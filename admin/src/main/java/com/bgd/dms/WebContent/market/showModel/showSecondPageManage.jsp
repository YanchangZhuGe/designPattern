<%@ page  contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.bgp.mcs.service.ma.showMainFrame.util.MarketGetInfoUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
	String contextPath = request.getContextPath();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName=user.getUserName();
	Map mapOrg = new HashMap();
	if(resultMsg.getMsgElement("mapOrg")!=null){
		mapOrg = resultMsg.getMsgElement("mapOrg").toMap();
	}
	List listOrg = new ArrayList();
	if(MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("listOrg"))!=null){
		listOrg = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("listOrg"));
	}
	
	String content = resultMsg.getValue("content");
	String pageType=resultMsg.getValue("pageType");
	String typeId=resultMsg.getValue("typeId");
	String typeName=resultMsg.getValue("typeName");
	String threeTypeId = resultMsg.getValue("threeTypeId");
	
	//树二级列表

	//处理logo域 二级菜单列表
	List<Map> sckfList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("sckfList"));
	List<Map> scglList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("scglList"));
	List<Map> ygsdtList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("ygsdtList"));
	List<Map> jzhbdtList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("jzhbdtList"));
	List<Map> tjfxList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("tjfxList"));
	List<Map> secondOrgList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("secondOrgList"));
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/images/ma/style.css" />
<script type="text/javascript" src="<%=contextPath%>/images/ma/js/jquery-1.3.2.min.js"></script>
<script type="text/javascript">
	function changeMainFrameDown(info){
		if(info=="sy"){
			window.location.href="<%=contextPath%>/market/show/showHomePage.srq";	
		}else if(info=="tjfx"){
			window.location.href="<%=contextPath%>/market/show/viewListTree.srq?typeId=10201001&&typeName=市场落实价值工作量&&pageType="+info;
		}else if(info=="sckf"){
			window.location.href="<%=contextPath%>/market/show/viewListTreeSckf.srq?pageType="+info;
		}else if(info=="scgl"){
			window.location.href="<%=contextPath%>/market/show/viewListTreeManage.srq?typeId=10401&&pageType=scgl&&typeName=组织机构&&threeTypeId=10401001";
		}else if(info=="ygsdt"){
			window.location.href="<%=contextPath%>/market/show/showSecondPageLike.srq?pageType=<%=pageType%>&&typeName=公司简介&&typeId=10501001&&headingInfo=油公司动态&&threeTypeId=10801006";
		}else if(info=="jzhbdt"){
			window.location.href="<%=contextPath%>/market/show/showSecondPageLike.srq?pageType=<%=pageType%>&&typeName=公司简介&&typeId=10601001&&headingInfo=物探公司动态&&threeTypeId=10802006";
		}
	}
	function linkTwoList(typeId,typeName,threeTypeId){
		window.location.href="<%=contextPath%>/market/show/viewListMore.srq?typeId="+typeId+"&&typeName="+typeName+"&&orgId="+threeTypeId;	
	}
	
	function linkThirdList(threeTypeId,typeId,typeName){
		window.location.href="<%=contextPath%>/market/show/viewListTreeManage.srq?typeName="+typeName+"&&typeId="+typeId+"&&threeTypeId="+threeTypeId;
	}
	
	
	$(function(){
		 $('#webmenu li').hover(function(){
		  $(this).children('ul').stop(true,true).show();
		 },function(){
		  $(this).children('ul').stop(true,true).hide();
		 });
		 
		 $('#webmenu li').hover(function(){
		  $(this).children('div').stop(true,true).show();
		 },function(){
		  $(this).children('div').stop(true,true).hide();
		 });
		});

	$(function(){
		$("#list_div").css("height","440px");
	});
</script>
<title>市场信息平台</title>
</head>
<body onload="showtime()">
<div id="mbody">
<div id="head_fl">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="112" valign="top"><img src="<%=contextPath%>/images/ma/sc3_01.png" width="112" height="109" /></td>
    <td width="348" valign="top"><img src="<%=contextPath%>/images/ma/sc3_02.png" width="348" height="109" /></td>
    <td valign="top">
	    <table width="100%" border="0" cellspacing="0" cellpadding="0">
	      <tr>
	        <td align="right" style="background:url(<%=contextPath%>/images/ma/sc3_03.png) no-repeat; width:540px; height:23px; text-align:right; padding-right:20px;" class="data_text"><span class="date_text" id="time"></span></td>
	      </tr>
	      <tr>
	        <td>
	        	<img src="<%=contextPath%>/images/ma/sc3_04.gif" width="540" height="86" />
	       </td>
	      </tr>
	    </table>
    </td>
    </tr>
</table>

  </div>
  <div id="nav">
  <ul id="webmenu" class="first-menu">
  <li><a id="sy" <%if("sy".equals(pageType)){ %>class="select"<%} %> href="javascript: changeMainFrameDown('sy');" style="width:125px;"  target="_self">首页</a></li>
  <li><a id="tjfx" <%if("tjfx".equals(pageType)){ %>class="select"<%} %> href="javascript: changeMainFrameDown('tjfx');" style="width:126px;" target="_self">统计分析</a>
   		<ul  style="display: none;" id="subMusic" class="second-menu">
     	 	<% for(int i=0;tjfxList!=null&&i<tjfxList.size();i++) {
     	 		Map mapLogo=tjfxList.get(i);
     	 		String code=(String)mapLogo.get("code");
     	 		String codeName=(String)mapLogo.get("codeName");
     	 		if(code.equals("10203")){
     	     %>
     	     <li><a href="<%=contextPath%>/market/show/viewListTreeFen.srq?typeId=<%=code %>&&typeName=<%=codeName%>&&pageType=tjfx" class="arrow" target="_self"><%=codeName%></a></li>
     	     <%}else{ %>
     	     <li><a href="<%=contextPath%>/market/show/viewListTree.srq?typeId=<%=code %>&&typeName=<%=codeName%>&&pageType=tjfx" class="arrow" target="_self"><%=codeName%></a></li>
     	     <%} 
     	     }%>
	  	</ul>
  </li>
  <li><a id="sckf" <%if("sckf".equals(pageType)){ %>class="select"<%} %> href="javascript: changeMainFrameDown('sckf');" style="width:126px;" target="_self">市场开发</a>
    <ul  style="display: none;" id="subMusic" class="second-menu">
     	 	<% for(int i=0;sckfList!=null&&i<sckfList.size();i++) {
     	 		Map mapLogo=sckfList.get(i);
     	 		String code=(String)mapLogo.get("code");
     	 		String codeName=(String)mapLogo.get("codeName");
     	 		if(code.equals("10303")){
     	 	%>
     	 	<li><a href="<%=contextPath%>/market/show/viewListTree.srq?typeId=<%=code %>&&typeName=<%=codeName%>&&pageType=sckf"  class="arrow" target="_self"><%=codeName%></a></li>
     	 	<%}else{ %>
     	 	<li><a href="<%=contextPath%>/market/show/viewListTreeSckf.srq?typeId=<%=code %>&&typeName=<%=codeName%>&&pageType=sckf"  class="arrow" target="_self"><%=codeName%></a></li>
     	 	<%} 
     	 	}%>
	  	</ul>
  </li>
  <li><a id="scgl" <%if("scgl".equals(pageType)){ %>class="select"<%} %> href="javascript: changeMainFrameDown('scgl');" style="width:126px;" class="arrow" target="_self">市场管理</a>
    <ul  style="display: none;" id="subMusic" class="second-menu">
     	 	<% for(int i=0;scglList!=null&&i<scglList.size();i++) {
     	 		Map mapLogo=scglList.get(i);
     	 		String code=(String)mapLogo.get("code");
     	 		String codeName=(String)mapLogo.get("codeName");
     	 	%>
     	 	<li><a href="<%=contextPath%>/market/show/viewListTreeManage.srq?typeId=<%=code %>&&pageType=scgl&&typeName=<%=codeName %>&&threeTypeId=10401001" class="arrow" target="_self"><%=codeName%></a></li>
     	 	<%} %>
	  	</ul>
  </li>
    <li><a id="ygsdt" <%if("ygsdt".equals(pageType)){ %>class="select"<%} %> href="javascript: changeMainFrameDown('ygsdt');" style="width:126px;" class="arrow" target="_self">油公司信息</a>
    <ul  style="display: none;" id="subMusic" class="second-menu">
     	 	<% for(int i=0;ygsdtList!=null&&i<ygsdtList.size();i++) {
     	 		Map mapLogo=ygsdtList.get(i);
     	 		String code=(String)mapLogo.get("code");
     	 		String codeName=(String)mapLogo.get("codeName");
     	 	%>
     	 	<li><a href="<%=contextPath%>/market/show/showSecondPageLike.srq?pageType=<%=pageType%>&&typeName=公司简介&&typeId=<%=code %>&&headingInfo=油公司动态&&threeTypeId=10801006" class="arrow" target="_self"><%=codeName%></a></li>
     	 	<%} %>
	  	</ul>
  </li>
  <li><a id="jzhbdt" <%if("jzhbdt".equals(pageType)){ %>class="select"<%} %> href="javascript: changeMainFrameDown('jzhbdt');" style="width:126px; border-right:none;" class="arrow" target="_self">物探公司信息</a>
   <ul  style="display: none;" id="subMusic" class="second-menu">
     	 	<% for(int i=0;jzhbdtList!=null&&i<jzhbdtList.size();i++) {
     	 		Map mapLogo=jzhbdtList.get(i);
     	 		String code=(String)mapLogo.get("code");
     	 		String codeName=(String)mapLogo.get("codeName");
     	 	%>
     	 	<li><a href="<%=contextPath%>/market/show/showSecondPageLike.srq?pageType=<%=pageType%>&&typeName=公司简介&&typeId=<%=code %>&&headingInfo=物探公司动态&&threeTypeId=10802006"  class="arrow" target="_self"><%=codeName%></a></li>
     	 	<%} %>
	  	</ul>
  </li>
</ul>
  </div>
  <div id="list_div"  style="width: 784px">
   <table width="100%" border="0" cellspacing="0" cellpadding="0" >
      <tr>
        <td width="182" valign="top">
         <div id="right_div" style="padding-top: 0px;margin-left: 15px">
         <div style="width: 162px;float:left;">
	     <div id="gl_left_head" style="width: 165px">
	      	<ul>
	        	<li class="mleft"></li>
	        	<li class="mbg" style="width: 117px"><span class="gl_mbx_text">市场管理</span></li>
	        	<li class="mright"></li>
	      	</ul>
	     </div>
    		<div id="gl_left_botbox_short">
    		<%
				for (int j = 0; scglList != null && j < scglList.size(); j++) {
						Map subMap = (Map) scglList.get(j);
						String subCode = (String) subMap.get("code");
						String subCodeName = (String) subMap.get("codeName");
			%>
			<div  <%if(typeId.equals(subCode)){%>class="sel_notNews_short"<%}else{ %>class="notNews_short"<%} %>><a href="javascript:linkThirdList('<%=threeTypeId %>','<%=subCode%>','<%=subCodeName%>')"><%=subCodeName%></a></div>
			<%}%>
			</div>
			</div>
    	</div>
    	</div>
  		</td>
  	 <td valign="top" align="left" height="780px">
  	 <div id="gl_news_mbx_fen2" style="margin-left: 10px;width: 580px">
        <ul>
          <li class="mleft"></li>
          <%if(typeId.equals("10401")||typeId.equals("10406")){ %>
          <li class="mbg" style="width: 565px"><span class="mbx_text"><%=typeName %></span></li>
          <%}else{ %>
          <li class="mbg" style="width: 565px"><span class="mbx_text"><%=typeName %></span><span class="more_text" style="margin-left: 460px;"><a href="javascript:linkTwoList('<%=typeId %>','<%=typeName%>','<%=threeTypeId%>')">MORE</a></span></li>
          <%} %>
          <li class="mright"></li>
        </ul>
    </div>
   <div style="display: block">
    <div id="main_content_fen2" style="overflow-x:hidden;height: 365px;width: 580px;border:1px #e2e2e2 solid;margin-left: 9px">
    	<div id="infofen2" style="width: 580px;height:350px;padding-left: 0px;padding-top: 0px">
    	<div class="infNews" style="width: 580px;padding-top: 0px;margin-top: 5px;">
    	<% if(typeId.equals("10401")||typeId.equals("10406")){%>
    		<div style="width: 580px;height: 350px"> 
    		<%=content %>
    		</div>
    	<%}else{ 
    		for(int i=0;i<listOrg.size();i++){
    			Map map = (Map)listOrg.get(i);
    			String infomationId = (String)map.get("infomationId");
    			String name = (String)map.get("infomationName");
    			System.out.println(name);
    			String releaseDate = (String)map.get("releaseDate");
    	%>
    			<div style="padding-bottom: 5px;padding-top: 5px;"><a style="width: 460px;" href="<%=contextPath %>/market/show/viewDetail.srq?id=<%=infomationId %>&&typeName=<%=typeName %>" target=_self><%=name%></a><span class="time"><%=releaseDate%>&nbsp;&nbsp;&nbsp;&nbsp;</span></div>
    	<%}
    	} %>
    	</div>
    </div>
    </div>
    
    </td>
  </tr>
    </table>
  </div>
  <div id="right_div" style="width: 200px">
    <div id="gl_left_botbox">
    <div class="notNews" style="width: 200px"><a  style="width: 200px" href="javascript:linkThirdList('10401001','10401','组织机构')"><span class="mbx_text"><font color="black">东方地球物理公司</font></span></a></div>
			<%
				for (int j = 0; secondOrgList != null && j < secondOrgList.size(); j++) {
						Map subMap = (Map) secondOrgList.get(j);
						String subCode = (String) subMap.get("code");
						String subCodeName = (String) subMap.get("codeName");
						String twoClassSub="sub_notNews";
						if(subCode.equals(threeTypeId)){
							twoClassSub="sub_sel_notNews";
						}
			%>
			<div class="<%=twoClassSub %>"><a href="javascript:linkThirdList('<%=subCode%>','10401','组织机构')"><%=subCodeName%></a></div>
			<%
				}
			%>
		</div>
    </div>
    <div id="copy_div" class="copy_text" >
	<div class="copy_img"></div><a href="">版权所有：中国石油集团东方地球物理公司</a>
</div>
  </div>
  
</body>
</html>