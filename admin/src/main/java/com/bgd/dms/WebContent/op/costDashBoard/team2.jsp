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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
</head>
<body style="height: 600px">
<div id="chart_c640c8b06d7020ece0430a15082c2002" style="width:100%; height:100%; overflow:auto;"></div>   
</body> 
<script type="text/javascript">
	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId2", "100%", "100%", "0", "0" );    
	myChart2.setXMLUrl("<%=contextPath%>/op/OpCostSrv/getTeamTargetActualInfo.srq?parentId=S01001&projectInfoNo=<%=projectInfoNo%>");      
	myChart2.render("chart_c640c8b06d7020ece0430a15082c2002"); 
	
	function  drillxmtadt(obj){
		window.showModalDialog("<%=contextPath%>/op/costDashBoard/team8.jsp?parentId="+obj+"&projectInfoNo=<%=projectInfoNo%>",obj,"dialogWidth=800px;dialogHeight=600px");
	}
</script>  
</html>