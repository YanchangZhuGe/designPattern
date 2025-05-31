<%@page import="com.bgp.mcs.service.pm.service.project.WorkMethodSrv"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page  import="java.util.*" %>
<%@ taglib uri="code" prefix="code"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String daily_no = request.getParameter("daily_no");
	
	String project_info_no = request.getParameter("project_info_no");
	String project_name = request.getParameter("project_name");
	String exploration_method = "";
	if(project_info_no == null || "".equals(project_info_no)){
		project_info_no = user.getProjectInfoNo();
		exploration_method = user.getExplorationMethod();
		project_name = user.getProjectName();
	}
	if(project_name == null || "".equals(project_name)){
		project_name = user.getProjectName();
	}
	if(exploration_method == null || "".equals(exploration_method)){
		exploration_method = user.getExplorationMethod();
	}
	String workload_type = "km²";
	String resource_id = "G";
	if(exploration_method!=null && exploration_method.trim().equals("0300100012000000002")){
		resource_id = "G0";
		workload_type = "km";
	}
	String produce_date = request.getParameter("produce_date");
	
	if(produce_date == null){
		produce_date = "null";
	}
	
	WorkMethodSrv srv = new WorkMethodSrv();
	String build_method = srv.getProjectExcitationMode(project_info_no);
	List<Map> list = srv.getDailyInformation(project_info_no,produce_date,resource_id);//获取日报线束（测线）完成详情
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/qua/sProject/summary/summary.js"></script>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
</head>


<script type="text/javascript">

cruConfig.contextPath = "<%=contextPath%>";
cruConfig.cdtType = 'form';
var work_load = "1-design_execution_area,2-design_data_area,3-design_object_area,";
function page_init(){
	var exploration_method ='<%=exploration_method%>';
	var method = "design_execution_area,design_data_area,design_object_area";
	if(exploration_method!=null && exploration_method =='0300100012000000002'){//二维的设计工作量是长度，三维的设计工作量是面积
		method = "design_physical_workload,design_data_workload,design_object_workload";
		work_load = "1-design_physical_workload,2-design_data_workload,3-design_object_workload,";
	}
	var produce_date = document.getElementById("produce_date").value;
	var daily_no = '<%=daily_no %>';
	var project_info_no = '<%=project_info_no %>';
	var columns ="if_build,weather,team_name,design_sp_num,"+method+",work_load,daily_qq_acquire_shot_num,"+
	"daily_jp_acquire_shot_num,daily_acquire_sp_num,total_shot_num,daily_qq_acquire_workload,daily_jp_acquire_workload,daily_acquire_workload,"+
	"total_workload,workload_radio,path,line_lay,array_check,day_check,first_delay,last_delay,actual_shot,weather_delay,tide_delay,"+
	"machine_delay,focus_delay,measure_delay,array_trouble,clearup_delay,transit_delay,air_gun_use_time,relation_delay,hse_delay,operation_explain,"+
	"audit_status";
	var if_build = "1_动迁,2_踏勘,3_基地建设,4_培训,5_试验,6_测量,7_钻井,8_采集,9_停工,10_暂停（人员设备撤离）,11_结束";//项目状态
	var weather = "1_晴,2_阴,3_多云,4_雨,5_雾,17_大风,6_霾,7_霜冻,8_暴风,9_台风,10_暴风雪,11_雪,12_雨夹雪,13_冰雹,14_浮尘,15_扬沙,16_其它";//天气
	var audit_status = "0_日报还没有提交!,1_日报已经提交，等待审批中!,3_日报已经审批通过!,4_日报审批未通过!";//审批信息
	
	//gp_ops_daily_report、bgp_ops_ss_daily_efficiency、gp_ops_daily_produce_sit连接获得的字段
	var querySql = "select i.org_abbreviation team_name ,s.if_build,s.weather,d.design_sp_num,d.design_execution_area,d.design_data_area,"+
	" d.design_object_area,d.work_load2,d.work_load3,d.design_physical_workload,d.design_data_workload,d.design_object_workload,"+
	" t.daily_qq_acquire_shot_num,t.daily_jp_acquire_shot_num,t.daily_acquire_sp_num,"+
	" (nvl(t.daily_qq_acquire_shot_num,0)-(-nvl(t.daily_jp_acquire_shot_num,0))-(nvl(t.daily_acquire_sp_num,0)))total_shot_num,"+
	" t.daily_qq_acquire_workload,t.daily_jp_acquire_workload,t.daily_acquire_workload ,case when design_data_area = 0 then 0 else "+
	" round((nvl(t.daily_qq_acquire_workload,0)-(-nvl(t.daily_jp_acquire_workload,0))-(nvl(t.daily_acquire_workload,0)))/design_data_area*10000)/100.0 end workload_radio,"+
	" (nvl(t.daily_qq_acquire_workload,0)-(-nvl(t.daily_jp_acquire_workload,0))-(nvl(t.daily_acquire_workload,0)))total_workload,"+
	" e.path,e.line_lay,e.array_check,e.day_check,e.first_delay,e.last_delay,e.actual_shot,e.weather_delay,e.tide_delay,"+
	" e.machine_delay,e.focus_delay,e.measure_delay,e.array_trouble,e.clearup_delay,e.transit_delay,e.air_gun_use_time,e.relation_delay,"+
	" e.hse_delay,t.operation_explain,t.audit_status from gp_ops_daily_report t "+
	" left join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag ='0'"+
	" left join gp_task_project_dynamic d on t.project_info_no = d.project_info_no and d.bsflag ='0'"+
	" left join comm_org_information i on t.org_id = i.org_id and i.bsflag ='0' left join bgp_ops_ss_daily_efficiency e on t.daily_no = e.daily_no "+
	" left join gp_ops_daily_produce_sit s on t.daily_no = s.daily_no and s.bsflag ='0'"+
	" where t.bsflag ='0' and t.project_info_no ='<%=project_info_no%>' and t.produce_date = to_date('"+produce_date+"','yyyy-MM-dd')";
	var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
	if(retObj!=null && retObj.returnCode =='0' && retObj.datas!=null && retObj.datas[0]!=0){
		var column = columns.split(",");
		for(var i in column){
			if(column[i]=='if_build'){//项目状态
				document.getElementById('if_build_value').value = retObj.datas[0][column[i]];
				if(retObj.datas[0][column[i]]=='1'){//避免“动迁”和“暂停（人员设备撤离）”,“结束”可能造成的冲突
					document.getElementById(column[i]).innerHTML = '动迁';
				}else{
					var index = if_build.indexOf(retObj.datas[0][column[i]]);
					if_build = if_build.substring(index-(-2));
					index = if_build.indexOf(",");
					if_build = if_build.substring(index,0);
					document.getElementById(column[i]).innerHTML = if_build;
				}
			}else if(column[i]=='weather'){//天气
				if(retObj.datas[0][column[i]]=='1'){//避免“晴”和“暴风雪”,“雪”等可能造成的冲突
					document.getElementById(column[i]).innerHTML = '晴';
				}else{
					var index = weather.indexOf(retObj.datas[0][column[i]]);
					weather = weather.substring(index-(-2));
					index = weather.indexOf(",");
					weather = weather.substring(index,0);
					document.getElementById(column[i]).innerHTML = weather;
				}
			}else if(column[i]=='audit_status'){//审批
				var index = audit_status.indexOf(retObj.datas[0][column[i]]);
				audit_status = audit_status.substring(index-(-2));
				index = audit_status.indexOf(",");
				audit_status = audit_status.substring(index,0);
				document.getElementById(column[i]).innerHTML = audit_status;
				if(retObj.datas[0][column[i]]=='1'){//待审批和审批通过则屏蔽提交按钮
					document.getElementById("tj").style.display="inline";
					document.getElementById("gb").style.display="inline";
					document.getElementById("cx_btn").colSpan = "1";
				}if(retObj.datas[0][column[i]]=='3'){//待审批和审批通过则屏蔽提交按钮
					//document.getElementById("gb").style.display="inline";
				}
			}else if(column[i]=='work_load'){//工作量，项目立项时选中的工作量置为红色
				var workload = retObj.datas[0].work_load3;
				if(exploration_method!=null && exploration_method =='0300100012000000002'){
					workload = retObj.datas[0].work_load2;
				}
				workload = workload ==null || workload=='' ? '1':workload;
				document.getElementById("method"+workload).style.color = 'red';
				document.getElementById("workload").value = workload;
			}else{
				document.getElementById(column[i]).innerHTML = retObj.datas[0][column[i]];
			}
		}
	}
	
	var retAuditMap = jcdpCallService("DailyReportSrv", "getAuditInfo", "dailyNo=<%=daily_no%>");
	document.getElementById("employee_name").innerHTML= retAuditMap.auditMap.employeeName;
	document.getElementById("audit_opinion").value= retAuditMap.auditMap.auditOpinion;
	
	otherInformation(daily_no,project_info_no,produce_date);//其他工作量完成情况
	sumInformation(project_info_no,produce_date);//累计工作量和炮数
	stopInformation(project_info_no,produce_date);//累计停工时间
}
function audit(audit_status){
	var form = document.getElementById("form1");
	var projectInfoNo = '<%=project_info_no %>';
	var produceDate = document.getElementById("produce_date").value;
	var if_build = document.getElementById("if_build_value").value
	var audit_opinion = document.getElementById("audit_opinion").value;
	var retObj = jcdpCallService("DailyReportSrv", "auditDailyReport", "dailyNo=<%=daily_no %>&projectInfoNo=<%=project_info_no %>&produceDate="+produceDate+"&audit_status="+audit_status+"&if_build="+if_build+"&audit_opinion="+audit_opinion);
	opener.refreshData();
	window.close()
}

function toQueryQuestion(){
	var produce_date = document.getElementById("produce_date").value;
	popWindow("<%=contextPath%>/pm/dailyReport/singleProject/dailyQuestionList.jsp?projectInfoNo=<%=project_info_no %>&produce_date="+produce_date);
}
function refrashDate(){
	var produce_date = document.getElementById("produce_date").value;
	window.location.href='<%=contextPath%>/pm/dailyReport/singleProject/viewDailyReportSea.jsp?daily_no=<%=daily_no %>&produce_date='+produce_date;
}
</script>
<body onload="page_init()" style="overflow-y:scroll; ">
		<div id="tab_box" class="tab_box" >
			<div id="tab_box_content0" class="tab_box_content" style="overflow: hidden;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr style="background-color: #97cbfd">
						<td class="inquire_item8">生产日期：</td>	
						<td class="inquire_form8">
							<input type="hidden" name="daily_no" id="daily_no"/>
							<input type="hidden" name="if_build_value" id="if_build_value"/>
							<input type="text" name="produce_date" id="produce_date" value="<%=produce_date %>" disabled="disabled" onchange="refrashDate();"/>&nbsp;&nbsp;
							<img width="16" height="16" id="cal_button1" style="cursor: hand;" onmouseover="calDateSelector(produce_date,cal_button1);" src="<%=contextPath %>/images/calendar.gif" />
							<font color="red" style="text-align: right;" id="audit_status">审批通过</font>
						</td>
						<auth:ListButton tdid="cx_btn" functionId="" css="cx" event="onclick='refrashDate()'" title="JCDP_btn_query"></auth:ListButton>
						<auth:ListButton tdid="tj" display="none" functionId="" css="tj" event="onclick='audit(3)'" title="通过"></auth:ListButton>
		    			<auth:ListButton tdid="gb" display="none" functionId="" css="gb" event="onclick='audit(4)'" title="不通过"></auth:ListButton>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info"  id="audit">
					<tr style="background-color: #97cbfd">
					 	<td align="center">审批人</td>
					 	<td colspan="5" id="employee_name">&nbsp;</td>
					 </tr>
					 <tr class="odd">
					 	<td >审批意见</td>
					 	<td colspan="5">
					 		<textarea rows="4" style="width:100%;" id="audit_opinion"  name="audit_opinion"></textarea>
					 	</td>
					 </tr>
				 </table>
				 <input type="hidden" id="workload" name="workload" value=""/>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr style="background-color: #97cbfd">
						<td align="left" colspan="8">&nbsp;&nbsp;&nbsp;项目名称:&nbsp;<%=project_name %></td>
					</tr>
					<tr class="even">
						<td class="inquire_item8">项目状态：</td>
						<td class="inquire_form8" id="if_build"></td>
						<td class="inquire_item8">天气：</td>
						<td class="inquire_form8" id="weather"></td>
						<td class="inquire_item8">生产日期：</td>
						<td class="inquire_form8" ><%=produce_date %></td>
						<td class="inquire_item8">施工队伍：</td>
						<td class="inquire_form8" id="team_name"></td>
					</tr>
					<%if(exploration_method!=null && exploration_method.trim().equals("0300100012000000003")){ %>
					<tr class="odd">
						<td class="inquire_item8">设计总炮数：</td>
						<td class="inquire_form8" id="design_sp_num"></td>
						<td class="inquire_item8" id="method1">设计施工面积：</td>
						<td class="inquire_form8" ><font id="design_execution_area"></font> <%=workload_type %></td>
						<td class="inquire_item8" id="method2">设计有资料面积：</td>
						<td class="inquire_form8" ><font id="design_data_area"></font> <%=workload_type %></td>
						<td class="inquire_item8" id="method3">设计满覆盖面积：</td>
						<td class="inquire_form8" ><font id="design_object_area"></font> <%=workload_type %></td>
					</tr>
					<%}else{ %>
					<tr class="odd">
						<td class="inquire_item8">设计总炮数：</td>
						<td class="inquire_form8" id="design_sp_num"></td>
						<td class="inquire_item8" id="method1" >设计实物长度：</td>
						<td class="inquire_form8" ><font id="design_physical_workload"></font> <%=workload_type %></td>
						<td class="inquire_item8" id="method2">设计有资料长度：</td>
						<td class="inquire_form8" ><font id="design_data_workload"></font> <%=workload_type %></td>
						<td class="inquire_item8" id="method3">设计满覆盖长度：</td>
						<td class="inquire_form8" ><font id="design_object_workload"></font> <%=workload_type %></td>
					</tr>
					<%} %>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr style="background-color: #97cbfd">
						<td align="left" colspan="8">&nbsp;&nbsp;&nbsp;日生产信息</td>
					</tr>
					<tr class="even">
						<td class="inquire_item8">日完成气枪：</td>
						<td class="inquire_form8" id="daily_qq_acquire_shot_num"></td>
						<td class="inquire_item8">日完成井炮：</td>
						<td class="inquire_form8" id="daily_jp_acquire_shot_num"></td>
						<td class="inquire_item8">日完成震源：</td>
						<td class="inquire_form8" id="daily_acquire_sp_num"></td>
						<td class="inquire_item8">日完成总炮数：</td>
						<td class="inquire_form8" id="total_shot_num"></td>
					</tr>
					<tr class="odd">
						<td class="inquire_item8">日完成气枪工作量：</td>
						<td class="inquire_form8"><font id="daily_qq_acquire_workload"></font> <%=workload_type %></td>
						<td class="inquire_item8">日完成井炮工作量：</td>
						<td class="inquire_form8"><font id="daily_jp_acquire_workload"></font> <%=workload_type %></td>
						<td class="inquire_item8">日完成震源工作量：</td>
						<td class="inquire_form8"><font id="daily_acquire_workload"></font> <%=workload_type %></td>
						<td class="inquire_item8">日完成工作量：</td>
						<td class="inquire_form8"><font id="total_workload"></font> <%=workload_type %></td>
					</tr>
					<tr class="even">
						<td class="inquire_item8"></td>
						<td class="inquire_form8"></td>
						<td class="inquire_item8"></td>
						<td class="inquire_form8"></td>
						<td class="inquire_item8"></td>
						<td class="inquire_form8"></td>
						<td class="inquire_item8">日完成进度：</td>
						<td class="inquire_form8"><font id="workload_radio"></font>%</td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr style="background-color: #97cbfd">
						<td align="left" colspan="5">&nbsp;&nbsp;&nbsp;线束（测线）完成详情</td>
					</tr>
					<tr class="even">
						<td align="center" width="20%">线束（测线）号</td>
						<td align="center" width="20%">起止桩号</td>
						<td align="center" width="20%">气枪炮点数</td>
						<td align="center" width="20%">井炮炮点数</td>
						<td align="center" width="20%">震源炮点数</td>
					</tr>
					<%if(list ==null) list = new ArrayList();
					int i =1 ;
					for(Map map : list){
						String c = "odd";
						if(i%2 ==0){
							c = "even";
						}
						%>
					<tr class="<%=c%>">
						<td align="center" width="20%"><%=(String)map.get("line_num") %></td>
						<td align="center" width="20%"><%=(String)map.get("start_end") %></td>
						<td align="center" width="20%"><%=(String)map.get("qq_shot_num") %></td>
						<td align="center" width="20%"><%=(String)map.get("jp_shot_num") %></td>
						<td align="center" width="20%"><%=(String)map.get("zy_shot_num") %></td>
					</tr>
					<%i++;} %>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="border-bottom: solid 1px;">
					<tr style="background-color: #97cbfd">
						<td align="left" colspan="4">&nbsp;&nbsp;&nbsp;<a onclick="showInformation()">其他工作量完成情况</a></td>
					</tr>
				</table>
				<div id="other_information" style="display: none;border: solid 1px;" >
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr style="background-color: #97cbfd">
							<td align="left" colspan="8">&nbsp;&nbsp;&nbsp;试验工作</td>
						</tr>
						<tr class="even">
							<td class="inquire_item8">设计试验炮：</td>
							<td class="inquire_form8" id="plan_g1001"></td>
							<td class="inquire_item8">日完成试验炮：</td>
							<td class="inquire_form8" id="actual_g1001"></td>
							<td class="inquire_item8">累计完成试验炮：</td>
							<td class="inquire_form8" id="total_g1001"></td>
							<td class="inquire_item8"></td>
							<td class="inquire_form8"></td>
						</tr>
						<tr class="odd">
							<td class="inquire_item8">设计定位炮：</td>
							<td class="inquire_form8" id="plan_g9000"></td>
							<td class="inquire_item8">日完成定位炮：</td>
							<td class="inquire_form8" id="actual_g9000"></td>
							<td class="inquire_item8">累计完成定位炮：</td>
							<td class="inquire_form8" id="total_g9000"></td>
							<td class="inquire_item8"></td>
							<td class="inquire_form8"></td>
						</tr>
					</table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr style="background-color: #97cbfd">
							<td align="left" colspan="8">&nbsp;&nbsp;&nbsp;表层调查</td>
						</tr>
						<tr class="even">
							<td class="inquire_item8">设计微测井点数：</td>
							<td class="inquire_form8" id="plan_g4001"></td>
							<td class="inquire_item8">日完成微测井数：</td>
							<td class="inquire_form8" id="actual_g4001"></td>
							<td class="inquire_item8">累计完成微测井：</td>
							<td class="inquire_form8" id="total_g4001"></td>
							<td class="inquire_item8"></td>
							<td class="inquire_form8"></td>
						</tr>
						<tr class="odd">
							<td class="inquire_item8">设计小折射点数：</td>
							<td class="inquire_form8" id="plan_g4002"></td>
							<td class="inquire_item8">日完成小折射数：</td>
							<td class="inquire_form8" id="actual_g4002"></td>
							<td class="inquire_item8">累计完成小折射：</td>
							<td class="inquire_form8" id="total_g4002"></td>
							<td class="inquire_item8"></td>
							<td class="inquire_form8"></td>
						</tr>
					</table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr style="background-color: #97cbfd">
							<td align="left" colspan="8">&nbsp;&nbsp;&nbsp;测量工作</td>
						</tr>
						<tr class="even">
							<td class="inquire_item8">设计炮点数：</td>
							<td class="inquire_form8" id="plan_g2001"></td>
							<td class="inquire_item8">日完成炮点数：</td>
							<td class="inquire_form8" id="actual_g2001"></td>
							<td class="inquire_item8">累计完成炮点数：</td>
							<td class="inquire_form8" id="total_g2001"></td>
							<td class="inquire_item8">完成进度：</td>
							<td class="inquire_form8"><font id="radio_g2001"></font>%</td>
						</tr>
						<tr class="odd">
							<td class="inquire_item8">设计检波点数：</td>
							<td class="inquire_form8" id="plan_g2002"></td>
							<td class="inquire_item8">日完成检波点数：</td>
							<td class="inquire_form8" id="actual_g2002"></td>
							<td class="inquire_item8">累计完成检波点数：</td>
							<td class="inquire_form8" id="total_g2002"></td>
							<td class="inquire_item8">完成进度：</td>
							<td class="inquire_form8"><font id="radio_g2002"></font>%</td>
						</tr>
						<tr class="even">
							<td class="inquire_item8">设计炮点公里数：</td>
							<td class="inquire_form8" id="plan_g2004"></td>
							<td class="inquire_item8">日完成炮点公里数：</td>
							<td class="inquire_form8" id="actual_g2004"></td>
							<td class="inquire_item8">累计完成炮点公里数：</td>
							<td class="inquire_form8" id="total_g2004"></td>
							<td class="inquire_item8">完成进度：</td>
							<td class="inquire_form8"><font id="radio_g2004"></font>%</td>
						</tr>
						<tr class="odd">
							<td class="inquire_item8">设计接收线公里数：</td>
							<td class="inquire_form8" id="plan_g2003"></td>
							<td class="inquire_item8">日完成接收线公里数：</td>
							<td class="inquire_form8" id="actual_g2003"></td>
							<td class="inquire_item8">累计完成接收线公里数：</td>
							<td class="inquire_form8" id="total_g2003"></td>
							<td class="inquire_item8">完成进度：</td>
							<td class="inquire_form8"><font id="radio_g2003"></font>%</td>
						</tr>
						<tr class="even">
							<td class="inquire_item8">设计总公里数：</td>
							<td class="inquire_form8" id="plan_g2"></td>
							<td class="inquire_item8">日完成总公里数：</td>
							<td class="inquire_form8" id="actual_g2"></td>
							<td class="inquire_item8">累计完成总公里数：</td>
							<td class="inquire_form8" id="total_g2"></td>
							<td class="inquire_item8">完成进度：</td>
							<td class="inquire_form8"><font id="radio_g2"></font>%</td>
						</tr>
					</table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr style="background-color: #97cbfd">
							<td align="left" colspan="8">&nbsp;&nbsp;&nbsp;钻井工作</td>
						</tr>
						<tr class="even">
							<td class="inquire_item8"></td>
							<td class="inquire_form8"></td>
							<td class="inquire_item8">日完成钻井进尺数：</td>
							<td class="inquire_form8" id="actual_g5003"></td>
							<td class="inquire_item8">累计完钻井成进尺数：</td>
							<td class="inquire_form8" id="total_g5003"></td>
							<td class="inquire_item8"></td>
							<td class="inquire_form8"></td>
						</tr>
						<tr class="odd">
							<td class="inquire_item8">设计钻井井口数：</td>
							<td class="inquire_form8" id="plan_g5002"></td>
							<td class="inquire_item8">日完成钻井井口数：</td>
							<td class="inquire_form8" id="actual_g5002"></td>
							<td class="inquire_item8">累计完成钻井井口数：</td>
							<td class="inquire_form8" id="total_g5002"></td>
							<td class="inquire_item8"></td>
							<td class="inquire_form8"></td>
						</tr>
						<tr class="even">
							<td class="inquire_item8">设计钻井炮点数：</td>
							<td class="inquire_form8" id="plan_g5001"></td>
							<td class="inquire_item8">日完成钻井炮点数：</td>
							<td class="inquire_form8" id="actual_g5001"></td>
							<td class="inquire_item8">累计完成钻井炮点数：</td>
							<td class="inquire_form8" id="total_g5001"></td>
							<td class="inquire_item8">完成进度：</td>
							<td class="inquire_form8"><font id="radio_g5001"></font>%</td>
						</tr>
					</table>
				</div>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr style="background-color: #97cbfd">
						<td align="left" colspan="8">&nbsp;&nbsp;&nbsp;日生产时效(24小时)</td>
					</tr>
					<tr class="even">
						<td class="inquire_item8">路途时间：</td>
						<td class="inquire_form8" id="path"></td>
						<td class="inquire_item8">收放线时间：</td>
						<td class="inquire_form8" id="line_lay"></td>
						<td class="inquire_item8">查排列时间：</td>
						<td class="inquire_form8" id="array_check"></td>
						<td class="inquire_item8">日检时间：</td>
						<td class="inquire_form8" id="day_check"></td>
					</tr>
					<tr class="odd">
						<td class="inquire_item8">首炮时间：</td>
						<td class="inquire_form8" id="first_delay"></td>
						<td class="inquire_item8">末炮时间：</td>
						<td class="inquire_form8" id="last_delay"></td>
						<td class="inquire_item8">实际放炮时间：</td>
						<td class="inquire_form8" id="actual_shot"></td>
						<td class="inquire_item8">天气影响时间：</td>
						<td class="inquire_form8" id="weather_delay"></td>
					</tr>
					<tr class="even">
						<td class="inquire_item8">潮汐时间：</td>
						<td class="inquire_form8" id="tide_delay"></td>
						<td class="inquire_item8">仪器故障时间：</td>
						<td class="inquire_form8" id="machine_delay"></td>
						<td class="inquire_item8">震源故障影响：</td>
						<td class="inquire_form8" id="focus_delay"></td>
						<td class="inquire_item8">测量故障时间：</td>
						<td class="inquire_form8" id="measure_delay"></td>
					</tr>
					<tr class="odd">
						<td class="inquire_item8">排列故障时间：</td>
						<td class="inquire_form8" id="array_trouble"></td>
						<td class="inquire_item8">工区清障时间：</td>
						<td class="inquire_form8" id="clearup_delay"></td>
						<td class="inquire_item8">工地搬迁时间：</td>
						<td class="inquire_form8" id="transit_delay"></td>
						<td class="inquire_item8">气枪挑头上线时间：</td>
						<td class="inquire_form8" id="air_gun_use_time"></td>
					</tr>
					<tr class="even">
						<td class="inquire_item8">地方关系影响：</td>
						<td class="inquire_form8" id="relation_delay"></td>
						<td class="inquire_item8">HSE影响时间: </td>
						<td class="inquire_form8" id="hse_delay"></td>
						<td class="inquire_item8"></td>
						<td class="inquire_form8" ></td>
						<td class="inquire_item8"></td>
						<td class="inquire_form8" ></td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr style="background-color: #97cbfd">
						<td align="left" colspan="8">&nbsp;&nbsp;&nbsp;当日生产写实</td>
					</tr>
					<tr class="even">
						<td width="10px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;生产写实：</td><!-- class="inquire_item6" -->
						<td width=""><textarea id="operation_explain" name="operation_explain" cols="45" rows="3" class="textarea"></textarea></td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >
					<tr style="background-color: #97cbfd">
						<td align="left" colspan="17">&nbsp;&nbsp;&nbsp;阶段生产信息</td>
					</tr>
					<tr class="even" >
						<td align="center" colspan="3" style="border: solid 1px;">累计完成工作量</td>
						<td align="center" colspan="2" style="border: solid 1px;">剩余工作量</td>
						<td align="center" colspan="4" style="border: solid 1px;">阶段生产情况</td>
						<td align="center" colspan="7" style="border: solid 1px;">累计停工时间（天）</td>
						<td align="center" style="border: solid 1px;">阶段生产时效</td>
					</tr>
					<tr class="odd" >
						<td style="border: solid 1px;"><%=workload_type %></td>
						<td style="border: solid 1px;">炮数</td>
						<td style="border: solid 1px;">项目完成总进度%</td>
						<td style="border: solid 1px;"><%=workload_type %></td>
						<td style="border: solid 1px;">炮数</td>
						<td style="border: solid 1px;">自然天</td>
						<td style="border: solid 1px;">自然日均（炮）</td>
						<td style="border: solid 1px;">生产天</td>
						<td style="border: solid 1px;">生产日均（炮）</td>
						<td style="border: solid 1px;">天气</td>
						<td style="border: solid 1px;">地方影响</td>
						<td style="border: solid 1px;">设备检修</td>
						<td style="border: solid 1px;">设备故障</td>
						<td style="border: solid 1px;">搬迁</td>
						<td style="border: solid 1px;">试验</td>
						<td style="border: solid 1px;">累计</td>
						<td style="border: solid 1px;">（自然日均/计划自然日均时效）</td>
					</tr>
					<tr class="even" style="border: solid 1px;">
						<td style="border: solid 1px;"><font id="sum_workload">0</font></td>
						<td style="border: solid 1px;"><font id="sum_shot">0</font></td>
						<td style="border: solid 1px;"><font id="sum_radio"></font></td>
						<td style="border: solid 1px;"><font id="remain_workload"></font></td>
						<td style="border: solid 1px;"><font id="remain_shot"></font></td>
						<td style="border: solid 1px;"><font id="nature_day"></font></td>
						<td style="border: solid 1px;"><font id="nature_shot"></font></td>
						<td style="border: solid 1px;"><font id="produce_day"></font></td>
						<td style="border: solid 1px;"><font id="produce_shot"></font></td>
						<td style="border: solid 1px;"><font id="stop_weather"></font></td>
						<td style="border: solid 1px;"><font id="stop_place"></font></td>
						<td style="border: solid 1px;"><font id="stop_repair"></font></td>
						<td style="border: solid 1px;"><font id="stop_fault"></font></td>
						<td style="border: solid 1px;"><font id="stop_move"></font></td>
						<td style="border: solid 1px;"><font id="stop_test"></font></td>
						<td style="border: solid 1px;"><font id="stop_sum"></font></td>
						<td style="border: solid 1px;"><font id="radio"></font></td>
					</tr>
				</table>
			</div>
			<br/>
		</div>
		
<script type="text/javascript">

	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function refreshData() {
		document.getElementById("form1").submit();
		newClose();
	}
	function showInformation(){
		var display = document.getElementById("other_information").style.display ;
		if(display == 'block'){
			document.getElementById("other_information").style.display = 'none';
		}else{
			document.getElementById("other_information").style.display = 'block';
		}
	}
	function otherInformation(daily_no,project_info_no,produce_date){
		var types ="actual-actual_this_period_units,plan-planned_units,total-actual_units".split(",");
		
		var column_sql = "";
		var ids = "1001,9000,4001,4002,2001,2002,2004,2003,5003,5002,5001".split(",");//计划编制中的id，因为需要区分二维和三维，所以需要resource_id + 5001进行组合
		
		for(var i in ids){
			for(var j in types){
				var column = types[j].split("-");
				if(column[0] =='total'){
					column_sql = column_sql + "max(case when t.resource_id ='<%=resource_id%>"+ids[i]+"' then t."+column[1]+" else 0 end) "+column[0]+"_g"+ids[i]+",";
				}else{
					column_sql = column_sql + "sum(case when (t.resource_id ='<%=resource_id%>"+ids[i]+"' and t.produce_date = to_date('"+produce_date+"', 'yyyy-MM-dd')) then t."+column[1]+" else 0 end) "+column[0]+"_g"+ids[i]+",";
				}
				
			}
		}
		var querySql = "select "+column_sql+" sum(1) total from bgp_p6_workload t where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"' and t.produce_date <= to_date('"+produce_date+"','yyyy-MM-dd')";
		
		var nums = "1001,9000,4001,4002,2001,2002,2004,2003,5003,5002,5001";
		nums = nums.replace(/\,/g,"','<%=resource_id%>");
		nums = '<%=resource_id%>'+nums;
		querySql = querySql +"and t.resource_id in ('"+nums+"')";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj !=null && retObj.returnCode =='0' && retObj.datas!=null && retObj.datas[0]!=null){
			var column = "plan_g1001,actual_g1001,total_g1001,plan_g9000,actual_g9000,total_g9000,plan_g4001,actual_g4001,total_g4001,"+
			"plan_g4002,actual_g4002,total_g4002,plan_g2001,actual_g2001,total_g2001,plan_g2002,actual_g2002,total_g2002,plan_g2004,"+
			"actual_g2004,total_g2004,plan_g2003,actual_g2003,total_g2003,actual_g5003,total_g5003,plan_g5002,actual_g5002,total_g5002,"+
			"plan_g5001,actual_g5001,total_g5001";//页面上的字段
			var columns = column.split(",");
			for(var i in columns){
				document.getElementById(columns[i]).innerHTML = retObj.datas[0][columns[i]];
			}	
		}
		var columns = "g2001,g2002,g2004,g2003,g2,g5001".split(",");//完成进度字段= plan / total
		for(var i in columns){
			var plan = document.getElementById("plan_"+columns[i]).innerHTML;
			if(plan == null){
				plan = document.getElementById("plan_"+columns[i]).value;
			}
			if(plan ==''){
				plan = "0";
			}
			var total = document.getElementById("total_"+columns[i]).innerHTML;
			if(total ==null || total ==''){
				total = "0";
			}
			
			var radio = 0;
			if(plan !='0' ){
				radio = Math.round(total/plan*10000)/100.0;
			}
			document.getElementById("radio_"+columns[i]).innerHTML = radio;
		}
	}
	function sumInformation(project_info_no,produce_date){
		var querySql = "select sum(nvl(t.daily_acquire_sp_num,0)+nvl(t.daily_jp_acquire_shot_num,0)+nvl(t.daily_qq_acquire_shot_num,0)) sum_shot,"+
		" sum(nvl(t.daily_acquire_workload,0)+nvl(t.daily_jp_acquire_workload,0)+nvl(t.daily_qq_acquire_workload,0)) sum_workload"+
		" from gp_ops_daily_report t where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"'"+
		" and t.produce_date <= to_date('"+produce_date+"','yyyy-MM-dd')";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj !=null && retObj.returnCode =='0' && retObj.datas!=null && retObj.datas[0]!=null){
			var columns = "sum_shot,sum_workload".split(",");
			for(var i in columns){
				document.getElementById(columns[i]).innerHTML = retObj.datas[0][columns[i]];
			}
		}
		var plan_shot = document.getElementById("design_sp_num").innerHTML;
		var sum_shot  = document.getElementById("sum_shot").innerHTML;
		document.getElementById("remain_shot").innerHTML = plan_shot - sum_shot;
		
		var sum_workload = document.getElementById("sum_workload").innerHTML;
		var workload  = document.getElementById("workload").value;
		var index = work_load.indexOf(workload);
		work_load = work_load.substring(index-(-2));
		index = work_load.indexOf(",");
		work_load = work_load.substring(0,index);
		var workloadVaue = document.getElementById(work_load).innerHTML;
		if(workloadVaue!=null && workloadVaue!=''){
			var radio = Math.round(sum_workload/workloadVaue*10000)/100.0;
			document.getElementById("sum_radio").innerHTML = radio;
			document.getElementById("remain_workload").innerHTML = workloadVaue  - sum_workload;
		}
		
		
		querySql = " with daily_report as(select sum(nvl(t.daily_acquire_sp_num,0)+nvl(t.daily_jp_acquire_shot_num,0)+nvl(t.daily_qq_acquire_shot_num,0)) sum_shot,"+
		" t.produce_date,s.if_build from gp_ops_daily_report t left join gp_ops_daily_produce_sit s on t.daily_no = s.daily_no and s.bsflag ='0'"+
		" where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"' and t.produce_date <= to_date('"+produce_date+"','yyyy-MM-dd')"+
		" group by t.produce_date,s.if_build order by t.produce_date asc) select max(d.produce_date)- min(d.produce_date)-(-1) nature_day,"+
		" max((select count(*) from daily_report dr where dr.sum_shot >0)) produce_day"+
		" from(select decode(tt.if_build,'9',9,'11',11,tt.sum_shot)sum_shot ,tt.produce_date,tt.if_build from daily_report tt)d where d.sum_shot >0";
		retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj !=null && retObj.returnCode =='0' && retObj.datas!=null && retObj.datas[0]!=null){
			var columns = "nature_day,produce_day".split(",");
			for(var i in columns){
				document.getElementById(columns[i]).innerHTML = retObj.datas[0][columns[i]];
			}
		}
		var columns = "sum_shot-nature_day-nature_shot,sum_shot-produce_day-produce_shot".split(",");
		for(var i in columns){
			var total = document.getElementById(columns[i].split("-")[0]).innerHTML ;
			var day = document.getElementById(columns[i].split("-")[1]).innerHTML ;
			var radio = 0;
			if(day!=null && day!='0' && day !='' && total!=null && total !=''){
				radio = Math.round(total/day);
			}
			document.getElementById(columns[i].split("-")[2]).innerHTML = radio ;
		}
		var nature_day = document.getElementById("nature_day").innerHTML;
	}
	function stopInformation(project_info_no,produce_date){//停工原因统计
		var querySql = " select nvl(sum(case when s.stop_reason ='1' then 1 else 0 end),0) stop_test,nvl(sum(case when s.stop_reason ='2' then 1 else 0 end),0) stop_weather, "+
		" nvl(sum(case when s.stop_reason ='3' then 1 else 0 end),0) stop_move,nvl(sum(case when s.stop_reason ='4' then 1 else 0 end),0) stop_repair, "+
		" nvl(sum(case when s.stop_reason ='5' then 1 else 0 end),0) stop_fault,nvl(sum(case when s.stop_reason ='6' then 1 else 0 end),0) stop_place, "+
		" nvl(sum(1),0) stop_sum from gp_ops_daily_report t left join gp_ops_daily_produce_sit s on t.daily_no = s.daily_no   "+
		" where t.bsflag ='0' and s.if_build ='9' and t.project_info_no ='"+project_info_no+"' and t.exploration_method = '<%=exploration_method%>' "+
		" and t.produce_date <= to_date('"+produce_date+"','yyyy-MM-dd')";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj !=null && retObj.returnCode =='0' && retObj.datas!=null && retObj.datas[0]!=null){
			var columns = "stop_test,stop_weather,stop_move,stop_repair,stop_fault,stop_place,stop_sum".split(",");
			for(var i in columns){
				document.getElementById(columns[i]).innerHTML = retObj.datas[0][columns[i]];
			}	
		}
	}
</script>
</body>


</html>