<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String cpApplyId = request.getParameter("cpApplyId");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<title>采购单据明细列表</title>
</head>

<body style="background:#cdddef">
	<div id="list_table">
		<div id="table_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
				<tr>
					<td class="bt_info_even" autoOrder="1" exp="<input type='hidden' value='ids_{dms_cg_apply_detail_id}' id='{dms_cg_apply_detail_id}'/>">序号</td> 
					<td class="bt_info_odd" exp="{line_num}">行号</td>
					<td class="bt_info_even" exp="{line_type_name}">行类型</td>
					<td class="bt_info_odd" exp="{dev_coding}">设备编码</td>
					<td class="bt_info_even" exp="{material_code}">物资编码</td>
					<td class="bt_info_odd" exp="{material_desc}">物料说明</td>
					<td class="bt_info_even" exp="{material_group}">物料组</td>
					<td class="bt_info_odd" exp="{amount}">数量</td>
					<td class="bt_info_even" exp="{meas_unit}">计量单位</td>
					<td class="bt_info_odd" exp="{unit_price}">单价</td>
					<td class="bt_info_even" exp="{currency}">币种</td>
					<td class="bt_info_odd" exp="{amount_money}">金额</td>
				</tr>
			</table>
		</div>
		<div id="fenye_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
						</label>
					</td>
					<td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				</tr>
			</table>
		</div>
	</div>
</body>
<script type="text/javascript">
	function frameSize(){
		$("#table_box").css("height",$(window).height()-$("#fenye_box").height());
	}
	$(function(){
		frameSize();
		$(window).resize(function(){
	  		frameSize();
		});
	});
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "PurchaseSrv";
	cruConfig.queryOp = "queryCgApplyDetailList";
	var cpApplyId="<%=cpApplyId%>";
	// 复杂查询
	function refreshData(){
		var temp = "cpApplyId="+cpApplyId;
		cruConfig.submitStr = temp;	
		queryData(1);
	}

	refreshData();
</script>
</html>

