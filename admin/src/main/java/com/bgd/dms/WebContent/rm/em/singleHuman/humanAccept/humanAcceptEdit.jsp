<%@page import="java.util.Map"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.List"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubjectionId = user.getOrgSubjectionId();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	List humanMap = respMsg.getMsgElements("datas");
	String projectInfoNo = respMsg.getValue("projectInfoNo");
	String paramsType = respMsg.getValue("paramsType");
	
	String projectType = user.getProjectType();	

	int length = 0;
	if(humanMap != null && humanMap.size()>0){
		length = humanMap.size();
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
  <link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
  <link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
  <link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
  <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

 <title>项目页面</title> 
 </head> 
 
 <body style="background:#fff;overflow-y:auto" onload="refreshData()">
 <form id="CheckForm" action="" method="post" target="list" enctype="multipart/form-data">
 	<div id="oper_div" align="center">
 		<span class="yd"><a href="#" onclick="copyEsimiDate()"></a></span>
    </div>
 <div id="list_table">
	<div id="table_box" >
	  <table width="99%" border="0" cellspacing="0" cellpadding="0"  id="queryRetTable">		
	     <tr>
	      <td class="bt_info_odd" width="3%">序号</td>
	      <td class="bt_info_even" width="6%">员工编号</td>
	      <td class="bt_info_odd" width="6%">员工姓名</td>
	      <td class="bt_info_even" width="6%">班组</td>
	      <td class="bt_info_odd" width="6%">岗位</td>
	      <td class="bt_info_even" width="6%">预计进入项目时间</td>
	      <td class="bt_info_odd" width="6%">预计离开项目时间</td>
	      <td class="bt_info_even" width="6%">预计天数</td>
	      <td class="bt_info_odd" width="12%">实际进入项目时间 
	      <input type="hidden" id="equipmentSize" name="equipmentSize" value="<%=length%>" />
	      <input type="hidden" id="project_info_no" name="project_info_no" value="<%=projectInfoNo%>" /> 
	      <input type="hidden" id="params_type" name="params_type" value="<%=paramsType%>" />
	      </td>
	     </tr> 		
	<% 	if(humanMap != null && humanMap.size()>0){
  				for(int i = 0;i < humanMap.size(); i++){
  					String className = "";
  					if (i % 2 == 0) {
  						className = "odd_";
  					} else {
  						className = "even_";
  					}
  					MsgElement msg = (MsgElement)humanMap.get(i);
  					Map record = msg.toMap(); 
       %>
    <tr>
   	 <td class="<%=className%>odd" ><%=i+1%>
   	 <input type="hidden" name="fy<%=i%>relationNo" id="fy<%=i%>relationNo" value=""/>		
   	 <input type="hidden" name="fy<%=i%>spare2" id="fy<%=i%>spare2" value="<%=record.get("spare2") != null ? record.get("spare2"):""%>"/>		
   	 <input type="hidden" name="fy<%=i%>humanDetailNo" id="fy<%=i%>humanDetailNo" value="<%=record.get("human_detail_no")%>"/>		
   	 <input type="hidden" name="fy<%=i%>employeeHrId" id="fy<%=i%>employeeHrId" value="<%=record.get("employee_hr_id")%>"/>	
   	 <input type="hidden" name="fy<%=i%>reorgId" id="fy<%=i%>reorgId" value="<%=(record.get("reorg_id") == null || "".equals(record.get("reorg_id")))?record.get("org_id"):record.get("reorg_id")%>"/>
   	 <input type="hidden" name="fy<%=i%>projectInfoNo" id="fy<%=i%>projectInfoNo" value="<%=record.get("project_info_no")%>"/></td>			
	 <td class="<%=className%>even" ><%= record.get("employee_cd") != null ? record.get("employee_cd"):"" %>&nbsp;</td>	
	 <td class="<%=className%>odd" ><%= record.get("employee_name") != null ? record.get("employee_name"):"" %><input type="hidden" name="fy<%=i%>employeeId" id="fy<%=i%>employeeId" value="<%=record.get("employee_id")%>"/>&nbsp;</td>	
	 <td class="<%=className%>even"><%= record.get("team_name") != null ? record.get("team_name"):"" %><input type="hidden" name="fy<%=i%>team" id="fy<%=i%>team" value="<%=record.get("team")%>"/>&nbsp;</td>
	 <td class="<%=className%>odd" ><%= record.get("work_post_name") != null ? record.get("work_post_name"):"" %><input type="hidden" name="fy<%=i%>workPost" id="fy<%=i%>workPost" value="<%=record.get("work_post")%>"/>&nbsp;</td>
	 <td class="<%=className%>even"><%= record.get("plan_start_date") != null ? record.get("plan_start_date"):"" %><input type="hidden" name="fy<%=i%>planStartDate" id="fy<%=i%>planStartDate" value="<%=record.get("plan_start_date")%>"/>&nbsp;</td>
	 <td class="<%=className%>odd" ><%= record.get("plan_end_date") != null ? record.get("plan_end_date"):"" %><input type="hidden" name="fy<%=i%>planEndDate" id="fy<%=i%>planEndDate" value="<%=record.get("plan_end_date")%>"/>&nbsp;</td>
	 <td class="<%=className%>even"><%= record.get("days") != null ? record.get("days"):"" %>&nbsp;</td>
	 <td class="<%=className%>odd" >
	 <input type="text" name="fy<%=i%>actualStartDate" id="fy<%=i%>actualStartDate" value="<%=(record.get("actual_start_date") != null && !"".equals(record.get("actual_start_date"))) ? record.get("actual_start_date"):record.get("plan_start_date") != null ? record.get("plan_start_date"):""%>" readonly="readonly"/>
	 <img src="<%=contextPath%>/images/calendar.gif" id="tributton40<%=i%>" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector('fy<%=i%>actualStartDate',tributton40<%=i%>);" />
	 </td>
	 </tr>
       <% } 
  				}%>
	  </table>
	</div>
	
	<div id="oper_div" align="center"  >
     	<span class="zj" id="spDiv" style="display:none;" ><a href="#" onclick="selectTree()"></a></span>
    </div>
	<div>
	<table id="taskTable" width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:2px;">
    	<tr class="bt_info">
    	    <td>序号</td>
            <td>作业名称</td>
            <td>计划开始时间</td>		
            <td>计划结束时间</td>
            <td>原定工期</td>			
            <td>操作<input type="hidden" id="lineNum" name="lineNum" value="0"/>
            <input type="hidden" id="lineNumJ" name="lineNumJ" value="0"/>
            </td>			
        </tr>
    </table>
    </div>
    <div id="oper_div">
        <span class="bc_btn"><a href="#" onclick="save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</div>
</form>
</body>
 
<script type="text/javascript">
function copyEsimiDate(){
	
	var infoSize = document.getElementById("equipmentSize").value;
	var date1 = document.getElementById("fy0actualStartDate").value;
	for(var i=0;i<infoSize;i++){
		document.getElementById("fy"+i+"actualStartDate").value=date1;
	}
}

function save(){
	if(checkForm()){
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/rm/em/toHumanAcceptEdit.srq";
		form.submit();
		newClose();
	}
}
var projectTypes="<%=projectType%>";
if(projectTypes !="5000100004000000008"  && projectTypes !="5000100004000000009" ){
	document.getElementById("spDiv").style.display="block";
} 

function checkForm(){
	var deviceCount = document.getElementById("equipmentSize").value;
	
	for(var i=0;i<deviceCount;i++){		
		if(!notNullForCheck("fy"+i+"actualStartDate","实际进入项目时间")) return false;
	}
	
	var rowNum = document.getElementById("lineNumJ").value;
	
	if(projectTypes !="5000100004000000008" && projectTypes !="5000100004000000009" ){
		if(rowNum == "0"){
			alert("请分配一条作业");
			return false;
		}
		
	}
  
	
	return true;
} 

function notNullForCheck(filedName,fieldInfo){

	if(document.getElementById(filedName).value==null||document.getElementById(filedName).value==""){
		alert(fieldInfo+"不能为空");
		document.getElementById(filedName).onfocus="true";
		return false;
	}else{
		return true;
	}
}
function selectTree(){

	  var teamInfo = {
		  TaskIds:"",
		  Names:"",
		  StartDates:"",
		  EndDates:"",
		  CheckOther1s:""
	  }; 
	  window.showModalDialog('<%=contextPath%>/p6/tree/selectTree.jsp?projectInfoNo=<%=projectInfoNo%>',teamInfo);
	  
	  if(teamInfo.TaskIds != ""){

		  var tempTaskIds = teamInfo.TaskIds.split(",");
		  var tempNames = teamInfo.Names.split(",");
		  var tempStartDates = teamInfo.StartDates.split(",");
		  var tempEndDates = teamInfo.EndDates.split(",");
		  var Other1s = teamInfo.CheckOther1s.split(",");
		  
		  for(var i=0;i<tempTaskIds.length;i++){

			  addLine("",Other1s[i],tempNames[i],tempStartDates[i],tempEndDates[i]);
		  }	  
	  }
	  
}

function deleteLine(lineId){		
	var rowNum = lineId.split('_')[1];
	var rowNumj = document.getElementById("lineNumJ").value; 
	document.getElementById("lineNumJ").value = parseInt(rowNumj) - 1;
	
	var line = document.getElementById(lineId);		

	var bsflag = document.getElementsByName("em"+rowNum+"bsflag")[0].value;
	if(bsflag!=""){
		line.style.display = 'none';
		document.getElementsByName("em"+rowNum+"bsflag")[0].value = '1';
	}else{
		line.parentNode.removeChild(line);
	}	
}

function addLine( receive_nos,task_ids,task_names,plan_start_dates,plan_end_dates){
	
	var receive_no = "";
	var task_id = "";
	var task_name = "";
	var plan_start_date = "";
	var plan_end_date = "";
	var numsd ="";
	if(receive_nos != null && receive_nos != ""){
		receive_no=receive_nos;
	}
	if(task_ids != null && task_ids != ""){
		task_id=task_ids;
	}
	if(task_names != null && task_names != ""){
		task_name=task_names;
	}
	if(plan_start_dates != null && plan_start_dates != ""){
		plan_start_date=plan_start_dates;
	}
	if(plan_end_dates != null && plan_end_dates != ""){
		plan_end_date=plan_end_dates;
		
		var array1 = plan_start_date.split("-"); 
		var array2 = plan_end_date.split("-"); 	
		var dt1 = new Date(); 
		dt1.setFullYear(array1[0]); 
		dt1.setMonth(array1[1] - 1); 
		dt1.setDate(array1[2]); 
		var dt2 = new Date(); 
		dt2.setFullYear(array2[0]); 
		dt2.setMonth(array2[1] - 1); 
		dt2.setDate(array2[2]); 	
		var distance = dt2.getTime() - dt1.getTime(); //毫秒数	
		var days = distance / (24 * 60 * 60 * 1000);//算出天数 
 
		numsd=parseInt(days)+1;
	 
	}


	
	
	var rowNum = document.getElementById("lineNum").value;	
	var rowNumJ = document.getElementById("lineNumJ").value;	
	
	var tr = document.getElementById("taskTable").insertRow();
	tr.id = "row_" + rowNum + "_";

  	if(rowNum % 2 == 1){  
  		tr.className = "odd";
	}else{ 
		tr.className = "even";
	}	

	tr.insertCell().innerHTML = '<input type="hidden" name="em'+ rowNum + 'receiveNo" id="em'+ rowNum + 'receiveNo" value="'+receive_no+'"/>'+(parseInt(rowNum) + 1);
	tr.insertCell().innerHTML = '<input type="hidden" id="em' + rowNum + 'taskId" name="em' + rowNum + 'taskId" value="'+task_id+'"/>'+'<input type="text" readonly="readonly" id="em' + rowNum + 'taskName" name="em' + rowNum + 'taskName" value="'+task_name+'"/>';
	tr.insertCell().innerHTML = '<input type="text" readonly="readonly" id="em' + rowNum + 'planStartDate" name="em' + rowNum + 'planStartDate"  value="'+plan_start_date+'"/>';
	tr.insertCell().innerHTML = '<input type="text" readonly="readonly" id="em' + rowNum + 'planEndDate" name="em' + rowNum + 'planEndDate" value="'+plan_end_date+'"/>'+'<input type="hidden"  class="input_width" name="em' + rowNum + 'bsflag" id="em' + rowNum + 'bsflag" value="0"/>';
	tr.insertCell().innerHTML = '<input type="text" readonly="readonly"  value="'+numsd+'"/>';
		
	var rowid = "row_" + rowNum + "_";
	tr.insertCell().innerHTML = '<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine('+"'"+rowid+"'"+')"/>';
	document.getElementById("lineNum").value = (parseInt(rowNum) + 1);
	document.getElementById("lineNumJ").value = (parseInt(rowNumJ) + 1);
}
</script>
</html>