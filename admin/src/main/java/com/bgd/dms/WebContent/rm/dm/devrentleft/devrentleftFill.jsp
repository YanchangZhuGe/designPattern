<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	String devaccid = request.getParameter("devaccid");
	
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getEmpId();
	String org_id = user.getOrgId();
	String org_subjection_id = user.getOrgSubjectionId();
	String userName = user.getUserName();
	String projectinfono = user.getProjectInfoNo();
	String projectName = user.getProjectName();
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	String appDate = df.format(new Date());
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

<title>单项目-外租离场-确定离场按钮页面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData()">
<form name="form1" id="form1" method="post" action="">
<input type="hidden" id="detail_count" value="" />
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <fieldset style="margin-left:2px"><legend style="color:#B0B0B0;">外租离场基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >项目名称</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text" value="<%=projectName %>" style="color:#B0B0B0;" readonly/>
          	<input name="projectInfoNo" id="projectInfoNo" class="input_width" type="hidden" value="<%=projectinfono %>"/>
          </td>
           <td class="inquire_item4">返还单位</td>
          <td class="inquire_form4">
          	<input name="back_org_name" id="back_org_name" class="input_width" type="text" style="color:#B0B0B0;" value="" readonly/>
          </td>
        </tr>
        <tr>
         <td class="inquire_item4">返还时间:</td>
          <td class="inquire_form4">
          	<input name="backdate" id="backdate" class="input_width" type="text" style="color:#B0B0B0;" value="<%=appDate %>" readonly/>
          </td>
          <td class="inquire_item4">返还人</td>
          <td class="inquire_form4">
          	<input name="back_employee_name" id="back_employee_name" class="input_width" type="text" style="color:#B0B0B0;" value="<%=user.getUserName()%>" readonly/>
          </td>
        </tr>
      </table>
      </fieldset>
      <fieldset style="margin-left:2px"><legend>外租离场设备明细</legend>
		  <div style="height:220px;overflow:auto">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" width="4%">序号</td>
					<td class="bt_info_even" width="10%">设备名称</td>
					<td class="bt_info_odd" width="10%">规格型号</td>
					<td class="bt_info_even" width="10%">自编号</td>
					<td class="bt_info_odd" width="12%">实物标识号</td>
					<td class="bt_info_even" width="11%">牌照号</td>
					<td class="bt_info_odd" width="10%">计划离场时间</td>
					<td class="bt_info_even" width="12%">实际离场时间</td>
				</tr>
			   </table>
				<div style="height:190px;overflow:auto;">
				<table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style='table-layout: auto'>
			  		<tbody id="processtable" name="processtable" >
			   		</tbody>
		      	</table>
		      </div>
	       </div>
      </fieldset>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a id="submitButton" href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	
	function refreshData(){
		var devaccid = '<%=devaccid%>';
		var temp = devaccid.split(",");
		var idss = "";
		
		if(devaccid!=null){
			var querysql = "select n.org_name,pro.project_name,account.dev_acc_id,account.asset_coding,account.self_num,account.dev_sign,account.project_info_id, ";
			querysql += "account.license_num,account.actual_in_time,account.planning_out_time,account.actual_out_time, ";
			querysql += "account.dev_name,account.dev_model,account.fk_dev_acc_id,account.planning_in_time,account.is_leaving ";
			querysql += "from gms_device_account_dui account ";
			querysql += "left join comm_coding_sort_detail sd on sd.coding_code_id = account.account_stat ";
			querysql += "left join gp_task_project pro on account.project_info_id = pro.project_info_no and pro.bsflag='0' ";
			querysql += "left join comm_org_information n on n.org_id=account.usage_org_id ";
			querysql += "where account.account_stat='0110000013000000005' ";
			querysql += "and account.dev_acc_id in (";
			
			for(var i=0;i<temp.length;i++){
				if(idss!="") idss += ",";
				idss += "'"+temp[i]+"'";
			}
			querysql = querysql+idss+")";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querysql+'&pageSize=1000');
			retObj = proqueryRet.datas;
		}
		$("#back_org_name").val(retObj[0].org_name);
		
		for(var index=0;index<retObj.length;index++){
			//动态新增表格
			var innerhtml = "<tr id='tr"+retObj[index].dev_acc_id+"' name='tr' fkidinfo='"+retObj[index].fk_dev_acc_id+"' midinfo='"+retObj[index].dev_acc_id+"'>";
			innerhtml += "<td width='4%'>"+(index+1)+"</td>";
			innerhtml += "<td width='10%'>"+retObj[index].dev_name+"</td>";
			innerhtml += "<td width='10%'>"+retObj[index].dev_model+"</td>";
			innerhtml += "<td width='10%'>"+retObj[index].self_num+"</td>";
			innerhtml += "<td width='12%'>"+retObj[index].dev_sign+"</td>";
			innerhtml += "<td width='11%'>"+retObj[index].license_num+"</td>";
			innerhtml += "<td width='10%'>"+retObj[index].planning_out_time+"</td>";
			innerhtml += "<td width='12%'><input name='enddate"+index+"' id='enddate"+index+"' devaccid='"+retObj[index].dev_acc_id+"' style='line-height:15px' value='"+retObj[index].planning_out_time+"' size='10' type='text' readonly/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+index+",tributton3"+index+");'/></td>";
			
			innerhtml += "</tr>";
			$("#processtable").append(innerhtml);
		}
		$("#processtable>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable>tr:odd>td:even").addClass("odd_even");
		$("#processtable>tr:even>td:odd").addClass("even_odd");
		$("#processtable>tr:even>td:even").addClass("even_even");
		
	}
	function submitInfo(){
		//保留的行信息
		var count = 0;
		var idinfos;
		var fkidinfos;
		var enddateinfo;
		$("tr","#processtable").each(function(){
			if(count == 0){
				idinfos = this.midinfo;
				fkidinfos = this.fkidinfo;
				enddateinfo = $("input[id^='enddate'][devaccid='"+this.midinfo+"']").val();
			}else{
				idinfos = idinfos+"~"+this.midinfo;
				fkidinfos = fkidinfos+"~"+this.fkidinfo;
				enddateinfo = enddateinfo+"~"+$("input[id^='enddate'][devaccid='"+this.midinfo+"']").val();
			}
			count++;
		});
		if(count == 0){
			alert('请添加外租设备明细信息！');
			return;
		}
		if(confirm("确认提交？")){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveRentDevLeftInfo.srq?count="+count+"&idinfos="+idinfos+"&enddateinfo="+enddateinfo+"&fkidinfos="+fkidinfos;
			document.getElementById("form1").submit();
			document.getElementById("submitButton").onclick = "";
		}
	}
</script>
</html>

