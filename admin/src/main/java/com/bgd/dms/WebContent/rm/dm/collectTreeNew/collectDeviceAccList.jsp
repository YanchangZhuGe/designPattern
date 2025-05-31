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
	
	String userSubid = user.getOrgSubjectionId();
	//String orgId= user.getOrgId();
	String orgType="";
	String dgOrg="C6000000000039,C6000000000040,C6000000005269,C6000000005280,C6000000005275,C6000000005279,C6000000005278,C6000000007366";
	//大港8个服务中心判断标志
	if(dgOrg.contains(userOrgId)){
		orgType="Y";
	}else{
		orgType="N";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>项目页面</title> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open2.js"></script>
 </head> 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input"><input id="query_dev_name" name="query_dev_name" type="text" /></td>
			    <td class="ali_cdn_name">设备型号</td>
			    <td class="ali_cdn_input">
			    <input id="type_id" name="type_id" type="text" />
      			</td>
      			<td class="ali_cdn_name">所属单位</td>
			    <td class="ali_cdn_input">
			    	<input id="s_own_org_name" name="s_own_org_name" type="text" />
			    </td>
			     <td class="ali_cdn_input">
					<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOrgTreePage()"  />
					<input id="owning_org_id" name="owning_org_id" class="" type="hidden" />
					<input id="owning_sub_org_id" name="owning_sub_org_id" class="" type="hidden" />
			    </td>
      			<td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
			         			
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="gl" event="onclick='newSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" class="tab_info" id="queryRetTable">		
			     <tr >
					<td class="bt_info_even" exp="<input type='checkbox' name='rdo_entity_id' value='{dev_acc_id}' id='rdo_entity_id_{dev_acc_id}' />" >选择</td>
					<td class="bt_info_odd" exp="{dev_name}">采集设备名称</td>
					<td class="bt_info_even" exp="{dev_type}">采集设备类型</td>
					<td class="bt_info_odd" exp="{dev_model}">采集设备型号</td>
					<td class="bt_info_even" exp="{unit_name}">计量单位</td>
					<td class="bt_info_odd" exp="{owning_org_name}">所属单位</td>
					<td class="bt_info_even" exp="{usage_org_name}">所在单位</td>
					<td class="bt_info_odd" exp="{total_num}">总数量</td>
					<td class="bt_info_even" exp="{unuse_num}">闲置数量</td>
					<td class="bt_info_odd" exp="{use_num}">在用数量</td>
					<td class="bt_info_even" exp="{other_num}">其他数量</td>
					<td class="bt_info_odd" exp="{ifcountry}">国内/国外</td>
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
			    <li id="tag3_1" ><a href="#" onclick="getTab3(1)">技术状况</a></li>
			    <li id="tag3_2" ><a href="#" onclick="getTab3(2)">台账变更记录</a></li>
			    <li id="tag3_3" ><a href="#" onclick="getTab3(3)">项目分布</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table id="devMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	 <tr>
						    <td class="inquire_item6">采集设备名称</td>
						    <td class="inquire_form6"><input id="dev_name" name="dev_name"  class="input_width" type="text" /></td>
						    <td class="inquire_item6">采集设备类型</td>
						    <td class="inquire_form6"><input id="dev_type" name="dev_type" class="input_width" type="text" /></td>
						    <td class="inquire_item6">采集设备型号</td>
						    <td class="inquire_form6"><input id="dev_model" name="dev_model" class="input_width" type="text" /></td>
						 </tr>
						 <tr>
						    <td class="inquire_item6">所在单位</td>
						    <td class="inquire_form6"><input id="usage_org" name="usage_org" class="input_width" type="text" /></td>
						     <td class="inquire_item6">计量单位</td>
						    <td class="inquire_form6"><input id="unit_name" name="unit_name" class="input_width" type="text" /></td>
						    <td class="inquire_item6">所在位置</td>
						    <td class="inquire_form6"><input id="dev_position" name="dev_position" class="input_width" type="text" /></td>
						 </tr>
						 <tr>
						    <td class="inquire_item6">总数量</td>
						    <td class="inquire_form6"><input id="total_num" name="total_num" class="input_width" type="text" /></td>
						    <td class="inquire_item6">闲置数量</td>
						    <td class="inquire_form6"><input id="unuse_num" name="unuse_num" class="input_width" type="text" /></td>
						    <td class="inquire_item6">在用数量</td>
						    <td class="inquire_form6"><input id="use_num" name="use_num" class="input_width" type="text" /></td>
						 </tr>
						  <tr>
						    <td class="inquire_item6">其它数量</td>
						    <td class="inquire_form6"><input id="other_num" name="other_num" class="input_width" type="text" /></td>
						 </tr>
			        </table>
				</div>
			<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				  	<tr align="right">
				  		<td class="ali_cdn_name" ></td>
				  		<td class="ali_cdn_input" ></td>
				  		<td class="ali_cdn_name" ></td>
				  		<td class="ali_cdn_input" ></td>
				  		<td>&nbsp;</td>
						<!--<auth:ListButton functionId="" css="xg" event="onclick='toEditTech()'" title="JCDP_btn_edit"></auth:ListButton>-->
					</tr>
				</table>
				<table id="tab_dev_tech" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
						    <td class="inquire_item6">完好</td>
						    <td class="inquire_form6"><input id="good_num" name="good_num"  class="input_width" type="text" /></td>
						    <td class="inquire_item6">待报废</td>
						    <td class="inquire_form6"><input id="touseless_num" name="touseless_num" class="input_width" type="text" /></td>
						    <td class="inquire_item6">维修</td>
						    <td class="inquire_form6"><input id="torepair_num" name="torepair_num" class="input_width" type="text" /></td>
						</tr>
						<tr>    
						    <td class="inquire_item6">盘亏</td>
						    <td class="inquire_form6"><input id="tocheck_num" name="tocheck_num" class="input_width" type="text" /></td>
						    <td class="inquire_item6">毁损</td>
						    <td class="inquire_form6"><input id="destroy_num" name="destroy_num" class="input_width" type="text" /></td>
						 </tr>
				</table>
			</div>
			<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<table id="tab_dev_rec" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    <tr class="bt_info">
			    		<td class="bt_info_odd" width="5%">序号</td>
						<td class="bt_info_even" width="11%">操作类型</td>
						<td class="bt_info_odd" width="11%">操作时间</td>
						<td class="bt_info_even" width="11%">操作数量</td>
						<td class="bt_info_odd" width="11%">总数量</td>
						<td class="bt_info_even" width="6%">闲置数量</td>
						<td class="bt_info_odd" width="6%">在用数量</td>
						<td class="bt_info_even" width="6%">其他数量</td>
						<td class="bt_info_odd" width="6%">完好数量</td>
						<td class="bt_info_even" width="6%">维修数量</td>
						<td class="bt_info_odd" width="6%">盘亏数量</td>
						<td class="bt_info_even" width="6%">毁损数量</td>
			        </tr>
			        <tbody id="recDetailList" name="recDetailList" ></tbody>
				</table>
			</div>
			<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				<table id="tab_dev_rec" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    <tr class="bt_info">
			    		<td class="bt_info_odd" width="5%">序号</td>
						<td class="bt_info_even" width="11%">项目名称</td>
						<td class="bt_info_odd" width="11%">在用数量</td>
						<td class="bt_info_even" width="11%">所在单位</td>
						<td class="bt_info_odd" width="11%">实际进场时间</td>
			        </tr>
			        <tbody id="proDetailList" name="proDetailList" ></tbody>
				</table>
			</div>
		 </div>
</div>

<script >
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var orgtype = '<%=orgType%>';//大港8个专业化中心判断
	var usersubid = '<%=userSubid%>';
	var node_level = '<%=node_level%>';
	var is_leaf = '<%=is_leaf%>';
	var code = '<%=code%>';
	var userOrgId = '<%=userOrgId%>';
	var selectedTagIndex = 0;
	var userid = '<%=subOrgId%>';
	var orgLength = userid.length;
	//下拉时查询
	function selectRefreshData(){
	    searchDevData();
	}
	function searchDevData(){
		var query_dev_name = document.getElementById("query_dev_name").value;
		var query_dev_type = document.getElementById("type_id").value;
		var owning_org_id = document.getElementById("owning_org_id").value;
		var owning_sub_org_id = document.getElementById("owning_sub_org_id").value;
		var obj = new Array();
		obj.push({"label":"dev_name","value":query_dev_name});
		obj.push({"label":"dev_model","value":query_dev_type});	
		if(owning_sub_org_id == 'C105001005' || owning_sub_org_id == 'C105001002' || owning_sub_org_id == 'C105001003' 
			|| owning_sub_org_id == 'C105001004' || owning_sub_org_id == 'C105005004' || owning_sub_org_id == 'C105005000'
			 || owning_sub_org_id == 'C105005001' || owning_sub_org_id == 'C105007' || owning_sub_org_id == 'C105063'
			  || owning_sub_org_id == 'C105006' || owning_sub_org_id == 'C105002' || owning_sub_org_id == 'C105003' 
			   || owning_sub_org_id == 'C105008' || owning_sub_org_id == 'C105015'){
			
			obj.push({"label":"org_subjection_id","value":owning_sub_org_id});
		}else{
			obj.push({"label":"owning_org_id","value":owning_org_id});
		}	
		refreshData(obj);
	}
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("query_dev_name").value="";
		document.getElementById("type_id").value="";
		document.getElementById("owning_org_id").value="";
		document.getElementById("s_own_org_name").value="";
    }
	//点击树节点查询
	function refreshData(arrObj){

		//var sql = "";
		//if(orgLength==4){
		//	sql += "select tmp.*,(case when tmp.owning_org_name=tmp.usage_org then '' else tmp.usage_org end)use_name_desc from (select acc.owning_org_id,acc.usage_org_id,acc.dev_acc_id,acc.dev_unit,acc.total_num,acc.unuse_num,acc.dev_name,acc.dev_model,acc.use_num,case when acc.ifcountry='000' then '国内' else acc.ifcountry end as ifcountry,acc.other_num,ci.dev_code,ci.dev_name as dev_type, "+
		//			"usageorg.org_abbreviation as usage_org,unitsd.coding_name as unit_name, (case when acc.usage_sub_id like 'C105001005%' then '塔里木物探处' else (case when acc.usage_sub_id like 'C105001002%' then '新疆物探处'else(case when acc.usage_sub_id like 'C105001003%' then '吐哈物探处'else(case when acc.usage_sub_id like 'C105001004%' then '青海物探处'else(case when acc.usage_sub_id like 'C105005004%' then '长庆物探处'else(case when acc.usage_sub_id like 'C105005000%' then '华北物探处'else(case when acc.usage_sub_id like 'C105005001%' then '新兴物探处'else(case when acc.usage_sub_id like 'C105007%' then '大港物探处'else(case when acc.usage_sub_id like 'C105063%' then '辽河物探处'else(case when acc.usage_sub_id like 'C105006%' then '装备服务处'else (case when acc.usage_sub_id like 'C105002%' then '国际勘探事业部'else (case when acc.usage_sub_id like 'C105003%' then '研究院'else (case when acc.usage_sub_id like 'C105008%' then '综合物化处'else (case when acc.usage_sub_id like 'C105015%' then '井中地震中心'else '' end) end) end) end) end) end) end) end) end) end) end) end) end) end) as owning_org_name "+
		//			",acc.usage_sub_id from gms_device_coll_account acc "+
		//			"left join gms_device_collectinfo ci on acc.device_id=ci.device_id "+
		//			"left join comm_org_information usageorg on acc.usage_org_id=usageorg.org_id "+
		//			"left join comm_coding_sort_detail unitsd on acc.dev_unit=unitsd.coding_code_id "+
		//			"where acc.bsflag='0' and ci.is_leaf = '1' and ci.dev_code not like '04%' and acc.usage_sub_id like '<%=subOrgId%>%' "+
		//			" union "+
		//			"select acc.owning_org_id,acc.usage_org_id,acc.dev_acc_id,acc.dev_unit,acc.total_num*100,acc.unuse_num*100,acc.dev_name,acc.dev_model,acc.use_num*100,case when acc.ifcountry='000' then '国内' else acc.ifcountry end as ifcountry,acc.other_num*100,ci.dev_code,ci.dev_name as dev_type, "+
		//			"usageorg.org_abbreviation as usage_org,unitsd.coding_name as unit_name, (case when acc.usage_sub_id like 'C105001005%' then '塔里木物探处' else (case when acc.usage_sub_id like 'C105001002%' then '新疆物探处'else(case when acc.usage_sub_id like 'C105001003%' then '吐哈物探处'else(case when acc.usage_sub_id like 'C105001004%' then '青海物探处'else(case when acc.usage_sub_id like 'C105005004%' then '长庆物探处'else(case when acc.usage_sub_id like 'C105005000%' then '华北物探处'else(case when acc.usage_sub_id like 'C105005001%' then '新兴物探处'else(case when acc.usage_sub_id like 'C105007%' then '大港物探处'else(case when acc.usage_sub_id like 'C105063%' then '辽河物探处'else(case when acc.usage_sub_id like 'C105006%' then '装备服务处'else (case when acc.usage_sub_id like 'C105002%' then '国际勘探事业部'else (case when acc.usage_sub_id like 'C105003%' then '研究院'else (case when acc.usage_sub_id like 'C105008%' then '综合物化处'else (case when acc.usage_sub_id like 'C105015%' then '井中地震中心'else '' end) end) end) end) end) end) end) end) end) end) end) end) end) end) as owning_org_name "+
		//			",acc.usage_sub_id from gms_device_coll_account acc "+
	//				"left join gms_device_collectinfo ci on acc.device_id=ci.device_id "+
		//			"left join comm_org_information usageorg on acc.usage_org_id=usageorg.org_id "+
		//			"left join comm_coding_sort_detail unitsd on acc.dev_unit=unitsd.coding_code_id "+
		//			"where acc.bsflag='0' and ci.is_leaf = '1' and ci.dev_code like '04%' and acc.usage_sub_id like '<%=subOrgId%>%'"+
		//			")tmp where 1=1 ";
	//	}else{
	//		sql += "select tmp.*,(case when tmp.owning_org_name=tmp.usage_org then '' else tmp.usage_org end)use_name_desc from (select acc.owning_org_id,acc.usage_org_id,acc.dev_acc_id,acc.dev_unit,acc.total_num,acc.unuse_num,acc.dev_name,acc.dev_model,acc.use_num,case when acc.ifcountry='000' then '国内' else acc.ifcountry end as ifcountry,acc.other_num,ci.dev_code,ci.dev_name as dev_type, "+
		//	"usageorg.org_abbreviation as usage_org,unitsd.coding_name as unit_name, org.org_abbreviation as owning_org_name "+
		//	",acc.usage_sub_id from gms_device_coll_account acc "+
		//	"left join gms_device_collectinfo ci on acc.device_id=ci.device_id "+
		//	"left join comm_org_information org on acc.owning_org_id=org.org_id "+
		//	"left join comm_org_information usageorg on acc.usage_org_id=usageorg.org_id "+
		//	"left join comm_coding_sort_detail unitsd on acc.dev_unit=unitsd.coding_code_id "+
	//		"where acc.bsflag='0' and ci.is_leaf = '1' and ci.dev_code not like '04%' and acc.usage_sub_id like '<%=subOrgId%>%' "+
		//	" union "+
		//	"select acc.owning_org_id,acc.usage_org_id,acc.dev_acc_id,acc.dev_unit,acc.total_num,acc.unuse_num,acc.dev_name,acc.dev_model,acc.use_num,case when acc.ifcountry='000' then '国内' else acc.ifcountry end as ifcountry,acc.other_num*100,ci.dev_code,ci.dev_name as dev_type, "+
		//	"usageorg.org_abbreviation as usage_org,unitsd.coding_name as unit_name,org.org_abbreviation as owning_org_name "+
		//	",acc.usage_sub_id from gms_device_coll_account acc "+
		//	"left join gms_device_collectinfo ci on acc.device_id=ci.device_id "+
		//	"left join comm_org_information org on acc.owning_org_id=org.org_id "+
		//	"left join comm_org_information usageorg on acc.usage_org_id=usageorg.org_id "+
		//	"left join comm_coding_sort_detail unitsd on acc.dev_unit=unitsd.coding_code_id "+
		//	"where acc.bsflag='0' and ci.is_leaf = '1' and ci.dev_code like '04%' and acc.usage_sub_id like '<%=subOrgId%>%'"+
		//	")tmp where 1=1 ";
		//	}
		var sql = "";
		if(orgLength==4){
			sql += "select tmp.* from (select acc.owning_org_id,suborg.org_subjection_id,acc.usage_org_id,acc.dev_acc_id,acc.dev_unit,nvl(acc.total_num, 0) total_num,nvl(acc.unuse_num, 0) unuse_num,acc.dev_name,acc.dev_model,nvl(acc.use_num, 0) use_num,case when acc.ifcountry='000' then '国内' else acc.ifcountry end as ifcountry,nvl(acc.other_num, 0) other_num,ci.dev_code,ci.dev_name as dev_type, "+
					"usageorg.org_abbreviation as usage_org_name,unitsd.coding_name as unit_name, case when suborg.org_subjection_id like 'C105001005%' then '塔里木物探处' when suborg.org_subjection_id like 'C105001002%' then '新疆物探处' when suborg.org_subjection_id like 'C105001003%' then '吐哈物探处' when suborg.org_subjection_id like 'C105001004%' then '青海物探处' when suborg.org_subjection_id like 'C105005004%' then '长庆物探处' when suborg.org_subjection_id like 'C105005000%' then '华北物探处' when suborg.org_subjection_id like 'C105005001%' then '新兴物探处' when suborg.org_subjection_id like 'C105007%' then '大港物探处' when suborg.org_subjection_id like 'C105063%' then '辽河物探处' when suborg.org_subjection_id like 'C105006%' then '装备服务处' when suborg.org_subjection_id like 'C105002%' then '国际勘探事业部' when suborg.org_subjection_id like 'C105003%' then '研究院'  when suborg.org_subjection_id like 'C105008%' then '综合物化处' when suborg.org_subjection_id like 'C105015%' then '井中地震中心'else '' end as owning_org_name "+
					",acc.usage_sub_id from gms_device_coll_account acc "+
					"left join gms_device_collectinfo ci on acc.device_id=ci.device_id "+
					"left join comm_org_information usageorg on acc.usage_org_id=usageorg.org_id and usageorg.bsflag = '0' "+
					"left join comm_org_subjection suborg on acc.owning_org_id = suborg.org_id and suborg.bsflag = '0' "+
					"left join comm_coding_sort_detail unitsd on acc.dev_unit=unitsd.coding_code_id "+
					"where acc.bsflag='0' and ci.is_leaf = '1' and ( acc.owning_sub_id like '<%=subOrgId%>%' or acc.usage_sub_id like '<%=subOrgId%>%' ) "+
					")tmp where 1=1 ";
		}else{
			sql += "select tmp.* from (select acc.dev_acc_id,acc.dev_unit,nvl(acc.total_num, 0) total_num,nvl(acc.unuse_num, 0) unuse_num,acc.dev_name,acc.dev_model,nvl(acc.use_num, 0) use_num,case when acc.ifcountry='000' then '国内' else acc.ifcountry end as ifcountry,nvl(acc.other_num, 0) other_num,ci.dev_code,ci.dev_name as dev_type, "+
					"usageorg.org_abbreviation as usage_org_name,owingorg.org_abbreviation as owning_org_name,unitsd.coding_name as unit_name, org.org_abbreviation as org_name,acc.usage_sub_id,acc.usage_org_id,acc.owning_org_id,acc.owning_sub_id,suborg.org_subjection_id "+
					"from gms_device_coll_account acc "+
					"left join gms_device_collectinfo ci on acc.device_id=ci.device_id "+
					"left join comm_org_information org on acc.owning_org_id=org.org_id and org.bsflag = '0' "+
					"left join comm_org_information usageorg on acc.usage_org_id=usageorg.org_id and usageorg.bsflag = '0' "+
					"left join comm_org_information owingorg on acc.owning_org_id=owingorg.org_id and owingorg.bsflag = '0' "+
					"left join comm_org_subjection suborg on acc.owning_org_id = suborg.org_id and suborg.bsflag = '0' "+
					"left join comm_coding_sort_detail unitsd on acc.dev_unit=unitsd.coding_code_id ";
			if(orgtype == 'Y'){//大港8个专业化中心只能看到自己中心的数据
				sql += "where acc.bsflag='0' and ci.is_leaf = '1' and ( acc.owning_sub_id like '"+usersubid+"%' or acc.usage_sub_id like '"+usersubid+"%' ) ";
			}else{
				sql += "where acc.bsflag='0' and ci.is_leaf = '1' and ( acc.owning_sub_id like '<%=subOrgId%>%' or acc.usage_sub_id like '<%=subOrgId%>%' ) ";
			}
					
			sql +=	")tmp where 1=1 ";
		}
		if(node_level=='null'||node_level=='0'){
			//如果是0级，不加条件
		}else if(is_leaf=='0'){
			//如果是非叶子节点，那么用code拼like
			sql += "and tmp.dev_code like '"+code+"%'";
		}else if(is_leaf=='1'){
			//如果是叶子节点，那么用code拼=
			sql += "and tmp.dev_code ='"+code+"'";
		}
		
		for(var key in arrObj){
			if(arrObj[key].value!=undefined && arrObj[key].value!=''){
				sql += " and tmp."+arrObj[key].label+" like '%"+arrObj[key].value+"%'";
			}
		}
		cruConfig.queryStr = sql;
		queryData(cruConfig.currentPage);
		createNewTitleTable();
	}
	//打开新增界面
	function toAdd(){   
		popWindow("<%=contextPath%>/rm/dm/collectTreeNew/toAdd.jsp"); 
	}
    //修改界面
    function toEdit(){  
     	 ids = getSelIds('rdo_entity_id');  
	 	 if(ids==''){  alert("请选择一条信息!");  return;  }  
	 	 selId = ids.split(',')[0]; 
	 	 editUrl = "<%=contextPath%>/rm/dm/collectTreeNew/toEdit.jsp?id={id}";  
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
			 retObj = jcdpCallService("DevCommInfoSrv", "getCollectDevAccInfo", "deviceAccId="+shuaId);
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    shuaId = ids;
		    retObj = jcdpCallService("DevCommInfoSrv", "getCollectDevAccInfo", "deviceAccId="+ids);
		}
		//取消选中框--------------------------------------------------------------------------
    	var obj = document.getElementsByName("rdo_entity_id");  
        for (i=0; i<obj.length; i++){   
            obj[i].checked = false;   
        } 
		//选中这一条checkbox
		$("#rdo_entity_id_"+retObj.deviceaccMap.dev_acc_id).attr("checked","checked");
		//------------------------------------------------------------------------------------
		for(var i in retObj.deviceaccMap){
			if(i == 'type_id'){
				continue;
			}
			$("#"+i).val(retObj.deviceaccMap[i]);
		}
		//给变更记录也回填
		var detSql = "select * from gms_device_coll_record where dev_acc_id='"+shuaId+"' order by create_date";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+detSql+"&pageSize=1000");
		basedatas = queryRet.datas;
		
		//项目分布
		var proSql = "select pro.project_name, t.unuse_num, info.org_abbreviation,t.actual_in_time from gms_device_coll_account_dui t ";
			proSql += "left join gp_task_project pro on t.project_info_id = pro.project_info_no ";
			proSql += "left join comm_org_information info on info.org_id = t.in_org_id ";
			proSql += "where t.fk_dev_acc_id ='"+shuaId+"' and t.is_leaving = '0' ";
		var queryProRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql+"&pageSize=1000");
			basedatasPro = queryProRet.datas;
			
		if(basedatas!=undefined && basedatas.length>=1){
			//先清空
			var filtermapid = "#recDetailList";
			$(filtermapid).empty();
			appendDataToDetailTab(filtermapid,basedatas);
			var filtermapproid = "#proDetailList";
			$(filtermapproid).empty();
			appendDataToDetailPro(filtermapproid,basedatasPro);
		}else if(basedatasPro!=undefined && basedatasPro.length>=1){
			//先清空
			var filtermapid = "#recDetailList";
			$(filtermapid).empty();
			appendDataToDetailTab(filtermapid,basedatas);
			var filtermapproid = "#proDetailList";
			$(filtermapproid).empty();
			appendDataToDetailPro(filtermapproid,basedatasPro);
		}else{
			var filtermapid = "#recDetailList";
			$(filtermapid).empty();
			var filtermapproid = "#proDetailList";
			$(filtermapproid).empty();
		}
    }
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].rectype+"</td><td>"+datas[i].recdate+"</td>";
			innerHTML += "<td>"+datas[i].opr_num+"</td><td>"+datas[i].total_num+"</td>";
			innerHTML += "<td>"+datas[i].unuse_num+"</td><td>"+datas[i].use_num+"</td><td>"+datas[i].other_num+"</td>";
			innerHTML += "<td>"+datas[i].wanhao_num+"</td><td>"+datas[i].weixiu_num+"</td>";
			innerHTML += "<td>"+datas[i].pankui_num+"</td><td>"+datas[i].huisun_num+"</td>";
			innerHTML += "</tr>";
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	function appendDataToDetailPro(filterobj,datas){
		for(var i=0;i<basedatasPro.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td>";
			innerHTML += "<td>"+datas[i].project_name+"</td><td>"+datas[i].unuse_num+"</td>";
			innerHTML += "<td>"+datas[i].org_abbreviation+"</td><td>"+datas[i].actual_in_time+"</td>";
			innerHTML += "</tr>";
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	function toDelete(){
 		var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
			    
			if(confirm('确定要删除吗?')){
				var path = "<%=contextPath%>/rad/asyncUpdateEntitiesBySql.srq";
				var sql = "update GMS_DEVICE_COLL_ACCOUNT set bsflag = '1' where dev_acc_id = '{id}'";
				var paramStr = "sql="+sql+"&ids="+ids;
				syncRequest('post',path,paramStr); 
				queryData(cruConfig.currentPage);
				
			}

	}
	//打开查询条件页面
    function newSearch(){
    	popWindow('<%=contextPath%>/rm/dm/collectTreeNew/devquery.jsp');
    }
	function frameSize(){
		setTabBoxHeight();
	}
	frameSize();
	$(function(){
// 		if(userOrgId == ""){
<%-- 			parent.window.location.href = '<%=contextPath%>'; --%>
// 		}
//		增加select下面的option
// 		var sql = "select  distinct dev_name , device_id  from gms_device_collectinfo  where is_leaf != 1";
// 		var result = jcdpQueryRecords(sql);
// 		if(result["returnCode"] == 0){
// 			var datas = result.datas;
// 			for(var i=0 , length = datas.length ; i < length ; i++){
// 				$("#type_id").append("<option value="+datas[i]["device_id"]+">"+datas[i]["dev_name"]+"</option>");
// 			}
// 		}
		$(window).resize(function(){
	  		frameSize();
		});
	})	
	$(document).ready(lashen);
	
	function toEditTech(){
		
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    popWindow('<%=contextPath%>/rm/dm/collectTreeNew/editTech.jsp?devaccid='+ids); 
		
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
	function showOrgTreePage(){
		//var returnValue={
		//	fkValue:"",
		//	value:""
		//}
		//window.showModalDialog("<%=contextPath%>/common/selectOrgSub.jsp",returnValue,"");
		var returnValue = window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");

		var strs= new Array(); //定义一数组
		if(!returnValue){
			return;
		}
		strs = returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		var orgidnames = names[1];
		document.getElementById("s_own_org_name").value = orgidnames;
		
		var orgId = strs[1].split(":");
		var orgidvalue = orgId[1];
		document.getElementById("owning_org_id").value = orgidvalue;

		var orgSubId = strs[2].split(":");
		var orgSubIdValue = orgSubId[1];
		document.getElementById("owning_sub_org_id").value = orgSubIdValue;
	}
</script>
</body>
</html>