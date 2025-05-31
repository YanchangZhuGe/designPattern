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
		  <%if(isSingle != "true" && !"true".equals(isSingle)){ %>
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
		    <%} %>
		    <td>&nbsp;</td>
		    <%if(isSingle != "true" && !"true".equals(isSingle)){ %>
		    <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_query"></auth:ListButton>
		    <%} %>
		    <%if(action.equals("edit")){ %>
		    <%if(isSingle != "true" && !"true".equals(isSingle)){ %>
		    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
		    <auth:ListButton functionId="F_PM_M_003" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
		    <auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
		    <%} %>
		    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
		    <%} %>
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
		      <td class="bt_info_odd" exp="{project_name}<input type='hidden' id='projectName{project_info_no}' value='{project_name}'/>" >项目名称</td>
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
		    <!-- <li id="tag3_7"><a href="#" onclick="getTab3(7)">地质任务</a></li> -->
		    <li id="tag3_2"><a href="#" onclick="getTab3(2)">质量指标</a></li>
		    <li id="tag3_10"><a href="#" onclick="getTab3(10)">审批流程</a></li>
		    <li id="tag3_11"><a href="#" onclick="getTab3(11)">部署图</a></li>
		    <li id="tag3_9"><a href="#" onclick="getTab3(9)">备注</a></li>
		  </ul>
		</div>
		
		<div id="tab_box" class="tab_box">
			<form name="projectForm" id="projectForm"  method="post" action="">
			<!-- 基本信息  -->
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
					    <input type="hidden" id="project_info_no" name="project_info_no" />
					    <input type="hidden" id="project_id" name="project_id" />
					    <input type="text" id="project_name" name="project_name" class="input_width" />
				    </td>
				    <td class="inquire_item6">项目类型：</td>
				    <td class="inquire_form6" id="item0_2">
				    	<code:codeSelect cssClass="select_width"  name='project_type' option="projectType"  selectedValue=""  addAll="true" />
				    </td>
				  </tr>
				  
				  <tr>
				    <td class="inquire_item6"><span class="red_star">*</span>市场范围：</td>
				    <td class="inquire_form6" id="item0_4">
				    	<input id="market_classify" name="market_classify" value="" type="hidden" class="input_width" />
						<input id="market_classify_name" name="market_classify_name" value="" type="text" class="input_width" readonly="readonly"/>
						&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectMarketClassify()" /></td>
				    </td>
				    <td class="inquire_item6"><span class="red_star">*</span>计划采集开始时间：</td>
				    <td class="inquire_form6" id="item0_3">
					    <input type="text" id="acquire_start_time" name="acquire_start_time" value="" class="input_width" readonly="readonly"/>
						&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acquire_start_time,tributton1);" />
					</td>
				  </tr>
				  
				  <tr>
				    <td class="inquire_item6"><span class="red_star">*</span>计划采集结束时间：</td>
				    <td class="inquire_form6" id="item0_3">
					    <input type="text" id="acquire_end_time" name="acquire_end_time" value="" class="input_width" readonly="readonly"/>
						&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acquire_end_time,tributton2);" />
					</td>
					<td class="inquire_item6"><span class="red_star">*</span>合同开始时间：</td>
				    <td class="inquire_form6" id="item0_3">
						<input type="text" id="design_start_date" name="design_start_date" value="" class="input_width" readOnly="readonly"/>
						&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(design_start_date,tributton3);" />
					</td>
				  </tr>
				  
				  <tr>
				  <td class="inquire_item6"><span class="red_star">*</span>合同结束时间：</td>
				    <td class="inquire_form6" id="item0_3">
						<input type="text" id="design_end_date" name="design_end_date" value="" class="input_width" readOnly="readonly"/>
						&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(design_end_date,tributton4);" />
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
					<td class="inquire_item6">勘探方法：</td>
				    <td class="inquire_form6" id="item0_5">
				    	<select class=select_width name=exploration_method  id="exploration_method" >
								<option value="0300100012000000002">二维地震</option>
								<option value="0300100012000000003">三维地震</option>
						 
						</select>
				    </td>
				  </tr>
				  <tr>
				  	<td class="inquire_item6"><span class="red_star">*</span>激发方式：</td>
				    <td class="inquire_form6" id="item0_4">
				    	<code:codeSelect cssClass="select_width"   name='build_method' option="buildMethod"  selectedValue=""  addAll="true" />
					</td>
					<td class="inquire_item6"><span class="red_star">*</span>施工队伍：</td>
					<td class="inquire_form6" id="item0_19">
						<input id="org_id" name="org_id" value="" type="hidden" class="input_width" />
						<input id="org_name" name="org_name" value="" type="text" class="input_width" />
						<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectTeam()" />
					</td>
			      </tr>
				  
				  <tr>
				    <td class="inquire_item6"><span class="red_star">*</span>利润中心：</td>
				    <td class="inquire_form6" id="item0_3">
				    	<input type="hidden" id="prctr" name="prctr" value="" class="input_width" />
						<input type="text" id="prctr_name" name="prctr_name" value="" class="input_width"  readonly="readonly"/>
						&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectPrctr()" />
				    </td>
				    <td class="inquire_item6"><span class="red_star">*</span>项目重要程度：</td>
				    <td class="inquire_form6" id="item0_5">
				    	<code:codeSelect cssClass="select_width"   name='is_main_project' option="isMainProject" selectedValue=""  addAll="true" />
				    </td>
				  </tr>
				</table>
			</div>
			
			<!-- 工作量  -->
			<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                <tr align="right" height="30">
	                  <td>&nbsp;</td>
	                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateProject()"><a href="#"></a></span></td>
	                  <td width="5"></td>
	                </tr>
	              </table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr>
					    <td class="inquire_item6"><span class="red_star">*</span>设计线束数：</td>
					    <td class="inquire_form6">
				 <input type="hidden" id="project_dynamic_no" name="project_dynamic_no" />
					  	<input type="hidden" id="design_object_workload" name="design_object_workload" />
					    	<input type="text" id="design_line_num" name="design_line_num" class="input_width" />&nbsp;束</td>
					       <td class="inquire_item6"><span class="red_star">*</span>设计工作量：</td>
					   <td class="inquire_form6" id="workload_td1" style="display:none">
						 
					    	<input   id="workload_input1" name="workload_input1" class="input_width" />&nbsp;KM	
					     </td>
					   
					    <td class="inquire_form6" id="workload_td2" style="display:block">
						 
					    	<input   id="workload_input2" name="workload_input2" class="input_width" />&nbsp;KM²	
					     </td>
					    </tr>
					    	<tr>
					    <td class="inquire_item6"></td>
					    <td class="inquire_form6"></td>
					    <td class="inquire_item6"></td>
					    <td class="inquire_form6"></td>
					</tr>
				</table>
			</div>
			
			<!-- 地质任务  -->
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
					<div align="center">
   						<span class="bc_btn"><a href="#" onclick="toUpdateProject()"></a></span>
					</div> 
			</div>
			</form>
			
			<form action="" id="workareaForm" name="workareaForm" method="post">
			<!-- 工区信息  -->
			<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                <tr align="right" height="30">
	                  <td>&nbsp;</td>
	                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateWorkarea()"><a href="#"></a></span></td>
	                  <td width="5"></td>
	                </tr>
	              </table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				    <tr>
				      <td class="inquire_item6">
				    	<input id="workarea_no"  name="workarea_no"type="hidden" />
				    	<input type="hidden" id="project_info_no1" name="project_info_no1" />
				      	<span class="red_star">*</span>工区名称：
				      </td>
				      <td class="inquire_form6">
					      <input id="workarea"  name="workarea" class="input_width" type="text" />
					      <input id="start_year" name="start_year" class="input_width" type="hidden" />
				      </td>
				      <td class="inquire_item6"><span class="red_star">*</span>区块（矿权）：</td>
				      <td class="inquire_form6" >
				      	<input name="block" id="block" value="" type="hidden" class="input_width" />
				      	<input id="spare2"  name="spare2"class="input_width" type="text"  readonly="readonly"/>
				      	<img src="<%= request.getContextPath() %>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectCoding('0300100011','block','spare2');" />
				      </td>
				    </tr>
				    
				    <tr>
				      <td class="inquire_item6"><span class="red_star">*</span>主要地表类型：</td>
				      <td class="inquire_form6" ><select id="surface_type" name="surface_type" class="select_width"></select></td>
				      <td class="inquire_item6"><span class="red_star">*</span>工区中心经度：</td>
				      <td class="inquire_form6" ><input id="focus_x"  name="focus_x" class="input_width" type="text" /></td>
				     </tr>
				     
				     <tr>
				      <td class="inquire_item6"><span class="red_star">*</span>工区中心纬度:</td>
				      <td class="inquire_form6" ><input id="focus_y"  name="focus_y"class="input_width" type="text" /></td>
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
			
			<form action="" id="qualityForm" name="qualityForm" method="post">
			<!-- 质量指标  -->
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
						<td class="inquire_item4" id="item2_0">单束线空炮率≦</td>
							<td class="inquire_form4"><input id="miss_radio" name="miss_radio" class="input_width"/>&nbsp;%</td>	
						<td class="inquire_item4">全工区空炮率≦</td>
						<td class="inquire_form4"><input id="all_miss_radio" name="all_miss_radio" class="input_width"/>&nbsp;%</td>	
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
debugger;
var projectStatus1 = new Array(
		['5000100001000000001','项目启动'],['5000100001000000002','正在运行'],['5000100001000000003','项目结束'],['5000100001000000004','项目暂停'],['5000100001000000005','施工结束']
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
	debugger;
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
	var businessType="5110000004100000104";
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
	
	function loadDataDetail(ids){
	    if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
		clearLoadData();
		var retObj = jcdpCallService("ProjectSrv", "getProjectInfo", "projectInfoNo="+ids);
		debugger;
	    processNecessaryInfo={         
   	    		businessTableName:"gp_task_project",    //置入流程管控的业务表的主表表明
   	    		businessType:businessType,        //业务类型 即为之前设置的业务大类
   	    		businessId:ids,         //业务主表主键值
   	    		businessInfo:retObj.map.project_name+'项目立项审批',        //用于待审批界面展示业务信息
   	    		applicantDate:'<%=appDate%>'       //流程发起时间
   	    	}; 
   	    	processAppendInfo={ 
   	    			projectInfoNo:ids,
   	    			projectName:retObj.map.project_name
   	    	};
   	    	loadProcessHistoryInfo();
  
 
		document.getElementById("project_info_no").value= retObj.map.project_info_no;
		document.getElementById("project_info_no1").value= retObj.map.project_info_no;
		document.getElementById("project_info_no2").value= retObj.map.project_info_no;
		document.getElementById("project_name").value= retObj.map.project_name;
		document.getElementById("project_id").value= retObj.map.project_id;
		document.getElementById("acquire_start_time").value= retObj.map.acquire_start_time;
		document.getElementById("acquire_end_time").value= retObj.map.acquire_end_time;
		document.getElementById("design_start_date").value= retObj.map.design_start_date;
		document.getElementById("design_end_date").value= retObj.map.design_end_date;
		
		//根据bulid_method的值设置显示信息
		var buildMethod = retObj.map.build_method;
		//井炮
	
		document.getElementById("org_id").value= retObj.dynamicMap.org_id;
		document.getElementById("org_name").value= retObj.dynamicMap.org_name;
		document.getElementById("prctr_name").value= retObj.map.prctr_name;
		document.getElementById("prctr").value= retObj.map.prctr;
		
		document.getElementById("market_classify").value= retObj.map.market_classify;
		document.getElementById("market_classify_name").value= retObj.map.market_classify_name;
		document.getElementById("notes").value= retObj.map.notes;
		
		document.getElementById("project_dynamic_no").value= retObj.dynamicMap.project_dynamic_no;
	  
			
			document.getElementById("design_line_num").value= retObj.dynamicMap.design_line_num;
			//document.getElementById("design_workload1").value= retObj.dynamicMap.design_workload1;
			//document.getElementById("design_workload2").value= retObj.dynamicMap.design_workload2;
		var exmethod=retObj.dynamicMap.exploration_method;
 
		if(exmethod=="0300100012000000002"){
			  document.getElementById("workload_td1").style.display="block";
			  document.getElementById("workload_td2").style.display="none";
			  document.getElementById("workload_input1").value= retObj.dynamicMap.design_sp_num;
		}else{
			  document.getElementById("workload_td2").style.display="block";
			  document.getElementById("workload_td1").style.display="none";
			  document.getElementById("workload_input2").value= retObj.dynamicMap.design_sp_num;
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
		
		
		 debugger;
 	
		sel = document.getElementById("exploration_method").options;
		value = retObj.map.exploration_method;
		for(var i=0;i<sel.length;i++)
		{
		    if(value==sel[i].value)
		    {
		       document.getElementById('exploration_method').options[i].selected=true;
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
	
		//部署图
		document.getElementById("deployDiagram").src = "<%=contextPath%>/pm/deployDiagram/deployDiagramList.jsp?projectInfoNo="+ids;
	
		//分类码
		document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=3&relationId="+ids;

		//测量测算 encodeURI(encodeURI(_tmplsgx)
				
		$("#measurement")[0].src = "<%=contextPath%>/pm/measurement/measurementList.jsp?projectInfoNo="+ids;

		
		var retObj = jcdpCallService("WorkAreaSrv", "getSurfaceType", "");
		var retCrop = jcdpCallService("WorkAreaSrv", "getCropreaType", "");
		var selectTag = document.getElementById("surface_type");
	 
 
		if(retObj.surfaceType != null){
			for(var i=0;i<retObj.surfaceType.length;i++){
				var record = retObj.surfaceType[i];
				var item = new Option(record.coding_name.replace(/\-/g," "),record.coding_code_id);
		 
				selectTag.add(item);
		 
			}
		}
		
		//工区信息
		debugger;
		if(workarea_no != null && workarea_no != ""){
			var retWorkArea = jcdpCallService("WorkAreaSrv", "getWorkarea", "workareaNo="+workarea_no);
			document.getElementById("workarea_no").value = workarea_no;
			document.getElementById("workarea").value = retWorkArea.workarea.workarea;
			document.getElementById("start_year").value = retWorkArea.workarea.start_year;
			document.getElementById("spare2").value = retWorkArea.workarea.spare2;
			//document.getElementById("region_name").value = retWorkArea.workarea.region_name;
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
		var retQuality = jcdpCallService("ProjectSrv", "getQuality", "projectInfoNo="+ids);
		if(retQuality != null && retQuality.qualityMap != null){
			document.getElementById("object_id").value = retQuality.qualityMap.objectId;
			//document.getElementById("qualified_radio").value = retQuality.qualityMap.qualifiedRadio;
			//document.getElementById("waster_radio").value = retQuality.qualityMap.wasterRadio;
			document.getElementById("miss_radio").value = retQuality.qualityMap.missRadio;
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
		document.getElementById("acquire_start_time").value= "";
		document.getElementById("acquire_end_time").value= "";
		document.getElementById("design_start_date").value= "";
		document.getElementById("design_end_date").value= "";
		document.getElementById("prctr_name").value= "";
		document.getElementById("prctr").value= "";
		document.getElementById("market_classify").value= "";
		document.getElementById("market_classify_name").value= "";
		document.getElementById("notes").value= "";		
		document.getElementById("project_dynamic_no").value= "";
		
		document.getElementById("design_line_num").value= "";
		document.getElementById("workload_input1").value= "";
		document.getElementById("workload_input2").value= "";

		document.getElementById("workarea_no").value = "";
		document.getElementById("workarea").value = "";
		document.getElementById("start_year").value = "";
		document.getElementById("spare2").value = "";
		//document.getElementById("region_name").value = ""
		document.getElementById("focus_x").value = "";
		document.getElementById("focus_y").value = "";
		document.getElementById("block").value = "";
		document.getElementById("country").value = "";
		document.getElementById("country_name").value = "";
		
		
		//质量指标
		document.getElementById("object_id").value = "";
		//document.getElementById("qualified_radio").value = "";
		//document.getElementById("waster_radio").value = "";
		document.getElementById("miss_radio").value = "";
		document.getElementById("all_miss_radio").value = ""
	}
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function toAdd(){
		popWindow('<%=contextPath%>/pm/project/multiProject/sh/insertProject.jsp?orgSubjectionId='+orgSubjectionId+'&orgId='+orgId,'750:700');
	}
	
	function toUpdateProject(){
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
		
		var str = "project_info_no="+document.getElementById("project_info_no").value;
		str += "&project_name="+encodeURI(encodeURI(document.getElementById("project_name").value));
		str += "&project_id="+document.getElementById("project_id").value;
		str += "&project_type="+document.getElementById("project_type").value;
		str += "&acquire_start_time="+document.getElementById("acquire_start_time").value;
		str += "&acquire_end_time="+document.getElementById("acquire_end_time").value;
		str += "&design_start_date="+document.getElementById("design_start_date").value;
		str += "&design_end_date="+document.getElementById("design_end_date").value;
		str += "&explore_type="+document.getElementById("explore_type").value;
		str += "&exploration_method="+document.getElementById("exploration_method").value;
		str += "&build_method="+document.getElementById("build_method").value;
		str += "&prctr="+document.getElementById("prctr").value;
		str += "&market_classify="+document.getElementById("market_classify").value;
		str += "&notes="+encodeURI(encodeURI(document.getElementById("notes").value));
		str += "&is_main_project="+document.getElementById("is_main_project").value;
		str += "&project_dynamic_no="+document.getElementById("project_dynamic_no").value;
		str += "&design_line_num="+document.getElementById("design_line_num").value;
	 	str += "&org_id="+document.getElementById("org_id").value;
		var exmethod=document.getElementById("exploration_method").value;
		if(exmethod=="0300100012000000002"){
			str += "&design_sp_num="+document.getElementById("workload_input1").value;
		}else{
			str += "&design_sp_num="+document.getElementById("workload_input2").value;
		}
		
		
	 
		
		var obj = jcdpCallService("ProjectSrv", "addProject", str);
		
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
		//str += "&region_name="+document.getElementById("region_name").value;
		str += "&surface_type="+document.getElementById("surface_type").value;
		str += "&focus_x="+document.getElementById("focus_x").value;
		str += "&focus_y="+document.getElementById("focus_y").value;
		
		str += "&block="+document.getElementById("block").value;
		str += "&country="+document.getElementById("country").value;
		
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
		if (!isTextPropertyNotNull("block", "区块（矿权）")) {
			return false;	
		}
        if (!isLimitB32("block", "区块（矿权）")) {
			return false;	
		}
        /* if (!isTextPropertyNotNull("region_name", "所属行政区")){
			return false;	
		} */
       /*  if (!isLimitB200("region_name", "所属行政区")) {
			return false;	
		} */
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
        if (!isTextPropertyNotNull("market_classify_name", "市场范围")) return false;
       	if (!isTextPropertyNotNull("acquire_start_time", "计划采集开始时间")) return false;
       	if (!isTextPropertyNotNull("acquire_end_time", "计划采集结束时间")) return false;
        if (!isTextPropertyNotNull("is_main_project", "项目重要程度")) return false;
        if (!isTextPropertyNotNull("design_start_date", "合同开始时间")) return false;
        if (!isTextPropertyNotNull("design_end_date", "合同结束时间")) return false;
        if (!isTextPropertyNotNull("build_method", "激发方式")) return false;
 
        if (!isTextPropertyNotNull("prctr_name", "利润中心")) return false;
		return true;
	}
	
	function checkText1() {		
		debugger;
		var b = true ;		
		 
	
		if(document.getElementById("design_line_num").style.display==""||document.getElementById("design_line_num").style.display=="block"){
			if (!isTextPropertyNotNull("design_line_num","设计线束数")) b = false;
			if (!isValidFloatProperty20_0("design_line_num","设计线束数")) b = false;
		}
		
		return b;
	
	}
	
	function checkMission() {
        if (!isTextPropertyNotNull("notes", "地质任务")) {
			return false;	
		}
		return true;
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
		refreshData('','',projectType, '', '', '', '<%=orgSubjectionId%>','','');
	}
	
	function toUpdateQuality(){
		
		var str = "project_info_no="+document.getElementById("project_info_no").value;
		str += "&object_id="+document.getElementById("object_id").value;
		//str += "&qualified_radio="+document.getElementById("qualified_radio").value;
		//str += "&waster_radio="+document.getElementById("waster_radio").value;
		str += "&miss_radio="+document.getElementById("miss_radio").value;
		str += "&all_miss_radio="+document.getElementById("all_miss_radio").value;
		var obj = jcdpCallService("ProjectSrv", "saveOrUpdateQuality", str);
		
		if(obj != null && obj.message == "success") {
			alert("修改成功");
		} else {
			alert("修改失败");
		}
	}
	

	function toDelete(){
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中至少一条记录!");
	     	return;
	    }	
		    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("ProjectSrv", "deleteProject", "projectInfoNos="+ids);
			window.location.href ="<%=contextPath%>/pm/project/multiProject/sh/projectList.jsp?projectType=<%=projectType%>&action=<%=action%>&orgSubjectionId=<%=orgSubjectionId%>&orgId=<%=orgId%>&isSingle=<%=isSingle%>";
		}
	}

	function toSearch(){
		popWindow('<%=contextPath%>/pm/project/multiProject/sh/project_search.jsp?projectType='+projectType+'&orgSubjectionId=<%=orgSubjectionId%>&orgId=<%=orgId %>');
	}
	
	function dbclickRow(ids){
		<%if(action.equals("view")){ %>
		location.href="<%=contextPath %>/pm/project/selectProject.srq?projectInfoNo="+ids;
		var name = document.getElementById("projectName"+ids).value;
		var longName = name;
		if (name.length > 6){
			name = name.substring(0,6)+"...";
		}
		parent.window.opener.setProject(longName, name);
		parent.window.close();
		<%}%>
		
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
</script>
</html>