<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%> 
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@ include file="/common/rptHeader.jsp" %>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>

<%
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	UserToken user = OMSMVCUtil.getUserToken(request);
	String str="project_info_id="+user.getProjectInfoNo();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>新建项目</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<title></title>
</head>

<body style="overflow-x: scroll;overflow-y: scroll;">
    <div  style="height: 400px">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="rtab_info">
	  <tr>
	    <td align="right">     
	      <a href="#" onClick="report1_saveAsWord();return false;"><%=wordImage%></a>
	      <a href="#" onClick="report1_saveAsExcel();return false;"><%=excelImage%></a>
	      <a href="#" onClick="report1_saveAsPdf();return false;"><%=pdfImage%></a>
	      <a href="#" onClick="report1_print();return false;"><%=printImage%></a>
	    </td>
	  </tr>
	</table>
	
	<table   align="center"  id="90" >
		<tr align="center" >
		    <td align="center" >
       <report:html name="report1"
			               reportFileName="/devicekkzywx_zy.raq"
						   params="<%=str%>"
						   scrollWidth="180%" scrollHeight="100%"
						width="-1" 
			height="-1"
			needScroll="no"
			needPageMark="no"	   
			saveAsName="可控震源维修"
			excelPageStyle="0"
			  />
			
			</td>
  	</tr>
	</table>
	</div>
</body>
</html>