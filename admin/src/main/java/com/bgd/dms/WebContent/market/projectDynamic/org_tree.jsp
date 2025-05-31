<%@ page language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = request.getParameter("orgSubId");
	if(orgSubId==null || orgSubId.equals("")) orgSubId = user.getSubOrgIDofAffordOrg();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";

/**公共变量定义*/
//"INIT_AUTH_ORG_012345678900000";

cruConfig.contextPath = "<%=contextPath%>";
var rootMenuName = "东方公司"; 
var rootMenuId = "init_data_001";
</script>

<link href="<%= contextPath %>/styles/table.css" rel="stylesheet" type="text/css" />
<!-- ext -->
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 
<script type="text/javascript" src="<%=extPath %>/tree.js"></script> 

<script language="javascript" type="text/javascript">
var treeDivId = "menuTree";
var loadingIcon = extPath+"/resources/images/default/shared/blue-loading.gif";
var blank_image_url = extPath+"/resources/images/default/s.gif";

jcdpTreeCfg.rightClickEvent = false;
jcdpTreeCfg.moveEvent = false;
jcdpTreeCfg.dbClickEvent = true;

var treeCfg = {
	region : 'west',// 设定显示区域为东边,停靠在容器左边
	split : true,// 出现拖动条
	bodyStyle:"padding:2px",
	collapseMode : 'mini',// 拖动条显示类型为mini,可出现拖动条中间的尖头
	width : 530,// 初始宽度
	minSize : 210,// 拖动最小宽度
	maxSize : 300,// 拖动最大宽度
	collapsible : true,// 允许隐藏
	title : "选择组织机构",// 显示标题为树
	lines : true,// 出现节点间虚线
	autoScroll : true,// 自动出现滚动条
	frame : false,
	enableDD:true	
};

function dbClickNode(node){
	debugger;
	var orgName = node.text;
	//var obj = window.dialogArguments;
	//obj.fkValue = node.id.split(",")[1];

	//obj.value = node.text;
	window.parent.opener.getValue(orgName);
	window.close();
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
			//case (select count(os3.org_id) from comm_org_subjection os3 where os3.father_org_id=os.org_subjection_id and os3.bsflag='0') when 0 then '1' else '0' end as is_leaf
			querySql:"select org_id,org_name from sm_org where bsflag='0' and parent_id='"+info[0]+"' order by order_no"
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
		var nodes = nodes;

		var parentNode1;
		var parentNode2;
		
/*		if(info[0]=='1'){//
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
				
			}
			parentNode1.firstChild.remove();// 删除当前节点第一个孩子节点(loading节点)
			parentNode1.ui.addClass("x-tree-node-collapsed");//设置样式为文件夹，防止没有子机构而改变样式
			parentNode2.firstChild.remove();// 删除当前节点第一个孩子节点(loading节点)
			parentNode2.ui.addClass("x-tree-node-collapsed");//设置样式为文件夹，防止没有子机构而改变样式
			
		}*/
		
			for (var i = 0; i < nodes.length; i++) {
				
				var treeNode = getTreeNode(nodes[i]);
				
				appendEvent(treeNode);
				parentNode.appendChild(treeNode);
			
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
	var nodeData = nodeData;
	clickNode(nodeData)
	return treeNode;
}


</script>      

</head>
<body style="overflow-y: scroll;">
<table border="0" cellpadding="0" cellspacing="0"  id="FilterLayer" width="100%">
	<tr>
		<td align="left">
			<div id="menuTree" style="width:100%;height:100%;overflow:auto;"></div>
		</td>
	</tr>
</table>



</body>