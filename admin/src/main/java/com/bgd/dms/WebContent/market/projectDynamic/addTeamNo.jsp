<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = request.getParameter("orgId");
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
var jcdp_codes_items = null;
var jcdp_codes = new Array(
);


function head_chx_box_changed(headChx){
	var chxBoxes = document.getElementsByName("chx_entity_id");
	if(chxBoxes==undefined) return;
	for(var i=0;i<chxBoxes.length;i++){
	  if(!chxBoxes[i].disabled){
			chxBoxes[i].checked = headChx.checked;	
			doCheck(chxBoxes[i]);
	  }
	  
	}
}

//保存的checkbox拼接的值
var checked=""; 
function doCheck(id){

	//序号
	var num = -1;
	//新的check值
	var newcheck = "";
	//拼接的值不为空

	if(checked != ""){
		var checkStr = checked.split(",");
		for(var i=0;i<checkStr.length-1; i++){
			//如果check中存在  选择的id值
			if(checkStr[i] == id.value){
				//记录位置
				num = i;		
				break;	
			}
		}
        //判断num是否有值
		if(num != -1 ){
			if(id.checked==false){
				for(var j=0;j<checkStr.length-1; j++){
					if( j != num ){
						newcheck += checkStr[j] + ',';
					}
				}
				checked = newcheck;
			}
		}else{
			//直接拼
			if(id.checked==true){
				checked= checked + id.value + ',';	
			}		
		}
	}else{
		checked = id.value + ',';
		
	}
	

}
function sure(){
	debugger;
	if(checked == ""){
		alert("请选择一条记录!");
		return;
	}
	var teamNoSum="";
	var teamNo;
	var checks = checked.split(",");
	debugger;
	for(var i=0; i<checks.length;i++){
		 teamNo = checks[i];
		 teamNoSum = teamNoSum+teamNo+",";
	}
	var qq =teamNoSum.length;
	var teamNoSum1 = teamNoSum.substring(0,teamNoSum.length-2);
	window.parent.opener.getTeamNo(teamNoSum1);
	parent.window.close();
}
  
function page_init(){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.cdtType = 'form';
	cdt_init();
	cruConfig.queryStr = "select * from MM_TEAM_DYNAMIC mtd where mtd.corp_id='<%=orgId%>' and mtd.bsflag='0'  order by mtd.create_date desc ";
	cruConfig.currentPageUrl = "/market/projectDynamic/addTeamNo3.lpmd";
	cruConfig.pageSize="20";
	queryData(1);
}

var fields = new Array();
fields[0] = ['team_no','作业队号','TEXT'];
fields[1] = ['work_place','作业地点','TEXT'];
	
function basicQuery(){
	var qStr = generateBasicQueryStr();
	cruConfig.cdtStr = qStr;
	queryData(1);
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
<input class="iButton2" type="button" value="确定" onClick="sure()">
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
		<td class="tableHeader" 	 exp="<input type='checkbox' name='chx_entity_id' value='{team_no}'  onclick=doCheck(this)>"><input type='checkbox' id='headChxBox' onclick="head_chx_box_changed(this)"></td>
		<td class="tableHeader" 	 exp="{team_no}">作业队号</td>
		<td class="tableHeader" 	 exp="{team_status}">作业状态</td>
		<td class="tableHeader" 	 exp="{work_place}">作业地点</td>
	</tr>
	</thead>
	<tbody>
	
	</tbody>
</table>
</div>
</body>
</html>
