<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String projectType = user.getProjectType();
	String org_id = user.getOrgId();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<script type="text/javascript" src="<%=contextPath %>/js/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.dialog.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
</head>
<body onload=''>
<form name="form1" id="form1" method="post"
	action="">
<div id="new_table_box">
<div id="new_table_box_content">
<div id="new_table_box_bg">
<table border="0" cellpadding="0" cellspacing="0"
	class="tab_line_height" width="100%">
	<input type='hidden' name='selectWzId' id='selectWzId'/>
	<tr>
    	<td colspan="6" align="center">物资入库</td>
    </tr>
	<tr>
		<td class="inquire_item6"><font color="red">*</font>验收日期：</td>
		<td class="inquire_form6"><input type="text"
			name="input_date" id="input_date" class="input_width"
			value="" readonly />
			<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(input_date,tributton1);" /></td>
		<td class="inquire_item6">经办人：</td>
		<td class="inquire_form6"><input type="text" name="operator" id="operator"
			class="input_width" value="" /></td>
		<td class="inquire_item6">提货人：</td>
		<td class="inquire_form6"><input type="text" name="pickupgoods" id="pickupgoods"
			class="input_width"
			value="" /></td>
	</tr>
	<tr>
		<td class="inquire_item6">保管人：</td>
		<td class="inquire_form6"><input type="text" name="storage" id="storage" 
			class="input_width" value="" /></td>
		<td class="inquire_item6">备注：</td>
		<td class="inquire_form6"><input type="text" name="note" id="note"
			class="input_width"
			value="" /></td>
		<td class="inquire_item6">金额：</td>
		<td class="inquire_form6"><input type="text" name="total_money" id="total_money"
			class="input_width"
			value="" /></td>
	</tr>
	<tr>
		<td class="inquire_item6">物资来源：</td>
		<td class="inquire_form6">
			<select id="wz_from" name="wz_from" class="select_width">
	 	    	<option value="1">大港分中心</option>
	 	    	<option value="2">转入</option>
			</select>
		</td>
		<td class="inquire_item6"></td>
		<td class="inquire_item6"></td>
		<td class="inquire_item6"></td>
		<td align="right">
		   		<input type="button" value="物资验收" onclick="openMatHave()"/>
		   		<input type="button" value="删除" onclick="deleteMatHave()"/>
		   	</td>
	</tr>
</table>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right" id="queryRetTable">
			<tr>
				<td class="bt_info_even" exp="<input name = 'rdo_entity_id'  type='checkbox'  value='{wz_id},{plan_flat_id}' checked = 'true' onclick='loadDataDetail()'/>" ><input type='checkbox' name='rdo_entity_id' value='' onclick='check()'/></td>
				<td class="bt_info_odd" autoOrder="1">序号</td>
				<td class="bt_info_even" exp="{wz_id}">物资编码</td>
				<td class="bt_info_odd" exp="{wz_name}">物资名称</td>
				<td class="bt_info_even" exp="{wz_prickie}">计量单位</td>
				<td class="bt_info_odd" exp="{demand_num}">计划数量</td>
				<td class="bt_info_even" exp="{mat_num}">已入库数量</td>
				<td class="bt_info_odd" exp="<input type='text' name='actual_price_{wz_id}' id='actual_price_{wz_id}' value='{wz_price}'  style='width:40px'/>">入库单价</td>
				<td class="bt_info_even"	exp="<input type='text' name='mat_num_{wz_id}' id='mat_num_{wz_id}' value='{in_num}'  style='width:40px' onkeyup='keyup()'/>">入库数量</td>
				<td class="bt_info_odd"exp="<input type='text' name='total_money_{wz_id}' id='total_money_{wz_id}' value=''  style='width:40px' readonly='readonly'/>">入库金额</td>
				<td class="bt_info_even"	exp="<input type='text' name='warehouse_number_{wz_id}' id='warehouse_number_{wz_id}' value=''  style='width:40px'/>">收料库</td>
				<td class="bt_info_odd" exp="<input type='text' name='goods_allocation_{wz_id}' id='goods_allocation_{wz_id}' value=''  style='width:40px'/>">货位</td>
			</tr>
		</table>
	</div>
	<table id="fenye_box_table">
	</table>
</div>
		
<div id="oper_div"><span class="bc_btn"><a href="#"
	onclick="save()"></a></span> <span class="gb_btn"><a href="#"
	onclick="newClose()"></a></span></div>
</div>
</div>
<div id="dialog-modal" title="正在执行" style="display:none;">
	请不要关闭
</div>
</form>
</body>
<script type="text/javascript">
function frameSize(){
//	$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-40);
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
</script>
<script type="text/javascript"><!--
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	var projectType = "<%=projectType %>";
	var checked = false;
  	function check(){
		var chk = document.getElementsByName("rdo_entity_id");
		for(var i = 0; i < chk.length; i++){ 
			if(!checked){ 
				chk[i].checked = true; 
			}
			else{
				chk[i].checked = false;
			}
		} 
		if(checked){
			checked = false;
		}
		else{
			checked = true;
		}
	}
	function refreshData(wz_from){
		cruConfig.queryService = "MatItemSrv";
		cruConfig.queryOp = "getAcceptListDg";
		queryData(1);
		
		var tab =document.getElementById("queryRetTable");
		var row = tab.rows;
		for(var i=1;i<row.length;i++){
			var cell_0 = row[i].cells[0].firstChild.checked;
			if(cell_0 == true){
				if(wz_from!=null&&(wz_from=="C6000000000039"||wz_from=="C6000000000040"||wz_from=="C6000000005275"||wz_from=="C6000000005277"||wz_from=="C6000000005278"||wz_from=="C6000000005279"||wz_from=="C6000000005280")){
						row[i].cells[8].firstChild.readOnly = true;
				}
			}
		}
	}					
	
	function openMatHave(){
		var selectWzId = document.getElementById("selectWzId").value;
		var wz_from = document.getElementById("wz_from").value;
		var selected = window.showModalDialog("<%=contextPath%>/mat/singleproject/warehouseDg/accept/selfacceptNew/selectAcceptList.jsp?selectWzId="+selectWzId+"&wz_from="+wz_from,"","dialogWidth=1240px;dialogHeight=480px");
		var wz_id = selected;
		document.getElementById("selectWzId").value = wz_id;
		cruConfig.submitStr ="wz_ids="+wz_id+"&wz_from="+wz_from;
		if(selected!=null&&selected!=""){
			refreshData(wz_from);
		}
	}
	
	function deleteMatHave(){
		ids = getSelIds('rdo_entity_id');
   	  	if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
   	 	var tab=document.getElementById("queryRetTable");//最好给table指定个id
	   // for(var i=0;i<tab.rows.length;i++) {
    	var obj=document.getElementsByName("rdo_entity_id");
    	var length = obj.length;
    	
    	if(obj!=null ){
    		for(var j=length-1; j>=0;j--){
		    	var rdo = obj[j];
		    	if(rdo!=null && rdo.checked==true) {//你没说需求我就直接将第一行中有checkbox且为true的删除
		            tab.deleteRow(j);
	            }
	    	}
    	}
		var newIds = getSelIds2('rdo_entity_id');
		var wz_ids = "";
		var wz_from = document.getElementById("wz_from").value;
		if(newIds!=""){
			var temp = newIds.split(",");
			for(var i=0;i<temp.length;i=i+2){
				if(wz_ids!=""){
					wz_ids += ","; 
				}
				if(wz_from!=null&&(wz_from=="C6000000000039"||wz_from=="C6000000000040"||wz_from=="C6000000005275"||wz_from=="C6000000005277"||wz_from=="C6000000005278"||wz_from=="C6000000005279"||wz_from=="C6000000005280")){
					wz_ids += "'"+temp[i+1]+"'";
				}else{
					wz_ids += "'"+temp[i]+"'";
				}
			}
		}
		//重新刷新列表页面
		document.getElementById("selectWzId").value = wz_ids;
		if(wz_ids!=null&&wz_ids!=""){
			cruConfig.submitStr ="wz_ids="+wz_ids+"&wz_from="+wz_from;
			refreshData();
		}
	}
   	 	
	function getSelIds2(inputName){
		var checkboxes = document.getElementsByName(inputName);
		
		var ids = "";
		for(var i=0;i<checkboxes.length;i++){
			var chx = checkboxes[i];
			if(ids!="") ids += ",";
			ids += chx.value;
		}
		return ids;
	}	
	
	
	
	function save(){	
		//if (!checkForm()) return;
		ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				alert("请选择一条记录!");
				return;
			}
		var input_date = document.getElementById("input_date").value;	
		if(input_date==""){
			alert("验收日期不能为空!");
			return;
		}
		if(loadDataDetail()){
			openMask();
			document.getElementById("form1").action="<%=contextPath%>/mat/singleproject/warehouse/accept/selfaccept/saveAcceptLedgerDg.srq?id="+ids;
			document.getElementById("form1").submit();
		}
	}
	 function openMask(){
			$( "#dialog-modal" ).dialog({
				height: 140,
				modal: true,
				draggable: false
			});
		}
	 
	 
	function keyup(){
		//alert("123456");
		
		var tab =document.getElementById("queryRetTable");
		var outNum=0;
		var wzPrice=0;
		var totalMoney=0;
		var row = tab.rows;
		for(var i=1;i<row.length;i++){
			var cell_5 = row[i].cells[5].innerHTML;
			var cell_6 = row[i].cells[6].innerHTML;
			var cell_7 = row[i].cells[7].firstChild.value;
			var cell_8 = row[i].cells[8].firstChild.value;
			var cell_0 = row[i].cells[0].firstChild.checked;
			debugger;
			if(cell_0 == true){
				if(cell_7!=undefined && cell_8!=undefined &&cell_6!=undefined){
					
						if(cell_8==""){
							outNum=0;
							}
						else{
							outNum=cell_8;
							}
						
						if(cell_7==""){
							wzPrice=0;
							}
						else{
							wzPrice=cell_7;
							}
						if(cell_5==""){
							cell_5=0;
							}
						if(cell_6==""){
							cell_6=0;
							}
					if(cell_5<(cell_6-(-outNum))){
						alert("第"+i+"行入库量已大于计划量！");
						return;
						}
					row[i].cells[9].firstChild.value=Math.round((outNum*wzPrice)*1000)/1000;
					totalMoney+=Math.round((outNum*wzPrice)*1000)/1000;
				}
			}
		}
		document.getElementById("total_money").value=Math.round(totalMoney*1000)/1000;
	}
	 
	 function loadDataDetail(shuaId){
		 
			var tab =document.getElementById("queryRetTable");
			var outNum=0;
			var wzPrice=0;
			var totalMoney=0;
			var row = tab.rows;
			var flag = true;
			for(var i=1;i<row.length;i++){
				var cell_5 = row[i].cells[5].innerHTML;
				var cell_6 = row[i].cells[6].innerHTML;
				var cell_7 = row[i].cells[7].firstChild.value;
				var cell_8 = row[i].cells[8].firstChild.value;
				var cell_0 = row[i].cells[0].firstChild.checked;
				if(cell_0 == true){
					var wz_from = document.getElementById("wz_from").value;
					if(wz_from!=null&&(wz_from=="C6000000000039"||wz_from=="C6000000000040"||wz_from=="C6000000005275"||wz_from=="C6000000005277"||wz_from=="C6000000005278"||wz_from=="C6000000005279"||wz_from=="C6000000005280")){
							var plan_flat_id = row[i].cells[0].firstChild.value.split(",")[1];
							row[i].cells[7].firstChild.id = "actual_price_"+plan_flat_id;
							row[i].cells[7].firstChild.name = "actual_price_"+plan_flat_id;
							row[i].cells[8].firstChild.id = "mat_num_"+plan_flat_id;
							row[i].cells[8].firstChild.name = "mat_num_"+plan_flat_id;
							row[i].cells[8].firstChild.readOnly = true;
							row[i].cells[9].firstChild.id = "total_money_"+plan_flat_id;
							row[i].cells[9].firstChild.name = "total_money_"+plan_flat_id;
							row[i].cells[10].firstChild.id = "warehouse_number_"+plan_flat_id;
							row[i].cells[10].firstChild.name = "warehouse_number_"+plan_flat_id;
							row[i].cells[11].firstChild.id = "goods_allocation_"+plan_flat_id;
							row[i].cells[11].firstChild.name = "goods_allocation_"+plan_flat_id;
					}
					if(cell_7!=undefined && cell_8!=undefined &&cell_6!=undefined){
						
							if(cell_8==""){
								outNum=0;
								}
							else{
								outNum=cell_8;
								}
							
							if(cell_7==""){
								wzPrice=0;
								}
							else{
								wzPrice=cell_7;
								}
							if(cell_5==""){
								cell_5=0;
								}
							if(cell_6==""){
								cell_6=0;
								}
						if(cell_5<(cell_6-(-outNum))){
							alert("第"+i+"行入库量已大于计划量！");
							flag = false;
							return;
							}
						row[i].cells[9].firstChild.value=Math.round((outNum*wzPrice)*1000)/1000;
						totalMoney+=Math.round((outNum*wzPrice)*1000)/1000;
					}
				}
			}
			document.getElementById("total_money").value=Math.round(totalMoney*1000)/1000;
			return flag;
		}
</script>
</html>