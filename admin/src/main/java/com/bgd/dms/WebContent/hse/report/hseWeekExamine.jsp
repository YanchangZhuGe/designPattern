<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%> 
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	String startDate = request.getParameter("startDate");
	if(startDate==null){
		String sql = "select to_char(max(t.week_end_date),'yyyy-MM-dd') week_start_date from bgp_hse_week_examine_new  t ";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		if(map!=null){
			startDate = map.get("weekStartDate").toString();
		}else{
			startDate = "";
		}
	}
	
	
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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<title></title>
</head>

<body style="overflow-x: scroll;overflow-y: scroll;">
<div id="list_table">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="FilterLayer">
			<tr>
				<td width="6"><img src="<%=contextPath%>/images/list_13.png"
					width="6" height="36" /></td>
				<td background="<%=contextPath%>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="ali_cdn_name">周报截止日期：</td>
			 	    <td class="ali_cdn_input">
			 	    	<input type="text" id="startDate" name="startDate" class="input_width" style="width:120px" value="" readonly="readonly"/>
					    &nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(startDate,tributton1);" />&nbsp;
			 	    </td> 
			 	    
					<td class="ali_query">
					   <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
				    </td>
				    <td class="ali_query">
					    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
					</td>
	
				    <td>&nbsp;</td>
				</tr>
			  </table>
			
				</td>
				<td width="4"><img src="<%=contextPath%>/images/list_17.png"
					width="4" height="36" /></td>
			</tr>
		</table>
	</div>
</div>
<% if(!startDate.equals("")){
    StringBuffer str = new StringBuffer();
    str.append("startDate=").append(startDate); %>
    <div >
	<table   align="center"  id="90" >
		<tr align="center" >
		    <td align="left" >
			  <report:html name="report1"
			               reportFileName="/hse_report_new_4.raq"
						   params="<%=str.toString()%>"
						   needScroll="yes"
						   scrollWidth="100%"
						   scrollHeight="50%"
						   excelPageStyle="0"
						   needSaveAsExcel="yes"
						   saveAsName="HSE统计周报" excelPageStyle="0"
			  />
			</td>
  	</tr>
	</table>
	</div>
<%} %>
</body>
<script type="text/javascript">
	
	document.getElementById("startDate").value = "<%=startDate%>";
	
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	//键盘上只有删除键，和左右键好用
	function noEdit(event){
		if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
			return true;
		}else{
			return false;
		}
	}
	
	// 简单查询
	function simpleSearch(){
		var startDate = document.getElementById("startDate").value;
		if(startDate==""){
			alert("请选择开始时间!");
			return;
		}
//		if(endDate==""){
//			endDate = convertDate(new Date());
//		}
		
		window.location="<%=contextPath%>/hse/report/hseWeekExamine.jsp?startDate="+startDate;
	}
	
	function convertDate(date){
		var year = date.getFullYear();
		var month = date.getMonth()+1;
		var m;
		if(month < 10){
			m = '0' + month;
		} else {
			m = month;
		}
		var day = date.getDate();
		var d;
		if(day < 10){
			d = '0' + day;
		} else {
			d = day;
		}
		var s = year + '-' +m+'-'+d;
		return s;
	}
</script>
</html>