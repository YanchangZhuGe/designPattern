<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.cnpc.jcdp.webapp.util.ActionUtils"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.webapp.constant.MVCConstant"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%
	/*
	* author:邱庆豹
	* des：审批公共页面
	* create;2010-7-15
	*/
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	response.sendRedirect(contextPath+respMsg.getValue("forwardUrl"));
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<link href="<%=contextPath%>/styles/table.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">

</script>
<title>执行审批</title>
</head>
<body>

</body>
</html>