<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	//String inspection_id=request.getParameter("inspection_id");
	//String dev_appdet_id = request.getParameter("ids");	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<%@include file="/common/include/quotesresource.jsp"%>
  <title>设备检查</title> 
 </head>
<body style="background:#cdddef">
<form name="form1" id="form1" method="post" enctype="multipart/form-data" action="">
<div id="new_table_box" >
  <div id="new_table_box_content">
    <div id="new_table_box_bg" >
      <fieldset><legend>设备信息</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  <tr>
					    
			<td class="inquire_item6">设备名称</td>
			<td class="inquire_form6">
				<input id="dev_name" name="dev_name" class="input_width"  type="text" readonly/>
				<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showDevAccountPage()"  />
				<input id="fk_dev_acc_id" name="fk_dev_acc_id" type ="hidden" />
			</td>
			<td class="inquire_item6">规格型号</td>
			<td class="inquire_form6"><input id="dev_model" name="dev_model"  class="input_width" type="text" readonly/></td>
		  </tr>
		  <tr>
			<td class="inquire_item6">自编号</td>
			<td class="inquire_form6">
				<input id="self_num" name="self_num"  class="input_width" type="text" readonly/>
			
			</td>
			<td class="inquire_item6">牌照号</td>
			<td class="inquire_form6"><input name="license_num" id="license_num"  class="input_width" type="text" readonly /></td>
		  </tr>
		   <tr>
			<td class="inquire_item6">ERP设备编号</td>
			<td class="inquire_form6">
				<input id="dev_coding" name="dev_coding"  class="input_width" type="text" readonly/>
			</td>
		  </tr>
		  </table>
	  </fieldset>
      <fieldset><legend>设备检查</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>
			<td class="inquire_item6">检查类型</td>
			<td class="inquire_form6">
			<code:codeSelect  cssClass="select_width"   name='INSPECTION_TYPE' option="INSPECTION_TYPE" selectedValue=""  addAll="true" />
			</td>			
		  </tr>
		  <tr>
		  	<td class="inquire_item6">检查人</td>
			<td class="inquire_form6"><input name="INSPECTOR" id="INSPECTOR" value="<%=user.getUserName()%>"  class="input_width" type="text"  /></td>
			<td class="inquire_item6">检查日期</td>
			<td class="inquire_form6">
				<input type="text" name="INSPECTION_DATE" id="INSPECTION_DATE" class="input_width easyui-datebox" style="width:130px" editable="false" required/>
			</td>
		  </tr>
		  
		  <tr>
		  	<td class="inquire_item6">检查内容</td>
			<td class="inquire_form6" colspan="3">
			<textarea rows="2" cols="59" id="INSPECTION_CONTENT" name="INSPECTION_CONTENT" class="textarea" style="height:50px"></textarea>
		
			</td>
		  </tr>
		  <tr>
		    <td class="inquire_item6">附件:</td>
		    <td class="inquire_item6" colspan="3"><input type="file" name="apply_file" id="apply_file" value="" class="input_width" />
		    <input type="hidden" id="file_name" name="file_name" value=""/></td>
		</tr>
	  </table>
	  
	  </fieldset>
	  <fieldset><legend>整改信息</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  <tr>
		  	<td class="inquire_item6">整改期限</td>
			<td class="inquire_form6"><input name="RECTIFICATION_PERIOD" id="RECTIFICATION_PERIOD"  class="input_width" type="text"  /></td>
			<td class="inquire_item6">责任人</td>
			<td class="inquire_form6">
				<input id="CHARGE_PERSON" name="CHARGE_PERSON"  class="input_width" type="text" />
			</td>
		  </tr>
		  <tr>
		  	<td class="inquire_item6">是否合格</td>
			<td class="inquire_form6">
				<select id="SPARE1" name="SPARE1" class="select_width">
					<option value="">--请选择--</option>
					<option value="1">是</option>
					<option value="0">否</option>
				</select>
			</td>
		  </tr>
		<tr>
			<td class="inquire_item6">整改问题</td>
			<td class="inquire_form6" colspan="3">
				<textarea rows="2" cols="59" id="INSPECTION_RESULT" name="INSPECTION_RESULT" class="textarea" style="height:50px"></textarea>
			</td>
		  </tr>
	 </table>
	  </fieldset>
	  <fieldset><legend>整改情况检查</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  <tr>
		  	<td class="inquire_item6">检查日期</td>
			<td class="inquire_form6">
				<input type="text" name="RECTIFY_DATE" id="RECTIFY_DATE" class="input_width easyui-datebox" style="width:130px" editable="false" required/>
			</td>
			<td class="inquire_item6">检查人</td>
			<td class="inquire_form6">
				<input id="RECTIFY_PERSON" name="RECTIFY_PERSON"  class="input_width" type="text" />
			</td>
		  </tr>
		  <tr>
		  	<td class="inquire_item6">整改结果</td>
			<td class="inquire_form6" colspan="3">
			<textarea rows="2" cols="59" id="RECTIFY_CONTENT" name="RECTIFY_CONTENT" class="textarea" style="height:50px"></textarea>
		
			</td>
		  </tr>
	 </table>
	  </fieldset>
	</div>
			  <div id="oper_div" style="margin-bottom:5px">
			 	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
			    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			  </div>
    </div>
    
</div>
</form>
</body>
<script type="text/javascript"> 
<%-- 	var dev_appdet_id='<%=dev_appdet_id%>'; --%>
<%-- 	var inspection_id='<%=inspection_id%>'; --%>
	function showNewInfo(){
		$("#device_mix_id").val("");
		$("#in_org_name").val($("#in_org_name_info").val());
		$("#in_org_id").val($("#in_org_id_info").val());
		$("#modify_table").show();
	}
	
	$().ready(function(){
		//第一次进入页面移除验证提示
		$('.validatebox-text').removeClass('validatebox-invalid');
	})
	
	function submitInfo(){
		if(confirm("提交后数据不能修改，确认提交？")){
			//调配数量提交
			var obj = document.getElementById("apply_file");
			var value = obj.value ;
			if(obj ==null || value==''){
			}else{
				var start = value.lastIndexOf('\\');
				var end = value.lastIndexOf('.');
				value = value.substring(start+1,end);
				document.getElementById("file_name").value = value;
			}
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/bgpCommDeviceInspection.srq?state=9";
			document.getElementById("form1").submit();
		}
	}

	function showDevAccountPage(){
		var returnValue = window.showModalDialog("<%=contextPath%>/dmsManager/safekeeping/selectBYAccount.jsp","","dialogWidth=1200px;dialogHeight=480px");			
		var strs= new Array(); //定义一数组
		if(!returnValue){
			return;
		}
		strs = returnValue.split("@");
		loadDataDetail(strs[0]);
	}

	function loadDataDetail(devAccId){
// 		if(inspection_id=="null"){
			var querySql="select dev_acc_id, dev_name,dev_model,dev_coding,dev_sign,self_num,license_num,asset_coding,owning_org_name,usage_org_name,dev_position,using_stat,tech_stat,asset_value,net_value,case account_stat when '0' then '账内' when '1' then '账外' else '外租' end as stat_desc from GMS_DEVICE_ACCOUNT b where dev_acc_id='"+devAccId+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
			$("#dev_name")[0].value=basedatas[0].dev_name;
			$("#dev_model")[0].value=basedatas[0].dev_model;
			$("#self_num")[0].value=basedatas[0].self_num;
			$("#license_num")[0].value=basedatas[0].license_num;
			$("#dev_coding")[0].value=basedatas[0].dev_coding;
			$("#fk_dev_acc_id")[0].value=devAccId;
// 		}else{
// 			var querySql="select a.*,b.dev_name,b.dev_model,b.self_num,b.license_num,c.PROJECT_NAME,b.owning_org_name,b.usage_org_name,b.using_stat,b.tech_stat from BGP_COMM_DEVICE_INSPECTION a left join GMS_DEVICE_ACCOUNT_DUI b on a.DEVICE_ACCOUNT_ID=b.dev_acc_id left join gp_task_project c on b.PROJECT_INFO_ID=c.project_info_no  where a.inspection_id='"+inspection_id+"'" ;
<%-- 			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);  --%>
// 			basedatas = queryRet.datas;
// 			$("#dev_name")[0].value=basedatas[0].dev_name;
// 			$("#dev_model")[0].value=basedatas[0].dev_model;
// 			$("#self_num")[0].value=basedatas[0].self_num;
// 			$("#license_num")[0].value=basedatas[0].license_num;
// 			$("#PROJECT_NAME")[0].value=basedatas[0].project_name;
// 			$("#INSPECTION_TYPE").val(basedatas[0].inspection_type);
// 			$("#RECTIFICATION_PERIOD")[0].value=basedatas[0].rectification_period;
// 			$("#CHARGE_PERSON")[0].value=basedatas[0].charge_person;
// 			$("#INSPECTOR")[0].value=basedatas[0].inspector;
// 			$("#INSPECTION_DATE")[0].value=basedatas[0].inspection_date;
// 			$("#SPARE1")[0].value=basedatas[0].spare1;
// 			$("#INSPECTION_CONTENT")[0].value=basedatas[0].inspection_content;
// 			$("#INSPECTION_RESULT")[0].value=basedatas[0].inspection_result;
			
// 			$("#RECTIFY_DATE")[0].value=basedatas[0].rectify_date;
// 			$("#RECTIFY_PERSON")[0].value=basedatas[0].rectify_person;
// 			$("#RECTIFY_CONTENT")[0].value=basedatas[0].rectify_content;
//		}
			
	}
</script>
</html>
 