<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>

<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js" charset="utf-8"></script>

<div id="hse_c647893f3d81b062e0430a15082cb062" style="width:100%; height:100%; overflow:auto;"></div>
<div id="hse_c647893f3d88b062e0430a15082cb062" style="width:100%; height:100%; overflow:auto;"></div> 
<script type="text/javascript">
	var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/StackedColumn2D.swf", "myChartId4", "100%", "100%", "0", "0" );    
	myChart4.setXMLUrl("<%=contextPath%>/hse/chart/queryAccLevelColumn.srq");      
	myChart4.render("hse_c647893f3d88b062e0430a15082cb062");	
</script>  
 
<script type="text/javascript">
		var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/StackedColumn2D.swf", "myChartId3", "100%", "100%", "0", "0" );    
		myChart2.setXMLUrl("<%=contextPath%>/hse/chart/queryAccTypeColumn.srq");      
		myChart2.render("hse_c647893f3d81b062e0430a15082cb062");	
</script>  


