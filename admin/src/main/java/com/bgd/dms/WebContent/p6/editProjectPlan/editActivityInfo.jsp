<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.List"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.bgp.mcs.service.pm.service.project.P6ProjectPlanSrv,com.cnpc.jcdp.cfg.BeanFactory"%>
<%

	UserToken user = OMSMVCUtil.getUserToken(request);

	String contextPath = request.getContextPath();

	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	
	String taskObjectId = request.getParameter("taskObjectId") != null ? request.getParameter("taskObjectId").toString():"";
	String taskName = request.getParameter("taskName") != null ? request.getParameter("taskName").toString() : "";
	String head = request.getParameter("head") != null ? request.getParameter("head").toString() : "";

	if(taskName != ""){
		taskName = URLDecoder.decode(taskName,"UTF-8");
	}
	if(head != ""){
		head = URLDecoder.decode(head,"UTF-8");
	}
	
	
	String taskId = request.getParameter("taskId") != null ? request.getParameter("taskId").toString() : "";
	String plannedStartDate = request.getParameter("plannedStartDate") != null ? request.getParameter("plannedStartDate").toString() : "";
	String plannedEndDate = request.getParameter("plannedEndDate") != null ? request.getParameter("plannedEndDate").toString() : "";
	String plannedDuration = request.getParameter("plannedDuration") != null ? request.getParameter("plannedDuration").toString() : "";
	

	
	String projectInfoNo = request.getParameter("projectInfoNo") != null ? request.getParameter("projectInfoNo").toString() : "";
	
	String typevalue = request.getParameter("typevalue") != null ? request.getParameter("typevalue").toString() : "";

	P6ProjectPlanSrv planSrv =  new P6ProjectPlanSrv("P6RelationshipWSBean");
	
	List<Map<String,Object>> PredecessorRelationInfoList = null;
	if(planSrv!=null)
		PredecessorRelationInfoList =  planSrv.getPredecessorRelations(taskObjectId); 
	List<Map<String,Object>> SuccessorRelationInfoList = null;
	if(planSrv!=null)
		SuccessorRelationInfoList = planSrv.getSuccessorRelations(taskObjectId);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
</head>

<body style="background:#cdddef;overflow-y: auto;">
<form action="" id="form1" name="form1" method="post">
	<div id="tag-container_3">
	  <ul id="tags" class="tags">
	    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">常用</a></li>
	   	<li id="tag3_1"><a href="#" onclick="getTab3(1)">状态</a></li>
	    <li id="tag3_2"><a href="#" onclick="getTab3(2)">紧前作业</a></li>
	    <li id="tag3_3"><a href="#" onclick="getTab3(3)">后续作业</a></li>
	  </ul>
	</div>
	
	<div id="tab_box" class="tab_box" style="overflow-y: auto;">
		<div id="tab_box_content0" class="tab_box_content">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
		       <tr align="right">
		           <td>&nbsp;</td>
		           <td width="30" id="buttonDis1" ><span class="bc"  onclick="updateActivity()"><a href="#"></a></span></td>
		           <td width="5"></td>
		       </tr>
		    </table>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   <tr>
			      <td class="inquire_item4">作业编号：</td>
			      <td class="inquire_form4"><input name="task_id" id="task_id" class="input_width" type="text" value="<%=taskId%>" />&nbsp;</td>
			  	<td class="inquire_item4">作业名称：</td>
			      <td class="inquire_form4">
			      	<input name="task_name" id="task_name" class="input_width" type="text" value="<%=taskName%>"/>
			      	<input type="hidden" name="task_object_id" id="task_object_id" value="<%=taskObjectId%>"/>
			      </td>
			   </tr>
			   <tr>
			      <td class="inquire_item4">作业类型：</td>
			      <td class="inquire_form4">
			       <select name= 'type' id="type" class='input_width'>
			      			<option value="Task Dependent">任务作业</option>
			       			<option value="Resource Dependent">独立式作业</option>
			       			<option value="Level of Effort">配合作业</option>
			       			<option value="Start Milestone">开始里程碑</option>
			       			<option value="Finish Milestone">完成里程碑</option>
			       			<option value="WBS Summary">WBS作业</option>
			       </select>
			      </td>
			      <td class="inquire_item4">责任人：</td>
			      <td class="inquire_form4"><input name="activityhead" id="activityhead" readonly="readonly" class="input_width" type="text" value="<%=head%>" />&nbsp;</td>
			   </tr>
			   
			</table>
		</div>
		<div id="tab_box_content1" class="tab_box_content" style="display:none;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
		       <tr align="right">
		           <td>&nbsp;</td>
		           <td width="30" id="buttonDis1" ><span class="bc"  onclick="updateActivity()"><a href="#"></a></span></td>
		           <td width="5"></td>
		       </tr>
		    </table>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   <tr>
			      <td class="inquire_item8">作业名称：</td>
			      <td class="inquire_form8">
			      	<input name="" id="" class="input_width" type="text" value="<%=taskName%>"/>
			      </td>
			      <td class="inquire_item8">原定工期：</td>
			      <td class="inquire_form8">
			      <input name="task_id" id="task_id" class="input_width" type="hidden" value="<%=taskId%>" readonly="readonly"/>
			      <input name="plannedDuration" id="plannedDuration" class="input_width" type="text" value="<%=plannedDuration%>"/>天</td>
			      
			     <td class="inquire_item8">计划开始：</td>
			      <td class="inquire_form8"><input name="plan_start_date" id="plan_start_date" class="input_width" type="text" value="<%=plannedStartDate%>"/>
      			  &nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(plan_start_date,tributton1);" />
				  </td>
			      <td class="inquire_item8">计划结束：</td>
			      <td class="inquire_form8"><input name="plan_end_date" id="plan_end_date" class="input_width" type="text" value="<%=plannedEndDate%>"/>
			      &nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(plan_end_date,tributton2);" />
			      </td>
			   </tr>
			   <tr>
			      <td class="inquire_item8">主要限制条件：</td>
			      <td class="inquire_form8">
			      	<select name="Primary_Constraint_Type" id="Primary_Constraint_Type" class="input_width" >
						<option value="">无</option>
			      		<option value="Start On">开始于</option>
			      		<option value="Start On or Before">开始不晚于</option>
			      		<option value="Start On or After">开始不早于</option>
			      		<option value="Finish On">完成于</option>
			      		<option value="Finish On or Before">完成不晚于</option>
			      		<option value="Finish On or After">完成不早于</option>
			      		<option value="As Late As Possible">尽可能晚</option>
			      		<option value="Mandatory Start">强制开始</option>
			      		<option value="Mandatory Finish">强制完成</option>
			      	</select>
			      </td>
			      <td class="inquire_item8">主要限制日期：</td>
			      <td class="inquire_form8"><input name="Primary_Constraint_Date" id="Primary_Constraint_Date" class="input_width" type="text" value=""/>
			      &nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(Primary_Constraint_Date,tributton3);" />
			      
			      </td>
			   	<td class="inquire_item8">次要限制条件：</td>
			      <td class="inquire_form8">
			      	<select name="Secondary_Constraint_Type" id="Secondary_Constraint_Type" class="input_width" >
						<option value="">无</option>
			      		<option value="Start On">开始于</option>
			      		<option value="Start On or Before" >开始不晚于</option>
			      		<option value="Start On or After">开始不早于</option>
			      		<option value="Finish On">完成于</option>
			      		<option value="Finish On or Before">完成不晚于</option>
			      		<option value="Finish On or After">完成不早于</option>
			      		<option value="As Late As Possible">尽可能晚</option>
			      		<option value="Mandatory Start">强制开始</option>
			      		<option value="Mandatory Finish">强制完成</option>
			      	</select>
			      </td>
			      <td class="inquire_item8">次要限制时间：</td>
			      <td class="inquire_form8"><input name="Secondary_Constraint_Date" id="Secondary_Constraint_Date" class="input_width" type="text" value=""/>
			      &nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(Secondary_Constraint_Date,tributton4);" />
			      
			      </td>
			   
			   </tr>

			</table>
		</div>
		
		<div id="tab_box_content2" class="tab_box_content" style="display:none;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
		       <tr align="right">
		           <td>&nbsp;</td>
		           <td width="30" id="buttonDis1" ><span class="zj"  onclick="selectTask(0)"><a href="#"></a></span></td>
		           <td width="30" id="buttonDis2" ><span class="bc"  onclick="savePredecessor()"><a href="#"></a></span></td>
		           <td width="5"></td>
		       </tr>
		    </table>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   <tr>
			      <td class="bt_info_odd">序号</td>
			      <td class="bt_info_odd">项目编码</td>
			      <td class="bt_info_even">WBS名称</td>
			      <td class="bt_info_even">作业编码</td>	
			      <td class="bt_info_even">作业名称</td>	
			      <td class="bt_info_even">关系类型</td>	
			      <td class="bt_info_even">延时</td>	
			      <td class="bt_info_odd">删除</td>		      
			   </tr>
			   <tbody id="predecessorTable">
			   	<%if(PredecessorRelationInfoList != null){ 
				String relationType = "";
				Map<String,Object> relationMap = new HashMap<String,Object>();
				for(int i=0;i<PredecessorRelationInfoList.size();i++){
					relationMap = PredecessorRelationInfoList.get(i);
					String type = (String)relationMap.get("PredecessorRelationType");
				%>
				
				<tr id="tr<%=i+1 %>" name="tr<%=i+1 %>" collseq="tr<%=i+1 %>">
			      <td class="bt_info_odd"><%= i+1 %><input name="predecessorActivityObjectId" id="predecessorActivityObjectId<%=i+1 %>" readonly="readonly" type="hidden" value="<%=relationMap.get("predecessorActivityObjectId")==null?"":relationMap.get("predecessorActivityObjectId").toString()%>"/></td>
			      <td class=""><input name="predecessorProjectId" class="input_width" readonly="readonly" type="text" value="<%=relationMap.get("predecessorProjectId")==null?"":relationMap.get("predecessorProjectId").toString()%>"/></td>
			      <td class=""><input name="predecessorActivityWBSName" class="input_width" readonly="readonly" type="text" value="<%=relationMap.get("predecessorActivityWBSName")==null?"":relationMap.get("predecessorActivityWBSName").toString()%>"/></td>			     
			      <td class=""><input name="predecessorActivityId" class="input_width" readonly="readonly" type="text" value="<%=relationMap.get("predecessorActivityId")==null?"":relationMap.get("predecessorActivityId").toString()%>"/>&nbsp;</td>
			      <td class=""><input name="predecessorActivityName" class="input_width" readonly="readonly" type="text" value="<%=relationMap.get("predecessorActivityName")==null?"":relationMap.get("predecessorActivityName").toString()%>"/></td>
			      
			      <td class="">
				      <select name="predecessor_type<%=i+1 %>" class="input_width" id="predecessor_type<%=i+1 %>">
					      <option value="Finish to Start" <%if("Finish to Start".equals(type)){ %> selected="selected"<% }%> >完成-开始</option>
					      <option value="Finish to Finish" <%if("Finish to Finish".equals(type)){ %> selected="selected"<% }%> >完成-完成</option>
					      <option value="Start to Start" <%if("Start to Start".equals(type)){ %> selected="selected"<% }%>  >开始-开始</option>
					      <option value="Start to Finish" <%if("Start to Finish".equals(type)){ %> selected="selected"<% }%>  >开始-完成</option>
				      </select>
				      <input name="predecessorAddorUpdate<%=i+1 %>" id="predecessorAddorUpdate<%=i+1 %>" value="update" type="hidden"/>
				      <input name="predecessorRelationObjectId<%=i+1 %>" id="predecessorRelationObjectId<%=i+1 %>" value="<%=relationMap.get("relationObjectId")==null?"":relationMap.get("relationObjectId").toString()%>" type="hidden"/>
				   </td>
			     <td class=""><input name="PredecessororLag<%=i+1 %>" id="PredecessororLag<%=i+1 %>" class="input_width" type="text" value="<%=relationMap.get("PredecessororLag")==null?"":relationMap.get("PredecessororLag").toString()%>"/>&nbsp;</td>
			     
			      <td class=""><img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="toDelete(0,<%=relationMap.get("relationObjectId")==null?"":relationMap.get("relationObjectId").toString()%>,<%=i+1%>)"/>&nbsp;</td>
			   </tr>
				<% 
					}	
				}
				%>
			   </tbody>
			</table>
		</div>
		<div id="tab_box_content3" class="tab_box_content" style="display:none;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
		       <tr align="right">
		           <td>&nbsp;</td>
		           <td width="30" id="buttonDis1" ><span class="zj"  onclick="selectTask(1)"><a href="#"></a></span></td>
		           <td width="30" id="buttonDis2" ><span class="bc"  onclick="saveSuccessor()"><a href="#"></a></span></td>
		           <td width="5"></td>
		       </tr>
		    </table>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   <tr>
			      <td class="bt_info_odd">序号</td>
			      <td class="bt_info_odd">项目编码</td>
			      <td class="bt_info_even">WBS名称</td>
			      <td class="bt_info_even">作业编码</td>	
			      <td class="bt_info_even">作业名称</td>	
			      <td class="bt_info_even">关系类型</td>	
			      <td class="bt_info_even">延时</td>	
			      <td class="bt_info_odd">删除</td>		      
			   </tr>
			   <tbody id="successorTable">
			    <%if(SuccessorRelationInfoList != null){ 
				String relationType = "";
				Map<String,Object> relationMap = new HashMap<String,Object>();
				for(int i=0;i<SuccessorRelationInfoList.size();i++){
					relationMap = SuccessorRelationInfoList.get(i);
					String type=(String)relationMap.get("SuccessorRelationType");
				%>
				<tr id="tr<%=i+1 %>" name="tr<%=i+1 %>" collseq="tr<%=i+1 %>">
			      
			   	 <td class="bt_info_odd"><%= i+1 %><input name="successorActivityObjectId" id="successorActivityObjectId<%=i+1 %>" readonly="readonly" type="hidden" value="<%=relationMap.get("successorActivityObjectId")==null?"":relationMap.get("successorActivityObjectId").toString()%>"/></td>
			     <td class=""><input name="successorProjectId" class="input_width" type="text" readonly="readonly" value="<%=relationMap.get("successorProjectId")==null?"":relationMap.get("successorProjectId").toString()%>"/></td>
			   	 <td class=""><input name="successorActivityWBSName" class="input_width" type="text" readonly="readonly" value="<%=relationMap.get("successorActivityWBSName")==null?"":relationMap.get("successorActivityWBSName").toString()%>"/></td>
			     <td class=""><input name="successorActivityId" class="input_width" readonly="readonly" type="text" value="<%=relationMap.get("successorActivityId")==null?"":relationMap.get("successorActivityId").toString()%>"/>&nbsp;</td>
			     <td class=""><input name="successorActivityName" class="input_width" type="text" readonly="readonly" value="<%=relationMap.get("successorActivityName")==null?"":relationMap.get("successorActivityName").toString()%>"/></td>
			      <td class="">
			      
			      <select name="successor_type<%=i+1 %>" class="input_width" id="successor_type<%=i+1 %>">
				      <option value="Finish to Start" <%if("Finish to Start".equals(type)){ %> selected="selected"<% }%> >完成-开始</option>
				      <option value="Finish to Finish" <%if("Finish to Finish".equals(type)){ %> selected="selected"<% }%> >完成-完成</option>
				      <option value="Start to Start" <%if("Start to Start".equals(type)){ %> selected="selected"<% }%>  >开始-开始</option>
				      <option value="Start to Finish" <%if("Start to Finish".equals(type)){ %> selected="selected"<% }%>  >开始-完成</option>
			      </select>
				      <input name="successorAddorUpdate<%=i+1%>" id="successorAddorUpdate<%=i+1%>" value="update" type="hidden"/>
				      <input name="successorRelationObjectId<%=i+1 %>" id="successorRelationObjectId<%=i+1 %>" value="<%=relationMap.get("relationObjectId")==null?"":relationMap.get("relationObjectId").toString()%>" type="hidden"/>
				      
			      </td>
			     
			     <td class=""><input name="SuccessorLag<%=i+1 %>" id="SuccessorLag<%=i+1 %>" class="input_width" type="text" value="<%=relationMap.get("SuccessorLag")==null?"":relationMap.get("SuccessorLag").toString()%>"/>&nbsp;</td>
			     
			      <td class=""><img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="toDelete(1,<%=relationMap.get("relationObjectId")==null?"":relationMap.get("relationObjectId").toString()%>,<%=i+1%>)"/>&nbsp;</td>
			   </tr>
				<% 
					}	
				}
				%>
			   </tbody>
			</table>
		</div>
	</div>
	</form>
</body>
<script type="text/javascript">
	$("#type").val('<%=typevalue%>');
	
	var proSql = "select * from BGP_P6_ACTIVITY where OBJECT_ID='<%=taskObjectId%>'";
	var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql+'&pageSize=1000');
	retObj = proqueryRet.datas;
	//alert(retObj[0].secondary_constraint_type);
	$("#Primary_Constraint_Type").val(retObj[0].primary_constraint_type);
	$("#Primary_Constraint_Date").val(retObj[0].primary_constraint_date);
	$("#Secondary_Constraint_Type").val(retObj[0].secondary_constraint_type);
	$("#Secondary_Constraint_Date").val(retObj[0].secondary_constraint_date);
	
	
	
function updateActivity(){
		
		var str = "task_name="+document.getElementById("task_name").value;
		str += "&task_id="+encodeURI(encodeURI(document.getElementById("task_id").value));
		str += "&task_object_id="+document.getElementById("task_object_id").value;
		str += "&activityhead="+document.getElementById("activityhead").value;
		str += "&type="+document.getElementById("type").value;
		str += "&plan_start_date="+document.getElementById("plan_start_date").value;
		str += "&plan_end_date="+document.getElementById("plan_end_date").value;
		
		str += "&plannedDuration="+document.getElementById("plannedDuration").value;
		str += "&Primary_Constraint_Type="+document.getElementById("Primary_Constraint_Type").value;
		str += "&Primary_Constraint_Date="+document.getElementById("Primary_Constraint_Date").value;
		str += "&Secondary_Constraint_Type="+document.getElementById("Secondary_Constraint_Type").value;
		str += "&Secondary_Constraint_Date="+document.getElementById("Secondary_Constraint_Date").value;


		var obj = jcdpCallService("P6ProjectPlanSrv", "updateTask", str);
		if(obj != null && obj.message == "success") {
			alert("修改成功");
			
			reload();
		} else {
			alert("修改失败");
		}
}
function reload(){
	var ctt = top.frames['list'];
	if(ctt != "" && ctt != undefined){
		ctt.mainTopframe.refreshTreeStore();
	}
}

function addPredecessor(objectId,taskName,taskId,projectId,wbsName){
		var tbody = $("tr","#predecessorTable");
 		var showseq = tbody.size()+1;
 		var lasttr = tbody.eq(tbody.size()-1);
 		var tr_id = lasttr.attr("id");
		if(tr_id != undefined){
			tr_id = parseInt(tr_id.substr(2,1),10);
		}
		if(tr_id == undefined){
			tr_id = 1;
		}else{
			tr_id = tr_id+1;
		}
		//动态新增表格
		var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' collseq='"+tr_id+"'>";
		
		innerhtml += "<td class='bt_info_odd'>"+showseq+"<input name='predecessorActivityObjectId' id='predecessorActivityObjectId"+tr_id+"' type='hidden' value ='"+objectId+"'/></td>";
		innerhtml += "<td><input name='predecessorProjectId' id='predecessorProjectId"+tr_id+"' class='input_width' readonly = 'readonly' type='text' value='"+projectId+"'/>&nbsp;&nbsp;";
		innerhtml += "</td>";
		innerhtml += "<td><input name='predecessorActivityWBSName' id='predecessorActivityWBSName_"+tr_id+"' class='input_width' readonly = 'readonly' type='text' value='"+wbsName+"'/></td>";
		innerhtml += "<td><input name='predecessorActivityId' id='predecessorActivityId_"+tr_id+"' class='input_width' readonly = 'readonly' type='text' value='"+taskId+"'/></td>";
		innerhtml += "<td><input name='predecessorActivityName' id='predecessorActivityName_"+tr_id+"' class='input_width' readonly = 'readonly' type='text' value='"+taskName+"'/>&nbsp;&nbsp;";
		innerhtml += "</td>";
		innerhtml += "<td>";
		innerhtml += "<select name='predecessor_type"+tr_id+"'  id='predecessor_type"+tr_id+"'  class='input_width'>";
		innerhtml += "<option value='Finish to Start'>完成-开始</option>";
		innerhtml += "<option value='Finish to Finish'>完成-完成</option>";
		innerhtml += "<option value='Start to Start'>开始-开始</option>";
		innerhtml += "<option value='Start to Finish'>开始-完成</option>";
		innerhtml += "</select>";
		innerhtml += "<input name='predecessorAddorUpdate"+tr_id+"' id='predecessorAddorUpdate"+tr_id+"' value='add' type='hidden'/></td>";
		innerhtml += "<td><input name='PredecessororLag"+tr_id+"' id='PredecessororLag"+tr_id+"' class='input_width'  type='text' value='0'/>";
		innerhtml += "<input name='relationShipId"+tr_id+"' id='relationShipId"+tr_id+"' class='input_width' type='hidden' value=''/></td>";
		
		innerhtml += "<td><img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='toDelete(0,0,"+tr_id+")'/>&nbsp;</td>";
		innerhtml += "</tr>";
		
		$("#predecessorTable").append(innerhtml);
}

function addSuccessor(objectId,taskName,taskId,projectId,wbsName){
	var tbody = $("tr","#successorTable");
		var showseq = tbody.size()+1;
		var lasttr = tbody.eq(tbody.size()-1);
		var tr_id = lasttr.attr("id");
	if(tr_id != undefined){
		tr_id = parseInt(tr_id.substr(2,1),10);
	}
	if(tr_id == undefined){
		tr_id = 1;
	}else{
		tr_id = tr_id+1;
	}
	//动态新增表格
	var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' collseq='"+tr_id+"'>";
	
	innerhtml += "<td class='bt_info_odd'>"+showseq+"<input name='successorActivityObjectId' id='successorActivityObjectId_"+tr_id+"' type='hidden' value ='"+objectId+"'/></td>";
	innerhtml += "<td><input name='successorProjectId' id='successorProjectId_"+tr_id+"' readonly = 'readonly' class='input_width' type='text' value='"+projectId+"'/>&nbsp;&nbsp;";
	innerhtml += "</td>";
	innerhtml += "<td><input name='successorActivityWBSName' id='successorActivityWBSName_"+tr_id+"' class='input_width' readonly = 'readonly' type='text' value='"+wbsName+"'/></td>";
	innerhtml += "<td><input name='successorActivityId' id='successorActivityId_"+tr_id+"' class='input_width' readonly = 'readonly' type='text' value='"+taskId+"'/></td>";
	innerhtml += "<td><input name='successorActivityName' id='successorActivityName_"+tr_id+"' readonly = 'readonly' class='input_width' type='text' value='"+taskName+"'/>&nbsp;&nbsp;";
	innerhtml += "</td>";
	innerhtml += "<td>";
	innerhtml += "<select name= 'successor_type"+tr_id+"'  id= 'successor_type"+tr_id+"' class='input_width'>";
	innerhtml += "<option value='Finish to Start'>完成-开始</option>";
	innerhtml += "<option value='Finish to Finish'>完成-完成</option>";
	innerhtml += "<option value='Start to Start'>开始-开始</option>";
	innerhtml += "<option value='Start to Finish'>开始-完成</option>";
	innerhtml += "</select>";
	innerhtml += "<input name='successorAddorUpdate"+tr_id+"' id='successorAddorUpdate"+tr_id+"' value='add' type='hidden'/></td>";
	innerhtml += "<td><input name='SuccessorLag"+tr_id+"' id='SuccessorLag"+tr_id+"' class='input_width' type='text' value='0'/>";
	innerhtml += "<input name='relationShipId"+tr_id+"' id='relationShipId"+tr_id+"' class='input_width' type='hidden' value=''/></td>";
	
	
	innerhtml += "<td><img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='toDelete(1,0,"+tr_id+")'/>&nbsp;</td>";
	innerhtml += "</tr>";
	
	$("#successorTable").append(innerhtml);
}

function toDelete(tableId,objectId,trId){

		if(objectId == "0"){
			if(tableId=='0'){
				var id = $('#relationShipId'+trId,"#predecessorTable").val();	
				var str = "relation_object_id="+id;	
			}else if(tableId=='1'){
				var id = $('#relationShipId'+trId,"#successorTable").val();	
				var str = "relation_object_id="+id;	
				
			}
		}else{	
			//已经写入数据库,需要删除页面和数据库数据
			var str = "relation_object_id="+objectId;
		}
		var obj = jcdpCallService("P6ProjectPlanSrv", "deleteTaskRelationShip", str);
		if(obj != null && obj.message == "success") {
			if(tableId=='0'){
				$('#tr'+trId,"#predecessorTable").remove();	
			}else if(tableId=='1'){
				$('#tr'+trId,"#successorTable").remove();	
			}
			alert("修改成功");
		} else {
			alert("修改失败");
		}
}

function selectTask(flag){
	var taskInfo = {
			fkValue:"",
			value:"",
			id:""
	};
	window.showModalDialog('<%=contextPath%>/p6/editProjectPlan/selectTask.jsp?project_info_no=<%=projectInfoNo%>',taskInfo);
	if(taskInfo.fkValue!=""){
			var taskObjectIds = taskInfo.fkValue;
			var taskNames = taskInfo.value;
			var taskIds = taskInfo.id;
			var taskProjectIds = taskInfo.projectId;
			var checkwbsNames = taskInfo.wbsName;
			
			
			var ObjectIdArray = taskObjectIds.split(",");
			var taskNameArray = taskNames.split(",");
			var taskIdArray = taskIds.split(",");
			var taskProjectIdArray = taskProjectIds.split(",");
			var taskwbsNameArray = checkwbsNames.split(",");
			
			if(flag == "0"){
				for(var i=0;i<ObjectIdArray.length;i++){
					addPredecessor(ObjectIdArray[i],taskNameArray[i],taskIdArray[i],taskProjectIdArray[i],taskwbsNameArray[i]);
				}
			}else if(flag == "1"){
				for(var i=0;i<ObjectIdArray.length;i++){
					addSuccessor(ObjectIdArray[i],taskNameArray[i],taskIdArray[i],taskProjectIdArray[i],taskwbsNameArray[i]);
				}
			}
	}
}

function savePredecessor(){
	var ctt = top.frames['list'];
	var ids = document.getElementsByName("predecessorActivityObjectId");
	var predecessorObjectIds = "";
    for (i=0; i<ids.length; i++){   
    	predecessorObjectIds += "," + ids[i].value;
    } 
    predecessorObjectIds = predecessorObjectIds =="" ? "" : predecessorObjectIds.substr(1);
    if(predecessorObjectIds == ""){
    	//alert("没有新添加的数据");
    	//return;
    }

	//document.getElementById("form1").action = "<%=contextPath%>/pm/p6/addTaskRelationShip.srq?type_flag=predecessor&activity_object_id=<%=taskObjectId%>&predecessor_object_ids="+predecessorObjectIds;  
	//document.getElementById("form1").submit();	
    //var str = "type_flag= predecessor&activity_object_id=<%=taskObjectId%>&predecessor_object_ids="+predecessorObjectIds;
	//var obj = jcdpCallService("P6ProjectPlanSrv", "addTaskRelationShip", str);
	
	var str = $("#form1").serialize();		
	str+="&type_flag=predecessor&activity_object_id=<%=taskObjectId%>&predecessor_object_ids="+predecessorObjectIds;  	
	var result = jcdpCallService("P6ProjectPlanSrv", "addTaskRelationShip", str);
	if(result != null && result.message == "success") {
		var list = result.relationshipIds;
		if(list!=null){
			for(var i=0;i<list.length;i++){
				var tempid = list[i].index;
				var tempvalue = list[i].value;
				$('#relationShipId'+tempid,"#predecessorTable").val(tempvalue);				
			}
		}

		alert("修改成功");
	} else {
		alert("修改失败");
	}
}

function saveSuccessor(){
	var ctt = top.frames['list'];
	var ids = document.getElementsByName("successorActivityObjectId");
	var successorObjectIds = "";
    for (i=0; i<ids.length; i++){   
    	successorObjectIds += "," + ids[i].value;
    } 
    successorObjectIds = successorObjectIds =="" ? "" : successorObjectIds.substr(1);
    if(successorObjectIds == ""){
    	//alert("没有新添加的数据");
    	//return;
    }
	//document.getElementById("form1").action = "<%=contextPath%>/pm/p6/addTaskRelationShip.srq?type_flag=successor&activity_object_id=<%=taskObjectId%>&successor_object_ids="+successorObjectIds;  
	//document.getElementById("form1").submit();
	//var str = "type_flag=successor&activity_object_id=<%=taskObjectId%>&successor_object_ids="+successorObjectIds;
	//var obj = jcdpCallService("P6ProjectPlanSrv", "addTaskRelationShip", str);
	
	var str = $("#form1").serialize();		
	 str+="&type_flag=successor&activity_object_id=<%=taskObjectId%>&successor_object_ids="+successorObjectIds; 	
		var result = jcdpCallService("P6ProjectPlanSrv", "addTaskRelationShip", str);
		if(result != null && result.message == "success") {
			var list = result.relationshipIds;
			for(var i=0;i<list.length;i++){
				var tempid = list[i].index;
				var tempvalue = list[i].value;
				$('#relationShipId'+tempid,"#successorTable").val(tempvalue);	
			}
			alert("修改成功");
		} else {
			alert("修改失败");
		}
}

function resetSeqinfo(tableId){
	if(tableId == "1"){
		$("tr","#successorTable").each(function(i){
			var cells = this.cells;
			$(cells[0]).text((i+1));
			$(cells[0]).attr("align","center");
		});
	}else if(tableId == "0"){
		$("tr","#predecessorTable").each(function(i){
			var cells = this.cells;
			$(cells[0]).text((i+1));
			$(cells[0]).attr("align","center");
		});
	}
}

function frameSize(){

	var height = $(window).height()-$("#head").height()-$("#head_bot").height()-$("#mainTopframe").height();
	

	$("#tab_box").css("height",300);
	//$("#tab_box").css("height",$(window).height()-$("#head").height()-$("#head_bot").height()-$("#mainTopframe").height());

	var width = $(window).width()-$("#page_aside").width()-$("#navHidBtn").width();

	$("#frame_ctt").css("width",width);

	$("#navHid a").css("margin-top",height/2-22);

}

frameSize();


$(function(){

	$(window).resize(function(){

  		frameSize();

	});

})	

</script>

<script type="text/javascript">

	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	var selectedTag=document.getElementsByTagName("li")[0];

	function getTab(obj,index) {  
		if(selectedTag!=null){
			selectedTag.className ="";
		}

		selectedTag = obj.parentElement;

		selectedTag.className ="selectTag";

	}


</script>

</html>

