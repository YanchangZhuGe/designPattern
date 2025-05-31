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
<script type="text/javascript" src="/epDemo/js/rt/rt_list.js"></script>  
<script type="text/javascript" src="/epDemo/js/rt/rt_base.js"></script>
<script type="text/javascript" src="/epDemo/js/rt/rt_search.js"></script>
<script type="text/javascript" src="/epDemo/js/json.js"></script>

<link rel="stylesheet" href="/epDemo/css/rt_table.css" type="text/css" />  
<link rel="stylesheet" href="/epDemo/css/common.css" type="text/css" />
<link rel="stylesheet" href="/epDemo/css/main.css" type="text/css" />
<title>列表页面</title>
</head>
<script language="javaScript">
<!--Remark JavaScript定义-->
var pageTitle = "流程模板选择";
var jcdp_codes_items = null;
var jcdp_codes = new Array(
);

function page_init(){
	getObj("cruTitle").innerHTML = pageTitle;
	cruConfig.contextPath = "/epDemo";
	cdt_init();
	cruConfig.queryStr = "select * from wf_d_procdefine where STATE=0";
	queryData(1);
	cruConfig.editedColumnNames = "ENTITY_ID";
}

var fields = new Array();
fields[0] = ['PROC_NAME','流程名称','TEXT'];
	
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

function onlineEdit(rowParams){
	var path = cruConfig.contextPath+cruConfig.editAction;
	var params = cruConfig.editTableParams+"&rowParams="+rowParams.toJSONString();
	var retObject = syncRequest('Post',path,params);
	if(retObject.returnCode!=0){
		alert(retObject.returnMsg);
		return false;
	}else return true;
}

function toAdd(){
	infos = getSelIds('chx_entity_id');
	if(infos==''){
		alert("请先选中一条记录!");
		return;
	}
	
	var ids="";
	var names="";
	var procEName="";
	var procVersion="";
	
	infoAarray=infos.split(',');
	procEName=infos.split('@')[2];
	procVersion=infos.split('@')[3];
	for(var i=0;i<infoAarray.length;i++)
	{
	 var id=infoAarray[i].split('@')[0];
	 var name=infoAarray[i].split('@')[1];
	  ids=ids+id+",";
	  names=names+name+",";
	
	}
	
	
	if(ids.length>0)
	{
	ids=ids.substring(0,ids.length-1);
	}
	if(names.length>0)
	{
	names=names.substring(0,names.length-1);
	}
     window.close();
     window.parent.opener.returnProcnfos(names,ids,procEName,procVersion);

}
</script>

<body onLoad="page_init()">
<!--Remark 标题-->
<div id="nav">
    <ul><li id="cruTitle" class="bg_image_onclick"></li></ul>
</div>


<!--Remark 按钮区域-->
<div id="div_button">
<table  cellSpacing=0 cellPadding=0 border=0 >
<tr>
<td>
<input class="button general" type="button" value="添加" onClick="toAdd()">

</td>
</tr>
</table>
</div>
<!--Remark 快捷查询区域-->
<div id="basicSearch" >
<table class="searchUIBasic" cellSpacing=0 cellPadding=2 width="100%" align=center border=0>
<tr>
<td width="60" align=left noWrap>
	<span><img src="/epDemo/images/search.gif" width="25"></span><br>
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
	<span><img src="/epDemo/images/search.gif" width="25"></span>
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

<!--Remark 查询指示区域-->
<div id="rtToolbarDiv">
<table border="0"  cellpadding="0"  cellspacing="0"  class="rtToolbar"  width="100%" >
	<tr>
		<td></td>
	<td>
		<span id="dataRowHint">第0/0页,共0条记录 </span>&nbsp;&nbsp;
		到&nbsp;<input type="text"  id="changePage"  class="rtToolbar_chkboxme">&nbsp;页
		<a href='javascript:changePage()'><img src='/epDemo/images/table/bullet_go.gif'    alt='Go' align="absmiddle" /></a>		 </td>
		<td align="right" >
		<table id="navTableId" border="0"  cellpadding="0"  cellspacing="0" >
			<tr>
				<td><img src="/epDemo/images/table/firstPageDisabled.gif"  style="border:0"  alt="First" /></td>
				<td><img src="/epDemo/images/table/prevPageDisabled.gif"  style="border:0"  alt="Prev" /></td>
				<td><img src="/epDemo/images/table/nextPageDisabled.gif"  style="border:0"  alt="Next" /></td>
				<td><img src="/epDemo/images/table/lastPageDisabled.gif"  style="border:0"  alt="Last" /></td>				
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
	<td exp="<input type='checkbox' name='chx_entity_id' value='{entity_id}@{proc_name}@{proc_e_name}@{proc_version}'>"><input type='checkbox' id='headChxBox' onclick="head_chx_box_changed(this)"></td>
	<td exp="{entity_id}" isShow="Hide" style="display:none">ENTITY_ID</td>
	<td exp="{proc_name}" fieldName="流程名称">PROC_NAME</td>
	<td exp="{proc_e_name}" fieldName="流程英文名称">PROC_E_NAME</td>
	<td exp="{proc_version}" fieldName="版本号">PROC_VERSION</td>
</tr>
</thead>
</table>
</div>

</body>
</html>
