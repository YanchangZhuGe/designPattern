<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%@ page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%> 
<%
	String contextPath = request.getContextPath();
	String selectOrg = request.getParameter("selectorg");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<link rel="stylesheet" href="<%=contextPath%>/js/extjs/resources/css/ext-all.css"/>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>
	<title>新增单位考核指标</title>
</head>
<body class="bgColor_f3f3f3" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content" style="height: 500px;">
    <div id="new_table_box_bg" style="height: 350px;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<tr>
      		<td>
		      <fieldset style="margin-left:2px"><legend>指标信息</legend>
		      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		        <tr>
		          <td class="inquire_item6" align="left"><font color=red>*</font>&nbsp;单位名称:</td>
		          <td class="inquire_form6" style="padding-right:20px">
		          	<select id="assess_org" name="assess_org">
		          	<% if(selectOrg==null||"".equals(selectOrg)||"null".equals(selectOrg)){ %>
			    		<option value="" selected="selected">--请选择--</option>
			    	<% } %>
		          	</select>
		          </td>
		          <td class="inquire_item6" align="left"><font color=red>*</font>&nbsp;指标类型:</td>
		          <td class="inquire_form6" style="padding-right:20px">
		          	<select id="assess_type" name="assess_type">
		          		<option value="" selected="selected">--请选择--</option>
		          	</select>
		          </td>
		          <td class="inquire_item6" align="left"><font color=red>*</font>&nbsp;权重值:</td>
				  <td class="inquire_form6" style="padding-right:20px">
					<input name="assess_value" id="assess_value" class="input_width" type="text"  onblur='checkAssessNum(this,"ass")' value="0" />
				  </td>
				</tr>
				<tr>
				  <td class="inquire_item6" align="left">指标值上限(%):</td>
				  <td class="inquire_form6" style="padding-right:20px">
					<input name="assess_org_ceiling" id="assess_org_ceiling" class="input_width" type="text"  onblur='checkAssessNum(this,"cei")' value="100" />
				  </td>
				  <td class="inquire_item6" align="left">指标值下限(%):</td>
				  <td class="inquire_form6" style="padding-right:20px">
					 <input name="assess_org_floor" id="assess_org_floor" class="input_width" type="text"  onblur='checkAssessNum(this,"flo")' value="0" />
				  </td>
				</tr>		        
		        <tr><td></td></tr>
			   <tr>
			   	<td class="inquire_item6" >备注:</td>
				<td class="inquire_form6" colspan="5">
					<textarea id="assess_remark" name="assess_remark" rows="2" cols="75" ></textarea>
				</td>
			  </tr>
		      </table>
		      </fieldset>
      		</td>
      	</tr>
      </table>
    </div>
    <div id="oper_div">
     	<span class="bc_btn"><a id="submitButton" href="####" onclick="saveInfo()"></a></span>
        <span class="gb_btn"><a href="####" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	var select_org = '<%=selectOrg%>';

	function loadDataDetail(){
		var retObj = jcdpCallService("DeviceAssessInfoSrv", "getAllAssessInfo", "");
		var assesstypeoptionhtml = "";
		
		if(retObj!=null && retObj.returnCode=='0'){
			for(var index=0;index<retObj.assesslist.length;index++){
				assesstypeoptionhtml +=  "<option name='assesstypecode' id='assesstypecode"+index+"' value='"+retObj.assesslist[index].value+"'>"+retObj.assesslist[index].label+"</option>";
			}
			$("#assess_type").append(assesstypeoptionhtml);
		}

		var retOrgObj = jcdpCallService("DeviceAssessInfoSrv", "getAssessOrgInfo", "selectorg="+select_org);
		var assesstypeoptionhtml = "";

		var assessorgoptionhtml = "";
		for(var index=0;index<retOrgObj.assessOrglist.length;index++){
			assessorgoptionhtml +=  "<option name='assessorgcode' id='assessorgcode"+index+"' value='"+retOrgObj.assessOrglist[index].value+"'>"+retOrgObj.assessOrglist[index].label+"</option>";
		}
		$("#assess_org").append(assessorgoptionhtml);
	}
	
	function saveInfo(){

		var assess_org_value = document.getElementById("assess_org").value;
		if(assess_org_value == ''){
			alert("单位不能为空!");
			return;
		}
		
		var assess_type_value = document.getElementById("assess_type").value;
		if(assess_type_value == ''){
			alert("指标类型不能为空!");
			return;
		}

		var assess_value_value = document.getElementById("assess_value").value;
		if(assess_value_value == ''){
			alert("指标权重不能为空!");
			return;
		}

		var assessceiling = parseInt($("#assess_org_ceiling").val(),10);
		var assessfloor = parseInt($("#assess_org_floor").val(),10);

		if((assessceiling >0) && (assessfloor > assessceiling)){
			alert("指标值下限不能大于上限!");
			return;
		}
		
		var retObj = jcdpCallService("DeviceAssessInfoSrv", "getOrgAssessExist", "assessorg="+assess_org_value+"&assesstype="+assess_type_value);
		
		if(retObj != null&&retObj!=""){
			if(retObj.existtmp == '1'){
				alert("本单位已存在此指标，不能新增!");
				return;
			}
		}
		
		if(window.confirm("确认保存?")){
			Ext.MessageBox.wait('请等待...','处理中...');
			$("#submitButton").attr({"disabled":"disabled"});
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveOrgAssessInfo.srq?selectorg="+select_org;
			document.getElementById("form1").submit();
		}
	}

	function checkAssessNum(obj,str){
		var assessValue = obj.value;
		var re = /^(?:(?:[1-9]\d*)|(?:0))$/;
		if(assessValue==""){
			if(str=="ass"){
				$("#assess_value").val("");
				alert("权重值不能为空!");
			}
			return;
		}else{
			var assessValue = parseInt(assessValue,10);
			if(str=="cei"){
				if(!re.test(assessValue)){
					$("#assess_org_ceiling").val("");
					alert("指标值上限必须为数字!");
					return;
				}
				if(assessValue > 100){
					$("#assess_org_ceiling").val("");
					alert("指标值上限不能超过100!");
					return;
				}				
			}else if(str=="flo"&&!re.test(assessValue)){
				$("#assess_org_floor").val("");
				alert("指标值下限必须为数字!");
				return;
			}else if(str=="ass"&&!re.test(assessValue)){
				$("#assess_value").val("");
				alert("权重值必须为数字!");
				return;
			}
		}
	}
	
</script>
</html>

