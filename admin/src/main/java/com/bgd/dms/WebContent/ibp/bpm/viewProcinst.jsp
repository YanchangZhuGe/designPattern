<%@page contentType="text/html;charset=GBK"%>
<html>
<head>
<%
	String contextPath = request.getContextPath();
	String procinstId = request.getParameter("procinstId");
	System.out.println(procinstId);
%>
<title>Insert title here</title>
<script language="javascript" type="text/javascript">
     function hrefHtmlPage(){
         window.location.href="<%=contextPath%>/BPM/viewProcinst.jsp?procinstId=<%=procinstId%>";
     }
</script>
</head>
<body onload="hrefHtmlPage()">
</body>
</html>