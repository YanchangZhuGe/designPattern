<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>设备入库明细</title>
</head>
<body class="bgColor_f3f3f3" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<input type="hidden" id="detail_count" value="" />
  <div id="new_table_box_content" style="height: 500px;">
    <div id="new_table_box_bg" style="height: 450px;">
      <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
         <tr>
				<td class="inquire_item6">设备名称</td>
				<td class="inquire_form6"><input id="dev_name" name="dev_name"  class="input_width" type="text" readonly="readonly" /></td>
				<td class="inquire_item6">规格型号</td>
				<td class="inquire_form6"><input id="dev_model" name="dev_model" class="input_width" type="text" readonly="readonly" /></td>
				<td class="inquire_item6">单位</td>
				<td class="inquire_form6">
					<input id="dev_unit_name" name="dev_unit_name" class="input_width" type="text" readonly="readonly" />
					<input id="dev_unit" name="dev_unit" type="hidden" value=""/>
					<input id="device_id" name="device_id" type="hidden" value=""/>
					<input id="type_id" name="type_id" type="hidden" value=""/>
				</td>
			  </tr>
				<tr>
				<td class="inquire_item6">返还单位</td>
				<td class="inquire_form6">
					<input id="back_org_name" name="back_org_name" class="input_width" type="text" readonly="readonly" />
					<input name="back_org_id" id="back_org_id" class="input_width" type="hidden"/>
				</td>
				
				<td class="inquire_item6">接收单位</td>
				<td class="inquire_form6">
					<input id="receive_org_name" name="receive_org_name" class="input_width" type="text" readonly="readonly" />
					<input name="receive_org_id" id="receive_org_id" class="input_width" type="hidden"/>
					<input name="usage_sub_id" id="usage_sub_id" class="input_width" type="hidden"/>
				</td>
				<td class="inquire_item6">原所在单位</td>
				<td class="inquire_form6">
					<input id="out_org_name" name="out_org_name" class="input_width" type="text" readonly="readonly" />
					<input name="out_org_id" id="out_org_id" class="input_width" type="hidden"/>
					<input name="owning_sub_id" id="owning_sub_id" class="input_width" type="hidden"/>
				</td>				
			  </tr>
				<tr>
				<td class="inquire_item6">国内/国外</td>
				<td class="inquire_form6">
					<select id='ifcountry' name='ifcountry' class="input_width">
						<option value='国内'>国内</option>
						<option value='国外'>国外</option>
					</select>
				</td>	
					<td class="inquire_item6">返还数量</td>
					<td class="inquire_form6"><input id="back_num" name="back_num" class="input_width" type="text" readonly="readonly" /></td>
					<td class="inquire_item6"><font color=red>*</font>&nbsp;验收时间</td>
					<td class="inquire_form6"><input id="actual_out_time" name="actual_out_time" class="input_width" type="text" readonly="readonly"/>
						&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;"
						onmouseover="calDateSelector(actual_out_time,tributton1);" />
					</td>
				</tr>
      </table>
      <hr style="border:1 dashed #ffffff" width="100%" />
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<tr>
      		<td>
      			<fieldset style="margin-left:2px"><legend>设备技术状况</legend>
			      		<table id="table1" width="100%" border="0" cellspacing="0" cellpadding="1" class="tab_line_height">
			         		<tr>
			         			<td class="bt_info_odd" colspan='2'>验收设备信息</td>
			         			<td class="bt_info_even" colspan='2'>设备原状态信息</td>
			         			<td class="bt_info_odd" colspan='2'>设备现状态信息</td>
			         		</tr>
							<tr>
								<td class="inquire_item6"><font color=red>*</font>&nbsp;完好数量</td>
								<td class="inquire_form6"><input id="good_num" name="good_num" class="input_width" type="text" onkeyup="techAutoCal(this)"/></td>
								<td class="inquire_item6">原完好数量</td>
								<td class="inquire_form6"><input id="old_good_num" name="old_good_num" class="input_width" type="text" readonly="readonly" /></td>
								<td class="inquire_item6">现完好数量</td>
								<td class="inquire_form6"><input id="new_good_num" name="new_good_num" class="input_width" type="text" readonly="readonly" /></td>
						  	</tr>
						  	<tr>
								<td class="inquire_item6"><font color=red>*</font>&nbsp;待维修数量</td>
								<td class="inquire_form6"><input id="torepair_num" name="torepair_num" class="input_width" type="text" onkeyup="techAutoCal(this)"/></td>
								<td class="inquire_item6">原维修数量</td>
								<td class="inquire_form6"><input id="old_torepair_num" name="old_torepair_num" class="input_width" type="text" readonly="readonly" /></td>
								<td class="inquire_item6">现维修数量</td>
								<td class="inquire_form6"><input id="new_torepair_num" name="new_torepair_num" class="input_width" type="text" readonly="readonly" /></td>
						  	</tr>
						  	<tr>
						   		<td class="inquire_item6"><font color=red>*</font>&nbsp;毁损数量</td>
								<td class="inquire_form6"><input id="destroy_num" name="destroy_num" class="input_width" type="text" onkeyup="techAutoCal(this)"/></td>
								<td class="inquire_item6">原毁损数量</td>
								<td class="inquire_form6"><input id="old_destroy_num" name="old_destroy_num" class="input_width" type="text" readonly="readonly" /></td>
								<td class="inquire_item6">现毁损数量</td>
								<td class="inquire_form6"><input id="new_destroy_num" name="new_destroy_num" class="input_width" type="text" readonly="readonly" /></td>
						  	</tr>
						    <tr>
						   		<td class="inquire_item6"><font color=red>*</font>&nbsp;盘亏数量</td>
								<td class="inquire_form6"><input id="tocheck_num" name="tocheck_num" class="input_width" type="text" onkeyup="techAutoCal(this)"/></td>
								<td class="inquire_item6">原盘亏数量</td>
								<td class="inquire_form6"><input id="old_tocheck_num" name="old_tocheck_num" class="input_width" type="text" readonly="readonly" /></td>
								<td class="inquire_item6">现盘亏数量</td>
								<td class="inquire_form6"><input id="new_tocheck_num" name="new_tocheck_num" class="input_width" type="text" readonly="readonly" /></td>
						  	</tr>
						  	<tr>
						  		<td class="inquire_item6"><font color=red>*</font>未交回数量</td>
								<td class="inquire_form6"><input id="noreturn_num" name="noreturn_num" class="input_width" type="text" onkeyup="techAutoCal(this)" /></td>
								<td class="inquire_item6">原未交回数量</td>
								<td class="inquire_form6"><input id="old_noreturn_num" name="old_noreturn_num" class="input_width" type="text" readonly="readonly" /></td>
								<td class="inquire_item6">现未交回数量</td>
								<td class="inquire_form6"><input id="new_noreturn_num" name="new_noreturn_num" class="input_width" type="text" readonly="readonly" /></td>
						  	</tr>
			     	 </table>
      			</fieldset>
      		</td>      		
      	</tr>
      </table>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</form>
</body>
<script type="text/javascript"> 
	$().ready(function(){
		$("#addProcess").click(function(){
			tr_id = $("#processtable>tbody>tr:last").attr("id");
			if(tr_id != undefined){
				tr_id = parseInt(tr_id.substr(2,1),10);
			}
			if(tr_id == undefined){
				tr_id = 0;
			}else{
				tr_id = tr_id+1;
			}
			//统计本次的总行数
			$("#detail_count").val(tr_id);
			//动态新增表格
			var innerhtml = "<tr id = 'tr"+tr_id+"' ><td><input type='checkbox' name='idinfo' id='"+tr_id+"'/><input name='devicename"+tr_id+"' value='通过设备编码树选择设备名称' size='12' type='text'/></td><td><input name='devicetype"+tr_id+"' class='input_width' value='设备名称带出类型' size='12' type='text'/></td><td><input name='signtype"+tr_id+"' class='input_width' value='名称和类型带出类别' size='12' type='text'/></td><td><input name='unit"+tr_id+"' class='input_width' type='text'/></td><td><input name='neednum"+tr_id+"' class='input_width' value='' size='8' type='text'/></td><td><input name='team"+tr_id+"' class='input_width' type='text'/></td><td><input name='purpose"+tr_id+"' class='input_width' value='' size='8' type='text'/></td><td><input name='startdate"+tr_id+"' class='input_width' type='text'/></td><td><input name='enddate"+tr_id+"' class='input_width' type='text'/></td></tr>";
			
			$("#processtable").append(innerhtml);
			if(tr_id%2 == 0){
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:odd").addClass("odd_odd");
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:even").addClass("odd_even");
			}else{
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:odd").addClass("even_odd");
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:even").addClass("even_even");
			}
		});
		$("#delProcess").click(function(){
			$("input[name='idinfo']").each(function(){
				var selected_id = this.id;
				$('#tr'+selected_id).remove();
			});
		});
	});
	var devaccId="";
	
	var projectInfoNo="";
	var device_backapp_id = "";
	function loadDataDetail(){
		
		var device_backdet_id = '<%=request.getParameter("id")%>';
		var retObj;
		if(device_backdet_id!=null){
			var querySql="select backdet.device_backdet_id,backdet.device_backapp_id,backdet.dev_acc_id,backdet.dev_name,backdet.dev_model,";
				querySql+="backdet.back_num,backdet.planning_out_time,backdet.is_leaving,backdet.bsflag,backdet.devremark,";
		    	querySql+="t.back_num as mixnum,t.device_coll_mixinfo_id,unitsd.coding_name as dev_unit_name,outacc.device_id,outacc.type_id,";
		    	querySql+="accdui.dev_unit,apporg.org_id as apporg_id,apporg.org_abbreviation as apporg_name, ";
		    	querySql+="f.receive_org_id as revorg_id,usesub.org_subjection_id as usage_sub_id,revorg.org_abbreviation as revorg_name,app.project_info_id as project_info_no,";
		    	querySql+="outacc.owning_org_id as owning_org_id,ownorg.org_abbreviation as owning_org_name,ownsub.org_subjection_id as owning_sub_id,accdui.out_org_id,oldorg.org_abbreviation as oldorg_name,";
		    	querySql+="  nvl(acc.total_num ,0) as use_old_total_num , nvl(acc.unuse_num,0) as old_unusing_num,  nvl(acc.use_num,0)as old_using_num, nvl(acc.other_num,0) as old_other_num,    nvl(tech.good_num,0) as good_num, ";//原数量
		    	querySql+="  nvl(tech.touseless_num,0)as touseless_num,  nvl(tech.torepair_num,0) as torepair_num , nvl(tech.tocheck_num,0) as tocheck_num,  nvl(tech.destroy_num,0) as destroy_num , nvl(tech.noreturn_num,0) as noreturn_num ";
		    	querySql+="from GMS_DEVICE_COLL_BACK_DETAIL t left join GMS_DEVICE_COLL_BACKINFO_FORM backfor on t.device_coll_mixinfo_id = backfor.device_coll_mixinfo_id left join gms_device_collbackapp_detail backdet on t.device_backdet_id = backdet.device_backdet_id ";
		    	querySql+="left join gms_device_collbackapp app on app.device_backapp_id=backdet.device_backapp_id ";
		    	querySql+="left join comm_org_information apporg on app.back_org_id = apporg.org_id and apporg.bsflag='0' ";//返还申请单位
		    	querySql+="left join gms_device_coll_account_dui accdui on backdet.dev_acc_id = accdui.dev_acc_id ";
		    	querySql+="left join comm_coding_sort_detail unitsd on accdui.dev_unit=unitsd.coding_code_id ";
		    	querySql+="left join comm_org_information oldorg on accdui.out_org_id = oldorg.org_id ";//转出单位即原所在单位
		    	querySql+="left join gms_device_coll_account acc on accdui.device_id = acc.device_id and acc.ifcountry != '国外' and acc.bsflag='0' and backfor.receive_org_id=acc.usage_org_id ";//公司级台账使用状态
		    	querySql+="left join gms_device_coll_account outacc on accdui.fk_dev_acc_id = outacc.dev_acc_id ";//公司级台账使用状态
		    	querySql+="left join gms_device_coll_account_tech tech on tech.dev_acc_id=acc.dev_acc_id  left join gms_device_coll_backinfo_form f on t.device_coll_mixinfo_id=f.device_coll_mixinfo_id left join comm_org_information revorg on f.receive_org_id = revorg.org_id and revorg.bsflag='0' ";//公司级台账技术状况
		    	querySql+="left join comm_org_subjection usesub on f.receive_org_id = usesub.org_id and usesub.bsflag='0' left join comm_org_information ownorg on outacc.owning_org_id = ownorg.org_id and ownorg.bsflag='0' left join comm_org_subjection ownsub on outacc.owning_org_id = ownsub.org_id and ownsub.bsflag='0' ";
					querySql+="where t.device_coll_backdet_id='"+device_backdet_id+"'";
				
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		        retObj = queryRet.datas;
		}
		
		device_backapp_id = retObj[0].device_coll_mixinfo_id;
		devaccId = retObj[0].dev_acc_id;
		projectInfoNo=retObj[0].project_info_no;
		document.getElementById("dev_name").value =retObj[0].dev_name;
		document.getElementById("dev_model").value =retObj[0].dev_model;
		document.getElementById("dev_unit_name").value =retObj[0].dev_unit_name;
		document.getElementById("device_id").value =retObj[0].device_id;
		document.getElementById("type_id").value =retObj[0].type_id;
		document.getElementById("dev_unit").value =retObj[0].dev_unit;
		document.getElementById("back_org_name").value =retObj[0].apporg_name;
		document.getElementById("back_org_id").value =retObj[0].apporg_id;
		document.getElementById("receive_org_name").value =retObj[0].revorg_name;
		document.getElementById("receive_org_id").value =retObj[0].revorg_id;
		document.getElementById("out_org_name").value =retObj[0].oldorg_name;
		document.getElementById("out_org_id").value =retObj[0].out_org_id;
		document.getElementById("back_num").value =retObj[0].mixnum;
		
		document.getElementById("usage_sub_id").value =retObj[0].usage_sub_id;
		document.getElementById("owning_sub_id").value =retObj[0].owning_sub_id;
		document.getElementById("old_noreturn_num").value =retObj[0].noreturn_num;
		document.getElementById("old_good_num").value =retObj[0].good_num;
		//业务需求，验收中不需要待报废，2012-12-29
		//document.getElementById("old_usless_num").value =retObj[0].touseless_num;
		document.getElementById("old_tocheck_num").value =retObj[0].tocheck_num;
		document.getElementById("old_torepair_num").value =retObj[0].torepair_num;
		document.getElementById("old_destroy_num").value =retObj[0].destroy_num;
		if(document.getElementById("old_noreturn_num").value=="")
			{
			document.getElementById("old_noreturn_num").value ="0";
			}
	
	
	}
	function usingAutoCal(obj){
		//valimation(obj)
		if(parseInt(document.getElementById("back_num").value)<
			(parseInt(document.getElementById("unusing_num").value)+parseInt(document.getElementById("other_num").value))){
			alert("分配数量之和超过返还数量，请重新分配!");
			obj.value = "";
        	return false;
		}
		if(obj.id=="unusing_num"){
			document.getElementById("new_unusing_num").value=parseInt(document.getElementById("old_unusing_num").value)+parseInt(document.getElementById("unusing_num").value);
		}
		else{
			document.getElementById("new_other_num").value=parseInt(document.getElementById("old_other_num").value)+parseInt(document.getElementById("other_num").value);
		}
	}
	function techAutoCal(obj){
		valimation(obj);
		var totalnum = 0;
		if(document.getElementById("good_num").value!=""){
			totalnum += parseInt(document.getElementById("good_num").value);
		}
		if(document.getElementById("tocheck_num").value!=""){
			totalnum += parseInt(document.getElementById("tocheck_num").value);
		}
		if(document.getElementById("torepair_num").value!=""){
			totalnum += parseInt(document.getElementById("torepair_num").value);
		}
		if(document.getElementById("destroy_num").value!=""){
			totalnum += parseInt(document.getElementById("destroy_num").value);
		}
		if(document.getElementById("noreturn_num").value!=""){
			totalnum += parseInt(document.getElementById("noreturn_num").value);
		}
		//业务需求，验收中不需要待报废，2012-12-29
		if(parseInt(document.getElementById("back_num").value)<totalnum){
			alert("分配数量之和超过返还数量，请重新分配!");
			obj.value = "";
        	return false;
		}
		if(obj.id=="good_num"){
			//现完好＝原完好－返还数量+分配完好数量
			//if(document.getElementById("receive_org_id").value==document.getElementById("out_org_id").value){
			//	document.getElementById("new_good_num").value
			//		=parseInt(document.getElementById("old_good_num").value)-parseInt(document.getElementById("back_num").value)+parseInt(document.getElementById("good_num").value);
			//}else{
				document.getElementById("new_good_num").value=parseInt(document.getElementById("old_good_num").value)+parseInt(document.getElementById("good_num").value);
		//	}			
		}else if(obj.id=="tocheck_num"){
			document.getElementById("new_tocheck_num").value=parseInt(document.getElementById("old_tocheck_num").value)+parseInt(document.getElementById("tocheck_num").value);
		}else if(obj.id=="torepair_num"){
			document.getElementById("new_torepair_num").value=parseInt(document.getElementById("old_torepair_num").value)+parseInt(document.getElementById("torepair_num").value);
		}else if(obj.id=="noreturn_num"){
			document.getElementById("new_noreturn_num").value=parseInt(document.getElementById("old_noreturn_num").value)+parseInt(document.getElementById("noreturn_num").value);
		}else{
			document.getElementById("new_destroy_num").value=parseInt(document.getElementById("old_destroy_num").value)+parseInt(document.getElementById("destroy_num").value);
		}
	}
	function valimation(obj){
		var value = obj.value;
		var re = /^\+?[0-9][0-9]*$/;
		if(value=="")
			return;
		if(!re.test(value)){
			alert("数量必须为数字!");
			obj.value = "";
        	return false;
		}else{
			if(parseInt(value,10)>parseInt(document.getElementById("back_num").value)){
				alert("数量必须小于等于返还数量!");
				obj.value = "";
				return false;
			}
		}
	}
	function submitInfo(){
		if(document.getElementById("actual_out_time").value==""){
			alert("验收时间不能为空！");
			return;
		}
		if(document.getElementById("good_num").value==""){
			alert("完好数量不能为空，请分配！");
			return;
		}
		//业务需求，验收中不需要待报废，2012-12-29
		//if(document.getElementById("usless_num").value==""){
		//	alert("待报废数量不能为空，请分配！");
		//	return;
		//}
		if(document.getElementById("torepair_num").value==""){
			alert("维修数量不能为空，请分配！");
			return;
		}
		if(document.getElementById("destroy_num").value==""){
			alert("毁损数量不能为空，请分配！");
			return;
		}
		if(document.getElementById("tocheck_num").value==""){
			alert("盘亏数量不能为空，请分配！");
			return;
		}
		if(document.getElementById("noreturn_num").value==""){
			alert("未交回数量不能为空，请分配！");
			return;
		}
		//5个数之和必须等于返还数量
		if(parseInt(document.getElementById("back_num").value)!=
				(parseInt(document.getElementById("good_num").value)
				+parseInt(document.getElementById("torepair_num").value)
				+parseInt(document.getElementById("destroy_num").value)
				+parseInt(document.getElementById("tocheck_num").value)	+parseInt(document.getElementById("noreturn_num").value))){
			alert("分配数量之和必须等于返还数量，请重新分配!");
        	return ;
		}
		
		var device_backdet_id = '<%=request.getParameter("id")%>';
		if(window.confirm("确认验收?")){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSubmitCollectStocknew.srq?device_backdet_id="+device_backdet_id+"&devaccId="+devaccId+"&device_backapp_id="+device_backapp_id+"&projectInfoNo="+projectInfoNo;
			document.getElementById("form1").submit();
		}
		//newClose();
	}
	function showOwingTreePage(str){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001&orgId=C6000000000007","test","");
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
	}
</script>
</html>

