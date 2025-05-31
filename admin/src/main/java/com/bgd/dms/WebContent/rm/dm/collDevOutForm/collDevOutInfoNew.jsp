<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String mixInfoId = request.getParameter("mixInfoId");
	String oprstate = request.getParameter("oprstate");
	UserToken user = OMSMVCUtil.getUserToken(request);
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
<link id="artDialogSkin" href="<%=contextPath %>/js/artDialog/skins/blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath %>/js/artDialog/artDialog.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>多项目-设备出库-设备出库(按量装备设备)-出库单添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%;height: 510px;">
  <div id="new_table_box_content" style="width:100%;height: 520px;">
    <div id="new_table_box_bg" style="width:95%;height: 480px;">
      <fieldset style="margin-left:2px"><legend style="font-size: 13px;">基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >出库单号:</td>
          <td class="inquire_form4" >
          	<input name="outinfo_no" id="outinfo_no" class="input_width" type="text"  value="保存后自动生成..." readonly/>
          </td>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text"  value="" readonly/>
          	<input name="project_info_no" id="project_info_no" class="input_width" type="hidden"  value="" />
          	<input name="devicemixinfoid" id="devicemixinfoid" type="hidden" value="<%=mixInfoId%>" />
          	<input name="devouttype" id="devouttype" type="hidden" value="1" />
          	<input name="mix_type_id" id="mix_type_id" type="hidden" value="S1405" />
          	<input name="planstartdate" id="planstartdate" type="hidden" value="" />
          	<input name="planenddate" id="planenddate" type="hidden" value="" />
          	<input name="project_type" id="project_type" type="hidden" value="" />
          </td>
          <td class="inquire_item4" ></td><td class="inquire_form4" ></td>
        </tr>
        <tr>
          <td class="inquire_item4" >调配单号:</td>
          <td class="inquire_form4" >
          	<input name="mixinfo_no" id="mixinfo_no" class="input_width" type="text"  value="" readonly/>
          </td>
          <td class="inquire_item4" >调配时间:</td>
          <td class="inquire_form4" >
          	<input name="mix_date" id="mix_date" class="input_width" type="text"  value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >转入单位:</td>
          <td class="inquire_form4" >
          	<input name="in_org_name" id="in_org_name" class="input_width" type="text"  value="" readonly/>
          	<input name="in_org_id" id="in_org_id" class="input_width" type="hidden"  value="" />
          	<input name="in_sub_id" id="in_sub_id" class="input_width" type="hidden"  value="" />
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
	  <fieldset style="margin-left:2px;margin-top: 15px;background-color: #ccccff;"><legend style="font-size: 13px;">出库明细</legend>
		  <div style="overflow:auto">
			  <table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_even" width="4%">选择</td>
					<td class="bt_info_odd" width="13%">设备名称</td>
					<td class="bt_info_even" width="13%">规格型号</td>
					<td class="bt_info_odd" width="10%">计量单位</td>
					<td class="bt_info_even" width="10%">调配数量</td>
					<td class="bt_info_odd" width="10%">调配备注</td>
					<td class="bt_info_even" width="10%">已出库数量</td>
					<td class="bt_info_odd" width="10%">闲置数量</td>
					<td class="bt_info_even" width="10%">出库数量</td>
					<td class="bt_info_odd" width="10%">备注</td>
				</tr>
			   </table>
				<div style="height:120px;overflow:auto;">
				<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style='table-layout: auto'>
			   	<tbody id="processtable" name="processtable" >
			   	</tbody>
		      	</table>
		      	</div>
	       </div>
      </fieldset>
      <fieldset style="margin-left:2px;margin-top: 15px;background-color: #66FFFF;"><legend style="font-size: 13px;">补充明细</legend>
		  <div style="overflow:auto">
			  <table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       		<tr>
						<td class="bt_info_even" width="4%">选择</td>
						<td class="bt_info_odd" width="13%">设备名称</td>
						<td class="bt_info_even" width="13%">规格型号</td>
						<td class="bt_info_odd" width="10%">计量单位</td>
						<td class="bt_info_even" width="10%">调配数量</td>
						<td class="bt_info_odd" width="10%">调配备注</td>
						<td class="bt_info_even" width="10%">已出库数量</td>
						<td class="bt_info_odd" width="10%">出库数量</td>
						<td class="bt_info_even" width="10%">备注</td>
					</tr>
			   </table>
				<div style="height:120px;overflow:auto;">
				<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style='table-layout: auto'>
			   		<tbody id="mixprocesstable" name=mixprocesstable >
			   		</tbody>
		      	</table>
		      	</div>
	       </div>
	  		<fieldset style="margin-left:2px;width:97.9%"><legend>补充出库明细</legend>
	        	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				     <tr>
				        <td width="5%"><span class="jl"><a href="#" id="mixaddbtn" onclick='toMixMixedDetailInfos()' title="填报补充明细"></a></span></td>
				        <td width="5%"><span class="xg"><a href="#" id="mixmodifybtn" onclick='toModifyMixedDetailInfos()' title="修改补充明细"></a></span></td>
				        <td width="5%" align="right"><span class="zj"><a href="#" id="addallbtn" onclick='toAddMixInfos()' title="多选台帐明细"></a></span></td>
				        <td width="75%"></td>
				        <td width="5%" align="right"><span class="zj"><a href="#" id="addaddedbtn" onclick='toAddAddedDetailInfo()' title="添加"></a></span></td>
	          			<td width="5%" align="right"><span class="sc"><a href="#" id="deladdedbtn" onclick='toDelAddedDetailInfo()' title="删除"></a></span></td>
				     </tr>
				</table>
				<div id="mixtab_box" class="tab_box" style="height:120px;overflow:auto;display:none">
					<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			       		<tr>
							<td class="bt_info_even" width="4%">选择</td>
							<td class="bt_info_odd" width="12%">设备名称</td>
							<td class="bt_info_even" width="12%">规格型号</td>
							<td class="bt_info_odd" width="10%">自编号</td>
							<td class="bt_info_even" width="10%">实物标识号</td>
							<td class="bt_info_odd" width="10%">牌照号</td>
							<td class="bt_info_even" width="10%">AMIS资产编号</td>
							<td class="bt_info_odd" width="11%">计划进场时间</td>
							<td class="bt_info_even" width="11%">计划离场时间</td>
							<td class="bt_info_odd" width="10%">备注</td>
						</tr>
					</table>
					<div style="height:90px;overflow:auto;">
						<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style='table-layout: auto'>
			   	 			<tbody id="addeddetailtable" name="addeddetailtable">
			    			</tbody>
						</table>
					</div>
				</div>
		  </fieldset>
      </fieldset>
    </div>
    </div>
	</div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo(9)"></a></span>
     	 <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
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
function dialogClose(str){
	if(str!=''){
		art.dialog.list['KDf435'].close();
	}
}
function dialogValue(str){
	if(str!=''){
	 art.dialog({
		 id:'KDf435',
		 left:200,
		 opacity: 0.87,
		    padding: 0,
		    width: '300',
		    height: 80,
		    title: '调配备注',
		    content: str   
		});
	}
}
	function submitInfo(state){
		//给信息保存到数据库中，重写入库操作
		var outdate = $("#out_date").val();
		if(outdate == ""){
			alert("出库时间 不能为空!");
			return;
		}
		//保留的行信息
		var count = 0;
		var line_infos;
		var idinfos ;
		$("input[type='checkbox'][name='detinfo']").each(function(){
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
		
		//给补充明细进行校验，如果有选中的补充明细，那么对应的出库数量必须不为空
		var mixcount = 0;
		var mixline_infos = "";
		var mixidinfos = "";
		var mixwrongflag = true;
		$("input[type='checkbox'][name='mixdetinfo']").each(function(){
			var mixid = this.value;
		    var mixnum = this.id;
			
			if(this.checked == true){
				if($("#mixoutednum"+mixnum).val()==""){
					mixwrongflag = false;
				}else{
					if(mixcount == 0){
						mixline_infos = this.id;
						mixidinfos = this.value;
					}else{
						mixline_infos += "~"+this.id;
						mixidinfos += "~"+this.value;
					}
					mixcount++;
				}
			}
		});
		if(!mixwrongflag && count == 0){
			alert("请设置出库单明细信息或者调配补充明细的出库数量!");
			return;
		}
		//if(count == 0){
		//	alert('请选择出库单明细信息！');
		//	return;
		//}
		if(count != 0){
			var selectedlines = line_infos.split("~");
			var wronglineinfos = "";
			for(var index=0;index<selectedlines.length;index++){
				var valueinfo = $("#outnum"+selectedlines[index]).val();
				if(valueinfo == ""){
					if(index == 0){
						wronglineinfos += (parseInt(selectedlines[index])+1);
					}else{
						wronglineinfos += ","+(parseInt(selectedlines[index])+1);
					}
				}
			}
			if(wronglineinfos!=""){
				alert("请设置第"+wronglineinfos+"行明细的出库数量!");
				return;
			}
		}
		//单台补充明细
		var devaddedcount = 0;
		var devaddedline_infos = "";
		var devaddedwrongflag = true;
		$("input[type='checkbox'][name='mixdetseq']").each(function(){
			var mixid = this.trinfo;
			if($("#mixdetdev_acc_id"+mixid).val()==""){
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

		var addedcount = $("input[type='hidden'][name^='addeddev_acc_id']","#addeddetailtable").size();
		var addedline_info;
		$("input[type='hidden'][name^='addeddev_acc_id']","#addeddetailtable").each(function(i){
			var seq = this.seq;
			if(i==0){
				addedline_info = seq;
			}else{
				addedline_info += "~"+seq;
			}
		})

		//给调配单号设置成空
		$("#outinfo_no").val("");

		if(count == 0 && mixcount ==0 ){
			alert("请设置出库明细信息!");
			return;
		}else if(mixcount != 0&& devaddedcount == 0){
			alert("请设置您添加的补充单台明细!");
			return;
		}
		//给参数拼上
		var submiturl = "<%=contextPath%>/rm/dm/toSaveOutFormDetailInfoNew.srq?state="+state;
		submiturl += "&count="+count+"&line_infos="+line_infos+"&idinfos="+idinfos;
		submiturl += "&mixcount="+mixcount+"&mixline_infos="+mixline_infos+"&mixidinfos="+mixidinfos;
		submiturl += "&devaddedcount="+devaddedcount+"&devaddedline_infos="+devaddedline_infos;
		submiturl += "&addedcount="+addedcount+"&addedline_info="+addedline_info;

		document.getElementById("form1").action = submiturl;
		if(state==9 && window.confirm("提交以后数据不可修改,是否提交?")){
			document.getElementById("form1").submit();
		}else if(state==0){
			document.getElementById("form1").submit();
		}
	}
	function refreshData(){
		var retObj;
		var basedatas;
		var planstartdate;
		var planenddate;
		var ownorgid='';
		if('<%=mixInfoId%>'!=null){
			//回填基本信息
			var mainsql = "select tp.project_type,cmf.own_org_id,tail.plan_start_date,tail.plan_end_date,cmf.mixinfo_no,cmf.project_info_no,";
				mainsql += "outsub.org_subjection_id out_sub_id,cmf.in_org_id,insub.org_subjection_id in_sub_id,cmf.out_org_id,cmf.device_mixinfo_id,cmf.modifi_date as mix_date,";
				mainsql += "tp.project_name,inorg.org_abbreviation as in_org_name,outorg.org_abbreviation as out_org_name ";
				mainsql += "from gms_device_collmix_form cmf ";
				mainsql += "left join gp_task_project tp on cmf.project_info_no=tp.project_info_no ";
				mainsql += "left join gms_device_collapp pp on cmf.device_app_id = pp.device_app_id and pp.bsflag = '0' ";
				mainsql += "left join gms_device_allapp_colldetail tail on pp.device_allapp_id = tail.device_allapp_id and tail.bsflag = '0' ";
				mainsql += "left join comm_org_information inorg on cmf.in_org_id=inorg.org_id and inorg.bsflag = '0' ";
				mainsql += "left join comm_org_subjection insub on cmf.in_org_id = insub.org_id and insub.bsflag = '0' ";
				mainsql += "left join comm_org_information outorg on cmf.out_org_id=outorg.org_id and outorg.bsflag = '0' ";
				mainsql += "left join comm_org_subjection outsub on outsub.org_id=cmf.out_org_id and outsub.bsflag = '0' ";
				mainsql += "where cmf.bsflag = '0' and cmf.device_mixinfo_id='<%=mixInfoId%>' order by tail.create_date desc ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+mainsql);
			retObj = proqueryRet.datas;
			if(retObj!=undefined && retObj.length>0){
				$("#project_name").val(retObj[0].project_name);
				$("#project_info_no").val(retObj[0].project_info_no);
				$("#mixinfo_no").val(retObj[0].mixinfo_no);
				$("#mix_date").val(retObj[0].mix_date);
				$("#in_org_name").val(retObj[0].in_org_name);
				$("#in_org_id").val(retObj[0].in_org_id);
				$("#in_sub_id").val(retObj[0].in_sub_id);
				$("#out_org_name").val(retObj[0].out_org_name);
				$("#out_org_id").val(retObj[0].out_org_id);
				$("#out_sub_id").val(retObj[0].out_sub_id);
				$("#planstartdate").val(retObj[0].plan_start_date);
				$("#planenddate").val(retObj[0].plan_end_date);
				ownorgid=retObj[0].own_org_id;
				planstartdate = retObj[0].plan_start_date;
				planenddate = retObj[0].plan_end_date;
			}
			//为了过度以前没有添加所属单位的单据
			if(ownorgid==''){
				var prosql = "select cms.device_mif_subid,cms.device_id,cms.device_name,cms.device_model,cms.mix_num,cms.team,cms.devremark as mixdevmark,";
					prosql += "nvl(temp.outednum,0) outednum, nvl(tech.good_num,0) as unuse_num,account.dev_acc_id,cms.unit_id,unitsd.coding_name as unit_name ";
					prosql += "from gms_device_coll_mixsub cms ";
					prosql += "left join (select device_mif_subid,sum(out_num) as outednum from gms_device_coll_outsub group by device_mif_subid) temp on temp.device_mif_subid=cms.device_mif_subid ";
					prosql += "left join gms_device_collmix_form cmf on cms.device_mixinfo_id = cmf.device_mixinfo_id ";
					prosql += "left join gms_device_coll_account account on cms.device_id=account.device_id and cmf.out_org_id = account.usage_org_id and (account.bsflag is null or account.bsflag='0') and ( account.ifcountry !='国外' or account.ifcountry is null ) ";
					prosql += "left join comm_coding_sort_detail unitsd on unitsd.coding_code_id=cms.unit_id    join gms_device_coll_account_tech tech on tech.dev_acc_id=account.dev_acc_id                        ";
					prosql += "where cms.device_mixinfo_id='<%=mixInfoId%>'";
					prosql += "order by cms.device_id ";
				var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
				retObj = proqueryRet.datas;
			}else{
				var prosql = "select cms.device_mif_subid,cms.device_id,cms.device_name,cms.device_model,cms.mix_num,cms.team,cms.devremark as mixdevmark,";
					prosql += "nvl(temp.outednum,0) outednum,nvl(account.unuse_num,0) unuse_num,account.dev_acc_id,cms.unit_id,unitsd.coding_name as unit_name ";
					prosql += "from gms_device_coll_mixsub cms ";
					prosql += "left join (select device_mif_subid,sum(out_num) as outednum from gms_device_coll_outsub group by device_mif_subid) temp on temp.device_mif_subid=cms.device_mif_subid ";
					prosql += "left join gms_device_collmix_form cmf on cms.device_mixinfo_id = cmf.device_mixinfo_id ";
					prosql += "left join gms_device_coll_account account on cms.device_id=account.device_id and cmf.out_org_id = account.usage_org_id and cmf.own_org_id = account.owning_org_id and (account.bsflag is null or account.bsflag='0') and ( account.ifcountry !='国外' or account.ifcountry is null ) ";
					prosql += "left join comm_coding_sort_detail unitsd on unitsd.coding_code_id=cms.unit_id ";
					prosql += "where cms.device_mixinfo_id='<%=mixInfoId%>'";
					prosql += "order by cms.device_id ";
				var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
				retObj = proqueryRet.datas;
			}
			if(retObj!=undefined){
				for(var index=0;index<retObj.length;index++){
					//动态新增表格
					var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
					innerhtml += "<td width='4%'><input type='checkbox' name='detinfo' id='"+index+"' value='"+retObj[index].device_mif_subid+"' checked/></td>";
					innerhtml += "<td width='13%'><input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='"+retObj[index].device_name+"' size='12' type='text' readonly/>";
					innerhtml += "<input name='team"+index+"' id='team"+index+"' style='line-height:15px' value='"+retObj[index].team+"' type='hidden' />";
					innerhtml += "<input name='deviceid"+index+"' id='deviceid"+index+"' style='line-height:15px' value='"+retObj[index].device_id+"' type='hidden' /></td>";
					innerhtml += "<td width='13%'><input name='devicemodel"+index+"' id='devicemodel"+index+"' value='"+retObj[index].device_model+"' size='12' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='unitname"+index+"' id='unitname"+index+"' size='8' value='"+retObj[index].unit_name+"' type='text' readonly/>";
					innerhtml += "<input name='unitid"+index+"' id='unitid"+index+"' value='"+retObj[index].unit_id+"' size='8' type='hidden' readonly/></td>";
					innerhtml += "<td width='10%'><input name='mixnum"+index+"' id='mixnum"+index+"' style='line-height:15px' value='"+retObj[index].mix_num+"' size='8' type='text' /></td>";
					innerhtml += "<td width='10%' style='cursor:hand' onmouseout='dialogClose("+"\""+retObj[index].mixdevmark+"\""+")' onmouseover='dialogValue("+"\""+retObj[index].mixdevmark+"\""+")' ><input name='mixdevremark"+index+"' id='mixdevremark"+index+"' value='"+retObj[index].mixdevmark+"' size='8' type='text' readonly/></td>";					
					innerhtml += "<td width='10%'><input name='outednum"+index+"' id='outednum"+index+"' value='"+retObj[index].outednum+"' size='8'  type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='unusenum"+index+"' id='unusenum"+index+"' value='"+retObj[index].unuse_num+"' size='8' type='text' />";
					innerhtml += "<input name='devaccid"+index+"' id='devaccid"+index+"' value='"+retObj[index].dev_acc_id+"' type='hidden' /></td>";					
					innerhtml += "<td width='10%'><input name='outnum"+index+"' id='outnum"+index+"' value='' size='8' type='text' detindex='"+index+"' onkeyup='checkAssignNum(this)'></td>";
					innerhtml += "<td width='10%'><input name='devremark"+index+"' id='devremark"+index+"' value='' size='10' type='text' /></td>";					
					innerhtml += "</tr>";
					$("#processtable").append(innerhtml);		
				}
				$("#processtable>tr:odd>td:odd").addClass("odd_odd");
				$("#processtable>tr:odd>td:even").addClass("odd_even");
				$("#processtable>tr:even>td:odd").addClass("even_odd");
				$("#processtable>tr:even>td:even").addClass("even_even");
			}
			//回填补充明细信息
			var addprosql = "select cms.device_mif_subid,cms.device_id,cms.device_name,cms.device_model,";
				addprosql += "cms.mix_num,cms.team,cms.devremark as mixdevmark,";
				addprosql += "nvl(temp.outednum,0) outednum,cms.unit_name ";
				addprosql += "from gms_device_coll_mixsubadd cms ";
				addprosql += "left join (select device_mif_subid,sum(out_num) as outednum ";
				addprosql += "from gms_device_coll_outsubadd group by device_mif_subid) temp on temp.device_mif_subid=cms.device_mif_subid ";
				addprosql += "left join gms_device_collmix_form cmf on cms.device_mixinfo_id = cmf.device_mixinfo_id ";
				addprosql += "where cms.device_mixinfo_id='<%=mixInfoId%>'";
				addprosql += "order by cms.device_name ";
			var adddproqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+addprosql);
			retObj = adddproqueryRet.datas;
			if(retObj!=undefined){
				for(var index=0;index<retObj.length;index++){
					//动态新增表格
					var innerhtml = "<tr id='mixtr"+index+"' name='mixtr"+index+"' seq='"+index+"'>";
					innerhtml += "<td width='4%'><input type='checkbox' name='mixdetinfo' id='"+index+"' value='"+retObj[index].device_mif_subid+"' checked/></td>";
					innerhtml += "<td width='13%'><input name='mixdevicename"+index+"' id='mixdevicename"+index+"' style='line-height:18px;width:98%' value='"+retObj[index].device_name+"'  type='text' readonly/>";
					innerhtml += "<input name='mixteam"+index+"' id='mixteam"+index+"' value='"+retObj[index].team+"' type='hidden' /></td>";
					innerhtml += "<td width='13%'><input name='mixdevicemodel"+index+"' id='mixdevicemodel"+index+"' value='"+retObj[index].device_model+"' style='line-height:18px;width:98%' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='mixunitname"+index+"' id='mixunitname"+index+"' value='"+retObj[index].unit_name+"' style='line-height:18px;width:98%' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='mixnum"+index+"' id='mixnum"+index+"' value='"+retObj[index].mix_num+"' style='line-height:18px;width:98%' type='text' /></td>";
					innerhtml += "<td width='10%'><input name='mixdevremark"+index+"' id='mixdevremark"+index+"' value='"+retObj[index].mixdevmark+"' style='line-height:18px;width:98%' type='text' readonly/></td>";					
					innerhtml += "<td width='10%'><input name='mixoutednum"+index+"' id='mixoutednum"+index+"' value='"+retObj[index].outednum+"' style='line-height:18px;width:98%' type='text' readonly/>";
					innerhtml += "<input name='planstartdate"+index+"' id='planstartdate"+index+"' value='"+planstartdate+"' type='hidden' />";
					innerhtml += "<input name='planenddate"+index+"' id='planenddate"+index+"' value='"+planenddate+"' type='hidden' /></td>";
					innerhtml += "<td width='10%'><input name='mixoutnum"+index+"' id='mixoutnum"+index+"' value='' style='line-height:18px;width:98%' type='text' detindex='"+index+"' onkeyup='checkAssignAddNum(this)'></td>";
					innerhtml += "<td width='10%'><input name='mixoutdevremark"+index+"' id='mixoutdevremark"+index+"' value='' style='line-height:18px;width:98%' type='text' /></td>";					
					innerhtml += "</tr>";
					$("#mixprocesstable").append(innerhtml);		
				}
				$("#mixprocesstable>tr:odd>td:odd").addClass("odd_odd");
				$("#mixprocesstable>tr:odd>td:even").addClass("odd_even");
				$("#mixprocesstable>tr:even>td:odd").addClass("even_odd");
				$("#mixprocesstable>tr:even>td:even").addClass("even_even");
			}
		}
	}
	function checkaddedNum(obj){
		var index = obj.detindex;
		if(obj.value == ''){
			return;
		}
		var objValue = obj.value;
		var re = /^\+?[1-9][0-9]*$/;
		if(objValue=="")
			return;
		if(!re.test(objValue)){
			alert("出库数量必须为数字!");
			obj.value = "";
        	return false;
		}
	}
	function checkAssignAddNum(obj){
		var index = obj.detindex;
		var mixnumVal = parseInt($("#addmixnum"+index).val(),10)
		var outednumVal = parseInt($("#addmixoutednum"+index).val(),10);
		if(obj.value == ''){
			return;
		}
		var objValue = obj.value;
		var re = /^\+?[1-9][0-9]*$/;
		if(objValue=="")
			return;
		if(!re.test(objValue)){
			alert("出库数量必须为数字!");
			obj.value = "";
        	return false;
		}else{
			if(parseInt(objValue,10)>mixnumVal){
				alert("出库数量必须小于等于调配数量!");
				obj.value = "";
				return false;
			}else if((parseInt(objValue,10)+outednumVal)>mixnumVal){
				alert("出库数量必须小于等于未出库数量!");
				obj.value = "";
				return false;
			}
		}
	}
	function checkAssignNum(obj){
		var index = obj.detindex;
		var mixnumVal = parseInt($("#mixnum"+index).val(),10)
		var unusenumVal = parseInt($("#unusenum"+index).val(),10);
		var outednumVal = parseInt($("#outednum"+index).val(),10);
		if(obj.value == ''){
			return;
		}
		var objValue = obj.value;
		var re = /^\+?[1-9][0-9]*$/;
		if(objValue=="")
			return;
		if(!re.test(objValue)){
			alert("出库数量必须为数字!");
			obj.value = "";
        	return false;
		}else{
			if($("#unusenum"+index).val() == ''){
				alert("没有对应台账信息或者闲置数量为空!");
				obj.value = "";
				return;
			}
			if(parseInt(objValue,10)>unusenumVal){
				alert("出库数量必须小于等于库存数量!");
				obj.value = "";
				return false;
			}else if(parseInt(objValue,10)>mixnumVal){
				alert("出库数量必须小于等于调配数量!");
				obj.value = "";
				return false;
			}else if((parseInt(objValue,10)+outednumVal)>mixnumVal){
				alert("出库数量必须小于等于未出库数量!");
				obj.value = "";
				return false;
			}else if(parseInt(objValue,10)>unusenumVal){
				alert("出库数量必须小于等于闲置数量!");
				obj.value = "";
				return false;
			}
		}
	}
	//补充调配对应的出库，填写信息
	var mixAddedNum=0;
	function toMixMixedDetailInfos(){
		var valuesize = 0;
		$("input[type='checkbox'][name='mixdetinfo']").each(function(i){
			if(this.checked == true){
				valuesize = valuesize+1;
			}
		});
		if(valuesize == 0)
		return;
		//先给非补充出库添加的清空，然后再插进来，放在补充出库的前面 
		$("#addeddetailtable>tr[name^='mixdettr']").remove();
		var addedinnerhtml = $("#addeddetailtable").html();
		$("#addeddetailtable").empty();
		//补充调配信息
		var outNotmixedflag = false;
		//获得选择的调配类别信息
		$("input[type='checkbox'][name='mixdetinfo']").each(function(i){
			if(this.checked == true){
				var indexinfo = this.id;
				var outnuminfo = $("#mixoutnum"+indexinfo).val();
				if(outnuminfo==""){
					outNotmixedflag = true;
				}
			}
		});
		if(outNotmixedflag){
			alert("请填写已选择数量明细的补充出库数量信息!");
			return;
		}
		var mixseqinfo = 0;
		//数量都添了，没有问题，继续填报信息
		//$("input[type='checkbox'][name='mixdetinfo']").each(function(i){
		$("input[type='checkbox'][name='mixdetinfo']").each(function(i){
			if(this.checked == true){
				var indexinfo = this.id;
				var valueinfo = this.value;
				var devicename = $("#mixdevicename"+indexinfo).val();
				var devicemodel = $("#mixdevicemodel"+indexinfo).val();
				var outnum = $("#mixoutnum"+indexinfo).val();
				var startdate = $("#planstartdate"+indexinfo).val();				
				if(startdate == "undefined"){
					startdate= '';
				}
				var enddate = $("#planenddate"+indexinfo).val();
				if(enddate == "undefined"){
					enddate= '';
				}
				//需要回头给unitid也放进来 var unitid = $("#mixunitid"+indexinfo).val();
				var unitname = $("#mixunitname"+indexinfo).val();
				//累加调配数量
				mixAddedNum += parseInt(outnum);
				for(var j = 0;j<parseInt(outnum);j++){
					mixseqinfo++;
					var innerhtml = "<tr id='mixdettr"+mixseqinfo+"' name='mixdettr"+mixseqinfo+"' seq='"+mixseqinfo+"' is_added='false'>";
					innerhtml += "<td width='4%'><input type='checkbox' name='mixdetseq' id='"+mixseqinfo+"' trinfo ="+mixseqinfo+" disabled/></td>";
					innerhtml += "<td width='12%'><input name='mixdetdevicename"+mixseqinfo+"' id='mixdetdevicename"+mixseqinfo+"' value='"+devicename+"' style='line-height:18px;width:98%' type='text' readonly/></td>";
					innerhtml += "<td width='12%'><input name='mixdetdevicetype"+mixseqinfo+"' id='mixdetdevicetype"+mixseqinfo+"' value='"+devicemodel+"' style='line-height:18px;' size='10' type='text' readonly/><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick=showMixDevPage("+mixseqinfo+") /></td>";
					innerhtml += "<td width='10%'><input name='mixdetdev_acc_id"+mixseqinfo+"' id='mixdetdev_acc_id"+mixseqinfo+"' seq='"+mixseqinfo+"' type='hidden'/>";
					innerhtml += "<input name='mixdetdevcicode"+mixseqinfo+"' id='mixdetdevcicode"+mixseqinfo+"' value='' type='hidden'/>";
					innerhtml += "<input name='mixdetself_num"+mixseqinfo+"' id='mixdetself_num"+mixseqinfo+"' style='line-height:18px;width:98%' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='mixdetlicense_num"+mixseqinfo+"' id='mixdetlicense_num"+mixseqinfo+"' value='' style='line-height:18px;width:98%' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='mixdetdev_sign"+mixseqinfo+"' id='mixdetdev_sign"+mixseqinfo+"' style='line-height:18px;width:98%' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='mixdetasset_coding"+mixseqinfo+"' id='mixdetasset_coding"+mixseqinfo+"' style='line-height:18px;width:98%' value='' readonly/></td>";
					innerhtml += "<td width='11%'><input name='mixdetplanstartdate"+mixseqinfo+"' id='mixdetplanstartdate"+mixseqinfo+"' style='line-height:15px' value='"+startdate+"' size='9' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+mixseqinfo+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(mixdetplanstartdate"+mixseqinfo+",tributton2"+mixseqinfo+");'/></td>";
					innerhtml += "<td width='11%'><input name='mixdetplanenddate"+mixseqinfo+"' id='mixdetplanenddate"+mixseqinfo+"' style='line-height:15px' value='"+enddate+"' size='9' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+mixseqinfo+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(mixdetplanenddate"+mixseqinfo+",tributton3"+mixseqinfo+");'/></td>";
					innerhtml += "<td width='10%'><input name='mixdetremark"+mixseqinfo+"' id='mixdetremark"+mixseqinfo+"' value='' size='10' type='text' /></td>";
					innerhtml += "</tr>";
					$("#addeddetailtable").append(innerhtml);
				}
			}
		});
		if(addedinnerhtml!=null&&addedinnerhtml!=""){
			$("#addeddetailtable").append(addedinnerhtml);
		}
		$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
		$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
		$("#addeddetailtable>tr:even>td:even").addClass("even_even");
		
		$("#mixtab_box").show();
		$("input[type='text'][id^='mixoutnum']").each(function(i){
			$(this).attr("readonly","readonly");
		});
		sc();
	}
	var addedseqinfo = 0;
	function toAddAddedDetailInfo(){
		var startdate = $("#planstartdate").val();
		var enddate = $("#planenddate").val();
		addedseqinfo++;
		var innerhtml = "<tr id='tr"+addedseqinfo+"' name='tr"+addedseqinfo+"' seq='"+addedseqinfo+"' is_added='false'>";
		innerhtml += "<td width='4%'><input type='checkbox' name='addedseq' id='"+addedseqinfo+"' trinfo ="+addedseqinfo+" /></td>";
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
		$("#mixtab_box").show();
		sc();
	}
	function toDelAddedDetailInfo(){
		$("input[name='addedseq'][type='checkbox']").each(function(i){
			if(this.checked){
				var index = this.id;//.substr(8);
				
				$("#tr"+index,"#addeddetailtable").remove();
			}
		});
		if($("tr","#addeddetailtable").size()==0){
			$("#mixtab_box").hide();
		}
		$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
		$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
		$("#addeddetailtable>tr:even>td:even").addClass("even_even");
	}
	function toModifyMixedDetailInfos(){
		$("#addeddetailtable>tr[name^='mixdettr']").remove();
		var addedinnerhtml = $("#addeddetailtable").html();
		if(addedinnerhtml == null || addedinnerhtml == ""){
			$("#mixtab_box").hide();
		}
		$("input[type='text'][name^='addmixoutnum']").each(function(i){
			$(this).removeAttr("readonly");
		});
	}
	function toAddMixInfos(str){
		var valuesize = 0;
		var mixNotmixedflag = false;
		$("input[type='checkbox'][name='mixdetinfo']").each(function(){
			if(this.checked){
				var indexinfo = this.id;
				var mixnuminfo = $("#mixoutnum"+indexinfo).val();
				if(mixnuminfo==""){
					mixNotmixedflag = true;
				}
				valuesize = valuesize+1;
			}
		});
		if(valuesize == 0){
			alert("请填写“填报台账明细”!");
			return;
		}

		if(mixNotmixedflag){
			alert("请填写“填报台账明细”!");
			return;
		}
		var obj = new Object();
		var pageselectedstr = null;
		var checkstr = 0;
		$("input[name^='mixdetdev_acc_id'][type='hidden']").each(function(i){
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
		
		//加上转出单位
		var out_sub_id = $("#out_sub_id").val();
		var dialogurl = "<%=contextPath%>/rm/dm/tree/selectAllAccountForMix.jsp?out_org_id="+out_sub_id+"&added=Y";
		var vReturnValue = window.showModalDialog(dialogurl, obj ,"dialogWidth=950px;dialogHeight=480px");
		if(vReturnValue!=undefined){
			//返回信息是 队级台账id
			var returnMidvalues = vReturnValue.split('@');
			if(parseInt(mixAddedNum)<(parseInt(checkstr)+returnMidvalues.length-1)){
				alert("筛选数量不能多于调配数量");
				return;
			}else{
				for(var i=parseInt(checkstr);i<(parseInt(checkstr)+returnMidvalues.length-1);i++){
					var trid =i+1;
					var returnvalues = returnMidvalues[i-parseInt(checkstr)].split('~');
					//返回信息是 队级台账id + 设备编码 + 设备名称 + 规格型号 + 自编号 + 实物标识号 + 牌照号
					$("input[name='mixdetdev_acc_id"+trid+"']","#addeddetailtable").val(returnvalues[0]);
					$("input[name='mixdetasset_coding"+trid+"']","#addeddetailtable").val(returnvalues[1]);
					$("input[name='mixdetdevicename"+trid+"']","#addeddetailtable").val(returnvalues[2]);
					$("input[name='mixdetdevicetype"+trid+"']","#addeddetailtable").val(returnvalues[3]);
					$("input[name='mixdetself_num"+trid+"']","#addeddetailtable").val(returnvalues[4]);
					$("input[name='mixdetdev_sign"+trid+"']","#addeddetailtable").val(returnvalues[5]);
					$("input[name='mixdetlicense_num"+trid+"']","#addeddetailtable").val(returnvalues[6]);
					$("input[name='mixdetdevcicode"+trid+"']","#addeddetailtable").val(returnvalues[7]);
				}
			}
		}   
	}
	function showMixDevPage(trid){
		var obj = new Object();
		var pageselectedstr = null;
		var checkstr = 0;
		$("input[name^='mixdetdev_acc_id'][type='hidden']").each(function(i){
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
		var out_sub_id = $("#out_sub_id").val();
		var forwordurl =  "<%=contextPath%>/rm/dm/tree/selectAccountForMix.jsp?out_org_id="+out_sub_id;
		var vReturnValue = window.showModalDialog(forwordurl , obj ,"dialogWidth=950px;dialogHeight=480px");
		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split('~');
			//返回信息是 队级台账id + 设备编码 + 设备名称 + 规格型号 + 自编号 + 实物标识号 + 牌照号
			$("input[name='mixdetdev_acc_id"+trid+"']","#addeddetailtable").val(returnvalues[0]);
			$("input[name='mixdetasset_coding"+trid+"']","#addeddetailtable").val(returnvalues[1]);
			$("input[name='mixdetdevicename"+trid+"']","#addeddetailtable").val(returnvalues[2]);
			$("input[name='mixdetdevicetype"+trid+"']","#addeddetailtable").val(returnvalues[3]);
			$("input[name='mixdetself_num"+trid+"']","#addeddetailtable").val(returnvalues[4]);
			$("input[name='mixdetdev_sign"+trid+"']","#addeddetailtable").val(returnvalues[5]);
			$("input[name='mixdetlicense_num"+trid+"']","#addeddetailtable").val(returnvalues[6]);
			$("input[name='mixdetdevcicode"+trid+"']","#addeddetailtable").val(returnvalues[7]);
		}
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

		//加上转出单位
		var out_sub_id = $("#out_sub_id").val();
		var dialogurl =  "<%=contextPath%>/rm/dm/tree/selectAccountForMix.jsp?out_org_id="+out_sub_id+"&added=Y";
		var vReturnValue = window.showModalDialog(dialogurl, obj ,"dialogWidth=950px;dialogHeight=480px;scroll:yes");
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
	function sc(){
		var e = document.getElementById("new_table_box_bg");
		e.scrollTop = e.scrollHeight;
	}
</script>
</html>