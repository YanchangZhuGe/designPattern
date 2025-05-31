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
	String org_subjection_id = user.getOrgSubjectionId();
	String userName = user.getUserName();
	String isDgUser="";
	if(org_subjection_id != null && org_subjection_id.startsWith("C105007")){
		isDgUser = "true";
	}
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
<title>返还明细添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend style="color:#B0B0B0;">返还申请基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text" value="" readonly/>
          	<input name="projectInfoNo" id="projectInfoNo" type="hidden" value="<%=projectInfoNo%>" />
          	<input name="devicebackappid" id="devicebackappid" type="hidden" value="<%=devicebackappid%>" />
        </td>
          <td class="inquire_item4">返还申请单号:</td>
          <td class="inquire_form4">
          	<input name="device_backapp_no" id="device_backapp_no" class="input_width" type="text" value="提交后自动生成..." readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">返还申请单名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="backapp_name" id="backapp_name" class="input_width" style="width:92%" type="text" />
          </td>
        </tr>
       <tr>
          <td class="inquire_item4">返还单位:</td>
          <td class="inquire_form4">
          	<input name="back_org_name" id="back_org_name" class="input_width" type="text" value="<%=user.getOrgName()%>" readonly/>
          	<input name="back_org_id" id="back_org_id" class="input_width" value="<%=user.getTeamOrgId()%>" type="hidden" />
          </td>
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
	  <fieldset style="margin-left:2px"><legend>返还申请明细</legend>
		  <div style="height:120px;overflow:auto">
			  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" width="4%"><input type='checkbox' id='collbackinfo' name='collbackinfo'/></td>
					<td class="bt_info_even" width="10%">设备名称</td>
					<td class="bt_info_odd" width="10%">规格型号</td>
					<td class="bt_info_even" width="5%">单位</td>
					<td class="bt_info_odd" width="8%">总数量</td>
					<td class="bt_info_even" width="8%">在队数量</td>
					<td class="bt_info_odd" width="8%">离队数量</td>
					<td class="bt_info_even" width="8%">返还数量</td>
					<td class="bt_info_odd" width="13%">实际进场时间</td>
					<td class="bt_info_even" width="13%"><font color='red'>实际离场时间</font></td>
					<td class="bt_info_odd" width="13%">备注</td>
				</tr>
			   <tbody id="processtable" name="processtable" >
			   </tbody>
		      </table>
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
var isDgUser = '<%=isDgUser%>';
var date = new Date(); 
var result = date.getFullYear()+'-'+(date.getMonth()+1)+'-'+date.getDate();  //当前时间
	$().ready(function(){
		$("#addProcess").click(function(){
			var projectInfoNo = $("#projectInfoNo").val();
			var backdevtype = $("#backdevtype").val();
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
			var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/jbqDevBack/selectAccountForBack.jsp?projectinfono="+projectInfoNo+"&backdevtype="+backdevtype,paramobj,"dialogWidth=820px;dialogHeight=380px");
			if(vReturnValue == undefined){
				return;
			}
			var accountidinfos = vReturnValue.split("|","-1");
			var condition ="(";
			
				for(var index=0;index<accountidinfos.length;index++){
					if(index==0)
						condition += "'"+accountidinfos[index]+"'";
					else
						condition += ",'"+accountidinfos[index]+"'";
					
				}
				condition += ") ";
			
		var devdetSql = "select account.*,unitsd.coding_name as unit_name ";
				devdetSql += "from gms_device_coll_account_dui account ";
				devdetSql += "left join gms_device_collectinfo info on info.device_id = account.device_id ";
				devdetSql += "left join comm_coding_sort_detail unitsd on account.dev_unit=unitsd.coding_code_id ";
				devdetSql += "where substr(info.dev_code,0,2) = '04' and nvl(account.bsflag, 0) != 'N' and nvl(account.bsflag, 0) != '1' and account.dev_acc_id in "+condition ;
				devdetSql += " and account.project_info_id='"+projectInfoNo+"' ";
				devdetSql += " order by account.planning_out_time";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devdetSql);
				var retObj = proqueryRet.datas;
				addLine(retObj)
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
		
		$().ready(function(){
			$("#devbackinfo").change(function(){
				var checkvalue = this.checked;
				$("input[type='checkbox'][name^='idinfo2']").attr('checked',checkvalue);
			});
			
			
		});
	});
	$().ready(function(){
		$("#collbackinfo").change(function(){
			var checkvalue = this.checked;
			$("input[type='checkbox'][name='idinfo']").attr('checked',checkvalue);
		});
		
		
	});
	function addLine(retObj){
		var rows = document.getElementById("processtable").rows.length;
		for(var index=rows;index<rows+retObj.length;index++){
			var innerhtml = "<tr id='tr"+retObj[index-rows].dev_acc_id+"' name='tr' midinfo='"+retObj[index-rows].dev_acc_id+"'>";
			innerhtml += "<td><input type='checkbox' name='idinfo' seqinfo='"+index+"' id='"+retObj[index-rows].dev_acc_id+"' checked/></td>";
			innerhtml += "<td>"+retObj[index-rows].dev_name+"</td>";
			innerhtml += "<td>"+retObj[index-rows].dev_model+"</td>";
			innerhtml += "<td>"+retObj[index-rows].unit_name+"</td>";
			innerhtml += "<td>"+retObj[index-rows].total_num+"</td>";
			innerhtml += "<td>"+retObj[index-rows].unuse_num+"</td>";
			innerhtml += "<td>"+retObj[index-rows].use_num+"</td>";
			var back_num = retObj[index-rows].back_num;
			if(back_num==null){
				back_num = "";
			}
			innerhtml += "<td><input name='back_num"+index+"' id='back_num"+index+"' detindex='"+index+"' maxnum='"+retObj[index-rows].unuse_num+"' size='5' type='text' value='"+back_num+"' onkeyup='checkAssignNum(this)'></input></td>";
			innerhtml += "<td>"+retObj[index-rows].actual_in_time+"</td>";
			var actual_out = retObj[index-rows].actual_out;
			if(actual_out==null){
				actual_out = "";
			}
			innerhtml += "<td><input readonly name='enddate"+index+"' id='enddate"+index+"' devaccid='"+retObj[index-rows].dev_acc_id+"' style='line-height:15px' value='"+result+"' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+index+",tributton3"+index+");'/></td>";
			innerhtml += "<td><input name='devremark"+index+"' id='devremark"+index+"' detindex='"+index+"' type='text' size='14' value='' /></td>";
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
		var lineinfo;
		$("input[type='checkbox'][name='idinfo']").each(function(){
			if(count == 0){
				idinfos = this.id;
				lineinfo = this.seqinfo;
			}else{
				idinfos = idinfos+"~"+this.id;
				lineinfo = lineinfo+"~"+this.seqinfo;
			}
			count++;
		});
		
		if(count == 0){
			alert('请添加返还申请明细信息！');
			return;
		}
		var selectedlines = lineinfo.split("~");
		var wronglineinfos = "";
		var wronglineinfoss = "";
		for(var index=0;index<selectedlines.length;index++){
			var valueinfo = $("#back_num"+selectedlines[index]).val();
			if(valueinfo == ""){
				if(index == 0){
					wronglineinfos += (parseInt(selectedlines[index])+1);
				}else{
					wronglineinfos += ","+(parseInt(selectedlines[index])+1);
				}
			}
			var dateinfo = $("#enddate"+selectedlines[index]).val();
			if(dateinfo == ""){
				if(index == 0){
					wronglineinfoss += (parseInt(selectedlines[index])+1);
				}else{
					wronglineinfoss += ","+(parseInt(selectedlines[index])+1);
				}
			}
		}
		if(wronglineinfos!=""){
			alert("请设置第"+wronglineinfos+"行明细的返还数量!");
			return;
		}
		if(wronglineinfoss!=""){
			alert("请设置第"+wronglineinfos+"行明细的实际离场时间!");
			return;
		}
		if(confirm("确认提交？")){
			var project_info_no = document.getElementById("projectInfoNo").value;
			var back_org_id = document.getElementById("back_org_id").value;
			var backdate = document.getElementById("backdate").value;
			var backdevtype = "S14050208";
			var backmix_org_id = "C6000000005526";
			if(isDgUser=="true"){
				backmix_org_id="C6000000000040";
			}
			var backappname = document.getElementById("backapp_name").value;
			var device_backapp_no = "返还申请"+backdate.replace(/\-/g,'')+'0'+Math.round(Math.random()*1000);
			var devicebackappid = '<%=devicebackappid%>';
			var sql = "update gms_device_collbackapp set back_org_id='"+back_org_id+"',backdate=to_date('"+backdate+"','yyyy-MM-dd'),"+
				" back_employee_id='<%=empId%>',backmix_org_id='"+backmix_org_id+"',modifi_date=sysdate,updator_id='<%=empId%>',org_id='<%=org_id%>',"+
				" org_subjection_id='<%=org_subjection_id%>',state='0',backapp_name='"+backappname+"' "+
				" where device_backapp_id='"+devicebackappid+"';";
			if(devicebackappid==null || devicebackappid==''){
				var sql = "select lower(sys_guid()) devicebackappid from dual";
				var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql+'&pageSize=10000');
				if(retObj!=null && retObj.returnCode=='0'){
					devicebackappid = retObj.datas[0].devicebackappid;
				}
				document.getElementById("devicebackappid").value = devicebackappid;
				sql = "insert into gms_device_collbackapp(device_backapp_id,device_backapp_no,project_info_id,back_org_id,backdate,back_employee_id,backmix_org_id,"+
				" bsflag,create_date,creator_id,modifi_date,updator_id,org_id,org_subjection_id,state,search_backapp_id,backapp_name,backdevtype,backmix_username,backapptype) "+
				" values('"+devicebackappid+"','"+device_backapp_no+"','"+project_info_no+"','"+back_org_id+"',to_date('"+backdate+"','yyyy-MM-dd'),'<%=empId%>','"+backmix_org_id+"',"+
				"'0',sysdate,'<%=empId%>',sysdate,'<%=empId%>','<%=org_id%>','<%=org_subjection_id%>','0',(lower(sys_guid())),'"+backappname+"','"+backdevtype+"','','1');";
			}
			var retObj = jcdpCallService("QualityItemsSrv", "saveQuality", "sql="+sql);
			if(retObj==null || !retObj.returnCode=='0'){
				alert('保存失败!');
			}
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveCollBackDetailInfo.srq?count="+count+"&idinfos="+idinfos+"&lineinfo="+lineinfo;
			document.getElementById("form1").submit();
			document.getElementById("submitButton").onclick = "";
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
		
		if(devicebackappid!=null && devicebackappid!=''){
			var proSql = "select backapp.back_org_id,backapp_name,backapp.backdate,backapp.back_employee_id,backapp.device_backapp_no,";
			proSql += "backapp.remark,pro.project_info_no,pro.project_name,";
			proSql += "backorg.org_name as back_org_name,emp.employee_name as back_emp_name ";
			proSql += "from gms_device_collbackapp backapp left join gp_task_project pro on backapp.project_info_id=pro.project_info_no ";
			proSql += "left join comm_org_information backorg on backorg.org_id=backapp.back_org_id ";
			proSql += "left join comm_human_employee emp on emp.employee_id=backapp.back_employee_id ";
			proSql += "where backapp.project_info_id= '<%=projectInfoNo%>' and backapp.device_backapp_id='<%=devicebackappid%>' ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql);
			retObj = proqueryRet.datas;
			//将项目信息放在里面
			$("#project_name").val(retObj[0].project_name);
			$("#backapp_name").val(retObj[0].backapp_name);
			$("#device_backapp_no").val(retObj[0].device_backapp_no);
			var devdetSql = "select account.*,unitsd.coding_name as unit_name,d.back_num,d.planning_out_time actual_out from gms_device_coll_account_dui account  "+
			" join comm_coding_sort_detail unitsd on account.dev_unit=unitsd.coding_code_id "+
			" join gms_device_collbackapp_detail d on account.dev_acc_id = d.dev_acc_id and d.bsflag ='0'"+
			" join gms_device_collbackapp b on d.device_backapp_id = b.device_backapp_id and b.bsflag ='0'"+
			" where b.device_backapp_id ='"+devicebackappid+"' order by account.planning_out_time";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devdetSql+'&pageSize=10000');
			var retObj = proqueryRet.datas;
			addLine(retObj);
			
			
			var str = "select dui.dev_acc_id,dui.dev_name,dui.dev_model,dui.self_num,dui.dev_sign,dui.license_num,dui.asset_coding,det.actual_in_time,det.planning_out_time from gms_device_backapp_detail det ";
			str += "left join gms_device_account_dui dui on dui.dev_acc_id=det.dev_acc_id ";
			str += "where det.device_backapp_id='"+devicebackappid+"'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
			basedatas = queryRet.datas;
			addLine2(basedatas);
		}
	}
	function checkAssignNum(obj){
		var index = obj.detindex;
		var maxnum = parseInt($(obj).attr("maxnum"));
		var applyednumval = parseInt($("#back_num"+index).val(),10);
		
		var value = obj.value;
		var re = /^\+?[1-9][0-9]*$/;
		if(value=="")
			return;
		if(!re.test(value)){
			alert("返还数量必须为数字!");
			obj.value = "";
        	return false;
		}else{
			if(parseInt(value,10)>maxnum){
				alert("返还数量必须小于等于在队数量!");
				obj.value = "";
				return false;
			}
		}
	}

</script>
</html>

