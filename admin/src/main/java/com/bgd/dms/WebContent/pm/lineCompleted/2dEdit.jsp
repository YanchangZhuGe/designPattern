<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String userId =  user.getEmpId();
	String projectName = user.getProjectName();
	String projectInfoNo = user.getProjectInfoNo();
	String contextPath = request.getContextPath();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());
	String message = "";
	if(resultMsg != null){
		message = resultMsg.getValue("message");
	}
%>
<html>
<head>
<title>项目情况</title>
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
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<style type="text/css">
body,table, td {font-size:12px;font-weight:normal;}
/* 重点：固定行头样式*/  
.scrollRowThead{BACKGROUND-COLOR: #AEC2E6;position: relative; left: expression(this.parentElement.parentElement.parentElement.parentElement.scrollLeft);z-index:0;}  
/* 重点：固定表头样式*/  
.scrollColThead {position: relative;top: expression(this.parentElement.parentElement.parentElement.scrollTop);z-index:2;}  
/* 行列交叉的地方*/  
.scrollCR{ z-index:3;}
/*div 外框*/  
.scrollDiv {height:360;clear: both; border: 1px solid #94B6E6;OVERFLOW: scroll;width: 100%; }  
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

var message = "<%=message%>";
if(message != "" && message != 'null'){
	alert(message);
}

var projectName = "<%=projectName%>";
var bActive = false;
var team_name = "";
var dataRows = 0;
var insertIndex = 3;
var exportRows = new Array();

function toAdd(){
	var rowNum = document.getElementById("lineNum").value;
	var lineId = "row_" + rowNum + "_";
	var lineNum = parseInt(rowNum)+1;
	document.getElementById("lineNum").value = lineNum;
	var tr = document.getElementById("lineTable").insertRow(insertIndex);
	insertIndex++;
	if(rowNum % 2 == 0){
    	tr.className = "even";
	}else{
		tr.className = "odd";
	}
	tr.id=lineId;
	// 单元格
	if(dataRows < 1){
		var td = tr.insertCell();
		td.rowSpan = 1000;
		td.className = "scrollRowThead";
		td.innerHTML = '<input type="text" name="team_num_'+rowNum+'" value="'+team_name+'" size="8">';
	}
	dataRows++;
	var td = tr.insertCell();
	td.className = "scrollRowThead";
	td.innerHTML = '<input type="hidden" name="order" class="input_width" value="'+lineNum+'">'
								+'<input type="text" name="serialnum" size="3" value="'+lineNum+'" onkeypress="return key_press_check(this)">';
	var td = tr.insertCell();
	td.className = "scrollRowThead";
	td.innerHTML = '<input type="text" name="line_id_'+rowNum+'" size="10">';
	tr.insertCell().innerHTML = '<input type="text" name="measure_fold_num_'+rowNum+'" size="8" onkeypress="return key_press_check(this)">';
	tr.insertCell().innerHTML = '<input type="text" name="measure_fullfold_start_pile_'+rowNum+'" size="10" onkeypress="return key_press_check(this)">';
	tr.insertCell().innerHTML = '<input type="text" name="measure_fullfold_end_pile_'+rowNum+'" size="10" onkeypress="return key_press_check(this)">';
	tr.insertCell().innerHTML = '<input type="text" name="measure_fullfold_kilo_num_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'measure_fullfold_kilo_num\')">';
	tr.insertCell().innerHTML = '<input type="text" name="measure_shot_num_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'measure_shot_num\')">';
	tr.insertCell().innerHTML = '<input type="text" name="profile_fold_num_'+rowNum+'" size="8" onkeypress="return key_press_check(this)">';
	tr.insertCell().innerHTML = '<input type="text" name="profile_fullfold_start_pile_'+rowNum+'" size="10" onkeypress="return key_press_check(this)">';
	tr.insertCell().innerHTML = '<input type="text" name="profile_fullfold_end_pile_'+rowNum+'" size="10" onkeypress="return key_press_check(this)">';
	tr.insertCell().innerHTML = '<input type="text" name="full_fold_len_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'full_fold_len\')">';
	tr.insertCell().innerHTML = '<input type="text" name="physical_shot_kilo_num_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'physical_shot_kilo_num\')">';
	tr.insertCell().innerHTML = '<input type="text" name="record_num_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computeShotSum('+rowNum+');">';
	tr.insertCell().innerHTML = '<input type="text" name="acceptable_product_num_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computePrcentage(\'acceptable_product_num\',\'qualifier_ratio\','+rowNum+');">';
	tr.insertCell().innerHTML = '<input type="text" name="qualifier_ratio_'+rowNum+'" size="6" readonly>';
	tr.insertCell().innerHTML = '<input type="text" name="first_num_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computePrcentage(\'first_num\',\'first_ratio\','+rowNum+');">';
	tr.insertCell().innerHTML = '<input type="text" name="first_ratio_'+rowNum+'" size="6" readonly>';
	tr.insertCell().innerHTML = '<input type="text" name="seconde_num_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computePrcentage(\'seconde_num\',\'seconde_ratio\','+rowNum+');">';
	tr.insertCell().innerHTML = '<input type="text" name="seconde_ratio_'+rowNum+'" size="6" readonly>';
	tr.insertCell().innerHTML = '<input type="text" name="defective_product_num_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computePrcentage(\'defective_product_num\',\'defective_product_ratio\','+rowNum+');">';
	tr.insertCell().innerHTML = '<input type="text" name="defective_product_ratio_'+rowNum+'" size="6" readonly>';
	tr.insertCell().innerHTML = '<input type="text" name="no_shoot_num_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computePrcentage(\'no_shoot_num\',\'no_shoot_ratio\','+rowNum+');">';
	tr.insertCell().innerHTML = '<input type="text" name="no_shoot_ratio_'+rowNum+'" size="6" readonly>';
	tr.insertCell().innerHTML = '<input type="text" name="design_encrypt_sum_num_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'design_encrypt_sum_num\')">';
	tr.insertCell().innerHTML = '<input type="text" name="infill_sp_num_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'infill_sp_num\')">';
	tr.insertCell().innerHTML = '<input type="text" name="construct_begin_end_date_'+rowNum+'" size="20">';
	tr.insertCell().innerHTML = '<input type="text" name="notes_'+rowNum+'" size="12">';
	tr.insertCell().innerHTML = '<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + lineId + '\')"/>'
	+'<input type="hidden" name="bsflag' + '_' + rowNum + '" value="0"/>'
	+'<input type="hidden" name="record_id' + '_' + rowNum + '" value=""/></td>';
	
	document.getElementById("trlinesum").style.display = "block";
}

function deleteLine(lineId){		
	var rowNum = lineId.split('_')[1];
	var line = document.getElementById(lineId);		

	var dynamic_id = document.getElementsByName("record_id_"+rowNum)[0].value;
	if(dynamic_id!=""){
		line.style.display = 'none';
		document.getElementsByName("bsflag_"+rowNum)[0].value = '1';
		insertIndex--;
	}else{
		var lineNum = document.getElementById("lineNum").value;
		lineNum = parseInt(lineNum) - 1;
		document.getElementById("lineNum").value = lineNum;
		line.parentNode.removeChild(line);
		insertIndex--;
	}
}


function initData(){
	//获取队号
	var retPrj = jcdpCallService("TaskBookSrv", "getProjectInfo", "");
	if(retPrj.project != null){
		team_name = retPrj.project.team_name;
		team_name = team_name.replace("东方地球物理公司"," ");
	}
	//加载数据
	var retObj = jcdpCallService("DBDataSrv","queryTableDatas","tableName=gp_ops_wa2d_line_finish&option=bsflag='0'%20and%20project_info_no='<%=projectInfoNo%>'&order=order_num");
	if(retObj.datas != null){
		for(var i=0;i<retObj.datas.length;i++){
			var record = retObj.datas[i];
			var rowNum = i;
			var lineId = "row_" + rowNum + "_";
			var lineNum = parseInt(rowNum)+1;
			var tr = document.getElementById("lineTable").insertRow(insertIndex);
			insertIndex++;
			if(rowNum % 2 == 0){
    			tr.className = "even";
			}else{
				tr.className = "odd";
			}
			tr.id=lineId;
			// 单元格
			if(dataRows < 1){
				var td = tr.insertCell();
				td.rowSpan = 1000;
				td.className = "scrollRowThead";
				td.innerHTML = '<input type="text" name="team_num_'+rowNum+'" value="'+team_name+'" size="8" readonly>';
			}
			dataRows++;
			var td = tr.insertCell();
			td.className = "scrollRowThead";
			td.innerHTML = '<input type="hidden" name="order" class="input_width" value="'+lineNum+'">'
										+'<input type="text" name="serialnum" size="3" value="'+lineNum+'" readonly onkeypress="return key_press_check(this)">';
			var td = tr.insertCell();
			td.className = "scrollRowThead";
			td.innerHTML = '<input type="text" name="line_id_'+rowNum+'" value="'+record.line_id+'" size="10" onkeypress="return key_press_check(this)" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="measure_fold_num_'+rowNum+'" value="'+record.measure_fold_num+'" size="8" onkeypress="return key_press_check(this)" readonly >';
			tr.insertCell().innerHTML = '<input type="text" name="measure_fullfold_start_pile_'+rowNum+'" value="'+record.measure_fullfold_start_pile+'" size="10" onkeypress="return key_press_check(this)" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="measure_fullfold_end_pile_'+rowNum+'" value="'+record.measure_fullfold_end_pile+'" size="10" onkeypress="return key_press_check(this)" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="measure_fullfold_kilo_num_'+rowNum+'" value="'+record.measure_fullfold_kilo_num+'" size="8" onkeypress="return key_press_check(this)" readonly onchange="computeSum(\'measure_fullfold_kilo_num\')">';
			tr.insertCell().innerHTML = '<input type="text" name="measure_shot_num_'+rowNum+'" value="'+record.measure_shot_num+'" size="8" onkeypress="return key_press_check(this)" readonly onchange="computeSum(\'measure_shot_num\')">';
			tr.insertCell().innerHTML = '<input type="text" name="profile_fold_num_'+rowNum+'" value="'+record.profile_fold_num+'" size="8" onkeypress="return key_press_check(this)" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="profile_fullfold_start_pile_'+rowNum+'" value="'+record.profile_fullfold_start_pile+'" size="10" onkeypress="return key_press_check(this)" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="profile_fullfold_end_pile_'+rowNum+'" value="'+record.profile_fullfold_end_pile+'" size="10" onkeypress="return key_press_check(this)" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="full_fold_len_'+rowNum+'" value="'+record.full_fold_len+'" size="8" onkeypress="return key_press_check(this)" readonly onchange="computeSum(\'full_fold_len\')">';
			tr.insertCell().innerHTML = '<input type="text" name="physical_shot_kilo_num_'+rowNum+'" value="'+record.physical_shot_kilo_num+'" size="8" onkeypress="return key_press_check(this)" readonly onchange="computeSum(\'physical_shot_kilo_num\')">';
			tr.insertCell().innerHTML = '<input type="text" name="record_num_'+rowNum+'" value="'+record.record_num+'" size="8" onkeypress="return key_press_check(this)" readonly onchange="computeShotSum('+rowNum+');">';
			tr.insertCell().innerHTML = '<input type="text" name="acceptable_product_num_'+rowNum+'" value="'+record.acceptable_product_num+'" size="8" onkeypress="return key_press_check(this)" onchange="computePrcentage(\'acceptable_product_num\',\'qualifier_ratio\','+rowNum+');" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="qualifier_ratio_'+rowNum+'" value="'+record.qualifier_ratio+'" size="6" readonly readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="first_num_'+rowNum+'" value="'+record.first_num+'" size="8" onkeypress="return key_press_check(this)" onchange="computePrcentage(\'first_num\',\'first_ratio\','+rowNum+');" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="first_ratio_'+rowNum+'" value="'+record.first_ratio+'" size="6" readonly readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="seconde_num_'+rowNum+'" value="'+record.seconde_num+'" size="8" onkeypress="return key_press_check(this)" onchange="computePrcentage(\'seconde_num\',\'seconde_ratio\','+rowNum+');" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="seconde_ratio_'+rowNum+'" value="'+record.seconde_ratio+'" size="6" readonly readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="defective_product_num_'+rowNum+'" value="'+record.defective_product_num+'" size="8" onkeypress="return key_press_check(this)" onchange="computePrcentage(\'defective_product_num\',\'defective_product_ratio\','+rowNum+');" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="defective_product_ratio_'+rowNum+'" value="'+record.defective_product_ratio+'" size="6" readonly readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="no_shoot_num_'+rowNum+'" value="'+record.no_shoot_num+'" size="8" onkeypress="return key_press_check(this)" onchange="computePrcentage(\'no_shoot_num\',\'no_shoot_ratio\','+rowNum+');" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="no_shoot_ratio_'+rowNum+'" value="'+record.no_shoot_ratio+'" size="6" readonly readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="design_encrypt_sum_num_'+rowNum+'" value="'+record.design_encrypt_sum_num+'" size="8" onkeypress="return key_press_check(this)" readonly onchange="computeSum(\'design_encrypt_sum_num\')">';
			tr.insertCell().innerHTML = '<input type="text" name="infill_sp_num_'+rowNum+'" value="'+record.infill_sp_num+'" size="8" onkeypress="return key_press_check(this)" readonly onchange="computeSum(\'infill_sp_num\')">';
			tr.insertCell().innerHTML = '<input type="text" name="construct_begin_end_date_'+rowNum+'" value="'+record.construct_begin_end_date+'" size="20" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="notes_'+rowNum+'" value="'+record.notes+'" size="12" readonly>';
			tr.insertCell().innerHTML = '<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + lineId + '\')"/>'
			+'<input type="hidden" name="record_id' + '_' + rowNum + '" value="'+record.wa2d_line_id+'"/>'
			+'<input type="hidden" name="bsflag' + '_' + rowNum + '" value="0"/>';
			
			var exportRow = {};
			exportRow["1"] = team_name;
			exportRow["2"] = lineNum;
			exportRow["3"] = record.line_id;
			exportRow["4"] = record.measure_fold_num;
			exportRow["5"] = record.measure_fullfold_start_pile;
			exportRow["6"] = record.measure_fullfold_end_pile;
			exportRow["7"] = record.measure_fullfold_kilo_num;
			exportRow["8"] = record.measure_shot_num;
			exportRow["9"] = record.profile_fold_num;
			exportRow["10"] = record.profile_fullfold_start_pile;
			exportRow["11"] = record.profile_fullfold_end_pile;
			exportRow["12"] = record.full_fold_len;
			exportRow["13"] = record.physical_shot_kilo_num;
			exportRow["14"] = record.record_num;
			exportRow["15"] = record.acceptable_product_num;
			exportRow["16"] = record.qualifier_ratio;
			exportRow["17"] = record.first_num;
			exportRow["18"] = record.first_ratio;
			exportRow["19"] = record.seconde_num;
			exportRow["20"] = record.seconde_ratio;
			exportRow["21"] = record.defective_product_num;
			exportRow["22"] = record.defective_product_ratio;
			exportRow["23"] = record.no_shoot_num;
			exportRow["24"] = record.no_shoot_ratio;
			exportRow["25"] = record.design_encrypt_sum_num;
			exportRow["26"] = record.infill_sp_num;
			exportRow["27"] = record.construct_begin_end_date;
			exportRow["28"] = record.notes;
			exportRows[exportRows.length] = exportRow;
		}
		document.getElementById("lineNum").value = retObj.datas.length;
		insertIndex = retObj.datas.length + 3;
		computeSum('measure_fullfold_kilo_num');
		computeSum('measure_shot_num');		
		computeSum('full_fold_len');
		computeSum('physical_shot_kilo_num');
		computeSum('record_num');
		computeSum('design_encrypt_sum_num');
		computeSum('infill_sp_num');
		computeShotSum(0);
		document.getElementById("trlinesum").style.display = "block";
		var sumRow = {};
		sumRow["1"] = "";
		sumRow["2"] = "合计";
		sumRow["3"] = "";
		sumRow["4"] = "";
		sumRow["5"] = "";
		sumRow["6"] = "";
		sumRow["7"] = document.getElementsByName("sum_measure_fullfold_kilo_num")[0].value;
		sumRow["8"] = document.getElementsByName("sum_measure_shot_num")[0].value;
		sumRow["9"] = "";
		sumRow["10"] = "";
		sumRow["11"] = "";
		sumRow["12"] = document.getElementsByName("sum_full_fold_len")[0].value;
		sumRow["13"] = document.getElementsByName("sum_physical_shot_kilo_num")[0].value;
		sumRow["14"] = document.getElementsByName("sum_record_num")[0].value;
		sumRow["15"] = document.getElementsByName("sum_acceptable_product_num")[0].value;
		sumRow["16"] = document.getElementsByName("sum_qualifier_ratio")[0].value;
		sumRow["17"] = document.getElementsByName("sum_first_num")[0].value;
		sumRow["18"] = document.getElementsByName("sum_first_ratio")[0].value;
		sumRow["19"] = document.getElementsByName("sum_seconde_num")[0].value;
		sumRow["20"] = document.getElementsByName("sum_seconde_ratio")[0].value;
		sumRow["21"] = document.getElementsByName("sum_defective_product_num")[0].value;
		sumRow["22"] = document.getElementsByName("sum_defective_product_ratio")[0].value;
		sumRow["23"] = document.getElementsByName("sum_no_shoot_num")[0].value;
		sumRow["24"] = document.getElementsByName("sum_no_shoot_ratio")[0].value;
		sumRow["25"] = document.getElementsByName("sum_design_encrypt_sum_num")[0].value;
		sumRow["26"] = document.getElementsByName("sum_infill_sp_num")[0].value;
		sumRow["27"] = "";
		sumRow["28"] = "";
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
		rowParam['team_name'] = document.getElementsByName("team_num_0")[0].value; 
		rowParam['line_id'] = document.getElementsByName("line_id_"+rowNum)[0].value;
		var measure_fold_num=document.getElementsByName("measure_fold_num_"+rowNum)[0].value;
		rowParam['project_info_no'] = "<%=projectInfoNo%>";
		if(measure_fold_num.length > 0){
			rowParam['measure_fold_num'] = measure_fold_num;
		}
		//
		var measure_fullfold_start_pile = document.getElementsByName("measure_fullfold_start_pile_"+rowNum)[0].value;
		if(measure_fullfold_start_pile.length > 0) {
			rowParam['measure_fullfold_start_pile'] = measure_fullfold_start_pile;
		}
		//
		var measure_fullfold_end_pile = document.getElementsByName("measure_fullfold_end_pile_"+rowNum)[0].value;
		if(measure_fullfold_end_pile.length > 0) {
			rowParam['measure_fullfold_end_pile'] = measure_fullfold_end_pile;
		}
		//
		var measure_fullfold_kilo_num = document.getElementsByName("measure_fullfold_kilo_num_"+rowNum)[0].value;
		if(measure_fullfold_kilo_num.length > 0){
			rowParam['measure_fullfold_kilo_num'] = measure_fullfold_kilo_num;
		}
		//
		var measure_shot_num  = document.getElementsByName("measure_shot_num_"+rowNum)[0].value;
		if(measure_shot_num.length > 0){
			rowParam['measure_shot_num'] = measure_shot_num;
		}
		//
		var profile_fold_num = document.getElementsByName("profile_fold_num_"+rowNum)[0].value;
		if(profile_fold_num.length > 0){
			rowParam['profile_fold_num'] = profile_fold_num;
		}
		//
		var profile_fullfold_start_pile = document.getElementsByName("profile_fullfold_start_pile_"+rowNum)[0].value;
		if(profile_fullfold_start_pile.length > 0){
			rowParam['profile_fullfold_start_pile'] = profile_fullfold_start_pile;
		}
		//
		var profile_fullfold_end_pile = document.getElementsByName("profile_fullfold_end_pile_"+rowNum)[0].value;
		if(profile_fullfold_end_pile.length > 0){
			rowParam['profile_fullfold_end_pile'] = profile_fullfold_end_pile;
		}
		//
		var full_fold_len = document.getElementsByName("full_fold_len_"+rowNum)[0].value;
		if(full_fold_len.length > 0){
			rowParam['full_fold_len'] = full_fold_len;
		}
		//
		var physical_shot_kilo_num = document.getElementsByName("physical_shot_kilo_num_"+rowNum)[0].value;
		if(physical_shot_kilo_num.length > 0){
			rowParam['physical_shot_kilo_num'] =  physical_shot_kilo_num;
		}
		//
		var record_num = document.getElementsByName("record_num_"+rowNum)[0].value;
		if(record_num.length > 0){
			rowParam['record_num'] = record_num;
		}
		//
		var acceptable_product_num = document.getElementsByName("acceptable_product_num"+"_"+rowNum)[0].value;
		if(acceptable_product_num.length > 0){
			rowParam['acceptable_product_num'] = acceptable_product_num;
		}else{
			rowParam['acceptable_product_num'] = 0;
		}
		//
		var qualifier_ratio = document.getElementsByName("qualifier_ratio"+"_"+rowNum)[0].value;
		if(qualifier_ratio.length > 0){
			rowParam['qualifier_ratio'] = qualifier_ratio;
		}
		//
		var first_num = document.getElementsByName("first_num"+"_"+rowNum)[0].value;
		if(first_num.length > 0){
			rowParam['first_num'] = first_num;
		}else{
			rowParam['first_num'] = 0;
		}
		//
		var first_ratio = document.getElementsByName("first_ratio"+"_"+rowNum)[0].value;
		if(first_ratio.length > 0){
			rowParam['first_ratio'] = first_ratio;
		}
		//
		var seconde_num = document.getElementsByName("seconde_num"+"_"+rowNum)[0].value;
		if(seconde_num.length > 0){
			rowParam['seconde_num'] = seconde_num;
		}else{
			rowParam['seconde_num'] = 0;
		}
		//
		var seconde_ratio = document.getElementsByName("seconde_ratio"+"_"+rowNum)[0].value;
		if(seconde_ratio.length > 0){
			rowParam['seconde_ratio'] = seconde_ratio;
		}
		//
		var defective_product_num = document.getElementsByName("defective_product_num"+"_"+rowNum)[0].value;
		if(defective_product_num.length > 0){
			rowParam['defective_product_num'] = defective_product_num;
		}else{
			rowParam['defective_product_num'] = 0;
		}
		
		//
		var defective_product_ratio = document.getElementsByName("defective_product_ratio"+"_"+rowNum)[0].value;
		if(defective_product_ratio.length > 0){
			rowParam['defective_product_ratio'] = defective_product_ratio;
		}
		//
		var no_shoot_num = document.getElementsByName("no_shoot_num"+"_"+rowNum)[0].value;
		if(no_shoot_num.length > 0){
			rowParam['no_shoot_num'] = no_shoot_num;
		}else{
			rowParam['no_shoot_num'] = 0;
		}
		//
		var no_shoot_ratio  = document.getElementsByName("no_shoot_ratio"+"_"+rowNum)[0].value;
		if(no_shoot_ratio.length > 0){
			rowParam['no_shoot_ratio'] = no_shoot_ratio;
		}
		//
		var design_encrypt_sum_num = document.getElementsByName("design_encrypt_sum_num"+"_"+rowNum)[0].value;
		if(design_encrypt_sum_num.length > 0){
			rowParam['design_encrypt_sum_num'] = design_encrypt_sum_num;
		}
		//
		var infill_sp_num = document.getElementsByName("infill_sp_num"+"_"+rowNum)[0].value;
		if(infill_sp_num.length > 0){
			rowParam['infill_sp_num'] = infill_sp_num;
		}
		rowParam['construct_begin_end_date'] = document.getElementsByName("construct_begin_end_date_"+rowNum)[0].value;
		rowParam['notes'] = document.getElementsByName("notes_"+rowNum)[0].value;
		
		if(record_id !=""){
			rowParam['wa2d_line_id'] = record_id;
			rowParam['updator_id'] = '<%=userId%>';
			rowParam['modifi_date'] = '<%=curDate%>';
		}else{
			rowParam['create_id'] = '<%=userId%>';
			rowParam['create_date'] = '<%=curDate%>';
		}
		rowParam['bsflag'] = bsflag;
		
		rowParams[rowParams.length] = rowParam;
	}
	var rows=JSON.stringify(rowParams);
	//alert(rows);
	saveFunc("gp_ops_wa2d_line_finish",rows);
}

function key_press_check(obj)
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

function activeInput(){
	if(bActive == true){
		return;
	}
	var nodeList = document.getElementsByTagName("input");
    for (var i = 0; i < nodeList.length; i++) {
		nodeList[i].readOnly = false;
    }
    bActive = true;
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
			sumValue += parseFloat(cellValue);
		}
	}
	sumValue = Math.round(parseFloat(sumValue)*100)/100;
	document.getElementsByName("sum_" + colName)[0].value = sumValue;
}

function computeShotSum(rowIndex){
	var orders=document.getElementsByName("order");
	var sumValue = 0;
	for(var i=0;i<orders.length;i++){
		var order = orders[i].value;
		var rowNum = order - 1;
		
		var bsflag = document.getElementsByName("bsflag_"+rowNum)[0].value;
		if(bsflag == "1"){
			continue;
		}
		var cellValue = document.getElementsByName("record_num_" + rowNum)[0].value;
		if(cellValue.length > 0){
			sumValue += parseInt(cellValue);
		}
	}
	document.getElementsByName("sum_record_num")[0].value = sumValue;
	//
	computePrcentage('acceptable_product_num','qualifier_ratio',rowIndex);
	computePrcentage('first_num','first_ratio',rowIndex);
	computePrcentage('seconde_num','seconde_ratio',rowIndex);
	computePrcentage('defective_product_num','defective_product_ratio',rowIndex);
	computePrcentage('no_shoot_num','no_shoot_ratio',rowIndex);
}

function computePrcentage(colName,colPrcentage,rowIndex){
	var orders=document.getElementsByName("order");
	var sumValue = 0;
	var prcentage = 0;
	var sumShotNum = parseInt(document.getElementsByName("sum_record_num")[0].value);
	
	var currentShotNum = document.getElementsByName("record_num_"+rowIndex)[0].value;
	var currentColValue = document.getElementsByName(colName + "_" + rowIndex)[0].value;
	var currentPrcentage = 0;
	if(currentColValue.length < 1){
		document.getElementsByName(colPrcentage+"_" + rowIndex)[0].value = "";
	}
	if(currentShotNum.length > 0 && currentColValue.length>0){
		currentShotNum = parseInt(currentShotNum);
		currentColValue = parseInt(currentColValue);
		
		if(colName == "no_shoot_num"){
			//空点张数
			currentShotNum += currentColValue;
		}
		if(currentShotNum > 0){
			//当前行的百分比
			currentPrcentage = currentColValue/currentShotNum*100;
			currentPrcentage = Math.round(currentPrcentage*100)/100;
		}
		document.getElementsByName(colPrcentage+"_" + rowIndex)[0].value = currentPrcentage;
	}
	
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
	if(colName == "no_shoot_num"){
		//空点张数
		sumShotNum += sumValue;
	}
	
	if(sumShotNum > 0){
		//汇总行的百分比
		prcentage = sumValue/sumShotNum*100;
		prcentage = Math.round(prcentage*100)/100;
	}
	document.getElementsByName("sum_" + colName)[0].value = sumValue;
	document.getElementsByName("sum_" + colPrcentage)[0].value = prcentage;
}

function exportExcel(){
	var path = cruConfig.contextPath+"/pm/exportDataToExcel.srq";
	var rows=JSON.stringify(exportRows);
	var fromPage = "2dlineCompleted";
	var submitStr = "fromPage=" + fromPage + "&projectName="+projectName+"&dataRows="+rows;
	var retObj = syncRequest("post", path, submitStr);
	window.location=cruConfig.contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname=" + fromPage + ".xls";
}

function downloadTemplate(){
	window.location.href="<%=contextPath%>/pm/dailyReport/singleProject/download.jsp?path=/pm/lineCompleted/2dLineCompletedTemp.xls&filename=2dLineCompleted_template.xls";
}

function importData(){
	var filename = document.getElementById("fileName").value;
	if(filename == ""){
		alert("请选择导入文件!");
		return;
	}
	if(checkFile(filename)){
		document.getElementById("fileForm").action = "<%=contextPath%>/pm/gpe/importLineCompleted.srq?workMethod=2&teamName="+team_name;
		document.getElementById("fileForm").submit();
	}
}

function checkFile(filename){
	var type=filename.match(/^(.*)(\.)(.{1,8})$/)[3];
	type=type.toUpperCase();
	if(type=="XLS" || type=="XLSX"){
	   return true;
	}
	else{
	   alert("上传类型有误，请上传EXCLE文件！");
	   return false;
	}
}
</script>
</head>
<body style="background:#fff;overflow-y:auto;overflow-x:auto;" onload="initData()" width="800px">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan = "2">
			  <form action="" id="fileForm" method="post" enctype="multipart/form-data">
			    <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  		<tr>
			    		<td width="60%">&nbsp;<td>
			    		<font color=red>选择文件：</font>
	      	        	<input type="file"  id="fileName" name="fileName"/>
	      	        	<auth:ListButton functionId="" css="dr" event="onclick='importData()'" title="导入数据"></auth:ListButton>
			    		<input type="hidden" id="lineNum" value="0"/>
			    		<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="增加"></auth:ListButton>
			    		<auth:ListButton functionId="" css="xg" event="onclick='activeInput()'" title="修改"></auth:ListButton>
			    		<auth:ListButton functionId="" css="xz" event="onclick='downloadTemplate()'" title="下载模板"></auth:ListButton>
			    		<auth:ListButton functionId="" css="dc" event="onclick='exportExcel()'" title="导出excel"></auth:ListButton>
			  		</tr>
				</table>
			  </form> 		
			</td>		
			<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
		</tr>
		<tr>
		   <td width="90%" align="center"><font size="3"><%=projectName%>测线完成情况表</font></td>
		   <td width="10%">&nbsp;</td>
		   <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
		</tr>
</table>
<div id="scrollDiv" class="scrollDiv" >
<table id="lineTable" width="100%" border="0" cellspacing="0"  align="center" cellpadding="0" class="scrolltable">
   <thead>
    <tr class="scrollColThead td_head">
      <td class="scrollCR scrollRowThead" colspan="3"></td>
      <td colspan="5"></td>
      <td colspan="18">实际完成情况</td>
      <td></td>
      <td></td>
      <td></td>
    </tr>
    <tr class="scrollColThead td_head">
      <td class="scrollCR scrollRowThead" colspan="3"></td>
      <td colspan="5">设计测线</td>
      <td colspan="4">满覆盖剖面</td>
      <td colspan="2">实际工作量</td>
      <td colspan="2">合格品</td>
      <td colspan="2">一级品</td>
      <td colspan="2">二级品</td>
      <td colspan="2">废品</td>
      <td colspan="2">空炮</td>
      <td colspan="2"></td>
      <td></td>
      <td></td>
      <td></td>
    </tr>
    <tr class="scrollColThead td_head">
      <td class="scrollCR scrollRowThead" >队号</td>
      <td class="scrollCR scrollRowThead" >序号</td>
      <td class="scrollCR scrollRowThead" >测线号</td>
      <td>覆盖次数</td>
      <td>满覆盖点</br>首桩号</td>
      <td>满覆盖点</br>尾桩号</td>
      <td>满覆盖</br>公里数</td>
      <td>炮数</td>
      <td>覆盖次数</td>
      <td>满覆盖点</br>首桩号</td>
      <td>满覆盖点</br>尾桩号</td>
      <td>满覆盖公里数</td>
      <td>炮点公里数</td>
      <td>炮数</td>
      <td>张数</td>
      <td>%</td>
      <td>张数</td>
      <td>%</td>
      <td>张数</td>
      <td>%</td>
      <td>张数</td>
      <td>%</td>
      <td>张数</td>
      <td>%</td>
      <td>设计加</br>密炮数</td>
      <td>完成加</br>密炮数</td>
      <td>施工起止日期</td>
      <td>备注</td>
      <td nowrap>删除</td>
    </tr>
    <tr style="display:none;" id="trlinesum">
    	<td class="scrollCR scrollRowThead">合计</td>
    	<td class="scrollCR scrollRowThead"><input type="text" size="10" value="" readonly/></td>
    	<td><input type="text" name="sum_measure_fold_num" size="8" readonly/></td>
    	<td><input type="text" size="10" value="" readonly/></td>
    	<td><input type="text" size="10" value="" readonly/></td>
    	<td><input type="text" name="sum_measure_fullfold_kilo_num" size="8" readonly/></td>
    	<td><input type="text" name="sum_measure_shot_num" size="8" readonly/></td>
    	<td><input type="text" size="8" value="" readonly/></td>
    	<td><input type="text" size="10" value="" readonly/></td>
    	<td><input type="text" size="10" value="" readonly/></td>
    	<td><input type="text" name="sum_full_fold_len" size="8" readonly/></td>
    	<td><input type="text" name="sum_physical_shot_kilo_num" size="8" readonly/></td>
    	<td><input type="text" name="sum_record_num" size="8" readonly/></td>
    	<td><input type="text" name="sum_acceptable_product_num" size="8" readonly/></td>
    	<td><input type="text" name="sum_qualifier_ratio" size="6" readonly/></td>
    	<td><input type="text" name="sum_first_num" size="8" readonly/></td>
    	<td><input type="text" name="sum_first_ratio" size="6" readonly/></td>
    	<td><input type="text" name="sum_seconde_num" size="8" readonly/></td>
    	<td><input type="text" name="sum_seconde_ratio" size="6" readonly/></td>
    	<td><input type="text" name="sum_defective_product_num" size="8" readonly/></td>
    	<td><input type="text" name="sum_defective_product_ratio" size="6" readonly/></td>
    	<td><input type="text" name="sum_no_shoot_num" size="8" readonly/></td>
    	<td><input type="text" name="sum_no_shoot_ratio" size="6" readonly/></td>
    	<td><input type="text" name="sum_design_encrypt_sum_num" size="8" readonly/></td>
    	<td><input type="text" name="sum_infill_sp_num" size="8" readonly/></td>
    	<td><input type="text" size="20" value="" readonly/></td>
    	<td><input type="text" size="12" value="" readonly/></td>
    	<td></td>
    </tr>
</table>
</div>
<div align="center">
    <span class="tj_btn"><a href="#" onclick="toSave()"></a></span>
</div>
</body>
</html>
