<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>

<div id="chart_c640c8b06d7020ece0430a15082c0009" style="width:100%; height:100%; overflow:auto;"></div>   

<script type="text/javascript">
	var myChart9 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId9", "100%", "100%", "0", "0" );    
	myChart9.setXMLUrl("<%=contextPath%>/cache/op/OpCostSrv/getCompanyCompareCountryInfo.srq");      
	myChart9.render("chart_c640c8b06d7020ece0430a15082c0009");  
	
	 function drillwtsr(obj){
	 	window.showModalDialog("<%=contextPath%>/op/costDashBoard/company4table.jsp?isGuoNei="+obj,obj,"dialogWidth=800px;dialogHeight=600px");
 		}
</script>  