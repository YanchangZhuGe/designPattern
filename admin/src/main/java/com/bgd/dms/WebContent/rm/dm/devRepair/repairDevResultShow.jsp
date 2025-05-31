<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants,com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%@taglib prefix="devselect" uri="devselect"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	String id = request.getParameter("id");
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
<title>设备送修接收界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
	<form name="form1" id="form1" method="post" action="">
		<div id="new_table_box" style="width: 98%">
			<div id="new_table_box_content" style="width: 100%">
				<div id="new_table_box_bg" style="width: 95%">
					<fieldSet style="margin: 2px:padding:2px;">
						<legend>送修设备基本信息</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0"
							class="tab_line_height" name="projectMap" id="projectMap">
							<!-- 
							<tr>
								<td class="inquire_item4">送修单号:</td>
								<td class="inquire_form4" colspan="3"><input
									id="repair_form_code" class="input_width" type="text" value=""
									disabled name="repair_form_code" /></td>
							</tr>
							<tr>
								<td class="inquire_item4">送修单名称:</td>
								<td class="inquire_form4"><input id="repair_form_name"
									class="input_width" type="text" value="" disabled
									name="repair_form_name" /> <input name="id" id="id"
									class="input_width" type="hidden" value="" /></td>
								<td class="inquire_item4">所属项目:</td>
								<td class="inquire_form4"><input id="project_name"
									class="input_width" type="text" value="" disabled
									name="project_name" /></td>
							</tr>
							<tr>
								<td class="inquire_item4">送修单位:</td>
								<td class="inquire_form4"><input id="req_comp_name"
									class="input_width" type="text" value="" disabled
									name="req_comp_name" /></td>
								<td class="inquire_item4">维修单位:</td>
								<td class="inquire_form4"><input id="todo_comp_name"
									class="input_width" type="text" value="" disabled
									name="todo_comp_name" /></td>
							</tr>
							 -->
							<tr>
								<td class="inquire_item4">设备名称:</td>
								<td class="inquire_form4" colspan="1"><input id="dev_name"
									class="input_width" type="text" value="" disabled
									name="dev_name" /></td>
								<td class="inquire_item4">规格型号:</td>
								<td class="inquire_form4" colspan="1"><input id="dev_model"
									class="input_width" type="text" value="" disabled
									name="dev_model" /></td>
							</tr>
							<tr>
								<td class="inquire_item4">实物标识号:</td>
								<td class="inquire_form4"><input id="dev_sign"
									class="input_width" type="text" value="" disabled
									name="dev_sign" /></td>
								<td class="inquire_item4">派工人:</td>
								<td class="inquire_form4" colspan="1"><input
									id="dispath_user_name" class="input_width" type="text" value=""
									disabled name="dispath_user_name" /></td>
							</tr>
							<tr>
								<td class="inquire_item4">派工日期:</td>
								<td class="inquire_form4"><input id="dispath_date"
									class="input_width" type="text" value="" disabled
									name="dispath_date" /></td>
								<td class="inquire_item4">维修班组:</td>
								<td class="inquire_form4" colspan="1"><input
									id="repair_team" class="input_width" type="text" value=""
									disabled name="repair_team" /></td>
							</tr>
							<tr>
								<td class="inquire_item4">维修结束时间:</td>
								<td class="inquire_form4"><input name="repair_end_time"
									id="repair_end_time" class="input_width" type="text" value=""
									disabled /></td>
								<td class="inquire_item4">维修状态:</td>
								<td class="inquire_form4" colspan="1">
								<input
									id="assign_status" class="input_width" type="text" value=""
									disabled name="assign_status" />
									 </td>
							</tr>
						</table>
					</fieldSet>
					<fieldset>
						<legend>维修内容及结果</legend>
						<table id="table2" width="100%" border="0" cellspacing="0"
							cellpadding="0" class="tab_line_height">
							<tr>
								<td><textarea id='resultDesc' name='resultDesc' rows="5"
										cols="80" disabled></textarea></td>
							</tr>
						</table>
					</fieldset>
					<fieldSet style="margin-left: 2px">
						<legend>配件信息明细</legend>
						<div style="overflow: auto">
							<table style="width: 97.9%" border="0" cellspacing="0"
								cellpadding="0" class="tab_line_height">
								<tr>
									<td width="8%" class="bt_info_even">配件分类名称</td>
									<td width="8%" class="bt_info_even" >配件名称</td>
									<td width="8%" class="bt_info_odd" >批次号</td>
									<td width="8%" class="bt_info_odd" >规格</td>
									<td width="8%" class="bt_info_odd" >品牌</td>
									<td width="8%" class="bt_info_odd" >供应商名称</td>
									<td width="8%" class="bt_info_odd" >生产厂家</td>
									<td width="8%" class="bt_info_odd" >币种</td>
									<td width="8%" class="bt_info_even" >计量单位</td>
									<td width="8%" class="bt_info_odd" >单价</td>
								</tr>
							</table>
							<div style="height: 190px; overflow: auto;">
								<table style="width: 97.9%" border="0" cellspacing="0"
									cellpadding="0" class="tab_line_height">
									<tbody id="detaillist" name="detaillist">
									</tbody>
								</table>
							</div>
						</div>
					</fieldSet>
				</div>
				<div id="oper_div">
					 <span class="gb_btn"><a
						href="#" onclick="newClose()"></a></span>
				</div>
			</div>
		</div>
	</form>
</body>
<script type="text/javascript"> 
	function refreshData(){
		var sql = "SELECT REP.*,\n" +
		"       EMP.EMPLOYEE_NAME AS CREATOR_NAME,\n" + 
		"       PRO.PROJECT_NAME,\n" + 
		"       REQORG.ORG_ABBREVIATION AS REQ_COMP_NAME,\n" + 
		"       TODOORG.ORG_ABBREVIATION AS TODO_COMP_NAME,\n" + 
		"       DECODE(REP.STATUS, 0, '编制', 1, '生效' ，2, '作废', '无效状态') AS STATUS_DESC， DECODE(NVL(REC.REC_STATUS, 0), 0, '待接收', 1, '接收完成', 2, '拒接收') AS REC_STATUS_DESC,\n" + 
		"       ACC.DEV_NAME AS DEV_NAME,\n" + 
		"       ACC.DEV_TYPE AS DEV_TYPE,\n" + 
		"       ACC.DEV_MODEL AS DEV_MODEL,\n" + 
		"       DECODE(SUB.ERROR_TYPE, <%=DevUtil.getDecodeStr(DevConstants.DECODE_KEY_ERRORTYPE)%>) AS ERROR_TYPE,\n" + 
		"       DECODE(SUB.ERROR_DESC,\n" + 
		"       <%=DevUtil.getDecodeStr(DevConstants.DECODE_KEY_ERRORDESC)%>) AS ERROR_DESC,\n" + 
		"       ACC.DEV_SIGN AS DEV_SIGN,\n" + 
		"       DECODE(SUB.DEV_STATUS,\n" + 
		"       <%=DevUtil.getDecodeStr(DevConstants.DECODE_KEY_DEVSTATUS)%>) AS DEV_STATUS,\n" + 
		"       SUB.REMARK AS SUBREMARK,\n" + 
		"       DECODE(AGN.REPAIRSTATE,\n" + 
		"       <%=DevUtil.getDecodeStr(DevConstants.DECODE_KEY_REPAIRSTATUS)%>) AS ASSIGN_STATUS,\n" + 
		"       AGN.DISPATH_USER AS DISPATH_USER,\n" + 
		"       AGN.DISPATH_DATE AS DISPATH_DATE,\n" + 
		"       AGN.ID AS DISPATCH_ID,\n" + 
		"       AGN.REPAIR_END_TIME AS REPAIR_END_TIME,\n" + 
		"       AGN.REPAIRSTATE AS AGNSTATUS,\n" + 
		"       AGN.RESULTDESC AS RESULTDESC,\n" + 
		"       AGN.REPAIR_TEAM AS REPAIR_TEAM,\n" + 
		"       DISEMP.EMPLOYEE_NAME AS DISPATH_USER_NAME\n" + 
		"  FROM GMS_DEVICE_COLL_REPAIR_SUB    SUB,\n" + 
		"       GMS_DEVICE_ACCOUNT_B          ACC,\n" + 
		"       GMS_DEVICE_COLL_REPAIRFORM    SEND,\n" + 
		"       GMS_DEVICE_COLL_REPAIR_ASSIGN AGN,\n" + 
		"       GMS_DEVICE_COLL_REPAIRFORM    REP,\n" + 
		"       GP_TASK_PROJECT               PRO,\n" + 
		"       COMM_ORG_INFORMATION          REQORG,\n" + 
		"       COMM_ORG_INFORMATION          TODOORG,\n" + 
		"       COMM_HUMAN_EMPLOYEE           EMP,\n" + 
		"       COMM_HUMAN_EMPLOYEE           DISEMP,\n" + 
		"       GMS_DEVICE_COLL_REPAIR_REC    REC\n" + 
		" WHERE 1 = 1\n" + 
		"   AND SUB.DEV_ACC_ID = ACC.DEV_ACC_ID(+)\n" + 
		"   AND SUB.REPAIRFORM_ID = SEND.ID(+)\n" + 
		"   AND SUB.ID = AGN.REPAIR_ID(+)\n" + 
		"   AND REP.OWN_PROJECT = PRO.PROJECT_INFO_NO(+)\n" + 
		"   AND REP.REQ_COMP = REQORG.ORG_ID(+)\n" + 
		"   AND REP.TODO_COMP = TODOORG.ORG_ID(+)\n" + 
		"   AND REP.CREATOR = EMP.EMPLOYEE_ID(+)\n" + 
		"   AND AGN.DISPATH_USER = DISEMP.EMPLOYEE_ID(+)\n" + 
		"   AND REP.ID(+) = REC.REPARE_ID\n" + 
		"   AND REP.BSFLAG = '0'\n" + 
		"   AND REP.STATUS = '1'\n" + 
		"   AND SUB.BSFLAG = '0'\n" + 
		"   AND ACC.BSFLAG = '0'\n" + 
		"   AND AGN.BSFLAG = '0'\n" + 
		"   AND AGN.ENABLEFLAG = '0'\n" +
		"   AND AGN.RECIEVESTATE  IN ('1')\n";
		sql += " and AGN.REPAIR_ID = '<%=id%>'";
		var repairQueryRet = encodeAndsyncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql);
		var retObj = repairQueryRet.datas;
		//$("#repair_form_code","#projectMap").val(retObj[0].repair_form_code);
		//$("#repair_form_name","#projectMap").val(retObj[0].repair_form_name);
		//$("#project_name").val(retObj[0].project_name);
		//$("#req_comp_name").val(retObj[0].req_comp_name);
		//$("#todo_comp_name").val(retObj[0].todo_comp_name);
		$("#dev_name").val(retObj[0].dev_name);
		$("#dev_model").val(retObj[0].dev_model);
		$("#dev_sign").val(retObj[0].dev_sign);
		$("#dispath_user_name").val(retObj[0].dispath_user_name);
		$("#dispath_date").val(retObj[0].dispath_date);
		$("#assign_status").val(retObj[0].assign_status);
		$("#repair_team").val(retObj[0].repair_team);
		$("#repair_end_time").val(retObj[0].repair_end_time);
		$("#resultDesc").val(retObj[0].resultdesc);
		$("#assign_status").val(retObj[0].assign_status);
		//************************
		var now = new Date();
	    var year = now.getFullYear();       //年
	    var month = now.getMonth() + 1;     //月
	    var day = now.getDate();            //日
	    var clock = year + "-";
	    if(month < 10)
	        clock += "0";
	    clock += month + "-";
	    if(day < 10)
	        clock += "0";
	    clock += day;
	    var repair_end_time = $("#repair_end_time").val();
	    if(repair_end_time == ""){
	    	$("#repair_end_time").val(clock);
	    }
	    //*****************************
		//配件明细信息
		var querySql =  "SELECT ITEM.*,TREE.PART_NAME AS PART_NAME ,	" +
			"       part.ID          AS PART_ID,\n" + 
		 	"DECODE(ITEM.CURRERY, <%=DevUtil.getDecodeStr(DevConstants.DECODE_KEY_CURRENCY)%>) AS CURRENCY_NAME " +
			"  FROM GMS_DEVICE_REPARE_PART        PART,\n" + 
			"       GMS_DEVICE_PART_ITEM          ITEM,\n" + 
			"       GMS_DEVICE_PART_TREE          TREE,\n" +
			"       GMS_DEVICE_COLL_REPAIR_ASSIGN AGN\n" + 
			" WHERE PART.PART_INFO_ID = ITEM.ID(+)\n" + 
			"   AND ITEM.TREE_ID = TREE.ID(+)\n" + 
			"   AND PART.DEV_REPAIR_ID = AGN.ID(+)\n" + 
			"   AND PART.BSFLAG = '0'" +
			"   AND AGN.REPAIR_ID = '<%=id%>'";
		var dataret = encodeAndsyncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql+'&pageSize=1000');
		var retObj = dataret.datas;
		addLine(retObj,true);
		};
	function addLine(retObj,readflag){  //flag 是否从数据库中读取  true  是
		var curline =  $("#detaillist>tr").size();
		var length = curline + retObj.length;
		for(var index=0;index<retObj.length;index++){
			var flag = true;
			$("input[type='checkbox'][name='idinfo']").each(function(){
					var id=this.id;
					if(retObj[index].id == id){
					flag = false;
					}
			});
			var line = index+curline; 
			var innerhtml = "<tr id='tr"+retObj[index].id+"' name='tr' midinfo='"+retObj[index].id+"'>";
			innerhtml += "<td width='8%'>"+retObj[index].part_name+"</td>";
			innerhtml += "<td width='8%'>"+retObj[index].item_name+"</td>";
			innerhtml += "<td width='8%'>"+retObj[index].orderno+"</td>";
			innerhtml += "<td width='8%'>"+retObj[index].part_model+"</td>";
			innerhtml += "<td width='8%'>"+retObj[index].brand+"</td>";
			innerhtml += "<td width='8%'>"+retObj[index].supplyname+"</td>";
			innerhtml += "<td width='8%'>"+retObj[index].factoryname+"</td>";
			innerhtml += "<td width='8%'>"+retObj[index].currency_name+"</td>";
			innerhtml += "<td width='8%'>"+retObj[index].unit+"</td>";
			innerhtml += "<td width='8%'>"+retObj[index].perprice+"</td>";
			innerhtml += "</tr>";
		if(flag){//如果与现有的不重复
			$("#detaillist").append(innerhtml);
			$("#detaillist>tr:odd>td:odd").addClass("odd_odd");
			$("#detaillist>tr:odd>td:even").addClass("odd_even");
			$("#detaillist>tr:even>td:odd").addClass("even_odd");
			$("#detaillist>tr:even>td:even").addClass("even_even");
		}
		}
	}
</script>
</html>

