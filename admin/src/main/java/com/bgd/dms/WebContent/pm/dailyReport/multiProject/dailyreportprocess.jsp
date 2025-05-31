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
<title>�ձ����Ȳ鿴</title>
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
		
			alert("������ǰҳ��");
			return;
		} else {

			var form = document.forms[0];
			form.action="<%=contextPath%>/pm/dailyReport/queryDailyReportProcess.srq?cur=1&projectInfoNo="+projectInfoNo+"&explorationMethod="+explorationMethod;
			form.submit();		
		}
	}
	
	function lastPage() {
		if(cur==1) {
		
			alert("������ǰҳ��û����һҳ��");
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
		
			alert("�������һҳ,û����һҳ��");
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
		
			alert("�������һҳ��");
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
	<td align="left">�ҵ� <%=resultMsg.getValue("totalRows")!=null?resultMsg.getValue("totalRows"):0%> ����¼,ÿҳ  <%=resultMsg.getValue("pageSize")!=null?resultMsg.getValue("pageSize"):0%> ��,��ǰ�� <%=resultMsg.getValue("cur")!=null?resultMsg.getValue("cur"):0%> ҳ&nbsp;&nbsp;</td>
	<td><img src="<%=contextPath%>/images/table/firstPageDisabled.gif"  style="border:0"  alt="��һҳ" onclick="firstPage()"  style="cursor:hand;"/></td>
	<td><img src="<%=contextPath%>/images/table/prevPageDisabled.gif"  style="border:0"  alt="��һҳ" onclick="lastPage()"  style="cursor:hand;"/></td>
	<td><img src="<%=contextPath%>/images/table/nextPageDisabled.gif"  style="border:0"  alt="��һҳ" onclick="nextPage()" style="cursor:hand;"/></td>
	<td><img src="<%=contextPath%>/images/table/lastPageDisabled.gif"  style="border:0"  alt="���ҳ" onclick="finalPage()"  style="cursor:hand;"/></td>
	</tr>
</table>
<form action="" method="post">

<table border="0" cellpadding="0" cellspacing="0" class="Tab_page_title">
	<tr class="Tab_page_title">
		<td colspan="4" class="Tab_Header">�������Ȳ鿴</td>
	</tr>
</table>

<table cellpadding="" cellspacing="" class="tab_info" >
	<tr bgcolor="#daedf0" >
		<td rowspan="2" align="center">��������</td>
		<td colspan="3" align="center">�ɼ�������</td>
		<td colspan="3" align="center">�꾮������</td>
		<td colspan="3" align="center">�����鹤����</td>
		<td colspan="4" align="center">����������</td>
	</tr>
	<tr bgcolor="#daedf0">
		<td align="center">���������</td>
		<td align="center">��Ŀ�ۼ�</td>
		<td align="center">��ɱ���</td>
		<td align="center">���������</td>
		<td align="center">��Ŀ�ۼ�</td>
		<td align="center">��ɱ���</td>
		<td align="center">����ɵ���</td>
		<td align="center">��Ŀ�ۼ�</td>
		<td align="center">��ɱ���</td>
		<td align="center">������ڵ���</td>
		<td align="center">����ɼ첨����</td>
		<td align="center">��Ŀ�ۼ�</td>
		<td align="center">��ɱ���</td>
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
			<input type="text" style="width:<%=collFinishedRate%>px;height:13px;background-color:#0000FF;border:0" name="textfield2"><br><font style="font-size:12px">���<%=collFinishedRate%>%</font>&nbsp;
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
			<input type="text" style="width:<%=drillFinishedRate%>px;height:13px;background-color:#0000FF;border:0" name="textfield2"><br><font style="font-size:12px">���<%=drillFinishedRate%>%</font>&nbsp;
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
			<input type="text" style="width:<%=surfaceFinishedRate%>px;height:13px;background-color:#0000FF;border:0" name="textfield2"><br><font style="font-size:12px">���<%=surfaceFinishedRate%>%</font>&nbsp;
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
			<input type="text" style="width:<%=surveyFinishedRate%>px;height:13px;background-color:#0000FF;border:0" name="textfield2"><br><font style="font-size:12px">���<%=surveyFinishedRate%>%</font>&nbsp;
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
	<td align="left">�ҵ� <%=resultMsg.getValue("totalRows")!=null?resultMsg.getValue("totalRows"):0%> ����¼,ÿҳ  <%=resultMsg.getValue("pageSize")!=null?resultMsg.getValue("pageSize"):0%> ��,��ǰ�� <%=resultMsg.getValue("cur")!=null?resultMsg.getValue("cur"):0%> ҳ&nbsp;&nbsp;</td>
	<td><img src="<%=contextPath%>/images/table/firstPageDisabled.gif"  style="border:0"  alt="��һҳ" onclick="firstPage()"  style="cursor:hand;"/></td>
	<td><img src="<%=contextPath%>/images/table/prevPageDisabled.gif"  style="border:0"  alt="��һҳ" onclick="lastPage()"  style="cursor:hand;"/></td>
	<td><img src="<%=contextPath%>/images/table/nextPageDisabled.gif"  style="border:0"  alt="��һҳ" onclick="nextPage()" style="cursor:hand;"/></td>
	<td><img src="<%=contextPath%>/images/table/lastPageDisabled.gif"  style="border:0"  alt="���ҳ" onclick="finalPage()"  style="cursor:hand;"/></td>
	</tr>
</table>
</body>
</html>
