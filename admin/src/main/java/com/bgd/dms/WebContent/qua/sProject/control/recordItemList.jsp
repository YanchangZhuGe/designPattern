<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String projectInfoNo = user.getProjectInfoNo();
	if(projectInfoNo==null || projectInfoNo.trim().equals("")){
		projectInfoNo = "";
	}
	String projectName = user.getProjectName();
	if(projectName==null || projectName.trim().equals("")){
		projectName = "";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<style type="text/css" >
</style>
<script type="text/javascript" >
	var checked = false;
	function check(){
		var chk = document.getElementsByName("chk_entity_id");
		for(var i = 0; i < chk.length; i++){ 
			if(!checked){ 
				chk[i].checked = true; 
			}
			else{
				chk[i].checked = false;
			}
		} 
		if(checked){
			checked = false;
		}
		else{
			checked = true;
		}
	}
	function selectOrgHR(select_type , select_id , select_name){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgHR.jsp?select='+select_type,teamInfo);
	    if(teamInfo.fkValue!=""){
	        document.getElementById(select_id).value = teamInfo.fkValue;
	        document.getElementById(select_name).value = teamInfo.value;
	    }
	}
</script>
<title>列表页面</title>
</head>
<body style="background:#fff" >

	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						 	<td>&nbsp;</td>
						    <auth:ListButton functionId="F_QUA_CONTROL_001" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
						    <auth:ListButton functionId="F_QUA_CONTROL_001" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
						    <auth:ListButton functionId="F_QUA_CONTROL_001" css="sc" event="onclick='toDel()'" title="JCDP_btn_delete"></auth:ListButton>
						    <%-- <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton> --%>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>
			  <td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{record_id}' onclick=check(this)/>" >
			  	<input type='checkbox' name='chk_entity_id' value='' onclick='check(this)'/></td>
			  <td class="bt_info_even" autoOrder="1">序号</td> 
			  <td class="bt_info_odd" exp="{quality_type}">工序名称</td>
			  <td class="bt_info_even" exp="{record_type}">检查项类型</td>
			  <td class="bt_info_odd" exp="{unit_id}">机组号</td>
			  <td class="bt_info_even" exp="{status}">状态</td>
			  <td class="bt_info_odd" exp="{org_name}">整改单位</td>
			  <td class="bt_info_even" exp="{task_name}">作业</td>
			  <td class="bt_info_odd" exp="{project_name}">项目名称</td>
			</tr>
		</table>
	</div> 
	<div id="fenye_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
		  <tr>
		    <td align="right">第1/1页，共0条记录</td>
		    <td width="10">&nbsp;</td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_01.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_02.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_03.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_04.png" width="20" height="20" /></td>
		    <td width="50">到 
		      <label>
		        <input type="text" name="changePage" id="changePage" style="width:20px;" />
		      </label></td>
		    <td align="left"><img src="<%=contextPath %>/images/fenye_go.png" width="22" height="22" onclick="changePage()"/></td>
		  </tr>
		</table>
	</div>
	<div class="lashen" id="line"></div>
	<div id="tag-container_3" >
      <ul id="tags" class="tags">
        <li class="selectTag"><a href="#" onclick="getTab(this,1)">常用</a></li>
        <li><a href="#" onclick="getTab(this,2)" >附件</a></li>
        <li><a href="#" onclick="getTab(this,3)" >关联文档</a></li>
        <li><a href="#" onclick="getTab(this,4)" >备注</a></li>
        <li><a href="#" onclick="getTab(this,5)" >分类码</a></li>
      </ul>
    </div>
	<div id="tab_box" class="tab_box" style="overflow:hidden;">
		<div id="tab_box_content1" class="tab_box_content" >
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr align="right" >
			  	<td>&nbsp;</td>
			    <auth:ListButton functionId="F_QUA_CONTROL_002" css="tj" event="onclick='newSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
			  </tr>
			</table>
			<form action="" id="form0" name="form0" method="post" target="record">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		    		<input type="hidden" name="record_id" id="record_id" value="" />
		    		<input type="hidden" name="taskId" id="taskId" value="" />
		    		<input type="hidden" name="objectName" id="objectName" value="" />
		    		<input type="hidden" name="project_info_no" id="project_info_no" value="<%=projectInfoNo%>"/>
					<tr>
					    <td class="inquire_item6">项目名称:</td>
					    <td class="inquire_form6" ><input type="text" name="projectName" id="projectName" value="<%=projectName %>" class="input_width" disabled="disabled"/></td>
					    <td class="inquire_item6">作业名称:</td>
					   	<td class="inquire_form6"><input type="text" name="task_name" id="task_name" value="" class="input_width" disabled="disabled"/></td>
					    <td class="inquire_item6">机组号:</td>
					   	<td class="inquire_form6"><input type="text" name="unit_id" id="unit_id" value="" class="input_width" 
							onkeydown="javascript:return checkIfNum(event);" /></td>
						<input type="hidden" name="describe" id="describe" value="" class="input_width" />
					   	<!-- <td class="inquire_item6">检查总量:</td>
					   	<td class="inquire_form6"></td> -->
				  	</tr>
				  	<tr> 
					   	<td class="inquire_item6">工序名称:</td>
					    <td class="inquire_form6" ><select id="quality_type" name="quality_type" onchange="getRecordType()" class="select_width">
	    					</select></td> 
					    <td class="inquire_item6">检查项类型:</td>
					    <td class="inquire_form6" ><select id="record_type" name="record_type" class="select_width"></select>
					    </td> 
					    <td class="inquire_item6">状态:</td>
					   	<td class="inquire_form6"><select id="status" name="status" class="select_width">
					   			<option value="1">整改中</option>
					   			<option value="2">合格</option>
					   			<option value="3">整改合格</option>
					   			<option value="4">不合格</option>
					   		</select></td>
				  	</tr>
				  	<tr>
				  		<td class="inquire_item6">检查日期:</td>
					    <td class="inquire_form6" ><input type="text" name="check_date" id="check_date" value="" class="input_width" disabled="disabled"/>
					    <img width="16" height="16" id="cal_button6" style="cursor: hand;" 
	    					onmouseover="calDateSelector(check_date,cal_button6);" 
	    					src="<%=contextPath %>/images/calendar.gif" /></td>
					    <td class="inquire_item6">要求完成日期:</td>
					    <td class="inquire_form6" ><input type="text" name="complete_date" id="complete_date" value="" class="input_width" disabled="disabled"/>
					    	<img width="16" height="16" id="cal_button7" style="cursor: hand;" 
					    		onmouseover="calDateSelector(complete_date,cal_button7);" 
					    		src="<%=contextPath %>/images/calendar.gif" /></td>
				  		<td class="inquire_item6">整改单位:</td>
					    <td class="inquire_form6" ><input type="hidden" name="org_id" id="org_id" value="" class="input_width" />
					    	<input name="org_name" id="org_name" type="text" class="input_width" value="" disabled="disabled"/>
							<img onclick="selectOrgHR('orgId','org_id','org_name')" src="<%=contextPath %>/images/images/tree_12.png" width="16" height="16" style="cursor: hand;" /></td> 
					</tr>
				  	<tr> 	
					  	<td class="inquire_item6">检查人:</td>
					    <td class="inquire_form6" ><input type="hidden" name="checker" id="checker" value="" class="input_width" />
					    	<input name="checker_name" id="checker_name" type="text" class="input_width" value="" disabled="disabled"/>
							<img onclick="selectOrgHR('userId','checker','checker_name')" src="<%=contextPath %>/images/images/tree_12.png" width="16" height="16" style="cursor: hand;" /></td> 
				  </tr>
				</table>
			</form> 
		</div>
		<div id="tab_box_content2" class="tab_box_content" style="display:none;"> 
		</div>
		<div id="tab_box_content3" class="tab_box_content" style="display:none;">
			<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
			</iframe>
		</div>
		<div id="tab_box_content4" class="tab_box_content" style="display:none;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				  <tr>
				    <td class="inquire_item4">备注:</td>
				    <td class="inquire_form4">
						<textarea rows="4" cols="10" id="notes" name="notes" class="textarea"></textarea></td>
				  </tr>
			</table>
		</div>
		<div id="tab_box_content5" class="tab_box_content" style="display:none;">
			<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
		</div>
	</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "QualityItemsSrv";
	cruConfig.queryOp = "getQualityItems"; 
	var object_id = '';
	var id = '';
	var name ='';
	var rowIndex = 0;
	function getQualityType(objectId){
		var retObj = jcdpCallService("QualityItemsSrv", "getQualityType", "qualityType="+objectId);
		var selObj = document.getElementById("quality_type");
		if(retObj!=null){
			if(selObj!=null){
				for(var i=0;selObj.options[i]!=null;){
					selObj.options[i] = null;
				}
				for(var i=0;retObj.qualityType[i]!=null;i++){
					selObj.options[i] = 
						new Option(retObj.qualityType[i].label,retObj.qualityType[i].value);
				}
			}
		}
		getRecordType();
	}
	function getRecordType(){
		var value = document.getElementById("quality_type").options.value;
		if(value!=null &&value!='0'){
			var retObj = jcdpCallService("QualityItemsSrv", "getRecordType", "qualityType="+value);
			var selObj = document.getElementById("record_type");
			for(var i=0;selObj.options[i]!=null;){
				selObj.options[i] = null;
			}
			for(var i=0;retObj.recordType[i]!=null;i++){
				selObj.options[i] = 
					new Option(retObj.recordType[i].codingName,retObj.recordType[i].codingCodeId);
			}
		}
		else{
			var selObj = document.getElementById("record_type");
			for(var i=0;selObj.options[i]!=null;){
				selObj.options[i] = null;
			}
		}
	}
	function refreshCodeData(taskId , taskName ,objectId){
		var project = '<%=projectInfoNo%>';
		if(project ==null || project=='null' || project ==''){
			alert("请选择项目");
		}
		object_id = objectId;
		id = taskId;
		name = taskName;
		if(taskId!=null && taskId!=''){
			document.getElementById("taskId").value = taskId;
			document.getElementById("task_name").value = taskName;
			document.getElementById("objectName").value = objectId;
		}
		else{
			id = document.getElementById("taskId").value ;
			name = document.getElementById("task_name").value ;
			object_id = document.getElementById("objectName").value ;
		}
		cruConfig.submitStr = "taskId="+id+"&task_name="+name;	
		queryData(1);
		getQualityType(object_id);
		getRecordType();
	}
	refreshCodeData('','','');
	/* 输入的是否是数字 */
	function checkIfNum(event){
		if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8){
			return true;
		}
		else{
			return false;
		}
	}
	/* 详细信息 */
	function loadDataDetail(record_id){
		var obj = event.srcElement; 
    	if(obj.tagName.toLowerCase() == "td"){   
    		var   tr   =  obj.parentNode ;
    		tr.cells[0].firstChild.checked = true;
    	} 
		document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+record_id;
		document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=7&relationId="+record_id;
		var retObj = jcdpCallService("QualityItemsSrv","getQualityItemsDetail", "recordId=" + record_id);
		document.getElementById("record_id").value = record_id;
		document.getElementById("taskId").value = id;
		document.getElementById("task_name").value = name;
		document.getElementById("projectName").value = retObj.qualityItemDetail.projectName;
		document.getElementById("checker").value = retObj.qualityItemDetail.checker;
		document.getElementById("checker_name").value = retObj.qualityItemDetail.checkerName;
		document.getElementById("check_date").value = retObj.qualityItemDetail.checkDate;
		document.getElementById("complete_date").value = retObj.qualityItemDetail.completeDate;
		document.getElementById("unit_id").value = retObj.qualityItemDetail.unitId;
		document.getElementById("org_id").value = retObj.qualityItemDetail.orgId;
		document.getElementById("org_name").value = retObj.qualityItemDetail.orgName;
		document.getElementById("notes").value = retObj.qualityItemDetail.notes;
		document.getElementById("describe").value = retObj.qualityItemDetail.describe;
		var qualityType = retObj.qualityItemDetail.qualityType;
		var quaObj = document.getElementById("quality_type");
		for (i = 0; i < quaObj.options.length; i++) {
			if (quaObj.options[i].value == qualityType) {
				quaObj.options[i].selected = true;
				break;
			}
		}
		getRecordType();
		var recordType = retObj.qualityItemDetail.recordType;
		var selObj = document.getElementById("record_type");
		for (i = 0; i < selObj.options.length; i++) {
			if (selObj.options[i].value == recordType) {
				selObj.options[i].selected = true;
				break;
			}
		}
		var status = retObj.qualityItemDetail.status;
		var statObj = document.getElementById("status");
		for (i = 0; i < statObj.options.length; i++) {
			if (statObj.options[i].value == status) {
				statObj.options[i].selected = true;
				break;
			}
		}
	}
	/* 修改 */
	function newSubmit() {
		var obj = document.getElementById("record_id").value;
		var submitStr = "record_id="+obj;
		obj = document.getElementById("taskId").value;
		submitStr = submitStr + "&task_id=" + obj;
		obj = document.getElementById("task_name").value;
		submitStr = submitStr + "&task_name=" + obj;
		obj = document.getElementById("status").value;
		submitStr = submitStr + "&status=" + obj;
		obj = document.getElementById("quality_type").value;
		submitStr = submitStr + "&quality_type=" + obj;
		obj = document.getElementById("record_type").value;
		submitStr = submitStr + "&record_type=" + obj;
		obj = document.getElementById("check_date").value;
		submitStr = submitStr + "&check_date=" + obj;
		obj = document.getElementById("complete_date").value;
		submitStr = submitStr + "&complete_date=" + obj;
		obj = document.getElementById("checker").value;
		submitStr = submitStr + "&checker=" + obj;
		obj = document.getElementById("org_id").value;
		submitStr = submitStr + "&org_id=" + obj;
		obj = document.getElementById("unit_id").value;
		submitStr = submitStr + "&unit_id=" + obj;
		obj = document.getElementById("notes").value;
		submitStr = submitStr + "&notes=" + obj;
		obj = document.getElementById("describe").value;
		submitStr = submitStr + "&describe=" + obj;
		var retObj = jcdpCallService("QualityItemsSrv","editQualityItems", submitStr);
		refreshCodeData(id,name,object_id);
	}
	var selectedTag=document.getElementsByTagName("li")[0];
	function getTab(obj,index) {  
		if(selectedTag!=null){
			selectedTag.className ="";
		}
		selectedTag = obj.parentElement;
		selectedTag.className ="selectTag";
		var showContent = 'tab_box_content'+index;
	
		for(var i=1; j=document.getElementById("tab_box_content"+i); i++){
			j.style.display = "none";
		}
		document.getElementById(showContent).style.display = "block";
	}
	function toAdd() {
		if(id==null || id==""){
			alert("请选择一项作业");
			return;
		}
		popWindow("<%=contextPath%>/qua/sProject/control/recordEdit.jsp?task_id="+id+"&task_name="+name+"&object_id="+object_id );
	}
	function toEdit() {
		
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var recordId = '';
		for (var i = 0;i< objLen ;i++){   
		    if (obj [i].checked==true) { 
		      	recordId=obj [i].value;
		      	var text = '你确定要修改第'+i+'行吗?';
				if(i!=rowIndex && window.confirm(text) ){
					popWindow("<%=contextPath%>/qua/sProject/control/recordEdit.jsp?record_id="+recordId+"&task_id="+id+"&task_name="+name+"&object_id="+object_id );
					return;
				}
		  	}
		} 
		alert("请选择修改的记录!");
	}
	function toDel() {
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var recordId = '';
		var dConfirm = false;
		for (var i = 0;i< objLen;i++){   
			if (obj [i].checked==true) { 
				recordId=obj [i].value;
				var text = '你确定要删除第'+i+'行吗?';
				if(dConfirm || window.confirm(text)){
			    	dConfirm = true;
			    	 var retObj = jcdpCallService("QualityItemsSrv","deleteRecord", "record_id="+recordId);
				}
			}   
		} 
		if(dConfirm == false){
			alert("请选择删除的记录!")
		}
		
	}
	function frameSize(){
		setTabBoxHeight();
	}
	frameSize();
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	})	

	$(document).ready(lashen);
</script>

</body>
</html>
