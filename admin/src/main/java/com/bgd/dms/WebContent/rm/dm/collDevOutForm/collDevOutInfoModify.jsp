<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String mixInfoId = request.getParameter("mixInfoId");
	String outInfoId = request.getParameter("outInfoId");
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
<title>出库单修改界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend >基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >出库单号:</td>
          <td class="inquire_form4" >
          	<input name="outinfo_no" id="outinfo_no" class="input_width" type="text"  value="" readonly/>
          </td>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text"  value="" readonly/>
          	<input name="project_info_no" id="project_info_no" class="input_width" type="hidden"  value="" readonly/>
          	<input name="devicemixinfoid" id="devicemixinfoid" type="hidden" value="<%=mixInfoId%>" />
          	<input name="deviceoutinfoid" id="deviceoutinfoid" type="hidden" value="<%=outInfoId%>" />
          	<input name="devouttype" id="devouttype" type="hidden" value="1" />
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
          </td>
          <td class="inquire_item4" >转出单位:</td>
          <td class="inquire_form4" >
          	<input name="out_org_name" id="out_org_name" class="input_width" type="text"  value="" readonly/>
          	<input name="out_org_id" id="out_org_id" class="input_width" type="hidden"  value="" />
          </td>
        </tr>
      </table>
      </fieldset>
	  <fieldset style="margin-left:2px"><legend>出库明细</legend>
		  <div style="height:220px;overflow:auto">
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
				<div style="height:190px;overflow:auto;">
					<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style='table-layout: auto'>
			   		<tbody id="processtable" name="processtable" >
			   		</tbody>
		      		</table>
		      	</div>
	       </div>
      </fieldset>
      <fieldset style="margin-left:2px"><legend>出库明细</legend>
		  <table style="width:98%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	        <tr>
	          <td width="5%"><span class="zj"><a href="#" id="addaddedbtn" onclick='toAddAddedDetailInfos()' title="添加"></a></span></td>
	          <td width="5%"><span class="sc"><a href="#" id="deladdedbtn" onclick='toDelAddedDetailInfos()' title="删除"></a></span></td>
	          <td width="90%"></td>
	        </tr>
	      </table>
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
			   	<tbody id="addeddetailtable" name="addeddetailtable" >
			   	</tbody>
		      	</table>
		      	</div>
	       </div>
      </fieldset>
    </div>
    <div id="oper_div">
    	<span class="tj_btn"><a href="#" onclick="submitInfo(9)"></a></span>
     	<span class="bc_btn"><a href="#" onclick="submitInfo(0)"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript"> 
	function submitInfo(state){
		//TODO 修改保存工作信息
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
		if(count == 0){
			alert('请选择出库单明细信息！');
			return;
		}
		var selectedlines = line_infos.split("~");
		var wronglineinfos = "";
		for(var index=0;index<selectedlines.length;index++){
			var valueinfo = $("#applynum"+selectedlines[index]).val();
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
		//给补充明细进行校验，如果有选中的补充明细，那么对应的出库数量必须不为空
		var mixcount = 0;
		var mixline_infos = "";
		var mixidinfos = "";
		var mixwrongflag = true;
		$("input[type='checkbox'][name='adddetinfo']").each(function(){
			var mixid = this.value;
			if(this.checked == true){
				if($("#addmixoutnum"+mixid).val()==""){
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
		if(!mixwrongflag){
			alert("请设置您选择的调配补充明细的出库数量!");
			return;
		}
		//如果有额外添加的明细，那么不能为空
		var addedcount = 0;
		var addedline_infos = "";
		var addedwrongflag = true;
		$("input[type='checkbox'][name='addedoutseq']").each(function(){
			var mixid = this.trinfo;
			if($("#addedoutassignnum"+mixid).val()==""){
				addedwrongflag = false;
			}else{
				if(addedcount == 0){
					addedline_infos = this.id;
				}else{
					addedline_infos += "~"+this.id;
				}
				addedcount++;
			}
		});
		if(!addedwrongflag){
			alert("请设置您添加的补充明细的出库数量!");
			return;
		}
		//给参数拼上
		var submiturl = "<%=contextPath%>/rm/dm/toModifyOutFormDetailInfo.srq?state="+state;
		submiturl += "&count="+count+"&line_infos="+line_infos+"&idinfos="+idinfos;
		submiturl += "&mixcount="+mixcount+"&mixline_infos="+mixline_infos+"&mixidinfos="+mixidinfos;
		submiturl += "&addedcount="+addedcount+"&addedline_infos="+addedline_infos;
		document.getElementById("form1").action = submiturl;
		document.getElementById("form1").submit();
	}
	function refreshData(){
		var retObj;
		var basedatas;
		if('<%=mixInfoId%>'!=null){
			//回填基本信息
			var mainsql = "select cmf.mixinfo_no,cmf.project_info_no,cmf.in_org_id,cmf.out_org_id,cmf.device_mixinfo_id,cmf.modifi_date as mix_date,";
			mainsql += "tp.project_name,inorg.org_abbreviation as in_org_name,outorg.org_abbreviation as out_org_name,cof.outinfo_no ";
			mainsql += "from gms_device_collmix_form cmf ";
			mainsql += "left join gms_device_coll_outform cof on cmf.device_mixinfo_id=cof.device_mixinfo_id ";
			mainsql += "left join gp_task_project tp on cmf.project_info_no=tp.project_info_no ";
			mainsql += "left join comm_org_information inorg on cmf.in_org_id=inorg.org_id ";
			mainsql += "left join comm_org_information outorg on cmf.out_org_id=outorg.org_id ";
			mainsql += "where cmf.device_mixinfo_id='<%=mixInfoId%>' and cof.device_outinfo_id='<%=outInfoId%>'";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+mainsql);
			retObj = proqueryRet.datas;
			if(retObj!=undefined && retObj.length>0){
				$("#outinfo_no").val(retObj[0].outinfo_no);
				$("#project_name").val(retObj[0].project_name);
				$("#project_info_no").val(retObj[0].project_info_no);
				$("#mixinfo_no").val(retObj[0].mixinfo_no);
				$("#mix_date").val(retObj[0].mix_date);
				$("#in_org_name").val(retObj[0].in_org_name);
				$("#out_org_name").val(retObj[0].out_org_name);
			}
			//回填明细信息
			var prosql = "select cms.device_mif_subid,cms.device_id,cms.device_name,cms.device_model,cms.mix_num,outsub.device_mif_subid as checksubid,cms.team,cms.devremark as mixdevremark,";
				prosql += "temp.outednum,account.unuse_num,account.dev_acc_id,cms.unit_id,unitsd.coding_name as unit_name,outsub.out_num,outsub.device_oif_subid,outsub.devremark ";
				prosql += "from gms_device_coll_mixsub cms ";
				prosql += "left join (select device_mif_subid,sum(out_num) as outednum from gms_device_coll_outsub group by device_mif_subid) temp on temp.device_mif_subid=cms.device_mif_subid ";
				prosql += "left join gms_device_collmix_form cmf on cms.device_mixinfo_id = cmf.device_mixinfo_id ";
				prosql += "left join gms_device_coll_account account on cms.device_id=account.device_id and cmf.out_org_id = account.usage_org_id ";
				prosql += "left join comm_coding_sort_detail unitsd on unitsd.coding_code_id=cms.unit_id ";
				prosql += "left join gms_device_coll_outsub outsub on outsub.device_mif_subid=cms.device_mif_subid ";
				prosql += "where (account.bsflag is null or account.bsflag='0') and cms.device_mixinfo_id='<%=mixInfoId%>' and outsub.device_outinfo_id='<%=outInfoId%>' ";
				prosql += "order by cms.device_id ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
			retObj = proqueryRet.datas;
			if(retObj!=undefined){
				for(var index=0;index<retObj.length;index++){
					var checkOutedNum = parseInt(retObj[index].outednum,10)-parseInt(retObj[index].out_num,10);
					//动态新增表格
					var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
					innerhtml += "<td width='4%'><input type='checkbox' name='detinfo' id='"+index+"' value='"+retObj[index].device_mif_subid+"' ";
					if(retObj[index].checksubid == retObj[index].device_mif_subid){
						innerhtml += " oifid='"+retObj[index].device_oif_subid+"' checked ";
					}
					innerhtml += "/></td>";
					innerhtml += "<td width='13%'><input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='"+retObj[index].device_name+"' size='12' type='text' readonly/>";
					innerhtml += "<input name='team"+index+"' id='team"+index+"' style='line-height:15px' value='"+retObj[index].team+"' type='hidden' />";
					innerhtml += "<input name='deviceid"+index+"' id='deviceid"+index+"' style='line-height:15px' value='"+retObj[index].device_id+"' type='hidden' /></td>";
					innerhtml += "<td width='13%'><input name='devicemodel"+index+"' id='devicemodel"+index+"' value='"+retObj[index].device_model+"' size='12' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='unitname"+index+"' id='unitname"+index+"' size='10' value='"+retObj[index].unit_name+"' type='text' readonly/>";
					innerhtml += "<input name='unitid"+index+"' id='unitid"+index+"' value='"+retObj[index].unit_id+"' size='8' type='hidden' readonly/></td>";
					innerhtml += "<td width='10%'><input name='mixnum"+index+"' id='mixnum"+index+"' style='line-height:15px' value='"+retObj[index].mix_num+"' size='8' type='text' /></td>";
					innerhtml += "<td width='10%'><input name='mixdevremark"+index+"' id='mixdevremark"+index+"' value='"+retObj[index].mixdevremark+"' size='10' type='text' readonly/></td>";
					
					innerhtml += "<td width='10%'><input name='outednum"+index+"' id='outednum"+index+"' value='"+retObj[index].outednum+"' size='8' type='text' readonly/>";
					innerhtml += "<input name='checkoutnum"+index+"' id='checkoutnum"+index+"' value='"+checkOutedNum+"' size='8' type='hidden' /></td>";
					innerhtml += "<td width='10%'><input name='unusenum"+index+"' id='unusenum"+index+"' value='"+retObj[index].unuse_num+"' size='8' type='text' />";
					innerhtml += "<input name='devaccid"+index+"' id='devaccid"+index+"' value='"+retObj[index].dev_acc_id+"' type='hidden' /></td>";
					
					innerhtml += "<td width='10%'><input name='outnum"+index+"' id='outnum"+index+"' value='"+retObj[index].out_num+"' size='8' type='text' detindex='"+index+"' onkeyup='checkAssignNum(this)'></td>";
					innerhtml += "<td width='10%'><input name='devremark"+index+"' id='devremark"+index+"' value='"+retObj[index].devremark+"' size='10' type='text' readonly/></td>";
					
					innerhtml += "</tr>";
					$("#processtable").append(innerhtml);
				}
				$("#processtable>tr:odd>td:odd").addClass("odd_odd");
				$("#processtable>tr:odd>td:even").addClass("odd_even");
				$("#processtable>tr:even>td:odd").addClass("even_odd");
				$("#processtable>tr:even>td:even").addClass("even_even");
			}
			//回填补充出库明细信息
			var mixprosql = "select cms.device_mif_subid,cms.device_id,cms.device_name,cms.device_model,cms.mix_num,";
				mixprosql += "outsub.device_mif_subid as checksubid,cms.team,cms.devremark as mixdevremark,";
				mixprosql += "temp.outednum,cms.unit_name,outsub.out_num,outsub.device_oif_subid,outsub.devremark ";
				mixprosql += "from gms_device_coll_mixsubadd cms ";
				mixprosql += "left join (select device_mif_subid,sum(out_num) as outednum from gms_device_coll_outsubadd ";
				mixprosql += "group by device_mif_subid) temp on temp.device_mif_subid=cms.device_mif_subid ";
				mixprosql += "left join gms_device_collmix_form cmf on cms.device_mixinfo_id = cmf.device_mixinfo_id ";
				mixprosql += "left join gms_device_coll_outsubadd outsub on outsub.device_mif_subid=cms.device_mif_subid ";
				mixprosql += "where cms.device_mixinfo_id='<%=mixInfoId%>' and outsub.device_outinfo_id='<%=outInfoId%>' and outsub.device_mif_subid is not null ";
			var mixproqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+mixprosql);
			retObj = mixproqueryRet.datas;
			
			if(retObj!=undefined){
				for(var index=0;index<retObj.length;index++){
					//动态新增表格
					var innerhtml = "<tr id='mixdettr"+index+"' name='mixdettr"+index+"' seq='"+index+"'>";
					innerhtml += "<td width='4%'><input type='checkbox' name='adddetinfo' id='"+index+"' value='"+retObj[index].device_mif_subid+"' checked/></td>";
					innerhtml += "<td width='13%'><input name='addmixdevicename"+index+"' id='addmixdevicename"+index+"' style='line-height:18px;width:98%' value='"+retObj[index].device_name+"'  type='text' readonly/>";
					innerhtml += "<input name='addmixteam"+index+"' id='addmixteam"+index+"' value='"+retObj[index].team+"' type='hidden' /></td>";
					innerhtml += "<td width='13%'><input name='addmixdevicemodel"+index+"' id='addmixdevicemodel"+index+"' value='"+retObj[index].device_model+"' style='line-height:18px;width:98%' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='addmixunitname"+index+"' id='addmixunitname"+index+"' value='"+retObj[index].unit_name+"' style='line-height:18px;width:98%' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='addmixnum"+index+"' id='addmixnum"+index+"' style='line-height:15px' value='"+retObj[index].mix_num+"' style='line-height:18px;width:98%' type='text' /></td>";
					innerhtml += "<td width='10%'><input name='addmixdevremark"+index+"' id='addmixdevremark"+index+"' value='"+retObj[index].mixdevremark+"' style='line-height:18px;width:98%' type='text' readonly/></td>";
					
					innerhtml += "<td width='10%'><input name='addmixoutednum"+index+"' id='addmixoutednum"+index+"' value='"+retObj[index].outednum+"' style='line-height:18px;width:98%' type='text' readonly/>";
					var checknum = parseInt(retObj[index].outednum)-parseInt(retObj[index].out_num);
					innerhtml += "<input name='checkmixoutednum"+index+"' id='checkmixoutednum"+index+"' value='"+checknum+"' type='hidden'/></td>";
					innerhtml += "<td width='10%'><input name='addmixoutnum"+index+"' id='addmixoutnum"+index+"' value='"+retObj[index].out_num+"' style='line-height:18px;width:98%' type='text' detindex='"+index+"' onkeyup='checkAssignAddNum(this)'></td>";
					innerhtml += "<td width='10%'><input name='addmixoutdevremark"+index+"' id='addmixoutdevremark"+index+"' value='"+retObj[index].devremark+"' style='line-height:18px;width:98%' type='text' /></td>";
					innerhtml += "</tr>";
					$("#addeddetailtable").append(innerhtml);		
				}
				$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
				$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
				$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
				$("#addeddetailtable>tr:even>td:even").addClass("even_even");
			}
			
			//回填自己填的补充出库明细信息
			var addedprosql = "select outsub.device_oif_subid,outsub.device_name,outsub.device_model,outsub.team,";
				addedprosql += "outsub.unit_name,outsub.out_num,outsub.devremark  ";
				addedprosql += "from gms_device_coll_outsubadd outsub ";
				addedprosql += "where outsub.device_outinfo_id='<%=outInfoId%>' and outsub.device_mif_subid is null ";
			var addedproqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+addedprosql);
			retObj = addedproqueryRet.datas;
			
			if(retObj!=undefined){
				for(var index=0;index<retObj.length;index++){
					//动态新增表格
					var innerhtml = "<tr id='addedtr"+index+"' name='addedtr"+index+"' seq='"+index+"'>";
					innerhtml += "<td width='4%'><input type='checkbox' name='addedoutseq' id='"+index+"' style='background-color:#909090' /></td>";
					innerhtml += "<td width='13%'><input name='addedoutdevicename"+index+"' id='addedoutdevicename"+index+"' style='line-height:18px;width:98%' value='"+retObj[index].device_name+"'  type='text' />";
					innerhtml += "<input name='addedoutteam"+index+"' id='addedoutteam"+index+"' value='"+retObj[index].team+"' type='hidden' /></td>";
					innerhtml += "<td width='13%'><input name='addedoutdevicetype"+index+"' id='addedoutdevicetype"+index+"' value='"+retObj[index].device_model+"' style='line-height:18px;width:98%' type='text' /></td>";
					innerhtml += "<td width='10%'><input name='addedoutunit"+index+"' id='addedoutunit"+index+"' value='"+retObj[index].unit_name+"' style='line-height:18px;width:98%' type='text' /></td>";
					
					innerhtml += "<td width='10%'>&nbsp;</td>";
					innerhtml += "<td width='10%'>&nbsp;</td>";
					innerhtml += "<td width='10%'>&nbsp;</td>";
					
					innerhtml += "<td width='10%'><input name='addedoutassignnum"+addedseqinfo+"' id='addedoutassignnum"+addedseqinfo+"' value='"+retObj[index].out_num+"' style='line-height:18px;width:98%' type='text' size='8' onkeyup='checkaddedNum(this)'/></td>";
					innerhtml += "<td width='10%'><input name='addedoutremark"+addedseqinfo+"' id='addedoutremark"+addedseqinfo+"' value='"+retObj[index].devremark+"' style='line-height:18px;width:98%' size='10' type='text' /></td>";
					innerhtml += "</tr>";
					$("#addeddetailtable").append(innerhtml);
					addedseqinfo++;
				}
				$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
				$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
				$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
				$("#addeddetailtable>tr:even>td:even").addClass("even_even");
			}
		}
	}
	var addedseqinfo = 0;
	function toAddAddedDetailInfos(){
		//获得第一行的team信息
		var team = $("input[name^='team'][type='hidden']")[0].value;
		addedseqinfo++;
		var innerhtml = "<tr id='addedtr"+addedseqinfo+"' name='addedtr"+addedseqinfo+"' seq='"+addedseqinfo+"' is_added='false'>";
		innerhtml += "<td width='4%'><input type='checkbox' name='addedoutseq' id='"+addedseqinfo+"' style='background-color:#909090'/></td>";
		innerhtml += "<input name='addedoutteam"+addedseqinfo+"' id='addedoutteam"+addedseqinfo+"' value='"+team+"' type='hidden' /></td>";
		innerhtml += "<td width='12%'><input name='addedoutdevicename"+addedseqinfo+"' id='addedoutdevicename"+addedseqinfo+"' idindex='"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='10' type='text' /></td>";
		innerhtml += "<td width='12%'><input name='addedoutdevicetype"+addedseqinfo+"' id='addedoutdevicetype"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='10' type='text' /></td>";
		innerhtml += "<td width='10%'><input name='addedoutunit"+addedseqinfo+"' id='addedoutunit"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='8' type='text' /></td>";
		
		innerhtml += "<td width='10%'>&nbsp;</td>";
		innerhtml += "<td width='10%'>&nbsp;</td>";
		innerhtml += "<td width='10%'>&nbsp;</td>";
		
		innerhtml += "<td width='10%'><input name='addedoutassignnum"+addedseqinfo+"' id='addedoutassignnum"+addedseqinfo+"' style='line-height:18px;width:98%' type='text' size='8' onkeyup='checkaddedNum(this)'/></td>";
		innerhtml += "<td width='10%'><input name='addedoutremark"+addedseqinfo+"' id='addedoutremark"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='10' type='text' /></td>";
		innerhtml += "</tr>";
		$("#addeddetailtable").append(innerhtml);
		$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
		$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
		$("#addeddetailtable>tr:even>td:even").addClass("even_even");
	}
	function toDelAddedDetailInfos(){
		$("input[name='addedoutseq'][type='checkbox']").each(function(i){
			if(this.checked == true){
				var index = this.id;
				$("#addedtr"+index).remove();
			}
		});
		$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
		$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
		$("#addeddetailtable>tr:even>td:even").addClass("even_even");
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
		var outednumVal = parseInt($("#checkmixoutednum"+index).val(),10);
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
		var outednumVal = parseInt($("#checkoutnum"+index).val(),10);
		if(obj.value == ''){
			return;
		}
		var objValue = obj.value;
		var re = /^\+?[1-9][0-9]*$/;
		if(objValue=="")
			return;
		if(!re.test(objValue)){
			alert("申请数量必须为数字!");
			obj.value = "";
        	return false;
		}else{
			if($("#unusenum"+index).val() == ''){
				alert("没有对应台账信息或者闲置数量为空!");
				obj.value = "";
				return;
			}
			if(parseInt(objValue,10)>unusenumVal){
				alert("申请数量必须小于等于库存数量!");
				obj.value = "";
				return false;
			}else if((parseInt(objValue,10)+outednumVal)>mixnumVal){
				alert("申请数量必须小于等于未出库数量!");
				obj.value = "";
				return false;
			}
		}
	}
</script>
</html>

