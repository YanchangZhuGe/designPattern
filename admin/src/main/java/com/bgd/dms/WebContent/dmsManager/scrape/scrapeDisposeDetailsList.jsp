<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String scrape_detailed_id = request.getParameter("scrape_detailed_id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/adapter/ext/ext-base.js"></script> 
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/js/extjs/resources/css/ext-all.css"/>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/ext-all.js"></script> 
<title>报废汇总表</title>
<style type="text/css">
#new_table_box_bg {
	width:auto;
	border:1px #aebccb solid;
	background:#f1f2f3;
	padding:10px;
	overflow:auto;
}
@media Print { .noprint { DISPLAY: none }}
</style>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" enctype="multipart/form-data" action="">
    <div id="new_table_box_bg">
     	<div align="right" class="noprint">
     	 	<span class='dy'><a href='####' onclick='myprint()'  title='打印'></a></span>
    	</div>
    	<div><p align="center"><font style="FONT-SIZE: 24px">报废处置详情清单</font></p><br/></div>
    	<!-- 1、报废申请信息 -->
        <fieldSet style="margin:2px:padding:2px;"><legend><font style="FONT-SIZE: 20px">报废申请信息</font></legend>
	      <div id='scrape_apply' name='scrape_apply'>
		      <table width="100%" border="0" cellspacing="0" cellpadding="0" >
		        <tr>
		        <td class="inquire_item6">申请单号:</td>
		          <td class="inquire_form6" colspan="3" id='scrape_apply_no'>
 		          </td>
		          <td class="inquire_item6">报废申请人:</td>
		          <td class="inquire_form6" id="scrape_apply_employee_name">
 		          </td>
		        </tr>
		        <tr>
		          <td class="inquire_item6">申请单位:</td>
		          <td class="inquire_form6"  id="scrape_apply_org_name">
 		          </td>
		          <td class="inquire_item6">申请时间:</td>
		          <td class="inquire_form6" id="scrape_apply_date">
 		          </td>
		          <td class="inquire_item6">状态:</td>
		          <td class="inquire_form6" id="scrape_apply_status">
 		          </td>
		        </tr>
		        <tr>
		          <td class="inquire_item6">专家组长:</td>
		          <td class="inquire_form6" id="scrape_apply_emp_employee_name">
 		          </td>
		          <td class="inquire_item6">专家意见:</td>
		          <td class="inquire_form6" id="scrape_apply_emp_employee_opinion">
 		          </td>
		          <td class="inquire_item6">专家组成员:</td>
		          <td class="inquire_form6" id="scrape_apply_emp_bak">
 		          </td>
		        </tr>
		      </table>
			  <fieldSet style="margin-left:5px"><legend>审批流程</legend>
				   <div style="overflow:auto;">
			      	<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" >
				   		<tbody id="processtable1" name="processtable1" >
				   		</tbody>
			      	</table>
			      </div>
		       </fieldSet>
	       </div>
    </fieldSet>
    <!-- 2、报废批复信息 -->
     <fieldSet style="margin:2px:padding:2px;"><legend><font style="FONT-SIZE: 20px">报废审批信息</font></legend>
	    <div id='scrape_report' name='scrape_report'>
	      <table width="100%" border="0" cellspacing="0" cellpadding="0" >
	        <tr>
	        <td class="inquire_item6">批复单号:</td>
	          <td class="inquire_form6" colspan="3" id="scrape_report_no">
 	          </td>
	          <td class="inquire_item6">批复申请人:</td>
	          <td class="inquire_form6" id="scrape_report_employee_name">
 	          </td>
	        </tr>
	        <tr>
	          <td class="inquire_item6">批复单位:</td>
	          <td class="inquire_form6" id="scrape_report_org_name">
 	          </td>
	          <td class="inquire_item6">批复时间:</td>
	          <td class="inquire_form6" id="scrape_report_date">
 	          </td>
	          <td class="inquire_item6">状态:</td>
	          <td class="inquire_form6" id="scrape_report_status">
 	          </td>
	        </tr>
	      </table>
		  <fieldSet style="margin-left:5px"><legend>审批流程</legend>
			   <div style="overflow:auto;">
		      	<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" >
			   		<tbody id="processtable2" name="processtable2" >
			   		</tbody>
		      	</table>
		      </div>
	       </fieldSet>
		</div>
    </fieldSet>
    <!-- 3、报废处置申请信息 -->
    <fieldSet style="margin:2px:padding:2px;"><legend><font style="FONT-SIZE: 20px">报废处置信息</font></legend>
    	<div id='scrape_dispose' name='scrape_dispose'>
	      <table width="100%" border="0" cellspacing="0" cellpadding="0" >
	        <tr>
	        <td class="inquire_item6">处置单号:</td>
	          <td class="inquire_form6" colspan="3" id="scrape_dispose_no">
 	          </td>
	          <td class="inquire_item6">处置申请人:</td>
	          <td class="inquire_form6" id="scrape_dispose_employee_name">
 	          </td>
	        </tr>
	        <tr>
	          <td class="inquire_item6">处置单位:</td>
	          <td class="inquire_form6" id="scrape_dispose_org_name">
 	          </td>
	          <td class="inquire_item6">处置时间:</td>
	          <td class="inquire_form6" id="scrape_dispose_date">
 	          </td>
	          <td class="inquire_item6">状态:</td>
	          <td class="inquire_form6" id="scrape_dispose_status">
 	          </td>
	        </tr>
	      </table>
		  <fieldSet style="margin-left:5px"><legend>审批流程</legend>
			   <div style="overflow:auto;">
		      	<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" >
			   		<tbody id="processtable3" name="processtable3" >
			   		</tbody>
		      	</table>
		      </div>
	       </fieldSet>
		</div>
    </fieldSet>
    </div>
</form>
</body>
<script type="text/javascript">
function refreshData(){
	var baseData;
	//修改的时候的操作
	if('<%=scrape_detailed_id%>'!='null'){
		baseData = jcdpCallService("ScrapeSrvNew", "getScrapeDisposeAllInfo", "scrape_detailed_id="+'<%=scrape_detailed_id%>');
//1报废申请信息
		if(baseData.scrapeAppMap!=null){
			$("#scrape_apply_no").append(baseData.scrapeAppMap.scrape_apply_no);
			$("#scrape_apply_employee_name").append(baseData.scrapeAppMap.employee_name);
			$("#scrape_apply_org_name").append(baseData.scrapeAppMap.org_name);
			$("#scrape_apply_date").append(baseData.scrapeAppMap.apply_date);
			$("#scrape_apply_status").append(baseData.scrapeAppMap.apply_status);
		}else{
			$("#scrape_apply").empty();
			$("#scrape_apply").append("暂无数据");
		}
		//报废申请专家信息
		if(baseData.scrapeAppEmpMap!=null){
			$("#scrape_apply_emp_employee_name").append(baseData.scrapeAppEmpMap.employee_name);
			$("#scrape_apply_emp_employee_opinion").append(baseData.scrapeAppEmpMap.employee_opinion);
			$("#scrape_apply_emp_bak").append(baseData.scrapeAppEmpMap.bak);
		}
		//报废申请审批信息
		if(baseData.scrapeAppFlowList!=null){
			var innerhtml = "";
			for (var i = 0; i< baseData.scrapeAppFlowList.length; i++) {
				if(i%2==0){
					innerhtml += "<tr>";
				}
				innerhtml += "<td width='20'><fieldSet style='align:center;padding:10px;margin:10px;width:270px;color:#333;border:#06c dashed 1px;'  ><table>";
				innerhtml += "<tr><td>审批人："+baseData.scrapeAppFlowList[i].examine_user_name+"</td></tr>";
				innerhtml += "<tr><td>审批环节："+baseData.scrapeAppFlowList[i].node_name+"</td></tr>";
				innerhtml += "<tr><td>审批状态："+baseData.scrapeAppFlowList[i].curstate+"</td></tr>";
				innerhtml += "<tr><td>审批日期："+baseData.scrapeAppFlowList[i].examine_end_date+"</td></tr>";
				innerhtml += "</table></fieldSet></td>";
				if(i%2==1){
					innerhtml += "</tr>";
				}
			}
			if(baseData.scrapeAppFlowList.length%2==1){
				innerhtml += "</tr>";
			}
			$("#processtable1").append(innerhtml);
		}else{
			$("#processtable1").append("暂无数据");
		}

//2报废批复信息
		if(baseData.scrapeRepMap!=null){
			$("#scrape_report_no").append(baseData.scrapeRepMap.scrape_report_no);
			$("#scrape_report_employee_name").append(baseData.scrapeRepMap.employee_name);
			$("#scrape_report_org_name").append(baseData.scrapeRepMap.org_name);
			$("#scrape_report_date").append(baseData.scrapeRepMap.report_date);
			$("#scrape_report_status").append(baseData.scrapeRepMap.report_status);
		}else{
			$("#scrape_report").empty();
			$("#scrape_report").append("暂无数据");
		}
		//报废批复审批信息
		if(baseData.scrapeRepFlowList!=null){
			var innerhtml = "";
			for (var i = 0; i< baseData.scrapeRepFlowList.length; i++) {
				if(i%2==0){
					innerhtml += "<tr>";
				}
				innerhtml += "<td width='20'><fieldSet style='align:center;padding:10px;margin:10px;width:270px;color:#333;border:#06c dashed 1px;'  ><table>";
				innerhtml += "<tr><td>审批人："+baseData.scrapeRepFlowList[i].examine_user_name+"</td></tr>";
				innerhtml += "<tr><td>审批环节："+baseData.scrapeRepFlowList[i].node_name+"</td></tr>";
				innerhtml += "<tr><td>审批状态："+baseData.scrapeRepFlowList[i].curstate+"</td></tr>";
				innerhtml += "<tr><td>审批日期："+baseData.scrapeRepFlowList[i].examine_end_date+"</td></tr>";
				innerhtml += "</table></fieldSet></td>";
				if(i%2==1){
					innerhtml += "</tr>";
				}
			}
			if(baseData.scrapeRepFlowList.length%2==1){
				innerhtml += "</tr>";
			}
			$("#processtable2").append(innerhtml);
		}else{
			$("#processtable2").append("暂无数据");
		}
//3报废处置信息
		if(baseData.scrapeDisMap!=null){
			$("#scrape_dispose_no").append(baseData.scrapeDisMap.app_no);
			$("#scrape_dispose_employee_name").append(baseData.scrapeDisMap.employee_name);
			$("#scrape_dispose_org_name").append(baseData.scrapeDisMap.org_name);
			$("#scrape_dispose_date").append(baseData.scrapeDisMap.apply_date);
			$("#scrape_dispose_status").append(baseData.scrapeDisMap.dispose_status);
		}else{
			$("#scrape_dispose").empty();
			$("#scrape_dispose").append("暂无数据");
		}
		//报废批复审批信息
		if(baseData.scrapeDisFlowList!=null){
			var innerhtml = "";
			for (var i = 0; i< baseData.scrapeDisFlowList.length; i++) {
				if(i%2==0){
					innerhtml += "<tr>";
				}
				innerhtml += "<td width='20'><fieldSet style='align:center;padding:10px;margin:10px;width:270px;color:#333;border:#06c dashed 1px;'  ><table>";
				innerhtml += "<tr><td>审批人："+baseData.scrapeDisFlowList[i].examine_user_name+"</td></tr>";
				innerhtml += "<tr><td>审批环节："+baseData.scrapeDisFlowList[i].node_name+"</td></tr>";
				innerhtml += "<tr><td>审批状态："+baseData.scrapeDisFlowList[i].curstate+"</td></tr>";
				innerhtml += "<tr><td>审批日期："+baseData.scrapeDisFlowList[i].examine_end_date+"</td></tr>";
				innerhtml += "</table></fieldSet></td>";
				/* if(i+1<baseData.scrapeRepFlowList.length){
					innerhtml += "<td width='10' style='text-align:center'>===></td>";
				} */
				if(i%2==1){
					innerhtml += "</tr>";
				}
			}
			if(baseData.scrapeDisFlowList.length%2==1){
				innerhtml += "</tr>";
			}
			$("#processtable3").append(innerhtml);
		}else{
			$("#processtable3").append("暂无数据");
		}
		
	}
}
function myprint()
{
	 document.body.innerHTML=document.getElementById('new_table_box_bg').innerHTML;
	 window.print();
	 location.reload();
}
</script>
</html>