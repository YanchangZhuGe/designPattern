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
 
	String projectName = user.getProjectName();	
	String projectInfoNo = user.getProjectInfoNo();
	String contextPath = request.getContextPath();
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
#lineTable td{
	border: solid 1px block;
	align: center;
}
</style>
<script type="text/javascript">

cruConfig.contextPath='<%=contextPath%>';

function initData(){
	var retObj = jcdpCallService("WsDailyReportSrv", "getCheckedReport","");
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
			
			tr.insertCell().innerHTML = record.orgName;
			tr.insertCell().innerHTML = record.basin;
			tr.insertCell().innerHTML = record.wellNumber;
			tr.insertCell().innerHTML = record.codingName;
			tr.insertCell().innerHTML = record.contractsSigned;
			tr.insertCell().innerHTML = record.contractAmount;
			tr.insertCell().innerHTML = record.completeValue;
			tr.insertCell().innerHTML = record.viewType;
			tr.insertCell().innerHTML = record.viewWells;
			tr.insertCell().innerHTML = record.viewPoint;
			tr.insertCell().innerHTML = record.buildMethod;
			tr.insertCell().innerHTML = record.collectionSeries;
			tr.insertCell().innerHTML = record.shotNumber;
			tr.insertCell().innerHTML = record.testRecord;
			tr.insertCell().innerHTML = record.obsPoint;
			tr.insertCell().innerHTML = record.qualityPoints;
			tr.insertCell().innerHTML = record.qualityRate;
			tr.insertCell().innerHTML = record.passPoint;
			tr.insertCell().innerHTML = record.passRate;
			tr.insertCell().innerHTML = record.wastePoint;
			tr.insertCell().innerHTML = record.wasteRate;
			tr.insertCell().innerHTML = record.refPoints;
			tr.insertCell().innerHTML = record.micLogging;
			tr.insertCell().innerHTML = record.startDate;
			tr.insertCell().innerHTML = record.endDate;
			tr.insertCell().innerHTML = record.projectStatus;
			tr.insertCell().innerHTML = record.handleExplainStatus;
			tr.insertCell().innerHTML = record.passDate;
			tr.insertCell().innerHTML = record.remarks;
			
			
		}
	}
}

</script>
</head>
<body style="background: #fff; overflow-y: auto; overflow-x: auto;" onload="initData()">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" id="idsType">
	<tr>
		<td width="100%" align="center"><font size="3">东方地球物理公司井中地震项目进度动态表</font></td>
	</tr>
	</table>
	<div id="scrollDiv" class="scrollDiv">
		<table id="lineTable" width="100%" border="0" cellspacing="0" align="center" cellpadding="0" class="scrolltable">
			<tr align="center" >
				<td rowspan="2" class="bt_info_odd">施工队伍</td>
				<td rowspan="2" class="bt_info_odd">地区(盆地)</td>
				<td rowspan="2" class="bt_info_odd">施工井号</td>
				<td rowspan="2" class="bt_info_odd">甲方名称</td>
				<td rowspan="2" class="bt_info_odd">已签订合同额(万 元)</td>
				<td rowspan="2" class="bt_info_odd">预测价值工作量(万 元)</td>
				<td rowspan="2" class="bt_info_odd">完成价值工作量(万 元)</td>
				<td colspan="5" class="bt_info_odd">采集参数</td>
				<td colspan="11" class="bt_info_odd">完成工作量及质量</td>
				<td rowspan="2" class="bt_info_odd">开工时间</td>
				<td rowspan="2" class="bt_info_odd">完工时间</td>
				<td rowspan="2" class="bt_info_odd">运行状态</td>
				<td rowspan="2" class="bt_info_odd">处理、解释状态</td>
				<td rowspan="2" class="bt_info_odd">甲方验收日期</td>
				<td rowspan="2" class="bt_info_odd">备注</td>
			</tr>
			<tr align="center" >
				<td class="bt_info_odd">观测方式</td>
				<td class="bt_info_odd">观测井段</td>
				<td class="bt_info_odd">观测点距（米）</td>
				<td class="bt_info_odd">激发方式</td>
				<td class="bt_info_odd">采集级数（级）</td>
				<td class="bt_info_odd">炮数</td>
				<td class="bt_info_odd">合格试验记录</td>
				<td class="bt_info_odd">总观测点数</td>
				<td class="bt_info_odd">优级品点数</td>
				<td class="bt_info_odd">优级品率（%）</td>
				<td class="bt_info_odd">合格品点数</td>
				<td class="bt_info_odd">合格品率（%）</td>
				<td class="bt_info_odd">废品点数</td>
				<td class="bt_info_odd">废品率（%）</td>
				<td class="bt_info_odd">小折射点数</td>
				<td class="bt_info_odd">微测井(口)</td>	
			</tr>
		</table>
	</div>
</body>
</html>