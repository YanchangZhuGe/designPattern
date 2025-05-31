<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page language="java" import="com.richfit.bi.portal.token.MadeToken" contentType="text/html; charset=utf-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<body>
<%
String tokenId= MadeToken.madeTokenId("admin", "admin");
String url = "http://10.88.17.204:8060/debug/dynamic/rpt/showReport?reportId=OPCC1&tokenId="+tokenId;
%>
<a href="<%=url%>">测试单点登录中油瑞飞商业智能软件BI报表系统</a>
</body>
</html>

