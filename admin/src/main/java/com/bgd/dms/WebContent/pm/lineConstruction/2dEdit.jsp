<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId =  user.getEmpId();
	String projectName = user.getProjectName();
	String projectInfoNo = user.getProjectInfoNo();
	String contextPath = request.getContextPath();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());
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
.scrollDiv {height:80%;clear: both; border: 1px solid #94B6E6;OVERFLOW: scroll;width: 100%; }  
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
var projectName = "<%=projectName%>";
var bActive = false;
var team_name = "";
var dataRows = 0;
var loadDataRows = 0;
var exportRows = new Array();

function toAdd(){
	var rowNum = document.getElementById("lineNum").value;
	if(rowNum == 0){
		var lineId = "row_" + rowNum + "_";
		var lineNum = parseInt(rowNum)+1;
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
			td.rowSpan = 1000;
			td.className = "scrollRowThead";
			td.innerHTML = '<input type="text" name="team_num_'+rowNum+'" value="'+team_name+'" size="8">';
		}
		dataRows++;
		var td = tr.insertCell();
		td.className = "scrollRowThead";
		td.innerHTML = '<input type="text" name="line_id_'+rowNum+'" size="12" >';
		tr.insertCell().innerHTML = '<input type="text" name="layout_'+rowNum+'" size="20" >';
		tr.insertCell().innerHTML = '<input type="text" name="fold_'+rowNum+'" size="6" >';
		tr.insertCell().innerHTML = '<input type="text" name="track_interval_'+rowNum+'" size="8" onkeypress="return key_press_check(this)">';
		tr.insertCell().innerHTML = '<input type="text" name="shot_interval_'+rowNum+'" size="6" onkeypress="return key_press_check(this)">';
		tr.insertCell().innerHTML = '<input type="text" name="small_dist_'+rowNum+'" size="20">';
		tr.insertCell().innerHTML = '<input type="text" name="receiving_track_num_'+rowNum+'" size="8" onkeypress="return key_press_check(this)">';
		tr.insertCell().innerHTML = '<input type="text" name="element_interval_'+rowNum+'" size="18">';
		tr.insertCell().innerHTML = '<input type="text" name="pat_distance_'+rowNum+'" size="18">';
		tr.insertCell().innerHTML = '<input type="text" name="receive_comp_graph_'+rowNum+'" size="24" >';
		tr.insertCell().innerHTML = '<input type="text" name="well_depth_'+rowNum+'" size="10" >';
		tr.insertCell().innerHTML = '<input type="text" name="well_num_'+rowNum+'" size="8" >';
		tr.insertCell().innerHTML = '<input type="text" name="explosive_qty_'+rowNum+'" size="8" >';
		tr.insertCell().innerHTML = '<input type="text" name="sp_comp_graph_'+rowNum+'" size="8" >';
		tr.insertCell().innerHTML = '<input type="text" name="source_num_'+rowNum+'" size="8">';
		tr.insertCell().innerHTML = '<input type="text" name="scan_frequency_'+rowNum+'" size="8" >';
		tr.insertCell().innerHTML = '<input type="text" name="scanning_len_'+rowNum+'" size="8" >';
		tr.insertCell().innerHTML = '<input type="text" name="source_comp_graph_'+rowNum+'" size="8" >';
		
		//新加 气枪字段列
		tr.insertCell().innerHTML = '<input type="text" name="airgun_capacity_'+rowNum+'" size="8">';
		tr.insertCell().innerHTML = '<input type="text" name="airgun_pressure_'+rowNum+'" size="8">';
		tr.insertCell().innerHTML = '<input type="text" name="airgun_intro_'+rowNum+'" size="8">';
		tr.insertCell().innerHTML = '<input type="text" name="airgun_num_'+rowNum+'" size="8">';
		tr.insertCell().innerHTML = '<input type="text" name="airgun_length_'+rowNum+'" size="8">';
		tr.insertCell().innerHTML = '<input type="text" name="airgun_spacing_'+rowNum+'" size="8">';
		
		tr.insertCell().innerHTML = '<input type="text" name="instrument_model_'+rowNum+'" size="10" >';
		tr.insertCell().innerHTML = '<input type="text" name="preamplifier_gain_'+rowNum+'" size="8" onkeypress="return key_press_check(this)">';
		tr.insertCell().innerHTML = '<input type="text" name="sample_ratio_'+rowNum+'" size="8" onkeypress="return key_press_check(this)">';
		tr.insertCell().innerHTML = '<input type="text" name="record_len_'+rowNum+'" size="8" onkeypress="return key_press_check(this)">';
		tr.insertCell().innerHTML = '<input type="text" name="notes_'+rowNum+'" size="12">';
		tr.insertCell().innerHTML = '<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + lineId + '\')"/>'
		+'<input type="hidden" name="bsflag' + '_' + rowNum + '" value="0"/>'
		+'<input type="hidden" name="record_id' + '_' + rowNum + '" value=""/><input type="hidden" name="order" class="input_width" value="'+lineNum+'"></td>';
	}else{
		copyLastLine();
	}
}

function initData(){
	//获取队号
	var retPrj = jcdpCallService("TaskBookSrv", "getProjectInfo", "");
	if(retPrj.project != null){
		team_name = retPrj.project.team_name;
		team_name = team_name.replace("东方地球物理公司","");
	}
	//加载数据
	var retObj = jcdpCallService("DBDataSrv","queryTableDatas","tableName=gp_ops_2dwa_method_data&option=bsflag='0'%20and%20project_info_no='<%=projectInfoNo%>'&order=order_num");
	if(retObj.datas != null){
		for(var i=0;i<retObj.datas.length;i++){
			var record = retObj.datas[i];
			var rowNum = i;
			var lineId = "row_" + rowNum + "_";
			var lineNum = parseInt(rowNum)+1;
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
				td.rowSpan = 1000;
				td.className = "scrollRowThead";
				td.innerHTML = '<input type="text" name="team_num_'+rowNum+'" value="'+team_name+'" size="8" readonly>';
			}
			dataRows++;
			var td = tr.insertCell();
			td.className = "scrollRowThead";
			td.innerHTML = '<input type="text" name="line_id_'+rowNum+'" value="'+record.line_id+'" size="12" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="layout_'+rowNum+'" value="'+record.layout+'" size="20" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="fold_'+rowNum+'" value="'+record.fold+'" size="6" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="track_interval_'+rowNum+'" value="'+record.track_interval+'" size="8" onkeypress="return key_press_check(this)" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="shot_interval_'+rowNum+'" value="'+record.shot_interval+'" size="6" onkeypress="return key_press_check(this)" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="small_dist_'+rowNum+'" value="'+record.small_dist+'" size="20" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="receiving_track_num_'+rowNum+'" value="'+record.receiving_track_num+'" size="8" onkeypress="return key_press_check(this)" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="element_interval_'+rowNum+'" value="'+record.element_interval+'" size="18"  readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="pat_distance_'+rowNum+'" value="'+record.pat_distance+'" size="18" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="receive_comp_graph_'+rowNum+'" value="'+record.receive_comp_graph+'" size="24" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="well_depth_'+rowNum+'" value="'+record.well_depth+'" size="10" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="well_num_'+rowNum+'" value="'+record.well_num+'" size="8" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="explosive_qty_'+rowNum+'" value="'+record.explosive_qty+'" size="8" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="sp_comp_graph_'+rowNum+'" value="'+record.sp_comp_graph+'" size="8" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="source_num_'+rowNum+'" value="'+record.source_num+'" size="8" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="scan_frequency_'+rowNum+'" value="'+record.scan_frequency+'" size="8" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="scanning_len_'+rowNum+'" value="'+record.scanning_len+'" size="8" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="source_comp_graph_'+rowNum+'" value="'+record.source_comp_graph+'" size="8" readonly>';
			
			tr.insertCell().innerHTML = '<input type="text" name="airgun_capacity_'+rowNum+'" value="'+record.airgun_capacity+'" size="8" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="airgun_pressure_'+rowNum+'" value="'+record.airgun_pressure+'" size="8" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="airgun_intro_'+rowNum+'" value="'+record.airgun_intro+'" size="8" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="airgun_num_'+rowNum+'" value="'+record.airgun_num+'" size="8" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="airgun_length_'+rowNum+'" value="'+record.airgun_length+'" size="8" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="airgun_spacing_'+rowNum+'" value="'+record.airgun_spacing+'" size="8" readonly>';
			
			
			tr.insertCell().innerHTML = '<input type="text" name="instrument_model_'+rowNum+'" value="'+record.instrument_model+'" size="10" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="preamplifier_gain_'+rowNum+'" value="'+record.preamplifier_gain+'" size="8" onkeypress="return key_press_check(this)" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="sample_ratio_'+rowNum+'" value="'+record.sample_ratio+'" size="8" onkeypress="return key_press_check(this)" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="record_len_'+rowNum+'" value="'+record.record_len+'" size="8" onkeypress="return key_press_check(this)" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="notes_'+rowNum+'" value="'+record.notes+'" size="12" readonly>';
			tr.insertCell().innerHTML = '<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + lineId + '\')"/>'
			+'<input type="hidden" name="record_id' + '_' + rowNum + '" value="'+record.method_no+'"/>'
			+'<input type="hidden" name="bsflag' + '_' + rowNum + '" value="0"/><input type="hidden" name="order" class="input_width" value="'+lineNum+'">';
			
			var exportRow = {};
			exportRow["1"] = team_name;
			exportRow["2"] = record.line_id;
			exportRow["3"] = record.layout;
			exportRow["4"] = record.fold;
			exportRow["5"] = record.track_interval;
			exportRow["6"] = record.shot_interval;
			exportRow["7"] = record.small_dist;
			exportRow["8"] = record.receiving_track_num;
			exportRow["9"] = record.element_interval;
			exportRow["10"] = record.pat_distance;
			exportRow["11"] = record.receive_comp_graph;
			exportRow["12"] = record.well_depth;
			exportRow["13"] = record.well_num;
			exportRow["14"] = record.explosive_qty;
			exportRow["15"] = record.sp_comp_graph;
			exportRow["16"] = record.source_num;
			exportRow["17"] = record.scan_frequency;
			exportRow["18"] = record.scanning_len;
			exportRow["19"] = record.source_comp_graph;
			
			exportRow["20"] = record.airgun_capacity;
			exportRow["21"] = record.airgun_pressure;
			exportRow["22"] = record.airgun_intro;
			exportRow["23"] = record.airgun_num;
			exportRow["24"] = record.airgun_length;
			exportRow["25"] = record.airgun_spacing;
			
			exportRow["26"] = record.instrument_model;
			exportRow["27"] = record.preamplifier_gain;
			exportRow["28"] = record.sample_ratio;
			exportRow["29"] = record.record_len;
			exportRow["30"] = record.notes;
			exportRows[exportRows.length] = exportRow;
		}
		document.getElementById("lineNum").value = retObj.datas.length;
		loadDataRows = retObj.datas.length;
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
		rowParam['project_info_no'] = "<%=projectInfoNo%>";
		//
		var layout = document.getElementsByName("layout"+"_"+rowNum)[0].value;
		if(layout.length > 0){
			rowParam['layout'] = layout;
		}
		//
		var fold  = document.getElementsByName("fold"+"_"+rowNum)[0].value;
		if(fold.length > 0) {
			rowParam['fold'] = fold;
		}
		//
		var track_interval  = document.getElementsByName("track_interval"+"_"+rowNum)[0].value;
		if(track_interval.length > 0){
			rowParam['track_interval'] = track_interval;
		}
		//
		var shot_interval  = document.getElementsByName("shot_interval"+"_"+rowNum)[0].value;
		if(shot_interval.length > 0){
			rowParam['shot_interval'] = shot_interval;
		}
		//
		var small_dist = document.getElementsByName("small_dist"+"_"+rowNum)[0].value;
		if(small_dist.length > 0){
			rowParam['small_dist'] = small_dist;
		}
		//
		var receiving_track_num = document.getElementsByName("receiving_track_num"+"_"+rowNum)[0].value;
		if(receiving_track_num.length > 0) {
			rowParam['receiving_track_num'] = receiving_track_num;
		}
		//
		var element_interval = document.getElementsByName("element_interval"+"_"+rowNum)[0].value;
		if(element_interval.length > 0){
			rowParam['element_interval'] = element_interval;
		}
		//
		var pat_distance  = document.getElementsByName("pat_distance"+"_"+rowNum)[0].value;
		if(pat_distance.length > 0){
			rowParam['pat_distance'] = pat_distance;
		}
		//
		var receive_comp_graph = document.getElementsByName("receive_comp_graph"+"_"+rowNum)[0].value;
		if(receive_comp_graph.length > 0){
			rowParam['receive_comp_graph'] = receive_comp_graph;
		}
		//
		var well_depth = document.getElementsByName("well_depth"+"_"+rowNum)[0].value;
		if(well_depth.length > 0){
			rowParam['well_depth'] = well_depth;
		}
		//
		var well_num = document.getElementsByName("well_num"+"_"+rowNum)[0].value;
		if(well_num.length > 0){
			rowParam['well_num'] = well_num;
		}
		//
		var explosive_qty  = document.getElementsByName("explosive_qty"+"_"+rowNum)[0].value;
		if(explosive_qty.length > 0){
			rowParam['explosive_qty'] = explosive_qty;
		}
		//
		var sp_comp_graph  = document.getElementsByName("sp_comp_graph"+"_"+rowNum)[0].value;
		if(sp_comp_graph.length > 0){
			rowParam['sp_comp_graph'] = sp_comp_graph;
		}
		//
		var source_num  = document.getElementsByName("source_num"+"_"+rowNum)[0].value;
		if(source_num.length > 0){
			rowParam['source_num'] = source_num;
		}
		//
		var scan_frequency = document.getElementsByName("scan_frequency"+"_"+rowNum)[0].value;
		if(scan_frequency.length > 0){
			rowParam['scan_frequency'] = scan_frequency;
		}
		//
		var scanning_len = document.getElementsByName("scanning_len"+"_"+rowNum)[0].value;
		if(scanning_len.length > 0){
			rowParam['scanning_len'] = scanning_len;
		}
		//
		var source_comp_graph = document.getElementsByName("source_comp_graph"+"_"+rowNum)[0].value;
		if(source_comp_graph.length > 0){
			rowParam['source_comp_graph'] = source_comp_graph;
		}
		//
		var preamplifier_gain = document.getElementsByName("preamplifier_gain"+"_"+rowNum)[0].value;
		if(preamplifier_gain.length > 0){
			rowParam['preamplifier_gain'] = preamplifier_gain;
		}
		//
		var sample_ratio  = document.getElementsByName("sample_ratio"+"_"+rowNum)[0].value;
		if(sample_ratio.length > 0){
			rowParam['sample_ratio'] = sample_ratio;
		}
		//
		var record_len  = document.getElementsByName("record_len"+"_"+rowNum)[0].value;
		if(record_len.length > 0){
			rowParam['record_len'] = record_len;
		}
		//
		var instrument_model = document.getElementsByName("instrument_model"+"_"+rowNum)[0].value;
		if(instrument_model.length > 0){
			rowParam['instrument_model'] = instrument_model;
		}
		
		
		 //新加 气枪相关字段
		var airgun_capacity = document.getElementsByName("airgun_capacity"+"_"+rowNum)[0].value;
		if(airgun_capacity.length > 0){
			rowParam['airgun_capacity'] = airgun_capacity;
		}
		var airgun_pressure = document.getElementsByName("airgun_pressure"+"_"+rowNum)[0].value;
		if(airgun_pressure.length > 0){
			rowParam['airgun_pressure'] = airgun_pressure;
		}
		var airgun_intro = document.getElementsByName("airgun_intro"+"_"+rowNum)[0].value;
		if(airgun_intro.length > 0){
			rowParam['airgun_intro'] = airgun_intro;
		}
		var airgun_num = document.getElementsByName("airgun_num"+"_"+rowNum)[0].value;
		if(airgun_num.length > 0){
			rowParam['airgun_num'] = airgun_num;
		}
		var airgun_length = document.getElementsByName("airgun_length"+"_"+rowNum)[0].value;
		if(airgun_length.length > 0){
			rowParam['airgun_length'] = airgun_length;
		}
		var airgun_spacing = document.getElementsByName("airgun_spacing"+"_"+rowNum)[0].value;
		if(airgun_spacing.length > 0){
			rowParam['airgun_spacing'] = airgun_spacing;
		}
		 
		
		
		rowParam['notes'] = document.getElementsByName("notes"+"_"+rowNum)[0].value;
		
		if(record_id !=""){
			rowParam['method_no'] = record_id;
			rowParam['modifi_date'] = '<%=curDate%>';
			rowParam['updator_id'] = '<%=userId%>';
		}else{
			rowParam['create_date'] = '<%=curDate%>';
			rowParam['create_id'] = '<%=userId%>';
		}
		rowParam['bsflag'] = bsflag;
		
		rowParams[rowParams.length] = rowParam;
	}
	var rows=JSON.stringify(rowParams);
	saveFunc("gp_ops_2dwa_method_data",rows);
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

function copyLastLine(){
	
	var rowNum = document.getElementById("lineNum").value;
	var preRowNum = parseInt(rowNum)-1;
	var lineId = "row_" + rowNum + "_";
	
	var pre_line_id = document.getElementsByName('line_id'+'_'+preRowNum)[0].value;
	var pre_layout = document.getElementsByName('layout'+'_'+preRowNum)[0].value;
	var pre_fold = document.getElementsByName('fold'+'_'+preRowNum)[0].value;
	var pre_track_interval = document.getElementsByName('track_interval'+'_'+preRowNum)[0].value;
	var pre_shot_interval = document.getElementsByName('shot_interval'+'_'+preRowNum)[0].value;
	var pre_small_dist = document.getElementsByName('small_dist'+'_'+preRowNum)[0].value;
	var pre_receiving_track_num = document.getElementsByName('receiving_track_num'+'_'+preRowNum)[0].value;
	var pre_element_interval = document.getElementsByName('element_interval'+'_'+preRowNum)[0].value;
	var pre_pat_distance = document.getElementsByName('pat_distance'+'_'+preRowNum)[0].value;
	var pre_receive_comp_graph = document.getElementsByName('receive_comp_graph'+'_'+preRowNum)[0].value;
	var pre_well_depth = document.getElementsByName('well_depth'+'_'+preRowNum)[0].value;
	var pre_well_num = document.getElementsByName('well_num'+'_'+preRowNum)[0].value;
	var pre_explosive_qty = document.getElementsByName('explosive_qty'+'_'+preRowNum)[0].value;
	var pre_sp_comp_graph = document.getElementsByName('sp_comp_graph'+'_'+preRowNum)[0].value;
	var pre_source_num = document.getElementsByName('source_num'+'_'+preRowNum)[0].value;
	var pre_scan_frequency = document.getElementsByName('scan_frequency'+'_'+preRowNum)[0].value;
	var pre_scanning_len = document.getElementsByName('scanning_len'+'_'+preRowNum)[0].value;
	var pre_source_comp_graph = document.getElementsByName('source_comp_graph'+'_'+preRowNum)[0].value;
	
	//新加 气枪字段列
	var g_airgun_capacity = document.getElementsByName('airgun_capacity'+'_'+preRowNum)[0].value;
	var g_airgun_pressure = document.getElementsByName('airgun_pressure'+'_'+preRowNum)[0].value;
	var g_airgun_intro = document.getElementsByName('airgun_intro'+'_'+preRowNum)[0].value;
	var g_airgun_num = document.getElementsByName('airgun_num'+'_'+preRowNum)[0].value;
	var g_airgun_length = document.getElementsByName('airgun_length'+'_'+preRowNum)[0].value;
	var g_airgun_spacing = document.getElementsByName('airgun_spacing'+'_'+preRowNum)[0].value;
	
	var pre_instrument_model = document.getElementsByName('instrument_model'+'_'+preRowNum)[0].value;
	var pre_preamplifier_gain = document.getElementsByName('preamplifier_gain'+'_'+preRowNum)[0].value;
	var pre_sample_ratio = document.getElementsByName('sample_ratio'+'_'+preRowNum)[0].value;
	var pre_record_len = document.getElementsByName('record_len'+'_'+preRowNum)[0].value;
	var pre_notes = document.getElementsByName('notes'+'_'+preRowNum)[0].value;
	
	var lineNum = parseInt(rowNum)+1;
	document.getElementById("lineNum").value = lineNum;
	var tr = document.getElementById("lineTable").insertRow();
	if(rowNum % 2 == 0){
	    tr.className = "even";
	}else{
		tr.className = "odd";
	}
	tr.id=lineId;
		// 单元格
	dataRows++;
	var td = tr.insertCell();
	td.className = "scrollRowThead";
	td.innerHTML = '<input type="text" name="line_id_'+rowNum+'" value="'+pre_line_id+'" size="12" >';
	tr.insertCell().innerHTML = '<input type="text" name="layout_'+rowNum+'" value="'+pre_layout+'" size="20">';
	tr.insertCell().innerHTML = '<input type="text" name="fold_'+rowNum+'" value="'+pre_fold+'" size="6">';
	tr.insertCell().innerHTML = '<input type="text" name="track_interval_'+rowNum+'" value="'+pre_track_interval+'" size="8" onkeypress="return key_press_check(this)" >';
	tr.insertCell().innerHTML = '<input type="text" name="shot_interval_'+rowNum+'" value="'+pre_shot_interval+'" size="6" onkeypress="return key_press_check(this)" >';
	tr.insertCell().innerHTML = '<input type="text" name="small_dist_'+rowNum+'" value="'+pre_small_dist+'" size="20" >';
	tr.insertCell().innerHTML = '<input type="text" name="receiving_track_num_'+rowNum+'" value="'+pre_receiving_track_num+'" size="8" onkeypress="return key_press_check(this)" >';
	tr.insertCell().innerHTML = '<input type="text" name="element_interval_'+rowNum+'" value="'+pre_element_interval+'" size="18" >';
	tr.insertCell().innerHTML = '<input type="text" name="pat_distance_'+rowNum+'" value="'+pre_pat_distance+'" size="18" >';
	tr.insertCell().innerHTML = '<input type="text" name="receive_comp_graph_'+rowNum+'" value="'+pre_receive_comp_graph+'" size="24" >';
	tr.insertCell().innerHTML = '<input type="text" name="well_depth_'+rowNum+'" value="'+pre_well_depth+'" size="10" >';
	tr.insertCell().innerHTML = '<input type="text" name="well_num_'+rowNum+'" value="'+pre_well_num+'" size="8" >';
	tr.insertCell().innerHTML = '<input type="text" name="explosive_qty_'+rowNum+'" value="'+pre_explosive_qty+'" size="8" >';
	tr.insertCell().innerHTML = '<input type="text" name="sp_comp_graph_'+rowNum+'" value="'+pre_sp_comp_graph+'" size="8" >';
	tr.insertCell().innerHTML = '<input type="text" name="source_num_'+rowNum+'" value="'+pre_source_num+'" size="8" >';
	tr.insertCell().innerHTML = '<input type="text" name="scan_frequency_'+rowNum+'" value="'+pre_scan_frequency+'" size="8" >';
	tr.insertCell().innerHTML = '<input type="text" name="scanning_len_'+rowNum+'" value="'+pre_scanning_len+'" size="8" >';
	tr.insertCell().innerHTML = '<input type="text" name="source_comp_graph_'+rowNum+'" value="'+pre_source_comp_graph+'" size="8" >';
	
	tr.insertCell().innerHTML = '<input type="text" name="airgun_capacity_'+rowNum+'" value="'+g_airgun_capacity+'" size="8">';
	tr.insertCell().innerHTML = '<input type="text" name="airgun_pressure_'+rowNum+'" value="'+g_airgun_pressure+'" size="8">';
	tr.insertCell().innerHTML = '<input type="text" name="airgun_intro_'+rowNum+'" value="'+g_airgun_intro+'" size="8">';
	tr.insertCell().innerHTML = '<input type="text" name="airgun_num_'+rowNum+'" value="'+g_airgun_num+'" size="8">';
	tr.insertCell().innerHTML = '<input type="text" name="airgun_length_'+rowNum+'" value="'+g_airgun_length+'" size="8">';
	tr.insertCell().innerHTML = '<input type="text" name="airgun_spacing_'+rowNum+'" value="'+g_airgun_spacing+'" size="8">';
	
	tr.insertCell().innerHTML = '<input type="text" name="instrument_model_'+rowNum+'" value="'+pre_instrument_model+'" size="10" >';
	tr.insertCell().innerHTML = '<input type="text" name="preamplifier_gain_'+rowNum+'" value="'+pre_preamplifier_gain+'" size="8" onkeypress="return key_press_check(this)" >';
	tr.insertCell().innerHTML = '<input type="text" name="sample_ratio_'+rowNum+'" value="'+pre_sample_ratio+'" size="8" onkeypress="return key_press_check(this)" >';
	tr.insertCell().innerHTML = '<input type="text" name="record_len_'+rowNum+'" value="'+pre_record_len+'" size="8" onkeypress="return key_press_check(this)" >';
	tr.insertCell().innerHTML = '<input type="text" name="notes_'+rowNum+'" value="'+pre_notes+'" size="12" >';
	tr.insertCell().innerHTML = '<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + lineId + '\')"/>'
	+'<input type="hidden" name="bsflag' + '_' + rowNum + '" value="0"/>'
	+'<input type="hidden" name="record_id' + '_' + rowNum + '" value=""/><input type="hidden" name="order" class="input_width" value="'+lineNum+'"></td>';
}
//之前保存后才能复制前一行数据
function copyLastLine1(){
	if(loadDataRows > 0){
		var index = loadDataRows - 1;
		var allRows = document.getElementById("lineNum").value;
		var layout = document.getElementsByName('layout'+'_'+index)[0].value;
		var fold = document.getElementsByName('fold'+'_'+index)[0].value;
		var track_interval = document.getElementsByName('track_interval'+'_'+index)[0].value;
		var shot_interval = document.getElementsByName('shot_interval'+'_'+index)[0].value;
		var small_dist = document.getElementsByName('small_dist'+'_'+index)[0].value;
		var receiving_track_num = document.getElementsByName('receiving_track_num'+'_'+index)[0].value;
		var element_interval = document.getElementsByName('element_interval'+'_'+index)[0].value;
		var pat_distance = document.getElementsByName('pat_distance'+'_'+index)[0].value;
		var receive_comp_graph = document.getElementsByName('receive_comp_graph'+'_'+index)[0].value;
		var well_depth = document.getElementsByName('well_depth'+'_'+index)[0].value;
		var well_num = document.getElementsByName('well_num'+'_'+index)[0].value;
		var explosive_qty = document.getElementsByName('explosive_qty'+'_'+index)[0].value;
		var sp_comp_graph = document.getElementsByName('sp_comp_graph'+'_'+index)[0].value;
		var source_num = document.getElementsByName('source_num'+'_'+index)[0].value;
		var scan_frequency = document.getElementsByName('scan_frequency'+'_'+index)[0].value;
		var scanning_len = document.getElementsByName('scanning_len'+'_'+index)[0].value;
		var source_comp_graph = document.getElementsByName('source_comp_graph'+'_'+index)[0].value;
		var instrument_model = document.getElementsByName('instrument_model'+'_'+index)[0].value;
		var preamplifier_gain = document.getElementsByName('preamplifier_gain'+'_'+index)[0].value;
		var sample_ratio = document.getElementsByName('sample_ratio'+'_'+index)[0].value;
		var record_len = document.getElementsByName('record_len'+'_'+index)[0].value;
		var notes = document.getElementsByName('notes'+'_'+index)[0].value;
		
		var j = allRows - 1;
		
		//for(var j=loadDataRows; j<allRows; j++){
			document.getElementsByName('layout'+'_'+ j)[0].value = layout;
			document.getElementsByName('fold'+'_'+ j)[0].value = fold;
			document.getElementsByName('track_interval'+'_'+j)[0].value = track_interval;
			document.getElementsByName('shot_interval'+'_'+j)[0].value = shot_interval;
			document.getElementsByName('small_dist'+'_'+j)[0].value = small_dist;
			document.getElementsByName('receiving_track_num'+'_'+j)[0].value = receiving_track_num;
			document.getElementsByName('element_interval'+'_'+j)[0].value = element_interval;
			document.getElementsByName('pat_distance'+'_'+j)[0].value = pat_distance;
			document.getElementsByName('receive_comp_graph'+'_'+j)[0].value = receive_comp_graph;
			document.getElementsByName('well_depth'+'_'+j)[0].value = well_depth;
			document.getElementsByName('well_num'+'_'+j)[0].value = well_num;
			document.getElementsByName('explosive_qty'+'_'+j)[0].value = explosive_qty;
			document.getElementsByName('sp_comp_graph'+'_'+j)[0].value = sp_comp_graph;
			document.getElementsByName('source_num'+'_'+j)[0].value = source_num;
			document.getElementsByName('scan_frequency'+'_'+j)[0].value = scan_frequency;
			document.getElementsByName('scanning_len'+'_'+j)[0].value = scanning_len;
			document.getElementsByName('source_comp_graph'+'_'+j)[0].value = source_comp_graph;
			document.getElementsByName('instrument_model'+'_'+j)[0].value = instrument_model;
			document.getElementsByName('preamplifier_gain'+'_'+j)[0].value = preamplifier_gain;
			document.getElementsByName('sample_ratio'+'_'+j)[0].value = sample_ratio;
			document.getElementsByName('record_len'+'_'+j)[0].value = record_len;
			document.getElementsByName('notes'+'_'+j)[0].value = notes;
		//}
	}
}

function exportExcel(){
	var path = cruConfig.contextPath+"/pm/exportDataToExcel.srq";
	var rows=JSON.stringify(exportRows);
	var fromPage = "2dlineConsruction";
	var submitStr = "fromPage=" + fromPage + "&projectName="+projectName+"&dataRows="+rows;
	var retObj = syncRequest("post", path, submitStr);
	window.location=encodeURI(encodeURI(cruConfig.contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname=" + fromPage + ".xls"));
}

function importData(){
	var filename = document.getElementById("fileName").value;
	if(filename == ""){
		alert("请选择导入文件!");
		return;
	}
	if(checkFile(filename)){
		document.getElementById("fileForm").action = "<%=contextPath%>/pm/gpe/importLineConstruction.srq?workMethod=2&teamName="+team_name;
		document.getElementById("fileForm").submit();
	}
}

function importData(){
	var filename = document.getElementById("fileName").value;
	if(filename == ""){
		alert("请选择导入文件!");
		return;
	}
	if(checkFile(filename)){
		document.getElementById("fileForm").action = "<%=contextPath%>/pm/gpe/importLineConstruction.srq?workMethod=2&teamName="+team_name;
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

function downloadTemplate(){
	window.location.href="<%=contextPath%>/pm/dailyReport/singleProject/download.jsp?path=/pm/lineConstruction/2dLineConsructionTemp.xls&filename=2dLineConsruction_template.xls";
}
</script>
</head>
<body style="background:#fff;overflow-y:auto;overflow-x:auto;height:400px" onload="initData()">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			    <td colspan="2">
			    <form action="" id="fileForm" method="post" enctype="multipart/form-data">
			    <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  		<tr>
						<td width="60%">&nbsp;<td>
			    		<font color=red>选择文件：</font>
	      	        	<input type="file"  id="fileName" name="fileName"/>
	      	        	<auth:ListButton functionId="" css="dr" event="onclick='importData()'" title="导入数据"></auth:ListButton>
			    		<input type="hidden" id="lineNum" value="0"/>
			    		<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    		<auth:ListButton functionId="" css="xg" event="onclick='activeInput()'" title="JCDP_btn_edit"></auth:ListButton>
			    		<auth:ListButton functionId="" css="xz" event="onclick='downloadTemplate()'" title="下载模板"></auth:ListButton>
			    		<auth:ListButton functionId="" css="dc" event="onclick='exportExcel()'" title="导出excel"></auth:ListButton>
			  		</tr>
				</table>
				</form>
				</td>
			   <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
		</tr>
		<tr>
			   <td width="90%" align="center"><font size="3"><%=projectName%>项目施工方法一览表</font></td>
			   <td width="10%">&nbsp;</td>
			   <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>		
		</tr>
</table>
<div id="scrollDiv" class="scrollDiv" >
<table id="lineTable" width="100%" border="0" cellspacing="0" align="center" cellpadding="0" class="scrolltable">
    <thead>
    <tr class="scrollColThead td_head">
      <td class="scrollCR scrollRowThead" colspan="2"></td>
      <td colspan="6"></td>
      <td colspan="3">接收因素</td>
      <td colspan="14">激发因素</td>
      <td colspan="4"></td>
      <td></td>
      <td></td>
    </tr>
    <tr class="scrollColThead td_head">
      <td class="scrollCR scrollRowThead" colspan="2"></td>
      <td colspan="6">观测系统</td>
      <td colspan="3"></td>
      <td colspan="4">井炮</td>
      <td colspan="4">震源</td>
      <td colspan="6">气枪</td>
      <td colspan="4">仪器因素</td>
      <td></td>
      <td></td>
    </tr>
    <tr class="scrollColThead td_head">
      <td class="scrollCR scrollRowThead">队号</td>
      <td class="scrollCR scrollRowThead">测线号</td>
      <td>观测系统类型</td>
      <td>覆盖次数</td>
      <td>道距m</td>
      <td>炮点距m</td>
      <td>纵向排列</br>方式</td>
      <td>接收道数</td>
      <td>组内距m</td>
      <td>基距m</td>
      <td>组合个数</br>及图形</td>
      <td>激发井深m</td>
      <td>井数(口)</td>
      <td>单井药量kg</td>
      <td>组合井</br>组合图形</td>
      <td>台次</td>
      <td>扫描范围</td>
      <td>扫描长度</td>
      <td>组合图形</td>
       <td >容量(cu in)</td>
                <td >压力(psi)</td>
                     <td >沉放深度(m)</td>
                          <td >枪数(条)</td>
                               <td >陈列长度(m)</td>
                                    <td >子阵间距(m)</td>
      <td>仪器型号</td>
      <td>前放增益</br>dB</td>
      <td>采样率 ms</td>
      <td>记录长度 s</td>
      <td>备注</td>
      <td nowrap>删除</td>
    </tr>
    </thead>
</table>
</div>
<div align="center">
    <span class="tj_btn"><a href="#" onclick="toSave()"></a></span>
</div>
</body>
</html>
