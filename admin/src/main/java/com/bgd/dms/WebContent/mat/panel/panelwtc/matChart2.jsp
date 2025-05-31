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

<div id="chart_c640c8b06d7120ece0430a15082c20ec" style="width:100%; height:100%; overflow:auto;"></div>   

<script type="text/javascript">
	var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId", "100%", "100%", "0", "0" );    
	myChart4.setXMLUrl("<%=contextPath%>/mat/panel/getChart9.srq?orgSubjectionId=<%=orgSubjectionId%>");   
	myChart4.render("chart_c640c8b06d7120ece0430a15082c20ec"); 
</script>  