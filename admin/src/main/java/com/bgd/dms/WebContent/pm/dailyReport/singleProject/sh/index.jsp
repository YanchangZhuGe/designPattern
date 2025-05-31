<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="java.util.*" contentType="text/html;charset=UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ taglib uri="code" prefix="code"%> 
<%
    String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	String projectInfoNo = request.getParameter("projectInfoNo");
	String projectName = request.getParameter("projectName");
	String orgName = request.getParameter("orgName");
	UserToken user = OMSMVCUtil.getUserToken(request);
	if(projectInfoNo == null || "".equals(projectInfoNo)){
	
		projectInfoNo = user.getProjectInfoNo();
		projectName = user.getProjectName();
		orgName = user.getOrgName();
	}
	

	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup-new.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<style type="text/css">
 .myButton {
	BORDER: #deddde 1px solid;
	font-size: 12px;
	background:#2C83C1;
	CURSOR:  hand;
	COLOR: #FFFFFF;
	padding-top: 2px;
	padding-left: 2px;
	padding-right: 2px;
	height:22px;
}
</style>
</head>

<script type="text/javascript">

	function g(o){
		return document.getElementById(o);
	}

	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	var exploration_method="";
	
	var flag = "";
	var edit_flag = "no";
	
	function validate(){
		var produce_date = document.getElementById("produce_date").value;
		var project_info_no = document.getElementById("project_info_no").value;
		
		var retObj = jcdpCallService("DailyReportSrv", "getDailyReportInfo", "projectInfoNo=<%=projectInfoNo %>&produceDate="+produce_date);
		
		if(retObj == null || retObj.dailyMap == null || retObj.dailyMap.DAILY_NO == null){
			//日报未录入
			cleanTheBlank();
			g('edit_button').style.display="none";
			g('zj_button').style.display="inline";
			g('message').innerHTML="日报没有录入！";
			g('flag').value = "notSaved";
		} else if(retObj.dailyMap.AUDIT_STATUS=="0"){
			//debugger;
			fillTheBlank(retObj.dailyMap);
			disableTheBlank();
			g('message').innerHTML="日报已经录入但未提交，请点确定继续反馈工作量或者返回！";
			g('edit_button').style.display="inline";
			g('zj_button').style.display="inline";
			g('flag').value = "notSubmited";
		} else if(retObj.dailyMap.AUDIT_STATUS=="1"){
			//日报已经提交
			fillTheBlank(retObj.dailyMap);
			disableTheBlank();
			g('message').innerHTML="日报已经提交，请点确定查看反馈工作量或者返回！";		
			g('edit_button').style.display="none";
			g('zj_button').style.display="none";
			g('flag').value = "Submited";
		} else if(retObj.dailyMap.AUDIT_STATUS=="3"){
			//日报审批通过
			fillTheBlank(retObj.dailyMap);
			disableTheBlank();
			g('message').innerHTML="日报审批通过，请点确定查看反馈工作量或者返回！";		
			g('edit_button').style.display="none";
			g('zj_button').style.display="none";
			g('flag').value = "Passed";
		} else if(retObj.dailyMap.AUDIT_STATUS=="4"){
			//日报审批未通过
			fillTheBlank(retObj.dailyMap);
			disableTheBlank();
			g('message').innerHTML="日报审批未通过，请点确定继续反馈工作量或者返回！";		
			g('edit_button').style.display="inline";
			g('zj_button').style.display="inline";
			g('flag').value = "notPassed";
		}
		
		//debugger;
		retObj = jcdpCallService("DailyReportSrv", "queryDailyQuestion", "projectInfoNo=<%=projectInfoNo %>&produceDate="+produce_date);
	    var lineNum = 0;
	    if(retObj != null && retObj.questionList != null){
	      lineNum = retObj.questionList.length;
	    }
	    
	    var table = document.getElementById("table");
		if(table.rows.length != 1){
			//清掉已增加的列
			for(var i=1; i < table.rows.length;i++){
				table.deleteRow(1);
			}
		}
	    
	    document.getElementById("rowNum").value = lineNum;
	    
	    for(var i = 0; i < lineNum; i++){
	      var tr = document.getElementById("table").insertRow();
	      if ( i % 2 == 0) {
	        tr.className = "even";
	      } else {
	        tr.className = "odd";
	      }
	      
	      var rowNum = i;
	      var lineId = "row_" + rowNum + "_";
	      tr.id=lineId;
	      
	      var obj = retObj.questionList[i];
	      
	      //序号
	      tr.insertCell().innerHTML = (i+1);
	      
	      //问题分类bugCode
	      tr.insertCell().innerHTML = '<input type="hidden" name="question_id_'+rowNum+'" id="question_id_'+rowNum+'" value="'+obj.question_id+'"/><select name="bug_code_'+rowNum+'" id="bug_code_'+rowNum+'" class="select_width"> '+
										    		'<option value="">--请选择--</option>'+
										    		'<option value="5000100005000000001">人员</option>'+
										    		'<option value="5000100005000000002">物资</option>'+
										    		'<option value="5000100005000000003">设备</option>'+
										    		'<option value="5000100005000000004">HSE</option>'+
										    		'<option value="5000100005000000005">后勤</option>'+
										    		'<option value="5000100005000000006">工农、社区关系</option>'+
										    		'<option value="5000100005000000007">技术</option>'+
										    		'<option value="5000100005000000008">生产</option>'+
										    		'<option value="5000100005000000009">甲方信息</option>'+
										    		'<option value="5000100005000000010">自然因素</option>'+
										    		'<option value="5000100005000000011">质量</option>'+
										    		'<option value="5000100005000000012">财务经营</option>'+
										    		'<option value="5000100005000000013">其它</option>'+
										    	'</select>';
										    	
		  document.getElementsByName("bug_code_"+rowNum)[0].value = obj.bug_code;
	      
	      //问题描述
	      tr.insertCell().innerHTML = '<textarea name="q_description_'+rowNum+'" id="q_description_'+rowNum+'" class="textarea" >'+obj.q_description+'</textarea>';
	      
	      //解决方案
	      tr.insertCell().innerHTML = '<textarea name="resolvent_'+rowNum+'" id="resovlent_'+rowNum+'" class="textarea" >'+obj.resolvent+'</textarea>';
	      
	      //删除
	      tr.insertCell().innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/><img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="toDelete(\''+lineId+'\')"/>';
	    }
	    
	}
	function disableTheBlank(){
		document.getElementsByName("if_build")[0].disabled = true;
		document.getElementsByName("weather")[0].disabled = true;
		document.getElementsByName("stop_reason")[0].disabled = true;
		document.getElementsByName("work_time")[0].disabled = true;
		document.getElementsByName("collect_time")[0].disabled = true;
		document.getElementsByName("day_check_time")[0].disabled = true;
		document.getElementsByName("breakdown_time")[0].disabled = true;
		
		//document.getElementsByName("workman_num")[0].disabled = true;
		//document.getElementsByName("out_employee_num")[0].disabled = true;
		//document.getElementsByName("season_employee_num")[0].disabled = true;
	}
	function forEdit(){
		document.getElementById("edit_button").disabled=true;
		document.getElementById("edit_flag").value="yes";
		edit_flag="yes";
		document.getElementsByName("if_build")[0].disabled = false;
		document.getElementsByName("weather")[0].disabled = false;
		document.getElementsByName("stop_reason")[0].disabled = false;
		document.getElementsByName("work_time")[0].disabled = false;
		document.getElementsByName("collect_time")[0].disabled = false;
		document.getElementsByName("day_check_time")[0].disabled = false;
		document.getElementsByName("breakdown_time")[0].disabled = false;
		//document.getElementsByName("workman_num")[0].disabled = false;
		//document.getElementsByName("out_employee_num")[0].disabled = false;
		//document.getElementsByName("season_employee_num")[0].disabled = false;
	}
	function fillTheBlank(dailyMap){
		//debugger;
		document.getElementsByName("if_build")[0].value = dailyMap.IF_BUILD;
		document.getElementsByName("weather")[0].value = dailyMap.WEATHER;
		document.getElementsByName("stop_reason")[0].value = dailyMap.STOP_REASON;
		
		document.getElementsByName("work_time")[0].value = dailyMap.WORK_TIME==0?"":dailyMap.WORK_TIME;
		document.getElementsByName("collect_time")[0].value = dailyMap.COLLECT_TIME==0?"":dailyMap.COLLECT_TIME;
		document.getElementsByName("day_check_time")[0].value = dailyMap.DAY_CHECK_TIME==0?"":dailyMap.DAY_CHECK_TIME;
		document.getElementsByName("breakdown_time")[0].value = dailyMap.BREAKDOWN_TIME==0?"":dailyMap.BREAKDOWN_TIME;

		
		//document.getElementsByName("workman_num")[0].value = dailyMap.WORKMAN_NUM==0?"":dailyMap.WORKMAN_NUM;
		//document.getElementsByName("out_employee_num")[0].value = dailyMap.OUT_EMPLOYEE_NUM==0?"":dailyMap.OUT_EMPLOYEE_NUM;
		//document.getElementsByName("season_employee_num")[0].value = dailyMap.SEASON_EMPLOYEE_NUM==0?"":dailyMap.SEASON_EMPLOYEE_NUM;
	
	}
	function cleanTheBlank(){
		document.getElementsByName("if_build")[0].value = "";
		document.getElementsByName("weather")[0].value = "";
		document.getElementsByName("stop_reason")[0].value = "";
		document.getElementsByName("work_time")[0].value = "";
		document.getElementsByName("collect_time")[0].value = "";
		document.getElementsByName("day_check_time")[0].value = "";
		document.getElementsByName("breakdown_time")[0].value = "";
		
		//document.getElementsByName("workman_num")[0].value = "";
		//document.getElementsByName("out_employee_num")[0].value = "";
		//document.getElementsByName("season_employee_num")[0].value = "";
		
		document.getElementsByName("if_build")[0].disabled = false;
		document.getElementsByName("weather")[0].disabled = false;
		document.getElementsByName("stop_reason")[0].disabled = false;
		document.getElementsByName("work_time")[0].disabled = false;
		document.getElementsByName("collect_time")[0].disabled = false;
		document.getElementsByName("day_check_time")[0].disabled = false;
		document.getElementsByName("breakdown_time")[0].disabled = false;
		//document.getElementsByName("workman_num")[0].disabled = false;
		//document.getElementsByName("out_employee_num")[0].disabled = false;
		//document.getElementsByName("season_employee_num")[0].disabled = false;
	}
	
	function goNext(){
		//debugger;
		var produce_date = document.getElementById("produce_date");
		if(produce_date == null || produce_date.value == ""){
			alert("生产日期不能为空!");
			return false;
		}
		
		var if_build = document.getElementById("if_build");
		if(if_build == null || if_build.value == ""){
			alert("项目状态不能为空!");
			return false;
		}
		
		var weather = document.getElementById("weather");
		if(weather == null || weather.value == ""){
			alert("天气不能为空!");
			return false;
		}
		document.form1.submit();
	}
	
	function toAdd(){
		var rowNum = Number(document.getElementById("rowNum").value);
		var lineId = "row_" + rowNum + "_";
		
		var tr = document.getElementById("table").insertRow();
		tr.id=lineId;	
		if ( rowNum % 2 == 0) {
			tr.className = "even";
		} else {
			tr.className = "odd";
		}
		
		//序号
	      tr.insertCell().innerHTML = (rowNum+1);
	      
	      //问题分类bugCode
	      tr.insertCell().innerHTML = '<input type="hidden" name="question_id_'+rowNum+'" id="question_id_'+rowNum+'"/><select name="bug_code_'+rowNum+'" id="bug_code_'+rowNum+'" class="select_width"> '+
										    		'<option value="">--请选择--</option>'+
										    		'<option value="5000100005000000001">人员</option>'+
										    		'<option value="5000100005000000002">物资</option>'+
										    		'<option value="5000100005000000003">设备</option>'+
										    		'<option value="5000100005000000004">HSE</option>'+
										    		'<option value="5000100005000000005">后勤</option>'+
										    		'<option value="5000100005000000006">工农、社区关系</option>'+
										    		'<option value="5000100005000000007">技术</option>'+
										    		'<option value="5000100005000000008">生产</option>'+
										    		'<option value="5000100005000000009">甲方信息</option>'+
										    		'<option value="5000100005000000010">自然因素</option>'+
										    		'<option value="5000100005000000011">质量</option>'+
										    		'<option value="5000100005000000012">财务经营</option>'+
										    		'<option value="5000100005000000013">其它</option>'+
										    	'</select>';
	      
	      //问题描述
	      tr.insertCell().innerHTML = '<textarea name="q_description_'+rowNum+'" class="textarea"></textarea>';
	      
	      //解决方案
	      tr.insertCell().innerHTML = '<textarea name="resolvent_'+rowNum+'" class="textarea"></textarea>';
	      
	      //删除
	      tr.insertCell().innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/><img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="toDelete(\''+lineId+'\')"/>';
	      
	     document.getElementById("rowNum").value = rowNum+1;
	}
	
	function toDelete(lineId){
		var rowNum = lineId.split('_')[1];
		var line = document.getElementById(lineId);	
		
		var lineNum = Number(document.getElementById("rowNum").value);
		
		var question_id = document.getElementById('question_id_'+rowNum);
		
		if(question_id != null){
			//删除数据库中现有记录
			document.getElementById('deleteId').value = document.getElementById('deleteId').value + "," +question_id.value;
		}
		
		line.parentNode.removeChild(line);
		
		lineNum--;
		document.getElementById("rowNum").value = lineNum;
	}
	function change(){
		if(document.getElementsByName("if_build")[0].value == "7"){
			g('td1').style.display="inline";
			g('td2').className="odd";
		} else {
			g('td1').style.display="none";
			g('td2').className="even";
		}
	}
</script>
<body style="background:#fff">
<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height">  
	<tr class="tongyong_box_title">
		<td colspan="6" align="left"><span>&nbsp;&nbsp;<font size="2">日报基本信息</font></span><td>
	</tr>
  	<tr class="even">
	    <td class="inquire_item6">施工队伍：</td>
	    <td class="inquire_form6"><%=orgName  %></td>
    	<td class="inquire_item6">项目信息：</td>
		<td class="inquire_form6"><%=projectName %></td>
		<td class="inquire_item6">&nbsp;</td>
		<td class="inquire_form6" >
			<input id="edit_button" type="button" name="button2" value="编辑" onClick="forEdit()" class="myButton" style="display: none;"/>&nbsp;&nbsp;&nbsp;
			<input type="button" name="button2" value="下一步"  class="myButton"  onclick="goNext()"/>
		</td>
	</tr> 
</table>
<form name="form1" action="<%=contextPath%>/pm/dailyReport/saveOrUpdateDailyReportSh.srq" method="post">

<input id="project_info_no" name="project_info_no" value="<%=projectInfoNo %>" type="hidden"/>
<input id="edit_flag" name="edit_flag" value="no" type="hidden"/>
<input id="flag" name="flag" value="" type="hidden"/>


<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height">
<tr class="odd">
		<td class="inquire_item6"><font style="color:red">*</font>&nbsp;生产日期:</td>
		<td class="inquire_form6"><input type="text" name='produce_date' id='produce_date' value=''  onchange="validate()" readonly>&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1"  name="tributton1" width="16" height="16" style="cursor:hand;" onmouseover="calDateSelector('produce_date',tributton1);" /></td>
		<td class="inquire_item6"><font style="color:red">*</font>&nbsp;项目状态:</td>
		<td class="inquire_form6">
			<select name="if_build" id="if_build" class="select_width" onchange="change()">
				<option value="">请选择</option>
				<option value="1">动迁</option>
				<option value="2">踏勘</option>
				<option value="3">试验</option>
				<option value="4">测量</option>
				<option value="5">钻井</option>
				<option value="6">采集</option>
				<option value="7">停工</option>
				<option value="8">暂停（人员设备撤离）</option>
				<option value="9">结束</option>
			</select>
		</td>
		<td class="inquire_item6"><font style="color:red">*</font>&nbsp;天气情况：</td>
		<td class="inquire_form6">
			<select name="weather" id="weather" class="select_width">
				<option value="">请选择</option>
				<option value="1">晴</option>
				<option value="2">阴</option>
				<option value="3">多云</option>
				<option value="4">雨</option>
				<option value="5">雾</option>
				<option value="17">大风</option>
				<option value="6">霾</option>
				<option value="7">霜冻</option>
				<option value="8">暴风</option>
				<option value="9">台风</option>
				<option value="10">暴风雪</option>
				<option value="11">雪</option>
				<option value="12">雨夹雪</option>
				<option value="13">冰雹</option>
				<option value="14">浮尘</option>
				<option value="15">扬沙</option>
				<option value="16">其它</option>
			</select>
		</td>
		
	</tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height">
	<tr class="even" id="td1" style="display: none;">
		<td class="inquire_item6">停工原因:</td>
		<td class="inquire_form6">
			<select name="stop_reason" id="stop_reason" class="select_width">
				<option value="">请选择</option>
				<option value="1">试验</option>
				<option value="2">检修</option>
				<option value="3">组织停工</option>
				<option value="4">自然停工</option>
				<option value="5">其他</option>
			</select>
		</td>
		<td class="inquire_item6">&nbsp;</td>
		<td class="inquire_form6">&nbsp;</td>
		<td class="inquire_item6">&nbsp;</td>
		<td class="inquire_form6">&nbsp;</td>
	</tr>
	<tr class="even" id="td2">
		<td class="inquire_item6">采集时间（小时）</td>
		<td class="inquire_form6" ><input name="work_time" type="text" class="input_width" /></td>
		<td class="inquire_item6">付费待工时间（小时）</td>
		<td class="inquire_form6"><input name="collect_time" type="text" class="input_width"/></td>
		<td class="inquire_item6">不付费待工时间（小时）</td>
		<td class="inquire_form6"><input name="day_check_time" type="text" class="input_width"/></td>
		
	</tr>
	<tr class="odd" id="td2">
		<td class="inquire_item6">故障时间（小时）</td>
		<td class="inquire_form6" ><input name="breakdown_time" type="text" class="input_width"/></td>
		<td class="inquire_item6"></td>
		<td class="inquire_form6"></td>
		<td class="inquire_item6"></td>
		<td class="inquire_form6"></td>

	</tr>
	<!-- 
	<tr class="even" id="td2">
		<td class="inquire_item6"><font style="color:red">*</font>&nbsp;施工时长(小时):</td>
		<td class="inquire_form6" ><input name="work_time" type="text" class="input_width" /></td>
		<td class="inquire_item6">采集时间(小时):</td>
		<td class="inquire_form6"><input name="collect_time" type="text" class="input_width"/></td>
		<td class="inquire_item6">日检时间(小时):</td>
		<td class="inquire_form6"><input name="day_check_time" type="text" class="input_width"/></td>
	</tr>
	                    
	 -->
	<tr>
		<td colspan="6" class="inquire_item6">
			<span id="message" style="color:red">&nbsp;</span>			
		</td>
	</tr>
</table>  	

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >
	<tr class="tongyong_box_title">
		<td colspan="3" align="left"><span>&nbsp;&nbsp;<font size="2">日问题信息</font></span></td>
		<span id="zj_button" ><auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton></span>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  id="table" style="overflow: scroll;">
	<tr class="bt_info">
		<td class="bt_info_odd" width="5%">序号<input type="hidden" value="0" id="rowNum" name="rowNum"/><input type="hidden" value="" id="deleteId" name="deleteId"/></td>
		<td class="bt_info_even" width="20%">问题分类</td>
		<td class="bt_info_odd" width="35%">问题描述</td>
		<td class="bt_info_even" width="35%">解决方案</td>
		<td class="bt_info_odd" width="5%">删除</td>
	</tr>
</table>

</form>
</body>
</html>