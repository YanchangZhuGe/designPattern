<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String device_mix_id = request.getParameter("device_mix_id");
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
  <title>设备类型的调配调剂</title> 
 </head>
<body style="background:#fff" onload="refreshData()">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset><legend>调配数量信息</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>
			<td class="inquire_item6">项目名称</td>
			<td class="inquire_form6">
				<input id="pro_name" name="pro_name" class="input_width" type="text" readonly/>
				<input id="device_mix_id" name="device_mix_id" class="input_width" type="hidden" value='<%=device_mix_id%>'/>
			</td>
			<td class="inquire_item6">班组</td>
			<td class="inquire_form6">
				<input id="teamname" name="teamname" class="input_width" type="text" readonly/>
				<input id="teamid" name="teamid" type="hidden"/>
				<input id="team" name="team" class="input_width" type="hidden" readonly/>
				<input id="purpose" name="purpose" type="hidden"/>
			</td>
		  </tr>
		  <tr>
			<td class="inquire_item6">设备名称</td>
			<td class="inquire_form6">
				<input id="dev_ci_code" name="dev_ci_code" class="input_width" type="hidden"/>
				<input id="dev_name" name="dev_name" class="input_width" type="text" readonly/>
			</td>
			<td class="inquire_item6">规格型号</td>
			<td class="inquire_form6">
				<input id="dev_type" name="dev_type" class="input_width" type="text" readonly/>
			</td>
		  </tr>
			<tr>
			<td class="inquire_item6">计划开始时间</td>
			<td class="inquire_form6"><input name="plan_start_date" id="plan_start_date" class="input_width" type="text" readonly /></td>
			<td class="inquire_item6">计划结束时间</td>
			<td class="inquire_form6"><input name="plan_end_date" id="plan_end_date" class="input_width" type="text" readonly /></td>
		  </tr>
		  <tr>
			<td class="inquire_item6" style="color:#FF0033">调配数量</td>
			<td class="inquire_form6"><input name="assign_detailnum" id="assign_detailnum" class="input_width" type="text" readonly /></td>
		  </tr>
	  </table>
	  </fieldset>
	  <fieldset><legend>调配明细信息</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
       <tr>
		<td class="bt_info_odd" width="14%">设备编号</td>
		<td class="bt_info_even" width="12%">设备名称</td>
		<td class="bt_info_odd" width="14%">规格型号</td>
		<td class="bt_info_even" width="10%">自编号</td>
		<td class="bt_info_odd" width="9%">牌照号</td>
		<td class="bt_info_even" width="10%">实物标识号</td>
		<td class="bt_info_odd" width="4%">数量</td>
	   </tr>
	   <tbody id="assigndetail_body" name="assigndetail_body">
	   </tbody>
      </table>
	  </fieldset>
    </div>
    <div id="oper_div" style="margin-bottom:5px">
	 	<span id="tjbtn" class="tj_btn"><a id="tja" href="#" onclick="submitInfo()"></a></span>
	 	<span class="bc_btn"><a href="#" onclick="saveInfo()"></a></span>
	    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
	  </div>
	  <div id="oper_div2" style="margin-bottom:5px;text-align:center;" style="display:none">
	    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
	  </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	function showDevPage(trid){
		var obj = new Object();
		var dev_ci_code = $("#dev_ci_code").val();
		var deviceappmixid = $("#deviceappmixid"+trid).val();
		var condition ="and not exists(select 1 from gms_device_appmix_detail detail where detail.device_appmix_id!='"+deviceappmixid+"' and detail.dev_acc_id=account.dev_acc_id)";
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectAccountForMix.jsp?dev_ci_code="+dev_ci_code+"&condition="+condition , obj ,"dialogWidth=820px;dialogHeight=380px");
		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split('~');
			//返回信息是 队级台账id + 设备编码 + 设备名称 + 规格型号 + 自编号 + 实物标识号 + 牌照号
			$("input[name='dev_acc_id"+trid+"']","#assigndetail_body").val(returnvalues[0]);
			$("input[name='asset_coding"+trid+"']","#assigndetail_body").val(returnvalues[1]);
			$("input[name='devicename"+trid+"']","#assigndetail_body").val(returnvalues[2]);
			$("input[name='devicetype"+trid+"']","#assigndetail_body").val(returnvalues[3]);
			$("input[name='self_num"+trid+"']","#assigndetail_body").val(returnvalues[4]);
			$("input[name='dev_sign"+trid+"']","#assigndetail_body").val(returnvalues[5]);
			$("input[name='license_num"+trid+"']","#assigndetail_body").val(returnvalues[6]);
			$("input[name='num"+trid+"']","#assigndetail_body").val("1");
		}
	}
	function saveInfo(){
		//明细提交
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveDevMixDetailInfo.srq?state=0";
		document.getElementById("form1").submit();
	}
	function submitInfo(){
		//明细提交
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveDevMixDetailInfo.srq?state=9";
		document.getElementById("form1").submit();
	}
</script>
<script type="text/javascript">
	var device_mix_id = '<%=device_mix_id%>';
	function refreshData(){
		//通过SQL查询
		var retObj;
		var basedatas;
		if(device_mix_id!=null){
			//查询基本信息
			var querySql = "select pro.project_name,det.device_app_detid,det.project_info_no,teamsd.coding_name as teamname, ";
			querySql += "det.teamid,det.team,det.dev_ci_code, ci.dev_ci_name, ci.dev_ci_model,det.plan_start_date,det.plan_end_date,";
			querySql += "employee.employee_name,approveemp.employee_name as approve_name,det.purpose,";
			querySql += "mixmain.device_mix_id,mixmain.assign_num,mixmainemp.employee_name as assign_emp_name,mixmain.is_print_form ";
			querySql += "from gms_device_app_detail det left join gms_device_app devapp on det.device_app_id=devapp.device_app_id ";
			querySql += "left join comm_coding_sort_detail teamsd on det.team = teamsd.coding_code_id ";
			querySql += "left join gp_task_project pro on det.project_info_no=pro.project_info_no ";
			querySql += "left join gms_device_codeinfo ci on det.dev_ci_code=ci.dev_ci_code ";
			querySql += "left join gms_device_appmix_main mixmain on mixmain.device_app_detid = det.device_app_detid ";
			querySql += "left join comm_human_employee mixmainemp on mixmain.assign_emp_id = mixmainemp.employee_id ";
			querySql += "left join comm_human_employee employee on det.employee_id=employee.employee_id ";
			querySql += "left join comm_human_employee approveemp on det.approve_id=approveemp.employee_id ";
			querySql += "where devapp.bsflag='0' and mixmain.device_mix_id='<%=device_mix_id%>' and mixmain.state='9' ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
		}
		var printformflag;
		if(basedatas!=undefined&&basedatas.length==1){
			$("#pro_name").val(basedatas[0].project_name);
			$("#teamid").val(basedatas[0].teamid);
			$("#team").val(basedatas[0].team);
			$("#teamname").val(basedatas[0].teamname);
			$("#dev_ci_code").val(basedatas[0].dev_ci_code);
			$("#dev_name").val(basedatas[0].dev_ci_name);
			$("#dev_type").val(basedatas[0].dev_ci_model);
			$("#plan_start_date").val(basedatas[0].plan_start_date);
			$("#plan_end_date").val(basedatas[0].plan_end_date);
			$("#assign_detailnum").val(basedatas[0].assign_num);
			$("#purpose").val(basedatas[0].purpose);
			printformflag = basedatas[0].is_print_form;
		}
		var tr_num = parseInt($("#assign_detailnum").val());
		for(var tr_id=0;tr_id<tr_num;tr_id++){
			var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"' is_added='false'>";
			innerhtml += "<td><input name='asset_coding"+tr_id+"' id='asset_coding"+tr_id+"' style='line-height:18px;width:80%' value='' readonly/><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showDevPage("+tr_id+")' /></td>";
			innerhtml += "<td><input name='devicename"+tr_id+"' id='devicename"+tr_id+"' value='' style='line-height:18px;width:99%' type='text' readonly/></td>";
			innerhtml += "<td><input name='devicetype"+tr_id+"' id='devicetype"+tr_id+"' value='' style='line-height:18px;width:99%' type='text' readonly/></td>";
			innerhtml += "<td><input name='dev_acc_id"+tr_id+"' id='dev_acc_id"+tr_id+"' type='hidden'/>";
			innerhtml += "<input name='self_num"+tr_id+"' id='self_num"+tr_id+"' style='line-height:18px;width:99%' type='text' readonly/></td>";
			innerhtml += "<input name='deviceappmixid"+tr_id+"' id='deviceappmixid"+tr_id+"' value='' type='hidden'/></td>";
			innerhtml += "<td><input name='license_num"+tr_id+"' id='license_num"+tr_id+"' value='' style='line-height:18px;width:99%' type='text' readonly/></td>";
			innerhtml += "<td><input name='dev_sign"+tr_id+"' id='dev_sign"+tr_id+"' style='line-height:18px;width:99%' type='text' readonly/></td>";
			innerhtml += "<td align='center'><input name='num"+tr_id+"' id='num"+tr_id+"' value='' style='line-height:18px;width:99%' type='text' readonly/></td>";
			innerhtml += "</tr>";
			$("#assigndetail_body").append(innerhtml);
		}
		$("#assigndetail_body>tr:odd>td:odd").addClass("odd_odd");
		$("#assigndetail_body>tr:odd>td:even").addClass("odd_even");
		$("#assigndetail_body>tr:even>td:odd").addClass("even_odd");
		$("#assigndetail_body>tr:even>td:even").addClass("even_even");
		if(device_mix_id!=null){
			//查询已保存的设备信息
			var prosql = "select amd.device_appmix_id, amd.dev_acc_id, amd.asset_coding, ";
				prosql += "amd.self_num, amd.dev_sign, amd.license_num, amd.state,account.dev_name,account.dev_model ";
				prosql += "from gms_device_appmix_detail amd ";
				prosql += "left join gms_device_account account on amd.dev_acc_id=account.dev_acc_id ";
				prosql += "where amd.device_mix_id='"+device_mix_id+"'";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
			retObj = proqueryRet.datas;
		}
		//如果已经提交过，那么只能查看
		var state = retObj[0].state;
		//如果已开据了调配单，那么不能再修改 ||printformflag=='Y'
		if(state == '9'||printformflag=='Y'){
			$("#oper_div").hide();
			$("#oper_div2").show();
		}
		//回填明细信息，便于保存操作
		for(var added_tr_id=0;added_tr_id<retObj.length;added_tr_id++){
			$("#deviceappmixid"+added_tr_id).val(retObj[added_tr_id].device_appmix_id);
			
			$("#asset_coding"+added_tr_id).val(retObj[added_tr_id].asset_coding);
			$("#devicename"+added_tr_id).val(retObj[added_tr_id].dev_name);
			$("#devicetype"+added_tr_id).val(retObj[added_tr_id].dev_model);
			$("#dev_acc_id"+added_tr_id).val(retObj[added_tr_id].dev_acc_id);
			$("#self_num"+added_tr_id).val(retObj[added_tr_id].self_num);
			$("#license_num"+added_tr_id).val(retObj[added_tr_id].license_num);
			$("#dev_sign"+added_tr_id).val(retObj[added_tr_id].dev_sign);
			$("#num"+added_tr_id).val(1);
		}
	}
</script>
</html>
 