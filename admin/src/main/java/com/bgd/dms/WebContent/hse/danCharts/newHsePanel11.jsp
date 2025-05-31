<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);


	String org_subjection_id = user.getOrgSubjectionId();
	String percent_health = "0";
	String total_num = "0";
	String places = "0";
	String people_num = "0";
	String percent_places = "0";
	String health_target = "0";
	String places_target = "0";
	
	String sql="select sum(nvl(t.percent_health,0)) percent_health,sum(nvl(t.percent_places,0)) percent_places,sum(nvl(to_number(t.total_num),0)) total_num ,sum(nvl(to_number(t.places),0)) places,sum(nvl(to_number(t.people_num),0)) people_num  from bgp_hse_professional_health t join bgp_hse_org o on t.org_sub_id=o.org_sub_id and o.father_org_sub_id='C105' where t.bsflag='0'";
	Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
	if(map!=null){
	 	percent_health = (String)map.get("percentHealth");
		total_num = (String)map.get("totalNum");
		places = (String)map.get("places");
		people_num = (String)map.get("peopleNum");
		percent_places = (String)map.get("percentPlaces");
	}		
	
	String sqlTarget = "select * from BGP_HSE_HEALTH_TARGET where bsflag='0'";
	Map mapTarget = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlTarget);
	if(mapTarget!=null){
		health_target = (String)mapTarget.get("healthTarget");
		places_target = (String)mapTarget.get("placesTarget");
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<title>无标题文档</title>

</head>
<body style="overflow-y: auto; background: #c0e2fb;">
		<table cellpadding="0" cellspacing="0" id="lineTable" class="tab_info" width="100%">
			<tr class="bt_info">
				<td colspan="3">职业病危害作业场所</td>
				<td colspan="2">职业健康体检率</td>
				<td colspan="2">职业病危害作业场所检测率</td>
				
			</tr>
			<tr class="bt_info">
				<td>总数</td>
				<td>固定场所</td>
				<td>接害人员</td>
				<td width="14%">集团指标</td>
				<td width="14%">当前值</td>
				<td width="14%">集团指标</td>
				<td width="14%">当前值</td>
			</tr>
			<tr class="even">
				<td><%=total_num %></td>
				<td><%=places %></td>
				<td><%=people_num %></td>
				<td><%=health_target %></td>
				<td><%=percent_health %></td>
				<td><%=places_target %></td>
				<td><%=percent_places %></td>
			</tr>
		</table>
</body>
</html>

