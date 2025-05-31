<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String deviceappid = request.getParameter("deviceappid");
	String deviceappdetid = request.getParameter("deviceappdetid");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
	String userName = user.getUserName();
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
<title>调配明细修改界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:94%">
      <fieldSet style="margin-left:2px"><legend style="color:#B0B0B0;">配置计划基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" style="color:#B0B0B0;">项目名称:</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text" style="color:#B0B0B0;" value="" readonly/>
          	<input name="projectInfoNo" id="projectInfoNo" type="hidden" value="<%=projectInfoNo%>" />
          	<input name="deviceappid" id="deviceappid" type="hidden" value="<%=deviceappid%>" />
          	<input name="deviceappdetid" id="deviceappdetid" type="hidden" value="<%=deviceappdetid%>" />
          </td>
          <td class="inquire_item4"></td>
          <td class="inquire_form4"></td>
        </tr>
        <tr>
          <td class="inquire_item4" style="color:#B0B0B0;">配置计划单号:</td>
          <td class="inquire_form4" >
          	<input name="device_allapp_no" id="device_allapp_no" class="input_width" type="text" style="color:#B0B0B0;" value="" readonly/>
          </td>
          <td class="inquire_item4" style="color:#B0B0B0;">配置计划单名称:</td>
          <td class="inquire_form4">
          	<input name="device_allapp_name" id="device_allapp_name" class="input_width" type="text" style="color:#B0B0B0;" value="" readonly/>
          </td>
        </tr>
      </table>
      </fieldSet>
	  <fieldSet style="margin-left:2px"><legend>调配申请明细</legend>
		  <div style="height:105px;overflow:auto">
			  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_even" width="5%">选择</td>
					<td class="bt_info_odd" width="5%">工序</td>
					<td class="bt_info_even" width="8%">班组</td>
					<td class="bt_info_odd" width="12%">设备名称</td>
					<td class="bt_info_even" width="15%">规格型号</td>
					<td class="bt_info_odd" width="3%">计量单位</td>
					<td class="bt_info_even" width="6%">需求数量</td>
					<td class="bt_info_odd" width="6%">已申请数量</td>
					<td class="bt_info_even" width="6%">申请数量</td>
					<td class="bt_info_odd" width="12%">用途</td>
					<td class="bt_info_even" width="15%">开始时间</td>
					<td class="bt_info_odd" width="15%">结束时间</td>
				</tr>
			   <tbody id="processtable" name="processtable" >
			   </tbody>
		      </table>
	       </div>
      </fieldSet>
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
    <div id="oper_div2" style="display:none;width:100%;height:35px;text-align:center;">
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
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
		if(count == 0){
			alert('请选择调配设备申请明细信息！');
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
			alert("请设置第"+wronglineinfos+"行调配设备申请明细信息!");
			return;
		}
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveCollMixAppDetailInfo.srq?count="+count+"&idinfos="+idinfos+"&line_infos="+line_infos+"&sub_line_infos="+sub_line_infos;
		document.getElementById("form1").submit();
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
	function checkAssignNum(obj){
		var index = obj.detindex;
		var neednumval = parseInt($("#neednum"+index).val(),10);
		var applyednumval = parseInt($("#checknum"+index).val(),10);
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
	function refreshData(){
		var retObj;
		var basedatas;
		if('<%=deviceappid%>'!=null){
			var prosql = "select dad.device_allapp_detid,dad.device_app_detid,dad.team,dad.teamid,dad.apply_num,";
				prosql += "dad.dev_codetype,dad.dev_name_input as dev_ci_name,devtype.coding_name as dev_ci_model,p6.name as jobname,";
				prosql += "sd.coding_name as unit_name,teamsd.coding_name as teamname,aad.approve_num as require_num,dad.purpose,da.state,";
				prosql += "dad.plan_start_date,dad.plan_end_date,dad.unitinfo,";
				prosql += "allapp.device_allapp_no,allapp.device_allapp_name,allapp.remark,allapp.project_info_no,";
				prosql += "pro.project_name,nvl(tmp.applyed_num, 0) as applyed_num "
				prosql += "from gms_device_app_colldetail dad left join gms_device_collapp da on dad.device_app_id = da.device_app_id ";
				prosql += "left join bgp_p6_activity p6 on dad.teamid = p6.object_id ";
				prosql += "left join comm_coding_sort_detail devtype on dad.dev_codetype = devtype.coding_code_id ";
				prosql += "left join comm_coding_sort_detail teamsd on dad.team = teamsd.coding_code_id ";
				prosql += "left join gms_device_allapp allapp on da.device_allapp_id = allapp.device_allapp_id ";
				prosql += "left join gms_device_allapp_colldetail aad on dad.device_allapp_detid = aad.device_allapp_detid ";
				prosql += "left join comm_coding_sort_detail sd on aad.unitinfo = sd.coding_code_id ";
				prosql += "left join gp_task_project pro on dad.project_info_no = pro.project_info_no ";
				prosql += "left join (select device_allapp_detid,dev_name_input,dev_codetype,sum(apply_num) as applyed_num ";
				prosql += "from gms_device_app_colldetail where project_info_no='<%=projectInfoNo%>' and bsflag='0' group by device_allapp_detid,dev_name_input,dev_codetype) ";
				prosql += "tmp on aad.device_allapp_detid = tmp.device_allapp_detid ";
				prosql += "where da.device_app_id='<%=deviceappid%>' and da.bsflag='0' and aad.bsflag='0' and allapp.bsflag='0' and pro.bsflag='0' ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
			retObj = proqueryRet.datas;
		}
		//回填基本信息
		$("#project_name").val(retObj[0].project_name);
		$("#device_allapp_no").val(retObj[0].device_allapp_no);
		$("#device_allapp_name").val(retObj[0].device_allapp_name);
		for(var index=0;index<retObj.length;index++){
			//动态新增表格
			var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
			innerhtml += "<td><input type='checkbox' name='detinfo' id='"+index+"' value='"+retObj[index].device_allapp_detid+"' checked/></td>";
			innerhtml += "<td><input name='deviceappdetid"+index+"' id='deviceappdetid"+index+"' value='"+retObj[index].device_app_detid+"' type='hidden' readonly/>";
			innerhtml += "<input type='hidden' name='detinfo' id='"+index+"' alldetvalue='"+retObj[index].device_allapp_detid+"' value='"+retObj[index].device_app_detid+"' />";
			
			innerhtml += "<input name='jobname"+index+"' id='jobname"+index+"' style='line-height:15px' value='"+retObj[index].jobname+"' size='12' type='text' readonly/>";
			innerhtml += "<input name='teamid"+index+"' id='teamid"+index+"' style='line-height:15px' value='"+retObj[index].teamid+"' type='hidden' /></td>";
			innerhtml += "<td><input name='teamname"+index+"' id='teamname"+index+"' value='"+retObj[index].teamname+"' type='text' readonly/>";
			innerhtml += "<input name='team"+index+"' id='teamid"+index+"' value='"+retObj[index].team+"' type='hidden'/></td>";
			
			innerhtml += "<td><input name='devicename"+index+"' id='devicename"+index+"' style='line-height:15px' value='"+retObj[index].dev_ci_name+"' size='12' type='text' readonly/></td>";
			innerhtml += "<td><input name='devicetype"+index+"' id='devicetype"+index+"' value='"+retObj[index].dev_ci_model+"' size='15'  type='text' readonly/>";
			innerhtml += "<input name='dev_codetype"+index+"' id='dev_codetype"+index+"' value='"+retObj[index].dev_codetype+"' type='hidden' /></td>";
			
			innerhtml += "<td><input name='unitname"+index+"' id='unitname"+index+"' value='"+retObj[index].unit_name+"' size='3' type='text' readonly>";
			innerhtml += "<input name='unitinfo"+index+"' id='unitinfo"+index+"' value='"+retObj[index].unitinfo+"' type='hidden'></td>";
			
			innerhtml += "<td><input name='neednum"+index+"' id='neednum"+index+"' value='"+retObj[index].require_num+"' size='2' type='text' readonly/></td>";
			innerhtml += "<td><input name='applyednum"+index+"' id='applyednum"+index+"' value='"+retObj[index].applyed_num+"' size='2' type='text' readonly/></td>";
			innerhtml += "<td><input name='applynum"+index+"' id='applynum"+index+"' detindex='"+index+"' value='"+retObj[index].apply_num+"' size='2' type='text'  onkeyup='checkAssignNum(this)'/>";
			var checknum = parseInt(retObj[index].applyed_num)-parseInt(retObj[index].apply_num);
			innerhtml += "<input name='checknum"+index+"' id='checknum"+index+"'  value='"+checknum+"' type='hidden' /></td>";
			
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
		//回填明细信息
		//toMixDetailInfos();
		//获得当前显示的填报明细，给重新复制
		var divobj;
		$("div[name^='tab_box_content']","#tab_box").each(function(i){
			if(this.style.display == 'block'){
				divobj = this.idinfo;
			}
		})
		if(divobj == undefined)
			return;
		//回填信息
		var prosql = "select cds.device_detsubid,cds.device_app_detid,cds.device_id,cds.device_name,cds.device_model,";
			prosql += "cds.device_slot_num,cds.device_num,cds.unit_id,sd.coding_name as unit_name ";
			prosql += "from gms_device_app_colldetsub cds ";
			prosql += "left join gms_device_collectinfo ci on cds.device_id=ci.device_id ";
			prosql += "left join gms_device_app_colldetail cd on cds.device_app_detid=cd.device_app_detid ";
			prosql += "left join gms_device_collapp da on cd.device_app_id = da.device_app_id ";
			prosql += "join comm_coding_sort_detail sd on cds.unit_id=sd.coding_code_id ";
			prosql += "where da.device_app_id='<%=deviceappid%>' and da.bsflag='0' ";
			prosql += "and cds.device_app_detid='<%=deviceappdetid%>' order by ci.dev_code ";
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
		var basedatas = proqueryRet.datas;
		for(var index=0;index<basedatas.length;index++){
			lineinfo = index+1;
			var innerhtml = "<tr id='tr"+divobj+lineinfo+"' name='tr"+divobj+lineinfo+"' seqinfo='"+lineinfo+"'>";
			innerhtml += "<td><input type='checkbox' name='idinfo' id='"+divobj+lineinfo+"' /></td>";
			innerhtml += "<td>"+lineinfo+"<input type='hidden' id='device_id"+divobj+lineinfo+"' name='device_id"+divobj+lineinfo+"' value='"+basedatas[index].device_id+"'></td>";
			innerhtml += "<td><input name='devicename"+divobj+lineinfo+"' id='devicename"+divobj+lineinfo+"' style='line-height:15px' value='"+basedatas[index].device_name+"' size='30' type='text' readonly/></td>";
			innerhtml += "<td><input name='devicemodel"+divobj+lineinfo+"' id='devicemodel"+divobj+lineinfo+"' style='line-height:15px' value='"+basedatas[index].device_model+"' size='30' type='text' readonly/></td>";
			innerhtml += "<td><input name='unit_name"+divobj+lineinfo+"' id='unit_name"+divobj+lineinfo+"' style='line-height:15px' value='"+basedatas[index].unit_name+"' size='4' type='text' readonly/>";
			innerhtml += "<input name='unitList"+divobj+lineinfo+"' id='unitList"+divobj+lineinfo+"' value='"+basedatas[index].unit_id+"' type='hidden' /></td>";
			innerhtml += "<td><input name='devslotnum"+divobj+lineinfo+"' id='devslotnum"+divobj+lineinfo+"' style='line-height:15px' value='"+basedatas[index].device_slot_num+"' size='6' type='text' readonly/></td>";
			innerhtml += "<td><input name='apply_num"+divobj+lineinfo+"' id='apply_num"+divobj+lineinfo+"' checkinfo='"+divobj+lineinfo+"' style='line-height:15px' value='"+basedatas[index].device_num+"' size='10' type='text' onkeyup='checkInputNum(this)'/></td>";
			innerhtml += "<td><input name='totalslotnum"+divobj+lineinfo+"' id='totalslotnum"+divobj+lineinfo+"' style='line-height:15px' value='"+parseInt(basedatas[index].device_slot_num)*parseInt(basedatas[index].device_num)+"' size='10' type='text' readonly/></td>";
			innerhtml += "</tr>";
			$("#detailList"+divobj).append(innerhtml);
		}
		$("#detailList"+divobj+">tr:odd>td:odd").addClass("odd_odd");
		$("#detailList"+divobj+">tr:odd>td:even").addClass("odd_even");
		$("#detailList"+divobj+">tr:even>td:odd").addClass("even_odd");
		$("#detailList"+divobj+">tr:even>td:even").addClass("even_even");	
		//给模板放进内容 start
		var querySql = "select model_mainid,model_name ";
		querySql += "from gms_device_collmodel_main main ";
		querySql += "where main.bsflag='0' and main.model_type='"+retObj[0].dev_codetype+"' ";
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
	}
</script>
</html>

