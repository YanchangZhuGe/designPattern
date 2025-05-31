<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>

<%@ page import="com.bgp.mcs.service.ma.showMainFrame.util.MarketGetInfoUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>


<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
    List<MsgElement> list = resultMsg.getMsgElements("list");
    List<MsgElement> nextList = resultMsg.getMsgElements("nextList");
    
    String typeName=resultMsg.getValue("typeName");
    
    String headingInfo=resultMsg.getValue("headingInfo");
	String pageType=resultMsg.getValue("pageType");
    String typeId=resultMsg.getValue("typeId");
    System.out.println(typeId);
    
    String lastId = "";
    String nextId = "";
    String lastName = "";
    String nextName = "";
    if(typeId.equals("10301")){
    	lastId = "10301";
    	nextId = "10302";
    	lastName = "高层互访";
    	nextName = "市场活动";
    }else if(typeId.equals("10302")){
    	lastId = "10301";
    	nextId = "10302";
    	lastName = "高层互访";
    	nextName = "市场活动";
    }else if(typeId.equals("10304")){
    	lastId = "10304";
    	nextId = "10305";
    	lastName = "专题会议";
    	nextName = "客户沟通";
    }else if(typeId.equals("10305")){
    	lastId = "10304";
    	nextId = "10305";
    	lastName = "专题会议";
    	nextName = "客户沟通";
    }else if(typeId.equals("10306")){
    	lastId = "10306";
    	nextId = "10307";
    	lastName = "行业新闻";
    	nextName = "政经动态";
    }
    else if(typeId.equals("10307")){
    	lastId = "10306";
    	nextId = "10307";
    	lastName = "行业新闻";
    	nextName = "政经动态";
    }
   
	
    String totalRows=resultMsg.getValue("totalRows");
    String pageCount=resultMsg.getValue("pageCount");
    String pageSize=resultMsg.getValue("pageSize");
    String currentPage=resultMsg.getValue("currentPage");
    
  //树二级列表
	List<Map> twoList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("twoList"));
	Map mapTree = new HashMap();
	String codeList = "";
	for (int i = 0; twoList != null && i < twoList.size(); i++) {
		Map map = (Map) twoList.get(i);
		String code = (String) map.get("code");
		codeList += code + ",";
		List<Map> subList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("twoList" + code));
		mapTree.put("twoList" + code, subList);
	}
	if (codeList.length() > 1) {
		codeList = codeList.substring(0, codeList.length() - 1);
	}
	
	//叶子节点列表
	List<Map> leafList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("leafList"));
	Map mapLeaf=new HashMap();
	String leafStr="";
	for(int i=0;leafList!=null&&i<leafList.size();i++){
		Map map=(Map)leafList.get(i);
		String code=(String)map.get("code");
		leafStr += code + ",";
		List<Map> subList=MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("leafList"+code));
		mapLeaf.put("leafList"+code,subList);
	}
	if (leafStr.length() > 1) {
		leafStr = leafStr.substring(0, leafStr.length() - 1);
	}
	
	//处理logo域 二级菜单列表
	List<Map> sckfList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("sckfList"));
	List<Map> scglList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("scglList"));
	List<Map> ygsdtList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("ygsdtList"));
	List<Map> jzhbdtList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("jzhbdtList"));
	List<Map> tjfxList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("tjfxList"));
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/images/ma/style.css" />
<script type="text/javascript" src="<%=contextPath%>/images/ma/js/jquery-1.3.2.min.js"></script>
<script type="text/javascript">

	function changeDivStyle(id,typeName){
		if(id=="10303"){
			window.location.href="<%=contextPath%>/market/show/viewListTree.srq?typeId="+id+"&&typeName="+typeName+"&&pageType=sckf";		
		}else {
			window.location.href="<%=contextPath%>/market/show/viewListTreeSckf.srq?typeId="+id+"&&typeName="+typeName+"&&pageType=sckf";			
		}
	}
	
	function linkTwoListRight(typeId,typeName){
		window.location.href="<%=contextPath%>/market/show/viewList.srq?typeId="+typeId+"&&typeName="+typeName;	
	}
	
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
</script>
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
     	 	<li><a href="<%=contextPath%>/market/show/viewListTreeManage.srq?typeId=<%=code %>&&pageType=scgl&&typeName=<%=codeName %>&&threeTypeId=10401001"  class="arrow" target="_self"><%=codeName%></a></li>
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
     	 	<li><a href="<%=contextPath%>/market/show/showSecondPageLike.srq?pageType=<%=pageType%>&&typeName=公司简介&&typeId=<%=code %>&&headingInfo=油公司动态&&threeTypeId=10801006"  class="arrow" target="_self"><%=codeName%></a></li>
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
     	 	<li><a href="<%=contextPath%>/market/show/showSecondPageLike.srq?pageType=<%=pageType%>&&typeName=公司简介&&typeId=<%=code %>&&headingInfo=物探公司动态&&threeTypeId=10802006" class="arrow" target="_self"><%=codeName%></a></li>
     	 	<%} %>
	  	</ul>
  </li>
</ul>
  </div>
  <div id="list_div" style="float: right">
  	 <table width="100%" border="0" cellspacing="5" cellpadding="0">
  	 	<tr>
        <td>
        <div style="margin-left: 0px">
		    <div id="gl_news_mbx_fen" style="width: 330px">
		      <ul>
		        <li class="mleft"></li>
		        <li class="mbg" style="width: 315px"><span class="mbx_text"><%="10301".equals(typeId)||"10302".equals(typeId)?"高层互访":"10305".equals(typeId)||"10304".equals(typeId)?"专题会议":"行业新闻"  %></span><span class="more_text" style="margin-left: 215px;"><a href="javascript:linkTwoListRight('<%=lastId %>','<%=lastName%>')">MORE</a></span></li>
		        <li class="mright"></li>
		      </ul>
		    </div>
		    <div id="main_content_fen" style="width: 330px;height: 280px;margin-bottom: 12px">
		    	 <div id="infofen" style="width: 320px">
		          <div class="infNews" style="width: 320px;padding-top: 0px;margin-top: 5px;">
		            <div id="img1"></div>
		            <%
		         		if(list!=null && list.size()>0){
		         			for(int j=0;j<list.size();j++){
		         				Map map=list.get(j).toMap();
		         				String  infomationName=(String)map.get("infomationName");
		         				if(infomationName!=null&&!"".equals(infomationName)&&infomationName.length()>20){
		        					infomationName=infomationName.substring(0,20)+"...";
		        				}
		         	%>
		         	<div style="padding-bottom: 5px;padding-top: 5px;"><a style="width: 250px;" href="<%=contextPath %>/market/show/viewDetail.srq?id=<%=(String)map.get("infomationId") %>&&typeName=<%=typeName %>" target=_self><%=infomationName%></a><span class="time"><%=(String)map.get("releaseDate") %></span></div>
		         	<%
		         			}
		         		}
		         	%>
		            </div>
		        </div>
		    </div>
		  </div>
  		</td>
  		<td>
  		<div style="margin-right: 10px">
  			<div id="gl_news_mbx_fen">
		      <ul>
		        <li class="mleft"></li>
		        <li class="mbg"><span class="mbx_text"><%="10301".equals(typeId)||"10302".equals(typeId)?"市场活动":"10305".equals(typeId)||"10304".equals(typeId)?"客户沟通":"政经动态"  %></span><span class="more_text" style="margin-left: 215px;"><a href="javascript:linkTwoListRight('<%=nextId %>','<%=nextName%>')">MORE</a></span></li>
		        <li class="mright"></li>
		      </ul>
		    </div>
		    <div id="main_content_fen"  style="width: 330px;height: 280px;margin-bottom: 12px">
		    	 <div id="infofen">
		          <div class="infNews" style="width: 320px;padding-top: 0px;margin-top: 5px;">
		            <div id="img1"></div>
		            <%
		         		if(nextList!=null && nextList.size()>0){
		         			for(int j=0;j<nextList.size();j++){
		         				Map map=nextList.get(j).toMap();
		         				String  infomationName=(String)map.get("infomationName");
		         				if(infomationName!=null&&!"".equals(infomationName)&&infomationName.length()>20){
		        					infomationName=infomationName.substring(0,20)+"...";
		        				}
		         	%>
		         	<div style="padding-bottom: 5px;padding-top: 5px;"><a style="width: 250px;" href="<%=contextPath %>/market/show/viewDetail.srq?id=<%=(String)map.get("infomationId") %>&&typeName=<%=typeName %>" target=_self><%=infomationName%></a><span class="time"><%=(String)map.get("releaseDate") %></span></div>
		         	<%
		         			}
		         		}
		         	%>
		            </div>
		        </div>
		    </div>
		  </div>
  		</td>
  	</table>
  </div>
  <div id="right_div_left" style="width: 271px;float: left;margin-left: 8px">
    <div id="gl_left_head" style="width: 271px">
      <ul>
        <li class="mleft"></li>
        <li class="mbg" style="width: 223px"><span class="gl_mbx_text"><%=headingInfo%></span></li>
        <li class="mright"></li>
      </ul>
    </div>
    <div id="gl_left_botbox" style="width: 269px">
     <%
	for (int i = 0; twoList != null && i < twoList.size(); i++) {
		Map map = (Map) twoList.get(i);
		String code = (String) map.get("code");
		String codeName = (String) map.get("codeName");
		String oneClass="notNews";
		if(code.equals(typeId)){
			oneClass="sel_notNews";
		}
	%>
		<div class="<%=oneClass %>" style="width: 265px"><a href="javascript:changeDivStyle('<%=code%>','<%=codeName%>')"><%=codeName%></a></div>
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
