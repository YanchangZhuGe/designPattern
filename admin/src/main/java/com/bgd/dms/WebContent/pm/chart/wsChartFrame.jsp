<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.mcs.service.pm.service.project.WorkMethodSrv"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo == null || "".equals(projectInfoNo)){
    	projectInfoNo = user.getProjectInfoNo();
	}
    
    WorkMethodSrv wm = new WorkMethodSrv();
	String 	buildMethod = wm.getProjectExcitationMode(projectInfoNo);
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
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr id="line1">
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">测量日报数据分析</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left"  id="chartContainer1" style="height: 250px;">
						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">测量累积数据分析</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left" id="chartContainer2" style="height: 250px;">
						</div>
						</div>
						</td>
						<td width="1%"></td>
					</tr>
					<tr><td colspan="3"><div class="tongyong_box">
						<div class="tongyong_box_content_left"  id="chartInfo2" style="height: 25px;">
					</div></div></td></tr>
				</table>
				</td>
			</tr>
			<tr id="line2">
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">钻井日报数据分析</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left" id="chartContainer3" style="height: 250px;">
						</div>
						</div>
						</td>
						<td width="1%">
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">钻井累积数据分析</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left" id="chartContainer4" style="height: 250px;">
						</div>
						</div>
						</td>
						<td width="1%"></td>
					</tr>
					<tr><td colspan="3"><div class="tongyong_box">
						<div class="tongyong_box_content_left" id="chartInfo4" style="height: 25px;">
					</div></div></td></tr>
				</table>
				</td>
			</tr>
			<tr id="line3">
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">采集日报数据分析</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left" id="chartContainer5" style="height: 250px;">
						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">采集累积数据分析</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left" id="chartContainer6" style="height: 250px;">
						</div>
						</div>
						</td>
						<td width="1%"></td>
					</tr>
					<tr><td colspan="3"><div class="tongyong_box">
						<div class="tongyong_box_content_left"  id="chartInfo6" style="height: 25px;">
					</div></div></td></tr>
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
var buildMethod = "<%=buildMethod%>";

function getFusionChart(){
	debugger;
	if(buildMethod == "5000100003000000001" || buildMethod == "5000100003000000004"){
		var retObj3 = jcdpCallService("WsDailyReportAnalysisSrv","getDailyActivity","type=drilldailylist&projectInfoNo="+projectInfoNo);
		var drillDataXml = retObj3.xmlData;
		if(drillDataXml == undefined){
			drillDataXml = "";
		}
		var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId3", "100%", "100%", "0", "0" );    
		myChart3.setXMLData(drillDataXml);
		if(drillDataXml == undefined){
			drillDataXml = "";
		}
		myChart3.render("chartContainer3");
		//var chatInfo3 = retObj3.chatInfo;
		//document.getElementById("chartInfo3").innerHTML = chatInfo3;
	
		var retObj4 = jcdpCallService("WsDailyReportAnalysisSrv","getDaysCumulative","type=drilldailylist&projectInfoNo="+projectInfoNo);
		var drillXml = retObj4.xmlData;
		if(drillXml == undefined){
			drillXml = "";
		}
		var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId4", "100%", "100%", "0", "0" );    
		myChart4.setXMLData(drillXml);
		if(drillXml == undefined){
			drillXml = "";
		}
		myChart4.render("chartContainer4");
		var chatInfo4 = retObj4.chatInfo;
		if(chatInfo4 == undefined){
			chatInfo4 = "";
		}
		if(chatInfo4.length > 100){
			chatInfo4 = "&nbsp;&nbsp;&nbsp;&nbsp;" + chatInfo4;
			document.getElementById("chartInfo4").style.height= 40;
			document.getElementById("chartInfo4").innerHTML = '<table boder="0" width="100%"><tr><td width="5%"></td><td width="90%" align="left">'+chatInfo4+'</td><td width="5%"></td></tr><table>';
		}else{
			document.getElementById("chartInfo4").innerHTML = '<table boder="0" width="100%"><tr><td width="5%"></td><td width="90%">'+chatInfo4+'</td><td width="5%"></td></tr><table>';
		}
		
	}else{
		var line = document.getElementById("line2");
		line.parentNode.removeChild(line);
	}
	var retObj1 = jcdpCallService("WsDailyReportAnalysisSrv","getDailyActivity","type=measuredailylist&projectInfoNo="+projectInfoNo);
	var measureDataXml = retObj1.xmlData;
	if(measureDataXml == undefined){
		measureDataXml = "";
	}
	//var chatInfo1 = retObj1.chatInfo;
	//document.getElementById("chartInfo1").innerHTML = chatInfo1;
	
	var retObj5 = jcdpCallService("WsDailyReportAnalysisSrv","getDailyActivity","type=colldailylist&projectInfoNo="+projectInfoNo);
	var collDataXml = retObj5.xmlData;
	if(collDataXml == undefined){
		collDataXml = "";
	}
	//var chatInfo5 = retObj5.chatInfo;
	//document.getElementById("chartInfo5").innerHTML = chatInfo5;
	
	var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId1", "100%", "100%", "0", "0" );    
	myChart1.setXMLData(measureDataXml);
	 
	myChart1.render("chartContainer1");
	
	var myChart5 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId5", "100%", "100%", "0", "0" );    
	myChart5.setXMLData(collDataXml);
	
	myChart5.render("chartContainer5");
	
	var retObj2 = jcdpCallService("WsDailyReportAnalysisSrv","getDaysCumulative","type=measuredailylist&projectInfoNo="+projectInfoNo);
	var measureXml = retObj2.xmlData;
	if(measureXml == undefined){
		measureXml = "";
	}
	var chatInfo2 = retObj2.chatInfo;
 
	if(chatInfo2 == undefined){
		chatInfo2 = "";
	}
	if(chatInfo2.length > 100){
		chatInfo2 = "&nbsp;&nbsp;&nbsp;&nbsp;" + chatInfo2;
		document.getElementById("chartInfo2").style.height= 40;
		document.getElementById("chartInfo2").innerHTML = '<table boder="0" width="100%"><tr><td width="5%"></td><td width="90%" align="left">'+chatInfo2+'</td><td width="5%"></td></tr><table>';
	}else{
		document.getElementById("chartInfo2").innerHTML = '<table boder="0" width="100%"><tr><td width="5%"></td><td width="90%">'+chatInfo2+'</td><td width="5%"></td></tr><table>';
	}
	var retObj6 = jcdpCallService("WsDailyReportAnalysisSrv","getDaysCumulative","type=colldailylist&projectInfoNo="+projectInfoNo);
	var collXml = retObj6.xmlData;
	if(collXml == undefined){
		collXml= "";
	}
	var chatInfo6 = retObj6.chatInfo;
	if(chatInfo6 == undefined){
		chatInfo6= "";
	}
	if(chatInfo6.length > 100){
		chatInfo6 = "&nbsp;&nbsp;&nbsp;&nbsp;" + chatInfo6;
		document.getElementById("chartInfo6").style.height= 40;
		document.getElementById("chartInfo6").innerHTML = '<table boder="0" width="100%"><tr><td width="5%"></td><td width="90%" align="left">'+chatInfo6+'</td><td width="5%"></td></tr><table>';
	}else{
		document.getElementById("chartInfo6").innerHTML = '<table boder="0" width="100%"><tr><td width="5%"></td><td width="90%">'+chatInfo6+'</td><td width="5%"></td></tr><table>';
	}
	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId2", "100%", "100%", "0", "0" );    
	myChart2.setXMLData(measureXml);
	myChart2.render("chartContainer2");
	
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

