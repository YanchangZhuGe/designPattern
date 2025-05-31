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
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	
	String invoices_id = "";
	Date date = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	String today = sdf.format(date);
	String autoSql = "select invoices_id from gms_mat_out_info t where t.project_info_no='"+ projectInfoNo+ "' and t.bsflag='0' and t.out_type = '1' and t.invoices_id like '"+today+"%' order by invoices_id desc";
	Map  autoMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(autoSql);
	if(autoMap!=null&&autoMap.size()!=0){
		String input_nos = (String)autoMap.get("invoicesId");
		String[] temp = input_nos.split("-");
		String nos = String.valueOf(Integer.parseInt(temp[1])+1);
		if(nos.length()==1){
			nos = "00"+nos;
		}else if(nos.length()==2){
			nos = "0"+nos;
		}
		invoices_id = today + "-" +nos;
	}else{
		invoices_id = today + "-001";
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
<body onload=''>
<form name="form1" id="form1" method="post"
	action="">
<div id="new_table_box">
<div id="new_table_box_content">
<div id="new_table_box_bg">
<table border="0" cellpadding="0" cellspacing="0"
	class="tab_line_height" width="100%">
	<tr>
    	<td colspan="6" align="center">退货</td>
    </tr>
	<tr>
		<td class="inquire_item6">采购订单号：</td>
		<td class="inquire_item6">
		<input type="text" name="procure_name" id="procure_name" class="input_width" value="" readonly="readonly"/>
		<input type="hidden" name="procure_no" id="procure_no" class="input_width" value=""  /><input type='button' style='width:20px' value='...' onclick='showDevPage()'/></td>
		<td class="inquire_item6">退货单号：</td>
		<td class="inquire_item6"><input type="text"
			name="invoices_id" id="invoices_id" class="input_width"
			value="<%=invoices_id %>"  readonly="readonly"/></td>
		<td class="inquire_item6"><font color="red">*</font>制表日期：</td>
		<td class="inquire_item6"><input type="text"
			name="out_date" id="out_date" class="input_width"
			value="" readonly />
			<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(out_date,tributton1);" /></td>
	</tr>
	<tr>
		<td class="inquire_item6">供货商：</td>
		<td class="inquire_item6"><input type="text" name="storeroom" id="storeroom"
			class="input_width" value="" /></td>
		<td class="inquire_item6">采购单位：</td>
		<td class="inquire_item6"><input type="text" name="input_org" id="input_org"
			class="input_width"
			value="" /></td>
		<td class="inquire_item6">采购员：</td>
		<td class="inquire_item6"><input type="text" name="operator" id="operator"
			class="input_width" value="" /></td>
	</tr>
	<tr>
		<td class="inquire_item6">验收员：</td>
		<td class="inquire_item6"><input type="text" name="pickupgoods" id="pickupgoods"
			class="input_width" value="" /></td>
		<td class="inquire_item6">保管员：</td>
		<td class="inquire_item6"><input type="text" name="storage" id="storage"
			class="input_width" value="" /></td>
		<td class="inquire_item6">备注：</td>
		<td class="inquire_item6"><input type="text" name="note" id="note"
			class="input_width"
			value="<gms:msg msgTag="matInfo" key="describe"/>" /></td>
	</tr>
	<tr>
		<td class="inquire_item6">合计金额：</td>
		<td class="inquire_item6"><input type="text" name="total_money" id="total_money"
			class="input_width"
			value="" readonly/></td>
	</tr>
</table>
 	<div id="list_table">
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right" id="queryRetTable" class="tab_info">
			<tr>
				<td class="bt_info_odd" exp="<input name = 'rdo_entity_id'  type='checkbox' checked='true' value='{wz_id}' onclick='loadDataDetail()'/>" >选择</td>
				<td class="bt_info_even" autoOrder="1">序号</td>
				<td class="bt_info_even" exp="{wz_id}">物资编码</td>
				<td class="bt_info_odd" exp="{wz_name}">名称</td>
				<td class="bt_info_even" exp="{wz_prickie}">单位</td>
				<td class="bt_info_odd" exp="{stock_num}">库存数量</td>
				<td class="bt_info_odd" exp="<input type='text' name='mat_num_{wz_id}' id='mat_num_{wz_id}' value='' style='width:40px'/>">退货数量</td>
				<td class="bt_info_even" exp="<input type='text' name='actual_price_{wz_id}' id='actual_price_{wz_id}' value='{actual_price}' style='width:40px'/>">单价</td>
				<td class="bt_info_odd"exp="<input type='text' name='total_money_{wz_id}' id='total_money_{wz_id}' value='{total_money}' style='width:40px'/>">金额</td>
				<td class="bt_info_even"exp="{warehouse_number}">退货库</td>
				<td class="bt_info_odd" exp="{goods_allocation}">货位</td>
			</tr>
		</table>
	</div>
	</div>
	<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
</div>
		
<div id="oper_div"><span class="bc_btn"><a href="#"
	onclick="save()"></a></span> <span class="gb_btn"><a href="#"
	onclick="newClose()"></a></span></div>
</div>
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
<script type="text/javascript"><!--
	cruConfig.contextPath =  "<%=contextPath%>";
	var checkIds="";
	function refreshData(value){
		debugger;
		var sql ="select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num,a.warehouse_number,a.goods_allocation,a.actual_price from(select dd.coding_name, i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num,t.warehouse_number,t.goods_allocation,t.actual_price from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no,aa.warehouse_number,aa.goods_allocation,aa.actual_price from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num,tid.warehouse_number,tid.goods_allocation,tid.actual_price from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.invoices_id='"+value+"' and mti.project_info_no='<%=user.getProjectInfoNo()%>' and mti.if_input='0' and mti.invoices_type='1' group by tid.wz_id,tid.project_info_no,tid.warehouse_number,tid.goods_allocation,tid.actual_price )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='2' and mto.project_info_no='<%=user.getProjectInfoNo()%>' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '<%=user.getProjectInfoNo()%>' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '<%=user.getProjectInfoNo()%>') a order by a.wz_id asc";
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/warehouse/out/retpur/purOut.jsp";
		queryData(1);
		checkIds=getSelIds('rdo_entity_id');
		var tab =document.getElementById("queryRetTable");
		var row = tab.rows;
		for(var i=1;i<row.length;i++){
			if(row[i].cells[6].firstChild.value != undefined){
			row[i].cells[6].firstChild.value=row[i].cells[5].innerHTML;
			}
		}
		loadDataDetail();
	}							
	function save(){	
		//if (!checkForm()) return;
		ids = getSelIds('rdo_entity_id');
		var out_date = document.getElementById("out_date").value;
		if(out_date==""){
			alert("请填写时间!");
			return;
		}
		if(ids==""){
			alert("请选择一条记录!");
			return;
		}
		if(loadDataDetail()){
			document.getElementById("form1").action="<%=contextPath%>/mat/singleproject/warehouse/out/retpur/saveRetPur.srq?laborId="+ids+"&checkIds="+checkIds;
			document.getElementById("form1").submit();
		}
	}
	function showDevPage(){
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/mat/select/template/selectPruId.jsp",obj);
		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split(',');
			var id = returnvalues[0].substr(returnvalues[0].indexOf(':')+1);
			var name = returnvalues[1].substr(returnvalues[1].indexOf(':')+1);
			document.getElementById("procure_no").value = id;
			document.getElementById("procure_name").value = name;
			refreshData(id);
			return id;
   }
   }
	function loadDataDetail(shuaId){
		var tab =document.getElementById("queryRetTable");
		var outNum=0;
		var wzPrice=0;
		var totalMoney=0;
		var bsflag = true;
		var row = tab.rows;
		for(var i=1;i<row.length;i++){
			var cell_6 = row[i].cells[6].firstChild.value;
			var cell_7 = row[i].cells[7].firstChild.value;
			var cell_5 = row[i].cells[5].innerHTML;
			if(cell_6!=undefined && cell_7!=undefined){
			    
					if(cell_6==""){
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
					
					if(cell_5=="&nbsp;"){
						cell_5=0;
					}
					
					if(Number(cell_5)<Number(outNum)){
						alert("退货数量不能大于库存数量!");
						bsflag=false;
						return;
					}
					debugger;
				row[i].cells[8].firstChild.value=Math.round((outNum*wzPrice)*1000)/1000;
				totalMoney+=Number(row[i].cells[8].firstChild.value);
			}
		}
		document.getElementById("total_money").value=Math.round(totalMoney*1000)/1000;
		return bsflag;
	}
</script>
</html>