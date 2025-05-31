<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectinfono = request.getParameter("projectinfono");
	String out_org_id = request.getParameter("out_org_id");
	String backdevtype = request.getParameter("backdevtype");
	String orgSubId = user.getOrgSubjectionId();
	String projectType = user.getProjectType();
	ResourceBundle rb = ResourceBundle.getBundle("devCodeDesc");
	String[] backTypeIDs = rb.getString("BackTypeID").split("~", -1);
	String backtypeziyou = backTypeIDs[0];
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

 <title>查询队级返还页面</title> 
 </head> 
 <body style="background:#F1F2F3;overflow:auto" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_ci_name" name="s_dev_ci_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_ci_model" name="s_dev_ci_model" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">牌照号</td>
			    <td class="ali_cdn_input">
			    	<input id="license_num" name="license_num" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">自编号</td>
			    <td class="ali_cdn_input">
			    	<input id="self_num" name="self_num" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">实物标识号</td>
			    <td class="ali_cdn_input">
			    	<input id="dev_sign" name="dev_sign" type="text" class="input_width" />
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
			  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable" style='float:auto'>		
			     <tr id='dev_acc_id_head' name='dev_acc_id'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{dev_acc_id}' id='selectedbox_{dev_acc_id}' />" >
			     		<input type='checkbox' name='selectedboxAll' id='selectedboxAll'/>
			     	</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_model}">规格型号</td>
					<td class="bt_info_even" exp="{self_num}">自编号</td>
					<td class="bt_info_odd" exp="{license_num}">牌照号</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
					<!-- <td class="bt_info_odd" exp="{asset_coding}">AMIS资产编号</td> -->
					<td class="bt_info_odd" exp="{dev_coding}">ERP设备编号</td>
					<td class="bt_info_odd" exp="{actual_in_time}">实际进场时间</td>
					<td class="bt_info_even" exp="{planning_out_time}">计划离场时间</td>
			     </tr>
			    <tbody id="detaillist" name="detaillist" >
			   </tbody>
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

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNos = '<%=projectinfono%>';
	var out_org_id = '<%=out_org_id%>';
	var backdevtype = '<%=backdevtype%>';
	var projectType="<%=projectType%>";
	var obj = window.dialogArguments;
	
	function searchDevData(){
		var v_dev_ci_name = $("#s_dev_ci_name").val();
		var v_dev_ci_model = $("#s_dev_ci_model").val();
		var license_num = $("#license_num").val();
		var self_num = $("#self_num").val();
		var dev_sign = $("#dev_sign").val();
		refreshData(v_dev_ci_name,v_dev_ci_model,license_num,self_num,dev_sign);
	}
	function clearQueryText(){
		$("#s_dev_ci_name").val("");
		$("#s_dev_ci_model").val("");
		$("#license_num").val("");
		$("#self_num").val("");
		$("#dev_sign").val("");
	}
	function refreshData(v_dev_ci_name,v_dev_ci_model,license_num,self_num,dev_sign){
		var conditionStr = "";
	
		if(backdevtype == '<%=DevConstants.MIXTYPE_ZHENYUAN%>'){
			conditionStr += " and (substr(account.dev_type,1,5) = '<%=DevConstants.MIXTYPE_ZHENYUAN%>' or 'S'||substr(account.dev_type,0,4) = '<%=DevConstants.MIXTYPE_ZHENYUAN%>' ) ";
			
		}else if(backdevtype == '<%=DevConstants.MIXTYPE_YIQI%>'){
			conditionStr += " and (((substr(account.dev_type,1,5) = '<%=DevConstants.MIXTYPE_YIQI%>' or 'S'||substr(account.dev_type,0,4) = '<%=DevConstants.MIXTYPE_YIQI%>') ";
			conditionStr += " and (substr(account.dev_type,1,9)!='<%=DevConstants.MIXTYPE_JIANBOQI%>' and 'S'||substr(account.dev_type,0,8)!='<%=DevConstants.MIXTYPE_JIANBOQI%>') ";
			conditionStr += " and (substr(account.dev_type,1,7)!='<%=DevConstants.MIXTYPE_XIAOZHESHEYI%>' and 'S'||substr(account.dev_type,0,6)!='<%=DevConstants.MIXTYPE_XIAOZHESHEYI%>') ";
			conditionStr += " and (substr(account.dev_type,1,9)!='<%=DevConstants.MIXTYPE_JIANBOQICESHIYI%>' and 'S'||substr(account.dev_type,0,8)!='<%=DevConstants.MIXTYPE_JIANBOQICESHIYI%>')) ";
			conditionStr += " or (substr(account.dev_type,1,5) = '<%=DevConstants.MIXTYPE_SHUZIJIANBOQI%>' or 'S'||substr(account.dev_type,0,4) = '<%=DevConstants.MIXTYPE_SHUZIJIANBOQI%>' )";
			conditionStr += " or (substr(account.dev_type,1,5) = '<%=DevConstants.MIXTYPE_YIQICHE%>' or 'S'||substr(account.dev_type,0,4) = '<%=DevConstants.MIXTYPE_YIQICHE%>')) ";
			
		}else if(backdevtype == '<%=DevConstants.MIXTYPE_CELIANG%>'){
			conditionStr += " and ((substr(account.dev_type,1,7) = '<%=DevConstants.MIXTYPE_CELIANG_01%>' or 'S'||substr(account.dev_type,0,6) = '<%=DevConstants.MIXTYPE_CELIANG_01%>') ";
			conditionStr += " or (substr(account.dev_type,1,7) = '<%=DevConstants.MIXTYPE_CELIANG_02%>' or 'S'||substr(account.dev_type,0,6) = '<%=DevConstants.MIXTYPE_CELIANG_02%>')";
			conditionStr += " or (substr(account.dev_type,1,7) = '<%=DevConstants.MIXTYPE_CELIANG_03%>' or 'S'||substr(account.dev_type,0,6) = '<%=DevConstants.MIXTYPE_CELIANG_03%>')) ";
			
		}else{
			conditionStr += "and (((substr(account.dev_type,1,5) != '<%=DevConstants.MIXTYPE_ZHENYUAN%>' and 'S'||substr(account.dev_type,0,4) != '<%=DevConstants.MIXTYPE_ZHENYUAN%>')";
			conditionStr += " and (substr(account.dev_type,1,5) != '<%=DevConstants.MIXTYPE_YIQI%>'  and 'S'||substr(account.dev_type,0,4) != '<%=DevConstants.MIXTYPE_YIQI%>')";
			conditionStr += " and (substr(account.dev_type,1,5) != '<%=DevConstants.MIXTYPE_YIQICHE%>' and 'S'||substr(account.dev_type,0,4) != '<%=DevConstants.MIXTYPE_YIQICHE%>')";
			conditionStr += " and (substr(account.dev_type,1,7) != '<%=DevConstants.MIXTYPE_CELIANG_01%>' and 'S'||substr(account.dev_type,0,6) != '<%=DevConstants.MIXTYPE_CELIANG_01%>') ";
			conditionStr += " and (substr(account.dev_type,1,7) != '<%=DevConstants.MIXTYPE_CELIANG_02%>' and 'S'||substr(account.dev_type,0,6) != '<%=DevConstants.MIXTYPE_CELIANG_02%>')";
			conditionStr += " and (substr(account.dev_type,1,7) != '<%=DevConstants.MIXTYPE_CELIANG_03%>' and 'S'||substr(account.dev_type,0,6) != '<%=DevConstants.MIXTYPE_CELIANG_03%>')) ";
			conditionStr += " or ((substr(account.dev_type,1,9)='<%=DevConstants.MIXTYPE_JIANBOQI%>' or 'S'||substr(account.dev_type,0,8)='<%=DevConstants.MIXTYPE_JIANBOQI%>' ) ";
			conditionStr += " and (substr(account.dev_type,1,11)!='<%=DevConstants.MIXTYPE_SHUZIJIANBOQI%>' and 'S'||substr(account.dev_type,0,10)!='<%=DevConstants.MIXTYPE_SHUZIJIANBOQI%>')) ";
			conditionStr += " or (substr(account.dev_type,1,7)='<%=DevConstants.MIXTYPE_XIAOZHESHEYI%>' or 'S'||substr(account.dev_type,0,6)='<%=DevConstants.MIXTYPE_XIAOZHESHEYI%>' ) ";
			conditionStr += " or (substr(account.dev_type,1,9)='<%=DevConstants.MIXTYPE_JIANBOQICESHIYI%>' or 'S'||substr(account.dev_type,0,8)='<%=DevConstants.MIXTYPE_JIANBOQICESHIYI%>' )) ";
			
		}
		var str = "select account.dev_acc_id,account.asset_coding, ";
		str += "account.dev_coding,account.self_num,account.dev_sign, ";
		str += "account.license_num,account.actual_in_time,account.planning_out_time, ";
		str += "account.dev_name,account.dev_model ";
		str += "from gms_device_account_dui account ";
		str += "left join gms_device_account ca on account.fk_dev_acc_id = ca.dev_acc_id "
		str += "where account.bsflag = '0' and account.project_info_id='"+projectInfoNos+"' and account.actual_out_time is null ";
		str += "and (account.transfer_state is null or account.transfer_state = '4') ";
		//str += conditionStr;
		if(obj.selectStr != null){
			str += "and account.dev_acc_id not in ("+obj.selectStr+")";
		}
		str += "and account.account_stat!='0110000013000000005' ";
		str += "and account.is_leaving='0' and account.mix_type_id = '"+backdevtype+"' ";

		if(license_num!=undefined && license_num!=''){
			str+=" and account.license_num like '%"+license_num+"%'";
		}
		if(self_num!=undefined && self_num!=''){
			str+=" and account.self_num like '%"+self_num+"%'";
		}
		if(dev_sign!=undefined && dev_sign!=''){
			str+=" and account.dev_sign like '%"+dev_sign+"%'";
		}
		if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
			str += "and account.dev_name like '%"+v_dev_ci_name+"%' ";
		}
		if(v_dev_ci_model!=undefined && v_dev_ci_model!=''){
			str += "and account.dev_model like '%"+v_dev_ci_model+"%' ";
		}
	
		str += "order by account.dev_type ";
		//alert(str);
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
	$("#selectedboxAll").change(function(){
		var checkedval = this.checked;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			this.checked = checkedval;
		});
	});
	function submitInfo(){
		var length = 0;
		//返回信息是 队级台账id + AMIS资产编号 + 设备名称 + 规格型号 + 自编号 + 实物标识号 + 牌照号  |  记录2 | 记录3
		var selectedids = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				if(length != 0){
					selectedids += "|";
				}
				selectedids += this.value;
				var columnsObj = this.parentNode.parentNode.cells;
				selectedids += "~"+columnsObj[7].innerText+"~"+columnsObj[2].innerText+"~"+columnsObj[3].innerText;
				selectedids += "~"+columnsObj[4].innerText+"~"+columnsObj[6].innerText+"~"+columnsObj[5].innerText;
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录!");
			return;
		}
		if(confirm("确认提交？")){
			window.returnValue = selectedids;
			window.close();
		}
		//window.returnValue = selectedids;
		//window.close();
	}
	function dbclickRow(shuaId){
		var length = 0;
		//返回信息是 队级台账id + Amis资产编号 + 设备名称 + 规格型号 + 自编号 + 实物标识号 + 牌照号  |  记录2 | 记录3
		var selectedids = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				if(length != 0){
					selectedids += "|";
				}
				selectedids += this.value;
				var columnsObj = this.parentNode.parentNode.cells;
				selectedids += "~"+columnsObj[7].innerText+"~"+columnsObj[2].innerText+"~"+columnsObj[3].innerText;
				selectedids += "~"+columnsObj[4].innerText+"~"+columnsObj[6].innerText+"~"+columnsObj[5].innerText;
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录!");
			return;
		}
		if(confirm("确认提交？")){
			window.returnValue = selectedids;
			window.close();
		}
		//window.returnValue = selectedids;
		//window.close();
	}
	function newClose(){
		window.close();
	}
</script>
</html>