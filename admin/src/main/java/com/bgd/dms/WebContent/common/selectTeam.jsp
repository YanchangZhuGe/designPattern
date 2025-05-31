<%@ page language="java" pageEncoding="GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = request.getParameter("orgId");
	if(orgId==null || orgId.equals("")) orgId = user.getCodeAffordOrgID();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title></title>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";

/**公共变量定义*/
var rootMenuId = "<%=orgId%>";//"INIT_AUTH_ORG_012345678900000";

cruConfig.contextPath = "<%=contextPath%>";
var querySql = "Select oi.org_id,oi.org_abbreviation,os.org_subjection_id FROM comm_org_information oi join comm_org_subjection os on oi.org_id=os.org_id and os.bsflag = '0' and os.locked_if = '0' WHERE oi.bsflag='0' and oi.org_id='"+rootMenuId+"'";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
var rootMenuName = queryOrgRet.datas[0].org_abbreviation; 
rootMenuId += ","+queryOrgRet.datas[0].org_subjection_id; 
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
	width : 500,// 初始宽度
	minSize : 210,// 拖动最小宽度
	maxSize : 300,// 拖动最大宽度
	collapsible : true,// 允许隐藏
	title : "选择队伍",// 显示标题为树
	lines : true,// 出现节点间虚线
	autoScroll : true,// 自动出现滚动条
	frame : false,
	enableDD:true	
};

function dbClickNode(node){
	/*if(node.leaf){
		var obj = window.dialogArguments;
		obj.fkValue = node.id.substr(0,14);
		obj.value = node.text;
		window.close();
	}*/
}


/**
	获取parentNode的子节点
*/
function getSubNodes(parentNode) {
	if(parentNode.firstChild.text!='loading') return;
		
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:"select distinct org.org_subjection_id,org.org_id,case org.org_level when '0200100005000000008' then '1' else '0' end as is_leaf,org.org_abbreviation from (select oi.org_id,oi.org_name,os.org_subjection_id,os.father_org_id,os.coding_show_id,oi.org_level,oi.org_abbreviation from comm_org_information oi join comm_org_subjection os on oi.org_id=os.org_id and oi.bsflag='0' and os.bsflag='0')org where org.father_org_id='"+parentNode.id.substring(15)+"' start with org.org_id in (select org_id from comm_org_information where substr(org_id,1,4)='C600' and org_type = '0200100004000000024' and org_level='0200100005000000008' and bsflag='0') connect by prior org.father_org_id = org.org_subjection_id"
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;

			if(nodes!=null && nodes.length>0){
				for (var i = 0; i < nodes.length; i++) {
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
			id : nodeData.org_id+','+nodeData.org_subjection_id,
			text : nodeData.org_abbreviation,// 显示内容									
			leaf : true,								
			singleClickExpand: false,
			checked : false,
			children: [{// 添加loading子节点
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
		});	
	}else{
		treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.org_id+','+nodeData.org_subjection_id,
			text : nodeData.org_abbreviation,// 显示内容									
			leaf : false,								
			singleClickExpand:true,
			children: [{// 添加loading子节点
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
		});	
	}
	
	return treeNode;
}

	function getCheckedNode() {   
	    var nodes = rctTree.getChecked();
	    var checkIds = "";// 存放选中id
	    var checkTexts = "";// 存放选中id
	    if(nodes.length > 1){
	    	alert("只能选择一支队伍");
	    	return;
	    }
	    for (var i = 0; i < nodes.length; i++) {   
	    	checkIds += "," + nodes[i].id.substr(0,14);
	    	checkTexts += "," + nodes[i].text;
	    } 
	    
	    var obj = window.dialogArguments;
		obj.fkValue = checkIds=="" ? "" : checkIds.substr(1);
		obj.value = checkTexts=="" ? "" : checkTexts.substr(1);
		window.close();
	}   

	

</script>      

</head>
<body>

<table border="0" cellpadding="0" cellspacing="0"  id="FilterLayer" width="100%">
	<tr>
		<td align="left" style="padding-left:400px;padding-top:5px;padding-bottom:5px;">
			<input type="button" value="确定" onclick="getCheckedNode()" class="iButton2"/>
			<input type="button" value="取消" onclick="window.close()" class="iButton2"/>
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