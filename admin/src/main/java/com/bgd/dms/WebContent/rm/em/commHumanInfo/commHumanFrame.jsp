<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = user.getOrgSubjectionId();
	String paramsType = request.getParameter("params");
%>



<frameset cols="300,*" frameborder="yes" border="0" framespacing="0">

  <frame src="<%=contextPath %>/rm/em/commHumanInfo/selectOrgHR.jsp" name="mainTopframe" frameborder="no" scrolling="auto" id="mainTopframe" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>

  <frame src="<%=contextPath %>/rm/em/commHumanInfo/commHumanList.jsp?orgSubId=<%=orgSubId%>&paramsType=<%=paramsType%>" name="mainFrame" frameborder="no" scrolling="auto"  id="mainFrame" style="border-left: 2px solid #5796DD; cursor: w-resize;"/> 

</frameset>