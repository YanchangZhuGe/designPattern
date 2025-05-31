<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	if (projectInfoNo == null || "".equals(projectInfoNo)) {
		projectInfoNo = respMsg.getValue("projectInfoNo");
	}
	
	String customKey = request.getParameter("customKey");
	if (customKey == null || "".equals(customKey)) {
		customKey = respMsg.getValue("customKey");
	}
	
	String customValue = request.getParameter("customValue");
	if (customValue == null || "".equals(customValue)) {
		customValue = respMsg.getValue("customValue");
	}
	
	String taskBackUrl = request.getParameter("taskBackUrl");
	if (taskBackUrl == null || "".equals(taskBackUrl)) {
		taskBackUrl = respMsg.getValue("taskBackUrl");
	}
%>
<html>
<head>
</head>

<script type="text/javascript">
location.href="<%=contextPath %>/p6/showTree.srq?projectInfoNo=<%=projectInfoNo %>&taskBackUrl=<%=taskBackUrl %>&customKey=<%=customKey %>&customValue=<%=customValue %>";
</script>
<body>
</body>
</html>