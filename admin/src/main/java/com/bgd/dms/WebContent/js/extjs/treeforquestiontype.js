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
				children : [{// �ӽڵ�
					text : 'loading',// ��ʾ����Ϊloading
					icon : loadingIcon,// ʹ��ͼ��Ϊloading
					leaf : true					
				}]
	});
	var treeLoader = new Ext.tree.TreeLoader();// ָ��һ���յ�TreeLoader
	
	rctTree = new Ext.tree.TreePanel({// ����һ��TreePanel��ʾtree
		id : 'tree',// idΪtree
		region : treeCfg.region,// �趨��ʾ����Ϊ����,ͣ�����������
		split : treeCfg.split,// �����϶���
		bodyStyle:treeCfg.bodyStyle,
		collapseMode : treeCfg.collapseMode,// �϶�����ʾ����Ϊmini,�ɳ����϶����м�ļ�ͷ
		width : treeCfg.width,// ��ʼ���
		minSize : treeCfg.minSize,// �϶���С���
		maxSize : treeCfg.maxSize,// �϶������
		collapsible : treeCfg.collapsible,// ��������
		title : treeCfg.title,// ��ʾ����Ϊ��
		lines : treeCfg.lines,// ���ֽڵ������
		autoScroll : treeCfg.autoScroll,// �Զ����ֹ�����
		frame : treeCfg.frame,
		enableDD:false,
		
		loader : treeLoader,// ָ�����������loader����,���ڶ���Ϊ��	
		root : rootNode
	});

	if(jcdpTreeCfg.rightClickEvent)setRightMenu();
	
	rctTree.render(treeDivId); // ��Ⱦ����
	
	appendEvent(rootNode);
	rctTree.getRootNode().toggle();	
});


/**
	���ڵ�������Ӧ�¼�
*/
function appendEvent(treeNode){
	treeNode.on('expand', getSubNodes);// ���嵱ǰ�ڵ�չ��ʱ����getSubNodes,�ٴ��첽��ȡ�ӽڵ�
	
	
	//����Ҽ��˵�
	if(rightMenu!=null){
		treeNode.on("contextmenu",showMenu);	
	}
	
	//���ڵ��ƶ�ʱ�����¼�
	//if(jcdpTreeCfg.moveEvent)treeNode.on("move",moveMenu);
	
	if(jcdpTreeCfg.clickEvent) treeNode.on("click",clickNode);
	if(jcdpTreeCfg.dbClickEvent) treeNode.on("dblclick",dbClickNode);
	
}	


/**
  ��ʾ�˵�
*/
function showMenu(node,e)
{
	selectedNode = node;
	node.select();
	// ���������Ҽ��˵�
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


