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
	String temp = "";
	String sqlOrg = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = '"+org_subjection_id+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
	List listOrg = BeanFactory.getQueryJdbcDAO().queryRecords(sqlOrg);
	if(listOrg.size()>0){
		Map mapOrg = (Map)listOrg.get(0);
		org_sub_id = (String)mapOrg.get("orgSubId")+"'";
		temp = " and t.second_org='";
	}
	if(listOrg.size()>1){
		Map mapOrg1 = (Map)listOrg.get(1);
		org_sub_id = (String)mapOrg1.get("orgSubId")+"'";
		temp = " and t.third_org='";
	}
	if(listOrg.size()>2){
		Map mapOrg2 = (Map)listOrg.get(2);
		org_sub_id = (String)mapOrg2.get("orgSubId")+"'";
		temp = " and t.fourth_org= '";
	}

	//事故快报中的死亡事故，重伤事故，轻伤事故
	String number_die = "0";
	String number_harm = "0";
	String number_injure = "0";
	String sqlAcc = "select sum(t.number_die) number_die, sum(t.number_harm) number_harm,sum(t.number_injure) number_injure from bgp_hse_accident_news t where t.bsflag = '0'"+temp+org_sub_id;
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
	String sqlEvent = "select sum(nvl(t.number_owner,0)+nvl(t.number_out,0)+nvl(t.number_stock,0)+nvl(t.number_group,0)) event_num,t.event_property from bgp_hse_event t where t.bsflag='0' "+temp+org_sub_id+" group by t.event_property";
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
	
	
	
	
	
	String second_org = "";
	String sqlOrg2 = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = '"+org_subjection_id+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
	List listOrg2 = BeanFactory.getQueryJdbcDAO().queryRecords(sqlOrg2);
	if(listOrg2.size()>0){
		Map mapOrg = (Map)listOrg2.get(0);
		String flag = (String)mapOrg.get("organFlag");
		if(flag.equals("0")){
			second_org = "C105";
		}else{
			if(listOrg2.size()>1){
				Map mapOrg1 = (Map)listOrg2.get(1);
				flag = (String)mapOrg1.get("organFlag");
				if(flag.equals("0")){
					second_org = (String)mapOrg.get("orgSubId");
				}else{
					if(listOrg2.size()>2){
						Map mapOrg2 = (Map)listOrg2.get(2);
						flag = (String)mapOrg2.get("organFlag");
						if(flag.equals("0")){
							second_org = (String)mapOrg1.get("orgSubId");
						}else{
							second_org = (String)mapOrg2.get("orgSubId");
						}
					}else{
						second_org = (String)mapOrg1.get("orgSubId");
					}
				}
			}else{
				second_org = (String)mapOrg.get("orgSubId");
			}
		}
	}else{
		second_org = "C105"; 
	}
	
	double record_percent = 0 ;
	double injure_percent = 0 ;
	double die_percent = 0 ;
	String sql = "select * from bgp_hse_workhour_all t where t.subjection_id = '"+second_org+"' order by t.create_date desc";
	Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
	if(map!=null){
		String work_hour = (String)map.get("workhour");
		if(work_hour.equals("")){
			work_hour = "0";
		}
		String record = (String)map.get("recordPercent");
		if(record.equals("")){
			record = "0";
		}
		String injure = (String)map.get("injurePercent");
		if(injure.equals("")){
			injure = "0";
		}
		String die = (String)map.get("diePercent");
		if(die.equals("")){
			die = "0";
		}
		
		record_percent = Double.parseDouble(record)*100;
		injure_percent = Double.parseDouble(injure)*100;
		die_percent = Double.parseDouble(die)*100;
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
				<div class="tongyong_box_title"><span class="kb"> </span><a href="#">HSE事故事件统计</a></div>
					<table width="100%"  cellspacing="0" cellpadding="0"class="tab_info" >
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
						<tr class="even">
							<td>数量</td>
							<td><%=number_die %></td>
							<td><%=number_harm %></td>
							<td><%=number_injure %></td>
							<td><%=work_event %></td>
							<td><%=medic_event %></td>
							<td><%=aid_event %></td>
							<td><%=money_event %></td>
							<td><%=not_event %></td>
						</tr>
					</table>	   
				</td>
			</tr>
					<tr>
						<td>
						<div class="tongyong_box_title"><span class="kb"> </span><a href="#">百万工时统计</a></div>
							<table width="100%" cellspacing="0" cellpadding="0"class="tab_info" >
								<tr class="bt_info">
									<td colspan="2">FTLR(百万工时死亡率)</td>
									<td colspan="2">LTIF(百万工时损工伤亡发生率)</td>
									<td colspan="2">TRCF(百万工时可记录事件人数发生率)</td>
								</tr>
								<tr class="bt_info">
									<td>集团指标</td>
									<td>实际</td>
									<td>集团指标</td>
									<td>实际</td>
									<td>集团指标</td>
									<td>实际</td>
								</tr>
								<tr class="even">
									<td>0.024</td>
									<td><%=die_percent %></td>
									<td>0.15</td>
									<td><%=injure_percent %></td>
									<td>1.1</td>
									<td><%=record_percent %></td>
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
	/**/function frameSize() {

		var width = $(window).width() - 256;
		$("#tongyong_box_content_left_1").css("width", width);

	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	})
</script>
</html>

