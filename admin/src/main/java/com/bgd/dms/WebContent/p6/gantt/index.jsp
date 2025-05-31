<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String wbsObjectId = request.getParameter("wbsObjectId");
	String projectObjectId = request.getParameter("projectObjectId");
	String startDate = request.getParameter("startDate");
	String endDate = request.getParameter("endDate");
	String wbsBackUrl = request.getParameter("wbsBackUrl");
	String taskBackUrl = request.getParameter("taskBackUrl");
	
	String customKey = request.getParameter("customKey");
	String customValue = request.getParameter("customValue");
	
	String epsObjectId = request.getParameter("epsObjectId");
	
	String showBaseline = request.getParameter("showBaseline");
	String targetProjectObjectId = request.getParameter("targetProjectObjectId");
	String targetWbsObjectId = request.getParameter("targetWbsObjectId");
	
	String url = "advanced";
	
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	if (projectInfoNo == null || "".equals(projectInfoNo)) {
		projectInfoNo = respMsg.getValue("projectInfoNo");
	}
	if (projectInfoNo == null || "".equals(projectInfoNo)) {
		if (wbsObjectId == null || "".equals(wbsObjectId)) {
			wbsObjectId = respMsg.getValue("wbsObjectId");
		}
		if (projectObjectId == null || "".equals(projectObjectId)) {
			projectObjectId = respMsg.getValue("projectObjectId");
		}
	}
	if (wbsBackUrl == null || "".equals(wbsBackUrl)) {
		wbsBackUrl = respMsg.getValue("wbsBackUrl");
	}
	if (taskBackUrl == null || "".equals(taskBackUrl)) {
		taskBackUrl = respMsg.getValue("taskBackUrl");
	}
	if (startDate == null || "".equals(startDate)) {
		startDate = respMsg.getValue("startDate");
	}
	if (endDate == null || "".equals(endDate)) {
		endDate = respMsg.getValue("endDate");
	}
	
	if (customKey == null || "".equals(customKey)) {
		customKey = respMsg.getValue("customKey");
	}
	if (customValue == null || "".equals(customValue)) {
		customValue = respMsg.getValue("customValue");
	}
	
	if (showBaseline == null || "".equals(showBaseline)) {
		showBaseline = respMsg.getValue("showBaseline");
	}
	if (targetProjectObjectId == null || "".equals(targetProjectObjectId)) {
		targetProjectObjectId = respMsg.getValue("targetProjectObjectId");
	}
	if (targetWbsObjectId == null || "".equals(targetWbsObjectId)) {
		targetWbsObjectId = respMsg.getValue("targetWbsObjectId");
	}
	
	if (epsObjectId == null || "".equals(epsObjectId)) {
		epsObjectId = respMsg.getValue("epsObjectId");
	}
	
	if (showBaseline == "true" || "true".equals(showBaseline)) {
		url = "advancedWithBaseline";
	}
	
%>

<frameset rows="350,*" cols="*" frameborder="no" border="0" framespacing="0">
  <frame src="<%=contextPath %>/p6/gantt/<%=url %>.jsp?epsObjectId=<%=epsObjectId %>&wbsObjectId=<%=wbsObjectId %>&projectObjectId=<%=projectObjectId %>&projectInfoNo=<%=projectInfoNo %>&startDate=<%=startDate %>&endDate=<%=endDate %>&wbsBackUrl=<%=wbsBackUrl %>&taskBackUrl=<%=taskBackUrl %>&targetProjectObjectId=<%=targetProjectObjectId %>&targetWbsObjectId=<%=targetWbsObjectId %>&customKey=<%=customKey %>&customValue=<%=customValue %>" name="mainTopframe" frameborder="no" scrolling="auto"  id="mainTopframe" style="border-buttom: 2px solid #5796DD;cursor: s-resize;"/>
  <frame src="<%=contextPath %>/p6/projectTask/activityInfoEmpty.jsp" name="mainDownframe" frameborder="no" scrolling="auto"  id="mainDownframe" style="border-top: 2px solid #5796DD; cursor: s-resize;"/>
</frameset>
