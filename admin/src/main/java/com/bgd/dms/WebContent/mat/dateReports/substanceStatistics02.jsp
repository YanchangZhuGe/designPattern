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

	SimpleDateFormat sdf =new SimpleDateFormat("yyyy-MM-dd 12:00:00"); 
	
	Calendar c = Calendar.getInstance();
	c.set(Calendar.DAY_OF_WEEK, 1);
	c.add(Calendar.DATE, -3);
	

	
	Calendar c2 = Calendar.getInstance();
	//判断是星期几和时间
	int wek = c2.get(Calendar.DAY_OF_WEEK);
	int hour = c2.get(Calendar.HOUR_OF_DAY);   
//如果是是星期四下午，则增加7天  
	if(wek==Calendar.THURSDAY){
		if(hour>=12){
			c.add(Calendar.DATE, 7);

		}
	}
	if(wek>Calendar.THURSDAY){
			c.add(Calendar.DATE, 7);
	}
	
	String endDate = sdf.format(c.getTime());
	
	int nowWeekNum = c.get(Calendar.WEEK_OF_YEAR);
	nowWeekNum=nowWeekNum-1;
	
	/*
	if(wek==Calendar.THURSDAY){
		if(hour<=12){
			nowWeekNum=nowWeekNum-1;
		}	
	}

	
	c.add(Calendar.DATE, -3);
	if(wek>Calendar.THURSDAY){
			c.add(Calendar.DATE, 7);
	}else if(wek==Calendar.THURSDAY){
		if(hour>12){
			c.add(Calendar.DATE, 7);
		}
	}
	

*/

	
	Calendar curDate = c;
	curDate.add(Calendar.WEEK_OF_MONTH, -1);
	curDate.set(Calendar.DAY_OF_WEEK, 5);
	String startDate = sdf.format(curDate.getTime());
	
	String rptParams ="startDate="+startDate+";endDate="+endDate+";weekNum="+nowWeekNum;

	%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>


</head>

<body >

	<div id="table_box"  style="height:510px;" >
		<table id=rpt border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
			<!-- width="-1" height="-1" needScroll="no" scrollWidth="100%" scrollHeight="100%" scrollBorder="border:1px solid red" needSaveAsExcel="yes" excelPageStyle="1"-->
			<report:html name="report1"
			reportFileName="substance/substanceStatistics02.raq"
			params="<%=rptParams%>"
			width="-1" 
			height="-1"
			needScroll="no"
			needSaveAsExcel="yes"
			saveAsName="物资模块数据统计表" excelPageStyle="0"/>
				</td>
			</tr>
		</table>
	</div>
 </body>

</html>
