<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.net.URLDecoder" %>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userId = (user==null)?"":user.getEmpId();
    String projectName = user.getProjectName();
    String creatorName = user.getUserName();
    String project_info_no = user.getProjectInfoNo();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
	String file_id = request.getParameter("file_id");
	String folder_id = request.getParameter("folder_id");

	
	String business_type = request.getParameter("business_type");
	String business_info = request.getParameter("business_info");
	if(business_info != ""){
		business_info = URLDecoder.decode(business_info,"UTF-8");
		
	}


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<!--Remark JavaScript定义-->
<script language="javaScript">

	
cruConfig.contextPath = "<%=contextPath%>";

function save(){
	if('<%=file_id%>'==""){
		if (!checkForm()) return;
	}
	var form = document.getElementById("CheckForm");
	form.action = "<%=contextPath%>/doc/commonSaveOrUpdateFile.srq";
	form.submit();

	//var ctt = top.frames('list');
	//ctt.location.reload();
	newClose();
}

function checkForm(){
	if (!isTextPropertyNotNull("file", "文档")) return false;	
	//if (!isLimitB100("title","标题")) return false;  
	///if (!isLimitB20("writer","参加人员")) return false; 
	//if (!isLimitB20("leader","负责人")) return false;
	return true;
}
function view_doc(file_id){
	if(file_id != ""){
		var retObj = jcdpCallService("ucmSrv", "getDocInfo", "ucmid="+file_id);
		var fileExtension = retObj.docInfoMap.dWebExtension;
		window.open('<%=contextPath %>/doc/onlineview/view_doc.jsp?ucmId='+file_id+'&fileExt='+fileExtension);
	}else{
    	alert("该条记录没有文档");
    	return;
	}
		
}
function refreshData(){
	
	if('<%=file_id%>'!=""){
		var str="select p.PROJECT_NAME,f.FILE_ID,f.FILE_NAME,f.CREATE_DATE,f.MODIFI_DATE,f.PARENT_FILE_ID,f.UCM_ID,f.PROJECT_INFO_NO from BGP_DOC_GMS_FILE f left join GP_TASK_PROJECT p on p.PROJECT_INFO_NO=f.PARENT_FILE_ID and p.BSFLAG='0' where f.BSFLAG='0' and f.IS_FILE='1' and f.FILE_ID='<%=file_id%>'"
		var detailRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=1000');
		var retObj = detailRet.datas;
		//$("#project_name").val(retObj[0].project_name);
		//$("#creator_name").val(retObj[0].creator_name);
		$("#file_id").val(retObj[0].file_id);
		$("#ucmId").val(retObj[0].ucm_id);
		$("#fileName").val(retObj[0].file_name);
		
		
		$("#downfile").html("<a onclick=\"view_doc('"+retObj[0].file_id+"')\"><font color='blue'>"+retObj[0].file_name+"</font></a>");
		$("#fileUrl").html("<input onclick=\"window.location ='<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+retObj[0].ucm_id+"';\" type=\"button\" value=\"下载\" />");		  

	}
}

</script>
</head>
<body onload="refreshData();">
	<form id="CheckForm" action="" method="post" target="list" enctype="multipart/form-data">
	<input type="hidden" id="file_id" name="file_id" value="<%=file_id %>"/>
	<input type="hidden" id="ucmId" name="ucmId" value=""/>
	<input type="hidden" id="fileName" name="fileName" value=""/>
	
	<input type="hidden" id="business_type" name="business_type" value="<%=business_type %>"/>
	<input type="hidden" id="business_info" name="business_info" value="<%=business_info %>"/>
	
			<div id="new_table_box_content">
				<div id="new_table_box_bg" >
					<div id="tab_box" class="tab_box">
							<table  id="tableDoc"  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item4">项目名称：</td>
									<td class="inquire_form4"><input type="text" readonly="readonly" id="project_name" name="project_name" value="<%=projectName %>" class="input_width"/></td>
									<td class="inquire_item4">创建人：</td>
									<td class="inquire_form4"><input type="text" readonly="readonly" id="creator_name" name="creator_name" value="<%=creatorName %>" class="input_width"/></td>

								</tr>
								<tr>
								     <td class="inquire_item4">存放目录：</td>
								     <td class="inquire_form4">
								     	<input type="text" name="select_folder" class="input_width" readonly="readonly"/>
								     	<!--  
								      	<img style="cursor: hand;" src="<%=contextPath%>/images/magnifier.gif" onclick="selectFolder()" />	
								      	-->
								      	<input type="hidden" id="folder_id" name="folder_id" value="<%=folder_id %>"/>
								     </td>
									<td class="inquire_item4">上传文档：</td>
									<td colspan="2">
										<input type="file" name="file" id="file" class="input_width" onchange="clearOldFileName()"/>
										<input id="UCM_ID" name="UCM_ID" value="" type="hidden"/></td>
									<td class="inquire_form4"></td>
								</tr>
								<tr>
								     <td class="inquire_item4"></td>
								     <td class="inquire_form4"> </td>
									<td class="inquire_item4"></td>
									<td colspan="2">
					    				<span id="downfile"></span> <span id="fileUrl"></span> </td>
									<td class="inquire_form4"></td>
								</tr>
								 
							</table>
						</div>
					</div>
					<div id="oper_div">
						<span class="tj_btn"><a href="#" onclick="save()"></a>
						</span> <span class="gb_btn"><a href="#" onclick="newClose()"></a>
						</span>
					</div>
				</div>
	</form>
</body>
<script language="javaScript">
function clearOldFileName(){
	$("#downfile").html("");
	$("#fileUrl").html("");		  

}

autoSelectFolder();
function autoSelectFolder(){
	var querySql1 = "select f.file_id,f.file_name from bgp_doc_gms_file f where f.bsflag = '0' and f.is_file <> '1' and f.file_abbr = '<%=folder_id%>' and f.project_info_no = '<%=project_info_no%>'";
	var queryOrgRet1 = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql1);
	if(queryOrgRet1.datas!=null && queryOrgRet1.datas.length == 1){
		document.getElementsByName("select_folder")[0].value = queryOrgRet1.datas[0].file_name;
		//document.getElementsByName("folder_id")[0].value =  queryOrgRet1.datas[0].file_id;
	}else{
		document.getElementsByName("select_folder")[0].value = "请先在文档管理中创建相应文件夹";
		document.getElementsByName("select_folder")[0].style.color ='red';
		
		alert("请先在文档管理中创建相应文件夹!");
		return;
	}
}

</script>
</html>
