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
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
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
	int year_sys  =Integer.parseInt(curDate.substring(0,4));  
	
	String date_1=(year_sys-3)+1+"-01-01";
	String date_2=curDate;
	String date_3=(year_sys-6)+1+"-01-01";
	String date_4=date_1;
	String date_5=(year_sys-9)+1+"-01-01";
	String date_6=date_3;
	String date_7=date_5;
	
	
	
	String curDateSpt = request.getParameter("kq_date"); 
	if(curDateSpt==null || curDateSpt.trim().equals("")){ 
		  curDateSpt = curDate.substring(0,7);  
 
	}

	 
	
	String orgS_id = (user==null)?"":user.getSubOrgIDofAffordOrg();
	
	  String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0'    start with t.org_sub_id = '"+orgS_id+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
		
		System.out.println("sql ="+sql);	
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		String orgSubIdA = "";
		String orgSubIdB = "";
		String orgSubIdC = "";
		String organ_flagA = "";
		String organ_flagB = "";
		String organ_flagC = "";
		
		if(list.size()>1){
		 	Map mapA = (Map)list.get(0);
		 	Map mapOrgB= (Map)list.get(1); 
			
//		 	if(mapOrgB == null){
//		 		mapOrgB= mapA;	 
//		 	} 
		 	
			orgSubIdA = (String)mapA.get("orgSubId");
			orgSubIdB = (String)mapOrgB.get("orgSubId"); 
			organ_flagA = (String)mapA.get("organFlag");
			organ_flagB = (String)mapOrgB.get("organFlag"); 
			
			if(organ_flagB.equals("")){
				if(organ_flagA.equals("1")){
					orgS_id = orgSubIdA;
				}
			}
			if(organ_flagB.equals("1")){
				orgS_id = orgSubIdB;
			}

			if(list.size()>2){ 
				Map mapOrgC = (Map)list.get(2);
				orgSubIdC = (String)mapOrgC.get("orgSubId");
				organ_flagC = (String)mapOrgC.get("organFlag");
				
				if(organ_flagC.equals("1")){
					orgS_id = orgSubIdC;
				}

				if(organ_flagC.equals("")){
					if(organ_flagB.equals("1")){
						orgS_id = orgSubIdB;
					}
				}
			}
		 
			
		 	if(organ_flagA.equals("0")||user.getOrgSubjectionId().equals("C105")){
		 		orgS_id = "C105";
		 	}
		}
		
		
		String rptParams = request.getParameter("rptParams");
		if(rptParams==null ){
			if(reportFileName.equals("sb_report2.raq")){
				 rptParams ="sub_org_id=C105001;date_1="+date_1+";date_2="+date_2+";date_3="+date_3+";date_4="+date_4+";date_5="+date_5+";date_6="+date_6+";date_7="+date_7;
			}else{
				 rptParams ="sub_org_id=C105001";
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
 
function simpleSearch(){
	var ifBuild = document.getElementById("ifBuild").value;
		if(ifBuild!=''&&ifBuild!=null){ 
		 window.location.href='<%=contextPath%>/rm/em/humanAttendance/reportKq.jsp?reportFileName=human_attendance.raq&kq_date='+ifBuild+'&p_info_no=<%=projectInfoNo%>';

		//document.getElementById("bireport").src="<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=<%=reportId%>&noLogin=admin&tokenId=admin&KeyId=<%=projectInfoNo%>&yearS="+ifBuild;	
		//document.getElementById("s").value="<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=<%=reportId%>&noLogin=admin&tokenId=admin&KeyId=<%=projectInfoNo%>&yearS="+ifBuild;
		}else{
			alert('请选择日期！');
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
