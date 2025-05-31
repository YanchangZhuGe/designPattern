<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String code = request.getParameter("code");
	String is_leaf = request.getParameter("is_leaf");
	String node_level = request.getParameter("node_level");
	String userOrgId = user == null || user.getOrgId() == null ? "" : user.getOrgId().trim();
	String subOrgId = user.getSubOrgIDofAffordOrg();
	String taskId = request.getParameter("taskId");
	String projectInfoNo = request.getParameter("projectInfoNo");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

  <title>项目页面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input"><input id="s_dev_name" name="s_dev_name" type="text" /></td>
			     <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input"><input id="s_dev_model" name="s_dev_model" type="text" /></td>
			    <td class="ali_cdn_name">所属单位</td>
			    <td class="ali_cdn_input">
			    	<input id="s_own_org_name" name="s_own_org_name" type="text" />
			    </td>
			    <td class="ali_cdn_input">
					<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOrgTreePage()"  />
					<input id="owning_org_id" name="owning_org_id" class="" type="hidden" />
			    </td>
      			<td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>		
			    <td>&nbsp;</td>
			    <td class="ali_cdn_name" ><a href="javascript:downloadModel('dev_model','设备导入')">设备模板</a></td>
			    <auth:ListButton functionId="" css="gl" event="onclick='newSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			    <auth:ListButton functionId="" css="dr" event="onclick='excelDataAdd()'" title="导入"></auth:ListButton>
				
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr >
					<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{dev_acc_id}' id='rdo_entity_id_{dev_acc_id}'  onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
					<td class="bt_info_even" exp="{dev_type}">设备编码</td>
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_model}">规格型号</td>
					<td class="bt_info_odd" exp="{self_num}">自编号</td>
					<td class="bt_info_even" exp="{license_num}">牌照号</td>
					<td class="bt_info_odd" exp="{producting_date}">投产日期</td>
					<td class="bt_info_even" exp="{asset_value}">固定资产原值</td>
					<td class="bt_info_odd" exp="{net_value}">固定资产净值</td>
					<td class="bt_info_even" exp="{owning_org_name_desc}">所属单位</td>
					<td class="bt_info_odd" exp="{usage_org_name_desc}">所在单位</td>
					<td class="bt_info_even" exp="{using_stat_desc}">使用情况</td>
					<td class="bt_info_odd" exp="{tech_stat_desc}">技术状况</td>
					<td class="bt_info_even" exp="{project_name_desc}">项目名称</td>
					<td class="bt_info_odd" exp="{dev_position}">所在位置</td>
					<td class="bt_info_even" exp="{ifcountry}">国内/国外</td>
					<td class="bt_info_odd" exp="{asset_coding}">AMIS资产编号</td>
					<td class="bt_info_even" exp="{cont_num}">合同编号</td>
					<td class="bt_info_odd" exp="{turn_num}">转资单号</td>
					<td class="bt_info_even" exp="{requ_num}">调拨单号</td>
					<td class="bt_info_odd" exp="{erp_id}">ERP设备编号</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_odd" exp="{account_stat_desc}">资产状况</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    <li id="tag3_1" ><a href="#" onclick="getTab3(1)">资产价值</a></li>
			    <li  id="tag3_2" ><a href="#" onclick="getTab3(2)">生产厂家</a></li>
			    <li  id="tag3_3" ><a href="#" onclick="getTab3(3)">随机资料</a></li>
			    <li  id="tag3_4" ><a href="#" onclick="getTab3(4)">主要技术参数</a></li>
			    <li id="tag3_5" ><a href="#" onclick="getTab3(5)">特种设备信息</a></li>
			    <li  id="tag3_6" ><a href="#" onclick="getTab3(6)">折旧年限</a></li>
			    <li id="tag3_7" ><a href="#" onclick="getTab3(7)">报废设备信息</a></li>
			    <li id="tag3_8"><a href="#" onclick="getTab3(8)">附件</a></li>
			    <li id="tag3_9"><a href="#" onclick="getTab3(9)">备注</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table id="devMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
						    <td class="inquire_item6">设备名称</td>
						    <td class="inquire_form6"><input id="dev_acc_name" name=""  class="input_width" type="text" /></td>
						    <td class="inquire_item6">规格型号</td>
						    <td class="inquire_form6"><input id="dev_acc_model" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">设备编码</td>
						    <td class="inquire_form6"><input id="dev_type" name="dev_type" class="input_width" type="text" /></td>
						 </tr>
						 <tr>
						    <td class="inquire_item6">实物标识号</td>
						    <td class="inquire_form6"><input id="dev_acc_sign" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">自编号</td>
						    <td class="inquire_form6"><input id="dev_acc_self" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">牌照号</td>
						    <td class="inquire_form6"><input id="dev_acc_license" name="" class="input_width" type="text" /></td>
						  </tr>
						  <tr>
						    
						    <td class="inquire_item6">资产编号</td>
						    <td class="inquire_form6"><input id="dev_acc_assetcoding" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">发动机号</td>
						    <td class="inquire_form6"><input id="dev_acc_engine_num" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">底盘号</td>
						    <td class="inquire_form6"><input id="dev_acc_chassis_num" name="" class="input_width" type="text" /></td>
						  </tr>
						  <tr>
						    <td class="inquire_item6">出厂编号</td>
						    <td class="inquire_form6"><input id="" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">出厂日期</td>
						    <td class="inquire_form6"><input id="dev_acc_producting_date" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">资产状况</td>
						    <td class="inquire_form6"><input id="dev_acc_asset_stat" name="" class="input_width" type="text" /></td>
						  </tr>
						   <tr>
						    <td class="inquire_item6">技术状况</td>
						    <td class="inquire_form6"><input id="dev_acc_tech_stat" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">使用状况</td>
						    <td class="inquire_form6"><input id="dev_acc_using_stat" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">项目名称</td>
						    <td class="inquire_form6"><input id="project_name_desc" name="project_name_desc" class="input_width" type="text" /></td>
						  </tr>
						               
			        </table>
				</div>
			<div id="tab_box_content1" class="tab_box_content" style="display:none;">
						<table id="assetTab" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
						    <td class="inquire_item6">固定资产原值</td>
						    <td class="inquire_form6"><input id="dev_acc_asset_value" name=""  class="input_width" type="text" /></td>
						    <td class="inquire_item6">固定资产净值</td>
						    <td class="inquire_form6"><input id="dev_acc_net_value" name="" class="input_width" type="text" /></td>
						 </tr>
					     </table>
			</div>
			<div id="tab_box_content2" class="tab_box_content" style="display:none;">
			
			</div>
			<div id="tab_box_content3" class="tab_box_content" style="display:none;">
			
			</div>
			<div id="tab_box_content4" class="tab_box_content" style="display:none;">
			
			</div>
			<div id="tab_box_content5" class="tab_box_content" style="display:none;">
			
			</div>
			<div id="tab_box_content6" class="tab_box_content" style="display:none;">
			
			</div>
			<div id="tab_box_content7" class="tab_box_content" style="display:none;">
			
			</div>
			<div id="tab_box_content8" class="tab_box_content" style="display:none;">
			
			</div>
			<div id="tab_box_content9" class="tab_box_content" style="display:none;">
				<table id="remarkTab" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
						    <td class="inquire_item6">备注</td>
						    <td class="inquire_form6"><input id="dev_acc_remark" name=""  class="input_width" type="text" /></td>
						 </tr>
				</table>
			</div>
		 </div>
</div>
</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var taskIds = '<%=taskId%>';
	var projectInfoNos = '<%=projectInfoNo%>';
	var node_level = '<%=node_level%>';
	var is_leaf = '<%=is_leaf%>';
	var userOrgId = '<%=userOrgId%>';

	function searchDevData(){
		var v_dev_name = document.getElementById("s_dev_name").value;
		var v_dev_model = document.getElementById("s_dev_model").value;
		//var v_dev_asset_stat = document.getElementById("s_dev_account_stat").value;
		var owning_org_id = document.getElementById("owning_org_id").value;
		var obj = new Array();
		obj.push({"label":"dev_name","value":v_dev_name});
		//obj.push({"label":"account_stat","value":v_dev_asset_stat});
		obj.push({"label":"dev_model","value":v_dev_model});
		obj.push({"label":"usage_sub_id","value":owning_org_id});
		refreshData(obj);
	}
	//点击树节点查询
	var code = '<%=code%>';
	code = code.replace("S","");//点根节点时去除S,只有根节点带S
	
	function refreshData(arrObj,content){
		var userid = '<%=subOrgId%>';
		var orgLength = userid.length;
		var sql = "";
		if(orgLength==4){
			sql += "select (case when org.org_abbreviation=usageorg.org_abbreviation then '' else usageorg.org_abbreviation end) use_name_desc,acc.dev_acc_id,acc.dev_unit,acc.dev_name,acc.dev_model,nvl2(ifcountry,ifcountry,'国内') as ifcountry,ci.dev_code,ci.dev_name as dev_type, "+
				"acc.self_num,acc.license_num,acc.producting_date,acc.asset_value,acc.net_value,acc.dev_position,acc.asset_coding,acc.cont_num,acc.turn_num,acc.requ_num,acc.dev_sign, "+
				"(select coding_name from comm_coding_sort_detail c where acc.using_stat=c.coding_code_id) as using_stat_desc, "+
				"(select coding_name from comm_coding_sort_detail c where acc.tech_stat=c.coding_code_id) as tech_stat_desc, "+
				"(select pro.project_name from gp_task_project pro where pro.project_info_no=acc.project_info_no) as project_name_desc, "+
				"(select coding_name from comm_coding_sort_detail co where co.coding_code_id=acc.account_stat) as account_stat_desc, "+
				"usageorg.org_abbreviation as usage_org,unitsd.coding_name as unit_name, (case when acc.usage_sub_id like 'C105001005%' then '塔里木物探处' else (case when acc.usage_sub_id like 'C105001002%' then '新疆物探处'else(case when acc.usage_sub_id like 'C105001003%' then '吐哈物探处'else(case when acc.usage_sub_id like 'C105001004%' then '青海物探处'else(case when acc.usage_sub_id like 'C105005004%' then '长庆物探处'else(case when acc.usage_sub_id like 'C105005000%' then '华北物探处'else(case when acc.usage_sub_id like 'C105005001%' then '新兴物探处'else(case when acc.usage_sub_id like 'C105007%' then '大港物探处'else(case when acc.usage_sub_id like 'C105063%' then '辽河物探处'else(case when acc.usage_sub_id like 'C105006%' then '装备服务处'else (case when acc.usage_sub_id like 'C105002%' then '国际勘探事业部'else (case when acc.usage_sub_id like 'C105003%' then '研究院'else (case when acc.usage_sub_id like 'C105008%' then '综合物化处'else (case when acc.usage_sub_id like 'C105015%' then '井中地震中心'else '' end) end) end) end) end) end) end) end) end) end) end) end) end) end) as owning_org_name "+
				",acc.usage_sub_id from gms_device_account_b acc  "+
				"left join GMS_DEVICE_CODEINFO cltype on cltype.dev_ci_code=acc.dev_type "+
				"left join GMS_DEVICE_COLL_MAPPING mp on mp.dev_ci_code=cltype.dev_ci_code "+
				"left join GMS_DEVICE_COLLECTINFO ci on ci.device_id=mp.device_id  "+
				"left JOIN comm_org_subjection c4 ON acc.owning_org_id  =c4.org_id "+
				"left join comm_org_information usageorg on acc.usage_org_id=usageorg.org_id  "+
				"left join comm_coding_sort_detail unitsd on acc.dev_unit=unitsd.coding_code_id  "+
				"where acc.bsflag='0' and ci.is_leaf = '1' and ci.dev_code not like '04%' and c4.org_subjection_id like '<%=subOrgId%>%' ";
				<%-- " union  "+
				"select acc.dev_acc_id,acc.dev_unit,acc.dev_name,acc.dev_model,nvl2(ifcountry,ifcountry,'国内') as ifcountry,ci.dev_code,ci.dev_name as dev_type, "+ 
				"acc.self_num,acc.license_num,acc.producting_date,acc.asset_value,acc.net_value,acc.dev_position,acc.asset_coding,acc.cont_num,acc.turn_num,acc.requ_num,acc.dev_sign, "+
				"(select coding_name from comm_coding_sort_detail c where acc.using_stat=c.coding_code_id) as using_stat_desc, "+
				"(select coding_name from comm_coding_sort_detail c where acc.tech_stat=c.coding_code_id) as tech_stat_desc, "+
				"(select pro.project_name from gp_task_project pro where pro.project_info_no=acc.project_info_no) as project_name_desc, "+
				"(select coding_name from comm_coding_sort_detail co where co.coding_code_id=acc.account_stat) as account_stat_desc, "+
				"usageorg.org_abbreviation as usage_org,unitsd.coding_name as unit_name, (case when acc.usage_sub_id like 'C105001005%' then '塔里木物探处' else (case when acc.usage_sub_id like 'C105001002%' then '新疆物探处'else(case when acc.usage_sub_id like 'C105001003%' then '吐哈物探处'else(case when acc.usage_sub_id like 'C105001004%' then '青海物探处'else(case when acc.usage_sub_id like 'C105005004%' then '长庆物探处'else(case when acc.usage_sub_id like 'C105005000%' then '华北物探处'else(case when acc.usage_sub_id like 'C105005001%' then '新兴物探处'else(case when acc.usage_sub_id like 'C105007%' then '大港物探处'else(case when acc.usage_sub_id like 'C105063%' then '辽河物探处'else(case when acc.usage_sub_id like 'C105006%' then '装备服务处'else (case when acc.usage_sub_id like 'C105002%' then '国际勘探事业部'else (case when acc.usage_sub_id like 'C105003%' then '研究院'else (case when acc.usage_sub_id like 'C105008%' then '综合物化处'else (case when acc.usage_sub_id like 'C105015%' then '井中地震中心'else '' end) end) end) end) end) end) end) end) end) end) end) end) end) end) as owning_org_name "+ 
				",acc.usage_sub_id from gms_device_account_b acc  "+
				"left join GMS_DEVICE_CODEINFO cltype on cltype.dev_ci_code=acc.dev_type "+
				"left join GMS_DEVICE_COLL_MAPPING mp on mp.dev_ci_code=cltype.dev_ci_code "+
				"left join GMS_DEVICE_COLLECTINFO ci on ci.device_id=mp.device_id  "+
				"left JOIN comm_org_subjection c4 ON acc.owning_org_id  =c4.org_id "+
				"left join comm_org_information usageorg on acc.usage_org_id=usageorg.org_id  "+
				"left join comm_coding_sort_detail unitsd on acc.dev_unit=unitsd.coding_code_id  "+
				"where acc.bsflag='0' and ci.is_leaf = '1' and ci.dev_code like '04%' and c4.org_subjection_id like '<%=subOrgId%>%' "+
				")tmp where 1=1  "; --%>
		}
		else{
			sql += "select (case when org.org_abbreviation=usageorg.org_abbreviation then '' else usageorg.org_abbreviation end) use_name_desc,acc.dev_acc_id,acc.dev_unit,acc.dev_name,acc.dev_model,nvl2(ifcountry,ifcountry,'国内') as ifcountry,ci.dev_code,ci.dev_name as dev_type, "+ 
			"acc.self_num,acc.license_num,acc.producting_date,acc.asset_value,acc.net_value,acc.dev_position,acc.asset_coding,acc.cont_num,acc.turn_num,acc.requ_num,acc.dev_sign, "+
			"(select coding_name from comm_coding_sort_detail c where acc.using_stat=c.coding_code_id) as using_stat_desc, "+
			"(select coding_name from comm_coding_sort_detail c where acc.tech_stat=c.coding_code_id) as tech_stat_desc, "+
			"(select pro.project_name from gp_task_project pro where pro.project_info_no=acc.project_info_no) as project_name_desc, "+
			"(select coding_name from comm_coding_sort_detail co where co.coding_code_id=acc.account_stat) as account_stat_desc, "+
			"usageorg.org_abbreviation as usage_org,unitsd.coding_name as unit_name,org.org_abbreviation as owning_org_name "+
			",acc.usage_sub_id from gms_device_account_b acc "+
			"left join GMS_DEVICE_CODEINFO cltype on cltype.dev_ci_code=acc.dev_type "+
			"left join GMS_DEVICE_COLL_MAPPING mp on mp.dev_ci_code=cltype.dev_ci_code "+
			"left join GMS_DEVICE_COLLECTINFO ci on ci.device_id=mp.device_id  "+
			"left JOIN comm_org_subjection c4 ON acc.owning_org_id  =c4.org_id "+
			"left join comm_org_information org on acc.owning_org_id=org.org_id "+
			"left join comm_org_information usageorg on acc.usage_org_id=usageorg.org_id "+
			"left join comm_coding_sort_detail unitsd on acc.dev_unit=unitsd.coding_code_id "+
			"where acc.bsflag='0' and ci.is_leaf = '1' and ci.dev_code not like '04%' and c4.org_subjection_id like '<%=subOrgId%>%' ";
			<%-- " union "+
			"select acc.dev_acc_id,acc.dev_unit,acc.dev_name,acc.dev_model,nvl2(ifcountry,ifcountry,'国内') as ifcountry,ci.dev_code,ci.dev_name as dev_type, "+ 
			"acc.self_num,acc.license_num,acc.producting_date,acc.asset_value,acc.net_value,acc.dev_position,acc.asset_coding,acc.cont_num,acc.turn_num,acc.requ_num,acc.dev_sign, "+
			"(select coding_name from comm_coding_sort_detail c where acc.using_stat=c.coding_code_id) as using_stat_desc, "+
			"(select coding_name from comm_coding_sort_detail c where acc.tech_stat=c.coding_code_id) as tech_stat_desc, "+
			"(select pro.project_name from gp_task_project pro where pro.project_info_no=acc.project_info_no) as project_name_desc, "+
			"(select coding_name from comm_coding_sort_detail co where co.coding_code_id=acc.account_stat) as account_stat_desc, "+
			"usageorg.org_abbreviation as usage_org,unitsd.coding_name as unit_name,org.org_abbreviation as owning_org_name "+
			",acc.usage_sub_id from gms_device_account_b acc "+
			"left join GMS_DEVICE_CODEINFO cltype on cltype.dev_ci_code=acc.dev_type "+
			"left join GMS_DEVICE_COLL_MAPPING mp on mp.dev_ci_code=cltype.dev_ci_code "+
			"left join GMS_DEVICE_COLLECTINFO ci on ci.device_id=mp.device_id  "+
			"left JOIN comm_org_subjection c4 ON acc.owning_org_id  =c4.org_id "+
			"left join comm_org_information org on acc.owning_org_id=org.org_id "+
			"left join comm_org_information usageorg on acc.usage_org_id=usageorg.org_id "+
			"left join comm_coding_sort_detail unitsd on acc.dev_unit=unitsd.coding_code_id "+
			"where acc.bsflag='0' and ci.is_leaf = '1' and ci.dev_code like '04%' and c4.org_subjection_id like '<%=subOrgId%>%'"+
			")tmp where 1=1 "; --%>
			}
		if(node_level=='null'||node_level=='0'){
			//如果是0级，不加条件
		}else if(is_leaf=='0'){
			//如果是非叶子节点，那么用code拼like
			sql += "and ci.dev_code like '"+code+"%'";
		}else if(is_leaf=='1'){
			//如果是叶子节点，那么用code拼=
			sql += "and ci.dev_code ='"+code+"'";
		}
		for(var key in arrObj) { 
			if(arrObj[key].value!=undefined && arrObj[key].value!=''){
					sql += " and tmp."+arrObj[key].label+" like '%"+arrObj[key].value+"%'";
			}
		}
		debugger;
		cruConfig.queryStr = sql;
		queryData(cruConfig.currentPage);
		createNewTitleTable();
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	
	//打开新增界面
	function toAdd(){
		popWindow("<%=contextPath%>/rm/dm/rfid/account/rfidAccountAdd.jsp"); 
	}

    //修改界面
    function toEdit(){  
		ids = getSelIds('rdo_entity_id');  
		if(ids==''){  alert("请选择一条信息!");  return;  }  
		
		var columnsObj ;
		$("input[type='checkbox']", "#queryRetTable").each(function(){
			if(this.checked){
				columnsObj = this.parentNode.parentNode.cells;
			}
		});
		if(columnsObj(10).innerText=="在账"){
			alert("此设备为在账设备，不允许修改");
			return;
		}
		
		selId = ids.split(',')[0]; 
		
		editUrl = "<%=contextPath%>/rm/dm/deviceAccount/toEdit.jsp?id={id}";  
		editUrl = editUrl.replace('{id}',selId); 
 
		//editUrl += '&pagerAction=edit2Edit';
	  		popWindow(editUrl); 
	  } 
	  //选择一条记录
	  function chooseOne(cb){   
        var obj = document.getElementsByName("rdo_entity_id");  
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else 
             {obj[i].checked = true;  
              checkvalue = obj[i].value;
             } 
        }   
	  }   
    
	//点击记录查询明细信息
    function loadDataDetail(shuaId){
    	var retObj;
		if(shuaId!=null){
			 retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfo", "deviceId="+shuaId);
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		     retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfo", "deviceId="+ids);
		}
		//取消选中框--------------------------------------------------------------------------
    	var obj = document.getElementsByName("rdo_entity_id");  
        for (i=0; i<obj.length; i++){   
            obj[i].checked = false;   
             
        } 
		//选中这一条checkbox
		$("#rdo_entity_id_"+retObj.deviceaccMap.dev_acc_id).attr("checked","checked");
		//------------------------------------------------------------------------------------
		document.getElementById("dev_acc_name").value =retObj.deviceaccMap.dev_name;
		document.getElementById("dev_acc_sign").value =retObj.deviceaccMap.dev_sign;
		document.getElementById("dev_acc_model").value =retObj.deviceaccMap.dev_model;
		document.getElementById("dev_acc_self").value =retObj.deviceaccMap.self_num;
		document.getElementById("dev_acc_license").value =retObj.deviceaccMap.license_num;
		document.getElementById("dev_acc_assetcoding").value =retObj.deviceaccMap.asset_coding;
		
		document.getElementById("dev_acc_using_stat").value =retObj.deviceaccMap.using_stat_desc;
		document.getElementById("dev_acc_tech_stat").value =retObj.deviceaccMap.tech_stat_desc;
		document.getElementById("dev_acc_producting_date").value =retObj.deviceaccMap.producting_date;
		document.getElementById("dev_acc_engine_num").value =retObj.deviceaccMap.engine_num;
		document.getElementById("dev_acc_chassis_num").value =retObj.deviceaccMap.chassis_num;
		document.getElementById("dev_acc_asset_stat").value =retObj.deviceaccMap.stat_desc;
		
		document.getElementById("dev_acc_asset_value").value =retObj.deviceaccMap.asset_value;
		document.getElementById("dev_acc_net_value").value =retObj.deviceaccMap.net_value;
		
		document.getElementById("dev_acc_remark").value =retObj.deviceaccMap.remark;
		document.getElementById("dev_type").value =retObj.deviceaccMap.dev_type;
		document.getElementById("project_name_desc").value =retObj.deviceaccMap.project_name_desc;
    }
	
	function toDelete(){
 		ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("DevCommInfoSrv", "deleteUpdate", "deviceId="+ids);
			queryData(cruConfig.currentPage);
		}
	}
	//打开查询条件页面
    function newSearch(){
    	popWindow('<%=contextPath%>/rm/dm/deviceAccount/devquery.jsp');
    }    
    //清空查询条件
    function clearQueryText(){
    	document.getElementById("s_dev_name").value="";
		document.getElementById("s_dev_account_stat").value="";
    }
    /**
	 * 选择组织机构树
	 */
	 
	function showOrgTreePage(){
		var returnValue={
			fkValue:"",
			value:""
		}
		window.showModalDialog("<%=contextPath%>/common/selectOrgSub.jsp",returnValue,"");
		document.getElementById("s_own_org_name").value = returnValue.value;
		
		//var orgId = strs[1].split(":");
		document.getElementById("owning_org_id").value = returnValue.fkValue;
	}
	function excelDataAdd(){
		popWindow('<%=contextPath%>/rm/dm/deviceAccount/devExcelAdd.jsp');
		}
	function downloadModel(modelname,filename){
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		window.location.href="<%=contextPath%>/rm/dm/xlsmodel/download.jsp?path=/rm/dm/deviceAccount/"+modelname+".xlsx&filename="+filename+".xlsx";
	}
	function createNewTitleTable(){
		// 如果是dialog
		if(window.dialogArguments){
			return;
		}
		
		// 如果声明了不出现固定表头
		if(window.showNewTitle==false){
			return;
		}
		
		var newTitleTable = document.getElementById("newTitleTable");
		if(newTitleTable!=null) return;
		var queryRetTable = document.getElementById("queryRetTable");
		if(queryRetTable==null) return;
		var titleRow = queryRetTable.rows(0);
		
		var newTitleTable = document.createElement("table");
		newTitleTable.id = "newTitleTable";
		newTitleTable.className="tab_info";
		newTitleTable.border="0";
		newTitleTable.cellSpacing="0";
		newTitleTable.cellPadding="0";
		newTitleTable.style.width = queryRetTable.clientWidth;
		newTitleTable.style.position="absolute";
		var x = getAbsLeft(queryRetTable);
		newTitleTable.style.left=x+"px";
		var y = getAbsTop(queryRetTable)-4;
		newTitleTable.style.top=y+"px";
		
		
		var tbody = document.createElement("tbody");
		var tr = titleRow.cloneNode(true);
		
		tbody.appendChild(tr);
		newTitleTable.appendChild(tbody);
		document.body.appendChild(newTitleTable);
		// 设置每一列的宽度
		for(var i=0;i<tr.cells.length;i++){
			tr.cells[i].style.width=titleRow.cells[i].clientWidth;
			if(i%2==0){
				tr.cells[i].className="bt_info_odd";
			}else{
				tr.cells[i].className="bt_info_even";
			}
			// 设置是否显示
			if(titleRow.cells[i].isShow=="Hide"){
				tr.cells[i].style.display='none';
			}
		}
		
		document.getElementById("table_box").onscroll = resetNewTitleTablePos;
		
	}
</script>
</html>