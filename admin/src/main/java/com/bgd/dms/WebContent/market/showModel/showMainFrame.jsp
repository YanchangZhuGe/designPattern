<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%
	String contextPath = request.getContextPath();
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="<%=contextPath%>/images/ma/style.css" rel="stylesheet" type="text/css" />
<title>市场信息平台</title>
</head>
<frameset rows="150,*" cols="*" frameborder="no" border="0" framespacing="0" >
  <frame src="showMainFrameTop.jsp" name="topFrame" frameborder="no" scrolling="yes" noresize="noresize" id="topFrame" title="" />
  <frame src="<%=contextPath%>/market/show/showHomePage.srq" name="mainFrame" 	 frameborder="no" scrolling="yes"   noresize="noresize" id="mainFrame" title="" />
</frameset>
<body>
</body>
</html>