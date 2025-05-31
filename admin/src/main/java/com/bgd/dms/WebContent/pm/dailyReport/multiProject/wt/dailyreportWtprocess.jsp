<%@page import="com.cnpc.jcdp.soa.msg.MsgElementImpl"%>
<%@page import="java.util.List,com.bgp.mcs.service.pm.service.project.DailyReportProcessRatePOJO"  %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.bgp.mcs.service.wt.pm.service.dailyReport.WtDailyReportSrv" %>
<%@ page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();	
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String projectInfoNo=request.getParameter("projectInfoNo");
	if(projectInfoNo==null){
		projectInfoNo=  user.getProjectInfoNo();
	}
 
 %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="<%=contextPath%>/styles/table.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="<%=contextPath%>/styles/extremecomponents.css" type="text/css">
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/styles/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/validator.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<title>日报进度查看</title>
 
</head>

<body>

 
<table border="0" cellpadding="0" cellspacing="0" class="Tab_page_title">
	<tr class="Tab_page_title">
		<td colspan="4" class="Tab_Header">生产进度查看</td>
	</tr>
</table>

<table cellpadding="" cellspacing="" class="tab_info" >

        <%
    	
    	WtDailyReportSrv  wtSrv=new WtDailyReportSrv();
    	List list=wtSrv.processList(projectInfoNo);
    	System.out.print(list.size());
          for(int i=0;i<list.size();i++){
        	  Map map=(Map)list.get(i);
        	 
        	  %>
        
		<tr bgcolor="#daedf0" >
		<%
	  if(!map.get("dailyWorkload").equals("")){
		  %>
 		<td colspan="12" align="center"><%=map.get("codingName") %></td>
 		<%
	  }else{
		  %>
		  <td colspan="9" align="center"><%=map.get("codingName") %></td>
		  <%
	  }
 		%>
	</tr>
	
	<tr bgcolor="#daedf0">
	<%
	  if(!map.get("dailyWorkload").equals("")){
		  %>
	  

	 <td colspan="4" align="center">计划工作量</td>
	 <td colspan="4" align="center">完成工作量 </td>
	 <td colspan="4" align="center">剩余工作量</td>
	 		  <%
	  }else{
		  %>
     <td colspan="3" align="center">计划工作量</td>
	 <td colspan="3" align="center">完成工作量 </td>
	 <td colspan="3" align="center">剩余工作量</td>
		  <%
	  }
	%>
	</tr>
	<tr bgcolor="#daedf0">
	<%
	  if(!map.get("dailyWorkload").equals("")){
		  %>
	  <td align="center">工作量</td>
	  <%
	  }
	  %>
		<td align="center">坐标点</td>
		<td align="center">物理点</td>
		<td align="center">检查点</td>
			<%
	  if(!map.get("dailyWorkload").equals("")){
		  %>
	  <td align="center">工作量</td>
	  <%
	  }
	  %>
    	<td align="center">坐标点</td>
		<td align="center">物理点</td>
		<td align="center">检查点</td>
			<%
	  if(!map.get("dailyWorkload").equals("")){
		  %>
	  <td align="center">工作量</td>
	  <%
	  }
	  %>
		<td align="center">坐标点</td>
		<td align="center">物理点</td>
		<td align="center">检查点</td>
 	 
	<tr bgcolor="#daedf0">
	<%
	  if(!map.get("dailyWorkload").equals("")){
		  %>
		  <td align="center"><%=map.get("lineLength") %></td>
		  <%
	  }
	%>
		<td align="center"><%=map.get("locationPoint") %> </td>
		<td align="center"><%=map.get("physicsPoint") %></td>
		<td align="center"><%=map.get("checkPoint") %></td>
			<%
	  if(!map.get("dailyWorkload").equals("")){
		  %>
		  <td align="center"><%=map.get("smWorkload") %></td>
		  <%
	  }
	%>
    	<td align="center"><%=map.get("smPoin") %></td>
		<td align="center"><%=map.get("smPhysical") %></td>
		<td align="center"><%=map.get("smCheck") %></td>
					<%
	  if(!map.get("dailyWorkload").equals("")){
		  %>
		  <td align="center"><%=map.get("remainWorkload") %></td>
		  <%
	  }
	%>
    	<td align="center"><%=map.get("remainPoint") %></td>
		<td align="center"><%=map.get("remainPhysice") %></td>
		<td align="center"><%=map.get("remainCheck") %></td>
	</tr>
	<tr>
	<td colspan="10" ></td>
		 
	</tr>		
	
		  <%
          }
        %>
</table>
</body>
</html>
