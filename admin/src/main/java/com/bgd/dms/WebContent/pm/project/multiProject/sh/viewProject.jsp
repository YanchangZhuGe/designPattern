<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="code" prefix="code"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page  import="java.util.*" %>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);	

	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo == null || "".equals(projectInfoNo) || projectInfoNo == "null" || "null".equals(projectInfoNo)) {
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
				    <!-- <li id="tag3_7"><a href="#" onclick="getTab3(7)">地质任务</a></li> -->
				    <li id="tag3_2"><a href="#" onclick="getTab3(2)">质量指标</a></li>
				   
				    <li id="tag3_11"><a href="#" onclick="getTab3(11)">部署图</a></li>
				   
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
									<select class=select_width name=project_type id='project_type' disabled="disabled">
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
								<td class="inquire_item4">计划采集开始时间：</td>
								<td class="inquire_form4" id="item0_6">
									<input type="text" id="acquire_start_time" name="acquire_start_time" value="" class="input_width" readonly="readonly"/>
									<%-- &nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acquire_start_time,tributton1);" /> --%>
								</td>
								<td class="inquire_item4">计划采集结束时间：</td>
								<td class="inquire_form4" id="item0_7">
									<input type="text" id="acquire_end_time" name="acquire_end_time" value="" class="input_width" readonly="readonly"/>
									<%-- &nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acquire_end_time,tributton2);" /> --%>
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">合同开始时间：</td>
								<td class="inquire_form4" id="item0_9">
									<input type="text" id="design_start_date" name="design_start_date" value="" class="input_width" readonly="readonly"/>
									<%-- &nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(design_start_date,tributton3);" /> --%>
								</td>
								<td class="inquire_item4">合同结束时间：</td>
								<td class="inquire_form4" id="item0_10">
									<input type="text" id="design_end_date" name="design_end_date" value="" class="input_width" readonly="readonly"/>
									<%-- &nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(design_end_date,tributton4);" /> --%>
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">项目重要程度：</td>
								<td class="inquire_form4" id="item0_8"><code:codeSelect cssClass="select_width" name='is_main_project' option="isMainProject" selectedValue="" addAll="true" /></td>
								<td class="inquire_item4">勘探方法：</td>
								<td class="inquire_form4" id="item0_11">
									<select class=select_width name=exploration_method  id="exploration_method" disabled='disabled'>
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
									<select class=select_width name=project_country id="project_country" disabled='disabled'>
											<option value="1">国内</option>
											<option value="2">国外</option>
									</select>
								</td>
								<td class="inquire_item4">甲方单位：</td>
								<td class="inquire_form4" id="item0_13">
									<input id="manage_org" name="manage_org" value="" type="hidden" class="input_width" />
									<input id="manage_org_name" name="manage_org_name" value="" type="text" class="input_width" readonly="readonly"/>
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
								<td class="inquire_item4">施工队伍：</td>
								<td class="inquire_form4" id="item0_19">
									<input id="org_id" name="org_id" value="" type="hidden" class="input_width" />
									<input id="org_name" name="org_name" value="" type="text" class="input_width" readonly="readonly"/>
								</td>
							</tr>
						</table>

					</div>
					
					
					
					<div id="tab_box_content1" class="tab_box_content" style="display:none;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" id="workload_table">
						  <tr><input type="hidden" id="project_dynamic_no" name="project_dynamic_no" />
						  	  <input type="hidden" id="workload" name="workload" />
						    <td class="inquire_item6" id="design_line_num_td"><span class="red_star">*</span>设计线束数：</td>
						    <td class="inquire_form6" id="item1_0"><input type="text" id="design_line_num" name="design_line_num" class="input_width" />&nbsp;条</td>
						    <td class="inquire_item6" id="design_object_workload1_td">设计工作量：</td>
						    <td class="inquire_form6" id="workload_td1" >
					    			<input   id="workload_input2" name="workload_input2" class="input_width" />&nbsp;KM²	
					     	</td>
						    <td class="inquire_item6" id=""></td>
						    <td class="inquire_form6" id="item1_22"></td>

						  </tr>
						  
						</table>	

					</div>
					<!-- <div id="tab_box_content7" class="tab_box_content" style="display:none;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" id="notes_table">
						  <tr>
						  	<td class="inquire_item4">地质任务：</td>
							<td colspan="3" class="inquire_form4"><textarea id="notes"  name="notes"cols="45" rows="5" class="textarea"></textarea></td>
							</tr>
						</table>
	
					</div> -->
					
					<div id="tab_box_content3" class="tab_box_content" style="display:none;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" id="workarea_table">
						    <tr><input id="workarea_no"  name="workarea_no"type="hidden" /><input type="hidden" id="project_info_no1" name="project_info_no1" />
						      <td class="inquire_item6"><span class="red_star">*</span>工区名称：</td>
						      <td class="inquire_form6"><input id="workarea"  name="workarea"class="input_width" type="text" /><input id="start_year" name="start_year" class="input_width" type="hidden" /></td>
						     
						      <td class="inquire_item6">区块（矿权）：</td>
						      <td class="inquire_form6" >
						      	<input name="block" id="block" value="" type="hidden" class="input_width" />
						      	<input id="spare2"  name="spare2"class="input_width" type="text"  readonly="readonly"/>
						      </td>
						       <td class="inquire_item6"></td>
						      <td class="inquire_form6"></td>
						    </tr>
						    <tr>
						      <td class="inquire_item6"><span class="red_star">*</span>所属行政区:</td>
						      <td class="inquire_form6"><input id="region_name"  name="region_name"class="input_width" type="text" /></td>
						      <td class="inquire_item6">主要地表类型：</td>
						      <td class="inquire_form6" ><select id="surface_type" name="surface_type" class="select_width"></select></td>
						      <td class="inquire_item6"></td>
						      <td class="inquire_form6"></td>
						     </tr>
						     <tr>
						      <td class="inquire_item6"><span class="red_star">*</span>工区中心经度：</td>
						      <td class="inquire_form6" ><input id="focus_x"  name="focus_x" class="input_width" type="text" /></td>
						      <td class="inquire_item6"><span class="red_star">*</span>工区中心纬度:</td>
						      <td class="inquire_form6" ><input id="focus_y"  name="focus_y"class="input_width" type="text" /></td>
						      <td class="inquire_item6"></td>
						      <td class="inquire_form6" ></td>
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
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" id="ratio_table">
						 	<!-- <tr>
								<td class="inquire_item4">合格品率≧<input type="hidden" id="object_id" name="object_id" /></td>
								<td class="inquire_form4"><input id="qualified_radio" name="qualified_radio" class="input_width"/>&nbsp;%</td>	
								<td class="inquire_item4">废品率≦</td>
								<td class="inquire_form4"><input id="waster_radio" name="waster_radio" class="input_width"/>&nbsp;%</td>
							</tr> -->
							<tr>
							  	<td class="inquire_item4" id="item2_0">单束线空炮率≦</td>
								<td class="inquire_form4"><input id="miss_radio" name="miss_radio" class="input_width"/>&nbsp;%</td>
								<td class="inquire_item4">全工区空炮率≦</td>
								<td class="inquire_form4"><input id="all_miss_radio" name="all_miss_radio" class="input_width"/>&nbsp;%</td>	
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

	//alert("深海");
	debugger;
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	debugger;
	
	
	var retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo=<%=projectInfoNo%>");
	document.getElementById("project_name").value= retObj.map.project_name;
	document.getElementById("project_id").value= retObj.map.project_id;
	document.getElementById("project_year").value= retObj.map.project_year;
	document.getElementById("acquire_start_time").value= retObj.map.acquire_start_time;
	document.getElementById("acquire_end_time").value= retObj.map.acquire_end_time;
	document.getElementById("design_start_date").value= retObj.map.design_start_date;
	document.getElementById("design_end_date").value= retObj.map.design_end_date;
	document.getElementById("prctr_name").value= retObj.map.prctr_name;
	document.getElementById("prctr").value= retObj.map.prctr;
	document.getElementById("manage_org_name").value= retObj.map.manage_org_name;
	document.getElementById("manage_org").value= retObj.map.manage_org;
	document.getElementById("market_classify_name").value= retObj.map.market_classify_name;
	document.getElementById("market_classify").value= retObj.map.market_classify;
	document.getElementById("org_name").value= retObj.dynamicMap.org_name;
	//document.getElementById("notes").value= retObj.map.notes;
	
	
	document.getElementById("project_dynamic_no").value= retObj.dynamicMap.project_dynamic_no;
	document.getElementById("workload").value= retObj.dynamicMap.workload;
	
	document.getElementById("org_id").value= retObj.dynamicMap.org_id;
	document.getElementById("org_name").value= retObj.dynamicMap.org_name;
	
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

	////////////////////////////////////////////////////工作量 ////////////////////////////////////////////////
	//根据bulid_method的值设置显示信息
	var buildMethod = retObj.map.build_method;


	var exploration_method= retObj.map.exploration_method;

	document.getElementById("design_line_num").value= retObj.dynamicMap.design_line_num;//设计线束数
	//document.getElementById("design_object_workload").value= retObj.dynamicMap.design_object_workload;//设计工作量
	document.getElementById("workload_input2").value= retObj.dynamicMap.design_sp_num;//设计工作量
	//document.getElementById("design_workload1").value= retObj.dynamicMap.design_workload1;
	//document.getElementById("design_workload2").value= retObj.dynamicMap.design_workload2;




	//////////////////////////////////////////////部署图/////////////////////////////////////////////////
	document.getElementById("deployDiagram").src = "<%=contextPath%>/pm/deployDiagram/deployDiagramList.jsp?projectInfoNo=<%=projectInfoNo %>";


		
var retObj = jcdpCallService("WorkAreaSrv", "getSurfaceType", "");
var retCrop = jcdpCallService("WorkAreaSrv", "getCropreaType", "");
var selectTag = document.getElementById("surface_type");
//var selectTag2 = document.getElementById("second_surface_type");
//var selectTag3 = document.getElementById("crop_area_type");
if(retObj.surfaceType != null){
	for(var i=0;i<retObj.surfaceType.length;i++){
		var record = retObj.surfaceType[i];
		var item = new Option(record.coding_name.replace(/\-/g," "),record.coding_code_id);
		//var item2 = new Option(record.coding_name.replace(/\-/g," "),record.coding_code_id);
		selectTag.add(item);
		//selectTag2.add(item2);
	}
}
if(retCrop.cropAreaType != null){
	for(var i=0;i<retCrop.cropAreaType.length;i++){
		var record = retCrop.cropAreaType[i];
		var item = new Option(record.coding_name.replace(/\-/g," "),record.coding_code_id);
		//selectTag3.add(item);
	}
}



	///////////////////////////////////////////////////工区信息///////////////////////////////////////////////
	if(workarea_no != null && workarea_no != ""){
		var retWorkArea = jcdpCallService("WorkAreaSrv", "getWorkarea", "workareaNo="+workarea_no);
		document.getElementById("workarea_no").value = workarea_no;
		document.getElementById("workarea").value = retWorkArea.workarea.workarea;
		document.getElementById("start_year").value = retWorkArea.workarea.start_year;
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
	}

//质量指标
debugger;
var retQuality = jcdpCallService("ProjectSrv", "getQuality", "projectInfoNo=<%=projectInfoNo %>");

//document.getElementById("item2_0").innerHTML= '单束线空炮率≦';

if(retQuality != null && retQuality.qualityMap != null){
	//document.getElementById("object_id").value = retQuality.qualityMap.objectId;
	//document.getElementById("qualified_radio").value = retQuality.qualityMap.qualifiedRadio;
	//document.getElementById("waster_radio").value = retQuality.qualityMap.wasterRadio;
	document.getElementById("miss_radio").value = retQuality.qualityMap.missRadio;
	document.getElementById("all_miss_radio").value = retQuality.qualityMap.allMissRadio;
}
// 备注
document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId=<%=projectInfoNo %>";

$("#is_main_project").attr("disabled","disabled");
$("#project_business_type").attr("disabled","disabled");
$("#workload_table input[type=text]").attr("readonly","readonly");
$("#workarea_table input[type=text]").attr("readonly","readonly");
$("#workarea_table select").attr("disabled","disabled");
$("#notes_table :input").attr("readonly","readonly");
$("#ratio_table input[type=text]").attr("readonly","readonly");
</script>
</html>