<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="java.util.Calendar"%>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%
	String contextPath = request.getContextPath();
	String year = request.getParameter("year");
	String org_sub_id = request.getParameter("org_sub_id");
	String plan_type = request.getParameter("plan_type");
	String purc_type = request.getParameter("purc_type");
	String queryStr = "year="+year+";org_sub_id="+org_sub_id+";plan_type="+plan_type+";purc_type="+purc_type;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<%@include file="/common/include/quotesresource.jsp"%>
	<title>上报情况明细分析</title>
</head>
<body style="background:white">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath%>/images/list_15.png">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
			  				<td>&nbsp;</td>
			  				<td class="ali_btn">
			   					<span class="fh"><a href="#" onclick="toBack()" title="返回上级"></a></span>
							</td>
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
	        			reportFileName="/dms/plan/s_plan_purc_report.raq"
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
	function frameSize(){
		$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height());
	}
	$(function(){
		frameSize();
		$(window).resize(function(){
	  		frameSize();
		});
	});
	function toBack(){
		window.location='<%=contextPath %>/dmsManager/plan/statAnal/planPurcReport.jsp?year=<%=year%>&plan_type=<%=plan_type%>&purc_type=<%=purc_type%>';
	}
</script>
</html>