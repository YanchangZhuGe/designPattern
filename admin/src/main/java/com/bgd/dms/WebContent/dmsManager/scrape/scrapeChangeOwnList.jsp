<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String code = request.getParameter("code");
	String userOrgId = user.getSubOrgIDofAffordOrg();
	String orgCode = user.getOrgCode();
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

<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/adapter/ext/ext-base.js"></script> 
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/js/extjs/resources/css/ext-all.css"/>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/ext-all.js"></script>
  <title>项目页面</title> 
 </head> 
 
 <body style="background:#cdddef" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input"><input id="s_dev_name" name="s_dev_name" type="text" /></td>
			    <td class="ali_cdn_name">设备编码</td>
			    <td class="ali_cdn_input"><input id="s_dev_type" name="s_dev_type" type="text" /></td>
			    <td class="ali_cdn_name">报废单号</td>
			    <td class="ali_cdn_input"><input id="s_scrape_apply_no" name="s_scrape_apply_no" type="text" class="input_width" /></td>     
			    <td class="ali_cdn_name">批复单号</td>
			    <td class="ali_cdn_input"><input id="s_scrape_report_no" name="s_scrape_report_no" type="text" class="input_width" /></td>
      			<!-- <td class="ali_cdn_input"><input id="s_app_no" name="s_app_no" type="hidden" class="input_width"/></td> -->
			    <!-- <td class="ali_cdn_name">自编号</td>
			    <td class="ali_cdn_input"><input id="s_self_num" name="s_self_num" type="text" /></td> -->
			    <!-- <td class="ali_cdn_name">牌照号</td>
			    <td class="ali_cdn_input"><input id="s_license_num" name="s_license_num" type="text" /></td> -->
      			<td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>			          			
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="gl" event="onclick='newSearch()'" title="JCDP_btn_filter"></auth:ListButton>
				<auth:ListButton functionId="" css="xg" event="onclick='toModifyScrapePage()'" title="修改设备所属单位"></auth:ListButton>
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
					<td class="bt_info_even" exp="<input type='checkbox' name='rdo_entity_id' value='{dev_acc_id}' id='rdo_entity_id_{dev_acc_id}'  onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
					<td class="bt_info_odd" exp="{owning_org_name_desc}">所属单位</td>
					<td class="bt_info_even" exp="{dev_type}">设备编码</td>
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<!-- <td class="bt_info_odd" exp="{erp_id}">ERP设备编号</td> -->
					<!-- <td class="bt_info_even" exp="{asset_coding}">AMIS资产编号</td> -->
					<td class="bt_info_even" exp="{dev_model}">规格型号</td>
					<td class="bt_info_odd" exp="{producting_date}">投产日期</td>
					<td class="bt_info_odd" exp="{license_num}">牌照号</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_odd" exp="{account_stat_desc}">资产状况</td>
					<!-- <td class="bt_info_even" exp="{self_num}">自编号</td>-->
					<td class="bt_info_even" exp="{asset_value}">原值</td>
					<!-- <td class="bt_info_even" exp="{using_stat_desc}">使用情况</td>
					<td class="bt_info_odd" exp="{tech_stat_desc}">技术状况</td> -->
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
			    <li id="tag3_12"><a href="#"  onclick="getTab3(12);loaddata('',12)">报废处置详情清单</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<div style="overflow: auto">
						<table width="100%" border="0" cellspacing="0" cellpadding="0"
							class="tab_line_height" style="background:url(<%=contextPath%>/images/list_15.png)">
							<tr align="right">
								<td class="ali_cdn_name"></td>
								<td class="ali_cdn_input"></td>
								<td class="ali_cdn_name"></td>
								<td class="ali_cdn_input"></td>
								<td>&nbsp;</td>
								<auth:ListButton functionId="" css="bc"	event="onclick='toEditbyjh()'" title="保存调拨修改"></auth:ListButton>
							</tr>
						</table>
					</div>
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
						  <tr>
							<td class="inquire_item6">所属单位</td>
							<td class="inquire_form6">
								<input id="owning_org_name" name="owning_org_name" class="input_width" type="text" />
								<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOrgTreePage()"  />
								<input id="owning_org_id" name="owning_org_id" class="" type="hidden" />
								<input id="owning_sub_id" name="owning_sub_id" class="" type="hidden" />
							</td>
							<td class="inquire_item6"></td>
							<td class="inquire_form6"></td>
							<td class="inquire_item6"></td>
							<td class="inquire_form6"></td>
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
			<div id="tab_box_content8" class="tab_box_content" style="display:none;">
				<table id="djMap" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
						<tr>   
						<td class="bt_info_even">序号</td>
						<td class="bt_info_odd">项目名称</td>
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
			<div id="tab_box_content11" class="tab_box_content" style="display:none;">
				<table id="bfczgc" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>   
						<td class="bt_info_even">报废申请时间</td>
						<td class="bt_info_odd">报废批复时间</td>
						<td class="bt_info_even">报废处理申请时间</td>
						<td class="bt_info_odd">报废处理结果时间</td>						
					  </tr>
					  <tbody id="assign_body"></tbody>
				</table>
			</div>
			<div id="tab_box_content12" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="bfczxqqd" id="bfczxqqd" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				<!-- <table id="" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    <tbody id="assign_body"></tbody>
				</table> -->
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
	//下拉时查询
	function selectRefreshData(){
	    searchDevData();
	}
	function searchDevData(){
		var v_dev_name = document.getElementById("s_dev_name").value;
		/* var v_license_num = document.getElementById("s_license_num").value;
		var v_self_num = document.getElementById("s_self_num").value; */
		var v_dev_type = document.getElementById("s_dev_type").value;
		var obj = new Array();
		obj.push({"label":"dev_name","value":v_dev_name});
		obj.push({"label":"dev_type","value":v_dev_type});
		
		var v_scrape_apply_no = document.getElementById("s_scrape_apply_no").value;//报废申请
		var objApp= new Array();
		objApp.push({"label":"app.scrape_apply_no","value":v_scrape_apply_no});
		
		var v_scrape_report_no = document.getElementById("s_scrape_report_no").value;//报废批复
		var objRep= new Array();
		objRep.push({"label":"rep.scrape_report_no","value":v_scrape_report_no});
		
		refreshData(obj,objApp,objRep);
	}
	 //清空查询条件
    function clearQueryText(){
    	document.getElementById("s_dev_name").value="";
		document.getElementById("s_dev_model").value="";
		document.getElementById("s_own_org_name").value="";
		document.getElementById("s_dev_type").value="";
		/* document.getElementById("s_license_num").value="";
		document.getElementById("s_self_num").value=""; */
		document.getElementById("s_scrape_apply_name").value="";
		document.getElementById("s_scrape_apply_no").value="";
    }
	//点击树节点查询
	var code = '<%=code%>';
	code = code.replace("S","");//点根节点时去除S,只有根节点带S
	function refreshData(arrObj,objApp,objRep,objDis){
		var userid = '<%=userOrgId%>';
		var orgLength = userid.length;
		var str = "";
		if(orgLength==4){
			/* str += "select u.coding_name as using_stat_desc,nvl(t.ifcountry, '国内') as ifcountry_tmp,c.coding_name as tech_stat_desc,t.dev_coding as erp_id, "
				+ "p.project_name as project_name_desc,t.dev_acc_id,t.dev_name,t.dev_model,t.dev_sign,t.self_num,t.license_num,t.dev_type, "
				+ "t.producting_date,t.asset_value,t.net_value,t.dev_position,t.asset_coding,t.cont_num,t.turn_num,t.spare1,t.spare2,t.spare3, "
				+ "case when t.owning_sub_id like 'C105001005%' then '塔里木物探处' when t.owning_sub_id like 'C105001002%' then '新疆物探处' "
				+ "when t.owning_sub_id like 'C105001003%' then '吐哈物探处' when t.owning_sub_id like 'C105001004%' then '青海物探处' "
				+ "when t.owning_sub_id like 'C105005004%' then '长庆物探处' when t.owning_sub_id like 'C105005000%' then '华北物探处' "
				+ "when t.owning_sub_id like 'C105005001%' then '新兴物探开发处' when t.owning_sub_id like 'C105007%' then '大港物探处' "
				+ "when t.owning_sub_id like 'C105063%' then '辽河物探处' when t.owning_sub_id like 'C105086%' then '深海物探处' "
				+ "when t.owning_sub_id like 'C105008%' then '综合物化处' when t.owning_sub_id like 'C105002%' then '国际勘探事业部' "
				+ "when t.owning_sub_id like 'C105006%' then '装备服务处' when t.owning_sub_id like 'C105003%' then '研究院' "
				+ "when t.owning_sub_id like 'C105017%' then '矿区服务事业部' else info.org_abbreviation end as owning_org_name_desc, "
				+ "i.org_abbreviation usage_org_name_desc,co.coding_name as account_stat_desc from gms_device_account t "
				+ "left join comm_org_information i on t.usage_org_id = i.org_id and i.bsflag = '0' "
				+ " join dms_scrape_detailed sd on sd.foreign_dev_id = t.dev_acc_id "
				+ "left join comm_org_information info on t.owning_org_id = info.org_id and info.bsflag = '0' "
				+ "left join gp_task_project p on t.project_info_no = p.project_info_no "
				+ "left join comm_coding_sort_detail co on co.coding_code_id = t.account_stat "
				+ "left join comm_coding_sort_detail c on c.coding_code_id = t.tech_stat "
				+ "left join comm_coding_sort_detail u on u.coding_code_id = t.using_stat "; */
			str += "select u.coding_name as using_stat_desc,nvl(t.ifcountry, '国内') as ifcountry_tmp,c.coding_name as tech_stat_desc,t.dev_coding as erp_id, "
				+ "p.project_name as project_name_desc,t.dev_acc_id,t.dev_name,t.dev_model,t.dev_sign,t.self_num,t.license_num,t.dev_type, "
				+ "t.producting_date,t.asset_value,t.net_value,t.dev_position,t.asset_coding,t.cont_num,t.turn_num,t.spare1,t.spare2,t.spare3, "
				+ "info.org_abbreviation as owning_org_name_desc, "
				+ "i.org_abbreviation usage_org_name_desc,co.coding_name as account_stat_desc from (select spare1,spare2,spare3, ifcountry, project_info_no, dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date from gms_device_account tt union all select '' spare1,'' spare2,'' spare3, ifcountry, project_info_no, dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date from gms_device_account_b) t "
				+ "left join comm_org_information i on t.usage_org_id = i.org_id and i.bsflag = '0' "
				+ " join dms_scrape_detailed sd on sd.foreign_dev_id = t.dev_acc_id "
				+ "left join comm_org_information info on t.owning_org_id = info.org_id and info.bsflag = '0' "
				+ "left join gp_task_project p on t.project_info_no = p.project_info_no "
				+ "left join comm_coding_sort_detail co on co.coding_code_id = t.account_stat "
				+ "left join comm_coding_sort_detail c on c.coding_code_id = t.tech_stat "
				+ "left join comm_coding_sort_detail u on u.coding_code_id = t.using_stat ";
		}else{
			str += "select u.coding_name as using_stat_desc,nvl(t.ifcountry, '国内') as ifcountry_tmp,c.coding_name as tech_stat_desc,t.dev_coding as erp_id, "
				+ "p.project_name as project_name_desc,t.dev_acc_id,t.dev_name,t.dev_model,t.dev_sign,t.self_num,t.license_num,t.dev_type, "
				+ "t.producting_date,t.asset_value,t.net_value,t.dev_position,t.asset_coding,t.cont_num,t.turn_num,t.spare1,t.spare2,t.spare3, "
				+ "info.org_abbreviation as owning_org_name_desc, "
				+ "i.org_abbreviation usage_org_name_desc,co.coding_name as account_stat_desc from (select spare1,spare2,spare3, ifcountry, project_info_no, dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date from gms_device_account tt union all select '' spare1,'' spare2,'' spare3, ifcountry, project_info_no, dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date from gms_device_account_b) t "
				+ "left join comm_org_information i on t.usage_org_id = i.org_id and i.bsflag = '0' "
				+ " join dms_scrape_detailed sd on sd.foreign_dev_id = t.dev_acc_id "
				+ "left join comm_org_information info on t.owning_org_id = info.org_id and info.bsflag = '0' "
				+ "left join gp_task_project p on t.project_info_no = p.project_info_no "
				+ "left join comm_coding_sort_detail co on co.coding_code_id = t.account_stat "
				+ "left join comm_coding_sort_detail c on c.coding_code_id = t.tech_stat "
				+ "left join comm_coding_sort_detail u on u.coding_code_id = t.using_stat ";
			/* str +=" where t.owning_sub_id like '"+userid+"%' "; */
			}
			str +="and (t.account_stat = '0110000013000000001' or t.account_stat = '0110000013000000002')";
			str +=" where 1=1 ";
		for(var key in arrObj) {
			if(arrObj[key].value!=undefined && arrObj[key].value!=''){
				if(arrObj[key].label=='source_from'){
					if(arrObj[key].value=="0"){
						str += " and scrape_apply_id is  not null ";
					}else if(arrObj[key].value=="1"){
						str += " and scrape_apply_id is null ";
					}
				}else if(arrObj[key].label=='org_abbreviation'){
					str += " and info.org_abbreviation like '%"+arrObj[key].value+"%' ";
				}else {
					str += " and t."+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
				}
			}
		}
		if(objApp!=undefined)
		if(objApp[0].value!=undefined && objApp[0].value!=''){
			str +="and t.dev_coding in(select d.dev_coding from DMS_SCRAPE_DETAILED d where d.scrape_apply_id in(select app.scrape_apply_id from dms_scrape_apply app where 1=1 ";
			str += "and "+objApp[0].label+" like '%"+objApp[0].value+"%' ";
			str +="))";
		}
		if(objRep!=undefined)
		if(objRep[0].value!=undefined && objRep[0].value!=''){
			str +="and t.dev_coding in(select d.dev_coding from DMS_SCRAPE_DETAILED d where d.scrape_apply_id in(select scrape_apply_id from dms_scrape_apply where scrape_report_id in(select scrape_report_id from dms_scrape_report rep where 1=1 ";
			str += "and "+objRep[0].label+" like '%"+objRep[0].value+"%' ";
			str +=")))";
		}
		if(objDis!=undefined)
		if(objDis[0].value!=undefined && objDis[0].value!=''){
			str +="and t.dev_coding in(select d.dev_coding from DMS_SCRAPE_DETAILED d where d.dispose_apply_id in(select dis.dispose_apply_id from dms_dispose_apply dis where 1=1 ";
			str += "and "+objDis[0].label+" like '%"+objDis[0].value+"%' ";
			str +="))";
		}
		str	+= "order by case "
			+ "when t.dev_type like 'S0808%' then 1 " 		//船舶
			+ "when t.dev_type like 'S14050101%' then 2 "   //地震仪器主机
			+ "when t.dev_type like 'S0623%' then 3 "       //可控震源
			+ "when t.dev_type like 'S1404%' then 4 "       //测量设备
			+ "when t.dev_type like 'S060101%' then 5 "     //车装钻机
			+ "when t.dev_type like 'S060102%' then 6 "     //人抬化钻机
			+ "when t.dev_type like 'S070301%' then 7 "     //推土机
			+ "when t.dev_type like 'S0622%' then 8 "       //仪器车
			+ "when t.dev_type like 'S08%' then 9 "         //运输设备
			+ "when t.dev_type like 'S0901%' then 10 "      //发电机组
			+ "end ";
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
		
		document.getElementById("owning_org_name").value =retObj.deviceaccMap.owning_org_name_desc;
		document.getElementById("owning_org_id").value = retObj.deviceaccMap.owning_org_id;
		document.getElementById("owning_sub_id").value = retObj.deviceaccMap.owning_sub_id;
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
    	popWindow('<%=contextPath%>/dmsManager/scrape/devquery_arichive.jsp');
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
		else if(index==8) 
			pro(ids);
		else if(index==11) 
			bfczgc(ids);
		else if(index==12) 
			bfczxqqd(ids);
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
		//var querySql="select pro.project_name,acc.dev_name,acc.asset_coding,info.mileage_total,info.drilling_footage_total,"+
		//	"info.work_hour_total,info.modify_date from gms_device_operation_info info "+
		//	"left join gms_device_archive_detail arc on arc.dev_archive_refid=info.operation_info_id "+
		//	"left join gms_device_account acc on acc.dev_acc_id=arc.dev_acc_id "+
		//	"left join gp_task_project pro on arc.project_info_id = pro.project_info_no "+
		//	"where arc.dev_archive_type='1' and arc.dev_acc_id='"+shuaId+"' "+
		//	" and arc.seqinfo = (select max(seqinfo) from gms_device_archive_detail arc "+
        // 	"where arc.dev_archive_type = '1' and arc.dev_acc_id='"+shuaId+"' )";
        var querySql = " select  nvl(sum(aa.mileage_total), 0) as mileage_total,nvl(sum(aa.drilling_footage_total), 0) as drilling_footage_total, nvl(sum(aa.work_hour_total), 0) as work_hour_total,aa.modify_date from ( select pro.project_name,acc.dev_name,acc.asset_coding,info.dev_acc_id,nvl(sum(info.mileage),0) as mileage_total,nvl(sum(info.drilling_footage),0) as drilling_footage_total,";
            querySql +="nvl(sum(info.work_hour),0) as work_hour_total,to_char(max(info.modify_date),'yyyy') as modify_date from gms_device_operation_info info ";
            querySql +="left join gms_device_archive_detail arc on arc.dev_archive_refid = info.operation_info_id left join gms_device_account acc on acc.dev_acc_id = arc.dev_acc_id ";
            querySql +="left join gp_task_project pro on arc.project_info_id = pro.project_info_no where arc.dev_archive_type = '1' ";
            querySql +="and arc.dev_acc_id ='"+shuaId+"' group by pro.project_name, acc.dev_name, acc.asset_coding,info.dev_acc_id ) aa  group by aa.modify_date    order by aa.modify_date desc ";
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
		var querySql = "select aa.modifi_date, nvl(sum(aa.human_cost), 0) human_cost, nvl(sum(aa.material_cost), 0) material_cost from  (select to_char(info.modifi_date, 'yyyy') as modifi_date,arc.dev_acc_id,nvl(sum(info.human_cost), 0) human_cost, nvl(sum(info.material_cost), 0) material_cost";
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
	function openQzbyView(devid,proid){
		if(devid != ''){
			window.showModalDialog("<%=contextPath%>/rm/dm/deviceArchive/devArchiveView_qzby.jsp?devaccid="+devid+"&projectinfoid="+proid,"","dialogWidth=1050px;dialogHeight=480px");
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
		var querySql="select pro.project_name,acc.dev_name,acc.asset_coding,info.*,det1.coding_name as accident_properties1,det2.coding_name as accident_grade1,wmsys.wm_concat(p.operator_name) over(partition by p.device_account_id order by p.operator_name) as operator_name from BGP_COMM_DEVICE_ACCIDENT_INFO info "+
				"left join GMS_DEVICE_ARCHIVE_DETAIL arc on arc.dev_archive_refid=info.accident_info_id "+
				"left join gms_device_account acc on acc.dev_acc_id=arc.dev_acc_id "+
				"left join gp_task_project pro on arc.project_info_id = pro.project_info_no "+
				"left join comm_coding_sort_detail det1 on det1.coding_code_id=info.accident_properties "+
				"left join comm_coding_sort_detail det2 on det2.coding_code_id=info.accident_grade left join gms_device_account_dui dui on acc.dev_acc_id = dui.fk_dev_acc_id left join gms_device_equipment_operator p on p.device_account_id=dui.dev_acc_id "+
				"where  arc.dev_acc_id='"+shuaId+"' order by seqinfo desc ";//arc.dev_archive_type='6' and
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
		* 参与项目****************************************************************************************************************************
		* @param {Object} shuaId
	*/
	function pro(shuaId){
									 
		var retObj;
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
		/**
		* 报废处置过程****************************************************************************************************************************
		* @param {Object} shuaId
	*/
	function bfczgc(shuaId){
									 
		var retObj;
		var querySql = "select a.scrape_apply_id,a.create_date bfsq_create,a.modifi_date bfsq_modifi,";
			querySql +="r.scrape_report_id,r.create_date bfsp_create,r.modifi_date bfsp_modifi,";
			querySql +="da.dispose_apply_id,da.create_date czsq_create,da.modifi_date czsq_modifi,";
			querySql +="dm.dispose_method_id,dm.dispose_date czjg_create "; 
			querySql +="from (select t.scrape_apply_id,cb.create_date,cb.modifi_date,t.scrape_report_id from DMS_SCRAPE_APPLY t ,common_busi_wf_middle cb where t.scrape_apply_id = cb.business_id ";
			var orgCode = '<%=orgCode%>';
			var orgLength = orgCode.length;
			if(orgLength!=4){
				querySql +=" and t.scrape_org_id ='"+'<%=orgId%>'+"'";
			}
			querySql +=") a ";
			querySql +="left join dms_scrape_detailed d  on a.scrape_apply_id = d.scrape_apply_id ";
			querySql +="left join (select t.scrape_report_id,cb.create_date,cb.modifi_date from dms_scrape_report t ,common_busi_wf_middle cb where t.scrape_report_id = cb.business_id) r on r.scrape_report_id = a.scrape_report_id ";
			querySql +="left join (select t.dispose_apply_id,cb.create_date,cb.modifi_date from dms_dispose_apply t ,common_busi_wf_middle cb where t.dispose_apply_id = cb.business_id) da on da.dispose_apply_id = d.dispose_apply_id ";
			querySql +="left join dms_dispose_method dm on dm.dispose_method_id = d.dispose_method_id ";
			querySql +="where d.foreign_dev_id = '"+shuaId+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
		retObj= queryRet.datas;
		var size = $("#assign_body", "#tab_box_content11").children("tr").size();
			if(size > 0){
				$("#assign_body", "#tab_box_content11").children("tr").remove();
			}
		var by_body1 = $("#assign_body", "#tab_box_content11")[0];
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
					newTd.innerHTML = "<a onClick='openBfsqView(\""+retObj[i].scrape_apply_id+"\")'>"+retObj[i].bfsq_create+"</a>";
				var newTd1 = newTr.insertCell();
					newTd1.innerHTML = "<a onClick='openBfspView(\""+retObj[i].scrape_report_id+"\")'>"+retObj[i].bfsp_modifi+"</a>";
				var newTd2 = newTr.insertCell();
					newTd2.innerHTML = "<a onClick='openCzsqView(\""+retObj[i].dispose_apply_id+"\")'>"+retObj[i].czsq_create+"</a>";
				var newTd3 = newTr.insertCell();
					newTd3.innerHTML = "<a onClick='openCzjgView(\""+retObj[i].dispose_method_id+"\")'>"+retObj[i].czjg_create+"</a>";
			}
		}
		$("#assign_body>tr:odd>td:odd",'#tab_box_content11').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#tab_box_content11').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#tab_box_content11').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#tab_box_content11').addClass("even_even");
	}
	function openBfsqView(id){
	window.showModalDialog("<%=contextPath%>/dmsManager/scrape/scrapeApplyList.jsp?scrape_apply_id="+id,"","dialogWidth=1050px;dialogHeight=480px");
	}
	function openBfspView(id){
		window.showModalDialog("<%=contextPath%>/dmsManager/scrape/scrapeReportListForSJZ.jsp?scrape_report_id="+id,"","dialogWidth=1050px;dialogHeight=480px");
	}
	function openCzsqView(id){
		window.showModalDialog("<%=contextPath%>/dmsManager/scrape/disposeApplyList.jsp?dispose_apply_id="+id,"","dialogWidth=1050px;dialogHeight=480px");
	}
	function openCzjgView(id){
		window.showModalDialog("<%=contextPath%>/dmsManager/scrape/disposeResultList.jsp?dispose_method_id="+id,"","dialogWidth=1050px;dialogHeight=480px");
	}
	/**
	* 报废处置详情清单****************************************************************************************************************************
	* @param {Object} shuaId
*/
function bfczxqqd(shuaId){
	var scrape_org_id = '<%=orgId%>';//所属组织部门	
	var foreign_dev_id = shuaId;//总台账设备id
    var scrape_detailed_id = jcdpCallService("ScrapeSrvNew", "getDevId", "foreign_dev_id="+foreign_dev_id).scrape_detailed_id;
    if(scrape_detailed_id!=0){
    	$("#bfczxqqd").attr("src","<%=contextPath%>/dmsManager/scrape/scrapeDisposeDetailsList.jsp?scrape_detailed_id="+scrape_detailed_id);
    }else{
    	alert("未找到该设备!");
    }

}
	/*修改设备所属单位*/
	function toModifyScrapePage(){
		var baseData;
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		 baseData = jcdpCallService("ScrapeSrv", "getScrapeState", "scrape_apply_id="+ids);
		var proStatus = baseData.deviceappMap.proc_status;
		if(proStatus=='1')
		{
			if(!confirm("您选择的记录中存在状态为'待审批'的单据,是否继续修改?")){
				return;
			}
			
		}
		if(proStatus=='3')
		{
			if(!confirm("您选择的记录中存在状态为'审批通过'的单据,是否继续修改?")){
				return;
			}
		}
		
		popWindow('<%=contextPath%>/dmsManager/scrape/scrapeApply_add.jsp?scrape_apply_id='+ids+'&proStatus='+proStatus,'840:650','修改报废申请');
	}
	 //打开保养计划修改界面
	 function toEditbyjh(){
		 var ids = getSelIds('rdo_entity_id');
		 var owning_org_id=$("#owning_org_id").val();
		 var owning_sub_id=$("#owning_sub_id").val();
		 if(owning_org_id !=""){
				Ext.MessageBox.wait('请等待','处理中');
				Ext.Ajax.request({
					url : "<%=contextPath%>/dmsManager/scrape/updateScrapeAccountOwn.srq",
					method : 'Post',
					isUpload : true,  
					params : {
						ids :ids,
						owning_org_id :owning_org_id,
						owning_sub_id :owning_sub_id
					},
					success : function(resp){
						alert("保存成功!");
						Ext.MessageBox.hide();
					},
					failure : function(resp){// 失败
						alert("保存失败！");
						Ext.MessageBox.hide();
					}
				}); 
			}else{
				alert("所属单位不能为空!");
				document.getElementById("owning_sub_id").focus();
			}
	 }
	 /**
		 * 选择组织机构树
		 */
		function showOrgTreePage(){
			var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
			if(returnValue == undefined){
				return;
			}
			var strs= new Array(); //定义一数组
			strs=returnValue.split("~"); //字符分割
			var names = strs[0].split(":");
			document.getElementById("owning_org_name").value = names[1];
			
			var orgId = strs[1].split(":");
			document.getElementById("owning_org_id").value = orgId[1];

			var orgSubId = strs[2].split(":");
			document.getElementById("owning_sub_id").value = orgSubId[1];
		}
</script>
</html>