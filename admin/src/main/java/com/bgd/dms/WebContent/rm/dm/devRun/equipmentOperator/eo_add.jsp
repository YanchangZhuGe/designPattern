<%@page contentType="text/html;charset=utf-8" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
	String userName = user.getUserName();
	String projectInfoNo = user.getProjectInfoNo();
	String str = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date()); 
	//获取组织机构--大港
		String orgCode=user.getOrgCode();
	String bsInfo="false";
		if(orgCode.indexOf("C105007")>-1){
		 bsInfo="true";
		}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
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
<title>设备新添加界面</title>
</head>
<body class="bgColor_f3f3f3">
<form name="form" id="form" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%;overflow: ">
    <fieldSet style="margin-left:2px"><legend>表头信息</legend>
    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="right" >
    <input type="hidden" id="mat_num" name="mat_num" value=""/>
    <input type="hidden" id="wz_type" name="wz_type" value=""></input>
     <tr>
     <td class="inquire_item4"><font color="red">*</font>油料来源:</td>
		 	<td class="inquire_form4">
				<select id="oil_from" name="oil_from" class="select_width">
		 		<option value='0'>油库</option>
		 		<option value='1'>加油站</option>
		 		</select>
			</td>
			<td class="inquire_item4"><font color="red">*</font>油品名称:</td>
		 	<td class="inquire_form4">
		 		<select id='oil_type' name='oil_type' class='select_width' style="width: 30%;" onchange="selectOilType()">
				        <option value='1'>车用汽油</option>
				 		<option value='2'>轻柴油</option>
				</select>
				<select id='wz_id' name='wz_id'  class='select_width' style="width: 50%;" onchange="ifOilNum()">
<!-- 				
				        <option value=''>请选择</option>
				 		<option value='11000051822'>车用汽油 90#</option>
				 		<option value='10001037161'>车用汽油 92#</option>
				 		<option value='11004534305'>车用汽油 93#</option>
				 		<option value='10000189078'>车用汽油 95#</option>
				 		<option value='11000062340'>车用汽油 97#</option>
				 		<option value='11003426794'>轻柴油 0# 多元</option>
				 		<option value='11003308799'>轻柴油 RC-0℃</option>
				 		<option value='11003308800'>轻柴油 RC-10℃</option>
				 		<option value='11003308801'>轻柴油 RC-20℃</option>
				 		<option value='11003308804'>轻柴油 RC-30℃</option>
				 		<option value='11003308802'>轻柴油 RC-35℃</option>
				 		<option value='11003308803'>轻柴油 RC-50℃</option>
				 		<option value='11003308805'>轻柴油 RC+5</option>
 -->				 		
				      </select>
			</td>
        </tr>
        <tr>
      		 <td class="inquire_item4"><font color="red">*</font>油品单价(升):</td>
		 	<td class="inquire_form4">
		 				<input type="text" id="actual_price" name="actual_price" class="input_width"  value=""/>
		 	</td>
		 		<td class="inquire_item6"><font color="red">*</font>加油时间:</td>
		<td class="inquire_item6"><input type="text" name="outmat_date" id="outmat_date"
			class="input_width"
			value="<%=str %>" readonly="readonly" onchange="refreshData()"/>
			<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(outmat_date,tributton1);" />
			</td>
        </tr>   	
         <tr>  		
    	 </tr>
        </table>
    </fieldSet>
    
	 <fieldSet style="margin-left:2px"><legend>列表信息</legend>
	<div id="list_table">
		<div id="table_box" >
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right" id="queryRetTable" >
			<tr>
				<td class="bt_info_odd" exp="<input name = 'rdo_entity_id'  type='checkbox' value='{dev_acc_id}' onclick='loadDataDetail()'/>" ><input type='checkbox' name='rdo_entity_id' value='' onclick='check()'/></td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{dev_name}">设备名称</td>
			      <td class="bt_info_even" exp="{self_num}">自编号</td>
			      <td class="bt_info_odd" exp="{license_num}">牌照号</td>
			      <td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
			      <td class="bt_info_odd" exp="{operator_name}">操作手</td>
			      <td class="bt_info_even" exp="<input name ='oil_num_{dev_acc_id}' id ='oil_num_{dev_acc_id}' type='text' value='' size='12' onkeyup='loadDataDetail()'/>" >数量(升)</td>
			      <td class="bt_info_odd" exp="<input name ='mat_num_{dev_acc_id}' id ='mat_num_{dev_acc_id}' type='text' value='' size='12' readonly/>" >数量(吨)</td>
			      <td class="bt_info_even" exp="<input name ='total_money_{dev_acc_id}' id ='total_money_{dev_acc_id}' type='text' value='' size='12' readonly/>" >金额(元)</td>
			      <td class="bt_info_odd"><auth:ListButton functionId="" css="zj" event="onclick='showDevAccountPage()'" title="JCDP_btn_add"></auth:ListButton></td>
			</tr>
			</table> 
		</div>
		<table id="fenye_box_table">
		</table>
</div>
      </fieldSet>
      </div>

    <div id="oper_div">
     	<span class="bc_btn" ><a id="subButton" href="#" onclick="submitInfo()"></a></span>
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
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
cruConfig.queryStr = "";
selectOilType();
function refreshData(ids){
	cruConfig.queryService = "MatItemSrv";
	cruConfig.queryOp = "getDevAccDatas";
	cruConfig.submitStr ="ids="+ids;
	queryData(1);
}	
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
function loadDataDetail(shuaId){
	var bsInfo='<%=bsInfo%>';
	var tab =document.getElementById("queryRetTable");
	var outNum=0;
	var matNum = 0;
	var wzPrice=0;
	var totalMoney=0;
	var row = tab.rows;
	var obj = event.srcElement;
	if(obj.tagName.toLowerCase() =='td'){
		var tr = obj.parentNode;
		selectIndex = tr.rowIndex;
	}else if(obj.tagName.toLowerCase() =='input'){
		var tr = obj.parentNode.parentNode;
		selectIndex = tr.rowIndex;
	}
	debugger;
	for(var i=1;i<row.length;i++){
		var cell_7 = row[i].cells[7].firstChild.value;
		var cell_8 = document.getElementById("actual_price").value;
		var wzId = document.getElementById("wz_id").value;
		var oil_type = document.getElementById("oil_type").value;
		var cell_0 = row[i].cells[0].firstChild.checked;
		if(cell_0 == true){
		if(cell_7!=undefined && cell_8!=undefined && wzId!=undefined){
				if(cell_7==""){
					outNum=0;
					}
				else{
					outNum=cell_7;
					}
				
				if(cell_8==""){
					wzPrice=0;
					}
				else{
					wzPrice=cell_8;
					}
				if(wzId==""){
					row[i].cells[9].firstChild.value=0;
					}
				else if(oil_type=="1"){
					if(bsInfo=="true")
						{
						row[i].cells[8].firstChild.value=Math.round((outNum*0.77/1000)*10000)/10000;
						}
					else
						{
						row[i].cells[8].firstChild.value=Math.round((outNum*0.75/1000)*10000)/10000;
						}
					}
					else{
						if(bsInfo=="true")
						{
							row[i].cells[8].firstChild.value=Math.round((outNum*0.89/1000)*10000)/10000;
						}
						else
						{
							row[i].cells[8].firstChild.value=Math.round((outNum*0.86/1000)*10000)/10000;
						}
						
					}
			row[i].cells[9].firstChild.value=Math.round((outNum*wzPrice)*1000)/1000;
			matNum += Math.round(row[i].cells[8].firstChild.value*10000)/10000;
		}
		}
	}
	
	document.getElementById("mat_num").value = matNum ;
}
var projectInfoNo = "<%=projectInfoNo %>";
var deviceCode='';
function submitInfo(){
	var ids = getSelIds("rdo_entity_id");
	var temp = ids.split(",");
	
	var form = document.getElementById("form");
	var actual_price = document.getElementById("actual_price").value;
	var wz_id = document.getElementById("wz_id").value;
	var mat_num = document.getElementById("mat_num").value;
	var oil_type = document.getElementById("oil_type").value;
	debugger
	
	if(wz_id==""){
		alert("油品名称不能为空!");
		return;
	}
	if(actual_price==""){
		alert("单价不能为空!");
		return;
	}
	if (ids == '') {
		alert("请选择一条记录!");
		return;
	}
	

	form.action="<%=contextPath%>/mat/singleproject/oilconsumption/addConsumption.srq?devAccId="+ids;
	form.submit();
	document.getElementById("subButton").onclick = "";
	openMask();
	windows.colse();
}

function getSelIds(inputName){
	var checkboxes = document.getElementsByName(inputName);
	
	var ids = "";
	for(var i=0;i<checkboxes.length;i++){
		var chx = checkboxes[i];
		if(chx.checked){
			if(ids!="") ids += ",";
			ids += chx.value;
		}
	}
	return ids;
}
function showTemPage(){
	popWindow('<%=contextPath%>/mat/singleproject/singleExpense/selectTem.jsp?ids='+deviceCode,'1024:800');
}
function openMask(){
	$( "#dialog-modal" ).dialog({
		height: 140,
		modal: true,
		draggable: false
	});
}

function ifOilNum(){
	var wz_id = document.getElementById("wz_id").value;
	var oil_type = document.getElementById("oil_type").value;
	if(wz_id!=null&&wz_id!=""){
			var retObj=jcdpCallService("MatItemSrv","queryOilNum","wz_id="+wz_id);
			if(retObj.map!=null){
				var wz_price = retObj.map.wzPrice;	
				if(oil_type=="1"){
					document.getElementById("actual_price").value=Math.round(Number(wz_price)/1000*0.75*1000)/1000;
				}else{
//					mat_num=Math.round((oil_num*0.86/1000)*10000)/10000;
					document.getElementById("actual_price").value=Math.round(Number(wz_price)/1000*0.86*1000)/1000;
				}
		}
	}
}


function selectOilType(){
	var oil_type = document.getElementById("oil_type").value;
	debugger;
	document.getElementById("wz_id").innerHTML = "";
	var retObj=jcdpCallService("MatItemSrv","selectOilType","oil_type="+oil_type);
	if(retObj.list!=null){
		for (var i = 0; i< retObj.list.length; i++) {
			document.getElementById("wz_id").options.add(new Option(retObj.list[i].wzName,retObj.list[i].wzId)); 
		}
	}
}

function showDevAccountPage(){
	var obj = new Object();
	var dialogurl = "<%=contextPath%>/rm/dm/devRun/comm/selectAllAccount1.jsp";
	dialogurl = encodeURI(dialogurl);
	dialogurl = encodeURI(dialogurl);
	var vReturnValue = window.showModalDialog(dialogurl , obj ,"dialogWidth=950px;dialogHeight=520px");
	refreshData(vReturnValue);
}
</script>
</html>

