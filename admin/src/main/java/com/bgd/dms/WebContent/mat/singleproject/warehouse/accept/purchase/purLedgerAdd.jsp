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
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String procure_no = "";
	Date date = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	String today = sdf.format(date);
	String autoSql = "select procure_no from gms_mat_teammat_invoices t where t.project_info_no='"+ projectInfoNo+ "' and t.bsflag='0' and t.invoices_type = '1' and t.procure_no like '"+today+"%' order by procure_no desc";
	Map  autoMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(autoSql);
	if(autoMap!=null&&autoMap.size()!=0){
		String input_nos = (String)autoMap.get("procureNo");
		String[] temp = input_nos.split("-");
		String nos = String.valueOf(Integer.parseInt(temp[1])+1);
		if(nos.length()==1){
			nos = "00"+nos;
		}else if(nos.length()==2){
			nos = "0"+nos;
		}
		procure_no = today + "-" +nos;
	}else{
		procure_no = today + "-001";
	}
	
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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
</head>
<body class="odd_odd">
<form name="form1" id="form1" method="post"
	action="">
	<input type='hidden' name='code_id' id = 'code_id' value='1'/>
<table border="0" cellpadding="0" cellspacing="0"
	class="tab_line_height" width="100%">
	<tr>
    	<td colspan="6" align="center">自采购物资入库</td>
    </tr>
	<tr>
		<td class="inquire_item6">采购单号：</td>
		<td class="inquire_item6"><input type="text"
			name="procure_no" id="procure_no" class="input_width"
			value="<%=procure_no %>"  /></td>
		<td class="inquire_item6">计划单号：</td>
		<td class="inquire_item6"><input type="hidden"name="plan_invoice_id" id="plan_invoice_id" class="input_width" value=""  />
		<input type="text"name="plan_invoice_name" id="plan_invoice_name" class="input_width" value=""  />
		<input type='button' style='width:20px' value='...' onclick='showDevPage()'/></td>
		<td class="inquire_item6"><font color="red">*</font>验收日期：</td>
		<td class="inquire_item6"><input type="text"
			name="input_date" id="input_date" class="input_width"
			value="" readonly />
			<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(input_date,tributton1);" /></td>
	</tr>
	<tr>
		<td class="inquire_item6">经办：</td>
		<td class="inquire_item6"><input type="text" name="operator" id="operator"
			class="input_width" value="" /></td>
		<td class="inquire_item6">提货人：</td>
		<td class="inquire_item6"><input type="text" name="pickupgoods" id="pickupgoods"
			class="input_width"
			value="" /></td>
		<td class="inquire_item6">保管：</td>
		<td class="inquire_item6"><input type="text" name="storage" id="storage"
			class="input_width" value="" /></td>
	</tr>
	<tr>
		<td class="inquire_item6">供货商：</td>
		<td class="inquire_item6"><input type="text" name="source" id="source"
			class="input_width" value="" /></td>
		<td class="inquire_item6">自提车辆编号：</td>
		<td class="inquire_item6"><input type="text"
			name="vehicle_no" id="vehicle_no" class="input_width"
			value=""  /></td>
		<td class="inquire_item6">铁路运单号：</td>
		<td class="inquire_item6"><input type="text"
			name="waybill_no" id="waybill_no" class="input_width"
			value=""  /></td>
	</tr>
	<tr>
		<td class="inquire_item6">备注：</td>
		<td class="inquire_item6"><input type="text" name="note" id="note"
			class="input_width"
			value="<gms:msg msgTag="matInfo" key="describe"/>" /></td>
		<td class="inquire_item6">供应商信息：</td>
		<td class="inquire_item6"><input type="text" name="supplier" id="supplier" class="input_width" value="" /></td>	
		<td class="inquire_item6">金额：</td>
		<td class="inquire_item6"><input type="text" name="total_money" id="total_money" class="input_width" value="" /></td>	
	</tr>
</table>
<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
			    <!--  
			    <td><auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton></td>
			    -->
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
	<div id="table_box" >
					<table width="100%" border="0" cellspacing="0" cellpadding="0" id="queryRetTable" style="overflow:scroll;">
						<tr>
							<td class="bt_info_odd" exp="<input name = 'rdo_entity_id'  type='checkbox' checked='true' value='{wz_id}' onclick='loadDataDetail()'/>" >选择</td>
							<td class="bt_info_even" autoOrder="1">序号</td>
							<td class="bt_info_odd" exp="{wz_id}">物资编号</td>
							<td class="bt_info_odd" exp="<input name='invoice_num_{wz_id}' type='text' style='width:50px' value=''/>">发票号</td>
							<td class="bt_info_even" exp="{wz_name}">名称</td>
							<td class="bt_info_odd" exp="{wz_prickie}">计量单位</td>
							<td class="bt_info_even"
								exp="<input name='mat_num_{wz_id}'  type='text' style='width:50px' value='{demand_num}'  onkeyup='checkNum()'/>">数量</td>
							<td class="bt_info_odd"
								exp="<input name='actual_price_{wz_id}' type='text' style='width:50px' value='{wz_price}' onkeyup='checkNum()'/>">入库单价</td>
								<td class="bt_info_even" exp="<input name='total_money_{wz_id}' type='text' style='width:50px' value=''/>">金额</td>
								<td class="bt_info_odd" exp="<input name='warehouse_number_{wz_id}' type='text' style='width:50px' value=''/>">收料库</td>
								<td class="bt_info_even" exp="<input name='goods_allocation_{wz_id}' type='text' style='width:50px' value=''/>">货位</td>
						</tr>
					</table>
	</div>
	
	<table id="fenye_box_table">
		 
	</table>
<div id="oper_div"><span class="bc_btn"><a id="submitButton"  href="#"
	onclick="save()"></a></span> <span class="gb_btn"><a href="#"
	onclick="newClose()"></a></span></div>
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
	cruConfig.queryService = "MatItemSrv";
	cruConfig.queryOp = "getMatLeaf";
	function refreshData(id){
			cruConfig.submitStr ="codeId="+id;
			queryData(1);
	}							
	function save(){	
		//if (!checkForm()) return;
		ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				alert("请选择一条记录!");
				return;
			}
		var input_date = document.getElementById("input_date").value;
		if(input_date==""){
			alert("验收日期不能为空!");
			return;
		}
		document.getElementById("form1").action="<%=contextPath%>/mat/singleproject/warehouse/accept/purchase/saveMatLedger.srq?laborId="+ids;
		document.getElementById("form1").submit();
		document.getElementById("submitButton").onclick = "";
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
			            tab.deleteRow(j+1);
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
	function showDevPage(){
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/mat/singleproject/warehouse/accept/purchase/selectPlanList.jsp",obj);
		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split(',');
			var id = returnvalues[0].substr(returnvalues[0].indexOf(':')+1);
			var name = returnvalues[1].substr(returnvalues[1].indexOf(':')+1);
			document.getElementById("plan_invoice_id").value = id;
			document.getElementById("plan_invoice_name").value = name;
			refreshData(id);
			checkNum();
   }
   }
	function checkNum(){
		var tab =document.getElementById("queryRetTable");
		var outNum=0;
		var wzPrice=0;
		var totalMoney=0;
		var row = tab.rows;
		for(var i=1;i<row.length;i++){
			var cell_6 = row[i].cells[6].firstChild.value;
			var cell_7 = row[i].cells[7].firstChild.value;
			var cell_0 = row[i].cells[0].firstChild.checked;
			if(cell_0 == true){
				if(cell_7!=undefined &&cell_6!=undefined){
					
						if(cell_7==""){
							wzPrice=0;
							}
						else{
							wzPrice=cell_7;
							}
						if(cell_6==""){
							cell_6=0;
							}
						else{
							outNum = cell_6;
							}
					
					row[i].cells[8].firstChild.value=Math.round((outNum*wzPrice)*1000)/1000;
					totalMoney+=Math.round((outNum*wzPrice)*1000)/1000;
				}
			}
		}
		document.getElementById("total_money").value=Math.round(totalMoney*1000)/1000;
		}
</script>
</html>