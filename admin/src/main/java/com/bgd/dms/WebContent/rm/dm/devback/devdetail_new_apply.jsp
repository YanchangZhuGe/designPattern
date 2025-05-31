<%@page contentType="text/html;charset=UTF-8" pageEncoding="GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.util.DateUtil"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String selectedStr = request.getParameter("selectedStr");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getEmpId();
	String userName = user.getUserName();
	String backdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd hh:mm:ss");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>新建返还单</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <fieldset style="margin-left:2px"><legend>返还单基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">项目名称</td>
          <td class="inquire_form4">
          	<input name="project_name" id="project_name" class="input_width" type="text" value="" readonly/>
          	<input name="project_info_id" id="project_info_id" class="input_width" type="hidden" value=""/>
          </td>
          <td class="inquire_item4">返还单号:</td>
          <td class="inquire_form4"><input name="mixinfo_no" id="mixinfo_no" class="input_width" type="text" value="提交后自动生成..." readonly/></td>
        </tr>
        <tr>
          <td class="inquire_item4">转出单位:</td>
          <td class="inquire_form4">
          	<input name="in_org_name" id="out_org_name" class="input_width" type="text" readonly/>
          	<input name="in_org_id" id="out_org_id" class="input_width" type="hidden" />
          </td>
          <td class="inquire_item4">返还单位</td>
          <td class="inquire_form4">
          	<input name="out_org_name" id="back_org_name" class="input_width" type="text" value="<%=user.getOrgName()%>" readonly/>
          	<input name="out_org_id" id="back_org_id" class="input_width" value="<%=user.getOrgId()%>" type="hidden" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">申请时间:</td>
          <td class="inquire_form4">
          	<input name="backdate" id="backdate" class="input_width" type="text" value="<%=backdate%>" readonly/>
          </td>
          <td class="inquire_item4">申请人</td>
          <td class="inquire_form4">
          	<input name="back_employee_name" id="back_employee_name" class="input_width" type="text" value="<%=user.getUserName()%>" readonly/>
          	<input name="back_employee_id" id="back_employee_id" class="input_width" value="<%=user.getEmpId()%>" type="hidden" />
          </td>
        </tr>
      </table>
      </fieldset>
      <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  	<tr >
	  		<td width="10%" align="right">
	  		</td>
			<td width="90%" align="right">
				<input type="button" id="addProcess" name="addDev" class="custom_buttons" value="添加返还设备" />
				<input type="button" id="delProcess" name="delDev" class="custom_buttons" value="删除返还设备" />
			</td>
		</tr>
	  </table>
	  <fieldset style="margin-left:2px"><legend>调配明细信息</legend>
		  <div style="height:100px;overflow:auto">
		  <table width="99%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	       <tr>
				<td class="bt_info_odd" width="4%">选择</td>
				<td class="bt_info_even" width="6%">序号</td>
				<td class="bt_info_odd" width="8%">设备编码</td>
				<td class="bt_info_even" width="8%">设备名称</td>
				<td class="bt_info_odd" width="8%">规格型号</td>
				<td class="bt_info_even" width="8%">自编号</td>
				<td class="bt_info_odd" width="9%">实物标识号</td>
				<td class="bt_info_even" width="8%">牌照号</td>
				<td class="bt_info_odd" width="13%">实际进场时间</td>
				<td class="bt_info_even" width="13%">计划离场时间</td>
			</tr>
		   <tbody id="backDevtable" name="backDevtable">
		   </tbody>
	      </table>
	      </div>
	    </fieldset>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
     	<span class="bc_btn"><a href="#" onclick="saveInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript"> 
	$().ready(function(){
		$("#addProcess").click(function(){
			var in_org_id = $("#in_org_id").val();
			if(in_org_id==''){
				alert("请选择转入单位!");
				return;
			}
			var obj = new Object();
			var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/devmixdetail/selectMDM.jsp?in_org_id="+in_org_id,obj,"dialogWidth=305px;dialogHeight=420px");
			var seq = $("tr","#processtable").size();
			if(vReturnValue!=undefined){
				var returnvalues = vReturnValue.split('~');
				var innerhtml = "<tr id='tr"+returnvalues[0]+"' name='tr'>";
				innerhtml += "<td><input type='checkbox' name='idinfo' id='"+returnvalues[0]+"'/></td>";
				innerhtml += "<td>"+(seq+1)+"<input type='hidden' id='mdmid'"+seq+" name='mdmid' value='"+returnvalues[0]+"'></td>";
				innerhtml += "<td>"+returnvalues[2]+"</td>";
				innerhtml += "<td>"+returnvalues[3]+"</td>";
				innerhtml += "<td>"+returnvalues[4]+"</td>";
				innerhtml += "<td>"+returnvalues[1]+"</td>";
				innerhtml += "</tr>";
			
				$("#processtable").append(innerhtml);
				//异步查询设备明细信息，回填到设备明细中
			}
			$("#processtable>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable>tr:odd>td:even").addClass("odd_even");
			$("#processtable>tr:even>td:odd").addClass("even_odd");
			$("#processtable>tr:even>td:even").addClass("even_even");
			if(returnvalues[0]!=null){
				var devdetSql = "select mdm.device_mix_mainid,amd.dev_coding,ad.dev_ci_code,ci.dev_ci_name,ci.dev_ci_model,amd.self_num,amd.dev_sign,";
				devdetSql += "amd.license_num,amd.dev_plan_start_date,amd.dev_plan_end_date ";
				devdetSql += "from gms_device_appmix_detail amd ";
				devdetSql += "left join gms_device_mixdetail_main mdm  on mdm.device_mix_mainid = amd.device_mix_mainid ";
				devdetSql += "left join gms_device_appmix_main amm on mdm.device_mix_id = amm.device_mix_id ";
				devdetSql += "left join gms_device_app_detail ad on amm.device_appdet_id = ad.device_appdet_id ";
				devdetSql += "left join gms_device_codeinfo ci on ci.dev_ci_code = ad.dev_ci_code ";
				devdetSql += "left join gms_device_app app on ad.device_app_id = app.device_app_id ";
				devdetSql += "left join gms_device_mixinfo_detail mid on mid.device_mix_mainid = mdm.device_mix_mainid ";
				devdetSql += "where mdm.state = '9' and mdm.device_mix_mainid = '"+returnvalues[0]+"' ";
				devdetSql += "order by amd.dev_coding";
				var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devdetSql);
				retObj = proqueryRet.datas;
				for(var index=0;index<retObj.length;index++){
					var innerhtml = "<tr id='tr"+retObj[index].dev_coding+"' name='tr' mdminfo='"+retObj[index].device_mix_mainid+"'>";
					innerhtml += "<td>"+retObj[index].dev_coding+"</td>";
					innerhtml += "<td>"+retObj[index].dev_ci_name+"</td>";
					innerhtml += "<td>"+retObj[index].dev_ci_model+"</td>";
					innerhtml += "<td>"+retObj[index].self_num+"</td>";
					innerhtml += "<td>"+retObj[index].dev_sign+"</td>";
					innerhtml += "<td>"+retObj[index].license_num+"</td>";
					innerhtml += "<td>1</td>";
					innerhtml += "<td>"+retObj[index].dev_plan_start_date+"</td>";
					innerhtml += "<td>"+retObj[index].dev_plan_end_date+"</td>";
					innerhtml += "</tr>";
					$("#detailtable").append(innerhtml);
				}
				$("#detailtable>tr:odd>td:odd").addClass("odd_odd");
				$("#detailtable>tr:odd>td:even").addClass("odd_even");
				$("#detailtable>tr:even>td:odd").addClass("even_odd");
				$("#detailtable>tr:even>td:even").addClass("even_even");
			}
		});
		$("#delProcess").click(function(){
			$("input[type='checkbox'][name='idinfo']").each(function(i){
				if(this.checked){
					var id=this.id;
					$("#tr"+id).remove();
					$("tr[name='tr'][mdminfo='"+id+"']","#detailtable").each(function(){
						$(this).remove();
					});
				}
			});
			$("#processtable>tbody>tr>td:odd").addClass("odd_odd");
			$("#processtable>tbody>tr>td:even").addClass("odd_even");
			$("#processtable>tbody>tr>td:odd").addClass("even_odd");
			$("#processtable>tbody>tr>td:even").addClass("even_even");
			$("#detailtable>tbody>tr>td:odd").addClass("odd_odd");
			$("#detailtable>tbody>tr>td:even").addClass("odd_even");
			$("#detailtable>tbody>tr>td:odd").addClass("even_odd");
			$("#detailtable>tbody>tr>td:even").addClass("even_even");
		});
	});
	function saveInfo(){
		var selectedids = $("input[type='checkbox'][name='idinfo']").size();
		alert(selectedids);
		if(selectedids==0){
			alert("请添加返还单明细信息!");
			return;
		}else{
			selectedids = "";
			$("input[type='checkbox'][name='idinfo']").each(function(i){
				if(i!=0){
					selectedids += "~"
				}
				selectedids += this.value;
			});
		}
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveBackAppInfo.srq?state=0&selectedids="+selectedids;
		document.getElementById("form1").submit();
	}
	
	function submitInfo(){
		var selectedids = $("input[type='checkbox'][name='idinfo']").size();
		alert(selectedids);
		if(selectedids==0){
			alert("请添加返还单明细信息!");
			return;
		}else{
			selectedids = "";
			$("input[type='checkbox'][name='idinfo']").each(function(i){
				if(i!=0){
					selectedids += "~"
				}
				selectedids += this.value;
			});
		}
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveBackAppInfo.srq?state=9&selectedids="+selectedids;
		document.getElementById("form1").submit();
	}
	
	function showInOrgIdPage(devappid){
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/devmixdetail/selectInOrgId.jsp?devappid="+devappid,obj,"dialogWidth=305px;dialogHeight=420px");
		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split('~');
			$("#in_org_id").val(returnvalues[0]);
			$("#in_org_name").val(returnvalues[1]);
		}
	}
	function refreshData(){
		var retObj;
		var projectInfoNos = '<%=projectInfoNo%>';
		var selectedStr = '<%=selectedStr%>';
		var ids = selectedStr.split("," , -1);
		if(selectedStr!=null){
			//查询明细信息
			var proSql = "select duiacc.dev_acc_id,duiacc.project_info_id,pro.project_name,duiacc.dev_coding,";
			proSql += "duiacc.dev_name,duiacc.dev_model,duiacc.self_num,duiacc.dev_sign,duiacc.license_num,";
			proSql += "duiacc.planning_in_time,duiacc.planning_out_time,";
			proSql += "duiacc.actual_in_time,duiacc.account_stat,duiacc.out_org_id,org.org_name as out_org_name ";
			proSql += "from gms_device_account_dui duiacc ";
			proSql += "left join gp_task_project pro on duiacc.project_info_id = pro.project_info_no ";
			proSql += "left join comm_org_information org on duiacc.out_org_id = org.org_id ";
			proSql += "where duiacc.project_info_id = '"+projectInfoNos+"' ";
			proSql += "and not exists(select 1 from gms_device_backapp_detail detail left join gms_device_backapp backapp ";
			proSql += "on detail.device_backapp_id=backapp.device_backapp_id ";
			proSql += "where detail.dev_acc_id =duiacc.fk_dev_acc_id and backapp.project_info_id='"+projectInfoNos+"') ";
			if(ids.length>=2){
				proSql += "and duiacc.dev_acc_id in (";
				for(var index=0;index<=ids.length;index++){
					if(index!=0){
						proSql += ",";
					}
					proSql += "'"+ids[index]+"'"
					
				}
				proSql += ") ";
			}else if(ids.length==1){
				proSql += "and duiacc.dev_acc_id='"+selectedStr+"' ";
			}
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql);
			retObj = proqueryRet.datas;
			//查询出多条，回填下面的输入框
			for(var index=0;index<retObj.length;index++){
				if(index==0){
					$("#project_info_id").val(retObj[index].project_info_id);
					$("#project_name").val(retObj[index].project_name);
					$("#out_org_name").val(retObj[index].out_org_name);
					$("#out_org_id").val(retObj[index].out_org_id);
				}
				var seq = $("tr","#backDevtable").size();
				var innerhtml = "<tr id='tr"+retObj[index].dev_acc_id+"' name='tr' mdminfo='"+retObj[index].dev_acc_id+"'>";
				innerhtml += "<td><input type='checkbox' name='idinfo' id='"+retObj[index].dev_acc_id+"' value='"+retObj[index].dev_acc_id+"'/></td>";
				innerhtml += "<td>"+(seq+1)+"</td>";
				innerhtml += "<td>"+retObj[index].dev_coding+"</td>";
				innerhtml += "<td>"+retObj[index].dev_name+"</td>";
				innerhtml += "<td>"+retObj[index].dev_model+"</td>";
				innerhtml += "<td>"+retObj[index].self_num+"</td>";
				innerhtml += "<td>"+retObj[index].dev_sign+"</td>";
				innerhtml += "<td>"+retObj[index].license_num+"</td>";
				innerhtml += "<td>"+retObj[index].actual_in_time+"</td>";
				innerhtml += "<td>"+retObj[index].planning_out_time+"</td>";
				innerhtml += "</tr>";
				$("#backDevtable").append(innerhtml);
			}
			$("#backDevtable>tr:even>td:odd").addClass("odd_odd");
			$("#backDevtable>tr:even>td:even").addClass("odd_even");
			$("#backDevtable>tr:odd>td:odd").addClass("even_odd");
			$("#backDevtable>tr:odd>td:even").addClass("even_even");
		}
	}
</script>
</html>

