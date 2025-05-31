<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();

	String types[] = {"bgp_hse_professional","bgp_hse_special_work","bgp_hse_driver","bgp_hse_strain","bgp_hse_cater","bgp_hse_blast","bgp_hse_health","bgp_hse_medical","bgp_hse_water"};

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
				<td></td>
				<td>合同化</td>
				<td>市场化</td>
				<td>临时季节性</td>
				<td>再就业</td>
				<td>劳务用工</td>
				
			</tr>
			<tr class="even">
			<%
			String hetonghua1 = "0";
			String shichanghua1 = "0";
			String zaijiuye1 = "0";
			String laowuyonggong1 = "0";
			String jijiexing1 = "0";
			
			String sql = "select count(hp.employee_id) num,cc.employee_gz type from (select hr.employee_id,hr.employee_gz from comm_human_employee_hr hr union select la.labor_id,la.if_engineer from bgp_comm_human_labor la) cc join "+types[0]+" hp on cc.employee_id=hp.employee_id where hp.bsflag='0' group by cc.employee_gz ";
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
			if(list!=null&&list.size()!=0){
				for(int i=0;i<list.size();i++){
					Map map = (Map)list.get(i);
					String type = map.get("type")==null?"":(String)map.get("type");
					if(type.equals("0110000019000000001")){
						hetonghua1 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000019000000002")){
						shichanghua1 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000001")){
						zaijiuye1 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000003")){
						laowuyonggong1 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000005")){
						jijiexing1 = map.get("num")==null?"0":(String)map.get("num");
					}
			}
			}
			
			%>
				<td>HSE专业人员</td>
				<td><%=hetonghua1 %></td>
				<td><%=shichanghua1 %></td>
				<td><%=jijiexing1 %></td>
				<td><%=zaijiuye1 %></td>
				<td><%=laowuyonggong1 %></td>
			</tr>
			<tr class="odd">
			<%
			String hetonghua2 = "0";
			String shichanghua2 = "0";
			String zaijiuye2 = "0";
			String laowuyonggong2 = "0";
			String jijiexing2 = "0";
			
			String sql2 = "select count(hp.employee_id) num,cc.employee_gz type from (select hr.employee_id,hr.employee_gz from comm_human_employee_hr hr union select la.labor_id,la.if_engineer from bgp_comm_human_labor la) cc join "+types[1]+" hp on cc.employee_id=hp.employee_id where hp.bsflag='0' group by cc.employee_gz ";
			List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
			if(list2!=null&&list2.size()!=0){
				for(int i=0;i<list2.size();i++){
					Map map = (Map)list2.get(i);
					String type = map.get("type")==null?"":(String)map.get("type");
					if(type.equals("0110000019000000001")){
						hetonghua2 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000019000000002")){
						shichanghua2 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000001")){
						zaijiuye2 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000003")){
						laowuyonggong2 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000005")){
						jijiexing2 = map.get("num")==null?"0":(String)map.get("num");
					}
			}
			}
			
			%>
				<td>特种作业人员</td>
				<td><%=hetonghua2 %></td>
				<td><%=shichanghua2 %></td>
				<td><%=jijiexing2 %></td>
				<td><%=zaijiuye2 %></td>
				<td><%=laowuyonggong2 %></td>
			</tr>
			<tr class="even">
			<%
			String hetonghua3 = "0";
			String shichanghua3 = "0";
			String zaijiuye3 = "0";
			String laowuyonggong3 = "0";
			String jijiexing3 = "0";
			
			String sql3 = "select count(hp.employee_id) num,cc.employee_gz type from (select hr.employee_id,hr.employee_gz from comm_human_employee_hr hr union select la.labor_id,la.if_engineer from bgp_comm_human_labor la) cc join "+types[2]+" hp on cc.employee_id=hp.employee_id where hp.bsflag='0' group by cc.employee_gz ";
			List list3 = BeanFactory.getQueryJdbcDAO().queryRecords(sql3);
			if(list3!=null&&list3.size()!=0){
				for(int i=0;i<list3.size();i++){
					Map map = (Map)list3.get(i);
					String type = map.get("type")==null?"":(String)map.get("type");
					if(type.equals("0110000019000000001")){
						hetonghua3 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000019000000002")){
						shichanghua3 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000001")){
						zaijiuye3 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000003")){
						laowuyonggong3 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000005")){
						jijiexing3 = map.get("num")==null?"0":(String)map.get("num");
					}
			}
			}
			
			%>
				<td>司驾人员</td>
				<td><%=hetonghua3 %></td>
				<td><%=shichanghua3 %></td>
				<td><%=jijiexing3 %></td>
				<td><%=zaijiuye3 %></td>
				<td><%=laowuyonggong3 %></td>
			</tr>
			<tr class="odd">
			<%
			String hetonghua4 = "0";
			String shichanghua4 = "0";
			String zaijiuye4 = "0";
			String laowuyonggong4 = "0";
			String jijiexing4 = "0";
			
			String sql4 = "select count(hp.employee_id) num,cc.employee_gz type from (select hr.employee_id,hr.employee_gz from comm_human_employee_hr hr union select la.labor_id,la.if_engineer from bgp_comm_human_labor la) cc join "+types[3]+" hp on cc.employee_id=hp.employee_id where hp.bsflag='0' group by cc.employee_gz ";
			List list4 = BeanFactory.getQueryJdbcDAO().queryRecords(sql4);
			if(list4!=null&&list4.size()!=0){
				for(int i=0;i<list4.size();i++){
					Map map = (Map)list4.get(i);
					String type = map.get("type")==null?"":(String)map.get("type");
					if(type.equals("0110000019000000001")){
						hetonghua4 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000019000000002")){
						shichanghua4 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000001")){
						zaijiuye4 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000003")){
						laowuyonggong4 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000005")){
						jijiexing4 = map.get("num")==null?"0":(String)map.get("num");
					}
			}
			}
			
			%>
				<td>应急人员</td>
				<td><%=hetonghua4 %></td>
				<td><%=shichanghua4 %></td>
				<td><%=jijiexing4 %></td>
				<td><%=zaijiuye4 %></td>
				<td><%=laowuyonggong4 %></td>
			</tr>
			<tr class="even">
			<%
			String hetonghua5 = "0";
			String shichanghua5 = "0";
			String zaijiuye5 = "0";
			String laowuyonggong5 = "0";
			String jijiexing5 = "0";
			
			String sql5 = "select count(hp.employee_id) num,cc.employee_gz type from (select hr.employee_id,hr.employee_gz from comm_human_employee_hr hr union select la.labor_id,la.if_engineer from bgp_comm_human_labor la) cc join "+types[4]+" hp on cc.employee_id=hp.employee_id where hp.bsflag='0' group by cc.employee_gz ";
			List list5 = BeanFactory.getQueryJdbcDAO().queryRecords(sql5);
			if(list5!=null&&list5.size()!=0){
				for(int i=0;i<list5.size();i++){
					Map map = (Map)list5.get(i);
					String type = map.get("type")==null?"":(String)map.get("type");
					if(type.equals("0110000019000000001")){
						hetonghua5 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000019000000002")){
						shichanghua5 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000001")){
						zaijiuye5 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000003")){
						laowuyonggong5 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000005")){
						jijiexing5 = map.get("num")==null?"0":(String)map.get("num");
					}
			}
			}
			
			%>
				<td>餐饮从业人员</td>
				<td><%=hetonghua5 %></td>
				<td><%=shichanghua5 %></td>
				<td><%=jijiexing5 %></td>
				<td><%=zaijiuye5 %></td>
				<td><%=laowuyonggong5 %></td>
			</tr>
			<tr class="odd">
			<%
			String hetonghua6 = "0";
			String shichanghua6 = "0";
			String zaijiuye6 = "0";
			String laowuyonggong6 = "0";
			String jijiexing6 = "0";
			
			String sql6 = "select count(hp.employee_id) num,cc.employee_gz type from (select hr.employee_id,hr.employee_gz from comm_human_employee_hr hr union select la.labor_id,la.if_engineer from bgp_comm_human_labor la) cc join "+types[5]+" hp on cc.employee_id=hp.employee_id where hp.bsflag='0' group by cc.employee_gz ";
			List list6 = BeanFactory.getQueryJdbcDAO().queryRecords(sql6);
			if(list6!=null&&list6.size()!=0){
				for(int i=0;i<list6.size();i++){
					Map map = (Map)list6.get(i);
					String type = map.get("type")==null?"":(String)map.get("type");
					if(type.equals("0110000019000000001")){
						hetonghua6 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000019000000002")){
						shichanghua6 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000001")){
						zaijiuye6 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000003")){
						laowuyonggong6 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000005")){
						jijiexing6 = map.get("num")==null?"0":(String)map.get("num");
					}
			}
			}
			
			%>
				<td>涉爆人员</td>
				<td><%=hetonghua6 %></td>
				<td><%=shichanghua6 %></td>
				<td><%=jijiexing6 %></td>
				<td><%=zaijiuye6 %></td>
				<td><%=laowuyonggong6 %></td>
			</tr>
			<tr class="even">
			<%
			String hetonghua7 = "0";
			String shichanghua7 = "0";
			String zaijiuye7 = "0";
			String laowuyonggong7 = "0";
			String jijiexing7 = "0";
			
			String sql7 = "select count(hp.employee_id) num,cc.employee_gz type from (select hr.employee_id,hr.employee_gz from comm_human_employee_hr hr union select la.labor_id,la.if_engineer from bgp_comm_human_labor la) cc join "+types[6]+" hp on cc.employee_id=hp.employee_id where hp.bsflag='0' group by cc.employee_gz ";
			List list7 = BeanFactory.getQueryJdbcDAO().queryRecords(sql7);
			if(list7!=null&&list7.size()!=0){
				for(int i=0;i<list7.size();i++){
					Map map = (Map)list7.get(i);
					String type = map.get("type")==null?"":(String)map.get("type");
					if(type.equals("0110000019000000001")){
						hetonghua7 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000019000000002")){
						shichanghua7 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000001")){
						zaijiuye7 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000003")){
						laowuyonggong7 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000005")){
						jijiexing7 = map.get("num")==null?"0":(String)map.get("num");
					}
			}
			}
			
			%>
				<td>职业健康人员</td>
				<td><%=hetonghua7 %></td>
				<td><%=shichanghua7 %></td>
				<td><%=jijiexing7 %></td>
				<td><%=zaijiuye7 %></td>
				<td><%=laowuyonggong7 %></td>
			</tr>
			<tr class="odd">
			<%
			String hetonghua8 = "0";
			String shichanghua8 = "0";
			String zaijiuye8 = "0";
			String laowuyonggong8 = "0";
			String jijiexing8 = "0";
			
			String sql8 = "select count(hp.employee_id) num,cc.employee_gz type from (select hr.employee_id,hr.employee_gz from comm_human_employee_hr hr union select la.labor_id,la.if_engineer from bgp_comm_human_labor la) cc join "+types[7]+" hp on cc.employee_id=hp.employee_id where hp.bsflag='0' group by cc.employee_gz ";
			List list8 = BeanFactory.getQueryJdbcDAO().queryRecords(sql8);
			if(list8!=null&&list8.size()!=0){
				for(int i=0;i<list8.size();i++){
					Map map = (Map)list8.get(i);
					String type = map.get("type")==null?"":(String)map.get("type");
					if(type.equals("0110000019000000001")){
						hetonghua8 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000019000000002")){
						shichanghua8 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000001")){
						zaijiuye8 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000003")){
						laowuyonggong8 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000005")){
						jijiexing8 = map.get("num")==null?"0":(String)map.get("num");
					}
			}
			}
			
			%>
				<td>医护人员</td>
				<td><%=hetonghua8 %></td>
				<td><%=shichanghua8 %></td>
				<td><%=jijiexing8 %></td>
				<td><%=zaijiuye8 %></td>
				<td><%=laowuyonggong8 %></td>
			</tr>
			<tr class="even">
			<%
			String hetonghua9 = "0";
			String shichanghua9 = "0";
			String zaijiuye9 = "0";
			String laowuyonggong9 = "0";
			String jijiexing9 = "0";
			
			String sql9 = "select count(hp.employee_id) num,cc.employee_gz type from (select hr.employee_id,hr.employee_gz from comm_human_employee_hr hr union select la.labor_id,la.if_engineer from bgp_comm_human_labor la) cc join "+types[8]+" hp on cc.employee_id=hp.employee_id where hp.bsflag='0' group by cc.employee_gz ";
			List list9 = BeanFactory.getQueryJdbcDAO().queryRecords(sql9);
			if(list9!=null&&list9.size()!=0){
				for(int i=0;i<list9.size();i++){
					Map map = (Map)list9.get(i);
					String type = map.get("type")==null?"":(String)map.get("type");
					if(type.equals("0110000019000000001")){
						hetonghua9 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000019000000002")){
						shichanghua9 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000001")){
						zaijiuye9 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000003")){
						laowuyonggong9 = map.get("num")==null?"0":(String)map.get("num");
					}
					if(type.equals("0110000059000000005")){
						jijiexing9 = map.get("num")==null?"0":(String)map.get("num");
					}
			}
			}
			
			%>
				<td>水域施工人员</td>
				<td><%=hetonghua9 %></td>
				<td><%=shichanghua9 %></td>
				<td><%=jijiexing9 %></td>
				<td><%=zaijiuye9 %></td>
				<td><%=laowuyonggong9 %></td>
			</tr>
		</table>
</body>
</html>

