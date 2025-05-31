<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String extPath = contextPath + "/js/extjs";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head><meta http-equiv="X-UA-Compatible" content="IE=9; IE=8; IE=7; IE=EDGE"> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title></title>
<link href="<%= contextPath %>/styles/table.css" rel="stylesheet" type="text/css" />
<!-- ext -->
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css" />
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 
<script type="text/javascript" src="<%=extPath %>/tree.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";
var contextPath = "<%=contextPath%>";
/**公共变量定义*/
var rootMenuName = "考核项信息"; 
var rootMenuId = "rootMenuId";

var treeDivId = "menuTree";
var loadingIcon = extPath+"/resources/images/default/shared/blue-loading.gif";
var blank_image_url = extPath+"/resources/images/default/s.gif";
//var default_image_url = "<%=contextPath%>/images/images/tree_15.png";

var assessSql="";
var atretObj = jcdpCallService("AutoScoreSrv", "getAssessItemSqlInfo", "conf_id="+window.dialogArguments.assessId);
if(typeof atretObj.data!="undefined"){
	assessSql=atretObj.data;
}

jcdpTreeCfg.moveEvent = false;
jcdpTreeCfg.rightClickEvent =false;
jcdpTreeCfg.dbClickEvent = true;

var treeCfg = {
	region : 'west',// 设定显示区域为东边,停靠在容器左边
	border : false,
	split : true,// 出现拖动条
	bodyStyle:"padding:2px",
	collapseMode : 'mini',// 拖动条显示类型为mini,可出现拖动条中间的尖头
	width : 530,// 初始宽度
	minSize : 210,// 拖动最小宽度
	maxSize : 300,// 拖动最大宽度
	collapsible : true,// 允许隐藏
	title : "",// 显示标题为树
	lines : true,// 出现节点间虚线
	autoScroll : true,// 自动出现滚动条
	frame : false,
	enableDD:false //是否拖动	
};

function dbClickNode(node){
	if("rootMenuId"==node.id){
		alert("请选择子节点");
		return;
	}
	var obj = window.dialogArguments;
	obj.id = node.id;
	obj.name = node.text;
	window.close();
}
/**
	获取parentNode的子节点
*/
function getSubNodes(parentNode) {
	if(parentNode.firstChild.text!='loading') return;
	//alert("assessSql == "+assessSql);
	var querySql=assessSql;
	var nodes;
	Ext.Ajax.request({
		url : "<%=contextPath%>/rad/asyncQueryList.srq",
		params : {
			currentPage: "1",
			pageSize: "10000",
			querySql: querySql
		},
		method : 'Post',
		
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			 nodes = myData.datas;
			 
				for (var i = 0; i < nodes.length; i++) {
					var treeNode = getTreeNode(nodes[i]);
					appendEvent(treeNode);
					parentNode.appendChild(treeNode);
				}
			
				parentNode.firstChild.remove();// 删除当前节点第一个孩子节点(loading节点)	
				parentNode.ui.addClass("x-tree-node-collapsed");//设置样式为文件夹，防止没有子机构而改变样式
			},
			failure : function(){// 失败
			}			
	});
	
}

/**
根据服务器查询到的nodeData构造ext树节点
*/
function getTreeNode(nodeData){
var treeNode = new Ext.tree.AsyncTreeNode({
		id : nodeData.id,
		text : nodeData.name,// 显示内容					
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
</html>