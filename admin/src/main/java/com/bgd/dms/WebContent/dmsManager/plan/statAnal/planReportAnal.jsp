<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Calendar"%>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%
	String contextPath = request.getContextPath();
	String year = request.getParameter("year");
	if(null==year || "".equals(year)){
		Calendar cal = Calendar.getInstance();
		year = Integer.toString(cal.get(Calendar.YEAR));
	}
	String queryStr = "year="+year;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
	<title>计划上报情况分析</title>
</head>
<body style="background:white">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath%>/images/list_15.png">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						  	<td class="ali_cdn_name">年度：</td>
			  				<td class="ali_cdn_input">
						   		<input id="q_year" name="year" type="text" style="width:105px;height:18px;line-height:18px;"readonly="readonly"/>
						   		<img width="20" height="18" id="cal_button" style="cursor: hand;" onmouseover="yearSelector(q_year,cal_button);" src="<%=contextPath%>/images/calendar.gif" />
						  	</td>
			  				<td class="ali_query">
			   					<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
							</td>
							<td>&nbsp;</td>
				  		</tr>
					</table>
				</td>
			   	<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			</tr>
		</table>
	</div>
	<div id="table_box">		
		<table align="center"  id="90" >
			<tr align="center" >
		    	<td align="center" >
			  		<report:html name="report1"
	        			reportFileName="/dms/plan/plan_report_anal.raq"
						params="<%=queryStr%>"
		   				needScroll="yes"
		   				scrollWidth="100%"
		   				scrollHeight="100%"/>
				</td>
	 		</tr>
		</table>
	</div>
</body>
<script type="text/javascript">
    var curYear="<%=year%>";
	function frameSize(){
		$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height());
	}
	$(function(){
		frameSize();
		$(window).resize(function(){
	  		frameSize();
		});
		$("#q_year").val(curYear); 
	});
	//简单查询
	function simpleSearch(){
	    var q_year = $("#q_year").val(); 
	    window.location="<%=contextPath%>/dmsManager/plan/statAnal/planReportAnal.jsp?year="+q_year;
	}
	//选择年份
	function yearSelector(inputField,tributton){    
	    Calendar.setup({
	        inputField     :    inputField,   // id of the input field
	        ifFormat       :    "%Y",       // format of the input field
	        align          :    "Br",
			button         :    tributton,
	        onUpdate       :    null,
	        weekNumbers    :    false,
			singleClick    :    true,
			step	       :	1
	    });
	}
</script>
</html>