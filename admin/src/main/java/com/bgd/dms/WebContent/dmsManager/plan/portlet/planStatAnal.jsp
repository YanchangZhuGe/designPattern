<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ taglib uri="code" prefix="code"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
		<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
		<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/FusionCharts.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
		<style type="text/css">
			.select {
				margin:0,0,0,0;
				border:1px #52a5c4 solid;
				width:120px;
				height:20px;
				color: #333333;
				position: relative;
				FONT-FAMILY: "微软雅黑";font-size:9pt;
			}
			.input {
				margin:0,0,0,0;
				border:1px #52a5c4 solid;
				width:120px;
				height:18px;
				color: #333333;
				position: relative;
				FONT-FAMILY: "微软雅黑";font-size:9pt;
			}
			.tongyong_box_title {
				width:100%;
				height:auto;
				text-align:left;
				text-indent:12px;
				font-weight:bold;
				font-size:14px;
				color:#0f6ab2;
				line-height:22px;
			} 
			.tongyong_box {
			width:100%;
			height:auto;
			float:left;
			border:1px #6dabe6 solid;
			background:#efefef;
			color:#666;
			margin:2px 0px;
		}
		.load_t_div{
			margin:6px;
		}
		.load_t_div table tr{
			padding:1px;
		}
		</style>
		<title>设备使用分析</title>
	</head>
	<body style="background: #cdddef; overflow-y: auto">
		<div class="load_t_div">
			<table id="div_table" width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="100%" colspan="2">
						<div id="tr1_td1_loaddiv">
						</div>
					</td>
				</tr>
				<tr>
					<td width="100%" colspan="2">
						<div id="tr2_td1_loaddiv">
						</div>
					</td>
				</tr>
				<tr>
					<td width="50%" valign="top">
						<div id="tr3_td1_loaddiv">
						</div>
					</td>
					<td width="50%" valign="top">
						<div id="tr3_td2_loaddiv">
						</div>
					</td>
				</tr>
				<tr>
					<td width="100%" colspan="2">
						<div id="tr4_td1_loaddiv">
						</div>
					</td>
				</tr>
			</table>
		</div>
	</body>
	<script type="text/javascript">
		$(function() {
			$("#tr1_td1_loaddiv").load("<%=contextPath%>/dmsManager/plan/portlet/pPlanRepoAmouAnal.jsp");
			$("#tr2_td1_loaddiv").load("<%=contextPath%>/dmsManager/plan/portlet/pDeviceNewExtent.jsp");
			$("#tr3_td1_loaddiv").load("<%=contextPath%>/dmsManager/use/portlet/pProduceRate.jsp");
			$("#tr3_td2_loaddiv").load("<%=contextPath%>/dmsManager/use/portlet/pFieldCapital.jsp");
			$("#tr4_td1_loaddiv").load("<%=contextPath%>/dmsManager/use/portlet/pDlyldb.jsp");
		});
		$.ajaxSetup ({
			cache: false //close AJAX cache
		});
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

