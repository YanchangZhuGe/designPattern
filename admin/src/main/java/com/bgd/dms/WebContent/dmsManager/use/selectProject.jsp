<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%>
<%@ taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@ page import="java.text.*"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();

	String orgSubjectionId = "C105";
	if (request.getParameter("orgSubjectionId") != null) {
		orgSubjectionId = request.getParameter("orgSubjectionId");
	}
	String orgId = "C6000000000001";
	if (request.getParameter("orgId") != null) {
		orgId = request.getParameter("orgId");
	}
	UserToken user = OMSMVCUtil.getUserToken(request);
%>
<html>
<head>
<script type="text/javascript">
var projectStatus1 = new Array(
		['5000100001000000001','项目启动'],
		['5000100001000000002','正在运行'],
		['5000100001000000003','项目结束'],
		['5000100001000000004','项目暂停'],
		['5000100001000000005','施工结束']
		);
var projectType1 = new Array(
		 ['5000100004000000001','陆地项目'],
		 ['5000100004000000008','井中项目'],
		 ['5000100004000000002','浅海项目'],
		 ['5000100004000000003','非地震项目'],
		 ['5000100004000000005','地震项目'],
		 ['5000100004000000006','深海项目'],
		 ['5000100004000000009','综合物化探'],
		 ['5000100004000000007','陆地和浅海项目'],
		 ['5000100004000000010','滩浅海过渡带']
		 );

</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all"
	href="<%=contextPath%>/css/calendar-blue.css" />

<title>无标题文档</title>
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
							<tr>
								<td class="ali_cdn_name">项目名</td>
								<td class="ali_cdn_input"><input id="projectName"
									name="projectName" type="text" class="input_width" /></td>
								<td class="ali_cdn_name">项目状态</td>
								<td class="ali_cdn_input"><select id="projectStatus"
									name="projectStatus" class="select_width">
										<option value="" selected="selected">--请选择--</option>
										<option value="5000100001000000001">项目启动</option>
										<option value="5000100001000000002">正在运行</option>
										<option value="5000100001000000003">项目结束</option>
										<option value="5000100001000000004">项目暂停</option>
										<option value="5000100001000000005">施工结束</option>
								</select></td>
								<td class="ali_query"><span class="cx"><a href="#"
										onclick="simpleRefreshData()" title="JCDP_btn_query"></a></span></td>
								<td class="ali_query"><span class="qc"><a href="#"
										onclick="clearQueryText()" title="JCDP_btn_clear"></a></span></td>
								<td>&nbsp;</td>
								<auth:ListButton functionId="" css="dk"
									event="onclick='toSubProjects()'" title="子项目列表"></auth:ListButton>
								<auth:ListButton functionId="" css="gl"
									event="onclick='toSearch()'" title="JCDP_btn_query"></auth:ListButton>
							</tr>

						</table></td>
					<td width="4"><img src="<%=contextPath%>/images/list_17.png"
						width="4" height="36" /></td>
				</tr>
			</table>
		</div>
		<div id="table_box">
			<input type="hidden" id="orgSubjectionId" name="orgSubjectionId"
				value="<%=orgSubjectionId%>" class="input_width" />
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				class="tab_info" id="queryRetTable">
				<tr>
					<td class="bt_info_odd"
						exp="<input type='checkbox' name='rdo_entity_id' value='{project_info_no}~{project_type}~{project_year}~{org_subjection_id}~{org_id}~{project_name}' id='rdo_entity_id_{project_info_no}' onclick='chooseOne(this)'/>">选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_even"
						exp="{project_name}<input type='hidden' id='projectName{project_info_no}' value='{project_name}'/>">项目名称</td>
					<td class="bt_info_odd" exp="{project_status}"
						func="getOpValue,projectStatus1">项目状态</td>
					<td class="bt_info_even" exp="{project_type}"
						func="getOpValue,projectType1">项目类型</td>
					<td class="bt_info_even" exp="{manage_org_name}">甲方单位</td>
					<td class="bt_info_odd" exp="{start_date}">采集开始时间</td>
					<td class="bt_info_even" exp="{end_date}">采集结束时间</td>
				</tr>
			</table>
		</div>
		<div id="fenye_box">
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
	</div>
</body>
<script type="text/javascript">
function frameSize(){
	$("#table_box").css("height",$(window).height()*0.85);
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	;
$(document).ready(lashen);
</script>

<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	var orgSubjectionId= "<%=orgSubjectionId%>";
	var orgId="<%=orgId%>";
	// 复杂查询
		function refreshData(q_projectName, q_projectStatus, q_orgSubjectionId){	
		var str = "";
			str += "select p.*,    dy.org_id as org_id22, (select t.coding_name  from comm_coding_sort_detail t"+
			"  where t.coding_code_id =      (select superior_code_id       from comm_coding_sort_detail   where coding_code_id = p.manage_org)) || ' ' ||  ccsd.coding_name as manage_org_name,     sap.prctr_name as prctr_name,  ct.project_name as pro_name,       "+
			"     p.design_end_date - p.design_start_date as duration_date,    p6.object_id as project_object_id, "+
			"  nvl(p.project_start_time, p.acquire_start_time) as start_date,         nvl(p.project_end_time, p.acquire_end_time) as end_date,"+
			" dy.org_id,    org.org_abbreviation as org_name,     (case p.project_status     when '5000100001000000001' then    '1' "+
			"  when '5000100001000000002' then    '2'     when '5000100001000000003' then  '4'     when '5000100001000000004' then    '3' "+
			"  when '5000100001000000005' then   '5'    else     '6'     end) pro_status   from gp_task_project p";
		    str +="  join gp_task_project_dynamic dy on dy.bsflag = '0'  and dy.project_info_no =  p.project_info_no and dy.exploration_method =p.exploration_method and dy.org_subjection_id like  '<%=orgSubjectionId%>%'";
			str +="   left join comm_coding_sort_detail ccsd on p.manage_org = ccsd.coding_code_id  and ccsd.bsflag = '0' "+
			"  left join bgp_pm_sap_org sap on sap.prctr = p.prctr   left join bgp_p6_project p6 on p6.project_info_no =  p.project_info_no   and p6.bsflag = '0' "+
			"  left join gp_workarea_diviede wd on wd.workarea_no =  p.workarea_no   and wd.bsflag = '0' "+
			" left join comm_org_information org on org.org_id =   dy.org_id   and org.bsflag = '0' left join gp_ops_epg_task_project ct on ct.project_info_no = p.spare2 "+
			"   where 1 = 1 and p.bsflag = '0' ";
			if(q_projectName!=undefined&&q_projectName!=""){
					str += "  and p.project_name like '%"+q_projectName+"%' ";
	         }
			
			if(q_projectStatus!=undefined&&q_projectStatus!=""){
				str += "  and p.project_status='"+q_projectStatus+"' ";
             }
			str+=" order by pro_status, p.project_year desc";
		    cruConfig.queryStr = str;
		    queryData(cruConfig.currentPage);
	}

	
	// 简单查询
	function simpleRefreshData(){
		var q_projectName = document.getElementById("projectName").value;
		var q_projectStatus = document.getElementById("projectStatus").value;
		refreshData(q_projectName,q_projectStatus, orgSubjectionId);
	}
	
	function clearQueryText(){
		document.getElementById("projectName").value = "";
		document.getElementById("projectStatus").value = "";
	}
	function dbclickRow(ids){
		var name = ids.split("~")[5];
		var id= ids.split("~")[0];
		var project_type= ids.split("~")[1];
		window.returnValue = id+"~"+name+"~"+project_type;
		window.close();

	}

	//chooseOne()函式，參數為觸發該函式的元素本身
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

