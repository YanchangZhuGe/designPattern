<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil,com.cnpc.jcdp.webapp.util.JcdpMVCUtil"%>
<%@ taglib uri="oms-rights" prefix="oms_auth" %>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	boolean audit = JcdpMVCUtil.hasPermission("F_PM_WR_021", request);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
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
var pageTitle = "生产周报列表页面";
cruConfig.contextPath =  "<%=contextPath%>";
var substatus = new Array(
['2','待审批'],['1','审批通过'],['3','审批不通过']
);

var jcdp_codes_items = null;
var jcdp_codes = new Array(
);


function page_init(){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;	
	cruConfig.funcCode = "F_PM_WR_021";
	cruConfig.contextPath = "<%=contextPath%>";
	var path = "/tcg/ajaxServiceProxyAction.srq?JCDP_SRV_NAME=workFlowSrv&JCDP_OP_NAME=getExamineList&procType=8a9588b6326acb1301327119b155007b&params=week_date,week_end_date";
	appConfig.queryListAction = path;	
	cruConfig.cdtType = 'form';
	cdt_init();
	cruConfig.queryStr = "";
	cruConfig.currentPageUrl = "/pm/wr/reportIndex.jsp";
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

function queryData(targetPage){

	
	var temp=appConfig.queryListAction;
	var path="";	
	
	var week_date=document.getElementById("week_date").value;
	if(week_date!=""){
		path+="&week_date="+week_date;
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

	var retObject;

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

function JcdpButton0OnClick(){
	var ids = getSelIds('chx_entity_id');
    if(ids==''){ alert("请先选中一条记录!");
     return;
    } 
	var tempa = ids.split(',');
	var proc_audit_url=tempa[0];
	var proc_applyType=tempa[1];
	var proc_id=tempa[2];
	var proc_tableName=tempa[3];
	var proc_tableKeyName=tempa[4];
	var proc_includeJsp=tempa[5];
	var proc_tableKeyValue=tempa[6];
	var entityId=tempa[7];
	var procinstId=tempa[8];
	var taskinstId=tempa[9];
	var proc_busKey=tempa[10];
	var proc_week_date=tempa[11];
	var proc_week_end_date=tempa[12];
	var editUrl = proc_audit_url+"?taskinstId="+taskinstId+"&applyType="+proc_applyType+"&id="+proc_id+"&audit_info=/workFlow/getExamineInfo.srq&tableName="+proc_tableName+"&tableKeyName="+proc_tableKeyName+"&tableKeyValue="+proc_tableKeyValue+"&examineinstID="+entityId+"&procinstID="+procinstId+"&busKey="+proc_busKey+"&weekDate="+proc_week_date+"&weekEndDate="+proc_week_end_date;
	window.location=cruConfig.contextPath+editUrl+"&backUrl="+cruConfig.currentPageUrl;
}

</script>

<script type="text/javascript" src="/BGPMCS/js/calendar.js"></script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
<script type="text/javascript" src="/BGPMCS/js/calendar-setup.js"></script>
</head>
<body onload="page_init()">
<div id="queryDiv" style="display:">
<table  border="0" cellpadding="0" cellspacing="0" class="form_info" id="queryCdtTable" enctype="multipart/form-data">
  <tr>
    <td class="rtCDTFdName">周报开始日期：</td>
    <td class="rtCDTFdValue">
   <input name="week_date" id="week_date" type="text" class="input_width" />&nbsp;<img style="CURSOR: hand" id="cal_button0" onmouseover="calDateSelector(week_date,cal_button0);" src="<%=contextPath %>/images/calendar.gif" width="16" height="16"></img>
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
		<oms_auth:button type="button" value="审核" css="iButton2" functionId="F_PM_WR_021" event="onclick='JcdpButton0OnClick();'"/>
	</div>
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
		<td class="tableHeader" 	 exp="<input type='radio'  name='chx_entity_id' value='{proc_audit_url},{proc_applyType},{proc_id},{proc_tableName},{proc_tableKeyName},{proc_includeJsp},{proc_tableKeyValue},{entityId},{procinstId},{taskinstId},{proc_busKey},{proc_week_date},{proc_week_end_date}'>">选择</td>
		<td class="tableHeader" 	 exp="<a href='${pageContext.request.contextPath}{proc_view_url}?taskinstId={taskinstId}&applyType={proc_applyType}&id={proc_id}&audit_info=/workFlow/getExamineInfo.srq&tableName={proc_tableName}&tableKeyName={proc_tableKeyName}&includeJsp={proc_includeJsp}&tableKeyValue={proc_tableKeyValue}&examineinstID={entityId}&procinstID={procinstId}&busKey={proc_busKey}&weekDate={proc_week_date}&weekEndDate={proc_week_end_date}'>{proc_week_date}</a>">周报开始日期</td>
		<td class="tableHeader" 	 exp="{proc_week_end_date}" >周报结束日期</td>
		<td class="tableHeader" 	 exp="{proc_create_org_name}">单位</td>
		<td class="tableHeader" 	 exp="{currentNode}">当前审批环节</td>
		<td class="tableHeader" 	 exp="{currentProcName}">流程名称</td>   		
   		<td class="tableHeader" 	 exp="{examineStartDate}" >流程创建日期</td>
	</tr>
	
	</thead>
	<tbody>
	
	</tbody>
</table>
</div>
</body>
<script type="text/javascript">
function calDateSelector(inputField,tributton)
{    
    Calendar.setup({
        inputField     :    inputField,   // id of the input field
        ifFormat       :    "%Y-%m-%d",       // format of the input field
        align          :    "Br",
		button         :    tributton,
        onUpdate       :    null,
        weekNumbers    :    true,
		singleClick    :    true,
		step        : 1,
		disableFunc: function(date) {
	        if (date.getDay() != 0) {
	            return true;
	        } else {
	            return false;
	        }
	    }
	    });
}
</script>
</html>
