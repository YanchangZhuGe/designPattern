<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Calendar"%>
<%@ include file="/common/rptHeader.jsp" %>
<%@taglib prefix="auth" uri="auth"%>
<%
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId=user.getSubOrgIDofAffordOrg();   //user.getOrgSubjectionId();
	String reportDate = request.getParameter("reportDate");
	String pMonth="";
	if(null==reportDate || "".equals(reportDate)){
		Calendar cal = Calendar.getInstance();
		String tyear=Integer.toString(cal.get(Calendar.YEAR));//年份
		int month=cal.get(Calendar.MONTH)+1;//月份
		pMonth=Integer.toString(cal.get(Calendar.MONTH)+1);//月份
		//格式化的月份
		String tmonth=Integer.toString(cal.get(Calendar.MONTH)+1);
		tmonth = month < 10 ? "0" + tmonth : tmonth; 
		reportDate = tyear+'-'+tmonth;
	}else{
		int smonth=Integer.parseInt(reportDate.substring(4));
		pMonth = smonth < 10 ? reportDate.substring(5) : reportDate.substring(4);
	}
	String queryStr = "reportDate="+reportDate+";pMonth="+pMonth;//报表参数
	String exelName= "东方公司设备物资降本增效五项指标控制目标（"+pMonth+"）";//保存excel名称
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
	<title>设备物资降本增效五项指标报表</title>
	<style type="text/css">
		.jbzx_button {
			margin:0,0,0,0;
			border:1px #52a5c4 solid;
			width:80px;
			height:25px;
			color: #333333;
			background-color:#DEF0FC;
			font-family: "微软雅黑";
			font-size:11pt;
		}
	</style>
</head>
<body style="background:white">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath%>/images/list_15.png">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>
								<div>
									<input type="button" value="资产折旧" class="jbzx_button" onclick="popTotalJbzkAnal('1')"/>
									<input type="button" value="采购价格" class="jbzx_button" onclick="popTotalJbzkAnal('2')"/>
									<input type="button" value="库存" class="jbzx_button"  onclick="popTotalJbzkAnal('3')"/>
									<input type="button" value="检波器电缆摊销折旧" class="jbzx_button" style="width:150px;" onclick="popTotalJbzkAnal('4')"/>
									<input type="button" value="设备维修" class="jbzx_button" onclick="popTotalJbzkAnal('5')"/>
								</div>
							</td>
							<td class="inquire_item6">上报日期：</td>
			  				<td class="inquire_form6">
						   		<input id="report_date" name="report_date" type="text" class="input_width"  style="width:120px;" readonly="readonly" />
				   				<img width="20px" height="20px" id="cal_button" style="cursor: hand;" onmouseover="ymSelector('report_date','cal_button');" src="<%=contextPath%>/images/calendar.gif" />
						  	</td>
						  	<td class="ali_query">
			   					<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
							</td>
							<td>&nbsp;</td>
				  		</tr>
					</table>
				</td>
			   	<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			</tr>
		</table>
	</div>
	<div id="table_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="table_box_export">
			<tr>
				<td align="right">     
					<a href="#" onClick="report1_saveAsExcel();return false;"><%=excelImage%></a>
			    </td>
		  	</tr>
		</table>		
		<table align="center"  id="90" width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr align="center" >
		    	<td align="center" >
			  		<report:html name="report1"
	        			reportFileName="/dms/assess/jbzx_report2.raq"
	        			params="<%=queryStr%>"
		   				needScroll="yes"
		   				saveAsName="<%=exelName%>"
		   				scrollWidth="100%"
		   				scrollHeight="100%"/>
				</td>
	 		</tr>
		</table>
	</div>
</body>
<script type="text/javascript">
	var reportDate="<%=reportDate%>";
	function frameSize(){
		$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box_export").height());
	}
	$(function(){
		frameSize();
		$(window).resize(function(){
	  		frameSize();
		});
		$("#report_date").val(reportDate);
	});
	//选择年月
	function ymSelector(inputField,tributton){    
	    Calendar.setup({
	        inputField     :    inputField,   // id of the input field
	        ifFormat       :    "%Y-%m",       // format of the input field
	        align          :    "Br",
			button         :    tributton,
	        onUpdate       :    null,
	        weekNumbers    :    false,
			singleClick    :    true,
			step	       :	1
	    });
	}
	//简单查询
	function simpleSearch(){
		var r_reportDate = $("#report_date").val();
		var r_month=r_reportDate.substr(5);
		r_month= r_month < 10 ? r_reportDate.substr(6) : r_reportDate.substr(5); 
	    window.location="<%=contextPath%>/dmsManager/assessment/jbzx/jbzx_report.jsp?reportDate="+r_reportDate+"&pMonth"+r_month;
	}
	//指标分析
	function popTotalJbzkAnal(item_name){
		var aOrgSubId="<%=orgSubId%>";
		popWindow('<%=contextPath%>/dmsManager/assessment/jbzx/jbzx_t_anal.jsp?item_name='+item_name+'&org_sub_id='+aOrgSubId,'900:640');		
	}
</script>
</html>