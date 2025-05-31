<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	String leafBackUrl = "/rm/dm/deviceAccount/rootDevAccList.jsp";
	String forderBackUrl = "/rm/dm/deviceAccount/rootDevAccList.jsp";
	String rootBackUrl = "/rm/dm/deviceAccount/rootDevAccList.jsp";
%>

<frameset cols="200,*" frameborder="yes" border="0" framespacing="0">
  <frame src="<%=contextPath %>/rm/dm/tree/ctDeviceTree.jsp?rootBackUrl=<%=rootBackUrl%>&forderBackUrl=<%=forderBackUrl%>&leafBackUrl=<%=leafBackUrl%>" name="mainTopframe" frameborder="no" scrolling="auto" id="mainTopframe" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
  <frame src="<%=contextPath %>/rm/dm/deviceAccount/rootDevAccList.jsp?code" name="mainRightframe" frameborder="no" scrolling="auto" id="mainRightframe" style="border-left: 2px solid #5796DD; cursor: w-resize;"/>
</frameset>
