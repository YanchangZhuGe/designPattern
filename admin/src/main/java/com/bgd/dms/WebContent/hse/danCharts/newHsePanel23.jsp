<%@page import="com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);

	String org_subjection_id = user.getOrgSubjectionId();
	
	System.out.println(org_subjection_id);
	
	String second_org = "" ;
	String sqlOrg = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = '"+org_subjection_id+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
	List listOrg = BeanFactory.getQueryJdbcDAO().queryRecords(sqlOrg);
	if(listOrg.size()>0){
		Map mapOrg = (Map)listOrg.get(0);
		second_org = (String)mapOrg.get("orgSubId");
	}

	Date d = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	String today = sdf.format(d);
	
	double record_percent = 0 ;
	double injure_percent = 0 ;
	double die_percent = 0 ;
	String sql = "select * from bgp_hse_workhour_all t where t.subjection_id = '"+second_org+"' and to_char(t.create_date, 'yyyy-MM-dd') = '"+today+"'";
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
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<title>无标题文档</title>

</head>
<body style="background: #C0E2FB; overflow-y: auto" >
	<table cellpadding="0" cellspacing="0" id="lineTable" class="tab_info" width="100%">
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

