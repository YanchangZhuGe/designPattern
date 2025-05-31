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
	
	//保存结果 
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String message = null;
	if (respMsg != null && respMsg.getValue("message") != null) {
		message = respMsg.getValue("message");
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
<!-- 上传控件相关的js css-->
<link rel="stylesheet" href="<%=contextPath %>/js/upload/uploadify.css" type="text/css"></link>
<script type="text/javascript" src="<%=contextPath %>/js/upload/jquery.uploadify.v2.1.4.min.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/upload/swfobject.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/upload/uploadfile.js"></script>
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
				    <li id="tag3_7"><a href="#" onclick="getTab3(7)">地质任务</a></li>
				    <li id="tag3_2"><a href="#" onclick="getTab3(2)">质量指标</a></li>
				    <li id="tag3_4"><a href="#" onclick="getTab3(4)">技术指标</a></li>
				    <li id="tag3_11"><a href="#" onclick="getTab3(11)">部署图</a></li>
				    <li id="tag3_5"><a href="#" onclick="getTab3(5)">项目以往勘探程度</a></li>
				    <li id="tag3_12"><a href="#" onclick="getTab3(12)">测量测算</a></li>
				    <!-- <li id="tag3_8"><a href="#" onclick="getTab3(8)">分类码</a></li> -->
				    <li id="tag3_9"><a href="#" onclick="getTab3(9)">备注</a></li>
				  </ul>
				</div>
				<div id="tab_box" class="tab_box" style="overflow: hidden;">
					<form name="projectForm" id="projectForm"  method="post" action="">
				<div id="tab_box_content0" class="tab_box_content">
					<!-- <table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateProject()"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		              </table> -->
					<table id="tb_project" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					    <td class="inquire_item6"><span class="red_star">*</span>项目名称：</td>
					    <td class="inquire_form6" id="item0_0">
						    <input type="hidden" id="project_info_no" name="project_info_no" />
						    <input type="hidden" id="project_dynamic_no" name="project_dynamic_no" />
						    <input type="text" id="project_name" name="project_name" class="input_width" />
					    </td>
					    <td class="inquire_item6">项目编号：</td>
					    <td class="inquire_form6" id="item0_1"><input type="text" id="project_id" name="project_id" class="input_width_no_color"/></td>
					    <td class="inquire_item6">项目类型：</td>
					    <td class="inquire_form6" id="item0_2">
					    	<code:codeSelect cssClass="select_width"  name='project_type' option="projectType"  selectedValue=""  addAll="true" />
					    </td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">项目状态：</td>
					    <td class="inquire_form6"><code:codeSelect cssClass="select_width"  name='project_status' option="projectStatus"  selectedValue=""  addAll="true" /></td>
					    <td class="inquire_item6"><span class="red_star">*</span>市场范围：</td>
					    <td class="inquire_form6" id="item0_4">
					    	<input id="market_classify" name="market_classify" value="" type="hidden" class="input_width" />
							<input id="market_classify_name" name="market_classify_name" value="" type="text" class="input_width" readonly="readonly"/>
					    </td>
					    <td class="inquire_item6"><span class="red_star">*</span>年度：</td>
					    <td class="inquire_form6">
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
					    <td class="inquire_item6"><span class="red_star">*</span>计划开始时间：</td>
					    <td class="inquire_form6" id="item0_3">
						    <input type="text" id="acquire_start_time" name="acquire_start_time" value="" class="input_width" readonly="readonly"/>
						</td>
					    <td class="inquire_item6"><span class="red_star">*</span>计划结束时间：</td>
					    <td class="inquire_form6" id="item0_4">
						    <input type="text" id="acquire_end_time" name="acquire_end_time" value="" class="input_width" readonly="readonly"/>
					    </td>
					    <td class="inquire_item6"><span class="red_star">*</span>项目重要程度：</td>
					    <td class="inquire_form6">
					    	<select class=select_width name="is_main_project"  id="is_main_project" >
								<option value="0300100008000000001">集团重点</option>
								<option value="0300100008000000002">地区（局）重点</option>
								<option value="0300100008000000005">正常</option>
							</select>
					    </td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">二级单位重要程度：</td>
						<td class="inquire_form6">
							<select class=select_width name="second_main_project"  id="second_main_project" >
							    <option value=""></option>
								<option value="5110000069000000001">物探处重点</option>
								<option value="5110000069000000002">物探处正常</option>
							</select>
						</td>
						<td class="inquire_item6"><span class="red_star">*</span>项目部：</td>
						<td class="inquire_form6"><code:codeSelect cssClass="select_width"  name='project_department' option="projectDepartment"  selectedValue=""  addAll="true" /></td>
						<td class="inquire_item6"><span class="red_star">*</span>利润中心：</td>
					    <td class="inquire_form6" id="item0_3">
					    	<input type="hidden" id="prctr" name="prctr" value="" class="input_width" />
							<input type="text" id="prctr_name" name="prctr_name" value="" class="input_width"  readonly="readonly"/>
					    </td>
					  </tr>
					  <tr>
					    <td class="inquire_item6"><span class="red_star">*</span>勘探方法：</td>
					    <td class="inquire_form6">
					    	<input id="exploration_method" name="exploration_method" value="" type="hidden" class="input_width" />
							<input id="exploration_method_name" name="exploration_method_name" value="" type="text" class="input_width" readonly="readonly"/>
					    </td>
					    <td class="inquire_item6">观测方法：</td>
						<td class="inquire_form6"><code:codeSelect cssClass="select_width"  name='view_type' option="viewTypeWT"  selectedValue=""  addAll="true" /></td>
						<td class="inquire_item6"><span class="red_star">*</span>国内/国外：</td>
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
					    </td>
					    <td class="inquire_item6">勘探类型：</td>
						<td class="inquire_form6"><code:codeSelect cssClass="select_width"  name='explore_type' option="exploreTypeWT"  selectedValue=""  addAll="true" /></td>
					    <td class="inquire_item6">资料处理单位：</td>
					    <td class="inquire_form6" id="item0_3"><input type="hidden" id="bgp_report_no" name="bgp_report_no"/><input type="text" id="processing_unit" name="processing_unit" class="input_width" /></td>
					  </tr>
					  <tr>
					  	<td class="inquire_item6">比例尺：</td>
						<td class="inquire_form6"><code:codeSelect cssClass="select_width"  name='scale' option="scale"  selectedValue=""  addAll="true" /></td>
					    <td class="inquire_item6"><span class="red_star">*</span>施工队伍：</td>
						<td class="inquire_form6" id="item0_19">
							<input id="org_id" name="org_id" value="" type="hidden" class="input_width" />
							<input id="org_name" name="org_name" value="" type="text" class="input_width" />
						</td>
					    <td class="inquire_item6"><span class="red_star">*</span>项目业务类型：</td>
					    <td class="inquire_form6"><code:codeSelect cssClass="select_width"   name='project_business_type' option="projectBusinessType"  selectedValue=""  addAll="true" /></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">项目负责人：</td>
					    <td class="inquire_form6"><input type="text" id="project_man" name="project_man" value="" class="input_width" /></td>
					    <td class="inquire_item6">项目投资：</td>
						<td class="inquire_form6"><input type="text" id="project_cost" name="project_cost" value="" class="input_width" />万元</td>
					  </tr>
					</table>
				</div>
				<div id="tab_box_content7" class="tab_box_content" style="display:none;">
					<!-- <table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateProject()"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		              </table> -->
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					  	<td class="inquire_item4"><span class="red_star">*</span>地质任务：</td>
						<td colspan="3" class="inquire_form4"><textarea id="notes"  name="notes" cols="45" rows="5" class="textarea"></textarea></td>
						</tr>
					</table>
					</div>
					<div id="tab_box_content7" class="tab_box_content" style="display:none;">
						<!-- <table width="100%" border="0" cellspacing="0" cellpadding="0">
			                <tr align="right" height="30">
			                  <td>&nbsp;</td>
			                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateProject()"><a href="#"></a></span></td>
			                  <td width="5"></td>
			                </tr>
		                </table> -->
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						  	<tr>
							  	<td class="inquire_item4"><span class="red_star">*</span>地质任务：</td>
								<td colspan="3" class="inquire_form4"><textarea id="notes"  name="notes" cols="45" rows="5" class="textarea"></textarea></td>
							</tr>
						</table>
					</div>
					<div id="tab_box_content4" class="tab_box_content" style="display:none;">
						<!-- <table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30"><span class="bc"  onclick="toUpdateProject()"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
			            </table> -->
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						  <tr>
						  	<td class="inquire_item4"><span class="red_star">*</span>技术指标：</td>
							<td colspan="3" class="inquire_form4"><textarea id="qualifications"  name="qualifications" cols="45" rows="5" class="textarea"></textarea></td>
							</tr>
						</table>
					</div>
				</form>
					<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<!-- <table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateWorkLoad()"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		              </table> -->
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
						<!-- <table width="100%" border="0" cellspacing="0" cellpadding="0">
			                <tr align="right" height="30">
			                  <td><input id="workarea_no" name="workarea_no"type="hidden" /></td>
			                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateWorkarea()"><a href="#"></a></span></td>
			                  <td width="5"></td>
			                </tr>
			              </table> -->
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						    <tr>
						      <td class="inquire_item6"><span class="red_star">*</span>工区名称：</td>
						      <td class="inquire_form6"><input id="workarea"  name="workarea"class="input_width" type="text" /><input id="start_year" name="start_year" class="input_width" type="hidden" /></td>
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
					
					<div id="tab_box_content5" class="tab_box_content" style="display:none;">
					 <form id="degreeForm" name="degreeForm" action="" method="post" enctype="multipart/form-data">
						  <!-- <table width="100%" border="0" cellspacing="0" cellpadding="0">
			                <tr align="right" height="30">
			                  <td>
				                  <input id="exploration_degree_id"  name="exploration_degree_id" type="hidden" />
				                  <input type="hidden" id="oldUcmId" name="oldUcmId" value=""/>
			                  </td>
			                  <td width="30"><span class="bc"  onclick="toUpdateDegree()"><a href="#"></a></span></td>
			                  <td width="5"></td>
			                </tr>
			              </table> -->
						  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						    <tr>
						      <td class="inquire_item6">项目名称：</td>
						      <td class="inquire_form6"><input id="de_project_name"  name="de_project_name" class="input_width" type="text" disabled="disabled" readOnly="readonly"/></td>
						      <td class="inquire_item6">施工队伍：</td>
						      <td class="inquire_form6" ><input id="de_org_name" name="de_org_name" class="input_width" type="text" /></td>
						      <td class="inquire_item6">勘探方法：</td>
						      <td class="inquire_form6" ><input id="de_exploration_method" name="de_exploration_method" class="input_width" type="text" /></td>
						    </tr>
						    <tr>
						      <td class="inquire_item6">观测类型:</td>
						      <td class="inquire_form6"><input id="de_view_type" name="de_view_type" class="input_width" type="text" /></td>
						      <td class="inquire_item6">使用仪器：</td>
						      <td class="inquire_form6" ><input id="de_instrument" name="de_instrument" class="input_width" type="text" /></td>
						      <td class="inquire_item6">比例尺：</td>
						      <td class="inquire_form6" ><input id="de_scale" name="de_scale" class="input_width" type="text" /></td>
						     </tr>
						     <tr>
						      <td class="inquire_item6">点距：</td>
						      <td class="inquire_form6"><input id="de_point_distance" name="de_point_distance" class="input_width" type="text" />km</td>
						      <td class="inquire_item6">线距：</td>
						      <td class="inquire_form6"><input id="de_line_distance" name="de_line_distance" class="input_width" type="text" />km</td>
						      <td class="inquire_item6"></td>
						      <td class="inquire_form6"></td>
						     </tr>
						     <tr>
						    	<td class="inquire_item6"><font color="red">*</font>勘探程度图：</td>
						    	<td colspan="5"> 
						       	 	<!-- <div style="float:left" id="fileQueue" style="border:1px solid green;width:400px"></div>
									<div id="file_content" style="float:left"><input type="file"  name="file" id="file" readonly="readonly"/></div>
									<div id="status-message"></div>  -->
									<div id="td_down"></div>
								</td>
								<td><div style="display:none;"><input type="text" name="upload_file_name" id="upload_file_name" />
	      							<input type="text" name="doc_name" id="doc_name" class="input_width"/>
							      		<select name="doc_type" id="doc_type" class="select_width">
								      		<option value="0">-请选择-</option>
								      		<option value="word">word</option>
								      		<option value="excel">excel</option>
								      		<option value="ppt">PowerPoint</option>
								      		<option value="pdf">PDF</option>
								      		<option value="txt">TXT</option>
								      		<option value="picture">图片文件</option>
								      		<option value="compress">压缩文件</option>
								      		<option value="other">其他文件</option>
								      	</select>
	      							</div>
	      					 	</td>
						    </tr>
						</table>
					  </form>
					</div>
				
					<div id="tab_box_content2" class="tab_box_content" style="display:none;">
					 <form action="" id="qualityForm" name="qualityForm" method="post">
						<!-- <table width="100%" border="0" cellspacing="0" cellpadding="0">
			                <tr align="right" height="30">
			                  <td>
			                  	
			                  </td>
			                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateQuality()"><a href="#"></a></span></td>
			                  <td width="5"></td>
			                </tr>
			              </table> -->
						  <table id="tbQuality"  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						  </table>
					  </form>
					</div>
					
					<!-- <div id="tab_box_content8" class="tab_box_content" style="display:none;">
						<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: auto;"></iframe>
					</div> -->
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
var message="<%=message%>";

if (message != null&&"null"!=message) {
	alert("修改成功");
}

cruConfig.contextPath = "<%=contextPath%>";
cruConfig.cdtType = 'form';
//debugger;
var expMethod = "";
var well_no="";
var qualification_no="";
var num=0;
var num_q=0;
var retObj = jcdpCallService("WtProjectSrv", "getProjectInfo", "projectInfoNo=<%=projectInfoNo%>");
document.getElementById("project_info_no").value= retObj.map.project_info_no;
document.getElementById("project_name").value= retObj.map.project_name;
document.getElementById("project_id").value= retObj.map.project_id;
document.getElementById("project_year").value= retObj.map.project_year;
document.getElementById("start_year").value= retObj.map.project_year;
document.getElementById("acquire_start_time").value= retObj.map.acquire_start_time;
document.getElementById("acquire_end_time").value= retObj.map.acquire_end_time;
document.getElementById("prctr_name").value= retObj.map.prctr_name;
document.getElementById("prctr").value= retObj.map.prctr;
var fullname=this.getFullManageOrg(retObj.map.manage_org);
document.getElementById("manage_org_name").value=fullname+retObj.map.manage_org_name;
document.getElementById("manage_org").value= retObj.map.manage_org;
document.getElementById("org_name").value= retObj.dynamicMap.org_name;
document.getElementById("project_cost").value= retObj.map.project_cost;
document.getElementById("project_man").value= retObj.map.project_man;
document.getElementById("notes").value= retObj.map.notes;
document.getElementById("qualifications").value= retObj.map.qualifications;
document.getElementById("exploration_method").value= retObj.dynamicMap.exploration_method;
document.getElementById("exploration_method_name").value= retObj.dynamicMap.exploration_method_name;


document.getElementById("market_classify").value= retObj.map.market_classify;
document.getElementById("market_classify_name").value= retObj.map.market_classify_name;
document.getElementById("org_id").value= retObj.dynamicMap.org_id;
document.getElementById("project_dynamic_no").value= retObj.dynamicMap.project_dynamic_no;

//document.getElementById("bgp_report_no").value= retObj.map.bgp_report_no;
//document.getElementById("processing_unit").value= retObj.map.processing_unit;

document.getElementById("project_department").value= retObj.map.project_department;

var workarea_no = retObj.map.workarea_no;
well_no = retObj.map.well_no;
qualification_no = retObj.map.qualification_no;

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

sel = document.getElementsByName("second_main_project")[0].options;
value = retObj.map.second_main_project;
for(var i=0;i<sel.length;i++)
{
    if(value==sel[i].value)
    {
       document.getElementsByName('second_main_project')[0].options[i].selected=true;
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

//--------------------------------------------质量指标信息----------------------------------------------
num_q=0;
for(var i=0;i<retObj.qualityMap.length;i++){
	var exploration_method=retObj.qualityMap==null?"":retObj.qualityMap[i].exploration_method;
	var mapName=retObj.qualityMap==null?"":retObj.qualityMap[i].exploration_method_name;
	var mapCode=retObj.qualityMap==null?"":retObj.qualityMap[i].superior_code_id;
	var object_id=retObj.qualityMap==null?"":retObj.qualityMap[i].object_id;
	var firstlevel_radio=retObj.qualityMap==null?"":retObj.qualityMap[i].firstlevel_radio;
	var qualified_radio=retObj.qualityMap==null?"":retObj.qualityMap[i].qualified_radio;
	var waster_radio=retObj.qualityMap==null?"":retObj.qualityMap[i].waster_radio;
	var miss_radio=retObj.qualityMap==null?"":retObj.qualityMap[i].miss_radio;
	addRow_quality(mapName,exploration_method,object_id,firstlevel_radio,qualified_radio,waster_radio,miss_radio);
}
//document.getElementById("num_q").value=num_q;
//调整样式
addTdCss("tbQuality","#mapNameQual",num_q);
//-------------------------------------项目以往勘探程度--------------------------------------------
document.getElementById("de_project_name").value= retObj.map.project_name;
	$("#td_down").html("");
if(null!=retObj.degreeMap){
	//document.getElementById("exploration_degree_id").value = retObj.degreeMap[0].exploration_degree_id;
	document.getElementById("de_org_name").value = retObj.degreeMap[0].de_org_name;
	document.getElementById("de_exploration_method").value =retObj.degreeMap[0].de_exploration_method;
	document.getElementById("de_view_type").value =retObj.degreeMap[0].de_view_type;
	document.getElementById("de_instrument").value =retObj.degreeMap[0].de_instrument;
	document.getElementById("de_scale").value =retObj.degreeMap[0].de_scale;
	document.getElementById("de_point_distance").value =retObj.degreeMap[0].de_point_distance;
	document.getElementById("de_line_distance").value =retObj.degreeMap[0].de_line_distance;

	<%-- if(null!=retObj.degreeMap[0].ucm_id&&""!=retObj.degreeMap[0].ucm_id){
		var umc_id=retObj.degreeMap[0].ucm_id;
		var file_name = retObj.degreeMap[0].file_name;
		var url = "<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+umc_id+"&emflag=0";
		var html = "<a style='color:blue;' href="+url+">"+file_name+"</a>";
		$("#td_down").html(html);
	} --%>
}

//部署图
document.getElementById("deployDiagram").src ="<%=contextPath%>/pm/deployDiagram/deployDiagramList.jsp?projectInfoNo=<%=projectInfoNo %>";

//分类码
//document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=3&relationId=<%=projectInfoNo %>";

//测量测算 encodeURI(encodeURI(_tmplsgx)
$("#measurement")[0].src = "<%=contextPath%>/pm/measurement/wt/measurementList.jsp?action=view&projectInfoNo=<%=projectInfoNo %>&viewmeasurement=1&lineUnit="+document.getElementById("line_unit").value;
		
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
	//document.getElementById("workarea_no").value = workarea_no;
	document.getElementById("workarea").value = retWorkArea.workarea.workarea;
	document.getElementById("start_year").value = retWorkArea.workarea.start_year;
	document.getElementById("basin").value = retWorkArea.workarea.basin;
	var fullname=this.getFullManageOrg(retWorkArea.workarea.block);
	document.getElementById("spare2").value=fullname+retWorkArea.workarea.spare2;
	//document.getElementById("spare2").value = retWorkArea.workarea.spare2;
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

// 备注
document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId=<%=projectInfoNo %>&action=view";


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

/* function toUpdateProject(){
	if(document.getElementById("tab_box_content7").style.display==""||document.getElementById("tab_box_content7").style.display=="block"){
        if (!isTextPropertyNotNull("notes", "地质任务")) return false;
	}
	if(document.getElementById("tab_box_content4").style.display==""||document.getElementById("tab_box_content4").style.display=="block"){
		if (!isTextPropertyNotNull("qualifications", "技术指标")) return false;
	}
	
	var params = $("#projectForm").serialize();
	var obj = jcdpCallService("WtProjectSrv","addProject",params);
	if(obj != null && obj.message == "success") {
		alert("修改成功");
	} else {
		alert("修改失败");
	}
} */

function toUpdateWorkarea(){
	if(!checkWorkarea()) return;
	var params = $("#workareaForm").serialize();
	params+="&project_info_no="+document.getElementById("project_info_no").value;
	cruConfig.contextPath = '<%=contextPath%>';
	var obj = jcdpCallService("WorkAreaSrv", "saveOrUpdateWorkarea",params);
	if(obj != null && obj.message == "success") {
		alert("修改成功");
	} else {
		alert("修改失败");
	}
}

function toUpdateDegree(){
	var proj_no=document.getElementById("project_info_no").value;
	if(""==proj_no){
		alert("请先选择一条项目信息!");
		return;
	}
	if (!isLimitB200("de_org_name", "施工队伍")) return false;
	if (!isLimitB200("de_exploration_method", "勘探方法")) return false;
	if (!isLimitB100("de_view_type", "观测类型")) return false;
	if (!isLimitB100("de_instrument", "使用仪器")) return false;
	if (!isLimitB32("de_instrument", "比例尺")) return false;
	if(!isValidFloatProperty13_3("de_point_distance","点距")) return false;  
	if(!isValidFloatProperty13_3("de_line_distance","线距")) return false;

	var params = $("#degreeForm").serialize();
	params+="&project_info_no="+project_info_no;
	var obj = jcdpCallService("WtProjectSrv","saveOrUpdateDegree",params);
	if(obj != null && obj.message == "success") {
		alert("修改成功");
		//回填信息
		for(var i=1;i<=num;i++){
			$("#exploration_degree_id").val(obj.exploration_degree_id);
			$("#oldUcmId").val(obj.ucmDocId);
			$("#td_down").html("&nbsp;<a style='color:blue;' href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+obj.ucmDocId+"&emflag=0>"+obj.uploadFileName+"</a>");
		}
	} else {
		alert("修改失败");
	}
}

function checkWorkarea() {
    if (!isTextPropertyNotNull("workarea", "工区名称")) return false;	
    if (!isLimitB100("workarea", "工区名称")) return false;	
    if (!isLimitB100("basin", "盆地")) return false;	
    if (!isLimitB32("block", "区块（矿权）")) return false;	
    if (!isTextPropertyNotNull("region_name", "所属行政区")) return false;	
    if (!isLimitB100("basin", "所属行政区")) return false;	
    if (!isTextPropertyNotNull("focus_x", "工区中心经度")) return false;
    if (!isValidFloatProperty12_9("focus_x", "工区中心经度")) return false;	
    if (!isTextPropertyNotNull("focus_y", "工区中心纬度")) return false;		
    if (!isValidFloatProperty12_9("focus_y", "工区中心纬度")) return false;	
    if (!isTextPropertyNotNull("country", "国家")) return false;
	return true;
}

/* function toUpdateWorkLoad(){
	var project_info_no=document.getElementById("project_info_no").value;
	var form = document.forms["workloadForm"];
	var params = $("#workloadForm").serialize();
	params+="&project_info_no="+project_info_no;
	var obj = jcdpCallService("WtProjectSrv","addProjectWorkLoad",params);
	if(obj != null && obj.message == "success") {
		alert("修改成功");
		
		//回填工作量workload_id
		$("#workload_id").val(obj.workload_id);
		for(var i=1;i<=num;i++){
			$("#workload_id_"+i).val(obj['workload_id_'+i]);
		}
	} else {
		alert("修改失败");
	}
} */

/* function toUpdateQuality(){
	var project_info_no=document.getElementById("project_info_no").value;
	var params = $("#qualityForm").serialize();
	params+="&project_info_no="+project_info_no;
	var obj = jcdpCallService("WtProjectSrv","saveOrUpdateQuality",params);
	if(obj != null && obj.message == "success") {
		alert("修改成功");
		
		//回填主键object_id
		for(var i=1;i<=num;i++){
			$("#object_id_"+i).val(obj['object_id_'+i]);
		}
	} else {
		alert("修改失败");
	}
} */

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

function addRow_quality(mapName,exploration_method,object_id,firstlevel_radio,qualified_radio,waster_radio,miss_radio){
	++num_q;
	//插入第一行标题
	var tr0=document.all.tbQuality.insertRow();
	tr0.className = "bt_info_odd";
	var td0 = tr0.insertCell(0);
	td0.setAttribute("colspan",6);
	td0.setAttribute("id", "mapNameQual"+num_q);
	td0.innerHTML="<font size='2'>"+mapName+"</font></td>";
	var tr=document.all.tbQuality.insertRow();
  	tr.insertCell(0).innerHTML="<input type='hidden' id='object_id_"+num_q+"' name='object_id_"+num_q+"' value='"+object_id+"'/>"+
  	"<input type='hidden' value='"+exploration_method+"' id='exploration_method_q_"+num_q+"' name='exploration_method_q_"+num_q+"'/>一级品率：";
  	tr.insertCell(1).innerHTML="<input class='input_width' type='text' id='firstlevel_radio_"+num_q+"' name='firstlevel_radio_"+num_q+"' value='"+firstlevel_radio+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>%";
  	tr.insertCell(2).innerHTML="合格品率：";
  	tr.insertCell(3).innerHTML="<input class='input_width' type='text' id='qualified_radio_"+num_q+"' name='qualified_radio_"+num_q+"' value='"+qualified_radio+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>%";
	tr.insertCell(4).innerHTML="废品率：";
  	tr.insertCell(5).innerHTML="<input class='input_width' type='text' id='waster_radio_"+num_q+"' name='waster_radio_"+num_q+"' value='"+waster_radio+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>%";
  	var tr1=document.all.tbQuality.insertRow();
	tr1.insertCell(0).innerHTML="空点率：";
  	tr1.insertCell(1).innerHTML="<input class='input_width' type='text' id='miss_radio_"+num_q+"' name='miss_radio_"+num_q+"' value='"+miss_radio+"' onkeyup='if(isNaN(value))execCommand(\"undo\")' onafterpaste='if(isNaN(value))execCommand(\"undo\")'/>%";
}
$("#tb_project input[type=text]").attr("readonly","readonly");
$("#is_main_project").attr("disabled","disabled");
$("#second_main_project").attr("disabled","disabled");
$("#explore_type").attr("disabled","disabled");
$("#project_department").attr("disabled","disabled");
$("#view_type").attr("disabled","disabled");
$("#scale").attr("disabled","disabled");
$("#project_business_type").attr("disabled","disabled");
$("#project_year").attr("disabled","disabled");
$("#project_type").attr("disabled","disabled");
$("#project_country").attr("disabled","disabled");

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

function getFullManageOrg(id){
	var querySql = "select t.coding_name from comm_coding_sort_detail t where t.coding_code_id=(select superior_code_id from comm_coding_sort_detail where coding_code_id='"+id+"')";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	var datas = queryRet.datas;
	var name="";
	if(datas!=null && datas.length>0){
		name=datas[0].coding_name+"/";
	}
	return name;
}
</script>
</html>