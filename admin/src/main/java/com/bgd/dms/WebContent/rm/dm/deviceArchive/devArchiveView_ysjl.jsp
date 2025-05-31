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
  <title>多项目-设备台账管理-设备档案查询-油水记录查看子页面</title> 
 </head> 
  <body style="background:#F1F2F3;width:98%;overflow:auto;" onload="refreshData()">
  	<input type="hidden" name="export_name"  id="export_name" value="设备油品消耗记录"/> 
      	<div id="list_table">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
			</table>
			<div id="table_box">
			  <table width="98%"  border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable" style='float:auto'>		
			     <tr>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{project_name}">项目名称</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_model}">设备型号</td>
					<td class="bt_info_even" exp="{self_num}">自编号</td>
					<td class="bt_info_even" exp="{fill_date}">加注日期</td>
					<td class="bt_info_odd" exp="{oil_name}">油品名称</td>
					<td class="bt_info_even" exp="{actual_price}">单价(元)</td>
					<td class="bt_info_odd" exp="{oil_num}">数量(升)</td>
					<td class="bt_info_even" exp="{total_money}">金额(元)</td>
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
		var str = "select pro.project_name,acc.dev_name,acc.dev_model,acc.self_num,acc.license_num,acc.dev_sign,acc.dev_coding,acc.asset_coding,";
			str += "i.wz_name as oil_name,t.outmat_date as fill_date,d.oil_num,d.actual_price,d.total_money ";
			str += "from gms_mat_teammat_out t left join GMS_MAT_TEAMMAT_OUT_DETAIL d on t.teammat_out_id = d.teammat_out_id and t.bsflag = '0' ";
			str += "left join gms_device_account_dui acc on acc.dev_acc_id = d.dev_acc_id left join gms_mat_infomation i on d.wz_id = i.wz_id ";
			str += "left join gp_task_project pro on t.project_info_no = pro.project_info_no  left join gms_device_account ac on ac.dev_acc_id=acc.fk_dev_acc_id   ";
			str += "where t.out_type = '3' and ac.dev_acc_id='"+devaccid+"' and to_char(d.modifi_date,'yyyy')='"+projectinfoid+"' order by t.outmat_date desc ";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
</script>
</html>