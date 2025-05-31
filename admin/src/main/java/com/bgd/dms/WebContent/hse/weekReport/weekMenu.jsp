<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>

<%
	String contextPath = request.getContextPath();

	UserToken user = OMSMVCUtil.getUserToken(request);

	String week_date = request.getParameter("week_date");
	String week_end_date = request.getParameter("week_end_date");
	String org_id = request.getParameter("org_id");
	String subflag = request.getParameter("subflag");
	String action = request.getParameter("action");
	String organ_flag = request.getParameter("organ_flag");
	String isProject = request.getParameter("isProject");
	
%>

<frameset rows="*" cols="300,*" frameborder="no" border="0" framespacing="0">
  <frame src="<%=contextPath %>/hse/weekReport/tree/tree.jsp?isProject=<%=isProject %>&week_date=<%=week_date %>&week_end_date=<%=week_end_date %>&org_id=<%=org_id %>&organ_flag=<%=organ_flag %>&subflag=<%=subflag %>&action=<%=action %>" name="mainLeftframe" frameborder="no" scrolling="auto" id="mainLeftframe"  style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
  <frame src="" name="mainRightframe" frameborder="no" scrolling="no" id="mainRightframe" style="border-left: 2px solid #5796DD; cursor: w-resize;"/>
</frameset>
