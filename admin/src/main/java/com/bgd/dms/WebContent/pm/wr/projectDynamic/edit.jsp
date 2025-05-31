<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page language="java"  contentType="text/html; charset=UTF-8"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.bgp.mcs.service.rm.dm.equipmentApply.pojo.*"%>
<%@ taglib uri="code" prefix="code"%>

<%
	String contextPath = request.getContextPath();
	String project_info_no = request.getParameter("id");
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
    String userName = (user==null)?"":user.getUserName();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
	String orgId = (user==null)?"":user.getCodeAffordOrgID();
	String orgSubjectionId = (user==null)?"":user.getSubOrgIDofAffordOrg();
	String projectType = request.getParameter("projectType");
    String action = request.getParameter("action");
	String week_date = request.getParameter("week_date");
	String week_end_dates = request.getParameter("week_end_date");
	String message= request.getParameter("message" ) ; 
	System.out.println(message);
	if(message!=null){
		message=URLDecoder.decode(message,"UTF-8");
	}	
    String addButtonDisplay="";
    if("view".equals(action))addButtonDisplay="none";
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.net.URLDecoder"%><html>
<head>
<title>项目情况</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
</head>

<body style="background:#fff">
<form action="<%=contextPath%>/pm/wr/importExcelTemplateTest.srq" id="fileForm" method="post" enctype="multipart/form-data">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
	    <td background="<%=contextPath%>/images/list_15.png">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali3">周报开始日期：</td>
			    <td class="ali1"><input type="text" id="week_date" class="input_width4"  name="week_date" value="" readonly></td>
			    <td class="ali3">周报结束日期：</td>
			    <td class="ali1"><input type="text" id="week_end_date" class="input_width4"  name="week_end_date" value="" readonly></td>
	  <%if(!"view".equals(request.getParameter("action"))) {%>	
      <%if("4".equals(projectType)||"2".equals(projectType)){ %>
			    <td><span class="zj"><a href="#" onclick="addLine()" title="增加数据"></a></span></td>
      <%}else{ %>
      			<td class="ali3"><font color=red>附件：</font></td>
			    <td class="ali1"><input type="file"  id="fileName" name="fileName"></td>
				<input type="hidden"  value="<%=week_date%>" id="ww" name="ww" class="input_width">
				<input type="hidden"  value="<%=projectType%>" id="project_type" name="project_type" class="input_width">
				<input type="hidden"  value="<%=orgId%>" id="org_id" name="org_id" class="input_width">
				<input type="hidden"  value="<%=action%>" id="action" name="action" class="input_width">
				<input type="hidden"  value="<%=orgSubjectionId%>" id="org_subjection_id" name="org_subjection_id" class="input_width">
				<input type="hidden"  value="<%=week_end_dates%>" id="week_end_dates" name="week_end_dates" class="input_width">
			    <td><span class="dr"><a href="#" onclick="uploadFile()" title="导入"></a></span></td>
			    <td><span class="xz"><a href="<%=contextPath%>/pm/wr/projectDynamic/download.jsp?path=/pm/wr/projectDynamic/ImpleDynamic.xlsx&filename=地震采集项目导入模板.xlsx" title="下载模板"></a></span></td>
			    <td><span class="zj"><a href="#" onclick="addLine()" title="增加数据"></a></span></td>
       <%}} %>
			  </tr>
			</table>
		</td>
	    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
	  </tr>
</table>

<table border="0" cellpadding="0" cellspacing="0" id="lineTable" class="form_info" width="100%" style="margin-top:-1px;">
    <tr background="blue" class="bt_info">
      <td class="tableHeader" width="5%">序号</td>
      <%if("4".equals(projectType)){ %>
      <td class="tableHeader" width="15%">项目名称</td>
      <td class="tableHeader" width="10%">甲方名称</td>
      <td class="tableHeader" width="10%">合同额</td>
      <td class="tableHeader" width="10%">项目长</td>
      <td class="tableHeader" width="10%">合同起止日期</td>
      <td class="tableHeader" width="10%">实际执行日期</td>
      <td class="tableHeader" width="25%">项目情况</td>
      <%}else if("2".equals(projectType)){ %>
      <td class="tableHeader" width="15%">项目名称</td>
      <td class="tableHeader" width="10%">队号</td>
      <td class="tableHeader" width="10%">项目状态</td>
      <td class="tableHeader" width="30%">项目情况</td>
      <td class="tableHeader" width="25%">备注</td>
      <%}else{ %>
      <td class="tableHeader" width="15%">项目名称</td>
      <td class="tableHeader" width="10%">甲方名称</td>
      <td class="tableHeader" width="10%">队号</td>
      <td class="tableHeader" width="10%">工作量(设计)</td>
      <td class="tableHeader" width="10%">工作量(完成)</td>
      <td class="tableHeader" width="10%">进度(%)</td>
      <td class="tableHeader" width="10%">项目状态</td>
      <td class="tableHeader" width="10%">不正常原因</td>
      <td class="tableHeader" width="10%">备注</td>
      <%} %>
	  <td class="tableHeader" width="5%" style="display:<%=addButtonDisplay%>"><input type="hidden" id="lineNum" value="0"/>删除</td>    
    </tr>
</table>  

<div id="oper_div">
<%
if(!"view".equals(request.getParameter("action"))){
%>
<span class="bc_btn"><a href="#" onclick="save()"></a></span>
<%	
}
%>
</div>
</form>
</body>
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath%>';
var message='<%=message%>';
function uploadFile(){		
	var filename = document.getElementById("fileName").value;
	if(filename == ""){
		alert("请选择上传附件!");
		return;
	}

	if(check(filename)){
		document.getElementById("fileForm").submit();
	}
		
}
function alertError(str){		
	alert(str);
}
function check(filename){
	var type=filename.match(/^(.*)(\.)(.{1,8})$/)[3];
	type=type.toUpperCase();
	if(type=="XLS" || type=="XLSX"){
	   return true;
	}
	else{
	   alert("上传类型有误，请上传EXCLE文件！");
	   return false;
	}
}

	function initData(){			
		var data=['tableName:BGP_WR_PROJECT_DYNAMIC','text:T','count:N','number:NN','date:D'];
		return data;
	}
	function afterSave(retObject,successHint,failHint){
		if(successHint==undefined) successHint = '提交成功';
		if(failHint==undefined) failHint = '提交失败';
		if (retObject.returnCode != "0") alert(failHint);
		else{
			alert(successHint);
			cancel();
		}
	}
	function cancel()
	{
		//window.parent.getNextTab();
		
	}

	function key_press_check1(obj)
	{
		var keycode = event.keyCode;
		if(keycode > 57 || keycode < 45 || keycode==47)
		{
			return false;
		}
		var reg = /^[0-9]{0,13}(\.[0-9]{0,2})?$/;
		var nextvalue = obj.value+String.fromCharCode(keycode);
		if(!(reg.test(nextvalue)))return false;
		return true;
	}
	//添加详细信息	
	var kbcs=new Array();
	
	
	function addLine(){

		var rowNum = document.getElementById("lineNum").value;	
		//var tr = document.getElementById("lineTable").insertRow();
		//tr.align="center";		

		//tr.id = "row_" + rowNum + "_";

		//tr.insertCell().innerHTML = parseInt(rowNum)+1;
		
		var table=document.getElementById("lineTable");
		var temp = "odd";
		
		if(rowNum%2 == 0){
			//even
			temp = "even";
		} else {
			//odd
			temp = "odd";
		}
		var lineId = "row_" + rowNum + "_";
		var num = parseInt(rowNum)+1;
		
		var elem;
		
		<%if("4".equals(projectType)){ %>
		//tr.insertCell().innerHTML = '<textarea name="project_name' + '_' + rowNum + '"></textarea>';
		//tr.insertCell().innerHTML = '<textarea name="manage_org' + '_' + rowNum + '"></textarea>';
		//tr.insertCell().innerHTML = '<textarea name="contract_amount' + '_' + rowNum + '"></textarea>';
		//tr.insertCell().innerHTML = '<textarea name="project_manager' + '_' + rowNum + '"></textarea>';
		//tr.insertCell().innerHTML = '<textarea name="contract_date' + '_' + rowNum + '" ></textarea>';
		//tr.insertCell().innerHTML = '<textarea name="execution_date' + '_' + rowNum + '"></textarea>';
		//tr.insertCell().innerHTML = '<textarea name="project_note' + '_' + rowNum + '"></textarea>';
		elem=createRow('<tr class="'+temp+'" id="'+lineId+'">'
				+'<td>'+num+'</td>'
				
				+'<td><textarea name="project_name' + '_' + rowNum + '"></textarea></td>'
				+'<td><textarea name="manage_org' + '_' + rowNum + '"></textarea></td>'
				+'<td><textarea name="contract_amount' + '_' + rowNum + '" onkeypress="return key_press_check1(this)"></textarea></td>'
				+'<td><textarea name="project_manager' + '_' + rowNum + '"></textarea></td>'
				+'<td><textarea name="contract_date' + '_' + rowNum + '" ></textarea></td>'
				+'<td><textarea name="execution_date' + '_' + rowNum + '"></textarea></td>'
				+'<td><textarea name="project_note' + '_' + rowNum + '"></textarea></td>'
				
				+'<td><input type="hidden" name="order" value="' + rowNum + '"/>'
				+'<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + lineId + '\')"/>'
				+'<input type="hidden" name="bsflag' + '_' + rowNum + '" value="0"/>'
				+'<input type="hidden" name="dynamic_id' + '_' + rowNum + '" value=""/></td>'
				+'</tr>');
		
		<%}else if("2".equals(projectType)){ %>
		//tr.insertCell().innerHTML = '<textarea name="project_name' + '_' + rowNum + '" ></textarea>';
		//tr.insertCell().innerHTML = '<textarea name="team_name' + '_' + rowNum + '" ></textarea>';
		//tr.insertCell().innerHTML = '<select name="project_status' + '_' + rowNum + '" width="20"><option value="执行">执行</option><option value="结束">结束</option></select>';
		//tr.insertCell().innerHTML = '<textarea name="project_note' + '_' + rowNum + '" ></textarea>';
		//tr.insertCell().innerHTML = '<textarea name="notes' + '_' + rowNum + '" ></textarea>';
		elem=createRow('<tr class="'+temp+'" id="'+lineId+'">'
				+'<td>'+num+'</td>'
				
				+'<td><textarea name="project_name' + '_' + rowNum + '" ></textarea></td>'
				+'<td><textarea name="team_name' + '_' + rowNum + '" ></textarea></td>'
				+'<td><select name="project_status' + '_' + rowNum + '" width="20"><option value="执行">执行</option><option value="结束">结束</option></select></td>'
				+'<td><textarea name="project_note' + '_' + rowNum + '" ></textarea></td>'
				+'<td><textarea name="notes' + '_' + rowNum + '" ></textarea></td>'
				
				+'<td><input type="hidden" name="order" value="' + rowNum + '"/>'
				+'<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + lineId + '\')"/>'
				+'<input type="hidden" name="bsflag' + '_' + rowNum + '" value="0"/>'
				+'<input type="hidden" name="dynamic_id' + '_' + rowNum + '" value=""/></td>'
				+'</tr>');
		<%}else{ %>
		//tr.insertCell().innerHTML = '<input type="text" name="project_name' + '_' + rowNum + '" size="20"/>';
		//tr.insertCell().innerHTML = '<input type="text" name="manage_org' + '_' + rowNum + '" size="10"/>';
		//tr.insertCell().innerHTML = '<input type="text" name="team_name' + '_' + rowNum + '" size="10"/>';
		//tr.insertCell().innerHTML = '<input type="text" name="design_workload' + '_' + rowNum + '" size="10"  onkeypress="return key_press_check1(this)" style="ime-mode:disabled" />';
		//tr.insertCell().innerHTML = '<input type="text" name="complete_workload' + '_' + rowNum + '" size="10"  onkeypress="return key_press_check1(this)" style="ime-mode:disabled" />';
		//tr.insertCell().innerHTML = '<input type="text" name="schedule' + '_' + rowNum + '" size="10"  onkeypress="return key_press_check1(this)" style="ime-mode:disabled" />';
		//tr.insertCell().innerHTML = '<select name="project_status' + '_' + rowNum + '" onchange="showReason(this.value,' + rowNum + ')">' + '<option value="正常">正常</option>'+'<option value="不正常">不正常</option>'+'<option value="结束">结束</option>' + '</select>';
		//tr.insertCell().innerHTML = '<input type="text" name="reason' + '_' + rowNum + '" style="display:none;" size="10"/>&nbsp;';
		//tr.insertCell().innerHTML = '<input type="text" name="notes' + '_' + rowNum + '" size="10"/>';
		elem=createRow('<tr class="'+temp+'" id="'+lineId+'">'
				+'<td>'+num+'</td>'
				
				+'<td><input type="text" name="project_name' + '_' + rowNum + '" size="20"/></td>'
				+'<td><input type="text" name="manage_org' + '_' + rowNum + '" size="10"/></td>'
				+'<td><input type="text" name="team_name' + '_' + rowNum + '" size="10"/></td>'
				+'<td><input type="text" name="design_workload' + '_' + rowNum + '" size="10"  onkeypress="return key_press_check1(this)" style="ime-mode:disabled" /></td>'
				+'<td><input type="text" name="complete_workload' + '_' + rowNum + '" size="10"  onkeypress="return key_press_check1(this)" style="ime-mode:disabled" /></td>'
				+'<td><input type="text" name="schedule' + '_' + rowNum + '" size="10"  onkeypress="return key_press_check1(this)" style="ime-mode:disabled" /></td>'
				+'<td><select name="project_status' + '_' + rowNum + '" onchange="showReason(this.value,' + rowNum + ')">' + '<option value="正常">正常</option>'+'<option value="不正常">不正常</option>'+'<option value="结束">结束</option>' + '</select></td>'
				+'<td><input type="text" name="reason' + '_' + rowNum + '" style="display:none;" size="10"/>&nbsp;</td>'
				+'<td><input type="text" name="notes' + '_' + rowNum + '" size="10"/></td>'
				
				+'<td><input type="hidden" name="order" value="' + rowNum + '"/>'
				+'<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + lineId + '\')"/>'
				+'<input type="hidden" name="bsflag' + '_' + rowNum + '" value="0"/>'
				+'<input type="hidden" name="dynamic_id' + '_' + rowNum + '" value=""/></td>'
				+'</tr>');
		<%} %>
		//var td = tr.insertCell();
		//td.style.display = "<%=addButtonDisplay%>";
		//td.innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/><img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + tr.id + '\')"/>'
		//							+ '<input type="hidden" name="bsflag' + '_' + rowNum + '" value="0"/>'
		//							+ '<input type="hidden" name="dynamic_id' + '_' + rowNum + '" value=""/>';
		
		table.appendChild(elem);		
		
		document.getElementById("lineNum").value = parseInt(rowNum) + 1;
		
	}	
	
	function createRow(html){
	    var div=document.createElement("div");
	    html="<table><tbody>"+html+"</tbody></table>"
	    div.innerHTML=html;
	    return div.lastChild.lastChild;
	}
	
	function deleteLine(lineId){		
		var rowNum = lineId.split('_')[1];
		var line = document.getElementById(lineId);		

		var dynamic_id = document.getElementsByName("dynamic_id_"+rowNum)[0].value;
		if(dynamic_id!=""){
			line.style.display = 'none';
			document.getElementsByName("bsflag_"+rowNum)[0].value = '1';
		}else{
			line.parentNode.removeChild(line);
		}	
	}

	function showReason(value,rowNum){
		if(value=='不正常'){
			document.getElementsByName("reason_"+rowNum)[0].style.display="";
		}else{
			document.getElementsByName("reason_"+rowNum)[0].style.display="none";
		}
	}
	
	function save(){
		
		var week_date=document.getElementById("week_date").value;
			
		var rowParams = new Array();
		var orders=document.getElementsByName("order");
		for(var i=0;i<orders.length;i++){
			var rowParam = {};
			var order = orders[i].value;		
			var bsflag = document.getElementsByName("bsflag_"+order)[0].value; 
			var dynamic_id = document.getElementsByName("dynamic_id_"+order)[0].value;
			
			<%if("4".equals(projectType)){ %>			

			var project_name = document.getElementsByName("project_name_"+order)[0].value;	
			var manage_org = document.getElementsByName("manage_org_"+order)[0].value;
			var contract_amount = document.getElementsByName("contract_amount_"+order)[0].value;
			var project_manager = document.getElementsByName("project_manager_"+order)[0].value;
			var contract_date = document.getElementsByName("contract_date_"+order)[0].value;
			var execution_date = document.getElementsByName("execution_date_"+order)[0].value;
			var project_note = document.getElementsByName("project_note_"+order)[0].value;

			rowParam['project_name'] = encodeURIComponent(encodeURIComponent(project_name));
			rowParam['manage_org'] = encodeURIComponent(encodeURIComponent(manage_org.replace('&','')));
			rowParam['contract_amount'] = encodeURIComponent(encodeURIComponent(contract_amount));
			rowParam['project_manager'] = encodeURIComponent(encodeURIComponent(project_manager));
			rowParam['contract_date'] = encodeURIComponent(encodeURIComponent(contract_date));
			rowParam['execution_date'] = encodeURIComponent(encodeURIComponent(execution_date));
			rowParam['project_note'] = encodeURIComponent(encodeURIComponent(project_note));

			<%}else if("2".equals(projectType)){ %>		

			var project_name = document.getElementsByName("project_name_"+order)[0].value;	
			var team_name = document.getElementsByName("team_name_"+order)[0].value;
			var project_status = document.getElementsByName("project_status_"+order)[0].value; 
			var project_note = document.getElementsByName("project_note_"+order)[0].value;
			var notes = document.getElementsByName("notes_"+order)[0].value; 
			
			rowParam['project_name'] = encodeURIComponent(encodeURIComponent(project_name));
			rowParam['team_name'] = encodeURIComponent(encodeURIComponent(team_name));
			rowParam['project_status'] = encodeURIComponent(encodeURIComponent(project_status));
			rowParam['project_note'] = encodeURIComponent(encodeURIComponent(project_note));
			rowParam['notes'] = encodeURIComponent(encodeURIComponent(notes));
			
			<%}else{%>

			var project_name = document.getElementsByName("project_name_"+order)[0].value;	
			var manage_org = document.getElementsByName("manage_org_"+order)[0].value;
			var team_name = document.getElementsByName("team_name_"+order)[0].value;
			var design_workload = document.getElementsByName("design_workload_"+order)[0].value;
			var complete_workload = document.getElementsByName("complete_workload_"+order)[0].value;
			var schedule = document.getElementsByName("schedule_"+order)[0].value;
			var project_status = document.getElementsByName("project_status_"+order)[0].value; 
			var notes = document.getElementsByName("notes_"+order)[0].value; 
			var reason = document.getElementsByName("reason_"+order)[0].value;

			rowParam['project_name'] = encodeURIComponent(encodeURIComponent(project_name));
			rowParam['manage_org'] = encodeURIComponent(encodeURIComponent(manage_org));
			rowParam['team_name'] = encodeURIComponent(encodeURIComponent(team_name));
			rowParam['design_workload'] = design_workload;
			rowParam['complete_workload'] = complete_workload;
			rowParam['schedule'] = schedule;
			rowParam['project_status'] = encodeURIComponent(encodeURIComponent(project_status));
			rowParam['reason'] = encodeURIComponent(encodeURIComponent(reason));
			rowParam['notes'] = encodeURIComponent(encodeURIComponent(notes));
			
			<%}%>

			rowParam['dynamic_id'] = dynamic_id;
			rowParam['week_date'] = week_date;
			rowParam['project_type'] = '<%=projectType%>';
			rowParam['create_user'] = encodeURIComponent(encodeURIComponent('<%=userName%>'));
			rowParam['mondify_user'] = encodeURIComponent(encodeURIComponent('<%=userName%>'));
			rowParam['create_date'] = '<%=curDate%>';
			rowParam['mondify_date'] = '<%=curDate%>';	
			rowParam['org_id'] = '<%=orgId%>';
			rowParam['org_subjection_id'] = '<%=orgSubjectionId%>';		
			rowParam['bsflag'] = bsflag;
			rowParam['subflag'] = '0';
			
			rowParams[rowParams.length] = rowParam;
		}
		var rows=JSON.stringify(rowParams);
		
		saveFunc("BGP_WR_PROJECT_DYNAMIC",rows);	
	}

	var data_org_id = '<%=request.getParameter("org_id")%>';
	var data_week_date = '<%=request.getParameter("week_date")%>';
	var data_week_end_date = '<%=request.getParameter("week_end_date")%>';
	var action = '<%=request.getParameter("action")%>';
	if(data_week_date!='null'){
		document.getElementsByName("week_date")[0].value = data_week_date;
		document.getElementsByName("week_end_date")[0].value = data_week_end_date;
		var querySql = "select t.* from BGP_WR_PROJECT_DYNAMIC t where t.bsflag='0' and project_type='<%=projectType%>' and t.org_id = '" + data_org_id + "' and to_char(t.week_date,'yyyy-MM-dd') = '" + data_week_date + "'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		
		//如果datas为空，并且是新增或修改页面，进行数据抽取
		if(action!='view' && datas.length==0){
			var opName = '';
			if('4'=='<%=projectType%>'){
				opName = 'getSIProjectDynamicInfo';
			}else if('3'=='<%=projectType%>'){
				opName = 'getIPCEProjectDynamicInfo';
			}else if('1'=='<%=projectType%>'){
				opName = 'getProjectDynamicInfo';
			}
			if(opName!=''){
				queryRet = jcdpCallService('DataExtractSrv',opName,'week_date='+data_week_date+'&week_end_date='+data_week_end_date+'&org_id='+data_org_id+'&project_type=<%=projectType%>');
				datas = queryRet.datas;
			}
		}// 抽取完成
		
		for (var i = 0; datas && i < datas.length; i++) {
			addLine();
			document.getElementsByName("dynamic_id_"+i)[0].value=datas[i].dynamic_id ? datas[i].dynamic_id : "";

			<%if("4".equals(projectType)){ %>			
			
			document.getElementsByName("project_name_"+i)[0].value=datas[i].project_name ? datas[i].project_name : "";
			document.getElementsByName("manage_org_"+i)[0].value=datas[i].manage_org ? datas[i].manage_org : "";
			document.getElementsByName("contract_amount_"+i)[0].value=datas[i].contract_amount ? datas[i].contract_amount : "";
			document.getElementsByName("project_manager_"+i)[0].value=datas[i].project_manager ? datas[i].project_manager : "";
			document.getElementsByName("contract_date_"+i)[0].value=datas[i].contract_date ? datas[i].contract_date : "";
			document.getElementsByName("execution_date_"+i)[0].value=datas[i].execution_date ? datas[i].execution_date : "";
			document.getElementsByName("project_note_"+i)[0].value=datas[i].project_note ? datas[i].project_note : "";
									
			<%}else if("2".equals(projectType)){ %>		
			document.getElementsByName("project_name_"+i)[0].value=datas[i].project_name ? datas[i].project_name : "";
			document.getElementsByName("team_name_"+i)[0].value=datas[i].team_name ? datas[i].team_name : "";

			var select = document.getElementsByName("project_status_"+i)[0];
			for(var j=0;j<select.options.length;j++){
				if(select.options[j].value==(datas[i].project_status ? datas[i].project_status : "")){
					select.selectedIndex=j;
					break;
				}
			}
			
			document.getElementsByName("project_note_"+i)[0].value=datas[i].project_note ? datas[i].project_note : "";
			document.getElementsByName("notes_"+i)[0].value=datas[i].notes ? datas[i].notes : "";
			
			<%}else{%>
			document.getElementsByName("project_name_"+i)[0].value=datas[i].project_name ? datas[i].project_name : "";
			document.getElementsByName("manage_org_"+i)[0].value=datas[i].manage_org ? datas[i].manage_org : "";			
			document.getElementsByName("team_name_"+i)[0].value=datas[i].team_name ? datas[i].team_name : "";
			document.getElementsByName("design_workload_"+i)[0].value=datas[i].design_workload ? datas[i].design_workload : "";
			document.getElementsByName("complete_workload_"+i)[0].value=datas[i].complete_workload ? datas[i].complete_workload : "";
			document.getElementsByName("schedule_"+i)[0].value=datas[i].schedule ? datas[i].schedule : "";
			document.getElementsByName("notes_"+i)[0].value=datas[i].notes ? datas[i].notes : "";
			document.getElementsByName("reason_"+i)[0].value=datas[i].reason ? datas[i].reason : "";
			
			if(datas[i].project_status=='不正常')document.getElementsByName("reason_"+i)[0].style.display="";
			
			var select = document.getElementsByName("project_status_"+i)[0];
			for(var j=0;j<select.options.length;j++){
				if(select.options[j].value==(datas[i].project_status ? datas[i].project_status : "")){
					select.selectedIndex=j;
					break;
				}
			}
			<%}%>
		}

	}
	if(message!='null'){
		alert(message);	
	}

	function ButtonOnClick(){
		editUrl = "<%=contextPath%>/pm/wr/projectDynamic/DynamicImportFile.jsp?week_date="+data_week_date+"&project_type=<%=projectType%>&org_id="+data_org_id+"&org_subjection_id=<%=orgSubjectionId%>&week_end_date="+data_week_end_date+"&action="+action;
	     // showModalDialog(editUrl,'','dialogWidth:900px;dialogHeight:500px;status:yes');
	         window.location=editUrl+"&backUrl="+cruConfig.currentPageUrl;
	 
 
		}
	
</script>
</html>
