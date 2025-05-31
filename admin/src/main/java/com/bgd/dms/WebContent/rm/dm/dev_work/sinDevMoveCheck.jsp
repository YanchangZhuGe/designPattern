<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String mixId = request.getParameter("mixId");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
		<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
		<title>单台设备流动变更-编辑</title>
	</head>
	<body class="bgColor_f3f3f3" onload="refreshData();">
		<form name="form1" id="form1" method="post" action="">
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
										<input name="moveapp_no" id="moveapp_no" class="input_width" type="text" readonly />
									</td>
									<td class="inquire_item4"><font color=red>*</font>变更单名称:</td>
									<td class="inquire_form4">
										<input name="moveapp_name" id="moveapp_name" class="input_width" type="text" readonly/>
									</td>
								</tr>
								<tr>
									<td class="inquire_item4"><font color=red>*</font>转出单位:</td>
									<td class="inquire_form4">
										<input name="out_org_name" id="out_org_name" class="input_width" type="text" readonly />
										<input name="out_org_id" id="out_org_id" class="input_width" type="hidden"/>
									</td>
									<td class="inquire_item4"><font color=red>*</font>转入单位:</td>
									<td class="inquire_form4">
										<input name="in_org_name" id="in_org_name" class="input_width" type="text" readonly /> 
										<input name="in_org_id" id="in_org_id" class="input_width" type="hidden" />
									</td>
								</tr>
								<tr></tr>
								<tr>
									<td class="inquire_item4">调剂人</td>
									<td class="inquire_form4">
										<input name="opertor_id" id="opertor_id" class="input_width" type="text" readonly /> 
									</td>
									<td class="inquire_item4"><font color=red>*</font>&nbsp;调剂时间:</td>
									<td class="inquire_form4">
										<input name="apply_date" id="apply_date" class="input_width" type="text" readonly />
									</td>
								</tr>
							</table>
						</fieldset>
						<fieldset style="margin-left: 2px">
							<legend>设备调剂明细</legend>
							<div style="height: 220px; overflow: auto">
								<table style="width: 120.5%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
									<tr>
										<td class="bt_info_even" width="20%">设备名称</td>
										<td class="bt_info_odd" width="20%">规格型号</td>
										<td class="bt_info_even" width="20%">自编号</td>
										<td class="bt_info_odd" width="20%">牌照号</td>
										<td class="bt_info_even" width="20%">实物标识号</td>
									</tr>
									<tbody id="processtable0" name="processtable0">
									</tbody>
								</table>
							</div>
						</fieldset>
					</div>
					<div id="oper_div">
						<span class="js_btn"><a href="#" onclick="submitInfo('ys')"></a></span>
        				<span class="th_btn"><a href="#" onclick="submitInfo('th')"></a></span>
					</div>
				</div>
			</div>
		</form>
	</body>
<script type="text/javascript">
	function submitInfo(info){
		if(confirm("是否提交?")){
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/updateMoveappDetailInfo.srq?info="+info;
			document.getElementById("form1").submit();
		}	
	}
	var mixId='<%=mixId%>';
	function refreshData(){
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
			for (var i=0; i< baseData.datas.length; i++) {
				tr_id=$("#processtable0 tr").length;
				var innerhtml = "<tr>";
				innerhtml += "<input name='out_dev_id_"+tr_id+"' type='hidden' value='"+baseData.datas[i].dev_acc_id+"'/>";
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
	
</script>
</html>

