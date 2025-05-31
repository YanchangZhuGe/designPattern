<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String deviceappid = request.getParameter("deviceappid");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String addUpFlag = request.getParameter("addupflag");
	String appDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
	String opi_id = request.getParameter("select_model_id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/ext-all.js"></script>
<style type="text/css">
#new_table_box_content {
width:auto;
height:620px;
border:1px #999 solid;
background:#cdddef;
padding:15px;
}
#new_table_box_bg {
width:auto;
height:487px;
border:1px #aebccb solid;
background:#f1f2f3;
padding:10px;
overflow:auto;
}
</style>
<title>设备选型申请</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="" enctype="multipart/form-data" >
	<div id="new_table_box">
	<div id="new_table_box_content">
	<div id="new_table_box_bg">
	<fieldSet style="margin:2px:padding:2px;"><legend>设备选型申请</legend>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	     <input name="opi_id" id="opi_id" type="hidden" value="<%=opi_id%>" />
	     <input name="company_id" id="company_id" type="hidden" value="" />
	    <tr>
    		<td class="inquire_item4" width="10%"><font color="red">*</font>&nbsp;产品名称型号：</td>
    		<td class="inquire_form4" class="inquire_form4" width="35%"><input name="opi_name" id="opi_name" class="input_width easyui-validatebox main" type="text" value="" style="width: 100%" data-options="validType:'length[0,50]'" maxlength="50" required/></td>
    		<td class="inquire_item4" width="10%">&nbsp;商标：</td>
    		<td class="inquire_form4" ><input name="brand" id="brand" class="input_width "  type="text" value="" style="width: 100%" data-options="validType:'length[0,50]'" maxlength="50" required/></td>
	    </tr>
	    <tr>
      		<td class="inquire_item4" ><font color="red">*</font>&nbsp;生产单位：</td>
      		<td class="inquire_form4"><input name="production" id="production" readonly="readonly" class="input_width easyui-validatebox main" type="text" value="" style="width: 80%" data-options="validType:'length[0,50]'" maxlength="50" required/>
			<table border="0">
				<tr><td><span class="xq"><a href="####" id="production" onclick="toAdd()" title="添加企业"></a></span></td></tr>
			</table></td>
      		<td class="inquire_item4" >&nbsp;上年产量：</td>
      		<td class="inquire_form4" ><input name="last_year_yield" id="last_year_yield" style="width:100%;height:20px;line-height:20px;border:1px solid #a4b2c0;float:left;background:#FFF;" type="text" value="" class="input easyui-numberbox main" data-options="validType:'length[0,50]'" maxlength="50" /></td>
	     </tr>
	     <tr>
      		<td class="inquire_item4" ><font color="red">*</font>&nbsp;主要用户名称：</td>
      		<td  colspan="3" class="inquire_form4"><input name="main_user_object" id="main_user_object" class="input_width easyui-validatebox main" type="text" value="" style="width: 100%" data-options="validType:'length[0,100]'" maxlength="100" required/></td>
	     </tr>
	     <tr>
      		<td class="inquire_item4" ><font color="red">*</font>&nbsp;产品简介：</td>
      		<td  colspan="3" class="inquire_form4"><textarea id="product_info" name="product_info"  class="input_width easyui-textarea easyui-validatebox main" style="width:100%;height:40px;" overflow-x:hidded; data-options="validType:'length[0,250]'" maxlength="250" required onpropertychange="checkLength(this,250);" oninput="checkLength(this,250);"></textarea></td>
	     </tr>
	     <tr id="file_tr_public">
			<td class="inquire_item4">&nbsp;技术参数：</td>
  			<td class="inquire_form4" colspan="1"><input type="file" name='skill_parameter__' id='skill_parameter__' class="input_width" style="width: 100%"/></td>
		 </tr>
		 <tr>
		   <td colspan="3">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="file_skill_tablePublic">
				<input name="skill_parameter_report" id="skill_parameter_report" type="hidden" />
			 </table>
		   </td>
		 </tr>
		 <tr>
			<td class="inquire_item4" >&nbsp;测试使用报告：</td>
			<td class="inquire_form4" ><font style="font-size: 15px;">多附件</font><auth:ListButton functionId="" css="dr" event="onclick='testUsingFileDataAdd(1)'" title="导入附件"></auth:ListButton></td>
		 </tr>
		 <tr>
		   <td colspan="3">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="file_test_tablePublic">
				<input name="test_using_report" id="test_using_report" type="hidden"/>
			 </table>
		   </td>
		 </tr>
		  <tr>
			<td class="inquire_item4" >&nbsp;应用证明：</td>
			<td class="inquire_form4" ><font style="font-size: 15px;">多附件</font><auth:ListButton functionId="" css="dr" event="onclick='userProveFileDataAdd(1)'" title="导入附件"></auth:ListButton></td>
		 </tr>
		 <tr>
		   <td colspan="3">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="userProve_file_tablePublic">
				<input name="user_prove" id="user_prove" type="hidden"/>
			 </table>
		   </td>
		 </tr>
		  <tr>
			<td class="inquire_item4" >&nbsp;生产单位资质：</td>
			<td class="inquire_form4" ><font style="font-size: 15px;">多附件</font><auth:ListButton functionId="" css="dr" event="onclick='productionFileDataAdd(1)'" title="导入附件"></auth:ListButton></td>
		 </tr>
		 <tr>
		   <td colspan="3">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="production_file_tablePublic">
				<input name="production_unit_aptitude" id="production_unit_aptitude" type="hidden"/>
			 </table>
		   </td>
		 </tr>
		  <tr>
			<td class="inquire_item4" >&nbsp;其他附件：</td>
			<td class="inquire_form4" ><font style="font-size: 15px;">多附件</font><auth:ListButton functionId="" css="dr" event="onclick='otherFileDataAdd(1)'" title="导入附件"></auth:ListButton></td>
		 </tr>
		 <tr>
		   <td colspan="3">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="other_file_tablePublic">
				<input name="other" id="other" type="hidden"/>
			 </table>
		   </td>
		 </tr>
		 <tr>
      		<td class="inquire_item4" ><font color="red">*</font>&nbsp;申请状态：</td>
      		<td colspan="4" class="inquire_form4">
      			<input type="radio" id="apply_state" name="apply_state" value="0" checked="checked"/><label >&nbsp;首次申请&nbsp;&nbsp;&nbsp;&nbsp;</label>
      			<input type="radio" id="apply_state" name="apply_state" value="1"/><label >&nbsp;至期复查&nbsp;&nbsp;&nbsp;&nbsp;</label>
      			<input type="radio" id="apply_state" name="apply_state" value="2"/><label >&nbsp;增项</label>
      		</td>
	     </tr>
	     <tr>
      		<td class="inquire_item4" ><font color="red">*</font>&nbsp;申请单位：</td>
      		 <td class="inquire_item4" style="width:50px;">
      			<input name="apply_unit" id="apply_unit" class="input_width easyui-validatebox main" type="text" value="<%=user.getOrgName() %>" style="width: 100%" readonly="readonly" required/>
				<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOrgTreePage()"  />
				<input id="apply_unit_code" name="apply_unit_code" class="" type="hidden" />
				<input id="apply_uno_code" name="apply_uno_code" class="" type="hidden" />
		    </td>
	     </tr>
	     <tr>
      		<td class="inquire_item4" ><font color="red">*</font>&nbsp;申请单位理由：</td>
      		<td  colspan="3" class="inquire_form4"><textarea id="apply_unit_reason" name="apply_unit_reason"  class="input_width easyui-textarea easyui-validatebox main"data-options="validType:'length[0,250]'" maxlength="250" style="width:100%;height:40px" required onpropertychange="checkLength(this,250);" oninput="checkLength(this,250);"></textarea></td>
	     </tr>
	     <tr>
      		<td class="inquire_item4" ><font color="red">*</font>&nbsp;负责人：</td>
      		<td class="inquire_form4"><input name="principal" id="principal" class="input_width easyui-validatebox main" type="text" value="" required data-options="validType:'length[0,50]'" maxlength="50"/></td>
      		<td class="inquire_item4" ><font color="red">*</font>&nbsp;批准时间：</td>
      		<td><input type="text" name="approve_date" id="approve_date" value="<%=appDate %>" class="input_width easyui-datebox main" style="width:258px" required/></td>
	     </tr>
	     <tr>
			<td class="inquire_item4" >&nbsp;附件(评审证明)：</td>
			<td class="inquire_form4" ><font style="font-size: 15px;">多附件</font><auth:ListButton functionId="" css="dr" event="onclick='reviewConfirmsFileDataAdd(1)'" title="导入附件"></auth:ListButton></td>
		 </tr>
		 <tr>
		   <td colspan="3">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="reviewConfirms_file_tablePublic">
				<input name="review_confirms" id="review_confirms" type="hidden"/>
			 </table>
		   </td>
		 </tr>
	    </table>
		</fieldSet>
		<fieldSet style="margin:2px:padding:2px;"><legend>评审</legend>
		<h5 align="center" style="font-size: 15px">专家组意见</h5>
       <table style="width:98%" border="1" cellspacing="0" cellpadding="0" class="tab_line_height">
	 	<tr>
          <td width="11%;" align="right"><font color="red">*</font>&nbsp;意见：</td>
	      <td colspan="2" class="inquire_form4"><textarea id="panel_idea" name="panel_idea"  class="input_width easyui-textarea easyui-validatebox main" style="width:60%;height:40px" data-options="validType:'length[0,250]'" maxlength="250" required onpropertychange="checkLength(this,250);" oninput="checkLength(this,250);"></textarea></td>
        </tr>
        <tr>
			<td align="right"><font color="red">*</font>&nbsp;负责人：</td>
			<td class="inquire_form4">
				<input name="panel_principal" id="panel_principal" class="input_width easyui-validatebox" type="text" value="" style="width: 258px" title="负责人" data-options="validType:'length[0,50]'" maxlength="50" required/>
			</td>
		</tr>
		<tr>
          <td align="right"><font color="red">*</font>评审日期：</td>
          <td class="inquire_form4">
				<input type="text" name="panel_review_date" id="panel_review_date" title="评审日期"  value="<%=appDate %>" class="input_width easyui-datebox main" style="width:258px" required />
		  </td>
        </tr>
      </table>
      <h5 align="center" style="font-size: 15px">设备物资处意见</h5>
		<table style="width:98%" border="1" cellspacing="0" cellpadding="0" class="tab_line_height">
	 	<tr>
          <td width="8%;" align="right"><font color="red">*</font>&nbsp;意见：</td>
	      <td colspan="2" class="inquire_form4"><textarea id="equipment_idea" name="equipment_idea"  class="input_width easyui-textarea easyui-validatebox main" style="width:60%;height:40px" data-options="validType:'length[0,250]'" maxlength="250" required onpropertychange="checkLength(this,250);" oninput="checkLength(this,250);"></textarea></td>
        </tr>
        <tr>
			<td align="right"><font color="red">*</font>&nbsp;负责人：</td>
			<td class="inquire_form4">
				<input name="equipment_principal" id="equipment_principal" class="input_width easyui-validatebox main" type="text" value="" style="width: 258px" title="负责人" data-options="validType:'length[0,50]'" maxlength="50" required/>
			</td>
		</tr>
		<tr>
          <td align="right" ><font color="red">*</font>&nbsp;评审日期：</td>
          <td class="inquire_form4">
				<input type="text" name="equipment_review_date" id="equipment_review_date" title="评审日期"  value="<%=appDate %>" class="input_width easyui-datebox" style="width:258px" required />
		  </td>
        </tr>
        <tr>
          <td align="right"><font color="red">*</font>&nbsp;评审结果：</td>
          <td><select  class="input_width easyui-combobox easyui-validatebox main" name="review_result" id="review_result" style="width: 60px" editable="false" required>
			 <option value ="0">通过</option>
			 <option value ="1">未通过</option>
			</select>
		</td>
        </tr>
        <tr>
	      <td align="right">&nbsp;附件(评审证明)：</td>					
	      	<auth:ListButton functionId="" css="dr" event="onclick='reviewConfirmsFileData(1)'" title="导入附件"></auth:ListButton>
	     </tr>	
	      <tr>
		   <td colspan="3">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="review_tablePublic">
				<input name="review_confirms" id="review_confirms" type="hidden"/>
			 </table>
		   </td>
		 </tr>
		</table>
		</fieldSet>
		<div id="oper_div" style="text-align: right">
	     	<span class="bc_btn"><a href="####" id ="submitButton" onclick="saveInfo()"></a></span>
	        <span class="gb_btn"><a href="####" onclick="newClose()"></a></span>
   		</div>	
		</div>
		</div>
	</div>
</form>
</body>
<script type="text/javascript">
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var idinfo = '<%=deviceappid%>';
	var addupflag = '<%=addUpFlag%>';
	var addedseqinfo;
	var flag_public = 0;	
	debugger;
	$().ready(function(){
		//禁止日期框手动输入
		$("#approve_date").datebox({
			editable: false
        });
	});
	
	function checkLength(obj,maxlength){
    if(obj.value.length > maxlength){
        obj.value = obj.value.substring(0,maxlength);
    }
}
	//选择生产单位
	function toAdd(){
		 var obj = new Object();
		var dialogurl = "<%=contextPath%>/dmsManager/modelSelection/selectEnterprise.jsp";
		dialogurl = encodeURI(dialogurl);
		dialogurl = encodeURI(dialogurl);
		var vReturnValue =  window.showModalDialog(dialogurl , obj ,"dialogHeight: 600px; dialogWidth: 950px");
		
		var content= vReturnValue.split('~');
		document.getElementById("company_id").value=content[0];
		document.getElementById("production").value=content[1];
	}
	/**
	 * 申请单位 
	 * 选择组织机构树
	 */
	function showOrgTreePage(){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
		if(returnValue == undefined){
			return;
		}
		var strs= new Array(); //定义一数组
		strs=returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		document.getElementById("apply_unit").value = names[1];
		
		var orgId = strs[1].split(":");
		document.getElementById("apply_unit_code").value = orgId[1];

		var orgSubId = strs[2].split(":");
		document.getElementById("apply_uno_code").value = orgSubId[1];
	}
	
	function refreshData(){ 
		var baseData; 
		if('<%=opi_id%>'!='null'){ 
			baseData = jcdpCallService("EquipmentSelectionApply", "getopiInfo", "opi_id="+$("#opi_id").val());
			$("#opi_name").val(baseData.deviceappMap.opi_name);
			$("#brand").val(baseData.deviceappMap.brand);
			$("#production").val(baseData.deviceappMap.production);
			$("#last_year_yield").val(baseData.deviceappMap.last_year_yield);
			$("#main_user_object").val(baseData.deviceappMap.main_user_object);
			$("#product_info").val(baseData.deviceappMap.product_info); 
			if(baseData.deviceappMap.apply_state=="1") {
				document.all.apply_state[1].checked = true;   
			}
			if(baseData.deviceappMap.apply_state=="0") {
				document.all.apply_state[0].checked = true;   
			}
			if(baseData.deviceappMap.apply_state=="2") {
				document.all.apply_state[2].checked = true;   
			}
			$("#apply_unit").val(baseData.deviceappMap.apply_unit);
			$("#apply_unit_code").val(baseData.deviceappMap.apply_unit_code);
			$("#apply_unit_reason").val(baseData.deviceappMap.apply_unit_reason);
			$("#principal").val(baseData.deviceappMap.principal);
			$("#approve_date").datebox("setValue", baseData.deviceappMap.approve_date);
			
 			$("#panel_idea").val(baseData.deviceappMap.panel_idea);
			$("#panel_principal").val(baseData.deviceappMap.panel_principal);
			if(baseData.deviceappMap.panel_review_date !=""){
				$("#panel_review_date").datebox("setValue", baseData.deviceappMap.panel_review_date);
			}
			$("#equipment_idea").val(baseData.deviceappMap.equipment_idea);
			$("#equipment_principal").val(baseData.deviceappMap.equipment_principal);
			if(baseData.deviceappMap.equipment_review_date !=""){
				$("#equipment_review_date").datebox("setValue", baseData.deviceappMap.equipment_review_date);
			}
			$("#review_result").val(baseData.deviceappMap.review_result);
			
			if(baseData.fdataPublic!=null){ debugger;
				// 有附件不显示设备详情而是显示附件
				for (var tr_id = 1; tr_id<=baseData.fdataPublic.length; tr_id++) {
					if(baseData.fdataPublic[tr_id-1].file_type =="skill_parameter"){
						insertFilePublicSkill(baseData.fdataPublic[tr_id-1].file_name,baseData.fdataPublic[tr_id-1].file_id);
						flag_public=1;
					}
					if(baseData.fdataPublic[tr_id-1].file_type =="test_content"){
						insertFilePublicTest(baseData.fdataPublic[tr_id-1].file_name,baseData.fdataPublic[tr_id-1].file_id);
						flag_public=1;
					}
					if(baseData.fdataPublic[tr_id-1].file_type =="user_prove_content"){
						insertFilePublicUser(baseData.fdataPublic[tr_id-1].file_name,baseData.fdataPublic[tr_id-1].file_id);
						flag_public=1;
					}
					if(baseData.fdataPublic[tr_id-1].file_type =="production_file_content"){
						insertFilePublicProduction(baseData.fdataPublic[tr_id-1].file_name,baseData.fdataPublic[tr_id-1].file_id);
						flag_public=1;
					}
					if(baseData.fdataPublic[tr_id-1].file_type =="other_file_content"){
						insertFilePublicOther(baseData.fdataPublic[tr_id-1].file_name,baseData.fdataPublic[tr_id-1].file_id);
						flag_public=1;
					}
					if(baseData.fdataPublic[tr_id-1].file_type =="review_confirms_file_content"){
						insertFilePublicReview(baseData.fdataPublic[tr_id-1].file_name,baseData.fdataPublic[tr_id-1].file_id);
						flag_public=1;
					}
					if(baseData.fdataPublic[tr_id-1].file_type =="review_content"){
						insertFilePublicNew(baseData.fdataPublic[tr_id-1].file_name,baseData.fdataPublic[tr_id-1].file_id);
						flag_public=1;
					}
				}
			}
		}
	}
	//保存
	function saveInfo(){debugger;
		var opi_name = $.trim($("#opi_name").val());
		if(opi_name.length<=0){
			$.messager.alert("提示","产品名称型号不能为空!");
			return;
		}	 
		var production = $.trim($("#production").val());
		if(production<=0){
		$.messager.alert("提示","生产单位不能为空!");
			return;
		}
		var main_user_object =  $.trim($("#main_user_object").val());
		if(main_user_object<=0){
		$.messager.alert("提示","主要用户名称不能为空!");
			return;
		}
		var product_info = $.trim($("#product_info").val());
		if(product_info<=0){
		$.messager.alert("提示","产品简介不能为空!");
			return;
		}
		
		if($("#apply_state").val()==""){
		$.messager.alert("提示","申请状态不能为空!");
			return;
		}
		var apply_unit = $.trim($("#apply_unit").val());
		if(apply_unit<=0){
		$.messager.alert("提示","申请单位不能为空!");
			return;
		}
		if($("#apply_unit_reason").val()==""){
		$.messager.alert("提示","申请单位理由不能为空!");
			return;
		}
		var principal = $.trim($("#principal").val());
		if(principal<=0){
		$.messager.alert("提示","负责人不能为空!");
			return;
		}
		var approve_date = $.trim($("#approve_date").val());
		if(approve_date<=0){
		$.messager.alert("提示","批准时间不能为空!");
			return;
		}
		
		var panel_idea = $.trim($("#panel_idea").val());
		if(panel_idea<=0){
		$.messager.alert("提示","专家组意见不能为空!");
			return;
		}
		var panel_principal = $.trim($("#panel_principal").val());
		if(panel_principal<=0){
		$.messager.alert("提示","专家组负责人不能为空!");
			return;
		}
		var equipment_idea = $.trim($("#equipment_idea").val());
		if(equipment_idea<=0){
		$.messager.alert("提示","设备物资处意见不能为空!");
			return;
		}
		var equipment_principal = $.trim($("#equipment_principal").val());
		if(equipment_principal<=0){
		$.messager.alert("提示","设备物资处负责人不能为空!");
			return;
		}
/* 		if(($("#skill_parameter").val()==undefined||$("#skill_parameter").val()=='')){
		$.messager.alert("提示","技术参数不能为空!");
			return;
		} */
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
            if (data) {
            	$.messager.progress({title:'请稍后',msg:'数据保存中....'});
    			$("#submitButton").attr({"disabled":"disabled"});
    			document.getElementById("form1").action = "<%=contextPath%>/dmsManager/modelSelection/equipmentSelectionApply.srq";
    			document.getElementById("form1").submit();
            }
        });	
	}
	// skill_parameter__
	//显示已插入的技术参数文件
	function insertFilePublicSkill(name,id){
		$("#file_skill_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' width='25%' align='right'>附件:&nbsp;&nbsp;&nbsp;&nbsp;</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"<td class='inquire_form5' style='width :30%'><span class='sc'><a href='javascript:void(0);' onclick=deleteTeFilePublicOPI(this,\""+id+"\") title='删除'></a></span></td>"+
					"</tr>"
			);
	}
	// 测试使用报告多附件添加
	function testUsingFileDataAdd(status){debugger;
		insertTrPublic_test('file_test_tablePublic');
	}
	
	// 新增插入测试使用报告文件
	function insertTrPublic_test(obj){debugger;
		//var tmp="public";
		var tmp= new Date().getTime();
			$("#"+obj+"").append(
				"<tr id='file_test_public'>"+
					"<td class='inquire_form5' width='25%' align='right'>多附件添加：&nbsp;&nbsp;</td>"+
		  			"<td class='inquire_form5'><input type='file' name='test_content__"+tmp+"' id='test_content__"+tmp+"' onchange='getTestFileInfoPublic(this)' class='input_width'/></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteTestInputPublic(this)'  title='删除'></a></span></td>"+
				"</tr>"
			);
		}
	//显示已插入的测试使用报告文件文件
	function insertFilePublicTest(name,id){
		$("#file_test_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' width='25%' align='right'>附件:&nbsp;&nbsp;&nbsp;&nbsp;</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"<td class='inquire_form5' style='width :30%'><span class='sc'><a href='javascript:void(0);' onclick=deleteTeFilePublicOPI(this,\""+id+"\") title='删除'></a></span></td>"+
					"</tr>"
			);
	}
	//删除附件
	function deleteTeFilePublicOPI(item,id){
		if(confirm('确定要删除吗?')){  
			var tmp= new Date().getTime();
			$(item).parent().parent().parent().empty();
			jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
			flag_public = 1;
		}	
	}
	
	function getTestFileInfoPublic(item){debugger;
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#test_using_report_"+order).val(docTitle);//文件name
		jcdpCallService("EquipmentSelectionApply", "uploadFile", "opi_id="+'<%=opi_id%>');
	}
	//删除行
	function deleteTestInputPublic(item){
		test_using_report = 0;
		$(item).parent().parent().parent().remove();
	 }	
	
	
	
	
	// 应用证明多附件添加
	function userProveFileDataAdd(status){
		insertTrPublic_userProve('userProve_file_tablePublic');
	}
	// 新增插入应用证明报告文件
	function insertTrPublic_userProve(obj){
		//var tmp="public";
		var tmp= new Date().getTime();
			$("#"+obj+"").append(
				"<tr id='file_userProve_public'>"+
					"<td class='inquire_form5' width='25%' align='right'>多附件添加：&nbsp;&nbsp;</td>"+
		  			"<td class='inquire_form5'><input type='file' name='user_prove_content__"+tmp+"' id='user_prove_content__"+tmp+"' onchange='getUserProveFileInfoPublic(this)' class='input_width'/></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteUserProveInputPublic(this)'  title='删除'></a></span></td>"+
				"</tr>"	
			);
		}
	//显示已插入的文件
	function insertFilePublicUser(name,id){
		$("#userProve_file_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' width='25%' align='right'>附件:&nbsp;&nbsp;&nbsp;&nbsp;</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"<td class='inquire_form5' style='width :30%'><span class='sc'><a href='javascript:void(0);' onclick=deletePuFilePublic(this,\""+id+"\") title='删除'></a></span></td>"+
					"</tr>"
			);
	}
	//删除应用证明文件
	function deletePuFilePublic(item,id){
		if(confirm('确定要删除吗?')){  
			var tmp= new Date().getTime();
			$(item).parent().parent().parent().empty();
				jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
				flag_public = 1;
		}	
	}
	function getUserProveFileInfoPublic(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#user_prove_"+order).val(docTitle);//文件name
		
	}
	//删除行
	function deleteUserProveInputPublic(item){
		user_prove = 0;
		$(item).parent().parent().parent().remove();
	 }
	
	
	
	// 生产单位资质多附件添加
	function productionFileDataAdd(status){
		insertTrPublic_production('production_file_tablePublic');
	}
	// 新增插入应用证明报告文件
	function insertTrPublic_production(obj){
		//var tmp="public";
		var tmp= new Date().getTime();
			$("#"+obj+"").append(
				"<tr id='file_production_file_public'>"+
					"<td class='inquire_form5' width='25%' align='right'>多附件添加：&nbsp;&nbsp;</td>"+
		  			"<td class='inquire_form5'><input type='file' name='production_file_content__"+tmp+"' id='production_file_content__"+tmp+"' onchange='getProductionFileInfoPublic(this)' class='input_width'/></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteProductionFilePublic(this)'  title='删除'></a></span></td>"+
				"</tr>"	
			);
		}
	//显示已插入的文件
	function insertFilePublicProduction(name,id){
		$("#production_file_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' width='25%' align='right'>附件:&nbsp;&nbsp;&nbsp;&nbsp;</td>"+
					"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
	      			"<td class='inquire_form5'><span class='sc' style='width :30%'><a href='javascript:void(0);' onclick=deleteTeFilePublicOPI(this,\""+id+"\") title='删除'></a></span></td>"+
					"</tr>"
			);
	}
	//删除应用证明文件
	function deleteProdFilePublic(item,id){
		if(confirm('确定要删除吗?')){  
			var tmp= new Date().getTime();
			$(item).parent().parent().parent().empty();
				jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
				flag_public = 1;
		}	
	}
	function getProductionFileInfoPublic(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#user_prove_"+order).val(docTitle);//文件name
		
	}
	//删除行
	function deleteProductionFilePublic(item){
		production_unit_aptitude = 0;
		$(item).parent().parent().parent().remove();
	 }
	
	
	
	
	
	
	// 其他附件添加
	function otherFileDataAdd(status){
		insertTrPublic_other('other_file_tablePublic');
	}
	// 新增插入应用证明报告文件
	function insertTrPublic_other(obj){
		var tmp=new Date().getTime();
			$("#"+obj+"").append(
				"<tr id='file_other_public'>"+
					"<td class='inquire_form5' width='25%' align='right'>多附件添加：&nbsp;&nbsp;</td>"+
		  			"<td class='inquire_form5'><input type='file' name='other_file_content__"+tmp+"' id='other_file_content__"+tmp+"' onchange='getOtherFileInfoPublic(this)' class='input_width'/></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteOtherFilePublic(this)'  title='删除'></a></span></td>"+
				"</tr>"	
			);
		}
	//显示已插入的文件
	function insertFilePublicOther(name,id){
		$("#other_file_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' width='25%' align='right'>附件:&nbsp;&nbsp;&nbsp;&nbsp;</td>"+
					"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
	      			"<td class='inquire_form5'><span class='sc' style='width :30%'><a href='javascript:void(0);' onclick=deleteTeFilePublicOPI(this,\""+id+"\") title='删除'></a></span></td>"+
					"</tr>"
			);
	}
	//删除其他文件
	function deleteOtherPublic(item,id){
		if(confirm('确定要删除吗?')){  
			var tmp= new Date().getTime();
			$(item).parent().parent().parent().empty();
				jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
				other = 1;
		}	
	}
	function getOtherFileInfoPublic(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#other_"+order).val(docTitle);//文件name
		
	}
	//删除行
	function deleteOtherFilePublic(item){
		other = 0;
		$(item).parent().parent().parent().remove();
	 }
	
	
	// 附件(评审证明)
	function reviewConfirmsFileDataAdd(status){  
		insertTrPublic_reviewConfirms('reviewConfirms_file_tablePublic');
	}
	// 评审信息多附件添加
	function reviewConfirmsFileData(status){
		insertTrPublic_New('review_tablePublic');
	}
	 
	// 新增插入评审信息报告文件
	function insertTrPublic_New(obj){
		var tmp= new Date().getTime();
			$("#"+obj+"").append(
				"<tr id='review_test_public'>"+
				"<td class='inquire_form5' width='25%' align='right'>多附件添加：&nbsp;&nbsp;</td>"+
		  			"<td class='inquire_form5'><input type='file' name='review_content__"+tmp+"' id='review_content__"+tmp+"' onchange='getTestFileInfoPublic(this)' class='input_width'/></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteTestInputPublic(this)'  title='删除'></a></span></td>"+
				"</tr>"
			);
		}
	//显示已插入的评审信息文件文件
	function insertFilePublicNew(name,id){
		$("#review_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' width='25%' align='right'>附件:&nbsp;&nbsp;&nbsp;&nbsp;</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"<td class='inquire_form5' style='width :30%'><span class='sc'><a href='javascript:void(0);' onclick=deleteTeFilePublicOPI(this,\""+id+"\") title='删除'></a></span></td>"+
					"</tr>"
			);
	}	
	// 新增插入 附件(评审证明)文件
	function insertTrPublic_reviewConfirms(obj){
		var tmp=new Date().getTime();
			$("#"+obj+"").append(
				"<tr id='reviewConfirms_file_public'>"+
					"<td class='inquire_form5' width='25%' align='right'>多附件添加：&nbsp;&nbsp;</td>"+
		  			"<td class='inquire_form5'><input type='file' name='review_confirms_file_content__"+tmp+"' id='review_confirms_file_content__"+tmp+"' onchange='getreviewConfirmsFileInfoPublic(this)' class='input_width'/></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteConfirmsFilePublic(this)'  title='删除'></a></span></td>"+
				"</tr>"	
			);
		}
		
	
	//显示已插入的文件
	function insertFilePublicReview(name,id){
		$("#reviewConfirms_file_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' width='25%' align='right'>附件:&nbsp;&nbsp;&nbsp;&nbsp;</td>"+
					"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
	      			"<td class='inquire_form5'><span class='sc' style='width :30%'><a href='javascript:void(0);' onclick=deleteTeFilePublicOPI(this,\""+id+"\") title='删除'></a></span></td>"+
					"</tr>"
			);
	}
	//删除 附件(评审证明)文件
	function deleteReviewConfirmsFilePublic(item,id){
		if(confirm('确定要删除吗?')){  
			$(item).parent().parent().parent().empty();
			var tmp=new Date().getTime();
				jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
				review_confirms = 1;
		}	
	}
	function getreviewConfirmsFileInfoPublic(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#Confirms_file_content_"+order).val(docTitle);//文件name
		
	}
	//删除行
	function deleteConfirmsFilePublic(item){
		review_confirms = 0;
		$(item).parent().parent().parent().remove();
	 }
	
</script>
</html>

