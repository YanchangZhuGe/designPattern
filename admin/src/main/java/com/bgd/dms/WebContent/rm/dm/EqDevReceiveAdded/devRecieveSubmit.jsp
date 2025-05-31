<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String id = request.getParameter("id");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgOfSubId = user.getSubOrgIDofAffordOrg();
	String dgFlag = "";
	//判断是否为大港用户(由于大港项目projectType可能有多种，所以使用用户隶属组织机构ID来判断)
	if(orgOfSubId.startsWith("C105007")){
		dgFlag = "Y";
	}else{
		dgFlag = "N";
	}
	String projectInfoNo = user.getProjectInfoNo();
	String mixId = request.getParameter("mixId");
	String mixTypeId = request.getParameter("mixTypeId");
	String projectType = user.getProjectType();

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
<input id="mixId" name="mixId" type="hidden" value="<%=mixId%>" />
<input id="mix_type_id" name="mix_type_id"  class="input_width" type="hidden" value="<%=mixTypeId%>" />
<input type="hidden" id="device_out_detid" name="device_out_detid"></input>
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">   	    
	    <fieldset style="margin-left:2px"><legend>接收确认信息</legend>
	      <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	      	<tr>
			  	<td class="inquire_item6">存放地(省份+库房)</td>
				<td class="inquire_form6" colspan="3">
				<select id="province" name="province" class="select_width" style="width: 30%;"> 
					<option value="安徽省">安徽省</option>
					<option value="澳门特别行政区">澳门特别行政区</option>
					<option value="北京市">北京市</option>
					<option value="重庆市">重庆市</option>
					<option value="福建省">福建省</option>
					<option value="甘肃省">甘肃省</option>
					<option value="广东省">广东省</option>
					<option value="广西壮族自治区">广西壮族自治区</option>
					<option value="贵州省">贵州省</option>
					<option value="海南省">海南省</option>
					<option value="河北省">河北省</option>
					<option value="黑龙江省">黑龙江省</option>
					<option value="河南省">河南省</option>
					<option value="湖北省">湖北省</option>
					<option value="湖南省">湖南省</option>
					<option value="江苏省">江苏省</option>
					<option value="江西省">江西省</option>
					<option value="吉林省">吉林省</option>
					<option value="辽宁省">辽宁省</option>
					<option value="内蒙古">内蒙古</option>
					<option value="宁夏回族自治区">宁夏回族自治区</option>
					<option value="青海省">青海省</option>
					<option value="陕西省">陕西省</option>
					<option value="山东省">山东省</option>
					<option value="上海市">上海市</option>
					<option value="山西省">山西省</option>
					<option value="四川省">四川省</option>
					<option value="台湾">台湾</option>
					<option value="天津市">天津市</option>
					<option value="香港特别行政区">香港特别行政区</option>
					<option value="新疆维吾尔族自治区">新疆维吾尔族自治区</option>
					<option value="西藏自治区">西藏自治区</option>
					<option value="云南省">云南省</option>
					<option value="浙江省">浙江省</option>
				</select>&nbsp;&nbsp;&nbsp;&nbsp;
				<input id="dev_position" name="dev_position" class="input_width" type="text" style="width: 60%; float: none;margin-bottom: 7px;height:20px;line-height:20px;"/>
				</td>
			</tr>
	      	<tr>
				<td class="inquire_item6">实际进场时间</td>
				<td class="inquire_form6">
					<input type="text" name="actual_start_date" id="actual_start_date" value="" readonly="readonly" class="input_width" style="height:20px;line-height:20px;"/>
					<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(actual_start_date,tributton1);" />
				</td>
			</tr>
		  </table>
	    </fieldset>
        <fieldset id="addTaskInfo" style="margin-left:2px"><legend>添加作业信息</legend>
	      	<div ic="oper_div" align="center">
	     		 <auth:ListButton functionId="" css="zj" event="onclick='selectTree()'" title="JCDP_btn_add"></auth:ListButton>
	    	</div>
	    	<div>
				<table id="taskTable" width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:2px;">
			    	<tr class="bt_info">
			    	     <td class="bt_info_odd">序号</td>
			            <td class="bt_info_even">作业名称</td>
			            <td class="bt_info_odd">计划开始时间</td>
			            <td class="bt_info_even">计划结束时间</td>
			            <td class="bt_info_odd">原定工期</td>
			            <td class="bt_info_even">操作<input type="hidden" id="lineNum" name="lineNum" value="0"/></td>			
			        </tr>
			    </table>
	    	</div>
      </fieldset>
      
      <fieldset style="margin-left:2px"><legend></legend>
      	<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_mix_detid_{device_mix_detid}' name='device_mix_detid'>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{team_name}">班组</td>
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_model}">规格型号</td>
					<td class="bt_info_odd" exp="{dev_unit}">计量单位</td>
					<td class="bt_info_even" exp="{self_num}">自编号</td>
					<td class="bt_info_odd" exp="{license_num}">牌照号</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_even" exp="{dev_plan_start_date}">计划进场时间</td>
					<td class="bt_info_odd" exp="{dev_plan_end_date}">计划离场时间</td>
			     </tr> 
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
			</fieldset>
      
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
var dg_Flag="<%=dgFlag%>";
var mixTypeId = '<%=mixTypeId%>';
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';

	$().ready(function(){
		//判断是否显示"添加作业信息"--dongzhi井中和大港不添加作业信息
		if(projectType == "5000100004000000008" || dg_Flag == "Y"){
			document.getElementById("addTaskInfo").style.display="none";
		}
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
	var projectInfoNo="<%=projectInfoNo%>";
	var projectType="<%=projectType%>";
	function loadDataDetail(){
		var device_out_detid = '<%=id%>';
		
		document.getElementById("device_out_detid").value = device_out_detid;
		var temp = device_out_detid.split(",");
		var idss = "";		
		var retObj,queryRet;
		if(device_out_detid!=null){
		    var querysql="select plan.maintenance_cycle,dt.*,acc.dev_name,acc.dev_model,acc.dev_unit,acc.dev_position,"+
	    				"case dt.state when '0' then '未接收' when '9' then '已接收'  else '未接收' end as state_desc, "+
						"teamid.coding_name as team_name from gms_device_equ_outdetail_added dt "+
						"left join gms_device_account acc on acc.dev_acc_id=dt.dev_acc_id "+
						"left join comm_coding_sort_detail teamid on dt.team=teamid.coding_code_id "+
						"left join gms_device_maintenance_plan plan on dt.dev_acc_id = plan.dev_acc_id "+
						"where dt.device_oif_detid in (";

						for(var i=0;i<temp.length;i++){
							if(idss!="") idss += ",";
							idss += "'"+temp[i]+"'";
						}
						querysql = querysql+idss+")";
						cruConfig.queryStr = querysql;
						queryData(cruConfig.currentPage);	
		}
	}
	function submitInfo(){
		var taskids="";
		$("input[type='hidden'][name$='objcetId']").each(function(i){
			if(i==0){
				taskids = this.value;
			}else{
				taskids += "~"+this.value;
			}
		})
	    var id = '<%=request.getParameter("id")%>';
	    if(projectType != "5000100004000000008" && dg_Flag == "N" ){
	   		if(taskids==""){
				alert("请填加作业信息！");
				return;
		    }
		}
	    if(confirm("确认提交？")){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSubmitAddedEqReceive.srq?id="+id+"&devaccId="+devaccId+"&projectInfoNo="+projectInfoNo+"&taskids="+taskids+"&mixtype="+mixTypeId;
			document.getElementById("form1").submit();
			document.getElementById("submitButton").onclick = "";
	    }
	}
	//选择调配单位
	function selectTree(){

	  var teamInfo = {
		  TaskIds:"",
		  Names:"",
		  StartDates:"",
		  EndDates:"",
		  ObjectId:"",
		  PlannedDurations:""
	  }; 
	  window.showModalDialog('<%=contextPath%>/p6/tree/selectTreeWz.jsp?projectInfoNo='+projectInfoNo,teamInfo);
	  
	  if(teamInfo.TaskIds != ""){         
		  var tempTaskIds = teamInfo.TaskIds.split(",");
		  var tempNames = teamInfo.Names.split(",");
		  var tempStartDates = teamInfo.StartDates.split(",");
		  var tempEndDates = teamInfo.EndDates.split(",");
		  var tempObjectId = teamInfo.CheckOther1s.split(",");
		  var temPlannedDurations = teamInfo.PlannedDurations.split(",");
		  
		  for(var i=0;i<tempTaskIds.length;i++){             
			  addLine("",tempTaskIds[i],tempNames[i],tempStartDates[i],tempEndDates[i],tempObjectId[i],temPlannedDurations[i]);
		  }	  
	  }	  
	}
	function addLine( receive_nos,task_ids,task_names,plan_start_dates,plan_end_dates,objcet_ids,planned_durations){
		
		var receive_no = "";
		var task_id = "";
		var task_name = "";
		var plan_start_date = "";
		var plan_end_date = "";
		var object_id = "";
		var planned_duration = "";
		
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
		if(planned_durations != null && planned_durations != ""){
			planned_duration=planned_durations;
		}
		
		var rowNum = document.getElementById("lineNum").value;	
		var tr = document.getElementById("taskTable").insertRow();
		tr.id = "row_" + rowNum + "_";
		tr.displayinfo = 'show';
	  	if(rowNum % 2 == 1){  
	  		tr.className = "odd";
		}else{ 
			tr.className = "even";
		}	
	   
		tr.insertCell().innerHTML = '<input type="hidden" name="fy'+ rowNum + 'receiveNo" id="fy'+ rowNum + 'receiveNo" value="'+receive_no+'"/>';
		tr.insertCell().innerHTML = '<input type="hidden" id="fy' + rowNum + 'objcetId" name="fy' + rowNum + 'objcetId" value="'+objcet_id+'"/>'+'<input type="hidden" id="fy' + rowNum + 'taskId" name="fy' + rowNum + 'taskId" value="'+task_id+'"/>'+'<input type="text" readonly="readonly" id="fy' + rowNum + 'taskName" name="fy' + rowNum + 'taskName" value="'+task_name+'"/>';
		
		tr.insertCell().innerHTML = '<input type="text" readonly="readonly" id="fy' + rowNum + 'planStartDate" name="fy' + rowNum + 'planStartDate"  value="'+plan_start_date+'"/>';
		tr.insertCell().innerHTML = '<input type="text" readonly="readonly" id="fy' + rowNum + 'planEndDate" name="fy' + rowNum + 'planEndDate" value="'+plan_end_date+'"/>'+'<input type="hidden"  class="input_width" name="fy' + rowNum + 'bsflag" id="fy' + rowNum + 'bsflag" value="0"/>';
		tr.insertCell().innerHTML = '<input type="text" readonly="readonly"  value="'+planned_duration+'"/>';
			
		var rowid = "row_" + rowNum + "_";
		tr.insertCell().innerHTML = '<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine('+"'"+rowid+"'"+')"/>';
		document.getElementById("lineNum").value = (parseInt(rowNum) + 1);
		resetShowNum();
	}
	function deleteLine(lineId){		
		var rowNum = lineId.split('_')[1];
		
		var line = document.getElementById(lineId);		

		var bsflag = document.getElementsByName("fy"+rowNum+"bsflag")[0].value;
		if(bsflag!=""){
			line.style.display = 'none';
			line.displayinfo = 'none';
			document.getElementsByName("fy"+rowNum+"bsflag")[0].value = '1';
		}else{
			line.parentNode.removeChild(line);
		}	
		resetShowNum();
	}
	function resetShowNum(){
		//更新序号
		$("tr[displayinfo='show']","#taskTable").each(function(i){
			var colcells = this.cells;
			colcells[0].innerHTML = (i+1);
			if(i % 2 == 1){  
		  		this.className = "odd";
			}else{ 
				this.className = "even";
			}
		});
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

