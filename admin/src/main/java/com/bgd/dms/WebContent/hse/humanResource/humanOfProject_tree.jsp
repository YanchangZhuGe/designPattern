<%@ page language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo==null || projectInfoNo.equals("")) projectInfoNo = user.getProjectInfoNo();
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
var rootMenuName = ""; 
var rootMenuId = "";

var querySql = "select t.project_info_no,t.project_name from gp_task_project t where t.project_info_no='<%=projectInfoNo%>'";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
var datas = queryOrgRet.datas;
debugger;
if(datas.length!=0){
	rootMenuName = datas[0].project_name;
	rootMenuId = datas[0].project_info_no;
}
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
	title : "选择项目人员",// 显示标题为树
	lines : true,// 出现节点间虚线
	autoScroll : true,// 自动出现滚动条
	frame : false,
	enableDD:true	
};

function dbClickNode(node){
	debugger;
	var orgName = node.text;
	
	
	var fkValue = node.id.split(",")[0];
	var obj = window.dialogArguments;
	obj.fkValue = fkValue;
	obj.value = node.text;
	window.close();
	
	
	//var obj = window.dialogArguments;
	//obj.fkValue = node.id.split(",")[1];
	//obj.value = node.text;
//	window.parent.opener.getValue(orgName);
//	window.close();
}


/**
	获取parentNode的子节点
*/
function getSubNodes(parentNode) {
	if(parentNode.firstChild.text!='loading') return;
	var info = parentNode.id.split(',');
	debugger;
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:"select * from view_human_project_relation t where t.project_info_no='"+info[0]+"'"
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
			id : nodeData.employee_id,
			text : nodeData.employee_name,// 显示内容									
			leaf : true,								
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