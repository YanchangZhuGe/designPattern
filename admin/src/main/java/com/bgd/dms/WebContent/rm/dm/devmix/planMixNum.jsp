<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String device_app_detid = request.getParameter("device_app_detid");
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
  <title>设备类型的调配数量</title> 
 </head>
<body style="background:#fff" onload="refreshData()">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:750px">
  <div id="new_table_box_content">
    <div id="new_table_box_bg" style="height:420px">
      <fieldset><legend>申请信息</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>
			<td class="inquire_item6">项目名称</td>
			<td class="inquire_form6">
				<input id="pro_name" name="pro_name" class="input_width" type="text" readonly/>
				<input id="project_info_no" name="project_info_no" type="hidden" value=''/>
				<input id="dev_app_detid" name="dev_app_detid" class="input_width" type="hidden" value='<%=device_app_detid%>'/>
			</td>
			<td class="inquire_item6">班组</td>
			<td class="inquire_form6">
				<input id="teamname" name="teamname" class="input_width" type="text" readonly/>
				<input id="team" name="team" class="input_width" type="hidden" readonly/>
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
			<td class="inquire_item6" style="color:#FF0033">申请数量</td>
			<td class="inquire_form6"><input name="apply_num" id="apply_num" class="input_width" type="text" readonly /></td>
			<td class="inquire_item6" style="color:#FF0033">已调配数量</td>
			<td class="inquire_form6"><input id="mixed_num" name="mixed_num" class="input_width" type="text" readonly /></td>
		  </tr>
	  </table>
	  </fieldset>
	  <fieldset><legend>已调配信息</legend>
      <div id="inq_tool_box">
      	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
		    <td background="<%=contextPath%>/images/list_15.png">
			 <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali3">转出单位</td>
			    <td class="ali1"><input id="s_device_app_no" name="s_device_app_no" type="text" onkeypress="simpleRefreshData()"/></td>
			    <td class="ali3">状态</td>
			    <td class="ali1"><input id="s_project_name" name="s_project_name" type="text" onkeypress="simpleRefreshData()"/></td>
			    <td>&nbsp;</td>
			    <td><span class="cx"><a href="#" onclick="javascript:$('#modify_table').show();"></a></span></td>
			    <td><span class="zj"><a href="#" onclick="showNewInfo();"></a></span></td>
			    <td><span class="xg"><a href="#" onclick="showModifyInfo();"></a></span></td>
			  </tr>
			 </table>
			</td>
		    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
		  </tr>
		</table>
	  </div>
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
       <tr>
        <td class="bt_info_odd" width="5%">选择</td>
		<td class="bt_info_even" width="5%">序号</td>
		<td class="bt_info_odd" width="20%">转入单位</td>
		<td class="bt_info_even" width="20%">转出单位</td>
		<td class="bt_info_odd" width="8%">调配数量</td>
		<td class="bt_info_odd" width="10%">调配人</td>
		<td class="bt_info_even" width="8%">状态</td>
	   </tr>
	   <tbody id="assign_body" name="assign_body">
	   </tbody>
      </table>
	  </fieldset>
	  <div id="modify_table" style="display:none">
	  <fieldset><legend>调配基础信息</legend>
	  	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>
			<td class="inquire_item6">转入单位</td>
			<td class="inquire_form6">
				<input name="in_org_name" id="in_org_name" class="input_width" type="text" value="" readonly="readonly"/>
				<input name="in_org_id" id="in_org_id" class="input_width" type="hidden" value="" />
				<input name="in_org_name_info" id="in_org_name_info" class="input_width" type="hidden" value="" readonly="readonly"/>
				<input name="in_org_id_info" id="in_org_id_info" class="input_width" type="hidden" value="" />
				<input name="device_mix_id" id="device_mix_id" class="input_width" type="hidden" value="" />
			</td>
			<td class="inquire_item6">转出单位</td>
			<td class="inquire_form6">
				<input name="out_org_name" id="out_org_name" class="input_width" type="text" value="<%=user.getOrgName()%>" readonly="readonly"/><img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOrgPage()"  />
				<input name="out_org_id" id="out_org_id" class="input_width" type="hidden" value="<%=user.getOrgId()%>" />
			</td>
		  </tr>
		  <tr>
			<td class="inquire_item6" style="color:#FF0033">调配数量</td>
			<td class="inquire_form6">
				<input id="assign_num" name="assign_num" class="input_width" value="" type="text" style='color:#FF0000' onkeyup='checkAssignNum(this)'/>
				<input id="assign_num_old" name="assign_num_old" class="input_width" value="" type="hidden"/>
				<input id="assigned_num" name="assigned_num" class="input_width" value="" type="hidden"/>
			</td>
			<td class="inquire_item6">调配人</td>
			<td class="inquire_form6">
				<input name="assign_emp_name" id="assign_emp_name" class="input_width" value="<%=user.getUserName()%>" type="text" readonly="readonly"/>
				<input name="assign_emp_id" id="assign_emp_id" value="<%=user.getEmpId()%>" type="hidden"/>
			</td>
		  </tr>
	  </table>
	  <div id="oper_div" style="margin-bottom:5px">
	 	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
	 	<span class="bc_btn"><a href="#" onclick="saveInfo()"></a></span>
	    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
	  </div>
	  </fieldset>
	  </div>
	  </div>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript"> 
	function showOrgPage(){
		var obj = new Object();
		window.showModalDialog("<%=contextPath%>/common/selectOrg.jsp",obj);
		if(obj.value!=undefined){
			$("#out_org_name").val(obj.value)
			$("#out_org_id").val(obj.fkValue)
		}
	}
	function showNewInfo(){
		$("#device_mix_id").val("");
		$("#in_org_name").val($("#in_org_name_info").val());
		$("#in_org_id").val($("#in_org_id_info").val());
		
		$("#modify_table").show();
	}
	function showModifyInfo(){
		var s_device_mix_id ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				s_device_mix_id = this.value;
			}
		});
		if(s_device_mix_id!=undefined){
			var proSql = "select amm.device_mix_id,amm.device_appdet_id,amm.project_info_id,amm.in_org_id,inorg.org_name as in_org_name,amm.out_org_id,outorg.org_name as out_org_name,amm.assign_num,amm.mixed_num,amm.assign_emp_id,emp.employee_name as assign_emp_name,amm.state from gms_device_appmix_main amm left join comm_org_information inorg on amm.in_org_id=inorg.org_id left join comm_org_information outorg on amm.out_org_id=outorg.org_id left join comm_human_employee emp on amm.assign_emp_id=emp.employee_id where amm.device_mix_id='"+s_device_mix_id+"'";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql);
			retObj = proqueryRet.datas[0];
			$("#device_mix_id").val(retObj.device_mix_id);
			$("#in_org_id").val(retObj.in_org_id);
			$("#in_org_name").val(retObj.in_org_name);
			$("#out_org_id").val(retObj.out_org_id);
			$("#out_org_name").val(retObj.out_org_name);
			$("#assign_num").val(retObj.assign_num);
			$("#assign_num_old").val(retObj.assign_num);
			$("#modify_table").show();
		}
	}
	function checkAssignNum(obj){
		var device_mix_id = $("#device_mix_id").val();
		var proSql = "select sum(assign_num) as mixed_num from gms_device_appmix_main where device_app_detid='<%=device_app_detid%>' ";
		if(device_mix_id!=null&&device_mix_id!=""){
			proSql += "and device_mix_id!='"+device_mix_id+"'";
		}
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql);
		var mixed_num = parseInt(proqueryRet.datas[0].mixed_num==""?0:proqueryRet.datas[0].mixed_num , 10);
		var value = obj.value;
		var re = /^\+?[1-9][0-9]*$/;
		if(value=="")
			return;
		if(!re.test(value)){
			alert("调配数量必须为数字，且大于0!");
			$("#assign_num").val($("#assign_num_old").val());
        	return false;
		}else{
			if(parseInt(value,10)>parseInt($("#apply_num").val(),10)){
				alert("调配数量必须小于等于审批数量!");
				$("#assign_num").val($("#assign_num_old").val());
				return false;
			}else if((parseInt(value,10)+mixed_num)>parseInt($("#apply_num").val())){
				
				alert("调配数量必须小于等于未调配数量!");
				$("#assign_num").val($("#assign_num_old").val());
				return false;
			}
		}
	}
	function saveInfo(){
		//调配数量保存
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveDevMixNumInfo.srq?state=0";
		document.getElementById("form1").submit();
	}
	function submitInfo(){
		if(confirm("提交后数据不能修改，确认提交?")){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveDevMixNumInfo.srq?state=9";
			document.getElementById("form1").submit();
		}
	}
</script>
<script type="text/javascript">
	var device_app_detid = '<%=device_app_detid%>';
	function refreshData(){
		var retObj;
		var basedatas;
		if(device_app_detid!=null){
			var querySql = "select pro.project_name,det.device_app_detid,teamsd.coding_name as teamname,";
				querySql += "det.project_info_no,det.teamid,sd.coding_name as unitname,";
				querySql += "ci.dev_ci_name,ci.dev_ci_model,det.apply_num,det.team,det.purpose,det.employee_id,";
				querySql += "det.plan_start_date,det.plan_end_date,employee.employee_name,nvl(tmp.assigned_num,0) as assigned_num,";
				querySql += "devapp.app_org_id as in_org_id,org.org_name as in_org_name ";
				querySql += "from gms_device_app_detail det ";
				querySql += "left join comm_coding_sort_detail teamsd on det.team = teamsd.coding_code_id ";
				querySql += "left join gms_device_app devapp on det.device_app_id = devapp.device_app_id ";
				querySql += "left join comm_org_information org on devapp.app_org_id = org.org_id ";
				querySql += "left join gp_task_project pro on det.project_info_no = pro.project_info_no ";
				querySql += "left join gms_device_codeinfo ci on det.dev_ci_code = ci.dev_ci_code ";
				querySql += "left join comm_coding_sort_detail sd on det.unitinfo = sd.coding_code_id ";
				querySql += "left join (select mixmain.device_app_detid, sum(assign_num) as assigned_num ";
				querySql += "from gms_device_appmix_main mixmain group by device_app_detid) tmp ";
				querySql += "on tmp.device_app_detid = det.device_app_detid ";
				querySql += "left join comm_human_employee employee on det.employee_id = employee.employee_id ";
				querySql += "where devapp.bsflag='0' and det.device_app_detid='"+device_app_detid+"'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
		}
		if(basedatas!=undefined&&basedatas.length==1){
			$("#pro_name").val(basedatas[0].project_name);
			$("#project_info_no").val(basedatas[0].project_info_no);
			$("#team").val(basedatas[0].team);
			$("#teamname").val(basedatas[0].teamname);
			$("#dev_ci_code").val(basedatas[0].dev_ci_code);
			$("#dev_name").val(basedatas[0].dev_ci_name);
			$("#dev_type").val(basedatas[0].dev_ci_model);
			$("#plan_start_date").val(basedatas[0].plan_start_date);
			$("#plan_end_date").val(basedatas[0].plan_end_date);
			$("#apply_num").val(basedatas[0].apply_num);
			//新建的in_org信息
			$("#in_org_name_info").val(basedatas[0].in_org_name);
			$("#in_org_id_info").val(basedatas[0].in_org_id);
			//设置已调配数量
			$("#mixed_num").val(basedatas[0].assigned_num==""?0:basedatas[0].assigned_num);
		}
		if(device_app_detid!=null){
			//查询已分配的设备信息
			var proSql = "select amm.device_mix_id, amm.device_app_detid, amm.project_info_no,";
				proSql += "amm.in_org_id, inorg.org_name as in_org_name, amm.out_org_id, outorg.org_name as out_org_name,";
				proSql += "amm.assign_num, amm.assign_emp_id, emp.employee_name as assign_emp_name, amm.state,";
				proSql += "case amm.state when '0' then '未提交' else '已提交' end as state_desc ";
				proSql += "from gms_device_appmix_main amm ";
				proSql += "left join comm_org_information inorg on amm.in_org_id = inorg.org_id ";
				proSql += "left join comm_org_information outorg on amm.out_org_id = outorg.org_id ";
				proSql += "left join comm_human_employee emp on amm.assign_emp_id = emp.employee_id "; 
				proSql += "where amm.device_app_detid='"+device_app_detid+"' "; 
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql);
			retObj = proqueryRet.datas;
		}
		//给查询出来的数据放到列表中
		for(var added_tr_id=0;added_tr_id<retObj.length;added_tr_id++){
			var state = retObj[added_tr_id].state;
			var checkboxValid ="";
			var clickBtnValid = "onclick='choseOnlyOneRec(this)'";
			if(state=='9'){
				checkboxValid = "disabled";
				clickBtnValid = "";
			}
			//TODO 增加已调配信息的列表显示
			var innerhtml = "<tr id='tr"+added_tr_id+"' name='tr"+added_tr_id+"' seq='"+added_tr_id+"'>";
			innerhtml += "<td><input type='checkbox' name='selectedbox' id='selectedbox_"+retObj[added_tr_id].device_mix_id+"' value='"+retObj[added_tr_id].device_mix_id+"' "+clickBtnValid+" "+checkboxValid+" /></td>";
			innerhtml += "<td>"+(added_tr_id+1)+"</td>";
			innerhtml += "<td>"+retObj[added_tr_id].in_org_name+"</td>";
			innerhtml += "<td>"+retObj[added_tr_id].out_org_name+"</td>";
			innerhtml += "<td>"+retObj[added_tr_id].assign_num+"</td>";
			innerhtml += "<td>"+retObj[added_tr_id].assign_emp_name+"</td>";
			innerhtml += "<td>"+retObj[added_tr_id].state_desc+"</td>";
			innerhtml += "</tr>";
			$("#assign_body").append(innerhtml);
		}
		$("#assign_body>tr:odd>td:odd").addClass("odd_odd");
		$("#assign_body>tr:odd>td:even").addClass("odd_even");
		$("#assign_body>tr:even>td:odd").addClass("even_odd");
		$("#assign_body>tr:even>td:even").addClass("even_even");
	}
	function choseOnlyOneRec(obj){
		var device_mix_id = obj.value;
		//选中这一条checkbox
		$("#selectedbox_"+device_mix_id).attr("checked",'true');
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+device_mix_id+"']").removeAttr("checked");
	} 
</script>
</html>
 