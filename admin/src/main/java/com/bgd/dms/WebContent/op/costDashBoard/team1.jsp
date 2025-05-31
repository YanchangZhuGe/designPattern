<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	String projectInfoNo= request.getParameter("projectInfoNo");
	if(projectInfoNo==null||"".equals(projectInfoNo)){
		projectInfoNo=user.getProjectInfoNo();
	}
%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>

<div id="chart_c640c8b06d7020ece0430a15082c2001" style="width:100%; height:100%; overflow:auto;"></div>   

<script type="text/javascript">
	var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "myChartId1", "100%", "100%", "0", "0" );    
	myChart1.setXMLUrl("<%=contextPath%>/cache/op/OpCostSrv/getTeamTargetPieInfo.srq?projectInfoNo=<%=projectInfoNo%>");      
	myChart1.render("chart_c640c8b06d7020ece0430a15082c2001");  
</script>  