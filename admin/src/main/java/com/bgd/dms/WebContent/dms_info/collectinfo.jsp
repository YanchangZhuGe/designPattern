<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg,com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*,com.cnpc.jcdp.soa.msg.ISrvMsg,com.cnpc.jcdp.soa.msg.MsgElement,com.cnpc.jcdp.webapp.util.MVCConstants,com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.webapp.constant.MVCConstant"%>
<%
  UserToken user = OMSMVCUtil.getUserToken(request);
  if(user==null){
	  request.getRequestDispatcher("login.jsp").forward(request, response);
	  return;
  }
  response.setContentType("text/html;charset=utf-8");
  String contextPath = request.getContextPath();
  String userOrgId = user.getOrgId();
  System.out.println("userOrgId == "+userOrgId);
  
 
  ISrvMsg msg = (ISrvMsg) request.getAttribute(MVCConstant.RESPONSE_DTO);
  
  List<MsgElement> links = msg.getMsgElements("links");
  
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/dms_home/home.css"/>
<title>设备寿命周期管理平台</title>
   <style type="text/css">
	html,body { height:100%; margin:0; overflow-y:hidden;}
	</style>
	<style type="text/css">
	html,body { height:100%; margin:0;overflow-x:hidden}
	</style> 
	<style type="text/css">
	.left-img{float:left; position:fixed; top:20px; left:93px;}
	</style>
<script type="text/javascript">

	var contextPath = "<%=contextPath %>";
	
	function getTab(obj,fl){  
		var menuId = obj.getAttribute("menuId");
		var menuUrl = obj.getAttribute("menuUrl");
		var menuName = obj.getAttribute("menuName");
		
	    top.testColl(menuId,menuUrl,fl,menuName,'yes');
	}
	function selectMenuTree(){
		popWindow('<%=contextPath%>/ibp/auth2/menu/collectionMenu.jsp');
	}
</script>
</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr>
    <td width="122" valign="top" bgcolor="#4197d3" height="100%">
    <div class="wodeshoucang">我的收藏   	
		<span style="cursor: pointer;"><img src="<%=contextPath %>/css/dms_home/images/shoucangxing1.png" class="left-img" style="width:22px;height:27px;"  onclick="selectMenuTree()"  border="0" />
       </span></div>
		<div class="shoucangqu">
		
		<%if(links!=null) {for(int i=0;i<links.size();i++) {
			if(i<links.size()){
	      		MsgElement menu = links.get(i); 
	      		String menu_id = menu.getValue("menu_id");
	      		String menu_name = menu.getValue("menu_c_name");
	      		String url = menu.getValue("menu_url");
	      		url=contextPath+url;
		%>
			<div class="shoucangxiang">
				<a href="####" class="shoucang" menuName="<%=menu_name %>" menuId="<%=menu_id %>" menuUrl="<%=url %>" onclick="getTab(this,'0')"><%=menu_name %></a>
			</div>
			<%}}}else { %>
			<div class="shoucangxiang">
				<a href="####" class="shoucang" menuName="测试收藏" menuId="8ad891104c7dfa85014c7e034ab60008" menuUrl="/dmsManager/assessment/assessManage/assessIndicatorsList.jsp" onclick="getTab(this,'0')">设备台账</a>
			</div>
			<div class="shoucangxiang">
				<a href="####" class="shoucang" menuName="测试收藏1" menuId="8ad891104c7dfa85014c7e15dcaf0023" menuUrl="<%=contextPath %>/dmsManager/device/devAWhl.jsp" onclick="getTab(this,'0')">设备完好率</a>
			</div>
			<div class="shoucangxiang">
				<a href="####" class="shoucang" menuName="测试收藏2" menuId="8ad891104c7dfa85014c7e1599690022" menuUrl="<%=contextPath %>/dmsManager/device/deviceUseRate.jsp" onclick="getTab(this,'0')">设备利用率</a>
			</div>
			<%} %>
	    </div>
    </td>
  </tr>
</table>
</body>
</html>
