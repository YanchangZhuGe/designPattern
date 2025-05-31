<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="java.util.Calendar"%>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%
	String contextPath = request.getContextPath();
	String year = request.getParameter("year");
	String plan_type = request.getParameter("plan_type");
	String purc_type = request.getParameter("purc_type");
	if(null==year || "".equals(year)){
		Calendar cal = Calendar.getInstance();
		year = Integer.toString(cal.get(Calendar.YEAR));
	}
	String queryStr = "year="+year+";plan_type="+plan_type+";purc_type="+purc_type;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<%@include file="/common/include/quotesresource.jsp"%>
	<title>上报情况分析</title>
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
						   		<input id="q_year" name="year" class="easyui-numberspinner input_width" style="line-height:25px; height:25px;" data-options="editable:false"/>
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
	        			reportFileName="/dms/plan/plan_purc_report.raq"
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
		$('#q_year').numberspinner('setValue', curYear);
	});
	//简单查询
	function simpleSearch(){
	    var q_year = $('#q_year').numberspinner('getValue');
	    window.location="<%=contextPath%>/dmsManager/plan/statAnal/planPurcReport.jsp?year="+q_year+"&plan_type=<%=plan_type%>&purc_type=<%=purc_type%>";
	}
	function popPlanPurcDetail(org_sub_id,year,plan_type,purc_type){
		window.location='<%=contextPath %>/dmsManager/plan/statAnal/sPlanPurcReport.jsp?year='+year+'&org_sub_id='+org_sub_id+'&plan_type='+plan_type+'&purc_type='+purc_type;
	}
</script>
</html>