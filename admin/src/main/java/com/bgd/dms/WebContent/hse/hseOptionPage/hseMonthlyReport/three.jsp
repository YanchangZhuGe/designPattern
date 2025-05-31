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
			    <auth:ListButton functionId="" id="zj" css="zj" event="onclick='toAddLine()'" title="JCDP_btn_add"></auth:ListButton>
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
				<td rowspan="2">操作</td>
				<td colspan="3">直属单位</td>
				<td colspan="3" >基层单位</td>
				<td rowspan="2" >观察与沟通时长（小时）</td>
				<td rowspan="2" >安全项目数量</td>
				<td colspan="9" >不安全行为数量</td>
				<td rowspan="2">每小时安全项目次数</td>
        	</tr>
			<tr class="bt_info">
			  <td height="74">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;单位名称&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>应实施人数&nbsp;&nbsp;&nbsp;</td>
				<td>实际实施人数</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;单位名称&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>应实施人数&nbsp;&nbsp;&nbsp;</td>
				<td>实际实施人数</td>
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
			  <td height="74" colspan="2">合计
			    <input type="hidden" id="bsflag" name="bsflag" value="0" />
		      	<input type="hidden" id="month_no" name="month_no" value="" />
		      	<input type="hidden" id="recore_id" name="recore_id" value="" />
				<input type="hidden" id="org_sub_id" name="org_sub_id" class="input_width" />
				<input type="hidden" id="mrstatistics_no" name="mrstatistics_no" class="input_width" />
			     </td> 
			  <td> <input type="text" id="sum_oshould_number"   name="sum_oshould_number" class="input_width" /></td>
			  <td>  <input type="text" id="sum_oactual_number"   name="sum_oactual_number" class="input_width" /></td>
			  <td> ——— </td>			  
			  <td>  <input type="text" id="sum_tshould_number"   name="sum_tshould_number" class="input_width" /></td>
			  <td>  <input type="text" id="sum_tactual_number"   name="sum_tactual_number" class="input_width" /></td>
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
			  <td colspan="17">&nbsp;<textarea id="analysis_statistics" name="analysis_statistics"   style="height:100px;" class="textarea" ></textarea></td>
	    </tr>
	 	
				<tr class="even">
			  <td height="74" colspan="2">改进建议：</td>
			  <td colspan="17">&nbsp;<textarea id="suggested" name="suggested"   style="height:100px;" class="textarea" ></textarea></td>
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
if(subflag!="审批不通过"  && subflag!="4" ){
	document.getElementById("bc").style.display="none";
	document.getElementById("zj").style.display="none";
}else{
	document.getElementById("bc").style.display="true";
	document.getElementById("zj").style.display="true"; 
}

function toAdd(){ 	
	var rowNum = document.getElementById("lineNum").value;			
	var rowParams = new Array();
		var mrstatistics_nos = document.getElementsByName("mrstatistics_no")[0].value;						
		var recore_id = document.getElementsByName("recore_id")[0].value;	
		if(recore_id == "") recore_id='<%=record_id%>';
		var org_sub_id = document.getElementsByName("org_sub_id")[0].value;			
		if(org_sub_id == "") org_sub_id='<%=org_sub_id%>';
		var month_no = document.getElementsByName("month_no")[0].value;		
		if( month_no == "") month_no='<%=month_no%>';
 
		var   sum_oshould_number = document.getElementsByName("sum_oshould_number")[0].value;
		var   sum_oactual_number = document.getElementsByName("sum_oactual_number")[0].value;		
		var   sum_tshould_number = document.getElementsByName("sum_tshould_number")[0].value;		
		var   sum_tactual_number= document.getElementsByName("sum_tactual_number")[0].value;		
		var   sum_hours= document.getElementsByName("sum_hours")[0].value;		
		var   sum_project_num= document.getElementsByName("sum_project_num")[0].value;		
		var   sum_people_reaction= document.getElementsByName("sum_people_reaction")[0].value;		
		var   sum_people_position= document.getElementsByName("sum_people_position")[0].value;		
		var   sum_protective= document.getElementsByName("sum_protective")[0].value;		
		var   sum_tools= document.getElementsByName("sum_tools")[0].value;		
		var   sum_man_machine = document.getElementsByName("sum_man_machine")[0].value;		
		var   sum_clean_tidy= document.getElementsByName("sum_clean_tidy")[0].value;		
		var   sum_people_management= document.getElementsByName("sum_people_management")[0].value;		
		var   sum_system_program= document.getElementsByName("sum_system_program")[0].value;		
		var   sum_sum_num= document.getElementsByName("sum_sum_num")[0].value;		
		var   sum_hour_number= document.getElementsByName("sum_hour_number")[0].value;		
		var   analysis_statistics= document.getElementsByName("analysis_statistics")[0].value;
		var   suggested= document.getElementsByName("suggested")[0].value;
	  	
		var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
	var submitStr = 'JCDP_TABLE_NAME=BGP_MONTH_RECORD_STATISTICS&JCDP_TABLE_ID='+mrstatistics_nos+'&org_sub_id='+org_sub_id
	+'&recore_id='+recore_id+'&month_no='+month_no+'&sum_oshould_number='+sum_oshould_number+'&sum_oactual_number='+sum_oactual_number	
	+'&sum_tshould_number='+sum_tshould_number+'&sum_tactual_number='+sum_tactual_number+'&sum_hours='+sum_hours+'&sum_project_num='+sum_project_num
	+'&sum_people_reaction='+sum_people_reaction+'&sum_people_position='+sum_people_position+'&sum_protective='+sum_protective+'&sum_tools='+sum_tools
	+'&sum_man_machine='+sum_man_machine+'&sum_clean_tidy='+sum_clean_tidy+'&sum_people_management='+sum_people_management+'&sum_system_program='+sum_system_program
	+'&sum_sum_num='+sum_sum_num+'&sum_hour_number='+sum_hour_number+'&analysis_statistics='+analysis_statistics+'&suggested='+suggested;
	
	if(mrstatistics_nos!=null && mrstatistics_nos !=''){		
		submitStr =submitStr+'&updator=<%=userName%>&modifi_date=<%=curDate%>&bsflag=0';			
	}else {		
		submitStr =submitStr+'&creator=<%=userName%>&updator=<%=userName%>&create_date=<%=curDate%>&modifi_date=<%=curDate%>&bsflag=0';
	}
	
	var retObject = syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		
	var mrstatistics_noS=retObject.entity_id; //获得 主表id 				
	
		for(var i=0;i<rowNum;i++){
			var rowParam = {};		
			var sdetail_no =document.getElementsByName("sdetail_no_"+i)[0].value; 
			var mrstatistics_no =document.getElementsByName("mrstatistics_no_"+i)[0].value; 
			var ounit_name =document.getElementsByName("ounit_name_"+i)[0].value; 
			var oshould_number =document.getElementsByName("oshould_number_"+i)[0].value; 
			var oactual_number =document.getElementsByName("oactual_number_"+i)[0].value; 
			var tunit_name =document.getElementsByName("tunit_name_"+i)[0].value; 
			var tshould_number =document.getElementsByName("tshould_number_"+i)[0].value; 
			var tactual_number =document.getElementsByName("tactual_number_"+i)[0].value; 
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
			var hour_number =document.getElementsByName("hour_number_"+i)[0].value; 			
			var creator = document.getElementsByName("creator_"+i)[0].value; 
			var create_date = document.getElementsByName("create_date_"+i)[0].value; 
			var updator = document.getElementsByName("updator_"+i)[0].value; 
			var modifi_date = document.getElementsByName("modifi_date_"+i)[0].value; 
			var bsflag = document.getElementsByName("bsflag_"+i)[0].value; 
						
			if(sdetail_no !=null && sdetail_no !=''){			
 				rowParam['ounit_name'] = encodeURI(encodeURI(ounit_name));
				rowParam['tunit_name'] = encodeURI(encodeURI(tunit_name));
				rowParam['sdetail_no'] = sdetail_no;
				rowParam['mrstatistics_no'] =mrstatistics_no; 				
			    rowParam['oshould_number'] = oshould_number;
			    rowParam['oactual_number'] = oactual_number;			    
			     rowParam['tshould_number'] =tshould_number;
				 rowParam['tactual_number'] =tactual_number;
				 rowParam['hours'] =hours;
				 rowParam['project_num'] =project_num;
				 rowParam['people_reaction'] =people_reaction;
				 rowParam['people_position'] =people_position;
				 rowParam['protective'] =protective;
				 rowParam['tools'] =tools;
				 rowParam['man_machine'] =man_machine;
				 rowParam['clean_tidy'] =clean_tidy;
				 rowParam['people_management'] =people_management;
				 rowParam['system_program'] =system_program;
				 rowParam['sum_num'] =sum_num;
				 rowParam['hour_number'] =hour_number;
		 
				rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['create_date'] ='<%=curDate%>';	
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';	
				rowParam['bsflag'] = bsflag;	
				
			}else{
				rowParam['ounit_name'] = encodeURI(encodeURI(ounit_name));
				rowParam['tunit_name'] = encodeURI(encodeURI(tunit_name));
				rowParam['sdetail_no'] = sdetail_no;
				rowParam['mrstatistics_no'] =mrstatistics_noS; 				
			    rowParam['oshould_number'] = oshould_number;
			    rowParam['oactual_number'] = oactual_number;			    
			     rowParam['tshould_number'] =tshould_number;
				 rowParam['tactual_number'] =tactual_number;
				 rowParam['hours'] =hours;
				 rowParam['project_num'] =project_num;
				 rowParam['people_reaction'] =people_reaction;
				 rowParam['people_position'] =people_position;
				 rowParam['protective'] =protective;
				 rowParam['tools'] =tools;
				 rowParam['man_machine'] =man_machine;
				 rowParam['clean_tidy'] =clean_tidy;
				 rowParam['people_management'] =people_management;
				 rowParam['system_program'] =system_program;
				 rowParam['sum_num'] =sum_num;
				 rowParam['hour_number'] =hour_number;
		 
				rowParam['creator'] = encodeURI(encodeURI(creator));
				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;		 
			}
				rowParams[rowParams.length] = rowParam; 
 
		}
			var rows=JSON.stringify(rowParams);			 
			saveFunc("BGP_MONTH_STATISTICS_DETAIL",rows);	
 
}

function toAddLine(sdetail_nos,mrstatistics_nos,ounit_names,oshould_numbers,oactual_numbers,tunit_names,tshould_numbers,tactual_numbers,hourss,project_nums,people_reactions,people_positions,protectives,toolss,man_machines,clean_tidys,people_managements,system_programs,sum_nums,hour_numbers,creators,create_dates,updators,modifi_dates,bsflags){
	
	var sdetail_no ="";
	var mrstatistics_no ="";
	var ounit_name =org_name;
	var oshould_number ="";
	var oactual_number ="";
	var tunit_name =org_name;
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
	
	
	if(sdetail_nos != null && sdetail_nos != ""){
		sdetail_no=sdetail_nos;
	}
	if(mrstatistics_nos != null && mrstatistics_nos != ""){
		mrstatistics_no=mrstatistics_nos;
	}
	if(ounit_names != null && ounit_names != ""){
		ounit_name=ounit_names;
	}
	
	if(oshould_numbers != null && oshould_numbers != ""){
		oshould_number=oshould_numbers;
	}
	if(oactual_numbers != null && oactual_numbers != ""){
		oactual_number=oactual_numbers;
	}
	if(tunit_names != null && tunit_names != ""){
		tunit_name=tunit_names;
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
	
	document.getElementById("lineNum").value = parseInt(rowNum) + 1;	
	var td = tr.insertCell(); 
	td.style.display = "";
	
	td.innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/>'+'<img src="'+'<%=contextPath%>'+'/images//delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + tr.id + '\')"/>';
 
	tr.insertCell().innerHTML = '<input type="hidden"  name="sdetail_no' + '_' + rowNum + '" value="'+sdetail_no+'"/>'+'<input type="text" class="input_width" name="ounit_name' + '_' + rowNum + '"   readonly="readonly"  value="'+ounit_name+'" />'+'<input type="hidden"  name="mrstatistics_no' + '_' + rowNum + '" value="'+mrstatistics_no+'"/>'+'<input type="hidden"  name="bsflag' + '_' + rowNum + '" value="0"/>'+'<input type="hidden"  name="creator' + '_' + rowNum + '" value="'+creator+'"/>'+'<input type="hidden"  name="create_date' + '_' + rowNum + '" value="'+create_date+'"/>'+'<input type="hidden"  name="updator' + '_' + rowNum + '" value="'+updator+'"/>'+'<input type="hidden"  name="modifi_date' + '_' + rowNum + '" value="'+modifi_date+'"/>';
	tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="oshould_number' + '_' + rowNum + '" value="'+oshould_number+'" onblur="chuange1('+rowNum+');allNumber();"  />';
	tr.insertCell().innerHTML = '<input type="text" class="input_width" name="oactual_number' + '_' + rowNum + '" value="'+oactual_number+'" onblur="chuange1('+rowNum+');allNumber();" />';				
	tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="tunit_name' + '_' + rowNum + '" value="'+tunit_name+'" />';		
	tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="tshould_number' + '_' + rowNum + '" value="'+tshould_number+'" onblur="chuange2('+rowNum+');allNumber();" />';		
	tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="tactual_number' + '_' + rowNum + '" value="'+tactual_number+'" onblur="chuange2('+rowNum+');allNumber();" />';		
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
		 
	
}
 
function chuange1(i){ 
	var   num1=document.getElementsByName("oshould_number_"+i)[0].value;					
	var   num2 =document.getElementsByName("oactual_number_"+i)[0].value;	
	var   num3=document.getElementsByName("tshould_number_"+i)[0].value;					
	var   num4 =document.getElementsByName("tactual_number_"+i)[0].value;	
	if(num1 !=""  || num2 !="" ){
		if(num3 !="" || num4 !="" ){
		alert('基层单位信息不可填！');
		document.getElementsByName("tshould_number_"+i)[0].value="";		
		document.getElementsByName("tactual_number_"+i)[0].value="";
		}
	}
	
}

function chuange2(i){ 
	var   num1=document.getElementsByName("oshould_number_"+i)[0].value;					
	var   num2 =document.getElementsByName("oactual_number_"+i)[0].value;	
	var   num3=document.getElementsByName("tshould_number_"+i)[0].value;					
	var   num4 =document.getElementsByName("tactual_number_"+i)[0].value;	
	if(num3 !=""  || num4 !="" ){
		if(num1 !="" || num2 !="" ){
		alert('直属单位信息不可填！');
		document.getElementsByName("oshould_number_"+i)[0].value="";		
		document.getElementsByName("oactual_number_"+i)[0].value="";
		}
	}
	
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
		var oshould_number =document.getElementsByName("oshould_number_"+i)[0].value; 
		var oactual_number =document.getElementsByName("oactual_number_"+i)[0].value; 
		var tshould_number =document.getElementsByName("tshould_number_"+i)[0].value; 
		var tactual_number =document.getElementsByName("tactual_number_"+i)[0].value; 
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
						
								
	if(checkNaN("oshould_number_"+i)){
		a1 = parseFloat(a1)+parseFloat(oshould_number);
	 	}
	if(checkNaN("oactual_number_"+i)){			 
		a2 = parseFloat(a2)+parseFloat(oactual_number);
	 	}
	if(checkNaN("tshould_number_"+i)){
		a3 = parseFloat(a3)+parseFloat(tshould_number);
	}
	if(checkNaN("tactual_number_"+i)){
		a4 = parseFloat(a4)+parseFloat(tactual_number);
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
	document.getElementById("sum_tshould_number").innerText=substrin(a3);
	document.getElementById("sum_tactual_number").innerText=substrin(a4);
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

function clearNum(i){	  
	    document.getElementsByName("oshould_number_"+i)[0].value="0";
		document.getElementsByName("oactual_number_"+i)[0].value="0";
		document.getElementsByName("tshould_number_"+i)[0].value="0";
		document.getElementsByName("tactual_number_"+i)[0].value="0";
		document.getElementsByName("hours_"+i)[0].value="0";
		document.getElementsByName("project_num_"+i)[0].value="0";
		document.getElementsByName("people_reaction_"+i)[0].value="0";
		document.getElementsByName("people_position_"+i)[0].value="0";
		document.getElementsByName("protective_"+i)[0].value="0";
		document.getElementsByName("tools_"+i)[0].value="0";
		document.getElementsByName("man_machine_"+i)[0].value="0";
		document.getElementsByName("clean_tidy_"+i)[0].value="0";
		document.getElementsByName("people_management_"+i)[0].value="0";
		document.getElementsByName("system_program_"+i)[0].value="0";
		document.getElementsByName("sum_num_"+i)[0].value="0";
	    document.getElementsByName("hour_number_"+i)[0].value="0";	
 
}

function deleteLine(lineId){		
	var rowNum = lineId.split('_')[1];
	 clearNum(rowNum);
	 allNumber();
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

		var querySql = "";
		var queryRet = null;
		var  datas =null;				
		querySql = " select tr.mrstatistics_no,tr.recore_id,tr.org_sub_id,tr.month_no,tr.sum_oshould_number,tr.sum_oactual_number,tr.sum_tshould_number,tr.sum_tactual_number,tr.sum_hours,tr.sum_project_num,tr.sum_people_reaction,tr.sum_people_position,tr.sum_protective,tr.sum_tools,tr.sum_man_machine,tr.sum_clean_tidy,tr.sum_people_management,tr.sum_system_program,tr.sum_sum_num,tr.sum_hour_number, tr.analysis_statistics,tr.suggested  from   BGP_MONTH_RECORD_STATISTICS  tr  where  tr.bsflag='0' and tr.recore_id='<%=record_id%>' and tr.month_no='<%=month_no%>' and tr.org_sub_id='<%=org_sub_id%>' ";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null && datas != ''){			 
			      document.getElementsByName("mrstatistics_no")[0].value=datas[0].mrstatistics_no;
				 document.getElementsByName("recore_id")[0].value=datas[0].recore_id;
				 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;			
				 document.getElementsByName("month_no")[0].value=datas[0].month_no;			 
					
		         document.getElementsByName("sum_oshould_number")[0].value=datas[0].sum_oshould_number;
		 		 document.getElementsByName("sum_oactual_number")[0].value=datas[0].sum_oactual_number;		
		 	     document.getElementsByName("sum_tshould_number")[0].value=datas[0].sum_tshould_number;		
		 		 document.getElementsByName("sum_tactual_number")[0].value=datas[0].sum_tactual_number;		
		 	     document.getElementsByName("sum_hours")[0].value=datas[0].sum_hours;		
		         document.getElementsByName("sum_project_num")[0].value=datas[0].sum_project_num;		
		 	     document.getElementsByName("sum_people_reaction")[0].value=datas[0].sum_people_reaction;		
		 		 document.getElementsByName("sum_people_position")[0].value=datas[0].sum_people_position;		
		 		 document.getElementsByName("sum_protective")[0].value=datas[0].sum_protective;		
		 		 document.getElementsByName("sum_tools")[0].value=datas[0].sum_tools;		
		 		 document.getElementsByName("sum_man_machine")[0].value=datas[0].sum_man_machine;		
		 	     document.getElementsByName("sum_clean_tidy")[0].value=datas[0].sum_clean_tidy;		
		 		 document.getElementsByName("sum_people_management")[0].value=datas[0].sum_people_management;		
		 		 document.getElementsByName("sum_system_program")[0].value=datas[0].sum_system_program;		
		 		 document.getElementsByName("sum_sum_num")[0].value=datas[0].sum_sum_num;		
		 		 document.getElementsByName("sum_hour_number")[0].value=datas[0].sum_hour_number;		
		 		 document.getElementsByName("analysis_statistics")[0].value=datas[0].analysis_statistics;
		 		 document.getElementsByName("suggested")[0].value=datas[0].suggested;
			}					
		
	    	}			
		
		var querySql1="";
		var queryRet1=null;
		var datas1 =null;
		 
		 document.getElementById("lineNum").value="0";	
		 var mrstatistics_no= document.getElementById("mrstatistics_no").value;
			   querySql1 = " select sd.sdetail_no,sd.mrstatistics_no,sd.ounit_name,sd.oshould_number,sd.oactual_number,sd.tunit_name,sd.tshould_number,sd.tactual_number,sd.hours,sd.project_num,sd.people_reaction,sd.people_position,sd.protective,sd.tools,sd.man_machine,sd.clean_tidy,sd.people_management,sd.system_program,sd.sum_num,sd.hour_number ,sd.creator,sd.create_date,sd.updator,sd.modifi_date,sd.bsflag    from   BGP_MONTH_STATISTICS_DETAIL  sd  where sd.bsflag='0' and sd.mrstatistics_no='" + mrstatistics_no + "'  order by  sd.modifi_date";
			   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
				if(queryRet1.returnCode=='0'){
				  datas1 = queryRet1.datas;	

					if(datas1 != null && datas1 != ''){							 
					  						 
						for(var i = 0; i<datas1.length; i++){	 
		                  toAddLine(datas1[i].sdetail_no,datas1[i].mrstatistics_no,datas1[i].ounit_name,datas1[i].oshould_number,datas1[i].oactual_number,datas1[i].tunit_name,datas1[i].tshould_number,datas1[i].tactual_number,datas1[i].hours,datas1[i].project_num,datas1[i].people_reaction,datas1[i].people_position,datas1[i].protective,datas1[i].tools,datas1[i].man_machine,datas1[i].clean_tidy,datas1[i].people_management,datas1[i].system_program,datas1[i].sum_num,datas1[i].hour_number,datas1[i].creator,datas1[i].create_date,datas1[i].updator,datas1[i].modifi_date,datas1[i].bsflag);
		  		      
						}
						
					}
			    }	
		
	   
	   
   }
	 
 	function toBack(){
		window.parent.parent.location='mainPage.jsp';
	}
	
</script>
</html>

