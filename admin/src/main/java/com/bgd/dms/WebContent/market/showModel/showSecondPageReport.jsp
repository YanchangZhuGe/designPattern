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
	
	//wer
	List listOrg = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("listOrg"));
	
	String corpId = resultMsg.getValue("corpId");
	String headingInfo = resultMsg.getValue("headingInfo");
	String pageType=resultMsg.getValue("pageType");
	String typeId=resultMsg.getValue("typeId");
	String typeName=resultMsg.getValue("typeName");
	String twoId=typeId;
	
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
	function changeDivStyle(id,typeName){
		var codeList='<%=codeList%>';
		var codeArray=codeList.split(',');
		if(document.getElementById(("twoList"+id)).innerHTML==""){
			window.location.href="<%=contextPath%>/market/show/viewListTree.srq?typeId="+id+"&&typeName="+typeName+"&&pageType=<%=pageType%>";	;	
		}else if(id=="10202"){
			window.location.href="<%=contextPath%>/market/show/viewListTree.srq?typeId=10202001&&typeName=新签市场价值工作量落实情况&&pageType=tjfx";		
		}else if(id=="10203"){
			window.location.href="<%=contextPath%>/market/show/viewListTreeFen.srq?typeId=10203001&&typeName=市场周报&&pageType=tjfx";			
		}else if(id=="10201"){
			window.location.href="<%=contextPath%>/market/show/viewListTree.srq?typeId=10201001&&typeName=市场落实价值工作量&&pageType=tjfx";			
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
			if(id=="10202004"){
				window.location.href="<%=contextPath%>/market/show/viewListTreeReport.srq?typeId="+id+"&&typeName="+typeName+"&&pageType=<%=pageType%>";
			}else if(id.substr(0,5)=="10203"){
				window.location.href="<%=contextPath%>/market/show/viewListTreeFen.srq?typeId="+id+"&&typeName="+typeName+"&&pageType=<%=pageType%>";
			}else if(id=="10201003"){
				window.location.href="<%=contextPath%>/market/show/viewListReport.srq?typeId="+id+"&&typeName="+typeName+"&&corpId=300&&pageType=<%=pageType%>";
			} 
			else{
				window.location.href="<%=contextPath%>/market/show/viewListTree.srq?typeId="+id+"&&typeName="+typeName+"&&pageType=<%=pageType%>";
			}
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
	
	function linkThirdList(typeId,corpId){
		window.location.href="<%=contextPath%>/market/show/viewListReport.srq?&&typeId="+typeId+"&&corpId="+corpId;
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
		$("#list_div").css("height","430px");
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
     	 	<li><a href="<%=contextPath%>/market/show/showSecondPageLike.srq?pageType=<%=pageType%>&&typeName=公司简介&&typeId=<%=code %>&&headingInfo=物探公司动态&&threeTypeId=10802006"  class="arrow" target="_self"><%=codeName%></a></li>
     	 	<%} %>
	  	</ul>
  </li>
</ul>
  </div>
  <div id="list_div"  style="width: 765px;float: right;">
   <table width="100%"  border="0" cellspacing="0" cellpadding="0" >
      <tr>
	  	 <td valign="top" align="left" width="575px" height="360px">
		  	<div id="gl_news_mbx_fen2" style="margin-left: 0px;width: 570px">
		        <ul>
		          <li class="mleft"></li>
		          <li class="mbg" style="width: 555px"><a><span class="mbx_text"><%=typeName %></span></a></li>
		          <li class="mright"></li>
		        </ul>
		    </div>
		    <div id="main_content_fen2" style="overflow-x:hidden;width: 570px;height:360px;padding-left: 0px;">
		    	<div id="infofen2" style="width: 570px;height: 360px;padding-left: 0px;">
		  		<div style="width: 570px;">
					<iframe src= "<%=contextPath%>/market/reportPage/showReportPageList.jsp?corpId=<%=corpId %>" width="570px" height="370px"  name= "window "> </iframe>
				</div>
		    </div>
	    </div>
	    </td>
	    <td width="170" valign="top">
	         <div id="right_div" style="padding-top: 0px;width: 165px;height:360px;float: right;margin-left: 10px">
	    		<div id="gl_left_botbox" style="width: 170px;height:360px">
	    		<div class="notNews" style="width: 170px"><a  style="width: 170px" href="javascript:linkThirdList('<%=typeId %>','300')"><span class="mbx_text"><font color="black">东方地球物理公司</font></span></a></div>
	    		<div>
	    		<%
					for (int j = 0; listOrg != null && j < listOrg.size(); j++) {
							Map subMap = (Map) listOrg.get(j);
							String subCode = (String) subMap.get("orgId");
							String subCodeName = (String) subMap.get("orgName");
				%>
				<div  <%if(corpId.equals(subCode)){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>  style="width: 170px">
				<a  style="width: 170px" href="javascript:linkThirdList('<%=typeId %>','<%=subCode%>')"><%=subCodeName%></a>
				</div>
				<%}%>
				</div>
				</div>
	    	</div>
	  	</td>
  	</tr>
  </table>
 </div>
  
    <div id="right_div_left" style="width: 235px;float: left;">
    <div id="gl_left_head" style="width: 215px;">
      <ul>
        <li class="mleft"></li>
        <li class="mbg" style="width: 167px;"><span class="gl_mbx_text"><a href="javascript:linkSecondPage('<%=pageType %>')"><%=headingInfo %></a></span></li>
        <li class="mright"></li>
      </ul>
    </div>
    <div id="gl_left_botbox" style="width: 206px;margin-right: 4px;">
     <%
	for (int i = 0; twoList != null && i < twoList.size(); i++) {
		Map map = (Map) twoList.get(i);
		String code = (String) map.get("code");
		String codeName = (String) map.get("codeName");
		List subList = (List) mapTree.get("twoList" + code);
		String oneClass="notNews";
		if(code.equals(typeId)){
			oneClass="sel_notNews";
		}
		String javascriptMethod="changeDivStyle";
		if("10401".equals(code)||"10406".equals(code)){
			javascriptMethod="linkThridImgInfo";
		}
	%>
		<div class="<%=oneClass %>" style="width: 206px"><a href="javascript:<%=javascriptMethod %>('<%=code%>','<%=codeName%>')"><%=codeName%></a></div>
		<%
			String twoDisplay="none";
			if((twoId!=null&&!"".equals(twoId)&&twoId.startsWith(code))||typeId.startsWith(code)) {
				twoDisplay="block";
			}
				if(code.equals("10203")){
					%>
					<div id="<%="twoList" + code%>" style="display: <%=twoDisplay%>">
						<div  class="sub_notNews" style="width: 206px"><a style="width:206px">公司内部信息</a></div>
						<div class="sub_notNews_third"  style="width: 206px"><a style="width:206px" href="javascript:changeDivStyle2('10203001','市场周报')">市场周报</a></div>
						<div id="twoList10203001" style="display: none">
						</div>
						<div class="sub_notNews_third" style="width: 206px"><a style="width:206px" href="javascript:changeDivStyle2('10203003','市场月报')">市场月报</a></div>
						<div id="twoList10203003" style="display: none">
						</div>
						<div class="sub_notNews_third" style="width: 206px"><a style="width:206px" href="javascript:changeDivStyle2('10203005','市场季报')">市场季报</a></div>
						<div id="twoList10203005" style="display: none">
						</div>
						<div  class="sub_notNews" style="width: 206px"><a style="width:206px">公司外部信息</a></div>
						<div class="sub_notNews_third" style="width: 206px"><a style="width:206px" href="javascript:changeDivStyle2('10203002','油气市场一周综述')">油气市场一周综述</a></div>
						<div id="twoList10203002" style="display: none">
						</div>
						<div class="sub_notNews_third" style="width: 206px"><a style="width:206px" href="javascript:changeDivStyle2('10203004','公司市场月度专报')">公司市场月度专报</a></div>
						<div id="twoList10203004" style="display: none">
						</div>
						<div class="sub_notNews_third" style="width: 206px"><a style="width:206px" href="javascript:changeDivStyle2('10203006','油气勘探综合信息')">油气勘探综合信息</a></div>
						<div id="twoList10203006" style="display: none">
						</div>
					</div>
					<%
				}else{
			%>
		<div id="<%="twoList" + code%>" style="display: <%=twoDisplay%>">
			<%
				for (int j = 0; subList != null && j < subList.size(); j++) {
						Map subMap = (Map) subList.get(j);
						String subCode = (String) subMap.get("code");
						String subCodeName = (String) subMap.get("codeName");
						String twoClass="sub_notNews";
						if(subCode.equals(twoId)){
							twoClass="sub_sel_notNews";
						}		
			%>
			
			<div class="<%=twoClass %>"  style="width: 206px"><a style="width:206px" href="javascript:changeDivStyle2('<%=subCode%>','<%=subCodeName%>')"><%=subCodeName%></a></div>
			<%
			String thirdDisplay="none";
			if(twoId!=null&&!"".equals(twoId)&&subCode.equals(twoId)) {
				thirdDisplay="block";
			}
		%>
			<div id="<%="twoList" + subCode%>" style="display: <%=thirdDisplay%>">
			</div>
			<%
				}
			%>
		</div>
	<%	}
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