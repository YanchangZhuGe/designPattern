<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<title>保养计划提醒</title>
</head>

<body onload = "simpleSearch()" style="overflow-x:hidden;overflow-y:visible;background:#fff">
      	<div id="list_table">
			<div id="inq_tool_box">
				<div id="tab_box_content1" class="tab_box_content">
						<table id="yzMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
					    <tr>   
						<td class="bt_info_odd">序号</td>
						<td class="bt_info_even">自编号</td>
					    <td class="bt_info_odd">设备名称</td>
						<td class="bt_info_odd">下次累计工作小时</td>
						<td class="bt_info_odd">下次保养级别</td>
						<td class="bt_info_even">下次保养时间</td>
					 </tr>	
					<tbody id="assign_body"></tbody>
				</table> 
			</div>
			
		  </div>
		  </div>
</body>
<script type="text/javascript">
       function simpleSearch(){
    		var retObj;
    		var querySql = "select zy.by_nexttime,zy.by_nexthours,zy.byjb,dui.dev_name,dui.self_num from gms_device_zy_by zy  left join gms_device_account_dui dui on dui.dev_acc_id=zy.dev_acc_id  where zy.isnewbymsg='0'  and (zy.by_nexttime < sysdate + 2  or   zy.by_nexthours <=( (select sum(t.work_hour)  from GMS_DEVICE_OPERATION_INFO t  ";
    		querySql+=" where dev_acc_id =zy.dev_acc_id)+(select p.work_hour from gms_device_zy_project p where p.project_info_id='<%=projectInfoNo%>')*2))";
    		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
    		retObj= queryRet.datas;
    		var size = $("#assign_body", "#tab_box_content1").children("tr").size();
    		if (size > 0) {
    			$("#assign_body", "#tab_box_content1").children("tr").remove();
    		}
    		var by_body1 = $("#assign_body", "#tab_box_content1")[0];
    		if (retObj != undefined) {
    			var innerHtml="";
    			for (var i = 0; i < retObj.length; i++) {
    				//innerHtml+="<tr><td>"+(i+1)+"</td><td>"+retObj[i].self_num+"</td><td>"+retObj[i].dev_name+"</td><td>"+retObj[i].by_nexthours+"</td><td>"+retObj[i].byjb+"</td><td>"+retObj[i].by_nexttime+"</td></tr>";
    			var newTr = by_body1.insertRow();	
    			var newTd = newTr.insertCell();
    			newTd.innerText = i+1;
    			var newTd1 = newTr.insertCell();
    			newTd1.innerText = retObj[i].self_num;
    			var newTd2 = newTr.insertCell();
    			newTd2.innerText = retObj[i].dev_name;
    			var newTd3 = newTr.insertCell();
    			newTd3.innerText = retObj[i].by_nexthours;
    			newTr.insertCell().innerText=retObj[i].byjb;
    			newTr.insertCell().innerText=retObj[i].by_nexttime;
    			}
    			//$("#assign_body").append(innerHtml); 
    		}
    	
    		$("#assign_body>tr:odd>td:odd",'#tab_box_content1').addClass("odd_odd");
    		$("#assign_body>tr:odd>td:even",'#tab_box_content1').addClass("odd_even");
    		$("#assign_body>tr:even>td:odd",'#tab_box_content1').addClass("even_odd");
    		$("#assign_body>tr:even>td:even",'#tab_box_content1').addClass("even_even");
    	
       }
   
	 	
</script>

</html>

