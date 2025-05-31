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
var pageTitle = "物探公司动态";
cruConfig.contextPath =  "<%=contextPath%>";
var wtgsType = new Array(
['10601001','大庆物探一公司'],['10601002','大庆物探二公司'],['10601003','川庆钻探物探公司'],['10602001','胜利物探公司'],['10602002','江汉物探公司'],['10602003','江苏物探公司'],['10602004','河南物探公司'],['10602005','中原物探公司'],['10602006','南方物探公司'],['10602007','第一物探公司'],['10602008','西南二物'],['10602009','中南五物'],['10602010','东北物探公司'],['10602011','华北物探公司'],['10602012','华东物探公司'],['10602013','西北物探公司'],['10603001','中海油物探公司'],['10604001','延长石油集团油气勘探公司'],['10605001','CGGVeritas'],['10605002','Schlumberger'],['10605003','PGS'],['10605004','TGS'],['10605005','Geokinetics'],['10605006','Fugro'],['10605007','SeaBird'],['10605008','Global'],['10606001','其他物探公司']
);

var jcdp_codes_items = null;
var jcdp_codes = new Array(
);


  		function toAdd(){
	  		editUrl = "/market/marketWtgsPage/addMarketWtgsPage.jsp?action=0";
			window.location=cruConfig.contextPath+editUrl+"&backUrl="+cruConfig.currentPageUrl;
		}
  	function toEdit(){
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	    var tempa = ids.split(',');
	    var infomation_id = tempa[0];
	   	var infomation_name = tempa[1];
	    	editUrl = "/market/editWtgs.srq?infomation_id="+infomation_id; 
	    	window.location=cruConfig.contextPath+editUrl; 
	}
	
	function viewLink(infomation_id){
	    	editUrl = "/market/viewWtgs.srq?infomation_id="+infomation_id;
	    	window.location=cruConfig.contextPath+editUrl+"&backUrl="+cruConfig.currentPageUrl;
		}
  
function page_init(){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.cdtType = 'form';
	cdt_init();
	cruConfig.queryStr = "select infomation_id, infomation_name,two_type_id,three_type_id,release_date,creator, case when times is null then '0' else times end as times  from (select r.*, t.father_code from bgp_infomation_release_info r, bgp_infomation_type_info t where r.two_type_id = t.code) where father_code like '106%' and bsflag = '0' order by release_date desc, modify_date desc";
	cruConfig.currentPageUrl = "/market/marketWtgsPage/MarketWtgsPageList.lpmd";
	queryData(1);
}

function toDelete(){
	ids = getSelIds('chx_entity_id');
    if(ids==''){ alert("请先选中一条记录!");
     return;
    } 
    var tempa = ids.split(',');
    
    var infomation_id = tempa[0];
   	var infomation_name = tempa[1];
	
	deleteEntities("update bgp_infomation_release_info set bsflag='1' where infomation_id='{id}'");
	
	var title = "在后台发布中物探公司动态里删除了一条标题为：“"+infomation_name+"”的信息"
	var operationPlace = "物探公司动态";
	var submitStr = "title="+encodeURI(encodeURI(title))+"&operationPlace="+encodeURI(encodeURI(operationPlace));
	var retObject=jcdpCallService("MarketInfoInputSrv","logDelete",submitStr);
	queryData(1);
}

var fields = new Array();
fields[0] = ['infomation_name','标题','TEXT'];
fields[1] = ['two_type_id','公司名称','TEXT',,,'SEL_OPs',wtgsType];
fields[2] = ['release_date','发布日期','D'];
	
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
text-align:left;
padding-left: 15px;
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
		<td class="tableHeader" 	 exp="<input type='radio' name='chx_entity_id' value='{infomation_id},{infomation_mame}'>"></td>
		<td class="tableHeader"   cellClass="class1"	 exp="<a href=javascript:viewLink('{infomation_id}') >{infomation_name}</a>">标题</td>
		<td class="tableHeader" 	 exp="{two_type_id}" func="getOpValue,wtgsType">公司名称</td>
		<td class="tableHeader" 	 exp="{release_date}">发布日期</td>
		<td class="tableHeader" 	 exp="{creator}">发布人</td>
		<td class="tableHeader" 	 exp="{times}">浏览次数</td>
	</tr>
	</thead>
	<tbody>
	
	</tbody>
</table>
</div>
</body>
</html>
