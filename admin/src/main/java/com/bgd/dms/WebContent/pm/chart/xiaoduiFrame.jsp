<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String projectInfoNo = user.getProjectInfoNo();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>	
<link href="${applicationScope.fusionChartsURL}/Code/assets/ui/css/style.css" rel="stylesheet" type="text/css" />
<title>无标题文档</title>
</head>
<body style="background: #fff; overflow-y: auto"  onload="getFusionChart()">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				</td>
			</tr>
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="40%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">测量日报数据分析</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left"  id="chartContainer1" style="height: 250px;">
			 
						</div>
						</div>
						</td>
						<td width="40%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">测量累积数据分析</a><span class="gd"><a
							href="#"></a></span></div>
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
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">钻井日报数据分析</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left" id="chartContainer3" style="height: 250px;">

						</div>
						</div>
						</td>
						<td width="40%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">钻井累积数据分析</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left" id="chartContainer4" style="height: 250px;">
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
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">采集日报数据分析</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left" id="chartContainer5" style="height: 250px;">
						</div>
						</div>
						</td>
						<td width="40%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">采集累积数据分析</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left" id="chartContainer6" style="height: 250px;">
						</div>
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

function getFusionChart(){
	var retObj1 = jcdpCallService("DailyReportAnalysisSrv","getDailyActivity","type=measuredailylist&projectInfoNo="+projectInfoNo);
	var measureDataXml = retObj1.xmlData;
	var retObj3 = jcdpCallService("DailyReportAnalysisSrv","getDailyActivity","type=drilldailylist&projectInfoNo="+projectInfoNo);
	var drillDataXml = retObj3.xmlData;
	var retObj5 = jcdpCallService("DailyReportAnalysisSrv","getDailyActivity","type=colldailylist&projectInfoNo="+projectInfoNo);
	var collDataXml = retObj5.xmlData;
	
	var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId1", "100%", "100%", "0", "0" );    
	myChart1.setXMLUrl("acquireData.xml");
	myChart1.render("chartContainer1");
	
	var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId3", "100%", "100%", "0", "0" );    
	myChart3.setXMLData(drillDataXml);
	myChart3.render("chartContainer3");
	
	var myChart5 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId5", "100%", "100%", "0", "0" );    
	myChart5.setXMLData(collDataXml);
	myChart5.render("chartContainer5");
	
	var retObj2 = jcdpCallService("DailyReportAnalysisSrv","getDaysCumulative","type=measuredailylist&projectInfoNo="+projectInfoNo);
	var measureXml = retObj2.xmlData;
	var retObj4 = jcdpCallService("DailyReportAnalysisSrv","getDaysCumulative","type=drilldailylist&projectInfoNo="+projectInfoNo);
	var drillXml = retObj4.xmlData;
	var retObj6 = jcdpCallService("DailyReportAnalysisSrv","getDaysCumulative","type=colldailylist&projectInfoNo="+projectInfoNo);
	var collXml = retObj6.xmlData;
	
	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId2", "100%", "100%", "0", "0" );    
	myChart2.setXMLData(measureXml);
	myChart2.render("chartContainer2");
	
	var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId4", "100%", "100%", "0", "0" );    
	myChart4.setXMLData(drillXml);
	myChart4.render("chartContainer4");
	
	var myChart6 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId6", "100%", "100%", "0", "0" );    
	myChart6.setXMLData(collXml);
	myChart6.render("chartContainer6");
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

