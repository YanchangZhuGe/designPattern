<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%
	String pageFlag = request.getParameter("pageFlag");
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	String appDate = df.format(new Date());
	int sys_year  = Integer.parseInt(appDate.substring(0,4));
	String sysyear = sys_year+"-01-01";
	String perSql = "";
	String useSql = "";
	String startDate = "";
	String endDate = "";
	
	if(pageFlag !=null && "1".equals(pageFlag)){
		
		perSql = request.getParameter("perSql");
		if(perSql==null)perSql="";
		
		useSql = request.getParameter("useSql");
		if(useSql==null)useSql="";
		
		startDate = request.getParameter("startDate");
		if(startDate==null)startDate="";
		
		endDate = request.getParameter("endDate");
		if(endDate==null)endDate="";
	}else{
		ISrvMsg msg = JcdpMVCUtil.getResponseMsg(request);
		
		perSql = msg.getValue("perSql");
		if(perSql==null)perSql="";
		
		useSql = msg.getValue("perSql");
		if(useSql==null)useSql="";
		
		startDate = sysyear;
		if(startDate==null)startDate="";
		
		endDate = appDate;
		if(endDate==null)endDate="";
	}
	String contextPath = request.getContextPath();
	
	String reportFile = "/dms/assess/devOrgAssess.raq";
	String reportName="物探处考核结果报表";
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<%@include file="/common/include/quotesresource.jsp"%>
	<title>考核结果</title>
</head>
<body style="overflow-x: scroll;overflow-y: scroll;" >
<div id="list_table">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="FilterLayer">
			<tr>
				<td width="6"><img src="<%=contextPath%>/images/list_13.png"
					width="6" height="36" /></td>
				<td background="<%=contextPath%>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td style="width:4%;" >图例：</td>
					<td style="width:18%;">
						<div>
							<span style="background:red;">&nbsp;&nbsp;<font color="white">超出上限</font>&nbsp;&nbsp;</span>
							<span style="background:yellow;">&nbsp;&nbsp;<font color="black">低于下限</font>&nbsp;&nbsp;</span>
							<span style="background:green;">&nbsp;&nbsp;<font color="white">正常区间</font>&nbsp;&nbsp;</span>
						</div>
					</td>
					<td class="ali_cdn_name">开始日期：</td>
			 	    <td class="ali_cdn_input">
			 	    	<input type="text" id="startDate" name="startDate" class="input_width easyui-datebox" value="<%=startDate %>" data-options="prompt:'请选择开始日期',onSelect:onSelect" style="width:120px" editable="false" required/>
			 	    </td>
			 	    <td class="ali_cdn_name">结束时间：</td>
			 	    <td class="ali_cdn_input">
			 	    	<input type="text" id="endDate" name="endDate" class="input_width easyui-datebox" value="<%=endDate %>" data-options="prompt:'请选择结束日期',validType:'equaldDate[\'#startDate\']'" style="width:120px" editable="false" required/>
			 	    </td> 
					<td class="ali_query">
					   <span class="cx"><a href="####" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
				    </td>
				    <td class="ali_query">
					    <span class="qc"><a href="####" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
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
    StringBuffer str = new StringBuffer();
    str.append("perSql=").append(perSql).append(";useSql=").append(useSql).append(";startDate=").append(startDate);
    str.append(";endDate=").append(endDate).append(";reportName=").append(reportName); 
    %>
    <div>
	<table align="center"  id="90" >
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
	function frameSize(){
		$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height());
	}
	function onSelect(date){  //开始日期选择时触发  
	    $('#endDate').datebox('enable');    //启用结束日期控件  
	    $('#endDate').datebox('reset');      //重置结束日期的值  
	};
	$(function(){
		frameSize();
		$(window).resize(function(){
	  		frameSize();
		});
		$.extend($.fn.validatebox.defaults.rules, {  
		    equaldDate: {
		            validator: function(value, param){
		                var d1 = $(param[0]).datetimebox('getValue');  //获取开始时间
		                if(value < d1){
		                	$.messager.alert("提示","结束时间应大于开始时间","warning");
		                	$("#endDate").datebox("setValue","");
		                }else{
		                	return value >=d1;  //有效范围为大于开始时间的日期  
		                }
		            },  
		        message: '结束时间应大于开始时间!'  
		    }  
		 });
	});
	function dataSelector(inputField,tributton){
		Calendar.setup({
	        inputField     :    inputField,   // id of the input field
	        ifFormat       :    "%Y-%m-%d",       // format of the input field
	        align          :    "Br",
			button         :    tributton,
	        onUpdate       :    null,
	        weekNumbers    :    false,
			singleClick    :    true,
			step	       :	1
	    });
	}
	// 简单查询
	function simpleSearch(){
		var pageFlag = '1';
		var startDate = $("#startDate").datebox("getValue");
		var endDate = $("#endDate").datebox("getValue");
		if(startDate==""){
			$.messager.alert("提示","请选择开始时间!","warning");
			return;
		}
		if(endDate==""){
			$.messager.alert("提示","请选择结束时间!","warning");
			return;
		}		
		if(endDate<startDate){
			alert("开始时间不能大于结束时间!");
			return;
		}
		
		var retObj = jcdpCallService("DeviceAssessInfoSrv", "getAssessSqlInfo", "pageFlag="+pageFlag);
		var perSql = retObj.perSql;
		var useSql = retObj.useSql;
		if(retObj != null&&retObj!=""){			
			window.location.href="<%=contextPath%>/dmsManager/assessment/assessResult/assessOrgRateReport.jsp?startDate="+startDate+"&endDate="+endDate+"&perSql="+perSql+"&useSql="+useSql+"&pageFlag=1";
		}
	}
	//清空查询条件
    function clearQueryText(){
    	$("#startDate").datebox("setValue","");
		$("#endDate").datebox("setValue","");
    }
</script>
</html>