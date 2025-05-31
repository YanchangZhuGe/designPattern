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
	
	ResourceBundle rb = ResourceBundle.getBundle("devCodeDesc");
	String[] backTypeIDs = rb.getString("BackTypeID").split("~", -1);
	String backtypewaizu = backTypeIDs[0];
	String backtypeziyou = backTypeIDs[1];
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
 <script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
 <script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
 
 <title>查询送外维修单页面</title> 
 </head> 
 
 <body style="background:#F1F2F3" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">送修单号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_device_repair_app_no" name="s_device_repair_app_no" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">送修单名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_device_repair_app_name" name="s_device_repair_app_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
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
			   <table style="width: 98.5%" border="0" cellspacing="0"
				cellpadding="0" class="tab_info" id="queryRetTable">
				<tr id='id_{id}' name='id'
					idinfo='{id}'>
					<td class="bt_info_odd" 
						exp="<input type='checkbox' name='selectedbox' value='{id}' id='selectedbox_{id}' onclick='chooseOne(this)'/>">选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{repair_form_no}">送外维修单号</td>
					<td class="bt_info_odd" exp="{repair_form_name}">送修单名称</td>
					<td class="bt_info_even" exp="{project_name}">所属项目</td>
					<td class="bt_info_odd" exp="{req_comp_name}">送修单位</td>
					<td class="bt_info_even" exp="{service_company}">维修单位</td>
					<!-- 刘广 start -->
					<td class="bt_info_even" exp="{apply_date}">申请日期</td>
					<td class="bt_info_even" exp="{buget_our}">预计原币金额</td>
					<td class="bt_info_even" exp="{buget_local}">预计本币金额</td>
					<td class="bt_info_even" exp="{currency}">币种</td>
					<td class="bt_info_even" exp="{rate}">汇率</td>
					<!-- 刘广 end {status_desc}-->
					<td class="bt_info_odd" exp="{creator_name}">创建人</td>
					<td class="bt_info_even" exp="{create_date}">创建日期</td>
					<td class="bt_info_odd" exp="审批通过">状态</td>
				</tr>
			</table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
		 </div>
	<div id="oper_div">
     	<span class="bc_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</body>
<script type="text/javascript">

	var projectInfoNos = '<%=projectinfono%>';
	var out_org_id = '<%=out_org_id%>';
	var backdevtype = '<%=backdevtype%>';
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	function refreshData(v_device_repair_app_no, v_device_repair_app_name){
		////AND DEV_STATUS > 2  比较count 暂时不判断
		var tmp = 
			"SELECT A.FORMID AS FORMID FROM\n" +
			"(SELECT COUNT(1) AS COUNT1,SEND_FORM_ID AS FORMID FROM  GMS_DEVICE_COLL_SEND_SUB\n" + 
			"WHERE BSFLAG = 0  GROUP BY SEND_FORM_ID) A,\n" + 
			"(SELECT COUNT(1) AS COUNT2,REPAIRFORM_ID AS FORMID FROM   GMS_DEVICE_COL_REP_DETAIL\n" + 
			"WHERE BSFLAG = 0 GROUP BY REPAIRFORM_ID) B\n" + 
			"WHERE A.FORMID = B.FORMID\n" + 
			"AND A.COUNT1 = B.COUNT2";

		var str = " SELECT SEND.*,EMP.EMPLOYEE_NAME AS CREATOR_NAME,";
			str += " case wfmiddle.proc_status when '1' then '待审批' when '3' then '审批通过' when '4' then '审批不通过' else '未提交' end as pro_desc,";
			str += " PRO.PROJECT_NAME,REQORG.ORG_ABBREVIATION AS REQ_COMP_NAME,";
			str += " DECODE(SEND.STATUS, 0, '编制', 1, '生效',2, '作废',3, '拒接收', '无效状态') AS STATUS_DESC";
			str += " FROM GMS_DEVICE_COLL_REPAIR_SEND SEND,common_busi_wf_middle wfmiddle,GP_TASK_PROJECT PRO,COMM_ORG_INFORMATION       REQORG,";
			str += " COMM_HUMAN_EMPLOYEE EMP  WHERE 1 = 1";
			str += " AND SEND.BSFLAG = 0";
			str += " AND SEND.STATUS = 1";
			str += "   AND SEND.ID = wfmiddle.business_id(+) and wfmiddle.bsflag='0' ";
			str += "  AND SEND.OWN_PROJECT = PRO.PROJECT_INFO_NO(+)";
			str += "   AND SEND.APPLY_ORG = REQORG.ORG_ID(+)";
			str += "   AND SEND.CREATOR = EMP.EMPLOYEE_ID(+)";
			str += "   AND wfmiddle.proc_status = '3'";
			str += "   AND SEND.ID NOT IN ("+tmp+")";
		if(v_device_repair_app_no!=undefined && v_device_repair_app_no!=''){//根据送修单号查询
			str += " AND SEND.REPAIR_FORM_NO like '%"+v_device_repair_app_no+"%' ";
		}
		if(v_device_repair_app_name!=undefined && v_device_repair_app_name!=''){//根据送修单名称查询
			str += " and SEND.REPAIR_FORM_NAME like '%"+v_device_repair_app_name+"%' ";
		}
			str += " ORDER BY SEND.CREATE_DATE DESC";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
	function submitInfo(){
		var length = 0;
		var selectedids = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(i){
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
			$("input[type='checkbox'][name='selectedbox']").attr('checked',checkvalue);
		});
		
		
	});
	function searchDevData(){
		var v_device_repair_app_no = document.getElementById("s_device_repair_app_no").value;
		var v_device_repair_app_name = document.getElementById("s_device_repair_app_name").value;
		refreshData(v_device_repair_app_no, v_device_repair_app_name);
	}
	function clearQueryText(){
		document.getElementById("s_device_repair_app_no").value = "";
		document.getElementById("s_device_repair_app_name").value = "";
	}
	function chooseOne(cb) {
		var obj = document.getElementsByName("selectedbox");
		for (i = 0; i < obj.length; i++) {
			if (obj[i] != cb)
				obj[i].checked = false;
			else
				obj[i].checked = true;
		}
	}
</script>
</html>