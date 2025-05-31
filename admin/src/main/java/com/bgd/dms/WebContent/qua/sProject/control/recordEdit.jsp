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
	String record_id = request.getParameter("record_id");
	if(record_id==null){
		record_id = "";
	}
	String task_id = request.getParameter("task_id");
	if(task_id==null){
		task_id = "";
	}
	String task_name = request.getParameter("task_name");
	if(task_name==null){
		task_name = "";
	}
	String object_id = request.getParameter("object_id");
	if(object_id==null){
		object_id = "";
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
 <form name="fileForm" id="fileForm" method="post" > <!--target="hidden_frame" enctype="multipart/form-data" --> 
	 <div id="new_table_box" align="center">
		<div id="new_table_box_content"> 
			<div id="new_table_box_bg">
			  <table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   	<tr>
			   		<input type="hidden" name="record_id" id="record_id" value="<%=record_id %>" />
			  		<input type="hidden" name="task_id" id="task_id" value="<%=task_id %>" />
			  		<input type="hidden" name="task_name" id="task_name" value="<%=task_name %>" />
			   	<td class="inquire_item4">项目名称</td>
			   	<td class="inquire_form4">
			   		<input name="project_name" id="project_name" type="text" class="input_width" value="<%=projectName %>" disabled="disabled"/></td>
			   	<td class="inquire_item4">作业名称</td>
			   	<td class="inquire_form4">
			   		<input name="task_name" id="task_name" type="text" class="input_width" value="<%=task_name %>" disabled="disabled"/></td>
			   </tr>
			  	<tr>
			  		<td class="inquire_item4"><font color="red">*</font>工序名称</td>
			   	<td class="inquire_form4">
			   		<select id="quality_type" name="quality_type" class="select_width" onchange="getRecordType()">
			   		</select>
			   	</td>
			  		<td class="inquire_item4"><font color="red">*</font>记录项类型</td>
			   	<td class="inquire_form4">
			   		<select id="record_type" name="record_type" class="select_width">
			   		</select>
			   		<input name="record_name" id="record_name" type="hidden" class="input_width" />
			   	</td>
			  	</tr>
			  	<tr>
			  		<td class="inquire_item4"><font color="red">*</font>状态</td>
			   	<td class="inquire_form4">
					<select id="status" name="status" class="select_width">
			   			<option value="1">整改中</option>
			   			<option value="2">合格</option>
			   			<option value="3">整改合格</option>
			   			<option value="4">不合格</option>
			   		</select>
			   	</td>
			   	<td class="inquire_item4">机组号</td>
			   	<td class="inquire_form4"><input name="unit_id" id="unit_id" type="text" 
			   		onkeypress="javascript:return checkIfNum(event);"  class="input_width" value=""/></td>
			   </tr>
			   <tr>
			   	<td class="inquire_item4">检查日期</td>
			   	<td class="inquire_form4"><input name="check_date" id="check_date" type="text" class="input_width" value="" readonly="readonly"/>
			   		<img width="16" height="16" id="cal_button6" style="cursor: hand;" 
			   		onmouseover="calDateSelector(check_date,cal_button6);" 
			   		src="<%=contextPath %>/images/calendar.gif" /></td>
			   	<td class="inquire_item4">要求完成日期</td>
			   	<td class="inquire_form4"><input name="complete_date" id="complete_date" type="text" class="input_width" value="" readonly="readonly"/>
			   		<img width="16" height="16" id="cal_button7" style="cursor: hand;" 
			   		onmouseover="calDateSelector(complete_date,cal_button7);" 
			   		src="<%=contextPath %>/images/calendar.gif" /></td>
			   </tr>
			   <tr>
			   	<td class="inquire_item4">检查人:</td>
			    <td class="inquire_form4" ><input type="hidden" name="checker" id="checker" value="" class="input_width" />
			    	<input name="checker_name" id="checker_name" type="text" class="input_width" value="" disabled="disabled"/>
					<img onclick="selectOrgHR('userId','checker','checker_name')" src="<%=contextPath %>/images/images/tree_12.png" width="16" height="16" style="cursor: hand;" /></td> 
			  	<td class="inquire_item4">整改单位</td>
			    <td class="inquire_form4" ><input type="hidden" name="org_id" id="org_id" value="" class="input_width" />
			    	<input name="org_name" id="org_name" type="text" class="input_width" value="" disabled="disabled"/>
					<img onclick="selectOrgHR('orgId','org_id','org_name')" src="<%=contextPath %>/images/images/tree_12.png" width="16" height="16" style="cursor: hand;" /></td> 
			 		</tr>
			    <tr>
			    	<td class="inquire_item4">备注</td>
			    	<td colspan="3" class="inquire_form4"><textarea name="notes" id="notes" cols="45" rows="5" class="textarea"> </textarea></td>
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
		if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8){
			return true;
		}
		else{
			alert("只能输入数字");
			return false;
		}
	}
	function getQualityType(){
		var object_name =  '<%=object_id%>';
		var retObj = jcdpCallService("QualityItemsSrv", "getQualityType", "qualityType="+object_name);
		var selObj = document.getElementById("quality_type");
		if(retObj!=null){
			if(selObj!=null){
				for(var i=0;selObj.options[i]!=null;){
					selObj.options[i] = null;
				}
				for(var i=0;retObj.qualityType[i]!=null;i++){
					selObj.options[i] = 
						new Option(retObj.qualityType[i].label,retObj.qualityType[i].value);
				}
			}
		}
		getRecordType();
	}
	function getRecordType(){
		var selObj = document.getElementById("record_type");
		for(var i=0;selObj.options[i]!=null;){
			selObj.options[i] = null;
		}
		var value = document.getElementById("quality_type").options.value;
		if(value!=null ){
			var retObj = jcdpCallService("QualityItemsSrv", "getRecordType", "qualityType="+value);
			var selObj = document.getElementById("record_type");
			for(var i=0;retObj.recordType[i]!=null;i++){
				selObj.options[i] = 
					new Option(retObj.recordType[i].codingName,retObj.recordType[i].codingCodeId);
			}
		}
	}
	function refreshCodeData(){
		getQualityType();
		var record_id  = '<%=record_id%>';
		var retObj = jcdpCallService("QualityItemsSrv", "getQualityItemsDetail", "recordId="+record_id);
		var qualityItemDetail = retObj.qualityItemDetail;
		if(qualityItemDetail!=null){
			document.getElementById("record_id").value = record_id;
			document.getElementById("project_name").value = retObj.qualityItemDetail.projectName;
			document.getElementById("checker").value = retObj.qualityItemDetail.checker;
			document.getElementById("checker_name").value = retObj.qualityItemDetail.checkerName;
			document.getElementById("check_date").value = retObj.qualityItemDetail.checkDate;
			document.getElementById("complete_date").value = retObj.qualityItemDetail.completeDate;
			document.getElementById("unit_id").value = retObj.qualityItemDetail.unitId;
			document.getElementById("org_id").value = retObj.qualityItemDetail.orgId;
			document.getElementById("org_name").value = retObj.qualityItemDetail.orgName;
			document.getElementById("notes").value = retObj.qualityItemDetail.notes;
			var quality = qualityItemDetail.qualityType;
			var quality_type = document.getElementById("quality_type");
			if(quality_type!=null && quality_type.options.length>0){
				for(var i =0; i<quality_type.options.length;i++){
					var option = quality_type.options[i];
					if(quality==option.value){
						option.selected = true;
					}
				}
			}
			getRecordType();
			var record_type = qualityItemDetail.recordType;
			var recordType = document.getElementById("record_type");
			if(recordType!=null && recordType.options.length>0){
				for(var i =0; i<recordType.options.length;i++){
					var option = recordType.options[i];
					if(record_type == option.value){
						option.selected = true;
					}
				}
			}
			var sta = qualityItemDetail.status;
			var status = document.getElementById("status");
			if(status!=null && status.options.length>0){
				for(var i =0; i<status.options.length;i++){
					var option = status.options[i];
					if(sta == option.value){
						option.selected = true;
					}
				}
			}
		}
		
	}
	refreshCodeData();
	function newSubmit() {
		if(!checkRight()){
			return;
		}
		var form = document.getElementById("fileForm");
		var recordType = document.getElementById("record_type");
		var text = recordType.options[recordType.selectedIndex].text;
		document.getElementById("record_name").value = text;
		form.action = '<%=contextPath%>/qua/sProject/editQualityItems.srq';
		form.submit();
	}
	function checkRight(){
		var check_date = document.getElementById("check_date").value;
		var complete_date = document.getElementById("complete_date").value;
		if(check_date != null && complete_date != null && check_date!='' && complete_date!=''){
			if(complete_date < check_date){
				alert("要求完成日期不能早于检查日期");
				document.getElementById("complete_date").value = '';
				return false;
			}
		}
		return true;
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