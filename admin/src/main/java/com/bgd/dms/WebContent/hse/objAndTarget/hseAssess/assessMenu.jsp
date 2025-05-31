<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();

	UserToken user = OMSMVCUtil.getUserToken(request);
	String project = request.getParameter("project");

%>

<frameset rows="25px,*" cols="*" frameborder="no" border="0" framespacing="0" bordercolor="f3f3f3">
  <frame src="<%=contextPath %>/hse/objAndTarget/hseAssess/assessTag_list.jsp?project=<%=project %>" name="mainTopframe" frameborder="no" scrolling="no" noresize="noresize" id="mainTopframe"/>
  <frame src="" name="assessframe" frameborder="no" scrolling="no" id="assessframe" />
</frameset>
