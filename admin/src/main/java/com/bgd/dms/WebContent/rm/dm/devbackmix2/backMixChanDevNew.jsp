<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String devappid = request.getParameter("devappid");
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
<title>(自有设备)更换设备返还调配单添加界面</title>
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
          	<input name="in_sub_id" id="in_sub_id" class="input_width" type="hidden"  value="" />
          </td>
          <td class="inquire_item4" >设备接收单位:</td>
          <td class="inquire_form4" >
          	<input name="own_org_name" id="own_org_name" class="input_width" type="text"  value="" readonly/><img id="show-btn" src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOrgTreePage('own_org')" />
          	<input name="own_org_id" id="own_org_id" class="input_width" type="hidden"  value="" />
          	<input name="own_sub_id" id="own_sub_id" class="input_width" type="hidden"  value="" />
          </td>
        </tr>
      </table>
      </fieldset>
      <table style="width:98%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td width="5%"><span class="jl"><a href="#" id="addbtn" onclick='toMixDetailInfos()' title="填报返还明细"></a></span></td>
          <td width="95%"></td>
        </tr>
      </table>
      <fieldset style="margin-left:2px"><legend>调配台账明细</legend>
		<div id="tab_box" class="tab_box" style="height:150px;overflow:auto">
			<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr class="FixedTitleRow">
					<td class="bt_info_odd" width="8%">设备名称</td>
					<td class="bt_info_even" width="11%">规格型号</td>
					<td class="bt_info_odd" width="14%">设备编号</td>
					<td class="bt_info_even" width="8%">自编号</td>
					<td class="bt_info_odd" width="11%">实物标识号</td>
					<td class="bt_info_even" width="8%">牌照号</td>
					<td class="bt_info_odd" width="14%">计划离场时间</td>
					<td class="bt_info_even" width="14%">实际离场时间</td>
					<td class="bt_info_odd" width="11%">存放地</td>
				</tr>
			    <tbody id="detailtable" name="detailtable">
			    </tbody>
			</table>
		</div>
	  </fieldset>
	   <fieldset style="margin-left:2px"><legend>更换台账明细</legend>
		<div id="tab_box" class="tab_box" style="height:150px;overflow:auto">
			<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr class="FixedTitleRow">
					<td class="bt_info_odd" width="8%">设备名称</td>
					<td class="bt_info_even" width="11%">规格型号</td>
					<td class="bt_info_odd" width="14%">设备编号</td>
					<td class="bt_info_even" width="8%">自编号</td>
					<td class="bt_info_odd" width="11%">实物标识号</td>
					<td class="bt_info_even" width="8%">牌照号</td>
					<td class="bt_info_odd" width="14%">计划进场时间</td>
					<td class="bt_info_even" width="14%">计划离场时间</td>
				</tr>
			    <tbody id="chandetailtable" name="chandetailtable">
			    </tbody>
			</table>
		</div>
	  </fieldset>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a id="submitButton" href="#" onclick="submitInfo(9)"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript"> 
	function submitInfo(state){		
		//首先明细的长度不能为0
		var detailsize = $("tr","#detailtable").size();
		if(detailsize == 0){
			alert("请添加调配台账明细!");
			return;
		}
		var chandetailsize = $("tr","#chandetailtable").size();
		if(chandetailsize == 0){
			alert("请添加更换台账明细!");
			return;
		}
		//然后校验是否给所有明细都填写
		var fillAlldetailFlag = true;
		$("input[type='hidden'][name^='chandevaccid']","#chandetailtable").each(function(i){
			if(this.value == ""){
				fillAlldetailFlag = false;
			}
		})
		if(!fillAlldetailFlag){
			alert("请填写更换台账明细信息!");
			return;
		}
		//然后校验是否给所有明细都填写计划进离场时间
		var fillAllstartdateFlag = true;
		$("input[type='text'][name^='chanstartdate']","#chandetailtable").each(function(i){
			if(this.value == ""){
				fillAllstartdateFlag = false;
			}
		})
		if(!fillAllstartdateFlag){
			alert("请填写更换台账计划进场时间信息!");
			return;
		}
		//然后校验是否给所有明细都填写计划进离场时间
		var fillAllenddateFlag = true;
		$("input[type='text'][name^='chanenddate']","#chandetailtable").each(function(i){
			if(this.value == ""){
				fillAllenddateFlag = false;
			}
		})
		if(!fillAllenddateFlag){
			alert("请填写更换台账计划离场时间信息!");
			return;
		}
		var detailcount = $("input[type='hidden'][name^='devicebackdetid']","#detailtable").size();
		//给调配单号设置成空
		$("#mixinfo_no").val("");

		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveBackMDFInfoNew.srq?mixform_type=5&state="+state+"&detailcount="+detailcount;
		if(state==9 && window.confirm("提交以后数据不可修改,是否提交?")){
			document.getElementById("form1").submit();
			document.getElementById("submitButton").onclick = "";
		}else if(state==0){
			document.getElementById("form1").submit();
			document.getElementById("submitButton").onclick = "";
		}
	}
	/**
	 * 选择组织机构树
	 */
	function showOrgTreePage(str){
		var devicebackappid = $("#devicebackappid").val();
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/devbackmix2/selectOwnOrgId.jsp?devbackappid="+devicebackappid,"test","");
		var strs= new Array(); //定义一数组
		if(!returnValue){
			return;
		}
		strs=returnValue.split("~"); //字符分割
		document.getElementById(str+"_id").value = strs[0];		
		document.getElementById(str+"_name").value = strs[1];
		document.getElementById("own_sub_id").value = strs[2];
	}
	function toMixDetailInfos(){
		
		var own_org_id = $("#own_org_id").val();
		if(own_org_id==''){
			alert("请选择设备接收单位!");
			return;
		}
		if($("#detailtable tr") && $("#detailtable tr").size()>0){
			alert("返还明细已填报");
			return;
		}
		var devbackappid = $("#devicebackappid").val();
		//先清空下面的列表，再给数据回填
		$("#detailtable").empty();
		$("#chandetailtable").empty();
		//检查设备接收单位中属于自己的设备明细，将其添加到明细中
		var str = "select dui.dev_team,ci.dev_ci_name,ci.dev_ci_model,ci.dev_ci_code,detail.device_backdet_id,detail.dev_acc_id,detail.dev_position,";
			str +="detail.dev_coding,detail.self_num,detail.dev_sign,detail.license_num,detail.planning_out_time,detail.actual_in_time ";
			str +="from gms_device_backapp_detail detail ";
			str +="join gms_device_account_dui dui on detail.dev_acc_id = dui.dev_acc_id ";
			str +="join gms_device_codeinfo ci on dui.dev_type = ci.dev_ci_code ";
			str +="where detail.device_backapp_id = '"+devbackappid+"' and dui.owning_org_id='"+own_org_id+"'";
		//查询设备明细并进行回填
		
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=1000');
			retObj = proqueryRet.datas;
		if(retObj!=undefined){
			for(var index=0;index<retObj.length;index++){
				//动态新增表格
				var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
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
				innerhtml += "<td><input name='devposition"+index+"' id='devposition"+index+"' style='line-height:15px' value='"+retObj[index].dev_position+"' size='10' type='text'/></td>";
				innerhtml += "</tr>";
								
				$("#detailtable").append(innerhtml);
			}
			$("#detailtable>tr:odd>td:odd").addClass("odd_odd");
			$("#detailtable>tr:odd>td:even").addClass("odd_even");
			$("#detailtable>tr:even>td:odd").addClass("even_odd");
			$("#detailtable>tr:even>td:even").addClass("even_even");
		}
		if(retObj!=undefined){
			for(var chanindex=0;chanindex<retObj.length;chanindex++){
				//动态新增表格
				var innerhtml = "<tr id='tr"+chanindex+"' name='tr"+chanindex+"' seq='"+chanindex+"'>";
				innerhtml += "<td><input name='chandevicename"+chanindex+"' id='chandevicename"+chanindex+"' style='line-height:15px' value='' size='9' type='text' readonly/>";
				innerhtml += "<input name='chandevbackdetid"+chanindex+"' id='chandevbackdetid"+chanindex+"' value='"+retObj[chanindex].device_backdet_id+"' type='hidden' />";
				innerhtml += "<input name='chandevaccid"+chanindex+"' id='chandevaccid"+chanindex+"' value='' type='hidden' />";
				innerhtml += "<input name='chandevcicode"+chanindex+"' id='chandevcicode"+chanindex+"' value='' type='hidden'/>";
				innerhtml += "<input name='chanassetcoding"+chanindex+"' id='chanassetcoding"+chanindex+"' value='' type='hidden'/>";
				innerhtml += "<input name='chanteamid"+chanindex+"' id='chanteamid"+chanindex+"' value='"+retObj[chanindex].dev_team+"' type='hidden' /></td>";
				innerhtml += "<td><input name='chandevicemodel"+chanindex+"' id='chandevicemodel"+chanindex+"' value='' size='10' type='text' readonly/><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick=showDevPage('"+chanindex+"') /></td>";				
				innerhtml += "<td><input name='chandevcoding"+chanindex+"' id='chandevcoding"+chanindex+"' value='' size='14' type='text' readonly/></td>";
				innerhtml += "<td><input name='chanselfnum"+chanindex+"' id='chanselfnum"+chanindex+"' style='line-height:15px' value='' size='9' type='text' /></td>";
				innerhtml += "<td><input name='chandevsign"+chanindex+"' id='chandevsign"+chanindex+"' value='' size='10'  type='text' readonly/></td>";
				innerhtml += "<td><input name='chanlicensenum"+chanindex+"' id='chanlicensenum"+chanindex+"' value='' size='9' type='text' readonly/>";				
				innerhtml += "<td><input name='chanstartdate"+chanindex+"' id='chanstartdate"+chanindex+"' style='line-height:15px' value='' onpropertychange='checkEndDate("+chanindex+");' size='14' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+chanindex+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(chanstartdate"+chanindex+",tributton2"+chanindex+");'/></td>";
				innerhtml += "<td><input name='chanenddate"+chanindex+"' id='chanenddate"+chanindex+"' style='line-height:15px' value='' onpropertychange='checkEndDate("+chanindex+");' size='14' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+chanindex+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(chanenddate"+chanindex+",tributton3"+chanindex+");'/></td>";
				innerhtml += "</tr>";
				
				$("#chandetailtable").append(innerhtml);
			}
			$("#chandetailtable>tr:odd>td:odd").addClass("odd_odd");
			$("#chandetailtable>tr:odd>td:even").addClass("odd_even");
			$("#chandetailtable>tr:even>td:odd").addClass("even_odd");
			$("#chandetailtable>tr:even>td:even").addClass("even_even");
		}
	}
	function showDevPage(trid){
		var obj = new Object();
		var pageselectedstr = null;
		var checkstr = 0;
		$("input[name^='chandevaccid'][type='hidden']").each(function(i){
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
		var out_org_id = $("#own_sub_id").val();
		var dialogurl = "<%=contextPath%>/rm/dm/tree/selectAccountForMix.jsp?out_org_id="+out_org_id;
		dialogurl = encodeURI(dialogurl);
		dialogurl = encodeURI(dialogurl);
		var vReturnValue = window.showModalDialog(dialogurl , obj ,"dialogWidth=1050px;dialogHeight=480px");
		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split('~');
			$("input[name='chandevaccid"+trid+"']","#chandetailtable").val(returnvalues[0]);
			$("input[name='chandevcoding"+trid+"']","#chandetailtable").val(returnvalues[9]);
			$("input[name='chandevicename"+trid+"']","#chandetailtable").val(returnvalues[2]);
			$("input[name='chandevicemodel"+trid+"']","#chandetailtable").val(returnvalues[3]);
			$("input[name='chanselfnum"+trid+"']","#chandetailtable").val(returnvalues[4]);
			$("input[name='chandevsign"+trid+"']","#chandetailtable").val(returnvalues[5]);
			$("input[name='chanlicensenum"+trid+"']","#chandetailtable").val(returnvalues[6]);
			$("input[name='chandevcicode"+trid+"']","#chandetailtable").val(returnvalues[7]);
			$("input[name='chanassetcoding"+trid+"']","#chandetailtable").val(returnvalues[1]);
		}   
	}
	function checkEndDate(index){
		var startTime = $("#chanstartdate"+index).val();
		var returnTime = $("#chanenddate"+index).val();
		if(startTime!=null&&startTime!=''&&returnTime!=null&&returnTime!=''){
			var days=(new Date(returnTime.replace(/-/g,'/'))-new Date(startTime.replace(/-/g,'/')))/3600/24/1000;
			if(days<0){
				alert("计划离场时间应大于计划进场时间");
				$("#chanenddate"+index).val("");
				return false;
			}			
		}
		return true;
	}
	function refreshData(){
		var retObj;
		var basedatas;
		if('<%=devappid%>'!=null){
			//回填基本信息
			var str = "select devapp.device_backapp_id,devapp.device_backapp_no,to_char(devapp.backdate,'yyyy-mm-dd') as appdate,"
			+"apporg.org_abbreviation as app_org_name,devapp.back_org_id as in_org_id,appsub.org_subjection_id as in_sub_id,devapp.project_info_id,"
			+"tp.project_name,mixorg.org_abbreviation as mix_org_name,devapp.backmix_org_id "
			+"from gms_device_backapp devapp "
			+"left join common_busi_wf_middle wfmiddle on devapp.device_backapp_id=wfmiddle.business_id "
			+"left join gp_task_project tp on devapp.project_info_id=tp.project_info_no " 
			+"left join comm_org_information apporg on devapp.back_org_id=apporg.org_id "
			+"left join comm_org_information mixorg on devapp.backmix_org_id=mixorg.org_id "
			+"left join comm_org_subjection appsub on devapp.back_org_id=appsub.org_id "
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
				$("#in_sub_id").val(retObj[0].in_sub_id);
				$("#mix_org_id").val(retObj[0].backmix_org_id);
			}
		}
	}
</script>
</html>

