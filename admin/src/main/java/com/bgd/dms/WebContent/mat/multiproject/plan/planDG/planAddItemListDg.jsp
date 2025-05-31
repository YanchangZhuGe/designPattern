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
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%
		String contextPath = request.getContextPath();
		String codeId = "";
		codeId = request.getParameter("codeId");
		Date startDate = new Date();
		String str = new java.text.SimpleDateFormat("yyyy/MM/dd").format(startDate); 
		UserToken user = OMSMVCUtil.getUserToken(request);
		String teamId = user.getOrgId();
		
		String plannum = "";
		String org_sql = "select o.org_abbreviation from comm_org_information o where o.org_id='"+teamId+"'";
		Map org_map = BeanFactory.getPureJdbcDAO().queryRecordBySQL(org_sql);
		if(org_map!=null){
			plannum += org_map.get("org_abbreviation").toString()+str;
			String sql = "select count(bz.submite_number) as numb from gms_mat_demand_plan_bz bz where bz.bsflag='0' and bz.if_purchase='9' and to_char(bz.create_date,'yyyy-MM-dd')='"+str+"' and bz.org_id like '%"+teamId+"%'";
			Map map = BeanFactory.getPureJdbcDAO().queryRecordBySQL(sql);
			if(map!=null){
				plannum += "-"+(Integer.parseInt(map.get("numb").toString())+1);
			}
		}
		
//		String sql = 
		
		

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
<title>储备计划</title>
</head>

<body   onload="getConRatio()" class="odd_odd">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" align="center">
		<div id="new_table_box_content"> 
			<div id="new_table_box_bg">
				<input type='hidden' name = 'submite_number' id = 'submite_number' value=''/>
			  	<input type='hidden' name='laborId' id='laborId' value=''/>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						  <tr>
						  	<td class="inquire_item4"><font color="red">*</font>计划编号：</td>
						   	<td class="inquire_form4"><input name="plannum" id="plannum" type="text" class="input_width" value="<%=plannum %>"/>
						   	</td>
						  	<td class="inquire_item4">转入项目：</td>
							<td class="inquire_item4">
							<input type="text"name="input_name" id="input_name" class="input_width"value="" readonly />
							<input type="hidden"name="input_org" id="input_org" class="input_width"value="" readonly />
							<input type='button' style='width:20px' value='...' onclick='showDevPage()'/>
							</td>
						  </tr>
						  <tr>
						  <td class="inquire_item4"><font color="red">*</font>计划用途：</td>
						   	<td class="inquire_form4">
						   		<select id="plan_type" name="plan_type" class="select_width"></select>
						   	</td>
 							<td class="inquire_item4">金额:</td>
						   	<td class="inquire_form4"><input name="total_money" id="total_money" type="text" class="input_width" value="" readonly="readonly"/>
						   	</td>
						   	</tr>
						   	<input type='hidden' name='if_purchase' id='if_purchase' value='1'/>
					</table>
						<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
 <!-- 		    <auth:ListButton functionId="" css="jl" event="onclick='showDevPage()'" title="模板"></auth:ListButton> -->  
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
			      <td class="bt_info_odd" exp="<input name = 'rdo_entity_id'  type='checkbox' checked='true' value='{wz_id}' onclick='loadDataDetail()'/>" ><input type='checkbox' name='rdo_entity_id' value='' onclick='check()'/></td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{wz_id}">物资编码</td>
			      <td class="bt_info_even" exp="{coding_code_id}">分类编码</td>
			      <td class="bt_info_odd" exp="{wz_name}">资源名称</td>
			      <td class="bt_info_even" exp="{wz_prickie}">计量单位</td>
<!-- 		      <td class="bt_info_odd" exp="{stock_num}">库存数量</td> -->
			      <td class="bt_info_odd" exp="<input name='wz_price_{wz_id}'  type='text' value='{wz_price}' onkeyup='loadDataDetail()'/>">参考单价</td>
			      <td class="bt_info_even" exp="<input name='demand_num_{wz_id}'  type='text' value='{unit_num}' onkeyup='loadDataDetail()'/>" >发放数量</td>
			      <td class="bt_info_odd" exp="<input name='demand_money_{wz_id}'  type='text' value='' readonly/>" >金额</td>
			      <td class="bt_info_even" exp="<input name='note_{wz_id}'  type='text' value=''/>" >备注</td>
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
$("#t_d").hide();
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
	var orgId = '<%=user.getOrgId()%>';
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
	
	
	function refreshData(value){
		cruConfig.queryService = "MatItemSrv";
		cruConfig.queryOp = "getPlanLeaf";
		cruConfig.submitStr ="value="+value;
		queryData(1);
	}
	function addData(value){
		cruConfig.queryService = "";
		cruConfig.queryOp = "";
		var sql ='';
//		if(orgId=="C6000000005263"){
//			sql +="select i.*,c.code_name, tt.stock_num,tt.actual_price, tt.org_id,tt.org_abbreviation from (select t.wz_id, case when  sum(t.stock_num)- case  when  flat.plan_num is null then 0 else flat.plan_num end is null then 0 else  sum(t.stock_num)- case  when  flat.plan_num is null then 0 else flat.plan_num end end stock_num, round(sum(t.stock_num * t.actual_price) / case when sum(t.stock_num) = 0 then  1 else sum(t.stock_num) end, 3) actual_price, t.org_id,comm.org_abbreviation  from gms_mat_recyclemat_info t  inner join comm_org_information comm on t.org_id = comm.org_id left join  (select sum(plan_num) plan_num,wz_id  from gms_mat_demand_plan_flat where  plan_flat_type='1' and wz_type='1' group by wz_id ) flat   on t.wz_id=flat.wz_id where t.bsflag = '0' and t.wz_type = '1' and t.org_id = 'C6000000000039' and t.wz_type = '1' and t.bsflag = '0'  or t.org_id = 'C6000000000040' and t.bsflag = '0' and t.wz_type = '1' or t.org_id = 'C6000000005269' and t.bsflag = '0' and t.wz_type = '1' or t.org_id = 'C6000000005275' and t.bsflag = '0' and t.wz_type = '1' or t.org_id = 'C6000000005279' and t.bsflag = '0' and t.wz_type = '1' or t.org_id = 'C6000000005280' and t.bsflag = '0' and t.wz_type = '1' or t.org_id = 'C6000000005278' and t.bsflag = '0' and t.wz_type = '1' group by t.wz_id, t.org_id,comm.org_abbreviation,flat.plan_num) tt inner join(gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id = c.coding_code_id and i.bsflag = '0' and c.bsflag = '0') on tt.wz_id = i.wz_id  and tt.stock_num>0 and tt.wz_id='"+value+"' order by i.coding_code_id asc, i.wz_id asc";
//			}else{
//			sql +="select i.*, c.code_name, tt.stock_num, tt.actual_price  from (select t.wz_id, case when  sum(t.stock_num)- case  when  flat.plan_num is null then 0 else flat.plan_num end is null then 0 else  sum(t.stock_num)- case  when  flat.plan_num is null then 0 else flat.plan_num end end stock_num, round(sum(t.stock_num * t.actual_price) / case when sum(t.stock_num) = 0 then 1 else sum(t.stock_num) end, 3) actual_price from gms_mat_recyclemat_info  t  left join  (select sum(plan_num) plan_num,wz_id  from gms_mat_demand_plan_flat where  plan_flat_type='1' and wz_type='1' group by wz_id ) flat   on t.wz_id=flat.wz_id where t.bsflag = '0' and t.wz_type = '1' and t.org_id = '"+orgId+"'  group by t.wz_id,flat.plan_num) tt inner join(gms_mat_infomation i  inner join gms_mat_coding_code c on i.coding_code_id = c.coding_code_id and i.bsflag = '0' and c.bsflag = '0') on tt.wz_id = i.wz_id  and tt.stock_num>0 and tt.wz_id='"+value+"'  order by i.coding_code_id asc, i.wz_id asc";
//			}
		sql +="select t.* from gms_mat_infomation t where t.bsflag='0'and wz_id='"+value+"' order by t.coding_code_id asc,t.wz_id asc";
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/plan/planAddItemList.jsp";
		queryData(1);
	}
	function toDelete(){
		 ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				alert("请选择一条记录!");
				return;
			}
			else{
				del();
				}
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
		  if(checkText()){
				return;
			};
		  ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				alert("请选择一条记录!");
				return;
			}
			else{
				if(loadDataDetail()){
					openMask();
					document.getElementById("laborId").value = ids;
					var plannum=document.getElementById("plannum").value;
					document.getElementById("form1").action="<%=contextPath%>/mat/singleproject/plan/savePlanDg.srq";
					document.getElementById("form1").submit();
				}
				}
			
	 }  
		 function getids(){
			 ids = getSelIds('rdo_entity_id');
				if (ids == '') {
					alert("请选择一条记录!");
					return;
				}else
				{
				return ids;
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
       function showDevPage2222222222(){
			var obj = new Object();
			var vReturnValue = window.showModalDialog('<%=contextPath%>/mat/select/template/selectTem.jsp',obj,'dialogWidth=1024px;dialogHigth=400px');
			if(vReturnValue!=undefined){
				var returnvalues = vReturnValue.split(',');
				var id = returnvalues[0].substr(returnvalues[0].indexOf(':')+1);
				var name = returnvalues[1].substr(returnvalues[1].indexOf(':')+1);
				refreshData(id);
       }
       }
       function toAdd(trid){
			var obj = new Object();
			var ids=getSelIds('rdo_entity_id');
			var vReturnValue = window.showModalDialog('<%=contextPath%>/mat/multiproject/plan/planDG/selectMatList.jsp?ids='+ids,obj,'dialogWidth=1024px;dialogHigth=400px');
			if(vReturnValue!=undefined){

				var plannum=document.getElementById("plannum").value;
								
				if(plannum==""){
					var myDate = new Date();
					  //计划编号
					 var plannum="WZGY_"+Math.floor(myDate.getTime()/1000);   
					 document.getElementById("plannum").value=plannum;
				}
				var returnvalues = vReturnValue.split('~');
				var wzId = returnvalues[0].substr(returnvalues[0].indexOf(':')+1);
				var wzIds = wzId.split(',');
				for(var i=0;i<wzIds.length;i++){
					addData(wzIds[i]);
					}
				}
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
						tbObj.selectedRow=this.orderNum;
						
						
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
		var flag = true;
		var tab =document.getElementById("queryRetTable");
		var totalMoney=0;
		var outNum=0;
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
			var cell_6 = row[i].cells[6].firstChild.value;
			if(row[i].cells[0].firstChild.checked==true){
				if(cell_6!=undefined && cell_7!=undefined){
					debugger;
						if(cell_7==""){
							outNum=0;
							}
						else{
							outNum=cell_7;
							}
						
						if(cell_6==""){
							wzPrice=0;
							}
						else{
							wzPrice=cell_6;
							}
					row[i].cells[8].firstChild.value=Math.round((outNum*wzPrice)*1000)/1000;
					totalMoney+=Math.round((outNum*wzPrice)*1000)/1000;
				}
			}
		}
		document.getElementById("total_money").value=Math.round((totalMoney)*1000)/1000;
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
	function getTimes(){
		var tab =document.getElementById("queryRetTable");
		var row = tab.rows;
		for(var i=1;i<row.length;i++){
			var cell_7 = row[i].cells[7].innerHTML;
			var times = document.getElementById("times").value;
			if(cell_7!=undefined){
					if(cell_7=='&nbsp;'){
						cell_7=0;
						row[i].cells[8].firstChild.value = cell_7*times;
						}
					else{
						row[i].cells[8].firstChild.value = cell_7*times;
						}
				
		}
		}
	}
	function checkText(){


		var plannum=document.getElementById("plannum").value;
		var input_org = document.getElementById("input_org").value;
		if(plannum==""){
			var myDate = new Date();
			  //计划编号
			 var plannum="WZGY_"+Math.floor(myDate.getTime()/1000);   
			 document.getElementById("plannum").value=plannum;
		}
		if(input_org==""){
			alert("请选择项目!");
			return true;
		}
		
		return false;
	}
	function getConRatio(){
		var selectObj = document.getElementById("plan_type"); 
    	document.getElementById("plan_type").innerHTML="";

    	var retObj=jcdpCallService("MatItemSrv","queryConRatio","radioValue=1");	
    	var taskList = retObj.matInfo;
    	for(var i =0; taskList!=null && i < taskList.length; i++){
			selectObj.add(new Option(taskList[i].lable,taskList[i].value),i+1);
    	}
	}
	
	
	//function showDevPage(){
	//	popWindow('<%=contextPath%>/mat/singleproject/warehouseDg/out/matremove/selectProject.jsp?backUrl=/pm/project/multiProject/projectList.jsp&action=view','800:600');
   //}
	 function getMessage(arg){
		 var datas = "";
		 for(var i=0;i<arg.length;i++){
				datas +=arg[i];
				}
		var returnvalues = datas.split('@');
		var name = returnvalues[0].substr(returnvalues[0].indexOf(':')+1);
		var id = returnvalues[1].substr(returnvalues[1].indexOf(':')+1);
		document.getElementById("input_name").value = name;
		document.getElementById("input_org").value = id;
	 }
	 function showDevPage(){
			ret =  window.showModalDialog("<%=contextPath%>/mat/singleproject/warehouseDg/out/matremove/selectProject.jsp?backUrl=/pm/project/multiProject/projectList.jsp&action=view",null,"dialogWidth=800px;dialogHeight=600px");
			if(ret!=null){
				getMessage(ret);
			}				
		}
</script>

</html>

