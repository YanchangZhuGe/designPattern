<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
    String contextPath = request.getContextPath();
    UserToken user = OMSMVCUtil.getUserToken(request);
    String projectInfoNo = user.getProjectInfoNo();
    String root_folderId = projectInfoNo;
    String projectName = user.getProjectName();
    String orgName=user.getOrgName();
    if(projectName==null){
    	projectName = "";
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>新增请示报告</title>
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
<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
var projectInfoNo = "<%=projectInfoNo%>";
var module_name = top.frames("topFrame").selectedTag.childNodes[0].innerHTML;
var module_id = top.frames("topFrame").selectedTag.childNodes[0].menuId;

function forward()
{
	//window.location.href="index.html"
}

function checkForm() {
	if (!isTextPropertyNotNull("reportName", "报告名称")) {
		document.form1.reportName.focus();
		return false;	
	}
	if (!isTextPropertyNotNull("consultOrg", "请示单位")) {
		document.form1.consultOrg.focus();
		return false;	
	}
	if (!isTextPropertyNotNull("requestOrg", "批示单位")) {
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
	if (!isTextPropertyNotNull("consult_date", "日期")) {
		document.form1.consult_date.focus();
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

<body>
<form id="CheckForm" name="form1" enctype="multipart/form-data" action="" method="post" >
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height">
  	<tr>
   <td class="inquire_item4"><font color="red">*</font>&nbsp;报告名称：</td>
   <td class="inquire_form4" colspan="3"><input name="reportName" type="text" value="" class="input_width" />
   </td>
   </tr>
  <tr>
   <td class="inquire_item4"><font color="red">*</font>&nbsp;请示单位：</td>
   <td class="inquire_form4"><input name="consultOrg" type="text" value="<%=orgName %>" class="input_width" /></td>
   <td class="inquire_item4"><font color="red">*</font>&nbsp;批示单位：</td>
   <td class="inquire_form4"><input name="requestOrg" type="text" value="大港物探处生产管理科"class="input_width"/></td>
  </tr>
   <tr>
   	<td class="inquire_item4">项目名称：</td>
    <td class="inquire_form4">
    <input name="projectId" type="hidden" value="<%=projectInfoNo%>" class="input_width"/>
    <input name="projectName" type="text" value="<%=projectName%>" class="input_width" readonly/></td>
  	<td class="inquire_item4"><font color="red">*</font>&nbsp;日期：</td>
    <td class="inquire_form4">
	<input name="consult_date" type="text" value="" class="input_width" readonly/>
    <img src="<%=contextPath%>/images/calendar.gif" id="tbutton3" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(consult_date,tbutton3);"/>
    </td>
  </tr>
  <tr>
   <td class="inquire_item4"><font color="red">*</font>&nbsp;请示事由：</td>
   <td class="inquire_form4" colspan="3"><textarea name="subjectMatter" class="textarea" cols="45" rows="5"></textarea></td>
  </tr>
  <tr>
    <td class="inquire_item4">建议方案：</td>
    <td class="inquire_form4"  colspan="3"><textarea name="suggestionScheme" class="textarea"></textarea></td>
  </tr>
  <tr>
     <td class="inquire_item4">选择目录：</td>
     <td class="inquire_form4">
     	<input type="text" name="select_folder" class="input_width" readonly="readonly"/>
      	<img style="cursor: hand;" src="<%=contextPath%>/images/magnifier.gif" onclick="selectFolder()" />	
      	<input type="hidden" name="folder_id"/>
     </td>
     <td class="inquire_item4">文档：</td>
     <td class="inquire_form4" colspan="3">
     	<input type="file" name="doc_content" id="doc_content" onchange="getFileInfo()" class="input_width"/>
     </td>
  </tr>
</table>
  </div>
  <div id="oper_div">
   	<span class="tj_btn"><a href="#" onclick="toSave()"></a></span>
    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
  </div>
</div></div>
</form>
<script type="text/javascript">
autoSelectFolder();
function autoSelectFolder(){
	var querySql1 = "select f.file_id,f.file_name from bgp_doc_gms_file f where f.bsflag = '0' and f.is_file <> '1' and f.file_abbr = 'BG' and f.project_info_no = '"+projectInfoNo+"'";
	var queryOrgRet1 = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql1);
	if(queryOrgRet1.datas!=null && queryOrgRet1.datas.length == 1){
		document.getElementsByName("select_folder")[0].value = queryOrgRet1.datas[0].file_name;
		document.getElementsByName("folder_id")[0].value =  queryOrgRet1.datas[0].file_id;
	}else{
		alert("没有生产任务书这个文件夹!");
		return;
	}
}
</script>
</body>
</html>