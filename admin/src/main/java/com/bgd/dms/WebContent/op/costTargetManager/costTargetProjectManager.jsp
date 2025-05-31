<%@page import="java.net.URLDecoder"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@ taglib uri="code" prefix="code"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	String projectId = request.getParameter("projectInfoNo");
	String project_name = request.getParameter("projectName");
	String project_type = request.getParameter("projectType");
	UserToken user = OMSMVCUtil.getUserToken(request);
	if(projectId==null||"".equals(projectId)){
		projectId= user.getProjectInfoNo();
		project_name = user.getProjectName();
		project_type = user.getProjectType();
	}
	project_name = URLDecoder.decode(project_name,"UTF-8"); 
	
	if(project_type!=null && project_type.trim().equals("5000100004000000002")){
		project_type = "5000100004000000010";
	}
	String org_id = user.getOrgId();
	String org_subjection_id = user.getSubOrgIDofAffordOrg();
	String user_id = user.getUserId();
	String targetBasicId=OPCommonUtil.getTargetProjectBasicId(projectId);
	Map map = new HashMap();
	map.put("org_id",org_id);
	map.put("org_subjection_id",org_subjection_id);
	map.put("user_id",user_id);
	map.put("tartget_basic_id",targetBasicId);
	String proc_status = OPCommonUtil.getPermit(projectId,map,"");
	boolean status = OPCommonUtil.getProcessStatus("BGP_OP_TARGET_PROJECT_BASIC","tartget_basic_id","5110000004100000009",projectId);
	String exploration_method = OPCommonUtil.getExplorationMethod(projectId);
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	String now = df.format(new Date());
	String is_single = request.getParameter("is_single");//is_single表示是不是单项目
	String spare5 = "1";
	if(project_type !=null && project_type.trim().equals("5000100004000000009")){//综合物化探的单项目需要屏蔽操作的按钮
		spare5= "2";
		if(is_single!=null && is_single.trim().equals("true")){
			status = false;
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css"></link>
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>
<title>项目目标费用管理</title>
<style type="text/css">
.x-tree-icon-leaf {
	width: 16px;
	background-image:
		url('<%=contextPath%>/images/images/tree_10.png')
}

.x-tree-icon-parent {
	width: 16px;
	background-image:
		url('<%=contextPath%>/images/images/tree_10.png')
}

.x-grid-tree-node-expanded .x-tree-icon-parent {
	background-image:
		url('<%=contextPath%>/images/images/tree_10.png')
}

</style>
<script type="text/javascript" language="javascript">

cruConfig.contextPath='<%=contextPath%>';

var costType="";

var targetBasicId="<%=targetBasicId%>";

var project_type ="<%=project_type%>";

//流程提交前配置流程关键信息
function configProecessInfo(){
	processNecessaryInfo={
			businessTableName:"BGP_OP_TARGET_PROJECT_BASIC",
			businessType:"5110000004100000009",
			businessId:targetBasicId,
			businessInfo:"<%=project_name %>发起项目目标成本预算审批",
			applicantDate:"<%=now %>"
	};
	processAppendInfo={
			projectInfoNo:'<%=projectId%>',
			projectName:'<%=project_name %>',
			projectType:'<%=project_type%>',
			targetId:targetBasicId
	};
}
loadProcessHistoryInfo();
function initPage(){
	debugger;
	var proc_status = '<%=proc_status%>';
	if(proc_status!='3'){
		alert('审批未通过，不允许查看!');
		return;
	}
	//获取当前项目的费用管理信息
	var submitStr="projectInfoNo="+'<%=projectId%>';
	var retObject=jcdpCallService('OPCostSrv','getProjectCostTargetType',submitStr);
	costType=retObject.costType;
	
	configProecessInfo();
	loadProcessHistoryInfo();
	//refreshTargetBasicInfo();
	var exploration_method = '<%=exploration_method%>';
	if(exploration_method==null || exploration_method==''){
		alert("该项目既不是二维也不是三维!");
	}else if(exploration_method!=null && exploration_method=='0300100012000000002'){
		document.getElementById("second1").style.display = 'none';
		document.getElementById("second2").style.display = 'none';
		document.getElementById("second3").style.display = 'none';
	}else if(exploration_method!=null && exploration_method=='0300100012000000003'){
		document.getElementById("second1").style.display = 'block';
		document.getElementById("second2").style.display = 'block';
		document.getElementById("second3").style.display = 'block';
	}
	
}

</script>
</head>
<body style="background:#fff;height: 600px;" onload="initPage()">
	<%if(proc_status.equals("3")){ %>
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					    <td>&nbsp;</td>
					    <%if(status){ %>
					    <auth:ListButton functionId="OP_TARGET_PLAN_EDIT,OP_TARGET_EDIT" css="qr" event="onclick='toImportFromTemplate()'" title="JCDP_btn_refresh"></auth:ListButton>
					    	<%if(project_type!=null && !project_type.trim().equals("5000100004000000009")){ %>
					    		<auth:ListButton functionId="OP_TARGET_PLAN_EDIT,OP_TARGET_EDIT" css="hz" event="onclick='toRefreshPlanData()'" title="JCDP_btn_summary"></auth:ListButton>
					    		<auth:ListButton functionId="OP_TARGET_PLAN_EDIT,OP_TARGET_EDIT" css="tj" event="onclick='toVersionData()'" title="JCDP_btn_version"></auth:ListButton>
					    		<auth:ListButton functionId="OP_TARGET_PLAN_EDIT,OP_TARGET_EDIT" css="xz" event="onclick='toImportFormulaFromProject()'" title="JCDP_btn_formula"></auth:ListButton>
					    	<%}else{ %>
					    		<auth:ListButton functionId="OP_TARGET_PLAN_EDIT,OP_TARGET_EDIT" css="dc" event="onclick='toExportExcel()'" title="JCDP_btn_export"></auth:ListButton>
					    		<auth:ListButton functionId="OP_TARGET_PLAN_EDIT,OP_TARGET_EDIT" css="dr" event="onclick='toImportFromExcel()'" title="JCDP_btn_import"></auth:ListButton>
					    	<%} %>
					    
					    <%} %>
					    <auth:ListButton functionId="OP_TARGET_PLAN_EDIT,OP_TARGET_EDIT" css="xq" event="onclick='showProjectInformation()'" title="项目基本情况"></auth:ListButton>
					  </tr>
					</table>
				</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
		</div>
		<div id="table_box" style="overflow: hidden;">
			<div id="menuTree" style="width:100%;height:auto;overflow:auto;z-index: 0;"></div>
		</div>
		<div id="fenye_box" style="height: 0px"></div>
		<div class="lashen" id="line"></div>
		<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">费用金额</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">公式维护</a></li>
			    <!-- <li id="tag3_2"><a href="#" onclick="getTab3(2)">项目基本信息</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">技术指标</a></li> -->
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">之前版本</a></li>
			    <li id="tag3_5"><a href="#" onclick="getTab3(5)">流程</a></li>
			    <li id="tag3_6"><a href="#" onclick="getTab3(6)">附件</a></li>
			  </ul>
		</div>
		<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<div id="inq_tool_box">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="6"><img src="<%=contextPath%>/images/list_13.png"width="6" height="36" /></td>
								<td background="<%=contextPath%>/images/list_15.png">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr align="right">
											<td>&nbsp;</td>
											<%if(status){ %>
											<auth:ListButton css="bc" event="onclick='saveCostMondyDetail()'" title="JCDP_save"></auth:ListButton>
											<auth:ListButton css="sc" event="onclick='deleteCostMondyDetail()'" title="JCDP_btn_delete"></auth:ListButton>
											<%} %>
										</tr>
									</table></td>
								<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
							</tr>
						</table>
					</div>
					<table width="100%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr>
							<td class="inquire_item4">费用金额：</td>
							<td class="inquire_form4">
							<input name="cost_detail_money" id="cost_detail_money" class="input_width" value="" type="text"  />
							<input name="target_project_detail_id" id="target_project_detail_id" class="input_width" value="" type="hidden" />
							<span class='jd'><a href='#' onclick='getTheMoney()'  title='计算'></a></span>
							</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td class="inquire_item4">描述依据：</td>
							<td class="inquire_form4">
							<textarea  name="cost_detail_desc" id="cost_detail_desc" value=""   class="textarea" ></textarea>
							</td>
							<td class="inquire_item4" >备注：</td>
							<td class="inquire_form4">
							<textarea  name="spare3" id="spare3" value=""   class="textarea" ></textarea>
							</td>
						</tr>
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content"  style="display:none;">
					<div id="inq_tool_box">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="6"><img src="<%=contextPath%>/images/list_13.png"width="6" height="36" /></td>
								<td background="<%=contextPath%>/images/list_15.png">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr align="right">
											<td>&nbsp;</td>
											<%if(status){ %>
											<auth:ListButton css="bc" event="onclick='saveCostFormula()'" title="JCDP_save"></auth:ListButton>
											<auth:ListButton css="sc" event="onclick='deleteCostFormula()'" title="JCDP_btn_delete"></auth:ListButton>
											<%} %>
										</tr>
									</table></td>
								<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
							</tr>
						</table>
					</div>
					<table width="100%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr>
							<td class="inquire_item4">维护类型：</td>
							<td class="inquire_form4">
							<code:codeSelect   name='formula_type' option="opFormulaType" selectedValue=""  addAll="true"/> 
							<input name="gp_target_project_id" id="gp_target_project_id" class="input_width" value="" type="hidden" />
							</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td class="inquire_item4">公式内容：</td>
							<td class="inquire_form4">
							<textarea  name="formula_content" id="formula_content" value=""   class="textarea" ></textarea>
							<span class='jl' style="float: right "><a href='#' onclick='toOpenFormulaTree("formula_content")'  title='打开公式树'></a></span>
							</td>
							<td class="inquire_item4">实际公式内容(若与计划公式相同可不填写)：</td>
							<td class="inquire_form4">
							<textarea  name="formula_content_a" id="formula_content_a" value=""   class="textarea" ></textarea>
							<span class='jl' style="float: right "><a href='#' onclick='toOpenFormulaTree("formula_content_a")'  title='打开公式树'></a></span>
							</td>
						</tr>
					</table>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
					<div id="inq_tool_box">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="6"><img src="<%=contextPath%>/images/list_13.png"width="6" height="36" /></td>
								<td background="<%=contextPath%>/images/list_15.png">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr align="right">
											<td>&nbsp;</td>
											<%if(status){ %>
											<auth:ListButton css="bc" event="onclick='saveTargetBasicInfo()'" title="JCDP_save"></auth:ListButton>
											<%} %>
										</tr>
									</table></td>
								<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
							</tr>
						</table>
					</div>
					<table width="100%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr>
							<td class="inquire_item4">工作量：</td>
							<td class="inquire_form4">
							<input name="tartget_basic_id" id="tartget_basic_id" class="input_width" value="<%=targetBasicId%>"   type="hidden"/>
							<textarea  name="work_load" id="work_load" value=""   class="textarea" ></textarea>
							</td>
							<td class="inquire_item4">地表条件：</td>
							<td class="inquire_form4">
							<textarea  name="work_situation" id="work_situation" class="textarea" ></textarea>
							</td>
						</tr>
						<tr>
							<td class="inquire_item4">施工因素：</td>
							<td class="inquire_form4">
							<textarea  name="work_factor" id="work_factor" value=""   class="textarea" ></textarea>
							</td>
							<td class="inquire_item4">影响施工效率的主要因素：</td>
							<td class="inquire_form4">
							<textarea  name="work_reason" id="work_reason" value=""   class="textarea" ></textarea>
							</td>
						</tr>
						<tr>
							<td class="inquire_item4">用工人数及工期：</td>
							<td class="inquire_form4">
							<textarea  name="work_person" id="work_person" value=""   class="textarea" ></textarea>
							</td>
							<td class="inquire_item4">设备投入情况：</td>
							<td class="inquire_form4">
							<textarea  name="work_device" id="work_device" value=""   class="textarea" ></textarea>
							</td>
						</tr>
					</table>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
					<div id="inq_tool_box">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="6"><img src="<%=contextPath%>/images/list_13.png"width="6" height="36" /></td>
								<td background="<%=contextPath%>/images/list_15.png">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr align="right">
											<td>&nbsp;</td>
											<%if(status){ %>
											<auth:ListButton css="bc" event="onclick='saveTargetIndicatorInfo()'" title="JCDP_save"></auth:ListButton>
											<auth:ListButton css="dr" event="onclick='importTargetIndicatorInfo()'" title="JCDP_btn_import"></auth:ListButton>
											<%} %>
										</tr>
									</table></td>
								<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
							</tr>
						</table>
					</div>
					<input name="target_indicator_id" id="target_indicator_id" class="input_width" value="" type="hidden" />
					<input name="spare5" id="spare5" value="" class="input_width" type="hidden" />
					<input name="tech_020" id="tech_020" value="" class="input_width" type="hidden" />
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr>
							<td class="inquire_item8">观测系统类型：</td>
							<td class="inquire_form8"> <input name="tech_001" id="tech_001" class="input_width" value="" type="text"  /></td>
							<td class="inquire_item8">设计线束：</td>
							<td class="inquire_form8"> <input name="tech_002" id="tech_002" value="" class="input_width" type="text"  /> </td>
							<td class="inquire_item8"><font color="red">*</font>满覆盖工作量<input type="radio" name="workload" id="workload1" value="1" checked="checked"/></td>
							<td class="inquire_form8"> <input name="tech_005" id="tech_005" value="" class="input_width" type="text"  /> </td>
							<td class="inquire_item8"><font color="red">*</font>实物工作量<input type="radio" name="workload" id="workload2" value="2"/></td>
							<td class="inquire_form8"> <input name="tech_006" id="tech_006" value="" class="input_width" type="text"  /> </td>
						</tr>
						<tr>
							<td class="inquire_item8">井炮生产炮数：</td>
							<td class="inquire_form8"> <input name="tech_022" id="tech_022" value="" class="input_width" type="text" onkeydown="javascript:return checkIfNum(event);"/> </td>
							<td class="inquire_item8">震源生产炮数：</td>
							<td class="inquire_form8"> <input name="tech_021" id="tech_021" value="" class="input_width" type="text" onkeydown="javascript:return checkIfNum(event);"/> </td>
							<td class="inquire_item8">气枪生产炮数：</td>
							<td class="inquire_form8"> <input name="tech_023" id="tech_023" class="input_width" value="" type="text" onkeydown="javascript:return checkIfNum(event);"/> </td>
							<td class="inquire_item8"><font color="red">*</font>总生产炮数：</td>
							<td class="inquire_form8"> <input name="tech_004" id="tech_004" class="input_width" value="" type="text" disabled="disabled"/> </td>
						</tr>
						<tr>
							<td class="inquire_item8">微测井：</td>
							<td class="inquire_form8"> <input name="tech_018" id="tech_018" class="input_width" value="" type="text"  /> </td>
							<td class="inquire_item8">小折射：</td>
							<td class="inquire_form8"> <input name="tech_003" id="tech_003" value="" class="input_width" type="text"  /> </td>
							<td class="inquire_item8"><font color="red">*</font>接收道数：</td>
							<td class="inquire_form8"> <input name="tech_008" id="tech_008" value="" class="input_width" type="text"  onkeydown="javascript:return checkIfNum(event);"/> </td>
							<td class="inquire_item8"><font color="red">*</font>检波器串数：</td>
							<td class="inquire_form8"> <input name="tech_019" id="tech_019" value="" class="input_width" type="text"  onkeydown="javascript:return checkIfNum(event);"/> </td>
						</tr>
						<tr>
							<td class="inquire_item8">覆盖次数：</td>
							<td class="inquire_form8"> <input name="tech_007" id="tech_007" class="input_width" value="" type="text"  /> </td>
							<td class="inquire_item8">道间距：</td>
							<td class="inquire_form8"> <input name="tech_009" id="tech_009" value="" class="input_width" type="text"  /> </td>
							<td class="inquire_item8">炮点距：</td>
							<td class="inquire_form8"> <input name="tech_010" id="tech_010" value="" class="input_width" type="text"  /> </td>
							<td class="inquire_item8" id="second1">接收线距：</td>
							<td class="inquire_form8" id="second2"> <input name="tech_011" id="tech_011" value="" class="input_width" type="text"  /> </td>
						</tr>
						<tr id="second3">
							<td class="inquire_item8">炮线距：</td>
							<td class="inquire_form8"> <input name="tech_012" id="tech_012" class="input_width" value="" type="text"  /> </td>
							<td class="inquire_item8">单线道数：</td>
							<td class="inquire_form8"> <input name="tech_013" id="tech_013" class="input_width" value="" type="text"  /> </td>
							<td class="inquire_item8">滚动接收线数：</td>
							<td class="inquire_form8"> <input name="tech_014" id="tech_014" value="" class="input_width" type="text"  /> </td>
							<td class="inquire_item8">面元：</td>
							<td class="inquire_form8"> <input name="tech_015" id="tech_015" value="" class="input_width" type="text"  /> </td>
						</tr>
					</table>
				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
					<div id="inq_tool_box">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="6"><img src="<%=contextPath%>/images/list_13.png"width="6" height="36" /></td>
								<td background="<%=contextPath%>/images/list_15.png">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr align="right">
											<td>&nbsp;</td>
											<%if(status){ %>
											<auth:ListButton css="sc" event="onclick='deleteVersion()'" title="JCDP_btn_delete"></auth:ListButton>
											<%} %>
										</tr>
									</table></td>
								<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
							</tr>
						</table>
					</div>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="editionList">		
			     		<tr>
					      <td class="bt_info_odd"></td>
					      <td class="bt_info_even">版本</td>
					      <td class="bt_info_odd">产生时间</td>	
					      <td class="bt_info_even">内容 </td>	
			    	    </tr> 			        
			  		</table>
				</div>
				<div id="tab_box_content5" class="tab_box_content" style="display:none;">
					<%if(is_single!=null && is_single.trim().equals("true") && project_type.trim().equals("5000100004000000009")){ %>
						<wf:startProcessInfo buttonFunctionId="true" />
					<%}else{ %>
						<wf:startProcessInfo />
					<%} %>
				</div>
				<div id="tab_box_content6" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="<%=contextPath%>/doc/common/common_doc_list.jsp?relationId=<%=targetBasicId %>" marginheight="0" marginwidth="0" >
					</iframe>
				</div>
		</div>
	</div>
	<%} %>
</body>
<script type="text/javascript">
function frameSize(){
	if(lashened==0){
		if($(window).height()==0){
			$("#table_box").css("height",450*0.46);
		}else{
			$("#table_box").css("height",$(window).height()*0.46);
		}
	}
	$("#tab_box .tab_box_content").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height()-10);
	$("#tab_box .tab_box_content").each(function(){
		if($(this).children('iframe').length > 0){
			$(this).css('overflow-y','hidden');
		}
	});
}
frameSize();
$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	
$(document).ready(lashen);
var schemaInfoOfSet = {
	tech_001:'',
	tech_002:'',
	
	spare5:'',
	tech_005:'',
	tech_006:'',
	tech_020:'',
	
	tech_022:'',
	tech_021:'',
	tech_023:'',
	tech_004:'',
	
	tech_018:'',
	tech_003:'',
	tech_008:'',
	tech_019:'',
	
	tech_007:'',
	tech_009:'',
	tech_010:'',
	
	tech_011:'',
	tech_012:'',
	tech_013:'',
	tech_014:'',
	tech_015:''
};

var schDetDataOfSet={
			work_load:'',
			work_situation:'',
			work_factor:'',
			work_reason:'',
			work_device:'',
			work_person:''
};
var costDetailDataOfSet={
		cost_detail_money:'',
		cost_detail_desc:'',
		spare3:''
}
	
function toAdd(){
	if(selectParentIdData==null||selectParentIdData==""){
		selectParentIdData=costType;
	}
	popWindow(cruConfig.contextPath+"/op/costTargetManager/costTargetManagerEdit.upmd?pagerAction=edit2Add&parentId="+selectParentIdData+"&costType="+costType+"&projectInfoNo=<%=projectId%>");
}
function toModify(){
	if(selectParentIdData==null||selectParentIdData==""){
		selectParentIdData=costType;
	}else{
		popWindow(cruConfig.contextPath+"/op/costTargetManager/costTargetManagerEdit.upmd?pagerAction=edit2Edit&parentId="+selectUpIdData+"&id="+selectParentIdData+"&costType="+costType+"&projectInfoNo=<%=projectId%>");
	}
}
function toDelete(){
	if(selectUpIdData=='root'){
		alert("模板类型节点不允许在此删除");
	}else{
		var sql="delete from  bgp_op_target_project_info where gp_target_project_id in (select gp_target_project_id from bgp_op_target_project_info "+
				" start with parent_id = '"+selectParentIdData+"'  connect by prior gp_target_project_id = parent_id   union  select '"+selectParentIdData+"' from dual)";
		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids=";
		var retObject = syncRequest('Post',path,params);
		if(retObject.returnCode!=0) alert(retObject.returnMsg);
		refreshTree();
	}
}

function refreshTree(){
	Ext.getCmp('gridId').getStore().load();
}

function toImportFromTemplate(){
	if(confirm("将导入最新的费用科目模板，若当前已维护了费用科目，则将会被覆盖，确定导入请点击确定，否则点击取消")){
		var project_type = '<%=project_type%>';
		var spare5 = "1";
		if(project_type=='5000100004000000009'){
			spare5 = "2";
		}
		var submitStr="projectInfoNo="+'<%=projectId%>'+"&costType=01&project_type=<%=project_type%>&spare5="+spare5;
		var retObject=jcdpCallService('OPCostSrv','saveProjectCostTargetByTemplate',submitStr)
		refreshTreeStore();
	}
	
}

function refreshTreeStore(){
	initPage();
	Ext.getCmp('gridId').getStore().setProxy({
		type : 'ajax',
        method: 'get',
        url: '<%=contextPath%>/op/OpCostSrv/getCostTargetProject.srq?projectInfoNo=<%=projectId%>&costType='+costType+'&project_type=<%=project_type %>&spare5=<%=spare5 %>',
        reader: {
            type : 'json'
        }
        });
	Ext.getCmp('gridId').getStore().load();
	
}

function loadDataDetail(){
	
	//载入费用详细信息
	var querySql = "select * from bgp_op_target_project_detail where bsflag='0' and gp_target_project_id ='"+selectParentIdData+"' ";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	var datas = queryRet.datas;
	if(datas != null&&datas.length>0){
		setOneDataInfo(costDetailDataOfSet,datas[0],'target_project_detail_id');
	}else{
		setOneDataInfo(costDetailDataOfSet,null,'target_project_detail_id');
	}
	
	//载入公式信息
	var querySql = "select * from BGP_OP_TARGET_PROJECT_INFO where GP_TARGET_PROJECT_ID ='"+selectParentIdData+"'";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	var datas = queryRet.datas;
	if(datas != null&&datas.length>0){
		document.getElementById("gp_target_project_id").value=datas[0].gp_target_project_id;
		setSelectedValue("formula_type",datas[0].formula_type);
		document.getElementById("formula_content").value=datas[0].formula_content;
		document.getElementById("formula_content_a").value=datas[0].formula_content_a;
		if(datas[0].formula_content!=null && datas[0].formula_content==''){
			var sql = "select * from (select p.project_name ,t.project_info_no ,t.formula_content ,t.gp_target_project_id ,t.formula_type ,t.formula_content_a "+
			" from bgp_op_target_project_info t "+
			" join gp_task_project p on t.project_info_no = p.project_info_no where p.bsflag ='0' and t.formula_content is not null "+
			" and t.template_id =(select i.template_id from BGP_OP_TARGET_PROJECT_INFO i where i.gp_target_project_id ='"+selectParentIdData+"')"+ 
			" group by p.project_name ,t.project_info_no ,t.formula_content ,t.gp_target_project_id ,t.formula_type ,t.formula_content_a)d where rownum =1";
			var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql);
			if(retObj!=null && retObj.returnCode =='0' && retObj.datas!=null && retObj.datas.length>0){
				var data = retObj.datas[0];
				debugger;
				with(data){
					document.getElementById("formula_content").value=formula_content;
					if(datas[0].formula_content_a!=null && datas[0].formula_content_a==''){
						document.getElementById("formula_content_a").value=formula_content_a;
					}
				}
			}
		}
		
	}else{
		document.getElementById("gp_target_project_id").value='';
		setSelectedValue("formula_type",'');
		document.getElementById("formula_content").value='';
		document.getElementById("formula_content_a").value='';
	}
	
}
function toEditCost(){
	if(selectLeafOrParent==false){
		alert("根节点无法维护起费用金额信息");
	}else if(selectParentIdData==null||selectParentIdData==""){
		alert("请先选择某费用科目");
	}else{
		var targetProjectDetailId=document.getElementById("target_project_detail_id").value;
		if(targetProjectDetailId==null||targetProjectDetailId==""){
			popWindow(cruConfig.contextPath+"/op/costTargetManager/costTargetProjectManagerEdit.upmd?pagerAction=edit2Add&gpTargetProjectId="+selectParentIdData);
		}else{
			popWindow(cruConfig.contextPath+"/op/costTargetManager/costTargetProjectManagerEdit.upmd?pagerAction=edit2Edit&gpTargetProjectId="+selectParentIdData+"&id="+targetProjectDetailId);
		}
	}
}
function saveCostMondyDetail(){
	if(selectLeafOrParent==false){
		alert("非根节点无法维护起费用金额信息");
	}else if(selectParentIdData==null||selectParentIdData==""){
		alert("请先选择某费用科目");
	}else{
		var gpTargetProjectId=selectParentIdData;
		saveSingleTableInfoByData(costDetailDataOfSet,'bgp_op_target_project_detail','target_project_detail_id','gp_target_project_id='+gpTargetProjectId);
		refreshTreeStore();
		loadDataDetail();
	}
}
function deleteCostMondyDetail(){
	if(selectLeafOrParent==false){
		alert("非根节点无法维护起费用金额信息");
	}else if(selectParentIdData==null||selectParentIdData==""){
		alert("请先选择某费用科目");
	}else{
		var id=document.getElementById("target_project_detail_id").value;
		if (!window.confirm("确认要删除吗?")) {
			return;
		}
		var sql = "update bgp_op_target_project_detail t set t.bsflag='1' where t.target_project_detail_id ='"+id+"'";
		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids="+id;
		syncRequest('Post',path,params);
		refreshTreeStore();
		loadDataDetail();
	}
}
function refreshTargetBasicInfo(){
	//载入项目基本信息
	var querySql = "select * from bgp_op_target_project_basic where bsflag='0' and  tartget_basic_id ='"+targetBasicId+"' ";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	var datas = queryRet.datas;
	if(datas != null&&datas.length>0){
		setOneDataInfo(schDetDataOfSet,datas[0]);
	}
	//载入技术指标信息
	var querySql="select * from bgp_op_target_project_indicato where bsflag='0' and tartget_basic_id='"+targetBasicId+"'";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	var datas = queryRet.datas;
	if(datas != null&&datas.length>0){
		setOneDataInfo(schemaInfoOfSet,datas[0],'target_indicator_id');
	}
	var spare5 = document.getElementById("spare5").value;
	if(spare5==2 || spare5 =='2'){
		document.getElementById("workload2").checked = true;
	}
	refreshTargetVersionInfo();
}

function refreshTargetVersionInfo(){
	//载入旧有版本信息
	var querySql = "select distinct t.gather_version,t.create_date from bgp_op_target_gather_info t where t.project_info_no = '<%=projectId%>'";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
	var datas = queryRet.datas;
	deleteTableTr("editionList");
	if(datas != null){
		rowsCount=datas.length;
		for (var i = 0; i< queryRet.datas.length; i++) {
			var tr = document.getElementById("editionList").insertRow();		
             	if(i % 2 == 1){  
             		tr.className = "even";
			}else{ 
				tr.className = "odd";
			}
            var td = tr.insertCell();
   			td.innerHTML = "<input type='checkbox' name='version_chk' value='"+datas[i].gather_version+"' />";
   			
			var td = tr.insertCell();
			td.innerHTML = datas[i].gather_version;
			
			var td = tr.insertCell();
			td.innerHTML = datas[i].create_date;
			
			var td = tr.insertCell();
			td.innerHTML = "<a onclick=openTargetDetailWin('"+datas[i].gather_version+"')>查看</a>";
			
		}
	}
}
function saveTargetBasicInfo(){
	saveSingleTableInfoByData(schDetDataOfSet,'bgp_op_target_project_basic','tartget_basic_id');
}
function saveTargetIndicatorInfo(){
	var tech_008 = document.getElementById('tech_008').value;
	if(tech_008 ==null || tech_008==''){
		alert("接收道数不能空!");
		return;
	}
	var tech_019 = document.getElementById('tech_019').value;
	if(tech_019 ==null || tech_019==''){
		alert("检波器串数不能空!");
		return;
	}
	var tech_021 = document.getElementById('tech_021').value;
	if(tech_021==null ||tech_021==''){
		tech_021 = 0;
	}
	var tech_022 = document.getElementById('tech_022').value;
	if(tech_022==null ||tech_022==''){
		tech_022 = 0;
	}
	var tech_023 = document.getElementById('tech_023').value;
	if(tech_023==null ||tech_023==''){
		tech_023 = 0;
	}
	var tech_004 = document.getElementById('tech_004').value;
	if(tech_004==null ||tech_004==''){
		tech_004 = 0;
	}
	if(tech_004!=(tech_021-(-tech_022)-(-tech_023))){
		alert("炮数不等于震源生产数量、井炮生产数量、气枪生产数量之和，请确认!")
		return;
	}
	document.getElementById("spare5").value = 1;
	document.getElementById("tech_020").value = document.getElementById("tech_005").value;
	var checked = document.getElementById("workload2").checked;
	if(checked=='true' || checked ==true){
		document.getElementById("spare5").value = 2;
		document.getElementById("tech_020").value = document.getElementById("tech_006").value;
	}
	var retObj = saveSingleTableInfoByData(schemaInfoOfSet,'bgp_op_target_project_indicato','target_indicator_id','tartget_basic_id='+targetBasicId);
	if(retObj!=null && retObj.returnCode=='0'){
		alert('保存成功!');
	}
}
function getSubmitStrByData(dataInfo){
	var returnStr="bsflag=0";
	for(var i in dataInfo){
		var tempValue=document.getElementById(i).value;
		if(1==1||isNotNull(tempValue)){
			tempValue=encodeURI(tempValue);
			tempValue=encodeURI(tempValue);
			returnStr+='&'+i+"="+tempValue;
		}
	}
	return returnStr;
}
function toExportTargetInfo(){
	popWindow(cruConfig.contextPath+"/op/costTargetManager/costTargetProjectInfo.jsp?targetBasicId="+targetBasicId);
}
function toRefreshPlanData(){
	var sql = "select s.planned_start_date,e.planned_finish_date "+
	" from (select nvl(min(t3.actual_start_date),min(t3.planned_start_date)) planned_start_date from  bgp_p6_project t1 "+
	" inner join bgp_p6_project_wbs t2 on t1.object_id=t2.project_object_id "+
	" left outer join bgp_p6_activity t3 on t2.object_id=t3.wbs_object_id "+
	" where t1.project_info_no = '<%=projectId%>' "+
	" start with t2.name ='工区踏勘' connect by prior  t2.object_id=t2.PARENT_OBJECT_ID )s"+
	" left join (select nvl(max(t3.actual_finish_date),max(t3.planned_finish_date)) planned_finish_date from  bgp_p6_project t1 "+
	" inner join bgp_p6_project_wbs t2 on t1.object_id=t2.project_object_id "+
	" left outer join bgp_p6_activity t3 on t2.object_id=t3.wbs_object_id "+
	" where t1.project_info_no = '<%=projectId%>' "+
	" start with t2.name ='资源遣散' connect by prior  t2.object_id=t2.PARENT_OBJECT_ID)e on 1=1";
	var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
	var planned_start_date = "";
	var planned_finish_date = "";
	if(retObj==null || retObj.returnCode !='0'){
		alert("工区踏勘、资源遣散工序的计划开始时间为空");
		return;
	}else{
		planned_start_date = retObj.datas[0].planned_start_date;
		planned_finish_date = retObj.datas[0].planned_finish_date;
	}
	if(planned_start_date==null || planned_start_date==''){
		alert("工区踏勘工序的计划开始时间为空");
		return;
	}
	if(planned_finish_date==null || planned_finish_date==''){
		alert("资源遣散工序的计划开始时间为空");
		return;
	}
	
	retObj = jcdpCallService("OPCostSrv", "hzCostPlanByFormula", "projectInfoNo=<%=projectId%>");
	if(retObj!=null && retObj.returnCode =='0'){
		alert("汇总成功!");
		refreshTreeStore();
	}else{
		alert("汇总失败!");
	}
	
}
function getTheMoney(){
	debugger;
	var cost_detail_desc = document.getElementById("cost_detail_desc").value;
	if(cost_detail_desc==null || cost_detail_desc==''){
		cost_detail_desc = 0;
		document.getElementById("cost_detail_money").value=0;
		return;
	}
	var value=convertCalcuFromDesc(cost_detail_desc);
	document.getElementById("cost_detail_money").value=value;
}


function saveCostFormula(){
	if(selectLeafOrParent==false){
		alert("非根节点无法维护公式信息");
	}else if(selectParentIdData==null||selectParentIdData==""){
		alert("请先选择某费用科目");
	}else{
		var gp_target_project_id=document.getElementById("gp_target_project_id").value;
		var formula_type=document.getElementById("formula_type").value;
		var formula_content=document.getElementById("formula_content").value;
		var formula_content_a=document.getElementById("formula_content_a").value;
		
		var myregexpLeft =  /(^"*)/g;
		var myregexpRight =  /("*$)/g;
		var subject=formula_content;
		var result = subject.replace(myregexpLeft, "");
		result = result.replace(myregexpRight, "");
		formula_content=result;
		 
		formula_content_a=formula_content_a.replace(myregexpLeft, "").replace(myregexpRight, "");
		
		formula_content=encodeURI(formula_content);
		formula_content=encodeURI(formula_content);
		
		formula_content_a=encodeURI(formula_content_a);
		formula_content_a=encodeURI(formula_content_a);
		
		var tableId=''
		if(gp_target_project_id!=null&&gp_target_project_id!=''){
			tableId='&JCDP_TABLE_ID='+gp_target_project_id;
		}
		var submitStr='JCDP_TABLE_NAME=BGP_OP_TARGET_PROJECT_INFO'+tableId+'&formula_type='+formula_type+'&formula_content='+formula_content+'&bsflag=0&formula_content_a='+formula_content_a;
		var path = cruConfig.contextPath+'/rad/addOrUpdateEntity.srq';
		if(submitStr == null) return;
		var retObject = syncRequest('Post',path,submitStr);
		if(retObject!=null && retObject.returnCode=='0'){
			alert("保存成功!")
		}
		loadDataDetail();
	}
}
function deleteCostFormula(){
	if(selectLeafOrParent==false){
		alert("非根节点无法维护公式信息");
	}else if(selectParentIdData==null||selectParentIdData==""){
		alert("请先选择某费用科目");
	}else{
		var id=document.getElementById("gp_target_project_id").value;
		if (!window.confirm("确认要删除吗?")) {
			return;
		}
		var sql = "update gp_target_project_id t set t.formula_type= null,t.formula_content = null where t.gp_target_project_id ='"+id+"'";
		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids="+id;
		syncRequest('Post',path,params);
		loadDataDetail();
		refreshTreeStore();
	}	
}
function deleteVersion(){
	var project_info_no = '<%=projectId%>'
	var version = document.getElementsByName("version_chk");
	if(window.confirm("确认要删除吗?")){
		var sql = "";
		for(var i =0;i<version.length;i++ ){
			if(version[i].checked){
				var gather_version = version[i].value;
				 sql = sql +"delete from bgp_op_target_gather_info t where t.project_info_no ='"+project_info_no+"' and t.gather_version='"+gather_version+"';"
			}
		}
		var retObj = jcdpCallService('QualitySrv','saveQualityBySql','sql='+sql);
		if(retObj!=null && retObj.returnCode =='0'){
			alert('删除成功!');
			initPage();
		}
	}
	/* if(selectLeafOrParent==false){
		alert("非根节点无法维护公式信息");
	}else if(selectParentIdData==null||selectParentIdData==""){
		alert("请先选择某费用科目");
	}else{
		var id=document.getElementById("gp_target_project_id").value;
		if (!window.confirm("确认要删除吗?")) {
			return;
		}
		var sql = "update gp_target_project_id t set t.formula_type= null,t.formula_content = null where t.gp_target_project_id ='"+id+"'";
		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids="+id;
		syncRequest('Post',path,params);
		loadDataDetail();
		refreshTreeStore();
	} */
}

function setSelectedValue(id,value){
	var selectObj=document.getElementById(id);
	for(var i=0;i<selectObj.options.length;i++ ){
	  if(selectObj.options[i].value==value){
	 	 selectObj.options[i].selected=true;
	 	 return false;
	  }
	}
}

function  toOpenFormulaTree(a){
	 var returnValue=window.showModalDialog(cruConfig.contextPath+"/op/costFormulaManager/costFormulaSelect.jsp");
	appendCostFormula(returnValue,a);
}

function appendCostFormula(someStr,a){
	if(someStr!=null&&someStr!=''&&someStr!=undefined){
		var value=document.getElementById(a).value;
		document.getElementById(a).value=value+someStr;
	}
}

function toVersionData(){
	retObj = jcdpCallService("OPCostSrv", "toGenerateVersionData", "projectInfoNo=<%=projectId%>");
	alert("生成版本成功");
	refreshTargetVersionInfo();
	getTab3(4);
}

function importTargetIndicatorInfo(){
	retObj = jcdpCallService("OPCostSrv", "importTargetIndicatorInfo", "projectInfoNo=<%=projectId%>&targetBasicId="+targetBasicId);
	if(retObj!=null && retObj.returnCode=='0'){
		alert("保存成功!");
		//refreshTargetBasicInfo();
		var tech_001 = document.getElementById('tech_001').value;
		tech_001 = tech_001.replace(/L/g,'*');
		tech_001 = tech_001.replace(/S/g,'*');
		tech_001 = tech_001.replace(/R/g,'*');
		tech_001 = tech_001.replace(/P/g,'*');
		tech_001 = tech_001.replace(/T/g,'*');
		tech_001 = tech_001.replace(/\-/g,'*');
		tech_001 = tech_001.replace(/\(/g,'*');
		tech_001 = tech_001.replace(/\)/g,'*');
		tech_001 = tech_001.replace(/[^*\d]/g,'');
		var tech_013 = tech_001.split("*")[2];
		if(tech_013==null){
			tech_013 = "";
		}
		document.getElementById('tech_013').value = tech_013;
		var sql = "update bgp_op_target_project_indicato t set t.tech_013 = '"+tech_013+"' where t.tartget_basic_id ='"+targetBasicId+"'";
		jcdpCallService("QualitySrv", "saveQualityBySql", "sql="+sql);
	}
	
}

function  openTargetDetailWin(versionId){
		popWindow(cruConfig.contextPath+"/op/costTargetManager/costTargetVersionDetail.jsp?projectInfoNoo=<%=projectId%>&versionId="+versionId);
}
function toImportFormulaFromProject(){
	var obj=new Object();
	window.showModalDialog("<%=contextPath%>/op/costTargetManager/costTargetManagerChoose.jsp",obj,"dialogWidth=800px;dialogHeight=600px");
	document.getElementById("projectInfoNo").value=obj.value;
	retObj = jcdpCallService("OPCostSrv", "importFormulaFromProject", "projectInfoNo="+obj.value+"&projectId=<%=projectId%>");
	loadDataDetail();
}
function setTech008(){
	var tech_021 = document.getElementById("tech_021").value;
	var tech_022 = document.getElementById("tech_022").value;
	var tech_023 = document.getElementById("tech_023").value;
	if(tech_021==null || tech_021==''){
		tech_021 = 0;
	}
	if(tech_022==null || tech_022==''){
		tech_022 = 0;
	}
	if(tech_023==null || tech_023==''){
		tech_023 = 0;
	}
	document.getElementById("tech_004").value = tech_021 -(-tech_022)-(-tech_023);
}
/* 输入的是否是数字 */
function checkIfNum(event){
	var element = event.srcElement;
	if(element.value != null && element.value =='0' && (event.keyCode>=48 && event.keyCode<=57)){
		element.value = '';
	}
	if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8 || event.keyCode ==37 || event.keyCode ==39 || event.keyCode ==9){
		return true;
	}
	else{
		return false;
	}
}
function toExportExcel(){
	var project_info_no = '<%=projectId%>';
	var file_name = encodeURI(encodeURI("<%=project_name%>项目目标成本预算"))
	var key_id = "<%=project_type%>:<%=spare5%>";
	window.open("<%=contextPath%>/op/OPCostSrv/commExportExcel.srq?export_function=exportTargetCost&project_info_no="+project_info_no+"&file_name="+file_name+"&key_id="+key_id);
}
function toImportFromExcel(){
	popWindow(cruConfig.contextPath+"/op/mProject/ExcelImport.jsp?path=/op/OPCostSrv/mProjectImportExcel.srq&import_function=importTargetCost");<%-- &projectInfoNo=<%=projectId%>&project_type =<%=project_type%>&spare5=<%=spare5%> --%>
}
function refreshData(){
	Ext.getCmp('gridId').getStore().load();
	initPage();
}
function showProjectInformation(){//项目基本信息
	if(project_type !=null && project_type=='5000100004000000009'){
		<%-- popWindow(cruConfig.contextPath+"/op/mProject/project_information.jsp?tartget_basic_id=<%=targetBasicId%>&status=<%=status%>"); --%>
		window.open(cruConfig.contextPath+"/op/mProject/project_information.jsp?tartget_basic_id=<%=targetBasicId%>&status=<%=status%>");
	}else{
		<%-- popWindow(cruConfig.contextPath+"/op/costTargetManager/project_information.jsp?tartget_basic_id=<%=targetBasicId%>&status=<%=status%>"); --%>
		window.open(cruConfig.contextPath+"/op/costTargetManager/project_information.jsp?tartget_basic_id=<%=targetBasicId%>&status=<%=status%>");
	}
	
}

var selectParentIdData="";
var selectUpIdData="";
var selectLeafOrParent="";
var nodeGet=null;
cruConfig.contextPath = "<%=contextPath%>";
Ext.require([
             'Ext.data.*',
             'Ext.grid.*',
             'Ext.tree.*',
             'Ext.util.*'
]);
var rightMenu = null;
Ext.onReady(function() {
	var proc_status = '<%=proc_status%>';
	if(proc_status!='3'){
		return;
	}
    //we want to setup a model and store instead of using dataUrl
    Ext.define('Task', {
        extend: 'Ext.data.Model',
        fields: [
            {name : 'costName',type: 'string'},
            {name : 'costDesc', type : 'String'},
            {name : 'gpCostTempId', type : 'String'},
            {name : 'zip', type : 'String'},
            {name : 'orderCode', type : 'String'},
            {name : 'costDetailMoney', type : 'String'},
            {name : 'costDetailDesc', type : 'String'},
            {name : 'spare3', type : 'String'}
        ]
    });

    var store = Ext.create('Ext.data.TreeStore', {
    	autoLoad: false,
        model: 'Task',
        proxy: {
       	 type : 'ajax',
            method: 'get',
            url: '<%=contextPath%>/op/OpCostSrv/getCostTargetProject.srq?projectInfoNo=<%=projectId%>&costType='+costType+'&project_type=<%=project_type %>&spare5=<%=spare5 %>',
            reader: {
                type : 'json'
            }
        },
        folderSort: false
    });

    //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel
    var width = 800;
    var height = 600;
    if(document.body.clientWidth!=null && document.body.clientWidth!=0){
    	width = document.body.clientWidth;
        height = document.body.clientHeight;
    }
    if(project_type=='5000100004000000009'){
	    var grid = Ext.create('Ext.tree.Panel', {
	    	id:'gridId',
	    	width: (width-6),
	        height: (height*0.45-68),
	        lines: true,
	        renderTo: 'menuTree',
	        enableDD: true,
	        collapsible: false,
	        useArrows: false,
	        rootVisible: false,
	        store: store,
	        multiSelect: false,
	        singleExpand: false,
	        //the 'columns' property is now 'headers'
	        columns: [{
	            xtype: 'treecolumn', //this is so we know which column will show the tree
	            height: 22,
	            text: '费用名称',
	            hideable:false,
	            flex: 1,
	            sortable: true,
	            dataIndex: 'costName'
	        },{
	            //we must use the templateheader component so we can use a custom tpl
	            //xtype: 'templatecolumn',
	            text: '金额（元）',
	            height: 22,
	            flex: 1,
	            sortable: true,
	            dataIndex: 'costDetailMoney',
	            align: 'center'
	        },{
	            text: '计算依据',
	            height: 22,
	            flex: 1,
	            sortable: true,
	            dataIndex: 'costDetailDesc',
	            align: 'center'
	        },{
                text: '备注',
                height: 22,
                flex: 3,
                sortable: true,
                dataIndex: 'spare3',
                align: 'center'
            }]
	    });
    }else{
    	var grid = Ext.create('Ext.tree.Panel', {
	    	id:'gridId',
	        width: width-6,
	        height: (height*0.45-68),
	        lines: true,
	        renderTo: 'menuTree',
	        enableDD: true,
	        collapsible: false,
	        useArrows: false,
	        rootVisible: false,
	        store: store,
	        multiSelect: false,
	        singleExpand: false,
	        //the 'columns' property is now 'headers'
	        columns: [{
	            xtype: 'treecolumn', //this is so we know which column will show the tree
	            text: '费用名称',
	            hideable:false,
	            height: 22,
	            flex: 1,
	            sortable: true,
	            dataIndex: 'costName'
	        },{
	            text: '金额（元）',
	            height: 22,
	            flex: 1,
	            sortable: true,
	            dataIndex: 'costDetailMoney',
	            align: 'center'
	        },{
	            text: '计算依据',
	            height: 22,
	            flex: 1,
	            sortable: true,
	            dataIndex: 'costDetailDesc',
	            align: 'center'
	        }]
	    });
    }    
    grid.addListener('cellclick', cellclick);

    function cellclick(grid,colspan, colIndex, rowdata, rowspan,rowIndex,e) {
        selectParentIdData= rowdata.data.gpCostTempId;
        selectUpIdData= rowdata.data.zip;
        selectLeafOrParent=rowdata.data.leaf;
        loadDataDetail();
    }
    
    //grid.addListener('load', load);
    function load(treeStore,node,records,sucess){
    	ifFind=false;
    	getChildBySpecial(records);
    	if(nodeGet!=null&&nodeGet!=undefined){
    		grid.selectPath(nodeGet.getPath("gpCostTempId"),"gpCostTempId");
    	}
    }
    
    
    function getChildBySpecial(records){
    	for(var i=0;i<records.length;i++){
    		var data=records[i].data;
    		if(data.gpCostTempId==selectParentIdData){
    			nodeGet= records[i];	
    		}else{
    			getChildBySpecial(records[i].childNodes);
    		}
    	}
    }
});
</script>
</html>