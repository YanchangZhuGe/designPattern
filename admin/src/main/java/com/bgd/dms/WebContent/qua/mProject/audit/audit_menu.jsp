<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_subjection_id = user.getSubOrgIDofAffordOrg();
%>
<%if(org_subjection_id!=null && org_subjection_id.equals("C105")){ %>
 <frameset  cols="310,*"  frameborder="yes" border="0" framespacing="0">
 <frame src="<%=contextPath %>/qua/mProject/audit/audit_tree.jsp" name="mainTopframe" frameborder="no" scrolling="auto" style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainTopframe"/>
  <frame src="<%=contextPath %>/qua/mProject/audit/audit.jsp" name="menuFrame" frameborder="no" scrolling="auto" style="border-left: 2px solid #5796DD; cursor: w-resize;" id="menuFrame"/>
 </frameset>
 <%}else{ %>
 <frameset  cols="0,*"  frameborder="yes" border="0" framespacing="0">
 <frame src="<%=contextPath %>/qua/mProject/audit/audit_tree.jsp" name="mainTopframe" frameborder="no" scrolling="auto" style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainTopframe"/>
  <frame src="<%=contextPath %>/qua/mProject/audit/audit.jsp" name="menuFrame" frameborder="no" scrolling="auto" style="border-left: 2px solid #5796DD; cursor: w-resize;" id="menuFrame"/>
 </frameset>
 <%} %>
 