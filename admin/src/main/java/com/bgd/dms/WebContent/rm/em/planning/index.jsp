<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%
	String contextPath = request.getContextPath();
%>
<frameset rows="*" cols="300,*" frameborder="no" border="0" framespacing="0" framespacing="0">



  <frame src="<%=contextPath %>/pm/comm/eps_project_tree.jsp?backUrl=/rm/em/planning/planningList.jsp" name="mainTopframe" frameborder="no" scrolling="no"  style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainTopframe" />
  <frame src="" name="mainRightframe" frameborder="no" scrolling="auto" style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainRightframe"/>
</frameset>