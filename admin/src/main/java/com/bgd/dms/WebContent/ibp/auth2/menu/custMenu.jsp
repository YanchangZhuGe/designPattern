<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"
	import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"
%>
<html lang="zh-CN">
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  	<!--[if lt IE 10]>
		<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	<![endif]-->
    <title>常用权限定义</title>
	<link rel="stylesheet" href="<%=request.getContextPath()%>/js/extjs/resources/css/ext-all.css">
	<style type="text/css">
		.save {
			background: url(<%=request.getContextPath()%>/js/extjs/resources/images/menu/save.png) no-repeat !important;
		}
		.refresh {
			background: url(<%=request.getContextPath()%>/js/extjs/resources/images/menu/refresh.png) no-repeat !important;
		}
	</style>
	<script>
		//为js初始化一些参数
		var	_path = "<%=request.getContextPath()%>",
			_userId = "<%=OMSMVCUtil.getUserToken(request).getUserId()%>";
	</script>
  </head>
  <body>
    <script src="<%=request.getContextPath()%>/js/extjs/adapter/ext/ext-base.js"></script>
	<script src="<%=request.getContextPath()%>/js/extjs/ext-all-debug.js"></script>
	<script src="<%=request.getContextPath()%>/js/extjs/ext-lang-zh_CN.js"></script>
	<script src="<%=request.getContextPath()%>/js/extjs/menu/custMenu.js"></script>
	<script src="<%=request.getContextPath()%>/js/extjs/menu/menuTree.js"></script>
	<script>
		Ext.BLANK_IMAGE_URL = "<%=request.getContextPath()%>/js/extjs/resources/images/default/s.gif";
		Ext.QuickTips.init();
	</script>
	<script>
		Ext.onReady(function(){
			var menuPanel = new ibp.menu.TwoTreePanel({
				_path : _path,
				_userId : _userId,
				url : _path+"/tcg/ajaxServiceProxyAction.srq?JCDP_SRV_NAME=RADCommCRUD&JCDP_OP_NAME=queryRecords"
			});
			new Ext.Viewport({
				items : [menuPanel],
				layout : 'fit'
			});
		});
	</script>
  </body>
</html>
