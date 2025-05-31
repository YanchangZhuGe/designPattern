<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	
	String taskObjectId = request.getParameter("taskObjectId");
	if (taskObjectId == null || "".equals(taskObjectId)) {
		taskObjectId = respMsg.getValue("taskObjectId");
	}
	
	String taskName = request.getParameter("taskName");
	if (taskName == null || "".equals(taskName)) {
		taskName = respMsg.getValue("taskName");
	}
	
%>
<html>
<head>
</head>

<script type="text/javascript">

var taskName = '<%=taskName%>'
location.href="<%=contextPath %>/pm/workload/workloadList.jsp?taskObjectId=<%=taskObjectId %>&testTaskName="+encodeURI(taskName,'UTF-8')+"&foward=1";

</script>
<body>
</body>
</html>