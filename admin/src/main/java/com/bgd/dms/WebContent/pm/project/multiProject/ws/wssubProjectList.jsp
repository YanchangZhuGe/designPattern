<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="java.util.*" %>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ taglib uri="code" prefix="code"%> 
<%@	taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@ page import="java.text.*" %>
<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	
	String orgSubjectionId = "C105";
	if(request.getParameter("orgSubjectionId") != null){
		orgSubjectionId = request.getParameter("orgSubjectionId");
	}
	
	if(respMsg != null && respMsg.getValue("orgSubjectionId") != null){
		orgSubjectionId=respMsg.getValue("orgSubjectionId");
	}
	
	String orgId = "C6000000000001";
	if(request.getParameter("orgId") != null){
		orgId = request.getParameter("orgId");
	}
	String projectFatherNo="";
	if(request.getParameter("projectFatherNo")!=null){
		projectFatherNo = request.getParameter("projectFatherNo");
	}
	
	if(respMsg != null && respMsg.getValue("projectFatherNo") != null){
		projectFatherNo=respMsg.getValue("projectFatherNo");
	}
	
	String projectFatherName=request.getParameter("projectFatherName")==null?"":java.net.URLDecoder.decode(request.getParameter("projectFatherName"),"utf-8");

	
	String projectYear=request.getParameter("projectYear")==null?"":java.net.URLDecoder.decode(request.getParameter("projectYear"),"utf-8");
	
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String projectType=request.getParameter("projectType")==null?"":request.getParameter("projectType");
	
	//保存结果 
	String message = null;
	if (respMsg != null && respMsg.getValue("message") != null) {
		message = respMsg.getValue("message");
	}
	
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
      	<div id="list_table">
			<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
				    <table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					  	<td class="ali_cdn_name"><b>父项目名称:</b></td>
					    <td align="left"><%=projectFatherName%></td>
					    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
					    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
					    <auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
					  </tr>
					</table>
				</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{project_info_no}-{project_name}' id='rdo_entity_id_{project_info_no}' onclick='chooseOne(this);'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{project_name}<input type='hidden' id='projectName{project_info_no}' value='{project_name}'/>" >项目名称</td>
			      <td class="bt_info_even" exp="{project_common}" func="getOpValue,projectCommon1">常规/非常规项目</td>
			      <td class="bt_info_odd" exp="{team_name}" >施工单位</td>
			      <td class="bt_info_even" exp="{is_main_team}" func="getOpValue,ISMAINTEAM">主施工/协作</td>
			      <td class="bt_info_odd" exp="{project_status}"  func="getOpValue,projectStatus1">项目状态</td>
			      <td class="bt_info_even" exp="{manage_org_name}">甲方单位</td>
			      <td class="bt_info_odd" exp="{start_date}">采集开始时间</td>
			      <td class="bt_info_even" exp="{end_date}">采集结束时间</td>
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
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">井筒信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">工作量</a></li>
			    <li id="tag3_7"><a href="#" onclick="getTab3(7)">地质任务</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">质量指标</a></li>
			    <li id="tag3_10"><a href="#" onclick="getTab3(10)">审批流程</a></li>
			    <li id="tag3_12"><a href="#" onclick="getTab3(12)">测量测算</a></li>
			    <li id="tag3_11"><a href="#" onclick="getTab3(11)">部署图</a></li>
			    <li id="tag3_5"><a href="#" onclick="getTab3(5)">队伍信息</a></li>
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
					    <td class="inquire_item6"><span class="red_star">*</span>项目状态：</td>
					    <td class="inquire_form6" id="item0_3">
					    	<code:codeSelect cssClass="select_width"  name='project_status' option="projectStatus"  selectedValue=""  addAll="true" />
					    </td>
					    <td class="inquire_item6">市场范围：</td>
					    <td class="inquire_form6" id="item0_4">
					    	<input id="market_classify" name="market_classify" value="" type="hidden" class="input_width" />
							<input id="market_classify_name" name="market_classify_name" value="" type="text" class="input_width" readonly="readonly"/>
							&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectMarketClassify()" /></td>
					    </td>
					    <td class="inquire_item6">年度：</td>
					    <td class="inquire_form6" id="item0_5">
					    	<input id="project_year" name="project_year" value="<%=projectYear%>" type="text" class="input_width_no_color" readonly="readonly"/>
					    </td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">计划采集开始时间：</td>
					    <td class="inquire_form6" id="item0_3">
						    <input type="text" id="acquire_start_time" name="acquire_start_time" value="" class="input_width" readonly="readonly"/>
							&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acquire_start_time,tributton1);" />
						</td>
					    <td class="inquire_item6">计划采集结束时间：</td>
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
					    <td class="inquire_item6">合同开始时间：</td>
					    <td class="inquire_form6" id="item0_3">
							<input type="text" id="design_start_date" name="design_start_date" value="" class="input_width" readOnly="readonly"/>
							&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(design_start_date,tributton3);" />
						</td>
					    <td class="inquire_item6">合同结束时间：</td>
					    <td class="inquire_form6" id="item0_4">
						    <input type="text" id="design_end_date" name="design_end_date" value="" class="input_width" readOnly="readonly"/>
							&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(design_end_date,tributton4);" />
					    </td>
					    <td class="inquire_item6">合同金额：</td>
					    <td class="inquire_form6" id="item0_1">
					    	<input type="text" id="contract_amount" name="contract_amount" class="input_width_no_color"  />万元
					    </td>
					  </tr>
					  
					  <tr>
					  <td class="inquire_item6">勘探方法：</td>
					    <td class="inquire_form6" id="item0_5">
					    	<select class=select_width name=exploration_method  id="exploration_method" >
									<option value="0300100012000000002">二维地震</option>
									<option value="0300100012000000003">三维地震</option>
									<option value="0300100012000000023">四维地震</option>
									<option value="0300100012000000028">多波</option>
									<option value="0300100012000000027">其它</option>
							</select>
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
						<td class="inquire_item6"><span class="red_star">*</span>甲方单位：</td>
					    <td class="inquire_form6" id="item0_4">
					    	<input type="hidden" id="manage_org" name="manage_org" class="input_width" readonly="readonly"/>
					    	<input type="text" id="manage_org_name" name="manage_org_name" class="input_width" />
					    	<img src="<%= request.getContextPath() %>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectManageOrgCode('manage_org','manage_org_name');" />
					    </td>
					  </tr>
					  
					  <tr>
					    <td class="inquire_item6">资料处理单位：</td>
					    <td class="inquire_form6" id="item0_3"><input type="hidden" id="bgp_report_no" name="bgp_report_no"/><input type="text" id="processing_unit" name="processing_unit" class="input_width" /></td>
					    <td class="inquire_item6">项目来源：</td>
					    <td class="inquire_form6" id="item0_5">
					   		<select class=select_width name="project_source" id="project_source">
								<option value='5110000054000000001'>矿保</option>
								<option value='5110000054000000002'>风险</option>
								<option value='5000100004000000003'>预探</option>
								<option value='5000100004000000004'>油藏评价</option>
								<option value='5000100004000000005'>油田开发</option>
								<option value='5000100004000000006'>天然气开发</option>
								<option value='5000100004000000007'>页岩气</option>
								<option value='5000100004000000008'>煤层气</option>
								<option value='5000100004000000009'>其它</option>
							</select>
					    </td>
					    <td class="inquire_item6"><span class="red_star">*</span>项目业务类型：</td>
					    <td class="inquire_form6" id="item0_5">
					    	<code:codeSelect cssClass="select_width"   name='project_business_type' option="projectBusinessType"  selectedValue=""  addAll="true" />
					    </td>
					  </tr>
					  
					  <tr>
					    <td class="inquire_item6">利润中心：</td>
					    <td class="inquire_form6" id="item0_3">
					    	<input type="hidden" id="prctr" name="prctr" value="" class="input_width" />
							<input type="text" id="prctr_name" name="prctr_name" value="" class="input_width"  readonly="readonly"/>
							&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectPrctr()" />
					    </td>
					    <td class="inquire_item6"><span class="red_star">*</span>施工队伍：</td>
						<td class="inquire_form6">
							<input id="org_id" name="org_name" value="" type="hidden" class="input_width" />
							<input id="org_name" name="org_name" value="" type="text" class="input_width_no_color" readonly="readonly"/>
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
					    <td class="inquire_item6">区带：</td>
					    <td class="inquire_form6"><input id="zone" name="zone" value="" type="text" class="input_width" /></td>
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
					    <td class="inquire_item6"><span class="red_star">*</span>观测类型：</td>
						<td class="inquire_form6" colspan="6">
							<input type="hidden" id="view_type" name="view_type" value="" class="input_width" />
							<input type="checkbox" name="view_type_name" value="5110000053000000001" id="5110000053000000001">零偏VSP（Zero offset-VSP）</input>
							<input type="checkbox" name="view_type_name" value="5110000053000000002" id="5110000053000000002">非零偏VSP（Offset-VSP）</input>
							<input type="checkbox" name="view_type_name" value="5110000053000000003" id="5110000053000000003">Walkaway-VSP&nbsp;&nbsp;</input>
							<input type="checkbox" name="view_type_name" value="5110000053000000004" id="5110000053000000004">Walkaround-VSP&nbsp;&nbsp;</input>
							<input type="checkbox" name="view_type_name" value="5110000053000000005" id="5110000053000000005">3D-VSP&nbsp;&nbsp;</input>
						</td>
					  </tr>
					  <tr>
					    <td class="inquire_item6"></td>
						<td class="inquire_form6" colspan="6">
							<input type="hidden" id="view_type" name="view_type" value="" class="input_width" />
							<input type="checkbox" name="view_type_name" value="5110000053000000006" id="5110000053000000006">微地震井中监测&nbsp;&nbsp;</input>
							<input type="checkbox" name="view_type_name" value="5110000053000000007" id="5110000053000000007">微地震地面监测&nbsp;&nbsp;</input>
							<input type="checkbox" name="view_type_name" value="5110000053000000008" id="5110000053000000008">井间地震&nbsp;&nbsp;</input>
							<input type="checkbox" name="view_type_name" value="5110000053000000009" id="5110000053000000009">随钻地震&nbsp;&nbsp;</input>
							<input type="checkbox" name="view_type_name" value="5110000053000000010" id="5110000053000000010">井地联合勘探&nbsp;&nbsp;</input>
						</td>
					  </tr>
					  <tr>
					  	<td class="inquire_item6"><span class="red_star">*</span>常规项目：</td>
					    <td class="inquire_form6">
					    	<input type="radio" name="project_common" id="project_common1" value="1" disabled="disabled"/>常规项目&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="project_common" id="project_common0"  value="0" disabled="disabled"/>非常规项目
							<input type="hidden" name="project_common" value=""/>
						</td>
						<td class="inquire_item6" id="item0_0_19"><span class="red_star">*</span>协作队伍：</td>
						<td class="inquire_form6" id="item0_19" colspan="4">
							<input id="other_org_id" name="other_org_id" value="" type="hidden" class="input_width" />
							<input id="other_org_name" name="other_org_name" value="" type="text" class="input_width_no_color" />
							<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectOtherTeam()" />
						</td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">项目投资：</td>
						<td class="inquire_form6">
							<input type="text" id="project_cost" name="project_cost" value="" class="input_width" />
						</td>
					    <td class="inquire_item6">项目负责人：</td>
					    <td class="inquire_form6">
					    	<input type="text" id="project_man" name="project_man" value="" class="input_width" />
					    </td>
					    <td class="inquire_item6">一级构造单元：</td>
						<td class="inquire_form6">
							<input type="text" id="unit_one" name="unit_one" value="" class="input_width" />
						</td>
					    <!-- <td class="inquire_item6">仪器型号：</td>
					    <td class="inquire_form6"><input type="text" id="instrument_model" name="instrument_model" value="" class="input_width" /></td> -->
					  </tr>
					  <tr>
					    
					    <td class="inquire_item6">二级构造单元：</td>
					    <td class="inquire_form6" id="item0_3">
					    	<input type="text" id="unit_two" name="unit_two" value="" class="input_width" />
					    </td>
					    <td class="inquire_item6">井下仪器级数：</td>
					    <td class="inquire_form6">
					    	<input type="text" id="instrument_num" name="instrument_num" value="" class="input_width" />
						</td>
						<td class="inquire_item6">井下仪器间距：</td>
						<td class="inquire_form6">
							<input type="text" id="instrument_space" name="instrument_space" value="" class="input_width" />
						</td>
					  </tr>
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<input type="hidden" id="project_dynamic_no" name="project_dynamic_no" />
					<input type="hidden" id="design_object_workload" name="design_object_workload" />
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateProject()"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		              </table>
					<table id="work_load_table" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					   <tr>
					   		<td class="inquire_item6"><span class="red_star">*</span>设计测线条数：</td>
					    	<td class="inquire_form6"><input type="text" id="design_line_num" name="design_line_num" class="input_width" />&nbsp;条</td>
					    	<td class="inquire_item6"><input type="radio" id="workload1" name="workload" value="1" checked="checked"/>设计实物工作量：</td>
						    <td class="inquire_form6"><input type="text" id="design_workload1" name="design_workload1" class="input_width" />&nbsp;km</td>
						    <td class="inquire_item6"><input type="radio" id="workload2" name="workload" value="2"/>设计满覆盖工作量：</td>
						    <td class="inquire_form6"><input type="text" id="design_workload2" name="design_workload2" class="input_width" />&nbsp;km</td>
					    </tr>
					  	<tr>
						    <td class="inquire_item6"><span class="red_star">*</span>设计试验炮：</td>
						    <td class="inquire_form6"><input type="text" id="full_fold_workload" name="full_fold_workload" class="input_width" />&nbsp;炮</td>
						    <td class="inquire_item6"><span class="red_star">*</span>设计检波点数：</td>
						    <td class="inquire_form6"><input type="text" id="design_geophone_num" name="design_geophone_num" class="input_width" />&nbsp;个</td>
						    <td class="inquire_item6"><span class="red_star">*</span>设计炮数：</td>
						    <td class="inquire_form6"><input type="text" id="design_sp_num" name="design_sp_num" class="input_width" />&nbsp;炮</td>
					    </tr>
					    <tr>
						    <td class="inquire_item6"><span class="red_star">*</span>设计震源炮数：</td>
						    <td class="inquire_form6"><input type="text" id="design_sp_num_zy" name="design_sp_num_zy" class="input_width" />&nbsp;炮</td>
						    <td class="inquire_item6"><span class="red_star">*</span>设计检波点面积：</td>
					    	<td class="inquire_form6"><input type="text" id="design_geophone_area" name="design_geophone_area" class="input_width" />&nbsp;km²</td>
						   	<td class="inquire_item6"><span class="red_star">*</span>钻井设计点数：</td>
						    <td class="inquire_form6"><input type="text" id="design_drill_num" name="design_drill_num" class="input_width" />&nbsp;个</td>
					    </tr>
					   
					    <tr>
						    <td class="inquire_item6"><span class="red_star">*</span>压裂监测井段：</td>
					    	<td class="inquire_form6"><input type="text" id="press_well_num" name="press_well_num" class="input_width" />&nbsp;</td>
						    <td class="inquire_item6"><span class="red_star">*</span>设计有资料面积：</td>
						    <td class="inquire_form6"><input type="text" id="design_data_area" name="design_data_area" class="input_width" />&nbsp;km²</td>
						    <td class="inquire_item6"><span class="red_star">*</span>设计施工面积：</td>
						    <td class="inquire_form6"><input type="text" id="design_execution_area" name="design_execution_area" class="input_width" />&nbsp;km²</td>
					    </tr>
					   
					    <tr>
						    <td class="inquire_item6"><span class="red_star">*</span>测量总公里数：</td>
						    <td class="inquire_form6"><input type="text" id="measure_km" name="measure_km" class="input_width" />&nbsp;km</td>
						    <td class="inquire_item6"><span class="red_star">*</span>微测井设计点数：</td>
						    <td class="inquire_form6"><input type="text" id="design_micro_measue_num" name="design_micro_measue_num" class="input_width" />&nbsp;个</td>
						    <td class="inquire_item6"><span class="red_star">*</span>小折射设计点数：</td>
					   		<td class="inquire_form6" id="item1_6"><input type="text" id="design_small_regraction_num" name="design_small_regraction_num" class="input_width" />&nbsp;个</td>
					    </tr>
					    <tr>
						    <td class="inquire_item6" id="item1_big_title" style="display:block;">大折射设计点数：</td>
					    	<td class="inquire_form6" id="item1_big" style="display:block;"><input type="text" id="design_big_regraction_num" name="design_big_regraction_num" class="input_width" />&nbsp;个</td>
					    </tr>
					</table>
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
						<td colspan="3" class="inquire_form4"><textarea id="notes"  name="notes" cols="45" rows="5" class="textarea"></textarea></td>
						</tr>
					</table>
				</div>
				</form>
				<form action="" id="workareaForm" name="workareaForm" method="post">
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td><input id="workarea_no" name="workarea_no"type="hidden" /><input type="hidden" id="project_info_no1" name="project_info_no1" /></td>
		                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateWorkarea()"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		              </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					    <tr>
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
					      <td class="inquire_item6"><span class="red_star">*</span>作物区类型：</td>
					      <td class="inquire_form6" ><select id="crop_area_type" name="crop_area_type" class="select_width"></select></td>
					      <td class="inquire_item6"><span class="red_star">*</span>国家:</td>
					      <td class="inquire_form6">
					      	<input id="country"  name="country" class="input_width" type="hidden" />
					      	<input id="country_name"  name="country_name" class="input_width" type="text"  readonly="readonly"/>
					      	&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectCoding('0200100001','country','country_name');" />
					      </td>
					      <td></td>
					     </tr>
					     <tr>
					      <td class="inquire_item6">地表条件描述：</td>
					      <td class="inquire_form6" colspan="5"><textarea id="earth_remark"  name="earth_remark" cols="45" rows="5" class="textarea"></textarea></td>
					     </tr>
					</table>
				</div>
				</form>
				<form id="wellholeForm" name="wellholeForm" action="" method="post" enctype="multipart/form-data">
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td><input id="well_no"  name="well_no" type="hidden" />
		                  <input type="hidden" id="oldUcmId1" name="oldUcmId1" value=""/>
		                  <input type="hidden" id="oldUcmId2" name="oldUcmId2" value=""/></td>
		                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateWellhole()"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
	              	</table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					    <td class="inquire_item6">井别：</td>
					    <td class="inquire_form6" id="item4_0">
					    	<select class=select_width name="well_category" id="well_category">
								<option value='0200200002000000004'>开发井</option>
								<option value='0300100001000000003'>预探井</option>
								<option value='0300100001000000006'>评价井</option>
							</select>
						</td>
					    <td class="inquire_item6">井型：</td>
					    <td class="inquire_form6">
					    	<select class=select_width name="well_type" id="well_type">
								<option value='0300100002000000001'>直井</option>
								<option value='0300100002000000020'>斜井</option>
								<option value='0300100002000000011'>水平井</option>
							</select>
					    </td>
					    <td class="inquire_item6">井的用途：</td>
					    <td class="inquire_form6">
					    	<select class=select_width name="well_use" id="well_use">
								<option value='100001'>激发</option>
								<option value='100002'>接收(井间)</option>
								<option value='100003'>压裂</option>
								<option value='100004'>监测(微地震)</option>
							</select>
					    </td>
					    
					  </tr>
					  <tr>
					 	<td class="inquire_item6">开钻日期：</td>
					    <td class="inquire_form6">
					    	 <input type="text" id="well_start_time" name="well_start_time" value="" class="input_width" readonly="readonly"/>
							&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(well_start_time,tributton2);" />
					    </td>
					  	<td class="inquire_item6">完钻日期：</td>
					    <td class="inquire_form6">
					    	<input type="text" id="well_end_time" name="well_end_time" value="" class="input_width" readonly="readonly"/>
							&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(well_end_time,tributton1);" />
					    </td>
					    <td class="inquire_item6">补芯高：</td>
					    <td class="inquire_form6"><input type="text" id="core_high" name="core_high" class="input_width" /></td>
					    
					  </tr>
					  <tr>
					  	<td class="inquire_item6">构造位置：</td>
					    <td class="inquire_form6"><input type="text" id="location_structure" name="location_structure" class="input_width" /></td>
					  	<td class="inquire_item6">测线位置：</td>
					    <td class="inquire_form6"><input type="text" id="line_location" name="line_location" class="input_width" /></td>
					    <td class="inquire_item6">经度：</td>
					    <td class="inquire_form6"><input type="text" id="land_x" name="land_x" class="input_width" /></td>
					    
					  </tr>
					  <tr>
					  	<td class="inquire_item6">纬度：</td>
					    <td class="inquire_form6"><input type="text" id="land_y" name="land_y" class="input_width" /></td>
					  	<td class="inquire_item6">地面海拔：</td>
					    <td class="inquire_form6"><input type="text" id="land_high" name="land_high" class="input_width" /></td>
					    <td class="inquire_item6">套管结构：</td>
					    <td class="inquire_form6"><input type="text" id="casing_structure" name="casing_structure" class="input_width" /></td>
					    
					  </tr>
					  <tr>
					  	<td class="inquire_item6">裸眼井段：</td>
					    <td class="inquire_form6"><input type="text" id="barefoot_interval" name="barefoot_interval" class="input_width" /></td>
					  	<td class="inquire_item6">泥浆比重：</td>
					    <td class="inquire_form6"><input type="text" id="mud_weight" name="mud_weight" class="input_width" /></td>
					    <td class="inquire_item6">泥浆粘度：</td>
					    <td class="inquire_form6"><input type="text" id="mud_viscosity" name="mud_viscosity" class="input_width" /></td>
					    
					  </tr>
					  <tr>
					  	<td class="inquire_item6">设计井深：</td>
					    <td class="inquire_form6"><input type="text" id="design_well_depth" name="design_well_depth" class="input_width" /></td>
					  	<td class="inquire_item6">完钻井深：</td>
					    <td class="inquire_form6"><input type="text" id="drilling_well_depth" name="drilling_well_depth" class="input_width" /></td>
					    <td class="inquire_item6">人工井底：</td>
					    <td class="inquire_form6"><input type="text" id="artificial_hole" name="artificial_hole" class="input_width" /></td>
					   
					  </tr>
					  <tr>
					  	<td class="inquire_item6">井底温度：</td>
					    <td class="inquire_form6"><input type="text" id="bottom_temperature" name="bottom_temperature" class="input_width" /></td>
					  	<td class="inquire_item6">目的层：</td>
					    <td class="inquire_form6"><input type="text" id="target_stratum" name="target_stratum" class="input_width" /></td>
					    <td class="inquire_item6">完钻层位：</td>
					    <td class="inquire_form6"><input type="text" id="drilling_stratum" name="drilling_stratum" class="input_width" /></td>
					  </tr>
					  <tr>
					  	<td class="inquire_item6">仪器下放深度：</td>
					    <td class="inquire_form6"><input type="text" id="inst_decent_depth" name="inst_decent_depth" class="input_width" /></td>
					  	<td class="inquire_item6"></td>
					    <td class="inquire_form6"></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_form6"></td>
					  </tr>
					  <tr>
					  	<td class="inquire_item6">井斜数据文件：</td>
					    <td class="inquire_form6" colspan="3"><input type="file" name="1" id="1" class="input_width"/>
					    <div  id="td_down1"></div></td>
					    <td class="inquire_item6">&nbsp;</td>
					    <td class="inquire_form6">&nbsp;</td>
					    <td class="inquire_item6">&nbsp;</td>
					    <td class="inquire_form6">&nbsp;</td>
					  </tr>
					  <tr>
					  	<td class="inquire_item6">井身结构图：</td>
					    <td class="inquire_form6" colspan="3"><input type="file" name="2" id="2" class="input_width"/>
					    <div  id="td_down2"></div>
					    </td>
					    <td class="inquire_item6">&nbsp;</td>
					    <td class="inquire_form6">&nbsp;</td>
					    <td class="inquire_item6">&nbsp;</td>
					    <td class="inquire_form6">&nbsp;</td>
					  </tr>
					</table>
				</div>
				</form>
				<form id="QualificationForm" name="QualificationForm" action="" method="post" enctype="multipart/form-data">
				<div id="tab_box_content5" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td><input id="qualification_no"  name="qualification_no" type="hidden" />
		                  <input type="hidden" id="oldZZ1" name="oldZZ1" value=""/>
		                  <input type="hidden" id="oldZZ2" name="oldZZ2" value=""/></td>
		                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateQualification()"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
	              	</table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					  	<td class="inquire_item4"><span class="red_star">*</span>所属单位：</td>
					    <td class="inquire_form4"><input type="text" id="unit" name="unit" class="input_width" disabled="disabled"/></td>
					    <td class="inquire_item4"><span class="red_star">*</span>队号：</td>
					    <td class="inquire_form4"><input type="text" id="team_no" name="team_no" class="input_width" disabled="disabled"/></td>
					  </tr>
					  <tr>
					  	<td class="inquire_item4">施工经验：</td>
					    <td class="inquire_form4" colspan="3" ><input type="textarea" id="experience" name="experience" cols="100" rows="5" class="textarea"/></td>
					  </tr>
					  <tr>
					  	<td class="inquire_item4">资质：</td>
					    <td class="inquire_form4" colspan="2"><input type="file" name="zz1" id="zz1" class="input_width"/>
					    <div  id="td_zz1"></div></td>
					    <td class="inquire_form4">&nbsp;</td>
					  </tr>
					  <tr>
					  	<td class="inquire_item4">资质核查：</td>
					    <td class="inquire_form4" colspan="2"><input type="file" name="zz2" id="zz2" class="input_width"/>
					    <div  id="td_zz2"></div></td>
					    <td class="inquire_item4">&nbsp;</td>
					  </tr>
					</table>
				</div>
				</form>

				<form action="" id="qualityForm" name="qualityForm" method="post">
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td> <input type="hidden" id="project_info_no2" name="project_info_no2" />
		                	<input type="hidden" id="object_id" name="object_id" /></td>
		                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateQuality()"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		              </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					 	<tr>
						  	<td class="inquire_item4">一级品率≧</td>
							<td class="inquire_form4"><input id="firstlevel_radio" name="firstlevel_radio" class="input_width"/>&nbsp;%</td>
							<td class="inquire_item4"><span class="red_star">*</span>合格品率≧</td>
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
						  	<td class="inquire_item4"><span class="red_star">*</span>表层调查成果合格率</td>
							<td class="inquire_form4"><input id="surface_radio" name="surface_radio" class="input_width"/>&nbsp;%</td>
							<td class="inquire_item4"><span class="red_star">*</span>测量成果合格率</td>
							<td class="inquire_form4"><input id="survey_radio" name="survey_radio" class="input_width"/>&nbsp;%</td>	
						</tr>
						<tr>
						  	<td class="inquire_item4"><span class="red_star">*</span>现场处理剖面合格率</td>
							<td class="inquire_form4"><input id="profile_radio" name="profile_radio" class="input_width"/>&nbsp;%</td>
							<td class="inquire_item4">&nbsp;</td>
							<td class="inquire_form4">&nbsp;</td>	
						</tr>
					</table>
				</div>
				</form>
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
		['5000100001000000001','项目启动'],
		['5000100001000000002','正在运行'],
		['5000100001000000003','项目结束'],
		['5000100001000000004','项目暂停'],
		['5000100001000000005','施工结束']
		);
var ISMAINTEAM = new Array(
		['1','主施工队伍'],
		['0','协作队伍']
);

var projectCommon1 = new Array(
		['1','常规'],
		['0','非常规']
		);
function frameSize(){
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
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "WsProjectSrv";
	cruConfig.queryOp = "querySubProjects";
	var businessType="5110000004100000080";
	var orgSubjectionId= "<%=orgSubjectionId%>";
	var projectType="<%=projectType%>";
	var orgId="<%=orgId %>";
	var message="<%=message%>";
	var projectFatherNo="<%=projectFatherNo%>";
	var projectFatherName = "<%=projectFatherName%>";
	var projectYear = "<%=projectYear%>";
	
	if (message != null&&"null"!=message) {
		alert("修改成功");
	}
	refreshData();

	// 复杂查询
	function refreshData(){
		cruConfig.submitStr = "projectFatherNo="+projectFatherNo+"&projectType="+projectType+"&orgSubjectionId="+orgSubjectionId+"&projectYear="+projectYear+"&orgId="+orgId;
		queryData(1);
	}
	
	
	function loadDataDetail(ids){
		if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
		
		ids=ids.split("-")[0];
		clearLoadData();
		var retObj = jcdpCallService("WsProjectSrv", "getProjectDetail", "projectInfoNo="+ids+"&orgSubjectionId="+orgSubjectionId+"&isson=true");
		
		processNecessaryInfo={
    		businessTableName:"gp_task_project",    //置入流程管控的业务表的主表表明
    		businessType:businessType,              //业务类型 即为之前设置的业务大类
    		businessId:ids,         			    //业务主表主键值
    		businessInfo:retObj.map.project_name+'井中项目立项审批',        //用于待审批界面展示业务信息
    		applicantDate:'<%=appDate%>'       	    //流程发起时间
    	}; 
    	processAppendInfo={
   			projectInfoNo:ids,
   			action:'view',
   			projectName:retObj.map.project_name   
    	};
    	loadProcessHistoryInfo();
    	
    	
    	//观测类型checkbox赋值
   		var checkboxArray = document.getElementsByName("view_type_name");
	    var vt=retObj.map.view_type;
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
	    
	    
	    
	    var pc =retObj.map.project_common;
	    if(""!=pc&&null!=pc){
	   		document.getElementById("project_common"+pc).checked = true;
	   		if(pc=="1"){
	   			document.getElementById("item0_0_19").style.display = "none";
	   			document.getElementById("item0_19").style.display = "none";
	   		}else{
	   			document.getElementById("item0_0_19").style.display = "block";
	   			document.getElementById("item0_19").style.display = "block";
	   		}
	    }

	    document.getElementById("project_father_no").value= retObj.map.project_father_no;
   	    document.getElementById("instrument_num").value= retObj.map.instrument_num;
		document.getElementById("instrument_space").value= retObj.map.instrument_space;
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
		document.getElementById("contract_amount").value= retObj.map.contract_amount;
		document.getElementById("project_cost").value= retObj.map.project_cost;
		document.getElementById("project_man").value= retObj.map.project_man;
		document.getElementById("unit_one").value= retObj.map.unit_one;
		document.getElementById("unit_two").value= retObj.map.unit_two;
		document.getElementById("project_source").value= retObj.map.project_source;
		//document.getElementById("instrument_model").value= retObj.map.instrument_model;
		document.getElementById("zone").value= retObj.map.zone;
		
		
		
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
	    
	    
	    
	  //井中项目
		/* if(retObj.map.project_type==projectType){
			document.getElementById("item1_5_title").style.display="none";
			document.getElementById("item1_5").style.display="none";
			document.getElementById("design_object_workload2_td").style.display="none";
			document.getElementById("item1_22").style.display="none";
			//document.getElementById("item1_big_title").style.display="block";
			//document.getElementById("item1_big").style.display="block";
			document.getElementById("tr_press").style.display="block";
		}else{
			document.getElementById("tr_press").style.display="none";
			document.getElementById("design_object_workload2_td").style.display="block";
			document.getElementById("item1_22").style.display="block";
			//document.getElementById("item1_big_title").style.display="none";
			//document.getElementById("item1_big").style.display="none";

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
		} */
		document.getElementById("prctr_name").value= retObj.map.prctr_name;
		document.getElementById("prctr").value= retObj.map.prctr;
		document.getElementById("manage_org").value= retObj.map.manage_org;
		document.getElementById("manage_org_name").value= retObj.map.manage_org_name;
		document.getElementById("market_classify").value= retObj.map.market_classify;
		document.getElementById("market_classify_name").value= retObj.map.market_classify_name;
		document.getElementById("notes").value= retObj.map.notes;
		document.getElementById("project_dynamic_no").value= retObj.dynamicMap.project_dynamic_no;
		document.getElementById("design_object_workload").value= retObj.dynamicMap.design_object_workload;
		
		document.getElementById("org_id").value= retObj.dynamicMap.org_id;
		document.getElementById("org_name").value= retObj.dynamicMap.org_name;
		if(retObj.dynamicMap.other_org_id!=null){
			document.getElementById("other_org_id").value= retObj.dynamicMap.other_org_id;
		}
		if(retObj.dynamicMap.other_org_name!=null){
			document.getElementById("other_org_name").value= retObj.dynamicMap.other_org_name;
		}
		
		
		

		if( retObj.bgpMap != null && retObj.bgpMap.bgp_report_no != null) {
			document.getElementById("bgp_report_no").value= retObj.bgpMap.bgp_report_no;
			document.getElementById("processing_unit").value= retObj.bgpMap.processing_unit;
		}

		var workarea_no = retObj.map.workarea_no;
		//工区信息
		if(workarea_no != null && workarea_no != ""){
			var retWorkArea = jcdpCallService("WorkAreaSrv", "getWorkarea", "workareaNo="+workarea_no);
			document.getElementById("workarea_no").value = workarea_no;
			document.getElementById("workarea").value = retWorkArea.workarea.workarea;
			document.getElementById("start_year").value = retWorkArea.workarea.start_year;
			document.getElementById("basin").value = retWorkArea.workarea.basin;
			document.getElementById("spare2").value = retWorkArea.workarea.spare2;
			document.getElementById("region_name").value = retWorkArea.workarea.region_name;
			document.getElementById("block").value = retWorkArea.workarea.block;
			document.getElementById("country").value = retWorkArea.workarea.country;
			document.getElementById("country_name").value = retWorkArea.workarea.country_name;
			document.getElementById("earth_remark").value = retWorkArea.workarea.earth_remark;
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
		$("#td_down1").html("");
		$("#td_down2").html("");
		var well_no = retObj.dynamicMap.well_no;
		//井筒信息
		if(well_no != null && well_no != ""){
			var wellObj = jcdpCallService("WsProjectSrv", "getWellhole", "&welNo="+well_no);//获取井筒信息
			document.getElementById("well_no").value = well_no;
			document.getElementById("well_start_time").value = wellObj.wellMap.well_start_time;
			document.getElementById("well_end_time").value = wellObj.wellMap.well_end_time;
			document.getElementById("core_high").value = wellObj.wellMap.core_high;
			document.getElementById("location_structure").value = wellObj.wellMap.location_structure;
			document.getElementById("line_location").value = wellObj.wellMap.line_location;
			document.getElementById("land_x").value = wellObj.wellMap.land_x;
			document.getElementById("land_y").value = wellObj.wellMap.land_y;
			document.getElementById("land_high").value = wellObj.wellMap.land_high;
			document.getElementById("casing_structure").value = wellObj.wellMap.casing_structure;
			document.getElementById("barefoot_interval").value = wellObj.wellMap.barefoot_interval;
			document.getElementById("mud_weight").value = wellObj.wellMap.mud_weight;
			document.getElementById("mud_viscosity").value = wellObj.wellMap.mud_viscosity;
			document.getElementById("design_well_depth").value = wellObj.wellMap.design_well_depth;
			document.getElementById("drilling_well_depth").value = wellObj.wellMap.drilling_well_depth;
			document.getElementById("artificial_hole").value = wellObj.wellMap.artificial_hole;
			document.getElementById("bottom_temperature").value = wellObj.wellMap.bottom_temperature;
			document.getElementById("target_stratum").value = wellObj.wellMap.target_stratum;
			document.getElementById("drilling_stratum").value = wellObj.wellMap.drilling_stratum;
			document.getElementById("inst_decent_depth").value = wellObj.wellMap.inst_decent_depth;
			//井别
			var wellSel = document.getElementById("well_category").options;
			var wellValue = wellObj.wellMap.well_category;
			for(var i=0;i<wellSel.length;i++)
			{
			    if(wellValue==wellSel[i].value)
			    {
			       document.getElementById('well_category').options[i].selected=true;
			    }
			}

			//井型
			wellSel = document.getElementById("well_type").options;
			wellValue = wellObj.wellMap.well_type;
			for(var i=0;i<wellSel.length;i++)
			{
			    if(wellValue==wellSel[i].value)
			    {
			       document.getElementById('well_type').options[i].selected=true;
			    }
			}
			//井的yongtu
			wellSel = document.getElementById("well_use").options;
			wellValue = wellObj.wellMap.well_use;
			for(var i=0;i<wellSel.length;i++)
			{
			    if(wellValue==wellSel[i].value)
			    {
			       document.getElementById('well_use').options[i].selected=true;
			    }
			}
			
			if(wellObj.wellMap.ucm_id1!= null &&wellObj.wellMap.ucm_id1!= ""){
				document.getElementById("oldUcmId1").value = wellObj.wellMap.ucm_id1;
				$("#td_down1").append("&nbsp;<a style='color:blue;' href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+wellObj.wellMap.ucm_id1+"&emflag=0>"+wellObj.wellMap.file_name1+"</a>");
			}
			if(wellObj.wellMap.ucm_id2 != null && wellObj.wellMap.ucm_id2 != ""){
				document.getElementById("oldUcmId2").value = wellObj.wellMap.ucm_id2;
				$("#td_down2").append("&nbsp;<a style='color:blue;' href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+wellObj.wellMap.ucm_id2+"&emflag=0>"+wellObj.wellMap.file_name2+"</a>");
			}
		}

		$("#td_zz1").html("");
		$("#td_zz2").html("");
		var qualification_no = retObj.dynamicMap.qualification_no;
		//队伍信息
		document.getElementById("unit").value = retObj.teamMap.orgAbbreviation;
		document.getElementById("team_no").value = retObj.dynamicMap.org_name;
		if(qualification_no != null && qualification_no != ""){
			var qualObj = jcdpCallService("WsProjectSrv", "getQualification","&qualificationNo="+qualification_no);
			document.getElementById("qualification_no").value = qualification_no;
			
			document.getElementById("experience").value = qualObj.qualMap.experience;
			
			if(qualObj.qualMap.ucm_id1!= null &&qualObj.qualMap.ucm_id1!= ""){
				document.getElementById("oldZZ1").value = qualObj.qualMap.ucm_id1;
				$("#td_zz1").append("&nbsp;<a style='color:blue;' href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+qualObj.qualMap.ucm_id1+"&emflag=0>"+qualObj.qualMap.file_name1+"</a>");
			}
			if(qualObj.qualMap.ucm_id2 != null && qualObj.qualMap.ucm_id2 != ""){
				document.getElementById("oldZZ2").value = qualObj.qualMap.ucm_id2;
				$("#td_zz2").append("&nbsp;<a style='color:blue;' href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+qualObj.qualMap.ucm_id2+"&emflag=0>"+qualObj.qualMap.file_name2+"</a>")
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

		//项目来源
		sel = document.getElementById("project_source").options;
		value = retObj.map.project_source;
		for(var i=0;i<sel.length;i++)
		{
		    if(value==sel[i].value)
		    {
		       document.getElementById('project_source').options[i].selected=true;
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
		/**
		sel = document.getElementById("build_method").options;
		value = retObj.map.build_method;
		for(var i=0;i<sel.length;i++)
		{
		    if(value==sel[i].value)
		    {
		       document.getElementById('build_method').options[i].selected=true;
		    }
		}*/
		
		
		var exploration_method= retObj.map.exploration_method;
		expMethod = exploration_method;
		projType=retObj.map.project_type;
		//工作量
		
		document.getElementById("design_line_num").value= retObj.dynamicMap.design_line_num;
		if(retObj.dynamicMap.workload == "2"){
			document.getElementById("workload2").checked  = true;
		} else {
			document.getElementById("workload1").checked  = true;
		}
		document.getElementById("design_workload1").value= retObj.dynamicMap.design_workload1;
		document.getElementById("design_workload2").value= retObj.dynamicMap.design_workload2;
		document.getElementById("full_fold_workload").value= retObj.dynamicMap.full_fold_workload;
		document.getElementById("design_geophone_num").value= retObj.dynamicMap.design_geophone_num;
		document.getElementById("design_sp_num").value= retObj.dynamicMap.design_sp_num;
		document.getElementById("design_sp_num_zy").value= retObj.dynamicMap.design_sp_num_zy;
		document.getElementById("design_geophone_area").value= retObj.dynamicMap.design_geophone_area;
		document.getElementById("design_drill_num").value= retObj.dynamicMap.design_drill_num;
		document.getElementById("press_well_num").value= retObj.dynamicMap.press_well_num;
		document.getElementById("design_data_area").value= retObj.dynamicMap.design_data_area;
		document.getElementById("design_execution_area").value= retObj.dynamicMap.design_execution_area;
		document.getElementById("measure_km").value= retObj.dynamicMap.measure_km;
		document.getElementById("design_micro_measue_num").value= retObj.dynamicMap.design_micro_measue_num;
		document.getElementById("design_small_regraction_num").value= retObj.dynamicMap.design_small_regraction_num;
		document.getElementById("design_big_regraction_num").value= retObj.dynamicMap.design_big_regraction_num;
		
		
		
		
		
		
		
		
		
		//部署图
		document.getElementById("deployDiagram").src = "<%=contextPath%>/pm/deployDiagram/deployDiagramList.jsp?projectInfoNo="+ids;
	
		//分类码
		//document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=3&relationId="+ids;

		//测量测算 encodeURI(encodeURI(_tmplsgx)
		$("#measurement")[0].src = "<%=contextPath%>/pm/measurement/ws/measurementList.jsp?projectInfoNo="+ids;

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
		
		//质量指标
		var retQuality = jcdpCallService("WsProjectSrv", "getQuality", "projectInfoNo="+ids);
		if(exploration_method == "0300100012000000002"){
			document.getElementById("item2_0").innerHTML= '单线空炮率≦';
		} else {
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
		document.getElementById("projectForm").reset();
		document.getElementById("workareaForm").reset();
		document.getElementById("qualityForm").reset();
		document.getElementById("wellholeForm").reset();
		document.getElementById("QualificationForm").reset();
	}
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	
	
function toUpdateProject(){
		
		var project_info_no = document.getElementById("project_info_no").value;
		var submitStr='businessTableName=gp_task_project&businessType='+businessType+'&businessId='+project_info_no;
		var retObject=jcdpCallService('WFCommonSrv','getWfProcessHistoryInfo',submitStr)
		var procStatus=retObject.procStatus;
		if(procStatus=='3'||procStatus=='1'){
			alert("该项目已提交审批流程，无法修改");
			return ;
		} 
		
		//更新之前先判断一下协作队伍里面是否包含了施工队伍 如果包含 页面不能提交
		var org_id = document.getElementById("org_id").value;
		var other_org_id = document.getElementById("other_org_id").value;
		if(other_org_id.length!=0){
			var orgArry = other_org_id.split(",");
			for(var i=0;i<orgArry.length;i++){
				var other_org_id_val = orgArry[i];
				if(org_id==other_org_id_val){
					alert("协作队伍不能包含施工队伍!");
					return;
				}
			}
		}
		
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
		
		//debugger;
		var str = "project_info_no="+document.getElementById("project_info_no").value;
		
		str += "&project_name="+encodeURI(encodeURI(document.getElementById("project_name").value));
		str += "&exploration_method="+document.getElementById("exploration_method").value;
		str += "&project_id="+document.getElementById("project_id").value;
		str += "&project_type="+document.getElementById("project_type").value;
		str += "&project_year="+document.getElementById("project_year").value;
		str += "&start_year="+document.getElementById("start_year").value;
		str += "&acquire_start_time="+document.getElementById("acquire_start_time").value;
		str += "&acquire_end_time="+document.getElementById("acquire_end_time").value;
		str += "&design_start_date="+document.getElementById("design_start_date").value;
		str += "&design_end_date="+document.getElementById("design_end_date").value;
		str += "&contract_amount="+document.getElementById("contract_amount").value;
		str += "&explore_type="+document.getElementById("explore_type").value;
		//str += "&build_method="+document.getElementById("build_method").value;
		str += "&prctr="+document.getElementById("prctr").value;
		str += "&manage_org="+document.getElementById("manage_org").value;
		str += "&project_status="+document.getElementById("project_status").value;
		str += "&market_classify="+document.getElementById("market_classify").value;
		str += "&notes="+encodeURI(encodeURI(document.getElementById("notes").value));
		str += "&project_business_type="+document.getElementById("project_business_type").value;
		str += "&is_main_project="+document.getElementById("is_main_project").value;
		str += "&project_dynamic_no="+document.getElementById("project_dynamic_no").value;
		str += "&design_line_num="+document.getElementById("design_line_num").value;
		str += "&design_object_workload="+document.getElementById("design_object_workload").value;
		str += "&full_fold_workload="+document.getElementById("full_fold_workload").value;
		str += "&design_geophone_num="+document.getElementById("design_geophone_num").value;
		str += "&design_sp_num="+document.getElementById("design_sp_num").value;
		str += "&design_small_regraction_num="+document.getElementById("design_small_regraction_num").value;
		str += "&design_micro_measue_num="+document.getElementById("design_micro_measue_num").value;
		str += "&design_drill_num="+document.getElementById("design_drill_num").value;
		str += "&design_execution_area="+document.getElementById("design_execution_area").value;
		str += "&design_data_area="+document.getElementById("design_data_area").value;
		str += "&design_geophone_area="+document.getElementById("design_geophone_area").value;

		
		str += "&design_sp_num_zy="+document.getElementById("design_sp_num_zy").value;
		str += "&org_id="+document.getElementById("org_id").value;
		str += "&other_org_id="+document.getElementById("other_org_id").value;
		str += "&design_workload1="+document.getElementById("design_workload1").value;
		str += "&design_workload2="+document.getElementById("design_workload2").value;
		//井中
		str += "&project_cost="+document.getElementById("project_cost").value;
		str += "&zone="+document.getElementById("zone").value;	
		str += "&project_man="+document.getElementById("project_man").value;
		str += "&unit_one="+document.getElementById("unit_one").value;
		str += "&unit_two="+document.getElementById("unit_two").value;
		str += "&project_source="+document.getElementById("project_source").value;
		//str += "&instrument_model="+document.getElementById("instrument_model").value;
		str += "&instrument_num="+document.getElementById("instrument_num").value;
		str += "&instrument_space="+document.getElementById("instrument_space").value;
		str += "&design_big_regraction_num="+document.getElementById("design_big_regraction_num").value;
		str += "&press_well_num="+document.getElementById("press_well_num").value;
		str += "&measure_km="+document.getElementById("measure_km").value;	
		//观测类型字符串拼接
		var checkboxArray = document.getElementsByName("view_type_name");
		var vtn="";
		for(i = 0;i <checkboxArray.length;i++ ){
			if(checkboxArray[i].checked==true){
				vtn+=checkboxArray[i].value+",";
			}
		}
		vtn =vtn.substring(0,vtn.lastIndexOf(','));
		if (""==vtn) {		
			alert("请选择观测类型!");
			return false;
		}
		document.getElementById('view_type').value=vtn;
		str += "&view_type="+document.getElementById("view_type").value;


		//激发方式字符串拼接
		checkboxArray = document.getElementsByName("build_method_name");
		vtn="";
		for(i = 0;i <checkboxArray.length;i++ ){
			if(checkboxArray[i].checked==true){
				vtn+=checkboxArray[i].value+",";
			}
		}
		vtn =vtn.substring(0,vtn.lastIndexOf(','));
		if (""==vtn) {		
			alert("请选择激发方式!");
			return false;
		}
		document.getElementById('build_method').value=vtn;
		str += "&build_method="+document.getElementById("build_method").value;

		//常规项目
		if(document.getElementById("project_common1").checked){
			str += "&project_common=1";
		} else {
			str += "&project_common=0";
		}
		
		if(document.getElementById("workload2").checked){
			str += "&workload=2";
		} else {
			str += "&workload=1";
		}
		
		str += "&bgp_report_no="+document.getElementById("bgp_report_no").value;
		str += "&processing_unit="+encodeURI(encodeURI(document.getElementById("processing_unit").value));
		
		var obj = jcdpCallService("WsProjectSrv", "addProject", str);
		
		if(obj != null && obj.message == "success") {
			alert("修改成功");
		} else {
			alert("修改失败");
		}
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
		str += "&earth_remark="+document.getElementById("earth_remark").value;
		str += "&block="+document.getElementById("block").value;
		str += "&crop_area_type="+document.getElementById("crop_area_type").value;
		str += "&country="+document.getElementById("country").value;
		var obj = jcdpCallService("WorkAreaSrv", "saveOrUpdateWorkarea", str);
		if(obj != null && obj.message == "success") {
			alert("修改成功");
		} else {
			alert("修改失败");
		}
	}
	
	
	
	function toUpdateWellhole(){
		var proj_no=document.getElementById("project_info_no").value;
		if(""==proj_no){
			alert("请先选择一条项目信息再保存");
			return;
		}
		if(!isValidFloatProperty13_3("core_high","补芯高")) return false;  
		if(!isValidFloatProperty13_3("land_x","经度")) return false;
		if(!isValidFloatProperty13_3("land_y","纬度")) return false;
		if(!isValidFloatProperty13_3("land_high","地面海拔")) return false;
		if(!isValidFloatProperty13_3("mud_weight","泥浆比重")) return false;
		if (!isValidFloatProperty10_0("mud_viscosity","泥浆粘度")) return false;
		if(!isValidFloatProperty13_3("design_well_depth","设计井深")) return false;
		if(!isValidFloatProperty13_3("drilling_well_depth","完钻井深")) return false;
		if(!isValidFloatProperty13_3("artificial_hole","人工井底")) return false;
		if(!isValidFloatProperty13_3("bottom_temperature","井底温度")) return false;
		if (!isLimitB100("location_structure", "构造位置")) return false;
		if (!isLimitB100("line_location", "测线位置")) return false;
		if (!isLimitB100("casing_structure", "套管结构")) return false;
		if (!isLimitB32("barefoot_interval", "裸眼井段")) return false;
		if (!isLimitB100("target_stratum", "目的层")) return false;
		if (!isLimitB100("drilling_stratum", "完钻层位")) return false;
		
		var form = document.forms["wellholeForm"];
		var projectFatherName=encodeURI(encodeURI('<%=projectFatherName%>'));
		form.action="<%=contextPath%>/pm/project/ws/saveOrUpdateWellhole1.srq?projectInfoNo="+proj_no+"&orgSubjectionId="+orgSubjectionId+"&projectType="+projectType+"&projectFatherName="+projectFatherName+"&projectFatherNo="+projectFatherNo;
		form.submit();
	}
	
	
	
	function toUpdateQualification(){
		var proj_no=document.getElementById("project_info_no").value;
		if(""==proj_no){
			alert("请先选择一条项目信息再保存");
			return;
		}
		if (!isTextPropertyNotNull("unit", "所属单位")) return false;	
		if (!isTextPropertyNotNull("team_no", "队号")) return false;	
		if (!isLimitB20("unit","所属单位")) return false;
		if (!isLimitB20("team_no","队号")) return false;
		if (!isLimitB20("experience","施工经验")) return false;

		var form = document.forms["QualificationForm"];
		var projectFatherName=encodeURI(encodeURI('<%=projectFatherName%>'));
		form.action="<%=contextPath%>/pm/project/ws/saveQualification2.srq?projectInfoNo="+proj_no+"&orgSubjectionId="+orgSubjectionId+"&projectType="+projectType+"&projectFatherName="+projectFatherName+"&projectFatherNo="+projectFatherNo;
		form.submit();
	}
	
	function checkWorkarea() {
        if (!isTextPropertyNotNull("workarea", "工区名称")) return false;	
        if (!isLimitB100("workarea", "工区名称")) return false;	
        if (!isTextPropertyNotNull("basin", "盆地")) return false;	
        if (!isLimitB100("basin", "盆地")) return false;	
		if (!isTextPropertyNotNull("block", "区块（矿权）")) return false;	
        if (!isLimitB32("block", "区块（矿权）")) return false;	
        if (!isTextPropertyNotNull("region_name", "所属行政区")) return false;	
        if (!isLimitB200("region_name", "所属行政区")) return false;	
	    if (!isTextPropertyNotNull("country", "国家")) return false;
	    if (!isLimitB200("earth_remark", "地表条件描述")) return false;	
		return true;
	}
	
	
	
	function checkText0() {
		if (!isTextPropertyNotNull("project_name", "项目名称")) return false;
        if (!isLimitB200("project_name", "项目名称")) return false;
        if (!isTextPropertyNotNull("project_status", "项目状态")) return false;
        if (!isTextPropertyNotNull("is_main_project", "项目重要程度")) return false;
        if (!isTextPropertyNotNull("project_business_type", "项目业务类型")) return false;
    	if (!isTextPropertyNotNull("acquire_start_time", "计划采集开始时间")) return false;
        if (!isTextPropertyNotNull("acquire_end_time", "计划采集结束时间")) return false;
        if (!checkStartEndDate("acquire_start_time", "acquire_end_time", "计划采集开始时间", "计划采集结束时间")) return false;
        if (!isTextPropertyNotNull("design_start_date", "合同开始时间")) return false;
        if (!isTextPropertyNotNull("design_end_date", "合同结束时间")) return false;
        if (!isTextPropertyNotNull("manage_org_name", "甲方单位"))return false;
        if (!isTextPropertyNotNull("contract_amount", "合同金额")) 
		{		
			document.projectForm.contract_amount.focus();
			return false;	
		}
		else if( isNaN( document.getElementById("contract_amount").value ) )
		{
			alert("合同金额,请输入数字!");
			document.projectForm.contract_amount.focus();
			return false;
		}
		else
		{
			var v = $.trim(document.getElementById("contract_amount").value) ;
			var v_1 = v ;
			var v_2 = "" ;
			var _1 = 14 ;
			var _2 = 2 ;
			if (!!v) 
			{
				if (v.indexOf(".") != -1)
				{
					var v_arr = v.split(".");
					v_1 = v_arr[0];
					v_2 = v_arr[1];
				}  
				if( !( /^-?\d+(\.\d+)?$/.test(v) && v_1.length <= _1 && v_2.length <= _2 && v_1 >=0 ) )
				{
					alert("最多输入14位正整数，2位小数的数值!");
					document.projectForm.contract_amount.focus();
					return false;
				}
			}
		}
        if (!checkStartEndDate("design_start_date", "design_end_date", "合同开始时间", "合同结束时间")) return false;  
        if (!isValidFloatProperty13_3("project_cost","项目投资")) return false;  
		if (!isValidFloatProperty13_3("instrument_num","井下仪器级数")) return false; 
		if (!isValidFloatProperty13_3("instrument_space","井下仪器间距")) return false;  
		if (!isLimitB20("project_man","项目负责人")) return false;  
		if (!isLimitB32("unit_one","一级构造单元")) return false;  
		if (!isLimitB32("unit_two","二级构造单元")) return false;  
		if (!isLimitB32("zone","区带")) return false;  

		//观测类型字符串拼接
		checkboxArray = document.getElementsByName("view_type_name");
		str="";
		for(i = 0;i <checkboxArray.length;i++ ){
			if(checkboxArray[i].checked==true){
				str+=checkboxArray[i].value+",";
			}
		}
		str =str.substring(0,str.lastIndexOf(','));
		if (""!=str) {		
			document.getElementById('view_type').value=str;
		}else{
			alert("请选择观测类型!");
			return false;
		}

		//常规项目
		var checkboxArray1 = document.getElementsByName("project_common");
		str="";
		for(i = 0;i <checkboxArray1.length;i++ ){
			if(checkboxArray1[i].checked==true){
				str=checkboxArray1[i].value;
			}
		}
		if (""==str) {		
			alert("请选择常规项目!");
			return false;
		}

		return true;
	}
	
	
	
	
	function checkText1() {
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
		str += "&firstlevel_radio="+document.getElementById("firstlevel_radio").value;
		str += "&qualified_radio="+document.getElementById("qualified_radio").value;
		str += "&waster_radio="+document.getElementById("waster_radio").value;
		str += "&miss_radio="+document.getElementById("miss_radio").value;
		str += "&all_miss_radio="+document.getElementById("all_miss_radio").value;
		str += "&surface_radio="+document.getElementById("surface_radio").value;
		str += "&survey_radio="+document.getElementById("survey_radio").value;
		str += "&profile_radio="+document.getElementById("profile_radio").value;
		str += "&project_father_no="+document.getElementById("project_father_no").value;
		var obj = jcdpCallService("WsProjectSrv", "saveOrUpdateQuality", str);
		
		if(obj != null && obj.message == "success") {
			alert("修改成功");
		} else {
			alert("修改失败");
		}
	}
	
	
	
	function checkQuality() {
		if (!isTextPropertyNotNull("qualified_radio", "合格品率")) return false;
		if (!isValidFloatProperty8_3("qualified_radio", "合格品率")) return false;
		if (!isTextPropertyNotNull("surface_radio", "表层调查合格率")) return false;
		if (!isValidFloatProperty8_3("surface_radio", "表层调查合格率")) return false;
		
		if (!isTextPropertyNotNull("survey_radio", "测量成果合格率")) return false;
		if (!isValidFloatProperty8_3("survey_radio", "测量成果合格率")) return false;
		
		if (!isTextPropertyNotNull("profile_radio", "现场处理剖面合格率")) return false;
		if (!isValidFloatProperty8_3("profile_radio", "现场处理剖面合格率")) return false;

		return true;
	}
	
	
	function toDelete(){
	    ids = getSelIds('rdo_entity_id');
	    var s=ids.split(",");
	    var str="";
	    for(var i=0;i<s.length;i++){
		    str+=s[i].split("-")[0];
		    if(i!=(s.length)-1) str+=",";
	    }
	    if(ids==''){ alert("请先选中至少一条记录!");
	     	return;
	    }	
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("WtProjectSrv", "deleteProject", "projectInfoNos="+str);
			refreshData();
		}
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
		window.showModalDialog('<%=contextPath%>/common/selectCode.jsp?codingSortId=0100100014',teamInfo);
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
	
	function selectOtherTeam(){
		var selectIds=document.getElementById('other_org_id').value;
		var teamInfo = {
			fkValue:"",
			value:""
		};
		window.showModalDialog('<%=contextPath%>/common/selectTeams.jsp?selectIds='+selectIds,teamInfo);
		if(teamInfo.fkValue!=""){
			document.getElementById('other_org_id').value = teamInfo.fkValue;
			document.getElementById('other_org_name').value = teamInfo.value;
		}
	}
	
	
	
	function toAdd(){
		var projectFatherName=encodeURI(encodeURI('<%=projectFatherName%>'));
		window.location = '<%=contextPath%>/pm/project/multiProject/ws/insertSubProject.jsp?projectFatherName='+projectFatherName+'&projectFatherNo='+projectFatherNo+'&orgSubjectionId='+orgSubjectionId+'&orgId='+orgId+'&projectType='+projectType;
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
		refreshData();
	}
	
	$("#project_type").attr("disabled","disabled");
</script>
</html>