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
	String projectType = user.getProjectType();
	String project_info_no = request.getParameter("project_info_no");
	String project_name = request.getParameter("project_name");
	if(project_info_no==null || project_info_no.trim().equals("")){
		project_info_no = user.getProjectInfoNo();
		project_name = user.getProjectName();
	}
	if(projectType.equals("5000100004000000006")){
		response.sendRedirect(contextPath+"/pm/projectEvaluation/sh_evaluation_project.jsp");
	}
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript">
var checked = false;
function doCheck(){
	if(checked){
		var chk = document.getElementsByName("chk_entity_id");
		var len = chk.length;
		for(var i =0;i<len;i++){
			chk[i].checked = false;
		}
		checked = false;
	}
	else{
		var chk = document.getElementsByName("chk_entity_id");
		var len = chk.length;
		for(var i =0;i<len;i++){
			chk[i].checked = true;
		}
		checked = true;
	}
}
</script>
<title>无标题文档</title>
</head>
<body style="background:#fff" >
<div id="list_table">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			    <td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						    <td class="" align="center"><font size="4"><%=project_name %>(总分:<strong><span id="total_score"></span></strong>)</font></td>
						    <td>&nbsp;</td>
						    <auth:ListButton functionId="F_PM_EVALUATION_EDIT" css="hz" event="onclick='toSetting()'" title="JCDP_btn_setting"></auth:ListButton>
						    <auth:ListButton functionId="F_PM_EVALUATION_EDIT" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
	  	<!-- <tr style="height: 40px;">
	      <td class="bt_info_even" exp="{spare1}" colspan="7" ></td>
	    </tr> -->
	    <tr >
	      <td class="bt_info_odd" exp="">考核项目</td> 
	      <td class="bt_info_even" exp="{name}">考核内容</td>
	      <td class="bt_info_odd" exp="{spare1}">标准分值</td>
	      <td class="bt_info_even" exp="{name}">评分标准</td>
	      <td class="bt_info_odd" exp="{spare1}">评分依据</td>
	      <td class="bt_info_even" exp="{name}">分数</td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;" rowspan="2">1、合同执行</td>
	    	<td style="border: black 1px solid;">1、工作量</td>
	    	<td style="border: black 1px solid;">3</td>
	    	<td style="border: black 1px solid;">1、	甲方认可的工作量达到合同要求得3分<br/>
	    	2、	未达到每低于2%扣0.2分,此项最多扣3分</td>
	    	<td style="border: black 1px solid;">甲方认可工作量:<strong><span id="contract_workload_accept"></span></strong><br/>合同要求工作量:<strong><span id="contract_workload_demand"></span></strong></td>
	    	<td style="border: black 1px solid;"><span id="score0"></span></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;">2、工期</td>
	    	<td style="border: black 1px solid;">7</td>
	    	<td style="border: black 1px solid;">1、合同要求的工期内完成得7分,超过不得分</td>
	    	<td style="border: black 1px solid;">实际项目结束时间:<strong><span id="contract_end_actual"></span></strong><br/>合同要求结束时间:<strong><span id="contract_end_plan"></span></strong></td>
	    	<td style="border: black 1px solid;"><span id="score1"></span></td>
	    </tr>
	     <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;" rowspan="3">2、生产进度</td>
	    	<td style="border: black 1px solid;">1、	进度计划</td>
	    	<td style="border: black 1px solid;">3</td>
	    	<td style="border: black 1px solid;">1、	计划没有按要求审批扣1分<br/>
				2、	没有下达目标日效扣1分,<br/>3、计划没有按甲方要求变更扣1分</td>
	    	<td style="border: black 1px solid;">1、计划<strong><span id="progress_plan_audit">已(未)</span></strong>审批<br/>
				2、<strong><span id="progress_target_sp">已(未)</span></strong>下达目标日效<br/>3、计划<strong><span id="progress_plan_change">(未)</span></strong>按甲方要求变更</td>
	    	<td style="border: black 1px solid;"><span id="score2"></span></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;">2、计划执行符合率</td>
	    	<td style="border: black 1px solid;">10</td>
	    	<td style="border: black 1px solid;">施工结束日期早于计划得20,超过(1-5)天每超一天扣0.4分,<br/>
	    		超过(6-10)天每超一天扣1分,<br/>超过11天的每超一天扣2分,最多扣20分</td>
	    	<td style="border: black 1px solid;">实际施工结束日期:<strong><span id="progress_end_actual"></span></strong><br/>计划施工结束日期:<strong><span id="progress_end_plan"></span></strong><br/>
				施工结束日期<strong><span id="progress_end"></span></strong>计划<strong><span id="progress_end_num"></span></strong>天</td>
	    	<td style="border: black 1px solid;"><span id="score3"></span></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;">3、提速目标</td>
	    	<td style="border: black 1px solid;">7</td>
	    	<td style="border: black 1px solid;">实际日效达到目标日效得7分,未达到不得分<br/></td>
	    	<td style="border: black 1px solid;">实际日效:<strong><span id="progress_actual_sp"></span></strong>计划日效:<strong><span id="progress_plan_sp"></span></strong></td>
	    	<td style="border: black 1px solid;"><span id="score4"></span></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;" rowspan="2">3、质量管理</td>
	    	<td style="border: black 1px solid;">1、质量指标完成情况</td>
	    	<td style="border: black 1px solid;">15</td>
	    	<td style="border: black 1px solid;">1、采集质量达到合同要求得15分,未达到不得分<br/>
	    		2、质量事故管理按事故等级在15分中扣除;<br/>甲方投诉的质量问题一次扣5分,此项最多扣15分</td>
	    	<td style="border: black 1px solid;">1、<strong><span id="quality_actual_index"></span></strong><br/>
	    		<strong><span id="quality_demand_index"></span></strong><br/>
	    		2、<strong><span id="quality_accident"></span></strong><br/>
	    		甲方投诉质量问题:<strong><span id="quality_problem_num"></span></strong>次 </td>
	    	<td style="border: black 1px solid;"><span id="score5"></span></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;">2、甲方优质工程评价(奖励项)</td>
	    	<td style="border: black 1px solid;">0</td>
	    	<td style="border: black 1px solid;">获得甲方优质工程评价的为奖励项</td>
	    	<td style="border: black 1px solid;"><strong><span id="quality_rewards"></span></strong>获得甲方优质工程评价</td>
	    	<td style="border: black 1px solid;"><span id="score6"></span></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;" rowspan="3">4、安全管理</td>
	    	<td style="border: black 1px solid;">1.体系审核成绩</td>
	    	<td style="border: black 1px solid;">10</td>
	    	<td style="border: black 1px solid;">1、	项目启动中后期公司安全处组织<br/>体系审核组现场审核审核成绩占10分</td>
	    	<td style="border: black 1px solid;">1、体系审核成绩:<strong><span id="hse_audit_score"></span></strong></td>
	    	<td style="border: black 1px solid;"><span id="score7"></span></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;">2.驻队监督出工验收<br/>和过程安全管理</td>
	    	<td style="border: black 1px solid;">5</td>
	    	<td style="border: black 1px solid;">2、	驻队监督项目开工验收占2分,<br/>项目过程安全管理占3分。</td>
	    	<td style="border: black 1px solid;">2、主队监督项目开工验收:<strong><span id="hse_start_check">合格(不合格)</span></strong><br/>
	    		项目过程安全管理:<strong><span id="hse_process_safety">(优良中差) </span></strong></td>
	    	<td style="border: black 1px solid;"><span id="score8"></span></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;">3、事故管理</td>
	    	<td style="border: black 1px solid;">0</td>
	    	<td style="border: black 1px solid;">3、	事故管理按事故等级在15分中扣除,<br/>达到一定等级的按责任书规定内容执行考核。</td>
	    	<td style="border: black 1px solid;"><strong><span id="hse_accident"></span></strong></td>
	    	<td style="border: black 1px solid;"><span id="score9"></span></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;" rowspan="3">5、设备管理</td>
	    	<td style="border: black 1px solid;">1、采集设备盘亏损失率</td>
	    	<td style="border: black 1px solid;">4</td>
	    	<td style="border: black 1px solid;">1、	1%以下,扣2分;1%-3%,扣3分;3%以上扣4分</td>
	    	<td style="border: black 1px solid;">1、采集设备盘亏损失率%(道):<strong><span id="device_miss"></span></strong></td>
	    	<td style="border: black 1px solid;"><span id="score10"></span></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;">2、采集设备毁损率</td>
	    	<td style="border: black 1px solid;">3</td>
	    	<td style="border: black 1px solid;">2、	5‰以下,扣1分;5‰-8‰,扣2分;8‰以上扣3分</td>
	    	<td style="border: black 1px solid;">2、采集设备毁损率%(道):<strong><span id="device_bad"></span></strong></td>
	    	<td style="border: black 1px solid;"><span id="score11"></span></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;">3、设备维修保养完成率</td>
	    	<td style="border: black 1px solid;">3</td>
	    	<td style="border: black 1px solid;">3、100%-97%的扣1分,97%-95%的扣2分,95%的扣3分</td>
	    	<td style="border: black 1px solid;">3、设备维修保养完成率%(台):<strong><span id="divice_repair"></span></strong></td>
	    	<td style="border: black 1px solid;"><span id="score12"></span></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;">6、成本控制</td>
	    	<td style="border: black 1px solid;">1、目标成本符合率</td>
	    	<td style="border: black 1px solid;">20</td>
	    	<td style="border: black 1px solid;">±3%内,得满分;超出此区间,<br/>每超1%扣0.5分,最多扣5分</td>
	    	<td style="border: black 1px solid;">实际成本:<strong><span id="cost_actual"></span></strong>目标成本:<strong><span id="cost_target"></span></strong><br/>目标成本符合率差额:<strong><span id="cost_ratio"></span></strong></td>
	    	<td style="border: black 1px solid;"><span id="score13"></span></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;" rowspan="4">7、队伍建设</td>
	    	<td style="border: black 1px solid;">1、上级各项制度执行情况</td>
	    	<td style="border: black 1px solid;" rowspan="4">10</td>
	    	<td style="border: black 1px solid;">1、	重要制度没执行一项扣1-2分<br/>2、	一般制度没执行一项扣0.2-0.5分</td>
	    	<td style="border: black 1px solid;">1、重要制度没执行<strong><span id="team_sys_major"></span></strong>项<br/>2、一般制度没执行<strong><span id="team_sys_normal"></span></strong>项</td>
	    	<td style="border: black 1px solid;"><span id="score14"></span></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;">2、队伍建设基础工作</td>
	    	<!-- <td style="border: black 1px solid;">3</td> -->
	    	<td style="border: black 1px solid;">1、	重要基础资料缺少一项次扣1-2分<br/>2、	一般基础资料缺少一项次扣0.2-0.5分<br/>3、	基础资料不规范一项次扣0.1分</td>
	    	<td style="border: black 1px solid;">1、	重要基础资料缺少<strong><span id="team_data_major"></span></strong>项次<br/>2、一般基础资料缺少<strong><span id="team_data_normal"></span></strong>项次<br/>
	    		3、基础资料不规范<strong><span id="team_data_basic"></span></strong>项次 </td>
	    	<td style="border: black 1px solid;"><span id="score15"></span></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;">3、职工队伍工作作风<br/>和遵章守纪情况</td>
	    	<!-- <td style="border: black 1px solid;">4</td> -->
	    	<td style="border: black 1px solid;">1、	发生重大群体事件影响恶劣的扣2-5分<br/>2、	发生群体事件扣1-2分<br/>3、	违纪违规受到处分的扣0.5-1分/人次<br/>4、	工作效果有缺陷的扣0.5-1分/每项工作</td>
	    	<td style="border: black 1px solid;">1、	<strong><span id="team_event_major">(未)</span></strong>发生重大群体事件<br/>2、<strong><span id="team_event_normal">(未)</span></strong>发生群体事件<br/>
	    		3、违纪违规受到处分:<strong><span id="team_punish"></span></strong>人次<br/>4、工作效果有缺陷:<strong><span id="team_defect"></span></strong>项</td>
	    	<td style="border: black 1px solid;"><span id="score16"></span></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;">4、企地关系</td>
	    	<!-- <td style="border: black 1px solid;">1</td> -->
	    	<td style="border: black 1px solid;">与地方发生纠纷给公司造成<br/>影响的,每一起扣0.5分</td>
	    	<td style="border: black 1px solid;">与地方发生纠纷给公司造成影响:<strong><span id="team_issue"></span></strong>起</td>
	    	<td style="border: black 1px solid;"><span id="score17"></span></td>
	    </tr>
	  </table>
	</div>
  </div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "QualityItemsSrv";
	cruConfig.queryOp = "toQualityCodes";
	$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-8);
	function refreshData(){
		var project_info_no = '<%=project_info_no%>';
		var sql = "select t.evaluate_project_data ,t.contract_workload_accept ,t.contract_workload_demand ,t.contract_end_plan,t.contract_end_actual, "+
		" decode(t.progress_plan_audit,'0','未','已') progress_plan_audit,decode(t.progress_target_sp,'0','未','已') progress_target_sp,"+
		" decode(t.progress_plan_change,'0','未','已') progress_plan_change,t.progress_end_plan ,t.progress_end_actual ,abs(t.progress_end_num) progress_end_num,"+
		" case when t.progress_end_num >0 then '晚于' when t.progress_end_num <0 then '早于' else '' end progress_end, "+
		" t.progress_plan_sp,t.progress_actual_sp,t.quality_problem_num,decode(t.quality_rewards,'0','未','已')quality_rewards,t.quality_accident_score, "+
		" t.hse_audit_score,decode(t.hse_start_check,'0','不合格','合格') hse_start_check,case t.hse_process_safety when '0' then '优' when '1' then '良' when '2' then '中' else '差' end hse_process_safety,"+
		" t.hse_safety_score,t.hse_accident,t.device_miss ,t.device_bad ,t.divice_repair, t.quality_actual_index ,t.quality_demand_index ,t.quality_accident,"+
		" t.cost_target ,t.cost_actual ,t.cost_ratio,t.team_sys_major,t.team_sys_major_score ,t.team_sys_normal,t.team_sys_normal_score, "+
		" t.team_data_major,t.team_data_major_score,t.team_data_normal,t.team_data_normal_score,t.team_data_basic,t.team_data_basic_score, "+ 
		" decode(t.team_event_major,'0','','未') team_event_major,decode(t.team_event_normal,'0','','未') team_event_normal,t.team_punish,t.team_punish_score, "+
		" t.team_defect,t.team_defect_score,t.team_issue "+
		" from bgp_pm_evaluate_project_data t where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"'";
		var retObj = syncRequest('post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
		if(retObj!=null&& retObj.returnCode =='0' && retObj.datas.length>0){
			if(retObj.datas[0]!=null){
				var map = retObj.datas[0];
				with(map){
					document.getElementById("contract_workload_accept").innerHTML = contract_workload_accept;
					document.getElementById("contract_workload_demand").innerHTML = contract_workload_demand;
					document.getElementById("contract_end_plan").innerHTML = contract_end_plan;
					document.getElementById("contract_end_actual").innerHTML = contract_end_actual;
					document.getElementById("progress_plan_audit").innerHTML= progress_plan_audit;
					document.getElementById("progress_target_sp").innerHTML= progress_target_sp;
					document.getElementById("progress_plan_change").innerHTML= progress_plan_change;
					document.getElementById("progress_end_plan").innerHTML = progress_end_plan;
					document.getElementById("progress_end_actual").innerHTML = progress_end_actual;
					document.getElementById("progress_end").innerHTML = progress_end;
					document.getElementById("progress_end_num").innerHTML = progress_end_num;
					document.getElementById("progress_plan_sp").innerHTML = progress_plan_sp;
					document.getElementById("progress_actual_sp").innerHTML = progress_actual_sp;
					document.getElementById("quality_actual_index").innerHTML = quality_actual_index;
					document.getElementById("quality_demand_index").innerHTML = quality_demand_index;
					document.getElementById("quality_accident").innerHTML = quality_accident;
					document.getElementById("quality_problem_num").innerHTML = quality_problem_num;
					document.getElementById("quality_rewards").innerHTML = quality_rewards;
					document.getElementById("hse_audit_score").innerHTML = hse_audit_score;
					document.getElementById("hse_start_check").innerHTML= hse_start_check;
					document.getElementById("hse_process_safety").innerHTML= hse_process_safety;
					document.getElementById("hse_accident").innerHTML= hse_accident;
					document.getElementById("device_miss").innerHTML = device_miss;
					document.getElementById("device_bad").innerHTML = device_bad;
					document.getElementById("divice_repair").innerHTML = divice_repair;
					document.getElementById("cost_target").innerHTML = cost_target;
					document.getElementById("cost_actual").innerHTML = cost_actual;
					document.getElementById("cost_ratio").innerHTML = cost_ratio;
					document.getElementById("team_sys_major").innerHTML = team_sys_major;
					document.getElementById("team_sys_normal").innerHTML = team_sys_normal;
					document.getElementById("team_data_major").innerHTML = team_data_major;
					document.getElementById("team_data_normal").innerHTML = team_data_normal;
					document.getElementById("team_data_basic").innerHTML = team_data_basic;
					document.getElementById("team_event_major").innerHTML= team_event_major;
					document.getElementById("team_event_normal").innerHTML= team_event_normal;
					document.getElementById("team_punish").innerHTML = team_punish;
					document.getElementById("team_defect").innerHTML = team_defect;
					document.getElementById("team_issue").innerHTML = team_issue;
				}
				sql = "select (t.evaluate_weight-t.evaluate_score) score from bgp_pm_evaluate_project t where t.bsflag ='0' and t.is_leaf ='1' and t.project_info_no ='"+project_info_no+"' order by t.ordering";
				retObj = syncRequest('post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql))+'&pageSize=100');
				if(retObj!=null&& retObj.returnCode =='0' && retObj.datas.length>0){
					if(retObj.datas!=null){
						for(var i =0;retObj.datas[i]!=null && i<retObj.datas.length;i++){
							map = retObj.datas[i];
							if(map!=null && map.score!=null){
								document.getElementById("score"+i).innerHTML = map.score;
							}
						}
					}
				}
				sql = "select sum((t.evaluate_weight-t.evaluate_score)) score from bgp_pm_evaluate_project t where t.bsflag ='0' and t.parent_id='ROOT' and t.project_info_no ='"+project_info_no+"'";
				retObj = syncRequest('post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
				if(retObj!=null&& retObj.returnCode =='0' && retObj.datas.length>0){
					if(retObj.datas!=null && retObj.datas[0]!=null){
						map = retObj.datas[0];
						document.getElementById("total_score").innerHTML = map.score;
					}
				}
			}
		}else{
			document.getElementById("total_score").innerHTML ='未评分';
			document.getElementById("quality_actual_index").innerHTML ='实际合格品率:、一级品率:、空炮率:、废炮率:';
			document.getElementById("quality_demand_index").innerHTML ='合同要求合格品率:、一级品率:、空炮率:、废炮率:';
			document.getElementById("quality_accident").innerHTML ='质量事故一般:次、较大:次、重大:次、特大:次';
			document.getElementById("hse_accident").innerHTML ='事故记录一般A级:次、一般B级:次、</br>一般C级:次、较大:次、重大:次、特大:次';
		}
	}
	refreshData();
	var obj = {};
	function toSetting(){
		//popWindow("<%=contextPath%>/pm/projectEvaluation/evaluation_setting.jsp","1000:680");
		var project_name = '<%=project_name%>';
		project_name = encodeURI(project_name);
		window.showModalDialog("<%=contextPath%>/pm/projectEvaluation/evaluation_setting.jsp?project_info_no=<%=project_info_no%>&project_name="+project_name,obj,"dialogWidth:1200px;dialogHeight:720px;");
		refreshData();
	}
	function toSubmit(){
		var project_info_no = '<%=project_info_no%>';
		var sql = "update bgp_pm_evaluate_project t set t.submit_flag='1' where t.project_info_no ='"+project_info_no+"';";
		retObj = jcdpCallService("ProjectEvaluationSrv", "saveDatasBySql", "sql="+sql);
		if(retObj!=null&& retObj.returnCode =='0'){
			alert("数据提交成功,项目已加入排名");
		}
	}
</script>
</body>
</html>

