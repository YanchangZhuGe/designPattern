<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_info_no = user.getProjectInfoNo();
	String target_rent_id = request.getParameter("target_rent_id");
	if(target_rent_id==null){
		target_rent_id = "";
	}
	String org_id = user.getOrgId();
	String org_subjection_id = user.getOrgSubjectionId();
	String user_name = user.getUserName();
	Date now = new Date();
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
  <title></title> 
 </head> 
 <body> 
 <form name="fileForm" id="fileForm" method="post" action="">  
 <div id="new_table_box" align="center">
  <div id="new_table_box_content"> 
  	<div id="new_table_box_bg">
  	<input type="hidden" name="target_rent_id" id="target_rent_id" value="<%=target_rent_id %>" />
    <table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
     	<tr>
	    	<td class="inquire_item4"><font color="red">*</font>设备名称:</td>
	    	<td class="inquire_form4"><input name="dev_name" id="dev_name" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4">规格型号:</td>
	    	<td class="inquire_form4"><input name="dev_model" id="dev_model" type="text" class="input_width" value="" /></td>
	    </tr>
    	<tr>
	    	<td class="inquire_item4">班组:</td>
	    	<td class="inquire_form4"><select id="dev_team" name="dev_team" class="select_width"></select></td>
	    	<td class="inquire_item4"><font color="red">*</font>数量:</td>
	    	<td class="inquire_form4"><input name="device_count" id="device_count" type="text" class="input_width" value="" onkeydown="return checkIfNum(this);"/></td>
	    </tr>
    	<tr>
	    	<td class="inquire_item4"><font color="red">*</font>到达工区验收合格时间:</td>
	    	<td class="inquire_form4"><input name="plan_start_date" id="plan_start_date" type="text" class="input_width" value="" readonly="readonly" />
	    		<img width="16" height="16" id="cal_button7" style="cursor: hand;" onmouseover="calDateSelector(plan_start_date,cal_button7);" src="<%=contextPath %>/images/calendar.gif" /></td>
			<td class="inquire_item4"><font color="red">*</font>设备撤回存放地时间:</td>
	    	<td class="inquire_form4"><input name="plan_end_date" id="plan_end_date" type="text" class="input_width" value="" readonly="readonly" />
	    		<img width="16" height="16" id="cal_button8" style="cursor: hand;" onmouseover="calDateSelector(plan_end_date,cal_button8);" src="<%=contextPath %>/images/calendar.gif" /></td>
	    </tr>
	    <tr>	
	    	<td class="inquire_item4"><font color="red">*</font>租赁单价(元):</td>
	    	<td class="inquire_form4"><input name="taxi_unit" id="taxi_unit" type="text" class="input_width" value="" onkeydown="return checkIfDouble()"/></td>
	    </tr>
    </table> 
  </div> 
  <div id="oper_div">
	<span class="bc_btn"><a href="#" onclick="newSubmit()"></a></span>
 	<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
  </div>
  </div> 
  </div>
</form> 
<script type="text/javascript">
	cruConfig.contextPath = '<%=contextPath%>';
	var querySql = "select coding_code_id value,t.coding_name label from comm_coding_sort_detail t where t.coding_sort_id='0110000001' and t.bsflag='0' and length(t.coding_code)=2 and t.spare1='0' order by t.coding_show_id";
	var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql+'&pageSize=1000');
	if(retObj!=null && retObj.returnCode=='0' && retObj.datas!=null && retObj.datas.length>0){
		for(var i =0;i<retObj.datas.length;i++){
			var map = retObj.datas[i];
			with(map){
				document.getElementById("dev_team").options.add(new Option(label,value));
			}
		}
	}
	function checkIfNum(){
		var element = event.srcElement;
		if(element.value =='0' && (event.keyCode>=48 && event.keyCode<=57)){
			element.value = '';
			return true;
		}
		var key = String.fromCharCode(event.keyCode);
		if(event.keyCode ==8 || event.keyCode ==37 || event.keyCode ==39 || event.keyCode ==9 || !isNaN(key) ){
			return true;
		}else{
			return false;
		}
	}
	function checkIfDouble(){
		var element = event.srcElement;
		var value = element.value;
		if(value.indexOf(".")!=-1){
			var key = String.fromCharCode(event.keyCode);
			if(event.keyCode ==8 || event.keyCode ==37 || event.keyCode ==39 || event.keyCode ==9 || !isNaN(key) ){
				return true;
			}else{
				return false;
			}
		}else{
			if(element.value =='0' && (event.keyCode>=48 && event.keyCode<=57)){
				element.value = '';
				return true;
			}else if(element.value =='' && event.keyCode == 190){
				element.value = '0';
				return true;
			}
			var key = String.fromCharCode(event.keyCode);
			if(event.keyCode ==8 || event.keyCode == 190 || event.keyCode ==37 || event.keyCode ==39 || event.keyCode ==9 || !isNaN(key) ){
				return true;
			}else{
				return false;
			}
		}
	}
	var column_names= {
		target_rent_id:"",
		dev_name:"",
		dev_model:"",
		device_count:"",
		plan_start_date:"",
		plan_end_date:"",
		taxi_unit:"",
		dev_team:""
	}
	function refreshData(){
		var id  = '<%=target_rent_id%>';
		var querySql = "select * from bgp_op_target_device_rent where bsflag='0' and if_change = '0' and target_rent_id = '"+id+"'";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		if(retObj!=null && retObj.returnCode=='0' && retObj.datas!=null && retObj.datas[0]!=null){
			var map = retObj.datas[0];
			for(var i in column_names){
				document.getElementById(i).value = map[i];
			}
		}
	}
	refreshData();
	function newSubmit() {
		if(checkValue() == false){
			return ;
		}
		var target_rent_id = document.getElementById("target_rent_id").value ;
		var dev_name = document.getElementById("dev_name").value;
		var dev_model = document.getElementById("dev_model").value ;
		var device_count = document.getElementById("device_count").value ;
		var plan_start_date = document.getElementById("plan_start_date").value;
		var plan_end_date = document.getElementById("plan_end_date").value ;
		var taxi_unit = document.getElementById("taxi_unit").value ;
		var dev_team = document.getElementById("dev_team").value ;
		
		var sql = "";
		if(target_rent_id!=null && target_rent_id!=''){
			var dev_acc_id = "";
			var querySql = "select t.dev_acc_id key_id from bgp_op_target_device_rent t where t.bsflag ='0' and t.target_rent_id ='"+target_rent_id+"'";
			var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(retObj!=null && retObj.returnCode =='0'){
				dev_acc_id = retObj.datas[0].key_id;
			}
			sql = "update bgp_op_target_device_rent t set t.dev_name='"+dev_name+"',t.dev_model='"+dev_model+"',t.device_count='"+device_count+"',"+
			" t.plan_start_date=to_date('"+plan_start_date+"','yyyy-MM-dd'),t.plan_end_date=to_date('"+plan_end_date+"','yyyy-MM-dd'),"+
			" t.taxi_unit='"+taxi_unit+"',t.dev_team='"+dev_team+"' where t.target_rent_id='"+target_rent_id+"';";
			
			sql += "update bgp_op_tartet_device_oil t set t.dev_name='"+dev_name+"',t.dev_model='"+dev_model+"',t.device_count='"+device_count+"',"+
			" t.plan_start_date=to_date('"+plan_start_date+"','yyyy-MM-dd'),t.plan_end_date=to_date('"+plan_end_date+"','yyyy-MM-dd'),"+
			" t.dev_team='"+dev_team+"' where t.dev_acc_id='"+dev_acc_id+"';";
			
			sql += "update bgp_op_tartet_device_depre t set t.dev_name='"+dev_name+"',t.dev_model='"+dev_model+"',t.device_count='"+device_count+"',"+
			" t.plan_start_date=to_date('"+plan_start_date+"','yyyy-MM-dd'),t.plan_end_date=to_date('"+plan_end_date+"','yyyy-MM-dd'),"+
			" t.dev_team='"+dev_team+"' where t.dev_acc_id='"+dev_acc_id+"';";
			
			sql += "update bgp_op_tartet_device_material t set t.dev_name='"+dev_name+"',t.dev_model='"+dev_model+"',t.device_count='"+device_count+"',"+
			" t.plan_start_date=to_date('"+plan_start_date+"','yyyy-MM-dd'),t.plan_end_date=to_date('"+plan_end_date+"','yyyy-MM-dd'),"+
			" t.dev_team='"+dev_team+"' where t.dev_acc_id='"+dev_acc_id+"';";
		}else{
			var dev_acc_id = "";
			var querySql = "select lower(sys_guid()) key_id from dual ";
			var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(retObj!=null && retObj.returnCode =='0'){
				dev_acc_id = retObj.datas[0].key_id;
			}
			sql = "insert into bgp_op_target_device_rent(target_rent_id,project_info_no,dev_name,dev_model,dev_team,device_count,taxi_unit,"+
			"plan_start_date,plan_end_date,org_id,org_subjection_id,creator,create_date,updator,update_date,bsflag,if_change,dev_acc_id)"+
			"values((lower(sys_guid())),'<%=project_info_no%>','"+dev_name+"','"+dev_model+"','"+dev_team+"','"+device_count+"','"+taxi_unit+"',"+
			"to_date('"+plan_start_date+"','yyyy-MM-dd'),to_date('"+plan_end_date+"','yyyy-MM-dd'),'<%=org_id%>',"+
			"'<%=org_subjection_id%>','<%=user_name%>',sysdate,'<%=user_name%>',sysdate,'0','0','"+dev_acc_id+"');";
			
			sql += "insert into bgp_op_tartet_device_oil(cost_device_id,project_info_no,dev_name,dev_model,dev_team,device_count,"+
			"plan_start_date,plan_end_date,org_id,org_subjection_id,creator,create_date,updator,update_date,bsflag,if_change,dev_acc_id)"+
			"values((lower(sys_guid())),'<%=project_info_no%>','"+dev_name+"','"+dev_model+"','"+dev_team+"','"+device_count+"',"+
			"to_date('"+plan_start_date+"','yyyy-MM-dd'),to_date('"+plan_end_date+"','yyyy-MM-dd'),'<%=org_id%>',"+
			"'<%=org_subjection_id%>','<%=user_name%>',sysdate,'<%=user_name%>',sysdate,'0','0','"+dev_acc_id+"');";
			
			sql += "insert into bgp_op_tartet_device_depre(target_depre_id,project_info_no,dev_name,dev_model,dev_team,device_count,"+
			"plan_start_date,plan_end_date,org_id,org_subjection_id,creator,create_date,updator,update_date,bsflag,if_change,record_type,dev_acc_id)"+
			"values((lower(sys_guid())),'<%=project_info_no%>','"+dev_name+"','"+dev_model+"','"+dev_team+"','"+device_count+"',"+
			"to_date('"+plan_start_date+"','yyyy-MM-dd'),to_date('"+plan_end_date+"','yyyy-MM-dd'),'<%=org_id%>',"+
			"'<%=org_subjection_id%>','<%=user_name%>',sysdate,'<%=user_name%>',sysdate,'0','0','0','"+dev_acc_id+"');";
			
			sql += "insert into bgp_op_tartet_device_material(target_material_id,project_info_no,dev_name,dev_model,dev_team,device_count,"+
			"plan_start_date,plan_end_date,org_id,org_subjection_id,creator,create_date,updator,update_date,bsflag,if_change,dev_acc_id)"+
			"values((lower(sys_guid())),'<%=project_info_no%>','"+dev_name+"','"+dev_model+"','"+dev_team+"','"+device_count+"',"+
			"to_date('"+plan_start_date+"','yyyy-MM-dd'),to_date('"+plan_end_date+"','yyyy-MM-dd'),'<%=org_id%>',"+
			"'<%=org_subjection_id%>','<%=user_name%>',sysdate,'<%=user_name%>',sysdate,'0','0','"+dev_acc_id+"');";
		}
		var retObj = jcdpCallService("QualityItemsSrv","saveQuality", "sql="+sql);
		if(retObj!=null && retObj.returnCode == '0'){
			alert("保存成功!");
			top.frames['list'].refreshData();
			newClose();
		}else{
			alert("保存失败!");
		}
	}
	var not_null_column ={
		dev_name:"设备名称",
		device_count:"数量",
		plan_start_date:"到达工区验收合格时间",
		plan_end_date:"设备撤回存放地时间",
		taxi_unit:"租赁单价(元)"
	}
	function checkValue(){
		for(var i in not_null_column){
			var value = document.getElementById(i).value ;
			if(value==''){
				alert(not_null_column[i]+"不能空!");
				return false;
			}
		}
	}
</script>
</body>
</html>