<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.text.SimpleDateFormat"%>
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
	

	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	Calendar cc=Calendar.getInstance();  
	cc.setTimeInMillis(System.currentTimeMillis());  
	Date today = sdf.parse(sdf.format(cc.getTime()));
	cc.set(Calendar.DAY_OF_WEEK, Calendar.THURSDAY);  	
	Date thursday = sdf.parse(sdf.format(cc.getTime()));
	
	String week_end_date = "";
	if(today.getTime()>thursday.getTime()){
		 week_end_date = sdf.format(thursday);
	}else{
		 week_end_date = sdf.format(new Date(thursday.getTime()-7*24*60*60*1000));
	}
	
	System.out.println("************************************************");
	System.out.println(week_end_date);
	System.out.println("************************************************");
	
	
	String use_no = "0";
	String week_use_no = "0";
	String normal_no = "0";
	String wrong_no = "0";
	String fix_no = "0";
	String sql = "select g.use_no,g.week_use_no,g.normal_no,g.wrong_no,g.fix_no from bgp_hse_common c join bgp_hse_week_gps g on c.hse_common_id = g.hse_common_id where c.bsflag = '0' and c.subflag = '1' and c.org_id = '"+second_org+"' and c.week_end_date = to_date('"+week_end_date+"','yyyy-MM-dd')";
	Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
	if(map!=null){
		use_no = (String)map.get("useNo") == "" ? "0" : (String)map.get("useNo");
		week_use_no = (String)map.get("weekUseNo") == "" ? "0" : (String)map.get("weekUseNo");
		normal_no = (String)map.get("normalNo") == "" ? "0" : (String)map.get("normalNo");
		wrong_no = (String)map.get("wrongNo") == "" ? "0" : (String)map.get("wrongNo");
		fix_no = (String)map.get("fixNo") == "" ? "0" : (String)map.get("fixNo");
	}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<title>公司GPS监控工作情况(台)</title>
</head>
<body style="background: #C0E2FB; overflow-y: auto" >
	<table cellpadding="0" cellspacing="0" id="lineTable" class="tab_info" width="100%">
		<tr class="bt_info">
			<td>现有安装台数</td>
			<td>本周工作台数</td>
			<td>正常</td>
			<td>不正常</td>
			<td>待修</td>
		</tr>
		<tr class="even">
			<td><%=use_no %></td>
			<td><%=week_use_no %></td>
			<td><%=normal_no %></td>
			<td><%=wrong_no %></td>
			<td><%=fix_no %></td>
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

