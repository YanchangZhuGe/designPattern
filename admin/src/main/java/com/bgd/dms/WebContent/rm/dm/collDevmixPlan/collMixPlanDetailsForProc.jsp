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
	String projectType = request.getParameter("projectType")==null?user.getProjectType():request.getParameter("projectType");
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
 
 <body style="background:#cdddef;overflow:auto" onload="refreshData()">
 	<form name="form1" id="form1" method="post" action="" target="target_id">
      	<div id="list_table" style="height:700px">
			<div id="table_box">
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
					     	<td class="bt_info_odd" >选择</td>
							<td class="bt_info_even">序号</td>
							<td class="bt_info_odd" >班组</td>
							<td class="bt_info_even">申请名称</td>
							<td class="bt_info_odd">申请型号</td>
							<td class="bt_info_even">单位</td>
							<td class="bt_info_odd">申请道数</td>
							<td class="bt_info_even">计划开始时间</td>
							<td class="bt_info_odd">计划结束时间</td>
							<td class="bt_info_even">用途</td>
							<td class="bt_info_odd"><font color='red'>备注</font></td>
					     </tr> 
						  <tbody id="detailList1" name="detailList1"></tbody>
					  </table>
					 </fieldset>
					  <fieldset>
					      	<table style="width:95%;" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					        <tr>
					          <!-- <td width="10%"><span class="jl"><a href="#" id="addbtn" onclick='toMixDetailInfos()' title="分配具体明细"></a></span></td>
					          <td width="30%"> -->
					          <td id="selectmodeltd" width="50%" align="right" style="display:none">
					          	<select id="selectmodel" name="selectmodel" class="select_width" style="width:180px">
					          		<option value="">请选择模板...</option>
					          	</select>&nbsp;&nbsp;&nbsp;&nbsp;
					          </td>
					          <td id="addtd" width="5%" align="right" style="display:none"><span class="zj"><a href="#" id="addbtn" onclick='toAddRowInfo()' title="新增"></a></span></td>
							  <td id="deltd" width="5%" align="right" style="display:none"><span class="sc"><a href="#" id="delbtn" onclick='toDelRowInfo()' title="删除"></a></span></td>
					        </tr>
					      </table>
						    <div id="tag-container_3" style="width:98%;">
							  <ul id="tags" class="tags">
							  </ul>
							</div>
							<div id="tab_box" class="tab_box" style="width:98%;height:170px;overflow:auto">
							</div>
					</fieldset>
					<fieldset style="margin-left:2px"><legend>附属设备</legend>
					  <table style="width:98%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				        <tr>
				          <td width="5%"><span class="zj"><a href="#" id="addaddedbtn" onclick='toAddAddedDetailInfos()' title="添加"></a></span></td>
				          <td width="5%"><span class="sc"><a href="#" id="deladdedbtn" onclick='toDelAddedDetailInfos()' title="删除"></a></span></td>
				          <td width="90%"></td>
				        </tr>
				      </table>
					  <div id="tab_box" class="tab_box" style="height:120px;overflow:auto;">
							<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						       <tr>
									<td class="bt_info_odd" width="4%"><input type="checkbox" name="alldetinfo" id="alldetinfo" checked/></td>
									<td class="bt_info_even" width="8%">班组</td>
									<td class="bt_info_odd" width="12%">设备名称</td>
									<td class="bt_info_even" width="12%">规格型号</td>
									<td class="bt_info_odd" width="4%">计量单位</td>
									<td class="bt_info_even" width="10%">申请数量</td>
									<td class="bt_info_odd" width="10%">备注</td>
								</tr>
								<tbody id="addeddetailtable" name="addeddetailtable">
						    	</tbody>
							</table>
							<!-- <div style="height:90px;overflow:auto;">
								<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style='table-layout: auto'>
						   	 	<tbody id="addeddetailtable" name="addeddetailtable">
						    	</tbody>
								</table> -->
							</div>
							</fieldset>
						</div>			       
				    </div>

					<div id="tag-container_4" style="display:block;">
					  <ul id="tags" class="tags">
					    <li class="selectTag" id="tag3_1"><a href="#" onclick="getContentTab(this,2)">审批明细</a></li>
					  </ul>
					</div>
					<div id="tab_box" class="tab_box" style="width:98%">
						<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="display:block;width:98%">
							<wf:getProcessInfo/>
						</div>
					</div>
				</div>
			 	<div id="oper_div">
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
		
	</form>
	<iframe style="display: none;" id="target_id" name="target_id"></iframe>
</body>
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNos = '<%=projectInfoNo%>';
	var idinfo = '<%=deviceappid%>';
	var projectType="<%=projectType%>";
	var detailmainid;
	var addedseqinfo;
	function refreshData(){
		//查询基本信息也带过来		
		var str = "select appdet.device_app_id,appdet.device_app_detid,appdet.dev_codetype,appdet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, ";
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
				detailmainid = retObj[index].device_app_detid;
				var device_app_detid = retObj[index].device_app_detid;
				var device_app_id = retObj[index].device_app_id;
				var devcodetype = retObj[index].dev_codetype;
				var collseqinfo = retObj[index].seqinfo;
				var collproject_name = retObj[index].project_name;
				var collteamname = retObj[index].teamname;
				var collteam = retObj[index].team;
				var collunitname = retObj[index].unitname;
				var colldev_ci_name = retObj[index].dev_ci_name;
				var colldev_ci_model = retObj[index].dev_ci_model;
				var collapply_num = retObj[index].apply_num;
				var collpurpose = retObj[index].purpose;
				var collstartdate = retObj[index].plan_start_date;
				var collenddate = retObj[index].plan_end_date;
				
				//动态新增表格
				var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
					innerhtml += "<td><input type='checkbox' name='idinfo' id='"+index+"' value='"+device_app_detid+"' devcodetype='"+devcodetype+"' checked='true'/></td>";
					innerhtml += "<td>"+(index+1)+"<input name='colldevice_app_detid' id='colldevice_app_detid"+index+"' value='"+device_app_detid+"' type='hidden'/></td>";
					innerhtml += "<td><input name='collteamname"+index+"' id='collteamname"+index+"' style='line-height:15px' value='"+collteamname+"' size='8' type='text' readonly/></td>";
					innerhtml += "<input name='team"+index+"' id='teamid"+index+"' value='"+collteam+"' type='hidden'/></td>";
					innerhtml += "<td><input name='colldevicename"+index+"' id='colldevicename"+index+"' style='line-height:15px' value='"+colldev_ci_name+"' size='12' type='text' readonly/></td>";
					innerhtml += "<td><input id='colldevicetype"+index+"' name='colldevicetype"+index+"' value='"+colldev_ci_model+"' size='12'  type='text' readonly/></td>";
					innerhtml += "<td><input id='collunitname"+index+"' name='collunitname"+index+"' value='"+collunitname+"' size='3' type='text' readonly/></td>";
					innerhtml += "<td><input id='collapplynum"+index+"' name='collapplynum"+index+"' value='"+collapply_num+"' size='12' type='text' /></td>";
					innerhtml += "<td><input name='collstartdate"+index+"' id='collstartdate"+index+"' style='line-height:15px' size='10' value='"+collstartdate+"' type='text' readonly/></td>";
					innerhtml += "<td><input name='collenddate"+index+"' id='collenddate"+index+"' style='line-height:15px' size='10' value='"+collenddate+"' type='text' readonly/></td>";
					innerhtml += "<td><input id='collpurpose"+index+"' name='collpurpose"+index+"' value='"+collpurpose+"' size='8' type='text' readonly/></td>";
					innerhtml += "<td><a onclick='viewRemark("+"\""+device_app_id+"\""+")'>查看</a></td>";				
					innerhtml += "</tr>";
				
				$("#detailList1").append(innerhtml);
			}
			$("#detailList1>tr:odd>td:odd").addClass("odd_odd");
			$("#detailList1>tr:odd>td:even").addClass("odd_even");
			$("#detailList1>tr:even>td:odd").addClass("even_odd");
			$("#detailList1>tr:even>td:even").addClass("even_even");
		}
		//回填基本信息
		$("#project_name").val(retObj[0].project_name);
		$("#projectInfoNo").val(retObj[0].project_info_no);
		$("#device_app_name").val(retObj[0].device_app_name);
		toMixDetailInfos();
		var querySql = "select teamsd.coding_name as teamname,mix.team,mix.device_name,mix.device_model,mix.unit_name as unit_id,tail.coding_name as unit_name,'' as a,";
			querySql += "mix.device_num,mix.mix_num,mix.devremark from gms_device_coll_mixsubadd mix left join comm_coding_sort_detail teamsd on mix.team = teamsd.coding_code_id ";
			querySql += "left join comm_coding_sort_detail tail on mix.unit_name = tail.coding_code_id ";
			querySql += "left join comm_coding_sort_detail d on mix.team=d.coding_code_id where mix.device_mixinfo_id='"+detailmainid+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql+'&pageSize=10000');
		var queryObj = queryRet.datas;
		if(queryObj.length>0){
			addedseqinfo = queryObj.length;
		}else{
			addedseqinfo=0;
		}
		if(queryObj && queryObj.length>0){
			var index;
			for(index=0;index<queryObj.length;index++){
				var innerhtml = "<tr id='traddedseq"+index+"' name='traddedseq"+index+"' seq='"+index+"' is_added='false'>";
				innerhtml += "<td width='4%'><input type='checkbox' name='addedseq' id='"+index+"' checked='true' /></td>";
				innerhtml += "<td width='12%'><input name='addedteamname"+index+"' id='addedteamname"+index+"' value='"+queryObj[index].teamname+"' style='line-height:18px;width:98%' size='10' type='text' readonly/>";
				innerhtml += "<input name='addedteam"+index+"' id='addedteam"+index+"'  value='"+queryObj[index].team+"' type='hidden' /></td>";
				innerhtml += "<td width='12%'><input name='addeddevicename"+index+"' id='addeddevicename"+index+"' idindex='"+index+"' value='"+queryObj[index].device_name+"' style='line-height:18px;width:98%' size='10' type='text' /></td>";
				innerhtml += "<td width='12%'><input name='addeddevicetype"+index+"' id='addeddevicetype"+index+"' value='"+queryObj[index].device_model+"' style='line-height:18px;width:98%' size='10' type='text' /></td>";
				innerhtml += "<td width='4%'><input name='addedunitname"+index+"' id='addedunitname"+index+"' value='"+queryObj[index].unit_name+"' style='line-height:18px;width:98%' size='8' type='text' /><input name='addedunit"+index+"' id='addedunit"+index+"' value='"+queryObj[index].unit_id+"' style='line-height:18px;width:98%' size='8' type='hidden' /></td>";
				innerhtml += "<td width='10%'><input name='addedassignnum"+index+"' id='addedassignnum"+index+"' style='line-height:18px;width:98%' value='"+queryObj[index].device_num+"' type='text' size='8' onkeyup='checkInputNum(this)'/></td>";
				innerhtml += "<td width='10%'><input name='addedremark"+index+"' id='addedremark"+index+"' value='"+queryObj[index].devremark+"' style='line-height:18px;width:98%' size='10' type='text' /></td>";
				innerhtml += "</tr>";
				$("#addeddetailtable").append(innerhtml);
			}
			$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
			$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
			$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
			$("#addeddetailtable>tr:even>td:even").addClass("even_even");
		}
	}
</script>
<script type="text/javascript">	
$().ready(function(){
	$("#alldetinfo").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='addedseq']").attr('checked',checkvalue);
	});
	
	$("#devbackinfo").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='didinfo']").attr('checked',checkvalue);
	});
});
	function submitInfo(oprinfo){
		//保留的行信息
		var count = 0;
		var subcount = 0;
		var line_infos;
		var idinfos;
		var sub_line_infos;
		var oprstate;
		if(oprinfo==1){
			oprstate = "pass";
		}else{
			oprstate = "notPass";
		}
		$("input[type='checkbox'][name='idinfo']").each(function(){
			if(this.checked == true){
				var keyinfo = this.value;
				if(count == 0){
					line_infos = this.id;
					idinfos = keyinfo;
				}else{
					line_infos += "~"+this.id;
					idinfos += "~"+keyinfo;
				}
				$("input[type='checkbox'][name='didinfo']","#detailList"+keyinfo).each(function(i){
					if(count == 0 ){
						if(i==0){
							sub_line_infos = this.id;
						}else{
							sub_line_infos += "@"+this.id;
						}
					}else{
						if(i==0){
							sub_line_infos += this.id;
						}else{
							sub_line_infos += "@"+this.id;
						}
					}
				});
				if(sub_line_infos!=undefined && sub_line_infos.length>0){
					sub_line_infos += "~";
				}
				count++;
			}
		});
		if(oprstate == 'pass'){
			if(count == 0){
				alert('请选择调配设备申请明细信息！');
				return;
			}
		}
		if(oprstate == 'pass'){
			if(sub_line_infos == undefined){
				alert('请添加采集设备明细信息！');
				return;
			}
		}
		var selectedlines = line_infos.split("~");
		var wronglineinfos = "";
		for(var index=0;index<selectedlines.length;index++){
			var valueinfo = $("#applynum"+selectedlines[index]).val();
			if(valueinfo == ""){
				if(index == 0){
					wronglineinfos += (parseInt(selectedlines[index])+1);
				}else{
					wronglineinfos += ","+(parseInt(selectedlines[index])+1);
				}
			}
		}
		if(oprstate == 'pass'){
			if(wronglineinfos!=""){
				alert("请设置第"+wronglineinfos+"行明细的申请数量!");
				return;
			}else{
				var subwrongflag = false;
				//判断子表是否有未填的设备明细数量
				sub_line_infos = sub_line_infos.substr(0,sub_line_infos.length-1);
				var checkinfos = sub_line_infos.split("~",-1);
				for(var index=0;index<checkinfos.length;index++){
					var checkinfo = checkinfos[index];
					var checksubinfos = checkinfo.split("@",-1);
					for(var j=0;j<checksubinfos.length;j++){
						var valueinfo = $("#apply_num"+checksubinfos[index]).val();
						if(valueinfo == ""){
							subwrongflag = true;
						}
					}
				}
				if(subwrongflag){
					alert("请设置采集设备明细的需求数量!");
					return;
				}
			}
		}
		//补充明细的seq信息
		var addedcount = $("input[type='text'][name^='addeddevicename']","#addeddetailtable").size();
		var addedline_info;
		$("input[type='text'][name^='addeddevicename']","#addeddetailtable").each(function(i){
			var idindex = this.idindex;
			if(i==0){
				addedline_info = idindex;
			}else{
				addedline_info += "~"+idindex;
			}
		});
		var collcount = $("input[type='hidden'][name='colldevice_app_detid']").size();
		if(oprstate == 'pass'){
			if(collcount == 0 ){
				alert('不存在明细信息!');
				return;
			}
		}

		if(confirm("确认提交？")){
			document.getElementById("isPass").value=oprstate;
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveCollDevAppAuditInfowfpa.srq?deviceappid=<%=deviceappid%>&detailmainid="+detailmainid+"&oprstate="+oprstate+"&count="+count+"&idinfos="+idinfos+"&line_infos="+line_infos+"&sub_line_infos="+sub_line_infos+"&addedcount="+addedcount+"&addedline_info="+addedline_info;
			document.getElementById("form1").submit();
			
		}
		window.setTimeout(function(){window.close();},2000);
	}
	
	var seqinfo = 0;
	function toMixDetailInfos(){
		seqinfo++;
		var valueinfo ;
		$("input[type='checkbox'][name='idinfo']").each(function(){
			if(this.checked == true){
				valueinfo = this.value; 
			}
		});
		if(valueinfo == undefined)
			return;
		var size = $("div[id='tab_box_content"+valueinfo+"']","#tab_box").size();
		if(size==1){
			//给当前显示，其他的都隐藏
			$("div","#tab_box").hide();
			$("div[id='tab_box_content"+valueinfo+"']","#tab_box").show();
			//给标签页加个选中样式
			$("li","#tag-container_3").removeClass("selectTag");
			$("li[id='tag3_"+valueinfo+"']","#tag-container_3").addClass("selectTag");
		}else{
			var showid ;
			var showmodeltype ;
			$("input[type='checkbox'][name='idinfo']").each(function(){
				if(this.checked == true){
					showid = this.id;
					showmodeltype = this.devcodetype;
				}
			});
			var showname = $("#colldevicename"+showid).val()+"("+$("#colldevicetype"+showid).val()+")";
			var taginnerhtml = "<li id='tag3_"+valueinfo+"'><a href='#' onclick=getContentTab('"+valueinfo+"')>"+showname+"</a></li>";
			$("#tags").append(taginnerhtml);
			var containhtml = "<div style='width:97.5%' id='tab_box_content"+valueinfo+"' name='tab_box_content"+valueinfo+"' idinfo='"+valueinfo+"' style='width:97%' class='tab_box_content'>";
				containhtml += "<table border='0' cellpadding='0' cellspacing='0' class='tab_line_height' style='width:99%' style='margin-top:10px;background:#efefef'>";
				containhtml += "<tr class='bt_info'><td class='bt_info_odd'>选择</td><td class='bt_info_odd'>设备名称</td><td class='bt_info_even'>规格名称</td>";
				containhtml += "<td class='bt_info_odd'>计量单位</td><td class='bt_info_even'>道数</td><td class='bt_info_odd'>需求数量</td><td class='bt_info_even'>总道数</td></tr>";
				containhtml += "<tbody id='detailList"+valueinfo+"' name='detailList"+valueinfo+"'></tbody></table></div> ";
			$("#tab_box").append(containhtml);
			//给当前显示，其他的都隐藏
			$("div","#tab_box").hide();
			$("div[id='tab_box_content"+valueinfo+"']","#tab_box").show();
			//给标签页加个选中样式
			$("li","#tag-container_3").removeClass("selectTag");
			$("li[id='tag3_"+valueinfo+"']","#tag-container_3").addClass("selectTag");
			//模板归零
			var querySql = "select model_mainid,model_name from gms_device_collmodel_main main where main.bsflag='0' ";			
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql+'&pageSize=100');
				basedatas = queryRet.datas;
			if(basedatas!=undefined && basedatas.length>0){
				//回填基本信息
				for(var index=0;index<basedatas.length;index++){
					var innerhtml = "<option value='"+basedatas[index].model_mainid+"'>"+basedatas[index].model_name+"</option>";
					$("#selectmodel").append(innerhtml);
				}
			}
			//给模板放进内容 end
			$("#selectmodel").val("");
			$("#selectmodeltd").show();
			$("#addtd").show();
			$("#deltd").show();
		}
		var querySql = "select cds.device_id,cds.device_name,cds.device_model,detail.coding_name as unitname, unit_id,cds.device_slot_num,cds.device_num,device_slot_num*device_num as apply_num from gms_device_app_colldetsub cds left join gms_device_app_colldetail det on cds.device_app_detid=det.device_app_detid left join comm_coding_sort_detail detail on detail.coding_code_id = cds.unit_id where cds.device_app_detid = '"+detailmainid+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql+'&pageSize=10000');
		var queryObj = queryRet.datas;
		if(queryObj && queryObj.length>0){
			var index;
			for(index=0;index<queryObj.length;index++){
				var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seqinfo='"+index+"'>";
					innerhtml += "<td><input type='checkbox' name='didinfo' id='"+index+"' checked='true'/><input type='hidden' id='device_id"+index+"' name='device_id"+index+"' value='"+queryObj[index].device_id+"'></td>";
					innerhtml += "<td><input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='"+queryObj[index].device_name+"' size='30' type='text' readonly/></td>";
					innerhtml += "<td><input name='devicemodel"+index+"' id='devicemodel"+index+"' style='line-height:15px' value='"+queryObj[index].device_model+"' size='30' type='text' readonly/></td>";
					innerhtml += "<td><select id='unitList"+index+"' name='unitList"+index+"' style='select_width'></select></td>";
					innerhtml += "<td><input name='devslotnum"+index+"' id='devslotnum"+index+"' style='line-height:15px' value='"+queryObj[index].device_slot_num+"' size='6' type='text' /></td>";
					innerhtml += "<td><input name='apply_num"+index+"' id='apply_num"+index+"' checkinfo='"+index+"' style='line-height:15px' value='"+queryObj[index].device_num+"' size='10' type='text' onkeyup='checkInputNum(this)'/></td>";
					innerhtml += "<td><input name='totalslotnum"+index+"' id='totalslotnum"+index+"' style='line-height:15px' value='"+queryObj[index].apply_num+"' size='10' type='text' readonly/></td>";
					innerhtml += "</tr>";
				$("#detailList"+valueinfo).append(innerhtml);
			}
			$("#detailList"+valueinfo+">tr:odd>td:odd").addClass("odd_odd");
			$("#detailList"+valueinfo+">tr:odd>td:even").addClass("odd_even");
			$("#detailList"+valueinfo+">tr:even>td:odd").addClass("even_odd");
			$("#detailList"+valueinfo+">tr:even>td:even").addClass("even_even");
			var retObj;
			var unitSql = "select sd.coding_code_id,coding_name from comm_coding_sort_detail sd ";
				unitSql += "where coding_sort_id ='5110000038' order by coding_code";
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql+'&pageSize=1000');
				retObj = unitRet.datas;
			var optionhtml = "";
			var i=0;
			for(var index=0;index<retObj.length;index++){
				if(queryObj[i].unit_id == retObj[index].coding_code_id){
					optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"' selected>"+retObj[index].coding_name+"</option>";
				}else{
					optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
				}
			}
			for(;i<index;i++){
				$("#unitList"+i).append(optionhtml);
			}
		}
	}
	function toAddRowInfo(){
		var obj = new Object();
		var data=window.showModalDialog("<%=contextPath%>/rm/dm/collectTree/collectTreeManager.jsp?ctxmenu=false&inline=true",obj,"dialogWidth=300px;dialogHeight=400px");
		
		if(data!=undefined){
			//查找现在的显示标签页
			var divobj;
			$("div[name^='tab_box_content']","#tab_box").each(function(i){
				if(this.style.display == 'block'){
					divobj = this.idinfo;
				}
			});
			if(divobj == undefined)
				return;
			//查找最大的index
			var maxseqinfo = $("#detailList"+divobj+">tr:last").attr("seqinfo");
			if(maxseqinfo == undefined || maxseqinfo == ''){
				maxseqinfo = 0;
			}
			var currentseq = parseInt(maxseqinfo,10)+1;
			
			var mainsql = "select nvl(device_slot_num,0) as device_slot_num from gms_device_collmodel_sub sub ";
				mainsql += "where sub.device_id='"+data.device_id+"' ";
	 			
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+mainsql);
			retObj = proqueryRet.datas;
	
			var innerhtml = "<tr id='tr"+divobj+currentseq+"' name='tr"+divobj+currentseq+"' seqinfo='"+currentseq+"'>";
				innerhtml += "<td><input type='checkbox' name='didinfo' id='"+divobj+currentseq+"' checked='true'/><input type='hidden' id='device_id"+divobj+currentseq+"' name='device_id"+divobj+currentseq+"' value='"+data.device_id+"'></td>";
				innerhtml += "<td><input name='devicename"+divobj+currentseq+"' id='devicename"+divobj+currentseq+"' style='line-height:15px' value='"+data.dev_name+"' size='30' type='text' readonly/></td>";
				innerhtml += "<td><input name='devicemodel"+divobj+currentseq+"' id='devicemodel"+divobj+currentseq+"' style='line-height:15px' value='"+data.dev_model+"' size='30' type='text' readonly/></td>";
				innerhtml += "<td><select id='unitList"+divobj+currentseq+"' name='unitList"+divobj+currentseq+"' style='select_width'></select></td>";
			if(retObj!=undefined && retObj.length == 0){
				innerhtml += "<td><input name='devslotnum"+divobj+currentseq+"' id='devslotnum"+divobj+currentseq+"' style='line-height:15px' value='0' size='6' type='text' /></td>";
			}else{
				innerhtml += "<td><input name='devslotnum"+divobj+currentseq+"' id='devslotnum"+divobj+currentseq+"' style='line-height:15px' value='"+retObj[0].device_slot_num+"' size='6' type='text' /></td>";
			}			
			innerhtml += "<td><input name='apply_num"+divobj+currentseq+"' id='apply_num"+divobj+currentseq+"' checkinfo='"+divobj+currentseq+"' style='line-height:15px' value='' size='10' type='text' onkeyup='checkInputNum(this)'/></td>";
			innerhtml += "<td><input name='totalslotnum"+divobj+currentseq+"' id='totalslotnum"+divobj+currentseq+"' style='line-height:15px' value='' size='10' type='text' readonly/></td>";
			innerhtml += "</tr>";
			$("#detailList"+divobj).append(innerhtml);
			
			$("#detailList"+divobj+">tr:odd>td:odd").addClass("odd_odd");
			$("#detailList"+divobj+">tr:odd>td:even").addClass("odd_even");
			$("#detailList"+divobj+">tr:even>td:odd").addClass("even_odd");
			$("#detailList"+divobj+">tr:even>td:even").addClass("even_even");
			//给当前这个单位追加数据
			var retObj;
			var unitSql = "select sd.coding_code_id,coding_name from comm_coding_sort_detail sd ";
				unitSql += "where coding_sort_id ='5110000038' order by coding_code";
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql+'&pageSize=1000');
				retObj = unitRet.datas;
			var optionhtml = "";
			for(var index=0;index<retObj.length;index++){
				optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
			}
			$("#unitList"+divobj+currentseq).append(optionhtml);
		}
	}
	function toDelRowInfo(){
		//查找现在的显示标签页
		var divobj;
		$("div[name^='tab_box_content']","#tab_box").each(function(i){
			if(this.style.display == 'block'){
				divobj = this.idinfo;
			}
		})
		if(divobj == undefined)
			return;
		$("input[type='checkbox'][name='didinfo']","#detailList"+divobj).each(function(i){
			if(this.checked == true){
				var id=this.id;
				$("#tr"+id,"#detailList"+divobj).remove();
			}
		});
		$("#detailList"+divobj+">tr:odd>td:odd").addClass("odd_odd");
		$("#detailList"+divobj+">tr:odd>td:even").addClass("odd_even");
		$("#detailList"+divobj+">tr:even>td:odd").addClass("even_odd");
		$("#detailList"+divobj+">tr:even>td:even").addClass("even_even");
	}
	$().ready(function(){
		$("#selectmodel").change(function(){
			var value = $("#selectmodel").val();
			if(value == ''){
				return;
			}
			//获得当前显示的填报明细，给重新复制
			var divobj;
			$("div[name^='tab_box_content']","#tab_box").each(function(i){
				if(this.style.display == 'block'){
					divobj = this.idinfo;
				}
			})
			if(divobj == undefined)
				return;
			//先查询模板的子记录
			var querySql = "select sub.device_id,sub.device_name,sub.device_model,sub.unit_id,";
				querySql += "detail.coding_name as unit_name,sub.device_slot_num ";
				querySql += "from gms_device_collmodel_sub sub ";
				querySql += "left join gms_device_collectinfo ci on sub.device_id=ci.device_id ";
				querySql += "left join gms_device_collmodel_main main on main.model_mainid=sub.model_mainid ";
				querySql += "left join comm_coding_sort_detail detail on sub.unit_id=detail.coding_code_id ";
				querySql += "where main.bsflag='0' and sub.model_mainid='"+value+"' ";
				querySql += "order by (case sub.device_name when '电源站' then 'A' when '采集站' then 'B' ";
				querySql += "when '交叉站' then 'C' when '交叉线' then 'D' when '排列电缆' then 'E' end) ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
				basedatas = queryRet.datas;
			if(basedatas!=undefined && basedatas.length>0){
				$("#detailList"+divobj).empty();
				var lineinfo;
				//回填基本信息
				for(var index=0;index<basedatas.length;index++){
					lineinfo = index+1;
					var innerhtml = "<tr id='tr"+divobj+lineinfo+"' name='tr"+divobj+lineinfo+"' seqinfo='"+lineinfo+"'>";
					innerhtml += "<td><input type='checkbox' name='didinfo' id='"+divobj+lineinfo+"' checked='true'/><input type='hidden' id='device_id"+divobj+lineinfo+"' name='device_id"+divobj+lineinfo+"' value='"+basedatas[index].device_id+"'></td>";
					innerhtml += "<td><input name='devicename"+divobj+lineinfo+"' id='devicename"+divobj+lineinfo+"' style='line-height:15px' value='"+basedatas[index].device_name+"' size='30' type='text' readonly/></td>";
					innerhtml += "<td><input name='devicemodel"+divobj+lineinfo+"' id='devicemodel"+divobj+lineinfo+"' style='line-height:15px' value='"+basedatas[index].device_model+"' size='30' type='text' readonly/></td>";
					innerhtml += "<td><input name='unit_name"+divobj+lineinfo+"' id='unit_name"+divobj+lineinfo+"' style='line-height:15px' value='"+basedatas[index].unit_name+"' size='4' type='text' readonly/>";
					innerhtml += "<input name='unitList"+divobj+lineinfo+"' id='unitList"+divobj+lineinfo+"' value='"+basedatas[index].unit_id+"' type='hidden' /></td>";
					innerhtml += "<td><input name='devslotnum"+divobj+lineinfo+"' id='devslotnum"+divobj+lineinfo+"' style='line-height:15px' value='"+basedatas[index].device_slot_num+"' size='6' type='text' readonly/></td>";
					innerhtml += "<td><input name='apply_num"+divobj+lineinfo+"' id='apply_num"+divobj+lineinfo+"' checkinfo='"+divobj+lineinfo+"' style='line-height:15px' value='' size='10' type='text' onkeyup='checkInputNum(this)'/></td>";
					innerhtml += "<td><input name='totalslotnum"+divobj+lineinfo+"' id='totalslotnum"+divobj+lineinfo+"' style='line-height:15px' value='' size='10' type='text' readonly/></td>";
					innerhtml += "</tr>";
					$("#detailList"+divobj).append(innerhtml);
				}
				$("#detailList"+divobj+">tr:odd>td:odd").addClass("odd_odd");
				$("#detailList"+divobj+">tr:odd>td:even").addClass("odd_even");
				$("#detailList"+divobj+">tr:even>td:odd").addClass("even_odd");
				$("#detailList"+divobj+">tr:even>td:even").addClass("even_even");
			}
		})
	});
	
	function toAddAddedDetailInfos(){

		var retObj;
		var unitSql = "select sd.coding_code_id,coding_name from comm_coding_sort_detail sd ";
			unitSql += "where coding_sort_id ='5110000038' order by coding_code";
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql+'&pageSize=1000');
			retObj = unitRet.datas;
		var optionhtml = "";
		for(var index=0;index<retObj.length;index++){
			optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
		}		
		var teamSql = "select t.coding_code_id as value,t.coding_name as label from comm_coding_sort_detail t ";
			teamSql += "where t.coding_sort_id='0110000001' and t.bsflag='0' and t.spare1='0' and length(t.coding_code) = 2 ";
			if(projectType != "5000100004000000009" && projectType != "5000100004000000006"){
				//除了深海项目和综合物化探项目类型班组都使用陆地项目班组
				teamSql += "and t.coding_mnemonic_id='5000100004000000001' ";
			}else{
				teamSql += "and t.coding_mnemonic_id='"+projectType+"' ";
			}
			teamSql += "order by t.coding_show_id ";
		var teamRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+teamSql+'&pageSize=1000');
			teamObj = teamRet.datas;
		var teamoptionhtml = "";
		for(var index=0;index<teamObj.length;index++){
			teamoptionhtml +=  "<option name='teamcode' id='teamcode"+index+"' value='"+teamObj[index].value+"'>"+teamObj[index].label+"</option>";
		}

		var innerhtml = "<tr id='traddedseq"+addedseqinfo+"' name='traddedseq"+addedseqinfo+"' seq='"+addedseqinfo+"' is_added='false'>";
		innerhtml += "<td width='4%'><input type='checkbox' name='addedseq' id='"+addedseqinfo+"' checked='true'/></td>";
		innerhtml += "<td width='8%'><select id='addedteam"+addedseqinfo+"' name='addedteam"+addedseqinfo+"' style='select_width'>"+teamoptionhtml+"</select></td>";
		innerhtml += "<td width='12%'><input name='addeddevicename"+addedseqinfo+"' id='addeddevicename"+addedseqinfo+"' idindex='"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='10' type='text' /></td>";
		innerhtml += "<td width='12%'><input name='addeddevicetype"+addedseqinfo+"' id='addeddevicetype"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='10' type='text' /></td>";
		innerhtml += "<td width='4%'><select id='addedunit"+addedseqinfo+"' name='addedunit"+addedseqinfo+"' style='select_width'>"+optionhtml+"</select></td>";
		innerhtml += "<td width='10%'><input name='addedassignnum"+addedseqinfo+"' id='addedassignnum"+addedseqinfo+"' style='line-height:18px;width:98%' type='text' size='8' onkeyup='checkInputNum(this)'/></td>";
		innerhtml += "<td width='10%'><input name='addedremark"+addedseqinfo+"' id='addedremark"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='10' type='text' /></td>";
		innerhtml += "</tr>";
		
		$("#addeddetailtable").append(innerhtml);
		$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
		$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
		$("#addeddetailtable>tr:even>td:even").addClass("even_even");
		addedseqinfo++;

	}
	function toDelAddedDetailInfos(){
		$("input[name='addedseq'][type='checkbox']").each(function(i){
			if(this.checked){
				var index = this.id;
				$("#traddedseq"+index).remove();
			}
		});
		$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
		$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
		$("#addeddetailtable>tr:even>td:even").addClass("even_even");
	}
	function checkInputNum(obj){
		var lineid = obj.checkinfo;
		var devslotnum = $("#devslotnum"+lineid).val();
		if(devslotnum == ""){
			devslotnum = 0;
		}
		var value = obj.value;
		var re = /^(0|(^[1-9]+\d*$)?)$/;
		if(value==""){
			$("#totalslotnum"+lineid).val("");
			return;
		}
		if(!re.test(value)){
			alert("明细需求数量必须为数字!");
			obj.value = "";
			$("#totalslotnum"+lineid).val("");
        	return false;
		}
		$("#totalslotnum"+lineid).val(parseInt(devslotnum)*parseInt(value));
	}
	function viewRemark(id){
		window.showModalDialog("<%=contextPath%>/rm/dm/project/devRemark.jsp?devAppId="+id,"950:680");
	}
</script>
</html>