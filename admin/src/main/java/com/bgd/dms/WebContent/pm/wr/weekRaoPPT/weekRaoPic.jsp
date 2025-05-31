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
<%@ taglib uri="/WEB-INF/runqianReport.tld" prefix="report"%>
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
	JFreeChart chart =(JFreeChart)request.getAttribute("chart");
	String chartname = request.getParameter("chartname");

	
	ChartRenderingInfo info = new ChartRenderingInfo(new StandardEntityCollection());
	
	String fileName = "";
	String graphURL = "";
	
	if(chart != null){
		fileName = ServletUtilities.saveChartAsPNG(chart, 1000, 650, info, request.getSession());
		graphURL = request.getContextPath() + "/servlet/DisplayChart?filename=" + fileName;
	}


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
<script type="text/javascript">

function getgraphURL(){
	document.form1.action="<%=contextPath%>/pm/wr/getCompanyProductionInfo.srq";
	document.form1.submit();
}

function jsSelectIsExitItem(objSelect, objItemValue) {        
    var isExit = false;        
    for (var i = 0; i < objSelect.options.length; i++) {        
        if (objSelect.options[i].value == objItemValue) {        
            isExit = true;        
            break;        
        }        
    }        
    return isExit;        
}   

</script>
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
	width: 80%;
}
</style>
<title><%=(chartname != null && !"".equals(chartname)?chartname:"")%></title>
</head>
<body  style="background-color:#EBEBEB">
<table cellpadding="0" cellspacing="0" class="rtab_infos"
	id="FilterLayer">
	<tr>
	<td colspan="3" class="" align="left">
		<table>
			<tr align="left"><td>
				<img src="<%=graphURL%>" width=1000 height=500 border=0 usemap="#map0"></td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</body>
</html>
