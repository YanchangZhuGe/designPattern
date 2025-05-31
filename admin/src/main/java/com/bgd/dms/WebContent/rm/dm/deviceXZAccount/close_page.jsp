<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%
	String contextPath = request.getContextPath();
ISrvMsg msg = OMSMVCUtil.getResponseMsg(request);
String mixId = msg.getValue("device_mixInfo_id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<script language="javaScript">
refreshData();
if(confirm('调剂单已生成、是否查看？')){  
	window.location.href="<%=contextPath%>/rm/dm/devmixTJForm/devMixForxztjInfo.jsp?mixId=<%=mixId%>";
	}
else
	{
	newClose();
	}
	
</script>
</head>
<body>
	<!-- <input type="button" value="close" onclick="refreshData()"/> -->
</body>
