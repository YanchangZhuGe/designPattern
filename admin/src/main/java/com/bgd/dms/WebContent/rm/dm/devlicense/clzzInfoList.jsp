<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@taglib prefix="auth" uri="auth"%>
<%	
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<script type="text/javascript">

	function frameSize(){
		setTabBoxHeight();
	}
	frameSize();
	
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	});
	$(document).ready(lashen);
</script>
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "DevProSrv";
	cruConfig.queryOp = "queryDevLicInfo";
	
	function searchDevData(){
		var v_dev_name = document.getElementById("s_dev_name").value;
		var v_dev_model = document.getElementById("s_dev_model").value;
		var v_license_type = document.getElementById("s_license_type").value;
		var v_license_num= document.getElementById("s_license_num").value;
		var v_dev_sign= document.getElementById("s_dev_sign").value;
		var v_valid_day = document.getElementById("s_valid_day").value;
		refreshData(v_dev_name,v_dev_model,v_license_type,v_license_num,v_dev_sign,v_valid_day);
	}
	
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_dev_name").value="";
		document.getElementById("s_dev_model").value="";
		document.getElementById("s_license_type").value="";
		document.getElementById("s_license_num").value="";
		document.getElementById("s_dev_sign").value="";
		document.getElementById("s_valid_day").value="";
		refreshData('','','','','','');
    }
	function refreshData(v_dev_name,v_dev_model,v_license_type,v_license_num,v_dev_sign,v_valid_day){
		var str = "";	
		if(v_dev_name!=undefined && v_dev_name!=''){
			str += "&devname="+v_dev_name;
		}
		if(v_dev_model!=undefined && v_dev_model!=''){
			str += "&devmodel="+v_dev_model;
		}
		if(v_license_type!=undefined && v_license_type!=''){
			str += "&licensetype="+v_license_type;
		}
		if(v_license_num!=undefined && v_license_num!=''){
			str += "&licensenum="+v_license_num;
		}
		if(v_dev_sign!=undefined && v_dev_sign!=''){
			str += "&devsign="+v_dev_sign;
		}
		if(v_valid_day!=undefined && v_valid_day!=''){
			str += "&validday="+v_valid_day;
		}
		cruConfig.submitStr = str;
		queryData(1);
	}
	
    function loadDataDetail(shuaId){
    	var retObj;
		if(shuaId!=null){
			 retObj = jcdpCallService("DevProSrv", "queryDevLicDetInfo", "devlicenseid="+shuaId);			
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("DevProSrv", "queryDevLicDetInfo", "devlicenseid="+shuaId);
		}
		//取消其他选中的
		//$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.devLicMap.dev_acc_id+"']").removeAttr("checked");
		//选中这一条checkbox
		$("input[type='radio'][name='selectedbox'][id='selectedbox_"+retObj.devLicMap.dev_license_id+"']").attr("checked",'true');
		//------------------------------------------------------------------------------------
		$("#devname").val(retObj.devLicMap.dev_name);
		$("#devmodel").val(retObj.devLicMap.dev_model);
		$("#licensenum").val(retObj.devLicMap.license_num);
		$("#devcoding").val(retObj.devLicMap.dev_coding);
		$("#owningorg_name").val(retObj.devLicMap.owning_org_name);
		$("#usageorg_name").val(retObj.devLicMap.usage_org_name);
		$("#usestatname").val(retObj.devLicMap.usestat_name);
		$("#devstart_date").val(retObj.devLicMap.dev_start_date);
		$("#devend_date").val(retObj.devLicMap.dev_end_date);
		$("#devcgs_name").val(retObj.devLicMap.dev_cgs_name);
		$("#devuser_name").val(retObj.devLicMap.dev_user_name);
		$("#devzs_no").val(retObj.devLicMap.dev_zs_no);
		$("#licensetype_name").val(retObj.devLicMap.license_type_name);
		$("#lastaudit_date").val(retObj.devLicMap.last_audit_date);
		$("#remark").val(retObj.devLicMap.remark);
    }
    //查看审验明细
	function viewAuditDet(devaccid,licensetype){
		popWindow('<%=contextPath%>/rm/dm/devlicense/clzzAuditDetInfo.jsp?devaccid='+devaccid+'&licensetype='+licensetype,'1024:580');
	}
</script>
  <title>车辆证照管理</title>
 </head>
 <body style="background:#fff" onload="searchDevData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input"><input id="s_dev_name" height:40px; name="s_dev_name" type="text" /></td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input"><input id="s_dev_model" name="s_dev_model" type="text" /></td>
			    <td class="ali_cdn_name">车牌号</td>
			    <td class="ali_cdn_input"><input id="s_license_num" name="s_license_num" type="text" /></td>
			    <td class="ali_cdn_name" style="width:110px;">实物标识号</td>
			    <td class="ali_cdn_input"><input id="s_dev_sign" name="s_dev_sign" type="text" /></td>
			    <td class="ali_cdn_name">有效天数</td>
			    <td class="ali_cdn_input">
			    <select name="s_valid_day" id="s_valid_day">
					<option value="" selected="selected">--请选择--</option>
					<option value="30">1个月内</option>
					<option value="60">2个月内</option>
					<option value="90">3个月内</option>
			    </select></td>
			    <td class="ali_cdn_name">证照类型</td>
			    <td class="ali_cdn_input">
			    <select name="s_license_type" id="s_license_type">
					<option value="" selected="selected">--请选择--</option>
					<option value="001">车辆行驶证</option>
					<option value="002">车辆道路运输证</option>
					<option value="003">危货运输车辆检测</option>
					<option value="004">危险品运输证</option>
					<option value="005">车辆二级维护</option>					
			    </select></td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr >
			     	<td class="bt_info_even" exp="<input type='radio' name='selectedbox'  value='{dev_license_id}' id='selectedbox_{dev_license_id}' />" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="<img src='<%=contextPath%>/pm/projectHealthInfo/head{warn}.jpg' style='cursor: pointer;' width='14px' height='14px'/> " >审验状况</td>
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_model}">设备型号</td>
					<td class="bt_info_odd" exp="{license_num}">牌照号</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_odd" exp="{dev_coding}">ERP编号</td>
					<td class="bt_info_even" exp="{license_type_name}">证照类型</td>
					<td class="bt_info_odd" exp="{dev_zs_no}">机动车登记证书编号</td>
					<td class="bt_info_even" exp="{dev_reg_date}">注册登记日期</td>
					<td class="bt_info_odd" exp="{dev_start_date}">有效起始日期</td>
					<td class="bt_info_even" exp="{dev_end_date}">有效截止日期</td>
					<td class="bt_info_odd" exp="{valid_day}">有效天数</td>
					<td class="bt_info_even" exp="<a onclick=viewAuditDet('{dev_acc_id}','{license_type}')><font color='blue'>查看</font></a>">审验明细</td>
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
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0" ><a href="####" onclick="getContentTab(this,0)">基本信息</a></li>
			    <!-- <li id="tag3_1" ><a href="####" onclick="getContentTab(this,1)">审验明细</a></li> -->
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
						<td class="inquire_item6">设备名称</td>
						<td class="inquire_form6"><input id="devname" name="devname" class="input_width" type="text" /></td>
						<td class="inquire_item6">设备型号</td>
						<td class="inquire_form6"><input id="devmodel" name="devmodel" class="input_width" type="text" /></td>
						<td class="inquire_item6">牌照号</td>
						<td class="inquire_form6"><input id="licensenum" name="licensenum" class="input_width" type="text" /></td>
					  </tr>
					  <tr>
						<td class="inquire_item6">设备编号</td>
						<td class="inquire_form6"><input id="devcoding" name="devcoding" class="input_width" type="text" /></td>
						<td class="inquire_item6">所属单位</td>
						<td class="inquire_form6"><input id="owningorg_name" name="owningorg_name" class="input_width" type="text" /></td>
						<td class="inquire_item6">所在单位</td>
						<td class="inquire_form6"><input id="usageorg_name" name="usageorg_name" class="input_width" type="text" /></td>
					  </tr>
					  <tr>
						<td class="inquire_item6">使用情况</td>
						<td class="inquire_form6"><input id="usestatname" name="usestatname" class="input_width" type="text" /></td>
						<td class="inquire_item6">有效起始日期</td>
						<td class="inquire_form6"><input id="devstart_date" name="devstart_date" class="input_width" type="text" /></td>
						<td class="inquire_item6">有效截止日期</td>
						<td class="inquire_form6"><input id="devend_date" name="devend_date" class="input_width" type="text" /></td>					
					  </tr>
					  <tr>
					  	<td class="inquire_item6">末次审核时间</td>
						<td class="inquire_form6"><input id="lastaudit_date" name="lastaudit_date" class="input_width" type="text" /></td>
						<td class="inquire_item6">车管所名称</td>
						<td class="inquire_form6"><input id="devcgs_name" name="devcgs_name" class="input_width" type="text" /></td>
						<td class="inquire_item6">注册登记户主名称</td>
						<td class="inquire_form6"><input id="devuser_name" name="devuser_name" class="input_width" type="text" /></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6">机动车登记证书编号</td>
						<td class="inquire_form6"><input id="devzs_no" name="devzs_no" class="input_width" type="text" /></td>
						<td class="inquire_item6">证照类型</td>
						<td class="inquire_form6"><input id="licensetype_name" name="licensetype_name" class="input_width" type="text" /></td>
					  </tr>
					  <tr>
					  	<td class="inquire_item6">备注</td>
						<td class="inquire_form6" colspan="5">
						<textarea rows="30" cols="30"  id="remark" name="remark" class="input_width"></textarea>
						</td>
					  </tr>
					</table>
				</div>
		 	</div>
		</div>
	</body>
</html>