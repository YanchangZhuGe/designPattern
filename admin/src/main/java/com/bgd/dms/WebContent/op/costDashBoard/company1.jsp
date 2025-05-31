<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>

<div id="chart_c640c8b06d7020ece0430a15082c0001" style="width:100%; height:100%; overflow:auto;"></div>   

<script type="text/javascript">
	var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId1", "100%", "100%", "0", "0" );    
	myChart1.setXMLUrl("<%=contextPath%>/cache/op/OpCostSrv/getCompanyIncomeInfo.srq");      
	myChart1.render("chart_c640c8b06d7020ece0430a15082c0001");  
	
	 function drillgssr(obj){
	 window.showModalDialog("<%=contextPath%>/op/costDashBoard/costCompanyZQ.jsp?d_month="+obj,obj,"dialogWidth=800px;dialogHeight=600px");
 }
</script>  