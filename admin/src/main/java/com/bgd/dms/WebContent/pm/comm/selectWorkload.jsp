<%@ page language="java" pageEncoding="GBK"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	String codingSortId = "6121";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String exploration_method = user.getExplorationMethod() != null ? user.getExplorationMethod() :"";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title></title>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";
var expMethod = "<%=exploration_method%>";
/**公共变量定义*/
var rootMenuId = "<%=codingSortId%>";//"INIT_AUTH_ORG_012345678900000";

cruConfig.contextPath = "<%=contextPath%>";
var querySql = "select * from bgp_p6_resource_workload WHERE exploration_method = 'root' and object_id = '"+rootMenuId+"'";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
var rootMenuName = queryOrgRet.datas[0].name; 
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
	title : "选择工作量<input type='button' value='确定' onclick='fun()'>",// 显示标题为树
	lines : true,// 出现节点间虚线
	autoScroll : true,// 自动出现滚动条
	frame : false,
	enableDD:true	
};

function dbClickNode(node){
		//var obj = window.dialogArguments;
		//obj.fkValue = node.id;
		//obj.value = node.text;
 
		//window.close();
}

function fun(){
	debugger;
	//alert(1);
	var nodes = rctTree.getChecked();
	var checkIds = "";// 存放选中的节点的id
    var checkTexts = "";// 存放选中的节点的text
   
    for (var i = 0; i < nodes.length; i++) {   
 		var node = nodes[i];
 		var node_text = node.text.split('_')[0];
 		if(node_text.length < 5){
 			alert("不能选择"+node_text+",请选择下一级");
 			return;
 		}
      	checkIds += "," + node.id;
      	checkTexts += "," + node.text;
 	} 
	checkIds = checkIds=="" ? "" : checkIds.substr(1);
	if(checkIds == ""){
		alert("1");
	}
	checkTexts = checkTexts=="" ? "" : checkTexts.substr(1);
	
	var obj = window.dialogArguments;
	obj.fkValue = checkIds;
	obj.value = checkTexts;
	window.close();
}


/**
	获取parentNode的子节点
*/
function getSubNodes(parentNode) {
	if(parentNode.firstChild.text!='loading') return;
	var sql = "select * from bgp_p6_resource_workload WHERE bsflag = '0' and parent_object_id = '"+parentNode.id+"'";
	if(expMethod == '0300100012000000003'){
		sql = "select * from bgp_p6_resource_workload WHERE bsflag = '0' and exploration_method = '0300100012000000003' and parent_object_id = '"+parentNode.id+"'";
	}else if(expMethod == '0300100012000000002'){
		sql = "select * from bgp_p6_resource_workload WHERE bsflag = '0' and exploration_method = '0300100012000000002' and parent_object_id = '"+parentNode.id+"'";
	}
	
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:sql
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
			id : nodeData.object_id,
			text : nodeData.id+'_'+nodeData.name,// 显示内容									
			leaf : false,
			singleClickExpand:true,
			checked : false,
			children: [{// 添加loading子节点
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
	});	
	//debugger;
	//if(nodeData.if_check == 'false') {
	//treeNode.checked = true;	
	//}
	treeNode.leaf = false;
	treeNode.singleClickExpand = false;
	
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