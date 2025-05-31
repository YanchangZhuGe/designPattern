<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script language="javaScript">
	//top.frames[1].frames('list').refreshData();
	//获取顶层页面下的iframe(id='indexFrame')
	var indexFrame=top.document.getElementById('indexFrame');
	//获取iframe(id='indexFrame')页面下的iframe(id='list')
	var list=indexFrame.contentWindow.document.getElementById('list');
	//调用刷新方法
	list.contentWindow.searchDevData();
	newClose();
</script>
</head>
<body>
</body>
