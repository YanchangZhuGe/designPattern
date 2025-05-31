<%@ page language="java" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	String codingSortId=request.getParameter("codingSortId");
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<link href="<%= contextPath %>/styles/table.css" rel="stylesheet" type="text/css" />
<!-- ext -->
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 
<script type="text/javascript" src="<%=extPath %>/tree.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";

/**公共变量定义*/
var rootMenuId = "<%=codingSortId%>";
var rootMenuName = decodeURI("<%=request.getParameter("codingSortName")%>");

var treeDivId = "menuTree";
var loadingIcon = extPath+"/resources/images/default/shared/blue-loading.gif";
var blank_image_url = extPath+"/resources/images/default/s.gif";

var treeCfg = {
	region : 'west',// 设定显示区域为东边,停靠在容器左边
	split : true,// 出现拖动条
	bodyStyle:"padding:2px",
	collapseMode : 'mini',// 拖动条显示类型为mini,可出现拖动条中间的尖头
	width : "100%",// 初始宽度
	minSize : 210,// 拖动最小宽度
	maxSize : 300,// 拖动最大宽度
	collapsible : false,// 允许隐藏
	title : "编码树",// 显示标题为树
	lines : true,// 出现节点间虚线
	autoScroll : true,// 自动出现滚动条
	frame : false,
	enableDD:false	
};

/**
	定义右键菜单
*/
function setRightMenu()
{
	var menuItems = [];
	
	//非根节点
	if(selectedNode && selectedNode.id != rootMenuId){
		menuItems = [
			{
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
	}
		
	if(selectedNode && !selectedNode.isLeaf()){
		if(menuItems.length>0) menuItems.unshift("-");
		
		menuItems.unshift(
			{
				text:"新增",
				handler:function(){
					addNode(selectedNode);
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
	var sql = "update comm_coding_sort_detail set bsflag='1' where coding_code_id ='{id}';"
		+ "update comm_coding_sort_detail set bsflag='1' where coding_code_id in (select coding_code_id from comm_coding_sort_detail start with superior_code_id='{id}' connect by prior coding_code_id = superior_code_id);"
	var path = "<%=contextPath%>/rad/asyncUpdateEntitiesBySql.srq";
	var params = "sql="+sql;
	params += "&ids="+selectedNode.id;
	
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

var reloadNode;
/**
	新增菜单
*/
function addNode(selectedNode)
{
	//reloadSelectedNode();
	if (selectedNode.id == null) {
		alert("请先选中一个节点!");
		return;
	}
	reloadNode = selectedNode;
	if(selectedNode.id == rootMenuId){
		popWindow("<%=contextPath%>/common/code/detailInsert.jsp?pagerAction=edit2Add&lineRange=1&superiorCodeId=0&superiorCodeName=" + rootMenuName + "&codingSortId=<%=codingSortId%>");
	}else{
		popWindow("<%=contextPath%>/common/code/detailInsert.jsp?pagerAction=edit2Add&lineRange=1&superiorCodeId="+selectedNode.id+"&superiorCodeName="+selectedNode.text+"&codingSortId=<%=codingSortId%>");	
	}	
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
	reloadNode = selectedNode.parentNode;
	popWindow("<%=contextPath%>/common/code/detailEdit.jsp?pagerAction=edit2Edit&lineRange=1&id="+selectedNode.id);	

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
			pageSize:"1000",
			querySql:"SELECT * FROM COMM_CODING_SORT_DETAIL WHERE CODING_SORT_ID='<%=codingSortId%>' and " + parentCondition + " and bsflag='0' ORDER  BY  CODING_SHOW_ID desc"
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
			// 如果没有孩子，设置图标样式
			if(!parentNode.firstChild){
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
			id : nodeData.coding_code_id,
			text : nodeData.coding_name,// 显示内容									
			leaf : false,								
			singleClickExpand:true,
			children: [{// 添加loading子节点
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
	});	
	//alert(nodeData.end_if)
	if(nodeData.end_if=="1"){//叶子节点
		treeNode.leaf = true;
		treeNode.singleClickExpand = false;
	}
	
	return treeNode;
}

function refreshData(){
	reloadNode.reload();
}

</script>      
</head>
<body>
<table border="0" cellpadding="0" cellspacing="0"  id="FilterLayer" width="100%">
	<tr>
		<td align="left">
			<div id="menuTree" style="width:100%;height:100%;overflow:auto;"></div>
			<!-- a href="javascript:window.parent.parent.AddWin(new Date().getTime(),'baidu','http://www.baidu.com');" >openwindow</a> -->
		</td>
	</tr>
</table>



</body>