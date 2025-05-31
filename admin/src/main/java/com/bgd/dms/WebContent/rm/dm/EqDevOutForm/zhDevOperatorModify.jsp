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
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>多项目-设备出库-设备出库(综合物化探)-查看明细子页面-修改操作手子页面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData()">
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
					<input id="dev_dev_name" name="dev_dev_name"  class="input_width" type="text" readonly/>
					<input id="dev_acc_id" name="dev_acc_id"  class="input_width" type="hidden" />
					<input id="dev_new_acc_id" name="dev_new_acc_id"  class="input_width" type="hidden" />
					<input id="dev_asset_coding" name="dev_asset_coding"  class="input_width" type="hidden" />
					<input id="dev_dev_code" name="dev_dev_code"  class="input_width" type="hidden" />
					<input id="out_org_id" name="out_org_id"  class="input_width" type="hidden" />
					<input id="in_org_id" name="in_org_id"  class="input_width" type="hidden" />
					<input id="in_sub_id" name="in_sub_id"  class="input_width" type="hidden" />
					<input id="device_mix_detid" name="device_mix_detid" class="input_width" type="hidden" />
					<input id="device_mixinfo_id" name="device_mixinfo_id" class="input_width" type="hidden" />
					<input id="device_mix_subid" name="device_mix_subid" class="input_width" type="hidden" />
				</td>
				<td class="inquire_item6">规格型号</td>
				<td class="inquire_form6">
					<input id="dev_dev_model" name="dev_dev_model" class="input_width" type="text" readonly/>
					<img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showDevPage()' />
				</td>
				<td class="inquire_item6">班组</td>
				<td class="inquire_form6">
					<input id="dev_team" name="" class="input_width" type="text" readonly/>
					<input id="team" name="team" type="hidden" />
				</td>
			 </tr>
			 <tr>
				<td class="inquire_item6">自编号</td>
				<td class="inquire_form6"><input id="dev_self_num" name="dev_self_num" class="input_width" type="text" readonly/></td>
				<td class="inquire_item6">牌照号</td>
				<td class="inquire_form6"><input id="dev_license_num" name="dev_license_num" class="input_width" type="text" readonly/></td>
				<td class="inquire_item6">实物标识号</td>
				<td class="inquire_form6"><input id="dev_dev_sign" name="dev_dev_sign" class="input_width" type="text" readonly/></td>
			 </tr>
			 <tr>
				<td class="inquire_item6">用途</td>
				<td class="inquire_form6"><input id="dev_purpose" name="dev_purpose" class="input_width" type="text" readonly/></td>
				<td class="inquire_item6">计划进场时间</td>
				<td class="inquire_form6"><input id="dev_plan_start_date" name="dev_plan_start_date" class="input_width" type="text" readonly/></td>
				<td class="inquire_item6">计划离场时间</td>
				<td class="inquire_form6">
					<input id="dev_plan_end_date" name="dev_plan_end_date" class="input_width" type="text" readonly/>
				</td>
			 </tr>
			 <!-- <tr>
				<td class="inquire_item6">操作员</td>
				<td class="inquire_form6"><input id="operator_name" name="operator_name" class="input_width" type="text" />
				<input id="operator_id" name="operator_id" class="input_width" type="hidden" />
				<input id="operator_new_id" name="operator_new_id" class="input_width" type="hidden" />
				<input id="device_mix_detid" name="device_mix_detid" class="input_width" type="hidden" />
				<input id="device_mixinfo_id" name="device_mixinfo_id" class="input_width" type="hidden" />
				<input id="device_mix_subid" name="device_mix_subid" class="input_width" type="hidden" />
				<img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showOperPage(this)' />
				</td>
			  </tr> -->
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
	var projectInfoNo="";
	function refreshData(){
		
		var device_mix_detid = '<%=id%>';
		
		if(device_mix_detid!=null){
		    var querysql="select da.self_num as acc_self_num,da.license_num as acc_license_num,da.dev_sign as acc_dev_sign,da.dev_model as acc_dev_model,mif.project_info_no,dad.*,mif.device_mixinfo_id, ";
		    	querysql+="da.dev_name,da.dev_model,unit.coding_name as dev_unit,da.dev_position,teamid.coding_name as team_name, ";
		    	querysql+="mif.in_org_id,sub.org_subjection_id as in_sub_id, mif.out_org_id from gms_device_appmix_detail dad ";
				querysql+="left join gms_device_appmix_main dam on dam.device_mix_subid =dad.device_mix_subid ";
				querysql+="left join gms_device_mixinfo_form mif on mif.device_mixinfo_id =dam.device_mixinfo_id ";
				querysql+="left join comm_org_subjection sub on mif.in_org_id = sub.org_id ";
				querysql+="left join gms_device_account da on dad.dev_acc_id = da.dev_acc_id ";
				querysql+="left join gms_device_maintenance_plan plan on da.dev_acc_id = plan.dev_acc_id ";
				querysql+="left join comm_coding_sort_detail teamid on dad.team=teamid.coding_code_id ";
				querysql+="left join comm_coding_sort_detail unit on da.dev_unit=unit.coding_code_id ";
				//querysql+="left join comm_human_employee e on e.employee_id = dad.operator_id ";
				querysql+="where dad.device_mix_detid='"+device_mix_detid+"'";
				queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querysql);
		    retObj = queryRet.datas;
			document.getElementById("dev_dev_name").value =retObj[0].dev_name;
			document.getElementById("dev_dev_model").value =retObj[0].dev_model;
			document.getElementById("dev_acc_id").value =retObj[0].dev_acc_id;
			document.getElementById("dev_self_num").value =retObj[0].acc_self_num;
			document.getElementById("dev_license_num").value =retObj[0].acc_license_num;
			document.getElementById("dev_dev_sign").value =retObj[0].acc_dev_sign;
			document.getElementById("dev_team").value =retObj[0].team_name;
			document.getElementById("dev_purpose").value =retObj[0].purpose;
			document.getElementById("team").value =retObj[0].team;
			document.getElementById("dev_plan_start_date").value =retObj[0].dev_plan_start_date;
			document.getElementById("dev_plan_end_date").value =retObj[0].dev_plan_end_date;
			//document.getElementById("operator_name").value =retObj[0].operator_name;
			//document.getElementById("operator_id").value =retObj[0].operator_id;
			document.getElementById("device_mix_detid").value =retObj[0].device_mix_detid;
			document.getElementById("device_mixinfo_id").value =retObj[0].device_mixinfo_id;
			document.getElementById("device_mix_subid").value =retObj[0].device_mix_subid;
			document.getElementById("out_org_id").value =retObj[0].out_org_id;
			document.getElementById("in_org_id").value =retObj[0].in_org_id;
			document.getElementById("in_sub_id").value =retObj[0].in_sub_id;
			
			projectInfoNo=retObj[0].project_info_no;
			
		}
	}
	function submitInfo(){
		var devaccid = $("#dev_acc_id").val();
		var devnewaccid = $("#dev_new_acc_id").val();
		//var operatorid = $("#operator_id").val();
		//var operatornewid = $("#operator_new_id").val();

		if(devaccid==devnewaccid || devnewaccid==''){
			alert("无修改操作！");
			return;
		}

		if(window.confirm("确认修改?")){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toModifyDevOperator.srq";
			document.getElementById("form1").submit();
		}	
	}

	//选择操作手
	function showOperPage(trid){
		var project_info_id = $("#project_info_no").val();
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/device-xd/searchZHOperatorList.jsp?project_info_id="+project_info_id,obj,"dialogWidth=880px;dialogHeight=480px");
		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split('~');
			document.getElementById("operator_new_id").value = returnvalues[0];
			document.getElementById("operator_name").value = returnvalues[1];
		}
	}
	//选择更换设备
	function showDevPage(trid,devcicode,isdevicecode,devicename){
		var obj = new Object();
		var pageselectedstr = null;
		var checkstr = 0;
		$("input[name^='dev_acc_id'][type='hidden']").each(function(i){
			if(this.value!=null&&this.value!=''){
				if(checkstr == 0){
					pageselectedstr = "'"+this.value;
				}else{
					pageselectedstr += "','"+this.value;
				}
				checkstr++;
			}
		});
		if(pageselectedstr!=null){
			pageselectedstr = pageselectedstr + "'";
		}
		obj.pageselectedstr = pageselectedstr;
		//回头加上转出单位
		var out_org_id = $("#out_org_id").val();
		var dialogurl = "<%=contextPath%>/rm/dm/tree/selectAccountForMix.jsp?out_org_id="+out_org_id;
		dialogurl = encodeURI(dialogurl);
		dialogurl = encodeURI(dialogurl);
		var vReturnValue = window.showModalDialog(dialogurl , obj ,"dialogWidth=950px;dialogHeight=480px");
		if(vReturnValue!=undefined){
			//返回信息是 队级台账id + AMIS资产编号+ 设备名称 + 规格型号 + 自编号 + 实物标识号 + 牌照号  + 设备编码
			var returnvalues = vReturnValue.split('~');
			document.getElementById("dev_new_acc_id").value = returnvalues[0];
			document.getElementById("dev_asset_coding").value = returnvalues[1];
			document.getElementById("dev_dev_name").value = returnvalues[2];			
			document.getElementById("dev_dev_model").value = returnvalues[3];
			document.getElementById("dev_self_num").value = returnvalues[4];
			document.getElementById("dev_dev_sign").value = returnvalues[5];
			document.getElementById("dev_license_num").value = returnvalues[6];			
			document.getElementById("dev_dev_code").value = returnvalues[7];
		}   
	}
</script>
</html>

