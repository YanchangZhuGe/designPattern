<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>

<div id="chart_c63ea7b9253e8016e0430a15082c8012" style="width:100%; height:100%; overflow:auto;"></div>   

<script type="text/javascript">
	var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie2D.swf", "myChartId", "100%", "100%", "0", "0" );    
	myChart4.setXMLUrl("<%=contextPath%>/cache/mat/panel/getChart1.srq");   
	myChart4.render("chart_c63ea7b9253e8016e0430a15082c8012"); 
	function drillwzzbxh(obj){
	    	popWindow('<%=contextPath%>/mat/panel/matChart2xz.jsp?matId='+obj,'800:600');
	    }
</script>  