<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.List"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%

	UserToken user = OMSMVCUtil.getUserToken(request);

	String contextPath = request.getContextPath();

	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);

	MsgElement msg1 = respMsg.getMsgElement("map");
	Map map1 = msg1.toMap();
	
	List LaborList = respMsg.getMsgElements("LaborList");//人工
	List NonlaborList = respMsg.getMsgElements("NonlaborList");//非人工
	List MaterialLlist = respMsg.getMsgElements("MaterialLlist");//材料
	List<MsgElement> CodeInfoList = respMsg.getMsgElements("CodeInfoList");// 作业分类码
	List<MsgElement> PredecessorRelationInfoList =respMsg.getMsgElements("PredecessorRelationInfoList");//紧前作业
	List<MsgElement> SuccessorRelationInfoList =respMsg.getMsgElements("SuccessorRelationInfoList");//后续作业
	List<MsgElement> ResourceInfoList =respMsg.getMsgElements("ResourceInfoList");//资源信息
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

</head>

<body style="background:#cdddef">
	<div id="tag-container_3">
	  <ul id="tags" class="tags">
	    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">常用</a></li>
	    <li id="tag3_1"><a href="#" onclick="getTab3(1)">资源</a></li>
	    <li id="tag3_2"><a href="#" onclick="getTab3(2)">分类码</a></li>
	    <li id="tag3_3"><a href="#" onclick="getTab3(3)">紧前作业</a></li>
	    <li id="tag3_4"><a href="#" onclick="getTab3(4)">后续作业</a></li>
	  </ul>
	</div>
	
	<div id="tab_box" class="tab_box" style="overflow-y: auto;">
		<div id="tab_box_content0" class="tab_box_content">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   <tr>
			      <td class="inquire_item8">状态：</td>
			      <td class="inquire_form8"><input name="status" class="input_width" type="text" value="<%=map1.get("STATUS_NAME")%>"/>&nbsp;</td>
			      <td class="inquire_item8">作业代码：</td>
			      <td class="inquire_form8"><input name="id" class="input_width" type="text" value="<%=map1.get("ID")%>"/>&nbsp;</td>
			      <td class="inquire_item8">作业名称：</td>
			      <td class="inquire_form8"><input name="name" class="input_width" type="text" value="<%=map1.get("NAME")%>"/>&nbsp;</td>
			      <td class="inquire_item8">原定工期：</td>
			      <td class="inquire_form8"><input name="plannedDuration" class="input_width" type="text" value="<%=Long.parseLong((String)map1.get("PLANNED_DURATION"))/Long.parseLong((String)map1.get("HOURS_PER_DAY")) %>"/>&nbsp;天</td>
			   </tr>
			   <tr>
			      <td class="inquire_item8">开始日期：</td>
			      <td class="inquire_form8"><input name="startDate" class="input_width" type="text" value="<%=map1.get("START_DATE")==null?"":map1.get("START_DATE").toString().substring(0,10)%>"/>&nbsp;</td>
			      <td class="inquire_item8">完工日期：</td>
			      <td class="inquire_form8"><input name="finishDate" class="input_width" type="text" value="<%=map1.get("FINISH_DATE")==null?"":map1.get("FINISH_DATE").toString().substring(0,10)%>"/>&nbsp;</td>
			      <td class="inquire_item8">预计开工日期：</td>
			      <td class="inquire_form8"><input name="plannedStartDate" class="input_width" type="text" value="<%=map1.get("PLANNED_START_DATE")==null?"&nbsp;":map1.get("PLANNED_START_DATE").toString().substring(0,10)%>"/>&nbsp;</td>
			      <td class="inquire_item8">预计完工日期：</td>
			      <td class="inquire_form8"><input name="plannedFinishDate" class="input_width" type="text" value="<%=map1.get("PLANNED_FINISH_DATE")==null?"&nbsp;":map1.get("PLANNED_FINISH_DATE").toString().substring(0,10) %>"/>&nbsp;</td>
			   </tr>
			</table>
		</div>
		<div id="tab_box_content1" class="tab_box_content" style="display:none;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   <tr>
			      <td class="bt_info_odd">序号</td>
			      <td class="bt_info_even">资源代码</td>
			      <td class="bt_info_odd">资源名称</td>
			      <td class="bt_info_even">计划数量</td>
			      <td class="bt_info_odd">预算数量</td>
			      <td class="bt_info_even">本期实际数量</td>
			      <td class="bt_info_odd">实际数量</td>	
			      <td class="bt_info_even">尚需数量</td>
			      <td class="bt_info_odd">完成时数量</td>	
			      <td class="bt_info_even">资源类型</td>		      
			   </tr>
			   <%if(ResourceInfoList != null){ 
				Map<String,Object> ResourceMap = new HashMap<String,Object>();
				for(int i=0;i<ResourceInfoList.size();i++){
					ResourceMap = ((MsgElement)ResourceInfoList.get(i)).toMap();
				%>
				<tr>
			      <td class="bt_info_odd"><%= i+1 %>&nbsp;</td>
			      <td class=""><input name="resource_name" class="input_width" type="text" value="<%=ResourceMap.get("resourceId")==null?"":ResourceMap.get("resourceId").toString()%>"/>&nbsp;</td>
			      <td class=""><input name="resource_id" class="input_width" type="text" value="<%=ResourceMap.get("resourceName")==null?"":ResourceMap.get("resourceName").toString()%>"/>&nbsp;</td>
			      <td class=""><input name="budgeted_units" class="input_width" type="text" value="<%=ResourceMap.get("budgetValue")==null?"":ResourceMap.get("budgetValue").toString()%>"/>&nbsp;</td>
			      <td class=""><input name="planned_units" class="input_width" type="text" value="<%=ResourceMap.get("plannedUnits")==null?"":ResourceMap.get("plannedUnits").toString()%>"/>&nbsp;</td>
			      <td class=""><input name="actual_this_period_units" class="input_width" type="text" value="<%=ResourceMap.get("actualThisPeriodUnits")==null?"":ResourceMap.get("actualThisPeriodUnits").toString()%>"/>&nbsp;</td>
			      <td class=""><input name="actual_units" class="input_width" type="text" value="<%=ResourceMap.get("actualUnits")==null?"":ResourceMap.get("actualUnits").toString()%>"/>&nbsp;</td>
			      <td class=""><input name="remaining_units" class="input_width" type="text" value="<%=ResourceMap.get("remainingUnits")==null?"":ResourceMap.get("remainingUnits").toString()%>"/>&nbsp;</td>
			      <td class=""><input name="at_completion_units" class="input_width" type="text" value="<%=ResourceMap.get("atCompletionUnits")==null?"":ResourceMap.get("atCompletionUnits").toString()%>"/>&nbsp;</td>
			      <td class=""><input name="resource_type" class="input_width" type="text" value="<%=ResourceMap.get("resourceType")==null?"":ResourceMap.get("resourceType").toString()%>"/>&nbsp;</td>
			   </tr>
				<% 
					}	
				}
				%>
			</table>			
		</div>
		<div id="tab_box_content2" class="tab_box_content" style="display:none;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   <tr>
			      <td class="bt_info_odd">序号</td>
			      <td class="bt_info_even">作业分类码</td>
			      <td class="bt_info_odd">分类码值</td>
			      <td class="bt_info_even">分类码说明</td>
			   </tr>
			   <%if(CodeInfoList != null){ 
				Map<String,String> codeInfoMap = new HashMap<String,String>();
				for(int i=0;i<CodeInfoList.size();i++){
					codeInfoMap = ((MsgElement)CodeInfoList.get(i)).toMap();
				%>
				<tr>
			      <td class="bt_info_odd"><%= i+1 %>&nbsp;</td>
			      <td class=""><input name="codeTypeName" class="input_width" type="text" value="<%=codeInfoMap.get("codeTypeName")==null?"":codeInfoMap.get("codeTypeName").toString()%>"/>&nbsp;</td>
			      <td class=""><input name="codeValue" class="input_width" type="text" value="<%=codeInfoMap.get("codeValue")==null?"":codeInfoMap.get("codeValue").toString()%>"/>&nbsp;</td>
			      <td class=""><input name="codeDescription" class="input_width" type="text" value="<%=codeInfoMap.get("codeDescription")==null?"":codeInfoMap.get("codeDescription").toString()%>"/>&nbsp;</td>
			   </tr>
				<% 
					}	
				}
				%>
			</table>
		</div>
		<div id="tab_box_content3" class="tab_box_content" style="display:none;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   <tr>
			      <td class="bt_info_odd">序号</td>
			      <td class="bt_info_even">项目代码</td>
			      <td class="bt_info_odd">项目名称</td>
			      <td class="bt_info_even">作业代码</td>
			      <td class="bt_info_odd">作业名称</td>
			      <td class="bt_info_even">关系类型</td>	
			      <td class="bt_info_odd">延时</td>		      
			   </tr>
			   <%if(PredecessorRelationInfoList != null){ 
				String relationType = "";
				Map<String,String> relationMap = new HashMap<String,String>();
				for(int i=0;i<PredecessorRelationInfoList.size();i++){
					relationMap = ((MsgElement)PredecessorRelationInfoList.get(i)).toMap();
				%>
				<tr>
			      <td class="bt_info_odd"><%= i+1 %>&nbsp;</td>
			      <td class=""><input name="project_id" class="input_width" type="text" value="<%=relationMap.get("project_id")==null?"":relationMap.get("project_id").toString()%>"/>&nbsp;</td>
			      <td class=""><input name="project_name" class="input_width" type="text" value="<%=relationMap.get("project_name")==null?"":relationMap.get("project_name").toString()%>"/>&nbsp;</td>
			      <td class=""><input name="predecessorActivityId" class="input_width" type="text" value="<%=relationMap.get("predecessorActivityId")==null?"":relationMap.get("predecessorActivityId").toString()%>"/>&nbsp;</td>
			      <td class=""><input name="predecessorActivityName" class="input_width" type="text" value="<%=relationMap.get("predecessorActivityName")==null?"":relationMap.get("predecessorActivityName").toString()%>"/>&nbsp;</td>
			      <td class=""><input name="type" class="input_width" type="text" value="<%=relationMap.get("PredecessorRelationType")==null?"":relationMap.get("PredecessorRelationType").toString()%>"/>&nbsp;</td>
			      <td class=""><input name="PredecessororLag" class="input_width" type="text" value="<%=relationMap.get("PredecessororLag")==null?"":relationMap.get("PredecessororLag").toString()%>"/>天&nbsp;</td>
			   </tr>
				<% 
					}	
				}
				%>
			</table>
		</div>
		<div id="tab_box_content4" class="tab_box_content" style="display:none;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   <tr>
			      <td class="bt_info_odd">序号</td>
			      <td class="bt_info_even">项目代码</td>
			      <td class="bt_info_odd">项目名称</td>
			      <td class="bt_info_even">作业代码</td>
			      <td class="bt_info_odd">作业名称</td>
			      <td class="bt_info_even">关系类型</td>		
			      <td class="bt_info_odd">延时</td>		      
			   </tr>
			   <%if(SuccessorRelationInfoList != null){ 
				String relationType = "";
				Map<String,String> relationMap = new HashMap<String,String>();
				for(int i=0;i<SuccessorRelationInfoList.size();i++){
					relationMap = ((MsgElement)SuccessorRelationInfoList.get(i)).toMap();
				%>
				<tr>
			      <td class="bt_info_odd"><%= i+1 %>&nbsp;</td>
			      <td class=""><input name="project_id" class="input_width" type="text" value="<%=relationMap.get("project_id")==null?"":relationMap.get("project_id").toString()%>"/>&nbsp;</td>
			      <td class=""><input name="project_name" class="input_width" type="text" value="<%=relationMap.get("project_name")==null?"":relationMap.get("project_name").toString()%>"/>&nbsp;</td>
			      <td class=""><input name="successorActivityId" class="input_width" type="text" value="<%=relationMap.get("successorActivityId")==null?"":relationMap.get("successorActivityId").toString()%>"/>&nbsp;</td>
			      <td class=""><input name="successorActivityName" class="input_width" type="text" value="<%=relationMap.get("successorActivityName")==null?"":relationMap.get("successorActivityName").toString()%>"/>&nbsp;</td>
			      <td class=""><input name="type" class="input_width" type="text" value="<%=relationMap.get("SuccessorRelationType")==null?"":relationMap.get("SuccessorRelationType").toString()%>"/>&nbsp;</td>
			      <td class=""><input name="SuccessorLag" class="input_width" type="text" value="<%=relationMap.get("SuccessorLag")==null?"":relationMap.get("SuccessorLag").toString()%>"/>天&nbsp;</td>
			   </tr>
				<% 
					}	
				}
				%>
			</table>
		</div>
	</div>
</body>
<script type="text/javascript">

function frameSize(){

	var height = $(window).height()-$("#head").height()-$("#head_bot").height()-$("#mainTopframe").height();

	$("#tab_box").css("height",$(window).height()-$("#head").height()-$("#head_bot").height()-$("#mainTopframe").height()-60);

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

