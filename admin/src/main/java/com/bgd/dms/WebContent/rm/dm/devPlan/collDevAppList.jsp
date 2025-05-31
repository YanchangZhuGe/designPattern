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
<title>按量设备调配单添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%;">
  <div id="new_table_box_content" style="width:100%;">
    <div id="new_table_box_bg" style="width:95%;">
      <fieldset style="margin-left:2px"><legend >基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text"  value="" readonly/>
          	<input name="project_info_no" id="project_info_no" class="input_width" type="hidden"  value="" />
          	<input name="deviceappid" id="deviceappid" type="hidden" value="<%=devappid%>" />
          </td>
           <td class="inquire_item4" >调配申请单号:</td>
          <td class="inquire_form4" >
          	<input name="appinfo_no" id="appinfo_no" class="input_width" type="text"  value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >申请人:</td>
          <td class="inquire_form4" >
          	<input name="appinfo_no" id="appinfo_no" class="input_width" type="text"  value="<%=user.getUserName() %>" readonly/>
          </td>
          <td class="inquire_item4" >申请单位名称:</td>
          <td class="inquire_form4" >
          	<input name="app_org" id="app_org" class="input_width" type="text"  value="<%=user.getOrgName() %>" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >申请时间:</td>
          <td class="inquire_form4" >
          	<input name="app_date" id="app_date" class="input_width" type="text"  value="" readonly/>
          </td>
         </tr> 
      </table>
      </fieldset>
	  <fieldset style="margin-left:2px"><legend>调配明细</legend>
		  <div style="overflow:auto">
			  <table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" width="4%">序号</td>
					<td class="bt_info_even" width="9%">班组</td>
					<td class="bt_info_odd" width="14%">设备名称</td>
					<td class="bt_info_even" width="14%">规格型号</td>
					<td class="bt_info_even" width="9%">计量单位</td>
					<td class="bt_info_odd" width="9%">申请数量</td>
					<td class="bt_info_even" width="14%">备注</td>
				</tr>
			   <tbody id="processtable" name="processtable" >
			   </tbody>
		      </table>
	       </div>
      </fieldset>
      <fieldset style="margin-left:2px"><legend>附属设备</legend>
		  <div id="tab_box" class="tab_box" style="height:120px;overflow:auto;">
				<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			       <tr>
						<td class="bt_info_odd" width="4%">序号</td>
						<td class="bt_info_even" width="9%">班组</td>
						<td class="bt_info_odd" width="9%">设备名称</td>
						<td class="bt_info_even" width="9%">规格型号</td>
						<td class="bt_info_odd" width="7%">计量单位</td>
						<td class="bt_info_even" width="7%">申请数量</td>
						<td class="bt_info_even" width="7%">已调配数量</td>
						<td class="bt_info_odd" width="7%">调配数量</td>
						<td class="bt_info_even" width="10%">备注</td>
					</tr>
					<tbody id="addeddetailtable" name="addeddetailtable" >
			   		</tbody>
				</table>
			</div>
       </fieldset>
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

	function refreshData(){
		var retObj;
		var devObj;
		var basedatas;
		if('<%=devappid%>'!=null){
			//回填基本信息
			var mainsql = "select devapp.device_app_no,devapp.project_info_no,devapp.app_org_id as in_org_id,";
			mainsql += "devapp.appdate,tp.project_name,inorg.org_abbreviation as in_org_name ";
			mainsql += "from gms_device_collapp devapp ";
			mainsql += "left join gp_task_project tp on devapp.project_info_no=tp.project_info_no ";
			mainsql += "left join comm_org_information inorg on devapp.app_org_id=inorg.org_id ";
			mainsql += "where devapp.device_app_id='8ad891104858fd58014858fe62810003' ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+mainsql);
			retObj = proqueryRet.datas;
			if(retObj!=undefined && retObj.length>0){
				$("#project_name").val(retObj[0].project_name);
				$("#project_info_no").val(retObj[0].project_info_no);
				$("#appinfo_no").val(retObj[0].device_app_no);
				$("#app_date").val(retObj[0].appdate);
				$("#in_org_name").val(retObj[0].in_org_name);
				$("#in_org_id").val(retObj[0].in_org_id);
				$("#opr_state").val(retObj[0].opr_state);
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
				prosql += "where  cd.device_app_id='8ad891104858fd58014858fe62810003' and cd.bsflag='0' and nvl(cms.device_num,0)>0 ";
				prosql += "order by cms.device_id ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
			retObj = proqueryRet.datas;
			//回填附属设备信息
			var devsql = "select mix.device_mif_subid,mix.device_name,mix.device_model,nvl(mix.device_slot_num, 0) as device_slot_num,nvl(mix.device_num, 0) as device_num,";
				devsql += "nvl(mix.mix_num, 0) as mix_num,tail.coding_name as unit_name,mix.team,mix.devremark,d.coding_name from gms_device_coll_mixsubadd mix ";
				devsql += "left join comm_coding_sort_detail tail on mix.unit_name = tail.coding_code_id left join comm_coding_sort_detail d on mix.team=d.coding_code_id where mix.device_mixinfo_id='"+retObj[0].device_app_detid+"' and nvl(mix.device_num, 0)>0 ";
			var devqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devsql);
			devObj = devqueryRet.datas;
		}
		if(retObj!=undefined){
			for(var index=0;index<retObj.length;index++){
				//动态新增表格
				var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
				innerhtml += "<td>"+(index+1)+"</td>";
				innerhtml += "<td><input name='teamname"+index+"' id='teamname"+index+"' style='line-height:15px' value='"+retObj[index].team_name+"'  type='text' readonly/>";
				innerhtml += "<input name='team"+index+"' id='team"+index+"' style='line-height:15px' value='"+retObj[index].team+"' type='hidden' /></td>";
				innerhtml += "<td><input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='"+retObj[index].device_name+"'  type='text' readonly/>";
				innerhtml += "<input name='deviceid"+index+"' id='deviceid"+index+"' style='line-height:15px' value='"+retObj[index].device_id+"' type='hidden' /></td>";				
				innerhtml += "<td><input name='devicemodel"+index+"' id='devicemodel"+index+"' value='"+retObj[index].device_model+"'  type='text' readonly/></td>";				
				innerhtml += "<td><input name='unitname"+index+"' id='unitname"+index+"' value='"+retObj[index].unit_name+"'  type='text' readonly/>";
				innerhtml += "<input name='unitid"+index+"' id='unitid"+index+"' value='"+retObj[index].unit_id+"' type='hidden' /></td>";				
				innerhtml += "<td><input name='applynum"+index+"' id='applynum"+index+"' style='line-height:15px' value='"+retObj[index].applynum+"'  type='text' /></td>";				
				innerhtml += "<td><input name='devremark"+index+"' id='devremark"+index+"' value=''  type='text' /></td>";				
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
				innerhtml += "<td width='4%' align='center'>"+(index+1)+"</td>";
				innerhtml += "<td width='9%'><input name='addedteamname"+index+"' id='addedteamname"+index+"' value='"+retObj[index].team_name+"' style='line-height:18px;width:98%' size='10' type='text' readonly/>";
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
			}
			$("#processtable>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable>tr:odd>td:even").addClass("odd_even");
			$("#processtable>tr:even>td:odd").addClass("even_odd");
			$("#processtable>tr:even>td:even").addClass("even_even");
		}
	}

	function showDevCodePage(lineobj){
		var owingOrgId = document.getElementById("owning_org_id").value;
		var outOrgId = document.getElementById("out_org_id").value;
		var mixed_num = $("#mixednum"+lineobj).val();

		//if(mixed_num != '0'){
		//	alert("调配中的设备不能更改！");
		//	return;
		//}
		
		if(owingOrgId == '' || outOrgId == ''){
			alert("请首先选择“转出单位”和“所在位置”！");
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
				
			var devsql = "select usage_org_id,device_id,total_num,unuse_num from gms_device_coll_account account ";
				devsql += "where account.usage_org_id='"+outOrgId+"' and account.owning_org_id='"+owingOrgId+"' and account.bsflag='0' and account.ifcountry !='国外' and ";
				devsql += "account.device_id = '"+data.device_id+"' ";
			
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devsql);
				retObj = proqueryRet.datas;
			if(retObj!=undefined && retObj.length>0){
				var maxline =  $("#processtable>tr").size();
				for(var index=0;index<retObj.length&&index<maxline;index++){
					$("input:checkbox[name^='detinfo'][id="+lineobj+"]").removeAttr("disabled");
					$("input:checkbox[name^='detinfo'][id="+lineobj+"]").attr("checked","checked");
					$("#totalnum"+lineobj,"#processtable").val(retObj[index].total_num);
					$("#unusenum"+lineobj,"#processtable").val(retObj[index].unuse_num);
					//$("#processtable>tr").enableLineInput();
					$("#tr"+lineobj).enableLineInput();
				}
			}else{
				var maxline = $("#processtable>tr").size();
				for(var j = 0;j<maxline;j++){
					$("input:checkbox[name^='detinfo'][id="+lineobj+"]").attr("disabled","disabled");
					$("input:checkbox[name^='detinfo'][id="+lineobj+"]").removeAttr("checked");
					$("#totalnum"+lineobj,"#processtable").val('');
					$("#unusenum"+lineobj,"#processtable").val('');
					$("#tr"+lineobj).disableLineInput();
				}
			}		
		}
	}
	
	function checkAssignNum(obj){
		var index = obj.detindex;
		var mixednum = parseInt($("#mixednum"+index).val(),10)
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
	function selectMultiPerson(){
		var teamInfo = {
		        fkValue:"",
		        value:""
		    };
		    window.showModalDialog('<%=contextPath%>/common/selectEmployeeMulti.jsp',teamInfo);
		    if(!teamInfo.fkValue && !teamInfo.value){
				return;
			}
		    document.getElementById("noticeUserId").value=teamInfo.fkValue;
		    document.getElementById("noticeUser").value=teamInfo.value;
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

