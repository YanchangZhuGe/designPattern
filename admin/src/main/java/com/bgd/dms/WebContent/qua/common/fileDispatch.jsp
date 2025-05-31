<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.mcs.service.qua.service.QualityUtil"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();

	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectType = user.getProjectType();
	String projectInfoNo = user.getProjectInfoNo();
	String isMulti = request.getParameter("isMulti"); //是否是多项目   0但项目；1多项目
	//String menuFalg = request.getParameter("menuFalg");  //菜单标识

	//判断是否是井中项目
		if("0".equals(isMulti)){
			if("5000100004000000008".equals(projectType)){
				request.getRequestDispatcher("/qua/wsProject/plan/control_plan.jsp").forward(request,response);
			}else{
				request.getRequestDispatcher("/qua/sProject/plan/qualityControl.jsp").forward(request,response);
			}
		}else if("1".equals(isMulti)){
				if("5000100004000000008".equals(projectType)){
					request.getRequestDispatcher("/qua/wsProject/plan/control_plans.jsp").forward(request,response);
				}else{
					request.getRequestDispatcher("/qua/mProject/plan/plan_menu.jsp").forward(request,response);
				}
		}
			//response.sendRedirect(contextPath+"/pm/dailyReport/multiProject/wt/wtReportList.jsp?projectType="+projectType);

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
</body>
</html>