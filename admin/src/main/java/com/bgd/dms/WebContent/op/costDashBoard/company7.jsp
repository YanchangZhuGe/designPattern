<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>

<div id="chart_c640c8b06d7020ece0430a15082c0007" style="width:100%; height:100%; overflow:auto;"></div>   

<script type="text/javascript">
	var myChart7 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "myChartId7", "100%", "100%", "0", "0" );    
	myChart7.setXMLUrl("<%=contextPath%>/cache/op/OpCostSrv/getIncomeCompareTwoTreePieInfo.srq?orgSubjectionId=C105");      
	myChart7.render("chart_c640c8b06d7020ece0430a15082c0007");
	
	function drillxmsr(obj){
		window.showModalDialog("<%=contextPath%>/op/costDashBoard/company4table.jsp?orgId="+obj,obj,"dialogWidth=800px;dialogHeight=600px");
 	}
</script>  