<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
%>

<frameset rows="320,300" frameborder="yes" border="0" framespacing="0">
  <frame src="<%=contextPath %>/dmsManager/repair/spare/spareConsumeAnal.jsp" name="topframe" frameborder="no" scrolling="auto" id="topframe" />
  <frame src="<%=contextPath %>/dmsManager/repair/spare/spare_consume_list.jsp" name="bottomframe" frameborder="no" scrolling="auto" id="bottomframe" />
</frameset>