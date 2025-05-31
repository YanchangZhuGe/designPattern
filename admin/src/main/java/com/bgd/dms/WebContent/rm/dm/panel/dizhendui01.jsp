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
<div id="chart_caaa9d806639e084e0430a15082ce084" style="width:100%;height:100%"/>
<script type="text/javascript">
	var retObj1 = jcdpCallServiceCache("EarthquakeTeamStatistics","getMachineryEquipmentStatistics","projectInfoNo=<%=projectInfoNo%>");
	var dataXml1 = retObj1.dataXML;
	var myChart1 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId1", "100%", "250", "0", "0" );    
	myChart1.setXMLData(dataXml1);
	myChart1.render("chart_caaa9d806639e084e0430a15082ce084");
	
</script>
		
</script>  