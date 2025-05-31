<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userId = (user==null)?"":user.getEmpId();
    String creatorName = user.getUserName();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
	String project_year = request.getParameter("project_year");
	String ifcarry = request.getParameter("ifcarry");
	String project_info_id = request.getParameter("project_info_id");%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<!--Remark JavaScript定义-->
<script language="javaScript">	
cruConfig.contextPath = "<%=contextPath%>";

function save(){
//	if (!checkForm()) return;
	var form = document.getElementById("CheckForm");
	form.action = "<%=contextPath%>/op/OpCostSrv/saveCarrayOverProjectWs.srq";
	form.submit();
	var ctt = top.frames('list');
	ctt.location.reload();
	newClose();
}



function refreshData(){
	var str="";
	if('<%=ifcarry%>'=='0'){
		 str= "select * from ("
			+"select t0.DAILY_ID,t0.PROJECT_INFO_NO,t0.ORG_NAME,t0.BASIN,t0.WELL_NUMBER,t0.CODING_NAME,t0.CONTRACTS_SIGNED,t0.project_income,t0.PROJECT_STATUS,t0.START_DATE,END_DATE from BGP_WS_DAILY_REPORT t0 where t0.DAILY_ID=(select max(t.DAILY_ID) from BGP_WS_DAILY_REPORT t where  t.PROJECT_INFO_NO='<%=project_info_id%>')"
			+") t1 left join ("
			+" select wm_concat(distinct VIEW_TYPE) as VIEW_TYPE,wm_concat(distinct BUILD_METHOD) as BUILD_METHOD, PROJECT_INFO_NO from BGP_WS_DAILY_REPORT where BSFLAG='0' group by PROJECT_INFO_NO"
			+") vb on vb.PROJECT_INFO_NO=t1.PROJECT_INFO_NO  left join ("
			+"select re.CREATE_DATE ,re.PROJECT_INFO_ID,re.CONTRACTS_SIGNED_CHANGE,re.COMPLETE_VALUE_CHANGE,re.YEAR   from BGP_OP_MONEY_CONFIRM_RECORD_WS re right join "
			+"(select max(rr.CREATE_DATE) as CREATE_DATE,rr.PROJECT_INFO_ID,rr.YEAR from BGP_OP_MONEY_CONFIRM_RECORD_WS rr left join COMMON_BUSI_WF_MIDDLE wf on rr.RECORD_ID=wf.BUSINESS_ID and wf.BSFLAG='0' where wf.PROC_STATUS='3' "
			+"group by rr.PROJECT_INFO_ID,rr.YEAR) tt on tt.CREATE_DATE=re.CREATE_DATE	"		
			+")  re3 on re3.PROJECT_INFO_ID=t1.PROJECT_INFO_NO and re3.year='<%=project_year%>' left join gp_task_project pro on pro.PROJECT_INFO_NO=t1.PROJECT_INFO_NO and pro.BSFLAG='0' "				
	}else{
		str="select car.PROJECT_INFO_NO,car.CARRYOVER_ID,car.YEAR as project_year,"
			+"decode(re3.CONTRACTS_SIGNED_CHANGE,'',car.CONTRACTS_SIGNED_CARRYOVER,re3.CONTRACTS_SIGNED_CHANGE) as CONTRACTS_SIGNED_CHANGE,decode(re3.COMPLETE_VALUE_CHANGE,'',car.COMPLETE_VALUE_CARRYOVER,re3.COMPLETE_VALUE_CHANGE) as COMPLETE_VALUE_CHANGE,car.PROJECT_NAME_CARRYOVER,"
			+"t2.ORG_NAME,t2.BASIN,t2.WELL_NUMBER||'(结转)' as well_number, t2.PROJECT_INCOME, t2.START_DATE, t2.END_DATE, t2.PROJECT_STATUS,t2.CODING_NAME,"
			+"vb.VIEW_TYPE,vb.BUILD_METHOD,pro.project_name||'(结转)' as project_name "
			+"from BGP_OP_PROJECT_MONEY_CARRYOVER car "
			+"left join gp_task_project pro on pro.PROJECT_INFO_NO=car.PROJECT_INFO_NO and pro.BSFLAG='0' left join ("
			+"    select PROJECT_INFO_NO, ORG_NAME, BASIN, WELL_NUMBER, CODING_NAME, PROJECT_INCOME,START_DATE, END_DATE, PROJECT_STATUS "
			+"     from BGP_WS_DAILY_REPORT report where report.DAILY_ID=(select max(DAILY_ID) from BGP_WS_DAILY_REPORT where PROJECT_INFO_NO='<%=project_info_id%>')"
			+") t2  on t2.PROJECT_INFO_NO=car.PROJECT_INFO_NO "
			+"left join ( select wm_concat(distinct VIEW_TYPE) as VIEW_TYPE,wm_concat(distinct BUILD_METHOD) as BUILD_METHOD, PROJECT_INFO_NO from BGP_WS_DAILY_REPORT where BSFLAG='0' group by PROJECT_INFO_NO) vb on vb.PROJECT_INFO_NO=car.PROJECT_INFO_NO  "
			+"left join (select re.YEAR,re.CREATE_DATE ,re.PROJECT_INFO_ID,re.CONTRACTS_SIGNED_CHANGE,re.COMPLETE_VALUE_CHANGE  from BGP_OP_MONEY_CONFIRM_RECORD_WS re where re.CREATE_DATE in (select max(rr.CREATE_DATE) from BGP_OP_MONEY_CONFIRM_RECORD_WS rr left join COMMON_BUSI_WF_MIDDLE wf on rr.RECORD_ID=wf.BUSINESS_ID and wf.BSFLAG='0' where wf.PROC_STATUS='3' group by rr.PROJECT_INFO_ID)group by PROJECT_INFO_ID,re.CONTRACTS_SIGNED_CHANGE,re.COMPLETE_VALUE_CHANGE,re.CREATE_DATE,re.YEAR"  
			+")  re3 on re3.PROJECT_INFO_ID=car.PROJECT_INFO_NO and re3.year='<%=project_year%>' "
			+"where car.YEAR='<%=project_year%>' and car.PROJECT_INFO_NO='<%=project_info_id%>'"
	}
var detailRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=1000');
		var retObj = detailRet.datas;
		$("#contracts_signed").html(retObj[0].contracts_signed_change);
		$("#complete_value").html(retObj[0].complete_value_change);
		$("#project_name").html(retObj[0].project_name);
		$("#org_name").html(retObj[0].org_name);
		$("#basin").html(retObj[0].basin);
		$("#well_number").html(retObj[0].well_number);
		$("#well_number_").val(retObj[0].well_number);
		$("#coding_name").html(retObj[0].coding_name);
		$("#project_status").html(retObj[0].project_status);
		$("#start_date").html(retObj[0].start_date);
		$("#end_date").html(retObj[0].end_date);
		$("#view_type").html(retObj[0].view_type);
		$("#build_method").html(retObj[0].build_method);
}

</script>
</head>
<body onload="refreshData();">
	<form id="CheckForm" action="" method="post" target="list" >
	<input type="hidden" id="project_info_id" name="project_info_id" value="<%=project_info_id %>"/>
	<input type="hidden" id="well_number_" name="well_number_" value=""/>
			<div id="new_table_box_content">
				<div id="new_table_box_bg" >
					<div id="tab_box" class="tab_box">
							<table  id="tableDoc"  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item4">项目名称：</td>
									<td class="inquire_form4"><span id="project_name"></span></td>
									<td class="inquire_item4">施工队号：</td>
									<td class="inquire_form4"><span id="org_name"></span></td>
								</tr>
								<tr>
									<td class="inquire_item4">地区盆地：</td>
									<td class="inquire_form4"><span id="basin"></span></td>
									<td class="inquire_item4">施工井号：</td>
									<td class="inquire_form4"><span id="well_number"></span></td>
								</tr>
								<tr>
								<td class="inquire_item4">甲方单位：</td>
									<td class="inquire_form4"><span id="coding_name"></span></td>
									<td class="inquire_item4">项目状态：</td>
									<td class="inquire_form4"><span id="project_status"></span></td>
								</tr>							
								<tr>
								<td class="inquire_item4">开工时间：</td>
									<td class="inquire_form4"><span id="start_date"></span></td>
									<td class="inquire_item4">完工时间：</td>
									<td class="inquire_form4"><span id="end_date"></span></td>
								</tr>								
								<tr>
								<td class="inquire_item4">观测类型：</td>
									<td class="inquire_form4"><span id="view_type"></span></td>
									<td class="inquire_item4">激发方式：</td>
									<td class="inquire_form4"><span id="build_method"></span></td>
								</tr>
								<tr>
									<td class="inquire_item4">已签到合同额(万元)：</td>
									<td class="inquire_form4"><span id="contracts_signed"></span></td>
									<td class="inquire_item4" >完成价值工作量(万元)：</td>
									<td class="inquire_form4"><span id="complete_value"></span></td>
								</tr>
							<tr><td></td></tr>
							<tr>
								<td class="inquire_item4">结转年度：</td>
								<td class="inquire_form4">
								<select id="year_carryover" name="year_carryover">
									<option value="2014">2014</option>
									<option value="2015">2015</option>
									<option value="2016">2016</option>
									<option value="2017">2017</option>
									<option value="2018">2018</option>
									<option value="2019">2019</option>
								</select></td>
							</tr>
								<tr>
									<td class="inquire_item4">结转  已签到合同额(万元)：</td>
									<td class="inquire_form4"><input id="contracts_signed_carryover" name="contracts_signed_carryover" value=""></input></td>
									<td class="inquire_item4" >结转  完成价值工作量(万元)：</td>
									<td class="inquire_form4"><input id="complete_value_carryover" name="complete_value_carryover" value=""></input></td>
								</tr>
							</table>
						</div>
					</div>
					<div id="oper_div">
						<span class="tj_btn"><a href="#" onclick="save()"></a>
						</span> <span class="gb_btn"><a href="#" onclick="newClose()"></a>
						</span>
					</div>
				</div>
	</form>
</body>
</html>
