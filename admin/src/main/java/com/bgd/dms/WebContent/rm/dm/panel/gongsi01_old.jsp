<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
    <%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath=request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String orgId = user.getSubOrgIDofAffordOrg();
%>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/rm/dm/panel/js/swfobject.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<div id="chart_caa538f67da490f6e0430a15082c90f6" style="width:100%;height:100%"/>
<script type="text/javascript">
	var swfVersionStr = "10.0.0";
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
    attributes.id = "gsi01Chart";
    attributes.name = "gsi01Chart";
    attributes.align = "middle";
    flashvars = {};
	swfobject.embedSWF(
        "<%=contextPath%>/rm/dm/panel/charts/compDevStat2.swf", "chart_caa538f67da490f6e0430a15082c90f6", 
        "100%", "250", 
        swfVersionStr, xiSwfUrlStr, 
        flashvars, params, attributes);
	cruConfig.contextPath="<%=contextPath%>";
	function getRootData(){
		
		   var userid = '<%=orgId%>';
		   var str = "<chart>";
		  
		    var retObj = jcdpCallService("DevCommInfoSrv", "getCompDevStatData", "code=060101");
		   
		    str += retObj.xmldata;
	    	
	    	str +="</chart>";
	    	
	    	return str;
	   }      
	function getLeafData(code){
		   var userid = '<%=orgId%>';
		   var str = "";
		   //
		   var retObj = jcdpCallService("DevCommInfoSrv", "getCompLeafData", "userid="+userid+"&code="+code);
		   str = retObj.xmldata;
		   return str;
	} 
	function getDiZhenData(code,len){
		   var userid = '<%=orgId%>';
		   var str = "";
		   //地震仪器
		   var retObj = jcdpCallService("DevCommInfoSrv", "getDiZhenData", "userid="+userid+"&code="+code);
		   str = retObj.xmldata;
		   return str;
	}
	   //第三级钻取
	function getThirdData(code,owninorgid){
		   var userid = '<%=orgId%>';
		   var str = "";
		   //
		   var retObj = jcdpCallService("DevCommInfoSrv", "getCompThirdData", "userid="+userid+"&code="+code+"&owninorgid="+owninorgid);
		   str = retObj.xmldata;
		   return str;
	} 
	   //地震仪器第三级钻取
	function getDiZhenThirdData(code,usageorgid){
		   var userid = '<%=orgId%>';
		   var str = "";
		   //地震仪器
		   var retObj = jcdpCallService("DevCommInfoSrv", "getDiZhenThirdData", "userid="+userid+"&code="+code+"&usageorgid="+usageorgid);
		   str = retObj.xmldata;
		   return str;
	}     
	   
</script>
		