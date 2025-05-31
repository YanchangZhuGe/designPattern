<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%> 
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%> 
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>  
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%> 
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo=user.getProjectInfoNo();
	String orgSubjectionId=user.getSubOrgIDofAffordOrg();
 
	String reportFileName = request.getParameter("reportId").toString();
	String title = reportFileName; 
	reportFileName="/mat/"+reportFileName;
	SimpleDateFormat format =new SimpleDateFormat("yyyy-MM-dd"); 
	String curDate = format.format(new Date());  
	
	String startTime=curDate.substring(0,4)+"-01-01";
	String endDate=curDate;
	
	String pInfoNo = request.getParameter("pInfoNo"); 
	if(pInfoNo!=null ){ 
		projectInfoNo =pInfoNo;   
	}
	String start_time = request.getParameter("start_date");  
	if(start_time!=null  &&  !"null".equals(start_time)){ 
		startTime =start_time;   
	}
	
	String end_date = request.getParameter("end_date"); 
	if(end_date!=null  &&  !"null".equals(end_date) ){ 
		endDate =end_date;   
	}
	
	String rptParams = request.getParameter("rptParams"); 
	if(rptParams==null ){
		  rptParams ="startDate="+startTime+";projectInfoNo="+projectInfoNo+";endDate="+endDate;
	}
	
	%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
 <title></title>
 <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json2.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<script type="text/javascript">
 
function simpleSearch(){
	var start_date = document.getElementById("start_time").value;
	var end_date = document.getElementById("end_time").value;
 
	window.location.href='<%=contextPath%>/mat/multiproject/common/forwardXHReportNew.jsp?reportId=<%=title%>&start_date='+start_date+'&end_date='+end_date+'&pInfoNo=<%=projectInfoNo%>'; 
 	
}
</script>
  </head>
  <body >
  <div id="inq_tool_box">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" id="FilterLayer">
		<tr>
			<td width="6"><img src="<%=contextPath%>/images/list_13.png"
				width="6" height="36" /></td>
			<td background="<%=contextPath%>/images/list_15.png">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td style="width:80px;"  >开始时间：</td>
			 	    <td  style="width:180px;" ><input class="input_width" id="start_time" name="start_time" type="text" />
			  
			 	    <img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(start_time,tributton1);" />
			 	    </td>
			 	    <td style="width:80px;" >结束时间：</td>
			 	    <td style="width:180px;" ><input class="input_width" id="end_time" name="end_time" type="text" />
			 	 
			 	    <img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(end_time,tributton2);" />
			 	    </td>
			 	    <auth:ListButton functionId="" css="cx" event="onclick='simpleSearch()'" title="JCDP_btn_query"></auth:ListButton>
			 	    <td>&nbsp;</td>
				</tr>
			</table>
			</td>
			<td width="4"><img src="<%=contextPath%>/images/list_17.png"
				width="4" height="36" /></td>
		</tr>
	</table>
</div>
 <div id="table_box"  style="height:610px;" >
<table id=rpt border="0" cellpadding="0" cellspacing="0" class="ali6">
	<tr>
		<td>
			<!-- width="-1" height="-1" needScroll="no" scrollWidth="100%" scrollHeight="100%" scrollBorder="border:1px solid red" needSaveAsExcel="yes" excelPageStyle="1"-->
			<report:html name="report1"
			reportFileName="<%=reportFileName %>"
			params="<%=rptParams%>"
			width="-1" 
			height="-1"
			needScroll="no"
			needSaveAsExcel="yes"
			saveAsName="<%=title%>" excelPageStyle="0"/>
		</td>
	</tr>
</table>
</div>
 </body>
 
</html>
