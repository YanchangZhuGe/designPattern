<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%
	String contextPath = request.getContextPath();
//	String projectInfoNo = request.getParameter("projectInfoNo");
	UserToken user = OMSMVCUtil.getUserToken(request);	
	String projectInfoNo = user.getProjectInfoNo();

	String wbsObjectId = request.getParameter("wbsObjectId"); 
	String projectObjectId = request.getParameter("projectObjectId");
	
	String customKey="laborCategory";
	String customValue= request.getParameter("laborCategory");

//	String startDate = request.getParameter("startDate");
//	String endDate = request.getParameter("endDate");
//	String wbsBackUrl = request.getParameter("wbsBackUrl");
//	String taskBackUrl = request.getParameter("taskBackUrl");

String wbsBackUrl = "/rm/em/singleHuman/humanLedger/wbsPlanLaborList.jsp";
String taskBackUrl = "/rm/em/singleHuman/humanLedger/taskPlanLaborList.jsp";
String rootBackUrl = "/rm/em/singleHuman/humanLedger/rootPlanLaborList.jsp";
	
%>

<frameset cols="300,*" frameborder="yes" border="0" framespacing="0">
  <frame src="<%=contextPath %>/p6/tree/tree_rl.jsp?projectInfoNo=<%=projectInfoNo %>&wbsBackUrl=<%=wbsBackUrl%>&taskBackUrl=<%=taskBackUrl%>&rootBackUrl=<%=rootBackUrl%>&customKey=<%=customKey%>&customValue=<%=customValue%>" name="mainTopframe" frameborder="no" scrolling="no"  style="border-right: 2px solid #5796DD; cursor: w-resize;"  id="mainTopframe"/>
  <frame src="" name="mainRightframe" frameborder="no" scrolling="auto" style="border-left: 2px solid #5796DD; cursor: w-resize;" id="mainRightframe"/>
</frameset>
