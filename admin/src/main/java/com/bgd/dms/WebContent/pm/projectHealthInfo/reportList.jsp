<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="java.util.*" %>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{project_info_no}' id='rdo_entity_id_{project_info_no}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{project_name}" >项目名称</td>
			      <td class="bt_info_even" exp="{org_abbreviation}" >施工队伍</td>
			      <td class="bt_info_odd" exp="{project_status_name}" >项目状态</td>
			      <td class="bt_info_even" exp="<img src='<%=contextPath%>/pm/projectHealthInfo/head{pm_info}.jpg' alt=''  width='14px' height='14px'/> " >生产</td>
			      <td class="bt_info_odd" exp="<img src='<%=contextPath%>/pm/projectHealthInfo/head{qm_info}.jpg' alt=''  width='14px' height='14px'/> " >质量</td>
			      <td class="bt_info_even" exp="<img src='<%=contextPath%>/pm/projectHealthInfo/head{hse_info}.jpg' alt=''  width='14px' height='14px'/> " >HSE </td>
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">项目信息</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<form name="projectForm" id="projectForm"  method="post" action="">
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                </tr>
		              </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr>
							<td class="inquire_item6"><span class="red_star">*</span>EPS：</td>
							<td class="inquire_form6" colspan="5"><input type="text" id="eps" name="eps" value="待定" class="input_width" /></td>
						</tr>
					  <tr>
					    <td class="inquire_item6"><span class="red_star">*</span>项目名称：</td>
					    <td class="inquire_form6" id="item0_0"><input type="hidden" id="project_info_no" name="project_info_no" /><input type="text" id="project_name" name="project_name" class="input_width" /></td>
					    <td class="inquire_item6">项目编号：</td>
					    <td class="inquire_form6" id="item0_1"><input type="text" id="project_id" name="project_id" class="input_width_no_color"  disabled="disabled" readOnly="readonly"/></td>
					    <td class="inquire_item6">项目类型：</td>
					    <td class="inquire_form6" id="item0_2">
					    	<select class="select_width" name="project_type" id="project_type">
								<option value='5000100004000000001'>陆地项目</option>
								<option value='5000100004000000007'>陆地和浅海项目</option>
							</select>
					    </td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">项目状态：</td>
					    <td class="inquire_form6" id="item0_3">
					    	<code:codeSelect cssClass="select_width"  name='project_status' option="projectStatus"  selectedValue=""  addAll="true" />
					    </td>
					    <td class="inquire_item6">市场范围：</td>
					    <td class="inquire_form6" id="item0_4">
					    	<input id="market_classify" name="market_classify" value="" type="hidden" class="input_width" />
							<input id="market_classify_name" name="market_classify_name" value="" type="text" class="input_width" readOnly="readonly"/>
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
					    <td class="inquire_item6">计划采集开始时间：</td>
					    <td class="inquire_form6" id="item0_3">
						    <input type="text" id="acquire_start_time" name="acquire_start_time" value="" class="input_width" readOnly="readonly"/>
							&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acquire_start_time,tributton1);" />
						</td>
					    <td class="inquire_item6">计划采集结束时间：</td>
					    <td class="inquire_form6" id="item0_4">
						    <input type="text" id="acquire_end_time" name="acquire_end_time" value="" class="input_width" readOnly="readonly"/>
							&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acquire_end_time,tributton2);" />
					    </td>
					    <td class="inquire_item6">项目重要程度：</td>
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
					    <td class="inquire_item6">勘探方法：</td>
					    <td class="inquire_form6" id="item0_5">
					    	<select class=select_width name=exploration_method  id="exploration_method" >
									<option value="0300100012000000002">二维地震</option>
									<option value="0300100012000000003">三维地震</option>
									<option value="0300100012000000023">四维地震</option>
									<option value="0300100012000000028">多波</option>
							</select>
					    </td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">国内/国外：</td>
					    <td class="inquire_form6" id="item0_3">
					    	<select class="select_width" name="project_country" id="project_country">
								<option value='1'>国内</option>
								<option value='2'>国外</option>
							</select>
					    </td>
					    <td class="inquire_item6">甲方单位：</td>
					    <td class="inquire_form6" id="item0_4">
					    	<input type="hidden" id="manage_org" name="manage_org" class="input_width" readOnly="readonly"/>
					    	<input type="text" id="manage_org_name" name="manage_org_name" class="input_width" />
					    	<img src="<%= request.getContextPath() %>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectCoding('0100100014','manage_org','manage_org_name');" />
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
					  </tr>
					  <tr>
					    <td class="inquire_item6">资料处理单位：</td>
					    <td class="inquire_form6" id="item0_3"><input type="text" id="a" name="a" class="input_width" /></td>
					    <td class="inquire_item6">激发方式：</td>
					    <td class="inquire_form6" id="item0_4">
							<select class=select_width name=build_method id="build_method">
									<option value="5000100003000000001">井炮</option>
									<option value="5000100003000000002">震源</option>
							</select>
						</td>
					    <td class="inquire_item6">项目业务类型：</td>
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
					    <td class="inquire_item4"><span class="red_star">*</span>施工队伍：</td>
						<td class="inquire_form4" id="item0_19">
							<input id="org_id" name="org_id" value="" type="hidden" class="input_width" />
							<input id="org_name" name="org_name" value="" type="text" class="input_width" />
							&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectTeam()" />
						</td>
					    <td class="inquire_item6">&nbsp;</td>
					    <td class="inquire_form6" id="item0_5">&nbsp;</td>
					  </tr>
					    
					</table>
				</div>
				</form>
			</div>
		  </div>

</body>
<script type="text/javascript">

var audit_status1 = new Array(
		['0','未提交'],['1','待审批'],['2',''],['3','审批通过'],['4','审批不通过']
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

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "OPCostSrv";
	cruConfig.queryOp = "queryProjectHealthInfo";
	var orgSubjectionId = "<%=orgSubjectionId %>";
	// 复杂查询
	function refreshData(q_projectName, q_orgName, q_projectStatus, q_auditStatus, q_projectType, q_orgSubjectionId){

		document.getElementById("projectName").value = q_projectName;
		cruConfig.submitStr = "projectStatus="+q_projectStatus+"&orgSubjectionId="+q_orgSubjectionId+"&projectName="+q_projectName+"&auditStatus="+q_auditStatus+"&projectType="+q_projectType+"&orgName="+q_orgName;
		queryData(1);
	}

	refreshData("", "", "", "", "",  "<%=orgSubjectionId%>");
	// 简单查询
	function simpleRefreshData(){
		var q_projectName = document.getElementById("projectName").value;
		refreshData(q_projectName, "", "", "", "", "", orgSubjectionId);
	}
	
	function loadDataDetail(id){
		//var ids = getSelIds('rdo_entity_id');
	    if(id==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
	    var idss = id.split(",");
	    var ids = idss[0];
	    var ids1 = idss[1];
	    
		var retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo="+ids);
		document.getElementById("project_info_no").value= retObj.map.project_info_no;
		document.getElementById("project_name").value= retObj.map.project_name;
		document.getElementById("project_id").value= retObj.map.project_id;
		document.getElementById("project_year").value= retObj.map.project_year;
		document.getElementById("start_year").value= retObj.map.project_year;
		document.getElementById("acquire_start_time").value= retObj.map.acquire_start_time;
		document.getElementById("acquire_end_time").value= retObj.map.acquire_end_time;
		document.getElementById("design_start_date").value= retObj.map.design_start_date;
		document.getElementById("design_end_date").value= retObj.map.design_end_date;
		document.getElementById("prctr_name").value= retObj.map.prctr_name;
		document.getElementById("prctr").value= retObj.map.prctr;
		document.getElementById("manage_org").value= retObj.map.manage_org;
		document.getElementById("manage_org_name").value= retObj.map.manage_org_name;
		document.getElementById("market_classify").value= retObj.map.market_classify;
		document.getElementById("market_classify_name").value= retObj.map.market_classify_name;
		document.getElementById("notes").value= retObj.map.notes;
		
		document.getElementById("org_id").value= retObj.dynamicMap.org_id;
		document.getElementById("org_name").value= retObj.dynamicMap.org_name;
		
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
		
	}
	
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	
	function toUpdateProject(){
		var form = document.getElementById("projectForm");
		form.action="<%=contextPath%>/pm/project/addProject.srq";
		
		if(document.getElementById("tab_box_content0").style.display==""||document.getElementById("tab_box_content0").style.display=="block"){
			if(!checkText0()){
				return;
			}
		}
		if(document.getElementById("tab_box_content1").style.display==""||document.getElementById("tab_box_content1").style.display=="block"){
			if(!checkText1()){
				return;
			}
		}/*
		if(document.getElementById("tab_box_content2").style.display==""||document.getElementById("tab_box_content2").style.display=="block"){
			if(checkText2()){
				return;
			}
		}
		*/
		form.submit();
		simpleRefreshData();
	}
	
	function toUpdateWorkarea(){
		if(!checkWorkarea()) return;
		var form = document.getElementById("workareaForm");
		form.action="<%=contextPath%>/gpe/saveOrUpdateWorkarea.srq";
		
		form.submit();
		simpleRefreshData();
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
	
	function checkWorkarea() {
	 	
        if (!isTextPropertyNotNull("workarea", "工区名称")) {
			return false;	
		}
        if (!isLimitB100("workarea", "工区名称")) {
			return false;	
		}
        if (!isLimitB100("basin", "盆地")) {
			return false;	
		}
		if (!isTextPropertyNotNull("block", "施工地区")) {
			return false;	
		}
        if (!isLimitB32("block", "施工地区")) {
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
    	if (!isTextPropertyNotNull("acquire_start_time", "计划采集开始时间")) return false;
        if (!isTextPropertyNotNull("acquire_end_time", "计划采集结束时间")) return false;
        if (!checkStartEndDate("acquire_start_time", "acquire_end_time", "计划采集开始时间", "计划采集结束时间")) return false;
        if (!isTextPropertyNotNull("design_start_date", "合同开始时间")) return false;
        if (!isTextPropertyNotNull("design_end_date", "合同结束时间")) return false;
        if (!checkStartEndDate("design_start_date", "design_end_date", "合同开始时间", "合同结束时间")) return false;    

		return true;
	}
	
	function checkText1() {
		if(document.getElementById("tr1_9").style.display==""||document.getElementById("tr1_9").style.display=="block"){
			//三维
			if (!isTextPropertyNotNull("design_line_num","设计线束数")) return false;
			if (!isValidFloatProperty20_0("design_line_num","设计线束数")) return false;
			if (!isTextPropertyNotNull("design_object_workload","设计偏前满覆盖工作量")) return false;
			if (!isValidFloatProperty8_3("design_object_workload","设计偏前满覆盖工作量")) return false;
			if (!isTextPropertyNotNull("full_fold_workload","设计试验炮数")) return false;
			if (!isValidFloatProperty7_0("full_fold_workload","设计试验炮数")) return false;
			if (!isTextPropertyNotNull("design_geophone_num","设计检波点数")) return false;
			if (!isValidFloatProperty20_0("design_geophone_num","设计检波点数")) return false;
			if (!isTextPropertyNotNull("design_sp_num","设计炮数")) return false;
			if (!isValidFloatProperty12_0("design_sp_num","设计炮数")) return false;
			if (!isTextPropertyNotNull("design_small_regraction_num","小折射设计点数")) return false;
			if (!isValidFloatProperty10_0("design_small_regraction_num","小折射设计点数")) return false;
			if (!isTextPropertyNotNull("design_micro_measue_num","微测井设计点数")) return false;
			if (!isValidFloatProperty10_0("design_micro_measue_num","微测井设计点数")) return false;
			if (!isTextPropertyNotNull("design_drill_num","设计钻井点数")) return false;
			if (!isValidFloatProperty12_0("design_drill_num","设计钻井点数")) return false;
			if (!isTextPropertyNotNull("aa","设计施工面积")) return false;
			if (!isValidFloatProperty8_3("aa","设计施工面积")) return false;
			if (!isTextPropertyNotNull("bb","设计有资料面积")) return false;
			if (!isValidFloatProperty8_3("bb","设计有资料面积")) return false;
			if (!isTextPropertyNotNull("cc","设计激发点面积")) return false;
			if (!isValidFloatProperty8_3("cc","设计激发点面积")) return false;
		} else {
			//二维
			if (!isTextPropertyNotNull("design_line_num","设计测线数")) return false;
			if (!isValidFloatProperty20_0("design_line_num","设计测线数")) return false;
			if (!isTextPropertyNotNull("design_object_workload","设计满覆盖工作量")) return false;
			if (!isValidFloatProperty8_3("design_object_workload","设计满覆盖工作量")) return false;
			if (!isTextPropertyNotNull("full_fold_workload","设计试验炮数")) return false;
			if (!isValidFloatProperty7_0("full_fold_workload","设计试验炮数")) return false;
			if (!isTextPropertyNotNull("design_geophone_num","设计检波点数")) return false;
			if (!isValidFloatProperty20_0("design_geophone_num","设计检波点数")) return false;
			if (!isTextPropertyNotNull("design_sp_num","设计炮数")) return false;
			if (!isValidFloatProperty12_0("design_sp_num","设计炮数")) return false;
			if (!isTextPropertyNotNull("design_small_regraction_num","小折射设计点数")) return false;
			if (!isValidFloatProperty10_0("design_small_regraction_num","小折射设计点数")) return false;
			if (!isTextPropertyNotNull("design_micro_measue_num","微测井设计点数")) return false;
			if (!isValidFloatProperty10_0("design_micro_measue_num","微测井设计点数")) return false;
			if (!isTextPropertyNotNull("design_drill_num","设计钻井点数")) return false;
			if (!isValidFloatProperty12_0("design_drill_num","设计钻井点数")) return false;
			
		}

		return true;
	}
	
	function toUpdateQuality(){
		var form = document.getElementById("qualityForm");
		form.action="<%=contextPath%>/pm/project/saveQuality.srq";
		
		if(!checkQuality()){
			return;
		}
		form.submit();
		simpleRefreshData();
	}
	
	function checkQuality() {
	 	
		if (!isValidFloatProperty8_3("firstlevel_radio", "一级品率")) return false;
		if (!isValidFloatProperty8_3("qualified_radio", "合格品率")) return false;
		if (!isValidFloatProperty8_3("waster_radio", "废品率")) return false;
		if(document.getElementById("tr1_9").style.display==""||document.getElementById("tr1_9").style.display=="block"){
			if (!isValidFloatProperty8_3("miss_radio", "单束线空炮率")) return false;
		} else {
			if (!isValidFloatProperty8_3("miss_radio", "单线空炮率")) return false;
		}
		if (!isValidFloatProperty8_3("all_miss_radio", "全工区空炮率")) return false;
		if (!isValidFloatProperty8_3("surface_radio", "表层调查合格率")) return false;
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
			queryData(cruConfig.currentPage);
		}
	}
	
	function dbclickRow(ids){
		popWindow('<%=contextPath%>/pm/projectHealthInfo/detail.jsp?healthInfoId='+ids,'1280:800');
	}

	function toSearch(){
		popWindow('<%=contextPath%>/pm/projectHealthInfo/search.jsp?orgSubjectionId=<%=orgSubjectionId%>&orgId=<%=orgId %>');
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
	
</script>

</html>

