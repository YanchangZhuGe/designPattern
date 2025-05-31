<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="code" prefix="code"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page  import="java.util.*" %>
<%@ page import="java.text.*" %>

<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo")==null?"":request.getParameter("projectInfoNo");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String username = user.getUserName();
	String projectName = user.getProjectName();
	SimpleDateFormat df = new SimpleDateFormat("yyyy年MM月dd日");
	String appDate = df.format(new Date());
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />

<title>无标题文档</title>
</head>
 <body style="text-align:center;font-family: 宋体;">
 <div style="text-align:left;margin:40px auto auto auto ;width:595px;">
 <div style="text-align:center;font-size: 29px;font-weight: bold;"> 动迁申请书 </div>
 <div style="text-align:right;font-size: 16px;font-weight: bold;">BGP&sdot;ZH/Q/JL7.5.1-1</div>

<div style="margin:10px auto auto auto ;font-size: 21px;line-height:30px;">
   <span >生产管理科：</span>
   <span style="display:block;text-indent: 2em;"><span id="teamid" style="text-decoration: underline;"></span>&nbsp;承担了&nbsp;<span id="areaId" style="text-decoration: underline;"></span>&nbsp;地区&nbsp;<span id="projectNameId" style="text-decoration: underline;"></span>&nbsp;勘探任务，经过认真准备，出工前的各项工作均已就绪，现申请队伍动迁，奔赴探区，请批示。</span>
</div>
<div style="margin:70px auto auto auto ;font-size: 21px;line-height:40px;">
 <span>附件：</span>
    <span style="display:block;text-indent: 2em;line-height:40px;"> 1.主要人员名单；</span>
    <span style="display:block;text-indent: 2em;line-height:40px;"> 2.主要设备清单，包括仪器、车辆；</span>
    <span style="display:block;text-indent: 2em;line-height:40px;"> 3.主要技术资料清单；</span>
    <span style="display:block;text-indent: 2em;line-height:40px;"> 4.动迁计划。</span>
</div>


 <div style="margin:70px auto auto 340px;font-size: 21px;">申请单位：</div>
  <div style="margin:10px auto auto 340px;font-size: 21px;">领导签字：</div>
 <div style="margin:10px auto auto 460px;font-size: 21px;">年&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;日</div>
 </div>

 </body>
<script type="text/javascript">
//alert('aaa');
var retObj2 = jcdpCallService("WtProjectSrv", "getProjectOrgNames", "projectInfoNo=<%=projectInfoNo%>");
if(null!=retObj2.orgNameMap){
	$("#teamid").html(retObj2.orgNameMap.org_name);
}else{
	$("#teamid").html("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;队");
}
$("#projectNameId").html("<%=projectName%>");

var projectInfoNo='<%=projectInfoNo%>';
var querySql = "select di.workarea from gp_task_project t left join gp_workarea_diviede di on di.workarea_no = t.workarea_no where t.project_info_no='"+projectInfoNo+"'";
var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);

if(queryRet.datas.length!='0'){
	$("#areaId").html(queryRet.datas[0].workarea);	
}else{
	$("#areaId").html("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");	
}







<%--
//var resourcesId='<%=resourcesId%>';
var retObj = jcdpCallService("WtProjectResourcesSrv", "getProjectResourcesInfo", "resourcesId="+resourcesId);
$("#project_name").append(retObj.map.project_name);
$("#work_load").append(retObj.map.work_load);
$("#time_limit").append(retObj.map.time_limit);
$("#landform").append(retObj.map.landform);
$("#team_manager").append(retObj.map.team_manager);
$("#instructor").append(retObj.map.instructor);
$("#working_group").append(retObj.map.working_group);
$("#org_name").append(retObj.orgMap.org_name);
//--------设备配置------------------------------------------
if(null!=retObj.deviceMap&& retObj.deviceMap !=undefined){
	//表头
	$("#device").append("<tr><td class='item_center' rowspan='"+retObj.deviceMap.length+1+"'>设备配置</td><td align='center'>名&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;称</td>"+
		"<td align='center' height='40'>数&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;量</td><td align='center'>型&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号</td><td width='100px' align='center' colspan='4'>备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</td></tr>");
	//内容
	for(var i=0;i<retObj.deviceMap.length;i++){
		var obj=retObj.deviceMap[i];
		$("#device").append("<tr><td>"+obj.device_name+"</td><td class='item_center'>"+obj.neednum+"</td><td>"+obj.device_code+"</td><td colspan='4'>"+obj.memo+"</td></tr>");
	}
}else{//数据为空时表头内容
	$("#device").append("<tr><td rowspan='2' class='item_center'>设备配置</td><td class='item_center' align='center'>名&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;称</td>"+
		"<td align='center'>数&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;量</td><td align='center'>型&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号</td><td width='100px' align='center' colspan='4'>备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</td></tr>");
	$("#device").append("<tr><td class='item_center'></td><td></td><td></td><td colspan='4'></td></tr>");
	//$("#device").append("<tr><td class='item_center'></td><td></td><td></td><td></td><td colspan='4'></td></tr>");
}

//--------人员配置------------------------------------------
if(null!=retObj.humanMap&&retObj.humanMap!=undefined){
	//表头
	$("#human").append("<tr><td class='item_center' rowspan='"+retObj.humanMap.length+1+"'>人员配置</td><td colspan='2' align='center' class='item_center'>岗&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;位</td>"+
			"<td align='center'>人&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;数</td><td colspan='4' align='center'>备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</td></tr>");
	//内容
	for(var i=0;i<retObj.humanMap.length;i++){
		obj=retObj.humanMap[i];
		$("#human").append("<tr><td colspan='2'><div id='post"+i+"'></div></td><td class='item_center'>"+obj.human_nums+"</td><td colspan='4'>"+obj.note+"</td></tr>");
		//查询公共代码，并且回填到界面的岗位中
		var postSql="select coding_name from comm_coding_sort_detail where coding_code_id = '"+obj.human_post+"' and bsflag = '0'";
		var postRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+postSql+'&pageSize=1000');
		postObj = postRet.datas;
		if(null!=postObj){
			$("#post"+i).append(postObj[0].coding_name);
		}
	}
}else{//数据为空时表头内容
	$("#human").append("<tr><td class='item_center' rowspan='2'>人员配置</td><td colspan='2' align='center' class='item_center'>岗&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;位</td>"+
	"<td align='center'>人&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;数</td><td colspan='4' align='center'>备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</td></tr>");
	$("#human").append("<tr><td colspan='2'></td><td class='item_center'></td><td colspan='4'></td></tr>");
}
--%>
window.print(); 
</script>
</html>