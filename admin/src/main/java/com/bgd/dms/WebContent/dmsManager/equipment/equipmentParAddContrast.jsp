<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%
	String contextPath = request.getContextPath();
	String ids = request.getParameter("ids");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String appDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>设备参数对比</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData('<%=ids %>'),ladeRefreshData('<%=ids %>');">
<form name="form1" id="form1" method="post" action="">
	<div id="new_table_box" style="width: 98%">
 	<div id="new_table_box_content" style="width: 98%">
 	<div id="new_table_box_bg" style="width: 95%">
 	<div id="list_table">
	<div id="table_box">
      <fieldset style="margin:2px;padding:2px;"><legend></legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
       
       <tr align="left">
          <td class="ali_cdn_name">&nbsp;参数列表:</td>
          	<td class="inquire_form6"><input name="province" class="input_width" id="province" style="width: 174px;" /></td>         
			<td>
				<span class="cx" ><a href="####" title="检索" onclick="searchDevData()"></a></span>
				 <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			</td>
        </tr>
       </table>
       <hr></hr>
        <table style="width:100%" border="1" cellspacing="0" cellpadding="0" class="tab_line_height" align="center">
       	  <tr align="center">
       		<td width="35%" colspan="3">设备名称:</td>
       		<td><input name="qian" id="qian" style="text-align: center ;border:none;" class="input_width" type="text" value="" disabled="disabled"/></td>
       		<td><input name="hou" id="hou" style="text-align: center;border:none;" class="input_width" type="text" value="" disabled="disabled"/></td>
       	  </tr>
        <tr><td align="center" colspan="5"> 设备参数 </td></tr>
        </table>
         <table  style="table-layout:fixed;text-align:center;" width="100%" border="1" cellspacing="0" cellpadding="0"class="tab_info" id="itemTable">
			<tr>
				<!-- <td>序号</td> -->
				<td>参数名称</td>
				<td>参数</td>
				<td>参数</td>
			</tr>
		</table>
		<table style="table-layout:fixed;text-align:center;" width="100%" border="1" cellspacing="0" cellpadding="0"class="tab_info" id="itemTable2">
			
		</table>
	   </fieldset>
	   </div>
	   </div>
	   </div>
       <div align="right">	
	        <span class="gb_btn" style="text-align: right;"><a href="####" onclick="newClose()"></a></span>
    	</div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryService = "ModelApply";
	cruConfig.queryOp = "queryParContrast";
	var addedseqinfo;
	var ids = "<%=ids%>";
	$().ready(function(){
		//第一次进入页面移除验证提示
		$('.validatebox-text').removeClass('validatebox-invalid');
	});
	// 检索
	function searchDevData(){
		var equipment_name =  $("#province").combobox("getText");
		
		ladeRefreshData(ids,equipment_name);
	} 
	// 清空
	function clearQueryText(){
		//$("#province").clear
		$("#province").combobox("setText","");
		var equipment_name =  $("#province").combobox("getText");
		ladeRefreshData(ids,equipment_name);
	}
	function refreshData(ids){
	// 下拉框选择控件，下拉框的内容是动态查询数据库信息
 	$('#province').combobox({
		url:'<%=contextPath%>/dmsManager/modelSelection/toGetJsonDevList.srq?equipment_id='+ids,
		editable:false, //不可编辑状态
		valueField:'code',   
		textField:'note',
		value:'全部',
     });
 	retObj = jcdpCallService("EquipmentParMan", "getParameterList", "equipment_id="+ids);
 	$("#qian").val(retObj.deviceappMap[0].equipment_name);
	$("#hou").val(retObj.deviceappMap[1].equipment_name);
	
	}
		
	function ladeRefreshData(ids,equipment_name){
		//先清空
		var filtermapid = "#itemTable2";
		$(filtermapid).empty();
		var baseData ;
		baseData = jcdpCallService("EquipmentParMan", "queryParContrast", "ids="+ids+"&equipment_name=" + equipment_name); 
		var mes = baseData.deviceappMap;//返回列表
		var mes1 = baseData.deviceappMap1;//设备
		var mes2 = baseData.deviceappMap2;//参数列表
		var innerhtml = "";
		for(var i=0;i<mes2.length;i++){
		
		innerhtml += "<tr><td>"+mes2[i].parameter_name+"</td>";
			for(var j=0;j<mes.length;j++){
				 if(mes2[i].parameter_id == mes[j].parameter_id){
						innerhtml += "<td>"+mes[j].parameter+"</td>";
				  }
				}
			}
		innerhtml += "</tr>";
		 $("#itemTable2").append(innerhtml);
		}
</script>
</html>

