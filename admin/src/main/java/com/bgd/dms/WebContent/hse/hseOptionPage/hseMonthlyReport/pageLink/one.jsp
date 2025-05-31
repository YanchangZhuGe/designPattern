<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
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
    String subflag= ""; 
	if(request.getParameter("month_no")!=null && request.getParameter("month_no")!="" )month_no = request.getParameter("month_no");	
	if(request.getParameter("org_sub_id")!=null && request.getParameter("org_sub_id")!="" )org_sub_id = request.getParameter("org_sub_id");
	if(request.getParameter("record_id")!=null && request.getParameter("record_id")!="" )record_id = request.getParameter("record_id");
	if(request.getParameter("action")!=null && request.getParameter("action")!="" )action = request.getParameter("action");
	if(request.getParameter("subflag")!=null && request.getParameter("subflag")!="" )subflag = request.getParameter("subflag");

	Date now = new Date();	
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getUserName();
		//(user==null)?"":user.getEmpId();
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
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

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
<title>HSE管理基本信息：</title>
</head>
  <style type="text/css">
   <!--.tnt {Writing-mode:tb-rl;Text-align:center;vertical-align:top;}-->

   </style>

<body class="bgColor_f3f3f3"  >       
      	<div id="list_table" >
			<div id="inq_tool_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" >
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
			<div id="table_box" >
			  <table width="173%" height="373" border="1" cellpadding="0" cellspacing="0" class="tab_info" id="queryRetTable">
			<tr class="bt_info">
				<td height="34">&nbsp;</td>
				<td height="34">用工总人数</td>
				<td height="34">&nbsp;</td>
				<td height="34">&nbsp;</td>
				<td height="34">&nbsp;</td>
				<td height="34">&nbsp;</td>
				<td >用工总工时</td>
				<td >&nbsp;</td>
				<td >&nbsp;</td>
				<td >&nbsp;</td>
				<td >&nbsp;</td>
				<td height="44">HSE 奖励</td>
				<td height="44">&nbsp;</td>
				<td height="44">&nbsp;</td>
				<td>HSE 处罚</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td width="9%">&nbsp;</td>
			</tr>
			<tr class="bt_info">
			  <td width="13%" height="40" >&nbsp;&nbsp;&nbsp;&nbsp;单位名称 &nbsp;&nbsp;&nbsp;&nbsp;
		      	<input type="hidden" id="lineNum" name="lineNum" value="0"></input></td>
			  <td width="5%" height="40" >野外员工&nbsp;&nbsp;</td>
			  <td width="5%">二线员工&nbsp;&nbsp;</td>
			  <td width="5%">集团承包工时</td>
			  <td width="5%">外部承包工时</td>
			  <td width="4%">&nbsp;&nbsp;合计&nbsp;&nbsp;&nbsp;&nbsp;</td>
			  <td width="5%">野外工时&nbsp;&nbsp;</td>
			  <td width="5%">二线工时&nbsp;&nbsp;</td>
			  <td width="5%">集团承包工时</td>
			  <td width="5%">外部承包工时</td>
			  <td width="3%">&nbsp;&nbsp;合计&nbsp;&nbsp;&nbsp;&nbsp;</td>
			  <td width="3%" height="44">&nbsp;&nbsp;单位&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td width="3%">&nbsp;&nbsp;个人&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td width="4%">&nbsp;&nbsp;金额（元）</td>
				<td width="4%">&nbsp;&nbsp;单位&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td width="4%">&nbsp;&nbsp;待岗&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td width="4%">&nbsp;&nbsp;离岗&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td width="4%">&nbsp;&nbsp;辞退&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td width="5%">经济处罚</td>
				<td width="5%">金额（元）</td>
			</tr>
			 
			 
			 
				<tr class="even">
				  <td height="111" colspan="2" >其他工作：</td>
				  <td colspan="18">&nbsp;<textarea id="other_work" name="other_work"   style="height:60px;" class="textarea" ></textarea></td>
		        </tr>
				<tr class="even">
				  <td height="128" colspan="2" >第三方伤害：</td>
				  <td colspan="18">&nbsp;<textarea id="third_damage" name="third_damage"   style="height:60px;"   class="textarea" ></textarea></td>
		        </tr>
			  </table>
			</div>
 
		  </div>
 
</body>

<script type="text/javascript">
	$("#table_box").css("height",$(window).height()-40);
	cruConfig.contextPath =  "<%=contextPath%>";	 
	cruConfig.cdtType = 'form';	 
	var recore_id='<%=record_id%>'; 
	var month_no='<%=month_no%>';
	var org_sub_id='<%=org_sub_id%>';
	var action='<%=action%>';
	var subflag='<%=subflag%>';
	if(subflag!="未提交" && subflag!="0" ){
		document.getElementById("bc").style.display="none";
	}else{
		document.getElementById("bc").style.display="true"; 
	}
	if(subflag!="审批不通过" && subflag!="5" ){
		document.getElementById("bc").style.display="none";
	}else{
		document.getElementById("bc").style.display="true"; 
	}
	
	function sumNum1(i){				 
	    var sum_num=0; 
		var  num1=document.getElementsByName("field_staff_"+i)[0].value;					
		var num2 =document.getElementsByName("two_employees_"+i)[0].value;			
		var num3 =document.getElementsByName("group_contractors_"+i)[0].value;	
		var num4 =document.getElementsByName("external_contractor_"+i)[0].value;	
		
	if(checkNaN("field_staff_"+i)){
		sum_num = parseFloat(sum_num)+parseFloat(num1); 
	 	}
	if(checkNaN("two_employees_"+i)){
		sum_num = parseFloat(sum_num)+parseFloat(num2);
	}
	if(checkNaN("group_contractors_"+i)){
		sum_num = parseFloat(sum_num)+parseFloat(num3);
	}
	if(checkNaN("external_contractor_"+i)){
		sum_num = parseFloat(sum_num)+parseFloat(num4);
	}
	document.getElementsByName("o_aggreagte_"+i)[0].value=substrin(sum_num);
  
}
	
	function sumNum2(i){				 
	    var sum_num=0; 	  
		var  num1=document.getElementsByName("field_workhours_"+i)[0].value;					
		var num2 =document.getElementsByName("secondline_workhours_"+i)[0].value;			
		var num3 =document.getElementsByName("group_workhours_"+i)[0].value;	
		var num4 =document.getElementsByName("external_workhours_"+i)[0].value;	
		
	if(checkNaN("field_workhours_"+i)){
		sum_num = parseFloat(sum_num)+parseFloat(num1); 
	 	}
	if(checkNaN("secondline_workhours_"+i)){
		sum_num = parseFloat(sum_num)+parseFloat(num2);
	}
	if(checkNaN("group_workhours_"+i)){
		sum_num = parseFloat(sum_num)+parseFloat(num3);
	}
	if(checkNaN("external_workhours_"+i)){
		sum_num = parseFloat(sum_num)+parseFloat(num4);
		}
 
	document.getElementsByName("t_aggreagte_"+i)[0].value=substrin(sum_num);
	  
}
	function sumNum3(i){				 
	    var sum_num=0; 	  		 
		var  num1=document.getElementsByName("o_unit_"+i)[0].value;					
		var num2 =document.getElementsByName("personal_"+i)[0].value;			
	 		
	if(checkNaN("o_unit_"+i)){
		sum_num = parseFloat(sum_num)+parseFloat(num1); 
	 	}
	if(checkNaN("personal_"+i)){
		sum_num = parseFloat(sum_num)+parseFloat(num2);
	}
  
	document.getElementsByName("o_amount_"+i)[0].value=substrin(sum_num);
	
}
	
	function sumNum4(i){				 
	    var sum_num=0; 	   		
		var  num1=document.getElementsByName("t_unit_"+i)[0].value;					
		var num2 =document.getElementsByName("daigang_"+i)[0].value;			
		var num3 =document.getElementsByName("leave_"+i)[0].value;	
		var num4 =document.getElementsByName("dismissal_"+i)[0].value;	
		var num5 =document.getElementsByName("economic_punishment_"+i)[0].value;	
	if(checkNaN("t_unit_"+i)){
		sum_num = parseFloat(sum_num)+parseFloat(num1); 
	 	}
	if(checkNaN("daigang_"+i)){
		sum_num = parseFloat(sum_num)+parseFloat(num2);
	}
	if(checkNaN("leave_"+i)){
		sum_num = parseFloat(sum_num)+parseFloat(num3);
	}
	if(checkNaN("dismissal_"+i)){
		sum_num = parseFloat(sum_num)+parseFloat(num4);
		}
	if(checkNaN("economic_punishment_"+i)){
		sum_num = parseFloat(sum_num)+parseFloat(num5);
		}
 
	document.getElementsByName("t_amount_"+i)[0].value=substrin(sum_num);
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

	function toAddLine(mrmanagement_nos,recore_ids,org_names,org_sub_ids,month_nos,field_staffs,two_employeess,group_contractorss,external_contractors,o_aggreagtes,field_workhourss,secondline_workhourss,group_workhourss,external_workhourss,t_aggreagtes,o_units,personals,o_amounts,t_units,daigangs,leaves,dismissals,economic_punishments,t_amounts,creators,create_dates,updators,modifi_dates,bsflags){
		var mrmanagement_no ="";
		var  recore_id ="";
		var  org_name  ="";
		var  org_sub_id ="";
		var  month_no ="";
		var  field_staff ="";
		var  two_employees ="";
		var  group_contractors ="";
		var  external_contractor ="";
		var  o_aggreagte ="";
		var  field_workhours ="";		
		var  secondline_workhours ="";
		var  group_workhours ="";
		var  external_workhours ="";
		var  t_aggreagte ="";
		var  o_unit ="";
		var  personal ="";
		var  o_amount ="";
		var  t_unit ="";
		var  daigang ="";
		var  leave ="";
		var  dismissal ="";
		var  economic_punishment ="";
		var  t_amount ="";		
		var creator = "";
		var create_date = "";
		var updator = "";
		var modifi_date = "";
		var bsflag = "";		
		
		if(mrmanagement_nos != null && mrmanagement_nos != ""){
			mrmanagement_no=mrmanagement_nos;
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
		if(field_staffs != null && field_staffs != ""){
			field_staff=field_staffs;
		}
		if(two_employeess != null && two_employeess != ""){
			two_employees=two_employeess;
		}
		 
		if(group_contractorss != null && group_contractorss != ""){
			group_contractors=group_contractorss;
		}
		if(external_contractors != null && external_contractors != ""){
			external_contractor=external_contractors;
		}
		if(o_aggreagtes != null && o_aggreagtes != ""){
			o_aggreagte=o_aggreagtes;
		}
		
		if(field_workhourss != null && field_workhourss != ""){
			field_workhours=field_workhourss;
		}
		if(secondline_workhourss != null && secondline_workhourss != ""){
			secondline_workhours=secondline_workhourss;
		}
		if(group_workhourss != null && group_workhourss != ""){
			group_workhours=group_workhourss;
		}
		
		
		if(external_workhourss != null && external_workhourss != ""){
			external_workhours=external_workhourss;
		}
		if(t_aggreagtes != null && t_aggreagtes != ""){
			t_aggreagte=t_aggreagtes;
		}
		if(o_units != null && o_units != ""){
			o_unit=o_units;
		}
		
		if(personals != null && personals != ""){
			personal=personals;
		}
		if(o_amounts != null && o_amounts != ""){
			o_amount=o_amounts;
		}
		if(t_units != null && t_units != ""){
			t_unit=t_units;
		}
		 
		if(daigangs != null && daigangs != ""){
			daigang=daigangs;
		}
		if(leaves != null && leaves != ""){
			leave=leaves;
		}
 
	  	if(dismissals != null && dismissals != ""){
	  		dismissal=dismissals;
		}
		 
		if(economic_punishments != null && economic_punishments != ""){
			economic_punishment=economic_punishments;
		}
		if(t_amounts != null && t_amounts != ""){
			t_amount=t_amounts;
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
		var autoOrder = document.getElementById("queryRetTable").rows.length-2;
		var tr = document.getElementById("queryRetTable").insertRow(autoOrder);
	 
		tr.align="center";		
	  	if(rowNum % 2 == 1){  
	  		tr.className = "odd";
		}else{ 
			tr.className = "even";
		}	
		tr.id = "row_" + rowNum + "_";  
		tr.insertCell().innerHTML = '<input type="hidden"  name="mrmanagement_no' + '_' + rowNum + '" value="'+mrmanagement_no+'"/>'+'<input type="text" class="input_width" name="org_name' + '_' + rowNum + '"   readonly="readonly"  value="'+org_name+'" style="width:80px;" />'+'<input type="hidden"  name="recore_id' + '_' + rowNum + '" value="'+recore_id+'"/>'+'<input type="hidden"  name="bsflag' + '_' + rowNum + '" value="0"/>'+'<input type="hidden"  name="creator' + '_' + rowNum + '" value="'+creator+'"/>'+'<input type="hidden"  name="create_date' + '_' + rowNum + '" value="'+create_date+'"/>'+'<input type="hidden"  name="updator' + '_' + rowNum + '" value="'+updator+'"/>'+'<input type="hidden"  name="modifi_date' + '_' + rowNum + '" value="'+modifi_date+'"/>';
		tr.insertCell().innerHTML = '<input type="hidden"  name="org_sub_id' + '_' + rowNum + '" value="'+org_sub_id+'"/>'+'<input type="hidden"  name="month_no' + '_' + rowNum + '" value="'+month_no+'"/>'+'<input type="text"  class="input_width" name="field_staff' + '_' + rowNum + '" value="'+field_staff+'"  onblur="sumNum1('+rowNum+');"   />';
		tr.insertCell().innerHTML = '<input type="text" class="input_width" name="two_employees' + '_' + rowNum + '" value="'+two_employees+'"  onblur="sumNum1('+rowNum+');"   />';				
		tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="group_contractors' + '_' + rowNum + '" value="'+group_contractors+'"  onblur="sumNum1('+rowNum+');"  />';		
		tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="external_contractor' + '_' + rowNum + '" value="'+external_contractor+'"   onblur="sumNum1('+rowNum+');"   />';		
		tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="o_aggreagte' + '_' + rowNum + '" value="'+o_aggreagte+'"   readonly="readonly" />';		
		tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="field_workhours' + '_' + rowNum + '" value="'+field_workhours+'"    onblur="sumNum2('+rowNum+');"  />';		
		tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="secondline_workhours' + '_' + rowNum + '" value="'+secondline_workhours+'"  onblur="sumNum2('+rowNum+');"  />';		
		tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="group_workhours' + '_' + rowNum + '"     value="'+group_workhours+'"  onblur="sumNum2('+rowNum+');"  />'; 
		tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="external_workhours' + '_' + rowNum + '"   value="'+external_workhours+'" onblur="sumNum2('+rowNum+');"  />';		
		tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="t_aggreagte' + '_' + rowNum + '"  value="'+t_aggreagte+'"  readonly="readonly" />';		
		tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="o_unit' + '_' + rowNum + '"   value="'+o_unit+'"  onblur="sumNum3('+rowNum+');"  />';		
		tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="personal' + '_' + rowNum + '"  value="'+personal+'"  onblur="sumNum3('+rowNum+');" />';		
		tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="o_amount' + '_' + rowNum + '"  value="'+o_amount+'" readonly="readonly" />';		
		tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="t_unit' + '_' + rowNum + '"  value="'+t_unit+'"   onblur="sumNum4('+rowNum+');" />';		
		tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="daigang' + '_' + rowNum + '"  value="'+daigang+'" onblur="sumNum4('+rowNum+');" />';		
		tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="leave' + '_' + rowNum + '"   value="'+leave+'" onblur="sumNum4('+rowNum+');" />';		
		tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="dismissal' + '_' + rowNum + '"   value="'+dismissal+'" onblur="sumNum4('+rowNum+');" />';	
		tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="economic_punishment' + '_' + rowNum + '"   value="'+economic_punishment+'" onblur="sumNum4('+rowNum+');" />';		
		tr.insertCell().innerHTML = '<input type="text"  class="input_width" name="t_amount' + '_' + rowNum + '"   value="'+t_amount+'"  readonly="readonly" />';	
		
		document.getElementById("lineNum").value = parseInt(rowNum) + 1;	
		var td = tr.insertCell(); 
		td.style.display = "";
		
	//	td.innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/>'+'<img src="'+'<%=contextPath%>'+'/images//delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + tr.id + '\')"/>';
	 
		
	}
	
	function toAdd(){ 	
		var rowNum = document.getElementById("lineNum").value;			
		var rowParams = new Array();					
			var recore_idS='<%=record_id%>';
			var spareSub  ='<%=spareSub%>';		 
			var   other_work= document.getElementsByName("other_work")[0].value;
			var   third_damage= document.getElementsByName("third_damage")[0].value;
		  	
			var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq'; 
		    var submitStr = 'JCDP_TABLE_NAME=BGP_HSE_MONTH_RECORD&JCDP_TABLE_ID='+recore_idS+'&spare1=1&spare2=<%=userName%>&other_work='+other_work+'&third_damage='+third_damage;
		    var retObject = syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		
 					
			for(var i=0;i<rowNum;i++){
				var rowParam = {};			 
				var  mrmanagement_no =document.getElementsByName("mrmanagement_no_"+i)[0].value; 
				var  recore_id =document.getElementsByName("recore_id_"+i)[0].value; 
				var  org_name  =document.getElementsByName("org_name_"+i)[0].value; 
				var  org_sub_id =document.getElementsByName("org_sub_id_"+i)[0].value; 
				var  month_no =document.getElementsByName("month_no_"+i)[0].value; 
				var  field_staff =document.getElementsByName("field_staff_"+i)[0].value; 
				var  two_employees =document.getElementsByName("two_employees_"+i)[0].value; 
				var  group_contractors =document.getElementsByName("group_contractors_"+i)[0].value; 
				var  external_contractor =document.getElementsByName("external_contractor_"+i)[0].value; 
				var  o_aggreagte =document.getElementsByName("o_aggreagte_"+i)[0].value; 
				var  field_workhours =document.getElementsByName("field_workhours_"+i)[0].value; 
				
				var  secondline_workhours =document.getElementsByName("secondline_workhours_"+i)[0].value; 
				var  group_workhours =document.getElementsByName("group_workhours_"+i)[0].value; 
				var  external_workhours =document.getElementsByName("external_workhours_"+i)[0].value; 
				var  t_aggreagte =document.getElementsByName("t_aggreagte_"+i)[0].value; 
				var  o_unit =document.getElementsByName("o_unit_"+i)[0].value; 
				var  personal =document.getElementsByName("personal_"+i)[0].value; 
				var  o_amount =document.getElementsByName("o_amount_"+i)[0].value; 
				var  t_unit =document.getElementsByName("t_unit_"+i)[0].value; 
				var  daigang =document.getElementsByName("daigang_"+i)[0].value; 
				var  leave =document.getElementsByName("leave_"+i)[0].value; 
				var  dismissal =document.getElementsByName("dismissal_"+i)[0].value; 
				var  economic_punishment =document.getElementsByName("economic_punishment_"+i)[0].value; 
				var  t_amount =document.getElementsByName("t_amount_"+i)[0].value; 
				
				var creator = document.getElementsByName("creator_"+i)[0].value; 
				var create_date = document.getElementsByName("create_date_"+i)[0].value; 
				var updator = document.getElementsByName("updator_"+i)[0].value; 
				var modifi_date = document.getElementsByName("modifi_date_"+i)[0].value; 
				var bsflag = document.getElementsByName("bsflag_"+i)[0].value; 
			 	
	 				 rowParam['mrmanagement_no'] = encodeURI(encodeURI(mrmanagement_no));
					 rowParam['recore_id'] = encodeURI(encodeURI(recore_id));
					 rowParam['org_sub_id'] = org_sub_id;
					 rowParam['month_no'] =month_no; 				
				     rowParam['field_staff'] = field_staff;
				     rowParam['two_employees'] = two_employees;			    
				     rowParam['group_contractors'] =group_contractors;
					 rowParam['external_contractor'] =external_contractor;
					 rowParam['o_aggreagte'] =o_aggreagte;
					 rowParam['field_workhours'] =field_workhours;
					 
				    rowParam['secondline_workhours'] = secondline_workhours;
				    rowParam['group_workhours'] = group_workhours;
				    rowParam['external_workhours'] = external_workhours;
				    rowParam['t_aggreagte'] = t_aggreagte;
				    rowParam['o_unit'] = o_unit;
				    rowParam['personal'] = personal;
				    rowParam['o_amount'] = o_amount;
				    rowParam['t_unit'] = t_unit;
				    rowParam['daigang'] = daigang;
				    rowParam['leave'] = leave;
	 
				    rowParam['dismissal'] = dismissal;
					rowParam['economic_punishment'] = economic_punishment;
					rowParam['t_amount'] = t_amount;
			 
					rowParam['spare1'] = recore_idS;
					rowParam['spare2'] = spareSub;	
					rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['modifi_date'] = '<%=curDate%>';	
					rowParam['bsflag'] = bsflag;						
				 
					rowParams[rowParams.length] = rowParam; 
	 
			}
				var rows=JSON.stringify(rowParams);			 
				saveFunc("BGP_MONTH_RECORD_MANAGEMENT",rows);	
	 
	}
	 
	if(action=="edit"){		
		var querySql = "";
		var queryRet = null;
		var  datas =null;				
		querySql = " select  other_work, third_damage from    BGP_HSE_MONTH_RECORD  where  bsflag='0'   and recore_id='"+recore_id+"' and  month_no='"+month_no+"' ";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas; 
			if(datas != null && datas != ''  ){	
				document.getElementsByName("other_work")[0].value=datas[0].other_work;
				document.getElementsByName("third_damage")[0].value=datas[0].third_damage;
			}					
		
	    	}			
		
		    var querySql1="";
			var queryRet1=null;
			var datas1 =null;		 
			 document.getElementById("lineNum").value="0";	
				   querySql1 = " select tr.mrmanagement_no, i.org_abbreviation as org_name ,tr.recore_id,tr.org_sub_id,tr.month_no,tr.field_staff,tr.two_employees,tr.group_contractors,tr.external_contractor,tr.o_aggreagte,tr.field_workhours,tr.secondline_workhours,tr.group_workhours,tr.external_workhours,tr.t_aggreagte,tr.o_unit,tr.personal,tr.o_amount,tr.t_unit,tr.daigang,tr.leave,tr.dismissal,tr.economic_punishment,tr.t_amount,tr.other_work,tr.third_damage,tr.creator,tr.create_date,tr.updator,tr.modifi_date,tr.bsflag   from   BGP_MONTH_RECORD_MANAGEMENT  tr   join  BGP_HSE_MONTH_RECORD hd on tr.recore_id=hd.recore_id and hd.bsflag='0' and hd.subflag='3'   join comm_org_subjection s    on tr.org_sub_id = s.org_subjection_id   and s.bsflag = '0'  join comm_org_information i    on s.org_id = i.org_id   and i.bsflag = '0'     where  tr.bsflag='0'   and tr.month_no='"+month_no+"'    order by  tr.modifi_date";
				   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
					if(queryRet1.returnCode=='0'){
					  datas1 = queryRet1.datas;	
						if(datas1 != null && datas1 != ''){	
							for(var i = 0; i<datas1.length; i++){	 		                 
			                  toAddLine(datas1[i].mrmanagement_no,datas1[i].recore_id,datas1[i].org_name,datas1[i].org_sub_id,datas1[i].month_no,datas1[i].field_staff,datas1[i].two_employees,datas1[i].group_contractors,datas1[i].external_contractor,datas1[i].o_aggreagte,datas1[i].field_workhours,datas1[i].secondline_workhours,datas1[i].group_workhours,datas1[i].external_workhours,datas1[i].t_aggreagte,datas1[i].o_unit,datas1[i].personal,datas1[i].o_amount,datas1[i].t_unit,datas1[i].daigang,datas1[i].leave,datas1[i].dismissal,datas1[i].economic_punishment,datas1[i].t_amount,datas1[i].creator,datas1[i].create_date,datas1[i].updator,datas1[i].modifi_date,datas1[i].bsflags);
							}
							
						}
				    }	
		
	}
 	function toBack(){
 		window.parent.location='<%=contextPath%>/hse/hseOptionPage/hseMonthlyReport/companyMonthlyReport.jsp';
	}
	
	
</script>

</html>

