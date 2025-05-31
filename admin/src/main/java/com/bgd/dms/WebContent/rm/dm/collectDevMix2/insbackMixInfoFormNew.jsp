<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String devappid = request.getParameter("devappid");
	String oprstate = request.getParameter("oprstate");
	UserToken user = OMSMVCUtil.getUserToken(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<style type="text/css">
	.FixedTitleRow
        {
            position: relative; 
            top: expression(this.offsetParent.scrollTop); 
            z-index: 1;
			background-color: #E6ECF0;
        }
</style>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>(自有设备)返还调配单添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:96%">
      <fieldset style="margin-left:2px"><legend >基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >返还调配单号:</td>
          <td class="inquire_form4" >
          	<input name="mixinfo_no" id="mixinfo_no" class="input_width" type="text"  value="保存后自动生成..." readonly/>
          </td>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text"  value="" readonly/>
          	<input name="project_info_no" id="project_info_no" class="input_width" type="hidden"  value="" />
          	<input name="devicebackappid" id="devicebackappid" type="hidden" value="<%=devappid%>" />
          	<input name="mix_org_id" id="mix_org_id" type="hidden" value="" />
          </td>
          <td class="inquire_item4" ></td><td class="inquire_form4" ></td>
        </tr>
        <tr>
          <td class="inquire_item4" >返还申请单号:</td>
          <td class="inquire_form4" >
          	<input name="device_backapp_no" id="device_backapp_no" class="input_width" type="text"  value="" readonly/>
          </td>
          <td class="inquire_item4" >返还申请时间:</td>
          <td class="inquire_form4" >
          	<input name="back_date" id="back_date" class="input_width" type="text"  value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >返还申请单位:</td>
          <td class="inquire_form4" >
          	<input name="in_org_name" id="in_org_name" class="input_width" type="text"  value="" readonly/>
          	<input name="in_org_id" id="in_org_id" class="input_width" type="hidden"  value="" />
          </td>
          <td class="inquire_item4" >设备接收单位:</td>
          <td class="inquire_form4" >
          	<input name="own_org_name" id="own_org_name" class="input_width" type="text"  value="" readonly/><img id="show-btn" src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOrgTreePage('own_org')" />
          	<input name="own_org_id" id="own_org_id" class="input_width" type="hidden"  value="" />
          </td>
        </tr>
      </table>
      </fieldset>
      <!-- <table style="width:98%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td width="5%"><span class="jl"><a href="#" id="addbtn" onclick='toMixDetailInfos()' title="填报返还明细"></a></span></td>
          <td width="95%"></td>
        </tr>
      </table> -->
      <fieldset style="margin-left:2px"><legend>调配台账明细</legend>
		<div id="tab_box" class="tab_box" style="height:190px;overflow:auto">
			<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr class="FixedTitleRow">
		       		<td class="bt_info_even" width="4%">选择</td>
					<td class="bt_info_odd" width="8%">设备名称</td>
					<td class="bt_info_even" width="11%">规格型号</td>
					<td class="bt_info_odd" width="14%">设备编号</td>
					<td class="bt_info_even" width="8%">自编号</td>
					<td class="bt_info_odd" width="11%">实物标识号</td>
					<td class="bt_info_even" width="8%">牌照号</td>
					<td class="bt_info_odd" width="8%">原出库单位</td>
					<td class="bt_info_even" width="14%">计划离场时间</td>
					<td class="bt_info_odd" width="14%">实际离场时间</td>
					<!-- <td class="bt_info_odd" width="11%">存放地</td> -->
				</tr>
			    <tbody id="detailtable" name="detailtable">
			    </tbody>
			</table>
		</div>
	  </fieldset>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo(9)"></a></span>
     	<!-- <span class="bc_btn"><a href="#" onclick="submitInfo(0)"></a></span> -->
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript"> 
var oprstate_tmp="<%=oprstate%>";
$().ready(function(){
	//已关闭的调配申请单屏蔽提交按钮
    if(oprstate_tmp == '4'){
    	$(".tj_btn").hide();      
    }
});
	function submitInfo(state){	
		var own_org_id = $("#own_org_id").val();
		if(own_org_id==''){
			alert("请选择设备接收单位!");
			return;
		}	
		//首先明细的长度不能为0
		var detailsize = $("tr","#detailtable").size();
		if(detailsize == 0){
			alert("请添加调配台账明细!");
			return;
		}

		//保留的行信息
		var count = 0;
		var line_infos;
		var idinfos ;
		$("input[type='checkbox'][name='detinfo']").each(function(){
			if(this.checked){
				if(count == 0){
					line_infos = this.id;
					idinfos = this.value;
				}else{
					line_infos += "~"+this.id;
					idinfos += "~"+this.value;
				}
				count++;
			}
		});
		if(count == 0){
			alert('请选择调配单明细信息！');
			return;
		}

		var detailcount = $("input[type='hidden'][name^='devicebackdetid']","#detailtable").size();
		//给调配单号设置成空
		$("#mixinfo_no").val("");
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveBackMDFInfoNew.srq?mixform_type=1&state="+state+"&detailcount="+detailcount;
		if(state==9 && window.confirm("提交以后数据不可修改,是否提交?")){
			document.getElementById("form1").submit();
		}else if(state==0){
			document.getElementById("form1").submit();
		}
	}
	/**
	 * 选择组织机构树
	 */
	 function showOrgTreePage(str){
			var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
			var strs= new Array(); //定义一数组
			if(!returnValue){
				return;
			}
			strs=returnValue.split("~"); //字符分割
			var names = strs[0].split(":");
			document.getElementById(str+"_name").value = names[1];
			
			var orgId = strs[1].split(":");
			document.getElementById(str+"_id").value = orgId[1];
	}
	function toMixDetailInfos(){
		
		var own_org_id = $("#own_org_id").val();
		if(own_org_id==''){
			alert("请选择设备接收单位!");
			return;
		}
		var devbackappid = $("#devicebackappid").val();
		//先清空下面的列表，再给数据回填
		$("#detailtable").empty();
		//检查设备接收单位中属于自己的设备明细，将其添加到明细中
		var str = "select ci.dev_ci_name,ci.dev_ci_model,ci.dev_ci_code,detail.device_backdet_id,detail.dev_acc_id,detail.dev_position,";
			str +="detail.dev_coding,detail.self_num,detail.dev_sign,detail.license_num,detail.planning_out_time,detail.actual_in_time ";
			str +="from gms_device_backapp_detail detail ";
			str +="join gms_device_account_dui dui on detail.dev_acc_id = dui.dev_acc_id ";
			str +="join gms_device_codeinfo ci on dui.dev_type = ci.dev_ci_code ";
			str +="where detail.device_backapp_id = '"+devbackappid+"' and detail.device_mixinfo_id is null ";//and dui.owning_org_id='"+own_org_id+"'";
		//查询设备明细并进行回填
		
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=1000');
			retObj = proqueryRet.datas;
		if(retObj!=undefined){
			for(var index=0;index<retObj.length;index++){
				//动态新增表格
				var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
				innerhtml += "<td><input type='checkbox' name='detinfo' id='"+index+"' value='"+retObj[index].device_backdet_id+"' /></td>";
				innerhtml += "<td><input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='"+retObj[index].dev_ci_name+"' size='9' type='text' readonly/>";
				innerhtml += "<input name='devicebackdetid"+index+"' id='devicebackdetid"+index+"' value='"+retObj[index].device_backdet_id+"' type='hidden' />";
				innerhtml += "<input name='devcicode"+index+"' id='devcicode"+index+"' value='"+retObj[index].dev_ci_code+"' type='hidden' /></td>";
				innerhtml += "<td><input name='devicemodel"+index+"' id='devicemodel"+index+"' value='"+retObj[index].dev_ci_model+"' size='10' type='text' readonly/></td>";
				
				innerhtml += "<td><input name='devcoding"+index+"' id='devcoding"+index+"' value='"+retObj[index].dev_coding+"' size='14' type='text' readonly/></td>";
				innerhtml += "<td><input name='selfnum"+index+"' id='selfnum"+index+"' style='line-height:15px' value='"+retObj[index].self_num+"' size='9' type='text' /></td>";
				innerhtml += "<td><input name='devsign"+index+"' id='devsign"+index+"' value='"+retObj[index].dev_sign+"' size='10'  type='text' readonly/></td>";
				innerhtml += "<td><input name='licensenum"+index+"' id='licensenum"+index+"' value='"+retObj[index].license_num+"' size='9' type='text' readonly/>";
				
				innerhtml += "<td><input name='planningouttime"+index+"' id='planningouttime"+index+"' style='line-height:15px' value='"+retObj[index].planning_out_time+"' size='14' type='text' readonly/></td>";
				innerhtml += "<td><input name='actualouttime"+index+"' id='actualouttime"+index+"' style='line-height:15px' value='"+retObj[index].actual_in_time+"' size='14' type='text' readonly/></td>";
				//innerhtml += "<td><input name='devposition"+index+"' id='devposition"+index+"' style='line-height:15px' value='"+retObj[index].dev_position+"' size='10' type='text'/></td>";
				innerhtml += "</tr>";
				
				$("#detailtable").append(innerhtml);
			}
			$("#detailtable>tr:odd>td:odd").addClass("odd_odd");
			$("#detailtable>tr:odd>td:even").addClass("odd_even");
			$("#detailtable>tr:even>td:odd").addClass("even_odd");
			$("#detailtable>tr:even>td:even").addClass("even_even");
		}
	}
	function refreshData(){
		var retObj;
		var basedatas;
		if('<%=devappid%>'!=null){
			//回填基本信息
			var str = "select devapp.device_backapp_id,devapp.device_backapp_no,to_char(devapp.backdate,'yyyy-mm-dd') as appdate,"
			+"apporg.org_abbreviation as app_org_name,devapp.back_org_id as in_org_id,devapp.project_info_id,"
			+"tp.project_name,mixorg.org_abbreviation as mix_org_name,devapp.backmix_org_id "
			+"from gms_device_backapp devapp "
			+"left join common_busi_wf_middle wfmiddle on devapp.device_backapp_id=wfmiddle.business_id "
			+"left join gp_task_project tp on devapp.project_info_id=tp.project_info_no " 
			+"left join comm_org_information apporg on devapp.back_org_id=apporg.org_id "
			+"left join comm_org_information mixorg on devapp.backmix_org_id=mixorg.org_id "
			+"where devapp.state='9' and devapp.bsflag='0' and devapp.device_backapp_id='<%=devappid%>'";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=1000');
			retObj = proqueryRet.datas;
			if(retObj!=undefined && retObj.length>0){
				$("#project_name").val(retObj[0].project_name);
				$("#project_info_no").val(retObj[0].project_info_id);
				$("#device_backapp_no").val(retObj[0].device_backapp_no);
				$("#back_date").val(retObj[0].appdate);
				$("#in_org_name").val(retObj[0].app_org_name);
				$("#in_org_id").val(retObj[0].in_org_id);
				$("#mix_org_id").val(retObj[0].backmix_org_id);
			}
		}
		var devbackappid = $("#devicebackappid").val();
		
		var str = "select dui.out_org_id,n.org_abbreviation as out_org_name,ci.dev_ci_name,ci.dev_ci_model,ci.dev_ci_code,detail.device_backdet_id,detail.dev_acc_id,detail.dev_position,";
		str +="detail.dev_coding,detail.self_num,detail.dev_sign,detail.license_num,detail.planning_out_time,detail.actual_in_time ";
		str +="from gms_device_backapp_detail detail ";
		str +="left join gms_device_account_dui dui on detail.dev_acc_id = dui.dev_acc_id ";
		str +="left join gms_device_codeinfo ci on dui.dev_type = ci.dev_ci_code ";
		str +="left join comm_org_subjection sub on sub.org_subjection_id = dui.out_org_id and sub.bsflag = '0' ";
		str +="left join comm_org_information n on sub.org_id = n.org_id and n.bsflag = '0' ";
		str +="where detail.device_backapp_id = '"+devbackappid+"' and detail.device_mixinfo_id is null ";//and dui.owning_org_id='"+own_org_id+"'";
		//查询设备明细并进行回填
	
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=1000');
			retObj = proqueryRet.datas;
		addLine(retObj);
	}

	function addLine(retObj){
		var rows = document.getElementById("detailtable").rows.length;
		
		for(var index=rows;index<rows+retObj.length;index++){
			//动态新增表格
			var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
			innerhtml += "<td><input type='checkbox' name='detinfo' id='"+index+"' value='"+retObj[index].device_backdet_id+"' checked/></td>";
			innerhtml += "<td><input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='"+retObj[index].dev_ci_name+"' size='12' type='text' readonly/>";
			innerhtml += "<input name='devicebackdetid"+index+"' id='devicebackdetid"+index+"' value='"+retObj[index].device_backdet_id+"' type='hidden' />";
			innerhtml += "<input name='devcicode"+index+"' id='devcicode"+index+"' value='"+retObj[index].dev_ci_code+"' type='hidden' /></td>";
			innerhtml += "<td><input name='devicemodel"+index+"' id='devicemodel"+index+"' value='"+retObj[index].dev_ci_model+"' size='12' type='text' readonly/></td>";
			
			innerhtml += "<td><input name='devcoding"+index+"' id='devcoding"+index+"' value='"+retObj[index].dev_coding+"' size='14' type='text' readonly/></td>";
			innerhtml += "<td><input name='selfnum"+index+"' id='selfnum"+index+"' style='line-height:15px' value='"+retObj[index].self_num+"' size='9' type='text' /></td>";
			innerhtml += "<td><input name='devsign"+index+"' id='devsign"+index+"' value='"+retObj[index].dev_sign+"' size='10'  type='text' readonly/></td>";
			innerhtml += "<td><input name='licensenum"+index+"' id='licensenum"+index+"' value='"+retObj[index].license_num+"' size='9' type='text' readonly/>";
			innerhtml += "<td><input name='devoutorg"+index+"' id='devoutorg"+index+"' value='"+retObj[index].out_org_name+"' size='14' type='text' readonly/>";
			innerhtml += "<td><input name='planningouttime"+index+"' id='planningouttime"+index+"' style='line-height:15px' value='"+retObj[index].planning_out_time+"' size='14' type='text' readonly/></td>";
			innerhtml += "<td><input name='actualouttime"+index+"' id='actualouttime"+index+"' style='line-height:15px' value='"+retObj[index].actual_in_time+"' size='14' type='text' readonly/></td>";
			//innerhtml += "<td><input name='devposition"+index+"' id='devposition"+index+"' style='line-height:15px' value='"+retObj[index].dev_position+"' size='10' type='text'/></td>";
			innerhtml += "</tr>";
			
			$("#detailtable").append(innerhtml);
		}
		$("#colldetailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#colldetailtable>tr:odd>td:even").addClass("odd_even");
		$("#colldetailtable>tr:even>td:odd").addClass("even_odd");
		$("#colldetailtable>tr:even>td:even").addClass("even_even");
	}
</script>
</html>

