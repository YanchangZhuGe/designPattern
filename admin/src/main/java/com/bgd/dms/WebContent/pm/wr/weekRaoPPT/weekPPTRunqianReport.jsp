<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date" %>
<%@ taglib uri="/WEB-INF/runqianReport.tld" prefix="report"%>
<html>
<%

UserToken user = OMSMVCUtil.getUserToken(request);
String org_subjection_id = user.getOrgSubjectionId();
String contextPath = request.getContextPath();

String rptParams= "";

String week_date = request.getParameter("week_date");
String reportFileName = request.getParameter("reportFileName");
String reportName = request.getParameter("reportName");
rptParams = "weekDate="+week_date+";"+"orgSubjectionId="+org_subjection_id+";";
if(rptParams != null && "".equals(rptParams)){
	rptParams += request.getParameter("rptParams");
}

%>
<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/js/DivHiddenOpen.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/validator.js"></script>
<link href="<%=contextPath%>/styles/table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/styles/calendar-blue.css"  />
<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/js/report.js"></script>
</head>

<title></title>
<body style="background-color:#EBEBEB">

<table id=rpt border="0" cellpadding="1" cellspacing="2" class="ali6">
  <tr>
    <td align="left">
	  <report:html name="<%=reportName%>"
	               reportFileName="<%=reportFileName%>"				  
				   saveAsName="<%=reportName%>"
				   params="<%=rptParams%>"
				   width="950"
				   height="-1"
				   funcBarLocation=""
				   excelPageStyle="0"				  
	  />
	</td>
  </tr>
</table>
</body>
</html>