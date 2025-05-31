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
	String pk_id_zs = request.getParameter("pk_id_zs");
	String pk_id_ls = request.getParameter("pk_id_ls");
	String ptdetail_id = request.getParameter("ptdetail_id");
	String taskIds = request.getParameter("taskIds");
	
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


</head>
<body  >
<form id="CheckForm" action="" method="post" target="list" > 
	<div style="border:1px #aebccb solid;background:#f1f2f3;padding:5px;width:100%;">
	<input type="hidden" id="project_info_no" name="project_info_no" value="<%=projectInfoNo%>"/>	
 
 	<div id="oper_div" align="center">
		<span class="yd"><a href="#" onclick="copyEsimiDate()"></a></span>
    </div>
	<div style="width:98%;height:515px;overflow-y:scroll;">
	<table id="lineTable" width="100%" border="0" cellspacing="0" cellpadding="0"  style="margin-top:2px;" >
    	<tr>
    	    <td class="bt_info_even" width="3%">序号</td>
    	     <td class="bt_info_odd" width="6%">用工性质</td>
    	    <td class="bt_info_even" width="6%">姓名</td>
    	    <td class="bt_info_odd" width="6%">人员编号</td>
            <td class="bt_info_even"  width="6%">班组</td>
            <td class="bt_info_odd"  width="6%">岗位</td>		           
            <td class="bt_info_even"  width="8%">进入时间</td>			
            <td class="bt_info_odd"  width="8%">离开时间</td> 
            <td class="bt_info_even"  width="4%">天数</td>			
            <td class="bt_info_odd"  width="6%">人员评价<input type="hidden" id="equipmentSize" name="equipmentSize" value="0" /></td> 
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


<!--Remark JavaScript定义-->
<script language="javaScript">
cruConfig.contextPath='<%=contextPath %>'; 

function save(){	
	if(checkForm()){
		
		var rowNum = document.getElementById("equipmentSize").value;		
		var rowParams = new Array();
		
		for(var i=0;i<rowNum;i++){
			var rowParam = {};
			   
			var ptdetail_id = document.getElementsByName("fy"+ i + "ptdetail_id")[0].value;						
			var end_date = document.getElementsByName("fy"+ i + "end_date")[0].value;			
			var notes = document.getElementsByName("fy"+ i + "notes")[0].value;			
			var nums  = document.getElementsByName("fy"+ i + "nums")[0].value;	
			var xz_type = document.getElementsByName("fy"+ i + "xz_type")[0].value;	
			var pk_ids = document.getElementsByName("fy"+ i + "pk_ids")[0].value;
			
		    var paths = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';	 
		     if (xz_type == "1"){		    	 
		    	 var submitStr1 = 'JCDP_TABLE_NAME=bgp_human_prepare_human_detail&JCDP_TABLE_ID='+pk_ids+'&zy_type='; 
	    		  syncRequest('Post',paths,encodeURI(encodeURI(submitStr1)));  //如果有人转移修改 状态 0 待转移	
		     }else if (xz_type == "0"){		    	 
		    	 var submitStr2 = 'JCDP_TABLE_NAME=bgp_comm_human_labor_deploy&JCDP_TABLE_ID='+pk_ids+'&zy_type='; 
		    		syncRequest('Post',paths,encodeURI(encodeURI(submitStr2)));  //如果有人转移修改 状态 0 待转移	
 
		     }
			
			rowParam['ptdetail_id'] = ptdetail_id;
			rowParam['end_date'] = end_date;
			rowParam['spare2'] = nums;
			rowParam['notes'] = encodeURI(encodeURI(notes));
			rowParam['modifi_date'] = '<%=curDate%>';

			rowParams[rowParams.length] = rowParam;
		}
			var rows=JSON.stringify(rowParams);
			saveFunc("BGP_COMM_HUMAN_PT_DETAIL",rows);	
			top.frames('list').frames('mainRightframe').refreshData('<%=taskIds%>','<%=projectInfoNo%>');		 
			newClose();
	}

}
 

function checkForm(){
	var deviceCount = document.getElementById("equipmentSize").value;
	var isCheck=true;
	for(var i=0;i<deviceCount;i++){			
		if(!notNullForCheck("fy"+i+"end_date","离开时间")) return false;
	}
	return true;

}

function copyEsimiDate(){ 
	var infoSize = document.getElementById("equipmentSize").value;
	var date1 = document.getElementById("fy0end_date").value;
	var date2 = document.getElementById("fy0notes").value;
	 
	for(var i=0;i<infoSize;i++){
		document.getElementById("fy"+i+"end_date").value=date1;
		document.getElementById("fy"+i+"notes").value=date2;
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
function  addLine (pk_ids,ptdetail_id,xz_type,employee_gz_name,employee_name,employee_cd,team_name ,work_post_name,start_date,end_date){
	
	var rowNum = document.getElementById("equipmentSize").value;	
	var tr = document.getElementById("lineTable").insertRow();
	tr.id = "row_" + rowNum + "_";
	
	if(rowNum % 2 == 1){  
  		classCss = "even_";
	}else{ 
		classCss = "odd_";
	}	

	var endDates = "fy"+ rowNum + "end_date";
	
	var td = tr.insertCell(0);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="hidden" name="fy'+ rowNum + 'pk_ids" id="fy'+ rowNum + 'pk_ids" value="'+pk_ids+'"/>'+'<input type="hidden" name="fy'+ rowNum + 'ptdetail_id" id="fy'+ rowNum + 'ptdetail_id" value="'+ptdetail_id+'"/>'+'<input type="hidden" name="fy'+ rowNum + 'xz_type" id="fy'+ rowNum + 'xz_type" value="'+xz_type+'"/>'+(parseInt(rowNum) + 1);
	
	var td = tr.insertCell(1);
	td.className=classCss+"even";
	td.innerHTML ='<input type="text" readonly="readonly" name="fy'+ rowNum + 'employee_gz_name" id="fy'+ rowNum + 'employee_gz_name"  value="'+employee_gz_name+'" class="input_width" onFocus="this.select()" />';
	
	var td = tr.insertCell(2);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" readonly="readonly"  class="input_width" name="fy'+ rowNum + 'employee_name" id="fy'+ rowNum + 'employee_name"  value="'+employee_name+'" onFocus="this.select()"/>';

	var td = tr.insertCell(3);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" readonly="readonly" name="fy'+ rowNum + 'employee_cd" id="fy'+ rowNum + 'employee_cd"  value="'+employee_cd+'" class="input_width"  />';
	
	var td = tr.insertCell(4);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" readonly="readonly" name="fy'+ rowNum + 'team_name" id="fy'+ rowNum + 'team_name"  value="'+team_name+'" class="input_width"  />';
	
	var td = tr.insertCell(5);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" readonly="readonly" name="fy'+ rowNum + 'work_post_name" id="fy'+ rowNum + 'work_post_name"  value="'+work_post_name+'" class="input_width"  />';
	
	var td = tr.insertCell(6);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" readonly="readonly" name="fy'+ rowNum + 'start_date" id="fy'+ rowNum + 'start_date"  value="'+start_date+'" class="input_width"  />';

	var td = tr.insertCell(7);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" class="input_width" readonly="readonly"  onpropertychange="calDays('+rowNum+')" name="fy'+ rowNum + 'end_date" id="fy'+ rowNum + 'end_date"  value="" />'+'<img src="<%=contextPath%>/images/calendar.gif" id="tributton2'+rowNum+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+endDates+',tributton2'+rowNum+');" />';


	var td = tr.insertCell(8);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" class="input_width"  readonly="readonly" name="fy'+ rowNum + 'nums" id="fy'+ rowNum + 'nums"  value="" />';

	var td = tr.insertCell(9);
	td.className=classCss+"even";
	td.innerHTML = 	'<select name="fy'+ rowNum + 'notes" id="fy'+ rowNum + 'notes" class="select_width">	<option value="">--请选择--</option>	<option value="0110000058000000001">优秀</option>	<option value="0110000058000000002">称职</option>	<option value="0110000058000000003">基本称职</option>	<option value="0110000058000000004">不称职</option></select>';

	document.getElementById("equipmentSize").value = (parseInt(rowNum) + 1);
	 
}


function calDays(i){
	var startTime = document.getElementById("fy"+ i + "start_date").value;
	var returnTime = document.getElementById("fy"+ i + "end_date").value;
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

 
	var ptdetail_id = "<%=ptdetail_id%>";		
	if(ptdetail_id!='null'){
		var querySql = " select t.pk_ids,t.ptdetail_id,  t.xz_type zy_type, '' disasss, '是'   zy_sf,''employee_gender,t.employee_id,t.employee_name, gp.project_name org_name,t.aproject_info_no org_subjection_id ,t.start_date actual_start_date,t.end_date actual_end_date , t.team_s team ,t.post_s work_post,t.team_name ,t.work_post_name , t.employee_gz ,t.employee_gz_name,'' dalei,   '' xiaolei, t.employee_cd,'' id_code,t.end_date employee_birth_date  from BGP_COMM_HUMAN_PT_DETAIL t  left join  gp_task_project gp on  t.aproject_info_no=gp.project_info_no and gp.bsflag='0'  where t.bsflag='0' and  t.ptdetail_id in (<%=ptdetail_id%>) ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		for (var i = 0; datas && queryRet.datas.length; i++) {	
		  
			addLine (datas[i].pk_ids,datas[i].ptdetail_id,datas[i].zy_type,datas[i].employee_gz_name,datas[i].employee_name,datas[i].employee_cd,datas[i].team_name ,datas[i].work_post_name,datas[i].actual_start_date,datas[i].actual_start_date);
	 
		}			
	}

 
</script>


</html>
