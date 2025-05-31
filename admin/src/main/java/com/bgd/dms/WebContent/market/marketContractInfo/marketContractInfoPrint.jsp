<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/common/rptHeader.jsp" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="/WEB-INF/runqianReport.tld" prefix="report"%>
<%
String path = request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
			String orgId=user.getSubOrgIDofAffordOrg();//request.getParameter("orgId");
			String params = "contextPath="+path;
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=basePath%>">
		<title>市场合同签订情况统计表</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="description" content="This is my page">
		<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/js/DivHiddenOpen.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/check_radio.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/check_sps.js"></script>
		<link href="<%=contextPath%>/styles/ssmaintable.css" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" href="<%=contextPath%>/styles/extremecomponents.css" type="text/css">
		<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/styles/calendar-blue.css" />
		<link href="<%=contextPath%>/styles/sy.css" rel="stylesheet" type="text/css">
	</head>
	<body bgcolor="#F5F6F7">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="rtab_info" bgcolor="#F5F6F7">
  <tr>
  </tr>
</table>
		<table bgcolor="#F5F6F7">
			<tr bgcolor="#F5F6F7">
				<td align="left" bgcolor="#F5F6F7">
					<report:html 
				   name="report1"
				   savePrintSetup="yes"
	               reportFileName="mm/marketContractInfo.raq"
				   params="<%=params %>"
				   width="-1"
				   height="-1"
				   funcBarLocation=""
				   saveAsName="公司市场合同签订情况统计表"
				   excelPageStyle="0"
	 				/>
				</td>
			</tr>
		</table>
	</body>
</html>
