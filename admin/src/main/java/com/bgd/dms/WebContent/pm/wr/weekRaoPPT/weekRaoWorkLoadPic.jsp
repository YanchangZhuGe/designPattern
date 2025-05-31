<%@ page import="com.cnpc.oms.webapp.gpe.team.authority.action.UserInfo"
	language="java" contentType="text/html; charset=GBK" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.SrvMsgUtil"%>
<%@page import="com.cnpc.oms.webapp.util.MVCConstants"%>
<%@page import="org.jfree.chart.servlet.ServletUtilities"%>
<%@page import="java.util.List"%>
<%@page import="org.jfree.chart.ChartUtilities"%>
<%@page import="org.jfree.chart.entity.StandardEntityCollection"%>
<%@page import="org.jfree.chart.JFreeChart"%>
<%@page import="org.jfree.chart.ChartRenderingInfo"%>
<%@ taglib uri="extremecomponents" prefix="ec"%>
<%@ taglib uri="oms" prefix="oms"%>
<html xmlns:v="urn:schemas-microsoft-com:vml">
<!-- include thre header file -->
<%@ include file="/common/jspHeader.jsp"%>
<head>
<%
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragrma", "no-cache");
	response.setDateHeader("Expires", 0);
	UserInfo userinfo = (UserInfo) session.getAttribute("user");
	String contextPath = request.getContextPath();
	ISrvMsg msg = (ISrvMsg) request.getAttribute(MVCConstants.RESPONSE_DTO);
	JFreeChart chartA =(JFreeChart)request.getAttribute("chartA");
	ChartRenderingInfo infoA = new ChartRenderingInfo(new StandardEntityCollection());
	String fileNameA = ServletUtilities.saveChartAsPNG(chartA, 1000, 300, infoA, request.getSession());
	String graphURLA = request.getContextPath() + "/servlet/DisplayChart?filename=" + fileNameA;
	
	JFreeChart chartB =(JFreeChart)request.getAttribute("chartB");
	ChartRenderingInfo infoB = new ChartRenderingInfo(new StandardEntityCollection());
	String fileNameB = ServletUtilities.saveChartAsPNG(chartB, 1000, 300, infoB, request.getSession());
	String graphURLB = request.getContextPath() + "/servlet/DisplayChart?filename=" + fileNameB;

%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
div#tipDiv {
	position: absolute;
	visibility: hidden;
	left: 0;
	top: 0;
	z-index: 10000;
	background-color: #ffffcc;
	border: 1px solid #336;
	width: 135px;
	padding: 4px;
	color: #000;
	font-size: 12px;
	line-height: 1.2;
	text-align: left;
}
</style>

<script language="JavaScript" type="text/JavaScript"
	src="<%=contextPath%>/js/DivHiddenOpen.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/check_radio.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/check_sps.js"></script>

<link href="<%=contextPath%>/styles/table.css" rel="stylesheet"
	type="text/css" />
<link rel="stylesheet"
	href="<%=contextPath%>/styles/extremecomponents.css" type="text/css">
<link rel="stylesheet" type="text/css" media="all"
	href="<%=contextPath%>/styles/calendar-blue.css" />
<style type="text/css">
.rtab_infos {
	FONT-SIZE: 12px;
	height:20px;
	BORDER-TOP: #89c6ef 1px solid;
	BORDER-LEFT: #89c6ef 1px solid;
	line-height: 20px;
	width: 100%;
}
</style>
<title>地震勘探工作量完成情况</title>
</head>
<body style="background-color:#EBEBEB">

<table border="0" cellpadding="0" cellspacing="0" class="rtab_infos"
	id="FilterLayer">
	<tr>
		<td colspan="3" class="" align="left">
		<table>
			<tr align="left">
				<img src="<%=graphURLA%>" width=1000 height=300 border=0
					usemap="#map0">
			</tr>
			<tr align="left">
				<img src="<%=graphURLB%>" width=1000 height=300 border=0
					usemap="#map0">
			</tr>
		</table>

		</td>

	</tr>
</table>
</body>
</html>
