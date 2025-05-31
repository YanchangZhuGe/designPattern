<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
  UserToken user = OMSMVCUtil.getUserToken(request);
  if(user==null){
	  request.getRequestDispatcher("login.jsp").forward(request, response);
	  return;
  }
  response.setContentType("text/html;charset=UTF-8");
  String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>设备寿命周期管理平台</title>
<style type="text/css">
	html,body { height:100%; margin:0; overflow-y:hidden;}
</style>
<script type="text/javascript">
	$(function(){
		$(window).resize(doResize);

		doResize();

	});
	
	function doResize(){
		var h = $(window).height();
	
		$('#navFrame').css('height',h -83);
		$('#navHidBtn').css('height',h -93);
		$('#list').css('height',h -125);
		
		$('#navFrame').css('height',h -120);
		$('#navHidBtn').css('height',h -120);
		$('#list').css('height',h -150);
		//alert($('#navHidBtn').css('height'));
		window.frames["navHidBtn"].location.reload(true);
	}

	function hideLeftMenu(){
		document.getElementById('zzz').style.display="none";
		document.getElementById('yyy').style.display="none";
		document.getElementById('fff').style.display="none";
		var h = $(window).height();
		$('#list').css('height',h -85);
		$('#ttt').css('height',80);
		
		$('#list').css('height',h -150);
		$('#ttt').css('height',120);
	}
	function showLeftMenu(){
		document.getElementById('zzz').style.display="";
		document.getElementById('yyy').style.display="";
		document.getElementById('fff').style.display="";
		var h = $(window).height();
		$('#list').css('height',h -125);
		$('#ttt').css('height',90);
		
		$('#list').css('height',h -150);
		$('#ttt').css('height',120);
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

</script>   
</head>
<body >

<div id="dialog_wrap" style="background:#fff;"></div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
 <tr>
  <td id='ttt' height="80px">
	   <iframe id="topFrame" name="topFrame" title="topFrame" width="100%" height="100%" frameborder="0" scrolling="no" src="<%=request.getContextPath()%>/common/index/header.srq"></iframe>
  </td>
 </tr>
 <tr>
 <td id="xxFrame" >
  <table width="100%" cellpadding="0" cellspacing="0">
  <tr valign="top">
  	<td width="205px"  id='zzz' style='display:none;'> <iframe  id="navFrame" name="navFrame" title="navFrame" width="100%"  height="100%"  frameborder="0" scrolling="no" src="<%=request.getContextPath()%>/hr_menu.jsp"></iframe></td>
  	<td width="10px" id='yyy' style='display:none;'>   <iframe  id="navHidBtn" name="navHidBtn" title="navHidBtn" width="100%" height="100%"  frameborder="0" scrolling="no" src="<%=request.getContextPath()%>/skin/cute/navhidbtn.html"></iframe></td>
  	<td > 
  		<table width="100%" cellpadding="0" cellspacing="0">
  			<tr>
  				<td height="33px" id='fff' style='display:none;'>
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
 </td>
 </tr>
 </table>
 </body>
</html>
