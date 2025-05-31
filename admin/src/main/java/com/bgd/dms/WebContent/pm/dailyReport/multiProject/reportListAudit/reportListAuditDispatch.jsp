<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.mcs.service.pm.service.dailyReport.DailyReportSrv"%>
<%@page import="com.bgp.mcs.service.qua.service.QualityUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("project_info_no") != null ? request.getParameter("project_info_no"):"";
	
	DailyReportSrv drs = new DailyReportSrv();
	String build_method = drs.getBuildMethod(projectInfoNo);
	
	if("5000100003000000001".equals(build_method) || "5000100003000000004".equals(build_method) || "5000100003000000005".equals(build_method) || "5000100003000000007".equals(build_method)){
		request.getRequestDispatcher("reportListAuditDrill.jsp").forward(request,response);
	}else{
		request.getRequestDispatcher("reportListAudit.jsp").forward(request,response);
	}


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
</body>
