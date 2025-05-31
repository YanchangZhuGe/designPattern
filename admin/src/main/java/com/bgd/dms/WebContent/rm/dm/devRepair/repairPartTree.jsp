<%@ page language="java" contentType="text/html;charset=utf-8"
	pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
%>
<html>
<head>

<title>配件管理</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache" />
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<meta http-equiv="expires" content="0" />
<link rel="stylesheet" type="text/css"
	href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css"
	href="<%=contextPath%>/js/extjs/UAS/css/patch.css" />
<style type="text/css">
.maddIcon {
	background-image: url(<%=contextPath%>/js/extjs/UAS/images/add.png) !important;
}

.mdelIcon {
	background-image: url(<%=contextPath%>/js/extjs/UAS/images/del.png) !important;
}

.meditIcon {
	background-image: url(<%=contextPath%>/js/extjs/UAS/images/edit.png) !important;
}

.faddIcon {
	background-image: url(<%=contextPath%>/js/extjs/UAS/images/plugin_add.png) !important;
}

.fdelIcon {
	background-image: url(<%=contextPath%>/js/extjs/UAS/images/plugin_delete.png) !important
		;
}

.feditIcon {
	background-image: url(<%=contextPath%>/js/extjs/UAS/images/plugin_edit.png) !important;
}

.nodeIcon {
	background-image: url(<%=contextPath%>/js/extjs/UAS/images/leaf.gif) !important;
}

.menuLeafNodeIcon {
	background-image: url(<%=contextPath%>/js/extjs/UAS/images/menu_leaf.gif) !important;
}

.fNodeIcon {
	background-image: url(<%=contextPath%>/js/extjs/UAS/images/func.png) !important;
}
</style>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>
<script type="text/javascript" src="extTreeMenu.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script type="text/javascript">
	var mId;
	var name;
	var level;
	var hint;
	var parentId="";
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	function doInsert() {
		if (mId == null) {
			alert("请先选中一个节点");
			return;g
		}
		/***
		if(level==0){
			alert("aaaaaaaaaaaaaaaaaa");
		}else{//叶子节点增加功能
			alert("bbbbbbbbbbbbbbbbbb");
		}
		***/
		path = "<%=contextPath%>/rm/dm/devRepair/repairPartNew.jsp?pagerAction=edit2Add&lineRange=1&noCloseButton=true&parent_id="+mId;
		parent.menuFrame.location.href = path;
	}
	
	function doUpdate() {
		if (mId == null) {
			alert("请先选中一个节点");
			return;
		}
		path = "<%=contextPath%>/rm/dm/devRepair/repairPartModify.jsp?pagerAction=edit2Add&lineRange=1&noCloseButton=true&id="+mId+"&parent_id="+parentId;
		parent.menuFrame.location.href = path;
	}
	
	function doDelete() {
	if (mId == null) {
		alert("请先选中一个节点");
		return;
	}
	//判断是否可以删除记录
	//1.对于有子类别的记录无法删除
	 var idsql = "select t.id              as id \n" +
								    	"  from GMS_DEVICE_PART_TREE t where t.bsflag = 0 \n" +  
								    	" start with id = '"+mId+"'\n" + 
								    	"connect by parent_id = prior id "; 
	 var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+idsql);
	 var basedatas = queryRet.datas;
	 if(basedatas.length>1){
		 alert('请先删除子类别!');
		 return;
	 }
	//2.无子类别但是有配件信息的无法删除
	 var itemsql = "select t.id              as id \n" +
 	"  from GMS_DEVICE_PART_ITEM t  where t.tree_id = '" + mId + "' \n";
	var queryrlt = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+itemsql);
	var data = queryrlt.datas;
	if(data.length>0){
	alert('请先删除该类别的配件信息!');
	return;
	}
	if(!window.confirm("确认要删除")){
		return;
	}
	/*********
		var u;
		 var idsql = "select t.id              as id \n" +
									    	"  from GMS_DEVICE_PART_TREE t \n" +  
									    	" start with id = '"+mId+"'\n" + 
									    	"connect by parent_id = prior id "; 
			var querySql = 
				"SELECT TREE_ID, SUMNUM, C.PART_NAME\n" +
				"  FROM (SELECT COUNT(1) AS SUMNUM, T.PART_TYPE_TREE_ID AS TREE_ID\n" + 
				"          FROM GMS_DEVICE_REPARE_PART T\n" + 
				"         WHERE T.BSFLAG = 0\n" + 
				"           AND T.PART_TYPE_TREE_ID IN\n" + 
				" ("+idsql+") "+
				"         GROUP BY T.PART_TYPE_TREE_ID) B,\n" + 
				"       GMS_DEVICE_PART_TREE C\n" + 
				" WHERE B.TREE_ID = C.ID(+)";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
				var basedatas = queryRet.datas;
			for(var index = 0;index<basedatas.length;index++){
			if(basedatas[index].sumnum > 0 ){
				alert("选择的配件"+basedatas[index].part_name+"正在使用，无法删除!");
				return ;
			}
			}
		**********/
		/******************/
	var sql = "update GMS_DEVICE_PART_TREE set bsflag='1' where id in ("+idsql+")";
	var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
	var params = "deleteSql="+sql;
	params += "&ids=";
	var retObject = syncRequest('Post',path,params);
	if (retObject.returnCode == "0") { 
 		alert("删除成功!");
 	} else {
 		alert("删除失败 !");
 	}
	/***********************/
		return true;
	}
	function leafClick(node, e) {
			mId = node.attributes.id;
			name = node.attributes.text;
			level = node.attributes.menuLeaf;
			hint = node.attributes.hint;
			parentId =  node.attributes.parentId;
			path = "<%=contextPath%>/rm/dm/devRepair/repairPartDetailList.jsp?id="+mId+"&parent_id="+parentId;
			parent.menuFrame.location.href = path;
	 };
	function referesh() {
		location.href="<%=contextPath%>/rm/dm/devRepair/repairPartFrame.jsp";
	}
	createTree('<%=contextPath%>/rad/asyncQueryList.srq',"menuTree","INIT_REPAIR_012345678900000");
	</script>

</head>

<body>
<table border="0" cellpadding="0" cellspacing="0" id="FilterLayer"
	width="100%">
	<tr>
		<td align="left">
		<div id="menuTree" style="width: 100%; height: 100%; overflow: auto;"></div>
		</td>
	</tr>
</table>
</body>
</html>