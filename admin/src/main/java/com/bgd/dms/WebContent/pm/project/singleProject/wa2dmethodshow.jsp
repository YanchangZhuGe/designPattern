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

function loadData(){
	//默认都添加一行数据
	toAddLayout();
	toAddSP();
	toAddSource();
	toAddGeophone();
	toAddInstrument();
	
	// 取所有数据
	var retObj = jcdpCallService("WorkMethodSrv", "getWork2Method", "projectInfoNo="+project_info_no);
	var mainData = retObj.mainData;
	var layoutData = retObj.layoutData;
	var spData = retObj.spData;
	var sourceData = retObj.sourceData;
	var geophoneData = retObj.geophoneData;
	var instrumentData = retObj.instrumentData;
	
	if(mainData != null){
		//初始第一行数据
		maindata_rowid = mainData.wa2d_no;
		setLayoutData(mainData,1);
		setSPData(mainData,1);
		setSourceData(mainData,1);
		setGeophoneData(mainData,1);
		setInstrumentData(mainData,1);
	}
	// 加载观测系统段数据
	if(layoutData != null){
		for(var i=0;i<layoutData.length;i++){
			var record = layoutData[i];
			var order_num = record.order_num;
			if(order_num == "1"){
				first_layout_rowid = record.wa2d_no;
				continue;
			}else{
				toAddLayout();
				var rowIndex = layoutRows - 1;
				setLayoutData(record, rowIndex);
			}
		}
	}
	if("5000100003000000001" == buildMethod){
		//井炮
		document.getElementById("table3").style.display = "none";
		document.getElementById("td_section_sp").innerHTML = '<span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">2、激发参数: 井炮激发</font></span>';
		document.getElementById("td_section_geophone").innerHTML = '<span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">3、组合检波</font></span>';
		document.getElementById("td_section_instrument").innerHTML = '<span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">4、仪器参数</font></span>';
		// 加载得井炮段数据
		if(spData != null){
			for(var i=0;i<spData.length;i++){
				var record = spData[i];
				var order_num = record.order_num;
				if(order_num == "1"){
					first_sp_rowid = record.wa2d_no;
					continue;
				}else{
					toAddSP();
					var rowIndex = spRows - 1;
					setSPData(record, rowIndex);
				}
			}
		}
	}else if("5000100003000000002" == buildMethod){
		//可控震源
		document.getElementById("table2").style.display = "none";
		document.getElementById("td_section_source").innerHTML = '<span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">2、激发参数: 可控震源激发</font></span>';
		document.getElementById("td_section_geophone").innerHTML = '<span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">3、组合检波</font></span>';
		document.getElementById("td_section_instrument").innerHTML = '<span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">4、仪器参数</font></span>';
		// 加载可控震源段数据
		if(sourceData != null){
			for(var i=0;i<sourceData.length;i++){
				var record = sourceData[i];
				var order_num = record.order_num;
				if(order_num == "1"){
					first_source_rowid = record.wa2d_no;
					continue;
				}else{
					toAddSource();
					var rowIndex = sourceRows - 1;
					setSourceData(record, rowIndex);
				}
			}
		}
	}else if("5000100003000000004" == buildMethod){
		//井炮加震源
		document.getElementById("td_section_sp").innerHTML = '<span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">2、激发参数: 井炮激发</font></span>';
		document.getElementById("td_section_source").innerHTML = '<span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">3、激发参数: 可控震源激发</font></span>';
		document.getElementById("td_section_geophone").innerHTML = '<span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">4、组合检波</font></span>';
		document.getElementById("td_section_instrument").innerHTML = '<span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">5、仪器参数</font></span>';
		
		// 加载井炮段数据
		if(spData != null){
			for(var i=0;i<spData.length;i++){
				var record = spData[i];
				var order_num = record.order_num;
				if(order_num == "1"){
					first_sp_rowid = record.wa2d_no;
					continue;
				}else{
					toAddSP();
					var rowIndex = spRows - 1;
					setSPData(record, rowIndex);
				}
			}
		}
		// 加载可控震源段数据
		if(sourceData != null){
			for(var i=0;i<sourceData.length;i++){
				var record = sourceData[i];
				var order_num = record.order_num;
				if(order_num == "1"){
					first_source_rowid = record.wa2d_no;
					continue;
				}else{
					toAddSource();
					var rowIndex = sourceRows - 1;
					setSourceData(record, rowIndex);
				}
			}
		}
	}
	// 加载检波段数据
	if(geophoneData != null){
		for(var i=0;i<geophoneData.length;i++){
			var record = geophoneData[i];
			var order_num = record.order_num;
			if(order_num == "1"){
				first_geophone_rowid = record.wa2d_no;
				continue;
			}else{
				toAddGeophone();
				var rowIndex = geophoneRows - 1;
				setGeophoneData(record, rowIndex);
			}
		}
	}
	// 加载仪器段数据
	if(instrumentData != null){
		for(var i=0;i<instrumentData.length;i++){
			var record = instrumentData[i];
			var order_num = record.order_num;
			if(order_num == "1"){
				first_instrument_rowid = record.wa2d_no;
				continue;
			}else{
				toAddInstrument();
				var rowIndex = instrumentRows - 1;
				setInstrumentData(record, rowIndex);
			}
		}
	}
	
	parent.document.all("if5").style.height=document.body.scrollHeight; 
	parent.document.all("if5").style.width=document.body.scrollWidth; 
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
	var tr_1 = document.getElementById("table1").insertRow();
	var td_1 = tr_1.insertCell();
    td_1.colSpan = "6";
    td_1.innerHTML = "<hr width='95%'>";
	
	var cells = 0;
	var rows = 1;
	var tr;
	
	if(record.layout != null && record.layout != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table1").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "观测系统类型：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.layout;
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "观测系统类型：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.layout;
		}
	}
	
	if(record.receiving_track_num != null && record.receiving_track_num != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table1").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "接收道数：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.receiving_track_num+"&nbsp;道";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "接收道数：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.receiving_track_num+"&nbsp;道";
		}
	}
	
	if(record.track_interval != null && record.track_interval != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table1").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "道距：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.track_interval+"&nbsp;m";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "道距：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.track_interval+"&nbsp;m";
		}
	}
	
	if(record.track_interval != null && record.track_interval != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table1").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "道距：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.track_interval+"&nbsp;m";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "道距：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.track_interval+"&nbsp;m";
		}
	}
	
	if(record.receiving_line_distance != null && record.receiving_line_distance != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table1").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "接收线距：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.receiving_line_distance+"&nbsp;m";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "接收线距：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.receiving_line_distance+"&nbsp;m";
		}
	}
	
	if(record.receiving_line_distance != null && record.receiving_line_distance != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table1").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "接收线距：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.receiving_line_distance+"&nbsp;m";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "接收线距：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.receiving_line_distance+"&nbsp;m";
		}
	}
	
	if(record.fold != null && record.fold != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table1").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "覆盖次数：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.fold+"&nbsp;次";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "覆盖次数：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.fold+"&nbsp;次";
		}
	}
	
	if(record.vertical_array != null && record.vertical_array != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table1").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "纵向排列方式：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.vertical_array;
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "纵向排列方式：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.vertical_array;
		}
	}
	
	if(record.single_line_fold != null && record.single_line_fold != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table1").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "单线覆盖次数(宽线)：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.single_line_fold+"&nbsp;次";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "单线覆盖次数(宽线)：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.single_line_fold+"&nbsp;次";
		}
	}
	
	if(record.cmp_line_fold != null && record.cmp_line_fold != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table1").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "CMP线满覆盖(宽线)：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.cmp_line_fold+"&nbsp;次";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "CMP线满覆盖(宽线)：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.cmp_line_fold+"&nbsp;次";
		}
	}
}

function setSPData(record, lineNum){
	var tr_1 = document.getElementById("table2").insertRow();
	var td_1 = tr_1.insertCell();
    td_1.colSpan = "6";
    td_1.innerHTML = "<hr width='95%'>";
	
	var cells = 0;
	var rows = 1;
	var tr;
	
	if(record.dynamite_type != null && record.dynamite_type != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table2").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "炸药类型：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.dynamite_type;
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "炸药类型：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.dynamite_type;
		}
	}
	
	if(record.well_array_type != null && record.well_array_type != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table2").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "组合方式：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.well_array_type;
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "组合方式：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.well_array_type;
		}
	}
	
	if(record.well_num != null && record.well_num != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table2").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "井数：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.well_num+"&nbsp;口";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "井数：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.well_num+"&nbsp;口";
		}
	}
	
	if(record.well_depth != null && record.well_depth != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table2").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "井深：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.well_depth+"&nbsp;m";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "井深：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.well_depth+"&nbsp;m";
		}
	}
	
	if(record.explosive_qty != null && record.explosive_qty != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table2").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "单井药量：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.explosive_qty+"&nbsp;kg";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "单井药量：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.explosive_qty+"&nbsp;kg";
		}
	}
}

function setSourceData(record, lineNum){
	var tr_1 = document.getElementById("table3").insertRow();
	var td_1 = tr_1.insertCell();
    td_1.colSpan = "6";
    td_1.innerHTML = "<hr width='95%'>";
	
	var cells = 0;
	var rows = 1;
	var tr;
	
	if(record.source_type != null && record.source_type != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table3").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "震源型号：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.source_type;
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "震源型号：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.source_type;
		}
	}

	if(record.excitation_form != null && record.excitation_form != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table3").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "激发形式：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.excitation_form+"&nbsp;m";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "激发形式：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.excitation_form+"&nbsp;m";
		}
	}

	if(record.sliding_time != null && record.sliding_time != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table3").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "滑动时间：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.sliding_time+"&nbsp;s";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "滑动时间：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.sliding_time+"&nbsp;s";
		}
	}
	
	if(record.vibrator_num != null && record.vibrator_num != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table3").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "组合台数：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.vibrator_num+"&nbsp;台";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "组合台数：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.vibrator_num+"&nbsp;台";
		}
	}
	
	if(record.sweeping_times != null && record.sweeping_times != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table3").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "震动次数：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.sweeping_times+"&nbsp;次";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "震动次数：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.sweeping_times+"&nbsp;次";
		}
	}
	
	if(record.scan_length != null && record.scan_length != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table3").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "扫描长度：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.scan_length+"&nbsp;s";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "扫描长度：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.scan_length+"&nbsp;s";
		}
	}
	
	if(record.scan_width != null && record.scan_width != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table3").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "扫描频率：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.scan_width+"&nbsp;Hz";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "扫描频率：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.scan_width+"&nbsp;Hz";
		}
	}
	
	if(record.drive_level != null && record.drive_level != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table3").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "驱动幅度：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.drive_level+"&nbsp;%";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "驱动幅度：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.drive_level+"&nbsp;%";
		}
	}
	
	if(record.sweeping_method != null && record.sweeping_method != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table3").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "扫描方式：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.sweeping_method;
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "扫描方式：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.sweeping_method;
		}
	}
	
	if(record.sweeping_type != null && record.sweeping_type != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table3").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "震动方式：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.sweeping_type;
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "震动方式：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.sweeping_type;
		}
	}
	
	if(record.source_array_type != null && record.source_array_type != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table3").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "组合形式：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.source_array_type;
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "组合形式：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.source_array_type;
		}
	}
	
	if(record.source_array_interval != null && record.source_array_interval != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table3").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "组合基距：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.source_array_interval+"&nbsp;m";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "组合基距：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.source_array_interval+"&nbsp;m";
		}
	}
}
function setGeophoneData(record, lineNum){
	var tr_1 = document.getElementById("table4").insertRow();
	var td_1 = tr_1.insertCell();
    td_1.colSpan = "6";
    td_1.innerHTML = "<hr width='95%'>";
	
	var cells = 0;
	var rows = 1;
	var tr;
	
	if(record.geophone_model != null && record.geophone_model != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table4").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "检波器类型：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.geophone_model;
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "检波器类型：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.geophone_model;
		}
	}
	
	if(record.geophone_comb_num != null && record.geophone_comb_num != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table4").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "组合个数：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.geophone_comb_num+"&nbsp;个";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "组合个数：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.geophone_comb_num+"&nbsp;个";
		}
	}
	
	if(record.geophone_comb_style != null && record.geophone_comb_style != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table4").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "组合方式：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.geophone_comb_style;
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "组合方式：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.geophone_comb_style;
		}
	}
	
	if(record.geophone_interval != null && record.geophone_interval != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table4").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "检波器间距：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.geophone_interval+"&nbsp;";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "检波器间距：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.geophone_interval+"&nbsp;";
		}
	}
	
	if(record.geophone_pat_distance != null && record.geophone_pat_distance != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table4").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "组合基距：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.geophone_pat_distance+"&nbsp;";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "组合基距：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.geophone_pat_distance+"&nbsp;";
		}
	}
	
	if(record.geophone_comb_height != null && record.geophone_comb_height != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table4").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "组合高差：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.geophone_comb_height+"&nbsp;";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "组合高差：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.geophone_comb_height+"&nbsp;";
		}
	}
	
	if(record.geophone_planting != null && record.geophone_planting != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table4").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "检波器埋置：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.geophone_planting+"&nbsp;cm";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "检波器埋置：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.geophone_planting+"&nbsp;cm";
		}
	}
}
function setInstrumentData(record, lineNum){
	var tr_1 = document.getElementById("table5").insertRow();
	var td_1 = tr_1.insertCell();
    td_1.colSpan = "6";
    td_1.innerHTML = "<hr width='95%'>";
	
	var cells = 0;
	var rows = 1;
	var tr;
	
	if(record.instrument_model != null && record.instrument_model != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table5").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "仪器型号：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.instrument_model;
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "仪器型号：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.instrument_model;
		}
	}

	if(record.record_format != null && record.record_format != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table5").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "记录格式：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.record_format;
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "记录格式：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.record_format;
		}
	}
	
	if(record.sample_interval != null && record.sample_interval != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table5").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "采样间隔：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.sample_interval+"&nbsp;ms";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "采样间隔：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.sample_interval+"&nbsp;ms";
		}
	}
	
	if(record.record_len != null && record.record_len != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table5").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "记录长度：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.record_len+"&nbsp;s";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "记录长度：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.record_len+"&nbsp;s";
		}
	}
	
	if(record.preamplifier_gain != null && record.preamplifier_gain != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table5").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "前放增益：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.preamplifier_gain+"&nbsp;dB";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "前放增益：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.preamplifier_gain+"&nbsp;dB";
		}
	}
	
	if(record.preamplifier_gain != null && record.preamplifier_gain != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table5").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "低截频率：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.preamplifier_gain+"&nbsp;Hz";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "低截频率：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.preamplifier_gain+"&nbsp;Hz";
		}
	}
	
	if(record.high_cut != null && record.high_cut != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table5").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "高截频率：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.high_cut+"&nbsp;Hz";
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "高截频率：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.high_cut+"&nbsp;Hz";
		}
	}
	
	if(record.filtering_method != null && record.filtering_method != ""){
		cells++;
		if(cells%3 == 1){
			tr = document.getElementById("table5").insertRow();
			rows++;
			if(rows % 2 != 0){
				tr.className = "even";
			} else {
				tr.className = "odd";
			}
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "滤波方式：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.filtering_method;
		} else {
			var td = tr.insertCell();
			td.className = "inquire_item6";
			td.innerHTML = "滤波方式：";
			td = tr.insertCell();
			td.className = "inquire_form6";
			td.innerHTML = record.filtering_method;
		}
	}
	
}
function toAddLayout(){
	layoutIndex++;
	var tr = document.getElementById("trLayout_"+layoutIndex);
	if(tr != null){
		document.getElementById("trLayout_hr_"+layoutIndex).style.display = "block";
		document.getElementById("trLayout_"+layoutIndex).style.display = "block";
		return;
	}

}

function toAddSP(){
	spIndex++;
	var tr = document.getElementById("trSP_"+spIndex);
	if(tr != null){
		document.getElementById("trSP_hr_"+spIndex).style.display = "block";
		document.getElementById("trSP_"+spIndex).style.display = "block";
		return;
	}
}

function toAddSource(){
	sourceIndex++;
	var tr = document.getElementById("trSource_"+sourceIndex);
	if(tr != null){
		document.getElementById("trSource_hr_"+sourceIndex).style.display = "block";
		document.getElementById("trSource_"+sourceIndex).style.display = "block";
		return;
	}

}

function toAddGeophone(){
	geophoneIndex++;
	var tr = document.getElementById("trGeophone_"+geophoneIndex);
	if(tr != null){
		document.getElementById("trGeophone_hr_"+geophoneIndex).style.display = "block";
		document.getElementById("trGeophone_"+geophoneIndex).style.display = "block";
		return;
	}

}

function toAddInstrument(){
	instrumentIndex++;
	var tr = document.getElementById("trInstrument_"+instrumentIndex);
	if(tr != null){
		document.getElementById("trInstrument_hr_"+instrumentIndex).style.display = "block";
		document.getElementById("trInstrument_"+instrumentIndex).style.display = "block";
		return;
	}

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
<tr><td colspan="6">
<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height">
  <tr style="background-color: #97cbfd">
	<td align="left" width="90%">
		<span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">1、 观测系统</font></span>
	<td>
	<td width="10%" align="right">
		<%if(action != "view" && !"view".equals(action)){ %>
		<table>
			<tr>
				<td><auth:ListButton functionId="" css="zj"
						event="onclick='toAddLayout()'" title="JCDP_btn_add"></auth:ListButton>
				</td>
				<td><auth:ListButton functionId="" css="sc"
						event="onclick='toDeleteLayout()'" title="JCDP_btn_edit"></auth:ListButton>
				</td>
			</tr>
		</table>
		<%} %>
	</td>
  </tr>
 </table>
 <td></tr>
 </table>
 <table  border="0" cellpadding="0" cellspacing="0" width="100%" id="table2">
	<tr><td colspan="6">
		<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height">
  			<tr style="background-color: #97cbfd">
			<td align="left" width="90%" id="td_section_sp"></td>
  			</tr>
 		</table>
 	<td></tr>
 </table>
 <table  border="0" cellpadding="0" cellspacing="0" width="100%" id="table3">
	<tr><td colspan="6">
		<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height">
  			<tr style="background-color: #97cbfd">
			<td align="left" width="90%" id="td_section_source"></td>
  			</tr>
 		</table>
 	<td></tr>
 </table>
 <table  border="0" cellpadding="0" cellspacing="0" width="100%" id="table4">
	<tr><td colspan="6">
		<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height">
  			<tr style="background-color: #97cbfd">
			<td align="left" width="90%" id="td_section_geophone"></td>
  			</tr>
 		</table>
 	<td></tr>
 </table>
 <table  border="0" cellpadding="0" cellspacing="0" width="100%" id="table5">
	<tr><td colspan="6">
		<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height">
  			<tr style="background-color: #97cbfd">
			<td align="left" width="90%" id="td_section_instrument"></td>
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
