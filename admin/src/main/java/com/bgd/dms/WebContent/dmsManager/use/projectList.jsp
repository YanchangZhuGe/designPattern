<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="code" prefix="code"%>
<%@ page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ page import="java.text.*"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = user.getSubOrgIDofAffordOrg();
	String projectType = request.getParameter("projectType");
	if ("".equals(projectType) || projectType == null) {
		projectType = "";
	}
%>
<html>
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>项目综合数据查询</title>
</head>
<body style="background: #cdddef">
	<div id="list_table">
	<div id="inq_tool_box">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			<td background="<%=contextPath%>/images/list_15.png">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="ali_cdn_name">项目名:</td>
					<td class="ali_cdn_input"><input id="projectName" name="projectName" type="text" class="input_width" /></td>
					<td class="ali_cdn_name">物探处:</td>
					<td class="ali_cdn_input"><select name='s_orgSubjectionId' id="s_orgSubjectionId">
						<% if ("C105".equals(orgSubId)) { %>
								<option value="1">--请选择--</option>
						<%
							}
							if ("C105".equals(orgSubId)) {
								for (int i = 0; i < DevUtil.orgNameList.size(); i++) {
									String[] tmpstrs = DevUtil.orgNameList.get(i).split("-");
						%>
							<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
						<%
							}
						} else {
												for (int i = 0; i < DevUtil.orgNameList.size(); i++) {
													if (DevUtil.orgNameList.get(i).indexOf(orgSubId) >= 0) {
														String[] tmpstrs = DevUtil.orgNameList.get(i)
																.split("-");
										%>
										<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
										<%
											}
												}
											}
										%>
								</select></td>
								<td class="ali_cdn_name">项目类型:</td>
								<td class="ali_cdn_input"><select id="projecttype"></select></td>
								<td class="ali_cdn_name">项目状态:</td>
          						<td class="ali_cdn_input"><select id="projectstatus"></select></td>
								<td class="ali_query"><span class="cx"><a href="####" onclick="simpleRefreshData()" title="JCDP_btn_query"></a></span></td>
								<td class="ali_query"><span class="qc"><a href="####" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span></td>
								<td>&nbsp;</td>
								<auth:ListButton functionId="" css="gl"  event="onclick='toSearch()'" title="JCDP_btn_query"></auth:ListButton>								
								<auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
							</tr>
						</table></td>
					<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				</tr>
			</table>
		</div>
		<div id="table_box">
			<input type="hidden" id="orgSubjectionId" name="orgSubjectionId" value="<%=orgSubId%>" class="input_width" />
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
				<tr>
					<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{project_info_no}' id='rdo_entity_id_{project_info_no}' onclick=doCheck(this)/>">选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{project_name}">项目名称</td>
					<td class="bt_info_even" exp="{project_status}" func="getOpValue,projectStatus1">项目状态</td>
					<td class="bt_info_odd" exp="{org_name}">施工队伍</td>
					<!-- <td class="bt_info_even" exp="{project_type}"  func="getOpValue,projectType1">项目类型</td> -->
					<td class="bt_info_even" exp="{owning_org_name_desc}">所属单位</td>
					<td class="bt_info_odd" exp="{start_date}">采集开始时间</td>
					<td class="bt_info_even" exp="{end_date}">采集结束时间</td>
				</tr>
			</table>
		</div>
		<div id="fenye_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
				<tr>
					<td align="right">第1/1页，共0条记录</td>
					<td width="10">&nbsp;</td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
					<td width="50">到 <label> <input type="text" name="textfield" id="textfield" style="width: 20px;" />
					</label></td>
					<td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				</tr>
			</table>
		</div>
		<div class="lashen" id="line"></div>
		<div id="tag-container_3">
			<ul id="tags" class="tags">
				<li class="selectTag" id="tag3_0"><a href="####" onclick="getTab3(0)">基本信息</a></li>
				<li id="tag3_3"><a href="####" onclick="getTab3(3)">工区信息</a></li>
				<li id="tag3_1"><a href="####" onclick="getTab3(1)">工作量</a></li>
				<li id="tag3_7"><a href="####" onclick="getTab3(7)">地质任务</a></li>
				<li id="tag3_2"><a href="####" onclick="getTab3(2)">质量指标</a></li>
				<li id="tag3_12"><a href="####" onclick="getTab3(12)">测量测算</a></li>
				<li id="tag3_11"><a href="####" onclick="getTab3(11)">部署图</a></li>
				<li id="tag3_8"><a href="####" onclick="getTab3(8)">分类码</a></li>
				<li id="tag3_9"><a href="####" onclick="getTab3(9)">备注</a></li>
			</ul>
		</div>

		<div id="tab_box" class="tab_box">
			<form name="projectForm" id="projectForm" method="post" action="">
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr>
							<td class="inquire_item6"><span class="red_star">*</span>项目名称：</td>
							<td class="inquire_form6" id="item0_0">
								<input type="hidden" name="task_log_id" id="task_log_id" />
								<input type="hidden" id="project_info_no" name="project_info_no" />
								<input type="text" id="project_name" name="project_name" class="input_width" />
							</td>
							<td class="inquire_item6">项目编号：</td>
							<td class="inquire_form6" id="item0_1">
								<input type="text" id="project_id" name="project_id" class="input_width_no_color" disabled="disabled" readOnly="readonly" />
							</td>
							<td class="inquire_item6">项目类型：</td>
							<td class="inquire_form6" id="item0_2">
								<code:codeSelect cssClass="select_width" name='project_type' option="projectType" selectedValue="" addAll="true" />
							</td>
						</tr>
						<tr>
							<td class="inquire_item6"><span class="red_star">*</span>项目状态：</td>
							<td class="inquire_form6" id="item0_3">
								<code:codeSelect cssClass="select_width" name='project_status' option="projectStatus" selectedValue="" addAll="true" />
							</td>
							<td class="inquire_item6"><span class="red_star">*</span>市场范围：</td>
							<td class="inquire_form6" id="item0_4">
								<input id="market_classify" name="market_classify" value="" type="hidden" class="input_width" />
								<input id="market_classify_name" name="market_classify_name" value="" type="text" class="input_width" readonly="readonly" />
							</td>
							<td class="inquire_item6">年度：</td>
							<td class="inquire_form6" id="item0_5">
								<select id="project_year" name="project_year" class="select_width">
									<%
										Date date = new Date();
										int years = date.getYear() + 1900 - 10;
										int year = date.getYear() + 1900;
										for (int i = 0; i < 20; i++) {
									%>
									<option value="<%=years%>">
										<%=years%>
									</option>
									<%
										years++;
										}
									%>
							</select></td>
						</tr>
						<tr>
							<td class="inquire_item6"><span class="red_star">*</span>计划采集开始时间：</td>
							<td class="inquire_form6" id="item0_3">
								<input type="text" id="acquire_start_time" name="acquire_start_time" value="" class="input_width" readonly="readonly" /> 
							</td>
							<td class="inquire_item6"><span class="red_star">*</span>计划采集结束时间：</td>
							<td class="inquire_form6" id="item0_4">
								<input type="text" id="acquire_end_time" name="acquire_end_time" value="" class="input_width" readonly="readonly" />
							</td>
							<td class="inquire_item6"><span class="red_star">*</span>项目重要程度：</td>
							<td class="inquire_form6" id="item0_5">
								<code:codeSelect cssClass="select_width" name='is_main_project' option="isMainProject" selectedValue="" addAll="true" />
							</td>
						</tr>
						<tr>
							<td class="inquire_item6"><span class="red_star">*</span>合同开始时间：</td>
							<td class="inquire_form6" id="item0_3">
								<input type="text" id="design_start_date" name="design_start_date" value="" class="input_width" readOnly="readonly" />
							</td>
							<td class="inquire_item6"><span class="red_star">*</span>合同结束时间：</td>
							<td class="inquire_form6" id="item0_4">
								<input type="text" id="design_end_date" name="design_end_date" value="" class="input_width" readOnly="readonly" />
							</td>
							<td class="inquire_item6">勘探方法：</td>
							<td class="inquire_form6" id="item0_5">
								<select class="select_width" name=exploration_method id="exploration_method">
									<option value="0300100012000000002">二维地震</option>
									<option value="0300100012000000003">三维地震</option>
									<option value="0300100012000000023">四维地震</option>
									<option value="0300100012000000028">多波</option>
								</select>
							</td>
						</tr>
						<tr>
							<td class="inquire_item6"><span class="red_star">*</span>甲方单位：</td>
							<td class="inquire_form6" id="item0_4">
								<input type="hidden" id="manage_org" name="manage_org" class="input_width" readonly="readonly" />
								<input type="text" id="manage_org_name" name="manage_org_name" class="input_width" readonly/>
							</td>
							<td class="inquire_item6">勘探类型：</td>
							<td class="inquire_form6" id="item0_5">
								<select class=select_width name=explore_type id=explore_type>
									<option value='1'>普查</option>
									<option value='2'>详查</option>
									<option value='3'>预探</option>
									<option value='4'>评价</option>
									<option value='5'>开发</option>
									<option value='6'>其它</option>
								</select>
							</td>
							<td class="inquire_item6">资料处理单位：</td>
							<td class="inquire_form6" id="item0_3">
								<input type="hidden" id="bgp_report_no" name="bgp_report_no" />
								<input type="text" id="processing_unit" name="processing_unit" class="input_width" />
							</td>
						</tr>
						<tr>
							<td class="inquire_item6"><span class="red_star">*</span>激发方式：</td>
							<td class="inquire_form6" id="item0_4">
								<code:codeSelect cssClass="select_width" name='build_method' option="buildMethod" selectedValue="" addAll="true" />
							</td>
							<td class="inquire_item6"><span class="red_star">*</span>项目业务类型：</td>
							<td class="inquire_form6" id="item0_5">
								<code:codeSelect cssClass="select_width" name='project_business_type' option="projectBusinessType" selectedValue="" addAll="true" />
							</td>
							<td class="inquire_item6"><span class="red_star">*</span>利润中心：</td>
							<td class="inquire_form6" id="item0_3">
								<input type="hidden" id="prctr" name="prctr" value="" class="input_width" />
								<input type="text" id="prctr_name" name="prctr_name" value="" class="input_width" readonly="readonly" />
							</td>
						</tr>
						<tr>
							<td class="inquire_item6"><span class="red_star">*</span>施工队伍：</td>
							<td class="inquire_form6" id="item0_19">
								<input id="org_id" name="org_id" value="" type="hidden" class="input_width" />
								<input id="org_name" name="org_name" value="" type="text" class="input_width" readonly/>
							</td>
							<td class="inquire_item6"><span class="red_star">*</span>队经理：</td>
							<td class="inquire_form6" id="item0_18">
								<input type="text" id="vsp_team_leader" name="vsp_team_leader" class="input_width" />
							</td>
							<td class="inquire_item6">国内/国外：</td>
							<td class="inquire_form6" id="item0_3">
								<select class="select_width" name="project_country" id="project_country">
									<option value='1'>国内</option>
									<option value='2'>国外</option>
								</select>
							</td>
							<td class="inquire_item6">&nbsp;</td>
							<td class="inquire_form6" id="item0_5">&nbsp;</td>
						</tr>
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content"
					style="display: none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr>
							<input type="hidden" id="project_dynamic_no" name="project_dynamic_no" />
							<input type="hidden" id="design_object_workload" name="design_object_workload" />
							<td class="inquire_item6" id="design_line_num_td"><span class="red_star">*</span>设计测线条数：</td>
							<td class="inquire_form6" id="item1_0">
								<input type="text" id="design_line_num" name="design_line_num" class="input_width" />&nbsp;条</td>
							<td class="inquire_item6" id="design_object_workload1_td">
								<input type="radio" id="workload1" name="workload" value="1" checked="checked" />
								<span class="red_star">*</span>设计实物工作量：</td>
							<td class="inquire_form6" id="item1_1">
								<input type="text" id="design_workload1" name="design_workload1" class="input_width" />&nbsp;km</td>
							<td class="inquire_item6" id="design_object_workload2_td">
								<input type="radio" id="workload2" name="workload" value="2" />
								<span class="red_star">*</span>设计满覆盖工作量：</td>
							<td class="inquire_form6" id="item1_22">
								<input type="text" id="design_workload2" name="design_workload2" class="input_width" />&nbsp;km</td>
						</tr>
						<tr>
							<td class="inquire_item6"><span class="red_star">*</span>设计试验炮：</td>
							<td class="inquire_form6" id="item1_2">
								<input type="text" id="full_fold_workload" name="full_fold_workload" class="input_width" />&nbsp;炮</td>
							<td class="inquire_item6"><span class="red_star">*</span>设计检波点数：</td>
							<td class="inquire_form6" id="item1_3">
								<input type="text" id="design_geophone_num" name="design_geophone_num" class="input_width" />&nbsp;个</td>
							<td class="inquire_item6"><span class="red_star">*</span>设计炮数：</td>
							<td class="inquire_form6" id="item1_4"><input type="text"
								id="design_sp_num" name="design_sp_num" class="input_width" />&nbsp;炮</td>
						</tr>
						<tr>
							<td class="inquire_item6" id="item1_5_title"
								style="display: block;"><span class="red_star">*</span>设计震源炮数：</td>
							<td class="inquire_form6" id="item1_5" style="display: block;"><input
								type="text" id="design_sp_num_zy" name="design_sp_num_zy"
								class="input_width" />&nbsp;炮</td>
							<td class="inquire_item6"><span class="red_star">*</span>小折射设计点数：</td>
							<td class="inquire_form6" id="item1_6"><input type="text"
								id="design_small_regraction_num"
								name="design_small_regraction_num" class="input_width" />&nbsp;个</td>
							<td class="inquire_item6"><span class="red_star">*</span>微测井设计点数：</td>
							<td class="inquire_form6" id="item1_7"><input type="text"
								id="design_micro_measue_num" name="design_micro_measue_num"
								class="input_width" />&nbsp;个</td>
						</tr>
						<tr id="tr1_9">
							<!-- <td class="inquire_item6" id="item1_8_title" style="display:block;"><span class="red_star">*</span>钻井设计点数：</td> -->
							<td class="inquire_item6" id="item1_8_title"
								style="display: block;"><span class="red_star">*</span>设计井炮炮数：</td>
							<td class="inquire_form6" id="item1_8" style="display: block;"><input
								type="text" id="design_drill_num" name="design_drill_num"
								class="input_width" />&nbsp;炮</td>
							<td class="inquire_item6"><span class="red_star">*</span>测量总公里数：</td>
							<td class="inquire_form6" id="item1_9"><input type="text"
								id="measure_km" name="measure_km" class="input_width" />&nbsp;km</td>
							<td class="inquire_item6" style="display: none;" id="item1_10_1"><span
								class="red_star">*</span>设计检波点面积：</td>
							<td class="inquire_form6" id="item1_10" style="display: none;"><input
								type="text" id="design_geophone_area"
								name="design_geophone_area" class="input_width" />&nbsp;km²</td>
						</tr>
						<tr style="display: none;" id="tr1_10">
							<td class="inquire_item6" id="item1_11_1"><span
								class="red_star">*</span>设计有资料面积：</td>
							<td class="inquire_form6" id="item1_11"><input type="text"
								id="design_data_area" name="design_data_area"
								class="input_width" />&nbsp;km²</td>
							<td class="inquire_item6"><span class="red_star">*</span>设计施工面积：</td>
							<td class="inquire_form6" id="item1_133">
								<input type="text" id="design_execution_area" name="design_execution_area" class="input_width" />&nbsp;km²</td>
							<td class="inquire_item6">&nbsp;</td>
							<td class="inquire_form6">
								<input type="hidden" id="design_sp_area" name="design_sp_area" class="input_width" />&nbsp;</td>
						</tr>
					</table>
				</div>
				<div id="tab_box_content7" class="tab_box_content" style="display: none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr>
							<td class="inquire_item4"><span class="red_star">*</span>地质任务：</td>
							<td colspan="3" class="inquire_form4">
								<textarea id="notes" name="notes" cols="45" rows="5" class="textarea"></textarea></td>
						</tr>
					</table>
				</div>
			</form>
			<form action="" id="workareaForm" name="workareaForm" method="post">
				<div id="tab_box_content3" class="tab_box_content" style="display: none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr>
							<input id="workarea_no" name="workarea_no" type="hidden" />
							<input type="hidden" id="project_info_no1" name="project_info_no1" />
							<td class="inquire_item6"><span class="red_star">*</span>工区名称：</td>
							<td class="inquire_form6">
								<input id="workarea" name="workarea" class="input_width" type="text" />
								<input id="start_year" name="start_year" class="input_width" type="hidden" /></td>
							<td class="inquire_item6"><span class="red_star">*</span>盆地：</td>
							<td class="inquire_form6">
								<input id="basin" name="basin" class="input_width" type="text" />
							</td>
							<td class="inquire_item6"><span class="red_star">*</span>区块（矿权）：</td>
							<td class="inquire_form6">
								<input name="block" id="block" value="" type="hidden" class="input_width" />
								<input id="spare2" name="spare2" class="input_width" type="text" readonly="readonly" />
							</td>
						</tr>
						<tr>
							<td class="inquire_item6"><span class="red_star">*</span>所属行政区:</td>
							<td class="inquire_form6"><input id="region_name" name="region_name" class="input_width" type="text" /></td>
							<td class="inquire_item6"><span class="red_star">*</span>主要地表类型：</td>
							<td class="inquire_form6"><select id="surface_type" name="surface_type" class="select_width"></select></td>
							<td class="inquire_item6"><span class="red_star">*</span>次要地表类型:</td>
							<td class="inquire_form6"><select id="second_surface_type" name="second_surface_type" class="select_width"></select></td>
						</tr>
						<tr>
							<td class="inquire_item6"><span class="red_star">*</span>工区中心经度：</td>
							<td class="inquire_form6"><input id="focus_x" name="focus_x" class="input_width" type="text" /></td>
							<td class="inquire_item6"><span class="red_star">*</span>工区中心纬度:</td>
							<td class="inquire_form6"><input id="focus_y" name="focus_y" class="input_width" type="text" /></td>
							<td class="inquire_item6"><span class="red_star">*</span>作物区类型：</td>
							<td class="inquire_form6"><select id="crop_area_type" name="crop_area_type" class="select_width"></select></td>
						</tr>
						<tr>
							<td class="inquire_item6"><span class="red_star">*</span>国家:</td>
							<td class="inquire_form6"><input id="country" name="country" class="input_width" type="hidden" />
								<input id="country_name" name="country_name" class="input_width" type="text" readonly="readonly" />
							</td>
							<td class="inquire_item6"></td>
							<td class="inquire_form6"></td>
							<td class="inquire_item6"></td>
							<td class="inquire_form6"></td>
						</tr>
					</table>
				</div>
			</form>
			<div id="tab_box_content4" class="tab_box_content" style="display: none;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr>
						<td class="inquire_item6">&nbsp;</td>
						<td class="inquire_form6" id="item4_0">&nbsp;</td>
						<td class="inquire_item6">&nbsp;</td>
						<td class="inquire_form6">&nbsp;</td>
						<td class="inquire_item6">&nbsp;</td>
						<td class="inquire_form6">&nbsp;</td>
					</tr>
				</table>
			</div>
			<div id="tab_box_content5" class="tab_box_content" style="display: none;"></div>
			<div id="tab_box_content6" class="tab_box_content" style="display: none;"></div>
			<form action="" id="qualityForm" name="qualityForm" method="post">
				<div id="tab_box_content2" class="tab_box_content"
					style="display: none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr align="right" height="30"></tr>
						<input type="hidden" id="project_info_no2" name="project_info_no2" />
						<input type="hidden" id="object_id" name="object_id" />
					</table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr>
							<td class="inquire_item4">一级品率≧</td>
							<td class="inquire_form4"><input id="firstlevel_radio" name="firstlevel_radio" class="input_width" />&nbsp;%</td>
							<td class="inquire_item4"><span class="red_star">*</span>合格品率≧</td>
							<td class="inquire_form4"><input id="qualified_radio" name="qualified_radio" class="input_width" />&nbsp;%</td>
						</tr>
						<tr>
							<td class="inquire_item4"><span class="red_star">*</span>废品率≦</td>
							<td class="inquire_form4"><input id="waster_radio" name="waster_radio" class="input_width" />&nbsp;%</td>
							<td class="inquire_item4">&nbsp;</td>
							<td class="inquire_form4">&nbsp;</td>
						</tr>
						<tr>
							<td class="inquire_item4" id="item2_0">空炮率≦</td>
							<td class="inquire_form4"><input id="miss_radio" name="miss_radio" class="input_width" />&nbsp;%</td>
							<td class="inquire_item4"><span class="red_star">*</span>全工区空炮率≦</td>
							<td class="inquire_form4"><input id="all_miss_radio" name="all_miss_radio" class="input_width" />&nbsp;%</td>
						</tr>
						<tr>
							<td class="inquire_item4"><span class="red_star"></span>表层调查成果合格率</td>
							<td class="inquire_form4"><input id="surface_radio" name="surface_radio" class="input_width" />&nbsp;%</td>
							<td class="inquire_item4"><span class="red_star"></span>测量成果合格率</td>
							<td class="inquire_form4"><input id="survey_radio" name="survey_radio" class="input_width" />&nbsp;%</td>
						</tr>
						<tr>
							<td class="inquire_item4"><span class="red_star"></span>现场处理剖面合格率</td>
							<td class="inquire_form4"><input id="profile_radio" name="profile_radio" class="input_width" />&nbsp;%</td>
							<td class="inquire_item4">&nbsp;</td>
							<td class="inquire_form4">&nbsp;</td>
						</tr>
					</table>
				</div>
			</form>
			<div id="tab_box_content8" class="tab_box_content" style="display: none;">
				<iframe width="100%" height="100%" name="codeManager"
					id="codeManager" frameborder="0" src="" marginheight="0"
					marginwidth="0" scrolling="auto" style="overflow: auto;"></iframe>
			</div>
			<div id="tab_box_content9" class="tab_box_content" style="display: none;">
				<iframe width="100%" height="100%" name="remark" id="remark"
					frameborder="0" src="" marginheight="0" marginwidth="0"
					scrolling="auto" style="overflow: auto;"></iframe>
			</div>
			<div id="tab_box_content11" class="tab_box_content" style="display: none;">
				<iframe width="100%" height="100%" name="deployDiagram"
					id="deployDiagram" frameborder="0" src="" marginheight="0"
					marginwidth="0" scrolling="auto" style="overflow: auto;"></iframe>
			</div>
			<div id="tab_box_content12" class="tab_box_content" style="display: none;">
				<iframe width="100%" height="100%" name=measurement id="measurement"
					frameborder="0" src="" marginheight="0" marginwidth="0"
					scrolling="auto" style="overflow: auto;"></iframe>
			</div>
		</div>
	</div>

</body>
<script type="text/javascript">
var projectStatus1 = new Array(
		['5000100001000000001','项目启动'],
		['5000100001000000002','正在施工'],
		['5000100001000000003','项目结束'],
		['5000100001000000004','项目暂停'],
		['5000100001000000005','施工结束']
		);

function frameSize(){
	setTabBoxHeight();
}
frameSize();

$(function(){
	$(window).resize(function(){
  		frameSize();
	});
	var optionhtml = getCodeList();
	$("#projecttype").html("");
	$("#projecttype").append("<option value='' selected='selected'>--请选择--</option>");
	$("#projecttype").append(optionhtml);

	var optionhtml1 = getCodeList1();
	$("#projectstatus").html("");
	$("#projectstatus").append("<option value='' selected='selected'>--请选择--</option>");
	$("#projectstatus").append(optionhtml1);
})	

$(document).ready(lashen);
</script>

<script type="text/javascript">
	//debugger;
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "DeviceUseSrv";
	cruConfig.queryOp = "queryProject";
	var orgSubjectionId= "<%=orgSubId%>";
	var projectType= "<%=projectType%>";
	
	// 复杂查询
	function refreshData(q_projectName, q_projectYear, q_projectType, q_isMainProject, q_projectStatus, q_orgName, q_orgSubjectionId,q_explorationMethod,q_projectArea){	
		cruConfig.submitStr = "projectType="+q_projectType+"&orgSubjectionId="+q_orgSubjectionId+"&projectName="+q_projectName+"&projectYear="+q_projectYear+"&isMainProject="+q_isMainProject+"&projectStatus="+q_projectStatus
			+"&orgName="+q_orgName+"&explorationMethod="+q_explorationMethod+"&projectArea="+q_projectArea;		
		queryData(1);
	}

	refreshData("", "", "", "", "", "", "<%=orgSubId%>","","");
	// 简单查询
	function simpleRefreshData(){
		var q_projectName = $("#projectName").val();
		var orgSubjectionId = $("#s_orgSubjectionId").val();
		var project_type= $("#projecttype").val();
		var project_status= $("#projectstatus").val();
		refreshData(q_projectName, "",project_type , "", project_status, "", orgSubjectionId,"","");
	}

	function clearQueryText(){
		document.getElementById("projectName").value = '';
		$("#s_orgSubjectionId").val("1");
		$("#project_type").val("0");
	}
	
	function loadDataDetail(ids){
	    if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
		clearLoadData();
		var retObj = jcdpCallService("ProjectSrvOld", "getProjectInfo", "projectInfoNo="+ids);
		document.getElementById("task_log_id").value= retObj.task_log_id;
		document.getElementById("project_info_no").value= retObj.map.project_info_no;
		document.getElementById("project_info_no1").value= retObj.map.project_info_no;
		document.getElementById("project_info_no2").value= retObj.map.project_info_no;
		document.getElementById("project_name").value= retObj.map.project_name;
		document.getElementById("project_id").value= retObj.map.project_id;
		document.getElementById("project_year").value= retObj.map.project_year;
		document.getElementById("start_year").value= retObj.map.project_year;
		document.getElementById("acquire_start_time").value= retObj.map.acquire_start_time;
		document.getElementById("acquire_end_time").value= retObj.map.acquire_end_time;
		document.getElementById("design_start_date").value= retObj.map.design_start_date;
		document.getElementById("design_end_date").value= retObj.map.design_end_date;
		
		//根据bulid_method的值设置显示信息
		var buildMethod = retObj.map.build_method;
		//井炮
		if(retObj.map.build_method == "5000100003000000001"){
			document.getElementById("item1_5_title").style.display="none";
			document.getElementById("item1_5").style.display="none";
			
			document.getElementById("item1_8_title").style.display="none";
			document.getElementById("item1_8").style.display="none";
		}else if(retObj.map.build_method == "5000100003000000005"){//井炮/气枪
			document.getElementById("item1_5_title").style.display="none";
			document.getElementById("item1_5").style.display="none";
			document.getElementById("item1_8_title").style.display="none";
			document.getElementById("item1_8").style.display="none";
		}else if(retObj.map.build_method == "5000100003000000002"){//震源
			document.getElementById("item1_8_title").style.display="none";
			document.getElementById("item1_8").style.display="none";			
			document.getElementById("item1_5_title").style.display="none";
			document.getElementById("item1_5").style.display="none";
		}else if(retObj.map.build_method == "5000100003000000006"){//震源/气枪
			document.getElementById("item1_8_title").style.display="none";
			document.getElementById("item1_8").style.display="none";			
			document.getElementById("item1_5_title").style.display="none";
			document.getElementById("item1_5").style.display="none";
		}else if(retObj.map.build_method == "5000100003000000004"){//井炮/震源
			document.getElementById("item1_8_title").style.display="block";
			document.getElementById("item1_8").style.display="block";			
			document.getElementById("item1_5_title").style.display="block";
			document.getElementById("item1_5").style.display="block";
		}else if(retObj.map.build_method == "5000100003000000007"){//井炮/震源/气枪
			document.getElementById("item1_8_title").style.display="block";
			document.getElementById("item1_8").style.display="block";			
			document.getElementById("item1_5_title").style.display="block";
			document.getElementById("item1_5").style.display="block";
		}
		
		document.getElementById("prctr_name").value= retObj.map.prctr_name;
		document.getElementById("prctr").value= retObj.map.prctr;
		document.getElementById("manage_org").value= retObj.map.manage_org;
		document.getElementById("manage_org_name").value= retObj.map.manage_org_name;
		document.getElementById("market_classify").value= retObj.map.market_classify;
		document.getElementById("market_classify_name").value= retObj.map.market_classify_name;
		document.getElementById("notes").value= retObj.map.notes;		
		document.getElementById("project_dynamic_no").value= retObj.dynamicMap.project_dynamic_no;
		document.getElementById("full_fold_workload").value= retObj.dynamicMap.full_fold_workload;
		document.getElementById("design_object_workload").value= retObj.dynamicMap.design_object_workload;
		document.getElementById("design_geophone_num").value= retObj.dynamicMap.design_geophone_num;
		document.getElementById("design_sp_num").value= retObj.dynamicMap.design_sp_num;
		document.getElementById("design_small_regraction_num").value= retObj.dynamicMap.design_small_regraction_num;
		document.getElementById("design_micro_measue_num").value= retObj.dynamicMap.design_micro_measue_num;
		document.getElementById("design_drill_num").value= retObj.dynamicMap.design_drill_num;
		document.getElementById("vsp_team_leader").value= retObj.map.vsp_team_leader;
		document.getElementById("org_id").value= retObj.dynamicMap.org_id;
		document.getElementById("org_name").value= retObj.dynamicMap.org_name;
		document.getElementById("measure_km").value= retObj.dynamicMap.measure_km;
		document.getElementById("design_sp_num_zy").value= retObj.dynamicMap.design_sp_num_zy;
		
		if( retObj.bgpMap != null && retObj.bgpMap.bgp_report_no != null) {
			document.getElementById("bgp_report_no").value= retObj.bgpMap.bgp_report_no;
			document.getElementById("processing_unit").value= retObj.bgpMap.processing_unit;
		}
		
		var workarea_no = retObj.map.workarea_no;
		var sel = document.getElementById("project_type").options;
		var value = retObj.map.project_type;
		for(var i=0;i<sel.length;i++){
		    if(value==sel[i].value){
		       document.getElementById('project_type').options[i].selected=true;
		    }
		}
		
		sel = document.getElementById("project_status").options;
		value = retObj.map.project_status;
		for(var i=0;i<sel.length;i++){
		    if(value==sel[i].value){
		       document.getElementById('project_status').options[i].selected=true;
		    }
		}
		
		sel = document.getElementById("exploration_method").options;
		value = retObj.map.exploration_method;
		for(var i=0;i<sel.length;i++){
		    if(value==sel[i].value){
		       document.getElementById('exploration_method').options[i].selected=true;
		    }
		}
		
		sel = document.getElementById("project_business_type").options;
		value = retObj.map.project_business_type;
		for(var i=0;i<sel.length;i++){
		    if(value==sel[i].value){
		       document.getElementById('project_business_type').options[i].selected=true;
		    }
		}
		sel = document.getElementById("is_main_project").options;
		value = retObj.map.is_main_project;
		for(var i=0;i<sel.length;i++){
		    if(value==sel[i].value){
		       document.getElementById('is_main_project').options[i].selected=true;
		    }
		}
		sel = document.getElementById("project_country").options;
		value = retObj.map.project_country;
		for(var i=0;i<sel.length;i++){
		    if(value==sel[i].value){
		       document.getElementById('project_country').options[i].selected=true;
		    }
		}
		sel = document.getElementById("explore_type").options;
		value = retObj.map.explore_type;
		for(var i=0;i<sel.length;i++){
		    if(value==sel[i].value){
		       document.getElementById('explore_type').options[i].selected=true;
		    }
		}
		sel = document.getElementById("build_method").options;
		value = retObj.map.build_method;
		for(var i=0;i<sel.length;i++){
		    if(value==sel[i].value){
		       document.getElementById('build_method').options[i].selected=true;
		    }
		}

		var exploration_method= retObj.map.exploration_method;
			expMethod = exploration_method;
		if(exploration_method == "0300100012000000002"){
			document.getElementById("design_line_num_td").innerHTML= '<span class="red_star">*</span>设计测线条数：';
			document.getElementById("item1_0").innerHTML= '<input type="text" id="design_line_num" name="design_line_num" class="input_width" />&nbsp;条';
			document.getElementById("design_line_num").value= retObj.dynamicMap.design_line_num;			
			document.getElementById("design_object_workload1_td").innerHTML= '<span class="red_star">*</span><input type="radio" id="workload1" name="workload" value="1" checked="checked"/>设计实物工作量：';
			document.getElementById("item1_1").innerHTML= '<input type="text" id="design_workload1" name="design_workload1" class="input_width" />&nbsp;km';
			document.getElementById("design_workload1").value= retObj.dynamicMap.design_workload1;			
			document.getElementById("design_object_workload2_td").innerHTML= '<span class="red_star">*</span><input type="radio" id="workload2" name="workload" value="2"/>设计满覆盖工作量：';
			document.getElementById("item1_22").innerHTML= '<input type="text" id="design_workload2" name="design_workload2" class="input_width" />&nbsp;km';
			document.getElementById("design_workload2").value= retObj.dynamicMap.design_workload2;			
			document.getElementById("item1_10_1").style.display="none";
			document.getElementById("item1_10").style.display="none";
			document.getElementById("item1_11").style.display="none";
			document.getElementById("item1_11_1").style.display="none";
			document.getElementById("tr1_10").style.display="none";
		} else if(exploration_method == "0300100012000000003"){
			document.getElementById("design_line_num_td").innerHTML= '<span class="red_star">*</span>设计线束数：';
			document.getElementById("item1_0").innerHTML= '<input type="text" id="design_line_num" name="design_line_num" class="input_width" />&nbsp;束';
			document.getElementById("design_line_num").value= retObj.dynamicMap.design_line_num;			
			document.getElementById("design_object_workload1_td").innerHTML= '<span class="red_star">*</span><input type="radio" id="workload1" name="workload" value="1" checked="checked"/>设计激发点面积：';
			document.getElementById("item1_1").innerHTML= '<input type="text" id="design_workload1" name="design_workload1" class="input_width" />&nbsp;km²';
			document.getElementById("design_workload1").value= retObj.dynamicMap.design_workload1;			
			document.getElementById("design_object_workload2_td").innerHTML= '<span class="red_star">*</span><input type="radio" id="workload2" name="workload" value="2"/>设计偏前满覆盖面积：';
			document.getElementById("item1_22").innerHTML= '<input type="text" id="design_workload2" name="design_workload2" class="input_width" />&nbsp;km²';
			document.getElementById("design_workload2").value= retObj.dynamicMap.design_workload2;			
			document.getElementById("design_geophone_area").value= retObj.dynamicMap.design_geophone_area;
			document.getElementById("design_execution_area").value= retObj.dynamicMap.design_execution_area;
			document.getElementById("design_data_area").value= retObj.dynamicMap.design_data_area;
			document.getElementById("design_sp_area").value= retObj.dynamicMap.design_sp_area;			
			document.getElementById("item1_10_1").style.display="block";
			document.getElementById("item1_10").style.display="block";
			document.getElementById("item1_11").style.display="block";
			document.getElementById("item1_11_1").style.display="block";
			document.getElementById("tr1_10").style.display="block";
		}
		
		if(retObj.dynamicMap.workload == "2"){
			document.getElementById("workload2").checked  = true;
		} else {
			document.getElementById("workload1").checked  = true;
		}
		
		//部署图
		document.getElementById("deployDiagram").src = "<%=contextPath%>/pm/deployDiagram/deployDiagramList.jsp?projectInfoNo="+ids;	
		//分类码
		document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=3&relationId="+ids;				
		$("#measurement")[0].src = "<%=contextPath%>/pm/measurement/measurementList.jsp?projectInfoNo="+ids;

		
		var retObj = jcdpCallService("WorkAreaSrv", "getSurfaceType", "");
		var retCrop = jcdpCallService("WorkAreaSrv", "getCropreaType", "");
		var selectTag = document.getElementById("surface_type");
		while(selectTag.hasChildNodes()){
			selectTag.removeChild(selectTag.firstChild);
    	}

		var selectTag2 = document.getElementById("second_surface_type");
		while(selectTag2.hasChildNodes()){
			selectTag2.removeChild(selectTag2.firstChild);
   		}
		var selectTag3 = document.getElementById("crop_area_type");
		while(selectTag3.hasChildNodes()){
			selectTag3.removeChild(selectTag3.firstChild);
   		}
		
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
			for(var i=0;i<sel.length;i++){
		    	if(value==sel[i].value){
		       		document.getElementById('surface_type').options[i].selected=true;
		    	}
			}
			sel = document.getElementById("second_surface_type").options;
			value = retWorkArea.workarea.second_surface_type;
			for(var i=0;i<sel.length;i++){
		    	if(value==sel[i].value){
		     	  	document.getElementById('second_surface_type').options[i].selected=true;
		    	}
			}
			sel = document.getElementById("crop_area_type").options;
			value = retWorkArea.workarea.crop_area_type;
			for(var i=0;i<sel.length;i++){
		    	if(value==sel[i].value){
		      	 	document.getElementById('crop_area_type').options[i].selected=true;
		    	}
			}
		}
		
		//质量指标
		var retQuality = jcdpCallService("ProjectSrvOld", "getQuality", "projectInfoNo="+ids);
		if(exploration_method == "0300100012000000002"){
			document.getElementById("item2_0").innerHTML= '<span class="red_star">*</span>单线空炮率≦';
		}else {
			document.getElementById("item2_0").innerHTML= '单束线空炮率≦';
		}
		if(retQuality != null && retQuality.qualityMap != null){
			document.getElementById("object_id").value = retQuality.qualityMap.objectId;
			document.getElementById("firstlevel_radio").value = retQuality.qualityMap.firstlevelRadio;
			document.getElementById("qualified_radio").value = retQuality.qualityMap.qualifiedRadio;
			document.getElementById("waster_radio").value = retQuality.qualityMap.wasterRadio;
			document.getElementById("miss_radio").value = retQuality.qualityMap.missRadio;
			document.getElementById("all_miss_radio").value = retQuality.qualityMap.allMissRadio;
			document.getElementById("surface_radio").value = retQuality.qualityMap.surfaceRadio;
			document.getElementById("survey_radio").value = retQuality.qualityMap.surveyRadio;
			document.getElementById("profile_radio").value = retQuality.qualityMap.profileRadio;
		}
		
		// 备注
		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;
	}
	
	function clearLoadData(){
		document.getElementById("project_info_no").value= "";
		document.getElementById("project_info_no1").value= "";
		document.getElementById("project_info_no2").value= "";
		document.getElementById("project_name").value= "";
		document.getElementById("project_id").value= "";
		document.getElementById("project_year").value= "";
		document.getElementById("start_year").value= "";
		document.getElementById("acquire_start_time").value= "";
		document.getElementById("acquire_end_time").value= "";
		document.getElementById("design_start_date").value= "";
		document.getElementById("design_end_date").value= "";
		document.getElementById("prctr_name").value= "";
		document.getElementById("prctr").value= "";
		document.getElementById("manage_org").value= "";
		document.getElementById("manage_org_name").value= "";
		document.getElementById("market_classify").value= "";
		document.getElementById("market_classify_name").value= "";
		document.getElementById("notes").value= "";		
		document.getElementById("project_dynamic_no").value= "";
		document.getElementById("full_fold_workload").value= "";
		document.getElementById("design_geophone_num").value= "";
		document.getElementById("design_sp_num").value= "";
		document.getElementById("design_small_regraction_num").value= "";
		document.getElementById("design_micro_measue_num").value= "";
		document.getElementById("design_drill_num").value= "";
		document.getElementById("org_id").value= "";
		document.getElementById("org_name").value= "";
		document.getElementById("measure_km").value= "";		
		document.getElementById("bgp_report_no").value= "";
		document.getElementById("processing_unit").value= "";		
		document.getElementById("design_line_num").value= "";
		document.getElementById("design_object_workload").value= "";
		document.getElementById("design_workload1").value= "";
		document.getElementById("design_workload2").value= "";		
		document.getElementById("design_geophone_area").value= "";
		document.getElementById("design_execution_area").value= "";
		document.getElementById("design_data_area").value= "";
		document.getElementById("design_sp_area").value= "";
		document.getElementById("design_sp_num_zy").value= "";
		document.getElementById("workarea_no").value = "";
		document.getElementById("workarea").value = "";
		document.getElementById("start_year").value = "";
		document.getElementById("basin").value = "";
		document.getElementById("spare2").value = "";
		document.getElementById("region_name").value = ""
		document.getElementById("focus_x").value = "";
		document.getElementById("focus_y").value = "";
		document.getElementById("block").value = "";
		document.getElementById("country").value = "";
		document.getElementById("country_name").value = "";
		//质量指标
		document.getElementById("object_id").value = "";
		document.getElementById("firstlevel_radio").value = "";
		document.getElementById("qualified_radio").value = "";
		document.getElementById("waster_radio").value = "";
		document.getElementById("miss_radio").value = "";
		document.getElementById("all_miss_radio").value = ""
		document.getElementById("surface_radio").value = "";
		document.getElementById("survey_radio").value = "";
		document.getElementById("profile_radio").value = "";
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	//查询
	function toSearch(){
		popWindow('<%=contextPath%>/dmsManager/use/project_search.jsp?orgSubjectionId=<%=orgSubId%>');
	}
	//双击操作
	function dbclickRow(ids){
		location.href="<%=contextPath%>/pm/project/selectProject.srq?projectInfoNo="+ids;
		window.location.href="<%=contextPath%>/dmsManager/use/deviceUseInfo.jsp?project_info_id="+ids;
	}
	//项目类型
	function getCodeList(){
		var codeObj;
		var unitSql = "select coding_name,coding_code_id from comm_coding_sort_detail"
				    + " where coding_code_id in (select distinct t.project_type"
				    + " from gp_task_project t  where t.bsflag = '0') order by coding_code_id"; 

		var unitRet = syncRequest('Post',getContextPath()+appConfig.queryListAction,'querySql='+unitSql+'&pageSize=1000');
			codeObj = unitRet.datas;
		var optionhtml = "";
		for(var codeindex=0;codeindex<codeObj.length;codeindex++){
			if(codeObj[codeindex].coding_name!='陆地和浅海项目'){
				optionhtml +=  "<option name='code' id='code"+codeindex+"' value='"+codeObj[codeindex].coding_code_id+"'>"+codeObj[codeindex].coding_name+"</option>";
			}		
		}
		return optionhtml;
	}
	//项目状态
	function getCodeList1(){
		var codeObj1;
		var unitSql1 = "select coding_name,coding_code_id from comm_coding_sort_detail t where t.coding_sort_id='5000100001' and t.bsflag='0' order by t.coding_show_id ";

		var unitRet1 = syncRequest('Post',getContextPath()+appConfig.queryListAction,'querySql='+unitSql1+'&pageSize=1000');
			codeObj1 = unitRet1.datas;
		var optionhtml1 = "";
		for(var codeindex1=0;codeindex1<codeObj1.length;codeindex1++){
			optionhtml1 +=  "<option name='code1' id='code1"+codeindex1+"' value='"+codeObj1[codeindex1].coding_code_id+"'>"+codeObj1[codeindex1].coding_name+"</option>";
		}
		return optionhtml1;
	}
</script>
</html>
