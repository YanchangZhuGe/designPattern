<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
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
<title>列表页面</title>
</head>
<script language="javaScript">
<!--Remark JavaScript定义-->
var pageTitle = "";
cruConfig.contextPath =  "<%=contextPath%>";
var contractType = new Array(
['1','区内'],['2','区外']
);

var jcdp_codes_items = null;
var jcdp_codes = new Array(
);


	  function toAdd(){
	  		editUrl = "/market/contractPage/addContract.jsp?action=0";
			window.location=cruConfig.contextPath+editUrl+"&backUrl="+cruConfig.currentPageUrl;
		}
  	function toEdit(){
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	    var tempa = ids.split(',');
    	var contract_id = tempa[0];
   		var contract_name = tempa[1];
	    	editUrl = "/market/editContract.srq?contractId="+contract_id; 
	    	window.location=cruConfig.contextPath+editUrl; 
	}
	
	function toDelete(){
	 ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	    var tempa = ids.split(',');
    	var contract_id = tempa[0];
   		var contract_name = tempa[1];
	deleteEntities("update bgp_market_contract_account set bsflag='1' where contract_id='{id}'");
	var title = "在合同台账维护中删除了一条项目名称为：“"+contract_name+"”的信息";
	var operationPlace = "合同台账维护";
	var submitStr = "title="+encodeURI(encodeURI(title))+"&operationPlace="+encodeURI(encodeURI(operationPlace));
	var retObject=jcdpCallService("MarketInfoInputSrv","logDelete",submitStr);
	queryData(1);
}
	
	function viewLink(contract_id){
	    	editUrl = "/market/contractPage/viewContract.upmd?id="+contract_id;
	    	window.location=cruConfig.contextPath+editUrl+"&backUrl="+cruConfig.currentPageUrl;
		}
  
function page_init(){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.cdtType = 'form';
	cdt_init();
	cruConfig.queryStr = "select t.contract_id,        t.contract_name,        t.parta_org,        t.undertaking_org,        t.contract_money,        t.signed_people,        t.signed_date,        t.perform_time,        t.perform_place,        t.contract_no,        t.contract_type,        t.contract_start_date,        t.contract_end_date,        t.workload,        t.unit_price,        c.org_abbreviation,        decode(t.market_type, '1', '区内', '2', '区外') as market_type   from bgp_market_contract_account t, comm_org_information c  where t.undertaking_org = c.org_id    and t.bsflag = '0' order by t.signed_date desc,t.modifi_date desc ";
	cruConfig.currentPageUrl = "/market/contractPage/contractPageList.lpmd";
	queryData(1);
}

var fields = new Array();
fields[0] = ['contract_name','合同名称','TEXT'];
fields[1] = ['market_type','(区内/区外)市场','TEXT',,,'SEL_OPs',contractType];
	
function basicQuery(){
	var qStr = generateBasicQueryStr();
	cruConfig.cdtStr = qStr;
	queryData(1);
}


function cmpQuery(){
	var qStr = generateCmpQueryStr();
	cruConfig.cdtStr = qStr;
	queryData(1);
}

function classicQuery(){
	var qStr = generateClassicQueryStr();
	cruConfig.cdtStr = qStr;
	queryData(1);
}

function onlineEdit(rowParams){
	var path = cruConfig.contextPath+cruConfig.editAction;
	var params = cruConfig.editTableParams+"&rowParams="+JSON.stringify(rowParams);
	var retObject = syncRequest('Post',path,params);
	if(retObject.returnCode!=0){
		alert(retObject.returnMsg);
		return false;
	}else return true;
}

</script>

<script type="text/javascript" src="/BGPMCS/js/calendar.js"></script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
<script type="text/javascript" src="/BGPMCS/js/calendar-setup.js"></script>
<style>
.class1{
width:80px;
}
.class2{
width:210px;
}
.class3{
width:100px;
}
.class4{
width:55px;
}
.class5{
width:70px;
}
.class6{
width:60px;
}
.class6{
width:50px;
}
</style>
</head>
<body onload="page_init()">
<div id="queryDiv" style="display:">
<table  border="0" cellpadding="0" cellspacing="0" class="form_info" id="queryCdtTable" enctype="multipart/form-data">
  <tr class="ali4">
    <td colspan="4"><input type="submit" onclick="classicQuery()" name="search" value="查询"  class="iButton2"/>  <input type="reset" name="reset" value="清除" onclick="clearQueryCdt()" class="iButton2"/></td>
  </tr>  
</table>
</div>
<table  border="0" cellpadding="0" cellspacing="0" class="Tab_new_mod_del">
  <tr class="ali7">
    <td>
<input class="iButton2" type="button" value="新增" onClick="toAdd()">
<input class="iButton2" type="button" value="修改" onClick="toEdit()">
<input class="iButton2" type="button" value="删除" onClick="toDelete()">
    </td>
  </tr>
</table>
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
		<td class="tableHeader" 	 exp="<input type='radio' name='chx_entity_id' value='{contract_id},{contract_name}'>">选择</td>
		<td class="tableHeader" 	 exp="{contract_no}">合同编号<br>/自编号</td>
		<td class="tableHeader" 	 exp="<a href=javascript:viewLink('{contract_id}') >{contract_name}</a>">项目名称</td>
		<td class="tableHeader" 	 exp="{parta_org}">甲方单位</td>
		<td class="tableHeader" 	 exp="{org_abbreviation}">合同执行<br>单位</td>
		<td class="tableHeader" 	 exp="{contract_type}">合同类型</td>
		<td class="tableHeader" 	 exp="{contract_money}">合同额<br>(万元)</td>
		<td class="tableHeader" 	 exp="{workload}">工作量<br>(2D/3D)</td>
		<td class="tableHeader"  	 exp="{unit_price}">单价<br>(万元)</td>
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
