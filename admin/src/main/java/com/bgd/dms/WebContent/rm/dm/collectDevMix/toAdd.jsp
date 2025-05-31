<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
String contextPath = request.getContextPath();
%>
<!DOCTYPE>
<html>
	<head>
		<title>采集设备台账明细</title>
		<meta charset="UTF-8" />
		<!--[if lt IE 9]>
    		<script src="<%=contextPath%>/js/html5.js"></script>
<![endif]-->
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" />
		<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
			rel="stylesheet" />
		<link rel="stylesheet" href="<%=contextPath%>/css/cn/style.css" />
		<link href="<%=contextPath%>/css/common.css" rel="stylesheet" />
		<link href="<%=contextPath%>/css/main.css" rel="stylesheet" />
		<link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" />
		<link rel="stylesheet"
			href="<%=contextPath%>/skin/cute/style/style.css" />
		<link rel="stylesheet" media="all"
			href="<%=contextPath%>/css/calendar-blue.css" />
		<link rel="stylesheet"
			href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" />
		<link rel="stylesheet"
			href="<%=contextPath%>/js/extjs/resources/css/ext-all.css">
		<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
	</head>
	<body class="bgColor_f3f3f3" onload="pageInit()">
		<form name="form1" id="form1" method="post" action="">
			<input type="hidden" id="detail_count" value="" />
			<div id="new_table_box">
				<div id="new_table_box_content">
					<div id="new_table_box_bg">
						<fieldset>
							<legend>
								采集设备调配单
							</legend>
							<table id="table1" width="100%" border="0" cellspacing="0"
								cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item6">
										计划申请单名称
									</td>
									<td class="inquire_form6">
										<input id="device_allapp_name" name="device_allapp_name" readonly="readonly"
											class="input_width" type="text" />
									</td>
									<td class="inquire_item6">
										计划申请单单号
									</td>
									<td class="inquire_form6">
										<input id="device_allapp_no" readonly="readonly" name="device_allapp_no" class="input_width" type="text" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">
										调配申请单名称
									</td>
									<td class="inquire_form6">
										<input id="device_app_name" name="device_app_name" readonly="readonly"
											class="input_width" type="text" />
										<img id="show-btn" src="<%=contextPath%>/images/magnifier.gif"
											width="16" height="16" style="cursor:hand;"
											onclick="showCollMixPlanList()" />
										<input id="device_app_id" name="device_app_id" class="" type="hidden" />
									</td>
									<td class="inquire_item6">
										调配申请单单号
									</td>
									<td class="inquire_form6">
										<input id="device_app_no" readonly="readonly" name="device_app_no" class="input_width" type="text" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">
										项目名称
									</td>
									<td class="inquire_form6">
											<input id="project_name" readonly="readonly" name="project_name"
												class="input_width" type="text" />
											<input id="project_info_no" name="project_info_no" class="" type="hidden" />
									</td>
									<td class="inquire_item6">
										申请人
									</td>
									<td class="inquire_form6">
										<input id="employee_name" name="employee_name" readonly="readonly"
											class="input_width" type="text" />
										<input id="employee_id" name="employee_id" class="" type="hidden" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item6">
										转入单位
									</td>
									<td class="inquire_form6">
										<input id="org_name" name=org_name readonly="readonly"
											class="input_width" type="text" />
										<input id="org_id" name="org_id" class="" type="hidden" />
									</td>
									<td class="inquire_item6">
										转出单位
									</td>
									<td class="inquire_form6">
										<input id="out_org_name" name="out_org_name" readonly="readonly"
											class="input_width" type="text" />
										<img id="show-btn" src="<%=contextPath%>/images/magnifier.gif"
											width="16" height="16" style="cursor:hand;"
											onclick="showOrgTreePage('out_org')" />
										<input id="out_org_id" name="out_org_id" class="" type="hidden" />
									</td>
								</tr>
								<tr>
								<td class="inquire_item6">
										调配单单号
									</td>
									<td class="inquire_form6">
										<input id="mixinfo_no" name="mixinfo_no" 
											class="input_width" type="text" value="保存后自动生成..." readonly/>
										<input id="org_subjection_id" name="org_subjection_id" 
											class="input_width" type="hidden"  />
									</td>
								</tr>
							</table>
						</fieldset>
					</div>
					<div id="oper_div">
						<span class="bc_btn"><a href="#" onclick="submitInfo()"></a>
						</span>
						<span class="gb_btn"><a href="#" onclick="newClose()"></a>
						</span>
					</div>
				</div>
			</div>
		</form>
		<script src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
		<script src="<%=contextPath%>/js/table.js"></script>
		<script src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script>
		<script src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script>
		<script src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script>
		<script src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
		<script src="<%=contextPath%>/js/calendar.js"></script>
		<script src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
		<script src="<%=contextPath%>/js/calendar-setup.js"></script>
		<script src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script src="<%=contextPath%>/js/rt/rt_cru.js"></script>
		<script src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
		<script src="<%=contextPath%>/js/rt/proc_base.js"></script>
		<script src="<%=contextPath%>/js/rt/fujian.js"></script>
		<script src="<%=contextPath%>/js/rt/rt_validate.js"></script>
		<script src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
		<script src="<%=contextPath%>/js/rt/rt_edit.js"></script>
		<script src="<%=contextPath%>/js/json2.js"></script>
		<script src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
		<script src="<%=contextPath%>/js/gms_list.js"></script>
		<script src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
		<script src="<%=contextPath%>/js/extjs/ext-all-debug.js"></script>
		<script src="<%=contextPath%>/js/extjs/ext-lang-zh_CN.js"></script>
		<script src="<%=contextPath%>/js/dialog_open1.js"></script>
<script>
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
				if(this.checked == true){
					var selected_id = this.id;
					$('#tr'+selected_id).remove();
				}
			});
		});
		
	});
	function showCollMixPlanList(){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/collectDevMix/collMixPlanSelectList.jsp","test","dialogHeight:600px;dialogWidth:1000px");
		for(var i in returnValue){
			$("#"+i).val(returnValue[i]);
		}
	}
	function pageInit(){
	}
	/**
	 * 选择组织机构树
	 */
	function showOrgTreePage(str){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
		var strs= new Array(); //定义一数组
		if(!returnValue){
			return;
		}
		strs=returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		document.getElementById(str+"_name").value = names[1];
		
		var orgId = strs[1].split(":");
		document.getElementById(str+"_id").value = orgId[1];
	}
	/**
	 * 提交
	 */
	function submitInfo(){
		if(document.getElementById("out_org_name").value==""){
			alert("请选择转出单位");
			return false;
		}
		if(document.getElementById("device_app_name").value==""){
			alert("请选择调配申请单");
			return false;
		}
		document.getElementById("mixinfo_no").value=="";
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/collectTree/saveCollectDevMixForm.srq";
		document.getElementById("form1").submit();
	}
</script>
	</body>
</html>

