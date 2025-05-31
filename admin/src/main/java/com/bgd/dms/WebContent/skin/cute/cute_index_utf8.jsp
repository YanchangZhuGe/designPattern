<%@ page contentType="text/html;charset=utf-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
response.setContentType("text/html;charset=utf-8");
  response.setHeader("Pragma","No-cache"); 
  response.setHeader("Cache-Control","no-cache"); 
  response.setDateHeader("Expires", 0);
  String contextPath = request.getContextPath();
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/JCDP_SAIS_CSS/style.css">
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/JCDP_SAIS_CSS/jquery_ui/jquery.ui.all.css">
<script type="text/javascript" src="<%=contextPath %>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.dialog.js"></script>
 
<title>ePlanet</title>
<style type="text/css">
html,body { height:100%; margin:0;}
</style>
</head>
<body>
<div id="dialog_wrap"></div>
<TABLE style="background:#ccc;" width="100%" border="0" cellpadding="0" cellspacing="0">
 <TR>
  <TD  height="60px">
   <IFrame align="center" id="topFrame" name="topFrame" title="topFrame" width="100%" height="100%" frameborder="0" scrolling="No" src="<%=request.getContextPath()%>/skin/cute/header.jsp"></IFrame>
  </TD>
 </TR>
 <TR>
 <td id="xxFrame" >
  <table width="100%" cellpadding="0" cellspacing="0">
  <tr valign="top">
  	<td width="260px"  id='zzz' style='display:block;'> <IFrame  id="navFrame" name="navFrame" title="navFrame" width="100%"  height="100%"  frameborder="0" scrolling="No" src="<%=request.getContextPath()%>/skin/cute/nav_new.jsp"></IFrame></td>
  	<td width="20px" > <IFrame  id="navHidBtn" name="navHidBtn" title="navHidBtn" width="100%" height="100%"  frameborder="0" scrolling="No" src="<%=request.getContextPath()%>/skin/cute/navhidbtn.html"></IFrame></td>
  	<td > <IFrame id="list" name="list" title="mainFrame" width="100%" height="100%" frameborder="0" scrolling="No" src="blank.htm"></IFrame></td>
  </tr>
  </table>
 </td>
 </TR>
 </TABLE>
<script type="text/javascript">
var menus = {
	menu1List : new Array(),
	menu2List : new Array()
};

$(window).resize(doResize);
function doResize(){
   var h = $(window).height();
//   document.getElementById('xxFrame').style.height = h - 60;
	document.getElementById('navFrame').style.height = h -60 -4;
	document.getElementById('navHidBtn').style.height = h -60 -4;
	document.getElementById('list').style.height = h -60-4;
   var oldMenu1Index = window.frames( "navFrame").document.getElementById('menu1Index').value;
   var oldMenu2Index = window.frames( "navFrame").document.getElementById('menu2Index').value;
   window.frames( "navFrame").document.location.href="<%=request.getContextPath()%>/skin/cute/nav_new.jsp?menu1="+oldMenu1Index+"&menu2="+oldMenu2Index;;
   window.frames( "navHidBtn").location.reload(true);
// 	window.frames( "list").autoHeight();
}

	var h = $(window).height();
//	alert(h);
//	document.getElementById('xxFrame').style.height = h - 60;
	document.getElementById('navFrame').style.height = h -60-4;
	document.getElementById('navHidBtn').style.height = h -60-4;
	document.getElementById('list').style.height = h -60-4;
</script>   
 </body>
</html>
