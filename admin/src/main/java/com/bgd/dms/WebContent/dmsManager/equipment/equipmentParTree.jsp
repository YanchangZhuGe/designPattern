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

<title>设备勘探名录管理</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
	<form name="form1" id="form1" method="post" action="">
	<div class="content_wrap">
		<div class="zTreeDemoBackground left">
			<ul id="treeDemo" class="ztree"></ul>
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
			onMouseDown: onMouseDown
		}
};
function onMouseDown(event, treeId, treeNode) {
	if (treeNode.children !=undefined) {
		if (treeNode.children && treeNode.children.length >= 0) {
			var id =treeNode.id;
			var pid =treeNode.pid;
			var whole = treeNode.whole;
			var href = _path
			+ "/dmsManager/equipment/equipmentParMan.jsp?id="+id+"&whole="+whole+"&pid="+pid;
			parent[ns.parentRightFrame].location.href = href;
		}
	}
	if (treeNode.children ==undefined) {
		var id =treeNode.id;
		var whole = treeNode.whole;
		var pid =treeNode.pid;
		var href = _path
		+ "/dmsManager/equipment/equipmentParMan.jsp?id="+id+"&whole="+whole+"&pid="+pid;
		parent[ns.parentRightFrame].location.href = href;
	}
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


/* str =[{"name":"Sercel","id":"001","pId":"0","open":"true","nocheck":"true"},{"name":"Sercels8","id":"0001","pId":"001","open":"true","nocheck":"true"}]; */
var zTree, rMenu;
$(document).ready(function(){
	var baseData =null;
	baseData = jcdpCallService("EquipmentParMan", "selTree", "id="+id);
	var str = eval(baseData.json);
	$.fn.zTree.init($("#treeDemo"), setting, str);
	zTree = $.fn.zTree.getZTreeObj("treeDemo");
	rMenu = $("#rMenu");
});
</script>
</html>

