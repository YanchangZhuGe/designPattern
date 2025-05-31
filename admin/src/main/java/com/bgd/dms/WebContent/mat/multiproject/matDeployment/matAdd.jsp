<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>物资汇总编辑管理</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
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
</head>
<body onload="refreshData()" style="background:#fff" >
<form name="form1" id="form1" method="post" action="">
<input type="hidden" name="project_info_no" id="project_info_no" class="input_width" value="<gms:msg msgTag="matInfo" key="project_info_no" />" />
<input type='hidden' name='invoices_type' id='invoices_type' value='4'/>
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">

  	<tr>
    	<td colspan="4" align="center">在帐物资调剂</td>
    </tr>
    <tr>
    	
    	<td class="inquire_item6">申请单号：</td>
      	<td class="inquire_form6"><input type="text" name="plan_invoice_id" id="plan_invoice_id" class="input_width" value="<gms:msg msgTag="matInfo" key="plan_invoice_id" />" readonly/></td>
      	<td class="inquire_item6">项目名称：</td>
      	<td class="inquire_form6"><input type="text" name="project_name" id="project_name" class="input_width" value="<gms:msg msgTag="matInfo" key="project_name" />" readonly/></td>
      	<td class="inquire_item6">申请单位：</td>
      	<td class="inquire_form6"><input type="text" name="org_name" id="org_name" class="input_width" value="<gms:msg msgTag="matInfo" key="org_name" />" readonly/></td>
    </tr>
    <tr>
      	<td class="inquire_item6">申请人：</td>
      	<td class="inquire_form6"><input type="text" name="user_name" id="user_name" class="input_width" value="<gms:msg msgTag="matInfo" key="user_name" />" readonly/></td>
      	<td class="inquire_item6">申请时间：</td>
      	<td class="inquire_form6"><input type="text" name="compile_date" id="compile_date" class="input_width" value="<gms:msg msgTag="matInfo" key="compile_date" />" readonly/></td>
    </tr>
</table>
<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
    <tr>
    	
    	<td class="inquire_item6">调剂单号：</td>
      	<td class="inquire_form6"><input type="text" name="invoices_no" id="invoices_no" class="input_width" value="" /></td>
      	<td class="inquire_item6">经办人：</td>
      	<td class="inquire_form6"><input type="text" name="operator" id="operator" class="input_width" value="" /></td>
      	<td class="inquire_item6">调剂时间：</td>
      	<td class="inquire_form6"><input type="text" name="input_date" id="input_date" class="input_width" value="" />
      	<img src='<%=contextPath%>/images/calendar.gif'id='tributton_create_date' width='16' height='16' style='cursor: hand;' onmouseover='calDateSelector(input_date,tributton_create_date);'/></td>
    </tr>
    <tr>
      	<td class="inquire_item6">备注：</td>
      	<td class="inquire_form6"><input type="text" name="note" id="note" class="input_width" value="" /></td>
      	<td class="inquire_item6">合计金额：</td>
		<td class="inquire_item6"><input type="text" name="total_money" id="total_money"
			class="input_width"
			value="" readonly/></td>
    </tr>
    
</table>
<div id="inq_tool_box">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="6"><img src="<%=contextPath%>/images/list_13.png"
			width="6" height="36" /></td>
		<td background="<%=contextPath%>/images/list_15.png">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td  align="left">汇总信息</td>
			</tr>
		</table>
		</td>
		<td width="4"><img src="<%=contextPath%>/images/list_17.png"
			width="4" height="36" /></td>
	</tr>
</table>
</div>
<div id="table_box" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input name = 'plan_id_{wz_id}' id='rdo_entity_id' type='checkbox' checked='checked' value='{wz_id}' onclick='loadDataDetail()'/>"><input type='checkbox' name='task_entity_id' value='' onclick='check()'/></td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{coding_code_id}">资源编码</td>
			      <td class="bt_info_even" exp="{wz_name}">名称</td>
			      <td class="bt_info_odd" exp="{use_num}">累计调剂量</td>
			      <td class="bt_info_even" exp="{stock_num}">库存数量</td>
			      <td class="bt_info_odd" exp="<input name='regulate_num_{wz_id}'  type='text' value='{regulate_num}'/>">调剂数量</td>
			      <td class="bt_info_even" exp="<input name='actual_price_{wz_id}'  type='text' value=''/>">调剂单价</td>
			      <td class="bt_info_odd" exp="<input name='total_money_{wz_id}'  type='text' value=''/>">金额</td>
			    </tr>
			  </table>
			</div>
			<table  id="fenye_box_table">
			 
			</table>
    <div id="oper_div">
     	<span class="bc_btn"><a href="#" onclick="openMask();save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
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
    var planInvoiceId = "<gms:msg msgTag="matInfo" key="plan_invoice_id" />";
    function refreshData(){
		//var sql ='';
		//sql += "select m.wz_id,m.coding_code_id,m.wz_name,r.stock_num,t.apply_num,t.regulate_num,u.use_num from gms_mat_demand_plan t inner join (GMS_MAT_INFOMATION m left join (GMS_MAT_RECYCLEMAT_INFO r left join GMS_MAT_RECYCLE_USE_INFO u on r.recyclemat_info=u.recyclemat_info )on m.wz_id=r.wz_id and m.bsflag='0'and r.bsflag='0' )on t.wz_id=m.wz_id and t.plan_invoice_id='"+planInvoiceId+"'";
		cruConfig.queryService = "MatItemSrv";
		cruConfig.queryOp = "getEscLeaf";
		cruConfig.submitStr ="planInvoiceId="+planInvoiceId;
		queryData(1);
	}
	function save(){	
		ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
	    else{
	    document.getElementById("form1").action = "<%=contextPath%>/mat/multiproject/matescrow/saveMatEscEdit.srq?laborId="+ids;
		document.getElementById("form1").submit();
	    }
	}
	 function openMask(){
			$( "#dialog-modal" ).dialog({
				height: 140,
				modal: true,
				draggable: false
			});
		}
	 function loadDataDetail(shuaId){
			var tab =document.getElementById("queryRetTable");
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
				var cell_6 = row[i].cells[6].firstChild.value;
				var cell_7 = row[i].cells[7].firstChild.value;
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
						
					row[i].cells[8].firstChild.value=outNum*wzPrice;
					totalMoney+=parseInt(row[i].cells[8].firstChild.value);
				}
			}
			document.getElementById("total_money").value=totalMoney;
		}
</script>
</html>