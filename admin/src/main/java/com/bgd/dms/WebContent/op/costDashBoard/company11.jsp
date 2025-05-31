<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>

<div id="chart_c640c8b06d7020ece5430a15082c0009" style="width:100%; height:100%; overflow:auto;"></div>   

<script type="text/javascript">
	var myChart11 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "myChartId8", "100%", "100%", "0", "0" );    
	myChart11.setXMLUrl("<%=contextPath%>/cache/op/OpCostSrv/getCompanyCompareCountryLirunInfo.srq");      
	myChart11.render("chart_c640c8b06d7020ece5430a15082c0009");  
	
	 function drillwtlr(obj){
	 	window.showModalDialog("<%=contextPath%>/op/costDashBoard/company6.jsp",obj,"dialogWidth=800px;dialogHeight=600px");
 		}
</script>  