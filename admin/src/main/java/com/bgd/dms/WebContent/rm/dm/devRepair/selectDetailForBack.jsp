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
 
 <title>查询送外维修返还页面</title> 
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
			<!-- 
			  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='dev_acc_id_head' name='dev_acc_id'>
			     	<td class="bt_info_odd"><input type='checkbox' id='collbackinfo' name='collbackinfo'/></td>
			     	<td class="bt_info_odd">送修单号</td>
						<td class="bt_info_even">送修单名称</td>
					<td class="bt_info_odd">设备名称</td>
						<td class="bt_info_even">规格型号</td>
						<td class="bt_info_odd">实物标识号</td>
						<td class="bt_info_odd">故障类别</td>
						<td class="bt_info_even">故障现象</td>
						<td class="bt_info_odd">设备状态</td>
						 <td class="bt_info_even">备注</td>
			     </tr>
			    <tbody id="detaillist" name="detaillist" >
			   </tbody>
			  </table>
			   -->
			   <table style="width: 98.5%" border="0" cellspacing="0"
				cellpadding="0" class="tab_info" id="queryRetTable">
				<tr id='id_{id}' name='id'
					idinfo='{id}'>
					<td class="bt_info_odd" 
						exp="<input type='checkbox' name='idinfo' value='{id}' id='selectedbox_{id}' />">选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{repair_form_no}">送外维修单号</td>
					<td class="bt_info_odd" exp="{repair_form_name}">送修单名称</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_model}">规格型号</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_even" exp="{error_type}">故障类别</td>
					<td class="bt_info_even" exp="{error_desc}">故障现象</td>
					<td class="bt_info_even" exp="{dev_status}">设备状态</td>
					<td class="bt_info_even" exp="{remark}">备注</td>
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
	</div>
	<div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</body>
<script type="text/javascript">

	var projectInfoNos = '<%=projectinfono%>';
	var out_org_id = '<%=out_org_id%>';
	var backdevtype = '<%=backdevtype%>';
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	function refreshData(v_dev_ci_name,v_dev_ci_model){
		var str = 
			"SELECT SEND.REPAIR_FORM_NO AS REPAIR_FORM_NO,\n" +
			"                        SEND.REPAIR_FORM_NAME AS REPAIR_FORM_NAME,\n" + 
			"                        ACC.DEV_NAME AS DEV_NAME,\n" + 
			"                        ACC.DEV_TYPE AS DEV_TYPE,\n" + 
			"       ACC.DEV_MODEL AS DEV_MODEL,\n" + 
			"                        DECODE(SUB.ERROR_TYPE,\n" + 
			"                               '0',\n" + 
			"                               '无故障',\n" + 
			"                               '1',\n" + 
			"                               '普通',\n" + 
			"                               '2',\n" + 
			"                               '特殊',\n" + 
			"                               '') as ERROR_TYPE,\n" + 
			"                        DECODE(SUB.ERROR_DESC,\n" + 
			"                               '0',\n" + 
			"                               '无故障',\n" + 
			"                               '1',\n" + 
			"                               '不通',\n" + 
			"                               '2',\n" + 
			"                               '数传',\n" + 
			"                               '3',\n" + 
			"                               '死站',\n" + 
			"                               '4',\n" + 
			"                               '年检不过',\n" + 
			"                               '5',\n" + 
			"                               '单边通',\n" + 
			"                               '6',\n" + 
			"                               '本道不通',\n" + 
			"                               '7',\n" + 
			"                               '共摸',\n" + 
			"                               '8',\n" + 
			"                               '本道',\n" + 
			"                               '9',\n" + 
			"                               '初始化不过',\n" + 
			"                               '10',\n" + 
			"                               '漏电',\n" + 
			"                               '11',\n" + 
			"                               '畸变不过',\n" + 
			"                               '12',\n" + 
			"                               '单边不通',\n" + 
			"                               '13',\n" + 
			"                               '短路',\n" + 
			"                               '14',\n" + 
			"                               '物理损坏',\n" + 
			"                               '15',\n" + 
			"                               '共模不过',\n" + 
			"                               '') AS ERROR_DESC,\n" + 
			"                        ACC.DEV_SIGN AS DEV_SIGN,\n" + 
			"                        DECODE(SUB.DEV_STATUS,\n" + 
			"                               '0',\n" + 
			"                               '待修',\n" + 
			"                               '1',\n" + 
			"                               '在修',\n" + 
			"                               '2',\n" + 
			"                               '待仪器检测',\n" + 
			"                               '3',\n" + 
			"                               '无法修复',\n" + 
			"                               '4',\n" + 
			"                               '完好',\n" + 
			"                               '') AS DEV_STATUS,\n" + 
			"                        SUB.REMARK AS REMARK,\n" + 
			"                        SUB.ID as ID\n" + 
			"                   FROM (select t.*\n" + 
			"                           from GMS_DEVICE_COLL_SEND_SUB t\n" + 
			"                          where not exists\n" + 
			"                          (select 1\n" + 
			"                                   from GMS_DEVICE_COL_REP_DETAIL back\n" + 
			"                                  where t.id = back.REP_FORM_DET_ID\n" + 
			"                                    and back.bsflag = 0)) sub,\n" + 
			"                        GMS_DEVICE_ACCOUNT_B ACC,\n" + 
			"                        GMS_DEVICE_COLL_REPAIR_SEND SEND\n" + 
			"                  WHERE SUB.BSFLAG = '0'\n" + 
			"                    AND ACC.BSFLAG = '0'\n" + 
			"                    AND SUB.DEV_ACC_ID = ACC.DEV_ACC_ID(+)\n" + 
			"                    AND SUB.SEND_FORM_ID = SEND.ID(+)";
			if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
				str += "and SEND.REPAIR_FORM_NO like '%"+v_dev_ci_name+"%' ";
			}
			if(v_dev_ci_model!=undefined && v_dev_ci_model!=''){
				str += "and SEND.REPAIR_FORM_NAME like '%"+v_dev_ci_model+"%' ";
			}
			cruConfig.queryStr = str;
			queryData(cruConfig.currentPage);
			/***
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		var retObj = proqueryRet.datas;
		$("#detaillist").empty();
		for(var index=0;index<retObj.length;index++){
			var innerhtml = "<tr id='tr"+retObj[index].id+"' name='tr' midinfo='"+retObj[index].id+"'>";
			innerhtml += "<td><input type='checkbox' name='idinfo' id='"+retObj[index].id+"' value='"+retObj[index].id+"'/></td>";
			innerhtml += "<td>"+retObj[index].repair_form_no+"</td><td>"+retObj[index].repair_form_name+"</td>";
			innerhtml += "<td>"+retObj[index].dev_name+"</td><td>"+retObj[index].dev_model+"</td>";
			innerhtml += "<td>"+retObj[index].dev_sign+"</td>";
			innerhtml += "<td>"+retObj[index].error_type+"</td><td>"+retObj[index].error_desc+"</td>";
			innerhtml += "<td>"+retObj[index].dev_status+"</td><td>"+retObj[index].remark+"</td>";
			innerhtml += "</tr>";
			$("#detaillist").append(innerhtml);
		}
		$("#detaillist>tr:odd>td:odd").addClass("odd_odd");
		$("#detaillist>tr:odd>td:even").addClass("odd_even");
		$("#detaillist>tr:even>td:odd").addClass("even_odd");
		$("#detaillist>tr:even>td:even").addClass("even_even");
		***/
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
		var v_device_repair_app_no = document.getElementById("s_device_repair_app_no").value;
		var v_device_repair_app_name = document.getElementById("s_device_repair_app_name").value;
		refreshData(v_device_repair_app_no, v_device_repair_app_name);
	}
	function clearQueryText(){
		document.getElementById("s_device_repair_app_no").value = "";
		document.getElementById("s_device_repair_app_name").value = "";
	}
</script>
</html>