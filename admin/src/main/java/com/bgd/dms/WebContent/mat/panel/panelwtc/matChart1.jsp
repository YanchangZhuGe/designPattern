<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubjectionId =request.getParameter("orgSubjectionId");
	System.out.println(orgSubjectionId);
	if(orgSubjectionId==null){
		orgSubjectionId = user.getSubOrgIDofAffordOrg();
	}
%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<div id="chart_c63ea7b9253f8016e0430a15082c8016" style="width:100%; height:100%; overflow:auto;"></div>
<script type="text/javascript">
	var myChart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column2D.swf", "ChartId", "100%", "100%", "0", "0" );    
	myChart.setXMLUrl("<%=contextPath%>/mat/panel/getChart8.srq?orgSubjectionId=<%=orgSubjectionId%>");   
	myChart.render("chart_c63ea7b9253f8016e0430a15082c8016"); 
</script>