<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userOrgSubjectionId=user.getSubOrgIDofAffordOrg();
	String orgSubjectionId=request.getParameter("orgId");
	if(orgSubjectionId==null||"".equals(orgSubjectionId)){
		orgSubjectionId=userOrgSubjectionId;
	}
%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>

<div id="chart_c640c8b06d7020ece0430a15082c1004" style="width:100%; height:100%; overflow:auto;"></div>   

<script type="text/javascript">
	var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "myChartId4", "100%", "100%", "0", "0" );    
	myChart4.setXMLUrl("<%=contextPath%>/cache/op/OpCostSrv/getIncomeCompareTwoTreePieInfo.srq?orgSubjectionId=<%=orgSubjectionId%>");   
	myChart4.render("chart_c640c8b06d7020ece0430a15082c1004"); 
	function  drillxmsr(obj){
		window.showModalDialog("<%=contextPath%>/op/costDashBoard/costSectionZQ.jsp?orgId="+obj,obj,"dialogWidth=800px;dialogHeight=600px");
	}
</script>  