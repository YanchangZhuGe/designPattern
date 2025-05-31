<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%
	//JcdpMVCUtil.clearSession(request); 
	JcdpMVCUtil.clearSession(request);
	response.sendRedirect(request.getContextPath());

%>