<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="code" prefix="code"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page  import="java.util.*" %>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo == null || "".equals(projectInfoNo) || projectInfoNo == "null" || "null".equals(projectInfoNo)) {
		UserToken user = OMSMVCUtil.getUserToken(request);
		projectInfoNo = user.getProjectInfoNo();
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
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
<body>
<div id="new_table_box">
		<div id="new_table_box_content">
			<div id="new_table_box_bg">
				<div id="tag-container_3">
				  <ul id="tags" class="tags">
				    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
				    <li id="tag3_3"><a href="#" onclick="getTab3(3)">工区信息</a></li>
				    <li id="tag3_1"><a href="#" onclick="getTab3(1)">工作量</a></li>
				  </ul>
				</div>
				<div id="tab_box" class="tab_box" style="overflow: hidden;">
					<div id="tab_box_content0" class="tab_box_content">
						<table width="100%" id="tb_project" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td class="inquire_item4">项目名：</td>
								<td class="inquire_form4" id="item0_0">
								<input type="hidden" id="project_info_no" name="project_info_no" value="<%=projectInfoNo%>"/>
								<input type="text" id="project_name" name="project_name" value="" class="input_width" readonly="readonly"/>
								</td>
								<td class="inquire_item4">项目编号：</td>
								<td class="inquire_form4" id="item0_1"><input type="text" id="project_id" name="project_id" value="" class="input_width" readonly="readonly"/>
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">项目类型：</td>
								<td class="inquire_form4" id="item0_2">
									<select class=select_width name=project_type id='project_type' disabled="disabled">
										<option value='5000100004000000008'>井中项目</option>
										<option value='5000100004000000001'>陆地项目</option>
										<option value='5000100004000000007'>陆地和浅海项目</option>
										<option value='5000100004000000009'>综合物化探</option>
										<option value='5000100004000000010'>滩浅海地震</option>
										<option value='5000100004000000005'>地震项目</option>
										<option value='5000100004000000002'>浅海项目</option>
										<option value='5000100004000000003'>非地震项目</option>
										<option value='5000100004000000006'>深海项目</option>
									</select>
								</td>
								<td class="inquire_item4">项目状态：</td>
								<td class="inquire_form4" id="item0_3">
									<select name="project_status" id="project_status" class="select_width" disabled="disabled">
										<option value="5000100001000000001">项目启动</option>
										<option value="5000100001000000002">正在施工</option>
										<option value="5000100001000000003">项目结束</option>
										<option value="5000100001000000004">项目暂停</option>
										<option value="5000100001000000005">施工结束</option>
									</select>
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">市场范围：</td>
								<td class="inquire_form4" id="item0_4">
									<input id="market_classify" name="market_classify" value="" type="hidden" class="input_width" />
									<input id="market_classify_name" name="market_classify_name" value="" type="text" class="input_width" readonly="readonly"/>
								</td>
								<td class="inquire_item4">年度：</td>
								<td class="inquire_form4" id="item0_5">
									    <select id="project_year" name="project_year" class="select_width" disabled="disabled">
									    <%
									    Date date = new Date();
									    int years = date.getYear()+ 1900 - 10;
									    int year = date.getYear()+1900;
									    for(int i=0; i<20; i++){
									    %>
									    <option value="<%=years %>" <%	if(years == year) {  %> selected="selected" <% } %> > <%=years %> </option>
									    <%
									    years++;
									    }
									     %>
									    </select>
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">计划开始时间：</td>
								<td class="inquire_form4" id="item0_6">
									<input type="text" id="acquire_start_time" name="acquire_start_time" value="" class="input_width" readonly="readonly"/>
									<%-- &nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acquire_start_time,tributton1);" /> --%>
								</td>
								<td class="inquire_item4">计划结束时间：</td>
								<td class="inquire_form4" id="item0_7">
									<input type="text" id="acquire_end_time" name="acquire_end_time" value="" class="input_width" readonly="readonly"/>
									<%-- &nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acquire_end_time,tributton2);" /> --%>
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">项目重要程度：</td>
								<td class="inquire_form4" id="item0_8"><code:codeSelect cssClass="select_width" name='is_main_project' option="isMainProject" selectedValue="" addAll="true" /></td>
								<td class="inquire_item4">勘探方法：</td>
								<td class="inquire_form4" id="item0_11">
									<input id="exploration_method" name="exploration_method" value="" type="hidden" class="input_width" />
									<input id="exploration_method_name" name="exploration_method_name" value="" type="text" class="input_width" readonly="readonly"/>
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">国内/国外：</td>
								<td class="inquire_form4" id="item0_12">
									<select class=select_width name=project_country id="project_country" disabled='disabled'>
											<option value="1">国内</option>
											<option value="2">国外</option>
									</select>
								</td>
								<td class="inquire_item4">甲方单位：</td>
								<td class="inquire_form4" id="item0_13">
									<input id="manage_org" name="manage_org" value="" type="hidden" class="input_width" />
									<input id="manage_org_name" name="manage_org_name" value="" type="text" class="input_width" readonly="readonly"/>
					    			<%-- <img src="<%= request.getContextPath() %>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectCoding('0100100014','manage_org','manage_org_name');" /> --%>
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">勘探类型：</td>
								<td class="inquire_form4" id="item0_14">
									<code:codeSelect cssClass="select_width"  name='explore_type' option="exploreTypeWT"  selectedValue=""  addAll="true" />
								</td>
								<td class="inquire_item4">资料处理单位：</td>
								<td class="inquire_form4" id="item0_15">
									<input type="hidden" id="bgp_report_no" name="bgp_report_no"/>
									<input type="text" id="processing_unit" name="processing_unit" class="input_width" readonly="readonly"/>
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">施工队伍：</td>
								<td class="inquire_form4" id="item0_19">
									<input id="org_id" name="org_id" value="" type="hidden" class="input_width" />
									<input id="org_name" name="org_name" value="" type="text" class="input_width" readonly="readonly"/>
								</td>
								<td class="inquire_item4">项目业务类型：</td>
								<td class="inquire_form4" id="item0_17">
									<code:codeSelect cssClass="select_width" name='project_business_type' option="projectBusinessType" selectedValue="" addAll="true" />
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">利润中心：</td>
								<td class="inquire_form4" id="item0_18">
									<input type="hidden" id="prctr" name="prctr" value="" class="input_width" />
									<input type="text" id="prctr_name" name="prctr_name" value="" class="input_width" readonly="readonly"/>
								</td>
								<td class="inquire_item4">观测方法：</td>
								<td class="inquire_form4"><code:codeSelect cssClass="select_width"  name='view_type' option="viewTypeWT"  selectedValue=""  addAll="true" /></td>
							</tr>
							<tr>
								<td class="inquire_item4">项目投资：</td>
								<td class="inquire_form4"><input type="text" id="project_cost" name="project_cost" value="" class="input_width" readonly="readonly"/>万元
								</td>
								<td class="inquire_item4">项目负责人：</td>
								<td class="inquire_form4"><input type="text" id="project_man" name="project_man" value="" class="input_width" readonly="readonly"/>
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">项目部：</td>
								<td class="inquire_form4"><code:codeSelect cssClass="select_width"  name='project_department' option="projectDepartment"  selectedValue=""  addAll="true" />
								</td>
								<td class="inquire_item4">比例尺：</td>
								<td class="inquire_form4"><code:codeSelect cssClass="select_width"  name='scale' option="scale"  selectedValue=""  addAll="true" />
								</td>
							</tr>
						</table>
					</div>
					
					<div id="tab_box_content1" class="tab_box_content" style="display:none;">
		             <form action="" id="workloadForm" name="workloadForm" method="post">
						 <table id="tbWorkload"  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						 	  <tr class="bt_info_odd"><td colspan="6" id="mapNameId0" ><font size="2">测量</font></td></tr>
							  <tr>
							    <td>测线：</td>
							    <td>
							    	<input type="hidden" id="num" name="num" value="" />
							    	<input type="hidden" value="5110000056000000045" id="exploration_method_cl" name="exploration_method_cl" class="input_width"/>
							        <input type="hidden" id="workload_id" name="workload_id" class="input_width"/>
								  	<input type="text" id="line_num" name="line_num" class="input_width" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')"/>条</td>
							    <td>测线长度/测区面积：</td>
							    <td><input type="text" id="line_length" name="line_length" class="input_width" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"/></td>
							    <td>单位：</td>
							    <td>
								    <select class='select_width' name='line_unit' id='line_unit'>
										<option value='1'>m</option>
										<option value='2'>km</option>
										<option value='3'>m&sup2</option>
										<option value='4'>km&sup2</option>
									</select>
							    </td>
							  </tr>
							   <tr>
							    <td>坐标点：</td>
							    <td><input type="text" id="location_point" name="location_point" class="input_width" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"/>个</td>
							    <td>复测点：</td>
							    <td><input type="text" id="repeat_point" name="repeat_point" class="input_width" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"/>个</td>
							    <td></td>
							    <td></td>
							  </tr>
						  </table>
						</form>
					</div>

					<form action="" id="workareaForm" name="workareaForm" method="post">
					<div id="tab_box_content3" class="tab_box_content" style="display:none;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						    <tr>
						      <td class="inquire_item6"><span class="red_star">*</span>工区名称：</td>
						      <td class="inquire_form6"><input id="workarea_no" name="workarea_no"type="hidden" /><input id="workarea"  name="workarea"class="input_width" type="text" /><input id="start_year" name="start_year" class="input_width" type="hidden" /></td>
						      <td class="inquire_item6">盆地：</td>
						      <td class="inquire_form6"><input id="basin" name="basin" class="input_width" type="text" /></td>
						      <td class="inquire_item6">区块（矿权）：</td>
						      <td class="inquire_form6" >
						      	<input name="block" id="block" value="" type="hidden" class="input_width" />
						      	<input id="spare2"  name="spare2"class="input_width" type="text"  readonly="readonly"/>
						      	&nbsp;&nbsp;<img src="<%= request.getContextPath() %>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectCoding('0300100011','block','spare2');" />
						      </td>
						    </tr>
						    <tr>
						      <td class="inquire_item6"><span class="red_star">*</span>所属行政区:</td>
						      <td class="inquire_form6"><input id="region_name"  name="region_name"class="input_width" type="text" /></td>
						      <td class="inquire_item6">主要地表类型：</td>
						      <td class="inquire_form6" ><select id="surface_type" name="surface_type" class="select_width"></select></td>
						      <td class="inquire_item6">次要地表类型:</td>
						      <td class="inquire_form6"><select id="second_surface_type" name="second_surface_type" class="select_width"></select></td>
						     </tr>
						     <tr>
						      <td class="inquire_item6">一级构造单元:</td>
					      <td class="inquire_form6"><input id="struct_unit_first"  name="struct_unit_first" class="input_width" type="text" /></td>
					      <td class="inquire_item6">二级构造单元：</td>
					      <td class="inquire_form6" ><input id="struct_unit_second"  name="struct_unit_second" class="input_width" type="text" /></td>
						      <td class="inquire_item6"><span class="red_star">*</span>工区中心经度:</td>
						      <td class="inquire_form6"><input id="focus_x"  name="focus_x" class="input_width" type="text" /></td>
						     </tr>
						     <tr>
						      <td class="inquire_item6"><span class="red_star">*</span>工区中心纬度:</td>
						      <td class="inquire_form6"><input id="focus_y"  name="focus_y" class="input_width" type="text" /></td>
						      <td class="inquire_item6"><span class="red_star">*</span>作物区类型：</td>
						      <td class="inquire_form6" ><select id="crop_area_type" name="crop_area_type" class="select_width"></select></td>
						      <td class="inquire_item6"><span class="red_star">*</span>国家:</td>
						      <td class="inquire_form6">
						      	<input id="country"  name="country" class="input_width" type="hidden" />
						      	<input id="country_name"  name="country_name" class="input_width" type="text"  readonly="readonly"/>
						      	&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectCoding('0200100001','country','country_name');" />
						      </td>
						     </tr>
						</table>
					</div>
					</form>
					
				</div>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
var showTabBox = document.getElementById("tab_box_content0");

cruConfig.contextPath = "<%=contextPath%>";
cruConfig.cdtType = 'form';
//debugger;
var expMethod = "";
var num=0;
var retObj = jcdpCallService("WtProjectSrv", "getProjectInfo", "projectInfoNo=<%=projectInfoNo%>");
document.getElementById("project_info_no").value= retObj.map.project_info_no;
document.getElementById("project_name").value= retObj.map.project_name;
document.getElementById("project_id").value= retObj.map.project_id;
document.getElementById("project_year").value= retObj.map.project_year;
document.getElementById("acquire_start_time").value= retObj.map.acquire_start_time;
document.getElementById("acquire_end_time").value= retObj.map.acquire_end_time;
document.getElementById("prctr_name").value= retObj.map.prctr_name;
document.getElementById("prctr").value= retObj.map.prctr;
document.getElementById("manage_org_name").value= retObj.map.manage_org_name;
document.getElementById("manage_org").value= retObj.map.manage_org;
document.getElementById("market_classify_name").value= retObj.map.market_classify_name;
document.getElementById("market_classify").value= retObj.map.market_classify;
document.getElementById("org_name").value= retObj.dynamicMap.org_name;
document.getElementById("project_cost").value= retObj.map.project_cost;
document.getElementById("project_man").value= retObj.map.project_man;
document.getElementById("project_department").value= retObj.map.project_department;
document.getElementById("exploration_method").value= retObj.dynamicMap.exploration_method;
document.getElementById("exploration_method_name").value= retObj.dynamicMap.exploration_method_name;

var workarea_no = retObj.map.workarea_no;

if( retObj.bgpMap != null && retObj.bgpMap.bgp_report_no != null) {
	document.getElementById("bgp_report_no").value= retObj.bgpMap.bgp_report_no;
	document.getElementById("processing_unit").value= retObj.bgpMap.processing_unit;
}

var sel = document.getElementById("project_type").options;
var value = retObj.map.project_type;
for(var i=0;i<sel.length;i++)
{
    if(value==sel[i].value)
    {
       document.getElementById('project_type').options[i].selected=true;
    }
}

sel = document.getElementById("project_status").options;
value = retObj.map.project_status;
for(var i=0;i<sel.length;i++)
{
    if(value==sel[i].value)
    {
       document.getElementById('project_status').options[i].selected=true;
    }
}

sel = document.getElementById("scale").options;
value = retObj.map.scale;
for(var i=0;i<sel.length;i++)
{
    if(value==sel[i].value)
    {
       document.getElementById('scale').options[i].selected=true;
    }
}

sel = document.getElementById("view_type").options;
value = retObj.map.view_type;
for(var i=0;i<sel.length;i++)
{
    if(value==sel[i].value)
    {
       document.getElementById('view_type').options[i].selected=true;
    }
}
sel = document.getElementsByName("project_business_type")[0].options;
value = retObj.map.project_business_type;
for(var i=0;i<sel.length;i++)
{
    if(value==sel[i].value)
    {
       document.getElementsByName('project_business_type')[0].options[i].selected=true;
    }
}
sel = document.getElementsByName("is_main_project")[0].options;
value = retObj.map.is_main_project;
for(var i=0;i<sel.length;i++)
{
    if(value==sel[i].value)
    {
       document.getElementsByName('is_main_project')[0].options[i].selected=true;
    }
}
sel = document.getElementById("project_country").options;
value = retObj.map.project_country;
for(var i=0;i<sel.length;i++)
{
    if(value==sel[i].value)
    {
       document.getElementById('project_country').options[i].selected=true;
    }
}
sel = document.getElementById("explore_type").options;
value = retObj.map.explore_type;
for(var i=0;i<sel.length;i++)
{
    if(value==sel[i].value)
    {
       document.getElementById('explore_type').options[i].selected=true;
    }
}

//--------------------------------------------工作量信息--------------------------------------------
num=0;
for(var i=0;i<retObj.workloadMap.length;i++){
	var exploration_method=retObj.workloadMap==null?"":retObj.workloadMap[i].exploration_method;
	var mapName=retObj.workloadMap==null?"":retObj.workloadMap[i].exploration_method_name;
	var mapCode=retObj.workloadMap==null?"":retObj.workloadMap[i].superior_code_id;
	var workload_id=retObj.workloadMap==null?"":retObj.workloadMap[i].workload_id;
	var line_num=retObj.workloadMap==null?"":retObj.workloadMap[i].line_num;
	var line_length=retObj.workloadMap==null?"":retObj.workloadMap[i].line_length;
	var line_unit=retObj.workloadMap==null?"":retObj.workloadMap[i].line_unit;
	var location_point=retObj.workloadMap==null?"":retObj.workloadMap[i].location_point;
	var repeat_point=retObj.workloadMap==null?"":retObj.workloadMap[i].repeat_point;
	var point_distance=retObj.workloadMap==null?"":retObj.workloadMap[i].point_distance;
	var line_distance=retObj.workloadMap==null?"":retObj.workloadMap[i].line_distance;
	var base_length=retObj.workloadMap==null?"":retObj.workloadMap[i].base_length;
	var gravity_point=retObj.workloadMap==null?"":retObj.workloadMap[i].gravity_point;
	var check_point=retObj.workloadMap==null?"":retObj.workloadMap[i].check_point;
	var physics_point=retObj.workloadMap==null?"":retObj.workloadMap[i].physics_point;
	var well_point=retObj.workloadMap==null?"":retObj.workloadMap[i].well_point;

	//重力
	if("5110000056000000001"==mapCode){
		addRow1(mapName,workload_id,exploration_method,line_num,line_length,line_unit,location_point,repeat_point,point_distance,line_distance,base_length,gravity_point,check_point,physics_point,well_point);
	}
	//磁力
	else if("5110000056000000002"==mapCode){
		addRow2(mapName,workload_id,exploration_method,line_num,line_length,line_unit,location_point,repeat_point,point_distance,line_distance,base_length,gravity_point,check_point,physics_point,well_point);
	}
	//天然场源电磁法
	else if("5110000056000000003"==mapCode){
		addRow3(mapName,workload_id,exploration_method,line_num,line_length,line_unit,location_point,repeat_point,point_distance,line_distance,base_length,gravity_point,check_point,physics_point,well_point);
	}
	//人工场源电磁法
	else if("5110000056000000004"==mapCode){
		addRow2(mapName,workload_id,exploration_method,line_num,line_length,line_unit,location_point,repeat_point,point_distance,line_distance,base_length,gravity_point,check_point,physics_point,well_point);
	}
	//化探
	else if("5110000056000000005"==exploration_method){
		addRow2(mapName,workload_id,exploration_method,line_num,line_length,line_unit,location_point,repeat_point,point_distance,line_distance,base_length,gravity_point,check_point,physics_point,well_point);
	}
	//工程勘探
	else if("5110000056000000006"==mapCode){
		addRow4(mapName,workload_id,exploration_method,line_num,line_length,line_unit,location_point,repeat_point,point_distance,line_distance,base_length,gravity_point,check_point,physics_point,well_point);
	}else if("5110000056000000045"==exploration_method){//测量
		document.getElementById("workload_id").value=workload_id;
		document.getElementById("exploration_method_cl").value=exploration_method;
		document.getElementById("line_num").value=line_num;
		document.getElementById("line_length").value=line_length;
		document.getElementById("line_unit").value=line_unit;
		document.getElementById("location_point").value=location_point;
		document.getElementById("repeat_point").value=repeat_point;
	}
}
document.getElementById("num").value=num;
//调整样式
addTdCss("tbWorkload","#mapNameId",num);


var retObj = jcdpCallService("WorkAreaSrv", "getSurfaceType", "");
var retCrop = jcdpCallService("WorkAreaSrv", "getCropreaType", "");
var selectTag = document.getElementById("surface_type");
var selectTag2 = document.getElementById("second_surface_type");
var selectTag3 = document.getElementById("crop_area_type");
if(retObj.surfaceType != null){
	for(var i=0;i<retObj.surfaceType.length;i++){
		var record = retObj.surfaceType[i];
		var item = new Option(record.coding_name.replace(/\-/g," "),record.coding_code_id);
		var item2 = new Option(record.coding_name.replace(/\-/g," "),record.coding_code_id);
		selectTag.add(item);
		selectTag2.add(item2);
	}
}
if(retCrop.cropAreaType != null){
	for(var i=0;i<retCrop.cropAreaType.length;i++){
		var record = retCrop.cropAreaType[i];
		var item = new Option(record.coding_name.replace(/\-/g," "),record.coding_code_id);
		selectTag3.add(item);
	}
}

//工区信息
if(workarea_no != null && workarea_no != ""){
	var retWorkArea = jcdpCallService("WorkAreaSrv", "getWorkarea", "workareaNo="+workarea_no);
	document.getElementById("workarea_no").value = workarea_no;
	document.getElementById("workarea").value = retWorkArea.workarea.workarea;
	document.getElementById("start_year").value = retWorkArea.workarea.start_year;
	document.getElementById("basin").value = retWorkArea.workarea.basin;
	document.getElementById("spare2").value = retWorkArea.workarea.spare2;
	document.getElementById("region_name").value = retWorkArea.workarea.region_name;
	document.getElementById("struct_unit_first").value = retWorkArea.workarea.struct_unit_first;
	document.getElementById("struct_unit_second").value = retWorkArea.workarea.struct_unit_second;

	
	document.getElementById("focus_x").value = retWorkArea.workarea.focus_x;
	document.getElementById("focus_y").value = retWorkArea.workarea.focus_y;
	document.getElementById("block").value = retWorkArea.workarea.block;
	document.getElementById("country").value = retWorkArea.workarea.country;
	document.getElementById("country_name").value = retWorkArea.workarea.country_name;
	sel = document.getElementById("surface_type").options;
	value = retWorkArea.workarea.surface_type;
	for(var i=0;i<sel.length;i++)
	{
    	if(value==sel[i].value)
    	{
       		document.getElementById('surface_type').options[i].selected=true;
    	}
	}
	sel = document.getElementById("second_surface_type").options;
	value = retWorkArea.workarea.second_surface_type;
	for(var i=0;i<sel.length;i++)
	{
    	if(value==sel[i].value)
    	{
     	  	document.getElementById('second_surface_type').options[i].selected=true;
    	}
	}
	sel = document.getElementById("crop_area_type").options;
	value = retWorkArea.workarea.crop_area_type;
	for(var i=0;i<sel.length;i++)
	{
    	if(value==sel[i].value)
    	{
      	 	document.getElementById('crop_area_type').options[i].selected=true;
    	}
	}
}

function selectCoding(codingSortId,objId,objName){
	var obj = new Object();
	obj.fkValue="";
	obj.value="";
	var resObj = window.showModalDialog('<%=contextPath%>/pm/workarea/selectcode.jsp?codeSort='+codingSortId,window);
	if(objId!=""){
		document.getElementById(objId).value = resObj.fkValue;
	}
	document.getElementById(objName).value = resObj.value;
}

function addRow1(mapName,workload_id,exploration_method,line_num,line_length,line_unit,location_point,repeat_point,point_distance,line_distance,base_length,gravity_point,check_point,physics_point,well_point){
	++num;
	//插入第一行标题
	var tr0=document.all.tbWorkload.insertRow();
	tr0.className = "bt_info_odd";
	var td0 = tr0.insertCell(0);
	td0.setAttribute("colspan",6);
	td0.setAttribute("id", "mapNameId"+num);
	td0.innerHTML="<font size='2'>"+mapName+"</font></td>";
	var tr=document.all.tbWorkload.insertRow();
  	tr.insertCell(0).innerHTML="<input type='hidden' id='workload_id_"+num+"' name='workload_id_"+num+"' value='"+workload_id+"'/>"+
  	"<input type='hidden' value='"+exploration_method+"' id='exploration_method_"+num+"' name='exploration_method_"+num+"'/>测线：";
  	tr.insertCell(1).innerHTML="<input class='input_width' type='text' id='line_num_"+num+"' name='line_num_"+num+"' value='"+line_num+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>条";
  	tr.insertCell(2).innerHTML="勘探面积/剖面长度：";
  	tr.insertCell(3).innerHTML="<input class='input_width' type='text' id='line_length_"+num+"' name='line_length_"+num+"' value='"+line_length+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>";
  	tr.insertCell(4).innerHTML="单位：";
  	tr.insertCell(5).innerHTML="<select class='select_width' name='line_unit_"+num+"' id='line_unit_"+num+"'><option value='1'>m</option><option value='2'>km</option><option value='3'>m&sup2</option><option value='4'>km&sup2</option></select>";
  	var tr1=document.all.tbWorkload.insertRow();
  	tr1.insertCell(0).innerHTML="点距：";
  	tr1.insertCell(1).innerHTML="<input class='input_width' type='text' id='point_distance_"+num+"' name='point_distance_"+num+"' value='"+point_distance+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>km";
  	tr1.insertCell(2).innerHTML="线距：";
  	tr1.insertCell(3).innerHTML="<input class='input_width' type='text' id='line_distance_"+num+"' name='line_distance_"+num+"' value='"+line_distance+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>km";
  	tr1.insertCell(4).innerHTML="基线长度：";
  	tr1.insertCell(5).innerHTML="<input class='input_width' type='text' id='base_length_"+num+"' name='base_length_"+num+"' value='"+base_length+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>km";
  	var tr2=document.all.tbWorkload.insertRow();
  	tr2.insertCell(0).innerHTML="重力基点：";
  	tr2.insertCell(1).innerHTML="<input class='input_width' type='text' id='gravity_point_"+num+"' name='gravity_point_"+num+"' value='"+gravity_point+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>个";
  	tr2.insertCell(2).innerHTML="坐标点：";
  	tr2.insertCell(3).innerHTML="<input class='input_width' type='text' id='location_point_"+num+"' name='location_point_"+num+"' value='"+location_point+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>个";
  	tr2.insertCell(4).innerHTML="检查点：";
  	tr2.insertCell(5).innerHTML="<input class='input_width' type='text' id='check_point_"+num+"' name='check_point_"+num+"' value='"+check_point+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>个";
  	var tr3=document.all.tbWorkload.insertRow();
  	tr3.insertCell(0).innerHTML="物理点：";
  	tr3.insertCell(1).innerHTML="<input class='input_width' type='text' id='physics_point_"+num+"' name='physics_point_"+num+"' value='"+physics_point+"'/>个";
  	document.getElementById("line_unit_"+num).value=line_unit;
}

function addRow2(mapName,workload_id,exploration_method,line_num,line_length,line_unit,location_point,repeat_point,point_distance,line_distance,base_length,gravity_point,check_point,physics_point,well_point){
	++num;
	//插入第一行标题
	var tr0=document.all.tbWorkload.insertRow();
	tr0.className = "bt_info_odd";
	var td0 = tr0.insertCell(0);
	td0.setAttribute("colspan",6);
	td0.setAttribute("id", "mapNameId"+num);
	td0.innerHTML="<font size='2'>"+mapName+"</font></td>";
	var tr=document.all.tbWorkload.insertRow();
  	tr.insertCell(0).innerHTML="<input type='hidden' id='workload_id_"+num+"' name='workload_id_"+num+"' value='"+workload_id+"'/>"+
  	"<input type='hidden' value='"+exploration_method+"' id='exploration_method_"+num+"' name='exploration_method_"+num+"'/>测线：";
  	tr.insertCell(1).innerHTML="<input class='input_width' type='text' id='line_num_"+num+"' name='line_num_"+num+"' value='"+line_num+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>条";
  	tr.insertCell(2).innerHTML="勘探面积/剖面长度：";
  	tr.insertCell(3).innerHTML="<input  class='input_width' type='text' id='line_length_"+num+"' name='line_length_"+num+"' value='"+line_length+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>";
  	tr.insertCell(4).innerHTML="单位：";
  	tr.insertCell(5).innerHTML="<select class='select_width' name='line_unit_"+num+"' id='line_unit_"+num+"'><option value='1'>m</option><option value='2'>km</option><option value='3'>m&sup2</option><option value='4'>km&sup2</option></select>";
  	var tr1=document.all.tbWorkload.insertRow();
  	tr1.insertCell(0).innerHTML="点距：";
  	tr1.insertCell(1).innerHTML="<input class='input_width' type='text' id='point_distance_"+num+"' name='point_distance_"+num+"' value='"+point_distance+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>km";
  	tr1.insertCell(2).innerHTML="线距：";
  	tr1.insertCell(3).innerHTML="<input class='input_width' type='text' id='line_distance_"+num+"' name='line_distance_"+num+"' value='"+line_distance+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>km";
  	tr1.insertCell(4).innerHTML="坐标点：";
  	tr1.insertCell(5).innerHTML="<input class='input_width' type='text' id='location_point_"+num+"' name='location_point_"+num+"' value='"+location_point+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>个";
  	var tr2=document.all.tbWorkload.insertRow();
  	tr2.insertCell(0).innerHTML="检查点：";
  	tr2.insertCell(1).innerHTML="<input class='input_width' type='text' id='check_point_"+num+"' name='check_point_"+num+"' value='"+check_point+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>个";
  	tr2.insertCell(2).innerHTML="物理点：";
  	tr2.insertCell(3).innerHTML="<input class='input_width' type='text' id='physics_point_"+num+"' name='physics_point_"+num+"' value='"+physics_point+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>个";
  	document.getElementById("line_unit_"+num).value=line_unit;
}

function addRow3(mapName,workload_id,exploration_method,line_num,line_length,line_unit,location_point,repeat_point,point_distance,line_distance,base_length,gravity_point,check_point,physics_point,well_point){
	++num;
	//插入第一行标题
	var tr0=document.all.tbWorkload.insertRow();
	tr0.className = "bt_info_odd";
	var td0 = tr0.insertCell(0);
	td0.setAttribute("colspan",6);
	td0.setAttribute("id", "mapNameId"+num);
	td0.innerHTML="<font size='2'>"+mapName+"</font></td>";
	var tr=document.all.tbWorkload.insertRow();
  	tr.insertCell(0).innerHTML="<input type='hidden' id='workload_id_"+num+"' name='workload_id_"+num+"' value='"+workload_id+"'/>"+
  	"<input type='hidden' value='"+exploration_method+"' id='exploration_method_"+num+"' name='exploration_method_"+num+"'/>测线：";
  	tr.insertCell(1).innerHTML="<input class='input_width' type='text' id='line_num_"+num+"' name='line_num_"+num+"' value='"+line_num+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>条";
  	tr.insertCell(2).innerHTML="勘探面积/剖面长度：";
  	tr.insertCell(3).innerHTML="<input class='input_width' type='text' id='line_length_"+num+"' name='line_length_"+num+"' value='"+line_length+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>";
  	tr.insertCell(4).innerHTML="单位：";
  	tr.insertCell(5).innerHTML="<select class='select_width' name='line_unit_"+num+"' id='line_unit_"+num+"'><option value='1'>m</option><option value='2'>km</option><option value='3'>m&sup2</option><option value='4'>km&sup2</option></select>";
  	var tr1=document.all.tbWorkload.insertRow();
  	tr1.insertCell(0).innerHTML="点距：";
  	tr1.insertCell(1).innerHTML="<input class='input_width' type='text' id='point_distance_"+num+"' name='point_distance_"+num+"' value='"+point_distance+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>km";
  	tr1.insertCell(2).innerHTML="线距：";
  	tr1.insertCell(3).innerHTML="<input class='input_width' type='text' id='line_distance_"+num+"' name='line_distance_"+num+"' value='"+line_distance+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>km";
  	tr1.insertCell(4).innerHTML="坐标点：";
  	tr1.insertCell(5).innerHTML="<input class='input_width' type='text' id='location_point_"+num+"' name='location_point_"+num+"' value='"+location_point+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>个";
  	var tr2=document.all.tbWorkload.insertRow();
  	tr2.insertCell(0).innerHTML="井旁测深点：";
  	tr2.insertCell(1).innerHTML="<input class='input_width' type='text' id='well_point_"+num+"' name='well_point_"+num+"' value='"+well_point+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>个";
  	tr2.insertCell(2).innerHTML="检查点：";
  	tr2.insertCell(3).innerHTML="<input class='input_width' type='text' id='check_point_"+num+"' name='check_point_"+num+"' value='"+check_point+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>个";
  	tr2.insertCell(4).innerHTML="物理点：";
  	tr2.insertCell(5).innerHTML="<input class='input_width' type='text' id='physics_point_"+num+"' name='physics_point_"+num+"' value='"+physics_point+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>个";
  	document.getElementById("line_unit_"+num).value=line_unit;
}

function addRow4(mapName,workload_id,exploration_method,line_num,line_length,line_unit,location_point,repeat_point,point_distance,line_distance,base_length,gravity_point,check_point,physics_point,well_point){
	++num;
	//插入第一行标题
	var tr0=document.all.tbWorkload.insertRow();
	tr0.className = "bt_info_odd";
	var td0 = tr0.insertCell(0);
	td0.setAttribute("colspan",6);
	td0.setAttribute("id", "mapNameId"+num);
	td0.innerHTML="<font size='2'>"+mapName+"</font></td>";
	var tr=document.all.tbWorkload.insertRow();
  	tr.insertCell(0).innerHTML="<input type='hidden' id='workload_id_"+num+"' name='workload_id_"+num+"' value='"+workload_id+"'/>"+
  	"<input type='hidden' value='"+exploration_method+"' id='exploration_method_"+num+"' name='exploration_method_"+num+"'/>测线：";
  	tr.insertCell(1).innerHTML="<input class='input_width' type='text' id='line_num_"+num+"' name='line_num_"+num+"' value='"+line_num+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>条";
  	tr.insertCell(2).innerHTML="勘探面积/剖面长度：";
  	tr.insertCell(3).innerHTML="<input class='input_width' type='text' id='line_length_"+num+"' name='line_length_"+num+"' value='"+line_length+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>";
  	tr.insertCell(4).innerHTML="单位：";
  	tr.insertCell(5).innerHTML="<select class='select_width' name='line_unit_"+num+"' id='line_unit_"+num+"'><option value='1'>m</option><option value='2'>km</option><option value='3'>m&sup2</option><option value='4'>km&sup2</option></select>";
  	var tr1=document.all.tbWorkload.insertRow();
  	tr1.insertCell(0).innerHTML="点距：";
  	tr1.insertCell(1).innerHTML="<input class='input_width' type='text' id='point_distance_"+num+"' name='point_distance_"+num+"' value='"+point_distance+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>km";
  	tr1.insertCell(2).innerHTML="线距：";
  	tr1.insertCell(3).innerHTML="<input class='input_width' type='text' id='line_distance_"+num+"' name='line_distance_"+num+"' value='"+line_distance+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>km";
  	tr1.insertCell(4).innerHTML="坐标点：";
  	tr1.insertCell(5).innerHTML="<input class='input_width' type='text' id='location_point_"+num+"' name='location_point_"+num+"' value='"+location_point+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>个";
  	var tr2=document.all.tbWorkload.insertRow();
  	tr2.insertCell(0).innerHTML="检查点：";
  	tr2.insertCell(1).innerHTML="<input class='input_width' type='text' id='check_point_"+num+"' name='check_point_"+num+"' value='"+check_point+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>个";
  	tr2.insertCell(2).innerHTML="物理点：";
  	tr2.insertCell(3).innerHTML="<input class='input_width' type='text' id='physics_point_"+num+"' name='physics_point_"+num+"' value='"+physics_point+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>个";
  	tr2.insertCell(4).innerHTML="重力基点：";
  	tr2.insertCell(5).innerHTML="<input class='input_width' type='text' id='gravity_point_"+num+"' name='gravity_point_"+num+"' value='"+gravity_point+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>个";
  	var tr3=document.all.tbWorkload.insertRow();
  	tr3.insertCell(0).innerHTML="井旁测深点：";
  	tr3.insertCell(1).innerHTML="<input class='input_width' type='text' id='well_point_"+num+"' name='well_point_"+num+"' value='"+well_point+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>个";
  	document.getElementById("line_unit_"+num).value=line_unit;
}

$("#tb_project input[type=text]").attr("readonly","readonly");
$("#is_main_project").attr("disabled","disabled");
$("#explore_type").attr("disabled","disabled");
$("#project_department").attr("disabled","disabled");
$("#view_type").attr("disabled","disabled");
$("#scale").attr("disabled","disabled");
$("#project_business_type").attr("disabled","disabled");


//奇偶列样式
function addTdCss(table,mapName,num){
	var table = document.getElementById(table);
  	var tbody = table.getElementsByTagName("tbody")[0];
  	for(var m=0;m<tbody.getElementsByTagName("tr").length;m++){
  		var td=tbody.getElementsByTagName("tr")[m].getElementsByTagName("td");
		for(var i=0; i<td.length;i++){
	  		if(i%2==0){
	  			td[i].setAttribute("class", "inquire_item6");
	  		}
	  	}
	}
	for(var i=0;i<=num;i++){
		$(mapName+i).attr("class","inquire_form6");
	}
}
</script>
</html>