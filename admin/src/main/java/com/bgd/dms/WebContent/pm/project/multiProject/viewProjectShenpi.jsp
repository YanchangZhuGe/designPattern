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
			<div id="new_table_box_bg" style="overflow: hidden;">
				<div id="tag-container_3">
				  <ul id="tags" class="tags">
				    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
				    <li id="tag3_3"><a href="#" onclick="getTab3(3)">工区信息</a></li>
				    <li id="tag3_1"><a href="#" onclick="getTab3(1)">工作量</a></li>
				    <li id="tag3_7"><a href="#" onclick="getTab3(7)">地质任务</a></li>
				    <li id="tag3_2"><a href="#" onclick="getTab3(2)">质量指标</a></li>
				  </ul>
				</div>
				<div id="tab_box" class="tab_box" style="overflow: hidden;">
					<div id="tab_box_content0" class="tab_box_content">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<!-- 
							<tr>
								<td class="inquire_item4">EPS：</td>
								<td class="inquire_form4" colspan="3"><input type="text" id="eps" name="eps" value="" class="input_width" /></td>
							</tr>
						 -->
							<tr>
								<td class="inquire_item4">项目名：</td>
								<td class="inquire_form4" id="item0_0"><input type="text" id="project_name" name="project_name" value="" class="input_width" />
								</td>
								<td class="inquire_item4">项目编号：</td>
								<td class="inquire_form4" id="item0_1"><input type="text" id="project_id" name="project_id" value="" class="input_width" />
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">项目类型：</td>
								<td class="inquire_form4" id="item0_2">
									<select class=select_width name=project_type id='project_type'>
										<option value='5000100004000000001'>陆地项目</option>
										<option value='5000100004000000007'>陆地和浅海项目</option>
									</select>
								</td>
								<td class="inquire_item4">项目状态：</td>
								<td class="inquire_form4" id="item0_3">
									<select name="project_status" id="project_status" class="select_width">
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
									<input id="market_classify_name" name="market_classify_name" value="" type="text" class="input_width" />
								</td>
								<td class="inquire_item4">年度：</td>
								<td class="inquire_form4" id="item0_5">
									    <select id="project_year" name="project_year" class="select_width">
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
								<td class="inquire_item4">计划采集开始时间：</td>
								<td class="inquire_form4" id="item0_6">
									<input type="text" id="acquire_start_time" name="acquire_start_time" value="" class="input_width" />
								</td>
								<td class="inquire_item4">计划采集结束时间：</td>
								<td class="inquire_form4" id="item0_7"><input type="text" id="acquire_end_time" name="acquire_end_time" value="" class="input_width" />
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">合同开始时间：</td>
								<td class="inquire_form4" id="item0_9">
									<input type="text" id="design_start_date" name="design_start_date" value="" class="input_width" />
								</td>
								<td class="inquire_item4">合同结束时间：</td>
								<td class="inquire_form4" id="item0_10">
									<input type="text" id="design_end_date" name="design_end_date" value="" class="input_width" />
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">项目重要程度：</td>
								<td class="inquire_form4" id="item0_8"><code:codeSelect cssClass="select_width" name='is_main_project' option="isMainProject" selectedValue="" addAll="true" /></td>
								<td class="inquire_item4">勘探方法：</td>
								<td class="inquire_form4" id="item0_11">
									<select class=select_width name=exploration_method  id="exploration_method" >
											<option value="0300100012000000002">二维地震</option>
											<option value="0300100012000000003">三维地震</option>
											<option value="0300100012000000023">四维地震</option>
											<option value="0300100012000000028">多波</option>
									</select>
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">国内/国外：</td>
								<td class="inquire_form4" id="item0_12">
									<select class=select_width name=project_country id="project_country">
											<option value="1">国内</option>
											<option value="2">国外</option>
									</select>
								</td>
								<td class="inquire_item4">甲方单位：</td>
								<td class="inquire_form4" id="item0_13">
									<input id="manage_org" name="manage_org" value="" type="hidden" class="input_width" />
									<input id="manage_org_name" name="manage_org_name" value="" type="text" class="input_width" />
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">勘探类型：</td>
								<td class="inquire_form4" id="item0_14">
									<select class=select_width name=explore_type id='explore_type'>
										<option value='1'>普查</option>
										<option value='2'>详查</option>
										<option value='3'>预探</option>
										<option value='4'>评价</option>
										<option value='5'>开发</option>
										<option value='6'>其它</option>
									</select>
								</td>
								<td class="inquire_item4">资料处理单位：</td>
								<td class="inquire_form4" id="item0_15">
									<input type="text" id="processing_unit" name="processing_unit" class="input_width" />
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">激发方式：</td>
								<td class="inquire_form4" id="item0_16">
									<select class=select_width name=build_method id="build_method">
											<option value="5000100003000000001">井炮</option>
											<option value="5000100003000000002">震源</option>
									</select>
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
									<input type="text" id="prctr_name" name="prctr_name" value="" class="input_width" />
								</td>
								<td class="inquire_item4">施工队伍：</td>
								<td class="inquire_form4" id="item0_19">
									<input id="org_id" name="org_id" value="" type="hidden" class="input_width" />
									<input id="org_name" name="org_name" value="" type="text" class="input_width" />
								</td>
							</tr>
						</table>
					</div>
					<div id="tab_box_content1" class="tab_box_content" style="display:none;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						  <tr><input type="hidden" id="project_dynamic_no" name="project_dynamic_no" />
						  	<input type="hidden" id="workload" name="workload" />
					    	<td class="inquire_item6" id="design_line_num_td"><span class="red_star">*</span>设计测线条数：</td>
						    <td class="inquire_form6" id="item1_0"><input type="text" id="design_line_num" name="design_line_num" class="input_width" />&nbsp;条</td>
						    <td class="inquire_item6" id="design_object_workload1_td"><input type="radio" id="workload1" name="workload" value="1" checked="checked"/>设计实物工作量：</td>
						    <td class="inquire_form6" id="item1_1"><input type="text" id="design_workload1" name="design_workload1" class="input_width" />&nbsp;km</td>
						    <td class="inquire_item6" id="design_object_workload2_td"><input type="radio" id="workload2" name="workload" value="2"/>设计满覆盖工作量：</td>
						    <td class="inquire_form6" id="item1_22"><input type="text" id="design_workload2" name="design_workload2" class="input_width" />&nbsp;km</td>

						  </tr>
						  <tr>
						  	<td class="inquire_item6">设计试验炮：</td>
						    <td class="inquire_form6" id="item1_2"><input type="text" id="full_fold_workload" name="full_fold_workload" class="input_width" />&nbsp;炮</td>
						  	<td class="inquire_item6">设计检波点数：</td>
						    <td class="inquire_form6" id="item1_3"><input type="text" id="design_geophone_num" name="design_geophone_num" class="input_width" />&nbsp;个</td>
						  	<td class="inquire_item6">设计炮数：</td>
						    <td class="inquire_form6" id="item1_4"><input type="text" id="design_sp_num" name="design_sp_num" class="input_width" />&nbsp;炮</td>
						   </tr>
						   <tr>
						   	<td class="inquire_item6" id="item1_5_title" style="display:block;">设计震源炮数：</td>
						    <td class="inquire_form6" id="item1_5" style="display:block;"><input type="text" id="design_sp_num_zy" name="design_sp_num_zy" class="input_width" />&nbsp;炮</td>
						    <td class="inquire_item6">小折射设计点数：</td>
						    <td class="inquire_form6" id="item1_6"><input type="text" id="design_small_regraction_num" name="design_small_regraction_num" class="input_width" />&nbsp;个</td>
						    <td class="inquire_item6">微测井设计点数：</td>
						    <td class="inquire_form6" id="item1_7"><input type="text" id="design_micro_measue_num" name="design_micro_measue_num" class="input_width" />&nbsp;个</td>
						   </tr>
						   <tr id="tr1_9">
						   <!-- 	<td class="inquire_item6" id="item1_8_title" style="display:block;">钻井设计点数：</td> -->
						    <td class="inquire_item6" id="item1_8_title" style="display:block;">设计井炮炮数：</td>
						    <td class="inquire_form6" id="item1_8" style="display:block;"><input type="text" id="design_drill_num" name="design_drill_num" class="input_width" />&nbsp;炮</td>
						    <td class="inquire_item6">测量总公里数：</td>
						    <td class="inquire_form6" id="item1_9"><input type="text" id="measure_km" name="measure_km" class="input_width" />&nbsp;km</td>
						    <td class="inquire_item6"  style="display: none;" id="item1_10_1">设计检波点面积：</td>
						    <td class="inquire_form6" id="item1_10" style="display: none;"><input type="text" id="design_geophone_area" name="design_geophone_area" class="input_width" />&nbsp;km²</td>
						   </tr>
						   <tr style="display: none;" id="tr1_10">
						   	<td class="inquire_item6" style="display: none;" id="item1_11_1">设计有资料面积：</td>
						    <td class="inquire_form6" id="item1_11" style="display: none;"><input type="text" id="design_data_area" name="design_data_area" class="input_width" />&nbsp;km²</td>						   
						    <td class="inquire_item6" >设计施工面积：</td>
						    <td class="inquire_form6" id="item1_133"><input type="text" id="design_execution_area" name="design_execution_area" class="input_width" />&nbsp;km²</td>
						   	<td class="inquire_item6">&nbsp;</td>
						    <td class="inquire_form6" id="item1_12"><input type="hidden" id="design_sp_area" name="design_sp_area" class="input_width" />&nbsp;</td>
						   </tr>
						</table>
					</div>
					<div id="tab_box_content7" class="tab_box_content" style="display:none;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						  <tr>
						  	<td class="inquire_item4">地质任务：</td>
							<td colspan="3" class="inquire_form4"><textarea id="notes"  name="notes"cols="45" rows="5" class="textarea"></textarea></td>
							</tr>
						</table>
					</div>
					
					<div id="tab_box_content3" class="tab_box_content" style="display:none;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						    <tr><input id="workarea_no"  name="workarea_no"type="hidden" /><input type="hidden" id="project_info_no1" name="project_info_no1" />
						      <td class="inquire_item6"><span class="red_star">*</span>工区名称：</td>
						      <td class="inquire_form6"><input id="workarea"  name="workarea"class="input_width" type="text" /><input id="start_year" name="start_year" class="input_width" type="hidden" /></td>
						      <td class="inquire_item6">盆地：</td>
						      <td class="inquire_form6"><input id="basin" name="basin" class="input_width" type="text" /></td>
						      <td class="inquire_item6">区块（矿权）：</td>
						      <td class="inquire_form6" >
						      	<input name="block" id="block" value="" type="hidden" class="input_width" />
						      	<input id="spare2"  name="spare2"class="input_width" type="text"  readonly="readonly"/>
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
						      <td class="inquire_item6"><span class="red_star">*</span>工区中心经度：</td>
						      <td class="inquire_form6" ><input id="focus_x"  name="focus_x" class="input_width" type="text" /></td>
						      <td class="inquire_item6"><span class="red_star">*</span>工区中心纬度:</td>
						      <td class="inquire_form6" ><input id="focus_y"  name="focus_y"class="input_width" type="text" /></td>
						      <td class="inquire_item6">作物区类型：</td>
						      <td class="inquire_form6" ><select id="crop_area_type" name="crop_area_type" class="select_width"></select></td>
						     </tr>
						     <tr>
						      <td class="inquire_item6"><span class="red_star">*</span>国家:</td>
						      <td class="inquire_form6">
						      	<input id="country"  name="country" class="input_width" type="hidden" />
						      	<input id="country_name"  name="country_name" class="input_width" type="text"  readonly="readonly"/>
						      </td>
						      <td class="inquire_item6"></td>
						      <td class="inquire_form6"></td>
						      <td class="inquire_item6"></td>
						      <td class="inquire_form6"></td>
						     </tr>
						</table>
					</div>
					
					<div id="tab_box_content2" class="tab_box_content" style="display:none;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						 	<tr>
							  	<td class="inquire_item4">一级品率≧</td>
								<td class="inquire_form4"><input id="firstlevel_radio" name="firstlevel_radio" class="input_width"/>&nbsp;%</td>
								<td class="inquire_item4">合格品率≧</td>
								<td class="inquire_form4"><input id="qualified_radio" name="qualified_radio" class="input_width"/>&nbsp;%</td>	
							</tr>
							<tr>
							  	<td class="inquire_item4">废品率≦</td>
								<td class="inquire_form4"><input id="waster_radio" name="waster_radio" class="input_width"/>&nbsp;%</td>
								<td class="inquire_item4">&nbsp;</td>
								<td class="inquire_form4">&nbsp;</td>	
							</tr>
							<tr>
							  	<td class="inquire_item4" id="item2_0">空炮率≦</td>
								<td class="inquire_form4"><input id="miss_radio" name="miss_radio" class="input_width"/>&nbsp;%</td>
								<td class="inquire_item4">全工区空炮率≦</td>
								<td class="inquire_form4"><input id="all_miss_radio" name="all_miss_radio" class="input_width"/>&nbsp;%</td>	
							</tr>
							<tr>
							  	<td class="inquire_item4">表层调查成果合格率</td>
								<td class="inquire_form4"><input id="surface_radio" name="surface_radio" class="input_width"/>&nbsp;%</td>
								<td class="inquire_item4">测量成果合格率</td>
								<td class="inquire_form4"><input id="survey_radio" name="survey_radio" class="input_width"/>&nbsp;%</td>	
							</tr>
							<tr>
							  	<td class="inquire_item4">现场处理剖面合格率</td>
								<td class="inquire_form4"><input id="profile_radio" name="profile_radio" class="input_width"/>&nbsp;%</td>
								<td class="inquire_item4">&nbsp;</td>
								<td class="inquire_form4">&nbsp;</td>	
							</tr>
						</table>
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
debugger;
var retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo=<%=projectInfoNo %>");
document.getElementById("project_name").value= retObj.map.project_name;
document.getElementById("project_id").value= retObj.map.project_id;
document.getElementById("project_year").value= retObj.map.project_year;
document.getElementById("acquire_start_time").value= retObj.map.acquire_start_time;
document.getElementById("acquire_end_time").value= retObj.map.acquire_end_time;
document.getElementById("design_start_date").value= retObj.map.design_start_date;
document.getElementById("design_end_date").value= retObj.map.design_end_date;
document.getElementById("prctr_name").value= retObj.map.prctr_name;
document.getElementById("manage_org_name").value= retObj.map.manage_org_name;
document.getElementById("market_classify_name").value= retObj.map.market_classify_name;
document.getElementById("org_name").value= retObj.dynamicMap.org_name;
document.getElementById("notes").value= retObj.map.notes;

document.getElementById("project_dynamic_no").value= retObj.dynamicMap.project_dynamic_no;
document.getElementById("full_fold_workload").value= retObj.dynamicMap.full_fold_workload;
document.getElementById("design_geophone_num").value= retObj.dynamicMap.design_geophone_num;
document.getElementById("design_sp_num").value= retObj.dynamicMap.design_sp_num;
document.getElementById("design_small_regraction_num").value= retObj.dynamicMap.design_small_regraction_num;
document.getElementById("design_micro_measue_num").value= retObj.dynamicMap.design_micro_measue_num;
document.getElementById("design_drill_num").value= retObj.dynamicMap.design_drill_num;
document.getElementById("org_id").value= retObj.dynamicMap.org_id;
document.getElementById("org_name").value= retObj.dynamicMap.org_name;
document.getElementById("measure_km").value= retObj.dynamicMap.measure_km;
document.getElementById("design_sp_num_zy").value= retObj.dynamicMap.design_sp_num_zy;
var workarea_no = retObj.map.workarea_no;

if( retObj.bgpMap != null && retObj.bgpMap.bgp_report_no != null) {
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

sel = document.getElementById("exploration_method").options;
value = retObj.map.exploration_method;
for(var i=0;i<sel.length;i++)
{
    if(value==sel[i].value)
    {
       document.getElementById('exploration_method').options[i].selected=true;
    }
}

sel = document.getElementById("project_business_type").options;
value = retObj.map.project_business_type;
for(var i=0;i<sel.length;i++)
{
    if(value==sel[i].value)
    {
       document.getElementById('project_business_type').options[i].selected=true;
    }
}
sel = document.getElementById("is_main_project").options;
value = retObj.map.is_main_project;
for(var i=0;i<sel.length;i++)
{
    if(value==sel[i].value)
    {
       document.getElementById('is_main_project').options[i].selected=true;
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
sel = document.getElementById("build_method").options;
value = retObj.map.build_method;
for(var i=0;i<sel.length;i++)
{
    if(value==sel[i].value)
    {
       document.getElementById('build_method').options[i].selected=true;
    }
}


//根据bulid_method的值设置显示信息
var buildMethod = retObj.map.build_method;
//井炮
if(retObj.map.build_method == "5000100003000000001"){
	document.getElementById("item1_5_title").style.display="none";
	document.getElementById("item1_5").style.display="none";
	
	document.getElementById("item1_8_title").style.display="none";
	document.getElementById("item1_8").style.display="none";
}
//井炮/气枪
else if(retObj.map.build_method == "5000100003000000005"){
	document.getElementById("item1_5_title").style.display="none";
	document.getElementById("item1_5").style.display="none";
	
	document.getElementById("item1_8_title").style.display="none";
	document.getElementById("item1_8").style.display="none";
}
//震源
else if(retObj.map.build_method == "5000100003000000002"){
	document.getElementById("item1_8_title").style.display="none";
	document.getElementById("item1_8").style.display="none";
	
	document.getElementById("item1_5_title").style.display="none";
	document.getElementById("item1_5").style.display="none";
}
//震源/气枪
else if(retObj.map.build_method == "5000100003000000006"){
	document.getElementById("item1_8_title").style.display="none";
	document.getElementById("item1_8").style.display="none";
	
	document.getElementById("item1_5_title").style.display="none";
	document.getElementById("item1_5").style.display="none";
}

//井炮/震源
else if(retObj.map.build_method == "5000100003000000004"){
	document.getElementById("item1_8_title").style.display="block";
	document.getElementById("item1_8").style.display="block";
	
	document.getElementById("item1_5_title").style.display="block";
	document.getElementById("item1_5").style.display="block";
}
//井炮/震源/气枪
else if(retObj.map.build_method == "5000100003000000007"){
	document.getElementById("item1_8_title").style.display="block";
	document.getElementById("item1_8").style.display="block";
	
	document.getElementById("item1_5_title").style.display="block";
	document.getElementById("item1_5").style.display="block";
}

var exploration_method= retObj.map.exploration_method;
if(exploration_method == "0300100012000000002"){
	//document.getElementById("tag3_1").innerHTML= "<a href='#' onclick='getTab3(1)'>二维工作量</a>";
	document.getElementById("design_line_num_td").innerHTML= '<span class="red_star">*</span>设计测线条数：';
	document.getElementById("item1_0").innerHTML= '<input type="text" id="design_line_num" name="design_line_num" class="input_width" />&nbsp;条';
	document.getElementById("design_line_num").value= retObj.dynamicMap.design_line_num;
	
	//document.getElementById("design_object_workload_td").innerHTML= '<span class="red_star">*</span>设计工作量：';
	document.getElementById("item1_1").innerHTML= '<input type="text" id="design_object_workload" name="design_object_workload" class="input_width" />&nbsp;km';
	document.getElementById("design_object_workload").value= retObj.dynamicMap.design_object_workload;
	
	//document.getElementById("tr1_9").style.display="none";
	document.getElementById("item1_10_1").style.display="none";
	document.getElementById("item1_10").style.display="none";
	document.getElementById("item1_11").style.display="none";
	document.getElementById("item1_11_1").style.display="none";
	document.getElementById("tr1_10").style.display="none";
} else if(exploration_method == "0300100012000000003"){
	//document.getElementById("tag3_1").innerHTML= "<a href='#' onclick='getTab3(1)'>三维工作量</a>";
	document.getElementById("design_line_num_td").innerHTML= '<span class="red_star">*</span>设计线束数：';
	document.getElementById("item1_0").innerHTML= '<input type="text" id="design_line_num" name="design_line_num" class="input_width" />&nbsp;束';
	document.getElementById("design_line_num").value= retObj.dynamicMap.design_line_num;
	
	//document.getElementById("design_object_workload_td").innerHTML= '<span class="red_star">*</span>设计工作量：';
	document.getElementById("item1_1").innerHTML= '<input type="text" id="design_object_workload" name="design_object_workload" class="input_width" />&nbsp;km²';
	document.getElementById("design_object_workload").value= retObj.dynamicMap.design_object_workload;
	
	document.getElementById("design_geophone_area").value= retObj.dynamicMap.design_geophone_area;
	document.getElementById("design_execution_area").value= retObj.dynamicMap.design_execution_area;
	document.getElementById("design_data_area").value= retObj.dynamicMap.design_data_area;
	document.getElementById("design_sp_area").value= retObj.dynamicMap.design_sp_area;
	
	//document.getElementById("tr1_9").style.display="block";
	document.getElementById("item1_10_1").style.display="block";
	document.getElementById("item1_10").style.display="block";
	document.getElementById("item1_11").style.display="block";
	document.getElementById("item1_11_1").style.display="block";
	document.getElementById("tr1_10").style.display="block";
}
		
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

//质量指标
var retQuality = jcdpCallService("ProjectSrv", "getQuality", "projectInfoNo=<%=projectInfoNo %>");
if(exploration_method == "0300100012000000002"){
	document.getElementById("item2_0").innerHTML= '单线空炮率≦';
} else {
	document.getElementById("item2_0").innerHTML= '单束线空炮率≦';
}
if(retQuality != null && retQuality.qualityMap != null){
	document.getElementById("firstlevel_radio").value = retQuality.qualityMap.firstlevelRadio;
	document.getElementById("qualified_radio").value = retQuality.qualityMap.qualifiedRadio;
	document.getElementById("waster_radio").value = retQuality.qualityMap.wasterRadio;
	document.getElementById("miss_radio").value = retQuality.qualityMap.missRadio;
	document.getElementById("all_miss_radio").value = retQuality.qualityMap.allMissRadio;
	document.getElementById("surface_radio").value = retQuality.qualityMap.surfaceRadio;
	document.getElementById("survey_radio").value = retQuality.qualityMap.surveyRadio;
	document.getElementById("profile_radio").value = retQuality.qualityMap.profileRadio;
}

</script>
</html>