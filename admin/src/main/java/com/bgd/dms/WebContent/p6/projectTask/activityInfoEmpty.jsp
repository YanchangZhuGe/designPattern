<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%
	String contextPath = request.getContextPath();
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

<body style="background:#cdddef; overflow-y: auto;">
	<div id="tag-container_3">
	  <ul id="tags" class="tags">
	    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">常用</a></li>
	    <li id="tag3_1"><a href="#" onclick="getTab3(1)">资源</a></li>
	    <li id="tag3_2"><a href="#" onclick="getTab3(2)">分类码</a></li>
	    <li id="tag3_3"><a href="#" onclick="getTab3(3)">紧前作业</a></li>
	    <li id="tag3_4"><a href="#" onclick="getTab3(4)">后续作业</a></li>
	  </ul>
	</div>
	
	<div id="tab_box" class="tab_box">
		<div id="tab_box_content0" class="tab_box_content">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   <tr>
			      <td class="inquire_item8">状态：</td>
			      <td class="inquire_form8"><input name="status" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class="inquire_item8">作业代码：</td>
			      <td class="inquire_form8"><input name="id" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class="inquire_item8">作业名称：</td>
			      <td class="inquire_form8"><input name="name" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class="inquire_item8">原定工期：</td>
			      <td class="inquire_form8"><input name="plannedDuration" class="input_width" type="text" value=""/>&nbsp;天</td>
			   </tr>
			   <tr>
			      <td class="inquire_item8">开始日期：</td>
			      <td class="inquire_form8"><input name="startDate" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class="inquire_item8">完工日期：</td>
			      <td class="inquire_form8"><input name="finishDate" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class="inquire_item8">预计开工日期：</td>
			      <td class="inquire_form8"><input name="plannedStartDate" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class="inquire_item8">预计完工日期：</td>
			      <td class="inquire_form8"><input name="plannedFinishDate" class="input_width" type="text" value=""/>&nbsp;</td>
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

				<tr>
			      <td class="bt_info_odd">1&nbsp;</td>
			      <td class=""><input name="resource_name" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class=""><input name="resource_id" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class=""><input name="budgeted_units" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class=""><input name="planned_units" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class=""><input name="actual_this_period_units" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class=""><input name="actual_units" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class=""><input name="remaining_units" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class=""><input name="at_completion_units" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class=""><input name="resource_type" class="input_width" type="text" value=""/>&nbsp;</td>
			   </tr>

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

				<tr>
			      <td class="bt_info_odd">1&nbsp;</td>
			      <td class=""><input name="codeTypeName" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class=""><input name="codeValue" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class=""><input name="codeDescription" class="input_width" type="text" value=""/>&nbsp;</td>
			   </tr>

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

				<tr>
			      <td class="bt_info_odd">1&nbsp;</td>
			      <td class=""><input name="project_id" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class=""><input name="project_name" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class=""><input name="predecessorActivityId" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class=""><input name="predecessorActivityName" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class=""><input name="type" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class=""><input name="PredecessororLag" class="input_width" type="text" value=""/>&nbsp;</td>
			   </tr>

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
				<tr>
			      <td class="bt_info_odd">1&nbsp;</td>
			      <td class=""><input name="project_id" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class=""><input name="project_name" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class=""><input name="successorActivityId" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class=""><input name="successorActivityName" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class=""><input name="type" class="input_width" type="text" value=""/>&nbsp;</td>
			      <td class=""><input name="SuccessorLag" class="input_width" type="text" value=""/>&nbsp;</td>
			   </tr>
			</table>
		</div>
	</div>
</body>

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

