<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil,com.cnpc.jcdp.webapp.util.JcdpMVCUtil"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
	String contextPath = request.getContextPath();
	String week_date = request.getParameter("week_date");
	String week_end_date = request.getParameter("week_end_date");
	String org_id = request.getParameter("org_id");

	
	UserToken user = OMSMVCUtil.getUserToken(request);
	String[][] infos = {
			  {"","生产经营情况","weekRaoworkReport.jsp"},
			  {"","重点资源动态","weekPPTReport.jsp"},
			  {"","上周问题解决情况","weekworkReport.jsp"},
			  {"","项目运作情况","weekstressReport.jsp"}
	};
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/styles/table.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/styles/forum.css" />
<link href="<%=contextPath%>/SpryAssets/SpryTabbedPanels.css" rel="stylesheet" type="text/css" />
<script src="<%=contextPath%>/SpryAssets/SpryTabbedPanels.js" type="text/javascript"></script>
<script src="<%=contextPath%>/images/ForumImg/iepng.js" type="text/javascript"></script>
<title>生产周报录入</title>
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
	
	function getNextTab(){
		getTab(selectedIndex+1);
	}

	function cancel()
	{
		window.location="<%=contextPath%>/pm/wr/reportIndex.jsp";
	}
</script>
</head>
<body style="overflow-x:no;overflow-y:no">
<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr valign="top" align="left">
    <td width="100%">
		<ul id="tags" style="MARGIN-LEFT: 0px; width:100%; white-space:nowrap; overflow:hidden; word-break:keep-all; height:100%; ">
			<%
			int j=0;
			for(int i=0;i<infos.length;i++){
			%>
			<li url="<%=infos[i][2] %>?week_date=<%=week_date%>&week_end_date=<%=week_end_date%>&org_id=<%=org_id%>"><a href="javascript:getTab(<%=j++%>);"><%=infos[i][1]%></a></li>
			<%
			}
			%>
			<input type="button" value="返回" class="iButton2" onclick="cancel()"/>
		</ul>
		<div id="tagContent" style="align:left">
			<iframe name="tabIframe" src="" frameborder="0" width="100%" height="1500px" scrolling="no" style="overflow-x:no;overflow-y:no;align:left"></iframe>
		</div>
	</td>
  </tr>
</table>
<script type="text/javascript">
	//加载选项卡页面
	getTab(0);
</script>
</body>
</html>
