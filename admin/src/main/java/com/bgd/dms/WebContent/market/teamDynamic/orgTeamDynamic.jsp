<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
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
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/images/ma/weekStyle.css" rel="stylesheet" type="text/css" />
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


	  function toAdd(){
	  		editUrl = "/market/teamDynamic/addTeamDynamic.jsp?orgId=<%=orgId%>";
			window.location=cruConfig.contextPath+editUrl;
		}
  	function toEdit(){
  		ids = getSelIds('chx_entity_id');
  	    if(ids==''){ alert("请先选中一条记录!");
  	     return;
  	    } 
  	    var tempa = ids.split(',');
  	    
  	    var team_dynamic_id = tempa[0];
  	   	var team_no = tempa[1];
	    	editUrl = "/market/editTeamDynamic.srq?button=edit&teamDynamicId="+team_dynamic_id; 
	    	window.location=cruConfig.contextPath+editUrl; 
	}
  
function page_init(){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.cdtType = 'form';
	cdt_init();
	cruConfig.queryStr = "select * from MM_TEAM_DYNAMIC t where t.bsflag='0' and t.corp_id='<%=orgId %>' order by t.create_date desc";
	cruConfig.currentPageUrl = "/market/teamDynamic/orgTeamDynamic.lpmd";
	queryData(1);
}

function toDelete(){
	ids = getSelIds('chx_entity_id');
    if(ids==''){ alert("请先选中一条记录!");
     return;
    } 
    var tempa = ids.split(',');
    
    var team_dynamic_id = tempa[0];
   	var team_no = tempa[1];
	deleteEntities("update MM_TEAM_DYNAMIC set bsflag='1' where team_dynamic_id='{id}'");
	
	var title = "在队伍动态维护中删除了一条作业队号为：“"+team_no+"”的信息"
	var operationPlace = "队伍动态维护";
	var submitStr = "title="+encodeURI(encodeURI(title))+"&operationPlace="+encodeURI(encodeURI(operationPlace));
	var retObject=jcdpCallService("MarketInfoInputSrv","logDelete",submitStr);
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
	window.location="<%=contextPath%>/market/startTeamDynamic.srq?orgId="+orgId;
}


</script>

<script type="text/javascript" src="/BGPMCS/js/calendar.js"></script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
<script type="text/javascript" src="/BGPMCS/js/calendar-setup.js"></script>
</head>
<body onload="page_init()">
<div id="right_div_left">
     <div id="gl_left_botbox" style="margin-left: 10px">
    	<div class="notNews" style="width: 200px;"><a  style="width: 200px" href="javascript:linkThirdList('300')"><span class="mbx_text"><font color="black">东方地球物理公司</font></span></a></div>
			<div <%if(orgId.equals("306")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('306')">国际勘探事业部</a></div>
			<div <%if(orgId.equals("180")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('180')">研究院</a></div>
			<div <%if(orgId.equals("319")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('319')">塔里木物探处</a></div>
			<div <%if(orgId.equals("320")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('320')">新疆物探处</a></div>
			<div <%if(orgId.equals("321")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('321')">吐哈物探处</a></div>
			<div <%if(orgId.equals("322")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('322')">青海物探处</a></div>
			<div <%if(orgId.equals("8ad878cd2cf41a23012d02f4e7ec00c3")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('8ad878cd2cf41a23012d02f4e7ec00c3')">长庆物探处</a></div>
			<div <%if(orgId.equals("308")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('308')">大港物探处</a></div>
			<div <%if(orgId.equals("323")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('323')">辽河物探处</a></div>
			<div <%if(orgId.equals("8ad878cd2cf41a23012d02f53ff000c4")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('8ad878cd2cf41a23012d02f53ff000c4')">华北物探处</a></div>
			<div <%if(orgId.equals("8ad878cd2d11f476012d2553db8a0435")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('8ad878cd2d11f476012d2553db8a0435')">新兴物探开发处</a></div>
			<div <%if(orgId.equals("309")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('309')">综合物化探处</a></div>
			<div <%if(orgId.equals("8ad878cd2e765396012eb2394b5201aa")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('8ad878cd2e765396012eb2394b5201aa')">信息技术中心</a></div>
			<div <%if(orgId.equals("8ad878cd2e765396012eb23bf93801ae")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('8ad878cd2e765396012eb23bf93801ae')">英洛瓦物探装备</a></div>
			<div <%if(orgId.equals("123")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('123')">西安装备分公司</a></div>
		</div>
</div>
<div id="list_div" style="width: auto;margin-right: 10px">
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
    <%if(userId.equals(orgId)||userId.equals("300")){ %>
<input class="iButton2" type="button" value="新增" onClick="toAdd()">
<input class="iButton2" type="button" value="修改" onClick="toEdit()">
<input class="iButton2" type="button" value="删除" onClick="toDelete()">
<%} %>
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
		<td class="tableHeader" 	 exp="<input type='radio' name='chx_entity_id' value='{team_dynamic_id},{team_no}'>">选择</td>
		<td class="tableHeader" 	 exp="{team_no}">作业队号</td>
		<td class="tableHeader" 	 exp="{team_status}">作业状态</td>
		<td class="tableHeader" 	 exp="{work_place}">作业地点</td>
	</tr>
	</thead>
	<tbody>
	
	</tbody>
</table>
</div>
</div>
</body>
</html>
