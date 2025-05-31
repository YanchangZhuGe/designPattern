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
	String deviceappid = request.getParameter("deviceallappid");
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
 
 <body style="background:#cdddef;overflow:auto" onload="refreshData()">
 	<form name="form1" id="form1" method="post" action="" target="target_id">
      	<div id="list_table" style="height:400px;overflow:auto">
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
							<!-- <td class="bt_info_odd">申请道数</td> -->
							<td class="bt_info_even">申请道数</td>
							<td class="bt_info_odd">计划开始时间</td>
							<td class="bt_info_even">计划结束时间</td>
							<td class="bt_info_odd">用途</td>
					     </tr> 
						  <tbody id="detailList1" name="detailList1"></tbody>
					  </table>
					 </fieldset>				
				    </div>
										
					<div id="tag-container_4" style="display:block;">
					  <ul id="tags" class="tags">
					    <li class="selectTag" id="tag3_1"><a href="#" onclick="getContentTab(this,2)">审批明细</a></li>
					  </ul>
					</div>
					<div id="tab_box" class="tab_box" style="width:100%">
						<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="display:block;width:100%">
							<wf:getProcessInfo/>
						</div>
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
	var detailmainid;
	function refreshData(){
		//查询基本信息也带过来
		
		var str = "select a.*,comm.org_abbreviation from ( select devapp.app_org_id,appdet.device_app_detid,appdet.dev_codetype,appdet.project_info_no,sd.coding_name as unitname,teamsd.coding_name as teamname, ";
		str += "p6.name as jobname,pro.project_name,appdet.dev_name_input as dev_ci_name,devtype.coding_name as dev_ci_model, ";
		str += "appdet.apply_num,appdet.teamid,appdet.team,devapp.device_app_name, ";
		str += "appdet.purpose,appdet.employee_id,emp.employee_name, ";
		str += "appdet.plan_start_date,appdet.plan_end_date  ";
		str += "from gms_device_app_colldetail appdet ";
		str += "left join gms_device_collapp devapp on appdet.device_app_id = devapp.device_app_id ";
        str += "left join gms_device_allapp allapp on allapp.DEVICE_ALLAPP_ID=devapp.DEVICE_ALLAPP_ID ";
		str += "left join bgp_p6_activity p6 on appdet.teamid = p6.object_id ";
		str += "left join comm_coding_sort_detail devtype on appdet.dev_codetype = devtype.coding_code_id ";
		str += "left join comm_coding_sort_detail teamsd on appdet.team = teamsd.coding_code_id ";
		str += "left join comm_coding_sort_detail sd on appdet.unitinfo = sd.coding_code_id ";
		str += "left join gp_task_project pro on appdet.project_info_no = pro.project_info_no ";
		str += "left join comm_human_employee emp on appdet.employee_id = emp.employee_id ";
		str += "where allapp.DEVICE_ALLAPP_ID = '"+idinfo+"' and appdet.bsflag='0' ";
		str += "and devapp.bsflag = '0' ) a  inner join  comm_org_information comm on a.app_org_id=comm.org_id";
		var detailRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=10000');

		var retObj = detailRet.datas;
		if(retObj && retObj.length>0){
			for(var index=0;index<retObj.length;index++){
				detailmainid = retObj[index].device_app_detid;
				var device_app_detid = retObj[index].device_app_detid;
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
				innerhtml += "<td><input name='colldevicename"+index+"' id='colldevicename"+index+"' style='line-height:15px' value='"+colldev_ci_name+"' size='10' type='text' readonly/></td>";
				innerhtml += "<td><input id='colldevicetype"+index+"' name='colldevicetype"+index+"' value='"+colldev_ci_model+"' size='12'  type='text' readonly/></td>";
				innerhtml += "<td><input id='collunitname"+index+"' name='collunitname"+index+"' value='"+collunitname+"' size='3' type='text' readonly/></td>";
				innerhtml += "<td><input id='collapplynum"+index+"' name='collapplynum"+index+"' value='"+collapply_num+"' size='3' type='text' readonly/></td>";
				//审批道数
				//innerhtml += "<td><input id='collapplynum"+index+"' name='collapplynum"+index+"' value='"+collapply_num+"' size='3' type='text'  onkeyup='returnNumber(this)'/></td>";
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
		//回填基本信息
		$("#project_name").val(retObj[0].project_name);
		$("#projectInfoNo").val(retObj[0].project_info_no);
		$("#device_app_name").val(retObj[0].device_app_name);
		$("#username").val(retObj[0].employee_name);
		$("#org_name").val(retObj[0].org_abbreviation);
		toMixDetailInfos();
		//var querySql = "select mix.device_name,mix.device_model,mix.unit_name,'' as a,mix.device_num,mix.mix_num,mix.devremark from gms_device_coll_mixsubadd mix left join comm_coding_sort_detail d on mix.team=d.coding_code_id where mix.device_mixinfo_id='"+detailmainid+"'";
		var querySql = "select mix.device_mif_subid,teamsd.coding_name as teamname,mix.device_name,mix.device_model,mix.unit_name,'' as a,mix.device_num,mix.mix_num,mix.devremark from gms_device_coll_mixsubadd mix left join comm_coding_sort_detail teamsd on mix.team = teamsd.coding_code_id left join comm_coding_sort_detail d on mix.team=d.coding_code_id where mix.device_mixinfo_id='"+detailmainid+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql+'&pageSize=10000');
		var queryObj = queryRet.datas;
		if(queryObj && queryObj.length>0){
			var index;
			for(index=0;index<queryObj.length;index++){
				var innerhtml = "<tr id='tradded"+index+"' name='tradded"+index+"' seq='"+index+"' is_added='false'>";
				innerhtml += "<td width='4%'><input type='checkbox' name='addedseq' id='addedseq"+index+"' checked='true' /></td>";
				//innerhtml += "<td width='4%'>"+(index+1)+"<input type='hidden' id='addeddevmifsubid"+index+"' name='addeddevmifsubid"+index+"' value='"+queryObj[index].device_mif_subid+"'></td>";
				innerhtml += "<td width='12%'><input name='addedteamname"+index+"' id='addedteamname"+index+"' value='"+retObj[0].teamname+"' style='line-height:18px;width:98%' size='10' type='text' readonly/>";
				innerhtml += "<input name='addedteam"+index+"' id='addedteam"+index+"' value='"+retObj[0].team+"' type='hidden' /></td>";
				innerhtml += "<td width='12%'><input name='addeddevicename"+index+"' id='addeddevicename"+index+"' idindex='"+index+"' value='"+queryObj[index].device_name+"' style='line-height:18px;width:98%' size='10' type='text' /></td>";
				innerhtml += "<td width='12%'><input name='addeddevicetype"+index+"' id='addeddevicetype"+index+"' value='"+queryObj[index].device_model+"' style='line-height:18px;width:98%' size='10' type='text' /></td>";
				innerhtml += "<td width='10%'><input name='addedunit"+index+"' id='addedunit"+index+"' value='"+queryObj[index].unit_name+"' style='line-height:18px;width:98%' size='8' type='text' /></td>";
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
		var form = document.getElementById("form1");
		document.getElementById("isPass").value="pass";
		form.action = "<%=contextPath%>/bpm/common/toDoProcessInfo.srq";
		//Ext.MessageBox.wait('请等待','处理中');
		if(oprinfo==1){
			if(confirm("是否确定审批通过?")){
				form.submit();		
				window.close();
			}
		}else if(oprinfo==0){
			document.getElementById("isPass").value="back";
				if(confirm("是否确定审批不通过?")){
					form.submit();		
					window.close();
				}
			}
		 
		//document.getElementById("isPass").value=oprstate;
		//if(confirm("确认提交？")){
		//	document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveCollDevAppAuditInfowfpa.srq?deviceappid=<%=deviceappid%>&detailmainid="+detailmainid+"&oprstate="+oprstate+"&count="+count+"&idinfos="+idinfos+"&line_infos="+line_infos+"&sub_line_infos="+sub_line_infos+"&addedcount="+addedcount+"&addedline_info="+addedline_info;
		//	document.getElementById("form1").submit();
	//	}
	//	window.setTimeout(function(){window.close();},2000); */
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
			
		}
		//var querySql = "select cds.device_name,cds.device_model,detail.coding_name as unitname, unit_id,cds.device_slot_num,cds.device_num,det.apply_num from gms_device_app_colldetsub cds left join gms_device_app_colldetail det on cds.device_app_detid=det.device_app_detid left join comm_coding_sort_detail detail on detail.coding_code_id = cds.unit_id where cds.device_app_detid = '"+detailmainid+"'";
		var querySql = "select cds.device_id,cds.device_name,cds.device_model,detail.coding_name as unitname, unit_id,cds.device_slot_num,cds.device_num,device_slot_num*device_num as apply_num from gms_device_app_colldetsub cds left join gms_device_app_colldetail det on cds.device_app_detid=det.device_app_detid left join comm_coding_sort_detail detail on detail.coding_code_id = cds.unit_id where cds.device_app_detid = '"+detailmainid+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql+'&pageSize=10000');
		var queryObj = queryRet.datas;
		if(queryObj && queryObj.length>0){
			var index;
			for(index=0;index<queryObj.length;index++){
				var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seqinfo='"+index+"'>";
				innerhtml += "<td><input type='checkbox' name='didinfo' id='"+index+"' checked='true'/></td>";
				innerhtml += "<td>"+(index+1)+"<input type='hidden' id='device_id"+index+"' name='device_id"+index+"' value='"+queryObj[index].device_id+"'></td>";
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
			var unitSql = "select sd.coding_code_id,coding_name ";
			unitSql += "from comm_coding_sort_detail sd "; 
			unitSql += "where coding_sort_id ='5110000038' order by coding_code";
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql);
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
			var innerhtml = "<tr id='tr"+divobj+currentseq+"' name='tr"+divobj+currentseq+"' seqinfo='"+currentseq+"'>";
			innerhtml += "<td><input type='checkbox' name='didinfo' id='"+divobj+currentseq+"' checked='true'/></td>";
			innerhtml += "<td>"+currentseq+"<input type='hidden' id='device_id"+divobj+currentseq+"' name='device_id"+divobj+currentseq+"' value='"+data.device_id+"'></td>";
			innerhtml += "<td><input name='devicename"+divobj+currentseq+"' id='devicename"+divobj+currentseq+"' style='line-height:15px' value='"+data.dev_name+"' size='30' type='text' readonly/></td>";
			innerhtml += "<td><input name='devicemodel"+divobj+currentseq+"' id='devicemodel"+divobj+currentseq+"' style='line-height:15px' value='"+data.dev_model+"' size='30' type='text' readonly/></td>";
			innerhtml += "<td><select id='unitList"+divobj+currentseq+"' name='unitList"+divobj+currentseq+"' style='select_width'></select></td>";
			innerhtml += "<td><input name='devslotnum"+divobj+currentseq+"' id='devslotnum"+divobj+currentseq+"' style='line-height:15px' value='"+data.dev_slot_num+"' size='6' type='text' /></td>";
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
			var unitSql = "select sd.coding_code_id,coding_name ";
			unitSql += "from comm_coding_sort_detail sd "; 
			unitSql += "where coding_sort_id ='5110000038' order by coding_code";
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql);
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
				querySql += "where main.bsflag='0' and sub.model_mainid='"+value+"' order by ci.dev_code ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
				basedatas = queryRet.datas;
			if(basedatas!=undefined && basedatas.length>0){
				$("#detailList"+divobj).empty();
				var lineinfo;
				//回填基本信息
				for(var index=0;index<basedatas.length;index++){
					lineinfo = index+1;
					var innerhtml = "<tr id='tr"+divobj+lineinfo+"' name='tr"+divobj+lineinfo+"' seqinfo='"+lineinfo+"'>";
					innerhtml += "<td><input type='checkbox' name='didinfo' id='"+divobj+lineinfo+"' checked='true'/></td>";
					innerhtml += "<td>"+lineinfo+"<input type='hidden' id='device_id"+divobj+lineinfo+"' name='device_id"+divobj+lineinfo+"' value='"+basedatas[index].device_id+"'></td>";
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
	var addedseqinfo = 0;
	function toAddAddedDetailInfos(){
		addedseqinfo++;
		//获得第一行的team信息
		var teamname = $("input[name^='collteamname'][type='text']")[0].value;
		var team = $("input[name^='team'][type='hidden']")[0].value;
		var innerhtml = "<tr id='tradded"+addedseqinfo+"' name='tradded"+addedseqinfo+"' seq='"+addedseqinfo+"' is_added='false'>";
		innerhtml += "<td width='4%'><input type='checkbox' name='addedseq' id='addedseq"+addedseqinfo+"' checked='true'/></td>";
		//innerhtml += "<td width='4%'>"+(addedseqinfo+1)+"<input type='hidden' id='addeddevmifsubid"+addedseqinfo+"' name='addeddevmifsubid"+addedseqinfo+"' value=''></td>";
		innerhtml += "<td width='12%'><input name='addedteamname"+addedseqinfo+"' id='addedteamname"+addedseqinfo+"' value='"+teamname+"' style='line-height:18px;width:98%' size='10' type='text' readonly/>";
		innerhtml += "<input name='addedteam"+addedseqinfo+"' id='addedteam"+addedseqinfo+"' value='"+team+"' type='hidden' /></td>";
		innerhtml += "<td width='12%'><input name='addeddevicename"+addedseqinfo+"' id='addeddevicename"+addedseqinfo+"' idindex='"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='10' type='text' /></td>";
		innerhtml += "<td width='12%'><input name='addeddevicetype"+addedseqinfo+"' id='addeddevicetype"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='10' type='text' /></td>";
		innerhtml += "<td width='10%'><input name='addedunit"+addedseqinfo+"' id='addedunit"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='8' type='text' /></td>";
		//innerhtml += "<td width='9%'><select id='addedunit"+addedseqinfo+"' name='addedunit"+addedseqinfo+"' style='select_width'></select></td>";
		innerhtml += "<td width='10%'><input name='addedassignnum"+addedseqinfo+"' id='addedassignnum"+addedseqinfo+"' value='' style='line-height:18px;width:98%' type='text' size='8' onkeyup='checkInputNum(this)'/></td>";
		innerhtml += "<td width='10%'><input name='addedremark"+addedseqinfo+"' id='addedremark"+addedseqinfo+"' value='' style='line-height:18px;width:98%' size='10' type='text' /></td>";
		innerhtml += "</tr>";
		$("#addeddetailtable").append(innerhtml);
		$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
		$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
		$("#addeddetailtable>tr:even>td:even").addClass("even_even");
		//给当前这个单位追加数据
		//var retObj;
		//var unitSql = "select sd.coding_code_id,coding_name ";
	//	   unitSql += "from comm_coding_sort_detail sd "; 
	//	   unitSql += "where coding_sort_id ='5110000038' order by coding_code";
	//	var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql);
	//	retObj = unitRet.datas;
	//	var optionhtml = "";
	//	for(var index=0;index<retObj.length;index++){
	//		optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
	//	}
	//	$("#addedunit"+addedseqinfo).append(optionhtml);
	//	addedseqinfo++;
	}
	function toDelAddedDetailInfos(){
		
		$("input[name='addedseq'][type='checkbox']").each(function(i){
			if(this.checked){
				var index = this.id.substr(8);
				$("#tradded"+index).remove();
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
		var re = /^\+?[1-9][0-9]*$/;
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
	function returnNumber(obj){

		var value = obj.value;
		var re = /^\+?[1-9][0-9]*$/;
			if(!re.test(value)&&value!=null){
				alert("道数必须为数字!");
				obj.value = 0;
				
	        	return false;
			}
		}
</script>
</html>