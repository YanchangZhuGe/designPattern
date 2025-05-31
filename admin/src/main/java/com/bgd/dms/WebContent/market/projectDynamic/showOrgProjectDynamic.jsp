<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName=user.getUserName();
	String orgId = request.getParameter("orgId");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/images/ma/weekStyle.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/js/bgpmcs/DivHiddenOpen.js"></script>
<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>
<%@ include file="/common/pmd_list.jsp"%>
<title>项目明细填报</title>
</head>
<script language="javaScript">
<!--Remark JavaScript定义-->
var pageTitle = "";
cruConfig.contextPath =  "<%=contextPath%>";
var jcdp_codes_items = null;
var jcdp_codes = new Array(
);


	  function toAdd(){
	  		editUrl = "/market/projectDynamic/addProjectDynamic.jsp?orgId=<%=orgId%>";
			window.location=cruConfig.contextPath+editUrl;
		}
  	function toEdit(){
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	    var tempa = ids.split(',');
	    
	    var project_dynamic_id = tempa[0];
	   	var project_name = tempa[1];
	    	editUrl = "/market/editProjectDynamic.srq?button=edit&orgId=<%=orgId%>&projectDynamicId="+project_dynamic_id; 
	    	window.location=cruConfig.contextPath+editUrl; 
	}
	
	function viewLink(project_dynamic_id){
	    	editUrl = "/market/viewProjectDynamic.srq?back=hidden&button=view&orgId=<%=orgId%>&projectDynamicId="+project_dynamic_id;
	    	window.location=cruConfig.contextPath+editUrl+"&backUrl="+cruConfig.currentPageUrl;
		}
  
function page_init(){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.cdtType = 'form';
	cdt_init();
	cruConfig.queryStr = "select t.PROJECT_DYNAMIC_ID,t.record_year,t.VALUE_WORKLOAD,t.PROJECT_NAME,t.TEAM_NO,t.TRUSTER,t.con_status,t.PROJECT_TYPE,t.PROJECT_STATUS,to_char(t.MODIFY_DATE, 'yyyy-MM-dd') as MODIFY_DATE,to_char(t.CREATE_DATE,'yyyy-MM-dd') as CREATE_DATE   from MM_PROJECT_DYNAMIC t  where t.bsflag='0' and t.corp_id='<%=orgId %>'  order by t.record_year desc, t.modify_date desc ";
	cruConfig.currentPageUrl = "/market/projectDynamic/orgProjectDynamic.lpmd";
	queryData(1);
}

function toDelete(){
	ids = getSelIds('chx_entity_id');
    if(ids==''){ alert("请先选中一条记录!");
     return;
    } 
    var tempa = ids.split(',');
    
    var project_dynamic_id = tempa[0];
   	var project_name = tempa[1];
	
	deleteEntities("update MM_PROJECT_DYNAMIC set bsflag='1' where project_dynamic_id='{id}'");
	
	var title = "在项目明细填报中删除了一条项目名称为：“"+project_name+"”的信息"
	var operationPlace = "项目明细填报";
	var submitStr = "title="+encodeURI(encodeURI(title))+"&operationPlace="+encodeURI(encodeURI(operationPlace));
	var retObject=jcdpCallService("MarketInfoInputSrv","logDelete",submitStr);
	queryData(1);
}

var fields = new Array();
fields[0] = ['project_name','项目名称','TEXT'];
fields[1] = ['record_year','记录年度','TEXT'];
fields[2] = ['team_no','施工队号','TEXT'];
	
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
	window.location="<%=contextPath%>/market/startProjectDynamic.srq?orgId="+orgId;
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
		<td class="tableHeader" 	 exp="<input type='radio' name='chx_entity_id' value='{project_dynamic_id},{project_name}'>"></td>
		<td class="tableHeader" autoOrder="1">序号</td> 
		<td class="tableHeader" 	 exp="<a href=javascript:viewLink('{project_dynamic_id}') ><font color='#3366ff'>{project_name}</font></a>">项目名称</td>
		<td class="tableHeader" 	 exp="{record_year}">记录<br>年度</td>
		<td class="tableHeader" 	 exp="{truster}">委托方</td>		
		<td class="tableHeader" 	 exp="{value_workload}">落实价值<br>工作量(万元)</td>
		<td class="tableHeader" 	 exp="{project_type}">项目<br>类型</td>
		<td class="tableHeader" 	 exp="{team_no}">施工<br>队号</td>
		<td class="tableHeader" 	 exp="{project_status}">项目<br>状态</td>
		<td class="tableHeader" 	 exp="{con_status}">合同签<br>订情况</td>
		<td class="tableHeader" 	 exp="{create_date}">创建时间</td>
		<td class="tableHeader" 	 exp="{modify_date}">修改时间</td>
	</tr>
	</thead>
	<tbody>
	
	</tbody>
</table>
</div>
</body>
</html>
