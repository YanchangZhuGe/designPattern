<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.bgp.gms.service.rm.em.pojo.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getEmpId();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    String projectInfoNo = user.getProjectInfoNo();
	String laborCategory = request.getParameter("laborCategory");
	
	String projectType = user.getProjectType();	
	String projectType_zj = user.getProjectType();	
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

<!--Remark JavaScript定义-->
<script language="javaScript">
cruConfig.contextPath='<%=contextPath %>';

var projectType_zj="<%=projectType_zj%>";
function save1(){
	
	if(checkForm()){
		
		var rowNum = document.getElementById("equipmentSize").value;		
		var rowParams = new Array();
		
		for(var i=0;i<rowNum;i++){
			var rowParam = {};
			
			var labor_deploy_id = document.getElementsByName("fy"+ i + "labor_deploy_id")[0].value;						
			var end_date = document.getElementsByName("fy"+ i + "end_date")[0].value;			
			var notes = document.getElementsByName("fy"+ i + "notes")[0].value;			
						
			rowParam['labor_deploy_id'] = labor_deploy_id;
			rowParam['end_date'] = end_date;
			rowParam['notes'] = encodeURI(encodeURI(notes));
			rowParam['modifi_date'] = '<%=curDate%>';

			rowParams[rowParams.length] = rowParam;
		}
			var rows=JSON.stringify(rowParams);
			saveFunc("bgp_comm_human_labor_deploy",rows);	
			top.frames('list').refreshData();
			newClose();
	}

}

function save(){
	
	if(checkForm()){
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/rm/em/toLaborReturnEdit.srq";
		form.submit();
		newClose();
	}

}

function checkForm(){
	var deviceCount = document.getElementById("equipmentSize").value;
	var isCheck=true;
	for(var i=0;i<deviceCount;i++){			
		if(!notNullForCheck("fy"+i+"endDate","离开时间")) return false;
	}
	return true;

}

function copyEsimiDate(){ 
	var infoSize = document.getElementById("equipmentSize").value;
	var date1 = document.getElementById("fy0endDate").value;
	for(var i=0;i<infoSize;i++){
		document.getElementById("fy"+i+"endDate").value=date1;
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

function addLine(emp_types,labor_deploy_ids,labor_ids,employee_names,employee_id_code_nos,apply_team_names,post_names,task_names,start_dates,end_dates,numss,notess,project_father_nos){
	var emp_type = "";
	var labor_deploy_id = "";
	var labor_id = "";
	var employee_name = "";
	var employee_id_code_no = "";
	var apply_team_name = "";
	var post_name = "";
	var task_name = "";
	var start_date = "";
	var end_date = "";
	var nums = "";
	var notes = "";
	var project_father_no ="";
	if(emp_types != null && emp_types != ""){
		emp_type=emp_types;
	}
	if(labor_deploy_ids != null && labor_deploy_ids != ""){
		labor_deploy_id=labor_deploy_ids;
	}
	if(labor_ids != null && labor_ids != ""){
		labor_id=labor_ids;
	}
	if(employee_names != null && employee_names != ""){
		employee_name=employee_names;
	}
	if(employee_id_code_nos != null && employee_id_code_nos != ""){
		employee_id_code_no=employee_id_code_nos;
	}
	if(apply_team_names != null && apply_team_names != ""){
		apply_team_name=apply_team_names;
	}
	if(post_names != null && post_names != ""){
		post_name=post_names;
	}
	if(task_names != null && task_names != ""){
		task_name=task_names;
	}
	if(start_dates != null && start_dates != ""){
		start_date=start_dates;
	}
	if(end_dates != null && end_dates != ""){
		end_date=end_dates;
	}
	if(numss != null && numss != ""){
		nums=numss;
	}	
	if(notess != null && notess != ""){
		notes=notess;
	}
	if(project_father_nos != null && project_father_nos != ""){
		project_father_no=project_father_nos;
	}
	
	var rowNum = document.getElementById("equipmentSize").value;	
	var tr = document.getElementById("lineTable").insertRow();
	tr.id = "row_" + rowNum + "_";
	
	if(rowNum % 2 == 1){  
  		classCss = "even_";
	}else{ 
		classCss = "odd_";
	}	

	var endDates = "fy"+ rowNum + "endDate";
	
	var td = tr.insertCell(0);
	td.className=classCss+"odd";
	td.innerHTML =  '<input type="hidden" name="fy'+ rowNum + 'empType" id="fy'+ rowNum + 'empType" value="'+emp_type+'"/>'+'<input type="hidden" name="fy'+ rowNum + 'projectFatherNo" id="fy'+ rowNum + 'projectFatherNo" value="'+project_father_no+'"/>'+'<input type="hidden" name="fy'+ rowNum + 'laborDeployId" id="fy'+ rowNum + 'laborDeployId" value="'+labor_deploy_id+'"/>'+(parseInt(rowNum) + 1);
	
	var td = tr.insertCell(1);
	td.className=classCss+"even";
	td.innerHTML = '<input type="hidden" name="fy'+ rowNum + 'laborId" id="fy'+ rowNum + 'laborId" value="'+labor_id+'"/>'+'<input type="text" readonly="readonly" name="fy'+ rowNum + 'employeeName" id="fy'+ rowNum + 'employeeName"  value="'+employee_name+'" class="input_width" onFocus="this.select()"/>';
	
	var td = tr.insertCell(2);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" readonly="readonly"  class="input_width" name="fy'+ rowNum + 'employeeIdCodeNo" id="fy'+ rowNum + 'employeeIdCodeNo"  value="'+employee_id_code_no+'" onFocus="this.select()"/>';

	var td = tr.insertCell(3);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" readonly="readonly" name="fy'+ rowNum + 'applyTeamName" id="fy'+ rowNum + 'applyTeamName"  value="'+apply_team_name+'" class="input_width"  />';
	
	var td = tr.insertCell(4);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" readonly="readonly" name="fy'+ rowNum + 'postName" id="fy'+ rowNum + 'postName"  value="'+post_name+'" class="input_width"  />';
    if( projectType_zj !='5000100004000000008'){
		var td = tr.insertCell(5);
		td.className=classCss+"odd";
		td.innerHTML = '<input type="text" readonly="readonly"  class="input_width" name="fy'+ rowNum + 'taskName" id="fy'+ rowNum + 'taskName"  value="'+task_name+'"  />';
		
		var td = tr.insertCell(6);
		td.className=classCss+"even";
		td.innerHTML = '<input type="text" class="input_width"  readonly="readonly" name="fy'+ rowNum + 'startDate" id="fy'+ rowNum + 'startDate" value="'+start_date+'" />';
		
		var td = tr.insertCell(7);
		td.className=classCss+"odd";
		td.innerHTML = '<input type="text" class="input_width" readonly="readonly"  onpropertychange="calDays('+rowNum+')" name="fy'+ rowNum + 'endDate" id="fy'+ rowNum + 'endDate"  value="'+end_date+'" />'+'<img src="<%=contextPath%>/images/calendar.gif" id="tributton2'+rowNum+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+endDates+',tributton2'+rowNum+');" />';
	
		var td = tr.insertCell(8);
		td.className=classCss+"even";
		td.innerHTML = '<input type="text" class="input_width"  readonly="readonly" name="fy'+ rowNum + 'nums" id="fy'+ rowNum + 'nums"  value="'+nums+'" />';
	
		var td = tr.insertCell(9);
		td.className=classCss+"odd";
		td.innerHTML = '<input type="text" class="input_width"   name="fy'+ rowNum + 'notes" id="fy'+ rowNum + 'notes" value="'+notes+'" />';
			
		document.getElementById("equipmentSize").value = (parseInt(rowNum) + 1);
    }else{
    	
		var td = tr.insertCell(5);
		td.className=classCss+"even";
		td.innerHTML = '<input type="text" class="input_width"  readonly="readonly" name="fy'+ rowNum + 'startDate" id="fy'+ rowNum + 'startDate" value="'+start_date+'" />';
		
		var td = tr.insertCell(6);
		td.className=classCss+"odd";
		td.innerHTML = '<input type="text" class="input_width" readonly="readonly"  onpropertychange="calDays('+rowNum+')" name="fy'+ rowNum + 'endDate" id="fy'+ rowNum + 'endDate"  value="'+end_date+'" />'+'<img src="<%=contextPath%>/images/calendar.gif" id="tributton2'+rowNum+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+endDates+',tributton2'+rowNum+');" />';
	
		var td = tr.insertCell(7);
		td.className=classCss+"even";
		td.innerHTML = '<input type="text" class="input_width"  readonly="readonly" name="fy'+ rowNum + 'nums" id="fy'+ rowNum + 'nums"  value="'+nums+'" />';
	
		var td = tr.insertCell(8);
		td.className=classCss+"odd";
		td.innerHTML = '<input type="text" class="input_width"   name="fy'+ rowNum + 'notes" id="fy'+ rowNum + 'notes" value="'+notes+'" />';
			
		document.getElementById("equipmentSize").value = (parseInt(rowNum) + 1);
    	
    }
}



function calDays(i){
	var startTime = document.getElementById("fy"+ i + "startDate").value;
	var returnTime = document.getElementById("fy"+ i + "endDate").value;
	if(startTime!=null&&startTime!=''&&returnTime!=null&&returnTime!=''){
		var days=(new Date(returnTime.replace(/-/g,'/'))-new Date(startTime.replace(/-/g,'/')))/3600/24/1000;
		if(days<0){
			alert("计划离开时间应大于计划进入时间");
			return false;
		}else{
			document.getElementById("fy"+ i + "nums").value = days+1;
			return true;
		}
	}
	return true;
}

function page_init(){
	
	var detail_ids = "<%=request.getParameter("id")%>";	
	if(detail_ids!='null'){
		var querySql = "select 'edit' emp_type, t.labor_deploy_id,  t.project_father_no,      t.labor_id,        l.employee_name,        l.employee_id_code_no,        t.project_info_no,        t.start_date,    case when    (select wmsys.wm_concat(l.task_id)   from bgp_comm_human_receive_labor l   where l.bsflag = '0'  and l.deploy_detail_id = d2.deploy_detail_id)  is null  then  t.actual_start_date  else  nvl(t.actual_start_date,t.start_date) end actual_start_date  ,    t.end_date,  t.notes,  d2.deploy_detail_id,        d2.apply_team,        d2.post,        d3.coding_name apply_team_name,        d4.coding_name post_name,        round( case when nvl(t.end_date, sysdate) - t.start_date > 0 then nvl(t.end_date, sysdate) - t.start_date  -(-1) else 0 end ) nums ,(select wmsys.wm_concat(l.task_id) from bgp_comm_human_receive_labor l where l.bsflag='0' and l.deploy_detail_id=d2.deploy_detail_id) task_name from bgp_comm_human_labor_deploy t   left join bgp_comm_human_deploy_detail d2 on t.labor_deploy_id = d2.labor_deploy_id and d2.bsflag='0'  left join bgp_comm_human_labor l on t.labor_id = l.labor_id   left join comm_coding_sort_detail d3 on d2.apply_team = d3.coding_code_id  and d3.bsflag='0' and d3.coding_mnemonic_id='<%=projectType%>'     left join comm_coding_sort_detail d4 on d2.post = d4.coding_code_id  and d4.bsflag='0' and d4.coding_mnemonic_id='<%=projectType%>'   where t.bsflag = '0' and t.labor_deploy_id in (<%=request.getParameter("id")%>) union  all  select 'add' emp_type, dt.ptdetail_id  labor_deploy_id , '' project_father_no,dt.employee_id labor_id,dt.employee_name,dt.employee_cd employee_id_code_no,t.project_info_no   ,dt.start_date,dt.start_date actual_start_date,dt.end_date,dt.notes,'' deploy_detail_id ,dt.team_s apply_team,dt.post_s post ,dt.team_name,dt.work_post_name  post_name,round(case  when nvl(dt.end_date, sysdate) -   dt.start_date > 0 then   nvl(dt.end_date, sysdate) - dt.start_date - (-1)   else     0    end) days,''  task_name  from  BGP_COMM_HUMAN_PT_DETAIL dt    left join comm_coding_sort_detail cd3 on dt.notes = cd3.coding_code_id    left join gp_task_project t on dt.bproject_info_no= t.project_info_no   left join bgp_comm_human_labor l on dt.employee_id = l.labor_id    where dt.bsflag='0' and  dt.pk_ids='add' and dt.ptdetail_id in (<%=request.getParameter("id")%>) ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		for (var i = 0; datas && queryRet.datas.length; i++) {			
			addLine(datas[i].emp_type,datas[i].labor_deploy_id,datas[i].labor_id,datas[i].employee_name,datas[i].employee_id_code_no,datas[i].apply_team_name,datas[i].post_name,datas[i].task_name,datas[i].actual_start_date,datas[i].end_date,datas[i].nums,datas[i].notes,datas[i].project_father_no);
		}			
	}

}
</script>

</head>
<body onload="page_init()">
<form id="CheckForm" action="" method="post" target="list" > 
	<div style="border:1px #aebccb solid;background:#f1f2f3;padding:5px;width:100%;">
	<input type="hidden" id="project_info_no" name="project_info_no" value="<%=projectInfoNo%>"/>	
	<input type="hidden" id="laborCategory" name="laborCategory" value="<%=laborCategory%>"/>	
 	<div id="oper_div" align="center">
		<span class="yd"><a href="#" onclick="copyEsimiDate()"></a></span>
    </div>
	<div style="width:98%;height:515px;overflow-y:scroll;">
	<table id="lineTable" width="100%" border="0" cellspacing="0" cellpadding="0"  style="margin-top:2px;" >
    	<tr>
    	    <td class="bt_info_odd" width="3%">序号</td>
    	    <td class="bt_info_even" width="6%">姓名</td>
    	    <td class="bt_info_odd" width="6%">身份证号</td>
            <td class="bt_info_even"  width="6%">班组</td>
            <td class="bt_info_odd"  width="6%">岗位</td>		
               <% 
			        if(!"5000100004000000008".equals(projectType_zj)){
						  %>
			   <td class="bt_info_even"  width="6%">作业</td>		 
			    <%
					} 
				 %>	
				 
         	           
            <td class="bt_info_odd"  width="8%">进入时间</td>			
            <td class="bt_info_even"  width="8%">离开时间</td> 
            <td class="bt_info_odd"  width="4%">天数</td>			
            <td class="bt_info_even"  width="6%">备注<input type="hidden" id="equipmentSize" name="equipmentSize" value="0" /></td> 
        </tr>  
    </table>	
    </div>
	</div>
    <div id="oper_div">
        <span class="bc_btn"><a href="#" onclick="save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
 </form>
</body>
</html>
