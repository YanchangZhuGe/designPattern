<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String  corpId = request.getParameter("corpId");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/css/bgpmcs_table_ma.css" rel="stylesheet" type="text/css" />
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
var reportType = new Array(
['周报','周报'],['月报','月报'],['季报','季报']
);

var monthSel = new Array(
['一月','一月'],['二月','二月'],['三月','三月'],['四月','四月'],['五月','五月'],['六月','六月'],['七月','七月'],['八月','八月'],['九月','九月'],['十月','十月'],['十一月','十一月'],['十二月','十二月']
);

var reportOrgId = new Array(
['300','东方地球物理公司'],['306','国际部'],['180','研究院'],['308','海上'],['319','塔里木'],['320','北疆'],['321','吐哈'],['322','敦煌'],['8ad878cd2cf41a23012d02f4e7ec00c3','长庆'],['8ad878cd2cf41a23012d02f53ff000c4','华北'],['8ad878cd2d11f476012d2553db8a0435','新兴物探'],['323','辽河物探'],['309','物化探'],['8ad878cd2e765396012eb2394b5201aa','信息中心'],['8ad878cd2e765396012eb37e23e20215','装备制造'],['8ad878cd2e765396012eb23bf93801ae','天津英洛瓦'],['313','原井中地震'],['181','原东部'],['285','西部前指']
);

var jcdp_codes_items = null;
var jcdp_codes = new Array(
);
  
function page_init(){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.cdtType = 'form';
	cdt_init();
	cruConfig.queryStr = "select d.*,s.org_name from MM_HISTORY_REPORT d,SM_ORG s where d.bsflag='0' and s.org_id='<%=corpId%>' and d.corp_id=s.org_id order by to_number(d.record_year) desc, decode(d.month, '一月', 1, '二月', 2, '三月', 3, '四月', 4, '五月', 5, '六月', 6, '七月', 7, '八月', 8, '九月', 9, '十月', 10, '十一月', 11, '十二月', 12) desc";
	cruConfig.currentPageUrl = "/market/reportPage/reportPageList.lpmd";
	    cruConfig.pageSize='10';
	queryData(1);
}

var fields = new Array();
fields[0] = ['record_year','年度','TEXT'];
fields[1] = ['month','月份','TEXT',,,'SEL_OPs',monthSel];
fields[2] = ['type','类型','TEXT',,,'SEL_OPs',reportType];
	
function basicQuery(){
	var qStr = generateBasicQueryStr();
	cruConfig.cdtStr = qStr;
	queryData(1);
}
function viewLink(history_report_id){
	editUrl = "/market/viewReport.srq?button=view&&reportId="+history_report_id;
	url = cruConfig.contextPath+editUrl+"&amp;backUrl="+cruConfig.currentPageUrl;
	window.open(url,"_report","height=400,width=600");
}
function queryData(targetPage){

	// 设置等待提示
	//querySuccess=false;
	Ext.MessageBox.wait('请等待','处理中');
	//setTimeout(hideStatusBar,1000);
	
	cruConfig.currentPage = targetPage;

	var submitStr = "currentPage="+targetPage+"&pageSize="+cruConfig.pageSize;
	if(cruConfig.funcCode!='') submitStr += "&EP_DATA_AUTH_funcCode="+cruConfig.funcCode;

	var retObject;//alert(cruConfig.queryService);
	if(cruConfig.queryService!=''){//调用服务查询
		if(cruConfig.submitStr!='')submitStr += "&"+cruConfig.submitStr;
		submitStr = encodeURI(submitStr);
		submitStr = encodeURI(submitStr);
		retObject = jcdpCallService(cruConfig.queryService,cruConfig.queryOp,submitStr);
	}
	else{//根据sql查询
		var querySql = cruConfig.queryStr;
		if(cruConfig.cdtStr!=''){
			querySql = "Select * FROM ("+querySql+")TARGET_RET WHERE "+cruConfig.cdtStr;
		}
		submitStr += "&querySql="+querySql;
		submitStr = encodeURI(submitStr);
		submitStr = encodeURI(submitStr);
		var path = cruConfig.contextPath+appConfig.queryListAction;
		retObject = syncRequest('Post',path,submitStr);
	}

	if (retObject.returnCode != "0") return;
	cruConfig.items = retObject.datas;
	cruConfig.totalRows = retObject.totalRows;
	cruConfig.pageSize = retObject.pageSize;
	renderTable(getObj(cruConfig.queryRetTable_id),cruConfig);

	cruConfig.currentPageRlIds = '';

	if(cruConfig.relationedIds!=''){
		var chxs = document.getElementsByName("chx_entity_id");
		for(var i=0;i<chxs.length;i++)
			if(cruConfig.relationedIds.indexOf(chxs[i].value)>=0){
				 chxs[i].checked = true;
				 if(cruConfig.currentPageRlIds=='') cruConfig.currentPageRlIds = chxs[i].value;
				 else cruConfig.currentPageRlIds += ','+chxs[i].value;
			}
	}
	//querySuccess=true;
	Ext.MessageBox.hide();
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
</head>
<body onload="page_init()">
<div style="width: 570px">
<div id="queryDiv" style="display:">
<table  border="0" cellpadding="0" cellspacing="0" class="form_info" id="queryCdtTable" enctype="multipart/form-data">
  <tr class="ali4">
    <td colspan="4"><input type="submit" onclick="classicQuery()" name="search" value="查询" />  <input type="reset" name="reset" value="清除" onclick="clearQueryCdt()"/></td>
  </tr>  
</table>
</div>
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

<div id="resultable"  style="width:100%; " >
<table border="0"  cellspacing="0"  cellpadding="0"  class="form_info"  width="100%" id="queryRetTable">
	<thead>

	<tr class="bt_info">
		<td class="tableHeader" 	 exp="<a href=javascript:viewLink('{history_report_id}') >{title}</font></a>">名称</td>
		<td class="tableHeader" 	 exp="{record_year}">年度</td>
		<td class="tableHeader" 	 exp="{month}">月份</td>
		<td class="tableHeader" 	 exp="{type}">类型</td>
	</tr>
	</thead>
	<tbody>
	
	</tbody>
</table>
</div>
</div>
</body>
</html>
