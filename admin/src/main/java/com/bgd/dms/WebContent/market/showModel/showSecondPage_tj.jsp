<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="GBK"%>
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
	String userName = user.getUserName();
	String headingInfo = resultMsg.getValue("headingInfo");
	
	String pageType=resultMsg.getValue("pageType");
	String typeId=resultMsg.getValue("typeId");
	//�������б�
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
	//Ҷ�ӽڵ��б�
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
	
	//����logo�� �����˵��б�
	List<Map> sckfList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("sckfList"));
	List<Map> scglList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("scglList"));
	List<Map> ygsdtList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("ygsdtList"));
	List<Map> jzhbdtList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("jzhbdtList"));
	List<Map> tjfxList = MarketGetInfoUtil.getListMapFromListMsgElement(resultMsg.getMsgElements("tjfxList"));
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="<%=contextPath%>/images/ma/style.css" rel="stylesheet"
	type="text/css" />
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
	window.location.href="<%=contextPath%>/market/show/viewListTreeTj.srq?typeId="+typeId+"&&typeName="+typeName+"&&pageType=<%=pageType%>";	;	
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
		window.location.href="<%=contextPath%>/market/show/viewListTree.srq?typeId=10201001&&typeName=�г���ʵ��ֵ������&&pageType="+info;
	}else if(info=="sckf"){
		window.location.href="<%=contextPath%>/market/show/viewListTreeSckf.srq?pageType="+info;
	}else if(info=="scgl"){
		window.location.href="<%=contextPath%>/market/show/viewListTreeManage.srq?typeId=10401&&pageType=scgl&&typeName=��֯����&&threeTypeId=10401001";
	}else if(info=="ygsdt"){
		window.location.href="<%=contextPath%>/market/show/showSecondPageLike.srq?pageType=<%=pageType%>&&typeName=��˾���&&typeId=10501001&&headingInfo=�͹�˾��̬&&threeTypeId=10801006";
	}else if(info=="jzhbdt"){
		window.location.href="<%=contextPath%>/market/show/showSecondPageLike.srq?pageType=<%=pageType%>&&typeName=��˾���&&typeId=10601001&&headingInfo=��̽��˾��̬&&threeTypeId=10802006";
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
<title>�г���Ϣƽ̨</title>
</head>
<body>
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
  <li><a id="sy" <%if("sy".equals(pageType)){ %>class="select"<%} %> href="javascript: changeMainFrameDown('sy');" style="width:125px;"  target="_self">��ҳ</a></li>
  <li><a id="tjfx" <%if("tjfx".equals(pageType)){ %>class="select"<%} %> href="javascript: changeMainFrameDown('tjfx');" style="width:126px;" target="_self">ͳ�Ʒ���</a>
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
  <li><a id="sckf" <%if("sckf".equals(pageType)){ %>class="select"<%} %> href="javascript: changeMainFrameDown('sckf');" style="width:126px;" target="_self">�г�����</a>
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
  <li><a id="scgl" <%if("scgl".equals(pageType)){ %>class="select"<%} %> href="javascript: changeMainFrameDown('scgl');" style="width:126px;" class="arrow" target="_self">�г�����</a>
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
    <li><a id="ygsdt" <%if("ygsdt".equals(pageType)){ %>class="select"<%} %> href="javascript: changeMainFrameDown('ygsdt');" style="width:126px;" class="arrow" target="_self">�͹�˾��Ϣ</a>
    <ul  style="display: none;" id="subMusic" class="second-menu">
     	 	<% for(int i=0;ygsdtList!=null&&i<ygsdtList.size();i++) {
     	 		Map mapLogo=ygsdtList.get(i);
     	 		String code=(String)mapLogo.get("code");
     	 		String codeName=(String)mapLogo.get("codeName");
     	 	%>
     	 	<li><a href="<%=contextPath%>/market/show/showSecondPageLike.srq?pageType=<%=pageType%>&&typeName=��˾���&&typeId=<%=code %>&&headingInfo=�͹�˾��̬&&threeTypeId=10801006"  class="arrow" target="_self"><%=codeName%></a></li>
     	 	<%} %>
	  	</ul>
  </li>
  <li><a id="jzhbdt" <%if("jzhbdt".equals(pageType)){ %>class="select"<%} %> href="javascript: changeMainFrameDown('jzhbdt');" style="width:126px; border-right:none;" class="arrow" target="_self">��̽��˾��Ϣ</a>
   <ul  style="display: none;" id="subMusic" class="second-menu">
     	 	<% for(int i=0;jzhbdtList!=null&&i<jzhbdtList.size();i++) {
     	 		Map mapLogo=jzhbdtList.get(i);
     	 		String code=(String)mapLogo.get("code");
     	 		String codeName=(String)mapLogo.get("codeName");
     	 	%>
     	 	<li><a href="<%=contextPath%>/market/show/showSecondPageLike.srq?pageType=<%=pageType%>&&typeName=��˾���&&typeId=<%=code %>&&headingInfo=��̽��˾��̬&&threeTypeId=10802006"  class="arrow" target="_self"><%=codeName%></a></li>
     	 	<%} %>
	  	</ul>
  </li>
</ul>
  </div>
<div id="list_div" style="float: right">
<table width="100%" border="0" cellspacing="5" cellpadding="0">
	<%
		for (int i = 0; leafList != null && i < leafList.size();) {
			Map map = (Map) leafList.get(i);
			String code = (String) map.get("code");
			String codeName = (String) map.get("codeName");
			List subList = (List) mapLeaf.get("leafList" + code);

			List subListTwo = null;
			String codeTwo = "";
			String codeNameTwo = "";
			
			i=i+1;
			
			if(i<leafList.size()){
				Map mapTwo = (Map) leafList.get(i);
				codeTwo = (String) mapTwo.get("code");
				codeNameTwo = (String) mapTwo.get("codeName");
				subListTwo = (List) mapLeaf.get("leafList" + codeTwo);
				i=i+1;
			}
			
	%>
	<tr>
		<td>
		<%
			if (subList != null) {
		%>

		<div id="gl_news_mbx_fen">
		<ul>
			<li class="mleft"></li>
			<li class="mbg"><span class="mbx_text"><%=codeName%></span><a href="javascript:linkTwoList('<%=code%>','<%=codeName%>')" style="float: right"><span class="mbx_text_more">MORE</span></a></li>
			<li class="mright"></li>
		</ul>
		</div>
		<div id="main_content_fen">
		<div id="infofen">
		<%
			for (int j = 0; subList != null && j < subList.size(); j++) {
						Map subMap = (Map) subList.get(j);
						String infomationName = (String) subMap.get("infomationName");
						String releaseDate = (String) subMap.get("releaseDate");
						String infomationId = (String) subMap.get("infomationId");
		%>
		<div class="infNews">
		<div id="img1"></div>
		<a
			href="javascript:linkThirdDetail('<%=infomationId%>','<%=codeName%>')"><%=infomationName%></a><span
			class="time"><%=releaseDate%></span></div>
		<%
			}
		%>
		</div>
		</div>

		<%
			}
		%>
		</td>
		<td>
		<%
			if (subListTwo != null) {
		%>

		<div id="gl_news_mbx_fen">
		<ul>
			<li class="mleft"></li>
			<li class="mbg"><span class="mbx_text"><%=codeNameTwo%></span><a href="javascript:linkTwoList('<%=codeTwo%>','<%=codeNameTwo%>' )" style="float: right"><span class="mbx_text_more">MORE</span></a></li>
			<li class="mright"></li>
		</ul>
		</div>
		<div id="main_content_fen">
		<div id="infofen">
		<%
			for (int j = 0; subListTwo != null && j < subListTwo.size(); j++) {
						Map subMap = (Map) subListTwo.get(j);
						String infomationName = (String) subMap.get("infomationName");
						String releaseDate = (String) subMap.get("releaseDate");
						String infomationId = (String) subMap.get("infomationId");
		%>
		<div class="infNews">
		<div id="img1"></div>
		<a
			href="javascript:linkThirdDetail('<%=infomationId%>','<%=codeNameTwo%>')"><%=infomationName%></a><span
			class="time"><%=releaseDate%></span></div>
		<%
			}
		%>
		</div>
		</div>

		<%
			}
		%>
		</td>
	</tr>
	<%
		}
	%>
</table>
</div>
<div id="right_div" style="width: 280px">
<div id="gl_left_head">
<ul>
	<li class="mleft"></li>
	<li class="mbg"><span class="gl_mbx_text"><%=headingInfo%></span></li>
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
		<div class="<%=twoClass %>"><a href="javascript:<%=javascriptMethod %>('<%=code%>','<%=codeName%>')"><%=codeName%></a></div>
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
				<div class="third_notNews"><a href="javascript:linkThirdList('<%=subCode %>','10801001','�滮����')">�滮����</a></div>
				<div class="third_notNews"><a href="javascript:linkThirdList('<%=subCode %>','10801002','��������')">��������</a></div>
				<div class="third_notNews"><a href="javascript:linkThirdList('<%=subCode %>','10801003','�ͻ�����')">�ͻ�����</a></div>
				<div class="third_notNews"><a href="javascript:linkThirdList('<%=subCode %>','10801004','��ҵ����')">��ҵ����</a></div>
				<div class="third_notNews"><a href="javascript:linkThirdList('<%=subCode %>','10801005','������̬')">������̬</a></div>
				<%} else if(subCode.startsWith("106")){%>
				<div class="third_notNews"><a href="javascript:linkThirdList('<%=subCode %>','10802001','����װ������')">����װ������</a></div>
				<div class="third_notNews"><a href="javascript:linkThirdList('<%=subCode %>','10802002','������鶯̬����')">������鶯̬����</a></div>
				<div class="third_notNews"><a href="javascript:linkThirdList('<%=subCode %>','10802003','����������')">����������</a></div>
				<div class="third_notNews"><a href="javascript:linkThirdList('<%=subCode %>','10802004','����ԭ�ͼ۸�')">����ԭ�ͼ۸�</a></div>
				<div class="third_notNews"><a href="javascript:linkThirdList('<%=subCode %>','10802005','����Ա�')">����Ա�</a></div>
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
	<div class="copy_img"></div><a href="">��Ȩ���У��й�ʯ�ͼ��Ŷ�����������˾</a>
</div>
</div>
</body>
</html>