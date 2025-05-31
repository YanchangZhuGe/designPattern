<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.bgp.gms.service.rm.dm.DMAutoUtil"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String subjection_id = user.getSubOrgIDofAffordOrg();
	if(subjection_id ==null){
		subjection_id = "";
	}
    String title="主要设备制度完好率利用率";
	String reportFileName = "perfect_use.raq";
	String reportName="主要设备制度完好率利用率";
	String year =(String)request.getParameter("year");
	if(year==null){
		year = String.valueOf((new Date()).getYear()+1900);
	}
	String querySql =DMAutoUtil.getPerfectUse(year);
	if(querySql==null ){
		querySql = "";
	}
	System.out.println(querySql);
	String rptParams = "querySql="+querySql;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>无标题文档</title>
</head>
<body style="background:#cdddef" >
<div id="list_table">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath%>/images/list_15.png">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="ali_cdn_name">文件名称</td>
							<td class="ali_cdn_input"><select id="year" name="year" onchange="refreshData()">
							<option value="2013">2013</option>
							<option value="2012">2012</option>
							<option value="2011">2011</option>
							<option value="2010">2010</option></select></td>
							<td>&nbsp;</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box">
		<table id=rpt border="0" cellpadding="0" cellspacing="0" class="ali6">
			<tr>
				<td>
					<report:html name="report1"
					reportFileName="<%=reportFileName %>"
					params="<%=rptParams%>"
					needScroll="no"
					width="-1" 
					height="-1"
		            needSaveAsExcel="yes"
					funcBarLocation=""
					saveAsName="<%=reportName%>" excelPageStyle="0"/>
				</td>
			</tr>
		</table>
	</div>
	<div id="fenye_box" style="height: 0px;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
		</table> 
	</div> 
</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var org_subjection_id = '<%=subjection_id%>';
	$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-8);
	var option = document.getElementById("year").options;
	for(var i =0;i<option.length;i++){
		var value = document.getElementById("year").options[i].value;
		if(value=='<%=year%>'){
			document.getElementById("year").options[i].selected = 'selected';
		}
	}
	// 复杂查询
	function refreshData(){
		debugger;
		var year = document.getElementById("year").value;
		window.location.href='<%=contextPath%>/rm/perfect_use.jsp?year='+year;
	}
</script>
</body>
</html>