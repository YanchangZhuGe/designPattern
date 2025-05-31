<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil,com.cnpc.jcdp.webapp.util.JcdpMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	boolean audit = false;//JcdpMVCUtil.hasPermission("F_PM_WR_021", request);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/js/bgpmcs/DivHiddenOpen.js"></script>
<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>
<%@ include file="/common/pmd_list.jsp"%>

<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
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

function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height());
	//setTabBoxHeight();
	$("#table_box").css("height",$(window).height()*0.85);
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);


function page_init(){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	var week_date = getObj("week_date").value;
	var subflag_obj = getObj("subflag");
	var subflag = subflag_obj ? subflag_obj.value : "";
	cruConfig.queryService = "DataExtractSrv";
	cruConfig.queryOp = "getReportIndexList";
	cruConfig.submitStr = "audit=<%=audit%>&week_date="+week_date+"&subflag="+subflag;
	queryData(1);
}

var fields = new Array();
fields[0] = ['week_date','周报开始日期','D'];
<%if(audit){ %>
fields[1] = ['subflag','状态','TEXT',,,'SEL_OPs',substatus];
<%}%>

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

	var week_date = getObj("week_date").value;
	var subflag_obj = getObj("subflag");
	var subflag = subflag_obj ? subflag_obj.value : "";
	cruConfig.submitStr = "audit=<%=audit%>&week_date="+week_date+"&subflag="+subflag;
	
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

<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
</head>
<body onload="page_init()" style="background:#fff">
<div id="list_table">
<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr><input id="week_date" name="week_date" type="hidden"  />
    <!--<td class="ali3">周报开始日期：</td>
    <td class="ali1"><input id="week_date" name="week_date" type="text"  /></td>
    <td>&nbsp;</td>
     <td><span class="gl"><a href="#" onclick="toSearch()" title="JCDP_btn_query"></a></span></td> -->
  </tr>
</table>
</td>
    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
  </tr>
</table>
</div>

<div id="table_box">
<table border="0"  cellspacing="0"  cellpadding="0"  class="tab_info"  width="100%" id="queryRetTable">
	<thead>

	<tr class="bt_info">
		<td class="bt_info_odd" 	 exp="<input type='radio' name='rdo_entity_id' value='{week_date}'>">选择</td>
		<td class="bt_info_even" autoOrder="1">序号</td> 
		<td class="bt_info_odd" 	 exp="{week_date}">开始日期</td>
		<td class="bt_info_even" 	 exp="{week_end_date}">结束日期</td>
		<%if(audit){ %>
		<td class="bt_info_odd" 	 exp="{create_user}">填报人</td>
		<td class="bt_info_even" 	 exp="{subflag}" func="getOpValue,substatus">审批状态</td>
		<td class="bt_info_odd" 	 exp="<a href=javascript:popWindow('auditInfo.jsp?record_id={record_id}&week_date={week_date}&week_end_date={week_end_date}')>查看审批意见</a>">审批意见</td>
		<%} %>
	</tr>
	
	</thead>
	<tbody>
	
	</tbody>
</table>
</div>
<div id="fenye_box">
<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
	  <tr>
	    <td align="right">第1/1页，共0条记录</td>
	    <td width="10">&nbsp;</td>
	    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
	    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
	    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
	    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
	    <td width="50">到 
	      <label>
	        <input type="text" name="textfield" id="textfield" style="width:20px;" />
	      </label></td>
	    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
	  </tr>
	</table>
	</div>
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
function dbclickRow(ids){
	popWindow('<%=contextPath%>/pm/wr/getCompanyProductionInfoBySubflag.srq?weekDate='+ids,'1024:768');
}
</script>
</html>
