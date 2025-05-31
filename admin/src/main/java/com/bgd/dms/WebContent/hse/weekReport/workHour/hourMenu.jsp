<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
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

<frameset rows="22%,78%" cols="*" frameborder="no" border="0" framespacing="0" bordercolor="f3f3f3">
  <frame src="<%=contextPath %>/hse/weekReport/workHour/hour_list.jsp?isProject=<%=isProject %>&week_date=<%=week_date %>&week_end_date=<%=week_end_date %>&org_id=<%=org_id %>&organ_flag=<%=organ_flag %>&subflag=<%=subflag %>&action=<%=action %>" name="mainLeftframe" frameborder="no" scrolling="auto" id="mainLeftframe" style="border-bottom: 2px solid #5796DD; cursor: n-resize;"/ >
  <%if(organ_flag.equals("0")){ %>
  <frame src="<%=contextPath %>/hse/weekReport/workHour/hour_list2.jsp?week_date=<%=week_date %>&week_end_date=<%=week_end_date %>&org_id=<%=org_id %>&organ_flag=<%=organ_flag %>" name="mainRightframe" frameborder="no" scrolling="no"   id="mainRightframe"  style="border-top: 2px solid #5796DD; cursor: n-resize;"/>
   <%}else{%>
  <frame src="<%=contextPath %>/blank.html" name="mainRightframe" frameborder="no" scrolling="no"  id="mainRightframe" style="border-top: 2px solid #5796DD; cursor: n-resize;"/>
  <%} %>
</frameset>
