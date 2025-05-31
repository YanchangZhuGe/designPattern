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
	
	String ifHeath = request.getParameter("ifHeath");
	if (ifHeath == null || "".equals(ifHeath)) {
		ifHeath = respMsg.getValue("ifHeath");
	}
	
	String url = "";
	if(ifHeath == "0" || "0".equals(ifHeath)){
		//不健康
		url = contextPath + "/pm/projectHealthInfo/detail.jsp?healthInfoId="+projectInfoNo+"&ifHeath=0&flag=0";
	} else {
		//健康
		url = contextPath + "/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=pDStat&noLogin=admin&tokenId=admin&projectInfoNo="+projectInfoNo;
	}
%>
<html>
<head>
</head>

<script type="text/javascript">
location.href="<%=url %>&projectInfoNo=<%=projectInfoNo %>";
</script>
<body>
</body>
</html>