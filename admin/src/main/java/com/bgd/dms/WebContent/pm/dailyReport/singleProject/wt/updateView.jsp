<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.bgp.mcs.service.wt.pm.service.dailyReport.WtDailyReportSrv"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String weather = request.getParameter("weather");
	String daily_no = request.getParameter("daily_no_wt");
 
	String projectInfoNo = request.getParameter("project_info_no");
	String status = request.getParameter("status");
	String build = request.getParameter("build");
	String produce_date = request.getParameter("produce_date");

	if (projectInfoNo == null || "".equals(projectInfoNo)) {
		UserToken user = OMSMVCUtil.getUserToken(request);
		projectInfoNo = user.getProjectInfoNo();
	}
	System.out.print("project_info_no+" + projectInfoNo + ",+status+"
			+ status + "+build+" + build + "+weather+" + weather
			+ "+produce_date+" + produce_date);

	if (produce_date == null) {
		produce_date = "null";
	}
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String message = null;
	if (respMsg != null && respMsg.getValue("message") != null) {
		message = respMsg.getValue("message");
	}
 
	WtDailyReportSrv wtsrv = new WtDailyReportSrv();

	List<Map> list = (List) wtsrv.getExplorationName(projectInfoNo,
			produce_date);

	List<Map> list2 = (List) wtsrv.getExplorationUnit(projectInfoNo,produce_date);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup-new.js"></script>
<link rel="stylesheet" type="text/css" media="all"
	href="<%=contextPath%>/css/calendar-blue.css" />
</head>


<script type="text/javascript">
debugger;

cruConfig.contextPath = "<%=contextPath%>";
cruConfig.cdtType = 'form';
var produceDate;
var message="<%=message%>";

if (message != null&&"null"!=message) {
	alert("修改成功");
}


function page_init(){
	
	var produceDate ="";
	if(produceDate == null || produceDate == ""){
		produceDate = '<%=produce_date%>';
	} 
	//var retObj = jcdpCallService("WtDailyReportSrv", "getDailyReportList", "projectInfoNo=<%=projectInfoNo%>&produceDate="+produceDate);
 
	if(<%=status%> == "" || <%=status%> == null) {
		document.getElementById("AUDIT_STATUS").innerHTML = '日报未录入!';
		document.getElementById("tj_btn").style.display="none";
		//document.getElementById("cx_btn").colSpan="2";
	} else if(<%=status%> == "0") {
		document.getElementById("AUDIT_STATUS").innerHTML = '日报还没有提交!';
		document.getElementById("tj_btn").style.display="inline";
		//document.getElementById("cx_btn").colSpan="1";
	} else if(<%=status%> == "1") {
		document.getElementById("AUDIT_STATUS").innerHTML = '日报已经提交，等待审批中!';
		document.getElementById("tj_btn").style.display="none";
	//	document.getElementById("cx_btn").colSpan="2";
	} else if(<%=status%> == "3") {
		document.getElementById("AUDIT_STATUS").innerHTML = '日报已经审批通过!';
		document.getElementById("tj_btn").style.display="none";
	//	document.getElementById("cx_btn").colSpan="2";
	} else {
		document.getElementById("AUDIT_STATUS").innerHTML = '日报审批未通过!';
		document.getElementById("tj_btn").style.display="inline";
		//document.getElementById("cx_btn").colSpan="1";
	}

	if(<%=build%>== "" || <%=build%> == null){
		document.getElementById("IF_BUILD").innerHTML = '';
	} else if(<%=build%> == "1"){
		document.getElementById("IF_BUILD").innerHTML = '动迁';
	} else if(<%=build%> == "2"){
		document.getElementById("IF_BUILD").innerHTML = '踏勘';
	
	}else if(<%=build%> == "3"){
		document.getElementById("IF_BUILD").innerHTML = '建网';
	} else if(<%=build%> == "4"){
		document.getElementById("IF_BUILD").innerHTML = '培训';
	} else if(<%=build%> == "5"){
		document.getElementById("IF_BUILD").innerHTML = '试验';
	} else if(<%=build%> == "6"){
		document.getElementById("IF_BUILD").innerHTML = '测量';
	} else if(<%=build%>== "7"){
		document.getElementById("IF_BUILD").innerHTML = '钻井';
	} else if(<%=build%> == "8"){
		document.getElementById("IF_BUILD").innerHTML = '采集';
	} else if(<%=build%> == "9"){
		document.getElementById("IF_BUILD").innerHTML = '停工';
	} else if(<%=build%> == "10"){
		document.getElementById("IF_BUILD").innerHTML = '暂停';
	} else if(<%=build%>== "11"){
		document.getElementById("IF_BUILD").innerHTML = '结束';
	}
	if(<%=weather%> == "" || <%=weather%> == null){
		document.getElementById("IF_WEATHER").innerHTML = '';
	} else if(<%=weather%> == "1"){
		document.getElementById("IF_WEATHER").innerHTML = '晴';
	} else if(<%=weather%> == "2"){
		document.getElementById("IF_WEATHER").innerHTML = '阴';
	} else if(<%=weather%> == "3"){
		document.getElementById("IF_WEATHER").innerHTML = '多云';
	} else if(<%=weather%> == "4"){
		document.getElementById("IF_WEATHER").innerHTML = '雨';
	} else if(<%=weather%> == "5"){
		document.getElementById("IF_WEATHER").innerHTML = '雾';
	} else if(<%=weather%> == "6"){
		document.getElementById("IF_WEATHER").innerHTML = '霾';
	} else if(<%=weather%> == "7"){
		document.getElementById("IF_WEATHER").innerHTML = '霜冻';
	} else if(<%=weather%> == "8"){
		document.getElementById("IF_WEATHER").innerHTML = '暴风';
	} else if(<%=weather%> == "9"){
		document.getElementById("IF_WEATHER").innerHTML = '台风';
	} else if(<%=weather%> == "10"){
		document.getElementById("IF_WEATHER").innerHTML = '暴风雪';
	} else if(<%=weather%> == "11"){
		document.getElementById("IF_WEATHER").innerHTML = '雪';
	} else if(<%=weather%> == "12"){
		document.getElementById("IF_WEATHER").innerHTML = '雨夹雪';
	} else if(<%=weather%> == "13"){
		document.getElementById("IF_WEATHER").innerHTML = '冰雹';
	} else if(<%=weather%> == "14"){
		document.getElementById("IF_WEATHER").innerHTML = '浮尘';
	} else if(<%=weather%> == "15"){
		document.getElementById("IF_WEATHER").innerHTML = '扬沙';
	} else if(<%=weather%> == "16"){
		document.getElementById("IF_WEATHER").innerHTML = '其他';
	} else if(<%=weather%> == "17"){
		document.getElementById("IF_WEATHER").innerHTML = '大风';
	}
	
  
}
function toAdd(){
	
	document.getElementById("form1").action="<%=contextPath%>/pm/dailyReport/singleProject/wt/saveOrUpdateView.srq?projectInfoNo=<%=projectInfoNo%>&&produceDate=<%=produce_date%>";
	document.getElementById("form1").submit();
}
</script>
<body onload="page_init()" style="overflow: scroll;">
	<div id="tab_box" class="tab_box">
		<div id="tab_box_content0" class="tab_box_content">
			<form id="form1" method="post">
			<input type="hidden" name="daily_no_wt"id="daily_no_wt"  value='<%=daily_no%>'></input >
				<input type="hidden" name="produce_date"id="produce_date"  value='<%=produce_date%>'></input>
					<input type="hidden" name="weather"id="weather"  value='<%=weather%>'></input>
					<input type="hidden" name="build"id="build"  value='<%=build%>'></input>
					<input type="hidden" name="status"id="status"  value='<%=status%>'></input>
				<table width="100%" border="0" cellspacing="0" cellpadding="0"
					class="tab_line_height">
					<tr style="background-color: #97cbfd">
						<td class="inquire_item8">生产日期：</td>
						<td class="inquire_form8"><input type="hidden" name="daily_no" id="daily_no" /> 
						<input type="text" name="produceDate" id='produceDate' value='<%=produce_date%>' readonly="readonly" />&nbsp;&nbsp; <img
							src="<%=contextPath%>/images/calendar.gif" id="tributton1"
							width="16" height="16" style="cursor: hand;"
							onmouseover="calDateSelector(produceDate,tributton1);" />&nbsp;&nbsp;
							<font color="red" style="text-align: right;" id="AUDIT_STATUS">审批通过</font>
						</td>
						<td class="inquire_form4">&nbsp;</td>
						 <auth:ListButton functionId="" css="bc" event="onclick='toAdd()'" title="保存"></auth:ListButton>
						 	 
						<auth:ListButton tdid="tj_btn" functionId="" css="tj"
							event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
					</tr>
				</table>
		

			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				class="tab_line_height">
				<tr class="even">
					<td class="inquire_item6">项目状态：</td>
					<td class="inquire_form6" id="IF_BUILD"></td>
					<td class="inquire_item6">天气：</td>
					<td class="inquire_form6" name="IF_WEATHER" id='IF_WEATHER'  >  </td>
					<td class="inquire_item6">&nbsp;</td>
					<td class="inquire_form6">&nbsp;</td>
				</tr>

			 
			</table>
				 <%
			List listM= wtsrv.getDailyReportList(projectInfoNo,produce_date);
			 	 for(int i=0; i<listM.size(); i++){
				 Map map=(Map)listM.get(i);
			             System.out.print(map.get("name"));
			             if(map.get("exmethod").equals("5110000056000000045")){
			            	 %>
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				class="tab_line_height"> 
				<tr style="background-color: #97cbfd">
					<td class="inquire_item8">测量工作量</td>

					<td colspan="15">&nbsp;</td>
				</tr>

			<tr  class="odd">
		<td class="inquire_item8">每日工作量</td>
		<td colspan="15">&nbsp;</td>
		</tr>
				<tr>
				
					<%
				if(!map.get("sumce1").equals("")) {
				%>
					<td class="inquire_item8" id="gpscong" >日GPS控制点：</td>
					<td class="inquire_form8" id="gpscon1"><input  id="gpscon1" type="text" name="gpscon1" value='<%=map.get("sumce1") %> '/></td>
				<%
				}
			 
				if(!map.get("sumce5").equals("")) {
				%>
					<td class="inquire_item8" id="gpscong1">日坐标点：</td>
					<td class="inquire_form8" id="gpscon2"><input id="gpscon2" type="text" name="gpscon2" value='<%=map.get("sumce5") %>' /> </td>
				<%
				}
				if(!map.get("sumce2").equals("")) {
					%>
					<td class="inquire_item8" id="gpscong2">日复测点：</td>
					<td class="inquire_form8" id="gpscon3"><input id="gpscon3" type="text" name="gpscon3" value='<%=map.get("sumce2") %>'/></td>
					<%
					}
				if(!map.get("sumce3").equals("")) {
					%>
						<td class="inquire_item8" id="gpscong3">日地形改正点：</td>
					<td class="inquire_form8" id="gpscon4"><input id="gpscon4" type="text" name="gpscon4" value='<%=map.get("sumce3") %>' /></td>
					<%
					}
					%>
				
				 
				 
					 
				 
				</tr>
				<tr>
					<%
				if(!map.get("sumce4").equals("") ) {
					%>
	                    <td class="inquire_item8" id="gpscong4" >日地改检查点：</td>
						<td class="inquire_form8" id="gpscon5"><input id="gpscon5" type="text" name="gpscon5" value="<%=map.get("sumce4") %>"/></td>
					<%
					}
					%>
				
				 
				</tr>
				<tr class="odd">
					<td >&nbsp;&nbsp;&nbsp;&nbsp; 累计工作量</td>
						<td colspan="15"></td>
				</tr>
					<tr>
						<%
				if(!map.get("sumceA").equals("") ) {
					%>
	              	<td class="inquire_item8" id="sumceg">累计GPS控制点：</td>
					<td class="inquire_form8" id="sumce"><input id="sumce" type="text" name="sumce" value='<%=map.get("sumceA") %>' /></td>
					<%
					}
					%>
							<%
				if(!map.get("sumceE").equals("") ) {
					%>
	              	<td class="inquire_item8" id="sumceg1">累计坐标点：</td>
					<td class="inquire_form8" id="sumce1"><input id="sumce1" type="text" name="sumce1" value='<%=map.get("sumceE") %>'/></td> 
					<%
					}
					%>
							<%
				if(!map.get("sumceB").equals("") ) {
					%>
	              <td class="inquire_item8" id="sumceg2">累计复测点：</td>
					<td class="inquire_form8" id="sumce2"><input id="sumce2" type="text" name="sumce2" value="<%=map.get("sumceB") %> " /></td>
					<%
					}
					%>
							<%
				if(!map.get("sumceC").equals("") ) {
					%>
	       		<td class="inquire_item8" id="sumceg3">累计地形改正点：</td>
					<td class="inquire_form8" id="sumce3"><input id="sumce3" type="text" name="sumce3" value='<%=map.get("sumceC") %>'/></td>
					<%
					}
					%>
				 
					 
				 
					 
				</tr>
				<tr>
									<%
				if(!map.get("sumceD").equals("") ) {
					%>
	       	<td class="inquire_item8" id="sumceg4">累计地改检查点：</td>
					<td class="inquire_form8" id="sumce4"><input id="sumce4" type="text" name="sumce4"  value='<%=map.get("sumceD") %>'/></td>
					<%
					}
					%>
			 
					</tr>
						<tr class="odd">
					<td >&nbsp;&nbsp;&nbsp;&nbsp;效率计算</td>
						<td colspan="15"></td>
				</tr>
					<tr>
										<%
				if(!map.get("avgcet").equals("") ) {
					%>
	                <td class="inquire_item8" id="avgcetg">复测率：</td>
					<td class="inquire_form8" id="avgcet"><input id="avgcet" type="text" name="avgcet" value='<%=map.get("avgcet") %>' />%</td>
					<%
					}
					%>
											<%
				if(!map.get("lvttce").equals("") ) {
					%>
	    	       <td class="inquire_item8" id="lvttceg">地改检查率：</td>
					<td class="inquire_form8" id="lvttce"><input id="lvttce" type="text" name="lvttce" value="<%=map.get("lvttce") %>"/>%</td>
					<%
					}
			             
					%>
				 
				 
				</tr>
			</table>
		 <%
			             }
			             if(map.get("exmethod").equals("5110000056000000001")){
			            	 System.out.print(map.get("name"));
			            
		 %>
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				class="tab_line_height" id="zlMethod" name="zlMethod" >
				
				<tr style="background-color: #97cbfd">
					<td class="inquire_item8" ><%=map.get("name")%>工作量</td>
					
				<td colspan="15">&nbsp;</td>
				</tr>
		<tr  class="odd">
		<td class="inquire_item8">每日工作量</td>
		<td colspan="15">&nbsp;</td>
		</tr>
				<tr  >
					<%
				if(!map.get("base12").equals("") ) {
				   String nameX=(String)map.get("explorationMethod");
					System.out.print(map.get("explorationMethod"));
					%>	
	               <td class="inquire_item8" id="basep">日工作量：</td>
								<td class="inquire_form8" ><input id="base12" type="text" name="base12<%=map.get("explorationMethod") %>" value="<%=map.get("base12") %>" /> </td>	
											  <% 
					}
					%>
						<%
				if(!map.get("base14").equals("") ) {
					%>
	             	<td class="inquire_item8" id="basep1">日坐标点：</td>
					<td class="inquire_form8"><input id="base" type="text" name="base14<%=map.get("explorationMethod") %>" value="<%=map.get("base14") %>"/></td>					<%
					}
					%>
						<%
				if(!map.get("base10").equals("") ) {
					%>
	            	<td class="inquire_item8" id="basep2">日检查点：</td>
					<td class="inquire_form8"><input id="base10" type="text" name="base10<%=map.get("explorationMethod") %>" value="<%=map.get("base10")%>" /></td>			<%
					}
					%>
						<%
				if(!map.get("base13").equals("") ) {
					%>
	               <td class="inquire_item8" id="basep3">日物理点：</td>
					<td class="inquire_form8" ><input id="base13" type="text" name="base13<%=map.get("explorationMethod") %>" value="<%=map.get("base13") %>" /></td>				<%
					}
					%>
				</tr>
				<tr  >
							<%
				if(!map.get("base9").equals("") ) {
					%>
	               	<td class="inquire_item8" id="basep4">日返工点：</td>
					<td class="inquire_form8" ><input id="base9" type="text" name="base9<%=map.get("explorationMethod") %>" value="<%=map.get("base9") %>"/></td>
								<%
					}
					%>
							<%
				if(!map.get("base8").equals("") ) {
					%>
	            	<td class="inquire_item8" id="basep5">日一级品：</td>
					<td class="inquire_form8" ><input id="base8" type="text" name="base8<%=map.get("explorationMethod") %>" value="<%=map.get("base8") %>"/></td>			<%
					}
					%>
							<%
				if(!map.get("base7").equals("") ) {
					%>
	           	<td class="inquire_item8" id="basep6">日合格品：</td>
					<td class="inquire_form8"><input id="base7" type="text" name="base7<%=map.get("explorationMethod") %>" value="<%=map.get("base7") %>" /></td>			<%
					}
					%>
							<%
				if(!map.get("base11").equals("") ) {
					%>
	           <td class="inquire_item8" id="basep7">日基点：</td>
					<td class="inquire_form8" > <input id="base11" type="text" name="base11<%=map.get("explorationMethod") %>" value="<%=map.get("base11") %>" /></td>		<%
					}
					%>
				 
					 
					 
				 
				</tr>
				<tr  >
								<%
				if(!map.get("base6").equals("") ) {
					%>
	             	<td class="inquire_item8" id="basep8">日废品：</td>
					<td class="inquire_form8" ><input id="base6" type="text" name="base6<%=map.get("explorationMethod") %>" value="<%=map.get("base6") %>"/></td>		<%
					}
					%>
									<%
				if(!map.get("base5").equals("") ) {
					%>
	         	    <td class="inquire_item8" id="basep9">日空点：</td>
					<td class="inquire_form8" ><input id="base5" type="text" name="base5<%=map.get("explorationMethod") %>" value="<%=map.get("base5") %>" /></td>	<%
					}
					%>
				 
				 
					

				</tr>
		
				<tr class="odd">
					<td class="inquire_item8"> 累计工作量</td>
					<td colspan="15">&nbsp;</td>
				</tr>
		
				<tr >
						<%
				if(!map.get("base12m").equals("") ) {
					%>
	         	<td class="inquire_item8" id="sump">累计工作量：</td>
					<td class="inquire_form8" ><input  id="sum1" type="text" name="sum1" value="<%=map.get("base12m")%>"/> </td>	<%
					}
					%>
					
											<%
				if(!map.get("base14p").equals("") ) {
					%>
	         		<td class="inquire_item8" id="sump1">累计坐标点：</td>
					<td class="inquire_form8" ><input id="sum12" type="text" name="sum12" value="<%=map.get("base14p") %>"/></td>	<%
					}
					%>
					
											<%
				if(!map.get("base10k").equals("") ) {
					%>
	         	 	<td class="inquire_item8" id="sump2">累计检查点：</td>
					<td class="inquire_form8" ><input id="sum3" type="text" name="sum3" value="<%=map.get("base10k") %>"/></td>	<%
					}
					%>
					
											<%
				if(!map.get("base13n").equals("") ) {
					%>
	            	<td class="inquire_item8" id="sump3">累计物理点：</td>
					<td class="inquire_form8" ><input id="sum13" type="text" name="sum13" value="<%=map.get("base13n") %>" /> </td>	<%
					}
					%>
			 
					 
				 
			 

				</tr>
				<tr  >
													<%
				if(!map.get("base9j").equals("") ) {
					%>
	            	<td class="inquire_item8" id="sumf4">累计返工点：</td>
					<td class="inquire_form8" ><input id="sum4" type="text" name="sum4" value="<%=map.get("base9j") %>"/></td><%
					}
					%>
															<%
				if(!map.get("base8h").equals("") ) {
					%>
	          		<td class="inquire_item8" id="sumpy">累计一级品：</td>
					<td class="inquire_form8"><input id="sum5" type="text" name="sum5" value="<%=map.get("base8h")%>"/></td>	<%
					}
					%>
															<%
				if(!map.get("base7g").equals("") ) {
					%>
	            		<td class="inquire_item8" id="sumhg">累计合格品：</td>
					<td class="inquire_form8" ><input id="sum6" type="text" name="sum6" value="<%=map.get("base7g") %>"/></td>	<%
					}
					%>
															<%
				if(!map.get("base11l").equals("") ) {
					%>
	            			<td class="inquire_item8" id="sumpj">累计基点：</td>
					<td class="inquire_form8" ><input  id="sum2" type="text" name="sum2" value="<%=map.get("base11l") %>" /></td>	<%
					}
					%>
				</tr>
				<tr >
																		<%
				if(!map.get("base6f").equals("") ) {
					%>
	            			<td class="inquire_item8" id="sump5">累计废品：</td>
					<td class="inquire_form8" ><input id="sum7" type="text" name="sum7" value="<%=map.get("base6f")%>"/></td>	
					<%
					}
				
                 
            
				if(!map.get("base5e").equals("") ) {
					%>
	            	<td class="inquire_item8" id="sump6">累计空点：</td>
					<td class="inquire_form8" ><input id="sum8" type="text" name="sum8" value="<%=map.get("base5e") %>"/></td>	<%
					}
					%>
				 
				 
				</tr>
				<tr class="odd">
					<td class="inquire_item8">效率计算</td>
					<td colspan="15">&nbsp;</td>
				</tr>
				<tr>
				       													<%
				if(!map.get("lvavg").equals("") ) {
					%>
	            	<td class="inquire_item8" id="avgzp">检查率：</td>
					<td class="inquire_form8" ><input id="avgz1" type="text" name="avgz1" value="<%=map.get("lvavg") %>"/>%</td>	<%
					}
					%>
                
                       													<%
				if(!map.get("lvavgt").equals("") ) {
					%>
	           	<td class="inquire_item8" id="avgzp2">返工率：</td>
					<td class="inquire_form8" ><input id="avgz3" type="text" name="avgz3" value="<%=map.get("lvavgt") %>"/>%</td>	<%
					}
					%>
                
                       													<%
				if(!map.get("lvavge").equals("") ) {
					%>
	          	<td class="inquire_item8" id="avgzp3">合格品率：</td>
					<td class="inquire_form8" ><input  id="avgz5" type="text" name="avgz5" value="<%=map.get("lvavge") %>"/>%</td>	<%
					}
					%>
                
                       													<%
				if(!map.get("lvavgtt").equals("") ) {
					%>
	            	<td class="inquire_item8" id="avgzp1">一级品率：</td>		 
					<td class="inquire_form8" ><input id="avgz2" type="text" name="avgz2" value="<%=map.get("lvavgtt") %>"/>%</td>	<%
					}
					%>
				 
				</tr>
				<tr>
				      													<%
				if(!map.get("lvavgv").equals("") ) {
					%>
	            	<td class="inquire_item8" id="avgzp4">废品率：</td>
					<td class="inquire_form8"  ><input id="avgz4" type="text" name="avgz4" value="<%=map.get("lvavgv") %>"/>%</td>	<%
					}
					%>
					
				             													<%
				if(!map.get("lvavgw").equals("") ) {
					%>
	            	<td class="inquire_item8" id="avgzp5">空点率：</td>
					<td class="inquire_form8"  ><input id="avgz6" type="text" name="avgz6" value="<%=map.get("lvavgw") %>"/>%</td>	<%
					}
					%>
			 
			 
				</tr>
			</table>
			      
			      	<%
			             }
			             if(map.get("exmethod").equals("5110000056000000002")){
			            	 System.out.print(map.get("name"));
						 %>
					
					
						<table width="100%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height" id="clMethod" name="clMethod"   >
						
						<tr style="background-color: #97cbfd">
							<td class="inquire_item8" ><%=map.get("name")%>工作量</td>
							
						<td colspan="15">&nbsp;</td>
						</tr>
				<tr  class="odd">
				<td class="inquire_item8">每日工作量</td>
				<td colspan="15">&nbsp;</td>
				</tr>
						<tr  >
											<%
						if(!map.get("base12").equals("") ) {
							%>
			         	  	<td class="inquire_item8" id="workcl">日工作量：</td>
							<td class="inquire_form8" ><input type="text" id="load1" name="load1<%=map.get("explorationMethod") %>" value="<%=map.get("base12")%>"/></td>	<%
							}
							%>
												<%
						if(!map.get("base14").equals("") ) {
							%>
			         		<td class="inquire_item8" id="work2">日坐标点：</td>
							<td class="inquire_form8"><input type="text"  id="load2" name="load2<%=map.get("explorationMethod") %>" value="<%=map.get("base14") %>"/></td>	<%
							}
							%>
												<%
						if(!map.get("base10").equals("") ) {
							%>
			         	 	<td class="inquire_item8" id="work3">日检查点：</td>
							<td class="inquire_form8" ><input type="text" id="load3" name="load3<%=map.get("explorationMethod") %>" value="<%=map.get("base10") %>"/></td>	<%
							}
							%>
												<%
						if(!map.get("base13").equals("") ) {
							%>
			         	  	<td class="inquire_item8" id="work4">日物理点：</td>
							<td class="inquire_form8" ><input type="text"id="load4" name="load4<%=map.get("explorationMethod") %>" value="<%=map.get("base13")%>"/></td>	<%
							}
							%>
						
						
						
						
						</tr>
						<tr  >
													<%
						if(!map.get("base9").equals("") ) {
							%>
			         	 	<td class="inquire_item8" id="work5">日返工点：</td>
							<td class="inquire_form8" ><input type="text" id="load5" name="load5<%=map.get("explorationMethod") %>" value="<%=map.get("base9") %>"/></td>	<%
							}
							%>
															<%
						if(!map.get("base8").equals("") ) {
							%>
			         	<td class="inquire_item8" id="work6">日一级品：</td>
							<td class="inquire_form8" ><input type="text" id="load6" name="load6<%=map.get("explorationMethod") %>" value="<%=map.get("base8")%>"/></td>	<%
							}
							%>
														<%
						if(!map.get("base7").equals("") ) {
							%>
			         	  	<td class="inquire_item8" id="work7">日合格品：</td>
							<td class="inquire_form8" ><input type="text"id="load7" name="load7<%=map.get("explorationMethod") %>" value="<%=map.get("base7")%>"/></td>	<%
							}
							%>
						
														<%
						if(!map.get("base4").equals("") ) {
							%>
			         	  	<td class="inquire_item8" id="work8">日变站：</td>
							<td class="inquire_form8" ><input type="text" id="load8" name="load8<%=map.get("explorationMethod") %>" value="<%=map.get("base4") %>"/></td>	<%
							}
							%>
						
							
						
						
						</tr>
						<tr  >
															<%
						if(!map.get("base6").equals("") ) {
							%>
			         		<td class="inquire_item8" id="work9">日废品：</td>
							<td class="inquire_form8" ><input type="text" id="load9" name="load9<%=map.get("explorationMethod") %>" value="<%=map.get("base6") %>"/></td>	
							<%
							}
							%>
															<%
						if(!map.get("base5").equals("") ) {
							%>
			         	  	<td class="inquire_item8" id="work10">日空点：</td>
							<td class="inquire_form8" ><input type="text" id="load10" name="load10<%=map.get("explorationMethod") %>" value="<%=map.get("base5") %>"/></td>	<%
							}
							%>
						
						
						
						

						</tr>
				
						<tr class="odd">
							<td class="inquire_item8"> 累计工作量</td>
							<td colspan="15">&nbsp;</td>
						</tr>
				
					<tr >
																	<%
						if(!map.get("base12m").equals("") ) {
							%>
			         		<td class="inquire_item8" id="sumcl">累计工作量：</td>
							<td class="inquire_form8" ><input type="text" id="sumgzl" name="sumgzl" value="<%=map.get("base12m") %>"/></td>	<%
							}
							%>
																			<%
						if(!map.get("base14p").equals("") ) {
							%>
			        	<td class="inquire_item8" id="sumc2">累计坐标点：</td>
							<td class="inquire_form8" ><input type="text"id="sumzbd" name="sumzbd" value="<%=map.get("base14p") %>"/></td>	<%
							}
							%>
																			<%
						if(!map.get("base10k").equals("") ) {
							%>
			         	<td class="inquire_item8" id="sumc3">累计检查点：</td>
							<td class="inquire_form8" ><input type="text"id="sumjcd" name="sumjcd" value="<%=map.get("base10k") %>"/></td>	<%
							}
							%>
																			<%
						if(!map.get("base13n").equals("") ) {
							%>
			         					<td class="inquire_item8" id="sumc4">累计物理点：</td>
							<td class="inquire_form8" ><input type="text"id="sumwld" name="sumwld" value="<%=map.get("base13n") %>"/></td>	<%
							}
							%>
							
						
						
							
				

						</tr>
						<tr  >
																					<%
						if(!map.get("base9j").equals("") ) {
							%>
			         			 	<td class="inquire_item8" id="sumc5">累计返工点：</td>
							<td class="inquire_form8" ><input type="text" id="sumfgd" name="sumfgd" value="<%=map.get("base9j") %>"/></td><%
							}
							%>
																						<%
						if(!map.get("base8h").equals("") ) {
							%>
			         				<td class="inquire_item8" id="sumc6">累计一级品：</td>
							<td class="inquire_form8" ><input type="text" id="sumyjp" name="sumyjp" value="<%=map.get("base8h") %>"/></td><%
							}
							%>
																						<%
						if(!map.get("base7g").equals("") ) {
							%>
			         					<td class="inquire_item8" id="sumc7">累计合格品：</td>
							<td class="inquire_form8" ><input type="text"id="sumhgp"name="sumhgp" value="<%=map.get("base7g") %>"/></td><%
							}
							%>
																						<%
						if(!map.get("base4d").equals("") ) {
							%>
			         			<td class="inquire_item8" id="sumc8">累计日变站：</td>
							<td class="inquire_form8"><input type="text" id="sumrbz"name="sumrbz" value="<%=map.get("base4d")%>"/></td>	<%
							}
							%>
		               
					
					
						
						
							
						</tr>
						<tr >
																										<%
						if(!map.get("base6f").equals("") ) {
							%>
			         			<td class="inquire_item8" id="sumc9">累计废品：</td>
							<td class="inquire_form8" ><input type="text" id="sumfp" name="sumfp" value="<%=map.get("base6f") %>"/></td>	<%
							}
							%>
																											<%
						if(!map.get("base5e").equals("") ) {
					 
							%>
			         			<td class="inquire_item8" id="sumc10">累计空点：</td>
							<td class="inquire_form8" ><input type="text" id="sumkd"name="sumkd" value="<%=map.get("base5e") %>"/></td>	<%
							}
							%>
						
						
						</tr>
						<tr class="odd">
							<td class="inquire_item8">效率计算</td>
							<td colspan="15">&nbsp;</td>
						</tr>
						<tr>
																											<%
						if(!map.get("lvavg").equals("") ) {
							%>
			         			<td class="inquire_item8" id="avgjc">检查率：</td>
							<td class="inquire_form8" ><input type="text" id="avgc1" name="avgc1" value="<%=map.get("lvavg") %>"/>%</td>	<%
							}
							%>
																												<%
						if(!map.get("lvavgt").equals("") ) {
							%>
			         		<td class="inquire_item8" id="avgfg">返工率：</td>
							<td class="inquire_form8"><input type="text"  id="avgc2" name="avgc2" value="<%=map.get("lvavgt")  %>"/>%</td>	<%
							}
							%>
																												<%
						if(!map.get("lvavge").equals("") ) {
							%>
			         			<td class="inquire_item8" id="avghg">合格品率：</td>
							<td class="inquire_form8" ><input type="text"id="avgc3" name="avgc3" value="<%=map.get("lvavge")%>"/>%</td>	<%
							}
							%>
																												<%
						if(!map.get("lvavgtt").equals("") ) {
							%>
			         			<td class="inquire_item8" id="avgyjp">一级品率：</td>
							<td class="inquire_form8" ><input type="text" id="avgc4" name="avgc4" value="<%=map.get("lvavgtt") %>"/>% </td>	<%
							}
							%>
							
							
						
							
						</tr>
						<tr>
																													<%
						if(!map.get("lvavgv").equals("") ) {
							%>
			         			<td class="inquire_item8" id="avgfp">废品率：</td>
							<td class="inquire_form8" ><input type="text" id="avgc5" name="avgc5" value="<%=map.get("lvavgv")%>"/>%</td>	<%
							}
							%>
																														<%
						if(!map.get("lvavgw").equals("") ) {
							%>
			         			<td class="inquire_item8" id="avgkd">空点率：</td>
							<td class="inquire_form8" ><input type="text" id="avgc6" name="avgc6" value="<%=map.get("lvavgw") %>"/>%</td>	<%
							}
							%>
						
						
						</tr>
					</table>
						<%
		             }
					   if(map.get("exmethod").equals("5110000056000000004")){
			            	 System.out.print(map.get("name"));
						 %>
					<table width="100%" border="0" cellspacing="0" cellpadding="0"
					                class="tab_line_height" id="rgcy" name="rgcy" >

						<tr style="background-color: #97cbfd">
							<td class="inquire_item8"><%=map.get("name")%>工作量</td>

							<td colspan="15">&nbsp;</td>
						</tr>
						<tr class="odd">
							<td  >每日工作量</td>
							<td colspan="15">&nbsp;</td>
						</tr>
						
						
						<tr>
																	<%
						if(!map.get("base12").equals("") ) {
							%>
			         				<td class="inquire_item8" id="basework">日工作量：</td>
							<td class="inquire_form8" ><input type="text" id="bw1" name="bw1<%=map.get("explorationMethod") %>" value="<%=map.get("base12")%>"/></td>	<%
							}
							%>
																		<%
						if(!map.get("base14").equals("") ) {
							%>
			         			<td class="inquire_item8" id="basework2">日坐标点：</td>
							<td class="inquire_form8" ><input type="text" id="bw2" name="bw2<%=map.get("explorationMethod") %>" value="<%=map.get("base14")%>"/></td>	<%
							}
							%>
																		<%
						if(!map.get("base10").equals("") ) {
							%>
			         		<td class="inquire_item8" id="basework3">日检查点：</td>
							<td class="inquire_form8" ><input type="text" id="bw3" name="bw3<%=map.get("explorationMethod") %>" value="<%=map.get("base10")%>"/></td>	<%
							}
							%>
																		<%
						if(!map.get("base13").equals("") ) {
							%>
			         		<td class="inquire_item8" id="basework4">日物理点：</td>
							<td class="inquire_form8" ><input type="text" id="bw4" name="bw4<%=map.get("explorationMethod") %>" value="<%=map.get("base13")%>"/></td>	<%
							}
							%>
					
						
						
						
						</tr>
						<tr>
																			<%
						if(!map.get("base9").equals("") ) {
							%>
			         		
							<td class="inquire_item8" id="basepwork5">日返工点：</td>
							<td class="inquire_form8" ><input type="text" id="bw5" name="bw5<%=map.get("explorationMethod") %>" value="<%=map.get("base9")%>"/></td>	
							<%
							}
							%>
																				<%
						if(!map.get("base8").equals("") ) {
							%>
			         		<td class="inquire_item8" id="basepwork6">日一级品：</td>
							<td class="inquire_form8" ><input type="text" id="bw6"name="bw6<%=map.get("explorationMethod") %>" value="<%=map.get("base8")%>"/></td>	<%
							}
							%>
																				<%
						if(!map.get("base7").equals("") ) {
							%>
			         	<td class="inquire_item8" id="basepwork7">日合格品：</td>
							<td class="inquire_form8" ><input type="text" id="bw7" name="bw7<%=map.get("explorationMethod") %>" value="<%=map.get("base7")%>"/></td>	<%
							}
							%>
																				<%
						if(!map.get("base6").equals("") ) {
							%>
			         	<td class="inquire_item8" id="basework8">日废品：</td>
							<td class="inquire_form8" ><input type="text" id="bw8"name="bw8<%=map.get("explorationMethod") %>" value="<%=map.get("base6")%>"/></td>	<%
							}
							%>
							
					
						
						
							

						</tr>
						<tr>
																					<%
						if(!map.get("base5").equals("") ) {
							%>
			         	<td class="inquire_item8" id="basework9">日空点：</td>
							<td class="inquire_form8" id="bw9"><input type="text" id="bw9" name="bw9<%=map.get("explorationMethod") %>" value="<%=map.get("base5")%>"/></td>	<%
							}
							%>
						



						</tr>

						<tr class="odd">
							<td class="inquire_item8">累计工作量</td>
							<td colspan="15">&nbsp;</td>
						</tr>

						<tr class="odd">
																						<%
						if(!map.get("base12m").equals("") ) {
							%>
			         <td class="inquire_item8" id="sumwork1">累计工作量：</td>
							<td class="inquire_form8" ><input type="text"id="sw1" name="sw1" value="<%=map.get("base12m")%>"/> </td>	<%
							}
							%>
																							<%
						if(!map.get("base14p").equals("") ) {
							%>
			        	<td class="inquire_item8" id="sumwork2">累计坐标点：</td>
							<td class="inquire_form8" ><input type="text" id="sw2" name="sw2" value="<%=map.get("base14p")%>"/></td>	<%
							}
							%>
																							<%
						if(!map.get("base10k").equals("") ) {
							%>
			         		<td class="inquire_item8" id="sumwork3">累计检查点：</td>
							<td class="inquire_form8" id="sw3"><input type="text" id="" name="" value="<%=map.get("base12")%>"/><%=map.get("base10k")%></td>	<%
							}
							%>
																							<%
						if(!map.get("base13n").equals("") ) {
							%>
			         		<td class="inquire_item8" id="sumwork4">累计物理点：</td>
							<td class="inquire_form8" id="sw4"><input type="text" id="" name="" value="<%=map.get("base12")%>"/><%=map.get("base13n")%></td><%
							}
							%>
							
						
					
						

						</tr>
						<tr>
																									<%
						if(!map.get("base9j").equals("") ) {
							%>
			         		<td class="inquire_item8" id="sumwork5">累计返工点：</td>
							<td class="inquire_form8" ><input type="text" id="sw5" name="sw5" value="<%=map.get("base9j")%>"/></td><%
							}
							%>
																										<%
						if(!map.get("base8h").equals("") ) {
							%>
			         			<td class="inquire_item8" id="sumwork6">累计一级品：</td>
							<td class="inquire_form8"><input type="text"  id="sw6"name="sw6" value="<%=map.get("base8h")%>"/></td><%
							}
							%>
																										<%
						if(!map.get("base7g").equals("") ) {
							%>
			         		<td class="inquire_item8" id="sumwork7">累计合格品：</td>
							<td class="inquire_form8" ><input type="text" id="sw7"name="sw7" value="<%=map.get("base7g")%>"/></td>          <%
							}
							%>
																										<%
						if(!map.get("base6f").equals("") ) {
							%>
			         		       <td class="inquire_item8" id="sumwork8">累计废品：</td>
							<td class="inquire_form8"><input type="text"  id="sw8" name="sw8" value="<%=map.get("base6f")%>"/></td>            <%
							}
							%>
						
						
						
		             

						</tr>
						<tr>
																											<%
						if(!map.get("base5e").equals("") ) {
							%>
			         		<td class="inquire_item8" id="sumwork9">累计空点：</td>
							<td class="inquire_form8" ><input type="text"id="sw9" name="sw9" value="<%=map.get("base5e")%>"/></td>         <%
							}
							%>
							
						</tr>
						<tr class="odd">
							<td class="inquire_item8">效率计算</td>
							<td colspan="15">&nbsp;</td>
						</tr>
						<tr>
																													<%
						if(!map.get("lvavg").equals("") ) {
							%>
			         		<td class="inquire_item8" id="avgrg">检查率：</td>
							<td class="inquire_form8" ><input type="text"id="avgtr" name="avgtr" value="<%=map.get("lvavg")%>"/>%</td>        <%
							}
							%>
																														<%
						if(!map.get("lvavgt").equals("") ) {
							%>
			         			<td class="inquire_item8" id="avgrg1">返工率：</td>
							<td class="inquire_form8" ><input type="text" id="avgtr1" name="avgtr1" value="<%=map.get("lvavgt")%>"/>%</td>       <%
							}
							%>
																														<%
						if(!map.get("lvavge").equals("") ) {
							%>
			         		<td class="inquire_item8" id="avgrg2">合格品率：</td>
							<td class="inquire_form8" ><input type="text" id="avgtr2"name="avgtr2" value="<%=map.get("lvavge")%>"/>%</td>        <%
							}
							%>
																														<%
						if(!map.get("lvavgtt").equals("") ) {
							%>
			         			<td class="inquire_item8" id="avgrg3">一级品率：</td>
							<td class="inquire_form8"><input type="text"  id="avgtr3" name="avgtr3" value="<%=map.get("lvavgtt")%>"/>%</td>        <%
							}
							%>
							
						
							
					
						</tr>
						<tr>
																														<%
						if(!map.get("lvavgv").equals("") ) {
							%>
			         			<td class="inquire_item8" id="avgrg4">废品率：</td>
							<td class="inquire_form8" ><input type="text" id="avgtr4" name="avgtr4" value="<%=map.get("lvavgv")%>"/>%</td>       <%
							}
							%>
																															<%
						if(!map.get("lvavgw").equals("") ) {
							%>
			         			<td class="inquire_item8" id="avgrg5">空点率：</td>
							<td class="inquire_form8" ><input type="text" id="avgtr5"name="avgtr5" value="<%=map.get("lvavgw")%>"/>%</td>      <%
							}
							%>
					
						
						</tr>
					</table>


					<%
		             }
					   if(map.get("exmethod").equals("5110000056000000003")){
			            	 System.out.print(map.get("name"));
						 %>
					
					<table width="100%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height" id="trcy" name="trcy"  >
						
					
						<tr style="background-color: #97cbfd">
							<td class="inquire_item8" ><%=map.get("name")%>工作量</td>
							
						<td colspan="15">&nbsp;</td>
						</tr>
				<tr  class="odd">
				<td class="inquire_item8">每日工作量</td>
				<td colspan="15">&nbsp;</td>
				</tr>
						<tr>
						
																							<%
						if(!map.get("base12").equals("") ) {
							%>
			         	<td class="inquire_item8" id="trmethod">日工作量：</td>
							<td class="inquire_form8" ><input type="text" id="cymethod" name="cymethod<%=map.get("explorationMethod") %>" value="<%=map.get("base12") %>"/></td>	<%
							}
							%>
		 																					<%
						if(!map.get("base14").equals("") ) {
							%>
			                <td class="inquire_item8" id="trmethod1">日坐标点：</td>
							<td class="inquire_form8" ><input type="text" id="cymethod1" name="cymethod1<%=map.get("explorationMethod") %>" value="<%=map.get("base14") %>"/></td>	<%
							}
							%>
									
																							<%
						if(!map.get("base10").equals("") ) {
							%>
			         	<td class="inquire_item8" id="trmethod2">日检查点：</td>
							<td class="inquire_form8"><input type="text"  id="cymethod2" name="cymethod2<%=map.get("explorationMethod") %>" value="<%=map.get("base10") %>"/></td>	<%
							}
							%>
									
																							<%
						if(!map.get("base12").equals("") ) {
							%>
			            	<td class="inquire_item8" id="trmethod3">日物理点：</td>
							<td class="inquire_form8" ><input type="text"id="cymethod3" name="cymethod3<%=map.get("explorationMethod") %>" value="<%=map.get("base12") %>"/></td>	<%
							}
							%>
		 
						</tr>
						<tr  >
																								<%
						if(!map.get("base12").equals("") ) {
							%>
			           	<td class="inquire_item8" id="trmethod4">日返工点：</td>
							<td class="inquire_form8" ><input type="text" id="cymethod4"name="cymethod4<%=map.get("explorationMethod") %>" value="<%=map.get("base9") %>"/></td>	<%
							}
							%>
							
																									<%
						if(!map.get("base8").equals("") ) {
							%>
			          	<td class="inquire_item8" id="trmethod5">日一级品：</td>
							<td class="inquire_form8" ><input type="text" id="cymethod5" name="cymethod5<%=map.get("explorationMethod") %>" value="<%=map.get("base8") %>"/></td>	<%
							}
							%>
							
																									<%
						if(!map.get("base7").equals("") ) {
							%>
			            	<td class="inquire_item8" id="trmethod6">日合格品：</td>
							<td class="inquire_form8" ><input type="text"id="cymethod6"name="cymethod6<%=map.get("explorationMethod") %>" value="<%=map.get("base7") %>"/></td>	<%
							}
							%>
							
																									<%
						if(!map.get("base3").equals("") ) {
							%>
			            		<td class="inquire_item8" id="trmethod7">日井旁测深点：</td>
							<td class="inquire_form8" ><input type="text" id="cymethod7"name="cymethod7<%=map.get("explorationMethod") %>" value="<%=map.get("base3") %>"/></td>	<%
							}
							%>
		 
						
						</tr>
						<tr  >
																										<%
						if(!map.get("base6").equals("") ) {
							%>
			            	<td class="inquire_item8" id="trmethod8">日废品：</td>
							<td class="inquire_form8" ><input type="text" id="cymethod8" name="cymethod8<%=map.get("explorationMethod") %>" value="<%=map.get("base6") %>"/></td>	<%
							}
							%>
		 
		 																				<%
						if(!map.get("base5").equals("") ) {
							%>
			                <td class="inquire_item8" id="trmethod9">日空点：</td>
							<td class="inquire_form8" ><input type="text" id="cymethod9" name="cymethod9<%=map.get("explorationMethod") %>" value="<%=map.get("base5") %>"/></td>		<%
							}
							%>
		  

						</tr>
				
						<tr class="odd">
							<td class="inquire_item8"> 累计工作量</td>
							<td colspan="15">&nbsp;</td>
						</tr>
				
					<tr >
																						<%
						if(!map.get("base12m").equals("") ) {
							%>
			           		<td class="inquire_item8" id="summethod">累计工作量：</td>
							<td class="inquire_form8" ><input type="text" id="sumthod" name="sumthod" value="<%=map.get("base12m") %>"/></td>		<%
							}
							%>
																								<%
						if(!map.get("base14p").equals("") ) {
							%>
			              	<td class="inquire_item8" id="summethod1">累计坐标点：</td>
							<td class="inquire_form8" ><input type="text" id="sumthod1"name="sumthod1" value="<%=map.get("base14p") %>"/></td>		<%
							}
							%>
																								<%
						if(!map.get("base10k").equals("") ) {
							%>
			             			<td class="inquire_item8" id="summethod2">累计检查点：</td>
							<td class="inquire_form8"><input type="text"  id="sumthod2" name="sumthod2" value="<%=map.get("base10k") %>"/></td>	<%
							}
							%>
																								<%
						if(!map.get("base13n").equals("") ) {
							%>
			   		<td class="inquire_item8" id="summethod3">累计物理点：</td>
							<td class="inquire_form8" ><input type="text" id="sumthod3" name="sumthod3" value="<%=map.get("base13n") %>"/></td>	<%
							}
							%>
					
						
				
					

						</tr>
						<tr  >
																									<%
						if(!map.get("base9j").equals("") ) {
							%>
			   	<td class="inquire_item8" id="summethod4">累计返工点：</td>
							<td class="inquire_form8"><input type="text"  id="sumthod4" name="sumthod4" value="<%=map.get("base9j") %>"/></td>	<%
							}
							%>
																										<%
						if(!map.get("base8h").equals("") ) {
							%>
			   				<td class="inquire_item8" id="summethod5">累计一级品：</td>
							<td class="inquire_form8" ><input type="text" id="sumthod5" name="sumthod5" value="<%=map.get("base8h") %>"/></td>	<%
							}
							%>
																										<%
						if(!map.get("base7g").equals("") ) {
							%>
			   			<td class="inquire_item8" id="summethod6">累计合格品：</td>
							<td class="inquire_form8" ><input type="text" id="sumthod6" name="sumthod6" value="<%=map.get("base7g") %>"/></td><%
							}
							%>
																										<%
						if(!map.get("base3c").equals("") ) {
							%>
			    <td class="inquire_item8" id="summethod7">累计井旁测深点：</td>
							<td class="inquire_form8" ><input type="text"id="sumthod7" name="sumthod7" value="<%=map.get("base3c") %>"/></td>	<%
							}
							%>
		                	
					
						
				           
						
							
						</tr>
						<tr >
																												<%
						if(!map.get("base6f").equals("") ) {
							%>
			    		     <td class="inquire_item8" id="summethod8">累计废品：</td>
							<td class="inquire_form8" ><input type="text" id="sumthod8" name="sumthod8" value="<%=map.get("base6f") %>"/></td>	<%
							}
							%>
																													<%
						if(!map.get("base5e").equals("") ) {
							%>
			             	<td class="inquire_item8" id="summethod9">累计空点：</td>
							<td class="inquire_form8" ><input type="text"id="sumthod9"name="sumthod9" value="<%=map.get("base5e") %>"/></td>	<%
							}
							%>
					
						
						</tr>
						<tr class="odd">
							<td class="inquire_item8">效率计算</td>
							<td colspan="15">&nbsp;</td>
						</tr>
						<tr>
																														<%
						if(!map.get("lvavg").equals("") ) {
							%>
			          	<td class="inquire_item8" id="avgmethod">检查率：</td>
							<td class="inquire_form8" ><input type="text" id="avgthod" name="avgthod" value="<%=map.get("lvavg") %>"/>%</td>	<%
							}
							%>
																															<%
						if(!map.get("lvavgt").equals("") ) {
							%>
			          	<td class="inquire_item8" id="avgmethod2">返工率：</td>
							<td class="inquire_form8" ><input type="text" id="avgthod2" name="avgthod2" value="<%=map.get("lvavgt") %>"/>%</td>	<%
							}
							%>
																															<%
						if(!map.get("lvavge").equals("") ) {
							%>
			             	<td class="inquire_item8" id="avgmethod3">合格品率：</td>
							<td class="inquire_form8" ><input type="text" id="avgthod3"name="avgthod3" value="<%=map.get("lvavge") %>"/>%</td>	<%
							}
							%>
																															<%
						if(!map.get("lvavgtt").equals("") ) {
							%>
			             <td class="inquire_item8" id="avgmethod1">一级品率：</td>
							<td class="inquire_form8" ><input type="text" id="avgthod1"name="avgthod1" value="<%=map.get("lvavgtt") %>"/>%</td>	<%
							}
							%>
						
						
						
							
						</tr>
						<tr>
																																<%
						if(!map.get("lvavgv").equals("") ) {
							%>
			           	<td class="inquire_item8" id="avgmethod4">废品率：</td>
							<td class="inquire_form8" ><input type="text" id="avgthod4" name="avgthod4" value="<%=map.get("lvavgv") %>"/>%</td><%
							}
							%>
																																	<%
						if(!map.get("lvavgw").equals("") ) {
							%>
			          			<td class="inquire_item8" id="avgmethod5">空点率：</td>
							<td class="inquire_form8" ><input type="text" id="avgthod5" name="avgthod5" value="<%=map.get("lvavgw") %>"/>%</td>	<%
							}
							%>
						
				
						</tr>
					
					</table>
						<%
					             }
					   System.out.print(map.get("exploration_method"));
		             if(map.get("exmethod").equals("5110000056000000005")){
		            	 System.out.print(map.get("name"));
					 %>
						<table width="100%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height" id="hxmethod" name="hxmethod"  >
						<tr style="background-color: #97cbfd">
							<td class="inquire_item8" ><%=map.get("name")%>工作量</td>
						<td colspan="15">&nbsp;</td>
						</tr>
				<tr  class="odd">
				<td class="inquire_item8">每日工作量</td>
				<td colspan="15">&nbsp;</td>
				</tr>
						<tr>
																								<%
						if(!map.get("base12").equals("") ) {
							%>
			               		<td class="inquire_item8" id="huamethod">日工作量：</td>
							<td class="inquire_form8" ><input type="text" id="xumethod"name="xumethod<%=map.get("explorationMethod") %>" value="<%=map.get("base12") %>"/></td>		<%
							}
							%>
																									<%
						if(!map.get("base14").equals("") ) {
							%>
			         	    <td class="inquire_item8" id="huamethod1">日坐标点：</td>
							<td class="inquire_form8" ><input type="text" id="xumethod1" name="xumethod1<%=map.get("explorationMethod") %>" value="<%=map.get("base14") %>"/></td>		<%
							}
							%>
																									<%
						if(!map.get("base10").equals("") ) {
							%>
			        		<td class="inquire_item8" id="huamethod2">日检查点：</td>
							<td class="inquire_form8" ><input type="text"id="xumethod2" name="xumethod2<%=map.get("explorationMethod") %>" value="<%=map.get("base10") %>"/></td>		<%
							}
							%>
																									<%
						if(!map.get("base13").equals("") ) {
							%>
			         		<td class="inquire_item8" id="huamethod3">日物理点：</td>
							<td class="inquire_form8" ><input type="text"id="xumethod3" name="xumethod3<%=map.get("explorationMethod") %>" value="<%=map.get("base13") %>"/></td>	<%
							}
							%>
					
						
					
					
						</tr>
						<tr  >
																												<%
						if(!map.get("base9").equals("") ) {
							%>
			         			<td class="inquire_item8" id="huamethod4">日返工点：</td>
							<td class="inquire_form8" ><input type="text"id="xumethod4" name="xumethod4<%=map.get("explorationMethod") %>" value="<%=map.get("base9") %>"/></td>	<%
							}
							%>
					
																												<%
						if(!map.get("base8").equals("") ) {
							%>
			         				   <td class="inquire_item8" id="huaFirst">日一级品：</td>
							<td class="inquire_form8" ><input type="text" id="xueFirst" name="xueFirst<%=map.get("explorationMethod") %>" value="<%=map.get("base8") %>"/></td>	<%
							}
							%>
					
						
																												<%
						if(!map.get("base7").equals("") ) {
							%>
			         							<td class="inquire_item8" id="huamethod5">日合格品：</td>
							<td class="inquire_form8"><input type="text"  id="xumethod5" name="xumethod5<%=map.get("explorationMethod") %>" value="<%=map.get("base7") %>"/></td>	<%
							}
							%>
					
						
																												<%
						if(!map.get("base6").equals("") ) {
							%>
			         		<td class="inquire_item8" id="huamethod6">日废品：</td>
							<td class="inquire_form8" ><input type="text" id="xumethod6" name="xumethod6<%=map.get("explorationMethod") %>" value="<%=map.get("base6") %>"/></td>	<%
							}
							%>
					
						</tr>
						<tr>
																													<%
						if(!map.get("base5").equals("") ) {
							%>
			         		<td class="inquire_item8" id="huamethod7">日空点：</td>
							<td class="inquire_form8" ><input type="text"id="xumethod7" name="xumethod7<%=map.get("explorationMethod") %>" value="<%=map.get("base5") %>"/></td>	<%
							}
							%>
						
						</tr>
						<tr class="odd">
							<td class="inquire_item8"> 累计工作量</td>
							<td colspan="15">&nbsp;</td>
						</tr>
					<tr >
														<%
						if(!map.get("base12m").equals("") ) {
							%>
			         		<td class="inquire_item8" id="sumhua1">累计工作量：</td>
							<td class="inquire_form8" ><input type="text" id="sumxue1" name="sumxue1" value="<%=map.get("base12m") %>"/></td>	<%
							}
							%>
																<%
						if(!map.get("base14p").equals("") ) {
							%>
			        	<td class="inquire_item8" id="sumhua2">累计坐标点：</td>
							<td class="inquire_form8" ><input type="text" id="sumxue2" name="sumxue2" value="<%=map.get("base14p") %>"/></td><%
							}
							%>
																<%
						if(!map.get("base10k").equals("") ) {
							%>
			         		<td class="inquire_item8" id="sumhua3">累计检查点：</td>
							<td class="inquire_form8" ><input type="text"id="sumxue3" name="sumxue3" value="<%=map.get("base10k") %>"/></td>	<%
							}
							%>
																<%
						if(!map.get("base13n").equals("") ) {
							%>
			         		<td class="inquire_item8" id="sumhua4">累计物理点：</td>
							<td class="inquire_form8" ><input type="text" id="sumxue4"name="sumxue4" value="<%=map.get("base13n") %>"/></td>	<%
							}
							%>
						
						
						
						
						</tr>
						<tr  >
																		<%
						if(!map.get("base9j").equals("") ) {
							%>
			         	<td class="inquire_item8" id="sumhua5">累计返工点：</td>
							<td class="inquire_form8" ><input type="text" id="sumxue5" name="sumxue5" value="<%=map.get("base9j") %>"/></td>	<%
							}
							%>
																			<%
						if(!map.get("base8h").equals("") ) {
							%>
			         			<td class="inquire_item8" id="sumFirst">累计一级品：</td>
							<td class="inquire_form8" ><input type="text"id="sumFirstValue" name="sumFirstValue" value="<%=map.get("base8h") %>"/></td>     	<%
							}
							%>
																			<%
						if(!map.get("base7g").equals("") ) {
							%>
			         		<td class="inquire_item8" id="sumhua6">累计合格品：</td>
							<td class="inquire_form8" ><input type="text" id="sumxue6" name="sumxue6" value="<%=map.get("base7g") %>"/></td>
						<%
							}
							%>
																			<%
						if(!map.get("base6f").equals("") ) {
							%>
			        		<td class="inquire_item8" id="sumhua7">累计废品：</td>
							<td class="inquire_form8" ><input type="text"id="sumxue7" name="sumxue7" value="<%=map.get("base6f") %>"/></td>	<%
							}
							%>
		                
						
						
						
						</tr>
						<tr>
																				<%
						if(!map.get("base5e").equals("") ) {
							%>
			        		<td class="inquire_item8" id="sumhua8">累计空点：</td>
							<td class="inquire_form8"><input type="text" id="sumxue8"name="sumxue8" value="<%=map.get("base5e") %>"/></td>	<%
							}
							%>
						
						</tr>
						<tr class="odd">
							<td class="inquire_item8">效率计算</td>
							<td colspan="15">&nbsp;</td>
						</tr>
						<tr>
																					<%
						if(!map.get("lvavg").equals("") ) {
							%>
			        		<td class="inquire_item8" id="avghua">检查率：</td>
							<td class="inquire_form8" ><input type="text" id="avgxue" name="avgxue" value="<%=map.get("lvavg") %>"/>%</td>	<%
							}
							%>
																						<%
						if(!map.get("lvavgt").equals("") ) {
							%>
			        			<td class="inquire_item8" id="avghua1">返工率：</td>
							<td class="inquire_form8" ><input type="text" id="avgxue1" name="avgxue1" value="<%=map.get("lvavgt") %>"/>%</td>	<%
							}
							%>
																						<%
						if(!map.get("lvavge").equals("") ) {
							%>
			        		<td class="inquire_item8" id="avghua2">合格品率：</td>
							<td class="inquire_form8" ><input type="text" id="avgxue2" name="avgxue2" value="<%=map.get("lvavge") %>"/>%</td>	<%
							}
							%>
																						<%
						if(!map.get("lvavgtt").equals("") ) {
							%>
			        		<td class="inquire_item8" id="avgfirst">一级品率：</td>
							<td class="inquire_form8" ><input type="text" id="avghxfirst" name="avghxfirst" value="<%=map.get("lvavgtt") %>"/>%</td>	<%
							}
							%>
						
					
						
						
						</tr>
						<tr>
																							<%
						if(!map.get("lvavgv").equals("") ) {
							%>
			        			<td class="inquire_item8" id="avghua3">废品率：</td>
							<td class="inquire_form8"><input type="text" id="avgxue3" name="avgxue3" value="<%=map.get("lvavgv") %>"/>%</td>	<%
							}
							%>
						
																							<%
						if(!map.get("lvavgw").equals("") ) {
							%>
			        			<td class="inquire_item8" id="avghua4">空点率：</td>
							<td class="inquire_form8"><input type="text"  id="avgxue4"name="avgxue4" value="<%=map.get("lvavgw") %>"/>%</td>	<%
							}
							%>
						
					
					
						</tr>
					</table>
					
					
					
					<%
					             }
					   System.out.print(map.get("exploration_method"));
		             if(map.get("exmethod").equals("5110000056000000006")){
		            	 System.out.print(map.get("name"));
					 %>
					
						<table width="100%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height" id="gcmethod" name="gcmethod" >
						
						<tr style="background-color: #97cbfd">
							<td class="inquire_item8" ><%=map.get("name") %>工作量</td>
							
						<td colspan="15">&nbsp;</td>
						</tr>
				<tr  class="odd">
				<td class="inquire_item8">每日工作量</td>
				<td colspan="15">&nbsp;</td>
				</tr>
						<tr>
																													<%
						if(!map.get("base12").equals("") ) {
							%>
			         	<td class="inquire_item8" id="prowork">日工作量：</td>
							<td class="inquire_form8" ><input type="text" id="provalue" name="provalue<%=map.get("explorationMethod") %>" value="<%=map.get("base12") %>"/></td>	<%
							}
							%>
																														<%
						if(!map.get("base14").equals("") ) {
							%>
			         		<td class="inquire_item8" id="prowork1">日坐标点：</td>
							<td class="inquire_form8" ><input type="text"id="provalue1" name="provalue1<%=map.get("explorationMethod") %>" value="<%=map.get("base14") %>"/></td>	<%
							}
							%>
																														<%
						if(!map.get("base10").equals("") ) {
							%>
			         	<td class="inquire_item8" id="prowork2">日检查点：</td>
							<td class="inquire_form8" ><input type="text" id="provalue2" name="provalue2<%=map.get("explorationMethod") %>" value="<%=map.get("base10") %>"/></td>	<%
							}
							%>
																														<%
						if(!map.get("base13").equals("") ) {
							%>
			         			<td class="inquire_item8" id="prowork3">日物理点：</td>
							<td class="inquire_form8" ><input type="text" id="provalue3" name="provalue3<%=map.get("explorationMethod") %>" value="<%=map.get("base13") %>"/></td>	<%
							}
							%>
							
							
						
							
					
						</tr>
						<tr  >
																															<%
						if(!map.get("base9").equals("") ) {
							%>
			         	<td class="inquire_item8" id="prowork4">日返工点：</td>
							<td class="inquire_form8" ><input type="text" id="provalue4" name="provalue4<%=map.get("explorationMethod") %>" value="<%=map.get("base9") %>"/></td>	<%
							}
							%>
																																<%
						if(!map.get("base8").equals("") ) {
							%>
			         			<td class="inquire_item8" id="prowork5">日一级品：</td>
							<td class="inquire_form8"><input type="text"  id="provalue5" name="provalue5<%=map.get("explorationMethod") %>" value="<%=map.get("base8") %>"/></td>	<%
							}
							%>
																																<%
						if(!map.get("base7").equals("") ) {
							%>
			         			<td class="inquire_item8" id="prowork6">日合格品：</td>
							<td class="inquire_form8" ><input type="text" id="provalue6" name="provalue6<%=map.get("explorationMethod") %>" value="<%=map.get("base7") %>"/></td>	<%
							}
							%>
																																<%
						if(!map.get("base2").equals("") ) {
							%>
			         			    <td class="inquire_item8" id="prowork7">日重力基点：</td>
							<td class="inquire_form8" ><input type="text" id="provalue7" name="provalue7<%=map.get("explorationMethod") %>" value="<%=map.get("base2") %>"/></td>	<%
							}
							%>
						</tr>
						<tr  >
																																<%
						if(!map.get("base1").equals("") ) {
							%>
			         		   <td class="inquire_item8" id="prowork8">日磁力日变站：</td>
							<td class="inquire_form8"><input type="text" id="provalue8" name="provalue8<%=map.get("explorationMethod") %>" value="<%=map.get("base1") %>"/></td>	<%
							}
							%>
																																	<%
						if(!map.get("base3").equals("") ) {
							%>
			         			  <td class="inquire_item8" id="prowork9">日井旁测深点：</td>
							<td class="inquire_form8" ><input type="text"id="provalue9" name="provalue9<%=map.get("explorationMethod") %>" value="<%=map.get("base3") %>"/></td>	<%
							}
							%>
																																	<%
						if(!map.get("base6").equals("") ) {
							%>
			         			<td class="inquire_item8" id="prowork10">日废品：</td>
							<td class="inquire_form8" ><input type="text" id="provalue10" name="provalue10<%=map.get("explorationMethod") %>" value="<%=map.get("base6") %>"/></td>	<%
							}
							%>
						    <%
						if(!map.get("base5").equals("") ) {
							%>
			         				<td class="inquire_item8" id="prowork11">日空点：</td>
							<td class="inquire_form8" ><input type="text"id="provalue11" name="provalue11<%=map.get("explorationMethod") %>" value="<%=map.get("base5") %>"/></td>	<%
							}
							%>
							
						
						  
						
						
						
						</tr>
						<tr class="odd">
							<td class="inquire_item8"> 累计工作量</td>
							<td colspan="15">&nbsp;</td>
						</tr>
					<tr >
																																	<%
						if(!map.get("base12m").equals("") ) {
							%>
			         				<td class="inquire_item8" id="sumpro1">累计工作量：</td>
							<td class="inquire_form8" ><input type="text"id="sumvalue1" name="sumvalue1" value="<%=map.get("base12m") %>"/></td>
						<%
							}
							%>
							
																																			<%
						if(!map.get("base14p").equals("") ) {
							%>
			         			<td class="inquire_item8" id="sumpro2">累计坐标点：</td>
							<td class="inquire_form8" ><input type="text" id="sumvalue2" name="sumvalue2" value="<%=map.get("base14p") %>"/></td>	<%
							}
							%>
							
																																			<%
						if(!map.get("base10k").equals("") ) {
							%>
			         				<td class="inquire_item8" id="sumpro3">累计检查点：</td>
							<td class="inquire_form8" ><input type="text"id="sumvalue3" name="sumvalue3" value="<%=map.get("base10k") %>"/></td>	<%
							}
							%>
							
						   <%
						if(!map.get("base13n").equals("") ) {
							%>
			         			<td class="inquire_item8" id="sumpro4">累计物理点：</td>
							<td class="inquire_form8" ><input type="text" id="sumvalue4"name="sumvalue4" value="<%=map.get("base13n") %>"/></td>	<%
							}
							%>
							
							
					
						
						

						</tr>
						<tr  >
																																			<%
						if(!map.get("base9j").equals("") ) {
							%>
			         		<td class="inquire_item8" id="sumpro5">累计返工点：</td>
							<td class="inquire_form8" ><input type="text" id="sumvalue5" name="sumvalue5" value="<%=map.get("base9j")%>"/></td>	<%
							}
							%>
																																				<%
						if(!map.get("base8h").equals("") ) {
							%>
			         			<td class="inquire_item8" id="sumpro6">累计一级品：</td>
							<td class="inquire_form8" ><input type="text" id="sumvalue6"name="sumvalue6" value="<%=map.get("base8h")%>"/></td>	<%
							}
							%>
																																				<%
						if(!map.get("base7g").equals("") ) {
							%>
			         		<td class="inquire_item8" id="sumpro7">累计合格品：</td>
							<td class="inquire_form8" ><input type="text" id="sumvalue7" name="sumvalue7" value="<%=map.get("base7g")%>"/></td>	<%
							}
							%>
																																				<%
						if(!map.get("base2b").equals("") ) {
							%>
			         				<td class="inquire_item8" id="sumpro8">累计重力基点：</td>
							<td class="inquire_form8" ><input type="text"id="sumvalue8" name="sumvalue8" value="<%=map.get("base2b")%>"/></td><%
							}
							%>
		                
						
						
						
						</tr>
						<tr >
																																					<%
						if(!map.get("base1a").equals("") ) {
							%>
			         			<td class="inquire_item8" id="sumpro9">累计磁力日变站：</td>
							<td class="inquire_form8" ><input type="text" id="sumvalue9" name="sumvalue9" value="<%=map.get("base1a")%>"/></td><%
							}
							%>
		                
		                																															<%
						if(!map.get("base3c").equals("") ) {
							%>
			         					<td class="inquire_item8" id="sumpro10">累计井旁测深点：</td>
							<td class="inquire_form8" ><input type="text" id="sumvalue10"name="sumvalue10" value="<%=map.get("base3c")%>"/></td><%
							}
							%>
		                
		                																															<%
						if(!map.get("base6f").equals("") ) {
							%>
			         			<td class="inquire_item8" id="sumpro11">累计废品：</td>
							<td class="inquire_form8"  ><input type="text"id="sumvalue11" name="sumvalue11" value="<%=map.get("base6f")%>"/></td><%
							}
							%>
		                
		                	 <%
						if(!map.get("base5e").equals("") ) {
							%>
			         				<td class="inquire_item8" id="sumpro12">累计空点：</td>
							<td class="inquire_form8" ><input type="text"id="sumvalue12" name="sumvalue12" value="<%=map.get("base5e")%>"/></td><%
							}
							%>
		                
						
						
							
						
						</tr>
						<tr class="odd">
							<td class="inquire_item8">效率计算</td>
							<td colspan="15">&nbsp;</td>
						</tr>
						<tr>
						 		<%
						if(!map.get("lvavg").equals("") ) {
							%>
			         			<td class="inquire_item8" id="avgpro">检查率：</td>
							<td class="inquire_form8"><input type="text"  id="avgvalue"name="avgvalue" value="<%=map.get("lvavg")%>"/>%</td>
						<%
							}
							%>
		                
						
						   																															<%
						if(!map.get("lvavgt").equals("") ) {
							%>
			         	<td class="inquire_item8" id="avgpro1">返工率：</td>
							<td class="inquire_form8" ><input type="text" id="avgvalue1" name="avgvalue1" value="<%=map.get("lvavgt")%>"/>%</td>
						<%
							}
							%>
		                         <%
						if(!map.get("lvavge").equals("") ) {
							%>
			         			<td class="inquire_item8" id="avgpro2">合格品率：</td>
							<td class="inquire_form8" > <input type="text" id="avgvalue2" name="avgvalue2" value="<%=map.get("lvavge")%>"/> </td><%
							}
							%>
						
					       <%
						if(!map.get("base0").equals("") ) {
							%>
			         			<td class="inquire_item8" id="avgpro3">一级品率：</td>
							<td class="inquire_form8" ><input type="text" id="avgvalue3"name="avgvalue3" value="<%=map.get("base0")%>"/>%</td><%
							}
							%>
		                
						
						
						
						</tr>
						<tr>
						
						   																															<%
						if(!map.get("lvavgv").equals("") ) {
							%>
			         			<td class="inquire_item8" id="avgpro4">废品率：</td>
							<td class="inquire_form8" ><input type="text" id="avgvalue4"name="avgvalue4" value="<%=map.get("lvavgv")%>"/>%</td><%
							}
							%>
							
						   																															<%
						if(!map.get("lvavgw").equals("") ) {
							%>
			         			<td class="inquire_item8" id="avgpro5">空点率：</td>
							<td class="inquire_form8"><input type="text"  id="avgvalue5" name="avgvalue5" value="<%=map.get("lvavgw")%>"/>%</td><%
							}
							%>
						
						
						</tr>
					</table>
			<%
		             }           
			             
			 	 }
			             %>
			         
	 
			</form>
		<iframe width="100%" height="100%" name="dailyQuestion" id="dailyQuestion" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: auto;"></iframe>
		</div>
	</div>
</body>


<script type="text/javascript">
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function cancel() {
		window.close();
	}

	function save() {
		//if (!checkForm()) return;
		document.getElementById("form1").submit();
	}

	function refreshData() {
		//var ctt = top.frames('list').frames[1];
		//var file_name = document.getElementsByName("file_name")[0].value;
		//ctt.refreshData(undefined, file_name);
		//newClose();
		document.getElementById("form1").submit();
		newClose();
	}
</script>
</html>