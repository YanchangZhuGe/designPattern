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
var jcdp_codes_items = null;
var jcdp_codes = new Array(
);


  
	function viewLink(dept_id){
	    	editUrl = "/market/showModel/showPerson.lpmd?id="+dept_id;
	    	url=cruConfig.contextPath+editUrl+"&backUrl="+cruConfig.currentPageUrl;
	    	window.showModalDialog(url);
		}
  
function page_init(){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "select d.* from sm_org sm ,ci_department d where d.bsflag='0' and d.corp_id =sm.org_id and sm.bgp_infomation_type_id ='${param.typeId}' order by d.ORDER_NO";
	cruConfig.currentPageUrl = "/market/showModel/showDepartment.lpmd";
	queryData(1);
}

</script>

<script type="text/javascript" src="/BGPMCS/js/calendar.js"></script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
<script type="text/javascript" src="/BGPMCS/js/calendar-setup.js"></script>
</head>
<body onload="page_init()"  >
<!--Remark 查询指示区域-->

<div id="resultable"  style="width:570px; overflow-x:scroll ;overflow-y:hidden ;margin-left: 0px" >
<table border="0"  cellspacing="0"  cellpadding="0"   class="form_info"  width="100%" id="queryRetTable">
	<thead>

	<tr class="bt_info">
		<td class="notNews" 	 exp="{dept_name}">部门名称</td>
		<td class="notNews" 	 exp="<a href=javascript:viewLink('{dept_id}') >查看部门人员</a>">人员</td>
	</tr>
	</thead>
	<tbody>
	
	</tbody>
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
	
</table>
</div>
</body>
</html>
