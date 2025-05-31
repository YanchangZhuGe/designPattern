<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.mcs.service.pm.service.dailyReport.DailyReportSrv"%>
<%@page import="com.bgp.mcs.service.qua.service.QualityUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	
	String projectType = user.getProjectType();//项目类型
	   DailyReportSrv drs = new DailyReportSrv();
		String build_method = drs.getBuildMethod(projectInfoNo);
	//projectType="5000100004000000006";//测试
	
	if("5000100004000000006".equals(projectType)){
		//深海项目
		response.sendRedirect(contextPath+"/pm/dailyReport/singleProject/sh/reportList.jsp");
	}
	
	//判断是否为综合物化探 
	 
	if( user.getProjectType().equals("5000100004000000009")){

		response.sendRedirect(contextPath+"/pm/dailyReport/singleProject/wt/wtReportListDrill.jsp");

	}
	//end
	
		//判断是否为井中
	 
	if( user.getProjectType().equals("5000100004000000008")){

		response.sendRedirect(contextPath+"/pm/dailyReport/singleProject/ws/wsReportListDrill.jsp");

	}
	
	//String projectType = user.getProjectType();
	String project_subjection_id = QualityUtil.getProjectSubjectionId(projectInfoNo);
	if(project_subjection_id!=null && project_subjection_id.trim().startsWith("C105007")){//大港物探处
		if("5000100003000000001".equals(build_method) || "5000100003000000004".equals(build_method) || "5000100003000000005".equals(build_method) || "5000100003000000007".equals(build_method)){
			request.getRequestDispatcher("tqh/reportListDrill.jsp").forward(request,response);
			System.out.print("1");
		}else{
			System.out.print("2");
		 	request.getRequestDispatcher("tqh/reportList.jsp").forward(request,response);
	//response.sendRedirect(contextPath+"/pm/dailyReport/singleProject/tqh/reportListDrill.jsp");
		}
		return;
	}
	//end
	//陆地
   if(projectType.equals("5000100004000000001")||project_subjection_id!=null && project_subjection_id.trim().startsWith("C105007")){

		
		if("5000100003000000001".equals(build_method) || "5000100003000000004".equals(build_method) || "5000100003000000005".equals(build_method) || "5000100003000000007".equals(build_method)){
			request.getRequestDispatcher("reportListDrill.jsp").forward(request,response);
		}else{
		 	request.getRequestDispatcher("reportList.jsp").forward(request,response);
	}
   }
	//end
	

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
</body>
