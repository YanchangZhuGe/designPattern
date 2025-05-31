<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.util.DateUtil"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@ taglib uri="code" prefix="code"%> 
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%
	String contextPath = request.getContextPath();
	String month_no = "";
	String org_sub_id = "";
	String record_id = "";
	String action = "";
	String org_name="";
    String subflag= ""; 
	if(request.getParameter("month_no")!=null && request.getParameter("month_no")!="" )month_no = request.getParameter("month_no");	
	if(request.getParameter("org_sub_id")!=null && request.getParameter("org_sub_id")!="" )org_sub_id = request.getParameter("org_sub_id");
	if(request.getParameter("record_id")!=null && request.getParameter("record_id")!="" )record_id = request.getParameter("record_id");
	if(request.getParameter("action")!=null && request.getParameter("action")!="" )action = request.getParameter("action");
	if(request.getParameter("org_name")!=null && request.getParameter("org_name")!="" )org_name = request.getParameter("org_name");
	if(request.getParameter("subflag")!=null && request.getParameter("subflag")!="" )subflag = request.getParameter("subflag");
	
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getOrgSubjectionId();
	String userName = user.getUserId();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date()); 
	String projectInfoNo = user.getProjectInfoNo();
	 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>

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

<title>隐患识别统计</title>
</head>
<body class="bgColor_f3f3f3"   >       
<form name="form1" id="form1" method="post" action="">
<div id="list_table" style="height: auto;width:auto;overflow: hidden;">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" id="zj" css="zj" event="onclick='toProjectNo()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" id="bc" css="bc" event="onclick='toAdd()'" title=""></auth:ListButton>
			    <auth:ListButton functionId="" css="fh" event="onclick='toBack()'" title=""></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
		</table>
	</div>
      <fieldSet style="margin-left:2px"><legend>野外作业队伍隐患识别统计</legend>
      <div id="week_box" style="overflow: scroll;">
      <table id="lineTable" width="100%" border="1" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<input type="hidden" id="hse_common_id" name="hse_common_id" value=""></input>
      	<input type="hidden" id="hse_danger_id" name="hse_danger_id" value=""></input>
      	<input type="hidden" id="lineNum" name="lineNum" value="0"></input>
         
			<tr class="bt_info">
			  <td>操作</td>
			  <td>序号</td>
			  <td height="74">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;单位名称&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;队号&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;项目名称&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;项目施工方法/规模&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>隐患数量&nbsp;&nbsp;&nbsp;</td>
				<td>统计天数</td>
				<td >&nbsp;月平均隐患数量</td>
				<td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;备注&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
 		 
			</tr>		 
      </table>
 
	  
      </div>
      </fieldSet>
  </div>
</form>
</body>
<script type="text/javascript">
$("#week_box").css("height",$(window).height()-60);
cruConfig.contextPath =  "<%=contextPath%>";	 
cruConfig.cdtType = 'form';	 
var recore_id='<%=record_id%>'; 
var month_no='<%=month_no%>';
var org_sub_id='<%=org_sub_id%>';
var action='<%=action%>';
var org_name='<%=org_name%>';
var subflag='<%=subflag%>';
var projectInfoNo='<%=projectInfoNo%>';
if(subflag!="未提交"  && subflag!="0" ){
	document.getElementById("bc").style.display="none";
	document.getElementById("zj").style.display="none";
}else{
	document.getElementById("bc").style.display="true";
	document.getElementById("zj").style.display="true";
	
}
if(subflag!="审批不通过" && subflag!="4" ){
	document.getElementById("bc").style.display="none";
	document.getElementById("zj").style.display="none";
}else{
	document.getElementById("bc").style.display="true";
	document.getElementById("zj").style.display="true";
	
}

function toAdd(){ 	
	var rowNum = document.getElementById("lineNum").value;			
	var rowParams = new Array();		 
		for(var i=0;i<rowNum;i++){
			var rowParam = {};	
			var  statistics_no =document.getElementsByName("statistics_no_"+i)[0].value; 
			var  recore_id =document.getElementsByName("recore_id_"+i)[0].value; 
			var  org_sub_id =document.getElementsByName("org_sub_id_"+i)[0].value; 
			var  month_no =document.getElementsByName("month_no_"+i)[0].value; 
			var  unit_s=document.getElementsByName("unit_s_"+i)[0].value; 
			var  team_num =document.getElementsByName("team_num_"+i)[0].value; 
			var  project_no =document.getElementsByName("project_no_"+i)[0].value; 
			var  project_method =document.getElementsByName("project_method_"+i)[0].value; 
			var  hidden_num =document.getElementsByName("hidden_num_"+i)[0].value; 
			var  statistical_day =document.getElementsByName("statistical_day_"+i)[0].value; 
			var  avg_day =document.getElementsByName("avg_day_"+i)[0].value; 
			var  note_s=document.getElementsByName("note_s_"+i)[0].value; 
			
			var creator = document.getElementsByName("creator_"+i)[0].value; 
			var create_date = document.getElementsByName("create_date_"+i)[0].value; 
			var updator = document.getElementsByName("updator_"+i)[0].value; 
			var modifi_date = document.getElementsByName("modifi_date_"+i)[0].value; 
			var bsflag = document.getElementsByName("bsflag_"+i)[0].value; 
						
			if(statistics_no !=null && statistics_no !=''){	
 
 				rowParam['note_s'] = encodeURI(encodeURI(note_s));
				rowParam['project_method'] = encodeURI(encodeURI(project_method));				
				rowParam['statistics_no'] = statistics_no;
				rowParam['recore_id'] =recore_id; 				
			    rowParam['org_sub_id'] = org_sub_id;
			    rowParam['month_no'] = month_no;			    
			     rowParam['unit_s'] =unit_s;
				 rowParam['team_num'] =team_num;
				 rowParam['project_no'] =project_no;
				 rowParam['hidden_num'] =hidden_num;
				 rowParam['statistical_day'] =statistical_day;
				 rowParam['avg_day'] =avg_day;
		 
				rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['create_date'] ='<%=curDate%>';	
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';	
				rowParam['bsflag'] = bsflag;	
				
			}else{
				rowParam['note_s'] = encodeURI(encodeURI(note_s));
				rowParam['project_method'] = encodeURI(encodeURI(project_method));				
				rowParam['statistics_no'] = statistics_no;
				rowParam['recore_id'] =recore_id; 				
			    rowParam['org_sub_id'] = org_sub_id;
			    rowParam['month_no'] = month_no;			    
			     rowParam['unit_s'] =unit_s;
				 rowParam['team_num'] =team_num;
				 rowParam['project_no'] =project_no;
				 rowParam['hidden_num'] =hidden_num;
				 rowParam['statistical_day'] =statistical_day;
				 rowParam['avg_day'] =avg_day;
		 
				rowParam['creator'] = encodeURI(encodeURI(creator));
				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;		 
			}
				rowParams[rowParams.length] = rowParam; 
 
		}
			var rows=JSON.stringify(rowParams);			 
			saveFunc("BGP_MONTH_HIDDEN_STATISTICS",rows);	
 
}
function toProjectNo(){
	if(projectInfoNo =="null"  ){
		alert('添加前请先选择项目！'); return;
	}else{ 
		toAddLine();
	}
	
}
function toAddLine(statistics_nos,recore_ids,org_sub_ids,month_nos,unit_ss,unit_names,team_nums,team_names,project_nos,project_names,project_methods,hidden_nums,statistical_days,avg_days,note_ss,creators,create_dates,updators,modifi_dates,bsflags){
	
	var statistics_no="";
	var recore_id="";
	if(recore_id == "") recore_id='<%=record_id%>';
	var org_sub_id="";
	if(org_sub_id == "") org_sub_id='<%=org_sub_id%>';
	var month_no="";
	if( month_no == "") month_no='<%=month_no%>';	
	var unit_s="";
	if( unit_s == "") unit_s='<%=org_sub_id%>';
	var unit_name="";
	if( unit_name == "") unit_name='<%=org_name%>';
	
	var team_num="";
	var team_name="";
	var project_no="";
	var project_name="";
 
	if(projectInfoNo !="null"  ){
		var querySql1="";
		var queryRet1=null;
		var datas1 =null; 
			   querySql1 = " select d.org_id as team_no,i.org_name as team_name ,t.project_info_no,t.project_name from gp_task_project t left join gp_task_project_dynamic d on t.project_info_no = d.project_info_no and d.bsflag = '0' left join comm_org_information i on d.org_id = i.org_id and i.bsflag = '0' where t.bsflag = '0' and t.project_info_no = '"+projectInfoNo+"' order by i.org_name " ;
			   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
				if(queryRet1.returnCode=='0'){
				  datas1 = queryRet1.datas;	
					if(datas1 != null && datas1 != ''){	 
						if( team_num == "") team_num=datas1[0].team_no;
						if( team_name == "") team_name=datas1[0].team_name;
						if( project_no == "") project_no=datas1[0].project_info_no;
						if( project_name == "") project_name=datas1[0].project_name;
					}
			    }	
	 }
	 
	var project_method="";
	var hidden_num="";
	var statistical_day="";
	var avg_day="";
	var note_s=""; 	
	var creator = "";
	var create_date = "";
	var updator = "";
	var modifi_date = "";
	var bsflag = "";
	
	
	if(statistics_nos != null && statistics_nos != ""){
		statistics_no=statistics_nos;
	}
	if(recore_ids != null && recore_ids != ""){
		recore_id=recore_ids;
	}
	if(org_sub_ids != null && org_sub_ids != ""){
		org_sub_id=org_sub_ids;
	}
	
	if(month_nos != null && month_nos != ""){
		month_no=month_nos;
	}
	if(unit_ss != null && unit_ss != ""){
		unit_s=unit_ss;
	}
	if(unit_names != null && unit_names != ""){
		unit_name=unit_names;
	}
	 
	if(team_nums != null && team_nums != ""){
		team_num=team_nums;
	}
	if(team_names != null && team_names != ""){
		team_name=team_names;
	}
	if(project_nos != null && project_nos != ""){
		project_no=project_nos;
	}
	
	if(project_names != null && project_names != ""){
		project_name=project_names;
	}
	if(project_methods != null && project_methods != ""){
		project_method=project_methods;
	}
	if(hidden_nums != null && hidden_nums != ""){
		hidden_num=hidden_nums;
	}
	
	
	if(statistical_days != null && statistical_days != ""){
		statistical_day=statistical_days;
	}
	if(avg_days != null && avg_days != ""){
		avg_day=avg_days;
	}
	if(note_ss != null && note_ss != ""){
		note_s=note_ss;
	}
	 
	
	if(creators != null && creators != ""){
		creator=creators;
	}
	
	if(create_dates != null && create_dates != ""){
		create_date=create_dates;
	}
	if(updators != null && updators != ""){
		updator=updators;
	}
	if(modifi_dates != null && modifi_dates != ""){
		modifi_date=modifi_dates;
	}
	if(bsflags != null && bsflags != ""){
		bsflag=bsflags;
	}
	 
	var rowNum = document.getElementById("lineNum").value;	
	var autoOrder = document.getElementById("lineTable").rows.length;
	var tr = document.getElementById("lineTable").insertRow(autoOrder);
 
	tr.align="center";		
  	if(rowNum % 2 == 1){  
  		tr.className = "odd";
	}else{ 
		tr.className = "even";
	}	
	tr.id = "row_" + rowNum + "_";  
	
	document.getElementById("lineNum").value = parseInt(rowNum) + 1;	
	var td = tr.insertCell(); 
	td.style.display = "";
	
	td.innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/>'+'<img src="'+'<%=contextPath%>'+'/images//delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + tr.id + '\')"/>';
	tr.insertCell().innerHTML = parseInt(rowNum) + 1;
	tr.insertCell().innerHTML = '<input type="hidden"  name="statistics_no' + '_' + rowNum + '" value="'+statistics_no+'"/>'+'<input type="text" class="input_width" name="unit_name' + '_' + rowNum + '"   readonly="readonly"  style="width:130px;" readonly="readonly"  value="'+unit_name+'" />'+'<input type="hidden"  name="recore_id' + '_' + rowNum + '" value="'+recore_id+'"/>'+'<input type="hidden"  name="bsflag' + '_' + rowNum + '" value="0"/>'+'<input type="hidden"  name="creator' + '_' + rowNum + '" value="'+creator+'"/>'+'<input type="hidden"  name="create_date' + '_' + rowNum + '" value="'+create_date+'"/>'+'<input type="hidden"  name="updator' + '_' + rowNum + '" value="'+updator+'"/>'+'<input type="hidden"  name="modifi_date' + '_' + rowNum + '" value="'+modifi_date+'"/>';
	tr.insertCell().innerHTML = '<input type="hidden"  name="team_num' + '_' + rowNum + '" value="'+team_num+'"/>'+'<input type="hidden"  name="org_sub_id' + '_' + rowNum + '" value="'+org_sub_id+'"/>'+'<input type="hidden"  name="month_no' + '_' + rowNum + '" value="'+month_no+'"/>'+'<input type="hidden"  name="unit_s' + '_' + rowNum + '" value="'+unit_s+'"/>'+'<input type="text"  class="input_width" name="team_name' + '_' + rowNum + '" style="width:130px;"  readonly="readonly"  value="'+team_name+'"  />';
	tr.insertCell().innerHTML = '<input type="hidden"  name="project_no' + '_' + rowNum + '" value="'+project_no+'"/>'+'<input type="text" class="input_width" name="project_name' + '_' + rowNum + '" style="width:165px;" readonly="readonly"   value="'+project_name+'"   />';				
	tr.insertCell().innerHTML = '<textarea name="project_method' + '_' + rowNum + '"  id="project_method' + '_' + rowNum + '"    style="height:30px; width:260px;" class="textarea" >'+project_method+'</textarea>  ';	
	tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="hidden_num' + '_' + rowNum + '" onblur="divisionNum('+rowNum+');" value="'+hidden_num+'" />';		
    tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="statistical_day' + '_' + rowNum + '" onblur="divisionNum('+rowNum+');"  value="'+statistical_day+'"   />';		
	tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="avg_day' + '_' + rowNum + '" readonly="readonly"  value="'+avg_day+'"  />';		
	tr.insertCell().innerHTML = '<textarea name="note_s' + '_' + rowNum + '"  id="note_s' + '_' + rowNum + '"    style="height:30px; width:330px;" class="textarea" >'+note_s+'</textarea>  ';	
 
}
 
 
function divisionNum(i){			  
    var sum_num=0;  
	var   num1=document.getElementsByName("hidden_num_"+i)[0].value;					
	var   num2 =document.getElementsByName("statistical_day_"+i)[0].value;				
	if(num1 ==""){alert('隐患数量不能为空！'); return; }
	if(num2 ==""){alert('统计天数不能为空！'); return;}
if(checkNaN("hidden_num_"+i)){

 	}
if(checkNaN("statistical_day_"+i)){
	
}
 
document.getElementsByName("avg_day_"+i)[0].value=substrin(num1)/substrin(num2)*30;
 
 
}
 
function checkNaN(numids){
	 var str =document.getElementsByName(numids)[0].value;
	 if(str!=""){		 
		if(isNaN(str)){
			alert("请输入数字");
			document.getElementsByName(numids)[0].value="";
			return false;
		}else{
			return true;
		}
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
   if(action =="edit"){	    
		var querySql1="";
		var queryRet1=null;
		var datas1 =null; 
		 document.getElementById("lineNum").value="0";	
		  querySql1 = " select tr.statistics_no,tr.recore_id,tr.org_sub_id,ion.org_abbreviation as org_name,tr.month_no,tr.unit_s,tr.team_num,  i.org_name as team_name,tr.project_no,  t.project_name,tr.project_method,tr.hidden_num,tr.statistical_day,tr.avg_day,tr.note_s ,tr.creator,tr.create_date,tr.updator,tr.modifi_date,tr.bsflag  from  BGP_MONTH_HIDDEN_STATISTICS tr  left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  join comm_org_information ion    on ion.org_id = ose.org_id  left join gp_task_project t    on t.project_info_no = tr.project_no   and t.bsflag = '0'  left join gp_task_project_dynamic d    on t.project_info_no = d.project_info_no   and d.bsflag = '0'  left join comm_org_information i    on d.org_id = i.org_id   and i.bsflag = '0'   where tr.bsflag='0' and tr.recore_id='<%=record_id%>' and tr.org_sub_id='<%=org_sub_id%>' and tr.month_no='<%=month_no%>'" ;
		   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
			if(queryRet1.returnCode=='0'){
			  datas1 = queryRet1.datas;	
					if(datas1 != null && datas1 != ''){		
						for(var i = 0; i<datas1.length; i++){						 
						  toAddLine(datas1[i].statistics_no,datas1[i].recore_id,datas1[i].org_sub_id,datas1[i].month_no,datas1[i].unit_s,datas1[i].org_name,datas1[i].team_num,datas1[i].team_name,datas1[i].project_no,datas1[i].project_name,datas1[i].project_method,datas1[i].hidden_num,datas1[i].statistical_day,datas1[i].avg_day,datas1[i].note_s,datas1[i].creator,datas1[i].create_date,datas1[i].updator,datas1[i].modifi_date,datas1[i].bsflag);
						}
					}else{
						var querySql="";
						var queryRet=null;
						var datas =null; 
						   querySql = " select       ion.org_abbreviation as org_name,d.org_id, i.org_name as team_name,t.project_name,  tr.org_sub_id,tr.project_no,    count(*) as hidden_num     from BGP_HSE_HIDDEN_INFORMATION tr  join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0'  join comm_org_information oi1  on oi1.org_id = os1.org_id  and oi1.bsflag = '0'  left join comm_org_subjection os2  on tr.third_org = os2.org_subjection_id  and os2.bsflag = '0'  left join comm_org_information oi2  on oi2.org_id = os2.org_id  and oi2.bsflag = '0'  left join comm_org_subjection ose  on tr.org_sub_id = ose.org_subjection_id  and ose.bsflag = '0'  join comm_org_information ion  on ion.org_id = ose.org_id  left join BGP_HIDDEN_INFORMATION_DETAIL hdl  on hdl.hidden_no = tr.hidden_no  and hdl.bsflag = '0'  left join gp_task_project t    on t.project_info_no =  tr.project_no   and t.bsflag = '0'   left join gp_task_project_dynamic d  on t.project_info_no = d.project_info_no  and d.bsflag = '0'  left join comm_org_information i  on d.org_id = i.org_id  and i.bsflag = '0'  where   tr.bsflag = '0' and  to_char(tr.report_date,'yyyy-MM')='"+month_no+"' and tr.org_sub_id like'"+org_sub_id+"'  group by tr.project_no ,       ion.org_abbreviation ,  d.org_id, i.org_name,  t.project_name,    tr.org_sub_id,  tr.project_no  having count(*) > 0" ;
						   queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql)));
							if(queryRet.returnCode=='0'){
							  datas = queryRet.datas;	
								if(datas != null && datas != ''){	 
									for(var i = 0; i<datas.length; i++){								 
										toAddLine('','<%=record_id%>','<%=org_sub_id%>','<%=month_no%>',datas[i].org_sub_id,datas[i].org_name,datas[i].org_id,datas[i].team_name,datas[i].project_no,datas[i].project_name,'',datas[i].hidden_num,'','','','','','','','0');
					                }
									
								}
						     }	
						
					}
		    }	

   }else  if(action =="add"){
	   var querySql="";
		var queryRet=null;
		var datas =null; 
		   querySql = " select       ion.org_abbreviation as org_name,d.org_id, i.org_name as team_name,t.project_name,  tr.org_sub_id,tr.project_no,    count(*) as hidden_num     from BGP_HSE_HIDDEN_INFORMATION tr  join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0'  join comm_org_information oi1  on oi1.org_id = os1.org_id  and oi1.bsflag = '0'  left join comm_org_subjection os2  on tr.third_org = os2.org_subjection_id  and os2.bsflag = '0'  left join comm_org_information oi2  on oi2.org_id = os2.org_id  and oi2.bsflag = '0'  left join comm_org_subjection ose  on tr.org_sub_id = ose.org_subjection_id  and ose.bsflag = '0'  join comm_org_information ion  on ion.org_id = ose.org_id  left join BGP_HIDDEN_INFORMATION_DETAIL hdl  on hdl.hidden_no = tr.hidden_no  and hdl.bsflag = '0'  left join gp_task_project t    on t.project_info_no =  tr.project_no   and t.bsflag = '0'   left join gp_task_project_dynamic d  on t.project_info_no = d.project_info_no  and d.bsflag = '0'  left join comm_org_information i  on d.org_id = i.org_id  and i.bsflag = '0'  where   tr.bsflag = '0' and  to_char(tr.report_date,'yyyy-MM')='"+month_no+"' and tr.org_sub_id like'"+org_sub_id+"'  group by tr.project_no ,       ion.org_abbreviation ,  d.org_id, i.org_name,  t.project_name,    tr.org_sub_id,  tr.project_no  having count(*) > 0" ;
		   queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
			  datas = queryRet.datas;	
				if(datas != null && datas != ''){	 
					for(var i = 0; i<datas.length; i++){								 
						toAddLine('','<%=record_id%>','<%=org_sub_id%>','<%=month_no%>',datas[i].org_sub_id,datas[i].org_name,datas[i].org_id,datas[i].team_name,datas[i].project_no,datas[i].project_name,'',datas[i].hidden_num,'','','','','','','','0');
	                }
					
				}
		     }	
		 
   }	   
	 
 	function toBack(){
		window.parent.parent.location='mainPage.jsp';
	}
	
</script>
</html>

