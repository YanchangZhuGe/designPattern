<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.bgp.mcs.service.pm.service.project.WorkMethodSrv"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId =  user.getEmpId();
	String projectName = user.getProjectName();
	String projectInfoNo = user.getProjectInfoNo();
	WorkMethodSrv wm = new WorkMethodSrv();
	String	workmethod = wm.getProjectWorkMethod(projectInfoNo);
	String contextPath = request.getContextPath();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());
%>
<html>
<head>
<title>时效分析</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/setday.js"></script>
<style type="text/css">
body,table, td {font-size:12px;font-weight:normal;}
/* 重点：固定行头样式*/  
.scrollRowThead{BACKGROUND-COLOR: #AEC2E6;position: relative; left: expression(this.parentElement.parentElement.parentElement.parentElement.scrollLeft);z-index:0;}  
/* 重点：固定表头样式*/  
.scrollColThead {position: relative;top: expression(this.parentElement.parentElement.parentElement.scrollTop);z-index:2;}  
/* 行列交叉的地方*/  
.scrollCR{ z-index:3;}
/*div 外框*/  
.scrollDiv {height:90%;clear: both; border: 1px solid #94B6E6;OVERFLOW: scroll;width: 100%;}  
/* 行头居中*/  
.scrollColThead td,.scrollColThead th{ text-align: center ;}  
/* 行头列头背景*/  
.scrollRowThead,.scrollColThead td,.scrollColThead th{background-color:#94B6E6;background-repeat:repeat;}  
/* 表格的线*/  
.scrolltable{border-bottom:1px solid #CCCCCC; border-right:1px solid #8EC2E6;}  
/* 单元格的线等*/  
.scrolltable td,.scrollTable th{border-left: 1px solid #CCCCCC; border-top: 1px solid #CCCCCC; padding: 1px;}
.scrollTable thead th{background-color:#94B6E6;position:relative;}
.td_head {
	FONT-SIZE: 12px;
	COLOR: #296184;
	font-family:"微软雅黑", Arial, Helvetica, sans-serif;
	font-weight:normal;
	text-align: center;
	vertical-align: middle;
	height:20px;
	line-height: 20px;
	background:#CCCCCC;
}
</style>
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath%>';
var projectInfoNo = "<%=projectInfoNo%>";
var projectName = "<%=projectName%>";
var exportRows = new Array();

var workmethod = "<%=workmethod%>";
var bActive = false;
var team_name = "";
var dataRows = 0;
function toAdd(){
	var rowNum = document.getElementById("lineNum").value;
	var lineId = "row_" + rowNum + "_";
	var lineNum = parseInt(rowNum)+1;
	var weekStartTimes = "";
	var weekEndTimes = "";
	if(lineNum > 1){
		//计算出新增行的日期
		var forwardRow = rowNum - 1;
		var forwardWeekEndTime = document.getElementsByName("week_work_end_time_"+forwardRow)[0].value;
		if(dateCheck(forwardWeekEndTime)){
			weekStartTimes = dateAddDays(forwardWeekEndTime,1);
			weekEndTimes = dateAddDays(forwardWeekEndTime,7);
		}
	}
	
	document.getElementById("lineNum").value = lineNum;
	var tr = document.getElementById("lineTable").insertRow();
	if(rowNum % 2 == 0){
    	tr.className = "even";
	}else{
		tr.className = "odd";
	}
	tr.id=lineId;
	// 单元格
	if(dataRows < 1){
		var td = tr.insertCell();
		td.innerHTML = '<input type="text" name="team_num_'+rowNum+'" value="'+team_name+'" size="8">';
		td.rowspan = "1000";
	}
	dataRows++;
	
	tr.insertCell().innerHTML = '<input type="text" name="week_work_start_time'+'_'+rowNum+'" value="'+weekStartTimes+'" size="10"  onclick="setday(this)" readonly>';
	tr.insertCell().innerHTML = '<input type="text" name="week_work_end_time' + '_'+rowNum+'" value="'+weekEndTimes+'" size="10" onclick="setday(this)">';
	tr.insertCell().innerHTML = '<input type="text" name="natural_days' + '_'+rowNum+'" value="7" size="8" onkeypress="return key_press_int(this)" onchange="computeDays(\'natural_days\','+rowNum+');">';
	tr.insertCell().innerHTML = '<input type="text" name="product_natural_days' + '_'+rowNum+'" value="7" size="8" onkeypress="return key_press_int(this)" onchange="computeDays(\'product_natural_days\','+rowNum+');" readonly>';
	tr.insertCell().innerHTML = '<input type="text" name="product_standard_days' + '_'+rowNum+'" value="21" size="8" onkeypress="return key_press_int(this)" onchange="computeDays(\'product_standard_days\','+rowNum+');" readonly>';
	tr.insertCell().innerHTML = '<input type="text" name="shutdown_test_days' + '_'+rowNum+'" size="8" onkeypress="return key_press_int(this)" onchange="computeDays(\'shutdown_test_days\','+rowNum+');">';
	tr.insertCell().innerHTML = '<input type="text" name="shutdown_overhaul_days' + '_'+rowNum+'" size="8" onkeypress="return key_press_int(this)" onchange="computeDays(\'shutdown_overhaul_days\','+rowNum+');">';
	tr.insertCell().innerHTML = '<input type="text" name="shutdown_organization_days' + '_'+rowNum+'" size="8" onkeypress="return key_press_int(this)" onchange="computeDays(\'shutdown_organization_days\','+rowNum+');">';
	tr.insertCell().innerHTML = '<input type="text" name="shutdown_natural_days' + '_'+rowNum+'" size="8" onkeypress="return key_press_int(this)" onchange="computeDays(\'shutdown_natural_days\','+rowNum+');">';
	tr.insertCell().innerHTML = '<input type="text" name="shutdown_others' + '_'+rowNum+'" size="8" onkeypress="return key_press_int(this)" onchange="computeDays(\'shutdown_others\','+rowNum+');">';
	tr.insertCell().innerHTML = '<input type="text" name="product_shot_num' + '_'+rowNum+'" size="8" onkeypress="return key_press_int(this)" onchange="computeSum(\'product_shot_num\');">';
	tr.insertCell().innerHTML = '<input type="text" name="project_avg_daily_activity' + '_'+rowNum+'" size="8" onkeypress="return key_press_int(this)">';
	tr.insertCell().innerHTML = '<input type="text" name="acq_avg_daily_activity' + '_'+rowNum+'" size="8" onkeypress="return key_press_int(this)">';
	tr.insertCell().innerHTML = '<input type="text" name="acq_max_daily_activity' + '_'+rowNum+'" size="8" onkeypress="return key_press_int(this)">';
	tr.insertCell().innerHTML = '<input type="text" name="notes_'+rowNum+'" size="10">';
	tr.insertCell().innerHTML = '<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + lineId + '\')"/>'
	+'<input type="hidden" name="bsflag' + '_' + rowNum + '" value="0"/>'
	+'<input type="hidden" name="record_id' + '_' + rowNum + '" value=""/><input type="hidden" name="order" class="input_width" value="'+lineNum+'"></td>';
	
	computeSum("natural_days");
	computeSum("product_natural_days");
	computeSum("product_standard_days");
	computeSum("shutdown_test_days");
	computeSum("shutdown_overhaul_days");
	computeSum("shutdown_organization_days");
	computeSum("shutdown_natural_days");
	computeSum("shutdown_others");
	computeSum("product_shot_num");
}

function initData(){
	//获取队号
	var retPrj = jcdpCallService("TaskBookSrv", "getProjectInfo", "");
	if(retPrj.project != null){
		team_name = retPrj.project.team_name;
	}
	//加载数据
	var retObj = jcdpCallService("AgingAnalysisSrv","readDailyReport","");
	if(retObj.projectStartDate != null){
		var td = document.getElementById("tdProjectDate");
		td.innerHTML = "项目运行起始时间:"+retObj.projectStartDate;
	}
	if(retObj.datas != null){
		var allRows = retObj.datas.length - 1;
		for(var i=0;i<allRows;i++){
			var record = retObj.datas[i];
			var rowNum = i;
			var lineId = "row_" + rowNum + "_";
			var lineNum = parseInt(rowNum)+1;
			var insertIndex = 4 + i;
			var tr = document.getElementById("lineTable").insertRow(insertIndex);
			if(rowNum % 2 == 0){
    			tr.className = "even";
			}else{
				tr.className = "odd";
			}
			tr.id=lineId;
			// 单元格
			if(dataRows < 1){
				var td = tr.insertCell();
				td.rowSpan = allRows;
				td.innerHTML = team_name;
			}
			dataRows++;
			tr.insertCell().innerHTML = record.week_work_start_time;
			tr.insertCell().innerHTML = record.week_work_end_time;
			tr.insertCell().innerHTML = record.natural_days;
			tr.insertCell().innerHTML = record.product_natural_days;
			tr.insertCell().innerHTML = record.product_standard_days;
			tr.insertCell().innerHTML = record.shutdown_test_days;
			tr.insertCell().innerHTML = record.shutdown_overhaul_days;
			tr.insertCell().innerHTML = record.shutdown_organization_days;
			tr.insertCell().innerHTML = record.shutdown_natural_days;
			tr.insertCell().innerHTML = record.shutdown_others;
			tr.insertCell().innerHTML = record.product_shot_num;
			tr.insertCell().innerHTML = record.project_avg_daily_activity;
			tr.insertCell().innerHTML = record.acq_avg_daily_activity;
			tr.insertCell().innerHTML = record.acq_max_daily_activity;
			//tr.insertCell().innerHTML = '<input type="hidden" name="bsflag' + '_' + rowNum + '" value="0"/>'
			//+'<input type="hidden" name="record_id' + '_' + rowNum + '" value="'+record.record_id+'" /><input type="hidden" name="order" class="input_width" value="'+lineNum+'"></td>';
			
			var exportRow = {};
			exportRow["1"] = team_name;
			exportRow["2"] = record.week_work_start_time;
			exportRow["3"] = record.week_work_end_time;
			exportRow["4"] = record.natural_days;
			exportRow["5"] = record.product_natural_days;
			exportRow["6"] = record.product_standard_days;
			exportRow["7"] = record.shutdown_test_days;
			exportRow["8"] = record.shutdown_overhaul_days;
			exportRow["9"] = record.shutdown_organization_days;
			exportRow["10"] = record.shutdown_natural_days;
			exportRow["11"] = record.shutdown_others;
			exportRow["12"] = record.product_shot_num;
			exportRow["13"] = record.project_avg_daily_activity;
			exportRow["14"] = record.acq_avg_daily_activity;
			exportRow["15"] = record.acq_max_daily_activity;
			exportRows[exportRows.length] = exportRow;
		}
		document.getElementById("trlinesum").style.display = "block";
		//加载汇总数据
		var record = retObj.datas[allRows];
		document.getElementById("sum_week_work_start_time").innerHTML = record.week_work_start_time;
		document.getElementById("sum_week_work_end_time").innerHTML = record.week_work_end_time;
		document.getElementById("sum_natural_days").innerHTML = record.natural_days;
		document.getElementById("sum_product_natural_days").innerHTML = record.product_natural_days;
		document.getElementById("sum_product_standard_days").innerHTML = record.product_standard_days;
		document.getElementById("sum_shutdown_test_days").innerHTML = record.shutdown_test_days;
		document.getElementById("sum_shutdown_overhaul_days").innerHTML = record.shutdown_overhaul_days;
		document.getElementById("sum_shutdown_organization_days").innerHTML = record.shutdown_organization_days;
		document.getElementById("sum_shutdown_natural_days").innerHTML = record.shutdown_natural_days;
		document.getElementById("sum_shutdown_others").innerHTML = record.shutdown_others;
		document.getElementById("sum_product_shot_num").innerHTML = record.product_shot_num;
		document.getElementById("sum_project_avg_daily_activity").innerHTML = record.project_avg_daily_activity;
		document.getElementById("sum_acq_avg_daily_activity").innerHTML = record.acq_avg_daily_activity;
		document.getElementById("sum_acq_max_daily_activity").innerHTML = record.acq_max_daily_activity;
		
		var sumRow = {};
		sumRow["1"] = "合计";
		sumRow["2"] = record.week_work_start_time;
		sumRow["3"] = record.week_work_end_time;
		sumRow["4"] = record.natural_days;
		sumRow["5"] = record.product_natural_days;
		sumRow["6"] = record.product_standard_days;
		sumRow["7"] = record.shutdown_test_days;
		sumRow["8"] = record.shutdown_overhaul_days;
		sumRow["9"] = record.shutdown_organization_days;
		sumRow["10"] = record.shutdown_natural_days;
		sumRow["11"] = record.shutdown_others;
		sumRow["12"] = record.product_shot_num;
		sumRow["13"] = record.project_avg_daily_activity;
		sumRow["14"] = record.acq_avg_daily_activity;
		sumRow["15"] = record.acq_max_daily_activity;
		exportRows[exportRows.length] = sumRow;
			
	}
}
function toSave(){
	var rowParams = new Array();
	var orders=document.getElementsByName("order");
	for(var i=0;i<orders.length;i++){
		var rowParam = {};
		var order = orders[i].value;
		var rowNum = order - 1;
		var bsflag = document.getElementsByName("bsflag_"+rowNum)[0].value; 
		var record_id = document.getElementsByName("record_id_"+rowNum)[0].value;
		rowParam['order_num'] = order;
		rowParam['team_num'] = document.getElementsByName("team_num_0")[0].value; 
		rowParam['week_work_start_time'] = document.getElementsByName("week_work_start_time_"+rowNum)[0].value; 
		rowParam['week_work_end_time'] = document.getElementsByName("week_work_end_time_"+rowNum)[0].value; 
		
		//
		//var field_workteam_month = document.getElementsByName("field_workteam_month"+"_"+rowNum)[0].value;
		//if(field_workteam_month.length > 0){
		//	rowParam['field_workteam_month'] = field_workteam_month;
		//}
		//
		var natural_days = document.getElementsByName("natural_days"+"_"+rowNum)[0].value;
		if(natural_days.length > 0){
			rowParam['natural_days'] = natural_days;
		}
		//
		var product_natural_days = document.getElementsByName("product_natural_days"+"_"+rowNum)[0].value;
		if(product_natural_days.length > 0){
			rowParam['product_natural_days'] = product_natural_days;
		}
		//
		var product_standard_days = document.getElementsByName("product_standard_days"+"_"+rowNum)[0].value;
		if(product_standard_days.length > 0){
			rowParam['product_standard_days'] = product_standard_days;
		}
		//
		var shutdown_test_days = document.getElementsByName("shutdown_test_days"+"_"+rowNum)[0].value;
		if(shutdown_test_days.length > 0){
			rowParam['shutdown_test_days'] = shutdown_test_days;
		}
		//
		var shutdown_overhaul_days = document.getElementsByName("shutdown_overhaul_days"+"_"+rowNum)[0].value;
		if(shutdown_overhaul_days.length > 0){
			rowParam['shutdown_overhaul_days'] = shutdown_overhaul_days;
		}
		//
		var shutdown_organization_days = document.getElementsByName("shutdown_organization_days"+"_"+rowNum)[0].value;
		if(shutdown_organization_days.length > 0){
			rowParam['shutdown_organization_days'] = shutdown_organization_days;
		}
		//
		var shutdown_natural_days = document.getElementsByName("shutdown_natural_days"+"_"+rowNum)[0].value;
		if(shutdown_natural_days.length > 0){
			rowParam['shutdown_natural_days'] = shutdown_natural_days;
		}
		//
		var shutdown_others = document.getElementsByName("shutdown_others"+"_"+rowNum)[0].value;
		if(shutdown_others.length > 0){
			rowParam['shutdown_others'] = shutdown_others;
		}
		//
		var product_shot_num = document.getElementsByName("product_shot_num"+"_"+rowNum)[0].value;
		if(product_shot_num.length > 0){
			rowParam['product_shot_num'] = product_shot_num;
		}
		//
		var project_avg_daily_activity = document.getElementsByName("project_avg_daily_activity"+"_"+rowNum)[0].value;
		if(project_avg_daily_activity.length > 0){
			rowParam['project_avg_daily_activity'] = project_avg_daily_activity;
		}
		//
		var acq_avg_daily_activity = document.getElementsByName("acq_avg_daily_activity"+"_"+rowNum)[0].value;
		if(acq_avg_daily_activity.length > 0){
			rowParam['acq_avg_daily_activity'] = acq_avg_daily_activity;
		}
		//
		var acq_max_daily_activity = document.getElementsByName("acq_max_daily_activity"+"_"+rowNum)[0].value;
		if(acq_max_daily_activity.length > 0){
			rowParam['acq_max_daily_activity'] = acq_max_daily_activity;
		}
		rowParam['notes'] = document.getElementsByName("notes"+"_"+rowNum)[0].value;
		
		if(record_id !=""){
			rowParam['record_id'] = record_id;
		}
		rowParam['create_id'] = '<%=userId%>';
		rowParam['mondify_id'] = '<%=userId%>';
		rowParam['create_date'] = '<%=curDate%>';
		rowParam['mondify_date'] = '<%=curDate%>';
		rowParam['bsflag'] = bsflag;
		rowParam['project_info_no'] = '<%=projectInfoNo%>';
		
		rowParams[rowParams.length] = rowParam;
	}
	var rows=JSON.stringify(rowParams);
	
	saveFunc("gp_ops_aging_analysis",rows);
}

function deleteLine(lineId){		
	var rowNum = lineId.split('_')[1];
	var line = document.getElementById(lineId);		

	var dynamic_id = document.getElementsByName("record_id_"+rowNum)[0].value;
	if(dynamic_id!=""){
		line.style.display = 'none';
		document.getElementsByName("bsflag_"+rowNum)[0].value = '1';
	}else{
		var lineNum = document.getElementById("lineNum").value;
		lineNum = parseInt(lineNum) - 1;
		document.getElementById("lineNum").value = lineNum;
		line.parentNode.removeChild(line);
	}
	if(dataRows > 0){
		computeSum("natural_days");
		computeSum("product_natural_days");
		computeSum("product_standard_days");
		computeSum("shutdown_test_days");
		computeSum("shutdown_overhaul_days");
		computeSum("shutdown_organization_days");
		computeSum("shutdown_natural_days");
		computeSum("shutdown_others");
		computeSum("product_shot_num");
	}
	dataRows--;	
}

function key_press_int(obj)
{
	var keycode = event.keyCode;
	if(keycode > 57 || keycode < 45 || keycode==47)
	{
		return false;
	}
	var reg = /^[0-9]{0,13}?$/;
	var nextvalue = obj.value+String.fromCharCode(keycode);
	if(!(reg.test(nextvalue)))return false;
	return true;
}

function key_press_double(obj)
{
	var keycode = event.keyCode;
	if(keycode > 57 || keycode < 45 || keycode==47)
	{
		return false;
	}
	var reg = /^[0-9]{0,13}(\.[0-9]{0,2})?$/;
	var nextvalue = obj.value+String.fromCharCode(keycode);
	if(!(reg.test(nextvalue)))return false;
	return true;
}

//设置周结束时间
function setWeekEnd(rowNum){
	var weekStartTimes = document.getElementsByName("week_work_start_time_"+rowNum)[0].value;
	if(dateCheck(weekStartTimes)){
		var weekEndTimes = dateAddDays(weekStartTimes ,6);
		//赋值
		document.getElementsByName("week_work_end_time_"+rowNum)[0].value = weekEndTimes;
	}
}

function dateAddDays(dd,dadd)
{
	dd = dd.replace(/\-/g,"/");
	var a = new Date(dd);
	a = a.valueOf();
	a = a + dadd * 24 * 60 * 60 * 1000;
	a = new Date(a);
	return a.getFullYear() + "-" + (a.getMonth() + 1) + "-" + a.getDate();
}

function dateCheck(dd){ 
	var a=/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})/;
	if (!a.test(dd)){
		return false;
	}
	else{
		return true;
	}
}

function selectedAfter()
{
	if(outObject.name.indexOf('start') > 0){
		var str = outObject.name.split("_");
		var num = str[str.length - 1];
  		setWeekEnd(num);
  		dateChange(num);
  	}else{
  		var str = outObject.name.split("_");
		var num = str[str.length - 1];
  		dateChange(num);
  	}
}

function activeInput(){
	if(bActive == true){
		return;
	}
	var nodeList = document.getElementsByTagName("input");
    for (var i = 0; i < nodeList.length; i++) {
		nodeList[i].disabled = false;
    }
    bActive = true;
}

function dataSum(obj){
	var sumValue;
	var orders=document.getElementsByName("order");
	//循环行得到改变的列 所有值
	for(var i=0;i<orders.length;i++){
		var order = orders[i].value;
		var rowNum = order - 1;
		var columnValue = document.getElementsByName(obj.name+"_"+rowNum)[0].value;
		sumValue = sumValue + columnValue;
	}
	document.getElementsByName("sum_"+obj.name+"_"+rowNum)[0].value = sumValue;
}

function dateChange(rowIndex){
	// 得出汇总行的最小日期
	var minDate = document.getElementsByName("week_work_start_time_0")[0].value;
	//var orders=document.getElementsByName("order");
	//for(var i=0;i<orders.length;i++){
	//	var order = orders[i].value;
	//	var rowNum = order - 1;
	//	var startDate = document.getElementsByName("week_work_start_time_"+rowNum)[0].value;
	//	if(i==0){
	//		minDate = startDate;
	//		continue;
	//	}
	//	//比较得出最小日期todo
	//}
	document.getElementsByName("sum_week_work_start_time")[0].value = minDate;
	
	// 得出汇总行的最大日期
	var rowNum = document.getElementById("lineNum").value;
	rowNum = rowNum - 1;
	var maxDate = document.getElementsByName("week_work_end_time_"+rowNum)[0].value;
	document.getElementsByName("sum_week_work_end_time")[0].value = maxDate;
	
	computeDailyActivity(rowIndex);
	sumDailyActivity();
}

function naturalDaysChange(rowIndex){
	computeDailyActivity(rowIndex);
	sumDailyActivity();
}

function computeDailyActivity(rowIndex){
	var startDate = document.getElementsByName("week_work_start_time_"+rowIndex)[0].value;
	var endDate = document.getElementsByName("week_work_end_time_"+rowIndex)[0].value;
	
	var colName ="daily_finishing_3d_sp";
	if(workmethod == "0300100012000000002"){
		colName = "daily_finishing_2d_sp";
	}
	
	//所选日期内累积完成炮数
	var shotNumSql = "select nvl(sum("+colName+"),0) as shot_nums from rpt_gp_daily where send_date >= to_date('"+startDate+"','yyyy-MM-dd') and send_date <= to_date('"+endDate+"','yyyy-MM-dd') and project_info_no = '"+ projectInfoNo+"'";
	//var shotNumSql = "select sum(nvl(daily_finishing_3d_sp,0)) as shot_nums from rpt_gp_daily where project_info_no ='8ad878dd39aefd8a0139b3320af9018e'";
	var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+shotNumSql);
	var shot_nums = retObj.datas[0].shot_nums;
	document.getElementsByName("product_shot_num_"+rowIndex)[0].value = shot_nums;
	
	//计算采集平均日效
	var natural_days = document.getElementsByName("natural_days_"+rowIndex)[0].value
	if(natural_days.length > 0 && natural_days != "0"){
		var acq_avg_daily_activity = parseInt(shot_nums)/parseInt(natural_days);
		acq_avg_daily_activity = Math.round(acq_avg_daily_activity*100)/100;
		document.getElementsByName("acq_avg_daily_activity_"+rowIndex)[0].value = acq_avg_daily_activity;
	}
	
	//项目平均日效,起始至今的天数
	var shotNumSql = "select nvl(sum("+colName+"),0) as shot_nums from rpt_gp_daily where send_date <= sysdate and project_info_no = '"+ projectInfoNo+"'";
	var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+shotNumSql);
	var shot_nums = retObj.datas[0].shot_nums;
	
	var diffDaySql = "select nvl(floor(sysdate - min(send_date)),0) as diff_days from rpt_gp_daily where project_info_no = '"+ projectInfoNo+"'";
	//var diffDaySql = "select count(*) as diff_days from rpt_gp_daily where work_status ='采集' and send_date <= sysdate and project_info_no = '"+ projectInfoNo+"'";
	var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+diffDaySql);
	var diff_days = retObj.datas[0].diff_days;
	if(diff_days != "0"){
		var project_avg_daily_activity = parseInt(shot_nums)/parseInt(diff_days);
		project_avg_daily_activity = Math.round(project_avg_daily_activity*100)/100;
		document.getElementsByName("project_avg_daily_activity_"+rowIndex)[0].value = project_avg_daily_activity;
	}
	
	//本周日完成最高值
	var shotNumSql = "select max("+colName+") as shot_nums from rpt_gp_daily where send_date >= to_date('"+startDate+"','yyyy-MM-dd') and send_date <= to_date('"+endDate+"','yyyy-MM-dd') and project_info_no = '"+ projectInfoNo+"'";
	
	var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+shotNumSql);
	var shot_nums = retObj.datas[0].shot_nums;
	document.getElementsByName("acq_max_daily_activity_"+rowIndex)[0].value = shot_nums;
}

function sumDailyActivity(){
	var startDate = document.getElementsByName("sum_week_work_start_time")[0].value;
	var endDate = document.getElementsByName("sum_week_work_end_time")[0].value;
	
	var colName ="daily_finishing_3d_sp";
	if(workmethod == "0300100012000000002"){
		colName = "daily_finishing_2d_sp";
	}
	
	//所选日期内累积完成炮数
	var shotNumSql = "select nvl(sum("+colName+"),0) as shot_nums from rpt_gp_daily where send_date >= to_date('"+startDate+"','yyyy-MM-dd') and send_date <= to_date('"+endDate+"','yyyy-MM-dd') and project_info_no = '"+ projectInfoNo+"'";
	
	var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+shotNumSql);
	var shot_nums = retObj.datas[0].shot_nums;
	document.getElementsByName("sum_product_shot_num")[0].value = shot_nums;
	
	//计算采集平均日效
	var natural_days = document.getElementsByName("sum_natural_days")[0].value
	if(natural_days.length > 0 && natural_days != "0"){
		var acq_avg_daily_activity = parseInt(shot_nums)/parseInt(natural_days);
		acq_avg_daily_activity = Math.round(acq_avg_daily_activity*100)/100;
		document.getElementsByName("sum_acq_avg_daily_activity")[0].value = acq_avg_daily_activity;
	}
	
	//项目平均日效,起始至今的天数
	var shotNumSql = "select nvl(sum("+colName+"),0) as shot_nums from rpt_gp_daily where send_date <= sysdate and project_info_no = '"+ projectInfoNo+"'";
	var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+shotNumSql);
	var shot_nums = retObj.datas[0].shot_nums;
	
	var diffDaySql = "select nvl(floor(sysdate - min(send_date)),0) as diff_days from rpt_gp_daily where project_info_no = '"+ projectInfoNo+"'";
	//var diffDaySql = "select count(*) as diff_days from rpt_gp_daily where work_status ='采集' and send_date <= sysdate and project_info_no = '"+ projectInfoNo+"'";
	var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+diffDaySql);
	var diff_days = retObj.datas[0].diff_days;
	if(diff_days != "0"){
		var project_avg_daily_activity = parseInt(shot_nums)/parseInt(diff_days);
		project_avg_daily_activity = Math.round(project_avg_daily_activity*100)/100;
		document.getElementsByName("sum_project_avg_daily_activity")[0].value = project_avg_daily_activity;
	}
	
	//本周日完成最高值
	var shotNumSql = "select max("+colName+") as shot_nums from rpt_gp_daily where send_date >= to_date('"+startDate+"','yyyy-MM-dd') and send_date <= to_date('"+endDate+"','yyyy-MM-dd') and project_info_no = '"+ projectInfoNo+"'";
	var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+shotNumSql);
	var shot_nums = retObj.datas[0].shot_nums;
	document.getElementsByName("sum_acq_max_daily_activity")[0].value = shot_nums;
}

function computeSum(colName){
	var orders=document.getElementsByName("order");
	var sumValue = 0;
	for(var i=0;i<orders.length;i++){
		var order = orders[i].value;
		var rowNum = order - 1;
		
		var bsflag = document.getElementsByName("bsflag_"+rowNum)[0].value;
		if(bsflag == "1"){
			continue;
		}
		var cellValue = document.getElementsByName(colName + "_" + rowNum)[0].value;
		if(cellValue.length > 0){
			sumValue += parseInt(cellValue);
		}
	}
	document.getElementsByName("sum_" + colName)[0].value = sumValue;
}

function computeDays(colName, rowIndex){	
	//计算当前行的其他列
	var natural_days = document.getElementsByName("natural_days_"+rowIndex)[0].value;
	if(natural_days > 0){
		natural_days = parseInt(natural_days);
	}else{
		return;
	}
	var product_natural_days = natural_days;
	
	var shutdown_test_days = document.getElementsByName("shutdown_test_days_"+rowIndex)[0].value;
	var shutdown_overhaul_days = document.getElementsByName("shutdown_overhaul_days_"+rowIndex)[0].value;
	var shutdown_organization_days = document.getElementsByName("shutdown_organization_days_"+rowIndex)[0].value;
	var shutdown_natural_days = document.getElementsByName("shutdown_natural_days_"+rowIndex)[0].value;
	var shutdown_others = document.getElementsByName("shutdown_others_"+rowIndex)[0].value;
	if(shutdown_test_days.length > 0){
		product_natural_days = product_natural_days - parseInt(shutdown_test_days);
	}
	if(shutdown_overhaul_days.length > 0){
		product_natural_days = product_natural_days - parseInt(shutdown_overhaul_days);
	}
	if(shutdown_organization_days.length > 0){
		product_natural_days = product_natural_days - parseInt(shutdown_organization_days);
	}
	if(shutdown_natural_days.length > 0){
		product_natural_days = product_natural_days - parseInt(shutdown_natural_days);
	}
	if(shutdown_others.length > 0){
		product_natural_days = product_natural_days - parseInt(shutdown_others);
	}
	var product_standard_days = parseInt(product_natural_days) * 3;
	document.getElementsByName("product_natural_days_"+rowIndex)[0].value = product_natural_days;
	document.getElementsByName("product_standard_days_"+rowIndex)[0].value = product_standard_days;
	
	//汇总改变的列值
	computeSum(colName);
	computeSum("product_natural_days");
	computeSum("product_standard_days");
	if(colName == "natural_days"){
		naturalDaysChange(rowIndex);
	}
}

function exportExcel(){
	var path = cruConfig.contextPath+"/pm/exportDataToExcel.srq";
	var rows=JSON.stringify(exportRows);
	var fromPage = "agingAnalysis";
	var submitStr = "fromPage=" + fromPage + "&projectName="+projectName+"&dataRows="+rows;
	var retObj = syncRequest("post", path, submitStr);
	window.location=cruConfig.contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname=" + fromPage + ".xls";
}
</script>
</head>
<body style="background:#fff;overflow-y:auto;overflow-x:auto;" onload="initData()" width="800px">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			    <td width="90%" align="center"><font size="3"><%=projectName%>项目时效分析表</font></td>
			    <td width="10%">
			    <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  		<tr>
			    		<td>&nbsp;</td>
			    		<auth:ListButton functionId="" css="dc" event="onclick='exportExcel()'" title="导出excel"></auth:ListButton>
			  		</tr>
				</table>
				</td>
			   <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
		</tr>
</table>
<div id="scrollDiv" class="scrollDiv" >
<table id="lineTable" width="100%" border="0" cellspacing="0"  align="center" cellpadding="0" class="scrolltable">
    <thead>
    <tr class="scrollColThead td_head">
    	<td colspan="13" width="50%"></td>
    	<td colspan="2" width="50%" align="right" id="tdProjectDate" nowrap>项目运行起始时间:</td>
    </tr>
    <tr class="scrollColThead td_head">
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td colspan="7">时间利用(日)</td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
    </tr>
    <tr class="scrollColThead td_head">
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td colspan="2">生产天数</td>
      <td colspan="5">停工天数</td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
    </tr>
    <tr class="scrollColThead td_head">
      <td nowrap>&nbsp;&nbsp;队号&nbsp;&nbsp;</td>
      <td nowrap>&nbsp;周施工起始时间&nbsp;</td>
      <td nowrap>&nbsp;周施工结束时间&nbsp;</td>
      <td nowrap>&nbsp;自然天数&nbsp;</td>
      <td nowrap>&nbsp;自然日&nbsp;</td>
      <td nowrap>&nbsp;标准日&nbsp;</td>
         <!--   <td nowrap>&nbsp;&nbsp;试验&nbsp;&nbsp;</td>
      <td nowrap>&nbsp;&nbsp;检修&nbsp;&nbsp;</td>
      <td nowrap>&nbsp;组织停工&nbsp;</td>
      <td nowrap>&nbsp;自然停工&nbsp;</td>  shishengjie-->
       <td nowrap>&nbsp;&nbsp;气候&nbsp;&nbsp;</td>
      <td nowrap>&nbsp;&nbsp;施工协调&nbsp;&nbsp;</td>
      <td nowrap>&nbsp;油公司因素&nbsp;</td>
      <td nowrap>&nbsp;突发事件&nbsp;</td>
      <td nowrap>&nbsp;&nbsp;其它&nbsp;&nbsp;</td>
      <td nowrap>&nbsp;&nbsp;生产炮数&nbsp;&nbsp;</td>
      <td nowrap>项目平均</br>日效(炮)</td>
      <td nowrap>采集平均</br>日效(炮)</td>
      <td nowrap>采集最高</br>效率(炮)</td>
    </tr>
    <tr class="odd" style="display:none" id="trlinesum">
		<td align="center">合计</td>
		<td id="sum_week_work_start_time"></td>
		<td id="sum_week_work_end_time"></td>
		<td id="sum_natural_days" size="8"></td>
		<td id="sum_product_natural_days"></td>
		<td id="sum_product_standard_days"></td>
		<td id="sum_shutdown_test_days"></td>
		<td id="sum_shutdown_overhaul_days"></td>
		<td id="sum_shutdown_organization_days"></td>
		<td id="sum_shutdown_natural_days"></td>
		<td id="sum_shutdown_others"></td>
		<td id="sum_product_shot_num"></td>
		<td id="sum_project_avg_daily_activity"></td>
		<td id="sum_acq_avg_daily_activity"></td>
		<td id="sum_acq_max_daily_activity"></td>
	</tr>
	</thead>
</table>
</div>
</body>
</html>
