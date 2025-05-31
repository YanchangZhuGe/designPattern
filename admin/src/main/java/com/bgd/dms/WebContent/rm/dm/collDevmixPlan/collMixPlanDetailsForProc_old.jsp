<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo");
	String deviceappid = request.getParameter("deviceappid");
	ResourceBundle rb  = ResourceBundle.getBundle("devCodeDesc");
	String collMixFlag = null;
	if(rb != null){
		collMixFlag = rb.getString("CollMixFlag");
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>已添加的采集设备调配明细页面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
 	<form name="form1" id="form1" method="post" action="">
      	<div id="list_table">
			<div id="table_box" >
				<fieldset style="margin-left:2px;width:98%"><legend>申请基本信息</legend>
			      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			        <tr>
			          <td class="inquire_item4" >项目名称:</td>
			          <td class="inquire_form4" >
			          	<input name="project_name" id="project_name" class="input_width" type="text"  value="" readonly/>
			          	<input name="projectInfoNo" id="projectInfoNo" type="hidden" value="<%=projectInfoNo%>" />
			          </td>
			          <td class="inquire_item4" >申请单名称:</td>
			          <td class="inquire_form4" >
			          	<input name="device_app_name" id="device_app_name" class="input_width" type="text"  value="" readonly/>
			          </td>
			        </tr>
			       </table>
			      </fieldset>
			      <div id="table_box">
			      	<fieldset style="margin-left:2px;width:98%"><legend>申请明细</legend>
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
					     <tr id='device_appdet_id_{device_app_detid}' name='device_app_detid'>
							<td class="bt_info_even">序号</td>
							<td class="bt_info_odd" >班组</td>
							<td class="bt_info_even">申请名称</td>
							<td class="bt_info_odd">申请型号</td>
							<td class="bt_info_even">单位</td>
							<td class="bt_info_odd">申请道数</td>
							<td class="bt_info_even">计划开始时间</td>
							<td class="bt_info_odd">计划结束时间</td>
							<td class="bt_info_even">用途</td>
					     </tr> 
						  <tbody id="detailList1" name="detailList1"></tbody>
					  </table>
					 </fieldset>
					</div>
					<div id="tag-container_3" style="display:block;">
					  <ul id="tags" class="tags">
					    <li class="selectTag" id="tag3_1"><a href="#" onclick="getContentTab(this,2)">审批明细</a></li>
					  </ul>
					</div>
					<div id="tab_box" class="tab_box">
					<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="display:block;">
						<wf:getProcessInfo />
					</div>
				</div>
			 </div> 
			 <div id="oper_div">
		        <span class="qc" title="审批不通过"><a href="#" onclick="submitInfo(0)"></a></span>
		        <span class="tj" title="审批通过"><a href="#" onclick="submitInfo(1)"></a></span>
		    </div>
		</div>
	</form>
</body>
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNos = '<%=projectInfoNo%>';
	var idinfo = '<%=deviceappid%>';

	function refreshData(){
		//查询基本信息也带过来
		
		var str = "select appdet.device_app_detid,appdet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, ";
		str += "p6.name as jobname,pro.project_name,appdet.dev_name_input as dev_ci_name,devtype.coding_name as dev_ci_model, ";
		str += "appdet.apply_num,appdet.teamid,appdet.team,devapp.device_app_name, ";
		str += "appdet.purpose,appdet.employee_id,emp.employee_name, ";
		str += "appdet.plan_start_date,appdet.plan_end_date  ";
		str += "from gms_device_app_colldetail appdet ";
		str += "left join gms_device_collapp devapp on appdet.device_app_id = devapp.device_app_id ";
		str += "left join bgp_p6_activity p6 on appdet.teamid = p6.object_id ";
		str += "left join comm_coding_sort_detail devtype on appdet.dev_codetype = devtype.coding_code_id ";
		str += "left join comm_coding_sort_detail teamsd on appdet.team = teamsd.coding_code_id ";
		str += "left join comm_coding_sort_detail sd on appdet.unitinfo = sd.coding_code_id ";
		str += "left join gp_task_project pro on appdet.project_info_no = pro.project_info_no ";
		str += "left join comm_human_employee emp on appdet.employee_id = emp.employee_id ";
		str += "where devapp.device_app_id = '"+idinfo+"' and appdet.bsflag='0' ";
		str += "and devapp.bsflag = '0' ";
		
		var detailRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=10000');
		var retObj = detailRet.datas;
		if(retObj && retObj.length>0){
			for(var index=0;index<retObj.length;index++){
				var device_app_detid = retObj[index].device_app_detid;
				var collseqinfo = retObj[index].seqinfo;
				var collproject_name = retObj[index].project_name;
				var collteamname = retObj[index].teamname;
				var collunitname = retObj[index].unitname;
				var colldev_ci_name = retObj[index].dev_ci_name;
				var colldev_ci_model = retObj[index].dev_ci_model;
				var collapply_num = retObj[index].apply_num;
				var collpurpose = retObj[index].purpose;
				var collstartdate = retObj[index].plan_start_date;
				var collenddate = retObj[index].plan_end_date;
				
				//动态新增表格
				var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
				innerhtml += "<td>"+(index+1)+"<input name='colldevice_app_detid' id='colldevice_app_detid"+index+"' value='"+device_app_detid+"' type='hidden'/></td>";
				innerhtml += "<td><input name='collteamname"+index+"' id='collteamname"+index+"' style='line-height:15px' value='"+collteamname+"' size='8' type='text' readonly/></td>";
				innerhtml += "<td><input name='colldevicename"+index+"' id='colldevicename"+index+"' style='line-height:15px' value='"+colldev_ci_name+"' size='10' type='text' readonly/></td>";
				innerhtml += "<td><input id='colldevicetype"+index+"' name='colldevicetype"+index+"' value='"+colldev_ci_model+"' size='12'  type='text' readonly/></td>";
				innerhtml += "<td><input id='collunitname"+index+"' name='collunitname"+index+"' value='"+collunitname+"' size='3' type='text' readonly/></td>";
				innerhtml += "<td><input id='collapplynum"+index+"' name='collapplynum"+index+"' value='"+collapply_num+"' size='3' type='text' readonly/></td>";
				innerhtml += "<td><input name='collstartdate"+index+"' id='collstartdate"+index+"' style='line-height:15px' size='10' value='"+collstartdate+"' type='text' readonly/></td>";
				innerhtml += "<td><input name='collenddate"+index+"' id='collenddate"+index+"' style='line-height:15px' size='10' value='"+collenddate+"' type='text' readonly/></td>";
				innerhtml += "<td><input id='collpurpose"+index+"' name='collpurpose"+index+"' value='"+collpurpose+"' size='8' type='text' readonly/></td>";
				innerhtml += "</tr>";
				
				$("#detailList1").append(innerhtml);
			}
			$("#detailList1>tr:odd>td:odd").addClass("odd_odd");
			$("#detailList1>tr:odd>td:even").addClass("odd_even");
			$("#detailList1>tr:even>td:odd").addClass("even_odd");
			$("#detailList1>tr:even>td:even").addClass("even_even");
		}
		
	}
</script>
<script type="text/javascript">	
	function submitInfo(oprinfo){
		var oprstate;
		if(oprinfo==1){
			oprstate = "pass";
		}else{
			oprstate = "notPass";
		}
		var collcount = $("input[type='hidden'][name='colldevice_app_detid']").size();
		if(collcount == 0 ){
			alert('不存在明细信息!');
			return;
		}
		
		document.getElementById("isPass").value=oprstate;
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveCollDevAppAuditInfowfpa.srq?deviceappid=<%=deviceappid%>&oprstate="+oprstate;
		document.getElementById("form1").submit();
	}
	
</script>
</html>