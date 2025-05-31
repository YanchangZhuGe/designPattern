<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();

%>

<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js" charset="utf-8"></script>

<div id="chart_CA7E5EF530B9C002E0430A15082CC002" style="width:100%;height:100%;"></div>

<script type="text/javascript">

var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "myChartId1", "100%", "100%", "0", "0" );    
myChart1.setXMLUrl("<%=contextPath%>/cache/rm/em/getChart17.srq");    
myChart1.render("chart_CA7E5EF530B9C002E0430A15082CC002");  


</script> 
