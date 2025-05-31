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

<div id="chart_c640c8b06d7020ece0430a15082c2005" style="width:100%; height:100%; overflow:auto;"></div>   

<script type="text/javascript">
	var myChart5 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId5", "100%", "100%", "0", "0" );    
	myChart5.setXMLUrl("<%=contextPath%>/cache/op/OpCostSrv/getTeamTargetActualInfo.srq?parentId=S01001004&projectInfoNo=<%=projectInfoNo%>");      
	myChart5.render("chart_c640c8b06d7020ece0430a15082c2005");
	function  drillxmtadt(obj){
		window.showModalDialog("<%=contextPath%>/op/costDashBoard/team8.jsp?parentId="+obj+"&projectInfoNo=<%=projectInfoNo%>",obj,"dialogWidth=800px;dialogHeight=600px");
	}
</script>  