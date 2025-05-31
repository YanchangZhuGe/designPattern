<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
    String contextPath = request.getContextPath();
    UserToken user = OMSMVCUtil.getUserToken(request);
    String projectInfoNo = user.getProjectInfoNo();
    String root_folderId = projectInfoNo;
    String projectName = user.getProjectName();
    String objectId = request.getParameter("objectId");
    if(projectName==null){
    	projectName = "";
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>修改任务书</title>
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
var objectId = "<%=objectId%>";

var module_name = top.frames("topFrame").selectedTag.childNodes[0].innerHTML;
var module_id = top.frames("topFrame").selectedTag.childNodes[0].menuId;

function forward()
{
	//window.location.href="index.html"
}

function loadData(){
	var retObj = jcdpCallService("TaskBookSrv", "getProjectInfo", "");
	
	if(retObj.project != null){
		document.getElementById("workarea_name").value = retObj.project.workarea;
		document.getElementById("team_name").value = retObj.project.team_name;
	}
	var retObj2 = jcdpCallService("TaskBookSrv", "getTaskBook", "objectId="+objectId);
	
	if(retObj2.taskbook != null){
		document.getElementById("line_group_id").value = retObj2.taskbook.line_group_id;
		var tasktype = retObj2.taskbook.task_type;
		jsSelectOption("work_type",tasktype);
		document.getElementById("task_name").value = retObj2.taskbook.name;
		document.getElementById("produce_date").value = retObj2.taskbook.produce_date;
		document.getElementById("receive_name").value = retObj2.taskbook.receive_name;
		document.getElementById("send_name").value = retObj2.taskbook.send_name;
		
		var folderId = retObj2.taskbook.folder_id;
		// folderId 不为空获取目录名
		if(folderId != null && folderId != ""){
			var retObj3 = jcdpCallService("DBDataSrv", "queryTableDatas", "tableName=bgp_doc_gms_file&option=file_id='"+folderId+"'");
			if(retObj3.datas != null){
				var folderName = retObj3.datas[0].file_name;
				document.getElementById("folder_id").value = folderId;
				document.getElementById("select_folder").value = folderName;
			}
		}
		var ucmId = retObj2.taskbook.ucm_id;
		if(ucmId != null && ucmId != ""){
			document.getElementById("oldUcmId").value = ucmId;
			document.getElementById("td_down").innerHTML += "&nbsp;<a href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucmId+"&emflag=0>下载</a>";
		}
	}
}

function jsSelectOption(objName, objItemValue) {
	var objSelect = document.getElementById(objName);
	for (var i = 0; i < objSelect.options.length; i++) {
		if (objSelect.options[i].value == objItemValue) {
			objSelect.options[i].selected = "selected";
			break;
		}
	}
}
	
function checkForm() {
	return true;
}
	
function toSave(){
	if (!checkForm()) return;
	var form = document.forms[0];
	form.action="<%=contextPath%>/pm/gpe/saveTaskBook.srq";
	form.submit();
}

function cancle(){
}

function settaskname(){
	var lineId = document.getElementById("line_group_id").value;
	var selectObj = document.getElementById("work_type");
	var index = selectObj.selectedIndex;
	var taskType = selectObj.options[index].text;
	var taskName = taskType + "任务书（" + lineId + "）";
	document.getElementById("task_name").value = taskName;
	document.getElementById("receive_name").value = taskType+"组";
	document.getElementById("send_name").value = "解释组";
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

<body onload="loadData()">
<form id="CheckForm" name="form1" action="" method="post" enctype="multipart/form-data">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height">
  	<tr>
   <td class="inquire_item4"><font color="red">*</font>&nbsp;线（束）号：</td>
   <td class="inquire_form4">
   <input type="hidden" name="object_id" value="<%=objectId%>"/>
   <input type="hidden" id="oldUcmId" name="oldUcmId" value=""/>
   <input id="line_group_id" name="line_group_id" type="text" value="" class="input_width" onchange="settaskname()"/>
   </td>
   <td class="inquire_item4">任务书类型：</td>
   <td class="inquire_form4">
		<select id="work_type" name="work_type" onchange="settaskname()">
			<option value="1">测量</option>
			<option value="2">表层调查（微测井）</option>
			<option value="3">表层调查（小折射）</option>
			<option value="4">钻井</option>
			<option value="5">放线</option>
			<option value="6">爆炸班</option>
			<option value="7">震源</option>
			<option value="8">仪器</option>
			<option value="9">气枪</option>
			
		</select>
   </td>
  </tr>
  <tr>
   <td class="inquire_item4">任务书名称：</td>
   <td class="inquire_form4"><input id="task_name" name="name" type="text" value=""class="input_width" readonly/></td>
    <td class="inquire_item4">工&nbsp;&nbsp;区：</td>
    <td class="inquire_form4">
    <input id="workarea_name" name="workarea_name" type="text" value="" class="input_width" readonly/></td>
  </tr>
   <tr>
  	<td class="inquire_item4">队&nbsp;&nbsp;号：</td>
    <td class="inquire_form4">
    	<input id="team_name" name="team_name" type="text" value="" class="input_width" readonly/></td>
    </td>
	 <td class="inquire_item4">下达日期：</td>
	 <td class="inquire_form4"><input id="produce_date" name="produce_date" type="text" value="" class="input_width" readonly/>
	 <img src="<%=contextPath%>/images/calendar.gif" id="tbutton3" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(produce_date,tbutton3);"/>
	 </td>
  </tr>
  <tr>
     <td class="inquire_item4">接收任务班组：</td>
     <td class="inquire_form4"><input id="receive_name" name="receive_name" type="text" value="" class="input_width"/></td>
     <td class="inquire_item4">下达任务班组：</td>
     <td class="inquire_form4" colspan="3"><input id="send_name" name="send_name" type="text" value="" class="input_width"/></td>
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
   	<span class="tj_btn"><a href="#" onclick="toSave()"></a></span>
    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
  </div>
</div></div>
</form>
</body>
</html>