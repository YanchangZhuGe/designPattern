<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();

	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新建项目</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
</head>
<body >
<form name="form" id="form"  method="post" action="" >
	<%if(JcdpMVCUtil.hasPermission("F_HSE_HOUR_001", request)){ 
		System.out.println("111111111111111");
	%>
		<iframe src="<%=contextPath %>/hse/objAndTarget/hseWorkHour/workHour_secondOrg.jsp" width="100%" id="second" height=""></iframe>
	<%}else if(JcdpMVCUtil.hasPermission("F_HSE_HOUR_002", request)){
		
		System.out.println("222222222222222");%>
		<iframe src="<%=contextPath %>/hse/objAndTarget/hseWorkHour/workHour_thirdOrg2.jsp" width="100%" id="second" height=""></iframe>
	<%}else if(JcdpMVCUtil.hasPermission("F_HSE_HOUR_003", request)){
		System.out.println("33333333333333333");%>
		<iframe src="<%=contextPath %>/hse/objAndTarget/hseWorkHour/workHour_autoOrg.jsp" width="100%" id="second" height=""></iframe>
	<%} %>
	
</form>
</body>

<script type="text/javascript">
$("#second").css("height",$(window).height()-5);
$("#second").css("height",$(window).height()-5);

</script>
</html>