<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String deviceappid = request.getParameter("deviceappid");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
	String userName = user.getUserName();
	String projectType = request.getParameter("projectType")==null?user.getProjectType():request.getParameter("projectType");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>调配明细添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend >配置计划基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text"  value="" readonly/>
          	<input name="projectInfoNo" id="projectInfoNo" type="hidden" value="<%=projectInfoNo%>" />
          	<input name="deviceappid" id="deviceappid" type="hidden" value="<%=deviceappid%>" />
          </td>
          <td class="inquire_item4" ></td><td class="inquire_form4" ></td>
        </tr>
        <tr>
          <td class="inquire_item4" >配置计划单号:</td>
          <td class="inquire_form4" >
          	<input name="device_allapp_no" id="device_allapp_no" class="input_width" type="text"  value="" readonly/>
          </td>
          <td class="inquire_item4" >配置计划单名称:</td>
          <td class="inquire_form4" >
          	<input name="device_allapp_name" id="device_allapp_name" class="input_width" type="text"  value="" readonly/>
          </td>
        </tr>
      </table>
      </fieldset>
	  <fieldset ><legend>调配申请明细(采集设备)</legend>
		  <div style="height:220px;overflow:auto">
			  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_even" width="5%"><input type='checkbox' id='collcheck' name='collcheck' /></td>
<!-- 					<td class="bt_info_odd" width="5%">工序</td> -->
<!-- 					<td class="bt_info_even" width="8%">班组</td> -->
					<td class="bt_info_odd" width="12%">申请名称</td>
					<td class="bt_info_even" width="15%">申请型号</td>
					<td class="bt_info_odd" width="3%">计量单位</td>
					<td class="bt_info_even" width="6%">需求道数</td>
					<td class="bt_info_odd" width="6%">已申请道数</td>
					<td class="bt_info_even" width="6%">申请道数</td>
					<td class="bt_info_odd" width="10%">用途</td>
					<td class="bt_info_even" width="12%">开始时间</td>
					<td class="bt_info_odd" width="12%">结束时间</td>
				</tr>
			   <tbody id="processtable" name="processtable" >
			   </tbody>
		      </table>
	       </div>
      </fieldset>
	    <div id="tag-container_3" style="width:98%;">
		  <ul id="tags" class="tags">
		  </ul>
		</div>
		<div id="tab_box" class="tab_box" style="width:98%;height:120px;overflow:auto">
		</div>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
$().ready(function(){
	$("#collcheck").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='detinfo']").attr('checked',checkvalue);
	});
});
var projectType="<%=projectType%>";

	function submitInfo(){
		//保留的行信息
		var count = 0;
		var subcount = 0;
		var line_infos;
		var idinfos;
		var sub_line_infos;
		$("input[type='checkbox'][name='detinfo']").each(function(){
			if(this.checked == true){
				var keyinfo = this.value;
				if(count == 0){
					line_infos = this.id;
					idinfos = keyinfo;
				}else{
					line_infos += "~"+this.id;
					idinfos += "~"+keyinfo;
				}
				$("input[type='checkbox'][name='idinfo']","#detailList"+keyinfo).each(function(i){
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
		if(line_infos == undefined){
			alert("请选择要提交的数据条数据");
			return;
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
		if(wronglineinfos!=""){
			alert("申请道数不能为空!");
			return;
		}
		//数据都没问题，增加对道数申请的提示
		var appdaonum = $("input[id^='applynum']")[0].value;
		var totaldaonum =0;
		$("input[id^='totalslotnum']").each(function(i){
			if(this.value!=""){
				totaldaonum += parseInt(this.value,10);
			}
		});
		if(totaldaonum>appdaonum){
			if(!confirm("您添加的明细总道数为["+totaldaonum+"],大于申请道数["+appdaonum+"],是否继续?")){
				return;
			}
		}
		if(confirm("确认提交？")){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveCollMixAppDetailInfo.srq?count="+count+"&idinfos="+idinfos+"&line_infos="+line_infos+"&sub_line_infos="+sub_line_infos;
			document.getElementById("form1").submit();
		}
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
	var seqinfo = 0;
	function toMixDetailInfos(){
		seqinfo++;
		var valueinfo ;
		$("input[type='checkbox'][name='detinfo']").each(function(){
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
			$("input[type='checkbox'][name='detinfo']").each(function(){
				if(this.checked == true){
					showid = this.id;
					showmodeltype = this.devcodetype;
				}
			});
			var showname = $("#devicename"+showid).val()+"("+$("#devicetype"+showid).val()+")";
			var taginnerhtml = "<li id='tag3_"+valueinfo+"'><a href='#' onclick=getContentTab('"+valueinfo+"')>"+showname+"</a></li>";
			$("#tags").append(taginnerhtml);
			var containhtml = "<div style='width:97.5%' id='tab_box_content"+valueinfo+"' name='tab_box_content"+valueinfo+"' idinfo='"+valueinfo+"' style='width:97%' class='tab_box_content'>";
			containhtml += "<table border='0' cellpadding='0' cellspacing='0'  class='tab_line_height' style='width:99%' style='margin-top:10px;background:#efefef'>";
			containhtml += "<tr class='bt_info'><td class='bt_info_odd'>选择</td><td class='bt_info_even'>序号</td><td class='bt_info_odd'>设备名称</td><td class='bt_info_even'>规格名称</td>";
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
			var querySql = "select model_mainid,model_name ";
			querySql += "from gms_device_collmodel_main main ";
			querySql += "where main.bsflag='0' and model_type='"+showmodeltype+"'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
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
	}
	function getContentTab(index) {
		$("li","#tag-container_3").removeClass("selectTag");
		$("li[id='tag3_"+index+"']","#tag-container_3").addClass("selectTag");
		$("div","#tab_box").hide();
		$("div[id='tab_box_content"+index+"']","#tab_box").show();
	}
	function refreshData(){
		var retObj;
		var basedatas;
		//先查询基本信息 
		var basesql = "select pro.project_name,allapp.device_allapp_id,allapp.device_allapp_no,allapp.device_allapp_name,app.mix_type_id from gms_device_collapp app "
			+"left join gp_task_project pro on app.project_info_no=pro.project_info_no "
			+"left join gms_device_allapp allapp on app.device_allapp_id=allapp.device_allapp_id "
			+"where device_app_id='<%=deviceappid%>' ";
		var baseRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+basesql);
		var baseObj = baseRet.datas;
		//回填基本信息
		$("#project_name").val(baseObj[0].project_name);
		$("#device_allapp_no").val(baseObj[0].device_allapp_no);
		$("#device_allapp_name").val(baseObj[0].device_allapp_name);
		if('<%=deviceappid%>'!=null){
			var prosql = "select * from (select aad.device_allapp_detid,aad.team,aad.teamid,aad.dev_name_input as dev_ci_name,aad.dev_codetype,";
			prosql += "devtype.coding_name as dev_ci_model,sd.coding_name as unit_name,teamsd.coding_name as teamname,p6.name as jobname, ";
			prosql += "aad.approve_num as require_num,aad.purpose,aad.plan_start_date,aad.plan_end_date,aad.unitinfo,";
			prosql += "allapp.device_allapp_no,allapp.device_allapp_name,allapp.project_info_no,";
			prosql += "pro.project_name,nvl(tmp.applyed_num,0) as applyed_num ";
			prosql += "from gms_device_allapp_colldetail aad ";
			prosql += "left join bgp_p6_activity p6 on aad.teamid = p6.object_id ";
			prosql += "left join comm_coding_sort_detail devtype on aad.dev_codetype = devtype.coding_code_id ";
			prosql += "left join comm_coding_sort_detail teamsd on aad.team = teamsd.coding_code_id ";
			prosql += "left join gms_device_allapp allapp on aad.device_allapp_id=allapp.device_allapp_id ";
			prosql += "left join gms_device_collapp da on allapp.device_allapp_id=da.device_allapp_id ";
			prosql += "left join comm_coding_sort_detail sd on aad.unitinfo=sd.coding_code_id ";
			prosql += "left join gp_task_project pro on aad.project_info_no = pro.project_info_no ";
			prosql += "left join ";
			prosql += "(select device_allapp_detid,dev_name_input,dev_codetype,sum(apply_num) as applyed_num ";
			prosql += "from (select cdet.project_info_no,cdet.bsflag,cdet.device_allapp_detid,cdet.dev_name_input,cdet.dev_codetype,cdet.apply_num ";
			prosql += "from gms_device_app_colldetail cdet join gms_device_collapp ca on cdet.device_app_id=ca.device_app_id and ca.bsflag='0') tmp2 ";
			prosql += "where project_info_no='<%=projectInfoNo%>' and bsflag='0' group by device_allapp_detid,dev_name_input,dev_codetype) ";
			prosql += "tmp on aad.device_allapp_detid = tmp.device_allapp_detid ";
			prosql += "where da.device_app_id='<%=deviceappid%>' and da.bsflag='0' and aad.bsflag='0' and allapp.bsflag='0' and pro.bsflag='0' and aad.device_addapp_id is null and aad.resourceflag is null ";
			prosql +=" union all ";
			prosql += "select aad.device_allapp_detid,aad.team,aad.teamid,aad.dev_name_input as dev_ci_name,aad.dev_codetype,";
			prosql += "devtype.coding_name as dev_ci_model,sd.coding_name as unit_name,teamsd.coding_name as teamname,p6.name as jobname, ";
			prosql += "aad.approve_num as require_num,aad.purpose,aad.plan_start_date,aad.plan_end_date,aad.unitinfo,";
			prosql += "allapp.device_allapp_no,allapp.device_allapp_name,allapp.project_info_no,";
			prosql += "pro.project_name,nvl(tmp.applyed_num,0) as applyed_num ";
			prosql += "from gms_device_allapp_colldetail aad ";
			prosql += "left join common_busi_wf_middle wf on wf.business_id = aad.device_addapp_id ";
			if(projectType == "5000100004000000008"){//井中
				prosql += "and wf.business_type = '5110000004100001064' ";
		    }
			prosql += "left join bgp_p6_activity p6 on aad.teamid = p6.object_id ";
			prosql += "left join comm_coding_sort_detail devtype on aad.dev_codetype = devtype.coding_code_id ";
			prosql += "left join comm_coding_sort_detail teamsd on aad.team = teamsd.coding_code_id ";
			prosql += "left join gms_device_allapp allapp on aad.device_allapp_id=allapp.device_allapp_id ";
			prosql += "left join gms_device_collapp da on allapp.device_allapp_id=da.device_allapp_id ";
			prosql += "left join comm_coding_sort_detail sd on aad.unitinfo=sd.coding_code_id ";
			prosql += "left join gp_task_project pro on aad.project_info_no = pro.project_info_no ";
			prosql += "left join ";
			prosql += "(select device_allapp_detid,dev_name_input,dev_codetype,sum(apply_num) as applyed_num ";
			prosql += "from (select cdet.project_info_no,cdet.bsflag,cdet.device_allapp_detid,cdet.dev_name_input,cdet.dev_codetype,cdet.apply_num ";
			prosql += "from gms_device_app_colldetail cdet join gms_device_collapp ca on cdet.device_app_id=ca.device_app_id and ca.bsflag='0') tmp2 ";
			prosql += "where project_info_no='<%=projectInfoNo%>' and bsflag='0' group by device_allapp_detid,dev_name_input,dev_codetype) ";
			prosql += "tmp on aad.device_allapp_detid = tmp.device_allapp_detid ";
			prosql += "where da.device_app_id='<%=deviceappid%>' and da.bsflag='0' and aad.bsflag='0' and aad.resourceflag is null and allapp.bsflag='0' and pro.bsflag='0' and wf.proc_status = '3' ";
			//prosql += "order by aad.teamid,aad.team ";
			//项目资源配置中录入的
			prosql +=" union all ";			
			prosql += "select aad.device_allapp_detid,aad.team,aad.teamid,aad.dev_name_input as dev_ci_name,aad.dev_codetype,";
			prosql += "devtype.coding_name as dev_ci_model,sd.coding_name as unit_name,teamsd.coding_name as teamname,p6.name as jobname, ";
			prosql += "aad.approve_num as require_num,aad.purpose,aad.plan_start_date,aad.plan_end_date,aad.unitinfo,";
			prosql += "allapp.device_allapp_no,allapp.device_allapp_name,allapp.project_info_no,";
			prosql += "pro.project_name,nvl(tmp.applyed_num,0) as applyed_num ";
			prosql += "from gms_device_allapp_colldetail aad ";
			prosql += "left join bgp_p6_activity p6 on aad.teamid = p6.object_id ";
			prosql += "left join comm_coding_sort_detail devtype on aad.dev_codetype = devtype.coding_code_id ";
			prosql += "left join comm_coding_sort_detail teamsd on aad.team = teamsd.coding_code_id ";
			prosql += "left join gms_device_allapp allapp on aad.device_allapp_id=allapp.device_allapp_id ";
			prosql += "left join gms_device_collapp da on allapp.device_allapp_id=da.device_allapp_id ";
			prosql += "left join comm_coding_sort_detail sd on aad.unitinfo=sd.coding_code_id ";
			prosql += "left join gp_task_project pro on aad.project_info_no = pro.project_info_no ";
			prosql += "left join ";
			prosql += "(select device_allapp_detid,dev_name_input,dev_codetype,sum(apply_num) as applyed_num ";
			prosql += "from (select cdet.project_info_no,cdet.bsflag,cdet.device_allapp_detid,cdet.dev_name_input,cdet.dev_codetype,cdet.apply_num ";
			prosql += "from gms_device_app_colldetail cdet join gms_device_collapp ca on cdet.device_app_id=ca.device_app_id and ca.bsflag='0') tmp2 ";
			prosql += "where project_info_no='<%=projectInfoNo%>' and bsflag='0' group by device_allapp_detid,dev_name_input,dev_codetype) ";
			prosql += "tmp on aad.device_allapp_detid = tmp.device_allapp_detid ";
			prosql += "where da.device_app_id='<%=deviceappid%>' and da.bsflag='0' and aad.bsflag='0' and allapp.bsflag='0' and pro.bsflag='0'  and aad.resourceflag='0'  and aad.device_addapp_id is null ";		
			//项目资源补充配置中录入审核通过的
			prosql += "union all ";
		  prosql += "select aad.device_allapp_detid,aad.team,aad.teamid,aad.dev_name_input as dev_ci_name,aad.dev_codetype,";
			prosql += "devtype.coding_name as dev_ci_model,sd.coding_name as unit_name,teamsd.coding_name as teamname,p6.name as jobname, ";
			prosql += "aad.approve_num as require_num,aad.purpose,aad.plan_start_date,aad.plan_end_date,aad.unitinfo,";
			prosql += "allapp.device_allapp_no,allapp.device_allapp_name,allapp.project_info_no,";
			prosql += "pro.project_name,nvl(tmp.applyed_num,0) as applyed_num ";
			prosql += "from gp_middle_resources r left join common_busi_wf_middle wf on r.mid=wf.business_id and wf.bsflag='0' ";
			prosql += "left join gms_device_allapp_add  al on r.dev_id=al.device_addapp_id and al.bsflag='0' ";
			prosql += "left join gms_device_allapp_colldetail aad on al.device_addapp_id=aad.device_addapp_id ";
			prosql += "left join bgp_p6_activity p6 on aad.teamid = p6.object_id ";
			prosql += "left join comm_coding_sort_detail devtype on aad.dev_codetype = devtype.coding_code_id ";
			prosql += "left join comm_coding_sort_detail teamsd on aad.team = teamsd.coding_code_id ";
			prosql += "left join gms_device_allapp allapp on aad.device_allapp_id=allapp.device_allapp_id ";
			prosql += "left join gms_device_collapp da on allapp.device_allapp_id=da.device_allapp_id ";
			prosql += "left join comm_coding_sort_detail sd on aad.unitinfo=sd.coding_code_id ";
			prosql += "left join gp_task_project pro on aad.project_info_no = pro.project_info_no ";
			prosql += "left join ";
			prosql += "(select device_allapp_detid,dev_name_input,dev_codetype,sum(apply_num) as applyed_num ";
			prosql += "from (select cdet.project_info_no,cdet.bsflag,cdet.device_allapp_detid,cdet.dev_name_input,cdet.dev_codetype,cdet.apply_num ";
			prosql += "from gms_device_app_colldetail cdet join gms_device_collapp ca on cdet.device_app_id=ca.device_app_id and ca.bsflag='0') tmp2 ";
			prosql += "where project_info_no='<%=projectInfoNo%>' and bsflag='0' group by device_allapp_detid,dev_name_input,dev_codetype) ";
			prosql += "tmp on aad.device_allapp_detid = tmp.device_allapp_detid ";
			prosql += "where da.device_app_id='<%=deviceappid%>' and da.bsflag='0' and aad.bsflag='0' and allapp.bsflag='0' and pro.bsflag='0'  and aad.resourceflag='0' and r.supplyflag='0' and wf.proc_status='3' ";
			prosql += ") order by teamid,team ";
			
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql+'&pageSize=1000');
			retObj = proqueryRet.datas;
		}

		for(var index=0;index<retObj.length;index++){
			//动态新增表格
			var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
			innerhtml += "<td><input type='checkbox' name='detinfo' id='"+index+"' value='"+retObj[index].device_allapp_detid+"' devcodetype='"+retObj[index].dev_codetype+"'/>";
			innerhtml += "<input name='jobname"+index+"' id='jobname"+index+"' style='line-height:15px' value='"+retObj[index].jobname+"' size='12' type='hidden' readonly/>";
			innerhtml += "<input name='teamid"+index+"' id='teamid"+index+"' style='line-height:15px' value='"+retObj[index].teamid+"' type='hidden' />";
			innerhtml += "<input name='teamname"+index+"' id='teamname"+index+"' value='"+retObj[index].teamname+"'  type='hidden' readonly/>";
			innerhtml += "<input name='team"+index+"' id='teamid"+index+"' value='"+retObj[index].team+"' type='hidden'/></td>";
			
			innerhtml += "<td><input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='"+retObj[index].dev_ci_name+"' size='12' type='text' readonly/></td>";
			innerhtml += "<td><input name='devicetype"+index+"' id='devicetype"+index+"' value='"+retObj[index].dev_ci_model+"' size='15'  type='text' readonly/>";
			innerhtml += "<input name='dev_codetype"+index+"' id='dev_codetype"+index+"' value='"+retObj[index].dev_codetype+"' type='hidden' /></td>";
			
			innerhtml += "<td><input name='unitname"+index+"' id='unitname"+index+"' value='"+retObj[index].unit_name+"' size='3' type='text' readonly>";
			innerhtml += "<input name='unitinfo"+index+"' id='unitinfo"+index+"' value='"+retObj[index].unitinfo+"' type='hidden'></td>";
			
			innerhtml += "<td><input name='neednum"+index+"' id='neednum"+index+"' value='"+retObj[index].require_num+"' size='5' type='text' /></td>";
			innerhtml += "<td><input name='applyednum"+index+"' id='applyednum"+index+"' value='"+retObj[index].applyed_num+"' size='5' type='text' readonly/></td>";
			innerhtml += "<td><input name='applynum"+index+"' id='applynum"+index+"' detindex='"+index+"' value='' size='5' type='text' onkeyup='checkAssignNum(this)'/></td>";
			
			innerhtml += "<td><input name='purpose"+index+"' id='purpose"+index+"' value='"+retObj[index].purpose+"' size='10' type='text' readonly/></td>";
			innerhtml += "<td><input name='startdate"+index+"' id='startdate"+index+"' style='line-height:15px' value='"+retObj[index].plan_start_date+"' size='10' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(startdate"+index+",tributton2"+index+");'/></td>";
			innerhtml += "<td><input name='enddate"+index+"' id='enddate"+index+"' style='line-height:15px' value='"+retObj[index].plan_end_date+"' size='10' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+index+",tributton3"+index+");'/></td>";
			innerhtml += "</tr>";
			$("#processtable").append(innerhtml);
		}
		$("#processtable>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable>tr:odd>td:even").addClass("odd_even");
		$("#processtable>tr:even>td:odd").addClass("even_odd");
		$("#processtable>tr:even>td:even").addClass("even_even");
	}
	function checkAssignNum(obj){
		var index = obj.detindex;
		var neednumval = parseInt($("#neednum"+index).val(),10);
		var applyednumval = parseInt($("#applyednum"+index).val(),10);
		var value = obj.value;
		var re = /^\+?[1-9][0-9]*$/;
		if(value=="")
			return;
		if(!re.test(value)){
			alert("申请数量必须为数字!");
			obj.value = "";
        	return false;
		}else{
			if(parseInt(value,10)>neednumval){
				if(!confirm("您添加的申请道数为["+value+"],大于需求道数["+neednumval+"],是否继续?")){
					obj.value = "";
					return false;
				}
			}else if((parseInt(value,10)+applyednumval)>neednumval){
				if(!confirm("您添加的申请道数为["+value+"],大于未申请道数["+(parseInt(neednumval,10)-parseInt(applyednumval,10))+"],是否继续?")){
					obj.value = "";
					return false;
				}
			}
		}
	}
</script>
</html>

