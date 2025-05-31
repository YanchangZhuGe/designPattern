<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
  UserToken user = OMSMVCUtil.getUserToken(request);
  if(user==null){
	  request.getRequestDispatcher("login.jsp").forward(request, response);
	  return;
  }
  response.setContentType("text/html;charset=utf-8");
  String contextPath = request.getContextPath();
  String menuId = request.getParameter("menuId");  
  String menuUrl = request.getParameter("menuUrl");  
  String fl = request.getParameter("fl");
  
  String fromColl = request.getParameter("fromColl");
  String navUrl=request.getContextPath()+"/dms_info/hr_menu.jsp?parentMenuId="+menuId ;
  if(fromColl!=null &&fromColl.equals("yes")){
	  navUrl=request.getContextPath()+"/ibp/auth2/dmsCollMenu.srq";
  }
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/style.css"/>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
<link rel="stylesheet" href="<%=contextPath%>/js/extjs/resources/css/ext-all.css"/>
<title>设备寿命周期管理平台</title>
<script type="text/javascript">
	$(function(){
	 
		getTab('<%=menuId%>','<%=menuUrl%>','<%=fl%>');
		 
	});
	
	function doResize(){
		var h = $(window).height();
	
		$('#navFrame').css('height',h -1);
		$('#navHidBtn').css('height',h -1);
		$('#list').css('height',h -1);
		
		$('#navFrame').css('height',h -1);
		$('#navHidBtn').css('height',h -1);
		$('#list').css('height',h -1);
		window.frames["navHidBtn"].location.reload(true);
	}

	function hideLeftMenu(){
		document.getElementById('zzz').style.display="none";
		document.getElementById('yyy').style.display="none";
		document.getElementById('fff').style.display="none";
		var h = $(window).height();
		$('#list').css('height',h -15);
		$('#ttt').css('height',80);
		
		$('#list').css('height',h -150);
		$('#ttt').css('height',120);
	}
	function showLeftMenu(){
		document.getElementById('zzz').style.display="";
		document.getElementById('yyy').style.display="";
		document.getElementById('fff').style.display="";
		var h = $(window).height();
		$('#zzz').css('height',h -10);
	}

	function selectProject(){
		popWindow('<%=contextPath%>/pm/project/multiProject/index.jsp?backUrl=/pm/project/multiProject/projectList.jsp&action=view','1024:768');
	}

	topDialogs=[];

	function dialogCallback(funcName, arg){
		if(topDialogs.length>1){
			eval("top.topDialogs[top.topDialogs.length-2][0].get(0).contentWindow." + funcName + "(arg)");
		}else{
			eval("top.frames['list']." + funcName + "(arg)");
		}
	}

	//参数fl为1时，可根据参数自动定位菜单，为0时默认等待用户操作	
    function getTab(menuId,menuUrl,fl) { 
		window.frames["list"].location = menuUrl;	 
		window.frames["navHidBtn"].location.reload(true);
		var h = $(window).height();
		
		$('#list').css('height',h-44);
		$('#zzz').css('height',h);
  }
</script>   
</head>
<body >

  <table width="100%" cellpadding="0" cellspacing="0">
  <tr valign="top">
  	<!--  <td width="205px" id='zzz'> <iframe  id="navFrame" name="navFrame" title="navFrame" width="100%"  height="100%"  frameborder="0" scrolling="no" src="<%=request.getContextPath()%>/dms_info/hr_menu.jsp?parentMenuId=<%=menuId %>"></iframe></td>
  	-->
  	<td width="205px" id='zzz'> <iframe  id="navFrame" name="navFrame" title="navFrame" width="100%"  height="100%"  frameborder="0" scrolling="no" src="<%=navUrl%>"></iframe></td>
  	<td width="10px" id='yyy'> <iframe  id="navHidBtn" name="navHidBtn" title="navHidBtn" width="100%" height="750px"  frameborder="0" scrolling="no" src="<%=request.getContextPath()%>/skin/cute/navhidbtn.html"></iframe></td>
  	<td > 
  		<table width="100%" cellpadding="0" cellspacing="0">
  			<tr>
  				<td height="33px" id='fff'  >
			  		<iframe id="fourthMenuFrame" name="fourthMenuFrame" title="fourthMenuFrame" width="100%" height="100%" frameborder="0" scrolling="no" src="<%=request.getContextPath()%>/skin/cute/fourth_menu.jsp"></iframe>
				</td>
			</tr>
			<tr>
  				<td>
					<iframe id="list" name="list" title="mainFrame" width="100%" height="100%" frameborder="0" src="<%=request.getContextPath()%>/blank.htm"></iframe>
				</td>
			</tr>
		</table>
 </td>
 </tr>
 </table>
 </body>
</html>
