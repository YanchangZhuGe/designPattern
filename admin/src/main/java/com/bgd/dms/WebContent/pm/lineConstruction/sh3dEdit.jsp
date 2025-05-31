<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getEmpId();
	String projectName = user.getProjectName();
	String projectInfoNo = user.getProjectInfoNo();
	String contextPath = request.getContextPath();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String message = "";
	if (resultMsg != null) {
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
body,table,td {
	font-size: 12px;
	font-weight: normal;
}
/* 重点：固定行头样式*/
.scrollRowThead {
	BACKGROUND-COLOR: #AEC2E6;
	position: relative;
	left: expression(this.parentElement.parentElement.parentElement.parentElement.scrollLeft
		);
	z-index: 0;
}
/* 重点：固定表头样式*/
.scrollColThead {
	position: relative;
	top: expression(this.parentElement.parentElement.parentElement.scrollTop);
	z-index: 2;
}
/* 行列交叉的地方*/
.scrollCR {
	z-index: 3;
}
/*div 外框*/
.scrollDiv {
	height: 80%;
	clear: both;
	border: 1px solid #94B6E6;
	OVERFLOW: scroll;
	width: 100%;
}
/* 行头居中*/
.scrollColThead td,.scrollColThead th {
	text-align: center;
}
/* 行头列头背景*/
.scrollRowThead,.scrollColThead td,.scrollColThead th {
	background-color: #94B6E6;
	background-repeat: repeat;
}
/* 表格的线*/
.scrolltable {
	border-bottom: 1px solid #CCCCCC;
	border-right: 1px solid #8EC2E6;
}
/* 单元格的线等*/
.scrolltable td,.scrollTable th {
	border-left: 1px solid #CCCCCC;
	border-top: 1px solid #CCCCCC;
	padding: 1px;
}

.scrollTable thead th {
	background-color: #94B6E6;
	position: relative;
}

.td_head {
	FONT-SIZE: 12px;
	COLOR: #296184;
	font-family: "微软雅黑", Arial, Helvetica, sans-serif;
	font-weight: normal;
	text-align: center;
	vertical-align: middle;
	height: 20px;
	line-height: 20px;
	background: #CCCCCC;
}
</style>
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath%>';
var projectInfoNo = "<%=projectInfoNo%>";
var projectName = "<%=projectName%>";
var message = "<%=message%>";
if(message != "" && message != 'null'){
	alert(message);
}


var rowNum = 1;
var team_name;
var exportRows = new Array();

function toAdd(){
	var tr = document.getElementById("lineTable").insertRow();
	tr.id="row_"+rowNum;
	if(rowNum % 2 == 0){
    	tr.className = "even";
	}else{
		tr.className = "odd";
	}
	tr.insertCell().innerHTML = '<input type="text" id="team_num_'+rowNum+'" size="16" value="'+team_name+'"/>';//队号
	tr.insertCell().innerHTML = '<input type="text" id="order_num_'+rowNum+'" size="2" value="'+rowNum+'"/>';//序号
	tr.insertCell().innerHTML = '<input type="text" id="line_group_id_'+rowNum+'" size="5" value=""/>';//线束号
	tr.insertCell().innerHTML = '<input type="text" id="fold_'+rowNum+'" size="5" value=""/>';//覆盖次数
	tr.insertCell().innerHTML = '<input type="text" id="binning_size_'+rowNum+'" size="5" value=""/>';//面元尺寸
	tr.insertCell().innerHTML = '<input type="text" id="track_interval_'+rowNum+'" size="5" value=""/>';//道距
	tr.insertCell().innerHTML = '<input type="text" id="shot_interval_'+rowNum+'" size="5" value=""/>';//炮点距
	tr.insertCell().innerHTML = '<input type="text" id="cable_distance_'+rowNum+'" size="5" value=""/>';//缆间距
	tr.insertCell().innerHTML = '<input type="text" id="source_distance_'+rowNum+'" size="5" value=""/>';//震源间距
	tr.insertCell().innerHTML = '<input type="text" id="receiving_track_num_'+rowNum+'" size="5" value=""/>';//接收道数
	tr.insertCell().innerHTML = '<input type="text" id="cable_depth_'+rowNum+'" size="5" value=""/>';//电缆深度 
	tr.insertCell().innerHTML = '<input type="text" id="array_num_'+rowNum+'" size="5" value=""/>';//阵列数
	tr.insertCell().innerHTML = '<input type="text" id="source_num_'+rowNum+'" size="5" value=""/>';//震源数
	tr.insertCell().innerHTML = '<input type="text" id="source_capacity_'+rowNum+'" size="5" value=""/>';//震源容量
	tr.insertCell().innerHTML = '<input type="text" id="instrument_model_'+rowNum+'" size="5" value=""/>';//仪器型号
	tr.insertCell().innerHTML = '<input type="text" id="sample_ratio_'+rowNum+'" size="5" value=""/>';//采样率(ms)
	tr.insertCell().innerHTML = '<input type="text" id="record_len_'+rowNum+'" size="5" value=""/>';//记录长度(s)
	tr.insertCell().innerHTML = '<input type="text" id="notes_'+rowNum+'" size="10" value=""/>';//备注
	tr.insertCell().innerHTML = '<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + rowNum + '\')"/>'//删除
	+'<input type="hidden" id="bsflag_'+rowNum+'" value="0"/>'
	+'<input type="hidden" id="record_id_'+rowNum+'" value=""/>';
	rowNum++;
}

function deleteLine(no){
	var tr = document.getElementById("row_"+no);
	tr.style.display = 'none';
	document.getElementById("bsflag_"+no).value = '1';
}

function initData(){
	var retPrj = jcdpCallService("TaskBookSrv", "getProjectInfo", "");
	if(retPrj.project != null){
		team_name = retPrj.project.team_name;
	}
	var retObj = jcdpCallService("DBDataSrv","queryTableDatas","tableName=gp_ops_3dwa_method_data&option=bsflag='0'%20and%20project_info_no='<%=projectInfoNo%>'&order=order_num");
	if(retObj.datas != null){
		for(var i=1;i<=retObj.datas.length;i++){
			var record = retObj.datas[i-1];
			if(parseInt(record.order_num)>=parseInt(rowNum)){
				rowNum=parseInt(record.order_num)+1;
			}
			var tr = document.getElementById("lineTable").insertRow();
			tr.id="row_"+record.order_num;
			if(i % 2 == 0){
    			tr.className = "even";
			}else{
				tr.className = "odd";
			}
			tr.insertCell().innerHTML = '<input type="text" id="team_num_'+record.order_num+'" size="16" value="'+team_name+'"/>';//队号
			tr.insertCell().innerHTML = '<input type="text" id="order_num_'+record.order_num+'" size="2" value="'+record.order_num+'"/>';//序号
			tr.insertCell().innerHTML = '<input type="text" id="line_group_id_'+record.order_num+'" size="5" value="'+record.line_group_id+'"/>';//线束号
			tr.insertCell().innerHTML = '<input type="text" id="fold_'+record.order_num+'" size="5" value="'+record.fold+'"/>';//覆盖次数
			tr.insertCell().innerHTML = '<input type="text" id="binning_size_'+record.order_num+'" size="5" value="'+record.binning_size+'"/>';//面元尺寸
			tr.insertCell().innerHTML = '<input type="text" id="track_interval_'+record.order_num+'" size="5" value="'+record.track_interval+'"/>';//道距
			tr.insertCell().innerHTML = '<input type="text" id="shot_interval_'+record.order_num+'" size="5" value="'+record.shot_interval+'"/>';//炮点距 
			tr.insertCell().innerHTML = '<input type="text" id="cable_distance_'+record.order_num+'" size="5" value="'+record.cable_distance+'"/>';//缆间距
			tr.insertCell().innerHTML = '<input type="text" id="source_distance_'+record.order_num+'" size="5" value="'+record.source_distance+'"/>';//震源间距
			tr.insertCell().innerHTML = '<input type="text" id="receiving_track_num_'+record.order_num+'" size="5" value="'+record.receiving_track_num+'"/>';//接收道数
			tr.insertCell().innerHTML = '<input type="text" id="cable_depth_'+record.order_num+'" size="5" value="'+record.cable_depth+'"/>';//电缆深度 
			tr.insertCell().innerHTML = '<input type="text" id="array_num_'+record.order_num+'" size="5" value="'+record.array_num+'"/>';//阵列数
			tr.insertCell().innerHTML = '<input type="text" id="source_num_'+record.order_num+'" size="5" value="'+record.source_num+'"/>';//震源数
			tr.insertCell().innerHTML = '<input type="text" id="source_capacity_'+record.order_num+'" size="5" value="'+record.source_capacity+'"/>';//震源容量
			tr.insertCell().innerHTML = '<input type="text" id="instrument_model_'+record.order_num+'" size="5" value="'+record.instrument_model+'"/>';//仪器型号
			tr.insertCell().innerHTML = '<input type="text" id="sample_ratio_'+record.order_num+'" size="5" value="'+record.sample_ratio+'"/>';//采样率(ms)
			tr.insertCell().innerHTML = '<input type="text" id="record_len_'+record.order_num+'" size="5" value="'+record.record_len+'"/>';//记录长度(s)
			tr.insertCell().innerHTML = '<input type="text" id="notes_'+record.order_num+'" size="10" value="'+record.notes+'"/>';//备注
			tr.insertCell().innerHTML = '<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + record.order_num + '\')"/>'
			+'<input type="hidden" id="bsflag_'+record.order_num+'" value="'+record.bsflag+'"/>'
			+'<input type="hidden" id="record_id_'+record.order_num+'" value="'+record.method_no+'"/>';
			
			var exportRow = {};
			exportRow["1"] = team_name;
			exportRow["2"] = record.order_num;
			exportRow["3"] = record.line_group_id;
			exportRow["4"] = record.fold;
			exportRow["5"] = record.binning_size;
			exportRow["6"] = record.track_interval;
			exportRow["7"] = record.shot_interval;
			exportRow["8"] = record.cable_distance;
			exportRow["9"] = record.source_distance;
			exportRow["10"] = record.receiving_track_num;
			exportRow["11"] = record.cable_depth;
			exportRow["12"] = record.array_num;
			exportRow["13"] = record.source_num;
			exportRow["14"] = record.source_capacity;
			exportRow["15"] = record.instrument_model;
			exportRow["16"] = record.sample_ratio;
			exportRow["17"] = record.record_len;
			exportRow["18"] = record.notes;
			exportRows[exportRows.length] = exportRow;
		}
	}
}

function toSave(){
	var rowParams = new Array();
	for(var i=1;i<rowNum;i++){
		var rowParam = {};
		var team_num = document.getElementById("team_num_"+i);//队号
		if(team_num!=null){
			rowParam['team_name']=team_num.value;
		}
		
		var order_num = document.getElementById("order_num_"+i);//序号
		if(order_num!=null){
			rowParam['order_num']=order_num.value;
		}
		
		var line_group_id = document.getElementById("line_group_id_"+i);//线束号
		if(line_group_id!=null){
			rowParam['line_group_id']=line_group_id.value;
		}
		
		var fold = document.getElementById("fold_"+i);//覆盖次数
		if(fold!=null){
			rowParam['fold']=fold.value;
		}
		
		var binning_size = document.getElementById("binning_size_"+i);//面元尺寸
		if(binning_size!=null){
			rowParam['binning_size']=binning_size.value;
		}
		
		var track_interval = document.getElementById("track_interval_"+i);//道距
		if(track_interval!=null){
			rowParam['track_interval']=track_interval.value;
		}
		
		var shot_interval = document.getElementById("shot_interval_"+i);//炮点距
		if(shot_interval!=null){
			rowParam['shot_interval']=shot_interval.value;
		}
		
		var cable_distance = document.getElementById("cable_distance_"+i);//缆间距
		if(cable_distance!=null){
			rowParam['cable_distance']=cable_distance.value;
		}
		
		var source_distance = document.getElementById("source_distance_"+i);//震源间距
		if(source_distance!=null){
			rowParam['source_distance']=source_distance.value;
		}
		
		var receiving_track_num = document.getElementById("receiving_track_num_"+i);//接收道数
		if(receiving_track_num!=null){
			rowParam['receiving_track_num']=receiving_track_num.value;
		}
		
		var cable_depth = document.getElementById("cable_depth_"+i);//电缆深度
		if(cable_depth!=null){
			rowParam['cable_depth']=cable_depth.value;
		}
		
		var array_num = document.getElementById("array_num_"+i);//阵列数
		if(array_num!=null){
			rowParam['array_num']=array_num.value;
		}
		
		var source_num = document.getElementById("source_num_"+i);//震源数
		if(source_num!=null){
			rowParam['source_num']=source_num.value;
		}
		
		var source_capacity = document.getElementById("source_capacity_"+i);//震源容量
		if(source_capacity!=null){
			rowParam['source_capacity']=source_capacity.value;
		}
		
		var instrument_model = document.getElementById("instrument_model_"+i);//仪器型号
		if(instrument_model!=null){
			rowParam['instrument_model']=instrument_model.value;
		}
		
		var sample_ratio = document.getElementById("sample_ratio_"+i);//采样率(ms)
		if(sample_ratio!=null){
			rowParam['sample_ratio']=sample_ratio.value;
		}
		
		var record_len = document.getElementById("record_len_"+i);//记录长度(s)
		if(record_len!=null){
			rowParam['record_len']=record_len.value;
		}
		
		var notes = document.getElementById("notes_"+i);//备注
		if(notes!=null){
			rowParam['notes']=notes.value;
		}
		
		
		var bsflag = document.getElementById("bsflag_"+i);
		if(bsflag!=null){
			rowParam['bsflag']=bsflag.value;
		}
		var record_id = document.getElementById("record_id_"+i);
		if(record_id != null){
			rowParam['method_no'] = record_id.value;
			rowParam['updator_id'] = '<%=userId%>';
			rowParam['modifi_date'] = '<%=curDate%>';
		}else{
			rowParam['create_id'] = '<%=userId%>';
			rowParam['create_date'] = '<%=curDate%>';
		}
		
		rowParam['project_info_no'] = "<%=projectInfoNo%>";
		rowParams[rowParams.length] = rowParam;
		
	}
	var rows=JSON.stringify(rowParams);
	saveFunc("gp_ops_3dwa_method_data",rows);
	refreshData();
}
function refreshData(){
	deleteTable("lineTable");
	initData();
}
function deleteTable(tableID){
	var tb = document.getElementById(tableID);
    var rowNum=tb.rows.length;
    for (i=2;i<rowNum;i++){
    	tb.deleteRow(i);
	    rowNum=rowNum-1;
	    i=i-1;
	}
}


function exportExcel(){
	var path = cruConfig.contextPath+"/pm/exportDataToExcel.srq";
	var rows=JSON.stringify(exportRows);
	var fromPage = "sh3dlineConsruction";
	var submitStr = "fromPage=" + fromPage + "&projectName="+projectName+"&dataRows="+rows;
	var retObj = syncRequest("post", path, submitStr);
	window.location=cruConfig.contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname=" + fromPage + ".xls";
}


function downloadTemplate(){
	window.location.href="<%=contextPath%>/pm/dailyReport/singleProject/download.jsp?path=/pm/lineConstruction/sh3dlineConsruction.xls&filename=sh3dlineConsruction.xls";
}

function importData(){
	var filename = document.getElementById("fileName").value;
	if(filename == ""){
		alert("请选择导入文件!");
		return;
	}
	if(checkFile(filename)){
		document.getElementById("fileForm").action = "<%=contextPath%>/pm/gpe/importLineConstruction.srq?workMethod=3&isSea=y&teamName="+team_name;
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
<body style="background: #fff; overflow-y: auto; overflow-x: auto;" onload="initData()" width="800px">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan="2">
				<form action="" id="fileForm" method="post" enctype="multipart/form-data">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="60%">&nbsp;</td>
							<td><font color=red>选择文件：</font><input type="file" id="fileName" name="fileName" /></td>
							<auth:ListButton functionId="" css="dr" event="onclick='importData()'" title="导入数据" />
							<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="增加" />
							<auth:ListButton functionId="" css="xz" event="onclick='downloadTemplate()'"title="下载模板" /> 
							<auth:ListButton functionId="" css="dc" event="onclick='exportExcel()'" title="导出excel" />
						</tr>
					</table>
				</form>
			</td>
		</tr>
		<tr>
			<td width="100%" align="center"><font size="3"><%=projectName%>施工方法一览表</font></td>
		</tr>
	</table>
	<div id="scrollDiv" class="scrollDiv">
		<table id="lineTable" width="100%" border="0" cellspacing="0" align="center" cellpadding="0" class="scrolltable">
			<thead>
				<tr class="scrollColThead td_head">
					<td></td>
					<td></td>
					<td></td>
					<td colspan="6">观测系统</td>
					<td colspan="2">接收因素</td>
					<td colspan="3">激发因素(震源)</td>
					<td colspan="3">仪器因素</td>
					<td></td>
					<td></td>
				</tr>
				<tr class="scrollColThead td_head">
					<td>队号</td>
					<td>序号</td>
      				<td>线束号</td>
					<td>覆盖次数</td>
					<td>面元尺寸</td>
					<td>道距</td>
					<td>炮点距</td>
					<td>缆间距</td>
					<td>震源间距</td>
					<td>接收道数</td>
					<td>电缆深度</td>
					<td>阵列数</td>
					<td>震源数</td>
					<td>震源容量</td>
					<td>仪器型号</td>
					<td>采样率(ms)</td>
					<td>记录长度(s)</td>
					<td>备注</td>
					<td>删除</td>
				</tr>
			</thead>
		</table>
	</div>
	<div align="center">
		<span class="tj_btn"><a href="#" onclick="toSave()"></a></span>
	</div>
</body>
</html>
