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
	String headingInfo=resultMsg.getValue("headingInfo");
	
	String pageType=resultMsg.getValue("pageType");
	String typeId=resultMsg.getValue("typeId");
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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" src="<%=contextPath%>/images/ma/js/jquery-1.3.2.min.js"></script>
<script type="text/javascript">
	function changeDivStyle(id,typeName){
		var codeList='<%=codeList%>';
		var codeArray=codeList.split(',');
		if(document.getElementById(("twoList"+id)).innerHTML==""){
			window.location.href="<%=contextPath%>/market/show/viewListTree.srq?typeId="+id+"&&typeName="+typeName+"&&pageType=<%=pageType%>";	;	
		}else{
			for(var i=0;i<codeArray.length;i++){
				var codeValue=codeArray[i];
				if(("twoList"+id)==("twoList"+codeValue)){
					if(document.getElementById("twoList"+codeValue).style.display=="block"){
						document.getElementById("twoList"+codeValue).style.display="none";
					}else{
						document.getElementById("twoList"+codeValue).style.display="block";
					}
				}else{
					document.getElementById("twoList"+codeValue).style.display="none";
				}
			}
		}
		
	}
	function changeDivStyle2(id,typeName){
		var codeList='<%=leafStr%>';
		var codeArray=codeList.split(',');
		if(document.getElementById(("twoList"+id)).innerHTML==""){
			window.location.href="<%=contextPath%>/market/show/viewListTree.srq?typeId="+id+"&&typeName="+typeName+"&&pageType=<%=pageType%>";	;	
		}else{
			for(var i=0;i<codeArray.length;i++){
				var codeValue=codeArray[i];
				if(("twoList"+id)==("twoList"+codeValue)){
					if(document.getElementById("twoList"+codeValue).style.display=="block"){
						document.getElementById("twoList"+codeValue).style.display="none";
					}else{
						document.getElementById("twoList"+codeValue).style.display="block";
					}
				}else{
					document.getElementById("twoList"+codeValue).style.display="none";
				}
			}
		}
	}

	function linkTwoList(typeId,typeName){
		window.location.href="<%=contextPath%>/market/show/viewListTree.srq?typeId="+typeId+"&&typeName="+typeName+"&&pageType=<%=pageType%>";	
	}
	function linkThirdList(twoId,typeId,typeName){
		window.location.href="<%=contextPath%>/market/show/viewListTree.srq?typeId="+typeId+"&&typeName="+typeName+"&&twoId="+twoId+"&&pageType=<%=pageType%>";	;	
	}
	function linkThirdDetail(typeId,typeName){
		window.location.href="<%=contextPath%>/market/show/viewDetail.srq?id="+typeId+"&&typeName="+typeName+"&&pageType=<%=pageType%>";	;	
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
	function linkThridImgInfo(typeId,typeName){
		window.location.href="<%=contextPath%>/market/show/viewDetailImg.srq?id="+typeId+"&&typeName="+typeName+"&&pageType=<%=pageType%>";	;	
	}
	
	function chageDispalyStyle(code){
		var codeList='<%=leafStr%>';
		var codeArray=codeList.split(',');
			for(var i=0;i<codeArray.length;i++){
				var codeValue=codeArray[i];
				if(("outer"+code)==("outer"+codeValue)){
					if(document.getElementById("outer"+codeValue).style.display=="block"){
						document.getElementById("outer"+codeValue).style.display="none";
					}else{
						document.getElementById("outer"+codeValue).style.display="block";
					}
				}else{
					document.getElementById("outer"+codeValue).style.display="none";
				}
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

	
	<%if(leafList!=null&&leafList.size()>7){%>
	$(function(){
		$("#list_div").css("height","auto");
	});
	<%}%>
	
	
</script>
<title>市场信息平台</title>
<link href="<%=contextPath%>/images/ma/style.css" rel="stylesheet" type="text/css" />
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
     	 	<li><a href="<%=contextPath%>/market/show/showSecondPageLike.srq?pageType=<%=pageType%>&&typeName=公司简介&&typeId=<%=code %>&&headingInfo=物探公司动态&&threeTypeId=10802006" class="arrow" target="_self"><%=codeName%></a></li>
     	 	<%} %>
	  	</ul>
  </li>
</ul>
  </div>
  <div id="list_div" style="float: right;width: 783px">
  	<%
  	for(int i=0;leafList!=null&&i<leafList.size();i++){
  		Map map=(Map)leafList.get(i);
  		String code=(String)map.get("code");
  		String codeName=(String)map.get("codeName");
  		List subList=(List)mapLeaf.get("leafList"+code);
  		String styleDisplay="none";
  		if(i==0){
  			styleDisplay="block";
  		}
  	%>
  	<div id="gl_news_mbx" style="width: 750px">
        <ul>
          <li class="mleft"></li>
          <li class="mbg" style="width: 735px"><a href="javascript:chageDispalyStyle('<%=code%>')"><span class="mbx_text" <%if(styleDisplay.equals("block")){%> style="color: #cc0000" <%}else{ %> style="color: black" <%} %>><%=codeName %></span></a><a href="javascript:linkTwoList('<%=code%>','<%=codeName%>')"><span class="mbx_text_more" <%if(styleDisplay.equals("block")){%> style="color: #cc0000" <%}else{ %> style="color: black" <%} %>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;MORE</span></a></li>
          <li class="mright"></li>
        </ul>
    </div>
    <div style="display: <%=styleDisplay%>" id="outer<%=code%>" >
    <div id="main_content" style="width: 750px">
    	<div id="info1" style="width: 740px">
    <%
    	for(int j=0;subList!=null&&j<subList.size();j++) {
    	Map subMap=(Map)subList.get(j);
    	String infomationName=(String)subMap.get("infomationName");
		String releaseDate=(String)subMap.get("releaseDate");
		String infomationId=(String)subMap.get("infomationId");
    %>
    	<div class="infNews" style="width: 740px">
            <div id="img1"></div>
            <a style="width: 670px" href="javascript:linkThirdDetail('<%=infomationId%>','<%=codeName%>')" ><%=infomationName %></a><span class="time"><%=releaseDate %></span>
        </div>
    <%	
    }
    %>
    	</div>
    </div>
    </div>
  	<%	
  		if(code.startsWith("10301")){
  			break;
  		}
    }
    %>
  </div>
  <div id="right_div_left" style="width: 200px;float: left;margin-left: 8px">
    <div id="gl_left_head" style="width: 206px">
      <ul>
        <li class="mleft"></li>
        <li class="mbg" style="width: 158px"><span class="gl_mbx_text"><%=headingInfo%></span></li>
        <li class="mright"></li>
      </ul>
    </div>
    <div id="gl_left_botbox">
    <%
		for (int i = 0; twoList != null && i < twoList.size(); i++) {
			Map map = (Map) twoList.get(i);
			String code = (String) map.get("code");
			String codeName = (String) map.get("codeName");
			List subList = (List) mapTree.get("twoList" + code);
			String javascriptMethod="changeDivStyle";
			if("10401".equals(code)||"10406".equals(code)){
				javascriptMethod="linkThridImgInfo";
			}
			String twoClass="notNews";
			if(code.equals(typeId)){
				twoClass="sel_notNews";
			}
			String twoDisplay="none";
			if(code.equals(typeId)) {
				twoDisplay="block";
			}
		%>
		<div  class="<%=twoClass %>"><a href="javascript:<%=javascriptMethod %>('<%=code%>','<%=codeName%>')"><%=codeName%></a></div>
		<div id="<%="twoList" + code%>" style="display: <%=twoDisplay%>">
			<%
				for (int j = 0; subList != null && j < subList.size(); j++) {
						Map subMap = (Map) subList.get(j);
						String subCode = (String) subMap.get("code");
						String subCodeName = (String) subMap.get("codeName");
			%>
			<div class="sub_notNews"><a href="javascript:changeDivStyle2('<%=subCode%>','<%=subCodeName%>')"><%=subCodeName%></a></div>
			<div id="<%="twoList" + subCode%>" style="display:none">
				<%if(subCode.startsWith("105")) {%>
				<div class="third_notNews"><a href="javascript:linkThirdList('<%=subCode %>','10801001','规划部署')">规划部署</a></div>
				<div class="third_notNews"><a href="javascript:linkThirdList('<%=subCode %>','10801002','油气发现')">油气发现</a></div>
				<div class="third_notNews"><a href="javascript:linkThirdList('<%=subCode %>','10801003','客户管理')">客户管理</a></div>
				<div class="third_notNews"><a href="javascript:linkThirdList('<%=subCode %>','10801004','行业新闻')">行业新闻</a></div>
				<div class="third_notNews"><a href="javascript:linkThirdList('<%=subCode %>','10801005','政经动态')">政经动态</a></div>
				<%} else if(subCode.startsWith("106")){%>
				<div class="third_notNews"><a href="javascript:linkThirdList('<%=subCode %>','10802001','技术装备能力')">技术装备能力</a></div>
				<div class="third_notNews"><a href="javascript:linkThirdList('<%=subCode %>','10802002','竞争伙伴动态分析')">竞争伙伴动态分析</a></div>
				<div class="third_notNews"><a href="javascript:linkThirdList('<%=subCode %>','10802003','竞争伙伴管理')">竞争伙伴管理</a></div>
				<div class="third_notNews"><a href="javascript:linkThirdList('<%=subCode %>','10802004','国际原油价格')">国际原油价格</a></div>
				<div class="third_notNews"><a href="javascript:linkThirdList('<%=subCode %>','10802005','收入对比')">收入对比</a></div>
				<%} %>
			</div>
			<%
				}
			%>
		</div>
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