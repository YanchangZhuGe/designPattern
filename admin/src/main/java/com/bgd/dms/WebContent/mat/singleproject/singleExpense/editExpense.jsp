<%@page contentType="text/html;charset=utf-8" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String userId = user.getUserId();
	String userName = user.getUserName();
	String projectInfoNo = user.getProjectInfoNo();
	Map map = new HashMap();
	if(resultMsg.getMsgElement("map")!=null){
		map  = resultMsg.getMsgElement("map").toMap();
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

<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
<title>设备新添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="">
<form name="form" id="form" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%;overflow: hidden;">
      <fieldSet style="margin-left:2px"><legend>基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      <input type="hidden" name="teammat_out_id" id="teammat_out_id" value="<gms:msg msgTag="matInfo" key="teammat_out_id"/>"></input>
        <tr>
			<td class="inquire_item4"><font color="red">*</font>计划名称：</td>
		 	<td class="inquire_form4">
				      	<input type="text" id="device_use_name" name="device_use_name" class="input_width"  value="<gms:msg msgTag="matInfo" key="device_use_name"/>"/>
			</td>
			<td class="inquire_item4"><font color="red">*</font>计划单号：</td>
		 	<td class="inquire_form4">
				      	<input type="text" id="second_org2" name="second_org2" class="input_width"  value="<gms:msg msgTag="matInfo" key="procure_no"/>"/>
			</td>
        </tr>
        <tr>
			<td class="inquire_item4"><font color="red">*</font>设备名称：</td>
		 	<td class="inquire_form4">
				      	<input type="text" id="device_name" name="device_name" class="input_width"  value="<gms:msg msgTag="matInfo" key="dev_name"/>" readonly/>
			</td>
				<td class="inquire_item4">自编号</td>
		 	<td class="inquire_form4">
		 				<input type="text" id="self_num" name="self_num" class="input_width"  value="<gms:msg msgTag="matInfo" key="self_num"/>" readonly/>
		 	</td>
        </tr>
        <tr>
       		<td class="inquire_item4">牌照号：</td>
		 	<td class="inquire_form4">
				      	<input type="text" id="license_num" name="license_num" class="input_width"  value="<gms:msg msgTag="matInfo" key="license_num"/>" readonly/>
			</td>
			<td class="inquire_item4">金额:</td>
		 	<td class="inquire_form4">
		 				<input type="text" id="total_money" name="total_money" class="input_width"  value="<gms:msg msgTag="matInfo" key="total_money"/>" readonly/>
		 	</td>
        </tr>
        <tr>
        	<td class="inquire_item4">备注：</td>
		 	<td class="inquire_form4" colspan="3"><textarea class="textarea" name="remark" id="remark" value="<gms:msg msgTag="matInfo" key="remark"/>"></textarea></td>
			<td class="inquire_item4"></td>
		 	<td class="inquire_form4"></td>
        </tr>
      </table>
      </fieldSet>
      <div style=" ">
	  <fieldSet style="margin-left:2px"><legend>列表信息</legend>
			  <div id="table_box" style="height:190px;overflow: auto;">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="taskTable">
					<tr>
						<td class="bt_info_odd" exp="<input type='checkbox' name='task_entity_id' 
		value='' onclick=doCheck(this)/>">
					    <input type='checkbox' name='task_entity_id' value='' onclick='check();loadDataDetail()'/></td>
						<td class="bt_info_even">序号</td>
						<td class="bt_info_odd">资源名称</td>
						<td class="bt_info_even">计量单位</td>
						<td class="bt_info_odd">参考单价</td>
						<td class="bt_info_even">计划数量</td>
					</tr>
			  </table>
			</div>
      </fieldSet>
      </div>
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
</form>
</body>
<script type="text/javascript"> 
cruConfig.contextPath =  "<%=contextPath%>";
var decCode = "<gms:msg msgTag="matInfo" key="teammat_out_id"/>";
showDatas(decCode);
var projectInfoNo = "<%=projectInfoNo %>";
function showDatas(deviceCode){
	for(var j =1;j <document.getElementById("taskTable")!=null && j < document.getElementById("taskTable").rows.length ;){
		document.getElementById("taskTable").deleteRow(j);
	}
//	var checkSql="select i.wz_id,i.wz_name,i.wz_prickie,i.wz_price from GMS_MAT_DEMAND_TAMPLATE t join GMS_MAT_DEMAND_TAMPLATE_DETAIL d on t.tamplate_id=d.tamplate_id join GMS_MAT_INFOMATION i on i.wz_id=d.wz_id where t.device_id='"+deviceCode+"'";
  //  var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
	//var datas = queryRet.datas;
	var retObj = jcdpCallService("MatItemSrv", "queryDeviceEdit", "ids="+deviceCode);
	var datas = retObj.datas;
	for(var i =0; datas!=null && i < datas.length; i++){
		var wz_id = datas[i].wz_id;
		var wz_name = datas[i].wz_name;
		var wz_prickie = datas[i].wz_prickie;
		var wz_price = datas[i].wz_price;
		var teammatId = datas[i].teammat_out_id;
		var plan_num = datas[i].plan_num;
		var detail_id = datas[i].use_info_detail;
		var autoOrder = document.getElementById("taskTable").rows.length;
		var newTR = document.getElementById("taskTable").insertRow(autoOrder);
		var tdClass = 'even';
		if(autoOrder%2==0){
			tdClass = 'odd';
		}
	    var td = newTR.insertCell(0);
	    
	    var checkBox = "<input type='checkbox' name='task_entity_id' value='"+wz_id+"'";
	    if(teammatId!=""&&teammatId!=null){
	    	checkBox = checkBox + " checked=true";
	    }
	    checkBox = checkBox + " onclick='ifChecked(this);' />";
	
	    td.innerHTML = checkBox;
	    td.className = tdClass+'_odd';
	    if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
	    td = newTR.insertCell(1);
	    
	    td.innerHTML = autoOrder;
	    td.className =tdClass+'_even'
	    if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
	    td = newTR.insertCell(2);
	
	    td.innerHTML = wz_name;
	    td.className = tdClass+'_odd';
	    if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
	    td = newTR.insertCell(3);
	    
	    td.innerHTML = wz_prickie;
	    td.className =tdClass+'_even'
	    if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
		td = newTR.insertCell(4);
		
	
	    td.innerHTML = wz_price;
	    td.className =tdClass+'_odd'
	    if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
		td = newTR.insertCell(5);

		td.innerHTML = "<input type='text' name='plan_num"+wz_id+"' id='plan_num"+wz_id+"' value='"+plan_num+"'/>";
	    td.className = tdClass+'_even';
	    if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
	    td = newTR.insertCell(6);
	    
		td.innerHTML = "<input type='hidden' name='detail"+wz_id+"' id='detail"+wz_id+"' value='"+detail_id+"'/>";
		
		td = newTR.insertCell(7);
		 newTR.onclick = function(){
	        	// 取消之前高亮的行
	       		for(var i=1;i<document.getElementById("taskTable").rows.length;i++){
	    			var oldTr = document.getElementById("taskTable").rows[i];
	    			var cells = oldTr.cells;
	    			for(var j=0;j<cells.length;j++){
	    				cells[j].style.background="#96baf6";
	    				// 设置列样式
	    				if(i%2==0){
	    					if(j%2==1) cells[j].style.background = "#FFFFFF";
	    					else cells[j].style.background = "#f6f6f6";
	    				}else{
	    					if(j%2==1) cells[j].style.background = "#ebebeb";
	    					else cells[j].style.background = "#e3e3e3";
	    				}
	    			}
	       		}
				// 设置新行高亮
				var cells = this.cells;
				for(var i=0;i<cells.length;i++){
					cells[i].style.background="#ffc580";
				}
				loadDataDetail(cells[0].childNodes[0].value);
			}
	}
}

var  details ="";
function ifChecked(self){
	var id = self.value;
	var detail = document.getElementById("detail"+id).value;
	if(!self.checked){
		if(detail!=""){
			if(details!="") details += ",";
			details += detail; 
			}
	}
	if(self.checked){
		if(detail!=""){
			details = details.replace(detail,"");
		}
	}
}
var checked = false;
function check(){
		var chk = document.getElementsByName("task_entity_id");
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

function submitInfo(){
	var ids = getSelIds("task_entity_id");
	var temp = ids.split(",");
	if(checkText()){
		return;
	};
	document.getElementById("subButton").onclick = "";
	
	var form = document.getElementById("form");
	openMask();
	form.action="<%=contextPath%>/mat/singleproject/expense/saveExpense.srq?ids="+ids+"&details="+details;
	form.submit();
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
	
	var re = /^[0-9]+\.?[0-9]*$/;
	var device_use_name=document.getElementById("device_use_name").value;
	var ids = getSelIds("task_entity_id");
	debugger;
	var temp = ids.split(",");
	if(device_use_name==""){
		alert("计划名称不能为空，请填写！");
		return true;
	}
	if(ids!=""){
		for(var i=0;i<temp.length;i++){
			debugger;
			var plan_num = document.getElementById("plan_num"+temp[i]).value;
			if(plan_num==""){
				alert("选择的计划数量不能为空，请填写！");
				return true;
			}
			if(!re.test(plan_num)){
				alert("选择的计划数量必须为数字，且大于0！");
				return true;
			}
		}
	}
	return false;
}
function loadDataDetail(shuaId){
	var totalMoney=0;
	var price=0;
	var matNum=0;
	 var tab=document.getElementById("taskTable");
	 var rows = tab.rows;
		for(var i=1;i<rows.length;i++){
			var cells = rows[i].cells;
			var cell_4 = rows[i].cells[4].innerHTML;
			var cell_5 = rows[i].cells[5].firstChild.value;
			if(cell_5!=undefined && cell_4!=undefined){
				
				if(cell_5==""){
					matNum=0;
					}
				else{
					matNum=cell_5;
					}
				
				if(cell_4==""){
					price=0;
					}
				else{
					price=cell_4;
					}
			totalMoney+=price*matNum;
			}
		}
		document.getElementById("total_money").value=Math.round((totalMoney)*1000)/1000;
	}
function openMask(){
	$( "#dialog-modal" ).dialog({
		height: 140,
		modal: true,
		draggable: false
	});
}
</script>
</html>

