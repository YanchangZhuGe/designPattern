<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%> 
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%> 
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="java.util.*"%>  
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%> 

<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo=user.getProjectInfoNo();
	String orgSubjectionId=user.getSubOrgIDofAffordOrg();
	projectInfoNo=projectInfoNo==null?"":projectInfoNo;
	String reportId = "234"; 
	String reportFileName = "human_works.raq"; 
	String title = "一线用工上岗情况报表"; 
	SimpleDateFormat format =new SimpleDateFormat("yyyy-MM-dd"); 
	String curDate = format.format(new Date());  
 
	 String  nianSubDate="";
	  String [] aa = curDate.split("-");    
	  for (int i = 0; i < aa.length; i++) {   
		  nianSubDate  =nianSubDate+aa[i];
		  } 
	  
	String end_date = request.getParameter("end_date");
	String start_date = request.getParameter("start_date");
	String org_sub_id = request.getParameter("org_sub_id");
	
	String curDateSpt = request.getParameter("year_date"); 
	if(curDateSpt==null || curDateSpt.trim().equals("")){ 
		  curDateSpt = curDate.substring(0,4);  
		  
		  String [] endDateSb = curDate.split("-");    
		  for (int i = 0; i < endDateSb.length; i++) {   
			  end_date  =end_date+endDateSb[i];
			  } 
		  
		  end_date=end_date.substring(4);
		  start_date = curDate.substring(0,4)+"0101";
		  org_sub_id = orgSubjectionId;
	}

	String rptParams = request.getParameter("rptParams");
	if(rptParams==null ){
		  rptParams ="year_date="+curDateSpt+";end_date="+end_date+";start_date="+start_date+";org_sub_id="+org_sub_id;
	}

	%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css">
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript">
  
function simpleSearch(){
	var ifBuild = document.getElementById("ifBuild").value;
	var nian="<%=curDate%>"; 
	var	nianSb= nian.substring(0,4);  
	
	var nianSubDates="<%=nianSubDate%>";
    var start_date="";
    var end_date="";
 
		if(ifBuild!=''&&ifBuild!=null){ 
			if(ifBuild == nianSb){
				  start_date = nianSb+"0101";
				  end_Date = nianSubDates;
				
			}else{ 
				  start_date = ifBuild+"0101";
				  end_Date = ifBuild+"1231";
			}
 
		 window.location.href='<%=contextPath%>/rm/em/humanChart/aWorksReport.jsp?reportFileName=human_works.raq&year_date='+ifBuild+'&end_date='+end_Date+'&start_date='+start_date+'&org_sub_id=<%=orgSubjectionId%>';
 		}else{
			alert('请选择年份!');
		}
	
	}
function getOrgSubjection(){
	var selectObj = document.getElementById("org_name"); 
	document.getElementById("org_name").innerHTML="";
	selectObj.add(new Option('东方物探',"C105"),0);
	var applyTeamList=jcdpCallService("MatItemSrv","queryOrgSubjection","");	
	for(var i=0;i<applyTeamList.detailInfo.length;i++){
		var templateMap = applyTeamList.detailInfo[i];
		selectObj.add(new Option(templateMap.lable,templateMap.value),i+1);
	}
	getProgectName();
}
function getProgectName(){
	var orgSubjectionId = document.getElementById("org_name").value;
	var selectObj = document.getElementById("progect_name"); 
	document.getElementById("progect_name").innerHTML="";
	selectObj.add(new Option('请选择',"%"),0);
	var applyTeamList=jcdpCallService("MatItemSrv","queryProgectName","orgSubjectionId="+orgSubjectionId);	
	for(var i=0;i<applyTeamList.detailInfo.length;i++){
		var templateMap = applyTeamList.detailInfo[i];
		selectObj.add(new Option(templateMap.lable,templateMap.value),i+1);
	}
}
function showTable(){ 
	var dateYear='<%=curDate%>';
	var datePSr = dateYear.substring(0,7);
	document.getElementById("bireport").src="<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=<%=reportId%>&noLogin=admin&tokenId=admin&KeyId=<%=projectInfoNo%>&yearS="+datePSr;
	
}

function clearQueryText(){
	document.getElementById("ifBuild").value = "";
}
</script>
  </head>
  <body >
	<div id="list_table">
        <div id="inq_tool_box">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" id="FilterLayer">
		<tr>
			<td width="6"><img src="<%=contextPath%>/images/list_13.png"
				width="6" height="36" /></td>
			<td background="<%=contextPath%>/images/list_15.png">
			<div id='divNone' style='display:none;'>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="ali_cdn_name">组织机构：</td>
			 	    <td class="ali_cdn_input"><select class="select_width" id="org_name" name="org_name" onchange="getProgectName()"></select></td>
			 	    <td class="ali_cdn_name">项目名称：</td>
			 	    <td class="ali_cdn_input"><select class="select_width" id="progect_name" name="progect_name" ></select></td>
			 	    <auth:ListButton functionId="" css="cx" event="onclick='simpleSearch()'" title="JCDP_btn_query"></auth:ListButton>
					<td>&nbsp;</td>
				</tr>
			</table>
			</div>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="ali_cdn_name">年份：</td>
		 	    <td class="ali_cdn_input">
		 	   <input id="ifBuild" name="ifBuild" class="input_width"  style="width:120px" type="text"  /> 
		 	  <input id="s" name="s" class="input_width"  style="width:120px" type="hidden"  /> 
			 	 <img src="<%=contextPath%>/images/calendar.gif" id="tributton0" width="16" height="16"  style="cursor:hand;" onmouseover="calMonthSelector(ifBuild,tributton0);"/> 
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
<div id="table_box"  style="height:510px;"> 
<table id=rpt border="0" cellpadding="0" cellspacing="0" class="ali6">
	<tr>
		<td>
			<!-- width="-1" height="-1" needScroll="no" scrollWidth="100%" scrollHeight="100%" scrollBorder="border:1px solid red" needSaveAsExcel="yes" excelPageStyle="1"-->
			<report:html name="report1"
			reportFileName="<%=reportFileName %>"
			params="<%=rptParams%>"
			width="-1" 
			height="-1"
			needScroll="no"
			needSaveAsExcel="yes"
			saveAsName="<%=title%>" excelPageStyle="0"/>
		</td>
	</tr>
</table>
</div>
</div>
 </body>
 <script type="text/javascript">
$("#bireport").css("height",$(window).height()-$("#inq_tool_box").height()-8);

function calMonthSelector(inputField,tributton)
{    
    Calendar.setup({
        inputField     :    inputField,   // id of the input field
        ifFormat       :    "%Y",       // format of the input field
        align          :    "Br",
		button         :    tributton,
        onUpdate       :    null,
        weekNumbers    :    false,
		singleClick    :    false,
		step	       :	1
    });
}
</script>
</html>
