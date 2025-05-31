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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<link id="artDialogSkin" href="<%=contextPath %>/js/artDialog/skins/blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath %>/js/artDialog/artDialog.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/artDialog/iframeTools.js"></script>
<title>出库单添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%;height: 510px;">
  <div id="new_table_box_content" style="width:100%;height: 520px;">
    <div id="new_table_box_bg" style="overflow-x:hidden;overflow-y:auto;width:97%;height: 480px;">
      <fieldset style="margin-left:2px;width:97%;" ><legend style="font-size: 13px;">基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text"  value="" readonly/>
          	<input name="project_info_no" id="project_info_no" class="input_width" type="hidden"  value="" />
          	<input name="devicemixinfoid" id="devicemixinfoid" type="hidden" value="<%=mixInfoId%>" />
          	<input name="mix_type_id" id="mix_type_id" type="hidden" value="" />
          	<input name="project_type" id="project_type" type="hidden" value="" />
          </td>
           <td class="inquire_item4" >调配单号:</td>
          <td class="inquire_form4" >
          	<input name="mixinfo_no" id="mixinfo_no" class="input_width" type="text"  value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >出库单号:</td>
          <td class="inquire_form4" >
          	<input name="outinfo_no" id="outinfo_no" class="input_width" type="text"  value="保存后自动生成..." readonly/>
          </td>
          <td class="inquire_item4" >调配时间:</td>
          <td class="inquire_form4" >
          	<input name="create_date" id="create_date" class="input_width" type="text"  value="" readonly/>
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
	  <fieldset style="margin-left:2px;width:97%;margin-top: 15px;background-color: #ccccff"><legend style="font-size: 13px;">出库数量</legend>
		  <div style="height:100px;overflow:auto">
			  <table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_even" width="5%">选择</td>
					<td class="bt_info_odd" width="15%">设备名称</td>
					<td class="bt_info_even" width="15%">规格型号</td>
					<td class="bt_info_odd" width="20%"><font color='red'>调配备注</font></td>
					<td class="bt_info_even" width="8%">计量单位</td>
					<td class="bt_info_odd" width="8%">调配数量</td>
					<td class="bt_info_even" width="8%">已出库数量</td>
					<td class="bt_info_odd" width="8%">出库数量</td>
				</tr>
			   </table>
				<div style="height:90px;overflow:auto;">
					<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style='table-layout: auto'>
				   	<tbody id="processtable" name="processtable" >
				   	</tbody>
			      	</table>
			     </div>
	       </div>
	       <fieldset style="margin-left:2px;width:97.9%"><legend>出库台账明细</legend>
	       <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				        <tr>
				          <td width="5%"><span class="jl"><a href="#" id="addbtn" onclick='toMixDetailInfos()' title="填报台账明细"></a></span></td>
				          <td width="5%"><span class="xg"><a href="#" id="modifybtn" onclick='toModifyMixInfos()' title="修改数量明细"></a></span></td>
				          <td width="5%"><span class="zj"><a href="#" id="addbtn" onclick='toAddMixInfos(0)' title="多选台帐明细"></a></span></td>
				          <td width="85%"></td>
				        </tr>
				    </table>
			<div id="tab_box" class="tab_box" style="height:120px;overflow:auto;display:none">
				<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			       <tr>
						<td class="bt_info_odd" width="12%">设备名称</td>
						<td class="bt_info_even" width="14%">规格型号</td>
						<td class="bt_info_odd" width="11%">自编号</td>
						<td class="bt_info_even" width="11%">实物标识号</td>
						<td class="bt_info_odd" width="10%">牌照号</td>
						<td class="bt_info_even" width="10%">AMIS资产编号</td>
						<td class="bt_info_odd" width="11%">计划进场时间</td>
						<td class="bt_info_even" width="11%">计划离场时间</td>
						<td class="bt_info_odd" width="10%">备注</td>
					</tr>
					</table>
					<div style="height:90px;overflow:auto;">
						<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style='table-layout: auto'>
				   	 		<tbody id="detailtable" name="detailtable"></tbody>
						</table>
					</div>
			</div>
		  </fieldset>
      </fieldset>
	  <fieldset style="margin-left:2px;margin-top: 15px;background-color: #66FFFF;"><legend style="font-size: 13px;">补充出库数量</legend>
		  <div style="height:90px;overflow:auto">
			  <table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_even" width="5%">选择</td>
					<td class="bt_info_odd" width="20%">设备名称</td>
					<td class="bt_info_even" width="15%">规格型号</td>
					<td class="bt_info_odd" width="10%">计量单位</td>
					<td class="bt_info_even" width="10%">调配数量</td>
					<td class="bt_info_odd" width="10%">已出库数量</td>
					<td class="bt_info_even" width="10%">出库数量</td>
				</tr>
			   </table>
				<div style="height:60px;overflow:auto;">
					<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style='table-layout: auto'>
				   		<tbody id="mixprocesstable" name="mixprocesstable" ></tbody>
			      	</table>
			     </div>
	       </div>
	       <fieldset style="margin-left:2px;width:97.9%"><legend>补充出库明细</legend>
	       <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				<tr>
				    <td width="5%"><span class="jl"><a href="#" id="mixaddbtn" onclick='toMixMixedDetailInfos()' title="填报补充明细"></a></span></td>
				    <td width="5%"><span class="xg"><a href="#" id="mixmodifybtn" onclick='toModifyMixedDetailInfos()' title="修改补充明细"></a></span></td>
				    <td width="5%" align="right"><span class="zj"><a href="#" id="addallbtn" onclick='toAddMixInfos(1)' title="多选台帐明细"></a></span></td>
				    <td width="75%"></td>
				    <td width="5%" align="right"><span class="zj"><a href="#" id="addaddedbtn" onclick='toAddAddedDetailInfos()' title="添加"></a></span></td>
	          		<td width="5%" align="right"><span class="sc"><a href="#" id="deladdedbtn" onclick='toDelAddedDetailInfos()' title="删除"></a></span></td>
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
			   	 		<tbody id="addeddetailtable" name="addeddetailtable"></tbody>
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
     	<!-- <span class="bc_btn"><a href="#" onclick="submitInfo(0)"></a></span> -->
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
		var outdate = $("#out_date").val();
		if(outdate == ""){
			alert("出库时间 不能为空!");
			return;
		}
		//1.首先明细的长度不能为0
		var detailsize = $("tr","#detailtable").size();
		var mixdetailsize = $("tr[name^='mixdettr']","#addeddetailtable").size();
		if(detailsize == 0 && mixdetailsize == 0){
			alert("出库明细和补充出库明细不能同为空!请添加出库台账明细或补充出库台账明细!");
			return;
		}
		//2.校验调配申请的选择的调配明细必须填写对应详细信息
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
			alert("请填写第"+notfillRowinfos+"行的出库台账明细!");
			return;
		}
		//3.校验补充调配的选择的出库明细必须填写对应的详细信息
		var mixfillAlldetailFlag = true;
		var mixnotfillRowinfos = "";
		var mixj = 0;
		$("input[type='hidden'][name^='mixdetdev_acc_id']","#addeddetailtable").each(function(i){
			if(this.value == ""){
				if(mixj==0){
					mixnotfillRowinfos = (mixj+1);
				}else{
					mixnotfillRowinfos += "、"+(mixj+1);
				}
				mixfillAlldetailFlag = false;
				mixj++;
			}
		})
		if(!mixfillAlldetailFlag){
			alert("请填写第"+notfillRowinfos+"行的补充出库台账明细!");
			return;
		}
		//3.2 补充出库，添加的不能不选择台账
		var addedfillAlldetailFlag = true;
		var addednotfillRowinfos = "";
		var addedj = 0;
		$("input[type='hidden'][name^='addeddev_acc_id']","#addeddetailtable").each(function(i){
			if(this.value == ""){
				if(i==0){
					addednotfillRowinfos = (i+1);
				}else{
					addednotfillRowinfos += "、"+(i+1);
				}
				addedfillAlldetailFlag = false;
				j++;
			}
		})
		if(!addedfillAlldetailFlag){
			alert("请填写第"+addednotfillRowinfos+"行的补充出库台账信息!");
			return;
		}
		//4.保留调配的行信息，通过2 4的校验不会出现，此操作为了拼出关键信息
		var line_infos;
		var idinfos ;
		var count = 0;
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
		//保留对应的台账明细信息
		var detailcount = $("input[type='hidden'][name^='dev_acc_id']","#detailtable").size();
		//5.保留的补充调配的行信息，通过3 5的校验不会出现，此操作为了拼出关键信息
		var mixline_infos;
		var mixidinfos;
		var mixcount=0;
		$("input[type='checkbox'][name='mixdetinfo']").each(function(){
			if(this.checked == true){
				if(mixcount == 0){
					mixline_infos = this.id;
					mixidinfos = this.value;
				}else{
					mixline_infos += "~"+this.id;
					mixidinfos += "~"+this.value;
				}
				mixcount = mixcount+1;
			}
		});
		//保留对应的台账明细信息
		var mixdetailsize = $("tr[name^='mixdettr']","#addeddetailtable").size();
		var mixdetailcount = $("input[type='hidden'][name^='mixdetdev_acc_id']","#addeddetailtable").size();
		//查找对应的addedlineinfo和count;
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
		//关键信息拼串传过去 
		//调配主表 count line_infos idinfos 调配子表 detailcount 
		//补充调配主表 mixcount mixline_infos mixidinfos 补充调配子表 mixdetailcount
		//额外出库表  addedcount addedline_info 
		var forwardurl = "<%=contextPath%>/rm/dm/toSaveEquOutFormDetailInfo.srq?state="+state;
			forwardurl += "&count="+count+"&line_infos="+line_infos+"&idinfos="+idinfos+"&detailcount="+detailcount;
			forwardurl += "&mixcount="+mixcount+"&mixline_infos="+mixline_infos+"&mixidinfos="+mixidinfos+"&mixdetailcount="+mixdetailcount;
			forwardurl += "&addedcount="+addedcount+"&addedline_info="+addedline_info;

		//给调配单号设置成空
		$("#outinfo_no").val("");
		document.getElementById("form1").action = forwardurl;

		if(state==9 && window.confirm("提交以后数据不可修改,是否提交?")){
			document.getElementById("form1").submit();
		}else if(state==0){
			document.getElementById("form1").submit();
		}
	}
	function toModifyMixInfos(){
		$("#detailtable").empty();
		$("#tab_box").hide();
		$("input[type='text'][name^='outnum']").each(function(i){
			$(this).removeAttr("readonly");
		});
	}
	var mixAllNum=0;
	function toMixDetailInfos(){
		var valuesize = 0;
		var outNotmixedflag = false;
		$("input[type='checkbox'][name='detinfo']").each(function(){
			if(this.checked){
				var indexinfo = this.id;
				var valueinfo = this.value;
				var outnuminfo = $("#outnum"+indexinfo).val();
				if(outnuminfo==""){
					outNotmixedflag = true;
				}
				valuesize = valuesize+1;
			}
		});
		if(valuesize == 0)
			return;
		if(outNotmixedflag){
			alert("请填写已选择数量明细的出库数量信息!");
			return;
		}
		//先清空表
		$("#detailtable").empty();
		var seqinfo = 0;
		//数量都添了，没有问题，继续填报信息
		$("input[type='checkbox'][name='detinfo']").each(function(i){
			if(this.checked){
				var indexinfo = this.id;
				var valueinfo = this.value;
				var devicename = $("#devicename"+indexinfo).val();
				var devicemodel = $("#devicemodel"+indexinfo).val();
				var devcicode = $("#devcicode"+indexinfo).val();
				var outnum = $("#outnum"+indexinfo).val();
				var startdate = $("#planstartdate"+indexinfo).val();
				var isdevicecode = $("#isdevicecode"+indexinfo).val();
				var enddate = $("#planenddate"+indexinfo).val();
				var unitid = $("#unitid"+indexinfo).val();
				var unitname = $("#unitname"+indexinfo).val();
				//累加调配数量
				mixAllNum += parseInt(outnum);
				for(var j = 0;j<parseInt(outnum);j++){
					seqinfo++;
					var innerhtml = "<tr id='tr"+seqinfo+"' name='tr"+seqinfo+"' seq='"+seqinfo+"' is_added='false'>";
					innerhtml += "<td width='12%'><input name='detdevicename"+seqinfo+"' id='detdevicename"+seqinfo+"' value='"+devicename+"' style='line-height:18px;width:98%' size='10' type='text' readonly/></td>";
					innerhtml += "<td width='14%'><input name='detdevicetype"+seqinfo+"' id='detdevicetype"+seqinfo+"' value='"+devicemodel+"' style='line-height:18px;' size='10' type='text' readonly/><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick=showDevPage("+seqinfo+",'"+devcicode+"','"+isdevicecode+"','"+devicename+"') /></td>";
					innerhtml += "<td width='11%'><input name='dev_acc_id"+seqinfo+"' id='dev_acc_id"+seqinfo+"' type='hidden'/>";
					innerhtml += "<input name='device_mix_subid"+seqinfo+"' id='device_mix_subid"+seqinfo+"' value='"+valueinfo+"' type='hidden'/>";
					innerhtml += "<input name='detdevcicode"+seqinfo+"' id='detdevcicode"+seqinfo+"' value='"+devcicode+"' type='hidden'/>";
					innerhtml += "<input name='self_num"+seqinfo+"' id='self_num"+seqinfo+"' style='line-height:18px;' size='10' type='text' readonly/></td>";
					innerhtml += "<td width='11%'><input name='dev_sign"+seqinfo+"' id='dev_sign"+seqinfo+"' style='line-height:18px;' type='text' size='10' readonly/></td>";
					innerhtml += "<td width='10%'><input name='license_num"+seqinfo+"' id='license_num"+seqinfo+"' value='' style='line-height:18px;' size='10' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='asset_coding"+seqinfo+"' id='asset_coding"+seqinfo+"' style='line-height:18px;width:98%' value='' readonly/></td>";
					innerhtml += "<td width='11%'><input name='devstartdate"+seqinfo+"' id='devstartdate"+seqinfo+"' style='line-height:18px;width:99%' size='15' value='"+startdate+"' type='text' readonly/></td>";
					innerhtml += "<td width='11%'><input name='devenddate"+seqinfo+"' id='devenddate"+seqinfo+"' style='line-height:18px;width:99%' size='15' value='"+enddate+"' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='devremark"+seqinfo+"' id='devremark"+seqinfo+"' value='' size='10' type='text' /></td>";
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
		$("input[type='text'][id^='outnum']").each(function(i){
			$(this).attr("readonly","readonly");
		});
	}
	var addedseqinfo = 0;
	function toAddAddedDetailInfos(){
		addedseqinfo++;
		var innerhtml = "<tr id='tr"+addedseqinfo+"' name='tr"+addedseqinfo+"' seq='"+addedseqinfo+"' is_added='false'>";
		innerhtml += "<td width='4%'><input type='checkbox' name='addedseq' id='addedseq"+addedseqinfo+"'/></td>";
		innerhtml += "<td width='12%'><input name='addeddevicename"+addedseqinfo+"' id='addeddevicename"+addedseqinfo+"' value='' style='line-height:18px;width:98%' type='text' readonly/></td>";
		innerhtml += "<td width='12%'><input name='addeddevicetype"+addedseqinfo+"' id='addeddevicetype"+addedseqinfo+"' value='' style='line-height:18px;' size='10' type='text' readonly/><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick=showAddedDevPage("+addedseqinfo+") /></td>";
		innerhtml += "<td width='10%'><input name='addeddev_acc_id"+addedseqinfo+"' id='addeddev_acc_id"+addedseqinfo+"' seq='"+addedseqinfo+"' type='hidden'/>";
		innerhtml += "<input name='addeddevcicode"+addedseqinfo+"' id='addeddevcicode"+addedseqinfo+"' value='' type='hidden'/>";
		innerhtml += "<input name='addedself_num"+addedseqinfo+"' id='addedself_num"+addedseqinfo+"' style='line-height:18px;width:98%' type='text' readonly/></td>";
		innerhtml += "<td width='10%'><input name='addedlicense_num"+addedseqinfo+"' id='addedlicense_num"+addedseqinfo+"' value='' style='line-height:18px;width:98%' type='text' readonly/></td>";
		innerhtml += "<td width='10%'><input name='addeddev_sign"+addedseqinfo+"' id='addeddev_sign"+addedseqinfo+"' style='line-height:18px;width:98%' type='text' readonly/></td>";
		innerhtml += "<td width='10%'><input name='addedasset_coding"+addedseqinfo+"' id='addedasset_coding"+addedseqinfo+"' style='line-height:18px;width:98%' value='' readonly/></td>";
		innerhtml += "<td width='11%'><input name='addedplanstartdate"+addedseqinfo+"' id='addedplanstartdate"+addedseqinfo+"' value='' style='line-height:18px;width:98%' type='text' readonly/>";
		innerhtml += "<td width='11%'><input name='addedplanenddate"+addedseqinfo+"' id='addedplanenddate"+addedseqinfo+"' value='' style='line-height:18px;width:98%' type='text' readonly/></td>";
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
	function toDelAddedDetailInfos(){
		$("input[name='addedseq'][type='checkbox']").each(function(i){
			if(this.checked){
				var index = this.id.substr(8);
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
				//累加调配数量
				mixAddedNum += parseInt(outnum);
				//需要回头给unitid也放进来 var unitid = $("#mixunitid"+indexinfo).val();
				var unitname = $("#mixunitname"+indexinfo).val();
				for(var j = 0;j<parseInt(outnum);j++){
					mixseqinfo++;
					var innerhtml = "<tr id='mixdettr"+mixseqinfo+"' name='mixdettr"+mixseqinfo+"' seq='"+mixseqinfo+"' is_added='false'>";
					innerhtml += "<td width='4%'><input type='checkbox' name='mixdetseq' id='"+mixseqinfo+"' trinfo ="+mixseqinfo+" disabled/></td>";
					innerhtml += "<td width='12%'><input name='mixdetdevicename"+mixseqinfo+"' id='mixdetdevicename"+mixseqinfo+"' value='"+devicename+"' style='line-height:18px;width:98%' size='10' type='text' readonly/></td>";
					innerhtml += "<td width='12%'><input name='mixdetdevicetype"+mixseqinfo+"' id='mixdetdevicetype"+mixseqinfo+"' value='"+devicemodel+"' style='line-height:18px;' size='10' type='text' readonly/><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick=showMixDevPage("+mixseqinfo+") /></td>";
					innerhtml += "<td width='10%'><input name='mixdetdevice_mix_subid"+mixseqinfo+"' id='mixdetdevice_mix_subid"+mixseqinfo+"' value='"+valueinfo+"' type='hidden'/>";
					innerhtml += "<input name='mixdetdev_acc_id"+mixseqinfo+"' id='mixdetdev_acc_id"+mixseqinfo+"' seq='"+mixseqinfo+"' value='' type='hidden'/>";
					innerhtml += "<input name='mixdetdevcicode"+mixseqinfo+"' id='mixdetdevcicode"+mixseqinfo+"' value='' type='hidden'/>";
					innerhtml += "<input name='mixdetself_num"+mixseqinfo+"' id='mixdetself_num"+mixseqinfo+"' style='line-height:18px;' size='10' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='mixdetdev_sign"+mixseqinfo+"' id='mixdetdev_sign"+mixseqinfo+"' style='line-height:18px;' type='text' size='10' readonly/></td>";
					innerhtml += "<td width='10%'><input name='mixdetlicense_num"+mixseqinfo+"' id='mixdetlicense_num"+mixseqinfo+"' value='' style='line-height:18px;' size='10' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='mixdetasset_coding"+mixseqinfo+"' id='mixdetasset_coding"+mixseqinfo+"' style='line-height:18px;width:98%' value='' readonly/></td>";
					innerhtml += "<td width='11%'><input name='mixdetdevstartdate"+mixseqinfo+"' id='mixdetdevstartdate"+mixseqinfo+"' style='line-height:18px;width:99%' size='15' value='"+startdate+"' type='text' readonly/></td>";
					innerhtml += "<td width='11%'><input name='mixdetdevenddate"+mixseqinfo+"' id='mixdetdevenddate"+mixseqinfo+"' style='line-height:18px;width:99%' size='15' value='"+enddate+"' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='mixdetdevremark"+mixseqinfo+"' id='mixdetdevremark"+mixseqinfo+"' value='' size='10' type='text' /></td>";
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
	function sc(){
		var e = document.getElementById("new_table_box_bg");
		e.scrollTop = e.scrollHeight;
	}
	function toModifyMixedDetailInfos(){
		$("#addeddetailtable>tr[name^='mixdettr']").remove();
		var addedinnerhtml = $("#addeddetailtable").html();
		if(addedinnerhtml == null || addedinnerhtml == ""){
			$("#mixtab_box").hide();
		}
		$("input[type='text'][name^='mixoutnum']").each(function(i){
			$(this).removeAttr("readonly");
		});
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
		var out_org_id = $("#out_org_id").val();
		var forwordurl =  "<%=contextPath%>/rm/dm/tree/selectAccountForMix.jsp?out_org_id="+out_org_id;
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
		//回头加上转出单位
		var out_org_id = $("#out_org_id").val();
		var dialogurl = "<%=contextPath%>/rm/dm/tree/selectAccountForMix.jsp?out_org_id="+out_org_id+"&added=Y";
		dialogurl = encodeURI(dialogurl);
		dialogurl = encodeURI(dialogurl);
		var vReturnValue = window.showModalDialog(dialogurl , obj ,"dialogWidth=950px;dialogHeight=480px");
		
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
	function showDevPage(trid){
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
			var returnvalues = vReturnValue.split('~');
			//返回信息是 队级台账id + 设备编码 + 设备名称 + 规格型号 + 自编号 + 实物标识号 + 牌照号
			$("input[name='dev_acc_id"+trid+"']","#detailtable").val(returnvalues[0]);
			$("input[name='asset_coding"+trid+"']","#detailtable").val(returnvalues[1]);
			$("input[name='detdevicename"+trid+"']","#detailtable").val(returnvalues[2]);
			$("input[name='detdevicetype"+trid+"']","#detailtable").val(returnvalues[3]);
			$("input[name='self_num"+trid+"']","#detailtable").val(returnvalues[4]);
			$("input[name='dev_sign"+trid+"']","#detailtable").val(returnvalues[5]);
			$("input[name='license_num"+trid+"']","#detailtable").val(returnvalues[6]);
			$("input[name='detdevcicode"+trid+"']","#detailtable").val(returnvalues[7]);
		}
	}
	function changeTitle(obj){
	 	obj.title=obj.value;
	}
	var planstartdate;
	var planenddate;
	function refreshData(){
		var retObj;
		var basedatas;
		if('<%=mixInfoId%>'!=null){
			//回填基本信息
			var mainsql = "select pro.project_type,mix.device_mixinfo_id,mix.mixinfo_no,pro.project_name,mix.create_date,mix.in_org_id,insub.org_subjection_id as in_sub_id,orgsub.org_subjection_id out_org_id,mix.project_info_no, "+
			"inorg.org_abbreviation as in_org_name,outorg.org_abbreviation as out_org_name,"+
			"he.employee_name,outform.device_outinfo_id,outform.outinfo_no,outform.receive_state,mix.mix_type_id "+
			"from gms_device_mixinfo_form mix "+
			"left join gp_task_project pro on mix.project_info_no=pro.project_info_no "+
			"left join comm_org_information inorg on mix.in_org_id=inorg.org_id and inorg.bsflag='0' "+
			"left join comm_org_subjection insub on mix.in_org_id = insub.org_id and insub.bsflag='0' "+
			"left join comm_org_subjection orgsub on mix.out_org_id = orgsub.org_id and orgsub.bsflag='0' "+
			"left join comm_org_information outorg on mix.out_org_id=outorg.org_id and outorg.bsflag='0' "+
			"left join comm_human_employee he on mix.mix_user_id=he.employee_id "+
			"left join gms_device_equ_outform outform on outform.device_mixinfo_id=mix.device_mixinfo_id ";
			mainsql += "where mix.device_mixinfo_id='<%=mixInfoId%>'";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+mainsql);
			retObj = proqueryRet.datas;
			if(retObj!=undefined && retObj.length>0){
				$("#project_name").val(retObj[0].project_name);
				$("#project_info_no").val(retObj[0].project_info_no);
				$("#mixinfo_no").val(retObj[0].mixinfo_no);
				$("#create_date").val(retObj[0].create_date);
				$("#in_org_name").val(retObj[0].in_org_name);
				$("#in_org_id").val(retObj[0].in_org_id);
				$("#in_sub_id").val(retObj[0].in_sub_id);
				$("#out_org_name").val(retObj[0].out_org_name);
				$("#out_org_id").val(retObj[0].out_org_id);
				$("#mix_type_id").val(retObj[0].mix_type_id);
				$("#project_type").val(retObj[0].project_type);
			}
			//回填明细信息
			var prosql = "select amm.device_mix_subid,amm.dev_ci_code,amm.assign_num,amm.isdevicecode,";
				prosql += "appdet.dev_name as dev_ci_name,appdet.dev_type as dev_ci_model,nvl(temp.outednum,0) outednum,";
				prosql += "unitsd.coding_name as unit_name,appdet.unitinfo,appdet.plan_start_date,appdet.plan_end_date,amm.devremark ";
				prosql += "from gms_device_appmix_main amm ";
				prosql += "left join (select device_mix_subid,dev_ci_code,sum(out_num) as outednum from gms_device_equ_outsub sub ";
				prosql += "left join gms_device_equ_outform frm on sub.device_outinfo_id=frm.device_outinfo_id where frm.bsflag='0' group by device_mix_subid,dev_ci_code) temp on temp.device_mix_subid=amm.device_mix_subid ";
				prosql += "left join gms_device_app_detail appdet on amm.device_app_detid=appdet.device_app_detid ";
				prosql += "left join comm_coding_sort_detail unitsd on unitsd.coding_code_id=appdet.unitinfo ";
				prosql += "where amm.bsflag='0' and amm.assign_num is not null and amm.device_mixinfo_id='<%=mixInfoId%>'";
				prosql += "order by amm.dev_ci_code ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
			retObj = proqueryRet.datas;
			if(retObj!=undefined){
				for(var index=0;index<retObj.length;index++){
					if(index==0){
						planstartdate = retObj[index].plan_start_date;
						planenddate = retObj[index].plan_end_date;
					}
					//动态新增表格
					var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
					innerhtml += "<td width='5%'><input type='checkbox' name='detinfo' id='"+index+"' value='"+retObj[index].device_mix_subid+"' checked/></td>";
					innerhtml += "<td width='15%'><input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='"+retObj[index].dev_ci_name+"' size='18' type='text' readonly/>";
					innerhtml += "<input name='devcicode"+index+"' id='devcicode"+index+"' style='line-height:15px' value='"+retObj[index].dev_ci_code+"' type='hidden' />";
					innerhtml += "<input name='isdevicecode"+index+"' id='isdevicecode"+index+"' style='line-height:15px' value='"+retObj[index].isdevicecode+"' type='hidden' /></td>";
					innerhtml += "<td width='15%'><input name='devicemodel"+index+"' id='devicemodel"+index+"' value='"+retObj[index].dev_ci_model+"' size='18' type='text' readonly/></td>";
					innerhtml += "<td width='20%' style='cursor:hand' onmouseout='dialogClose("+"\""+retObj[index].devremark+"\""+")' onmouseover='dialogValue("+"\""+retObj[index].devremark+"\""+")' ><input title='' name='devremark"+index+"' id='devremark"+index+"' value='"+retObj[index].devremark+"' size='28' type='text' readonly/></td>";
					innerhtml += "<td width='8%'><input name='unitname"+index+"' id='unitname"+index+"' value='"+retObj[index].unit_name+"' size='5' type='text' readonly/>";
					innerhtml += "<input name='unitid"+index+"' id='unitid"+index+"' value='"+retObj[index].unitinfo+"' type='hidden' />";
					innerhtml += "<input name='planstartdate"+index+"' id='planstartdate"+index+"' value='"+retObj[index].plan_start_date+"' type='hidden' />";
					innerhtml += "<input name='planenddate"+index+"' id='planenddate"+index+"' value='"+retObj[index].plan_end_date+"' type='hidden' /></td>";
					
					innerhtml += "<td width='8%'><input name='mixnum"+index+"' id='mixnum"+index+"' style='line-height:15px' value='"+retObj[index].assign_num+"' size='8' type='text' /></td>";
					innerhtml += "<td width='8%'><input name='outednum"+index+"' id='outednum"+index+"' value='"+retObj[index].outednum+"' size='8'  type='text' readonly/></td>";
					innerhtml += "<td width='8%'><input name='outnum"+index+"' id='outnum"+index+"' value='' size='8' type='text' detindex='"+index+"' onkeyup='checkAssignNum(this)'></td>";
					
					innerhtml += "</tr>";
					$("#processtable").append(innerhtml);
					$("#devremark"+index).mouseover(function(){changeTitle(this)});
				}
				$("#processtable>tr:odd>td:odd").addClass("odd_odd");
				$("#processtable>tr:odd>td:even").addClass("odd_even");
				$("#processtable>tr:even>td:odd").addClass("even_odd");
				$("#processtable>tr:even>td:even").addClass("even_even");
			}
			//回填补充明细信息
			var mixprosql = "select amm.device_mix_subid,amm.assign_num,amm.dev_name as dev_ci_name,amm.dev_model as dev_ci_model,";
				mixprosql += "nvl(temp.outednum,0) outednum,amm.dev_unit as unit_name ";
				mixprosql += "from gms_device_appmix_added amm ";
				mixprosql += "left join (select device_mix_subid,sum(out_num) as outednum from gms_device_equ_outsub_added added ";
				mixprosql += "left join gms_device_equ_outform frm on added.device_outinfo_id=frm.device_outinfo_id where frm.bsflag='0' ";
				mixprosql += "and added.device_mix_subid is not null group by device_mix_subid) temp on temp.device_mix_subid=amm.device_mix_subid ";
				mixprosql += "where amm.bsflag='0' and amm.device_mixinfo_id='<%=mixInfoId%>'";
				mixprosql += "order by amm.create_date ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+mixprosql);
			retObj = proqueryRet.datas;
			if(retObj!=undefined){
				for(var index=0;index<retObj.length;index++){
					//动态新增表格
					var innerhtml = "<tr id='mixtr"+index+"' name='mixtr"+index+"' seq='"+index+"'>";
					innerhtml += "<td width='5%'><input type='checkbox' name='mixdetinfo' id='"+index+"' value='"+retObj[index].device_mix_subid+"' checked/></td>";
					innerhtml += "<td width='20%'><input name='mixdevicename"+index+"' id='mixdevicename"+index+"' style='line-height:15px' value='"+retObj[index].dev_ci_name+"' size='20' type='text' readonly/></td>";
					innerhtml += "<td width='15%'><input name='mixdevicemodel"+index+"' id='mixdevicemodel"+index+"' value='"+retObj[index].dev_ci_model+"' size='20' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='mixunitname"+index+"' id='mixunitname"+index+"' value='"+retObj[index].unit_name+"' size='10' type='text' readonly/>";
					innerhtml += "<input name='planstartdate"+index+"' id='planstartdate"+index+"' value='"+planstartdate+"' type='hidden' />";
					innerhtml += "<input name='planenddate"+index+"' id='planenddate"+index+"' value='"+planenddate+"' type='hidden' /></td>";
					
					innerhtml += "<td width='10%'><input name='mixmixnum"+index+"' id='mixmixnum"+index+"' style='line-height:15px' value='"+retObj[index].assign_num+"' size='10' type='text' /></td>";
					innerhtml += "<td width='10%'><input name='mixoutednum"+index+"' id='mixoutednum"+index+"' value='"+retObj[index].outednum+"' size='10'  type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='mixoutnum"+index+"' id='mixoutnum"+index+"' value='' size='10' type='text' detindex='"+index+"' onkeyup='checkMixAssignNum(this)'></td>";
					
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
	function toAddMixInfos(str){
		var valuesize = 0;
		var mixNotmixedflag = false;
		if(str == '0'){
			$("input[type='checkbox'][name='detinfo']").each(function(){
				if(this.checked){
					var indexinfo = this.id;
					var mixnuminfo = $("#outnum"+indexinfo).val();
					if(mixnuminfo==""){
						mixNotmixedflag = true;
					}
					valuesize = valuesize+1;
				}
			});			
		}else{
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
		}
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
		if(str == '0'){
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
		}else{
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
		}
		if(pageselectedstr!=null){
			pageselectedstr = pageselectedstr + "'";
		}
		obj.pageselectedstr = pageselectedstr;
		
		//加上转出单位
		var out_org_id = $("#out_org_id").val();
		var dialogurl;
		if(str == '0'){
			dialogurl = "<%=contextPath%>/rm/dm/tree/selectAllAccountForMix.jsp?out_org_id="+out_org_id+"&added=N";
		}else{
			dialogurl = "<%=contextPath%>/rm/dm/tree/selectAllAccountForMix.jsp?out_org_id="+out_org_id+"&added=Y";
		}
		//var dialogurl = "<%=contextPath%>/rm/dm/tree/selectAllAccountForMix.jsp?out_org_id="+out_org_id+"&added=Y";
			dialogurl = encodeURI(dialogurl);
			dialogurl = encodeURI(dialogurl);
		var vReturnValue = window.showModalDialog(dialogurl , obj ,"dialogWidth=950px;dialogHeight=480px");
		if(vReturnValue!=undefined){
			//返回信息是 队级台账id
			var returnMidvalues = vReturnValue.split('@');
			if(str == '0'){
				if(parseInt(mixAllNum)<(parseInt(checkstr)+returnMidvalues.length-1)){
					alert("筛选数量不能多于调配数量");
					return;
				}else{
					for(var i=parseInt(checkstr);i<(parseInt(checkstr)+returnMidvalues.length-1);i++){
						    var trid =i+1;
							var returnvalues = returnMidvalues[i-parseInt(checkstr)].split('~');
							//返回信息是 队级台账id + 设备编码 + 设备名称 + 规格型号 + 自编号 + 实物标识号 + 牌照号
							$("input[name='dev_acc_id"+trid+"']","#detailtable").val(returnvalues[0]);
							$("input[name='asset_coding"+trid+"']","#detailtable").val(returnvalues[1]);
							$("input[name='detdevicename"+trid+"']","#detailtable").val(returnvalues[2]);
							$("input[name='detdevicetype"+trid+"']","#detailtable").val(returnvalues[3]);
							$("input[name='self_num"+trid+"']","#detailtable").val(returnvalues[4]);
							$("input[name='dev_sign"+trid+"']","#detailtable").val(returnvalues[5]);
							$("input[name='license_num"+trid+"']","#detailtable").val(returnvalues[6]);
							$("input[name='detdevcicode"+trid+"']","#detailtable").val(returnvalues[7]);
					}
				}
			}else{
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
	}
	function checkMixAssignNum(obj){
		var index = obj.detindex;
		var mixnumVal = parseInt($("#mixmixnum"+index).val(),10)
		var outednumVal = parseInt($("#mixoutednum"+index).val(),10);
		if(obj.value == ''){
			return;
		}
		var objValue = obj.value;
		var re = /^\+?[1-9][0-9]*$/;
		if(objValue=="")
			return;
		if(!re.test(objValue)){
			alert("补充出库数量必须为数字!");
			obj.value = "";
        	return false;
		}else{
			if(parseInt(objValue,10)>mixnumVal){
				alert("补充出库数量必须小于等于调配数量!");
				obj.value = "";
				return false;
			}else if((parseInt(objValue,10)+outednumVal)>mixnumVal){
				alert("补充出库数量必须小于等于未出库数量!");
				obj.value = "";
				return false;
			}
		}
	}
	function checkAssignNum(obj){
		var index = obj.detindex;
		var mixnumVal = parseInt($("#mixnum"+index).val(),10)
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
</script>
</html>

