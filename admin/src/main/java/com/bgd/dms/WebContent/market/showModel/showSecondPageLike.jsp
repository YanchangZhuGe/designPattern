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
	String typeId=resultMsg.getValue("typeId");
	List<MsgElement> list = resultMsg.getMsgElements("list");
	Map mapOrgInfo = new HashMap();
	if(resultMsg.getMsgElement("mapOrgInfo")!=null){
		mapOrgInfo = resultMsg.getMsgElement("mapOrgInfo").toMap();
	}
	Map mapOrgTech = new HashMap();
	if(typeId.startsWith("106")){
		if(resultMsg.getMsgElement("mapOrgTech")!=null){
		mapOrgTech = resultMsg.getMsgElement("mapOrgTech").toMap();
		}
	}
	String exceptionalSkill = (String)mapOrgTech.get("exceptionalSkill")==null ? "没有信息" : (String)mapOrgTech.get("exceptionalSkill");
	String skillSeries = (String)mapOrgTech.get("skillSeries")==null ? "没有信息" : (String)mapOrgTech.get("skillSeries");

	
	String pageType=resultMsg.getValue("pageType");
	
	String typeName=resultMsg.getValue("typeName");
	String threeTypeId =resultMsg.getValue("threeTypeId");
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
	
	//中间列表信息
	List<Map> midList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("midList"));
	
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

	function linkThirdListTotal(typeId,typeName){
			var threeTypeId="10801006";
		if(typeId.substr(0,3)==("106")){
			threeTypeId="10802006";
		}
		window.location.href="<%=contextPath%>/market/show/showSecondPageLike.srq?pageType=<%=pageType%>&&typeName="+typeName+"&&typeId="+typeId+"&&headingInfo=<%=headingInfo%>&&threeTypeId="+threeTypeId;
	}
	function linkTwoList(typeId,typeName,threeTypeId){
		window.location.href="<%=contextPath%>/market/show/viewListMore.srq?typeId="+threeTypeId+"&&typeName="+typeName+"&&orgId="+typeId;	
	}
	function linkThirdList(typeId,threeTypeId,typeName){
		window.location.href="<%=contextPath%>/market/show/showSecondPageLike.srq?pageType=<%=pageType%>&&typeName="+typeName+"&&typeId="+typeId+"&&headingInfo=<%=headingInfo%>&&threeTypeId="+threeTypeId;
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
			window.location.href="<%=contextPath%>/market/show/showSecondPageLike.srq?pageType=<%=pageType%>&&typeName=公司简介&&typeId=10501001&&headingInfo=油公司信息&&threeTypeId=10801006";
		}else if(info=="jzhbdt"){
			window.location.href="<%=contextPath%>/market/show/showSecondPageLike.srq?pageType=<%=pageType%>&&typeName=公司简介&&typeId=10601001&&headingInfo=物探公司信息&&threeTypeId=10802006";
		}
	}
	
	function modifyTaskSkill(){
	
		var exceptionalSkillId = document.getElementById("skillId").value;
		var returnVlue=window.showModalDialog("<%=contextPath%>/market/addSkill.srq?typeId=" + <%=typeId %>,window,'height=440,width=580');
	}
	
	function modifyOrgInfo(){
		var returnValue = window.showModalDialog("<%=contextPath%>/market/editOrgInfo.srq?typeId=" + <%=typeId %>,window,'height=440,width=580');
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
<title>市场信息平台</title>
<link href="<%=contextPath%>/images/ma/style.css" rel="stylesheet" type="text/css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/images/ma/form.css" />
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
     	 	<li><a href="<%=contextPath%>/market/show/showSecondPageLike.srq?pageType=<%=pageType%>&&typeName=公司简介&&typeId=<%=code %>&&headingInfo=物探公司动态&&threeTypeId=10802006"  class="arrow" target="_self"><%=codeName%></a></li>
     	 	<%} %>
	  	</ul>
  </li>
</ul>
  </div>
  <div id="list_div" style="width: 784px">
   <table width="100%" border="0" cellspacing="0" cellpadding="0" >
      <tr>
        <td width="182" valign="top">
         <div id="right_div" style="padding-top: 0px;margin-left: 15px">
         <div style="width: 162px;float:left;height: 350px">
         <div id="gl_left_head" style="width: 165px">
		      <ul>
		        <li class="mleft"></li>
		        <li class="mbg" style="width: 117px"><span class="gl_mbx_text"><%=headingInfo%></span></li>
		        <li class="mright"></li>
		      </ul>
		  </div>
    		<div id="gl_left_botbox_short" >
				<%if(typeId.startsWith("105")) {
				%>
					<div <%if(threeTypeId.equals("10801006")){%>class="sel_notNews_short"<%}else{ %>class="notNews_short"<%} %>><a href="javascript:linkThirdList('<%=typeId %>','10801006','公司简介')">公司简介</a></div>
					<%if(typeId.equals("10501")||typeId.equals("10502")||typeId.equals("10503")||typeId.equals("10502013")||typeId.equals("10502012")||typeId.equals("10502011")||typeId.equals("10502010")||typeId.equals("10502009")||typeId.equals("10502008")||typeId.equals("10502007")||typeId.equals("10502005")||typeId.equals("10502004")||typeId.equals("10502001")||typeId.equals("10502002")||typeId.equals("10503001")||typeId.equals("10503002")||typeId.equals("10503003")||typeId.equals("10503004")||typeId.equals("10503005")){ %>
					<%}else{ %>
					<div <%if(threeTypeId.equals("10801001")){%>class="sel_notNews_short"<%}else{ %>class="notNews_short"<%} %>><a href="javascript:linkThirdList('<%=typeId %>','10801001','规划部署')">规划部署</a></div>
					<div <%if(threeTypeId.equals("10801002")){%>class="sel_notNews_short"<%}else{ %>class="notNews_short"<%} %>><a href="javascript:linkThirdList('<%=typeId %>','10801002','最新动态')">最新动态</a></div>
					<div <%if(threeTypeId.equals("10801003")){%>class="sel_notNews_short"<%}else{ %>class="notNews_short"<%} %>><a href="javascript:linkThirdList('<%=typeId %>','10801003','客户管理')">客户管理</a></div>
					<%} %>
				<%} else if(typeId.startsWith("106")){%>
					<div <%if(threeTypeId.equals("10802006")){%>class="sel_notNews_short"<%}else{ %>class="notNews_short"<%} %>><a href="javascript:linkThirdList('<%=typeId %>','10802006','公司简介')">公司简介</a></div>
					<%if(typeId.startsWith("10601")||typeId.endsWith("10602001")||typeId.startsWith("10605")){ %>
					<div <%if(threeTypeId.equals("10802001")){%>class="sel_notNews_short"<%}else{ %>class="notNews_short"<%} %>><a href="javascript:linkThirdList('<%=typeId %>','10802001','技术装备能力')">技术装备能力</a></div>
					<div <%if(threeTypeId.equals("10802002")){%>class="sel_notNews_short"<%}else{ %>class="notNews_short"<%} %>><a href="javascript:linkThirdList('<%=typeId %>','10802002','最新动态')">最新动态</a></div>
					<div <%if(threeTypeId.equals("10802003")){%>class="sel_notNews_short"<%}else{ %>class="notNews_short"<%} %>><a href="javascript:linkThirdList('<%=typeId %>','10802003','人员状况')">人员状况</a></div>
					<%}else{ }%>
				<%} %>
			</div>
			</div>
    	</div>
    	</div>
  		</td>
  	 <td valign="top" align="left" style="height: auto">
  	 <div id="gl_news_mbx_fen2" style="margin-left: 10px;width: 580px">
        <ul>
          <li class="mleft"></li>
          <%if(threeTypeId.equals("10801002")||threeTypeId.equals("10801001")||threeTypeId.equals("10802002")){ %>
         <li class="mbg" style="width: 565px"><span class="mbx_text"><%=typeName %></span><span class="more_text" style="margin-left: 460px;"><a href="javascript:linkTwoList('<%=typeId %>','<%=typeName%>','<%=threeTypeId%>')">MORE</a></span></li>
		  <%}else{ %>
          <li class="mbg" style="width: 565px"><span class="mbx_text"><%=typeName %></span></li>
          <%} %>
          <li class="mright"></li>
        </ul>
    </div>
   <div style="display: block">
  <!--   <div id="main_content_fen2" style="overflow-x:hidden;overflow-y: auto;height: 580px;width: 610px;"> -->
    <div id="main_content_fen2">
    	<div id="infofen2" style="height:auto; width: 580px;padding-left: 10px">
    	
    		<%if(threeTypeId.equals("10801006")||threeTypeId.equals("10802006")){
    			if(resultMsg.getMsgElement("mapOrgInfo")!=null){%>
			 <table style="s">
				<tr class="odd">
				    <td class="inquire_item">&nbsp;公司全称:</td>
				    <td class="inquire_form"><%=mapOrgInfo.get("fullName") %>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			  	</tr>
			  	  <tr class="odd">
				  	<td class="inquire_item">&nbsp;公司简称:</td>
				    <td class="inquire_form">
				    <%=mapOrgInfo.get("shortName") %></td>
				</tr>
				<tr class="odd">
				  	<td class="inquire_item">&nbsp;公司地址:</td>
				    <td class="inquire_form"><%=mapOrgInfo.get("address") %>&nbsp;&nbsp;</td>
				</tr>
				<tr class="odd">
				    <td class="inquire_item">&nbsp;邮政编码:</td>
				    <td class="inquire_form"><%=mapOrgInfo.get("zipCode") %>&nbsp;&nbsp;</td>
			  	</tr>
				<tr class="odd">
				  	<td class="inquire_item">&nbsp;电话:</td>
				    <td class="inquire_form"><%=mapOrgInfo.get("phone") %>&nbsp;&nbsp;</td>
				</tr>
				<tr class="odd">
				    <td class="inquire_item">&nbsp;传真:</td>
				    <td class="inquire_form"><%=mapOrgInfo.get("fax") %>&nbsp;&nbsp;</td>
			 	</tr>
			 	<%if(typeId.startsWith("106")){%>
			 	<tr class="odd">
				    <td class="inquire_item">&nbsp;主营业务:</td>
				    <td class="inquire_form"> <%=mapOrgInfo.get("mainBusiness") %>  &nbsp;&nbsp;</td>
			 	</tr>
			 	<%}else{ %>
			 	<tr class="odd">
				    <td class="inquire_item">&nbsp;油田范围:</td>
				    <td class="inquire_form"> <%=mapOrgInfo.get("oilField") %>  &nbsp;&nbsp;</td>
			 	</tr>
			 	<%} %>
				<tr class="odd">
				  	<td class="inquire_item">&nbsp;公司简介:</td>
				    <td class="inquire_form"><%=mapOrgInfo.get("memo") %></td>
				</tr>
				<tr class="odd">
				<td  colspan="2" class="ali4">
				<oms_auth:button type="button" value="修改公司简介" css="iButton2" functionId="F_MA_020" event="onclick='modifyOrgInfo();'"/>&nbsp;&nbsp;&nbsp;&nbsp;
    			</td> 
    			</tr>
			</table>
			<%} else{
				if(typeId.startsWith("10606")){%>
			<%}else{ %>
    			没有信息<br>
    		<oms_auth:button type="button" value="修改公司简介" css="iButton2" functionId="F_MA_020" event="onclick='modifyOrgInfo();'"/>&nbsp;&nbsp;&nbsp;&nbsp;
    	<% }}}
    	
    	if(threeTypeId.equals("10801003")){%>
				<div>
					<iframe src= "<%=contextPath%>/market/showModel/showDepartment.jsp?typeId=<%=typeId %>" width="570px" height="450px" name= "window " allowtransparency="true"> </iframe>
				</div>
			<%}else if(threeTypeId.equals("10802003")){ %>
				<div>
					<iframe src= "<%=contextPath%>/market/showModel/showCompet.jsp?typeId=<%=typeId %>" width="570px" height="450px" name= "window1" allowtransparency="true"> </iframe>
				</div>
			<%} else if(threeTypeId.equals("10802001")){
					if (!mapOrgTech.equals("{}")){%>
				
				<div>
				<table >
				<input type="hidden" name="corpId" id="corpId" value="<%=typeId %>"></input>
				<input type="hidden" name="skillId" id="skillId" value="<%=(String)mapOrgTech.get("exceptionalSkillId") %>"></input>
				   <tr class="odd">
				  <td class="inquire_item">&nbsp;特色技术:</td>
				    <td class="inquire_form">
				      <%=exceptionalSkill%>
					</td>	
				  </tr>
				 <tr class="odd">
				  <td class="inquire_item">&nbsp;技术系列:</td>
				    <td class="inquire_form" >
				      <%=skillSeries %>
					</td>
				  </tr>	 
				 <td colspan="4" class="ali4">
				 <oms_auth:button type="button" value="修改技术装备能力信息" css="iButton2" functionId="F_MA_020" event="onclick='modifyTaskSkill();'"/>&nbsp;&nbsp;&nbsp;&nbsp;
    			</td> 
				  </table>
				</div>
					<%}%>
			<%}else if(threeTypeId.equals("10801001")||threeTypeId.equals("10801002")||threeTypeId.equals("10802002")){%>
         	<div class="infNews" style="width: 580px;padding-top: 0px;">
		    <div id="img1"></div>
		        <%
		         if(list!=null && list.size()>0){
		         	for(int j=0;j<list.size();j++){
		         		Map map=list.get(j).toMap();
		         		String  infomationName=(String)map.get("infomationName");
		         		if(infomationName!=null&&!"".equals(infomationName)&&infomationName.length()>30){
		        			infomationName=infomationName.substring(0,30)+"...";
		        		}
		         	%>
		      <div style="padding-bottom: 5px;padding-top: 5px;"><a style="width: 460px;" href="<%=contextPath %>/market/show/viewDetail.srq?id=<%=(String)map.get("infomationId") %>&&typeName=<%=typeName %>" target=_self><%=infomationName%></a><span class="time"><%=(String)map.get("releaseDate") %></span></div>
		         	<%
		         		}
		         	}
		         	%>
		      </div>
         	<%} %>
    	</div>
    </div>
    </div>
    
    </td>
  </tr>
    </table>
  </div>
  <div id="right_div" style="width: 200px">
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
			if(code.startsWith("105")||code.startsWith("106")){
				javascriptMethod="linkThirdListTotal";
			}
			String twoClass="notNews";
			if(code.equals(typeId)){
				twoClass="sel_notNews";
			}
			String twoDisplay="none";
			if(typeId.startsWith(code)) {
				twoDisplay="block";
			}
		%>
		<div  class="<%=twoClass %>"><a href="javascript:<%=javascriptMethod %>('<%=code%>','<%=codeName%>')" style="font-weight: bold"><%=codeName%></a></div>
		<div id="<%="twoList" + code%>" style="display: <%=twoDisplay%>">
			<%
				for (int j = 0; subList != null && j < subList.size(); j++) {
						Map subMap = (Map) subList.get(j);
						String subCode = (String) subMap.get("code");
						String subCodeName = (String) subMap.get("codeName");
						String twoClassSub="sub_notNews";
						if(typeId.equals("10504001")){
							typeId="10504";
						}
						if(subCode.equals(typeId)){
							twoClassSub="sub_sel_notNews";
						}
						
			%>
			<div class="<%=twoClassSub %>"><a style="width: 200px;" href="javascript:linkThirdList('<%=subCode%>','<%=subCode.startsWith("105")?"10801006":"10802006"%>','公司简介')"><%=subCodeName%></a></div>
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