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

<div id="chart_c640c8b06d7020ece0430a15082c2002" style="width:100%; height:100%; overflow:auto;"></div>   

<script type="text/javascript">
	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId2", "100%", "100%", "0", "0" );    
	myChart2.setXMLUrl("<%=contextPath%>/cache/op/OpCostSrv/getCompareTargetActualInfo.srq?projectInfoNo=<%=projectInfoNo%>");      
	myChart2.render("chart_c640c8b06d7020ece0430a15082c2002"); 
	
	 function drillxmtadb(obj){
	 window.showModalDialog("<%=contextPath%>/op/costDashBoard/team2.jsp?projectInfoNo="+obj,obj,"dialogWidth=800px;dialogHeight=600px");
 }
</script>  