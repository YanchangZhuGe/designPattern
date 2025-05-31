<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String month_no = request.getParameter("month_no");
	String org_sub_id = request.getParameter("org_sub_id");
	String record_id = request.getParameter("record_id");
	String action = request.getParameter("action");
    String org_name= request.getParameter("org_name");
    String subflag= request.getParameter("subflag");
	System.out.println("subflag::"+subflag);
%>

<frameset rows="*" cols="242,*" frameborder="no" border="0" framespacing="0">
  <frame src="<%=contextPath %>/hse/hseOptionPage/hseMonthlyReport/tree.jsp?month_no=<%=month_no %>&org_sub_id=<%=org_sub_id %>&record_id=<%=record_id %>&action=<%=action%>&org_name=<%=org_name%>&subflag=<%=subflag%>" name="mainLeftframe" frameborder="no" scrolling="auto" id="mainLeftframe"  style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
  <frame src="<%=contextPath %>/hse/hseOptionPage/hseMonthlyReport/one.jsp?month_no=<%=month_no %>&org_sub_id=<%=org_sub_id %>&record_id=<%=record_id %>&action=<%=action%>&org_name=<%=org_name%>&subflag=<%=subflag%>" name="mainRightframe" frameborder="no" scrolling="no" id="mainRightframe" style="border-left: 2px solid #5796DD; cursor: w-resize;"/>
</frameset>
