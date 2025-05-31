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
    
    String typeName=resultMsg.getValue("typeName");
    
    String headingInfo=resultMsg.getValue("headingInfo");
	String pageType=resultMsg.getValue("pageType");
    String typeId=resultMsg.getValue("typeId");
	String twoId=resultMsg.getValue("twoId");
	
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
	
	
	Date d = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	String d1 = sdf.format(d).toString().substring(0, 4);
	Integer n = Integer.parseInt(d1);
	List listYear = new ArrayList();
		for (int i = n; i >= 2006; i--) {
			listYear.add(i);
		}
	String year=request.getParameter("year");
	if(year==null||"".equals(year)){
		year=d1;
	}
	String corpId=request.getParameter("corpId");
	if(corpId==null||"".equals(corpId)){
		corpId="%%";
	}
	String corpName=request.getParameter("corpName");
	if(corpName==null||"".equals(corpName)){
		corpName="公司";
	}
	
	String params = "year="+year+";corpId="+corpId;
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
		var codeList='<%=codeList%>';
		var codeArray=codeList.split(',');
		if(document.getElementById(("twoList"+id)).innerHTML==""){
			window.location.href="<%=contextPath%>/market/show/viewListTree.srq?typeId="+id+"&&typeName="+typeName+"&&pageType=<%=pageType%>";
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
			}else{
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
	
	function toSelfReport(year,corpId,corpName){
		var id = "10202004";
		var typeName="历年价值工作量趋势图";
		window.location.href="<%=contextPath%>/market/show/viewListTreeReport.srq?typeId="+id+"&&typeName="+typeName+"&&pageType=<%=pageType%>&&year="+year+"&&corpId="+corpId+"&&corpName="+corpName;
	}
	function linkPageList(page){
		window.location.href="<%=contextPath%>/market/show/viewListTree.srq?typeId=<%=typeId%>&&typeName=<%=typeName%>&&currentPage="+page+"&&pageType=<%=pageType%>";		
	}
	function linkTwoList(typeId,typeName){
		window.location.href="<%=contextPath%>/market/show/viewListTree.srq?typeId="+typeId+"&&typeName="+typeName+"&&currentPage=<%=currentPage%>&&pageType=<%=pageType%>";		
	}
	function linkThirdList(twoId,typeId,typeName){
		window.location.href="<%=contextPath%>/market/show/viewListTree.srq?typeId="+typeId+"&&typeName="+typeName+"&&twoId="+twoId+"&&pageType=<%=pageType%>";	;	
	}
	function linkSecondPage(info){
		if(info=="tjfx"){
			window.location.href="<%=contextPath%>/market/show/showSecondPage_tj.srq?pageType="+info;
		}else{
			window.location.href="<%=contextPath%>/market/show/showSecondPage.srq?pageType="+info;
		}
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
		if(code=="monthPic"){
			if(document.getElementById("monthPic").style.display=="block"){
				document.getElementById("monthPic").style.display="none";
			}else{
				document.getElementById("monthPic").style.display="block";
			}
		}else{
			if(document.getElementById("yearPic").style.display=="block"){
				document.getElementById("yearPic").style.display="none";
			}else{
				document.getElementById("yearPic").style.display="block";
			}
		}
	}
	
	function myHref(){
		toSelfReport(document.getElementById("recordYear").value,'<%=corpId%>','<%=corpName%>');
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
		$("#list_div").css("height","auto");
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
  <div id="list_div" style="float: right;width: 765px;">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td valign="top">
		    <div id="gl_news_mbx_fen2" style="width: 562px;margin-right:13px;">
			      <ul>
			        <li class="mleft"></li>
			        <li class="mbg" style="width: 547px">
			           <a href="javascript:chageDispalyStyle('yearPic')">
			        <span class="mbx_text"><%=corpName %>年度价值工作量趋势图
			        <font size="2" color="black" class="mbx_text_modify" style="margin-left: <%=295-corpName.length()*9 %>px;">单位:亿元</font>
			        </span>
			        </a>
			        </li>
			        <li class="mright"></li>
			      </ul>
    		</div>
    		<div style="display:block;width: 560px;margin-right: 10px;" id="yearPic" >
		    <div id="main_content_fen2" style="width: 555px">
		    	 <div id="infofen2" style="height: 180px;padding-left:0px;width: 555px">
		          <div class="infNews"  style="height: 180px;width: 555px">
		            <report:html name="report2"
	               			reportFileName="mm/valueQuanlityYear.raq"
				   			params="<%=params %>"
				  		 	funcBarLocation=""
				   			needScroll="yes"
				   			scrollWidth="100%"
				   			scrollHeight="100%"
				   			excelPageStyle="0"
					/>
		            </div>
		        </div>
		    </div>
		    </div>
		    <div id="gl_news_mbx_fen2" style="width: 562px;margin-right:13px;">
			      <ul>
			        <li class="mleft"></li>
			        <li class="mbg" style="width: 547px">
			        <a href="javascript:chageDispalyStyle('monthPic')">
			        <span class="mbx_text">
			        <%=corpName %>月度价值工作量趋势图
					 <select id="recordYear" name="recordYear" onchange="myHref();" style="margin-left: <%=240-corpName.length()*9 %>px;">
				<%
					
					for(int j=0;j<listYear.size();j++){
						String year123 = listYear.get(j).toString();
					%>
						<option value="<%=listYear.get(j) %>" <%if(year123.equals(year)){ %> selected="selected" <%} %>><%=listYear.get(j) %></option>
					<% } %> 
				          
					  </select>
					  <span align="right">
					  <font size="2" color="black" class="mbx_text_modify" >单位:亿元</font>
					  </span>
			        </span>
			        </a>
			        </li>
			        <li class="mright"></li>
			      </ul>
    		</div>
    		<div style="display:block;width: 560px;margin-right: 10px;" id="monthPic" >
		    <div id="main_content_fen2" style="width: 555px">
		    	 <div id="infofen2" style="height: 200px;width:555px;padding-left:0px;">
		          <div class="infNews"  style="height: 200px;width: 555px">
		            <div id="img1"></div>
		            <report:html name="report1"
	               			reportFileName="mm/valueQuanlityMonth.raq"
				   			params="<%=params %>"
				  		 	funcBarLocation=""
				   			needScroll="yes"
				   			scrollWidth="100%"
				   			scrollHeight="100%"
				   			excelPageStyle="0"
					/>
		            </div>
		        </div>
		    </div>
		    </div>
        </td>
        <td width="175px"  valign="top">
        	<div id="right_div" style="width: 165px;padding-top: 0px" >
			    <div id="gl_left_botbox" style="width: 170px">
			    	<div class="notNews" style="width: 170px"><a href="javascript:toSelfReport('<%=year%>','%%','公司')"><span class="mbx_text"><font color="black">东方地球物理公司</font></span></a></div>
						<div>
						  <div  class="sub_<%if("306".equals(corpId)){ %>sel_<%} %>notNews"  style="width: 170px"><a href="javascript:toSelfReport('<%=year%>','306','国际勘探事业部')">国际勘探事业部</a></div>
					      <div  class="sub_<%if("180".equals(corpId)){ %>sel_<%} %>notNews"  style="width: 170px"><a href="javascript:toSelfReport('<%=year%>','180','研究院')">研究院</a></div>
					      <div  class="sub_<%if("319".equals(corpId)){ %>sel_<%} %>notNews"  style="width: 170px"><a href="javascript:toSelfReport('<%=year%>','319','塔里木物探处')">塔里木物探处</a></div>
					      <div  class="sub_<%if("160".equals(corpId)){ %>sel_<%} %>notNews"  style="width: 170px"><a href="javascript:toSelfReport('<%=year%>','160','新疆物探处')">新疆物探处</a></div>
					      <div  class="sub_<%if("321".equals(corpId)){ %>sel_<%} %>notNews"  style="width: 170px"><a href="javascript:toSelfReport('<%=year%>','321','吐哈物探处')">吐哈物探处</a></div>
					      <div  class="sub_<%if("163".equals(corpId)){ %>sel_<%} %>notNews"  style="width: 170px"><a href="javascript:toSelfReport('<%=year%>','163','青海物探处')">青海物探处</a></div>
					      <div  class="sub_<%if("164".equals(corpId)){ %>sel_<%} %>notNews"  style="width: 170px"><a href="javascript:toSelfReport('<%=year%>','164','长庆物探处')">长庆物探处</a></div>
					      <div  class="sub_<%if("166".equals(corpId)){ %>sel_<%} %>notNews"  style="width: 170px"><a href="javascript:toSelfReport('<%=year%>','166','大港物探处')">大港物探处</a></div>
					      <div  class="sub_<%if("323".equals(corpId)){ %>sel_<%} %>notNews"  style="width: 170px"><a href="javascript:toSelfReport('<%=year%>','323','辽河物探处')">辽河物探处</a></div>
					      <div  class="sub_<%if("32".equals(corpId)){ %>sel_<%} %>notNews"  style="width: 170px"><a href="javascript:toSelfReport('<%=year%>','32','华北物探处')">华北物探处</a></div>
					      <div  class="sub_<%if("8ad878cd2d11f476012d2553db8a0435".equals(corpId)){ %>sel_<%} %>notNews"  style="width: 170px"><a href="javascript:toSelfReport('<%=year%>','8ad878cd2d11f476012d2553db8a0435','新兴物探开发处')">新兴物探开发处</a></div>
					      <div  class="sub_<%if("309".equals(corpId)){ %>sel_<%} %>notNews"  style="width: 170px"><a href="javascript:toSelfReport('<%=year%>','309','综合物化探处')">综合物化探处</a></div>
					      <div  class="sub_<%if("8ad878cd2e765396012eb2394b5201aa".equals(corpId)){ %>sel_<%} %>notNews"  style="width: 170px"><a href="javascript:toSelfReport('<%=year%>','8ad878cd2e765396012eb2394b5201aa','信息技术中心')">信息技术中心</a></div>
					      <div  class="sub_<%if("8ad878cd2e765396012eb23bf93801ae".equals(corpId)){ %>sel_<%} %>notNews"  style="width: 170px"><a href="javascript:toSelfReport('<%=year%>','8ad878cd2e765396012eb23bf93801ae','英洛瓦物探装备')">英洛瓦物探装备</a></div>
					      <div  class="sub_<%if("123".equals(corpId)){ %>sel_<%} %>notNews"  style="width: 170px"><a href="javascript:toSelfReport('<%=year%>','123','西安装备分公司')">西安装备分公司</a></div>
						</div>		    	
			    </div>
  			</div>
        </td>
   </tr>
   </table>
  
  </div>
   <div id="right_div" style="padding-right: 0px;width: 235px;float: left;">
    <div id="gl_left_head" style="width: 215px;">
      <ul>
        <li class="mleft"></li>
        <li class="mbg" style="width: 167px;"><span class="gl_mbx_text" ><a href="javascript:linkSecondPage('<%=pageType %>')"><font style="font-weight: bold"><%=headingInfo%></font></a></span></li>
        <li class="mright"></li>
      </ul>
    </div>
    <div id="gl_left_botbox" style="width: 210px;margin-right: 2px;">
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
		<div class="<%=oneClass %>" style="width: 210px"><a href="javascript:<%=javascriptMethod %>('<%=code%>','<%=codeName%>')"><%=codeName%></a></div>
		<%
			String twoDisplay="none";
			if((twoId!=null&&!"".equals(twoId)&&twoId.startsWith(code))||typeId.startsWith(code)) {
				twoDisplay="block";
			}
				if(code.equals("10203")){
					%>
					<div id="<%="twoList" + code%>" style="display: <%=twoDisplay%>">
						<div  class="sub_notNews" style="width: 210px"><a style="width:210px">公司内部信息</a></div>
						<div class="sub_notNews_third"  style="width: 210px"><a style="width:210px" href="javascript:changeDivStyle2('10203001','市场周报')">市场周报</a></div>
						<div id="twoList10203001" style="display: none">
						</div>
						<div class="sub_notNews_third" style="width: 210px"><a style="width:210px" href="javascript:changeDivStyle2('10203003','市场月报')">市场月报</a></div>
						<div id="twoList10203003" style="display: none">
						</div>
						<div class="sub_notNews_third" style="width: 210px"><a style="width:210px" href="javascript:changeDivStyle2('10203005','市场季报')">市场季报</a></div>
						<div id="twoList10203005" style="display: none">
						</div>
						<div  class="sub_notNews" style="width: 210px"><a style="width:210px">公司外部信息</a></div>
						<div class="sub_notNews_third" style="width: 210px"><a style="width:210px" href="javascript:changeDivStyle2('10203002','油气市场一周综述')">油气市场一周综述</a></div>
						<div id="twoList10203002" style="display: none">
						</div>
						<div class="sub_notNews_third" style="width: 210px"><a style="width:210px" href="javascript:changeDivStyle2('10203004','市场动态月度专报')">市场动态月度专报</a></div>
						<div id="twoList10203004" style="display: none">
						</div>
						<div class="sub_notNews_third" style="width: 210px"><a style="width:210px" href="javascript:changeDivStyle2('10203006','油气勘探综合信息')">油气勘探综合信息</a></div>
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
						if(subCode.equals(typeId)){
							twoClass="sub_sel_notNews";
						}
			%>
			
			<div class="<%=twoClass %>"  style="width: 210px"><a style="width:210px" href="javascript:changeDivStyle2('<%=subCode%>','<%=subCodeName%>')"><%=subCodeName%></a></div>
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
