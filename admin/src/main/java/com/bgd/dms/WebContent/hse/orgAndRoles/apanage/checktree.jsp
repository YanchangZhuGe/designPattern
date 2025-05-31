<%@ page language="java" pageEncoding="GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = request.getParameter("orgId");
	if(orgId==null || orgId.equals("")) orgId = user.getOrgSubjectionId();
	
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
var apanage_flag = "";
debugger;
cruConfig.contextPath = "<%=contextPath%>";
var querySql = "select t.org_sub_id,os.org_id,oi.org_abbreviation,t.apanage_flag from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' start with t.org_sub_id = '"+rootMenuId+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
var datas = queryOrgRet.datas;
if(datas.length>1){
	rootMenuName = queryOrgRet.datas[1].org_abbreviation; 
	rootMenuId  = queryOrgRet.datas[1].org_sub_id;
	apanage_flag = queryOrgRet.datas[1].apanage_flag;
}else if(datas.length=="1"){
	rootMenuName = queryOrgRet.datas[0].org_abbreviation; 
	rootMenuId  = queryOrgRet.datas[0].org_sub_id; 
	apanage_flag = queryOrgRet.datas[0].apanage_flag;
}

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
	title : "选择",// 显示标题为树
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
	if(apanage_flag=="1"){
		rootNode.attributes.checked = true ;
	}
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
	//	treeNode.on("checkchange",checkParentNode);
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
	debugger;
//	alert(parentNode.id.substring(15));
	if(parentNode.firstChild.text!='loading') return;
		
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:"select ho.org_sub_id,ho.father_org_sub_id,ho.apanage_flag,os.org_id,oi.org_abbreviation, case when (select father_org_sub_id from bgp_hse_org where org_sub_id='"+parentNode.id+"') in (select org_sub_id from bgp_hse_org where father_org_sub_id='C105') then '1' else '' end is_leaf  from bgp_hse_org ho left join comm_org_subjection os on ho.org_sub_id=os.org_subjection_id and os.bsflag='0' left join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where ho.father_org_sub_id='"+parentNode.id+"' "
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;

			if(nodes!=null && nodes.length>0){
				for (var i = 0; i < nodes.length; i++) {
					nodes[i].checked = false;
					
					var treeNode = getTreeNode(nodes[i]);
					appendEvent(treeNode);
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
	if(nodeData.is_leaf=="1"){//叶子节点
		treeNode = new Ext.tree.TreeNode({
			id : nodeData.org_sub_id,
			text : nodeData.org_abbreviation,// 显示内容									
			leaf : true,
			singleClickExpand: false,
			checked : nodeData.checked,
			children: [{// 添加loading子节点
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
		});
	if(nodeData.apanage_flag=="1"){
		treeNode.attributes.checked = true;
	}
//	if(nodeData.father_org_sub_id=="C105080"){
//		treeNode.attributes.checked = "disabled";
//	}
	}else{
		treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.org_sub_id,
			text : nodeData.org_abbreviation,// 显示内容									
			leaf : false,
			expanded: true,
			singleClickExpand:true,
			checked : nodeData.checked,
			children: [{// 添加loading子节点
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
		});	
		if(nodeData.apanage_flag=="1"){
			treeNode.attributes.checked = true;
		}
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

	alert("选择的叶子节点：" + checkLeafTexts);
	alert("选择的非叶子节点：" + checkNonLeafTexts);
}  


function getCheckedNode123() {   
    var nodes = rctTree.getChecked();
    
    var checkIds = ""
    var checkTexts = "";// 存放选中的叶子节点的text
    
    for (var i = 0; i < nodes.length; i++) {   
        var node = nodes[i];
        checkIds += "," + nodes[i].id;
        checkTexts += "," + nodes[i].text;
    } 
    
    checkIds = checkIds=="" ? "" : checkIds.substr(1);
    checkTexts = checkTexts=="" ? "" : checkTexts.substr(1);
    if(checkIds==""){
    	alert("请选择单位!");
    	return;
    }
    jcdpCallService("HseOperationSrv", "setApanageFlag", "ids="+checkIds+"&rootMenuId="+rootMenuId);
    window.close();
}  

function checkchangeNode(node, checked){
	//node.expand();
	node.attributes.checked = checked;
	// 设置子节点的选中状态
//	node.eachChild(function(child) {   
//		child.ui.toggleCheck(checked);   
//		child.attributes.checked = checked;   
//	});

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
		<td align="left" style="padding-left:400px;padding-top:5px;padding-bottom:5px;">
			<!-- <input type="button" value="获得所有选中节点" onclick="getCheckedNode('1')" class="iButton2"/>
			<input type="button" value="获得顶级选中节点" onclick="getCheckedNode('0')" class="iButton2"/> -->
			<input type="button" value="保存" onclick="getCheckedNode123()" class="iButton2"/>
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