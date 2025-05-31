<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String userId =  user.getEmpId();
	
	
	String orgSubId = user.getOrgSubjectionId();
	String orgId =  user.getOrgId();
	String c_type = request.getParameter("c_type");
 

	
	String projectInfoNo = user.getProjectInfoNo();
	String projectName = user.getProjectName();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());
	String message = "";
	if(resultMsg != null){
		message = resultMsg.getValue("message");
		 c_type = resultMsg.getValue("c_type_s");

	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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
<script language="javaScript">
cruConfig.contextPath =  "<%=contextPath%>";
var projectInfoNo = "<%=projectInfoNo%>";
var projectName = "<%=projectName%>";
var exportRows = new Array();
var message = "<%=message%>";

var c_type="<%=c_type%>"; 
if(message != "" && message != 'null'){
	alert(message);
}
var table_Name="";
var fromPage = "";
if(c_type =="2"){
	table_Name="gp_ops_3dws_complete";
	fromPage = "borderComplete";
}else if(c_type =="1"){
	fromPage = "borderDesign";
	table_Name="gp_ops_3dws_design";
}

var posarray = new Array("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z");
var index1 = 0;
var index2 = 0;
var index3 = 0;
var index4 = 0;
var index5 = 0;

function toAdd1(){
	if(index1 > 25){
		return;
	}
	var line = document.getElementById("line_1_" + index1);
	if(line != null){
		line.style.display = 'block';
		//
		index1++;
		return;
	}
	var tr = document.getElementById("table1").insertRow();
	tr.id = "line_1_" + index1;
	var td = tr.insertCell(0);
	var posname = posarray[index1];
	td.innerHTML = '<input type="text" name="pos_1_' + index1 + '" value="'+posname +'" size="4" readonly>';
	var td = tr.insertCell(1);
	td.align="left";
	td.innerHTML = '<input type="text" name="xAxis_1_' + index1 +'" size="13" onkeypress="return key_press_check(this)">';
	var td = tr.insertCell(2);
	td.align="left";
	td.innerHTML = '<input type="text" name="yAxis_1_' + index1 +'" size="13" onkeypress="return key_press_check(this)">';
	var td = tr.insertCell(3);
	td.innerHTML = '<input type="hidden" name="record_id_1_'+index1+'" value=""/><input type="hidden" name="bsflag_1_'+index1+'" value="0" /><input type="hidden" name="projectInfoNo_1_'+index1+'" value="'+projectInfoNo+'" />';
	index1++;
}
function toAdd2(){	
	if(index2 > 25){
		return;
	}
	var line = document.getElementById("line_2_" + index2);
	if(line != null){
		line.style.display = 'block';
		//
		index2++;
		return;
	}
	var tr = document.getElementById("table2").insertRow();
	tr.id = "line_2_" + index2;
	var td = tr.insertCell(0);
	var posname = posarray[index2] + "1";
	td.innerHTML = '<input type="text" name="pos_2_' + index2 + '" value="'+posname +'" size="4" readonly>';
	var td = tr.insertCell(1);
	td.align="left";
	td.innerHTML = '<input type="text" name="xAxis_2_' + index2 +'" size="13" onkeypress="return key_press_check(this)">';
	var td = tr.insertCell(2);
	td.align="left";
	td.innerHTML = '<input type="text" name="yAxis_2_' + index2 +'" size="13" onkeypress="return key_press_check(this)">';
	var td = tr.insertCell(3);
	td.innerHTML = '<input type="hidden" name="record_id_2_'+index2+'" value=""/><input type="hidden" name="bsflag_2_'+index2+'" value="0" /><input type="hidden" name="projectInfoNo_2_'+index2+'" value="'+projectInfoNo+'" />';
	index2++;
}
function toAdd3(){
	if(index3 > 25){
		return;
	}
	var line = document.getElementById("line_3_" + index3);
	if(line != null){
		line.style.display = 'block';
		//
		index3++;
		return;
	}
	var tr = document.getElementById("table3").insertRow();
	tr.id = "line_3_" + index3;
	var td = tr.insertCell(0);
	var posname = posarray[index3] + "2";
	td.innerHTML = '<input type="text" name="pos_3_' + index3 + '" value="'+posname +'" size="4" readonly>';
	var td = tr.insertCell(1);
	td.align="left";
	td.innerHTML = '<input type="text" name="xAxis_3_' + index3 +'" size="13" onkeypress="return key_press_check(this)">';
	var td = tr.insertCell(2);
	td.align="left";
	td.innerHTML = '<input type="text" name="yAxis_3_' + index3 +'" size="13" onkeypress="return key_press_check(this)">';
	var td = tr.insertCell(3);
	td.innerHTML = '<input type="hidden" name="record_id_3_'+index3+'" value=""/><input type="hidden" name="bsflag_3_'+index3+'" value="0" /><input type="hidden" name="projectInfoNo_3_'+index3+'" value="'+projectInfoNo+'" />';
	index3++;
}

function toAdd4(){
	if(index4 > 25){
		return;
	}
	var line = document.getElementById("line_4_" + index4);
	if(line != null){
		line.style.display = 'block';
		//
		index4++;
		return;
	}
	var tr = document.getElementById("table4").insertRow();
	tr.id = "line_4_" + index4;
	var td = tr.insertCell(0);
	var posname = posarray[index4] + "3";
	td.innerHTML = '<input type="text" name="pos_4_' + index4 + '" value="'+posname +'" size="4" readonly>';
	var td = tr.insertCell(1);
	td.align="left";
	td.innerHTML = '<input type="text" name="xAxis_4_' + index4 +'" size="13" onkeypress="return key_press_check(this)">';
	var td = tr.insertCell(2);
	td.align="left";
	td.innerHTML = '<input type="text" name="yAxis_4_' + index4 +'" size="13" onkeypress="return key_press_check(this)">';
	var td = tr.insertCell(3);
	td.innerHTML = '<input type="hidden" name="record_id_4_'+index4+'" value=""/><input type="hidden" name="bsflag_4_'+index4+'" value="0" /><input type="hidden" name="projectInfoNo_4_'+index4+'" value="'+projectInfoNo+'" />';
	index4++;
}



function toAdd5(){
	if(index5 > 25){
		return;
	}
	var line = document.getElementById("line_5_" + index5);
	if(line != null){
		line.style.display = 'block';
		//
		index5++;
		return;
	}
	var tr = document.getElementById("table5").insertRow();
	tr.id = "line_5_" + index5;
	var td = tr.insertCell(0); 
	td.innerHTML = '<input type="text" name="xAxis_5_' + index5 +'" size="13" onkeypress="return key_press_check(this)">';	 
	var td = tr.insertCell(1);
	td.innerHTML = '<input type="hidden" name="record_id_5_'+index5+'" value=""/><input type="hidden" name="bsflag_5_'+index5+'" value="0" /><input type="hidden" name="projectInfoNo_5_'+index5+'" value="'+projectInfoNo+'" />';
	index5++;
}

function toDelete1(){
	if(index1 > 1){
		var rowNum = index1 - 1;
		var lineId = "line_1_" + rowNum;
		var line = document.getElementById(lineId);
		var record_id = document.getElementsByName("record_id_1_"+rowNum)[0].value;
		if(record_id!=""){
			line.style.display = 'none';
			document.getElementsByName("bsflag_1_"+rowNum)[0].value = '1';
		}else{
			line.parentNode.removeChild(line);
		}
		index1--;
	}
}

function toDelete2(){
	if(index2 > 1){
		var rowNum = index2 - 1;
		var lineId = "line_2_" + rowNum;
		var line = document.getElementById(lineId);

		var record_id = document.getElementsByName("record_id_2_"+rowNum)[0].value;
		if(record_id!=""){
			line.style.display = 'none';
			document.getElementsByName("bsflag_2_"+rowNum)[0].value = '1';
		}else{
			line.parentNode.removeChild(line);
		}
		index2--;
	}
}

function toDelete3(){
	if(index3 > 1){
		var rowNum = index3 - 1;
		var lineId = "line_3_" + rowNum;
		var line = document.getElementById(lineId);

		var record_id = document.getElementsByName("record_id_3_"+rowNum)[0].value;
		if(record_id!=""){
			line.style.display = 'none';
			document.getElementsByName("bsflag_3_"+rowNum)[0].value = '1';
		}else{
			line.parentNode.removeChild(line);
		}
		index3--;
	}
}

function initData(){
	
	//检波点
		var retObj1 = jcdpCallService("DBDataSrv","queryTableDatas","tableName="+table_Name+"&option=project_info_no='"+projectInfoNo+"'%20and bsflag='0'%20and%20data_type ='2'&order=border_break_point");
 	if(retObj1.datas != null){
		for(var i=0;i<retObj1.datas.length;i++){
			var record = retObj1.datas[i];
			var rowNum = i;
			index1 ++;
			var record_id = record.wa3d_design_no;
			var pos = record.border_break_point;
			var xAxis = record.point_x;
			var yAxis = record.point_y;
			var bsflag = "0";
			
			var tr = document.getElementById("table1").insertRow();
			tr.id = "line_1_" + rowNum;
			var td = tr.insertCell(0);
			td.innerHTML = '<input type="text" name="pos_1_' + rowNum + '" value="' + pos +'" size="4" readonly>';
			var td = tr.insertCell(1);
			td.align="left";
			td.innerHTML = '<input type="text" name="xAxis_1_' + rowNum +'" value="' + xAxis +'" size="13" onkeypress="return key_press_check(this)">';
			var td = tr.insertCell(2);
			td.align="left";
			td.innerHTML = '<input type="text" name="yAxis_1_' + rowNum +'" value="' + yAxis +'" size="13" align="left" onkeypress="return key_press_check(this)">';
			var td = tr.insertCell(3);
			td.innerHTML = '<input type="hidden" name="record_id_1_'+rowNum+'" value="' + record_id +'" /><input type="hidden" name="bsflag_1_'+rowNum+'" value="0" /><input type="hidden" name="projectInfoNo_1_'+rowNum+'" value="'+projectInfoNo+'" />';
			
			var exportRow = {};
			exportRow["1"] = pos;
			exportRow["2"] = xAxis;
			exportRow["3"] = yAxis;
			exportRow["4"] = "";
			exportRow["5"] = "";
			exportRow["6"] = "";
			exportRow["7"] = "";
			exportRow["8"] = "";
			exportRow["9"] = "";
			exportRow["10"] = "";
			exportRow["11"] = "";
			exportRow["12"] = "";
			exportRow["13"] = "";
			exportRows[exportRows.length] = exportRow;
		}
		document.getElementById("initRows1").value = retObj1.datas.length;
	}else{
		toAdd1();
	}
	// 炮点
	var retObj2 = jcdpCallService("DBDataSrv","queryTableDatas","tableName="+table_Name+"&option=project_info_no='"+projectInfoNo+"'%20and%20bsflag='0'%20and%20data_type ='1'&order=border_break_point");
 	if(retObj2.datas != null){
		for(var i=0;i<retObj2.datas.length;i++){
			var record = retObj2.datas[i];
			var rowNum = i;
			index2++;
			var record_id = record.wa3d_design_no;
			var pos = record.border_break_point;
			var xAxis = record.point_x;
			var yAxis = record.point_y;
			var bsflag = "0";
			
			var tr = document.getElementById("table2").insertRow();
			tr.id = "line_2_" + rowNum;
			var td = tr.insertCell(0);
			td.innerHTML = '<input type="text" name="pos_2_' + rowNum + '" value="' + pos +'" size="4" readonly>';
			var td = tr.insertCell(1);
			td.align="left";
			td.innerHTML = '<input type="text" name="xAxis_2_' + rowNum +'" value="' + xAxis +'" size="13" onkeypress="return key_press_check(this)">';
			var td = tr.insertCell(2);
			td.align="left";
			td.innerHTML = '<input type="text" name="yAxis_2_' + rowNum +'" value="' + yAxis +'" size="13" onkeypress="return key_press_check(this)">';
			var td = tr.insertCell(3);
			td.innerHTML = '<input type="hidden" name="record_id_2_'+rowNum+'" value="' + record_id +'" /><input type="hidden" name="bsflag_2_'+rowNum+'" value="0" /><input type="hidden" name="projectInfoNo_2_'+rowNum+'" value="'+projectInfoNo+'" />';
			
			if(i > exportRows.length){
				var exportRow = {};
				exportRow["1"] = "";
				exportRow["2"] = "";
				exportRow["3"] = "";
				exportRow["4"] = pos;
				exportRow["5"] = xAxis;
				exportRow["6"] = yAxis;
				exportRow["7"] = "";
				exportRow["8"] = "";
				exportRow["9"] = "";
				exportRow["10"] = "";
				exportRow["11"] = "";
				exportRow["12"] = "";
				exportRow["13"] = "";
				exportRows[exportRows.length] = exportRow;
			}else{
				var exportRow = exportRows[i];
				exportRow["4"] = pos;
				exportRow["5"] = xAxis;
				exportRow["6"] = yAxis;
				exportRows[i] = exportRow;
			}
		}
		
		document.getElementById("initRows2").value = retObj2.datas.length;
	}else{
		toAdd2();
	}
	//加载数据 满覆盖
	var retObj3 = jcdpCallService("DBDataSrv","queryTableDatas","tableName="+table_Name+"&option=project_info_no='"+projectInfoNo+"'%20and%20bsflag='0'%20and%20data_type ='3'&order=border_break_point");
	if(retObj3.datas != null){
		for(var i=0;i<retObj3.datas.length;i++){
			var record = retObj3.datas[i];
			var rowNum = i;
			index3++;
			var record_id = record.wa3d_design_no;
			var pos = record.border_break_point;
			var xAxis = record.point_x;
			var yAxis = record.point_y;
			var bsflag = "0";
			
			var tr = document.getElementById("table3").insertRow();
			tr.id = "line_3_" + rowNum;
			var td = tr.insertCell(0);
			td.innerHTML = '<input type="text" name="pos_3_' + rowNum + '" value="' + pos +'" size="4" readonly>';
			var td = tr.insertCell(1);
			td.align="left";
			td.innerHTML = '<input type="text" name="xAxis_3_' + rowNum +'" value="' + xAxis +'" size="13" onkeypress="return key_press_check(this)">';
			var td = tr.insertCell(2);
			td.align="left";
			td.innerHTML = '<input type="text" name="yAxis_3_' + rowNum +'" value="' + yAxis +'" size="13" onkeypress="return key_press_check(this)">';
			var td = tr.insertCell(3);
			td.innerHTML = '<input type="hidden" name="record_id_3_'+rowNum+'" value="' + record_id +'" /><input type="hidden" name="bsflag_3_'+rowNum+'" value="0" /><input type="hidden" name="projectInfoNo_3_'+rowNum+'" value="'+projectInfoNo+'" />';
			
			if(i > exportRows.length){
				var exportRow = {};
				exportRow["1"] = "";
				exportRow["2"] = "";
				exportRow["3"] = "";
				exportRow["4"] = "";
				exportRow["5"] = "";
				exportRow["6"] = "";
				exportRow["7"] = pos;
				exportRow["8"] = xAxis;
				exportRow["9"] = yAxis;
				exportRow["10"] = "";
				exportRow["11"] = "";
				exportRow["12"] = "";
				exportRow["13"] = "";
				exportRows[exportRows.length] = exportRow;
			}else{
				var exportRow = exportRows[i];
				exportRow["7"] = pos;
				exportRow["8"] = xAxis;
				exportRow["9"] = yAxis;
				exportRows[i] = exportRow;
			}
		}
		
		document.getElementById("initRows3").value = retObj3.datas.length;
	}else{
		toAdd3();
	}
	
	// 有资料面积边框
	var retObj4 = jcdpCallService("DBDataSrv","queryTableDatas","tableName="+table_Name+"&option=project_info_no='"+projectInfoNo+"'%20and%20bsflag='0'%20and%20data_type ='4'&order=border_break_point");
	if(retObj4.datas != null){
		for(var i=0;i<retObj4.datas.length;i++){
			var record = retObj4.datas[i];
			var rowNum = i;
			index4++;
			var record_id = record.wa3d_design_no;
			var pos = record.border_break_point;
			var xAxis = record.point_x;
			var yAxis = record.point_y;
			var bsflag = "0";
			
			var tr = document.getElementById("table4").insertRow();
			tr.id = "line_4_" + rowNum;
			var td = tr.insertCell(0);
			td.innerHTML = '<input type="text" name="pos_4_' + rowNum + '" value="' + pos +'" size="4" readonly>';
			var td = tr.insertCell(1);
			td.align="left";
			td.innerHTML = '<input type="text" name="xAxis_4_' + rowNum +'" value="' + xAxis +'" size="13" onkeypress="return key_press_check(this)">';
			var td = tr.insertCell(2);
			td.align="left";
			td.innerHTML = '<input type="text" name="yAxis_4_' + rowNum +'" value="' + yAxis +'" size="13" onkeypress="return key_press_check(this)">';
			var td = tr.insertCell(3);
			td.innerHTML = '<input type="hidden" name="record_id_4_'+rowNum+'" value="' + record_id +'" /><input type="hidden" name="bsflag_4_'+rowNum+'" value="0" /><input type="hidden" name="projectInfoNo_4_'+rowNum+'" value="'+projectInfoNo+'" />';
			
			if(i > exportRows.length){
				var exportRow = {};
				exportRow["1"] = "";
				exportRow["2"] = "";
				exportRow["3"] = "";
				exportRow["4"] = "";
				exportRow["5"] = "";
				exportRow["6"] = "";
				exportRow["7"] = "";
				exportRow["8"] = "";
				exportRow["9"] = "";
				exportRow["10"] = pos;
				exportRow["11"] = xAxis;
				exportRow["12"] = yAxis;
				exportRow["13"] = "";
				exportRows[exportRows.length] = exportRow;
			}else{
				var exportRow = exportRows[i];
				exportRow["10"] = pos;
				exportRow["11"] = xAxis;
				exportRow["12"] = yAxis;
				exportRows[i] = exportRow;
			}
		}
		
		document.getElementById("initRows4").value = retObj4.datas.length;
	}else{
		toAdd4();
	}
	
	
	
	
	//最小物理点信息
	var retObj5 = jcdpCallService("DBDataSrv","queryTableDatas","tableName="+table_Name+"&option=project_info_no='"+projectInfoNo+"'%20and bsflag='0'%20and%20data_type ='5'&order=border_break_point");
	if(retObj5.datas != null){
		for(var i=0;i<retObj5.datas.length;i++){
			var record = retObj5.datas[i];
			var rowNum = i;
			index5 ++;
			var record_id = record.wa3d_design_no;	 
			var xAxis = record.point_x; 
			var bsflag = "0";
			
			var tr = document.getElementById("table5").insertRow();
			tr.id = "line_5_" + rowNum;
			var td = tr.insertCell(0);
		 
			td.innerHTML = '<input type="text" name="xAxis_5_' + rowNum +'" value="' + xAxis +'" size="13" onkeypress="return key_press_check(this)">';
			 var td = tr.insertCell(1);
			td.innerHTML = '<input type="hidden" name="record_id_5_'+rowNum+'" value="' + record_id +'" /><input type="hidden" name="bsflag_5_'+rowNum+'" value="0" /><input type="hidden" name="projectInfoNo_5_'+rowNum+'" value="'+projectInfoNo+'" />';
 
			var exportRow = {};
			exportRow["1"] =  "";
			exportRow["2"] =  "";
			exportRow["3"] =  "";
			exportRow["4"] = "";
			exportRow["5"] = "";
			exportRow["6"] = "";
			exportRow["7"] = "";
			exportRow["8"] = "";
			exportRow["9"] = "";
			exportRow["10"] = "";
			exportRow["11"] = "";
			exportRow["12"] = "";
			exportRow["13"] = xAxis;
			exportRows[exportRows.length] = exportRow;
		}
		document.getElementById("initRows5").value = retObj5.datas.length;
	}else{
		toAdd5();
	}
	
	

}

function toSave(){
	var rows1 = document.getElementById("initRows1").value;
	var rows2 = document.getElementById("initRows2").value;
	var rows3 = document.getElementById("initRows3").value;
	if(index1 > rows1){
		rows1 = index1;
	}
	if(index2 > rows2){
		rows2 = index2;
	}
	if(index3 > rows3){
		rows3 = index3;
	}
	var rowParams = new Array();
	
	for(var i=0; i<rows1; i++){
		var record_id = document.getElementsByName("record_id_1_"+i)[0].value;
		var bsflag = document.getElementsByName("bsflag_1_"+i)[0].value;
		var pos = document.getElementsByName("pos_1_"+i)[0].value;
		var xAxis = document.getElementsByName("xAxis_1_"+i)[0].value;
		var yAxis = document.getElementsByName("yAxis_1_"+i)[0].value;
		var boderType = "";
		var rowParam = {};
		
		if(record_id !="" && record_id != null){
			rowParam['wa3d_design_no'] = record_id;
			rowParam['modifi_date'] = '<%=curDate%>';
			rowParam['updator'] = '<%=userId%>';
		}else{
			rowParam['create_date'] = '<%=curDate%>';
			rowParam['create'] = '<%=userId%>';
		}
		rowParam['frame_shape'] = "1";//边框设计数据
		rowParam['data_type'] = "2";//检波 点
		rowParam['bsflag'] = bsflag;//数据状态
		rowParam['border_break_point'] = pos;//拐点
		if(xAxis.length > 0){
			rowParam['point_x'] = xAxis;//东坐标
		}
		if(yAxis.length > 0){
			rowParam['point_y'] = yAxis;//北坐标
		}
		rowParam['project_info_no'] = projectInfoNo;//项目编号
		
		rowParam['ORG_ID'] =  '<%=orgId%>'; 
		rowParam['ORG_SUBJECTION_ID'] =  '<%=orgSubId%>'; 
		
		rowParams[rowParams.length] = rowParam;
	}
	
	for(var i=0; i<rows2; i++){
		var record_id = document.getElementsByName("record_id_2_"+i)[0].value;
		var bsflag = document.getElementsByName("bsflag_2_"+i)[0].value;
		var pos = document.getElementsByName("pos_2_"+i)[0].value;
		var xAxis = document.getElementsByName("xAxis_2_"+i)[0].value;
		var yAxis = document.getElementsByName("yAxis_2_"+i)[0].value;
		var boderType = "";
		var rowParam = {};
		if(record_id !="" && record_id != null){
			rowParam['wa3d_design_no'] = record_id;
		}
		rowParam['frame_shape'] = "1";//边框设计数据
		rowParam['data_type'] = "1";//炮 点
		rowParam['bsflag'] = bsflag;//数据状态
		rowParam['border_break_point'] = pos;//拐点
		if(xAxis.length > 0){
			rowParam['point_x'] = xAxis;//东坐标
		}
		if(yAxis.length > 0){
			rowParam['point_y'] = yAxis;//北坐标
		}
		rowParam['project_info_no'] = projectInfoNo;//项目编号
		
		rowParam['ORG_ID'] =  '<%=orgId%>'; 
		rowParam['ORG_SUBJECTION_ID'] =  '<%=orgSubId%>'; 
		
		rowParams[rowParams.length] = rowParam;
	}
	for(var i=0; i<rows3; i++){
		var record_id = document.getElementsByName("record_id_3_"+i)[0].value;
		var bsflag = document.getElementsByName("bsflag_3_"+i)[0].value;
		var pos = document.getElementsByName("pos_3_"+i)[0].value;
		var xAxis = document.getElementsByName("xAxis_3_"+i)[0].value;
		var yAxis = document.getElementsByName("yAxis_3_"+i)[0].value;
		var boderType = "";
		var rowParam = {};
		if(record_id !="" && record_id != null){
			rowParam['wa3d_design_no'] = record_id;
		}
		rowParam['frame_shape'] = "1";//边框设计数据
		rowParam['data_type'] = "3";//满覆盖
		rowParam['bsflag'] = bsflag;//数据状态
		rowParam['border_break_point'] = pos;//拐点
		if(xAxis.length > 0){
			rowParam['point_x'] = xAxis;//东坐标
		}
		if(yAxis.length > 0){
			rowParam['point_y'] = yAxis;//北坐标
		}
		rowParam['project_info_no'] = projectInfoNo;//项目编号
		
		rowParam['ORG_ID'] =  '<%=orgId%>'; 
		rowParam['ORG_SUBJECTION_ID'] =  '<%=orgSubId%>'; 
		
		rowParams[rowParams.length] = rowParam;
	}
	
	var rows=JSON.stringify(rowParams);
	saveFunc(table_Name,rows);
}

function key_press_check(obj)
{
	var keycode = event.keyCode;
	if(keycode > 57 || keycode < 45 || keycode==47)
	{
		return false;
	}
	var reg = /^[0-9]{0,13}(\.[0-9]{0,3})?$/;
	var nextvalue = obj.value+String.fromCharCode(keycode);
	if(!(reg.test(nextvalue)))return false;
	return true;
}

function importFile(){
	var filename = document.getElementById("fileName").value;
	if(filename == ""){
		alert("请选择导入文件!");
		return;
	}
	if(checkFile(filename)){
		document.getElementById("fileForm").action = "<%=contextPath%>/pm/gpe/importBorderDesign.srq?c_type="+c_type;
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
function toDownload(){
	window.location.href="<%=contextPath%>/pm/wr/projectDynamic/download.jsp?path=/pm/dBorder/"+fromPage+".xlsx&filename="+fromPage+".xlsx";
}

function exportExcel(){
	var path = cruConfig.contextPath+"/pm/exportDataToExcel.srq";
	var rows=JSON.stringify(exportRows);

	var submitStr = "fromPage=" + fromPage + "&projectName="+projectName+"&dataRows="+rows;
	var retObj = syncRequest("post", path, submitStr);
	window.location=cruConfig.contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname=" + fromPage + ".xls";
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
</script>
<title>工区设计边框</title>
</head>
<body style="overflow-y:auto;overflow-x:auto;height:600px" onload="initData()" >
<form action="" id="fileForm" method="post" enctype="multipart/form-data">
	<table border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%" style="margin-top:0px;" >
	    <tr class="even" style="BACKGROUND-COLOR:#fff;">
	      			<td colspan="12" align="right">
	      			<font color=red>选择文件：</font>
	      	        <input type="file"  id="fileName" name="fileName" size="30"/>
	      	      <!-- <a style="color:red;" href="<%=contextPath%>/pm/wr/projectDynamic/download.jsp?path=/pm/lineDesign/wa3dlinedesign.xls&filename=三维勘探线束设计表.xls">下载模板</a>&nbsp;-->
	      	      <auth:ListButton functionId="" css="dr" event="onclick='importFile()'" title="导入"></auth:ListButton>
	      	      <auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton>
	      	      <auth:ListButton functionId="" css="dc" event="onclick='exportExcel()'" title="导出excel"></auth:ListButton>    
	      	</td>
	    </tr>
	</table>
</form>
<table width="100%">
<tr class="bt_info">
	<td width="20%" align="center">检波点边框</td>
	<td width="20%" align="center">炮点边框</td>
	<td width="25%" align="center">偏前满覆盖边框</td>
	<td width="25%" align="center">有资料面积边框</td>
		<td width="10%" align="center">最小物理点信息</td>
</tr>
<tr>
	<td width="25%" valign="top" align="center">
		<table id="table1" border="1">
			<input type="hidden" id="initRows1" value="0"/>
			<tr class="even">
				<td width="20%">&nbsp;&nbsp;拐点&nbsp;</td>
				<td width="40%">&nbsp;X坐标&nbsp;</td>
				<td width="40%">&nbsp;Y坐标&nbsp;&nbsp;</td>
			</tr>
		</table>
	</td>
	<td width="25%" valign="top" align="center">
		<table id="table2" border="1">
			<input type="hidden" id="initRows2" value="0"/>
			<tr class="even">
				<td width="20%">&nbsp;&nbsp;拐点&nbsp;</td>
				<td width="40%">&nbsp;X坐标&nbsp;</td>
				<td width="40%">&nbsp;Y坐标&nbsp;&nbsp;</td>
			</tr>
		</table>
	</td>
	<td width="25%" valign="top" align="center">
		<table id="table3" border="1">
			<input type="hidden" id="initRows3" value="0"/>
			<tr class="even">
				<td width="20%">&nbsp;&nbsp;拐点&nbsp;</td>
				<td width="40%">&nbsp;X坐标&nbsp;</td>
				<td width="40%">&nbsp;Y坐标&nbsp;&nbsp;</td>
			</tr>
		</table>
	</td>
	<td width="25%" valign="top" align="center">
		<table id="table4" border="1">
			<input type="hidden" id="initRows4" value="0"/>
			<tr class="even">
				<td width="20%">&nbsp;&nbsp;拐点&nbsp;</td>
				<td width="40%">&nbsp;X坐标&nbsp;</td>
				<td width="40%">&nbsp;Y坐标&nbsp;&nbsp;</td>
			</tr>
		</table>
	</td>
	
		
	<td width="10%" valign="top" align="center">
		<table id="table5" border="1">
			<input type="hidden" id="initRows5" value="0"/>
			<tr class="even">
				<td width="10%">&nbsp;观测方位角&nbsp;</td>
				 
			</tr>
		</table>
	</td>
	
	
</tr>
</table>
</body>
</html>
