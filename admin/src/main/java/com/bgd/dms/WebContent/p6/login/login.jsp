<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK"%>
<%@ page import="com.cnpc.jcdp.common.UserToken" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>P6初始化</title>
</head>
<body>
<%
	String p6Url = "http://10.88.2.244:7001/p6/action/login?username=admin&password=abcd1234&databaseId=1&languageCode=zh_CN&actionType=login";
%>
<form action="<%=p6Url%>" name="p6loginform" method="get">
</form>

<script type="text/javascript">
	document.getElementsByName("p6loginform")[0].submit();
</script>

</body>
</html>