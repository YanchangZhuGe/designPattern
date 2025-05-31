<%@page contentType="text/html;charset=utf-8"%>
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
  String listUrl = request.getParameter("listUrl");
  String chartUrl = "";
  StringBuffer chartUrlBuffer = new StringBuffer();
  chartUrlBuffer.append(request.getContextPath()).append("/dms_info/index_info_chart.jsp");
  chartUrl = chartUrlBuffer.toString();
  
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/style.css"/>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/dms_home/home.css"/>
<link rel="stylesheet" href="<%=contextPath%>/js/extjs/resources/css/ext-all.css"/>
<script type="text/javascript" src="<%=contextPath %>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.dialog.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script src="<%=contextPath%>/js/extjs/ext-all.js"></script>
<script src="<%=contextPath%>/js/extjs/ext-lang-zh_CN.js"></script>

<title>设备管理体系信息系统</title>
<style type="text/css">
	html,body { height:100%; margin:0; overflow-y:hidden;}
</style>
<script type="text/javascript"> 
$(function(){
	$(window).resize(redirect('8ad899ae4ed8ec8b014ed90d1d27000d',<%=listUrl %>,'0','统计分析'));

	//doResize();

});
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
 
 function test(menuId,menuUrl,fl,menuName){
    // var h = $(window).height();
	//$('#ttt1').css('height',h); 
	var flag = false;
	if("仪表盘" == menuName){
		window.frames['topFrame'].preIsDashBoard=true;
	    window.frames['indexFrame'].location.href=menuUrl; 
	}else{
		
	    window.frames['indexFrame'].location.href='<%=request.getContextPath()%>/dms_info/index_info_old1.jsp?menuId='+menuId+'&fl='+fl+'&menuUrl='+menuUrl+'&listUrl='+<%=listUrl%>;
	   
	}
	flag = true;
	return flag;
	//chartSet.style.visibility = "visible";
	
 }
 function redirect(menuId,menuUrl,fl,menuName){
	 if(test(menuId,menuUrl,fl,menuName)){
		 chartSet.style.visibility = "visible"; 
	 }
	
 }
 
 //为收藏夹专用的跳转连接
 function testColl(menuId,menuUrl,fl,menuName,fromColl){
	    
		if("仪表盘" == menuName){
			window.frames['topFrame'].preIsDashBoard=true;
		    window.frames['indexFrame'].location.href=menuUrl; 
		}else{
			
		    window.frames['indexFrame'].location.href='<%=request.getContextPath()%>/dms_info/index_info_old.jsp?menuId='+menuId+'&fl='+fl+'&menuUrl='+menuUrl+'&fromColl='+fromColl;
		}
	 }
 
 function indexPage(page){
	 window.frames['indexFrame'].location.href=page; 
 }
 //test('8ad899ae4ed8ec8b014ed90d1d27000d','about:blank','0','统计分析');
</script>   
</head>
<body>

<div id="dialog_wrap" style=""></div>

<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%" id = "chartSet" style="visibility: hidden;">
 <tr>
  <td id='ttt' style="height:5.7%;background-color: #fff">
	   <iframe id="topFrame" name="topFrame" title="topFrame" width="100%" height="44px" frameborder="0" scrolling="no" src="<%=request.getContextPath()%>/common/index/header.srq"></iframe>
  </td>
 </tr>
 <tr>
  <td id='ttt3' style="height:1.3%;background:#F1F4F9;background-image:url(<%=contextPath%>/css/dms_home/images/yemei-yinying.png); background-position:center top; background-repeat: repeat-x;">
  </td>
 </tr>
 <tr>
 <td id='ttt1' style="height:93%">
   <iframe id="indexFrame"  name="indexFrame" title="indexFrame" width="100%" height="100%" frameborder="0" scrolling="no" src="<%=request.getContextPath()%>/dms_info/index_info.jsp"></iframe>
 </td>
 </tr>
 </table>

 </body>
</html>
