<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
        <%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();

%>

<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js" charset="utf-8"></script>

<div id="chart_CE75CF444D5CF0AAE0430A58F821F0AA" style="width:100%;height:100%;"></div>

<script type="text/javascript">

var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId5", "100%", "100%", "0", "0" );    
myChart1.setXMLUrl("<%=contextPath%>/rm/em/getChart15.srq?orgId=<%=orgId%>");      
myChart1.render("chart_CE75CF444D5CF0AAE0430A58F821F0AA"); 

</script> 
