<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userOrgId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript"
	src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>	
<link
	href="${applicationScope.fusionChartsURL}/Code/assets/ui/css/style.css"
	rel="stylesheet" type="text/css" />
<title>无标题文档</title>
</head>
<body class="bg">
	<div class="page_ctt">
		<!-- InstanceBeginEditable name="site_page_ctt" -->
		<div class="register_percent wrap fl">
			<div class="wrap_tt">设备台账技术状态统计</div>
			<div id="pieDiv" class="wrap_ctt"></div>
		</div>
		<div class="register_situation wrap fl">
			<div class="wrap_tt">设备台账使用状态统计</div>
			<div id="usePieDiv" class="wrap_ctt"></div>
		</div>
		<div class="register_top10 wrap fl">
			<div class="wrap_tt">主要设备动态周报表</div>
			<div id="columnDiv" class="wrap_ctt"></div>
		</div>
		<div class="register_situation wrap fl">
			<div class="wrap_tt">主要设备投入统计</div>
			<div id="devTRDiv" class="wrap_ctt"></div>
		</div>
		<div class="clear"></div>
		<!-- InstanceEndEditable -->
	</div>
</body>
<script type="text/javascript">
		var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie2D.swf", "myChartId1", "350", "210", "0", "0" );    
		myChart1.setXMLUrl("<%=contextPath%>/rm/dm/tree/getDevTechStatusData.srq?orgId=<%=userOrgId%>");      
		myChart1.render("pieDiv");
		
		var myChart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Doughnut2D.swf", "myChartId2", "350", "210", "0", "0" );    
		myChart2.setXMLUrl("<%=contextPath%>/rm/dm/tree/getDevUseStatusData.srq?orgId=<%=userOrgId%>");      
		myChart2.render("usePieDiv");
</script>
<link rel="stylesheet" type="text/css" href="css/reset.css">
	<link rel="stylesheet" type="text/css" href="css/template.css">
		<link rel="stylesheet" type="text/css" href="css/page_ctt.css">

<script type="text/javascript" src="js/swfobject.js"></script>

<script type="text/javascript">
	<!-- For version detection, set to min. required Flash Player version, or 0 (or 0.0.0), for no version detection. --> 
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
            "charts/deviceStat.swf", "columnDiv", 
            "100%", "200", 
            swfVersionStr, xiSwfUrlStr, 
            flashvars, params, attributes);
	   cruConfig.contextPath="<%=contextPath%>";
	   
	   var attributes = {};
       attributes.id = "trChart";
       attributes.name = "trChart";
       attributes.align = "middle";
       flashvars = {};
		      swfobject.embedSWF(
           "charts/deviceTR.swf", "devTRDiv", 
           "100%", "200", 
           swfVersionStr, xiSwfUrlStr, 
           flashvars, params, attributes);
	   cruConfig.contextPath="<%=contextPath%>";
       function getRootData(){
    	   var userid = '<%=userOrgId%>';
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
    	   var userid = '<%=userOrgId%>';
    	   var str = "";
    	   //推土机
    	   var retObj = jcdpCallService("DevCommInfoSrv", "getDevLeafStatData", "userid="+userid+"&code="+code);
    	   str = retObj.xmldata;
    	   return str;
       }
       function getYunShuData(code,len){
    	   var userid = '<%=userOrgId%>';
    	   var str = "";
    	   //推土机
    	   var retObj = jcdpCallService("DevCommInfoSrv", "getYunShuStatData", "userid="+userid+"&code="+code+"&len="+len);
    	   str = retObj.xmldata;
    	   return str;
       }
       function getTouRuData(){
    	   var userid = '<%=userOrgId%>';
    	   var str = "<chart>";
    	   //推土机
    	   var retObj = jcdpCallService("DevCommInfoSrv", "getTouRuData", "userid="+userid);
    	   str += retObj.xmldata;
    	   str +="</chart>";
    	   return str;
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

