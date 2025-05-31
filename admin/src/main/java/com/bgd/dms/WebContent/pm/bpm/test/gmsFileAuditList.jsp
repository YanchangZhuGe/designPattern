<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
%>
<html>
<head>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />


<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/js/bgpmcs/DivHiddenOpen.js"></script>
<%@ include file="/common/pmd_list.jsp"%>
<title>UCM文档审核</title>

<script language="javaScript">
var pageTitle = "";
var jcdp_codes_items = null;
var jcdp_codes = new Array(
);
function page_init(){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.contextPath = "<%=contextPath%>";
	var path = "/tcg/ajaxServiceProxyAction.srq?JCDP_SRV_NAME=workFlowSrv&JCDP_OP_NAME=getExamineList&procType=8ad88990376e3a7f01376e3d40f00002&params=fileName";
	appConfig.queryListAction = path;
	cruConfig.cdtType = 'form';
	cdt_init();
	cruConfig.queryStr = "";
	cruConfig.currentPageUrl = "/pm/bpm/test/gmsFileAuditList.jsp";
	queryData(1);
}

var fields = new Array();

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


function queryData(targetPage){


	var temp=appConfig.queryListAction;
	var fileName=document.getElementById("fileName").value;
	var path="";
	if(fileName!=""){
		path+="&fileName="+fileName;
	}

	var auditType=document.getElementById("auditType").value;
	if(auditType!=""){
		path+="&auditType="+auditType;
	}
	if(auditType=="1"){
		document.getElementById("auditButton").style.display="block";
	}else{
		document.getElementById("auditButton").style.display="none";
	}
	appConfig.queryListAction+=path;



	// 设置等待提示
	querySuccess=false;
	Ext.MessageBox.wait('请等待','处理中');
	setTimeout(hideStatusBar,1000);

	cruConfig.currentPage = targetPage;

	var submitStr = "currentPage="+targetPage+"&pageSize="+cruConfig.pageSize;
	if(cruConfig.funcCode!='') submitStr += "&EP_DATA_AUTH_funcCode="+cruConfig.funcCode;

	var retObject;//alert(cruConfig.queryService);
	if(cruConfig.queryService!=''){//调用服务查询
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
	querySuccess=true;
	appConfig.queryListAction=temp;
}

function classicQuery(){
	var qStr = generateClassicQueryStr();
	cruConfig.cdtStr = qStr;
	queryData(1);
}

function onlineEdit(rowParams){
	var path = cruConfig.contextPath+cruConfig.editAction;
	var params = cruConfig.editTableParams+"&rowParams="+rowParams.toJSONString();
	var retObject = syncRequest('Post',path,params);
	if(retObject.returnCode!=0){
		alert(retObject.returnMsg);
		return false;
	}else return true;
}
function JcdpButton0OnClick(){
	var ids = getSelIds('chx_entity_id');
    if(ids==''){ alert("请先选中一条记录!");
     return;
    }
	var tempa = ids.split(',');
	var proc_id=tempa[0];
	var proc_ucmId=tempa[1];
	var proc_projectInfoNo=tempa[2];
	var proc_fileName=tempa[3];
	proc_fileName=encodeURI(proc_fileName);
	proc_fileName=encodeURI(proc_fileName);
	var entityId=tempa[4];
	var procinstId=tempa[5];
	var taskinstId=tempa[6];
	var editUrl = "/pm/bpm/toViewExamineInfo.srq?taskinstId="+taskinstId+"&proc_fileName="+proc_fileName+"&proc_ucmId="+proc_ucmId+"&proc_id="+proc_id+"&examineinstID="+entityId+"&procinstID="+procinstId;
	window.location=cruConfig.contextPath+editUrl+"&backUrl="+cruConfig.currentPageUrl;
}
function JcdpButton1OnClick(){
	var ids = getSelIds('chx_entity_id');
    if(ids==''){ alert("请先选中一条记录!");
     return;
    }
	var tempa = ids.split(',');
	var proc_id=tempa[0];
	var proc_ucmId=tempa[1];
	var proc_projectInfoNo=tempa[2];
	var proc_proc_fileName=tempa[3];
	var entityId=tempa[4];
	var procinstId=tempa[5];
	var taskinstId=tempa[6];
	var editUrl = proc_view_url+"?taskinstId="+taskinstId+"&id="+proc_id+"&examineinstID="+entityId+"&procinstID="+procinstId;
	window.location=cruConfig.contextPath+editUrl+"&backUrl="+cruConfig.currentPageUrl;
}

function searchForPrepare(){
		var prepareStr = "当前有<font color="+"red"+">"+cruConfig.totalRows+"</font>条待审核的单据";
		document.getElementById("prepareStr").innerHTML =prepareStr;
}

</script>

<script type="text/javascript" src="/BGPMCS/js/calendar.js"></script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
<script type="text/javascript" src="/BGPMCS/js/calendar-setup.js"></script>
</head>
<body onload="page_init();searchForPrepare();">
<table border="0" cellpadding="0" cellspacing="0" class="Tab_page_title">
  <tr>
			<td height=1 colspan="4" align=left></td>
  </tr>
  <tr>
			<td width="5%"   height=28 align=left ><img src="<%=contextPath%>/images/oms_index_09.gif" width="100%" height="28" /></td>
			<td id="cruTitle" width="40%" align=left background="<%=contextPath%>/images/oms_index_11.gif" class="text11">
            	生产统计 -> 液量计量
          	</td>
			<td width="5%" align=left ><img src="<%=contextPath%>/images/oms_index_13.gif" width="100%" height="28" /></td>
			<td width="50%" align=left style="background:url(<%=contextPath%>/images/oms_index_14.gif) repeat-x;">&nbsp;</td>
  </tr>
</table>

<div id="queryDiv" style="display:">
<table  border="0" cellpadding="0" cellspacing="0" class="form_info" id="queryCdtTable" enctype="multipart/form-data">

<tr>
    <td class="rtCDTFdName">文件名：</td>
    <td class="rtCDTFdValue">
   <input name="fileName" id="fileName" type="text" class="input_width" />
    </td>
   <td class="rtCDTFdName">审批类型：</td>
    <td class="rtCDTFdValue">
    	<select id="auditType" name="auditType" class="input_width">
    		<option value="1">待审批</option>
    		<option value="2">已审批</option>
    	</select>
	</td>

  </tr>
  <tr class="ali4">
    <td colspan="4"><input type="submit" onclick="classicQuery()" name="search" value="查询"  class="iButton2"/>  <input type="reset" name="reset" value="清除" onclick="clearQueryCdt()" class="iButton2"/></td>
  </tr>
</table>
</div>
<table  border="0" cellpadding="0" cellspacing="0" class="Tab_new_mod_del">
  <tr class="ali7">
    <td>
    <div id="auditButton" style="">
    	<button type="button" class="iButton2"  onclick="JcdpButton0OnClick()">审核</button>
	</div>
<!-- <input class="iButton2" type="button" value="查看" onClick="JcdpButton1OnClick()"> -->
    </td>
  </tr>
</table>

<!--Remark 查询指示区域-->
<div id="rtToolbarDiv">
<table border="0"  cellpadding="0"  cellspacing="0"  class="rtToolbar"  width="100%" >
	<tr>
		<td id="prepareStr" align="left"></td>
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

<div id="resultable"  style="width:100%; overflow-x:scroll;" >
<table border="0"  cellspacing="0"  cellpadding="0"  class="form_info"  width="100%" id="queryRetTable">
	<thead>
	<tr class="bt_info">
		<td class="tableHeader" 	 exp="<input type='radio'  name='chx_entity_id' value='{proc_id},{proc_ucmId},{proc_projectInfoNo},{proc_fileName},{entityId},{procinstId},{taskinstId}'>">选择</td>
		<td class="tableHeader" 	 exp="{proc_fileName}" >文件名</td>
   		<td class="tableHeader" 	 exp="{currentNode}">当前审批环节</td>
		<td class="tableHeader" 	 exp="{currentProcName}">流程名称</td>
   		<td class="tableHeader" 	 exp="{currentcreateDate}" >流程创建时间</td>
	</tr>
	</thead>
	<tbody>
	</tbody>
</table>
</div>
</body>
</html>
