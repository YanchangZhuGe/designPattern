<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String devicebackappid = request.getParameter("devicebackappid");
	if(devicebackappid==null || devicebackappid.trim().equals("")){
		devicebackappid = "";
	}
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getEmpId();
	String org_id = user.getOrgId();
	System.out.println("org_id == "+org_id);
	String org_subjection_id = user.getOrgSubjectionId();
	String userName = user.getUserName();
	
	ResourceBundle rb = ResourceBundle.getBundle("devCodeDesc");
	String[] backTypeIDs = rb.getString("BackTypeID").split("~", -1);
	String backtypewaizu = backTypeIDs[backTypeIDs.length-1];
	String[] backTypeNames = rb.getString("BackTypeName").split("~", -1);
	String[] backTypeUserNames = rb.getString("BackTypeUserName").split("~", -1);
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
<title>单项目-设备返还-更换设备-新增按钮子页面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend style="color:#B0B0B0;">送修申请基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text" value="" readonly/>
          	<input name="projectInfoNo" id="projectInfoNo" type="hidden" value="<%=projectInfoNo%>" />
          	<input name="devicebackappid" id="devicebackappid" type="hidden" value="<%=devicebackappid%>" />
          </td>
          <td class="inquire_item4">更换申请单号:</td>
          <td class="inquire_form4">
          	<input name="device_backapp_no" id="device_backapp_no" class="input_width" type="text" value="提交后自动生成..." readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >更换申请单名称:</td>
          <td class="inquire_item4" >
          	<input name="backappname" id="backappname" class="input_width" type="text" value="" />
          </td>
          <td class="inquire_item4">返还单位:</td>
          <td class="inquire_form4">
          	<input name="back_org_name" id="back_org_name" class="input_width" type="text" readonly/>
          	<input name="back_org_id" id="back_org_id" class="input_width" type="hidden" />
          </td>
        </tr>
        <!-- <tr>
          <td class="inquire_item4">返还单位:</td>
          <td class="inquire_form4">
          	<input name="back_org_name" id="back_org_name" class="input_width" type="text" readonly/>
          	<input name="back_org_id" id="back_org_id" class="input_width" type="hidden" />
          </td>
          <td class="inquire_item4"><font color=red>*</font>&nbsp;接收单位:</td>
          <td class="inquire_form4">
          	<input name="receive_org_name" id="receive_org_name" class="input_width" type="text" readonly/>
          	<input name="receive_org_id" id="receive_org_id" class="input_width" type="hidden" />
          	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOrgTreePage()"  />
          </td>
        </tr> -->
        <tr>
          <td class="inquire_item4">申请时间:</td>
          <td class="inquire_form4">
          	<input name="backdate" id="backdate" class="input_width" type="text" value="" readonly/>
          </td>
          <td class="inquire_item4">申请人</td>
          <td class="inquire_form4">
          	<input name="back_employee_name" id="back_employee_name" class="input_width" type="text" value="<%=user.getUserName()%>" readonly/>
          	<input name="back_employee_id" id="back_employee_id" class="input_width" value="<%=user.getEmpId()%>" type="hidden" />
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
	  <fieldset style="margin-left:2px"><legend>送修申请明细</legend>
		  <div style="height:220px;overflow:auto">
			  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" width="4%"><input type='checkbox' id='devbackinfo' name='devbackinfo'/></td>
					<td class="bt_info_even" width="10%">设备名称</td>
					<td class="bt_info_odd" width="10%">规格型号</td>
					<td class="bt_info_even" width="10%">自编号</td>
					<td class="bt_info_odd" width="12%">实物标识号</td>
					<td class="bt_info_even" width="11%">牌照号</td>
					<td class="bt_info_odd" width="15%">ERP设备编号</td>
					<td class="bt_info_even" width="4%">数量</td>
					<td class="bt_info_odd" width="10%">计划离场时间</td>
					<td class="bt_info_even" width="12%"><font color='red'>实际离场时间</font></td>
				</tr>
			   <tbody id="processtable" name="processtable" >
			   </tbody>
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
		$("#addProcess").click(function(){
			var paramobj = new Object();
			var projectInfoNo = $("#projectInfoNo").val();
			var backdevtype = 'S0000';
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
			
			var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectAccountForBack.jsp?projectinfono="+projectInfoNo+"&backdevtype="+backdevtype,paramobj,"dialogWidth=1200px;dialogHeight=480px");
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

			var devdetSql = "select account.dev_acc_id,account.asset_coding, ";
				devdetSql += "account.dev_coding,account.self_num,account.dev_sign, ";
				devdetSql += "account.license_num,account.actual_in_time,to_char(account.planning_out_time,'yyyy-mm-dd') as planning_out_time, ";
				devdetSql += "account.dev_name,account.dev_model ";
				devdetSql += "from gms_device_account_dui account ";
				devdetSql += "where account.bsflag = '0' and account.dev_acc_id in "+condition;
				devdetSql += " and account.project_info_id='"+projectInfoNo+"' ";
				devdetSql += "order by account.planning_out_time,account.dev_type";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devdetSql+'&pageSize=10000');
				var retObj = proqueryRet.datas;
				addLine(retObj);
		});
		$("#delProcess").click(function(){
			$("input[type='checkbox'][name='idinfo']").each(function(i){
				if(this.checked == true){
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
	function submitInfo(){
		var backappname = document.getElementById("backappname").value;
		if(backappname=="" || backappname.length>16){
			alert("申请单不能为空或申请单长度过长！");
			return;
		}
		//var receive_org_name = document.getElementById("receive_org_name").value;
		//if(receive_org_name==""){
		//	alert("接收单位不能为空！");
		//	return;
		//}
		var project_info_no = document.getElementById("projectInfoNo").value;
		var back_org_id = document.getElementById("back_org_id").value;
		var backdate = document.getElementById("backdate").value;
		var back_employee_id = document.getElementById("back_employee_id").value;
		var backdevtype = 'S0000';
		var backmix_org_id = "<%=org_id%>";

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
		
		var backappname = document.getElementById("backappname").value;
		var device_backapp_no = "更换设备"+backdate.replace(/\-/g,'')+'0'+Math.round(Math.random()*1000);
		//var receive_org_id = document.getElementById("receive_org_id").value;
		var devicebackappid = '<%=devicebackappid%>';
		var sql = "update gms_device_backapp set back_org_id='"+back_org_id+"',backdate=to_date('"+backdate+"','yyyy-MM-dd'),"+
			" back_employee_id='"+back_employee_id+"',backmix_org_id='"+backmix_org_id+"',modifi_date=sysdate,updator_id='<%=empId%>',org_id='<%=org_id%>',"+
			" org_subjection_id='<%=org_subjection_id%>',state='0',backapp_name='"+backappname+"',backdevtype='"+backdevtype+"' "+
			" where device_backapp_id='"+devicebackappid+"';";
		if(devicebackappid==null || devicebackappid==''){
			var sql = "select lower(sys_guid()) devicebackappid from dual";
			var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql+'&pageSize=10000');
			if(retObj!=null && retObj.returnCode=='0'){
				devicebackappid = retObj.datas[0].devicebackappid;
			}
			document.getElementById("devicebackappid").value = devicebackappid;
			sql = "insert into gms_device_backapp(device_backapp_id,device_backapp_no,project_info_id,back_org_id,backdate,back_employee_id,backmix_org_id,"+
			" bsflag,create_date,creator_id,modifi_date,updator_id,org_id,org_subjection_id,state,search_backapp_id,backapp_name,backdevtype,backapptype) "+
			" values('"+devicebackappid+"','"+device_backapp_no+"','"+project_info_no+"','"+back_org_id+"',to_date('"+backdate+"','yyyy-MM-dd'),'"+back_employee_id+"','"+backmix_org_id+"',"+
			"'0',sysdate,'<%=empId%>',sysdate,'<%=empId%>','<%=org_id%>','<%=org_subjection_id%>','0',(lower(sys_guid())),'"+backappname+"','"+backdevtype+"','3') ";
		}
		
		if(confirm("确认提交？")){
			var retObj = jcdpCallService("QualityItemsSrv", "saveQuality", "sql="+sql);
			if(retObj==null || !retObj.returnCode=='0'){
				alert('保存失败!');
				return;
			}
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveBackAppDetailInfo.srq?count="+count+"&idinfos="+idinfos+"&enddateinfo="+enddateinfo;
			document.getElementById("form1").submit();
		}
	}
	function refreshData(){
		var retObj;
		var basedatas;
		var devicebackappid = '<%=devicebackappid%>';
		var proSql = "select n.org_abbreviation,dyn.org_id,dyn.org_subjection_id,pro.project_info_no,pro.project_name,to_char(sysdate,'yyyy-mm-dd') as backdate ";
		    proSql += "from gp_task_project pro left join gp_task_project_dynamic dyn on dyn.project_info_no = pro.project_info_no ";
		    proSql += "left join comm_org_information n on n.org_id = dyn.org_id where pro.project_info_no= '<%=projectInfoNo%>' ";
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql);
		if(proqueryRet!=null && proqueryRet.returnCode =='0'){
			retObj = proqueryRet.datas;
			//将项目信息放在里面
			$("#project_name").val(retObj[0].project_name);
			$("#projectInfoNo").val(retObj[0].project_info_no);
			$("#back_org_name").val(retObj[0].org_abbreviation);
			$("#back_org_id").val(retObj[0].org_id);
			$("#backdate").val(retObj[0].backdate);
		}
		
		if(devicebackappid!=null && devicebackappid!=''){
			proSql = "select backapp.back_org_id,backapp_name,backapp.backdate,backapp.back_employee_id,backapp.device_backapp_no,";
			proSql += "backapp.remark,pro.project_info_no,pro.project_name,backapp.backdevtype,";
			proSql += "backorg.org_name as back_org_name,emp.employee_name as back_emp_name ";
			proSql += "from gms_device_backapp backapp left join gp_task_project pro on backapp.project_info_id=pro.project_info_no ";
			proSql += "left join comm_org_information backorg on backorg.org_id=backapp.back_org_id ";
			proSql += "left join comm_human_employee emp on emp.employee_id=backapp.back_employee_id ";
			proSql += "where backapp.project_info_id= '<%=projectInfoNo%>' and backapp.device_backapp_id='"+devicebackappid+"' ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql);
			if(proqueryRet!=null && proqueryRet.returnCode =='0'){
				retObj = proqueryRet.datas;
				//将项目信息放在里面
				$("#project_name").val(retObj[0].project_name);
				$("#backappname").val(retObj[0].backapp_name);
				$("#device_backapp_no").val(retObj[0].device_backapp_no);
				$("#backdevtype").val(retObj[0].backdevtype);
			}
			var devdetSql = "select account.dev_acc_id,account.asset_coding, account.dev_coding,account.self_num,account.dev_sign, "+
			" account.license_num,account.actual_in_time,to_char(account.planning_out_time,'yyyy-mm-dd') as planning_out_time, "+
			" account.dev_name,account.dev_model from gms_device_account_dui account "+
			" join gms_device_backapp_detail d on account.dev_acc_id = d.dev_acc_id and d.bsflag ='0'"+
			" join gms_device_backapp b on d.device_backapp_id = b.device_backapp_id and b.bsflag ='0'"+
			" where b.device_backapp_id ='"+devicebackappid+"' and account.bsflag ='0' order by account.planning_out_time,account.dev_type";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devdetSql+'&pageSize=10000');
			var retObj = proqueryRet.datas;
			addLine(retObj);
		}
	}
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
			innerhtml += "<td width='15%'>"+retObj[index-rows].asset_coding+"</td>";
			innerhtml += "<td width='4%'>1</td>";
			innerhtml += "<td width='10%'>"+retObj[index-rows].planning_out_time+"</td>";
			innerhtml += "<td width='12%'><input name='enddate"+index+"' id='enddate"+index+"' devaccid='"+retObj[index-rows].dev_acc_id+"' style='line-height:15px' value='"+retObj[index-rows].planning_out_time+"' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+index+",tributton3"+index+");'/></td>";	
			innerhtml += "</tr>";
			$("#processtable").append(innerhtml);
		}
		$("#processtable>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable>tr:odd>td:even").addClass("odd_even");
		$("#processtable>tr:even>td:odd").addClass("even_odd");
		$("#processtable>tr:even>td:even").addClass("even_even");
	}
	/**
	 * 选择组织机构树
	 */
	function showOrgTreePage(){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
		if(returnValue==null)return;
		var strs= new Array(); //定义一数组
		strs=returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		document.getElementById("receive_org_name").value = names[1];
		
		var orgId = strs[1].split(":");
		document.getElementById("receive_org_id").value = orgId[1];
	}

</script>
</html>

