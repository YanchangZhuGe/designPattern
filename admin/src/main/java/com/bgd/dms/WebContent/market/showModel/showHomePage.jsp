<%@ page  contentType="text/html; charset=GBK" pageEncoding="utf-8"%>

<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.bgp.mcs.service.ma.showMainFrame.util.MarketGetInfoUtil"%>
<%@ page import="java.util.*"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
	String contextPath = request.getContextPath();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);

	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName=user.getUserName();
	
	String dateTime=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
	//公司市场动态
	List<Map> sczyb = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("sczyb"));
	List<Map> jzgzl = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("jzgzl"));
	//物探公司动态
	List<Map> wtgstt = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("wtgstt"));
	//油田公司动态
	List<Map> ytgstt = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("ytgstt"));
	//首页图片
	List<Map> sytp = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("sytp"));
	//行业动态
	List<Map> hydt = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("hydt"));
	//政经动态
	List<Map> zjdt = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("zjdt"));
	//公司重要活动
	List<Map> gszyhd = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("gszyhd"));
	
	//
	List list = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("list"));
	String pageType="sy";
	//处理首页图片
	String pics="";
	String links="";
	String texts="";
	for(int i=0;i<sytp.size();i++){
		Map map=sytp.get(i);
		String end="|";
		if(i==sytp.size()-1){
			end="";
		}
		if(((String)map.get("url")).startsWith("http")){
			pics+=(String)map.get("url")+end;
		}else{
			pics+="http://"+request.getServerName()+":"+request.getServerPort()+(String)map.get("url")+end;
		}
		links+="viewDetail.srq?id="+(String)map.get("infomationId")+end;
		texts+=(String)map.get("infomationName")+end;
	}
	
	//处理logo域 二级菜单列表
	List<Map> sckfList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("sckfList"));
	List<Map> scglList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("scglList"));
	List<Map> ygsdtList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("ygsdtList"));
	List<Map> jzhbdtList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("jzhbdtList"));
	List<Map> tjfxList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("tjfxList"));
	
	
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
<link href="<%=contextPath%>/images/ma/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/images/ma/js/jquery-1.3.2.min.js"></script>
<style type="text/css">
a.links {
	font:12px/25px "宋体";
}
a.links2 {
	font:12px/25px "宋体";
}
#con {
	width:180px;
	height:18px;
	margin-left: 5px;
}
#con_left {
	width:90px;
	float:left;
}
#con_right {
	width:90px;
	float:right;
}
#iDBody1 {
	width:194px;
	height:215px;
	border:1px #CCC solid;
	background:#FFF;
	position:absolute;
	left:304px;
	top:623px;
}
#iDBody2 {
	width:194px;
	height:187px;
	border:1px #CCC solid;
	background:#FFF;
	position:absolute;
	left:504px;
	top:651px;
}
#iDBody3 {
	width:194px;
	height:130px;
	border:1px #CCC solid;
	background:#FFF;
	position:absolute;
	left:304px;
	top:734px;
}
#iDBody4 {
	width:194px;
	height:150px;
	border:1px #CCC solid;
	background:#FFF;
	position:absolute;
	left:504px;
	top:714px;
}

</style>
<script type="text/javascript">

	function linkTwoList(typeId,typeName){
		window.location.href="<%=contextPath%>/market/show/viewList.srq?typeId="+typeId+"&&typeName="+typeName;	
	}
	function linkThirdList(typeId,typeName){
		window.location.href="<%=contextPath%>/market/show/viewDetail.srq?id="+typeId+"&&typeName="+typeName;	
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

	
	function changeIDBody2OnDiv(n){
		switch(n){    
		case 1:{    
		document.getElementById('iDBody1').style.display = "";   
		document.getElementById('iDBody2').style.display = "none";  
		document.getElementById('iDBody3').style.display = "none";    
		document.getElementById('iDBody4').style.display = "none";   
		break;  
		}    
		case 2:{    
		document.getElementById('iDBody1').style.display = "none";  
		document.getElementById('iDBody2').style.display = "";    
		document.getElementById('iDBody3').style.display = "none";  
		document.getElementById('iDBody4').style.display = "none"; 
		break;        
		}    
		case 3:{    
		document.getElementById('iDBody1').style.display = "none";  
		document.getElementById('iDBody2').style.display = "none"; 
		document.getElementById('iDBody3').style.display = "";    
		document.getElementById('iDBody4').style.display = "none";   
		break;          
		}       
		case 4:{    
		document.getElementById('iDBody1').style.display = "none";  
		document.getElementById('iDBody2').style.display = "none";    
		document.getElementById('iDBody3').style.display = "none";    
		document.getElementById('iDBody4').style.display = "";    
		break;          
		}    
		case 5:{    
			document.getElementById('iDBody1').style.display = "none";  
			document.getElementById('iDBody2').style.display = "none";    
			document.getElementById('iDBody3').style.display = "none";    
			document.getElementById('iDBody4').style.display = "none";    
			break;          
			}    
		}        
	}
	function changeIDBody2OnDiv_mod(){
		document.getElementById('iDBody2').style.display = "none";    
	}
	function changeBody(index){    

	switch(index){    
	case 1:{    
	document.getElementById('iDBody1').style.display = "";   
	document.getElementById('iDBody2').style.display = "none";  
	document.getElementById('iDBody3').style.display = "none";    
	document.getElementById('iDBody4').style.display = "none";   
	break;  
	}    
	case 2:{    
	document.getElementById('iDBody1').style.display = "none";  
	document.getElementById('iDBody2').style.display = "";    
	document.getElementById('iDBody3').style.display = "none";  
	document.getElementById('iDBody4').style.display = "none"; 
	break;        
	}    
	case 3:{    
	document.getElementById('iDBody1').style.display = "none";  
	document.getElementById('iDBody2').style.display = "none"; 
	document.getElementById('iDBody3').style.display = "";    
	document.getElementById('iDBody4').style.display = "none";   
	break;          
	}       
	case 4:{    
	document.getElementById('iDBody1').style.display = "none";  
	document.getElementById('iDBody2').style.display = "none";    
	document.getElementById('iDBody3').style.display = "none";    
	document.getElementById('iDBody4').style.display = "";    
	break;          
	}    
	case 5:{    
		document.getElementById('iDBody1').style.display = "none";  
		document.getElementById('iDBody2').style.display = "none";    
		document.getElementById('iDBody3').style.display = "none";    
		document.getElementById('iDBody4').style.display = "none";    
		break;          
		}    
	}    
}    

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
<div id="left_div"  style="float: left">
	<div id="gssctj">
		<div id="column_head">公司主营业务市场统计</div>
		<div id="gssctj_content" style="margin-left:1px">
		 <table width="100%" border="0" cellspacing="2" cellpadding="0">
				<tr>
					<td width="266px" align="left">
						<span  style="color: black;font:  11px/30px 宋体;align: center" >单位:亿元 <img width="84px" height="20px" style="margin-left: 120px;" alt="" align="middle" src="<%=contextPath %>/images/ma/indexImangeIs.png" />
						</span>
					</td>
				</tr>
				<tr>
					<td class="nortext"><!--2012 	
		 -->
					<!-- 
					<%for(int i=0;i<sczyb.size();i++){ 
						Map map=sczyb.get(i);
						String infomationName=(String)map.get("infomationName");
						String releaseDate=(String)map.get("releaseDate");
						String infomationId=(String)map.get("infomationId");
					%>
					<a href="javascript:linkThirdList('<%=infomationId%>','公司市场统计')"><%=infomationName%></a><br>
					<%} %>
					<%for(int i=0;i<jzgzl.size();i++){ 
						Map map=jzgzl.get(i);
						String infomationName=(String)map.get("infomationName");
						String releaseDate=(String)map.get("releaseDate");
						String summary=(String)map.get("summary");
						String infomationId=(String)map.get("infomationId");
						if(infomationName!=null&&!"".equals(infomationName)&&infomationName.length()>13){
							infomationName=infomationName.substring(0,13)+"...";
						}
					%>
					<%=infomationName%><br>
					<%=summary%>
					<%} %>
					 -->
					 <!-- img width="250px" height="166px" alt="" src="<%=contextPath %>/images/ma/indexPic.png" /-->
					 
				<!-- 	 <report:html name="report1"
					               reportFileName="/mm/test1.raq"
								   params=""
								   funcBarLocation=""
								   needScroll="yes"
								   scrollWidth="100%"
								   scrollHeight="100%"
								   excelPageStyle="0"
					  /> -->  
					</td>
				</tr>
			</table> 
		<!--2012
		<iframe src= "<%=contextPath%>/market/showModel/error.jsp" width="266px" height="302px" name= "window " scrolling="no" frameborder="0" allowtransparency="true"> </iframe>
			 -->
		</div>
	</div>
	
	
	<div id="gssctj3" style="margin-top: 8px;">
		<div id="column_head">市场预警:未按月进度完成新签指标单位</div>
		<div id="gssctj_content3">
			<div id="notice2" style="height: 30px">
			<div class="notNews" style="margin-left: 18px;" >
					<div id="img1" ></div>
					<table><tr><td style="margin-left: 60px" align="center"">
					<%if(list.isEmpty()){ %>
					<div style="margin-left: 50px;"><font size="2px">月报数据尚未形成</font></div>
					<%}else{ %>
					<marquee scrollAmount="2" style="text-align:center" width="230" height="20" scrolldelay="0" direction="up" onmouseover="stop()" onmouseout="start()">
					  <%
					  	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
					    String today = format.format(new Date());
					    String endDate = "";
						String[] circalInfo=today.split("-");
						if(Integer.parseInt(circalInfo[2])>26){
							endDate=circalInfo[0]+"-"+circalInfo[1]+"-25";
						}else{
							if(circalInfo[1].equals("01")){//如果是一月份
								endDate=String.valueOf(Integer.parseInt(circalInfo[0])-1)+"-12-25";//上一年度12月25日开始
							}else if(circalInfo[1].equals("11") || circalInfo[1].equals("12")){
								endDate=circalInfo[0]+"-"+String.valueOf(Integer.parseInt(circalInfo[1])-1)+"-25";//上个月25日开始
							}else{
								endDate=circalInfo[0]+"-0"+String.valueOf(Integer.parseInt(circalInfo[1])-1)+"-25";//上个月25日开始，月份前多加个0
							}
						}
					  for(int i = 0; i<list.size();i++){ %>
			          <p class="text_ld" title="截止<%=endDate %>新签市场价值工作量落实应为<%=((Map)list.get(i)).get("bud") %>亿元 实际落实<%=((Map)list.get(i)).get("inc") %>亿元"><font color="#999800"><strong><%=((Map)list.get(i)).get("orgAbbreviation") %></strong></font></p>
			          <%} %>
				  </marquee>
				  <%} %>
					</td></tr></table>
				</div>
			</div>
		</div>
	</div>
	
	
	
	<div id="gssctj2" style="margin-top: 8px;">
		<div id="column_head">油公司动态<span class="more_text" style="margin-left: 135px;"><a href="javascript:linkTwoList('10801002','油公司动态')">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;MORE</a></span></div>
		<div id="gssctj_content">
			<div id="notice">
			<%for(int i=0;i<ytgstt.size();i++){ 
				Map map=ytgstt.get(i);
				String infomationName=(String)map.get("infomationName");
				String releaseDate=(String)map.get("releaseDate");
				String infomationId=(String)map.get("infomationId");
				if(infomationName!=null&&!"".equals(infomationName)&&infomationName.length()>13){
					infomationName=infomationName.substring(0,13)+"...";
				}
			%>
				<div class="notNews">
					<div id="img1"></div>
					<a href="javascript:linkThirdList('<%=infomationId%>','油公司动态')"><%=infomationName%></a><span class="time"><%=releaseDate %></span>
				</div>
			<%} %>
			</div>
		</div>
	</div>
	<div id="gssctj2" style="margin-top: 8px;">
		<div id="column_head">物探公司动态<span class="more_text" style="margin-left: 135px;"><a href="javascript:linkTwoList('10802002','物探公司动态')">MORE</a></span></div>
		<div id="gssctj_content">
		 	<div id="notice">
				<%for(int i=0;i<wtgstt.size();i++){ 
					Map map=wtgstt.get(i);
					String infomationName=(String)map.get("infomationName");
					String releaseDate=(String)map.get("releaseDate");
					String infomationId=(String)map.get("infomationId");
					if(infomationName!=null&&!"".equals(infomationName)&&infomationName.length()>13){
						infomationName=infomationName.substring(0,13)+"...";
					}
				%>
					<div class="notNews">
						<div id="img1"></div>
						<a href="javascript:linkThirdList('<%=infomationId%>','物探公司动态')"><%=infomationName%></a><span class="time"><%=releaseDate %></span>
					</div>
				<%} %> 
			</div>
		</div>
	</div>
	
</div>
<div id="right_div" style="float: right">
<!-- <div id="data">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="right" class="data_btext">&nbsp;</td>
				<td class="data_btext" style="text-indent: 15px;"><%=dateTime %></td>
			</tr>
			<tr>
				<td colspan="2" align="right" height="8"></td>
			</tr>
		</table>
	</div>
	 -->
<div id="gssctj2" style="margin-top: 0px; ">
		<div id="column_head"><font color="black">行业新闻</font>&nbsp;&nbsp;&nbsp;&nbsp;<span class="more_text" style="margin-left: 135px;"><a href="javascript:linkTwoList('10306','行业新闻')"><font color="black">MORE</font></a></span></div>
		<div id="gssctj_content">
			<div id="notice">
			<%for(int i=0;i<hydt.size();i++){ 
				Map map=hydt.get(i);
				String infomationName=(String)map.get("infomationName");
				String releaseDate=(String)map.get("releaseDate");
				String infomationId=(String)map.get("infomationId");
				if(infomationName!=null&&!"".equals(infomationName)&&infomationName.length()>13){
					infomationName=infomationName.substring(0,13)+"...";
				}
			%>
				<div class="notNews">
					<div id="img1"></div>
					<a href="javascript:linkThirdList('<%=infomationId%>','行业新闻')"><%=infomationName%></a><span class="time"><%=releaseDate %></span>
				</div>
			<%} %>
			</div>
		</div>
</div>
<div id="gssctj2" style="margin-top: 8px;">
		<div id="column_head"><font color="black">政经动态</font>&nbsp;&nbsp;&nbsp;&nbsp;<span class="more_text" style="margin-left: 135px;"><a href="javascript:linkTwoList('10307','政经动态')"><font color="black">MORE</font></a></span></div>
		<div id="gssctj_content" >
			<div id="notice">
			<%for(int i=0;i<zjdt.size();i++){ 
					Map map=zjdt.get(i);
				String infomationName=(String)map.get("infomationName");
				String releaseDate=(String)map.get("releaseDate");
				String infomationId=(String)map.get("infomationId");
				if(infomationName!=null&&!"".equals(infomationName)&&infomationName.length()>13){
					infomationName=infomationName.substring(0,13)+"...";
				}
			%>
				<div class="notNews">
					<div id="img1"></div>
					<a href="javascript:linkThirdList('<%=infomationId%>','政经动态')"><%=infomationName%></a><span class="time"><%=releaseDate %></span>
				</div>
			<%} %>
			</div>
		</div>
	</div>

<div id="gssctj3" >			
			<div style="background: #f2eedd;width: 34px;height: 24px;float:right;position: relative;top: 27px;right: 2px;" ></div>
			<center> 
				<iframe src= "http://info.cnpc/INFO2006/Page/OilStock/OilPrice.aspx" height="150px" width="272px" scrolling="no" name= "window " frameborder="0"> 
				</iframe> 
			</center> 
	</div>
	
</div>
<div id="mid_div">
	<div id="photonews">
		<div style="margin-top: 11px; float: left; margin-left: 10px; margin-left: 10px\9; *margin-left: 10px; _margin-left: 5px; width: 272px;">
			<A href="#" target=_self><SPAN class=f14b> 
			<SCRIPT type=text/javascript>
	        
	         var focus_width=376;
	         var focus_height=195;
	         var text_height=22;
	         var swf_height = focus_height+text_height;
	         
		
			
			var pics = "<%=pics%>";
			var links = "<%=links%>";
			var texts ="<%=texts%>";
		
			document.write('<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" width="'+ focus_width +'" height="'+ swf_height +'">');
			document.write('<param name="allowScriptAccess" value="sameDomain"><param name="movie" value="<%=contextPath%>/market/showModel/focus.swf"><param name="quality" value="high"><param name="bgcolor" value="#f2f3ed">');
			document.write('<param name="menu" value="false"><param name=wmode value="opaque">');
			document.write('<param name="FlashVars" value="pics='+pics+'&links='+links+'&texts='+texts+'&borderwidth='+focus_width+'&borderheight='+focus_height+'&textheight='+text_height+'">');
			document.write('<embed src="pixviewer.swf" wmode="opaque" FlashVars="pics='+pics+'&links='+links+'&texts='+texts+'&borderwidth='+focus_width+'&borderheight='+focus_height+'&textheight='+text_height+'" menu="false" bgcolor="#e9ece1" quality="high" width="'+ focus_width +'" height="'+ focus_height +'" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />');
			document.write('</object>');
		</SCRIPT> </SPAN></A><span class=f14b id=focustext></span>
		</div>
	</div>
	<div id="gszyhd" style="margin-top: 8px;border-left: 1px #e2e2e2 solid;height: 430px;">
		<div id="gszyhd_head">公司重要活动<span class="more_text" style="margin-left: 265px;"><a href="javascript:linkTwoList('10302','公司重要活动')">MORE</a></span></div>
		<div id="gszyhd_content" style="width: 395px;height: 400px">
			<div id="info">
			<%for(int i=0;i<gszyhd.size();i++){ 
				Map map=gszyhd.get(i);
				String infomationName=(String)map.get("infomationName");
				String releaseDate=(String)map.get("releaseDate");
				String infomationId=(String)map.get("infomationId");
				if(infomationName!=null&&!"".equals(infomationName)&&infomationName.length()>22){
					infomationName=infomationName.substring(0,22)+"...";
				}
			%>
				<div class="infNews">
					<div id="img1"></div>
					<a href="javascript:linkThirdList('<%=infomationId%>','公司重要活动')"><%=infomationName %></a><span class="time"><%=releaseDate%></span>
				</div>
			<%} %>
			</div>
		</div>
	</div>
	<div style="margin-top: 8px;height: 52px;">
	<table id="__01" width="397px" height="52px" border="0" cellpadding="0" cellspacing="0"> 
	  <tr>
	    <td><a href="javascript:changeBody(1)" onMouseMove="javascript:changeBody(1)" onmouseout="javascript:changeBody(5)"><img src="<%=contextPath%>/images/ma/sc48_03.png" width="196" height="24" alt="" border="0"></a></td>
	    <td><a href="javascript:changeBody(2)" onMouseMove="javascript:changeBody(2)" onmouseout="javascript:changeBody(5)"><img src="<%=contextPath%>/images/ma/sc48_05.png" width="196" height="24" alt="" border="0"></a></td>
	  </tr>
	  
	  <tr>
	    <td><a href="javascript:changeBody(3)" onMouseMove="javascript:changeBody(3)" onmouseout="javascript:changeBody(5)"><img src="<%=contextPath%>/images/ma/sc48_09.png" width="196" height="24" alt="" border="0"></a></td>
	    <td><a href="javascript:changeBody(4)" onMouseMove="javascript:changeBody(4)" onmouseout="javascript:changeBody(5)"><img src="<%=contextPath%>/images/ma/sc48_10.png" width="196" height="24" alt="" border="0"></a></td>
	  </tr>
	  <div style="display: none;" id="iDBody1" onmousemove="javascript:changeIDBody2OnDiv(1)" onmouseout="javascript:changeIDBody2OnDiv(5)">
	  <div style="margin-left: 5px;">
		<div style="height: 20px;"><a class="links" href="http://eip.cnpc/default.htm" target="_blank"> 集团公司内网 </font></a></div> 
		<div style="height: 20px;"><a class="links" href="http://www.cnpc.com.cn/cn/" target="_blank"> 集团公司外网</font></a></div>
		<div style="height: 20px;"><a class="links" href="http://www.petrochina.com.cn/" target="_blank"> 股份公司网站</font></a></div>
		<div style="margin-top: 0px; font: normal 12px/25px '宋体'; height: 15px;"><font color="gray">油气田企业</font></div>
		<div style="margin-left: 0px;height: 20px;">
		<a class="links2" href="http://www.dqyt.petrochina/" target="_blank">大庆</a>
		<a class="links2" href="http://www.lhyt.petrochina/" target="_blank">辽河</a>
		<a class="links2" href="http://www.cqyt.petrochina/" target="_blank">长庆</a>
		<a class="links2" href="http://www.xjyt.petrochina/" target="_blank">新疆</a>
		<a class="links2" href="http://www.tlmyt.petrochina/" target="_blank">塔里木</a></div>
		<div style="margin-left: 0px;height: 20px;">
		<a class="links2" href="http://www.xnyqt.petrochina/" target="_blank">西南</a>
		<a class="links2" href="http://www.jlyt.petrochina/" target="_blank">吉林</a>
		<a class="links2" href="http://www.dgyt.petrochina/" target="_blank">大港</a>
		<a class="links2" href="http://www.qhyt.petrochina/" target="_blank">青海</a>
		<a class="links2" href="http://www.hbyt.petrochina/" target="_blank">华北</a></div>
		<div style="margin-left: 0px;height: 20px;">
		<a class="links2" href="http://www.thyt.petrochina/" target="_blank">吐哈</a>
		<a class="links2" href="http://www.jdyt.petrochina/" target="_blank">冀东</a>
		<a class="links2" href="http://www.ymyt.petrochina/" target="_blank">玉门</a>
		<a class="links2" href="http://www.zjyt.petrochina/default.aspx" target="_blank">浙江</a>
		<a class="links2" href="http://www.cbm.petrochina" target="_blank">煤气层</a></div>
		<div style="margin-left: 0px;height: 20px;">
		<a class="links2" href="http://www.nfkt.cnpc" target="_blank">南方勘探开发</a></div>
		<div style="margin-top: 0px; font: normal 12px/25px '宋体'; height: 15px;"><font color="gray">工程技术服务企业</font></div>
		<div style="margin-left: 0px;height: 20px;">
		<a class="links2" href="http://www.xdec.cnpc" target="_blank">西部钻探</a>
		<a class="links2" href="http://www.gwdc.cnpc/" target="_blank">长城钻探</a>
		<a class="links2" href="http://www.bhzt.cnpc/default.aspx" target="_blank">渤海钻探</a></div>
		<div style="margin-left: 0px;height: 20px;">
		<a class="links2" href="http://www.ccde.cnpc/default.aspx" target="_blank">川庆钻探</a>
		<a class="links2" href="http://www.cpoe.cnpc/" target="_blank">海洋工程</a>
		<a class="links2" href="http://www.cpl.cnpc/" target="_blank">测井</a></div>
		</div>
	</div>
	<div style="display: none" id="iDBody2" onmousemove="javascript:changeIDBody2OnDiv(2)" onmouseout="javascript:changeIDBody2OnDiv(5)"> 
	 	<div  id="con"><div id="con_left"><A class="links" href="http://www.mofcom.gov.cn/" target="_blank">商务部 </A></div>
		<div id="con_right"><A class="links" href="http://www.audit.gov.cn/" target="_blank">审计署 </A></div></div>
		<div  id="con"><div id="con_left"><A class="links" href="http://www.mps.gov.cn/" target="_blank">公安部</A></div>
		<div id="con_right"><A class="links" href="http://www.moc.gov.cn/" target="_blank">交通部</A></div></div>
		<div id="con"><div id="con_left"><A class="links" href="http://www.moe.edu.cn/" target="_blank">教育部</A></div>
		<div id="con_right"><A class="links" href="http://www.sasac.gov.cn/" target="_blank">国资委</A></div></div>
		<div id="con"><div id="con_left"><A class="links" href="http://www.mof.gov.cn/" target="_blank">财政部</A></div>
		<div id="con_right"><A class="links" href="http://www.mlr.gov.cn/" target="_blank">国土资源部</A></div></div>
		<div id="con"><div id="con_left"><A class="links" href="http://www.seac.gov.cn/" target="_blank">国家民委</A></div>
		<div id="con_right"><A class="links" href="http://www.mii.gov.cn/" target="_blank">信息产业部</A></div></div>
		<div id="con"><div id="con_left"><A class="links" href="http://www.most.gov.cn/" target="_blank">科学技术部</A></div>
		<div id="con_right"><A class="links" href="http://www.sdpc.gov.cn/" target="_blank">国家发改委</A></div></div>
		<div id="con"><div id="con_left"><A class="links" href="http://www.gov.cn/" target="_blank">中国政府网</A></div>
		<div id="con_right"><A class="links" href="http://www.chinatax.gov.cn/" target="_blank">国家税务总局</A></div></div>
		<div id="con"><div id="con_left"><A class="links" href="http://www.chinasafety.gov.cn/" target="_blank">国家安监局</A></div>
		<div id="con_right"><A class="links" href="http://www.stats.gov.cn/" target="_blank">国家统计局</A></div></div>
		<div id="con"><div id="con_left"><A class="links" href="http://www.zhb.gov.cn/" target="_blank">国家环保总局</A></div>
		<div id="con_right"><A class="links" href="http://www.saic.gov.cn/" target="_blank">国家工商总局</A></div></div>
		<div style="width: 189px;margin-left: 5px;height: 18px;"><div style="width: 90px;float: left;"><A class="links" href="http://www.sipo.gov.cn/" target="_blank">国家知识产权局</A></div>
		<div style="width: 99px;float: right;"></div></div>
	</div>
	<div style="display: none" id="iDBody3" onmousemove="javascript:changeIDBody2OnDiv(3)" onmouseout="javascript:changeIDBody2OnDiv(5)">
		<div id="con"><div id="con_left"><A class="links" href="http://www.tom.com/" target="_blank">TOM </A></div>
		<div  id="con_right"><A class="links" href="http://www.baidu.com/" target="_blank">baidu</A></div></div>
		<div id="con"><div id="con_left"><A class="links" href="http://www.21cn.com/" target="_blank">21CN</A></div>
		<div  id="con_right"><A class="links" href="http://www.google.cn/" target="_blank">Google</A></div></div>
		<div id="con"><div id="con_left"><A class="links" href="http://www.sohu.com/" target="_blank">搜狐</A></div>
		<div  id="con_right"><A class="links" href="http://www.yahoo.com.cn/" target="_blank">雅虎</A></div></div>
		<div id="con"><div id="con_left"><A class="links" href="http://www.163.com/" target="_blank">网易</A></div>
		<div  id="con_right"><A class="links" href="http://www.sina.com.cn/" target="_blank">新浪</A></div></div>
		<div id="con"><div id="con_left"><A class="links" href="http://www.homeway.com.cn/" target="_blank">和讯网</A></div>
		<div  id="con_right"><A class="links" href="http://www.china.com/" target="_blank">中华网</A></div></div>
		<div id="con"><div id="con_left"><A class="links" href="http://www.cei.gov.cn/" target="_blank">中经网</A></div>
		<div  id="con_right"><A class="links" href="http://www.stockstar.com/home.htm" target="_blank">证券之星</A></div></div>
		<div id="con"><div id="con_left"><A class="links" href="http://www.newhua.com/" target="_blank">华军软件</A></div>
		<div  id="con_right"><A class="links" href="http://www.energyahead.com/" target="_blank">能源一号网</A></div></div>

	</div>
	<div style="display: none" id="iDBody4" onmousemove="javascript:changeIDBody2OnDiv(4)" onmouseout="javascript:changeIDBody2OnDiv(5)">
		<div id="con"><div id="con_left"><A class="links" href="http://www.qsjournal.com.cn/" target="_blank">求是</A></div>
		<div  id="con_right"><A class="links" href="http://www.xinhuanet.com/" target="_blank">新华网</A></div></div>
		<div id="con"><div id="con_left"><A class="links" href="http://www.china.com.cn/" target="_blank">中国网 </A></div>
		<div  id="con_right"><A class="links" href="http://www.people.com.cn/" target="_blank">人民网</A></div></div>
		<div id="con"><div id="con_left"><A class="links" href="http://www.chinanews.com.cn/" target="_blank">中新网</A></div>
		<div  id="con_right"><A class="links" href="http://www.eastday.com/" target="_blank">东方网 </A></div></div>
		<div id="con"><div id="con_left"><A class="links" href="http://www.21dnn.com/" target="_blank">千龙网</A></div>
		<div  id="con_right"><A class="links" href="http://news.enorth.com.cn/" target="_blank">北方网</A></div></div>
		<div id="con"><div id="con_left"><A class="links" href="http://www.southcn.com/" target="_blank">南方网</A></div>
		<div  id="con_right"><A class="links" href="http://online.cri.com.cn/" target="_blank">国际在线 </A></div></div>
		<div id="con"><div id="con_left"><A class="links" href="http://www.stdaily.com/" target="_blank">科技日报</A></div>
		<div  id="con_right"><A class="links" href="http://www.cyd.com.cn/" target="_blank">中青在线 </A></div></div>
		<div id="con"><div id="con_left"><A class="links" href="http://www.chinadaily.com.cn/home/index.html" target="_blank">中国日报</A></div>
		<div  id="con_right"><A class="links" href="http://www.cnpc.com.cn/CNPC/xwzx/cbw/zgsyb/" target="_blank">中国石油报</A></div></div>
		<div id="con"><div id="con_left"><A class="links" href="http://www.cnradio.com/" target="_blank">中国广播网</A></div>
		<div  id="con_right"><A class="links" href="http://www.sinopecnews.com.cn/" target="_blank">中国石化报</A></div></div>
	</div>
	</table>
</div>
</div>
<div id="copy_div" class="copy_text" >
	<div class="copy_img"></div><a href="">版权所有：中国石油集团东方地球物理公司</a>
</div>
</div>
</body>
</html>