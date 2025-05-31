<%@ page language="java" pageEncoding="GBK"%>

<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title></title>
<link rel="stylesheet" type="text/css" href="<%= contextPath %>/css/reset.css">
<link rel="stylesheet" type="text/css" href="<%= contextPath %>/css/template.css">
<link rel="stylesheet" type="text/css" href="<%= contextPath %>/css/page_ctt.css">
<script type="text/javascript" src="<%= contextPath %>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%= contextPath %>/js/nav.js"></script>
<script type="text/javascript" src="<%= contextPath %>/js/swfobject.js"></script>
<script type="text/javascript" src=" <%=contextPath%>/js/rt/rt_page.js"></script>
<script type="text/javascript" src=" <%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script> 


<script type="text/javascript">
            cruConfig.contextPath = "<%= request.getContextPath()%>";
            <!-- For version detection, set to min. required Flash Player version, or 0 (or 0.0.0), for no version detection. --> 
            var swfVersionStr = "10.0.0";
            <!-- To use express install, set to playerProductInstall.swf, otherwise the empty string. -->
            var xiSwfUrlStr = "../charts/playerProductInstall.swf";
            var flashvars = {configXml:"../charts/flashStyle/pieChart.xml",getDataMethod:"getPieChartData"};
            var params = {};
            params.quality = "high";
            params.bgcolor = "#ffffff";
            params.allowscriptaccess = "sameDomain";
            params.allowfullscreen = "true";
            params.wmode = "transparent";
            var attributes = {};
            attributes.id = "pieChart";
            attributes.name = "pieChart";
            attributes.align = "middle";
            //设置图形组件
            swfobject.embedSWF(
                "../charts/pieChart.swf", "pieDiv", 
                "100%", "200", 
                swfVersionStr, xiSwfUrlStr, 
                flashvars, params, attributes);
			<!-- JavaScript enabled so display the flashContent div in case it is not replaced with a swf object. -->
		  
		  var flashvars = {configXml:"../charts/flashStyle/pieChart.xml",getDataMethod:"getPieChartData1"};
           swfobject.embedSWF(
                "../charts/pieChart.swf", "lineDiv", 
                "100%", "200", 
                swfVersionStr, xiSwfUrlStr, 
                flashvars, params, attributes);
                
                
         function getPieChartData(){
            var returnObj = jcdpCallService('PieChartDemoSrv','queryPieData','date=2012-7-3');
            var str = JSON.stringify(returnObj.result);
         	return str;
        }
        function getPieChartData1(){
         	var str = "{\"param\":[{\"label\":\"目前尚未注册\",\"data\":\"32\"},{\"label\":\"目前已注册\",\"data\":\"68\"}]}";
         	return str;
        }
       
        </script>
<!-- InstanceBeginEditable name="doctitle" -->
<title>register</title>
<!-- InstanceEndEditable -->
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
</head>

<body class="bg">
<div id="header" class="header">
  <img class="header_logo fl" src="../img/logo.png" />
  <span class="header_companyName fl">中石油信息技术中心</span>
  <div class="clear"></div>
</div>
<div id="nav" class="nav">
  <ul class="navLv1">
    <li><a>首页</a></li>
    <li><a>资产管理</a>
      <ul class="navLv2">
        <li><a href="register.html">实名注册率</a></li>
        <li><a href="anti_virus.html">防病毒软件安装率</a></li>
        <li><a href="hardware.html">计算机硬件</a></li>
        <li><a href="software.html">计算机软件</a></li>
      </ul>
    </li>
    <li><a>安全监察</a>
      <ul class="navLv2">
        <li><a href="../monitor/virus_monitor.html">杀毒软件使用情况</a></li>
        <li><a href="../monitor/virus_base.html">病毒库更新情况</a></li>
        <li><a href="../monitor/rising.html">瑞星监控数据</a></li>
        <li><a href="../monitor/trouble_link.html">违规外联</a></li>
        <li><a href="../monitor/trouble_software.html">违规软件</a></li>
        <li><a href="../monitor/weekness_sysPort.html">系统弱口令</a></li>
        <li><a href="../monitor/equipment_change.html">设备变化</a></li>
        <li><a href="../monitor/IP_bind.html">IP绑定变化</a></li>
        <li><a href="../monitor/dataflow.html">流量监控</a></li>
        <li><a href="../monitor/sensitive_info.html">敏感信息</a></li>
        <li><a href="../monitor/patch.html">补丁发布</a></li>
        <li><a href="../monitor/strategy.html">策略下发</a></li>
        <li><a href="../monitor/black_list.html">黑白名单</a></li>
      </ul>
    </li>
    <li><a>安全预警</a>
      <ul class="navLv2">
        <li><a href="../warning/virus.html">病毒报警</a></li>
        <li><a href="../warning/dataflow.html">流量报警</a></li>
        <li><a href="../warning/trouble_link.html">违规外联</a></li>
        <li><a href="../warning/reglist.html">注册表报警</a></li>
        <li><a href="../warning/weekness_sysPort.html">系统弱口令</a></li>
        <li><a href="../warning/user_right.html">用户权限报警</a></li>
        <li><a href="../warning/sys_user.html">系统用户报警</a></li>
      </ul>
    </li>
  </ul>
  <div class="clear"></div>
</div>
<div id="path" class="path">
  <!-- InstanceBeginEditable name="site_path" -->
  资产管理 》 实名注册率
  <!-- InstanceEndEditable -->
</div>
<div class="page_ctt">
  <!-- InstanceBeginEditable name="site_page_ctt" -->
  <div class="register_percent wrap fl">
    <div class="wrap_tt">
      终端设备集团公司当前注册率
    </div>
    <div class="wrap_ctt">
      <img id="pieDiv" src="" class="flash" />
    </div>
  </div>
  <div class="register_situation wrap fl">
    <div class="wrap_tt">
      终端设备区域注册情况
    </div>
    <div class="wrap_ctt">
      <img id="lineDiv" src="" class="flash" />
    </div>
  </div>
  <div class="clear"></div>
  <!-- InstanceEndEditable -->
</div>
<iframe src="../footer.html" frameborder="0" class="iframe_footer"></iframe>
</body>
<!-- InstanceEnd --></html>
