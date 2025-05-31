<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.bgp.mcs.service.rm.em.humanRequired.pojo.*"%>
<%@ taglib uri="bgp" prefix="bgp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%
	String contextPath = request.getContextPath();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	List<MsgElement> list = resultMsg.getMsgElements("detailInfo");
	List<BgpProjectHumanRelation> beanList=new ArrayList<BgpProjectHumanRelation>(0);
	if(list!=null){
		 beanList = new ArrayList<BgpProjectHumanRelation>(
				list.size());
		
		for (int i = 0; i < list.size(); i++) {
			beanList.add((BgpProjectHumanRelation) list.get(i).toPojo(
					BgpProjectHumanRelation.class));
		}
	}
	
	BgpProjectHumanRelation relation = new BgpProjectHumanRelation();
	if(beanList != null){
		relation = (BgpProjectHumanRelation)beanList.get(0);
	}

%>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">


<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/js/bgpmcs/DivHiddenOpen.js"></script>

<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>


<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_search.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript">

function viewProjectInfo(projectInfoNo){
	showModalDialog("<%=contextPath%>/common/viewProject.srq?projectInfoNo="+projectInfoNo,'','dialogWidth:900px;dialogHeight:500px;status:yes');
}
</script>
<title>人员项目经历查看</title>
</head>
<body>
<div onclick=""></div>
<form id="CheckForm" name="Form0" action="" method="post" enctype="multipart/form-data">
<table border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%">
	<tr class="even">
		<td class="rtCRUFdName">项目名称：</td>
		<td class="rtCRUFdValue">
		<input type="hidden" id="projectInfoNo" name="projectInfoNo" value="<%= relation.getProjectInfoNo()==null?"":relation.getProjectInfoNo() %>"/>
		<input type="text"  unselectable="on"   readonly="readonly" value="<%= relation.getProjectName()==null?"":relation.getProjectName() %>" maxlength="32" id="projectName" name="projectName" class='input_width'></input>
		</td>
		<td class="rtCRUFdName">&nbsp;</td>
		<td class="rtCRUFdValue">&nbsp;</td>
	</tr>
</table>
<br>
<table border="0" cellspacing="0" cellpadding="0" class="form_info" width="100%" id="equipmentTableInfo">
	<tr background="blue" class="bt_info">
		<TD class="tableHeader" width="6%">姓名</TD>
		<TD class="tableHeader" width="6%">班组</TD>
		<TD class="tableHeader" width="6%">岗位</TD>

		<TD class="tableHeader" width="14%">预计进入项目时间</TD>
		<TD class="tableHeader" width="14%">预计离开项目时间 </TD>
		<TD class="tableHeader" width="14%">实际进入项目时间</TD>
		<TD class="tableHeader" width="10%">实际离开项目时间 </TD>
		<TD class="tableHeader" width="20%">人员评价 </TD>
	</tr>

	<tr class="odd" id="fy0trflag">

		<td><%=relation.getEmployeeName()==null?"":relation.getEmployeeName()%>&nbsp;</td>
		<td><%=relation.getTeamName()==null?"":relation.getTeamName()%>&nbsp;</td>
		<td><%=relation.getWorkPostName()==null?"":relation.getWorkPostName()%>&nbsp;</td>
		<td><%=relation.getPlanStartDate()==null?"":relation.getPlanStartDate()%>&nbsp;</td>
		<td><%=relation.getPlanEndDate()==null?"":relation.getPlanEndDate()%>&nbsp;</td>
		<td><%=relation.getActualStartDate()==null?"":relation.getActualStartDate()%>&nbsp;</td>
		<td><%=relation.getActualEndDate()==null?"":relation.getActualEndDate()%>&nbsp;</td>
		<td><%=relation.getProjectEvaluate()==null?"":relation.getProjectEvaluate()%>&nbsp;</td>
		
	</tr>

</table>
<br>
<table id="buttonTable" border="0" cellpadding="0" cellspacing="0" class="form_info">
	<tr align="right">
		<td><input name="Submit" type="button" class="iButton2" onClick="window.history.back();" value="返回" /></td>
	</tr>
</table>
</form>
</body>
</html>