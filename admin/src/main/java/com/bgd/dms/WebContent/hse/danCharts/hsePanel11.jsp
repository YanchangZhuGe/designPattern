<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);


	String org_subjection_id = user.getOrgSubjectionId();
	
	System.out.println(org_subjection_id);
	
	String org_sub_id = "" ;
	String sqlOrg = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = '"+org_subjection_id+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
	List listOrg = BeanFactory.getQueryJdbcDAO().queryRecords(sqlOrg);
	if(listOrg.size()>0){
		Map mapOrg = (Map)listOrg.get(0);
		String flag = (String)mapOrg.get("organFlag");
		if(flag.equals("0")){
			org_sub_id = "C105";
		}else{
			if(listOrg.size()>1){
				Map mapOrg1 = (Map)listOrg.get(1);
				flag = (String)mapOrg1.get("organFlag");
				if(flag.equals("0")){
					org_sub_id = (String)mapOrg.get("orgSubId");
				}else{
					if(listOrg.size()>2){
						Map mapOrg2 = (Map)listOrg.get(2);
						flag = (String)mapOrg2.get("organFlag");
						if(flag.equals("0")){
							org_sub_id = (String)mapOrg1.get("orgSubId");
						}else{
							org_sub_id = (String)mapOrg2.get("orgSubId");
						}
					}else{
						org_sub_id = (String)mapOrg1.get("orgSubId");
					}
				}
			}else{
				org_sub_id = (String)mapOrg.get("orgSubId");
			}
		}
	}else{
		org_sub_id = "C105"; 
	}
	
	
	String percent_health = "0";
	String total_num = "0";
	String places = "0";
	String people_num = "0";
	String percent_places = "0";
	String health_target = "0";
	String places_target = "0";
	
	if(org_sub_id.equals("C105")){
		String sql="select sum(nvl(t.percent_health,0)) percent_health,sum(nvl(t.percent_places,0)) percent_places,sum(nvl(to_number(t.total_num),0)) total_num ,sum(nvl(to_number(t.places),0)) places,sum(nvl(to_number(t.people_num),0)) people_num  from bgp_hse_professional_health t join bgp_hse_org o on t.org_sub_id=o.org_sub_id and o.father_org_sub_id='C105' where t.bsflag='0'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		if(map!=null){
		 	percent_health = (String)map.get("percentHealth");
		 	if(percent_health.equals("")){
		 		percent_health = "0";
		 	}
			total_num = (String)map.get("totalNum");
			if(total_num.equals("")){
				total_num = "0";
			}
			places = (String)map.get("places");
			if(places.equals("")){
				places = "0";
			}
			people_num = (String)map.get("peopleNum");
			if(people_num.equals("")){
				people_num = "0";
			}
			percent_places = (String)map.get("percentPlaces");
			if(percent_places.equals("")){
				percent_places = "0";
			}
		}		
	}else{
		String sql = "select * from bgp_hse_professional_health t where t.bsflag='0' and t.org_sub_id='"+org_sub_id+"'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		if(map!=null){
		 	percent_health = (String)map.get("percentHealth");
			total_num = (String)map.get("totalNum");
			places = (String)map.get("places");
			people_num = (String)map.get("peopleNum");
			percent_places = (String)map.get("percentPlaces");
		}
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
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/hse/danCharts/panel.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<title>无标题文档</title>

</head>
<body style="overflow-y: auto; background: #c0e2fb;">
<div id="list_content" style="background: #c0e2fb;">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0"  class="tab_info" >
					<tr>
						<td>
							<div class="tongyong_box_title"><span class="kb"> </span><a href="#">职业健康状况</a></div>
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
</html>

