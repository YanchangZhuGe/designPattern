<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page
	import="com.bgp.mcs.service.wt.pm.service.dailyReport.WtDailyReportSrv"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.constant.MVCConstant"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	//String weather = request.getParameter("weather");
	String daily_no = request.getParameter("daily_no_wt");
     //System.out.print(daily_no);
	String projectInfoNo = request.getParameter("project_info_no");
	String status = request.getParameter("status");
	 String build = request.getParameter("build");
	String produce_date = request.getParameter("produce_date");

	if (projectInfoNo == null || "".equals(projectInfoNo)) {
		UserToken user = OMSMVCUtil.getUserToken(request);
		projectInfoNo = user.getProjectInfoNo();
	}
	//System.out.print( "build"+build);
			 

	if (produce_date == null) {
		produce_date = "null";
	}
	WtDailyReportSrv wtsrv = new WtDailyReportSrv();

	List<Map> list = (List) wtsrv.getExplorationName(projectInfoNo, produce_date);

	List<Map> list2 = (List) wtsrv.getExplorationUnit(projectInfoNo,produce_date);



	

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@page import="com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider"%><html>
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
	
<link id="artDialogSkin" href="<%=contextPath %>/js/artDialog/skins/blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath %>/js/artDialog/artDialog.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/artDialog/iframeTools.js"></script>
</head>


<script type="text/javascript">
debugger;
function viewPicture(path){
	//alert(path);
	//alert('<img src="'+path+'" width="450" height="175" />');
	 art.dialog({
		    padding: 0,
		    title: '图片',
		    content: '<img  src="'+path+'" width="500" height="330" />',
		    lock: true
		});
}
function queryProduce(){
	var dataVal = $("#produceDate").val();
	window.location.href = '<%=contextPath%>/pm/dailyReport/singleProject/wt/viewDailyReport.jsp?produce_date='+dataVal;
 
	
}

cruConfig.contextPath = "<%=contextPath%>";
cruConfig.cdtType = 'form';
var produceDate;



function page_init(type){
	debugger;
	var produceDate ="";
	if(produceDate == null || produceDate == ""){
		produceDate = '<%=produce_date%>';
	} 

	
	var retObj = jcdpCallService("WtDailyReportSrv", "getDailyReportDate", "projectInfoNo=<%=projectInfoNo%>&produceDate="+produceDate);
	 auditStatus=retObj.build.auditStatus;
	var weather = retObj.build.weather;
	var build = retObj.build.ifBuild;
//	var ary = retObj.datas;
  //  alert(auditStatus);
  	
  if(auditStatus=="1"){
		 debugger;
		 //document.getElementById("audit_status").innerHTML = '日报已提交,待审批!';
		 document.getElementById("tj_btn").style.display="inline";
		 document.getElementById("gb_btn").style.display="inline";
		 
  }else if( auditStatus=="3"){
		// document.getElementById("audit_status").innerHTML = '审批通过!';
		 document.getElementById("tj_btn").style.display="none";
		 document.getElementById("gb_btn").style.display="none";
		 document.getElementById("cx_btn").colSpan="2";
		 
  }else if(auditStatus=="4"){
	   //  document.getElementById("audit_status").innerHTML = '审批不通过!';
		 document.getElementById("tj_btn").style.display="none";
		 document.getElementById("gb_btn").style.display="none";
		 document.getElementById("cx_btn").colSpan="2";

  }else if(auditStatus=="0"){
	 // document.getElementById("audit_status").innerHTML = '日报未提交!';
		 document.getElementById("tj_btn").style.display="inline";
		 document.getElementById("gb_btn").style.display="inline";
  }

	if( build == "" || build == null){
		document.getElementById("IF_BUILD").innerHTML = '';
	} else if(build == "1"){
		document.getElementById("IF_BUILD").innerHTML = '动迁';
	} else if(build == "2"){
		document.getElementById("IF_BUILD").innerHTML = '踏勘';
	
	}else if(build == "3"){
		document.getElementById("IF_BUILD").innerHTML = '建网';
	} else if(build == "4"){
		document.getElementById("IF_BUILD").innerHTML = '培训';
	} else if(build == "5"){
		document.getElementById("IF_BUILD").innerHTML = '试验';
	} else if(build == "6"){
		document.getElementById("IF_BUILD").innerHTML = '采集';
	}else if(build == "7"){
		document.getElementById("IF_BUILD").innerHTML = '整理';
	} else if(build == "8"){
		document.getElementById("IF_BUILD").innerHTML = '验收';
	} else if(build == "9"){
		document.getElementById("IF_BUILD").innerHTML = '遣散';
	} else if(build == "10"){
		document.getElementById("IF_BUILD").innerHTML = '归档';
	} else if(build== "11"){
		document.getElementById("IF_BUILD").innerHTML = '停工';
	} else if(build == "12"){
		document.getElementById("IF_BUILD").innerHTML = '暂停';
	} else if(build == "13"){
		document.getElementById("IF_BUILD").innerHTML = '结束';
	}  
	if(weather == "" || weather == null){
		document.getElementById("WEATHER").innerHTML = '';
	} else if(weather == "1"){
		document.getElementById("WEATHER").innerHTML = '晴';
	} else if(weather == "2"){
		document.getElementById("WEATHER").innerHTML = '阴';
	} else if(weather == "3"){
		document.getElementById("WEATHER").innerHTML = '多云';
	} else if(weather == "4"){
		document.getElementById("WEATHER").innerHTML = '雨';
	} else if(weather == "5"){
		document.getElementById("WEATHER").innerHTML = '雾';
	} else if(weather == "6"){
		document.getElementById("WEATHER").innerHTML = '霾';
	} else if(weather == "7"){
		document.getElementById("WEATHER").innerHTML = '霜冻';
	} else if(weather == "8"){
		document.getElementById("WEATHER").innerHTML = '暴风';
	} else if(weather == "9"){
		document.getElementById("WEATHER").innerHTML = '台风';
	} else if(weather == "10"){
		document.getElementById("WEATHER").innerHTML = '暴风雪';
	} else if(weather == "11"){
		document.getElementById("WEATHER").innerHTML = '雪';
	} else if(weather == "12"){
		document.getElementById("WEATHER").innerHTML = '雨夹雪';
	} else if(weather == "13"){
		document.getElementById("WEATHER").innerHTML = '冰雹';
	} else if(weather == "14"){
		document.getElementById("WEATHER").innerHTML = '浮尘';
	} else if(weather == "15"){
		document.getElementById("WEATHER").innerHTML = '扬沙';
	} else if(weather == "16"){
		document.getElementById("WEATHER").innerHTML = '其他';
	} else if(weather == "17"){
		document.getElementById("WEATHER").innerHTML = '大风';
	}
	
   
	document.getElementById("dailyQuestion").src = "<%=contextPath%>/pm/dailyReport/singleProject/dailyQuestionList.jsp?projectInfoNo=<%=projectInfoNo %>&produceDate="+produceDate;

}

</script>
<body style="overflow: scroll;" onload="page_init()">
	<div id="tab_box" class="tab_box">
		<div id="tab_box_content0" class="tab_box_content">
			<form id="form1" method="post">
				<table width="100%" border="0" cellspacing="0" cellpadding="0"
					class="tab_line_height">
					<tr style="background-color: #97cbfd">
						<td class="inquire_item8">生产日期：</td>
						<td class="inquire_form8"><input type="hidden"
							name="daily_no" id="daily_no" /> <input type="text"
							name="produceDate" id='produceDate' value='<%=produce_date%>'
							readonly="readonly" />&nbsp;&nbsp; <img
							src="<%=contextPath%>/images/calendar.gif" id="tributton1"
							width="16" height="16" style="cursor: hand;"
							onmouseover="calDateSelector(produceDate,tributton1);" />&nbsp;&nbsp;
						
							<font color="red" style="text-align: right;" id="audit_status"></font>
						</td>
						
						<td class="inquire_form4" style="width: 1%">&nbsp;</td>
						 	<auth:ListButton tdid="cx_btn" functionId="" css="cx" event="onclick='queryProduce()'" title="JCDP_btn_query"></auth:ListButton>
						<!--<auth:ListButton tdid="tj_btn" functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>-->

						 	
 						<!--<auth:ListButton tdid="tj_btn" functionId="" css="tj" event="onclick='toSubmit(3)'" title="JCDP_btn_audit"></auth:ListButton>-->
	                	<!--<auth:ListButton tdid="gb_btn" functionId="" css="gb" event="onclick='toSubmit(4)'" title="JCDP_btn_audit"></auth:ListButton>-->

						 
					</tr>
				</table>
			</form>

			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				class="tab_line_height">
				<tr class="even">
				   <td class="inquire_item6">项目状态：</td>
					<td class="inquire_form6" id="IF_BUILD"></td>
			
				
					
					<td class="inquire_item6">天气：</td>
					<td class="inquire_form6" name="WEATHER" id='WEATHER' value=''></td>
					<td class="inquire_item6">&nbsp;</td>
					<td class="inquire_form6">&nbsp;</td>
				</tr>
<%
				List listIbuild=wtsrv.getIbuild(projectInfoNo,produce_date);
				
				for(int t=0;t<listIbuild.size();t++){
					Map mapTest=(Map)listIbuild.get(t);
					System.out.print(mapTest.get("ifBuild")+","+mapTest.get("name"));
					if(!mapTest.get("ifBuild").equals("6")&&!mapTest.get("ifBuild").equals("11")&&!mapTest.get("ifBuild").equals("12")&&!mapTest.get("ifBuild").equals("13")){
						%>
						<th class="inquire_form6" ><%=mapTest.get("name")%></th>
						<%
					}
				}
				%>
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

				<tr class="odd">
					<td class="inquire_item8">每日工作量</td>
					<td colspan="15">&nbsp;</td>
				</tr>
				<tr>
					<%
				if(!map.get("sumce1").equals("")) {
				%>
					<td class="inquire_item8" id="gpscong">日GPS控制点：</td>
					<td class="inquire_form8" id="gpscon1"><%=map.get("sumce1") %></td>
					<%
				}
			 
				if(!map.get("sumce5").equals("")) {
				%>
					<td class="inquire_item8" id="gpscong1">日坐标点：</td>
					<td class="inquire_form8" id="gpscon2"><%=map.get("sumce5") %></td>
					<%
				}
				if(!map.get("sumce2").equals("")) {
					%>
					<td class="inquire_item8" id="gpscong2">日复测点：</td>
					<td class="inquire_form8" id="gpscon3"><%=map.get("sumce2") %></td>
					<%
					}
				if(!map.get("sumce3").equals("")) {
					%>
					<td class="inquire_item8" id="gpscong3">日地形改正点：</td>
					<td class="inquire_form8" id="gpscon4"><%=map.get("sumce3") %></td>
					<%
					}
					%>

				</tr>
				<tr>
					<%
				if(!map.get("sumce4").equals("") ) {
					%>
					<td class="inquire_item8" id="gpscong4">日地改检查点：</td>
					<td class="inquire_form8" id="gpscon5"><%=map.get("sumce4") %></td>
					<%
					}
					%>

				</tr>
				<tr class="odd">
					<td>&nbsp;&nbsp;&nbsp;&nbsp; 累计工作量</td>
					<td colspan="15"></td>
				</tr>
				<tr>
					<%
				if(!map.get("sumceA").equals("") ) {
					%>
					<td class="inquire_item8" id="sumceg">累计GPS控制点：</td>
					<td class="inquire_form8" id="sumce"><%=map.get("sumceA") %></td>
					<%
					}
					%>
					<%
				if(!map.get("sumceE").equals("") ) {
					%>
					<td class="inquire_item8" id="sumceg1">累计坐标点：</td>
					<td class="inquire_form8" id="sumce1"><%=map.get("sumceE") %></td>
					</td>
					<%
					}
					%>
					<%
				if(!map.get("sumceB").equals("") ) {
					%>
					<td class="inquire_item8" id="sumceg2">累计复测点：</td>
					<td class="inquire_form8" id="sumce2"><%=map.get("sumceB") %></td>
					<%
					}
					%>
					<%
				if(!map.get("sumceC").equals("") ) {
					%>
					<td class="inquire_item8" id="sumceg3">累计地形改正点：</td>
					<td class="inquire_form8" id="sumce3"><%=map.get("sumceC") %></td>
					<%
					}
					%>
				</tr>
				<tr>
					<%
				if(!map.get("sumceD").equals("") ) {
					%>
					<td class="inquire_item8" id="sumceg4">累计地改检查点：</td>
					<td class="inquire_form8" id="sumce4"><%=map.get("sumceD") %></td>
					<%
					}
					%>

				</tr>
				<tr class="odd">
					<td>&nbsp;&nbsp;&nbsp;&nbsp;效率计算</td>
					<td colspan="15"></td>
				</tr>
				<tr>
					<%
				if(!map.get("avgcet").equals("") ) {
					%>
					<td class="inquire_item8" id="avgcetg">复测率：</td>
					<td class="inquire_form8" id="avgcet"><%=map.get("avgcet") %>%</td>
					<%
					}
					%>
					<%
				if(!map.get("lvttce").equals("") ) {
					%>
					<td class="inquire_item8" id="lvttceg">地改检查率：</td>
					<td class="inquire_form8" id="lvttce"><%=map.get("lvttce") %>%</td>
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
				class="tab_line_height" id="zlMethod" name="zlMethod">

				<tr style="background-color: #97cbfd">
					<td class="inquire_item8"><%=map.get("name")%>工作量</td>
					<td class="inquire_item8" id="location">设计坐标点：</td>
					<td class="inquire_form8" id="locationValue"><%=map.get("locationPoint") %>
					
					
					&nbsp;&nbsp;&nbsp;&nbsp;完成百分比：<%=map.get("pointavg") %>%</td>
					<td class="inquire_item8" id="Length">设计工作量：</td>
					<td id="LengthValue"><%=map.get("lineLength") %>
					<%
					  if(map.get("lineUnit").equals("4")){
						  %>
						  (KM²)
						  <%
					  }else if(map.get("lineUnit").equals("3")){
						  %>
						  (M²)
						  <%
					  }else if(map.get("lineUnit").equals("2")){
						  %>
						  (KM)
						  <%
					  }else if(map.get("lineUnit").equals("1")){
						  %>
						  (M)
						  <%
					  }
					%>
					&nbsp;&nbsp;&nbsp;&nbsp;完成百分比：<%=map.get("lengthavg") %>%</td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr class="odd">
					<td class="inquire_item8">每日工作量</td>
					<td colspan="15">&nbsp;</td>
				</tr>
				<tr>
					<%
				if(!map.get("base12").equals("") ) {
					
					
					%>
					<td class="inquire_item8" id="basep">日工作量：</td>

					<%
						         for(int k=0;k<list2.size();k++){
						        	 Map mapU=(Map)list2.get(k);
						        	 
						         
						        	 if(mapU.get("exploration_method"+k).equals(map.get("explorationMethod"))){
						        		 if(mapU.get("method"+k)==null||mapU.get("method"+k).equals("")){
						        			 %>
					<td class="inquire_form8" id="base12"><%=map.get("base12") %></td>
					<%
						        		 }else if(mapU.get("method"+k).equals("4")){
						        			 %>
					<td class="inquire_form8" id="base12"><%=map.get("base12") %>(KM²)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("2")){
						        			 %>
					<td class="inquire_form8" id="base12"><%=map.get("base12") %>(KM)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("3")){
						        			 %>
					<td class="inquire_form8" id="base12"><%=map.get("base12") %>(M²)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("1")){
						        			 %>
					<td class="inquire_form8" id="base12"><%=map.get("base12") %>(M)</td>
					<%
						        		 }
						        	 }
						         }
						 
 
						 
					}
					%>
					<%
				if(!map.get("base14").equals("") ) {
					%>
					<td class="inquire_item8" id="basep1">日坐标点：</td>
					<td class="inquire_form8" id="base14"><%=map.get("base14") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base10").equals("") ) {
					%>
					<td class="inquire_item8" id="basep2">日检查点：</td>
					<td class="inquire_form8" id="base10"><%=map.get("base10")%></td>
					<%
					}
					%>
					<%
				if(!map.get("base13").equals("") ) {
					%>
					<td class="inquire_item8" id="basep3">日物理点：</td>
					<td class="inquire_form8" id="base13"><%=map.get("base13") %></td>
					<%
					}
					%>





				</tr>
				<tr>
					<%
				if(!map.get("base9").equals("") ) {
					%>
					<td class="inquire_item8" id="basep4">日返工点：</td>
					<td class="inquire_form8" id="base9"><%=map.get("base9") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base8").equals("") ) {
					%>
					<td class="inquire_item8" id="basep5">日一级品：</td>
					<td class="inquire_form8" id="base8"><%=map.get("base8") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base7").equals("") ) {
					%>
					<td class="inquire_item8" id="basep6">日合格品：</td>
					<td class="inquire_form8" id="base7"><%=map.get("base7") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base11").equals("") ) {
					%>
					<td class="inquire_item8" id="basep7">日基点：</td>
					<td class="inquire_form8" id="base11"><%=map.get("base11") %></td>
					<%
					}
					%>



				</tr>
				<tr>
					<%
				if(!map.get("base6").equals("") ) {
					%>
					<td class="inquire_item8" id="basep8">日废品：</td>
					<td class="inquire_form8" id="base6"><%=map.get("base6") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base5").equals("") ) {
					%>
					<td class="inquire_item8" id="basep9">日空点：</td>
					<td class="inquire_form8" id="base5"><%=map.get("base5") %></td>
					<%
					}
					%>





				</tr>



				<tr class="odd">
					<td class="inquire_item8">累计工作量</td>
					<td colspan="15">&nbsp;</td>
				</tr>
				
				
	               <%
				if(!map.get("base12m").equals("") ) {
					%>
						<td class="inquire_item8" id="sump">累计工作量：</td>
					<%
						         for(int k=0;k<list2.size();k++){
						        	 Map mapU=(Map)list2.get(k);
						        	 
						         
						        	 if(mapU.get("exploration_method"+k).equals(map.get("explorationMethod"))){
						        		 if(mapU.get("method"+k)==null||mapU.get("method"+k).equals("")){
					  %>
					<td class="inquire_form8" id="sum1"><%=map.get("base12m") %></td>
					<%
						        		 }else if(mapU.get("method"+k).equals("4")){
						        			 %>
					<td class="inquire_form8" id="sum1"><%=map.get("base12m") %>(KM²)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("2")){
						        			 %>
					<td class="inquire_form8" id="sum1"><%=map.get("base12m") %>(KM)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("3")){
						        			 %>
					<td class="inquire_form8" id="sum1"><%=map.get("base12m") %>(M²)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("1")){
						        			 %>
					<td class="inquire_form8" id="sum1"><%=map.get("base12m") %>(M)</td>
					<%
						        		 }
						        	 }
						         }
			 	 
					}
					%>

					<%
				if(!map.get("base14p").equals("") ) {
					%>
					<td class="inquire_item8" id="sump1">累计坐标点：</td>
					<td class="inquire_form8" id="sum12"><%=map.get("base14p") %></td>
					<%
					}
					%>

					<%
				if(!map.get("base10k").equals("") ) {
					%>
					<td class="inquire_item8" id="sump2">累计检查点：</td>
					<td class="inquire_form8" id="sum3"><%=map.get("base10k") %></td>
					<%
					}
					%>

					<%
				if(!map.get("base13n").equals("") ) {
					%>
					<td class="inquire_item8" id="sump3">累计物理点：</td>
					<td class="inquire_form8" id="sum13"><%=map.get("base13n") %>
					</td>
					<%
					}
					%>







				</tr>
				<tr>
					<%
				if(!map.get("base9j").equals("") ) {
					%>
					<td class="inquire_item8" id="sumf4">累计返工点：</td>
					<td class="inquire_form8" id="sum4"><%=map.get("base9j") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base8h").equals("") ) {
					%>
					<td class="inquire_item8" id="sumpy">累计一级品：</td>
					<td class="inquire_form8" id="sum5"><%=map.get("base8h")%></td>
					<%
					}
					%>
					<%
				if(!map.get("base7g").equals("") ) {
					%>
					<td class="inquire_item8" id="sumhg">累计合格品：</td>
					<td class="inquire_form8" id="sum6"><%=map.get("base7g") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base11l").equals("") ) {
					%>
					<td class="inquire_item8" id="sumpj">累计基点：</td>
					<td class="inquire_form8" id="sum2"><%=map.get("base11l") %></td>
					<%
					}
					%>








				</tr>
				<tr>
					<%
				if(!map.get("base6f").equals("") ) {
					%>
					<td class="inquire_item8" id="sump5">累计废品：</td>
					<td class="inquire_form8" id="sum7"><%=map.get("base6f")%></td>
					<%
					}
				
                 
            
				if(!map.get("base5e").equals("") ) {
					%>
					<td class="inquire_item8" id="sump6">累计空点：</td>
					<td class="inquire_form8" id="sum8"><%=map.get("base5e") %></td>
					<%
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
					<td class="inquire_form8" id="avgz1"><%=map.get("lvavg") %>%</td>
					<%
					}
					%>

					<%
				if(!map.get("lvavgt").equals("") ) {
					%>
					<td class="inquire_item8" id="avgzp2">返工率：</td>
					<td class="inquire_form8" id="avgz3"><%=map.get("lvavgt") %>%</td>
					<%
					}
					%>

					<%
				if(!map.get("lvavge").equals("") ) {
					%>
					<td class="inquire_item8" id="avgzp3">合格品率：</td>
					<td class="inquire_form8" id="avgz5"><%=map.get("lvavge") %>%</td>
					<%
					}
					%>

					<%
				if(!map.get("lvavgtt").equals("")) {
					%>
					<td class="inquire_item8" id="avgzp1">一级品率：</td>
					<td class="inquire_form8" id="avgz2"><%=map.get("lvavgtt") %>%</td>
					<%
					}
					%>





				</tr>
				<tr>
					<%
				if(!map.get("lvavgv").equals("") ) {
					%>
					<td class="inquire_item8" id="avgzp4">废品率：</td>
					<td class="inquire_form8" id="avgz4"><%=map.get("lvavgv") %>%</td>
					<%
					}
					%>

					<%
				if(!map.get("lvavgw").equals("") ) {
					%>
					<td class="inquire_item8" id="avgzp5">空点率：</td>
					<td class="inquire_form8" id="avgz6"><%=map.get("lvavgw") %>%</td>
					<%
					}
					%>

				</tr>
				<tr>
					<td class="inquire_item8">施工进度图：</td>
					<td class="inquire_form8"><div id="<%=map.get("explorationMethod") %>Image" style="color: red"></div></td>
				</tr>
			</table>




			<%
             }
			   if(map.get("exmethod").equals("5110000056000000002")){
	            	 System.out.print(map.get("name"));
				 %>


			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				class="tab_line_height" id="clMethod" name="clMethod">

				<tr style="background-color: #97cbfd">
					<td class="inquire_item8"><%=map.get("name")%>工作量</td>
					<td class="inquire_item8" id="location">设计坐标点：</td>
					<td id="locationValue"><%=map.get("locationPoint") %>&nbsp;&nbsp;&nbsp;&nbsp;完成百分比：<%=map.get("pointavg") %>%</td>
					<td class="inquire_item8" id="Length">设计工作量：</td>
					<td id="LengthValue"><%=map.get("lineLength") %>
					<%
					  if(map.get("lineUnit").equals("4")){
						  %>
						  (KM²)
						  <%
					  }else if(map.get("lineUnit").equals("3")){
						  %>
						  (M²)
						  <%
					  }else if(map.get("lineUnit").equals("2")){
						  %>
						  (KM)
						  <%
					  }else if(map.get("lineUnit").equals("1")){
						  %>
						  (M)
						  <%
					  }
					%>
					&nbsp;&nbsp;&nbsp;&nbsp;完成百分比：<%=map.get("lengthavg") %>%</td>
					<td colspan="3">&nbsp;</td>

				</tr>
				<tr class="odd">
					<td class="inquire_item8">每日工作量</td>
					<td colspan="15">&nbsp;</td>
				</tr>
				<tr>
					<%
				if(!map.get("base12").equals("") ) {
					%>
					<td class="inquire_item8" id="workcl">日工作量：</td>
					<%
						         for(int k=0;k<list2.size();k++){
						        	 Map mapU=(Map)list2.get(k);
						        	 
						         
						        	 if(mapU.get("exploration_method"+k).equals(map.get("explorationMethod"))){
						        		 if(mapU.get("method"+k)==null||mapU.get("method"+k).equals("")){
						        			 %>
					<td class="inquire_form8" id="load1"><%=map.get("base12") %></td>
					<%
						        		 }else if(mapU.get("method"+k).equals("4")){
						        			 %>
					<td class="inquire_form8" id="load1"><%=map.get("base12") %>(KM²)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("2")){
						        			 %>
					<td class="inquire_form8" id="load1"><%=map.get("base12") %>(KM)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("3")){
						        			 %>
					<td class="inquire_form8" id="load1"><%=map.get("base12") %>(M²)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("1")){
						        			 %>
					<td class="inquire_form8" id="load1"><%=map.get("base12") %>(M)</td>
					<%
						        		 }
						        	 }
						         }
				  
					}
					%>
					<%
				if(!map.get("base14").equals("") ) {
					%>
					<td class="inquire_item8" id="work2">日坐标点：</td>
					<td class="inquire_form8" id="load2"><%=map.get("base14") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base10").equals("") ) {
					%>
					<td class="inquire_item8" id="work3">日检查点：</td>
					<td class="inquire_form8" id="load3"><%=map.get("base10") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base13").equals("") ) {
					%>
					<td class="inquire_item8" id="work4">日物理点：</td>
					<td class="inquire_form8" id="load4"><%=map.get("base13")%></td>
					<%
					}
					%>




				</tr>
				<tr>
					<%
				if(!map.get("base9").equals("") ) {
					%>
					<td class="inquire_item8" id="work5">日返工点：</td>
					<td class="inquire_form8" id="load5"><%=map.get("base9") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base8").equals("") ) {
					%>
					<td class="inquire_item8" id="work6">日一级品：</td>
					<td class="inquire_form8" id="load6"><%=map.get("base8")%></td>
					<%
					}
					%>
					<%
				if(!map.get("base7").equals("") ) {
					%>
					<td class="inquire_item8" id="work7">日合格品：</td>
					<td class="inquire_form8" id="load7"><%=map.get("base7")%></td>
					<%
					}
					%>

					<%
				if(!map.get("base4").equals("") ) {
					%>
					<td class="inquire_item8" id="work8">日变站：</td>
					<td class="inquire_form8" id="load8"><%=map.get("base4") %></td>
					<%
					}
					%>




				</tr>
				<tr>
					<%
				if(!map.get("base6").equals("") ) {
					%>
					<td class="inquire_item8" id="work9">日废品：</td>
					<td class="inquire_form8" id="load9"><%=map.get("base6") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base5").equals("") ) {
					%>
					<td class="inquire_item8" id="work10">日空点：</td>
					<td class="inquire_form8" id="load10"><%=map.get("base5") %></td>
					<%
					}
					%>





				</tr>

				<tr class="odd">
					<td class="inquire_item8">累计工作量</td>
					<td colspan="15">&nbsp;</td>
				</tr>

				<tr>
					<%
				if(!map.get("base12m").equals("") ) {
					%>
					<td class="inquire_item8" id="sumcl">累计工作量：</td>
					<%
						         for(int k=0;k<list2.size();k++){
						        	 Map mapU=(Map)list2.get(k);
						        	 
						         
						        	 if(mapU.get("exploration_method"+k).equals(map.get("explorationMethod"))){
						        		 if(mapU.get("method"+k)==null||mapU.get("method"+k).equals("")){
						        			 %>
					<td class="inquire_form8" id="sumgzl"><%=map.get("base12m") %></td>
					<%
						        		 }else if(mapU.get("method"+k).equals("4")){
						        			 %>
					<td class="inquire_form8" id="sumgzl"><%=map.get("base12m") %>(KM²)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("2")){
						        			 %>
					<td class="inquire_form8" id="sumgzl"><%=map.get("base12m") %>(KM)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("3")){
						        			 %>
					<td class="inquire_form8" id="sumgzl"><%=map.get("base12m") %>(M²)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("1")){
						        			 %>
					<td class="inquire_form8" id="sumgzl"><%=map.get("base12m") %>(M)</td>
					<%
						        		 }
						        	 }
						         }
				 
					}
					%>
					<%
				if(!map.get("base14p").equals("") ) {
					%>
					<td class="inquire_item8" id="sumc2">累计坐标点：</td>
					<td class="inquire_form8" id="sumzbd"><%=map.get("base14p") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base10k").equals("") ) {
					%>
					<td class="inquire_item8" id="sumc3">累计检查点：</td>
					<td class="inquire_form8" id="sumjcd"><%=map.get("base10k") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base13n").equals("") ) {
					%>
					<td class="inquire_item8" id="sumc4">累计物理点：</td>
					<td class="inquire_form8" id="sumwld"><%=map.get("base13n") %></td>
					<%
					}
					%>






				</tr>
				<tr>
					<%
				if(!map.get("base9j").equals("") ) {
					%>
					<td class="inquire_item8" id="sumc5">累计返工点：</td>
					<td class="inquire_form8" id="sumfgd"><%=map.get("base9j") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base8h").equals("") ) {
					%>
					<td class="inquire_item8" id="sumc6">累计一级品：</td>
					<td class="inquire_form8" id="sumyjp"><%=map.get("base8h") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base7g").equals("") ) {
					%>
					<td class="inquire_item8" id="sumc7">累计合格品：</td>
					<td class="inquire_form8" id="sumhgp"><%=map.get("base7g") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base4d").equals("") ) {
					%>
					<td class="inquire_item8" id="sumc8">累计日变站：</td>
					<td class="inquire_form8" id="sumrbz"><%=map.get("base4d")%></td>
					<%
					}
					%>






				</tr>
				<tr>
					<%
				if(!map.get("base6f").equals("") ) {
					%>
					<td class="inquire_item8" id="sumc9">累计废品：</td>
					<td class="inquire_form8" id="sumfp"><%=map.get("base6f") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base5e").equals("") ) {
			 
					%>
					<td class="inquire_item8" id="sumc10">累计空点：</td>
					<td class="inquire_form8" id="sumkd"><%=map.get("base5e") %></td>
					<%
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
					<td class="inquire_form8" id="avgc1"><%=map.get("lvavg") %>%</td>
					<%
					}
					%>
					<%
				if(!map.get("lvavgt").equals("") ) {
					%>
					<td class="inquire_item8" id="avgfg">返工率：</td>
					<td class="inquire_form8" id="avgc2"><%=map.get("lvavgt")  %>%</td>
					<%
					}
					%>
					<%
				if(!map.get("lvavge").equals("") ) {
					%>
					<td class="inquire_item8" id="avghg">合格品率：</td>
					<td class="inquire_form8" id="avgc3"><%=map.get("lvavge")%>%</td>
					<%
					}
					%>
					<%
				if(!map.get("lvavgtt").equals("") ) {
					%>
					<td class="inquire_item8" id="avgyjp">一级品率：</td>
					<td class="inquire_form8" id="avgc4"><%=map.get("lvavgtt") %>%
					</td>
					<%
					}
					%>




				</tr>
				<tr>
					<%
				if(!map.get("lvavgv").equals("") ) {
					%>
					<td class="inquire_item8" id="avgfp">废品率：</td>
					<td class="inquire_form8" id="avgc5"><%=map.get("lvavgv")%>%</td>
					<%
					}
					%>
					<%
				if(!map.get("lvavgw").equals("") ) {
					%>
					<td class="inquire_item8" id="avgkd">空点率：</td>
					<td class="inquire_form8" id="avgc6"><%=map.get("lvavgw") %>%</td>
					<%
					}
					%>

				</tr>
				<tr>
					<td class="inquire_item8">勘探方法图：</td>
					<td class="inquire_form8"><div id="<%=map.get("explorationMethod") %>Image" style="color: red"></div></td>
				</tr>
			</table>
					<%
             }
			   if(map.get("exmethod").equals("5110000056000000003")){
	            	 System.out.print(map.get("name"));
				 %>

			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				class="tab_line_height" id="trcy" name="trcy">


				<tr style="background-color: #97cbfd">
					<td class="inquire_item8"><%=map.get("name")%>工作量</td>
					<td class="inquire_item8" id="location">设计坐标点：</td>
					<td class="inquire_form8" id="locationValue"><%=map.get("locationPoint") %>&nbsp;&nbsp;&nbsp;&nbsp;完成百分比：<%=map.get("pointavg") %>%</td>
					<td class="inquire_item8" id="Length">设计工作量：</td>
					<td id="LengthValue"><%=map.get("lineLength") %>
					<%
					  if(map.get("lineUnit").equals("4")){
						  %>
						  (KM²)
						  <%
					  }else if(map.get("lineUnit").equals("3")){
						  %>
						  (M²)
						  <%
					  }else if(map.get("lineUnit").equals("2")){
						  %>
						  (KM)
						  <%
					  }else if(map.get("lineUnit").equals("1")){
						  %>
						  (M)
						  <%
					  }
					%>
					&nbsp;&nbsp;&nbsp;&nbsp;完成百分比：<%=map.get("lengthavg") %>%</td>
					<td colspan="4">&nbsp;</td>

				</tr>
				<tr class="odd">
					<td class="inquire_item8">每日工作量</td>
					<td colspan="15">&nbsp;</td>
				</tr>
				<tr>

					<%
				if(!map.get("base12").equals("") ) {
					%>
					<td class="inquire_item8" id="trmethod">日工作量：</td>
					<%
						         for(int k=0;k<list2.size();k++){
						        	 Map mapU=(Map)list2.get(k);
						        	 
						         
						        	 if(mapU.get("exploration_method"+k).equals(map.get("explorationMethod"))){
						        		 if(mapU.get("method"+k)==null||mapU.get("method"+k).equals("")){
						        			 %>
					<td class="inquire_form8" id="cymethod"><%=map.get("base12") %></td>
					<%
						        		 }else if(mapU.get("method"+k).equals("4")){
						        			 %>
					<td class="inquire_form8" id="cymethod"><%=map.get("base12") %>(KM2)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("2")){
						        			 %>
					<td class="inquire_form8" id="cymethod"><%=map.get("base12") %>(KM)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("3")){
						        			 %>
					<td class="inquire_form8" id="cymethod"><%=map.get("base12") %>(M2)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("1")){
						        			 %>
					<td class="inquire_form8" id="cymethod"><%=map.get("base12") %>(M)</td>
					<%
						        		 }
						        	 }
						         }
				 
				 
					}
					%>
					<%
				if(!map.get("base14").equals("") ) {
					%>
					<td class="inquire_item8" id="trmethod1">日坐标点：</td>
					<td class="inquire_form8" id="cymethod1"><%=map.get("base14") %></td>
					<%
					}
					%>

					<%
				if(!map.get("base10").equals("") ) {
					%>
					<td class="inquire_item8" id="trmethod2">日检查点：</td>
					<td class="inquire_form8" id="cymethod2"><%=map.get("base10") %></td>
					<%
					}
					%>

					<%
				if(!map.get("base12").equals("") ) {
					%>
					<td class="inquire_item8" id="trmethod3">日物理点：</td>
					<td class="inquire_form8" id="cymethod3"><%=map.get("base13") %></td>
					<%
					}
					%>

				</tr>
				<tr>
					<%
				if(!map.get("base12").equals("") ) {
					%>
					<td class="inquire_item8" id="trmethod4">日返工点：</td>
					<td class="inquire_form8" id="cymethod4"><%=map.get("base9") %></td>
					<%
					}
					%>

					<%
				if(!map.get("base8").equals("") ) {
					%>
					<td class="inquire_item8" id="trmethod5">日一级品：</td>
					<td class="inquire_form8" id="cymethod5"><%=map.get("base8") %></td>
					<%
					}
					%>

					<%
				if(!map.get("base7").equals("") ) {
					%>
					<td class="inquire_item8" id="trmethod6">日合格品：</td>
					<td class="inquire_form8" id="cymethod6"><%=map.get("base7") %></td>
					<%
					}
					%>

					<%
				if(!map.get("base3").equals("") ) {
					%>
					<td class="inquire_item8" id="trmethod7">日井旁测深点：</td>
					<td class="inquire_form8" id="cymethod7"><%=map.get("base3") %></td>
					<%
					}
					%>


				</tr>
				<tr>
					<%
				if(!map.get("base6").equals("") ) {
					%>
					<td class="inquire_item8" id="trmethod8">日废品：</td>
					<td class="inquire_form8" id="cymethod8"><%=map.get("base6") %></td>
					<%
					}
					%>

					<%
				if(!map.get("base5").equals("") ) {
					%>
					<td class="inquire_item8" id="trmethod9">日空点：</td>
					<td class="inquire_form8" id="cymethod9"><%=map.get("base5") %></td>
					<%
					}
					%>


				</tr>

				<tr class="odd">
					<td class="inquire_item8">累计工作量</td>
					<td colspan="15">&nbsp;</td>
				</tr>

				<tr>
					<%
				if(!map.get("base12m").equals("") ) {
					%>
					<td class="inquire_item8" id="summethod">累计工作量：</td>
					<%
						         for(int k=0;k<list2.size();k++){
						        	 Map mapU=(Map)list2.get(k);
						        	 
						         
						        	 if(mapU.get("exploration_method"+k).equals(map.get("explorationMethod"))){
						        		 if(mapU.get("method"+k)==null||mapU.get("method"+k).equals("")){
						        			 %>
					<td class="inquire_form8" id="sumthod"><%=map.get("base12m") %></td>
					<%
						        		 }else if(mapU.get("method"+k).equals("4")){
						        			 %>
					<td class="inquire_form8" id="sumthod"><%=map.get("base12m") %>(KM2)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("2")){
						        			 %>
					<td class="inquire_form8" id="sumthod"><%=map.get("base12m") %>(KM)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("3")){
						        			 %>
					<td class="inquire_form8" id="sumthod"><%=map.get("base12m") %>(M2)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("1")){
						        			 %>
					<td class="inquire_form8" id="sumthod"><%=map.get("base12m") %>(M)</td>
					<%
						        		 }
						        	 }
						         }
				 
					}
					%>
					<%
				if(!map.get("base14p").equals("") ) {
					%>
					<td class="inquire_item8" id="summethod1">累计坐标点：</td>
					<td class="inquire_form8" id="sumthod1"><%=map.get("base14p") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base10k").equals("") ) {
					%>
					<td class="inquire_item8" id="summethod2">累计检查点：</td>
					<td class="inquire_form8" id="sumthod2"><%=map.get("base10k") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base13n").equals("") ) {
					%>
					<td class="inquire_item8" id="summethod3">累计物理点：</td>
					<td class="inquire_form8" id="sumthod3"><%=map.get("base13n") %></td>
					<%
					}
					%>





				</tr>
				<tr>
					<%
				if(!map.get("base9j").equals("") ) {
					%>
					<td class="inquire_item8" id="summethod4">累计返工点：</td>
					<td class="inquire_form8" id="sumthod4"><%=map.get("base9j") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base8h").equals("") ) {
					%>
					<td class="inquire_item8" id="summethod5">累计一级品：</td>
					<td class="inquire_form8" id="sumthod5"><%=map.get("base8h") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base7g").equals("") ) {
					%>
					<td class="inquire_item8" id="summethod6">累计合格品：</td>
					<td class="inquire_form8" id="sumthod6"><%=map.get("base7g") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base3c").equals("") ) {
					%>
					<td class="inquire_item8" id="summethod7">累计井旁测深点：</td>
					<td class="inquire_form8" id="sumthod7"><%=map.get("base3c") %></td>
					<%
					}
					%>






				</tr>
				<tr>
					<%
				if(!map.get("base6f").equals("") ) {
					%>
					<td class="inquire_item8" id="summethod8">累计废品：</td>
					<td class="inquire_form8" id="sumthod8"><%=map.get("base6f") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base5e").equals("") ) {
					%>
					<td class="inquire_item8" id="summethod9">累计空点：</td>
					<td class="inquire_form8" id="sumthod9"><%=map.get("base5e") %></td>
					<%
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
					<td class="inquire_form8" id="avgthod"><%=map.get("lvavg") %>%</td>
					<%
					}
					%>
					<%
				if(!map.get("lvavgt").equals("") ) {
					%>
					<td class="inquire_item8" id="avgmethod2">返工率：</td>
					<td class="inquire_form8" id="avgthod2"><%=map.get("lvavgt") %>%</td>
					<%
					}
					%>
					<%
				if(!map.get("lvavge").equals("") ) {
					%>
					<td class="inquire_item8" id="avgmethod3">合格品率：</td>
					<td class="inquire_form8" id="avgthod3"><%=map.get("lvavge") %>%</td>
					<%
					}
					%>
					<%
				if(!map.get("lvavgtt").equals("") ) {
					%>
					<td class="inquire_item8" id="avgmethod1">一级品率：</td>
					<td class="inquire_form8" id="avgthod1"><%=map.get("lvavgtt") %>%</td>
					<%
					}
					%>




				</tr>
				<tr>
					<%
				if(!map.get("lvavgv").equals("") ) {
					%>
					<td class="inquire_item8" id="avgmethod4">废品率：</td>
					<td class="inquire_form8" id="avgthod4"><%=map.get("lvavgv") %>%</td>
					<%
					}
					%>
					<%
				if(!map.get("lvavgw").equals("") ) {
					%>
					<td class="inquire_item8" id="avgmethod5">空点率：</td>
					<td class="inquire_form8" id="avgthod5"><%=map.get("lvavgw") %>%</td>
					<%
					}
					%>


				</tr>
				<tr>
					<td class="inquire_item8">勘探方法图：</td>
					<td class="inquire_form8"><div id="<%=map.get("explorationMethod") %>Image" style="color: red"></div></td>
				</tr>
			</table>

			<%
             }
			   if(map.get("exmethod").equals("5110000056000000004")){
	            	 System.out.print(map.get("name"));
				 %>
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				class="tab_line_height" id="rgcy" name="rgcy">

				<tr style="background-color: #97cbfd">
					<td class="inquire_item8"><%=map.get("name")%>工作量</td>
					<td class="inquire_item8" id="location">设计坐标点：</td>
					<td class="inquire_form8" id="locationValue"><%=map.get("locationPoint") %>&nbsp;&nbsp;&nbsp;&nbsp;完成百分比：<%=map.get("pointavg") %>%</td>
					<td class="inquire_item8" id="Length">设计工作量：</td>
					<td id="LengthValue"><%=map.get("lineLength") %>
					<%
					  if(map.get("lineUnit").equals("4")){
						  %>
						  (KM²)
						  <%
					  }else if(map.get("lineUnit").equals("3")){
						  %>
						  (M²)
						  <%
					  }else if(map.get("lineUnit").equals("2")){
						  %>
						  (KM)
						  <%
					  }else if(map.get("lineUnit").equals("1")){
						  %>
						  (M)
						  <%
					  }
					%>
					
					&nbsp;&nbsp;&nbsp;&nbsp;完成百分比：<%=map.get("lengthavg") %>%</td>
					<td colspan="4">&nbsp;</td>

				</tr>
				<tr class="odd">
					<td class="inquire_item8">每日工作量</td>
					<td colspan="15">&nbsp;</td>
				</tr>

				<tr>
					<%
			if(!map.get("base12").equals("") ) {
				%>
					<td class="inquire_item8" id="basework">日工作量：</td>
					<%
		       for(int k=0;k<list2.size();k++){
			  	 Map mapU=(Map)list2.get(k);
						 if(mapU.get("exploration_method"+k).equals(map.get("explorationMethod"))){
						      	 if(mapU.get("method"+k)==null||mapU.get("method"+k).equals("")){
						        	 %>
					<td class="inquire_form8" id="bw1"><%=map.get("base12") %></td>
					<%
						        		 }else if(mapU.get("method"+k).equals("4")){
						        			 %>
					<td class="inquire_form8" id="bw1"><%=map.get("base12") %>(KM²)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("2")){
						        			 %>
					<td class="inquire_form8" id="bw1"><%=map.get("base12") %>(KM)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("3")){
						        			 %>
					<td class="inquire_form8" id="bw1"><%=map.get("base12") %>(M²)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("1")){
						        			 %>
					<td class="inquire_form8" id="bw1"><%=map.get("base12") %>(M)</td>
					<%
						        		 }
						        	 }
						         }
			 
					}
					%>
					<%
				if(!map.get("base14").equals("") ) {
					%>
					<td class="inquire_item8" id="basework2">日坐标点：</td>
					<td class="inquire_form8" id="bw2"><%=map.get("base14")%></td>
					<%
					}
					%>
					<%
				if(!map.get("base10").equals("") ) {
					%>
					<td class="inquire_item8" id="basework3">日检查点：</td>
					<td class="inquire_form8" id="bw3"><%=map.get("base10")%></td>
					<%
					}
					%>
					<%
				if(!map.get("base13").equals("") ) {
					%>
					<td class="inquire_item8" id="basework4">日物理点：</td>
					<td class="inquire_form8" id="bw4"><%=map.get("base13")%></td>
					<%
					}
					%>




				</tr>
				<tr>
					<%
				if(!map.get("base9").equals("") ) {
					%>

					<td class="inquire_item8" id="basepwork5">日返工点：</td>
					<td class="inquire_form8" id="bw5"><%=map.get("base9")%></td>
					<%
					}
					%>
					<%
				if(!map.get("base8").equals("") ) {
					%>
					<td class="inquire_item8" id="basepwork6">日一级品：</td>
					<td class="inquire_form8" id="bw6"><%=map.get("base8")%></td>
					<%
					}
					%>
					<%
				if(!map.get("base7").equals("") ) {
					%>
					<td class="inquire_item8" id="basepwork7">日合格品：</td>
					<td class="inquire_form8" id="bw7"><%=map.get("base7")%></td>
					<%
					}
					%>
					<%
				if(!map.get("base6").equals("") ) {
					%>
					<td class="inquire_item8" id="basework8">日废品：</td>
					<td class="inquire_form8" id="bw8"><%=map.get("base6")%></td>
					<%
					}
					%>






				</tr>
				<tr>
					<%
				if(!map.get("base5").equals("") ) {
					%>
					<td class="inquire_item8" id="basework9">日空点：</td>
					<td class="inquire_form8" id="bw9"><%=map.get("base5")%></td>
					<%
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
					<%
						         for(int k=0;k<list2.size();k++){
						        	 Map mapU=(Map)list2.get(k);
						        	 
						         
						        	 if(mapU.get("exploration_method"+k).equals(map.get("explorationMethod"))){
						        		 if(mapU.get("method"+k)==null||mapU.get("method"+k).equals("")){
						        			 %>
					<td class="inquire_form8" id="sw1"><%=map.get("base12m") %></td>
					<%
						        		 }else if(mapU.get("method"+k).equals("4")){
						        			 %>
					<td class="inquire_form8" id="sw1"><%=map.get("base12m") %>(KM²)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("2")){
						        			 %>
					<td class="inquire_form8" id="sw1"><%=map.get("base12m") %>(KM)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("3")){
						        			 %>
					<td class="inquire_form8" id="sw1"><%=map.get("base12m") %>(M²)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("1")){
						        			 %>
					<td class="inquire_form8" id="sw1"><%=map.get("base12m") %>(M)</td>
					<%
						        		 }
						        	 }
						         }
				 
				 
					}
					%>
					<%
				if(!map.get("base14p").equals("") ) {
					%>
					<td class="inquire_item8" id="sumwork2">累计坐标点：</td>
					<td class="inquire_form8" id="sw2"><%=map.get("base14p")%></td>
					<%
					}
					%>
					<%
				if(!map.get("base10k").equals("") ) {
					%>
					<td class="inquire_item8" id="sumwork3">累计检查点：</td>
					<td class="inquire_form8" id="sw3"><%=map.get("base10k")%></td>
					<%
					}
					%>
					<%
				if(!map.get("base13n").equals("") ) {
					%>
					<td class="inquire_item8" id="sumwork4">累计物理点：</td>
					<td class="inquire_form8" id="sw4"><%=map.get("base13n")%></td>
					<%
					}
					%>





				</tr>
				<tr>
					<%
				if(!map.get("base9j").equals("") ) {
					%>
					<td class="inquire_item8" id="sumwork5">累计返工点：</td>
					<td class="inquire_form8" id="sw5"><%=map.get("base9j")%></td>
					<%
					}
					%>
					<%
				if(!map.get("base8h").equals("") ) {
					%>
					<td class="inquire_item8" id="sumwork6">累计一级品：</td>
					<td class="inquire_form8" id="sw6"><%=map.get("base8h")%></td>
					<%
					}
					%>
					<%
				if(!map.get("base7g").equals("") ) {
					%>
					<td class="inquire_item8" id="sumwork7">累计合格品：</td>
					<td class="inquire_form8" id="sw7"><%=map.get("base7g")%></td>
					<%
					}
					%>
					<%
				if(!map.get("base6f").equals("") ) {
					%>
					<td class="inquire_item8" id="sumwork8">累计废品：</td>
					<td class="inquire_form8" id="sw8"><%=map.get("base6f")%></td>
					<%
					}
					%>





				</tr>
				<tr>
					<%
				if(!map.get("base5e").equals("") ) {
					%>
					<td class="inquire_item8" id="sumwork9">累计空点：</td>
					<td class="inquire_form8" id="sw9"><%=map.get("base5e")%></td>
					<%
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
					<td class="inquire_form8" id="avgtr"><%=map.get("lvavg")%>%</td>
					<%
					}
					%>
					<%
				if(!map.get("lvavgt").equals("") ) {
					%>
					<td class="inquire_item8" id="avgrg1">返工率：</td>
					<td class="inquire_form8" id="avgtr1"><%=map.get("lvavgt")%>%</td>
					<%
					}
					%>
					<%
				if(!map.get("lvavge").equals("") ) {
					%>
					<td class="inquire_item8" id="avgrg2">合格品率：</td>
					<td class="inquire_form8" id="avgtr2"><%=map.get("lvavge")%>%</td>
					<%
					}
					%>
					<%
				if(!map.get("lvavgtt").equals("") ) {
					%>
					<td class="inquire_item8" id="avgrg3">一级品率：</td>
					<td class="inquire_form8" id="avgtr3"><%=map.get("lvavgtt")%>%</td>
					<%
					}
					%>




				</tr>
				<tr>
					<%
				if(!map.get("lvavgv").equals("") ) {
					%>
					<td class="inquire_item8" id="avgrg4">废品率：</td>
					<td class="inquire_form8" id="avgtr4"><%=map.get("lvavgv")%>%</td>
					<%
					}
					%>
					<%
				if(!map.get("lvavgw").equals("") ) {
					%>
					<td class="inquire_item8" id="avgrg5">空点率：</td>
					<td class="inquire_form8" id="avgtr5"><%=map.get("lvavgw")%>%</td>
					<%
					}
					%>
				</tr>
				<tr>
					<td class="inquire_item8">勘探方法图：</td>
					<td class="inquire_form8"><div id="<%=map.get("explorationMethod") %>Image" style="color: red"></div></td>
				</tr>
			</table>



			<%
			             }
			   System.out.print(map.get("exploration_method"));
             if(map.get("exmethod").equals("5110000056000000005")){
            	 System.out.print(map.get("name"));
			 %>
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				class="tab_line_height" id="hxmethod" name="hxmethod">
				<tr style="background-color: #97cbfd">
					<td class="inquire_item8"><%=map.get("name")%>工作量</td>
					<td class="inquire_item8" id="location">设计坐标点：</td>
					<td class="inquire_form8" id="locationValue"><%=map.get("locationPoint") %>&nbsp;&nbsp;&nbsp;&nbsp;完成百分比：<%=map.get("pointavg") %>%</td>
					<td class="inquire_item8" id="Length">设计工作量：</td>
					<td id="LengthValue"><%=map.get("lineLength") %>
					
					<%
					  if(map.get("lineUnit").equals("4")){
						  %>
						  (KM²)
						  <%
					  }else if(map.get("lineUnit").equals("3")){
						  %>
						  (M²)
						  <%
					  }else if(map.get("lineUnit").equals("2")){
						  %>
						  (KM)
						  <%
					  }else if(map.get("lineUnit").equals("1")){
						  %>
						  (M)
						  <%
					  }
					%>
					&nbsp;&nbsp;&nbsp;&nbsp;完成百分比：<%=map.get("lengthavg") %>%</td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr class="odd">
					<td class="inquire_item8">每日工作量</td>
					<td colspan="15">&nbsp;</td>
				</tr>
				<tr>
					<%
				if(!map.get("base12").equals("") ) {
					%>

					<td class="inquire_item8" id="huamethod">日工作量：</td>
					<%
						         for(int k=0;k<list2.size();k++){
						        	 Map mapU=(Map)list2.get(k);
						        	 
						         
						        	 if(mapU.get("exploration_method"+k).equals(map.get("explorationMethod"))){
						        		 if(mapU.get("method"+k)==null||mapU.get("method"+k).equals("")){
						        			 %>
					<td class="inquire_form8" id="xumethod"><%=map.get("base12") %></td>
					<%
						        		 }else if(mapU.get("method"+k).equals("4")){
						        			 %>
					<td class="inquire_form8" id="xumethod"><%=map.get("base12m") %>(KM²)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("2")){
						        			 %>
					<td class="inquire_form8" id="xumethod"><%=map.get("base12") %>(KM)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("3")){
						        			 %>
					<td class="inquire_form8" id="xumethod"><%=map.get("base12") %>(M²)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("1")){
						        			 %>
					<td class="inquire_form8" id="xumethod"><%=map.get("base12") %>(M)</td>
					<%
						        		 }
						        	 }
						         }
				 
					}
					%>
					<%
				if(!map.get("base14").equals("") ) {
					%>
					<td class="inquire_item8" id="huamethod1">日坐标点：</td>
					<td class="inquire_form8" id="xumethod1"><%=map.get("base14") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base10").equals("") ) {
					%>
					<td class="inquire_item8" id="huamethod2">日检查点：</td>
					<td class="inquire_form8" id="xumethod2"><%=map.get("base10") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base13").equals("") ) {
					%>
					<td class="inquire_item8" id="huamethod3">日物理点：</td>
					<td class="inquire_form8" id="xumethod3"><%=map.get("base13") %></td>
					<%
					}
					%>




				</tr>
				<tr>
					<%
				if(!map.get("base9").equals("") ) {
					%>
					<td class="inquire_item8" id="huamethod4">日返工点：</td>
					<td class="inquire_form8" id="xumethod4"><%=map.get("base9") %></td>
					<%
					}
					%>

					<%
				if(!map.get("base8").equals("") ) {
					%>
					<td class="inquire_item8" id="huaFirst">日一级品：</td>
					<td class="inquire_form8" id="xueFirst"><%=map.get("base8") %></td>
					<%
					}
					%>


					<%
				if(!map.get("base7").equals("") ) {
					%>
					<td class="inquire_item8" id="huamethod5">日合格品：</td>
					<td class="inquire_form8" id="xumethod5"><%=map.get("base7") %></td>
					<%
					}
					%>


					<%
				if(!map.get("base6").equals("") ) {
					%>
					<td class="inquire_item8" id="huamethod6">日废品：</td>
					<td class="inquire_form8" id="xumethod6"><%=map.get("base6") %></td>
					<%
					}
					%>

				</tr>
				<tr>
					<%
				if(!map.get("base5").equals("") ) {
					%>
					<td class="inquire_item8" id="huamethod7">日空点：</td>
					<td class="inquire_form8" id="xumethod7"><%=map.get("base5") %></td>
					<%
					}
					%>

				</tr>
				<tr class="odd">
					<td class="inquire_item8">累计工作量</td>
					<td colspan="15">&nbsp;</td>
				</tr>
				<tr>
					<%
				if(!map.get("base12m").equals("") ) {
					%>
					<td class="inquire_item8" id="sumhua1">累计工作量：</td>
					<%
						         for(int k=0;k<list2.size();k++){
						        	 Map mapU=(Map)list2.get(k);
						        	 
						         
						        	 if(mapU.get("exploration_method"+k).equals(map.get("explorationMethod"))){
						        		 if(mapU.get("method"+k)==null||mapU.get("method"+k).equals("")){
						        			 %>
					<td class="inquire_form8" id="sumxue1"><%=map.get("base12m") %></td>
					<%
						        		 }else if(mapU.get("method"+k).equals("4")){
						        			 %>
					<td class="inquire_form8" id="sumxue1"><%=map.get("base12m") %>(KM²)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("2")){
						        			 %>
					<td class="inquire_form8" id="sumxue1"><%=map.get("base12m") %>(KM)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("3")){
						        			 %>
					<td class="inquire_form8" id="sumxue1"><%=map.get("base12m") %>(M²)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("1")){
						        			 %>
					<td class="inquire_form8" id="sumxue1"><%=map.get("base12m") %>(M)</td>
					<%
						        		 }
						        	 }
						         }
				 
					}
					%>
					<%
				if(!map.get("base14p").equals("") ) {
					%>
					<td class="inquire_item8" id="sumhua2">累计坐标点：</td>
					<td class="inquire_form8" id="sumxue2"><%=map.get("base14p") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base10k").equals("") ) {
					%>
					<td class="inquire_item8" id="sumhua3">累计检查点：</td>
					<td class="inquire_form8" id="sumxue3"><%=map.get("base10k") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base13n").equals("") ) {
					%>
					<td class="inquire_item8" id="sumhua4">累计物理点：</td>
					<td class="inquire_form8" id="sumxue4"><%=map.get("base13n") %></td>
					<%
					}
					%>




				</tr>
				<tr>
					<%
				if(!map.get("base9j").equals("") ) {
					%>
					<td class="inquire_item8" id="sumhua5">累计返工点：</td>
					<td class="inquire_form8" id="sumxue5"><%=map.get("base9j") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base8h").equals("") ) {
					%>
					<td class="inquire_item8" id="sumFirst">累计一级品：</td>
					<td class="inquire_form8" id="sumFirstValue"><%=map.get("base8h") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base7g").equals("") ) {
					%>
					<td class="inquire_item8" id="sumhua6">累计合格品：</td>
					<td class="inquire_form8" id="sumxue6"><%=map.get("base7g") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base6f").equals("") ) {
					%>
					<td class="inquire_item8" id="sumhua7">累计废品：</td>
					<td class="inquire_form8" id="sumxue7"><%=map.get("base6f") %></td>
					<%
					}
					%>




				</tr>
				<tr>
					<%
				if(!map.get("base5e").equals("") ) {
					%>
					<td class="inquire_item8" id="sumhua8">累计空点：</td>
					<td class="inquire_form8" id="sumxue8"><%=map.get("base5e") %></td>
					<%
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
					<td class="inquire_form8" id="avgxue"><%=map.get("lvavg") %>%</td>
					<%
					}
					%>
					<%
				if(!map.get("lvavgt").equals("") ) {
					%>
					<td class="inquire_item8" id="avghua1">返工率：</td>
					<td class="inquire_form8" id="avgxue1"><%=map.get("lvavgt") %>%</td>
					<%
					}
					%>
					<%
				if(!map.get("lvavge").equals("") ) {
					%>
					<td class="inquire_item8" id="avghua2">合格品率：</td>
					<td class="inquire_form8" id="avgxue2"><%=map.get("lvavge") %>%</td>
					<%
					}
					%>
					<%
				if(!map.get("lvavgtt").equals("") ) {
					%>
					<td class="inquire_item8" id="avgfirst">一级品率：</td>
					<td class="inquire_form8" id="avghxfirst"><%=map.get("lvavgtt") %>%</td>
					<%
					}
					%>




				</tr>
				<tr>
					<%
				if(!map.get("lvavgv").equals("") ) {
					%>
					<td class="inquire_item8" id="avghua3">废品率：</td>
					<td class="inquire_form8" id="avgxue3"><%=map.get("lvavgv") %>%</td>
					<%
					}
					%>

					<%
				if(!map.get("lvavgw").equals("") ) {
					%>
					<td class="inquire_item8" id="avghua4">空点率：</td>
					<td class="inquire_form8" id="avgxue4"><%=map.get("lvavgw") %>%</td>
					<%
					}
					%>
				</tr>
				<tr>
					<td class="inquire_item8">勘探方法图：</td>
					<td class="inquire_form8"><div id="<%=map.get("explorationMethod") %>Image"></div></td>
				</tr>
			</table>



			<%
			             }
			   System.out.print(map.get("exploration_method"));
             if(map.get("exmethod").equals("5110000056000000006")){
            	 System.out.print(map.get("name"));
			 %>

			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				class="tab_line_height" id="gcmethod" name="gcmethod">

				<tr style="background-color: #97cbfd">
					<td class="inquire_item8"><%=map.get("name") %>工作量</td>
					<td class="inquire_item8" id="location">设计坐标点：</td>
					<td class="inquire_form8" id="locationValue"><%=map.get("locationPoint") %>&nbsp;&nbsp;&nbsp;&nbsp;完成百分比：<%=map.get("pointavg") %>%</td>
					<td class="inquire_item8" id="Length">设计工作量：</td>
					<td id="LengthValue"><%=map.get("lineLength") %>
					<%
					  if(map.get("lineUnit").equals("4")){
						  %>
						  (KM²)
						  <%
					  }else if(map.get("lineUnit").equals("3")){
						  %>
						  (M²)
						  <%
					  }else if(map.get("lineUnit").equals("2")){
						  %>
						  (KM)
						  <%
					  }else if(map.get("lineUnit").equals("1")){
						  %>
						  (M)
						  <%
					  }
					%>
					&nbsp;&nbsp;&nbsp;&nbsp;完成百分比：<%=map.get("lengthavg") %>%</td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr class="odd">
					<td class="inquire_item8">每日工作量</td>
					<td colspan="15">&nbsp;</td>
				</tr>
				<tr>
					<%
				if(!map.get("base12").equals("") ) {
					%>
					<td class="inquire_item8" id="prowork">日工作量：</td>
					<%
						         for(int k=0;k<list2.size();k++){
						        	 Map mapU=(Map)list2.get(k);
						        	 
						         
						        	 if(mapU.get("exploration_method"+k).equals(map.get("explorationMethod"))){
						        		 if(mapU.get("method"+k)==null||mapU.get("method"+k).equals("")){
						        			 %>
					<td class="inquire_form8" id="provalue"><%=map.get("base12") %></td>
					<%
						        		 }else if(mapU.get("method"+k).equals("4")){
						        			 %>
					<td class="inquire_form8" id="provalue"><%=map.get("base12") %>(KM²)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("2")){
						        			 %>
					<td class="inquire_form8" id="provalue"><%=map.get("base12") %>(KM)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("3")){
						        			 %>
					<td class="inquire_form8" id="provalue"><%=map.get("base12") %>(M²)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("1")){
						        			 %>
					<td class="inquire_form8" id="provalue"><%=map.get("base12") %>(M)</td>
					<%
						        		 }
						        	 }
						         }
				 
					}
					%>
					<%
				if(!map.get("base14").equals("") ) {
					%>
					<td class="inquire_item8" id="prowork1">日坐标点：</td>
					<td class="inquire_form8" id="provalue1"><%=map.get("base14") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base10").equals("") ) {
					%>
					<td class="inquire_item8" id="prowork2">日检查点：</td>
					<td class="inquire_form8" id="provalue2"><%=map.get("base10") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base13").equals("") ) {
					%>
					<td class="inquire_item8" id="prowork3">日物理点：</td>
					<td class="inquire_form8" id="provalue3"><%=map.get("base13") %></td>
					<%
					}
					%>





				</tr>
				<tr>
					<%
				if(!map.get("base9").equals("") ) {
					%>
					<td class="inquire_item8" id="prowork4">日返工点：</td>
					<td class="inquire_form8" id="provalue4"><%=map.get("base9") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base8").equals("") ) {
					%>
					<td class="inquire_item8" id="prowork5">日一级品：</td>
					<td class="inquire_form8" id="provalue5"><%=map.get("base8") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base7").equals("") ) {
					%>
					<td class="inquire_item8" id="prowork6">日合格品：</td>
					<td class="inquire_form8" id="provalue6"><%=map.get("base7") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base2").equals("") ) {
					%>
					<td class="inquire_item8" id="prowork7">日重力基点：</td>
					<td class="inquire_form8" id="provalue7"><%=map.get("base2") %></td>
					<%
					}
					%>
				</tr>
				<tr>
					<%
				if(!map.get("base1").equals("") ) {
					%>
					<td class="inquire_item8" id="prowork8">日磁力日变站：</td>
					<td class="inquire_form8" id="provalue8"><%=map.get("base1") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base3").equals("") ) {
					%>
					<td class="inquire_item8" id="prowork9">日井旁测深点：</td>
					<td class="inquire_form8" id="provalue9"><%=map.get("base3") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base6").equals("") ) {
					%>
					<td class="inquire_item8" id="prowork10">日废品：</td>
					<td class="inquire_form8" id="provalue10"><%=map.get("base6") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base5").equals("") ) {
					%>
					<td class="inquire_item8" id="prowork11">日空点：</td>
					<td class="inquire_form8" id="provalue11"><%=map.get("base5") %></td>
					<%
					}
					%>






				</tr>
				<tr class="odd">
					<td class="inquire_item8">累计工作量</td>
					<td colspan="15">&nbsp;</td>
				</tr>
				<tr>
					<%
				if(!map.get("base12m").equals("") ) {
					%>
					<td class="inquire_item8" id="sumpro1">累计工作量：</td>
					<%
						         for(int k=0;k<list2.size();k++){
						        	 Map mapU=(Map)list2.get(k);
						        	 
						         
						        	 if(mapU.get("exploration_method"+k).equals(map.get("explorationMethod"))){
						        		 if(mapU.get("method"+k)==null||mapU.get("method"+k).equals("")){
						        			 %>
					<td class="inquire_form8" id="sumvalue1"><%=map.get("base12m") %></td>
					<%
						        		 }else if(mapU.get("method"+k).equals("4")){
						        			 %>
					<td class="inquire_form8" id="sumvalue1"><%=map.get("base12m") %>(KM²)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("2")){
						        			 %>
					<td class="inquire_form8" id="sumvalue1"><%=map.get("base12m") %>(KM)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("3")){
						        			 %>
					<td class="inquire_form8" id="sumvalue1"><%=map.get("base12m") %>(M²)</td>
					<%
						        		 }else if(mapU.get("method"+k).equals("1")){
						        			 %>
					<td class="inquire_form8" id="sumvalue1"><%=map.get("base12m") %>(M)</td>
					<%
						        		 }
						        	 }
						         }
			 
					}
					%>

					<%
				if(!map.get("base14p").equals("") ) {
					%>
					<td class="inquire_item8" id="sumpro2">累计坐标点：</td>
					<td class="inquire_form8" id="sumvalue2"><%=map.get("base14p") %></td>
					<%
					}
					%>

					<%
				if(!map.get("base10k").equals("") ) {
					%>
					<td class="inquire_item8" id="sumpro3">累计检查点：</td>
					<td class="inquire_form8" id="sumvalue3"><%=map.get("base10k") %></td>
					<%
					}
					%>

					<%
				if(!map.get("base13n").equals("") ) {
					%>
					<td class="inquire_item8" id="sumpro4">累计物理点：</td>
					<td class="inquire_form8" id="sumvalue4"><%=map.get("base13n") %></td>
					<%
					}
					%>






				</tr>
				<tr>
					<%
				if(!map.get("base9j").equals("") ) {
					%>
					<td class="inquire_item8" id="sumpro5">累计返工点：</td>
					<td class="inquire_form8" id="sumvalue5"><%=map.get("base9j") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base8h").equals("") ) {
					%>
					<td class="inquire_item8" id="sumpro6">累计一级品：</td>
					<td class="inquire_form8" id="sumvalue6"><%=map.get("base8h") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base7g").equals("") ) {
					%>
					<td class="inquire_item8" id="sumpro7">累计合格品：</td>
					<td class="inquire_form8" id="sumvalue7"><%=map.get("base7g") %></td>
					<%
					}
					%>
					<%
				if(!map.get("base2b").equals("") ) {
					%>
					<td class="inquire_item8" id="sumpro8">累计重力基点：</td>
					<td class="inquire_form8" id="sumvalue8"><%=map.get("base2b") %></td>
					<%
					}
					%>




				</tr>
				<tr>
					<%
				if(!map.get("base1a").equals("") ) {
					%>
					<td class="inquire_item8" id="sumpro9">累计磁力日变站：</td>
					<td class="inquire_form8" id="sumvalue9"><%=map.get("base1a") %></td>
					<%
					}
					%>

					<%
				if(!map.get("base3c").equals("") ) {
					%>
					<td class="inquire_item8" id="sumpro10">累计井旁测深点：</td>
					<td class="inquire_form8" id="sumvalue10"><%=map.get("base3c") %></td>
					<%
					}
					%>

					<%
				if(!map.get("base6f").equals("") ) {
					%>
					<td class="inquire_item8" id="sumpro11">累计废品：</td>
					<td class="inquire_form8" id="sumvalue11"><%=map.get("base6f") %></td>
					<%
					}
					%>

					<%
				if(!map.get("base5e").equals("") ) {
					%>
					<td class="inquire_item8" id="sumpro12">累计空点：</td>
					<td class="inquire_form8" id="sumvalue12"><%=map.get("base5e") %></td>
					<%
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
					<td class="inquire_form8" id="avgvalue"><%=map.get("lvavg") %>%</td>
					<%
					}
					%>


					<%
				if(!map.get("lvavgt").equals("") ) {
					%>
					<td class="inquire_item8" id="avgpro1">返工率：</td>
					<td class="inquire_form8" id="avgvalue1"><%=map.get("lvavgt") %>%</td>
					<%
					}
					%>
					<%
				if(!map.get("lvavge").equals("") ) {
					%>
					<td class="inquire_item8" id="avgpro2">合格品率：</td>
					<td class="inquire_form8" id="avgvalue2"><%=map.get("lvavge") %>%
					</td>
					<%
					}
					%>

					<%
				if(!map.get("base0").equals("") ) {
					%>
					<td class="inquire_item8" id="avgpro3">一级品率：</td>
					<td class="inquire_form8" id="avgvalue3"><%=map.get("base0") %>%</td>
					<%
					}
					%>




				</tr>
				<tr>

					<%
				if(!map.get("lvavgv").equals("") ) {
					%>
					<td class="inquire_item8" id="avgpro4">废品率：</td>
					<td class="inquire_form8" id="avgvalue4"><%=map.get("lvavgv") %>%</td>
					<%
					}
					%>

					<%
				if(!map.get("lvavgw").equals("") ) {
					%>
					<td class="inquire_item8" id="avgpro5">空点率：</td>
					<td class="inquire_form8" id="avgvalue5"><%=map.get("lvavgw") %>%</td>
					<%
					}
					%>
				</tr>
				<tr>
					<td class="inquire_item8">勘探方法图：</td>
					<td class="inquire_form8"><div id="<%=map.get("explorationMethod") %>Image" style="color: red"></div></td>
				</tr>
			</table>


			<%
             }
			}
				 
		%>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr style="background-color: #97cbfd">
						<td class="inquire_item8">日问题信息：</td>
						<td colspan="7">&nbsp;</td>
					</tr>
				</table>
				<iframe width="100%" height="100%" name="dailyQuestion" id="dailyQuestion" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: auto;"></iframe>
		
		</div>
	</div>
</body>

<%

List<Map> listUcm = (List) wtsrv.getDaiyMethodUcm(projectInfoNo, produce_date);
if(listUcm!=null&&listUcm.size()>0){
	for(int j=0;j<listUcm.size();j++){
		Map ucmMap = listUcm.get(j);
		String expMethod = (String)ucmMap.get("expMethod");
		String ucmId = (String)ucmMap.get("ucmId");
		String imageName = (String)ucmMap.get("imageName");
		String imagePath = (String)ucmMap.get("imagePath");
%>
		<script type="text/javascript">
		$("#<%=expMethod%>Image").html("<span title=\"查看\" style=\"cursor: pointer;\" onclick=\"viewPicture('<%=imagePath %>')\"><%=imageName %></span> "
			 +"  <input onclick=\"window.location ='<%=contextPath%>/doc/downloadDocByUcmId.srq?docId=<%=ucmId%>';\" type=\"button\" value=\"下载\" />");
	
		
		</script>
<% 
	}
}

%>

<script type="text/javascript">


/*** 提交已录入保存的日报 ***/
function toSubmit(status_p){
	debugger;
	var dailyNos = "";
	var projectInfoNo = '<%=projectInfoNo %>';
 	var produceDate = document.getElementById("produceDate").value;
    var retObj = jcdpCallService("WtDailyReportSrv", "getDailyReportInfo", "projectInfoNo="+projectInfoNo+"&produceDate="+produceDate);
	var audit_status = retObj.build.auditStatus;	//审批状态 
	var dailyNo=retObj.build.dailyNoWt;
	if( audit_status!=""&&audit_status!=null ){
		if( audit_status=="1" || audit_status=="2" ){		/* 审批状态 处于“已提交”和“待审批”的前提下，才能审批 */
			var retObj = jcdpCallService("WtDailyReportSrv", "submitDailyReport", "dailyNo="+dailyNo+"&projectInfoNo="+projectInfoNo+"&produceDate="+produceDate+"&audit_status="+status_p);
			queryData(cruConfig.currentPage);	//提交后刷新数据
		}else{	/* 审批状态 处于“未提交”、“审批通过”和“审批不通过”的前提下，不能审批 */
			var msg="";
			if(audit_status=="0"){
				msg="该日报未提交！";
			}else if(audit_status=="3"){
				msg="该日报审批已通过！";
			}else if(audit_status=="3"){
				msg="该日报已经审批未通过！";
			}
			if(msg!=""){
				alert(msg);
			}
		}
	}
	top.frames[5].refreshData();
	   page_init();
				//提交后刷新数据
			 	/* 审批状态 处于“待审批（已经提交）”、“审批中”和“审批通过”的前提下，不能提交 */
			 
			 
			 
 
    }
 
//if(ucmList!=null&&ucmList.size()>0){
//	alert(ucmList.size());
//}
function refreshData() {
	debugger;
		//var ctt = top.frames('list').frames[1];
		//var file_name = document.getElementsByName("file_name")[0].value;
		//ctt.refreshData(undefined, file_name);
		//newClose();
		document.getElementById("form1").submit();
		newClose();
	}

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