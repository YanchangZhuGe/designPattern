<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    
	String record_id = request.getParameter("record_id");
	String ifcarry = request.getParameter("ifcarry");
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



function refreshData(){
		if('<%=ifcarry%>'=="0"){
			   var str=" select * from ("
					+" SELECT  p.project_year,p.PROJECT_NAME, r.RECORD_ID, r.PROJECT_INFO_ID, r.CONTRACTS_SIGNED, r.CONTRACTS_SIGNED_CHANGE, r.COMPLETE_VALUE, r.COMPLETE_VALUE_CHANGE, r.CHANGE_STATUS, r.CREATE_DATE, r.CREATOR_ID, r.CREATOR_NAME "
					+   " FROM BGP_OP_MONEY_CONFIRM_RECORD_WS r left join GP_TASK_PROJECT p on p.PROJECT_INFO_NO=r.PROJECT_INFO_ID where r.RECORD_ID='<%=record_id %>') t1 left join("
			+" select wm_concat(distinct VIEW_TYPE) as VIEW_TYPE,wm_concat(distinct BUILD_METHOD) as BUILD_METHOD, PROJECT_INFO_NO from BGP_WS_DAILY_REPORT where BSFLAG='0' group by PROJECT_INFO_NO"
			+	") vb on vb.PROJECT_INFO_NO=t1.PROJECT_INFO_ID  left join BGP_WS_DAILY_REPORT re on re.PROJECT_INFO_NO=t1.PROJECT_INFO_ID";
			var detailRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=1000');
			var retObj = detailRet.datas;
			$("#contracts_signed").html(retObj[0].contracts_signed);
			$("#contracts_signed_change").val(retObj[0].contracts_signed_change);
			$("#complete_value").html(retObj[0].complete_value);
			$("#complete_value_change").val(retObj[0].complete_value_change);
		
			$("#project_name").html(retObj[0].project_name);
			$("#org_name").html(retObj[0].org_name);
			$("#basin").html(retObj[0].basin);
			$("#well_number").html(retObj[0].well_number);
			$("#coding_name").html(retObj[0].coding_name);
			$("#project_status").html(retObj[0].project_status);
			$("#start_date").html(retObj[0].start_date);
			$("#end_date").html(retObj[0].end_date);
			$("#project_year").html(retObj[0].project_year);
			$("#project_income").html(retObj[0].project_income);
			
			$("#view_type").html(retObj[0].view_type);
			$("#build_method").html(retObj[0].build_method);	
		}else{
			var str="select con.YEAR as project_year,con.CONTRACTS_SIGNED,con.CONTRACTS_SIGNED_CHANGE,con.COMPLETE_VALUE,con.COMPLETE_VALUE_CHANGE,con.PROJECT_INFO_ID ,"
			+"p.project_name||'(结转)' as project_name ,"
			+"t2.ORG_NAME, t2.BASIN, t2.WELL_NUMBER||'(结转)' as WELL_NUMBER, t2.CODING_NAME, t2.PROJECT_INCOME,t2.START_DATE, t2.END_DATE, t2.PROJECT_STATUS ,"
			+"vb.VIEW_TYPE,vb.BUILD_METHOD "
			+"from BGP_OP_MONEY_CONFIRM_RECORD_WS con "
			+"left join BGP_OP_PROJECT_MONEY_CARRYOVER car on con.PROJECT_INFO_ID=car.PROJECT_INFO_NO and con.YEAR=car.YEAR and car.BSFLAG='0' "
			+"left join ("
			+"    select PROJECT_INFO_NO, ORG_NAME, BASIN, WELL_NUMBER, CODING_NAME, PROJECT_INCOME,START_DATE, END_DATE, PROJECT_STATUS "
			+"     from BGP_WS_DAILY_REPORT report where report.DAILY_ID=(select max(DAILY_ID) from BGP_WS_DAILY_REPORT where PROJECT_INFO_NO=(select t.PROJECT_INFO_ID from BGP_OP_MONEY_CONFIRM_RECORD_WS t where t.RECORD_ID='<%=record_id %>'))"
			+") t2  on t2.PROJECT_INFO_NO=con.PROJECT_INFO_ID "
			+"left join ( select wm_concat(distinct VIEW_TYPE) as VIEW_TYPE,wm_concat(distinct BUILD_METHOD) as BUILD_METHOD, PROJECT_INFO_NO from BGP_WS_DAILY_REPORT where BSFLAG='0' group by PROJECT_INFO_NO) vb on vb.PROJECT_INFO_NO=con.PROJECT_INFO_ID " 
			+" left join GP_TASK_PROJECT p on p.PROJECT_INFO_NO=con.PROJECT_INFO_ID and p.BSFLAG='0' where con.RECORD_ID='<%=record_id %>'";
			var detailRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=1000');
			var retObj = detailRet.datas;
			$("#contracts_signed").html(retObj[0].contracts_signed);
			$("#contracts_signed_change").val(retObj[0].contracts_signed_change);
			$("#complete_value").html(retObj[0].complete_value);
			$("#complete_value_change").val(retObj[0].complete_value_change);
		
			$("#project_name").html(retObj[0].project_name);
			$("#org_name").html(retObj[0].org_name);
			$("#basin").html(retObj[0].basin);
			$("#well_number").html(retObj[0].well_number);
			$("#coding_name").html(retObj[0].coding_name);
			$("#project_status").html(retObj[0].project_status);
			$("#start_date").html(retObj[0].start_date);
			$("#end_date").html(retObj[0].end_date);
			$("#project_year").html(retObj[0].project_year);
			$("#project_income").html(retObj[0].project_income);
			
			$("#view_type").html(retObj[0].view_type);
			$("#build_method").html(retObj[0].build_method);
		}

		

}

</script>
</head>
<body onload="refreshData();">
	<form id="CheckForm" action="" method="post" target="list" >
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
									<td class="inquire_item4">年度：</td>
									<td class="inquire_form4"><span id="project_year"></span></td>
									<td class="inquire_item4">预计完成价值工作量(万元)：</td>
									<td class="inquire_form4"><span id="project_income"></span></td>
								</tr>	
								<tr>
									<td class="inquire_item4">原已签到合同额(万元)：</td>
									<td class="inquire_form4"><span id="contracts_signed"></span></td>
									<td class="inquire_item4">审批已签到合同额(万元)：</td>
									<td class="inquire_form4"><input type="text" readonly="readonly" id="contracts_signed_change" name="contracts_signed_change" value="" class="input_width"/></td>
								</tr>
								<tr>
									<td class="inquire_item4" >原完成价值工作量(万元)：</td>
									<td class="inquire_form4"><span id="complete_value"></span></td>
									<td class="inquire_item4">审批完成价值工作量(万元)：</td>
									<td class="inquire_form4"><input type="text" readonly="readonly" id="complete_value_change" name="complete_value_change" value="" class="input_width"/></td>
								</tr>								
							</table>
						</div>
					</div>
				</div>
	</form>
</body>
</html>
