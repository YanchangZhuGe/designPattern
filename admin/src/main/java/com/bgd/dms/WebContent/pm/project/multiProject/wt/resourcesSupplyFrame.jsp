<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="java.util.*" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@ page import="java.text.*" %>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String	projectInfoNo=request.getParameter("projectInfoNo")==null?user.getProjectInfoNo():request.getParameter("projectInfoNo");
	//String	projectType = request.getParameter("projectType")==null?user.getProjectType():request.getParameter("projectType");
	String	mid= request.getParameter("mid")==null?"":request.getParameter("mid");
	//String	planId= request.getParameter("planId")==null?"":request.getParameter("planId");
	//String	devId= request.getParameter("devId")==null?"":request.getParameter("devId");
	
	//action=="view" 审批页面
	String action = request.getParameter("action")==null?"":request.getParameter("action");
	String signle = request.getParameter("signle")==null?"":request.getParameter("signle");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<title>项目资源补充配置</title>
</head>
<body style="background:#fff" onload="refreshData();"  onbeforeunload="return CloseEvent();">
      	<div id="list_table">
			<div id="list_table"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				  <td>
					  <ul id="tags" class="tags">
					    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
					    <li id="tag3_3"><a href="#" onclick="getTab3(3)">申请明细</a></li>
					    <li id="tag3_1"><a href="#" onclick="getTab3(1)">人员配置</a></li>
					    <li id="tag3_2"><a href="#" onclick="getTab3(2)">设备配置</a></li>
					  </ul>
				  </td>
			  </tr>
			  </table>
			</div>
			<div id="tab_box" class="tab_box">
				<form name="resourcesForm" id="resourcesForm"  method="post" action="">
				<div id="tab_box_content0" class="tab_box_content">
				    <%if(!"view".equals(action)){%>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateResources()"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
	                </table>
	                <%} %>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr>
							<td class="inquire_item4">项目名称：</td>
							<td class="inquire_form4">
						    	<input type="hidden" id="resources_id" name="resources_id" />
							    <input type="hidden" id="project_info_no" name="project_info_no" value=""/>
							    <input type="text" id="project_name" name="project_name" value="" class="input_width" readonly="readonly"/>
					    	</td>
						    <td class="inquire_item4"></td>
						    <td class="inquire_form4"></td>
					  	</tr>
					  	<tr>
						    <td class="inquire_item4">施工队伍：</td>
						    <td class="inquire_form4"><input type="text" id="org_name" name="org_name" class="input_width" readonly="readonly"/></td>
						    <td class="inquire_item4">作业组数量：</td>
							<td class="inquire_form4"><input type="text" value="" id="working_group" name="working_group" class="input_width"/></td>
					  	</tr>
					  	<tr>
					  		<td class="inquire_item4">队经理：</td>
							<td class="inquire_form4"><input type="text" id="team_manager" name="team_manager" class="input_width"/></td>
							<td class="inquire_item4">副队经理：</td>
							<td class="inquire_form4"><input type="text" id="team_manager_f" name="team_manager_f" class="input_width"/></td>
						</tr>
						<tr>
							<td class="inquire_item4">指导员：</td>
							<td class="inquire_form4"><input type="text" id="instructor" name="instructor" class="input_width"/></td>
							<td class="inquire_item4">工期要求：</td>
							<td class="inquire_form4"><input type="text" id="time_limit" name="time_limit" class="input_width"/></td>
						</tr>
						<tr>
							<td class="inquire_item4">工作量：</td>
							<td id="item_workload" class="inquire_form4" colspan="3"></td>
						</tr>
					  	<tr>
					  		<td class="inquire_item4">地形：</td>
							<td id="item_landform" class="inquire_form4" colspan="3"></td>
					  	</tr>
					</table>
				</div>
				</form>
				<div id="tab_box_content1" style="display:none;width:100%;height:500px;overflow:auto;border:1px #aebccb solid;background:#fff;">
					<iframe width="100%" height="100%" name="human" id="human"></iframe>
				</div>
				
				<div id="tab_box_content2" style="display:none;width:100%;height:500px;overflow:auto;border:1px #aebccb solid;background:#fff;">
					<iframe width="100%" height="100%" name="dev" id="dev"></iframe>
				</div>
				
				<div id="tab_box_content3" style="display:none;width:100%;height:500px;overflow:auto;border:1px #aebccb solid;background:#fff;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  	<tr>
					  		<td class="inquire_item4">申请理由：</td>
							<td class="inquire_form4" colspan="3">
				            	<textarea name="memo" id="memo" rows="8" cols=50" readonly="readonly"></textarea>
				            </td>
						</tr>
					</table>
				</div>
			</div>
		  </div>
<script type="text/javascript">

var DispClose = true;  
/* function CloseEvent()  
{  
    if (DispClose)  
    {  
        return "是否离开当前页面?";  
    }  
}   */


function frameSize(){
	setTabBoxHeight();
}
frameSize();

$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

</script>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNo="<%=projectInfoNo%>";
	var mid="<%=mid%>";

	var projectType="";
	var planId="";//人力补充配置主表ID
	var deviceaddappid=""; //设备补充配置主表id
	var deviceallappid=""; //配置计划主表ID

	
	var action="<%=action%>";
	var taskObjectId="";
	var taskName="";
		
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	
	function refreshData(){
		//获得一些参数
		var querySql = "select p.project_type,m.human_id,m.dev_id,m.memo,d.device_allapp_id "+
			" from gp_middle_resources m "+
			"left join bgp_comm_human_plan h on m.human_id=h.plan_id and h.bsflag='0' "+
			"left join gms_device_allapp_add d on m.dev_id=d.device_addapp_id and d.bsflag='0' "+
			"left join gp_task_project p on m.project_info_no=p.project_info_no and p.bsflag='0' "+
			"where m.mid='"+mid+"' order by m.create_date desc";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(datas!=null && datas.length>0){
			projectType=datas[0].project_type;
			planId=datas[0].human_id;
			deviceaddappid=datas[0].dev_id;
			deviceallappid=datas[0].device_allapp_id;
			document.getElementById("memo").value=datas[0].memo;
			shenText=datas[0].memo;
		}
		
		//------------------------------基本信息-------------------------------
		var retObj = jcdpCallService("WtProjectSrv", "getProjectResourcesInfo","projectInfoNo="+projectInfoNo);
		document.getElementById("resources_id").value=retObj.map==null?"":retObj.map.resources_id;
	    document.getElementById("project_info_no").value=retObj.map==null?"":retObj.map.project_info_no;
	    document.getElementById("project_name").value=retObj.map==null?"":retObj.map.project_name;
	    document.getElementById("org_name").value=retObj.map==null?"":retObj.orgMap.org_name;
	    document.getElementById("working_group").value=retObj.map==null?"":retObj.map.working_group;
	    document.getElementById("team_manager").value=retObj.map==null?"":retObj.map.team_manager;
	    document.getElementById("team_manager_f").value=retObj.map==null?"":retObj.map.team_manager_f;
	    document.getElementById("instructor").value=retObj.map==null?"":retObj.map.instructor;
	    document.getElementById("time_limit").value=retObj.map==null?"":retObj.map.time_limit;
	    var word_load=retObj.map.work_load==null?"":retObj.map.work_load;
	    word_load=word_load.replace(new RegExp("m2", 'g'),"m&sup2");
	    var landform=retObj.map.landform==null?"":retObj.map.landform;
	    landform=landform.replace(new RegExp("m2", 'g'),"m&sup2");
	    //工作量
	    document.getElementById("item_workload").innerHTML="<textarea id='work_load'  name='work_load' cols='63' rows='10'>"+word_load+"</textarea>";
	    //地形
	    document.getElementById("item_landform").innerHTML="<textarea id='landform' name='landform' cols='63' rows='5'>"+landform+"</textarea>";
		//人员配置
	    document.getElementById("human").src = "<%=contextPath%>/pm/project/multiProject/wt/resourcesHumanApply.jsp?mid="+mid+"&planId="+planId+"&projectInfoNo="+projectInfoNo+"&projectType="+projectType+"&action="+action;
	    //设备配置
	    document.getElementById("dev").src = "<%=contextPath%>/pm/project/multiProject/wt/resourcesDevApply.jsp?mid="+mid+"&projectInfoNo="+projectInfoNo+"&deviceaddappid="+deviceaddappid+"&deviceallappid="+deviceallappid+"&projectType="+projectType+"&action="+action;
	}


	function toUpdateResources(){
		if (!checkForm()) return;
		var params = $("#resourcesForm").serialize();
		var retObj = jcdpCallService("WtProjectSrv","saveProjectResources",params);
		if(retObj != null &&retObj.message == "success") {
			alert("修改成功");
		} else {
			alert("修改失败");
		}
	}

	function checkForm(){ 	
		if (!isTextPropertyNotNull("project_name", "项目名称")) return false;	
		if (!isLimitB100("working_group","作业组数量")) return false;  
		if (!isLimitB20("team_manager","队经理")) return false; 
		if (!isLimitB20("team_manager_f","副队经理")) return false;
		if (!isLimitB20("instructor","指导员")) return false;  
		if (!isLimitB100("time_limit","工期要求")) return false;  
		if (!isLimitB1000("work_load","工作量")) return false;  
		if (!isLimitB1000("landform","地形")) return false;  
		return true;
	}
</script>
</body>
</html>