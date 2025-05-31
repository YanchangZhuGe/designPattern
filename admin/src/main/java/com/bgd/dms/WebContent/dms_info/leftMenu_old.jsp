<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil"%>
<%@page import="java.util.*,com.cnpc.jcdp.soa.msg.ISrvMsg,com.cnpc.jcdp.soa.msg.MsgElement,com.cnpc.jcdp.webapp.util.MVCConstants,com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil,com.cnpc.jcdp.webapp.constant.MVCConstant"%>
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
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/dms_home/home.css"/>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/style.css"/>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
<link rel="stylesheet" href="<%=contextPath%>/js/extjs/resources/css/ext-all.css"/>
<title>设备寿命周期管理平台</title>
<style type="text/css">
	html,body { height:100%; margin:0; overflow-y:hidden;}
</style> 
<script type="text/javascript">

function getTab(obj,fl) {  
	var menuId = obj.getAttribute("menuId");
	var menuUrl = obj.getAttribute("menuUrl");
    top.test(menuId,menuUrl,fl);
}

</script>
</head>
<body >
	<td>
		<table width="213" align="center" cellspacing="9" class="youlan" >
          <tr>
            <td colspan="2" class="daohangcaidan">导航菜单</td>
          </tr>
          <tr>
			<ul id="tags">
				<%
				int menuIndex=0;
				int pssMenuIndex = 0;
				for(MsgElement menu : menus){
					String id = menu.getValue("id");
					System.out.println("id == "+id);
					if("INIT_AUTH_MENU_012345678900001,8ad878dd399bab3d0139ae1c09700647".indexOf(id)>-1) continue;
					
					String name = menu.getValue("name");
					System.out.println("name == "+name);
					if(name.equalsIgnoreCase(pss_menu1l)){
						pssMenuIndex = menuIndex;
					}
					
					String url = "about:blank";
					if("C105".equals(user.getSubOrgIDofAffordOrg())){
						String t = menu.getValue("url");
						if(t==null || "".equals(t) || "null".equals(t)){
							url = "about:blank";
						}else{
							url = contextPath + t;
						}
					}
					System.out.println("url == "+url);
					String text = "";
					if("仪表盘".equals(name)){
						url = contextPath + menu.getValue("url");
						System.out.println("url == "+url);
						text = "&nbsp;<img src='"+contextPath+"/images/arrow_02.png' width='6' height='6'></img>";
					}
				%>
					<li ><a id="menu<%=menuIndex %>" href="#" menuIndex="<%=menuIndex %>" menuName="<%=name %>" menuId="<%=id %>" menuUrl="<%=url %>" onclick="getTab(this,'0')"><%=name %><%=text %></a></li>
				<%
					menuIndex++;
				} 
				%>
			</ul>
		</tr>
	  </table>
   </td>
 </body>
</html>
