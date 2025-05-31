<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String project = user.getProjectName();
	if(project == null ){
		project = "";
	}
	String project_type = user.getProjectType();
	if(project_type!=null && project_type.trim().equals("5000100004000000002")){
		project_type = "5000100004000000010";
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
<title>列表页面</title>
</head>
<body style="background:#fff" >
	<div id=tag-container_3>
      <ul id=tags class=tags>
        <li class="selectTag"><a href="#" onclick="getTab(this,0)">常用</a></li>
        <!-- <li><a href="#" onclick="getTab(this,1)" >备注</a></li>
        <li><a href="#" onclick="getTab(this,1)" >附件</a></li>
        <li><a href="#" onclick="getTab(this,2)" >关联文档</a></li>
        
        <li><a href="#" onclick="getTab(this,4)" >分类码</a></li> -->
      </ul>
    </div>
	<div id="tab_box" class="tab_box">
		<div id="tab_box_content0" class="tab_box_content">
		   <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr align="right">
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="F_QUA_PLAN_001" css="tj" event="onclick='savePlan()'" title="JCDP_btn_submit"></auth:ListButton>
			  </tr>
			</table> 
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				<tr>
				  	<input type="hidden" id="qua_plan_id" name="qua_plan_id" value="" class="input_width" />
				    <input type="hidden" id="taskId" name="taskId" value="" class="input_width" />
				    <td class="inquire_item4">项目名称:</td>
				    <td class="inquire_form4" ><input type="text" id="project" name="project" value="<%=project%>" readonly="readonly"  class="input_width"/></td> 
				  	<td class="inquire_item4">工序/作业名称:</td>
				    <td class="inquire_form4" ><input type="text" id="name" name="name" value="" disabled="disabled" class="input_width"/></td>
			  	</tr>
			  	<tr> 	
				  	<td class="inquire_item4">计划开始:</td>
				    <td class="inquire_form4" ><input type="text" id="PlannedStartDate" name="PlannedStartDate" value="" disabled="disabled" class="input_width"/></td> 
				  	<td class="inquire_item4">计划结束:</td>
				    <td class="inquire_form4" ><input type="text" id="PlannedEndDate" name="PlannedEndDate" value="" disabled="disabled" class="input_width"/></td> 
			  	</tr>
			  	<tr> 
				    <td class="inquire_item4">责任人:</td>
				    <td class="inquire_form4" ><input type="text" id="duty_person" name="duty_person" value="" class="input_width"/></td>
				    <td class="inquire_item4">检查人:</td>
				    <td class="inquire_form4" ><input type="text" id="check_person" name="check_person" value="" class="input_width"/></td>
				</tr>
				<tr> 
				 	<td class="inquire_item4">检查量:</td>
				    <td class="inquire_form4" colspan="3">
						<input type="text" id="notes" name="notes" class="input_width" value=""/></td>
				</tr>
				<tr>
				 	<td class="inquire_item4">质量检查项:</td>
				    <td class="inquire_form4" colspan="3">
						<input type="text"  id="setting" name="setting" class="input_width" /></td>
				</tr>
			</table>
		</div>
		<div id="tab_box_content1" class="tab_box_content" style="display: none">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr align="right">
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="tj" event="onclick='savePlan()'" title="JCDP_btn_submit"></auth:ListButton>
			  </tr>
			</table> 
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				 
			</table>
		</div>
	</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	var project_type =  "<%=project_type%>";
	function refreshCodeData(taskId ,name ,StartDate ,EndDate ,PlannedStartDate ,PlannedEndDate ){
		var projectName = '<%=project%>';
		if(projectName ==''){
			alert("请选择项目");
			return;
		}
		if( taskId!=null && taskId!=''){
			var relationId = projectName + ':' + taskId;
			//document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=7&relationId="+relationId;
		}
		document.getElementById("taskId").value = taskId;
		document.getElementById("name").value = name;
		document.getElementById("PlannedStartDate").value = PlannedStartDate;
		document.getElementById("PlannedEndDate").value = PlannedEndDate;
		var submitStr = "object_id="+taskId+"&name="+name;
		var retObj = jcdpCallService("QualityItemsSrv","getDutyPerson", submitStr);
		if(retObj.returnCode=='0' ){
			if(retObj.dutyPerson!=null){
				document.getElementById("qua_plan_id").value = retObj.dutyPerson.qua_plan_id;
				document.getElementById("duty_person").value = retObj.dutyPerson.duty_person;
				document.getElementById("check_person").value = retObj.dutyPerson.check_person;
				document.getElementById("notes").value = retObj.dutyPerson.notes;
			}else{
				document.getElementById("qua_plan_id").value = '';
				document.getElementById("duty_person").value = '';
				document.getElementById("check_person").value = '';
				document.getElementById("notes").value = '';
			}
			if(retObj.setting!=null && name!=''){
				var list = retObj.setting;
				debugger;
				var setting = '';
				for(var i=0;i<list.length;i++){
					var j = i -(-1);
					if(setting ==''){
						if(project_type!=null && project_type =='5000100004000000009'){
							setting = list[i].coding_name +'; ';
						}else{
							setting = j +'、'+list[i].coding_name +'; ';
						}
						
					}else{
						if(project_type!=null && project_type =='5000100004000000009'){
							setting = setting + list[i].coding_name +'; ';
						}else{
							setting = setting + j +'、'+list[i].coding_name +'; ';
						}
						
					}
					
				}
				document.getElementById("setting").value = setting;
			}else{
				document.getElementById("setting").value = '';
			}
		}
	}
	//refreshCodeData('','','','','','');
	function savePlan(){
		var note = document.getElementById("notes").value;
		var duty_person = document.getElementById("duty_person").value ;
		var check_person = document.getElementById("check_person").value ;
		var taskId = document.getElementById("taskId").value ;
		var name = document.getElementById("name").value ;
		var setting = document.getElementById("setting").value ;
		var qua_plan_id = document.getElementById("qua_plan_id").value;
		var submitStr = "qua_plan_id="+qua_plan_id+"&notes="+note+"&duty_person="+duty_person+"&check_person="+check_person+"&object_id="+taskId+"&object_name="+name;
		if(taskId==null || taskId==""){
			alert("请选择一项工序");
			return;
		}
		if(project_type!=null && project_type =='5000100004000000009'){
			submitStr = submitStr + "&setting="+setting;
		}
		var retObj = jcdpCallService("QualityItemsSrv","savePlan", submitStr);
		
		parent.mainTopframe.refreshTree();
		refreshCodeData('','','','','','');
		
	}
	/* function keyUp(){
		var keycode = event.keyCode;
		if(keycode!=null && keycode=='8'){
			return;
		}
		var note = document.getElementById("notes").value;
		if(note!=null && ""==note){
			document.getElementById("notes").value = "填写检查人名字，为必填项";
		}
		note = note.replace("填写检查人名字，为必填项","");
		document.getElementById("notes").value = note;
	}
	function mouseDown(){
		var note = document.getElementById("notes").value;
		if(note!=null && "填写检查人名字，为必填项"==note){
			document.getElementById("notes").value = "";
		}
	}
	function mouseOut(){
		var note = document.getElementById("notes").value;
		if(note!=null && ""==note){
			document.getElementById("notes").value = "填写检查人名字，为必填项";
		}
	} */
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
	var selectedTag=document.getElementsByTagName("li")[0];
	function getTab(obj,index) {  
		if(selectedTag!=null){
			selectedTag.className ="";
		}
		selectedTag = obj.parentElement;
		selectedTag.className ="selectTag";
		var showContent = 'tab_box_content'+index;
	
		for(i=0; j=document.getElementById("tab_box_content"+i); i++){
			j.style.display = "none";
		}
		document.getElementById(showContent).style.display = "block";
	}
	function frameSize(){
		setTabBoxHeight();
	}
	frameSize(); 
</script>

</body>
</html>
