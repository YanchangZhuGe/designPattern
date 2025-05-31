<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>

<%
	String contextPath=request.getContextPath();


%>

<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js" charset="utf-8"></script>

<div id="chart_CE75D887EE4B5050E0430A58F8215050" style="width:100%;height:100%;"></div>

<script type="text/javascript">

var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/StackedColumn3D.swf", "myChartId1", "100%", "100%", "0", "0" );    
myChart1.setXMLUrl("<%=contextPath%>/rm/em/getChart4.srq");      
myChart1.render("chart_CE75D887EE4B5050E0430A58F8215050");

</script> 
