<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String username=user.getLoginId();
	String userpwd=user.getUserPwd();
	String addr=request.getParameter("addr");
	if(username!=null && username.equals("superadmin"))username="df_manager";
	if(userpwd==null) userpwd="766C6BEDDE90663C";
	String url="http://10.2.46.73:9080/OMS_Web_GPE/common/transit.jsp?username="+username
			+"&userpwd="+userpwd+"&requestType=0&addr="+addr;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>loc.DMS.transit.jsp</title>
<script>
window.location.href="<%=url %>";
window.parent.focus();

</script>

</head>
<body>
系统跳转中...
</body>
</html>