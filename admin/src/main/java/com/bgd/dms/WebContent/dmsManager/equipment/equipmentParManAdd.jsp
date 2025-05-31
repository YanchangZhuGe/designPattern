<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="java.util.Date"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String appDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
	String equipment_id = request.getParameter("equipment_id");
	String id = request.getParameter("id");
	String pid = request.getParameter("pid");
	String flag=request.getParameter("flag");
	String equipment_ids = request.getParameter("equipment_ids");
	if(null==flag){
		flag="add";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>勘探设备名录增加</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData('<%=id%>'),loadDataDetail('<%=equipment_id%>');">
<form name="form1" id="form1" method="post" action="" enctype="multipart/form-data" >
	<div id="new_table_box">
	<div id="new_table_box_content">
	<div id="new_table_box_bg">
	 <fieldset style="margin:2px;padding:2px;"><legend>勘探设备名录增加</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
       <tr style="text-align: left">
		  <td class="inquire_item6">&nbsp;设备名称：</td>
		  <td class="inquire_form6"><input name ="equipment_name" id="equipment_name" class="input_width easyui-validatebox main" type="text" value="" data-options="validType:'length[0,50]'" maxlength="50" required/></td>
		  <td class="inquire_item6">&nbsp;设备型号：</td>
		  <td class="inquire_form6"><input name="equipment_model" id="equipment_model" class="input_width easyui-validatebox main" type="text" value="" data-options="validType:'length[0,50]'" maxlength="50" required/></td>
	  </tr>
	  <tr>
		  <td class="inquire_item6">&nbsp;设备编码：</td>
		  <td class="inquire_form6"><input name="equipment_code" id="equipment_code" class="input_width easyui-validatebox main" type="text" value="" data-options="validType:'length[0,50]'" maxlength="50" required /></td>
		  <td class="inquire_item6">&nbsp;生产厂家：</td>
		 <td class="inquire_form6"><input name="manufacturer" id="manufacturer" class="input_width easyui-validatebox main" type="text" value="" data-options="validType:'length[0,50]'" maxlength="50" required/></td>
	  </tr>  
	   <tr>
		  <td style="height: 40px;" class="inquire_item6">&nbsp;备注：</td>
		  <td colspan="3" class="inquire_form6"><textarea id="bak" name="bak"  class="easyui-textarea easyui-validatebox main" style="height:40px; width: 50%"data-options="validType:'length[0,250]'" maxlength="250" required onpropertychange="checkLength(this,250);" oninput="checkLength(this,250);"></textarea></td>
	  </tr>
   	   <tr id="file_tr_public">
			<td class="inquire_item4">&nbsp;附件：</td>
  			<td class="inquire_form4" colspan="1"><input type="file" name='skill_parameter__' id='skill_parameter__' class="input_width" style="width: 100%"/></td>
		 </tr>
		 <tr>
		   <td colspan="3">
			 <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="file_skill_tablePublic">
				<input name="skill_parameter_report" id="skill_parameter_report" type="hidden" />
			 </table>
		   </td>
		 </tr>
    </table>
    <fieldset style="margin:2px;padding:2px;">
       <h5 align="center"><font size="15px" style="text-align: center; font-size: 15px">设备参数</font></h5>
    	 <table  style="table-layout:fixed;text-align:center;" width="100%" border="0" cellspacing="0" cellpadding="0"class="tab_info" id="itemTable">
			<tr>
				<td width="10%">序号</td>
				<td width="1%"><input type="hidden"/></td>
				<td width="20%">参数名称</td>
				<td width="69%">参数</td>
			</tr>
		</table>
      </fieldset>
		<div id="oper_div" style="text-align: right">
	     	<span class="bc_btn"><a href="#" id="submitButton" onclick="saveInfo()"></a></span>
	        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
   		</div>	
   	</fieldSet>
   </div>
 </div>
</div>
</form>
</body>
<script type="text/javascript">
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var addedseqinfo;
	var review_confirms =0;
	var flag_public = 0;
	var flag="<%=flag%>";
	
	function checkLength(obj,maxlength){
	    if(obj.value.length > maxlength){
	        obj.value = obj.value.substring(0,maxlength);
	    }
	}

	var order = 0;
	function insertTr(old){
		order++;
		var temp = "";
		if(old=="old"){
			temp +="<tr id='tr_"+order+"' class='old' tempindex='"+order+"'>";
		}else{
			temp +="<tr id='tr_"+order+"' class='new' tempindex='"+order+"'>";
		}
		temp =temp + ("<td><input name='whole_"+order+"' id='whole_"+order+"' value='000' type='hidden'/>"+
		"<td align='right'>"+order+"</td> "+
		"<td><input name='parameter_name_"+order+"' id='parameter_name_"+order+"' type='text' style='height:20px;width:90%;' />"+
		"<input name='parameter_ids_"+order+"' id='parameter_ids_"+order+"' type='hidden' /></td>"+
		"<td colspan='3' ><input id='parameter_"+order+"' name='parameter_"+order+"' class='input_width easyui-validatebox main' type='text' value='' style='width: 80%' align='center' title='参数' data-options=\"validType:'length[0,50]'\" maxlength='50' required></td>"+
		"</tr>");
		$("#itemTable").append(temp);
		return order; 
	}
	
	$().ready(function(){
		//第一次进入页面移除验证提示
		$('.validatebox-text').removeClass('validatebox-invalid');
	});
	function refreshData(id){
		var baseData;
		if(id != "null"){
		baseData = jcdpCallService("EquipmentParMan", "getDevicePara", "current_device_type_id="+id); 
		if(typeof baseData.deviceappMap!="undefined"){
			var datas = baseData.deviceappMap;
			for(var i=0;i<datas.length;i++){
				var ts=insertTr("old");
				var data=datas[i];
				$.each(data, function(k, v){
					if(null!=v && ""!=v){
						$("#itemTable #"+k+"_"+ts).val(v);
					}
				});
			}
			orader=datas.length;
		}
		}
	}
	
	function loadDataDetail(equipment_id){
	var baseData;
	if(equipment_id != null &&"update"==flag){
		baseData = jcdpCallService("EquipmentParMan", "getExplorationType", "equipment_id="+equipment_id); 
		
	  //给数据回填
		$("#equipment_name").val(baseData.str.equipment_name);
		$("#equipment_model").val(baseData.str.equipment_model);
		$("#equipment_code").val(baseData.str.equipment_code);
		$("#manufacturer").val(baseData.str.manufacturer);
		$("#bak").val(baseData.str.bak);
		
		if(baseData.fdataPublic!=null){ 
			// 有附件不显示设备详情而是显示附件
			for (var tr_id = 1; tr_id<=baseData.fdataPublic.length; tr_id++) {
				if(baseData.fdataPublic[tr_id-1].file_type =="skill_parameter"){
					insertFilePublicSkill(baseData.fdataPublic[tr_id-1].file_name,baseData.fdataPublic[tr_id-1].file_id);
					flag_public=1;
				}
			}
		}
		if(typeof baseData.deviceappMap!="undefined"){
			var datas = baseData.deviceappMap;
			for(var i=0;i<datas.length;i++){
				var ts=insertTr("old");
				var data=datas[i];
				$.each(data, function(k, v){
					if(null!=v && ""!=v){
						$("#itemTable #"+k+"_"+ts).val(v);
					}
				});
			}
			order=datas.length;
		}
  	 }
	}
	
	//显示已插入的附件
	function insertFilePublicSkill(name,id){
		$("#file_skill_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' style='width :25%'>附件:</td>"+
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
	
	function saveInfo(){
		var pid ="<%=pid%>";
		var id ="<%=id%>";
		var equipment_id ="<%=equipment_id%>";
		var equipment_ids ="<%=equipment_ids%>";
		var equipment_name = $.trim($("#equipment_name").val());
		if(equipment_name.length<=0){
			$.messager.alert("提示","设备名称不能为空!");
			return;
		}	 
		var equipment_model = $.trim($("#equipment_model").val());
		if(equipment_model<=0){
		$.messager.alert("提示","设备型号不能为空!");
			return;
		}
		var equipment_code = $.trim($("#equipment_code").val());
		if(equipment_code<=0){
		$.messager.alert("提示","设备编码不能为空!");
			return;
		}
		
		var manufacturer = $.trim($("#manufacturer").val());
		if(manufacturer<=0){
		$.messager.alert("提示","生产厂家不能为空!");
			return;
		}
		var bak = $.trim($("#bak").val());
		if(bak<=0){
		$.messager.alert("提示","备注不能为空!");
			return;
		}
		
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
            if (data) {
            	$.messager.progress({title:'请稍后',msg:'数据保存中....'});
    			$("#submitButton").attr({"disabled":"disabled"});
    			document.getElementById("form1").action = "<%=contextPath%>/dmsManager/modelSelection/equipmentList.srq?flag="+flag+"&pid="+pid+"&id="+id+"&equipment_ids="+equipment_ids+"&equipment_id="+equipment_id;
    			document.getElementById("form1").submit();
            }
        });	
	}
	
</script>
</html>

