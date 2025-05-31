<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%
	String contextPath=request.getContextPath();
	
	//事故快报中的死亡事故，重伤事故，轻伤事故
	String number_die = "0";
	String number_harm = "0";
	String number_injure = "0";
	String sqlAcc = "select sum(t.number_die) number_die, sum(t.number_harm) number_harm,sum(t.number_injure) number_injure from bgp_hse_accident_news t where t.bsflag = '0'";
	Map mapAcc = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlAcc);
	if(mapAcc!=null){
		number_die = (String)mapAcc.get("numberDie");
		if(number_die.equals("")){
			number_die = "0";
		}
		number_harm = (String)mapAcc.get("numberHarm");
		if(number_harm.equals("")){
			number_harm = "0";
		}
		number_injure = (String)mapAcc.get("numberInjure");
		if(number_injure.equals("")){
			number_injure = "0";
		}
	}
	
	//事件信息中的工作受限、医疗处置、急救事件、未遂事件、财产损失事件
	String work_event = "0";
	String medic_event = "0";
	String aid_event = "0";
	String money_event = "0";
	String not_event = "0";
	String sqlEvent = "select sum(nvl(t.number_owner,0)+nvl(t.number_out,0)+nvl(t.number_stock,0)+nvl(t.number_group,0)) event_num,t.event_property from bgp_hse_event t where t.bsflag='0' group by t.event_property";
	List listEvent = BeanFactory.getQueryJdbcDAO().queryRecords(sqlEvent);
	for(int i=0;i<listEvent.size();i++){
		Map map = (Map)listEvent.get(i);
		String event_property = (String)map.get("eventProperty");
		if(event_property.equals("1")){
			work_event = (String)map.get("eventNum");
		}
		if(event_property.equals("2")){
			medic_event = (String)map.get("eventNum");
		}
		if(event_property.equals("3")){
			aid_event = (String)map.get("eventNum");
		}
		if(event_property.equals("4")){
			money_event = (String)map.get("eventNum");
		}
		if(event_property.equals("5")){
			not_event = (String)map.get("eventNum");
		}
	}
	
	




%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<title>无标题文档</title>
<style type="text/css">

</style>
</head>
<body style="background: #C0E2FB; overflow-y: auto" >
	<table cellpadding="0" cellspacing="0" id="lineTable" class="tab_info" width="100%">
		<tr class="bt_info">
			<td>事件等级</td>
			<td>死亡事故</td>
			<td>重伤事故</td>
			<td>轻伤事故</td>
			<td>工作受限</td>
			<td>医疗处置</td>
			<td>急救事件</td>
			<td>未遂事件</td>
			<td>财产损失事故</td>
		</tr>
		<tr  class="even">
			<td>数量</td>
			<td><%=number_die %></td>
			<td><%=number_harm %></td>
			<td><%=number_injure %></td>
			<td><%=work_event %></td>
			<td><%=medic_event %></td>
			<td><%=aid_event %></td>
			<td><%=not_event %></td>
			<td><%=money_event %></td>
		</tr>
	</table>	   
</body>
</html>

