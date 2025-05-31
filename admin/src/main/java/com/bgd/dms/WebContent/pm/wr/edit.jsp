<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil,com.cnpc.jcdp.webapp.util.JcdpMVCUtil"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
	String contextPath = request.getContextPath();
	String week_date = request.getParameter("week_date");
	String week_end_date = request.getParameter("week_end_date");
	String org_id = request.getParameter("org_id");
	String action = request.getParameter("action");
	String audit = request.getParameter("audit");
	
	
	UserToken user = OMSMVCUtil.getUserToken(request);
	String[][] infos = {
			  {"F_PM_WR_002","落实收入价值工作量","workloadInfo/workloadInfo.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_022","非地震落实收入价值工作量","workloadInfo/noWorkloadInfo.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_023","非采集落实收入价值工作量","workloadInfo/noCqProjectInfo.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_013","项目情况","acqProjectInfo/add_acqProjectInfoModify.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_024","VSP采集项目情况","acqProjectInfo/unAcqProjectInfoModify.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_014","公司重点项目动态","stressProject/add_stressProjectModify.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_015","公司勘探船只动态","sailInfo/add_sailInfoModify.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_016","地震采集项目运行动态","projectDynamic/edit.jsp?projectType=1"},
			  {"F_PM_WR_017","VSP项目运行动态","projectDynamic/edit.jsp?projectType=2"},
			  {"F_PM_WR_008","非地震项目运行动态","projectDynamic/edit.jsp?projectType=3"},
			  {"F_PM_WR_004","处理解释项目运行动态","projectDynamic/edit.jsp?projectType=4"},
			  {"F_PM_WR_006","技术支持情况","holdInfo/edit_holdInfo.jsp?pagerAction=edit2Edit"},
			  {"F_PM_WR_009","主要地震仪器情况（海上和辽河）","instrument/Edit_LiaoAndSea.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_010","主要地震仪器情况","instrument/Edit_other.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_011","国际可控震源情况","focus/Edit_abroad.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_012","国内测量仪器及可控震源情况","focus/Edit.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_020","检波器情况","geophoneInfo/add_geophoneModify.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_007","物资供应动态","materialInfo/materialInfo.jsp?pagerAction=edit2Add"}
	};
%>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
		if("1"=="<%=audit%>"){
			window.location="audit.jsp";
		}else{
			window.location="list.jsp";
		}
	}
</script>
</head>
<body style="overflow-x:no;overflow-y:no">
<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr valign="top">
    <td width="100%">
		<ul id="tags" style="MARGIN-LEFT: 0px; width:100%; white-space:nowrap; overflow:hidden; word-break:keep-all; height:100%; ">
			<%
			int j=0;
			for(int i=0;i<infos.length;i++){
				if(JcdpMVCUtil.hasPermission(infos[i][0], request)){
			%>
			<li url="<%=infos[i][2] %>&week_date=<%=week_date%>&week_end_date=<%=week_end_date%>&org_id=<%=org_id%>&action=<%=action%>"><a href="javascript:getTab(<%=j++%>);"><%=infos[i][1]%></a></li>
			<%
				}
			}
			%>
			<input type="button" value="返回" class="iButton2" onclick="cancel()"/>
		</ul>
		<div id="tagContent">
			<iframe name="tabIframe" src="" frameborder="0" width="100%" height="600px" style="overflow-x:no;overflow-y:auto"></iframe>
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
