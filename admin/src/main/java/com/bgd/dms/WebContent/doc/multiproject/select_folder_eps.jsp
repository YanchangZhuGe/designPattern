<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	String module_id = request.getParameter("moduleId") != null?request.getParameter("moduleId"):"";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>

<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";
var moduleId = "<%=module_id%>";

cruConfig.contextPath = "<%=contextPath%>";

/**公共变量定义*/

var queryRootIdSql = "select f.file_id from bgp_doc_gms_file f where f.bsflag = '0' and f.parent_file_id is null and f.project_info_no is null and f.is_file = '0' and f.is_template is null";
var queryRootRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+queryRootIdSql);
var rootMenuId = queryRootRet.datas[0].file_id;

var querySql = "Select b.file_name FROM bgp_doc_gms_file b WHERE b.file_id = '"+rootMenuId+"' and b.bsflag='0' and b.is_file='0' and b.parent_file_id is null and b.ucm_id is null";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
var rootMenuName = queryOrgRet.datas[0].file_name; 
</script>

<link href="<%= contextPath %>/styles/table.css" rel="stylesheet" type="text/css" />
<!-- ext -->
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 
<script type="text/javascript" src="<%=extPath %>/tree.js"></script> 


<script language="javascript" type="text/javascript">
var treeDivId = "menuTree";
var loadingIcon = extPath+"/resources/images/default/shared/blue-loading.gif";
var blank_image_url = extPath+"/resources/images/default/s.gif";
var default_image_url = "<%=contextPath%>/images/images/tree_15.png";

jcdpTreeCfg.rightClickEvent = false;
jcdpTreeCfg.moveEvent = false;
jcdpTreeCfg.dbClickEvent = true;

var treeCfg = {
	region : 'west',// 设定显示区域为东边,停靠在容器左边
	split : true,// 出现拖动条
	bodyStyle:"padding:2px",
	collapseMode : 'mini',// 拖动条显示类型为mini,可出现拖动条中间的尖头
	width : 530,// 初始宽度
	minSize : 210,// 拖动最小宽度
	maxSize : 300,// 拖动最大宽度
	collapsible : true,// 允许隐藏
	title : "选择编码",// 显示标题为树
	lines : true,// 出现节点间虚线
	autoScroll : true,// 自动出现滚动条
	frame : false,
	enableDD:true	
};

function setRightMenu()
{

}

function moveMenu(tree,node,oldParent,newParent,index){

}

function dbClickNode(node){
	if(node.id!=rootMenuId){
		var obj = window.dialogArguments;
		obj.fkValue = node.id;
		obj.value = node.text;
		window.close();
	}
}

function checkModuleID(the_module_id){
	var querySql1 = "Select b.* FROM bgp_doc_folder_module b WHERE b.module_id = '"+the_module_id+"' and b.bsflag='0' and b.project_info_no is null";
	var queryOrgRet1 = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql1);
	if(queryOrgRet1.datas.length == 0){
		return 0;
	}else{
		return 1;
	}		
} 


var checkSql;
if(checkModuleID(moduleId) == 1){
	checkSql = "select f.file_id, f.file_name from bgp_doc_folder_module t join bgp_doc_gms_file f on t.folder_id = f.file_id and t.bsflag='0' and t.project_info_no is null and t.module_id = '"+moduleId+"'";
}

if(checkModuleID(moduleId) == 0){
	checkSql = "select f.file_id, f.file_name from bgp_doc_gms_file f where f.bsflag = '0' and f.is_file = '0' and f.parent_file_id = '"+rootMenuId+"' and f.is_file='0' and f.project_info_no is null";
}


/**
	获取parentNode的子节点
*/
function getSubNodes(parentNode) {
	if(parentNode.firstChild.text!='loading') return;
	
	var parentCondition = " SUPERIOR_CODE_ID ";
	if (rootMenuId==parentNode.id) {
		parentCondition += "in ('0','1')";
	}else{
		parentCondition += "='"+parentNode.id+"'";
	}
	
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:checkSql
			//querySql:"select f.file_id, f.file_name from bgp_doc_folder_module t join bgp_doc_gms_file f on t.folder_id = f.file_id and t.bsflag='0' and t.project_info_no is null and t.module_id = '"+moduleId+"'"

			//querySql:"Select t.coding_code_id,t.coding_name,case (select count(ccsd.coding_code_id) from comm_coding_sort_detail ccsd where ccsd.SUPERIOR_CODE_ID=t.coding_code_id and ccsd.bsflag='0') when 0 then '1' else '0' end as is_leaf FROM comm_coding_sort_detail t WHERE t.coding_sort_id='"+rootMenuId+"' and t.bsflag='0' and "+parentCondition+" order by t.CODING_SHOW_ID"
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;
			
			for (var i = 0; i < nodes.length; i++) {
				var treeNode = getTreeNode(nodes[i]);
				
				appendEvent(treeNode);
				parentNode.appendChild(treeNode);
				treeNode.removeListener('expand',getSubNodes);
				treeNode.on('expand', getSubNodes1);
			}
			parentNode.firstChild.remove();// 删除当前节点第一个孩子节点(loading节点)	
		},
		failure : function(){// 失败
							}			
	});//eof Ext.Ajax.request
}

/**
 * 获取目录结构
 */
function getSubNodes1(parentNode) {
	if(parentNode.firstChild.text!='loading') return;

	var parentCondition = " SUPERIOR_CODE_ID ";
	if (rootMenuId==parentNode.id) {
		parentCondition += "in ('0','1')";
	}else{
		parentCondition += "='"+parentNode.id+"'";
	}
	
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:"Select b.file_id,b.file_name FROM bgp_doc_gms_file b WHERE b.parent_file_id = '"+parentNode.id+"' and b.bsflag='0' and b.is_file='0' and b.ucm_id is null"
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;
			
			for (var i = 0; i < nodes.length; i++) {
				var treeNode = getTreeNode(nodes[i]); 		
				appendEvent(treeNode);
				parentNode.appendChild(treeNode);
				treeNode.removeListener('expand',getSubNodes);
				treeNode.on('expand', getSubNodes1);
			}
			parentNode.firstChild.remove();// 删除当前节点第一个孩子节点(loading节点)	
		},
		failure : function(){// 失败
							}			
	});//eof Ext.Ajax.request
}

/**
	根据服务器查询到的nodeData构造ext树节点
*/
function getTreeNode(nodeData){
	var treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.file_id,
			text : nodeData.file_name,// 显示内容		
			icon : default_image_url,
			leaf : false,								
			singleClickExpand:true,
			children: [{// 添加loading子节点
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
	});	
	
	if(nodeData.is_leaf=="1"){//叶子节点
		treeNode.leaf = true;
		treeNode.singleClickExpand = false;
	}
	
	return treeNode;
}


</script>      

</head>
<body>
<table border="0" cellpadding="0" cellspacing="0"  id="FilterLayer" width="100%">
	<tr>
		<td align="left">
			<div id="menuTree" style="width:100%;height:100%;overflow:auto;"></div>
		</td>
	</tr>
</table>



</body>
</html>