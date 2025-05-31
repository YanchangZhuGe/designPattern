<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	//String rootMenuId = request.getParameter("project_info_no");
	//String rootMenuId = "8ad889f13759d014013759d3de520003";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title></title>
<link href="<%= contextPath %>/styles/table.css" rel="stylesheet" type="text/css" />
<!-- ext -->
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css" />
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 
<script type="text/javascript" src="<%=extPath %>/tree.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";
cruConfig.contextPath = "<%=contextPath%>";

/**公共变量定义*/

var queryRootIdSql = "select f.file_id from bgp_doc_gms_file f where f.bsflag = '0' and f.parent_file_id is null and f.project_info_no is null and f.is_file = '0' and f.is_template is null";
var queryRootRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+queryRootIdSql);
var rootMenuId = queryRootRet.datas[0].file_id;


var querySql = "Select b.file_id,b.file_name,b.file_abbr FROM bgp_doc_gms_file b WHERE b.file_id = '"+rootMenuId+"' and b.bsflag='0' and b.is_file='0' and b.parent_file_id is null and b.ucm_id is null";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
var rootMenuName = queryOrgRet.datas[0].file_name; 

var treeDivId = "menuTree";
var loadingIcon = extPath+"/resources/images/default/shared/blue-loading.gif";
var blank_image_url = extPath+"/resources/images/default/s.gif";
var default_image_url = "<%=contextPath%>/images/images/tree_15.png";

jcdpTreeCfg.clickEvent=true;
jcdpTreeCfg.moveEvent = false;
var treeCfg = {
	region : 'west',// 设定显示区域为东边,停靠在容器左边
	border : false,
	split : true,// 出现拖动条
	bodyStyle:"padding:2px",
	collapseMode : 'mini',// 拖动条显示类型为mini,可出现拖动条中间的尖头
	width : 300,// 初始宽度
	minSize : 250,// 拖动最小宽度
	maxSize : 300,// 拖动最大宽度
	collapsible : true,// 允许隐藏
	title : "企业文档",// 显示标题为树
	lines : true,// 出现节点间虚线
	autoScroll : true,// 自动出现滚动条
	frame : false,
	enableDD:true	
};



//设置右键菜单
function setRightMenu()
{

}

function moveMenu(tree,node,oldParent,newParent,index){

}

function clickNode(selectedNode){

	//显示目录下面的所有文档
	//parent.menuFrame.location.href = "<%=contextPath%>/doc/multiproject/doc_list_eps1.jsp?folderid="+selectedNode.id;
	parent.mainFrame.refreshData(selectedNode.id);
	//parent.mainBottomframe.location.href = "<%=contextPath%>/doc/multiproject/blank.htm";
	parent.mainFrame.clearCommonInfo();
}


/**
	获取parentNode的子节点
*/
function getSubNodes(parentNode) {
	if(parentNode.firstChild.text!='loading') return;
		
	Ext.Ajax.request({
		url : "<%=contextPath%>/rad/asyncQueryList.srq",
		params : {
			currentPage:"1",
			pageSize:"100",
			querySql:"Select file_id,file_name,file_abbr FROM BGP_DOC_GMS_FILE WHERE PARENT_FILE_ID='"+parentNode.id+"' and bsflag='0' and is_file='0' ORDER BY order_num"
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;
			
			for (var i = 0; i < nodes.length; i++) {
				var treeNode = getTreeNode(nodes[i]);
				
				appendEvent(treeNode);
				parentNode.appendChild(treeNode);
				
			}
			parentNode.firstChild.remove();// 删除当前节点第一个孩子节点(loading节点)	
			parentNode.ui.addClass("x-tree-node-collapsed");//设置样式为文件夹，防止没有子机构而改变样式
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
			singleClickExpand:false,
			children: [{// 添加loading子节点
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
	});	
	
	//叶子节点
	if(nodeData.is_leaf=="1"){
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