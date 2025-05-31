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
		Long beginDate = startDate.getTime();
		Long endDate = beginDate+(10*24*60*60*1000);
		startDate.setTime(endDate);
		String str = new java.text.SimpleDateFormat("yyyy-MM-dd").format(startDate); 
		UserToken user = OMSMVCUtil.getUserToken(request);
		String teamId = user.getOrgId();
		
		
		
		String wz_name = "";
		String apply_num = "";
		String submit_num = "";
		String note = "";
		String project_info_no = "";
		String plan_id = request.getParameter("plan_id");
		String sql = "select * from gms_mat_demand_rough_detail t join gms_mat_demand_plan_rough r on t.plan_id = r.plan_id and r.bsflag='0'  where detail_id='"+plan_id+"'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		if(map!=null){
			wz_name = (String)map.get("wzName");
			apply_num = (String)map.get("applyNum");
			submit_num = (String)map.get("submitNum");
			note = (String)map.get("note");
			project_info_no = (String)map.get("projectInfoNo");
		}
		
		
		
		
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
<title>无标题文档</title>
</head>

<body   onload="" class="odd_odd">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" align="center">
		<div id="new_table_box_content"> 
			<div id="new_table_box_bg">
			<input type='hidden' name='plan_id' id='plan_id' value='<%=plan_id%>'/>
			<input type='hidden' name='project_info_no' id='project_info_no' value='<%=project_info_no%>'/>
		  	<input type='hidden' name='laborId' id='laborId' value=''/>
		  	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						  <tr>
						  	<td class="inquire_item4">名称规格型号:</td>
						   	<td class="inquire_form4"><input name="wz_name" id="wz_name" type="text" class="input_width" value="<%=wz_name %>" readonly="readonly"/>
						   	</td>
						  	<td class="inquire_item4">申请数量:</td>
						   	<td class="inquire_form4">
						   		<input name="apply_num" id="apply_num" type="text" class="input_width" value="<%=apply_num %>" readonly="readonly"/>
						   	</td>
						  </tr>
						  <tr>
						  <td class="inquire_item4">审批数量:</td>
						   	<td class="inquire_form4">
						   		<input name="apply_num" id="apply_num" type="text" class="input_width" value="<%=submit_num %>" readonly="readonly"/>
						   	</td>
							<td class="inquire_item4"></td>
						   	<td class="inquire_form4"></td>
						   	</tr>
						   	<tr>
						   	<td class="inquire_item4">执行记录:</td>
						   	<td class="inquire_form4" colspan="3">
						   		<textarea name="note" id="note" type="text" class="textarea"  readonly="readonly"><%=note %></textarea>
						   	</td>
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
			      <td class="bt_info_odd" exp="<input name = 'rdo_entity_id'  type='checkbox' checked='true' value='{wz_id}' onclick='loadDataDetail()'/>" ><input type='checkbox' name='rdo_entity_id' value='' onclick='check()'/></td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{wz_id}">物资编码</td>
			      <td class="bt_info_even" exp="{coding_code_id}">分类编码</td>
			      <td class="bt_info_odd" exp="{wz_name}">资源名称</td>
			      <td class="bt_info_even" exp="{wz_prickie}">计量单位</td>
			      <td class="bt_info_odd" exp="<input name='wz_price_{wz_id}'  type='text' value='{wz_price}' onkeyup='loadDataDetail()' readonly/>">参考单价</td>
			      <td class="bt_info_even" exp="<input name='demand_num_{wz_id}'  type='text' value='{unit_num}' onkeyup='loadDataDetail()'/>" >需求数量</td>
			      <td class="bt_info_odd" exp="<input name='demand_money_{wz_id}'  type='text' value='' readonly/>" >金额</td>
	<!-- 	      <td class="bt_info_even" exp="<input name='demand_date_{wz_id}' id='demand_date_{wz_id}' type='text' value='<%=str %>'/><img src='<%=contextPath%>/images/calendar.gif'id='tributton_{wz_id}' width='16' height='16' style='cursor: hand;' onmouseover='calDateSelector(demand_date_{wz_id},tributton_{wz_id});'/>" >需求日期 </td>
			      <td class="bt_info_odd" exp="<input name='note_{wz_id}'  type='text' value=''/>" >备注</td>
	 -->		
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
		  ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				alert("请选择一条记录!");
				return;
			}
			else{
				document.getElementById("laborId").value = ids;
				document.getElementById("form1").action="<%=contextPath%>/mat/singleproject/plan/savePlanProject.srq";
				openMask();
				document.getElementById("form1").submit();
				}
			
	 }  
       function toAdd(trid){
			var obj = new Object();
			var ids=getSelIds('rdo_entity_id');
			var vReturnValue = window.showModalDialog('<%=contextPath%>/mat/singleproject/plan/selectMatList.jsp?ids='+ids,obj,'dialogWidth=1024px;dialogHigth=400px');
			if(vReturnValue!=undefined){
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
		var tab =document.getElementById("queryRetTable");
		var totalMoney=0;
		var outNum=0;
		var wzPrice=0;
		var totalMoney=0;
		var row = tab.rows;
		var obj = event.srcElement;
		for(var i=1;i<row.length;i++){
			var cell_6 = row[i].cells[6].firstChild.value;
			var cell_7 = row[i].cells[7].firstChild.value;
			if(row[i].cells[0].firstChild.checked==true){
				if(cell_6!=undefined && cell_7!=undefined){
					
						if(cell_6=='&nbsp;'){
							outNum=0;
							}
						else{
							outNum=cell_6;
							}
						
						if(cell_7==""){
							wzPrice=0;
							}
						else{
							wzPrice=cell_7;
							}
					row[i].cells[8].firstChild.value=Math.round((outNum*wzPrice)*1000)/1000;
				}
			}
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
	 function openMask(){
			$( "#dialog-modal" ).dialog({
				height: 140,
				modal: true,
				draggable: false
			});
		}
</script>

</html>

