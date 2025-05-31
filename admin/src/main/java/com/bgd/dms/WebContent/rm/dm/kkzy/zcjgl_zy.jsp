<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String projectName = user.getProjectName();
	String userOrgId = user == null || user.getOrgId() == null
			? ""
			: user.getOrgId().trim();
	String subOrgId = user.getSubOrgIDofAffordOrg();

	String userSubid = user.getOrgSubjectionId();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<title>总成件维修信息管理</title>
</head>
<body style="background: #fff" onload="refreshData()">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png"
						width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png"><table
							width="100%" border="0" cellspacing="0" cellpadding="0">
							</tr>
							<tr>
								<td class="ali_cdn_name">自编号</td>
								<td class="ali_cdn_input"><input id="s_self_num"
									name="s_self_num" type="text" class="input_width" /></td>

								<td class="ali_query"><span class="cx"><a href="#"
										onclick="searchDevData()" title="查询"></a></span></td>
								<td class="ali_query"><span class="qc"><a href="#"
										onclick="clearQueryText()" title="清除"></a></span></td>
								<td>&nbsp;</td>

								<auth:ListButton functionId="" css="zj"
									event="onclick='toAddXgll()'" title="新增"></auth:ListButton>
								<auth:ListButton functionId="" css="xg"
									event="onclick='toModifyXgll()'" title="修改"></auth:ListButton>
								<auth:ListButton functionId="" css="sc"
									event="onclick='toDelXgll()'" title="删除"></auth:ListButton>
								<auth:ListButton functionId="" css="dc"
									event="onclick='exportData()'" title="导出excel"></auth:ListButton>

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
				<tr id='zcjwx_id_{zcjwx_id}' name='zcjwx_id' idinfo='{zcjwx_id}'>
					<td class="bt_info_odd"
						exp="<input type='checkbox' name='rdo_entity_id' value='{zcjwx_id}'  onclick=''chooseOne(
						this);loadDataDetail();'/ id='rdo_entity_id_{zcjwx_id}' {selectflag}/>">选择
					</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{wx_date}">日期</td>
					<td class="bt_info_odd" exp="{self_num}">自编号</td>
					<td class="bt_info_even" exp="{zcj_name}">总成件名称</td>
					<td class="bt_info_even" exp="{zcj_model}">型号</td>
					<td class="bt_info_odd" exp="{sequence}">系列号</td>
					<td class="bt_info_even" exp="{work_hour}">累计运转时间</td>
					<td class="bt_info_odd" exp="{wx_level}">修理级别</td>
					<td class="bt_info_even" exp="{wx_content}">主要修理内容</td>
					<td class="bt_info_even" exp="{performance_desc}">主要装配尺寸及性能指标</td>
					<td class="bt_info_odd" exp="{worker_unit}">承修单位</td>
					<td class="bt_info_odd" exp="{worker}">主修人</td>
					<td class="bt_info_odd" exp="{bak}">备注</td>



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
		<div class="lashen" id="line"></div>
		<div id="tag-container_3">
			<ul id="tags" class="tags">
				<li class="selectTag" id="tag3_0"><a href="#"
					onclick="getContentTab(this,0)">基本信息</a></li>
			</ul>
		</div>
		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" name="tab_box_content0"
				class="tab_box_content">
				<table id="projectMap" name="projectMap" border="0" cellpadding="0"
					cellspacing="0" class="tab_line_height" width="100%"
					style="margin-top: 10px; background: #efefef">
					<tr>
						<td class="inquire_item6">日期：</td>
						<td class="inquire_form6"><input id="wx_date"
							class="input_width" type="text" value="" />&nbsp;</td>
						<td class="inquire_item6">总成件名称：</td>
						<td class="inquire_form6"><input id="zcj_name"
							class="input_width" type="text" value="" /> &nbsp;</td>
						<td class="inquire_item6">&nbsp;系列号：</td>
						<td class="inquire_form6"><input id="sequence"
							class="input_width" type="text" value="" /> &nbsp;</td>
					</tr>
					<tr>
						<td class="inquire_item6">累计运转时间：</td>
						<td class="inquire_form6"><input id="work_hour"
							class="input_width" type="text" value=""  /> &nbsp;</td>
						<td class="inquire_item6">&nbsp;修理级别：</td>
						<td class="inquire_form6"><input id="wx_level"
							class="input_width" type="text" value=""  /> &nbsp;</td>
						<td class="inquire_item6">&nbsp;主要修理内容：</td>
						<td class="inquire_form6"><input id="wx_content"
							class="input_width" type="text" value=""  /> &nbsp;</td>

					</tr>
					<tr>
						<td class="inquire_item6">主要装配尺寸及性能指标：</td>
						<td class="inquire_form6"><input id="performance_desc"
							class="input_width" type="text" value=""  /> &nbsp;</td>
						<td class="inquire_item6">主修人：</td>
						<td class="inquire_form6"><input id="worker"
							class="input_width" type="text" value="" /> &nbsp;</td>
						<td class="inquire_item6">承修单位：</td>
						<td class="inquire_form6"><input id="worker_unit"
							class="input_width" type="text" value=""  /> &nbsp;</td>

					</tr>
					<tr>
						<td class="inquire_item6">验收人：</td>
						<td class="inquire_form6"><input id="accepter"
							class="input_width" type="text" value=""  /> &nbsp;</td>
						<td class="inquire_item6">备注：</td>
						<td class="inquire_form6"><input id="bak" class="input_width"
							type="text" value=""  /> &nbsp;</td>
						<td colspan='6'>&nbsp;</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
	function frameSize() {
		//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
		setTabBoxHeight();
	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	});
	$(document).ready(lashen);
</script>
<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
cruConfig.queryStr = "";
function frameSize(){
//	$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-40);
	setTabBoxHeight();
}
frameSize();

function refreshData(v_self_num){
		var projectInfoNo='<%=projectInfoNo%>';
		var str = "";
		str+="select l.zcj_model,l.zcjwx_id,l.wx_date,(select  coding_name  from comm_coding_sort_detail where coding_sort_id='5110000187' and coding_code_id=l.zcj_name)  as   zcj_name,l.sequence,l.work_hour, d.coding_name as wx_level,l.performance_desc,l.worker,l.bak, dui.self_num,  l.wx_content, l.worker_unit,l.accepter,dui.dev_acc_id ";
		str+=" from gms_device_zy_zcjwx l  left join comm_coding_sort_detail d on d.coding_code_id=l.wx_level left join gms_device_account dui on dui.dev_acc_id = l.dev_acc_id where l.ORG_SUBJECTION_ID like  '<%=subOrgId%>%'  and l.bsflag='0'";
		if(v_self_num!=undefined && v_self_num!=''){
			str += "and dui.self_num like '%"+v_self_num+"%' ";
		}
		
		str+="  order  by l.create_date desc";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}

function toAddXgll(){
	popWindow('<%=contextPath%>/rm/dm/kkzy/zcjglAdd-zy.jsp','1050:680');
}
function toModifyXgll(){
	var ids = getSelIds('rdo_entity_id');
    if(ids==''){ 
    	alert("请选择一条记录");
 		return;
    }
    var temp = ids.split(",");
	var wz_ids = "";
	for(var i=0;i<temp.length;i++){
		if(wz_ids!=""){
			wz_ids += ","; 
		}
		wz_ids += "'"+temp[i]+"'";
	}
	popWindow('<%=contextPath%>/rm/dm/kkzy/zcjglAdd-zy.jsp?wx_ids='
				+ wz_ids, '1050:680');

	}
	//点击记录查询明细信息
	function loadDataDetail(shuaId) {
		var retObj;
		if (shuaId != null) {
			retObj = jcdpCallService("DevInsSrv", "getzcjwxInfo", "wx_id="
					+ shuaId);
		} else {
			var ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				return;
			}
			retObj = jcdpCallService("DevInsSrv", "getzcjwxInfo", "wx_id="
					+ shuaId);
		}
		//取消选中框--------------------------------------------------------------------------
		var obj = document.getElementsByName("rdo_entity_id");
		for (i = 0; i < obj.length; i++) {
			obj[i].checked = false;
		}
		//选中这一条checkbox
		$("#rdo_entity_id_" + retObj.deviceaccMap.zcjwx_id).attr("checked",
				"checked");
		document.getElementById("wx_date").value = retObj.deviceaccMap.wx_date;
		document.getElementById("zcj_name").value = retObj.deviceaccMap.zcj_name;
		document.getElementById("sequence").value = retObj.deviceaccMap.sequence;
		document.getElementById("work_hour").value = retObj.deviceaccMap.work_hour;
		document.getElementById("wx_level").value = retObj.deviceaccMap.wx_level;
		document.getElementById("wx_content").value = retObj.deviceaccMap.wx_content;
		document.getElementById("performance_desc").value = retObj.deviceaccMap.performance_desc;
		document.getElementById("worker").value = retObj.deviceaccMap.worker;
		document.getElementById("worker_unit").value = retObj.deviceaccMap.worker_unit;
		document.getElementById("accepter").value = retObj.deviceaccMap.accepter;
		document.getElementById("bak").value = retObj.deviceaccMap.bak;
	}

	function clearQueryText() {
		$("#s_self_num").val("");
	}
	function searchDevData() {
		var v_self_num = document.getElementById("s_self_num").value;
		refreshData(v_self_num);
	}

	function toDelXgll() {
		var ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录");
			return;
		}
		var temp = ids.split(",");
		var wz_ids = "";
		for ( var i = 0; i < temp.length; i++) {
			if (wz_ids != "") {
				wz_ids += ",";
			}
			wz_ids += "'" + temp[i] + "'";
		}
		if (confirm("是否执行删除操作?")) {
			retObj = jcdpCallService("DevInsSrv", "deletezcjwxInfo", "wx_ids="
					+ wz_ids);
			refreshData('');
		}

	}
	function chooseOne(cb) {
		//先取得同name的chekcBox的集合物件   
		var obj = document.getElementsByName("rdo_entity_id");
		for (i = 0; i < obj.length; i++) {
			//判斷obj集合中的i元素是否為cb，若否則表示未被點選   
			if (obj[i] != cb)
				obj[i].checked = false;
			//若是 但原先未被勾選 則變成勾選；反之 則變為未勾選  
			//else  obj[i].checked = cb.checked;   
			//若要至少勾選一個的話，則把上面那行else拿掉，換用下面那行  
			else
				obj[i].checked = true;
		}
	}
</script>
</html>