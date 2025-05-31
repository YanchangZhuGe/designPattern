<%@ page contentType="text/html;charset=UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String year = request.getParameter("year");
	String orgSubId = request.getParameter("orgSubId");
	String tableFlag = request.getParameter("tableFlag");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<%@include file="/common/include/quotesresource.jsp"%>
	<title>需求采购计划信息</title>
</head>

<body style="background:#cdddef">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td>&nbsp;</td>
					  		</tr>
						</table>
					</td>
				   	<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				</tr>
			</table>
		</div>
		<div id="table_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
				<tr>
				<% if("demand".equals(tableFlag)){%>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{org_name}">所属单位</td> 
					<td class="bt_info_even" exp="{apply_year}">年度</td>
					<td class="bt_info_odd" exp="{apply_num}">申请单号</td>
					<td class="bt_info_even" exp="{apply_dnum}">申请文号</td>
					<td class="bt_info_odd" exp="{dev_type}">物料编码</td>
					<td class="bt_info_even" exp="{dev_name}">物料描述</td>
					<td class="bt_info_odd" exp="{meas_unit}">计量单位</td>
					<td class="bt_info_even" exp="{apply_number}">申请数量</td>
					<td class="bt_info_odd" exp="{asse_price}">评估价格(元)</td>
					<td class="bt_info_even" exp="{mtotal}">总价格(元)</td>
				<%} %>
				<% if("purchase".equals(tableFlag)){%>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{org_name}">所属单位</td> 
					<td class="bt_info_even" exp="{purc_year}">年度</td>
					<td class="bt_info_odd" exp="{purc_num}">采购单号</td>
					<td class="bt_info_even" exp="{apply_num}">申请单号</td>
					<td class="bt_info_odd" exp="{material_code}">物料编码</td>
					<td class="bt_info_even" exp="{material_desc}">物料描述</td>
					<td class="bt_info_odd" exp="{unit}">单位</td>
					<td class="bt_info_even" exp="{amount}">数量</td>
					<td class="bt_info_odd" exp="{price}">金额(元)</td>
					<td class="bt_info_even" exp="{ptotal}">总价格(元)</td>
				<%} %>
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
		$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()- $("#fenye_box").height()-2);
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
	cruConfig.queryService = "DemaAndPurcAnalSrv";
	cruConfig.queryOp = "queryDemaPurcInfoList";
	cruConfig.pageSize="30";
	var year="<%=year%>";
	var orgSubId="<%=orgSubId%>";
	var tableFlag="<%=tableFlag%>";
	// 复杂查询
	function refreshData(){
		var temp = "year="+year+"&orgSubId="+orgSubId+"&tableFlag="+tableFlag;
		cruConfig.submitStr = temp;	
		queryData(1);
	}
	refreshData();
	//双击事件
	function dbclickRow(ids){	
	}

</script>
</html>

