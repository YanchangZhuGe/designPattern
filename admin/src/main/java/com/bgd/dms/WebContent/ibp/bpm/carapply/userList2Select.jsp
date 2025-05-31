<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<%@ include file="/common/pmd_list.jsp"%>
<%@ include file="/common/pmd_list.jsp"%>
<title>选择页面</title>
</head>
<script language="javaScript">
<!--Remark JavaScript定义-->
var pageTitle = "用户列表页面";
var jcdp_codes_items = null;
var jcdp_codes = new Array(
);


	
	 
function page_init(){

   
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.contextPath = "<%=contextPath%>";
	
	var submitStr = "toSelColumnName=user_id";
	submitStr += "&rlTableName=null";
	submitStr += "&rlColumnName=null";
	submitStr += "&rlColumnValue=null";
	cruConfig.relationParams = submitStr;
	cdt_init();
	cruConfig.queryStr = "select  *  from  p_auth_user   where USER_NAME !=''";
	cruConfig.currentPageUrl = "/ibp/bpm/carapply/userList2Select.lpmd";
	queryData(1);
}

function selectEntities(){
	var ids = getSelIds("chx_entity_id");
	if(ids=="" && cruConfig.currentPageRlIds == ''){
		alert("请先选中一条记录!");
		return;
	}	

     var obj = window.dialogArguments;
	 var idValues = ids.split(',');
	 var userName ='';
	 for(var i=0 ; i< idValues.length ; i++){
	      userName += getColValue(idValues[i],1);
	      if(i < (idValues.length-1)){
	         userName = userName  + ','
	      }
	 }
    var cUserIdElement =obj.getElementByTypeAndName('INPUT','ccUserId');
    var cUserNameElement =obj.getElementByTypeAndName('INPUT','ccUserName');
	cUserIdElement.value =ids;
	cUserNameElement.value =userName;
	window.close();
}

var fields = new Array();
fields[0] = ['email','','TEXT'];
fields[1] = ['last_login_time','','TEXT'];
fields[2] = ['user_name','','TEXT'];
	
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

<body onload="page_init()">
<!--Remark 标题-->
<div id="nav">
  <ul><li id="cruTitle" style="filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='<%=contextPath%>/images/manage_r2_c13.jpg', sizingMethod='scale')"></li></ul>
</div>

<!--Remark 按钮区域-->
<!--Remark 快捷查询区域-->
<div id="basicSearch" >
<table class="searchUIBasic" cellSpacing=0 cellPadding=2 width="100%" align=center border=0>
<tr>
<td width="60" align=left noWrap>
	<span><img src="<%=contextPath%>/images/search.gif" width="25"></span><br>
	<span ><a class="tishi_1txt" href="javascript:divHide('basicSearch');divShow('advanceSearch');">组合查询</a></span>
</td>

<td width="150" class=noWrap>
	<select id=bas_field style="WIDTH: 150px" onChange="updateFieldOption(this, 'bas_cdt','bas_sel','bas_input');" /> 
</td>
<td width="100" class="noWrap">
	<select style='WIDTH: 100px' id="bas_cdt"/>
</td>
<td width="120" class="noWrap">
	<input class=txtBox style="WIDTH:120px" id="bas_input" style="display:none">
	<select class=txtBox id=bas_sel style="WIDTH: 120px"/> 
</td>
<td class="noWrap" align="left">
	<input class="button general" onClick="basicQuery();" type=button value=" 查找 " name=submit>&nbsp; 
</td>
<td ></td>
</tr>
</table>
</div>

<!--Remark 组合查询区域-->
<div id="advanceSearch" style="display:none">
<table class="searchUIBasic" cellSpacing=0 cellPadding=0 width="100%" align=center border=0>
<tr>
	<td width="60">
	<span><img src="<%=contextPath%>/images/search.gif" width="25"></span>
	<br>
	<span ><a class="tishi_1txt" href="javascript:divHide('advanceSearch');divShow('basicSearch');">快捷查询</a></span>	
	</td>
	
  <td width="380">
  	<div class=small id=fixed style="BORDER-RIGHT: #cccccc 1px solid; PADDING-RIGHT: 0px; BORDER-TOP: #cccccc 1px solid; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; OVERFLOW: auto; BORDER-LEFT: #cccccc 1px solid; WIDTH: 410; PADDING-TOP: 0px; BORDER-BOTTOM: #cccccc 1px solid; POSITION: relative; HEIGHT: 85px; BACKGROUND-COLOR: #FFFFCC">
    <table id="ComplexTable" width="95%" border=0>
      <tr>
        <td><select style="WIDTH: 150px" onChange="updateCmpOption(this)" name='cmp_field'/>
              </td>
        <td><select style='WIDTH: 100px' name='cmp_cdt'/></td>             
        <td width="50%"><input name='cmp_input' style="WIDTH:120px">
        	<select name='cmp_sel' style="WIDTH: 120px"/> 
        </td>
      </tr>
      <tr>
        <td><select style="WIDTH: 150px" onChange="updateCmpOption(this)" name='cmp_field'/>
              </td>
        <td><select style='WIDTH: 100px' name='cmp_cdt'/></td>             
        <td width="50%"><input name='cmp_input' style="WIDTH:120px">
        	<select name='cmp_sel' style="WIDTH: 120px"/> 
        </td>
      </tr>
      <tr>
        <td><select style="WIDTH: 150px" onChange="updateCmpOption(this)" name='cmp_field'/>
              </td>
        <td><select style='WIDTH: 100px' name='cmp_cdt'/></td>             
        <td width="50%"><input name='cmp_input' style="WIDTH:120px">
        	<select name='cmp_sel' style="WIDTH: 120px"/> 
        </td>
      </tr>
    </table>
  </div></td>
  
	<td align=left>
	<table cellSpacing=0 cellPadding=0 align=left border=0>
		<tr>	
		<td height="34" align=center>
		  <input class="button general" onClick="cmpQuery();" type=button value=" 查找 "> 
		</td>
		</tr>
		<tr>
		<td height="36" align=center>
		<input class="button other" onClick="addSearchRow()" type=button value="添加条件" name=more> 
		<input class="button other" onclick=deleteSearchRow() type=button value="减少条件" name=button>
		</td>
		</tr>
	
		</table>
	</td>
	<td></td>	
</tr>
</table>
</div>

<div id="div_button">
<table  cellSpacing=0 cellPadding=0 border=0 >
<tr>
<td >
<input class="button general" type="button" value="确认" onClick="selectEntities()">
<input class="button general" type="button" value="关闭" onClick="window.close()">
</td>
</tr>
</table>
</div>

<!--Remark 查询指示区域-->
<div id="rtToolbarDiv">
<table border="0"  cellpadding="0"  cellspacing="0"  class="rtToolbar"  width="100%" >
	<tr>
		<td></td>
	<td>
		<span id="dataRowHint">第0/0页,共0条记录 </span>&nbsp;&nbsp;
		到&nbsp;<input type="text"  id="changePage"  class="rtToolbar_chkboxme">&nbsp;页
		<a href='javascript:changePage()'><img src='<%=contextPath%>/images/table/bullet_go.gif'    alt='Go' align="absmiddle" /></a>		 </td>
		<td align="right" >
		<table id="navTableId" border="0"  cellpadding="0"  cellspacing="0" >
			<tr>
				<td><img src="<%=contextPath%>/images/table/firstPageDisabled.gif"  style="border:0"  alt="First" /></td>
				<td><img src="<%=contextPath%>/images/table/prevPageDisabled.gif"  style="border:0"  alt="Prev" /></td>
				<td><img src="<%=contextPath%>/images/table/nextPageDisabled.gif"  style="border:0"  alt="Next" /></td>
				<td><img src="<%=contextPath%>/images/table/lastPageDisabled.gif"  style="border:0"  alt="Last" /></td>				
			</tr>
		</table>
		</td>
	</tr>
</table>
</div>

<!--Remark 查询结果显示区域-->
<div style="OVERFLOW-y:scroll;">
<table class="rtTable" id="queryRetTable">
<thead>
<tr>
	<td exp="<input type='checkbox' name='chx_entity_id' value='{user_id}'>"><input type='checkbox' id='headChxBox' onclick="head_chx_box_changed(this)"></td>
	<td exp="{user_name}">user_name</td>
	<td exp="{user_status}">user_status</td>
	<td exp="{last_login_time}">last_login_time</td>
	<td exp="{login_id}">login_id</td>
	<td exp="{login_ip}">login_ip</td>
	<td exp="{user_domain}">user_domain</td>
</tr>
</thead>
</table>
</div>

</body>
</html>
