<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.*"%>
<%@ page  import="java.net.*" %>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	List LaborList = respMsg.getMsgElements("LaborList");//人工
	List NonlaborList = respMsg.getMsgElements("NonlaborList");//非人工
	List MaterialLlist = respMsg.getMsgElements("MaterialLlist");//材料
	
	List WorkLoadLlist = respMsg.getMsgElements("WorkLoadLlist");//工作量
	
	String produceDate = request.getParameter("produceDate");
	String projectInfoNo = request.getParameter("projectInfoNo");
	String orgId = request.getParameter("orgId");
	String flag = respMsg.getValue("flag");
	
	if(produceDate == null || "".equals(produceDate)) {
		produceDate = respMsg.getValue("produceDate");
	}
	if(projectInfoNo == null || "".equals(projectInfoNo)) {
		projectInfoNo = respMsg.getValue("projectInfoNo");
	}
	if(orgId == null || "".equals(orgId)) {
		orgId = respMsg.getValue("orgId");
	}
	if(flag == null || "".equals(flag)) {
		flag = request.getParameter("flag");
	}
	if(flag == null || "".equals(flag)) {
		flag = "Submited";
	}
	
	List list = respMsg.getMsgElements("list");
	MsgElement msg1 = (MsgElement)list.get(0);
	Map map1 = msg1.toMap();
	
	String activity_object_id = (String) map1.get("OBJECT_ID");
	String remainingDuration = respMsg.getValue("remainingDuration");
	//map1.put("PLANNED_DURATION", "32");
	//map1.put("HOURS_PER_DAY", "8");
	String taskName = URLDecoder.decode(respMsg.getValue("taskname"),"UTF-8");
	
	String message = "";
	if(flag == "Saved" || "Saved".equals(flag)){
		message = "未提交";
	} else if(flag == "Submited" || "Submited".equals(flag)){
		message = "已提交，待审批";
	} else if(flag == "Passed" || "Passed".equals(flag)){
		message = "审批通过";
	} else if(flag == "notPassed" || "notPassed".equals(flag)){
		message = "审批未通过";
	} else {
		message = "未保存";
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/js/bgpmcs/DivHiddenOpen.js"></script>
<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>
<%@ include file="/common/pmd_list.jsp"%>
<title>列表页面</title>
</head>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/help.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/styles/calendar-blue.css"  />	
<script type="text/javascript">
//alert("mapping.jsp");
function changeStartStatus(){
	var start_date = $("#start_date").val();
	var end_date = $("#finish_date").val();
	if(start_date == ""){
		$("#status").val("Not Started");
		$("#activityStatus").html("未开始");
	}else{
		if(end_date == ""){
			$("#status").val("In Progress");
			$("#activityStatus").html("运行");
		}else{
			if(end_date < start_date){
				alert("开始时间不能大于结束时间");
				$("#start_date").val("");
				return;
			}
			$("#status").val("Completed");
			$("#activityStatus").html("完成");
		}	
	}
}

function changeEndStatus(){
	var end_date = $("#finish_date").val();
	var start_date = $("#start_date").val();
	if(start_date == ""){
		if(end_date != ""){
			alert("开始时间未填写,不能填写结束时间");
			$("#finish_date").val("");
			return;
		}
	}else{
		if(end_date == ""){
			$("#status").val("In Progress");
			$("#activityStatus").html("运行");
		}else{
			if(end_date < start_date){
				alert("结束时间不能小于开始时间");
				$("#finish_date").val("");
				$("#status").val("In Progress");
				$("#activityStatus").html("运行");
				return;
			}
			$("#status").val("Completed");
			$("#activityStatus").html("完成");
		}
	}
}

function change(object_id){
	var value = document.getElementById('budgeted_units'+object_id).value;
	document.getElementById('in'+object_id).value = value;
	var num = new Number(value*document.getElementById('remaining_duration'+<%=activity_object_id%>).value);
	document.getElementById('remaining_units'+object_id).value = num.toFixed(2);
	document.getElementById('actual_this_period_units'+object_id).value = value;
}
function change1(){
	<%
		if(LaborList != null){
		for(int i =0; i<LaborList.size();i++){
			MsgElement msg = (MsgElement)LaborList.get(i);
			Map map = msg.toMap();
	%>
	var value = document.getElementById('budgeted_units'+<%=map.get("OBJECT_ID") %>).value;
	document.getElementById('remaining_units'+<%=map.get("OBJECT_ID") %>).value = value*document.getElementById('remaining_duration'+<%=activity_object_id%>).value;
	<%}}%>
	<%
		if(NonlaborList != null){
		for(int i =0; i<NonlaborList.size();i++){
			MsgElement msg = (MsgElement)NonlaborList.get(i);
			Map map = msg.toMap();
	%>
	var value = document.getElementById('budgeted_units'+<%=map.get("OBJECT_ID") %>).value;
	document.getElementById('remaining_units'+<%=map.get("OBJECT_ID") %>).value = value*document.getElementById('remaining_duration'+<%=activity_object_id%>).value;
	<%}}%>
}
function change2(object_id){
	var value = document.getElementById('actual_this_period_units'+object_id).value;
	var value1 = document.getElementById('planned_units'+object_id).value;
	var num = new Number(value1 - value - document.getElementById('actual_units'+object_id).value);
	document.getElementById('remaining_units'+object_id).value = num.toFixed(2);
}
function change3(){
	//var value = document.getElementById('budgeted_units'+object_id).value;
	//alert(document.forms[0].status.value);
	if(document.forms[0].status.value=="Not Started"){
		//alert("1");
	} else if(document.forms[0].status.value=="In Progress"){
		//alert("2");
	} else if(document.forms[0].status.value=="Completed"){
		//alert("3");
	} 
	
}
function toAdd(){
	var start_date = $("#start_date").val();
	var end_date = $("#finish_date").val();
	if(start_date == ""){
		alert("请填写开始时间");
		return;
	}
	if(end_date != ""&&start_date == ""){
		alert("请填写开始时间");
		return;
	}
	document.form1.butL1.disabled = true;
	document.form1.action="<%=contextPath%>/p6/saveOrUpdateResourceAssignmentSh.srq";
	document.form1.submit();
}
cruConfig.contextPath = "<%=contextPath%>";
cruConfig.cdtType = 'form';
function toSubmit(){
	if(window.confirm("确定提交吗？该操作会提交所有作业的当天的反馈！")) {
		document.form1.butL1.disabled = true;
		//document.form1.action="<%=contextPath%>/p6/resourceAssignment/submitResourceAssignment.srq?";
		debugger;
		var retObj = jcdpCallService("DailyReportSrv", "submitDailyReport", "projectInfoNo=<%=projectInfoNo %>&produceDate=<%=produceDate %>");
		if(retObj.message != null) {
			if(retObj.message == "success"){
				document.getElementById('message').innerHTML = "已提交，待审批";
				alert("提交成功!");
			}
		}
		//document.form1.submit();
	}
}
function toEdit(){
	var start_date = $("#actual_start_date").html().substr(0,10);
	var finish_date = $("#actual_finish_date").html().substr(0,10);
	if(start_date.indexOf("INPUT") == 1 || start_date.indexOf("input") == 1){
		start_date = $("#start_date").val();
		finish_date = $("#finish_date").val();
	}
	var t1 = '<input type="text" name="start_date" id="start_date" value="'+start_date+'" onchange="changeStartStatus()" readonly/>&nbsp;&nbsp;'+
			 '<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor:hand;" onmouseover="calDateSelector(start_date,tributton1);" />'+
			 '&nbsp;<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="clearStartDate()"/>';
	var t2 = '<input type="text" name="finish_date" id="finish_date" value="'+finish_date+'" readonly>&nbsp;&nbsp;'+
			 '<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor:hand;" onmouseover="calDateSelector(finish_date,tributton2);" />'+
			 '&nbsp;<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="clearFinishDate()"/>';
	$("#actual_start_date").html(t1);
	$("#actual_finish_date").html(t2);
	$("#editbut").attr("disabled","disabled");
	$("#savebut").removeAttr("disabled");
}
function clearStartDate(){
	$("#start_date").val("");
	changeStartStatus();
}
function clearFinishDate(){
	$("#finish_date").val("");
	changeEndStatus();
}
</script>
</head>
<body>
<form action="" name="form1" id="form1" method="post">
<table  border="0" cellpadding="0" cellspacing="0" class="Tab_new_mod_del">
  <tr class="ali7">
    <td>
<%if ((String)map1.get("STATUS") =="Completed" || "Completed".equals((String)map1.get("STATUS")) ){ %>
<input class="iButton2" type="button" id="savebut" name="butL1" value="保存" onClick="toAdd()" disabled="disabled"/>
<%} else {%>
<input class="iButton2" type="button" id="savebut" name="butL1" value="保存" onClick="toAdd()"/>
<%} %>
	<font id="message" color="red"><%=message %></font>
    </td>
    <td align="left">当前日报日期：<font color="red"><%=produceDate %></font></td>
	<td>
    <%if (flag == "Submited" || flag == "Passed" || "Submited".equals(flag) || "Passed".equals(flag)){ %>
		<input class="iButton2" type="button" id="editbut" name="butL2" value="修改" />
	<%} else {%>
		<input class="iButton2" type="button" id="editbut" name="butL2" value="修改" onClick="toEdit()"/>
	<%} %>
    
    </td>

  </tr>
</table>

<div id="resultable"  style="width:100%; overflow-x:scroll ;" >
<%

if(map1 != null) {
%>
<table border="0"  cellspacing="0"  cellpadding="0"  class="form_info"  width="100%">
<tr>
<td bgcolor="#DDF1F2" width="25%">状态</td>
<td bgcolor="#DDF1F2" width="25%">作业代码</td>
<td bgcolor="#DDF1F2" width="25%">作业名称</td>
<td bgcolor="#DDF1F2" width="25%">原定工期</td>
</tr>
<tr>

<td>
<%if ((String)map1.get("STATUS") =="Not Started" || "Not Started".equals((String)map1.get("STATUS")) ){ %>
<label id="activityStatus">未开始</label>
<input type="hidden" id="status" name="status" value="Not Started"/>
<%} else if ((String)map1.get("STATUS") =="In Progress" || "In Progress".equals((String)map1.get("STATUS")) ){%>
<label id="activityStatus">运行</label>
<input type="hidden" id="status" name="status" value="In Progress"/>
<%} else if ((String)map1.get("STATUS") =="Completed" || "Completed".equals((String)map1.get("STATUS")) ){%>
<label id="activityStatus">结束</label>
<input type="hidden" id="status" name="status" value="Completed"/>
<%} %>
</td>

<td><%=map1.get("ID") %></td>
<%-- <td><%=map1.get("NAME") %></td> --%>
<td><%=taskName %></td>
<td><%=Long.parseLong((String)map1.get("PLANNED_DURATION"))/Long.parseLong((String)map1.get("HOURS_PER_DAY")) %>天</td>
<!-- td><%=map1.get("PROJECT_ID")+"."+map1.get("WBS_CODE")+" "+map1.get("WBS_NAME") %></td-->
</tr>
<tr>
<td bgcolor="#DDF1F2">实际开始日期</td>
<td bgcolor="#DDF1F2">实际完工日期</td>
<td bgcolor="#DDF1F2">预计开工日期</td>
<td bgcolor="#DDF1F2">预计完工日期</td>
</tr>
<tr>
<td id="actual_start_date">
<%if ((String)map1.get("STATUS") =="Completed" || "Completed".equals((String)map1.get("STATUS")) ){ %>
<%=map1.get("ACTUAL_START_DATE")==null?"&nbsp;":map1.get("ACTUAL_START_DATE").toString() %>
<%} else { %>
<input type="text" name="start_date" id='start_date' value='<%=map1.get("ACTUAL_START_DATE")==null?"":map1.get("ACTUAL_START_DATE").toString() %>' onchange='changeStartStatus()' readonly/>&nbsp;&nbsp;
<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor:hand;" onmouseover="calDateSelector(start_date,tributton1);" />
<%} %>
</td>
<td id="actual_finish_date">
<%if ((String)map1.get("STATUS") =="Completed" || "Completed".equals((String)map1.get("STATUS")) ){ %>
<%=map1.get("ACTUAL_FINISH_DATE")==null?"&nbsp;":map1.get("ACTUAL_FINISH_DATE").toString() %>
<%} else { %>
<input type="text" name="finish_date" id='finish_date' value='<%=map1.get("ACTUAL_FINISH_DATE")==null?"":map1.get("ACTUAL_FINISH_DATE").toString() %>' onchange='changeEndStatus()' readonly>&nbsp;&nbsp;
<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor:hand;" onmouseover="calDateSelector(finish_date,tributton2);" />
<%} %>
</td>
<!-- td><%=Long.parseLong((String)map1.get("PLANNED_DURATION"))/Long.parseLong((String)map1.get("HOURS_PER_DAY")) %>天</td-->
<td><%=map1.get("PLANNED_START_DATE")==null?"&nbsp;":map1.get("PLANNED_START_DATE").toString() %></td>
<td><%=map1.get("PLANNED_FINISH_DATE")==null?"&nbsp;":map1.get("PLANNED_FINISH_DATE").toString() %></td>
</tr>
<tr>
<td>尚需工期</td>
<td>
<input type="text" width="50%" name="remaining_duration<%=activity_object_id %>" id="remaining_duration<%=activity_object_id %>" value="<%=remainingDuration %>" onkeyup="change1()"/>
&nbsp;&nbsp;天
</td>
<td colspan="2">&nbsp;</td>
</tr>

</table>
<br/>
<%} %>
<table border="0"  cellspacing="0"  cellpadding="0"  class="form_info"  width="100%" id="queryRetTable">
	<thead>
	<input type="hidden" value="<%=projectInfoNo %>" id="projectInfoNo" name="projectInfoNo"/>
	<input type="hidden" value="<%=produceDate %>" id="produceDate" name="produceDate"/>
	<input type="hidden" value="<%=orgId %>" id="orgId" name="orgId"/>
	<input type= "hidden" value="<%=activity_object_id %>" id = "activity_object_id" name = "activity_object_id"/>
	<input type= "hidden" value="<%=activity_object_id %>" id = "object_id" name = "object_id"/>
	<input type= "hidden" value="<%=flag %>" id = "flag" name = "flag"/>
	<tr class="bt_info">
		<td>资源</td>
		<td>备注</td>
		<td>计划数量</td>
		<td>-</td>
		<td>本期完成</td>
		<td width="18%">尚需</td>
		<td>累计</td>
		<td>预计</td>
		<!--  td>开始</td>
		<td>结束</td-->
	</tr>
	</thead>
	<tbody>
	<%
		if(WorkLoadLlist != null){
	%>
		<tr>
			<td colspan="8" align="left" bgcolor="#DDF1F2">&nbsp;工作量</td>
		</tr>
	<%
		for(int i =0; i<WorkLoadLlist.size();i++){
			MsgElement msg = (MsgElement)WorkLoadLlist.get(i);
			Map map = msg.toMap();
	%>
		<tr>
			<td><%=map.get("RESOURCE_ID")+"."+map.get("RESOURCE_NAME") %></td>
			<td><%=map.get("TEXT_VALUE")==null?"&nbsp;":map.get("TEXT_VALUE") %></td>
			<td><%=map.get("DOUBLE_VALUE")==null?"&nbsp;":map.get("DOUBLE_VALUE") %></td>
			<td>-<input class="input_width" id="budgeted_units<%=map.get("OBJECT_ID") %>" name = "budgeted_units<%=map.get("OBJECT_ID") %>" value="<%=map.get("BUDGETED_UNITS") %>" type="hidden"/></td>
			<td><input class="input_width" id="actual_this_period_units<%=map.get("OBJECT_ID") %>" name = "actual_this_period_units<%=map.get("OBJECT_ID") %>" value="<%=map.get("ACTUAL_THIS_PERIOD_UNITS") %>" onkeyup="change2('<%=map.get("OBJECT_ID") %>')"/></td>
			<td><input class="input_width" id="remaining_units<%=map.get("OBJECT_ID") %>" name = "remaining_units<%=map.get("OBJECT_ID") %>" value="<%=map.get("REMAINING_UNITS") %>"/></td>
			<td><%=map.get("ACTUAL_UNITS") %>
			<input class="input_width" id="actual_units<%=map.get("OBJECT_ID") %>" name = "actual_units<%=map.get("OBJECT_ID") %>" value="<%=map.get("ACTUAL_UNITS") %>" type="hidden"/>
			</td>
			<td><%=map.get("PLANNED_UNITS") %>
			<input class="input_width" id="planned_units<%=map.get("OBJECT_ID") %>" name = "planned_units<%=map.get("OBJECT_ID") %>" value="<%=map.get("PLANNED_UNITS") %>" type="hidden"/>
			</td>
		</tr>
	<%
		}}
	%>
	<%
		if(MaterialLlist != null){
	%>
	<tr>
		<td colspan="8" align="left" bgcolor="#DDF1F2">&nbsp;材料消耗</td>
	</tr>
	<%
		for(int i =0; i<MaterialLlist.size();i++){
			MsgElement msg = (MsgElement)MaterialLlist.get(i);
			Map map = msg.toMap();
	%>
		<tr>
			<td><%=map.get("RESOURCE_ID")+"."+map.get("RESOURCE_NAME") %></td>
			<td><%=map.get("TEXT_VALUE")==null?"&nbsp;":map.get("TEXT_VALUE") %></td>
			<td><%=map.get("DOUBLE_VALUE")==null?"&nbsp;":map.get("DOUBLE_VALUE") %></td>
			<td>-<input class="input_width" id="budgeted_units<%=map.get("OBJECT_ID") %>" name = "budgeted_units<%=map.get("OBJECT_ID") %>" value="<%=map.get("BUDGETED_UNITS") %>" type="hidden"/></td>
			<td><input class="input_width" id="actual_this_period_units<%=map.get("OBJECT_ID") %>" name = "actual_this_period_units<%=map.get("OBJECT_ID") %>" value="<%=map.get("ACTUAL_THIS_PERIOD_UNITS") %>" onkeyup="change2('<%=map.get("OBJECT_ID") %>')"/></td>
			<td><input class="input_width" id="remaining_units<%=map.get("OBJECT_ID") %>" name = "remaining_units<%=map.get("OBJECT_ID") %>" value="<%=map.get("REMAINING_UNITS") %>"/></td>
			<td><%=map.get("ACTUAL_UNITS") %>
			<input class="input_width" id="actual_units<%=map.get("OBJECT_ID") %>" name = "actual_units<%=map.get("OBJECT_ID") %>" value="<%=map.get("ACTUAL_UNITS") %>" type="hidden"/>
			</td>
			<td><%=map.get("PLANNED_UNITS") %>
			<input class="input_width" id="planned_units<%=map.get("OBJECT_ID") %>" name = "planned_units<%=map.get("OBJECT_ID") %>" value="<%=map.get("PLANNED_UNITS") %>" type="hidden"/>
			</td>
			<!--td><%=map.get("START_DATE")==null?"":map.get("START_DATE").toString().substring(0,11) %></td>
			<td><%=map.get("FINISH_DATE")==null?"":map.get("FINISH_DATE").toString().substring(0,11)  %></td-->
		</tr>
	<%} }%>
	<%
		if(LaborList != null){
	%>
	<tr>
		<td align="left" bgcolor="#DDF1F2">&nbsp;人工</td>
		<td align="center" bgcolor="#DDF1F2">&nbsp;</td>
		<td align="center" bgcolor="#DDF1F2">&nbsp;</td>
		<td align="center" bgcolor="#DDF1F2">&nbsp;实际人数</td>
		<td colspan="4" bgcolor="#DDF1F2">&nbsp;</td>
	</tr>
	<%
		for(int i =0; i<LaborList.size();i++){
			MsgElement msg = (MsgElement)LaborList.get(i);
			Map map = msg.toMap();
	%>
		<tr>
			<td><%=map.get("RESOURCE_ID")+"."+map.get("RESOURCE_NAME") %></td>
			<td><%=map.get("TEXT_VALUE")==null?"&nbsp;":map.get("TEXT_VALUE") %></td>
			<td><%=map.get("DOUBLE_VALUE")==null?"&nbsp;":map.get("DOUBLE_VALUE") %></td>
			<td><input class="input_width" id="budgeted_units<%=map.get("OBJECT_ID") %>" name = "budgeted_units<%=map.get("OBJECT_ID") %>" value="<%=Long.parseLong((String)map.get("BUDGETED_UNITS"))/Long.parseLong((String)map.get("HOURS_PER_DAY")) %>" onkeyup="change('<%=map.get("OBJECT_ID") %>')"/></td>
			<td><input class="input_width" id="actual_this_period_units<%=map.get("OBJECT_ID") %>" name = "actual_this_period_units<%=map.get("OBJECT_ID") %>" value="<%=Double.parseDouble((String)map.get("BUDGETED_UNITS"))/Long.parseLong((String)map.get("HOURS_PER_DAY")) %>" type="hidden"/>
			<input class="input_width" id="in<%=map.get("OBJECT_ID") %>" value="<%=Double.valueOf(Math.ceil(Double.parseDouble((String)map.get("BUDGETED_UNITS"))/Long.parseLong((String)map.get("HOURS_PER_DAY")))).intValue() %>" disabled="disabled">
			</td>
			<%
				double value = Double.parseDouble((String)map.get("BUDGETED_UNITS"))/Long.parseLong((String)map.get("HOURS_PER_DAY"))*Double.parseDouble(remainingDuration) ;
				Double valueDouble = Double.valueOf(value);
				int valueInt = 0;
				if (valueDouble.intValue() < value) {
					valueInt = valueDouble.intValue()+1;
				} else {
					valueInt = valueDouble.intValue();
				}
			 %>
			<td><input style="width: 50%" id="remaining_units<%=map.get("OBJECT_ID") %>" name = "remaining_units<%=map.get("OBJECT_ID") %>" value="<%=valueInt %>"/>工日</td>
			<td><%=Double.valueOf(Math.ceil(Double.parseDouble((String)map.get("ACTUAL_UNITS"))/Long.parseLong((String)map.get("HOURS_PER_DAY")))).intValue() %>工日</td>
			<td><%=Double.valueOf(Math.ceil(Double.parseDouble((String)map.get("PLANNED_UNITS"))/Long.parseLong((String)map.get("HOURS_PER_DAY")))).intValue() %>工日</td>
			<!--td><%=map.get("START_DATE")==null?"":map.get("START_DATE").toString().substring(0,11) %></td>
			<td><%=map.get("FINISH_DATE")==null?"":map.get("FINISH_DATE").toString().substring(0,11)  %></td-->
		</tr>
	<%} }%>
	<%
		if(NonlaborList != null){
	%>
	<tr>
		<td align="left" bgcolor="#DDF1F2">&nbsp;设备</td>
		<td align="center" bgcolor="#DDF1F2">&nbsp;</td>
		<td align="center" bgcolor="#DDF1F2">&nbsp;</td>
		<td align="center" bgcolor="#DDF1F2">&nbsp;实际设备台数</td>
		<td colspan="4" bgcolor="#DDF1F2">&nbsp;</td>
	</tr>
	<%
		for(int i =0; i<NonlaborList.size();i++){
			MsgElement msg = (MsgElement)NonlaborList.get(i);
			Map map = msg.toMap();
	%>
		<tr>
			<td><%=map.get("RESOURCE_ID")+"."+map.get("RESOURCE_NAME") %></td>
			<td><%=map.get("TEXT_VALUE")==null?"&nbsp;":map.get("TEXT_VALUE") %></td>
			<td><%=map.get("DOUBLE_VALUE")==null?"&nbsp;":map.get("DOUBLE_VALUE") %></td>
			<td><input class="input_width" id="budgeted_units<%=map.get("OBJECT_ID") %>" name = "budgeted_units<%=map.get("OBJECT_ID") %>" value="<%=Long.parseLong((String)map.get("BUDGETED_UNITS"))/Long.parseLong((String)map.get("HOURS_PER_DAY")) %>" onkeyup="change('<%=map.get("OBJECT_ID") %>')"/></td>
			<td>
			<input class="input_width" id="actual_this_period_units<%=map.get("OBJECT_ID") %>" name = "actual_this_period_units<%=map.get("OBJECT_ID") %>" value="<%=Double.parseDouble((String)map.get("BUDGETED_UNITS"))/Long.parseLong((String)map.get("HOURS_PER_DAY")) %>" type="hidden"/>
			<input class="input_width" id="in<%=map.get("OBJECT_ID") %>" value="<%=Double.valueOf(Math.ceil(Double.parseDouble((String)map.get("BUDGETED_UNITS"))/Long.parseLong((String)map.get("HOURS_PER_DAY")))).intValue() %>" disabled="disabled">
			</td>
			<%
				double value = Double.parseDouble((String)map.get("BUDGETED_UNITS"))/Long.parseLong((String)map.get("HOURS_PER_DAY"))*Double.parseDouble(remainingDuration) ;
				Double valueDouble = Double.valueOf(value);
				int valueInt = 0;
				if (valueDouble.intValue() < value) {
					valueInt = valueDouble.intValue()+1;
				} else {
					valueInt = valueDouble.intValue();
				}
			 %>
			<td><input style="width: 50%" id="remaining_units<%=map.get("OBJECT_ID") %>" name = "remaining_units<%=map.get("OBJECT_ID") %>" value="<%=valueInt %>"/>台班</td>
			<td><%=Double.valueOf(Math.ceil(Double.parseDouble((String)map.get("ACTUAL_UNITS"))/Long.parseLong((String)map.get("HOURS_PER_DAY")))).intValue() %>台班</td>
			<td><%=Double.valueOf(Math.ceil(Double.parseDouble((String)map.get("PLANNED_UNITS"))/Long.parseLong((String)map.get("HOURS_PER_DAY")))).intValue() %>台班</td>
			<!--td><%=map.get("START_DATE")==null?"":map.get("START_DATE").toString().substring(0,11) %></td>
			<td><%=map.get("FINISH_DATE")==null?"":map.get("FINISH_DATE").toString().substring(0,11)  %></td-->
		</tr>
	<%} }%>
	</tbody>
</table>
</div>
</form>
</body>
</html>
