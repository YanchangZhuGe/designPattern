<%@ page contentType="text/html;charset=GBK"%>
<%@ page import="java.util.Map"%>
<%
String contextPath = request.getContextPath();
%>
<html>
<head>
<%
String examineinstID=request.getParameter("examineinstID");
 %>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<% 
out.print(examineinstID); 
 %>
<form action="<%=contextPath%>/wf/consignExamInst.srq" name="form" id="form">
<input type="hidden" name="examineinstID" id="examineinstID" value="<%=examineinstID %>">
ί���û��� <input name="userIDs" id="userIDs">
<input type="submit" value="ȷ��"> 

</form>
</body>
</html>