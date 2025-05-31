<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="code" prefix="code"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.cfg.BeanFactory" %>
<%@ page import="com.cnpc.jcdp.dao.IJdbcDao" %>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);

	String projectInfoNo = request.getParameter("projectInfoNo");
	if (projectInfoNo==null||projectInfoNo.equals("null")) {//年度项目
		response.sendRedirect(contextPath + "/pm/project/singleProject/ws/projectList.jsp");
	}else{
		String projectType = request.getParameter("projectType");
		String orgSubjectionId = user.getOrgSubjectionId();
		String orgId = user.getOrgId();
		String sql = "select project_father_no from gp_task_project where project_info_no = '"+projectInfoNo+"'";
		IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
		Map orgMap = jdbcDao.queryRecordBySQL(sql);
		String project_father_no  = orgMap.get("projectFatherNo").toString();//判断是年度项目还是子项目
		if (project_father_no==null||project_father_no.length()==0) {//年度项目
			response.sendRedirect(contextPath + "/pm/project/singleProject/ws/projectList.jsp");
		}else{
			response.sendRedirect(contextPath + "/pm/project/singleProject/ws/subProjectList.jsp?isSingle=true");
		}
	}

%>
<html>
<head>
</head>
<body>
</body>
</html>