<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String userName=user.getUserName();
	String userId = resultMsg.getValue("userId");
	String orgId = resultMsg.getValue("orgId");
	
	String countguoji1 = resultMsg.getValue("countguoji1");
	String countguoji2 = resultMsg.getValue("countguoji2");
	String countguoji3 = resultMsg.getValue("countguoji3");
	int countguojiSum = Integer.parseInt(countguoji1)+Integer.parseInt(countguoji2)+Integer.parseInt(countguoji3);
	
	String countyanjiuyuan1 = resultMsg.getValue("countyanjiuyuan1");
	String countyanjiuyuan2 = resultMsg.getValue("countyanjiuyuan2");
	String countyanjiuyuan3 = resultMsg.getValue("countyanjiuyuan3");
	int countyanjiuyuanSum = Integer.parseInt(countyanjiuyuan1)+Integer.parseInt(countyanjiuyuan2)+Integer.parseInt(countyanjiuyuan3);
	
	String counttalimu1 = resultMsg.getValue("counttalimu1");
	String counttalimu2 = resultMsg.getValue("counttalimu2");
	String counttalimu3 = resultMsg.getValue("counttalimu3");
	int counttalimuSum = Integer.parseInt(counttalimu1)+Integer.parseInt(counttalimu2)+Integer.parseInt(counttalimu3);
	
	String countxinjiang1 = resultMsg.getValue("countxinjiang1");
	String countxinjiang2 = resultMsg.getValue("countxinjiang2");
	String countxinjiang3 = resultMsg.getValue("countxinjiang3");
	int countxinjiangSum = Integer.parseInt(countxinjiang1)+Integer.parseInt(countxinjiang2)+Integer.parseInt(countxinjiang3);
	
	String counttuha1 = resultMsg.getValue("counttuha1");
	String counttuha2 = resultMsg.getValue("counttuha2");
	String counttuha3 = resultMsg.getValue("counttuha3");
	int counttuhaSum = Integer.parseInt(counttuha1)+Integer.parseInt(counttuha2)+Integer.parseInt(counttuha3);
	
	String countqinghai1 = resultMsg.getValue("countqinghai1");
	String countqinghai2 = resultMsg.getValue("countqinghai2");
	String countqinghai3 = resultMsg.getValue("countqinghai3");
	int countqinghaiSum = Integer.parseInt(countqinghai1)+Integer.parseInt(countqinghai2)+Integer.parseInt(countqinghai3);
	
	String countchangqing1 = resultMsg.getValue("countchangqing1");
	String countchangqing2 = resultMsg.getValue("countchangqing2");
	String countchangqing3 = resultMsg.getValue("countchangqing3");
	int countchangqingSum = Integer.parseInt(countchangqing1)+Integer.parseInt(countchangqing2)+Integer.parseInt(countchangqing3);
	
	String countdagang1 = resultMsg.getValue("countdagang1");
	String countdagang2 = resultMsg.getValue("countdagang2");
	String countdagang3 = resultMsg.getValue("countdagang3");
	int countdagangSum = Integer.parseInt(countdagang1)+Integer.parseInt(countdagang2)+Integer.parseInt(countdagang3);
	
	String countliaohe1 = resultMsg.getValue("countliaohe1");
	String countliaohe2 = resultMsg.getValue("countliaohe2");
	String countliaohe3 = resultMsg.getValue("countliaohe3");
	int countliaoheSum = Integer.parseInt(countliaohe1)+Integer.parseInt(countliaohe2)+Integer.parseInt(countliaohe3);
	
	String counthuabei1 = resultMsg.getValue("counthuabei1");
	String counthuabei2 = resultMsg.getValue("counthuabei2");
	String counthuabei3 = resultMsg.getValue("counthuabei3");
	int counthuabeiSum = Integer.parseInt(counthuabei1)+Integer.parseInt(counthuabei2)+Integer.parseInt(counthuabei3);
	
	String countxinxing1 = resultMsg.getValue("countxinxing1");
	String countxinxing2 = resultMsg.getValue("countxinxing2");
	String countxinxing3 = resultMsg.getValue("countxinxing3");
	int countxinxingSum = Integer.parseInt(countxinxing1)+Integer.parseInt(countxinxing2)+Integer.parseInt(countxinxing3);
	
	String countzonghe1 = resultMsg.getValue("countzonghe1");
	String countzonghe2 = resultMsg.getValue("countzonghe2");
	String countzonghe3 = resultMsg.getValue("countzonghe3");
	int countzongheSum = Integer.parseInt(countzonghe1)+Integer.parseInt(countzonghe2)+Integer.parseInt(countzonghe3);
	
	String countxinxi1 = resultMsg.getValue("countxinxi1");
	String countxinxi2 = resultMsg.getValue("countxinxi2");
	String countxinxi3 = resultMsg.getValue("countxinxi3");
	int countxinxiSum = Integer.parseInt(countxinxi1)+Integer.parseInt(countxinxi2)+Integer.parseInt(countxinxi3);
	
	String countyingluowa1 = resultMsg.getValue("countyingluowa1");
	String countyingluowa2 = resultMsg.getValue("countyingluowa2");
	String countyingluowa3 = resultMsg.getValue("countyingluowa3");
	int countyingluowaSum = Integer.parseInt(countyingluowa1)+Integer.parseInt(countyingluowa2)+Integer.parseInt(countyingluowa3);
	
	String countxian1 = resultMsg.getValue("countxian1");
	String countxian2 = resultMsg.getValue("countxian2");
	String countxian3 = resultMsg.getValue("countxian3");
	int countxianSum = Integer.parseInt(countxian1)+Integer.parseInt(countxian2)+Integer.parseInt(countxian3);
	
	int countSum = countguojiSum+countyanjiuyuanSum+counttalimuSum+countxinjiangSum+counttuhaSum+countqinghaiSum+countchangqingSum+countdagangSum+countliaoheSum+counthuabeiSum+countxinxingSum+countzongheSum+countxinxiSum+countyingluowaSum+countxianSum;
	int countSum1 = Integer.parseInt(countguoji1)+Integer.parseInt(countyanjiuyuan1)+Integer.parseInt(counttalimu1)+Integer.parseInt(countxinjiang1)+Integer.parseInt(counttuha1)+Integer.parseInt(countqinghai1)+Integer.parseInt(countchangqing1)+Integer.parseInt(countliaohe1)+Integer.parseInt(countdagang1)+Integer.parseInt(counthuabei1)+Integer.parseInt(countxinxing1)+Integer.parseInt(countzonghe1)+Integer.parseInt(countxinxi1)+Integer.parseInt(countyingluowa1)+Integer.parseInt(countxian1);
	int countSum2 = Integer.parseInt(countguoji2)+Integer.parseInt(countyanjiuyuan2)+Integer.parseInt(counttalimu2)+Integer.parseInt(countxinjiang2)+Integer.parseInt(counttuha2)+Integer.parseInt(countqinghai2)+Integer.parseInt(countchangqing2)+Integer.parseInt(countliaohe2)+Integer.parseInt(countdagang2)+Integer.parseInt(counthuabei2)+Integer.parseInt(countxinxing2)+Integer.parseInt(countzonghe2)+Integer.parseInt(countxinxi2)+Integer.parseInt(countyingluowa2)+Integer.parseInt(countxian2);
	int countSum3 = Integer.parseInt(countguoji3)+Integer.parseInt(countyanjiuyuan3)+Integer.parseInt(counttalimu3)+Integer.parseInt(countxinjiang3)+Integer.parseInt(counttuha3)+Integer.parseInt(countqinghai3)+Integer.parseInt(countchangqing3)+Integer.parseInt(countliaohe3)+Integer.parseInt(countdagang3)+Integer.parseInt(counthuabei3)+Integer.parseInt(countxinxing3)+Integer.parseInt(countzonghe3)+Integer.parseInt(countxinxi3)+Integer.parseInt(countyingluowa3)+Integer.parseInt(countxian3);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/images/ma/weekStyle.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/js/bgpmcs/DivHiddenOpen.js"></script>
<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>
<%@ include file="/common/pmd_list.jsp"%>
<title>项目明细填报</title>
</head>

<script type="text/javascript" src="/BGPMCS/js/calendar.js"></script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
<script type="text/javascript" src="/BGPMCS/js/calendar-setup.js"></script>
</head>
<body>
<div id="right_div_left">
     <div id="gl_left_botbox" style="margin-left: 10px">
    	<div class="notNews" style="width: 200px;"><a  style="width: 200px" href="javascript:linkThirdList('300')"><span class="mbx_text"><font color="black">东方地球物理公司</font></span></a></div>
			<div <%if(orgId.equals("306")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('306')">国际勘探事业部</a></div>
			<div <%if(orgId.equals("180")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('180')">研究院</a></div>
			<div <%if(orgId.equals("319")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('319')">塔里木物探处</a></div>
			<div <%if(orgId.equals("320")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('320')">新疆物探处</a></div>
			<div <%if(orgId.equals("321")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('321')">吐哈物探处</a></div>
			<div <%if(orgId.equals("322")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('322')">青海物探处</a></div>
			<div <%if(orgId.equals("8ad878cd2cf41a23012d02f4e7ec00c3")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('8ad878cd2cf41a23012d02f4e7ec00c3')">长庆物探处</a></div>
			<div <%if(orgId.equals("308")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('308')">大港物探处</a></div>
			<div <%if(orgId.equals("323")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('323')">辽河物探处</a></div>
			<div <%if(orgId.equals("8ad878cd2cf41a23012d02f53ff000c4")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('8ad878cd2cf41a23012d02f53ff000c4')">华北物探处</a></div>
			<div <%if(orgId.equals("8ad878cd2d11f476012d2553db8a0435")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('8ad878cd2d11f476012d2553db8a0435')">新兴物探开发处</a></div>
			<div <%if(orgId.equals("309")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('309')">综合物化探处</a></div>
			<div <%if(orgId.equals("8ad878cd2e765396012eb2394b5201aa")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('8ad878cd2e765396012eb2394b5201aa')">信息技术中心</a></div>
			<div <%if(orgId.equals("8ad878cd2e765396012eb23bf93801ae")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('8ad878cd2e765396012eb23bf93801ae')">英洛瓦物探装备</a></div>
			<div <%if(orgId.equals("123")){%>class="sub_sel_notNews"<%}else{ %>class="sub_notNews"<%} %>>
			<a href="javascript:linkThirdList('123')">西安装备分公司</a></div>
		</div>
</div>
<div id="list_div" style="width: auto;margin-right: 10px">
<div id="rtToolbarDiv">
<table border="0"  cellpadding="0"  cellspacing="0"  class="rtToolbar"  width="100%" >
	<tr>
		<td align="right" >
			<span id="dataRowHint"> </span>
			<table id="navTableId" border="0"  cellpadding="0"  cellspacing="0" style="display:inline">
				<tr>
					<td><img src="<%=contextPath%>/images/table/firstPageDisabled.gif"  style="border:0"  alt="First" /></td>
					<td><img src="<%=contextPath%>/images/table/prevPageDisabled.gif"  style="border:0"  alt="Prev" /></td>
					<td><img src="<%=contextPath%>/images/table/nextPageDisabled.gif"  style="border:0"  alt="Next" /></td>
					<td><img src="<%=contextPath%>/images/table/lastPageDisabled.gif"  style="border:0"  alt="Last" /></td>				
				</tr>
			</table>
			<span>到&nbsp;<input type="text"  id="changePage"  class="rtToolbar_chkboxme">&nbsp;页<a href='javascript:changePage()'><img src='<%=contextPath%>/images/table/bullet_go.gif' alt='Go' align="absmiddle" /></a></span>		
		</td>
	</tr>
</table>
</div>
<div id="resultable"  style="width:100%; overflow-x:scroll ;" >
<table border="0"  cellspacing="0"  cellpadding="0"  class="form_info"  width="100%" id="queryRetTable">
	<tr class="bt_info">
	    <td class="tableHeader">单位名称</td>
	    <td class="tableHeader">队伍总数</td>
	    <td class="tableHeader">正在施工队伍数</td>
	    <td class="tableHeader">闲置队伍数</td>
	    <td class="tableHeader">准备启动队伍数</td>
    </tr> 
    <tr class="even">
      <td><a href="javascript:linkThirdList('306')"><font color="#3366ff">国际勘探事业部</font></a></td>
      <td><%=countguojiSum %></td>
      <td><%=countguoji1 %></td>
      <td><%=countguoji2 %></td>
      <td><%=countguoji3 %></td>
    </tr>
    <tr class="odd">
      <td><a href="javascript:linkThirdList('180')"><font color="#3366ff">研究院</a></td>
      <td><%=countyanjiuyuanSum %></td>
      <td><%=countyanjiuyuan1 %></td>
      <td><%=countyanjiuyuan2 %></td>
      <td><%=countyanjiuyuan3 %></td>
    </tr>
    <tr class="even">
      <td><a href="javascript:linkThirdList('319')"><font color="#3366ff">塔里木物探处</a></td>
      <td><%=counttalimuSum %></td>
      <td><%=counttalimu1 %></td>
      <td><%=counttalimu2 %></td>
      <td><%=counttalimu3 %></td>
    </tr>
    <tr class="odd">
      <td><a href="javascript:linkThirdList('320')"><font color="#3366ff">新疆物探处</a></td>
      <td><%=countxinjiangSum %></td>
      <td><%=countxinjiang1 %></td>
      <td><%=countxinjiang2 %></td>
      <td><%=countxinjiang3 %></td>
    </tr>
    <tr class="even">
      <td><a href="javascript:linkThirdList('321')"><font color="#3366ff">吐哈物探处</a></td>
      <td><%=counttuhaSum %></td>
      <td><%=counttuha1 %></td>
      <td><%=counttuha2 %></td>
      <td><%=counttuha3 %></td>
    </tr>
    <tr class="odd">
      <td><a href="javascript:linkThirdList('322')"><font color="#3366ff">青海物探处</a></td>
      <td><%=countqinghaiSum %></td>
      <td><%=countqinghai1 %></td>
      <td><%=countqinghai2 %></td>
      <td><%=countqinghai3 %></td>
    </tr>
    <tr class="even">
      <td><a href="javascript:linkThirdList('8ad878cd2cf41a23012d02f4e7ec00c3')"><font color="#3366ff">长庆物探处</a></td>
      <td><%=countchangqingSum %></td>
      <td><%=countchangqing1 %></td>
      <td><%=countchangqing2 %></td>
      <td><%=countchangqing3 %></td>
    </tr>
    <tr class="odd">
      <td><a href="javascript:linkThirdList('308')"><font color="#3366ff">大港物探处</font></a></td>
      <td><%=countdagangSum %></td>
      <td><%=countdagang1 %></td>
      <td><%=countdagang2 %></td>
      <td><%=countdagang3 %></td>
    </tr>
    <tr class="even">
      <td><a href="javascript:linkThirdList('323')"><font color="#3366ff">辽河物探处</font></a></td>
      <td><%=countliaoheSum %></td>
      <td><%=countliaohe1 %></td>
      <td><%=countliaohe2 %></td>
      <td><%=countliaohe3 %></td>
    </tr>
    <tr class="odd">
      <td><a href="javascript:linkThirdList('8ad878cd2cf41a23012d02f53ff000c4')"><font color="#3366ff">华北物探处</font></a></td>
      <td><%=counthuabeiSum %></td>
      <td><%=counthuabei1 %></td>
      <td><%=counthuabei2 %></td>
      <td><%=counthuabei3 %></td>
    </tr>
    <tr class="even">
      <td><a href="javascript:linkThirdList('8ad878cd2d11f476012d2553db8a0435')"><font color="#3366ff">新兴物探开发处</font></a></td>
      <td><%=countxinxingSum %></td>
      <td><%=countxinxing1 %></td>
      <td><%=countxinxing2 %></td>
      <td><%=countxinxing3 %></td>
    </tr>
    <tr class="odd">
      <td><a href="javascript:linkThirdList('309')"><font color="#3366ff">综合物化探处</font></a></td>
      <td><%=countzongheSum %></td>
      <td><%=countzonghe1 %></td>
      <td><%=countzonghe2 %></td>
      <td><%=countzonghe3 %></td>
    </tr>
    <tr class="even">
      <td><a href="javascript:linkThirdList('8ad878cd2e765396012eb2394b5201aa')"><font color="#3366ff">信息技术中心</font></a></td>
      <td><%=countxinxiSum %></td>
      <td><%=countxinxi1 %></td>
      <td><%=countxinxi2 %></td>
      <td><%=countxinxi3 %></td>
    </tr>
    <tr class="odd">
      <td><a href="javascript:linkThirdList('8ad878cd2e765396012eb23bf93801ae')"><font color="#3366ff">英洛瓦物探装备</font></a></td>
      <td><%=countyingluowaSum %></td>
      <td><%=countyingluowa1 %></td>
      <td><%=countyingluowa2 %></td>
      <td><%=countyingluowa3 %></td>
    </tr>
    <tr class="even">
      <td><a href="javascript:linkThirdList('123')"><font color="#3366ff">西安装备分公司</font></a></td>
      <td><%=countxianSum %></td>
      <td><%=countxian1 %></td>
      <td><%=countxian2 %></td>
      <td><%=countxian3 %></td>
    </tr>
    <tr class="odd">
      <td>东方公司</td>
      <td><%=countSum %></td>
      <td><%=countSum1 %></td>
      <td><%=countSum2 %></td>
      <td><%=countSum3 %></td>
    </tr>
</table>
</div>
</div>
</body>
<script language="javaScript">

function linkThirdList(orgId){
	window.location="<%=contextPath%>/market/startTeamDynamic.srq?orgId="+orgId;
}
function classicQuery(){
	document.getElementById("form1").submit();
}

</script>
</html>
