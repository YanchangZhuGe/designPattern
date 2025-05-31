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
	
	
	
	String life_number = "0" ; 
	String industry_number = "0";
	String industry_cod = "0";
	String water_number = "0";
	String boiler_number = "0";
	String boiler_coal = "0";
	String boiler_gas = "0";
	String boiler_condition = "";
	String sql = "select ei.life_number ,ei.industry_number,ei.industry_cod,ei.water_number,ei.boiler_number,ei.boiler_coal,ei.boiler_gas from bgp_hse_environment_info ei where ei.org_sub_id='"+org_sub_id+"'";
	Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
	if(map!=null){
		life_number = (String)map.get("lifeNumber") =="" ? "0" : (String)map.get("lifeNumber");
		industry_number = (String)map.get("industryNumber") =="" ? "0" : (String)map.get("industryNumber");
		industry_cod = (String)map.get("industryCod") =="" ? "0" : (String)map.get("industryCod");
		water_number = (String)map.get("waterNumber") =="" ? "0" : (String)map.get("waterNumber");
		boiler_number = (String)map.get("boilerNumber") =="" ? "0" : (String)map.get("boilerNumber");
		boiler_coal = (String)map.get("boilerCoal") =="" ? "0" : (String)map.get("boilerCoal");
		boiler_gas = (String)map.get("boilerGas") =="" ? "0" : (String)map.get("boilerGas");
		boiler_condition = (String)map.get("boilerCondition") == null ? "" : (String)map.get("boilerCondition");
	}
	
	String target = "";
	String sqlTarget = "select * from bgp_hse_environment_target t where t.bsflag='0'";
	Map mapTarget = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlTarget);
	if(mapTarget!=null){
		target = (String)mapTarget.get("target");
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
						<div class="tongyong_box_title"><span class="kb"> </span><a href="#">环境</a></div>
							<table width="100%"  cellspacing="0" cellpadding="0"class="tab_info" >
								<tr class="bt_info">
									<td rowspan="2">生活源排污口</td>
									<td rowspan="2">工业源排污口</td>
									<td colspan="2">工业源COD</td>
									<td rowspan="2">水处理设施总数(台)</td>
									<td colspan="4">锅炉烟气处理设施</td>
								</tr>
								<tr class="bt_info">
									<td>集团指标</td>
									<td>当前值</td>
									<td>总数</td>
									<td>燃煤锅炉(个)</td>
									<td>燃气锅炉(个)</td>
									<td>运行情况</td>
								</tr>
								<tr class="even">
									<td><%=life_number %></td>
									<td><%=industry_number %></td>
									<td><%=target %></td>
									<td><%=industry_cod %></td>
									<td><%=water_number %></td>
									<td><%=boiler_number %></td>
									<td><%=boiler_coal %></td>
									<td><%=boiler_gas %></td>
									<td><%=boiler_condition %></td>
								</tr>
							</table>	   
						</td>
						
		<td width="1%">
		
		</td>
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

