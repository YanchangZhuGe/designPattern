<%@page import="com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.*,com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String reportName = "地震勘探项目运行动态表";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" type="text/JavaScript" src="/BGPMCS/js/bgpmcs/DivHiddenOpen.js"></script>
<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="<%=contextPath%>/css/rt_table.css" type="text/css" />
<link rel="stylesheet" href="<%=contextPath%>/css/common.css" type="text/css" />
<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>

<title></title>
</head>
<body>
<table border="0"  cellspacing="0"  cellpadding="0"  class="form_info"  width="100%" id="queryRetTable">
	<thead>
	<tr class="bt_info">
		<td class="tableHeader"  >序号</td>
		<td class="tableHeader"  >报表名称</td>
		<td class="tableHeader"  >第一期</td>
		<td class="tableHeader" >第二期</td>
		<td class="tableHeader" >第三期</td>
	</tr>
	</thead>
	<tbody>
		<tr class="even">
			<td class="even_odd">1</td>
			<td class="even_even">
				<a href="<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=Dynamic_year1&noLogin=admin&tokenId=admin&reportname=<%=reportName%>">
					地震勘探项目运行动态表(年报,含全年项目)
				</a>
			</td>
			<td class="even_odd"></td>
			<td class="even_even"></td>
			<td class="even_odd"></td>
		</tr>
		<tr class="odd">
			<td class="odd_odd">2</td>
			<td class="odd_even">
				<a href="<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=Dynamic_year1&noLogin=admin&tokenId=admin&reportname=<%=reportName%>">
					地震勘探项目运行动态表(月报,含全年项目)
				</a>
			</td>
			<td class="odd_odd"></td>
			<td class="odd_even"></td>
			<td class="odd_odd"></td>
		</tr>
		<tr class="even">
			<td class="even_odd">3</td>
			<td class="even_even">
				<a href="<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=Dynamic_year1&noLogin=admin&tokenId=admin&reportname=<%=reportName%>">
					地震勘探项目运行动态表(周报,含全年项目)
				</a>
			</td>
			<td class="even_odd"></td>
			<td class="even_even"></td>
			<td class="even_odd"></td>
		</tr>
		<tr class="odd">
			<td class="odd_odd">4</td>
			<td class="odd_even">
				<a href="<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=collect_ready&noLogin=admin&tokenId=admin"> 
					地震采集项目准备信息表
				</a>
			</td>
			<td class="odd_odd"></td>
			<td class="odd_even"></td>
			<td class="odd_odd"></td>
		</tr>
		<tr class="even">
			<td class="even_odd">5</td>
			<td class="even_even">
				<a href="<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=collect_end&noLogin=admin&tokenId=admin">
					地震采集项目结束信息表
				</a>
			</td>
			<td class="even_odd"></td>
			<td class="even_even"></td>
			<td class="even_odd"></td>
		</tr>
		<tr class="odd">
			<td class="odd_odd">6</td>
			<td class="odd_even">
				<a href="<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=pm_production&noLogin=admin&tokenId=admin">
					二维地震勘探生产报表
				</a>
			</td>
			<td class="odd_odd"></td>
			<td class="odd_even"></td>
			<td class="odd_odd"></td>
		</tr>
		<tr class="even">
			<td class="even_odd">7</td>
			<td class="even_even">
				<a href="<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=pm_production3&noLogin=admin&tokenId=admin">
					三维地震勘探生产报表
				</a>
			</td>
			<td class="even_odd"></td>
			<td class="even_even"></td>
			<td class="even_odd"></td>
		</tr>
		<tr class="odd">
			<td class="odd_odd">8</td>
			<td class="odd_even">
				<a href="<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=pm_question&noLogin=admin&tokenId=admin">
					地震勘探生产问题统计表
				</a>
			</td>
			<td class="odd_odd"></td>
			<td class="odd_even"></td>
			<td class="odd_odd"></td>
		</tr>
<!-- 			<tr class="even">
			<td class="even_odd">9</td>
			<td class="even_even">
				<a href="<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=pm_dynamic2&noLogin=admin&tokenId=admin">
					二维地震勘探项目施工因素及设备动态报表
				</a>
			</td>
			<td class="even_odd"></td>
			<td class="even_even"></td>
			<td class="even_odd"></td>
		</tr>
		<tr class="odd">
			<td class="odd_odd">10</td>
			<td class="odd_even">
				<a href="<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=pm_dynamic3&noLogin=admin&tokenId=admin">
					三维四维地震勘探项目施工因素及设备动态报表
				</a>
			</td>
			<td class="odd_odd"></td>
			<td class="odd_even"></td>
			<td class="odd_odd"></td>
		</tr>
 -->	
	</tbody>
</table>
</body>
</html>