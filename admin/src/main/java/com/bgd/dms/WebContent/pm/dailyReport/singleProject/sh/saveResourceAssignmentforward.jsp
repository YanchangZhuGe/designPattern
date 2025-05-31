<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	String taskObjectId = request.getParameter("objectId");
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	if (taskObjectId == null || "".equals(taskObjectId)) {
		taskObjectId = respMsg.getValue("objectId");
	}
	
	String projectInfoNo = request.getParameter("projectInfoNo");
	if (projectInfoNo == null || "".equals(projectInfoNo)) {
		projectInfoNo = respMsg.getValue("projectInfoNo");
	}
	
	String produceDate = request.getParameter("produceDate");
	if (produceDate == null || "".equals(produceDate)) {
		produceDate = respMsg.getValue("produceDate");
	}
	
	String edit_flag = request.getParameter("edit_flag");
	if (edit_flag == null || "".equals(edit_flag)) {
		edit_flag = respMsg.getValue("edit_flag");
	}
%>
<html>
<head>
</head>

<script type="text/javascript">
location.href="<%=contextPath %>/pm/dailyReport/queryResourceAssignmentSh.srq?projectInfoNo=<%=projectInfoNo %>&produceDate=<%=produceDate %>&taskObjectId=<%=taskObjectId %>&edit_flag=<%=edit_flag %>";
</script>
<body>
</body>
</html>