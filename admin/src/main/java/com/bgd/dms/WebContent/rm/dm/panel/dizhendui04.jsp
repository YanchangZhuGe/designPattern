<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String projectInfoNo = user.getProjectInfoNo();
%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<div id="chart_caaa9d80663ce084e0430a15082ce084" style="width:100%;height:100%"/>
<script type="text/javascript">
	var retObj4 = jcdpCallServiceCache("EarthquakeTeamStatistics","geAcquisitionEquipmentStatistics","projectInfoNo=<%=projectInfoNo%>");
	var dataXml4 = retObj4.dataXML;
	var myChart4 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId4", "100%", "250", "0", "0" );    
	myChart4.setXMLData(dataXml4);
	myChart4.render("chart_caaa9d80663ce084e0430a15082ce084");
</script>
		
</script>  