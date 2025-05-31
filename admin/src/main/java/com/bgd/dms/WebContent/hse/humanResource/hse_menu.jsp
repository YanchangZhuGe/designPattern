<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();

	UserToken user = OMSMVCUtil.getUserToken(request);
	String project = request.getParameter("project");
	
%>

<frameset rows="*" cols="260,*" frameborder="no" border="0" framespacing="0">
  <frame src="<%=contextPath %>/hse/humanResource/tree/tree.jsp?project=<%=project %>" name="mainTopframe" frameborder="no" scrolling="auto" id="mainTopframe"  style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
  <frame src="" name="mainRightframe" frameborder="no" scrolling="no" id="mainRightframe" style="border-left: 2px solid #5796DD; cursor: w-resize;"/>
</frameset>
