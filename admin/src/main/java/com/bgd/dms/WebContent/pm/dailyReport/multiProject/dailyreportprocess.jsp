<%@page import="com.cnpc.jcdp.soa.msg.MsgElementImpl"%>
<%@page import="java.util.List,com.bgp.mcs.service.pm.service.project.DailyReportProcessRatePOJO" contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
	String contextPath = request.getContextPath();	
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String projectNo = user.getProjectInfoNo();
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="<%=contextPath%>/styles/table.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="<%=contextPath%>/styles/extremecomponents.css" type="text/css">
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/styles/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/validator.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<title>日报进度查看</title>
<style type="text/css">

*{font-size:12px;}
ul{list-style:none;margin:0;padding:0;}

.ttl{height:18px;}
.ctt1{width:775px;height:auto;float:left;clear:both;border:1px solid #c2d9f9;background:#fff url(<%=contextPath %>/images/ju_26.jpg) repeat-x bottom;text-align:left;margin-top:-1px;}
.w500{clear:both;width:570px;text-align:center;}

.tbj_{float:left}
.tbj_ ul{height:20px;}
.tbj_ li{float:left;height:20px;line-height:20px;width:112px;cursor:pointer; padding-left:1px;}

.normaltabj{color:#666;background:#fff url(<%=contextPath %>/images/gpeimages/222.gif) no-repeat bottom;}
.hovertabj{color:#fff;font-weight:bold;background:#fff url(<%=contextPath %>/images/gpeimages/11.gif) no-repeat bottom; border-left:0;}
.disj{display:block;}
.undisj{display:none;}


</style>
<script type="text/javascript">
function g(o){
	return document.getElementById(o);
}
function HoverLij(m){
	if(m==2){
		g('tbj_3').className='normaltabj';
		g('3d').className='undisj';
		g('tbj_2').className='hovertabj';
		g('2d').className='disj';
	}else{
		g('tbj_2').className='normaltabj';
		g('2d').className='undisj';
		g('tbj_3').className='hovertabj';
		g('3d').className='disj';
	}
}
</script>
<script type="text/javascript">

	
	var totalRows2 = '<%=resultMsg.getValue("totalRows")!=null?resultMsg.getValue("totalRows"):0%>';
	var pageSize = '<%=resultMsg.getValue("pageSize")!=null?resultMsg.getValue("pageSize"):0%>';
	var cur ='<%=resultMsg.getValue("cur")!=null?resultMsg.getValue("cur"):0%>';
	var projectInfoNo ='<%=resultMsg.getValue("projectInfoNo")!=null?resultMsg.getValue("projectInfoNo"):""%>';
	var explorationMethod ='<%=resultMsg.getValue("explorationMethod")!=null?resultMsg.getValue("explorationMethod"):""%>';
	
	function firstPage() {
		if(cur==1) {
		
			alert("已是最前页！");
			return;
		} else {

			var form = document.forms[0];
			form.action="<%=contextPath%>/pm/dailyReport/queryDailyReportProcess.srq?cur=1&projectInfoNo="+projectInfoNo+"&explorationMethod="+explorationMethod;
			form.submit();		
		}
	}
	
	function lastPage() {
		if(cur==1) {
		
			alert("已是最前页，没有上一页！");
			return;
		} else {
		
			cur=parseInt(cur)-1;
			
			var form = document.forms[0];
			form.action="<%=contextPath%>/pm/dailyReport/queryDailyReportProcess.srq?cur="+cur+"&projectInfoNo="+projectInfoNo+"&explorationMethod="+explorationMethod;
			form.submit();		
		}
	}
	
	function nextPage() {
		
		var totalPages;
		
		
		totalRows = totalRows2;

		
		if(parseInt(totalRows)%parseInt(pageSize) == 0) {
		
			totalPages =parseInt(totalRows)/parseInt(pageSize);
		} else {
		
			totalPages = Math.ceil(parseInt(totalRows)/parseInt(pageSize));
		}
		
		if(cur==totalPages || totalPages==0) {
		
			alert("已是最后一页,没有下一页！");
			return;
		} else {
		
			cur = parseInt(cur)+1;
			
			var form = document.forms[0];
			form.action="<%=contextPath%>/pm/dailyReport/queryDailyReportProcess.srq?cur="+cur+"&projectInfoNo="+projectInfoNo+"&explorationMethod="+explorationMethod;
			form.submit();		
		}
	}
	
	function finalPage() {
	
		var totalPages;
		var totalRows = totalRows2;
		
		if(parseInt(totalRows)%parseInt(pageSize) == 0) {	
			
			totalPages = parseInt(totalRows)/parseInt(pageSize);
		} else {		
		
			totalPages = Math.ceil(parseInt(totalRows)/parseInt(pageSize));
		}	
		
		if(cur==totalPages || totalPages==0) {
		
			alert("已是最后一页！");
			return;
		} else {

			var form = document.forms[0];		
			form.action="<%=contextPath%>/pm/dailyReport/queryDailyReportProcess.srq?cur="+totalPages+"&projectInfoNo="+projectInfoNo+"&explorationMethod="+explorationMethod;
			form.submit();		
		}
	}
</script>
</head>

<body>
<table border="0" cellpadding="0" cellspacing="0" class="toolbar" width="100%" >
	<tr class="bt_info">
	<td align="left">找到 <%=resultMsg.getValue("totalRows")!=null?resultMsg.getValue("totalRows"):0%> 条记录,每页  <%=resultMsg.getValue("pageSize")!=null?resultMsg.getValue("pageSize"):0%> 条,当前第 <%=resultMsg.getValue("cur")!=null?resultMsg.getValue("cur"):0%> 页&nbsp;&nbsp;</td>
	<td><img src="<%=contextPath%>/images/table/firstPageDisabled.gif"  style="border:0"  alt="第一页" onclick="firstPage()"  style="cursor:hand;"/></td>
	<td><img src="<%=contextPath%>/images/table/prevPageDisabled.gif"  style="border:0"  alt="上一页" onclick="lastPage()"  style="cursor:hand;"/></td>
	<td><img src="<%=contextPath%>/images/table/nextPageDisabled.gif"  style="border:0"  alt="下一页" onclick="nextPage()" style="cursor:hand;"/></td>
	<td><img src="<%=contextPath%>/images/table/lastPageDisabled.gif"  style="border:0"  alt="最后页" onclick="finalPage()"  style="cursor:hand;"/></td>
	</tr>
</table>
<form action="" method="post">

<table border="0" cellpadding="0" cellspacing="0" class="Tab_page_title">
	<tr class="Tab_page_title">
		<td colspan="4" class="Tab_Header">生产进度查看</td>
	</tr>
</table>

<table cellpadding="" cellspacing="" class="tab_info" >
	<tr bgcolor="#daedf0" >
		<td rowspan="2" align="center">生产日期</td>
		<td colspan="3" align="center">采集工作量</td>
		<td colspan="3" align="center">钻井工作量</td>
		<td colspan="3" align="center">表层调查工作量</td>
		<td colspan="4" align="center">测量工作量</td>
	</tr>
	<tr bgcolor="#daedf0">
		<td align="center">日完成炮数</td>
		<td align="center">项目累计</td>
		<td align="center">完成比例</td>
		<td align="center">日完成炮数</td>
		<td align="center">项目累计</td>
		<td align="center">完成比例</td>
		<td align="center">日完成点数</td>
		<td align="center">项目累计</td>
		<td align="center">完成比例</td>
		<td align="center">日完成炮点数</td>
		<td align="center">日完成检波点数</td>
		<td align="center">项目累计</td>
		<td align="center">完成比例</td>
	</tr>
<%
	List list = resultMsg.getMsgElements("totalList");
	//List list = (List)request.getAttribute("totalList");
	
	if(list!=null && !list.isEmpty()) {
	
		String sl = "ali7";
		
		for(int i=0; i<list.size(); i++){
			MsgElement dailyReportProcess = (MsgElement)list.get(i);
						
%>
	<tr class="<%=sl%>">
		<td align="center" height="31"><%=dailyReportProcess.getValue("productDate")%>&nbsp;</td>
		<td align="center"><%=dailyReportProcess.getValue("collShotNum")%>&nbsp;</td>
		<td align="center"><%=dailyReportProcess.getValue("collFinishedSpNum")%>&nbsp;</td>
		<td align="left">
<%
			String collFinishedRate= dailyReportProcess.getValue("collFinishedRate");
			
			
			if(collFinishedRate!=null && !collFinishedRate.equals("")) {
%>
			<input type="text" style="width:<%=collFinishedRate%>px;height:13px;background-color:#0000FF;border:0" name="textfield2"><br><font style="font-size:12px">完成<%=collFinishedRate%>%</font>&nbsp;
<%
			}
%>
		&nbsp;
		</td>
		<td align="center"><%=dailyReportProcess.getValue("drillShotNum")%>&nbsp;</td>
		<td align="center"><%=dailyReportProcess.getValue("drillFinishedSpNum")%>&nbsp;</td>
		<td align="left">
<%
			String drillFinishedRate=dailyReportProcess.getValue("drillFinishedRate");
		
			if(drillFinishedRate!=null && !drillFinishedRate.equals("")) {
%>
			<input type="text" style="width:<%=drillFinishedRate%>px;height:13px;background-color:#0000FF;border:0" name="textfield2"><br><font style="font-size:12px">完成<%=drillFinishedRate%>%</font>&nbsp;
<%
			}
%>
		&nbsp;</td>
		<td align="center"><%=dailyReportProcess.getValue("surfacePointNo")%>&nbsp;</td>
		<td align="center"><%=dailyReportProcess.getValue("surfaceFinishedSpNum")%>&nbsp;</td>
		<td align="left">
<%
			String surfaceFinishedRate=dailyReportProcess.getValue("surfaceFinishedRate");
			
			if(surfaceFinishedRate!=null && !surfaceFinishedRate.equals("")) {
%>
			<input type="text" style="width:<%=surfaceFinishedRate%>px;height:13px;background-color:#0000FF;border:0" name="textfield2"><br><font style="font-size:12px">完成<%=surfaceFinishedRate%>%</font>&nbsp;
<%
			}
%>
		&nbsp;</td>
		<td align="center"><%=dailyReportProcess.getValue("surveyShotNum")%>&nbsp;</td>
		<td align="center"><%=dailyReportProcess.getValue("surveyGeophoneNum")%>&nbsp;</td>
		<td align="center"><%=dailyReportProcess.getValue("surveyFinishedSpNum")%>&nbsp;</td>
		<td align="left">
<%
			String surveyFinishedRate=dailyReportProcess.getValue("surveyFinishedRate");
			
			if(surveyFinishedRate!=null && !surveyFinishedRate.equals("")){
%>
			<input type="text" style="width:<%=surveyFinishedRate%>px;height:13px;background-color:#0000FF;border:0" name="textfield2"><br><font style="font-size:12px">完成<%=surveyFinishedRate%>%</font>&nbsp;
<%
			}
%>
		&nbsp;</td>
	</tr>
<%
		}
	}
%>
</table>

</form>
<table border="0" cellpadding="0" cellspacing="0" class="toolbar" width="100%" >
	<tr class="bt_info">
	<td align="left">找到 <%=resultMsg.getValue("totalRows")!=null?resultMsg.getValue("totalRows"):0%> 条记录,每页  <%=resultMsg.getValue("pageSize")!=null?resultMsg.getValue("pageSize"):0%> 条,当前第 <%=resultMsg.getValue("cur")!=null?resultMsg.getValue("cur"):0%> 页&nbsp;&nbsp;</td>
	<td><img src="<%=contextPath%>/images/table/firstPageDisabled.gif"  style="border:0"  alt="第一页" onclick="firstPage()"  style="cursor:hand;"/></td>
	<td><img src="<%=contextPath%>/images/table/prevPageDisabled.gif"  style="border:0"  alt="上一页" onclick="lastPage()"  style="cursor:hand;"/></td>
	<td><img src="<%=contextPath%>/images/table/nextPageDisabled.gif"  style="border:0"  alt="下一页" onclick="nextPage()" style="cursor:hand;"/></td>
	<td><img src="<%=contextPath%>/images/table/lastPageDisabled.gif"  style="border:0"  alt="最后页" onclick="finalPage()"  style="cursor:hand;"/></td>
	</tr>
</table>
</body>
</html>
