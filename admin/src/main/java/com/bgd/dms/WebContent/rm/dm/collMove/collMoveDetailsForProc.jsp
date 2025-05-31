<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String devMovId = request.getParameter("devMovId");
	if(projectInfoNo==null||"".equals(projectInfoNo)){
		UserToken user = OMSMVCUtil.getUserToken(request); 
		projectInfoNo= user.getProjectInfoNo();
	}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>配置计划审批明细页面</title> 
 </head> 
 <body class="bgColor_f3f3f3" onload="refreshData()">
 <form name="form1" id="form1" method="post" action="" target="target_id">
      	<div id="list_table">
			<div id="table_box" style="overflow-y:srcoll;height:550px">
			<fieldset style="margin-left:2px;width:98%"><legend>申请基本信息</legend>
		      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		        <tr>
		         <td class="inquire_item4" >转出项目:</td>
		          <td class="inquire_form4" >
		          	<input name="out_project_name" id="out_project_name" class="input_width" type="text"  value="" readonly/>
		          	<input name="out_project_no" id="out_project_no" class="input_width" type="hidden"  value="" readonly/>
		          </td>
		          <td class="inquire_item4" >转入项目:</td>
		          <td class="inquire_form4" >
		          	<input name="in_project_name" id="in_project_name" class="input_width" type="text"  value="" readonly/>
		          	<input name="in_project_no" id="in_project_no" class="input_width" type="hidden"  value="" readonly/>
		          </td>
		          </tr>
		          <tr>
		          <td class="inquire_item4" >申请单号:</td>
		          <td class="inquire_form4" >
		          	<input name="dev_mov_no" id="dev_mov_no" class="input_width" type="text"  value="" readonly/>
		          	<input name="dev_mov_id" id="dev_mov_id" class="input_width" type="hidden"  value="<%=devMovId%>" readonly/>
		          	<input name="dev_collproc_status" id="dev_collproc_status" class="input_width" type="hidden"  value="" readonly/>
		          </td>
		          <td class="inquire_item4" >申请单名称:</td>
		          <td class="inquire_form4" >
		          	<input name="dev_mov_name" id="dev_mov_name" class="input_width" type="text"  value="" readonly/>
		          </td>
		        </tr>
		       </table>
		      </fieldset>
		      <div id="dantaidiv" style="display:none">
			     <fieldset style="margin-left:2px;width:98%"><legend>设备明细</legend>
				  <table style="width:98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
				     <tr id='device_appdet_id_{device_allapp_detid}' name='device_allapp_detid'>
				     	<td class="bt_info_odd" >序号</td>
						<td class="bt_info_even" width="10%">设备名称</td>
							<td class="bt_info_odd" width="10%">规格型号</td>
							<td class="bt_info_even" width="5%">单位</td>
							<td class="bt_info_odd" width="8%">总数量</td>
							<td class="bt_info_even" width="8%">在队数量</td>
							<td class="bt_info_odd" width="8%">离队数量</td>
							<td class="bt_info_even" width="8%">本次转移数量</td>
							<td class="bt_info_odd" width="13%">实际进场时间</td>
							<td class="bt_info_even" width="13%">实际离场时间</td>
				     </tr>
				     <tbody id="detailList0" name="detailList0"></tbody>
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
		 <div id="oper_div" >
	
	<%
	String isDone = request.getParameter("isDone");
	if(isDone == null || !isDone.equals("1")){
		%>
		  <span class="pass_btn" title="审批通过"><a href="#" onclick="submitInfo(1);changeSub(1);"></a></span>
	        <span class="nopass_btn" title="审批不通过"><a href="#" onclick="submitInfo(0);changeSub(0);"></a></span>
		<%
	}
	%>
	    </div>
	</div>
</form>
<iframe style="display: none;" id="target_id" name="target_id"></iframe>
</body>
<script type="text/javascript">
	
	function getContentTab(obj,index) { 
		$("LI","#tag-container_3").removeClass("selectTag");
		var contentSelectedTag = obj.parentElement;
		contentSelectedTag.className ="selectTag";

		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		$(filternotobj).hide();
		$(filterobj).show();
	}
	$(document).ready(lashen);
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNos = '<%=projectInfoNo%>';

	function refreshData(){
	
		var str = "select wfmiddle.proc_status,mov.dev_mov_no,mov.out_project_info_id,mov.in_project_info_id,mov.dev_mov_name,outgp.project_name as out_project_name,";
		str+="ingp.project_name as in_project_name,dui.dev_name,dui.dev_model,d.coding_name as dev_unit,dui.total_num,dui.unuse_num,nvl(dui.use_num,0) as use_num,movdet.mov_num,";
		str+="dui.actual_in_time,movdet.actual_out_time from gms_device_move mov left join gms_device_move_detail movdet on mov.dev_mov_id=movdet.dev_mov_id ";
		str+="left join gms_device_coll_account_dui dui on movdet.dev_acc_id=dui.dev_acc_id left join gp_task_project outgp on mov.out_project_info_id=outgp.project_info_no ";
		str+="left join common_busi_wf_middle wfmiddle on mov.dev_mov_id = wfmiddle.business_id ";
		str+="left join gp_task_project ingp on mov.in_project_info_id=ingp.project_info_no ";
		str+="and mov.in_project_info_id=ingp.project_info_no left join comm_coding_sort_detail d on dui.dev_unit=d.coding_code_id where mov.dev_mov_id='<%=devMovId%>' and mov.bsflag='0'";
		var detailRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=10000');
		var retObj = detailRet.datas;
		if(retObj && retObj.length>0){
			for(var index=0;index<retObj.length;index++){
				if(index == 0 ){
					$("#dev_mov_no").val(retObj[index].dev_mov_no);
					$("#dev_mov_name").val(retObj[index].dev_mov_name);
					$("#out_project_name").val(retObj[index].out_project_name);
					$("#in_project_name").val(retObj[index].in_project_name);
					$("#out_project_no").val(retObj[index].out_project_info_id);
					$("#in_project_no").val(retObj[index].in_project_info_id);
					$("#dev_collproc_status").val(retObj[index].proc_status);
				}
				var seqinfo = retObj[index].seqinfo;
				var dev_name = retObj[index].dev_name;
				var dev_model = retObj[index].dev_model;
				
				//动态新增表格
				var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
				innerhtml += "<td>"+(index+1)+"</td>";
				innerhtml += "<td>"+dev_name+"</td>";
				innerhtml += "<td>"+dev_model+"</td>";
				innerhtml += "<td>"+retObj[index].dev_unit+"</td>";
				innerhtml += "<td>"+retObj[index].total_num+"</td>";
				innerhtml += "<td>"+retObj[index].unuse_num+"</td>";
				innerhtml += "<td>"+retObj[index].use_num+"</td>";
				innerhtml += "<td>"+retObj[index].mov_num+"</td>";
				innerhtml += "<td>"+retObj[index].actual_in_time+"</td>";
				innerhtml += "<td>"+retObj[index].actual_out_time+"</td>";
				innerhtml += "</tr>";
				
				$("#detailList0").append(innerhtml);
			}
			$("#detailList0>tr:odd>td:odd").addClass("odd_odd");
			$("#detailList0>tr:odd>td:even").addClass("odd_even");
			$("#detailList0>tr:even>td:odd").addClass("even_odd");
			$("#detailList0>tr:even>td:even").addClass("even_even");
			$("#dantaidiv").show();
		}
	}
	
	function submitInfo(oprinfo){
		var oprstate;
		if(oprinfo==1){
			oprstate = "pass";
		}else{
			oprstate = "notPass";
		}
		
		document.getElementById("isPass").value=oprstate;
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toUpStateInfowfpa.srq";
		document.getElementById("form1").submit();
	}

	function changeSub(oprinfo){
		var oprstate;
		if(oprinfo==1){
			oprstate = "pass";
		}else{
			oprstate = "notPass";
		}
		
		if(confirm("确认提交？")){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveCollMoveAuditInfowfpa.srq?oprstate="+oprstate;
			document.getElementById("form1").submit();
		}
		window.setTimeout(function(){window.close();},1000);
	}
</script>
</html>