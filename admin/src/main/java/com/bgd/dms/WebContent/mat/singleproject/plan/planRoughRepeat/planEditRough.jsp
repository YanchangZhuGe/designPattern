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
		String codeId = "";
		codeId = request.getParameter("codeId");
		Date startDate = new Date();
		Long beginDate = startDate.getTime();
		Long endDate = beginDate+(10*24*60*60*1000);
		startDate.setTime(endDate);
		String str = new java.text.SimpleDateFormat("yyyy-MM-dd").format(startDate); 
		UserToken user = OMSMVCUtil.getUserToken(request);
		
		String plan_id = request.getParameter("plan_id");
		
		


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
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

<title>无标题文档</title>
</head>

<body class="odd_odd">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" align="center">
		<div id="new_table_box_content"> 
			<div id="new_table_box_bg">
				<input type='hidden' name = 'taskObjectId' id = 'taskObjectId' value=''/>
			  	<input type='hidden' name = 'projectInfoNo' id = 'projectInfoNo' value=''/>
			  	<input type='hidden' name = 'planId' id = 'planId' value=''/>
			  	<input type='hidden' name='laborId' id='laborId' value=''/>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						  <tr>
						  	<td class="inquire_item4">申请单位</td>
						   	<td class="inquire_form4"><input name="org_name" id="org_name" type="text" class="input_width" value=""/>
						   	</td>
						  	<td class="inquire_item4">申请时间 </td>
						   	<td class="inquire_form4">
						   		<input type="text" id="apply_date" name="apply_date" class="input_width" readonly="readonly"/>
					    		&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(apply_date,tributton1);" />&nbsp;
					    	</td>
						  </tr>
						  <tr>
						  	<td class="inquire_item4">申请人：</td>
						   	<td class="inquire_form4">
						   		<input type="text" id="apply_person" name="apply_person" class="input_width"></select>
						   	</td>
							<td class="inquire_item4">联系电话:</td>
						   	<td class="inquire_form4"><input name="apply_phone" id="apply_phone" type="text" class="input_width" value=""/>
						   	</td>
						  </tr>
						  <tr>
						  	<td class="inquire_item4">交货时间：</td>
						   	<td class="inquire_form4">
						   		<input type="text" id="delivery_date" name="delivery_date" class="input_width" readonly="readonly"/>
					    		&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(delivery_date,tributton2);" />&nbsp;
					    	</td>
							<td class="inquire_item4">交货地点:</td>
						   	<td class="inquire_form4"><input name="delivery_address" id="delivery_address" type="text" class="input_width" value="" />
						   	</td>
						  </tr>
						  <tr>
						  	<td class="inquire_item4">计划编号：</td>
						   	<td class="inquire_form4">
						   		<input type="text" id="plan_no" name="plan_no" class="input_width"></select>
						   	</td>
						  	<td class="inquire_item4"></td>
						   	<td class="inquire_form4"></td>
						  </tr>
					</table>
						<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <td></td>
			    <td></td>
			    <td></td>
			  </tr>
			</table>
			</td>
			  </tr>
			</table>
			<div id="list_table">
			<div id="table_box" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input name = 'rdo_entity_id'  type='checkbox' checked='true' value='' onclick='loadDataDetail()'/>" ><input type='checkbox' name='rdo_entity_id' value='' onclick='check()'/></td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd"  exp="<input name=''  type='text' value='{wz_name}' />">名称规格(设备编号)</td>
			      <td class="bt_info_even" exp="<input name=''  type='text' value='{wz_prickie}' />">计量单位</td>
			      <td class="bt_info_odd" exp="<input name=''  type='text' value='{apply_num}' />">申请数量</td>
			      <td class="bt_info_even" exp="<input name=''  type='text' value='{zhichenggan_num}' />">支撑杆数量(附件)</td>
			      <td class="bt_info_odd" exp="<input name=''  type='text' value='{pengbu_num}' />">篷布(附件)</td>
			      <td class="bt_info_even" exp="<textarea name=''  >{appearance}</textarea>">外观</td>
			      <td class="bt_info_even" exp="<textarea name=''  >{performance}</textarea>">性能</td>
			      <td class="bt_info_even" exp="<textarea name=''  >{note}</textarea>">备注</td>
			      <td class="bt_info_odd" exp="">状态</td>
			    </tr>
			  </table>
			  </div>
			<table id="fenye_box_table">
			</table>
			</div>
			 </div> 
					</div>  
				 <div id="oper_div">
					<span class="bc_btn"><a href="#"onclick="toSave()"></a></span> 
					<span class="gb_btn"><a href="#"onclick="newClose()"></a></span>
			</div>
		</div> 
	</div>
	<div id="dialog-modal" title="正在执行" style="display:none;">
	请不要关闭
	</div>
</form>	
</body>
<script type="text/javascript">
function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]);
    return null;
    }

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

<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	debugger;
	onLoad();
	refreshData();
	loadDataDetail("1");
	
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
    var taskObjectId = getQueryString("taskObjectId");
    document.getElementById("taskObjectId").value = taskObjectId;
    var projectInfoNo = getQueryString("projectInfoNo");
    document.getElementById("projectInfoNo").value = projectInfoNo;
	function refreshData(value){
		cruConfig.queryService = "";
   		cruConfig.queryOp = "";
   		var sql ='';
   		sql +="select * from gms_mat_demand_rough_repeat where plan_id = '<%=plan_id%>' order by order_num asc";
   		cruConfig.cdtType = 'form';
   		cruConfig.queryStr = sql;
   		cruConfig.currentPageUrl = "";
		queryData(1);
	}
	
	
	function toDelete(){
			del();
	}
	
	function del() {
	    var tab=document.getElementById("queryRetTable");//最好给table指定个id
	   // for(var i=0;i<tab.rows.length;i++) {
	    	var obj=document.getElementsByName("rdo_entity_id");
	    	if(obj!=null ){
	    		for(var j =obj.length-1; j>0 ;j--){
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
	
	  function toSave(){ 
		  ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				alert("请选择一条记录!");
				return;
			}
			else{
				if(loadDataDetail()){
					document.getElementById("laborId").value = ids;
					document.getElementById("form1").action="<%=contextPath%>/mat/singleproject/plan/repeat/saveRepeatRoughPlan.srq";
					document.getElementById("form1").submit();
					openMask();
				}
			}
			
	 }  
       function toAdd(){
    	   	cruConfig.queryService = "";
	   		cruConfig.queryOp = "";
	   		var autoOrder = document.getElementById("queryRetTable").rows.length;
	   		var sql ='';
	   		sql +="select '' wz_name,'' wz_prickie,'' apply_num,'' submit_num,'' wz_price,'' total_price,'' note ,'' main_part,'' status from dual";
	   		cruConfig.cdtType = 'form';
	   		cruConfig.queryStr = sql;
	   		cruConfig.currentPageUrl = "/mat/singleproject/plan/planAddItemList.jsp";
	   		queryData(1);
		}
     
       /*
		*查询结果的显示
		*/
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
					vTr.orderNum = i+1;
					
					// 选中行高亮
					vTr.onclick = function(){
						//alert(tbObj.selectedRow);
						// 取消之前高亮的行
						
						tbObj.selectedValue = cells[0].childNodes[0].value;
						// 加载Tab数据
						loadDataDetail(cells[0].childNodes[0].value);
					}
					vTr.ondblclick = function(){
						var cells = this.cells;
						dbclickRow(cells[0].childNodes[0].value);
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
	var selectIndex = 0;
	function loadDataDetail(shuaId){
		var tab =document.getElementById("queryRetTable");
		var totalMoney=0;
		var row = tab.rows;
		var flag=true;
//		var obj = event.srcElement;
		for(var i=1;i<row.length;i++){
			row[i].cells[0].firstChild.value = i;     //文本框定义一个值
			row[i].cells[2].firstChild.name = "wz_name_"+i;
			row[i].cells[3].firstChild.name = "wz_prickie_"+i;
			row[i].cells[4].firstChild.name = "apply_num_"+i;
			row[i].cells[5].firstChild.name = "zhichenggan_num_"+i;
			row[i].cells[6].firstChild.name = "pengbu_num_"+i;
			row[i].cells[7].firstChild.name = "appearance_"+i;
			row[i].cells[8].firstChild.name = "performance_"+i;
			row[i].cells[9].firstChild.name = "note_"+i;
			
			var cell_4 = row[i].cells[4].firstChild.value;
			var cell_5 = row[i].cells[5].firstChild.value;
			var cell_6 = row[i].cells[6].firstChild.value;
			debugger;
			if(row[i].cells[0].firstChild.checked==true){
				
				var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  
				if(cell_4!=""&&!re.test(cell_4)){
					alert("第"+i+"行申请数量请输入数字!");
					flag = false;
					return ;
				}
				if(cell_5!=""&&!re.test(cell_5)){
					alert("第"+i+"行支撑杆数量请输入数字!");
					flag = false;
					return ;
				}
				if(cell_6!=""&&!re.test(cell_6)){
					alert("第"+i+"行篷布数量请输入数字!");
					flag = false;
					return ;
				}
			}
		}
		return flag;
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
	 function openMask(){
			$( "#dialog-modal" ).dialog({
				height: 140,
				modal: true,
				draggable: false
			});
		}
	 
	 function onLoad(){
		 var retObj;
		 retObj = jcdpCallService("MatItemSrv","queryRoughPlan","plan_id=<%=plan_id%>");
		 debugger;
		 document.getElementById("planId").value = retObj.map.planId;
		 document.getElementById("org_name").value = retObj.map.orgName;
		 document.getElementById("apply_date").value = retObj.map.applyDate;
		 document.getElementById("apply_person").value = retObj.map.applyPerson;
		 document.getElementById("apply_phone").value = retObj.map.applyPhone;
		 document.getElementById("delivery_date").value = retObj.map.deliveryDate;
		 document.getElementById("delivery_address").value = retObj.map.deliveryAddress;
		 document.getElementById("plan_no").value = retObj.map.planNo;
	 }
	 
</script>

</html>

