<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.mcs.service.pm.service.project.WorkMethodSrv"%>
<%@page import="com.bgp.mcs.service.qua.service.QualityUtil"%>
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
	
	//添加井中项目判断
	String sql = "select t.project_type from gp_task_project t where t.project_info_no='"+projectInfoNo+"'";
  	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
  	String projectType = null;
	if(list!=null&&list.size()!=0){
		Map map = (Map)list.get(0);
		projectType = (String)map.get("projectType");
	}
	String org_subjection_id = QualityUtil.getProjectSubjectionId(projectInfoNo);
	if(org_subjection_id!=null && org_subjection_id.startsWith("C105007")){//大港物探处
		request.getRequestDispatcher("/pm/project/singleProject/qtqmethodmodify.jsp?edit="+action+"projectInfoNo="+projectInfoNo+"&buildmethod="+buildMethod).forward(request,response);
	}else if("5000100004000000008".equals(projectType)){
		//井中项目 施工方法
		request.getRequestDispatcher("/ws/pm/plan/singlePlan/projectSchedule/wellmethod.jsp?projectInfoNo="+projectInfoNo+"&action=view").forward(request,response);
	}else{
		if("0300100012000000002".equals(workmethod)){
			request.getRequestDispatcher("wa2dmethodmodify.jsp?edit="+action+"&projectInfoNo="+projectInfoNo+"&buildmethod="+buildMethod).forward(request,response);
			//request.getRequestDispatcher("2dEdit.jsp?edit="+action+"&projectInfoNo="+projectInfoNo+"&buildmethod="+buildMethod).forward(request,response);
		}else{
			request.getRequestDispatcher("wa3dmethodmodify.jsp?edit="+action+"projectInfoNo="+projectInfoNo+"&buildmethod="+buildMethod).forward(request,response);
			//request.getRequestDispatcher("3dEdit.jsp?edit="+action+"projectInfoNo="+projectInfoNo+"&buildmethod="+buildMethod).forward(request,response);
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
