<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%> 
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%@page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	
	String date = request.getParameter("date");
	if(date==null){
		date="";	
	}
	
   String str = "";
	String name="综合物化探生产日报"+date;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>新建项目</title>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<title></title>
</head>

<body>
	<div>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" >
			<tr>
				<td width="6"><img src="<%=contextPath%>/images/list_13.png"width="6" height="36" /></td>
				<td background="<%=contextPath%>/images/list_15.png">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td></td>
				 	    <td>开始日期：
				 	    	<input type="text" id="dateId" name="dateId" class="" style="width:120px" value="" readonly="readonly"/>
						    &nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(dateId,tributton1);" />&nbsp;
				 	   	 <button type="button" onclick="simpleSearch()" id="a" >查询</button>	   
				 	    </td> 			 	   

					    <td>&nbsp;</td>
					</tr>
				  </table>
				</td>
				<td width="4"><img src="<%=contextPath%>/images/list_17.png"  width="4" height="36" /></td>
			</tr>
		</table>
	</div>
<%
if(date!=null && !date.equals("")){
    str="date="+date;

%>
	<div id="table_box"  style="height:510px;" >
			<table id=rpt border="0" cellpadding="0" cellspacing="0" class="ali6">
			<tr>
				<td>
			<report:html name="report1"
			reportFileName="pm/wtdaily.raq"
			params="<%=str.toString()%>"
			width="-1" 
			height="-1"
			needScroll="no"
			needSaveAsExcel="yes"
			saveAsName="<%=name %>" excelPageStyle="0"/>
				</td>
			</tr>
		</table>
	</div>
	<%
}
	%>
</body>
<script type="text/javascript">
 document.getElementById("dateId").value="<%=date%>";
	
	// 简单查询
	function simpleSearch(){
		var date = document.getElementById("dateId").value;
		if(date==""){
			alert("请选择开始时间!");
			return;
		}
		window.location="<%=contextPath%>/pm/dailyReport/singleProject/wt/wtdaily.jsp?date="+date;
	}
	
</script>
</html>