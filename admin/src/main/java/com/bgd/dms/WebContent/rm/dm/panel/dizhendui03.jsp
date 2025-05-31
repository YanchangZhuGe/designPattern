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
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<div id="chart_caaa9d80663be084e0430a15082ce084" style="width:100%;height:100%"/>
<script type="text/javascript">
	var retObj3 = jcdpCallServiceCache("EarthquakeTeamStatistics","getMobileEquipmentStatisticsForTable","projectInfoNo=<%=projectInfoNo%>");
	var dataXml3 = retObj3.dataXML;
	$("#chart_caaa9d80663be084e0430a15082ce084").append(dataXml3);
</script>
		
</script>  