<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String deviceappid = request.getParameter("deviceallappid");
	String devappid = request.getParameter("devappid");
	String mixstate = request.getParameter("mixstate");
	ResourceBundle rb = ResourceBundle.getBundle("devCodeDesc");
	String collMixFlag = null;
	if (rb != null) {
		collMixFlag = rb.getString("CollMixFlag");
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>多项目-调配调剂-大港调配单(自有)-批量调配子页面</title>
</head>

<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width: 98%">
<div id="new_table_box_content" style="width: 100%">
<div id="new_table_box_bg" style="width: 95%">
<fieldset style="margin-left: 2px; width: 98%"><legend>申请基本信息</legend>
<table border="0" cellspacing="0" cellpadding="0"
	class="tab_line_height">
	<tr>
		<td class="inquire_item4">项目名称:</td>
		<td class="inquire_form4"><input name="project_name" id="project_name" class="input_width" type="text" value="" readonly />
		<input name="project_info_no" id="project_info_no" type="hidden" value="" />
		<input name="devouttype" id="devouttype" type="hidden" value="1" />
		<input name="mix_type_id" id="mix_type_id" type="hidden" value="S1405" />
		<input name="collteam" id="collteam" type="hidden" value="" />
        <input name="planstartdate" id="planstartdate" type="hidden" value="" />
        <input name="planenddate" id="planenddate" type="hidden" value="" />
        <input name="deviceappid" id="deviceappid" type="hidden" value='<%=devappid %>' />
        <input name="deviceallappid" id="deviceallappid" type="hidden" value='<%=deviceappid %>' /></td>
		<!-- <td class="inquire_item4">申请单名称:</td>
		<td class="inquire_form4"><input name="device_app_name" id="device_app_name" class="input_width" type="text" value="" readonly /></td> -->
		 <td class="inquire_item4" >出库单号:</td>
          <td class="inquire_form4" >
          	<input name="outinfo_no" id="outinfo_no" class="input_width" type="text"  value="保存后自动生成..." readonly/>
          </td>
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
        </td>
        <td class="inquire_item4" >转出单位:</td>
        <td class="inquire_form4" >
          	<input name="out_org_name" id="out_org_name" class="input_width" type="text"  value="" readonly/>
          	<input name="out_org_id" id="out_org_id" class="input_width" type="hidden"  value="" />
          	<input name="out_sub_id" id="out_sub_id" class="input_width" type="hidden"  value="" />
        </td>
   </tr>
    <tr>
          <td class="inquire_item4" ><font color=red>*</font>&nbsp;出库时间:</td>
          	<td class="inquire_form4">
				<input type="text" name="out_date" id="out_date" value="" readonly="readonly" class="input_width"/>
				<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(out_date,tributton1);" />
			</td>
        </tr>
</table>
</fieldset>
<div id="table_box">
<fieldset style="margin-left: 2px; width: 98%"><legend>申请明细</legend>
<table width="100%" border="0" cellspacing="0" cellpadding="0"
	class="tab_info" id="queryRetTable">
	<tr id='device_appdet_id_{device_app_detid}' name='device_app_detid'>
		<td class="bt_info_odd">选择</td>
		<td class="bt_info_even">序号</td>
		<td class="bt_info_odd">班组</td>
		<td class="bt_info_even">申请名称</td>
		<td class="bt_info_odd">申请型号</td>
		<td class="bt_info_even">单位</td>
		<td class="bt_info_odd">申请道数</td>
		<td class="bt_info_even">计划开始时间</td>
		<td class="bt_info_odd">计划结束时间</td>
		<td class="bt_info_even">用途</td>
	</tr>
	<tbody id="detailList1" name="detailList1"></tbody>
</table>
</fieldset>
<fieldset style="margin-left: 2px; width: 98%">
<table style="width: 100%;" border="0" cellspacing="0" cellpadding="0"
	class="tab_line_height">
	<tr>
		<!-- <td width="10%"><span class="jl"><a href="#" id="addbtn" onclick='toMixDetailInfos()' title="分配具体明细"></a></span></td> -->
		<!-- <td width="30%"> -->
		<!-- <td id="selectmodeltd" width="50%" align="right" style="display: none">
		<select id="selectmodel" name="selectmodel" class="select_width"
			style="width: 180px">
			<option value="">请选择模板...</option>
		</select>&nbsp;&nbsp;&nbsp;&nbsp;</td> -->
		
			<td id="addtd" width="5%" align="right" style="display:none">
				<span class="zj">
					<a href="#" id="addbtn" onclick='toAddRowInfo()' title="分配"></a>
				</span>
			</td>
			<td id="deltd" width="5%" align="right" style="display: none">
				<span class="sc">
					<a href="#" id="delbtn" onclick='toDelRowInfo()' title="删除"></a>
				</span>
			</td>
			<td width="98%"></td>		
	</tr>
</table>
<div id="tag-container_3" style="width:98%;">
<ul id="tags" class="tags"></ul>
</div>
<div id="tab_box" class="tab_box"
	style="width:100%; height:160px;">
</div>
</fieldset>
<fieldset style="margin-left: 2px"><legend>附属设备</legend>
<table style="width: 100%" border="0" cellspacing="0" cellpadding="0"
	class="tab_line_height">
	<tr>
		<td width="5%"><span class="zj"><a href="#"
			id="addaddedbtn" onclick='toAddAddedDetailInfos()' title="添加"></a></span></td>
		<td width="5%"><span class="sc"><a href="#"
			id="deladdedbtn" onclick='toDelAddedDetailInfos()' title="删除"></a></span></td>
		<td width="90%"></td>
	</tr>
</table>
<div id="tab_box" class="tab_box" style="height: 120px; overflow: auto;">
<table style="width: 100%" border="0" cellspacing="0" cellpadding="0"
	class="tab_line_height">
	<tr>
		<td class="bt_info_even"></td>
		<td class="bt_info_odd" width="4%">选择</td>
		<td class="bt_info_odd" width="12%">设备名称</td>
		<td class="bt_info_even" width="12%">规格型号</td>
		<td class="bt_info_odd" width="10%">自编号</td>
		<td class="bt_info_even" width="10%">牌照号</td>
		<td class="bt_info_odd" width="10%">实物标识号</td>
		<td class="bt_info_even" width="10%">AMIS资产编号</td>
		<td class="bt_info_odd" width="11%">计划进场时间</td>
		<td class="bt_info_even" width="11%">计划离场时间</td>
		<td class="bt_info_odd" width="10%">备注</td>
	</tr>
</table>
<div style="height:90px; overflow: auto;">
<table style="width: 97.9%" border="0" cellspacing="0" cellpadding="0"
	class="tab_line_height" style='table-layout: auto'>
	<tbody id="addeddetailtable" name="addeddetailtable"></tbody>
</table>
</div>
</div>
</fieldset>
</div>
</div>
<div id="oper_div">
	<span class="tj_btn"><a href="#" onclick="submitInfo(9)"></a></span> 
	<span class="gb_btn"><a href="#" onclick="newClose()"></a></span></div>
</div>
</div>
</form>
<iframe style="display: none;" id="target_id" name="target_id"></iframe>
</body>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var device_all_appid_tmp = '<%=deviceappid%>';
	var devappid_tmp = '<%=devappid%>';
	var detailmainid;
	function refreshData(){
		//查询基本信息也带过来
		
		if('<%=devappid%>'!=null){
			//回填基本信息
			var str = "select devapp.device_app_id,devapp.device_app_no,devapp.device_app_name,outsub.org_subjection_id as out_sub_id,to_char(devapp.appdate,'yyyy-mm-dd') as appdate,"
			+"apporg.org_abbreviation as app_org_name,devapp.app_org_id as in_org_id,outorg.org_abbreviation as out_org_name,tail.dev_out_org_id as out_org_id,devapp.project_info_no,"
			+"tp.project_name,mixorg.org_abbreviation as mix_org_name,devapp.mix_org_id,"
			+"devapp.mix_type_id,devapp.mix_type_name,devapp.mix_user_id "
			+"from gms_device_app devapp "
			+"left join common_busi_wf_middle wfmiddle on devapp.device_allapp_id=wfmiddle.business_id "
			+"left join gp_task_project tp on devapp.project_info_no=tp.project_info_no " 
			+"left join comm_org_information apporg on devapp.app_org_id=apporg.org_id "
			+"left join gms_device_app_detail tail on tail.device_app_id = devapp.device_app_id "
			+"left join comm_org_information outorg on outorg.org_id = tail.dev_out_org_id "
			+"left join comm_org_subjection outsub on tail.dev_out_org_id = outsub.org_id "
			+"left join comm_org_information mixorg on devapp.mix_org_id=mixorg.org_id "
			+"where wfmiddle.proc_status='3' and devapp.bsflag='0' and devapp.device_allapp_id='"+device_all_appid_tmp+"' ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=10000');
			retObj = proqueryRet.datas;
			if(retObj!=undefined && retObj.length>0){
				$("#project_name").val(retObj[0].project_name);
				$("#project_info_no").val(retObj[0].project_info_no);
				$("#device_app_no").val(retObj[0].device_app_no);
				$("#device_app_name").val(retObj[0].device_app_name);
				$("#out_sub_id").val(retObj[0].out_sub_id);
				$("#app_date").val(retObj[0].appdate);
				$("#in_org_name").val(retObj[0].app_org_name);
				$("#in_org_id").val(retObj[0].in_org_id);
				$("#out_org_name").val(retObj[0].out_org_name);
				$("#out_org_id").val(retObj[0].out_org_id);
				$("#mix_org_id").val(retObj[0].mix_org_id);
				$("#mix_type_id").val(retObj[0].mix_type_id);
				$("#mix_type_name").val(retObj[0].mix_type_name);
				$("#mix_user_id").val(retObj[0].mix_user_id);
			}
		}
		var str = "select appdet.device_app_detid,appdet.dev_codetype,appdet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, ";
		str += "p6.name as jobname,pro.project_name,appdet.dev_name_input as dev_ci_name,devtype.coding_name as dev_ci_model, ";
		str += "appdet.apply_num,appdet.teamid,appdet.team,devapp.device_app_name, ";
		str += "appdet.purpose,appdet.employee_id,emp.employee_name, ";
		str += "appdet.plan_start_date,appdet.plan_end_date  ";
		str += "from gms_device_app_colldetail appdet ";
		str += "left join gms_device_collapp devapp on appdet.device_app_id = devapp.device_app_id ";
        str += "left join gms_device_allapp allapp on allapp.DEVICE_ALLAPP_ID=devapp.DEVICE_ALLAPP_ID ";
		str += "left join bgp_p6_activity p6 on appdet.teamid = p6.object_id ";
		str += "left join comm_coding_sort_detail devtype on appdet.dev_codetype = devtype.coding_code_id ";
		str += "left join comm_coding_sort_detail teamsd on appdet.team = teamsd.coding_code_id ";
		str += "left join comm_coding_sort_detail sd on appdet.unitinfo = sd.coding_code_id ";
		str += "left join gp_task_project pro on appdet.project_info_no = pro.project_info_no ";
		str += "left join comm_human_employee emp on appdet.employee_id = emp.employee_id ";
		str += "where allapp.DEVICE_ALLAPP_ID = '"+device_all_appid_tmp+"' and appdet.bsflag='0' ";
		str += "and devapp.bsflag = '0' ";
		var detailRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=10000');

		var retObj = detailRet.datas;
		if(retObj && retObj.length>0){
			$("#collteam").val(retObj[0].team);
			for(var index=0;index<retObj.length;index++){
				detailmainid = retObj[index].device_app_detid;
				var device_app_detid = retObj[index].device_app_detid;
				var devcodetype = retObj[index].dev_codetype;
				var collseqinfo = retObj[index].seqinfo;
				var collproject_name = retObj[index].project_name;
				var collteamname = retObj[index].teamname;
				var collteam = retObj[index].team;
				var collunitname = retObj[index].unitname;
				var colldev_ci_name = retObj[index].dev_ci_name;
				var colldev_ci_model = retObj[index].dev_ci_model;
				var collapply_num = retObj[index].apply_num;
				var collpurpose = retObj[index].purpose;
				var collstartdate = retObj[index].plan_start_date;
				var collenddate = retObj[index].plan_end_date;
				
				//动态新增表格
				var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
				innerhtml += "<td><input type='checkbox' name='idinfo' id='"+index+"' value='"+device_app_detid+"' devcodetype='"+devcodetype+"' checked='true'/></td>";

				innerhtml += "<td>"+(index+1)+"<input name='colldevice_app_detid' id='colldevice_app_detid"+index+"' value='"+device_app_detid+"' type='hidden'/></td>";
				innerhtml += "<td><input name='collteamname"+index+"' id='collteamname"+index+"' style='line-height:15px' value='"+collteamname+"' size='8' type='text' readonly/></td>";
				innerhtml += "<input name='team"+index+"' id='teamid"+index+"' value='"+collteam+"' type='hidden'/></td>";
				innerhtml += "<td><input name='colldevicename"+index+"' id='colldevicename"+index+"' style='line-height:15px' value='"+colldev_ci_name+"' size='10' type='text' readonly/></td>";
				innerhtml += "<td><input id='colldevicetype"+index+"' name='colldevicetype"+index+"' value='"+colldev_ci_model+"' size='12'  type='text' readonly/></td>";
				innerhtml += "<td><input id='collunitname"+index+"' name='collunitname"+index+"' value='"+collunitname+"' size='3' type='text' readonly/></td>";
				innerhtml += "<td><input id='collapplynum"+index+"' name='collapplynum"+index+"' value='"+collapply_num+"' size='3' type='text' /></td>";
				innerhtml += "<td><input name='collstartdate"+index+"' id='collstartdate"+index+"' style='line-height:15px' size='10' value='"+collstartdate+"' type='text' readonly/></td>";
				innerhtml += "<td><input name='collenddate"+index+"' id='collenddate"+index+"' style='line-height:15px' size='10' value='"+collenddate+"' type='text' readonly/></td>";
				innerhtml += "<td><input id='collpurpose"+index+"' name='collpurpose"+index+"' value='"+collpurpose+"' size='8' type='text' readonly/></td>";
				innerhtml += "</tr>";
				
				$("#detailList1").append(innerhtml);
			}
			$("#detailList1>tr:odd>td:odd").addClass("odd_odd");
			$("#detailList1>tr:odd>td:even").addClass("odd_even");
			$("#detailList1>tr:even>td:odd").addClass("even_odd");
			$("#detailList1>tr:even>td:even").addClass("even_even");
		}
		toMixDetailInfos();
		var querySql = "select mix.device_mif_subid,teamsd.coding_name as teamname,mix.device_name,mix.device_model,mix.unit_name,'' as a,mix.device_num,mix.mix_num,mix.devremark from gms_device_coll_mixsubadd mix left join comm_coding_sort_detail teamsd on mix.team = teamsd.coding_code_id left join comm_coding_sort_detail d on mix.team=d.coding_code_id where mix.device_mixinfo_id='"+detailmainid+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql+'&pageSize=10000');
		var queryObj = queryRet.datas;
		if(queryObj && queryObj.length>0){
			var index;
			for(index=0;index<queryObj.length;index++){
				var innerhtml = "<tr id='tradded"+index+"' name='tradded"+index+"' seq='"+index+"' is_added='false'>";
				innerhtml += "<td width='4%'><input type='checkbox' name='addedseq' id='addedseq"+index+"' checked='true' /></td>";
				innerhtml += "<td width='12%'><input name='addedteamname"+index+"' id='addedteamname"+index+"' value='"+retObj[0].teamname+"' style='line-height:18px;width:98%' size='10' type='text' readonly/>";
				innerhtml += "<input name='addedteam"+index+"' id='addedteam"+index+"' value='"+retObj[0].team+"' type='hidden' /></td>";
				innerhtml += "<td width='12%'><input name='addeddevicename"+index+"' id='addeddevicename"+index+"' idindex='"+index+"' value='"+queryObj[index].device_name+"' style='line-height:18px;width:98%' size='10' type='text' /></td>";
				innerhtml += "<td width='12%'><input name='addeddevicetype"+index+"' id='addeddevicetype"+index+"' value='"+queryObj[index].device_model+"' style='line-height:18px;width:98%' size='10' type='text' /></td>";
				innerhtml += "<td width='10%'><input name='addedunit"+index+"' id='addedunit"+index+"' value='"+queryObj[index].unit_name+"' style='line-height:18px;width:98%' size='8' type='text' /></td>";
				innerhtml += "<td width='10%'><input name='addedassignnum"+index+"' id='addedassignnum"+index+"' style='line-height:18px;width:98%' value='"+queryObj[index].device_num+"' type='text' size='8' onkeyup='checkInputNum(this)'/></td>";
				innerhtml += "<td width='10%'><input name='addedremark"+index+"' id='addedremark"+index+"' value='"+queryObj[index].devremark+"' style='line-height:18px;width:98%' size='10' type='text' /></td>";
				innerhtml += "</tr>";
				$("#addeddetailtable").append(innerhtml);
			}
			$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
			$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
			$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
			$("#addeddetailtable>tr:even>td:even").addClass("even_even");
		}
	}
</script>
<script type="text/javascript">
var mixstate_tmp="<%=mixstate%>";
$().ready(function(){
	$("#alldetinfo").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='addedseq']").attr('checked',checkvalue);
	});
	
	$("#devbackinfo").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='didinfo']").attr('checked',checkvalue);
	});
	//已分配的大港自有地震仪器单据屏蔽提交按钮
    if(mixstate_tmp == '9'){
    	$(".tj_btn").hide();      
    }
});

	function submitInfo(state){
		
		var outdate = $("#out_date").val();
		if(outdate == ""){
			alert("出库时间 不能为空!");
			return;
		}
		
		//保留的行信息
		var count = 0;
		var line_infos;
		var idinfos ;
		$("input[type='checkbox'][name='didinfo']").each(function(){
			if(this.checked == true){
				if(count == 0){
					line_infos = this.id;
					idinfos = this.value;
				}else{
					line_infos += "~"+this.id;
					idinfos += "~"+this.value;
				}
				count = count+1;
			}
		});
		if(count == 0){
			alert('请选择出库单明细信息！');
			return;
		}
		var selectedlines = line_infos.split("~");
		var wronglineinfos = "";
		for(var index=0;index<selectedlines.length;index++){
			var valueinfo = $("#outnum"+selectedlines[index]).val();
			if(valueinfo == ""){
				if(index == 0){
					wronglineinfos += index+1;
				}else{
					wronglineinfos += ","+(index+1);
				}
			}
		}
		if(wronglineinfos!=""){
			alert("请设置第"+wronglineinfos+"行明细的出库数量!");
			return;
		}
		//单台补充明细
		var devaddedcount = 0;
		var devaddedline_infos = "";
		var devaddedwrongflag = true;
		$("input[type='checkbox'][name='addedseq']").each(function(){
			var mixid = this.trinfo;
			if($("#addeddev_acc_id"+mixid).val()==""){
				devaddedwrongflag = false;
			}else{
				if(devaddedcount == 0){
					devaddedline_infos = this.id;
				}else{
					devaddedline_infos += "~"+this.id;
				}
				devaddedcount++;
			}
		});
		if(!devaddedwrongflag){
			alert("请设置您添加的补充单台明细!");
			return;
		}
		//给调配单号设置成空
		$("#outinfo_no").val("");
		//给参数拼上
		var submiturl = "<%=contextPath%>/rm/dm/toSaveOutFormDetailInfoDg.srq?state="+state;
			submiturl += "&count="+count+"&line_infos="+line_infos+"&idinfos="+idinfos;
			submiturl += "&devaddedcount="+devaddedcount+"&devaddedline_infos="+devaddedline_infos;
		document.getElementById("form1").action = submiturl;

		if(state==9 && window.confirm("提交以后数据不可修改,是否提交?")){
			document.getElementById("form1").submit();
		}else if(state==0){
			document.getElementById("form1").submit();
		}
	}
	
	var seqinfo = 0;
	function toMixDetailInfos(){
		seqinfo++;
		var valueinfo ;
		$("input[type='checkbox'][name='idinfo']").each(function(){
			if(this.checked == true){
				valueinfo = this.value; 
			}
		});
		if(valueinfo == undefined)
			return;
		var size = $("div[id='tab_box_content"+valueinfo+"']","#tab_box").size();
		if(size==1){
			//给当前显示，其他的都隐藏
			$("div","#tab_box").hide();
			$("div[id='tab_box_content"+valueinfo+"']","#tab_box").show();
			//给标签页加个选中样式
			$("li","#tag-container_3").removeClass("selectTag");
			$("li[id='tag3_"+valueinfo+"']","#tag-container_3").addClass("selectTag");
		}else{
			var showid ;
			var showmodeltype ;
			$("input[type='checkbox'][name='idinfo']").each(function(){
				if(this.checked == true){
					showid = this.id;
					showmodeltype = this.devcodetype;
				}
			});
			var showname = $("#colldevicename"+showid).val()+"("+$("#colldevicetype"+showid).val()+")";
			var taginnerhtml = "<li id='tag3_"+valueinfo+"'><a href='#' onclick=getContentTab('"+valueinfo+"')>"+showname+"</a></li>";
			$("#tags").append(taginnerhtml);
			var containhtml = "<div style='width:98%' id='tab_box_content"+valueinfo+"' name='tab_box_content"+valueinfo+"' idinfo='"+valueinfo+"' style='width:97%' class='tab_box_content'>";
			containhtml += "<table border='0' cellpadding='0' cellspacing='0'  class='tab_line_height' style='width:99%' style='margin-top:10px;background:#efefef'>";
			containhtml += "<tr class='bt_info'>";
			containhtml += "<td class='bt_info_odd' width='4%'>选择</td>";
			containhtml += "<td class='bt_info_even' width='4%'>序号</td>";
			containhtml += "<td class='bt_info_odd' width='11'>设备名称</td>";
			containhtml += "<td class='bt_info_even' width='11%'>规格名称</td>";
			containhtml += "<td class='bt_info_odd' width='11%'>计量单位</td>";
			containhtml += "<td class='bt_info_even' width='9%'>道数</td>";
			containhtml += "<td class='bt_info_odd' width='10%'>出库数量</td>";
			containhtml += "<td class='bt_info_even' width='10%'>库存数量</td>";
			containhtml += "<td class='bt_info_odd' width='10%'>总道数</td></tr>";
			containhtml += "<tbody id='detailList"+valueinfo+"' name='detailList"+valueinfo+"'></tbody></table></div> ";
			$("#tab_box").append(containhtml);
			//给当前显示，其他的都隐藏
			$("div","#tab_box").hide();
			$("div[id='tab_box_content"+valueinfo+"']","#tab_box").show();
			//给标签页加个选中样式
			$("li","#tag-container_3").removeClass("selectTag");
			$("li[id='tag3_"+valueinfo+"']","#tag-container_3").addClass("selectTag");
			//模板归零
			var querySql = "select model_mainid,model_name ";
			querySql += "from gms_device_collmodel_main main ";
			//querySql += "where main.bsflag='0' and model_type='"+showmodeltype+"'";
			querySql += "where main.bsflag='0' ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
			if(basedatas!=undefined && basedatas.length>0){
				//回填基本信息
				for(var index=0;index<basedatas.length;index++){
					var innerhtml = "<option value='"+basedatas[index].model_mainid+"'>"+basedatas[index].model_name+"</option>";
					$("#selectmodel").append(innerhtml);
				}
			}
			//给模板放进内容 end
			$("#selectmodel").val("");
			$("#selectmodeltd").show();
			$("#addtd").show();
			$("#deltd").show();
		}
		//var querySql = "select cds.device_name,cds.device_model,detail.coding_name as unitname, unit_id,cds.device_slot_num,cds.device_num,det.apply_num from gms_device_app_colldetsub cds left join gms_device_app_colldetail det on cds.device_app_detid=det.device_app_detid left join comm_coding_sort_detail detail on detail.coding_code_id = cds.unit_id where cds.device_app_detid = '"+detailmainid+"'";
		var querySql = "select cds.device_id,cds.device_name,cds.device_model,detail.coding_name as unitname, unit_id,cds.device_slot_num,cds.device_num,device_slot_num*device_num as apply_num from gms_device_app_colldetsub cds left join gms_device_app_colldetail det on cds.device_app_detid=det.device_app_detid left join comm_coding_sort_detail detail on detail.coding_code_id = cds.unit_id where cds.device_app_detid = '"+detailmainid+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql+'&pageSize=10000');
		var queryObj = queryRet.datas;
		if(queryObj && queryObj.length>0){
			var index;
			for(index=0;index<queryObj.length;index++){
				var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seqinfo='"+index+"'>";
				innerhtml += "<td><input type='checkbox' name='didinfo' id='"+index+"' checked='true'/></td>";
				innerhtml += "<td>"+(index+1)+"<input type='hidden' id='deviceid"+index+"' name='deviceid"+index+"' value='"+queryObj[index].device_id+"'></td>";
				innerhtml += "<td><input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='"+queryObj[index].device_name+"' size='30' type='text' readonly/></td>";
				innerhtml += "<td><input name='devicemodel"+index+"' id='devicemodel"+index+"' style='line-height:15px' value='"+queryObj[index].device_model+"' size='30' type='text' readonly/></td>";
				innerhtml += "<td><select id='unitList"+index+"' name='unitList"+index+"' style='select_width'></select></td>";
				innerhtml += "<td><input name='devslotnum"+index+"' id='devslotnum"+index+"' style='line-height:15px' value='"+queryObj[index].device_slot_num+"' size='6' type='text' readonly/></td>";
				innerhtml += "<td><input name='outnum"+index+"' id='outnum"+index+"' checkinfo='"+index+"' style='line-height:15px' value='"+queryObj[index].device_num+"' size='10' type='text' onkeyup='checkInputNum(this)'/></td>";
				innerhtml += "<td><input name='unusenum"+index+"' id='unusenum"+index+"' checkinfo='"+index+"' style='line-height:15px' value='' size='10' type='text' '/></td>";
				innerhtml += "<td><input name='totalslotnum"+index+"' id='totalslotnum"+index+"' style='line-height:15px' value='"+queryObj[index].apply_num+"' size='10' type='text' readonly/></td>";
				innerhtml += "</tr>";
				$("#detailList"+valueinfo).append(innerhtml);
			}
			$("#detailList"+valueinfo+">tr:odd>td:odd").addClass("odd_odd");
			$("#detailList"+valueinfo+">tr:odd>td:even").addClass("odd_even");
			$("#detailList"+valueinfo+">tr:even>td:odd").addClass("even_odd");
			$("#detailList"+valueinfo+">tr:even>td:even").addClass("even_even");
			var retObj;
			var unitSql = "select sd.coding_code_id,coding_name ";
			unitSql += "from comm_coding_sort_detail sd "; 
			unitSql += "where coding_sort_id ='5110000038' order by coding_code";
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql+'&pageSize=10000');
			retObj = unitRet.datas;
			var optionhtml = "";
			var i=0;
			for(var index=0;index<retObj.length;index++){
				if(queryObj[i].unit_id == retObj[index].coding_code_id){
					optionhtml +=  "<option name='unitcode"+index+"' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"' selected>"+retObj[index].coding_name+"</option>";
				}else{
					optionhtml +=  "<option name='unitcode"+index+"' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
				}
			}
			for(;i<index;i++){
				$("#unitList"+i).append(optionhtml);
			}
		}
	}
	function toAddRowInfo(){
		var obj = new Object();
		var data=window.showModalDialog("<%=contextPath%>/rm/dm/collectTree/collectCJDTreeManager.jsp?ctxmenu=false&inline=true",obj,"dialogWidth=300px;dialogHeight=400px");
		if(data!=undefined){
			//查找现在的显示标签页
			var divobj;
			$("div[name^='tab_box_content']","#tab_box").each(function(i){
				if(this.style.display == 'block'){
					divobj = this.idinfo;
				}
			});
			if(divobj == undefined)
				return;
			//查找最大的index
			var maxseqinfo = $("#detailList"+divobj+">tr:last").attr("seqinfo");
			if(maxseqinfo == undefined || maxseqinfo == ''){
				maxseqinfo = 0;
			}

			var currentseq = parseInt(maxseqinfo,10)+1;
			
			//给所有的unusenum设置为空
			//$("input[type='text'][name^='unusenum']","#detailList"+divobj).val("0");
			var owingSubId = document.getElementById("out_sub_id").value;
			
			var mainsql = "select account.dev_acc_id,usage_org_id,device_id,teach.good_num as unusenum from gms_device_coll_account account ";
				mainsql += "left join gms_device_coll_account_tech teach on teach.dev_acc_id=account.dev_acc_id ";
				mainsql += "where account.usage_sub_id like '"+owingSubId+"#gmslike#' and account.bsflag='0' and account.ifcountry !='国外' ";
				mainsql += "and account.device_id='"+data.device_id+"' ";
	 			
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+mainsql);
			retObj = proqueryRet.datas;
			if(retObj!=undefined && retObj.length == 0){
				alert(data.dev_name+"："+data.dev_model+" 库存为0，请更换型号或者更新库存！");
				return;
			}
						
			var innerhtml = "<tr id='tr"+divobj+currentseq+"' name='tr"+divobj+currentseq+"' seqinfo='"+currentseq+"'>";
			innerhtml += "<td><input type='checkbox' name='didinfo' id='"+divobj+currentseq+"' checked='true'/></td>";
			innerhtml += "<td>"+currentseq+"<input type='hidden' id='deviceid"+divobj+currentseq+"' name='deviceid"+divobj+currentseq+"' value='"+data.device_id+"'></td>";
			innerhtml += "<td><input name='devicename"+divobj+currentseq+"' id='devicename"+divobj+currentseq+"' style='line-height:15px' value='"+data.dev_name+"' size='30' type='text' readonly/></td>";
			innerhtml += "<td><input name='devicemodel"+divobj+currentseq+"' id='devicemodel"+divobj+currentseq+"' style='line-height:15px' value='"+data.dev_model+"' size='30' type='text' readonly/></td>";
			innerhtml += "<td><select id='unitList"+divobj+currentseq+"' name='unitList"+divobj+currentseq+"' style='select_width'></select></td>";
			innerhtml += "<td><input name='devslotnum"+divobj+currentseq+"' id='devslotnum"+divobj+currentseq+"' style='line-height:15px' value='"+data.dev_slot_num+"' size='6' type='text' readonly/></td>";
			innerhtml += "<td><input name='outnum"+divobj+currentseq+"' id='outnum"+divobj+currentseq+"' checkinfo='"+divobj+currentseq+"' style='line-height:15px' value='' size='10' type='text' onkeyup='checkInputNum(this)'/></td>";
			innerhtml += "<td><input name='unusenum"+divobj+currentseq+"' id='unusenum"+divobj+currentseq+"' checkinfo='"+divobj+currentseq+"' style='line-height:15px' value='"+retObj[0].unusenum+"' size='10' type='text' readonly/>";
			innerhtml += "<input name='devaccid"+divobj+currentseq+"' id='devaccid"+divobj+currentseq+"' value='"+retObj[0].dev_acc_id+"' type='hidden' /></td>";
			innerhtml += "<td><input name='totalslotnum"+divobj+currentseq+"' id='totalslotnum"+divobj+currentseq+"' style='line-height:15px' value='' size='10' type='text' readonly/></td>";
			innerhtml += "</tr>";
			$("#detailList"+divobj).append(innerhtml);
			
			$("#detailList"+divobj+">tr:odd>td:odd").addClass("odd_odd");
			$("#detailList"+divobj+">tr:odd>td:even").addClass("odd_even");
			$("#detailList"+divobj+">tr:even>td:odd").addClass("even_odd");
			$("#detailList"+divobj+">tr:even>td:even").addClass("even_even");
			//给当前这个单位追加数据
			var retObj;
			var unitSql = "select sd.coding_code_id,coding_name ";
			unitSql += "from comm_coding_sort_detail sd "; 
			unitSql += "where coding_sort_id ='5110000038' order by coding_code";
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql+'&pageSize=10000');
			retObj = unitRet.datas;
			var optionhtml = "";
			for(var index=0;index<retObj.length;index++){
				optionhtml +=  "<option name='unitcode"+index+"' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
			}
			$("#unitList"+divobj+currentseq).append(optionhtml);
		}
	}
	function toDelRowInfo(){
		//查找现在的显示标签页
		var divobj;
		$("div[name^='tab_box_content']","#tab_box").each(function(i){
			if(this.style.display == 'block'){
				divobj = this.idinfo;
			}
		})
		if(divobj == undefined)
			return;
		$("input[type='checkbox'][name='didinfo']","#detailList"+divobj).each(function(i){
			if(this.checked == true){
				var id=this.id;
				$("#tr"+id,"#detailList"+divobj).remove();
			}
		});
		$("#detailList"+divobj+">tr:odd>td:odd").addClass("odd_odd");
		$("#detailList"+divobj+">tr:odd>td:even").addClass("odd_even");
		$("#detailList"+divobj+">tr:even>td:odd").addClass("even_odd");
		$("#detailList"+divobj+">tr:even>td:even").addClass("even_even");
	}
	$().ready(function(){
		$("#selectmodel").change(function(){
			var value = $("#selectmodel").val();
			if(value == ''){
				return;
			}
			//获得当前显示的填报明细，给重新复制
			var divobj;
			$("div[name^='tab_box_content']","#tab_box").each(function(i){
				if(this.style.display == 'block'){
					divobj = this.idinfo;
				}
			})
			if(divobj == undefined)
				return;
			//先查询模板的子记录
			var querySql = "select sub.device_id,sub.device_name,sub.device_model,sub.unit_id,";
				querySql += "detail.coding_name as unit_name,sub.device_slot_num ";
				querySql += "from gms_device_collmodel_sub sub ";
				querySql += "left join gms_device_collectinfo ci on sub.device_id=ci.device_id ";
				querySql += "left join gms_device_collmodel_main main on main.model_mainid=sub.model_mainid ";
				querySql += "left join comm_coding_sort_detail detail on sub.unit_id=detail.coding_code_id ";
				querySql += "where main.bsflag='0' and sub.model_mainid='"+value+"' order by ci.dev_code ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql+'&pageSize=10000');
				basedatas = queryRet.datas;
			if(basedatas!=undefined && basedatas.length>0){
				$("#detailList"+divobj).empty();
				var lineinfo;
				//回填基本信息
				for(var index=0;index<basedatas.length;index++){
					lineinfo = index+1;
					var innerhtml = "<tr id='tr"+divobj+lineinfo+"' name='tr"+divobj+lineinfo+"' seqinfo='"+lineinfo+"'>";
					innerhtml += "<td><input type='checkbox' name='didinfo' id='"+divobj+lineinfo+"' checked='true'/></td>";
					innerhtml += "<td>"+lineinfo+"<input type='hidden' id='deviceid"+divobj+lineinfo+"' name='deviceid"+divobj+lineinfo+"' value='"+basedatas[index].device_id+"'></td>";
					innerhtml += "<td><input name='devicename"+divobj+lineinfo+"' id='devicename"+divobj+lineinfo+"' style='line-height:15px' value='"+basedatas[index].device_name+"' size='30' type='text' readonly/></td>";
					innerhtml += "<td><input name='devicemodel"+divobj+lineinfo+"' id='devicemodel"+divobj+lineinfo+"' style='line-height:15px' value='"+basedatas[index].device_model+"' size='30' type='text' readonly/></td>";
					innerhtml += "<td><input name='unit_name"+divobj+lineinfo+"' id='unit_name"+divobj+lineinfo+"' style='line-height:15px' value='"+basedatas[index].unit_name+"' size='4' type='text' readonly/>";
					innerhtml += "<input name='unitList"+divobj+lineinfo+"' id='unitList"+divobj+lineinfo+"' value='"+basedatas[index].unit_id+"' type='hidden' /></td>";
					innerhtml += "<td><input name='devslotnum"+divobj+lineinfo+"' id='devslotnum"+divobj+lineinfo+"' style='line-height:15px' value='"+basedatas[index].device_slot_num+"' size='6' type='text' readonly/></td>";
					innerhtml += "<td><input name='outnum"+divobj+lineinfo+"' id='outnum"+divobj+lineinfo+"' checkinfo='"+divobj+lineinfo+"' style='line-height:15px' value='' size='10' type='text' onkeyup='checkInputNum(this)'/></td>";
					innerhtml += "<td><input name='totalslotnum"+divobj+lineinfo+"' id='totalslotnum"+divobj+lineinfo+"' style='line-height:15px' value='' size='10' type='text' readonly/></td>";
					innerhtml += "</tr>";
					$("#detailList"+divobj).append(innerhtml);
				}
				$("#detailList"+divobj+">tr:odd>td:odd").addClass("odd_odd");
				$("#detailList"+divobj+">tr:odd>td:even").addClass("odd_even");
				$("#detailList"+divobj+">tr:even>td:odd").addClass("even_odd");
				$("#detailList"+divobj+">tr:even>td:even").addClass("even_even");
			}
		})
	});

	var addedseqinfo = 0;
	function toAddAddedDetailInfos(){
		var startdate = $("#collstartdate0").val();
		var enddate = $("#collenddate0").val();
		addedseqinfo++;
		var innerhtml = "<tr id='tradded"+addedseqinfo+"' name='tradded"+addedseqinfo+"' seq='"+addedseqinfo+"' is_added='false'>";
		innerhtml += "<td width='4%'><input type='checkbox' name='addedseq' id='"+addedseqinfo+"' trinfo ="+addedseqinfo+" checked/></td>";
		innerhtml += "<td width='12%'><input name='addeddevicename"+addedseqinfo+"' id='addeddevicename"+addedseqinfo+"' value='' style='line-height:18px;width:98%' type='text' readonly/></td>";
		innerhtml += "<td width='12%'><input name='addeddevicetype"+addedseqinfo+"' id='addeddevicetype"+addedseqinfo+"' value='' style='line-height:18px;' size='10' type='text' readonly/><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick=showAddedDevPage("+addedseqinfo+") /></td>";
		innerhtml += "<td width='10%'><input name='addeddev_acc_id"+addedseqinfo+"' id='addeddev_acc_id"+addedseqinfo+"' seq='"+addedseqinfo+"' type='hidden'/>";
		innerhtml += "<input name='addeddevcicode"+addedseqinfo+"' id='addeddevcicode"+addedseqinfo+"' value='' type='hidden'/>";
		innerhtml += "<input name='addedself_num"+addedseqinfo+"' id='addedself_num"+addedseqinfo+"' style='line-height:18px;width:98%' type='text' readonly/></td>";
		innerhtml += "<td width='10%'><input name='addedlicense_num"+addedseqinfo+"' id='addedlicense_num"+addedseqinfo+"' value='' style='line-height:18px;width:98%' type='text' readonly/></td>";
		innerhtml += "<td width='10%'><input name='addeddev_sign"+addedseqinfo+"' id='addeddev_sign"+addedseqinfo+"' style='line-height:18px;width:98%' type='text' readonly/></td>";
		innerhtml += "<td width='10%'><input name='addedasset_coding"+addedseqinfo+"' id='addedasset_coding"+addedseqinfo+"' style='line-height:18px;width:98%' value='' readonly/></td>";
		innerhtml += "<td width='11%'><input name='addedplanstartdate"+addedseqinfo+"' id='startdate"+addedseqinfo+"' style='line-height:15px' value='"+startdate+"' size='9' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+addedseqinfo+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(addedplanstartdate"+addedseqinfo+",tributton2"+addedseqinfo+");'/></td>";
		innerhtml += "<td width='11%'><input name='addedplanenddate"+addedseqinfo+"' id='enddate"+addedseqinfo+"' style='line-height:15px' value='"+enddate+"' size='9' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+addedseqinfo+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(addedplanenddate"+addedseqinfo+",tributton3"+addedseqinfo+");'/></td>";
		innerhtml += "<td width='10%'><input name='addedremark"+addedseqinfo+"' id='addedremark"+addedseqinfo+"' value='' size='10' type='text' /></td>";
		innerhtml += "</tr>";
		$("#addeddetailtable").append(innerhtml);
		$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
		$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
		$("#addeddetailtable>tr:even>td:even").addClass("even_even");
		$("#tab_box").show();
	}
	function showAddedDevPage(seqinfo){
		var obj = new Object();
		var pageselectedstr = null;
		var checkstr = 0;
		$("input[name^='addeddev_acc_id'][type='hidden']").each(function(i){
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
		var dialogurl ="<%=contextPath%>/rm/dm/tree/selectAccountForAdded_dg.jsp";
		dialogurl = encodeURI(dialogurl);
		dialogurl = encodeURI(dialogurl);
		var vReturnValue = window.showModalDialog(dialogurl, obj ,"dialogWidth=820px;dialogHeight=500px;scroll:yes");
		if(vReturnValue!=undefined){
			
			var returnvalues = vReturnValue.split('~');
			//返回信息是 队级台账id + 设备编码 + 设备名称 + 规格型号 + 自编号 + 实物标识号 + 牌照号
			$("input[name='addeddev_acc_id"+seqinfo+"']","#addeddetailtable").val(returnvalues[0]);
			$("input[name='addedasset_coding"+seqinfo+"']","#addeddetailtable").val(returnvalues[1]);
			$("input[name='addeddevicename"+seqinfo+"']","#addeddetailtable").val(returnvalues[2]);
			$("input[name='addeddevicetype"+seqinfo+"']","#addeddetailtable").val(returnvalues[3]);
			$("input[name='addedself_num"+seqinfo+"']","#addeddetailtable").val(returnvalues[4]);
			$("input[name='addeddev_sign"+seqinfo+"']","#addeddetailtable").val(returnvalues[5]);
			$("input[name='addedlicense_num"+seqinfo+"']","#addeddetailtable").val(returnvalues[6]);
			$("input[name='addeddevcicode"+seqinfo+"']","#addeddetailtable").val(returnvalues[7]);
		}
	}
	function toDelAddedDetailInfos(){

		$("input[name='addedseq'][type='checkbox']").each(function(i){
			if(this.checked){
				var index = this.id;
				$("#tradded"+index,"#addeddetailtable").remove();
			}
		});

		$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
		$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
		$("#addeddetailtable>tr:even>td:even").addClass("even_even");
	}
	function checkInputNum(obj){
		var lineid = obj.checkinfo;
		var applynumVal = parseInt($("#outnum"+lineid).val(),10);//分配数量
		var unusenumVal = parseInt($("#unusenum"+lineid).val(),10);//库存数量
		
		var devslotnum = $("#devslotnum"+lineid).val();
		if(devslotnum == ""){
			devslotnum = 0;
		}

		var value = obj.value;
		var re = /^\+?[1-9][0-9]*$/;
		if(value==""){
			$("#totalslotnum"+lineid).val("");
			return;
		}
		if(!re.test(value)){
			alert("明细需求数量必须为数字!");
			obj.value = "";
			$("#totalslotnum"+lineid).val("");
        	return false;
		}else{
			if(applynumVal>unusenumVal){
				alert("库存数量小于申请数量,不能分配!");
				obj.value = "";
				$("#totalslotnum"+lineid).val("");
				return false;
			}
		}
		$("#totalslotnum"+lineid).val(parseInt(devslotnum)*parseInt(value));
	}
</script>
</html>