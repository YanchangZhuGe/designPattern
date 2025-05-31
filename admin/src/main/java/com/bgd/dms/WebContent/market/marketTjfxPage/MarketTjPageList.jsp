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
var pageTitle = "统计分析";
cruConfig.contextPath =  "<%=contextPath%>";
var tjType = new Array(
['','所有'],['10203001','市场周报'],['10203003','市场月报'],['10203005','市场季报'],['10203002','油气市场一周综述'],['10203006','油气勘探综合信息'],['10203004','市场动态月度专报']
);

var jcdp_codes_items = null;
var jcdp_codes = new Array(
);


  	function toAdd(){
	  		editUrl = "/market/marketTjfxPage/addMarketTjPage.jsp?action=0";
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
	    	editUrl = "/market/editTj.srq?infomation_id="+infomation_id; 
	    	window.location=cruConfig.contextPath+editUrl; 
	}
	
	function viewLink(infomation_id){
	    	editUrl = "/market/viewTj.srq?infomation_id="+infomation_id;
	    	window.location=cruConfig.contextPath+editUrl+"&backUrl="+cruConfig.currentPageUrl;
		}
  
function page_init(){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.cdtType = 'form';
	cdt_init();
	cruConfig.queryStr = "select infomation_id, infomation_name,two_type_id,three_type_id,release_date,creator, case when times is null then '0' else times end as times  from (select r.*, t.father_code from bgp_infomation_release_info r, bgp_infomation_type_info t where r.two_type_id = t.code) where father_code like '102%' and bsflag = '0' order by release_date desc, modify_date desc";
	cruConfig.currentPageUrl = "/market/marketTjfxPage/MarketTjPageList.lpmd";
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
	
	var title = "在后台发布中统计分析里删除了一条标题为：“"+infomation_name+"”的信息"
	var operationPlace = "统计分析";
	var submitStr = "title="+encodeURI(encodeURI(title))+"&operationPlace="+encodeURI(encodeURI(operationPlace));
	var retObject=jcdpCallService("MarketInfoInputSrv","logDelete",submitStr);
	queryData(1);
}

var fields = new Array();
fields[0] = ['infomation_name','标题','TEXT'];
fields[1] = ['two_type_id','类别选择','TEXT',,,'SEL_OPs',tjType];
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
		<td class="tableHeader" 	 exp="<input type='radio' name='chx_entity_id' value='{infomation_id},{infomation_name}'>"></td>
		<td class="tableHeader"  cellClass="class1"	 exp="<a href=javascript:viewLink('{infomation_id}') >{infomation_name}</a>">标题</td>
		<td class="tableHeader" 	 exp="{two_type_id}" func="getOpValue,tjType">类别</td>
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
