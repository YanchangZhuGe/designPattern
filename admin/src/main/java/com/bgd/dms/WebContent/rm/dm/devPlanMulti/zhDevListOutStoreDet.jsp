<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String deviceallappid = request.getParameter("deviceallappid");
	String allapp_type = request.getParameter("allapp_type");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
	String userName = user.getUserName();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>多项目 -出库分配-出库分配(综合物化探)-设备配置计划-明细出库子页面</title>
</head>
<body style="background:#cdddef" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
	<div id="list_table">
	<div id="new_table_box_content" style="width:100%;">
    <div id="new_table_box_bg" style="width:95%">
     <fieldset style="margin-left:2px"><legend >配置计划基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text"  value="" readonly/>
          	<input name="projectInfoNo" id="projectInfoNo" type="hidden" value="<%=projectInfoNo%>" />
          	<input name="deviceappid" id="deviceappid" type="hidden" value="<%=deviceallappid%>" />
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
	  <fieldset style="margin-left:2px"><legend>调配申请明细</legend>
		  <div style="overflow:auto">
			  <table style="width:100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<!-- <td class="bt_info_odd" width="5%"><input type='checkbox' id='devchecked' name='devchecked' /></td> -->
					<td class="bt_info_odd width="5%">序号</td>
					<!-- <td class="bt_info_odd" width="8%">班组</td> -->
					<td class="bt_info_even" width="10%">设备名称</td>
					<td class="bt_info_odd" width="10%">规格型号</td>
					<td class="bt_info_even" width="3%">计量单位</td>
					<td class="bt_info_odd" width="6%">审批数量</td>
					<!-- <td class="bt_info_odd" width="6%">已申请数量</td>
					<td class="bt_info_even" width="6%">申请数量</td> -->
					<td class="bt_info_even" width="12%">开始时间</td>
					<td class="bt_info_odd" width="12%">结束时间</td>
					<td class="bt_info_even" width="8%">备注</td>
					<td class="bt_info_odd" width="9%">出库单位</td>
				</tr>
				<tbody id="processtable" name="processtable" />
				</table>
	      </div>
      </fieldset>
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
	$("#devchecked").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='detinfo']").attr('checked',checkvalue);
	});
});
var device_allapp_id = '<%=deviceallappid%>';
var projectInfoNos = '<%=projectInfoNo%>';
var allappType = "<%=allapp_type%>";

	function submitInfo(){
		//保留的行信息
		var count = 0;
		var line_infos;
		var idinfos ;
		$("tr","#processtable").each(function(){
		//$("input[type='checkbox'][name='detinfo']").each(function(){
			if(this.seq!=undefined){
				if(count == 0){
					line_infos = this.seq;
					idinfos = $("#detid"+this.seq).val();
				}else{
					line_infos += "~"+this.seq;
					idinfos += "~"+$("#detid"+this.seq).val();
				}
				count++;
			}
		});
		if(count == 0){
			alert('请选择调配设备申请明细信息！');
			return;
		}
		var selectedlines = line_infos.split("~");
		var wronglineinfos = "";
		var wrongoutid="";
		for(var index=0;index<selectedlines.length;index++){
			var valueinfo = $("#applynum"+selectedlines[index]).val();
			var outid = $("#devoutorgid"+selectedlines[index]).val();
			if(valueinfo == ""){
				if(index == 0){
					wronglineinfos += (parseInt(selectedlines[index])+1);
				}else{
					wronglineinfos += ","+(parseInt(selectedlines[index])+1);
				}
			}
			if(outid == "请选择..."){
				if(index == 0){
					wrongoutid += (parseInt(selectedlines[index])+1);
				}else{
					wrongoutid += ","+(parseInt(selectedlines[index])+1);
				}
			}
		}
		if(wrongoutid!=""){
			alert("请设置第"+wrongoutid+"行的出库单位!");
			return;
		}
		if(wronglineinfos!=""){
			alert("请设置第"+wronglineinfos+"行明细的申请数量!");
			return;
		}
		if(confirm("确认提交？")){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveMixAppDetailInfoZh.srq?mixownership=S0000&pbflag=Y&state=0&count="+count+"&line_infos="+line_infos+"&idinfos="+idinfos+"&device_allapp_id="+device_allapp_id+"&projectInfoNo="+projectInfoNos;
			document.getElementById("form1").submit();
		}
	}
	
	function refreshData(){
		var retObj;
		var basedatas;
		//先查询基本信息 
		var basesql = "select pro.project_name,allapp.device_allapp_id,allapp.device_allapp_no,allapp.device_allapp_name from gms_device_allapp allapp "
			+"left join gp_task_project pro on allapp.project_info_no=pro.project_info_no "
			+"where allapp.device_allapp_id='<%=deviceallappid%>' ";
		var baseRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+basesql);
		var baseObj = baseRet.datas;
		//回填基本信息
		$("#project_name").val(baseObj[0].project_name);
		$("#device_allapp_no").val(baseObj[0].device_allapp_no);
		$("#device_allapp_name").val(baseObj[0].device_allapp_name);
		var device_allapp_id = baseObj[0].device_allapp_id;	
		if(device_allapp_id!=null){
			var prosql = "select aad.device_allapp_detid,aad.team,aad.teamid,aad.dev_ci_code,aad.isdevicecode,";
				prosql += "aad.dev_name as dev_ci_name,";
				prosql += "aad.dev_type as dev_ci_model, ";
				prosql += "sd.coding_name as unit_name,teamsd.coding_name as teamname,p6.name as jobname, ";
				prosql += "aad.approve_num as require_num,aad.purpose,aad.plan_start_date,aad.plan_end_date,aad.unitinfo,";
				prosql += "nvl(tmp.applyed_num,0) as applyed_num,aad.project_info_no ";
				prosql += "from gms_device_allapp_detail aad ";
				prosql += "left join bgp_p6_activity p6 on aad.teamid = p6.object_id ";
				prosql += "left join comm_coding_sort_detail teamsd on aad.team = teamsd.coding_code_id ";
				prosql += "left join comm_coding_sort_detail sd on aad.unitinfo=sd.coding_code_id ";
				prosql += "left join gms_device_codeinfo ci on aad.dev_ci_code = ci.dev_ci_code ";
				prosql += "left join gms_device_codetype ct on aad.dev_ci_code = ct.dev_ct_code ";
				prosql += "left join ";
				prosql += "(select device_allapp_detid,dev_ci_code,sum(apply_num) as applyed_num ";
				prosql += "from (select det.project_info_no,det.bsflag,det.device_allapp_detid,det.dev_ci_code,det.apply_num,'1' as type ";
				prosql += "from gms_device_app_detail det join gms_device_app app on det.device_app_id=app.device_app_id where app.bsflag='0' union all ";
				prosql += "select det.project_info_no,det.bsflag,det.device_allapp_detid,det.dev_ci_code,det.apply_num,'2' as type ";
				prosql += "from gms_device_hireapp_detail det join gms_device_hireapp app on det.device_hireapp_id=app.device_hireapp_id where app.bsflag='0' )tmp ";
				prosql += "where project_info_no='<%=projectInfoNo%>' and bsflag='0' group by device_allapp_detid,dev_ci_code) ";
				prosql += "tmp on aad.device_allapp_detid = tmp.device_allapp_detid ";
				prosql += "where aad.device_allapp_id='"+device_allapp_id+"' and aad.project_info_no='<%=projectInfoNo%>' and aad.bsflag='0' ";
				//项目资源配置中录入的
				prosql+=" and aad.resourceflag is null union all "
				prosql+="select aad.device_allapp_detid,aad.team,aad.teamid,aad.dev_ci_code,aad.isdevicecode,aad.dev_name as dev_ci_name,aad.dev_type as dev_ci_model,sd.coding_name as unit_name,teamsd.coding_name as teamname,p6.name as jobname,aad.approve_num as require_num,aad.purpose,aad.plan_start_date,aad.plan_end_date,aad.unitinfo,nvl(tmp.applyed_num, 0) as applyed_num,aad.project_info_no ";
				prosql += "from gms_device_allapp_detail aad ";
				prosql += "left join bgp_p6_activity p6 on aad.teamid = p6.object_id ";
				prosql += "left join comm_coding_sort_detail teamsd on aad.team = teamsd.coding_code_id ";
				prosql += "left join comm_coding_sort_detail sd on aad.unitinfo=sd.coding_code_id ";
				prosql += "left join gms_device_codeinfo ci on aad.dev_ci_code = ci.dev_ci_code ";
				prosql += "left join gms_device_codetype ct on aad.dev_ci_code = ct.dev_ct_code ";
				prosql += "left join ";
				prosql += "(select device_allapp_detid,dev_ci_code,sum(apply_num) as applyed_num ";
				prosql += "from (select det.project_info_no,det.bsflag,det.device_allapp_detid,det.dev_ci_code,det.apply_num,'1' as type ";
				prosql += "from gms_device_app_detail det join gms_device_app app on det.device_app_id=app.device_app_id where app.bsflag='0' union all ";
				prosql += "select det.project_info_no,det.bsflag,det.device_allapp_detid,det.dev_ci_code,det.apply_num,'2' as type ";
				prosql += "from gms_device_hireapp_detail det join gms_device_hireapp app on det.device_hireapp_id=app.device_hireapp_id where app.bsflag='0' )tmp ";
				prosql += "where project_info_no='<%=projectInfoNo%>' and bsflag='0' group by device_allapp_detid,dev_ci_code) ";
				prosql += "tmp on aad.device_allapp_detid = tmp.device_allapp_detid ";
				prosql += "where aad.device_allapp_id='"+device_allapp_id+"' and aad.project_info_no='<%=projectInfoNo%>' and aad.bsflag='0' and aad.resourceflag='0' and aad.device_addapp_id is null ";
				//项目资源补充配置中录入审核通过的
				//prosql += "union all select aad.device_allapp_detid,aad.team,aad.teamid,aad.dev_ci_code,aad.isdevicecode,aad.dev_name as dev_ci_name,aad.dev_type as dev_ci_model,sd.coding_name as unit_name,teamsd.coding_name as teamname,p6.name as jobname,aad.approve_num as require_num,aad.purpose,aad.plan_start_date,aad.plan_end_date,aad.unitinfo,nvl(tmp.applyed_num, 0) as applyed_num,aad.project_info_no ";
				//prosql += "from gp_middle_resources r left join common_busi_wf_middle wf on r.mid=wf.business_id and wf.bsflag='0' ";
				//prosql += "left join gms_device_allapp_add  al on r.dev_id=al.device_addapp_id and al.bsflag='0' ";
				//prosql += "left join gms_device_allapp_detail aad on al.device_addapp_id=aad.device_addapp_id ";
				//prosql += "left join bgp_p6_activity p6 on aad.teamid = p6.object_id ";
				//prosql += "left join comm_coding_sort_detail teamsd on aad.team = teamsd.coding_code_id ";
				//prosql += "left join comm_coding_sort_detail sd on aad.unitinfo=sd.coding_code_id ";
				//prosql += "left join gms_device_codeinfo ci on aad.dev_ci_code = ci.dev_ci_code ";
				//prosql += "left join gms_device_codetype ct on aad.dev_ci_code = ct.dev_ct_code ";
				//prosql += "left join ";
				//prosql += "(select device_allapp_detid,dev_ci_code,sum(apply_num) as applyed_num ";
				//prosql += "from (select det.project_info_no,det.bsflag,det.device_allapp_detid,det.dev_ci_code,det.apply_num,'1' as type ";
				//prosql += "from gms_device_app_detail det join gms_device_app app on det.device_app_id=app.device_app_id where app.bsflag='0' union all ";
				//prosql += "select det.project_info_no,det.bsflag,det.device_allapp_detid,det.dev_ci_code,det.apply_num,'2' as type ";
				//prosql += "from gms_device_hireapp_detail det join gms_device_hireapp app on det.device_hireapp_id=app.device_hireapp_id where app.bsflag='0' )tmp ";
				//prosql += "where project_info_no='<%=projectInfoNo%>' and bsflag='0' group by device_allapp_detid,dev_ci_code) ";
				//prosql += "tmp on aad.device_allapp_detid = tmp.device_allapp_detid ";
				//prosql += "where aad.device_allapp_id='"+device_allapp_id+"' and aad.project_info_no='<%=projectInfoNo%>' and aad.bsflag='0' and aad.resourceflag='0' and r.supplyflag='0' and wf.proc_status='3' ";

			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql+'&pageSize=10000');
			retObj = proqueryRet.datas;
		}	
		for(var index=0;index<retObj.length;index++){
			var devoutorgName;
			//动态新增表格
			var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
			//innerhtml += "<td width='5%'><input type='checkbox' name='detinfo' id='"+index+"' value='"+retObj[index].device_allapp_detid+"' checked/></td>";
			innerhtml += "<td width='5%'>"+(index+1)+"</td>";
			//innerhtml += "<td width='8%'>";
			//innerhtml += "<input name='detid"+index+"' id='detid"+index+"' style='line-height:15px' value='"+retObj[index].device_allapp_detid+"' type='hidden' /></td>";
			//innerhtml += "<input name='teamid"+index+"' id='teamid"+index+"' style='line-height:15px' value='"+retObj[index].teamid+"' type='hidden' />";
			//innerhtml += "<input name='teamname"+index+"' id='teamname"+index+"' value='"+retObj[index].teamname+"' size='7' type='text' readonly/>";
			//innerhtml += "<input name='team"+index+"' id='teamid"+index+"' value='"+retObj[index].team+"' type='hidden'/></td>";			
			innerhtml += "<td width='10%'><input name='detid"+index+"' id='detid"+index+"' style='line-height:15px' value='"+retObj[index].device_allapp_detid+"' type='hidden' />";
			innerhtml += "<input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='"+retObj[index].dev_ci_name+"' size='10' type='text' readonly/></td>";
			innerhtml += "<td width='10%'><input name='devicetype"+index+"' id='devicetype"+index+"' value='"+retObj[index].dev_ci_model+"' size='10'  type='text' readonly/>";
			innerhtml += "<input name='colldevicetype"+index+"' id='colldevicetype"+index+"' value='"+retObj[index].dev_type+"' type='hidden' />";		
			innerhtml += "<input name='signtype"+index+"' id='signtype"+index+"' value='"+retObj[index].dev_ci_code+"' type='hidden' /></td>";			
			innerhtml += "<td width='4%'><input name='unitname"+index+"' id='unitname"+index+"' value='"+retObj[index].unit_name+"' size='4' type='text' readonly>";
			innerhtml += "<input name='unitinfo"+index+"' id='unitinfo"+index+"' value='"+retObj[index].unitinfo+"' type='hidden'></td>";			
			innerhtml += "<td width='5%'><input name='neednum"+index+"' id='neednum"+index+"' value='"+retObj[index].require_num+"' size='4' type='text' readonly/></td>";			
			innerhtml += "<td width='12%'><input name='startdate"+index+"' id='startdate"+index+"' style='line-height:15px' value='"+retObj[index].plan_start_date+"' size='10' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(startdate"+index+",tributton2"+index+");'/></td>";
			innerhtml += "<td width='12%'><input name='enddate"+index+"' id='enddate"+index+"' style='line-height:15px' value='"+retObj[index].plan_end_date+"' size='10' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+index+",tributton3"+index+");'/></td>";
			innerhtml += "<td width='8%'><input name='purpose"+index+"' id='purpose"+index+"' value='"+retObj[index].purpose+"' size='8' type='text' /></td>";
			innerhtml += "<td width='7%'><select name='devoutorgid"+index+"' id='devoutorgid"+index+"'></select></td>";
			innerhtml += "</tr>";
			$("#processtable").append(innerhtml);
			//查询公共代码，并且回填到界面的单位中
			var devoutorgidObj;
			var devoutorgidSql = "select t.coding_code_id as value,t.coding_name as label from comm_coding_sort_detail t where t.coding_sort_id='5110000070'";
			var devoutorgidRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devoutorgidSql+'&pageSize=1000');
			devoutorgidObj = devoutorgidRet.datas;
			var devoutorgidhtml = "<option >请选择...</option>";
			for(var i=0;i<devoutorgidObj.length;i++){
				if(devoutorgidObj[i].label == devoutorgName){
					devoutorgidhtml +=  "<option value='"+devoutorgidObj[i].value+"' selected>"+devoutorgidObj[i].label+"</option>";
				}else{
					devoutorgidhtml +=  "<option value='"+devoutorgidObj[i].value+"'>"+devoutorgidObj[i].label+"</option>";
				}
			}
			$("#devoutorgid"+index).append(devoutorgidhtml);
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
				alert("申请数量必须小于等于需求数量!");
				obj.value = "";
				return false;
			}else if((parseInt(value,10)+applyednumval)>neednumval){
				alert("申请数量必须小于等于未申请数量!");
				obj.value = "";
				return false;
			}
		}
	}
</script>
</html>

