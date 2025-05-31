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
  <title>多项目-设备台账管理-设备档案查询-运转记录查看子页面</title> 
 </head> 
  <body style="background:#F1F2F3;width:98%;overflow:auto" onload="refreshData()">
      	<div id="list_table">
      		<div id="inq_tool_box">
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" ></td>
			  </div>
			<div id="table_box">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable" style='float:auto'>		
			     <tr id='dev_acc_id_head' name='dev_acc_id'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{dev_acc_id}' id='selectedbox_{dev_acc_id}' />" >
			     		<input type='checkbox' name='selectedboxAll' id='selectedboxAll'/>
			     	</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_model}">设备型号</td>
					<td class="bt_info_even" exp="{self_num}">自编号</td>
					<td class="bt_info_odd" exp="{license_num}">牌照号</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_odd" exp="{dev_coding}">ERP设备编号</td>
					<td class="bt_info_even" exp="{modify_date}">填报时间</td>
					<td class="bt_info_odd" exp="{mileage}">里程(公里)</td>
					<td class="bt_info_even" exp="{drilling_footage}">钻井进尺(米)</td>
					<td class="bt_info_odd" exp="{work_hour}">工作小时(小时)</td>
			     </tr>
			    <tbody id="detaillist" name="detaillist" >
			   </tbody>
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
		 </div>
</body>
 
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';

	var devaccid = "<%=devaccid%>";

	function refreshData(){
		var str = "select dui.dev_name,dui.dev_model,dui.self_num,dui.license_num,dui.dev_coding,dui.dev_sign,"
			str += "t.operation_info_id,t.dev_acc_id,t.modify_date,nvl(t.mileage,0) mileage,nvl(t.drilling_footage,0) drilling_footage,";
			str += "nvl(t.work_hour,0) work_hour from gms_device_operation_info t ";
			str += "left join gms_device_account_dui dui on dui.dev_acc_id=t.dev_acc_id ";
			str += "where t.dev_acc_id='"+devaccid+"' order by t.modify_date desc ";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
</script>
</html>