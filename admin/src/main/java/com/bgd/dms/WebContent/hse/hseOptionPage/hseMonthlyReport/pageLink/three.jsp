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
	String userName = (user==null)?"":user.getUserName();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());	
	String spareSub =(user==null)?"":user.getOrgSubjectionId();	
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

<title>行为安全观察统计月报</title>
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
			    <auth:ListButton functionId="" id="bc" css="bc" event="onclick='toAdd()'" title=""></auth:ListButton>
			    <auth:ListButton functionId="" css="fh" event="onclick='toBack()'" title=""></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
		</table>
	</div>
      <fieldSet style="margin-left:2px"><legend>安全观察与沟通结果统计报表</legend>
      <div id="week_box" style="overflow: scroll;">
      <table id="lineTable" width="100%" border="1" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<input type="hidden" id="hse_common_id" name="hse_common_id" value=""></input>
      	<input type="hidden" id="hse_danger_id" name="hse_danger_id" value=""></input>
      	<input type="hidden" id="lineNum" name="lineNum" value="0"></input>
        	<tr class="bt_info">
				<td colspan="3">直属单位</td>
				<td rowspan="2" >观察与沟通时长（小时）</td>
				<td rowspan="2" >安全项目数量</td>
				<td colspan="9" >不安全行为数量</td>
				<td rowspan="2">每小时安全项目次数</td>
        	</tr>
			<tr class="bt_info">
			  <td height="74" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;单位名称&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			  <td>应实施人数&nbsp;&nbsp;&nbsp;</td>
				<td >实际实施人数</td>
				<td>人的反应&nbsp;&nbsp;&nbsp;</td>
				<td>人员的位置</td>
				<td>防护装备&nbsp;&nbsp;&nbsp;</td>
				<td>工具与设备</td>
				<td>人机工程&nbsp;&nbsp;&nbsp;</td>
				<td>环境整洁&nbsp;&nbsp;&nbsp;</td>
				<td>人员管理&nbsp;&nbsp;&nbsp;</td>
				<td>制度与程序&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;合计&nbsp;&nbsp;&nbsp;&nbsp;</td>
		    </tr>		
				 
		    <tr class="even">
			  <td height="74"  >合计 </td> 
			  <td> <input type="text" id="sum_oshould_number"   name="sum_oshould_number" class="input_width" /></td>
			  <td>  <input type="text" id="sum_oactual_number"   name="sum_oactual_number" class="input_width" /></td>			  
			  <td>  <input type="text" id="sum_hours"   name="sum_hours" class="input_width" /></td>
			  <td>  <input type="text" id="sum_project_num"   name="sum_project_num" class="input_width" /></td>
			  <td >  <input type="text" id="sum_people_reaction"   name="sum_people_reaction" class="input_width" /></td>
			  <td >  <input type="text" id="sum_people_position"   name="sum_people_position" class="input_width" /></td>
			  <td>  <input type="text" id="sum_protective"   name="sum_protective" class="input_width" /></td>
			  <td>  <input type="text" id="sum_tools"   name="sum_tools" class="input_width" /></td>
			  <td>  <input type="text" id="sum_man_machine"   name="sum_man_machine" class="input_width" /></td>
			  <td>  <input type="text" id="sum_clean_tidy"   name="sum_clean_tidy" class="input_width" /></td>
			  <td>  <input type="text" id="sum_people_management"   name="sum_people_management" class="input_width" /></td>
			  <td>  <input type="text" id="sum_system_program"   name="sum_system_program" class="input_width" /></td>
			  <td>  <input type="text" id="sum_sum_num"   name="sum_sum_num" class="input_width" /></td>
			  <td>  <input type="text" id="sum_hour_number"   name="sum_hour_number" class="input_width" /></td>
			
	    </tr>
			<tr class="even">
			  <td height="74" colspan="2">分析统计：</td>
			  <td colspan="17">&nbsp;<textarea id="analysis_statistics" name="analysis_statistics"   style="height:80px;" class="textarea" ></textarea></td>
	        </tr>
	 	
				<tr class="even">
			  <td height="74" colspan="2">改进建议：</td>
			  <td colspan="17">&nbsp;<textarea id="suggested" name="suggested"   style="height:80px;" class="textarea" ></textarea></td>
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

if(subflag!="未提交"  && subflag!="0" ){
	document.getElementById("bc").style.display="none";
	document.getElementById("zj").style.display="none";
}else{
	document.getElementById("bc").style.display="true";
	document.getElementById("zj").style.display="true";
}
if(subflag!="审批不通过"  && subflag!="5" ){
	document.getElementById("bc").style.display="none";
	document.getElementById("zj").style.display="none";
}else{
	document.getElementById("bc").style.display="true";
	document.getElementById("zj").style.display="true";
}
 
function toAdd(){ 	
	var rowNum = document.getElementById("lineNum").value;			
	var rowParams = new Array();					
		var recore_idS='<%=record_id%>';
		var spareSub  ='<%=spareSub%>';		 
		var   analysis_statistics= document.getElementsByName("analysis_statistics")[0].value;
		var   suggested= document.getElementsByName("suggested")[0].value;		 
		var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq'; 
	    var submitStr = 'JCDP_TABLE_NAME=BGP_HSE_MONTH_RECORD&JCDP_TABLE_ID='+recore_idS+'&spare1=1&spare2=<%=userName%>&analysis_statistics='+analysis_statistics+'&suggested='+suggested;
	    var retObject = syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		
					
		for(var i=0;i<rowNum;i++){
			var rowParam = {};			 
			var mrstatistics_no = document.getElementsByName("mrstatistics_no_"+i)[0].value;		
			var  recore_id =document.getElementsByName("recore_id_"+i)[0].value; 
			var  org_name  =document.getElementsByName("org_name_"+i)[0].value; 
			var  org_sub_id =document.getElementsByName("org_sub_id_"+i)[0].value; 
			var  month_no =document.getElementsByName("month_no_"+i)[0].value; 		 
			
			var   sum_oshould_number = document.getElementsByName("otshould_number_"+i)[0].value;
			var   sum_oactual_number = document.getElementsByName("otactual_number_"+i)[0].value;		
			var   sum_hours= document.getElementsByName("hours_"+i)[0].value;		
			var   sum_project_num= document.getElementsByName("project_num_"+i)[0].value;		
			var   sum_people_reaction= document.getElementsByName("people_reaction_"+i)[0].value;		
			var   sum_people_position= document.getElementsByName("people_position_"+i)[0].value;		
			var   sum_protective= document.getElementsByName("protective_"+i)[0].value;		
			var   sum_tools= document.getElementsByName("tools_"+i)[0].value;		
			var   sum_man_machine = document.getElementsByName("man_machine_"+i)[0].value;		
			var   sum_clean_tidy= document.getElementsByName("clean_tidy_"+i)[0].value;		
			var   sum_people_management= document.getElementsByName("people_management_"+i)[0].value;		
			var   sum_system_program= document.getElementsByName("system_program_"+i)[0].value;		
			var   sum_sum_num= document.getElementsByName("sum_num_"+i)[0].value;		
			var   sum_hour_number= document.getElementsByName("hour_number_"+i)[0].value;	
			
			var creator = document.getElementsByName("creator_"+i)[0].value; 
			var create_date = document.getElementsByName("create_date_"+i)[0].value; 
			var updator = document.getElementsByName("updator_"+i)[0].value; 
			var modifi_date = document.getElementsByName("modifi_date_"+i)[0].value; 
			var bsflag = document.getElementsByName("bsflag_"+i)[0].value; 
		 	
 				 rowParam['mrstatistics_no'] = encodeURI(encodeURI(mrstatistics_no));
				 rowParam['recore_id'] = encodeURI(encodeURI(recore_id));
				 rowParam['org_sub_id'] = org_sub_id;
				 rowParam['month_no'] =month_no; 			
				 
			     rowParam['sum_oshould_number'] = sum_oshould_number;
			     rowParam['sum_oactual_number'] = sum_oactual_number;			    
			     rowParam['sum_project_num'] =sum_project_num;
				 rowParam['sum_hours'] =sum_hours;
				 rowParam['sum_people_reaction'] =sum_people_reaction;
				 rowParam['sum_people_position'] =sum_people_position;
				 
			    rowParam['sum_protective'] = sum_protective;
			    rowParam['sum_tools'] = sum_tools;
			    rowParam['sum_man_machine'] = sum_man_machine;
			    rowParam['sum_clean_tidy'] = sum_clean_tidy;
			    rowParam['sum_people_management'] = sum_people_management;
			    rowParam['sum_system_program'] = sum_system_program;
			    rowParam['sum_sum_num'] = sum_sum_num;
			    rowParam['sum_hour_number'] = sum_hour_number;
	  
				rowParam['spare1'] = recore_idS;
				rowParam['spare2'] = spareSub;	
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';	
				rowParam['bsflag'] = bsflag;					
			 
				rowParams[rowParams.length] = rowParam; 
 
		}
			var rows=JSON.stringify(rowParams);			 
			saveFunc("BGP_MONTH_RECORD_STATISTICS",rows);	
 
}
function toAddLine(mrstatistics_nos,recore_ids,org_names,org_sub_ids,month_nos,oshould_numbers,oactual_numbers,tshould_numbers,tactual_numbers,hourss,project_nums,people_reactions,people_positions,protectives,toolss,man_machines,clean_tidys,people_managements,system_programs,sum_nums,hour_numbers,creators,create_dates,updators,modifi_dates,bsflags){

	var mrstatistics_no ="";
	var  recore_id ="";
	var  org_name  ="";
	var  org_sub_id ="";
	var  month_no ="";	
	var oshould_number ="";
	var oactual_number ="";
	var tshould_number ="";
	var tactual_number ="";
	var hours ="";
	var project_num ="";
	var people_reaction ="";
	var people_position ="";
	var protective ="";
	var tools ="";
	var man_machine ="";
	var clean_tidy ="";
	var people_management ="";
	var system_program ="";
	var sum_num ="";
	var hour_number ="";	
	var creator = "";
	var create_date = "";
	var updator = "";
	var modifi_date = "";
	var bsflag = "";
	 
	if(mrstatistics_nos != null && mrstatistics_nos != ""){
		mrstatistics_no=mrstatistics_nos;
	}

	if(recore_ids != null && recore_ids != ""){
		recore_id=recore_ids;
	}
	if(org_names != null && org_names != ""){
		org_name=org_names;
	}
	if(org_sub_ids != null && org_sub_ids != ""){
		org_sub_id=org_sub_ids;
	}
	
	if(month_nos != null && month_nos != ""){
		month_no=month_nos;
	}

	
	if(oshould_numbers != null && oshould_numbers != ""){
		oshould_number=oshould_numbers;
	}
	if(oactual_numbers != null && oactual_numbers != ""){
		oactual_number=oactual_numbers;
	}

	if(tshould_numbers != null && tshould_numbers != ""){
		tshould_number=tshould_numbers;
	}
	if(tactual_numbers != null && tactual_numbers != ""){
		tactual_number=tactual_numbers;
	}
	if(hourss != null && hourss != ""){
		hours=hourss;
	}
	
	if(project_nums != null && project_nums != ""){
		project_num=project_nums;
	}
	if(people_reactions != null && people_reactions != ""){
		people_reaction=people_reactions;
	}
	if(people_positions != null && people_positions != ""){
		people_position=people_positions;
	}
	
	
	if(protectives != null && protectives != ""){
		protective=protectives;
	}
	if(toolss != null && toolss != ""){
		tools=toolss;
	}
	if(man_machines != null && man_machines != ""){
		man_machine=man_machines;
	}
	
	if(clean_tidys != null && clean_tidys != ""){
		clean_tidy=clean_tidys;
	}
	if(people_managements != null && people_managements != ""){
		people_management=people_managements;
	}
	if(system_programs != null && system_programs != ""){
		system_program=system_programs;
	}
	 
	if(sum_nums != null && sum_nums != ""){
		sum_num=sum_nums;
	}
	if(hour_numbers != null && hour_numbers != ""){
		hour_number=hour_numbers;
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
	var otshould_number=parseInt(oshould_number)+parseInt(tshould_number); 
	var otactual_number =parseInt(oactual_number)+parseInt(tactual_number);

	var rowNum = document.getElementById("lineNum").value;	
	var autoOrder = document.getElementById("lineTable").rows.length-3;
	var tr = document.getElementById("lineTable").insertRow(autoOrder);
 
	tr.align="center";		

  	if(rowNum % 2 == 1){  
  		tr.className = "odd";
	}else{ 
		tr.className = "even";
	}	
	tr.id = "row_" + rowNum + "_";  	

	tr.insertCell().innerHTML = '<input type="hidden"  name="mrstatistics_no' + '_' + rowNum + '" value="'+mrstatistics_no+'"/>'+'<input type="text" class="input_width" name="org_name' + '_' + rowNum + '"   readonly="readonly"  value="'+org_name+'" />'+'<input type="hidden"  name="recore_id' + '_' + rowNum + '" value="'+recore_id+'"/>'+'<input type="hidden"  name="bsflag' + '_' + rowNum + '" value="0"/>'+'<input type="hidden"  name="creator' + '_' + rowNum + '" value="'+creator+'"/>'+'<input type="hidden"  name="create_date' + '_' + rowNum + '" value="'+create_date+'"/>'+'<input type="hidden"  name="updator' + '_' + rowNum + '" value="'+updator+'"/>'+'<input type="hidden"  name="modifi_date' + '_' + rowNum + '" value="'+modifi_date+'"/>';
	tr.insertCell().innerHTML = '<input type="hidden"  name="org_sub_id' + '_' + rowNum + '" value="'+org_sub_id+'"/>'+'<input type="hidden"  name="month_no' + '_' + rowNum + '" value="'+month_no+'"/>'+'<input type="text"  class="input_width" name="otshould_number' + '_' + rowNum + '" value="'+otshould_number+'" onblur="allNumber();"  />';
	tr.insertCell().innerHTML = '<input type="text" class="input_width" name="otactual_number' + '_' + rowNum + '" value="'+otactual_number+'" onblur="allNumber();" />';				
 	tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="hours' + '_' + rowNum + '" value="'+hours+'" onblur="sumNum('+rowNum+');allNumber();"  />';		
	tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="project_num' + '_' + rowNum + '" value="'+project_num+'" onblur="allNumber();" />';		
	tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="people_reaction' + '_' + rowNum + '"  onblur="sumNum('+rowNum+');allNumber();"   value="'+people_reaction+'" />';		
	tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="people_position' + '_' + rowNum + '" onblur="sumNum('+rowNum+');allNumber();"  value="'+people_position+'" />';		
	tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="protective' + '_' + rowNum + '" onblur="sumNum('+rowNum+');allNumber();" value="'+protective+'" />';		
	tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="tools' + '_' + rowNum + '"  onblur="sumNum('+rowNum+');allNumber();" value="'+tools+'" />';		
	tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="man_machine' + '_' + rowNum + '" onblur="sumNum('+rowNum+');allNumber();" value="'+man_machine+'" />';		
	tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="clean_tidy' + '_' + rowNum + '" onblur="sumNum('+rowNum+');allNumber();" value="'+clean_tidy+'" />';		
	tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="people_management' + '_' + rowNum + '" onblur="sumNum('+rowNum+');allNumber();" value="'+people_management+'" />';		
	tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="system_program' + '_' + rowNum + '" onblur="sumNum('+rowNum+');allNumber();" value="'+system_program+'" />';		
	tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="sum_num' + '_' + rowNum + '" onblur="allNumber();" value="'+sum_num+'" />';		
	tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="hour_number' + '_' + rowNum + '" onblur="allNumber();" value="'+hour_number+'" />';	
	document.getElementById("lineNum").value = parseInt(rowNum) + 1;	
	  
	
}
 
 
function sumNum(i){			 
 
    var sum_num=0;  
	var   num1=document.getElementsByName("people_reaction_"+i)[0].value;					
	var   num2 =document.getElementsByName("people_position_"+i)[0].value;				
	var   num3=document.getElementsByName("protective_"+i)[0].value;					
	var   num4 =document.getElementsByName("tools_"+i)[0].value;	
	var   num5=document.getElementsByName("man_machine_"+i)[0].value;					
	var   num6 =document.getElementsByName("clean_tidy_"+i)[0].value;	
	var   num7=document.getElementsByName("people_management_"+i)[0].value;					
	var   num8 =document.getElementsByName("system_program_"+i)[0].value;	
 
if(checkNaN("people_reaction_"+i)){
	sum_num = parseFloat(sum_num)+parseFloat(num1);

 	}
if(checkNaN("people_position_"+i)){
	sum_num = parseFloat(sum_num)+parseFloat(num2);
}

if(checkNaN("protective_"+i)){
	sum_num = parseFloat(sum_num)+parseFloat(num3);
}


if(checkNaN("tools_"+i)){
	sum_num = parseFloat(sum_num)+parseFloat(num4);
}

if(checkNaN("man_machine_"+i)){
	sum_num = parseFloat(sum_num)+parseFloat(num5);
}

if(checkNaN("clean_tidy_"+i)){
	sum_num = parseFloat(sum_num)+parseFloat(num6);
}

if(checkNaN("people_management_"+i)){
	sum_num = parseFloat(sum_num)+parseFloat(num7);
}
if(checkNaN("system_program_"+i)){
	sum_num = parseFloat(sum_num)+parseFloat(num8);
}
var hours =document.getElementsByName("hours_"+i)[0].value;

if(hours ==""){hours="1"; }
if(hours =="0"){hours="1"; }
document.getElementsByName("hour_number_"+i)[0].value=substrin(sum_num)/substrin(hours);
 
 document.getElementsByName("sum_num_"+i)[0].value=substrin(sum_num);
 
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

 
function allNumber(){	 
	var a1=0;
	var a2=0;
	var a3=0;
	var a4=0;
	var a5=0;
	var a6=0;
	var a7=0;				
	var a8=0;
	var a9=0;
	var a10=0;
	var a11=0;
	var a12=0;
	var a13=0;
	var a14=0;
	var a15=0;				
	var a16=0;
	 
	var rowNum = document.getElementById("lineNum").value;	
	for(var i=0;i<rowNum;i++){		 
		var oshould_number =document.getElementsByName("otshould_number_"+i)[0].value; 
		var oactual_number =document.getElementsByName("otactual_number_"+i)[0].value;  
		var hours =document.getElementsByName("hours_"+i)[0].value; 
		var project_num =document.getElementsByName("project_num_"+i)[0].value; 
		var people_reaction =document.getElementsByName("people_reaction_"+i)[0].value; 
		var people_position =document.getElementsByName("people_position_"+i)[0].value; 
		var protective =document.getElementsByName("protective_"+i)[0].value; 
		var tools =document.getElementsByName("tools_"+i)[0].value; 
		var man_machine =document.getElementsByName("man_machine_"+i)[0].value; 
		var clean_tidy =document.getElementsByName("clean_tidy_"+i)[0].value; 
		var people_management =document.getElementsByName("people_management_"+i)[0].value; 
		var system_program =document.getElementsByName("system_program_"+i)[0].value; 
		var sum_num =document.getElementsByName("sum_num_"+i)[0].value; 
		var hour_numbers =document.getElementsByName("hour_number_"+i)[0].value; 	
						
								
	if(checkNaN("otshould_number_"+i)){
		a1 = parseFloat(a1)+parseFloat(oshould_number);
	 	}
	if(checkNaN("otactual_number_"+i)){			 
		a2 = parseFloat(a2)+parseFloat(oactual_number);
	 	}
	 
	if(checkNaN("hours_"+i)){
		a5 = parseFloat(a5)+parseFloat(hours);
	}
	if(checkNaN("project_num_"+i)){
		a6 = parseFloat(a6)+parseFloat(project_num);
	}
	if(checkNaN("people_reaction_"+i)){
		a7 = parseFloat(a7)+parseFloat(people_reaction);
	}
	
	if(checkNaN("people_position_"+i)){
		a8 = parseFloat(a8)+parseFloat(people_position);
	}
	if(checkNaN("protective_"+i)){
		a9 = parseFloat(a9)+parseFloat(protective);
	}
	if(checkNaN("tools_"+i)){
		a10 = parseFloat(a10)+parseFloat(tools);
	}
	if(checkNaN("man_machine_"+i)){
		a11 = parseFloat(a11)+parseFloat(man_machine);
	}
	if(checkNaN("clean_tidy_"+i)){
		a12 = parseFloat(a12)+parseFloat(clean_tidy);
	}
	if(checkNaN("people_management_"+i)){
		a13 = parseFloat(a13)+parseFloat(people_management);
	}
	if(checkNaN("system_program_"+i)){
		a14 = parseFloat(a14)+parseFloat(system_program);
	}
	if(checkNaN("sum_num_"+i)){
		a15 = parseFloat(a15)+parseFloat(sum_num);
	}
	if(checkNaN("hour_number_"+i)){
		a16 = parseFloat(a16)+parseFloat(hour_numbers);
	}
	 
	document.getElementById("sum_oshould_number").innerText=substrin(a1);
	document.getElementById("sum_oactual_number").innerText=substrin(a2);
	document.getElementById("sum_hours").innerText=substrin(a5);
	document.getElementById("sum_project_num").innerText=substrin(a6);
	document.getElementById("sum_people_reaction").innerText=substrin(a7);
	document.getElementById("sum_people_position").innerText=substrin(a8);
	document.getElementById("sum_protective").innerText=substrin(a9);
	document.getElementById("sum_tools").innerText=substrin(a10);
	document.getElementById("sum_man_machine").innerText=substrin(a11);
	document.getElementById("sum_clean_tidy").innerText=substrin(a12);
	document.getElementById("sum_people_management").innerText=substrin(a13);
	document.getElementById("sum_system_program").innerText=substrin(a14);
	document.getElementById("sum_sum_num").innerText=substrin(a15);
	document.getElementById("sum_hour_number").innerText=substrin(a16);
	}
 
}

 
   if(action =="edit"){	   

		var querySql = "";
		var queryRet = null;
		var  datas =null;				
		querySql = " select  analysis_statistics, suggested from    BGP_HSE_MONTH_RECORD  where  bsflag='0'   and recore_id='"+recore_id+"' and  month_no='"+month_no+"' ";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas; 
			if(datas != null && datas != ''  ){	
		 		 document.getElementsByName("analysis_statistics")[0].value=datas[0].analysis_statistics;
		 		 document.getElementsByName("suggested")[0].value=datas[0].suggested;
			}					
		
	    	}			
 	 
		var querySql1="";
		var queryRet1=null;
		var datas1 =null;
		 
		 document.getElementById("lineNum").value="0";	
			   querySql1 = "select tr.mrstatistics_no,tr.recore_id, i.org_abbreviation as org_name ,tr.org_sub_id,tr.month_no,tr.sum_oshould_number,tr.sum_oactual_number,tr.sum_tshould_number,tr.sum_tactual_number,tr.sum_hours,tr.sum_project_num,tr.sum_people_reaction,tr.sum_people_position,tr.sum_protective,tr.sum_tools,tr.sum_man_machine,tr.sum_clean_tidy,tr.sum_people_management,tr.sum_system_program,tr.sum_sum_num,tr.sum_hour_number, tr.analysis_statistics,tr.suggested ,tr.creator,tr.create_date,tr.updator,tr.modifi_date,tr.bsflag  from   BGP_MONTH_RECORD_STATISTICS  tr    join  BGP_HSE_MONTH_RECORD hd on tr.recore_id=hd.recore_id and hd.bsflag='0' and hd.subflag='3'   join comm_org_subjection s    on tr.org_sub_id = s.org_subjection_id   and s.bsflag = '0'  join comm_org_information i    on s.org_id = i.org_id   and i.bsflag = '0'     where  tr.bsflag='0'   and tr.month_no='"+month_no+"'    order by  tr.modifi_date";
			   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
				if(queryRet1.returnCode=='0'){
				  datas1 = queryRet1.datas;	

					if(datas1 != null && datas1 != ''){	
						for(var i = 0; i<datas1.length; i++){ 
							toAddLine(datas1[i].mrstatistics_no,datas1[i].recore_id,datas1[i].org_name,datas1[i].org_sub_id,datas1[i].month_no,datas1[i].sum_oshould_number,datas1[i].sum_oactual_number,datas1[i].sum_tshould_number,datas1[i].sum_tactual_number,datas1[i].sum_hours,datas1[i].sum_project_num,datas1[i].sum_people_reaction,datas1[i].sum_people_position,datas1[i].sum_protective,datas1[i].sum_tools,datas1[i].sum_man_machine,datas1[i].sum_clean_tidy,datas1[i].sum_people_management,datas1[i].sum_system_program,datas1[i].sum_sum_num,datas1[i].sum_hour_number,datas1[i].creator,datas1[i].create_date,datas1[i].updator,datas1[i].modifi_date,datas1[i].bsflag);
						}
						
					}
			    }	
		
				   allNumber();
	   
   }
	 
 	function toBack(){
		//window.parent.parent.location='mainPage.jsp';
 		window.parent.location='<%=contextPath%>/hse/hseOptionPage/hseMonthlyReport/companyMonthlyReport.jsp';
	}
	
</script>
</html>

