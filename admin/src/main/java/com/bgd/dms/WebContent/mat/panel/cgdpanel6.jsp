<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<div id="chart_c63ea7b925408016e0430a15082c8010" style="width:100%; height:100%; overflow:auto;"></div>  
<script type="text/javascript">
	
	var myChart3 = new FusionCharts( "${applicationScope.fusionWidgetsURL}/Charts/AngularGauge.swf", "myChartId2", "100%", "220", "0", "0" );    
	myChart3.setXMLUrl("<%=contextPath%>/cache/mat/panel/getChartBI2.srq");   
	myChart3.render("chart_c63ea7b925408016e0430a15082c8010");
</script>  
