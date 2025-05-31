<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath=request.getContextPath();
	String startDate = request.getParameter("startDate");
	String endDate = request.getParameter("endDate");
	if(startDate == null){
		startDate = "";
	}
	if(endDate == null){
		endDate = "";
	}
	
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo == null || "".equals(projectInfoNo)){
		UserToken user = OMSMVCUtil.getUserToken(request);
		projectInfoNo = user.getProjectInfoNo();
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<link href="${applicationScope.fusionChartsURL}/Code/assets/ui/css/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>	
<title>工作量统计</title>
</head>
<body style="background: #fff; overflow-y: auto" onload="getFusionChart()">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="6" colspan="2"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
		<td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">			 
	<tr>
		<td><table><tr>
	    <td>&nbsp;&nbsp;起始日期
	    	<input id="start_date" name="start_date" type="text" width="10" readonly/>
	    	<img src="<%=contextPath%>/images/calendar.gif" id="tbutton1" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(start_date,tbutton1);"/>
	    	&nbsp;&nbsp;结束日期
	    	<input id="end_date" name="end_date" type="text" width="10" readonly/>
	    	<img src="<%=contextPath%>/images/calendar.gif" id="tbutton2" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(end_date,tbutton2);"/>
	    	&nbsp;&nbsp;
	    </td>
	    <td align="left">
		   <span class="cx"><a href="#" onclick="statistics()" title="JCDP_btn_query"></a></span>
		</td>
		</tr></table></td>
		<td></td>
	</tr>
</table>		
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>				<td>				</td>			</tr>
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="40%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><a href="#">测量工作量统计</a></div>
						<div class="tongyong_box_content_left"  id="chartContainer1" style="height: 250px;">
			 
						</div>
						</div>
						</td>
						<td width="40%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><a href="#">表层工作量统计</a></div>
						<div class="tongyong_box_content_left" id="chartContainer2" style="height: 250px;">
						</div>
						</div>
						</td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="40%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><a href="#">钻井工作量统计</a></div>
						<div class="tongyong_box_content_left" id="chartContainer3" style="height: 250px;">
						</div>
						</div>
						</td>
						<td width="40%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><a href="#">采集工作量统计</a></div>
						<div class="tongyong_box_content_left" id="chartContainer4" style="height: 250px;"></div>
						</div>
						</td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</div>
</body>
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath%>';
var projectInfoNo = "<%=projectInfoNo%>";
var startDate = "<%=startDate%>";
var endDate = "<%=endDate%>";
if(projectInfoNo == ""){
	projectInfoNo = "notexist";
}
if(startDate == "" || endDate == ""){
	var curDate = new Date();
	var year = curDate.getYear();
	var month = curDate.getMonth()+1;
	var day = curDate.getDate();
	var strDate = "";
	if(month >= 10){
		strDate = year + "-" + month + "-" + day;
	}else{
		strDate = year + "-0" + month + "-" + day;
	}
	startDate = year +"-01"+"-01";
	endDate = strDate;
}
	
document.getElementById("start_date").value = startDate;
document.getElementById("end_date").value = endDate;

 function getFusionChart(){
	
	var startDate = document.getElementById("start_date").value;
	var endDate =  document.getElementById("end_date").value;
	
	var retObj = jcdpCallService("WorkloadStatisticsSrv","getProjectWorkload","projectInfoNo="+projectInfoNo+"&startDate=" + startDate + "&endDate="+endDate);
	var collXmlData = retObj.collStr;
	var measureXmlData = retObj.measureStr;
	var drillXmlData = retObj.drillStr;
	var surfaceXmlData = retObj.surfaceStr;
	
	var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumnLine3D.swf", "myChartId1", "100%", "100%", "0", "0" );    
	myChart1.setXMLData(measureXmlData);
	myChart1.render("chartContainer1");
	
	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumnLine3D.swf", "myChartId2", "100%", "100%", "0", "0" );    
	myChart2.setXMLData(surfaceXmlData);
	myChart2.render("chartContainer2");
	
	var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumnLine3D.swf", "myChartId3", "100%", "100%", "0", "0" );    
	myChart3.setXMLData(drillXmlData);
	myChart3.render("chartContainer3");
	
	var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumnLine3D.swf", "myChartId4", "100%", "100%", "0", "0" );    
	myChart4.setXMLData(collXmlData);
	myChart4.render("chartContainer4");
}

function statistics(){
	var startDate = document.getElementById("start_date").value;
	var endDate =  document.getElementById("end_date").value;
	
	if("" == startDate){
		alert("请选择开始日期!");
		return;
	}
	if("" == endDate){
		alert("请选择结束日期!");
		return;
	}
	getFusionChart();
}
</script>
<script type="text/javascript">
	/**/function frameSize() {
		var width = $(window).width() - 256;
		$("#tongyong_box_content_left_1").css("width", width);
	}
	frameSize();
	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	})
</script>
</html>
