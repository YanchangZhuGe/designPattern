<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String taskId = request.getParameter("taskId");
	String projectInfoNo = request.getParameter("projectInfoNo");
    String code = request.getParameter("code");
	String userOrgId = user.getSubOrgIDofAffordOrg();
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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open2.js"></script>
  <title>项目页面</title> 
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
			    <!--     <auth:ListButton functionId="" css="yd" event="onclick='toCopy()'" title="转入"></auth:ListButton>-->
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
			  <table style="width:98.5%" border="0" cellspacing="0" class="tab_info" id="queryRetTable">		
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
					<td class="bt_info_odd" exp="{use_name_desc}">所属基层单位</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">设备使用概况</a></li>
			    <li   style="margin-left: 5px" id="tag3_1" ><a href="#" onclick="getTab3(1);loaddata('',1)">设备运转记录</a></li>
			    <li  style="margin-left: 5px" id="tag3_2" ><a href="#" onclick="getTab3(2);loaddata('',2)">强制保养记录</a></li>
			    <li  style="margin-left: 5px" id="tag3_3" ><a href="#" onclick="getTab3(3);loaddata('',3)">单机材料消耗</a></li>
			    <li  style="margin-left: 5px" id="tag3_4" ><a href="#" onclick="getTab3(4);loaddata('',4)">设备油品消耗</a></li>
			    <li  style="margin-left: 5px"  id="tag3_5" ><a href="#"  onclick="getTab3(5);loaddata('',5)">设备事故记录</a></li>
			    <li  style="margin-left: 5px" id="tag3_6" ><a href="#" onclick="getTab3(6);loaddata('',6)">项目修理记录</a></li>
			    <li   style="margin-left: 5px"id="tag3_7" ><a href="#" onclick="getTab3(7);loaddata('',7)">定人定机记录</a></li>
			    <li  style="margin-left: 5px" id="tag3_10" ><a href="#" onclick="getTab3(10);loaddata('',10)">参与项目</a></li>
			    <li  style="margin-left: 5px"id="tag3_8"><a href="#" onclick="getTab3(8)">附件</a></li>
			    <li  style="margin-left: 5px" id="tag3_9"><a href="#" onclick="getTab3(9)">备注</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table id="devMap" width="100%" border="1px" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
				    	    <td style="border-style:solid;"  class="inquire_item8"  rowspan="5">基本信息</td>
						    <td  style="border-style:solid;"  class="inquire_item8">设备名称</td>
						    <td style="border-style:solid;"  class="inquire_form6"><input id="dev_acc_name" name="dev_acc_name"  class="input_width" type="text" /></td>
						    <td  style="border-style:solid;"  class="inquire_item8">规格型号</td>
						    <td style="border-style:solid;"  class="inquire_form6"><input id="dev_acc_model" name="dev_acc_model" class="input_width" type="text" /></td>
						    <td  style="border-style:solid;"  class="inquire_item8">设备编码</td>
						    <td style="border-style:solid;"  class="inquire_form6"><input id="dev_acc_type" name="dev_acc_type" class="input_width" type="text" /></td>
						 </tr>
						 <tr  >
						    <td  style="border-style:solid;" class="inquire_item8">ERP设备编号</td>
						    <td  style="border-style:solid;" class="inquire_form6"><input id="dev_acc_coding" name="dev_acc_coding" class="input_width" type="text" /></td> 
						    <td  style="border-style:solid;" class="inquire_item8">自编号</td>
						    <td  style="border-style:solid;" class="inquire_form6"><input id="dev_acc_self" name="dev_acc_self" class="input_width" type="text" /></td>
						    <td  style="border-style:solid;"  class="inquire_item8">牌照号</td>
						    <td style="border-style:solid;"  class="inquire_form6"><input id="dev_acc_license" name="dev_acc_license" class="input_width" type="text" /></td>
						  </tr>
						  <tr>
						    <td  style="border-style:solid;"  class="inquire_item8">实物标识号</td>
						    <td  style="border-style:solid;"  class="inquire_form6"><input id="dev_acc_sign" name="" class="input_width" type="text" /></td>
						    <td style="border-style:solid;"class="inquire_item8">发动机号</td>
						    <td  style="border-style:solid;"class="inquire_form6"><input id="dev_acc_engine_num" name="" class="input_width" type="text" /></td>
						    <td  style="border-style:solid;"class="inquire_item8">底盘号</td>
						    <td  style="border-style:solid;" class="inquire_form6"><input id="dev_acc_chassis_num" name="" class="input_width" type="text" /></td>
						  </tr>
						  <tr>
						    
						   <td  style="border-style:solid;"class="inquire_item8">投产日期</td>
						    <td  style="border-style:solid;"class="inquire_form6"><input id="dev_acc_producting_date" name="" class="input_width" type="text" /></td>
						    <td  style="border-style:solid;"class="inquire_item8">原值</td>
						    <td  style="border-style:solid;"class="inquire_form6"><input id="dev_acc_asset_value" name=""  class="input_width" type="text" /></td>
						    <td  style="border-style:solid;"class="inquire_item8">净值</td>
						    <td  style="border-style:solid;"class="inquire_form6"><input id="dev_acc_net_value" name="" class="input_width" type="text" /></td>
	
						  </tr>
						   <tr>
						   <td  style="border-style:solid;"class="inquire_item8">资产状况</td>
						    <td style="border-style:solid;" class="inquire_form6"><input id="dev_acc_asset_stat" name="" class="input_width" type="text" /></td>
						    <td style="border-style:solid;" class="inquire_item8">技术状况</td>
						    <td  style="border-style:solid;"class="inquire_form6"><input id="dev_acc_tech_stat" name="" class="input_width" type="text" /></td>
						    <td  style="border-style:solid;"class="inquire_item8">使用状况</td>
						    <td style="border-style:solid;" class="inquire_form6"><input id="dev_acc_using_stat" name="" class="input_width" type="text" /></td>

						  </tr>
						  <tr>
						  <td style="border-style:solid;"class="inquire_item8"  rowspan="3">使用</td>
						   <td style="border-style:solid;"class="inquire_item8">所在单位/部室</td>
						    <td style="border-style:solid;" class="inquire_form6"><input id="usage_org_name_desc" name="usage_org_name_desc" class="input_width" type="text" /></td>
						    <td style="border-style:solid;" style="border-style:solid;"class="inquire_item8">当前操作人</td>
						    <td  style="border-style:solid;"class="inquire_form6"><input id="oper_name" name="oper_name" class="input_width" type="text" /></td>
						    <td  style="border-style:solid;"class="inquire_item8">累计更换人次</td>
						    <td  style="border-style:solid;"class="inquire_form6"><input id="oper_num" name="oper_num" class="input_width" type="text" /></td>

						  </tr>
						  <tr>
						   <td style="border-style:solid;" class="inquire_item8">累计行驶公里数(KM)</td>
						    <td style="border-style:solid;" class="inquire_form6"><input id="mileage" name="mileage" class="input_width" type="text" /></td>
						    <td style="border-style:solid;" class="inquire_item8">累计工作小时(h)</td>
						    <td style="border-style:solid;" class="inquire_form6"><input id="work_hour" name="work_hour" class="input_width" type="text" /></td>
						    <td  style="border-style:solid;"class="inquire_item8">累计钻进进尺(m)</td>
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

	function searchDevData(){
		var v_dev_name = document.getElementById("s_dev_name").value;
		var v_dev_model = document.getElementById("s_dev_model").value;
		//var v_dev_asset_stat = document.getElementById("s_dev_account_stat").value;
		var owning_org_id = document.getElementById("owning_org_id").value;
		var obj = new Array();
		obj.push({"label":"dev_name","value":v_dev_name});
		//obj.push({"label":"account_stat","value":v_dev_asset_stat});
		obj.push({"label":"dev_model","value":v_dev_model});
		obj.push({"label":"t.owning_sub_id","value":owning_org_id});
		refreshData(obj);
	}
	//点击树节点查询
	var code = '<%=code%>';
	code = code.replace("S","");//点根节点时去除S,只有根节点带S
	
	function refreshData(arrObj,content){
		var userid = '<%=userOrgId%>';
		var orgLength = userid.length;
		var str = "";
		if(orgLength==4){
			str += "select aa.*,(case when aa.owning_org_name_desc=aa.use_name then '' else aa.use_name end)use_name_desc from (select (select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc, "+
			" (select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc,t.*,substr(t.foreign_key,8) as erp_id,"+
			" (select pro.project_name from gp_task_project pro where pro.project_info_no=t.project_info_no) as project_name_desc,"+
			" (case when t.owning_sub_id like 'C105001005%' then '塔里木物探处' else (case when t.owning_sub_id like 'C105001002%' then '新疆物探处'else(case when t.owning_sub_id like 'C105001003%' then '吐哈物探处'else(case when t.owning_sub_id like 'C105001004%' then '青海物探处'else(case when t.owning_sub_id like 'C105005004%' then '长庆物探处'else(case when t.owning_sub_id like 'C105005000%' then '华北物探处'else(case when t.owning_sub_id like 'C105005001%' then '新兴物探开发处'else(case when t.owning_sub_id like 'C105007%' then '大港物探处'else(case when t.owning_sub_id like 'C105063%' then '辽河物探处'else(case when t.owning_sub_id like 'C105006%' then '装备服务处'else (case when t.owning_sub_id like 'C105002%' then '国际勘探事业部'else (case when t.owning_sub_id like 'C105003%' then '研究院'else (case when t.owning_sub_id like 'C105008%' then '综合物化处'else (case when t.owning_sub_id like 'C105015%' then '井中地震中心'  else (case when t.owning_sub_id like 'C105017%' then '矿区服务事业部' else '' end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) as owning_org_name_desc ,i.org_abbreviation usage_org_name_desc ,nvl(pi.org_abbreviation,org.org_abbreviation) use_name,"+
			" (select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc "+
			" from gms_device_account t inner join (comm_org_subjection s inner join comm_org_information org on s.org_id=org.org_id) on t.owning_sub_id=s.org_subjection_id "+
			" left join comm_org_information i on t.usage_org_id = i.org_id and i.bsflag ='0'"+
			" left join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag ='0'"+
			" left join gp_task_project_dynamic d on p.project_info_no = d.project_info_no and d.bsflag ='0' "+
			" left join comm_org_information pi on d.org_id = pi.org_id and pi.bsflag ='0'";
		}else{
			str += "select aa.*,aa.use_name use_name_desc from (select (select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc, "+
			" (select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc,t.*,substr(t.foreign_key,8) as erp_id,"+
			" (select pro.project_name from gp_task_project pro where pro.project_info_no=t.project_info_no) as project_name_desc,"+
			" org.org_abbreviation as owning_org_name_desc ,i.org_abbreviation usage_org_name_desc ,pi.org_abbreviation use_name,"+
			" (select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc "+
			" from gms_device_account t inner join (comm_org_subjection s inner join comm_org_information org on s.org_id=org.org_id) on t.owning_sub_id=s.org_subjection_id "+
			" left join comm_org_information i on t.usage_org_id = i.org_id and i.bsflag ='0'"+
			" left join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag ='0'"+
			" left join gp_task_project_dynamic d on p.project_info_no = d.project_info_no and d.bsflag ='0' "+
			" left join comm_org_information pi on d.org_id = pi.org_id and pi.bsflag ='0'";
		}
		if(code =='08'){
			str += " where t.bsflag='0' and (t.dev_type like 'S0801%' or t.dev_type like 'S0802%' or t.dev_type like 'S0803020015%' or t.dev_type like 'S080304%' or t.dev_type like 'S0804%' or t.dev_type like 'S080503%' or t.dev_type like 'S08060701%') and (owning_sub_id like '"+userid+"%' OR USAGE_SUB_ID like '"+userid+"%')";
		}else{
			str += " where t.bsflag='0' and dev_type like"+"'S"+code+"%' and (owning_sub_id like '"+userid+"%' OR USAGE_SUB_ID like '"+userid+"%')";
		}
		
		for(var key in arrObj) { 
			if(arrObj[key].value!=undefined && arrObj[key].value!=''){
				if(arrObj[key].label!='project_name'){
					str += "and "+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
				}else{
					str += "and t.project_info_no in (select project_info_no from gp_task_project where project_name like '%"+arrObj[key].value+"%' and bsflag='0' ) ";
				}
			}
		}
		debugger;
		if(content!=null&&content!=""){
			str += content;
		}
		str += ")aa ";
		debugger;
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
		createNewTitleTable();
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
		
		var columnsObj ;
		$("input[type='checkbox']", "#queryRetTable").each(function(){
			if(this.checked){
				columnsObj = this.parentNode.parentNode.cells;
			}
		});
		//if(columnsObj(22).innerText=="在账"){
		//	alert("此设备为在账设备，不允许修改!");
		//	return;
		//}
		selId = ids.split('~',-1);
		if(selId[1] != '1' && selId[2] != '0110000007000000001' && selId[3] != '1'){
			editUrl = "<%=contextPath%>/rm/dm/deviceAccount/toEditErp.jsp?id={id}";  
			editUrl = editUrl.replace('{id}',selId[0]); 
			//editUrl += '&pagerAction=edit2Edit';
		  	popWindow(editUrl); 
		    return;
		} 
		if(selId[2] == '0110000007000000001' || selId[3] == '1'){
		    alert("在用设备不能修改!");
		    return;
		}
		editUrl = "<%=contextPath%>/rm/dm/deviceAccount/toEdit.jsp?id={id}";  
		editUrl = editUrl.replace('{id}',selId[0]); 
 
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
	function refreshOrgData (fkValue){
		var userid = fkValue;
		var orgLength = userid.length;
		var str = "";
		if(orgLength==4){
			str += "select aa.*,(case when aa.owning_org_name_desc=aa.use_name then '' else aa.use_name end)use_name_desc from (select (select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc, "+
			" (select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc,t.*,substr(t.foreign_key,8) as erp_id,"+
			" (select pro.project_name from gp_task_project pro where pro.project_info_no=t.project_info_no) as project_name_desc,"+
			" (case when t.owning_sub_id like 'C105001005%' then '塔里木物探处' else (case when t.owning_sub_id like 'C105001002%' then '新疆物探处'else(case when t.owning_sub_id like 'C105001003%' then '吐哈物探处'else(case when t.owning_sub_id like 'C105001004%' then '青海物探处'else(case when t.owning_sub_id like 'C105005004%' then '长庆物探处'else(case when t.owning_sub_id like 'C105005000%' then '华北物探处'else(case when t.owning_sub_id like 'C105005001%' then '新兴物探开发处'else(case when t.owning_sub_id like 'C105007%' then '大港物探处'else(case when t.owning_sub_id like 'C105063%' then '辽河物探处'else(case when t.owning_sub_id like 'C105006%' then '装备服务处'else (case when t.owning_sub_id like 'C105002%' then '国际勘探事业部'else (case when t.owning_sub_id like 'C105003%' then '研究院'else (case when t.owning_sub_id like 'C105008%' then '综合物化处'else (case when t.owning_sub_id like 'C105015%' then '井中地震中心'  else (case when t.owning_sub_id like 'C105017%' then '矿区服务事业部' else '' end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) as owning_org_name_desc ,i.org_abbreviation usage_org_name_desc ,nvl(pi.org_abbreviation,org.org_abbreviation) use_name,"+
			" (select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc "+
			" from gms_device_account t inner join (comm_org_subjection s inner join comm_org_information org on s.org_id=org.org_id) on t.owning_sub_id=s.org_subjection_id "+
			" left join comm_org_information i on t.usage_org_id = i.org_id and i.bsflag ='0'"+
			" left join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag ='0'"+
			" left join gp_task_project_dynamic d on p.project_info_no = d.project_info_no and d.bsflag ='0' "+
			" left join comm_org_information pi on d.org_id = pi.org_id and pi.bsflag ='0'";
		}
		else{
			str += "select aa.*,aa.use_name use_name_desc from (select (select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc, "+
			" (select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc,t.*,substr(t.foreign_key,8) as erp_id,"+
			" (select pro.project_name from gp_task_project pro where pro.project_info_no=t.project_info_no) as project_name_desc,"+
			" org.org_abbreviation as owning_org_name_desc ,i.org_abbreviation usage_org_name_desc ,pi.org_abbreviation use_name,"+
			" (select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc "+
			" from gms_device_account t inner join (comm_org_subjection s inner join comm_org_information org on s.org_id=org.org_id) on t.owning_sub_id=s.org_subjection_id "+
			" left join comm_org_information i on t.usage_org_id = i.org_id and i.bsflag ='0'"+
			" left join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag ='0'"+
			" left join gp_task_project_dynamic d on p.project_info_no = d.project_info_no and d.bsflag ='0' "+
			" left join comm_org_information pi on d.org_id = pi.org_id and pi.bsflag ='0'";
			}
			//str += " where t.bsflag='0' and (t.dev_type like 'S0801%' or t.dev_type like 'S0802%' or t.dev_type like 'S0803020015%' or t.dev_type like 'S080304%' or t.dev_type like 'S0804%' or t.dev_type like 'S080503%' or t.dev_type like 'S08060701%') and (owning_sub_id like '"+userid+"%' OR USAGE_SUB_ID like '"+userid+"%')";
			str += " where t.bsflag='0' and (owning_sub_id like '"+userid+"%' OR USAGE_SUB_ID like '"+userid+"%')";
		str += ")aa ";
		debugger;
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
		createNewTitleTable();
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
		if(unProCount[0].unpro_count>0)
		{
			alert("改设备已在非生产单位现场管理中,请勿重复选择！");
			return;
		}
		if(confirm('确定要将设备导入到非生产单位现场管理吗?')){  
			var retObj = jcdpCallService("DevInsSrv", "copyToUnPro", "deviceId="+info[0]);
			var result=retObj.info;
			if(result!=undefined)
			{
				if(result=='转入成功')
				{
					var devId=retObj.devId;
					if(confirm('是否对该设备设置保养计划?')){  
					popWindow("<%=contextPath%>/rm/dm/device-xd/dev_byjh.jsp?ids="+devId); 
					return;
				}
				
				queryData(cruConfig.currentPage);
			}
			else
			{
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
		else if(index==10) 
			pro(ids);
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
		
		
         var querySql = " select  nvl(sum(aa.mileage_total), 0) as mileage_total,nvl(sum(aa.drilling_footage_total), 0) as drilling_footage_total, nvl(sum(aa.work_hour_total), 0) as work_hour_total,aa.modify_date from ( select pro.project_name,acc.dev_name,acc.asset_coding,info.dev_acc_id,nvl(sum(info.mileage),0) as mileage_total,nvl(sum(info.drilling_footage),0) as drilling_footage_total,";
         querySql +="nvl(sum(info.work_hour),0) as work_hour_total,to_char(max(info.modify_date),'yyyy') as modify_date from gms_device_operation_info info ";
         querySql +="left join gms_device_archive_detail arc on arc.dev_archive_refid = info.operation_info_id left join gms_device_account acc on acc.dev_acc_id = arc.dev_acc_id ";
         querySql +="left join gp_task_project pro on arc.project_info_id = pro.project_info_no where arc.dev_archive_type = '1' ";
         querySql +="and arc.dev_acc_id ='"+shuaId+"' group by pro.project_name, acc.dev_name, acc.asset_coding,info.dev_acc_id ) aa  group by aa.modify_date    order by aa.modify_date desc ";
        // var querySql = " select  nvl(sum(aa.mileage_total), 0) as mileage_total,nvl(sum(aa.drilling_footage_total), 0) as drilling_footage_total, nvl(sum(aa.work_hour_total), 0) as work_hour_total,aa.modify_date from ( select  info.dev_acc_id,nvl(info.mileage,0) as mileage_total,nvl(info.drilling_footage,0) as drilling_footage_total,";
        // querySql +="nvl(info.work_hour,0) as work_hour_total,to_char(info.modify_date,'yyyy') as modify_date from gms_device_operation_info info ";
         //querySql +="where  info.dev_acc_id  in (select dev_acc_id from gms_device_account_dui dui where dui.fk_dev_acc_id ='"+shuaId+"' )) aa  group by aa.modify_date    order by aa.modify_date desc ";
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
			
			//var querySql="select pro.project_name,acc.dev_name,acc.asset_coding,info.repair_start_date,info.repair_detail,info.human_cost,info.material_cost from BGP_COMM_DEVICE_REPAIR_INFO info "+
			//	"left join GMS_DEVICE_ARCHIVE_DETAIL arc on arc.dev_archive_refid=info.repair_info "+
			//	"left join gms_device_account acc on acc.dev_acc_id=arc.dev_acc_id "+
			//	"left join gp_task_project pro on arc.project_info_id = pro.project_info_no "+
			//	"where arc.dev_archive_type='2' and arc.dev_acc_id='"+shuaId+"' order by seqinfo desc ";
			var querySql = "select aa.modifi_date, nvl(sum(aa.human_cost), 0) human_cost, nvl(sum(aa.material_cost), 0) material_cost from  (select  to_char(info.modifi_date,'yyyy')  as modifi_date,arc.dev_acc_id,nvl(sum(info.human_cost), 0) human_cost, nvl(sum(info.material_cost), 0) material_cost";
			    querySql += " from BGP_COMM_DEVICE_REPAIR_INFO info ";
			    querySql += "  left join GMS_DEVICE_ARCHIVE_DETAIL arc on arc.dev_archive_refid =  info.repair_info left join gms_device_account acc on acc.dev_acc_id = arc.dev_acc_id ";
			    querySql += "left join gp_task_project pro on arc.project_info_id = pro.project_info_no where arc.dev_archive_type = '2' ";
			    querySql += "and arc.dev_acc_id ='"+shuaId+"' group by arc.dev_acc_id,info.modifi_date)aa  group by aa.modifi_date order by aa.modifi_date desc ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj= queryRet.datas;
			//if (shuaId != null) {
				//retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfoBY", "deviceId=" + shuaId);
			//}
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
				
				//var querySql="select to_char(a.NEXT_MAINTAIN_DATE,'yyyy') as Year,to_char(a.NEXT_MAINTAIN_DATE,'mm') as month "+
				//	"from BGP_COMM_DEVICE_MAINTAIN a "+
				//	"left join BGP_COMM_DEVICE_REPAIR_INFO info on info.device_account_id=a.device_account_id "+
				//	"where a.device_account_id='"+shuaId+"' "+
				//	"group by to_char(a.NEXT_MAINTAIN_DATE,'yyyy'),to_char(a.NEXT_MAINTAIN_DATE,'mm')  "+
				//	"order by to_char(a.NEXT_MAINTAIN_DATE,'yyyy'),to_char(a.NEXT_MAINTAIN_DATE,'mm') desc";
				//var querySql="select pro.project_name,acc.dev_name,acc.asset_coding,info.* from BGP_COMM_DEVICE_REPAIR_DETAIL info "+
				//	"left join GMS_DEVICE_ARCHIVE_DETAIL arc on arc.dev_archive_refid=info.repair_detail_id "+
				//	"left join gms_device_account acc on acc.dev_acc_id=arc.dev_acc_id "+
				//	"left join gp_task_project pro on arc.project_info_id = pro.project_info_no "+
				//	"where arc.dev_archive_type='3' and arc.dev_acc_id='"+shuaId+"' order by pro.project_name,seqinfo desc ";
				var querySql = "select aa.modifydate, nvl(sum(aa.total_charge), 0) total_charge,nvl(sum(aa.material_amout), 0) material_amout, nvl(sum(aa.out_num), 0) out_num  from( select arc.dev_acc_id,  nvl(sum(info.total_charge), 0) total_charge, ";
				    querySql += "nvl(sum(info.material_amout), 0) material_amout,nvl(sum(info.out_num), 0) out_num,to_char(info.modifi_date,'yyyy') as modifydate   from BGP_COMM_DEVICE_REPAIR_DETAIL info ";
				    querySql += "left join GMS_DEVICE_ARCHIVE_DETAIL arc on arc.dev_archive_refid = info.repair_detail_id left join gms_device_account acc on acc.dev_acc_id = arc.dev_acc_id ";
				    querySql += "left join gp_task_project pro on arc.project_info_id = pro.project_info_no where arc.dev_archive_type = '3' and arc.dev_acc_id = '"+shuaId+"' ";
				    querySql += "group by arc.dev_acc_id, info.modifi_date )aa group by aa.modifydate order by aa.modifydate  desc ";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
					retObj= queryRet.datas;
					//if (shuaId != null){
						//retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfoBY", "deviceId=" + shuaId);
					//}
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
							//newTr.insertCell().innerText=retObj[i].teammat_out_id;
							//newTr.insertCell().innerText=retObj[i].material_name;
							//newTr.insertCell().innerText=retObj[i].material_coding;
							//newTr.insertCell().innerText=retObj[i].unit_price;
												
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
				
				//var querySql="select to_char(a.NEXT_MAINTAIN_DATE,'yyyy') as Year,to_char(a.NEXT_MAINTAIN_DATE,'mm') as month "+
				//	"from BGP_COMM_DEVICE_MAINTAIN a "+
				//	"left join BGP_COMM_DEVICE_REPAIR_INFO info on info.device_account_id=a.device_account_id "+
				//	"where a.device_account_id='"+shuaId+"' "+
				//	"group by to_char(a.NEXT_MAINTAIN_DATE,'yyyy'),to_char(a.NEXT_MAINTAIN_DATE,'mm')  "+
				//	"order by to_char(a.NEXT_MAINTAIN_DATE,'yyyy'),to_char(a.NEXT_MAINTAIN_DATE,'mm') desc";
				//var querySql="select pro.project_name,acc.dev_name,acc.asset_coding,info.*,oname.coding_name as oil_name1,ounit.coding_name as oil_unit1 from BGP_COMM_DEVICE_OIL_INFO info "+
				//		"left join GMS_DEVICE_ARCHIVE_DETAIL arc on arc.dev_archive_refid=info.oil_info_id "+
				//		"left join gms_device_account acc on acc.dev_acc_id=arc.dev_acc_id "+
				//		"left join gp_task_project pro on arc.project_info_id = pro.project_info_no "+
				//		"left join comm_coding_sort_detail oname on oname.coding_code_id=info.oil_name "+
				//		"left join comm_coding_sort_detail ounit on ounit.coding_code_id=info.oil_unit "+
				//		"where arc.dev_archive_type='4' and arc.dev_acc_id='"+shuaId+"' order by seqinfo desc ";
				var querySql = "select aa.modifi_date, nvl(sum(aa.oil_num), 0) oil_num, nvl(sum(aa.total_money), 0) total_money from ( select  d.dev_acc_id,nvl(sum(d.oil_num), 0) oil_num,nvl(sum(d.total_money), 0) total_money,";
					querySql += "to_char( t.modifi_date,'yyyy') as modifi_date  from gms_mat_teammat_out t ";
					querySql += "left join GMS_MAT_TEAMMAT_OUT_DETAIL d on t.teammat_out_id = d.teammat_out_id ";
					querySql += "left join gms_device_account_dui acc on acc.dev_acc_id = d.dev_acc_id left join gp_task_project pro ";
					querySql += "on t.project_info_no = pro.project_info_no where t.out_type = '3' ";
					querySql += "and acc.fk_dev_acc_id ='"+shuaId+"'  group by  d.dev_acc_id,t.modifi_date) aa group by aa.modifi_date  order by aa.modifi_date desc ";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
					retObj= queryRet.datas;
					//if (shuaId != null) {
						//retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfoBY", "deviceId=" + shuaId);
					//}
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
				
														
						//newTr.insertCell().innerText=retObj[i].fill_date;
						//newTr.insertCell().innerText=retObj[i].oil_name1;
						//newTr.insertCell().innerText=retObj[i].oil_unit1;
						//newTr.insertCell().innerText=retObj[i].oil_quantity;
						//newTr.insertCell().innerText=retObj[i].quantity_total;
						//newTr.insertCell().innerText=retObj[i].oil_unit_price;
						//newTr.insertCell().innerText=retObj[i].oil_total;
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
				 
			var retObj;
			//var querySql="select to_char(a.NEXT_MAINTAIN_DATE,'yyyy') as Year,to_char(a.NEXT_MAINTAIN_DATE,'mm') as month "+
			//	"from BGP_COMM_DEVICE_MAINTAIN a "+
			//	"left join BGP_COMM_DEVICE_REPAIR_INFO info on info.device_account_id=a.device_account_id "+
			//	"where a.device_account_id='"+shuaId+"' "+
			//	"group by to_char(a.NEXT_MAINTAIN_DATE,'yyyy'),to_char(a.NEXT_MAINTAIN_DATE,'mm')  "+
			//	"order by to_char(a.NEXT_MAINTAIN_DATE,'yyyy'),to_char(a.NEXT_MAINTAIN_DATE,'mm') desc";
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
			//if (shuaId != null) {
					//retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfoBY", "deviceId=" + shuaId);
			//}
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
			
			//var querySql="select to_char(a.NEXT_MAINTAIN_DATE,'yyyy') as Year,to_char(a.NEXT_MAINTAIN_DATE,'mm') as month "+
			//	"from BGP_COMM_DEVICE_MAINTAIN a "+
			//	"left join BGP_COMM_DEVICE_REPAIR_INFO info on info.device_account_id=a.device_account_id "+
			//	"where a.device_account_id='"+shuaId+"' "+
			//	"group by to_char(a.NEXT_MAINTAIN_DATE,'yyyy'),to_char(a.NEXT_MAINTAIN_DATE,'mm')  "+
			//	"order by to_char(a.NEXT_MAINTAIN_DATE,'yyyy'),to_char(a.NEXT_MAINTAIN_DATE,'mm') desc";
			//var querySql="select pro.project_name,acc.dev_name,acc.asset_coding,info.*,det1.coding_name as repairtype,det2.coding_name as repairitem from BGP_COMM_DEVICE_REPAIR_INFO info "+
			//		"left join GMS_DEVICE_ARCHIVE_DETAIL arc on arc.dev_archive_refid=info.repair_info "+
			//		"left join gms_device_account acc on acc.dev_acc_id=arc.dev_acc_id "+
			//		"left join gp_task_project pro on arc.project_info_id = pro.project_info_no "+
			//		"left join comm_coding_sort_detail det1 on det1.coding_code_id=info.repair_type "+
			//		"left join comm_coding_sort_detail det2 on det2.coding_code_id=info.repair_item "+
			//		"where arc.dev_archive_type='7' and arc.dev_acc_id='"+shuaId+"' order by seqinfo desc ";
			var querySql = "select aa.modifi_date, nvl(sum(aa.human_cost), 0) human_cost, nvl(sum(aa.material_cost), 0) material_cost from( select arc.dev_acc_id, to_char(info.modifi_date,'yyyy') as  modifi_date,nvl(sum(info.human_cost), 0) human_cost,nvl(sum(info.material_cost), 0) material_cost ";
			    querySql += " from BGP_COMM_DEVICE_REPAIR_INFO info left join GMS_DEVICE_ARCHIVE_DETAIL arc ";
			    querySql += "on arc.dev_archive_refid = info.repair_info left join gms_device_account acc on acc.dev_acc_id = arc.dev_acc_id ";
			    querySql += "left join gp_task_project pro on arc.project_info_id = pro.project_info_no where arc.dev_archive_type = '7' ";
			    querySql += "and arc.dev_acc_id ='"+shuaId+"'  group by  arc.dev_acc_id,info.modifi_date) aa group by aa.modifi_date  order by aa.modifi_date desc ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
				retObj= queryRet.datas;
			//if (shuaId != null) {
				//retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfoBY", "deviceId=" + shuaId);
			//}
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
					
									
						//newTr.insertCell().innerText=retObj[i].repairtype;
						//newTr.insertCell().innerText=retObj[i].repairitem;
						//newTr.insertCell().innerText=retObj[i].repair_detail;
						//newTr.insertCell().innerText=retObj[i].repair_start_date;
						//newTr.insertCell().innerText=retObj[i].repair_end_date;
						//newTr.insertCell().innerText=retObj[i].human_cost;
						//newTr.insertCell().innerText=retObj[i].material_cost;
						//newTr.insertCell().innerText=retObj[i].repairer;
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
			 
		var retObj;
		var querySql="select pro.project_name,acc.dev_name,acc.asset_coding,info.* from gms_device_equipment_operator info "+
				"left join GMS_DEVICE_ARCHIVE_DETAIL arc on arc.dev_archive_refid=info.entity_id "+
				"left join gms_device_account acc on acc.dev_acc_id=arc.dev_acc_id "+
				"left join gp_task_project pro on arc.project_info_id = pro.project_info_no "+
				"where arc.dev_archive_type='5'  and info.bsflag!='1' and arc.dev_acc_id='"+shuaId+"' order by seqinfo desc ";
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
				 
		var retObj;
		var querySql="select pro.project_name, acc.dev_name, acc.asset_coding,dui.actual_in_time,dui.actual_out_time,(dui.actual_out_time-dui.actual_in_time) as days ,(select  org_abbreviation  from comm_org_information org where  dui.owning_org_id=org.org_id)||(select org_abbreviation  from comm_org_information coi where  coi.org_id=dy.org_id) as org_abbreviation  from gms_device_account_dui dui ";
		   querySql+="left join gp_task_project pro on dui.project_info_id = pro.project_info_no left join gp_task_project_dynamic dy on dy.project_info_no = pro.project_info_no  left join gms_device_account acc on acc.dev_acc_id=dui.fk_dev_acc_id ";
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
</script>
</html>