<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String corpId = request.getParameter("corpId");
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
var ytgsOrgId = new Array(
['','中石油-------------------------------------------------------------'],['236','勘探与生产分公司'],['168','大庆油田分公司'],['170','辽河油田分公司'],['169','吉林油田分公司'],['167','冀东油田分公司'],['166','大港油田分公司'],['165','华北油田分公司'],['164','长庆油田分公司'],['159','塔里木油田分公司'],['160','新疆油田分公司'],['161','吐哈油田分公司'],['163','青海油田分公司'],['162','玉门油田分公司'],['171','西南油气田分公司'],['158','浙江油田分公司'],['208','南方石油勘探公司'],['240','煤层气公司'],['246','西气东输管道公司'],['','中石化-------------------------------------------------------------'],['196','胜利油田分公司'],['173','中原油田分公司'],['174','河南油田分公司'],['175','江汉油田分公司'],['176','江苏油田分公司'],['179','西北油田分公司'],['178','上海海洋石油分公司'],['10180','西南分公司'],['184','东北分公司'],['182','华北分公司'],['10181','华东分公司'],['183','中南分公司'],['220','天然气分公司'],['','中海油-------------------------------------------------------------'],['231','中国海洋石油有限公司'],['190','上海分公司'],['189','深圳分公司'],['187','天津分公司'],['188','湛江分公司'],['','延长石油-------------------------------------------------------------'],['218','延长石油集团油气勘探公司'],['','国际油公司-------------------------------------------------------------'],['233','道达尔勘探与生产公司司'],['8ad878cd2c61b24a012c61deccce0304','英国瑞弗莱克公司'],['8ad878cd2c62ac1e012c62efa20b03df','Sonatrach'],['8ad878cd2c62ac1e012c62eea28f03cd','PPL'],['8ad878cd2c62ac1e012c62ef6c4003de','PGNIG'],['8ad878cd2c62ac1e012c62ef0d6903d0','Vanoil Kenya LTD'],['8ad878cd2c62ac1e012c62ef2e6803d1','ROY'],['8ad878cd2c62ac1e012c62ee855803cc','ENI'],['8ad878cd2c61f946012c61fee03f0017','沙特国家石油公司'],['','其他油公司-------------------------------------------------------------'],['219','天津大港圣康石油公司'],['214','四川德阳新场气田'],['228','金海石油公司'],['230','振华石油'],['241','纵横油田有限公司'],['239','中国年代能源投资有限公司']
);

var jcdp_codes_items = null;
var jcdp_codes = new Array(
);


   function JcdpButton3OnClick(){
		ids = getSelIds('chx_entity_id');
			    if(ids==''){ alert("请先选中一条记录!");
			     return;
			    } 
			    editUrl = "/market/deptOrder.srq?dept_id="+ids; 
			    var returnVlue=window.showModalDialog(cruConfig.contextPath+editUrl,window,'dialogHeight:200px;dialogWidth:600px');
	
	}
   
  
	function viewLink(dept_id,corp_id){
	    	editUrl = "/market/departmentPage/selectPerson.jsp?id="+dept_id+"&corpId="+corp_id;
	    	window.location=cruConfig.contextPath+editUrl+"&backUrl="+cruConfig.currentPageUrl;
		}
  
function page_init(){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.cdtType = 'form';
	cdt_init();
	cruConfig.queryStr = "select d.*,sm.org_name from ci_department d, sm_org sm, bgp_infomation_type_info t where d.corp_id =sm.org_id and t.infomation_type_id = sm.bgp_infomation_type_id and d.bsflag='0' and d.corp_id='<%=corpId%>' order by sm.org_name,d.ORDER_NO";
	cruConfig.currentPageUrl = "/market/departmentPage/DepartmentList.lpmd";
	queryData(1);
}

function toAdd(){
	window.location='editDepartment.upmd?pagerAction=edit2Add&backUrl='+cruConfig.currentPageUrl;
}

function toEdit(){
	ids = getSelIds('chx_entity_id');
	if(ids==''){
		alert("请先选中一条记录!");
		return;
	}
	selId = ids.split(',')[0];
	editUrl = "editDepartment.upmd?id={id}";
	editUrl = editUrl.replace('{id}',selId);
	editUrl += '&pagerAction=edit2Edit';
	window.location=editUrl+"&backUrl="+cruConfig.currentPageUrl;
}

function toDelete(){
	deleteEntities("update ci_department set bsflag='1' where dept_id='{id}'");
}

var fields = new Array();
fields[0] = ['dept_name','部门名称','TEXT'];
fields[1] = ['corp_id','组织机构','TEXT',,,'SEL_OPs',ytgsOrgId];
	
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
<input class="iButton2" type="button" value="调整部门位置" onClick="JcdpButton3OnClick()">
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
		<td class="tableHeader" 	 exp="<input type='radio' name='chx_entity_id' value='{dept_id}'>">选择</td>
		<td class="tableHeader" 	 exp="{dept_name}">部门名称</td>
		<td class="tableHeader" 	 exp="{org_name}">组织机构</td>
		<td class="tableHeader" 	 exp="<a href=javascript:viewLink('{dept_id}','{corp_id}') >查看部门人员</a>">人员</td>
	</tr>
	</thead>
	<tbody>
	
	</tbody>
</table>
</div>
</body>
</html>
