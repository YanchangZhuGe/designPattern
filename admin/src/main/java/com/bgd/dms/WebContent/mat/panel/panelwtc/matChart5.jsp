<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubjectionId = user.getSubOrgIDofAffordOrg();
%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<div id="chart_c63ea7b9253f8016e0430a15082c8017" style="width:100%; height:100%; overflow:auto;"></div>
<script type="text/javascript">
	var myChart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column2D.swf", "ChartId", "100%", "100%", "0", "0" );    
	myChart.setXMLUrl("${pageContext.request.contextPath}/mat/panel/panelwtc/matChart5.xml");   
	myChart.render("chart_c63ea7b9253f8016e0430a15082c8017"); 
</script>