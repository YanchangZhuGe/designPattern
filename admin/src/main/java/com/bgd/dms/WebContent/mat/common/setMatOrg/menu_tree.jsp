<%@ page language="java" pageEncoding="utf-8"%>

<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title></title>
<link href="<%=contextPath%>/styles/table.css" rel="stylesheet" type="text/css" />
<!-- ext -->
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath%>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script> 
<script type="text/javascript" src="<%=extPath%>/tree.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";

/**公共变量定义*/
var rootMenuId = "MAT_MENU_ID_C105";

var rootMenuName = "东方公司";

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
	title : "菜单树",// 显示标题为树
	lines : true,// 出现节点间虚线
	autoScroll : true,// 自动出现滚动条
	frame : false,
	enableDD:true	
};

/**
	定义右键菜单
*/
function setRightMenu()
{
	rightMenu = new Ext.menu.Menu({
		items:[{
			text:"新增菜单",
			handler:function(){
				addNode(selectedNode);
			}
		},"-",{
			text:"编辑菜单",
			handler:function(){
				editNode(selectedNode);
			}
		},"-",{
			text:"删除菜单",
			handler:function(){
				deleteNode(selectedNode);
			}
		}]
	});
}

/**
	删除菜单
*/
function deleteNode(selectedNode)
{
	if (selectedNode.id == null) {
		alert("请先选中一个节点!");
		return;
	}
	
	if (selectedNode.id == rootMenuId) {
		alert("根节点不能被删除!");
		return;
	}	
	
	var cStr="确认要删除:["+selectedNode.text+"]及其子菜单?";
	if(selectedNode.isLeaf()) 
	     cStr="确认要删除:["+selectedNode.text+"]?"
	if (!window.confirm(cStr)) {
		 return;
	}
	
	var submitStr = "menuId="+selectedNode.id;
	var ret = syncRequest('post',"../deleteMenu.srq",submitStr);
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
		alert("请先选中一个节点!");
		return;
	}

	parent.menuFrame.location.href = "addMenu.jsp?parentMenuId="+selectedNode.id;
}


/**
	修改菜单
*/
function editNode(selectedNode)
{

	if (selectedNode.id == null) {
		alert("请先选中一个节点!");
		return;
	}
	var actionUrl = "editMenu.jsp?isLeafNode=false&id="+selectedNode.id;
	if(selectedNode.isLeaf()) 
		actionUrl = "menuAndItems.cpmd?id="+selectedNode.id;
	parent.menuFrame.location.href = actionUrl;
}

/**
	移动菜单节点
*/
function moveMenu(tree,node,oldParent,newParent,index){
if(index<0){
index=0;
}

	var actionUrl = "<%=contextPath%>/tcg/moveTreeNodePosition.srq";
	var submitStr = "tableName=p_auth_menu&pkName=menu_id&fkName=parent_menu_id&orderName=order_num&leafFlagName=is_leaf";
	submitStr += "&pkValue="+node.id+"&index="+index+"&oldParentId="+oldParent.id+"&newParentId="+newParent.id;
	var ret = syncRequest('post',actionUrl,submitStr);
	if(ret.returnCode!='0'){
		alert(ret.returnMsg);
		rctTree.getRootNode().reload();
		 return false; 
	}
		
	//alert(node.text+index);
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
			querySql:"Select * FROM gms_mat_buss_menu WHERE fathetr_mat_menu_id='"+parentNode.id+"' ORDER BY order_num desc"
		},
		method : 'Post',
		success : function(resp){
		
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;
			for (var i = 0; i < nodes.length; i++) {
				var treeNode = getTreeNode(nodes[i]);
				appendEvent(treeNode);
			
			  if(parentNode.childNodes.length>1){
			      checkTreeNode(parentNode.childNodes,treeNode,parentNode);
			   }else{
			     treeNode.attributes.checked=parentNode.attributes.checked;
			     parentNode.appendChild(treeNode);
			   }
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
			id : nodeData.mat_menu_id,
			text : nodeData.menu_name,// 显示内容									
			leaf : false,								
			singleClickExpand:true,
			xtype : 'checkbox',  
            checked : false, 
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

function checkTreeNode(childs,node,parentNode){
   var  index=0;
   for(var e=1;e<childs.length;e++){
		    var treeNode=childs[e];
		    if(treeNode.id==node.id){
		      break;
		    }else{
		      index++;
		    }
		if(index==childs.length-1){
		 node.attributes.checked=parentNode.attributes.checked;
		 parentNode.appendChild(node);
		}
		  
	 }
	
}
function testSubmit(rctTree){
  var selNodes = rctTree.getChecked();
  Ext.each(selNodes, function(node){
  alert(node.text);})
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
	<tr>
		<td align="left">
			<!--<input type="button" value="submit" onClick="testSubmit(rctTree);">-->
		</td>
	</tr>
</table>



</body>
