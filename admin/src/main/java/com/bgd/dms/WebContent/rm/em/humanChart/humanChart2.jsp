<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%
	String contextPath=request.getContextPath();

%>

<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js" charset="utf-8"></script>

<div id="chart_c645c5aeca608062e0430a15082c8062" style="width:100%;height:100%;"></div>

<script type="text/javascript">

var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie2D.swf", "myChartId2", "100%", "100%", "0", "0" );    
myChart2.setXMLUrl("<%=contextPath%>/rm/em/getChart2.srq");      
myChart2.render("chart_c645c5aeca608062e0430a15082c8062"); 

</script> 
