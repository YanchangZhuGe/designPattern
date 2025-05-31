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
<link href="<%=contextPath%>/images/ma/weekStyle.css" rel="stylesheet" type="text/css" />
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
var pageTitle = "落实收入";
cruConfig.contextPath =  "<%=contextPath%>";
var orgId = "<%=orgId%>";
var subflags = new Array(
['0','未提交'],['1','已提交']
);

var jcdp_codes_items = null;
var jcdp_codes = new Array(
);


  	function toEdit(){
  		
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
		
	    var tempa = ids.split(',');
			
	    var week_date = tempa[0];
	    var subflag = tempa[1];
	    var week_end_date = tempa[2];
	    
	    if(subflag == '0'){
	    	if(orgId=="C6000000000025"){
	    	window.location = "<%=contextPath%>/market/month/editValueReport.srq?week_date="+week_date+"&week_end_date="+week_end_date+"&action=edit";
	    	}else{
	    		window.location = "<%=contextPath%>/market/incomeMonth/orgInsert.jsp?orgId=<%=orgId%>&week_date="+week_date+"&week_end_date="+week_end_date+"&action=edit";
	    	}
	    }else{
	    	alert("该记录已经提交，不能修改!"); 
	    	return; 
	    }
	}
	
  	function toDelete(){
  		
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
		
	    var tempa = ids.split(',');
	    
	    var week_date = tempa[0];
	    var subflag = tempa[1];
	    
	    if(subflag == '0'){
	    	if(orgId=="C6000000000025"){
	    	var sql = "update bgp_wr_income_money set bsflag='1' where org_type='1' and type='2' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
	    	}else{
		    var sql = "update bgp_wr_income_money set bsflag='1' where org_type='0' and type='2' and org_id='<%=orgId%>' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
	    	}
	    	deleteEntities(sql);
	    	
	    	var title = "在月市场落实价值工作量中删除了一条月报开始日期为：“"+week_date+"”的信息";
			var operationPlace = "月市场落实价值工作量";
			var submitStr = "title="+encodeURI(encodeURI(title))+"&operationPlace="+encodeURI(encodeURI(operationPlace));
			var retObject=jcdpCallService("MarketInfoInputSrv","logDelete",submitStr);
			queryData(1);
	    }else{
	    	alert("该记录已经提交，不能删除!"); 
	    	return; 
	    }
	}
	
	function JcdpButton3OnClick(){
		
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
		
	    var tempa = ids.split(',');

	    var week_date = tempa[0];
	    var subflag = tempa[1];
	    if(subflag == '0'){
	    	if(orgId=="C6000000000025"){
	    	var sql = "update bgp_wr_income_money set subflag='1' where org_type='1' and bsflag='0' and type='2' and  to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
	    	}else{
		    	var sql = "update bgp_wr_income_money set subflag='1' where org_type='0' and type='2' and bsflag='0' and org_id='<%=orgId%>' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
	    	}
	    	updateEntitiesBySql(sql,"提交");
	    }else{
	    	alert("该记录已经提交，不能再次提交!"); 
	    	return; 
	    }
	}
	
function JcdpButton4OnClick(){
		
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
		
	    var tempa = ids.split(',');

	    var week_date = tempa[0];
	    var subflag = tempa[1];
	    if(subflag == '1'){
	    	if(orgId=="C6000000000025"){
	    	var sql = "update bgp_wr_income_money set subflag='0' where org_type='1' and bsflag='0' and type='2' and  to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
	    	}else{
		    	var sql = "update bgp_wr_income_money set subflag='0' where org_type='0' and type='2' and bsflag='0' and org_id='<%=orgId%>' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
	    	}
	    	updateEntitiesBySql(sql,"取消提交");
	    }else{
	    	alert("该记录未提交，不能取消提交!"); 
	    	return; 
	    }
	}
  
function page_init(){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.cdtType = 'form';
	cdt_init();
	if(orgId=="C6000000000025"){
		cruConfig.queryStr = " 	select distinct t.week_date,t.subflag,t.week_end_date  from bgp_wr_income_money t  	 where t.bsflag = '0' and t.org_type='1' and type='2' order by week_date desc    ";
	}else{
		cruConfig.queryStr = " 	select distinct t.week_date,t.subflag,t.week_end_date  from bgp_wr_income_money t  	 where t.bsflag = '0' and t.org_type='0' and type='2' and t.org_id='<%=orgId%>' order by week_date desc    ";
	}
	cruConfig.currentPageUrl = "/pm/wr/income/list.lpmd";
	queryData(1);
}

function toAdd(){
	if(orgId=="C6000000000025"){
	window.location='<%=contextPath%>/market/incomeMonth/martSelectWeek.jsp';
	
	}else{
	window.location='<%=contextPath%>/market/incomeMonth/orgInsert.jsp?orgId=<%=orgId%>&action=add';
	}
}

var fields = new Array();
fields[0] = ['week_date','月报日期','D'];
fields[1] = ['subflag','状态','TEXT',,,'SEL_OPs',subflags];
	
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
	window.location.href="<%=contextPath%>/market/incomeMonth/incomeReport.srq?orgId="+orgId;
}
</script>

<script type="text/javascript" src="/BGPMCS/js/calendar.js"></script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
<script type="text/javascript" src="/BGPMCS/js/calendar-setup.js"></script>
</head>
<body onload="page_init()">
<div id="right_div_left">
     <div id="gl_left_botbox" style="margin-left:10px;margin-left: 10px\9;*margin-left:10px;_margin-left:5px;">
    	<div class="notNews" style="width: 200px;"><a  style="width: 200px" href="javascript:linkThirdList('C6000000000025')"><span class="mbx_text"><font color="black">东方地球物理公司</font></span></a></div>
			<div <%if(orgId.equals("C6000000000003")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('C6000000000003')">国际勘探事业部</a></div>
			<div <%if(orgId.equals("C6000000000004")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('C6000000000004')">研究院</a></div>
			<div <%if(orgId.equals("C6000000000010")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('C6000000000010')">塔里木物探处</a></div>
			<div <%if(orgId.equals("C6000000000011")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('C6000000000011')">新疆物探处</a></div>
			<div <%if(orgId.equals("C6000000000013")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('C6000000000013')">吐哈物探处</a></div>
			<div <%if(orgId.equals("C6000000000012")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('C6000000000012')">青海物探处</a></div>
			<div <%if(orgId.equals("C6000000000045")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('C6000000000045')">长庆物探处</a></div>
			<div <%if(orgId.equals("C6000000000008")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('C6000000000008')">大港物探处</a></div>
			<div <%if(orgId.equals("C6000000001888")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('C6000000001888')">辽河物探处</a></div>
			<div <%if(orgId.equals("C0000000000232")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('C0000000000232')">华北物探处</a></div>
			<div <%if(orgId.equals("C6000000000060")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('C6000000000060')">新兴物探开发处</a></div>
			<div <%if(orgId.equals("C6000000000009")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('C6000000000009')">综合物化探处</a></div>
			<div <%if(orgId.equals("C6000000000015")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('C6000000000015')">信息技术中心</a></div>
			<div <%if(orgId.equals("C6000000006451")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('C6000000006451')">英洛瓦物探装备</a></div>
			<div <%if(orgId.equals("C6000000000017")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('C6000000000017')">西安装备分公司</a></div>
			
		</div>
</div>
<div id="list_div" style="width: auto;margin-right: 10px;margin-right: 10px\9;*margin-right: 10px;_margin-right: 10px;">
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
    <%if(userId.equals(orgId)||userId.equals("C6000000000025")){ %>
<input class="iButton2" type="button" value="新增" onClick="toAdd()">
<input class="iButton2" type="button" value="修改" onClick="toEdit()">
<input class="iButton2" type="button" value="删除" onClick="toDelete()">
<input class="iButton2" type="button" value="提交" onClick="JcdpButton3OnClick()">
<%} %>
<oms_auth:button type="button" value="取消提交" css="iButton2" functionId="F_MA_019" event="onclick='JcdpButton4OnClick();'"/>
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
		<td class="tableHeader" 	 exp="<input type='radio' name='chx_entity_id' value='{week_date},{subflag},{week_end_date}'>">选择</td>
		<%if(orgId.equals("C6000000000025")){ %>
		<td class="tableHeader" 	 exp="<a href=javascript:link2self('<%=contextPath%>/market/month/viewValueReport.srq?week_date={week_date}&week_end_date={week_end_date}&action=view')><font color='3366ff'>{week_date}</font></a>">月报开始日期</td>
		<%}else{%>
		<td class="tableHeader" 	 exp="<a href=javascript:link2self('<%=contextPath%>/market/incomeMonth/orgInsert.jsp?orgId=<%=orgId%>&week_date={week_date}&week_end_date={week_end_date}&action=view')><font color='3366ff'>{week_date}</font></a>">月报开始日期</td>
		<%} %>
		<td class="tableHeader" 	 exp="{week_end_date}">月报结束日期</td>
		<td class="tableHeader" 	 exp="{subflag}" func="getOpValue,subflags">状态</td>
	</tr>
	</thead>
	<tbody>
	
	</tbody>
</table>
</div>
</div>
</body>
</html>
