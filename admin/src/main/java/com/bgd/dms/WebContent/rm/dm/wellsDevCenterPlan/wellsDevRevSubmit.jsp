<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();

	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getOrgId();
	String orgSubId = user.getOrgSubjectionId();
	String orgOfSubId = user.getSubOrgIDofAffordOrg();
	String id = request.getParameter("id");
	String mixId = request.getParameter("mixId");
	String mixTypeId = request.getParameter("mixTypeId");
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
  <link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
  <link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
  <link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
  <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/json2.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>  
<title>多项目-井中设备分中心-设备接收-接收子页面 -设备接收明细</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData()">
<form name="form1" id="form1" method="post" action="">
<input type="hidden" id="detail_count" value="" />
<input type="hidden" id="device_mix_detid" name="device_mix_detid"></input>
<input id="mixId" name="mixId"  class="input_width" type="hidden" value="<%=mixId%>" />
<input id="mix_type_id" name="mix_type_id"  class="input_width" type="hidden" value="<%=mixTypeId%>" />
<input type="hidden" id="projectcountry" name="projectcountry"></input>
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	    <fieldset style="margin-left:2px"><legend>接收确认信息</legend>
	      <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	      <tr style="display:none" id="inCountry">
			  	<td class="inquire_item4">存放地(省份+库房)</td>
				<td class="inquire_form4" colspan="3">
				<select id="province_in" name="province_in" class="select_width" style="width: 30%;"> 
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
				<input id="dev_position_in" name="dev_position_in" class="input_width" type="text" style="width: 60%; float: none;margin-bottom: 7px;height:20px;line-height:20px;"/>
				</td>
			</tr>
			<tr style="display:none" id="outCountry">
			  	<td class="inquire_item4">存放地(省份+库房)</td>
				<td class="inquire_form4" colspan="3">
				<input id="province_out" name="province_out" class="input_width" type="text" style="width: 30%; float: none;margin-bottom: 7px;height:20px;line-height:20px;"/>		
				<input id="dev_position_out" name="dev_position_out" class="input_width" type="text" style="width: 60%; float: none;margin-bottom: 7px;height:20px;line-height:20px;"/>
				</td>
			</tr>
			<input id="province" name="province" class="input_width" type="hidden" style="width: 60%; float: none;margin-bottom: 7px;height:20px;line-height:20px;"/>
			<input id="dev_position" name="dev_position" class="input_width" type="hidden" style="width: 60%; float: none;margin-bottom: 7px;height:20px;line-height:20px;"/>
	      	<tr>
				<td class="inquire_item4">实际进场时间</td>
				<td class="inquire_form4">
					<input type="text" name="actual_start_date" id="actual_start_date" value="" readonly="readonly" class="input_width" style="height:20px;line-height:20px;"/>
					<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(actual_start_date,tributton1);" />
				</td>
			</tr>
		  </table>
	    </fieldset> 
      	<fieldset style="margin-left:2px"><legend></legend>
      	<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_mix_detid_{device_mix_detid}' name='device_mix_detid'>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_model}">规格型号</td>
					<td class="bt_info_odd" exp="{dev_unit}">计量单位</td>
					<td class="bt_info_even" exp="{self_num}">自编号</td>
					<td class="bt_info_odd" exp="{license_num}">牌照号</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_even" exp="{dev_plan_start_date}">计划进场时间</td>
					<td class="bt_info_odd" exp="{dev_plan_end_date}">计划离场时间</td>
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

	function refreshData(){
		var device_mix_detid = '<%=id%>';

		document.getElementById("device_mix_detid").value = device_mix_detid;
		var temp = device_mix_detid.split(",");
		var idss = "";
		
		$("#inCountry").css("display","none");
		$("#outCountry").css("display","none");
		
	    var querySql = "select rownum,t.dev_position,t.project_country from (select pro.project_country,dm.project_info_no,da.dev_name,da.dev_model,";
	    	querySql += "da.dev_position,dam.assign_num,da.modifi_date,dad.device_mix_detid from gms_device_mixinfo_form dm ";
	    	querySql += "left join gms_device_appmix_main dam on dm.device_mixinfo_id = dam.device_mixinfo_id ";
	    	querySql += "left join gms_device_appmix_detail dad on dam.device_mix_subid = dad.device_mix_subid ";
	    	querySql += "left join gp_task_project pro on dm.project_info_no = pro.project_info_no ";
	    	querySql += "left join gms_device_account da on dad.dev_acc_id = da.dev_acc_id where dm.device_mixinfo_id in "
	    	querySql += "(select dm.device_mixinfo_id from gms_device_mixinfo_form dm ";
	    	querySql += "left join gms_device_appmix_main dam on dm.device_mixinfo_id = dam.device_mixinfo_id ";
	    	querySql += "left join gms_device_appmix_detail dad  on dam.device_mix_subid = dad.device_mix_subid ";
	    	querySql += "where dad.device_mix_detid ='"+temp[0]+"') order by da.modifi_date desc ) t where rownum=1 ";				 	 
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			var datas = queryRet.datas;
			if(datas != null && datas != ""){		 
				var selectName=datas[0].dev_position;
				var inOutCountry=datas[0].project_country;
				document.getElementById("projectcountry").value =inOutCountry;
				var tempa = selectName.split('-');	
					document.getElementsByName("province")[0].value= tempa[0];
				if(tempa[1] == undefined){
					document.getElementsByName("dev_position")[0].value="";
				}else{
				 	document.getElementsByName("dev_position")[0].value= tempa[1];
				}
				
				if(inOutCountry == '2'){//国外项目
					$("#outCountry").css("display","block");
				}else{
					$("#inCountry").css("display","block");
				}
			}			
		}
		
		if(device_mix_detid!=null){
		    var querysql="select plan.maintenance_cycle,mif.project_info_no,dad.*,";
		    	querysql+="da.dev_name,da.dev_model,unit.coding_name as dev_unit,da.dev_position,teamid.coding_name as team_name,mif.in_org_id,mif.out_org_id ";
		    	querysql+="from gms_device_appmix_detail dad ";
				querysql+="left join gms_device_appmix_main dam on dam.device_mix_subid =dad.device_mix_subid ";
				querysql+="left join gms_device_mixinfo_form mif on mif.device_mixinfo_id =dam.device_mixinfo_id ";
				querysql+="left join gms_device_account da on dad.dev_acc_id = da.dev_acc_id ";
				querysql+="left join gms_device_maintenance_plan plan on da.dev_acc_id = plan.dev_acc_id ";
				querysql+="left join comm_coding_sort_detail teamid on dad.team=teamid.coding_code_id ";
				querysql+="left join comm_coding_sort_detail unit on da.dev_unit=unit.coding_code_id ";
				querysql+="where dad.device_mix_detid in (";
				
				for(var i=0;i<temp.length;i++){
					if(idss!="") idss += ",";
					idss += "'"+temp[i]+"'";
				}
				querysql = querysql+idss+")";
				cruConfig.queryStr = querysql;
				queryData(cruConfig.currentPage);
		}
	}
	function submitInfo(){		
	    var id = '<%=request.getParameter("id")%>';
		var inOutCountry = document.getElementById("projectcountry").value;    
	    
	    if(inOutCountry == '2'){//井中国外项目
	    	var province_out = document.getElementById("province_out").value;
		    var dev_position_out = document.getElementById("dev_position_out").value;
		    
	    	document.getElementById("province").value = province_out;
	    	document.getElementById("dev_position").value = dev_position_out;
		}else{
			var province_in = document.getElementById("province_in").value;	    
		    var dev_position_in = document.getElementById("dev_position_in").value;
		    
			document.getElementById("province").value = province_in;
			document.getElementById("dev_position").value = dev_position_in;
		}
		if(confirm("确认提交？")){
	    	document.getElementById("submitButton").onclick = "";
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSubmitWellsReceive.srq?id="+id+"&devaccId="+devaccId;
			document.getElementById("form1").submit();
		}
	}
</script>
</html>

