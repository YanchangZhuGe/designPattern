<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getOrgId();
	if(user.getRoleIds().indexOf("INIT_AUTH_ROLE_012345678000000")>=0){
		orgId="C0000000000001";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
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
var pageTitle = "用户列表";
cruConfig.contextPath =  "<%=contextPath%>";
var userStatus = new Array(
['0','有效'],['1','禁用'],['2','作废']
);

var booleanOps = new Array(
		['0','否'],['1','是']
);

var jcdp_codes_items = null;
var jcdp_codes = new Array(
);


function page_init(){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.funcCode = "F_IBP_AUTH_091";
	cruConfig.cdtType = 'form';
	cdt_init();
	//cruConfig.queryStr = "select u.user_id,u.login_id,u.user_name,u.email,u.login_ip,u.this_login_time,u.user_status,u.if_admin,e.org_id,oi.org_name from p_auth_user u left join comm_human_employee e on u.emp_id=e.employee_id left join comm_org_information oi on e.org_id=oi.org_id where u.user_status<'5' and (u.user_id in (select user_id from (select t.user_id,(select v.org_id from comm_org_subjection v where v.bsflag='0' and rownum=1 and v.org_id in (select distinct org_id from p_auth_user where if_admin='1') start with v.org_id=t.org_id and v.bsflag='0' connect by v.org_subjection_id = prior v.father_org_id ) as admin_org from p_auth_user t) where admin_org='<%=orgId%>') or u.user_id in (select t.user_id from p_auth_user t join view_comm_org_information oi on t.org_id=oi.org_id where t.if_admin='1' and oi.org_code like '<%=user.getOrgSubjectionId()%>%'))";
	cruConfig.queryStr = "select u.user_id,u.login_id,u.user_name,u.email,u.login_ip,u.this_login_time,u.user_status,u.if_admin,u.org_id,oi.org_name,os.org_subjection_id as org_code from p_auth_user u join comm_org_information oi on u.org_id=oi.org_id join comm_org_subjection os on os.org_id=oi.org_id and os.bsflag='0' where u.user_status<'5' and u.bsflag='0'";
	cruConfig.currentPageUrl = "/ibp/auth/user/userList.jsp";
	queryData(1);
}

function toAdd(){
	window.location='addUser.jsp?pagerAction=edit2Add&backUrl='+cruConfig.currentPageUrl;
}

function toEdit(){
	ids = getSelIds('chx_entity_id');
	if(ids==''){
		alert("请先选中一条记录!");
		return;
	}
	selId = ids.split(',')[0];
	editUrl = "editUser.jsp?id={id}";
	editUrl = editUrl.replace('{id}',selId);
	editUrl += '&pagerAction=edit2Edit';
	window.location=editUrl+"&backUrl="+cruConfig.currentPageUrl;
}

function toDelete(){
	//deleteEntities("DELETE FROM p_auth_user WHERE user_id='{id}'");
	var ids = getSelIds("chx_entity_id");
	if(ids==""){
		alert("请先选中一条记录!");
		return;
	}

	if (!window.confirm("确认要删除吗?")) {
			return;
	}

	// 删除物探生产管理系统的用户
	var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
	var params = "deleteSql=update p_auth_user set bsflag='1', modifi_date=sysdate WHERE user_id='{id}'";
	params += "&ids="+ids;
	var retObject = syncRequest('Post',path,params);
	if(retObject.returnCode!=0) alert(retObject.returnMsg);
	else queryData(cruConfig.currentPage);
	
}

function JcdpButton3OnClick(){
	updateEntitiesBySql("update p_auth_user set user_pwd='5733C03AADA847E5948A9A78625EB4FC', modifi_date=sysdate where user_id='{id}'","重置密码");
}

var fields = new Array();
fields[0] = ['login_id','登陆ID','TEXT'];
fields[1] = ['user_name','名称','TEXT'];
fields[2] = ['if_admin','是否管理员','TEXT',,,'SEL_OPs',booleanOps];
fields[3] = ['org_name','单位','TEXT'];

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
	var params = cruConfig.editTableParams+"&rowParams="+rowParams.toJSONString();
	var retObject = syncRequest('Post',path,params);
	if(retObject.returnCode!=0){
		alert(retObject.returnMsg);
		return false;
	}else return true;
}

</script>
</head>
<body onload="page_init()">
<div id="queryDiv" style="display:">
<table  border="0" cellpadding="0" cellspacing="0" class="form_info" id="queryCdtTable" enctype="multipart/form-data">
</table>
</div>
<table  border="0" cellpadding="0" cellspacing="0" class="Tab_new_mod_del">
  <tr class="ali7">
  	<td width="60%">&nbsp;</td>
  	<td><span class="cx"><a href="#" onclick="classicQuery()" title="JCDP_btn_query"></a></span></td>
  	<td><span class="qc"><a href="#" onclick="clearQueryCdt()" title="JCDP_btn_clear"></a></span></td>
    <td><span class="zj"><a href="#" onclick="toAdd()" title="JCDP_btn_add"></a></span></td>
    <td><span class="xg"><a href="#" onclick="toEdit()" title="JCDP_btn_edit"></a></span></td>
    <td><span class="sc"><a href="#" onclick="toDelete()" title="JCDP_btn_delete"></a></span></td>
	<td><span class="cz"><a href="#" onclick="JcdpButton3OnClick()" title="JCDP_btn_reset_pwd"></a></span></td>
  </tr>
</table>

<div id="resultable"  style="width:100%;" >
<table border="0"  cellspacing="0"  cellpadding="0"  class="form_info"  width="100%" id="queryRetTable">
	<thead>

	<tr class="bt_info">
		<td class="tableHeader" 	 exp="<input type='radio' name='chx_entity_id' value='{user_id}'>">选择</td>
		<td class="tableHeader" 	 exp="<a href='userAndItems.cpmd?id={user_id}'>{login_id}</a>">登陆ID</td>
		<td class="tableHeader" 	 exp="{user_name}">名称</td>
		<td class="tableHeader" 	 exp="{org_name}">单位</td>
		<td class="tableHeader" 	 exp="{user_status}" func="getOpValue,userStatus">状态</td>
		<td class="tableHeader" 	 exp="{if_admin}" func="getOpValue,booleanOps">是否管理员</td>
		<td class="tableHeader" 	 exp="{email}">email</td>
		<td class="tableHeader" 	 exp="{login_ip}">最近登陆IP</td>
		<td class="tableHeader" 	 exp="{this_login_time}">最近登陆时间</td>
	</tr>
	</thead>
	<tbody>
	
	</tbody>
</table>
</div>
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
			<span>到&nbsp;<input type="text"  id="changePage"  class="rtToolbar_chkboxme">&nbsp;页<a href='javascript:changePage()'><img src='<%=contextPath%>/images/fenye_go.png' alt='Go' align="absmiddle" /></a></span>		
		</td>
	</tr>
</table>
</div>
</body>
</html>
