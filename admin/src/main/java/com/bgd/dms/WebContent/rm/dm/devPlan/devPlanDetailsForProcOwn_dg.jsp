<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String deviceallappid = request.getParameter("deviceallappid");
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
		          <td class="inquire_item4" >项目名称:</td>
		          <td class="inquire_form4" >
		          	<input name="project_name" id="project_name" class="input_width" type="text"  value="" readonly/>
		          	<input name="projectInfoNo" id="projectInfoNo" type="hidden" value="<%=projectInfoNo%>" />
		          </td>
		          <td class="inquire_item4" >申请单名称:</td>
		          <td class="inquire_form4" >
		          	<input name="device_allapp_name" id="device_allapp_name" class="input_width" type="text"  value="" readonly/>
		          </td>
		        </tr>
		        <tr>
			          <td class="inquire_item4" >申请单位：</td>
			          <td class="inquire_form4" >
			          	<input name="org_name" id="org_name" class="input_width" type="text"  value="" readonly/>
			          </td>
			          <td class="inquire_item4" >申请人名称:</td>
			          <td class="inquire_form4" >
			          	<input name="username" id="username" class="input_width" type="text"  value="" readonly/>
			          </td>
			        </tr>
			        <tr>
			          <td class="inquire_item4" >计划单号：</td>
			          <td class="inquire_form4" >
			          	<input name="device_allapp_no" id="device_allapp_no" class="input_width" type="text"  value="" readonly/>
			          </td>
			          <td class="inquire_item4" ></td>
			          <td class="inquire_form4" >
			          </td>
			        </tr>
		       </table>
		      </fieldset>
		       <div>
	  <ul id="tags" class="tags">
	    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">单台管理</a></li>
	    <li id="tag3_1"><a href="#" onclick="getTab3(1)">地震仪器（道）</a></li>
	    <li id="tag3_2"><a href="#" onclick="getTab3(2)">检波器</a></li>
	  </ul>
	</div>
		      
		      <div id="tab_box_content0" style="display:none">
		      
			     <fieldset style="margin-left:2px;width:98%"><legend>单台管理设备</legend>
				  <table style="width:98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
				     <tr id='device_appdet_id_{device_allapp_detid}' name='device_allapp_detid'>
				     	<td class="bt_info_odd" >序号</td>
						<td class="bt_info_even">班组</td>
						<td class="bt_info_odd">设备名称</td>
						<td class="bt_info_even">规格型号</td>
						<td class="bt_info_odd">单位</td>
						<td class="bt_info_even">需求数量</td>
						<td class="bt_info_odd"><font color='red'>审批数量</font></td>
						<td class="bt_info_even">计划开始时间</td>
						<td class="bt_info_odd">计划结束时间</td>
						<td class="bt_info_even">备注</td>
				     </tr>
				     <tbody id="detailList0" name="detailList0"></tbody>
				  </table>
				 </fieldset>
			 </div>
			 <div id="tab_box_content1" style="display:none">
				 <fieldset style="margin-left:2px;width:98%"><legend>地震仪器管理设备</legend>
				  <table style="width:98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
				     <tr id='device_appdet_id_{device_allapp_detid}' name='device_allapp_detid'>
				     	<td class="bt_info_odd" >序号</td>
						<td class="bt_info_even">班组</td>
						<td class="bt_info_odd">设备名称</td>
						<td class="bt_info_even">规格型号</td>
						<td class="bt_info_odd">单位</td>
						<td class="bt_info_even">需求道数</td>
						<td class="bt_info_odd"><font color='red'>审批道数</font></td>
						<td class="bt_info_even">计划开始时间</td>
						<td class="bt_info_odd">计划结束时间</td>
						<td class="bt_info_even">备注</td>
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
		 <div id="oper_div" >
	
	<%
	String isDone = request.getParameter("isDone");
	if(isDone == null || !isDone.equals("1")){
		%>
		  <span class="pass_btn" title="审批通过"><a href="#" onclick="submitInfo(1)"></a></span>
	        <span class="nopass_btn" title="审批不通过"><a href="#" onclick="submitInfo(0)"></a></span>
		<%
	}
	%>
	    </div>
	</div>
</form>
<iframe style="display: none;" id="target_id" name="target_id"></iframe>
</body>
<script type="text/javascript">
var retObjDG = jcdpCallService("DevCommInfoSrv", "getDGallappType", "device_allapp_id=<%=deviceallappid%>");
var allappType=retObjDG.allappObj.allapp_type;
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
	var deviceallappids = '<%=deviceallappid%>';
	function refreshData(){
		var str = "select a.*,comm.org_abbreviation from ( select devapp.device_allapp_no,devapp.app_org_id,alldet.device_allapp_detid,alldet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, ";
		str += "p6.name as jobname,pro.project_name,alldet.dev_ci_code,devapp.device_allapp_name, ";
		str += "case when alldet.dev_name is null then (case when alldet.isdevicecode = 'N' then ci.dev_ci_name else ct.dev_ct_name end) else alldet.dev_name end as dev_ci_name,";
		str += "case when alldet.dev_type is null then (case when alldet.isdevicecode='N' then ci.dev_ci_model else '' end) else alldet.dev_type end as dev_ci_model, ";
		str += "alldet.apply_num,alldet.teamid,alldet.team, ";
		str += "alldet.purpose,alldet.employee_id,emp.employee_name, ";
		str += "alldet.plan_start_date,alldet.plan_end_date,'0' as seqinfo  ";
		str += "from gms_device_allapp_detail alldet ";
		str += "left join gms_device_allapp devapp on alldet.device_allapp_id = devapp.device_allapp_id ";
		str += "left join bgp_p6_activity p6 on alldet.teamid = p6.object_id ";
		str += "left join comm_coding_sort_detail teamsd on alldet.team = teamsd.coding_code_id ";
		str += "left join comm_coding_sort_detail sd on alldet.unitinfo = sd.coding_code_id ";
		str += "left join gp_task_project pro on alldet.project_info_no = pro.project_info_no ";
		str += "left join gms_device_codeinfo ci on alldet.dev_ci_code = ci.dev_ci_code ";
		str += "left join gms_device_codetype ct on alldet.dev_ci_code = ct.dev_ct_code ";
		str += "left join comm_human_employee emp on alldet.employee_id = emp.employee_id ";
		str += "where devapp.project_info_no = '"+projectInfoNos+"' and devapp.bsflag='0' and alldet.bsflag='0' ";
		str += "and alldet.device_allapp_id = '"+deviceallappids+"' ) a  inner join  comm_org_information comm on a.app_org_id=comm.org_id ";

		
		var detailRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=10000');
		var retObj = detailRet.datas;
		if(retObj && retObj.length>0){
			for(var index=0;index<retObj.length;index++){
				if(index == 0 ){
					$("#project_name").val(retObj[index].project_name);
					$("#device_allapp_name").val(retObj[index].device_allapp_name);
					$("#username").val(retObj[index].employee_name);
					$("#org_name").val(retObj[index].org_abbreviation);
					$("#device_allapp_no").val(retObj[index].device_allapp_no);
				}
				var seqinfo = retObj[index].seqinfo;
				var device_allapp_detid = retObj[index].device_allapp_detid;
				var project_name = retObj[index].project_name;
				var teamname = retObj[index].teamname;
				var unitname = retObj[index].unitname;
				var dev_ci_name = retObj[index].dev_ci_name;
				var dev_ci_model = retObj[index].dev_ci_model;
				var dev_ci_code = retObj[index].dev_ci_code;
				var apply_num = retObj[index].apply_num;
				var purpose = retObj[index].purpose;
				var startdate = retObj[index].plan_start_date;
				var enddate = retObj[index].plan_end_date;
				
				//动态新增表格
				var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
				innerhtml += "<td>"+(index+1)+"<input name='device_allapp_detid"+index+"' id='device_allapp_detid"+index+"' value='"+device_allapp_detid+"' type='hidden'/>";
				innerhtml += "<input name='managetype"+index+"' id='managetype"+index+"' value='"+seqinfo+"' type='hidden' /></td>";
				innerhtml += "<td><input name='teamname"+index+"' id='teamname"+index+"' style='line-height:15px' value='"+teamname+"' size='8' type='text' readonly/></td>";
				innerhtml += "<td><input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='"+dev_ci_name+"' size='10' type='text' readonly/></td>";
				innerhtml += "<td><input id='devicetype"+index+"' name='devicetype"+index+"' value='"+dev_ci_model+"' size='12'  type='text' readonly/></td>";
				innerhtml += "<td><input id='unitname"+index+"' name='unitname"+index+"' value='"+unitname+"' size='3' type='text' readonly/></td>";
				innerhtml += "<td><input id='applynum"+index+"' name='applynum"+index+"' value='"+apply_num+"' size='3' type='text' readonly/></td>";
				innerhtml += "<td><input id='neednum"+index+"' name='neednum"+index+"' value='"+apply_num+"' size='3' type='text' applynuminfo='"+apply_num+"' onkeyup='checkAppNum(this)'/></td>";
				innerhtml += "<td><input name='startdate"+index+"' id='startdate"+index+"' style='line-height:15px' size='10' value='"+startdate+"' type='text' readonly/></td>";
				innerhtml += "<td><input name='enddate"+index+"' id='enddate"+index+"' style='line-height:15px' size='10' value='"+enddate+"' type='text' readonly/></td>";
				innerhtml += "<td><input id='purpose"+index+"' name='purpose"+index+"' style='line-height:15px' value='"+purpose+"' size='8' type='text' readonly/></td>";
				innerhtml += "</tr>";
				
				$("#detailList0").append(innerhtml);
			}
			$("#detailList0>tr:odd>td:odd").addClass("odd_odd");
			$("#detailList0>tr:odd>td:even").addClass("odd_even");
			$("#detailList0>tr:even>td:odd").addClass("even_odd");
			$("#detailList0>tr:even>td:even").addClass("even_even");
			$("#tab_box_content0").show();
		}
		str = "select alldet.device_allapp_detid,alldet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, ";
		str += "p6.name as jobname,pro.project_name,alldet.dev_name_input as dev_ci_name,devtype.coding_name as dev_ci_model, ";
		str += "alldet.apply_num,alldet.teamid,alldet.team, ";
		str += "alldet.purpose,alldet.employee_id,emp.employee_name, ";
		str += "alldet.plan_start_date,alldet.plan_end_date,'1' as seqinfo  ";
		str += "from gms_device_allapp_colldetail alldet ";
		str += "left join gms_device_allapp devapp on alldet.device_allapp_id = devapp.device_allapp_id ";
		str += "left join bgp_p6_activity p6 on alldet.teamid = p6.object_id ";
		str += "left join comm_coding_sort_detail devtype on alldet.dev_codetype = devtype.coding_code_id ";
		str += "left join comm_coding_sort_detail teamsd on alldet.team = teamsd.coding_code_id ";
		str += "left join comm_coding_sort_detail sd on alldet.unitinfo = sd.coding_code_id ";
		str += "left join gp_task_project pro on alldet.project_info_no = pro.project_info_no ";
		str += "left join comm_human_employee emp on alldet.employee_id = emp.employee_id ";
		str += "where devapp.project_info_no = '"+projectInfoNos+"' and devapp.bsflag='0' and alldet.bsflag='0' ";
		str += "and alldet.device_allapp_id = '"+deviceallappids+"' ";

		var detailRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=10000');
		var retObj = detailRet.datas;
		if(retObj && retObj.length>0){
			for(var index=0;index<retObj.length;index++){
				var collseqinfo = retObj[index].seqinfo;
				var colldevice_allapp_detid = retObj[index].device_allapp_detid;
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
				innerhtml += "<td>"+(index+1)+"<input name='colldevice_allapp_detid"+index+"' id='colldevice_allapp_detid"+index+"' value='"+colldevice_allapp_detid+"' type='hidden'/>";
				innerhtml += "<input name='collmanagetype"+index+"' id='collmanagetype"+index+"' value='"+collseqinfo+"' type='hidden' /></td>";
				innerhtml += "<td><input name='collteamname"+index+"' id='collteamname"+index+"' style='line-height:15px' value='"+collteamname+"' size='8' type='text' readonly/></td>";
				innerhtml += "<td><input name='colldevicename"+index+"' id='colldevicename"+index+"' style='line-height:15px' value='"+colldev_ci_name+"' size='10' type='text' readonly/></td>";
				innerhtml += "<td><input id='colldevicetype"+index+"' name='colldevicetype"+index+"' value='"+colldev_ci_model+"' size='12'  type='text' readonly/></td>";
				innerhtml += "<td><input id='collunitname"+index+"' name='collunitname"+index+"' value='"+collunitname+"' size='3' type='text' readonly/></td>";
				innerhtml += "<td><input id='collapplynum"+index+"' name='collapplynum"+index+"' value='"+collapply_num+"' size='3' type='text' readonly/></td>";
				innerhtml += "<td><input id='collneednum"+index+"' name='collneednum"+index+"' value='"+collapply_num+"' size='3' type='text' applynuminfo='"+collapply_num+"' onkeyup='checkAppNum(this)'/></td>";
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
			$("#tab_box_content1").show();
		}
	}
	function checkAppNum(obj){
		var re = /^\+?[1-9][0-9]*$/;
		var applynuminfo = obj.applynuminfo;
		//检查所有的数量字段 
		if(!re.test(obj.value)){
			alert("审批数量必须为数字，且大于0!");
			obj.value = "";
		}
	}
	function submitInfo(oprinfo){
		var oprstate;
		if(oprinfo==1){
			oprstate = "pass";
			
			if(allappType=='S9999'){
				retObj = jcdpCallService("DevCommInfoSrv", "createDgHireappInfo", "device_allapp_id="+deviceallappids);
			}	
		}else{
			oprstate = "notPass";
		}
		var allfillflag = true;
		$("input[type='text'][name^='neednum']").each(function(i){
			if(this.value == ""){
				if(allfillflag == true){
					allfillflag = false;
				}
			}
		});
		$("input[type='text'][name^='collneednum']").each(function(i){
			if(this.value == ""){
				if(allfillflag == true){
					allfillflag = false;
				}
			}
		});
		if(!allfillflag){
			alert("存在未填写的审批信息，请检查!");
			return;
		}
		var count = $("input[type='text'][name^='neednum']").size();
		var collcount = $("input[type='text'][name^='collneednum']").size();
		if(count == 0 && collcount == 0 ){
			alert('不存在明细信息!');
			return;
		}
		
		document.getElementById("isPass").value=oprstate;
		if(confirm("确认提交？")){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveDevAllAppAuditInfowfpa.srq?count="+count+"&collcount="+collcount+"&oprstate="+oprstate;
			document.getElementById("form1").submit();
		}
			
		window.setTimeout(function(){window.close();},2000);
	}
	var selectedTagIndex=0;

	function getTab3(index) {  
		var selectedTag = document.getElementById("tag3_"+selectedTagIndex);
		var selectedTabBox = document.getElementById("tab_box_content"+selectedTagIndex)
		selectedTag.className ="";
		selectedTabBox.style.display="none";

		selectedTagIndex = index;
		
		selectedTag = document.getElementById("tag3_"+selectedTagIndex);
		selectedTabBox = document.getElementById("tab_box_content"+selectedTagIndex)
		selectedTag.className ="selectTag";
		selectedTabBox.style.display="block";
	}
</script>
</html>