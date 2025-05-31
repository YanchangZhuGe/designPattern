<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String[] info = request.getParameter("deviceallappdetid").split("~",-1);
	String deviceallappdetid = info[0];
	String seqinfo = info[1];
	String deviceaddappid = request.getParameter("deviceaddappid");
	String deviceallappid = request.getParameter("deviceallappid");
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
<title>设备修改界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend>申请基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text"  value="" readonly/>
          	<input name="projectInfoNo" id="projectInfoNo" type="hidden" value="" />
          	<input name="device_allapp_id" id="device_allapp_id" type="hidden" value="<%=deviceallappid%>" />
          	<input name="device_addapp_id" id="device_addapp_id" type="hidden" value="<%=deviceaddappid%>" />
          </td>
          <td class="inquire_item4" >申请单名称:</td>
          <td class="inquire_form4" >
          	<input name="device_allapp_name" id="device_allapp_name" class="input_width" type="text"  value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">明细添加时间:</td>
          <td class="inquire_form4">
          	<input name="appdate" id="appdate" class="input_width" type="text" readonly/>
          </td>
          <td class="inquire_item4">明细添加人:</td>
          <td class="inquire_form4">
          	<input name="employee_id" class="input_width" type="hidden" value="<%=userId%>"/>
          	<input name="employee_name" class="input_width" type="text" value="<%=userName%>" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">工序:</td>
          <td class="inquire_form4" >
          	<input name="jobname" id="jobname" class="input_width" type="text" value="" readonly/>
          	<input name="teamid" id="teamid" class="input_width" type="hidden" value=""/>
          </td>
           <td class="inquire_item4"></td>
          <td class="inquire_form4"></td>
         </tr>
      </table>
      </fieldset>
	  <fieldset style="margin-left:2px"><legend>设备计划信息</legend>
		<div id="tag-container_3">
		  <ul id="tags" class="tags">
		    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">单台管理</a></li>
		    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">批量管理</a></li>
		  </ul>
		</div>
		  <div id="resultdiv0" name="resultdiv" style="float:left;height:210px;overflow:auto;">
			  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" width="15%">班组</td>
					<td class="bt_info_even" width="18%">设备名称</td>
					<td class="bt_info_odd" width="17%">规格型号</td>
					<td class="bt_info_even" width="8%">计量单位</td>
					<td class="bt_info_odd" width="8%">需求数量</td>
					<td class="bt_info_even" width="11%">开始时间</td>
					<td class="bt_info_odd" width="11%">结束时间</td>
					<td class="bt_info_even" width="12%">备注</td>
				</tr>
			   <tbody id="processtable0" name="processtable" >
			   </tbody>
		      </table>
		  </div>
		  <div id="resultdiv1" name="resultdiv" style="float:left;height:210px;overflow:auto;display:none">
			  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" width="15%">班组</td>
					<td class="bt_info_even" width="18%">设备名称</td>
					<td class="bt_info_odd" width="17%">规格型号</td>
					<td class="bt_info_even" width="8%">计量单位</td>
					<td class="bt_info_odd" width="8%">需求道数</td>
					<td class="bt_info_even" width="11%">开始时间</td>
					<td class="bt_info_odd" width="11%">结束时间</td>
					<td class="bt_info_even" width="12%">备注</td>
				</tr>
			   <tbody id="processtable1" name="processtable" >
			   </tbody>
		      </table>
		  </div>
		</fieldset>
    </div>
    <div id="oper_div">
     	<span class="bc_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	var projectType="<%=projectType%>";
	
	function checkAppNum(obj){
		var re = /^\+?[1-9][0-9]*$/;
		//检查所有的数量字段 
		if(!re.test(obj.value)){
			alert("调配数量必须为数字，且大于0!");
			obj.value = "";
		}
	}
	function submitInfo(){
		var numflag = "1";
		$("input[type='text'][name^='devicename']").each(function(){
			if(this.value == ""){
				numflag = "12";
				return;
			}
		});
		if(numflag == "12"){
			alert("请选择设备名称和规格型号!");
			return false;
		}
		var re = /^\+?[1-9][0-9]*$/;
		//检查所有的数量字段 
		$("input[type='text'][name^='neednum']").each(function(){
			if(this.value == ""){
				numflag = "2";
				return;
			}else if(!re.test(this.value)){
				numflag = "3";
				return;
			}
		});
		if(numflag == "3"){
			alert("调配数量必须为数字，且大于0!");
			$("input[type='text'][name^='neednum']").each(function(){
				if(!re.test(this.value)){
					this.value = "";
				}
			});
        	return false;
		}else if(numflag == "2"){
			alert("调配数量不能为空!");
        	return false;
		}
		//数字没啥问题，检查开始和结束时间
		var startdateflag;
		var datere = /^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)$/;
		$("input[type='text'][name^='startdate']").each(function(){
			if(this.value == ""){
				startdateflag = "2";
				return;
			}else if(!datere.test(this.value)){
				startdateflag = "3";
				return;
			}
		});
		var enddateflag;
		$("input[type='text'][name^='enddate']").each(function(){
			if(this.value == ""){
				enddateflag = "2";
				return;
			}else if(!datere.test(this.value)){
				enddateflag = "3";
				return;
			}
		});
		if(startdateflag == "2"){
			alert("计划开始时间不能为空，请检查所有日期字段!");
			return;
		}else if(startdateflag == "3"){
			alert("计划开始时间格式错误，请检查所有日期字段!");
			return;
		}
		if(enddateflag == "2"){
			alert("计划结束时间不能为空，请检查所有日期字段!");
			return;
		}else if(enddateflag == "3"){
			alert("计划结束时间格式错误，请检查所有日期字段!");
			return;
		}
		//保留的行信息
		var count = 0;
		var line_infos = '';
		$("tr","#processtable0").each(function(){
			if(this.seq!=undefined){
				if(count == 0){
					line_infos = this.seq;
				}else{
					line_infos = line_infos+"~"+this.seq;
				}
				count++;
			}
		});
		//检查按量管理的所有的数量字段 
		$("input[type='text'][name^='collneednum']").each(function(){
			if(this.value == ""){
				numflag = "2";
				return;
			}else if(!re.test(this.value)){
				numflag = "3";
				return;
			}
		});
		if(numflag == "3"){
			alert("调配数量必须为数字，且大于0!");
			$("input[type='text'][name^='collneednum']").each(function(){
				if(!re.test(this.value)){
					this.value = "";
				}
			});
        	return false;
		}else if(numflag == "2"){
			alert("调配数量不能为空!");
        	return false;
		}
		//数字没啥问题，检查按量管理的开始和结束时间
		$("input[type='text'][name^='collstartdate']").each(function(){
			if(this.value == ""){
				startdateflag = "2";
				return;
			}else if(!datere.test(this.value)){
				startdateflag = "3";
				return;
			}
		});
		var enddateflag;
		$("input[type='text'][name^='collstartdate']").each(function(){
			if(this.value == ""){
				enddateflag = "2";
				return;
			}else if(!datere.test(this.value)){
				enddateflag = "3";
				return;
			}
		});
		if(startdateflag == "2"){
			alert("计划开始时间不能为空，请检查所有日期字段!");
			return;
		}else if(startdateflag == "3"){
			alert("计划开始时间格式错误，请检查所有日期字段!");
			return;
		}
		if(enddateflag == "2"){
			alert("计划结束时间不能为空，请检查所有日期字段!");
			return;
		}else if(enddateflag == "3"){
			alert("计划结束时间格式错误，请检查所有日期字段!");
			return;
		}
		//保留按量的行信息
		var collcount = 0;
		var collline_infos = '';
		$("tr","#processtable1").each(function(){
			if(this.collseq!=undefined){
				if(collcount == 0){
					collline_infos = this.collseq;
				}else{
					collline_infos = collline_infos+"~"+this.collseq;
				}
				collcount++;
			}
		});
		if(count == 0 && collcount == 0){
			alert('请添加设备申请明细！');
			return;
		}
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveDevAllAddAppDetailInfo.srq?count="+count+"&line_infos="+line_infos+"&collcount="+collcount+"&collline_infos="+collline_infos;
		document.getElementById("form1").submit();
	}
	function showDevPage(trid){
		var obj = new Object();
		window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectDeviceTree.jsp",obj);
		if(obj.name!=undefined){
			if(obj.name.indexOf("(")>0){
				var name = obj.name;
				var devicename = name.substr(0,(name.indexOf('(')-name.indexOf(':')-1));
				var devicetype = name.substr(name.indexOf('(')+1,(name.indexOf(')')-name.indexOf('(')-1));
				$("input[name='devicename"+trid+"']","#processtable0").val(devicename);
				$("input[name='devicetype"+trid+"']","#processtable0").val(devicetype);
			}else{
				$("input[name='devicename"+trid+"']","#processtable0").val(obj.name);
				$("input[name='devicetype"+trid+"']","#processtable0").val("");
			}
			$("input[name='signtype"+trid+"']","#processtable0").val(obj.code);
			$("input[name='isdevicecode"+trid+"']","#processtable0").val(obj.isdevicecode);
		}
	}
	function refreshData(){
		var retObj;
		var basedatas;
		var seqinfo = '<%=seqinfo%>';
		//显示对应的div
		$("li[id^='tag3_']" , '#tag-container_3').hide();
		$("#tag3_"+seqinfo , '#tag-container_3').show();
		//显示对应的结果div
		$("div[id^='resultdiv']").hide();
		$("#resultdiv"+seqinfo).show();
		
		if('<%=deviceaddappid%>'!='null'){
			if('<%=seqinfo%>'=='0'){
				var proSql = "select devapp.device_allapp_id,devapp.project_info_no,project.project_name,devapp.device_addapp_no, ";
				proSql += "devapp.device_addapp_name,devapp.device_addapp_id,to_char(sysdate,'yyyy-mm-dd') as appdate "; 
				proSql += "from gms_device_allapp_add devapp left join gp_task_project project on devapp.project_info_no=project.project_info_no "; 
				proSql += "where devapp.bsflag='0' and devapp.device_addapp_id='<%=deviceaddappid%>'";
				var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql+'&pageSize=1000');
				retObj = proqueryRet.datas;
				$("#projectInfoNo").val(retObj[0].project_info_no);
				$("#project_name").val(retObj[0].project_name);
				$("#device_allapp_name").val(retObj[0].device_addapp_name);
				$("#appdate").val(retObj[0].appdate);
				//查询子表信息
				var str = "select alldet.device_allapp_detid,alldet.project_info_no,p6.name as jobname, ";
				str += "pro.project_name,alldet.dev_ci_code,alldet.unitinfo,alldet.isdevicecode, ";
				str += "alldet.dev_name as dev_ci_name,";
				str += "alldet.dev_type as dev_ci_model, ";
				str += "alldet.apply_num,alldet.teamid,alldet.team, ";
				str += "alldet.purpose,alldet.employee_id,emp.employee_name, ";
				str += "alldet.plan_start_date,alldet.plan_end_date  ";
				str += "from gms_device_allapp_detail alldet ";
				str += "left join gms_device_allapp devapp on alldet.device_allapp_id = devapp.device_allapp_id ";
				str += "left join bgp_p6_activity p6 on alldet.teamid = p6.object_id ";
				str += "left join gp_task_project pro on alldet.project_info_no = pro.project_info_no ";
				str += "left join gms_device_codeinfo ci on alldet.dev_ci_code = ci.dev_ci_code ";
				str += "left join gms_device_codetype ct on alldet.dev_ci_code = ct.dev_ct_code ";
				str += "left join comm_human_employee emp on alldet.employee_id = emp.employee_id ";
				str += "where alldet.device_allapp_detid = '<%=deviceallappdetid%>' ";
				str += "and devapp.bsflag = '0' ";
				var detailRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=1000');
				retObj = detailRet.datas;
				for(var index=0;index<retObj.length;index++){
					if(index==0){
						$("#jobname").val(retObj[0].jobname);
						$("#teamid").val(retObj[0].teamid);
					}
					var device_allapp_detid = retObj[index].device_allapp_detid;
					var dev_ci_name = retObj[index].dev_ci_name;
					var dev_ci_model = retObj[index].dev_ci_model;
					var dev_ci_code = retObj[index].dev_ci_code;
					var isdevicecode = retObj[index].isdevicecode;
					var team = retObj[index].team;
					var unitinfo = retObj[index].unitinfo;
					var apply_num = retObj[index].apply_num;
					var purpose = retObj[index].purpose;
					var startdate = retObj[index].plan_start_date;
					var enddate = retObj[index].plan_end_date;
					
					//动态新增表格
					var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
					
					innerhtml += "<td><input type='checkbox' name='idinfo' id='"+index+"'/>";
					innerhtml += "<select name='team"+index+"' id='team"+index+"' /></select></td>";
					
					innerhtml += "<td><input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='' size='15' type='text' />";
					innerhtml += "</td>";
					
					innerhtml += "<td><input id='devicetype"+index+"' name='devicetype"+index+"' value='' size='14'  type='text' />";
					innerhtml += "<input id='deviceallappdetid"+index+"' name='deviceallappdetid"+index+"' value='' type='hidden' />";
					innerhtml += "<input id='signtype"+index+"' name='signtype"+index+"' value='' type='hidden' />";
					innerhtml += "<input id='isdevicecode"+index+"' name='isdevicecode"+index+"' value='' type='hidden' /></td>";
					
					innerhtml += "<td><select name='unit"+index+"' id='unit"+index+"' /></select></td>";
					innerhtml += "<td><input id='neednum"+index+"' name='neednum"+index+"' class='input_width' value='' size='8' type='text' onkeyup='checkAppNum(this)'/></td>";
					innerhtml += "<td><input name='startdate"+index+"' id='startdate"+index+"' style='line-height:15px' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(startdate"+index+",tributton2"+index+");'/></td>";
					innerhtml += "<td><input name='enddate"+index+"' id='enddate"+index+"' style='line-height:15px' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+index+",tributton3"+index+");'/></td>";
					innerhtml += "<td><input id='purpose"+index+"' name='purpose"+index+"' class='input_width' value='' size='8' type='text'/></td>";
					innerhtml += "</tr>";
					
					$("#processtable0").append(innerhtml);
					//查询公共代码，并且回填到界面的班组中
					var teamObj;
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
					for(var teamindex=0;teamindex<teamObj.length;teamindex++){
						teamoptionhtml +=  "<option name='teamcode' id='teamcode"+teamindex+"' value='"+teamObj[teamindex].value+"'>"+teamObj[teamindex].label+"</option>";
					}
					$("#team"+index).append(teamoptionhtml);
					//查询公共代码，并且回填到界面的单位中
					var codeObj;
					var unitSql = "select sd.coding_code_id,coding_name ";
					unitSql += "from comm_coding_sort_detail sd "; 
					unitSql += "where coding_sort_id ='5110000038' order by coding_code";
					var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql+'&pageSize=1000');
					codeObj = unitRet.datas;
					var optionhtml = "";
					for(var codeindex=0;codeindex<codeObj.length;codeindex++){
						optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+codeObj[codeindex].coding_code_id+"'>"+codeObj[codeindex].coding_name+"</option>";
					}
					$("#unit"+index).append(optionhtml);
					
					//给数据回填
					$("#deviceallappdetid"+index).val(device_allapp_detid);
					$("#team"+index).val(team);
					$("#devicename"+index).val(dev_ci_name);
					$("#devicetype"+index).val(dev_ci_model);
					$("#signtype"+index).val(dev_ci_code);
					$("#isdevicecode"+index).val(isdevicecode);
					$("#unit"+index).val(unitinfo);
					$("#neednum"+index).val(apply_num);
					$("#purpose"+index).val(purpose);
					$("#startdate"+index).val(startdate);
					$("#enddate"+index).val(enddate);
				}
				$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
				$("#processtable0>tr:odd>td:even").addClass("odd_even");
				$("#processtable0>tr:even>td:odd").addClass("even_odd");
				$("#processtable0>tr:even>td:even").addClass("even_even");
			}else{
				var proSql = "select devapp.project_info_no,project.project_name,devapp.device_allapp_id,devapp.device_allapp_no,devapp.device_allapp_name,devapp.remark, ";
				proSql += "to_char(sysdate,'yyyy-mm-dd') as appdate "; 
				proSql += "from gms_device_allapp devapp left join gp_task_project project on devapp.project_info_no=project.project_info_no "; 
				proSql += "where devapp.bsflag='0' and devapp.device_allapp_id='<%=deviceallappid%>'";

				var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql+'&pageSize=1000');
				retObj = proqueryRet.datas;
				$("#projectInfoNo").val(retObj[0].project_info_no);
				$("#project_name").val(retObj[0].project_name);
				$("#device_allapp_name").val(retObj[0].device_allapp_name);
				$("#appdate").val(retObj[0].appdate);
				if(retObj[0].remark!=null){
					$("#remark").text(retObj[0].remark);
				}
				$("#appdate").val(retObj[0].appdate);
				//查询子表信息
				var str = "select alldet.device_allapp_detid,alldet.project_info_no,p6.name as jobname, ";
				str += "pro.project_name,alldet.dev_name_input as dev_ci_name,alldet.dev_codetype as dev_ci_model, ";
				str += "alldet.unitinfo,alldet.apply_num,alldet.teamid,alldet.team, ";
				str += "alldet.purpose,alldet.employee_id,emp.employee_name, ";
				str += "alldet.plan_start_date,alldet.plan_end_date  ";
				str += "from gms_device_allapp_colldetail alldet ";
				str += "left join gms_device_allapp devapp on alldet.device_allapp_id = devapp.device_allapp_id ";
				str += "left join bgp_p6_activity p6 on alldet.teamid = p6.object_id ";
				str += "left join gp_task_project pro on alldet.project_info_no = pro.project_info_no ";
				str += "left join comm_human_employee emp on alldet.employee_id = emp.employee_id ";
				str += "where alldet.device_allapp_detid = '<%=deviceallappdetid%>' ";
				str += "and devapp.bsflag = '0' ";
				var detailRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=1000');
				retObj = detailRet.datas;
				for(var index=0;index<retObj.length;index++){
					if(index==0){
						$("#jobname").val(retObj[0].jobname);
						$("#teamid").val(retObj[0].teamid);
					}
					var device_allapp_detid = retObj[index].device_allapp_detid;
					var dev_ci_name = retObj[index].dev_ci_name;
					var dev_ci_model = retObj[index].dev_ci_model;
					var team = retObj[index].team;
					var unitinfo = retObj[index].unitinfo;
					var apply_num = retObj[index].apply_num;
					var purpose = retObj[index].purpose;
					var startdate = retObj[index].plan_start_date;
					var enddate = retObj[index].plan_end_date;
					
					//动态新增表格
					var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' collseq='"+index+"'>";					
					innerhtml += "<td><input type='checkbox' name='collidinfo' id='"+index+"'/>";
					innerhtml += "<select name='collteam"+index+"' id='collteam"+index+"' /></select></td>";					
					innerhtml += "<td><input name='colldevicename"+index+"' id='colldevicename"+index+"' style='line-height:15px' value='用户输入名称' size='15' type='text' /></td>";					
					innerhtml += "<td><select name='colldevicetype"+index+"' id='colldevicetype"+index+"' class='select_width' ></selcted>";
					innerhtml += "<input id='colldeviceallappdetid"+index+"' name='colldeviceallappdetid"+index+"' value='' type='hidden' /></td>";					
					innerhtml += "<td><select name='collunit"+index+"' id='collunit"+index+"' /></select></td>";
					innerhtml += "<td><input name='collneednum"+index+"' id='collneednum"+index+"' class='input_width' value='' size='10' type='text' onkeyup='checkAppNum(this)'/></td>";
					innerhtml += "<td><input name='collstartdate"+index+"' id='collstartdate"+index+"' style='line-height:15px' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='colltributton2"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(collstartdate"+index+",colltributton2"+index+");'/></td>";
					innerhtml += "<td><input name='collenddate"+index+"' id='collenddate"+index+"' style='line-height:15px' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='colltributton3"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(collenddate"+index+",colltributton3"+index+");'/></td>";
					innerhtml += "<td><input name='collpurpose"+index+"' class='input_width' value='' size='10' type='text'/></td>";
					innerhtml += "</tr>";
					
					$("#processtable1").append(innerhtml);
					
					//查询公共代码，并且回填到界面的班组中
					var teamObj;
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
					for(var teamindex=0;teamindex<teamObj.length;teamindex++){
						teamoptionhtml +=  "<option name='teamcode' id='teamcode"+teamindex+"' value='"+teamObj[teamindex].value+"'>"+teamObj[teamindex].label+"</option>";
					}
					$("#collteam"+index).append(teamoptionhtml);
					//查询公共代码，并且回填到界面的单位中
					var codeObj;
					var unitSql = "select sd.coding_code_id,coding_name ";
					unitSql += "from comm_coding_sort_detail sd "; 
					unitSql += "where coding_sort_id ='0110000004' and coding_name='道' ";
					var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql+'&pageSize=1000');
					codeObj = unitRet.datas;
					var optionhtml = "";
					for(var codeindex=0;codeindex<codeObj.length;codeindex++){
						optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+codeObj[codeindex].coding_code_id+"'>"+codeObj[codeindex].coding_name+"</option>";
					}
					$("#collunit"+index).append(optionhtml);
					//查询公共代码，并且回填到界面的申请类型中
					var colltypeObj;
					var colltypeSql = "select t.coding_code_id as value,t.coding_name as label ";
					colltypeSql += "from comm_coding_sort_detail t "; 
					colltypeSql += "where t.coding_sort_id='5110000031' and t.bsflag='0' order by t.coding_show_id";
					var colltypeRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+colltypeSql);
					colltypeObj = colltypeRet.datas;
					var colltypeoptionhtml = "";
					for(var jinfo=0;jinfo<colltypeObj.length;jinfo++){
						colltypeoptionhtml +=  "<option name='colltypecode' id='colltypecode"+jinfo+"' value='"+colltypeObj[jinfo].value+"'>"+colltypeObj[jinfo].label+"</option>";
					}
					$("#colldevicetype"+index).append(colltypeoptionhtml);
					
					//给数据回填
					$("#colldeviceallappdetid"+index).val(device_allapp_detid);
					$("#collteam"+index).val(team);
					$("#colldevicename"+index).val(dev_ci_name);
					$("#colldevicetype"+index).val(dev_ci_model);
					$("#collunit"+index).val(unitinfo);
					$("#collneednum"+index).val(apply_num);
					$("#collpurpose"+index).val(purpose);
					$("#collstartdate"+index).val(startdate);
					$("#collenddate"+index).val(enddate);
				}
				$("#processtable1>tr:odd>td:odd").addClass("odd_odd");
				$("#processtable1>tr:odd>td:even").addClass("odd_even");
				$("#processtable1>tr:even>td:odd").addClass("even_odd");
				$("#processtable1>tr:even>td:even").addClass("even_even");
			}
		}
	}
</script>
</html>

