<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String id = request.getParameter("id");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String mixId = request.getParameter("mixId");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
  <link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
  <link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
  <link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
  <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/json2.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script> 
<title>设备接收明细</title>
</head>
<body class="bgColor_f3f3f3" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<input type="hidden" id="detail_count" value="" />
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
    	<fieldset style="margin-left:2px"><legend>设备基本信息</legend>
	      <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	          <tr>
				<td class="inquire_item6">设备名称</td>
				<td class="inquire_form6"><input id="dev_dev_name" name=""  class="input_width" type="text" /></td>
				<td class="inquire_item6">规格型号</td>
				<td class="inquire_form6"><input id="dev_dev_model" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">班组</td>
				<td class="inquire_form6">
					<input id="dev_team" name="" class="input_width" type="text" readonly/>
					<input id="team" name="team" type="hidden" />
					<input id="mixId" name="mixId" type="hidden" value="<%=mixId%>" />
				</td>
			  </tr>
				<tr>
				<td class="inquire_item6">实物标识号</td>
				<td class="inquire_form6"><input id="dev_dev_sign" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">自编号</td>
				<td class="inquire_form6"><input id="dev_self_num" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">牌照号</td>
				<td class="inquire_form6"><input id="dev_license_num" name="" class="input_width" type="text" /></td>
			  </tr>
			  <tr>
				<td class="inquire_item6">计量单位</td>
				<td class="inquire_form6"><input id="dev_dev_unit" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">存放地</td>
				<td class="inquire_form6"><input id="dev_position" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">用途</td>
				<td class="inquire_form6"><input id="dev_purpose" name="dev_purpose" class="input_width" type="text" /></td>
			  </tr>
			  <tr>
				<td class="inquire_item6">计划进场时间</td>
				<td class="inquire_form6"><input id="dev_plan_start_date" name="dev_plan_start_date" class="input_width" type="text" /></td>
				<td class="inquire_item6">计划离场时间</td>
				<td class="inquire_form6"><input id="dev_plan_end_date" name="dev_plan_end_date" class="input_width" type="text" /></td>
			  </tr>
	      </table>
	    </fieldset>
	    <fieldset style="margin-left:2px"><legend>接收确认信息</legend>
	      <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	      	<tr>
				<td class="inquire_item6">实际进场时间</td>
				<td class="inquire_form6">
					<input type="text" name="actual_start_date" id="actual_start_date" value="" readonly="readonly" class="input_width"/>
					<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(actual_start_date,tributton1);" />
					<input type="hidden" name="team_dev_acc_id" id="team_dev_acc_id" value="" />
				</td>
				<td class="inquire_item6">保养周期</td>
				<td class="inquire_form6">
					<select id="maintenance_cycle" name="maintenance_cycle" class="select_width"></select>天
				</td>
				<td class="inquire_item6">&nbsp;</td>
				<td class="inquire_form6">&nbsp;</td>
			</tr>
		  </table>
	    </fieldset>
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
	var devaccId="";
	var projectInfoNo="";
	function loadDataDetail(){
		var device_mix_detid = '<%=id%>';
		var retObj,queryRet;
		//回填保养周期 liujb 2012-9-26
		var bysql = "select coding_name,coding_code_id from comm_coding_sort_detail where coding_sort_id='5110000040' order by coding_show_id ";
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+bysql);
		retObj = queryRet.datas;
		if(retObj!=undefined && retObj.length>=1){
			//回填信息
			var optionhtml = "";
			for(var index=0;index<retObj.length;index++){
				optionhtml +=  "<option name='byzq' id='byzq"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
			}
			$("#maintenance_cycle").append(optionhtml);
		}
		if(device_mix_detid!=null){
		    var querysql="select plan.maintenance_cycle,dt.*,acc.dev_name,acc.dev_model,acc.dev_unit,acc.dev_position,"+
	    				"case dt.state when '0' then '未接收' when '9' then '已接收'  else '未接收' end as state_desc, "+
						"teamid.coding_name as team_name from gms_device_equ_outdetail_added dt "+
						"left join gms_device_account acc on acc.dev_acc_id=dt.dev_acc_id "+
						"left join comm_coding_sort_detail teamid on dt.team=teamid.coding_code_id "+
						"left join gms_device_maintenance_plan plan on dt.dev_acc_id = plan.dev_acc_id "+
						
						"where dt.device_oif_detid='"+device_mix_detid+"'";
				
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querysql);
		    retObj = queryRet.datas;
		    
		    document.getElementById("dev_dev_name").value =retObj[0].dev_name;
			document.getElementById("dev_dev_model").value =retObj[0].dev_model;
			document.getElementById("dev_dev_unit").value =retObj[0].dev_unit;
			document.getElementById("dev_self_num").value =retObj[0].self_num;
			document.getElementById("dev_license_num").value =retObj[0].license_num;
			document.getElementById("dev_dev_sign").value =retObj[0].dev_sign;
			document.getElementById("dev_position").value =retObj[0].dev_position;
			document.getElementById("dev_team").value =retObj[0].team_name;
			document.getElementById("team").value =retObj[0].team;
			document.getElementById("dev_purpose").value =retObj[0].purpose;
			document.getElementById("dev_plan_start_date").value =retObj[0].dev_plan_start_date;
			document.getElementById("dev_plan_end_date").value =retObj[0].dev_plan_end_date;
			//默认时间为原接收时间 -- 给台账ID也拿出来
			document.getElementById("actual_start_date").value = retObj[0].actual_in_time;
			document.getElementById("team_dev_acc_id").value = retObj[0].team_dev_acc_id;
			//设置保养周期
			document.getElementById("maintenance_cycle").value =retObj[0].maintenance_cycle;
			devaccId = retObj[0].dev_acc_id;
			
			//projectInfoNo=retObj[0].project_info_no;
			projectInfoNo = '<%=projectInfoNo%>';
			
		}
	}
	function submitInfo(){
		var taskids;
		$("input[type='hidden'][name$='objcetId']").each(function(i){
			if(i==0){
				taskids = this.value;
			}else{
				taskids += "~"+this.value;
			}
		})
	    var id = '<%=request.getParameter("id")%>';
	    var maintenance_cycle_value = $("option:selected","#maintenance_cycle").text();
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toReSubmitEqReceive.srq?id="+id+"&devaccId="+devaccId+"&projectInfoNo="+projectInfoNo+"&taskids="+taskids+"&maintenance_cycle_value="+maintenance_cycle_value;
		document.getElementById("form1").submit();
	}
	//选择调配单位
	function selectTree(){

	  var teamInfo = {
		  TaskIds:"",
		  Names:"",
		  StartDates:"",
		  EndDates:"",
		  ObjectId:""
	  }; 
	  window.showModalDialog('<%=contextPath%>/p6/tree/selectTree.jsp?projectInfoNo='+projectInfoNo,teamInfo);
	  
	  if(teamInfo.TaskIds != ""){
          
		  var tempTaskIds = teamInfo.TaskIds.split(",");
		  var tempNames = teamInfo.Names.split(",");
		  var tempStartDates = teamInfo.StartDates.split(",");
		  var tempEndDates = teamInfo.EndDates.split(",");
		  var tempObjectId = teamInfo.CheckOther1s.split(",");
		  
		  for(var i=0;i<tempTaskIds.length;i++){
              
			  addLine("",tempTaskIds[i],tempNames[i],tempStartDates[i],tempEndDates[i],tempObjectId[i]);
		  }	  
	  }
	  
	}
	function addLine( receive_nos,task_ids,task_names,plan_start_dates,plan_end_dates,objcet_ids){
		
		var receive_no = "";
		var task_id = "";
		var task_name = "";
		var plan_start_date = "";
		var plan_end_date = "";
		var object_id = "";

		if(receive_nos != null && receive_nos != ""){
			receive_no=receive_nos;
		}
		if(task_ids != null && task_ids != ""){
			task_id=task_ids;
		}
		if(task_names != null && task_names != ""){
			task_name=task_names;
		}
		if(plan_start_dates != null && plan_start_dates != ""){
			plan_start_date=plan_start_dates;
		}
		if(plan_end_dates != null && plan_end_dates != ""){
			plan_end_date=plan_end_dates;
		}
		if(objcet_ids != null && objcet_ids != ""){
			objcet_id=objcet_ids;
		}

		var rowNum = document.getElementById("lineNum").value;	
		var tr = document.getElementById("taskTable").insertRow();
		tr.id = "row_" + rowNum + "_";

	  	if(rowNum % 2 == 1){  
	  		tr.className = "odd";
		}else{ 
			tr.className = "even";
		}	
	   
		tr.insertCell().innerHTML = '<input type="hidden" name="fy'+ rowNum + 'receiveNo" id="fy'+ rowNum + 'receiveNo" value="'+receive_no+'"/>'+(parseInt(rowNum) + 1)+'<input type="hidden" id="fy' + rowNum + 'objcetId" name="fy' + rowNum + 'objcetId" value="'+objcet_id+'"/>';
		tr.insertCell().innerHTML = '<input type="hidden" id="fy' + rowNum + 'taskId" name="fy' + rowNum + 'taskId" value="'+task_id+'"/>'+'<input type="text" readonly="readonly" id="fy' + rowNum + 'taskName" name="fy' + rowNum + 'taskName" value="'+task_name+'"/>';
		
		tr.insertCell().innerHTML = '<input type="text" readonly="readonly" id="fy' + rowNum + 'planStartDate" name="fy' + rowNum + 'planStartDate"  value="'+plan_start_date+'"/>';
		tr.insertCell().innerHTML = '<input type="text" readonly="readonly" id="fy' + rowNum + 'planEndDate" name="fy' + rowNum + 'planEndDate" value="'+plan_end_date+'"/>'+'<input type="hidden"  class="input_width" name="fy' + rowNum + 'bsflag" id="fy' + rowNum + 'bsflag" value="0"/>';
		tr.insertCell().innerHTML = '<input type="text" readonly="readonly"  value="0"/>';
			
		var rowid = "row_" + rowNum + "_";
		tr.insertCell().innerHTML = '<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine('+"'"+rowid+"'"+')"/>';
		document.getElementById("lineNum").value = (parseInt(rowNum) + 1);

	}
	function deleteLine(lineId){		
		var rowNum = lineId.split('_')[1];
		
		var line = document.getElementById(lineId);		

		var bsflag = document.getElementsByName("fy"+rowNum+"bsflag")[0].value;
		if(bsflag!=""){
			line.style.display = 'none';
			document.getElementsByName("fy"+rowNum+"bsflag")[0].value = '1';
		}else{
			line.parentNode.removeChild(line);
		}	
	}
	function deleteTableTr(tableID){
		var tb = document.getElementById(tableID);
	     var rowNum=tb.rows.length;
	     for (i=1;i<rowNum;i++)
	     {
	         tb.deleteRow(i);
	         rowNum=rowNum-1;
	         i=i-1;
	     }
	}
</script>
</html>

