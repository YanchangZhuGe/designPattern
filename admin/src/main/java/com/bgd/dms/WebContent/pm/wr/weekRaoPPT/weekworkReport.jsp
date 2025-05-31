<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date" %>
<%@ taglib uri="/WEB-INF/runqianReport.tld" prefix="report"%>
<html>
<%

UserToken user = OMSMVCUtil.getUserToken(request);
String org_subjection_id = user.getOrgSubjectionId();
String contextPath = request.getContextPath();

String rptParams= "";

String week_date = request.getParameter("week_date");
String week_end_date = request.getParameter("week_end_date");
rptParams = "startDate="+week_date+";"+"endDate="+week_end_date+";";

String[][] infos = {
		//  {"各单位项目问题的解决情况",""},
		  {"生产系统登陆统计表","/pm/wr/weekRaoPPT/weekPPTRunqianReport.jsp?reportFileName=wr/loginNumReport.raq&reportName=生产系统登陆统计表&rptParams="+rptParams}
};


%>
<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/js/DivHiddenOpen.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/validator.js"></script>
<link href="<%=contextPath%>/styles/table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/styles/calendar-blue.css"  />
<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/js/report.js"></script>
</head>
<script type="text/javascript">
	var selectedIndex;
	function getTab(index) {  
	    var tags=document.getElementById("tags");
	    var elList, i;
	    elList = tags.getElementsByTagName("li");
	    for (i = 0; i < elList.length; i++){
		   elList[i].className ="";
	    }
	    index = index % elList.length;
	    elList[index].className ="selectTag";
	    document.getElementsByName("tabIframe")[0].src=elList[index].url;
	    selectedIndex=index;
	}
    function div01(){
    	document.getElementById("div01").style.display ="none";
    	document.getElementById("div02").style.display ="block";
    	document.getElementById("divT").style.display ="block";
    }
    function div02(){
    	document.getElementById("div02").style.display ="none";
    	document.getElementById("div01").style.display ="block";
    	document.getElementById("divT").style.display ="none";
    }

</script>
<style type="text/css">
a{TEXT-DECORATION:none}
a:link{TEXT-DECORATION:none;color:#555555;}
a:active{TEXT-DECORATION:blink}
a:hover{TEXT-DECORATION:none;color:#555555;background-image:url(input_cuteTxt_nm1.jpg); width:160px; height:25px;display:block;}
a:visited{TEXT-DECORATION:none;color:#555555;}
</style>
<title></title>
<body style="background-color:#EBEBEB">
<div style="width:175px;height:728px;float: left;display:block;background-color:#C1C1C1" id="divT">
      <ul id="tags" style="MARGIN-TOP: 20px;MARGIN-LEFT: 0px; width:100%; white-space:nowrap; overflow:hidden; word-break:keep-all; list-style-type: none;">
			<%
			int j=0;
			for(int i=0;i<infos.length;i++){
			%>
			<li url="<%=contextPath+infos[i][1] %>&week_date=<%=week_date%>&week_end_date=<%=week_end_date%>&chartname=<%=infos[i][0]%>"  style="height:22px;text-align: left; "><div style="background:url(input_cuteTxt_n.png); width: 160px;height:25px;float: left;margin-top: 2px;table-layout: fixed;word-break: break-all;" name="divs"><p style="MARGIN-TOP: 3px;text-align:center;position:absolute;"><a href="javascript:getTab(<%=j++%>);" style="font-size: 12px;" >&nbsp;<%=infos[i][0]%></a></p></div></li>
			<%
			}
			%>
		</ul>
</div>
<div id="div01" style="width:14px;height:728px;float: left;background:url(hiddenbtn.gif);display:none;"  onclick="div01()"></div>
<div id="div02" style="width:14px;height:728px;float: left;background:url(hiddenbtn_hover.gif);display:block;"  onclick="div02()"></div>
<div id="tagContent" style="float: left">
	<iframe name="tabIframe" src="" frameborder="0" width="1000px" height="728px" scrolling="no" style="overflow-x:no;overflow-y:no;align:left"></iframe>
</div>

<script type="text/javascript">
	//加载选项卡页面
	getTab(0);
</script>

</body>
</html>