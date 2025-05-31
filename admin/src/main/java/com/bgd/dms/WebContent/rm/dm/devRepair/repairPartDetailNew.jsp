<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants,com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%@taglib prefix="devselect" uri="devselect"%>
<%
	String contextPath = request.getContextPath();
	String tree_id = request.getParameter("paraid");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
	String userName = user.getUserName();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link rel="stylesheet" type="text/css" media="all"
	href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>配件添加界面</title>
</head>
<body class="bgColor_f3f3f3">
	<form name="form1" id="form1" method="post" action="">
		<div id="new_table_box" style="width: 98%">
			<div id="new_table_box_content" style="width: 100%">
				<div id="new_table_box_bg" style="width: 99%">
					<fieldset style="margin: 2px:padding:2px;">
						<legend>配件基本信息</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0"
							class="tab_line_height">
							<tr>
								<td class="inquire_item4">配件名称:</td>
								<td class="inquire_form4" colspan="3">
								<input name="item_name"
									id="item_name" class="input_width" type="text" value="" />
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">批次号:</td>
								<td class="inquire_form4" colspan="3">
								<input name="orderno"
									id="orderno" class="input_width" type="text" value="" />
								<input name="tree_id"
								id="tree_id" class="input_width" type="hidden" value="" />
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">供应商名称:</td>
								<td class="inquire_form4" colspan="3">
								<input name="supplyname"
									id="supplyname" class="input_width" type="text" value="" />
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">生产厂家:</td>
								<td class="inquire_form4" colspan="3">
								<input name="factoryname"
									id="factoryname" class="input_width" type="text" value="" />
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">币种:</td>
								<td class="inquire_form4" colspan="3">
								<devselect:combolist name='currery'
											id='currery' selectdefaultV='true' selectedValue='0'
											typeKey='currency'></devselect:combolist>
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">计量单位:</td>
								<td class="inquire_form4" colspan="3">
								<input name="unit"
									id="unit" class="input_width" type="text" value="" />
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">单价:</td>
								<td class="inquire_form4" colspan="3">
								<input name="perprice"
									id="perprice" class="input_width" type="text" value="" />
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">品牌:</td>
								<td class="inquire_form4" colspan="3">
								<input name="brand"
									id="brand" class="input_width" type="text" value="" />
								</td>
							</tr>
							<tr>
								<td class="inquire_item4">规格:</td>
								<td class="inquire_form4" colspan="3">
								<input name="part_model"
									id="part_model" class="input_width" type="text" value="" />
								</td>
							</tr>
							</table>
					</fieldset>
					<!-- 
					<fieldset>
						<legend>备注</legend>
						<table id="table2" width="100%" border="0" cellspacing="0"
							cellpadding="0" class="tab_line_height">
							<tr>
								<td align="center"><textarea id='remark' name='remark' rows="5" cols="60"></textarea>
								</td>
							</tr>
						</table>
					</fieldset>
					 -->
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
	$().ready(function(){
		$("#tree_id").val('<%=tree_id%>');
	});
	function submitInfo(){
		/***************** 数据验证 *****/
		var re = /^(?:[1-9][0-9]*(?:\.[0-9]{0,2})?)$/;
		//单价
		var perprice = $("#perprice").val();
		if(perprice!=""&&!re.test(perprice)){
			alert("单价必须为数字!");
			$("#perprice").val("");
        	return false;
		}
		/***************** 数据验证 *****/
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/devRepair/repairPartDetailNew.srq";
		document.getElementById("form1").submit();
		var ctt = parent.frames['list'];
		alert('保存成功！');
		ctt.menuFrame.refreshData();
		newClose();
	};
	/*****
	function afterSubmit(){   
			alert("保存成功！");  
			var tree_id = $("#tree_id").val();
	    	parent.treeFrame.tree.getNodeById(tree_id).reload();
			location.href = "../../../blank.html";
	}
	******/
</script>
</html>

