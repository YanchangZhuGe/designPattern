<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectType = request.getParameter("projectType");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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
var pageTitle = "非地震项目情况";
cruConfig.contextPath =  "<%=contextPath%>";

var substatus = new Array(
['0','未提交'],['1','已提交']
);

var jcdp_codes_items = null;
var jcdp_codes = new Array(
);


    function toAdd(){
    	window.location='edit.jsp?projectType=<%=projectType%>';
    }
    
  	function toEdit(){
  		
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
		
	    var tempa = ids.split(',');

	    var org_id = tempa[0];
	    var week_date = tempa[1];
	    var subflag = tempa[2];
	    
	    if(subflag == '0'){
	    	window.location = "edit.jsp?org_id="+org_id+"&week_date="+week_date+"&action=edit&projectType=<%=projectType%>";
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

	    var org_id = tempa[0];
	    var week_date = tempa[1];
	    var subflag = tempa[2];
	    
	    if(subflag == '0'){
	    	var sql = "update BGP_WR_PROJECT_DYNAMIC set bsflag='1' where project_type='<%=projectType%>' and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
			deleteEntities(sql);
	    }else{
	    	alert("该记录已经提交，不能删除!"); 
	    	return; 
	    }
	}
	
	function JcdpButton2OnClick(){
		
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
		
	    var tempa = ids.split(',');

	    var org_id = tempa[0];
	    var week_date = tempa[1];
	    var subflag = tempa[2];
	    
	    if(subflag == '0'){
	    	var sql = "update BGP_WR_PROJECT_DYNAMIC set subflag='1' where project_type='<%=projectType%>' and org_id='" + org_id + "' and to_char(week_date,'yyyy-MM-dd')='" + week_date + "'";
			updateEntitiesBySql(sql,"提交");
	    }else{
	    	alert("该记录已经提交，不能再次提交!"); 
	    	return; 
	    }
	}
  
function page_init(){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.funcCode = "F_PM_WR_016";
	cruConfig.cdtType = 'form';
	cdt_init();
	cruConfig.queryStr = "select distinct o.org_name,d.week_date,d.subflag,d.org_id from BGP_WR_PROJECT_DYNAMIC d,comm_org_information o where d.org_id=o.org_id and d.bsflag='0' and d.project_type='<%=projectType%>' and d.org_subjection_id like '<%=user.getSubOrgIDofAffordOrg()%>%' order by week_date desc";
	cruConfig.currentPageUrl = "/pm/wr/projectDynamic/list.jsp?projectType=<%=projectType%>";
	queryData(1);
}

var fields = new Array();
fields[0] = ['week_date','周报日期','D'];
fields[1] = ['subflag','状态','TEXT',,,'SEL_OPs',substatus];
	
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
<input class="iButton2" type="button" value="新增" onClick="toAdd()">
<input class="iButton2" type="button" value="修改" onClick="toEdit()">
<input class="iButton2" type="button" value="提交" onClick="JcdpButton2OnClick()">
<input class="iButton2" type="button" value="删除" onClick="toDelete()">
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
		<td class="tableHeader" 	 exp="<input type='radio' name='chx_entity_id' value='{org_id},{week_date},{subflag}'>">选择</td>
		<td class="tableHeader" autoOrder="1">序号</td> 
		<td class="tableHeader" 	 exp="<a href=javascript:link2self('edit.jsp?org_id={org_id}&week_date={week_date}&action=view&projectType=<%=projectType%>')>{week_date}</a>">周报日期</td>
		<td class="tableHeader" 	 exp="{subflag}" func="getOpValue,substatus">状态</td>
		<td class="tableHeader" 	 exp="{org_name}">单位</td>
	</tr>
	</thead>
	<tbody>
	
	</tbody>
</table>
</div>
</body>
</html>
