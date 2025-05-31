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
<title></title>
</head>
<body class="bgColor_f3f3f3" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<input type="hidden" id="detail_count" value="" />
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
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
					<input id="tech_id" name="tech_id" type="hidden" value=""/>
				</td>
			  </tr>
				<tr>
				<td class="inquire_item6">所在单位</td>
				<td class="inquire_form6">
					<input id="usageorg_name" name="usageorg_name" class="input_width" type="text" readonly="readonly" />
					<input name="usageorg_id" id="usageorg_id" class="input_width" type="hidden"/>
				</td>
				<td class="inquire_item6"><font color=red>*</font>&nbsp;修好时间</td>
				<td class="inquire_form6"><input id="repair_end_time" name="repair_end_time" class="input_width" type="text" readonly="readonly"/>
					&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;"
					onmouseover="calDateSelector(repair_end_time,tributton1);" />
				</td>
				<td class="inquire_item6"><font color=red>*</font>修好数量</td>
				<td class="inquire_form6"><input id="repair_end_num" name="repair_end_num" class="input_width" type="text"  onkeyup='valimation(this)'/></td>				
			  </tr>				
      </table>
      <hr style="border:1 dashed #ffffff" width="100%" />
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<tr>
      		<td>
      			<fieldset style="margin-left:2px"><legend>设备技术状况</legend>
			      		<table id="table1" width="100%" border="0" cellspacing="0" cellpadding="1" class="tab_line_height">
			         		<tr>
			         			
			         			<td class="bt_info_even" colspan='2'>设备原状态信息</td>
			         			<td class="bt_info_odd" colspan='2'>设备现状态信息</td>
			         		</tr>
							<tr>
								<td class="inquire_item6">原完好数量</td>
								<td class="inquire_form6"><input id="old_good_num" name="old_good_num" class="input_width" type="text" readonly="readonly" /></td>
								<td class="inquire_item6">现完好数量</td>
								<td class="inquire_form6"><input id="new_good_num" name="new_good_num" class="input_width" type="text" readonly="readonly" /></td>
						  	</tr>
						  	<tr>
								<td class="inquire_item6">原维修数量</td>
								<td class="inquire_form6"><input id="old_torepair_num" name="old_torepair_num" class="input_width" type="text" readonly="readonly" /></td>
								<td class="inquire_item6">现维修数量</td>
								<td class="inquire_form6"><input id="new_torepair_num" name="new_torepair_num" class="input_width" type="text" readonly="readonly" /></td>
						  	</tr>
			     	 </table>
      			</fieldset>
      		</td>     		
      	</tr>
      </table>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<tr>
      		<td>
      			<fieldset style="margin-left:2px"><legend>设备使用状态</legend>
			      		<table id="table1" width="100%" border="0" cellspacing="2" cellpadding="0" class="tab_line_height">
			         		<tr>
			         			<td class="bt_info_even" colspan='2'>设备原状态信息</td>
			         			<td class="bt_info_odd" colspan='2'>设备现状态信息</td>
			         		</tr>
			         		<tr>
								<td class="inquire_item6">原闲置数量</td>
								<td class="inquire_form6"><input id="old_unusing_num" name="old_unusing_num" class="input_width" type="text" readonly="readonly" /></td>
								<td class="inquire_item6">现闲置数量</td>
								<td class="inquire_form6"><input id="new_unusing_num" name="new_unusing_num" class="input_width" type="text" readonly="readonly" /></td>
						  	</tr>
						  	<tr>
								<td class="inquire_item6">原其他数量</td>
								<td class="inquire_form6"><input id="old_other_num" name="old_other_num" class="input_width" type="text" readonly="readonly" /></td>
								<td class="inquire_item6">现其他数量</td>
								<td class="inquire_form6"><input id="new_other_num" name="new_other_num" class="input_width" type="text" readonly="readonly" /></td>
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
				if(this.checked){
					var selected_id = this.id;
					$('#tr'+selected_id).remove();
				}
			});
		});
	});
	
	function loadDataDetail(){
		
		var dev_acc_id = '<%=request.getParameter("devaccid")%>';
		var retObj;
		if(dev_acc_id!=null){
		    var querySql="select ga.*,gc1.dev_name as dev_type,usageorg.org_abbreviation as usage_org,"+
		    	"unitsd.coding_name as unit_name,gt.good_num,gt.tocheck_num,gt.touseless_num,nvl(gt.torepair_num,0) as torepair_num,gt.tech_id "+
		    	"from gms_device_coll_account ga "+
		    	"left join gms_device_collectinfo gc1 on ga.device_id=gc1.device_id "+
		    	"left join comm_org_information usageorg on ga.usage_org_id=usageorg.org_id "+
		    	"left join comm_coding_sort_detail unitsd on ga.dev_unit=unitsd.coding_code_id "+
		    	"left join gms_device_coll_account_tech gt on gt.dev_acc_id = ga.dev_acc_id  "+
		    	"where ga.dev_acc_id='"+dev_acc_id+"'"
				
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		        retObj = queryRet.datas;
		}
		
		device_backapp_id = retObj[0].device_backapp_id;
		document.getElementById("dev_name").value =retObj[0].dev_name;
		document.getElementById("dev_model").value =retObj[0].dev_model;
		document.getElementById("dev_unit_name").value =retObj[0].unit_name;
		document.getElementById("device_id").value =retObj[0].device_id;
		document.getElementById("type_id").value =retObj[0].type_id;
		document.getElementById("dev_unit").value =retObj[0].dev_unit;
		document.getElementById("tech_id").value =retObj[0].tech_id;
		
		document.getElementById("usageorg_name").value =retObj[0].usage_org;
		document.getElementById("usageorg_id").value =retObj[0].usage_org_id;
		document.getElementById("old_good_num").value =retObj[0].good_num;
		document.getElementById("old_torepair_num").value =retObj[0].torepair_num;
		
		document.getElementById("old_unusing_num").value =retObj[0].unuse_num;
		document.getElementById("old_other_num").value =retObj[0].other_num;
		
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
			if(parseInt(value,10)>parseInt(document.getElementById("old_torepair_num").value)){
				alert("修好数量须不能大于维修数量!");
				obj.value = "";
				return false;
			}
		}
		document.getElementById("new_good_num").value = parseInt(document.getElementById("old_good_num").value)+parseInt(value);
		document.getElementById("new_unusing_num").value = parseInt(document.getElementById("old_unusing_num").value)+parseInt(value);
		
		document.getElementById("new_torepair_num").value = parseInt(document.getElementById("old_torepair_num").value)-parseInt(value);
		document.getElementById("new_other_num").value = parseInt(document.getElementById("old_other_num").value)-parseInt(value);
		
		
	}
	function submitInfo(){
		if(document.getElementById("repair_end_time").value==""){
			alert("修好时间不能为空！");
			return;
		}
		if(document.getElementById("repair_end_num").value==""){
			alert("修好数量不能为空，请分配！");
			return;
		}
		var dev_acc_id = '<%=request.getParameter("devaccid")%>';
		
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toEditColTech.srq?devaccid="+dev_acc_id;
		document.getElementById("form1").submit();
		//newClose();
		
	}
	
</script>
</html>

