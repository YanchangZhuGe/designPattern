<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String userName=user.getUserName();
	String userId = resultMsg.getValue("userId");
	String orgId = resultMsg.getValue("orgId");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/images/ma/weekStyle.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/js/bgpmcs/DivHiddenOpen.js"></script>
<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>
<%@ include file="/common/pmd_list.jsp"%>
<title>历史数据维护</title>

<style>
.class1{
text-align:left;
padding-left: 15px;
}
</style>
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
['300','东方地球物理公司'],['306','国际勘探事业部'],['180','研究院'],['308','大港物探处'],['319','塔里木物探处'],['320','新疆物探处'],['321','吐哈物探处'],['322','青海物探处'],['8ad878cd2cf41a23012d02f4e7ec00c3','长庆物探处'],['8ad878cd2cf41a23012d02f53ff000c4','华北物探处'],['8ad878cd2d11f476012d2553db8a0435','新兴物探开发处'],['323','辽河物探处'],['309','综合物化探'],['8ad878cd2e765396012eb2394b5201aa','信息中心'],['8ad878cd2e765396012eb37e23e20215','装备制造'],['8ad878cd2e765396012eb23bf93801ae','天津英洛瓦'],['313','原井中地震'],['181','原东部'],['285','西部前指']
);

var jcdp_codes_items = null;
var jcdp_codes = new Array(
);


  	function toAdd(){
  		editUrl = "/market/reportPage/addHistoryReport.jsp?action=0&orgId=<%=orgId%>";
		window.location=cruConfig.contextPath+editUrl+"&backUrl="+cruConfig.currentPageUrl;
	}
  
  	function toEdit(){
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	    var tempa = ids.split(',');
	    var history_report_id = tempa[0];
	    
	    editUrl = "/market/editReport.srq?reportId="+history_report_id+"&orgId=<%=orgId%>"; 
	   	window.location=cruConfig.contextPath+editUrl; 
	}	
	function viewLink(history_report_id){
	    	editUrl = "/market/viewReport.srq?reportId="+history_report_id+"&orgId=<%=orgId%>";
	    	window.location=cruConfig.contextPath+editUrl+"&backUrl="+cruConfig.currentPageUrl;
		}
  
function page_init(){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.cdtType = 'form';
	cruConfig.pageSize = 10;
	cdt_init();
	cruConfig.queryStr = "select d.*,s.org_name from MM_HISTORY_REPORT d,SM_ORG s where d.bsflag='0' and d.corp_id=s.org_id and  s.org_id='<%=orgId%>' order by to_number(d.record_year) desc, decode(d.month, '一月', 1, '二月', 2, '三月', 3, '四月', 4, '五月', 5, '六月', 6, '七月', 7, '八月', 8, '九月', 9, '十月', 10, '十一月', 11, '十二月', 12) desc";
	cruConfig.currentPageUrl = "/market/reportPage/reportPageList.lpmd";
	queryData(1);
}

function toDelete(){
	ids = getSelIds('chx_entity_id');
    if(ids==''){ alert("请先选中一条记录!");
     return;
    } 
    var tempa = ids.split(',');
    
    var history_report_id = tempa[0];
   	var name = tempa[1];
   	var record_year = tempa[2];
   	var month = tempa[3];
	
	deleteEntities("update MM_HISTORY_REPORT set bsflag='1' where history_report_id='{id}'");
	
	var title = "在历史数据维护中删除了一条"+record_year+"年"+month+"名称为：“"+name+"”的信息"
	var operationPlace = "历史数据维护";
	var submitStr = "title="+encodeURI(encodeURI(title))+"&operationPlace="+encodeURI(encodeURI(operationPlace));
	var retObject=jcdpCallService("MarketInfoInputSrv","logDelete",submitStr);
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
function linkThirdList(orgId){
	window.location="<%=contextPath%>/market/startReport.srq?orgId="+orgId;
}
</script>

<script type="text/javascript" src="/BGPMCS/js/calendar.js"></script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
<script type="text/javascript" src="/BGPMCS/js/calendar-setup.js"></script>
</head>
<body onload="page_init()">
<div id="right_div_left">
     <div id="gl_left_botbox" style="margin-left: 10px">
    	<div class="notNews" style="width: 200px;"><a  style="width: 200px" href="javascript:linkThirdList('300')"><span class="mbx_text"><font color="black">东方地球物理公司</font></span></a></div>
			<div <%if(orgId.equals("306")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('306')">国际勘探事业部</a></div>
			<div <%if(orgId.equals("180")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('180')">研究院</a></div>
			<div <%if(orgId.equals("319")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('319')">塔里木物探处</a></div>
			<div <%if(orgId.equals("320")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('320')">新疆物探处</a></div>
			<div <%if(orgId.equals("321")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('321')">吐哈物探处</a></div>
			<div <%if(orgId.equals("322")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('322')">青海物探处</a></div>
			<div <%if(orgId.equals("8ad878cd2cf41a23012d02f4e7ec00c3")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('8ad878cd2cf41a23012d02f4e7ec00c3')">长庆物探处</a></div>
			<div <%if(orgId.equals("308")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('308')">大港物探处</a></div>
			<div <%if(orgId.equals("323")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('323')">辽河物探处</a></div>
			<div <%if(orgId.equals("8ad878cd2cf41a23012d02f53ff000c4")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('8ad878cd2cf41a23012d02f53ff000c4')">华北物探处</a></div>
			<div <%if(orgId.equals("8ad878cd2d11f476012d2553db8a0435")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('8ad878cd2d11f476012d2553db8a0435')">新兴物探开发处</a></div>
			<div <%if(orgId.equals("309")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('309')">综合物化探处</a></div>
			<div <%if(orgId.equals("8ad878cd2e765396012eb2394b5201aa")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('8ad878cd2e765396012eb2394b5201aa')">信息技术中心</a></div>
			<div <%if(orgId.equals("8ad878cd2e765396012eb23bf93801ae")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('8ad878cd2e765396012eb23bf93801ae')">英洛瓦物探装备</a></div>
			<div <%if(orgId.equals("123")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('123')">西安装备分公司</a></div>
			
		</div>
</div>
<div id="list_div" style="width: auto;margin-right: 10px">
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
    <%if(userId.equals(orgId)||userId.equals("300")){ %>
<input class="iButton2" type="button" value="新增" onClick="toAdd()">
<input class="iButton2" type="button" value="修改" onClick="toEdit()">
<input class="iButton2" type="button" value="删除" onClick="toDelete()">
<%} %>
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
		<td class="tableHeader" 	 exp="<input type='radio' name='chx_entity_id' value='{history_report_id},{title},{record_year},{month}'>">选择</td>
		<td class="tableHeader"  cellClass="class1"	 exp="<a href=javascript:viewLink('{history_report_id}') ><font color='3366ff'>{title}</font></a>">名称</td>
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
