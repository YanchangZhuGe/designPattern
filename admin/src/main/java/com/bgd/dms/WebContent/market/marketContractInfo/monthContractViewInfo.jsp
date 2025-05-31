<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgName = request.getParameter("orgName");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/js/bgpmcs/DivHiddenOpen.js"></script>
<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>
<%@ include file="/common/pmd_list.jsp"%>
<title><%=orgName %>合同台账</title>
</head>
<script language="javaScript">
<!--Remark JavaScript定义-->
var pageTitle = "详细信息";
cruConfig.contextPath =  "<%=contextPath%>";
  	
  	function JcdpButton0OnClick(){
  		window.history.back();
  	}
  	
  	
  
function page_init(){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "select ca.contract_id, ca.contract_no, ca.contract_name, ca.parta_org, ca.contract_type, ca.contract_money, ca.workload, ca.unit_price, ca.signed_date, ca.contract_start_date, ca.contract_end_date, oi.org_abbreviation org_name, decode(ca.market_type, '1', '区内', '区外') market_type, ca.memo from bgp_market_contract_account ca inner join comm_org_information oi on ca.undertaking_org = oi.org_id and oi.bsflag='0' inner join comm_org_subjection os on oi.org_id=os.org_id and os.bsflag='0' where os.org_subjection_id like '${param.orgSubjectionId}%' and ca.bsflag='0' order by ca.signed_date desc,ca.modifi_date desc";
	cruConfig.currentPageUrl = "/market/marketContractInfo/monthContractViewInfo.lpmd";
	queryData(1);
}

</script>

<script type="text/javascript" src="/BGPMCS/js/calendar.js"></script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
<script type="text/javascript" src="/BGPMCS/js/calendar-setup.js"></script>

</head>
<body onload="page_init()">
<!--Remark 查询指示区域-->
<div id="rtToolbarDiv">
<table border="0"  cellpadding="0"  cellspacing="0"  class="rtToolbar"  width="100%" >
	<tr>
		<td align="right" >
			<span id="dataRowHint">第0/0页,共0条记录 </span>
			<table id="navTableId" border="0"  cellpadding="0"  cellspacing="0" style="display:inline">
				<tr>
					<td><img src="<%=contextPath%>/images/table/firstPageDisabled.gif"  style="border:0"  alt="First" /></td>
					<td><img src="<%=contextPath%>/images/table/prevPageDisabled.gif"  style="border:0"  alt="Prev" /></td>
					<td><img src="<%=contextPath%>/images/table/nextPageDisabled.gif"  style="border:0"  alt="Next" /></td>
					<td><img src="<%=contextPath%>/images/table/lastPageDisabled.gif"  style="border:0"  alt="Last" /></td>				
				</tr>
			</table>
			<span>到&nbsp;<input type="text"  id="changePage"  class="rtToolbar_chkboxme">&nbsp;页<a href='javascript:changePage()'><img src='<%=contextPath%>/images/table/bullet_go.gif' alt='Go' align="absmiddle" /></a></span>		
		</td>
	</tr>
</table>
</div>

<div id="resultable"  style="width:100%; overflow-x:scroll ;" >
<table border="0"  cellspacing="0"  cellpadding="0"  class="form_info"  width="100%" id="queryRetTable">
	<thead>

	<tr class="bt_info">
		<td class="tableHeader" 	 exp="<input type='radio' name='chx_entity_id' value='{contract_id}'>">选择</td>
		<td class="tableHeader"     exp="{contract_no}">合同编号<br>/自编号</td>
		<td class="tableHeader"  exp="{contract_name}">项目名称</td>
		<td class="tableHeader" 	 exp="{parta_org}">甲方单位</td>
		<td class="tableHeader" 	 exp="{org_name}">合同执行<br>单位</td>
		<td class="tableHeader" 	 exp="{contract_type}">合同类型</td>
		<td class="tableHeader" 	 exp="{contract_money}">合同额<br>(万元)</td>
		<td class="tableHeader" 	 exp="{workload}">工作量<br>(2D/3D)</td>
		<td class="tableHeader" 	 exp="{unit_price}">单价<br>(万元)</td>
		<td class="tableHeader" 	 exp="{signed_date}">合同签订<br>日期</td>
		<td class="tableHeader" 	 exp="{contract_start_date}">项目启动<br>日期</td>
		<td class="tableHeader" 	 exp="{contract_end_date}">项目结束<br>日期</td>
		<td class="tableHeader" 	 exp="{market_type}">市场<br>区内/外</td>
	</tr>
	</thead>
	<tbody>
	
	</tbody>
</table>
</div>
</body>
</html>
