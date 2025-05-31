<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
		String contextPath = request.getContextPath();
		UserToken user = OMSMVCUtil.getUserToken(request);
		
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
<title>设备新添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData()">
<form name="form" id="form" method="post" action="">
<input type="hidden" id="teammat_out_id" name="teammat_out_id" class="input_width"  value="<gms:msg msgTag="matInfo" key="teammat_out_id"/>"/>
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
				<select id="oil_from" name="oil_from" class="select_width" onchange="showOilNum(this.value)">
		 		<option value=''>请选择</option>
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
				<select id='wz_id' name='wz_id'  class='select_width'  style="width: 50%;">
<!-- 				        <option value=''>请选择</option>
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
		 				<input type="text" id="actual_price" name="actual_price" class="input_width"  value="<gms:msg msgTag="matInfo" key="actual_price"/>"/>
		 	</td>
		 		<td class="inquire_item6">加油时间:</td>
		<td class="inquire_item6"><input type="text" name="outmat_date" id="outmat_date"
			class="input_width"
			value="<gms:msg msgTag="matInfo" key="outmat_date"/>"  />
			<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(outmat_date,tributton1);" />
			</td>
        </tr>
        <tr id="iDBody1" style="display:none">
			<td class="inquire_item4">汽油库存量:</td>
			<td class="inquire_form4"><input type="text" id="total_ulp_num" name="total_ulp_num" class="input_width"  value="" readonly/></td>
			<td class="inquire_item4">柴油库存量:</td>
			<td class="inquire_form4"><input type="text" id="total_diesel_num" name="total_diesel_num" class="input_width"  value="" readonly/></td>
		</tr>
        </table>
    </fieldSet>
	 <fieldSet style="margin-left:2px"><legend>列表信息</legend>
	<div id="list_table">
		<div id="table_box" >
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right" id="queryRetTable" >
				<tr>
					<td class="bt_info_odd" exp="<input name = 'rdo_entity_id'  type='checkbox'checked='true' value='{out_detail_id}' onclick='loadDataDetail()'/>" ><input type='checkbox' name='rdo_entity_id' value='' onclick='check()'/></td>
				      <td class="bt_info_even" autoOrder="1">序号</td>
				      <td class="bt_info_odd" exp="{dev_name}">设备名称</td>
				      <td class="bt_info_even" exp="{self_num}">自编号</td>
				      <td class="bt_info_odd" exp="{license_num}">牌照号</td>
				      <td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
				      <td class="bt_info_odd" exp="{operator_name}">操作手</td>
				      <td class="bt_info_even" exp="<input name ='oil_num_{out_detail_id}' id ='oil_num_{out_detail_id}' type='text' value='{oil_num}' size='13'/>" >数量(升)</td>
				      <td class="bt_info_odd" exp="<input name ='mat_num_{out_detail_id}' id ='mat_num_{out_detail_id}' type='text' value='{mat_num}' size='13' readonly/>" >数量(吨)</td>
				      <td class="bt_info_even" exp="<input name ='total_money_{out_detail_id}' id ='total_money_{out_detail_id}' type='text' value='{total_money}' size='13' readonly/>" >金额(元)</td>
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

function refreshData(){
	var oil_type = "<gms:msg msgTag="matInfo" key="coding_code_id"/>";
	if(oil_type=="07030102"){  
		document.getElementById("oil_type").value = "1";
	}else if(oil_type=="07030301"){
		document.getElementById("oil_type").value = "2";
	}
	selectOilType();
	document.getElementById("oil_from").value="<gms:msg msgTag="matInfo" key="oil_from"/>";
	document.getElementById("wz_id").value="<gms:msg msgTag="matInfo" key="wz_id"/>";
	var sql ='';
//	sql +="select d.out_detail_id,dui.dev_name,dui.self_num,dui.license_num,i.wz_prickie,d.oil_num,d.mat_num,d.total_money,dui.dev_sign,oprtbl.operator_name from GMS_MAT_TEAMMAT_OUT t inner join  (GMS_MAT_TEAMMAT_OUT_DETAIL d inner join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0' inner join gms_device_account_dui dui on d.dev_acc_id=dui.dev_acc_id and dui.bsflag='0'  left join (select device_account_id,operator_name from ( select tmp.device_account_id,tmp.operator_name,row_number() over(partition by device_account_id order by length(operator_name) desc ) as seq from (select device_account_id,wmsys.wm_concat(operator_name) over(partition by device_account_id order by operator_name) as operator_name from gms_device_equipment_operator) tmp ) tmp2 where tmp2.seq=1) oprtbl on dui.dev_acc_id = oprtbl.device_account_id) on t.teammat_out_id =d.teammat_out_id and d.bsflag='0' where t.teammat_out_id='<gms:msg msgTag="matInfo" key="teammat_out_id"/>'and t.bsflag='0'";
//	cruConfig.cdtType = 'form';
//	cruConfig.queryStr = sql;
	//cruConfig.currentPageUrl = "/mat/singleproject/oilconsumption/eidtConsumption.jsp";
	cruConfig.queryService = "MatItemSrv";
	cruConfig.queryOp = "getDevDatasEdit";
	cruConfig.submitStr ="teammat_out_id=<gms:msg msgTag="matInfo" key="teammat_out_id"/>";
	queryData(1);
	showOilNum("<gms:msg msgTag="matInfo" key="oil_from"/>");
}	
function addData(value){
	var sql ='';
	sql +="select t.* from gms_mat_infomation t where t.bsflag='0'and wz_id='"+value+"'";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = sql;
	cruConfig.currentPageUrl = "/mat/singleproject/mattemplate/matAddTemList.jsp";
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
						row[i].cells[8].firstChild.value=Math.round((outNum*0.75/1000)*10000)/10000;
					}
					else{
						row[i].cells[8].firstChild.value=Math.round((outNum*0.86/1000)*10000)/10000;
					}
			row[i].cells[9].firstChild.value=Math.round((outNum*wzPrice)*1000)/1000;
			matNum += Math.round(row[i].cells[8].firstChild.value*10000)/10000;
		}
		}
	}
	document.getElementById("mat_num").value = matNum ;
}
var deviceCode='';
function showDevPage(){
	var obj = new Object();
	var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectAccount.jsp?projectinfono="+projectInfoNo,obj,"dialogWidth=900px;dialogHeight=500px");
//	var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectDeviceTree.jsp",obj);
	
	if(vReturnValue!=undefined){
		alert(vReturnValue);
		var returnvalues = vReturnValue.split('~',-1);
//		var devicename = returnvalues[0].substr(returnvalues[0].indexOf(':')+1,(returnvalues[0].indexOf('(')-returnvalues[0].indexOf(':')-1));
//		var devicetype = returnvalues[0].substr(returnvalues[0].indexOf('(')+1,(returnvalues[0].indexOf(')')-returnvalues[0].indexOf('(')-1));
	//	var deviceCode = returnvalues[1].substr(returnvalues[1].indexOf(':')+1,(returnvalues[1].length-returnvalues[1].indexOf(':')));
//		var deviceId = returnvalues[3].substring(returnvalues[3].indexOf(':')+1,returnvalues[3].length);
		
		var devAccId = returnvalues[0];
		deviceCode = returnvalues[7];
		var deviceName = returnvalues[2];
		var deviceType = returnvalues[3];
		var deviceSelfNum = returnvalues[4]; 
		var licenseNum = returnvalues[6]; 
		var deviceNum = deviceType+"-"+deviceSelfNum

		document.getElementById("dev_acc_id").value = devAccId;
		document.getElementById("self_num").value = deviceSelfNum;
		document.getElementById("license_num").value = licenseNum;
		
		document.getElementById("device_name").value = deviceName;
		document.getElementById("device_id").value = deviceCode;
		var retObj = jcdpCallService("MatItemSrv", "findDeviceNum", "ids="+deviceCode);
		var taskList = retObj.matInfo;
		var num=1;
		if(taskList!=undefined){
				num=taskList.length+1;
			}
		document.getElementById("second_org2").value = deviceNum+"-"+"00"+num;
		
		}
		
		
}

function submitInfo(){
	var ids = getSelIds("rdo_entity_id");
	var temp = ids.split(",");
	if(checkText()){
		return;
	};
	
	var form = document.getElementById("form");
	loadDataDetail();
	
	var oil_from = document.getElementById("oil_from").value;
	var actual_price = document.getElementById("actual_price").value;
	var wz_id = document.getElementById("wz_id").value;
	var mat_num = document.getElementById("mat_num").value;
	var oil_type = document.getElementById("oil_type").value;
	if(oil_from ==''){
		alert("油料来源不能为空!");
		return;
	}
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
	if(oil_from=="0"){
		if(oil_type=="1"){
			var total_ulp_num = document.getElementById("total_ulp_num").value;
			if(Number(mat_num)>Number(total_ulp_num)){
				alert("使用数量不能大于库存数量！");
				return ;
			}
		}else{
			var total_diesel_num = document.getElementById("total_diesel_num").value;
			if(Number(mat_num)>Number(total_diesel_num)){
				alert("使用数量不能大于库存数量！");
				return ;
			}
		}
	}
	//判断是否油库，油库wz_type=0
	var oil_from = document.getElementById("oil_from").value;
	if(oil_from=="0"){
		document.getElementById("wz_type").value="0";
	}
	form.action="<%=contextPath%>/mat/singleproject/oilconsumption/eidtConsumption.srq?ids="+ids;
	form.submit();
	document.getElementById("subButton").onclick = "";
	openMask();
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

function checkText(){
	
	var re = /^[1-9]+[0-9]*$/;
	var oil_from=document.getElementById("oil_from").value
	var ids = getSelIds("task_entity_id");
	var temp = ids.split(",");
	if(oil_from==""){
		alert("油料来源不能为空！");
		return true;
	}
	return false;
}
function showTemPage(){
	popWindow('<%=contextPath%>/mat/singleproject/singleExpense/selectTem.jsp?ids='+deviceCode,'1024:800');
}
function getMessage(arg){
	 for(var i=0;i<arg.length;i++){
		 document.getElementById("device_tem_id").value=arg[0];
		 document.getElementById("device_tem").value=arg[1];
		 showDatas(arg[0]);
		 var tab=document.getElementById("taskTable");
		 var rows = tab.rows;
			for(var i=1;i<rows.length;i++){
				var cells = rows[i].cells;
				cells[6].firstChild.value=cells[5].innerHTML;
			}
			}
	}
function openMask(){
	$( "#dialog-modal" ).dialog({
		height: 140,
		modal: true,
		draggable: false
	});
}
function toAdd(trid){
	var obj = new Object();
	var ids=getSelIds('rdo_entity_id');
	var vReturnValue = window.showModalDialog('<%=contextPath%>/mat/select/template/selectMatList.jsp?ids='+ids,obj,'dialogWidth=1024px;dialogHigth=400px');
	if(vReturnValue!=undefined){
		alert(vReturnValue);
		var returnvalues = vReturnValue.split('~');
		var wzId = returnvalues[0].substr(returnvalues[0].indexOf(':')+1);
		var wzIds = wzId.split(',');
		for(var i=0;i<wzIds.length;i++){
			addData(wzIds[i]);
			}
		}
	}
	
function showOilNum(value){
	if(value=='0'){
		 document.getElementById('iDBody1').style.display = "";
		 //var querySql = "select a.coding_code_id, sum(a.stock_num) as stock_num from(select dd.coding_name, i.wz_id,i.coding_code_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='<%=user.getProjectInfoNo()%>' and mti.if_input='0' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.project_info_no='<%=user.getProjectInfoNo()%>' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '<%=user.getProjectInfoNo()%>' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '<%=user.getProjectInfoNo()%>'and (i.coding_code_id like'07030102%'or i.coding_code_id like '07030301%')) a group by a.coding_code_id";
		 
		 var retObj=jcdpCallService("MatItemSrv","queryOilNum","");	
		 var taskList = retObj.matInfo;
			for(var i =0; taskList!=null && i < taskList.length; i++){
				if(taskList[i].codingCodeId =='07030102'){
					document.getElementById("total_ulp_num").value=taskList[i].stockNum;
					}
				if(taskList[i].codingCodeId =='07030301'){
					//document.getElementById("total_diesel_num").value=taskList[i].stockNum;
					$("#total_diesel_num").val(taskList[i].stockNum);
					}
			}
		}
	else{
		document.getElementById('iDBody1').style.display = "none";
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
</script>
</html>

