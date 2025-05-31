var rightMenu = null;
var selectedNode;
var jcdpTreeCfg={
	moveNodeAction:'/tcg/moveTreeNodePosition.srq',
	clickEvent:false,
	dbClickEvent:false,
	moveEvent:true,
	rightClickEvent:true
}

var rctTree;

Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = blank_image_url;
	var rootNode = new Ext.tree.AsyncTreeNode({
				id:rootMenuId,
				text:rootMenuName,
				singleClickExpand:true,
				children : [{// 子节点
					text : 'loading',// 显示文字为loading
					icon : loadingIcon,// 使用图标为loading
					leaf : true					
				}]
	});
	var treeLoader = new Ext.tree.TreeLoader();// 指定一个空的TreeLoader
	
	rctTree = new Ext.tree.TreePanel({// 声明一个TreePanel显示tree
		id : 'tree',// id为tree
		region : treeCfg.region,// 设定显示区域为东边,停靠在容器左边
		split : treeCfg.split,// 出现拖动条
		bodyStyle:treeCfg.bodyStyle,
		collapseMode : treeCfg.collapseMode,// 拖动条显示类型为mini,可出现拖动条中间的尖头
		width : treeCfg.width,// 初始宽度
		minSize : treeCfg.minSize,// 拖动最小宽度
		maxSize : treeCfg.maxSize,// 拖动最大宽度
		collapsible : treeCfg.collapsible,// 允许隐藏
		title : treeCfg.title,// 显示标题为树
		lines : treeCfg.lines,// 出现节点间虚线
		autoScroll : treeCfg.autoScroll,// 自动出现滚动条
		frame : treeCfg.frame,
		enableDD:false,
		
		loader : treeLoader,// 指定数据载入的loader对象,现在定义为空	
		root : rootNode
	});

	if(jcdpTreeCfg.rightClickEvent)setRightMenu();
	
	rctTree.render(treeDivId); // 渲染到层
	
	appendEvent(rootNode);
	rctTree.getRootNode().toggle();	
});


/**
	给节点增加响应事件
*/
function appendEvent(treeNode){
	treeNode.on('expand', getSubNodes);// 定义当前节点展开时调用getSubNodes,再次异步读取子节点
	
	
	//添加右键菜单
	if(rightMenu!=null){
		treeNode.on("contextmenu",showMenu);	
	}
	
	//当节点移动时触发事件
	//if(jcdpTreeCfg.moveEvent)treeNode.on("move",moveMenu);
	
	if(jcdpTreeCfg.clickEvent) treeNode.on("click",clickNode);
	if(jcdpTreeCfg.dbClickEvent) treeNode.on("dblclick",dbClickNode);
	
}	


/**
  显示菜单
*/
function showMenu(node,e)
{
	selectedNode = node;
	node.select();
	// 重新设置右键菜单
	if(jcdpTreeCfg.rightClickEvent)setRightMenu();
	
	rightMenu.showAt(e.getPoint());
/*	if(selectedNode.isLeaf())
	{
		dirMenu.showAt(e.getPoint());
	}
	else
	{
		dirMenu.showAt(e.getPoint());
	}*/
}


