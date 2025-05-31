<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.webapp.constant.MVCConstant"%>
<%@page import="java.util.List"%>
<%
  UserToken user = OMSMVCUtil.getUserToken(request);
  if(user==null){
	  request.getRequestDispatcher("login.jsp").forward(request, response);
	  return;
  }
  response.setContentType("text/html;charset=utf-8");
  String contextPath = request.getContextPath(); 
  ISrvMsg msg = (ISrvMsg) request.getAttribute(MVCConstant.RESPONSE_DTO); 
  List<MsgElement> menus = msg.getMsgElements("nodes");	
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=9; IE=8; IE=EDGE">
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/dms_home/home.css"/>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/style.css"/>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/styles/panelTableStyle.css"  />
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/table_fixed.css"  />
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/js/extjs/resources/css/ext-all.css"/>
<script type="text/javascript" src="<%=contextPath %>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.dialog.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery.messager.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/jdialog/jdialog.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/popup/CJL.0.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/popup/AlertBox.js"></script>
<script type="text/javascript" src="<%=contextPath%>/rm/dm/panel/js/swfobject.js"></script>
<title>设备寿命周期管理平台</title>
<style type="text/css">
	html,body { height:100%; margin:0;overflow:hidden}
</style> 
<style type="text/css"> 
* {margin:0px;padding:0px;} 
html,body { height:100%;} 
body { font-size:14px; line-height:24px;} 
#tip { 
position: absolute; 
right: 0px; 
bottom: 0px; 
height: 0px; 
width: 260px; 
border: 1px solid #CCCCCC; 
background-color: #eeeeee; 
padding: 1px; 
overflow:hidden; 
display:none; 
font-size:12px; 
z-index:10; 
} 
#tip p { padding:6px;} 
#tip h1,#detail h1 { 
font-size:14px; 
height:25px; 
line-height:25px; 
background-color:#0066CC; 
color:#FFFFFF; 
padding:0px 3px 0px 3px; 
filter: Alpha(Opacity=100); 
} 
#tip h1 a,#detail h1 a { 
float:right; 
text-decoration:none; 
color:#FFFFFF; 
} 
#shadow { 
position:absolute; 
width:100%; 
height:100%; 
background-color:#000000; 
z-index:11; 
filter: Alpha(Opacity=70); 
display:none; 
overflow:hidden; 
} 
#detail { 
width:500px; 
height:200px; 
border:3px double #ccc; 
background-color:#FFFFFF; 
position:absolute; 
z-index:30; 
display:none; 
left:30%; 
top:30% 
} 
</style> 
<script type="text/javascript"> 

	var handle;
	function start() {
		var obj = document.getElementById("tip");
		if (parseInt(obj.style.height) == 0) {
			obj.style.display = "block";
			handle = setInterval("changeH('up')", 2);
		} else {
			handle = setInterval("changeH('down')", 2)
		}
	}
	function changeH(str) {
		var obj = document.getElementById("tip");
		if (str == "up") {
			if (parseInt(obj.style.height) > 200)
				clearInterval(handle);
			else
				obj.style.height = (parseInt(obj.style.height) + 8).toString()
						+ "px";
		}
		if (str == "down") {
			if (parseInt(obj.style.height) < 8) {
				clearInterval(handle);
				obj.style.display = "none";
			} else
				obj.style.height = (parseInt(obj.style.height) - 8).toString()
						+ "px";
		}
	}
	function showwin() {
		document.getElementsByTagName("html")[0].style.overflow = "hidden";
		start();
		document.getElementById("shadow").style.display = "block";
		document.getElementById("detail").style.display = "block";
	}
	function recover() {
		document.getElementsByTagName("html")[0].style.overflow = "auto";
		document.getElementById("shadow").style.display = "none";
		document.getElementById("detail").style.display = "none";
	}
</script> 
<script type="text/javascript">

	var contextPath = "<%=contextPath %>";
	
	function getTab(obj,fl){  
		var menuId = obj.getAttribute("menuId");
		var menuUrl = obj.getAttribute("menuUrl");
		var menuName = obj.getAttribute("menuName");
	    top.test(menuId,menuUrl,fl,menuName);
	}
	
	function outimg(imgname,imgid){
		if(imgname == "仪表盘"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-16.png";
		}else if(imgname == "计划"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-4.png";
		}else if(imgname == "选型"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-9.png";
		}else if(imgname == "技术改造"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-26.png";
		}else if(imgname == "采购"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-24.png";
		}else if(imgname == "验收"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-10.png";
		}else if(imgname == "转资"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-22.png";
		}else if(imgname == "使用"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-2.png";
		}else if(imgname == "维修"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-5.png";
		}else if(imgname == "报废处置"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-12.png";
		}else if(imgname == "考核"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-25.png";
		}else if(imgname == "体系管理"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-27.png";
		}else if(imgname == "设备管理"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-28.png";
		}else if(imgname == "统计分析"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-29.png";
		}
	}
	function overimg(imgname,imgid){
		if(imgname == "仪表盘"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-16+.png";
		}else if(imgname == "计划"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-4+.png";
		}else if(imgname == "选型"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-9+.png";
		}else if(imgname == "技术改造"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-26+.png";
		}else if(imgname == "采购"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-24+.png";
		}else if(imgname == "验收"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-10+.png";
		}else if(imgname == "转资"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-22+.png";
		}else if(imgname == "使用"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-2+.png";
		}else if(imgname == "维修"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-5+.png";
		}else if(imgname == "报废处置"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-12+.png";
		}else if(imgname == "考核"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-25+.png";
		}else if(imgname == "体系管理"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-27+.png";
		}else if(imgname == "设备管理"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-28+.png";
		}else if(imgname == "统计分析"){
			document.getElementById(imgid).src= contextPath +"/css/dms_home/images/menu-29+.png";
		}
	}
</script>
</head>
<body style="background-color: #F1F4F9" onload="document.getElementById('tip').style.height='0px';myTimer();">
	<td width="234" align="center" valign="top" class="yinying"><table width="234" border="0" cellspacing="0" cellpadding="0">
      <!-- <tr>
        <td height="12" background="<%=contextPath%>/css/dms_home/images/yinying.png" class="yinying"></td>
      </tr> -->
      <tr><!-- 685 更换成  985-->
        <td><table width="213" height="685" align="center" class="youlan" ><tr><td valign="top"><table width="213" height="auto" align="center" cellspacing="9"  >
          <tr>
            <td colspan="2" class="daohangcaidan">导航菜单</td>
          </tr>
          <%
			for(int i=0; i<menus.size();i= i+2){
			%>
	      <tr>
	      	<%if(i<menus.size()){
	      		MsgElement menu = menus.get(i); 
		    	
				String id = menu.getValue("id");
				if("INIT_AUTH_MENU_012345678900001,8ad878dd399bab3d0139ae1c09700647".indexOf(id)>-1) continue;
				
				String name = menu.getValue("name");				
				String url = "about:blank";
				if("C105".equals(user.getSubOrgIDofAffordOrg())){
					String t = menu.getValue("url");
					if(t==null || "".equals(t) || "null".equals(t)){
						url = "about:blank";
					}else{
						url = contextPath + t;
					}
				}
				//String text = "";
				if("仪表盘".equals(name)){
					url = contextPath + menu.getValue("url");
					//text = "&nbsp;<img src='"+contextPath+"/images/arrow_02.png' width='6' height='6'></img>";
				}
				
				String ptoto = "";
				if("仪表盘".equals(name)){
					ptoto = contextPath + "/css/dms_home/images/menu-16.png";
				}else if("计划".equals(name)){
					ptoto = contextPath + "/css/dms_home/images/menu-4.png";
				}else if("选型".equals(name)){
					ptoto = contextPath + "/css/dms_home/images/menu-9.png";
				}else if("技术改造".equals(name)){
					ptoto = contextPath + "/css/dms_home/images/menu-26.png";
				}else if("采购".equals(name)){
					ptoto = contextPath + "/css/dms_home/images/menu-24.png";
				}else if("验收".equals(name)){
					ptoto = contextPath + "/css/dms_home/images/menu-10.png";
				}else if("转资".equals(name)){
					ptoto = contextPath + "/css/dms_home/images/menu-22.png";
				}else if("使用".equals(name)){
					ptoto = contextPath + "/css/dms_home/images/menu-2.png";
				}else if("维修".equals(name)){
					ptoto = contextPath + "/css/dms_home/images/menu-5.png";
				}else if("报废处置".equals(name)){
					ptoto = contextPath + "/css/dms_home/images/menu-12.png";
				}else if("考核".equals(name)){
					ptoto = contextPath + "/css/dms_home/images/menu-25.png";
				}else if("体系管理".equals(name)){
					ptoto = contextPath + "/css/dms_home/images/menu-27.png";
				}else if("设备管理".equals(name)){
					ptoto = contextPath + "/css/dms_home/images/menu-28.png";
				}else if("统计分析".equals(name)){
					ptoto = contextPath + "/css/dms_home/images/menu-29.png";
				}
			%>
		          <td width="92" height="73">
		          <table width="92" border="0" cellspacing="0" cellpadding="0">
		              <tr>
		                <td height="73" align="center" valign="middle" bgcolor="#F8F8F8">
		                	<a id="menu<%=i %>"  menuIndex="<%=i %>" menuName="<%=name %>" menuId="<%=id %>" menuUrl="<%=url %>" onclick="getTab(this,'0')">
		                		<img src="<%=ptoto%>"  onmouseout="outimg('<%=name %>','im<%=i %>');" onmouseover="overimg('<%=name %>','im<%=i %>');" id="im<%=i %>" border="0" /></a></td>
		              </tr>
		              <tr>
		                <td height="21" align="center" valign="middle">
		                	<a id="menu<%=i %>"  menuIndex="<%=i %>" menuName="<%=name %>" menuId="<%=id %>" menuUrl="<%=url %>" onclick="getTab(this,'0')" class="menu"><%=name%></a></td>
		              </tr>
		            </table></td>
		            <%} 
		      			if(i+1<menus.size()){
		      				 MsgElement menu1 = menus.get(i+1); 
		 	                String name1 = "";
		 	                String url1 = "";
		 	                //String text1 = "";
		 	                String ptoto1 = "";
		 	                String id1 = "";
		 	                if(menu1 !=null ){ 
		 					id1 = menu1.getValue("id");
		 					if("INIT_AUTH_MENU_012345678900001,8ad878dd399bab3d0139ae1c09700647".indexOf(id1)>-1) continue;
		 					
		 					 name1 = menu1.getValue("name");		 					
		 					 url1 = "about:blank";
		 					if("C105".equals(user.getSubOrgIDofAffordOrg())){
		 						String t = menu1.getValue("url");
		 						if(t==null || "".equals(t) || "null".equals(t)){
		 							url1 = "about:blank";
		 						}else{
		 							url1 = contextPath + t;
		 						}
		 					}
		 					
		 					if("仪表盘".equals(name1)){
		 						url1 = contextPath + menu1.getValue("url");
		 						//text1 = "&nbsp;<img src='"+contextPath+"/images/arrow_02.png' width='6' height='6'></img>";
		 					}		 					
		 					
		 					if("仪表盘".equals(name1)){
		 						ptoto1 = contextPath + "/css/dms_home/images/menu-16.png";
		 					}else if("计划".equals(name1)){
		 						ptoto1 = contextPath + "/css/dms_home/images/menu-4.png";
		 					}else if("选型".equals(name1)){
		 						ptoto1 = contextPath + "/css/dms_home/images/menu-9.png";
		 					}else if("技术改造".equals(name1)){
		 						ptoto1 = contextPath + "/css/dms_home/images/menu-26.png";
		 					}else if("采购".equals(name1)){
		 						ptoto1 = contextPath + "/css/dms_home/images/menu-24.png";
		 					}else if("验收".equals(name1)){
		 						ptoto1 = contextPath + "/css/dms_home/images/menu-10.png";
		 					}else if("转资".equals(name1)){
		 						ptoto1 = contextPath + "/css/dms_home/images/menu-22.png";
		 					}else if("使用".equals(name1)){
		 						ptoto1 = contextPath + "/css/dms_home/images/menu-2.png";
		 					}else if("维修".equals(name1)){
		 						ptoto1 = contextPath + "/css/dms_home/images/menu-5.png";
		 					}else if("报废处置".equals(name1)){
		 						ptoto1 = contextPath + "/css/dms_home/images/menu-12.png";
		 					}else if("考核".equals(name1)){
		 						ptoto1 = contextPath + "/css/dms_home/images/menu-25.png";
		 					}else if("体系管理".equals(name1)){
		 						ptoto1 = contextPath + "/css/dms_home/images/menu-27.png";
		 					}else if("设备管理".equals(name1)){
		 						ptoto1 = contextPath + "/css/dms_home/images/menu-28.png";
		 					}else if("统计分析".equals(name1)){
		 						ptoto1 = contextPath + "/css/dms_home/images/menu-29.png";
		 					}
		 	              }
		            %>
		            
		            <td width="92" height="73">
		          <table width="92" border="0" cellspacing="0" cellpadding="0">
		              <tr>
		                <td height="73" align="center" valign="middle" bgcolor="#F8F8F8">
		                	<a id="menu<%=i+1 %>"  menuIndex="<%=i+1 %>" menuName="<%=name1 %>" menuId="<%=id1 %>" menuUrl="<%=url1 %>" onclick="getTab(this,'0')">
		                		<img src="<%=ptoto1%>"  onmouseout="outimg('<%=name1 %>','im1<%=i+1 %>');" onmouseover="overimg('<%=name1 %>','im1<%=i+1 %>');" id="im1<%=i+1 %>"  border="0" /></a></td>
		              </tr>
		              <tr>
		                <td height="21" align="center" valign="middle">
		                	<a id="menu<%=i+1 %>"  menuIndex="<%=i+1 %>" menuName="<%=name1 %>" menuId="<%=id1 %>" menuUrl="<%=url1 %>" onclick="getTab(this,'0')" class="menu"><%=name1%></a></td>
		              </tr>
		            </table></td>
					<%}  %>
          		</tr>
          		<%
				} 
				%>
        </table></td></tr></table></td>
      </tr>
    </table></td>
    <div id="shadow"> </div> 
<div id="detail"> 
</div> 
<div id="tip">
</div> 
 </body>
</html>
<script language="JavaScript"> 
//window.addEventListener("onload", myTimer); //绑定到onload事件 
function myTimer() { 
	//查询该用户名下是否有待办信息
	var retObj = jcdpCallService("ScrapeSrvNew", "getScrapeInfoByEmployee", "");
	var retObj1= jcdpCallService("ScrapeSrvNew", "getDisposeInfoByEmployee", "");
	if((eval(retObj.num)+eval(retObj1.num))>0){
		var innerhtml ="<h1><a href='javascript:void(0)' onclick='start()'>X</a>您有"+(eval(retObj.num)+eval(retObj1.num))+"条待处理新消息</h1>";
		if(retObj.num>0){
			innerhtml +="<p><a href='javascript:void(0)' onclick='showwin(1)'>点击查看报废申请单("+retObj.num+")条</a></p>";
		}
		if(retObj1.num>0){
			innerhtml +="<p><a href='javascript:void(0)' onclick='showwin(2)'>点击查看处置结果单("+retObj1.num+")条</a></p>";
		}
		$("#tip").append(innerhtml);
		start(); 
	}
//window.setTimeout("myTimer()",6000);//设置循环时间 
} 
function showwin(type){
	if(type==1){
		popWindow('<%=contextPath%>/dmsManager/scrape/scrapeApplyListForEmp.jsp','','申请单查询');
	}
	if(type==2){
		popWindow('<%=contextPath%>/dmsManager/scrape/disposeResultListForEmp.jsp','','申请单查询');
	}
}
</script> 