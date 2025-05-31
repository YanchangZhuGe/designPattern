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
	boolean proc_status = OPCommonUtil.getProcessStatus2("BGP_OP_TARGET_PROJECT_INFO","gp_target_project_id","5110000004100000032",projectInfoNo);
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

  <title>测量费用表</title>
 </head>

 <body style="background:#fff" onload="refreshData()">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
					    <td>&nbsp;</td>
					    <td align="right" style="padding-right: 20px;"><font color="red"><span id="sum_value"></span></font></td>
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
			      <td class="bt_info_odd" exp="{send_date}">上报日期</td>
			      <td class="bt_info_even" exp="{workload}">测量完成工作量(km/km2)</td>
			      <td class="bt_info_odd" exp="{sum_price}" onclick="getSum()">金额(元)</td>
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
</body>

<script type="text/javascript">

function setTabBoxHeight(){
	$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-2);
}

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.pageSize=10;
	var projectInfoNo = '<%=projectInfoNo%>';
	
	
	function refreshData(ids){
		if(ids==undefined||ids==""||ids==null) ids=cruConfig.currentPage;
		if(ids==0)ids=1;
		var submitStr = "currentPage="+ids+"&pageSize="+cruConfig.pageSize;
		cruConfig.queryStr = "  select (nvl(gd.SHOT_2D_WORKLOAD, 0) + nvl(gd.SHOT_3D_WORKLOAD, 0))* "+
       " (select nvl(max(t.price_unit),0)  from bgp_op_price_project_info t    "+
       " where t.project_info_no='<%=projectInfoNo%>'  and t.node_code='S01026') sum_price ,gd.send_date,  "+
       " (nvl(gd.SHOT_2D_WORKLOAD, 0) + nvl(gd.SHOT_3D_WORKLOAD, 0)) workload "+
       " from rpt_gp_daily gd where gd.project_info_no = '<%=projectInfoNo%>'  "+
         "  and gd.bsflag = '0' order by gd.send_date asc";
		cruConfig.currentPageUrl = "/op/costMangerVersion/costManagerVersion.jsp";
		queryData(ids);
	}

	function loadDataDetail(ids){
		
	}
	
	 function getSum(){
			var project_info_no = '<%=projectInfoNo%>';
			var querySql = "select sum(nvl((nvl(gd.SHOT_2D_WORKLOAD, 0) + nvl(gd.SHOT_3D_WORKLOAD, 0))* (select nvl(max(t.price_unit),0)  from bgp_op_price_project_info t where t.project_info_no='<%=projectInfoNo%>'  and t.node_code='S01026'),0)) sum_value "+
		       " from rpt_gp_daily gd where gd.project_info_no = '<%=projectInfoNo%>' and gd.bsflag = '0'";
			var retObj = syncRequest('Post','<%=contextPath%>/rad/asyncQueryList.srq','querySql='+querySql);
			if(retObj!=null && retObj.returnCode=='0'&& retObj.datas!=null && retObj.datas[0]!=null){
				debugger;
				var sum_value = retObj.datas[0].sum_value;
				document.getElementById("sum_value").innerHTML = "合计:"+sum_value;
			}	
		}
</script>
</html>