<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String wbsObjectId = request.getParameter("wbsObjectId");
	String projectObjectId = request.getParameter("projectObjectId");
	String wbsBackUrl = request.getParameter("wbsBackUrl");
	String taskBackUrl = request.getParameter("taskBackUrl");
	String rootBackUrl = request.getParameter("rootBackUrl");
	
	String customKey = request.getParameter("customKey");
	String customValue = request.getParameter("customValue");
	
	String checked = request.getParameter("checked");
	
	String wbsOnly = request.getParameter("wbsOnly");
	Object expMethods = request.getParameter("explorationMethod");
	
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
	if (rootBackUrl == null || "".equals(rootBackUrl)) {
		rootBackUrl = respMsg.getValue("rootBackUrl");
	}
	if (checked == null || "".equals(checked)) {
		checked = respMsg.getValue("checked");
	}
	
	if (wbsOnly == null || "".equals(wbsOnly)) {
		wbsOnly = respMsg.getValue("wbsOnly");
	}
	
	if (customKey == null || "".equals(customKey)) {
		customKey = respMsg.getValue("customKey");
	}
	if (customValue == null || "".equals(customValue)) {
		customValue = respMsg.getValue("customValue");
	}
	if (expMethods == null || "".equals(expMethods)) {
		expMethods = respMsg.getValue("projectMethods");
	}
	
%>

<frameset rows="*" cols="300,*" frameborder="no" border="0" framespacing="0">
  <frame src="<%=contextPath %>/p6/tree/tree.jsp?checked=<%=checked %>&wbsObjectId=<%=wbsObjectId %>&projectObjectId=<%=projectObjectId %>&projectInfoNo=<%=projectInfoNo %>&wbsBackUrl=<%=wbsBackUrl %>&taskBackUrl=<%=taskBackUrl %>&rootBackUrl=<%=rootBackUrl %>&wbsOnly=<%=wbsOnly %>&customKey=<%=customKey %>&customValue=<%=customValue %>&explorationMethod=<%=expMethods %>" name="mainLeftframe" frameborder="no" scrolling="auto" id="mainLeftframe" style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
  <frame src="" name="mainRightframe" frameborder="no" scrolling="auto" id="mainRightframe" style="border-left: 2px solid #5796DD; cursor: w-resize;"/>
</frameset>
