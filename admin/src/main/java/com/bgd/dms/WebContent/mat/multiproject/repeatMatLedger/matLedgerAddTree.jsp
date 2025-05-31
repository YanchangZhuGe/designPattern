<%@ page language="java" pageEncoding="GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = request.getParameter("orgId");
	if(orgId==null || orgId.equals("")) orgId = user.getCodeAffordOrgID();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title></title>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 

<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";

/**公共变量定义*/
var rootMenuId = "<%=orgId%>";
var rootMenuName = "";
cruConfig.contextPath = "<%=contextPath%>";
var querySql = "Select oi.org_id,oi.org_abbreviation,os.org_subjection_id FROM comm_org_information oi join comm_org_subjection os on oi.org_id=os.org_id WHERE oi.bsflag='0' and oi.org_id='"+rootMenuId+"'";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
rootMenuName = "物资分类"; 
rootMenuId += ",C105"; 

var rctTree;
var rightMenu = null;
var selectedNode;

var treeDivId = "menuTree";
var loadingIcon = extPath+"/resources/images/default/shared/blue-loading.gif";
var blank_image_url = extPath+"/resources/images/default/s.gif";

var treeCfg = {
	region : 'west',// 设定显示区域为东边,停靠在容器左边
	split : true,// 出现拖动条
	bodyStyle:"padding:2px",
	collapseMode : 'mini',// 拖动条显示类型为mini,可出现拖动条中间的尖头
	width : 500,// 初始宽度
	minSize : 210,// 拖动最小宽度
	maxSize : 300,// 拖动最大宽度
	collapsible : true,// 允许隐藏
	title : "物资分类",// 显示标题为树
	lines : true,// 出现节点间虚线
	autoScroll : true,// 自动出现滚动条
	frame : false,
	enableDD:true	
};
var jcdpTreeCfg={
	moveNodeAction:'/tcg/moveTreeNodePosition.srq',
	clickEvent:true,
	dbClickEvent:false,
	moveEvent:false,
	rightClickEvent:false,
	checkchangeEvent:true
}

Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = blank_image_url;
	var rootNode = new Ext.tree.AsyncTreeNode({
				id:rootMenuId,
				text:rootMenuName,
				singleClickExpand:false,
				checked:false,
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
		border : treeCfg.border==undefined?true:treeCfg.border,
		enableDD:treeCfg.enableDD,
		tbar : treeCfg.tbar,
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
	if(jcdpTreeCfg.moveEvent)treeNode.on("move",moveMenu);
	
	if(jcdpTreeCfg.clickEvent) treeNode.on("click",clickNode);
	if(jcdpTreeCfg.dbClickEvent) treeNode.on("dblclick",dbClickNode);

	// 复选框事件
	if(jcdpTreeCfg.checkchangeEvent){
		treeNode.on("checkchange",checkchangeNode);
		treeNode.on("checkchange",checkParentNode);
	}
}	

/**
单击
*/
function clickNode(node){
	selectedNode=node;
}

/**
	获取parentNode的子节点
*/
function getSubNodes(parentNode) {
	if(parentNode.firstChild.text!='loading') return;
		var ids = parentNode.id.split(",");
		var id = "";
		if(ids.length>1){
			id=ids[1];
			}
		else{
			id = ids[0];
				}
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:"select t.*,length(t.coding_code_id) as is_leaf from GMS_MAT_CODING_CODE t where t.parent_code = '"+id+"'"
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;

			if(nodes!=null && nodes.length>0){
				for (var i = 0; i < nodes.length; i++) {
					nodes[i].checked = parentNode.attributes.checked;
					
					var treeNode = getTreeNode(nodes[i]);
					
					appendEvent(treeNode);
					//treeNode.on("checkchange",checkchangeNode);
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
	var treeNode;
	
	if(nodeData.is_leaf=="8"){//叶子节点
		treeNode = new Ext.tree.TreeNode({
			id : nodeData.coding_code_id,
			text : nodeData.code_name,// 显示内容									
			leaf : true,								
			singleClickExpand: false,
			checked : nodeData.checked,
			children: [{// 添加loading子节点
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
		});	
	}else{
		treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.coding_code_id,
			text : nodeData.code_name,// 显示内容									
			leaf : false,								
			singleClickExpand:true,
			checked : nodeData.checked,
			children: [{// 添加loading子节点
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
		});	
	}
	
	return treeNode;
}

// scope=1获取所有选中的节点，scope=0获取顶级选中的节点
function getCheckedNode(scope) {   
    var nodes = rctTree.getChecked();
    
    var checkLeafIds = "";// 存放选中的叶子节点的id
    var checkLeafTexts = "";// 存放选中的叶子节点的text
    
    var checkNonLeafIds = "";// 存放选中的非叶子节点的id
    var checkNonLeafTexts = "";// 存放选中的非叶子节点的text
    
    for (var i = 0; i < nodes.length; i++) {   
        var node = nodes[i];
        if(scope=="0"){
			var parentNode =  node.parentNode;
			if(parentNode!=null && parentNode.attributes.checked){
            	continue;
			}
        }
        
        if(nodes[i].isLeaf()){
        	checkLeafIds += "," + nodes[i].id.substr(0,14);
        	checkLeafTexts += "," + nodes[i].text;
        }else{
        	checkNonLeafIds += "," + nodes[i].id.substr(0,14);
        	checkNonLeafTexts += "," + nodes[i].text;
        }
    } 
    
    checkLeafIds = checkLeafIds=="" ? "" : checkLeafIds.substr(1);
    checkLeafTexts = checkLeafTexts=="" ? "" : checkLeafTexts.substr(1);

    checkNonLeafIds = checkNonLeafIds=="" ? "" : checkNonLeafIds.substr(1);
    checkNonLeafTexts = checkNonLeafTexts=="" ? "" : checkNonLeafTexts.substr(1);

	var checkAllIds = checkLeafIds +","+ checkNonLeafIds;
	parent.menuFrame.location = "<%=contextPath%>/mat/multiproject/repeatMatLedger/matAddItemList.jsp?codeId="+checkAllIds
}   

function checkchangeNode(node, checked){
	//node.expand();
	node.attributes.checked = checked;
	// 设置子节点的选中状态
	node.eachChild(function(child) {   
		child.ui.toggleCheck(checked);   
		child.attributes.checked = checked;   
	});

}

function checkParentNode(node, checked){
	
	// 设置父节点的选中状态
	var parentNode = node.parentNode;
	if(parentNode==null)return;
	
	// 取消父节点监听checkchange事件，防止向下传递
	parentNode.removeListener('checkchange',checkchangeNode);
	
	if(!checked){ // 未选中，设置父节点为未选中
		parentNode.ui.toggleCheck(false);   
		parentNode.attributes.checked = false;
	}else{ // 已选中，检查所有兄弟节点，如果都是选中，设置父节点为选中
		var siblings = parentNode.childNodes;
		var parentChecked = true;
		for(var i=0;i<siblings.length;i++){
			if(!siblings[i].attributes.checked){
				parentChecked = false;
				break;
			}
		}
		if(parentChecked){
			parentNode.ui.toggleCheck(true);   
			parentNode.attributes.checked=true;
		}
	}
	// 设置父节点监听checkchange事件
	parentNode.on("checkchange",checkchangeNode);
}
</script>      

</head>
<body>

<table border="0" cellpadding="0" cellspacing="0"  id="FilterLayer" width="100%">
	<tr>
		<td align="left">
			<input type="button" value="确定" onclick="getCheckedNode('0')" class="iButton2"/>
		</td>
	</tr>
	<tr>
		<td align="left">
			<div id="menuTree" style="width:100%;height:100%;overflow:auto;">
			</div>
		</td>
	</tr>
</table>



</body>