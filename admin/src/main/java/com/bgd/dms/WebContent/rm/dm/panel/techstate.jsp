<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<div id="chart_c695c2743cf2d0b6e0430a15082cd0b6" style="width:100%;height:100%"/>
<script type="text/javascript">
		var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie2D.swf", "myChartId1", "350", "210", "0", "0" );    
		myChart1.setXMLUrl("<%=contextPath%>/rm/dm/tree/getDevTechStatusData.srq");      
		myChart1.render("chart_c695c2743cf2d0b6e0430a15082cd0b6");
</script>
		
</script>  