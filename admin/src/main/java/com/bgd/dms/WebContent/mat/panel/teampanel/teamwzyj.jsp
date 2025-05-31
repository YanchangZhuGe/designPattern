<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo==null||projectInfoNo==""){
		projectInfoNo = user.getProjectInfoNo();
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>

<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>项目列表</title>
<script language="javaScript">
window.gudingbiaotou='true';
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	$("#table_box").css("height",$(window).height()*0.85);
	//setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})

cruConfig.contextPath =  "<%=contextPath%>";
function refreshData(){
	var sql ='';
		sql +="select c.*,case when c.zb_value>100 then 'red' else 'green' end yj_value from (select a.label,a.jh_value,b.sj_value,case when a.jh_value='0' then 0 else cast ((b.sj_value/a.jh_value)*100 as decimal(9,2)) end zb_value from (select '炸药' label,sum(t.cost_detail_money) jh_value  from view_op_target_plan_money  t where project_info_no = '<%=projectInfoNo%>' and t.node_code ='S01001006001005')a inner join (select '炸药' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end sj_value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and (i.coding_code_id like'1091%' or i.coding_code_id like'1905%')and d.project_info_no='<%=projectInfoNo%>')b on a.label=b.label)c";
		sql +=" union all";
		sql +=" select c.*,case when c.zb_value>100 then 'red' else 'green' end yj_value from (select a.label,a.jh_value,b.sj_value,case when a.jh_value='0' then 0 else cast ((b.sj_value/a.jh_value)*100 as decimal(9,2)) end zb_value from (select '雷管' label,sum(t.cost_detail_money) jh_value  from view_op_target_plan_money  t where project_info_no = '<%=projectInfoNo%>' and t.node_code ='S01001006001002')a inner join (select '雷管' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end sj_value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'1903%'and d.project_info_no='<%=projectInfoNo%>')b on a.label=b.label)c";
		sql +=" union all";
		sql +=" select c.*,case when c.zb_value>100 then 'red' else 'green' end yj_value from (select a.label,a.jh_value,b.sj_value,case when a.jh_value='0' then 0 else cast ((b.sj_value/a.jh_value)*100 as decimal(9,2)) end zb_value from (select '油品' label,sum(t.cost_detail_money) jh_value  from view_op_target_plan_money  t where project_info_no = '<%=projectInfoNo%>' and (t.node_code = 'S01001006004001001' or t.node_code = 'S01001006004001002' or t.node_code = 'S01001006004001003001'))a inner join (select '油品' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end sj_value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'07%'and d.project_info_no='<%=projectInfoNo%>')b on a.label=b.label)c";
		sql += " union all";
		sql +=" select c.*,case when c.zb_value>100 then 'red' else 'green' end yj_value from (select a.label,a.jh_value,b.sj_value,case when a.jh_value='0' then 0 else cast ((b.sj_value/a.jh_value)*100 as decimal(9,2)) end zb_value from (select '磁带' label,sum(t.cost_detail_money) jh_value  from view_op_target_plan_money  t where project_info_no = '<%=projectInfoNo%>' and t.node_code ='S01001006001001')a inner join (select '磁带' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end sj_value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'36070205%'and d.project_info_no='<%=projectInfoNo%>')b on a.label = b.label)c";
		sql +=" union all";
		sql +=" select c.*,case when c.zb_value>100 then 'red' else 'green' end yj_value from (select a.label,a.jh_value,b.sj_value,case when a.jh_value='0' then 0 else cast ((b.sj_value/a.jh_value)*100 as decimal(9,2)) end zb_value from (select '被覆线' label,sum(t.cost_detail_money) jh_value  from view_op_target_plan_money  t where project_info_no = '<%=projectInfoNo%>' and t.node_code ='S01001006001003')a inner join (select '被覆线' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end sj_value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and i.coding_code_id like'32019904'and d.project_info_no='<%=projectInfoNo%>')b on a.label=b.label)c";
		sql +=" union all";
		sql +=" select c.*,case when c.zb_value>100 then 'red' else 'green' end yj_value from (select a.label,a.jh_value,b.sj_value,case when a.jh_value='0' then 0 else cast ((b.sj_value/a.jh_value)*100 as decimal(9,2)) end zb_value from (select '配件' label,sum(t.cost_detail_money) jh_value  from view_op_target_plan_money  t where project_info_no = '<%=projectInfoNo%>' and (t.node_code ='S01001004001002' or t.node_code ='S01001004001003'))a inner join (select '配件' label, case when sum(d.total_money) is null then 0 else sum(d.total_money) end sj_value  from GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id where d.bsflag='0'and (i.coding_code_id like '37%' or i.coding_code_id like '47%'or i.coding_code_id like '48%'or i.coding_code_id like '02%'or i.coding_code_id like '51%'or i.coding_code_id like '28%'or i.coding_code_id like '55%'or i.coding_code_id like '56%'or i.coding_code_id like '57%'or i.coding_code_id like '58%')and d.project_info_no='<%=projectInfoNo%>')b on a.label=b.label)c";
		
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = sql;
	cruConfig.currentPageUrl = "/mat/panel/wtcwycz.jsp";
	queryData(1);
}
</script>
</head>
<body onload="refreshData()" style="background:#fff">
<div id="list_table">
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			        <td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{label}">物资分类</td>
					<td class="bt_info_even" exp="{jh_value}">计划消耗(元)</td>
					<td class="bt_info_odd" exp="{sj_value}">实际消耗(元)</td>
					<td class="bt_info_even" exp="{zb_value}">占比(%)</td>
					<td class="bt_info_odd" exp="<img src='<%=contextPath%>/pm/projectHealthInfo/head{yj_value}.jpg' style='cursor: pointer;'  width='14px' height='14px'/> ">预警</td>
			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
			<div class="lashen" id="line"></div>
</div>
</body>
</html>