<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
    String contextPath = request.getContextPath();
    UserToken user = OMSMVCUtil.getUserToken(request);
    String projectInfoNo = request.getParameter("projectInfoNo");
    String buildMethod = request.getParameter("buildmethod");
   
    String action = request.getParameter("action");
   	if(action == null || "".equals(action)){
   		action = "edit";
   	}
    
	if(projectInfoNo == null || "".equals(projectInfoNo)){
		projectInfoNo = user.getProjectInfoNo();
	}
    String projectName = user.getProjectName();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>施工方法</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript">
//alert("wa3methodmodify jsp 深海");
debugger;
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
var project_info_no = "<%=projectInfoNo%>";
var buildMethod = "<%=buildMethod%>";

var layoutRows = 1;
var spRows = 1;
var sourceRows = 1;
var geophoneRows = 1;
var instrumentRows = 1;
var layoutIndex = 0;
var spIndex = 0;
var sourceIndex = 0;
var geophoneIndex = 0;
var instrumentIndex = 0;
var maindata_rowid = "";
var first_layout_rowid = "";
var first_sp_rowid = "";
var first_source_rowid = "";
var first_geophone_rowid = "";
var first_instrument_rowid = "";

function setReadOnly(){

	for(var i=1;i<=layoutIndex;i++){
		var id="#layout_table_"+i;
		$("input[type='text']",id).each(function(i){
			this.disabled="disabled";
		})
	}
	
	for(var j=1;j<=instrumentIndex;j++){
		var id="#instrument_table_"+j;
		$("input[type='text']",id).each(function(i){
			this.disabled="disabled";
		})
	}

	//for(var k=1;k<=geophoneIndex;k++){
		//var id="#geophone_table_"+k;
		//$("input[type='text']",id).each(function(i){
			//this.disabled="disabled";
		//})
	//}

	for(var m=1;m<=sourceIndex;m++){
		var id="#source_table_"+m;
		$("input[type='text']",id).each(function(i){
			this.disabled="disabled";
		})
	}
	
	for(var n=1;n<=spIndex;n++){
		var id="#sp_table_"+n;
		$("input[type='text']",id).each(function(i){
			this.disabled="disabled";
		})
	}
}

function loadData(){
	//默认都添加一行数据
	toAddLayout();
	toAddSP();
	toAddSource();
	//toAddGeophone();
	toAddInstrument();
	
	// 取所有数据
	var retObj = jcdpCallService("WorkMethodSrv", "getWork3Method", "projectInfoNo="+project_info_no);
	var mainData = retObj.mainData;
	var layoutData = retObj.layoutData;
	var spData = retObj.spData;
	var sourceData = retObj.sourceData;
	var geophoneData = retObj.geophoneData;
	var instrumentData = retObj.instrumentData;
	
	if(mainData != null){
		//初始第一行数据
		maindata_rowid = mainData.wa3d_no;
		setLayoutData(mainData,1);
		setSPData(mainData,1);
		setSourceData(mainData,1);
		//setGeophoneData(mainData,1);
		setInstrumentData(mainData,1);
	}
	// 加载观测系统段数据
	if(layoutData != null){
		for(var i=0;i<layoutData.length;i++){
			var record = layoutData[i];
			var order_num = record.order_num;
			if(order_num == "1"){
				first_layout_rowid = record.wa3d_no;
				continue;
			}else{
				toAddLayout();
				var rowIndex = layoutRows - 1;
				setLayoutData(record, rowIndex);
			}
		}
	}
	//if("5000100003000000002" == buildMethod){
	
		//可控震源
		document.getElementById("table2").style.display = "none";
		document.getElementById("td_section_source").innerHTML = '<span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">2、激发参数: 气枪激发</font></span>';
		document.getElementById("td_section_instrument").innerHTML = '<span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">3、仪器参数</font></span>';
		// 加载可控震源段数据
		if(sourceData != null){
			for(var i=0;i<sourceData.length;i++){
				var record = sourceData[i];
				var order_num = record.order_num;
				if(order_num == "1"){
					first_source_rowid = record.wa3d_no;
					continue;
				}else{
					toAddSource();
					var rowIndex = sourceRows - 1;
					setSourceData(record, rowIndex);
				}
			}
		}
	
	// 加载仪器段数据
	if(instrumentData != null){
		for(var i=0;i<instrumentData.length;i++){
			var record = instrumentData[i];
			var order_num = record.order_num;
			if(order_num == "1"){
				first_instrument_rowid = record.wa3d_no;
				continue;
			}else{
				toAddInstrument();
				var rowIndex = instrumentRows - 1;
				setInstrumentData(record, rowIndex);
			}
		}
	}
	setReadOnly();
	
	parent.document.all("if5").style.height=document.body.scrollHeight; 
	parent.document.all("if5").style.width=document.body.scrollWidth; 
}

function checkForm(){
	var form = document.forms[0];
}

function on_key_press_str(obj)
{
	var keycode = event.keyCode;
	
	if(keycode > 57 || keycode <= 46 || keycode==47)
	{
		return true;
	}
}
	
function on_key_press_int(obj)
{
	var keycode = event.keyCode;
	if(keycode > 57 || keycode < 46 || keycode==47)
	{
		return false;
	}else{
		return true;
	}
}
	
function toSave(){
	var mainParams = new Array();
	var fromParams = new Array();
	var mainRow = {};
	if(maindata_rowid != ""){
		mainRow['wa3d_no'] = maindata_rowid;
	}
	mainRow['project_info_no'] = project_info_no;
	for(var i=1; i<layoutRows; i++){
		var fromRow = {};
		fromRow['project_info_no'] = project_info_no;
		var lineNum = i;
		var method_no = document.getElementById("method1_no" + "_"+lineNum).value;
		var bsflag = document.getElementById("bsflag1" + "_"+lineNum).value;
		var layout = document.getElementById("layout" + "_"+lineNum).value;
		if(layout.length < 1){
			layout="";
		}
		var binning = document.getElementById("binning" + "_"+lineNum).value;
		if(binning.length < 1){
			binning="";
		}
		var fold = document.getElementById("fold" + "_"+lineNum).value;
		if(fold.length < 1){
			fold="";
		}
		var receiving_track_num = document.getElementById("receiving_track_num" + "_"+lineNum).value;
		if(receiving_track_num.length < 1){
			receiving_track_num="";
		}
		var track_interval = document.getElementById("track_interval" + "_"+lineNum).value;
		if(track_interval.length < 1){
			track_interval="";
		}
		var shot_interval = document.getElementById("shot_interval" + "_"+lineNum).value;
		if(shot_interval.length < 1){
			shot_interval="";
		}
		var receiving_line_distance = document.getElementById("receiving_line_distance" + "_"+lineNum).value;
		if(receiving_line_distance.length < 1){
			receiving_line_distance = 0;
		}else{
			if(isNaN(receiving_line_distance)){
				alert("'接收线距'项是数字类型,输入内容不符!");
				document.getElementById("receiving_line_distance" + "_"+lineNum).focus();
				return;
			}
		}
		var	sp_line_interval = document.getElementById("sp_line_interval" + "_"+lineNum).value;
		if(sp_line_interval.length < 1){
			sp_line_interval="";
		}
		var max_cross_spread = document.getElementById("max_cross_spread" + "_"+lineNum).value;
		if(max_cross_spread.length < 1){
			max_cross_spread = 0;
		}else{
			if(isNaN(max_cross_spread)){
				alert("'最大非纵距'项是数字类型,输入内容不符!");
				document.getElementById("max_cross_spread" + "_"+lineNum).focus();
				return;
			}
		}
		var largest_minimum_offset = document.getElementById("largest_minimum_offset" + "_"+lineNum).value;
		if(largest_minimum_offset.length < 1){
			largest_minimum_offset="";
		}
		var max_offset_distance = document.getElementById("max_offset_distance" + "_"+lineNum).value;
		if(max_offset_distance.length < 1){
			max_offset_distance = 0;
		}else{
			if(isNaN(max_offset_distance)){
				alert("'最大炮检距'项是数字类型,输入内容不符!");
				document.getElementById("max_offset_distance" + "_"+lineNum).focus();
				return;
			}
		}
		var maximum_offset = document.getElementById("maximum_offset" + "_"+lineNum).value;
		if(maximum_offset.length < 1){
			maximum_offset="";
		}
		var aspect_ratio = document.getElementById("aspect_ratio" + "_"+lineNum).value;
		if(aspect_ratio.length < 1){
			aspect_ratio="";
		}
		var vertical_array = document.getElementById("vertical_array" + "_"+lineNum).value;
		if(vertical_array.length < 1){
			vertical_array="";
		}
		var group_roll_distance = document.getElementById("group_roll_distance" + "_"+lineNum).value;
		if(group_roll_distance.length < 1){
			group_roll_distance = "0";
		}else{
			if(isNaN(group_roll_distance)){
				alert("'束线横向滚动距离'项是数字类型,输入内容不符!");
				document.getElementById("group_roll_distance" + "_"+lineNum).focus();
				return;
			}
		}
		if(i==1){
			if(first_layout_rowid != ""){
				fromRow['wa3d_no'] = first_layout_rowid;
			}
			mainRow['layout'] = layout;
			mainRow['binning'] = binning;
			mainRow['fold'] = fold;
			mainRow['receiving_track_num'] = receiving_track_num;
			mainRow['track_interval'] = track_interval;
			mainRow['shot_interval'] = shot_interval;
			mainRow['receiving_line_distance'] = receiving_line_distance;
			mainRow['sp_line_interval'] = sp_line_interval;
			mainRow['max_cross_spread'] = max_cross_spread;
			mainRow['largest_minimum_offset'] = largest_minimum_offset;
			mainRow['max_offset_distance'] = max_offset_distance;
			mainRow['maximum_offset'] = maximum_offset;
			mainRow['aspect_ratio'] = aspect_ratio;
			mainRow['vertical_array'] = vertical_array;
			mainRow['group_roll_distance'] = group_roll_distance;
		}else{
			if(method_no != ""){
				fromRow['wa3d_no'] = method_no;
			}
		}
		fromRow['layout'] = layout;
		fromRow['binning'] = binning;
		fromRow['fold'] = fold;
		fromRow['receiving_track_num'] = receiving_track_num;
		fromRow['track_interval'] = track_interval;
		fromRow['shot_interval'] = shot_interval;
		fromRow['receiving_line_distance'] = receiving_line_distance;
		fromRow['sp_line_interval'] = sp_line_interval;
		fromRow['max_cross_spread'] = max_cross_spread;
		fromRow['largest_minimum_offset'] = largest_minimum_offset;
		fromRow['max_offset_distance'] = max_offset_distance;
		fromRow['maximum_offset'] = maximum_offset;
		fromRow['aspect_ratio'] = aspect_ratio;
		fromRow['vertical_array'] = vertical_array;
		fromRow['group_roll_distance'] = group_roll_distance;
		
		fromRow['section_type'] = "1";
		fromRow['order_num'] = i;
		fromRow['bsflag'] = bsflag;
		fromParams[fromParams.length] = fromRow;
	}
	
	for(var i=1; i<spRows; i++){
		var fromRow = {};
		fromRow['project_info_no'] = project_info_no;
		var lineNum = i;
		var method_no = document.getElementById("method2_no" + "_"+lineNum).value;
		var bsflag = document.getElementById("bsflag2" + "_"+lineNum).value;
		var dynamite_type =	document.getElementById("dynamite_type" + "_"+lineNum).value;
		if(dynamite_type.length < 1){
			dynamite_type = "";
		}
		var well_array_type = document.getElementById("well_array_type" + "_"+lineNum).value;
		if(well_array_type.length < 1){
			well_array_type = "";
		}
		var well_num = document.getElementById("well_num" + "_"+lineNum).value;
		if(well_num.length < 1){
			well_num = "";
		}
		var well_depth = document.getElementById("well_depth" + "_"+lineNum).value;
		if(well_depth.length < 1){
			well_depth = "";
		}
		var explosive_qty = document.getElementById("explosive_qty" + "_"+lineNum).value;
		if(explosive_qty.length < 1){
			explosive_qty = "";
		}
		if(i==1){
			if(first_sp_rowid != ""){
				fromRow['wa3d_no'] = first_sp_rowid;
			}
			mainRow['dynamite_type'] = dynamite_type;
			mainRow['well_array_type'] = well_array_type;
			mainRow['well_num'] = well_num;
			mainRow['well_depth'] = well_depth;
			mainRow['explosive_qty'] = explosive_qty;
		}else{
			if(method_no != ""){
				fromRow['wa2d_no'] = method_no;
			}
		}
		fromRow['dynamite_type'] = dynamite_type;
		fromRow['well_array_type'] = well_array_type;
		fromRow['well_num'] = well_num;
		fromRow['well_depth'] = well_depth;
		fromRow['explosive_qty'] = explosive_qty;
		
		fromRow['section_type'] = "2";
		fromRow['order_num'] = i;
		fromRow['bsflag'] = bsflag;
		fromParams[fromParams.length] = fromRow;
	}
	for(var i=1; i<sourceRows; i++){
		var fromRow = {};
		fromRow['project_info_no'] = project_info_no;
		var lineNum = i;
		var method_no = document.getElementById("method3_no" + "_"+lineNum).value;
		var bsflag = document.getElementById("bsflag3" + "_"+lineNum).value;
		var source_type = document.getElementById("source_type" + "_"+lineNum).value;
		if(source_type.length < 1){
			source_type = "";
		}
		var excitation_form = document.getElementById("excitation_form" + "_"+lineNum).value;
		if(excitation_form.length < 1){
			excitation_form = "";
		}
		var sliding_time = document.getElementById("sliding_time" + "_"+lineNum).value;
		if(sliding_time.length < 1){
			sliding_time = "";
		}
		var vibrator_num = document.getElementById("vibrator_num" + "_"+lineNum).value;
		if(vibrator_num.length < 1){
			vibrator_num = "";
		}
		var sweeping_times = document.getElementById("sweeping_times" + "_"+lineNum).value;
		if(sweeping_times.length < 1){
			sweeping_times = "";
		}
		var scan_length = document.getElementById("scan_length" + "_"+lineNum).value;
		if(scan_length.length < 1){
			scan_length = "";
		}
		var scan_width = document.getElementById("scan_width" + "_"+lineNum).value;
		if(scan_width.length < 1){
			scan_width = "";
		}
		var drive_level = document.getElementById("drive_level" + "_"+lineNum).value;
		if(drive_level.length < 1){
			drive_level = "";
		}
		var sweeping_method = document.getElementById("sweeping_method" + "_"+lineNum).value;
		if(sweeping_method.length < 1){
			sweeping_method = "";
		}
		var sweeping_type = document.getElementById("sweeping_type" + "_"+lineNum).value;
		if(sweeping_type.length < 1){
			sweeping_type = "";
		}
		var source_array_type = document.getElementById("source_array_type" + "_"+lineNum).value;
		if(source_array_type.length < 1){
			source_array_type = "";
		}
		var source_array_interval = document.getElementById("source_array_interval" + "_"+lineNum).value;
		if(source_array_interval.length < 1){
			source_array_interval = "";
		}
		if(i==1){
			if(first_source_rowid != ""){
				fromRow['wa3d_no'] = first_source_rowid;
			}
			mainRow['source_type'] = source_type;
			mainRow['excitation_form'] = excitation_form;
			mainRow['sliding_time'] = sliding_time;
			mainRow['vibrator_num'] = vibrator_num;
			mainRow['sweeping_times'] = sweeping_times;
			mainRow['scan_length'] = scan_length;
			mainRow['scan_width'] = scan_width;
			mainRow['drive_level'] = drive_level;
			mainRow['sweeping_method'] = sweeping_method;
			mainRow['sweeping_type'] = sweeping_type;
			mainRow['source_array_type'] = source_array_type;
			mainRow['source_array_interval'] = source_array_interval;
		}else{
			if(method_no != ""){
				fromRow['wa3d_no'] = method_no;
			}
		}
		fromRow['source_type'] = source_type;
		fromRow['excitation_form'] = excitation_form;
		fromRow['sliding_time'] = sliding_time;
		fromRow['vibrator_num'] = vibrator_num;
		fromRow['sweeping_times'] = sweeping_times;
		fromRow['scan_length'] = scan_length;
		fromRow['scan_width'] = scan_width;
		fromRow['drive_level'] = drive_level;
		fromRow['sweeping_method'] = sweeping_method;
		fromRow['sweeping_type'] = sweeping_type;
		fromRow['source_array_type'] = source_array_type;
		fromRow['source_array_interval'] = source_array_interval;
		
		fromRow['section_type'] = "3";
		fromRow['order_num'] = i;
		fromRow['bsflag'] = bsflag;
		fromParams[fromParams.length] = fromRow;
	}
	for(var i=1; i<geophoneRows; i++){
		var fromRow = {};
		fromRow['project_info_no'] = project_info_no;
		var lineNum = i;
		var method_no = document.getElementById("method4_no" + "_"+lineNum).value;
		var bsflag = document.getElementById("bsflag4" + "_"+lineNum).value;
		var geophone_model = document.getElementById("geophone_model" + "_"+lineNum).value;
		if(geophone_model.length < 1){
			geophone_model = "";
		}
		var geophone_comb_num = document.getElementById("geophone_comb_num" + "_"+lineNum).value;
		if(geophone_comb_num.length < 1){
			geophone_comb_num = "";
		}
		var geophone_comb_style = document.getElementById("geophone_comb_style" + "_"+lineNum).value;
		if(geophone_comb_style.length < 1){
			geophone_comb_style = "";
		}
		var geophone_interval = document.getElementById("geophone_interval" + "_"+lineNum).value;
		if(geophone_interval.length < 1){
			geophone_interval = "";
		}
		var geophone_pat_distance = document.getElementById("geophone_pat_distance" + "_"+lineNum).value;
		if(geophone_pat_distance.length < 1){
			geophone_pat_distance = "";
		}
		var geophone_comb_height = document.getElementById("geophone_comb_height" + "_"+lineNum).value;
		if(geophone_comb_height.length < 1){
			geophone_comb_height = "";
		}
		var geophone_planting = document.getElementById("geophone_planting" + "_"+lineNum).value;
		if(geophone_planting.length < 1){
			geophone_planting = "";
		}
		if(i==1){
			if(first_geophone_rowid != ""){
				fromRow['wa3d_no'] = first_geophone_rowid;
			}
			mainRow['geophone_model'] = geophone_model;
			mainRow['geophone_comb_num'] = geophone_comb_num;
			mainRow['geophone_comb_style'] = geophone_comb_style;
			mainRow['geophone_interval'] = geophone_interval;
			mainRow['geophone_pat_distance'] = geophone_pat_distance;
			mainRow['geophone_comb_height'] = geophone_comb_height;
			mainRow['geophone_planting'] = geophone_planting;
		}else{
			if(method_no != ""){
				fromRow['wa3d_no'] = method_no;
			}
		}
		fromRow['geophone_model'] = geophone_model;
		fromRow['geophone_comb_num'] = geophone_comb_num;
		fromRow['geophone_comb_style'] = geophone_comb_style;
		fromRow['geophone_interval'] = geophone_interval;
		fromRow['geophone_pat_distance'] = geophone_pat_distance;
		fromRow['geophone_comb_height'] = geophone_comb_height;
		fromRow['geophone_planting'] = geophone_planting;
		
		fromRow['section_type'] = "4";
		fromRow['order_num'] = i;
		fromRow['bsflag'] = bsflag;
		fromParams[fromParams.length] = fromRow;
	}
	for(var i=1; i<instrumentRows; i++){
		var fromRow = {};
		fromRow['project_info_no'] = project_info_no;
		var lineNum = i;
		var method_no = document.getElementById("method5_no" + "_"+lineNum).value;
		var bsflag = document.getElementById("bsflag5" + "_"+lineNum).value;
		var instrument_model = document.getElementById("instrument_model" + "_"+lineNum).value;
		if(instrument_model.length < 1){
			instrument_model = "";
		}
		var record_format = document.getElementById("record_format" + "_"+lineNum).value;
		if(record_format.length < 1){
			record_format = "";
		}
		var sample_interval = document.getElementById("sample_interval" + "_"+lineNum).value;
		if(sample_interval.length < 1){
			sample_interval = "0";
		}else{
			if(isNaN(sample_interval)){
				alert("'采样间隔'项是数字类型,输入内容不符!");
				document.getElementById("sample_interval" + "_"+lineNum).focus();
				return;
			}
		}
		var record_len = document.getElementById("record_len" + "_"+lineNum).value;
		if(record_len.length < 1){
			record_len = "0";
		}else{
			if(isNaN(record_len)){
				alert("'记录长度'项是数字类型,输入内容不符!");
				document.getElementById("record_len" + "_"+lineNum).focus();
				return;
			}
		}
		var preamplifier_gain = document.getElementById("preamplifier_gain" + "_"+lineNum).value;
		if(preamplifier_gain.length < 1){
			preamplifier_gain = "0";
		}else{
			if(isNaN(preamplifier_gain)){
				alert("'前放增益'项是数字类型,输入内容不符!");
				document.getElementById("preamplifier_gain" + "_"+lineNum).focus();
				return;
			}
		}
		var low_cut = document.getElementById("low_cut" + "_"+lineNum).value;
		if(low_cut.length < 1){
			low_cut = "";
		}
		var high_cut = document.getElementById("high_cut" + "_"+lineNum).value;
		if(high_cut.length < 1){
			high_cut = "";
		}
		var filtering_method = document.getElementById("filtering_method" + "_"+lineNum).value;
		if(filtering_method.length < 1){
			filtering_method = "";
		}
		if(i==1){
			if(first_instrument_rowid != ""){
				fromRow['wa3d_no'] = first_instrument_rowid;
			}
			mainRow['instrument_model'] = instrument_model;
			mainRow['record_format'] = record_format;
			mainRow['sample_interval'] = sample_interval;
			mainRow['record_len'] = record_len;
			mainRow['preamplifier_gain'] = preamplifier_gain;
			mainRow['low_cut'] = low_cut;
			mainRow['high_cut'] = high_cut;
			mainRow['filtering_method'] = filtering_method;
		}else{
			if(method_no != ""){
				fromRow['wa3d_no'] = method_no;
			}
		}
		fromRow['instrument_model'] = instrument_model;
		fromRow['record_format'] = record_format;
		fromRow['sample_interval'] = sample_interval;
		fromRow['record_len'] = record_len;
		fromRow['preamplifier_gain'] = preamplifier_gain;
		fromRow['low_cut'] = low_cut;
		fromRow['high_cut'] = high_cut;
		fromRow['filtering_method'] = filtering_method;
		
		fromRow['section_type'] = "5";
		fromRow['order_num'] = i;
		fromRow['bsflag'] = bsflag;
		fromParams[fromParams.length] = fromRow;
	}
	
	mainParams[mainParams.length] = mainRow;
	
	var mainRows=JSON.stringify(mainParams);
	var fromRows=JSON.stringify(fromParams);
	var path = getContextPath()+"/rad/addOrUpdateEntities.srq";
	submitMainStr = "tableName=gp_ops_3dwa_design_data&"+"rowParams="+mainRows;
	submitFromStr = "tableName=gp_ops_3dwa_design_data_from&"+"rowParams="+fromRows;
	
	var retObject1 = syncRequest('Post',path,submitMainStr);
	var retObject2 = syncRequest('Post',path,submitFromStr);
	if(retObject1.returnCode != "0" && retObject2.returnCode != "0"){
		alert("保存失败!");
	}else{
		alert("保存成功!");
	};
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

function setLayoutData(record, lineNum){
	document.getElementById("method1_no" + "_"+lineNum).value = record.wa3d_no;
	document.getElementById("layout" + "_"+lineNum).value = record.layout;
	document.getElementById("binning" + "_"+lineNum).value = record.binning;
	document.getElementById("fold" + "_"+lineNum).value = record.fold;	
	document.getElementById("receiving_track_num" + "_"+lineNum).value = record.receiving_track_num;
	document.getElementById("track_interval" + "_"+lineNum).value = record.track_interval;
	document.getElementById("shot_interval" + "_"+lineNum).value = record.shot_interval;
	document.getElementById("receiving_line_distance" + "_"+lineNum).value = record.receiving_line_distance;
	document.getElementById("sp_line_interval" + "_"+lineNum).value = record.sp_line_interval;
	document.getElementById("max_cross_spread" + "_"+lineNum).value = record.max_cross_spread;
	document.getElementById("largest_minimum_offset" + "_"+lineNum).value = record.largest_minimum_offset;
	document.getElementById("max_offset_distance" + "_"+lineNum).value = record.max_offset_distance;
	
	document.getElementById("maximum_offset" + "_"+lineNum).value = record.maximum_offset;
	document.getElementById("aspect_ratio" + "_"+lineNum).value = record.aspect_ratio;
	document.getElementById("vertical_array" + "_"+lineNum).value = record.vertical_array;
	document.getElementById("group_roll_distance" + "_"+lineNum).value = record.group_roll_distance;
}

function setSPData(record, lineNum){
	document.getElementById("method2_no" + "_"+lineNum).value = record.wa3d_no;
	document.getElementById("dynamite_type" + "_"+lineNum).value = record.dynamite_type;
	document.getElementById("well_array_type" + "_"+lineNum).value = record.well_array_type;
	document.getElementById("well_num" + "_"+lineNum).value = record.well_num;
	document.getElementById("well_depth" + "_"+lineNum).value = record.well_depth;
	document.getElementById("explosive_qty" + "_"+lineNum).value = record.explosive_qty;
}

function setSourceData(record, lineNum){
	document.getElementById("method3_no" + "_"+lineNum).value = record.wa3d_no;
	document.getElementById("source_type" + "_"+lineNum).value = record.source_type;
	document.getElementById("excitation_form" + "_"+lineNum).value = record.excitation_form;
	document.getElementById("sliding_time" + "_"+lineNum).value = record.sliding_time;
	document.getElementById("vibrator_num" + "_"+lineNum).value = record.vibrator_num;
	document.getElementById("sweeping_times" + "_"+lineNum).value = record.sweeping_times;
	document.getElementById("scan_length" + "_"+lineNum).value = record.scan_length;
	document.getElementById("scan_width" + "_"+lineNum).value = record.scan_width;
	document.getElementById("drive_level" + "_"+lineNum).value = record.drive_level;
	document.getElementById("sweeping_method" + "_"+lineNum).value = record.sweeping_method;
	document.getElementById("sweeping_type" + "_"+lineNum).value = record.sweeping_type;
	document.getElementById("source_array_type" + "_"+lineNum).value = record.source_array_type;
	document.getElementById("source_array_interval" + "_"+lineNum).value = record.source_array_interval;
}
function setGeophoneData(record, lineNum){
	document.getElementById("method4_no" + "_"+lineNum).value = record.wa3d_no;
	document.getElementById("geophone_model" + "_"+lineNum).value = record.geophone_model;
	document.getElementById("geophone_comb_num" + "_"+lineNum).value = record.geophone_comb_num;
	document.getElementById("geophone_comb_style" + "_"+lineNum).value = record.geophone_comb_style;
	document.getElementById("geophone_interval" + "_"+lineNum).value = record.geophone_interval;
	document.getElementById("geophone_pat_distance" + "_"+lineNum).value = record.geophone_pat_distance;
	document.getElementById("geophone_comb_height" + "_"+lineNum).value = record.geophone_comb_height;
	document.getElementById("geophone_planting" + "_"+lineNum).value = record.geophone_planting;
}
function setInstrumentData(record, lineNum){
	document.getElementById("method5_no" + "_"+lineNum).value = record.wa3d_no;
	document.getElementById("instrument_model" + "_"+lineNum).value = record.instrument_model;
	document.getElementById("record_format" + "_"+lineNum).value = record.record_format;
	document.getElementById("sample_interval" + "_"+lineNum).value = record.sample_interval;
	document.getElementById("record_len" + "_"+lineNum).value = record.record_len;
	document.getElementById("preamplifier_gain" + "_"+lineNum).value = record.preamplifier_gain;
	document.getElementById("low_cut" + "_"+lineNum).value = record.low_cut;
	document.getElementById("high_cut" + "_"+lineNum).value = record.high_cut;
	document.getElementById("filtering_method" + "_"+lineNum).value = record.filtering_method;
}
function toAddLayout(){
	layoutIndex++;
	var tr = document.getElementById("trLayout_"+layoutIndex);
	if(tr != null){
		document.getElementById("trLayout_hr_"+layoutIndex).style.display = "block";
		document.getElementById("trLayout_"+layoutIndex).style.display = "block";
		return;
	}
	var rowNum = layoutRows;
	layoutRows++;
	var tr = document.getElementById("table1").insertRow();
	tr.id = "trLayout_hr_" + rowNum;
	tr.insertCell().innerHTML = '<table width="100%"><tr><td><hr width="98%"></td></tr></table>';
	var tr = document.getElementById("table1").insertRow();
	tr.id = "trLayout_" + rowNum;
	tr.insertCell().innerHTML = '<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="layout_table_'+layoutIndex+'">'
				+' <tr class="even"><td class="inquire_item6">观测系统类型：</td>'
				+' <td class="inquire_form6"><input id="method1_no' + '_' + rowNum+'" type="hidden" value=""/><input id="bsflag1' + '_' + rowNum+'" type="hidden" value="0"/>'
				+' <input id="layout'+'_' + rowNum+'" type="text" value=""  class="input_width"/></td>'
				+' <td class="inquire_item6">面元尺寸：</td>'
    			+' <td class="inquire_form6"><input id="binning' + '_' + rowNum+'" type="text" value="" style="margin-top:4px;" class="input_width"/><div>m</div></td>'
				+' <td class="inquire_item6">覆盖次数：</td>'
   				+' <td class="inquire_form6"><input id="fold' + '_' + rowNum+'" type="text" value="" style="margin-top:4px;" class="input_width"/><div>次</div></td>'
				+' </tr>'
				+' <tr class="odd"><td class="inquire_item6">接收道数：</td>'
    			+' <td class="inquire_form6"><input id="receiving_track_num' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>道</div></td>'
				+' <td class="inquire_item6">道距：</td>'
				+' <td class="inquire_form6"><input id="track_interval' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>m</div></td>'
				+' <td class="inquire_item6">炮点距：</td>'
    			+'<td class="inquire_form6"><input id="shot_interval' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>m</div></td>'
				+' </tr>'
				+' <tr class="even"><td class="inquire_item6">接收线距：</td>'
    			+' <td class="inquire_form6"><input id="receiving_line_distance' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;" onkeypress="return on_key_press_int(this)"/><div>m</div></td>'
				+' <td class="inquire_item6">炮线距：</td>'
				+' <td class="inquire_form6"><input id="sp_line_interval' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>m</div></td>'
				+' <td class="inquire_item6">最大非纵距：</td>'
    			+'<td class="inquire_form6"><input id="max_cross_spread' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;" onkeypress="return on_key_press_int(this)"/><div>m</div></td>'
				+' </tr>'
				+' <tr class="odd"><td class="inquire_item6">最大最小炮检距：</td>'
    			+' <td class="inquire_form6"><input id="largest_minimum_offset' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>m</div></td>'
				+' <td class="inquire_item6">最大炮检距：</td>'
				+' <td class="inquire_form6"><input id="max_offset_distance' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;" onkeypress="return on_key_press_int(this)"/><div>m</div></td>'
				+' <td class="inquire_item6">纵向最大炮检距：</td>'
    			+'<td class="inquire_form6"><input id="maximum_offset' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>m</div></td>'
				+' </tr>'
				+' <tr class="even"><td class="inquire_item6">横纵比：</td>'
    			+' <td class="inquire_form6"><input id="aspect_ratio' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/></td>'
				+' <td class="inquire_item6">纵向排列方式：</td>'
				+' <td class="inquire_form6"><input id="vertical_array' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/></td>'
				+' <td class="inquire_item6">束线横向滚动距离：</td>'
    			+'<td class="inquire_form6"><input id="group_roll_distance' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;" onkeypress="return on_key_press_int(this)"/><div>m</div></td>'
				+' </tr></table>';
}

function toAddSP(){
	spIndex++;
	var tr = document.getElementById("trSP_"+spIndex);
	if(tr != null){
		document.getElementById("trSP_hr_"+spIndex).style.display = "block";
		document.getElementById("trSP_"+spIndex).style.display = "block";
		return;
	}
	var rowNum = spRows;
	spRows++;
	var tr = document.getElementById("table2").insertRow();
	tr.id = "trSP_hr_" + rowNum;
	tr.insertCell().innerHTML = '<table width="100%"><tr><td width="2%" align="right"></td><td width="98%"><hr width="95%"></td></tr></table>';
	var tr = document.getElementById("table2").insertRow();
	tr.id = "trSP_" + rowNum;
	tr.insertCell().innerHTML = '<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="sp_table_'+spIndex+'">'
				+' <tr class="even"><td class="inquire_item6">炸药类型：</td>'
				+' <td class="inquire_form6"><input id="method2_no' + '_' + rowNum+'" type="hidden" value=""/><input id="bsflag2' + '_' + rowNum+'" type="hidden" value="0"/>'
				+' <input id="dynamite_type' + '_' + rowNum+'" type="text" value=""  class="input_width"/></td>'
				+' <td class="inquire_item6">组合方式：</td>'
    			+' <td class="inquire_form6"><input id="well_array_type' + '_' + rowNum+'" type="text" value="" style="margin-top:4px;" class="input_width"/><div></div></td>'
				+' <td class="inquire_item6">井数：</td>'
   				+' <td class="inquire_form6"><input id="well_num' + '_' + rowNum+'" type="text" value="" style="margin-top:4px;" class="input_width"/><div>口</div></td>'
				+' </tr>'
				+' <tr class="odd"><td class="inquire_item6">井深：</td>'
    			+' <td class="inquire_form6"><input id="well_depth' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>m</div></td>'
				+' <td class="inquire_item6">单井药量：</td>'
				+' <td class="inquire_form6"><input id="explosive_qty' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>kg</div></td>'
				+' <td class="inquire_item6"></td>'
    			+'<td class="inquire_form6"></td>'
				+' </tr></table>';
}

function toAddSource(){
	sourceIndex++;
	var tr = document.getElementById("trSource_"+sourceIndex);
	if(tr != null){
		document.getElementById("trSource_hr_"+sourceIndex).style.display = "block";
		document.getElementById("trSource_"+sourceIndex).style.display = "block";
		return;
	}
	var rowNum = sourceRows;
	sourceRows++;
	var tr = document.getElementById("table3").insertRow();
	tr.id = "trSource_hr_"+rowNum;
	tr.insertCell().innerHTML = '<table width="100%"><tr><td width="2%" align="right"></td><td width="98%"><hr width="95%"></td></tr></table>';
	var tr = document.getElementById("table3").insertRow();
	tr.id = "trSource_"+rowNum;
	tr.insertCell().innerHTML = '<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="source_table_'+sourceIndex+'">'
				+' <tr class="even"><td class="inquire_item6">震源型号11111：</td>'
				+' <td class="inquire_form6"><input id="method3_no' + '_' + rowNum+'" type="hidden" value="" class="input_width" /><input id="bsflag3' + '_' + rowNum+'" type="hidden" value="0"/>'
				+' <input id="source_type' + '_' + rowNum+'" type="text" value=""  class="input_width"/></td>'
				+' <td class="inquire_item6">激发形式：</td>'
    			+' <td class="inquire_form6"><input id="excitation_form' + '_' + rowNum+'" type="text" value="" style="margin-top:4px;" class="input_width"/><div>m</div></td>'
				+' <td class="inquire_item6">滑动时间：</td>'
   				+' <td class="inquire_form6"><input id="sliding_time' + '_' + rowNum+'" type="text" value="" style="margin-top:4px;" class="input_width"/><div>s</div></td>'
				+' </tr>'
				+' <tr class="odd"><td class="inquire_item6">组合台数：</td>'
    			+' <td class="inquire_form6"><input id="vibrator_num' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>台</div></td>'
				+' <td class="inquire_item6">震动次数：</td>'
				+' <td class="inquire_form6"><input id="sweeping_times' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>次</div></td>'
				+' <td class="inquire_item6">扫描长度：</td>'
    			+'<td class="inquire_form6"><input id="scan_length' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>s</div></td>'
				+' </tr>'
				+' <tr class="even"><td class="inquire_item6">扫描频率：</td>'
    			+' <td class="inquire_form6"><input id="scan_width' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>Hz</div></td>'
				+' <td class="inquire_item6">驱动幅度：</td>'
				+' <td class="inquire_form6"><input id="drive_level' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>%</div></td>'
				+' <td class="inquire_item6">扫描方式：</td>'
    			+'<td class="inquire_form6"><input id="sweeping_method' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div></div></td>'
				+' </tr>'
				+' <tr class="odd"><td class="inquire_item6">震动方式：</td>'
    			+' <td class="inquire_form6"><input id="sweeping_type' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div></div></td>'
				+' <td class="inquire_item6">组合形式：</td>'
				+' <td class="inquire_form6"><input id="source_array_type' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div></div></td>'
				+' <td class="inquire_item6">组合基距：</td>'
    			+'<td class="inquire_form6"><input id="source_array_interval' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>m</div></td>'
				+' </tr></table>';
}

function toAddGeophone(){
	geophoneIndex++;
	var tr = document.getElementById("trGeophone_"+geophoneIndex);
	if(tr != null){
		document.getElementById("trGeophone_hr_"+geophoneIndex).style.display = "block";
		document.getElementById("trGeophone_"+geophoneIndex).style.display = "block";
		return;
	}
	var rowNum = geophoneRows;
	geophoneRows++;
	var tr = document.getElementById("table4").insertRow();
	tr.id = "trGeophone_hr_"+rowNum;
	tr.insertCell().innerHTML = '<table width="100%"><tr><td width="2%" align="right"></td><td width="98%"><hr width="95%"></td></tr></table>';
	var tr = document.getElementById("table4").insertRow();
	tr.id = "trGeophone_"+rowNum;
	tr.insertCell().innerHTML = '<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="geophone_table_'+geophoneIndex+'">'
				+' <tr class="even"><td class="inquire_item6">检波器类型：</td>'
				+' <td class="inquire_form6"><input id="method4_no' + '_' + rowNum+'" type="hidden" value="" class="input_width" /><input id="bsflag4' + '_' + rowNum+'" type="hidden" value="0"/>'
				+' <input id="geophone_model' + '_' + rowNum+'" type="text" value=""  class="input_width"/></td>'
				+' <td class="inquire_item6">组合个数：</td>'
    			+' <td class="inquire_form6"><input id="geophone_comb_num' + '_' + rowNum+'" type="text" value="" style="margin-top:4px;" class="input_width"/><div>个</div></td>'
				+' <td class="inquire_item6">组合方式:</td>'
   				+' <td class="inquire_form6"><input id="geophone_comb_style' + '_' + rowNum+'" type="text" value="" style="margin-top:4px;" class="input_width"/><div></div></td>'
				+' </tr>'
				+' <tr class="odd"><td class="inquire_item6">检波器间距：</td>'
    			+' <td class="inquire_form6"><input id="geophone_interval' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>m</div></td>'
				+' <td class="inquire_item6">组合基距：</td>'
				+' <td class="inquire_form6"><input id="geophone_pat_distance' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>m</div></td>'
				+' <td class="inquire_item6">组合高差：</td>'
    			+'<td class="inquire_form6"><input id="geophone_comb_height' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>m</div></td>'
				+' </tr>'
				+' <tr class="even"><td class="inquire_item6">检波器埋置：</td>'
    			+' <td class="inquire_form6"><input id="geophone_planting' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>cm</div></td>'
				+' <td class="inquire_item6"></td>'
				+' <td class="inquire_form6"></td>'
				+' <td class="inquire_item6"></td>'
    			+'<td class="inquire_form6"></td>'
				+' </tr></table>';
}

function toAddInstrument(){
	instrumentIndex++;
	var tr = document.getElementById("trInstrument_"+instrumentIndex);
	if(tr != null){
		document.getElementById("trInstrument_hr_"+instrumentIndex).style.display = "block";
		document.getElementById("trInstrument_"+instrumentIndex).style.display = "block";
		return;
	}
	var rowNum = instrumentRows;
	instrumentRows++;
	var tr = document.getElementById("table5").insertRow();
	tr.id = "trInstrument_hr_" + rowNum;
	tr.insertCell().innerHTML = '<table width="100%"><tr><td width="2%" align="right"></td><td width="98%"><hr width="95%"></td></tr></table>';
	var tr = document.getElementById("table5").insertRow();
	tr.id = "trInstrument_" + rowNum;
	tr.insertCell().innerHTML = '<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="instrument_table_'+instrumentIndex+'">'
				+' <tr class="even"><td class="inquire_item6">仪器型号：</td>'
				+' <td class="inquire_form6"><input id="method5_no' + '_' + rowNum+'" name="wa3d_id" type="hidden" value="" class="input_width" /><input id="bsflag5' + '_' + rowNum+'" type="hidden" value="0"/>'
				+' <input id="instrument_model' + '_' + rowNum+'" type="text" value=""  class="input_width"/></td>'
				+' <td class="inquire_item6">记录格式：</td>'
    			+' <td class="inquire_form6"><input id="record_format' + '_' + rowNum+'" type="text" value="" style="margin-top:4px;" class="input_width"/><div></div></td>'
				+' <td class="inquire_item6">采样间隔:</td>'
   				+' <td class="inquire_form6"><input id="sample_interval' + '_' + rowNum+'" type="text" value="" style="margin-top:4px;" class="input_width" onkeypress="return on_key_press_int(this)"/><div>ms</div></td>'
				+' </tr>'
				+' <tr class="odd"><td class="inquire_item6">记录长度：</td>'
    			+' <td class="inquire_form6"><input id="record_len' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;" onkeypress="return on_key_press_int(this)"/><div>s</div></td>'
				+' <td class="inquire_item6">前放增益：</td>'
				+' <td class="inquire_form6"><input id="preamplifier_gain' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;" onkeypress="return on_key_press_int(this)"/><div>dB</div></td>'
				+' <td class="inquire_item6">低截频率：</td>'
    			+'<td class="inquire_form6"><input id="low_cut' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>Hz</div></td>'
				+' </tr>'
				+' <tr class="even"><td class="inquire_item6">高截频率：</td>'
    			+' <td class="inquire_form6"><input id="high_cut' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>Hz</div></td>'
				+' <td class="inquire_item6">滤波方式：</td>'
				+' <td class="inquire_form6"><input id="filtering_method' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/></td>'
				+' <td class="inquire_item6"></td>'
    			+'<td class="inquire_form6"></td>'
				+' </tr></table>';
}

function toDeleteLayout(){
	var rowNum = layoutIndex;
	if(rowNum <= 1){
		return;	
	}
	var line = document.getElementById("trLayout_hr_"+rowNum);
	var dataLine = document.getElementById("trLayout_"+rowNum);
	var record_id = document.getElementById("method1_no_"+rowNum).value;
	if(record_id!=""){
		line.style.display = 'none';
		dataLine.style.display = 'none';
		document.getElementsByName("bsflag1_"+rowNum)[0].value = '1';
		layoutIndex--;
	}else{
		line.parentNode.removeChild(line);
		dataLine.parentNode.removeChild(dataLine);
		layoutRows--;
		layoutIndex--;
	}
}

function toDeleteSP(){
	var rowNum = spIndex;
	if(rowNum <= 1){
		return;	
	}	
	var line = document.getElementById("trSP_hr_"+rowNum);
	var dataLine = document.getElementById("trSP_"+rowNum);
	var record_id = document.getElementById("method2_no_"+rowNum).value;
	if(record_id!=""){
		line.style.display = 'none';
		dataLine.style.display = 'none';
		document.getElementsByName("bsflag2_"+rowNum)[0].value = '1';
		spIndex--;
	}else{
		line.parentNode.removeChild(line);
		dataLine.parentNode.removeChild(dataLine);
		spRows--;
		spIndex--;
	}
}
function toDeleteSource(){
	var rowNum = sourceIndex;
	if(rowNum <= 1){
		return;	
	}	
	var line = document.getElementById("trSource_hr_"+rowNum);
	var dataLine = document.getElementById("trSource_"+rowNum);
	var record_id = document.getElementById("method3_no_"+rowNum).value;
	if(record_id!=""){
		line.style.display = 'none';
		dataLine.style.display = 'none';
		document.getElementsByName("bsflag3_"+rowNum)[0].value = '1';
		sourceIndex--;
	}else{
		line.parentNode.removeChild(line);
		dataLine.parentNode.removeChild(dataLine);
		sourceRows--;
		sourceIndex--;
	}
}
function toDeleteGeophone(){
	var rowNum = geophoneIndex;
	if(rowNum <= 1){
		return;	
	}	
	var line = document.getElementById("trGeophone_hr_"+rowNum);
	var dataLine = document.getElementById("trGeophone_"+rowNum);
	var record_id = document.getElementById("method4_no_"+rowNum).value;
	if(record_id!=""){
		line.style.display = 'none';
		dataLine.style.display = 'none';
		document.getElementsByName("bsflag4_"+rowNum)[0].value = '1';
		geophoneIndex--;
	}else{
		line.parentNode.removeChild(line);
		dataLine.parentNode.removeChild(dataLine);
		geophoneRows--;
		geophoneIndex--;
	}
}
function toDeleteInstrument(){
	var rowNum = instrumentIndex;
	if(rowNum <= 1){
		return;	
	}	
	var line = document.getElementById("trInstrument_hr_"+rowNum);
	var dataLine = document.getElementById("trInstrument_"+rowNum);
	var record_id = document.getElementById("method5_no_"+rowNum).value;
	if(record_id!=""){
		line.style.display = 'none';
		dataLine.style.display = 'none';
		document.getElementsByName("bsflag5_"+rowNum)[0].value = '1';
		instrumentIndex--;
	}else{
		line.parentNode.removeChild(line);
		dataLine.parentNode.removeChild(dataLine);
		instrumentRows--;
		instrumentIndex--;
	}
}
</script>
</head>
<body onload="loadData()" style="overflow-y: auto;background: #fff;">
<form id="CheckForm"  name="CheckForm" action="" method="post">
<table  border="0" cellpadding="0" cellspacing="0" width="100%" id="table1">
<tr><td>
<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height">
  <tr style="background-color: #97cbfd">
	<td align="left" width="90%">
		<span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">1、 观测系统</font></span>
	<td>
	<td width="10%" align="right">
	<%if(action != "view" && !"view".equals(action)){ %><table><tr><td><auth:ListButton functionId="" css="zj" event="onclick='toAddLayout()'" title="JCDP_btn_add"></auth:ListButton></td>
		<td><auth:ListButton functionId="" css="sc" event="onclick='toDeleteLayout()'" title="JCDP_btn_edit"></auth:ListButton></td></tr></table>
	<%} %>
	</td>
  </tr>
 </table>
 <td></tr>
 </table>
 <table  border="0" cellpadding="0" cellspacing="0" width="100%" id="table2">
	<tr><td>
		<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height">
  			<tr style="background-color: #97cbfd">
			<td align="left" width="90%" id="td_section_sp"></td>
			<td width="10%" align="right">
			<%if(action != "view" && !"view".equals(action)){ %><table><tr><td><auth:ListButton functionId="" css="zj" event="onclick='toAddSP()'" title="JCDP_btn_add"></auth:ListButton></td>
				<td><auth:ListButton functionId="" css="sc" event="onclick='toDeleteSP()'" title="JCDP_btn_edit"></auth:ListButton></td></tr></table>
				<%} %>
			</td>
  			</tr>
 		</table>
 	<td></tr>
 </table>
 <table  border="0" cellpadding="0" cellspacing="0" width="100%" id="table3">
	<tr><td>
		<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height">
  			<tr style="background-color: #97cbfd">
			<td align="left" width="90%" id="td_section_source"></td>
			<td width="10%" align="right"><%if(action != "view" && !"view".equals(action)){ %><table><tr><td><auth:ListButton functionId="" css="zj" event="onclick='toAddSource()'" title="JCDP_btn_add"></auth:ListButton></td>
				<td><auth:ListButton functionId="" css="sc" event="onclick='toDeleteSource()'" title="JCDP_btn_edit"></auth:ListButton></td></tr></table><%} %>
			</td>
  			</tr>
 		</table>
 	<td></tr>
 </table>
 
 
 
 

 
 
 
 
 <table  border="0" cellpadding="0" cellspacing="0" width="100%" id="table5">
	<tr><td>
		<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height">
  			<tr style="background-color: #97cbfd">
			<td align="left" width="90%" id="td_section_instrument"></td>
			<td width="10%" align="right"><%if(action != "view" && !"view".equals(action)){ %><table><tr><td><auth:ListButton functionId="" css="zj" event="onclick='toAddInstrument()'" title="JCDP_btn_add"></auth:ListButton></td>
				<td><auth:ListButton functionId="" css="sc" event="onclick='toDeleteInstrument()'" title="JCDP_btn_edit"></auth:ListButton></td></tr></table><%} %>
			</td>
  			</tr>
 		</table>
 	<td></tr>
 </table>
<div id="oper_div">
<%if(action != "view" && !"view".equals(action)){ %>
   	<span class="tj_btn"><a href="#" onclick="toSave()"></a></span>
<%} %>
</div>
</form>
</body>
</html>
