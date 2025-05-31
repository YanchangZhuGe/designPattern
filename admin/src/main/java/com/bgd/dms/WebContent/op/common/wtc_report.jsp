<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String title="地震采集项目运营状况分析表";
	String chooseOp =(String)request.getAttribute("chooseOp");
	String reportFileName =(String)request.getParameter("reportFileName");
	String reportName="地震采集项目运营状况分析表";
	String org_subjection_id =(String)request.getParameter("org_subjection_id");
	if(org_subjection_id==null ){
		org_subjection_id = user.getSubOrgIDofAffordOrg();
	}
	String id = user.getSubOrgIDofAffordOrg();

	String start_date =(String)request.getParameter("start_date");
	if(start_date==null || start_date.trim().equals("")){
		start_date = "2010-01-01";
	}
	String end_date =(String)request.getParameter("end_date");
	if(end_date==null || end_date.trim().equals("")){
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		end_date = df.format(new Date());
	}
	org_subjection_id= "C105002";
	String rptParams =(String)request.getParameter("rptParams");
	if(rptParams==null ){
		rptParams = "org_subjection_id="+org_subjection_id+";start_date="+start_date+";end_date="+end_date;
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<title>无标题文档</title>
</head>
<body style="background:#fff" >
<div id="list_table">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath%>/images/list_15.png">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="ali_cdn_name">组织机构隶属</td>
							<td class="ali_cdn_input"><select id="org_subjection_id" name="org_subjection_id" class="select_width">
								</select></td>
							
							<td class="ali_cdn_name">开始日期</td>
							<td class="ali_cdn_input"><input type="text" name="start_date" id="start_date" value="<%=start_date %>" readonly="readonly"  class="input_width"/></td>
						    <td width="50px"><img width="16" height="16" id="cal_button8" style="cursor: hand;" onmouseover="calDateSelector(start_date,cal_button8);" src="<%=contextPath %>/images/calendar.gif" /></td> 
						    
						    <td class="ali_cdn_name">结束日期</td>
							<td class="ali_cdn_input"><input type="text" name="end_date" id="end_date" value="<%=end_date %>" readonly="readonly"  class="input_width"/></td>
						    <td width="50px"><img width="16" height="16" id="cal_button9" style="cursor: hand;" onmouseover="calDateSelector(end_date,cal_button9);" src="<%=contextPath %>/images/calendar.gif" /></td>
							
							<auth:ListButton functionId="" css="cx" event="onclick='refreshData()'" title="JCDP_btn_submit"></auth:ListButton>
							<td>&nbsp;</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box">
		<table id=rpt border="0" cellpadding="0" cellspacing="0" class="ali6">
			<tr>
				<td>
					<!-- width="-1" height="-1" needScroll="no" scrollWidth="100%" scrollHeight="100%" scrollBorder="border:1px solid red" needSaveAsExcel="yes"-->
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
	<div id="fenye_box" style="height: 0px;"></div> 
</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var org_subjection_id = '<%=org_subjection_id%>';
	$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-8);
	//
	var querySql = "select 'C105' org_subjection_id ,'东方公司' org_name from dual union select t.org_subjection_id ,t.org_abbreviation org_name from bgp_comm_org_wtc t ";
	var retObj = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
	if(retObj!=null && retObj.returnCode =='0'){
		var select = document.getElementById("org_subjection_id");
		for(var i=0;i<retObj.datas.length;i++){
			var map = retObj.datas[i];
			with(map){
				select.options.add(new Option(org_name,org_subjection_id));
			}
		}
		var id = '<%=id%>';
		if(id!='C105'){
			select.disabled = 'disabled';
		}
	}	
	var option = document.getElementById("org_subjection_id").options;
	for(var i =0;i<option.length;i++){
		var value = document.getElementById("org_subjection_id").options[i].value;
		if(value=='<%=org_subjection_id%>'){
			document.getElementById("org_subjection_id").options[i].selected = 'selected';
		}
	}
	<%-- var sql = " select to_char(nvl(min(t.design_start_date),sysdate),'yyyy-MM-dd') start_date from gp_task_project t "+
	" join common_busi_wf_middle wf on wf.business_id= t.project_info_no and wf.proc_status ='3' and wf.busi_table_name='gp_task_project' "+ 
	" and wf.business_type='5110000004100000057' join gp_task_project_dynamic d on t.project_info_no = d.project_info_no "+
	" where t.bsflag ='0' and d.bsflag ='0' and t.exploration_method in ('0300100012000000002','0300100012000000003') "+
	" and d.org_subjection_id like '<%=org_subjection_id%>%'  ";
	retObj = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
	if(retObj!=null && retObj.returnCode =='0'){
		var start_date = retObj.datas==null || retObj.datas.length<=0?"1970-01-01":retObj.datas[0].start_date
		//document.getElementById("start_date").value = start_date;
	} --%>
	function refreshData(){
		var org_subjection_id = document.getElementById("org_subjection_id").value;
		var start_date = document.getElementById("start_date").value;
		var end_date = document.getElementById("end_date").value;
		window.location.href='<%=contextPath%>/op/common/wtc_report.jsp?reportFileName=op_wtc_hz001.raq&org_subjection_id='+org_subjection_id+'&start_date='+start_date+'&end_date='+end_date;
	}
</script>
</body>
</html>