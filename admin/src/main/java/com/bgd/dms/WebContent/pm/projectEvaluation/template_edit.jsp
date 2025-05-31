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
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String id = request.getParameter("id");
	if(id==null){
		id = "";
	}
	String name = request.getParameter("name");
	if(name==null){
		name = "";
	}
	String evaluate_weight = request.getParameter("evaluate_weight");
	if(evaluate_weight==null){
		evaluate_weight = "";
	}
	String evaluate_standard = request.getParameter("evaluate_standard");
	if(evaluate_standard==null){
		evaluate_standard = "";
	}
	String ordering = request.getParameter("ordering");
	if(ordering==null){
		ordering = "";
	}
	String org_name = user.getOrgName();
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
     		
	    	<td class="inquire_item4">考核内容</td>
	    	<td class="inquire_form4"><input type="hidden" name="evaluate_template_id" id="evaluate_template_id" value="<%=id %>" />
	    		<input name="evaluate_template_name" id="evaluate_template_name" type="text" class="input_width" value="<%=name %>" /></td>
	    	<td class="inquire_item4">标准分值</td>
	    	<td class="inquire_form4">
	    		<input name="evaluate_weight" id="evaluate_weight" type="text" class="input_width" value="<%=evaluate_weight %>" onkeydown="javascript:return checkIfNum(event);" style="ime-mode:disabled;"/></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4">排序(序号)</td>
	    	<td class="inquire_form4">
	    		<input name="ordering" id="ordering" type="text" class="input_width" value="<%=ordering %>" onkeydown="javascript:return checkIfNum(event);" style="ime-mode:disabled;"/></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4">评分标准</td>
	    	<td class="inquire_form4" colspan="3">
				<textarea name="evaluate_standard" id="evaluate_standard" class="textarea" ><%=evaluate_standard %></textarea></td>
	    </tr>
    </table> 
  </div> 
  <div id="oper_div">
	<span class="tj_btn"><a href="#" onclick="newSubmit()"></a></span>
 	<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
  </div>
  </div> 
  </div>
</form> 
<script type="text/javascript">
	cruConfig.contextPath = '<%=contextPath%>';
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
	function checkIfNum(){
		if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8){
			return true;
		}
		else{
			alert("只能输入数字");
			return false;
		}
	}
	function newSubmit() {
		if(checkValue()==false){
			return;
		}
		var evaluate_template_id = document.getElementById("evaluate_template_id").value;
		var evaluate_template_name = document.getElementById("evaluate_template_name").value;
		var evaluate_weight = document.getElementById("evaluate_weight").value;
		var evaluate_standard = document.getElementById("evaluate_standard").value;
		var ordering = document.getElementById("ordering").value;
		var sql = "update bgp_pm_evaluate_template t set t.evaluate_template_name='"+evaluate_template_name+"',t.evaluate_weight='"+evaluate_weight+"',"+
		"t.evaluate_standard ='"+evaluate_standard+"',t.ordering='"+ordering+"' where t.evaluate_template_id='"+evaluate_template_id+"';"
		var retObj = jcdpCallService("ProjectEvaluationSrv", "saveDatasBySql", "sql="+sql);
		if(retObj!=null && retObj.returnCode=='0'){
			var ctt = top.frames('list');
			ctt.document.getElementById("menuTree");
			debugger;
			ctt.refreshTree(evaluate_template_id);
			newClose();
		}else{
			alert("保存失败!")
		}
		//form.submit();
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
	function checkValue(){
		var obj = document.getElementById("evaluate_template_name") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("考核内容不能为空!");
			return false;
		}
		obj = document.getElementById("evaluate_weight") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("标准分值不能为空!");
			return false;
		}
		obj = document.getElementById("ordering") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("排序(序号)不能为空!");
			return false;
		}
	}
</script>
</body>
</html>