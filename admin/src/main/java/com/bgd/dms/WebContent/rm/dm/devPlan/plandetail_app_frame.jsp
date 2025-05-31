<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = "8a9588b63618fc0d01361a93e0bf0018";
	String wbsObjectId = request.getParameter("wbsObjectId");
	String projectObjectId = request.getParameter("projectObjectId");

	String wbsBackUrl = "/rm/dm/devPlan/wbsPlanList.jsp";
	String taskBackUrl = "/rm/dm/devPlan/taskPlanList.jsp";
	String rootBackUrl = "/rm/dm/devPlan/rootPlanList.jsp";
%>

<frameset cols="300,*" frameborder="yes" border="0" framespacing="1">
  <frame src="<%=contextPath %>/rm/dm/tree/selectDeviceTree.jsp?projectInfoNo=<%=projectInfoNo %>&wbsBackUrl=<%=wbsBackUrl%>&taskBackUrl=<%=taskBackUrl%>&rootBackUrl=<%=rootBackUrl%>" name="mainTopframe" frameborder="no" scrolling="no"  noresize="noresize"  id="mainTopframe"/>
  <frame src="<%=contextPath %>/rm/dm/devPlan/rootPlanList.jsp?projectInfoNo=<%=projectInfoNo%>" name="mainRightframe" frameborder="no" scrolling="auto" noresize="noresize" id="mainRightframe"/>
</frameset>
