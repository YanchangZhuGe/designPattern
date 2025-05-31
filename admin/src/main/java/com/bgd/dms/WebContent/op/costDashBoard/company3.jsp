<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>

<div id="chart_c640c8b06d7020ece0430a15082c0003" style="width:100%; height:100%; overflow:auto;"></div>   

<script type="text/javascript">
	var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId3", "100%", "100%", "0", "0" );    
	myChart3.setXMLUrl("<%=contextPath%>/cache/op/OpCostSrv/getCompanyProfitInfo.srq");   
	myChart3.render("chart_c640c8b06d7020ece0430a15082c0003"); 
	
	function drillgslr(obj){
	 window.showModalDialog("<%=contextPath%>/op/costDashBoard/costCompanyLRZQ.jsp?d_month="+obj,obj,"dialogWidth=800px;dialogHeight=600px");
 	}
</script>  