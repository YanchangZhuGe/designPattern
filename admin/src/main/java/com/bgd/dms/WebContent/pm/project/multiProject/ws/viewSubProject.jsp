<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="java.util.*" %>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ taglib uri="code" prefix="code"%> 
<%@ taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@ page import="java.text.*" %>
<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	String isSingle=request.getParameter("isSingle");

	String projectInfoNo=request.getParameter("projectInfoNo");
	
	String projectYear=request.getParameter("projectYear")==null?"":java.net.URLDecoder.decode(request.getParameter("projectYear"),"utf-8");
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" media="all" />
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
</head>

<body style="background:#fff">
      	<div id="list_table"  >
			<div id="tag-container_3">
			  <ul id="tags" class="tags"0>
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">工区信息</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">其他信息</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box" >
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" id="Offsettable">
					  <tr>
					    <td class="inquire_item6"><span class="red_star">*</span>项目名称：</td>
					    <td class="inquire_form6" id="item0_0">
					    <input type="hidden" id="project_info_no" name="project_info_no" /><input type="text" id="project_name" name="project_name" class="input_width" />
					    <input type="hidden" id="project_father_no" name="project_father_no" value="" class="input_width" />
					    </td>
					    <td class="inquire_item6">项目编号：</td>
					    <td class="inquire_form6" id="item0_1"><input type="text" id="project_id" name="project_id" class="input_width_no_color"  disabled="disabled" readOnly="readonly"/></td>
					    <td class="inquire_item6">项目类型：</td>
					    <td class="inquire_form6" id="item0_2">
					    	<code:codeSelect cssClass="select_width"  name='project_type' option="projectType"  selectedValue=""  addAll="true" />
					    </td>
					  </tr>
					  <tr>
							<td class="inquire_item6"><span class="red_star">*</span>井号：</td>
							<td class="inquire_form6" id="item0_9"><input type="text"
									id="well_no" name="well_no" value=""
									class="input_width" /></td>
							<td class="inquire_item6"><span class="red_star">*</span>预测价值工作量：</td>
							<td class="inquire_form6" id="item0_9"><input type="text"
									id="project_income" name="project_income" value=""
									class="input_width" />万元
							</td>
							<td class="inquire_item6"></td>
							<td class="inquire_item6"></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">年度：</td>
					    <td class="inquire_form6" id="item0_5">
					    	<input id="project_year" name="project_year" value="<%=projectYear%>" type="text" class="input_width_no_color" readonly="readonly"/>
					    </td>
					    <td class="inquire_item6">合同金额：</td>
					    <td class="inquire_form6" id="item0_1">
					    	<input type="text" id="contract_amount" name="contract_amount" class="input_width_no_color"  />万元
					    </td>
					    <td class="inquire_item6"></td>
						<td class="inquire_item6"></td>
					  </tr>
					  <tr>
					   	<td class="inquire_item6"><span class="red_star">*</span>项目重要程度：</td>
					    <td class="inquire_form6" id="item0_5">
					    	<code:codeSelect cssClass="select_width"   name='is_main_project' option="isMainProject" selectedValue=""  addAll="true" />
					    </td>
					    <td class="inquire_item6">甲方交井时间：</td>
					    <td class="inquire_form6" id="item0_3">
						    <input type="text" id="start_time" name="start_time" value="" class="input_width" readonly="readonly"/>
							&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(start_time,tributton1);" />
						</td>
					    <td class="inquire_item6">完工时间：</td>
					    <td class="inquire_form6" id="item0_4">
						    <input type="text" id="end_time" name="end_time" value="" class="input_width" readonly="readonly"/>
							&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(end_time,tributton2);" />
					    </td>
					  </tr>
					  
					  <tr>
						<td class="inquire_item6"><span class="red_star">*</span>甲方单位：</td>
					    <td class="inquire_form6" id="item0_4">
					    	<input type="hidden" id="manage_org" name="manage_org" class="input_width" readonly="readonly"/>
					    	<input type="text" id="manage_org_name" name="manage_org_name" class="input_width" />
					    	<img src="<%= request.getContextPath() %>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectManageOrgCode('manage_org','manage_org_name');" />
					    </td>
					    <td class="inquire_item6"><span class="red_star">*</span>项目业务类型：</td>
					    <td class="inquire_form6" id="item0_5">
					    	<code:codeSelect cssClass="select_width"   name='project_business_type' option="projectBusinessType"  selectedValue=""  addAll="true" />
					    </td>
					    <td class="inquire_item6">国内/国外：</td>
					    <td class="inquire_form6" id="item0_3">
					    	<select class="select_width" name="project_country" id="project_country">
								<option value='1'>国内</option>
								<option value='2'>国外</option>
							</select>
					    </td>
					  </tr>
					  
					  <tr>
					    <td class="inquire_item6">利润中心：</td>
					    <td class="inquire_form6" id="item0_3">
					    	<input type="hidden" id="prctr" name="prctr" value="" class="input_width" />
							<input type="text" id="prctr_name" name="prctr_name" value="" class="input_width"  readonly="readonly"/>
							<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectPrctr()" />
					    </td>
					    <td class="inquire_item6"><span class="red_star">*</span>施工队伍：</td>
						<td class="inquire_form6">
							<input id="org_id" name="org_id" value="" type="hidden" class="input_width" />
							<input id="org_name" name="org_name" value="" type="text" class="input_width_no_color" readonly="readonly"/>
						</td>
					    <td class="inquire_item6"><span class="red_star">*</span>带队领导：</td>
					    <td class="inquire_form6">
					    	<input type="text" id="project_man" name="project_man" value="" class="input_width" />
					    </td>
					  </tr>
					  <tr>
						<td class="inquire_item6"><span class="red_star">*</span>常规项目：</td>
					    <td class="inquire_form6">
					    	<input type="radio" name="project_common" id="project_common1" value="1" />常规项目&nbsp;&nbsp;
							<input type="radio" name="project_common" id="project_common0"  value="0" />非常规项目
						</td>
						<td class="inquire_item6">&nbsp;</td>
						<td class="inquire_item6">&nbsp;</td>
						<td class="inquire_item6">&nbsp;</td>
						<td class="inquire_item6">&nbsp;</td>
					  </tr>
					  <tr>
					    <td class="inquire_item6"><span class="red_star">*</span>激发方式：</td>
					    <td class="inquire_form6" colspan="5">
					    	<input type="hidden" id="build_method" name="build_method" value="" class="input_width" />
							<input type="checkbox" name="build_method_name" value="5000100003000000001" id="5000100003000000001">井炮&nbsp;&nbsp;</input>
							<input type="checkbox" name="build_method_name" value="5000100003000000002" id="5000100003000000002">震源&nbsp;&nbsp;</input>
							<input type="checkbox" name="build_method_name" value="5000100003000000003" id="5000100003000000003">气枪&nbsp;&nbsp;</input>
							<input type="checkbox" name="build_method_name" value="5000100003000000010" id="5000100003000000010">井下扫描源&nbsp;&nbsp;</input>
							<input type="checkbox" name="build_method_name" value="5000100003000000011" id="5000100003000000011">井下脉冲源&nbsp;&nbsp;</input>
						</td>
					  </tr>
					  <tr>
						<input type="hidden" id="build_type" name="build_type" value="" class="input_width" />
						<td class="inquire_item6"><span class="red_star">*</span>激发设备型号：</td>
						<td colspan="3"><input type="radio" name="build_type" id="build_type_1"  value="zy"/>可控震源型号<input id="source_version" name="source_version" type="text" />可控震源台数<input id="source_num" name="source_num" type="text" /></td>
					  </tr>
					  <tr>
						<td class="inquire_item6"></td>
						<td colspan="3"><input type="radio" name="build_type" id="build_type_2"  value="zj"/>钻井型号<input id="drill_version" name="drill_version" type="text" /> 钻机台数<input id="drill_depth" name="drill_depth" type="text" /></td>
					  </tr>
					  <tr>
						<td class="inquire_item6"></td>
						<td colspan="3"><input type="radio" name="build_type" id="build_type_3"  value="qt"/>其他设备型号<input id="qt_version" name="qt_version" type="text" /> 其他设备数量<input id="qt_num" name="qt_num" type="text" /></td>
					  </tr>
					  <tr>
						<td class="inquire_item6">仪器型号：</td>
						<td class="inquire_item6"><input type="text"
							id="instrument_model" name="instrument_model" value=""
							class="input_width" />
						</td>
						<td class="inquire_item6">仪器级数：</td>
						<td class="inquire_item6"><input type="text"
							id="instrument_level" name="instrument_level" value=""
							class="input_width" />
						</td>
						<td class="inquire_item6">动迁车辆(台)：</td>
						<td class="inquire_item6"><input type="text"
							id="relocation_vehicle" name="relocation_vehicle" value=""
							class="input_width" />
						</td>
					</tr>
					<tr>
						<td class="inquire_item6">完钻井深(米)：</td>
						<td class="inquire_item6"><input type="text"
							id="total_depth" name="total_depth" value=""
							class="input_width" />
						</td>
						<td class="inquire_item6">最大井斜深度(度)：</td>
						<td class="inquire_item6"><input type="text"
							id="well_deviation_depth" name="well_deviation_depth" value=""
							class="input_width" />
						</td>
						<td class="inquire_item6">最大井深(米)：</td>
						<td class="inquire_item6"><input type="text"
							id="max_well_depth" name="max_well_depth" value=""
							class="input_width" />
						</td>
					</tr>
					
					<tr>
						<td class="inquire_item6">最大井温(℃)：</td>
						<td class="inquire_item6"><input type="text"
								id="well_temperature" name="well_temperature" value=""
								class="input_width" />
						</td>
						<td class="inquire_item6">井压力：</td>
						<td class="inquire_item6"><input type="text"
							id="well_pressure" name="well_pressure" value=""
							class="input_width" />
						</td>
						<td class="inquire_item6"></td>
						<td class="inquire_item6"></td>
					</tr>
					  <tr>
							<td class="inquire_item6">井身结构：</td>
							<td class="" colspan="5">
							套管井段：<input type="text" id="drivepipe_depth" name="drivepipe_depth" value=""  />
							最小套管尺寸：<input type="text" id="drivepipe_size" name="drivepipe_size" value=""  />
							裸眼井段：<input type="text" id="open_hole_depth" name="open_hole_depth" value="" />
							</td>
						</tr>
							
					  <tr>
							<td class="inquire_item6"><span class="red_star">*</span>观测类型：</td>
							<td colspan="5">
								<input type="hidden" id="view_type" name="view_type" value="" class="input_width" />
								<input type="hidden" id="zero_h_val" />
								<input type="hidden" id="zero_z_val" />
								<input type="hidden" id="offset_vsp_val" />
								<input type="hidden" id="walkaway_vsp_val" />
								<input type="hidden" id="walkaround_vsp_val" />
								<input type="hidden" id="3d_vsp_val" />
								<input type="hidden" id="micro_vsp_val" />
								<input type="hidden" id="wdzdmjc_vsp_val" />
								<input type="hidden" id="sdzj_vsp_val" />
								<input type="checkbox" name="zero_h" value="5110000053000000000" id="zero_h_0"/>零偏横波VSP
								&nbsp;观测井段(米)<input type="text" id="zero_h_view_well_0"/>观测点距离(米)<input type="text" id="zero_h_view_point_0"/>采集级数(级)<input type="text" id="zero_h_acquire_level_0" />
							</td>
						</tr>
							
						<tr>
							<td class="inquire_item6"></td>
							<td colspan="5">
								<input type="checkbox" name="zero_z" value="5110000053000000001" id="zero_z_0"/>零偏纵波VSP
								&nbsp;观测井段(米)<input type="text" id="zero_z_view_well_0"/>观测点距离(米)<input type="text"  id="zero_z_view_point_0"/>采集级数(级)<input type="text" id="zero_z_acquire_level_0" />
							</td>
						</tr>
							
						<tr>
							<td class="inquire_item6"></td>
							<td colspan="5">
								<input type="checkbox" name="offset_vsp" value="5110000053000000002" id="offset_vsp_0"/>非零偏VSP
								&nbsp;&nbsp;&nbsp;&nbsp;观测井段(米)<input type="text" id="offset_vsp_view_well_0"/>观测点距离(米)<input type="text"  id="offset_vsp_view_point_0"/>采集级数(级)<input type="text" id="offset_vsp_acquire_level_0" />
							</td>
						</tr>
							
							
						<tr>
							<td class="inquire_item6"></td>
							<td colspan="5">
								<input type="checkbox" name="walkaway_vsp" value="5110000053000000003" id="walkaway_vsp_0"/>Walkaway-VSP&nbsp;&nbsp;&nbsp;
								&nbsp;&nbsp;&nbsp;&nbsp;观测井段(米)<input type="text" id="walkaway_vsp_view_well_0"/>观测点距离(米)<input type="text"  id="walkaway_vsp_view_point_0"/>采集级数(级)<input type="text" id="walkaway_vsp_acquire_level_0" />
							</td>
						</tr>
					
					<tr>
						<td class="inquire_item6"></td>
						<td colspan="5">
							<input type="checkbox" name="walkaround_vsp" value="5110000053000000004" id="walkaround_vsp_0"/>Walkaround-VSP
							&nbsp;&nbsp;&nbsp;&nbsp;观测井段(米)<input type="text" id="walkaround_vsp_view_well_0"/>观测点距离(米)<input type="text"  id="walkaround_vsp_view_point_0"/>采集级数(级)<input type="text" id="walkaround_vsp_acquire_level_0" />
						</td>
					</tr>
					
					<tr>
						<td class="inquire_item6"></td>
						<td colspan="5">
							<input type="checkbox" name="3d_vsp" value="5110000053000000005" id="3d_vsp_0"/>3D-VSP&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;观测井段(米)<input type="text" id="3d_vsp_view_well_0"/>观测点距离(米)<input type="text"  id="3d_vsp_view_point_0"/>采集级数(级)<input type="text" id="3d_vsp_acquire_level_0" />
						</td>
					</tr>
					
					<tr>
						<td class="inquire_item6"></td>
						<td colspan="5">
							<input type="checkbox" name="micro_vsp" value="5110000053000000006" id="micro_vsp_0"/>微地震井中监测&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;观测井段(米)<input type="text" id="micro_vsp_view_well_0"/>观测点距离(米)<input type="text"  id="micro_vsp_view_point_0"/>采集级数(级)<input type="text" id="micro_vsp_acquire_level_0" />
						</td>
					</tr>
					
					
					<tr>
						<td class="inquire_item6"></td>
						<td colspan="5">
							<input type="checkbox" name="wdzdmjc_vsp" value="5110000053000000007" id="wdzdmjc_vsp_0"/>微地震地面监测
							接收线数(线)<input type="text" id="wdzdmjc_vsp_view_well_0"/>道距(米)<input type="text"  id="wdzdmjc_vsp_view_point_0"/>总接收道数(道)<input type="text" id="wdzdmjc_vsp_acquire_level_0" />
						</td>
					</tr>
					
					<tr>
						<td class="inquire_item6"></td>
						<td colspan="5">
							<input type="checkbox" name="sdzj_vsp" value="5110000053000000008" id="sdzj_vsp_0"/>随钻地震&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							接收线数(线)<input type="text" id="sdzj_vsp_view_well_0"/>道距(米)<input type="text"  id="sdzj_vsp_view_point_0"/>总接收道数(道)<input type="text" id="sdzj_vsp_acquire_level_0" />
						</td>
					</tr>
					
					<tr>
						<td class="inquire_item6"></td>
						<td colspan="5">
							<input type="checkbox" name="view_type_name" value="5110000053000000009" id="5110000053000000009"/>井间地震&nbsp;&nbsp;
							<input type="checkbox" name="view_type_name" value="5110000053000000010" id="5110000053000000010"/>井地联合勘探&nbsp;&nbsp;
							<input type="checkbox" name="view_type_name" value="5110000053000000011" id="5110000053000000011"/>其他&nbsp;&nbsp;
							<input type="text" name="" id=""/>
						</td>
					</tr>
					
					
					
					 <tr>
						<td class="inquire_item6"></td>
						<td colspan="5">
							
						</td>
					</tr>
					 <tr>
						<td class="inquire_item6"></td>
						<td colspan="5">
							
						</td>
					</tr> <tr>
						<td class="inquire_item6"></td>
						<td colspan="5">
							
						</td>
					</tr> <tr>
						<td class="inquire_item6"></td>
						<td colspan="5">
							
						</td>
					</tr> <tr>
						<td class="inquire_item6"></td>
						<td colspan="5">
							
						</td>
					</tr> <tr>
						<td class="inquire_item6"></td>
						<td colspan="5">
							
						</td>
					</tr>
					</table>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					    <tr>
					      <td class="inquire_item6"><span class="red_star">*</span>施工地区：</td>
					      <td class="inquire_form6"><input id="workarea"  name="workarea"class="input_width" type="text" /><input id="start_year" name="start_year" class="input_width" type="hidden" /></td>
					      <td class="inquire_item6">区块（矿权）：</td>
					      <td class="inquire_form6">
					       <input id="workarea_no" name="workarea_no"type="hidden" /><input type="hidden" id="project_info_no1" name="project_info_no1" />
					      	<input name="block" id="block" value="" type="hidden" class="input_width" />
					      	<input id="spare2"  name="spare2"class="input_width" type="text"  readonly="readonly"/>
					      	<img src="<%= request.getContextPath() %>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectCoding('0300100011','block','spare2');" />
					      </td>
					      <td class="inquire_item6">所属行政区:</td>
					      <td class="inquire_form6" >
					       <input id="region_name"  name="region_name"class="input_width" type="text" />
					      </td>
					    </tr>
					    <tr>
					      <td class="inquire_item6"><span class="red_star">*</span>主要地表类型：</td>
					      <td class="inquire_form6" ><select id="surface_type" name="surface_type" class="select_width"></select></td>
					      <td class="inquire_item6"><span class="red_star">*</span>次要地表类型:</td>
					      <td class="inquire_form6"><select id="second_surface_type" name="second_surface_type" class="select_width"></select></td>
					      <td class="inquire_item6"><span class="red_star">*</span>作物区类型：</td>
					      <td class="inquire_form6" ><select id="crop_area_type" name="crop_area_type" class="select_width"></select></td>
					     </tr>
					     <tr>
					      
					      <td class="inquire_item6"><span class="red_star">*</span>国家:</td>
					      <td class="inquire_form6">
					      	<input id="country"  name="country" class="input_width" type="hidden" />
					      	<input id="country_name"  name="country_name" class="input_width" type="text"  readonly="readonly"/>
					      	&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectCoding('0200100001','country','country_name');" />
					      </td>
					      <td></td>
					     </tr>
					</table>
				</div>
				
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateProject()"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		            </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr>
						<td class="inquire_item6">地理位置：</td>
						<td class="inquire_form6" colspan="3">
						<input type="text" class="input_width" id="geographic_position" name="geographic_position" value=""  />
						</td>
					</tr>
					
					<tr>
						<td class="inquire_item6">搬迁路线及总距离：</td>
						<td colspan="3" class="inquire_form4">
						<textarea id="route_distance"  name="route_distance" cols="45" rows="5" class="textarea"></textarea>
						</td>
					</tr>
					<tr>
						<td class="inquire_item6">施工风险评估及<br />控制措施：</td>
						<td colspan="3" class="inquire_form4">
						<textarea id="control_measures_1"  name="control_measures_1" cols="45" rows="5" class="textarea"></textarea>
						</td>
					</tr>
					<tr>
						<td class="inquire_item6">可能影响施工效率<br/>的原因分析及控制<br />措施：</td>
						<td colspan="3" class="inquire_form4">
						<textarea id="control_measures_2"  name="control_measures_2" cols="45" rows="5" class="textarea"></textarea>
						</td>
					</tr>
					</table>
				</div>
				
			</div>
		  </div>

</body>

<script type="text/javascript">
   
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	var isSingle = "<%=isSingle%>"
	var projectInfoNo = "<%=projectInfoNo%>"
	
	var retObj = jcdpCallService("WsProjectSrv", "getProjectDetail", "projectInfoNo="+projectInfoNo+"&isson=true");

	//常规/非常规
    var pc =retObj.map.project_common;
    if(""!=pc&&null!=pc){
   		document.getElementById("project_common"+pc).checked = true;
    }	
	//
	
    var bt =retObj.map.build_type;
    if(bt=="zy"){
   		document.getElementById("build_type_1").checked = true;
   		document.getElementById("source_version").value= retObj.map.build_type_version;
		document.getElementById("source_num").value= retObj.map.build_type_num;
    }
    if(bt=="zj"){
    	document.getElementById("build_type_2").checked = true;
    	document.getElementById("drill_version").value= retObj.map.build_type_version;
		document.getElementById("drill_depth").value= retObj.map.build_type_num;
    }
	if(bt=="qt"){
		document.getElementById("build_type_3").checked = true;
		document.getElementById("qt_version").value= retObj.map.build_type_version;
		document.getElementById("qt_num").value= retObj.map.build_type_num;
	}
	
    document.getElementById("project_father_no").value= retObj.map.project_father_no;
	document.getElementById("project_info_no").value= retObj.map.project_info_no;

	document.getElementById("project_name").value= retObj.map.project_name;
	document.getElementById("project_id").value= retObj.map.project_id;
	document.getElementById("project_year").value= retObj.map.project_year;
	document.getElementById("start_year").value= retObj.map.project_year;
	document.getElementById("start_time").value= retObj.map.start_time;
	document.getElementById("end_time").value= retObj.map.end_time;
	document.getElementById("contract_amount").value= retObj.map.contract_amount;
	document.getElementById("project_man").value= retObj.map.project_man;
	document.getElementById("prctr_name").value= retObj.map.prctr_name;
	document.getElementById("prctr").value= retObj.map.prctr;
	document.getElementById("manage_org").value= retObj.map.manage_org;
	document.getElementById("manage_org_name").value= retObj.map.manage_org_name;
	/* document.getElementById("source_version").value= retObj.map.source_version;
	document.getElementById("source_num").value= retObj.map.source_num;
	document.getElementById("drill_version").value= retObj.map.drill_version;
	document.getElementById("drill_depth").value= retObj.map.drill_depth; */
	
	
	document.getElementById("org_id").value= retObj.dynamicMap.org_id;
	document.getElementById("org_name").value= retObj.dynamicMap.org_name;
	
	document.getElementById("well_no").value= retObj.map.well_no;
	
	
	document.getElementById("project_income").value= retObj.map.project_income;
	document.getElementById("instrument_model").value= retObj.map.instrument_model;
	document.getElementById("instrument_level").value= retObj.map.instrument_level;
	document.getElementById("relocation_vehicle").value= retObj.map.relocation_vehicle;
	document.getElementById("total_depth").value= retObj.map.total_depth;
	document.getElementById("well_deviation_depth").value= retObj.map.well_deviation_depth;
	document.getElementById("max_well_depth").value= retObj.map.max_well_depth;
	document.getElementById("well_temperature").value= retObj.map.well_temperature;
	document.getElementById("well_pressure").value= retObj.map.well_pressure;
	document.getElementById("drivepipe_depth").value= retObj.map.drivepipe_depth;
	document.getElementById("drivepipe_size").value= retObj.map.drivepipe_size;
	document.getElementById("open_hole_depth").value= retObj.map.open_hole_depth;
	document.getElementById("geographic_position").value= retObj.map.geographic_position;
	document.getElementById("route_distance").value= retObj.map.route_distance;
	document.getElementById("control_measures_1").value= retObj.map.control_measures_1;
	document.getElementById("control_measures_2").value= retObj.map.control_measures_2;
	
	//激发方式checkbox赋值
	checkboxArray = document.getElementsByName("build_method_name");
    vt=retObj.map.build_method;
    if(""!=vt&&null!=vt){
	    var vts = vt.split(","); 
	    for (i=0;i<vts.length ;i++ )   
	    {
	    	 for (j=0;j<checkboxArray.length ;j++ )   
	 	    {
	    		if(vts[i]==checkboxArray[j].value){
	    			document.getElementById(vts[i]).checked = true;   
	    		}	    		
	 	    }
	    }   
    }
    
    
	
	

	var workarea_no = retObj.map.workarea_no;
	//工区信息
	if(workarea_no != null && workarea_no != ""){
		var retWorkArea = jcdpCallService("WorkAreaSrv", "getWorkarea", "workareaNo="+workarea_no);
		document.getElementById("workarea_no").value = workarea_no;
		document.getElementById("workarea").value = retWorkArea.workarea.workarea;
		document.getElementById("start_year").value = retWorkArea.workarea.start_year;
		//document.getElementById("basin").value = retWorkArea.workarea.basin;
		document.getElementById("spare2").value = retWorkArea.workarea.spare2;
		document.getElementById("region_name").value = retWorkArea.workarea.region_name;
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
	

	//项目类型
	var sel = document.getElementById("project_type").options;
	var value = retObj.map.project_type;
	for(var i=0;i<sel.length;i++)
	{
	    if(value==sel[i].value)
	    {
	       document.getElementById('project_type').options[i].selected=true;
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
	
	
	
	//观测类型
	var count1=0;
	var count2=0;
	var count3=0;
	var count4=0;
	var count5=0;
	
	var count6=0;
	var count7=0;
	var count8=0;
	var count9=0;
	var ids;
	var retObj_view_type = jcdpCallService("WsProjectSrv", "queryViewType", "projectInfoNo="+projectInfoNo);
	var allRows = retObj_view_type.datas.length;
	for(var i=0;i<allRows;i++){
		var record = retObj_view_type.datas[i];
		var view_type_code = record.view_type_code;
		
		if(view_type_code=="5110000053000000000"){
			count1++;
			if(count1==1){
				document.getElementById("zero_h_0").checked="true";
				document.getElementById("zero_h_view_well_0").value=record.view_well;
				document.getElementById("zero_h_view_point_0").value=record.view_point;
				document.getElementById("zero_h_acquire_level_0").value=record.acquire_level;
			}else{
				ids = toCopy('zero_h').split("_");
				document.getElementById("zero_h_"+ids[0]).checked="true";
				document.getElementById("zero_h_view_well_"+ids[0]).value=record.view_well;
				document.getElementById("zero_h_view_point_"+ids[0]).value=record.view_point;
				document.getElementById("zero_h_acquire_level_"+ids[0]).value=record.acquire_level;
			}
		}
		
		if(view_type_code=="5110000053000000001"){
			count2++;
			if(count2==1){
				document.getElementById("zero_z_0").checked="true";
				document.getElementById("zero_z_view_well_0").value=record.view_well;
				document.getElementById("zero_z_view_point_0").value=record.view_point;
				document.getElementById("zero_z_acquire_level_0").value=record.acquire_level;
			}else{
				ids = toCopy('zero_z').split("_");
				document.getElementById("zero_z_"+ids[1]).checked="true";
				document.getElementById("zero_z_view_well_"+ids[1]).value=record.view_well;
				document.getElementById("zero_z_view_point_"+ids[1]).value=record.view_point;
				document.getElementById("zero_z_acquire_level_"+ids[1]).value=record.acquire_level;
			}
		}
		
		if(view_type_code=="5110000053000000002"){
			count3++;
			if(count3==1){
				document.getElementById("offset_vsp_0").checked="true";
				document.getElementById("offset_vsp_view_well_0").value=record.view_well;
				document.getElementById("offset_vsp_view_point_0").value=record.view_point;
				document.getElementById("offset_vsp_acquire_level_0").value=record.acquire_level;
			}else{
				ids = toCopy('offset_vsp').split("_");
				document.getElementById("offset_vsp_"+ids[2]).checked="true";
				document.getElementById("offset_vsp_view_well_"+ids[2]).value=record.view_well;
				document.getElementById("offset_vsp_view_point_"+ids[2]).value=record.view_point;
				document.getElementById("offset_vsp_acquire_level_"+ids[2]).value=record.acquire_level;
			}
		}
		
		
		
		if(view_type_code=="5110000053000000003"){
			count4++;
			if(count4==1){
				document.getElementById("walkaway_vsp_0").checked="true";
				document.getElementById("walkaway_vsp_view_well_0").value=record.view_well;
				document.getElementById("walkaway_vsp_view_point_0").value=record.view_point;
				document.getElementById("walkaway_vsp_acquire_level_0").value=record.acquire_level;
			}else{
				ids = toCopy('walkaway_vsp').split("_");
				document.getElementById("walkaway_vsp_"+ids[3]).checked="true";
				document.getElementById("walkaway_vsp_view_well_"+ids[3]).value=record.view_well;
				document.getElementById("walkaway_vsp_view_point_"+ids[3]).value=record.view_point;
				document.getElementById("walkaway_vsp_acquire_level_"+ids[3]).value=record.acquire_level;
			}
		}
		if(view_type_code=="5110000053000000004"){
			count5++;
			if(count5==1){
				document.getElementById("walkaround_vsp_0").checked="true";
				document.getElementById("walkaround_vsp_view_well_0").value=record.view_well;
				document.getElementById("walkaround_vsp_view_point_0").value=record.view_point;
				document.getElementById("walkaround_vsp_acquire_level_0").value=record.acquire_level;
			}else{
				ids = toCopy('walkaround_vsp').split("_");
				document.getElementById("walkaround_vsp_"+ids[4]).checked="true";
				document.getElementById("walkaround_vsp_view_well_"+ids[4]).value=record.view_well;
				document.getElementById("walkaround_vsp_view_point_"+ids[4]).value=record.view_point;
				document.getElementById("walkaround_vsp_acquire_level_"+ids[4]).value=record.acquire_level;
			}
		}
		if(view_type_code=="5110000053000000005"){
			count6++;
			if(count6==1){
				document.getElementById("3d_vsp_0").checked="true";
				document.getElementById("3d_vsp_view_well_0").value=record.view_well;
				document.getElementById("3d_vsp_view_point_0").value=record.view_point;
				document.getElementById("3d_vsp_acquire_level_0").value=record.acquire_level;
			}else{
				ids = toCopy('3d_vsp').split("_");
				document.getElementById("3d_vsp_"+ids[5]).checked="true";
				document.getElementById("3d_vsp_view_well_"+ids[5]).value=record.view_well;
				document.getElementById("3d_vsp_view_point_"+ids[5]).value=record.view_point;
				document.getElementById("3d_vsp_acquire_level_"+ids[5]).value=record.acquire_level;
			}
		}
		if(view_type_code=="5110000053000000006"){
			count7++;
			if(count7==1){
				document.getElementById("micro_vsp_0").checked="true";
				document.getElementById("micro_vsp_view_well_0").value=record.view_well;
				document.getElementById("micro_vsp_view_point_0").value=record.view_point;
				document.getElementById("micro_vsp_acquire_level_0").value=record.acquire_level;
			}else{
				ids = toCopy('micro_vsp').split("_");
				document.getElementById("micro_vsp_"+ids[6]).checked="true";
				document.getElementById("micro_vsp_view_well_"+ids[6]).value=record.view_well;
				document.getElementById("micro_vsp_view_point_"+ids[6]).value=record.view_point;
				document.getElementById("micro_vsp_acquire_level_"+ids[6]).value=record.acquire_level;
			}
		}
		if(view_type_code=="5110000053000000007"){
			count8++;
			if(count8==1){
				document.getElementById("wdzdmjc_vsp_0").checked="true";
				document.getElementById("wdzdmjc_vsp_view_well_0").value=record.view_well;
				document.getElementById("wdzdmjc_vsp_view_point_0").value=record.view_point;
				document.getElementById("wdzdmjc_vsp_acquire_level_0").value=record.acquire_level;
			}else{
				ids = toCopy('wdzdmjc_vsp').split("_");
				document.getElementById("wdzdmjc_vsp_"+ids[7]).checked="true";
				document.getElementById("wdzdmjc_vsp_view_well_"+ids[7]).value=record.view_well;
				document.getElementById("wdzdmjc_vsp_view_point_"+ids[7]).value=record.view_point;
				document.getElementById("wdzdmjc_vsp_acquire_level_"+ids[7]).value=record.acquire_level;
			}
		}
		if(view_type_code=="5110000053000000008"){
			count9++;
			if(count9==1){
				document.getElementById("sdzj_vsp_0").checked="true";
				document.getElementById("sdzj_vsp_view_well_0").value=record.view_well;
				document.getElementById("sdzj_vsp_view_point_0").value=record.view_point;
				document.getElementById("sdzj_vsp_acquire_level_0").value=record.acquire_level;
			}else{
				ids = toCopy('sdzj_vsp').split("_");
				document.getElementById("sdzj_vsp_"+ids[8]).checked="true";
				document.getElementById("sdzj_vsp_view_well_"+ids[8]).value=record.view_well;
				document.getElementById("sdzj_vsp_view_point_"+ids[8]).value=record.view_point;
				document.getElementById("sdzj_vsp_acquire_level_"+ids[8]).value=record.acquire_level;
			}
		}
		if(view_type_code=="5110000053000000009"){
			document.getElementById("5110000053000000009").checked="true";
		}
		if(view_type_code=="5110000053000000010"){
			document.getElementById("5110000053000000010").checked="true";
		}
	}
	
	count1=0;
	count2=0;
	count3=0;
	count4=0;
	count5=0;
	count6=0;
	count7=0;
	count8=0;
	count9=0;
	
    
    var index_offset_vsp = 1;
	var index_zero_h = 1;
	var index_zero_z = 1;
	var index_walkaway = 1;
	var index_walkaround = 1;
	var index_3d = 1;
	var index_micro = 1;
	var index_wdzdmjc = 1;//微地震地面监测
	var index_sdzj = 1;   //随钻地震
	function toCopy(id){
		var index;
		var trid ;
		var rowNum = document.getElementById("Offsettable").rows.length;
		var count_1 = document.getElementsByName('zero_z').length;
		var count_2 = document.getElementsByName('offset_vsp').length;
		var count_3 = document.getElementsByName('walkaway_vsp').length;
		var count_4 = document.getElementsByName('walkaround_vsp').length;
		var count_5 = document.getElementsByName('3d_vsp').length;
		var count_6 = document.getElementsByName('micro_vsp').length;
		var count_7 = document.getElementsByName('wdzdmjc_vsp').length;
		var count_8 = document.getElementsByName('sdzj_vsp').length;
		if(id=='zero_h'){
			index = rowNum-1-count_1-count_2-count_3-count_4-count_5-count_6-count_7-count_8;
			trid=id+index_zero_h;
		}
		
		if(id=='zero_z'){
			index = rowNum-1-count_2-count_3-count_4-count_5-count_6-count_7-count_8;
			trid=id+index_zero_z;
		}
		
		if(id=='offset_vsp'){
			index = rowNum-1-count_3-count_4-count_5-count_6-count_7-count_8;
			trid=id+index_offset_vsp;
		}
		
		if(id=='walkaway_vsp'){
			index = rowNum-1-count_4-count_5-count_6-count_7-count_8;
			trid=id+index_walkaway;
		}
		
		if(id=='walkaround_vsp'){
			index = rowNum-1-count_5-count_6-count_7-count_8;
			trid=id+index_walkaround;
		}
		
		if(id=='3d_vsp'){
			index = rowNum-1-count_6-count_7-count_8;
			trid=id+index_3d;
		}
		
		if(id=='micro_vsp'){
			index = rowNum-1-count_7-count_8;
			trid=id+index_micro;
		}
		
		if(id=='wdzdmjc_vsp'){
			index = rowNum-1-count_8;
			trid=id+index_wdzdmjc;
		}
		
		if(id=='sdzj_vsp'){
			index = rowNum-1;
			trid=id+index_sdzj;
		}
		
		var tr = document.getElementById("Offsettable").insertRow(index);
		tr.id=trid;
		tr.className="tr_del";
		var td = tr.insertCell();
		td.innerHTML="&nbsp;&nbsp;";
		td = tr.insertCell();
		td.colSpan="5";
		var html1 = "<input type=\"checkbox\" checked=\"true\" onclick=\"return false;\"  name=\"zero_h\" value=\"5110000053000000000\" id=\"zero_h_"+index_zero_h+"\" />零偏横波VSP&nbsp;&nbsp;观测井段(米)<input type=\"text\" id=\"zero_h_view_well_"+index_zero_h+"\"/>观测点距离(米)<input type=\"text\" id=\"zero_h_view_point_"+index_zero_h+"\"/>采集级数(级)<input type=\"text\" id=\"zero_h_acquire_level_"+index_zero_h+"\"/>";
		var html2 = "<input type=\"checkbox\" checked=\"true\" onclick=\"return false;\"  name=\"zero_z\" value=\"5110000053000000001\" id=\"zero_z_"+index_zero_z+"\" />零偏纵波VSP&nbsp;&nbsp;观测井段(米)<input type=\"text\" id=\"zero_z_view_well_"+index_zero_z+"\"/>观测点距离(米)<input type=\"text\" id=\"zero_z_view_point_"+index_zero_z+"\"/>采集级数(级)<input type=\"text\" id=\"zero_z_acquire_level_"+index_zero_z+"\"/>";
		var html3 = "<input type=\"checkbox\" checked=\"true\" onclick=\"return false;\"  name=\"offset_vsp\" value=\"5110000053000000002\" id=\"offset_vsp_"+index_offset_vsp+"\" />非零偏VSP&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;观测井段(米)<input type=\"text\" id=\"offset_vsp_view_well_"+index_offset_vsp+"\"/>观测点距离(米)<input type=\"text\" id=\"offset_vsp_view_point_"+index_offset_vsp+"\"/>采集级数(级)<input type=\"text\" id=\"offset_vsp_acquire_level_"+index_offset_vsp+"\"/>";
		var html4 = "<input type=\"checkbox\" checked=\"true\" onclick=\"return false;\"  name=\"walkaway_vsp\" value=\"5110000053000000003\" id=\"walkaway_vsp_"+index_walkaway+"\" />Walkaway-VSP&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;观测井段(米)<input type=\"text\" id=\"walkaway_vsp_view_well_"+index_walkaway+"\"/>观测点距离(米)<input type=\"text\" id=\"walkaway_vsp_view_point_"+index_walkaway+"\"/>采集级数(级)<input type=\"text\" id=\"walkaway_vsp_acquire_level_"+index_walkaway+"\"/>";
		var html5 = "<input type=\"checkbox\" checked=\"true\" onclick=\"return false;\"  name=\"walkaround_vsp\" value=\"5110000053000000004\" id=\"walkaround_vsp_"+index_walkaround+"\" />Walkaround-VSP&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;观测井段(米)<input type=\"text\" id=\"walkaround_vsp_view_well_"+index_walkaround+"\"/>观测点距离(米)<input type=\"text\" id=\"walkaround_vsp_view_point_"+index_walkaround+"\"/>采集级数(级)<input type=\"text\" id=\"walkaround_vsp_acquire_level_"+index_walkaround+"\"/>";
		var html6 = "<input type=\"checkbox\" checked=\"true\" onclick=\"return false;\"  name=\"3d_vsp\" value=\"5110000053000000005\" id=\"3d_vsp_"+index_3d+"\" />3D-VSP&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;观测井段(米)<input type=\"text\" id=\"3d_vsp_view_well_"+index_3d+"\"/>观测点距离(米)<input type=\"text\" id=\"3d_vsp_view_point_"+index_3d+"\"/>采集级数(级)<input type=\"text\" id=\"3d_vsp_acquire_level_"+index_3d+"\"/>";
		var html7 = "<input type=\"checkbox\" checked=\"true\" onclick=\"return false;\"  name=\"micro_vsp\" value=\"5110000053000000006\" id=\"micro_vsp_"+index_micro+"\" />微地震井中监测&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;观测井段(米)<input type=\"text\" id=\"micro_vsp_view_well_"+index_micro+"\"/>观测点距离(米)<input type=\"text\" id=\"micro_vsp_view_point_"+index_micro+"\"/>采集级数(级)<input type=\"text\" id=\"micro_vsp_acquire_level_"+index_micro+"\"/>";
		var html8 = "<input type=\"checkbox\" checked=\"true\" onclick=\"return false;\"  name=\"wdzdmjc_vsp\" value=\"5110000053000000007\" id=\"wdzdmjc_vsp_"+index_wdzdmjc+"\" />微地震地面监测&nbsp;接收线数(线)<input type=\"text\" id=\"wdzdmjc_vsp_view_well_"+index_wdzdmjc+"\"/>道距(米)<input type=\"text\" id=\"wdzdmjc_vsp_view_point_"+index_wdzdmjc+"\"/>总接收道数(道)<input type=\"text\" id=\"wdzdmjc_vsp_acquire_level_"+index_wdzdmjc+"\"/>";
		var html9 = "<input type=\"checkbox\" checked=\"true\" onclick=\"return false;\"  name=\"sdzj_vsp\" value=\"5110000053000000008\" id=\"sdzj_vsp_"+index_sdzj+"\" />随钻地震&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;接收线数(线)<input type=\"text\" id=\"sdzj_vsp_view_well_"+index_sdzj+"\"/>道距(米)<input type=\"text\" id=\"sdzj_vsp_view_point_"+index_sdzj+"\"/>总接收道数(道)<input type=\"text\" id=\"sdzj_vsp_acquire_level_"+index_sdzj+"\"/>";
		
		var html;

		var returnStr = index_zero_h+"_"+index_zero_z+"_"+index_offset_vsp+"_"+index_walkaway+"_"+index_walkaround+"_"+index_3d+"_"+index_micro+"_"+index_wdzdmjc+"_"+index_sdzj;

		var html;
		if(id=="zero_h"){
			html=html1;
			td.innerHTML=html;
			index_zero_h++;
		}
		if(id=='zero_z'){
			html=html2;
			td.innerHTML=html;
			index_zero_z++;
		}
		if(id=='offset_vsp'){
			html=html3;
			td.innerHTML=html;
			index_offset_vsp++;
		}
		if(id=="walkaway_vsp"){
			html=html4;
			td.innerHTML=html;
			index_walkaway++;
		}
		if(id=="walkaround_vsp"){
			html=html5;
			td.innerHTML=html;
			index_walkaround++;
		}
		if(id=="3d_vsp"){
			html=html6;
			td.innerHTML=html;
			index_3d++;
		}
		if(id=="micro_vsp"){
			html=html7;
			td.innerHTML=html;
			index_micro++;
		}
		
		if(id=="wdzdmjc_vsp"){
			html=html8;
			td.innerHTML=html;
			index_wdzdmjc++;
		}
		
		if(id=="sdzj_vsp"){
			html=html9;
			td.innerHTML=html;
			index_sdzj++;
		}
		
		return returnStr;
	}
	
	
	var retObj = jcdpCallService("WorkAreaSrv", "getSurfaceType", "");  // 获取地表类型信息
	var retCrop = jcdpCallService("WorkAreaSrv", "getCropreaType", ""); // 获取作物区类型信息
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
</script>
</html>