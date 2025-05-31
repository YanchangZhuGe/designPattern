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
	String isDgUser = "";
	
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
          	<input   name="project_name" id="project_name" class="input_width" type="text" value="" readonly/>
          	<input   name="projectInfoNo" id="projectInfoNo" type="hidden" value="<%=projectInfoNo%>" />
          	<input   name="devicebackappid" id="devicebackappid" type="hidden" value="<%=devicebackappid%>" />
        </td>
          <td class="inquire_item4">返还申请单号:</td>
          <td class="inquire_form4">
          	<input readonly  name="device_backapp_no" id="device_backapp_no" class="input_width" type="text" value="提交后自动生成..." readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">返还申请单名称:</td>
          <td class="inquire_form4">
          	<input name="backapp_name" id="backapp_name" class="input_width" type="text" />
          </td>
          <td class="inquire_item4">申请时间:</td>
          <td class="inquire_form4">
          	<input   name="backdate" id="backdate" class="input_width" type="text" value="" readonly/>
          </td>
        </tr>
       <tr>
          <td class="inquire_item4">返还单位:</td>
          <td class="inquire_form4">
          	<input name="back_org_name" id="back_org_name" class="input_width" type="text" value="<%=user.getOrgName()%>" readonly/>
          	<input name="back_org_id" id="back_org_id" class="input_width" value="<%=user.getTeamOrgId()%>" type="hidden" />
          </td>
          <td class = "inquire_item4" id="check1">接收单位：</td>
             <td class="inquire_form4" id="orgselect">
          <select name ="checkOrg" id="checkOrg" class="selected_width">
          		<option value="C6000000000041">测量服务中心</option>
          		<option value="C6000000000042">仪器服务中心</option>
          		<option value="C6000000005551">塔里木作业部</option>
          		<option value="C6000000005538">北疆作业部</option>
          		<option value="C6000000005555">吐哈作业部</option>
          		<option value="C6000000005543">敦煌作业部</option>
          		<option value="C6000000005534">长庆作业部</option>
          		<option value="C6000000007537">辽河作业部</option>
          		<option value="C6000000005547">华北作业部</option>
          		<option value="C6000000005560">新区作业部</option>
          		<option value="C6000000005532">测量服务中心大港作业分部</option>
          	</select>
          </td>
        </tr>
        
       <%
       if(isDgUser.equals("true")){
       %>
       <tr>
          <td class="inquire_item4">返还设备类型:</td>
          <td class="inquire_form4">
          	<select id = "deviceType" name ="deviceType" onchange="delCheckOrg()">
          		<option value ='1'>自有批量</option>
          		<option value ='2'>专业化批量</option>
          	</select>
          </td>
          <td class="inquire_item4">&nbsp;</td>
          <td class="inquire_form4">
          	&nbsp;
          </td>
        </tr> 
       
       <%
       }
       
       %>      
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
					<td class="bt_info_odd" width="4%"><input   type='checkbox' id='collbackinfo' name='collbackinfo'/></td>
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
					<td class="bt_info_odd" width="4%"><input   type='checkbox' id='devbackinfo' name='devbackinfo'/></td>
					<td class="bt_info_even" width="10%">设备名称</td>
					<td class="bt_info_odd" width="10%">规格型号</td>
					<td class="bt_info_even" width="10%">自编号</td>
					<td class="bt_info_odd" width="12%">实物标识号</td>
					<td class="bt_info_even" width="11%">牌照号</td>
					<td class="bt_info_odd" width="15%">AMIS设备编号</td>
					<td class="bt_info_even" width="4%">数量</td>
					<td class="bt_info_odd" width="10%">计划离场时间</td>
					<td class="bt_info_even" width="12%"><font color='red'>实际离场时间</font></td>
				</tr>
				</table>
				<div style="height:90px;overflow:auto;">
					<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style='table-layout: auto'>
			   	 	<tbody id="addeddetailtable" name="addeddetailtable">
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
var isDgUser = '<%=isDgUser%>';
var date = new Date(); 
var result = date.getFullYear()+'-'+(date.getMonth()+1)+'-'+date.getDate();  //当前时间
	$().ready(function(){
		$("#addProcess").click(function(){
			var projectInfoNo = $("#projectInfoNo").val();
			//var backdevtype = $("#backdevtype").val();
			//alert(backdevtype);
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
			
			var deviceType="";
			if(isDgUser=="true"){
				deviceType = document.getElementById("deviceType").value; 
			}
			paramobj.selectStr = selectStr;
			var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/collectDevBack/selectAccountForBack.jsp?projectinfono="+projectInfoNo+"&deviceType="+deviceType,paramobj,"dialogWidth=820px;dialogHeight=480px");
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
			//alert(condition);
			var devdetSql = "select account.*,unitsd.coding_name as unit_name ";
				devdetSql += "from gms_device_coll_account_dui account ";
				devdetSql += "left join gms_device_collectinfo info on info.device_id = account.device_id ";
				devdetSql += "left join comm_coding_sort_detail unitsd on account.dev_unit=unitsd.coding_code_id ";
				//devdetSql += "where (substr(info.dev_code,0,2) = '01' or substr(info.dev_code,0,2) = '02' or substr(info.dev_code,0,2) = '03') and account.dev_acc_id in "+condition ;
				devdetSql += "where account.dev_acc_id in "+condition ;
				devdetSql += "and account.project_info_id='"+projectInfoNo+"' ";
				devdetSql += "and (account.is_leaving is null or account.is_leaving='0') ";
				devdetSql += "order by account.planning_out_time";
				//alert(devdetSql);
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
			innerhtml += "<td><input   type='checkbox' name='idinfo' seqinfo='"+index+"' id='"+retObj[index-rows].dev_acc_id+"' checked/></td>";
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
			innerhtml += "<td><input    name='back_num"+index+"' id='back_num"+index+"' detindex='"+index+"' maxnum='"+retObj[index-rows].unuse_num+"' size='5' type='text' value='"+back_num+"' onkeyup='checkAssignNum(this)' ></input></td>";
			innerhtml += "<td>"+retObj[index-rows].actual_in_time+"</td>";
			var actual_out = retObj[index-rows].actual_out;
			if(actual_out==null){
				actual_out = "";
			}
			innerhtml += "<td><input readonly  name='enddate"+index+"' id='enddate"+index+"' devaccid='"+retObj[index-rows].dev_acc_id+"' style='line-height:15px' value='"+result+"' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+index+",tributton3"+index+");'/></td>";
			innerhtml += "<td><input   name='devremark"+index+"' id='devremark"+index+"' detindex='"+index+"' type='text' size='14' value='' /></td>";
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
		//alert(idinfos);
		//if(count == 0){
		//	alert('请添加返还申请明细信息1111！');
		//	return;
		//}

		//保留的行信息
		var inscount = 0;
		var insidinfos;
		var insidlineinfo;
		$("input[type='checkbox'][name='idinfo2']").each(function(){
			if(inscount == 0){
				insidinfos = this.id;
				insidlineinfo = $("input[id^='enddate2'][devaccid='"+this.id+"']").val();
			}else{
				insidinfos = insidinfos+"~"+this.id;
				insidlineinfo =insidlineinfo+"~"+$("input[id^='enddate2'][devaccid='"+this.id+"']").val();
			}
			inscount++;
		});
		//if(inscount == 0){
		//	alert('请添加返还附属设备明细信息！');
		//	return;
	//	}
		if(count == 0 && inscount == 0){
			if(inscount == 0){
				alert('请添加返还附属设备明细信息！');
			}else{
				alert('请添加返还申请明细信息！')
			}
			return;
		}
		
		var project_info_no = document.getElementById("projectInfoNo").value;
		var back_org_id = document.getElementById("back_org_id").value;
		var backdate = document.getElementById("backdate").value;
		 var checkOrg = document.getElementById("checkOrg").value;
		var device_backapp_no = "返还申请"+backdate.replace(/\-/g,'')+'0'+Math.round(Math.random()*1000);
		
		if(count != 0){
			var selectedlines = lineinfo.split("~");
			var wronglineinfos = "";
			for(var index=0;index<selectedlines.length;index++){
				var valueinfo = $("#back_num"+selectedlines[index]).val();
				if(valueinfo == ""){
					if(index == 0){
						wronglineinfos += (parseInt(selectedlines[index])+1);
					}else{
						wronglineinfos += ","+(parseInt(selectedlines[index])+1);
					}
				}
			}
			if(wronglineinfos!=""){
				alert("请设置第"+wronglineinfos+"行明细的返还数量!");
				return;
			}
		}
		if(confirm("确认提交？")){}else{return;}
		//if(count != 0){
			var backdevtype = "S9000";
			var backmix_org_id = "";
			if(isDgUser=="true"){
				var deviceType=	document.getElementById("deviceType").value; 
				if(deviceType==1){
					backmix_org_id="C6000000000040";
					checkOrg="C6000000000040";
				}else{
					backmix_org_id = "C6000000005526";
				}
			}else{
				backmix_org_id = "C6000000005526";
			}
			var backappname = document.getElementById("backapp_name").value;
			var devicebackappid = '<%=devicebackappid%>';
			//alert(devicebackappid);
			var sql = "update gms_device_collbackapp set back_org_id='"+back_org_id+"',backdate=to_date('"+backdate+"','yyyy-MM-dd'),"+
				"back_employee_id='<%=empId%>',backmix_org_id='"+backmix_org_id+"',modifi_date=sysdate,updator_id='<%=empId%>',org_id='<%=org_id%>',"+
				"org_subjection_id='<%=org_subjection_id%>',state='0',backapp_name='"+backappname+"',receive_org_id='"+checkOrg+"' "+
				"where device_backapp_id='"+devicebackappid+"'";
				var sql1="";
			if(devicebackappid==null || devicebackappid==''){
				var sql = "select lower(sys_guid()) devicebackappid from dual";
				var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql+'&pageSize=10000');
				if(retObj!=null && retObj.returnCode=='0'){
					devicebackappid = retObj.datas[0].devicebackappid;
				}
				document.getElementById("devicebackappid").value = devicebackappid;
				sql = "insert into gms_device_collbackapp(device_backapp_id,device_backapp_no,project_info_id,back_org_id,backdate,back_employee_id,backmix_org_id,"+
					"bsflag,create_date,creator_id,modifi_date,updator_id,org_id,org_subjection_id,state,search_backapp_id,backapp_name,backdevtype,backmix_username,backapptype,receive_org_id,remark) "+
					"values('"+devicebackappid+"','"+device_backapp_no+"','"+project_info_no+"','"+back_org_id+"',to_date('"+backdate+"','yyyy-MM-dd'),'<%=empId%>','"+backmix_org_id+"',"+
					"'0',sysdate,'<%=empId%>',sysdate,'<%=empId%>','<%=org_id%>','<%=org_subjection_id%>','0',(lower(sys_guid())),'"+backappname+"','"+backdevtype+"','','1','"+checkOrg+"','1')";
			}
			var retObj = jcdpCallService("QualityItemsSrv", "saveQuality", "sql="+sql);
			if(retObj==null || !retObj.returnCode=='0'){
				alert('保存失败!');
				return;
			}
			
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveCollBackDetailInfo.srq?count="+count+"&idinfos="+idinfos+"&lineinfo="+lineinfo;
			document.getElementById("form1").submit();
			
		/////============================================================================================================
			//}else if(inscount != 0){
			<%
				String backTypeId = backTypeIDs[2];
				String backTypeName = backTypeNames[2];
				String backTypeUserName = backTypeUserNames[2];					
			%>
			var backmix_username = '<%=backTypeUserName%>'
			var back_employee_id = '<%=empId%>';
			var receive_org_id=$("#checkOrg").val();	
			var backmix_org_id ="";
			var backdevtype = 'S1405';
			if(isDgUser=="true"){
				var deviceType=	document.getElementById("deviceType").value; 
				if(deviceType==1){
					backmix_org_id="C6000000000040";
					backdevtype = 'S9996';//大港自有地震仪器附属设备
					backmix_username = "";
					receive_org_id="C6000000000040";
				}else{
					backmix_org_id = "C6000000005526";
				}
			}else{
				backmix_org_id = "C6000000005526";
			}

			if(inscount!=0){
				var devicebackappid2 = '<%=devicebackappid%>';
				var sql = "update gms_device_backapp set back_org_id='"+back_org_id+"',backdate=to_date('"+backdate+"','yyyy-MM-dd'),"+
					"back_employee_id='"+back_employee_id+"',backmix_org_id='"+backmix_org_id+"',modifi_date=sysdate,updator_id='<%=empId%>',org_id='<%=org_id%>',"+
					"org_subjection_id='<%=org_subjection_id%>',state='0',backapp_name='"+backappname+"',backdevtype='"+backdevtype+"',backmix_username='"+backmix_username+"',receive_org_id='"+receive_org_id+"' "+
					"where device_backapp_id='"+devicebackappid2+"' ";
				if(devicebackappid2==null || devicebackappid2==''){
					devicebackappid2 = devicebackappid;
					document.getElementById("devicebackappid").value = devicebackappid2;
					sql = "insert into gms_device_backapp(device_backapp_id,device_backapp_no,project_info_id,back_org_id,backdate,back_employee_id,backmix_org_id,"+
						"bsflag,create_date,creator_id,modifi_date,updator_id,org_id,org_subjection_id,state,search_backapp_id,backapp_name,backdevtype,backmix_username,backapptype,receive_org_id) "+
						"values('"+devicebackappid2+"','"+device_backapp_no+"','"+project_info_no+"','"+back_org_id+"',to_date('"+backdate+"','yyyy-MM-dd'),'"+back_employee_id+"','"+backmix_org_id+"',"+
						"'0',sysdate,'<%=empId%>',sysdate,'<%=empId%>','<%=org_id%>','<%=org_subjection_id%>','0',(lower(sys_guid())),'"+backappname+"','"+backdevtype+"','"+backmix_username+"','1','"+receive_org_id+"') ";
				}
				
				var retObj = jcdpCallService("QualityItemsSrv", "saveQuality", "sql="+sql);
				if(retObj==null || !retObj.returnCode=='0'){
					alert('保存失败!');
					return;
				}
				document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveBackAppDetailInfo.srq?count="+inscount+"&idinfos="+insidinfos+"&enddateinfo="+insidlineinfo;
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
			showCheckOrg();
		}
		
		if(devicebackappid!=null && devicebackappid!=''){
			var proSql = "select backapp.back_org_id,backapp_name,backapp.backdate,backapp.back_employee_id,backapp.device_backapp_no,";
			proSql += "backapp.remark,pro.project_info_no,pro.project_name,backapp.receive_org_id,";
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
			//接收单位
			var receive_org_id=retObj[0].receive_org_id;
			if(receive_org_id==null||receive_org_id=="")
				{
					showCheckOrg();
				}
			else
				{
				$("#checkOrg").val(receive_org_id);
				}
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
		delCheckOrg();
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
	
	
	function toAddAddedDetailInfos(){
		var projectInfoNo = $("#projectInfoNo").val();
		var backdevtype = "S1405";

		var deviceType="";
		if(isDgUser=="true"){
			 deviceType=	document.getElementById("deviceType").value; 
			
			}
		//如果是大港用户附属设备
		if(isDgUser =="true" && deviceType=="1"){
			backdevtype = "S9996";
		}
		//alert(isDgUser);
		//alert("deviceType="+deviceType+",backdevtype="+backdevtype);
		var paramobj = new Object();
		var selectStr = null;
		$("input[type='checkbox'][name='idinfo2']").each(function(i){
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
			devdetSql += "where account.dev_acc_id in "+condition ;
			devdetSql += "and account.project_info_id='"+projectInfoNo+"' ";
			devdetSql += "order by account.planning_out_time,account.dev_type";
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devdetSql+'&pageSize=10000');
			var retObj = proqueryRet.datas;
			addLine2(retObj);
	}
	function addLine2(retObj){
		var rows = document.getElementById("addeddetailtable").rows.length;
		for(var index=rows;index<rows+retObj.length;index++){
			var innerhtml = "<tr id='tr2"+retObj[index-rows].dev_acc_id+"' name='tr' midinfo='"+retObj[index-rows].dev_acc_id+"'>";
			innerhtml += "<td width='4%'><input   type='checkbox' name='idinfo2' id='"+retObj[index-rows].dev_acc_id+"' checked/></td>";
			innerhtml += "<td width='10%'>"+retObj[index-rows].dev_name+"</td>";
			innerhtml += "<td width='10%'>"+retObj[index-rows].dev_model+"</td>";
			innerhtml += "<td width='10%'>"+retObj[index-rows].self_num+"</td>";
			innerhtml += "<td width='12%'>"+retObj[index-rows].dev_sign+"</td>";
			innerhtml += "<td width='11%'>"+retObj[index-rows].license_num+"</td>";
			innerhtml += "<td width='15%'>"+retObj[index-rows].asset_coding+"</td>";
			innerhtml += "<td width='4%'>1</td>";
			innerhtml += "<td width='10%'>"+retObj[index-rows].planning_out_time+"</td>";
			innerhtml += "<td width='12%'><input readonly  name='enddate2"+index+"' id='enddate2"+index+"' devaccid='"+retObj[index-rows].dev_acc_id+"' style='line-height:15px' value='"+result+"' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton33"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate2"+index+",tributton33"+index+");'/></td>";
			
			innerhtml += "</tr>";
			$("#addeddetailtable").append(innerhtml);
		}
		$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
		$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
		$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
		$("#addeddetailtable>tr:even>td:even").addClass("even_even");
	}
	function toDelAddedDetailInfos(){
		$("input[type='checkbox'][name='idinfo2']").each(function(i){
			if(this.checked){
				var id=this.id;
				$("#tr2"+id).remove();
			}
		});
	}
	//2015.6.8新增需求,专业化测量增加验收单位选项
	function showCheckOrg(){
			var projectInfoNo = '<%=projectInfoNo%>';
			var retObj = jcdpCallService("DevProSrv","findProjectOrgSubIdByProNo","projectInfoNo="+projectInfoNo);
			var checkOrgId = retObj.checkOrgId;
			$("#checkOrg").val(checkOrgId);
	}
	//2015.6.8新增需求,专业化测量增加验收单位选项
	function delCheckOrg(){
		var checkText=$("#deviceType").find("option:selected").text();	
		if(checkText=="自有批量"){			
			$("#check1").hide();
			$("#orgselect").hide();
		}else{
			$("#check1").show();
			$("#orgselect").show();
		}
	}
</script>
</html>

