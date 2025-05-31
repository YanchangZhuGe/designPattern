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
	String projectName = user.getProjectName();
	if(projectName==null){
		projectName = "";
	}
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String qc_id = request.getParameter("qc_id");
	if(qc_id==null){
		qc_id = "";
	}
	String orgId = user.getOrgId();
	if(orgId==null || orgId.trim().equals("")){
		orgId = "";
	}
	String orgName = user.getOrgName();
	if(orgName==null || orgName.trim().equals("")){
		orgName = "";
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
 </head> 
 <body><!-- class="bgColor_f3f3f3"  onload="page_init()"> --> 
 <form name="fileForm" id="fileForm" method="post" > <!--target="hidden_frame" enctype="multipart/form-data" --> 
 <div id="new_table_box" align="center">
  <div id="new_table_box_content"> 
  	<div id="new_table_box_bg">
    <table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
     	<tr>
     		<input type="hidden" name="qc_id" id="qc_id" value="<%=qc_id %>" />
	    	<td class="inquire_item4">项目名称</td>
	    	<td class="inquire_form4">
	    		<input name="project_name" id="project_name" type="text" class="input_width" value="<%=projectName %>" disabled="disabled"/></td>
	    	<td class="inquire_item4"><font color="red">*</font>开展活动单位:</td>
		   	<td class="inquire_form4"><input type="hidden" name="org_id" id="org_id" value="<%=orgId %>" class="input_width" />
		    	<input name="org_name" id="org_name" type="text" class="input_width" value="<%=orgName %>" disabled="disabled"/>
				<img onclick="selectOrgHR('orgId','org_id','org_name')" src="<%=contextPath %>/images/images/tree_12.png" width="16" height="16" style="cursor: hand;" /></td> 
	    </tr>
	    <tr>
	    	<td class="inquire_item4"><font color="red">*</font>活动开始日期</td>
	    	<td class="inquire_form4"><input name="start_date" id="start_date" type="text" class="input_width" value="" readonly="readonly"/>
	    		<img width="16" height="16" id="cal_button6" style="cursor: hand;" 
	    		onmouseover="calDateSelector(start_date,cal_button6);" src="<%=contextPath %>/images/calendar.gif" /></td>
	    	<td class="inquire_item4"><font color="red">*</font>活动完成日期</td>
	    	<td class="inquire_form4"><input name="end_date" id="end_date" type="text" class="input_width" value="" readonly="readonly"/>
	    		<img width="16" height="16" id="cal_button7" style="cursor: hand;" 
	    		onmouseover="calDateSelector(end_date,cal_button7);" src="<%=contextPath %>/images/calendar.gif" /></td>
	     </tr>
	     <tr>
	    	<td class="inquire_item4">活动主持人</td>
	    	<td class="inquire_form4"><input name="qc_master" id="qc_master" type="hidden" class="input_width" value=""/>
	    		<input name="master_name" id="master_name" type="text" class="input_width" value="" disabled="disabled"/>
				<img onclick="selectOrgHR('userId','qc_master','master_name')" src="<%=contextPath %>/images/images/tree_12.png" width="16" height="16" style="cursor: hand;" /></td> 
	    	<td class="inquire_item4">活动人数:</td>
		   	<td class="inquire_form4"><input type="text" name="qc_num" id="qc_num" value="" class="input_width" 
		   		onkeydown="javascript:return checkIfNum(event);"/></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4"><font color="red">*</font>QC活动主题</td>
	    	<td colspan="3" class="inquire_form4"><textarea name="qc_title" id="qc_title" cols="45" rows="5" class="textarea"></textarea></td> <tr>
	    </tr>
	    	
	    </tr>
	    <tr>
	    	<td class="inquire_item4">QC活动申请理由</td>
	    	<td colspan="3" class="inquire_form4"><textarea name="reason" id="reason" cols="45" rows="5" class="textarea"></textarea></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4">备注</td>
	    	<td colspan="3" class="inquire_form4"><textarea name="notes" id="notes" cols="45" rows="5" class="textarea"></textarea></td>
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
	/* 输入的是否是数字 */
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
		var qc_id = '<%=qc_id%>';
		var retObj = jcdpCallService("QualityItemsSrv","getQCDetail", "qc_id=" + qc_id);
		if(retObj.returnCode =='0'){
			var map = retObj.qcDetail;
			if(map!=null){
				document.getElementById("qc_id").value = qc_id;
				document.getElementById("org_id").value = map.org_id;
				document.getElementById("org_name").value = map.org_name;
				document.getElementById("qc_title").value = map.qc_title;
				document.getElementById("start_date").value = map.start_date;
				document.getElementById("end_date").value = map.end_date;
				document.getElementById("qc_master").value = map.qc_master;
				document.getElementById("master_name").value = map.master_name;
				document.getElementById("qc_num").value = map.qc_num;
				document.getElementById("notes").value = map.notes;
			}
		}
	}
	refreshData();
	function newSubmit() {
		if(checkValue() == false){
			return ;
		}
		var form = document.getElementById("fileForm");
		form.action = '<%=contextPath%>/qua/sProject/QC/saveQC.srq';
		form.submit();
	}
	function checkValue(){
		var obj = document.getElementById("qc_title");
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("QC活动主题不能为空!");
			return false;
		}
		obj = document.getElementById("start_date");
		value = obj.value ;
		if(obj ==null || value==''){
			alert("活动开始日期不能为空!");
			return false;
		}
		obj = document.getElementById("end_date");
		value = obj.value ;
		if(obj ==null || value==''){
			alert("活动完成日期不能为空!");
			return false;
		}
		obj = document.getElementById("org_id");
		value = obj.value ;
		if(obj ==null || value==''){
			alert("开展活动单位不能为空!");
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
</script>
</body>
</html>