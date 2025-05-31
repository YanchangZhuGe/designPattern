<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String taskId = request.getParameter("taskId");
	String projectInfoNo = request.getParameter("projectInfoNo");
  	String code = request.getParameter("code");
  	String is_devicecode = request.getParameter("isDeviceCode");
	String userOrgId = user.getSubOrgIDofAffordOrg();
	String userSubid = user.getOrgSubjectionId();
	String orgId= user.getOrgId();
	String orgType="";
	String dgOrg="C6000000000039,C6000000000040,C6000000005269,C6000000005280,C6000000005275,C6000000005279,C6000000005278,C6000000007366";
	//大港8个服务中心判断标志
	if(dgOrg.contains(orgId)){
		orgType="Y";
	}else{
		orgType="N";
	}
	String zhEquSub="";
	if(userSubid.startsWith("C105008042")){//综合物化探机动设备服务中心用户显示设备物资科设备
		zhEquSub="Y";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open2.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/FusionCharts.js"></script>

  <title>多项目-设备台账管理-设备台账管理(单台)</title>
  <style type="text/css">
 .input_width {
	width:100%;
	height:20px;
	line-height:20px;
	border:1px solid #a4b2c0;
	float:left;
}

  </style>
 </head> 
 
 <body style="background:#fff" >
 <input id="export_name" name="export_name" value="设备台账(单台)" type='hidden' />
      	<div id="list_table">
			<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			    <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input" style="width:110px;"><input id="s_dev_name" name="s_dev_name" type="text" /></td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input" style="width:110px;"><input id="s_dev_model" name="s_dev_model" type="text" /></td>
			    <td class="ali_cdn_name" >牌照号</td>
			    <td class="ali_cdn_input" style="width:110px;"><input id="s_license_num" name="s_license_num" type="text" /></td>
			    <td class="ali_cdn_name">所属单位</td>
			    <td class="ali_cdn_input" style="width:110px;"><input id="s_own_org_name" name="s_own_org_name" type="text" /></td>
			    <td class="ali_cdn_input" style="width:50px;">
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
			    <auth:ListButton functionId="account_add" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="account_upd" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="account_del" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportDatForEasyUI1()'" title="JCDP_btn_export"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='expDataExcel()'" title="导出单机档案"></auth:ListButton>
			    <auth:ListButton functionId="" css="dr" event="onclick='excelDataAdd()'" title="导入"></auth:ListButton>				
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
		 	<div id="table_box" style="height:360px;">
			  <table  id="queryRetTable">	
			  	<thead>	
			  	<thead data-options="frozen:true">
			     	<tr>
			     				<th data-options="field:'dev_acc_id',checkbox:true,align:'center',dc:false" width="10">主键</th>
								<th data-options="field:'dev_name',align:'center',sortable:'true'" width="130">设备名称</th>
								<th data-options="field:'dev_model',align:'center',sortable:'true'" width="130">设备型号</th>
								<th data-options="field:'self_num',align:'center',sortable:'true'" width="60">自编号</th>
								<th data-options="field:'license_num',align:'center',sortable:'true'" width="80">牌照号</th>
								<th data-options="field:'producting_date',align:'center',sortable:'true'" width="80">投产日期</th>
								<th data-options="field:'asset_value',align:'center',sortable:'true'" width="90">固定资产原值</th>
								<th data-options="field:'net_value',align:'center',sortable:'true'" width="90">固定资产净值</th>
					</tr>
					</thead>
					<thead>
					<tr>
								<th data-options="field:'owning_org_name_desc',align:'center',sortable:'true'" width="130">所属单位</th>
								<th data-options="field:'usage_org_name_desc',align:'center',sortable:'true'" width="130" >所在单位</th>
								<th data-options="field:'using_stat_desc',align:'center',sortable:'true'" width="60" >使用情况</th>
								<th data-options="field:'tech_stat_desc',align:'center',sortable:'true',hidden:true,dc:false" width="60">技术状况</th>
								<th data-options="field:'project_name_desc',align:'center',sortable:'true'"  width="160" formatter='formatLonger' >项目名称</th>
								<th data-options="field:'dev_position',align:'center',sortable:'true'" formatter='formatLonger' width="160"  >所在位置</th>
								<th data-options="field:'ifcountry_tmp',align:'center',sortable:'true'" width="80">国内/国外</th>
								<th data-options="field:'asset_coding',align:'center',sortable:'true'" width="100">AMIS资产编号</th>
								<th data-options="field:'cont_num',align:'center',sortable:'true'" width="180">合同编号</th>
								<th data-options="field:'turn_num',align:'center',sortable:'true'" width="180">转资单号</th>
								<th data-options="field:'erp_id',align:'center',sortable:'true'" width="130">ERP设备编号</th>
								<th data-options="field:'dev_sign',align:'center',sortable:'true'" width="180">实物标识号</th>
								<th data-options="field:'account_stat_desc',align:'center',sortable:'true'" width="50">资产状况</th>
					 			<!--<th data-options="field:'spare1',align:'center',sortable:'true'" width="135">备注1</th>
								<th data-options="field:'spare2',align:'center',sortable:'true'" width="135">备注2</th>
								<th data-options="field:'spare3',align:'center',sortable:'true'" width="135">备注3</th>-->
					 
			     	</tr> 
			     </thead>
			  </table>
			 </div>
			 
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">设备使用概况</a></li>
			    <li style="margin-left: 5px" id="tag3_1" ><a href="#" onclick="getTab3(1);loaddata('',1)">设备运转记录</a></li>
			    <li style="margin-left: 5px" id="tag3_2" ><a href="#" onclick="getTab3(2);loaddata('',2)">强制保养记录</a></li>
			    <li style="margin-left: 5px" id="tag3_3" ><a href="#" onclick="getTab3(3);loaddata('',3)">单机材料消耗</a></li>
			    <li style="margin-left: 5px" id="tag3_4" ><a href="#" onclick="getTab3(4);loaddata('',4)">设备油品消耗</a></li>
			    <li style="margin-left: 5px"  id="tag3_5" ><a href="#"  onclick="getTab3(5);loaddata('',5)">设备事故记录</a></li>
			    <li style="margin-left: 5px" id="tag3_6" ><a href="#" onclick="getTab3(6);loaddata('',6)">项目修理记录</a></li>
			    <li style="margin-left: 5px"id="tag3_7" ><a href="#" onclick="getTab3(7);loaddata('',7)">定人定机记录</a></li>
			    <li style="margin-left: 5px" id="tag3_10" ><a href="#" onclick="getTab3(10);loaddata('',10)">参与项目</a></li>
			     <li style="margin-left: 5px" id="tag3_12"><a href="####" onclick="getTab3(12);loaddata('',12)">周期费用占比</a></li>
			       <li style="margin-left: 5px" id="tag3_11" ><a href="#" onclick="getTab3(11);loaddata('',11)">其他使用费用</a></li>
			    <li style="margin-left: 5px"id="tag3_8"><a href="#" onclick="getTab3(8)">附件</a></li>
			    <li style="margin-left: 5px" id="tag3_9"><a href="#" onclick="getTab3(9)">备注</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">				
			 		<table id="devMap" width="100%" border="1px" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
				    	    <td style="border-style:solid;"  class="inquire_item8"  rowspan="5">基本信息</td>
						    <td style="border-style:solid;"  class="inquire_item8">设备名称</td>
						    <td style="border-style:solid;"  class="inquire_form6"><input id="dev_acc_name" name="dev_acc_name"  class="input_width" type="text" /></td>
						    <td style="border-style:solid;"  class="inquire_item8">规格型号</td>
						    <td style="border-style:solid;"  class="inquire_form6"><input id="dev_acc_model" name="dev_acc_model" class="input_width" type="text" /></td>
						    <td style="border-style:solid;"  class="inquire_item8">设备编码</td>
						    <td style="border-style:solid;"  class="inquire_form6"><input id="dev_acc_type" name="dev_acc_type" class="input_width" type="text" /></td>
						 </tr>
						 <tr>
						    <td style="border-style:solid;" class="inquire_item8">ERP设备编号</td>
						    <td style="border-style:solid;" class="inquire_form6"><input id="dev_acc_coding" name="dev_acc_coding" class="input_width" type="text" /></td> 
						    <td style="border-style:solid;" class="inquire_item8">自编号</td>
						    <td style="border-style:solid;" class="inquire_form6"><input id="dev_acc_self" name="dev_acc_self" class="input_width" type="text" /></td>
						    <td style="border-style:solid;"  class="inquire_item8">牌照号</td>
						    <td style="border-style:solid;"  class="inquire_form6"><input id="dev_acc_license" name="dev_acc_license" class="input_width" type="text" /></td>
						  </tr>
						  <tr>
						    <td style="border-style:solid;"  class="inquire_item8">实物标识号</td>
						    <td style="border-style:solid;"  class="inquire_form6"><input id="dev_acc_sign" name="" class="input_width" type="text" /></td>
						    <td style="border-style:solid;"class="inquire_item8">发动机号</td>
						    <td style="border-style:solid;"class="inquire_form6"><input id="dev_acc_engine_num" name="" class="input_width" type="text" /></td>
						    <td style="border-style:solid;"class="inquire_item8">底盘号</td>
						    <td style="border-style:solid;" class="inquire_form6"><input id="dev_acc_chassis_num" name="" class="input_width" type="text" /></td>
						  </tr>
						  <tr>						    
						    <td style="border-style:solid;"class="inquire_item8">投产日期</td>
						    <td style="border-style:solid;"class="inquire_form6"><input id="dev_acc_producting_date" name="" class="input_width" type="text" /></td>
						    <td style="border-style:solid;"class="inquire_item8">原值</td>
						    <td style="border-style:solid;"class="inquire_form6"><input id="dev_acc_asset_value" name=""  class="input_width" type="text" /></td>
						    <td style="border-style:solid;"class="inquire_item8">净值</td>
						    <td style="border-style:solid;"class="inquire_form6"><input id="dev_acc_net_value" name="" class="input_width" type="text" /></td>	
						  </tr>
						   <tr>
						    <td style="border-style:solid;"class="inquire_item8">资产状况</td>
						    <td style="border-style:solid;" class="inquire_form6"><input id="dev_acc_asset_stat" name="" class="input_width" type="text" /></td>
						    <td style="border-style:solid;" class="inquire_item8">技术状况</td>
						    <td style="border-style:solid;"class="inquire_form6"><input id="dev_acc_tech_stat" name="" class="input_width" type="text" /></td>
						    <td style="border-style:solid;"class="inquire_item8">使用状况</td>
						    <td style="border-style:solid;" class="inquire_form6"><input id="dev_acc_using_stat" name="" class="input_width" type="text" /></td>
						  </tr>
						  <tr>
						    <td style="border-style:solid;"class="inquire_item8"  rowspan="3">使用</td>
						    <td style="border-style:solid;"class="inquire_item8">所在单位/部室</td>
						    <td style="border-style:solid;" class="inquire_form6"><input id="usage_org_name_desc" name="usage_org_name_desc" class="input_width" type="text" /></td>
						    <td style="border-style:solid;" style="border-style:solid;"class="inquire_item8">当前操作人</td>
						    <td style="border-style:solid;"class="inquire_form6"><input id="oper_name" name="oper_name" class="input_width" type="text" /></td>
						    <td style="border-style:solid;"class="inquire_item8">累计更换人次</td>
						    <td style="border-style:solid;"class="inquire_form6"><input id="oper_num" name="oper_num" class="input_width" type="text" /></td>
						  </tr>
						  <tr>
						    <td style="border-style:solid;" class="inquire_item8">累计行驶公里数(KM)</td>
						    <td style="border-style:solid;" class="inquire_form6"><input id="mileage" name="mileage" class="input_width" type="text" /></td>
						    <td style="border-style:solid;" class="inquire_item8">累计工作小时(h)</td>
						    <td style="border-style:solid;" class="inquire_form6"><input id="work_hour" name="work_hour" class="input_width" type="text" /></td>
						    <td style="border-style:solid;"class="inquire_item8">累计钻进进尺(m)</td>
						    <td style="border-style:solid;"class="inquire_form6"><input id="drilling_footage" name="drilling_footage" class="input_width" type="text" /></td>
						  </tr>
						  <tr>
						    <td style="border-style:solid;"class="inquire_item8">累计项目使用天数</td>
						    <td style="border-style:solid;" class="inquire_form6"><input id="projectUseDays" name="projectUseDays" class="input_width" type="text" /></td>
						    <td style="border-style:solid;"class="inquire_item6"></td>
						    <td style="border-style:solid;"class="inquire_form6"></td>
						    <td style="border-style:solid;"class="inquire_item6"></td>
						    <td style="border-style:solid;"class="inquire_form6"></td>
						  </tr>						  	  
					 	  <tr>
					  		<td style="border-style:solid;"class="inquire_item8"  rowspan="1">保养</td>
						    <td style="border-style:solid;"class="inquire_item8">累计保养费用(万元)</td>
						    <td style="border-style:solid;" class="inquire_form6"><input id="by_cost" name="by_cost" class="input_width" type="text" /></td>
						    <td style="border-style:solid;"class="inquire_item8">累计保养次数</td>
						    <td style="border-style:solid;"class="inquire_form6"><input id="by_count" name="by_count" class="input_width" type="text" /></td>
						    <td style="border-style:solid;"class="inquire_item8">本年度已保养次数</td>
						    <td style="border-style:solid;"class="inquire_form6"><input id="by_year_count" name="by_year_count" class="input_width" type="text" /></td>
						  </tr>
						   <tr>
						     <td style="border-style:solid;"class="inquire_item8"  rowspan="1">故障</td>
						     <td style="border-style:solid;"class="inquire_item8">累计故障次数</td>
						     <td style="border-style:solid;"class="inquire_form6"><input id="" name="" class="input_width" type="text" /></td>
						     <td style="border-style:solid;"class="inquire_item8">累计故障停机时间(h)</td>
						     <td style="border-style:solid;"class="inquire_form6"  colspan='1'><input id="" name="" class="input_width" type="text" /></td>
						     <td style="border-style:solid;"class="inquire_item6"></td>
						     <td style="border-style:solid;"class="inquire_form6"></td>
						  </tr>
						  <tr>
						    <td style="border-style:solid;"class="inquire_item8"  rowspan="2">维修</td>
						    <td style="border-style:solid;"class="inquire_item8">累计维修费用(万元)</td>
						    <td style="border-style:solid;"class="inquire_form6"><input id="wx_cost" name="wx_cost" class="input_width" type="text" /></td>
						    <td style="border-style:solid;"class="inquire_item8">累计维修次数</td>
						    <td style="border-style:solid;"class="inquire_form6"><input id="wx_count" name="wx_count" class="input_width" type="text" /></td>
						    <td style="border-style:solid;"class="inquire_item8">发动机修理次数</td>
						    <td style="border-style:solid;"class="inquire_form6"><input id="wx_eng_count" name="wx_eng_count" class="input_width" type="text" /></td>
						  </tr>
						   <tr>
						    <td style="border-style:solid;"class="inquire_item8">本年度维修次数</td>
						    <td style="border-style:solid;"class="inquire_form6"><input id="wx_year_count" name="wx_year_count" class="input_width" type="text" /></td>
						    <td style="border-style:solid;"class="inquire_item8">本年度维修费用(万元)</td>
						    <td style="border-style:solid;"class="inquire_form6"  colspan='1'><input id="wx_year_cost" name="wx_year_cost" class="input_width" type="text" /></td>
						    <td style="border-style:solid;"class="inquire_item6"></td>
						    <td style="border-style:solid;"class="inquire_form6"></td>
						  </tr>						               
			        </table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<div style="overflow:auto">
				      <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						  <tr align="right">
						  	<td class="inquire_item6">累计里程(公里):</td>
							<td class="inquire_form6">
								<input id="v_mileage" name="v_mileage" class="input_width" type="text" readonly/>
							</td>
							<td class="inquire_item6">累计钻井进尺(米):</td>
							<td class="inquire_form6">
								<input id="v_drilling_footage" name="v_drilling_footage"  class="input_width" type="text" readonly/>
							</td>
							<td class="inquire_item6">累计工作小时(小时):</td>
							<td class="inquire_form6">
								<input id="v_work_hour" name="v_work_hour"  class="input_width" type="text" readonly/>
							</td>
						  </tr>
						</table>
				</div>
				<table id="yzMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
					<tr>   
						<td class="bt_info_odd">序号</td>
						<td class="bt_info_odd">年份</td>
						<!-- <td class="bt_info_odd">里程</td> -->
						<td class="bt_info_odd">累计里程</td>
						<td class="bt_info_even">累计钻井进尺</td>
						<td class="bt_info_odd">累计工作小时</td>
						<td class="bt_info_odd">查看明细</td>
					 </tr>	
					 <tbody id="assign_body"></tbody>
				</table>
			</div>
			<!--强制保养-->
			<div id="tab_box_content2" class="tab_box_content" style="display:none;">
			<div style="overflow:auto">
				      <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						  <tr align="right">
						  	<td class="inquire_item6">合计工时费(元):</td>
							<td class="inquire_form6">
								<input id="v_qz_human_cost" name="v_human_cost" class="input_width" type="text" style="width:160px;" readonly/>
							</td>
							<td class="inquire_item6">合计材料费(元):</td>
							<td class="inquire_form6">
								<input id="v_qz_material_cost" name="v_material_cost"  class="input_width" type="text" style="width:160px;" readonly/>
							</td>
						  </tr>
						</table>
					</div>
				<table id="byMap" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
					 <tr>   
					 	<td class="bt_info_odd">序号</td>
					 	<td class="bt_info_even">年份</td>
					    <td class="bt_info_odd">工时费</td>
					    <td class="bt_info_even">材料费</td>
					    <td class="bt_info_odd">查看明细</td>
					  </tr>
					  <tbody id="assign_body"></tbody>
					</table>
			</div>
			<!--单机材料消耗-->
			<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				<div style="overflow:auto">
				      <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						  <tr align="right">
						  	<td class="inquire_item6">累计出库数量:</td>
							<td class="inquire_form6">
								<input id="v_out_num" name="v_out_num" class="input_width" type="text" readonly/>
							</td>
							<td class="inquire_item6">累计消耗数量:</td>
							<td class="inquire_form6">
								<input id="v_material_amout" name="v_material_amout"  class="input_width" type="text" readonly/>
							</td>
							<td class="inquire_item6">累计总价(元):</td>
							<td class="inquire_form6">
								<input id="v_total_charge" name="v_total_charge"  class="input_width" type="text" readonly/>
							</td>
						  </tr>
						</table>
				</div>
				<table id="metMap" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;">
			  <tr>  
			  	  <td class="bt_info_odd">序号</td>
				  <td class="bt_info_even">年份</td>
				 <!-- <td class="bt_info_odd">计划单号</td>
				  <td class="bt_info_even">材料名称</td>
				  <td class="bt_info_odd">材料编号</td>
				  <td class="bt_info_even">单价</td> -->
				  <td class="bt_info_odd">出库数量</td>
				  <td class="bt_info_even">消耗数量</td>
				  <td class="bt_info_odd">总价</td>
				  <td class="bt_info_even">查看明细</td>			  
			  </tr>
			  <tbody id="assign_body"></tbody>
		  </table>
			</div>
			<!--油水消耗-->
			<div id="tab_box_content4" class="tab_box_content" style="display:none;">
				<div style="overflow:auto">
				    <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						  <tr align="right">
						  	<td class="inquire_item6">项目累计数量(升):</td>
							<td class="inquire_form6">
								<input id="v_oil_num" name="v_oil_num" class="input_width" type="text" style="width:160px;" readonly/>
							</td>
							<td class="inquire_item6">项目累计金额(元):</td>
							<td class="inquire_form6">
								<input id="v_total_money" name="v_total_money"  class="input_width" type="text" style="width:160px;" readonly/>
							</td>
						  </tr>
					</table>
				</div>
				<table id="ysMap" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
						<tr>   
						<td class="bt_info_odd">序号</td>
					    <td class="bt_info_odd">年份</td>
						<!-- <td class="bt_info_even">加注日期</td>
						<td class="bt_info_odd">油品名称</td>
						<td class="bt_info_even">单位</td>
					    <td class="bt_info_odd">数量</td> -->
						<td class="bt_info_even">累计数量</td>
					    <!-- <td class="bt_info_odd">单价（元）</td> -->
					    <td class="bt_info_even">累计金额（元） </td>
					    <td class="bt_info_odd">查看明细</td>
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
					    <td class="bt_info_even">操作手</td>
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
			<!-- 项目修理记录 -->
			<div id="tab_box_content6" class="tab_box_content" style="display:none;">
				<div style="overflow:auto">
				      <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						  <tr align="right">
						  	<td class="inquire_item6">合计工时费(元):</td>
							<td class="inquire_form6">
								<input id="v_human_cost" name="v_human_cost" class="input_width" type="text" style="width:160px;" readonly/>
							</td>
							<td class="inquire_item6">合计材料费(元):</td>
							<td class="inquire_form6">
								<input id="v_material_cost" name="v_material_cost"  class="input_width" type="text" style="width:160px;" readonly/>
							</td>
						  </tr>
						</table>
					</div>
					<table id="whMap" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
						<tr>  
						<td class="bt_info_even">序号</td>
						<td class="bt_info_odd">年份</td>
					    <!-- <td class="bt_info_even">修理类别</td>        
					    <td class="bt_info_odd">修理项目</td>
					    <td class="bt_info_even">修理详情</td>
					    <td class="bt_info_odd">送修日期</td>
					    <td class="bt_info_even">竣工日期</td> -->
					    <td class="bt_info_even">工时费</td>
					    <td class="bt_info_odd">材料费</td>
					    <!-- <td class="bt_info_odd">承修人</td>
					    <td class="bt_info_even">验收人</td> -->
					    <td class="bt_info_even">查看明细</td>
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
			<div id="tab_box_content10" class="tab_box_content" style="display:none;">
				<table id="djMap" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
					<tr>   
						<td class="bt_info_even">序号</td>
						<td class="bt_info_odd">所属单位</td>
						<td class="bt_info_even">项目名称</td>
						<td class="bt_info_odd">在队天数</td>
						<td class="bt_info_even">入队时间</td>						
						<td class="bt_info_odd">离队时间</td>						
				   </tr>
				   <tbody id="assign_body"></tbody>
				</table>
			</div>
			<!--周期费用占比-->
			<div id="tab_box_content12" class="tab_box_content" style="display:none;">
			<table id="div_table" width="90%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<div class="tongyong_box">
							<div class="tongyong_box_content_left" id="chartContainer1"></div>
						</div>
					</td>
				</tr>
				<tr>
					
				</tr>
			</table>
			<table id="lineTable" border="1" align="center" width="80%" class="tab_info">
			</table>
			</div>		
				<!--其他使用费用-->
			<div id="tab_box_content11" class="tab_box_content" style="display:none;">
				 <div style="overflow:auto">
				      <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						  <tr align="left">
						  	<td class="inquire_item8"  >合计费用(元):</td>
							<td class="inquire_form8"  >
								<input id="v_sum_cost" name="v_sum_cost" class="input_width" type="text" style="width:160px;" readonly/>
							</td>
						  </tr>
						</table>
					</div>
				<table id="byMap" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
					 <tr>   
					 	<td class="bt_info_odd">序号</td>
					 	<td class="bt_info_even">年份</td>
					    <td class="bt_info_odd">使用费</td>
					    <td class="bt_info_odd">查看明细</td>
					  </tr>
					  <tbody id="assign_body"></tbody>
					</table>
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
	setTabBoxHeight();
}
$(function(){
	
	 
	$("#queryRetTable").datagrid({ 
		method:'post',
		nowrap:false,
		rownumbers:true,//行号 
		title:"",
		toolbar:'#tb2',
		border:false,
		striped:true,
		singleSelect:true,//是否单选 
		pagination:true,//分页控件 
		selectOnCheck:true,
		fit:true,//自动大小 
		fitColumns:false,
		showFooter: true,
		pageList: [10, 20, 50, 100,200],
		queryParams:{projectInfoNo:'<%=projectInfoNo%>',code:'<%=code%>',isDeviceCode:'<%=is_devicecode%>',orgSubId:'<%=userSubid%>',userOrgId :'<%=userSubid%>',orgId:'<%=orgId%>'},
		onClickRow:function(index,data){
			currentId = data.dev_acc_id;
			if(selectedTagIndex==0){
			loadDataDetail(currentId);
			}else{
			loaddata(currentId+"~",selectedTagIndex);
			}
		},url:"${pageContext.request.contextPath}/dmsManager/safekeeping/queryKeepingConfInfoList.srq?JCDP_SRV_NAME=DevCommInfoSrv&JCDP_OP_NAME=queryDeviceList",
		onLoadSuccess : function(data1) {
			for(var i = 0; i < data1.rows.length; i++){
			 
                if(data1.rows[i].dev_position!= undefined&&data1.rows[i].dev_position!='undefined'){
                    var dev_position = data1.rows[i].dev_position;
                    tipView('orgName-' + dev_position,dev_position,'top');
                }
               if(data1.rows[i].project_name_desc!= undefined&&data1.rows[i].project_name_desc!='undefined'){
                    var project_name_desc = data1.rows[i].project_name_desc;
                    tipView('orgName-' + project_name_desc,project_name_desc,'top');
                }
                
            }
        }		
		 
	});
	
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
</script>
 
<script type="text/javascript">
	var orgtype = '<%=orgType%>';//大港8个专业化中心判断
	var zhequsub = '<%=zhEquSub%>';
	var usersubid = '<%=userSubid%>';
	var taskIds = '<%=taskId%>';
	var projectInfoNos = '<%=projectInfoNo%>';
	function exportDatForEasyUI1(){
	exportForEasyUI('queryRetTable','单台设备',1,99,'<%=contextPath%>');
	}
	function searchDevData(){
		var v_dev_name = document.getElementById("s_dev_name").value;
		var v_dev_model = document.getElementById("s_dev_model").value;
		var v_license_num = document.getElementById("s_license_num").value;
		var owning_org_id = document.getElementById("owning_org_id").value;
		
		var params = {};
		params["query_dev_name"] = v_dev_name;
		params["query_dev_model"] = v_dev_model;
		params["query_license_num"] = v_license_num;
		params["query_owning_sub_id"] = owning_org_id;
		params["code"] = '<%=code%>';
		params["isDeviceCode"] = '<%=is_devicecode%>';
		
		params["orgSubId"] = '<%=userSubid%>';
		params["userOrgId"] = '<%=userSubid%>';
		params["orgId"] = '<%=orgId%>';
		$("#queryRetTable").datagrid('reload',params);
		 
	}
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_dev_name").value="";
    	document.getElementById("s_dev_model").value="";
		document.getElementById("s_own_org_name").value="";
		document.getElementById("s_own_org_id").value="";
		document.getElementById("s_license_num").value="";		
    }
	 
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	
	//打开新增界面
	function toAdd(){   
		//popWindow("<%=contextPath%>/rm/dm/deviceAccount/loaderInfo.upmd?pagerAction=edit2Add");
		popWindow("<%=contextPath%>/rm/dm/deviceAccount/toAdd.jsp");
		//window.open('<%=contextPath%>/rm/dm/deviceAccount/toAdd.jsp','','height=470,width=800,top=150,toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no,depended=no');
		//
		//window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/toAdd.jsp","test","dialogWidth=820px;dialogHeight=470px;location:no;status:no;");
		//top.Dialog.open({URL:"<%=contextPath%>/rm/dm/deviceAccount/toAdd.jsp",Width:1000,Height:400,Title:"选择维修配件"});		
	}

    //修改界面
    function toEdit(){
		 var row = $('#queryRetTable').datagrid('getSelected');
		if(!row){  alert("请选择一条信息!");  return;  }  
		
	 
		 
		
		if(row.spare4 != '1' && row.using_stat != '0110000007000000001' && row.saveflag != '1'){
			editUrl = "<%=contextPath%>/rm/dm/deviceAccount/toEditErp.jsp?id={id}";  
			editUrl = editUrl.replace('{id}',row.dev_acc_id); 
			//editUrl += '&pagerAction=edit2Edit';
		  	popWindow(editUrl); 
		    return;
		} 
		if(row.using_stat == '0110000007000000001' || row.saveflag == '1'){
		    alert("在用设备不能修改!");
		    return;
		}
		editUrl = "<%=contextPath%>/rm/dm/deviceAccount/toEdit.jsp?id={id}";  
		editUrl = editUrl.replace('{id}',row.dev_acc_id); 
 
		//editUrl += '&pagerAction=edit2Edit';
	  	popWindow(editUrl); 
	  } 
	   
    
	//点击记录查询明细信息
    function loadDataDetail(shuaId){
    	var retObj;
        var syObj;
        var puObj;
    	var info = shuaId.split("~" , -1);
		if(info[0]!=null){
			 retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfo", "deviceId="+info[0]);
			 //syObj = jcdpCallService("DevCommInfoSrv", " getDevAccUseInfo", "deviceId="+info[0]);			
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		     retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfo", "deviceId="+info[0]);
		      //syObj = jcdpCallService("DevCommInfoSrv", "getDevAccUseInfo", "deviceId="+info[0]);     
		}
		//取消选中框--------------------------------------------------------------------------
    	var obj = document.getElementsByName("rdo_entity_id");  
        for (i=0; i<obj.length; i++){   
            obj[i].checked = false;   
             
        } 
		//选中这一条checkbox
		$("#rdo_entity_id_"+retObj.deviceaccMap.dev_acc_id).attr("checked","checked");
		//选中这一条checkbox
		//$("#rdo_entity_id"+retObj.deviceaccMap.dev_acc_id).attr("checked","checked");
		//取消其他选中的
		//$("input[type='checkbox'][name='rdo_entity_id'][id!='selectedbox_"+retObj.deviceaccMap.dev_acc_id+"']").removeAttr("checked");
		//------------------------------------------------------------------------------------设备配置信息
		//设备名称
		document.getElementById("dev_acc_name").value =retObj.deviceaccMap.dev_name;
		//规格型号
		document.getElementById("dev_acc_model").value =retObj.deviceaccMap.dev_model;
		//设备编码
		document.getElementById("dev_acc_type").value =retObj.deviceaccMap.dev_type;
		//erp设备编号
		document.getElementById("dev_acc_coding").value =retObj.deviceaccMap.dev_coding;
		//自编号
		document.getElementById("dev_acc_self").value =retObj.deviceaccMap.self_num;
		//牌照号
		document.getElementById("dev_acc_license").value =retObj.deviceaccMap.license_num;
		//实物标识号
		document.getElementById("dev_acc_sign").value =retObj.deviceaccMap.dev_sign;
		//发动机号
		document.getElementById("dev_acc_engine_num").value =retObj.deviceaccMap.engine_num;
		//底牌号
		document.getElementById("dev_acc_chassis_num").value =retObj.deviceaccMap.chassis_num;
		//投产日期
		document.getElementById("dev_acc_producting_date").value =retObj.deviceaccMap.producting_date;
		//资产原值
		document.getElementById("dev_acc_asset_value").value =retObj.deviceaccMap.asset_value;
		//资产净值
		document.getElementById("dev_acc_net_value").value =retObj.deviceaccMap.net_value;
		//资产状态
		document.getElementById("dev_acc_asset_stat").value =retObj.deviceaccMap.stat_desc;
		//技术状态
		document.getElementById("dev_acc_tech_stat").value =retObj.deviceaccMap.tech_stat_desc;
		//使用状态
		document.getElementById("dev_acc_using_stat").value =retObj.deviceaccMap.using_stat_desc;
		//所在单位
		document.getElementById("usage_org_name_desc").value =retObj.deviceaccMap.usage_org_name_desc;
		//当前操作人
		document.getElementById("oper_name").value =retObj.oper_name;
		//累计更换人次
		document.getElementById("oper_num").value =retObj.oper_num;
		//累计行驶公里数
		document.getElementById("mileage").value =retObj.deviceUseMap.mileage_total;
		//累计工作小时
		document.getElementById("work_hour").value =retObj.deviceUseMap.work_hour_total;
		//累计钻井进尺
		document.getElementById("drilling_footage").value =retObj.deviceUseMap.drilling_footage_total;
		//累计项目使用天数
		document.getElementById("projectUseDays").value =retObj.devicePUseMap.days;
		//累计保养费用		
		document.getElementById("by_cost").value =retObj.deviceByCostMap.by_cost;
		//累计保养次数
		document.getElementById("by_count").value =retObj.deviceByCountMap.bycount;
		//本年度累计保养次数
		document.getElementById("by_year_count").value =retObj.deviceByCountYearMap.bycount;
		//累计故障次数
		//累计停机时间（H）

		//累计维修费用（万元）
		document.getElementById("wx_cost").value =retObj.deviceWxCostMap.wxcost;
		//累计维修次数
		document.getElementById("wx_count").value =retObj.deviceWxCountMap.wxcount;
		//发动机修理次数
		document.getElementById("wx_eng_count").value =retObj.deviceWxEngCountMap.wxcount;
		//本年度维修次数
		document.getElementById("wx_year_count").value =retObj.deviceWxCountYearMap.wxcount;
		//本年底维修费用（万元）
		document.getElementById("wx_year_cost").value =retObj.deviceWxCostYearMap.wxcost;
		//备注
		document.getElementById("dev_acc_remark").value =retObj.deviceaccMap.remark;
		//document.getElementById("project_name_desc").value =retObj.deviceaccMap.project_name_desc;
		if(shuaId==null)
			shuaId = ids;
		loaddata(shuaId,selectedTagIndex);
    }
	
	function toDelete(){
 		 var row = $('#queryRetTable').datagrid('getSelected');
	    if(!row){ 
		    alert("请先选中一条记录!");
	     	return;
	    }
	   
	    
	    if(row.spare4 != '1'){
		    alert("ERP同步设备不能删除!");
		    return;
		}
		if(row.using_stat == '0110000007000000001' || row.saveflag == '1'){
		    alert("在用设备不能删除!");
		    return;
		}
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("DevCommInfoSrv", "deleteUpdate", "deviceId="+info[0]);
			queryData(cruConfig.currentPage);
		}
	}
	//查询及返回刷新
	function searchDevData1(obj){
  	var params=obj.params;
  		params["code"] = '<%=code%>';
		params["isDeviceCode"] = '<%=is_devicecode%>';
    $('#queryRetTable').datagrid({ queryParams:params });   //点击搜索
	}
	//打开查询条件页面
    function newSearch(){
    window.top.$.JDialog.open('${pageContext.request.contextPath}/rm/dm/deviceAccount/devqueryEasyUI.jsp',{
        win:window,
        width:840,
        height:480,
        title:"高级查询",
		callback:searchDevData1 //设置回调函数
     } ); 
    	 
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
	 
	function toCopy(){
 		ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
		    alert("请先选中一条记录!");
	     	return;
	    }
	    info = ids.split("~",-1);
	    var querySql="select count(*) as unpro_count from GMS_DEVICE_ACCOUNT_UNPRO p where p.fk_dev_acc_id='"+info[0]+"' and p.IS_LEAVING='0'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
		unProCount = queryRet.datas;
	
		if (unProCount == undefined) {
			return;
		}
		if(unProCount[0].unpro_count>0){
			alert("改设备已在非生产单位现场管理中,请勿重复选择！");
			return;
		}
		if(confirm('确定要将设备导入到非生产单位现场管理吗?')){  
			var retObj = jcdpCallService("DevInsSrv", "copyToUnPro", "deviceId="+info[0]);
			var result=retObj.info;
			if(result!=undefined){
				if(result=='转入成功'){
					var devId=retObj.devId;
					if(confirm('是否对该设备设置保养计划?')){  
						popWindow("<%=contextPath%>/rm/dm/device-xd/dev_byjh.jsp?ids="+devId); 
						return;
					}				
					queryData(cruConfig.currentPage);
				}else{
					alert("未知错误！");
				}
				queryData(cruConfig.currentPage);
			}
		}
	}
	/**
	 * 延迟加载*****************************************************************************************************************************
	 * @param {Object} index
	 */
	function loaddata(ids,index){	
		
	  
		selectedTagIndex=index;		
		if (ids == "") {			
			 ids = $('#queryRetTable').datagrid('getSelected').dev_acc_id+"~";
			if (ids == '') {
				//			    alert("请先选中一条记录!");
				return;
			}
		}
		 
		if(index==1){
			yzjl(ids);}
		else if(index==2) {
			qzby(ids);}
		else if(index==3) {
			djxh(ids);}
		else if(index==4) {
			ysjl(ids);}
		else if(index==5) {
			sgjl(ids);}
		else if(index==6) {
			wsjl(ids);}
		else if(index==7) {
			djjl(ids);}
		else if(index==10){
			pro(ids);}
		else if(index==11){
			sbfy(ids);}
		else if(index==12){
			getFieldCaptialFusionChart(ids);
		 	getData(ids);}
	}
	 /**
		 * 运转记录****************************************************************************************************************************
		 * @param {Object} shuaId
	*/
	function yzjl(shuaId){	 
		var retObj;
		var sum_mileage="0";
		var sum_drilling_footage="0";
		var sum_work_hour="0";
		var postion=shuaId.indexOf("~");
		shuaId=shuaId.substring(0,postion);
	 
        var querySql = " select nvl(sum(tmp.mileage_total), 0) as mileage_total,nvl(sum(tmp.drilling_footage_total), 0) as drilling_footage_total, nvl(sum(tmp.work_hour_total), 0) as work_hour_total,tmp.modify_date";
         querySql += " from (select nvl(info.mileage, 0) as mileage_total,nvl(info.drilling_footage, 0) as drilling_footage_total,nvl(info.work_hour, 0) as work_hour_total,to_char(info.modify_date, 'yyyy') as modify_date,dui.fk_dev_acc_id as dev_acc_id ";
         querySql += " from gms_device_operation_info info inner join gms_device_account_dui dui on info.dev_acc_id = dui.dev_acc_id union all ";
         querySql += " select nvl(info.mileage, 0) as mileage_total,nvl(info.drilling_footage, 0) as drilling_footage_total,nvl(info.work_hour, 0) as work_hour_total,to_char(info.modify_date, 'yyyy') as modify_date,acc.dev_acc_id ";
         querySql += " from gms_device_operation_info info inner join gms_device_account acc on info.dev_acc_id = acc.dev_acc_id ";
         querySql += " ) tmp where tmp.dev_acc_id='"+shuaId+"' group by tmp.modify_date order by tmp.modify_date desc ";
        
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj= queryRet.datas;

		var size = $("#assign_body", "#tab_box_content1").children("tr").size();
		if (size > 0) {
			$("#assign_body", "#tab_box_content1").children("tr").remove();
		}
		var by_body1 = $("#assign_body", "#tab_box_content1")[0];
		if (retObj != undefined) {
			for (var i = 0; i < retObj.length; i++) {
				var columnsObj ;
				$("input[type='checkbox']", "#queryRetTable").each(function(){
					if(this.checked){
						columnsObj = this.parentNode.parentNode.cells;
					}
				});
				var newTr = by_body1.insertRow();
					
				var newTd = newTr.insertCell();
				newTd.innerText = i+1;
				newTr.insertCell().innerText=retObj[i].modify_date;
				newTr.insertCell().innerText=retObj[i].mileage_total;
				newTr.insertCell().innerText=retObj[i].drilling_footage_total;
				newTr.insertCell().innerText=retObj[i].work_hour_total;
				newTr.insertCell().innerHTML = "<a onClick='openYzjlView(\""+shuaId+"\",\""+retObj[i].modify_date+"\")'>查看</a>";
				sum_mileage = Number(sum_mileage) + Number(retObj[i].mileage_total);
				sum_drilling_footage = Number(sum_drilling_footage) + Number(retObj[i].drilling_footage_total);
				sum_work_hour = Number(sum_work_hour) + Number(retObj[i].work_hour_total);
			}
		}
		document.getElementById("v_mileage").value = sum_mileage;
		document.getElementById("v_drilling_footage").value = sum_drilling_footage;
		document.getElementById("v_work_hour").value = sum_work_hour;
		
		$("#assign_body>tr:odd>td:odd",'#tab_box_content1').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#tab_box_content1').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#tab_box_content1').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#tab_box_content1').addClass("even_even");
	}
		 function openYzjlView(id,year){
				if(id != ''){

					window.showModalDialog("<%=contextPath%>/rm/dm/deviceArchive/devArchiveView_yzjl.jsp?devaccid="+id+"&year="+year,"","dialogWidth=1050px;dialogHeight=480px");
				}else{
					alert("未知错误!");
					return;
				}
			}
		 /**
			 * 强制保养****************************************************************************************************************************
			 * @param {Object} shuaId
		*/
		function qzby(shuaId){
				 
			var retObj;
			var sum_human_cost="0";
			var sum_material_cost="0";	
			var postion=shuaId.indexOf("~");
			shuaId=shuaId.substring(0,postion);

			var querySql = "select nvl(sum(tmp.human_cost), 0) as human_cost,nvl(sum(tmp.material_cost), 0) as material_cost,tmp.modifi_date ";
			    querySql += " from (select nvl(info.human_cost, 0) as human_cost,nvl(info.material_cost, 0) as material_cost,to_char(info.modifi_date, 'yyyy') as modifi_date,dui.fk_dev_acc_id as dev_acc_id ";
			    querySql += " from BGP_COMM_DEVICE_REPAIR_INFO info inner join gms_device_account_dui dui on info.DEVICE_ACCOUNT_ID = dui.dev_acc_id where info.repair_type='0110000037000000002' ";
			    querySql += " union all ";
			    querySql += " select nvl(info.human_cost, 0) as human_cost,nvl(info.material_cost, 0) as material_cost,to_char(info.modifi_date, 'yyyy') as modifi_date,acc.dev_acc_id ";
			    querySql += " from BGP_COMM_DEVICE_REPAIR_INFO info inner join gms_device_account acc on info.DEVICE_ACCOUNT_ID = acc.dev_acc_id where info.repair_type='0110000037000000002' ) tmp";
			    querySql += " where tmp.dev_acc_id ='"+shuaId+"' group by tmp.modifi_date order by tmp.modifi_date desc ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj= queryRet.datas;

			var size = $("#assign_body", "#tab_box_content2").children("tr").size();
			if (size > 0) {
				$("#assign_body", "#tab_box_content2").children("tr").remove();
			}
			var by_body1 = $("#assign_body", "#tab_box_content2")[0];
			if (retObj != undefined) {
				for (var i = 0; i < retObj.length; i++) {
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
				newTd1.innerText = retObj[i].modifi_date;
				newTr.insertCell().innerText=retObj[i].human_cost;
				newTr.insertCell().innerText=retObj[i].material_cost;
				newTr.insertCell().innerHTML = "<a onClick='openQzbyView(\""+shuaId+"\",\""+retObj[i].modifi_date+"\")'>查看</a>";
				sum_human_cost = Number(sum_human_cost) + Number(retObj[i].human_cost);
				sum_material_cost = Number(sum_material_cost) + Number(retObj[i].material_cost);
				}
			}
			document.getElementById("v_qz_human_cost").value = sum_human_cost;
			document.getElementById("v_qz_material_cost").value = sum_material_cost;
		
			$("#assign_body>tr:odd>td:odd",'#tab_box_content2').addClass("odd_odd");
			$("#assign_body>tr:odd>td:even",'#tab_box_content2').addClass("odd_even");
			$("#assign_body>tr:even>td:odd",'#tab_box_content2').addClass("even_odd");
			$("#assign_body>tr:even>td:even",'#tab_box_content2').addClass("even_even");
		}   	
		function openQzbyView(devid,year){
			if(devid != ''){
				window.showModalDialog("<%=contextPath%>/rm/dm/deviceArchive/devArchiveView_qzby.jsp?devaccid="+devid+"&projectinfoid="+year,"","dialogWidth=1050px;dialogHeight=480px");
			}else{
				alert("未知错误!");
				return;
			}
		}	
			 /**
				* 单机材料消耗****************************************************************************************************************************
				* @param {Object} shuaId
			*/
			function djxh(shuaId){
										 
				var retObj;
				var sum_out_num="0";
				var sum_material_amout="0";
				var sum_total_charge="0";
				var postion=shuaId.indexOf("~");
				shuaId=shuaId.substring(0,postion);
				var querySql = "select tmp.modifydate,nvl(sum(tmp.total_charge), 0) total_charge,nvl(sum(tmp.material_amout), 0) material_amout,nvl(sum(tmp.out_num), 0) out_num ";
				    querySql += " from (select dui.fk_dev_acc_id as dev_acc_id,nvl(info.total_charge, 0) total_charge,nvl(info.material_amout, 0) material_amout,nvl(info.out_num, 0) out_num,to_char(info.modifi_date, 'yyyy') as modifydate ";
				    querySql += " from BGP_COMM_DEVICE_REPAIR_DETAIL info left join BGP_COMM_DEVICE_REPAIR_INFO inf on info.repair_info=inf.repair_info inner join gms_device_account_dui dui on inf.device_account_id = dui.dev_acc_id where info.bsflag = '0' ";
				    querySql += " union all ";
				    querySql += " select acc.dev_acc_id,nvl(info1.total_charge, 0) total_charge,nvl(info1.material_amout, 0) material_amout,nvl(info1.out_num, 0) out_num,to_char(info1.modifi_date, 'yyyy') as modifydate ";
				    querySql += " from BGP_COMM_DEVICE_REPAIR_DETAIL info1 left join BGP_COMM_DEVICE_REPAIR_INFO inf1 on info1.repair_info=inf1.repair_info inner join gms_device_account acc on inf1.device_account_id = acc.dev_acc_id where info1.bsflag = '0' )tmp ";
				    querySql += " where tmp.dev_acc_id='"+shuaId+"' group by tmp.modifydate ";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql+"&pageSize=1000");
					retObj= queryRet.datas;
				var size = $("#assign_body", "#tab_box_content3").children("tr").size();
					if(size > 0){
						$("#assign_body", "#tab_box_content3").children("tr").remove();
					}
				var by_body1 = $("#assign_body", "#tab_box_content3")[0];
					if (retObj != undefined){
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
							newTd1.innerText = retObj[i].modifydate;					
							newTr.insertCell().innerText=retObj[i].out_num;
							newTr.insertCell().innerText=retObj[i].material_amout;
							newTr.insertCell().innerText=retObj[i].total_charge;
							newTr.insertCell().innerHTML = "<a onClick='openDjxhView(\""+shuaId+"\",\""+retObj[i].modifydate+"\")'>查看</a>";
							
							sum_out_num = Number(sum_out_num) + Number(retObj[i].out_num);
							sum_material_amout = Number(sum_material_amout) + Number(retObj[i].material_amout);
							sum_total_charge = Number(sum_total_charge) + Number(retObj[i].total_charge);
						}
					}
					document.getElementById("v_out_num").value = sum_out_num;
					document.getElementById("v_material_amout").value = sum_material_amout;
					document.getElementById("v_total_charge").value = sum_total_charge;
					
				$("#assign_body>tr:odd>td:odd",'#tab_box_content3').addClass("odd_odd");
				$("#assign_body>tr:odd>td:even",'#tab_box_content3').addClass("odd_even");
				$("#assign_body>tr:even>td:odd",'#tab_box_content3').addClass("even_odd");
				$("#assign_body>tr:even>td:even",'#tab_box_content3').addClass("even_even");
			}
				function openDjxhView(devid,proid){
					if(devid != ''){
						window.showModalDialog("<%=contextPath%>/rm/dm/deviceArchive/devArchiveView_djxh.jsp?devaccid="+devid+"&projectinfoid="+proid,"","dialogWidth=1050px;dialogHeight=480px");
					}else{
						alert("未知错误!");
						return;
					}
				}
				/**
				* 油水消耗****************************************************************************************************************************
				* @param {Object} shuaId
			 */
			function ysjl(shuaId){
						 
				var retObj;
				var sum_oil_num=0;
				var sum_total_money=0;
				var postion=shuaId.indexOf("~");
				shuaId=shuaId.substring(0,postion);

				var querySql = " select tmp.modifi_date,nvl(sum(tmp.oil_num), 0) oil_num,nvl(sum(tmp.total_money), 0) total_money ";
					querySql += " from (select dui.fk_dev_acc_id as dev_acc_id,nvl(d.oil_num, 0) oil_num,nvl(d.total_money, 0) total_money,to_char(t.modifi_date, 'yyyy') as modifi_date ";
					querySql += " from gms_mat_teammat_out t left join GMS_MAT_TEAMMAT_OUT_DETAIL d  on t.teammat_out_id = d.teammat_out_id inner join gms_device_account_dui dui on dui.dev_acc_id = d.dev_acc_id ";
					querySql += " where t.out_type = '3' and t.bsflag = '0' ";
					querySql += " union all "
					querySql += " select acc.dev_acc_id,nvl(d.oil_num, 0) oil_num,nvl(d.total_money, 0) total_money,to_char(t.modifi_date, 'yyyy') as modifi_date ";
					querySql += " from gms_mat_teammat_out t left join GMS_MAT_TEAMMAT_OUT_DETAIL d on t.teammat_out_id = d.teammat_out_id inner join gms_device_account acc on acc.dev_acc_id = d.dev_acc_id ";
					querySql += " where t.out_type = '3' and t.bsflag = '0' ) tmp where tmp.dev_acc_id = '"+shuaId+"' group by tmp.modifi_date order by tmp.modifi_date desc";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
					retObj= queryRet.datas;
				var size = $("#assign_body", "#tab_box_content4").children("tr").size();
				if (size > 0) {
					$("#assign_body", "#tab_box_content4").children("tr").remove();
				}
				var by_body1 = $("#assign_body", "#tab_box_content4")[0];
				if (retObj != undefined) {
					for (var i = 0; i < retObj.length; i++) {
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
						newTd1.innerText = retObj[i].modifi_date;
						newTr.insertCell().innerText=retObj[i].oil_num;
						newTr.insertCell().innerText=retObj[i].total_money;
						newTr.insertCell().innerHTML = "<a onClick='openYsjlView(\""+shuaId+"\",\""+retObj[i].modifi_date+"\")'>查看</a>";
			            
						sum_oil_num = Number(sum_oil_num) + Number(retObj[i].oil_num);
						sum_total_money = Number(sum_total_money) + Number(retObj[i].total_money);
					}
				}
				document.getElementById("v_oil_num").value = sum_oil_num.toFixed(2);
				document.getElementById("v_total_money").value = sum_total_money.toFixed(2);
				
				$("#assign_body>tr:odd>td:odd",'#tab_box_content4').addClass("odd_odd");
				$("#assign_body>tr:odd>td:even",'#tab_box_content4').addClass("odd_even");
				$("#assign_body>tr:even>td:odd",'#tab_box_content4').addClass("even_odd");
				$("#assign_body>tr:even>td:even",'#tab_box_content4').addClass("even_even");
			}
			function openYsjlView(devid,proid){
				if(devid != ''){
					window.showModalDialog("<%=contextPath%>/rm/dm/deviceArchive/devArchiveView_ysjl.jsp?devaccid="+devid+"&projectinfoid="+proid,"","dialogWidth=1050px;dialogHeight=480px");
				}else{
					alert("未知错误!");
					return;
				}
			}
			/**
			* 事故记录****************************************************************************************************************************
			* @param {Object} shuaId
		*/
		function sgjl(shuaId){
				var postion=shuaId.indexOf("~");
				shuaId=shuaId.substring(0,postion);	 
			var retObj;
			var querySql="select  distinct pro.project_name,acc.dev_name,acc.asset_coding,info.*,det1.coding_name as accident_properties1,det2.coding_name as accident_grade1,(select  wmsys.wm_concat(p.operator_name) as operator_name  from  gms_device_equipment_operator p ,GMS_DEVICE_ARCHIVE_DETAIL arc where  p.device_account_id = dui.dev_acc_id    and p.entity_id=arc.dev_archive_refid and arc.dev_archive_type='5' and  p.bsflag='0' and dui.project_info_id=p.project_info_id) as operator_name  from BGP_COMM_DEVICE_ACCIDENT_INFO info "+
					"left join GMS_DEVICE_ARCHIVE_DETAIL arc on arc.dev_archive_refid=info.accident_info_id "+
					"left join gms_device_account acc on acc.dev_acc_id=arc.dev_acc_id "+
					"left join gp_task_project pro on arc.project_info_id = pro.project_info_no "+
					"left join comm_coding_sort_detail det1 on det1.coding_code_id=info.accident_properties "+
					"left join comm_coding_sort_detail det2  on det2.coding_code_id = info.accident_grade left join gms_device_account_dui dui"+
					" on acc.dev_acc_id = dui.fk_dev_acc_id   left join gms_device_equipment_operator p  on p.device_account_id = dui.dev_acc_id and p.entity_id=arc.dev_archive_refid and arc.dev_archive_type='5' and  p.bsflag='0' "+
					"where  arc.dev_archive_type='6' and dui.project_info_id=arc.project_info_id  and  arc.dev_acc_id='"+shuaId+"'  ";//arc.dev_archive_type='6' and
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
				retObj= queryRet.datas;

				var size = $("#assign_body", "#tab_box_content5").children("tr").size();
				if (size > 0) {
					$("#assign_body", "#tab_box_content5").children("tr").remove();
				}
				var by_body1 = $("#assign_body", "#tab_box_content5")[0];
				if (retObj != undefined) {
					for (var i = 0; i < retObj.length; i++) {
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
			var sum_human_cost="0";
			var sum_material_cost="0";
			var postion=shuaId.indexOf("~");
			shuaId=shuaId.substring(0,postion);
			
			var querySql = "select nvl(sum(tmp.human_cost), 0) as human_cost,nvl(sum(tmp.material_cost), 0) as material_cost,tmp.modifi_date ";
		    querySql += " from (select nvl(info.human_cost, 0) as human_cost,nvl(info.material_cost, 0) as material_cost,to_char(info.modifi_date, 'yyyy') as modifi_date,dui.fk_dev_acc_id as dev_acc_id";
		    querySql += " from BGP_COMM_DEVICE_REPAIR_INFO info inner join gms_device_account_dui dui on info.DEVICE_ACCOUNT_ID = dui.dev_acc_id where info.repair_type <> '0110000037000000002' ";
		    querySql += " union all ";
		    querySql += " select nvl(info.human_cost, 0) as human_cost,nvl(info.material_cost, 0) as material_cost,to_char(info.modifi_date, 'yyyy') as modifi_date,acc.dev_acc_id ";
		    querySql += " from BGP_COMM_DEVICE_REPAIR_INFO info inner join gms_device_account acc on info.DEVICE_ACCOUNT_ID = acc.dev_acc_id where info.repair_type <> '0110000037000000002' ) tmp";
		    querySql += " where tmp.dev_acc_id ='"+shuaId+"' group by tmp.modifi_date order by tmp.modifi_date desc ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
				retObj= queryRet.datas;
			var size = $("#assign_body", "#tab_box_content6").children("tr").size();
				if (size > 0){
					$("#assign_body", "#tab_box_content6").children("tr").remove();
				}
				var by_body1 = $("#assign_body", "#tab_box_content6")[0];
				if (retObj != undefined){
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
						newTd1.innerText = retObj[i].modifi_date;
						newTr.insertCell().innerText=retObj[i].human_cost;
						newTr.insertCell().innerText=retObj[i].material_cost;
						newTr.insertCell().innerHTML = "<a onClick='openWsjlView(\""+shuaId+"\",\""+retObj[i].modifi_date+"\")'>查看</a>";
						sum_human_cost = Number(sum_human_cost) + Number(retObj[i].human_cost);
						sum_material_cost = Number(sum_material_cost) + Number(retObj[i].material_cost);
					}
				}
				document.getElementById("v_human_cost").value = sum_human_cost;
				document.getElementById("v_material_cost").value = sum_material_cost;
				
				$("#assign_body>tr:odd>td:odd",'#tab_box_content6').addClass("odd_odd");
				$("#assign_body>tr:odd>td:even",'#tab_box_content6').addClass("odd_even");
				$("#assign_body>tr:even>td:odd",'#tab_box_content6').addClass("even_odd");
				$("#assign_body>tr:even>td:even",'#tab_box_content6').addClass("even_even");
		}
		function openWsjlView(devid,proid){
			if(devid != ''){
				window.showModalDialog("<%=contextPath%>/rm/dm/deviceArchive/devArchiveView_wsjl.jsp?devaccid="+devid+"&projectinfoid="+proid,"","dialogWidth=1050px;dialogHeight=480px");
			}else{
				alert("未知错误!");
				return;
			}
		}
		/**
		* 操作记录****************************************************************************************************************************
		* @param {Object} shuaId
	*/
	function djjl(shuaId){
			var postion=shuaId.indexOf("~");
			shuaId=shuaId.substring(0,postion);		 
		var retObj;
		var querySql="select pro.project_name,dui.dev_name,dui.asset_coding,info.* from gms_device_equipment_operator info "+
				" inner join gms_device_account_dui dui on dui.dev_acc_id=info.device_account_id "+
				" left join gp_task_project pro on dui.project_info_id = pro.project_info_no "+
				" where info.bsflag!='1' and dui.fk_dev_acc_id='"+shuaId+"'"+
		        " union all select '' as project_name,acc.dev_name,acc.asset_coding,info.* from gms_device_equipment_operator info "+
		        " inner join gms_device_account acc on acc.dev_acc_id=info.device_account_id "+
		        " where info.bsflag!='1' and acc.dev_acc_id='"+shuaId+"'";
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
		* 参与项目****************************************************************************************************************************
		* @param {Object} shuaId
	*/
	function pro(shuaId){
			var postion=shuaId.indexOf("~");
			shuaId=shuaId.substring(0,postion);					 
		var retObj;
		var querySql="select pro.project_name, acc.dev_name, acc.asset_coding,dui.actual_in_time,dui.actual_out_time,round(dui.actual_out_time-dui.actual_in_time,0) as days ,substr(info.org_name,9) as org_abbreviation  from gms_device_account_dui dui ";
		   querySql+="left join gp_task_project pro on dui.project_info_id = pro.project_info_no left join gp_task_project_dynamic dy on dy.project_info_no = pro.project_info_no  left join gms_device_account acc on acc.dev_acc_id=dui.fk_dev_acc_id left join comm_org_information info on info.org_id = dy.org_id and info.bsflag='0' ";
		   querySql+="where acc.dev_acc_id = '"+shuaId+"' and pro.bsflag = '0' and dui.bsflag = '0' and dui.is_leaving = '1' ";
		   querySql+=" order by dui.actual_out_time desc";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj= queryRet.datas;
		var size = $("#assign_body", "#tab_box_content10").children("tr").size();
			if(size > 0){
				$("#assign_body", "#tab_box_content10").children("tr").remove();
			}
		var by_body1 = $("#assign_body", "#tab_box_content10")[0];
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
					var newTd0 = newTr.insertCell();
					newTd0.innerText = retObj[i].org_abbreviation;
					
					
				var newTd1 = newTr.insertCell();
					newTd1.innerText = retObj[i].project_name;
					var newTd2 = newTr.insertCell();
					newTd2.innerText = retObj[i].days ;
				var newTd4 = newTr.insertCell();
					newTd4.innerText = retObj[i].actual_in_time;
					newTr.insertCell().innerText=retObj[i].actual_out_time;
			}
		}
		$("#assign_body>tr:odd>td:odd",'#tab_box_content10').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#tab_box_content10').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#tab_box_content10').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#tab_box_content10').addClass("even_even");
	}
		 /**
		 * 其他使用费用****************************************************************************************************************************
		 * @param {Object} shuaId
	*/
	function sbfy(shuaId){
			 
		var retObj;
		var sum_human_cost="0";
		var sum_material_cost="0";	
		var postion=shuaId.indexOf("~");
		shuaId=shuaId.substring(0,postion);

		var querySql = "select to_char(posting_date,'YYYY') year,sum(amount) sum_cost "
			querySql =querySql+ "   from DMS_DEVICE_COST c "
			querySql =querySql+ " where c.REPAIR_ORDER is null and dev_coding =(select t.dev_coding from gms_device_account t  where t.dev_acc_id = '"+shuaId+"') ";
			querySql =querySql+ "  group by to_char(posting_date,'YYYY') ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
		retObj= queryRet.datas;

		var size = $("#assign_body", "#tab_box_content11").children("tr").size();
		if (size > 0) {
			$("#assign_body", "#tab_box_content11").children("tr").remove();
		}
		var by_body1 = $("#assign_body", "#tab_box_content11")[0];
		if (retObj != undefined) {
			for (var i = 0; i < retObj.length; i++) {
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
			newTd1.innerText = retObj[i].year;
			newTr.insertCell().innerText=retObj[i].sum_cost;
			newTr.insertCell().innerHTML = "<a onClick='openSbfyView(\""+shuaId+"\",\""+retObj[i].year+"\")'>查看</a>";
			sum_human_cost = Number(sum_human_cost) + Number(retObj[i].sum_cost);
		 
			}
		}
		document.getElementById("v_sum_cost").value = sum_human_cost;
	 
	
		$("#assign_body>tr:odd>td:odd",'#tab_box_content11').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#tab_box_content11').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#tab_box_content11').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#tab_box_content11').addClass("even_even");
	}   	
	function openSbfyView(devid,year){
		if(devid != ''){
			window.showModalDialog("<%=contextPath%>/rm/dm/deviceArchive/devArchiveView_qtfy.jsp?devaccid="+devid+"&projectinfoid="+year,"","dialogWidth=1050px;dialogHeight=480px");
		}else{
			alert("未知错误!");
			return;
		}
	}
	//格式化太长字段
	function formatLonger(value,row,index){
	if(value){
	if(value.length>12) {
	    return '<div id="orgName-'+value+'" style="width:auto;">'+value.substring(0,12)+'</div>';
	 }else{
	    return value;
	 }
	}
	}
//导出设备档案
	function expDataExcel(){
		var row = $('#queryRetTable').datagrid('getSelected');
	    if(!row){ 
		    alert("请先选中一条记录!");
	     	return;
	    }
		if(row.dev_type.indexOf('S062301')==-1){
		window.location.href='<%=contextPath%>/rm/dm/toGetDevExcel.srq?devid='+row.dev_acc_id;	
		}else{
		window.location.href='<%=contextPath%>/rm/dm/toGetDevExcelZY.srq?devid='+row.dev_acc_id;	
		}
	}
	//周期花费占比
		function getFieldCaptialFusionChart(shuaId){
		var type;
		var postion=shuaId.indexOf("~");
			shuaId=shuaId.substring(0,postion);	
		//可控震源
		if(getDevType(shuaId).indexOf("S0623")==0){
		type="kkzy";
		}else{//单台
		type="dt";
		}
			var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "chart1", "95%", "95%", "0", "0" );    
			chart1.setXMLUrl("<%=contextPath%>/rm/dm/getDeviceleftRate.srq?dev_acc_id="+shuaId+"&type="+type);
			chart1.render("chartContainer1");
		}
		//周期花费占比
		function getData(shuaId){
		var postion=shuaId.indexOf("~");
			shuaId=shuaId.substring(0,postion);	
			//可控震源
		if(getDevType(shuaId).indexOf("S0623")==0){
		type="kkzy";
		}else{//单台
		type="dt";
		}
			$.ajax({
		        type:"post",
		        dataType:"xml",
		        url:"<%=contextPath%>/rm/dm/getDeviceleftRate.srq?dev_acc_id="+shuaId+"&type="+type,//xml文件路径
		        error:function(){ alert("加载文件失败！"); },
		        success: function(data){	
		            var set = $(data).find("set");     
		            var j=0;
		            var t = document.getElementById('lineTable');
		            $("#lineTable").html("");
		            for(var i=0;i<set.length/2;i++){
		            	var value1 = set.eq(j).attr("displayValue");
		            	var value2 = set.eq(j+1).attr("displayValue");
	                    var arr1 = value1.split(",");
	                    var arr2 = null;
						if(value2 != null && value2 !="undefinded"){
						   arr2 = value2.split(",");		               
		            	}
	                    var tr = t.insertRow(i);
						var td = tr.insertCell(0);
						td.innerHTML = arr1[0];
					    td = tr.insertCell(1);
						td.innerHTML = set.eq(j).attr("toolText");
						td = tr.insertCell(2);
						if(arr2 != null){
							td.innerHTML = arr2[0];
						}
						td = tr.insertCell(3);
						td.innerHTML = set.eq(j+1).attr("toolText");
						j=j+2; 
		            }
		        }
		    });
		}
		
	 
		//获取设备编码
	function getDevType(devAccId){
		var tquerySql = " select acc.dev_type from gms_device_account acc where acc.dev_acc_id='"+devAccId+"'";
		var tqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+tquerySql);
		var	tretObj= tqueryRet.datas;
		return tretObj[0].dev_type;
	}
 
function exportForEasyUI(datagrid_name,filename,curPage, pageSize,contextPath){
	if(curPage==undefined) curPage=1;
	if(pageSize==undefined) pageSize=10;
	var submitStr = "page="+curPage+"&rows="+pageSize;
	var url = $("#"+datagrid_name).datagrid("options").url;
		url = url.substring(url.indexOf('?')+1);  
	var params = $("#"+datagrid_name).datagrid("options").queryParams;    // ����
	for(var p in params){ 
    	submitStr=submitStr+"&"+p+"="+params[p];
    }
    var columns = $("#"+datagrid_name).datagrid("options").columns;    // �õ�columns����    
    var frozenColumns=$("#"+datagrid_name).datagrid("options").frozenColumns; //获得冻结列
	var columnExp="";
	var columnTitle="";
	if(frozenColumns){
		$(frozenColumns).each(function (index) { 
			for (var i = 0; i < frozenColumns[index].length; ++i) { 
				var dc=frozenColumns[index][i].dc;//�Ƿ񵼳�
				if("undefined" == typeof dc||dc!=false){
			 	columnExp += frozenColumns[index][i].field + ",";
				columnTitle += frozenColumns[index][i].title+ ",";
				}
			}
		});
	}
	$(columns).each(function (index) { 
		for (var i = 0; i < columns[index].length; ++i) { 
		 
			var dc=columns[index][i].dc;//�Ƿ񵼳�
			if("undefined" == typeof dc||dc!=false){
		 	columnExp += columns[index][i].field + ",";
			columnTitle += columns[index][i].title+ ",";
			}
		}
	});
 
	var querySql='';	
	var path = '';
		submitStr = encodeURI(submitStr);
		submitStr = encodeURI(submitStr);
		//if(cruConfig.submitStr!='')submitStr += "&"+cruConfig.submitStr;
		submitStr+="&"+url+"&JCDP_COLUMN_EXP="+columnExp+"&JCDP_COLUMN_TITLE="+columnTitle+"&JCDP_FILE_NAME="+filename;
		path = contextPath+"/common/excel/listToExcelNew.srq";
	var retObj = syncRequest("post", path, submitStr);
		filename = encodeURI(filename);
	    filename = encodeURI(filename);

	window.location=contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname="+filename+".xls";
}
</script>
</html>