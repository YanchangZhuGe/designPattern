<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
    String contextPath = request.getContextPath();
    UserToken user = OMSMVCUtil.getUserToken(request);
    String  objectId = request.getParameter("objectId");
    String projectInfoNo = user.getProjectInfoNo();
    String root_folderId = projectInfoNo;
    String projectName = user.getProjectName();
    if(projectName==null){
    	projectName = "";
    }
    String action = request.getParameter("action");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>修改请示报告</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/help.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/validator.js"></script>
<script>
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
var projectInfoNo = "<%=projectInfoNo%>";
var module_name = top.frames("topFrame").selectedTag.childNodes[0].innerHTML;
var module_id = top.frames("topFrame").selectedTag.childNodes[0].menuId;

function loadData(){
	var ids = "<%=objectId%>";
	if(ids!=''){ 
		// 加载当前行信息
		document.getElementById("object_id").value = ids;
		var resultObj = jcdpCallService("ConsultReportSrv", "getConsultReportById", "objectId="+ids);
		document.getElementById("reportName").value = resultObj.consultReport.report_name;
		document.getElementById("consultOrg").value = resultObj.consultReport.consult_org;
		document.getElementById("requestOrg").value = resultObj.consultReport.request_org;
		document.getElementById("consult_date").value = resultObj.consultReport.consult_date;
		document.getElementById("subjectMatter").value = resultObj.consultReport.subject_matter;
		document.getElementById("suggestionScheme").value = resultObj.consultReport.suggestion_scheme;
		
		var folderId = resultObj.consultReport.folder_id;
		// folderId 不为空获取目录名
		if(folderId != null && folderId != ""){
			var retObj3 = jcdpCallService("DBDataSrv", "queryTableDatas", "tableName=bgp_doc_gms_file&option=file_id='"+folderId+"'");
			if(retObj3.datas != null){
				var folderName = retObj3.datas[0].file_name;
				document.getElementById("folder_id").value = folderId;
				document.getElementById("select_folder").value = folderName;
			}
		}		
		var ucmId = resultObj.consultReport.ucm_id;
		if(ucmId != null && ucmId != ""){
			document.getElementById("oldUcmId").value = ucmId;
			document.getElementById("td_down").innerHTML += "&nbsp;<a href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucmId+"&emflag=0>下载</a>";
		}
   }
}
	
function forward()
{
	//window.location.href="index.html"
}
</script>
<script type="text/javascript">
function checkForm() {
	if (!isTextPropertyNotNull("reportName", "报告名称")) {
		document.form1.reportName.focus();
		return false;	
	}
	if (!isTextPropertyNotNull("consultOrg", "请示单位")) {
		document.form1.consultOrg.focus();
		return false;	
	}
	if (!isTextPropertyNotNull("requestOrg", "申请单位")) {
		document.form1.requestOrg.focus();
		return false;
	}
    if (!isTextPropertyNotNull("projectName", "项目名称")) {
		document.form1.projectName.focus();
		return false;
	}
	if (!isTextPropertyNotNull("subjectMatter", "请示事由")) {
		document.form1.subjectMatter.focus();
		return false;	
	}
    return true;
}
	
function toSave(){
	if (!checkForm()) return;
	var form = document.forms[0];
	form.action="<%=contextPath%>/pm/eps/saveConsultReport.srq";
	form.submit();
}

function cancle(){
}

function selectFolder(){
	var folder_info={
        fkValue:"",
		value:""
	};
	if(checkModuleID(module_id,projectInfoNo) == 0){
		window.showModalDialog('<%=contextPath%>/doc/common/select_folder_project.jsp?project_info_no=<%=root_folderId%>',folder_info);
	}else if(checkModuleID(module_id,projectInfoNo) == 1){
		window.showModalDialog('<%=contextPath%>/doc/common/select_folder.jsp?project_info_no=<%=root_folderId%>&moduleID='+module_id,folder_info);
	}
	document.getElementsByName("select_folder")[0].value = folder_info.value;
	document.getElementsByName("folder_id")[0].value = folder_info.fkValue;
	generateFileNumber(folder_info.fkValue);
}

function checkModuleID(moduleId,projectNo){
	var querySql = "Select * FROM bgp_doc_folder_module b WHERE b.module_id = '"+moduleId+"' and b.bsflag='0' and b.project_info_no ='"+projectNo+"'";
	var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
	if(queryOrgRet.datas.length == 0){
		return 0;
	}else{
		return 1;
	}
}
</script>
<link href="table.css" rel="stylesheet" type="text/css" />
</head>

<body onload="loadData();">
<form id="CheckForm" name="form1" enctype="multipart/form-data" action="" method="post" >
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height">
  	<tr>
   <td class="inquire_item4"><font color="red">*</font>&nbsp;报告名称：</td>
   <td class="inquire_form4" ><input id="object_id" name="object_id" type="hidden" value="" />
   <input type="hidden" id="oldUcmId" name="oldUcmId" value=""/>
   <input id="reportName" name="reportName" type="text" value="" class="input_width" />
   </td>
   <td class="inquire_item4"><font color="red">*</font>&nbsp;请示单位：</td>
   <td class="inquire_form4"><input id="consultOrg" name="consultOrg" type="text" value="" class="input_width" />
   </td>
  </tr>
  <tr>
   <td class="inquire_item4"><font color="red">*</font>&nbsp;批示单位：</td>
   <td class="inquire_form4"><input id="requestOrg" name="requestOrg" type="text" value=""class="input_width"/></td>
    <td class="inquire_item4">项目名称：</td>
    <td class="inquire_form4">
    <input id="projectId" name="projectId" type="hidden"  value="<%=projectInfoNo%>" class="input_width"/>
    <input id="projectName" name="projectName" type="text" value="<%=projectName%>" class="input_width" readonly/></td>
  </tr>
   <tr>
  	<td class="inquire_item4"><font color="red">*</font>&nbsp;日期：</td>
    <td class="inquire_form4">
	<input id="consult_date" name="consult_date" type="text" value="" class="input_width" readonly/>
    <img src="<%=contextPath%>/images/calendar.gif" id="tbutton3" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(consult_date,tbutton3);"/>
    </td>
	 <td class="inquire_item4"></td>
	 <td class="inquire_form4"></td>
  </tr>
  <tr>
   <td class="inquire_item4"><font color="red">*</font>&nbsp;请示事由：</td>
   <td class="inquire_form4" colspan="3"><textarea id="subjectMatter" name="subjectMatter" class="textarea"></textarea></td>
  </tr>
  <tr>
    <td class="inquire_item4">建议方案：</td>
    <td class="inquire_form4"  colspan="3"><textarea id="suggestionScheme" name="suggestionScheme" class="textarea"></textarea></td>
  </tr>
  <tr>
     <td class="inquire_item4">选择目录：</td>
     <td class="inquire_form4">
     	<input type="text" id="select_folder" name="select_folder" class="input_width" readonly="readonly"/>
      	<img style="cursor: hand;" src="<%=contextPath%>/images/magnifier.gif" onclick="selectFolder()" />	
      	<input type="hidden" id="folder_id" name="folder_id"/>
     </td>
     <td class="inquire_item4">文档：</td>
     <td class="inquire_form4" colspan="3" id="td_down">
     	<input type="file" name="doc_content" id="doc_content" onchange="getFileInfo()" class="input_width"/></div>
     </td>
  </tr>
</table>
  </div>
  <div id="oper_div">
  <%
  if(action!=null&&action.equals("1")){ 
	  %>
	  <span class="tj_btn"><a href="#" onclick="toSave()"></a></span>
	  <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
	  <%
  }else{  
  %>
   	
  <%} %> 	
    
  </div>
</div></div>
</form>
</body>
</html>