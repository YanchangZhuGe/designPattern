<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();

	UserToken user = OMSMVCUtil.getUserToken(request);

	String week_date = request.getParameter("week_date");
	String week_end_date = request.getParameter("week_end_date");
	String org_id = request.getParameter("org_id");
	String action = request.getParameter("action");
	String audit = request.getParameter("audit");
	
	
%>

<frameset rows="*" cols="300,*" frameborder="no" border="0" framespacing="0">
  <frame src="<%=contextPath %>/pm/comm/tree.jsp?week_date=<%=week_date %>&week_end_date=<%=week_end_date %>&org_id=<%=user.getCodeAffordOrgID()%>&action=<%=action %>" name="mainLeftframe" frameborder="no" scrolling="auto"  id="mainLeftframe" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
  <frame src="" name="mainRightframe" frameborder="no" scrolling="auto" id="mainRightframe" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
</frameset>
