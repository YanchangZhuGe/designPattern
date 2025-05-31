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
            //����ͼ�����
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
         	var str = "{\"param\":[{\"label\":\"Ŀǰ��δע��\",\"data\":\"32\"},{\"label\":\"Ŀǰ��ע��\",\"data\":\"68\"}]}";
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
  <span class="header_companyName fl">��ʯ����Ϣ��������</span>
  <div class="clear"></div>
</div>
<div id="nav" class="nav">
  <ul class="navLv1">
    <li><a>��ҳ</a></li>
    <li><a>�ʲ�����</a>
      <ul class="navLv2">
        <li><a href="register.html">ʵ��ע����</a></li>
        <li><a href="anti_virus.html">�����������װ��</a></li>
        <li><a href="hardware.html">�����Ӳ��</a></li>
        <li><a href="software.html">��������</a></li>
      </ul>
    </li>
    <li><a>��ȫ���</a>
      <ul class="navLv2">
        <li><a href="../monitor/virus_monitor.html">ɱ�����ʹ�����</a></li>
        <li><a href="../monitor/virus_base.html">������������</a></li>
        <li><a href="../monitor/rising.html">���Ǽ������</a></li>
        <li><a href="../monitor/trouble_link.html">Υ������</a></li>
        <li><a href="../monitor/trouble_software.html">Υ�����</a></li>
        <li><a href="../monitor/weekness_sysPort.html">ϵͳ������</a></li>
        <li><a href="../monitor/equipment_change.html">�豸�仯</a></li>
        <li><a href="../monitor/IP_bind.html">IP�󶨱仯</a></li>
        <li><a href="../monitor/dataflow.html">�������</a></li>
        <li><a href="../monitor/sensitive_info.html">������Ϣ</a></li>
        <li><a href="../monitor/patch.html">��������</a></li>
        <li><a href="../monitor/strategy.html">�����·�</a></li>
        <li><a href="../monitor/black_list.html">�ڰ�����</a></li>
      </ul>
    </li>
    <li><a>��ȫԤ��</a>
      <ul class="navLv2">
        <li><a href="../warning/virus.html">��������</a></li>
        <li><a href="../warning/dataflow.html">��������</a></li>
        <li><a href="../warning/trouble_link.html">Υ������</a></li>
        <li><a href="../warning/reglist.html">ע�����</a></li>
        <li><a href="../warning/weekness_sysPort.html">ϵͳ������</a></li>
        <li><a href="../warning/user_right.html">�û�Ȩ�ޱ���</a></li>
        <li><a href="../warning/sys_user.html">ϵͳ�û�����</a></li>
      </ul>
    </li>
  </ul>
  <div class="clear"></div>
</div>
<div id="path" class="path">
  <!-- InstanceBeginEditable name="site_path" -->
  �ʲ����� �� ʵ��ע����
  <!-- InstanceEndEditable -->
</div>
<div class="page_ctt">
  <!-- InstanceBeginEditable name="site_page_ctt" -->
  <div class="register_percent wrap fl">
    <div class="wrap_tt">
      �ն��豸���Ź�˾��ǰע����
    </div>
    <div class="wrap_ctt">
      <img id="pieDiv" src="" class="flash" />
    </div>
  </div>
  <div class="register_situation wrap fl">
    <div class="wrap_tt">
      �ն��豸����ע�����
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
