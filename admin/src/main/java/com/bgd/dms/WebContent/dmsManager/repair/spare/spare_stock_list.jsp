<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String orgSubId = request.getParameter("orgSubId");
	if(null==orgSubId){
		orgSubId="";
	}
	String matType = request.getParameter("matType");
	if(null==matType){
		matType="";
	}
	String dataSource = request.getParameter("dataSource");
	if(null==dataSource){
		dataSource="";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<title>备件库存列表</title>
</head>

<body style="background:#cdddef">
	<div id="list_table">
		<div id="table_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
				<tr>
					<td class="bt_info_even" autoOrder="1">序号</td> 
					<td class="bt_info_odd" exp="{wz_id}">物料编号</td>
					<td class="bt_info_even" exp="{coding_code_id}">物料组</td>
					<td class="bt_info_odd" exp="{wz_name}">物资名称</td>
					<td class="bt_info_even" exp="{wz_prickie}">单位</td>
					<td class="bt_info_even" exp="{stock_place}">库存地点</td>
					<td class="bt_info_odd" exp="{wz_price}">单价</td>
					<td class="bt_info_even" exp="{stock_amount}">库存数量</td>
					<td class="bt_info_odd" exp="{stock_money}">库存金额</td>
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
		$("#table_box").css("height",$(window).height()-$("#fenye_box").height()-1);
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
	cruConfig.queryService = "RepairStatAnalSrv";
	cruConfig.queryOp = "querySpareStockList";
	cruConfig.pageSize="30";
	var path = "<%=contextPath%>";
	var orgSubId="<%=orgSubId%>";
	var matType="<%=matType%>";
	var dataSource="<%=dataSource%>";
	// 复杂查询
	function refreshData(orgSubId1,matType1,dataSource1){
		var temp = "orgSubId="+orgSubId1+"&matType="+matType1+"&dataSource="+dataSource1;
		cruConfig.submitStr = temp;	
		queryData(1);
	}
	refreshData(orgSubId,matType,dataSource);
	//双击事件
	function dbclickRow(ids){	
	}
</script>
</html>

