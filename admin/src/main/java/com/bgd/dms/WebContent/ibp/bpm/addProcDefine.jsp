<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page contentType="text/html;charset=GBK"%>
<html>
<head>
<%
	String contextPath = request.getContextPath();
	UserToken user=(UserToken)request.getSession(true).getAttribute("SYS_USER_TOKEN_ID");
	String userId = user.getUserId();
	String userName = user.getUserName();// 组织机构隶属ID，用户数据过滤
%>
<title>Insert title here</title>
<script language="javascript" type="text/javascript">
     function hrefHtmlPage(){
          window.location.href="<%=contextPath%>/BPM/addProcDefine.jsp?userName=<%=userName%>&userId=<%=userId%>";
     }
</script>
</head>
<body onload="hrefHtmlPage()">
</body>
</html>