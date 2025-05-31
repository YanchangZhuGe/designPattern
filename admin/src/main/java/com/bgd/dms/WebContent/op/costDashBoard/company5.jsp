<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
	String gjb=request.getParameter("gjb");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
</head>
<body style="height: 600px">

<div id="chart_c640c8b06d7020ece0430a15082c0005" style="width:100%; height:100%; overflow:auto;"></div>   
</body> 
<script type="text/javascript">
	var myChart5 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId5", "100%", "100%", "0", "0" );    
	myChart5.setXMLUrl("<%=contextPath%>/op/OpCostSrv/getCompanyOutcomeCompareSectionInfo.srq?gjb=<%=gjb%>");   
	myChart5.render("chart_c640c8b06d7020ece0430a15082c0005");  
	
	 function drillxmzc(obj){
	 window.showModalDialog("<%=contextPath%>/op/costDashBoard/costSectionZCZQ.jsp?orgId="+obj,obj,"dialogWidth=800px;dialogHeight=600px");
	 }
</script>  
</html>