<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String devicebackappid = request.getParameter("devicebackappid");
	if(devicebackappid==null){
		devicebackappid = "";
	}
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getEmpId();
	String org_id = user.getOrgId();
	String org_subjection_id = user.getOrgSubjectionId();
	String userName = user.getUserName();
	
	//ResourceBundle rb = ResourceBundle.getBundle("devCodeDesc");
	//String[] backTypeIDs = rb.getString("BackTypeID").split("~", -1);
	//String backtypewaizu = backTypeIDs[backTypeIDs.length-1];
	//String[] backTypeNames = rb.getString("BackTypeName").split("~", -1);
	//String[] backTypeUserNames = rb.getString("BackTypeUserName").split("~", -1);
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
<title>井中设备转移返还页面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend style="color:#B0B0B0;">转移设备返还基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >项目名称</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text" value="" style="color:#B0B0B0;" readonly/>
          	<input name="projectInfoNo" id="projectInfoNo" class="input_width" type="hidden" value="<%=projectInfoNo%>"/>
          	<input name="devicebackappid" id="devicebackappid" type="hidden" value="<%=devicebackappid%>" />
          </td>
          <td class="inquire_item4" >返还项目名称</td>
          <td class="inquire_form4" id="selecprojecttd">
			<select id="selectproject" onchange="clearDevList(this.value)" name="selectproject" class="select_width" style="width:230px">
				<option value="">请选择返还项目...</option>
			    </select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		 </td>
        </tr>
        <tr>
          <td class="inquire_item4">返还单位</td>
          <td class="inquire_form4">
          	<input name="back_org_name" id="back_org_name" class="input_width" type="text" value="<%=user.getOrgName()%>" readonly/>
          	<input name="back_org_id" id="back_org_id" class="input_width" value="<%=user.getOrgId()%>" type="hidden" />
          </td>
          <td class="inquire_item4">返还人</td>
          <td class="inquire_form4">
          	<input name="back_employee_name" id="back_employee_name" class="input_width" type="text" value="<%=user.getUserName()%>" readonly/>
          	<input name="back_employee_id" id="back_employee_id" class="input_width" value="<%=user.getEmpId()%>" type="hidden" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">申请时间:</td>
          <td class="inquire_form4">
          	<input name="backdate" id="backdate" class="input_width" type="text" value="" readonly/>
          </td>
        </tr>
      </table>
      </fieldset>
      <div style="overflow:auto">
      	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  	<tr align="right">
		  		<td style="width:90%"></td>
				<td><span class="zj"><a href="#" id="addProcess" name="addProcess" ></a></span></td>
			    <td><span class="sc"><a href="#" id="delProcess" name="delProcess" ></a></span></td>
			    <td style="width:1%"></td>
			</tr>
		  </table>
	  </div>
	  <fieldset style="margin-left:2px"><legend>返还转移设备明细</legend>
		  <div style="height:220px;overflow:auto">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" width="4%"><input type='checkbox' id='devbackinfo' name='devbackinfo'/></td>
					<td class="bt_info_even" width="10%">设备名称</td>
					<td class="bt_info_odd" width="10%">规格型号</td>
					<td class="bt_info_even" width="10%">自编号</td>
					<td class="bt_info_odd" width="12%">实物标识号</td>
					<td class="bt_info_even" width="11%">牌照号</td>
					<!-- <td class="bt_info_odd" width="15%">AMIS设备编号</td> -->
					<td class="bt_info_odd" width="15%">ERP设备编号</td>
					<td class="bt_info_even" width="4%">数量</td>
					<td class="bt_info_odd" width="10%">进队时间</td>
					<td class="bt_info_even" width="12%">离场时间</td>
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
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	$().ready(function(){
		$("#addProcess").click(function(){	
			var outprojectInfoNo = $("#selectproject").val();
			if(outprojectInfoNo == ''){
				alert("请选择返还项目名称!");
				return;
			}
			var projectInfoNo = $("#projectInfoNo").val();
			var paramobj = new Object();
			var selectStr = null;
			$("input[type='checkbox'][name='idinfo']").each(function(i){
				if(this.checked){					
					if(i==0){
						selectStr = "'"+this.id;
					}else{
						selectStr += "','"+this.id;
					}
				}
			});
			if(selectStr!=null){
				selectStr = selectStr + "'";
			}
			paramobj.selectStr = selectStr;
			var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectWellsAccForBack.jsp?projectinfono="+projectInfoNo+"&outprojectinfono="+outprojectInfoNo,paramobj,"dialogWidth=1200px;dialogHeight=480px");
			if(vReturnValue == undefined){
				return;
			}
			var accountidinfos = vReturnValue.split("|","-1");
			var condition ="";
			if(accountidinfos.length == 1){
				var accountids = accountidinfos[0].split("~", -1);
				condition = "('"+accountids[0]+"') ";
			}else{
				for(var index=0;index<accountidinfos.length;index++){
					var accountids = accountidinfos[index].split("~", -1);
					if(index == 0){
						condition = "('"+accountids[0]+"'";
					}else{
						condition += ",'"+accountids[0]+"'";
					}
				}
				condition += ") ";
			}
			var devdetSql = "select out_ve.out_project_info_id,account.dev_acc_id,account.asset_coding, ";
				devdetSql += "account.dev_coding,account.self_num,account.dev_sign, ";
				devdetSql += "account.license_num,account.actual_in_time,to_char(account.planning_out_time,'yyyy-mm-dd') as planning_out_time, ";
				devdetSql += "account.dev_name,account.dev_model ";
				devdetSql += "from gms_device_account_dui account ";
				devdetSql += "left join gms_device_move out_ve on account.fk_wells_transfer_id = out_ve.dev_mov_id ";
				devdetSql += "left join gp_task_project out_pro on out_pro.project_info_no = out_ve.out_project_info_id ";
				devdetSql += "where account.bsflag = '0' and account.dev_acc_id in "+condition ;
				devdetSql += "and account.project_info_id='"+projectInfoNo+"' ";
				devdetSql += "order by account.planning_out_time,account.dev_type";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devdetSql+'&pageSize=10000');
				var retObj = proqueryRet.datas;
				addLine(retObj);
		});
		$("#delProcess").click(function(){
			$("input[type='checkbox'][name='idinfo']").each(function(i){
				if(this.checked){
					var id=this.id;
					$("#tr"+id).remove();
				}
			});
			$("#processtable>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable>tr:odd>td:even").addClass("odd_even");
			$("#processtable>tr:even>td:odd").addClass("even_odd");
			$("#processtable>tr:even>td:even").addClass("even_even");
		});
	});
	function addLine(retObj){
		var rows = document.getElementById("processtable").rows.length;
		for(var index=rows;index<rows+retObj.length;index++){
			var innerhtml = "<tr id='tr"+retObj[index-rows].dev_acc_id+"' name='tr' midinfo='"+retObj[index-rows].dev_acc_id+"'>";
			innerhtml += "<td width='4%'><input type='checkbox' name='idinfo' id='"+retObj[index-rows].dev_acc_id+"' checked/></td>";
			innerhtml += "<td width='10%'>"+retObj[index-rows].dev_name+"</td>";
			innerhtml += "<td width='10%'>"+retObj[index-rows].dev_model+"</td>";
			innerhtml += "<td width='10%'>"+retObj[index-rows].self_num+"</td>";
			innerhtml += "<td width='12%'>"+retObj[index-rows].dev_sign+"</td>";
			innerhtml += "<td width='11%'>"+retObj[index-rows].license_num+"</td>";
			innerhtml += "<td width='15%'>"+retObj[index-rows].dev_coding+"</td>";
			innerhtml += "<td width='4%'>1</td>";
			innerhtml += "<td width='10%'><input name='startdate"+index+"' id='startdate"+index+"' style='line-height:15px' value='"+retObj[index-rows].actual_in_time+"' size='10' type='text' readonly/></td>";
			innerhtml += "<td width='12%'><input name='enddate"+index+"' id='enddate"+index+"' devaccid='"+retObj[index-rows].dev_acc_id+"' style='line-height:15px' value='' onpropertychange='checkEndDate("+index+");' size='10' type='text'/>";
			innerhtml += "<img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+index+",tributton3"+index+");'/></td>";
			
			innerhtml += "</tr>";
			$("#processtable").append(innerhtml);
		}
		$("#processtable>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable>tr:odd>td:even").addClass("odd_even");
		$("#processtable>tr:even>td:odd").addClass("even_odd");
		$("#processtable>tr:even>td:even").addClass("even_even");
	}
	function clearDevList(index){
		//$("#tr"+index,"#processtable").remove();
		$("input[type='checkbox'][name='idinfo']").each(function(i){
			if(this.checked){
				var id=this.id;
				$("#tr"+id).remove();
			}
		});
	}
	function checkEndDate(index){
		var startTime = $("#startdate"+index).val();
		var returnTime = $("#enddate"+index).val();
		if(startTime!=null&&startTime!=''&&returnTime!=null&&returnTime!=''){
			var days=(new Date(returnTime.replace(/-/g,'/'))-new Date(startTime.replace(/-/g,'/')))/3600/24/1000;
			if(days<0){
				alert("计划离开时间应大于计划进入时间");
				$("#enddate"+index).val("");
				return false;
			}
			
		}
		return true;
	}
	function submitInfo(){
		var outprojectInfoNo = $("#selectproject").val();
		if(outprojectInfoNo == ''){
			alert("请选择返还项目名称!");
			return;
		}
		//保留的行信息
		var count = 0;
		var idinfos;
		var enddateinfo;
		$("input[type='checkbox'][name='idinfo']").each(function(){
			if(count == 0){
				idinfos = this.id;
				enddateinfo = $("input[id^='enddate'][devaccid='"+this.id+"']").val();
			}else{
				idinfos = idinfos+"~"+this.id;
				enddateinfo = enddateinfo+"~"+$("input[id^='enddate'][devaccid='"+this.id+"']").val();
			}
			count++;
		});
		if(count == 0){
			alert('请添加返还申请明细信息！');
			return;
		}
	
		var count = $("#processtable>tr").size();
		var wronglineinfos = "";
		for(var index=0;index<count;index++){
			var enddate_tmp = $("#enddate"+index).val();
			if(enddate_tmp == ""){
				if(index == 0){
					wronglineinfos += (index+1);
				}else{
					wronglineinfos += ","+(index+1);
				}
			}
		}
		if(wronglineinfos!=""){
			alert("请填写第"+wronglineinfos+"行的实际离场日期!");
			return;
		}
	
		if(confirm("确认提交？")){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveBackWellsDevDetInfo.srq?count="+count+"&idinfos="+idinfos+"&enddateinfo="+enddateinfo;
			document.getElementById("form1").submit();
		}
	}
	function refreshData(){
		var retObj;
		var basedatas;
		var devicebackappid = '<%=devicebackappid%>';
		var proSql = "select project_info_no,project_name,to_char(sysdate,'yyyy-mm-dd') as backdate from gp_task_project where project_info_no= '<%=projectInfoNo%>' ";
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql);
		
		if(proqueryRet!=null && proqueryRet.returnCode =='0'){
			retObj = proqueryRet.datas;
			//将项目信息放在里面
			$("#project_name").val(retObj[0].project_name);
			$("#projectInfoNo").val(retObj[0].project_info_no);
			$("#backdate").val(retObj[0].backdate);
		}

		//查询公共代码，并且回填到界面的单位中
		var outsql;
		var outObj;
		var outsqlRet
		var outsql = "select out_ve.out_project_info_id,case when out_ve.out_project_info_id = 'C6000000007250' then '井中设备分中心' else regexp_substr(wm_concat(out_pro.project_name), '[^,]+', 1, 1) end as out_projectname ";
			outsql += "from gms_device_account_dui t left join gms_device_move out_ve on t.fk_wells_transfer_id = out_ve.dev_mov_id ";
			outsql += "left join gp_task_project out_pro on out_pro.project_info_no = out_ve.out_project_info_id ";
			outsql += "where t.bsflag = '0' and t.transfer_state = '0' and t.project_info_id= '<%=projectInfoNo%>' group by out_ve.out_project_info_id ";
		var outsqlRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+outsql+'&pageSize=1000');
			outObj = outsqlRet.datas;
			if(outObj!=undefined && outObj.length>0){
				//回填基本信息
				for(var index=0;index<outObj.length;index++){
					var innerhtml = "<option value='"+outObj[index].out_project_info_id+"'>"+outObj[index].out_projectname+"</option>";
					$("#selectproject").append(innerhtml);
				}
			}
			//给模板放进内容 end
			$("#selectproject").val("");
			$("#selectprojecttd").show();
		
	}
	$().ready(function(){
		$("#devbackinfo").change(function(){
			var checkvalue = this.checked;
			$("input[type='checkbox'][name^='idinfo']").attr('checked',checkvalue);
		});
	});
</script>
</html>

