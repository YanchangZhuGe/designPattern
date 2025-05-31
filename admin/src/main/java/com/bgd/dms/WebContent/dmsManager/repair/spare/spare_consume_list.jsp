<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="java.util.Date"%>
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
	String startDate = request.getParameter("startDate");
	if(null==startDate){
		startDate = new java.text.SimpleDateFormat("yyyy").format(new Date())+"-01-01";
	}
	String endDate = request.getParameter("endDate");
	if(null==endDate){
		endDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<title>备件消耗列表</title>
</head>

<body style="background:#cdddef">
<input id="export_name" name="export_name" value="备件消耗列表" type='hidden' />
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="6"><img src="/DMS/images/list_13.png" width="6" height="36" /></td>
				<td background="/DMS/images/list_15.png">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>	          			
							<td>&nbsp;</td>
							<td class='ali_btn'><span class='dc'><a href='####' onclick='exportData()'  title='导出excel'></a></span></td>
						</tr>
					</table>
				</td>
				<td width="4"><img src="/DMS/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
		</div>
		<div id="table_box">
			<table width="98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
				<tr>
					<td class="bt_info_even" autoOrder="1">序号</td> 
					<td class="bt_info_odd" exp="{wz_id}">物料编号</td>
					<td class="bt_info_even" exp="{coding_code_id}">物料组</td>
					<td class="bt_info_odd" exp="{wz_name}">物资名称</td>
					<td class="bt_info_even" exp="{material_unit}">单位</td>
					<td class="bt_info_odd" exp="{unit_price}">单价</td>
					<td class="bt_info_even" exp="{amout}">数量</td>
					<td class="bt_info_even" exp="{stock_money}">消耗金额</td>
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{self_num}">自编号</td>
					<td class="bt_info_odd" exp="{create_date}">消耗时间</td>
				</tr>
			</table>
		</div>
		<div id="fenye_box" style="display:block">
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
		$("#table_box").css("height",$(window).height()-$("#fenye_box").height()-$("#inq_tool_box").height()-1);
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
	cruConfig.queryOp = "querySpareConsumeList";
	cruConfig.pageSize="10";
	var path = "<%=contextPath%>";
	var orgSubId="<%=orgSubId%>";
	var matType="<%=matType%>";
	var dataSource="<%=dataSource%>";
	var startDate="<%=startDate%>";
	var endDate="<%=endDate%>";
	// 复杂查询
	function refreshData(orgSubId1,matType1,dataSource1,startDate1,endDate1){
		var temp = "orgSubId="+orgSubId1+"&matType="+matType1+"&dataSource="+dataSource1+"&startDate="+startDate1+"&endDate="+endDate1;
		cruConfig.submitStr = temp;	
		queryData(1);
	}
	refreshData(orgSubId,matType,dataSource,startDate,endDate);
	//双击事件
	function dbclickRow(ids){	
	}
</script>
</html>

