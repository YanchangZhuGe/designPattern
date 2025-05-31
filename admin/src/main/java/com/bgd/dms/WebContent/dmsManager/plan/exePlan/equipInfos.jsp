<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	//String eqId = request.getParameter("eqId");
	String args = request.getParameter("args");
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
	<title>单据明细</title>
</head>

<body style="background:#cdddef">
	<div id="list_table">
		<div id="table_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
				<tr>
					<td class="bt_info_even" autoOrder="1">序号</td> 
					<td class="bt_info_odd" exp="{device_type}">设备编码</td>
					<td class="bt_info_even" exp="{sum_num}">总数</td>
					<td class="bt_info_odd" exp="{use_num}">使用数量</td>
					<td class="bt_info_even" exp="{idle_num}">闲置数量</td>
					<td class="bt_info_odd" exp="{original_value}">原值（万元）</td>
					<td class="bt_info_even" exp="{net_value}">净值（万元）</td>
					<td class="bt_info_odd" exp="{country}">国内外</td>
					<td class="bt_info_odd" exp="{org_name}">所属单位</td>
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
	cruConfig.queryService = "DemaAndPurcAnalSrv";
	cruConfig.queryOp = "getAnalysisData";
	var path = "<%=contextPath%>";
	var args="<%=args%>";
	// 复杂查询
	function refreshData(){
		var temp = "args="+args;
		//temp+="&orgId="+orgId;
		cruConfig.submitStr = temp;	
		queryData(1);
	}

	refreshData();
</script>