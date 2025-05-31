<%@page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String userId = user.getEmpId();
	String projectName = user.getProjectName();
	String projectInfoNo = user.getProjectInfoNo();
	String contextPath = request.getContextPath();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());
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
	height: 340;
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
	tr.insertCell().innerHTML = '<input type="text" id="team_num_'+rowNum+'" size="16" value="'+team_name+'"/>';
	tr.insertCell().innerHTML = '<input type="text" id="order_num_'+rowNum+'" size="2" value="'+rowNum+'"/>';
	tr.insertCell().innerHTML = '<input type="text" id="line_id_'+rowNum+'" size="10" />';
	tr.insertCell().innerHTML = '<input type="text" id="measure_fullfold_kilo_num_'+rowNum+'" size="10" />';
	tr.insertCell().innerHTML = '<input type="text" id="full_fold_len_'+rowNum+'" size="10" />';
	tr.insertCell().innerHTML = '<input type="text" id="repair_rate_'+rowNum+'" size="10" /><span>%</span>';
	tr.insertCell().innerHTML = '<input type="text" id="construct_begin_end_date_'+rowNum+'" size="10" />';
	tr.insertCell().innerHTML = '<input type="text" id="notes_'+rowNum+'" size="10" />';
	tr.insertCell().innerHTML = '<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + rowNum + '\')"/>'
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
	//获取队号
	var retPrj = jcdpCallService("TaskBookSrv", "getProjectInfo", "");
	if(retPrj.project != null){
		team_name = retPrj.project.team_name;
	}
	var retObj = jcdpCallService("DBDataSrv","queryTableDatas","tableName=gp_ops_wa2d_line_finish&option=bsflag='0'%20and%20project_info_no='<%=projectInfoNo%>'&order=order_num");
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
			tr.insertCell().innerHTML = '<input type="text" id="line_id_'+record.order_num+'" size="10" value="'+record.line_id+'"/>';//测线号
			tr.insertCell().innerHTML = '<input type="text" id="measure_fullfold_kilo_num_'+record.order_num+'" size="10"  value="'+record.measure_fullfold_kilo_num+'"/>';//设计测线满覆盖
			tr.insertCell().innerHTML = '<input type="text" id="full_fold_len_'+record.order_num+'" size="10"  value="'+record.full_fold_len+'"/>';//实际完成满覆盖
			tr.insertCell().innerHTML = '<input type="text" id="repair_rate_'+record.order_num+'" size="10" value="'+record.repair_rate+'"/><span>%</span>';//补线率
			tr.insertCell().innerHTML = '<input type="text" id="construct_begin_end_date_'+record.order_num+'" size="10" value="'+record.construct_begin_end_date+'"/>';//施工起止日期
			tr.insertCell().innerHTML = '<input type="text" id="notes_'+record.order_num+'" size="10" value="'+record.notes+'"/>';//备注
			tr.insertCell().innerHTML = '<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + record.order_num + '\')"/>'
			+'<input type="hidden" id="bsflag_'+record.order_num+'" value="'+record.bsflag+'"/>'
			+'<input type="hidden" id="record_id_'+record.order_num+'" value="'+record.wa2d_line_id+'"/>';
			
			var exportRow = {};
			exportRow["1"] = team_name;
			exportRow["2"] = record.order_num;
			exportRow["3"] = record.line_id;
			exportRow["4"] = record.measure_fullfold_kilo_num;
			exportRow["5"] = record.full_fold_len;
			exportRow["6"] = record.repair_rate;
			exportRow["7"] = record.construct_begin_end_date;
			exportRow["8"] = record.notes;
			exportRows[exportRows.length] = exportRow;
		}
	}
}

function toSave(){
	var rowParams = new Array();
	for(var i=1;i<rowNum;i++){
		var rowParam = {};
		
		var team_num = document.getElementById("team_num_"+i);
		if(team_num!=null){
			rowParam['team_name']=team_num.value;
		}
		
		var order_num = document.getElementById("order_num_"+i);
		if(order_num!=null){
			rowParam['order_num']=order_num.value;
		}
		
		var line_id = document.getElementById("line_id_"+i);
		if(line_id!=null){
			rowParam['line_id']=line_id.value;
		}
		
		var measure_fullfold_kilo_num = document.getElementById("measure_fullfold_kilo_num_"+i);
		if(measure_fullfold_kilo_num!=null){
			rowParam['measure_fullfold_kilo_num']=measure_fullfold_kilo_num.value;
		}
		
		var repair_rate = document.getElementById("repair_rate_"+i);
		if(repair_rate!=null){
			rowParam['repair_rate']=repair_rate.value;
		}
		
		var full_fold_len = document.getElementById("full_fold_len_"+i);
		if(full_fold_len!=null){
			rowParam['full_fold_len']=full_fold_len.value;
		}
		
		var construct_begin_end_date = document.getElementById("construct_begin_end_date_"+i);
		if(construct_begin_end_date!=null){
			rowParam['construct_begin_end_date']=construct_begin_end_date.value;
		}
		
		var notes = document.getElementById("notes_"+i);
		if(notes!=null){
			rowParam['notes']=notes.value;
		}
		
		var bsflag = document.getElementById("bsflag_"+i);
		if(bsflag!=null){
			rowParam['bsflag']=bsflag.value;
		}
		var record_id = document.getElementById("record_id_"+i);
		if(record_id != null){
			rowParam['wa2d_line_id'] = record_id.value;
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
	saveFunc("gp_ops_wa2d_line_finish ",rows);
	refreshData();
}

function refreshData(){
	deleteTable("lineTable");
	initData();
}

function deleteTable(tableID){
	var tb = document.getElementById(tableID);
    var rowNum=tb.rows.length;
    for (i=1;i<rowNum;i++)
    {
    	tb.deleteRow(i);
	    rowNum=rowNum-1;
	    i=i-1;
	}
}

function exportExcel(){
	var path = cruConfig.contextPath+"/pm/exportDataToExcel.srq";
	var rows=JSON.stringify(exportRows);
	var fromPage = "sh2dlineCompleted";
	var submitStr = "fromPage=" + fromPage + "&projectName="+projectName+"&dataRows="+rows;
	var retObj = syncRequest("post", path, submitStr);
	window.location=cruConfig.contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname=" + fromPage + ".xls";
}


function downloadTemplate(){
	window.location.href="<%=contextPath%>/pm/dailyReport/singleProject/download.jsp?path=/pm/lineCompleted/sh2dlineCompleted.xls&filename=sh2dlineCompleted.xls";
}

function importData(){
	var filename = document.getElementById("fileName").value;
	if(filename == ""){
		alert("请选择导入文件!");
		return;
	}
	if(checkFile(filename)){
		document.getElementById("fileForm").action = "<%=contextPath%>/pm/gpe/importLineCompletedSh.srq?workMethod=2&teamName="+team_name;
		document.getElementById("fileForm").submit();
	}
}

function checkFile(filename){
	var type=filename.match(/^(.*)(\.)(.{1,8})$/)[3];
	type=type.toUpperCase();
	if(type=="XLS" || type=="XLSX"){
	   return true;
	}else{
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
			<td width="100%" align="center"><font size="3"><%=projectName%>测线完成情况表</font></td>
		</tr>
	</table>
	<div id="scrollDiv" class="scrollDiv">
		<table id="lineTable" width="100%" border="0" cellspacing="0" align="center" cellpadding="0" class="scrolltable">
			<thead>
				<tr class="scrollColThead td_head">
					<td>队号</td>
					<td>序号</td>
					<td>测线号</td>
					<td>设计测线满覆盖</td>
					<td>实际完成满覆盖</td>
					<td>补线率(%)</td>
					<td>施工起止日期</td>
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