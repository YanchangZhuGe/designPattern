<%@ page language="java" import="com.cnpc.jcdp.common.UserToken,com.cnpc.jcdp.webapp.util.OMSMVCUtil"
    contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>检波器设备类型树</title>
<link rel="stylesheet" href="<%=contextPath%>/js/extjs/resources/css/ext-all.css">
<link rel="stylesheet" href="<%=contextPath%>/js/extjs/resources/css/column-tree.css">
</head>
<body>
	<script>var _path='<%=contextPath%>'</script>
	<script src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
	<script src="<%=contextPath%>/js/extjs/ext-all-debug.js"></script>
	<script src="<%=contextPath%>/js/extjs/ext-lang-zh_CN.js"></script>
	<script src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script src="<%=contextPath%>/js/extjs/ColumnNodeUI.js"></script>
	<script src="collectJBQTreeManager.js"></script>
</body>
</html>