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
<body onload='refreshData()' style="background:#fff">
<form name="form1" id="form1" method="post"
	action="">
<table border="0" cellpadding="0" cellspacing="0"
	class="tab_line_height" width="100%">
	<tr>
    	<td colspan="6" align="center">代管物资入库</td>
    </tr>
	<tr>
		<td class="inquire_item6">入库单号：</td>
		<td class="inquire_item6"><input type="text" name="input_no" id="input_no" class="input_width" value="" readonly="readonly" /></td>
		<td class="inquire_item6">调剂单号：</td>
		<td class="inquire_item6"><input type="text"
			name="invoices_no" id="invoices_no" class="input_width"
			value="" readonly /></td>
		<td class="inquire_item6">日期：</td>
		<td class="inquire_item6"><input type="text"
			name="input_date" id="input_date" class="input_width"
			value="" readonly />
			<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(input_date,tributton1);" /></td>
	</tr>
	<tr>
		<td class="inquire_item6">单位：</td>
		<td class="inquire_item6"><input type="text" name="operator" id="operator"
			class="input_width" value="" /></td>
		<td class="inquire_item6">合计金额：</td>
		<td class="inquire_item6"><input type="text" name="pickupgoods" id="pickupgoods"
			class="input_width"
			value="" /></td>
		<td class="inquire_item6">主管领导：</td>
		<td class="inquire_item6"><input type="text" name="procure_no" id="procure_no"
			class="input_width" value="" /></td>
	</tr>
	<tr>
		<td class="inquire_item6">材料员：</td>
		<td class="inquire_item6"><input type="text" name="storage" id="storage"
			class="input_width" value="" /></td>
		<td class="inquire_item6">保管：</td>
		<td class="inquire_item6"><input type="text" name="storage" id="storage"
			class="input_width" value="" /></td>
		<td class="inquire_item6">备注：</td>
		<td class="inquire_item6"><input type="text" name="note" id="note"
			class="input_width"
			value="<gms:msg msgTag="matInfo" key="describe"/>" /></td>
	</tr>
</table>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right" id="queryRetTable">
			<tr>
				<td class="bt_info_odd" exp="<input name = 'rdo_entity_id'  type='checkbox' checked='true' value='{teammat_info_idetail_id}' onclick='loadDataDetail()'/>" >选择</td>
				<td class="bt_info_even" autoOrder="1">序号</td>
				<td class="bt_info_even" exp="{give_out}">物资编码</td>
				<td class="bt_info_odd" exp="{wz_name}">名称及规格</td>
				<td class="bt_info_even" exp="{wz_prickie}">单位</td>
				<td class="bt_info_odd" exp="{mat_num}">数量</td>
				<td class="bt_info_even" exp="{actual_price}">入库单价</td>
				<td class="bt_info_odd"exp="{total_money}">金额</td>
				<td class="bt_info_odd"exp="{warehouse_number}">库号</td>
				<td class="bt_info_even" exp="{goods_allocation}">货位</td>
				<td class="bt_info_odd" exp="{noteuuu}">备注</td>
			</tr>
		</table>
	</div>
	<table  id="fenye_box_table">
			
			</table>
<div id="oper_div"><span class="bc_btn"><a href="#"
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
	var checkIds="";
	function refreshData(){
		document.getElementById("input_no").value = "<gms:msg msgTag="matInfo" key="input_no"/>";
		document.getElementById("invoices_no").value = "<gms:msg msgTag="matInfo" key="invoices_no"/>";
		document.getElementById("procure_no").value = "<gms:msg msgTag="matInfo" key="procure_no"/>";
		document.getElementById("input_date").value = "<gms:msg msgTag="matInfo" key="input_date"/>";
		var invoicesId="<gms:msg msgTag="matInfo" key="invoices_id"/>";
		var sql ="select i.wz_name,i.wz_prickie,t.teammat_info_idetail_id,t.mat_num,t.actual_price,t.receive_number,t.total_money,t.warehouse_number,t.goods_allocation,t.give_out from GMS_MAT_TEAMMAT_INFO_DETAIL t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag='0' and t.invoices_id = '"+invoicesId+"'and t.project_info_no='<%=projectInfoNo%>'";
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/warehouse/accept/escrow/escLedgerEdit.jsp.jsp";
		queryData(1);
		checkIds=getSelIds('rdo_entity_id');
	}							
	function save(){	
		//if (!checkForm()) return;
		ids = getSelIds('rdo_entity_id');
		document.getElementById("form1").action="<%=contextPath%>/mat/singleproject/warehouse/accept/trac/updateTracLedger.srq?laborId="+ids+"&checkIds="+checkIds;
		document.getElementById("form1").submit();
		
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
	
</script>
</html>