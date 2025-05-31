<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
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

<frameset rows="40%,60%" cols="*" frameborder="no" border="0" framespacing="0" bordercolor="f3f3f3">
  <frame src="<%=contextPath %>/hse/weekReport/outGPS/gps_list.jsp?isProject=<%=isProject %>&week_date=<%=week_date %>&week_end_date=<%=week_end_date %>&org_id=<%=org_id %>&subflag=<%=subflag %>&action=<%=action %>&organ_flag=<%=organ_flag %>" name="mainLeftframe" frameborder="no" scrolling="no" id="mainLeftframe" style="border-top: 2px solid #5796DD; cursor: n-resize;"/>
  <%if(organ_flag.equals("0")){ %>
  <frame src="<%=contextPath %>/hse/weekReport/outGPS/gps_list2.jsp?week_date=<%=week_date %>&week_end_date=<%=week_end_date %>&org_id=<%=org_id %>" name="mainRightframe" frameborder="no" scrolling="no" id="mainRightframe" style="border-top: 2px solid #5796DD; cursor: n-resize;"/>
  <%}else{ %>
  <frame src="<%=contextPath %>/blank.html" name="mainRightframe" frameborder="no" scrolling="no"  id="mainRightframe" style="border-top: 2px solid #5796DD; cursor: n-resize;"/>
  <%} %>
</frameset>
