<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getEmpId();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());

    String projectInfoNo = request.getParameter("projectInfoNo");
    String action = request.getParameter("action");
    String addButtonDisplay="";
    if("view".equals(action)) addButtonDisplay="none";

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

<!--Remark JavaScript定义-->
<script language="javaScript">
cruConfig.contextPath='<%=contextPath %>';

var cruTitle = "资格证信息";
var jcdp_codes_items = null;
var jcdp_codes = new Array(
);

var jcdp_record = null;
/**
 表单字段要插入的数据库表定义
*/
var tables = new Array(
['bgp_comm_human_receive_process']
);
var defaultTableName = 'bgp_comm_human_receive_process';
/**0字段名，1显示label，2是否显示或编辑：Hide,Edit,ReadOnly，
   3字段类型：TEXT(文本),N(整数),NN(数字),D(日期),EMAIL,ET(英文)，
             MEMO(备注)，SEL_Codes(编码表),SEL_OPs(自定义下拉列表) ，FK(外键型)，
   4最大输入长度，
   5默认值：'CURRENT_DATE'当前日期，'CURRENT_DATE_TIME'当前日期时间，
           编辑或修改时如果为空表示取0字段名对应的值，'{ENTITY.fieldName}'表示取fieldName对应的值，
           其他默认值
   6输入框的长度，7下拉框的值或弹出页面的链接，8 是否非空，取值为non-empty会在输入框后加*
   9 Column Name，10 Event,11 Table Name
*/
	

function page_init(){
	getObj('cruTitle').innerHTML = cruTitle;
	cruConfig.openerUrl = "/rm/singleHuman/humanRequest/taskPlanList.jsp";
	cru_init();
	
}

function save(){
	if(checkForm()){
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/rm/em/toHumanAcceptEdit.srq";
		form.submit();
		newClose();
	}
}
function checkForm(){
	var rowNum = document.getElementById("lineNum").value;
	if(rowNum == "0"){
		alert("请分配一条作业");
		return false;
	}
	if(!notNullForCheck("actual_start_date","实际进入项目时间")) return false;
	
	return true;
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
function save1(){
	
	var project_info_no=document.getElementById("project_info_no").value;
	var employee_id=document.getElementById("employee_id").value;
	var rowNum = document.getElementById("lineNum").value;	

	var rowParams = new Array();
	for(var i=0;i<rowNum;i++){
		var rowParam = {};
						
		var receive_no = document.getElementsByName("receive_no_"+i)[0].value;			
		var task_id = document.getElementsByName("task_id_"+i)[0].value;			
		var task_name = document.getElementsByName("task_name_"+i)[0].value;			
		var plan_start_date = document.getElementsByName("plan_start_date_"+i)[0].value;			
		var plan_end_date = document.getElementsByName("plan_end_date_"+i)[0].value;			
		var bsflag = document.getElementsByName("bsflag_"+i)[0].value;			
				
		rowParam['project_info_no'] = project_info_no;		
		rowParam['employee_id'] = employee_id;		
		rowParam['task_id'] = task_id;		
		rowParam['task_name'] = encodeURI(encodeURI(task_name));		
		rowParam['receive_no'] = receive_no;		
		rowParam['bsflag'] = bsflag;				
		rowParam['plan_start_date'] = plan_start_date;
		rowParam['plan_end_date'] = plan_end_date;

		rowParam['create_date'] = '<%=curDate%>';
		rowParam['modifi_date'] = '<%=curDate%>';

		rowParams[rowParams.length] = rowParam;
	}
		var rows=JSON.stringify(rowParams);

		saveFunc("bgp_comm_human_receive_process",rows);
		
		top.frames('list').refreshData();
}


function page_init(){
	
	var human_detail_no = '<%=request.getParameter("id")%>';	
//	var action = '<%=request.getParameter("action")%>';
	if(human_detail_no!='null'){
		var querySql = "select d.human_detail_no,d.employee_id,e.employee_name,h.employee_cd,cd.coding_name team_name,cd2.coding_name work_post_name,d.plan_start_date,d.plan_end_date,d.actual_start_date,d.notes from  bgp_human_prepare_human_detail d left join comm_human_employee e on d.employee_id = e.employee_id and e.bsflag='0' left join comm_human_employee_hr h on d.employee_id = h.employee_id and h.bsflag='0' left join comm_coding_sort_detail cd on d.team = cd.coding_code_id  left join comm_coding_sort_detail cd2 on d.work_post = cd2.coding_code_id where d.bsflag='0' and d.human_detail_no ='"+human_detail_no+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);		
		var datas = queryRet.datas;
		
		var employee_id = datas[0].employee_id;
		document.getElementById("human_detail_no").value = datas[0].human_detail_no;
		document.getElementById("employee_id").value = datas[0].employee_id;
		document.getElementById("employee_name").value = datas[0].employee_name;
		document.getElementById("employee_cd").value = datas[0].employee_cd;
		document.getElementById("team_name").value = datas[0].team_name;
		document.getElementById("work_post_name").value = datas[0].work_post_name;
		document.getElementById("plan_start_date").value = datas[0].plan_start_date;
		document.getElementById("plan_end_date").value = datas[0].plan_end_date;
		document.getElementById("actual_start_date").value = datas[0].actual_start_date;
		
		var querySql1 = "select t.* from bgp_comm_human_receive_process t where t.bsflag='0' and t.employee_id='"+employee_id+"'";
		var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql1);		
		var datas1 = queryRet1.datas;
		
		for (var i = 0; datas1 && queryRet1.datas.length; i++) {			
			addLine(datas1[i].receive_no,datas1[i].task_id,datas1[i].task_name,datas1[i].plan_start_date,datas1[i].plan_end_date);
		}	
	}

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

function addLine( receive_nos,task_ids,task_names,plan_start_dates,plan_end_dates){
	
	var receive_no = "";
	var task_id = "";
	var task_name = "";
	var plan_start_date = "";
	var plan_end_date = "";

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

	var rowNum = document.getElementById("lineNum").value;	
	var tr = document.getElementById("taskTable").insertRow();
	tr.id = "row_" + rowNum + "_";

  	if(rowNum % 2 == 1){  
  		tr.className = "odd";
	}else{ 
		tr.className = "even";
	}	

	tr.insertCell().innerHTML = '<input type="hidden" name="fy'+ rowNum + 'receiveNo" id="fy'+ rowNum + 'receiveNo" value="'+receive_no+'"/>'+(parseInt(rowNum) + 1);
	tr.insertCell().innerHTML = '<input type="hidden" id="fy' + rowNum + 'taskId" name="fy' + rowNum + 'taskId" value="'+task_id+'"/>'+'<input type="text" readonly="readonly" id="fy' + rowNum + 'taskName" name="fy' + rowNum + 'taskName" value="'+task_name+'"/>';
	tr.insertCell().innerHTML = '<input type="text" readonly="readonly" id="fy' + rowNum + 'planStartDate" name="fy' + rowNum + 'planStartDate"  value="'+plan_start_date+'"/>';
	tr.insertCell().innerHTML = '<input type="text" readonly="readonly" id="fy' + rowNum + 'planEndDate" name="fy' + rowNum + 'planEndDate" value="'+plan_end_date+'"/>'+'<input type="hidden"  class="input_width" name="fy' + rowNum + 'bsflag" id="fy' + rowNum + 'bsflag" value="0"/>';
	tr.insertCell().innerHTML = '<input type="text" readonly="readonly"  value="0"/>';
		
	var rowid = "row_" + rowNum + "_";
	tr.insertCell().innerHTML = '<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine('+"'"+rowid+"'"+')"/>';
	document.getElementById("lineNum").value = (parseInt(rowNum) + 1);

}


//选择调配单位
function selectTree(){

  var teamInfo = {
	  TaskIds:"",
	  Names:"",
	  StartDates:"",
	  EndDates:"",
	  CheckOther1s:""
  }; 
  window.showModalDialog('<%=contextPath%>/p6/tree/selectTree.jsp?projectInfoNo=<%=projectInfoNo%>',teamInfo);
  
  if(teamInfo.TaskIds != ""){

	  var tempTaskIds = teamInfo.TaskIds.split(",");
	  var tempNames = teamInfo.Names.split(",");
	  var tempStartDates = teamInfo.StartDates.split(",");
	  var tempEndDates = teamInfo.EndDates.split(",");
	  var Other1s = teamInfo.CheckOther1s.split(",");
	  
	  for(var i=0;i<tempTaskIds.length;i++){

		  addLine("",Other1s[i],tempNames[i],tempStartDates[i],tempEndDates[i]);
	  }	  
  }
  
}


</script>
</head>
<body onload="page_init();">
<form id="CheckForm" action="" method="post" target="list" >
	<div>
	<table id="lineTable" width="100%" border="0" cellspacing="0" cellpadding="0"  style="margin-top:2px;" >
    	<tr>
    	    <td class="bt_info_odd" width="8%">员工编号</td>
            <td class="bt_info_even" width="8%">员工姓名</td>
            <td class="bt_info_odd" width="10%">班组</td>		
            <td class="bt_info_even" width="10%">岗位</td>
            <td class="bt_info_odd" width="12%">预计进入项目时间</td>			
            <td class="bt_info_even" width="12%">预计离开项目时间</td> 
            <td class="bt_info_odd" width="12%">实际进入项目时间</td>			
            <td class="bt_info_even" width="8%">备注</td> 
        </tr>
        <tr>		
		<td class="even_odd"><input type="hidden" name="human_detail_no" id="human_detail_no" value="" class="input_width" readonly="readonly"/>
		<input type="hidden" name="employee_id" id="employee_id" value="" readonly="readonly"/>
		<input type="hidden" name="project_info_no" id="project_info_no" value="<%=projectInfoNo%>" />
		<input type="text" name="employee_cd" id="employee_cd" value="" readonly="readonly" class="input_width"/></td>
		<td class="odd_even"><input type="text" name="employee_name" id="employee_name" value="" class="input_width"/></td>
		<td class="even_odd"><input type="text" name="team_name" id="team_name" value="" class="input_width"/></td>
		<td class="odd_even"><input type="text" name="work_post_name" id="work_post_name" value="" class="input_width" readonly="readonly"/></td>
		<td class="even_odd"><input type="text" name="plan_start_date" id="plan_start_date" value="" readonly="readonly" class="input_width"/></td>
		<td class="odd_even"><input type="text" name="plan_end_date" id="plan_end_date" class="input_width" value=""  readonly="readonly"/></td>
		<td class="even_odd"><input type="text" name="actual_start_date" id="actual_start_date" value="" readonly="readonly" class="input_width"/>
		<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;"
					onmouseover="calDateSelector(actual_start_date,tributton1);" /></td>
		<td class="odd_even"><input type="text" name="notes" id="notes" value="" class="input_width" /></td>
        </tr>
     </table>
	</div>  

	<div ic="oper_div" align="center">
     	<span class="zj"><a href="#" onclick="selectTree()"></a></span>
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
   <div id="oper_div">
        <span class="bc_btn"><a href="#" onclick="save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</form>
</body>
</html>
