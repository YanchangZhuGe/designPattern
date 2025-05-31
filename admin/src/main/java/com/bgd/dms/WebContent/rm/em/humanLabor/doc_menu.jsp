<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%
	String contextPath = request.getContextPath(); 
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = user.getSubOrgIDofAffordOrg(); 
	String laborCategory = request.getParameter("laborCategory");
%>

<frameset cols="250,*" frameborder="yes" border="0" framespacing="0">

  <frame src="<%=contextPath %>/rm/em/humanLabor/selectOrgSub.jsp?orgSubId=<%=orgSubId%>" name="mainTopframe" frameborder="no" scrolling="auto" style="border-right: 2px solid #5796DD; cursor: w-resize;"  id="mainTopframe"/>

  <frame src="<%=contextPath %>/rm/em/humanLabor/doc_list2.jsp?orgSubId=<%=orgSubId%>&laborCategory=<%=laborCategory%>" name="mainFrame" frameborder="no" scrolling="auto"  style="border-left: 2px solid #5796DD; cursor: w-resize;"  id="mainFrame"/> 

</frameset>