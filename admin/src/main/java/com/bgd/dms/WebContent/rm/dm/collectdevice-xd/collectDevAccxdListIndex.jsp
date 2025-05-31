<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubid = user.getSubOrgIDofAffordOrg();
	
	if(orgSubid.startsWith("C105007")){//大港物探处 	device_type 1 检波器 2 地震仪器
		request.getRequestDispatcher("/rm/dm/collectdevice-xd/collectDevAccxdList_dg.jsp")
				.forward(request, response);
	}else{
		request.getRequestDispatcher("/rm/dm/collectdevice-xd/collectDevAccxdList.jsp")
				.forward(request, response);
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
</body>
</html>