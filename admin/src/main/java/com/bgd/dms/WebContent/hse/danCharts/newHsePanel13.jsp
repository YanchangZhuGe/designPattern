<%@page import="com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%
	String contextPath=request.getContextPath();

	Date d = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	String today = sdf.format(d);

	String sqlHours = "select sum(t.workhour) workhour from bgp_hse_workhour_all t join bgp_hse_org o on t.subjection_id = o.org_sub_id where o.father_org_sub_id = 'C105' and to_char(t.create_date, 'yyyy-MM-dd') = '"+today+"'";
	Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlHours);
	String all_hours = (String)map.get("workhour");
	double allHours = Double.parseDouble(all_hours);
	
	double acc_all = 0;
	double eve_all = 0;
	double dieNum = 0;
	//事故记录中的伤亡人员和的SQL
	String	accSql = "select sum(nu.number_die) die,sum(nu.number_harm) harm,sum(nu.number_injure) injure from bgp_hse_accident_news an left join bgp_hse_accident_number nu on an.hse_accident_id = nu.hse_accident_id and nu.bsflag='0' where an.bsflag='0'";
	Map accMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(accSql);
	if(accMap!=null&&!accMap.equals("")){
		String die = (String)accMap.get("die")=="" ? "0" : (String)accMap.get("die");
		String harm = (String)accMap.get("harm")=="" ? "0" : (String)accMap.get("harm");
		String injure = (String)accMap.get("injure")=="" ? "0" : (String)accMap.get("injure");
		dieNum = Integer.parseInt(die);
		acc_all = Integer.parseInt(die)+Integer.parseInt(harm)+Integer.parseInt(injure);
	}
	//事件信息报告中事件性质为限工事件、医疗事件中的4个受害人数和
	String eveSql = "select sum(t.number_owner) owner_num,sum(t.number_out) out_num,sum(t.number_stock) stock_num,sum(t.number_group) group_num from bgp_hse_event t where t.bsflag='0' and t.event_property in ('1','2')";
	Map eveMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(eveSql);
	if(eveMap!=null&&!eveMap.equals("")){
		String owner_num = (String)eveMap.get("ownerNum")=="" ? "0" : (String)eveMap.get("ownerNum");
		String out_num = (String)eveMap.get("outNum")=="" ? "0" : (String)eveMap.get("outNum");
		String stock_num = (String)eveMap.get("stockNum")=="" ? "0" : (String)eveMap.get("stockNum");
		String group_num = (String)eveMap.get("groupNum")=="" ? "0" : (String)eveMap.get("groupNum");
		eve_all = Integer.parseInt(owner_num)+Integer.parseInt(out_num)+Integer.parseInt(stock_num)+Integer.parseInt(group_num);
	}
	
	
	double accEvePercent = 0; 
	double accPercent = 0;				
	double diePercent = 0;
	if(allHours!=0){
		accEvePercent = (acc_all+eve_all)/allHours; //百万工时可记录事件发生率
		accPercent = acc_all/allHours;				//百万工时损工伤亡发生率
		diePercent = dieNum/allHours;				//百万工时死亡率
	}

	double accEvePercent1 = Math.round(accEvePercent*100000);
	accEvePercent =  accEvePercent1/1000;
	double accPercent1 = Math.round(accPercent*100000);
	accPercent =  accPercent1/1000;
	double diePercent1 = Math.round(diePercent*100000);
	diePercent =  diePercent1/1000;

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
			<td><%=diePercent %></td>
			<td>0.15</td>
			<td><%=accPercent %></td>
			<td>1.1</td>
			<td><%=accEvePercent %></td>
		</tr>
	</table>	   
</body>
</html>

