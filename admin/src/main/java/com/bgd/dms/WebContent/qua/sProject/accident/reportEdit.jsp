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
	if(accident_id ==null){
		accident_id = "";
	}
	String report_id = request.getParameter("report_id");
	if(report_id ==null){
		report_id = "";
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
     	<tr>
     		<input type="hidden" name="report_id" id="report_id" value="<%=report_id %>" />
     		<input type="hidden" name="accident_id" id="accident_id" value="<%=accident_id %>" />
	    	<td class="inquire_item4"><font color="red">*</font>单位名称:</td>
	    	<td class="inquire_form4"><input name="report_org" id="report_org" type="hidden" class="input_width" value="" />
	    		<input name="org_name" id="org_name" type="text" class="input_width" value="" disabled="disabled"/>
	    		<img onclick="selectOrgHR('orgId','report_org','org_name')" src="<%=contextPath %>/images/images/tree_12.png" width="16" height="16" style="cursor: hand;" /></td>
	    	<td class="inquire_item4"><font color="red">*</font>质量事故发生单位:</td>
	    	<td class="inquire_form4"><input name="accident_org" id="accident_org" type="hidden" class="input_width" value="" />
	    		<input name="accident_name" id="accident_name" type="text" class="input_width" value="" disabled="disabled"/>
	    		<img onclick="selectOrgHR('orgId','accident_org','accident_name')" src="<%=contextPath %>/images/images/tree_12.png" width="16" height="16" style="cursor: hand;" /></td>
	   	</tr>
    	<tr>
	    	<td class="inquire_item4"><font color="red">*</font>质量事故发生时间:</td>
	    	<td class="inquire_form4"><input name="accident_date" id="accident_date" type="text" class="input_width" value="" readonly="readonly" />
	    		<img width="16" height="16" id="cal_button7" style="cursor: hand;" onmouseover="calDateSelector(accident_date,cal_button7);" src="<%=contextPath %>/images/calendar.gif" /></td>
	    	<td class="inquire_item4"><font color="red">*</font>预计直接经济损失(万元):</td>
	    	<td class="inquire_form4"><input name="accident_loss" id="accident_loss" type="text" class="input_width" value="" 
				onblur="checkFormat();" onkeydown="javascript:return checkIfDouble(event);"/></td>
		</tr>
	    <tr>	    
			<td class="inquire_item4"><font color="red">*</font>报告人:</td>
	    	<td class="inquire_form4"><input name="reporter_id" id="reporter_id" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4">联系电话:</td>
	    	<td class="inquire_form4"><input name="reporter_tel" id="reporter_tel" type="text" class="input_width" value="" /></td>
	    </tr>
	     <tr>
	    	<td class="inquire_item4">质量事故概述:</td>
	    	<td class="inquire_form4" colspan="3" ><textarea id="describe" name="describe" rows="45" cols="3" class="textarea"></textarea></td>
	    </tr>
	     <tr>
	    	<td class="inquire_item4">目前处理情况:</td>
	    	<td class="inquire_form4" colspan="3" ><textarea id="situation" name="situation" rows="45" cols="3" class="textarea"></textarea></td>
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
	function checkFormat(){
		var element = event.srcElement;
		var accident_loss = element.value;
		var index = accident_loss.indexOf('.');
		if(index == accident_loss.length-1){
			element.value = accident_loss.substring(0,accident_loss.length-1);
		}
	}
	function checkIfDouble(){
		var element = event.srcElement;
		if(element.value =='0' && (event.keyCode>=48 && event.keyCode<=57)){
			element.value = '';
			return true;
		}
		if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8 || event.keyCode == 190 || event.keyCode ==37 || event.keyCode ==39 || event.keyCode ==9){
			var accident_loss = element.value;
			var index = accident_loss.indexOf('.');
			if(event.keyCode == 190 && (accident_loss == null || accident_loss =='')){
				return false;
			}else if(event.keyCode == 190 && (accident_loss != null && accident_loss !='') && index !=(-1)){
				return false;
			}
			return true;
		}else{
			alert("只能输入数字");
			return false;
		}
	}
	function selectOrgHR(select_type , select_id , select_name){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgHR.jsp?select='+select_type,teamInfo);
	    if(teamInfo.fkValue!=""){
	        document.getElementById(select_id).value = teamInfo.fkValue;
	        document.getElementById(select_name).value = teamInfo.value;
	    }
	}
	function refreshData(){
		var id  = '<%=report_id%>';
		var retObj = jcdpCallService("QualityItemsSrv","getReportDetail", "report_id=" + id);
		if(retObj.returnCode =='0'){
			var map = retObj.reportDetail;
			if(map !=null ){
				document.getElementById("report_id").value = id;
				document.getElementById("accident_id").value = '<%=accident_id%>';
				document.getElementById("report_org").value = map.report_org;
				document.getElementById("org_name").value = map.org_name;
				document.getElementById("accident_org").value = map.accident_org;
				document.getElementById("accident_name").value = map.accident_name;
				document.getElementById("accident_date").value = map.accident_date;
				document.getElementById("accident_loss").value = map.accident_loss;
				document.getElementById("describe").value = map.describe;
				document.getElementById("situation").value = map.situation;
				document.getElementById("reporter_id").value = map.reporter_id;
				document.getElementById("reporter_tel").value = map.reporter_tel;
			}
		}
	}
	refreshData();
	function newSubmit() {
		if(checkValue() == false){
			return ;
		}
		var form = document.getElementById("fileForm");
		form.action = '<%=contextPath%>/qua/sProject/accident/saveAccidentReport.srq?index=0';
		form.submit();
	}
	function checkValue(){
		var obj = document.getElementById("report_org") ;
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("单位名称不能为空!");
			return false;
		}
		obj = document.getElementById("accident_org") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("质量事故发生单位不能为空!");
			return false;
		}
		obj = document.getElementById("accident_date") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("质量事故发生时间不能为空!");
			return false;
		}
		obj = document.getElementById("accident_loss") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("预计直接经济损失不能为空!");
			return false;
		}
		obj = document.getElementById("reporter_id") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("报告人不能为空!");
			return false;
		}
	}
</script>
</body>
</html>