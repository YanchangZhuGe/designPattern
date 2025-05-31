<%@page language="java" contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.mcs.web.common.util.Base64" %>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String includeUrl = request.getParameter("url");

	if(includeUrl!=null){
		includeUrl = new String(Base64.decode(includeUrl));
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>Portlet include</title>
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath %>/js/rt/rt_list.js"></script> 
	<script type="text/javascript" src="<%=contextPath %>/js/rt/rt_base.js"></script> 
</head>
<body style="background: white;">
<jsp:include page="<%=includeUrl%>"></jsp:include>
</body>
</html>
