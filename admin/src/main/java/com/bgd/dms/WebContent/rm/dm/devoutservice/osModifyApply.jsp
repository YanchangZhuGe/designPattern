<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String deviceosappid = request.getParameter("deviceosappid");
	UserToken user = OMSMVCUtil.getUserToken(request);
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
<title>报停计划修改界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend style="color:#B0B0B0;">报停申请基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >报停申请单名称:</td>
          <td class="inquire_form4" >
          	<input name="osapp_name" id="osapp_name" class="input_width" type="text" value="" />
          	<input name="project_info_no" id="project_info_no" type="hidden" value="<%=projectInfoNo%>" />
          	<input name="deviceosappid" id="deviceosappid" type="hidden" value="<%=deviceosappid%>" />
          </td>
          <td class="inquire_item4" >报停申请单号:</td>
          <td class="inquire_form4" >
          	<input name="device_osapp_no" id="device_osapp_no" class="input_width" type="text" value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >报停单位:</td>
          <td class="inquire_form4" >
          	<input name="osapp_orgname" id="osapp_orgname" class="input_width" type="text" value="" readonly/>
          	<input name="osapporgid" id="osapporgid" type="hidden" value="" />
          </td>
          <td class="inquire_item4" >报停时间:</td>
          <td class="inquire_form4" >
          	<input name="osappdate" id="osappdate" class="input_width" type="text" value="" readonly/>
          </td>
        </tr>
      </table>
      </fieldset>
      <fieldset style="margin-left:2px"><legend>设备计划信息</legend>
		<div id="tag-container_4" style="float:left">
		  <ul id="tags" class="tags">
		    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">单台管理设备</a></li>
		    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">批量管理设备</a></li>
		  </ul>
		</div>
		<div id="oprdiv0" name="oprdiv" style="float:left;width:70%;overflow:auto;">
	      	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  	<tr align="right">
			  		<td class="ali_cdn_name" ></td>
			  		<td class="ali_cdn_input" ></td>
			  		<td class="ali_cdn_name" ></td>
			  		<td class="ali_cdn_input" ></td>
			  		<td class="ali_query">
			    	<auth:ListButton functionId="" css="zj" id="addProcess" event="" title="添加按台管理设备"></auth:ListButton>
			    	<auth:ListButton functionId="" css="sc" id="delProcess" event="" title="删除按台管理设备"></auth:ListButton>
				</tr>
			  </table>
		  </div>
		  <div id="resultdiv0" name="resultdiv" style="float:left;height:220px;overflow:auto;">
			  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   <tr>
				<td class="bt_info_even" width="4%">选择</td>
				<td class="bt_info_odd" width="10%">设备编号</td>
				<td class="bt_info_even" width="9%">设备名称</td>
				<td class="bt_info_odd" width="7.5%">规格型号</td>
				<td class="bt_info_even" width="7.5%">自编号</td>
				<td class="bt_info_odd" width="7.5%">实物标识号</td>
				<td class="bt_info_even" width="7.5%">牌照号</td>
				<td class="bt_info_odd" width="8%">设备所属单位</td>
				<td class="bt_info_even" width="7.5%">进队日期</td>
				<td class="bt_info_odd" width="7.5%">报停原因</td>
				<td class="bt_info_even" width="12%">预计报停日期</td>
				<td class="bt_info_odd" width="12%">预计启动日期</td>
			   </tr>
			   </table>
			   <div style="height:190px;overflow:auto;">
				<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  	<tbody id="processtable0" name="processtable0" >
			  	</tbody>
		      	</table>
		      </div>
		  </div>
		  <div id="oprdiv1" name="oprdiv" style="float:left;width:70%;overflow:auto;display:none">
	      	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  	<tr align="right">
			  		<td class="ali_cdn_name" ></td>
			  		<td class="ali_cdn_input" ></td>
			  		<td class="ali_cdn_name" ></td>
			  		<td class="ali_cdn_input" ></td>
			  		<td class="ali_query">
			    	<auth:ListButton functionId="" css="zj" event="onclick='addCollRows()'" title="添加按量管理设备"></auth:ListButton>
			    	<auth:ListButton functionId="" css="sc" event="onclick='delCollRows()'" title="删除按量管理设备"></auth:ListButton>
				</tr>
			  </table>
		  </div>
		  <div id="resultdiv1" name="resultdiv" style="float:left;height:220px;overflow:auto;display:none">
			  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		        <tr>
				<td class="bt_info_even" width="5%">选择</td>
				<td class="bt_info_odd" width="15%">设备名称</td>
				<td class="bt_info_even" width="8%">规格型号</td>
				<td class="bt_info_odd" width="8%">在队数量</td>
				<td class="bt_info_even" width="8%">报停数量</td>
				<td class="bt_info_odd" width="15%">设备所属单位</td>
				<td class="bt_info_even" width="15%">报停原因</td>
				<td class="bt_info_odd" width="15%">预计报停日期</td>
				<td class="bt_info_even" width="15%">预计启动日期</td>
				</tr>
			   </table>
				<div style="height:190px;overflow:auto;">
				<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   <tbody id="processtable1" name="processtable1" >
			   </tbody>
		      </table>
		      </div>
		  </div>
		</fieldset>
    </div>
    <div id="oper_div">
	   <span class="bc_btn"><a href="#" onclick="submitInfo(0)"></a></span>
	   <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
	 </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	var projectInfoNo = '<%=projectInfoNo%>';
	var deviceosappid = '<%=deviceosappid%>';
	
	function refreshData(){
		var retObj;
		var basedatas;
		if('<%=projectInfoNo%>'!=null){
			//查询基本信息
			var querySql = "select pro.project_name,osapp.device_osapp_id,osapp.device_osapp_no,osapp.osapp_name,";
			querySql += "osapp.osapp_org_id,osorg.org_name as osapp_org_name,osapp.osappdate ";
			querySql += "from gms_device_osapp osapp ";
			querySql += "join gp_task_project pro on osapp.project_info_no=pro.project_info_no ";
			querySql += "join comm_org_information osorg on osorg.org_id = osapp.osapp_org_id ";
			querySql += "where pro.bsflag='0' and pro.project_info_no='<%=projectInfoNo%>' and osapp.device_osapp_id='<%=deviceosappid%>'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			basedatas = queryRet.datas;
		}
		//回填基本信息
		$("#project_name").val(basedatas[0].project_name);
		$("#osappdate").val(basedatas[0].osappdate);
		$("#device_osapp_no").val(basedatas[0].device_osapp_no);
		$("#osapp_name").val(basedatas[0].osapp_name);
		$("#osapporgid").val(basedatas[0].osapp_org_id);
		$("#osapp_orgname").val(basedatas[0].osapp_org_name);
		var retObj;
		if('<%=projectInfoNo%>'!=null){
			//查询明细信息
			var querySql = "select osdet.device_osdet_id,osdet.dev_acc_id,osdet.dev_name,osdet.dev_model,osdet.dev_coding,osdet.self_num,osdet.dev_sign,outorg.org_abbreviation as out_org_name,";
			querySql += "osdet.license_num,osdet.dev_unit,osdet.reason,osdet.start_date,osdet.plan_end_date,osdet.out_org_id,osdet.act_in_time,unitsd.coding_name as unit_name ";
			querySql += "from gms_device_osapp_detail osdet ";
			querySql += "left join comm_org_information outorg on osdet.out_org_id = outorg.org_id  ";
			querySql += "left join comm_coding_sort_detail unitsd on osdet.dev_unit=unitsd.coding_code_id ";
			querySql += "where osdet.devtype='1' and osdet.device_osapp_id='<%=deviceosappid%>'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			retObj = queryRet.datas;
		}
		if(retObj!=undefined&&retObj.length>0){
			for(var index=0;index<retObj.length;index++){
				var innerhtml = "<tr id='tr"+retObj[index].dev_acc_id+"' name='tr' midinfo='"+retObj[index].dev_acc_id+"'>";
				innerhtml += "<td width='4%'><input type='checkbox' name='idinfo' id='"+retObj[index].dev_acc_id+"' idinfo='"+index+"' readonly/></td>";
				innerhtml += "<td width='10%'><input name='dev_coding"+index+"' value='"+retObj[index].dev_coding+"' size='9' type='text' readonly/></td>";
				innerhtml += "<td width='9%'><input name='dev_name"+index+"' value='"+retObj[index].dev_name+"' size='8' type='text' readonly/></td>";
				innerhtml += "<td width='7.5%'><input name='dev_model"+index+"' value='"+retObj[index].dev_model+"' size='6' type='text' readonly/></td>";
				innerhtml += "<td width='7.5%'><input name='self_num"+index+"' value='"+retObj[index].self_num+"' size='6' type='text' readonly/></td>";
				innerhtml += "<td width='7.5%'><input name='dev_sign"+index+"' value='"+retObj[index].dev_sign+"' size='6' type='text' readonly/></td>";
				innerhtml += "<td width='7.5%'><input name='license_num"+index+"' value='"+retObj[index].license_num+"' size='6' type='text' readonly/></td>";
				innerhtml += "<td width='8%'><input name='out_org_name"+index+"' value='"+retObj[index].out_org_name+"' size='6' type='text' readonly/></td>";
				innerhtml += "<td width='7.5%'><input name='start_date"+index+"' value='"+retObj[index].start_date+"' size='6' type='text' readonly/></td>";
				innerhtml += "<td width='7.5%'><input name='reason"+index+"' value='"+retObj[index].reason+"' size='6' type='text'/>";
				innerhtml += "<input name='deviceosdetid"+index+"' value='"+retObj[index].device_osdet_id+"' type='hidden'/></td>";
				innerhtml += "<td width='12%'><input name='startdate"+index+"' id='startdate"+index+"' value='"+retObj[index].start_date+"' style='line-height:15px' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(startdate"+index+",tributton2"+index+");'/></td>";
				innerhtml += "<td width='12%'><input name='enddate"+index+"' id='enddate"+index+"' value='"+retObj[index].plan_end_date+"' style='line-height:15px' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+index+",tributton3"+index+");'/></td>";
				innerhtml += "</tr>";
				
				$("#processtable0").append(innerhtml);			
			}
			$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable0>tr:odd>td:even").addClass("odd_even");
			$("#processtable0>tr:even>td:odd").addClass("even_odd");
			$("#processtable0>tr:even>td:even").addClass("even_even");
		}
		if('<%=projectInfoNo%>'!=null){
			//查询明细信息
			var querySql = "select dui.dev_acc_id,dui.unuse_num,osdet.dev_model,osdet.device_osdet_id,osdet.dev_acc_id,osdet.dev_name,osdet.dev_coding,osdet.self_num,osdet.dev_sign,outorg.org_abbreviation as out_org_name,";
			querySql += "osdet.license_num,osdet.dev_unit,osdet.reason,osdet.start_date,osdet.plan_end_date,osdet.out_org_id,osdet.act_in_time,unitsd.coding_name as unit_name,";
			querySql += "osdet.osnum ";
			querySql += "from gms_device_osapp_detail osdet ";
			querySql += "left join comm_org_information outorg on osdet.out_org_id = outorg.org_id  ";
			querySql += "left join comm_coding_sort_detail unitsd on osdet.dev_unit=unitsd.coding_code_id ";
			querySql += "left join gms_device_coll_account_dui dui on osdet.dev_acc_id=dui.dev_acc_id ";
			querySql += "where osdet.devtype='2' and osdet.device_osapp_id='<%=deviceosappid%>'";
			
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			retObj = queryRet.datas;
			
		}
		if(retObj!=undefined&&retObj.length>0){
			for(var tr_id=0;tr_id<retObj.length;tr_id++){
				
				//动态新增表格
				var innerhtml = "<tr id='tr"+retObj[tr_id].dev_acc_id+"' name='tr"+tr_id+"' collseq='"+tr_id+"'>";
				
				innerhtml += "<td width='5%'><input type='checkbox' name='collidinfo' id='"+retObj[tr_id].dev_acc_id+"'/></td>";
				innerhtml += "<td width='15%'>"+retObj[tr_id].dev_name+"<input value='"+retObj[tr_id].dev_name+"' name='colldevicetype"+tr_id+"' id='colldevicetype"+tr_id+"' class='input_width' type='hidden'/></td>";
				innerhtml += "<td width='8%'>"+retObj[tr_id].dev_model+"</td>";
				innerhtml += "<td width='8%'>"+retObj[tr_id].unuse_num+"</td>";
				innerhtml += "<td width='8%'><input name='collneednum"+tr_id+"' id='collneednum"+tr_id+"' class='input_width' value='' size='10' type='text' unuseNum='"+retObj[tr_id].unuse_num+"' onkeyup='checkAppNum(this)'/></td>";
				innerhtml += "<td width='15%'><input name='collorgname"+tr_id+"' id='collorgname"+tr_id+"' class='input_width' value='' size='10' type='text'/>";
				innerhtml += "<img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick=showCollOrgPage('collorg','"+tr_id+"') />";
				innerhtml += "<input name='collorgid"+tr_id+"' id='collorgid"+tr_id+"' class='input_width' value='' size='10' type='hidden'/></td>";
				innerhtml += "<td width='15%'><input name='collreason"+tr_id+"' class='input_width' value='' size='10' type='text'/></td>";
				innerhtml += "<td width='15%'><input name='collstartdate"+tr_id+"' id='collstartdate"+tr_id+"' style='line-height:15px' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='colltributton2"+tr_id+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(collstartdate"+tr_id+",colltributton2"+tr_id+");'/></td>";
				innerhtml += "<td width='15%'><input name='collenddate"+tr_id+"' id='collenddate"+tr_id+"' style='line-height:15px' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='colltributton3"+tr_id+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(collenddate"+tr_id+",colltributton3"+tr_id+");'/></td>";
				innerhtml += "</tr>";
				
				$("#processtable1").append(innerhtml);
				//查询公共代码，并且回填到界面的申请类型中
				var colltypeObj;
				var colltypeSql = "select t.coding_code_id as value,t.coding_name as label ";
				colltypeSql += "from comm_coding_sort_detail t "; 
				colltypeSql += "where t.coding_sort_id='5110000031' and t.bsflag='0' order by t.coding_show_id";
				var colltypeRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+colltypeSql);
				colltypeObj = colltypeRet.datas;
				var colltypeoptionhtml = "";
				for(var index=0;index<colltypeObj.length;index++){
					colltypeoptionhtml +=  "<option name='colltypecode' id='colltypecode"+index+"' value='"+colltypeObj[index].value+"'>"+colltypeObj[index].label+"</option>";
				}
				$("#colldevicetype"+tr_id).append(colltypeoptionhtml);
				$("#colldevicetype"+tr_id).val(retObj[tr_id].dev_name);
				//查询公共代码，并且回填到界面的单位中
				var retObj;
				var unitSql = "select sd.coding_code_id,coding_name ";
				unitSql += "from comm_coding_sort_detail sd "; 
				unitSql += "where coding_sort_id ='0110000004' and coding_name='道' ";
				var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql);
				retObj = unitRet.datas;
				var optionhtml = "";
				for(var index=0;index<retObj.length;index++){
					optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
				}
				$("#collunit"+tr_id).append(optionhtml);
			}
			$("#processtable1>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable1>tr:odd>td:even").addClass("odd_even");
			$("#processtable1>tr:even>td:odd").addClass("even_odd");
			$("#processtable1>tr:even>td:even").addClass("even_even");
		}
	}
	
	$().ready(function(){
		$("#addProcess").click(function(){
			var paramobj = new Object();
			var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectAccountForOS.jsp?projectinfono="+projectInfoNo,paramobj,"dialogWidth=820px;dialogHeight=380px");
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
			var devdetSql = "select account.dev_acc_id,account.asset_coding,unitsd.coding_name as unit_coding_name, ";
				devdetSql += "account.dev_coding,account.self_num,account.dev_sign,account.out_org_id,outorg.org_name as out_org_name,";
				devdetSql += "account.license_num,account.actual_in_time,account.planning_out_time, ";
				devdetSql += "account.dev_name,account.dev_model ";
				devdetSql += "from gms_device_account_dui account ";
				devdetSql += "left join comm_coding_sort_detail unitsd on account.dev_unit=unitsd.coding_code_id ";
				devdetSql += "left join comm_org_information outorg on account.out_org_id=outorg.org_id ";
				devdetSql += "where account.dev_acc_id in "+condition ;
				devdetSql += "and account.project_info_id='"+projectInfoNo+"' ";
				devdetSql += "order by account.planning_out_time,account.dev_type";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devdetSql);
				var retObj = proqueryRet.datas;
				for(var index=0;index<retObj.length;index++){
					var innerhtml = "<tr id='tr"+retObj[index].dev_acc_id+"' name='tr' midinfo='"+retObj[index].dev_acc_id+"'>";
					innerhtml += "<td width='4%'><input type='checkbox' name='idinfo' id='"+retObj[index].dev_acc_id+"' idinfo='"+index+"' /></td>";
					innerhtml += "<td width='10%'><input name='dev_coding"+index+"' value='"+retObj[index].dev_coding+"' size='9' type='text'/></td>";
					innerhtml += "<td width='9%'><input name='dev_name"+index+"' value='"+retObj[index].dev_name+"' size='8' type='text'/></td>";
					innerhtml += "<td width='7.5%'><input name='dev_model"+index+"' value='"+retObj[index].dev_model+"' size='6' type='text'/></td>";
					innerhtml += "<td width='7.5%'><input name='self_num"+index+"' value='"+retObj[index].self_num+"' size='6' type='text'/></td>";
					innerhtml += "<td width='7.5%'><input name='dev_sign"+index+"' value='"+retObj[index].dev_sign+"' size='6' type='text'/></td>";
					innerhtml += "<td width='7.5%'><input name='license_num"+index+"' value='"+retObj[index].license_num+"' size='6' type='text'/></td>";
					innerhtml += "<td width='8%'><input name='out_org_name"+index+"' value='"+retObj[index].out_org_name+"' size='6' type='text'/></td>";
					innerhtml += "<td width='7.5%'><input name='actual_in_time"+index+"' value='"+retObj[index].actual_in_time+"' size='6' type='text'/></td>";
					innerhtml += "<td width='7.5%'><input name='reason"+index+"' value='' size='6' type='text'/></td>";
					innerhtml += "<td width='12%'><input name='startdate"+index+"' id='startdate"+index+"' style='line-height:15px' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton2"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(startdate"+index+",tributton2"+index+");'/></td>";
					innerhtml += "<td width='12%'><input name='enddate"+index+"' id='enddate"+index+"' style='line-height:15px' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='tributton3"+index+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(enddate"+index+",tributton3"+index+");'/></td>";
					innerhtml += "</tr>";
					$("#processtable0").append(innerhtml);
				}
				$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
				$("#processtable0>tr:odd>td:even").addClass("odd_even");
				$("#processtable0>tr:even>td:odd").addClass("even_odd");
				$("#processtable0>tr:even>td:even").addClass("even_even");
		});
		$("#delProcess").click(function(){
			$("input[type='checkbox'][name='idinfo']").each(function(i){
				if(this.checked){
					var id=this.id;
					$("#tr"+id).remove();
				}
			});
			$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable0>tr:odd>td:even").addClass("odd_even");
			$("#processtable0>tr:even>td:odd").addClass("even_odd");
			$("#processtable0>tr:even>td:even").addClass("even_even");
		});
	});
	function getContentTab(obj,index) {
		$("LI","#tag-container_4").removeClass("selectTag");
		var contentSelectedTag = obj.parentElement;
		contentSelectedTag.className ="selectTag";

		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		$(filternotobj).hide();
		$(filterobj).show();
		//给关联的按钮给隐藏
		var oprfilterobj = "div[name='oprdiv'][id='oprdiv"+index+"']";
		var oprfilternotobj = "div[name='oprdiv'][id!='oprdiv"+index+"']";
		$(oprfilternotobj).hide();
		$(oprfilterobj).show();
		//给结果区的数据DIV进行控制
		var resfilterobj = "div[name='resultdiv'][id='resultdiv"+index+"']";
		var resfilternotobj = "div[name='resultdiv'][id!='resultdiv"+index+"']";
		$(resfilternotobj).hide();
		$(resfilterobj).show();
	}
	function addCollRows(){
		tr_id = $("#processtable1>tr:last").attr("id");
		if(tr_id != undefined){
			tr_id = parseInt(tr_id.substr(2,1),10);
		}
		if(tr_id == undefined){
			tr_id = 0;
		}else{
			tr_id = tr_id+1;
		}
		//动态新增表格
		var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' collseq='"+tr_id+"'>";
		
		innerhtml += "<td width='5%'><input type='checkbox' name='collidinfo' id='"+tr_id+"'/></td>";
		innerhtml += "<td width='15%'><select name='colldevicetype"+tr_id+"' id='colldevicetype"+tr_id+"' class='select_width' ></select></td>";
		innerhtml += "<td width='8%'><select name='collunit"+tr_id+"' id='collunit"+tr_id+"' ></select></td>";
		innerhtml += "<td width='8%'><input name='collneednum"+tr_id+"' id='collneednum"+tr_id+"' class='input_width' value='' size='10' type='text' onkeyup='checkAppNum(this)'/></td>";
		innerhtml += "<td width='15%'><input name='collorgname"+tr_id+"' id='collorgname"+tr_id+"' class='input_width' value='' size='10' type='text'/>";
		innerhtml += "<img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick=showCollOrgPage('collorg','"+tr_id+"') />";
		innerhtml += "<input name='collorgid"+tr_id+"' id='collorgid"+tr_id+"' class='input_width' value='' size='10' type='hidden'/></td>";
		innerhtml += "<td width='15%'><input name='collreason"+tr_id+"' class='input_width' value='' size='10' type='text'/></td>";
		innerhtml += "<td width='15%'><input name='collstartdate"+tr_id+"' id='collstartdate"+tr_id+"' style='line-height:15px' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='colltributton2"+tr_id+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(collstartdate"+tr_id+",colltributton2"+tr_id+");'/></td>";
		innerhtml += "<td width='15%'><input name='collenddate"+tr_id+"' id='collenddate"+tr_id+"' style='line-height:15px' size='10' type='text'/><img src='"+"<%=contextPath%>"+"/images/calendar.gif' id='colltributton3"+tr_id+"' width='16' height='16' style='cursor: hand;'"+"onmouseover='calDateSelector(collenddate"+tr_id+",colltributton3"+tr_id+");'/></td>";
		innerhtml += "</tr>";
		
		$("#processtable1").append(innerhtml);
		//查询公共代码，并且回填到界面的申请类型中
		var colltypeObj;
		var colltypeSql = "select t.coding_code_id as value,t.coding_name as label ";
		colltypeSql += "from comm_coding_sort_detail t "; 
		colltypeSql += "where t.coding_sort_id='5110000031' and t.bsflag='0' order by t.coding_show_id";
		var colltypeRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+colltypeSql);
		colltypeObj = colltypeRet.datas;
		var colltypeoptionhtml = "";
		for(var index=0;index<colltypeObj.length;index++){
			colltypeoptionhtml +=  "<option name='colltypecode' id='colltypecode"+index+"' value='"+colltypeObj[index].value+"'>"+colltypeObj[index].label+"</option>";
		}
		$("#colldevicetype"+tr_id).append(colltypeoptionhtml);
		
		//查询公共代码，并且回填到界面的单位中
		var retObj;
		var unitSql = "select sd.coding_code_id,coding_name ";
		unitSql += "from comm_coding_sort_detail sd "; 
		unitSql += "where coding_sort_id ='0110000004' and coding_name='道' ";
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql);
		retObj = unitRet.datas;
		var optionhtml = "";
		for(var index=0;index<retObj.length;index++){
			optionhtml +=  "<option name='unitcode' id='unitcode"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
		}
		$("#collunit"+tr_id).append(optionhtml);
		
		$("#processtable1>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable1>tr:odd>td:even").addClass("odd_even");
		$("#processtable1>tr:even>td:odd").addClass("even_odd");
		$("#processtable1>tr:even>td:even").addClass("even_even");
	};
	function delCollRows(){
		$("input[name='collidinfo']").each(function(){
			if(this.checked){
				$('#tr'+this.id,"#processtable1").remove();
			}
		});
		
		$("#processtable1>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable1>tr:odd>td:even").addClass("odd_even");
		$("#processtable1>tr:even>td:odd").addClass("even_odd");
		$("#processtable1>tr:even>td:even").addClass("even_even");
	};
	function showCollOrgPage(keyinfo,lineinfo){
		var paramobj = new Object();
		var retvalue = window.showModalDialog("<%=contextPath%>/rm/dm/devoutservice/selectCollOrgPage.jsp?projectinfono="+projectInfoNo,paramobj,"dialogWidth=820px;dialogHeight=380px");
		//得到了ID和SHORTNAME
		var infos = retvalue.split("~",-1);
		alert(infos[0]);
		alert(infos[1]);
		alert("#"+keyinfo+"id"+lineinfo);
		$("#"+keyinfo+"id"+lineinfo).val(infos[0]);
		$("#"+keyinfo+"name"+lineinfo).val(infos[1]);
	}
	function checkAppNum(obj){
		var re = /^\+?[1-9][0-9]*$/;
		//检查所有的数量字段 
		if(!re.test(obj.value)){
			alert("调配数量必须为数字，且大于0!");
			obj.value = "";
		}
	}
	function submitInfo(state){
		var osapp_name = $("#osapp_name").val();
		if(osapp_name==''){
			alert("请输入报停申请单名称!");
			return;
		}
		//保留单台的行信息
		var count = 0;
		var idinfos;
		var line_infos;
		var existsflag = false;
		$("input[type='checkbox'][name='idinfo']").each(function(){
			var id = this.idinfo;
			var thisrealid = $("deviceosdetid"+id).val();
			if(count == 0){
				idinfos = this.id;
				line_infos = id;
			}else{
				idinfos = idinfos+"~"+this.id;
				line_infos = line_infos+"~"+id;
			}
			if($("#startdate"+id).val()==''||$("#enddate"+id).val()==''){
				existsflag = true;
			}
			count++;
		});
		if(existsflag){
			alert("单台设备报停明细中计划报停日期和计划启动日期不能为空!");
			return;
		}
		//保留采集外设的行信息
		var collcount = 0;
		var collidinfos;
		$("input[type='checkbox'][name='collidinfo']").each(function(){
			var id = this.id;
			var thisrealid = $("colldeviceosdetid"+id).val();
			if(collcount == 0){
				collidinfos = this.id;
			}else{
				collidinfos = collidinfos+"~"+this.id;
			}
			if($("#collneednum"+id).val()==''||$("#collstartdate"+id).val()==''||$("#collstartdate"+id).val()==''){
				existsflag = true;
			}
			collcount++;
		});
		if(existsflag){
			alert("单台设备报停明细中报停数量、计划报停日期和计划启动日期不能为空!");
			return;
		}
		if(count==0 && collcount == 0){
			alert('请添加报停明细信息!');
			return;
		}
		$("#device_osapp_no").val("");
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveOsAppDetailInfo.srq?state="+state+"&count="+count+"&idinfos="+idinfos+"&line_infos="+line_infos+"&collcount="+collcount+"&collidinfos="+collidinfos;
		document.getElementById("form1").submit();
	}
</script>
</html>

