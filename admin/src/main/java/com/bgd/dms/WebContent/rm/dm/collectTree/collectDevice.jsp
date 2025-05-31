<%@ page language="java"
	import="com.cnpc.jcdp.common.UserToken,com.cnpc.jcdp.webapp.util.OMSMVCUtil"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String contextPath = request.getContextPath();
%>
<!DOCTYPE>
<html>
	<head>
		<title></title>
		<meta charset="UTF-8">
		<!--[if lt IE 9]>
    		<script src="<%=contextPath%>/js/html5.js"></script>
		<![endif]-->
		<link rel="stylesheet" href="<%=contextPath%>/js/extjs/resources/css/ext-all.css">
	</head>
	<body>
		<script>var _path='<%=contextPath%>'</script>
		<script src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
		<script src="<%=contextPath%>/js/extjs/ext-all-debug.js"></script>
		<script src="<%=contextPath%>/js/extjs/ext-lang-zh_CN.js"></script>
		<script src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script src="collectDevice.js"></script>
	</body>
</html>