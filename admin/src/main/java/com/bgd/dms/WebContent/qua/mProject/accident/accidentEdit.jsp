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
	String accident_id = request.getParameter("accident_id");
	if(accident_id==null){
		accident_id = "";
	}
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
     		<input type="hidden" name="accident_id" id="accident_id" value="<%=accident_id %>" />
    	<tr>
	    	<td class="inquire_item4"><font color="red">*</font>填报单位:</td>
	    	<td class="inquire_form4"><input name="org_id" id="org_id" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4"><font color="red">*</font>填报日期:</td>
	    	<td class="inquire_form4"><input name="report_date" id="report_date" type="text" class="input_width" value="" readonly="readonly" />
	    		<img width="16" height="16" id="cal_button7" style="cursor: hand;" 
	    		onmouseover="calDateSelector(report_date,cal_button7);" src="<%=contextPath %>/images/calendar.gif" /></td>
	    </tr>
    	<tr>
	    	<td class="inquire_item4"><font color="red">*</font>单位领导姓名:</td>
	    	<td class="inquire_form4"><input name="leader_id" id="leader_id" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4"><font color="red">*</font>分管领导姓名:</td>
	    	<td class="inquire_form4"><input name="super_id" id="super_id" type="text" class="input_width" value="" /></td>
	    </tr>
	    <tr>	
	    	<td class="inquire_item4">办公电话:</td>
	    	<td class="inquire_form4"><input name="office_num" id="office_num" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4"><font color="red">*</font>质量管理部门:</td>
	    	<td class="inquire_form4"><input name="depart_id" id="depart_id" type="text" class="input_width" value="" /></td>
	    </tr>
	    <tr>	
	    	<td class="inquire_item4"><font color="red">*</font>负责人姓名:</td>
	    	<td class="inquire_form4"><input name="charge_id" id="charge_id" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4">办公电话、手机:</td>
	    	<td class="inquire_form4"><input name="office_tel" id="office_tel" type="text" class="input_width" value="" /></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4"><font color="red">*</font>一般质量事故次数:</td>
	    	<td class="inquire_form4"><input name="small_num" id="small_num" type="text" class="input_width" value="0" 
	    		onkeydown="javascript:return checkIfNum(event);"/></td>
	    	<td class="inquire_item4">累计直接经济损失(万元):</td>
	    	<td class="inquire_form4"><input name="small_loss" id="small_loss" type="text" class="input_width" value="0" 
				onblur="checkFormat();" onkeydown="javascript:return checkIfDouble(event);"/></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4"><font color="red">*</font>较大质量事故次数:</td>
	    	<td class="inquire_form4"><input name="large_num" id="large_num" type="text" class="input_width" value="0" 
	    		onkeydown="javascript:return checkIfNum(event);"/></td>
	    	<td class="inquire_item4">累计直接经济损失(万元):</td>
	    	<td class="inquire_form4"><input name="large_loss" id="large_loss" type="text" class="input_width" value="0" 
				onblur="checkFormat();" onkeydown="javascript:return checkIfDouble(event);"/></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4"><font color="red">*</font>重大质量事故次数:</td>
	    	<td class="inquire_form4"><input name="great_num" id="great_num" type="text" class="input_width" value="0" 
	    		onkeydown="javascript:return checkIfNum(event);"/></td>
	    	<td class="inquire_item4">累计直接经济损失(万元):</td>
	    	<td class="inquire_form4"><input name="great_loss" id="great_loss" type="text" class="input_width" value="0" 
	    		onblur="checkFormat();" onkeydown="javascript:return checkIfDouble(event);"/></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4"><font color="red">*</font>特大质量事故次数:</td>
	    	<td class="inquire_form4"><input name="super_num" id="super_num" type="text" class="input_width" value="0" 
	    		onkeydown="javascript:return checkIfNum(event);"/></td>
	    	<td class="inquire_item4">累计直接经济损失(万元):</td>
	    	<td class="inquire_form4"><input name="super_loss" id="super_loss" type="text" class="input_width" value="0" 
	    		onblur="checkFormat();" onkeydown="javascript:return checkIfDouble(event);"/></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4">国家不合格批次:</td>
	    	<td class="inquire_form4"><input name="nation" id="nation" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4">省(市、自治区)不合格批次:</td>
	    	<td class="inquire_form4"><input name="province" id="province" type="text" class="input_width" value="" /></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4">集团公司不合格批次:</td>
	    	<td class="inquire_form4"><input name="corporation" id="corporation" type="text" class="input_width" value="" /></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4">备注:</td>
	    	<td class="inquire_form4" colspan="3"><textarea name="spare1" id="spare1" class="textarea" ></textarea></td>
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
	function checkFormat(){
		var element = event.srcElement;
		var small_loss = element.value;
		var index = small_loss.indexOf('.');
		if(index == small_loss.length-1){
			element.value = small_loss.substring(0,small_loss.length-1);
		}
	}
	function checkIfDouble(){
		var element = event.srcElement;
		if(element.value =='0' && (event.keyCode>=48 && event.keyCode<=57)){
			element.value = '';
			return true;
		}
		if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8 || event.keyCode == 190 || event.keyCode ==37 || event.keyCode ==39 || event.keyCode ==9){
			var small_loss = element.value;
			var index = small_loss.indexOf('.');
			if(event.keyCode == 190 && (small_loss == null || small_loss =='')){
				return false;
			}else if(event.keyCode == 190 && (small_loss != null && small_loss !='') && index !=(-1)){
				return false;
			}
			return true;
		}
		else{
			alert("只能输入数字");
			return false;
		}
	}
	function selectOrgHR(select_type , select_id , select_name){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    debugger;
	    window.showModalDialog('<%=contextPath%>/common/selectOrgHR.jsp?select='+select_type,teamInfo);
	    if(teamInfo.fkValue!=""){
	        document.getElementById(select_id).value = teamInfo.fkValue;
	        document.getElementById(select_name).value = teamInfo.value;
	    }
	}
	function refreshCodeData(){
		var id  = '<%=accident_id%>';
		debugger;
		var retObj = jcdpCallService("QualityItemsSrv","getAccidentDetail", "accident_id=" + id);
		if(retObj.returnCode =='0'){
			if(id!=''){
				document.getElementById("accident_id").value = id;
				document.getElementById("org_id").value = retObj.accidentDetail.orgId;
				document.getElementById("report_date").value = retObj.accidentDetail.reportDate;
				document.getElementById("leader_id").value = retObj.accidentDetail.leaderId;
				document.getElementById("super_id").value = retObj.accidentDetail.superId;
				document.getElementById("office_num").value = retObj.accidentDetail.officeNum;
				document.getElementById("depart_id").value = retObj.accidentDetail.departId;
				document.getElementById("charge_id").value = retObj.accidentDetail.chargeId;
				document.getElementById("office_tel").value = retObj.accidentDetail.officeTel;
				document.getElementById("small_num").value = retObj.accidentDetail.smallNum;
				document.getElementById("small_loss").value = retObj.accidentDetail.smallLoss;
				document.getElementById("large_num").value = retObj.accidentDetail.largeNum;
				document.getElementById("large_loss").value = retObj.accidentDetail.largeLoss;
				document.getElementById("great_num").value = retObj.accidentDetail.greatNum;
				document.getElementById("great_loss").value = retObj.accidentDetail.greatLoss;
				document.getElementById("super_num").value = retObj.accidentDetail.superNum;
				document.getElementById("super_loss").value = retObj.accidentDetail.superLoss;
				document.getElementById("nation").value = retObj.accidentDetail.nation;
				document.getElementById("province").value = retObj.accidentDetail.province;
				document.getElementById("corporation").value = retObj.accidentDetail.corporation;
				document.getElementById("spare1").value = retObj.accidentDetail.spare1;
			}
		}
		
		
		
	}
	refreshCodeData();
	function newSubmit() {
		if(checkValue() == false){
			return ;
		}
		var report_date = document.getElementById("report_date").value;
		var org_id = document.getElementById("org_id").value;
		var accident_id = document.getElementById("accident_id").value;
		var retObj = jcdpCallService("QualityItemsSrv","checkAccidentExist", "report_date=" +report_date + "&org_id="+org_id+"&accident_id="+accident_id);
		if(retObj.returnCode == '0'){
			var map = retObj.existMap;
			if(map!=null){
				alert("填报日期已经存在，请重新填写");
				return ;
			}
		}
		var form = document.getElementById("fileForm");
		form.action = '<%=contextPath%>/qua/sProject/accident/saveAccident.srq';
		form.submit();
	}
	function checkValue(){
		var obj = document.getElementById("org_id") ;
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("填报单位不能为空!");
			return false;
		}
		obj = document.getElementById("report_date") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("填报日期不能为空!");
			return false;
		}
		obj = document.getElementById("leader_id") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("单位领导不能为空!");
			return false;
		}
		obj = document.getElementById("super_id") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("分管领导不能为空!");
			return false;
		}
		obj = document.getElementById("depart_id") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("质量管理部门不能为空!");
			return false;
		}
		obj = document.getElementById("charge_id") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("负责人不能为空!");
			return false;
		}
		obj = document.getElementById("small_num") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("一般质量事故次数不能为空!");
			return false;
		}else if(obj !=null && value=='0'){
			document.getElementById("small_loss").value = '0';
		}
		obj = document.getElementById("large_num") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("较大质量事故不能为空!");
			return false;
		}else if(obj !=null && value=='0'){
			document.getElementById("large_loss").value = '0';
		}
		obj = document.getElementById("great_num") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("重大质量事故次数不能为空!");
			return false;
		}else if(obj !=null && value=='0'){
			document.getElementById("great_loss").value = '0';
		}
		obj = document.getElementById("super_num") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("特大质量事故次数不能为空!");
			return false;
		}else if(obj !=null && value=='0'){
			document.getElementById("super_loss").value = '0';
		}
	}
</script>
</body>
</html>