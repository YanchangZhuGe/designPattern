<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="java.util.*" %>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@ page import="java.text.*" %>
<%
	String contextPath = request.getContextPath();

	String orgSubjectionId = "C105";
	if(request.getParameter("orgSubjectionId") != null){
		orgSubjectionId = request.getParameter("orgSubjectionId");
	}
	String orgId = "C6000000000001";
	if(request.getParameter("orgId") != null){
		orgId = request.getParameter("orgId");
	}
	
	String action = request.getParameter("action");
	if("".equals(action) || action == null){
		action = "edit";
	}
	
	String isSingle = request.getParameter("isSingle");
	if("".equals(isSingle) || isSingle == null){
		isSingle = "";
	}
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	
	String projectType=request.getParameter("projectType")==null?"":request.getParameter("projectType");
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
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<title>无标题文档</title>
</head>

<body style="background:#fff">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">项目名</td>
			    <td class="ali_cdn_input">
				    <input id="projectName" name="projectName" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleRefreshData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_query"></auth:ListButton>
			    <auth:ListButton functionId="F_PM_M_100" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="F_PM_M_003" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			  </tr>
			  
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <input type="hidden" id="orgSubjectionId" name="orgSubjectionId"  value="<%=orgSubjectionId %>" class="input_width" />
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{project_info_no}' id='rdo_entity_id_{project_info_no}' onclick=chooseOne(this) />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{project_name}<input type='hidden' id='projectName{project_info_no}' value='{project_name}'/>" >项目名称</td>
			      <td class="bt_info_odd" exp="{project_type}" func="getOpValue,projectType1">项目类型</td>
			      <td class="bt_info_even" exp="{project_status}"  func="getOpValue,projectStatus1">项目状态</td>
			      <td class="bt_info_odd" exp="{manage_org_name}">甲方单位</td>
			      <td class="bt_info_even" exp="{start_date}">采集开始时间</td>
			      <td class="bt_info_odd" exp="{end_date}">采集结束时间</td>
			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">工区信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">工作量</a></li>
			    <!-- 
			    <li id="tag3_6"><a href="#" onclick="getTab3(6)">施工方法</a></li> -->
			    <li id="tag3_7"><a href="#" onclick="getTab3(7)">地质任务</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">质量指标</a></li>
			    <!-- 
			    <li id="tag3_5"><a href="#" onclick="getTab3(5)">队伍信息</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">合同信息</a></li> 
			    -->
			    <li id="tag3_10"><a href="#" onclick="getTab3(10)">审批流程</a></li>
			    <li id="tag3_12"><a href="#" onclick="getTab3(12)">测量测算</a></li>
			    <li id="tag3_11"><a href="#" onclick="getTab3(11)">部署图</a></li>
			    <li id="tag3_8"><a href="#" onclick="getTab3(8)">分类码</a></li>
			    <li id="tag3_9"><a href="#" onclick="getTab3(9)">备注</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<form name="projectForm" id="projectForm"  method="post" action="">
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateProject()"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		              </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					  
					    <td class="inquire_item6"><span class="red_star">*</span>项目名称：</td>
					    <td class="inquire_form6" id="item0_0"><input type="hidden" id="project_info_no" name="project_info_no" /><input type="text" id="project_name" name="project_name" class="input_width" /></td>
					    <td class="inquire_item6">项目编号：</td>
					    <td class="inquire_form6" id="item0_1"><input type="text" id="project_id" name="project_id" class="input_width_no_color"  disabled="disabled" readOnly="readonly"/></td>
					    <td class="inquire_item6">项目类型：</td>
					    <td class="inquire_form6" id="item0_2">
					    	<select class="select_width" name="project_type" id="project_type">
					    		<option value=''></option>
					    	    <option value='5000100004000000001'>陆地项目</option>
								<option value='5000100004000000002'>浅海项目</option>
								<option value='5000100004000000010'>滩浅海过渡带</option>
							</select>
					    </td>
					  </tr>
					  <tr>
					    <td class="inquire_item6"><span class="red_star">*</span>项目状态：</td>
					    <td class="inquire_form6" id="item0_3">
					    	<code:codeSelect cssClass="select_width"  name='project_status' option="projectStatus"  selectedValue=""  addAll="true" />
					    </td>
					    <td class="inquire_item6"><span class="red_star">*</span>市场范围：</td>
					    <td class="inquire_form6" id="item0_4">
					    	<input id="market_classify" name="market_classify" value="" type="hidden" class="input_width" />
							<input id="market_classify_name" name="market_classify_name" value="" type="text" class="input_width" readonly="readonly"/>
							&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectMarketClassify()" /></td>
					    </td>
					    <td class="inquire_item6">年度：</td>
					    <td class="inquire_form6" id="item0_5">
					    	<select id="project_year" name="project_year" class="select_width">
						    <%
						    Date date = new Date();
						    int years = date.getYear()+ 1900 - 10;
						    int year = date.getYear()+1900;
						    for(int i=0; i<20; i++){
						    %>
						    <option value="<%=years %>" > <%=years %> </option>
						    <%
						    years++;
						    }
						     %>
						    </select>
					    </td>
					  </tr>
					  <tr>
					    <td class="inquire_item6"><span class="red_star">*</span>计划采集开始时间：</td>
					    <td class="inquire_form6" id="item0_3">
						    <input type="text" id="acquire_start_time" name="acquire_start_time" value="" class="input_width" readonly="readonly"/>
							&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acquire_start_time,tributton1);" />
						</td>
					    <td class="inquire_item6"><span class="red_star">*</span>计划采集结束时间：</td>
					    <td class="inquire_form6" id="item0_4">
						    <input type="text" id="acquire_end_time" name="acquire_end_time" value="" class="input_width" readonly="readonly"/>
							&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acquire_end_time,tributton2);" />
					    </td>
					    <td class="inquire_item6"><span class="red_star">*</span>项目重要程度：</td>
					    <td class="inquire_form6" id="item0_5">
					    	<code:codeSelect cssClass="select_width"   name='is_main_project' option="isMainProject" selectedValue=""  addAll="true" />
					    </td>
					  </tr>
					  <tr>
					    <td class="inquire_item6"><span class="red_star">*</span>合同开始时间：</td>
					    <td class="inquire_form6" id="item0_3">
							<input type="text" id="design_start_date" name="design_start_date" value="" class="input_width" readOnly="readonly"/>
							&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(design_start_date,tributton3);" />
						</td>
					    <td class="inquire_item6"><span class="red_star">*</span>合同结束时间：</td>
					    <td class="inquire_form6" id="item0_4">
						    <input type="text" id="design_end_date" name="design_end_date" value="" class="input_width" readOnly="readonly"/>
							&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(design_end_date,tributton4);" />
					    </td>
					  </tr>
					  <tr>
					  	<td class="inquire_item6"><span class="red_star">*</span>项目业务类型：</td>
					    <td class="inquire_form6" id="item0_5">
					    	<code:codeSelect cssClass="select_width"   name='project_business_type' option="projectBusinessType"  selectedValue=""  addAll="true" />
					    </td>
					    <td class="inquire_item6"><span class="red_star">*</span>施工队伍：</td>
						<td class="inquire_form6" id="item0_19">
							<input id="org_id" name="org_id" value="" type="hidden" class="input_width" />
							<input id="org_name" name="org_name" value="" type="text" class="input_width" />
							&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectTeam()" />
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
					  	<td class="inquire_item6"><span class="red_star">*</span>甲方单位：</td>
					    <td class="inquire_form6" id="item0_4">
					    	<input type="hidden" id="manage_org" name="manage_org" class="input_width" readonly="readonly"/>
					    	<input type="text" id="manage_org_name" name="manage_org_name" class="input_width" />
					    	<img src="<%= request.getContextPath() %>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectManageOrgCode('manage_org','manage_org_name');" />
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
					    <td class="inquire_form6" id="item0_3"><input type="hidden" id="bgp_report_no" name="bgp_report_no"/><input type="text" id="processing_unit" name="processing_unit" class="input_width" /></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6"><span class="red_star">*</span>勘探方法：</td>
					    <td class="inquire_form6">
					    	<select class=select_width name=exploration_method  id="exploration_method" onChange="changeExploration(this.value)">
								<option value="0300100012000000002">二维地震</option>
								<option value="0300100012000000003">三维地震</option>
								<!-- <option value="0300100012000000029">二维/三维</option> -->
							</select>
					    </td>
					  	<td class="inquire_item6"><span class="red_star">*</span>激发方式：</td>
					    <td class="inquire_form6">
					    	<select class=select_width name=build_method  id="build_method">
							</select>
						</td>
					    <td class="inquire_item6"><span class="red_star">*</span>利润中心：</td>
					    <td class="inquire_form6" id="item0_3">
					    	<input type="hidden" id="prctr" name="prctr" value="" class="input_width" />
							<input type="text" id="prctr_name" name="prctr_name" value="" class="input_width"  readonly="readonly"/>
							&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectPrctr()" />
					    </td>
					  </tr>
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateProject()"><a href="#"></a></span></td>
		                  <td width="5"><input type="hidden" id="project_dynamic_no" name="project_dynamic_no" /></td>
		                </tr>
		              </table>
		              <div id="workLoad3">
		              	<fieldSet style="margin:2px;padding:2px;"><legend>三维工作量</legend>
		              	<input type="hidden" id="work_load3" name="work_load3" value="1" />
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
					  	<input type="hidden" id="work_load2" name="work_load2" value="1" />
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
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateProject()"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		              </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					  	<td class="inquire_item4"><span class="red_star">*</span>地质任务：</td>
						<td colspan="3" class="inquire_form4"><textarea id="notes"  name="notes"cols="45" rows="5" class="textarea"></textarea></td>
						</tr>
					</table>
 
				</div>
				</form>
				<form action="" id="workareaForm" name="workareaForm" method="post">
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateWorkarea()"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		              </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					    <tr><input id="workarea_no"  name="workarea_no"type="hidden" /><input type="hidden" id="project_info_no1" name="project_info_no1" />
					      <td class="inquire_item6"><span class="red_star">*</span>工区名称：</td>
					      <td class="inquire_form6"><input id="workarea"  name="workarea"class="input_width" type="text" /><input id="start_year" name="start_year" class="input_width" type="hidden" /></td>
					      <td class="inquire_item6"><span class="red_star">*</span>盆地：</td>
					      <td class="inquire_form6"><input id="basin" name="basin" class="input_width" type="text" /></td>
					      <td class="inquire_item6"><span class="red_star">*</span>区块（矿权）：</td>
					      <td class="inquire_form6" >
					      	<input name="block" id="block" value="" type="hidden" class="input_width" />
					      	<input id="spare2"  name="spare2"class="input_width" type="text"  readonly="readonly"/>
					      	<img src="<%= request.getContextPath() %>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectCoding('0300100011','block','spare2');" />
					      </td>
					    </tr>
					    <tr>
					      <td class="inquire_item6"><span class="red_star">*</span>所属行政区:</td>
					      <td class="inquire_form6"><input id="region_name"  name="region_name"class="input_width" type="text" /></td>
					      <td class="inquire_item6"><span class="red_star">*</span>主要地表类型：</td>
					      <td class="inquire_form6" ><select id="surface_type" name="surface_type" class="select_width"></select></td>
					      <td class="inquire_item6"><span class="red_star">*</span>次要地表类型:</td>
					      <td class="inquire_form6"><select id="second_surface_type" name="second_surface_type" class="select_width"></select></td>
					     </tr>
					     <tr>
					      <td class="inquire_item6"><span class="red_star">*</span>工区中心经度：</td>
					      <td class="inquire_form6" ><input id="focus_x"  name="focus_x" class="input_width" type="text" /></td>
					      <td class="inquire_item6"><span class="red_star">*</span>工区中心纬度:</td>
					      <td class="inquire_form6" ><input id="focus_y"  name="focus_y"class="input_width" type="text" /></td>
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
					      <td class="inquire_item6"></td>
					      <td class="inquire_form6"></td>
					      <td class="inquire_item6"></td>
					      <td class="inquire_form6"></td>
					     </tr>
					</table>
				</div>
				</form>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
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
				<div id="tab_box_content5" class="tab_box_content" style="display:none;">
					
				</div>
				<div id="tab_box_content6" class="tab_box_content" style="display:none;">
			
				</div>
				<form action="" id="qualityForm" name="qualityForm" method="post">
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateQuality()"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		                <input type="hidden" id="project_info_no2" name="project_info_no2" />
		                <input type="hidden" id="object_id" name="object_id" />
		              </table>
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
				</form>
				<div id="tab_box_content8" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: auto;"></iframe>
				</div>
				<div id="tab_box_content9" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: auto;"></iframe>
				</div>
				<div id="tab_box_content10" class="tab_box_content" style="display:none;">
					<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>		
				</div>
				<div id="tab_box_content11" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="deployDiagram" id="deployDiagram" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: auto;"></iframe>
				</div>
				<div id="tab_box_content12" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name=measurement id="measurement" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: auto;"></iframe>
				</div>
			</div>
		  </div>

</body>
<script type="text/javascript">
var projectStatus1 = new Array(
		['5000100001000000001','项目启动'],['5000100001000000002','正在运行'],['5000100001000000003','项目结束'],['5000100001000000004','项目暂停'],['5000100001000000005','施工结束']
		);
var projectType1 = new Array(
		 ['5000100004000000001','陆地项目'],
		 ['5000100004000000008','井中项目'],
		 ['5000100004000000002','浅海项目'],
		 ['5000100004000000003','非地震项目'],
		 ['5000100004000000005','地震项目'],
		 ['5000100004000000006','深海项目'],
		 ['5000100004000000009','综合物化探'],
		 ['5000100004000000007','陆地和浅海项目'],
		 ['5000100004000000010','滩浅海过渡带']
		 );
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
</script>

<script type="text/javascript">
	//debugger;
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "ProjectSrv";
	cruConfig.queryOp = "queryProject";
	var orgSubjectionId= "<%=orgSubjectionId%>";
	var orgId="<%=orgId %>";
	var projectName="";
	var projectId="";
	var projectType="<%=projectType%>";
	var projectYear="";
	var isMainProject="";
	var projectStatus="";
	var orgName="";
	var expMethod = "";
	var buildMethod = "";
	// 复杂查询
	function refreshData(q_projectName, q_projectYear, q_projectType, q_isMainProject, q_projectStatus, q_orgName, q_orgSubjectionId,q_explorationMethod,q_projectArea){
		cruConfig.submitStr = "projectType="+q_projectType+"&orgSubjectionId="+q_orgSubjectionId+"&projectName="+q_projectName+"&projectYear="+q_projectYear+"&isMainProject="+q_isMainProject+"&projectStatus="+q_projectStatus+"&orgName="+q_orgName+"&explorationMethod="+q_explorationMethod+"&projectArea="+q_projectArea+"&isSingle=<%=isSingle %>";
		queryData(1);
	}

	refreshData("", "",projectType, "", "", "", "<%=orgSubjectionId%>","","");
	// 简单查询
	function simpleRefreshData(){
		var q_projectName = document.getElementById("projectName").value;
		refreshData(q_projectName,"",projectType, "", "", "", orgSubjectionId,"","");
	}

	function clearQueryText(){
		document.getElementById("projectName").value = '';
	}
	
	
	  //chooseOne()函式，參數為觸發該函式的元素本身   
    function chooseOne(cb){   
        //先取得同name的chekcBox的集合物件   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            //判斷obj集合中的i元素是否為cb，若否則表示未被點選   
            if (obj[i]!=cb) obj[i].checked = false;   
            //若是 但原先未被勾選 則變成勾選；反之 則變為未勾選   
            //else  obj[i].checked = cb.checked;   
            //若要至少勾選一個的話，則把上面那行else拿掉，換用下面那行   
            else obj[i].checked = true;   
        }   
    }   
	  
	  
	function loadDataDetail(ids){
		//var ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
		clearLoadData();
		var retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo="+ids);
		
	    processNecessaryInfo={         
	 		businessTableName:"gp_task_project",    //置入流程管控的业务表的主表表明
	 		businessType:"5110000004100001045",     //业务类型 即为之前设置的业务大类 5110000004100000082
	 		businessId:ids,         //业务主表主键值
	 		businessInfo:retObj.map.project_name+'大港物探处项目立项审批',        //用于待审批界面展示业务信息
	 		applicantDate:'<%=appDate%>'       //流程发起时间
   	    }; 
   	    processAppendInfo={ 
   			projectInfoNo: ids,
   			action:'view',
			projectName:retObj.map.project_name  		 
   	    };
   	    loadProcessHistoryInfo();
//debugger;
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

		//document.getElementById("transit_time").value= retObj.map.transit_time;
		
		document.getElementById("prctr_name").value= retObj.map.prctr_name;
		document.getElementById("prctr").value= retObj.map.prctr;
		document.getElementById("manage_org").value= retObj.map.manage_org;
		document.getElementById("manage_org_name").value= retObj.map.manage_org_name;
		document.getElementById("market_classify").value= retObj.map.market_classify;
		document.getElementById("market_classify_name").value= retObj.map.market_classify_name;
		document.getElementById("notes").value= retObj.map.notes;
		document.getElementById("org_id").value= retObj.dynamicMap.org_id;
		document.getElementById("org_name").value= retObj.dynamicMap.org_name;
		
		document.getElementById("project_dynamic_no").value= retObj.dynamicMap.project_dynamic_no;

		//加载激发方式
		this.changeExploration(retObj.map.exploration_method);
		//-----------------------------工作量-----------------------------------------
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
			document.getElementById("area"+index).checked = 'checked';
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
			document.getElementById("length"+index).checked = 'checked';
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
		
		
		
		//------------------------------------------------------------------
		
		if( retObj.bgpMap != null && retObj.bgpMap.bgp_report_no != null) {
			document.getElementById("bgp_report_no").value= retObj.bgpMap.bgp_report_no;
			document.getElementById("processing_unit").value= retObj.bgpMap.processing_unit;
		}
		
		var workarea_no = retObj.map.workarea_no;
		
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
		
		
		//document.getElementById("quality_index").value= retObj.map.quality_index;
		
		var exploration_method= retObj.map.exploration_method;
		expMethod = exploration_method;
		
		/**if(retObj.dynamicMap.workload == "2"){
			document.getElementById("workload2").checked  = true;
		} else {
			document.getElementById("workload1").checked  = true;
		}*/
		
		//部署图
		document.getElementById("deployDiagram").src = "<%=contextPath%>/pm/deployDiagram/deployDiagramList.jsp?projectInfoNo="+ids;
	
		//分类码
		document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=3&relationId="+ids;

		//测量测算 encodeURI(encodeURI(_tmplsgx)
				
		$("#measurement")[0].src = "<%=contextPath%>/pm/measurement/measurementList.jsp?projectInfoNo="+ids;

		
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
		var retQuality = jcdpCallService("ProjectSrv", "getQuality", "projectInfoNo="+ids);
		if(exploration_method == "0300100012000000002"){
			document.getElementById("item2_0").innerHTML= '单线空炮率≦';
		} else {
			document.getElementById("item2_0").innerHTML= '单束线空炮率≦';
		}
		if(retQuality != null && retQuality.qualityMap != null){
			document.getElementById("object_id").value = retQuality.qualityMap.objectId;
			document.getElementById("qualified_radio").value = retQuality.qualityMap.qualifiedRadio;
			document.getElementById("miss_radio").value = retQuality.qualityMap.missRadio;
			document.getElementById("waster_radio").value = retQuality.qualityMap.wasterRadio;
			document.getElementById("survey_radio").value = retQuality.qualityMap.surveyRadio;
			document.getElementById("profile_radio").value = retQuality.qualityMap.profileRadio;
			document.getElementById("second_radio").value = retQuality.qualityMap.secondRadio;
			document.getElementById("firstlevel_radio").value = retQuality.qualityMap.firstlevelRadio;
			document.getElementById("all_miss_radio").value = retQuality.qualityMap.allMissRadio;
			
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
		//document.getElementById("transit_time").value= "";
		document.getElementById("acquire_end_time").value= "";
		document.getElementById("prctr_name").value= "";
		document.getElementById("prctr").value= "";
		document.getElementById("manage_org").value= "";
		document.getElementById("manage_org_name").value= "";
		document.getElementById("market_classify").value= "";
		document.getElementById("market_classify_name").value= "";
		document.getElementById("notes").value= "";		
		document.getElementById("project_dynamic_no").value= "";
		/**document.getElementById("full_fold_workload").value= "";
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
		document.getElementById("design_sp_num_zy").value= "";
		document.getElementById("design_object_area").value= "";

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
		document.getElementById("country_name").value = "";*/
		
		
		//质量指标
		document.getElementById("object_id").value = "";
		document.getElementById("qualified_radio").value = "";
		document.getElementById("miss_radio").value = "";
		document.getElementById("waster_radio").value = ""
		document.getElementById("survey_radio").value = "";
		document.getElementById("profile_radio").value = "";
	}
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function toAdd(){
		popWindow('<%=contextPath%>/pm/project/multiProject/tqh/insertProject.jsp?projectType='+projectType+'&orgSubjectionId='+orgSubjectionId+'&orgId='+orgId,'750:700');
	}
	
	function toUpdateProject(){
		debugger;
		if(document.getElementById("tab_box_content0").style.display==""||document.getElementById("tab_box_content0").style.display=="block"){
			if(!checkText0()){
				return;
			}
		}
		if(document.getElementById("tab_box_content1").style.display==""||document.getElementById("tab_box_content1").style.display=="block"){
			if(!checkText1()){
				return;
			}
		}
		if(document.getElementById("tab_box_content7").style.display==""||document.getElementById("tab_box_content7").style.display=="block"){
			if(!checkMission()){
				return;
			}
		}
		
		var params = $("#projectForm").serialize();
		var obj = jcdpCallService("ProjectSrv", "addTqhProject",params);
		if(obj != null && obj.message == "success") {
			alert("修改成功");
		} else {
			alert("修改失败");
		}
		loadDataDetail(document.getElementById("project_info_no").value);
	}
	
	function toUpdateWorkarea(){
		if(!checkWorkarea()) return;
		var str = "workarea_no="+document.getElementById("workarea_no").value;
		str += "&project_info_no="+document.getElementById("project_info_no").value;
		str += "&workarea="+document.getElementById("workarea").value;
		str += "&start_year="+document.getElementById("start_year").value;
		str += "&basin="+document.getElementById("basin").value;
		str += "&spare2="+document.getElementById("spare2").value;
		str += "&region_name="+document.getElementById("region_name").value;
		str += "&surface_type="+document.getElementById("surface_type").value;
		str += "&second_surface_type="+document.getElementById("second_surface_type").value;
		str += "&focus_x="+document.getElementById("focus_x").value;
		str += "&focus_y="+document.getElementById("focus_y").value;
		
		str += "&block="+document.getElementById("block").value;
		str += "&crop_area_type="+document.getElementById("crop_area_type").value;
		str += "&country="+document.getElementById("country").value;
		
		//alert(str);
		var obj = jcdpCallService("WorkAreaSrv", "saveOrUpdateWorkarea", str);
		
		if(obj != null && obj.message == "success") {
			alert("修改成功");
		} else {
			alert("修改失败");
		}
		
	}
	
	function checkWorkarea() {
	 	
        if (!isTextPropertyNotNull("workarea", "工区名称")) {
			return false;	
		}
        if (!isLimitB100("workarea", "工区名称")) {
			return false;	
		}
        if (!isTextPropertyNotNull("basin", "盆地")) {
			return false;	
		}
        if (!isLimitB100("basin", "盆地")) {
			return false;	
		}
		if (!isTextPropertyNotNull("block", "区块（矿权）")) {
			return false;	
		}
        if (!isLimitB32("block", "区块（矿权）")) {
			return false;	
		}
        if (!isTextPropertyNotNull("region_name", "所属行政区")){
			return false;	
		}
        if (!isLimitB200("region_name", "所属行政区")) {
			return false;	
		}
        if(!isRatio180("focus_x", "工区中心经度")){
			return false;	
		}
        if(!isValidFloatProperty12_9("focus_x", "工区中心经度")) {
			return false;	
		}
		if (!isTextPropertyNotNull("focus_x", "工区中心经度")) {
			return false;	
		}
        if(!isRatio180("focus_y", "工区中心纬度")) {
			return false;	
		}
        if(!isValidFloatProperty12_9("focus_y", "工区中心纬度")) {
			return false;	
		}
		if (!isTextPropertyNotNull("focus_y", "工区中心纬度")) {
			return false;	
		}
	    if (!isTextPropertyNotNull("country", "国家")){
			return false;	
		}

		return true;
	}
	
	function checkText0() {
	 	
		if (!isTextPropertyNotNull("project_name", "项目名称")) return false;
        if (!isLimitB200("project_name", "项目名称")) return false;
        if (!isTextPropertyNotNull("project_status", "项目状态")) return false;
        if (!isTextPropertyNotNull("market_classify_name", "市场范围")) return false;
       	if (!isTextPropertyNotNull("acquire_start_time", "计划采集开始时间")) return false;
        if (!isTextPropertyNotNull("acquire_end_time", "计划采集结束时间")) return false;
        if (!checkStartEndDate("acquire_start_time", "acquire_end_time", "计划采集开始时间", "计划采集结束时间")) return false;
        if (!isTextPropertyNotNull("is_main_project", "项目重要程度")) return false;
        if (!isTextPropertyNotNull("manage_org_name", "甲方单位")) return false;
        if (!isTextPropertyNotNull("build_method", "激发方式")) return false;
        if (!isTextPropertyNotNull("project_business_type", "项目业务类型")) return false;
        if (!isTextPropertyNotNull("prctr_name", "利润中心")) return false;
        if (!isTextPropertyNotNull("org_name", "施工队伍")) return false;
        
		return true;
	}
	
	function checkText1() {
		if (!isValidFloatProperty20_0("design_line_num","设计线束")) return false;
		if (!isValidFloatProperty8_3("design_execution_area","设计施工面积")) return false;
		if (!isValidFloatProperty8_3("design_data_area","设计有资料面积")) return false;
		if (!isValidFloatProperty8_3("measure_km","设计测量总公里数")) return false; 
		if (!isValidFloatProperty20_0("design_geophone_num","设计检波点数")) return false;
		if (!isValidFloatProperty7_0("design_sp_num","设计总炮数")) return false;
		if (!isValidFloatProperty7_0("full_fold_workload","设计试验炮")) return false;
		//if (!isValidFloatProperty7_0("design_dw_num","设计定位炮")) return false;
		if (!isValidFloatProperty8_3("design_object_area","设计满覆盖面积")) return false; 
		if (!isValidFloatProperty7_0("design_qq_num","设计气枪")) return false;
		if (!isValidFloatProperty7_0("design_drilling_num","设计井炮")) return false;
		if (!isValidFloatProperty7_0("design_sp_num_zy","设计震源")) return false;
		if (!isValidFloatProperty10_0("design_small_regraction_num","设计小折射点数")) return false;
		if (!isValidFloatProperty10_0("design_micro_measue_num","设计微测井点数")) return false;
		
		if (!isValidFloatProperty20_0("other_line_num","设计测线")) return false;
		if (!isValidFloatProperty8_3("design_physical_workload","设计施工长度")) return false;
		if (!isValidFloatProperty8_3("design_object_workload","设计满覆盖长度")) return false;
		if (!isValidFloatProperty8_3("measure_km2","设计测量总公里数")) return false; 
		if (!isValidFloatProperty20_0("design_geophone_num2","设计检波点数")) return false;
		if (!isValidFloatProperty7_0("design_sp_num2","设计总炮数")) return false;
		if (!isValidFloatProperty7_0("full_fold_workload2","设计试验炮")) return false;
		if (!isValidFloatProperty7_0("design_dw_num2","设计定位炮")) return false;
		if (!isValidFloatProperty8_3("design_data_workload","设计有资料长度")) return false;
		
		return true;
	}
	
	function checkMission() {
        if (!isTextPropertyNotNull("notes", "地质任务")) {
			return false;	
		}
		return true;
	}
		
	function toUpdateQuality(){
		if(!checkQuality()){
			return;
		}
		var str = "project_info_no="+document.getElementById("project_info_no").value;
		str += "&object_id="+document.getElementById("object_id").value;
		str += "&qualified_radio="+document.getElementById("qualified_radio").value;
		str += "&miss_radio="+document.getElementById("miss_radio").value;
		str += "&waster_radio="+document.getElementById("waster_radio").value;
		str += "&survey_radio="+document.getElementById("survey_radio").value;
		str += "&profile_radio="+document.getElementById("profile_radio").value;
		str += "&second_radio="+document.getElementById("second_radio").value;
		
		str += "&firstlevel_radio="+document.getElementById("firstlevel_radio").value;
		str += "&all_miss_radio="+document.getElementById("all_miss_radio").value;
		
		var obj = jcdpCallService("ProjectSrv", "saveOrUpdateQuality", str);
		
		if(obj != null && obj.message == "success") {
			alert("修改成功");
		} else {
			alert("修改失败");
		}
	}
	
	function checkQuality() {
		if (!isValidFloatProperty8_3("qualified_radio", "合格品率")) return false;
		if (!isValidFloatProperty8_3("miss_radio", "空炮率")) return false;
		if (!isValidFloatProperty8_3("waster_radio", "全工区空炮率")) return false;
		if (!isValidFloatProperty8_3("survey_radio", "测量成果合格率")) return false;
		if (!isValidFloatProperty8_3("profile_radio", "现场处理剖面合格率")) return false;
		return true;
	}

	function toDelete(){
	    ids = getSelIds('rdo_entity_id'); 
	    if(ids==''){ alert("请先选中至少一条记录!");
	     	return;
	    }	
		    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("ProjectSrv", "deleteProject", "projectInfoNos="+ids);
			window.location.href ="<%=contextPath%>/pm/project/multiProject/tqh/projectList.jsp?projectType=<%=projectType%>&action=<%=action%>&orgSubjectionId=<%=orgSubjectionId%>&orgId=<%=orgId%>&isSingle=<%=isSingle%>";
		}
	}

	function toSearch(){
		popWindow('<%=contextPath%>/pm/project/multiProject/project_search.jsp?projectType='+projectType+'&orgSubjectionId=<%=orgSubjectionId%>&orgId=<%=orgId %>');
	}
	
	function dbclickRow(ids){
		<%if(action.equals("view")){ %>
		location.href="<%=contextPath %>/pm/project/selectProject.srq?projectInfoNo="+ids;
		var name = document.getElementById("projectName"+ids).value;
		var longName = name;
		//alert(name.length);
		if (name.length > 6){
			name = name.substring(0,6)+"...";
		}
		parent.window.opener.setProject(longName, name);//.document.getElementById('projectName').innerHTML='<a href="#"  onclick="selectProject();" title="'+longName+'">'+name+'</a>';
 		//parent.window.opener.top.location.reload();
		parent.window.close();
		<%} else {%>
		//popWindow('<%=contextPath%>/pm/project/multiProject/viewProject.jsp?projectInfoNo='+ids);
		<%} %>
		
	}
	
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
		//window.showModalDialog('<%=contextPath%>/common/selectCode.jsp?codingSortId=0100100014',teamInfo);
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
	
	function selectManageOrgCode(objId,objName){
			var teamInfo = {
					fkValue:"",
					value:""
				};
				window.showModalDialog('<%=contextPath%>/common/selectManageOrg.jsp',teamInfo,'dialogWidth=600px;dialogHeight=600px');
				if(teamInfo.fkValue!=""){
					document.getElementById(objId).value = teamInfo.fkValue;
					document.getElementById(objName).value = teamInfo.value;
			}
		}

	function selectManageOrgCode(objId,objName){
		var teamInfo = {
				fkValue:"",
				value:""
			};
			window.showModalDialog('<%=contextPath%>/common/selectManageOrg.jsp',teamInfo,'dialogWidth=600px;dialogHeight=600px');
			if(teamInfo.fkValue!=""){
				document.getElementById(objId).value = teamInfo.fkValue;
				document.getElementById(objName).value = teamInfo.value;
		}
	}
	
	function selectTeam(){
		var teamInfo = {
			fkValue:"",
			value:""
		};
		window.showModalDialog('<%=contextPath%>/common/selectTeam.jsp',teamInfo);
		if(teamInfo.fkValue!=""){
			document.getElementById('org_id').value = teamInfo.fkValue;
			document.getElementById('org_name').value = teamInfo.value;
		}
	}

	function toSubmit(){
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	
		if (!window.confirm("确认要提交吗?")) {
			return;
		}		
		submitProcessInfo();
		refreshData("", "",projectType, "", "", "", "<%=orgSubjectionId%>","","");
	}

	//$("#build_method").html("<option value=''>请选择勘探方法</option>");
	function changeExploration(value){
		if("0300100012000000029"==value){//二维/三维
			$("#build_method").html("<option value='5000100003000000003'>气枪</option>"+
									"<option value='5000100003000000001'>井炮</option>");
		}else{
			/**if("0300100012000000003"==value){//三维
				$("#workLoad2 input[type=text]").attr("disabled","disabled");
			}
			if("0300100012000000002"==value){//二维
				$("#workLoad3 input[type=text]").attr("disabled","disabled");
			}*/
			$("#build_method").html("<option value='5000100003000000003'>气枪</option>"+
					"<option value='5000100003000000001'>井炮</option>"+
					"<option value='5000100003000000004'>井炮/震源</option>"+
					"<option value='5000100003000000005'>气枪/井炮</option>"+
					"<option value='5000100003000000007'>气枪/井炮/震源</option>");
		}
	}
	
	$("#project_type").attr("disabled","disabled");
	function work_load(type){
		var objs = document.getElementsByName(type);
		debugger;
		for(var i =0 ;i< objs.length ;i++){
			if(objs[i].checked == true){
				var value = objs[i].value;
				document.getElementById("work_load3").value = value;
				document.getElementById("work_load2").value = value;
			}
		}
	}
</script>

</html>

