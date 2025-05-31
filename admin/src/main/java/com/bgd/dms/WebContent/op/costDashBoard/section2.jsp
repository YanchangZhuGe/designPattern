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

<div id="chart_c640c8b06d7020ece0430a15082c1002" style="width:100%; height:100%; overflow:auto;"></div>   

<script type="text/javascript">
	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSLine.swf", "myChartId2", "100%", "100%", "0", "0" );    
	myChart2.setXMLUrl("<%=contextPath%>/cache/op/OpCostSrv/getOutcomeCompareYearInfo.srq?orgSubjectionId=<%=orgSubjectionId%>");      
	myChart2.render("chart_c640c8b06d7020ece0430a15082c1002");  
	
 function drillgszc(obj){
	 window.showModalDialog("<%=contextPath%>/op/costDashBoard/costCompanyZCZQ.jsp?d_month="+obj+"&orgId=<%=orgSubjectionId%>",obj,"dialogWidth=800px;dialogHeight=600px");
 }
</script>  