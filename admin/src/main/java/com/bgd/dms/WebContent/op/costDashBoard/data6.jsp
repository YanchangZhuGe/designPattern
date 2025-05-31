<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>

<div id="chart_c640c8b06d7520ece0430a15082c20ec" style="width:100%; height:100%; overflow:auto;"></div>   

<script type="text/javascript">
	var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId", "100%", "100%", "0", "0" );    
	myChart4.setXMLUrl("<%=contextPath%>/op/costDashBoard/data6.xml");   
	myChart4.render("chart_c640c8b06d7520ece0430a15082c20ec"); 
</script>  