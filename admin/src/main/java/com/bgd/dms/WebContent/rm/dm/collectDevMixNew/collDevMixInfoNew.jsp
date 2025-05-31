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
<title>按量设备调配单添加界面</title>
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
          <td class="inquire_item4" ><font color=red>*</font>&nbsp;转出单位:</td>
          <td class="inquire_form4" >
          	 <input name="out_org_name" id="out_org_name" class="input_width" type="text"  value="" readonly/>
          	<img id="show-btn" src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" 
          	     style="cursor:hand;" onclick="showOrgTreePage('out_org')" />
          	<input name="out_org_id" id="out_org_id" class="input_width" type="hidden"  value="" />

          </td>
          </tr>
      </table>
      </fieldset>
	  <fieldset style="margin-left:2px"><legend>调配明细</legend>
		  <div style="overflow:auto">
			  <table style="width:99.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" >选择</td>
					<td class="bt_info_even" >班组</td>
					<td class="bt_info_odd" >设备名称</td>
					<td class="bt_info_even" >规格型号</td>
					<td class="bt_info_odd" >更换型号</td>
					<td class="bt_info_even" >计量单位</td>
					<td class="bt_info_odd">申请数量</td>
					<td class="bt_info_even" >已调配数量</td>
					<td class="bt_info_even" >闲置数量</td>
					<td class="bt_info_odd" >调配数量</td>
					<td class="bt_info_even" >备注</td>
				</tr>
			   	 	<tbody id="processtable" name="processtable">
			    	</tbody>
			    		      </table>
	       </div>
      </fieldset>
      <fieldset style="margin-left:2px"><legend>附属设备</legend>
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
						<td class="bt_info_odd" width="4%">选择</td>
						<td class="bt_info_even" width="9%">班组</td>
						<td class="bt_info_odd" width="9%">设备名称</td>
						<td class="bt_info_even" width="9%">规格型号</td>
						<td class="bt_info_odd" width="7%">计量单位</td>
						<td class="bt_info_even" width="7%">申请数量</td>
						<td class="bt_info_even" width="7%">已调配数量</td>
						<td class="bt_info_odd" width="7%">调配数量</td>
						<td class="bt_info_even" width="10%">备注</td>
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
     	<!-- <span class="bc_btn"><a href="#" onclick="submitInfo(0)"></a></span> -->
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
var oprstate_tmp="<%=oprstate%>";
	(function($){
		$.fn.disableLineInput = function(){
			$("input[type='text']",$(this)).attr("disabled","disabled");
		};
		$.fn.enableLineInput = function(){
			$("input[type='text']",$(this)).removeAttr("disabled");
		};
	})(jQuery)
	$().ready(function(){
		$("#alldetinfo").change(function(){
			var checkvalue = this.checked;
			$("input[type='checkbox'][name^='addedseq']").attr('checked',checkvalue);
		});
		//已关闭的调配申请单屏蔽提交按钮
	    if(oprstate_tmp == '4'){
	    	$(".tj_btn").hide();      
	    }
	});
	
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
		//补充明细的seq信息
		var addedcount=0;
		var addedline_info;
		$("input[type='checkbox'][name='addedseq']").each(function(){
			if(this.checked == true){
				if(addedcount == 0){
					addedline_info = this.id;
				}else{
					addedline_info += "~"+this.id;
				}
				addedcount++;
			}
		});
		if(count == 0 && addedcount == 0){
			alert('请选择调配单明细信息！');
			return;
		}
		if(count != 0){
			var selectedlines = line_infos.split("~");
			var wronglineinfos = "";
			var outlineinfos = "";
			var wrongcount = 0;
			var bigcount = 0;
			for(var index=0;index<selectedlines.length;index++){
				var valueinfo = $("#mixnum"+selectedlines[index]).val();
				var unuseinfo = $("#unusenum"+selectedlines[index]).val();
				if(valueinfo == ""){
					if(wrongcount == 0){
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
			if(outlineinfos!=""){
				//var showinfo = "第"+outlineinfos+"行明细的调配数量大于闲置数量，是否继续?";
				//if(!confirm(showinfo)){
				//	return;
				//}
				alert("第"+outlineinfos+"行明细的调配数量大于库存数量!");
				return;
			}
		}
		//添加的明细信息必须有名称和数量
		var addedwrongflag = false;
		$("input[type='text'][name^='addeddevicename']").each(function(){
			var devicenameinfo  = this.value;
			var index = this.idindex ;
			//var assignnuminfo = document.getElementById("addedassignnum"+index);
			var addedmixnuminfo = document.getElementById("addedmixnum"+index);
			
			if(devicenameinfo==""||addedmixnuminfo==""){
				addedwrongflag = true;
			}
		})
		if(addedwrongflag){
			alert("调配明细信息的名称和数量不为空,请完善补充调配明细信息!");
			return;
		}

		if(addedcount != 0){
			var selectedAddedlines = addedline_info.split("~");
			var wrongaddedlineinfos = "";
			var wrongaddedcount = 0;
			for(var index=0;index<selectedAddedlines.length;index++){
				var valueaddedinfo = $("#addedmixnum"+selectedAddedlines[index]).val();
				if(valueaddedinfo == ""){
					if(wrongaddedcount == 0){
						wrongaddedlineinfos += (parseInt(selectedAddedlines[index])+1);
					}else{
						wrongaddedlineinfos += ","+(parseInt(selectedAddedlines[index])+1);
					}
				}
			}
			if(wrongaddedlineinfos!=""){
				alert("请填写所选行补充明细的调配数量!");
				return;
			}
		}
		//如果数量大于闲置数量，那么给出相关提示
		var detailcount = $("input[type='hidden'][name^='deviceid']","#detailtable").size();
		//return;
		//给调配单号设置成空
		$("#mixinfo_no").val("");
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveEQBatchMixFormDetailInfo.srq?state="+state+"&count="+count+"&line_infos="+line_infos+"&idinfos="+idinfos+"&detailcount="+detailcount+"&addedcount="+addedcount+"&addedline_info="+addedline_info;
		if(state==9 && window.confirm("提交以后数据不可修改,是否提交?")){
			document.getElementById("form1").submit();
		}else if(state==0){
			document.getElementById("form1").submit();
		}
	}
	function showOwingTreePage(str){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
		var strs= new Array(); //定义一数组
		if(!returnValue){
			return;
		}
		strs=returnValue.split("~"); //字符分割
		//alert(strs);
		var names = strs[0].split(":");
		document.getElementById(str+"_name").value = names[1];
		
		var orgId = strs[1].split(":");
		var orgidvalue = orgId[1];
		//alert(orgidvalue);
		document.getElementById(str+"_id").value = orgidvalue;
	}
	function showOrgTreePage(str){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
		var strs= new Array(); //定义一数组
		if(!returnValue){
			return;
		}
		strs=returnValue.split("~"); //字符分割
		//alert(strs);
		var names = strs[0].split(":");
		document.getElementById(str+"_name").value = names[1];
		
		var orgId = strs[1].split(":");
		var orgidvalue = orgId[1];
		//alert(orgidvalue);
		document.getElementById(str+"_id").value = orgidvalue;
		fillAppDetailNouseNum(orgidvalue);
	}
	function fillAppDetailNouseNum(orgidvalue){
		//给所有的unusenum设置为空
		$("input[type='text'][name^='unusenum']","#processtable").val("");
		//alert("owingOrgId == "+owingOrgId);
		var mainsql = "select usage_org_id,device_id,teach.good_num as  unuse_num from gms_device_coll_account account   left join gms_device_coll_account_tech teach on teach.dev_acc_id=account.dev_acc_id";
			mainsql += " where account.usage_org_id='"+orgidvalue+"'  and account.bsflag='0' and (account.ifcountry !='国外' or account.ifcountry is null) and ";
			//mainsql += "where account.usage_sub_id like '%"+orgidvalue+"%'  and account.bsflag='0' and account.ifcountry !='国外' and ";
			mainsql += "account.device_id in ";
 			mainsql += "(select device_id from gms_device_app_colldetsub sub ";
			mainsql += " join gms_device_app_colldetail detail ";
			mainsql += "on sub.device_app_detid=detail.device_app_detid ";
			mainsql += " where nvl(sub.device_num, 0) > 0 and detail.device_app_id='<%=devappid%>')";
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
				if(parseInt(tmpval)>0){
				$("input:checkbox[name^='detinfo'][id="+i+"]").removeAttr("disabled");
				$("input:checkbox[name^='detinfo'][id="+i+"]").attr("checked","checked");
				$(this).enableLineInput();
				}
				else{
					$("input:checkbox[name^='detinfo'][id="+i+"]").attr("disabled","disabled");
					$("input:checkbox[name^='detinfo'][id="+i+"]").removeAttr("checked");
					$(this).disableLineInput();
					}
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
		var innerhtml = "<tr id='traddedseq"+addedseqinfo+"' name='traddedseq"+addedseqinfo+"' seq='"+addedseqinfo+"' is_added='false'>";
		//innerhtml += "<td width='4%'><input type='checkbox' name='detinfo' id='"+addedseqinfo+"'/></td>";
		innerhtml += "<td width='4%'><input type='checkbox' name='addedseq' id='"+addedseqinfo+"'/></td>";
		innerhtml += "<td width='9%'><input name='addedteamname"+addedseqinfo+"' id='addedteamname"+addedseqinfo+"' value='"+teamname+"' style='line-height:18px;width:98%' size='10' type='text' readonly/>";
		innerhtml += "<input name='addedteam"+addedseqinfo+"' id='addedteam"+addedseqinfo+"' value='"+team+"' type='hidden' /></td>";
		innerhtml += "<td width='9%'><input name='addeddevicename"+addedseqinfo+"' id='addeddevicename"+addedseqinfo+"' idindex='"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='10' type='text' /></td>";
		innerhtml += "<td width='9%'><input name='addeddevicetype"+addedseqinfo+"' id='addeddevicetype"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='10' type='text' /></td>";
		innerhtml += "<td width='7%'><input name='addedunit"+addedseqinfo+"' id='addedunit"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='8' type='text' /></td>";
		innerhtml += "<td width='7%'><input name='addedassignnum"+addedseqinfo+"' id='addedassignnum"+addedseqinfo+"' style='line-height:18px;width:98%' type='text' size='8' value='0' readonly/></td>";
		innerhtml += "<td width='7%'><input name='addedmixednum"+addedseqinfo+"' id='addedmixednum"+addedseqinfo+"' style='line-height:18px;width:98%' type='text' size='8' value='0' readonly/></td>";
		innerhtml += "<td width='7%'><input name='addedmixnum"+addedseqinfo+"' id='addedmixnum"+addedseqinfo+"' addedindex='"+addedseqinfo+"' style='line-height:18px;width:98%' type='text' size='8' value=''/></td>";
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
				var index = this.id;
				$("#traddedseq"+index).remove();
			}
		});
		$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
		$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
		$("#addeddetailtable>tr:even>td:even").addClass("even_even");
	}
	function refreshData(){
		var mainObj;
		var retObj;
		var devObj;
		var basedatas;
		if('<%=devappid%>'!=null){
			//回填基本信息
			var mainsql = "select coll.device_app_detid,devapp.device_app_no,devapp.project_info_no,devapp.app_org_id as in_org_id,"
						 + "devapp.appdate,tp.project_name,inorg.org_abbreviation as in_org_name "
						 + "from gms_device_collapp devapp "
						 + "left join gms_device_app_colldetail coll on devapp.device_app_id = coll.device_app_id and coll.bsflag = '0' "
						 + "left join gp_task_project tp on devapp.project_info_no=tp.project_info_no "
						 + "left join comm_org_information inorg on devapp.app_org_id=inorg.org_id and inorg.bsflag = '0' "
						 + "where devapp.device_app_id='<%=devappid%>' ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+mainsql);
				mainObj = proqueryRet.datas;
			if(mainObj!=undefined && mainObj.length>0){
				$("#project_name").val(mainObj[0].project_name);
				$("#project_info_no").val(mainObj[0].project_info_no);
				$("#appinfo_no").val(mainObj[0].device_app_no);
				$("#app_date").val(mainObj[0].appdate);
				$("#in_org_name").val(mainObj[0].in_org_name);
				$("#in_org_id").val(mainObj[0].in_org_id);
				$("#opr_state").val(mainObj[0].opr_state);
			}
			//回填明细信息
			var prosql = "select cms.device_app_detid,cms.device_detsubid,cms.device_id,cms.device_name,cms.device_model,cms.device_num as applynum,";
				prosql += "nvl(temp.mixednum,0) mixednum,cms.unit_id,unitsd.coding_name as unit_name,";
				prosql += "cd.team,teamsd.coding_name as team_name ";
				prosql += "from gms_device_app_colldetsub cms ";
				prosql += "left join (select device_detsubid,sum(mix_num) as mixednum from gms_device_coll_mixsub mixsub,gms_device_collmix_form collform ";
				prosql += "where collform.device_mixinfo_id=mixsub.device_mixinfo_id and collform.bsflag='0' ";
				prosql += "group by device_detsubid) temp on temp.device_detsubid=cms.device_detsubid ";
				prosql += "left join gms_device_app_colldetail cd on cms.device_app_detid = cd.device_app_detid ";
				prosql += "left join comm_coding_sort_detail unitsd on unitsd.coding_code_id=cms.unit_id ";
				prosql += "left join comm_coding_sort_detail teamsd on teamsd.coding_code_id=cd.team ";
				prosql += "where  cd.device_app_id='<%=devappid%>' and cd.bsflag='0' and nvl(cms.device_num,0)>0 ";
				prosql += "order by cms.device_id ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
			retObj = proqueryRet.datas;
			//回填附属设备信息
			var devsql = "select mix.device_mif_subid,mix.device_name,mix.device_model,nvl(mix.device_slot_num, 0) as device_slot_num,nvl(mix.device_num, 0) as device_num,"
						+ "nvl(mix.mix_num, 0) as mix_num,tail.coding_name as unit_name,mix.team,mix.devremark,d.coding_name from gms_device_coll_mixsubadd mix "
						+ "left join comm_coding_sort_detail tail on mix.unit_name = tail.coding_code_id left join comm_coding_sort_detail d on mix.team=d.coding_code_id "
						+ "where mix.device_mixinfo_id='"+mainObj[0].device_app_detid+"' and nvl(mix.device_num, 0)>0 ";
			var devqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devsql);
			devObj = devqueryRet.datas;
		}
		if(retObj!=undefined){
			for(var index=0;index<retObj.length;index++){
				//动态新增表格
				var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
				innerhtml += "<td><input type='checkbox' name='detinfo' id='"+index+"' value='"+retObj[index].device_detsubid+"' /></td>";
				innerhtml += "<td><input name='teamname"+index+"' id='teamname"+index+"' style='line-height:15px' value='"+retObj[index].team_name+"' size='8' type='text' readonly/>";
				innerhtml += "<input name='team"+index+"' id='team"+index+"' style='line-height:15px' value='"+retObj[index].team+"' type='hidden' /></td>";
				innerhtml += "<td><input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='"+retObj[index].device_name+"' size='12' type='text' readonly/>";
				innerhtml += "<input name='deviceid"+index+"' id='deviceid"+index+"' style='line-height:15px' value='"+retObj[index].device_id+"' type='hidden' /></td>";
				innerhtml += "<td><input name='devicemodel"+index+"' id='devicemodel"+index+"' value='"+retObj[index].device_model+"' size='12' type='text' readonly/></td>";
				innerhtml += "<td><input name='devicemodelnew"+index+"' id='devicemodelnew"+index+"' value='' size='12' type='text' readonly/>";
				innerhtml += "<input name='deviceidnew"+index+"' id='deviceidnew"+index+"' style='line-height:15px' value='"+retObj[index].device_id+"' type='hidden' />";
				innerhtml += "<input style='line-height:15px' value='...' size='12' type='button' onclick='showDevCodePage("+index+")' /></td>";
				innerhtml += "<td><input name='unitname"+index+"' id='unitname"+index+"' value='"+retObj[index].unit_name+"' size='8' type='text' readonly/>";
				innerhtml += "<input name='unitid"+index+"' id='unitid"+index+"' value='"+retObj[index].unit_id+"' type='hidden' /></td>";
				innerhtml += "<td><input name='applynum"+index+"' id='applynum"+index+"' style='line-height:15px' value='"+retObj[index].applynum+"' size='8' type='text' /></td>";
				innerhtml += "<td><input name='mixednum"+index+"' id='mixednum"+index+"' value='"+retObj[index].mixednum+"' size='8'  type='text' readonly/></td>";
				innerhtml += "<td><input name='unusenum"+index+"' id='unusenum"+index+"' value='' size='7' type='text' readonly/></td>";
				innerhtml += "<td><input name='mixnum"+index+"' id='mixnum"+index+"' value='' size='7' type='text' detindex='"+index+"' onkeyup='checkAssignNum(this)'></td>";
				innerhtml += "<td><input name='devremark"+index+"' id='devremark"+index+"' value='' size='10' type='text' /></td>";
				innerhtml += "</tr>";
				$("#processtable").append(innerhtml);
			}
			$("#processtable>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable>tr:odd>td:even").addClass("odd_even");
			$("#processtable>tr:even>td:odd").addClass("even_odd");
			$("#processtable>tr:even>td:even").addClass("even_even");
		}
		if(devObj!=undefined){
			for(var index=0;index<devObj.length;index++){
				var innerhtml = "<tr id='traddedseq"+index+"' name='traddedseq"+index+"' seq='"+index+"' is_added='false'>";
				innerhtml += "<td width='4%' align='center'><input type='checkbox' name='addedseq' id='"+index+"' checked/>";
				innerhtml += "<input name='addedmifsubid"+index+"' id='addedmifsubid"+index+"' value='"+devObj[index].device_mif_subid+"' type='hidden' /></td>";
				innerhtml += "<td width='9%'><input name='addedteamname"+index+"' id='addedteamname"+index+"' value='"+devObj[index].coding_name+"' style='line-height:18px;width:98%' size='10' type='text' readonly/>";
				innerhtml += "<input name='addedteam"+index+"' id='addedteam"+index+"' value='"+devObj[index].team+"' type='hidden' /></td>";
				innerhtml += "<td width='9%'><input name='addeddevicename"+index+"' id='addeddevicename"+index+"' idindex='"+index+"' value='"+devObj[index].device_name+"' style='line-height:18px;width:98%' size='10' type='text' /></td>";
				innerhtml += "<td width='9%'><input name='addeddevicetype"+index+"' id='addeddevicetype"+index+"' value='"+devObj[index].device_model+"' style='line-height:18px;width:98%' size='10' type='text' /></td>";
				innerhtml += "<td width='7%'><input name='addedunit"+index+"' id='addedunit"+index+"' value='"+devObj[index].unit_name+"' style='line-height:18px;width:98%' size='8' type='text' /></td>";
				innerhtml += "<td width='7%'><input name='addedassignnum"+index+"' id='addedassignnum"+index+"' style='line-height:18px;width:98%' type='text' size='8' value='"+devObj[index].device_num+"' readonly/></td>";
				innerhtml += "<td width='7%'><input name='addedmixednum"+index+"' id='addedmixednum"+index+"' style='line-height:18px;width:98%' type='text' size='8' value='"+devObj[index].mix_num+"' readonly/></td>";
				innerhtml += "<td width='7%'><input name='addedmixnum"+index+"' id='addedmixnum"+index+"' addedindex='"+index+"' style='line-height:18px;width:98%' type='text' size='8' onkeyup='checkaddedNum(this)' value=''/></td>";
				innerhtml += "<td width='10%'><input name='addedremark"+index+"' id='addedremark"+index+"' value='"+devObj[index].devremark+"' style='line-height:18px;width:98%' size='10' type='text' /></td>";
				innerhtml += "</tr>";
				$("#addeddetailtable").append(innerhtml);
				addedseqinfo++;
			}
			$("#processtable>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable>tr:odd>td:even").addClass("odd_even");
			$("#processtable>tr:even>td:odd").addClass("even_odd");
			$("#processtable>tr:even>td:even").addClass("even_even");
		}
	}

	function showDevCodePage(lineobj){
		var outOrgId = document.getElementById("out_org_id").value;
		var mixed_num = $("#mixednum"+lineobj).val();

		//if(mixed_num != '0'){
		//	alert("调配中的设备不能更改！");
		//	return;
		//}
		
		if(outOrgId == ''){
			alert("请首先选择“转出单位”！");
			return;
		}
		//alert("==== "+$("#deviceid"+lineobj).val());
		var obj = new Object();
		var data=window.showModalDialog("<%=contextPath%>/rm/dm/collectTree/collectTreeManager.jsp?ctxmenu=false&inline=true",obj,"dialogWidth=300px;dialogHeight=400px");
		if(data!=undefined){
			$("#devicename"+lineobj).val(data.dev_name);
			$("#devicemodelnew"+lineobj).val(data.dev_model);
			$("#deviceidnew"+lineobj).val(data.device_id);
			$("#devslotnum"+lineobj).val(data.dev_slot_num);

			//alert("==== "+$("#deviceidnew"+lineobj).val());
				
			var devsql = "select usage_org_id,device_id,teach.good_num as unuse_num from gms_device_coll_account account   left join gms_device_coll_account_tech teach on teach.dev_acc_id=account.dev_acc_id";
				devsql += "where account.usage_org_id='"+outOrgId+"' and account.bsflag='0' and account.ifcountry !='国外' and ";
				devsql += "account.device_id = '"+data.device_id+"' ";
			
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devsql);
				retObj = proqueryRet.datas;
			if(retObj!=undefined && retObj.length>0){
				var maxline =  $("#processtable>tr").size();
				for(var index=0;index<retObj.length&&index<maxline;index++){
					$("input:checkbox[name^='detinfo'][id="+lineobj+"]").removeAttr("disabled");
					$("input:checkbox[name^='detinfo'][id="+lineobj+"]").attr("checked","checked");
					$("#unusenum"+lineobj,"#processtable").val(retObj[index].unuse_num);
					//$("#processtable>tr").enableLineInput();
					$("#tr"+lineobj).enableLineInput();
				}
			}else{
				var maxline = $("#processtable>tr").size();
				for(var j = 0;j<maxline;j++){
					$("input:checkbox[name^='detinfo'][id="+lineobj+"]").attr("disabled","disabled");
					$("input:checkbox[name^='detinfo'][id="+lineobj+"]").removeAttr("checked");
					$("#unusenum"+lineobj,"#processtable").val('');
					$("#tr"+lineobj).disableLineInput();
				}
			}		
		}
	}
	
	function checkAssignNum(obj){
		var index = obj.detindex;
		var mixednum = parseInt($("#mixednum"+index).val(),10)
		var unusenum = parseInt($("#unusenum"+index).val(),10);
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
			if(unusenum<(parseInt(objValue,10))){
				alert("闲置必须大于等于调配的数量!");
				obj.value = "";
				return;
			}
			if(unusenum<parseInt(objValue,10)){
				alert("闲置数量必须大于调配数量!");
				obj.value = "";
				return;
			}
			 if(parseInt(objValue,10)>applynum){
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
	function checkaddedNum(obj){
		var index = obj.addedindex;
		var addedmixednum = parseInt($("#addedmixednum"+index).val(),10);//已调配数量
		var addedassignnum = parseInt($("#addedassignnum"+index).val(),10);//申请数量
		var addedmixnum = parseInt($("#addedmixnum"+index).val(),10);//本次调配数量
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
			if(parseInt(objValue,10)>addedassignnum){
				alert("调配数量必须小于等于申请数量!");
				obj.value = "";
				return false;
			}else if((parseInt(objValue,10)+addedmixednum)>addedassignnum){
				alert("调配数量必须小于等于未调配数量!");
				obj.value = "";
				return false;
			}
		}		
	}
</script>
</html>

