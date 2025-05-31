<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/ibp/auth2/comm/include.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>菜单树</title>
</head>
<body>
	<script type="text/javascript" src="${ctx}/js/extjs/menu/menuTree.js"></script>
	<script type="text/javascript"> 
		Ext.onReady(function(){ 
			var treeConfig = Ext.urlDecode(location.search.substring(1));
			//treeConfig 可以写上自定义的属性，覆盖treepanel的默认属性
			var menuTree = new ibp.menu.treePanel(treeConfig);
			new Ext.Viewport({
				items : [menuTree],
				layout : 'fit'
			});
		});
	</script>
</body>
</html>