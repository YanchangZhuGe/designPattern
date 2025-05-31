<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.mcs.service.pm.service.project.WorkMethodSrv"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	
	WorkMethodSrv wm = new WorkMethodSrv();
	String	workmethod = wm.getProjectWorkMethod(projectInfoNo);
	String projectType = user.getProjectType();
	if("0300100012000000002".equals(workmethod)){
		if("5000100004000000006".equals(projectType)){//深海项目报备单独处理 新加 shEdit.jsp -- add by bianshen
			request.getRequestDispatcher("sh2dEdit.jsp").forward(request,response);
		}else{
			request.getRequestDispatcher("2dEdit.jsp").forward(request,response);
		}
	}else{
		if("5000100004000000006".equals(projectType)){//深海项目报备单独处理 新加 shEdit.jsp -- add by bianshen
			request.getRequestDispatcher("sh3dEdit.jsp").forward(request,response);
		}else{
			request.getRequestDispatcher("3dEdit.jsp").forward(request,response);
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
</body>
