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

<div id="chart_c640c8b06d7020ece0430a15082c1005" style="width:100%; height:100%; overflow:auto;"></div>   

<script type="text/javascript">
	var myChart5 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "myChartId5", "100%", "100%", "0", "0" );    
	myChart5.setXMLUrl("<%=contextPath%>/cache/op/OpCostSrv/getOutcomeCompareTwoTreePieInfo.srq?orgSubjectionId=<%=orgSubjectionId%>");   
	myChart5.render("chart_c640c8b06d7020ece0430a15082c1005");
	
	function drillxmzc(obj){
	 window.showModalDialog("<%=contextPath%>/op/costDashBoard/costSectionZCZQ.jsp?orgId="+obj,obj,"dialogWidth=800px;dialogHeight=600px");
 	}
</script>  