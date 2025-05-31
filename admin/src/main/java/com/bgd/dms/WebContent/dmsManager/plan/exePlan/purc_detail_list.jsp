<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String purcId = request.getParameter("purcId");
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
					<td class="bt_info_odd" exp="<a href='javascript:void(0);' onclick='showInfo({apply_num})'>{apply_num}</a>">需求计划单号</td>
					<td class="bt_info_even" exp="{org_name}">所属单位</td>
					<td class="bt_info_odd" exp="{contact}">联系人</td>
					<td class="bt_info_even" exp="{phone}">联系方式</td>
					<td class="bt_info_odd" exp="{material_code}">物料编码</td>
					<td class="bt_info_even" exp="{material_desc}">物料描述</td>
					<td class="bt_info_odd" exp="{amount}">数量</td>
					<td class="bt_info_even" exp="{unit}">单位</td>
					<td class="bt_info_odd" exp="{price}">金额/万元</td>
					<td class="bt_info_even" exp="{apply_dnum}">申请文号</td>
					<td class="bt_info_odd" exp="{remark}">备注</td>
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
	cruConfig.queryService = "ExePlanSrv";
	cruConfig.queryOp = "queryPurcDetailList";
	var path = "<%=contextPath%>";
	var purcId="<%=purcId%>";
	// 复杂查询
	function refreshData(){
		var temp = "purcId="+purcId;
		cruConfig.submitStr = temp;	
		queryData(1);
	}

	refreshData();
	//双击事件
	function dbclickRow(ids){	
		//cruConfig.submitStr = "per_id="+ids;	
		//queryData(1);
	}
	//显示需求计划信息根据计划单号
	function showInfo(apply_num){
		popWindow("<%=contextPath%>/dmsManager/plan/exePlan/apply_list.jsp?apply_num="+apply_num);
	}
</script>
</html>

