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
<body onload='getApplyTeam();getConRatio();checkdiv(2)'>
<form name="form1" id="form1" method="post"
	action="">
<input type='hidden' name='status' id='status' value='2'/>
<input type='hidden' name='selectWzId' id='selectWzId'/>
<div id="new_table_box">
<div id="new_table_box_content">
<div id="new_table_box_bg">
<fieldset>
<div>
<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
	<tr>
    	<td colspan="6" align="center">物资发放</td>
    </tr>
	<tr>
		<td class="inquire_item6" style="padding-left: 85px;">发放类别：</td>
		 <td class="inquire_item6" >
    	<input type="radio" name="coding_code" value="1" onclick='checkdiv(1)'>单机
        </td>
		<td class="inquire_item6">
    	<input type="radio" name="coding_code" value="2" onclick='checkdiv(2)' checked='checked'>班组
    	</td>
	</tr>
</table>
<div style="display:" id="iDBody1">
<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
	<tr>
		<td class="inquire_item6">
			使用班组：
		</td>
		<td class="inquire_item6"><select class="select_width" id="s_apply_team" name="s_apply_team" ></select></td>
		<td class="inquire_item6"></td>
		<td class="inquire_item6"></td>
		<td class="inquire_item6"></td>
		<td class="inquire_item6"></td>
	</tr>
</table>
</div> 
<div style="display: none" id="iDBody2">
<input type='hidden' name='device_id' id='device_id' >
<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
	<tr>
		<td class="inquire_item6">
			设备名称：
		</td>
		<td class="inquire_item6">
			<input type='hidden' name='device_code' id='device_code' value=''/>
			<input type='hidden' name='dev_acc_id' id='dev_acc_id' value=''/>
			<input type='text' name='device_name' id='device_name' class="input_width" >
			<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showDevPage()"  />
		</td>
		<td class="inquire_item6">牌照号：</td>
		<td class="inquire_item6"><input type="text" name="license_num" id="license_num" class="input_width" value="" readonly="readonly"/></td>
		<td class="inquire_item6">自编号：</td>
		<td class="inquire_item6"><input type="text" name="self_num" id="self_num" class="input_width" value="" readonly="readonly"/></td>
	</tr>
</table>
</div> 
<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
	<tr>
			<td class="inquire_item6"><font color="red">*</font>发放时间：</td>
		<td class="inquire_item6"><input type="text"
			name="outmat_date" id="outmat_date" class="input_width"
			value="" readonly />
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
		<td class="inquire_item6">合计金额：</td>
		<td class="inquire_item6"><input type="text" name="total_money" id="total_money"
			class="input_width"
			value="" readonly/></td>
			<td class="inquire_item6">备注：</td>
		<td class="inquire_item6"><input type="text" name="note" id="note"
			class="input_width" value="" /></td>
	</tr>
	 <tr>
		   	<td class="inquire_item6">物资用途：</td>
		   	<td>
		   		<select id="plan_type" name="plan_type" class="select_width"></select>
		   	</td>
		   		<td class="inquire_item6">物资类型：</td>
		   	<td>
		   		<select id="wz_type" name="wz_type" class="select_width" onchange=''>
		   		<option value='0'>在帐物资</option>
		   		<%if(!projectType.equals("5000100004000000008")){ %>
		   		<option value='1'>可重复利用物资</option>
		   		<%} %>
		   		<option value='2'>自采购物资</option>
		   		</select>
		   	</td>
		   	<td class="inquire_item6"></td>
		   	<td align="right">
		   		<input type="button" value="打开库存" onclick="openMatHave()"/>
		   		<input type="button" value="删除" onclick="deleteMatHave()"/>
		   	</td>
	</tr>
</table>
</div>
</fieldset>
<fieldset>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right" id="queryRetTable">
			<tr>
				<td class="bt_info_even" exp="<input name = 'rdo_entity_id' id = 'rdo_entity_id' type='checkbox' checked = 'true'  value='{wz_id}' onclick='loadDataDetail()'/>" ><input type='checkbox' name='rdo_entity_id' value='' onclick='check()'/></td>
				<td class="bt_info_odd" autoOrder="1">序号</td>
<!-- 			<td class="bt_info_even" exp="{coding_name}">物资用途</td>   -->
				<td class="bt_info_odd" exp="{wz_id}">物资编码</td>
				<td class="bt_info_even" exp="{wz_name}">名称</td>
				<td class="bt_info_odd" exp="{wz_prickie}">计量单位</td>
				<td class="bt_info_even" exp="{mat_num}">入库数量</td>
				<td class="bt_info_odd" exp="{wz_price}">参考单价</td>
				<td class="bt_info_even" exp="{out_num}">已发放数量</td>
				<td class="bt_info_odd"exp="<input type='text' name='mat_num_{wz_id}' id='mat_num_{wz_id}' value='' onkeyup='loadDataDetail()'  style='width:40px'/>">本次发放数量</td>
				<td class="bt_info_even" exp="<input type='text' name='mat_price_{wz_id}' id='mat_price_{wz_id}' value='{wz_price}'  style='width:40px'/>">实际单价</td>
				<td class="bt_info_odd" exp="<input type='text' name='total_money_{wz_id}' id='total_money_{wz_id}' value=''  style='width:40px' reandonly/>">金额</td>
			</tr>
		</table>
	</div>
	<table id="fenye_box_table">
			</table>
			</fieldset>	
</div>
<div id="oper_div">
<span class="bc_btn"><a href="#" onclick="save()"></a></span> 
<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
</div>
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
	var projectInfoNo = "<%=projectInfoNo%>";
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	var checkIds="";
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
	
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
	function refreshData(){
		cruConfig.queryService = "MatItemSrv";
		cruConfig.queryOp = "getOtherGantOut";
		
		queryData(1);
	}							
	function save(){	
		//if (!checkForm()) return;
		ids = getSelIds('rdo_entity_id');
		if(ids==""){
			alert("请选择一条记录!");
			return;
		}
		var outDate = document.getElementById("outmat_date").value;
		if(outDate!=null && outDate!=""){
			if(loadDataDetail()){
			document.getElementById("form1").action="<%=contextPath%>/mat/singleproject/warehouse/out/grant/saveOtherGrantOut.srq?laborId="+ids;
			document.getElementById("form1").submit();
			openMask();
			}
			}
		else{
			alert("发放时间不能为空！");
			}
	}
	function showDevPage(){
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectAccount.jsp?projectinfono="+projectInfoNo,obj,"dialogWidth=920px;dialogHeight=500px");

		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split('~');
			var deviceId = returnvalues[0];
			var deviceName = returnvalues[2];
			var selfNum = returnvalues[4];
			var licenseNum = returnvalues[6];
			
			var checkSql="select * from gms_device_account_dui where dev_acc_id='"+deviceId+"'";
		    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;
			if(datas!=null&&datas!=""){
				for (var i = 0; i<datas.length; i++) {
					var deviceCode = datas[0].dev_type;		
				}
			}
			document.getElementById("device_name").value = deviceName;
			document.getElementById("device_code").value = deviceCode;
			document.getElementById("dev_acc_id").value = deviceId;
			document.getElementById("self_num").value = selfNum;
			document.getElementById("license_num").value = licenseNum;
		}
	}		
	function getApplyTeam(){
    	var selectObj = document.getElementById("s_apply_team"); 
    	document.getElementById("s_apply_team").innerHTML="";
    	selectObj.add(new Option('请选择',""),0);

//    	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeam","");
		var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeamP","projectType=<%=projectType%>");

    	for(var i=0;i<applyTeamList.detailInfo.length;i++){
    		var templateMap = applyTeamList.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
    	}   	
    	
    }	
	function loadDataDetail(shuaId){
		var tab =document.getElementById("queryRetTable");
		var outNum=0;
		var wzPrice=0;
		var totalMoney=0;
		var flag = true;
		var row = tab.rows;
		for(var i=1;i<row.length;i++){
			var cell_8 = row[i].cells[8].firstChild.value;
			var cell_9 = row[i].cells[9].firstChild.value;
			var cell_7 = row[i].cells[7].innerHTML;
			var cell_5 = row[i].cells[5].innerHTML;
			if(cell_5=="&nbsp;"){
				cell_5 = "";
			}
			if(cell_7=="&nbsp;"){
				cell_7 = "";
			}
			if(cell_8!=undefined && cell_9!=undefined){
				
					if(cell_8==""){
						outNum=0;
						}
					else{
						outNum=cell_8;
						}
					
					var adsa = Math.round((Number(cell_5)-Number(cell_7))*10000)/10000;
					
					if(adsa<Number(outNum)){
						alert("发放数量不能大于库存数量!");
						flag = false;
						return;
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
		document.getElementById("total_money").value=totalMoney;
		return flag;
	}
	function checkdiv(value){
		switch(value){
		case 1:{
			 document.getElementById('iDBody1').style.display = "none";
		     document.getElementById('iDBody2').style.display = "";
		     break;
			}
		case 2:{
			 document.getElementById('iDBody1').style.display = "";
		     document.getElementById('iDBody2').style.display = "none";
		     break;
			}
		case 3:{
			 document.getElementById('iDBody1').style.display = "none";
		     document.getElementById('iDBody2').style.display = "none";
		     break;
			}
		}
		
		getConRatio(value);
		}
	function openMask(){
		$( "#dialog-modal" ).dialog({
			height: 140,
			modal: true,
			draggable: false
		});
	}
	function getConRatio(radioValue){
		var selectObj = document.getElementById("plan_type"); 
    	document.getElementById("plan_type").innerHTML="";

    	var retObj=jcdpCallService("MatItemSrv","queryConRatio","radioValue="+radioValue);	
    	var taskList = retObj.matInfo;
    	for(var i =0; taskList!=null && i < taskList.length; i++){
			selectObj.add(new Option(taskList[i].lable,taskList[i].value),i+1);
    	}
		}
	function changeDatas(value){
		if(value=='0'){
			refreshData();
			}
		else if(value=='1'){
			getRepeatDatas();
			}
		}
	function getRepeatDatas(){
		cruConfig.queryService = "MatItemSrv";
		cruConfig.queryOp = "getOtherRepOut";
		queryData(1);
		}
	
	function getPurRepeatDatas(){
		cruConfig.queryService = "MatItemSrv";
		cruConfig.queryOp = "getOtherPurOut";
		queryData(1);
		}
	
	function openMatHave(){
		var wz_type = document.getElementById("wz_type").value;
		var selectWzId = document.getElementById("selectWzId").value;
		var selected = window.showModalDialog("<%=contextPath%>/mat/singleproject/warehouse/out/grant/selectGrantList.jsp?wz_type="+wz_type+"&selectWzId="+selectWzId,"","dialogWidth=1240px;dialogHeight=480px");
		debugger;
/*		var temp = selected.split(",");
		var wz_ids = "";
		for(var i=0;i<temp.length;i++){
			if(wz_ids!=""){
				wz_ids += ","; 
			}
			wz_ids += "'"+temp[i]+"'";
		}
*/		
		var wz_id = selected;
		document.getElementById("selectWzId").value = wz_id;
		cruConfig.submitStr ="wz_ids="+wz_id;
		if(selected!=null&&selected!=""){
			if(wz_type=="1"){
				getRepeatDatas();
			  }else if(wz_type=="2"){
				  getPurRepeatDatas();
			  }else{
				refreshData();
			  }
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
		if(newIds!=""){
			var temp = newIds.split(",");
			for(var i=0;i<temp.length;i++){
				if(wz_ids!=""){
					wz_ids += ","; 
				}
				wz_ids += "'"+temp[i]+"'";
			}
		}
		//重新刷新列表页面
		document.getElementById("selectWzId").value = wz_ids;
		var wz_type = document.getElementById("wz_type").value;
		if(wz_ids!=null&&wz_ids!=""){
			cruConfig.submitStr ="wz_ids="+wz_ids;
			if(wz_type=="1"){
				getRepeatDatas();
			  }else if(wz_type=="2"){
				getPurRepeatDatas();
			  }else{
				refreshData();
			  }
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
	
</script>
</html>