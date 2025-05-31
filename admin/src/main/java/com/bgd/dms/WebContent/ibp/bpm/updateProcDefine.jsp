<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page contentType="text/html;charset=GBK"%>
<html>
<head>
<%
	String contextPath = request.getContextPath();
	//UserToken user = OMSMVCUtil.getUserToken(request);
	UserToken user=(UserToken)request.getSession(true).getAttribute("SYS_USER_TOKEN_ID");
	String userId = user.getUserId();
	String userName = user.getUserName();// 组织机构隶属ID，用户数据过滤
	String procId = request.getParameter("procId");
	String procEName = request.getParameter("procEName");
	String procVersion = request.getParameter("procVersion");
%>
<title>Insert title here</title>
<script language="javascript" type="text/javascript">
     function hrefHtmlPage(){
         window.location.href="<%=contextPath%>/BPM/updateProcDefine.jsp?userName=<%=userName%>&userId=<%=userId%>&procId=<%=procId%>&procEName=<%=procEName%>&procVersion=<%=procVersion%>"; 
     }
</script>
</head>
<body onload="hrefHtmlPage()">
</body>
</html>