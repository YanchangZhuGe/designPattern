<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String code = request.getParameter("code");
	String userOrgId = user.getSubOrgIDofAffordOrg();
	String projectType = request.getParameter("projectType")==null?user.getProjectType():request.getParameter("projectType");
	String projectCommon = user.getProjectCommon();
	String userSubid = user.getOrgSubjectionId();
	String orgId= user.getOrgId();
	//String orgType="";
	//String dgOrg="C6000000000039,C6000000000040,C6000000005269,C6000000005280,C6000000005275,C6000000005279,C6000000005278,C6000000007366";
	//大港8个服务中心判断标志
	//if(dgOrg.contains(orgId)){
	//	orgType="Y";
	//}else{
	//	orgType="N";
	//}
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
  <title>多项目-设备台账管理-设备状态管理(综合物化探专用)</title> 
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
			    <td class="ali_cdn_input"><input id="s_own_org_name" name="s_own_org_name" type="text" /></td>
			    <!-- <td class="ali_cdn_name">设备状态</td>
			     <td class="ali_cdn_input">
			    	<select id="s_opr_state_desc" name="s_opr_state_desc" class="select_width" >
			    	    <option value="" selected="selected">--请选择--</option>
						<option value="0">未处理</option>
						<option value="1">处理中</option>
						<option value="9">已处理</option>
			    	</select>
			    </td> -->
      			<td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
			          			
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="gl" event="onclick='newSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <!--<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>-->
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <!--<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>-->
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			    
				
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
					<td class="bt_info_odd" exp="{erp_id}">ERP设备编号</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_model}">规格型号</td>
					<td class="bt_info_even" exp="{account_stat_desc}">资产状况</td>
					<td class="bt_info_odd" exp="{self_num}">自编号</td>
					<td class="bt_info_even" exp="{license_num}">牌照号</td>
					<td class="bt_info_odd" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_even" exp="{asset_value}">固定资产原值</td>
					<td class="bt_info_odd" exp="{owning_org_name_desc}">所属单位</td>
					<td class="bt_info_even" exp="{using_stat_desc}">使用情况</td>
					<td class="bt_info_odd" exp="{tech_stat_desc}">技术状况</td>
					<td class="bt_info_odd" exp="{asset_coding}">AMIS资产编号</td>
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
			    <!-- <li id="tag3_1" ><a href="#" onclick="getTab3(1);loaddata('',1)">设备运转统计</a></li>
			    <li  id="tag3_2" ><a href="#" onclick="getTab3(2);loaddata('',2)">强制保养记录</a></li>
			    <li  id="tag3_3" ><a href="#" onclick="getTab3(3);loaddata('',3)">单机材料消耗</a></li>
			    <li  id="tag3_4" ><a href="#" onclick="getTab3(4);loaddata('',4)">设备油品消耗</a></li>
			    <li id="tag3_5" ><a href="#" onclick="getTab3(5);loaddata('',5)">设备事故记录</a></li>
			    <li  id="tag3_6" ><a href="#" onclick="getTab3(6);loaddata('',6)">项目修理记录</a></li>
			    <li  id="tag3_7" ><a href="#" onclick="getTab3(7);loaddata('',7)">定人定机记录</a></li>
			    <li  id="tag3_8" ><a href="#" onclick="getTab3(8);loaddata('',8)">参与项目</a></li>
			    <li id="tag3_9"><a href="#" onclick="getTab3(9)">附件</a></li>
			    <li id="tag3_10"><a href="#" onclick="getTab3(10)">备注</a></li> -->
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
						    <td class="inquire_item6">资产编号</td>
						    <td class="inquire_form6"><input id="dev_acc_assetcoding" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">实物标识号</td>
						    <td class="inquire_form6"><input id="dev_acc_sign" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">自编号</td>
						    <td class="inquire_form6"><input id="dev_acc_self" name="" class="input_width" type="text" /></td>
						  </tr>
						   <tr>
						    <td class="inquire_item6">牌照号</td>
						    <td class="inquire_form6"><input id="dev_acc_license" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">发动机号</td>
						    <td class="inquire_form6"><input id="dev_acc_engine_num" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">底盘号</td>
						    <td class="inquire_form6"><input id="dev_acc_chassis_num" name="" class="input_width" type="text" /></td>
						  </tr>
						    <tr>
						    <td class="inquire_item6">资产状况</td>
						    <td class="inquire_form6"><input id="dev_acc_asset_stat" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">技术状况</td>
						    <td class="inquire_form6"><input id="dev_acc_tech_stat" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">使用状况</td>
						    <td class="inquire_form6"><input id="dev_acc_using_stat" name="" class="input_width" type="text" /></td>
						  </tr>
						    <tr>
						    <td class="inquire_item6">出厂日期</td>
						    <td class="inquire_form6"><input id="dev_acc_producting_date" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">固定资产原值</td>
						    <td class="inquire_form6"><input id="dev_asset_value" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">固定资产净值</td>
						    <td class="inquire_form6"><input id="dev_net_value" name="" class="input_width" type="text" /></td>
						  </tr>            
			        </table>
				</div>
			<div id="tab_box_content1" class="tab_box_content" style="display:none;">
						<table id="yzMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
					    <tr>   
						<td class="bt_info_odd">序号</td>
						<td class="bt_info_even">项目名称</td>
					    <td class="bt_info_odd">设备名称</td>
					    <td class="bt_info_even">AMIS资产编号</td>
					    <!-- <td class="bt_info_odd">里程</td> -->
						<td class="bt_info_odd">累计里程</td>
					    <td class="bt_info_even">累计钻井进尺</td>
					    <td class="bt_info_odd">累计工作小时</td>
						<td class="bt_info_even">最后填报时间</td>
					  </tr>	
					  <tbody id="assign_body"></tbody>
					</table>
			</div>
			<!--强制保养-->
			<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<table id="byMap" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
					 <tr>   
					 	<td class="bt_info_odd">序号</td>
						<td class="bt_info_even">项目名称</td>
					    <td class="bt_info_odd">设备名称</td>
					    <td class="bt_info_even">AMIS资产编号</td>
					    <td class="bt_info_odd">保养日期</td>
					    <td class="bt_info_even">修理详情	</td>
					  </tr>
					  <tbody id="assign_body"></tbody>
					</table>
			</div>
			<!--单机材料消耗-->
			<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				<table id="metMap" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;">
			  <tr>  
			  	  <td class="bt_info_odd">序号</td>
				  <td class="bt_info_even">项目名称</td>
				  <td class="bt_info_odd">设备名称</td>
				  <td class="bt_info_even">AMIS资产编号</td>
				  <td class="bt_info_odd">计划单号</td>
				  <td class="bt_info_even">材料名称</td>
				  <td class="bt_info_odd">材料编号</td>
				  <td class="bt_info_even">单价</td>
				  <td class="bt_info_odd">出库数量</td>
				  <td class="bt_info_even">消耗数量</td>
				  <td class="bt_info_odd">总价</td>
				  
			  </tr>
			  <tbody id="assign_body"></tbody>
		  </table>
			</div>
			<!--油水消耗-->
			<div id="tab_box_content4" class="tab_box_content" style="display:none;">
				<table id="ysMap" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
						<tr>   
						<td class="bt_info_odd">序号</td>
						<td class="bt_info_even">项目名称</td>
					    <td class="bt_info_odd">设备名称</td>
					    <td class="bt_info_even">AMIS资产编号</td>
						<td class="bt_info_even">加注日期</td>
						<td class="bt_info_odd">油品名称</td>
						<td class="bt_info_even">单位</td>
					    <td class="bt_info_odd">数量</td>
						<td class="bt_info_even">累计数量</td>
					    <td class="bt_info_odd">单价（元）</td>
					    <td class="bt_info_even"> 金额（元） </td>
					  </tr>
					  <tbody id="assign_body"></tbody>
					</table>
			</div>
			<!--事故记录-->
			<div id="tab_box_content5" class="tab_box_content" style="display:none;">
				<table id="sgMap" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
						<tr>   
						<td class="bt_info_odd">序号</td>
						<td class="bt_info_even">项目名称</td>
					    <td class="bt_info_odd">设备名称</td>
					    <td class="bt_info_even">AMIS资产编号</td>
						<td class="bt_info_odd">操作手</td>
						<td class="bt_info_even">损失金额（万元）</td>
						<td class="bt_info_odd">事故级别</td>
						<td class="bt_info_even">责任人</td>
					    <td class="bt_info_even">事故性质</td>
						<td class="bt_info_odd">事故时间</td>
						<!-- <td class="bt_info_even"> 状态</td> -->
					  </tr>
					  <tbody id="assign_body"></tbody>
					</table>
			</div>
			<div id="tab_box_content6" class="tab_box_content" style="display:none;">
				<table id="whMap" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
						<tr>  
						<td class="bt_info_even">序号</td>
						<td class="bt_info_odd">项目名称</td>
					    <td class="bt_info_even">设备名称</td>
					    <td class="bt_info_odd">AMIS资产编号</td>
					    <td class="bt_info_even">修理类别</td>        
					    <td class="bt_info_odd">修理项目</td>
					    <td class="bt_info_even">修理详情</td>
					    <td class="bt_info_odd">送修日期</td>
					    <td class="bt_info_even">竣工日期</td>
					    <td class="bt_info_odd">工时费</td>
					    <td class="bt_info_even">材料费</td>
					    <td class="bt_info_odd">承修人</td>
					    <td class="bt_info_even">验收人</td>
					    <td class="bt_info_odd">单据状态</td>
					  </tr>
					  <tbody id="assign_body"></tbody>
					</table>
			</div>
			<!--操作记录-->
			<div id="tab_box_content7" class="tab_box_content" style="display:none;">
				<table id="djMap" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
						<tr>   
						<td class="bt_info_even">序号</td>
						<td class="bt_info_odd">项目名称</td>
					    <td class="bt_info_even">设备名称</td>
					    <td class="bt_info_odd">AMIS资产编号</td>
						<td class="bt_info_even">操作手</td>
						
					  </tr>
					  <tbody id="assign_body"></tbody>
					</table>
			</div>
			<!--参与项目-->
			<div id="tab_box_content8" class="tab_box_content" style="display:none;">
				<table id="djMap" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
						<tr>   
						<td class="bt_info_even">序号</td>
						<td class="bt_info_odd">项目名称</td>
					    <td class="bt_info_even">设备名称</td>
					    <td class="bt_info_odd">AMIS资产编号</td>
						<td class="bt_info_even">入队时间</td>
						<td class="bt_info_odd">离队时间</td>
						
					  </tr>
					  <tbody id="assign_body"></tbody>
					</table>
			</div>
			<div id="tab_box_content9" class="tab_box_content" style="display:none;">
			
			</div>
			<div id="tab_box_content10" class="tab_box_content" style="display:none;">
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
	var usersubid = '<%=userSubid%>';
	var projectType="<%=projectType%>";
	//下拉时查询
	function selectRefreshData(){
	    searchDevData();
	}
	function searchDevData(){
		var v_dev_name = document.getElementById("s_dev_name").value;
		var v_dev_model = document.getElementById("s_dev_model").value;
		var v_own_org_name = document.getElementById("s_own_org_name").value;
		var obj = new Array();
		obj.push({"label":"dev_name","value":v_dev_name});
		obj.push({"label":"dev_model","value":v_dev_model});
		obj.push({"label":"org.org_name","value":v_own_org_name});
		refreshData(obj);
	}
	 //清空查询条件
    function clearQueryText(){
    	document.getElementById("s_dev_name").value="";
			document.getElementById("s_dev_model").value="";
			document.getElementById("s_own_org_name").value="";
    }
	//点击树节点查询
	var code = '<%=code%>';
	code = code.replace("S","");//点根节点时去除S,只有根节点带S
	function refreshData(arrObj){
		var userid = '<%=userOrgId%>';
		var orgLength = userid.length;
		var str = "";
		if(orgLength==4){
			str += "select (select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc, ";
			str += "(select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc, t.*,substr(t.foreign_key,8) as erp_id,";
			str += "(case when t.owning_sub_id like 'C105001005%' then '塔里木物探处' else (case when t.owning_sub_id like 'C105001002%' then '新疆物探处'else(case when t.owning_sub_id like 'C105001003%' then '吐哈物探处'else(case when t.owning_sub_id like 'C105001004%' then '青海物探处'else(case when t.owning_sub_id like 'C105005004%' then '长庆物探处'else(case when t.owning_sub_id like 'C105005000%' then '华北物探处'else(case when t.owning_sub_id like 'C105005001%' then '新兴物探处'else(case when t.owning_sub_id like 'C105007%' then '大港物探处'else(case when t.owning_sub_id like 'C105063%' then '辽河物探处'else(case when t.owning_sub_id like 'C105006%' then '装备服务处'else (case when t.owning_sub_id like 'C105002%' then '国际勘探事业部'else (case when t.owning_sub_id like 'C105003%' then '研究院'else (case when t.owning_sub_id like 'C105008%' then '综合物化处'else (case when t.owning_sub_id like 'C105015%' then '井中地震中心'else '' end) end) end) end) end) end) end) end) end) end) end) end) end) end) as owning_org_name_desc,";
			str += "(select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc ";
			str += "from gms_device_account t join comm_org_information org on t.owning_org_id=org.org_id ";
			str += "where t.bsflag='0' and t.account_stat!='0110000013000000005' and t.tech_stat!='0110000006000000001' and t.owning_sub_id like '"+userid+"%' ";
		}else{
			str += "select (select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc, ";
			str += "(select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc, t.*,substr(t.foreign_key,8) as erp_id,";
			str += "(select org_abbreviation from comm_org_information org where t.owning_org_id=org.org_id) as owning_org_name_desc,";
			str += "(select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc ";
			str += "from gms_device_account t join comm_org_information org on t.owning_org_id=org.org_id ";
			str += "where t.bsflag='0' and t.account_stat!='0110000013000000005' ";
			str += "and t.owning_sub_id like '"+userid+"%' and t.tech_stat!='0110000006000000001' ";		
		}
		for(var key in arrObj) {
			if(arrObj[key].value!=undefined && arrObj[key].value!='')
			str += "and "+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
		}
		str += "order by dev_type ";
		
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	
	//打开新增界面
	 function toAdd(){   
	 	//popWindow("<%=contextPath%>/rm/dm/deviceAccount/loaderInfo.upmd?pagerAction=edit2Add");
		popWindow("<%=contextPath%>/rm/dm/deviceAccount/toAdd.jsp"); 
	 }

    //修改界面
     function toEdit(){  
     	ids = getSelIds('rdo_entity_id');  
	  	if(ids==''){  alert("请选择一条信息!");  return;  }  
	  	selId = ids.split(',')[0]; 
	  	editUrl = "<%=contextPath%>/rm/dm/deviceAccount/zhToEdit.jsp?id={id}";  
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
	
	  var selectedTagIndex = 0;
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
		document.getElementById("dev_acc_engine_num").value =retObj.deviceaccMap.engine_num;
		document.getElementById("dev_acc_chassis_num").value =retObj.deviceaccMap.chassis_num;
		document.getElementById("dev_acc_asset_stat").value =retObj.deviceaccMap.stat_desc;		
		document.getElementById("dev_acc_remark").value =retObj.deviceaccMap.remark;
		document.getElementById("dev_type").value =retObj.deviceaccMap.dev_type;
		document.getElementById("dev_acc_producting_date").value =retObj.deviceaccMap.producting_date;
		document.getElementById("dev_asset_value").value =retObj.deviceaccMap.asset_value;
		document.getElementById("dev_net_value").value =retObj.deviceaccMap.net_value;		
		
		if(shuaId==null)
			shuaId = ids;
		loaddata(shuaId,selectedTagIndex);		
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
    	popWindow('<%=contextPath%>/rm/dm/deviceAccount/devquery_arichive.jsp');
    }    
    /**
	 * 延迟加载*****************************************************************************************************************************
	 * @param {Object} index
	 */
	function loaddata(ids,index){		
		selectedTagIndex=index;
		
		if(ids == ""){			
			var ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				//			    alert("请先选中一条记录!");
				return;
			}
		}
		var currentid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				currentid = this.value;
			}
		});
		if(index==1)
			yzjl(ids);
		else if(index==2) 
			qzby(ids);
		else if(index==3) 
			djxh(ids);
		else if(index==4) 
			ysjl(ids);
		else if(index==5) 
			sgjl(ids);
		else if(index==6) 
			wsjl(ids);
		else if(index==7) 
			djjl(ids);
		else if(index==8) 
			pro(ids);
	}
	 /**
		 * 运转记录****************************************************************************************************************************
		 * @param {Object} shuaId
	 */
	function yzjl(shuaId){			 
		var retObj;
		var querySql="select pro.project_name,acc.dev_name,acc.asset_coding,info.mileage_total,info.drilling_footage_total,"+
			"info.work_hour_total,info.modify_date from gms_device_operation_info info "+
			"left join gms_device_archive_detail arc on arc.dev_archive_refid=info.operation_info_id "+
			"left join gms_device_account acc on acc.dev_acc_id=arc.dev_acc_id "+
			"left join gp_task_project pro on arc.project_info_id = pro.project_info_no "+
			"where arc.dev_archive_type='1' and arc.dev_acc_id='"+shuaId+"' "+
			" and arc.seqinfo = (select max(seqinfo) from gms_device_archive_detail arc "+
         	"where arc.dev_archive_type = '1' and arc.dev_acc_id='"+shuaId+"' )";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj= queryRet.datas;
			//if (shuaId != null) {
				//retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfoBY", "deviceId=" + shuaId);
			//}
		var size = $("#assign_body", "#tab_box_content1").children("tr").size();
		if(size > 0){
			$("#assign_body", "#tab_box_content1").children("tr").remove();
		}
		var by_body1 = $("#assign_body", "#tab_box_content1")[0];
		if(retObj != undefined){
			for(var i = 0; i < retObj.length; i++){
				var columnsObj ;
				$("input[type='checkbox']", "#queryRetTable").each(function(){
					if(this.checked){
						columnsObj = this.parentNode.parentNode.cells;
					}
				});
			var newTr = by_body1.insertRow();					
			var newTd = newTr.insertCell();
				newTd.innerText = i+1;
			var newTd1 = newTr.insertCell();
				newTd1.innerText = retObj[i].project_name;
			var newTd2 = newTr.insertCell();
				newTd2.innerText = retObj[i].dev_name;
			var newTd3 = newTr.insertCell();
				newTd3.innerText = retObj[i].asset_coding;
				//newTr.insertCell().innerText=retObj[i].mileage;
				newTr.insertCell().innerText=retObj[i].mileage_total;
				newTr.insertCell().innerText=retObj[i].drilling_footage_total;
				newTr.insertCell().innerText=retObj[i].work_hour_total;
				newTr.insertCell().innerText=retObj[i].modify_date;
			}
		}
		$("#assign_body>tr:odd>td:odd",'#tab_box_content1').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#tab_box_content1').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#tab_box_content1').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#tab_box_content1').addClass("even_even");
	}
	 /**
		 * 强制保养****************************************************************************************************************************
		 * @param {Object} shuaId
	 */
	function qzby(shuaId){			 
		var retObj;
			
		var querySql="select pro.project_name,acc.dev_name,acc.asset_coding,info.repair_start_date,info.repair_detail from BGP_COMM_DEVICE_REPAIR_INFO info "+
				"left join GMS_DEVICE_ARCHIVE_DETAIL arc on arc.dev_archive_refid=info.repair_info "+
				"left join gms_device_account acc on acc.dev_acc_id=arc.dev_acc_id "+
				"left join gp_task_project pro on arc.project_info_id = pro.project_info_no "+
				"where arc.dev_archive_type='2' and arc.dev_acc_id='"+shuaId+"' order by seqinfo desc ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj= queryRet.datas;
			//if (shuaId != null) {
				//retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfoBY", "deviceId=" + shuaId);
			//}
		var size = $("#assign_body", "#tab_box_content2").children("tr").size();
		if(size > 0){
			$("#assign_body", "#tab_box_content2").children("tr").remove();
		}
		var by_body1 = $("#assign_body", "#tab_box_content2")[0];
			if(retObj != undefined){
				for(var i = 0; i < retObj.length; i++){
					var columnsObj ;
					$("input[type='checkbox']", "#queryRetTable").each(function(){
						if(this.checked){
							columnsObj = this.parentNode.parentNode.cells;
					}
			});
			var newTr = by_body1.insertRow();					
			var newTd = newTr.insertCell();
				newTd.innerText = i+1;
			var newTd1 = newTr.insertCell();
				newTd1.innerText = retObj[i].project_name;
			var newTd2 = newTr.insertCell();
				newTd2.innerText = retObj[i].dev_name;
			var newTd3 = newTr.insertCell();
				newTd3.innerText = retObj[i].asset_coding;
			var newTd4 = newTr.insertCell();
				newTd4.innerText = retObj[i].repair_start_date;
			var newTd5 = newTr.insertCell();
				newTd5.innerText = retObj[i].repair_detail;
					//str = "device_acc_id=" + shuaId + "&ye=" + retObj[i].year + "&me=" + retObj[i].month;
					//alert(str);
					//newTd5.innerHTML = "<a lin=" + str + " onclick=getdate(this);><img src=<%=contextPath%>/images/calendar.gif /></a>";
			}
		}
		$("#assign_body>tr:odd>td:odd",'#tab_box_content2').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#tab_box_content2').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#tab_box_content2').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#tab_box_content2').addClass("even_even");
	}   	
		 
	/**
		* 油水消耗****************************************************************************************************************************
		* @param {Object} shuaId
	*/
	function ysjl(shuaId){				 
		var retObj;
		//var querySql="select to_char(a.NEXT_MAINTAIN_DATE,'yyyy') as Year,to_char(a.NEXT_MAINTAIN_DATE,'mm') as month "+
		//	"from BGP_COMM_DEVICE_MAINTAIN a "+
		//	"left join BGP_COMM_DEVICE_REPAIR_INFO info on info.device_account_id=a.device_account_id "+
		//	"where a.device_account_id='"+shuaId+"' "+
		//	"group by to_char(a.NEXT_MAINTAIN_DATE,'yyyy'),to_char(a.NEXT_MAINTAIN_DATE,'mm')  "+
		//	"order by to_char(a.NEXT_MAINTAIN_DATE,'yyyy'),to_char(a.NEXT_MAINTAIN_DATE,'mm') desc";
		var querySql="select pro.project_name,acc.dev_name,acc.asset_coding,info.*,oname.coding_name as oil_name1,ounit.coding_name as oil_unit1 from BGP_COMM_DEVICE_OIL_INFO info "+
				"left join GMS_DEVICE_ARCHIVE_DETAIL arc on arc.dev_archive_refid=info.oil_info_id "+
				"left join gms_device_account acc on acc.dev_acc_id=arc.dev_acc_id "+
				"left join gp_task_project pro on arc.project_info_id = pro.project_info_no "+
				"left join comm_coding_sort_detail oname on oname.coding_code_id=info.oil_name "+
				"left join comm_coding_sort_detail ounit on ounit.coding_code_id=info.oil_unit "+
				"where arc.dev_archive_type='4' and arc.dev_acc_id='"+shuaId+"' order by seqinfo desc ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj= queryRet.datas;
			//if (shuaId != null) {
				//retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfoBY", "deviceId=" + shuaId);
			//}
		var size = $("#assign_body", "#tab_box_content4").children("tr").size();
		if(size > 0){
			$("#assign_body", "#tab_box_content4").children("tr").remove();
		}
		var by_body1 = $("#assign_body", "#tab_box_content4")[0];
		if(retObj != undefined){
			for(var i = 0; i < retObj.length; i++){
				var columnsObj ;
				$("input[type='checkbox']", "#queryRetTable").each(function(){
				if(this.checked){
					columnsObj = this.parentNode.parentNode.cells;
				}
			});
			var newTr = by_body1.insertRow();						
			var newTd = newTr.insertCell();
				newTd.innerText = i+1;
			var newTd1 = newTr.insertCell();
				newTd1.innerText = retObj[i].project_name;
			var newTd2 = newTr.insertCell();
				newTd2.innerText = retObj[i].dev_name;
			var newTd3 = newTr.insertCell();
				newTd3.innerText = retObj[i].asset_coding;
															
				newTr.insertCell().innerText=retObj[i].fill_date;
				newTr.insertCell().innerText=retObj[i].oil_name1;
				newTr.insertCell().innerText=retObj[i].oil_unit1;
				newTr.insertCell().innerText=retObj[i].oil_quantity;
				newTr.insertCell().innerText=retObj[i].quantity_total;
				newTr.insertCell().innerText=retObj[i].oil_unit_price;
				newTr.insertCell().innerText=retObj[i].oil_total;
			}
		}
		$("#assign_body>tr:odd>td:odd",'#tab_box_content4').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#tab_box_content4').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#tab_box_content4').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#tab_box_content4').addClass("even_even");
	}
	/**
		* 事故记录****************************************************************************************************************************
		* @param {Object} shuaId
	*/
	function sgjl(shuaId){					 
		var retObj;
		//var querySql="select to_char(a.NEXT_MAINTAIN_DATE,'yyyy') as Year,to_char(a.NEXT_MAINTAIN_DATE,'mm') as month "+
		//	"from BGP_COMM_DEVICE_MAINTAIN a "+
		//	"left join BGP_COMM_DEVICE_REPAIR_INFO info on info.device_account_id=a.device_account_id "+
		//	"where a.device_account_id='"+shuaId+"' "+
		//	"group by to_char(a.NEXT_MAINTAIN_DATE,'yyyy'),to_char(a.NEXT_MAINTAIN_DATE,'mm')  "+
		//	"order by to_char(a.NEXT_MAINTAIN_DATE,'yyyy'),to_char(a.NEXT_MAINTAIN_DATE,'mm') desc";
		var querySql="select pro.project_name,acc.dev_name,acc.asset_coding,info.*,det1.coding_name as accident_properties1,det2.coding_name as accident_grade1 from BGP_COMM_DEVICE_ACCIDENT_INFO info "+
				"left join GMS_DEVICE_ARCHIVE_DETAIL arc on arc.dev_archive_refid=info.accident_info_id "+
				"left join gms_device_account acc on acc.dev_acc_id=arc.dev_acc_id "+
				"left join gp_task_project pro on arc.project_info_id = pro.project_info_no "+
				"left join comm_coding_sort_detail det1 on det1.coding_code_id=info.accident_properties "+
				"left join comm_coding_sort_detail det2 on det2.coding_code_id=info.accident_grade "+
				"where  arc.dev_acc_id='"+shuaId+"' order by seqinfo desc ";//arc.dev_archive_type='6' and
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj= queryRet.datas;
			//if (shuaId != null) {
					//retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfoBY", "deviceId=" + shuaId);
			//}
		var size = $("#assign_body", "#tab_box_content5").children("tr").size();
			if(size > 0){
				$("#assign_body", "#tab_box_content5").children("tr").remove();
			}
		var by_body1 = $("#assign_body", "#tab_box_content5")[0];
			if(retObj != undefined){
				for(var i = 0; i < retObj.length; i++){
					var columnsObj ;
					$("input[type='checkbox']", "#queryRetTable").each(function(){
					if(this.checked){
						columnsObj = this.parentNode.parentNode.cells;
					}
				});
				var newTr = by_body1.insertRow();							
				var newTd = newTr.insertCell();
					newTd.innerText = i+1;
				var newTd1 = newTr.insertCell();
					newTd1.innerText = retObj[i].project_name;
				var newTd2 = newTr.insertCell();
					newTd2.innerText = retObj[i].dev_name;
				var newTd3 = newTr.insertCell();
					newTd3.innerText = retObj[i].asset_coding;
							
					newTr.insertCell().innerText=retObj[i].accident_loss;
					newTr.insertCell().innerText=retObj[i].accident_grade1;
					newTr.insertCell().innerText=retObj[i].accident_charge_person;
					newTr.insertCell().innerText=retObj[i].accident_properties1;
					newTr.insertCell().innerText=retObj[i].accident_time;
				}
			}
			$("#assign_body>tr:odd>td:odd",'#tab_box_content5').addClass("odd_odd");
			$("#assign_body>tr:odd>td:even",'#tab_box_content5').addClass("odd_even");
			$("#assign_body>tr:even>td:odd",'#tab_box_content5').addClass("even_odd");
			$("#assign_body>tr:even>td:even",'#tab_box_content5').addClass("even_even");
		}
		/**
		  * 维修记录****************************************************************************************************************************
		  * @param {Object} shuaId
		*/
		function wsjl(shuaId){						 
			var retObj;
			//var querySql="select to_char(a.NEXT_MAINTAIN_DATE,'yyyy') as Year,to_char(a.NEXT_MAINTAIN_DATE,'mm') as month "+
			//	"from BGP_COMM_DEVICE_MAINTAIN a "+
			//	"left join BGP_COMM_DEVICE_REPAIR_INFO info on info.device_account_id=a.device_account_id "+
			//	"where a.device_account_id='"+shuaId+"' "+
			//	"group by to_char(a.NEXT_MAINTAIN_DATE,'yyyy'),to_char(a.NEXT_MAINTAIN_DATE,'mm')  "+
			//	"order by to_char(a.NEXT_MAINTAIN_DATE,'yyyy'),to_char(a.NEXT_MAINTAIN_DATE,'mm') desc";
			var querySql="select pro.project_name,acc.dev_name,acc.asset_coding,info.*,det1.coding_name as repairtype,det2.coding_name as repairitem from BGP_COMM_DEVICE_REPAIR_INFO info "+
					"left join GMS_DEVICE_ARCHIVE_DETAIL arc on arc.dev_archive_refid=info.repair_info "+
					"left join gms_device_account acc on acc.dev_acc_id=arc.dev_acc_id "+
					"left join gp_task_project pro on arc.project_info_id = pro.project_info_no "+
					"left join comm_coding_sort_detail det1 on det1.coding_code_id=info.repair_type "+
					"left join comm_coding_sort_detail det2 on det2.coding_code_id=info.repair_item "+
					"where arc.dev_archive_type='7' and arc.dev_acc_id='"+shuaId+"' order by seqinfo desc ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
				retObj= queryRet.datas;
				//if (shuaId != null) {
					//retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfoBY", "deviceId=" + shuaId);
				//}
			var size = $("#assign_body", "#tab_box_content6").children("tr").size();
			if(size > 0){
				$("#assign_body", "#tab_box_content6").children("tr").remove();
			}
			var by_body1 = $("#assign_body", "#tab_box_content6")[0];
			if(retObj != undefined){
				for(var i = 0; i < retObj.length; i++){
					var columnsObj ;
					$("input[type='checkbox']", "#queryRetTable").each(function(){
						if(this.checked){
							columnsObj = this.parentNode.parentNode.cells;
					}
				});
				var newTr = by_body1.insertRow();								
				var newTd = newTr.insertCell();
					newTd.innerText = i+1;
				var newTd1 = newTr.insertCell();
					newTd1.innerText = retObj[i].project_name;
				var newTd2 = newTr.insertCell();
					newTd2.innerText = retObj[i].dev_name;
				var newTd3 = newTr.insertCell();
					newTd3.innerText = retObj[i].asset_coding;
								
					newTr.insertCell().innerText=retObj[i].repairtype;
					newTr.insertCell().innerText=retObj[i].repairitem;
					newTr.insertCell().innerText=retObj[i].repair_detail;
					newTr.insertCell().innerText=retObj[i].repair_start_date;
					newTr.insertCell().innerText=retObj[i].repair_end_date;
					newTr.insertCell().innerText=retObj[i].human_cost;
					newTr.insertCell().innerText=retObj[i].material_cost;
					newTr.insertCell().innerText=retObj[i].repairer;
					newTr.insertCell().innerText=retObj[i].accepter;
					newTr.insertCell().innerText=retObj[i].record_status;
				}
			}
			$("#assign_body>tr:odd>td:odd",'#tab_box_content6').addClass("odd_odd");
			$("#assign_body>tr:odd>td:even",'#tab_box_content6').addClass("odd_even");
			$("#assign_body>tr:even>td:odd",'#tab_box_content6').addClass("even_odd");
			$("#assign_body>tr:even>td:even",'#tab_box_content6').addClass("even_even");
		}
		/**
		  * 操作记录****************************************************************************************************************************
		  * @param {Object} shuaId
		*/
		function djjl(shuaId){							 
			var retObj;
			var querySql="select pro.project_name,acc.dev_name,acc.asset_coding,info.* from gms_device_equipment_operator info "+
					"left join GMS_DEVICE_ARCHIVE_DETAIL arc on arc.dev_archive_refid=info.entity_id "+
					"left join gms_device_account acc on acc.dev_acc_id=arc.dev_acc_id "+
					"left join gp_task_project pro on arc.project_info_id = pro.project_info_no "+
					"where arc.dev_archive_type='5' and arc.dev_acc_id='"+shuaId+"' order by seqinfo desc ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
				retObj= queryRet.datas;
			var size = $("#assign_body", "#tab_box_content7").children("tr").size();
			if(size > 0){
				$("#assign_body", "#tab_box_content7").children("tr").remove();
			}
			var by_body1 = $("#assign_body", "#tab_box_content7")[0];
			if(retObj != undefined){
				for(var i = 0; i < retObj.length; i++){
					var columnsObj ;
					$("input[type='checkbox']", "#queryRetTable").each(function(){
					if(this.checked){
						columnsObj = this.parentNode.parentNode.cells;
					}
			});
			var newTr = by_body1.insertRow();									
			var newTd = newTr.insertCell();
				newTd.innerText = i+1;
			var newTd1 = newTr.insertCell();
				newTd1.innerText = retObj[i].project_name;
			var newTd2 = newTr.insertCell();
				newTd2.innerText = retObj[i].dev_name;
			var newTd3 = newTr.insertCell();
				newTd3.innerText = retObj[i].asset_coding;									
				newTr.insertCell().innerText=retObj[i].operator_name;
			}
		}
		$("#assign_body>tr:odd>td:odd",'#tab_box_content7').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#tab_box_content7').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#tab_box_content7').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#tab_box_content7').addClass("even_even");
	}
	/**
	  * 单机材料消耗****************************************************************************************************************************
	  * @param {Object} shuaId
	*/
	function djxh(shuaId){								 
		var retObj;
		//var querySql="select to_char(a.NEXT_MAINTAIN_DATE,'yyyy') as Year,to_char(a.NEXT_MAINTAIN_DATE,'mm') as month "+
		//	"from BGP_COMM_DEVICE_MAINTAIN a "+
		//	"left join BGP_COMM_DEVICE_REPAIR_INFO info on info.device_account_id=a.device_account_id "+
		//	"where a.device_account_id='"+shuaId+"' "+
		//	"group by to_char(a.NEXT_MAINTAIN_DATE,'yyyy'),to_char(a.NEXT_MAINTAIN_DATE,'mm')  "+
		//	"order by to_char(a.NEXT_MAINTAIN_DATE,'yyyy'),to_char(a.NEXT_MAINTAIN_DATE,'mm') desc";
		var querySql="select pro.project_name,acc.dev_name,acc.asset_coding,info.* from BGP_COMM_DEVICE_REPAIR_DETAIL info "+
					"left join GMS_DEVICE_ARCHIVE_DETAIL arc on arc.dev_archive_refid=info.repair_detail_id "+
					"left join gms_device_account acc on acc.dev_acc_id=arc.dev_acc_id "+
					"left join gp_task_project pro on arc.project_info_id = pro.project_info_no "+
					"where arc.dev_archive_type='3' and arc.dev_acc_id='"+shuaId+"' order by seqinfo desc ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj= queryRet.datas;
			//if(shuaId != null){
				//retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfoBY", "deviceId=" + shuaId);
			//}
		var size = $("#assign_body", "#tab_box_content3").children("tr").size();
		if(size > 0){
		$("#assign_body", "#tab_box_content3").children("tr").remove();
		}
		var by_body1 = $("#assign_body", "#tab_box_content3")[0];
		if(retObj != undefined){
			for(var i = 0; i < retObj.length; i++){
				var columnsObj ;
				$("input[type='checkbox']", "#queryRetTable").each(function(){
				if(this.checked){
					columnsObj = this.parentNode.parentNode.cells;
				}
		});
		var newTr = by_body1.insertRow();
		var newTd = newTr.insertCell();
			newTd.innerText = i+1;
		var newTd1 = newTr.insertCell();
			newTd1.innerText = retObj[i].project_name;
		var newTd2 = newTr.insertCell();
			newTd2.innerText = retObj[i].dev_name;
		var newTd3 = newTr.insertCell();
			newTd3.innerText = retObj[i].asset_coding;
										
			newTr.insertCell().innerText=retObj[i].teammat_out_id;
			newTr.insertCell().innerText=retObj[i].material_name;
			newTr.insertCell().innerText=retObj[i].material_coding;
			newTr.insertCell().innerText=retObj[i].unit_price;
										
			newTr.insertCell().innerText=retObj[i].out_num;
			newTr.insertCell().innerText=retObj[i].material_amout;
			newTr.insertCell().innerText=retObj[i].total_charge;
		}
	  }
		$("#assign_body>tr:odd>td:odd",'#tab_box_content3').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#tab_box_content3').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#tab_box_content3').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#tab_box_content3').addClass("even_even");
	}
	/**
	  * 参与项目****************************************************************************************************************************
	  * @param {Object} shuaId
	*/
	function pro(shuaId){
		var retObj;
		
		//井中地震-添加非常规项目
		//if(projectType == "5000100004000000008")
		//{
		//	var querySql = "select * from (select pro.project_name, acc.dev_name, acc.asset_coding,dui.actual_in_time,dui.actual_out_time from GMS_DEVICE_OPERATION_INFO info left join gms_device_account_dui dui on info.dev_acc_id=dui.dev_acc_id left join GMS_DEVICE_ARCHIVE_DETAIL arc on arc.dev_archive_refid = info.operation_info_id left join gms_device_account acc on acc.dev_acc_id = arc.dev_acc_id left join gp_task_project pro on arc.project_info_id = pro.project_info_no where arc.dev_archive_type = '1' and arc.dev_acc_id = '"+shuaId+"' ";
		//		querySql += "union all select pro.project_name, acc.dev_name, acc.asset_coding,dui.actual_in_time,dui.actual_out_time from GMS_DEVICE_OPERATION_INFO info left join gms_device_account_dui dui on info.dev_acc_id=dui.dev_acc_id left join GMS_DEVICE_ARCHIVE_DETAIL arc on arc.dev_archive_refid = info.operation_info_id left join gms_device_account acc on acc.dev_acc_id = arc.dev_acc_id left join gp_task_project pro on arc.project_info_id = pro.project_father_no and pro.bsflag = '0' where arc.dev_archive_type = '1'  and  pro.project_common = '0' and arc.dev_acc_id = '"+shuaId+"' ) group by project_name,dev_name,asset_coding,actual_in_time,actual_out_time order by actual_out_time desc";
   //     }else{
   //     	var querySql="select pro.project_name, acc.dev_name, acc.asset_coding,dui.actual_in_time,dui.actual_out_time from GMS_DEVICE_OPERATION_INFO info left join gms_device_account_dui dui on info.dev_acc_id=dui.dev_acc_id left join GMS_DEVICE_ARCHIVE_DETAIL arc on arc.dev_archive_refid = info.operation_info_id left join gms_device_account acc on acc.dev_acc_id = arc.dev_acc_id left join gp_task_project pro on arc.project_info_id = pro.project_info_no where arc.dev_archive_type = '1' and arc.dev_acc_id = '"+shuaId+"' group by pro.project_name,acc.dev_name,acc.asset_coding,dui.actual_in_time,dui.actual_out_time order by dui.actual_out_time desc";
   //     }
    var querySql="select pro.project_name, acc.dev_name, acc.asset_coding,dui.actual_in_time,dui.actual_out_time from gms_device_account_dui dui ";
		   querySql+="left join gp_task_project pro on dui.project_info_id = pro.project_info_no left join gms_device_account acc on acc.dev_acc_id=dui.fk_dev_acc_id ";
		   querySql+="where acc.dev_acc_id = '"+shuaId+"' and pro.bsflag = '0' and dui.bsflag = '0' and dui.is_leaving = '1' ";
		   querySql+="group by pro.project_name,acc.dev_name,acc.asset_coding,dui.actual_in_time,dui.actual_out_time order by dui.actual_out_time desc";        
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj= queryRet.datas;
		var size = $("#assign_body", "#tab_box_content8").children("tr").size();
		if(size > 0){
			$("#assign_body", "#tab_box_content8").children("tr").remove();
		}
		var by_body1 = $("#assign_body", "#tab_box_content8")[0];
		if(retObj != undefined){
			for(var i = 0; i < retObj.length; i++){
				var columnsObj ;
				$("input[type='checkbox']", "#queryRetTable").each(function(){
				if(this.checked){
					columnsObj = this.parentNode.parentNode.cells;
				}
		  });
		  var newTr = by_body1.insertRow();
		  var newTd = newTr.insertCell();
			  newTd.innerText = i+1;
		  var newTd1 = newTr.insertCell();
			  newTd1.innerText = retObj[i].project_name;
		  var newTd2 = newTr.insertCell();
			  newTd2.innerText = retObj[i].dev_name;
		  var newTd3 = newTr.insertCell();
			  newTd3.innerText = retObj[i].asset_coding;
		  var newTd4 = newTr.insertCell();
			  newTd4.innerText = retObj[i].actual_in_time;
			  newTr.insertCell().innerText=retObj[i].actual_out_time;
		  }
	    }
		$("#assign_body>tr:odd>td:odd",'#tab_box_content8').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#tab_box_content8').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#tab_box_content8').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#tab_box_content8').addClass("even_even");
	}
</script>
</html>