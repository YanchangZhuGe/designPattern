<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	UserToken user = OMSMVCUtil.getUserToken(request);
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>新增配置计划主申请</title>
</head>
<body>
<%--  
<form name="form1" id="form1" method="post" action="">

          项目名称:
          	<input name="project_name" id="project_name" class="input_width" type="text" value="" readonly/>
          	<input name="projectInfoNo" id="projectInfoNo" type="text" value="<%=projectInfoNo%>" />
          	<input name="device_allapp_id" id="device_allapp_id" type="text" value="" />
          申请单名称:
          	<input name="device_allapp_name" id="device_allapp_name" class="input_width" type="text" value="" />
          申请单号:
          	<input name="device_allapp_no" id="device_allapp_no" class="input_width" type="text" value="保存后自动生成.." style="color:#B0B0B0;" readonly/>
        申请时间:
          	<input name="appdate" id="appdate" class="input_width" type="text" value="" readonly/>
         申请单位名称:
          	<input name="org_id" id="org_id" class="input_width" type="text" value="<%=user.getOrgId()%>"/>
          	<input name="org_name" id="org_name" class="input_width" type="text" value="<%=user.getOrgName()%>" readonly/>
          申请人:
          	<input name="employee_id" id="employee_id" class="input_width" type="text" value="<%=user.getEmpId()%>" />
          	<input name="employee_name" id="employee_name" class="input_width" type="text" value="<%=user.getUserName()%>" readonly/>
 
</form>
--%>
</body>
<script type="text/javascript">

//0 判断是否存在p6任务

	var projectInfoNos ="<%=projectInfoNo%>";
	//alert("ccccc"+projectInfoNos);
	var strra = "select t.* from bgp_p6_project t where  t.project_info_no = '"+projectInfoNos+"'";
	//alert(strra);
	var p6sql = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+strra);
debugger;
if(p6sql.datas.length > 0){
	//存在任务
//1 判断是否存在申请计划 p:projectInfoNo

	
	//检查本项目是否存在bsflag为0的申请单
	var str = "select devapp.device_allapp_id from gms_device_allapp devapp ";
	str += "where devapp.bsflag = '0' and devapp.project_info_no='"+projectInfoNos+"'";
	
	var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
	debugger;
	if(unitRet.datas.length > 0){
		//alert(unitRet.datas[0].device_allapp_id);
		//alert("本项目已保存设备配置计划，不能新增!"); 
		//2跳转到添加明细列表页面 进行修改
		var tob = syncRequest('Post','<%=contextPath%>/p6/resourceAssignment/getTasks.srq','projectInfoNo='+projectInfoNos);
		//alert(tob[0].name);
		
		
		//需要参数  projectInfoNo ，idinfo 计划的id（customStringcustomString += "&"+idinfo+"="+值） ，taskObjectId，taskId，taskName="
		window.location.href="<%=contextPath%>/rm/dm/devPlan/taskPlanListM.jsp?projectInfoNo=<%=projectInfoNo%>&idinfo="+unitRet.datas[0].device_allapp_id+"&taskObjectId="+tob[0].other1+"&taskId="+tob[0].taskId+"&taskName="+encodeURI(encodeURI(tob[0].name,'UTF-8'),'UTF-8');

		
		
	}else{
		//3自动新增一条数据 
		//alert("能新增!"); 
		var params = "";
		
		var retObj;
		var basedatas;
		if('<%=projectInfoNo%>'!=null){
			//查询基本信息
			var querySql = "select pro.project_name,to_char(sysdate,'yyyy-mm-dd') as currentdate ";
			querySql += "from gp_task_project pro ";
			querySql += "where pro.bsflag='0' and pro.project_info_no='<%=projectInfoNo%>'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
		}
		
		//回填基本信息
		params+="&project_name="+basedatas[0].project_name;
		params+="&projectInfoNo="+projectInfoNos;
		//params+="&device_allapp_id="; //新增为空
		params+="&device_allapp_name=设备计划统一调配";//不知值从哪取
		params+="&device_allapp_no=";//保存后自动生成..
		params+="&appdate="+basedatas[0].currentdate;
		params+="&org_id=<%=user.getOrgId()%>";
		params+="&org_name=<%=user.getOrgName()%>";
		params+="&employee_id=<%=user.getEmpId()%>";
		params+="&employee_name=<%=user.getUserName()%>";
		params+="&state=0";
		
		//$("#project_name").val(basedatas[0].project_name);
		//$("#appdate").val(basedatas[0].currentdate);


//		$("#device_allapp_no").val("");
		//大计划保存
		//document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveDevAllAppBaseInfo.srq?state=0";
		//document.getElementById("form1").submit();
		//var path = "<%=contextPath%>/rm/dm/toSaveDevAllAppBaseInfoM.srq?state=0";

		var retObj = jcdpCallService("DevCommInfoSrv", "saveDevAllAppBaseInfo", params);
		
		if(retObj.returnCode==0){
			//4 跳转到添加明细列表页面 进行修改
			
			var unitRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);//取计划id
			var tob = syncRequest('Post','<%=contextPath%>/p6/resourceAssignment/getTasks.srq','projectInfoNo='+projectInfoNos);//取任务
			//alert(tob[0].name);
			//需要参数  projectInfoNo ，idinfo 计划的id（customStringcustomString += "&"+idinfo+"="+值） ，taskObjectId，taskId，taskName="
			window.location.href="<%=contextPath%>/rm/dm/devPlan/taskPlanListM.jsp?projectInfoNo=<%=projectInfoNo%>&idinfo="+unitRet1.datas[0].device_allapp_id+"&taskObjectId="+tob[0].other1+"&taskId="+tob[0].taskId+"&taskName="+encodeURI(encodeURI(tob[0].name,'UTF-8'),'UTF-8');

			
		}
		//syncRequest('Post',path,params);

		
	}

	
}else{
	alert("该项目无任务");

}


	


</script>
</html>

