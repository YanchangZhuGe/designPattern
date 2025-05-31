<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
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
	
	String projectType = user.getProjectType();//项目类型
	//<option value='5000100004000000008'>井中项目</option>
	//<option value='5000100004000000001'>陆地项目</option>
	//<option value='5000100004000000007'>陆地和浅海项目</option>
	//<option value='5000100004000000009'>综合物化探</option>
	//<option value='5000100004000000010'>滩浅海地震</option>
	//<option value='5000100004000000005'>地震项目</option>
	//<option value='5000100004000000002'>浅海项目</option>
	//<option value='5000100004000000003'>非地震项目</option>
	//<option value='5000100004000000006'>深海项目</option>
	//5000100004000000002 浅海项目
	//5000100004000000010 滩浅海过渡带项目	
	
	String org_subjection_id = QualityUtil.getProjectSubjectionId(projectInfoNo);
	
	if(org_subjection_id !=null && org_subjection_id.startsWith("C105007")){
		//5000100004000000002 浅海项目
		//5000100004000000010 滩浅海过渡带项目
		//request.getRequestDispatcher("/pm/project/singleProject/qtqmethodmodify.jsp").forward(request,response);
		response.sendRedirect(contextPath+"/pm/project/singleProject/qtqmethodmodify.jsp?edit="+action+"&projectInfoNo="+projectInfoNo+"&buildmethod="+buildMethod);
	}else if("5000100004000000008".equals(projectType)){
		//井中项目   设计井中施工方法 实际井中施工方法
		//request.getRequestDispatcher("/ws/pm/plan/singlePlan/projectSchedule/wellmethodSelect.jsp").forward(request,response);
		//response.sendRedirect(contextPath+"/ws/pm/plan/singlePlan/projectSchedule/wellmethodSelect.jsp"); 
		response.sendRedirect(contextPath+"/ws/pm/plan/singlePlan/projectSchedule/wellmethod.jsp");
	}else if("5000100004000000009".equals(projectType)){
		//综合物化探
		//request.getRequestDispatcher("/wt/tm/parameter/technicalParameter.jsp").forward(request,response);
		response.sendRedirect(contextPath+"/wt/tm/parameter/technicalParameter.jsp");
	}else if("5000100004000000006".equals(projectType)){
		//深海项目
		request.getRequestDispatcher("sh/tdwa2dmethodmodify.jsp?edit="+action+"&projectInfoNo="+projectInfoNo+"&buildmethod="+buildMethod).forward(request,response);
	}else{
		//原陆地项目代码	
		if("0300100012000000002".equals(workmethod)){
			request.getRequestDispatcher("tdwa2dmethodmodify.jsp?edit="+action+"&projectInfoNo="+projectInfoNo+"&buildmethod="+buildMethod).forward(request,response);
			//request.getRequestDispatcher("2dEdit.jsp?edit="+action+"&projectInfoNo="+projectInfoNo+"&buildmethod="+buildMethod).forward(request,response);
		}else{
			request.getRequestDispatcher("tdwa3dmethodmodify.jsp?edit="+action+"projectInfoNo="+projectInfoNo+"&buildmethod="+buildMethod).forward(request,response);
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
