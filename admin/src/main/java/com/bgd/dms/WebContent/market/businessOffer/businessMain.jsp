<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%
 
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = user.getOrgSubjectionId();
%>
<frameset rows="*" cols="240,*" frameborder="no" border="0" framespacing="0" framespacing="0">
  <frame src="<%=contextPath %>/market/businessOffer/selectOrgHR.jsp" name="mainTopframe" frameborder="no" scrolling="auto" id="mainTopframe" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
  <frame src="<%=contextPath %>/market/businessOffer/businessList.jsp?orgSubId=<%=orgSubId%>" name="mainFrame" frameborder="no" scrolling="auto"  id="mainFrame" style="border-left: 2px solid #5796DD; cursor: w-resize;"/>
</frameset>
