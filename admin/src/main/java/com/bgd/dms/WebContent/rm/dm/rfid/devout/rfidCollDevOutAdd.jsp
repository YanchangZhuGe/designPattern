<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String mixInfoId = request.getParameter("mixInfoId");
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
<title>出库单添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldSet style="margin-left:2px"><legend >基本信息</legend>
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
      </fieldSet>
	  <fieldSet style="margin-left:2px"><legend>出库明细</legend>
		  <div style="overflow:auto">
			  <table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_even" width="4%"><input type='checkbox' id='devbackinfo' name='devbackinfo'/></td>
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
      </fieldSet>
      <fieldSet style="margin-left:2px"><legend>补充明细</legend>
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
					<td class="bt_info_even" width="4%"><input type='checkbox' id='devbackinfo2' name='devbackinfo2'/></td>
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
		      	<div style="height:60px;overflow:auto;">
					<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style='table-layout: auto'>
				   	<tbody id="mixprocesstable" name="mixprocesstable" >
				   	</tbody>
			      	</table>
			     </div>
		      	</div>
	       </div>
	       </fieldSet>
	        <fieldSet style="margin-left:2px;width:97.9%"><legend>补充出库明细</legend>
	        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		        <tr>
		          <td width="5%"><span class="jl"><a href="#" id="mixaddbtn" onclick='toMixMixedDetailInfos()' title="填报补充明细"></a></span></td>
		          <td width="5%"><span class="zj"><a href="#" id="addaddedbtn" onclick='toAddAddedDetailInfo()' title="添加"></a></span></td>
         			  <td width="5%"><span class="sc"><a href="#" id="deladdedbtn" onclick='toDelAddedDetailInfo()' title="删除"></a></span></td>
		          <td width="90%"></td>
		        </tr>
		    </table>
			<div id="mixtab_box" class="tab_box" style="height:120px;overflow:auto;display:none">
				<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			       <tr>
						<td class="bt_info_even" width="4%"><input type='checkbox' id='devbackinfo3' name='devbackinfo3'/></td>
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
			   	 	<tbody id="devdetailtable" name="devdetailtable">
			    	</tbody>
					</table>
				</div>
			</div>
		  </fieldSet>
    </div>
    <div id="oper_div">
     	<!-- <span class="tj_btn"><a href="#" onclick="submitInfo(9)"></a></span> -->
     	<span class="bc_btn"><a href="#" onclick="submitInfo(0)"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript"> 
	function submitInfo(state){
		//给信息保存到数据库中，重写入库操作
		
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
		
		/* var selectedlines = line_infos.split("~");
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
		} */
		
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
				if(mixcount == 0){
					mixline_infos = this.id;
					mixidinfos = this.value;
				}else{
					mixline_infos += "~"+this.id;
					mixidinfos += "~"+this.value;
				}
				mixcount++;
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
		var submiturl = "<%=contextPath%>/rm/dm/saveOutFormSubInfo.srq?state="+state;
		submiturl += "&count="+count+"&line_infos="+line_infos+"&idinfos="+idinfos;
		submiturl += "&mixcount="+mixcount+"&mixline_infos="+mixline_infos+"&mixidinfos="+mixidinfos;
		submiturl += "&addedcount="+addedcount+"&addedline_infos="+addedline_infos+"&devaddedcount="+devaddedcount+"&devaddedline_infos="+devaddedline_infos;
		
		document.getElementById("form1").action = submiturl;
		document.getElementById("form1").submit();
	}
	
	function refreshData(){
		var retObj;
		var basedatas;
		if('<%=mixInfoId%>'!=null){
			//回填基本信息
			var mainsql = "select cmf.mixinfo_no,cmf.project_info_no,cmf.in_org_id,cmf.out_org_id,cmf.device_mixinfo_id,cmf.modifi_date as mix_date,";
			mainsql += "tp.project_name,inorg.org_abbreviation as in_org_name,outorg.org_abbreviation as out_org_name ";
			mainsql += "from gms_device_collmix_form cmf ";
			mainsql += "left join gp_task_project tp on cmf.project_info_no=tp.project_info_no ";
			mainsql += "left join comm_org_information inorg on cmf.in_org_id=inorg.org_id ";
			mainsql += "left join comm_org_information outorg on cmf.out_org_id=outorg.org_id ";
			mainsql += "where cmf.device_mixinfo_id='<%=mixInfoId%>'";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+mainsql);
			retObj = proqueryRet.datas;
			if(retObj!=undefined && retObj.length>0){
				$("#project_name").val(retObj[0].project_name);
				$("#project_info_no").val(retObj[0].project_info_no);
				$("#mixinfo_no").val(retObj[0].mixinfo_no);
				$("#mix_date").val(retObj[0].mix_date);
				$("#in_org_name").val(retObj[0].in_org_name);
				$("#in_org_id").val(retObj[0].in_org_id);
				$("#out_org_name").val(retObj[0].out_org_name);
				$("#out_org_id").val(retObj[0].out_org_id);
			}
			//回填明细信息
			<%-- var prosql = "select cms.device_mif_subid,cms.device_id,cms.device_name,cms.device_model,cms.mix_num,cms.team,cms.devremark as mixdevmark,";
				prosql += "nvl(temp.outednum,0) outednum,account.unuse_num,account.dev_acc_id,cms.unit_id,unitsd.coding_name as unit_name ";
				prosql += "from gms_device_coll_mixsub cms ";
				prosql += "left join (select device_mif_subid,sum(out_num) as outednum from gms_device_coll_outsub group by device_mif_subid) temp on temp.device_mif_subid=cms.device_mif_subid ";
				prosql += "left join gms_device_collmix_form cmf on cms.device_mixinfo_id = cmf.device_mixinfo_id ";
				prosql += "left join gms_device_coll_account account on cms.device_id=account.device_id and cmf.out_org_id = account.usage_org_id ";
				prosql += "left join comm_coding_sort_detail unitsd on unitsd.coding_code_id=cms.unit_id ";
				prosql += "where (account.bsflag is null or account.bsflag='0') and account.ifcountry !='国外' and cms.device_mixinfo_id='<%=mixInfoId%>'";
				prosql += "order by cms.device_id "; --%>
			var prosql = "select cms.device_mif_subid, cms.device_id, cms.device_name, cms.device_model, cms.mix_num, cms.team, cms.devremark as mixdevmark,";
			prosql += "nvl(temp.outednum, 0) outednum, nvl(subnum.unuse_num,0) unuse_num,nvl(subnum.total_num,0) total_num, cms.unit_id, unitsd.coding_name as unit_name ";
			prosql += " from gms_device_coll_mixsub cms left join (select device_mif_subid, sum(out_num) as outednum ";
			prosql += " from gms_device_coll_outsub group by device_mif_subid) temp ";
			prosql += " on temp.device_mif_subid = cms.device_mif_subid left join gms_device_collmix_form cmf ";
			prosql += " on cms.device_mixinfo_id = cmf.device_mixinfo_id left join GMS_DEVICE_COLLECTINFO ct on ct.device_id=cms.device_id ";
			prosql += " left join (select count(ct.device_id) total_num,ct.device_id,sum(nvl2(b.usage_org_id,0,1)) unuse_num ";
			prosql += " from gms_device_collmix_form cmform ";
			prosql += " join gms_device_coll_mixsub msub on cmform.device_mixinfo_id=msub.device_mixinfo_id ";
			prosql += " join GMS_DEVICE_COLLECTINFO ct on ct.device_id=msub.device_id ";
			prosql += " join GMS_DEVICE_COLL_MAPPING mp on mp.device_id=ct.device_id ";
			prosql += " join GMS_DEVICE_CODEINFO cltype on cltype.dev_ci_code=mp.dev_ci_code ";
			prosql += " join gms_device_account_b b on b.dev_type=cltype.dev_ci_code ";
			prosql += " where b.owning_org_id = cmform.out_org_id and b.bsflag='0' and cmform.device_mixinfo_id='<%=mixInfoId%>'";
			prosql += " group by ct.device_id ) subnum on subnum.device_id=cms.device_id ";
			prosql += " left join comm_coding_sort_detail unitsd on unitsd.coding_code_id = cms.unit_id ";
			prosql += " where  cms.device_mixinfo_id = '<%=mixInfoId%>' order by cms.device_id ";

			debugger;
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
			retObj = proqueryRet.datas;
			if(retObj!=undefined){
				for(var index=0;index<retObj.length;index++){
					//动态新增表格
					var innerhtml = "<tr id='mixtr"+index+"' name='mixtr"+index+"' seq='"+index+"'>";
					innerhtml += "<td width='4%'><input type='checkbox' name='detinfo' id='"+index+"' value='"+retObj[index].device_mif_subid+"' checked/></td>";
					innerhtml += "<td width='13%'><input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='"+retObj[index].device_name+"' size='12' type='text' readonly/>";
					innerhtml += "<input name='team"+index+"' id='team"+index+"' style='line-height:15px' value='"+retObj[index].team+"' type='hidden' />";
					innerhtml += "<input name='deviceid"+index+"' id='deviceid"+index+"' style='line-height:15px' value='"+retObj[index].device_id+"' type='hidden' /></td>";
					innerhtml += "<td width='13%'><input name='devicemodel"+index+"' id='devicemodel"+index+"' value='"+retObj[index].device_model+"' size='12' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='unitname"+index+"' id='unitname"+index+"' size='8' value='"+retObj[index].unit_name+"' type='text' readonly/>";
					innerhtml += "<input name='unitid"+index+"' id='unitid"+index+"' value='"+retObj[index].unit_id+"' size='8' type='hidden' readonly/></td>";
					innerhtml += "<td width='10%'><input name='mixnum"+index+"' id='mixnum"+index+"' style='line-height:15px' value='"+retObj[index].mix_num+"' size='8' type='text' /></td>";
					innerhtml += "<td width='10%'><input name='mixdevremark"+index+"' id='mixdevremark"+index+"' value='"+retObj[index].mixdevmark+"' size='8' type='text' readonly/></td>";
					
					innerhtml += "<td width='10%'><input name='outednum"+index+"' id='outednum"+index+"' value='"+retObj[index].outednum+"' size='8'  type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='unusenum"+index+"' id='unusenum"+index+"' value='"+retObj[index].unuse_num+"' size='8' type='text' />";
					
					//innerhtml += "<input name='devaccid"+index+"' id='devaccid"+index+"' value='"+retObj[index].dev_acc_id+"' type='hidden' /></td>";
					innerhtml += "</td>";
					
					innerhtml += "<td width='10%'><input name='outnum"+index+"' id='outnum"+index+"' value='' size='8' type='text' detindex='"+index+"' onkeyup='checkAssignNum(this)' readonly></td>";
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
				addprosql += "left join (select device_mif_subid,sum(out_num) as outednum from gms_device_coll_outsubadd group by device_mif_subid) temp on temp.device_mif_subid=cms.device_mif_subid ";
				addprosql += "left join gms_device_collmix_form cmf on cms.device_mixinfo_id = cmf.device_mixinfo_id ";
				addprosql += "where cms.device_mixinfo_id='<%=mixInfoId%>'";
				addprosql += "order by cms.device_name ";
			var adddproqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+addprosql);
			retObj = adddproqueryRet.datas;
			if(retObj!=undefined){
				for(var index=0;index<retObj.length;index++){
					//动态新增表格
					var innerhtml = "<tr id='mixdettr"+index+"' name='mixdettr"+index+"' seq='"+index+"'>";
					innerhtml += "<td width='4%'><input type='checkbox' name='adddetinfo' id='"+index+"' value='"+retObj[index].device_mif_subid+"' checked/></td>";
					innerhtml += "<td width='13%'><input name='addmixdevicename"+index+"' id='addmixdevicename"+index+"' style='line-height:18px;width:98%' value='"+retObj[index].device_name+"'  type='text' readonly/>";
					innerhtml += "<input name='addmixteam"+index+"' id='addmixteam"+index+"' value='"+retObj[index].team+"' type='hidden' /></td>";
					innerhtml += "<td width='13%'><input name='addmixdevicemodel"+index+"' id='addmixdevicemodel"+index+"' value='"+retObj[index].device_model+"' style='line-height:18px;width:98%' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='addmixunitname"+index+"' id='addmixunitname"+index+"' value='"+retObj[index].unit_name+"' style='line-height:18px;width:98%' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='addmixnum"+index+"' id='addmixnum"+index+"' value='"+retObj[index].mix_num+"' style='line-height:18px;width:98%' type='text' /></td>";
					innerhtml += "<td width='10%'><input name='addmixdevremark"+index+"' id='addmixdevremark"+index+"' value='"+retObj[index].mixdevmark+"' style='line-height:18px;width:98%' type='text' readonly/></td>";
					
					innerhtml += "<td width='10%'><input name='addmixoutednum"+index+"' id='addmixoutednum"+index+"' value='"+retObj[index].outednum+"' style='line-height:18px;width:98%' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='addmixoutnum"+index+"' id='addmixoutnum"+index+"' value='' style='line-height:18px;width:98%' type='text' detindex='"+index+"' onkeyup='checkAssignAddNum(this)'></td>";
					innerhtml += "<td width='10%'><input name='addmixoutdevremark"+index+"' id='addmixoutdevremark"+index+"' value='' style='line-height:18px;width:98%' type='text' /></td>";
					
					innerhtml += "</tr>";
					$("#addeddetailtable").append(innerhtml);		
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
		var _t = $("input[name^='team'][type='hidden']");
		if(_t.length==0){
			alert('没有出库数据，不能添加明细');
			return false;
		}
		var team = _t[0].value;
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
			if(this.checked){
				var index = this.id;//.substr(8);
				$("#addedtr"+index,"#addeddetailtable").remove();
			}
		});
		$("input[name='adddetinfo'][type='checkbox']").each(function(i){
			if(this.checked){
				var index = this.id;//.substr(8);
				
				$("#mixdettr"+index,"#addeddetailtable").remove();
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
			}
		}
	}
	//补充调配对应的出库，填写信息
	function toMixMixedDetailInfos(){
		
		var addedinnerhtml;
		//补充调配信息
		var outNotmixedflag = false;
		//获得选择的调配类别信息
		$("input[type='checkbox'][name='adddetinfo']").each(function(i){
			if(this.checked == true){
				var indexinfo = this.id;
				var outnuminfo = $("#addmixoutnum"+indexinfo).val();
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
		$("input[type='checkbox'][name='adddetinfo']").each(function(i){
			if(this.checked == true){
				var indexinfo = this.id;
				var valueinfo = this.value;
				var devicename = $("#addmixdevicename"+indexinfo).val();
				var devicemodel = $("#addmixdevicemodel"+indexinfo).val();
				var outnum = $("#addmixoutnum"+indexinfo).val();
				//var startdate = $("#addplanstartdate"+indexinfo).val();
				//var enddate = $("#addplanenddate"+indexinfo).val();
				//需要回头给unitid也放进来 var unitid = $("#mixunitid"+indexinfo).val();
				var unitname = $("#addmixunitname"+indexinfo).val();
				for(var j = 0;j<parseInt(outnum);j++){
					mixseqinfo++;
					var innerhtml = "<tr id='addmixdettr"+mixseqinfo+"' name='addmixdettr"+mixseqinfo+"' seq='"+mixseqinfo+"' is_added='false'>";
					innerhtml += "<td width='4%'>&nbsp;</td>";
					innerhtml += "<td width='12%'><input name='addmixdetdevicename"+mixseqinfo+"' id='addmixdetdevicename"+mixseqinfo+"' value='"+devicename+"' style='line-height:18px;width:98%' size='10' type='text' readonly/></td>";
					<%-- innerhtml += "<td width='12%'><input name='addmixdetdevicetype"+mixseqinfo+"' id='addmixdetdevicetype"+mixseqinfo+"' value='"+devicemodel+"' style='line-height:18px;' size='10' type='text' readonly/><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick=showMixDevPage("+mixseqinfo+",'"+devicename+"','"+devicemodel+"') /></td>"; --%>
					innerhtml += "<td width='12%'><input name='addmixdetdevicetype"+mixseqinfo+"' id='addmixdetdevicetype"+mixseqinfo+"' value='"+devicemodel+"' style='line-height:18px;' size='10' type='text' readonly/><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick=showMixDevPage("+mixseqinfo+",'"+devicename+"','"+devicemodel+"') /></td>";
					innerhtml += "<td width='10%'><input name='addmixdetdevice_mix_subid"+mixseqinfo+"' id='addmixdetdevice_mix_subid"+mixseqinfo+"' value='"+valueinfo+"' type='hidden'/>";
					innerhtml += "<input name='addmixdetdev_acc_id"+mixseqinfo+"' id='addmixdetdev_acc_id"+mixseqinfo+"' seq='"+mixseqinfo+"' value='' type='hidden'/>";
					innerhtml += "<input name='addmixdetdevcicode"+mixseqinfo+"' id='addmixdetdevcicode"+mixseqinfo+"' value='' type='hidden'/>";
					innerhtml += "<input name='addmixdetself_num"+mixseqinfo+"' id='addmixdetself_num"+mixseqinfo+"' style='line-height:18px;' size='10' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='addmixdetdev_sign"+mixseqinfo+"' id='addmixdetdev_sign"+mixseqinfo+"' style='line-height:18px;' type='text' size='10' readonly/></td>";
					innerhtml += "<td width='10%'><input name='addmixdetlicense_num"+mixseqinfo+"' id='addmixdetlicense_num"+mixseqinfo+"' value='' style='line-height:18px;' size='10' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='addmixdetasset_coding"+mixseqinfo+"' id='addmixdetasset_coding"+mixseqinfo+"' style='line-height:18px;width:98%' value='' readonly/></td>";
					innerhtml += "<td width='11%'><input name='addmixdetdevstartdate"+mixseqinfo+"' id='addmixdetdevstartdate"+mixseqinfo+"' style='line-height:18px;width:99%' size='15' value='' type='text' readonly/></td>";
					innerhtml += "<td width='11%'><input name='addmixdetdevenddate"+mixseqinfo+"' id='addmixdetdevenddate"+mixseqinfo+"' style='line-height:18px;width:99%' size='15' value='' type='text' readonly/></td>";
					innerhtml += "<td width='10%'><input name='addmixdetdevremark"+mixseqinfo+"' id='addmixdetdevremark"+mixseqinfo+"' value='' size='10' type='text' /></td>";
					innerhtml += "</tr>";
					$("#devdetailtable").append(innerhtml);
				}
			}
		});
		/* if(addedinnerhtml!=null&&addedinnerhtml!=""){
			$("#addeddetailtable").append(addedinnerhtml);
		} */
		$("#devdetailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#devdetailtable>tr:odd>td:even").addClass("odd_even");
		$("#devdetailtable>tr:even>td:odd").addClass("even_odd");
		$("#devdetailtable>tr:even>td:even").addClass("even_even");
		
		$("#mixtab_box").show();
		$("input[type='text'][id^='mixoutnum']").each(function(i){
			$(this).attr("readonly","readonly");
		});
	}
	function toAddAddedDetailInfo(){
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
		innerhtml += "<td width='11%'><input name='addedplanstartdate"+addedseqinfo+"' id='addedplanstartdate"+addedseqinfo+"' value='' style='line-height:18px;width:98%' type='text' readonly/>";
		innerhtml += "<td width='11%'><input name='addedplanenddate"+addedseqinfo+"' id='addedplanenddate"+addedseqinfo+"' value='' style='line-height:18px;width:98%' type='text' readonly/></td>";
		innerhtml += "<td width='10%'><input name='addedremark"+addedseqinfo+"' id='addedremark"+addedseqinfo+"' value='' size='10' type='text' /></td>";
		innerhtml += "</tr>";
		$("#devdetailtable").append(innerhtml);
		$("#devdetailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#devdetailtable>tr:odd>td:even").addClass("odd_even");
		$("#devdetailtable>tr:even>td:odd").addClass("even_odd");
		$("#devdetailtable>tr:even>td:even").addClass("even_even");
		$("#mixtab_box").show();
	}
	function toDelAddedDetailInfo(){
		$("input[name='addedseq'][type='checkbox']").each(function(i){
			if(this.checked){
				var index = this.id;//.substr(8);
				
				$("#tr"+index,"#devdetailtable").remove();
			}
		});
		if($("tr","#devdetailtable").size()==0){
			$("#mixtab_box").hide();
		}
		$("#devdetailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#devdetailtable>tr:odd>td:even").addClass("odd_even");
		$("#devdetailtable>tr:even>td:odd").addClass("even_odd");
		$("#devdetailtable>tr:even>td:even").addClass("even_even");
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
		var dialogurl ="<%=contextPath%>/rm/dm/tree/selectAccountForAdded.jsp";
		dialogurl = encodeURI(dialogurl);
		dialogurl = encodeURI(dialogurl);
		var vReturnValue = window.showModalDialog(dialogurl, obj ,"dialogWidth=820px;dialogHeight=500px;scroll:yes");
		if(vReturnValue!=undefined){
			
			var returnvalues = vReturnValue.split('~');
			//返回信息是 队级台账id + 设备编码 + 设备名称 + 规格型号 + 自编号 + 实物标识号 + 牌照号
			$("input[name='addeddev_acc_id"+seqinfo+"']","#devdetailtable").val(returnvalues[0]);
			$("input[name='addedasset_coding"+seqinfo+"']","#devdetailtable").val(returnvalues[1]);
			$("input[name='addeddevicename"+seqinfo+"']","#devdetailtable").val(returnvalues[2]);
			$("input[name='addeddevicetype"+seqinfo+"']","#devdetailtable").val(returnvalues[3]);
			$("input[name='addedself_num"+seqinfo+"']","#devdetailtable").val(returnvalues[4]);
			$("input[name='addeddev_sign"+seqinfo+"']","#devdetailtable").val(returnvalues[5]);
			$("input[name='addedlicense_num"+seqinfo+"']","#devdetailtable").val(returnvalues[6]);
			$("input[name='addeddevcicode"+seqinfo+"']","#devdetailtable").val(returnvalues[7]);
		}
	}
	$().ready(function(){
		$("#devbackinfo").change(function(){
			var checkvalue = this.checked;
			$("input[type='checkbox'][name^='detinfo']").attr('checked',checkvalue);
		});
		$("#devbackinfo2").change(function(){
			var checkvalue = this.checked;
			$("input[type='checkbox'][name^='adddetinfo']").attr('checked',checkvalue);
			$("input[type='checkbox'][name^='addedoutseq']").attr('checked',checkvalue);
			
			
		});
		$("#devbackinfo3").change(function(){
			var checkvalue = this.checked;
			$("input[type='checkbox'][name^='addedseq']").attr('checked',checkvalue);
		});
		
	});
	function showMixDevPage(trid,dev_name,dev_model){
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
		var forwordurl =  "<%=contextPath%>/rm/dm/tree/selectAccountForMixAdd.jsp?dev_model="+dev_model+"&dev_name="+dev_name+"&out_org_id="+out_org_id;
		forwordurl = encodeURI(forwordurl);
		forwordurl = encodeURI(forwordurl);
		var vReturnValue = window.showModalDialog(forwordurl , obj ,"dialogWidth=950px;dialogHeight=480px");
		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split('~');
			//返回信息是 队级台账id + 设备编码 + 设备名称 + 规格型号 + 自编号 + 实物标识号 + 牌照号
			$("input[name='mixdetdev_acc_id"+trid+"']","#devdetailtable").val(returnvalues[0]);
			$("input[name='mixdetasset_coding"+trid+"']","#devdetailtable").val(returnvalues[1]);
			$("input[name='mixdetdevicename"+trid+"']","#devdetailtable").val(returnvalues[2]);
			$("input[name='mixdetdevicetype"+trid+"']","#devdetailtable").val(returnvalues[3]);
			$("input[name='mixdetself_num"+trid+"']","#devdetailtable").val(returnvalues[4]);
			$("input[name='mixdetdev_sign"+trid+"']","#devdetailtable").val(returnvalues[5]);
			$("input[name='mixdetlicense_num"+trid+"']","#devdetailtable").val(returnvalues[6]);
			$("input[name='mixdetdevcicode"+trid+"']","#devdetailtable").val(returnvalues[7]);
		}
	}
</script>
</html>

