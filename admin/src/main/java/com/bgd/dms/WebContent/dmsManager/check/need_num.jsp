<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	String apply_num=request.getParameter("apply_num");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
	<title>需求计划单号</title>
</head>
<body style="background:#cdddef"  >
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
					  			<td class="ali_cdn_name">需求单号：</td>
					  			<td class="ali_cdn_input">
					   				<input id="q_apply_num" name="apply_num" type="text" class="input_width" />
					  			</td>
					  			<td class="ali_cdn_name">需求类型：</td>
					  			<td class="ali_cdn_input">
					   				<select id="q_order_type" name="order_type" class="input_select">
										<option value="">请选择</option>
										<option value="Y006">设备需求计划</option>
										<option value="Y002">物资需求计划</option>
						    		</select>
					  			</td>
								<td class="ali_cdn_name">年度：</td>
				  				<td class="ali_cdn_input">
							   		<input id="q_apply_year" name="apply_year" type="text" class="input_width" style="width:60px;" />
									<%-- <img width="20" height="20" id="cal_button" style="cursor: hand;" onmouseover="yearSelector(q_apply_year,cal_button);" src="<%=contextPath%>/images/calendar.gif" /> --%>
							  	</td>
							  	<td class="ali_cdn_name">所属单位：</td>
					  			<td class="ali_cdn_input">
					   				<input id="q_org_name" name="org_name" type="text" class="input_width" />
					  			</td>
					  			<td class="ali_cdn_name">单据状态：</td>
					  			<td class="ali_cdn_input">
					   				<select id="q_proc_status" name="proc_status" class="input_select">
										<option value="">请选择</option>
										<option value="1">创建</option>
										<option value="2">处理中</option>
										<option value="3">已审批</option>
						    		</select>
					  			</td>
				  				<td class="ali_query">
				   					<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
								</td>
								<td class="ali_query">
							 		<span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
								</td>
								<td>&nbsp;</td>
					  		</tr>
						</table>
					</td>
				   	<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				</tr>
			</table>
		</div>
		<div id="table_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
				<tr>
					<td class="bt_info_odd" exp="<input type='radio' name='selectedbox' value='{apply_num}' id='selectedbox_{apply_num}' />" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td> 
					<td class="bt_info_odd" exp="{apply_num}">需求单号</td>
					<td class="bt_info_even" exp="{order_type_name}">需求类型</td>
					<td class="bt_info_odd" exp="{apply_year}">年度</td>
					<td class="bt_info_even" exp="{org_name}">所属单位</td>
					<td class="bt_info_odd" exp="{employee_name}">填报人</td>
					<td class="bt_info_even" exp="{fill_date}">填报日期</td>
					<td class="bt_info_odd" exp="{proc_status}">单据状态</td>
				</tr>
			</table>
		</div>
		<div id="fenye_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
						</label>
					</td>
					<td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="30" /></td>
				</tr>
			</table>
		<div class="lashen" id="line"></div>		
		</div>
		<div id="oper_div">
			<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
			<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
		</div>
	</div>
</body>
<script type="text/javascript">
	var apply_num = '<%=apply_num%>';
	function frameSize() {
		setTabBoxHeight();
	}
	$(function () {
		frameSize();
		$(window).resize(function () {
			frameSize();
		});
		$("tr").click(function () {
			$(this).find("input[type='radio'][name='selectedbox']").attr("checked", true);
		})
	});
	$(document).ready(lashen);
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "ExePlanSrv";
	cruConfig.queryOp = "queryExePlanList";
	var path = "<%=contextPath%>";
	// 复杂查询
	function refreshData(apply_num, order_type, apply_year, org_name, proc_status) {
		var temp = "";
		if (typeof apply_num != "undefined" && apply_num != "") {
			temp += "&applyNum=" + apply_num;
		}
		if (typeof order_type != "undefined" && order_type != "") {
			temp += "&orderType=" + order_type;
		}
		if (typeof apply_year != "undefined" && apply_year != "") {
			temp += "&applyYear=" + apply_year;
		}
		if (typeof org_name != "undefined" && org_name != "") {
			temp += "&org_name=" + org_name;
		}
		if (typeof proc_status != "undefined" && proc_status != "") {
			temp += "&proc_status=" + proc_status;
		}
		cruConfig.submitStr = temp;
		queryData(1);
	}

	if (apply_num != 'null' && apply_num != "") {
		refreshData(apply_num, "", "", "", "");
	} else {
		refreshData("", "", "", "", "");
	}

	//简单查询
	function simpleSearch() {
		var q_apply_num = $("#q_apply_num").val();
		var q_order_type = $("#q_order_type").val();
		var q_apply_year = $("#q_apply_year").val();
		var q_org_name = $("#q_org_name").val();
		var q_proc_status = $("#q_proc_status").val();
		refreshData(q_apply_num, q_order_type, q_apply_year, q_org_name, q_proc_status);
	}
	//清空查询条件
	function clearQueryText() {
		document.getElementById("q_apply_num").value = "";
		document.getElementById("q_order_type").value = "";
		document.getElementById("q_apply_year").value = "";
		document.getElementById("q_org_name").value = "";
		document.getElementById("q_proc_status").value = "";
		refreshData("", "", "", "", "");
	}

	//清空表格
	function clearCommonInfo() {
		var qTable = getObj('commonInfoTable');
		for (var i = 0; i < qTable.all.length; i++) {
			var obj = qTable.all[i];
			if (obj.name == undefined || obj.name == '') continue;
			if (obj.tagName == "INPUT") {
				if (obj.type == "text") obj.value = "";
			}
		}
	}

	//获取日期
	function getdate() {
		var now = new Date();
		y = now.getFullYear();
		m = now.getMonth() + 1;
		d = now.getDate();
		m = m < 10 ? "0" + m : m;
		d = d < 10 ? "0" + d : d;
		return y + "-" + m + "-" + d;
	}

	//选择年份
	function yearSelector(inputField, tributton) {
		Calendar.setup({
			inputField: inputField,   // id of the input field
			ifFormat: "%Y",       // format of the input field
			align: "Br",
			button: tributton,
			onUpdate: null,
			weekNumbers: false,
			singleClick: true,
			step: 1
		});
	}

	function submitInfo() {
		var obj = document.getElementsByName("selectedbox");
		var count = 0;
		for (var index = 0; index < obj.length; index++) {
			var selectedobj = obj[index];
			if (selectedobj.checked == true) {
				count++;
			}
		}
		if (count == 0) {
			alert("请选择一条记录!");
			return;
		}
		var selectedids = "";
		for (var index = 0; index < obj.length; index++) {
			var selectedobj = obj[index];
			if (selectedobj.checked == true) {
				selectedids += selectedobj.value;
			}
		}
		//返回信息是 队级台账id
		window.returnValue = selectedids;
		window.close();
	}
	function newClose() {
		window.close();
	}
</script>
</html>