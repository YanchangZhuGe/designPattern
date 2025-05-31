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
	String subId = user.getOrgSubjectionId();
	String orgId = user.getOrgId();
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
 
 <title>查询送内维修单页面</title> 
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
				<tr id='id_{id}' name='id' idinfo='{id}'>
					<td class="bt_info_odd"
						exp="<input type='checkbox' name='selectedbox' value='{id}' id='selectedbox_{id}' onclick='chooseOne(this)'/>">选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{repair_form_code}">送修单号</td>
					<td class="bt_info_odd" exp="{repair_form_name}">送修单名称</td>
					<td class="bt_info_even" exp="{project_name}">所属项目</td>
					<td class="bt_info_odd" exp="{req_comp_name}">送修单位</td>
					<td class="bt_info_even" exp="{todo_comp_name}">维修单位</td>
					<td class="bt_info_odd" exp="{creator_name}">创建人</td>
					<td class="bt_info_even" exp="{create_date}">创建日期</td>
					<td class="bt_info_odd" exp="{status_desc}">状态</td>
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
		/********* 去除  已经制作了送内维修单 但是 没有进行结果登记的那部分单据   
		 AND rep.id not in
   （
   SELECT 0 AS COUNT1, REPAIRFORM_ID AS FORMID
                  FROM GMS_DEVICE_COLL_REPAIR_SUB
                 WHERE BSFLAG = 0
                   AND DEV_STATUS < 3
                 GROUP BY REPAIRFORM_ID
   ）
		**********/
		var tmp = 
			"SELECT A.FORMID AS FORMID FROM\n" +
			"(SELECT COUNT(1) AS COUNT1, REPAIRFORM_ID AS FORMID FROM   GMS_DEVICE_COLL_REPAIR_SUB\n" + 
			"WHERE BSFLAG = 0  AND DEV_STATUS > 2 GROUP BY REPAIRFORM_ID) A,\n" + 
			"(SELECT COUNT(1) AS COUNT2,REPAIRFORM_ID AS FORMID FROM   GMS_DEVICE_COL_REP_DETAIL\n" + 
			"WHERE BSFLAG = 0 GROUP BY REPAIRFORM_ID) B\n" + 
			"WHERE A.FORMID = B.FORMID\n" + 
			"AND A.COUNT1 = B.COUNT2";

		var str = " SELECT REP.*,EMP.EMPLOYEE_NAME AS CREATOR_NAME,";
			str += " PRO.PROJECT_NAME,REQORG.ORG_ABBREVIATION AS REQ_COMP_NAME,TODOORG.ORG_ABBREVIATION AS TODO_COMP_NAME,";
			str += " DECODE(REP.STATUS, 0, '编制', 1, '生效',2, '作废',3, '拒接收', '无效状态') AS STATUS_DESC";
			str += " FROM GMS_DEVICE_COLL_REPAIRFORM REP, GP_TASK_PROJECT PRO,COMM_ORG_INFORMATION       REQORG,";
			str += " COMM_ORG_INFORMATION       TODOORG,COMM_HUMAN_EMPLOYEE EMP,GMS_DEVICE_COLL_REPAIR_REC REC WHERE 1 = 1";
			str += " AND REP.BSFLAG = 0";
			str += "  AND REP.OWN_PROJECT = PRO.PROJECT_INFO_NO(+)";
			str += "   AND REP.REQ_COMP = REQORG.ORG_ID(+)";
			str += "   AND REP.TODO_COMP = TODOORG.ORG_ID(+)";
			str += "   AND REP.CREATOR = EMP.EMPLOYEE_ID(+)";
			str += "   AND REP.CREATOR = EMP.EMPLOYEE_ID(+)";
			str += "   AND REP.ID(+) = REC.REPARE_ID";
			//维修单位是本机构的
			str += "   AND REP.TODO_COMP = '<%=orgId%>' ";
			str += "   AND REP.ID NOT IN ("+tmp+")";
			str += "   AND REC.REC_STATUS = '1' AND REC.BSFLAG = '0'";
		if(v_device_repair_app_no!=undefined && v_device_repair_app_no!=''){//根据送修单号查询
			str += " AND REP.REPAIR_FORM_CODE like '%"+v_device_repair_app_no+"%' ";
		}
		if(v_device_repair_app_name!=undefined && v_device_repair_app_name!=''){//根据送修单名称查询
			str += " and REP.REPAIR_FORM_NAME like '%"+v_device_repair_app_name+"%' ";
		}
			str += " ORDER BY REP.CREATE_DATE DESC";
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