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
			  {"F_PM_WR_002","��ʵ�����ֵ������","workloadInfo/workloadInfo.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_022","�ǵ�����ʵ�����ֵ������","workloadInfo/noWorkloadInfo.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_023","�ǲɼ���ʵ�����ֵ������","workloadInfo/noCqProjectInfo.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_013","��Ŀ���","acqProjectInfo/add_acqProjectInfoModify.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_024","VSP�ɼ���Ŀ���","acqProjectInfo/unAcqProjectInfoModify.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_014","��˾�ص���Ŀ��̬","stressProject/add_stressProjectModify.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_015","��˾��̽��ֻ��̬","sailInfo/add_sailInfoModify.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_016","����ɼ���Ŀ���ж�̬","projectDynamic/edit.jsp?projectType=1"},
			  {"F_PM_WR_017","VSP��Ŀ���ж�̬","projectDynamic/edit.jsp?projectType=2"},
			  {"F_PM_WR_008","�ǵ�����Ŀ���ж�̬","projectDynamic/edit.jsp?projectType=3"},
			  {"F_PM_WR_004","���������Ŀ���ж�̬","projectDynamic/edit.jsp?projectType=4"},
			  {"F_PM_WR_006","����֧�����","holdInfo/edit_holdInfo.jsp?pagerAction=edit2Edit"},
			  {"F_PM_WR_009","��Ҫ����������������Ϻ��ɺӣ�","instrument/Edit_LiaoAndSea.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_010","��Ҫ�����������","instrument/Edit_other.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_011","���ʿɿ���Դ���","focus/Edit_abroad.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_012","���ڲ����������ɿ���Դ���","focus/Edit.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_020","�첨�����","geophoneInfo/add_geophoneModify.jsp?pagerAction=edit2Add"},
			  {"F_PM_WR_007","���ʹ�Ӧ��̬","materialInfo/materialInfo.jsp?pagerAction=edit2Add"}
	};
%>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/styles/table.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/styles/forum.css" />
<link href="<%=contextPath%>/SpryAssets/SpryTabbedPanels.css" rel="stylesheet" type="text/css" />
<script src="<%=contextPath%>/SpryAssets/SpryTabbedPanels.js" type="text/javascript"></script>
<script src="<%=contextPath%>/images/ForumImg/iepng.js" type="text/javascript"></script>
<title>�����ܱ�¼��</title>
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
			<input type="button" value="����" class="iButton2" onclick="cancel()"/>
		</ul>
		<div id="tagContent">
			<iframe name="tabIframe" src="" frameborder="0" width="100%" height="600px" style="overflow-x:no;overflow-y:auto"></iframe>
		</div>
	</td>
  </tr>
</table>
<script type="text/javascript">
	//����ѡ�ҳ��
	getTab(0);
</script>
</body>
</html>
