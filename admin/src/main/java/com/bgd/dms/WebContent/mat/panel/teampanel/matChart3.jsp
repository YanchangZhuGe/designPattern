<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<div id="chart_c63ea7b925408016e0430a15082c801a" style="width:100%; height:100%; overflow:auto;"></div>  
<script type="text/javascript">
	
	var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie2D.swf", "ChartId", "100%", "100%", "0", "0" );    
	myChart3.setXMLUrl("<%=contextPath%>/cache/mat/panel/getChart6.srq?projectInfoNo=<%=projectInfoNo%>");
	myChart3.render("chart_c63ea7b925408016e0430a15082c801a"); 
	
</script>  
