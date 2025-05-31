<%@page import="com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider"%>
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
	String reportFileName = request.getParameter("reportId").toString();
	String title = reportFileName; 
	SimpleDateFormat format =new SimpleDateFormat("yyyy-MM-dd"); 
	String curDate = format.format(new Date());  
	
	String curDateSpt = request.getParameter("kq_date"); 
	if(curDateSpt==null || curDateSpt.trim().equals("")){ 
		  curDateSpt = curDate.substring(0,7);  
 
	} 
	
	SimpleDateFormat formatA =new SimpleDateFormat("yyyy"); 
	String curDateA = formatA.format(new Date());  
 
	String p_year = request.getParameter("p_year"); 
	if(p_year==null || p_year.trim().equals("")){ 
		p_year = curDateA ; 
	}
	String p_org_sub = request.getParameter("p_org_sub"); 
	if(p_org_sub==null || p_org_sub.trim().equals("")){ 
		p_org_sub = "C105" ; 
	} 
	
	String rptParams = request.getParameter("rptParams");
	if(rptParams==null ){
		if(reportFileName.equals("human_professionals.raq")){ 
			  rptParams ="p_year="+p_year+";p_org_sub="+p_org_sub;
		}else{
			  rptParams ="kq_date="+curDateSpt+";p_info_no="+projectInfoNo;
			
		}

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
 
function simpleSearchZyh(){
	var p_year = document.getElementById("p_year").value;
	var p_org_sub = document.getElementById("p_org_sub").value; 
		if(p_year!=''|| p_org_sub!=''){  
		 window.location.href='<%=contextPath%>/rm/em/humanAttendance/reportOther.jsp?reportId=human_professionals.raq&p_year='+p_year+'&p_org_sub='+p_org_sub;
 		}else{
			alert('请选择查询条件!');
		}
	
	}
	
	
function simpleSearch(){
	var ifBuild = document.getElementById("ifBuild").value;
		if(ifBuild!=''&&ifBuild!=null){ 
		 window.location.href='<%=contextPath%>/rm/em/humanAttendance/reportKq.jsp?reportFileName=human_attendance.raq&kq_date='+ifBuild+'&p_info_no=<%=projectInfoNo%>';

		//document.getElementById("bireport").src="<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=<%=reportId%>&noLogin=admin&tokenId=admin&KeyId=<%=projectInfoNo%>&yearS="+ifBuild;	
		//document.getElementById("s").value="<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=<%=reportId%>&noLogin=admin&tokenId=admin&KeyId=<%=projectInfoNo%>&yearS="+ifBuild;
		}else{
			alert('请选择日期!');
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
	  document.getElementById("p_year").value="";
	  document.getElementById("p_org_sub").value="";
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
			<div id='divNone'  >
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr style='display:none;'>
					<td class="ali_cdn_name">组织机构：</td>
			 	    <td class="ali_cdn_input"><select class="select_width" id="org_name" name="org_name" onchange="getProgectName()"></select></td>
			 	    <td class="ali_cdn_name">项目名称：</td>
			 	    <td class="ali_cdn_input"><select class="select_width" id="progect_name" name="progect_name" ></select></td>
			 	    <auth:ListButton functionId="" css="cx" event="onclick='simpleSearch()'" title="JCDP_btn_query"></auth:ListButton>
					<td>&nbsp;</td>
				</tr>
				<%
				if(reportFileName.equals("human_professionals.raq")){
				
				%>
				 <tr>
				<td class="ali_cdn_name">项目年份：</td>
		 	    <td class="ali_cdn_input">
			 	 <select  id="p_year" name="p_year"    >
			     <option value="" selected >--请选择--</option>
			 	 <option value="2010" >2010</option>
			 	 	 <option value="2011" >2011</option>
			 	 	 	 <option value="2012" >2012</option>
			 	 	 	 	 <option value="2013" >2013</option>
			 	 	 	 	 	 <option value="2014">2014</option>
			 	 	 	 	 	 	 <option value="2015" >2015</option>
			 	 	 	 	 	 	 	 <option value="2016" >2016</option>
			 	 	 	 	 	 	 	 	 <option value="2017" >2017</option>
			 	 	 	 	 	 	 	 	 	 <option value="2018" >2018</option>
			 	 	 	 	 	 	 	 	 	 	 <option value="2019" >2019</option>
			 	 	 	 	 	 	 	 	 	 	 	 <option value="2020" >2020</option>
  
			 	 </select>
		 	    </td> 
					<td class="ali_cdn_name">单位：</td>
			 	    <td class="ali_cdn_input">
				<select  id="p_org_sub" name="p_org_sub"    >
			     <option value="" selected >--请选择--</option>
			 	 <option value="C105001005" >塔里木作业部</option>
			 	 	 <option value="C105063" >辽河作业部</option>
			 	 	 	 <option value="C105007" >大港作业部</option>
			 	 	 	 	 <option value="C105001003" >吐哈作业部</option>
			 	 	 	 	 	 <option value="C105001004">青海作业部</option>
			 	 	 	 	 	 	 <option value="C105005004" >长庆作业部</option>
			 	 	 	 	 	 	 	 <option value="C105005001" >新兴作业部</option>
			 	 	 	 	 	 	 	 	 <option value="C105001002" >新疆作业部</option>
			 	 	 	 	 	 	 	 	 	 <option value="C105005000" >华北作业部</option>
 
  
			 	 </select>
					</td>
					 <auth:ListButton functionId="" css="cx" event="onclick='simpleSearchZyh()'" title="JCDP_btn_query"></auth:ListButton>
					<td>&nbsp;</td>
			</tr>
			
			<% 
			}
			
			%>
			</table>
			</div>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="ali_cdn_name"> </td>
		 	    <td class="ali_cdn_input">
		 	   <input id="ifBuild" name="ifBuild" class="input_width"  style="width:120px" type="hidden"  /> 
		 	  <input id="s" name="s" class="input_width"  style="width:120px" type="hidden"  /> 
			   	    </td> 
				<td class="ali_query">
				    
			    </td>
			    <td class="ali_query">
				 
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
<div id="table_box"  style="height:610px;" >
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
        ifFormat       :    "%Y-%m",       // format of the input field
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
