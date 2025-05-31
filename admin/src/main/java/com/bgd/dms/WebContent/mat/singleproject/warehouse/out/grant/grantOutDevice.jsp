<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String startDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date()); 
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
	String applyDate = sdf.format(new Date());
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
<body onload='getPlanNum();getConRatio()'>
<form name="form1" id="form1" method="post"
	action="">
	<input type='hidden' name='data' id='data' value=''/>
	<input type='hidden' name='laborId' id='laborId' value=''/>
	<input type='hidden' name='status' id='status' value='1'/>
<div id="new_table_box">
<div id="new_table_box_content">
<div id="new_table_box_bg">
<table border="0" cellpadding="0" cellspacing="0"
	class="tab_line_height" width="100%">
	<tr>
    	<td colspan="6" align="center">发放</td>
    </tr>
	<tr>
		<td class="inquire_item6">计划编号：</td>
		<td class="inquire_item6"><input type="text"
			name="device_use_name" id="device_use_name" class="input_width"
			value=""  />
			<input type='hidden' name='submite_number' id='submite_number'/>
			<input type='hidden' name='procure_no' id='procure_no'/>
			<input type='button' style='width:20px' value='...' onclick='showDevPage()'/></td>
		<td class="inquire_item6">设备名称：</td>
		<td class="inquire_item6"><input type="text"
			name="device_name" id="device_name" class="input_width"
			value="" readonly />
			<input type='hidden' name='device_code' id='device_code' value=''/>
			<input type='hidden' name='dev_acc_id' id='dev_acc_id' value=''/>
			</td>
		<td class="inquire_item6">虚拟出库：</td>
		<td >
		<select class="select_width" name='out_type' id ='out_type'>
		<option value='2'>是</option>
		<option value='1' selected='select'>否</option>
		</select>
		</td>
	
	</tr>
	<tr>
			<td class="inquire_item6">发料时间：</td>
		<td class="inquire_item6"><input type="text"
			name="outmat_date" id="outmat_date" class="input_width"
			value="<%=startDate %>" readonly />
			<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(outmat_date,tributton1);" /></td>
		<td class="inquire_item6">开票员：</td>
		<td class="inquire_item6"><input type="text" name="drawer" id="drawer"
			class="input_width"
			value="" /></td>
		<td class="inquire_item6">保管员：</td>
		<td class="inquire_item6"><input type="text" name="storage" id="storage"
			class="input_width" value="" /></td>
	</tr>
	<tr>
		<td class="inquire_item6">提料人：</td>
		<td class="inquire_item6"><input type="text" name="pickupgoods" id="pickupgoods"
			class="input_width" value="" /></td>
		<td class="inquire_item6">备注：</td>
		<td class="inquire_item6"><input type="text" name="note" id="note"
			class="input_width" value="" /></td>
		<td class="inquire_item6">合计金额：</td>
		<td class="inquire_item6"><input type="text" name="total_money" id="total_money"
			class="input_width"
			value="" readonly/></td>
	</tr>
	 <tr>
		   	<td class="inquire_item6">物资用途：</td>
		   	<td>
		   		<select id="plan_type" name="plan_type" class="select_width">
		   		</select>
		   	</td>
	 </tr>
</table>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right" id="queryRetTable">
			<tr>
				<td class="bt_info_odd" exp="<input name = 'rdo_entity_id' id = 'rdo_entity_id' type='checkbox' checked='true' value='{wz_id}' onclick='loadDataDetail()'/>" >选择</td>
				<td class="bt_info_even" autoOrder="1">序号</td>
				<td class="bt_info_odd" exp="{wz_id}">物资编码</td>
				<td class="bt_info_even" exp="{coding_code_id}">物资分类码</td>
				<td class="bt_info_odd" exp="{wz_name}">名称</td>
				<td class="bt_info_even" exp="{wz_prickie}">单位</td>
				<td class="bt_info_odd" exp="{plan_num}">需求数量</td>
				<td class="bt_info_even" exp="{use_num}">已出库数量</td>
				<td class="bt_info_odd" exp="<input type='text' name='mat_num_{wz_id}' id='mat_num_{wz_id}' value='{plan_num}'  style='width:40px'/>">出库数量</td>
				<td class="bt_info_even" exp="<input type='text' name='actual_price_{wz_id}' id='actual_price_{wz_id}' value='{wz_price}'  style='width:40px'/>">入库单价</td>
				<td class="bt_info_odd" exp="<input type='text' name='total_money_{wz_id}' id='total_money_{wz_id}' value=''  style='width:40px'/><input type='hidden' name='data_{wz_id}' id='data_{wz_id}'>">金额</td>
				<td class="bt_info_even"exp="{warehouse_number}">备注</td>
			</tr>
		</table>
	</div>
	<table  id="fenye_box_table">
			 
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
	var checkIds="";
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
	var deviceCode=getQueryString("deviceCode");
	var deviceName=getQueryString("deviceName");
	document.getElementById("device_code").value = deviceCode;
	document.getElementById("device_name").value = deviceName;
	function refreshData(value){
		//var sql ="select d.plan_num,i.* from gms_mat_teammat_out t inner join (GMS_MAT_DEVICE_USE_INFO_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0') on t.teammat_out_id=d.teammat_out_id where t.teammat_out_id='"+value+"'";
		cruConfig.queryService = "MatItemSrv";
		cruConfig.queryOp = "getOutDevLeaf";
		cruConfig.submitStr ="value="+value;
		queryData(1);
		checkIds=getSelIds('rdo_entity_id');
	}							
	function save(){	
		//if (!checkForm()) return;
		ids = getSelIds('rdo_entity_id');
		 if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		 else{
			 var outType=document.getElementById("out_type").value;
			 if(outType==1){
					 if(checkNum())
						{
							return;
							}
					 else{
						openMask();
						document.getElementById("laborId").value = ids;
						document.getElementById("form1").action="<%=contextPath%>/mat/singleproject/warehouse/out/grant/saveGrant.srq";
						document.getElementById("form1").submit();
					 }
			 }
			 else{
				 
					 openMask();
					 document.getElementById("laborId").value = ids;
					 document.getElementById("form1").action="<%=contextPath%>/mat/singleproject/warehouse/out/grant/saveOutGrant.srq";
					 document.getElementById("form1").submit();
				 }
		 }
			
	}
	function loadDataDetail(shuaId){
		var tab =document.getElementById("queryRetTable");
		var outNum=0;
		var wzPrice=0;
		var totalMoney=0;
		var row = tab.rows;
		for(var i=1;i<row.length;i++){
			var cell_8 = row[i].cells[8].firstChild.value;
			var cell_9 = row[i].cells[9].firstChild.value;
			if(row[i].cells[0].firstChild.checked==true){
				if(cell_8!=undefined && cell_9!=undefined){
					
						if(cell_8==""){
							outNum=0;
							}
						else{
							outNum=cell_8;
							}
						
						if(cell_9==""){
							wzPrice=0;
							}
						else{
							wzPrice=cell_9;
							}
					row[i].cells[10].firstChild.value=Math.round((outNum*wzPrice)*1000)/1000;
					totalMoney+=Math.round((outNum*wzPrice)*1000)/1000;
				}
			}
		}
		document.getElementById("total_money").value=Math.round((totalMoney)*1000)/1000;
	}
	function showDevPage(){
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/mat/singleproject/warehouse/out/grant/selectPlanList.jsp?deviceCode="+deviceCode,obj,'dialogWidth=1024px;dialogHigth=400px');
		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split(',');
			var id = returnvalues[0].substr(returnvalues[0].indexOf(':')+1);
			var name = returnvalues[1].substr(returnvalues[1].indexOf(':')+1);
			var dev_acc_id = returnvalues[2].substr(returnvalues[2].indexOf(':')+1);
			document.getElementById("device_use_name").value = name;
			document.getElementById("dev_acc_id").value = dev_acc_id;
			document.getElementById("submite_number").value = id;
			refreshData(id);
   }
   }
	function openMask(){
		$( "#dialog-modal" ).dialog({
			height: 140,
			modal: true,
			draggable: false
		});
	}
	function getPlanNum(){
		var retObj = jcdpCallService("MatItemSrv", "findGrantNum", "ids=");
		var taskList = retObj.matInfo;
		var num=1;
		if(taskList!=undefined){
				num=taskList.length+1;
			}
		document.getElementById("procure_no").value=<%=applyDate%>+"-00"+num;
		}	
	function dbclickRow(shuaId){
		var tab =document.getElementById("queryRetTable");
		var rows = tab.rows;
		var tabNum='';
	  	   for(var i=0;i<rows.length;i++){
	  		   var cells = rows[i].cells;
	  		   for(var j=0;j<cells.length;j++){
	  			   if(cells[j].firstChild.value==shuaId){
	  				   tabNum = cells[8].firstChild.value;
	      			   }
	      		   }
	      	   }
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/mat/singleproject/warehouse/out/grant/selectMatAcceptList.jsp?id="+shuaId+"&tabNum="+tabNum,obj,'dialogWidth=1024px;dialogHigth=400px');
		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split(';');
			var datas =returnvalues[0];
			var num =returnvalues[1];
			var price = returnvalues[2];
			var matNum = "mat_num_"+shuaId;
			var actualPrice = "actual_price_"+shuaId;
			var data = "data_"+shuaId;
			document.getElementById(matNum).value=num;
			document.getElementById(actualPrice).value=price;
			document.getElementById(data).value=datas;
			document.getElementById("data").value = document.getElementById("data").value+datas;
   }
	} 
	function checkNum(){
		var tab =document.getElementById("queryRetTable");
		var rows = tab.rows;
		var tabNum='';
	  	   for(var i=1;i<rows.length;i++){
	  		   var cells = rows[i].cells;
	  		   var cell_0 = cells[0].firstChild.value;
	  		   var cell_6 = cells[6].innerHTML;
	  		   var cell_7 = cells[7].innerHTML;
	  		   var cell_8 = cells[8].firstChild.value;
	  		   if(cell_7=""){
	  			 cell_7=0;
		  		   }
	  		 if(cells[0].firstChild.checked==true){
		  		   if(cell_6 < (cell_7-(-cell_8))){
			  		   var num = i;
						alert("第"+num+"行出库数量不符合申请数量");
						return true;
			  		   }
		  		   if(document.getElementById("data_"+cell_0+"").value ==""){
			  			var num = i;
						alert("第"+num+"行出库数量没有选择明细");
						return true;
				  		}
		      	   }
	  	   }
		return false;
		}
	function getConRatio(){
		var selectObj = document.getElementById("plan_type"); 
    	document.getElementById("plan_type").innerHTML="";

    	var retObj=jcdpCallService("MatItemSrv","queryConRatio","");	
    	var taskList = retObj.matInfo;
    	for(var i =0; taskList!=null && i < taskList.length; i++){
			selectObj.add(new Option(taskList[i].lable,taskList[i].value),i+1);
    	}
		}
</script>
</html>