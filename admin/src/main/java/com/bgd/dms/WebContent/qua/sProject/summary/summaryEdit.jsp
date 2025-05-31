<%@page import="java.net.URLDecoder"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String project_info_no = user.getProjectInfoNo();
	if(project_info_no==null){
		project_info_no = "";
	}
	String summary_history_id = request.getParameter("summary_history_id");
	if(summary_history_id==null){
		summary_history_id = "";
	}
	String object_name = request.getParameter("object_name");
	if(object_name==null){
		object_name = "";
	}
	object_name = java.net.URLDecoder.decode(object_name, "utf-8");
	object_name = java.net.URLDecoder.decode(object_name, "utf-8");
	String task_id = request.getParameter("task_id");
	if(task_id==null){
		task_id = "";
	}
	String object_id = request.getParameter("object_id");
	if(object_id==null){
		object_id = "";
	}
	String user_id = user.getUserId();
	String project_type = user.getProjectType();
	if(project_type!=null && project_type.trim().equals("5000100004000000002")){
		project_type = "5000100004000000010";
	}
	String name = "评价单炮数量";
	if(project_type!=null && project_type.trim().equals("5000100004000000009")){
		name = "评价数量";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/qua/sProject/summary/summary.js"></script>
<title></title> 
</head> 
<body><!-- onload="page_init()"> --> 
<div id="new_table_box" align="center">
	<div id="new_table_box_content" > 
		<div id="new_table_box_bg" >
	    	<div id="check"  style="display: block;">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr>
						<td class="inquire_item6">检查总量:</td>
						<td class="inquire_form6" ><input type="text" name="quality_num" id="quality_num" value=""  class="input_width"/></td>
						<td class="inquire_item6">不合格数量:</td>
						<td class="inquire_form6" ><input type="text" name="summary_num" id="summary_num" value="" disabled="disabled"  class="input_width" /></td>
						<td class="inquire_item6">不合格数量占比:</td>
					    <td class="inquire_form6" ><input type="text" name="percent" id="percent" value="" disabled="disabled" class="input_width"/></td>   
					</tr>
				</table>
				<table id="summaryTable" width="100%" border="" cellspacing="0" cellpadding="0" class="tab_info"  >
			    	<tr>
			    		<td class="bt_info_odd"><input type='checkbox' name='summ_entity_id' value='' /></td>
			    	    <td class="bt_info_even">序号</td>
			            <td class="bt_info_odd">检查项名称</td>
			            <td class="bt_info_even">不合格数量</td>
			            <td class="bt_info_odd">不合格检查项占比</td>
			            <td class="bt_info_even"><label id="unit" >小组编号</label></td>
			            <td class="bt_info_odd"> 备注</td>
			        </tr>
			    </table>
			    <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr>
						<td class="inquire_item8">检查日期:</td>
					    <td class="inquire_form8" ><input type="text" name="check_date" id="check_date" value="" disabled="disabled" class="input_width"/>
						    <img width="16" height="16" id="cal_button6" style="cursor: hand;" onmouseover="calDateSelector(check_date,cal_button6);" src="<%=contextPath %>/images/calendar.gif" /></td>
					  	<td class="inquire_item8">责任人:</td>
					    <td class="inquire_form8" >	<input name="duty_name" id="duty_name" type="text" class="input_width" value="" disabled="disabled" /></td> 
					    <td class="inquire_item8">汇总日期:</td>
					    <td class="inquire_form8" ><input type="text" name="summary_date" id="summary_date" value="" disabled="disabled" class="input_width"/>
					    	<img width="16" height="16" id="cal_button7" style="cursor: hand;" onmouseover="calDateSelector(summary_date,cal_button7);" src="<%=contextPath %>/images/calendar.gif" /></td>
					   	<td class="inquire_item8">汇总人:</td>
					   	<td class="inquire_form8"><input type="text" name="summarier" id="summarier"  value="" class="input_width"/></td>
					</tr>
				</table>
			</div>
			<div id="shot" style="display: none;">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr>
						<td class="inquire_item10">&nbsp;&nbsp;&nbsp;<%=name %>:</td>
						<td class="inquire_form10" ><input type="text" name="shot_num" id="shot_num" value="" 
						<%if(project_type!=null && project_type.trim().equals("5000100004000000009")){ %><%}else{ %>
						disabled="disabled" <%} %>class="input_width"/></td>
						<td class="inquire_item10">一级品数量:</td>
						<td class="inquire_form10" ><input type="text" name="first_num" id="first_num" value="6340" 
						<%if(project_type!=null && project_type.trim().equals("5000100004000000009")){ %><%}else{ %>
						disabled="disabled" <%} %> class="input_width"/></td>
						<td class="inquire_item10">二级品数量:</td>
						<td class="inquire_form10" ><input type="text" name="second_num" id="second_num" value="0" disabled="disabled" class="input_width" /></td>
						<td class="inquire_item10">一级品率:</td>
					    <td class="inquire_form10" ><input type="text" name="first_percent" id="first_percent" value="" disabled="disabled" class="input_width"/></td>   
						<td class="inquire_item10">废品数量:</td>
					    <td class="inquire_form10" ><input type="text" name="abandon_num" id="abandon_num" value="8" 
					    <%if(project_type!=null && project_type.trim().equals("5000100004000000009")){ %><%}else{ %>
						disabled="disabled" <%} %> class="input_width"/></td>
					</tr>
				</table>
				<table id="shotTable" width="100%" border="1" cellspacing="0" cellpadding="0" class="tab_info"  >
			    	<tr>
			    		<td class="bt_info_odd"><input type='checkbox' name='shot_entity_id' value=''/></td>
			    	    <td  class="bt_info_even">序号</td>
			            <td  class="bt_info_odd">二级品原因</td>
			            <td class="bt_info_even">二级品数量</td>
			            <td class="bt_info_odd">二级品原因占比</td>
			            <td class="bt_info_even">备注</td>
			        </tr>
		   		</table>
		   		<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr>
						<td class="inquire_item8">评价日期:</td>
						<td class="inquire_form8" ><input type="text" name="evaluate_date" id="evaluate_date" value="" disabled="disabled" class="input_width"/>
							<img width="16" height="16" id="cal_button8" style="cursor: hand;" 
								onmouseover="calDateSelector(evaluate_date,cal_button8);" src="<%=contextPath %>/images/calendar.gif" /></td>
						<td class="inquire_item8">评价人:</td>
						<td class="inquire_form8" ><input type="text" name="evaluate_id" id="evaluate_id" value="" class="input_width" /></td> 
					    <td class="inquire_item8">汇总日期:</td>
						<td class="inquire_form8" ><input  type="text" name="shot_date" id="shot_date" value="" disabled="disabled" class="input_width" />
							<img width="16" height="16" id="cal_button9" style="cursor: hand;" 
								onmouseover="calDateSelector(shot_date,cal_button9);" src="<%=contextPath %>/images/calendar.gif" /></td>
						<td class="inquire_item8">汇总人:</td>
					    <td class="inquire_form8" ><input type="text" name="shot_id" id="shot_id" value="" class="input_width"/></td>   
					</tr>
				</table>
			</div>
			<div id='sql'></div>
		</div>
  		<div id="oper_div">
	 		<span class="bc_btn"><a href="#" onclick="newSubmit()"></a></span>
	 		<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
		</div>
	</div> 
</div> 
<script type="text/javascript">
	cruConfig.contextPath = '<%=contextPath%>';
	var record = 0;
	var shot = 0;
	function refreshData(){
		var summary_history_id = '<%=summary_history_id%>';
		var name = '<%=object_name%>';
		if(name.indexOf('钻井') !=-1 ){
			document.getElementById("unit").innerHTML = '机组号';
		}else{
			document.getElementById("unit").innerHTML = '小组编号';
		}
		if(name.indexOf('单炮') == -1 ){
			
			document.getElementById('check').style.display = "block";
			document.getElementById('shot').style.display = "none";
			showSummaryTable();
			showSummaryNumber();
		}else{
			document.getElementById('check').style.display = "none";
			document.getElementById('shot').style.display = "block";
			showShotTable();
			showShotNumber();
		}
		var project_info_no = '<%=project_info_no%>';
		var objectId = '<%=object_id %>';
		var sql = "select t.duty_person ,u.user_name from bgp_qua_plan t join p_auth_user u on t.duty_person = u.user_id and u.bsflag='0' "+
		" where t.bsflag='0' and t.project_info_no='"+project_info_no+"' and t.object_id ='"+objectId+"' and t.object_name like'%"+name+"%'";
		var obj = syncRequest('Post',cruConfig.contextPath + appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
		if(obj!=null && obj.returnCode =="0"){
			if(obj.datas!=null && obj.datas.length>0){
				var data = obj.datas[0];
				var duty_name = data.user_name;
				document.getElementById("duty_name").value = duty_name;
			}
		}
		var querySql = "select t.checker ,t.check_date ,t.summarier ,t.summary_date "+
		" from bgp_qua_summary_history t"+
		" where t.bsflag='0' and t.summary_history_id ='"+summary_history_id+"'";				 	 
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj!=null && retObj.datas != null && retObj.datas.length>0){
			var map = retObj.datas[0];
			if(map!=null){
				var checker = map.checker;
				var checker_name = map.checker_name;
				var check_date = map.check_date;
				var summarier = map.summarier;
				var summarier_name = map.summarier_name;
				var summary_date = map.summary_date;
				document.getElementById("check_date").value = check_date;
				document.getElementById("summarier").value = summarier;
				document.getElementById("summary_date").value = summary_date;
				document.getElementById("evaluate_date").value = check_date;
				document.getElementById("shot_id").value = summarier;
				document.getElementById("shot_date").value = summary_date;
				
				document.getElementById("evaluate_id").value = checker;
			}
		}
		var project_type = '<%=project_type%>';
		if(project_type!=null && project_type=='5000100004000000009'){
			var querySql = "select t.shot_num ,t.first_num from bgp_qua_summary_history t"+
			" where t.bsflag='0' and t.summary_history_id ='"+summary_history_id+"'";	
			var retObj = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(retObj!=null && retObj.returnCode=='0' && retObj.datas!=null && retObj.datas[0]!=null){
				var shot_num = retObj.datas[0].shot_num ==null?"0":retObj.datas[0].shot_num;
				document.getElementById("shot_num").value = shot_num;
				var first_num = retObj.datas[0].first_num ==null?"0":retObj.datas[0].first_num;
				document.getElementById("first_num").value = first_num;
			}
		}
	}
	refreshData();
	function showSummaryTable(){
		var summary_history_id = '<%=summary_history_id%>';
		var querySql = "select t.summary_id ,t.record_name ,t.record_num ,t.unit_id ,t.notes from bgp_qua_record_summary t "+
		" where t.bsflag='0' and t.summary_history_id ='"+summary_history_id+"'";				 	 
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj.datas != null && retObj.datas.length>0){
			for(var i =0;i<retObj.datas.length;i++){
				var map = retObj.datas[i];
				var summary_id = map.summary_id;
				var record_name = map.record_name;
				var record_num = map.record_num;
				var unit_id = map.unit_id;
				var notes = map.notes;
				var autoOrder = document.getElementById("summaryTable").rows.length;
				var newTR = document.getElementById("summaryTable").insertRow(autoOrder);
				var tdClass = 'even';
				if(autoOrder%2==0){
					tdClass = 'odd';
				}
		        var td = newTR.insertCell(0);
		        td.innerHTML = "<input type='checkbox' name='chk_entity_id' value='"+summary_id+"'/>";
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		        
		        td = newTR.insertCell(1);
		        td.innerHTML = autoOrder;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
		        
		        td = newTR.insertCell(2);
		        td.innerHTML = record_name;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		        record = record -(-record_num);
		       
		        td = newTR.insertCell(3);
		        td.innerHTML = "<input name='record_num' type='text'  value='"+record_num+"' onkeyup='changeRecord(event)' onkeydown='javascript:return checkIfNum(event);' />";
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
		        
		        td = newTR.insertCell(4);
		        td.innerHTML = '';
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		        
		        td = newTR.insertCell(5);
		        td.innerHTML = "<input name='unit_id' type='text' value='"+unit_id+"' />";
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
		        
		        td = newTR.insertCell(6);
		        td.innerHTML = "<input name='notes' type='text' value='"+notes+"' />";
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
			}
		}
		showPercent();
	}
	function showPercent(){
		var rows = document.getElementById("summaryTable").rows;
		if(rows.length == 1){
			return;
		}else{
			var sum = 0;
			var j = 1;
			var get = false;
			var percent =0;
			for(var i = rows.length - 1; i >=1 ;i--){
				var record_num = rows[i].cells[3].firstChild.value;
				percent = 0;
				if(record != 0){
					if(record_num != 0){
						if(!get){
							j = i;
							get = true;
							continue;
						}
					}
					sum = sum - (-((record_num/record)*100).toFixed(2));
					percent = ((record_num/record)*100).toFixed(2)+"%";
				}
				rows[i].cells[4].innerHTML = percent;
			}
			if(sum == 0 && get==false){
				percent = '0.00%';
			}else if(sum == 0 && get==true){
				percent = '100%';
			}else{
				percent = (100 - sum).toFixed(2) + "%";
			}
			if(get){
				rows[j].cells[4].innerHTML = percent;
			}
		}
	}
	function showSummaryNumber(){
		var summary_history_id = '<%=summary_history_id%>';
		var querySql = "select t.quality_num , t.summary_num from bgp_qua_summary_history t"+
		" where t.bsflag='0' and t.summary_history_id ='"+summary_history_id+"'";				 	 
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj.datas != null && retObj.datas.length>0){
			var map = retObj.datas[0];
			if(map!=null){
				var quality_num = map.quality_num;
				var summary_num = map.summary_num;
				document.getElementById("quality_num").value = quality_num;
				document.getElementById("summary_num").value = summary_num;
			}
			var percent = 0;
			var quality_num = document.getElementById("quality_num").value;
			var summary_num = document.getElementById("summary_num").value;
			if(shot_num!=null && first_num!=null && shot_num!='' && first_num!='' && shot_num!='0'){
				percent = ((summary_num/quality_num)*100).toFixed(2)+"%";
				document.getElementById("percent").value = percent; 
			}
		}
	}
	function showShotTable(){
		var summary_history_id = '<%=summary_history_id%>';
		var querySql = "select t.summary_id ,t.record_name ,t.record_num ,t.notes from bgp_qua_record_summary t "+
		" where t.bsflag='0' and t.summary_history_id ='"+summary_history_id+"'";				 	 
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj.datas != null && retObj.datas.length>0){
			for(var i =0;i<retObj.datas.length;i++){
				var map = retObj.datas[i];
				var summary_id = map.summary_id;
				var record_name = map.record_name;
				var record_num = map.record_num;
				var notes = map.notes;
				var autoOrder = document.getElementById("shotTable").rows.length;
				var newTR = document.getElementById("shotTable").insertRow(autoOrder);
				var tdClass = 'even';
				if(autoOrder%2==0){
					tdClass = 'odd';
				}
		        var td = newTR.insertCell(0);
		        td.innerHTML = "<input type='checkbox' name='shot_entity_id' value='"+summary_id+"'/>";
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		        
		        td = newTR.insertCell(1);
		        td.innerHTML = autoOrder;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
		        
		        td = newTR.insertCell(2);
		        td.innerHTML = record_name;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}

		        shot = shot - (-record_num);
		        td = newTR.insertCell(3);
		        td.innerHTML = "<input name='record_num' type='text'  value='"+record_num+"' onkeyup='changeShot(event)' onkeydown='javascript:return checkIfNum(event);' />";
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
		        
		        td = newTR.insertCell(4);
		        td.innerHTML = '';
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		        
		        td = newTR.insertCell(5);
		        td.innerHTML = "<input name='notes' type='text' value='"+notes+"' />";
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
			}
		}
		showFirstPercent();
	}
	function showFirstPercent(){
		var rows = document.getElementById("shotTable").rows;
		
		if(rows.length == 1){
			return;
		}else{
			var sum = 0;
			var j = 1;
			var get = false;
			var percent =0;
			for(var i = rows.length - 1; i >=1 ;i--){
				var record_num = rows[i].cells[3].firstChild.value;
				percent = 0;
				if(shot != 0){
					if(record_num != 0){
						if(!get){
							j = i;
							get = true;
							continue;
						}
					}
					sum = sum - (-((record_num/shot)*100).toFixed(2));
					percent = ((record_num/shot)*100).toFixed(2)+"%";
				}
				rows[i].cells[4].innerHTML = percent;
			}
			if(sum == 0 && get==false){
				percent = '0.00%';
			}else if(sum == 0 && get==true){
				percent = '100%';
			}else{
				percent = (100 - sum).toFixed(2) + "%";
			}
			if(get){
				rows[j].cells[4].innerHTML = percent;
			}
		}
	}
	function showShotNumber(){
		var project_info_no = '<%=project_info_no%>';
		var object_name = '<%=object_name%>';
		var task_id = '<%=task_id%>';
		var querySql = "select (case when sum(t.collect_2_class) is null then 0 else sum(t.collect_2_class) end) second_num ," +
			" (case when sum(t.collect_waster_num) is null then 0 else sum(t.collect_waster_num) end) waster ," +
			" (case when sum(t.daily_acquire_firstlevel_num) is null then 0 else sum(t.daily_acquire_firstlevel_num) end) first ," +
			" (case when sum(t.daily_acquire_sp_num) is null then 0 else sum(t.daily_acquire_sp_num) end) - (-(case when sum(t.daily_jp_acquire_shot_num) is null then 0 else sum(t.daily_jp_acquire_shot_num) end)) - (-(case when sum(t.daily_qq_acquire_shot_num) is null then 0 else sum(t.daily_qq_acquire_shot_num) end)) total ," +
			" sum(t.collect_miss_num) miss from gp_ops_daily_report t " +
			" where t.bsflag='0' and t.project_info_no ='"+project_info_no+"'";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj.datas != null && retObj.datas.length>0){
			for(var i =0;i<retObj.datas.length;i++){
				var map = retObj.datas[i];
				document.getElementById("shot_num").value = map.total;
				document.getElementById("first_num").value = map.first;
				document.getElementById("second_num").value = map.second_num;
				document.getElementById("abandon_num").value = map.waster;
			}
			var first_percent = 0;
			var shot_num = document.getElementById("shot_num").value;
			var first_num = document.getElementById("first_num").value;
			if(shot_num!=null && first_num!=null && shot_num!='' && first_num!='' && shot_num!='0'){
				first_percent = ((first_num/shot_num)*100).toFixed(2)+"%";
				document.getElementById("first_percent").value = first_percent; 
			}
		}
	}
	function changeRecord(event){
		var value =  event.srcElement.value;
		var cellIndex = event.srcElement.parentElement.cellIndex;
		var rowIndex = event.srcElement.parentElement.parentElement.rowIndex;
		var table = document.getElementById("summaryTable");
		record = 0;
		for(var i=1;i<table.rows.length;i++){
			var value = table.rows[i].cells[3].firstChild.value;
			record = record - (-value);
		}
		document.getElementById("summary_num").value = record;
		showPercent();
	}
	function changeShot(event){
		var value =  event.srcElement.value;
		var cellIndex = event.srcElement.parentElement.cellIndex;
		var rowIndex = event.srcElement.parentElement.parentElement.rowIndex;
		var table = document.getElementById("shotTable");
		shot = 0;
		for(var i=1;i<table.rows.length;i++){
			var temp = table.rows[i].cells[3].firstChild.value;
			shot = shot - (-temp);
		}
		var total = document.getElementById("second_num").value;
		if(total<shot){
			value = value.substr(0,value.length-1);
			event.srcElement.value = value;
		}
		shot = 0;
		for(var i=1;i<table.rows.length;i++){
			var temp = table.rows[i].cells[3].firstChild.value;
			shot = shot - (-temp);
		}
		showFirstPercent();
	}
	function newSubmit() {
		var substr ='';
		var user_id = '<%=user_id%>';
		var summary_history_id = '<%=summary_history_id%>';
		var table = document.getElementById("summaryTable");
		if(table!=null && table.rows.length>1){
			
			for(var i=1;i<table.rows.length;i++){
				var tr = table.rows[i];
				var summary_id = tr.cells[0].firstChild.value;
				var record_num = tr.cells[3].firstChild.value;
				var unit_id = tr.cells[5].firstChild.value;
				var notes = tr.cells[6].firstChild.value;
				substr = substr + "update bgp_qua_record_summary t set t.summary_history_id ='"+summary_history_id+"' ,t.updator_id='"+user_id+"' ," +
				" t.modifi_date = sysdate ,t.record_num ='"+record_num+"', t.unit_id ='"+unit_id+"' ,t.notes ='"+notes+"'"+
				" where t.summary_id ='"+summary_id+"';";
			}
			var quality_num = document.getElementById("quality_num").value;
			var summary_num = document.getElementById("summary_num").value;
			var check_date = document.getElementById("check_date").value;
			var checker = document.getElementById("evaluate_id").value;
			var summary_date = document.getElementById("summary_date").value;
			var summarier = document.getElementById("summarier").value;
			substr = substr + "update bgp_qua_summary_history t set t.summary_history_id ='"+summary_history_id+"' ,t.updator_id='"+user_id+"' ," +
			" t.modifi_date = sysdate ,t.quality_num ='"+quality_num+"' ,t.summary_num ='"+summary_num+"' ,t.checker ='"+checker+"' ,t.summarier ='"+summarier+"', "+
			" t.check_date =to_date('"+check_date+"','yyyy-MM-dd') ,t.summary_date =to_date('"+summary_date+"','yyyy-MM-dd')" +
			" where t.summary_history_id ='"+summary_history_id+"';";
		}else{
			table = document.getElementById("shotTable");
			for(var i=1;i<table.rows.length;i++){
				var tr = table.rows[i];
				var summary_id = tr.cells[0].firstChild.value;
				var record_num = tr.cells[3].firstChild.value;
				var notes = tr.cells[5].firstChild.value;
				substr = substr + "update bgp_qua_record_summary t set t.summary_history_id ='"+summary_history_id+"' ,t.updator_id='"+user_id+"' ," +
				" t.modifi_date = sysdate ,t.record_num ='"+record_num+"' ,t.notes ='"+notes+"'"+
				" where t.summary_id ='"+summary_id+"';";
			}
			var check_date = document.getElementById("evaluate_date").value;
			var checker = document.getElementById("evaluate_id").value;
			var summary_date = document.getElementById("shot_date").value;
			var summarier = document.getElementById("shot_id").value;
			
			var shot_num = document.getElementById("shot_num").value;
			var first_num = document.getElementById("first_num").value;
			var abandon_num = document.getElementById("abandon_num").value;
			substr = substr + "update bgp_qua_summary_history t set t.summary_history_id ='"+summary_history_id+"' ,t.updator_id='"+user_id+"' ," +
			" t.modifi_date = sysdate ,t.checker ='"+checker+"' ,t.summarier ='"+summarier+"', "+
			" t.check_date =to_date('"+check_date+"','yyyy-MM-dd') ,t.summary_date =to_date('"+summary_date+"','yyyy-MM-dd')," +
			" t.shot_num ='"+shot_num+"' ,t.first_num ='"+first_num+"' ,t.abandon_num ='"+abandon_num+"'"+
			" where t.summary_history_id ='"+summary_history_id+"';";
		}
		var retObj = jcdpCallService("QualitySrv", "saveQualityBySql", "sql="+substr);
		if(retObj.returnCode=='0'){
			alert("保存成功!");
			top.frames["list"].frames["menuFrame"].frames[0].refreshData();
			newClose();
		} 
	}
</script>
</body>
</html>