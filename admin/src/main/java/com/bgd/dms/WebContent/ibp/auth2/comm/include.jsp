<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil" %>
<% request.setAttribute("ctx",request.getContextPath());%>
<link rel="stylesheet" href="${ctx}/js/extjs/resources/css/ext-all.css"/>
<style type="text/css">
	.save {
		background: url(${ctx}/js/extjs/resources/images/menu/save.png) no-repeat !important;
	}
	.refresh {
		background: url(${ctx}/js/extjs/resources/images/menu/refresh.png) no-repeat !important;
	}
</style>
<script src="${ctx}/js/extjs/adapter/ext/ext-base.js"></script>
<script src="${ctx}/js/extjs/ext-all-debug.js"></script>
<script src="${ctx}/js/extjs/ext-lang-zh_CN.js"></script>
<script>
	Ext.BLANK_IMAGE_URL = "${ctx}/js/extjs/resources/images/default/s.gif";
	Ext.QuickTips.init();
</script>
<script>
	var	_path = "${ctx}", _userId = "<%=OMSMVCUtil.getUserToken(request).getUserId()%>";
</script>
</script>
<style type="text/css" >
    .x-selectable, .x-selectable * {
        -moz-user-select: text! important;
        -khtml-user-select: text! important;
    }
</style>
