<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>

<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js" charset="utf-8"></script>
<div id="chart_cba100de9702307ae0430a15082c307a" style="width:100%; height:100%; overflow:auto;"></div> 
<script type="text/javascript">

	var myChart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/StackedColumn2DLine.swf", "myChartId", "100%", "100%", "0", "0" );    
	myChart.setXMLUrl("<%=contextPath%>/risk/charts/risk_chart2.xml");      
	myChart.render("chart_cba100de9702307ae0430a15082c307a");   

</script>  


