<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.bgp.gms.service.rm.em.pojo.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ taglib uri="code" prefix="code"%> 
<%@ taglib prefix="auth" uri="auth"%>

<%
String contextPath = request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String userName = (user==null)?"":user.getEmpId();
SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
String curDate = format.format(new Date());

String projectInfoNo = request.getParameter("projectInfoNo");
String employeeId = request.getParameter("employeeId");

String projectType = user.getProjectType();	
if(projectType.equals("5000100004000000008")){
	projectType="5000100004000000001";
}
if(projectType.equals("5000100004000000010")){
	projectType="5000100004000000001";
} 
if(projectType.equals("5000100004000000002")){
	projectType="5000100004000000001";
}


%>

 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script> 
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
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<script type="text/javascript">
cruConfig.contextPath='<%=contextPath %>';

function sucess() {

	if(checkForm()){
	 
		var rowNum = document.getElementById("lineNum").value;	  
		var employeeId=document.getElementById("employeeId").value; 
		var projectInfoNo=document.getElementById("projectInfoNo").value; 
				
		var rowParams = new Array();
		for(var i=0;i<rowNum;i++){
			var rowParam = {};
							
			var position_no = document.getElementsByName("position_no_"+i)[0].value;			
			var team = document.getElementsByName("team_"+i)[0].value;			
			var work_post = document.getElementsByName("work_post_"+i)[0].value;			
			var actual_start_date = document.getElementsByName("actual_start_date_"+i)[0].value;			
			var actual_end_date = document.getElementsByName("actual_end_date_"+i)[0].value;			
			var evaluation = document.getElementsByName("evaluation_"+i)[0].value;			
			var bsflag = document.getElementsByName("bsflag_"+i)[0].value;			
			
			rowParam['position_no'] = position_no;		
			rowParam['project_info_no'] = projectInfoNo;		
			rowParam['employee_id'] = employeeId;		
			rowParam['bsflag'] = bsflag;		
			rowParam['team'] = team;
			rowParam['work_post'] = work_post;
			rowParam['actual_start_date'] = actual_start_date;
			rowParam['actual_end_date'] = actual_end_date;
			rowParam['evaluation'] = evaluation;

			rowParam['creator'] = '<%=userName%>';
			rowParam['updator'] = '<%=userName%>';
			rowParam['create_date'] = '<%=curDate%>';
			rowParam['modifi_date'] = '<%=curDate%>';

			rowParams[rowParams.length] = rowParam;
		}
			var rows=JSON.stringify(rowParams);

			saveFunc("bgp_human_position_change",rows);	
			top.frames('list').refreshData();
			newClose();
	}
}

function checkForm(){
	
	var rowNum = document.getElementById("lineNum").value;	
	var isCheck=true;
	for(var i=0;i<rowNum;i++){
		var bsflag = document.getElementById("bsflag_"+i).value;
		if(bsflag == "0"){
			isCheck=false;
			if(!notNullForCheck("team_"+i,"班组")) return false;
			if(!notNullForCheck("work_post_"+i,"岗位")) return false;
			//if(!notNullForCheck("evaluation_"+i,"评价")) return false;
			if(!notNullForCheck("actual_start_date_"+i,"进入时间")) return false;
			if(!notNullForCheck("actual_end_date_"+i,"离开时间")) return false;
		}
	}

	if(isCheck){
		alert("请添加一条记录");
		return false;
	}else{
		return true;
	}
}


function notNullForCheck(filedName,fieldInfo){

	if(document.getElementById(filedName).value==null||document.getElementById(filedName).value==""){
		alert(fieldInfo+"不能为空");
		document.getElementById(filedName).onfocus="true";
		return false;
	}else{
		return true;
	}
}
function isNumberForCheck(filedName,fieldInfo){
	var valNumber = document.getElementById(filedName).value;
	var re=/^[1-9]+[0-9]*]*$/;
	if(valNumber!=null&&valNumber!=""){
		if(!re.test(valNumber)){
			alert(fieldInfo+"格式不正确,请重新输入");
			return false;
		}else{
			return true;
		}
	}else{
		return true;
	}
}



function substrin(str)
{ 
	str = Math.round(str * 10000) / 10000;
	return(str); 
 }



function deleteLine(lineId){		
	var rowNum = lineId.split('_')[1];
	var line = document.getElementById(lineId);		

	var bsflag = document.getElementsByName("bsflag_"+rowNum)[0].value;
	if(bsflag!=""){
		line.style.display = 'none';
		document.getElementsByName("bsflag_"+rowNum)[0].value = '1';
	}else{
		line.parentNode.removeChild(line);
	}	

}


//加一行人员
function addLine(position_nos,teams,work_posts,actual_start_dates,actual_end_dates,evaluations){
	
	var position_no = "";
	var team = "";
	var work_post = "";
	var actual_start_date = "";
	var actual_end_date = "";
	var evaluation = "";
	
	if(position_nos != null && position_nos != ""){
		position_no=position_nos;
	}
	if(teams != null && teams != ""){
		team=teams;
	}
	if(work_posts != null && work_posts != ""){
		work_post=work_posts;
	}
	if(actual_start_dates != null && actual_start_dates != ""){
		actual_start_date=actual_start_dates;
	}
	if(actual_end_dates != null && actual_end_dates != ""){
		actual_end_date=actual_end_dates;
	}
	if(evaluations != null && evaluations != ""){
		evaluation=evaluations;
	}

	var rowNum = document.getElementById("lineNum").value;	

	var tr = document.getElementById("lineTable").insertRow();
	
	tr.align="center";		

	tr.id = "row_" + rowNum + "_";
	
	if(rowNum % 2 == 1){  
  		classCss = "even_";
	}else{ 
		classCss = "odd_";
	}

	var startDates = "actual_start_date_"+rowNum;
	var endDates = "actual_end_date_"+rowNum;
	
	var td = tr.insertCell(0);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="hidden" name="position_no' + '_' + rowNum + '" id="position_no' + '_' + rowNum + '" value="'+position_no+'"/>'+(parseInt(rowNum) + 1);
		
	var td = tr.insertCell(1);
	td.className=classCss+"even";
	td.innerHTML = '<select class="input_width" id="team' + '_' + rowNum + '" name="team' + '_' + rowNum + '" onchange="getPost('+rowNum+')" >'+getApplyTeam(team)+'</select>';

	if(work_post == ""){
		//请选择			
		var td = tr.insertCell(2);
		td.className=classCss+"odd";
		td.innerHTML = '<select class="input_width"  name="work_post' + '_' + rowNum + '" id="work_post' + '_' + rowNum + '" > <option value="">请选择</option> </select>';
	}else{	
		//选择岗位值
		var td = tr.insertCell(2);
		td.className=classCss+"odd";
		td.innerHTML = '<select class="input_width" name="work_post' + '_' + rowNum + '" id="work_post' + '_' + rowNum + '" >'+getPostForList(team,work_post)+'</select>';
	}
	
	var td = tr.insertCell(3);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" class="input_width"  readonly="readonly" onpropertychange="calDays('+rowNum+')" id="actual_start_date' + '_' + rowNum + '"  name="actual_start_date' + '_' + rowNum + '" value="'+actual_start_date+'" />'+'<img src="<%=contextPath%>/images/calendar.gif" id="tributton1'+rowNum+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+startDates+',tributton1'+rowNum+');" />';
	
	var td = tr.insertCell(4);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" class="input_width"  readonly="readonly"  onpropertychange="calDays('+rowNum+')"  id="actual_end_date' + '_' + rowNum + '" name="actual_end_date' + '_' + rowNum + '" value="'+actual_end_date+'" />'+'<img src="<%=contextPath%>/images/calendar.gif" id="tributton2'+rowNum+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+endDates+',tributton2'+rowNum+');" />';
	
	var td = tr.insertCell(5);
	td.className=classCss+"even";
	td.innerHTML = '<select class="input_width" id="evaluation' + '_' + rowNum + '" name="evaluation' + '_' + rowNum + '" >'+queryEvaluateLevel(evaluation)+'</select>';

	var td = tr.insertCell(6);
	td.className=classCss+"odd";
	
	var rowid = "row_" + rowNum + "_";
	td.innerHTML = '<input type="hidden" name="bsflag' + '_' + rowNum + '" id="bsflag' + '_' + rowNum + '" value="0"/>'+'<input type="hidden" name="order" value="' + rowNum + '"/><img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine('+"'"+rowid+"'"+')"/>';
	document.getElementById("lineNum").value = (parseInt(rowNum) + 1);
	
}
 
//得到所有班组
var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeamP","");	

function getApplyTeam( selectValue){

	var applypost_str='<option value="">请选择</option>';
	for(var i=0;i<applyTeamList.detailInfo.length;i++){
		var templateMap = applyTeamList.detailInfo[i];
		//选择当前班组
		if(templateMap.value == selectValue || templateMap.label == selectValue){
			applypost_str+='<option value="'+templateMap.value+'" selected="selected" >'+templateMap.label+'</option>';			
		}else{
			applypost_str+='<option value="'+templateMap.value+'" >'+templateMap.label+'</option>';
		}
	}
	
	return applypost_str;

}


function getPost(i){
    var applyTeam = "applyTeam="+document.getElementById("team_"+i).value;   
	var applyPost=jcdpCallService("HumanCommInfoSrv","queryApplyPostList",applyTeam);	

	var selectObj = document.getElementById("work_post_"+i);
	document.getElementById("work_post_"+i).innerHTML="";
	selectObj.add(new Option('请选择',""),0);
	if(applyPost.detailInfo!=null){
		for(var i=0;i<applyPost.detailInfo.length;i++){
			var templateMap = applyPost.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
		}
	}
}

//根据岗位值获得下拉框的值
function getPostForList( apply_team,post ){

    var applyTeam = "applyTeam="+apply_team;   
	content = encodeURI(applyTeam);
	content = encodeURI(applyTeam);
	var applyPost=jcdpCallService("HumanCommInfoSrv","queryApplyPostList",applyTeam);	

	var apppost_str='<option value="">请选择</option>';
	for(var i=0;i<applyPost.detailInfo.length;i++){
		var templateMap = applyPost.detailInfo[i];
		if(templateMap.value == post || templateMap.label== post){
			apppost_str+='<option value="'+templateMap.value+'" selected="selected">'+templateMap.label+'</option>';
		}else{
			apppost_str+='<option value="'+templateMap.value+'"  >'+templateMap.label+'</option>';
		}

	}
	return apppost_str;
}

var evaluateList=jcdpCallService("HumanCommInfoSrv","queryEvaluateLevel","");	

function queryEvaluateLevel( selectValue){

	var applypost_str='<option value="">请选择</option>';
	for(var i=0;i<evaluateList.detailInfo.length;i++){
		var templateMap = evaluateList.detailInfo[i];
		//选择当前班组
		if(templateMap.value == selectValue || templateMap.label == selectValue){
			applypost_str+='<option value="'+templateMap.value+'" selected="selected" >'+templateMap.label+'</option>';			
		}else{
			applypost_str+='<option value="'+templateMap.value+'" >'+templateMap.label+'</option>';
		}
	}
	
	return applypost_str;

}


function calDays(i){
	var startTime = document.getElementById("fy"+i+"planStartDate").value;
	var returnTime = document.getElementById("fy"+i+"planEndDate").value;
	if(startTime!=null&&startTime!=''&&returnTime!=null&&returnTime!=''){
	var days=(new Date(returnTime.replace(/-/g,'/'))-new Date(startTime.replace(/-/g,'/')))/3600/24/1000;
	if(days<0){
		alert("预计离开项目时间应大于预计进入项目时间");
		return false;
	}else{
		return true;
	}
	}
	return true;
}

function page_init(){
	
	var projectInfoNo = '<%=request.getParameter("projectInfoNo")%>';	
	var employeeId = '<%=request.getParameter("employeeId")%>';	

	var querySql = "select t.project_info_no,t.employee_id,t.employee_name,t.actual_start_date,t.actual_end_date,t.team,t.work_post,d1.coding_name team_name,d2.coding_name work_post_name,t.employee_gz,d3.coding_name employee_gz_name  from view_human_project_relation t  left join comm_coding_sort_detail d1 on t.team = d1.coding_code_id  and d1.bsflag='0' and d1.coding_mnemonic_id='<%=projectType%>' left join comm_coding_sort_detail d2 on t.work_post = d2.coding_code_id  and d2.bsflag='0' and d2.coding_mnemonic_id='<%=projectType%>'  left join comm_coding_sort_detail d3 on t.EMPLOYEE_GZ=d3.coding_code_id where t.project_info_no =  '"+projectInfoNo+"' and t.employee_id='"+employeeId+"'  order by t.EMPLOYEE_GZ,t.EMPLOYEE_NAME ";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);		
	var datas = queryRet.datas;
	
	if(datas != null && queryRet.datas.length>0){
		document.getElementById("employeeName").value = datas[0].employee_name;
		document.getElementById("employeeId").value = datas[0].employee_id;
		document.getElementById("projectInfoNo").value = datas[0].project_info_no;
		document.getElementById("actualStartDate").value = datas[0].actual_start_date;
		document.getElementById("actualEndDate").value = datas[0].actual_end_date;
		document.getElementById("teamName").value = datas[0].team_name;
		document.getElementById("workPostName").value = datas[0].work_post_name;

	}
	
	var querySql1 = "SELECT pc.position_no,pc.team,pc.work_post,pc.evaluation, d3.coding_name team_name,d4.coding_name work_post_name, pc.actual_start_date, pc.actual_end_date,d1.coding_name evaluation_name FROM bgp_human_position_change pc left join comm_coding_sort_detail d1 on pc.evaluation = d1.coding_code_id left join comm_coding_sort_detail d3 on pc.team = d3.coding_code_id  and d3.bsflag='0' and d3.coding_mnemonic_id='<%=projectType%>'  left join comm_coding_sort_detail d4 on pc.work_post = d4.coding_code_id  and d4.bsflag='0' and d4.coding_mnemonic_id='<%=projectType%>'  where pc.bsflag = '0'  and pc.project_info_no = '"+projectInfoNo+"' and pc.employee_id ='"+employeeId+"'   order by pc.actual_start_date ";
	var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql1);		
	var datas1 = queryRet1.datas;
	
	if(datas1 != null){
		for (var i = 0; datas1 && queryRet1.datas.length; i++) {			
			addLine(datas1[i].position_no,datas1[i].team,datas1[i].work_post,datas1[i].actual_start_date,datas1[i].actual_end_date,datas1[i].evaluation);
		}
	}

}

</script>
<title>员工变更修改</title>
</head>
<body onload="page_init();"  style="overflow-y:auto"> 
<form id="CheckForm" name="Form0" action="" method="post"  target="list">
<div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
<tr> 
	<td class="inquire_item6">姓名：</td>
	<td class="inquire_form6">
	<input type="text" id="employeeName" name="employeeName" value="" />
	<input type="hidden" id="employeeId" name="employeeId" value="" />
	<input type="hidden" id="projectInfoNo" name="projectInfoNo" value="<%=projectInfoNo%>" />	 
	</td>
	<td class="inquire_item6">班组：</td>
	<td class="inquire_form6">
	<input type="text" id="teamName" name="teamName" value="" />
	</td>
	<td class="inquire_item6">岗位：</td>
	<td class="inquire_form6">
	<input type="text" id="workPostName" name="workPostName" value="" />
	</td>
</tr>	
<tr> 
	<td class="inquire_item6">实际进入时间：</td>
	<td class="inquire_form6">
	<input type="text" id="actualStartDate" name="actualStartDate" value="" />	 
	</td>
	<td class="inquire_item6">实际离开时间：</td>
	<td class="inquire_form6">
	<input type="text" id="actualEndDate" name="actualEndDate" value="" />
	</td>
	<td class="inquire_item6">&nbsp;</td>
	<td class="inquire_form6">&nbsp;</td>
</tr>	
</table>
</div>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
  <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
  <td background="<%=contextPath%>/images/list_15.png">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr align="right">
  <td>&nbsp;</td>
  <td> 
  <auth:ListButton functionId="" css="zj" event="onclick='addLine()'" title="JCDP_btn_add"></auth:ListButton>
  </td>
</tr>
</table>
</td>
  <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
</tr>
</table>
 
<table border="0"  width="100%"  cellspacing="0" cellpadding="0" class="tab_info" id="lineTable">
	<tr> 
	  <td class="bt_info_odd" width="3%">序号</td> 
      <td class="bt_info_even" width="10%">班组</td>
      <td class="bt_info_odd" width="10%">岗位</td>		
      <td class="bt_info_even" width="12%">进入时间</td>		           
      <td class="bt_info_odd" width="12%">离开时间</td>					
      <td class="bt_info_even" width="10%">评价</td> 
      <td class="bt_info_odd" width="3%">操作 
		<input type="hidden" id="lineNum" value="0"/>
	  </td> 
	</tr>

</table>	 
 
<div id="oper_div">
    <span class="bc_btn"><a href="#" onclick="sucess()"></a></span>
    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
</div>

</form>
</body>
</html>