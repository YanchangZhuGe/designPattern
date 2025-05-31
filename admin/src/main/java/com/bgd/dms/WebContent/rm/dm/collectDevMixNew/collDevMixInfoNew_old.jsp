<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath(); 
	String devappid = request.getParameter("devappid");
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
          <td class="inquire_item4" >转出单位:</td>
          <td class="inquire_form4" >
          	<input name="out_org_name" id="out_org_name" class="input_width" type="text"  value="" readonly/>
          	<img id="show-btn" src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" 
          	     style="cursor:hand;" onclick="showOrgTreePage('out_org')" />
          	<input name="out_org_id" id="out_org_id" class="input_width" type="hidden"  value="" />
          </td>
        </tr>
      </table>
      </fieldset>
      <fieldset style="margin-left:2px;width:98%"><legend>申请明细</legend>
		  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
		     <tr id='device_appdet_id_{device_app_detid}' name='device_app_detid'>
		     	<td class="bt_info_odd" >选择</td>
				<td class="bt_info_even">序号</td>
				<td class="bt_info_odd" >班组</td>
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
	 <table style="width:95%;" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td width="10%"><span class="jl"><a href="#" id="addbtn" onclick='toMixDetailInfos()' title="分配具体明细"></a></span></td>
          <td width="30%">
          <td id="selectmodeltd" width="50%" align="right" style="display:none">
          	<select id="selectmodel" name="selectmodel" class="select_width" style="width:180px">
          		<option value="">请选择模板...</option>
          	</select>&nbsp;&nbsp;&nbsp;&nbsp;
          </td>
          <td id="addtd" width="5%" align="right" style="display:none"><span class="zj"><a href="#" id="addbtn" onclick='toAddRowInfo()' title="新增"></a></span></td>
		  <td id="deltd" width="5%" align="right" style="display:none"><span class="sc"><a href="#" id="delbtn" onclick='toDelRowInfo()' title="删除"></a></span></td>
        </tr>
      </table>
	  <fieldset style="margin-left:2px"><legend>调配明细</legend>
		  <div style="overflow:auto">
			  <table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" width="4%">选择</td>
					<td class="bt_info_even" width="10%">设备名称</td>
					<td class="bt_info_odd" width="10%">规格型号</td>
					<td class="bt_info_even" width="9%">计量单位</td>
					<td class="bt_info_odd" width="9%">道数</td>
					<td class="bt_info_even" width="9%">申请数量</td>
					<td class="bt_info_odd" width="9%">总道数</td>
					<td class="bt_info_even" width="9%">已调配数量</td>
					<td class="bt_info_odd" width="9%">总数量</td>
					<td class="bt_info_even" width="9%">闲置数量</td>
					<td class="bt_info_odd" width="9%">调配数量</td>
					<td class="bt_info_even" width="14%">备注</td>
				</tr>
			   <tbody id="processtable" name="processtable" >
			   </tbody>
		      </table>
		      <div style="height:90px;overflow:auto;">
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
		$("input[type='checkbox'][name='idinfo']").each(function(){
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
		var appinfos;
		$("input[type='checkbox'][name='detinfo']").each(function(){
			if(this.checked){
				appinfos = this.value;
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
		//如果数量大于闲置数量，那么给出相关提示
		var detailcount = $("input[type='hidden'][name^='deviceid']","#detailtable").size();
		//给调配单号设置成空
		$("#mixinfo_no").val("");
		alert(count);
		alert(line_infos);
		alert(idinfos);
		alert(appinfos);
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveEQBatchMixFormDetailInfo.srq?state="+state+"&count="+count+"&line_infos="+line_infos+"&idinfos="+idinfos+"&detailcount="+detailcount+"&addedcount="+addedcount+"&addedline_info="+addedline_info+"&appinfos="+appinfos;
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
		var value = $("#selectmodel").val();
		$("input[type='text'][name^='unusenum']","#processtable").val("");
		
		var mainsql = "select usage_org_id,device_id,total_num,unuse_num from gms_device_coll_account account ";
			mainsql += "where account.usage_org_id='"+orgidvalue+"' and account.bsflag='0' and ";
			mainsql += "account.device_id in ";
 			mainsql += "(select device_id from gms_device_collmodel_sub sub ";
			mainsql += " where sub.model_mainid='"+value+"')";
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
						$("input:checkbox[name^='idinfo'][id="+j+"]").attr("disabled","disabled");
						$("input:checkbox[name^='idinfo'][id="+j+"]").removeAttr("checked");
					}else{
						//$("#tr"+j,"#processtable").enableLineInput();
						$("input:checkbox[name^='idinfo'][id="+j+"]").removeAttr("disabled");
						$("input:checkbox[name^='idinfo'][id="+j+"]").attr("checked","checked");
						$("#totalnum"+j,"#processtable").val(retObj[index].total_num);
						$("#unusenum"+j,"#processtable").val(retObj[index].unuse_num);
					}
				}
			}
		}else{
			var maxline = $("#processtable>tr").size();
			for(var j = 0;j<maxline;j++){
				//$("#tr"+j,"#processtable").disableLineInput();
				$("input:checkbox[name^='idinfo']").attr("disabled","disabled");
				$("input:checkbox[name^='idinfo']").removeAttr("checked");
			}
		}
		//给为空的都屏蔽了
		$("#processtable>tr").each(function(i){
			var tmpval = $("#unusenum"+i).val();
			if(tmpval!= '' && tmpval != null){
				$("input:checkbox[name^='idinfo'][id="+i+"]").removeAttr("disabled");
				$("input:checkbox[name^='idinfo'][id="+i+"]").attr("checked","checked");
				$(this).enableLineInput();
			}else{
				$("input:checkbox[name^='idinfo'][id="+i+"]").attr("disabled","disabled");
				$("input:checkbox[name^='idinfo'][id="+i+"]").removeAttr("checked");
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
				$("#tr"+index).remove();
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
			var mainsql = "select appdet.device_app_detid,appdet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, p6.name as jobname,pro.project_name,appdet.dev_name_input as dev_ci_name,devtype.coding_name as dev_ci_model,appdet.dev_codetype, appdet.apply_num,appdet.teamid,appdet.team,devapp.device_app_name, appdet.purpose,appdet.employee_id,emp.employee_name, appdet.plan_start_date,appdet.plan_end_date,devapp.device_app_no,devapp.appdate,i.org_abbreviation as in_org_name,devapp.app_org_id as in_org_id  from gms_device_app_colldetail appdet left join (gms_device_collapp devapp left join comm_org_information i on devapp.app_org_id = i.org_id and i.bsflag='0') on appdet.device_app_id = devapp.device_app_id left join bgp_p6_activity p6 on appdet.teamid = p6.object_id left join comm_coding_sort_detail devtype on appdet.dev_codetype = devtype.coding_code_id left join comm_coding_sort_detail teamsd on appdet.team = teamsd.coding_code_id left join comm_coding_sort_detail sd on appdet.unitinfo = sd.coding_code_id left join gp_task_project pro on appdet.project_info_no = pro.project_info_no left join comm_human_employee emp on appdet.employee_id = emp.employee_id";
			mainsql += " where devapp.device_app_id ='<%=devappid%>' and appdet.bsflag='0' and devapp.bsflag = '0'";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+mainsql);
			retObj = proqueryRet.datas;
			if(retObj && retObj.length>0){
				for(var index=0;index<retObj.length;index++){
					var device_app_detid = retObj[index].device_app_detid;
					var collseqinfo = retObj[index].seqinfo;
					var collproject_name = retObj[index].project_name;
					var collteamname = retObj[index].teamname;
					var collunitname = retObj[index].unitname;
					var colldev_ci_name = retObj[index].dev_ci_name;
					var colldev_ci_model = retObj[index].dev_ci_model;
					var collapply_num = retObj[index].apply_num;
					var collpurpose = retObj[index].purpose;
					var collstartdate = retObj[index].plan_start_date;
					var collenddate = retObj[index].plan_end_date;
					var devcodetype = retObj[index].dev_codetype;
					//动态新增表格
					var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
					innerhtml += "<td><input type='checkbox' name='detinfo' id='"+index+"' value='"+device_app_detid+"' devcodetype='"+devcodetype+"'/></td>";
					innerhtml += "<td>"+(index+1)+"<input name='colldevice_app_detid' id='colldevice_app_detid"+index+"' value='"+device_app_detid+"' type='hidden'/></td>";
					innerhtml += "<td><input name='collteamname"+index+"' id='collteamname"+index+"' style='line-height:15px' value='"+collteamname+"' size='8' type='text' readonly/></td>";
					innerhtml += "<td><input name='colldevicename"+index+"' id='colldevicename"+index+"' style='line-height:15px' value='"+colldev_ci_name+"' size='10' type='text' readonly/></td>";
					innerhtml += "<td><input id='colldevicetype"+index+"' name='colldevicetype"+index+"' value='"+colldev_ci_model+"' size='12'  type='text' readonly/></td>";
					innerhtml += "<td><input id='collunitname"+index+"' name='collunitname"+index+"' value='"+collunitname+"' size='3' type='text' readonly/></td>";
					innerhtml += "<td><input id='collapplynum"+index+"' name='collapplynum"+index+"' value='"+collapply_num+"' size='3' type='text' readonly/></td>";
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
			if(retObj!=undefined && retObj.length>0){
				$("#project_name").val(retObj[0].project_name);
				$("#project_info_no").val(retObj[0].project_info_no);
				$("#appinfo_no").val(retObj[0].device_app_no);
				$("#app_date").val(retObj[0].appdate);
				$("#in_org_name").val(retObj[0].in_org_name);
				$("#in_org_id").val(retObj[0].in_org_id);
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
	var seqinfo = 0;
	function toMixDetailInfos(){
		seqinfo++;
		var valueinfo ;
		$("input[type='checkbox'][name='detinfo']").each(function(){
			if(this.checked == true){
				valueinfo = this.value; 
			}
		});
		if(valueinfo == undefined)
			return;
			var showid ;
			var showmodeltype ;
			$("input[type='checkbox'][name='detinfo']").each(function(){
				if(this.checked == true){
					showid = this.id;
					showmodeltype = this.devcodetype;
				}
			});
			//模板归零
			var querySql = "select model_mainid,model_name ";
			querySql += "from gms_device_collmodel_main main ";
			querySql += "where main.bsflag='0' and model_type='"+showmodeltype+"'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
			if(basedatas!=undefined && basedatas.length>0){
				//回填基本信息
				for(var index=0;index<basedatas.length;index++){
					var innerhtml = "<option value='"+basedatas[index].model_mainid+"'>"+basedatas[index].model_name+"</option>";
					$("#selectmodel").append(innerhtml);
				}
			//给模板放进内容 end
			$("#selectmodel").val("");
			$("#selectmodeltd").show();
			$("#addtd").show();
			$("#deltd").show();
		}
	}
	$().ready(function(){
		$("#selectmodel").change(function(){
			var value = $("#selectmodel").val();
			if(value == ''){
				return;
			}
			//获得当前显示的填报明细，给重新复制
			//先查询模板的子记录
			var querySql = "select sub.device_id,sub.device_name,sub.device_model,sub.unit_id,";
			querySql += "detail.coding_name as unit_name,sub.device_slot_num ";
			querySql += "from gms_device_collmodel_sub sub ";
			querySql += "left join gms_device_collectinfo ci on sub.device_id=ci.device_id ";
			querySql += "left join gms_device_collmodel_main main on main.model_mainid=sub.model_mainid ";
			querySql += "left join comm_coding_sort_detail detail on sub.unit_id=detail.coding_code_id ";
			querySql += "where main.bsflag='0' and sub.model_mainid='"+value+"' order by ci.dev_code ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
			if(basedatas!=undefined && basedatas.length>0){
				$("#detailList").empty();
				var lineinfo;
				//回填基本信息
				for(var index=0;index<basedatas.length;index++){
					lineinfo = index;
					var innerhtml = "<tr id='tr"+lineinfo+"' name='tr"+lineinfo+"' seqinfo='"+lineinfo+"'>";
					innerhtml += "<td><input type='checkbox' name='idinfo' id='"+lineinfo+"' value='"+basedatas[index].device_id+"' checked='true' />";
					innerhtml += "<input type='hidden' id='deviceid"+lineinfo+"' name='deviceid"+lineinfo+"' value='"+basedatas[index].device_id+"'></td>";
					innerhtml += "<td><input name='devicename"+lineinfo+"' id='devicename"+lineinfo+"' style='line-height:15px' value='"+basedatas[index].device_name+"' size='10' type='text' readonly/></td>";
					innerhtml += "<td><input name='devicemodel"+lineinfo+"' id='devicemodel"+lineinfo+"' style='line-height:15px' value='"+basedatas[index].device_model+"' size='10' type='text' readonly/></td>";
					innerhtml += "<td><input name='unit_name"+lineinfo+"' id='unit_name"+lineinfo+"' style='line-height:15px' value='"+basedatas[index].unit_name+"' size='9' type='text' readonly/>";
					innerhtml += "<input name='unitList"+lineinfo+"' id='unitList"+lineinfo+"' value='"+basedatas[index].unit_id+"' type='hidden' /></td>";
					innerhtml += "<td><input name='devslotnum"+lineinfo+"' id='devslotnum"+lineinfo+"' style='line-height:15px' value='"+basedatas[index].device_slot_num+"' size='6' type='text' readonly/></td>";
					innerhtml += "<td><input name='apply_num"+lineinfo+"' id='apply_num"+lineinfo+"' checkinfo='"+lineinfo+"' style='line-height:15px' value='' size='10' type='text' onkeyup='checkInputNum(this)'/></td>";
					innerhtml += "<td><input name='totalslotnum"+lineinfo+"' id='totalslotnum"+lineinfo+"' style='line-height:15px' value='' size='10' type='text' readonly/></td>";
					innerhtml += "<td><input name='mixednum"+lineinfo+"' id='mixednum"+lineinfo+"' value='' size='8'  type='text' readonly/></td>";
					innerhtml += "<td><input name='totalnum"+lineinfo+"' id='totalnum"+lineinfo+"' value='' size='6' type='text' readonly/></td>";
					innerhtml += "<td><input name='unusenum"+lineinfo+"' id='unusenum"+lineinfo+"' value='' size='7' type='text' readonly/></td>";
					
					innerhtml += "<td><input name='mixnum"+lineinfo+"' id='mixnum"+lineinfo+"' value='' size='7' type='text' detindex='"+index+"' onkeyup='checkAssignNum(this)'></td>";
					
					innerhtml += "<td><input name='devremark"+lineinfo+"' id='devremark"+lineinfo+"' value='' size='10' type='text' /></td>";
					innerhtml += "</tr>";
					$("#processtable").append(innerhtml);
				}
				$("#detailList>tr:odd>td:odd").addClass("odd_odd");
				$("#detailList>tr:odd>td:even").addClass("odd_even");
				$("#detailList>tr:even>td:odd").addClass("even_odd");
				$("#detailList>tr:even>td:even").addClass("even_even");
			}
		})
	});
	function checkInputNum(obj){
		var lineid = obj.checkinfo;
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
		}
		$("#totalslotnum"+lineid).val(parseInt(devslotnum)*parseInt(value));
	}
	function toAddRowInfo(){
		var obj = new Object();
		var data=window.showModalDialog("<%=contextPath%>/rm/dm/collectTree/collectTreeManager.jsp?ctxmenu=false&inline=true",obj,"dialogWidth=300px;dialogHeight=400px");
		if(data!=undefined){
			//查找现在的显示标签页
			//查找最大的index
			var maxseqinfo = $("#detailList"+">tr:last").attr("seqinfo");
			if(maxseqinfo == undefined || maxseqinfo == ''){
				maxseqinfo = 0;
			}
			var currentseq = parseInt(maxseqinfo,10)+1;
			var innerhtml = "<tr id='tr"+currentseq+"' name='tr"+currentseq+"' seqinfo='"+currentseq+"'>";
			innerhtml += "<td><input type='checkbox' name='idinfo' id='"+currentseq+"'/>";
			innerhtml += "<input type='hidden' id='device_id"+currentseq+"' name='device_id"+currentseq+"' value='"+data.device_id+"'></td>";
			innerhtml += "<td><input name='devicename"+currentseq+"' id='devicename"+currentseq+"' style='line-height:15px' value='"+data.dev_name+"' size='30' type='text' readonly/></td>";
			innerhtml += "<td><input name='devicemodel"+currentseq+"' id='devicemodel"+currentseq+"' style='line-height:15px' value='"+data.dev_model+"' size='30' type='text' readonly/></td>";
			innerhtml += "<td><select id='unitList"+currentseq+"' name='unitList"+currentseq+"' style='select_width'></select></td>";
			innerhtml += "<td><input name='devslotnum"+currentseq+"' id='devslotnum"+currentseq+"' style='line-height:15px' value='"+data.dev_slot_num+"' size='6' type='text' onclick='checkInputNum(this)'/></td>";
			innerhtml += "<td><input name='apply_num"+currentseq+"' id='apply_num"+currentseq+"' style='line-height:15px' value='' size='10' type='text' onclick='checkInputNum(this)'/></td>";
			innerhtml += "<td><input name='totalslotnum"+currentseq+"' id='totalslotnum"+currentseq+"' style='line-height:15px' value='' size='10' type='text' readonly/></td>";
			innerhtml += "<td><input name='mixednum"+currentseq+"' id='mixednum"+currentseq+"' value='' size='8'  type='text' readonly/></td>";
			innerhtml += "<td><input name='totalnum"+currentseq+"' id='totalnum"+currentseq+"' value='' size='6' type='text' readonly/></td>";
			innerhtml += "<td><input name='unusenum"+currentseq+"' id='unusenum"+currentseq+"' value='' size='7' type='text' readonly/></td>";
			
			innerhtml += "<td><input name='mixnum"+currentseq+"' id='mixnum"+currentseq+"' value='' size='7' type='text' detindex='"+index+"' onkeyup='checkAssignNum(this)'></td>";
			
			innerhtml += "<td><input name='devremark"+currentseq+"' id='devremark"+currentseq+"' value='' size='10' type='text' /></td>";
			innerhtml += "</tr>";
			$("#detailList").append(innerhtml);
			
			$("#detailList"+">tr:odd>td:odd").addClass("odd_odd");
			$("#detailList"+">tr:odd>td:even").addClass("odd_even");
			$("#detailList"+">tr:even>td:odd").addClass("even_odd");
			$("#detailList"+">tr:even>td:even").addClass("even_even");
			//给当前这个单位追加数据
			var retObj;
			var unitSql = "select sd.coding_code_id,coding_name ";
			unitSql += "from comm_coding_sort_detail sd "; 
			unitSql += "where coding_sort_id ='5110000038' order by coding_code";
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql);
			retObj = unitRet.datas;
			var optionhtml = "";
			for(var index=0;index<retObj.length;index++){
				optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
			}
			$("#unitList"+currentseq).append(optionhtml);
		}
	}
	function toDelRowInfo(){
		//查找现在的显示标签页
		$("input[type='checkbox'][name='idinfo']","#detailList").each(function(i){
			if(this.checked == true){
				var id=this.id;
				$("#tr"+id,"#detailList").remove();
			}
		});
		$("#detailList>tr:odd>td:odd").addClass("odd_odd");
		$("#detailList>tr:odd>td:even").addClass("odd_even");
		$("#detailList>tr:even>td:odd").addClass("even_odd");
		$("#detailList>tr:even>td:even").addClass("even_even");
	}
</script>
</html>

