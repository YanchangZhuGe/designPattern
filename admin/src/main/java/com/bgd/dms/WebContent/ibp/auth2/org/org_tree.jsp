<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	UserToken user = (UserToken)request.getSession().getAttribute("SYS_USER_TOKEN_ID");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<link href="<%= contextPath %>/styles/table.css" rel="stylesheet" type="text/css" />
<!-- ext -->
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css">
<link rel="stylesheet" type="text/css" href="<%=extPath %>/UAS/css/patch.css" />
<style type="text/css">
			.faddIcon{
				background: url(<%=extPath %>/UAS/images/plugin_add.png); !important;
			}
			.fdelIcon{
				background: url(<%=extPath %>/UAS/images/plugin_delete.png); !important;
			}
			.feditIcon{
				background: url(<%=extPath %>/UAS/images/plugin_edit.png);  !important;
			}
		</style>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script type="text/javascript">
var extPath = "<%=extPath%>";
var rootMenuId = "<%= user == null ? "" : user.getOrgId()%>";
cruConfig.contextPath = "<%=contextPath%>";
var querySql = "Select org_name FROM p_auth_org WHERE org_id='"+rootMenuId+"' order by order_num";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
var rootMenuName = queryOrgRet.datas[0].org_name; 
var treeDivId = "menuTree";
var loadingIcon = extPath+"/resources/images/default/shared/blue-loading.gif";
var blank_image_url = extPath+"/resources/images/default/s.gif";
var treeCfg = {
	region : 'west',// 设定显示区域为东边,停靠在容器左边
	split : true,// 出现拖动条
	bodyStyle:"padding:2px",
	collapseMode : 'mini',// 拖动条显示类型为mini,可出现拖动条中间的尖头
	width : 380,// 初始宽度
	minSize : 210,// 拖动最小宽度
	maxSize : 300,// 拖动最大宽度
	collapsible : true,// 允许隐藏
	title : "JCDP_orgTree",// 显示标题为树
	lines : true,// 出现节点间虚线
	autoScroll : true,// 自动出现滚动条
	frame : false,
	enableDD:true	
};
</script>

<script language="javascript" type="text/javascript">
/**
	定义右键菜单
*/
function setRightMenu()
{
	var menuItems = [
		{
			text:"JCDP_editOrg",
			iconCls : "feditIcon",
			handler:function(){
				editNode(selectedNode);
			}
		},
		{
			text : '机构功能集',
			iconCls : '',
			handler : function(){
				var href = "<%=contextPath%>/ibp/auth2/menu/menuTree.jsp?hideCheck=true&type=1&edit=false&id="+selectedNode.id;
				parent.menuFrame.location.href = href;	
			}
		}
	];
		
	if(selectedNode && !selectedNode.isLeaf()){
		//menuItems.unshift("-");
		menuItems.unshift(
			{
				text:"JCDP_addOrg",
				iconCls : "faddIcon",
				handler:function(){
					addNode(selectedNode);
				}
			}
		);
	}
	if(selectedNode && selectedNode.isLeaf()){
		//menuItems.push("-");
		menuItems.unshift(
			{
				text:"JCDP_delOrg",
				iconCls : "fdelIcon",
				handler:function(){
					deleteNode(selectedNode);
				}
			}
		);
	}
	
	rightMenu = new Ext.menu.Menu({
		items:menuItems
	});
}

/**
	删除菜单
*/
function deleteNode(selectedNode)
{
	if (selectedNode.id == null) {
		alert("JCDP_chooseNode!");
		return;
	}
	
	if (selectedNode.id == rootMenuId) {
		alert("JCDP_nodeNoDel!");
		return;
	}	
	
	if (!window.confirm("确定要删除:["+selectedNode.text+"],会删除机构及下属机构的所有角色和用户?")) {
			return;
	}
	
	
	var submitStr = "org_id="+selectedNode.id;
	var ret = syncRequest('post',"<%=contextPath%>/ibp/auth2/deleteOrg.srq",submitStr);
	if(ret.returnCode!='0'){
		alert(ret.returnMsg);
		return;
	}
	
	selectedNode.remove();
}

/**
	新增菜单
*/
function addNode(selectedNode)
{

	if (selectedNode.id == null) {
		alert("JCDP_chooseNode!");
		return;
	}
	var href = "org.upmd?pagerAction=edit2Add&lineRange=1&noCloseButton=true&parentId="+selectedNode.id+"&parentName="+selectedNode.text+"&refreshId="+selectedNode.id;
	parent.menuFrame.location.href = href;	
}


/**
	修改菜单
*/
function editNode(selectedNode)
{
    var herfUrl = "";
	if (selectedNode.id == null) {
		alert("JCDP_chooseNode!");
		return;
	} 
	if (selectedNode.id == "INIT_AUTH_ORG_012345678000000") {
	    herfUrl = "org.upmd?pagerAction=edit2Edit&lineRange=1&noCloseButton=true&id="+selectedNode.id;
	} else {
	    herfUrl = "org.upmd?pagerAction=edit2Edit&lineRange=1&noCloseButton=true&id="+selectedNode.id+"&refreshId="+(selectedNode.parentNode ? selectedNode.parentNode.id : '');
	}
	parent.menuFrame.location.href = herfUrl;	

}

/**
	移动节点
*/
function moveMenu(tree,node,oldParent,newParent,index){
	var actionUrl = "<%=contextPath%>"+jcdpTreeCfg.moveNodeAction;
	var submitStr = "tableName=p_auth_org&pkName=org_id&fkName=parent_id&orderName=order_num&leafFlagName=is_leaf";
	submitStr += "&pkValue="+node.id+"&index="+index+"&oldParentId="+oldParent.id+"&newParentId="+newParent.id;
	var ret = syncRequest('post',actionUrl,submitStr);
	if(ret.returnCode!='0'){
		alert(ret.returnMsg);
		return;
	}
}


/**
	获取parentNode的子节点
*/
function getSubNodes(parentNode) {
	if(parentNode.firstChild.text!='loading') return;
		
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"100",
			querySql:"Select * FROM p_auth_org WHERE parent_id='"+parentNode.id+"' ORDER  BY  order_num "
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
			
			if(!parentNode.firstChild){// 如果没有孩子，设置图标样式为文件夹
				parentNode.ui.addClass("x-tree-node-collapsed");
			}
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
			id : nodeData.org_id,
			text : nodeData.org_name,// 显示内容									
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
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 
<script type="text/javascript" src="<%=extPath %>/tree.js"></script>       
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