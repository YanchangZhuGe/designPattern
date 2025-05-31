<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@page import="java.net.URLDecoder"%>
<%
	String contextPath = request.getContextPath();
	String index = request.getParameter("index");
	  response.setHeader("Pragma","No-cache"); 
	  response.setHeader("Cache-Control","no-cache"); 
	  response.setDateHeader("Expires", 0);
	  
	  String level = request.getParameter("level");
	  if(level==null || level.equals("")) level="0";
	  
	  int levelNum = Integer.parseInt(level);
	  levelNum++;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<script type="text/javascript" src="<%=contextPath %>/js/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.dialog.js"></script>

<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
</head>
<body>
<center>
	<div>第<%=levelNum %>层</div>
	<input type="button" value="popWindow" onclick="showframes()"/>
	<input type="button" value="close" onclick="newClose()"/>
	<input type="button" value="mask" onclick="openMask()"/>
</center>
<div id="dialog-modal" title="正在执行" style="display:none;">
	请不要关闭
</div>
</body>
<script type="text/javascript">
	function showframes(){
		popWindow("<%=contextPath%>/demo/testPopWindow.jsp?level=<%=levelNum%>");
	}
	function openMask(){
		$( "#dialog-modal" ).dialog({
			height: 140,
			modal: true,
			draggable: false
		});
	}
</script>
</html>