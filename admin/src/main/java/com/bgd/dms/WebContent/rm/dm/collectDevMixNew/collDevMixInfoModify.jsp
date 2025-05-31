<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String devappid = request.getParameter("devappid");
	String mixInfoId = request.getParameter("mixInfoId");
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
<title>按量设备调配单修改界面</title>
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
          	<input name="devicemixinfoid" id="devicemixinfoid" type="hidden" value="<%=mixInfoId%>" />
          </td>
          <td class="inquire_item4" ></td><td class="inquire_form4" ></td>
        </tr>
        <tr>
          <td class="inquire_item4" >调配申请单号:</td>
          <td class="inquire_form4" >
          	<input name="appinfo_no" id="appinfo_no" class="input_width" type="text"  value="" readonly/>
          </td>
          <td class="inquire_item4" >申请时间:</td>
          <td class="inquire_form4" >
          	<input name="app_date" id="app_date" class="input_width" type="text"  value="" readonly/>
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
	  <fieldset style="margin-left:2px"><legend>调配明细</legend>
		  <div style="overflow:auto">
			  <table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" width="4%">选择</td>
					<td class="bt_info_even" width="9%">班组</td>
					<td class="bt_info_odd" width="12%">设备名称</td>
					<td class="bt_info_even" width="12%">规格型号</td>
					<td class="bt_info_odd" width="9%">计量单位</td>
					<td class="bt_info_even" width="9%">申请数量</td>
					<td class="bt_info_odd" width="8%">已调配数量</td>
					<td class="bt_info_even" width="8.5%">总数量</td>
					<td class="bt_info_odd" width="8.5%">闲置数量</td>
					<td class="bt_info_even" width="8%">调配数量</td>
					<td class="bt_info_odd" width="12%">备注</td>
				</tr>
		      </table>
		       <div style="height:150px;overflow:auto;">
					<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style='table-layout: auto'>
			   	 	<tbody id="processtable" name="processtable">
			    	</tbody>
					</table>
				</div>
	       </div>
      </fieldset>
      <fieldset style="margin-left:2px"><legend>补充明细</legend>
		  <table style="width:98%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	        <tr>
	          <td width="5%"><span class="zj"><a href="#" id="addaddedbtn" onclick='toAddAddedDetailInfos()' title="添加"></a></span></td>
	          <td width="5%"><span class="sc"><a href="#" id="deladdedbtn" onclick='toDelAddedDetailInfos()' title="删除"></a></span></td>
	          <td width="90%"></td>
	        </tr>
	      </table>
		  <div id="tab_box" class="tab_box" style="height:120px;overflow:auto;">
				<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			       <tr>
						<td class="bt_info_odd" width="4%">选择<input type="checkbox" name="alldetinfo" id="alldetinfo" checked/></td>
						<td class="bt_info_even" width="12%">班组</td>
						<td class="bt_info_odd" width="12%">设备名称</td>
						<td class="bt_info_even" width="12%">规格型号</td>
						<td class="bt_info_odd" width="10%">计量单位</td>
						<td class="bt_info_even" width="10%">调配数量</td>
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
	(function($){
		$.fn.disableLineInput = function(){
			$("input[type='text']",$(this)).attr("disabled","disabled");
		};
		$.fn.enableLineInput = function(){
			$("input[type='text']",$(this)).removeAttr("disabled");
		};
	})(jQuery)
	function submitInfo(state){
		//给信息保存到数据库中，重写入库操作
		if($("#out_org_name").val()==''){
			alert("请选择转出单位!");
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
		var selectedlines = line_infos.split("~");
		var wronglineinfos = "";
		var outlineinfos = "";
		var wrongcount = 0;
		var bigcount = 0;
		for(var index=0;index<selectedlines.length;index++){
			var valueinfo = $("#mixnum"+selectedlines[index]).val();
			var unuseinfo = $("#unusenum"+selectedlines[index]).val();
			if(valueinfo == ""){
				if(index == 0){
					wronglineinfos += (parseInt(selectedlines[index])+1);
				}else{
					wronglineinfos += ","+(parseInt(selectedlines[index])+1);
				}
			}else if(parseInt(valueinfo,10)>parseInt(unuseinfo,10)){
				if(bigcount == 0){
					outlineinfos += (parseInt(selectedlines[index])+1);
				}else{
					outlineinfos += ","+(parseInt(selectedlines[index])+1);
				}
			}
		}
		if(wronglineinfos!=""){
			alert("请设置第"+wronglineinfos+"行明细的调配数量!");
			return;
		}
		//添加的明细信息必须有名称和数量
		var addedwrongflag = false;
		$("input[type='text'][name^='addeddevicename']").each(function(){
			var devicenameinfo  = this.value;
			var index = this.idindex ;
			var assignnuminfo = document.getElementById("addedassignnum"+index);
			if(devicenameinfo==""||assignnuminfo==""){
				addedwrongflag = true;
			}
		})
		if(addedwrongflag){
			alert("调配明细信息的名称和数量不为空,请完善补充调配明细信息!");
			return;
		}
		if(outlineinfos!=""){
			var showinfo = "第"+outlineinfos+"行明细的调配数量大于闲置数量，是否继续?";
			if(!confirm(showinfo)){
				return;
			}
		}
		//补充明细的seq信息
		var addedcount = $("input[type='text'][name^='addeddevicename']","#addeddetailtable").size();
		var addedline_info;
		$("input[type='text'][name^='addeddevicename']","#addeddetailtable").each(function(i){
			var idindex = this.idindex;
			if(i==0){
				addedline_info = idindex;
			}else{
				addedline_info += "~"+idindex;
			}
		});
		var detailcount = $("input[type='hidden'][name^='deviceid']","#detailtable").size();
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveEQBatchMixFormDetailInfo.srq?state="+state+"&count="+count+"&line_infos="+line_infos+"&idinfos="+idinfos+"&detailcount="+detailcount+"&addedcount="+addedcount+"&addedline_info="+addedline_info;
		document.getElementById("form1").submit();
	}
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
		var orgidvalue = orgId[1];
		document.getElementById(str+"_id").value = orgidvalue;
		fillAppDetailNouseNum(orgidvalue);
	}
	function fillAppDetailNouseNum(orgidvalue){
		//给所有的unusenum设置为空
		$("input[type='text'][name^='unusenum']","#processtable").val("");
		
		var mainsql = "select usage_org_id,device_id,total_num,unuse_num from gms_device_coll_account account ";
			mainsql += "where account.usage_org_id='"+orgidvalue+"' and ";
			mainsql += "account.device_id in ";
 			mainsql += "(select device_id from gms_device_app_colldetsub sub ";
			mainsql += " join gms_device_app_colldetail detail ";
			mainsql += "on sub.device_app_detid=detail.device_app_detid ";
			mainsql += " where detail.device_app_id='<%=devappid%>')";
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+mainsql);
		retObj = proqueryRet.datas;
		if(retObj!=undefined && retObj.length>0){
			var maxline =  $("#processtable>tr").size();
			for(var index=0;index<retObj.length&&index<maxline;index++){
				var j = 0;
				var currentvalue = retObj[index].device_id;
				for(;j<maxline;j++){
					var lineidvalue = $("#deviceid"+j).val();
					if(lineidvalue != currentvalue){
						//$("#tr"+j,"#processtable").disableLineInput();
						$("input:checkbox[name^='detinfo'][id="+j+"]").attr("disabled","disabled");
						$("input:checkbox[name^='detinfo'][id="+j+"]").removeAttr("checked");
					}else{
						//$("#tr"+j,"#processtable").enableLineInput();
						$("input:checkbox[name^='detinfo'][id="+j+"]").removeAttr("disabled");
						$("input:checkbox[name^='detinfo'][id="+j+"]").attr("checked","checked");
						$("#totalnum"+j,"#processtable").val(retObj[index].total_num);
						$("#unusenum"+j,"#processtable").val(retObj[index].unuse_num);
					}
				}
			}
		}else{
			var maxline = $("#processtable>tr").size();
			for(var j = 0;j<maxline;j++){
				//$("#tr"+j,"#processtable").disableLineInput();
				$("input:checkbox[name^='detinfo']").attr("disabled","disabled");
				$("input:checkbox[name^='detinfo']").removeAttr("checked");
			}
		}
		//给为空的都屏蔽了
		$("#processtable>tr").each(function(i){
			var tmpval = $("#unusenum"+i).val();
			if(tmpval!= '' && tmpval != null){
				$("input:checkbox[name^='detinfo'][id="+i+"]").removeAttr("disabled");
				$("input:checkbox[name^='detinfo'][id="+i+"]").attr("checked","checked");
				$(this).enableLineInput();
			}else{
				$("input:checkbox[name^='detinfo'][id="+i+"]").attr("disabled","disabled");
				$("input:checkbox[name^='detinfo'][id="+i+"]").removeAttr("checked");
				$(this).disableLineInput();
			}
		});
	}
	var addedseqinfo = 0;
	function toAddAddedDetailInfos(){
		//获得第一行的team信息
		var teamname = $("input[name^='teamname'][type='text']")[0].value;
		var team = $("input[name^='team'][type='hidden']")[0].value;
		addedseqinfo++;
		var innerhtml = "<tr id='tr"+addedseqinfo+"' name='tr"+addedseqinfo+"' seq='"+addedseqinfo+"' is_added='false'>";
		innerhtml += "<td width='4%'><input type='checkbox' name='addedseq' id='addedseq"+addedseqinfo+"'/></td>";
		innerhtml += "<td width='12%'><input name='addedteamname"+addedseqinfo+"' id='addedteamname"+addedseqinfo+"' value='"+teamname+"' style='line-height:18px;width:98%' size='10' type='text' readonly/>";
		innerhtml += "<input name='addedteam"+addedseqinfo+"' id='addedteam"+addedseqinfo+"' value='"+team+"' type='hidden' /></td>";
		innerhtml += "<td width='12%'><input name='addeddevicename"+addedseqinfo+"' id='addeddevicename"+addedseqinfo+"' idindex='"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='10' type='text' /></td>";
		innerhtml += "<td width='12%'><input name='addeddevicetype"+addedseqinfo+"' id='addeddevicetype"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='10' type='text' /></td>";
		innerhtml += "<td width='10%'><input name='addedunit"+addedseqinfo+"' id='addedunit"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='8' type='text' /></td>";
		innerhtml += "<td width='10%'><input name='addedassignnum"+addedseqinfo+"' id='addedassignnum"+addedseqinfo+"' style='line-height:18px;width:98%' type='text' size='8' onkeyup='checkaddedNum(this)'/></td>";
		innerhtml += "<td width='10%'><input name='addedremark"+addedseqinfo+"' id='addedremark"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='10' type='text' /></td>";
		innerhtml += "</tr>";
		$("#addeddetailtable").append(innerhtml);
		$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
		$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
		$("#addeddetailtable>tr:even>td:even").addClass("even_even");
	}
	function toDelAddedDetailInfos(){
		$("input[name='addedseq'][type='checkbox']").each(function(i){
			if(this.checked){
				var index = this.id.substr(8);
				$("#tr"+index,"#addeddetailtable").remove();
			}
		});
		$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
		$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
		$("#addeddetailtable>tr:even>td:even").addClass("even_even");
	}
	function refreshData(){
		var retObj;
		var basedatas;
		if('<%=devappid%>'!=null){
			//回填基本信息
			var mainsql = "select devapp.device_app_no,cmf.project_info_no,";
			mainsql += "cmf.mixinfo_no,cmf.in_org_id,cmf.out_org_id,devapp.appdate,";
			mainsql += "tp.project_name,inorg.org_abbreviation as in_org_name,outorg.org_abbreviation as out_org_name ";
			mainsql += "from gms_device_collapp devapp ";
			mainsql += "left join gms_device_collmix_form cmf on cmf.device_app_id=devapp.device_app_id ";
			mainsql += "left join gp_task_project tp on cmf.project_info_no=tp.project_info_no ";
			mainsql += "left join comm_org_information inorg on cmf.in_org_id=inorg.org_id ";
			mainsql += "left join comm_org_information outorg on cmf.out_org_id=outorg.org_id "
			mainsql += "where devapp.device_app_id='<%=devappid%>' and cmf.device_mixinfo_id='<%=mixInfoId%>' ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+mainsql);
			retObj = proqueryRet.datas;
			if(retObj!=undefined && retObj.length>0){
				$("#project_name").val(retObj[0].project_name);
				$("#project_info_no").val(retObj[0].project_info_no);
				$("#appinfo_no").val(retObj[0].device_app_no);
				$("#app_date").val(retObj[0].appdate);
				$("#in_org_name").val(retObj[0].in_org_name);
				$("#in_org_id").val(retObj[0].in_org_id);
				$("#out_org_name").val(retObj[0].out_org_name);
				$("#out_org_id").val(retObj[0].out_org_id);
			}
			var v_out_org_id = retObj[0].out_org_id;
			//回填明细信息
			var prosql = "select cms.device_mif_subid,cds.device_detsubid,cds.device_id,cds.device_name,cms.devremark,";
				prosql += "cds.device_model,cds.device_num as applynum,nvl(temp.mixednum, 0) mixednum,cds.unit_id ,";
				prosql += "cd.team,teamsd.coding_name as team_name,";
				prosql += "unitsd.coding_name as unit_name,cms.mix_num,cd.device_app_id,cms.device_mixinfo_id,account.unuse_num,account.total_num ";
				prosql += "from gms_device_app_colldetsub cds ";
				prosql += "inner join gms_device_app_colldetail cd on cds.device_app_detid = cd.device_app_detid ";
 				prosql += "left join gms_device_coll_mixsub cms on cds.device_detsubid = cms.device_detsubid "
 							+"and cms.device_mixinfo_id='<%=mixInfoId%>' ";
 				prosql += "left join (select device_detsubid, sum(mix_num) as mixednum ";
				prosql += "  from gms_device_coll_mixsub mixsub ";
				prosql += " group by device_detsubid) temp on temp.device_detsubid = cds.device_detsubid ";
				prosql += "join comm_coding_sort_detail unitsd on unitsd.coding_code_id = cds.unit_id ";
				prosql += "left join comm_coding_sort_detail teamsd on teamsd.coding_code_id = cd.team ";
				prosql += "left join gms_device_coll_account account on account.device_id = cds.device_id and account.usage_org_id='"+v_out_org_id+"' ";
				prosql += "where cd.device_app_id = '<%=devappid%>' and cd.bsflag='0' ";
				prosql += "order by cms.device_id ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
			retObj = proqueryRet.datas;
		}
		if(retObj!=undefined){
			for(var index=0;index<retObj.length;index++){
				//动态新增表格
				var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
				innerhtml += "<td width='4%'><input type='checkbox' name='detinfo' id='"+index+"' value='"+retObj[index].device_detsubid+"' /></td>";
				innerhtml += "<td width='9%'><input name='teamname"+index+"' id='teamname"+index+"' style='line-height:15px' value='"+retObj[index].team_name+"' size='8' type='text' readonly/>";
				innerhtml += "<input name='team"+index+"' id='team"+index+"' style='line-height:15px' value='"+retObj[index].team+"' type='hidden' /></td>";
				innerhtml += "<td width='12%'><input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='"+retObj[index].device_name+"' size='11' type='text' readonly/>";
				innerhtml += "<input name='deviceid"+index+"' id='deviceid"+index+"' style='line-height:15px' value='"+retObj[index].device_id+"' type='hidden' /></td>";
				innerhtml += "<td width='12%'><input name='devicemodel"+index+"' id='devicemodel"+index+"' value='"+retObj[index].device_model+"' size='11' type='text' readonly/></td>";
				
				innerhtml += "<td width='9%'><input name='unitname"+index+"' id='unitname"+index+"' value='"+retObj[index].unit_name+"' size='6' type='text' readonly/>";
				innerhtml += "<input name='devicemifsubid"+index+"' id='devicemifsubid"+index+"' value='"+retObj[index].device_mif_subid+"' type='hidden' />";
				innerhtml += "<input name='unitid"+index+"' id='unitid"+index+"' value='"+retObj[index].unit_id+"' type='hidden' /></td>";
				innerhtml += "<td width='9%'><input name='applynum"+index+"' id='applynum"+index+"' style='line-height:15px' value='"+retObj[index].applynum+"' size='6' type='text' /></td>";
				innerhtml += "<td width='8%'><input name='mixednum"+index+"' id='mixednum"+index+"' value='"+retObj[index].mixednum+"' size='6'  type='text' readonly/>";
				innerhtml += "<input type='hidden' name='checkmixednum"+index+"' id='checkmixednum"+index+"' value='"+(parseInt(retObj[index].mixednum)-parseInt(retObj[index].mix_num))+"'/></td>";
				innerhtml += "<td width='8.5%'><input name='totalnum"+index+"' id='totalnum"+index+"' value='"+retObj[index].total_num+"' size='6' type='text' readonly/></td>";
				innerhtml += "<td width='8.5%'><input name='unusenum"+index+"' id='unusenum"+index+"' value='"+retObj[index].unuse_num+"' size='6' type='text' readonly/></td>";
				
				innerhtml += "<td width='8%'><input name='mixnum"+index+"' id='mixnum"+index+"' value='"+retObj[index].mix_num+"' size='6' type='text' detindex='"+index+"' onkeyup='checkAssignNum(this)'></td>";
				
				innerhtml += "<td width='12%'><input name='devremark"+index+"' id='devremark"+index+"' value='"+retObj[index].devremark+"' size='8' type='text' /></td>";
				
				innerhtml += "</tr>";
				$("#processtable").append(innerhtml);
			}
			$("#processtable>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable>tr:odd>td:even").addClass("odd_even");
			$("#processtable>tr:even>td:odd").addClass("even_odd");
			$("#processtable>tr:even>td:even").addClass("even_even");
			fillAppDetailNouseNum(v_out_org_id);
		}
		//回填明细信息
		var addedprosql = "select cds.device_mif_subid,cds.device_mixinfo_id,cds.device_name,cds.device_model,cds.mix_num,";
			addedprosql += "cds.unit_name,cds.team,cds.devremark,";
			addedprosql += "teamsd.coding_name as team_name ";
			addedprosql += "from gms_device_coll_mixsubadd cds ";
			addedprosql += "left join comm_coding_sort_detail teamsd on teamsd.coding_code_id = cds.team ";
			addedprosql += "where cds.device_mixinfo_id = '<%=mixInfoId%>'";
		var addedproqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+addedprosql);
		addedretObj = addedproqueryRet.datas;
			
		if(addedretObj!=undefined){
			for(var index=0;index<addedretObj.length;index++){
				addedseqinfo = index+1;
				//动态新增表格
				var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"' is_added='false'>";
				innerhtml += "<td width='4%'><input type='checkbox' name='addedseq' id='addedseq"+index+"'/>";
				innerhtml += "<input type='hidden' name='addeddevicemifsubid"+index+"' id='addeddevicemifsubid"+index+"' value='"+addedretObj[index].device_mif_subid+"'/></td>";
				
				innerhtml += "<td width='12%'><input name='addedteamname"+index+"' id='addedteamname"+index+"' value='"+addedretObj[index].team_name+"' style='line-height:18px;width:98%' size='10' type='text' readonly/>";
				innerhtml += "<input name='addedteam"+index+"' id='addedteam"+index+"' value='"+addedretObj[index].team+"' type='hidden' /></td>";
				innerhtml += "<td width='12%'><input name='addeddevicename"+index+"' id='addeddevicename"+index+"' idindex='"+index+"' value='"+addedretObj[index].device_name+"' style='line-height:18px;width:98%' size='10' type='text' /></td>";
				innerhtml += "<td width='12%'><input name='addeddevicetype"+index+"' id='addeddevicetype"+index+"' value='"+addedretObj[index].device_model+"' style='line-height:18px;width:98%' size='10' type='text' /></td>";
				innerhtml += "<td width='10%'><input name='addedunit"+index+"' id='addedunit"+index+"' value='"+addedretObj[index].unit_name+"' style='line-height:18px;width:98%' size='8' type='text' /></td>";
				innerhtml += "<td width='10%'><input name='addedassignnum"+index+"' id='addedassignnum"+index+"' style='line-height:18px;width:98%' value='"+addedretObj[index].mix_num+"' type='text' size='8' onkeyup='checkaddedNum(this)'/></td>";
				innerhtml += "<td width='10%'><input name='addedremark"+index+"' id='addedremark"+index+"' value='"+addedretObj[index].devremark+"' style='line-height:18px;width:98%' size='10' type='text' /></td>";
				innerhtml += "</tr>";
		
				$("#addeddetailtable").append(innerhtml);
			}
			$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
			$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
			$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
			$("#addeddetailtable>tr:even>td:even").addClass("even_even");
		}
	}
	function checkAssignNum(obj){
		var index = obj.detindex;
		var mixednum = parseInt($("#checkmixednum"+index).val(),10)
		var totalnumVal = parseInt($("#totalnum"+index).val(),10);
		var applynum = parseInt($("#applynum"+index).val(),10);
		if(obj.value == ''){
			return;
		}
		var objValue = obj.value;
		var re = /^\+?[1-9][0-9]*$/;
		if(objValue=="")
			return;
		if(!re.test(objValue)){
			alert("调配数量必须为数字!");
			obj.value = "";
        	return false;
		}else{
			if($("#unusenum"+index).val() == ''){
				alert("没有对应台账信息或者闲置数量为空!");
				obj.value = "";
				return;
			}
			if(parseInt(objValue,10)>totalnumVal){
				alert("调配数量必须小于等于总数量!");
				obj.value = "";
				return false;
			}else if(parseInt(objValue,10)>applynum){
				alert("调配数量必须小于等于申请数量!");
				obj.value = "";
				return false;
			}else if((parseInt(objValue,10)+mixednum)>applynum){
				alert("调配数量必须小于等于未调配数量!");
				obj.value = "";
				return false;
			}
		}
	}
</script>
</html>

