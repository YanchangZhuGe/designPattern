<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String outInfoId = request.getParameter("outInfoId");
	//String receiveType = request.getParameter("receiveType");
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
					<input id="dev_unit" name="dev_unit" class="input_width" type="hidden" readonly="readonly" />
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
		
		var device_oif_subid = '<%=request.getParameter("id")%>';
		var retObj;
		if(device_oif_subid!=null){
		    var querySql="select sub.dev_acc_id as subdevid, sub.device_id, sub.device_oif_subid,sub.team,"+
			    "sub.device_name,sub.device_model,sub.out_num,sub.unit_id,detail.coding_name as unit_name,"+
			    "teamsd.coding_name as team_name,"+
				"form.in_org_id,inorg.org_abbreviation as in_org_name,form.out_org_id,outorg.org_abbreviation as out_org_name, "+
				"dui.total_num,dui.unuse_num,dui.use_num,dui.dev_acc_id "+
				"from gms_device_coll_outsub sub "+
				"left join comm_coding_sort_detail detail on sub.unit_id = detail.coding_code_id "+
				"left join comm_coding_sort_detail teamsd on sub.team = teamsd.coding_code_id "+
				"left join gms_device_coll_outform form on form.device_outinfo_id=sub.device_outinfo_id "+
				"left join comm_org_information inorg on form.in_org_id=inorg.org_id "+
				"left join comm_org_information outorg on form.out_org_id=outorg.org_id "+
				"left join gms_device_coll_account_dui dui on dui.fk_dev_acc_id=sub.dev_acc_id and dui.project_info_id='<%=projectInfoNo%>' "+
			    "where device_oif_subid='"+device_oif_subid+"'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			retObj = queryRet.datas;
		}
		if(retObj!=undefined && retObj.length>=1){
			document.getElementById("dev_name").value =retObj[0].device_name;
			document.getElementById("dev_model").value =retObj[0].device_model;
			document.getElementById("dev_unit_name").value =retObj[0].unit_name;
			document.getElementById("dev_unit").value =retObj[0].unit_id;
			document.getElementById("device_id").value =retObj[0].device_id;
			document.getElementById("out_num").value =retObj[0].out_num;
			if('<%=receiveType%>' == '1'){
				document.getElementById("in_org_id").value =retObj[0].in_org_id;
				document.getElementById("in_org_name").value =retObj[0].in_org_name;
				document.getElementById("out_org_id").value =retObj[0].out_org_id;
				document.getElementById("out_org_name").value =retObj[0].out_org_name;
			}else{
				document.getElementById("in_org_id").value =retObj[0].out_org_id;
				document.getElementById("in_org_name").value =retObj[0].out_org_name;
				document.getElementById("out_org_id").value =retObj[0].in_org_id;
				document.getElementById("out_org_name").value =retObj[0].in_org_name;
			}
			
			document.getElementById("team_name").value =retObj[0].team_name;
			document.getElementById("team").value =retObj[0].team;			
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
		var device_oif_subid = '<%=request.getParameter("id")%>';
		var projectInfoNo='<%=projectInfoNo%>';
		if(document.getElementById("actual_in_time").value==""){
			alert("实际进场时间不能为空！");
			return;
		}
		if(confirm("确认提交？")){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSubmitCollectReceive.srq?device_oif_subid="+device_oif_subid+"&devaccId="+devaccId+"&projectInfoNo="+projectInfoNo+"&fk_devaccId="+fk_devaccId+"&outInfoId="+'<%=outInfoId%>';
			document.getElementById("form1").submit();
			document.getElementById("submitButton").onclick = "";
		}
	}
	
</script>
</html>

