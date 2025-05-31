<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String devappid = request.getParameter("devappid");
	String oprstate = request.getParameter("oprstate");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgsubid = user.getOrgSubjectionId();
	String orgType="";
	if(orgsubid.startsWith("C105008")){
		orgType="Y";
	}else{
		orgType="N";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>多项目-调配调剂-调配单管理(自有设备)-新增按钮页面(综合物化探专用)</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend >基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >调配单号:</td>
          <td class="inquire_form4" >
          	<input name="mixinfo_no" id="mixinfo_no" class="input_width" type="text"  value="保存后自动生成..." readonly/>
          </td>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text"  value="" readonly/>
          	<input name="project_info_no" id="project_info_no" class="input_width" type="hidden"  value="" />
          	<input name="deviceappid" id="deviceappid" type="hidden" value="<%=devappid%>" />
          	<input name="mix_org_id" id="mix_org_id" type="hidden" value="" />
          	<input name="mix_type_id" id="mix_type_id" type="hidden" value="" />
          	<input name="mix_type_name" id="mix_type_name" type="hidden" value="" />
          	<input name="mix_user_id" id="mix_user_id" type="hidden" value="" />
          </td>
          <td class="inquire_item4" ></td><td class="inquire_form4" ></td>
        </tr>
        <tr>
          <td class="inquire_item4" >调配申请单号:</td>
          <td class="inquire_form4" >
          	<input name="device_app_no" id="device_app_no" class="input_width" type="text"  value="" readonly/>
          </td>
          <td class="inquire_item4" >调配申请时间:</td>
          <td class="inquire_form4" >
          	<input name="app_date" id="app_date" class="input_width" type="text"  value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >申请单位名称:</td>
          <td class="inquire_form4" >
          	<input name="in_org_name" id="in_org_name" class="input_width" type="text"  value="" readonly/>
          	<input name="in_org_id" id="in_org_id" class="input_width" type="hidden"  value="" />
          	<input name="in_sub_id" id="in_sub_id" class="input_width" type="hidden"  value="" />
          </td>
          <td class="inquire_item4" >转出单位:</td>
          <td class="inquire_form4" >
          	<input name="out_org_name" id="out_org_name" class="input_width" type="text"  value="" readonly/><img id="show-btn" src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOrgTreePage('out_org')" />
          	<input name="out_org_id" id="out_org_id" class="input_width" type="hidden"  value="" />
          </td>
        </tr>
      </table>
      </fieldset>
	  <fieldset style="margin-left:2px"><legend>调配数量明细</legend>
		  <div style="overflow:auto">
			  <table style="width:98%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" width="5%"><input type="checkbox" name="alldetinfo" id="alldetinfo" /></td>
					<!-- <td class="bt_info_even" width="10%">班组</td> -->
					<td class="bt_info_even" width="14%">设备名称</td>
					<td class="bt_info_odd" width="14%">规格型号</td>
					<td class="bt_info_even" width="6%">单位</td>
					<td class="bt_info_odd" width="7%">申请数量</td>
					<td class="bt_info_even" width="7%">已调配数量</td>
					<td class="bt_info_odd" width="7%">调配数量</td>
					<td class="bt_info_even" width="11%">计划进场时间</td>
					<td class="bt_info_odd" width="11%">计划离场时间</td>
					<td class="bt_info_even" width="8%">备注</td>
				</tr>
		      </table>
		      <div style="height:165px;overflow:auto;">
		      	<table style="width:98%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   		<tbody id="processtable" name="processtable" >
			   		</tbody>
		      	</table>
		      </div>
	       </div>
      </fieldset>
      <table style="width:98%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td width="5%"><span class="jl"><a href="#" id="addbtn" onclick='toMixDetailInfos()' title="填报台账明细"></a></span></td>
          <!-- <td width="5%"><span class="xg"><a href="#" id="addbtn" onclick='toModifyMixInfos()' title="修改数量明细"></a></span></td>
          <td width="5%"><span class="zj"><a href="#" id="addbtn" onclick='toAddMixInfos()' title="筛选台帐明细"></a></span></td> -->
          <td width="90%"></td>
        </tr>
      </table>
      <fieldset style="margin-left:2px"><legend>调配台账明细</legend>
		<div id="tab_box" class="tab_box" style="display:none">
			<table style="width:98%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
		       		<!-- <td class="bt_info_even" width="10%">班组</td> -->
					<td class="bt_info_odd" width="11%">设备名称</td>
					<td class="bt_info_even" width="11%">规格型号</td>
					<td class="bt_info_odd" width="10%">自编号</td>
					<td class="bt_info_even" width="10%">实物标识号</td>
					<td class="bt_info_odd" width="10%">牌照号</td>
					<td class="bt_info_even" width="10%">AMIS资产编号</td>
					<!-- <td class="bt_info_odd" width="11%">操作手</td> -->
					<td class="bt_info_even" width="10%">计划进场时间</td>
					<td class="bt_info_odd" width="10%">计划离场时间</td>
				</tr>
		      </table>
		      <div style="height:290px;overflow:auto;">
		      	<table style="width:98%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   		<tbody id="detailtable" name="detailtable" >
			   		</tbody>
		      	</table>
		      </div>
		</div>
	  </fieldset>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo(8)"></a></span><!-- 综合物化探调配后还有一步出库步骤 -->
     	<!-- <span class="bc_btn"><a href="#" onclick="submitInfo(0)"></a></span>-->
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	var oprstate_tmp="<%=oprstate%>";
	$().ready(function(){
		$("#alldetinfo").change(function(){
			var checkvalue = this.checked;
			$("input[type='checkbox'][name^='detinfo']").attr('checked',checkvalue);
		});
	});
	//已关闭的调配申请单屏蔽提交按钮
    if(oprstate_tmp == '4'){
    	$(".tj_btn").hide();      
    }
	function submitInfo(state){
		//首先明细的长度不能为0
		var detailsize = $("tr","#detailtable").size();
		if(detailsize == 0){
			alert("请添加调配台账明细!");
			return;
		}
		//然后校验是否给所有明细都填写
		var fillAlldetailFlag = true;
		var notfillRowinfos = "";
		var j = 0;
		$("input[type='hidden'][name^='dev_acc_id']","#detailtable").each(function(i){
			if(this.value == ""){
				if(j==0){
					notfillRowinfos = (j+1);
				}else{
					notfillRowinfos += "、"+(j+1);
				}
				fillAlldetailFlag = false;
				j++;
			}
		})
		if(!fillAlldetailFlag){
			alert("请填写第"+notfillRowinfos+"行的明细台账信息!");
			return;
		}
		//现在只保留的数量明细的行信息即可
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
		var detailcount = $("input[type='hidden'][name^='dev_acc_id']","#detailtable").size();
		//给调配单号设置成空
		$("#mixinfo_no").val("");
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toZHSaveSelfMixFormAllInfo.srq?mixform_type=1&state="+state+"&count="+count+"&line_infos="+line_infos+"&idinfos="+idinfos+"&detailcount="+detailcount;
		if(state==8 && window.confirm("提交以后数据不可修改,是否提交?")){
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
		
		//var orgId = strs[1].split(":");
		//document.getElementById(str+"_id").value = orgId[1];
		var orgSubId = strs[2].split(":");
		document.getElementById(str+"_id").value = orgSubId[1];
	}
	function toModifyMixInfos(){
		$("#detailtable").empty();
		$("#tab_box").hide();
		$("input[type='text'][name^='mixnum']").each(function(i){
			$(this).removeAttr("readonly");
		});
	}
	//填报明细
	//定义调配设备数量
	var mixAllNum=0;
	function toMixDetailInfos(){
		var outorgname = $("#out_org_name").val();
		if(outorgname==''){
			alert("请选择转出单位!");
			return;
		}
		var valuesize = 0;
		var mixNotmixedflag = false;
		$("input[type='checkbox'][name='detinfo']").each(function(){
			if(this.checked){
				var indexinfo = this.id;
				var valueinfo = this.value;
				var mixnuminfo = $("#mixnum"+indexinfo).val();
				if(mixnuminfo==""){
					mixNotmixedflag = true;
				}
				valuesize = valuesize+1;
			}
		});
		if(valuesize == 0)
		{
			alert("请填写“调配数量明细”并勾选记录!");
			return;
		}			
		//先清空表
		$("#detailtable").empty();
		if(mixNotmixedflag){
			alert("请填写已选择数量明细的调配数量信息!");
			return;
		}
		var seqinfo = 0;
		//数量都添了，没有问题，继续填报信息
		$("input[type='checkbox'][name='detinfo']").each(function(i){
			if(this.checked){
				var indexinfo = this.id;
				var valueinfo = this.value;
				var devicename = $("#devicename"+indexinfo).val();
				var devicemodel = $("#devicemodel"+indexinfo).val();
				var devcicode = $("#devcicode"+indexinfo).val();
				var isdevicecode = $("#isdevicecode"+indexinfo).val();				
				var detteam = $("#team"+indexinfo).val();
				var detteamid = $("#teamid"+indexinfo).val();
				var detpurpose = $("#purpose"+indexinfo).val();					
				var mixnuminfo = $("#mixnum"+indexinfo).val();
				//累加调配数量
				mixAllNum += parseInt(mixnuminfo);
				var startdate = $("#startdate"+indexinfo).val();
				var enddate = $("#enddate"+indexinfo).val();
				for(var j = 0;j<parseInt(mixnuminfo);j++){
					seqinfo++;
					var innerhtml = "<tr id='tr"+seqinfo+"' name='tr"+seqinfo+"' seq='"+seqinfo+"' thisseq='"+j+"' is_added='false' appdetid='"+valueinfo+"'>";
					//innerhtml += "<td width='10%'><input name='detteamname"+seqinfo+"' id='detteamname"+seqinfo+"' value='"+teamname+"' style='line-height:18px;' size='10' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='detdevicename"+seqinfo+"' id='detdevicename"+seqinfo+"' value='"+devicename+"' style='line-height:18px;' size='10' type='text' readonly/></td>";
					innerhtml += "<td width='11%'><input name='detdevicetype"+seqinfo+"' id='detdevicetype"+seqinfo+"' value='"+devicemodel+"' style='line-height:18px;' size='10' type='text' readonly/><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick=showDevPage("+seqinfo+",'"+devcicode+"','"+isdevicecode+"') /></td>";
					innerhtml += "<td width='10%'><input name='dev_acc_id"+seqinfo+"' id='dev_acc_id"+seqinfo+"' type='hidden'/>";
					innerhtml += "<input name='device_app_detid"+seqinfo+"' id='device_app_detid"+seqinfo+"' value='"+valueinfo+"' type='hidden'/>";
					innerhtml += "<input name='detdevcicode"+seqinfo+"' id='detdevcicode"+seqinfo+"' value='"+devcicode+"' type='hidden'/>";
					innerhtml += "<input name='isdevicecode"+seqinfo+"' id='isdevicecode"+seqinfo+"' value='"+isdevicecode+"' type='hidden'/>";
					innerhtml += "<input name='detteam"+seqinfo+"' id='detteam"+seqinfo+"' value='"+detteam+"' type='hidden' />";
					innerhtml += "<input name='detteamid"+seqinfo+"' id='detteamid"+seqinfo+"' value='"+detteamid+"' type='hidden' />";
					innerhtml += "<input name='detpurpose"+seqinfo+"' id='detpurpose"+seqinfo+"' value='"+detpurpose+"' type='hidden' />";
					innerhtml += "<input name='self_num"+seqinfo+"' id='self_num"+seqinfo+"' style='line-height:18px;width:99%' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='dev_sign"+seqinfo+"' id='dev_sign"+seqinfo+"' style='line-height:18px;width:99%' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='license_num"+seqinfo+"' id='license_num"+seqinfo+"' value='' style='line-height:18px;width:99%' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='asset_coding"+seqinfo+"' id='asset_coding"+seqinfo+"' style='line-height:18px;width:95%' value='' readonly/></td>";
					//innerhtml += "<td width='11%'><input name='operator"+seqinfo+"' id='operator"+seqinfo+"' style='line-height:18px;' size='10' value='' readonly/><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick=showOperPage("+seqinfo+") /><input name='operator_id"+seqinfo+"' id='operator_id"+seqinfo+"' type='hidden'/></td>";
					innerhtml += "<td width='10%'><input name='devstartdate"+seqinfo+"' id='devstartdate"+seqinfo+"' style='line-height:18px;width:99%' value='"+startdate+"' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='devenddate"+seqinfo+"' id='devenddate"+seqinfo+"' style='line-height:18px;width:99%' value='"+enddate+"' type='text' readonly/></td>";
					innerhtml += "</tr>";
					$("#detailtable").append(innerhtml);
				}
			}
		});
		$("#detailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#detailtable>tr:odd>td:even").addClass("odd_even");
		$("#detailtable>tr:even>td:odd").addClass("even_odd");
		$("#detailtable>tr:even>td:even").addClass("even_even");
		$("#tab_box").show();
		$("input[type='text'][id^='mixnum']").each(function(i){
			$(this).attr("readonly","readonly");
		});
		sc();
		//给上面数量大的加上批量选择功能
		//$("input[name^='devicemodel']","#processtable").each(function(i){
		//	var index = this.name.substr(11);
		//	var rowmixnum = $("#mixnum"+index).val();
		//	var devcicode = $("#devcicode"+index).val();
		//	var isdevicecode = $("#isdevicecode"+index).val();
		//	if(rowmixnum>=2){
		//		var str = "<img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick=showBatchDevPage('"+devcicode+"','"+isdevicecode+"','"+index+"') />";
		//		$(this).after(str);
		//	}
		//});
	}
	function showOperPage(trid){
		var project_info_id = $("#project_info_no").val();
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/device-xd/searchZHOperatorList.jsp?project_info_id="+project_info_id,obj,"dialogWidth=880px;dialogHeight=480px");
		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split('~');
			$("input[name='operator_id"+trid+"']","#detailtable").val(returnvalues[0]);
			$("input[name='operator"+trid+"']","#detailtable").val(returnvalues[1]);
		}
	}
	function showDevPage(trid,devcicode,isdevicecode){
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
		//var condition ="and not exists(select 1 from gms_device_appmix_detail detail where detail.dev_acc_id=account.dev_acc_id)";
		//回头加上转出单位
		var out_org_id = $("#out_org_id").val();
		var dialogurl = "<%=contextPath%>/rm/dm/tree/selectAccountForMix.jsp?isdevicecode="+isdevicecode+"&dev_ci_code="+devcicode;
		dialogurl += "&out_org_id="+out_org_id;
		dialogurl = encodeURI(dialogurl);
		dialogurl = encodeURI(dialogurl);
		var vReturnValue = window.showModalDialog(dialogurl , obj ,"dialogWidth=950px;dialogHeight=480px");
		if(vReturnValue!=undefined){
			//返回信息是 队级台账id + AMIS资产编号+ 设备名称 + 规格型号 + 自编号 + 实物标识号 + 牌照号  + 设备编码
			var returnvalues = vReturnValue.split('~');
			$("input[name='dev_acc_id"+trid+"']","#detailtable").val(returnvalues[0]);
			$("input[name='asset_coding"+trid+"']","#detailtable").val(returnvalues[1]);
			$("input[name='detdevicename"+trid+"']","#detailtable").val(returnvalues[2]);
			$("input[name='detdevicetype"+trid+"']","#detailtable").val(returnvalues[3]);
			$("input[name='self_num"+trid+"']","#detailtable").val(returnvalues[4]);
			$("input[name='dev_sign"+trid+"']","#detailtable").val(returnvalues[5]);
			$("input[name='license_num"+trid+"']","#detailtable").val(returnvalues[6]);
			$("input[name='detdevcicode"+trid+"']","#detailtable").val(returnvalues[7]);
			//$("input[name='detownorgname"+trid+"']","#detailtable").val(returnvalues[8]);
		}   
	}
	function checkAssignNum(obj){
		var index = obj.detindex;
		var mixednumVal = parseInt($("#mixednum"+index).val(),10);
		var applynumVal = parseInt($("#apply_num"+index).val(),10);
		var objValue = obj.value;
		var re = /^\+?[1-9][0-9]*$/;
		if(objValue=="")
			return;
		if(!re.test(objValue)){
			alert("调配数量必须为数字!");
			obj.value = "";
        	return false;
		}else{
			if(parseInt(objValue,10)>applynumVal){
				alert("调配数量必须小于等于申请数量!");
				obj.value = "";
				return false;
			}else if((parseInt(objValue,10)+mixednumVal)>applynumVal){
				alert("调配数量必须小于等于未调配数量!");
				obj.value = "";
				return false;
			}
		}
	}
	function sc(){
		var e=document.getElementById("new_table_box_bg");
		e.scrollTop=e.scrollHeight;
	}
	var orgType = "<%=orgType%>";
	function refreshData(){
		var retObj;
		var basedatas;
		if('<%=devappid%>'!=null){
			//回填基本信息
			var str = "select devapp.device_app_id,devapp.device_app_no,to_char(devapp.appdate,'yyyy-mm-dd') as appdate,"
			+"apporg.org_abbreviation as app_org_name,devapp.app_org_id as in_org_id,appsub.org_subjection_id as in_sub_id,devapp.project_info_no,"
			+"tp.project_name,mixorg.org_abbreviation as mix_org_name,devapp.mix_org_id,"
			+"devapp.mix_type_id,devapp.mix_type_name,devapp.mix_user_id "
			+"from gms_device_app devapp "
			+"left join gp_task_project tp on devapp.project_info_no=tp.project_info_no " 
			+"left join comm_org_information apporg on devapp.app_org_id=apporg.org_id "
			+"left join comm_org_subjection appsub on  devapp.app_org_id = appsub.org_id "
			+"left join comm_org_information mixorg on devapp.mix_org_id=mixorg.org_id "
			+"where devapp.bsflag='0' and devapp.device_app_id='<%=devappid%>'";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=10000');
			retObj = proqueryRet.datas;
			if(retObj!=undefined && retObj.length>0){
				$("#project_name").val(retObj[0].project_name);
				$("#project_info_no").val(retObj[0].project_info_no);
				$("#device_app_no").val(retObj[0].device_app_no);
				$("#app_date").val(retObj[0].appdate);
				$("#in_org_name").val(retObj[0].app_org_name);
				$("#in_org_id").val(retObj[0].in_org_id);
				$("#in_sub_id").val(retObj[0].in_sub_id);
				$("#mix_org_id").val(retObj[0].mix_org_id);
				$("#mix_type_id").val(retObj[0].mix_type_id);
				$("#mix_type_name").val(retObj[0].mix_type_name);
				$("#mix_user_id").val(retObj[0].mix_user_id);
			}
			//回填明细信息
			var prosql = "";
			if(orgType=="Y"){
				prosql += "select appdet.device_app_detid,appdet.team,appdet.apply_num,appdet.purpose,appdet.isdevicecode,";
				prosql += "appdet.plan_start_date,appdet.plan_end_date,appdet.teamid,appdet.unitinfo,nvl(tmp.mixed_num,0) mixed_num,";
				prosql += "appdet.dev_name as dev_ci_name,";
				prosql += "appdet.dev_type as dev_ci_model,info.org_name,detsub.org_subjection_id,";
				prosql += "appdet.dev_ci_code,unitsd.coding_name as unit_name,teamsd.coding_name as team_name ";
				prosql += "from gms_device_app_detail appdet ";
				prosql += "left join gms_device_codeinfo ci on ci.dev_ci_code=appdet.dev_ci_code ";
				prosql += "left join gms_device_codetype ct on appdet.dev_ci_code = ct.dev_ct_code ";
				prosql += "left join (select device_app_detid,sum(assign_num) as mixed_num from gms_device_appmix_main amm ";
				prosql += "where amm.bsflag='0' group by device_app_detid) tmp on tmp.device_app_detid = appdet.device_app_detid ";
				prosql += "left join comm_coding_sort_detail teamsd on teamsd.coding_code_id=appdet.team ";
				prosql += "left join comm_coding_sort_detail unitsd on unitsd.coding_code_id=appdet.unitinfo ";
				prosql += "left join comm_org_subjection detsub on appdet.dev_out_org_id=detsub.org_id "
				prosql += "left join comm_org_information info on appdet.dev_out_org_id = info.org_id ";
				prosql += "where appdet.bsflag='0' and appdet.device_app_id='<%=devappid%>' and detsub.org_subjection_id like '<%=orgsubid%>%'";
				prosql += "order by appdet.dev_ci_code,mixed_num ";
				prosql = encodeURI(encodeURI(prosql));
				}
			else{
			 	prosql += "select appdet.device_app_detid,appdet.team,appdet.apply_num,appdet.purpose,appdet.isdevicecode,";
				prosql += "appdet.plan_start_date,appdet.plan_end_date,appdet.teamid,appdet.unitinfo,nvl(tmp.mixed_num,0) mixed_num,";
				prosql += "appdet.dev_name as dev_ci_name,";
				prosql += "appdet.dev_type as dev_ci_model, ";
				prosql += "appdet.dev_ci_code,unitsd.coding_name as unit_name,teamsd.coding_name as team_name ";
				prosql += "from gms_device_app_detail appdet ";
				prosql += "left join gms_device_codeinfo ci on ci.dev_ci_code=appdet.dev_ci_code ";
				prosql += "left join gms_device_codetype ct on appdet.dev_ci_code = ct.dev_ct_code ";
				prosql += "left join (select device_app_detid,sum(assign_num) as mixed_num from gms_device_appmix_main amm ";
				prosql += "where amm.bsflag='0' group by device_app_detid) tmp on tmp.device_app_detid = appdet.device_app_detid ";
				prosql += "left join comm_coding_sort_detail teamsd on teamsd.coding_code_id=appdet.team ";
				prosql += "left join comm_coding_sort_detail unitsd on unitsd.coding_code_id=appdet.unitinfo ";
				prosql += "where appdet.bsflag='0' and appdet.device_app_id='<%=devappid%>'";
				prosql += "order by appdet.dev_ci_code,mixed_num ";
			}
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql+'&pageSize=10000');
			retObj = proqueryRet.datas;
			$("#out_org_id").val(retObj[0].org_subjection_id);
			$("#out_org_name").val(retObj[0].org_name);
		}
		if(retObj!=undefined){
			for(var index=0;index<retObj.length;index++){
				//动态新增表格
				var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
				innerhtml += "<td width='5%'><input type='checkbox' name='detinfo' id='"+index+"' value='"+retObj[index].device_app_detid+"' /></td>";
				//innerhtml += "<td width='10%'><input name='team_name"+index+"' id='team_name"+index+"' style='line-height:15px' value='"+retObj[index].team_name+"' size='10' type='text' readonly/></td>";
				innerhtml += "<td width='14%'><input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='"+retObj[index].dev_ci_name+"' size='17' type='text' readonly/>";
				innerhtml += "<input name='devcicode"+index+"' id='devcicode"+index+"' value='"+retObj[index].dev_ci_code+"' type='hidden' />";
				innerhtml += "<input name='team"+index+"' id='team"+index+"' value='"+retObj[index].team+"' type='hidden' />";
				innerhtml += "<input name='teamid"+index+"' id='teamid"+index+"' value='"+retObj[index].teamid+"' type='hidden' />";
				innerhtml += "<input name='isdevicecode"+index+"' id='isdevicecode"+index+"' value='"+retObj[index].isdevicecode+"' type='hidden' /></td>";
				innerhtml += "<td width='14%'><input name='devicemodel"+index+"' id='devicemodel"+index+"' value='"+retObj[index].dev_ci_model+"' size='16' type='text' readonly/></td>";
				innerhtml += "<td width='6%'><input name='unitname"+index+"' id='unitname"+index+"' value='"+retObj[index].unit_name+"' size='5' type='text' readonly/>";
				innerhtml += "<input name='unitinfo"+index+"' id='unitinfo"+index+"' value='"+retObj[index].unitinfo+"' type='hidden' /></td>";
				
				innerhtml += "<td width='7%'><input name='apply_num"+index+"' id='apply_num"+index+"' style='line-height:15px' value='"+retObj[index].apply_num+"' size='5' type='text' /></td>";
				innerhtml += "<td width='7%'><input name='mixednum"+index+"' id='mixednum"+index+"' value='"+retObj[index].mixed_num+"' size='5'  type='text' readonly/></td>";
				innerhtml += "<td width='7%'><input name='mixnum"+index+"' id='mixnum"+index+"' detindex='"+index+"' value='' onkeyup='checkAssignNum(this)' size='5' type='text' /></td>";
				
				innerhtml += "<td width='11%'><input name='startdate"+index+"' id='startdate"+index+"' style='line-height:15px' value='"+retObj[index].plan_start_date+"' size='9' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(startdate"+index+",tributton2"+index+");'/></td>";
				innerhtml += "<td width='11%'><input name='enddate"+index+"' id='enddate"+index+"' style='line-height:15px' value='"+retObj[index].plan_end_date+"' size='9' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+index+",tributton3"+index+");'/></td>";
				
				innerhtml += "<td width='8%'><input name='purpose"+index+"' id='purpose"+index+"' value='"+retObj[index].purpose+"' size='8'  type='text' readonly/></td>";
				
				innerhtml += "</tr>";
				$("#processtable").append(innerhtml);
			}
			$("#processtable>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable>tr:odd>td:even").addClass("odd_even");
			$("#processtable>tr:even>td:odd").addClass("even_odd");
			$("#processtable>tr:even>td:even").addClass("even_even");
		}
	}
	function showBatchDevPage(devcicode,isdevicecode,index){
		var obj = new Object();
		var devicename = $("#devicename"+index).val();
		var devicemodel = $("#devicemodel"+index).val(); 
		//回头加上转出单位
		var out_org_id = $("#out_org_id").val();
		var out_org_name = $("#out_org_name").val();
		var apply_num = $("#apply_num"+index).val();
		var mixnum = $("#mixnum"+index).val();
		var deviceappdetid = $("input[type='checkbox'][name='detinfo'][id='"+index+"']").val();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectAccountForBatchMix.jsp?devicename="+devicename+"&devicemodel="+devicemodel+"&isdevicecode="+isdevicecode+"&dev_ci_code="+devcicode+"&out_org_id="+out_org_id+"&out_org_name="+out_org_name+"&apply_num="+apply_num+"&mixnum="+mixnum , obj ,"dialogWidth=800px;dialogHeight=480px");
		if(vReturnValue!=undefined){
			// 转出机构~申请编码~调配编码~调配数量~
			var returnvalues = vReturnValue.split('~');
			//根据四个值进行查找设备，进行回填 回头需要完善，去掉其他单子已分配的，但是未接收的
			var str = "select dev_acc_id,asset_coding,self_num,dev_sign,license_num,dev_name,dev_model,dev_type ";
			str += "from gms_device_account account "
			str += "where account.dev_type='"+returnvalues[2]+"' ";
			str += "and owning_org_id='"+returnvalues[0]+"' and search_id is null";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=1000');
			retObj = proqueryRet.datas;
			//只需要回填调配数量条数即可
			for(var index = 0;index<returnvalues[3];index++){
				var seqinfo = $("tr[thisseq='"+index+"'][appdetid='"+deviceappdetid+"']","#detailtable").attr("seq");
				//返回信息是 队级台账id + AMIS资产编号 + 设备名称 + 规格型号 + 自编号 + 实物标识号 + 牌照号 + 设备编码
				document.getElementById("dev_acc_id"+seqinfo).value = retObj[index].dev_acc_id;
				document.getElementById("asset_coding"+seqinfo).value = retObj[index].asset_coding;
				document.getElementById("detdevicename"+seqinfo).value = retObj[index].dev_name;
				document.getElementById("detdevicetype"+seqinfo).value = retObj[index].dev_model;
				document.getElementById("self_num"+seqinfo).value = retObj[index].self_num;
				document.getElementById("license_num"+seqinfo).value = retObj[index].license_num;
				document.getElementById("dev_sign"+seqinfo).value = retObj[index].dev_sign;
				document.getElementById("detdevcicode"+seqinfo).value = retObj[index].dev_type;
			}
		}
		sc();
	}
	function toAddMixInfos(trid,devcicode,isdevicecode,devicename){

		var outorgname = $("#out_org_name").val();
		if(outorgname==''){
			alert("请选择“转出单位”!");
			return;
		}
		
		var valuesize = 0;
		var mixNotmixedflag = false;
		var checkFlag = false;
		
		$("input[type='checkbox'][name='detinfo']").each(function(){
			if(this.checked){
				var indexinfo = this.id;
				var valueinfo = this.value;
				var mixnuminfo = $("#mixnum"+indexinfo).val();
				if(mixnuminfo==""){
					mixNotmixedflag = true;
				}
				valuesize = valuesize+1;
				checkFlag = true;
			}
		});
		if(valuesize == 0){
			alert("请填写“填报台账明细”!");
			return;
		}
				
		//先清空表
		//$("#detailtable").empty();
		if(mixNotmixedflag){
			alert("请填写“填报台账明细”!");
			return;
		}
		
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
		//var condition ="and not exists(select 1 from gms_device_appmix_detail detail where detail.dev_acc_id=account.dev_acc_id)";
		//回头加上转出单位
		var out_org_id = $("#out_org_id").val();
		var dialogurl = "<%=contextPath%>/rm/dm/tree/selectAllAccountForMix.jsp?isdevicecode="+isdevicecode+"&dev_ci_code="+devcicode;
		dialogurl += "&out_org_id="+out_org_id+"&devicename="+devicename;
		dialogurl = encodeURI(dialogurl);
		dialogurl = encodeURI(dialogurl);
		var vReturnValue = window.showModalDialog(dialogurl , obj ,"dialogWidth=950px;dialogHeight=480px");
		if(vReturnValue!=undefined){
			//返回信息是 队级台账id
			var returnMidvalues = vReturnValue.split('@');
			alert(mixAllNum);
			if(parseInt(mixAllNum)<(parseInt(checkstr)+returnMidvalues.length-1)){
				alert("筛选数量不能多于调配数量");
				return;
			}else{
				for(var i=parseInt(checkstr);i<(parseInt(checkstr)+returnMidvalues.length-1);i++){
					    var trid =i+1;
						var returnvalues = returnMidvalues[i-parseInt(checkstr)].split('~');
						$("input[name='dev_acc_id"+trid+"']","#detailtable").val(returnvalues[0]);
						$("input[name='asset_coding"+trid+"']","#detailtable").val(returnvalues[1]);
						$("input[name='detdevicename"+trid+"']","#detailtable").val(returnvalues[2]);
						$("input[name='detdevicetype"+trid+"']","#detailtable").val(returnvalues[3]);
						$("input[name='self_num"+trid+"']","#detailtable").val(returnvalues[4]);
						$("input[name='dev_sign"+trid+"']","#detailtable").val(returnvalues[5]);
						$("input[name='license_num"+trid+"']","#detailtable").val(returnvalues[6]);
						$("input[name='detdevcicode"+trid+"']","#detailtable").val(returnvalues[7]);
						$("input[name='detownorgname"+trid+"']","#detailtable").val(returnvalues[8]);
				}
			}
		}   
	}
</script>
</html>

