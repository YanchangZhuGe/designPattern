<%@ page language="java" pageEncoding="GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="ExtTab" prefix="eRed"%> 
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = "";
	if(user!=null) userId = user.getUserId();
	String orgId = user.getOrgId();
	if(orgId==null || orgId.equals("")) orgId = "C6000000000001";//user.getCodeAffordOrgID();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title></title>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script language="javascript" type="text/javascript">
var extPath = "<%=extPath%>";

var rootMenuId = "";
var rootMenuName = "";
/**公共变量定义*/
cruConfig.contextPath = "<%=contextPath%>";
debugger;
var querySql = "select t1.org_hr_id, t1.org_hr_short_name as org_name, t2.org_gms_id, t3.org_subjection_id as org_gms_sub_id from bgp_comm_org_hr t1 join bgp_comm_org_hr_gms t2 on t1.org_hr_id=t2.org_hr_id join comm_org_subjection t3 on t3.org_id=t2.org_gms_id and t3.bsflag='0' where t2.org_gms_id='<%=orgId%>'";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
rootMenuId = queryOrgRet.datas[0].org_hr_id + ',' + queryOrgRet.datas[0].org_gms_id + ',' + queryOrgRet.datas[0].org_gms_sub_id; 
rootMenuName = queryOrgRet.datas[0].org_name; 


</script>

<link href="<%= contextPath %>/styles/table.css" rel="stylesheet" type="text/css" />
<!-- ext -->
<link rel="stylesheet" type="text/css" href="<%=extPath %>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath %>/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=extPath %>/ext-all.js"></script> 

<script language="javascript" type="text/javascript">
var treeDivId = "menuTree";
var loadingIcon = extPath+"/resources/images/default/shared/blue-loading.gif";
var blank_image_url = extPath+"/resources/images/default/s.gif";

var rightMenu = null;
var selectedNode;
var jcdpTreeCfg={
	moveNodeAction:'/tcg/moveTreeNodePosition.srq',
	clickEvent:false,
	dbClickEvent:false,
	moveEvent:false,
	rightClickEvent:false
};
var rctTree_common;
Ext.onReady(function() {
	<%if("true".equals(request.getParameter("noPersonalTab"))){ %>
	return;
	<%} %>
	Ext.BLANK_IMAGE_URL = blank_image_url;
	var rootNode_common = new Ext.tree.AsyncTreeNode({
				id:'root,3.0',
				text:'常用联系人',
				singleClickExpand:true,
				children : [{// 子节点
					text : 'loading',// 显示文字为loading
					icon : loadingIcon,// 使用图标为loading
					leaf : true					
				}]
	});
	var treeLoader_common = new Ext.tree.TreeLoader();// 指定一个空的TreeLoader
	
	 rctTree_common = new Ext.tree.TreePanel({// 声明一个TreePanel显示tree
		id : 'common',// id为tree
		region : 'west',// 设定显示区域为东边,停靠在容器左边
		split : true,// 出现拖动条
		bodyStyle:"padding:2px",
		collapseMode : 'mini',// 拖动条显示类型为mini,可出现拖动条中间的尖头
		width : 480,// 初始宽度
		minSize : 210,// 拖动最小宽度
		maxSize : 300,// 拖动最大宽度
		collapsible : true,// 允许隐藏
		lines : true,// 出现节点间虚线
		autoScroll : true,// 自动出现滚动条
		frame : false,
		enableDD:true,
		loader : treeLoader_common,// 指定数据载入的loader对象,现在定义为空	
		root : rootNode_common
	});

	 
	rctTree_common.render("menuTree1"); // 渲染到层
	
	appendEvent_common(rootNode_common);
	rctTree_common.getRootNode().toggle();	
});
var rctTree;
Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = blank_image_url;
	var rootNode = new Ext.tree.AsyncTreeNode({
				id:rootMenuId,
				text:rootMenuName,
				singleClickExpand:true,
				children : [{// 子节点
					text : 'loading',// 显示文字为loading
					icon : loadingIcon,// 使用图标为loading
					leaf : true					
				}]
	});
	var treeLoader = new Ext.tree.TreeLoader();// 指定一个空的TreeLoader
	
	 rctTree = new Ext.tree.TreePanel({// 声明一个TreePanel显示tree
		id : 'tree',// id为tree
		region : 'west',// 设定显示区域为东边,停靠在容器左边
		split : true,// 出现拖动条
		bodyStyle:"padding:2px",
		collapseMode : 'mini',// 拖动条显示类型为mini,可出现拖动条中间的尖头
		width : 480,// 初始宽度
		minSize : 210,// 拖动最小宽度
		maxSize : 300,// 拖动最大宽度
		collapsible : false,// 允许隐藏
		lines : true,// 出现节点间虚线
		autoScroll : true,// 自动出现滚动条
		frame : false,
		enableDD:true,
		loader : treeLoader,// 指定数据载入的loader对象,现在定义为空	
		root : rootNode
	});

	rctTree.render("menuTree2"); // 渲染到层
	
	appendEvent(rootNode);
	rctTree.getRootNode().toggle();	
});
/**
	给节点增加响应事件
*/
function appendEvent(treeNode){
	treeNode.on('expand', getSubNodes);// 定义当前节点展开时调用getSubNodes,再次异步读取子节点
	
}	
/**
	给节点增加响应事件
*/
function appendEvent_common(treeNode){
	treeNode.on('expand', getSubNodes_common);// 定义当前节点展开时调用getSubNodes,再次异步读取子节点
	
}	
/**
获取parentNode的子节点
*/
function getSubNodes(parentNode) {
if(parentNode.firstChild.text!='loading') return;

var info = parentNode.id.split(',');

// 加载人员
Ext.Ajax.request({
	url : "<%=contextPath%>"+appConfig.queryListAction,
	params : {
		currentPage:"1",
		pageSize:"10000",
		querySql:"Select e.employee_id,e.employee_name FROM comm_human_employee e WHERE e.bsflag='0' and e.org_id='"+info[1]+"'"
	},
	method : 'Post',
	success : function(resp){
		var myData = eval("("+resp.responseText+")");
		var nodes = myData.datas;
		
		for (var i = 0; i < nodes.length; i++) {
			var treeNode = getEmployeeNode(nodes[i]);
			
			appendEvent(treeNode);
			parentNode.appendChild(treeNode);
		}

		getSubOrgNodes(parentNode,1);
	}
});


}

//加载下级机构
function getSubOrgNodes(parentNode,dbClickFlag){
	var info = parentNode.id.split(',');
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:"select t1.org_hr_id, t1.org_hr_short_name as org_name, t2.org_gms_id, t3.org_subjection_id as org_gms_sub_id from bgp_comm_org_hr t1 join bgp_comm_org_hr_gms t2 on t1.org_hr_id=t2.org_hr_id join comm_org_subjection t3 on t3.org_id=t2.org_gms_id and t3.bsflag='0' where t1.org_hr_parent_id='" + info[0] + "'"
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;
			//addSubNodes(parentNode,nodes);
			
			for (var i = 0; i < nodes.length; i++) {
				
				var treeNode = getOrgNode(nodes[i]);
				appendEvent(treeNode);
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
获取parentNode的子节点
*/
function getSubNodes_common(parentNode) {
if(parentNode.firstChild.text!='loading') return;

var info = parentNode.id.split(',');

// 加载人员
	Ext.Ajax.request({
		url : "<%=contextPath%>"+appConfig.queryListAction,
		params : {
			currentPage:"1",
			pageSize:"10000",
			querySql:"select t.entity_id,t.object_type,t.object_id,(case t.object_type when '3.1' then (select e.employee_name from comm_human_employee e where t.object_id=e.employee_id and e.bsflag='0') else spare1 end) as object_name from ic_user_favorite_dms t  where t.object_type in ('3.1','3.2','3.3') and t.user_id='<%=userId%>' and t.spare2='"+info[0]+"' and t.bsflag='0' order by object_name"
		},
		method : 'Post',
		success : function(resp){
			var myData = eval("("+resp.responseText+")");
			var nodes = myData.datas;
			
			for (var i = 0; i < nodes.length; i++) {
				var treeNode = getPersonalNode(nodes[i]);
				
				appendEvent_common(treeNode);
				parentNode.appendChild(treeNode);
				treeNode.toggle();	
			}
			parentNode.firstChild.remove();// 删除当前节点第一个孩子节点(loading节点)
			if(info[1]=="3.2"){
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
function getPersonalNode(nodeData){
	var treeNode;
	if(nodeData.object_type=="3.2"){
		treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.entity_id+','+nodeData.object_type+','+nodeData.object_id,
			text : nodeData.object_name,// 显示内容									
			leaf : false,	
			checked:false,
			singleClickExpand:true,
			checkChange:function(){
				alert();
			},
			children: [{// 添加loading子节点
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
		});	
		
		treeNode.on('checkchange', function(node, checked) {   
			node.expand();   
			node.attributes.checked = checked;   
			node.eachChild(function(child) {   
				child.ui.toggleCheck(checked);   
				child.attributes.checked = checked;   
			});   
		}, treeNode); 
	}else{
		treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.object_id,
			text : nodeData.object_name,// 显示内容									
			leaf : true,								
			checked : false,
			singleClickExpand : false,
			children: [{// 添加loading子节点
				text : 'loading',
				icon : loadingIcon,
				leaf : true
			}]
		});	
	}
	
	

	return treeNode;
}

/**
根据服务器查询到的nodeData构造ext树节点
*/
function getEmployeeNode(nodeData){
	var treeNode = new Ext.tree.AsyncTreeNode({
			id : nodeData.employee_id,
			text : nodeData.employee_name,// 显示内容									
			leaf : true,		
			checked:false,						
			singleClickExpand : false
	});	
	
	return treeNode;
}

/**
根据服务器查询到的nodeData构造ext树节点
*/
function getOrgNode(nodeData){
	var treeNode = new Ext.tree.AsyncTreeNode({
		id : nodeData.org_hr_id+','+nodeData.org_gms_id+','+nodeData.org_gms_sub_id,
		text : nodeData.org_name,// 显示内容									
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

function confirmchoose() {   
    var nodes = rctTree.getChecked();
    var saveId = "";// 存放选中id
    var saveValue = "";
    for (var i = 0; i < nodes.length; i++) {   
    	if(saveId==""){
			saveId+=nodes[i].id;
		}else{
			saveId+=","+nodes[i].id;
		}
		if(saveValue==""){
			saveValue+=nodes[i].text;
		}else{
			saveValue+=","+nodes[i].text;
		}
    } 
    <%if(!"true".equals(request.getParameter("noPersonalTab"))){ %>	
    var nodesCommon=rctTree_common.getChecked();
    for(var i = 0; i < nodesCommon.length; i++) {   
    	if(nodesCommon[i].leaf!=false){
	    	if(saveId==""){
	    		saveId+=nodesCommon[i].id;
	    	}else{
	    		if(saveId.indexOf(nodesCommon[i].id) <0 )  {
	    			saveId+=","+nodesCommon[i].id;
	    		}
	    	}
	    	if(saveValue==""){
				saveValue+=nodesCommon[i].text;
			}else{
				if(saveValue.indexOf(nodesCommon[i].text)< 0 )  {
				saveValue+=","+nodesCommon[i].text;
				}
			}
   		}
    }
	<%} %>
    var obj = window.dialogArguments;
	obj.fkValue=saveId;
	obj.value = saveValue;
	debugger;
	window.close();
}   
</script>      
</head>
<body style="overflow-x:hidden;overflow-y:hidden">
<table border="0" cellpadding="0" cellspacing="0"  id="FilterLayer" width="100%" height="100%">
	<tr>
		<td align="left" valign="top">
			<eRed:tabs tabsId="tabs" activeTab="0" width="500" height="540" autoScroll="true">
  				<%if(!"true".equals(request.getParameter("noPersonalTab"))){ %>
  				<eRed:tab tabId="table1" title="常用联系人">
     			 <div id="menuTree1" style="width:100%;height:100%;overflow:auto;"></div>
	 			</eRed:tab>
	 			<%} %>
	  			<eRed:tab tabId="table2" title="所有人员">
	    			<div id="menuTree2" style="width:100%;height:100%;overflow:auto;"></div>
	  			</eRed:tab>
			</eRed:tabs>
		</td>
	</tr>
</table>
</body>