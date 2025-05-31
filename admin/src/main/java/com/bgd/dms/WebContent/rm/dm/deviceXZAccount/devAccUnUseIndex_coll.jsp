<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
%>

<frameset rows="200,300" frameborder="yes" border="0" framespacing="0">
  <frame src="<%=contextPath %>/rm/dm/deviceXZAccount/deviceLieOne_coll.jsp" name="mainTopframe" frameborder="no" scrolling="auto" id="mainTopframe" style="border-bottom: 2px solid #5796DD; cursor: w-resize;"/>
  <frame src="<%=contextPath %>/rm/dm/deviceXZAccount/DevAccListUnUse_coll.jsp" name="mainRightframe" frameborder="no" scrolling="auto" id="mainRightframe" style="border-top: 2px solid #5796DD; cursor: w-resize;"/>
</frameset>