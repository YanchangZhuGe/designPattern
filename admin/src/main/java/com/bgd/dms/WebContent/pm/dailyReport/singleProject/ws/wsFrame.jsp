<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();

	UserToken user = OMSMVCUtil.getUserToken(request);	

	String projectInfoNo = user.getProjectInfoNo();
	String wbsObjectId = request.getParameter("wbsObjectId");
	String projectObjectId = request.getParameter("projectObjectId");
//	String startDate = request.getParameter("startDate");
//	String endDate = request.getParameter("endDate");
//	String wbsBackUrl = request.getParameter("wbsBackUrl");
//	String taskBackUrl = request.getParameter("taskBackUrl");

	String sqlP6 = "select t.* from bgp_p6_project t where  t.project_info_no = '"+projectInfoNo+"'";
 
String wbsBackUrl = "/pm/dailyReport/singleProject/ws/wsProjectReport.jsp";
String taskBackUrl = "/pm/dailyReport/singleProject/ws/wsProjectReport.jsp";
String rootBackUrl = "/pm/dailyReport/singleProject/ws/wsProjectReport.jsp";

	
%> 
 

<frameset cols="250,*" frameborder="yes" border="0" framespacing="0">
<frame src="<%=contextPath %>/p6/tree/tree.jsp?projectInfoNo=<%=projectInfoNo %>&wbsBackUrl=<%=wbsBackUrl%>&taskBackUrl=<%=taskBackUrl%>&rootBackUrl=<%=rootBackUrl%>" name="mainTopframe" frameborder="no" scrolling="no"  style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainTopframe"/>
<frame src="" name="mainRightframe" frameborder="no" scrolling="auto" style="border-left: 2px solid #5796DD; cursor: w-resize;" id="mainRightframe"/>
</frameset>

 

