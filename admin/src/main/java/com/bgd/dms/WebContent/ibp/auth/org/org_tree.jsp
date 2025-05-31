<%@ page language="java" pageEncoding="GBK"%>

<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" >
<title></title>
<!-- ext -->
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css" media="screen" />
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 
<script type="text/javascript" src="<%=extPath %>/tree.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";

/**公共变量定义*/
var rootMenuId = "1,C6000000000001,C105,C6000000000001,0200100005000000002";
var rootMenuName = "东方地球物理勘探有限公司";

var treeDivId = "menuTree";
var loadingIcon = extPath+"/resources/images/default/shared/blue-loading.gif";
var blank_image_url = extPath+"/resources/images/default/s.gif";

jcdpTreeCfg.clickEvent=true;

var treeCfg = {
	region : 'west',// 设定显示区域为东边,停靠在容器左边
	split : true,// 出现拖动条
	bodyStyle:"padding:2px",
	collapseMode : 'mini',// 拖动条显示类型为mini,可出现拖动条中间的尖头
	//width : 300,// 初始宽度
	minSize : 210,// 拖动最小宽度
	maxSize : 300,// 拖动最大宽度
	collapsible : true,// 允许隐藏
	title : "组织机构树",// 显示标题为树
	lines : true,// 出现节点间虚线
	autoScroll : true,// 自动出现滚动条
	frame : false,
	enableDD:true	
};

function clickNode(node){
	editNode(node);
}

/**
	定义右键菜单
*/
function setRightMenu()
{
	var menuItems = [
		{
			text:"新增机构",
			handler:function(){
				addNode(selectedNode);
			}
		}
		,"-"
		,{
			text:"新增队伍",
			handler:function(){
				addTeam(selectedNode);
			}
		}
		,"-"
		,{
			text:"编辑",
			handler:function(){
				editNode(selectedNode);
			}
		}
		,"-"
		,{
			text:"删除",
			handler:function(){
				deleteNode(selectedNode);
			}
		}
	];
	
	rightMenu = new Ext.menu.Menu({
		items:menuItems
	});
}

/**
删除菜单
*/
function deleteNode(selectedNode)
{
	var info = selectedNode.id.split(",");
	if (selectedNode.id == null) {
		alert("请先选中一个节点!");
		return;
	}
	
	if (selectedNode.id == rootMenuId) {
		alert("根节点不能被删除!");
		return;
	}	
	
	if (!window.confirm("确认要删除["+selectedNode.text+"]及其下级节点吗?")) {
			return;
	}
	
	
	/*var submitStr = "org_id="+selectedNode.id;
	var ret = syncRequest('post',"<%=contextPath%>/ibp/auth/deleteOrg.srq",submitStr);
	if(ret.returnCode!='0'){
		alert(ret.returnMsg);
		return;
	}*/
	var sql = "update comm_org_information set bsflag='1' where org_id ='{id}';"
		+ "update comm_org_subjection set bsflag='1' where org_id ='{id}';"
	var path = "<%=contextPath%>/rad/asyncUpdateEntitiesBySql.srq";
	var params = "sql="+sql;
	params += "&ids="+info[1];
	
	var retObject = syncRequest('Post',path,params);
	if(retObject.returnCode!=0){
		alert(retObject.returnMsg);
	}else{
	
		var selectedParentNode = selectedNode.parentNode;
	
		selectedNode.remove();
	
		// 如果没有孩子，设置图标样式
		if(!selectedParentNode.firstChild){
			selectedParentNode.ui.addClass("x-tree-node-collapsed");
		}
	}
}

var needReload;
/**
	新增菜单
*/
function addNode(selectedNode)
{

	if (selectedNode.id == null) {
		alert("请先选中一个节点!");
		return;
	}
	needReload=selectedNode;
	parent.menuFrame.location.href = "orgA7.upmd?pagerAction=edit2Add&lineRange=2&noCloseButton=true&parentId="+selectedNode.id;	
}
/**
新增队伍
*/
function addTeam(selectedNode)
{

	if (selectedNode.id == null) {
		alert("请先选中一个节点!");
		return;
	}
	needReload=selectedNode;
	parent.menuFrame.location.href = "teamA7.upmd?pagerAction=edit2Add&lineRange=2&noCloseButton=true&parentId="+selectedNode.id;	
}

/**
	修改菜单
*/
function editNode(selectedNode)
{
	var info = selectedNode.id.split(",");
	if (selectedNode.id == null) {
		alert("请先选中一个节点!");
		return;
	}
	needReload=selectedNode;
	var orgLevel=info[4];
	if(orgLevel=='0200100005000000008'){
		parent.menuFrame.location.href = "teamA7.upmd?pagerAction=edit2Edit&lineRange=2&noCloseButton=true&id="+info[1]+"&parentId="+((selectedNode.id!=rootMenuId)?(selectedNode.parentNode.id):'0');		
	}else{
		parent.menuFrame.location.href = "orgA7.upmd?pagerAction=edit2Edit&lineRange=2&noCloseButton=true&id="+info[1]+"&parentId="+((selectedNode.id!=rootMenuId)?(selectedNode.parentNode.id):'0');
	}

}

/**
	移动节点
*/
function moveMenu(tree,node,oldParent,newParent,index){
	/*var actionUrl = "<%=contextPath%>"+jcdpTreeCfg.moveNodeAction;
	var submitStr = "tableName=p_auth_org&pkName=org_id&fkName=parent_id&orderName=order_num&leafFlagName=is_leaf";
	submitStr += "&pkValue="+node.id+"&index="+index+"&oldParentId="+oldParent.id+"&newParentId="+newParent.id;
	var ret = syncRequest('post',actionUrl,submitStr);
	if(ret.returnCode!='0'){
		alert(ret.returnMsg);
		return;
	}*/
}


/**
	获取parentNode的子节点
*/
function getSubNodes(parentNode) {
	if(parentNode.firstChild.text!='loading') return;
	var info = parentNode.id.split(',');
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			//,case (select count(os3.org_id) from comm_org_subjection os3 where os3.father_org_id=os.org_subjection_id and os3.bsflag='0') when 0 then '1' else '0' end as is_leaf
			querySql:"Select (case os.code_afford_org_id when os.org_id then '1' else '0' end) as afford_if, oi.org_abbreviation,os.org_subjection_id,oi.org_id,os.code_afford_org_id,oi.org_level FROM comm_org_information oi,comm_org_subjection os WHERE oi.org_id=os.org_id and oi.bsflag='0' and os.bsflag='0' and os.father_org_id='"+info[2]+"' ORDER  BY coding_show_id"
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;
			addSubNodes(parentNode,nodes);
		},
		failure : function(){// 失败
							}			
	});//eof Ext.Ajax.request
}


function addSubNodes(parentNode,nodes){

	if(nodes.length>0){
		var info = parentNode.id.split(',');
	
		var parentNode1;
		var parentNode2;
		
		if(info[0]=='1'){//
			parentNode1 = new Ext.tree.AsyncTreeNode({
				id : 'jiguan'+info[1],
				text : '机关部室',// 显示内容									
				leaf : false,								
				singleClickExpand:true,
				children: [{// 添加loading子节点
					text : 'loading',
					icon : loadingIcon,
					leaf : false
				}]
			});	
			parentNode2 = new Ext.tree.AsyncTreeNode({
				id : 'zhishu'+info[1],
				text : '直属单位',// 显示内容									
				leaf : false,								
				singleClickExpand:true,
				children: [{// 添加loading子节点
					text : 'loading',
					icon : loadingIcon,
					leaf : false
				}]
			});	
			parentNode.appendChild(parentNode1);
			parentNode1.expand();
			parentNode.appendChild(parentNode2);
			parentNode2.expand();
			
			for (var i = 0; i < nodes.length; i++) {
				
				var treeNode = getTreeNode(nodes[i]);
				appendEvent(treeNode);
				if(nodes[i].afford_if=='1'){
					parentNode2.appendChild(treeNode);//alert("添加一个直属单位");
				}else{
					parentNode1.appendChild(treeNode);//alert("添加一个机关单位");
				}
				//treeNode.ensureVisible();
			}
			parentNode1.firstChild.remove();// 删除当前节点第一个孩子节点(loading节点)
			parentNode1.ui.addClass("x-tree-node-collapsed");//设置样式为文件夹，防止没有子机构而改变样式
			parentNode2.firstChild.remove();// 删除当前节点第一个孩子节点(loading节点)
			parentNode2.ui.addClass("x-tree-node-collapsed");//设置样式为文件夹，防止没有子机构而改变样式
			
		}else{
			for (var i = 0; i < nodes.length; i++) {
				var treeNode = getTreeNode(nodes[i]);
				
				appendEvent(treeNode);
				parentNode.appendChild(treeNode);
			}
		}
	}
	parentNode.firstChild.remove();//移除loading节点
	parentNode.ui.addClass("x-tree-node-collapsed");//设置样式为文件夹，防止没有子机构而改变样式
}


/**
	根据服务器查询到的nodeData构造ext树节点
*/
function getTreeNode(nodeData){
	var treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.afford_if+','+nodeData.org_id+','+nodeData.org_subjection_id+','+nodeData.code_afford_org_id+','+nodeData.org_level,
			text : nodeData.org_abbreviation,// 显示内容									
			leaf : false,								
			singleClickExpand:true,
			children: [{// 添加loading子节点
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
	});	
	
	return treeNode;
}


//重新加载选中节点
function reloadNeed(){
	needReload.reload();
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