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
  <title>多项目-设备台账管理-设备档案查询-单机消耗记录查看子页面</title> 
 </head> 
  <body style="background:#F1F2F3;width:98%" onload="refreshData()">
  <input type="hidden" name="export_name"  id="export_name" value="设备单机材料消耗记录"/>
      	<div id="list_table">
      	<table width="100%" border="0" cellspacing="0" cellpadding="0">
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
			</table>
			<div id="table_box">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable" >		
			     <tr>
					<td class="bt_info_odd" autoOrder="1">序号</td>
						<td class="bt_info_even" exp="{project_name}">项目名称</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_model}">设备型号</td>
					<td class="bt_info_even" exp="{self_num}">自编号</td>
					<td class="bt_info_even" exp="{teammat_out_id}">计划单号</td>
					<td class="bt_info_odd" exp="{material_name}">材料名称</td>
					<td class="bt_info_even" exp="{material_coding}">材料编号</td>
					<td class="bt_info_odd" exp="{unit_price}">单价</td>
					<td class="bt_info_even" exp="{out_num}">出库数量</td>
					<td class="bt_info_odd" exp="{material_amout}">消耗数量</td>
					<td class="bt_info_even" exp="{total_charge}">总价</td>
					<td class="bt_info_even" exp="{modifi_date}">填报日期</td>
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

	function refreshData(){
		var str = "select info.modifi_date,pro.project_name,acc.dev_name,acc.dev_model,acc.self_num,acc.dev_coding,acc.license_num,acc.asset_coding,info.teammat_out_id,";
			str += "info.material_name,info.material_coding,nvl(info.unit_price,0) unit_price,nvl(info.out_num,0) out_num,nvl(info.material_amout,0) material_amout,";
			str += "nvl(info.total_charge,0) total_charge from bgp_comm_device_repair_detail info left join gms_device_archive_detail arc on arc.dev_archive_refid = info.repair_detail_id ";
			str += "left join gms_device_account acc on acc.dev_acc_id = arc.dev_acc_id left join gp_task_project pro on arc.project_info_id = pro.project_info_no ";
			str += "where arc.dev_archive_type = '3' and arc.dev_acc_id='"+devaccid+"' and to_char(info.modifi_date,'yyyy')='"+projectinfoid+"' order by pro.project_name, seqinfo desc ";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
</script>
</html>