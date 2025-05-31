<%@page import="java.net.URLDecoder"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Calendar"%>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%
	String contextPath = request.getContextPath();
	String name = request.getParameter("name");
	String queryStr ="";
	if(null != name){
		queryStr = "name="+name;
	}else{
		queryStr = "name="+"%%";
	}
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
	<title>DEMO</title>
</head>
<body style="background:white">
	<%-- <div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			<td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
		      <tr>
		          <td class="ali_cdn_name">&nbsp名称:</td>
		          <td class="ali_cdn_input">
		          	<input name="parameter_name" id="parameter_name" class="input_width" type="text"/>
		          </td>
					 <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
				    </td>
				    <td class="ali_query">
					    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
				    </td>
				    <td>&nbsp;</td>
			 </tr>
	       </table>
	      </td>
				<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
		</tr>
      </table>
     </div> --%>
	<div id="table_box">		
		<table align="center"  id="90" >
			<tr align="center" >
		    	<td align="center" >
			  		<report:html name="report1"
	        			reportFileName="/flowChart/demanFlowChartdev.raq"
	        			params="<%=queryStr%>"
		   				needScroll="yes"
		   				scrollWidth="100%"
		   				scrollHeight="100%"/>
				</td>
	 		</tr>
		</table>
	</div>
</body>
<script type="text/javascript">
	var name="<%=name%>";
	function frameSize(){
		$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height());
	}
	$(function(){
		frameSize();
		$(window).resize(function(){
	  		frameSize();
		});
		if(name !="null"){
			$("#parameter_name").val(name); 
		}
	});
	<%-- //简单查询
	function searchDevData(){
	    var parameter_name = $("#parameter_name").val(); 
	    window.location="<%=contextPath%>/dmsManager/reportform/flowChart.jsp?name="+parameter_name;
	}
	// 清空
	function clearQueryText(){
		document.getElementById("parameter_name").value = "";                   
		refreshData("");
		 window.location="<%=contextPath%>/dmsManager/reportform/flowChart.jsp";
	} --%>
</script>
</html>