<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>

<div id="chart_c63ea7b925408016e0430a15082c8014" style="width:100%; height:100%; overflow:auto;"></div>   

<script type="text/javascript">
	var myChart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "ChartId", "100%", "220", "0", "0" );    
	myChart.setXMLUrl("<%=contextPath%>/cache/mat/panel/getChart3.srq"); 
	myChart.render("chart_c63ea7b925408016e0430a15082c8014"); 
	function drillwzxhxh(obj){
	    	popWindow('<%=contextPath%>/mat/panel/wtcwycz.jsp?orgSubjectionId='+obj,'800:600');
	    }
</script>  