<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String devaccid = request.getParameter("devaccid");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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

<title>单项目-外租离场-确定离场按钮页面</title>
</head>
<body class="bgColor_f3f3f3" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<input type="hidden" id="detail_count" value="" />
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <fieldset style="margin:2px;padding:2px;"><legend>外租设备离场信息</legend>
      <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
         <tr>
				<td class="inquire_item6">设备名称</td>
				<td class="inquire_form6"><input id="dev_name" name="dev_name"  class="input_width" type="text" readonly/></td>
				<td class="inquire_item6">规格型号</td>
				<td class="inquire_form6"><input id="dev_model" name="dev_model" class="input_width" type="text" readonly/></td>
				<td class="inquire_item6">在队数量</td>
				<td class="inquire_form6"><input id="unuse_num" name="unuse_num" class="input_width" type="text" readonly/></td>
			  </tr>
				<tr>
				<td class="inquire_item6">资产状况</td>
				<td class="inquire_form6"><input id="account_state" name="account_state" class="input_width" type="text" readonly/></td>
				<td class="inquire_item6">计划进场时间</td>
				<td class="inquire_form6"><input id="planning_in_time" name="planning_in_time" class="input_width" type="text" readonly/></td>
				<td class="inquire_item6">实际进场时间</td>
				<td class="inquire_form6"><input id="actual_in_time" name="actual_in_time" class="input_width" type="text" readonly/></td>
			  </tr>
			  <tr>
				<td class="inquire_item6">计划离场时间</td>
				<td class="inquire_form6"><input id="planning_out_time" name="planning_out_time" class="input_width" type="text" readonly/></td>
				<td class="inquire_item6">实际离场时间</td>
				<td class="inquire_form6">
					<input id="actual_out_time" name="actual_out_time" class="input_width" type="text" readonly/><img src='<%=contextPath%>/images/calendar.gif' id='tributton2' width='16' height='16' style='cursor: hand;' onmouseover='calDateSelector(actual_out_time,tributton2);'/>
				</td>
				<td class="inquire_item6"></td>
				<td class="inquire_form6">
					<input id="dev_acc_id" name="dev_acc_id" class="input_width" type="hidden" />
					<input id="total_num" name="total_num" class="input_width" type="hidden" />
						<input id="use_num" name="use_num" class="input_width" type="hidden" />
							<input id="fk_dev_acc_id" name="fk_dev_acc_id" class="input_width" type="hidden" />
					<input id="project_info_no" name="project_info_no" class="input_width" type="hidden" />
				</td>
			  </tr>
      </table>
      </fieldset>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript"> 
	var devaccId="";
	var projectInfoNo="";
	function loadDataDetail(){
		var devaccid = '<%=devaccid%>';
		var retObj;
		if(devaccid!=null){
			var str = "select account.dev_acc_id,account.project_info_id, account.total_num,  account.unuse_num,   account.use_num, ";
			str += "account.actual_in_time,account.planning_out_time,account.actual_out_time, ";
			str += "account.dev_name,account.dev_model,account.fk_dev_acc_id,account.planning_in_time,account.is_leaving,";
			str += "case account.is_leaving when '0' then '未离场' else '已离场' end as is_leaving_desc,sd.coding_name as account_stat_desc ";
			str += "from gms_device_coll_account_dui account ";
			str += "left join comm_coding_sort_detail sd on sd.coding_code_id = account.account_stat ";
			str += "where  account.account_stat='0110000013000000005' ";
			str += "and account.dev_acc_id='"+devaccid+"'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
	        retObj = queryRet.datas;
		}
		$("#dev_name").val(retObj[0].dev_name);
		$("#dev_model").val(retObj[0].dev_model);
		$("#unuse_num").val(retObj[0].unuse_num);
		$("#total_num").val(retObj[0].total_num);
		$("#use_num").val(retObj[0].use_num);
		$("#planning_in_time").val(retObj[0].planning_in_time);
		$("#actual_in_time").val(retObj[0].actual_in_time);
		$("#planning_out_time").val(retObj[0].planning_out_time);
		$("#actual_out_time").val(retObj[0].actual_out_time);
		
		$("#account_state").val(retObj[0].account_stat_desc);
		$("#dev_acc_id").val(retObj[0].dev_acc_id);
		$("#fk_dev_acc_id").val(retObj[0].fk_dev_acc_id);
		
		$("#project_info_no").val(retObj[0].project_info_id);
	}
	function submitInfo(){
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveRentDevLeftJBQInfo.srq";
		document.getElementById("form1").submit();
	}
</script>
</html>

