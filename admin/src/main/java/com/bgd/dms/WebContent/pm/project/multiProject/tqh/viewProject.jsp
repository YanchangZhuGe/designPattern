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
	//是否是审批查看
	String action = request.getParameter("action")==null?"":request.getParameter("action");
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
				    <li id="tag3_12"><a href="#" onclick="getTab3(12)">测量测算</a></li>
				    <li id="tag3_11"><a href="#" onclick="getTab3(11)">部署图</a></li>
				    <li id="tag3_8"><a href="#" onclick="getTab3(8)">分类码</a></li>
				    <li id="tag3_9"><a href="#" onclick="getTab3(9)">备注</a></li>
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
									<select class="select_width" name="project_type" id="project_type">
										<option value='5000100004000000001'>陆地项目</option>
										<option value='5000100004000000002'>浅海项目</option>
										<option value='5000100004000000010'>滩浅海过渡带</option>
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
									<%--  &nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectMarketClassify()" /> --%>
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
								<td class="inquire_item4">计划采集开始时间：</td>
								<td class="inquire_form4" id="item0_6">
									<input type="text" id="acquire_start_time" name="acquire_start_time" value="" class="input_width" readonly="readonly"/>
								</td>
								<td class="inquire_item4">计划采集结束时间：</td>
								<td class="inquire_form4" id="item0_7">
									<input type="text" id="acquire_end_time" name="acquire_end_time" value="" class="input_width" readonly="readonly"/>
								</td>
							</tr>
							
							<tr>
							    <td class="inquire_item6"><span class="red_star">*</span>合同开始时间：</td>
							    <td class="inquire_form6">
									<input type="text" id="design_start_date" name="design_start_date" value="" class="input_width" readOnly="readonly"/>
								</td>
							    <td class="inquire_item6"><span class="red_star">*</span>合同结束时间：</td>
							    <td class="inquire_form6">
								    <input type="text" id="design_end_date" name="design_end_date" value="" class="input_width" readOnly="readonly"/>
							    </td>
							</tr>
							
							<tr>
								<td class="inquire_item4">项目重要程度：</td>
								<td class="inquire_form4" id="item0_8"><code:codeSelect cssClass="select_width" name='is_main_project' option="isMainProject" selectedValue="" addAll="true" /></td>
								<td class="inquire_item4">项目业务类型：</td>
								<td class="inquire_form4" id="item0_17">
									<code:codeSelect cssClass="select_width" name='project_business_type' option="projectBusinessType" selectedValue="" addAll="true" />
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
									<select class=select_width name=explore_type id='explore_type' disabled='disabled'>
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
									<input type="hidden" id="bgp_report_no" name="bgp_report_no"/>
									<input type="text" id="processing_unit" name="processing_unit" class="input_width" readonly="readonly"/>
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">勘探方法：</td>
								<td class="inquire_form4" id="item0_11">
									<select class=select_width name=exploration_method  id="exploration_method" disabled='disabled'>
										<option value="0300100012000000002">二维地震</option>
										<option value="0300100012000000003">三维地震</option>
										<option value="0300100012000000029">二维/三维</option>
									</select>
								</td>
								<td class="inquire_item4">激发方式：</td>
								<td class="inquire_form4" id="item0_16">
									<select class=select_width name=build_method id="build_method" disabled="disabled">
										<option value="5000100003000000001">井炮</option>
										<option value="5000100003000000002">震源</option>
										<option value="5000100003000000003">气枪</option>
										<option value="5000100003000000004">井炮/震源</option>
										<option value="5000100003000000005">井炮/气枪</option>
										<option value="5000100003000000006">震源/气枪</option>
										<option value="5000100003000000007">井炮/震源/气枪</option>
										<option value="5000100003000000008">重锤</option>
										<option value="5000100003000000009">其他</option>
									</select>
								</td>
								
							</tr>
							<tr>
								<td class="inquire_item4">利润中心：</td>
								<td class="inquire_form4" id="item0_18">
									<input type="hidden" id="prctr" name="prctr" value="" class="input_width" />
									<input type="text" id="prctr_name" name="prctr_name" value="" class="input_width" readonly="readonly"/>
									<%-- &nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectPrctr()" /> --%>
								</td>
								<td class="inquire_item4">施工队伍：</td>
								<td class="inquire_form4" id="item0_19">
									<input id="org_id" name="org_id" value="" type="hidden" class="input_width" />
									<input id="org_name" name="org_name" value="" type="text" class="input_width" readonly="readonly"/>
								</td>
							</tr>
						</table>
					</div>
					<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					  <div id="workLoad3">
		              	<fieldSet style="margin:2px;padding:2px;"><legend>三维工作量</legend>
		              	<input type="hidden" id="work_load3" name="work_load3" value="" />
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						  <tr>
						    <td class="inquire_item6"><input type="radio" name="area" id="area1" value="1" onclick="work_load('area')" checked="checked" />设计施工面积：</td>
						    <td class="inquire_form6"><input type="text" id="design_execution_area" name="design_execution_area" class="input_width" />&nbsp;km²</td>
						    <td class="inquire_item6"><input type="radio" name="area" id="area2" value="2" onclick="work_load('area')"/>设计有资料面积：</td>
						    <td class="inquire_form6"><input type="text" id="design_data_area" name="design_data_area" class="input_width" />&nbsp;km²</td>
						    <td class="inquire_item6"><input type="radio" name="area" id="area3" value="3" onclick="work_load('area')"/>设计满覆盖面积：</td> <!-- id="td3_9_item" id="td3_9_form"-->
						    <td class="inquire_form6"><input type="text" id="design_object_area" name="design_object_area" class="input_width" />&nbsp;km²</td>
						  </tr>
						  <tr>
						  	<td class="inquire_item6">设计测量总公里数：</td>
						    <td class="inquire_form6"><input type="text" id="measure_km" name="measure_km" class="input_width" />&nbsp;km</td>
						    <td class="inquire_item6">设计检波点个数：</td>
						    <td class="inquire_form6"><input type="text" id="design_geophone_num" name="design_geophone_num" class="input_width" />&nbsp;个</td>
						    <td class="inquire_item6">设计总炮数：</td>
						    <td class="inquire_form6"><input type="text" id="design_sp_num" name="design_sp_num" class="input_width" />&nbsp;炮</td>
						  </tr>
						  <tr>
						    <td class="inquire_item6">设计试验炮：</td>
						    <td class="inquire_form6"><input type="text" id="full_fold_workload" name="full_fold_workload" class="input_width" />&nbsp;炮</td>
						    <td class="inquire_item6">设计线束数：</td>
						    <td class="inquire_form6"><input type="text" id="design_line_num" name="design_line_num" class="input_width" />&nbsp;束</td>
						    <td class="inquire_item6" id="td3_8_item"></td>
						    <td class="inquire_form6" id="td3_8_form"><!-- <input type="text" id="design_dw_num" name="design_dw_num" class="input_width" />&nbsp;炮 --></td>
						  </tr>
						  <tr id="tr3_1">
						    <td class="inquire_item6" id="td3_10_item">设计气枪：</td>
						    <td class="inquire_form6" id="td3_10_form"><input type="text" id="design_qq_num" name="design_qq_num" class="input_width" />&nbsp;炮</td>
						    <td class="inquire_item6" id="td3_11_item">设计井炮：</td>
						    <td class="inquire_form6" id="td3_11_form"><input type="text" id="design_drilling_num" name="design_drilling_num" class="input_width" />&nbsp;炮</td>
						    <td class="inquire_item6" id="td3_12_item">设计震源：</td>
						    <td class="inquire_form6" id="td3_12_form"><input type="text" id="design_sp_num_zy" name="design_sp_num_zy" class="input_width" />&nbsp;炮</td>
						  </tr>
						  <tr id="tr3_2">
						    <td class="inquire_item6">设计小折射点数：</td>
						    <td class="inquire_form6"><input type="text" id="design_small_regraction_num" name="design_small_regraction_num" class="input_width" />&nbsp;个</td>
						    <td class="inquire_item6">设计微测井点数：</td>
						    <td class="inquire_form6"><input type="text" id="design_micro_measue_num" name="design_micro_measue_num" class="input_width" />&nbsp;个</td>
						  </tr>
						</table>
						</fieldSet>
					  </div>
					  <div id="workLoad2">
					  	<fieldSet style="margin:2px;padding:2px;"><legend>二维工作量</legend>
					  	<input type="hidden" id="work_load2" name="work_load2" value="" />
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						  <tr>
						    <td class="inquire_item6"><input type="radio" name="lgth" id="length1" value="1" onclick="work_load('lgth')" checked="checked"/>设计实物工作量：</td>
						    <td class="inquire_form6"><input type="text" id="design_physical_workload" name="design_physical_workload" class="input_width" />&nbsp;km</td>
						    <td class="inquire_item6"><input type="radio" name="lgth" id="length2" value="2" onclick="work_load('lgth')"/>设计有资料工作量：</td>
						    <td class="inquire_form6"><input type="text" id="design_data_workload" name="design_data_workload" class="input_width" />&nbsp;km</td>
						    <td class="inquire_item6"><input type="radio" name="lgth" id="length3" value="3" onclick="work_load('lgth')"/>设计满覆盖工作量：</td>
						 	<td class="inquire_form6"><input type="text" id="design_object_workload" name="design_object_workload" class="input_width" />&nbsp;km</td>
						  </tr>
						  <tr>
						    <td class="inquire_item6">设计测量总公里数：</td>
						    <td class="inquire_form6"><input type="text" id="measure_km2" name="measure_km2" class="input_width" />&nbsp;km</td>
						    <td class="inquire_item6">设计检波点个数：</td>
						    <td class="inquire_form6"><input type="text" id="design_geophone_num2" name="design_geophone_num2" class="input_width" />&nbsp;个</td>
						    <td class="inquire_item6">设计总炮数：</td>
						    <td class="inquire_form6"><input type="text" id="design_sp_num2" name="design_sp_num2" class="input_width" />&nbsp;炮</td>
						  </tr>
						  <tr>
						    <td class="inquire_item6">设计试验炮：</td>
						    <td class="inquire_form6"><input type="text" id="full_fold_workload2" name="full_fold_workload2" class="input_width" />&nbsp;炮</td>
						    <td class="inquire_item6">设计测线：</td>
						    <td class="inquire_form6"><input type="text" id="other_line_num" name="other_line_num" class="input_width" />&nbsp;条</td>
						    <td class="inquire_item6" id="td2_8_item">设计定位炮：</td>
						    <td class="inquire_form6" id="td2_8_form"><input type="text" id="design_dw_num2" name="design_dw_num2" class="input_width" />&nbsp;炮</td>
						  </tr>
						  <tr id="tr3_3">
						    <td class="inquire_item6" id="td2_9_item">设计气枪：</td>
						    <td class="inquire_form6" id="td2_9_form"><input type="text" id="design_qq_num" name="design_qq_num" class="input_width" />&nbsp;炮</td>
						    <td class="inquire_item6" id="td2_10_item">设计震源：</td>
						    <td class="inquire_form6" id="td2_10_form"><input type="text" id="design_sp_num_zy" name="design_sp_num_zy" class="input_width" />&nbsp;炮</td>
						    <td class="inquire_item6" id="td2_11_item">设计井炮：</td>
						    <td class="inquire_form6" id="td2_11_form"><input type="text" id="design_drilling_num" name="design_drilling_num" class="input_width" />&nbsp;炮</td>
						  </tr>
						  <tr id="tr3_4">
						  	<td class="inquire_item6" id="td2_12_item">设计小折射点数：</td>
						    <td class="inquire_form6" id="td2_12_form"><input type="text" id="design_small_regraction_num" name="design_small_regraction_num" class="input_width" />&nbsp;个</td>
						    <td class="inquire_item6" id="td2_13_item">设计微测井点数：</td>
						    <td class="inquire_form6" id="td2_13_form"><input type="text" id="design_micro_measue_num" name="design_micro_measue_num" class="input_width" />&nbsp;个</td>
						  </tr>
						</table>
						</fieldSet>
					  </div>
					</div>
					<div id="tab_box_content7" class="tab_box_content" style="display:none;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" id="notes_table">
						  <tr>
						  	<td class="inquire_item4">地质任务：</td>
							<td colspan="3" class="inquire_form4"><textarea id="notes"  name="notes"cols="45" rows="5" class="textarea"></textarea></td>
							</tr>
						</table>
					</div>
					
					<div id="tab_box_content3" class="tab_box_content" style="display:none;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" id="workarea_table">
						    <tr><input id="workarea_no"  name="workarea_no"type="hidden" /><input type="hidden" id="project_info_no1" name="project_info_no1" />
						      <td class="inquire_item6"><span class="red_star">*</span>工区名称：</td>
						      <td class="inquire_form6"><input id="workarea"  name="workarea"class="input_width" type="text" /><input id="start_year" name="start_year" class="input_width" type="hidden" /></td>
						      <td class="inquire_item6">盆地：</td>
						      <td class="inquire_form6"><input id="basin" name="basin" class="input_width" type="text" /></td>
						      <td class="inquire_item6">区块（矿权）：</td>
						      <td class="inquire_form6" >
						      	<input name="block" id="block" value="" type="hidden" class="input_width" />
						      	<input id="spare2"  name="spare2"class="input_width" type="text"  readonly="readonly"/>
						      	<%-- <img src="<%= request.getContextPath() %>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectCoding('0300100011','block','spare2');" /> --%>
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
						      	<%-- &nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectCoding('0200100001','country','country_name');" /> --%>
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
						  	<td class="inquire_item4" id="yjpl_lab">一级品率≧</td>
							<td class="inquire_form4" id="yjpl_val"><input id="firstlevel_radio" name="firstlevel_radio" class="input_width"/>&nbsp;%</td>
							<td class="inquire_item4" id="fpl_lab">废品率≦</td>
							<td class="inquire_form4" id="fpl_val"><input id="waster_radio" name="waster_radio" class="input_width"/>&nbsp;%</td>	
						</tr>
						
					 	<tr>
						  	<td class="inquire_item4" id="qu_1_item">二次定位采收率</td>
							<td class="inquire_form4" id="qu_1_form"><input id="second_radio" name="second_radio" class="input_width"/>&nbsp;%</td>
							<td class="inquire_item4"><span class="red_star"></span>合格品率≧</td>
							<td class="inquire_form4"><input id="qualified_radio" name="qualified_radio" class="input_width"/>&nbsp;%</td>	
						</tr>
						<tr>
						  	<td class="inquire_item4" id="item2_0">空炮率≦</td>
							<td class="inquire_form4"><input id="miss_radio" name="miss_radio" class="input_width"/>&nbsp;%</td>
							<td class="inquire_item4">全工区空炮率≦</td>
							<td class="inquire_form4"><input id="all_miss_radio" name="all_miss_radio" class="input_width"/>&nbsp;%</td>	
						</tr>
						<tr>
							<td class="inquire_item4"><span class="red_star"></span>测量成果合格率</td>
							<td class="inquire_form4"><input id="survey_radio" name="survey_radio" class="input_width"/>&nbsp;%</td>	
							<td class="inquire_item4"><span class="red_star"></span>现场处理剖面合格率</td>
							<td class="inquire_form4"><input id="profile_radio" name="profile_radio" class="input_width"/>&nbsp;%</td>
						</tr>
					</table>
					</div>
					
					<div id="tab_box_content8" class="tab_box_content" style="display:none;">
						<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: auto;"></iframe>
					</div>
					<div id="tab_box_content9" class="tab_box_content" style="display:none;">
						<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: auto;"></iframe>
					</div>
					<div id="tab_box_content11" class="tab_box_content" style="display:none;">
						<iframe width="100%" height="100%" name="deployDiagram" id="deployDiagram" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: auto;"></iframe>
					</div>
					<div id="tab_box_content12" class="tab_box_content" style="display:none;">
						<iframe width="100%" height="100%" name=measurement id="measurement" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: auto;"></iframe>
					</div>
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
var expMethod = "";
var action="<%=action%>";

var retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo=<%=projectInfoNo%>");
document.getElementById("project_name").value= retObj.map.project_name;
document.getElementById("project_id").value= retObj.map.project_id;
document.getElementById("project_year").value= retObj.map.project_year;
document.getElementById("acquire_start_time").value= retObj.map.acquire_start_time;
document.getElementById("acquire_end_time").value= retObj.map.acquire_end_time;

document.getElementById("design_start_date").value= retObj.map.design_start_date;
document.getElementById("design_end_date").value= retObj.map.design_end_date;

//document.getElementById("transit_time").value= retObj.map.transit_time;
document.getElementById("prctr_name").value= retObj.map.prctr_name;
document.getElementById("prctr").value= retObj.map.prctr;
document.getElementById("manage_org_name").value= retObj.map.manage_org_name;
document.getElementById("manage_org").value= retObj.map.manage_org;
document.getElementById("market_classify_name").value= retObj.map.market_classify_name;
document.getElementById("market_classify").value= retObj.map.market_classify;
document.getElementById("org_name").value= retObj.dynamicMap.org_name;
document.getElementById("notes").value= retObj.map.notes;
//--加载工作量
$("#design_line_num").val(retObj.dynamicMap.design_line_num);
		$("#design_execution_area").val(retObj.dynamicMap.design_execution_area);
		$("#design_data_area").val(retObj.dynamicMap.design_data_area);
		$("#design_object_area").val(retObj.dynamicMap.design_object_area);
		$("#measure_km").val(retObj.dynamicMap.measure_km);
		$("#design_geophone_num").val(retObj.dynamicMap.design_geophone_num);
		$("#design_sp_num").val(retObj.dynamicMap.design_sp_num);
		$("#design_qq_num").val(retObj.dynamicMap.design_qq_num);
		$("#design_drilling_num").val(retObj.dynamicMap.design_drilling_num);
		$("#design_sp_num_zy").val(retObj.dynamicMap.design_sp_num_zy);
		$("#full_fold_workload").val(retObj.dynamicMap.full_fold_workload);
		//$("#design_dw_num").val(retObj.dynamicMap.design_dw_num);
		$("#design_small_regraction_num").val(retObj.dynamicMap.design_small_regraction_num);
		$("#design_micro_measue_num").val(retObj.dynamicMap.design_micro_measue_num);
		$("#design_data_workload").val(retObj.dynamicMap.design_data_workload);//设计有资料长度
		
		$("#other_line_num").val(retObj.dynamicMap.other_line_num);
		$("#design_physical_workload").val(retObj.dynamicMap.design_physical_workload);
		$("#design_object_workload").val(retObj.dynamicMap.design_object_workload);
		$("#measure_km2").val(retObj.dynamicMap.measure_km2);
		$("#design_geophone_num2").val(retObj.dynamicMap.design_geophone_num2);
		$("#design_sp_num2").val(retObj.dynamicMap.design_sp_num2);
		$("#full_fold_workload2").val(retObj.dynamicMap.full_fold_workload2);
		$("#design_dw_num2").val(retObj.dynamicMap.design_dw_num2);
		
		$("#workLoad2").css("display","block");
		$("#workLoad3").css("display","block");
		$("#workLoad2 input[type=text]").removeAttr("disabled");
		$("#workLoad3 input[type=text]").removeAttr("disabled");
		$("#[id^=tr3_]").attr("style","display:block");
		$("#[id^=td3_]").attr("style","display:block");
		$("#[id^=td2_]").attr("style","display:block");
		if("0300100012000000003"==retObj.map.exploration_method){//三维
			$("#workLoad3 input[id=design_qq_num]").val(retObj.dynamicMap.design_qq_num);//设计气枪
			$("#workLoad3 input[id=design_drilling_num]").val(retObj.dynamicMap.design_drilling_num);//设计井炮
			$("#workLoad3 input[id=design_sp_num_zy]").val(retObj.dynamicMap.design_sp_num_zy);//设计震源
			$("#workLoad3 input[id=design_small_regraction_num]").val(retObj.dynamicMap.design_small_regraction_num);//小折射点数赋值
			$("#workLoad3 input[id=design_micro_measue_num]").val(retObj.dynamicMap.design_micro_measue_num);//微测井点数赋值
			$("#workLoad2").attr("style","display:none");
			$("#workLoad2 input[type=text]").attr("disabled","disabled");
			if("5000100003000000003"==retObj.map.build_method){//气枪
				$("#tr3_1").attr("style","display:none");
				$("#tr3_2").attr("style","display:none");
			}
			if("5000100003000000001"==retObj.map.build_method){//井炮
				$("#[id^=td3_8_]").attr("style","display:none");
				$("#tr3_1").attr("style","display:none");
			}
			if("5000100003000000004"==retObj.map.build_method){//井炮/震源
				$("#[id^=td3_8_]").attr("style","display:none");
				$("#[id^=td3_10_]").attr("style","display:none");
			}
			if("5000100003000000005"==retObj.map.build_method){//气枪/井炮
				$("#[id^=td3_12_]").attr("style","display:none");
				$("#tr3_2").attr("style","display:none");
			}
			var index = retObj.dynamicMap.work_load3==null || retObj.dynamicMap.work_load3==''?'1':retObj.dynamicMap.work_load3;
			//document.getElementById("area"+index).checked = 'checked';
			if(index =="1"){
				document.getElementById("area"+index).checked = 'checked';		 
				document.getElementById("area2").disabled='disabled';
				document.getElementById("area3").disabled='disabled';
			}
			
			if(index =="2"){
				document.getElementById("area"+index).checked = 'checked';		 
				document.getElementById("area1").disabled='disabled';
				document.getElementById("area3").disabled='disabled';
			}
			
			if(index =="3"){
				document.getElementById("area"+index).checked = 'checked';		 
				document.getElementById("area1").disabled='disabled';
				document.getElementById("area2").disabled='disabled';
			}
			
		}
		if("0300100012000000002"==retObj.map.exploration_method){//二维
			$("#workLoad2 input[id=design_qq_num]").val(retObj.dynamicMap.design_qq_num);//设计气枪
			$("#workLoad2 input[id=design_drilling_num]").val(retObj.dynamicMap.design_drilling_num);//设计井炮
			$("#workLoad2 input[id=design_sp_num_zy]").val(retObj.dynamicMap.design_sp_num_zy);//设计震源
			$("#workLoad2 input[id=design_small_regraction_num]").val(retObj.dynamicMap.design_small_regraction_num);//小折射点数赋值
			$("#workLoad2 input[id=design_micro_measue_num]").val(retObj.dynamicMap.design_micro_measue_num);//微测井点数赋值
			$("#workLoad3").css("display","none");
			$("#workLoad3 input[type=text]").attr("disabled","disabled");
			if("5000100003000000003"==retObj.map.build_method){//气枪
				$("#tr3_3").attr("style","display:none");
				$("#tr3_4").attr("style","display:none");
			}
			if("5000100003000000001"==retObj.map.build_method){//井炮
				$("#[id^=td2_8_]").attr("style","display:none");
				$("#[id^=tr3_3]").attr("style","display:none");
			}
			if("5000100003000000004"==retObj.map.build_method){//井炮/震源
				$("#[id^=td2_8_]").attr("style","display:none");
				$("#[id^=td2_9_]").attr("style","display:none");
			}
			if("5000100003000000005"==retObj.map.build_method){//气枪/井炮
				$("#[id^=td2_10_]").attr("style","display:none");
			}
			var index = retObj.dynamicMap.work_load2==null || retObj.dynamicMap.work_load2==''?'1':retObj.dynamicMap.work_load2;
			
		//	document.getElementById("length"+index).checked = 'checked';
			
			if(index =="1"){
				document.getElementById("length"+index).checked = 'checked';		 
				document.getElementById("length2").disabled='disabled';
				document.getElementById("length3").disabled='disabled';
			}
			
			if(index =="2"){
				document.getElementById("length"+index).checked = 'checked';		 
				document.getElementById("length1").disabled='disabled';
				document.getElementById("length3").disabled='disabled';
			}
			
			if(index =="3"){
				document.getElementById("length"+index).checked = 'checked';		 
				document.getElementById("length1").disabled='disabled';
				document.getElementById("length2").disabled='disabled';
			}
			
			
		}
		if("0300100012000000029"==retObj.map.exploration_method){//二维+三维
			if("5000100003000000001"==retObj.map.build_method){//井炮
				$("#[id^=tr3_1]").attr("style","display:none");
				$("#[id^=tr3_3]").attr("style","display:none");
				$("#[id^=tr3_4]").attr("style","display:none");
				$("#[id^=td3_8_]").attr("style","display:none");
				$("#[id^=td2_8_]").attr("style","display:none");
				$("#tr3_4 input[type=text]").attr("disabled","disabled");
			}else{
				$("#[id^=tr3_]").attr("style","display:none");
			}
		}
		
		//质量指标隐藏二次定位采收率
		$("#[id^=qu_1]").attr("style","display:block");
		if("5000100003000000001"==retObj.map.build_method||"5000100003000000004"==retObj.map.build_method){//井炮||井炮+震源
			$("#[id^=qu_1]").attr("style","display:none");
		}
		
		
		
		$("#yjpl_lab").attr("style","display:none");
		$("#yjpl_val").attr("style","display:none");
		$("#fpl_lab").attr("style","display:none");
		$("#fpl_val").attr("style","display:none");
		if(retObj.map.build_method=='5000100003000000003'||retObj.map.build_method=='5000100003000000001'||retObj.map.build_method=='5000100003000000005'||retObj.map.build_method=='5000100003000000007'){
			$("#yjpl_lab").attr("style","display:block");
			$("#yjpl_val").attr("style","display:block");
			$("#fpl_lab").attr("style","display:block");
			$("#fpl_val").attr("style","display:block");
		}
		
		
		
//-----------------------

//质量指标
var retQuality = jcdpCallService("ProjectSrv", "getQuality", "projectInfoNo=<%=projectInfoNo%>");
if(exploration_method == "0300100012000000002"){
	document.getElementById("item2_0").innerHTML= '单线空炮率≦';
} else {
	document.getElementById("item2_0").innerHTML= '单束线空炮率≦';
}
if(retQuality != null && retQuality.qualityMap != null){
	//document.getElementById("object_id").value = retQuality.qualityMap.objectId;
	document.getElementById("qualified_radio").value = retQuality.qualityMap.qualifiedRadio;
	document.getElementById("miss_radio").value = retQuality.qualityMap.missRadio;
	document.getElementById("waster_radio").value = retQuality.qualityMap.wasterRadio;
	document.getElementById("survey_radio").value = retQuality.qualityMap.surveyRadio;
	document.getElementById("profile_radio").value = retQuality.qualityMap.profileRadio;
	document.getElementById("second_radio").value = retQuality.qualityMap.secondRadio;
	
	document.getElementById("firstlevel_radio").value = retQuality.qualityMap.firstlevelRadio;
	document.getElementById("all_miss_radio").value = retQuality.qualityMap.allMissRadio;
}

//------------------------------------------------------------------
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

sel = document.getElementById("exploration_method").options;
value = retObj.map.exploration_method;
for(var i=0;i<sel.length;i++)
{
    if(value==sel[i].value)
    {
       document.getElementById('exploration_method').options[i].selected=true;
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
sel = document.getElementById("build_method").options;
value = retObj.map.build_method;
for(var i=0;i<sel.length;i++)
{
    if(value==sel[i].value)
    {
       document.getElementById('build_method').options[i].selected=true;
    }
}


var exploration_method= retObj.map.exploration_method;
expMethod = exploration_method;


//部署图
document.getElementById("deployDiagram").src = "<%=contextPath%>/pm/deployDiagram/deployDiagramList.jsp?projectInfoNo=<%=projectInfoNo %>";

//分类码
document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=3&relationId=<%=projectInfoNo %>";

//测量测算 encodeURI(encodeURI(_tmplsgx)
		
$("#measurement")[0].src = "<%=contextPath%>/pm/measurement/measurementList.jsp?projectInfoNo=<%=projectInfoNo %>&viewmeasurement=1";
		
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
// 备注
document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId=<%=projectInfoNo %>";
	

function selectMarketClassify(){
	var teamInfo = {
		fkValue:"",
		value:""
	};
	window.showModalDialog('<%=contextPath%>/common/selectCode.jsp?codingSortId=0100500006',teamInfo);
	if(teamInfo.fkValue!=""){
		document.getElementById('market_classify').value = teamInfo.fkValue;
		document.getElementById('market_classify_name').value = teamInfo.value;
	}
}

function selectManageOrg(){
	var teamInfo = {
		fkValue:"",
		value:""
	};
	window.showModalDialog('<%=contextPath%>/common/selectManageOrg.jsp',teamInfo,'dialogWidth=600px;dialogHeight=600px');
	if(teamInfo.fkValue!=""){
		document.getElementById('manage_org').value = teamInfo.fkValue;
		document.getElementById('manage_org_name').value = teamInfo.value;
	}
}

function selectPrctr(){
	var teamInfo = {
		fkValue:"",
		value:""
	};
	window.showModalDialog('<%=contextPath%>/pm/comm/selectSAPProjectOrg.jsp', teamInfo);
		if (teamInfo.fkValue != "") {
			document.getElementById('prctr').value = teamInfo.fkValue;
			document.getElementById('prctr_name').value = teamInfo.value;
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

function selectTeam(){
	var teamInfo = {
		fkValue:"",
		value:""
	};
	window.showModalDialog('<%=contextPath%>/common/selectOrg.jsp',teamInfo);
	if(teamInfo.fkValue!=""){
		document.getElementById('org_id').value = teamInfo.fkValue;
		document.getElementById('org_name').value = teamInfo.value;
	}
}
$("#project_type").attr("disabled","disabled");
$("#is_main_project").attr("disabled","disabled");
$("#project_business_type").attr("disabled","disabled");
$("#workload_table input[type=text]").attr("readonly","readonly");
$("#workarea_table input[type=text]").attr("readonly","readonly");
$("#workarea_table select").attr("disabled","disabled");
$("#notes_table :input").attr("readonly","readonly");
$("#ratio_table input[type=text]").attr("readonly","readonly");

//审批页面隐藏页卡
if("view"==action){
	$("#tag3_12").css("display","none");
	$("#tag3_11").css("display","none");
	$("#tag3_8").css("display","none");
	$("#tag3_9").css("display","none");
}
</script>
</html>