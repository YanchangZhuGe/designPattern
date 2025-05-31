<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String projectInfoNo = user.getProjectInfoNo();
	if(projectInfoNo==null || projectInfoNo.trim().equals("")){
		projectInfoNo = "";
	}
	String projectName = user.getProjectName();
	if(projectName==null || projectName.trim().equals("")){
		projectName = "";
	}
	String orgId = user.getOrgId();
	if(orgId==null || orgId.trim().equals("")){
		orgId = "";
	}
	String orgName = user.getOrgName();
	if(orgName==null || orgName.trim().equals("")){
		orgName = "";
	}
	boolean proc_status = OPCommonUtil.getProcessStatus2("BGP_OP_TARGET_PROJECT_INFO","gp_target_project_id","5110000004100000014",projectInfoNo);
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
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<style type="text/css" >
</style>
<script type="text/javascript" >
	
</script>
<title>列表页面</title>
</head>
<body style="background:#fff" >
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						 	<td>&nbsp;</td>
						 	<td align="right" style="padding-right: 20px;"><font color="red"><span id="sum_value"></span></font></td>
							<%if(proc_status){ %>
						 	<auth:ListButton functionId="OP_ADJUST_PE_EDIT" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
						    <auth:ListButton functionId="OP_ADJUST_PE_EDIT" css="xg" event="onclick='toModify()'" title="JCDP_btn_edit"></auth:ListButton>
						    <auth:ListButton functionId="OP_ADJUST_PE_EDIT" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
							<%} %>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>
			  <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{cost_human_id}' onclick=check(this)/>" >
			  	<input type='checkbox' name='chk_entity_id' value='' onclick='check(this)'/></td>
			  <td class="bt_info_even" autoOrder="1">序号</td> 
			  <td class="bt_info_odd" exp="{person_num}">人数</td>
			  <td class="bt_info_even" exp="{apply_team}">人数</td>
			  <td class="bt_info_odd" exp="{change_date}">变更日期</td>
			  <td class="bt_info_even" exp="{start_loc}">起始地点</td>
			  <td class="bt_info_odd" exp="{end_loc}">到达地点</td>
			  <td class="bt_info_even" exp="{person_money}">单价（元）</td>
			  <td class="bt_info_odd" exp="{other_money}">其他费用（元）</td>
			  <td class="bt_info_even" exp="{total_money}" onclick="getSum()">总计(元)</td>
			</tr>
		</table>
	</div> 
	<div id="fenye_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	function setTabBoxHeight(){
		$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-8);
	}
	var project = '<%=projectInfoNo%>';
	function refreshData(){
		cruConfig.queryStr = "select t.*,to_char(nvl(t.person_num,0)*nvl(t.person_money,0)+nvl(other_money,0),'9999999999999999.00') total_money from BGP_OP_TARGET_DEVICE_HUM t where bsflag='0' and (t.if_change ='0' or t.if_change ='1') and nvl(t.if_delete_change,0)!=1 and t.project_info_no ='"+project+"'";
		setTabBoxHeight();
		queryData(1);
	}
	refreshData();
	/* 详细信息 */
	function loadDataDetail(clickId){
	}
	function toAdd(){
		popWindow(cruConfig.contextPath+"/op/costTargetAdjust/costTargetAdjustDeviceHEdit.upmd?pagerAction=edit2Add&projectInfoNo=<%=projectInfoNo%>");
	}
	function toModify(){
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
			popWindow(cruConfig.contextPath+"/op/costTargetAdjust/costTargetAdjustDeviceHEdit.upmd?pagerAction=edit2Edit&id="+ids+"&projectInfoNo=<%=projectInfoNo%>");
	}
	function toDelete(){
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		if (!window.confirm("确认要删除吗?")) {
			return;
		}
		ids = ids.replace(/\,/g,"','");
		var sql = "update BGP_OP_TARGET_DEVICE_HUM t set t.if_delete_change='1' where t.COST_HUMAN_ID in('"+ids+"')";

		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids="+ids;
		syncRequest('Post',path,params);
		refreshData();
	}
	
	function frameSize(){
		setTabBoxHeight();
	}
	frameSize();
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	})	
	$(document).ready(lashen);
	
	 function getSum(){
			var project_info_no = '<%=projectInfoNo%>';
			var querySql = "select sum(nvl(to_char(nvl(t.person_num,0)*nvl(t.person_money,0)-(-nvl(other_money,0)),'9999999999999999.00'),0)) sum_value"+
				" from bgp_op_target_device_hum t where t.project_info_no='<%=projectInfoNo%>' and (t.if_change ='0' or t.if_change ='1') and nvl(t.if_delete_change,0)!=1 and t.bsflag='0'";
			var retObj = syncRequest('Post','<%=contextPath%>/rad/asyncQueryList.srq','querySql='+querySql);
			if(retObj!=null && retObj.returnCode=='0'&& retObj.datas!=null && retObj.datas[0]!=null){
				debugger;
				var sum_value = retObj.datas[0].sum_value;
				document.getElementById("sum_value").innerHTML = "合计:"+sum_value;
			}	
		}
</script>

</body>
</html>
