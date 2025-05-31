<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="com.cnpc.jcdp.util.AppCrypt" %> 
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory,com.bgp.gms.service.td.srv.TdDocServiceSrv"%> 

<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
 
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" type="text/JavaScript" src="/BGPMCS/js/bgpmcs/DivHiddenOpen.js"></script>
<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="<%=contextPath%>/css/rt_table.css" type="text/css" />
<link rel="stylesheet" href="<%=contextPath%>/css/common.css" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>  
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
 


<title></title>
</head>
<body>

<form id="form1" action="" method="post">

<table border="0"  cellspacing="0"  cellpadding="0"  class="form_info"  width="100%" id="queryRetTable">
	<thead>
	<tr class="bt_info">
		<td class="tableHeader"  >序号</td>
		<td class="tableHeader"  >vsp周期报表</td>
		<td class="tableHeader"  >vdz周期报表</td>
 
	</tr>
	</thead>
	<tbody id ="reportView">
	 
	</tbody>
</table> 
</form>

</body>
<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
var querySqlA = "select rownum ,t.* ,'' spare from (select  distinct week_num ,to_char(one_day,'yyyy-MM-dd')one_day,to_char(sun_day,'yyyy-MM-dd')sun_day ,option_type  from  BGP_JS_WEEK_NUM where option_type='vsp' order by week_num desc )t ";
var queryRetA = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySqlA);		
var datasA = queryRetA.datas;

var querySqlB= "select rownum ,t.* ,'' spare from (select  distinct week_num ,to_char(one_day,'yyyy-MM-dd')one_day,to_char(sun_day,'yyyy-MM-dd')sun_day  ,option_type from  BGP_JS_WEEK_NUM where option_type='vdz' order by week_num desc )t ";
var queryRetB = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySqlB);		
var datasB = queryRetB.datas;

var A=datasA.length;
var B=datasB.length;
 
if(A >=B){
	for (var i = 0; i< queryRetA.datas.length; i++) { 
		var tr = document.getElementById("reportView").insertRow();		
		if(i % 2 == 1){  
      		tr.className = "odd";
		}else{ 
			tr.className = "even";
		}
		
		var td = tr.insertCell(0);
		td.innerHTML = datasA[i].rownum;
	    var strA="one_day="+datasA[i].one_day+"&sun_day="+datasA[i].sun_day;
	    var strB="one_day="+datasB[i].one_day+"&sun_day="+datasB[i].sun_day;
	    
		var td = tr.insertCell(1);
     	//td.innerHTML = datasA[i].one_day+"至"+datasA[i].sun_day;
     	td.innerHTML ="<a href='<%=contextPath%>/td/vspExplain/vspReportPage.jsp?reportId=vsp_js_week.raq&option_type=vsp&"+strA+"'  >"+datasA[i].one_day+"至"+datasA[i].sun_day+"</a>";
		if(i<B){ 
			var td = tr.insertCell(2);
			//td.innerHTML = datasB[i].one_day+"至"+datasB[i].sun_day;
			td.innerHTML ="<a href='<%=contextPath%>/td/vspExplain/vspReportPage.jsp?reportId=vdz_js_week.raq&option_type=vdz&"+strB+"'  >"+datasB[i].one_day+"至"+datasB[i].sun_day+"</a>";
			
		}else{ 
			var td = tr.insertCell(2);
			td.innerHTML = datasA[i].spare;
		}

	}
} 
if(B >A){
	for (var i = 0; i< queryRetB.datas.length; i++) { 
		var tr = document.getElementById("reportView").insertRow();		
		if(i % 2 == 1){  
      		tr.className = "odd";
		}else{ 
			tr.className = "even";
		}
		
		var td = tr.insertCell(0);
		td.innerHTML = datasB[i].rownum;

		if(i<A){  
			var td = tr.insertCell(1);
		//	td.innerHTML = datasA[i].one_day+"至"+datasA[i].sun_day;
		    var strA="one_day="+datasA[i].one_day+"&sun_day="+datasA[i].sun_day;
			td.innerHTML ="<a href='<%=contextPath%>/td/vspExplain/vspReportPage.jsp?reportId=vsp_js_week.raq&option_type=vsp&"+strA+"'  >"+datasA[i].one_day+"至"+datasA[i].sun_day+"</a>";
		}else{ 
			var td = tr.insertCell(1);
			td.innerHTML = datasB[i].spare;
		} 
	    var strB="one_day="+datasB[i].one_day+"&sun_day="+datasB[i].sun_day;
		var td = tr.insertCell(2);
		//td.innerHTML = datasB[i].one_day+"至"+datasB[i].sun_day;
		td.innerHTML ="<a href='<%=contextPath%>/td/vspExplain/vspReportPage.jsp?reportId=vdz_js_week.raq&option_type=vdz&"+strB+"'  >"+datasB[i].one_day+"至"+datasB[i].sun_day+"</a>";
	}
} 

</script>
</html>