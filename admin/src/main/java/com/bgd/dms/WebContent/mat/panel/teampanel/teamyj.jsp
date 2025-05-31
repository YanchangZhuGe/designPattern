<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubjectionId = user.getSubOrgIDofAffordOrg();
%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<div id="chart_c63ea7b9253f8016e0430a15082c8016" style="width:100%; height:100%; overflow:auto;">
<iframe width="100%" height="100%" frameborder="0" scrolling="auto" src="<%=contextPath %>/mat/panel/teampanel/teamwzyj.jsp">
</iframe>
</div>