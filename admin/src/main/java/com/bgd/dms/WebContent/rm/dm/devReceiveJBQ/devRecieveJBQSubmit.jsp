<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String outInfoId = request.getParameter("outInfoId");
	String receiveType = "1";
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

<title>设备接收提交</title>
</head>
<body class="bgColor_f3f3f3" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<input type="hidden" id="detail_count" value="" />
<input type="hidden" id="device_oif_subid" name ='device_oif_subid' value="" />

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
					<input id="dev_unit" name="dev_unit" class="input_width" type="hidden" value='5110000038000000011' readonly="readonly" />
					<input id="device_id" name="device_id" class="input_width" type="hidden" readonly="readonly" />
				</td>				
			  </tr>
				<tr>
				<td class="inquire_item6">转入单位</td>
				<td class="inquire_form6">
					<input id="in_org_name" name="in_org_name" class="input_width" type="text" readonly="readonly" />
					<input name="in_org_id" id="in_org_id" class="input_width" type="hidden"/>
				</td>				
				<td class="inquire_item6">转出单位</td>
				<td class="inquire_form6">
					<input id="out_org_name" name="out_org_name" class="input_width" type="text" readonly="readonly" />
					<input name="out_org_id" id="out_org_id" class="input_width" type="hidden"/>
					<input name="out_sub_id" id="out_sub_id" class="input_width" type="hidden"/>
				</td>
				<td class="inquire_item6">班组</td>
				<td class="inquire_form6">
					<input id="team_name" name="team_name" class="input_width" type="text" readonly="readonly" />
					<input id="team" name="team" type="hidden" readonly="readonly" />
				</td>
			  </tr>
			  <tr>
			  	<td class="inquire_item6">转入数量</td>
				<td class="inquire_form6">
					<input id="out_num" name="out_num" class="input_width" type="text" readonly="readonly" />
				</td>
				<td class="inquire_item6"><font color=red>*</font>&nbsp;实际进场时间</td>
				<td class="inquire_form6"><input id="actual_in_time" name="actual_in_time" class="input_width" type="text" readonly="readonly"/>
					&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;"
					onmouseover="calDateSelector(actual_in_time,tributton1);" />
				</td>
			  </tr>				
      </table>
      <HR style="border:1 dashed #ffffff" width="100%" />
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<tr>
      		<td>
      			<fieldset style="margin-left:2px"><legend>设备信息</legend>
			      		<table id="table1" width="100%" border="0" cellspacing="2" cellpadding="0" class="tab_line_height">
			         		<tr>
			         			<td class="bt_info_even" colspan='2'>设备原台账信息</td>
			         			<td class="bt_info_odd" colspan='2'>设备现台账信息</td>
			         		</tr>
			         		<tr>
								<td class="inquire_item6">总数量</td>
								<td class="inquire_form6"><input id="old_total_num" name="old_total_num" class="input_width" type="text" /></td>
								<td class="inquire_item6">总数量</td>
								<td class="inquire_form6"><input id="new_total_num" name="new_total_num" class="input_width" type="text" readonly="readonly" /></td>
						  	</tr>
						  	<tr>
								<td class="inquire_item6">在队数量</td>
								<td class="inquire_form6"><input id="old_unuse_num" name="old_unuse_num" class="input_width" type="text"/></td>
								<td class="inquire_item6">在队数量</td>
								<td class="inquire_form6"><input id="new_unuse_num" name="new_unuse_num" class="input_width" type="text" readonly="readonly" /></td>
						  	</tr>			         		
							<tr>
								<td class="inquire_item6">离队数量</td>
								<td class="inquire_form6"><input id="old_use_num" name="old_use_num" class="input_width" type="text" readonly="readonly" /></td>								
								<td class="inquire_item6">离队数量</td>
								<td class="inquire_form6"><input id="new_use_num" name="new_use_num" class="input_width" type="text" readonly="readonly" /></td>								
						  	</tr>
			     	 </table>
      			</fieldset>
      		</td>     		
      	</tr>
      </table>
    </div>   
    <div id="oper_div">
     	<span class="tj_btn"><a id="submitButton" href="#" onclick="submitInfo()"></a></span>
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
			$("input[name='idinfo']").each(function(i){
				if(this.checked == true){
					var selected_id = this.id;
					$('#tr'+selected_id).remove();
				}
			});
		});
	});
	var devaccId="";
	var fk_devaccId="";
	
	function loadDataDetail(){
		var retObj;
	    var querySql="select t.dev_acc_id as subdevid,t.dev_ci_code as device_id,dui.dev_acc_id,t.device_mix_subid,info.dev_name as dev_name,f.out_org_id as out_sub_id, info.dev_model as dev_type,det.coding_name,d.apply_num,t.assign_num,d.plan_start_date,d.plan_end_date,d.team as team_id,csd.coding_name as team_name,i.org_id as in_org_id,o.org_id as out_org_id,i.org_abbreviation as in_org_name,o.org_abbreviation as out_org_name,dui.total_num,dui.use_num,dui.unuse_num  from gms_device_appmix_main t left join gms_device_app_detail d on t.device_app_detid=d.device_app_detid left join comm_coding_sort_detail det on d.unitinfo=det.coding_code_id left join gms_device_coll_account_dui dui on t.dev_ci_code=dui.device_id and dui.project_info_id='<%=projectInfoNo%>' left join comm_coding_sort_detail csd on d.team=csd.coding_code_id left join gms_device_mixinfo_form f on t.device_mixinfo_id=f.device_mixinfo_id left join comm_org_information i on f.in_org_id=i.org_id left join comm_org_subjection sub on f.out_org_id=sub.org_subjection_id left join comm_org_information o on sub.org_id=o.org_id left join gms_device_collectinfo info on t.dev_ci_code=info.device_id where t.device_mixinfo_id='<%=outInfoId%>'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		retObj = queryRet.datas;
			
		if(retObj!=undefined && retObj.length>=1){
			document.getElementById("device_oif_subid").value =retObj[0].device_mix_subid;
			document.getElementById("dev_name").value =retObj[0].dev_name;
			document.getElementById("dev_model").value =retObj[0].dev_type;
			document.getElementById("dev_unit_name").value =retObj[0].coding_name;
			document.getElementById("device_id").value =retObj[0].device_id;
			document.getElementById("out_num").value =retObj[0].assign_num;
			document.getElementById("in_org_id").value =retObj[0].in_org_id;
			document.getElementById("in_org_name").value =retObj[0].in_org_name;
			document.getElementById("out_org_id").value =retObj[0].out_org_id;
			document.getElementById("out_sub_id").value =retObj[0].out_sub_id;
			document.getElementById("out_org_name").value =retObj[0].out_org_name;			
			document.getElementById("team_name").value =retObj[0].team_name;
			document.getElementById("team").value =retObj[0].team_id;			
			document.getElementById("old_total_num").value =retObj[0].total_num;
			document.getElementById("old_unuse_num").value =retObj[0].unuse_num;
			document.getElementById("old_use_num").value =retObj[0].use_num;
			if('<%=receiveType%>' == '1'){
				if(retObj[0].total_num==""){
					document.getElementById("old_total_num").value ="0";
				}
				if(retObj[0].unuse_num==""){
					document.getElementById("old_unuse_num").value ="0";
				}
				if(retObj[0].use_num==""){
					document.getElementById("old_use_num").value ="0";
				}
				var oldTatalNum = document.getElementById("old_total_num").value;
				document.getElementById("new_total_num").value =parseInt(oldTatalNum)+parseInt(document.getElementById("out_num").value);
				document.getElementById("new_unuse_num").value =parseInt(document.getElementById("old_unuse_num").value)+parseInt(document.getElementById("out_num").value);
				document.getElementById("new_use_num").value = document.getElementById("old_use_num").value;
				fk_devaccId = retObj[0].subdevid;
				devaccId=retObj[0].dev_acc_id;
			}else{
				if(retObj[0].total_num==""){
					document.getElementById("old_total_num").value ="0";
				}
				if(retObj[0].unuse_num==""){
					document.getElementById("old_unuse_num").value ="0";
				}
				if(retObj[0].use_num==""){
					document.getElementById("old_use_num").value ="0";
				}
				var oldTatalNum = document.getElementById("old_total_num").value;
				document.getElementById("new_total_num").value =oldTatalNum
				document.getElementById("new_unuse_num").value =parseInt(document.getElementById("old_unuse_num").value)+parseInt(document.getElementById("out_num").value);
				if(document.getElementById("old_use_num").value=="0"){
					document.getElementById("new_use_num").value = document.getElementById("old_use_num").value;
				}else{
					document.getElementById("new_use_num").value =parseInt(document.getElementById("old_use_num").value)-parseInt(document.getElementById("out_num").value);
				}
				fk_devaccId = retObj[0].subdevid;
				devaccId=retObj[0].dev_acc_id;
			}
		}
	}
	
	function submitInfo(){
		var projectInfoNo='<%=projectInfoNo%>';
		if(document.getElementById("actual_in_time").value==""){
			alert("实际进场时间不能为空！");
			return;
		}
		if(confirm("确认接收?")){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSubmitJBQReceive.srq?devaccId="+devaccId+"&projectInfoNo="+projectInfoNo+"&fk_devaccId="+fk_devaccId+"&outInfoId="+'<%=outInfoId%>';
			document.getElementById("form1").submit();
			document.getElementById("submitButton").onclick = "";
		}		
	}	
</script>
</html>

