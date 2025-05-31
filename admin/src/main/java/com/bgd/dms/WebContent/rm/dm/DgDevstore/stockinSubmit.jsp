<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<title>设备入库明细</title>
</head>
<body class="bgColor_f3f3f3" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<input type="hidden" id="detail_count" value="" />
<input type="hidden" id="device_backdet_id" name="device_backdet_id"></input>
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
 <!--    <fieldSet style="margin-left:2px"><legend >基本信息</legend>
           <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
         	<tr>
                <td class="inquire_item6">设备编号</td>
				<td class="inquire_form6"><input id="dev_coding" name="dev_coding" class="input_width" type="text" /></td>
				<td class="inquire_item6">设备名称</td>
				<td class="inquire_form6"><input id="dev_name" name="dev_name"  class="input_width" type="text" /></td>
				<td class="inquire_item6">规格型号</td>
				<td class="inquire_form6"><input id="dev_model" name="dev_model" class="input_width" type="text" /></td>
				
			  </tr>
				<tr>
				<td class="inquire_item6">实物标识号</td>
				<td class="inquire_form6"><input id="dev_sign" name="dev_sign" class="input_width" type="text" /></td>
				<td class="inquire_item6">自编号</td>
				<td class="inquire_form6"><input id="self_num" name="self_num" class="input_width" type="text" /></td>
				<td class="inquire_item6">牌照号</td>
				<td class="inquire_form6"><input id="license_num" name="license_num" class="input_width" type="text" /></td>
			  </tr>
			  <tr>
				<td class="inquire_item6">资产状况</td>
				<td class="inquire_form6"><input id="asset_state" name="asset_state" class="input_width" type="text" /></td>
				<td class="inquire_item6">计划离场时间</td>
				<td class="inquire_form6"><input id="planning_out_time" name="planning_out_time" class="input_width" type="text" /></td>
				<td class="inquire_item6">实际离场时间</td>
				<td class="inquire_form6"><input id="actual_in_time" name="actual_in_time" class="input_width" type="text" /></td>
			  </tr>
			 </table>
		</fieldSet>
 --> 		
		<fieldset style="margin-left:2px"><legend >离场信息</legend>
			 <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			 <tr>
			  	<td class="inquire_item6">存放地(省份+库房)</td>
				<td class="inquire_form6" colspan="3">
				<select id="province" name="province" class="select_width" style="width: 30%;"> 
					<option value="安徽省">安徽省</option>
					<option value="澳门特别行政区">澳门特别行政区</option>
					<option value="北京市">北京市</option>
					<option value="重庆市">重庆市</option>
					<option value="福建省">福建省</option>
					<option value="甘肃省">甘肃省</option>
					<option value="广东省">广东省</option>
					<option value="广西壮族自治区">广西壮族自治区</option>
					<option value="贵州省">贵州省</option>
					<option value="海南省">海南省</option>
					<option value="河北省">河北省</option>
					<option value="黑龙江省">黑龙江省</option>
					<option value="河南省">河南省</option>
					<option value="湖北省">湖北省</option>
					<option value="湖南省">湖南省</option>
					<option value="江苏省">江苏省</option>
					<option value="江西省">江西省</option>
					<option value="吉林省">吉林省</option>
					<option value="辽宁省">辽宁省</option>
					<option value="内蒙古">内蒙古</option>
					<option value="宁夏回族自治区">宁夏回族自治区</option>
					<option value="青海省">青海省</option>
					<option value="陕西省">陕西省</option>
					<option value="山东省">山东省</option>
					<option value="上海市">上海市</option>
					<option value="山西省">山西省</option>
					<option value="四川省">四川省</option>
					<option value="台湾">台湾</option>
					<option value="天津市">天津市</option>
					<option value="香港特别行政区">香港特别行政区</option>
					<option value="新疆维吾尔族自治区">新疆维吾尔族自治区</option>
					<option value="西藏自治区">西藏自治区</option>
					<option value="云南省">云南省</option>
					<option value="浙江省">浙江省</option>
				</select>&nbsp;&nbsp;&nbsp;&nbsp;
				<input id="dev_position" name="dev_position" class="input_width" type="text" style="width: 60%; float: none;margin-bottom: 7px;"/>
				</td>
			</tr>
			  <tr>
				<td class="inquire_item6">技术状况</td>
				<td class="inquire_form6"><select type="text" name="tech_stat" id="tech_stat" value="" readonly="readonly" class="select_width">
					<option value="0110000006000000001">完好</option>
					<option value="0110000006000000006">待修</option>
					<option value="0110000006000000005">待报废</option>
					<option value="0110000006000000013">验收</option>
				</select>
				</td>
				<td class="inquire_item6">验收时间</td>
				<td class="inquire_form6">
					<input type="text" name="actual_out_date" id="actual_out_date" value="" readonly="readonly" class="input_width"/>
					<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;"
					onmouseover="calDateSelector(actual_out_date,tributton1);" />
				</td>
			  </tr>
      		 </table>
      	</fieldset>
      	<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_appdet_id_{device_backapp_id}' name='device_backapp_id'>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_model}">规格型号</td>
					<td class="bt_info_odd" exp="{self_num}">自编号</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_odd" exp="{license_num}">牌照号</td>
					<td class="bt_info_even" exp="{stat_desc}">资产状况</td>
					<td class="bt_info_odd" exp="{planning_out_time}">计划离场时间</td>
					<td class="bt_info_even" exp="{actual_in_time}">实际离场时间</td>
			     </tr> 
			  </table>
		</div>
		<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
		</div>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a id="submitButton" href="#" onclick="submitInfo()" ></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript"> 

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';

	$().ready(function(){
		$("#addProcess").click(function(){
			tr_id = $("#processtable>tbody>tr:last").attr("id");
			if(tr_id != undefined){
				tr_id = parseInt(tr_id.substr(2,1),10);
			}
			if(tr_id == undefined){
				tr_id = 0;
			}else{
				tr_id = tr_id+1;
			}
			//统计本次的总行数
			$("#detail_count").val(tr_id);
			//动态新增表格
			var innerhtml = "<tr id = 'tr"+tr_id+"' ><td><input type='checkbox' name='idinfo' id='"+tr_id+"'/><input name='devicename"+tr_id+"' value='通过设备编码树选择设备名称' size='12' type='text'/></td><td><input name='devicetype"+tr_id+"' class='input_width' value='设备名称带出类型' size='12' type='text'/></td><td><input name='signtype"+tr_id+"' class='input_width' value='名称和类型带出类别' size='12' type='text'/></td><td><input name='unit"+tr_id+"' class='input_width' type='text'/></td><td><input name='neednum"+tr_id+"' class='input_width' value='' size='8' type='text'/></td><td><input name='team"+tr_id+"' class='input_width' type='text'/></td><td><input name='purpose"+tr_id+"' class='input_width' value='' size='8' type='text'/></td><td><input name='startdate"+tr_id+"' class='input_width' type='text'/></td><td><input name='enddate"+tr_id+"' class='input_width' type='text'/></td></tr>";
			
			$("#processtable").append(innerhtml);
			if(tr_id%2 == 0){
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:odd").addClass("odd_odd");
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:even").addClass("odd_even");
			}else{
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:odd").addClass("even_odd");
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:even").addClass("even_even");
			}
		});
		$("#delProcess").click(function(){
			$("input[name='idinfo']").each(function(){
				if(this.checked){
					var selected_id = this.id;
					$('#tr'+selected_id).remove();
				}
			});
		});
	});
	var devaccId="";
	var projectInfoNo="";
	var devicebackappid="";
	var devicemixinfoid = "";
	function loadDataDetail(){
		
		var device_backdet_id = '<%=request.getParameter("id")%>';
		document.getElementById("device_backdet_id").value = device_backdet_id;
		var temp = device_backdet_id.split(",");
		var idss = "";
		var retObj;
		if(device_backdet_id!=null){
		    var querySql="select backdet.*,dui.dev_name,dui.fk_dev_acc_id,dui.dev_model,dui.project_info_id,";
		    	querySql+="sd.coding_name as stat_desc ";
		    	querySql+="from gms_device_backapp_detail backdet ";
		    	querySql+="left join gms_device_account_dui dui on backdet.dev_acc_id=dui.dev_acc_id ";
		    	querySql+="left join comm_coding_sort_detail sd on dui.asset_stat = sd.coding_code_id ";
				querySql+="where backdet.bsflag='0' ";
					
				querySql+="and backdet.device_backdet_id in (";
				for(var i=0;i<temp.length;i++){
					if(idss!="") idss += ",";
					idss += "'"+temp[i]+"'";
				}
				querySql = querySql+idss+")";
				
				cruConfig.queryStr = querySql;
				queryData(cruConfig.currentPage);;
				
		}
		
/*		document.getElementById("dev_name").value =retObj[0].dev_name;
		document.getElementById("dev_model").value =retObj[0].dev_model;
		document.getElementById("dev_coding").value =retObj[0].dev_coding;
		document.getElementById("self_num").value =retObj[0].self_num;
		document.getElementById("license_num").value =retObj[0].license_num;
		document.getElementById("dev_sign").value =retObj[0].dev_sign;
		document.getElementById("planning_out_time").value =retObj[0].planning_out_time;
		//实际离场时间
		document.getElementById("actual_in_time").value =retObj[0].actual_in_time;
		//验收时间
		document.getElementById("actual_out_date").value =retObj[0].actual_in_time;
		document.getElementById("asset_state").value =retObj[0].stat_desc;
		document.getElementById("dev_position").value =retObj[0].dev_position;
		devaccId = retObj[0].fk_dev_acc_id;
		
		projectInfoNo=retObj[0].project_info_id;
		devicebackappid = retObj[0].device_backapp_id;
		devicemixinfoid = retObj[0].device_mixinfo_id;
	*/	
	}
	function submitInfo(){
	    var id = '<%=request.getParameter("id")%>';
	    if(confirm("确认提交吗？")){
				document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSubmitStock.srq?id="+id+"&devaccId="+devaccId+"&devaccidDui="+'<%=request.getParameter("devaccidDui")%>'+"&projectInfoNo="+projectInfoNo+"&devicebackappid="+devicebackappid+"&devicemixinfoid="+devicemixinfoid;
				document.getElementById("form1").submit();
				document.getElementById("submitButton").onclick = "";
				//newClose();
			}
	}
	
</script>
</html>

