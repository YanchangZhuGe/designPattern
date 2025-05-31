<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%> 
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>

<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%> 

<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo=user.getProjectInfoNo();
	String orgSubjectionId=user.getSubOrgIDofAffordOrg();
	projectInfoNo=projectInfoNo==null?"":projectInfoNo;
	String reportId = request.getParameter("reportId").toString();
	
	SimpleDateFormat format =new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());	
	
	String orgSubjectionIdP = user.getOrgSubjectionId();
	String orgName = user.getOrgName();
	
	String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = '"+orgSubjectionIdP+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
	System.out.println("sql:"+sql);
	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
	String father_id = "";
	String sub_id = "";
	String father_organ_flag = "";
	String organ_flag = "";
 
	int lengthParam = list.size();
	
	if(list.size()>1){
	 	Map map = (Map)list.get(0); 
	 	father_id = (String)map.get("orgSubId");	  
	 	father_organ_flag = (String)map.get("organFlag");	 
	 	 
 		Map mapOrg = (Map)list.get(1);
	 	sub_id = (String)mapOrg.get("orgSubId");
	 	organ_flag = (String)mapOrg.get("organFlag"); 
	 	
	 	if(father_organ_flag.equals("0")){
	 		orgSubjectionIdP = "C105";
	 		organ_flag = "0"; 
 
	 	}else if(father_organ_flag.equals("1")){   //一个organ_flag都是 1 时,单位 
	  
	 		orgSubjectionIdP=(String)map.get("orgSubId");	 	
	  
	 		if(organ_flag.equals("1")){ //两个organ_flag都是 1 那么是下属单位
	 			orgSubjectionIdP=(String)mapOrg.get("orgSubId"); 
	 		 
	 		}
	 	} 
	 	
	}else{		 
	
		orgSubjectionIdP = "C105";
 		organ_flag = "0";
  
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
			var Dstartdate =ifBuild+'01-01';
			var Denddate=ifBuild+'12-01';
			
		document.getElementById("bireport").src="<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=<%=reportId%>&noLogin=admin&tokenId=admin&KeyId=<%=orgSubjectionIdP%>&yearS="+ifBuild+"&Dstartdate="+Dstartdate+"&Denddate="+Denddate;	
		document.getElementById("s").value="<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=<%=reportId%>&noLogin=admin&tokenId=admin&KeyId=<%=orgSubjectionIdP%>&yearS="+ifBuild+"&Dstartdate="+Dstartdate+"&Denddate="+Denddate;
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
	var datePSr = dateYear.substring(0,4); // alert(datePSr); alert('<%=orgSubjectionIdP%>');
	var Dstartdate =datePSr+'01-01';
	var Denddate=datePSr+'12-01';
	
	document.getElementById("bireport").src="<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=<%=reportId%>&noLogin=admin&tokenId=admin&KeyId=<%=orgSubjectionIdP%>&yearS="+datePSr+"&Dstartdate="+Dstartdate+"&Denddate="+Denddate;
	
}

function clearQueryText(){
	document.getElementById("ifBuild").value = "";
}
</script>
  </head>
  <body onload='showTable()'>
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
<iframe id ="bireport" src="" marginheight="0" marginwidth="0" style="height:100%;width:100%;"></iframe>
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
