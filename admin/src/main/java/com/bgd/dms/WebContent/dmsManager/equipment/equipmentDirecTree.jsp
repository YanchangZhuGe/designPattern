<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="java.util.Date"%>
<%
	String contextPath = request.getContextPath();
	String id = request.getParameter("id");
	String pid = request.getParameter("pid");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/ext-all.js"></script>
<!-- ZTree树形插件 -->
<link rel="stylesheet" href="<%=contextPath %>/css/zTreeStyle2/metro.css" type="text/css"/>
<script type="text/javascript" src="<%=contextPath %>/js/ztree/jquery-1.4.4.min.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ztree/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ztree/jquery.ztree.excheck-3.5.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ztree/jquery.ztree.exedit-3.5.js"></script>
	<style type="text/css">
div#rMenu {position:absolute; visibility:hidden; top:0; background-color: #555;text-align: left;padding: 2px;}
div#rMenu ul li{
	margin: 1px 0;
	padding: 0 5px;
	cursor: pointer;
	list-style: none outside none;
	background-color: #DFDFDF;
}
	</style>

<title>勘探名录树</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
	<form name="form1" id="form1" method="post" action="">
	<div class="content_wrap">
		<div class="zTreeDemoBackground left">
			<ul id="treeDemo" class="ztree"></ul>
		</div>
	<div id="rMenu">
		<ul>
			<li id="m_add" onclick="addTreeNode();">增加菜单</li>
			<li id="m_udp" onclick="updateTreeNode();">修改菜单</li>
			<li id="m_del" onclick="removeTreeNode();">删除菜单</li>
		</ul>
	</div>
	</div>
	</form>
</body>
<script type="text/javascript">
var _path = '<%=contextPath%>';
var ns = new Object();
ns.windowParentName = "list";
ns.parentRightFrame = "mainRightframe";
ns.parentLeftFrame = "mainleftframe";
var id =<%=id%>;
var pid =<%=pid%>;
var i = null;
var setting = {	
		
		view: {
			dblClickExpand: true,
			showLine: false
		},
		data: {
			simpleData: {
				enable: true
			}
		},
		callback: {
			onRightClick: OnRightClick,
			onMouseDown: onMouseDown
		}
};
function onMouseDown(event, treeId, treeNode) {
	if (treeNode.children ==undefined) {
			var id =treeNode.id;
			var whole = treeNode.whole;
			var href = _path
			+ "/dmsManager/equipment/equipmentDirec.jsp?id="+id+"&whole="+whole;
			parent[ns.parentRightFrame].location.href = href;
	}
	if(treeNode.children !=undefined){
		if (treeNode.children && treeNode.children.length >= 0) {
			var id =treeNode.id;
			var whole = treeNode.whole;
			var href = _path
			+ "/dmsManager/equipment/equipmentDirec.jsp?id="+id+"&whole="+whole;
			parent[ns.parentRightFrame].location.href = href;
		}
	}
}
function OnRightClick(event, treeId, treeNode) {

	if (treeNode.children !=undefined) {
		if (treeNode.children && treeNode.children.length >= 0) {
			zTree.cancelSelectedNode();
			zTree.selectNode(treeNode);
			showRMenu("node", event.clientX, event.clientY);
		}
	}else{
		zTree.selectNode(treeNode);
		showRMenu("rent", event.clientX, event.clientY);
	}
}
function showRMenu(type, x, y) {
	$("#rMenu ul").show();
	if(type =="rent") {
		$("#m_add").hide();
		$("#m_udp").show();
		$("#m_del").show();
	} else{
		$("#m_del").show();
		$("#m_udp").hide();
		$("#m_add").show();
	}
	rMenu.css({"top":y+"px", "left":x+"px", "visibility":"visible"});

	$("body").bind("mousedown", onBodyMouseDown);
}
function hideRMenu() {
	if (rMenu) rMenu.css({"visibility": "hidden"});
	$("body").unbind("mousedown", onBodyMouseDown);
}
function hideRMenu() {
	if (rMenu) rMenu.css({"visibility": "hidden"});
	$("body").unbind("mousedown", onBodyMouseDown);
}
function onBodyMouseDown(event){
	if (!(event.target.id == "rMenu" || $(event.target).parents("#rMenu").length>0)) {
		rMenu.css({"visibility" : "hidden"});
	}
}
var addCount = 1;
function addTreeNode() {
	hideRMenu();
	if (zTree.getSelectedNodes()[0] == undefined){debugger;
		alert("请先选择菜单节点!");
		return;
	}
	var id =zTree.getSelectedNodes()[0].id;
	var pid =zTree.getSelectedNodes()[0].pid;
	var name =zTree.getSelectedNodes()[0].name;
	var whole = zTree.getSelectedNodes()[0].whole;
	popWindow(_path+ "/dmsManager/equipment/treeAdd.jsp?id="+id+"&pid="+pid+"&name="+name,'','新增');
	/* var href = _path
	+ "/dmsManager/equipment/treeAdd.jsp?&id="+id+"&pid="+pid+"&name="+name;
	parent[ns.parentRightFrame].location.href = href; */
}
function removeTreeNode() {
	hideRMenu();
	if (zTree.getSelectedNodes()[0] == undefined){
		alert("请先选择菜单节点!");
		return;
	}
	var nodes = zTree.getSelectedNodes();
	var whole = zTree.getSelectedNodes()[0].whole;
	var id = zTree.getSelectedNodes()[0].id;
	if (nodes && nodes.length>0) {
		if (nodes[0].children && nodes[0].children.length > 0) {
			alert("要删除的节点是父级菜单,包含子集菜单,不能被删除！");
			return;
		} else {
			var retObj = jcdpCallService("EquipmentParMan", "selectZtreeList", "current_device_type_id="+id);
			if(retObj.operationFlag!="undefined"){
				var dOperationFlag=retObj.operationFlag;
				if(''!=dOperationFlag){
					if("failed"==dOperationFlag){
						alert("包含参数不能删除！");
					}	
					if("success"==dOperationFlag){
						if(confirm('确定要删除吗?')){
							var retObj = jcdpCallService("EquipmentParMan", "deleteZtreeNote", "whole="+whole);
							if(typeof retObj.operationFlag!="undefined"){
								var dOperationFlag=retObj.operationFlag;
								if(''!=dOperationFlag){
									if("failed"==dOperationFlag){
										alert("删除失败！");
									}	
									if("success"==dOperationFlag){
										alert("删除成功！");
										zTree.removeNode(nodes[0]);
										queryData(cruConfig.currentPage);
									}
								}
							}
						}
					}
				}
			}
	  }
	}
}
 
function updateTreeNode(){
	hideRMenu();
	if (zTree.getSelectedNodes()[0] == undefined){
		alert("请先选择菜单节点!");
		return;
	}
	var id =zTree.getSelectedNodes()[0].id;
	var pid =zTree.getSelectedNodes()[0].pid;
	var name =zTree.getSelectedNodes()[0].name;
	var whole = zTree.getSelectedNodes()[0].whole;
	popWindow(_path+ "/dmsManager/equipment/treeAdd.jsp?id="+id+"&pid="+pid+"&name="+name+"&whole="+whole,'','修改');
	/* var href = _path
	+ "/dmsManager/equipment/treeAdd.jsp?&id="+id+"&pid="+pid+"&name="+name+"&whole="+whole;
	parent[ns.parentRightFrame].location.href = href; */
}


/* str =[{"name":"Sercel","id":"001","pId":"0","open":"true","nocheck":"true"},{"name":"Sercels8","id":"0001","pId":"001","open":"true","nocheck":"true"}]; */
var zTree, rMenu;
	function refreshData(){debugger;
	var baseData =null;
	baseData = jcdpCallService("EquipmentParMan", "selTree", "id="+id);
	var str = eval(baseData.json);
	$.fn.zTree.init($("#treeDemo"), setting, str);
	zTree = $.fn.zTree.getZTreeObj("treeDemo");
	rMenu = $("#rMenu");
}
</script>
</html>

