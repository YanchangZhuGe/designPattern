<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link href="<%= contextPath %>/styles/table.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 
<script type="text/javascript" src="<%=extPath %>/tree.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script language="javascript" type="text/javascript"> 
var extPath = "<%=contextPath%>/js/extjs";
cruConfig.contextPath = "<%=contextPath%>";
 
/**公共变量定义*/
var rootMenuId = "INIT_AUTH_MENU_012345678900000";
var rootMenuName = "根节点";
 
var treeDivId = "menuTree";
var loadingIcon = extPath+"/resources/images/default/shared/blue-loading.gif";
var blank_image_url = extPath+"/resources/images/default/s.gif";
var default_image_url = "<%=contextPath%>/images/images/tree_15.png";
 
var treeCfg = {
	region : 'west',// 设定显示区域为东边,停靠在容器左边
	split : true,// 出现拖动条
	bodyStyle:"padding:2px",
	collapseMode : 'mini',// 拖动条显示类型为mini,可出现拖动条中间的尖头
	width : 300,// 初始宽度
	minSize : 250,// 拖动最小宽度
	maxSize : 300,// 拖动最大宽度
	collapsible : true,// 允许隐藏
	title : "模块树",// 显示标题为树
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

}
 
/**
	删除菜单
*/
function deleteNode(selectedNode)
{

}
 
/**
	新增菜单
*/
function addNode(selectedNode)
{

}
 
 
/**
	修改菜单
*/
function editNode(selectedNode)
{
 
}
 
/**
	移动菜单节点
*/
function moveMenu(tree,node,oldParent,newParent,index){

}
var selectedNode = "";
 
var selectedModuleId = ""; 
 
function clickNode(node){
	selectedNode=node;
	var ctt = top.frames['list'];
	ctt.frames[1].location.reload();
	selectedModuleId = getClickNode();
} 

function getClickNode(){

	return selectedNode;
} 

function getNodeId(){
	if(selectedNode != ""&&selectedNode.id!=rootMenuId){
		var nodeID = selectedNode.id;
		return nodeID;
	}else{
		return;
	}

}

function getNodeText(){
	if(selectedNode != ""){
		var nodeText = selectedNode.text;
		return nodeText;
	}else{
		return;
	}

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
			querySql:"Select menu_id,menu_c_name FROM P_AUTH_MENU_DMS WHERE parent_menu_id='"+parentNode.id+"' and menu_c_name in ('经营管理','物资管理','风险管理','质量管理','市场信息','生产管理','人力资源','设备管理','HSE管理','技术管理','文档管理') ORDER BY order_num desc"
		},
		method : 'Post',
		success : function(resp){
		
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;
			var startIndex = 0;
			if(parentNode.id=="INIT_AUTH_MENU_012345678900000") 
			{	
				startIndex=0;
				for (var i = startIndex; i < nodes.length; i++) {
					var treeNode = getTreeNode(nodes[i]);
					appendEvent(treeNode);
				
	
				   if(parentNode.childNodes.length>1){
				      checkTreeNode(parentNode.childNodes,treeNode,parentNode);
				      //parentNode.childNodes[0].firstChild.remove();
				   }else{
				     treeNode.attributes.checked=parentNode.attributes.checked;
				     parentNode.appendChild(treeNode);
				     //treeNode.firstChild.remove();
				   } 
				   //alert("The firstChild is:"+parentNode.firstChild.text);
				}
			parentNode.firstChild.remove();// 删除当前节点第一个孩子节点(loading节点)	
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
			id : nodeData.menu_id,
			text : nodeData.menu_c_name,// 显示内容		
			icon : default_image_url,
			leaf : true,								
			singleClickExpand:false,
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
</html>
