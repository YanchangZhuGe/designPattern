<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
</head>
<body style="height: 600px">
<div id="chart_c640c8b06d7020ece7430a15082c0004" style="width:100%; height:100%; overflow:auto;">
</div>   
</body> 
<script type="text/javascript" >
	var myChart17 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId4", "100%", "100%", "0", "0" );    
	myChart17.setXMLUrl("<%=contextPath%>/op/OpCostSrv/getCompareSectionLirunTwoThreeInfo.srq");   
	myChart17.render("chart_c640c8b06d7020ece7430a15082c0004"); 
	
	function drillxmlr(obj){
	 window.showModalDialog("<%=contextPath%>/op/costDashBoard/costSectionLRZQ.jsp?orgId="+obj,obj,"dialogWidth=800px;dialogHeight=600px");
 	}
</script> 

</html>