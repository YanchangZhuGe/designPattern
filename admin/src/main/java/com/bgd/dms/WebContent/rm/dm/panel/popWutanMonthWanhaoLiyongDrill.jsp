<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String orgstrId = user.getOrgId();
	//月份信息
	String obj = request.getParameter("obj");
	String[] paramobj = obj.split("~",-1);
	String monthinfo = paramobj[0];
	String orgsubid = paramobj[1];
	//String monthinfo = request.getParameter("monthinfo");
	String[] monthinfos = monthinfo.split("-",-1);
	String showinfo = monthinfos[0]+"年"+monthinfos[1]+"月";
	//String orgsubid = request.getParameter("orgsubId");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<title>无标题文档</title>
</head>
<body style="background: #fff; overflow-y: auto"  onload="getFusionChart()">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="99%">
							<div class="tongyong_box">
							<div class="tongyong_box_title"><span class="kb"><a
								href="#"></a></span><a href="#">主要设备完好率、利用率钻取&lt;<%=showinfo%>&gt;
								</a><span class="gd"><a
								href="#"></a></span></div>
								<div class="tongyong_box_content_left" id="chartContainer2" style="height: 250px;">
		
								</div>
							</div>
						</td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	<td width="1%"></td>
	</tr>
</table>
</div>
</body>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	function getFusionChart(){
		var myChart3 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId3", "100%", "250", "0", "0" );    
		var retObj = jcdpCallService("DevCommInfoSrv","drillWutanMonthWanhaoLiyong","monthinfo=<%=monthinfo%>&orgsubid=<%=orgsubid%>");
		var dataXml = retObj.xmldata;   
		var startindex = dataXml.indexOf("<chart");
		dataXml = dataXml.substr(startindex);
		myChart3.setXMLData(dataXml);
		myChart3.render("chartContainer2"); 
	}
</script>
</html>

