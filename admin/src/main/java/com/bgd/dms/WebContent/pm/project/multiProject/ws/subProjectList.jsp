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
	
	String orgId = user.getOrgId();
	String orgSubjectionId = user.getSubOrgIDofAffordOrg();
	if(request.getParameter("orgId")!=null){
		orgId = request.getParameter("orgId");
	}
	
	
	String projectFatherNo="";
	if(request.getParameter("projectFatherNo")!=null){
		projectFatherNo = request.getParameter("projectFatherNo");
	}
	
	if(respMsg != null && respMsg.getValue("projectFatherNo") != null){
		projectFatherNo=respMsg.getValue("projectFatherNo");
	}
	
	String projectType=request.getParameter("projectType")==null?"":request.getParameter("projectType");
	if(respMsg != null && respMsg.getValue("projectType") != null){
		projectType=respMsg.getValue("projectType");
	}
	
	String isSingle=request.getParameter("isSingle")==null?"":java.net.URLDecoder.decode(request.getParameter("isSingle"),"utf-8");
	if(respMsg != null && respMsg.getValue("isSingle") != null){
		isSingle = respMsg.getValue("isSingle");
	}
	
	String projectInfoNo = user.getProjectInfoNo();
	if(respMsg != null && respMsg.getValue("projectInfoNo") != null){
		projectInfoNo = respMsg.getValue("projectInfoNo");
	}
	String projectFatherName=request.getParameter("projectFatherName")==null?"":java.net.URLDecoder.decode(request.getParameter("projectFatherName"),"utf-8");
	
	if(respMsg != null && respMsg.getValue("projectFatherName") != null){
		projectFatherName = respMsg.getValue("projectFatherName");
	}
	
	String projectYear=request.getParameter("projectYear")==null?"":java.net.URLDecoder.decode(request.getParameter("projectYear"),"utf-8");
	
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	
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
			    	<% if(isSingle==null||isSingle.length()==0){%>
				    <table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					  	<td class="ali_cdn_name"><b>父项目名称:</b></td>
					    <td align="left"><%=projectFatherName%></td>
					    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
					    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
					    <auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
					  </tr>
					</table>
					<%}else{%>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						
					</table>
					<%} %>
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
			      <td class="bt_info_even" exp="{manage_org_name}">甲方单位</td>
			      <td class="bt_info_odd" exp="{start_date}">甲方交井时间</td>
			      <td class="bt_info_even" exp="{end_date}">预计完工时间</td>
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
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">观测类型</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">工区信息</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">其他信息</a></li>
			    <li id="tag3_10"><a href="#" onclick="getTab3(10)">审批流程</a></li>
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
							<td class="inquire_item6">年度：</td>
					    <td class="inquire_form6" id="item0_5">
					    	<input id="project_year" name="project_year" value="<%=projectYear%>" type="text" class="input_width_no_color" readonly="readonly"/>
					    </td>
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
					    <td class="inquire_item6">预计完工时间：</td>
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
							<input type="checkbox" name="build_method_name" value="5000100003000000012" id="5000100003000000012" />其他&nbsp;&nbsp;
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
						<td class="inquire_item6"><span class="red_star">*</span>动迁车辆(台)：</td>
						<td class="inquire_item6"><input type="text"
							id="relocation_vehicle" name="relocation_vehicle" value=""
							class="input_width" />
						</td>
					</tr>
					<tr>
						<td class="inquire_item6"><span class="red_star">*</span>完钻井深(米)：</td>
						<td class="inquire_item6"><input type="text"
							id="total_depth" name="total_depth" value=""
							class="input_width" />
						</td>
						<td class="inquire_item6">最大井斜(度)：</td>
						<td class="inquire_item6"><input type="text"
							id="well_deviation_depth" name="well_deviation_depth" value=""
							class="input_width" />
						</td>
						<td class="inquire_item6">最大井斜深度(米)：</td>
						<td class="inquire_item6"><input type="text"
							id="max_well_depth" name="max_well_depth" value=""
							class="input_width" />
						</td>
					</tr>
					
					<tr>
						<td class="inquire_item6"><span class="red_star">*</span>最大井温(℃)：</td>
						<td class="inquire_item6"><input type="text"
								id="well_temperature" name="well_temperature" value=""
								class="input_width" />
						</td>
						<td class="inquire_item6"><span class="red_star">*</span>井压力：</td>
						<td class="inquire_item6"><input type="text"
							id="well_pressure" name="well_pressure" value=""
							class="input_width" />
						</td>
						<td class="inquire_item6"></td>
						<td class="inquire_item6"></td>
					</tr>
					  <tr>
							<td class="inquire_item6"><span class="red_star">*</span>井身结构：</td>
							<td class="" colspan="5">
							套管井段：<input type="text" id="drivepipe_depth" name="drivepipe_depth" value=""  />
							最小套管尺寸：<input type="text" id="drivepipe_size" name="drivepipe_size" value=""  />
							裸眼井段：<input type="text" id="open_hole_depth" name="open_hole_depth" value="" />
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
					</tr>
					</table>
				</div>
				</form>
				
				
				<form action="" id="" name="" method="post">
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td></td>
		                  <td width="30" id="buttonDis10" ><td class='ali_btn'><span class='zj'><a href='#' onclick='toAddViewType()'  title='添加'></a></span></td></td>
		                  <td width="5"></td>
		                </tr>
		            </table>
					<table id="viewtypelist" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					   
					   
					   
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
					      <td class="inquire_item6"><span class="red_star">*</span>施工地区(盆地)：</td>
					      <td class="inquire_form6"><input id="workarea"  name="workarea"class="input_width" type="text" /><input id="start_year" name="start_year" class="input_width" type="hidden" /></td>
					      <!-- <td class="inquire_item6">盆地：</td>
					      <td class="inquire_form6"><input id="basin" name="basin" class="input_width" type="text" /></td> -->
					      <td class="inquire_item6">区块（矿权）：</td>
					      <td class="inquire_form6" >
					      	<input name="block" id="block" value="" type="hidden" class="input_width" />
					      	<input id="spare2"  name="spare2"class="input_width" type="text"  readonly="readonly"/>
					      	<img src="<%= request.getContextPath() %>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectCoding('0300100011','block','spare2');" />
					      </td>
					    </tr>
					    <tr>
					      <td class="inquire_item6">所属行政区:</td>
					      <td class="inquire_form6"><input id="region_name"  name="region_name"class="input_width" type="text" /></td>
					      <td class="inquire_item6">主要地表类型：</td>
					      <td class="inquire_form6" ><select id="surface_type" name="surface_type" class="select_width"></select></td>
					      <td class="inquire_item6"></td>
					      <td class="inquire_form6"></td>
					     </tr>
					     <tr>
					      <td class="inquire_item6">作物区类型：</td>
					      <td class="inquire_form6" ><select id="crop_area_type" name="crop_area_type" class="select_width"></select></td>
					      <td class="inquire_item6">国家:</td>
					      <td class="inquire_form6">
					      	<input id="country"  name="country" class="input_width" type="hidden" value="02001000010000000046"/>
					      	<input id="country_name"  name="country_name" class="input_width" type="text"  readonly="readonly" value="中国"/>
					      	&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectCoding('0200100001','country','country_name');" />
					      </td>
					      <td></td>
					     </tr>
					</table>
				</div>
				</form>
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
						<td class="inquire_item6"><span class="red_star">*</span>地理位置：</td>
						<td class="inquire_form6" colspan="3">
						<input type="text" class="input_width" id="geographic_position" name="geographic_position" value=""  />
						</td>
					</tr>
					
					<tr>
						<td class="inquire_item6"><span class="red_star">*</span>搬迁路线及总距离：</td>
						<td colspan="3" class="inquire_form4">
						<textarea id="route_distance"  name="route_distance" cols="45" rows="5" class="textarea"></textarea>
						</td>
					</tr>
					<tr>
						<td class="inquire_item6"><span class="red_star">*</span>施工风险评估及<br />控制措施：</td>
						<td colspan="3" class="inquire_form4">
						<textarea id="control_measures_1"  name="control_measures_1" cols="45" rows="5" class="textarea"></textarea>
						</td>
					</tr>
					<tr>
						<td class="inquire_item6"><span class="red_star">*</span>可能影响施工效率<br/>的原因分析及控制<br />措施：</td>
						<td colspan="3" class="inquire_form4">
						<textarea id="control_measures_2"  name="control_measures_2" cols="45" rows="5" class="textarea"></textarea>
						</td>
					</tr>
					
					<tr>
						<td class="inquire_item6"> </td>
						<td colspan="3" class="inquire_form4">
						 </td>
					</tr>
					<tr>
						<td class="inquire_item6"> </td>
						<td colspan="3" class="inquire_form4">
						 </td>
					</tr>
					<tr>
						<td class="inquire_item6"> </td>
						<td colspan="3" class="inquire_form4">
						 </td>
					</tr>
					<tr>
						<td class="inquire_item6"> </td>
						<td colspan="3" class="inquire_form4">
						 </td>
					</tr>
					<tr>
						<td class="inquire_item6"> </td>
						<td colspan="3" class="inquire_form4">
						 </td>
					</tr>
					<tr>
						<td class="inquire_item6"> </td>
						<td colspan="3" class="inquire_form4">
						 </td>
					</tr>
					</table>
				</div>
				
				<div id="tab_box_content10" class="tab_box_content" style="display:none;">
					<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>		
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
	var businessType="5110000004100001002";
	var orgSubjectionId= "<%=orgSubjectionId%>";
	var projectType="<%=projectType%>";
	var orgId="<%=orgId %>";
	var message="<%=message%>";
	var projectFatherNo="<%=projectFatherNo%>";
	var projectFatherName = "<%=projectFatherName%>";
	var projectYear = "<%=projectYear%>";
	var isSingle = "<%=isSingle%>"
	var projectInfoNo = "<%=projectInfoNo%>"
	if (message != null&&"null"!=message) {
		alert("修改成功");
	}
	refreshData();

	// 复杂查询
	function refreshData(){
		if(isSingle=="true"){
			cruConfig.submitStr = "projectInfoNo="+projectInfoNo+"&projectType="+projectType+"&orgSubjectionId="+orgSubjectionId+"&projectYear="+projectYear+"&orgId="+orgId+"&isSingle=true";
		}else{
			cruConfig.submitStr = "projectFatherNo="+projectFatherNo+"&projectType="+projectType+"&orgSubjectionId="+orgSubjectionId+"&projectYear="+projectYear+"&orgId="+orgId;
		}
		queryData(1);
	}
	
	
	function loadDataDetail(ids){
		if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
		
		$(".tr_del").remove();
		
		
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
		//document.getElementById("contract_amount").value= retObj.map.contract_amount;
		document.getElementById("project_man").value= retObj.map.project_man;
		document.getElementById("prctr_name").value= retObj.map.prctr_name;
		document.getElementById("prctr").value= retObj.map.prctr;
		document.getElementById("manage_org").value= retObj.map.manage_org;
		document.getElementById("manage_org_name").value= retObj.map.manage_org_name;
		
		
		
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

		//查询子项目观测类型
		var retObj = jcdpCallService("WsProjectSrv", "queryViewType", "projectInfoNo="+ids);
		var viewtypelist = $("#viewtypelist");
		viewtypelist.empty();//首先删除table下面所以行
		var datas = retObj.datas;
		
		var flag1="";
		var flag2="";
		if(datas==null||datas==undefined){
			return;
		}
		for(var i=0;i<datas.length;i++){
			var sel_val = datas[i].view_type_code;
			
			var td1innerhtml = "";
			var td2innerhtml = "";
			var td3innerhtml = "";
			var td4innerhtml = "";
			var td5innerhtml = "";
			
			if(sel_val=="5110000053000000000"){
				td1innerhtml="零偏横波VSP";
				td2innerhtml="观测井段(米)";
				td3innerhtml="观测点距离(米)";
				td4innerhtml="采集级数(级)";
				td5innerhtml="备注";
			}else if(sel_val=="5110000053000000001"){
				td1innerhtml="零偏纵波VSP";
				td2innerhtml="观测井段(米)";
				td3innerhtml="观测点距离(米)";
				td4innerhtml="采集级数(级)";
				td5innerhtml="备注";
			}else if(sel_val=="5110000053000000002"){
				td1innerhtml="非零偏VSP";
				td2innerhtml="观测井段(米)";
				td3innerhtml="观测点距离(米)";
				td4innerhtml="采集级数(级)";
				td5innerhtml="备注";
			}else if(sel_val=="5110000053000000003"){
				td1innerhtml="Walkaway-VSP";
				td2innerhtml="观测井段(米)";
				td3innerhtml="观测点距离(米)";
				td4innerhtml="采集级数(级)";
				td5innerhtml="备注";
			}else if(sel_val=="5110000053000000004"){
				td1innerhtml="Walkaround-VSP";
				td2innerhtml="观测井段(米)";
				td3innerhtml="观测点距离(米)";
				td4innerhtml="采集级数(级)";
				td5innerhtml="备注";
			}else if(sel_val=="5110000053000000005"){
				td1innerhtml="3D-VSP";
				td2innerhtml="观测井段(米)";
				td3innerhtml="观测点距离(米)";
				td4innerhtml="采集级数(级)";
				td5innerhtml="备注";
			}else if(sel_val=="5110000053000000006"){
				td1innerhtml="微地震井中监测";
				td2innerhtml="观测井段(米)";
				td3innerhtml="观测点距离(米)";
				td4innerhtml="采集级数(级)";
				td5innerhtml="备注";
			}else if(sel_val=="5110000053000000007"){
				td1innerhtml="微地震地面监测";
				td2innerhtml="接收线数(线)";
				td3innerhtml="道距(米)";
				td4innerhtml="总接收道数(道)";
				td5innerhtml="备注";
			}else if(sel_val=="5110000053000000008"){
				td1innerhtml="随钻地震";
				td2innerhtml="接收线数(线)";
				td3innerhtml="道距(米)";
				td4innerhtml="总接收道数(道)";
				td5innerhtml="备注";
			}else if(sel_val=="5110000053000000009"){
				td1innerhtml="井间地震";
				td2innerhtml="";
				td3innerhtml="";
				td4innerhtml="";
				td5innerhtml="";
			}else if(sel_val=="5110000053000000010"){
				td1innerhtml="井地联合勘探";
				td2innerhtml="";
				td3innerhtml="";
				td4innerhtml="";
				td5innerhtml="";
			}else if(sel_val=="5110000053000000011"){
				td1innerhtml="其他";
				td2innerhtml="";
				td3innerhtml="";
				td4innerhtml="";
				td5innerhtml="";
			}
			
			var tdhtml="";
			var tr = $("<tr></tr>");
			if(i%2==0){
				tr.addClass("bt_info_odd");
			}else{
				tr.addClass("bt_info_even");
			}
			if(flag1==""&&flag2==""){
				flag1=datas[i].view_type_code;
				flag2=datas[i].seqno;
				tdhtml="<td>"+td1innerhtml+"</td><td>"+td2innerhtml+"<input type=text value="+datas[i].view_well+"></td><td>"+td3innerhtml+"<input type=text value="+datas[i].view_point+"></td><td>"+td4innerhtml+"<input type=text value="+datas[i].acquire_level+"></td><td>"+td5innerhtml+"<input type=text value="+datas[i].note+"></td>";
			}else{
				if(flag1==datas[i].view_type_code&&flag2==datas[i].seqno){
					tdhtml="<td>&nbsp;</td><td>"+td2innerhtml+"<input type=text value="+datas[i].view_well+"></td><td>"+td3innerhtml+"<input type=text value="+datas[i].view_point+"></td><td>"+td4innerhtml+"<input type=text value="+datas[i].acquire_level+"></td><td>"+td5innerhtml+"<input type=text value="+datas[i].note+"></td>";
				}else{
					tdhtml="<td>"+td1innerhtml+"</td><td>"+td2innerhtml+"<input type=text value="+datas[i].view_well+"></td><td>"+td3innerhtml+"<input type=text value="+datas[i].view_point+"></td><td>"+td4innerhtml+"<input type=text value="+datas[i].acquire_level+"></td><td>"+td5innerhtml+"<input type=text value="+datas[i].note+"></td>";
				}
			}
			flag1=datas[i].view_type_code;
			flag2=datas[i].seqno;
			if(datas[i].view_type_code=="5110000053000000009"||datas[i].view_type_code=="5110000053000000010"||datas[i].view_type_code=="5110000053000000011"){
				tdhtml="<td width='18%'>"+td1innerhtml+"</td><td width='18%'>"+td2innerhtml+"</td><td width='18%'>"+td3innerhtml+"</td><td width='18%'>"+td4innerhtml+"</td><td width='18%'>"+td5innerhtml+"</td>";
			}
			var td = $(tdhtml);
			tr.append(td);
			viewtypelist.append(tr);
		}
		
	}
	
	
	function clearLoadData(){
		document.getElementById("projectForm").reset();
		document.getElementById("workareaForm").reset();
	}
	
	var selectedTagIndex = 0;
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
		
		var geographic_position = document.getElementById("geographic_position").value;
		if(geographic_position.length==0){
			alert("地理位置不能为空");
			return false;
		}
		
		var route_distance = document.getElementById("route_distance").value;
		if(route_distance.length==0){
			alert("搬迁路线及总距离不能为空");
			return false;
		}
		
		var control_measures_1 = document.getElementById("control_measures_1").value;
		if(control_measures_1.length==0){
			alert("施工风险评估及控制措施不能为空");
			return false;
		}
		
		var control_measures_2 = document.getElementById("control_measures_2").value;
		if(control_measures_2.length==0){
			alert("可能影响施工效率的原因分析及控制措施不能为空");
			return false;
		}
		
		var project_name = document.getElementById("project_name").value;
		if(project_name.length==0){
			alert("项目名不能为空");
			return false;
		}
		
		var well_no = document.getElementById("well_no").value;
		if(well_no.length==0){
			alert("井号不能为空");
			return false;
		}
		
		
		var project_income = document.getElementById("project_income").value;
		if(project_income.length==0){
			alert("预测价值工作量不能为空");
			return false;
		}
		
		var start_time = document.getElementById("start_time").value;
		if(start_time.length==0){
			alert("甲方交井时间不能为空");
			return false;
		}
		
		var end_time = document.getElementById("end_time").value;
		if(end_time.length==0){
			alert("预计完工时间不能为空");
			return false;
		}
		
		var manage_org = document.getElementById("manage_org").value;
		if(manage_org.length==0){
			alert("甲方单位不能为空");
			return false;
		}
		
		var instrument_model = document.getElementById("instrument_model").value;
		if(instrument_model.length==0){
			alert("仪器型号不能为空");
			return false;
		}
		
		
		var instrument_level = document.getElementById("instrument_level").value;
		if(instrument_level.length==0){
			alert("仪器级数不能为空");
			return false;
		}
		
		var instrument_level = document.getElementById("instrument_level").value;
		if(instrument_level.length==0){
			alert("仪器级数不能为空");
			return false;
		}
		
		
		var relocation_vehicle = document.getElementById("relocation_vehicle").value;
		if(relocation_vehicle.length==0){
			alert("动迁车辆不能为空");
			return false;
		}
		
		
		var total_depth = document.getElementById("total_depth").value;
		if(total_depth.length==0){
			alert("完钻井深不能为空");
			return false;
		}
		
		var well_temperature = document.getElementById("well_temperature").value;
		if(well_temperature.length==0){
			alert("最大井温不能为空");
			return false;
		}
		
		var well_pressure = document.getElementById("well_pressure").value;
		if(well_pressure.length==0){
			alert("井压力不能为空");
			return false;
		}
		
		
		
		//debugger;
		//激发类型
		checkboxArray = document.getElementsByName("build_type");
		str="";
		var version_val;
		var num_val;
		for(i = 0;i <checkboxArray.length;i++ ){
			if(checkboxArray[i].checked==true){
				str=checkboxArray[i].value;
				if(str=="zy"){
					var source_version = document.getElementById('source_version').value
					var source_num = document.getElementById('source_num').value
					if(source_version==""||source_version.length==0){
						alert("请输入震源型号");
						return ;
					}else{
						version_val = source_version;
					}
					if(source_num==""||source_num.length==0){
						alert("请输入震源台数");
						return ;
					}else{
						num_val = source_num;
					}
				}
				
				if(str=="zj"){
					var drill_version = document.getElementById('drill_version').value
					var drill_depth = document.getElementById('drill_depth').value
					if(drill_version==""||drill_version.length==0){
						alert("请输入钻井型号");
						return ;
					}else{
						version_val = drill_version;
					}
					if(drill_depth==""||drill_depth.length==0){
						alert("请输入钻井深度");
						return ;
					}else{
						num_val = drill_depth;
					}
				}
				
				if(str=="qt"){
					var qt_version = document.getElementById('qt_version').value
					var qt_num = document.getElementById('qt_num').value
					if(qt_version==""||qt_version.length==0){
						alert("请输入其他设备型号");
						return ;
					}else{
						version_val = qt_version;
					}
					if(qt_num==""||qt_num.length==0){
						alert("请输入其他设备台数");
						return ;
					}else{
						num_val = qt_num;
					}
				}
			}
		}
		document.getElementById('build_type').value=str+"@"+version_val+"@"+num_val;
		
		var str = "project_father_no="+document.getElementById("project_father_no").value;
		str += "&project_info_no="+document.getElementById("project_info_no").value;
		str += "&project_name="+encodeURI(encodeURI(document.getElementById("project_name").value));
		str += "&project_type="+document.getElementById("project_type").value;
		str += "&project_year="+document.getElementById("project_year").value;
		str += "&start_time="+document.getElementById("start_time").value;
		str += "&end_time="+document.getElementById("end_time").value;
		str += "&is_main_project="+document.getElementById("is_main_project").value;
		str += "&project_country="+document.getElementById("project_country").value;
		str += "&manage_org="+document.getElementById("manage_org").value;
		str += "&manage_org_name="+document.getElementById("manage_org_name").value;
		str += "&org_id="+document.getElementById("org_id").value;
		str += "&org_name="+document.getElementById("org_name").value;
		str += "&project_business_type="+document.getElementById("project_business_type").value;
		str += "&prctr="+document.getElementById("prctr").value;
		str += "&prctr_name="+document.getElementById("prctr_name").value;
		str += "&build_method="+document.getElementById("build_method").value;
		
		str += "&project_man="+document.getElementById("project_man").value;
		str += "&build_type="+document.getElementById("build_type").value;
		
		str += "&well_no="+document.getElementById("well_no").value;
		str += "&project_income="+document.getElementById("project_income").value;
		str += "&instrument_model="+document.getElementById("instrument_model").value;
		str += "&instrument_level="+document.getElementById("instrument_level").value;
		str += "&relocation_vehicle="+document.getElementById("relocation_vehicle").value;
		str += "&total_depth="+document.getElementById("total_depth").value;
		str += "&well_deviation_depth="+document.getElementById("well_deviation_depth").value;
		str += "&max_well_depth="+document.getElementById("max_well_depth").value;
		str += "&well_temperature="+document.getElementById("well_temperature").value;
		str += "&well_pressure="+document.getElementById("well_pressure").value;
		str += "&drivepipe_depth="+document.getElementById("drivepipe_depth").value;
		str += "&drivepipe_size="+document.getElementById("drivepipe_size").value;
		str += "&open_hole_depth="+document.getElementById("open_hole_depth").value;
		str += "&geographic_position="+document.getElementById("geographic_position").value;
		str += "&route_distance="+document.getElementById("route_distance").value;
		str += "&control_measures_1="+document.getElementById("control_measures_1").value;
		str += "&control_measures_2="+document.getElementById("control_measures_2").value;
		
		//常规项目
		if(document.getElementById("project_common1").checked){
			str += "&project_common=1";
		} else {
			str += "&project_common=0";
		}
		
		var obj = jcdpCallService("WsProjectSrv", "addSubProject", str);
		
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
		str += "&spare2="+document.getElementById("spare2").value;
		str += "&region_name="+document.getElementById("region_name").value;
		str += "&surface_type="+document.getElementById("surface_type").value;
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
	
	function checkWorkarea() {
        if (!isTextPropertyNotNull("workarea", "施工地区")) return false;
        if (!isLimitB100("workarea", "施工地区")) return false;
		if (!isTextPropertyNotNull("block", "区块（矿权）")) return false;	
        if (!isLimitB32("block", "区块（矿权）")) return false;
        if (!isTextPropertyNotNull("region_name", "所属行政区")) return false;	
        if (!isLimitB200("region_name", "所属行政区")) return false;
	    if (!isTextPropertyNotNull("country", "国家")) return false;
		return true;
	}
	
	

	
	
	
	function toDelete(){
	    ids = getSelIds('rdo_entity_id');
	    var s=ids.split(",");
	    var str="";
	    for(var i=0;i<s.length;i++){
		    str+=s[i].split("-")[0];
		    if(i!=(s.length)-1){
		    	
		    } str+=",";
	    }
	    if(ids==''){ 
	    	alert("请先选中至少一条记录!");
	     	return;
	    }
	    
	    var project_info_no = document.getElementById("project_info_no").value;
	    var submitStr='businessTableName=gp_task_project&businessType='+businessType+'&businessId='+project_info_no;
		var retObject=jcdpCallService('WFCommonSrv','getWfProcessHistoryInfo',submitStr)
		var procStatus=retObject.procStatus;
		if(procStatus=='3'||procStatus=='1'){
			alert("该项目已提交审批流程，无法删除");
			return ;
		}
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("WtProjectSrv", "deleteProject", "projectInfoNos="+str);
			refreshData();
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
	
	
	
	function toAdd(){
		var projectFatherName=encodeURI(encodeURI('<%=projectFatherName%>'));
		window.location = '<%=contextPath%>/pm/project/singleProject/ws/insertSubProject.jsp?projectFatherName='+projectFatherName+'&projectFatherNo='+projectFatherNo+'&orgSubjectionId='+orgSubjectionId+'&orgId='+orgId+'&projectType='+projectType;
	}
	
	function toAddViewType(){
		var project_info_no = document.getElementById("project_info_no").value;
		popWindow('<%=contextPath%>/pm/project/singleProject/ws/insertViewType.jsp?project_info_no='+project_info_no,'1200:700');
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
	
	
	
	var retObj = jcdpCallService("WorkAreaSrv", "getSurfaceType", "");  // 获取地表类型信息
	var retCrop = jcdpCallService("WorkAreaSrv", "getCropreaType", ""); // 获取作物区类型信息
	var selectTag = document.getElementById("surface_type");
	var selectTag3 = document.getElementById("crop_area_type");
	if(retObj.surfaceType != null){
		for(var i=0;i<retObj.surfaceType.length;i++){
			var record = retObj.surfaceType[i];
			var item = new Option(record.coding_name.replace(/\-/g," "),record.coding_code_id);
			var item2 = new Option(record.coding_name.replace(/\-/g," "),record.coding_code_id);
			selectTag.add(item);
		}
	}
	if(retCrop.cropAreaType != null){
		for(var i=0;i<retCrop.cropAreaType.length;i++){
			var record = retCrop.cropAreaType[i];
			var item = new Option(record.coding_name.replace(/\-/g," "),record.coding_code_id);
			selectTag3.add(item);
		}
	}
	
	$("#project_type").attr("disabled","disabled");
</script>
</html>