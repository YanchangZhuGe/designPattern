<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId=user.getEmpId();
	String projectInfoNo = user.getProjectInfoNo();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript"  src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>

  <title>人员投入表</title>
 </head>

 <body style="background:#fff" onload="refreshData()">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
					    <td>&nbsp;</td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			     <tr>
			      <td class="bt_info_odd"  exp="<input type='checkbox' name='rdo_entity_id' value='{cost_project_schema_id}' id='rdo_entity_id_{cost_project_schema_id}'   />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{team}">工序及班组</td>
			      <td class="bt_info_even" exp="{team_post}">岗位</td>
			      <td class="bt_info_odd" exp="{sum_all}">合计</td>
			      <td class="bt_info_even" exp="{sum_ht}">合同化员工</td>
			      <td class="bt_info_odd" exp="{sum_sc}">市场化员工</td>
			       <td class="bt_info_even" exp="{sum_zj}">再就业人员</td>
			      <td class="bt_info_odd" exp="{sum_jj}">季节工</td>
			     </tr>
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
</body>

<script type="text/javascript">


	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.pageSize=10;
	var projectInfoNo = '<%=projectInfoNo%>';
	$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-8);
	
	function refreshData(ids){
		if(ids==undefined||ids==""||ids==null) ids=cruConfig.currentPage;
		var submitStr = "currentPage="+ids+"&pageSize="+cruConfig.pageSize;
		cruConfig.queryStr = "select sd1.coding_name team,sd2.coding_name team_post,sum(decode(employee_gz, '0110000019000000001', 1, 0))+"+
	   " sum(case when (employee_gz='0110000059000000002' or employee_gz='0110000059000000003' or employee_gz='0110000059000000005' or employee_gz='110000059000000006') then 1 else 0 end)+ "+
       " sum(decode(employee_gz, '0110000019000000002', 1, 0))+sum(decode(employee_gz, '0110000059000000001', 1, 0)) sum_all, "+
       " sum(decode(employee_gz, '0110000019000000001', 1, 0)) sum_ht,sum(decode(employee_gz, '0110000019000000002', 1, 0)) sum_sc, "+
       " sum(case when (employee_gz='0110000059000000002' or employee_gz='0110000059000000003' or employee_gz='0110000059000000005' or employee_gz='110000059000000006') then 1 else 0 end) sum_jj,"+
       " sum(decode(employee_gz, '0110000059000000001', 1, 0)) sum_zj "+
  	   " from (select d.employee_id,e.employee_gz,d.team,d.work_post,p.project_info_no,d.create_date, "+
       " row_number() over(partition by p.project_info_no, e.employee_id order by p.create_date desc) row_num "+
       " from bgp_human_prepare_human_detail d left join bgp_human_prepare p on d.prepare_no = p.prepare_no and p.bsflag = '0' "+
       " left join comm_human_employee_hr e on d.employee_id = e.employee_id and e.bsflag = '0' "+
       " where d.actual_start_date is not null and d.bsflag = '0' union all "+
       " select d.labor_id employee_id,l.if_engineer employee_gz,de.apply_team team,de.post work_post,d.project_info_no,d.create_date, "+
       "        row_number() over(partition by d.project_info_no, l.labor_id order by d.create_date desc) row_num "+
       "   from bgp_comm_human_labor_deploy d left join bgp_comm_human_deploy_detail de on d.labor_deploy_id = de.labor_deploy_id and de.bsflag = '0'  "+
       "    left join bgp_comm_human_labor l on d.labor_id = l.labor_id and l.bsflag = '0' where d.bsflag = '0') t "+
       " left outer join comm_human_employee he on t.employee_id = he.employee_id "+
       " left outer join comm_coding_sort_detail sd1 on t.team = sd1.coding_code_id "+
       " left outer join comm_coding_sort_detail sd2 on t.work_post = sd2.coding_code_id "+
       " where t.row_num = 1 and t.project_info_no = '<%=projectInfoNo%>' "+
       " group by sd1.coding_name, sd2.coding_name order by team desc";
		cruConfig.currentPageUrl = "/op/costMangerVersion/costManagerVersion.jsp";
		queryData(ids);
	}

	function loadDataDetail(ids){
		
	}
</script>
</html>