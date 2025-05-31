<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String ids = request.getParameter("ids");
	String mixId = request.getParameter("mixId");
	String mixTypeId = request.getParameter("mixTypeId");
	String currentpage = request.getParameter("currentpage");
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
    <input id="mixId" name="mixId"  class="input_width" type="hidden" value="<%=mixId%>" />
    <input id="mix_type_id" name="mix_type_id"  class="input_width" type="hidden" value="<%=mixTypeId%>" />
    <fieldset style="margin-left:2px"><legend>设备信息</legend>
    	<table id="devTable" width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:2px;">
    	<tr>   
					    <td class="bt_info_even">设备名称</td>
					    <td class="bt_info_odd">规格型号</td>
					    <td class="bt_info_even">单位</td>
					    <td class="bt_info_odd">实物标识号</td>
					    <td class="bt_info_even">自编号</td>
					    <td class="bt_info_odd">牌照号</td>
					    <td class="bt_info_even">实际进场时间</td>
					    <td class="bt_info_odd">保养周期</td>
					    <td class="bt_info_even">存放地</td>
					    <td class="bt_info_odd">班组</td>
					    <td class="bt_info_even">用途</td>
					    <td class="bt_info_odd">计划进场时间</td>
					    <td class="bt_info_even">计划离场时间</td>
					  </tr>
					  <tbody id="assign_body"></tbody>
    </table>
    </fieldset>
      
      <fieldset style="margin-left:2px"><legend>添加作业信息</legend>
      	<div ic="oper_div" align="center">
     		 <auth:ListButton functionId="" css="zj" event="onclick='selectTree()'" title="JCDP_btn_add"></auth:ListButton>
     		
    	</div>
    	<div>
	<table id="taskTable" width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:2px;">
    	<tr class="bt_info">
    	    
    	    <td>序号</td>
            <td>作业名称</td>
            <td>计划开始时间</td>		
            <td>计划结束时间</td>
            <td>原定工期</td>			
            <td>操作<input type="hidden" id="lineNum" name="lineNum" value="0"/></td>			
        </tr>
    </table>
    </div>
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
				var selected_id = this.id;
				$('#tr'+selected_id).remove();
			});
		});
	});
	var devaccId="";
	var projectInfoNo="";
	function loadDataDetail(){
		var device_mix_detids = "<%=ids%>";
		var retObj;
		if(device_mix_detids!=null){
		    var querysql="select plan.maintenance_cycle,mif.project_info_no,dad.*,";
		    	querysql+="da.dev_name,da.dev_model,unit.coding_name as dev_unit,da.dev_position,";
		    	querysql+="teamid.coding_name as team_name,mif.in_org_id,mif.out_org_id ";
		    	querysql+="from gms_device_appmix_detail dad ";
				querysql+="left join gms_device_appmix_main dam on dam.device_mix_subid =dad.device_mix_subid ";
				querysql+="left join gms_device_mixinfo_form mif on mif.device_mixinfo_id =dam.device_mixinfo_id ";
				querysql+="left join gms_device_account da on dad.dev_acc_id = da.dev_acc_id ";
				querysql+="left join gms_device_maintenance_plan plan on da.dev_acc_id = plan.dev_acc_id ";
				querysql+="left join comm_coding_sort_detail teamid on dad.team=teamid.coding_code_id ";
				querysql+="left join comm_coding_sort_detail unit on da.dev_unit=unit.coding_code_id ";
				querysql+="where dad.device_mix_detid in "+device_mix_detids;
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querysql);
		        retObj = queryRet.datas;
			var by_body1 = $("#assign_body", "#devTable")[0];
			var objlength = retObj.length;
			for (var i = 0; i < retObj.length; i++) {
				var newTr = by_body1.insertRow();
				var newTd0 = newTr.insertCell();
				newTd0.innerHTML = "<input id='dev_name"+i+"' name='dev_name"+i+"' type='hidden' value='"+retObj[i].dev_name+"' /> "+retObj[i].dev_name;
				var newTd1 = newTr.insertCell();
				newTd1.innerHTML = "<input id='dev_model"+i+"' name='dev_model"+i+"' type='hidden' value='"+retObj[i].dev_model+"' /> "+retObj[i].dev_model;
				var newTd2 = newTr.insertCell();
				newTd2.innerText = retObj[i].dev_unit;
				var newTd3 = newTr.insertCell();
				newTd3.innerText = retObj[i].dev_sign;
				var newTd4 = newTr.insertCell();
				newTd4.innerText = retObj[i].self_num;
				var newTd5 = newTr.insertCell();
				newTd5.innerText = retObj[i].license_num;
				var newTd6 = newTr.insertCell();
				newTd6.innerHTML = "<font color=red>*</font><input type='text' id='actual_start_date"+i+"' name='actual_start_date"+i+"' value='"+retObj[i].dev_plan_start_date+"' style='width:70'/><img src='<%=contextPath%>/images/calendar.gif' id='tributton1"+i+"' width='16' height='16' style='cursor: hand;'"+
					" onmouseover='calDateSelector(actual_start_date"+i+",tributton1"+i+");' />";
				var newTd7 = newTr.insertCell();
				newTd7.innerHTML = "<font color=red>*</font><select id='maintenance_cycle"+i+"' name='maintenance_cycle"+i+"' devciinfo='"+retObj[i].dev_ci_code+"' style='width:40px;' onchange='changeMCV("+i+",this)'><input type='hidden' id='maintenance_cycle_value"+i+"' name='maintenance_cycle_value"+i+"' value=''><input id='dev_in_org"+i+"' name='dev_in_org"+i+"' type='hidden' value='"+retObj[i].in_org_id+"' /><input id='dev_out_org"+i+"' name='dev_out_org"+i+"' value='"+retObj[i].out_org_id+"' type='hidden' />";
				var newTd8 = newTr.insertCell();
				newTd8.innerText = retObj[i].dev_position;
				var newTd9 = newTr.insertCell();
				newTd9.innerHTML = retObj[i].team_name+"<input id='team"+i+"' name='team"+i+"' type='hidden' value='"+ retObj[i].team+"' >";
				var newTd10 = newTr.insertCell();
				newTd10.innerText = retObj[i].purpose;
				var newTd11 = newTr.insertCell();
				newTd11.innerHTML = "<input id='dev_plan_start_date"+i+"' name='dev_plan_start_date"+i+"' type='hidden' value='"+retObj[i].dev_plan_start_date+"' /> "+retObj[i].dev_plan_start_date;
				var newTd12 = newTr.insertCell();
				newTd12.innerHTML = "<input id='dev_plan_end_date"+i+"' name='dev_plan_end_date"+i+"' type='hidden' value='"+retObj[i].dev_plan_end_date+"' /> "+retObj[i].dev_plan_end_date;
				if(i==0){
					devaccId = retObj[i].dev_acc_id;
				}else{
					devaccId += "~"+retObj[i].dev_acc_id;
				}
				
			}
			$("#assign_body>tr:odd>td:odd",'#devTable').addClass("odd_odd");
			$("#assign_body>tr:odd>td:even",'#devTable').addClass("odd_even");
			$("#assign_body>tr:even>td:odd",'#devTable').addClass("even_odd");
			$("#assign_body>tr:even>td:even",'#devTable').addClass("even_even");
	
			projectInfoNo=retObj[0].project_info_no;
			
			//作业标签－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
			var querySql = "select p6.* from gms_device_account_dui dui left join gms_device_receive_process dp on dui.dev_acc_id=dp.dev_acc_id left join bgp_p6_activity p6 on dp.task_id=p6.object_id where dui.fk_device_appmix_id='"+retObj[0].device_appmix_id+"'";
			
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);		
			var datas = queryRet.datas;
			deleteTableTr("taskTable");
			if(datas != null){
				for (var i = 0; i< queryRet.datas.length; i++) {
					addLine( "",datas[i].id,datas[i].name,datas[i].planned_start_date,datas[i].planned_finish_date,datas[i].object_id)
				}
			}
			//给这个值回填了
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
				for(var j=0;j<objlength;j++){
					$("#maintenance_cycle"+j).append(optionhtml);
					$("#maintenance_cycle_value"+j).val($("#maintenance_cycle"+j+" option:selected").text());
				}
			}
		}
	}
	function changeMCV(i,selectobj){
		var textinfo = $("option:selected","#maintenance_cycle"+i).text();
		var valinfo = $("option:selected","#maintenance_cycle"+i).val();
		var devciinfo = selectobj.devciinfo;
		//给devcicode相同的都更改值
		$("select[id^='maintenance_cycle'][devciinfo='"+devciinfo+"']").val(valinfo);
		$("input[type='hidden'][id^='maintenance_cycle_value']").val(textinfo);
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
	function submitInfo(){
		//校验 实际进场时间
		var validflag = true;
		$("input[type='text'][name^='actual_start_date']").each(function(i){
			if(this.value == ""){
				validflag = false;
			}
		})
		if(!validflag){
			alert("请输入实际进场时间!");
			return;
		}
		var taskids;
		$("input[type='hidden'][name$='objcetId']").each(function(i){
			if(i==0){
				taskids = this.value;
			}else{
				taskids += "~"+this.value;
			}
		});
		var id = "<%=request.getParameter("ids")%>";
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSavePLReceive.srq?id="+id+"&devaccId="+devaccId+"&projectInfoNo="+projectInfoNo+"&taskids="+taskids+"&mixId=<%=mixId%>&currentpage=<%=currentpage%>";
		document.getElementById("form1").submit();
	}
</script>
</html>

