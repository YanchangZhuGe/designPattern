<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String orgstrId = user.getOrgId();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<title>无标题文档</title>
</head>
<body style="background: #fff; overflow-y: auto"  onload="getFusionChart()">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#" onclick="alertTable()">主要设备使用情况统计</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left"  id="chartContainer1" style="height: 250px;">
			 
						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">主要设备技术状况统计</a>
						<div class="tongyong_box_content_left" id="chartContainer2" style="height: 250px;">

						</div>
						</div>
						</td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">主要设备动态统计表</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left"  id="chartContainer3" style="height: 250px;">
			 
						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">各队伍主要设备投入统计</a>
							<span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left" id="chartContainer4" style="height: 250px;">

						</div>
						</div>
						</td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	<td width="1%"></td>
	</tr>
</table>
</div>
</body>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="js/swfobject.js"></script>
<script type="text/javascript">

 function getFusionChart(){

	var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Doughnut2D.swf", "myChartId2", "100%", "250", "0", "0" );    
	myChart1.setXMLUrl("<%=contextPath%>/rm/dm/tree/getDevUseStatusData.srq?orgId=<%=orgId%>");
	myChart1.render("chartContainer1");  
	
	var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Doughnut2D.swf", "myChartId2", "100%", "250", "0", "0" );    
	myChart2.setXMLUrl("<%=contextPath%>/rm/dm/tree/getDevTechStatusData.srq?orgId=<%=orgId%>");
	myChart2.render("chartContainer2");
	
	var swfVersionStr = "10.0.0";
    <!-- To use express install, set to playerProductInstall.swf, otherwise the empty string. -->
    var xiSwfUrlStr = "charts/playerProductInstall.swf";
    var params = {};
    params.quality = "high";
    params.bgcolor = "#ffffff";
    params.allowscriptaccess = "sameDomain";
    params.allowfullscreen = "true";
    params.wmode = "transparent";
	<!-- JavaScript enabled so display the flashContent div in case it is not replaced with a swf object. -->
     //加载columnChart    
    var attributes = {};
    attributes.id = "columnChart";
    attributes.name = "columnChart";
    attributes.align = "middle";
    flashvars = {};
	swfobject.embedSWF(
        "charts/deviceStat.swf", "chartContainer3", 
        "100%", "250", 
        swfVersionStr, xiSwfUrlStr, 
        flashvars, params, attributes);
   cruConfig.contextPath="<%=contextPath%>";
   	
	var myChart4 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId4", "100%", "250", "0", "0" );    
	myChart4.setXMLUrl("<%=contextPath%>/rm/dm/tree/getWutanTeamProDevInfos.srq?orgstrId=<%=orgstrId%>");
	myChart4.render("chartContainer4");
}
 
	function getRootData(){
	   var userid = '<%=orgId%>';
	   var str = "<chart>";
	   //推土机
	    var retObj = jcdpCallService("DevCommInfoSrv", "getDevRootStatData", "userid="+userid+"&code=070301&seqinfo=0");
    	str += retObj.xmldata;
    	
    	//车装钻机
    	retObj = jcdpCallService("DevCommInfoSrv", "getDevRootStatData", "userid="+userid+"&code=060101&seqinfo=1");
    	str += retObj.xmldata;
    	//人抬化钻机
    	retObj = jcdpCallService("DevCommInfoSrv", "getDevRootStatData", "userid="+userid+"&code=060102&seqinfo=2");
    	str += retObj.xmldata;
    	//运输设备
    	retObj = jcdpCallService("DevCommInfoSrv", "getDevRootStatData", "userid="+userid+"&code=08&seqinfo=3");
    	str += retObj.xmldata;
    	//发电机组
    	retObj = jcdpCallService("DevCommInfoSrv", "getDevRootStatData", "userid="+userid+"&code=0901&seqinfo=4");
    	str += retObj.xmldata;
    	//检波器
    	retObj = jcdpCallService("DevCommInfoSrv", "getDevRootStatData", "userid="+userid+"&code=14050208&seqinfo=5");
    	str += retObj.xmldata;
    	
    	str +="</chart>";
    	
    	return str;
   }      
   function getLeafData(code){
	   var userid = '<%=orgId%>';
	   var str = "";
	   //推土机
	   var retObj = jcdpCallService("DevCommInfoSrv", "getDevLeafStatData", "userid="+userid+"&code="+code);
	   str = retObj.xmldata;
	   return str;
   }
   function getYunShuData(code,len){
	   var userid = '<%=orgId%>';
	   var str = "";
	   //推土机
	   var retObj = jcdpCallService("DevCommInfoSrv", "getYunShuStatData", "userid="+userid+"&code="+code+"&len="+len);
	   str = retObj.xmldata;
	   return str;
   }
   function getTouRuData(){
	   var userid = '<%=orgId%>';
	   var str = "<chart>";
	   //推土机
	   var retObj = jcdpCallService("DevCommInfoSrv", "getTouRuData", "userid="+userid);
	   str += retObj.xmldata;
	   str +="</chart>";
	   return str;
   }
   
 //弹出表格
   function alertTable(obj){
   	   
   	popWindow('<%=contextPath %>/rm/dm/panel/poptableOfGongsi.jsp','1024:768');
   }
</script>  
<script type="text/javascript">
	/**/function frameSize() {

		var width = $(window).width() - 256;
		$("#tongyong_box_content_left_1").css("width", width);

	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	})
</script>
</html>

