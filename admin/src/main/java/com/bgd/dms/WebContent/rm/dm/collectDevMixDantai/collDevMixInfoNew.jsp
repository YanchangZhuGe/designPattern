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
<div id="new_table_box">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend >基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >调配单号:</td>
          <td class="inquire_form4" >
          	<input name="mixinfo_no" id="mixinfo_no" class="input_width" type="text"  value="保存后自动生成..." readonly/>
          	<!-- <input name="mixInfoId" id="mixInfoId" class="input_width" type="hidden"  value="" /> -->
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
		  <div style="height:100px;overflow:auto">
			  <table style="width:100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" width="3%"><input type="checkbox" name="detinfo" id="detinfo" /></td>
					<td class="bt_info_even" width="10%">班组</td>
					<td class="bt_info_odd" width="10%">设备名称</td>
					<td class="bt_info_even" width="10%">规格型号</td>
					<!-- <td class="bt_info_odd" width="10%">更换型号</td> -->
					<td class="bt_info_odd" width="6%">单位</td>
					<td class="bt_info_even" width="7%">申请数量</td>
					<td class="bt_info_odd" width="7%">已调配数量</td>
					<td class="bt_info_even" width="7%">调配数量</td>
					<td class="bt_info_odd" width="11%">计划进场时间</td>
					<td class="bt_info_even" width="11%">计划离场时间</td>
					<td class="bt_info_odd" width="8%">调配备注</td>
				</tr>
		      </table>
		       <div style="height:150px;overflow:auto;">
					<table border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style='table-layout: auto'>
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
						<td class="bt_info_odd" width="4%"><input type="checkbox" name="addedseq" id="addedseq" /></td>
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
	$("#detinfo").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='detinfo']").attr('checked',checkvalue);
	});
	//已关闭的调配申请单屏蔽提交按钮
    if(oprstate_tmp == '4'){
    	$(".tj_btn").hide();      
    }
});
$().ready(function(){
	$("#addedseq").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='addedseq']").attr('checked',checkvalue);
	});
});
	function submitInfo(state){
		//给信息保存到数据库中，重写入库操作
		if($("#out_org_name").val()==''){
			alert("请选择转出单位!");
			return;
		}
		//然后校验是否给所有明细都填写
		var j=0;
		var fillAlldetailFlag = true;
		var notfillRowinfos = "";
		$("input[type='checkbox'][name='detinfo']").each(function(){
			if(this.checked == true){
				var index  = this.id;
				var mixnumval = $("#mixnum"+index).val();
				if(mixnumval == ""){
					if(j==0){
						notfillRowinfos = (index+1);
					}else{
						notfillRowinfos += "、"+(j+1);
					}
					fillAlldetailFlag = false;
					j++;
				}
			}
		})
		if(!fillAlldetailFlag){
			alert("请填写第"+notfillRowinfos+"行的调配明细信息!");
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
		//现在只保留的数量明细的行信息即可
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
		if(count == 0 && addedcount == 0){
			alert('请选择调配单明细信息！');
			return;
		}
		//给调配单号设置成空
		$("#mixinfo_no").val("");
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveEQMixFormAllInfo.srq?mixform_type=2&state="+state+"&count="+count+"&line_infos="+line_infos+"&idinfos="+idinfos+"&addedcount="+addedcount+"&addedline_info="+addedline_info;
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
	var addedseqinfo = 0;
	function toAddAddedDetailInfos(){
		//获得第一行的team信息
		var teamname = $("input[name^='team_name'][type='text']")[0].value;
		var team = $("input[name^='team'][type='hidden']")[0].value;
		addedseqinfo++;
		var innerhtml = "<tr id='tradded"+addedseqinfo+"' name='tr"+addedseqinfo+"' seq='"+addedseqinfo+"' is_added='false'>";
		innerhtml += "<td width='4%'><input type='checkbox' name='addedseq' id='addedseq"+addedseqinfo+"' checked/></td>";
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
		$("input[type='checkbox'][name='addedseq']").each(function(i){
			if(this.checked == true){
				var index = this.id.substr(8);
				$("#tradded"+index).remove();
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
			var str = "select devapp.device_app_id,devapp.device_app_no,devapp.project_info_no,devapp.app_org_id as in_org_id,"
			+"to_char(devapp.appdate,'yyyy-mm-dd') as appdate,tp.project_name,inorg.org_abbreviation as in_org_name,"
			+"devapp.mix_org_id,devapp.mix_type_id,devapp.mix_type_name,devapp.mix_user_id,dmf.device_mixinfo_id,dmf.out_org_id,outorg.org_abbreviation as out_org_name,dmf.mixinfo_no "
			+"from gms_device_app devapp   left join gms_device_mixinfo_form dmf on devapp.device_app_id = dmf.device_app_id and dmf.bsflag='0' left join comm_org_information outorg on dmf.out_org_id=outorg.org_id left join gp_task_project tp on devapp.project_info_no=tp.project_info_no "
			+"left join comm_org_information inorg on devapp.app_org_id=inorg.org_id "
			+"where devapp.device_app_id='<%=devappid%>' ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
			retObj = proqueryRet.datas;
			if(retObj!=undefined && retObj.length>0){
				$("#project_name").val(retObj[0].project_name);
				$("#project_info_no").val(retObj[0].project_info_no);
				$("#appinfo_no").val(retObj[0].device_app_no);
				$("#app_date").val(retObj[0].appdate);
				$("#in_org_name").val(retObj[0].in_org_name);
				$("#in_org_id").val(retObj[0].in_org_id);
				$("#mix_org_id").val(retObj[0].mix_org_id);
				$("#mix_type_id").val(retObj[0].mix_type_id);
				$("#mix_type_name").val(retObj[0].mix_type_name);
				$("#mix_user_id").val(retObj[0].mix_user_id);
				//$("#out_org_name").val(retObj[0].out_org_name);
				//$("#out_org_id").val(retObj[0].out_org_id);
				//$("#mixInfoId").val(retObj[0].device_mixinfo_id);
				//if(retObj[0].mixinfo_no !=""){
				//	$("#mixinfo_no").val(retObj[0].mixinfo_no);
				//	}
			}
			//回填明细信息
			var prosql = "select appdet.device_app_detid,appdet.team,appdet.apply_num,appdet.purpose,appdet.isdevicecode,";
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
				prosql += "order by appdet.dev_ci_code ";
				
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql+'&pageSize=10000');
			retObj = proqueryRet.datas;
		}
		if(retObj!=undefined){
			for(var index=0;index<retObj.length;index++){
				//动态新增表格
				var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
				innerhtml += "<td width='3%'><input type='checkbox' name='detinfo' id='"+index+"' value='"+retObj[index].device_app_detid+"' checked/></td>";
				innerhtml += "<td width='10%'><input name='team_name"+index+"' id='team_name"+index+"' style='line-height:15px' value='"+retObj[index].team_name+"' size='12' type='text' readonly/></td>";
				innerhtml += "<td width='10%'><input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='"+retObj[index].dev_ci_name+"' size='11' type='text' readonly/>";
				innerhtml += "<input name='devcicode"+index+"' id='devcicode"+index+"' value='"+retObj[index].dev_ci_code+"' type='hidden' />";
				innerhtml += "<input name='team"+index+"' id='team"+index+"' value='"+retObj[index].team+"' type='hidden' />";
				innerhtml += "<input name='teamid"+index+"' id='teamid"+index+"' value='"+retObj[index].teamid+"' type='hidden' />";
				innerhtml += "<input name='isdevicecode"+index+"' id='isdevicecode"+index+"' value='"+retObj[index].isdevicecode+"' type='hidden' /></td>";
				innerhtml += "<td width='10%'><input name='devicemodel"+index+"' id='devicemodel"+index+"' value='"+retObj[index].dev_ci_model+"' size='12' type='text' readonly/></td>";
				//innerhtml += "<td width='10%'><input name='devicemodelnew"+index+"' id='devicemodelnew"+index+"' value='' size='12' type='text' /></td>";
				innerhtml += "<td width='6%'><input name='unitname"+index+"' id='unitname"+index+"' value='"+retObj[index].unit_name+"' size='3' type='text' />";
				innerhtml += "<input name='unitinfo"+index+"' id='unitinfo"+index+"' value='"+retObj[index].unitinfo+"' type='hidden' /></td>";
				
				innerhtml += "<td width='7%'><input name='apply_num"+index+"' id='apply_num"+index+"' style='line-height:15px' value='"+retObj[index].apply_num+"' size='5' type='text' /></td>";
				innerhtml += "<td width='7%'><input name='mixednum"+index+"' id='mixednum"+index+"' value='"+retObj[index].mixed_num+"' size='5' type='text' readonly/></td>";
				innerhtml += "<td width='7%'><input name='mixnum"+index+"' id='mixnum"+index+"' detindex='"+index+"' value='' onkeyup='checkAssignNum(this)' size='5' type='text' /></td>";
				
				innerhtml += "<td width='11%'><input name='startdate"+index+"' id='startdate"+index+"' style='line-height:15px' value='"+retObj[index].plan_start_date+"' size='9' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(startdate"+index+",tributton2"+index+");'/></td>";
				innerhtml += "<td width='11%'><input name='enddate"+index+"' id='enddate"+index+"' style='line-height:15px' value='"+retObj[index].plan_end_date+"' size='9' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+index+",tributton3"+index+");'/></td>";
				
				innerhtml += "<td width='8%'><input name='devremark"+index+"' id='devremark"+index+"' value='' size='8'  type='text' /></td>";
				
				innerhtml += "</tr>";
				$("#processtable").append(innerhtml);
			}
			$("#processtable>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable>tr:odd>td:even").addClass("odd_even");
			$("#processtable>tr:even>td:odd").addClass("even_odd");
			$("#processtable>tr:even>td:even").addClass("even_even");
		}
	}
	function checkaddedNum(obj){
		var objValue = obj.value;
		var re = /^\+?[1-9][0-9]*$/;
		if(objValue=="")
			return;
		if(!re.test(objValue)){
			alert("调配数量必须为数字!");
			obj.value = "";
        	return false;
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
</script>
</html>

