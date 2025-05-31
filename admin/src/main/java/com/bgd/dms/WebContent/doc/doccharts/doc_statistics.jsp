<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>

<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js" charset="utf-8"></script>
<div id="chart_c640067cce5740c4e0430a15082c40c4" style="width:100%; height:100%; overflow:auto;"></div> 
<script type="text/javascript">

	var myChart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column2D.swf", "myChartId", "100%", "100%", "0", "0" );    
	myChart.setXMLUrl("<%=contextPath%>/cache/doc/getDocChart.srq");      
	myChart.render("chart_c640067cce5740c4e0430a15082c40c4");   

</script>  


