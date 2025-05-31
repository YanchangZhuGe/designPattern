<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String orgId = user.getSubOrgIDofAffordOrg();
String orgstrId = user.getOrgId();
%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<div id="chart_caaa9d806636e084e0430a15082ce084" style="width:100%;height:100%"/>
<script type="text/javascript">
	//主要设备完好率、利用率(物探处级) -- 先时时统计台账，出这个图
	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId2", "100%", "250", "0", "0" );    
	myChart2.setXMLUrl("<%=contextPath%>/cache/rm/dm/getCompDevRatioChartWTNew.srq?orgstrId=<%=orgstrId%>&drilllevel=1");
	myChart2.render("chart_caaa9d806636e084e0430a15082ce084"); 
</script>
