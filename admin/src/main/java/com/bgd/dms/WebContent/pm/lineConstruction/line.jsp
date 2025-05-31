<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>

<%@ page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="com.cnpc.jcdp.rad.dao.RADJdbcDao"%>
<%@ page import="java.util.Map"%>

<%@taglib prefix="auth" uri="auth"%>
<%
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String userId =  user.getEmpId();
	String projectName = user.getProjectName();
	String projectInfoNo = user.getProjectInfoNo();
	String contextPath = request.getContextPath();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());
	String message = "";
	if(resultMsg != null){
		message = resultMsg.getValue("message");
	}
	RADJdbcDao jdbcDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
	String project_info_no = user.getProjectInfoNo();
	String sql = " select org_id,org_subjection_id from gp_task_project_dynamic where project_info_no ='"+project_info_no+"' and bsflag='0' ";
	Map map_org = jdbcDao.queryRecordBySQL(sql);
	String org_id=map_org.get("org_id").toString();
	String org_subjection_id=map_org.get("org_subjection_id").toString();
	
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

var message = "<%=message%>";
if(message != "" && message != 'null'){
	alert(message);
}

var projectInfoNo = "<%=projectInfoNo%>";
var projectName = "<%=projectName%>";
var bActive = false;
var team_name = "";
var dataRows = 0;
var insertIndex = 1;
var exportRows = new Array();

function toAdd(){
	debugger;
	var rowNum = document.getElementById("lineNum").value;
	var lineId = "row_" + rowNum + "_";
	var lineNum = parseInt(rowNum)+1;
	document.getElementById("lineNum").value = lineNum;
	var tr = document.getElementById("lineTable").insertRow(insertIndex);
	insertIndex++;
	 
	tr.id=lineId;
	// 单元格
	 var td = tr.insertCell();
	td.className = "scrollRowThead";
	td.innerHTML = '<input type="hidden" name="order" class="input_width" value="'+lineNum+'">'
								+'<input type="text" name="serialnum" class="input_width" value="'+lineNum+'">';
		 
	 
	dataRows++;
	tr.insertCell().innerHTML = '<input type="text" name="line_group_id_'+rowNum+'" size="12" >';

	tr.insertCell().innerHTML = '<input type="text" name="epicentre_type'+rowNum+'" size="12" >';
  	tr.insertCell().innerHTML = '<input type="text" name="construction_length_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'construction_length\')">';
	tr.insertCell().innerHTML = '<input type="text" name="data_area_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'data_area\')">';
	tr.insertCell().innerHTML = '<input type="text" name="shot_area_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'shot_area\')">';
	tr.insertCell().innerHTML = '<input type="text" name="full_fold_area_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'full_fold_area\')">';
	tr.insertCell().innerHTML = '<input type="text" name="excitation_points_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'excitation_points\')">';
	tr.insertCell().innerHTML = '<input type="text" name="receiveing_points_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'receiveing_points\')">';
	tr.insertCell().innerHTML = '<input type="text" name="record_num_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computeShotSum('+rowNum+');">';
	tr.insertCell().innerHTML = '<input type="text" name="qualified_num_'+rowNum+'" size="8" onkeypress="return key_press_check(this)"  onchange="computePrcentage(\'qualified_num\',\'qualifier_ratio\','+rowNum+');">';
	tr.insertCell().innerHTML = '<input type="text" name="qualifier_ratio_'+rowNum+'" size="8" readonly>';

	tr.insertCell().innerHTML = '<input type="text" name="unqualified_num_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computePrcentage(\'unqualified_num\',\'unqualified_ratio\','+rowNum+');">';
	tr.insertCell().innerHTML = '<input type="text" name="unqualified_ratio_'+rowNum+'" size="8"  readonly>';
	
	tr.insertCell().innerHTML = '<input type="text" name="null_shot_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computePrcentage(\'null_shot\',\'null_shot_ratio\','+rowNum+');">';
	tr.insertCell().innerHTML = '<input type="text" name="null_shot_ratio_'+rowNum+'" size="8" readonly>';
 	tr.insertCell().innerHTML = '<input type="text" name="test_shot_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'test_shot\')">';
	tr.insertCell().innerHTML = '<input type="text" name="pass_weice_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'pass_weice\')">';
	tr.insertCell().innerHTML = '<input type="text" name="small_refraction_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'small_refraction\')">';
	tr.insertCell().innerHTML = '<input type="text" name="big_refraction_'+rowNum+'" size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'big_refraction\')">';
 

 	tr.insertCell().innerHTML = '<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + lineId + '\')"/>'
	+'<input type="hidden" name="bsflag' + '_' + rowNum + '" value="0"/>'
	+'<input type="hidden" name="record_id' + '_' + rowNum + '" value=""/></td>';
	
	document.getElementById("trlinesum").style.display = "block";
	document.getElementById("trlineGb").style.display = "block";
}

function initData(){
	debugger;
	//获取队号
	var retPrj = jcdpCallService("TaskBookSrv", "getProjectInfo", "");
	if(retPrj.project != null){
		team_name = retPrj.project.team_name;
		team_name = team_name.replace("东方地球物理公司"," ");
	}
	//加载数据
	var retObj = jcdpCallService("DBDataSrv","queryTableDatas","tableName=gp_ops_group_finish&option=bsflag='0'%20and%20project_info_no='<%=projectInfoNo%>'&order=order_num");
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
 				var td = tr.insertCell();
 				td.className = "scrollRowThead";
 				td.innerHTML = '<input type="hidden" name="order" class="input_width" value="'+lineNum+'">'
 											+'<input type="text" name="serialnum" class="input_width" value="'+lineNum+'" readonly>';
 					 
		 
			dataRows++;
		 
			tr.insertCell().innerHTML = '<input type="text" name="line_group_id_'+rowNum+'"  value="'+record.line_group_id+'" size="12" readonly>';

			tr.insertCell().innerHTML = '<input type="text" name="epicentre_type'+rowNum+'"  value="'+record.epicentre_type+'" size="12" readonly>';
		  	tr.insertCell().innerHTML = '<input type="text" name="construction_length_'+rowNum+'"  value="'+record.construction_length+'"  size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'construction_length\')" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="data_area_'+rowNum+'"  value="'+record.data_area+'"  size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'data_area\')" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="shot_area_'+rowNum+'" value="'+record.shot_area+'"  size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'shot_area\')" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="full_fold_area_'+rowNum+'"  value="'+record.full_fold_area+'" size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'full_fold_area\')" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="excitation_points_'+rowNum+'" value="'+record.excitation_points+'" size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'excitation_points\')" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="receiveing_points_'+rowNum+'" value="'+record.receiveing_points+'" size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'receiveing_points\')" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="record_num_'+rowNum+'" value="'+record.record_num+'" size="8" onkeypress="return key_press_check(this)" onchange="computeShotSum('+rowNum+');" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="qualified_num_'+rowNum+'"  value="'+record.qualified_num+'" size="8" onkeypress="return key_press_check(this)"  onchange="computePrcentage(\'qualified_num\',\'qualifier_ratio\','+rowNum+');" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="qualifier_ratio_'+rowNum+'" value="'+record.qualifier_ratio+'"  size="8" readonly>';

			tr.insertCell().innerHTML = '<input type="text" name="unqualified_num_'+rowNum+'"  value="'+record.unqualified_num+'" size="8" onkeypress="return key_press_check(this)" onchange="computePrcentage(\'unqualified_num\',\'unqualified_ratio\','+rowNum+');" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="unqualified_ratio_'+rowNum+'" size="8" value="'+record.unqualified_ratio+'"   readonly>';
			
			tr.insertCell().innerHTML = '<input type="text" name="null_shot_'+rowNum+'" size="8" value="'+record.null_shot+'"  onkeypress="return key_press_check(this)" onchange="computePrcentage(\'null_shot\',\'null_shot_ratio\','+rowNum+');" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="null_shot_ratio_'+rowNum+'" value="'+record.null_shot_ratio+'"  size="8" readonly>';
		 	tr.insertCell().innerHTML = '<input type="text" name="test_shot_'+rowNum+'" value="'+record.test_shot+'" size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'test_shot\')" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="pass_weice_'+rowNum+'" value="'+record.pass_weice+'" size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'pass_weice\')" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="small_refraction_'+rowNum+'" value="'+record.small_refraction+'"  size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'small_refraction\')" readonly>';
			tr.insertCell().innerHTML = '<input type="text" name="big_refraction_'+rowNum+'"  value="'+record.big_refraction+'"  size="8" onkeypress="return key_press_check(this)" onchange="computeSum(\'big_refraction\')" readonly>';
		 

		 	tr.insertCell().innerHTML = '<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + lineId + '\')" />'
			+'<input type="hidden" name="bsflag' + '_' + rowNum + '" value="0"/>'
			+'<input type="hidden" name="record_id' + '_' + rowNum + '" value="'+record.group_id+'"/></td>';
			
		 
			
			var exportRow = {};
			exportRow["1"] = lineNum;
			exportRow["2"] = record.line_group_id;
			exportRow["3"] = record.epicentre_type;
			exportRow["4"] = record.construction_length;
			exportRow["5"] = record.data_area;
			exportRow["6"] = record.shot_area;
			exportRow["7"] = record.full_fold_area;
			exportRow["8"] = record.excitation_points;
			exportRow["9"] = record.receiveing_points;
			exportRow["10"] = record.record_num;
			exportRow["11"] = record.qualified_num;
			exportRow["12"] = record.qualifier_ratio;
			exportRow["13"] = record.unqualified_num;
			exportRow["14"] = record.unqualified_ratio;
			exportRow["15"] = record.null_shot;
			exportRow["16"] = record.null_shot_ratio;
			exportRow["17"] = record.test_shot;
			exportRow["18"] = record.pass_weice;
			exportRow["19"] = record.small_refraction;
			exportRow["20"] = record.big_refraction;
 			exportRows[exportRows.length] = exportRow;
		}
		document.getElementById("lineNum").value = retObj.datas.length;
		document.getElementById("total_data").value = retObj.datas[0].total_data;
		insertIndex = retObj.datas.length + 1;
		
		computeSum('construction_length');
		computeSum('data_area');
		computeSum('shot_area');
		computeSum('full_fold_area');
		computeSum('excitation_points');
		computeSum('receiveing_points');
		computeSum('test_shot');
		computeSum('pass_weice');

		computeSum('small_refraction');
		computeSum('big_refraction');
/* 		computeSum('record_num');
 *//* 		computeSum('qualified_num');
 */		computeShotSum(0);
		document.getElementById("trlinesum").style.display = "block";
		document.getElementById("trlineGb").style.display = "block";

		
		var sumRow = {};
		sumRow["1"] = "合计";
		sumRow["2"] = "";
		sumRow["3"] = "";
		sumRow["4"] = document.getElementsByName("sum_construction_length")[0].value;
		sumRow["5"] = document.getElementsByName("sum_data_area")[0].value;
		sumRow["6"] = document.getElementsByName("sum_shot_area")[0].value;
		sumRow["7"] = document.getElementsByName("sum_full_fold_area")[0].value;
		sumRow["8"] = document.getElementsByName("sum_excitation_points")[0].value;
		sumRow["9"] = document.getElementsByName("sum_receiveing_points")[0].value;
		sumRow["10"] = document.getElementsByName("sum_record_num")[0].value;
		sumRow["11"] = document.getElementsByName("sum_qualified_num")[0].value;
		sumRow["12"] = document.getElementsByName("sum_qualifier_ratio")[0].value;
		sumRow["13"] = document.getElementsByName("sum_unqualified_num")[0].value;
		sumRow["14"] = document.getElementsByName("sum_unqualified_ratio")[0].value;
		sumRow["15"] = document.getElementsByName("sum_null_shot")[0].value;
		sumRow["16"] = document.getElementsByName("sum_null_shot_ratio")[0].value;
		sumRow["17"] = document.getElementsByName("sum_test_shot")[0].value;
		sumRow["18"] = document.getElementsByName("sum_pass_weice")[0].value;
		sumRow["19"] = document.getElementsByName("sum_small_refraction")[0].value;
		sumRow["20"] = document.getElementsByName("sum_big_refraction")[0].value;
 		exportRows[exportRows.length] = sumRow;
 		var gbRow={};
 		gbRow["1"]="总数据量（GB）";
 		gbRow["2"]=document.getElementsByName("total_data")[0].value;
 		exportRows[exportRows.length] = gbRow;

	}
}

function toSave(){
	debugger;
	var rowParams = new Array();
	var orders=document.getElementsByName("order");
	for(var i=0;i<orders.length;i++){
		var rowParam = {};
		var order = orders[i].value;
		var rowNum = order - 1;
		var bsflag = document.getElementsByName("bsflag_"+rowNum)[0].value; 
		var record_id = document.getElementsByName("record_id_"+rowNum)[0].value;
		rowParam['order_num'] = order;
 		rowParam['line_group_id'] = document.getElementsByName("line_group_id_"+rowNum)[0].value;
		rowParam['project_info_no'] = "<%=projectInfoNo%>";
		//
		var epicentre_type = document.getElementsByName("epicentre_type"+rowNum)[0].value;
		if(epicentre_type.length > 0){
			rowParam['epicentre_type'] = epicentre_type;
		}
		//
		var construction_length=document.getElementsByName("construction_length"+"_"+rowNum)[0].value;
		if(construction_length.length > 0){
			rowParam['construction_length'] = construction_length;
		}
		//
		var data_area = document.getElementsByName("data_area"+"_"+rowNum)[0].value;
		if(data_area.length > 0){
			rowParam['data_area'] = data_area;
		}
		//
	/* 	var record_num = document.getElementsByName("record_num"+"_"+rowNum)[0].value;
		if(record_num.length > 0){
			rowParam['record_num'] = record_num;
		} */
		//
		var shot_area = document.getElementsByName("shot_area"+"_"+rowNum)[0].value;
		if(shot_area.length > 0){
			rowParam['shot_area'] = shot_area;
		}else{
			rowParam['shot_area'] = 0;
		}
		//
		var full_fold_area= document.getElementsByName("full_fold_area"+"_"+rowNum)[0].value;
		if(full_fold_area.length > 0){
			rowParam['full_fold_area'] = full_fold_area;
		}
		//
		var excitation_points = document.getElementsByName("excitation_points"+"_"+rowNum)[0].value;
		if(excitation_points.length > 0){
			rowParam['excitation_points'] = excitation_points;
		}else{
			rowParam['excitation_points'] = 0;
		}
		//
		var receiveing_points = document.getElementsByName("receiveing_points"+"_"+rowNum)[0].value;
		if(receiveing_points.length > 0){
			rowParam['receiveing_points'] = receiveing_points;
		}
		//
		var record_num = document.getElementsByName("record_num"+"_"+rowNum)[0].value;
		if(record_num.length > 0){
			rowParam['record_num'] = record_num;
		}else{
			rowParam['record_num'] = 0;
		}
		//
		var qualified_num = document.getElementsByName("qualified_num"+"_"+rowNum)[0].value;
		if(qualified_num.length > 0){
			rowParam['qualified_num'] = qualified_num;
		}
		//
		var qualifier_ratio = document.getElementsByName("qualifier_ratio"+"_"+rowNum)[0].value;
		if(qualifier_ratio.length > 0){
			rowParam['qualifier_ratio'] = qualifier_ratio;
		}else{
			rowParam['qualifier_ratio'] = 0;
		}
		//
		var unqualified_num = document.getElementsByName("unqualified_num"+"_"+rowNum)[0].value;
		if(unqualified_num.length > 0){
			rowParam['unqualified_num'] = unqualified_num;
		}
		//
		var unqualified_ratio = document.getElementsByName("unqualified_ratio"+"_"+rowNum)[0].value;
		if(unqualified_ratio.length > 0){
			rowParam['unqualified_ratio'] = unqualified_ratio;
		}else{
			rowParam['unqualified_ratio'] = 0;
		}
		//
		var null_shot  = document.getElementsByName("null_shot"+"_"+rowNum)[0].value;
		if(null_shot.length > 0){
			rowParam['null_shot'] = null_shot;
		}
		//
		var null_shot_ratio = document.getElementsByName("null_shot_ratio"+"_"+rowNum)[0].value;
		if(null_shot_ratio.length > 0){
			rowParam['null_shot_ratio'] = null_shot_ratio;
		}
		//
		var test_shot = document.getElementsByName("test_shot"+"_"+rowNum)[0].value;
		if(test_shot.length > 0){
			rowParam['test_shot'] = test_shot;
		}
		rowParam['pass_weice'] = document.getElementsByName("pass_weice"+"_"+rowNum)[0].value;
		rowParam['small_refraction'] = document.getElementsByName("small_refraction"+"_"+rowNum)[0].value;
		rowParam['big_refraction'] = document.getElementsByName("big_refraction"+"_"+rowNum)[0].value;
		rowParam['total_data'] = document.getElementsByName("total_data")[0].value;

		if(record_id !=""){
			rowParam['group_id'] = record_id;
			rowParam['updator_id'] = '<%=userId%>';
		}else{
			rowParam['create_id'] = '<%=userId%>';
			rowParam['create_date'] = '<%=curDate%>';
		}
		rowParam['modifi_date'] = '<%=curDate%>';
		rowParam['bsflag'] = bsflag;
		rowParam['org_id'] = '<%=org_id%>';
		rowParam['org_subjection_id'] = '<%=org_subjection_id%>';
		rowParams[rowParams.length] = rowParam;
	}
	var rows=JSON.stringify(rowParams);
	saveFunc("gp_ops_group_finish ",rows);
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
		insertIndex--;
	}
}

function key_press_check(obj)
{
	debugger;

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
	debugger;
	var orders=document.getElementsByName("order");
	var sumValue = 0.00;
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
	debugger;
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
	computePrcentage('qualified_num','qualifier_ratio',rowIndex);
	computePrcentage('unqualified_num','unqualified_ratio',rowIndex);
	computePrcentage('null_shot','null_shot_ratio',rowIndex);
 /* 	computePrcentage('first_num','first_ratio',rowIndex);
	computePrcentage('seconde_num','seconde_ratio',rowIndex);
	computePrcentage('defective_product_num','defective_product_ratio',rowIndex);
	computePrcentage('no_shoot_num','no_shoot_ratio',rowIndex); */
}

function computePrcentage(colName,colPrcentage,rowIndex){
	debugger;
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
	debugger;
	var path = cruConfig.contextPath+"/pm/exportDataToExcel.srq";
	var rows=JSON.stringify(exportRows);
	var fromPage = "lineConsructionTemp";
	var submitStr = "fromPage=" + fromPage + "&projectName="+projectName+"&dataRows="+rows;
	var retObj = syncRequest("post", path, submitStr);
	window.location=cruConfig.contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname=" + fromPage + ".xls";
}

function downloadTemplate(){
	window.location.href="<%=contextPath%>/pm/dailyReport/singleProject/download.jsp?path=/pm/lineConstruction/lineConsructionTemp.xls&filename=lineConsructionTemp.xls";
}

function importData(){
	debugger;
	var filename = document.getElementById("fileName").value;
	if(filename == ""){
		alert("请选择导入文件!");
		return;
	}
	if(checkFile(filename)){
		document.getElementById("fileForm").action = "<%=contextPath%>/pm/gpe/importLineTemp.srq";
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
<body style="background:#cdddef;overflow-y:auto;overflow-x:auto;height:400px" onload="initData()">
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
			   <td width="90%" align="center"><font size="3"><%=projectName%>项目测线/线束完成情况统计表</font></td>
			   <td width="10%">&nbsp;</td>
			   <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
		</tr>
</table>
<div id="scrollDiv" class="scrollDiv" >
<table id="lineTable" width="100%" border="0" cellspacing="0"  align="center" cellpadding="0" class="scrolltable">
	<thead>
 
    <tr class="scrollColThead td_head">
    <td>序号</td>
      <td class="scrollRowThead scrollCR">测线号/线束号</td>
       <td class="scrollRowThead scrollCR">震源类型</td>
      <td>施工长度(km)/面积(km2)</td>
      <td>资料长度(km)/面积(km2)</td>
      <td>炮点面积(km)/面积(km2)</td>
      <td>满覆盖长度(km)/面积(km2)</td>
      <td>激发点数(炮)</td>
      <td>接收点数(点)</td>
      <td>记录张数(张)</td>
      <td>合格张数(张)</td>
      <td>合格率(%)</td>
      <td>不合格张数(张)</td>
      <td>不合格率（%）</td>
      <td>空炮数(炮)</td>
      <td>空炮率(%)</td>
      <td>试验炮数(炮)</td>
      <td>合格微测井数(点)</td>
      <td>合格小折射点数(点)</td>
      <td>合格大折射点数(点)</td>
      
       <td nowrap>删除</td>
    </tr>
    </thead>
    <tr class="even" style="display:none" id="trlinesum">
    	<td class="scrollRowThead scrollCR">合计</td>
    	<td class="scrollRowThead scrollCR"><input type="text" size="12" value="        --" readonly/></td>
    	<td><input type="text" name="" size="12"  value="        --" readonly/></td>
    	<td><input type="text" name="sum_construction_length" size="8" readonly/></td>
    	<td><input type="text" name="sum_data_area" size="8" readonly/></td>
    	<td><input type="text" name="sum_shot_area" size="8" readonly/></td>
    	<td><input type="text" name="sum_full_fold_area" size="8" readonly/></td>
    	<td><input type="text" name="sum_excitation_points" size="8" readonly/></td>
    	<td><input type="text" name="sum_receiveing_points" size="8" readonly/></td>
    	<td><input type="text" name="sum_record_num" size="8" readonly/></td>
    	<td><input type="text" name="sum_qualified_num" size="8" readonly/></td>
    	<td><input type="text" name="sum_qualifier_ratio" size="8" readonly/></td>
    	<td><input type="text" name="sum_unqualified_num" size="8" readonly/></td>
    	<td><input type="text" name="sum_unqualified_ratio" size="8" readonly/></td>
    	<td><input type="text" name="sum_null_shot" size="8" readonly/></td>
    	<td><input type="text" name="sum_null_shot_ratio" size="8" readonly/></td>
    	<td><input type="text" name="sum_test_shot" size="8" readonly/></td>
    	<td><input type="text" name="sum_pass_weice" size="8" readonly/></td>
    	<td><input type="text" name="sum_small_refraction" size="8" readonly/></td>
    	<td><input type="text" name="sum_big_refraction" size="8" readonly/></td>
     
    </tr>
    <tr class="even"  style="display:none"  id="trlineGb">
    <td class="scrollRowThead scrollCR" >总数据量（GB）</td>	
       	 <td  class="scrollRowThead scrollCR" ><input type='text' name ="total_data"size='12'/></td>

    </tr>
</table>
</div>
<div align="center">
    <span class="tj_btn"><a href="#" onclick="toSave()"></a></span>
</div>

</body>
</html>
