<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK"%>
    
    <%
    String path=request.getContextPath();
    
     %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<form action="<%=path %>/wf/startProcInst.srq">
±êÌâ£º <input  name="proc_title" id="proc_title"><br>
ÐÅÏ¢£º <input  name="proc_info" id="proc_info"><br>
Á÷³ÌÄ£°åID£º <input  name="procId" id="procId"><br>
<input type="submit" value="Æô¶¯">
</form>
<br><br><br><br><br>
<a href="<%=path %>/wf/getExamineList.srq">´ýÉóÅúÁÐ±í ²âÊÔ</a><br>
<a href="<%=path %>/wf/loadproc.srq">¼ÓÔØÁ÷³Ì ²âÊÔ</a><br>
<a href="<%=path %>/wf/getStartProcInsts.srq">ÒÑ¾­·¢ÆðÁ÷³ÌÊµÀý ²âÊÔ</a><br>
</body>
</html>