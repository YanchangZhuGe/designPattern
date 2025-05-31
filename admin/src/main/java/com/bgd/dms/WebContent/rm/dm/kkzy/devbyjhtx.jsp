<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
String contextPath = request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String userId = user.getSubOrgIDofAffordOrg();
String projectInfoNo = user.getProjectInfoNo();
ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>保养计划预警</title>
</head>

<body style="background: #F1F2F3" onload="refreshData()">
	<div id="list_table">
		<div id="table_box">
			<table width="98%" border="0" cellspacing="0" cellpadding="0"
				class="tab_info" id="queryRetTable">
				<tr >
				        <td class="bt_info_even" autoOrder="1">序号</td>
						<td class="bt_info_odd"  exp="{self_num}" >自编号</td>
					    <td class="bt_info_even"   exp="{dev_name}">设备名称</td>
						<td class="bt_info_odd"  exp="{by_nexthours}">下次累计工作小时</td>
						<td class="bt_info_even"  exp="{byjb}"  >下次保养级别</td>
						<td class="bt_info_odd"  exp="{by_nexttime}" >下次保养时间</td>
				</tr>
			</table>
		</div>
		<div id="fenye_box" style="display: block">
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				id="fenye_box_table">
				<tr>
					<td align="right">第1/1页，共0条记录</td>
					<td width="10">&nbsp;</td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_01.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_02.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_03.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_04.png"
						width="20" height="20" /></td>
					<td width="50">到 <label> <input type="text"
							name="textfield" id="textfield" style="width: 20px;" />
					</label></td>
					<td align="left"><img
						src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				</tr>
			</table>
		</div>
	</div>
	

</body>
<script type="text/javascript">
  cruConfig.contextPath =  "<%=contextPath%>";
  cruConfig.cdtType = 'form';
  cruConfig.queryStr = "";
	
	var project_info_id='<%=projectInfoNo%>';
	function refreshData(){
		var querySql = "select zy.by_nexttime,zy.by_nexthours,zy.byjb,dui.dev_name,dui.self_num from gms_device_zy_by zy  left join gms_device_account_dui dui on dui.dev_acc_id=zy.dev_acc_id  where  dui.project_info_id='"+project_info_id+"'  and  zy.isnewbymsg='0'  and (zy.by_nexttime < sysdate + 2  or   zy.by_nexthours <=( (select sum(t.work_hour)  from GMS_DEVICE_OPERATION_INFO t  ";
		querySql+=" where dev_acc_id =zy.dev_acc_id)+(select p.work_hour from gms_device_zy_project p where p.project_info_id='<%=projectInfoNo%>')*2))";
		cruConfig.queryStr = querySql;
		queryData(cruConfig.currentPage);
		
	}
</script>
</html>