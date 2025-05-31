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
<body onload='refreshData();getApplyTeam()' class="odd_odd">
<form name="form1" id="form1" method="post" action="">
	<input type='hidden' name='code_id' id='code_id' value='1'/>
	<input type='hidden' name='laborId' id='laborId' value=''/>
<table border="0" cellpadding="0" cellspacing="0"
	 width="100%">
						 <tr>
					    	<td class="ali_cdn_input"><font color="red">*</font>模板名称 ：</td>
					    	<td class="inquire_item4"><input name='tamplate_name' id='tamplate_name'  type='text' value=''/></td>
						  </tr>
						  <tr>
						  <td class="ali_cdn_input"><font color="red">*</font>模板类型：</td>
						  <td><input type='radio' name='tamplate_type' value='0' onclick='checkdiv(0)' checked="checked"/>班组模板</td>
						  <td><input type='radio' name='tamplate_type' value='1' onclick='checkdiv(1)'/>设备模板</td>
						  </tr>
</table>
<div style="display:" id="iDBody1">
<table >
	<tr>
		<td class="ali_cdn_input"><font color="red">*</font>使用班组：
		</td>
		<td class="ali_cdn_input"><select class="select_width" id="s_apply_team" name="s_apply_team" ></select></td>
	</tr>
</table>
</div> 
<div style="display: none" id="iDBody2">
<input type='hidden' name='device_id' id='device_id' >
<table >
	<tr>
		<td class="ali_cdn_input"><font color="red">*</font>
			设备名称：
		</td>
		<td class="ali_cdn_input">
			<input type='text' name='devicename' id='devicename' >
		</td>
		<td class="ali_cdn_input">
			<input type='button' style='width:20px' value='...' onclick='showDevPage()'/>
		</td>
	</tr>
</table>
</div> 
<table >
	<tr>
		<td class="ali_cdn_input">
			<font color="red">*</font>通用模板：
		</td>
		<td class="ali_cdn_input">
		<select class="select_width" id="loacked_if" name="loacked_if" >
		<option value='0'>是</option>
		<option value='1'>否</option>
		</select>
		</td>
	</tr>
</table>
<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
			    <td align="right">
			    <a  href="<%=contextPath%>/mat/singleproject/mattemplate/download.jsp?path=/mat/singleproject/mattemplate/wzplateinport.xlsx&filename=123.xlsx">下载物资申请模板</a>
			    <auth:ListButton functionId="" css="dr" event="onclick='AddExcelData()'" title="导入excel"></auth:ListButton>
			    </td>
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
			      <td class="bt_info_odd" exp="{wz_id}">物资编码</td>
			      <td class="bt_info_even" exp="{coding_code_id}">物资分类码</td>
			      <td class="bt_info_odd" exp="{wz_name}">名称</td>
			      <td class="bt_info_even" exp="{wz_prickie}">单位</td>
			      <td class="bt_info_odd" exp="{wz_price}" >单价</td>
			      <td class="bt_info_even" exp="<input name ='unit_num{wz_id}' type='text' value='{mat_num}'/>">单元用量</td>
			      <td class="bt_info_odd" exp="{note}" >备注</td>
			</tr>
		</table> 
	</div>
	<table id="fenye_box_table">
	</table>
</div>


		
<div id="oper_div">
<table width="100%" border="0" cellspacing="0" cellpadding="0"   >
<tr>
 
  <td background="<%=contextPath%>/images/list_15.png" >
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr align="center">
<td>
<span class="bc_btn"><a href="#"onclick="save()"></a></span> 
<span class="gb_btn"><a href="#"onclick="newClose()"></a></span>
</td>
</tr>
</table>
</td>
</tr>
</table>
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
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	function refreshData(value){
		var sql ='';
		sql +="select t.* from gms_mat_infomation t where t.bsflag='0'and wz_id='"+value+"'";
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/mattemplate/matAddTemList.jsp";
		queryData(1);
	}							
	function save(){	
		//if (!checkForm()) return;
		if(checkText()){
			return;
		};
		ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				alert("请选择一条记录!");
				return;
			}
			else{
			openMask();
			document.getElementById("laborId").value = ids;
			document.getElementById("form1").action="<%=contextPath%>/mat/singleproject/mattemplate/saveMatTem.srq";
			document.getElementById("form1").submit();
			}
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
	function checkdiv(value){
		switch(value){
		case 0:{
			 document.getElementById('iDBody1').style.display = "";
		     document.getElementById('iDBody2').style.display = "none";
		     break;
			}
		case 1:{
			 document.getElementById('iDBody1').style.display = "none";
		     document.getElementById('iDBody2').style.display = "";
		     break;
			}
		}
		}
	 function getApplyTeam(){
	    	var selectObj = document.getElementById("s_apply_team"); 
	    	document.getElementById("s_apply_team").innerHTML="";
	    	selectObj.add(new Option('请选择',""),0);

//	    	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeam","");	
	    	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeamP","projectType=<%=projectType%>");
	    	for(var i=0;i<applyTeamList.detailInfo.length;i++){
	    		var templateMap = applyTeamList.detailInfo[i];
				selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	    	}   	
	    	selectObj.add(new Option("储备","CB001"),applyTeamList.detailInfo.length+1);
	    	selectObj.add(new Option("配件","PJ001"),applyTeamList.detailInfo.length+2);
	    }
	 function showDevPage(trid){
			var obj = new Object();
			var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectDevCodeInfoForMater.jsp",obj);
			if(vReturnValue!=undefined){
				var returnvalues = vReturnValue.split('~');
				var deviceId = returnvalues[0];
				var deviceCode = returnvalues[1];
				var devicename = returnvalues[2]+returnvalues[3];
				document.getElementById("devicename").value = devicename;
				document.getElementById("device_id").value = deviceCode;
				}
		}
	 function toAdd(trid){
			var obj = new Object();
			var ids=getSelIds('rdo_entity_id');
			var vReturnValue = window.showModalDialog('<%=contextPath%>/mat/select/template/selectMatList.jsp?ids='+ids,obj,'dialogWidth=1024px;dialogHigth=400px');
			if(vReturnValue!=undefined){
				var returnvalues = vReturnValue.split('~');
				var wzId = returnvalues[0].substr(returnvalues[0].indexOf(':')+1);
				var wzIds = wzId.split(',');
				for(var i=0;i<wzIds.length;i++){
					refreshData(wzIds[i]);
					}
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

		 function getMessage(arg){
			 for(var i=0;i<arg.length;i++){
					refreshData(arg[i]);
					}
		 	}
		 function openMask(){
				$( "#dialog-modal" ).dialog({
					height: 140,
					modal: true,
					draggable: false
				});
			}
		 function checkText(){
				
				var tamplate_name=document.getElementById("tamplate_name").value;
				if(tamplate_name==""){
					alert("模板名称不能为空，请填写！");
					return true;
				}
				return false;
			}
		 function AddExcelData(){
			 var obj=window.showModalDialog('<%=contextPath%>/mat/singleproject/mattemplate/plateExcelAdd.jsp',"","dialogHeight:500px;dialogWidth:600px");
			obj = decodeURI(obj,'UTF-8');
			obj = decodeURI(obj,'UTF-8');
			 if(obj!="" && obj!=undefined ){
				 cruConfig.cdtType = 'form';
				 cruConfig.queryStr = "";
				 cruConfig.queryService = "MatItemSrv";
				 cruConfig.queryOp = "getExclData";
				 cruConfig.submitStr ="obj="+obj;
				 
				 queryData(1);
			 }			
			}
</script>
</html>