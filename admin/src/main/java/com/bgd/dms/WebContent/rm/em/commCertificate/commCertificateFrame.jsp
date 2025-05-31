<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = user.getSubOrgIDofAffordOrg();
	String codingCode = request.getParameter("codingCode");
%>

<frameset cols="300,*" frameborder="yes" border="0" framespacing="0">

  <frame src="<%=contextPath %>/rm/em/commCertificate/selectOrgSub.jsp?orgSubId=<%=orgSubId%>" name="mainTopframe" frameborder="no" scrolling="auto" style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainTopframe"/>

  <frame src="<%=contextPath %>/rm/em/commCertificate/commCertificateList.jsp?orgSubId=<%=orgSubId%>&codingCode=<%=codingCode%>" name="mainFrame" frameborder="no" scrolling="auto" style="border-left: 2px solid #5796DD; cursor: w-resize;" id="mainFrame"/> 

</frameset>