<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String parentCode = request.getParameter("parentCode");
	if(parentCode==null || parentCode.trim().equals("")){
		parentCode = "";
	}
	String ifCountry = request.getParameter("ifCountry");
	if(ifCountry==null || ifCountry.trim().equals("")){
		ifCountry = "";
	}
	String analType = request.getParameter("analType");
	if(analType==null || analType.trim().equals("")){
		analType = "";
	}
	String wutanorg = request.getParameter("wutanorg");
	if(wutanorg==null || wutanorg.trim().equals("")){
		wutanorg = "";
	}
	String account_stat = request.getParameter("account_stat");
	if(account_stat==null || account_stat.trim().equals("")){
		account_stat = "";
	}
	String postion_id= request.getParameter("postion_id");
	if(postion_id==null || postion_id.trim().equals("")){
		postion_id = "";
	}
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
</head>
<body style="overflow-y: no; overflow-x: hidden;" onload="getFusionChart()">
<div ><!-- style="overflow-y: auto; overflow-x: hidden;" -->
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td valign="middle">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<div class="tongyong_box" >
								<div class="tongyong_box_title">
								</div>
								<div class="tongyong_box_content_left" style="height: 500px;">
									<div id="chartContainer1"></div>
								</div>
							</div>
						</td>
					</tr>
				</table>
			</td> 
		</tr>
	</table>
</div>
<script type="text/javascript">
	var iparentCode='<%=parentCode%>';
	var _ifCountry='<%=ifCountry%>';
	var ianalType='<%=analType%>';
	var wutanorg='<%=wutanorg%>';
	var account_stat='<%=account_stat%>';
	var postion_id='<%=postion_id%>';
	//获取图表
	function getFusionChart(){
		var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "chart1", "98%", "480", "0", "0" ); 
		chart1.setXMLUrl("<%=contextPath%>/rm/dm/getDevOrgChartData.srq?parentCode="+iparentCode+"&ifCountry="+_ifCountry+"&analType="+ianalType+"&wutanorg="+wutanorg+"&account_stat="+account_stat+"&postion_id="+postion_id);
		chart1.render("chartContainer1");
	}
	// 弹出闲置信息
	function popIdleList(positionId){
		 
		popWindow("<%=contextPath%>/rm/dm/panel/devIdelList.jsp?parentCode="+iparentCode+"&ifCountry="+_ifCountry+"&analType="+ianalType+"&wutanorg="+wutanorg+"&account_stat="+account_stat+"&postion_id="+positionId,"800:572");
	}
</script>
</body>
</html>