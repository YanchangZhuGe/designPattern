<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userId = (user==null)?"":user.getEmpId();
    String projectName = user.getProjectName();
    String creatorName = user.getUserName();
    String projectInfoNo = user.getProjectInfoNo();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
	String project_year = request.getParameter("project_year");
	String ifcarry = request.getParameter("ifcarry");
	String project_info_id = request.getParameter("project_info_id");
%>
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
	form.action = "<%=contextPath%>/op/OpCostSrv/saveConfirmRecrdWs.srq";
	form.submit();
	//var ctt = top.frames('list');
	//ctt.location.reload();
	newClose();
}


function refreshData(){
	var querySql="";
	if(<%=ifcarry%>=='0'){
		querySql = "select p.project_name,p.project_year,t2.PROJECT_INFO_NO,t2.org_name,t2.well_number,t2.coding_name,t2.project_status,t3.build_method,t3.view_type,t2.project_income,re.CONTRACTS_SIGNED_CHANGE,re.COMPLETE_VALUE_CHANGE from ("
			+"select t1.DAILY_ID,t1.PROJECT_INFO_NO,t1.ORG_NAME,t1.BASIN,t1.WELL_NUMBER,t1.CODING_NAME,t1.CONTRACTS_SIGNED,t1.project_income,t1.PROJECT_STATUS,t1.START_DATE,END_DATE from BGP_WS_DAILY_REPORT t1 where t1.DAILY_ID=(select max(t.DAILY_ID) from BGP_WS_DAILY_REPORT t where  t.PROJECT_INFO_NO='<%=project_info_id%>')"
			+") t2 left join ("
			+"select wm_concat(distinct t4.VIEW_TYPE) as VIEW_TYPE,wm_concat(distinct t4.BUILD_METHOD) as BUILD_METHOD, t4.PROJECT_INFO_NO from BGP_WS_DAILY_REPORT t4 where t4.BSFLAG='0' group by t4.PROJECT_INFO_NO"
			+") t3 on t2.PROJECT_INFO_NO=t3.PROJECT_INFO_NO"
			+" left join GP_TASK_PROJECT p on  t2.PROJECT_INFO_NO=p.PROJECT_INFO_NO and p.bsflag='0' left join ("
			+"select re.CREATE_DATE ,re.PROJECT_INFO_ID,re.CONTRACTS_SIGNED_CHANGE,re.COMPLETE_VALUE_CHANGE,re.YEAR   from BGP_OP_MONEY_CONFIRM_RECORD_WS re right join "
			+"(select max(rr.CREATE_DATE) as CREATE_DATE,rr.PROJECT_INFO_ID,rr.YEAR from BGP_OP_MONEY_CONFIRM_RECORD_WS rr left join COMMON_BUSI_WF_MIDDLE wf on rr.RECORD_ID=wf.BUSINESS_ID and wf.BSFLAG='0' where wf.PROC_STATUS='3' "
			+"group by rr.PROJECT_INFO_ID,rr.YEAR) tt on tt.CREATE_DATE=re.CREATE_DATE"
			+") re on t2.PROJECT_INFO_NO=re.PROJECT_INFO_ID and re.year='<%=project_year%>'";
	}else{
		querySql="select car.PROJECT_INFO_NO,car.CARRYOVER_ID,car.YEAR as project_year,"
		+"decode(re3.CONTRACTS_SIGNED_CHANGE,'',car.CONTRACTS_SIGNED_CARRYOVER,re3.CONTRACTS_SIGNED_CHANGE) as CONTRACTS_SIGNED_CHANGE,decode(re3.COMPLETE_VALUE_CHANGE,'',car.COMPLETE_VALUE_CARRYOVER,re3.COMPLETE_VALUE_CHANGE) as COMPLETE_VALUE_CHANGE,car.PROJECT_NAME_CARRYOVER,"
		+"t2.ORG_NAME,t2.BASIN,t2.WELL_NUMBER||'(结转)' as well_number, t2.PROJECT_INCOME, t2.START_DATE, t2.END_DATE, t2.PROJECT_STATUS,"
		+"vb.VIEW_TYPE,vb.BUILD_METHOD ,p.project_name||'(结转)' as project_name "
		+"from BGP_OP_PROJECT_MONEY_CARRYOVER car "
		+"left join GP_TASK_PROJECT p on  car.PROJECT_INFO_NO=p.PROJECT_INFO_NO and p.bsflag='0' left join  ("
		+"    select PROJECT_INFO_NO, ORG_NAME, BASIN, WELL_NUMBER, CODING_NAME, PROJECT_INCOME,START_DATE, END_DATE, PROJECT_STATUS "
		+"     from BGP_WS_DAILY_REPORT report where report.DAILY_ID=(select max(DAILY_ID) from BGP_WS_DAILY_REPORT where PROJECT_INFO_NO='<%=project_info_id%>')"
		+") t2  on t2.PROJECT_INFO_NO=car.PROJECT_INFO_NO "
		+"left join ( select wm_concat(distinct VIEW_TYPE) as VIEW_TYPE,wm_concat(distinct BUILD_METHOD) as BUILD_METHOD, PROJECT_INFO_NO from BGP_WS_DAILY_REPORT where BSFLAG='0' group by PROJECT_INFO_NO) vb on vb.PROJECT_INFO_NO=car.PROJECT_INFO_NO  "
		+"left join (select re.YEAR,re.CREATE_DATE ,re.PROJECT_INFO_ID,re.CONTRACTS_SIGNED_CHANGE,re.COMPLETE_VALUE_CHANGE  from BGP_OP_MONEY_CONFIRM_RECORD_WS re where re.CREATE_DATE in (select max(rr.CREATE_DATE) from BGP_OP_MONEY_CONFIRM_RECORD_WS rr left join COMMON_BUSI_WF_MIDDLE wf on rr.RECORD_ID=wf.BUSINESS_ID and wf.BSFLAG='0' where wf.PROC_STATUS='3' group by rr.PROJECT_INFO_ID)group by PROJECT_INFO_ID,re.CONTRACTS_SIGNED_CHANGE,re.COMPLETE_VALUE_CHANGE,re.CREATE_DATE,re.YEAR"  
		+")  re3 on re3.PROJECT_INFO_ID=car.PROJECT_INFO_NO and re3.year='<%=project_year%>' "
		+"where car.YEAR='<%=project_year%>' and car.PROJECT_INFO_NO='<%=project_info_id%>'"
	}
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	var datas = queryRet.datas;
	if(datas!=null){
		$("#project_name").html(datas[0].project_name);
		$("#org_name").html(datas[0].org_name);
		$("#well_number").html(datas[0].well_number);
		$("#coding_name").html(datas[0].coding_name);
		//$("#project_status").html(datas[0].project_status);
		$("#project_year_").html(datas[0].project_year);
		$("#build_method").html(datas[0].build_method);
		$("#view_type").html(datas[0].view_type);
		$("#contracts_signed_").html(datas[0].contracts_signed_change);
		$("#project_income").html(datas[0].project_income);
		$("#complete_value_").html(datas[0].complete_value_change);
		
		$("#contracts_signed").val(datas[0].contracts_signed_change);
		$("#complete_value").val(datas[0].complete_value_change);
	}

}

</script>
</head>
<body onload="refreshData();">
	<form id="CheckForm" action="" method="post" target="list" >
	<input type="hidden" id="project_info_id" name="project_info_id" value="<%=project_info_id %>"/>
	<input type="hidden" id="project_year" name="project_year" value="<%=project_year %>"/>
	<input type="hidden" id="contracts_signed" name="contracts_signed" value=""/>
	<input type="hidden" id="complete_value" name="complete_value" value=""/>
	<input type="hidden" id="ifcarry" name="ifcarry" value="<%=ifcarry %>"/>
	
			<div id="new_table_box_content">
				<div id="new_table_box_bg" >
					<div id="tab_box" class="tab_box">
							<table  id="tableDoc"  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item4">项目名称：</td>
									<td class="inquire_form4"><span id="project_name"></span></td>
									<td class="inquire_item4">施工队伍：</td>
									<td class="inquire_form4"><span id="org_name"></span></td>
								</tr>
								<tr>
									<td class="inquire_item4">施工井号：</td>
									<td class="inquire_form4"><span id="well_number"></span></td>
									<td class="inquire_item4">年度：</td>
									<td class="inquire_form4"><span id="project_year_"></span></td>
								</tr>
								<tr>
									<td class="inquire_item4">观测类型：</td>
									<td class="inquire_form4"><span id="view_type"></span></td>
									<td class="inquire_item4">激发方式：</td>
									<td class="inquire_form4"><span id="build_method"></span></td>
								</tr>
								<tr>
									<td class="inquire_item4">原已签到合同额(万元)：</td>
									<td class="inquire_form4"><span id="contracts_signed_"></span></td>
									<td class="inquire_item4">审批已签到合同额(万元)：</td>
									<td class="inquire_form4"><input type="text"  id="contracts_signed_change" name="contracts_signed_change" value="" class="input_width"/></td>
								</tr>
								<tr>
									<td class="inquire_item4" >原完成价值工作量(万元)：</td>
									<td class="inquire_form4"><span id="complete_value_"></span></td>
									<td class="inquire_item4">审批完成价值工作量(万元)：</td>
									<td class="inquire_form4"><input type="text" id="complete_value_change" name="complete_value_change" value="" class="input_width"/></td>
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
