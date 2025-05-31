<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String id = request.getParameter("id");
	String mixId = request.getParameter("mixId");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
  <link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
  <link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
  <link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
  <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/json2.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>  
<title>设备接收明细</title>
</head>
<body class="bgColor_f3f3f3" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<input type="hidden" id="detail_count" value="" />
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
		<fieldset style="margin-left:2px"><legend>设备基本信息</legend>
	      <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	         <tr>
				<td class="inquire_item6">设备名称</td>
				<td class="inquire_form6">
					<input id="dev_dev_name" name=""  class="input_width" type="text" />
					<input id="mixId" name="mixId"  class="input_width" type="hidden" value="<%=mixId%>" />
				</td>
				<td class="inquire_item6">规格型号</td>
				<td class="inquire_form6"><input id="dev_dev_model" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">班组</td>
				<td class="inquire_form6">
					<input id="dev_team" name="" class="input_width" type="text" />
					<input id="team" name="team" type="hidden" />
				</td>
			 </tr>
			 <tr>
				<td class="inquire_item6">自编号</td>
				<td class="inquire_form6"><input id="dev_self_num" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">牌照号</td>
				<td class="inquire_form6"><input id="dev_license_num" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">实物标识号</td>
				<td class="inquire_form6"><input id="dev_dev_sign" name="" class="input_width" type="text" /></td>
			 </tr>
			 <tr>
			 	<td class="inquire_item6">计量单位</td>
				<td class="inquire_form6"><input id="dev_dev_unit" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">存放地</td>
				<td class="inquire_form6"><input id="dev_position" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">用途</td>
				<td class="inquire_form6"><input id="dev_purpose" name="dev_purpose" class="input_width" type="text" /></td>
			 </tr>
			 <tr>
				<td class="inquire_item6">计划进场时间</td>
				<td class="inquire_form6"><input id="dev_plan_start_date" name="dev_plan_start_date" class="input_width" type="text" /></td>
				<td class="inquire_item6">计划离场时间</td>
				<td class="inquire_form6">
					<input id="dev_plan_end_date" name="dev_plan_end_date" class="input_width" type="text" />
					<input id="dev_in_org" name="dev_in_org" class="input_width" type="hidden" />
					<input id="dev_out_org" name="dev_out_org" class="input_width" type="hidden" />
				</td>
			  </tr>
	      </table>
	    </fieldset>  
	    <fieldset style="margin-left:2px"><legend>接收确认信息</legend>
	      <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	      	<tr>
				<td class="inquire_item6">实际进场时间</td>
				<td class="inquire_form6">
					<input type="text" name="actual_start_date" id="actual_start_date" value="" readonly="readonly" class="input_width"/>
					<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(actual_start_date,tributton1);" />
					<input type="hidden" name="team_dev_acc_id" id="team_dev_acc_id" value="" />
				</td>
				<td class="inquire_item6">&nbsp;</td>
				<td class="inquire_form6">&nbsp;</td>
				<td class="inquire_form6">&nbsp;</td>
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
	$().ready(function(){
		$("#addProcess").click(function(){
			tr_id = $("#processtable>tbody>tr:last").attr("id");
			if(tr_id != undefined){
				tr_id = parseInt(tr_id.substr(2,1),10);
			}
			if(tr_id == undefined){
				tr_id = 0;
			}else{
				tr_id = tr_id+1;
			}
			//统计本次的总行数
			$("#detail_count").val(tr_id);
			//动态新增表格
			var innerhtml = "<tr id = 'tr"+tr_id+"' ><td><input type='checkbox' name='idinfo' id='"+tr_id+"'/><input name='devicename"+tr_id+"' value='通过设备编码树选择设备名称' size='12' type='text'/></td><td><input name='devicetype"+tr_id+"' class='input_width' value='设备名称带出类型' size='12' type='text'/></td><td><input name='signtype"+tr_id+"' class='input_width' value='名称和类型带出类别' size='12' type='text'/></td><td><input name='unit"+tr_id+"' class='input_width' type='text'/></td><td><input name='neednum"+tr_id+"' class='input_width' value='' size='8' type='text'/></td><td><input name='team"+tr_id+"' class='input_width' type='text'/></td><td><input name='purpose"+tr_id+"' class='input_width' value='' size='8' type='text'/></td><td><input name='startdate"+tr_id+"' class='input_width' type='text'/></td><td><input name='enddate"+tr_id+"' class='input_width' type='text'/></td></tr>";
			
			$("#processtable").append(innerhtml);
			if(tr_id%2 == 0){
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:odd").addClass("odd_odd");
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:even").addClass("odd_even");
			}else{
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:odd").addClass("even_odd");
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:even").addClass("even_even");
			}
		});
		$("#delProcess").click(function(){
			$("input[name='idinfo']").each(function(){
				if(this.checked){
					var selected_id = this.id;
					$('#tr'+selected_id).remove();
				}
			});
		});
	});
	var devaccId="";
	var projectInfoNo="";
	function loadDataDetail(){
		
		var device_mix_detid = '<%=id%>';
		
		if(device_mix_detid!=null){
		    var querysql="select plan.maintenance_cycle,mif.project_info_no,dad.*,";
		    	querysql+="da.dev_name,da.dev_model,unit.coding_name as dev_unit,da.dev_position,teamid.coding_name as team_name,mif.in_org_id,mif.out_org_id ";
		    	querysql+="from gms_device_appmix_detail dad ";
				querysql+="left join gms_device_appmix_main dam on dam.device_mix_subid =dad.device_mix_subid ";
				querysql+="left join gms_device_mixinfo_form mif on mif.device_mixinfo_id =dam.device_mixinfo_id ";
				querysql+="left join gms_device_account da on dad.dev_acc_id = da.dev_acc_id ";
				querysql+="left join gms_device_maintenance_plan plan on da.dev_acc_id = plan.dev_acc_id ";
				querysql+="left join comm_coding_sort_detail teamid on dad.team=teamid.coding_code_id ";
				querysql+="left join comm_coding_sort_detail unit on da.dev_unit=unit.coding_code_id ";
				querysql+="where dad.device_mix_detid='"+device_mix_detid+"'";
				queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querysql);
		    retObj = queryRet.datas;
			document.getElementById("dev_dev_name").value =retObj[0].dev_name;
			document.getElementById("dev_dev_model").value =retObj[0].dev_model;
			document.getElementById("dev_dev_unit").value =retObj[0].dev_unit;
			document.getElementById("dev_self_num").value =retObj[0].self_num;
			document.getElementById("dev_license_num").value =retObj[0].license_num;
			document.getElementById("dev_dev_sign").value =retObj[0].dev_sign;
			document.getElementById("dev_position").value =retObj[0].dev_position;
			document.getElementById("dev_team").value =retObj[0].team_name;
			document.getElementById("dev_purpose").value =retObj[0].purpose;
			document.getElementById("team").value =retObj[0].team;
			document.getElementById("dev_plan_start_date").value =retObj[0].dev_plan_start_date;
			document.getElementById("dev_plan_end_date").value =retObj[0].dev_plan_end_date;
			//默认时间为原接收时间 -- 给台账ID也拿出来
			document.getElementById("actual_start_date").value = retObj[0].actual_in_time;
			document.getElementById("team_dev_acc_id").value = retObj[0].team_dev_acc_id;
			//转出转入信息
			document.getElementById("dev_in_org").value =retObj[0].in_org_id;
			document.getElementById("dev_out_org").value =retObj[0].out_org_id;
			devaccId = retObj[0].dev_acc_id;			
			projectInfoNo=retObj[0].project_info_no;
			
		}
	}
	function submitInfo(){
	    var id = '<%=request.getParameter("id")%>';
	    
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toReSubmitReceive.srq?id="+id+"&devaccId="+devaccId+"&projectInfoNo="+projectInfoNo;
		document.getElementById("form1").submit();
	}
</script>
</html>

