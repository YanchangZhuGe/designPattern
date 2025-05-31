<%@page contentType="text/html;charset=GBK"%>
<html>
<head>
<%
	String contextPath = request.getContextPath();
	String procId = request.getParameter("procId");
	String procEName = request.getParameter("procEName");
	String procVersion = request.getParameter("procVersion");
%>
<title>Insert title here</title>
<script language="javascript" type="text/javascript">
     function hrefHtmlPage(){
         window.location.href="<%=contextPath%>/BPM/viewProcDefine.jsp?procId=<%=procId%>&procEName=<%=procEName%>&procVersion=<%=procVersion%>"; 
     }
</script>
</head>
<body onload="hrefHtmlPage()">
</body>
</html>