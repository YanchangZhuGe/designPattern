<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="wf" prefix="wf"%> 
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%> 
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="java.util.*"%>  
<%@ page import="java.text.*"%>
 

<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo=user.getProjectInfoNo();
	String reportId = request.getParameter("reportId").toString();
	String rptParams="";
	if (request.getParameter("option_type") != null){
		String option_type = request.getParameter("option_type").toString();
		String one_day = request.getParameter("one_day").toString();
		String sun_day = request.getParameter("sun_day").toString();
		rptParams ="option_type="+option_type+";one_day="+one_day+";sun_day="+sun_day;
	}
 
	%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>


</head>

<body >

<div id="list_content" >
<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
    <td background="<%=contextPath%>/images/list_15.png"> 
</td>
    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
  </tr>
</table>
</div>

	<div id="table_box"  style="height:510px;" >
		<table id=rpt border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
			<!-- width="-1" height="-1" needScroll="no" scrollWidth="100%" scrollHeight="100%" scrollBorder="border:1px solid red" needSaveAsExcel="yes" excelPageStyle="1"-->
			<report:html name="report1"
			reportFileName="<%=reportId%>"
			params="<%=rptParams%>"
			width="-1" 
			height="-1"
			needScroll="no"
			needSaveAsExcel="yes"
			saveAsName="<%=reportId%>" excelPageStyle="0"/>
				</td>
			</tr>
		</table>
	</div>
 </body>

</html>
