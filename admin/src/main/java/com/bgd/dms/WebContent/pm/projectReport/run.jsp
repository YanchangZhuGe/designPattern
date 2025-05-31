<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%> 
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	
	String startDate = request.getParameter("startDate");
	if(startDate==null)startDate="";
	
	String endDate = request.getParameter("endDate");
	if(endDate==null)endDate="";
	
	String reportId = request.getParameter("reportId");
	if(reportId==null)reportId="";
	
	String userSubId = request.getParameter("userSubId");
	if(userSubId==null)userSubId="";
	if(userSubId == ""){
		userSubId = user.getOrgSubjectionId();
	}
	
	List list = null;
	String org_subjection_id = user.getOrgSubjectionId();
	
	if(org_subjection_id!=null){
		if((org_subjection_id.startsWith("C105001")&&org_subjection_id.length()>=10)||(org_subjection_id.startsWith("C105005")&&org_subjection_id.length()>=10)){
			org_subjection_id = org_subjection_id.substring(0,10);
		}else if((org_subjection_id.startsWith("C105002")||org_subjection_id.startsWith("C105003")||org_subjection_id.startsWith("C105007")||org_subjection_id.startsWith("C105008")||org_subjection_id.startsWith("C105063"))&&org_subjection_id.length()>=7){
			org_subjection_id = org_subjection_id.substring(0,7);
		}else{
			org_subjection_id = "C105";
		}
		String sql = "select * from (select oi.org_Abbreviation , os.org_Subjection_Id   from Comm_Org_Information oi, Comm_Org_Subjection os where (os.father_Org_Id = 'C105' or os.org_Subjection_Id = 'C105' or os.father_org_id = 'C105001') and os.org_subjection_id != 'C105001' and os.org_subjection_id != 'C105001018' and os.bsflag = '0' and oi.bsflag = '0' and os.code_Afford_Org_Id = oi.org_Id and oi.forbid_If = '1' and os.org_Id = oi.org_Id and oi.org_Type != '0200100004000000024' order by os.org_Subjection_Id) where org_subjection_id like '"+org_subjection_id+"%' order by org_subjection_id";
		list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
	}
	
	String reportName = "";//ReportGenInitServlet.getReportName(reportId);

	String reportFile = "";//ReportGenInitServlet.getReportFile(reportId);
	
	if("001".equals(reportId)){
		reportName="地震勘探项目运行动态表(年报,含全年项目)";
		reportFile="/projectReport/earthquakeRunDynamic(Year)New.raq";
	} else if("002".equals(reportId)){
		reportName="地震勘探项目运行动态表(月报,含全年项目)";
		reportFile="/projectReport/earthquakeRunDynamic(month)New.raq";
	} else if("003".equals(reportId)){
		reportName="地震勘探项目运行动态表(周报,含全年项目)";
		reportFile="/projectReport/earthquakeRunDynamic(month)New.raq";
	} else if("005".equals(reportId)){
		reportName="地震采集项目准备信息表";
		reportFile="/projectReport/earthquakeCollectionReadyInfo.raq";
	} else if("006".equals(reportId)){
		reportName="地震采集项目结束信息表";
		reportFile="/projectReport/earthquakeCollectionEndInfo.raq";
	} else if("007".equals(reportId)){
		reportName="二维地震勘探生产报表";
		reportFile="/projectReport/earthquakeDailyTwo.raq";
	} else if("008".equals(reportId)){
		reportName="三维地震勘探生产报表";
		reportFile="/projectReport/earthquakeStaticsThree.raq";
	} else if("009".equals(reportId)){
		reportName="地震勘探生产问题统计表";
		reportFile="/projectReport/earthquakeProductionError.raq";
	} else if("010".equals(reportId)){
		reportName="二维地震勘探项目施工因素及设备动态报表";
		reportFile="/projectReport/earthquakeDeviceTwo.raq";
	} else if("011".equals(reportId)){
		reportName="三维四维地震勘探项目施工因素及设备动态报表";
		reportFile="/projectReport/earthquakeDeviceThreeFour.raq";
	} else if("012".equals(reportId)){
		reportName="地震勘探项目“六个计划、部署图、施工设计、试验总结、施工总结、甲方验收书”加载情况统计";
		reportFile="/projectReport/earthquakeLoadSituation.raq";
	} 
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>新建项目</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<title></title>
</head>

<body style="overflow-x: scroll;overflow-y: scroll;">
<div id="list_table">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="FilterLayer">
			<tr>
				<td width="6"><img src="<%=contextPath%>/images/list_13.png"
					width="6" height="36" /></td>
				<td background="<%=contextPath%>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="ali_cdn_name">开始日期：</td>
			 	    <td class="ali_cdn_input">
			 	    	<input type="text" id="startDate" name="startDate" class="input_width" style="width:120px" value="" readonly="readonly"/>
					    &nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(startDate,tributton1);" />&nbsp;
			 	    </td> 
			 	    <td class="ali_cdn_name">结束日期：</td>
			 	    <td class="ali_cdn_input">
			 	   		<input type="text" id="endDate" name="endDate" class="input_width" style="width:120px" value="" readonly="readonly"/>
					    &nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(endDate,tributton2);" />&nbsp;
			 	    </td> 
			 	    <td class="ali_cdn_name">统计单位：</td>
			 	    <td class="ali_cdn_input">
						<select id="userSubId" name="userSubId" class="select_width">
							<option value="">请选择</option>
							<%if(list != null && list.size() != 0){
								for(int i=0;i<list.size();i++){ 
									Map map = (Map)list.get(i) ;
							%>
							<option value="<%=(String)map.get("orgSubjectionId")%>"><%=(String)map.get("orgAbbreviation") %></option>
							<%}} %>
						</select>
			 	    </td> 
					<td class="ali_query">
					   <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
				    </td>
				    <td class="ali_query">
					    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
					</td>
	
				    <td>&nbsp;</td>
				</tr>
			  </table>
			
				</td>
				<td width="4"><img src="<%=contextPath%>/images/list_17.png"
					width="4" height="36" /></td>
			</tr>
		</table>
	</div>
</div>
<% if(startDate!=null && !startDate.equals("")){
    String priYearDate=(Integer.parseInt(endDate.substring(0,4))-1)+"-12-26";
    StringBuffer str = new StringBuffer();
    str.append("userSubId=").append(userSubId).append(";startDate=").append(startDate).append(";endDate=").append(endDate);
    str.append(";priYearDate=").append(priYearDate).append(";reportName=").append(reportName); %>
    <div>
	<table   align="center"  id="90" >
		<tr align="center" >
		    <td align="center" >
			  <report:html name="report1"
			               reportFileName="<%=reportFile %>"
						   params="<%=str.toString()%>"
						   funcBarLocation=""
						   needScroll="yes"
						   scrollWidth="100%"
						   scrollHeight="50%"
						   saveAsName="<%=reportName %>"
						   excelPageStyle="0"
			  />
			</td>
  	</tr>
	</table>
	</div>
<%} %>
</body>
<script type="text/javascript">
	
	document.getElementById("startDate").value = "<%=startDate%>";
	document.getElementById("endDate").value = "<%=endDate%>";
	document.getElementById("userSubId").value = "<%=userSubId%>";
	
	
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	//键盘上只有删除键，和左右键好用
	function noEdit(event){
		if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
			return true;
		}else{
			return false;
		}
	}
	
	// 简单查询
	function simpleSearch(){
		var startDate = document.getElementById("startDate").value;
		var endDate = document.getElementById("endDate").value;
		var userSubId = document.getElementById("userSubId").value;
		if(startDate==""){
			alert("请选择开始时间!");
			return;
		}
		if(endDate==""){
			endDate = convertDate(new Date());
		}
		
		window.location="<%=contextPath%>/pm/projectReport/run.jsp?reportId=<%=reportId%>&startDate="+startDate+"&endDate="+endDate+"&userSubId="+userSubId;
	}
	
	function convertDate(date){
		var year = date.getFullYear();
		var month = date.getMonth()+1;
		var m;
		if(month < 10){
			m = '0' + month;
		} else {
			m = month;
		}
		var day = date.getDate();
		var d;
		if(day < 10){
			d = '0' + day;
		} else {
			d = day;
		}
		var s = year + '-' +m+'-'+d;
		return s;
	}
</script>
</html>