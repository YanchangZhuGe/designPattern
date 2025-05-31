<%@page import="com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider"%>
<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil,com.cnpc.jcdp.webapp.util.JcdpMVCUtil"%>
<%@page import="java.util.*,com.cnpc.jcdp.soa.msg.ISrvMsg,com.cnpc.jcdp.soa.msg.MsgElement,com.cnpc.jcdp.webapp.util.MVCConstants"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
  response.setContentType("text/html;charset=utf-8");
  String contextPath = request.getContextPath();
  UserToken user = OMSMVCUtil.getUserToken(request);
  String userName = user==null ? "" : user.getUserName();
  String projectName = "选择项目";
  String allProjectName = "单击选择项目";
  String projectSelected = "false";
  String isDashbord=user.getIsDashbord();
  boolean is_children = false;
  if(user != null && user.getProjectName() !=null && !"".equals(user.getProjectName())){

	  projectName = user.getProjectName();
	  allProjectName = projectName;
	  if(projectName.length() > 16) {
		  projectName = projectName.substring(0, 16)+"...";
	  }
	  is_children = OPCommonUtil.isChildren(user.getProjectInfoNo(),user.getProjectType());//当前的项目是不是子项目，是子项目则隐藏经营管理	  
	  projectSelected = "true";
  }

  ISrvMsg responseDTO = (ISrvMsg)request.getAttribute("responseDTO");
  
  List<MsgElement> menus = responseDTO.getMsgElements("nodes");
  //加入对监测系统跳转链接的支持
  Object pss_flg = request.getSession().getAttribute("pss_flg");
  Object menu_flg = request.getSession().getAttribute("menu_flg");
  String pss_menu1l = "";//一级菜单
  String pss_menu2l = "";//二级
  String pss_menu3l = "";//三级
  String pss_menu4l = "";//四级
  if(pss_flg!=null && ((String)pss_flg).equals("psssysflg")){
	pss_menu1l = request.getSession().getAttribute("menu1l")!=null?(String)(request.getSession().getAttribute("menu1l")):"";
	pss_menu2l = request.getSession().getAttribute("menu2l")!=null?(String)(request.getSession().getAttribute("menu2l")):"";
	pss_menu3l = request.getSession().getAttribute("menu3l")!=null?(String)(request.getSession().getAttribute("menu3l")):"";
	pss_menu4l = request.getSession().getAttribute("menu4l")!=null?(String)(request.getSession().getAttribute("menu4l")):"";
	
	request.getSession().removeAttribute("menu1l");
	request.getSession().removeAttribute("menu2l");
	request.getSession().removeAttribute("menu3l");
	request.getSession().removeAttribute("menu4l");
  }
  //清理session
  request.getSession().removeAttribute("pss_flg");
  //request.getSession().removeAttribute("menu_flg");
  
  
  //String path = request.getContextPath();
  String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+contextPath+"/"; 
  
  String logoutReturnUrl = java.net.URLEncoder.encode(basePath+"index1.jsp","UTF-8");

%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/styles/style.css"/>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/dms_home/home.css"/>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/styles/SpryTabbedPanels.css"/>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/adapter/ext/ext-base.js"></script> 
<script type="text/javascript" src="<%=contextPath %>/js/extjs/ext-all.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
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
#help_detail {
    line-height: 22px;  list-style-type: none;text-align:left;
 	width: 80px; position: absolute; z-index: 2;top:10px;right:3px;
}
#help_detail li {
 float: left; width: 80px;
 background: #70B5E8; 
 border-bottom: 1px solid #8FC6EF;
 line-height: 22px;
 height: 22px;
}
#help_detail a{
 text-align:left;padding-left:10px;
}
#help_detail a:link  {
 color:#fff; text-decoration:none;
 line-height: 22px;  
 height: 22px; 
}
#help_detail a:visited  {
 color:#666;text-decoration:none;line-height: 22px; height: 22px; 
}
#help_detail a:hover  {
 color:#F3F3F3;text-decoration:none;font-weight:normal;
 background:#58ACEA;width: 58px; line-height: 22px; height: 22px;
}
.sfhover{

}
</style>
<script type=text/javascript>

function menuFix() {
 var nav_help = document.getElementById("nav_help");
 nav_help.onmouseover=function() {
	 document.getElementById("help_detail").style.display = 'block';
	 var sfEls = document.getElementById("help_detail").getElementsByTagName("li");
	 for (var i=0; i<sfEls.length; i++) {
		 sfEls[i].className = "sfhover";
	 }
 }
 /* var help_detail = document.getElementById("nav_help"); */
 nav_help.onmouseout=function() {
	 document.getElementById("help_detail").style.display = 'none';
	 var sfEls = document.getElementById("help_detail").getElementsByTagName("li");
	 for (var i=0; i<sfEls.length; i++) {
		 sfEls[i].className = "";
	 }
 }
}
window.onload=menuFix;
</script>
</head>
<body style="background-color: #fff">
<div class="head_bg">
    <div id="dmshead">
      <div id="inf" style="width: 600px;">
          <ul id="breadcrumb">	        	
	        <li><a href="<%=contextPath %>/logout.jsp?logoutReturnUrl=<%=logoutReturnUrl%>" target="_top">
	        	<input type="image" src="<%=contextPath %>/css/dms_home/images/ico-zhuxiao.png" width="22" height="22" />注销</a></li>	        		        
	        <li id="nav_help"><a href="#" ><input type="image" onclick="openHelp();" src="<%=contextPath %>/css/dms_home/images/ico-bangzhu.png" width="22" height="22" />帮助</a>
	        <ul id="help_detail" style="display: none;margin-top: 5px;" onclick="openHelp();">
			 <li><a href="#" onclick="openHelp();" onclick="proficientSystem();">专家支持</a></li> 
			 </ul>
	        </li>	        
	        <li><a href="<%=contextPath %>/blank.htm" onclick="showAdminMenu()" target="list" >
	        	<input type="image" src="<%=contextPath %>/css/dms_home/images/ico-guanli.png" width="20" height="20" />管理</a>
	        </li>	        
	        <li><a id="menu0" href="#" menuIndex="0" menuName="仪表盘" menuId="40288a8138dfbe030138dfc0159a0002" menuUrl="<%=contextPath %>/dashboard/new.jsp" onclick="getTab(this,'0')"  >
	        	<input type="image" src="<%=contextPath %>/css/dms_home/images/ico-yibiaoshezhi.png" width="22" height="22" />仪表盘&nbsp;<img src='<%=contextPath %>/images/arrow_02.png' width='6' height='6'></img></a>
	        </li>	        	        
	        <li><a href="#" onclick="backIndexPage()" >
	        	<input type="image" src="<%=contextPath %>/css/dms_home/images/ico-home.png" width="20" height="20" />主页</a></li>	        
	        <li><span class="inf_text_n">欢迎:</span><a href="#"><%=userName%></a></li>
	      </ul>		   
      </div>
    </div>	 
  </div>
<script type="text/javascript">
var pss_flg = "<%=pss_flg%>";
var menu_flg = "<%=menu_flg%>";

function backIndexPage(){
	preIsDashBoard = false;
	window.parent.indexPage('<%=contextPath%>/dms_info/index_info.jsp'); 
}
var menu_id_tree = null;
	// gms系统添加

	var selectedTag=null;
	var selectedIndex='<%=request.getParameter("index")%>';
	if(selectedIndex=='null')selectedIndex=0;
	var preIsDashBoard = false;
	var isDashbord='<%=isDashbord%>';
	
	//参数fl为1时，可根据参数自动定位菜单，为0时默认等待用户操作
	function getTab(obj,fl) {
		if(selectedTag!=null){
			selectedTag.className ="";
		}
		menu_id_tree = obj.getAttribute("menuId");
		selectedTag = obj.parentElement;
		selectedTag.className ="selectTag";
		//parent.frames["fourthMenuFrame"].clearFourthMenu();
		if(obj.getAttribute("menuName")!="仪表盘"){ 
			parent.showLeftMenu();
			if(fl=='1'){
				//延时，等待页面加载完成
				setTimeout(function(){parent.frames["navFrame"].loadData(obj.getAttribute("menuId"),'<%=pss_menu2l%>','<%=pss_menu3l%>','<%=pss_menu4l%>',fl);},1500);
			}else{
				parent.frames["navFrame"].loadData(obj.getAttribute("menuId"),'<%=pss_menu2l%>','<%=pss_menu3l%>','<%=pss_menu4l%>',fl);
			}

			parent.frames["navHidBtn"].location.reload(true);
			preIsDashBoard = false;
		}else{
			if(preIsDashBoard){
				top[1].showToolbar();
				return;
			}
			preIsDashBoard = true;
		}
		if((menu_flg=='null' || !menu_flg || menu_flg=='2')){
			if(isDashbord=="1"){
				top[1].location = obj.getAttribute("menuUrl");
			}
		}
	}

	function displayMenu(){
	    $("#tag-container").css("display","block");
	}
	
	var projectSelected=<%=projectSelected%>;

	function selectProject(){
		popWindow('<%=contextPath%>/pm/project/multiProject/selectProject.jsp?backUrl=/pm/project/multiProject/projectList.jsp&action=view','800:600');
	}

	function setProject(longName, name){
		document.getElementById('projectName').innerHTML='<a href="#"  onclick="selectProject();" title="'+longName+'"><span style="font-family:verdana;color:red">'+name+'</span></a>';
		projectSelected=true;
	}

	function showAdminMenu(){ 
		window.parent.test("INIT_AUTH_MENU_012345678900001",'<%=request.getContextPath()%>/blank.htm',"0"); 
	}

	function popWindow(url,size){
		var sFeature = 'status=yes,toolbar=no,menubar=no,location=no';
		if(size==undefined) size = appConfig.popSize;
		if(size!=undefined){
			var strs = size.split(":");
			sFeature += ",width="+strs[0];
			if(strs.length==2) sFeature += ",height="+strs[1];		
		}

		if(url.indexOf('?')<=0) url += '?';
		else url += '&';
		url += 'popSize='+size;
		window.open(url,null,sFeature);
	}		 
</script>
<script language="JavaScript">
//禁止F5刷新
document.onkeydown=function keydown() {
  var ev = window.event ;
  var code = ev.keyCode || ev.which;
  if (code == 116) {
      ev.keyCode ? ev.keyCode = 0 : ev.which = 0;
      cancelBubble = true;
      return false;
  }
}       
window.onbeforeunload = function() //author: meizz    
{
	 //获取事件鼠标的位置
     var n = window.event.screenX - window.screenLeft;
     //获取浏览器界面可活动的窗口宽度（20是右上角关闭按钮的宽度）
     var b = n > document.documentElement.scrollWidth-20;    
     //window.event.clientY表示事件的y值（鼠标）
     //window.event.altKey表示是否按下列alt键（alt+F4）
     //window.event.clientY < 0表示鼠标已经离开了document的区域
     if(!b && window.event.clientY < 0 || window.event.altKey)    {
	       var flag = confirm("你确定关闭系统?");
	       if(flag){
		        top.location.href = "<%=contextPath%>/logout.jsp";		       
	       }else{
		       return false;
	       }	       
     }    
}
 
    //禁止右键弹出菜单  
 document.oncontextmenu =function  oncontextmenu()  
{         return   false;   }  
 
function proficientSystem(){
	window.parent.frames["list"].popWindow("<%=contextPath%>/ess.jsp?stats=0",'954:700');
} 
function openHelp(){
	window.open ('<%=contextPath%>/help/help_main.jsp','newwindow','menubar,scrollbars=yes,resizable=yes,height=400,width=400,status=yes,toolbar=no,menubar=no,location=no') 
}
</script>
</body>
</html>

