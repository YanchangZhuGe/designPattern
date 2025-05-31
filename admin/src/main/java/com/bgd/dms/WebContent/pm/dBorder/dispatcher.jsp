<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String c_type = request.getParameter("c_type");
	String proType = user.getProjectType();
	if("5000100004000000006".equals(proType)){
		request.getRequestDispatcher("shedit.jsp").forward(request,response);
	}else{
		request.getRequestDispatcher("edit.jsp?c_type="+c_type).forward(request,response);
	}
%>