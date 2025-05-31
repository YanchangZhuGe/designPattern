<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@page import="java.util.ResourceBundle"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String devaccid = request.getParameter("devaccid");
	String projectinfoid = request.getParameter("projectinfoid");
	String year = request.getParameter("year");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>多项目-设备台账管理-设备档案查询-维修记录查看子页面</title> 
 </head> 
  <body style="background:#F1F2F3;width:98%" onload="refreshData()">
  <input type="hidden" name="export_name"  id="export_name" value="设备强制保养记录"/> 
      	<div id="list_table">
      	<table width="100%" border="0" cellspacing="0" cellpadding="0">
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
			</table>
			<div id="table_box">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable" style='float:auto'>		
			     <tr>
					<td class="bt_info_odd" autoOrder="1">序号</td>
						<td class="bt_info_even" exp="{project_name}">项目名称</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_model}">设备型号</td>
					<td class="bt_info_even" exp="{self_num}">自编号</td>
					<td class="bt_info_even" exp="{repairtype}">修理类别</td>
					<td class="bt_info_odd" exp="{repairitem}">修理项目</td>
					<td class="bt_info_even" exp="{repair_detail}">修理详情</td>
					<td class="bt_info_odd" exp="{repair_start_date}">保养日期</td>
					<td class="bt_info_odd" exp="{human_cost}">工时费</td>
					<td class="bt_info_even" exp="{material_cost}">材料费</td>
			     </tr>
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
 
<script type="text/javascript">
$(function(){
	$(window).resize(function(){
		
		if(lashened==0){
			$("#table_box").css("height",$(window).height()*0.75);
		}
		$("#tab_box .tab_box_content").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-10);
		$("#tab_box .tab_box_content").each(function(){
			if($(this).children('iframe').length > 0){
				$(this).css('overflow-y','hidden');
			}
		});
	});
})
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';

	var devaccid = "<%=devaccid%>";
	var projectinfoid = "<%=projectinfoid%>";
	var year="<%=year%>";
	
	function refreshData(){
		var str = "select pro.project_name,acc.dev_name,acc.dev_model,acc.self_num,acc.license_num,acc.dev_sign,acc.dev_coding,acc.asset_coding,";
			str += "det1.coding_name as repairtype,det2.coding_name as repairitem,info.repair_detail,info.repair_start_date,";
			str += "info.repair_end_date,nvl(info.human_cost,0) human_cost,nvl(info.material_cost,0) material_cost,info.repairer,info.accepter from BGP_COMM_DEVICE_REPAIR_INFO info ";
			str += " left join gms_device_account_dui acc ";
			str += "on acc.dev_acc_id = info.device_account_id  left join gp_task_project pro on acc.project_info_id = pro.project_info_no ";
			str += "  left join comm_coding_sort_detail det1 on det1.coding_code_id = info.repair_type ";
			str += "left join comm_coding_sort_detail det2 on det2.coding_code_id = info.repair_item ";
			str += "where acc.fk_dev_acc_id='"+devaccid+"' and to_char(to_date(info.modifi_date,'yyyy-mm-dd'),'yyyy')='"+year+"'";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
</script>
</html>