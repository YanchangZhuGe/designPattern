<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getEmpId();
	String org_id = user.getOrgId();
	String org_subjection_id = user.getSubOrgIDofAffordOrg();
	String userName = user.getUserName();
	String mixId = request.getParameter("mixId");
	String flag = request.getParameter("flag");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
		<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
		<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
		<title>单台设备流动变更-编辑</title>
	</head>
	<body class="bgColor_f3f3f3" onload="refreshData();">
		<form name="form1" id="form1" method="post" action="">
			<input type='hidden' name='selected_dev_ids' id='selected_dev_ids' /> 
			<input type='hidden' name='moveapp_id' id='moveapp_id' value="<%=mixId%>" />
			<div id="new_table_box" style="width: 98%">
				<div id="new_table_box_content" style="width: 100%">
					<div id="new_table_box_bg" style="width: 95%">
						<fieldset style="margin-left: 2px">
							<legend>变更申请基本信息</legend>
							<table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item4">变更单号:</td>
									<td class="inquire_form4">
										<input name="moveapp_no" id="moveapp_no" class="input_width" type="text" value="保存后自动生成..." readonly />
									</td>
									<td class="inquire_item4"><font color=red>*</font>变更单名称:</td>
									<td class="inquire_form4">
										<input name="moveapp_name" id="moveapp_name" class="input_width" type="text" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item4"><font color=red>*</font>转出单位:</td>
									<td class="inquire_form4">
										<input name="out_org_name" id="out_org_name" class="input_width" type="text" value="<%=user.getOrgName()%>" readonly />
										<img id="show-btn" src="/gms4/images/magnifier.gif" width="16" height="16" style="cursor: hand;" onclick="showOrgTreePage('out_org')" />
										<input name="out_org_id" id="out_org_id" class="input_width" type="hidden" value="<%=org_subjection_id%>" />
									</td>
									<td class="inquire_item4"><font color=red>*</font>转入单位:</td>
									<td class="inquire_form4">
										<input name="in_org_name" id="in_org_name" class="input_width" type="text" readonly />
										<img id="show-btn" src="/gms4/images/magnifier.gif" width="16" height="16" style="cursor: hand;" onclick="showOrgTreePage('in_org')" /> 
										<input name="in_org_id" id="in_org_id" class="input_width" type="hidden" />
									</td>
								</tr>
								<tr></tr>
								<tr>
									<td class="inquire_item4">调剂人</td>
									<td class="inquire_form4">
										<input name="opertor_id" id="opertor_id" class="input_width" type="text" value="<%=user.getUserName()%>" readonly /> 
									</td>
									<td class="inquire_item4"><font color=red>*</font>&nbsp;调剂时间:</td>
									<td class="inquire_form4">
										<input name="apply_date" id="apply_date" class="input_width" type="text" readonly />
										<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(apply_date,tributton2);" />
									</td>
								</tr>
							</table>
						</fieldset>
						<div style="overflow: auto">
							<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
								<tr align="right">
									<td style="width: 90%"></td>
									<td width="5%">
										<span class="zj">
											<a href="#" id="addaddedbtn" onclick='toAddDevInfo()' title="添加"></a>
										</span>
									</td>
									<td width="5%">
										<span class="sc">
											<a href="#" id="deladdedbtn" onclick='toDeleteDevInfo()' title="删除"></a>
										</span>
									</td>
									<td style="width: 1%"></td>
								</tr>
							</table>
						</div>
						<fieldSet style="margin-left: 2px">
							<legend>设备调剂明细</legend>
							<div style="height: 220px; overflow: auto">
								<table style="width: 120.5%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
									<tr>
										<td class="bt_info_odd" width="4%"><input type='checkbox' id='check_entity_id' name='rdo_entity_name' onclick='check()' /></td>
										<td class="bt_info_even" width="20%">设备名称</td>
										<td class="bt_info_odd" width="20%">规格型号</td>
										<td class="bt_info_even" width="18%">自编号</td>
										<td class="bt_info_odd" width="18%">牌照号</td>
										<td class="bt_info_even" width="20%">实物标识号</td>
									</tr>
									<tbody id="processtable0" name="processtable0">
									</tbody>
								</table>
							</div>
						</fieldSet>
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
	var flag="<%=flag%>";
	function submitInfo(){
		var in_org_id=$("#in_org_id").val();
		var out_org_id=$("#out_org_id").val();
		var moveapp_name=$("#moveapp_name").val();
		var apply_date=$("#apply_date").val();
		if( in_org_id==""||moveapp_name==""||apply_date==""||out_org_id==""){
			alert("请录入变更申请基本信息！");
			return;
		}
		//保留的行信息
		var count = 0;
		count=$("#processtable0").children().size();
		if(count == 0){
			alert('请录入变更设备信息！');
			return;
		}
		$("#moveapp_no").val("");
		if(confirm("是否提交?")){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/saveOrUpdateSinDevMoveInfo.srq?flag="+flag;
			document.getElementById("form1").submit();
		}
	}
	var mixId='<%=mixId%>';
	function refreshData(){
		if("update"==flag){
			var baseData;
		    baseData = jcdpCallService("DevProSrv", "getSinDevMoveInfo", "mixId="+mixId);
			if(baseData.devMap!=null){
				document.getElementById("moveapp_no").value=baseData.devMap.moveapp_no ;
				document.getElementById("moveapp_name").value=baseData.devMap.moveapp_name ;
				document.getElementById("in_org_name").value=baseData.devMap.inorgname;
				document.getElementById("in_org_id").value=baseData.devMap.in_org_id;
				document.getElementById("out_org_name").value=baseData.devMap.outorgname;
				document.getElementById("out_org_id").value=baseData.devMap.out_org_id;
				document.getElementById("apply_date").value=baseData.devMap.apply_date;
				document.getElementById("opertor_id").value=baseData.devMap.opertor_id;
			}
			if(baseData.datas!=null){
				//通过查询结果动态填充使用情况select;
				for (var i=0; i< baseData.datas.length; i++) {
					tr_id = $("#processtable0 tr").length;
					var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
					innerhtml += "<input name='out_dev_id_"+tr_id+"' type='hidden' value='"+baseData.datas[i].dev_acc_id+"'/>";
					innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
					innerhtml += "<td>"+baseData.datas[i].dev_name+"</td>";
					innerhtml += "<td>"+baseData.datas[i].dev_model+"</td>";
					innerhtml += "<td>"+baseData.datas[i].self_num+"</td>";
					innerhtml += "<td>"+baseData.datas[i].license_num+"</td>";
					innerhtml += "<td>"+baseData.datas[i].dev_sign+"</td></tr>";
					$("#processtable0").append(innerhtml);
				}
				$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
				$("#processtable0>tr:odd>td:even").addClass("odd_even");
				$("#processtable0>tr:even>td:odd").addClass("even_odd");
				$("#processtable0>tr:even>td:even").addClass("even_even");
			}
		}
	}
	/**
	 * 选择组织机构树
	 */
	function showOrgTreePage(str){
		var returnValue;
		if(str=="out_org"){
			returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
		}
		else{
		 	returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?orgId=C6000000000007","test","");
		}
		var strs= new Array(); //定义一数组
		if(!returnValue){
			return;
		}
		strs=returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		document.getElementById(str+"_name").value = names[1];
		var orgSubId = strs[2].split(":");
		document.getElementById(str+"_id").value = orgSubId[1];
		if(str=="out_org"){
			$("#processtable0").empty();
		}
	}
	
	
	function toAddDevInfo(){
		var out_org_id=document.getElementById("out_org_id").value;
		if(out_org_id==""){
			alert("请选择转出单位!");
			return;
		}
		var selected_dev_ids=document.getElementById("selected_dev_ids").value;
		var selected = window.showModalDialog("<%=contextPath%>/rm/dm/dev_work/selectSingleAccForMove.jsp?out_org_id="+ out_org_id+"&selectId="+selected_dev_ids,"","dialogWidth=1240px;dialogHeight=480px");
		document.getElementById("selected_dev_ids").value = selected;
		if (selected != null && selected != "") {
			addLine();
		}
	}

	function addLine() {
		var selected_dev_ids = document.getElementById("selected_dev_ids").value;
		var baseData;
		baseData = jcdpCallService("DevProSrv", "getSinDevInfo", "ids="+ selected_dev_ids);
		if (baseData.datas != null) {
			for ( var i = 0; i < baseData.datas.length; i++) {
				tr_id = $("#processtable0 tr").length;
				var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
				innerhtml += "<input name='out_dev_id_"+tr_id+"' type='hidden' value='"+baseData.datas[i].dev_acc_id+"'/>";
				innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
				innerhtml += "<td>"+baseData.datas[i].dev_name+"</td>";
				innerhtml += "<td>"+baseData.datas[i].dev_model+"</td>";
				innerhtml += "<td>"+baseData.datas[i].self_num+"</td>";
				innerhtml += "<td>"+baseData.datas[i].license_num+"</td>";
				innerhtml += "<td>"+baseData.datas[i].dev_sign+"</td></tr>";
				$("#processtable0").append(innerhtml);
			}
			$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable0>tr:odd>td:even").addClass("odd_even");
			$("#processtable0>tr:even>td:odd").addClass("even_odd");
			$("#processtable0>tr:even>td:even").addClass("even_even");
		}

	}
	function toDeleteDevInfo() {
		$("input[name='idinfo']").each(function() {
			if (this.checked == true) {
				$('#tr' + this.id, "#processtable0").remove();
			}
		});
		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
	}
	var checked = false;
	function check(){
 		var chk = document.getElementsByName("idinfo");
 		for(var i = 0; i < chk.length; i++){ 
 	 		
	 			if(!checked){ 
	 				chk[i].checked = true; 
	 			}
	 			else{
	 				chk[i].checked = false;
	 			}
	 		} 
	 		if(checked){
	 			checked = false;
	 		}
	 		else{
	 			checked = true;
	 		}
 		
 	}
</script>
</html>

