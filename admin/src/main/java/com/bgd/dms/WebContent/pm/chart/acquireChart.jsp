<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>
<div id="chart_c63ea7b925408016e0123a15082c8016" style="width:100%; height:100%; overflow:auto;"></div>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript">

	var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId1", "100%", "100%", "0", "0" );
	myChart1.setXMLUrl("<%=contextPath%>/pm/chart/getData.srq?type=colldailylist");
	myChart1.render("chart_c63ea7b925408016e0123a15082c8016");

</script>  

