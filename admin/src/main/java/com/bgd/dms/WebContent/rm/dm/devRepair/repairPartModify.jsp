<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants,com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%@taglib prefix="devselect" uri="devselect"%>
<%
	String contextPath = request.getContextPath();
	String parent_id = request.getParameter("parent_id");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String id = request.getParameter("id");
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
<title>配件类别添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
	<form name="form1" id="form1" method="post" action="">
		<div id="new_table_box" style="width: 98%">
			<div id="new_table_box_content" style="width: 100%">
				<div id="new_table_box_bg" style="width: 99%">
					<fieldSet style="margin: 2px:padding:2px;">
						<legend>配件类别基本信息</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0"
							class="tab_line_height">
							<tr>
								<td class="inquire_item4">配件分类名称:</td>
								<td class="inquire_form4" colspan="3">
								<input name="part_name"
									id="part_name" class="input_width" type="text" value="" />
								<input name="id"
									id="id" class="input_width" type="hidden" value="" />
								<input name="parent_id"
								id="parent_id" class="input_width" type="hidden" value="" />
								</td>
							</tr>
							<!-- 
							<tr>
								<td class="inquire_item4">生产厂家:</td>
								<td class="inquire_form4" colspan="3">
								<input name="factoryname"
									id="factoryname" class="input_width" type="text" value="" />
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
								<input name="cost_per"
									id="cost_per" class="input_width" type="text" value="" />
								</td>
							</tr>
							 -->
							</table>
					</fieldSet>
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
				</div>
				<div id="oper_div">
					<span class="bc_btn"><a href="#" onclick="submitInfo()"></a></span>
				</div>
			</div>
		</div>
	</form>
</body>
<script type="text/javascript"> 
	function submitInfo(){
		/***************** 数据验证 *****
		var re = /^(?:[1-9][0-9]*(?:\.[0-9]{0,2})?)$/;
		//单价
		var cost_per = $("#cost_per").val();
		if(cost_per!=""&&!re.test(cost_per)){
			alert("单价必须为数字!");
			$("#cost_per").val("");
        	return false;
		}
		***************** 数据验证 *****/
		var count = 0;
		var line_infos;
		var seqinfo;
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/devRepair/repairPartNew.srq?count="+count+"&line_infos="+line_infos+"&seqinfo="+seqinfo;
		document.getElementById("form1").submit();
		afterSubmit();
	}
	$().ready(function(){
		$("#parent_id").val('<%=parent_id%>');
	});
	function refreshData(){
		var sql = "select t.* from GMS_DEVICE_PART_TREE t ";
		sql += " where  t.id = '<%=id%>'";
		var repairQueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql);
		var repairObj = repairQueryRet.datas;
		$("#id").val(repairObj[0].id);
		$("#parent_id").val(repairObj[0].parent_id);
		$("#part_name").val(repairObj[0].part_name);
		$("#factoryname").val(repairObj[0].factoryname);
		$("#unit").val(repairObj[0].unit);
		$("#cost_per").val(repairObj[0].cost_per);
		$("#remark").val(repairObj[0].remark);
		}
	function afterSubmit(){  /*重写，关闭、刷新方法不同*/
		alert("修改成功！");  
		var parentId = $("#parent_id").val();
    	parent.treeFrame.tree.getNodeById(parentId).reload();
		location.href = "../../../blank.html";
}
</script>
</html>

