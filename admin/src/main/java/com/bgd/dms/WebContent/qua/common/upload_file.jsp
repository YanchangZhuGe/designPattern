<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
    //获取当前的项目编号，作为树的最顶层
    String relationId = (String)request.getParameter("relationId");
    String index = (String)request.getParameter("index");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_info_no = user.getProjectInfoNo();
	
	String path = (String)request.getParameter("path");
	if(path==null ){
		path = "";
	}
	String file_abbr = (String)request.getParameter("file_abbr");
	if(file_abbr==null || file_abbr.trim().equals("")){
		file_abbr = "ZL";
	}
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>上传文档公共</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
</head>
<body>
<form name="form1" id="form1" enctype="multipart/form-data" method="post" action="<%=contextPath%>/qua/common/uploadFile.srq">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
  	<tr>
    	<td colspan="4" align="center">上传文档</td>
    </tr>
    <tr>
      	<td class="inquire_item4"><font color="red">*</font>选择目录：</td>
      	<td class="inquire_form4">
      		<input type="text" name="select_folder" class="input_width" readonly="readonly"/>
      		<img style="cursor: hand;" src="<%=contextPath%>/images/magnifier.gif" onclick="selectFolder()" />	
      		<input type="hidden" name="folder_id"/>
      	</td>
      	<td class="inquire_item4"><font color="red">*</font>文档编号：</td>
      	<td class="inquire_form4">
      	<input type="hidden" name="relation_id" value="<%=relationId%>"/>
      	<input type="hidden" name="index" value="<%=index%>"/>
      	<input type="text" name="doc_number" id="doc_number" class="input_width" />
      	</td>
    </tr>
    <tr>
    	<td class="inquire_item4">文档名称：</td>
      	<td class="inquire_form4"><input type="text" name="file_name" id="file_name" class="input_width"/></td>
      	<td class="inquire_item4">文档：</td>
      	<td class="inquire_form4"><input type="file" name="file" id="file" onchange="getFileInfo()" class="input_width"/></td>
    </tr>    
</table>
</div>
    <div id="oper_div">
        <auth:ListButton functionId="" css="tj_btn" event="onclick='refreshData()'"></auth:ListButton>
        <auth:ListButton functionId="" css="gb_btn" event="onclick='newClose()'"></auth:ListButton>
    </div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">
	cruConfig.contextPath = "<%=contextPath%>";	
	var nowDate = new Date();
	var project_no = '<%=project_info_no%>';
	var path = '<%=path%>';
	if(path==null || path ==''){
		var querySql = "select * from bgp_doc_gms_file t where t.bsflag ='0' and t.project_info_no ='<%=project_info_no%>' and t.file_abbr ='<%=file_abbr%>' and rownum =1";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj !=null && retObj.returnCode =='0' && retObj.datas !=null && retObj.datas[0] !=null){
			debugger;
			document.getElementsByName("select_folder")[0].value = retObj.datas[0].file_name ==null?"":retObj.datas[0].file_name;
			var folder_id = retObj.datas[0].file_id ==null?"":retObj.datas[0].file_id;
			document.getElementsByName("folder_id")[0].value = folder_id;
			generateFileNumber(folder_id);
		}else{
			var name = "";
			if('<%=file_abbr%>'=='KZJH'){
				name = "控制计划";
			}
			alert("项目文档目录中不存在“"+name+"”的目录，请添加目录缩写为“<%=file_abbr%>”的目录!");
		}
	}else{
		var querySql ="select f.* from bgp_doc_gms_file f where f.bsflag ='0' and f.is_file = '0' and f.file_abbr = '<%=file_abbr%>'"+
		" start with f.bsflag = '0' and f.parent_file_id is null and f.project_info_no is null and f.is_file = '0' and f.is_template is null"+
		" connect by prior f.file_id = f.parent_file_id";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj !=null && retObj.returnCode =='0' && retObj.datas !=null && retObj.datas[0] !=null){
			debugger;
			document.getElementsByName("select_folder")[0].value = retObj.datas[0].file_name ==null?"":retObj.datas[0].file_name;
			var folder_id = retObj.datas[0].file_id ==null?"":retObj.datas[0].file_id;
			document.getElementsByName("folder_id")[0].value = folder_id;
			generateFileNumber(folder_id);
		}else{
			var name = "";
			if('<%=file_abbr%>'=='XX'){
				name = "信息汇总";
			}else if('<%=file_abbr%>'=='tb'){
				name = "质量通报";
			}
			alert("公共目录中不存在“"+name+"”的目录，请添加目录缩写为“<%=file_abbr%>”的目录!");
		}
	}
	
	
	function generateFileNumber(folder_id){
		var fileNumber = "";
		var fileNumberFormat = "";
		var fileAbbr = "";
		var querySql = "Select n.file_number_value as file_number_format,b.file_abbr FROM bgp_doc_gms_file b join bgp_doc_file_number n on b.file_number_format = n.bgp_doc_file_number_id WHERE b.file_id = '"+folder_id+"' and b.bsflag='0' and b.is_file='0' and b.ucm_id is null";
		var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
		if(queryOrgRet.datas.length != 0){
			fileNumberFormat = queryOrgRet.datas[0].file_number_format; 
			fileAbbr = queryOrgRet.datas[0].file_abbr; 
		}
		if(fileNumberFormat != ""){
			var params = fileNumberFormat.split("_");
			fileNumber = fileNumber+params[0];
			for(var i=1;i<params.length;i++){
				var param = params[i];
				if(param == "[folder]"){
					if(fileAbbr != ""){
						fileNumber= fileNumber+"-"+fileAbbr;
					}
					continue;
				}
				if(param == "[year]"){
					fileNumber= fileNumber+"-"+getYearValue();
					continue;
				}
				if(param == "[month]"){
					fileNumber= fileNumber+getMonthValue();
					continue;
				}
				if(param == "[day]"){
					fileNumber= fileNumber+getDateValue();
					continue;
				}
			}
			
			if(params[params.length-1] != "year"&&params[params.length-1] != "month" && params[params.length-1] != "day"){
				var lastLength = params[params.length-1];
				var timeValue = getTimeValue()+"";
				var timeValueLength = timeValue.length;
				var lastStr = timeValue.substring(timeValueLength-4,timeValueLength);
				fileNumber = fileNumber + "-" + lastStr;
			}
			document.getElementById("doc_number").value = fileNumber;
		}	
	}
/* 	
	var module_name = top.frames("topFrame").selectedTag.childNodes[0].innerHTML;
	var module_id = top.frames("topFrame").selectedTag.childNodes[0].menuId;
	 */
	function cancel()
	{
		window.close();
	}
										
	function refreshData(){
		
		document.getElementById("form1").submit();
	}
	
	function checkForm(){ 	
	
		if (!isTextPropertyNotNull("doc_number", "文档编号")) {		
			document.form1.doc_number.focus();
			return false;	
		}
		return true;
	}	
	
	function selectFolder(){
		var folder_info={
	        fkValue:"",
	        value:""
	    };
		
		var path = '<%=path%>';
		if(path==null || path ==''){
			if(checkModuleID(module_id,project_no) == 0){
				window.showModalDialog('<%=contextPath%>/doc/common/select_folder_project.jsp?project_info_no=<%=project_info_no%>',folder_info);
			}else if(checkModuleID(module_id,project_no) == 1){
				window.showModalDialog('<%=contextPath%>/doc/common/select_folder.jsp?project_info_no=<%=project_info_no%>&moduleID='+module_id,folder_info);
			}
		}else{
			window.showModalDialog('<%=contextPath%>/doc/multiproject/select_folder_eps.jsp?moduleId='+module_id,folder_info);
		}

		document.getElementsByName("select_folder")[0].value = folder_info.value;
		document.getElementsByName("folder_id")[0].value = folder_info.fkValue;
		
		generateFileNumber(folder_info.fkValue);
	}
	
	function checkModuleID(moduleId,projectNo){
		var querySql = "Select b.* FROM bgp_doc_folder_module b WHERE b.module_id = '"+moduleId+"' and b.bsflag='0' and b.project_info_no ='"+projectNo+"'";
		var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
		if(queryOrgRet.datas.length == 0){
			return 0;
		}else{
			return 1;
		}		
	}
	function getFileInfo(){
		var file_path = document.getElementById("file").value;
		var docName = file_path.substring(file_path.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		document.getElementById("file_name").value = docTitle;
	}
</script>

</html>