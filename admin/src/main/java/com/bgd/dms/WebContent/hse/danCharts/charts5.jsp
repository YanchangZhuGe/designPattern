<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>

<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js" charset="utf-8"></script>

<div id="hse_c647893f3d6cb062e0430a15082cb062" style="width:100%; height:100%; overflow:auto;"></div>
<div id="hse_c647893f3d77b062e0430a15082cb062" style="width:100%; height:100%; overflow:auto;"></div> 
<script type="text/javascript">
		var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie2D.swf", "myChartId", "100%", "100%", "0", "0" );    
		myChart3.setXMLUrl("<%=contextPath%>/hse/chart/queryAccLevelPie.srq");      
		myChart3.render("hse_c647893f3d77b062e0430a15082cb062");
</script> 
<script type="text/javascript">
		var myChart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie2D.swf", "myChartId", "100%", "100%", "0", "0" );    
		myChart.setXMLUrl("<%=contextPath%>/hse/chart/queryAccTypePie.srq");      
		myChart.render("hse_c647893f3d6cb062e0430a15082cb062");	
</script>  


