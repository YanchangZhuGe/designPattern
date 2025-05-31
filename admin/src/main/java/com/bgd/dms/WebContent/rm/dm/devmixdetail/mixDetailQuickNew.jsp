<%@page contentType="text/html;charset=UTF-8" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String devicemixids = request.getParameter("devicemixids");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getEmpId();
	String userName = user.getUserName();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>快捷添加调配单</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldSet style="margin-left:2px"><legend>调配单基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">项目名称</td>
          <td class="inquire_form4">
          	<input name="project_name" id="project_name" class="input_width" type="text" value="" readonly/>
          	<input name="project_info_no" id="project_info_no" class="input_width" type="hidden" value=""/>
          </td>
          <td class="inquire_item4">申请单号:</td>
          <td class="inquire_form4"><input name="device_app_no" id="device_app_no" class="input_width" type="text" value=""/ readonly></td>
        </tr>
        <tr>
          <td class="inquire_item4">开据人</td>
          <td class="inquire_form4">
          	<input name="print_emp_name" id="print_emp_name" class="input_width" type="text" value="<%=userName%>" readonly/>
          	<input name="print_emp_id" id="print_emp_id" class="input_width" type="hidden" value="<%=empId%>" readonly/>
          </td>
          <td class="inquire_item4">调拨单号:</td>
          <td class="inquire_form4"><input name="mixinfo_no" id="mixinfo_no" class="input_width" type="text" value="提交后自动生成..." readonly/></td>
        </tr>
        <tr>
          <td class="inquire_item4">转入单位:</td>
          <td class="inquire_form4">
          	<input name="in_org_name" id="in_org_name" class="input_width" type="text" readonly/>
          	<input name="in_org_id" id="in_org_id" class="input_width" type="hidden" />
          </td>
          <td class="inquire_item4">转出单位</td>
          <td class="inquire_form4">
          	<input name="out_org_name" id="out_org_name" class="input_width" type="text" value="" readonly/>
          	<input name="out_org_id" id="out_org_id" class="input_width" value="" type="hidden" />
          </td>
        </tr>
      </table>
      </fieldSet>
	  <fieldSet style="margin-left:2px"><legend>设备明细信息</legend>
		  <div style="overflow:auto">
		  <table width="99%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	       <tr>
				<td class="bt_info_odd" width="11%">设备编码</td>
				<td class="bt_info_even" width="11%">设备名称</td>
				<td class="bt_info_odd" width="11%">规格型号</td>
				<td class="bt_info_even" width="11%">自编号</td>
				<td class="bt_info_odd" width="11%">实物标识号</td>
				<td class="bt_info_even" width="11%">牌照号</td>
				<td class="bt_info_odd" width="8%">数量</td>
				<td class="bt_info_even" width="13%">计划进场时间</td>
				<td class="bt_info_odd" width="13%">计划离场时间</td>
			</tr>
		   <tbody id="detailtable" name="detailtable">
		   </tbody>
	      </table>
	      </div>
	    </fieldSet>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
     	<span class="bc_btn"><a href="#" onclick="saveInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript"> 
	var mdmids ="<%=devicemixids%>"
	function saveInfo(){
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveMDFInfo.srq?state=0&mdmids="+mdmids;
		document.getElementById("form1").submit();
	}
	
	function submitInfo(){
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveMDFInfo.srq?state=9&mdmids="+mdmids;
		document.getElementById("form1").submit();
	}
	
	function showInOrgIdPage(devappid){
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/devmixdetail/selectInOrgId.jsp?devappid="+devappid,obj,"dialogWidth=305px;dialogHeight=420px");
		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split('~');
			$("#in_org_id").val(returnvalues[0]);
			$("#in_org_name").val(returnvalues[1]);
		}
	}
	function refreshData(){
		var retObj;
		if("<%=devicemixids%>"!=null){
			var prosql = "select amd.device_appmix_id, amd.dev_acc_id, amd.asset_coding,amd.dev_plan_start_date,amd.dev_plan_end_date, ";
				prosql += "amd.self_num, amd.dev_sign, amd.license_num, amd.state,account.dev_name,account.dev_model, ";
				prosql += "amm.device_mix_id,amm.in_org_id,amm.out_org_id,inorg.org_name as in_org_name,outorg.org_name as out_org_name, ";
				prosql += "devapp.device_app_no,devapp.project_info_no,pro.project_name ";
				prosql += "from gms_device_appmix_detail amd ";
				prosql += "left join gms_device_account account on amd.dev_acc_id=account.dev_acc_id ";
				prosql += "left join gms_device_appmix_main amm on amm.device_mix_id=amd.device_mix_id ";
				prosql += "left join comm_org_information inorg on amm.in_org_id=inorg.org_id ";
				prosql += "left join comm_org_information outorg on amm.out_org_id=outorg.org_id ";
				prosql += "left join gms_device_app_detail ad on amm.device_app_detid=ad.device_app_detid ";
				prosql += "left join gms_device_app devapp on devapp.device_app_id=ad.device_app_id ";
				prosql += "left join gp_task_project pro on pro.project_info_no=devapp.project_info_no ";
				prosql += "where amd.device_mix_id  in <%=devicemixids%> ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
			retObj = proqueryRet.datas;
		}
		if(retObj.length>0){
			$("#project_name").val(retObj[0].project_name);
			$("#project_info_no").val(retObj[0].project_info_no);
			$("#device_app_no").val(retObj[0].device_app_no);
			$("#in_org_name").val(retObj[0].in_org_name);
			$("#in_org_id").val(retObj[0].in_org_id);
			$("#out_org_name").val(retObj[0].out_org_name);
			$("#out_org_id").val(retObj[0].out_org_id);
			for(var index=0;index<retObj.length;index++){
				var innerhtml = "<tr id='tr"+retObj[index].device_appmix_id+"' name='tr' mdminfo='"+retObj[index].device_mix_id+"'>";
				innerhtml += "<td>"+retObj[index].asset_coding+"</td>";
				innerhtml += "<td>"+retObj[index].dev_name+"</td>";
				innerhtml += "<td>"+retObj[index].dev_model+"</td>";
				innerhtml += "<td>"+retObj[index].self_num+"</td>";
				innerhtml += "<td>"+retObj[index].dev_sign+"</td>";
				innerhtml += "<td>"+retObj[index].license_num+"</td>";
				innerhtml += "<td>1</td>";
				innerhtml += "<td>"+retObj[index].dev_plan_start_date+"</td>";
				innerhtml += "<td>"+retObj[index].dev_plan_end_date+"</td>";
				innerhtml += "</tr>";
				$("#detailtable").append(innerhtml);
			}
			$("#detailtable>tr:odd>td:odd").addClass("odd_odd");
			$("#detailtable>tr:odd>td:even").addClass("odd_even");
			$("#detailtable>tr:even>td:odd").addClass("even_odd");
			$("#detailtable>tr:even>td:even").addClass("even_even");
		}
	}
</script>
</html>

