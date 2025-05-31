<%@page contentType="text/html;charset=utf-8" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
	String userName = user.getUserName();
	String projectInfoNo = user.getProjectInfoNo();
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
<body class="bgColor_f3f3f3" onload="">
<form name="form" id="form" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg">
      <fieldSet style="margin-left:2px"><legend>基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
			<td class="inquire_item4"><font color="red">*</font>计划名称：</td>
		 	<td class="inquire_form4">
				      	<input type="text" id="device_use_name" name="device_use_name" class="input_width"  value=""/>
			</td>
			<td class="inquire_item4"><font color="red">*</font>计划单号：</td>
		 	<td class="inquire_form4">
				      	<input type="text" id="second_org2" name="second_org2" class="input_width"  value=""/>
			</td>
        </tr>
        <tr>
			<td class="inquire_item4"><font color="red">*</font>设备名称：</td>
		 	<td class="inquire_form4">
				      	<input type="hidden" id="device_id" name="device_id" class="input_width"  value=""/>
				      	<input type="hidden" id="dev_acc_id" name="dev_acc_id" class="input_width"  value=""/>
				      	<input type="hidden" id="device_tem_id" name="device_tem_id" class="input_width"  value=""/>
				      	<input type="text" id="device_name" name="device_name" class="input_width"  value="" readonly/>
				      	<input type="button" style="width:20px" value="..." onclick="showDevPage()"/>
			</td>
			<td class="inquire_item4">自编号:</td>
		 	<td class="inquire_form4">
		 				<input type="text" id="self_num" name="self_num" class="input_width"  value="" readonly/>
		 	</td>
        </tr>
        <tr>
       	   
       		<td class="inquire_item4">牌照号：</td>
		 	<td class="inquire_form4">
				      	<input type="text" id="license_num" name="license_num" class="input_width"  value="" readonly/>
			</td>
			<td class="inquire_item4">金额:</td>
		 	<td class="inquire_form4">
		 				<input type="text" id="total_money" name="total_money" class="input_width"  value="" readonly/>
		 	</td>
        </tr>
        <tr>
        	<td class="inquire_item4">备注：</td>
		 	<td class="inquire_form4" colspan="3"><textarea class="textarea" name="remark" id="remark"></textarea></td>
			<td class="inquire_item4"></td>
		 	<td class="inquire_form4"></td>
        </tr>
      </table>
      </fieldSet>
      <fieldSet>
      		<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='showTemPage()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <td></td>
			    <td></td>
			    <td></td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			 </tr>
			</table>
			</div>
			 <div id="list_table">
				<div id="table_box" >
					<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right" id="queryRetTable" >
						<tr>
							<td class="bt_info_odd" exp="<input name = 'rdo_entity_id'  type='checkbox' checked='true' value='{wz_id}' onclick='loadDataDetail()'/>" ><input type='checkbox' name='rdo_entity_id' value='' onclick='check()'/></td>
						      <td class="bt_info_even" autoOrder="1">序号</td>
						      <td class="bt_info_odd" exp="{coding_code_id}">物资分类码</td>
						      <td class="bt_info_even" exp="{wz_id}">物资编码</td>
						      <td class="bt_info_odd" exp="{wz_name}">物资名称</td>
						      <td class="bt_info_even" exp="{wz_prickie}">计量单位</td>
						      <td class="bt_info_odd" exp="{wz_price}" >参考单价（元）</td>
						      <td class="bt_info_even" exp="{unit_num}">单元用量</td>
						      <td class="bt_info_odd" exp="<input name ='plan_num{wz_id}' id ='plan_num{wz_id}' type='text' value='{plan_num}'/>" >计划数量</td>
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
var projectInfoNo = "<%=projectInfoNo %>";
var deviceCode='';
function showDevPage(){
	var obj = new Object();
	var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectAccount.jsp?projectinfono="+projectInfoNo,obj,"dialogWidth=900px;dialogHeight=500px");
//	var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectDeviceTree.jsp",obj);
	
	if(vReturnValue!=undefined){
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

function showDatas(deviceCode){
	var sql ='';
	sql +="select i.*,t.unit_num from gms_mat_demand_tamplate_detail t inner join gms_mat_infomation i on t.wz_id=i.wz_id and i.bsflag='0' where t.tamplate_detail_id='"+deviceCode+"' and t.bsflag='0'";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = sql;
	cruConfig.currentPageUrl = "/mat/singleproject/singleExpense/addExpense.jsp";
	queryData(1);
	
}


function submitInfo(){
	ids = getSelIds('rdo_entity_id');
	if(checkText()==true){
		return;
		}
	
	if (ids == '') {
		alert("请选择一条记录!");
		return;
	}
	else{
	var form = document.getElementById("form");
	openMask();
	form.action="<%=contextPath%>/mat/singleproject/expense/addExpense.srq?ids="+ids;
	form.submit();
	}
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
	var device_id=document.getElementById("device_id").value;
	var ids = getSelIds("rdo_entity_id");
	var temp = ids.split(",");
	if(device_use_name==""){
		alert("计划名称不能为空，请填写！");
		return true;
	}
	if(device_id==""){
		alert("请选择设备！");
		return true;
	}
	var tab =document.getElementById("queryRetTable");
	var row = tab.rows;
	if(ids!=""){
		for(var i=0;i<temp.length;i++){
			var plan_num = document.getElementById("plan_num"+temp[i]).value;
			var cell = row[i+1].cells;
			var unit_num = cell[7].innerHTML;
			if(plan_num==""){
				alert("选择的计划数量不能为空，请填写！");
				return true;
			}
			if(!re.test(plan_num)){
				alert("选择的计划数量必须为数字，且大于0！");
				return true;
			}
			if(plan_num>unit_num){
				alert("选择的计划数量不能大于单元用量！");
				return true;
				}
		}
	}
	return false;
}
function showTemPage(){
	var obj = new Object();
	var ids=getSelIds('rdo_entity_id');
	var vReturnValue = popWindow('<%=contextPath%>/mat/singleproject/singleExpense/selectTem.jsp?ids='+deviceCode+'&wzIds='+ids,'1024:800');
}
function getMessage(arg){
	var totalMoney=0;
	var price=0;
	var matNum=0;
	 for(var i=0;i<arg.length;i++){
		 document.getElementById("device_tem_id").value=arg[0];
		 for(var i=0;i<arg.length;i++){
			 showDatas(arg[i]);
				}
		 var tab=document.getElementById("queryRetTable");
		 var rows = tab.rows;
			for(var i=1;i<rows.length;i++){
				var cells = rows[i].cells;
				cells[8].firstChild.value=cells[7].innerHTML;
				var cell_6 = rows[i].cells[6].innerHTML;
				var cell_8 = rows[i].cells[8].firstChild.value;
				if(rows[i].cells[0].firstChild.checked==true){
					if(cell_6!=undefined && cell_8!=undefined){
						
						if(cell_8==""){
							matNum=0;
							}
						else{
							matNum=cell_8;
							}
						
						if(cell_6=="&nbsp;"){
							price=0;
							}
						else{
							price=cell_6;
							}
					totalMoney+=price*matNum;
				}
				}
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
function showMatPage(trid){
	var obj = new Object();
	var ids=getSelIds('rdo_entity_id');
	var vReturnValue = popWindow('<%=contextPath%>/mat/singleproject/mattemplate/selectTem.jsp?ids='+ids,'1024:800');
}
/*
*查询结果的显示
*/
var selectIndex=0;
function renderTable(tbObj,tbCfg){
	//更新导航栏
	renderNaviTable(tbObj,tbCfg);
	//删除上次的查询结果
	var headChxBox = getObj("headChxBox");
	if(headChxBox!=undefined) headChxBox.checked = false;
	
	var titleRow = tbObj.rows(0);

	//设置选中的行号为0 
	tbObj.selectedRow = 0;
	tbObj.selectedValue = '';
	
	//给每一类添加exp属性，在ie9+iframe的情况下，td标签内的exp属性识别不出
	for(var j=0;j<titleRow.cells.length;j++){
		var tCell = titleRow.cells(j);
		tCell.exp = tCell.getAttribute("exp");
		tCell.cellClass = tCell.getAttribute("cellClass");
	}// end

	var orderNum=1;
	var datas = tbCfg.items;
	if(datas!=null){
		for(var i=0;i<datas.length;i++){
			var data = datas[i];
			var vTr = tbObj.insertRow();
			vTr.orderNum = orderNum+1;
			// 选中行高亮
			vTr.onclick = function(){
				//alert(tbObj.selectedRow);
				// 取消之前高亮的行
				if(tbObj.selectedRow>0){
					var oldTr = tbObj.rows[tbObj.selectedRow];
					var cells = oldTr.cells;
					for(var j=0;j<cells.length;j++){
						cells[j].style.background="#96baf6";
						// 设置列样式
						if(tbObj.selectedRow%2==0){
							if(j%2==1) cells[j].style.background = "#FFFFFF";
							else cells[j].style.background = "#f6f6f6";
						}else{
							if(j%2==1) cells[j].style.background = "#ebebeb";
							else cells[j].style.background = "#e3e3e3";
						}
					}
				}
				tbObj.selectedRow=this.cells[1].innerHTML;
				
				
				// 设置新行高亮
				var cells = this.cells;
				for(var i=0;i<cells.length;i++){
					cells[i].style.background="#ffc580";
				}
				tbObj.selectedValue = cells[0].childNodes[0].value;
				// 加载Tab数据
				loadDataDetail(cells[0].childNodes[0].value);
				if(selectIndex!=null && selectIndex!=0){
					tbObj.selectedRow=selectIndex;
				}
			}
			
			
			if(cruConfig.cruAction=='list2Link'){//列表页面选择坐父页面某元素的外键
				vTr.onclick = function(){
					eval(rowSelFuncName+"(this)");
				}
				vTr.onmouseover = function(){this.className = "trSel";}
				vTr.onmouseout = function(){this.className = this.initClassName;}
			}
	
			for(var j=0;j<titleRow.cells.length;j++){
				var tCell = titleRow.cells(j);
				var vCell = vTr.insertCell();
				// 设置列样式
				var num=getOrderNum();
				if(num%2==1){
					if(j%2==1) vCell.className = "even_even";
					else vCell.className = "even_odd";
				}else{
					if(j%2==1) vCell.className = "odd_even";
					else vCell.className = "odd_odd";
				}
				// 自动计算序号
				if(tCell.autoOrder=='1' || tCell.getAttribute('autoOrder')=='1'){
					vCell.innerHTML=getOrderNum();
					continue;
				}
				var outputValue = getOutputValue(tCell,data);
				var cellValue = outputValue;
				
				if(tCell.isShow=="Edit"){
					cellValue = "<input type=text onclick=tableInputEditable(this) onkeydown=tableInputkeydown(this) class=rtTableInputReadOnly";
					if(tCell.fieldName!=undefined) cellValue += " name="+tCell.fieldName
					else cellValue += " name="+tCell.exp.substr(1,tCell.exp.length-2);
					if(tCell.size!=undefined) cellValue += " size="+tCell.size;
					else cellValue += " size=8";
					cellValue += " value='"+outputValue+"'>";
				}
				else if(tCell.isShow=="Hide"){
					cellValue = "<input type=text value="+outputValue;
					if(tCell.fieldName!=undefined) cellValue += " name="+tCell.fieldName+">"
					else cellValue += " name="+tCell.exp.substr(1,tCell.exp.length-2)+">";
					vCell.style.display = 'none';
				}else if(tCell.isShow=="TextHide"){
					vCell.style.display = 'none';
				}
	//alert(typeof cellValue);alert(cellValue == undefined);
				if(cellValue == undefined || cellValue == 'undefined') cellValue = "";
				if(cellValue=='') {cellValue = "&nbsp;";}
				else if(cellValue.indexOf("undefined")!=-1){
				   cellValue = cellValue.replace("undefined","");
				}
	
				vCell.innerHTML = cellValue;
			}
		}
		
	}
	createNewTitleTable();
	resizeNewTitleTable();
}
function getOrderNum(){
	var tab=document.getElementById("queryRetTable");
	var rows = tab.rows;
	var sum=0;
	for(var i=1;i<rows.length;i++){
			cells= rows[i].cells;
			if(cells[1]!='undefined')
				sum+=1;
		}
	return sum;
}
function toDelete(){
	 ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		else{
			del(ids);
			}
}
function del(ids) {
   var tab=document.getElementById("queryRetTable");//最好给table指定个id
  // for(var i=0;i<tab.rows.length;i++) {
   	var obj=document.getElementsByName("rdo_entity_id");
   	if(obj!=null ){
   		for(var j =obj.length-1; j>=0 ;j--){
		    	var rdo = obj[j];
		    	if(rdo!=null && rdo.checked==true) {//你没说需求我就直接将第一行中有checkbox且为true的删除
		            tab.deleteRow(j);
	            }
	    	}
   	}
   tab=document.getElementById("queryRetTable");//最好给table指定个id
   for(var i=1;i<tab.rows.length;i++){
	    var td = tab.rows[i];
	    var cell = td.cells[1];
	    cell.innerHTML = i;
   }
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
	var wzPrice=0;
	var totalMoney=0;
	var row = tab.rows;
	for(var i=1;i<row.length;i++){
		var cell_8 = row[i].cells[8].firstChild.value;
		var cell_6 = row[i].cells[6].innerHTML;
		if(row[i].cells[0].firstChild.checked==true){
			if(cell_8!=undefined && cell_6!=undefined){
				
					if(cell_8==""){
						outNum=0;
						}
					else{
						outNum=cell_8;
						}
					
					if(cell_6=="&nbsp;"){
						wzPrice=0;
						}
					else{
						wzPrice=cell_6;
						}
				totalMoney+=Math.round((outNum*wzPrice)*1000)/1000;
			}
		}
	}
	document.getElementById("total_money").value=Math.round((totalMoney)*1000)/1000;
}
</script>
</html>

