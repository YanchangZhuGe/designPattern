<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String isProject = request.getParameter("isProject");

%>

<frameset rows="25px,*" cols="*" frameborder="no" border="0" framespacing="0" bordercolor="f3f3f3">
  <frame src="<%=contextPath %>/hse/techAndResource/techResourceTag.jsp?isProject=<%=isProject %>" name="mainTopframe" frameborder="no" scrolling="no" noresize="noresize" id="mainTopframe"/>
  <frame src="" name="bottomFrame" frameborder="no" scrolling="no" id="bottomFrame" />
</frameset>
