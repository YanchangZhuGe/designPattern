<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String subjection_id = user.getSubOrgIDofAffordOrg();
	if(subjection_id ==null){
		subjection_id = "";
	}
    String title="公司地震采集项目运营状况分析表";
	String reportFileName =(String)request.getParameter("reportFileName");
	//reportFileName = "/"+reportFileName;
	String reportName="公司地震采集项目运营状况分析表";
	String orgSubId =(String)request.getParameter("orgSubId");
	if(orgSubId==null ){
		orgSubId = "";
	}
	String rptParams =(String)request.getParameter("rptParams");
	if(rptParams==null ){
		rptParams = "org_subjection_id=C105";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<title>无标题文档</title>
</head>
<body style="background:#fff" >
<div id="list_table">
	<%-- <div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath%>/images/list_15.png">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="ali_cdn_name">文件名称</td>
							<td class="ali_cdn_input"><input id="file_name" name="file_name" type="text" class="input_width"/></td>
							<auth:ListButton functionId="" css="cx" event="onclick='simpleSearchCommon()'" title="JCDP_btn_submit"></auth:ListButton>
							<auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_submit"></auth:ListButton>
							<td>&nbsp;</td>
							<auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
							<auth:ListButton functionId="F_QUA_NOTICE_001" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div> --%>
	<div id="table_box">
		<%-- <table width="100%" border="0" cellspacing="0" cellpadding="0" class="rtab_info">
			<tr>
				<td align="right">     
					<a href="#" onClick="report1_saveAsWord();return false;"><%=wordImage%></a>
					<a href="#" onClick="report1_saveAsExcel();return false;"><%=excelImage%></a>
					 <a href="#" onClick="report1_saveAsPdf();return false;"><%=pdfImage%></a>
					<a href="#" onClick="report1_print();return false;"><%=printImage%></a>
					<a href="#" onClick="cancle();return false;"><img src="<%=contextPath%>/images/back2.gif" border="0"/></a>
				</td>
			</tr>
		</table> --%> 
		<table id=rpt border="0" cellpadding="0" cellspacing="0" class="ali6">
			<tr>
				<td>
					<!-- width="-1" height="-1" needScroll="no" scrollWidth="100%" scrollHeight="100%" scrollBorder="border:1px solid red" needSaveAsExcel="yes"-->
					<report:html name="report1"
					reportFileName="<%=reportFileName %>"
					params="<%=rptParams%>"
					width="-1" 
					height="-1"
					needSaveAsExcel="yes"
					saveAsName="<%=title%>" excelPageStyle="0"/>
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
	resizeNewTitleTable();
	var file_name="";	
	var org_subjection_id = "";
	var file_name="";	
	
	// 复杂查询
	function refreshData(q_file_name,subjection_id){
		if(q_file_name==null){
			q_file_name = file_name;
		}
		file_name = q_file_name;
		if(subjection_id == null){
			subjection_id = '<%=subjection_id%>';
			org_subjection_id = subjection_id;
			document.getElementById("org_subjection_id").value = subjection_id;
		}else{
			document.getElementById("org_subjection_id").value = subjection_id;
			org_subjection_id = subjection_id;
		}
		document.getElementById("file_name").value = file_name;
		cruConfig.queryStr = " select concat(concat(t.file_id ,':'),t.ucm_id) ids,t.file_id,t.file_name,'物探处' file_from," +
		" to_char(t.create_date,'yyyy-MM-dd') as create_date from bgp_doc_gms_file t " +
		" where t.bsflag='0' and t.is_file='1' and t.relation_id ='notice:"+org_subjection_id+"' union" +
		" select concat(concat(t.file_id ,':'),t.ucm_id) ids,t.file_id,t.file_name,'东方' file_from," +
		" to_char(t.create_date,'yyyy-MM-dd') as create_date from bgp_qua_notice n " +
		" join bgp_doc_gms_file t on n.file_id = t.file_id and t.bsflag ='0'" +
		" where n.bsflag='0' and n.org_subjection_id ='"+org_subjection_id+"'";
		cruConfig.pageSize = cruConfig.pageSizeMax;
		queryData(1);
	}
	//refreshData();
</script>
</body>
</html>