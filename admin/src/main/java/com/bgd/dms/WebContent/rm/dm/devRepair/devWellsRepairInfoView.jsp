<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String repair_info=request.getParameter("repairinfo");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

  <title>多项目-设备维修-井中设备维修-维修明细子页面-维修子页面</title> 
 </head>
<body style="background:#cdddef" onload="refreshData()">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width: 100%">
    <div id="new_table_box_bg" style="width: 95%">
      <fieldset><legend>维修记录</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>					    
			<td class="inquire_item6">设备名称</td>
			<td class="inquire_form6">
				<input id="dev_name" name="dev_name" class="input_width"  type="text" readonly/>
			</td>
			<td class="inquire_item6">规格型号</td>
			<td class="inquire_form6"><input id="dev_model" name="dev_model"  class="input_width" type="text" readonly/></td>
			<td class="inquire_item6">自编号</td>
			<td class="inquire_form6"><input id="self_num" name="self_num"  class="input_width" type="text" readonly/></td>
		  </tr>
		  <tr>			
			<td class="inquire_item6">牌照号</td>
			<td class="inquire_form6"><input name="license_num" id="license_num"  class="input_width" type="text" readonly /></td>
			<td class="inquire_item6">实物标识号</td>
			<td class="inquire_form6"><input name="dev_sign" id="dev_sign"  class="input_width" type="text" readonly /></td>
			<td class="inquire_item6">ERP编号</td>
			<td class="inquire_form6"><input name="dev_coding" id="dev_coding"  class="input_width" type="text" readonly /></td>
		  </tr>		 	
	   	  <tr>
		    <td class="inquire_item6" >送修日期</td>
			<td class="inquire_form6"><input name="REPAIR_START_DATE" id="REPAIR_START_DATE" class="input_width" type="text" readonly />
			</td>
			<td class="inquire_item6" >截止日期</td>
			<td class="inquire_form6"><input id="REPAIR_END_DATE" name="REPAIR_END_DATE" class="input_width" type="text" readonly />
			</td>
			<td class="inquire_item6" >检测费(元)</td>
			<td class="inquire_form6"><input name="CHECK_COST" id="CHECK_COST" class="input_width" type="text" value="0" readonly/></td>		
		  </tr>
		  <tr>
		   <td class="inquire_item6" >工时数(天)</td>
		   <td class="inquire_form6"><input name="WORK_HOUR" id="WORK_HOUR" class="input_width" type="text" value="0" /></td>
		   <td class="inquire_item6" >工时费(元)</td>
			<td class="inquire_form6"><input name="HUMAN_COST" id="HUMAN_COST" class="input_width" type="text" value="0" readonly/></td>		
			<td class="inquire_item6" >材料费(元)</td>
			<td class="inquire_form6"><input id="MATERIAL_COST" name="MATERIAL_COST" class="input_width" type="text" value="0" readonly/></td>
		  </tr>
		  <tr>
		   <td class="inquire_item6" >维修合计金额</td>
			<td class="inquire_form6"><input name="TOTAL_COST" id="TOTAL_COST" class="input_width" type="text" value="0" readonly/></td>
		  </tr>	
		   <tr>
		   <td class="inquire_item6" >修理详情</td>
			<td class="inquire_form6" colspan="5">
				<textarea id="REPAIR_DETAIL" name="REPAIR_DETAIL" rows="10" cols="90"  readonly></textarea>
			</td>
		  </tr>			
	  </table>	  
	  </fieldset>	
	</div>	
  </div>
	   
</div>
</form>
</body>
<script type="text/javascript"> 
	var repair_info='<%=repair_info%>';

	function refreshData(){

			var querySql = "select info.repair_info,info.repair_start_date,info.repair_end_date,(info.check_cost+info.material_cost+info.human_cost) as total_cost,info.repair_detail,info.check_cost,info.work_hour,info.material_cost,info.human_cost,b.dev_name,b.dev_model,b.self_num,b.license_num,b.dev_sign,b.dev_coding ";
			   querySql += "from bgp_comm_device_repair_info info left join gms_device_account_dui b on info.device_account_id=b.dev_acc_id ";
			   querySql += "left join gms_device_backapp_detail backdet on info.devback_repair_id = backdet.device_backapp_id and info.device_account_id = backdet.dev_acc_id ";
			   querySql += "where info.repair_info='"+repair_info+"' ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
				basedatas = queryRet.datas;
				$("#dev_name")[0].value=basedatas[0].dev_name;
				$("#dev_model")[0].value=basedatas[0].dev_model;
				$("#self_num")[0].value=basedatas[0].self_num;
				$("#license_num")[0].value=basedatas[0].license_num;
				$("#dev_coding")[0].value=basedatas[0].dev_coding;
				$("#dev_sign")[0].value=basedatas[0].dev_sign;
				$("#CHECK_COST")[0].value=basedatas[0].check_cost;
				$("#WORK_HOUR")[0].value=basedatas[0].work_hour;
				$("#HUMAN_COST")[0].value=basedatas[0].human_cost;
				$("#MATERIAL_COST")[0].value=basedatas[0].material_cost;
				$("#REPAIR_DETAIL")[0].value=basedatas[0].repair_detail;
				$("#TOTAL_COST")[0].value=basedatas[0].total_cost;
				$("#REPAIR_START_DATE")[0].value=basedatas[0].repair_start_date;
				$("#REPAIR_END_DATE")[0].value=basedatas[0].repair_end_date;

	}
</script>
</html>
 