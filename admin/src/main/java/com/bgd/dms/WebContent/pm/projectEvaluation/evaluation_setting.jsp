<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String project_info_no = request.getParameter("project_info_no");
	String project_name = request.getParameter("project_name");
	if(project_info_no==null || project_info_no.trim().equals("")){
		project_info_no = user.getProjectInfoNo();
		project_name = user.getProjectName();
	}
	String user_name = user.getUserName();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head> 
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
	<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
	<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  <title></title>
 <style type="text/css">
   background:#fff;
   background:#e3e3e3;
</style>
 </head> 
 <body style="background:#fff"> 
 <div id="list_table">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						    <td class="" align="center"><font size="4"><%=project_name %></font></td>
						    <td>&nbsp;</td>
						    <auth:ListButton functionId="F_PM_EVALUATION_EDIT" css="tj" event="onclick='newSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box" style="background:#e3e3e3;height: 605px;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="">
			<tr>
		    	<td class="inquire_item8" ><font size="2"><strong>1、合同执行</strong></font></td>
		    </tr>
	     	<tr>
		    	<td class="inquire_item8"><font color="red">*</font>甲方认可工作量</td>
		    	<td class="inquire_form8"><input type="hidden" name="evaluate_project_data" id="evaluate_project_data" value="" />
		    		<input name="contract_workload_accept" id="contract_workload_accept" type="text" class="input_width" value="" /></td>
		    	<td class="inquire_item8">合同要求工作量</td>
		    	<td class="inquire_form8">
		    		<input name="contract_workload_demand" id="contract_workload_demand" type="text" class="input_width" value="" disabled="disabled"/></td>
		    	<td class="inquire_item8">实际项目结束时间</td>
		    	<td class="inquire_form8">
		    		<input name="contract_end_actual" id="contract_end_actual" type="text" class="input_width" value="" disabled="disabled" /></td>
		    	<td class="inquire_item8">合同要求结束时间</td>
		    	<td class="inquire_form8">
		    		<input name="contract_end_plan" id="contract_end_plan" type="text" class="input_width" value="" disabled="disabled" /></td>
		    </tr>
		    <tr>
		    	<td class="inquire_item8"><font size="2"><strong>2、生产进度</strong></font></td>
		    </tr>
	     	<tr>
		    	<td class="inquire_item8">计划是否已审批</td>
		    	<td class="inquire_form8"><select id="progress_plan_audit" name="progress_plan_audit" class="select_width" disabled="disabled"><option value="0">否</option><option value="1">是</option></select></td>
		    	<td class="inquire_item8">是否已下达目标日效</td>
		    	<td class="inquire_form8"><select id="progress_target_sp" name="progress_target_sp" class="select_width" disabled="disabled"><option value="0">否</option><option value="1">是</option></select></td>
		    	<td class="inquire_item8"><font color="red">*</font>计划是否按甲方要求变更</td>
		    	<td class="inquire_form8"><select id="progress_plan_change" name="progress_plan_change" class="select_width"><option value="0">否</option><option value="1">是</option></select></td>
		    </tr>
		    <tr>
		    	<td class="inquire_item8">实际施工结束日期</td>
		    	<td class="inquire_form8"><input name="progress_end_actual" id="progress_end_actual" type="text" class="input_width" value="" disabled="disabled" /></td>
		    	<td class="inquire_item8">计划施工结束日期</td>
		    	<td class="inquire_form8"><input name="progress_end_plan" id="progress_end_plan" type="text" class="input_width" value="" disabled="disabled" />
		    		<input name="progress_end_num" id="progress_end_num" type="hidden" class="input_width" value="" disabled="disabled" /></td>
		    	<td class="inquire_item8">实际日效</td>
		    	<td class="inquire_form8"><input name="progress_actual_sp" id="progress_actual_sp" type="text" class="input_width" value="" disabled="disabled" /></td>
		    	<td class="inquire_item8">计划日效</td>
		    	<td class="inquire_form8"><input name="progress_plan_sp" id="progress_plan_sp" type="text" class="input_width" value="" disabled="disabled" /></td>
		    </tr>
		    <tr>
		    	<td class="inquire_item8"><font size="2"><strong>3、质量管理</strong></font></td>
		    </tr>
		    <tr>
		    	<td class="inquire_item8">实际合格品率%</td>
		    	<td class="inquire_form8"><input name="actual_qulified" id="actual_qulified" type="text" class="input_width" value="" disabled="disabled" /></td>
		    	<td class="inquire_item8">实际一级品率%</td>
		    	<td class="inquire_form8"><input name="actual_first" id="actual_first" type="text" class="input_width" value="" disabled="disabled" /></td>
		    	<td class="inquire_item8">实际空炮率%</td>
		    	<td class="inquire_form8"><input name="actual_miss" id="actual_miss" type="text" class="input_width" value="" disabled="disabled" /></td>
		    	<td class="inquire_item8">实际废炮率%</td>
		    	<td class="inquire_form8"><input name="actual_waster" id="actual_waster" type="text" class="input_width" value="" disabled="disabled" /></td>
		    </tr>
		    <tr>
		    	<td class="inquire_item8">合同要求合格品率%</td>
		    	<td class="inquire_form8"><input name="demand_qulified" id="demand_qulified" type="text" class="input_width" value="" disabled="disabled" /></td>
		    	<td class="inquire_item8">合同要求一级品率%</td>
		    	<td class="inquire_form8"><input name="demand_first" id="demand_first" type="text" class="input_width" value="" disabled="disabled" /></td>
		    	<td class="inquire_item8">合同要求空炮率%</td>
		    	<td class="inquire_form8"><input name="demand_miss" id="demand_miss" type="text" class="input_width" value="" disabled="disabled" /></td>
		    	<td class="inquire_item8">合同要求废炮率%</td>
		    	<td class="inquire_form8"><input name="demand_waster" id="demand_waster" type="text" class="input_width" value="" disabled="disabled" /></td>
		    </tr>
		    <tr>
		    	<td class="inquire_item8">质量事故一般</td>
		    	<td class="inquire_form8"><input name="accident_small" id="accident_small" type="text" class="input_width" value="" disabled="disabled" /></td>
		    	<td class="inquire_item8">质量事故较大</td>
		    	<td class="inquire_form8"><input name="accident_large" id="accident_large" type="text" class="input_width" value="" disabled="disabled" /></td>
		    	<td class="inquire_item8">质量事故重大</td>
		    	<td class="inquire_form8"><input name="accident_great" id="accident_great" type="text" class="input_width" value="" disabled="disabled" /></td>
		    	<td class="inquire_item8">质量事故特大</td>
		    	<td class="inquire_form8"><input name="accident_super" id="accident_super" type="text" class="input_width" value="" disabled="disabled" /></td>
		    </tr>
		    <tr>
		    	<td class="inquire_item8"><font color="red">*</font>质量事故扣分</td>
		    	<td class="inquire_form8"><input name="quality_accident_score" id="quality_accident_score" type="text" class="input_width" value="0" /></td>
		    	<td class="inquire_item8"><font color="red">*</font>甲方投诉质量问题(次)</td>
		    	<td class="inquire_form8"><input name="quality_problem_num" id="quality_problem_num" type="text" class="input_width" value=""/></td>
		    	<td class="inquire_item8"><font color="red">*</font>获得甲方优质工程评价</td>
		    	<td class="inquire_form8"><select id="quality_rewards" name="quality_rewards" class="select_width"><option value="0">否</option><option value="1">是</option></select></td>
		    	<td class="inquire_item8"><font color="red">*</font>奖励得分</td>
		    	<td class="inquire_form8"><input name="quality_rewards_score" id="quality_rewards_score" type="text" class="input_width" value="0" /></td>
		    	
		    </tr>
		    <tr>
		    	<td class="inquire_item8"><font size="2"><strong>4、安全管理</strong></font></td>
		    </tr>
		    <tr>
		    	<td class="inquire_item8"><font color="red">*</font>体系审核成绩</td>
		    	<td class="inquire_form8"><input name="hse_audit_score" id="hse_audit_score" type="text" class="input_width" value="" /></td>
		    	<td class="inquire_item8"><font color="red">*</font>驻队监督项目开工验收</td>
		    	<td class="inquire_form8"><select id="hse_start_check" name="hse_start_check" class="select_width"><option value="0">不合格</option><option value="1">合格</option></select></td>
		    	<td class="inquire_item8"><font color="red">*</font>项目过程安全管理</td>
		    	<td class="inquire_form8"><select id="hse_process_safety" name="hse_process_safety" class="select_width">
		    		<option value="0">优</option><option value="1">良</option>
		    		<option value="2">中</option><option value="3">差</option></select></td>
		    	<td class="inquire_item8"><font color="red">*</font>项目过程安全管理扣分</td>
		    	<td class="inquire_form8"><input name="hse_safety_score" id="hse_safety_score" type="text" class="input_width" value="0" /></td>
		    </tr>
		    <tr>	
		    	<td class="inquire_item8">事故一般A级</td>
		    	<td class="inquire_form8"><input name="hse_small_a" id="hse_small_a" type="text" class="input_width" value="" disabled="disabled" /></td>
		    
		    	<td class="inquire_item8">事故一般B级</td>
		    	<td class="inquire_form8"><input name="hse_small_b" id="hse_small_b" type="text" class="input_width" value="" disabled="disabled" /></td>
		    	<td class="inquire_item8">事故一般C级</td>
		    	<td class="inquire_form8"><input name="hse_small_c" id="hse_small_c" type="text" class="input_width" value="" disabled="disabled" /></td>
		    	<td class="inquire_item8">事故较大</td>
		    	<td class="inquire_form8"><input name="hse_large" id="hse_large" type="text" class="input_width" value="" disabled="disabled" /></td>
		    </tr>
		    <tr>	
		    	<td class="inquire_item8">事故重大</td>
		    	<td class="inquire_form8"><input name="hse_great" id="hse_great" type="text" class="input_width" value="" disabled="disabled" /></td>
		    	<td class="inquire_item8">事故特大</td>
		    	<td class="inquire_form8"><input name="hse_super" id="hse_super" type="text" class="input_width" value="" disabled="disabled" /></td>
		    	<td class="inquire_item8"><font color="red">*</font>安全事故扣分</td>
		    	<td class="inquire_form8"><input name="hse_accident_score" id="hse_accident_score" type="text" class="input_width" value="0" /></td>
		    </tr>
		    <tr>
		    	<td class="inquire_item8"><font size="2"><strong>5、设备管理</strong></font></td>
		    </tr>
		    <tr>	
		    	<td class="inquire_item8">采集设备盘亏损失率%(道)</td>
		    	<td class="inquire_form8"><input name="device_miss" id="device_miss" type="text" class="input_width" value="" disabled="disabled" /></td>
		    	<td class="inquire_item8">采集设备毁损率%(道)</td>
		    	<td class="inquire_form8"><input name="device_bad" id="device_bad" type="text" class="input_width" value="" disabled="disabled" /></td>
		    	<td class="inquire_item8">设备维修保养完成率%(台)</td>
		    	<td class="inquire_form8"><input name="divice_repair" id="divice_repair" type="text" class="input_width" value="" disabled="disabled" /></td>
		    </tr>
		    <tr>
		    	<td class="inquire_item8"><font size="2"><strong>6、成本控制</strong></font></td>
		    </tr>
		    <tr>	
		    	<td class="inquire_item8">实际成本</td>
		    	<td class="inquire_form8"><input name="cost_actual" id="cost_actual" type="text" class="input_width" value="" disabled="disabled" /></td>
		    	<td class="inquire_item8">目标成本</td>
		    	<td class="inquire_form8"><input name="cost_target" id="cost_target" type="text" class="input_width" value="" disabled="disabled" /></td>
		    	<td class="inquire_item8">目标成本符合率差额%</td>
		    	<td class="inquire_form8"><input name="cost_ratio" id="cost_ratio" type="text" class="input_width" value="" disabled="disabled" /></td>
		    </tr>
		    <tr>
		    	<td class="inquire_item8"><font size="2"><strong>7、队伍建设</strong></font></td>
		    </tr>
		    <tr>	
		    	<td class="inquire_item8"><font color="red">*</font>重要制度没执行(项)</td>
		    	<td class="inquire_form8"><input name="team_sys_major" id="team_sys_major" type="text" class="input_width" value="" /></td>
		    	<td class="inquire_item8"><font color="red">*</font>重要制度扣分</td>
		    	<td class="inquire_form8"><input name="team_sys_major_score" id="team_sys_major_score" type="text" class="input_width" value="0"/></td>
		    	<td class="inquire_item8"><font color="red">*</font>一般制度没执行(项)</td>
		    	<td class="inquire_form8"><input name="team_sys_normal" id="team_sys_normal" type="text" class="input_width" value=""  /></td>
		    	<td class="inquire_item8"><font color="red">*</font>一般制度扣分</td>
		    	<td class="inquire_form8"><input name="team_sys_normal_score" id="team_sys_normal_score" type="text" class="input_width" value="0" /></td>
		    </tr>
		    <tr>	
		    	<td class="inquire_item8"><font color="red">*</font>重要基础资料缺少(项)</td>
		    	<td class="inquire_form8"><input name="team_data_major" id="team_data_major" type="text" class="input_width" value="" /></td>
		    	<td class="inquire_item8"><font color="red">*</font>重要基础资料扣分</td>
		    	<td class="inquire_form8"><input name="team_data_major_score" id="team_data_major_score" type="text" class="input_width" value="0"/></td>
		    	<td class="inquire_item8"><font color="red">*</font>一般基础资料缺少(项)</td>
		    	<td class="inquire_form8"><input name="team_data_normal" id="team_data_normal" type="text" class="input_width" value=""  /></td>
		    	<td class="inquire_item8"><font color="red">*</font>一般基础资料扣分</td>
		    	<td class="inquire_form8"><input name="team_data_normal_score" id="team_data_normal_score" type="text" class="input_width" value="0" /></td>
		    </tr>
		    <tr>	
		    	<td class="inquire_item8"><font color="red">*</font>基础资料不规范(项)</td>
		    	<td class="inquire_form8"><input name="team_data_basic" id="team_data_basic" type="text" class="input_width" value="" /></td>
		    	<!-- <td class="inquire_item8"><font color="red">*</font>扣分</td>
		    	<td class="inquire_form8"><input name="team_data_basic_score" id="team_data_basic_score" type="text" class="input_width" value=""/></td> -->
		    	<td class="inquire_item8"><font color="red">*</font>是否发生重大群体事件</td>
		    	<td class="inquire_form8"><select id="team_event_major" name="team_event_major" class="select_width"><option value="0">否</option><option value="1">是</option></select></td>
		    	<td class="inquire_item8"><font color="red">*</font>重大群体事件扣分</td>
		    	<td class="inquire_form8"><input name="team_event_major_score" id="team_event_major_score" type="text" class="input_width" value="0" /></td>
		    </tr>
		    <tr>	
		    	<td class="inquire_item8"><font color="red">*</font>是否发生群体事件</td>
		    	<td class="inquire_form8"><select id="team_event_normal" name="team_event_normal" class="select_width"><option value="0">否</option><option value="1">是</option></select></td>
		    	<td class="inquire_item8"><font color="red">*</font>群体事件扣分</td>
		    	<td class="inquire_form8"><input name="team_event_normal_score" id="team_event_normal_score" type="text" class="input_width" value="0"/></td>
		    	<td class="inquire_item8"><font color="red">*</font>违纪违规受到处分(人次)</td>
		    	<td class="inquire_form8"><input name="team_punish" id="team_punish" type="text" class="input_width" value=""  /></td>
		    	<td class="inquire_item8"><font color="red">*</font>违纪违规扣分</td>
		    	<td class="inquire_form8"><input name="team_punish_score" id="team_punish_score" type="text" class="input_width" value="0" /></td>
		    </tr>
		    <tr>	
		    	<td class="inquire_item8"><font color="red">*</font>工作效果有缺陷(项)</td>
		    	<td class="inquire_form8"><input name="team_defect" id="team_defect" type="text" class="input_width" value=""/></td>
		    	<td class="inquire_item8"><font color="red">*</font>工作效果扣分</td>
		    	<td class="inquire_form8"><input name="team_defect_score" id="team_defect_score" type="text" class="input_width" value="0"/></td>
		    	<td class="inquire_item8"><font color="red">*</font>与地方发生纠纷(起)</td>
		    	<td class="inquire_form8"><input name="team_issue" id="team_issue" type="text" class="input_width" value=""  /></td>
		    </tr>
	    </table>
	</div> 
</div>	
<script type="text/javascript">
	cruConfig.contextPath = '<%=contextPath%>';
	function refreshData(){
		var project_info_no = '<%=project_info_no%>';
		var sql = "select t.evaluate_project_data ,t.contract_workload_accept ,t.contract_workload_demand ,t.contract_end_plan,t.contract_end_actual, "+
		" t.progress_plan_audit ,t.progress_target_sp ,t.progress_plan_change,t.progress_end_plan ,t.progress_end_actual ,t.progress_end_num, "+
		" t.progress_plan_sp,t.progress_actual_sp,t.quality_problem_num,t.quality_rewards ,t.quality_rewards_score,t.quality_accident_score, "+
		" t.hse_audit_score,t.hse_start_check,t.hse_process_safety,t.hse_safety_score,t.hse_accident_score,t.device_miss ,t.device_bad ,t.divice_repair, "+
		" t.cost_target ,t.cost_actual ,t.cost_ratio,t.team_sys_major,t.team_sys_major_score ,t.team_sys_normal,t.team_sys_normal_score, "+
		" t.team_data_major,t.team_data_major_score,t.team_data_normal,t.team_data_normal_score,t.team_data_basic,t.team_data_basic_score, "+ 
		" t.team_event_major,t.team_event_major_score,t.team_event_normal,t.team_event_normal_score,t.team_punish,t.team_punish_score, "+
		" t.team_defect,t.team_defect_score,t.team_issue "+
		" from bgp_pm_evaluate_project_data t where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"'";
		var retObj = syncRequest('post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
		if(retObj!=null&& retObj.returnCode =='0' && retObj.datas.length>0){
			if(retObj.datas[0]!=null){
				var map = retObj.datas[0];
				with(map){
					document.getElementById("evaluate_project_data").value = evaluate_project_data;
					document.getElementById("contract_workload_accept").value = contract_workload_accept;
					document.getElementById("contract_workload_demand").value = contract_workload_demand;
					document.getElementById("contract_end_plan").value = contract_end_plan;
					document.getElementById("contract_end_actual").value = contract_end_actual;
					document.getElementById("progress_plan_audit").options[progress_plan_audit].selected= true;
					document.getElementById("progress_target_sp").options[progress_target_sp].selected= true;
					document.getElementById("progress_plan_change").options[progress_plan_change].selected= true;
					document.getElementById("progress_end_plan").value = progress_end_plan;
					document.getElementById("progress_end_actual").value = progress_end_actual;
					document.getElementById("progress_end_num").value = progress_end_num;
					document.getElementById("progress_plan_sp").value = progress_plan_sp;
					document.getElementById("progress_actual_sp").value = progress_actual_sp;
					document.getElementById("quality_problem_num").value = quality_problem_num;
					document.getElementById("quality_rewards").options[quality_rewards].selected= true;
					document.getElementById("quality_rewards_score").value = quality_rewards_score;
					document.getElementById("quality_accident_score").value = quality_accident_score;
					document.getElementById("hse_audit_score").value = hse_audit_score;
					document.getElementById("hse_start_check").options[hse_start_check].selected= true;
					document.getElementById("hse_process_safety").options[hse_process_safety].selected= true;
					document.getElementById("hse_safety_score").value = hse_safety_score;
					document.getElementById("hse_accident_score").value = hse_accident_score;
					document.getElementById("device_miss").value = device_miss;
					document.getElementById("device_bad").value = device_bad;
					document.getElementById("divice_repair").value = divice_repair;
					document.getElementById("cost_target").value = cost_target;
					document.getElementById("cost_actual").value = cost_actual;
					document.getElementById("cost_ratio").value = cost_ratio;
					document.getElementById("team_sys_major").value = team_sys_major;
					document.getElementById("team_sys_major_score").value = team_sys_major_score;
					document.getElementById("team_sys_normal").value = team_sys_normal;
					document.getElementById("team_sys_normal_score").value = team_sys_normal_score;
					document.getElementById("team_data_major").value = team_data_major;
					document.getElementById("team_data_major_score").value = team_data_major_score;
					document.getElementById("team_data_normal").value = team_data_normal;
					document.getElementById("team_data_normal_score").value = team_data_normal_score;
					document.getElementById("team_data_basic").value = team_data_basic;
					document.getElementById("team_event_major").options[team_event_major].selected= true;
					document.getElementById("team_event_major_score").value = team_event_major_score;
					document.getElementById("team_event_normal").options[team_event_normal].selected= true;
					document.getElementById("team_event_normal_score").value = team_event_normal_score;
					document.getElementById("team_punish").value = team_punish;
					document.getElementById("team_punish_score").value = team_punish_score;
					document.getElementById("team_defect").value = team_defect;
					document.getElementById("team_defect_score").value = team_defect_score;
					document.getElementById("team_issue").value = team_issue;
				}
			}
		}
		sql = "select decode(d.workload ,'2',d.design_workload2 ,d.design_workload1) contract_workload_demand ,a.actual_finish_date contract_end_actual ,t.design_end_date contract_end_plan, "+
		" decode(nvl(wf.proc_status,'0'),'3','1','0') progress_plan_audit ,decode(nvl(dp.pro_plan_id,'0'),'0','0','1') progress_target_sp,t.project_end_time progress_end_actual, "+
		" t.acquire_end_time progress_end_plan ,nvl((t.project_end_time - t.acquire_end_time),0) progress_end_num ,round(decode(nvl(w.plan_date,0),0,0,nvl(w.plan_sp,0)/w.plan_date)) progress_plan_sp, "+
		" round(decode(nvl(w.actual_date,0),0,0,nvl(w.actual_sp,0)/w.actual_date)) progress_actual_sp ,(select to_number(to_char(cost_detail_money/10000,'99999999.00')) cost_detail_money "+ 
		"   from view_op_target_plan_money_s where node_code = 'S01001' and project_info_no='"+project_info_no+"') cost_target,(select to_number(to_char(cost_detail_money/10000,'99999999.00')) cost_detail_money "+
		"   from view_op_target_actual_money_s where node_code = 'S01001' and project_info_no='"+project_info_no+"') cost_actual,"+
		" case when nvl((pl.plan_num), 0)=0 then '' when (nvl(rp.actual_num, 0)/nvl(pl.plan_num,0)*100)<1 then to_char((nvl(rp.actual_num, 0)/nvl(pl.plan_num,0)*10000)/100.00,'0.99') else to_char((nvl(rp.actual_num, 0)/nvl(pl.plan_num,0)*10000)/100.00,'9999.99') end divice_repair "+
		" from gp_task_project t join bgp_p6_project p6 on t.project_info_no = p6.project_info_no and p6.bsflag ='0' "+
		" left join bgp_p6_activity a on p6.object_id = a.project_object_id and a.bsflag ='0' and a.name like'%项目结束%' "+
		" join gp_task_project_dynamic d on t.project_info_no = d.project_info_no and d.bsflag ='0' "+
		" join bgp_pm_project_plan pp on t.project_info_no = pp.project_info_no and pp.bsflag ='0' "+
		" left join common_busi_wf_middle wf on pp.object_id = wf.business_id and wf.bsflag ='0' "+
		" left join(select t.pro_plan_id ,t.project_info_no from gp_proj_product_plan t  "+
		"   where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"' and rownum =1) dp  on t.project_info_no = dp.project_info_no "+
		" left join(select t.project_info_no ,rr.actual_sp,rr.actual_date ,pp.plan_sp ,(nvl(t.project_end_time ,rr.produce_date)-pp.record_month-(-1)) plan_date "+
		"   from gp_task_project t left join(select t.project_info_no,count(t.gp_daily_id) actual_date ,max(t.send_date) produce_date, "+
		"   sum(nvl(t.daily_finishing_2d_sp,0)-(-nvl(t.daily_finishing_3d_sp,0))) actual_sp from rpt_gp_daily t where t.bsflag = '0'  "+
		"   and t.work_status not like '暂停%' and t.project_info_no ='"+project_info_no+"' "+
		"   and t.send_date >=(select nvl(gp.project_start_time,sysdate) from gp_task_project gp "+
		"   where gp.bsflag='0' and gp.project_info_no=t.project_info_no ) "+
		"   and t.send_date <= (select nvl(gp.project_end_time,sysdate) from gp_task_project gp "+
		"   where gp.bsflag='0' and gp.project_info_no=t.project_info_no) group by t.project_info_no)rr on t.project_info_no = rr.project_info_no  "+
		"   left join(select p.project_info_no ,sum(nvl(p.workload,0)) plan_sp ,to_date(min(p.record_month),'yyyy-MM-dd') record_month  "+
		"   from gp_proj_product_plan p where p.bsflag ='0' and p.oper_plan_type ='colldailylist' and p.workload is not null "+
		"   and p.project_info_no ='"+project_info_no+"' group by p.project_info_no) pp on t.project_info_no = pp.project_info_no  "+
		"   where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"') w on t.project_info_no = w.project_info_no "+
		" left join(select dui.project_info_id project_info_no,count(t.repair_info) actual_num from bgp_comm_device_repair_info t "+
		" left join gms_device_account_dui dui on t.device_account_id=dui.dev_acc_id"+
		" where dui.bsflag ='0' and dui.project_info_id='"+project_info_no+"' group by dui.project_info_id) rp on t.project_info_no = rp.project_info_no"+
		" left join(select dui.project_info_id project_info_no,count(plan.maintenance_id) plan_num from GMS_DEVICE_MAINTENANCE_PLAN plan"+
		" left join gms_device_account_dui dui on dui.dev_acc_id=plan.dev_acc_id and dui.bsflag ='0'"+
		" where dui.project_info_id='"+project_info_no+"' and plan.plan_date>dui.actual_in_time"+
		" group by dui.project_info_id) pl on t.project_info_no = pl.project_info_no"+
		" where d.project_info_no ='"+project_info_no+"' ";
		retObj = syncRequest('post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
		if(retObj!=null&& retObj.returnCode =='0' && retObj.datas.length>0){
			if(retObj.datas[0]!=null){
				var map = retObj.datas[0];
				with(map){
					document.getElementById("contract_workload_demand").value = contract_workload_demand;
					document.getElementById("contract_end_plan").value = contract_end_plan;
					document.getElementById("contract_end_actual").value = contract_end_actual;
					document.getElementById("progress_plan_audit").options[progress_plan_audit].selected= true;
					document.getElementById("progress_target_sp").options[progress_target_sp].selected= true;
					document.getElementById("progress_end_plan").value = progress_end_plan;
					document.getElementById("progress_end_actual").value = progress_end_actual;
					//document.getElementById("progress_end_num").value = progress_end_num;
					document.getElementById("progress_plan_sp").value = progress_plan_sp;
					document.getElementById("progress_actual_sp").value = progress_actual_sp;
					//document.getElementById("device_miss").value = device_miss;
					//document.getElementById("device_bad").value = device_bad;
					document.getElementById("divice_repair").value = divice_repair;
					document.getElementById("cost_target").value = cost_target;
					document.getElementById("cost_actual").value = cost_actual;
					var ratio = 0;
					if(cost_target!=null && cost_target!=0){
						ratio = Math.round((cost_actual-cost_target)/cost_target*100*100)/100.0;
					}
					document.getElementById("cost_ratio").value = ratio;
				}
			}
		}
		sql = " select q.qualified_radio qualified_index ,q.firstlevel_radio first_index ,q.miss_radio miss_index ,q.waster_radio waster_index ,aa.small_num ,aa.large_num ,aa.great_num ,aa.super_num, "+
		" decode(nvl(dd.total,0),0,0,round(nvl(dd.qualified,0)/dd.total*100*1000)/1000) qualified,decode(nvl(dd.total,0),0,0,round(nvl(dd.first,0)/dd.total*100*1000)/1000) first, "+
		" decode(nvl(dd.total,0),0,0,round(nvl(dd.waster,0)/dd.total*100*1000)/1000) waster,decode(nvl(dd.total,0),0,0,round(nvl(dd.miss,0)/dd.total*100*1000)/1000) miss  "+
		" from bgp_pm_quality_index q  "+
		" left join(select sum(nvl(t.daily_acquire_sp_num,0)-(-nvl(t.daily_jp_acquire_shot_num,0))-(-nvl(t.daily_qq_acquire_shot_num,0)))total ,sum(nvl(t.daily_acquire_firstlevel_num,0)) first , "+ 
		"   decode(sum(nvl(t.daily_acquire_qualified_num,0)),0,sum(nvl(t.daily_acquire_firstlevel_num,0))-(-sum(nvl(t.collect_2_class,0))),sum(nvl(t.daily_acquire_qualified_num,0))) qualified , "+ 
		"   sum(nvl(t.collect_waster_num,0)) waster ,sum(nvl(t.collect_miss_num,0)) miss,t.project_info_no from gp_ops_daily_report t  "+
		"   where t.bsflag='0' and t.audit_status ='3' and t.project_info_no ='"+project_info_no+"' group by t.project_info_no ) dd on q.project_info_no = dd.project_info_no "+
		" left join(select a.project_info_no ,sum(a.small_num) small_num ,sum(a.large_num)large_num ,sum(a.great_num)great_num,sum(a.super_num)super_num "+
		"   from bgp_qua_accident a where a.bsflag ='0' and a.project_info_no ='"+project_info_no+"' "+
		"   group by a.project_info_no) aa on q.project_info_no = aa.project_info_no "+
		" where q.bsflag ='0' and q.project_info_no ='"+project_info_no+"'";
		retObj = syncRequest('post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
		if(retObj!=null && retObj.returnCode =='0' && retObj.datas.length>0){
			var map = retObj.datas[0];
			with(map){
				document.getElementById("actual_qulified").value = qualified;
				document.getElementById("actual_first").value = first;
				document.getElementById("actual_miss").value = miss;
				document.getElementById("actual_waster").value = waster;
				document.getElementById("demand_qulified").value = qualified_index;
				document.getElementById("demand_first").value = first_index;
				document.getElementById("demand_miss").value = miss_index;
				document.getElementById("demand_waster").value = waster_index;
				document.getElementById("accident_small").value = small_num;
				document.getElementById("accident_large").value = large_num;
				document.getElementById("accident_great").value = great_num;
				document.getElementById("accident_super").value = super_num;
			}
		}
		sql = "select n.project_info_no , r.accident_level ,count(r.accident_level) accident_num "+
		" from bgp_hse_accident_news n ,bgp_hse_accident_record r where n.bsflag ='0' and r.bsflag ='0' "+
		" and n.hse_accident_id = r.hse_accident_id and n.project_info_no ='"+project_info_no+"' "+
		" group by n.project_info_no , r.accident_level ";
		retObj = syncRequest('post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
		if(retObj!=null && retObj.returnCode =='0' && retObj.datas.length>0){
			for(var i=0;retObj.datas[i]!=null && i<retObj.datas.length;i++){
				var map = retObj.datas[i];
				with(map){
					if(accident_level!=null && accident_level=='5110000043000000001'){
						document.getElementById("hse_small_a").value = accident_num;
					}else if(accident_level!=null && accident_level=='5110000043000000002'){
						document.getElementById("hse_small_b").value = accident_num;
					}else if(accident_level!=null && accident_level=='5110000043000000003'){
						document.getElementById("hse_small_c").value = accident_num;
					}else if(accident_level!=null && accident_level=='5110000043000000004'){
						document.getElementById("hse_large").value = accident_num;
					}else if(accident_level!=null && accident_level=='5110000043000000005'){
						document.getElementById("hse_great").value = accident_num;
					}else if(accident_level!=null && accident_level=='5110000043000000006'){
						document.getElementById("hse_super").value = accident_num;
					}
				}
			}
		}
	}
	refreshData();
	function checkIfNum(){
		if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8){
			return true;
		}
		else{
			alert("只能输入数字");
			return false;
		}
	}
	function newSubmit() {
		if(checkValue()==false){
			return;
		}
		var evaluate_project_data = document.getElementById("evaluate_project_data").value;
		var contract_workload_accept = document.getElementById("contract_workload_accept").value;
		var contract_workload_demand = document.getElementById("contract_workload_demand").value;
		var workload = 0;
		if(contract_workload_demand>contract_workload_accept){
			workload = Math.round((contract_workload_demand - contract_workload_accept)/contract_workload_accept*10000)/100.00*0.2;
			if(workload>3) workload = 3;
		}
		var submit = "工作量="+workload;
		var contract_end_actual = document.getElementById("contract_end_actual").value;
		var contract_end_plan = document.getElementById("contract_end_plan").value;
		var end = 0;
		if(contract_end_actual ==null || contract_end_actual ==''){
			if(((new Date()).getTime()-3600*24*1000)>(new Date(contract_end_plan.replace(/-/g,'/'))).getTime()){
				end = 7;
			}
		}else{
			if(contract_end_actual > contract_end_plan){
				end = 7;
			}
		}
		submit = submit +"&工期="+end+"&合同执行="+(workload+end);
		var progress_plan_audit = document.getElementById("progress_plan_audit").value;
		var progress_target_sp = document.getElementById("progress_target_sp").value;
		var progress_plan_change = document.getElementById("progress_plan_change").value;
		var plan1 = 0;
		if(progress_plan_audit!=null && progress_plan_audit==0){
			plan1++;
		}
		if(progress_target_sp!=null && progress_target_sp==0){
			plan1++;
		}
		if(progress_plan_change!=null && progress_plan_change==0){
			plan1++;
		}
		submit += "&进度计划="+plan1;
		var progress_end_actual = document.getElementById("progress_end_actual").value;
		var progress_end_plan = document.getElementById("progress_end_plan").value;
		var plan2 = 0;
		if(progress_end_actual!=null && progress_end_actual!=''){
			var actual = ((new Date(progress_end_actual.replace(/-/g,'/'))).getTime()-(new Date(progress_end_plan.replace(/-/g,'/'))).getTime())/3600/1000/24;
			if(actual>0 && actual<=5){
				plan2 = actual*0.2;
			}else if(actual>5 && actual<=10){
				plan2 = 2 + actual-5;
			}else if(actual>=11 ){
				plan2 = 7 + (actual -10)*2;
			}
			if(plan2>20) plan2 = 20;
		}else{
			var actual = Math.round(((new Date()).getTime()-(new Date(progress_end_plan.replace(/-/g,'/'))).getTime())/3600/1000/24);
			if(actual>0 && actual<=5){
				plan2 = actual*0.2;
			}else if(actual>5 && actual<=10){
				plan2 = 2 + actual-5;
			}else if(actual>=11 ){
				plan2 = 7 + (actual -10)*2;
			}
			if(plan2>20) plan2 = 20;
		}
		submit += "&计划执行="+plan2;
		var progress_actual_sp = document.getElementById("progress_actual_sp").value;
		var progress_plan_sp = document.getElementById("progress_plan_sp").value;
		var plan3 =0;
		if(progress_actual_sp<progress_plan_sp){
			plan3 = 7;
		}
		submit += "&提速目标="+plan3;
		submit += "&生产进度="+(plan1+plan2+plan3);
		var actual_qulified = document.getElementById("actual_qulified").value;
		var actual_first = document.getElementById("actual_first").value;
		var actual_miss = document.getElementById("actual_miss").value;
		var actual_waster = document.getElementById("actual_waster").value;
		var quality_actual_index = '实际合格品率:'+actual_qulified+'、一级品率:'+actual_first+'、空炮率:'+actual_miss +'、废炮率:'+actual_waster;
		var demand_qulified = document.getElementById("demand_qulified").value;
		var demand_first = document.getElementById("demand_first").value;
		var demand_miss = document.getElementById("demand_miss").value;
		var demand_waster = document.getElementById("demand_waster").value;
		var qualified = 0;
		if(((actual_qulified-demand_qulified)<0) ||((actual_first-demand_first)<0) || ((actual_miss-demand_miss)>0)|| ((actual_waster-demand_waster)>0) ){
			qualified = 15;
		}
		var quality_demand_index = '合同要求合格品率:'+demand_qulified+'、一级品率:'+demand_first+'、空炮率:'+demand_miss+'、废炮率:'+demand_waster;
		var accident_small = document.getElementById("accident_small").value;
		var accident_large = document.getElementById("accident_large").value;
		var accident_great = document.getElementById("accident_great").value;
		var accident_super = document.getElementById("accident_super").value;
		var quality_accident = '质量事故一般:'+accident_small+'次、较大:'+accident_large+'次、重大:'+accident_great+'次、特大:'+accident_super+'次';
		var quality_accident_score = document.getElementById("quality_accident_score").value;
		qualified += -(-quality_accident_score);
		var quality_problem_num = document.getElementById("quality_problem_num").value;
		qualified += -(-quality_problem_num*5);
		if(qualified>15) qualified = 15;
		submit += "&质量指标="+qualified;
		var quality_rewards = document.getElementById("quality_rewards").value;
		var quality_rewards_score = document.getElementById("quality_rewards_score").value;
		submit += "&优质工程评价="+(-quality_rewards_score);
		submit += "&质量管理="+(qualified-quality_rewards_score);
		var hse_audit_score = document.getElementById("hse_audit_score").value;
		var audit = 0;
		if(hse_audit_score>80 && hse_audit_score<90){
			audit = 2;
		}else if(hse_audit_score>60 && hse_audit_score<80){
			audit = 4;
		}else if(hse_audit_score<60){
			audit = 10;
		}
		submit += "&体系审核="+audit;
		var hse_start_check = document.getElementById("hse_start_check").value;
		var hse_process_safety = document.getElementById("hse_process_safety").value;
		var hse_safety_score = document.getElementById("hse_safety_score").value;
		var hse_check = 0;
		if(hse_start_check!=null && hse_start_check ==0){
			hse_check = 2;
		}
		submit += "&开工验收="+(hse_check-(hse_safety_score));
		var hse_small_a = document.getElementById("hse_small_a").value;
		var hse_small_b = document.getElementById("hse_small_b").value;
		var hse_small_c = document.getElementById("hse_small_c").value;
		var hse_large = document.getElementById("hse_large").value;
		var hse_great = document.getElementById("hse_great").value;
		var hse_super = document.getElementById("hse_super").value;
		if(hse_small_a==null || hse_small_a=='')hse_small_a=0;
		if(hse_small_b==null || hse_small_b=='')hse_small_b=0;
		if(hse_small_c==null || hse_small_c=='')hse_small_c=0;
		if(hse_large==null || hse_large=='')hse_large=0;
		if(hse_great==null || hse_great=='')hse_great=0;
		if(hse_super==null || hse_super=='')hse_super=0;
		var hse_accident = '事故记录一般A级:'+hse_small_a+'次、一般B级:'+hse_small_b+'次、</br>一般C级:'+hse_small_c+'次、较大:'+hse_large+'次、重大:'+hse_great+'次、特大:'+hse_super+'次';
		var hse_accident_score = document.getElementById("hse_accident_score").value;
		submit += "&事故记录="+hse_accident_score;
		submit += "&安全管理="+(audit-(hse_check-(hse_safety_score))-(-hse_accident_score));
		var device_miss = document.getElementById("device_miss").value;
		var miss =0;
		if(device_miss!='' && device_miss<1){
			miss = 2;
		}else if(device_miss!='' && device_miss<=3 && device_miss>=1){
			miss = 3;
		}else if(device_miss!='' && device_miss>3){
			miss = 4;
		}
		submit += "&盘亏损失率="+miss;
		var device_bad = document.getElementById("device_bad").value;
		var bad =0;
		if(device_bad!='' && device_bad<5){
			bad = 1;
		}else if(device_bad!='' && device_bad<=8 && device_bad>=5){
			bad = 2;
		}else if(device_bad!='' && device_bad>8){
			bad = 3;
		}
		submit += "&毁损率="+bad;
		var divice_repair = document.getElementById("divice_repair").value;
		var repair =0;
		if(divice_repair!='' && divice_repair<100 && divice_repair >=97 ){
			repair = 1;
		}else if(divice_repair!='' && divice_repair< 97 && divice_repair >=95){
			repair = 2;
		}else if(divice_repair!='' && divice_repair< 95){
			repair = 3;
		}
		submit += "&完成率="+repair;
		submit += "&设备管理="+(miss-(-bad)-(-repair));
		var cost_actual = document.getElementById("cost_actual").value;
		var cost_target = document.getElementById("cost_target").value;
		var cost_ratio = document.getElementById("cost_ratio").value;
		var ratio = 0;
		if(Math.abs(cost_ratio)>3){
			ratio = Math.round((Math.abs(cost_ratio) - 3)*0.5*100)/100.00;
		}
		if(ratio>5){
			ratio = 5;
		}
		submit += "&符合率="+ratio;
		submit += "&成本控制="+ratio;
		var team_sys_major = document.getElementById("team_sys_major").value;
		var team_sys_major_score = document.getElementById("team_sys_major_score").value;
		var team_sys_normal = document.getElementById("team_sys_normal").value;
		var team_sys_normal_score = document.getElementById("team_sys_normal_score").value;
		var sys = team_sys_major_score-(-team_sys_normal_score);
		submit += "&制度执行="+sys;
		var team_data_major = document.getElementById("team_data_major").value;
		var team_data_major_score = document.getElementById("team_data_major_score").value;
		var team_data_normal = document.getElementById("team_data_normal").value;
		var team_data_normal_score = document.getElementById("team_data_normal_score").value;
		var team_data_basic = document.getElementById("team_data_basic").value;
		var data = team_data_major_score -(-team_data_normal_score)-(-team_data_basic*0.1);
		submit += "&基础工作="+data;
		var team_event_major = document.getElementById("team_event_major").value;
		var team_event_major_score = document.getElementById("team_event_major_score").value;
		var team_event_normal = document.getElementById("team_event_normal").value;
		var team_event_normal_score = document.getElementById("team_event_normal_score").value;
		var team_punish = document.getElementById("team_punish").value;
		var team_punish_score = document.getElementById("team_punish_score").value;
		var team_defect = document.getElementById("team_defect").value;
		var team_defect_score = document.getElementById("team_defect_score").value;
		var event = team_event_major_score -(-team_event_normal_score)-(-team_punish_score)-(-team_defect_score);
		submit += "&遵章守纪="+event;
		var team_issue = document.getElementById("team_issue").value;
		var issue = team_issue*0.5;
		submit += "&企地关系="+issue;
		submit += "&队伍建设="+(sys-(-data)-(-event)-(-issue));
		var user_name = '<%=user_name%>';
		var sql = "";
		if(evaluate_project_data!=null && evaluate_project_data!='' && evaluate_project_data!='null'){
			sql = "update bgp_pm_evaluate_project_data set contract_workload_accept='"+contract_workload_accept+"',contract_workload_demand='"+contract_workload_demand+"',"+
			"contract_end_actual=to_date('"+contract_end_actual+"','yyyy-MM-dd'),contract_end_plan=to_date('"+contract_end_plan+"','yyyy-MM-dd'),progress_plan_audit='"+progress_plan_audit+"',progress_target_sp='"+progress_target_sp+"',"+
			"progress_plan_change='"+progress_plan_change+"',progress_end_actual=to_date('"+progress_end_actual+"','yyyy-MM-dd'),progress_end_plan=to_date('"+progress_end_plan+"','yyyy-MM-dd'),progress_actual_sp='"+progress_actual_sp+"',"+
			"progress_plan_sp='"+progress_plan_sp+"',quality_actual_index='"+quality_actual_index+"',quality_demand_index='"+quality_demand_index+"',quality_accident='"+quality_accident+"',"+
			"quality_accident_score='"+quality_accident_score+"',quality_problem_num='"+quality_problem_num+"',quality_rewards='"+quality_rewards+"',quality_rewards_score='"+quality_rewards_score+"',"+
			"hse_audit_score='"+hse_audit_score+"',hse_start_check='"+hse_start_check+"',hse_process_safety='"+hse_process_safety+"',hse_safety_score='"+hse_safety_score+"',"+
			"hse_accident='"+hse_accident+"',hse_accident_score='"+hse_accident_score+"',device_miss='"+device_miss+"',device_bad='"+device_bad+"',divice_repair='"+divice_repair+"',"+
			"cost_actual='"+cost_actual+"',cost_target='"+cost_target+"',cost_ratio='"+cost_ratio+"',team_sys_major='"+team_sys_major+"',team_sys_major_score='"+team_sys_major_score+"',"+
			"team_sys_normal='"+team_sys_normal+"',team_sys_normal_score='"+team_sys_normal_score+"',team_data_major='"+team_data_major+"',team_data_major_score='"+team_data_major_score+"',"+
			"team_data_normal='"+team_data_normal+"',team_data_normal_score='"+team_data_normal_score+"',team_data_basic='"+team_data_basic+"',team_event_major='"+team_event_major+"',"+
			"team_event_major_score='"+team_event_major_score+"',team_event_normal='"+team_event_normal+"',team_event_normal_score='"+team_event_normal_score+"',team_punish='"+team_punish+"',"+
			"team_punish_score='"+team_punish_score+"',team_defect='"+team_defect+"',team_defect_score='"+team_defect_score+"',team_issue='"+team_issue+"' where evaluate_project_data='"+evaluate_project_data+"';"
		}else{
			sql = "insert into bgp_pm_evaluate_project_data(evaluate_project_data,contract_workload_accept,contract_workload_demand,contract_end_plan,contract_end_actual,"+
			"progress_plan_audit,progress_target_sp,progress_plan_change,progress_end_plan,progress_end_actual,progress_end_num,progress_plan_sp,progress_actual_sp,"+
			"quality_actual_index,quality_demand_index,quality_accident,quality_problem_num,quality_rewards,quality_rewards_score,hse_audit_score,hse_start_check,"+
			"hse_process_safety,hse_accident,device_miss,device_bad,divice_repair,cost_target,cost_actual,cost_ratio,team_sys_major,team_sys_major_score,team_sys_normal,"+
			"team_sys_normal_score,team_data_major,team_data_major_score,team_data_normal,team_data_normal_score,team_data_basic,team_event_major,team_event_major_score,"+
			"team_event_normal,team_event_normal_score,team_punish,team_punish_score,team_defect,team_defect_score,team_issue,creator,create_date,modifier,modifi_date,"+
			"bsflag,project_info_no,quality_accident_score,hse_accident_score,hse_safety_score) values((select lower(sys_guid()) from dual),"+
			"'"+contract_workload_accept+"','"+contract_workload_demand+"',to_date('"+contract_end_plan+"','yyyy-MM-dd'),to_date('"+contract_end_actual+"','yyyy-MM-dd'),"+
			"'"+progress_plan_audit+"','"+progress_target_sp+"','"+progress_plan_change+"',to_date('"+progress_end_plan+"','yyyy-MM-dd'),to_date('"+progress_end_actual+"','yyyy-MM-dd'),"+
			"(to_date('"+progress_end_actual+"','yyyy-MM-dd') - to_date('"+progress_end_plan+"','yyyy-MM-dd')),'"+progress_plan_sp+"',"+
			"'"+progress_actual_sp+"','"+quality_actual_index+"','"+quality_demand_index+"','"+quality_accident+"','"+quality_problem_num+"','"+quality_rewards+"',"+
			"'"+quality_rewards_score+"','"+hse_audit_score+"','"+hse_start_check+"','"+hse_process_safety+"','"+hse_accident+"','"+device_miss+"','"+device_bad+"','"+divice_repair+"',"+
			"'"+cost_target+"','"+cost_actual+"','"+cost_ratio+"','"+team_sys_major+"','"+team_sys_major_score+"','"+team_sys_normal+"','"+team_sys_normal_score+"',"+
			"'"+team_data_major+"','"+team_data_major_score+"','"+team_data_normal+"','"+team_data_normal_score+"','"+team_data_basic+"','"+team_event_major+"','"+team_event_major_score+"',"+
			"'"+team_event_normal+"','"+team_event_normal_score+"','"+team_punish+"','"+team_punish_score+"','"+team_defect+"','"+team_defect_score+"','"+team_issue+"','"+user_name+"',sysdate,"+
			"'"+user_name+"',sysdate,'0','<%=project_info_no%>','"+quality_accident_score+"','"+hse_accident_score+"','"+hse_safety_score+"');"
		}
		//retObj = jcdpCallService("ProjectEvaluationSrv", "saveEvaluateTemplate", submit);
		var retObj = jcdpCallService("ProjectEvaluationSrv", "saveDatasBySql", "sql="+sql);
		debugger;
		if(retObj!=null && retObj.returnCode=='0'){
			alert("保存成功!");
			retObj = jcdpCallService("ProjectEvaluationSrv", "saveEvaluateTemplate", submit);
			if(retObj==null || retObj.returnCode!='0'){
				sql = "delete from bgp_pm_evaluate_project t where t.project_info_no ='<%=project_info_no%>';"
				jcdpCallService("ProjectEvaluationSrv", "saveDatasBySql", "sql="+sql);
			}
			window.close();
		}else{
			alert("保存失败!");
		}
		
	}
	
	function selectOrgHR(select_type , select_id , select_name){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgHR.jsp?select='+select_type,teamInfo);
	    if(teamInfo.fkValue!=""){
	        document.getElementById(select_id).value = teamInfo.fkValue;
	        document.getElementById(select_name).value = teamInfo.value;
	    }
	}
	function checkValue(){
		var obj = document.getElementById("contract_workload_accept").value ;
		if(obj ==null || obj==''){
			alert("甲方认可工作量不能为空!");
			return false;
		}
		obj = document.getElementById("quality_problem_num").value ;
		if(obj ==null || obj==''){
			alert("甲方投诉质量问题(次)不能为空!");
			return false;
		}
		obj = document.getElementById("hse_audit_score").value ;
		if(obj ==null || obj==''){
			alert("体系审核成绩不能为空!");
			return false;
		}
		obj = document.getElementById("team_sys_major").value ;
		if(obj ==null || obj==''){
			alert("重要制度没执行(项)不能为空!");
			return false;
		}
		obj = document.getElementById("team_sys_normal").value ;
		if(obj ==null || obj==''){
			alert("一般制度没执行(项)不能为空!");
			return false;
		}
		obj = document.getElementById("team_data_major").value ;
		if(obj ==null || obj==''){
			alert("重要基础资料缺少(项)不能为空!");
			return false;
		}
		obj = document.getElementById("team_data_normal").value ;
		if(obj ==null || obj==''){
			alert("一般基础资料缺少(项)不能为空!");
			return false;
		}
		obj = document.getElementById("team_data_basic").value ;
		if(obj ==null || obj==''){
			alert("基础资料不规范(项)不能为空!");
			return false;
		}
		obj = document.getElementById("team_punish").value ;
		if(obj ==null || obj==''){
			alert("违纪违规受到处分(人次)不能为空!");
			return false;
		}
		obj = document.getElementById("team_defect").value ;
		if(obj ==null || obj==''){
			alert("工作效果有缺陷(项)不能为空!");
			return false;
		}
		obj = document.getElementById("team_issue").value ;
		if(obj ==null || obj==''){
			alert("与地方发生纠纷(起)不能为空!");
			return false;
		}
	}
</script>
</body>
</html>