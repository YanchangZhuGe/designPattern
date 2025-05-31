<%@ page language="java" pageEncoding="GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	UserToken user = OMSMVCUtil.getUserToken(request);
%>
<html>
<head><meta http-equiv="X-UA-Compatible" content="IE=9; IE=8; IE=7; IE=EDGE"> 
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title></title>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<link href="<%= contextPath %>/styles/table.css" rel="stylesheet" type="text/css" />
<!-- ext -->
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 
<script type="text/javascript" src="<%=extPath %>/tree.js"></script> 
<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";
var rootMenuId = "";
var rootMenuName = "";
/**公共变量定义*/
cruConfig.contextPath = "<%=contextPath%>";
var querySql = "select t.indexconf_id as id ,t.index_name as name from dms_assess_indexconf t where t.bsflag='0' and t.indexconf_id='"+window.dialogArguments.indexconfId+"'";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
rootMenuId = queryOrgRet.datas[0].id; 
rootMenuName = queryOrgRet.datas[0].name; 

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
	collapsible : false,// 允许隐藏
	title : "请选择",// 显示标题为树
	lines : true,// 出现节点间虚线
	autoScroll : true,// 自动出现滚动条
	frame : false,
	enableDD:true,
	tbar : new Ext.Toolbar({
		items:[
			{
				xtype:'button',
				text:'确定',
				handler:button_ok
			}
			,
			{
				xtype:'button',
				text:'取消',
				handler:button_cancel
			}
		]
	})
};

function button_ok(){
	var nodes = rctTree.getChecked();
	if(null!=nodes &&  nodes.length>0){
		var checkIds = "";// 存放选中的节点的id
		var checkNames = "";// 存放选中的节点的id
		for (var i = 0; i < nodes.length; i++) {   
			checkIds += "," + nodes[i].id;
			checkNames += "," + nodes[i].text;
		} 
		checkIds = checkIds=="" ? "" : checkIds.substr(1);
		checkNames = checkNames=="" ? "" : checkNames.substr(1);
		var obj = new Object();
		obj.checkIds=checkIds;
		obj.checkNames=checkNames;
		window.returnValue = obj;
		window.close();
	}else{
		alert("请选择指标项");
	}
}
function button_cancel(){
	window.close();
}

function dbClickNode(node){
	
}


/**
	获取parentNode的子节点
*/
function getSubNodes(parentNode) {
	getSubOrgNodes(parentNode,1);
}

// 加载下级节点
function getSubOrgNodes(parentNode,dbClickFlag){
	if(parentNode.firstChild.text!='loading') return;
	var info = parentNode.id;
	
	var obj = window.dialogArguments;
	var querySql="";
	if(""==obj.checkedCodes){
		querySql="select t.item_id as id, t.item_name as name,'false' as checked from dms_assess_indexconf_item t where t.bsflag = '0' and t.indexconf_id = '"+info+"' order by t.item_order";
	}else{
		querySql="select t.item_id as id, t.item_name as name,case when t.item_id in("+obj.checkedCodes+") then 'true' else 'false' end as checked from dms_assess_indexconf_item t where t.bsflag = '0' and t.indexconf_id = '"+info+"' order by t.item_order";
	}
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:querySql
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;
			//addSubNodes(parentNode,nodes);
			
			for (var i = 0; i < nodes.length; i++) {
				
				var treeNode = getItemNode(nodes[i]);
				appendEvent(treeNode);
				if(dbClickFlag==1){
					// 需要选择人时，移除双击事件
					treeNode.removeListener('dblclick',dbClickNode);
				}
				parentNode.appendChild(treeNode);

			}
			parentNode.firstChild.remove();// 删除当前节点第一个孩子节点(loading节点)
			parentNode.ui.addClass("x-tree-node-collapsed");//设置样式为文件夹，防止没有子机构而改变样式
		},
		failure : function(){// 失败
							}			
	});//eof Ext.Ajax.request
}

/**
构造指标项节点
*/
function getItemNode(nodeData){
	var isChecked;
	if("true"==nodeData.checked){
		isChecked=true;
	}else{
		isChecked=false;
	}
	var treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.id,
			text : nodeData.name,// 显示内容
			checked : isChecked,						
			leaf : true,								
			singleClickExpand:false
	});	
	
	return treeNode;
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