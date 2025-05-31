<%@page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.bgp.mcs.service.pm.service.project.WorkMethodSrv"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getEmpId();
	String projectName = user.getProjectName();
	String projectInfoNo = user.getProjectInfoNo();
	WorkMethodSrv wm = new WorkMethodSrv();
	String workmethod = wm.getProjectWorkMethod(projectInfoNo);
	String contextPath = request.getContextPath();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());
%>
<html>
<head>
<title>时效分析</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/setday.js"></script>
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
	height: 90%;
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
var workmethod = "<%=workmethod%>";

var exportRows = new Array();
var team_name = "";

function initData(){
	//获取队号
	var retPrj = jcdpCallService("TaskBookSrv", "getProjectInfo", "");
	if(retPrj.project != null){
		team_name = retPrj.project.team_name;
	}
	
	//加载数据
	var retObj = jcdpCallService("AgingAnalysisSrv","readShDailyReport","");
    if(retObj.datas != null){
		var allRows = retObj.datas.length;
		for(var i=0;i<allRows;i++){
			var record = retObj.datas[i];
			var tr = document.getElementById("lineTable").insertRow();
			
			if(i % 2 == 0){
		    	tr.className = "even";
			}else{
				tr.className = "odd";
			}
			
			tr.insertCell().innerHTML = team_name;
			tr.insertCell().innerHTML = record.week_work_start_time;
			tr.insertCell().innerHTML = record.week_work_end_time;
 			tr.insertCell().innerHTML = record.natural_days;
			tr.insertCell().innerHTML = record.produce_time;
			tr.insertCell().innerHTML = record.day_check_time;
			tr.insertCell().innerHTML = record.collect_time;
			tr.insertCell().innerHTML = record.workload_sum;
			tr.insertCell().innerHTML = record.workload_plan;
			tr.insertCell().innerHTML = record.workload_avg;
			tr.insertCell().innerHTML = record.workload_max; 
			
			
			var exportRow = {};
			exportRow["1"] = team_name;
			exportRow["2"] = record.week_work_start_time;
			exportRow["3"] = record.week_work_end_time;
			exportRow["4"] = record.natural_days;
			exportRow["5"] = record.produce_time;
			exportRow["6"] = record.day_check_time;
			exportRow["7"] = record.collect_time;
			exportRow["8"] = record.workload_sum;
			exportRow["9"] = record.workload_plan;
			exportRow["10"] = record.workload_avg;
			exportRow["11"] = record.workload_max;
			exportRows[exportRows.length] = exportRow;
		} 
	}
	
}


function exportExcel(){
	var path = cruConfig.contextPath+"/pm/exportDataToExcel.srq";
	var rows=JSON.stringify(exportRows);
	var fromPage = "shagingAnalysis";
	var submitStr = "fromPage=" + fromPage + "&projectName="+projectName+"&dataRows="+rows;
	var retObj = syncRequest("post", path, submitStr);
	window.location=cruConfig.contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname=" + fromPage + ".xls";
}
</script>
</head>
<body style="background: #fff; overflow-y: auto; overflow-x: auto;" onload="initData()" width="800px">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="90%" align="center"><font size="3"><%=projectName%>时效分析表</font></td>
			<td width="10%">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>&nbsp;</td>
						<auth:ListButton functionId="" css="dc"
							event="onclick='exportExcel()'" title="导出excel"></auth:ListButton>
					</tr>
				</table>
			</td>
			<td width="4"><img src="<%=contextPath%>/images/list_17.png"
				width="4" height="36" /></td>
		</tr>
	</table>
	<div id="scrollDiv" class="scrollDiv">
		<table id="lineTable" width="100%" border="0" cellspacing="0"  align="center" cellpadding="0" class="scrolltable">
    <thead>
    <tr class="scrollColThead td_head">
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td colspan="3">时间利用(日)</td>
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
      <td colspan="1"></td>
      <td colspan="2">停工天数</td>
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
      <td nowrap>&nbsp;生产天数&nbsp;</td>
      <td nowrap>&nbsp;&nbsp;DOWNTIME(天)&nbsp;&nbsp;</td>
      <td nowrap>&nbsp;&nbsp;STANDBY(天)&nbsp;&nbsp;</td>
      <td nowrap>&nbsp;&nbsp;生产量&nbsp;&nbsp;</td>
      <td nowrap>采集计划日效</td>
      <td nowrap>采集平均日效</td>
      <td nowrap>采集最高日效</td>
    </tr>
	</thead>
</table>
	</div>
</body>
</html>
