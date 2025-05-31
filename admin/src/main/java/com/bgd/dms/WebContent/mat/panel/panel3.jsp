<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<div id="chart_c63ea7b925408016e0430a15082c8011" style="width:100%; height:100%; overflow:auto;"></div>  
<script type="text/javascript">
	
	var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column2D.swf", "ChartId", "100%", "100%", "0", "0" );    
	myChart3.setXMLUrl("<%=contextPath%>/cache/mat/panel/getChart2.srq");   
	myChart3.render("chart_c63ea7b925408016e0430a15082c8011"); 
	 function drillwyczxh(obj){
	    	popWindow('<%=contextPath%>/mat/panel/wtcwycz.jsp?orgSubjectionId='+obj,'800:600');
	    }
</script>  
