<%@ page language="java" pageEncoding="GBK"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	String dev_ci_code = request.getParameter("dev_ci_code");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>设备台账选择界面</title>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<link href="<%= contextPath %>/styles/table.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
	var extPath = "<%=extPath%>";
	/**公共变量定义*/
	var rootMenuId = "<%=dev_ci_code%>";
	cruConfig.contextPath = "<%=contextPath%>";
	var querySql = "select dev_ci_name,dev_ci_model from gms_device_codeinfo where dev_ci_code='"+rootMenuId+"'";
	var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
	var rootMenuName = queryOrgRet.datas[0].dev_ci_name+"("+queryOrgRet.datas[0].dev_ci_model+")"; 
</script>
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
	title : "选择设备台账",// 显示标题为树
	lines : true,// 出现节点间虚线
	autoScroll : true,// 自动出现滚动条
	frame : false,
	enableDD:true	
};

function dbClickNode(node){
	if(node.id!=rootMenuId){
		window.returnValue =  node.id;
		window.close();
	}
}


/**
	获取parentNode的子节点
*/
function getSubNodes(parentNode) {
	if(parentNode.firstChild.text!='loading') return;

	var parentCondition = " dev_type='"+parentNode.id+"'";
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:"select dev_acc_id,asset_coding,dev_name,dev_model,self_num,dev_sign,license_num,dev_type,'1' as is_leaf FROM gms_device_account where "+parentCondition+" order by dev_coding"
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
			id : nodeData.dev_acc_id+"~"+nodeData.asset_coding+"~"+nodeData.dev_name+"~"+nodeData.dev_model+"~"+nodeData.self_num+"~"+nodeData.dev_sign+"~"+nodeData.license_num,
			text : nodeData.asset_coding+":"+nodeData.dev_name+"("+nodeData.dev_model+")",// 显示内容									
			leaf : false,
			singleClickExpand:true,
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