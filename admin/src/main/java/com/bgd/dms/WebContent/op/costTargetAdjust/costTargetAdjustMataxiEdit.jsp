<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_info_no = user.getProjectInfoNo();
	String target_mataxi_id = request.getParameter("target_mataxi_id");
	if(target_mataxi_id==null){
		target_mataxi_id = "";
	}
	String org_id = user.getOrgId();
	String org_subjection_id = user.getOrgSubjectionId();
	String user_id = user.getUserId();
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	String now = df.format(new Date());
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
 <body><!-- class="bgColor_f3f3f3"  onload="page_init()"> --> 
 <form name="fileForm" id="fileForm" method="post" action=""> <!--target="hidden_frame" enctype="multipart/form-data" --> 
 <div id="new_table_box" align="center">
  <div id="new_table_box_content"> 
  	<div id="new_table_box_bg">
    <table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
     	<tr>
     		<input type="hidden" name="target_mataxi_id" id="target_mataxi_id" value="<%=target_mataxi_id %>" />
     		<input type="hidden" name="if_change" id="if_change" value="" />
	    	<td class="inquire_item4">计费时间:</td>
	    	<td class="inquire_form4"><select id="dev_name" name="dev_name" onchange="changeRatio();" class="select_width">
				<option value="0">动迁时间</option>
				<option value="1">租赁时间</option>
			    <option value="2">遣散时间</option>
			    <option value="3">待工时间</option>
			    <option value="4">交回验收时间</option>
			    <option value="5">超计划占用时间</option>
	    	</select></td>
	    	<td class="inquire_item4">型号:</td>
	    	<td class="inquire_form4"><select id="dev_model" name="dev_model" onchange="changeUnit();" class="select_width">
				<option value="428XL">428XL</option>
				<option value="408UL">408UL</option>
				<option value="SYS-IV">SYS-IV</option>
				<option value="SYS-IV(数字)">SYS-IV(数字)</option>
				<option value="ARIESI">ARIESI&II</option>
				<option value="SCORPION">SCORPION</option>
				<option value="FIREFLY">FIREFLY</option>
				<option value="UNITE">UNITE</option>
				<option value="GSR">GSR</option>
				<option value="G3i">G3i</option>
				<option value="数字400系列">数字400系列</option>
				<option value="ES109">ES109</option>
	    	</select></td>
	    </tr>
    	<tr>	
	    	<td class="inquire_item4"><font color="red">*</font>数量:</td>
	    	<td class="inquire_form4"><input name="dev_count" id="dev_count" type="text" class="input_width" value="" onkeydown="javascript:return checkIfNum(event);"/></td>
	    	<td class="inquire_item4">类型:</td>
	    	<td class="inquire_form4"><select id="mataxi_type" name="mataxi_type" class="select_width">
				 <option value="1">仪器</option>
			     <option value="2">运载设备</option>
			     <option value="3">专用工具</option>
	    	</select></td>
	    </tr>
    	<tr>
	    	<td class="inquire_item4"><font color="red">*</font>到达工区验收合格时间:</td>
	    	<td class="inquire_form4"><input name="plan_start_date" id="plan_start_date" type="text" class="input_width" value="" readonly="readonly" />
	    		<img width="16" height="16" id="cal_button7" style="cursor: hand;" onmouseover="calDateSelector(plan_start_date,cal_button7);" 
	    		src="<%=contextPath %>/images/calendar.gif" /></td>
			<td class="inquire_item4"><font color="red">*</font>设备撤回存放地时间:</td>
	    	<td class="inquire_form4"><input name="plan_end_date" id="plan_end_date" type="text" class="input_width" value="" readonly="readonly" />
	    		<img width="16" height="16" id="cal_button8" style="cursor: hand;" onmouseover="calDateSelector(plan_end_date,cal_button8);" 
	    		src="<%=contextPath %>/images/calendar.gif" /></td>
	    </tr>
	    <tr>	
	    	<td class="inquire_item4">租赁单价(元):</td>
	    	<td class="inquire_form4"><input name="taxi_unit" id="taxi_unit" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4"><font color="red">*</font>计费比例:</td>
	    	<td class="inquire_form4"><input name="taxi_ratio" id="taxi_ratio" type="text" class="input_width" value="" style="display: none;"/>
	    		<input name="spare1" id="spare1" type="text" class="input_width" value="" /></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4"><font color="red">*</font>变更日期:</td>
	    	<td class="inquire_form4"><input name="change_date" id="change_date" type="text" class="input_width" value="<%=now %>" disabled="disabled"  /></td>
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
	function checkIfNum(){
		var element = event.srcElement;
		if(element.value != null && element.value =='0' && (event.keyCode>=48 && event.keyCode<=57)){
			element.value = '';
		}
		if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8 || event.keyCode ==37 || event.keyCode ==39 || event.keyCode ==9){
			return true;
		}
		else{
			alert("只能输入数字");
			return false;
		}
	}
	function refreshData(){
		var id  = '<%=target_mataxi_id%>';
		var querySql = "select * from bgp_op_target_device_mataxi where bsflag='0' and mataxi_type !='4' and (if_change!='2' and if_delete_change is null ) and target_mataxi_id = '"+id+"'";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		if(retObj!=null && retObj.returnCode=='0' && retObj.datas!=null && retObj.datas[0]!=null){
			var map = retObj.datas[0];
			with(map){
				document.getElementById("target_mataxi_id").value = target_mataxi_id;
				document.getElementById("if_change").value = if_change;
				document.getElementById("dev_name").value = dev_name;
				document.getElementById("dev_model").value = dev_model;
				document.getElementById("dev_count").value = dev_count;
				document.getElementById("mataxi_type").value = mataxi_type;
				document.getElementById("plan_start_date").value = plan_start_date;
				document.getElementById("plan_end_date").value = plan_end_date;
				document.getElementById("taxi_unit").value = taxi_unit;
				document.getElementById("taxi_ratio").value = taxi_ratio;
				document.getElementById("spare1").value = spare1;
			}
		}
		var dev_name = document.getElementsByName("dev_name")[0].value;
		if(dev_name!='3')
			changeRatio();
		var dev_models = "019_428XL,016_408UL,010_SYS-IV,020_SYS-IV(数字),012_ARIESI&II,013_G3i,4.5_ES109";
		var dev_model = document.getElementsByName("dev_model")[0].value;
		if(dev_models.indexOf(dev_model)!=-1)
			changeUnit();
	}
	refreshData();
	function newSubmit() {
		if(checkValue() == false){
			return ;
		}
		var target_mataxi_id = document.getElementById("target_mataxi_id").value ;
		var dev_name = document.getElementById("dev_name").value;
		var dev_model = document.getElementById("dev_model").value ;
		var dev_count = document.getElementById("dev_count").value ;
		var mataxi_type = document.getElementById("mataxi_type").value ;
		var plan_start_date = document.getElementById("plan_start_date").value;
		var plan_end_date = document.getElementById("plan_end_date").value ;
		var taxi_unit = document.getElementById("taxi_unit").value ;
		var spare1 = document.getElementById("spare1").value ;
		var change_date = document.getElementById("change_date").value ;
		if(spare1.indexOf("%")!=-1){
			var ratio = spare1.replace("%","");
			ratio = ratio/100.0;
			document.getElementsByName("taxi_ratio")[0].value = ratio;
		}else{
			document.getElementsByName("taxi_ratio")[0].value = spare1;
		}
		var taxi_ratio = document.getElementById("taxi_ratio").value ;
		
		var sql = "";
		if(target_mataxi_id!=null && target_mataxi_id!=''){
			var if_change = document.getElementById("if_change").value ;
			if(if_change==null || if_change=='0'){
				sql = "update bgp_op_target_device_mataxi t set t.if_delete_change='1' where t.target_mataxi_id='"+target_mataxi_id+"';";
				
				sql += "insert into bgp_op_target_device_mataxi(target_mataxi_id,project_info_no,dev_name,dev_model,plan_start_date,plan_end_date,"+
				"dev_count,mataxi_type,taxi_unit,spare1,taxi_ratio,org_id,org_subjection_id,creator,create_date,updator,"+
				"update_date,bsflag,if_change,change_date) values((lower(sys_guid())),'<%=project_info_no%>','"+dev_name+"',"+
				"'"+dev_model+"',to_date('"+plan_start_date+"','yyyy-MM-dd'),to_date('"+plan_end_date+"','yyyy-MM-dd'),'"+dev_count+"',"+
				"'"+mataxi_type+"','"+taxi_unit+"','"+spare1+"','"+taxi_ratio+"','<%=org_id%>','<%=org_subjection_id%>',"+
				"'<%=user_id%>',sysdate,'<%=user_id%>',sysdate,'0','1',to_date('"+change_date+"','yyyy-MM-dd'));";
			}else{
				sql = "update bgp_op_target_device_mataxi t set t.dev_name='"+dev_name+"',t.dev_model='"+dev_model+"',t.dev_count='"+dev_count+"',"+
				" t.plan_start_date=to_date('"+plan_start_date+"','yyyy-MM-dd'),t.plan_end_date=to_date('"+plan_end_date+"','yyyy-MM-dd'),"+
				" t.mataxi_type='"+mataxi_type+"',t.taxi_unit='"+taxi_unit+"',t.spare1='"+spare1+"',t.taxi_ratio='"+taxi_ratio+"', "+
				" t.change_date =to_date('"+change_date+"','yyyy-MM-dd') where t.target_mataxi_id='"+target_mataxi_id+"';";
			}
			
		}else{
			sql = "insert into bgp_op_target_device_mataxi(target_mataxi_id,project_info_no,dev_name,dev_model,plan_start_date,plan_end_date,"+
			"dev_count,mataxi_type,taxi_unit,spare1,taxi_ratio,org_id,org_subjection_id,creator,create_date,updator,"+
			"update_date,bsflag,if_change,change_date) values((lower(sys_guid())),'<%=project_info_no%>','"+dev_name+"',"+
			"'"+dev_model+"',to_date('"+plan_start_date+"','yyyy-MM-dd'),to_date('"+plan_end_date+"','yyyy-MM-dd'),'"+dev_count+"',"+
			"'"+mataxi_type+"','"+taxi_unit+"','"+spare1+"','"+taxi_ratio+"','<%=org_id%>','<%=org_subjection_id%>',"+
			"'<%=user_id%>',sysdate,'<%=user_id%>',sysdate,'0','1',to_date('"+change_date+"','yyyy-MM-dd'));";
		}
		sql = encodeURI(encodeURI(sql)); 
		var retObj = jcdpCallService("QualityItemsSrv","saveQuality", "sql="+sql);
		if(retObj!=null && retObj.returnCode == '0'){
			alert("保存成功!");
			top.frames['list'].refreshData();
			newClose();
		}else{
			alert("保存失败!");
		}
	}
	function checkValue(){
		var obj = document.getElementById("dev_count") ;
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("数量不能为空!");
			return false;
		}
		obj = document.getElementById("plan_start_date") ;
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("到达工区验收合格时间不能为空!");
			return false;
		}
		obj = document.getElementById("plan_end_date") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("设备撤回存放地时间不能为空!");
			return false;
		}
		obj = document.getElementById("spare1") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("计费比例不能为空!");
			return false;
		}
	}
	function changeRatio(){
		var dev_name = document.getElementsByName("dev_name")[0].value;
		switch(parseInt(dev_name)){
			case 0 :
				document.getElementsByName("taxi_ratio")[0].value = '0.50';
				document.getElementsByName("spare1")[0].value = '50%';
				document.getElementsByName("spare1")[0].disabled = 'disabled';
			break;
			case 1 :
				document.getElementsByName("taxi_ratio")[0].value = '1';
				document.getElementsByName("spare1")[0].value = '100%';
				document.getElementsByName("spare1")[0].disabled = 'disabled';
			break;
			case 2 :
				document.getElementsByName("taxi_ratio")[0].value = '0.50';
				document.getElementsByName("spare1")[0].value = '50%';
				document.getElementsByName("spare1")[0].disabled = 'disabled';
			break;
			case 3 :
				document.getElementsByName("spare1")[0].value = '';
				document.getElementsByName("spare1")[0].removeAttribute("disabled");
			break;
			case 4 :
				document.getElementsByName("taxi_ratio")[0].value = '0.20';
				document.getElementsByName("spare1")[0].value = '20%';
				document.getElementsByName("spare1")[0].disabled = 'disabled';
			break;
			case 5 :
				document.getElementsByName("taxi_ratio")[0].value = '0.20';
				document.getElementsByName("spare1")[0].value = '20%';
				document.getElementsByName("spare1")[0].disabled = 'disabled';
			break;
		}
	}
	function changeUnit(){
		var units = "019_428XL,016_408UL,010_SYS-IV,020_SYS-IV(数字),012_ARIESI&II,013_G3i,4.5_ES109";
		var dev_model = document.getElementsByName("dev_model")[0].value; 
		var index = units.indexOf(dev_model);
		var unit = "";
		if(index!=-1){
			unit = units.substring(index-4,index-1);
			document.getElementsByName("taxi_unit")[0].value = parseFloat(unit);
			document.getElementsByName("taxi_unit")[0].disabled = 'disabled'; 
		}else{
			document.getElementsByName("taxi_unit")[0].value = "";
			document.getElementsByName("taxi_unit")[0].removeAttribute("disabled");
		}
	}
</script>
</body>
</html>