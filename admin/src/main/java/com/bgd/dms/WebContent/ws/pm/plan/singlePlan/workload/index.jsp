<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	String projectInfoNo = request.getParameter("projectInfoNo");
	String projectName = request.getParameter("projectName");
	if(projectInfoNo == null || "".equals(projectInfoNo)){
		projectInfoNo = user.getProjectInfoNo();
	}
	
%>
<html>
<head>
</head>

<script type="text/javascript">
location.href="<%=contextPath %>/p6/showTree.srq?projectInfoNo=<%=projectInfoNo %>&checked=true&taskBackUrl=/ws/pm/plan/singlePlan/workload/workloadList.jsp";

</script>
<body>
</body>
</html>