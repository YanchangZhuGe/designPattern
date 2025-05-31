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
var projectName = "<%=projectName%>";
var bActive = false;
var team_name = "";
var dataRows = 0;
var loadDataRows = 0;
var exportRows = new Array();


function activeInput(){
	if(bActive == true){
		return;
	}
	window.location.href="<%=contextPath%>/pm/lineConstruction/2dEdit.jsp";
    bActive = true;
}

function initData(){
	//获取队号
	var retPrj = jcdpCallService("TaskBookSrv", "getProjectInfo", "");
	if(retPrj.project != null){
		team_name = retPrj.project.team_name;
		team_name = team_name.replace("东方地球物理公司"," ");
	}
	//加载数据
	var retObj = jcdpCallService("DBDataSrv","queryTableDatas","tableName=gp_ops_2dwa_method_data&option=bsflag='0'%20and%20project_info_no='<%=projectInfoNo%>'&order=order_num");
	if(retObj.datas != null){
		var allRows = retObj.datas.length;
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
				td.rowSpan = allRows;
				td.innerHTML = team_name;
			}
			dataRows++;
			var td = tr.insertCell();
			td.className = "scrollRowThead";
			td.innerHTML = record.line_id+'<input type="hidden" name="line_id_'+rowNum+'" value="'+record.line_id+'" size="12" readonly>';
			tr.insertCell().innerHTML = record.layout+'<input type="hidden" name="layout_'+rowNum+'" value="'+record.layout+'" size="20" readonly>';
			tr.insertCell().innerHTML = record.fold+'<input type="hidden" name="fold_'+rowNum+'" value="'+record.fold+'" size="6" readonly>';
			tr.insertCell().innerHTML = record.track_interval+'<input type="hidden" name="track_interval_'+rowNum+'" value="'+record.track_interval+'">';
			tr.insertCell().innerHTML = record.shot_interval+'<input type="hidden" name="shot_interval_'+rowNum+'" value="'+record.shot_interval+'">';
			tr.insertCell().innerHTML = record.small_dist+'<input type="hidden" name="small_dist_'+rowNum+'" value="'+record.small_dist+'">';
			tr.insertCell().innerHTML = record.receiving_track_num+'<input type="hidden" name="receiving_track_num_'+rowNum+'" value="'+record.receiving_track_num+'">';
			tr.insertCell().innerHTML = record.element_interval+'<input type="hidden" name="element_interval_'+rowNum+'" value="'+record.element_interval+'">';
			tr.insertCell().innerHTML = record.pat_distance+'<input type="hidden" name="pat_distance_'+rowNum+'" value="'+record.pat_distance+'">';
			tr.insertCell().innerHTML = record.receive_comp_graph+'<input type="hidden" name="receive_comp_graph_'+rowNum+'" value="'+record.receive_comp_graph+'">';
			tr.insertCell().innerHTML = record.well_depth+'<input type="hidden" name="well_depth_'+rowNum+'" value="'+record.well_depth+'">';
			tr.insertCell().innerHTML = record.well_num+'<input type="hidden" name="well_num_'+rowNum+'" value="'+record.well_num+'">';
			tr.insertCell().innerHTML = record.explosive_qty+'<input type="hidden" name="explosive_qty_'+rowNum+'" value="'+record.explosive_qty+'">';
			tr.insertCell().innerHTML = record.sp_comp_graph+'<input type="hidden" name="sp_comp_graph_'+rowNum+'" value="'+record.sp_comp_graph+'">';
			tr.insertCell().innerHTML = record.source_num+'<input type="hidden" name="source_num_'+rowNum+'" value="'+record.source_num+'">';
			tr.insertCell().innerHTML = record.scan_frequency+'<input type="hidden" name="scan_frequency_'+rowNum+'" value="'+record.scan_frequency+'">';
			tr.insertCell().innerHTML = record.scanning_len+'<input type="hidden" name="scanning_len_'+rowNum+'" value="'+record.scanning_len+'">';
			tr.insertCell().innerHTML = record.source_comp_graph+'<input type="hidden" name="source_comp_graph_'+rowNum+'" value="'+record.source_comp_graph+'">';
			tr.insertCell().innerHTML = record.instrument_model+'<input type="hidden" name="instrument_model_'+rowNum+'" value="'+record.instrument_model+'">';
			tr.insertCell().innerHTML = record.preamplifier_gain+'<input type="hidden" name="preamplifier_gain_'+rowNum+'" value="'+record.preamplifier_gain+'">';
			tr.insertCell().innerHTML = record.sample_ratio+'<input type="hidden" name="sample_ratio_'+rowNum+'" value="'+record.sample_ratio+'">';
			tr.insertCell().innerHTML = record.record_len+'<input type="hidden" name="record_len_'+rowNum+'" value="'+record.record_len+'">';
			var record_notes = record.notes!="\"null\""?record.notes:"";
			tr.insertCell().innerHTML = record_notes+'<input type="hidden" name="notes_'+rowNum+'" value="'+record_notes+'">';
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
			exportRow["20"] = record.instrument_model;
			exportRow["21"] = record.preamplifier_gain;
			exportRow["22"] = record.sample_ratio;
			exportRow["23"] = record.record_len;
			exportRow["24"] = record.notes;
			exportRows[exportRows.length] = exportRow;
		}
		document.getElementById("lineNum").value = retObj.datas.length;
		loadDataRows = retObj.datas.length;
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

</script>
</head>
<body style="background:#fff;overflow-y:auto;overflow-x:auto;height:400px" onload="initData()">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			    <td width="90%" align="center"><font size="3"><%=projectName%>项目施工方法一览表</font></td>
			    <td width="10%">
			    <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  		<tr>
			    		<td>&nbsp;<input type="hidden" id="lineNum" value="0"/></td>
			    		<auth:ListButton functionId="" css="xg" event="onclick='activeInput()'" title="JCDP_btn_edit"></auth:ListButton>
			    		<auth:ListButton functionId="" css="dc" event="onclick='exportExcel()'" title="导出excel"></auth:ListButton>
			  		</tr>
				</table>
				</td>
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
      <td colspan="8">激发因素</td>
      <td colspan="4"></td>
      <td></td>
    </tr>
    <tr class="scrollColThead td_head">
      <td class="scrollCR scrollRowThead" colspan="2"></td>
      <td colspan="6">观测系统</td>
      <td colspan="3"></td>
      <td colspan="4">井炮</td>
      <td colspan="4">震源</td>
      <td colspan="4">仪器因素</td>
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
      <td>仪器型号</td>
      <td>前放增益</br>dB</td>
      <td>采样率 ms</td>
      <td>记录长度 s</td>
      <td>备注</td>
    </tr>
    </thead>
</table>
</div>
</body>
</html>
