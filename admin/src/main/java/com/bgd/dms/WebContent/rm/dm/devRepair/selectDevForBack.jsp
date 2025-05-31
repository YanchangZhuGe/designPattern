<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants,com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%
String contextPath = request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String projectinfono = request.getParameter("projectinfono");
String out_org_id = request.getParameter("out_org_id");
String backdevtype = request.getParameter("backdevtype");
String repid = request.getParameter("id");
ResourceBundle rb = ResourceBundle.getBundle("devCodeDesc");
String[] backTypeIDs = rb.getString("BackTypeID").split("~", -1);
String backtypewaizu = backTypeIDs[0];
String backtypeziyou = backTypeIDs[1];
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<title>查询送内维修设备页面</title>
</head>

<body style="background: #F1F2F3" onload="refreshData()">
	<div id="list_table">

		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png"
						width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png"><table
							width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="ali_cdn_name">设备名称</td>
								<td class="ali_cdn_input"><input id="s_device_dev_name"
									name="s_device_dev_name" type="text" class="input_width" /></td>
								<td class="ali_cdn_name">实物标识号</td>
								<td class="ali_cdn_input"><input id="s_device_dev_sign"
									name="s_device_dev_sign" type="text" class="input_width" /></td>
								<td class="ali_query"><span class="cx"><a href="#"
										onclick="searchDevData()" title="查询"></a></span></td>
								<td class="ali_query"><span class="qc"><a href="#"
										onclick="clearQueryText()" title="清除"></a></span></td>
								<td>&nbsp;</td>
							</tr>
						</table></td>
					<td width="4"><img src="<%=contextPath%>/images/list_17.png"
						width="4" height="36" /></td>
				</tr>
			</table>
		</div>

		<div id="table_box">
			<table style="width: 98.5%" border="0" cellspacing="0"
				cellpadding="0" class="tab_info" id="queryRetTable">
				<tr id='dev_acc_id_{dev_acc_id}' name='dev_acc_id' idinfo='{dev_acc_id}'>
					<td class="bt_info_odd"
						exp="<input type='checkbox' name='idinfo' value='{dev_acc_id}' id='selectedbox_{dev_acc_id}' />">选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_model}">设备类型</td>
					<td class="bt_info_odd" exp="{dev_model}">规格型号</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
				</tr>
			</table>
		</div>
		<div id="fenye_box" style="display: block">
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				id="fenye_box_table">
				<tr>
					<td align="right">第1/1页，共0条记录</td>
					<td width="10">&nbsp;</td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_01.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_02.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_03.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_04.png"
						width="20" height="20" /></td>
					<td width="50">到 <label> <input type="text"
							name="textfield" id="textfield" style="width: 20px;" />
					</label></td>
					<td align="left"><img
						src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				</tr>
			</table>
		</div>
	</div>
	</div>
	<div id="oper_div">
		<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span> <span
			class="gb_btn"><a href="#" onclick="newClose()"></a></span>
	</div>
</body>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	function refreshData(v_dev_name,v_dev_sign){
		var str = 
			"SELECT T.* FROM GMS_DEVICE_ACCOUNT_B T where 1=1 ";
			if(v_dev_name!=undefined && v_dev_name!=''){//根据送修单号查询
				str += " AND T.dev_name like '%"+v_dev_name+"%' ";
			}
			if(v_dev_sign!=undefined && v_dev_sign!=''){//根据送修单名称查询
				str += " and T.dev_sign like '%"+v_dev_sign+"%' ";
			}
			cruConfig.queryStr = str;
			queryData(cruConfig.currentPage);
	}
	function submitInfo(){
		var length = 0;
		var selectedids = "";
		$("input[type='checkbox'][name='idinfo']").each(function(i){
			if(this.checked == true){
				if(length != 0){
					selectedids += "|"
				}
				selectedids += this.value;
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录!");
			return;
		}
		window.returnValue = selectedids;
		window.close();
	}
	function newClose(){
		window.close();
	}
	$().ready(function(){
		$("#collbackinfo").change(function(){
			var checkvalue = this.checked;
			$("input[type='checkbox'][name='idinfo']").attr('checked',checkvalue);
		});
		
		
	});
	function searchDevData(){
		var v_device_dev_name = document.getElementById("s_device_dev_name").value;
		var v_device_dev_sign = document.getElementById("s_device_dev_sign").value;
		refreshData(v_device_dev_name, v_device_dev_sign);
	}
	function clearQueryText(){
		document.getElementById("s_device_dev_name").value = "";
		document.getElementById("s_device_dev_sign").value = "";
	}
</script>
</html>