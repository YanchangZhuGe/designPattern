<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String deptId = request.getParameter("id");
	String corpId = request.getParameter("corpId");
	System.out.println(deptId);
	System.out.println(corpId);
	
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


  	  function JcdpButton4OnClick(){
  	  			ids = getSelIds('chx_entity_id');
			    if(ids==''){ alert("请先选中一条记录!");
			     return;
			    } 
			    var tempa = ids.split(',');
			    var person_id = tempa[0];
			    editUrl = "/market/personOrder.srq?person_id="+person_id; 
			    var returnVlue=window.showModalDialog(cruConfig.contextPath+editUrl,window,"dialogHeight:200px;dialogWidth:600px;");
			    
  	  }
  	  
	  function viewLink(person_id){  			
		    	editUrl = "/market/viewPerson.srq?person_id="+person_id;
		    	window.location=cruConfig.contextPath+editUrl+"&backUrl="+cruConfig.currentPageUrl;
			}
	  function toAdd(){
		 	var corpId = "<%=corpId%>";
	  		var deptId = "<%=deptId%>";
			window.location=cruConfig.contextPath+"/market/departmentPage/addPerson.jsp?corpId="+corpId+"&deptId="+deptId +"&pagerAction=edit2Add&backUrl="+cruConfig.currentPageUrl;
			
		    }		 
		    
	 function toEdit(){
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	    var tempa = ids.split(',');
	    var person_id = tempa[0];
	    	editUrl = "/market/editPerson.srq?person_id="+person_id; 
	    	window.location=cruConfig.contextPath+editUrl; 
	}
	
	   
	 function toDelete(){
		 ids = getSelIds('chx_entity_id');
	    	if(ids==''){ alert("请先选中一条记录!");
	     	return;
	   	 } 
	   	 var tempa = ids.split(',');
	   	 var person_id = tempa[0];
	   	 var name = tempa[1];
	 	 deleteEntities("update ci_person set bsflag='1' where person_id='{id}'");
	 	 	var title = "在油公司人员维护中里删除了一个姓名为：“"+name+"”的人员"
			var operationPlace = "油公司人员维护";
			var submitStr = "title="+encodeURI(encodeURI(title))+"&operationPlace="+encodeURI(encodeURI(operationPlace));
			var retObject=jcdpCallService("MarketInfoInputSrv","logDelete",submitStr);
			queryData(1);
	}
	function refreshData(){
	classicQuery();
	}
  
function page_init(){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.cdtType = 'form';
	cdt_init();
	cruConfig.queryStr = "select p.corp_id, p.dept_id, p.order_no, p.name, p.person_id, p.office_phone, (select d.dept_name from ci_department d where d.dept_id = '<%=deptId%>') as dept_name, p.duty, p.APP_STATUS, p.CREATOR from ci_person p where p.bsflag='0' and p.dept_id = '<%=deptId%>' and p.corp_id = '<%=corpId%>' order by to_number(p.order_no)";
	cruConfig.currentPageUrl = "/market/departmentPage/selectPerson.lpmd";
	queryData(1);
}

function toBack(){
	window.location="<%=contextPath%>/market/departmentPage/DepartmentList.jsp?corpId=<%=corpId%>";
}


var fields = new Array();
fields[0] = ['name','姓名','TEXT'];
fields[1] = ['duty','职务','TEXT'];
	
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
<input class="iButton2" type="button" value="返回" onClick="toBack()">
<input class="iButton2" type="button" value="删除" onClick="toDelete()">
<input class="iButton2" type="button" value="调整人员位置" onClick="JcdpButton4OnClick()">
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
		<td class="tableHeader" 	 exp="<input type='radio' name='chx_entity_id' value='{person_id},{name}'>">选择</td>
		<td class="tableHeader" 	 exp="<a href=javascript:viewLink('{person_id}') >{name}</a>">名字</td>
		<td class="tableHeader" 	 exp="{duty}">职务</td>
		<td class="tableHeader" 	 exp="{dept_name}">所在部门</td>
		<td class="tableHeader" 	 exp="{office_phone}">办公室电话</td>
	</tr>
	</thead>
	<tbody>
	
	</tbody>
</table>
</div>
</body>
</html>
