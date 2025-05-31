<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
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
	
	//request.getRequestDispatcher("wa3dmethodmodify.jsp?edit="+action+"projectInfoNo="+projectInfoNo+"&buildmethod="+buildMethod).forward(request,response);
	
	request.getRequestDispatcher("tdwa2dmethodmodify.jsp?action=view&projectInfoNo="+projectInfoNo+"&buildmethod="+buildMethod).forward(request,response);

	
		//if("0300100012000000002".equals(workmethod)){
			//request.getRequestDispatcher("wa2dmethodmodify.jsp?edit="+action+"&projectInfoNo="+projectInfoNo+"&buildmethod="+buildMethod).forward(request,response);
		//}else{
			//request.getRequestDispatcher("wa3dmethodmodify.jsp?edit="+action+"projectInfoNo="+projectInfoNo+"&buildmethod="+buildMethod).forward(request,response);
		//}

%>

