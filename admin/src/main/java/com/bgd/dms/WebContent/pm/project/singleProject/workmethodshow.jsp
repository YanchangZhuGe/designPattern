<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.mcs.service.pm.service.project.WorkMethodSrv"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo == null || "".equals(projectInfoNo)){
		projectInfoNo = user.getProjectInfoNo();
	}
	String action = request.getParameter("action");
	if(action == null || "".equals(action)){
		action = "edit";
	}
	
	WorkMethodSrv wm = new WorkMethodSrv();
	String	workmethod = wm.getProjectWorkMethod(projectInfoNo);
	String 	buildMethod = wm.getProjectExcitationMode(projectInfoNo);
	
	if("0300100012000000002".equals(workmethod)){
		request.getRequestDispatcher("wa2dmethodshow.jsp?edit="+action+"&projectInfoNo="+projectInfoNo+"&buildmethod="+buildMethod).forward(request,response);
		//request.getRequestDispatcher("2dEdit.jsp?edit="+action+"&projectInfoNo="+projectInfoNo+"&buildmethod="+buildMethod).forward(request,response);
	}else{
		request.getRequestDispatcher("wa3dmethodshow.jsp?edit="+action+"&projectInfoNo="+projectInfoNo+"&buildmethod="+buildMethod).forward(request,response);
		//request.getRequestDispatcher("3dEdit.jsp?edit="+action+"projectInfoNo="+projectInfoNo+"&buildmethod="+buildMethod).forward(request,response);
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
</body>
