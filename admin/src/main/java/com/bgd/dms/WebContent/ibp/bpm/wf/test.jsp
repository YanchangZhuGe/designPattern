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
���⣺ <input  name="proc_title" id="proc_title"><br>
��Ϣ�� <input  name="proc_info" id="proc_info"><br>
����ģ��ID�� <input  name="procId" id="procId"><br>
<input type="submit" value="����">
</form>
<br><br><br><br><br>
<a href="<%=path %>/wf/getExamineList.srq">�������б� ����</a><br>
<a href="<%=path %>/wf/loadproc.srq">�������� ����</a><br>
<a href="<%=path %>/wf/getStartProcInsts.srq">�Ѿ���������ʵ�� ����</a><br>
</body>
</html>