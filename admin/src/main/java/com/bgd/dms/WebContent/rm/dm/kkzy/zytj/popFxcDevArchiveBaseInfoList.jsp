<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String code = request.getParameter("code");
	String userOrgId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link rel="stylesheet" type="text/css" media="all"
	href="<%=contextPath%>/css/calendar-blue.css" />

<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>

<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>项目页面</title>

</head>

<body style="background: #cdddef" onload="searchDevData()">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png"
						width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png"><table
							width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="ali_cdn_name">自编号</td>
								<td class="ali_cdn_input"><input id="s_self_num"
									name="s_self_num" type="text" /></td>
								<td class="ali_cdn_name">设备型号</td>
								<td class="ali_cdn_input"><input id="s_dev_model"
									name="s_dev_model" type="text" /></td>
									
									<td class="ali_cdn_name">国内/国外</td>
								<td class="ali_cdn_input">
								<select  id ="country" style="width: auto;">
								<option value="国内" selected="selected" >=请选择=</option>
								<option value="全部" >全部</option>
								<option value="国内" >国内</option>
								<option value="国外" >国外</option>
								</select>
								</td>
									
									
								<td class="ali_query"><span class="cx"><a href="#"
										onclick="searchDevData()" title="JCDP_btn_query"></a></span></td>
								<td class="ali_query"><span class="qc"><a href="#"
										onclick="clearQueryText()" title="JCDP_btn_clear"></a></span></td>
								<td>&nbsp;</td>
								<auth:ListButton functionId="" css="gl"
									event="onclick='newSearch()'" title="JCDP_btn_filter"></auth:ListButton>
								<auth:ListButton functionId="" css="zj"
									event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
								<auth:ListButton functionId="" css="xg"
									event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
								<auth:ListButton functionId="" css="sc"
									event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
								<auth:ListButton functionId="" css="dc"
									event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
							</tr>
						</table></td>
					<td width="4"><img src="<%=contextPath%>/images/list_17.png"
						width="4" height="36" /></td>
				</tr>
			</table>
		</div>
		<div id="table_box">
			<table style="width: 98.5%" border="0" cellspacing="0"
				cellpadding="0" class="tab_info" id="queryRetTable">
				<tr>
					<td class="bt_info_odd"
						exp="<input type='checkbox' name='rdo_entity_id' value='{dev_acc_id}' id='rdo_entity_id_{dev_acc_id}'  onclick='chooseOne(this);loadDataDetail();'/>">选择</td>
					<td class="bt_info_odd" exp="{self_num}">自编号</td>
					<td class="bt_info_odd" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_model}">设备型号</td>
					<td class="bt_info_odd" exp="{workhours}">当前运转小时</td>
					<td class="bt_info_even" exp="{owning_org_name_desc}">所属单位</td>
					<td class="bt_info_odd" exp="{usage_org_name_desc}">所在单位</td>
					<td class="bt_info_even" exp="{using_stat_desc}">使用情况</td>
					<td class="bt_info_odd" exp="{tech_stat_desc}">技术状况</td>
					<!-- <td class="bt_info_even" exp="{project_name_desc}">项目名称</td> -->
					<td class="bt_info_odd" exp="{dev_position}">所在位置</td>
					<td class="bt_info_even" exp="{ifcountry_tmp}">国内/国外</td>


				</tr>
			</table>
		</div>
		<div id="fenye_box" style="display: block">
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				id="fenye_box_table">
				<tr>
					<td align="right">第1/1页，共0条记录</td>
					<td width="10">&nbsp;</td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_01.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_02.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_03.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_04.png"
						width="20" height="20" /></td>
					<td width="50">到 <label> <input type="text"
							name="textfield" id="textfield" style="width: 20px;" />
					</label></td>
					<td align="left"><img
						src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				</tr>
			</table>
		</div>
		<div class="lashen" id="line"></div>
		<div id="tag-container_3">
			<ul id="tags" class="tags">
				<li class="selectTag" id="tag3_0"><a href="#"
					onclick="getTab3(0)">基本信息</a></li>
				<!-- <li id="tag3_1"><a href="#" onclick="getTab3(1);loaddata('',1)">设备运转记录</a></li> -->
				<li id="tag3_2"><a href="#" onclick="getTab3(2);loaddata('',2)">维修记录</a></li>
				<li id="tag3_11"><a href="#"
					onclick="getTab3(11);loaddata('',11)">保养记录</a></li>
				<li id="tag3_3"><a href="#" onclick="getTab3(3);loaddata('',3)">单机材料消耗</a></li>
				<!-- <li id="tag3_4"><a href="#" onclick="getTab3(4);loaddata('',4)">设备油品消耗</a></li> -->
				<li id="tag3_8"><a href="#" onclick="getTab3(8);loaddata('',8)">施工履历</a></li>
				<li id="tag3_7"><a href="#" onclick="getTab3(7);loaddata('',7)">主要总成件维修记录</a></li>
				<li id="tag3_12"><a href="#"
					onclick="getTab3(12);loaddata('',12)">主要总成件信息及更换记录</a></li>
				<!-- <li id="tag3_5"><a href="#" onclick="getTab3(5);loaddata('',5)">设备事故记录</a></li>
				<li id="tag3_9"><a href="#" onclick="getTab3(9)">附件</a></li>
				<li id="tag3_10"><a href="#" onclick="getTab3(10)">备注</a></li> -->

			</ul>
		</div>
		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" class="tab_box_content">
				<table id="devMap" width="100%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<td class="inquire_item6">设备名称</td>
						<td class="inquire_form6"><input id="dev_acc_name" name=""
							class="input_width" type="text" /></td>
						<td class="inquire_item6">设备型号</td>
						<td class="inquire_form6"><input id="dev_acc_model" name=""
							class="input_width" type="text" /></td>
						<td class="inquire_item6">设备编码</td>
						<td class="inquire_form6"><input id="dev_type"
							name="dev_type" class="input_width" type="text" /></td>
					</tr>
					<tr>
						<td class="inquire_item6">资产编号</td>
						<td class="inquire_form6"><input id="dev_acc_assetcoding"
							name="" class="input_width" type="text" /></td>
						<td class="inquire_item6">实物标识号</td>
						<td class="inquire_form6"><input id="dev_acc_sign" name=""
							class="input_width" type="text" /></td>
						<td class="inquire_item6">自编号</td>
						<td class="inquire_form6"><input id="dev_acc_self" name=""
							class="input_width" type="text" /></td>
					</tr>
					<tr>
						<td class="inquire_item6">牌照号</td>
						<td class="inquire_form6"><input id="dev_acc_license" name=""
							class="input_width" type="text" /></td>
						<td class="inquire_item6">发动机号</td>
						<td class="inquire_form6"><input id="dev_acc_engine_num"
							name="" class="input_width" type="text" /></td>
						<td class="inquire_item6">底盘号</td>
						<td class="inquire_form6"><input id="dev_acc_chassis_num"
							name="" class="input_width" type="text" /></td>
					</tr>
					<tr>
						<td class="inquire_item6">资产状况</td>
						<td class="inquire_form6"><input id="dev_acc_asset_stat"
							name="" class="input_width" type="text" /></td>
						<td class="inquire_item6">技术状况</td>
						<td class="inquire_form6"><input id="dev_acc_tech_stat"
							name="" class="input_width" type="text" /></td>
						<td class="inquire_item6">使用状况</td>
						<td class="inquire_form6"><input id="dev_acc_using_stat"
							name="" class="input_width" type="text" /></td>
					</tr>
					<tr>
						<td class="inquire_item6">出厂日期</td>
						<td class="inquire_form6"><input id="dev_acc_producting_date"
							name="" class="input_width" type="text" /></td>
						<td class="inquire_item6">固定资产原值</td>
						<td class="inquire_form6"><input id="dev_asset_value" name=""
							class="input_width" type="text" /></td>
						<td class="inquire_item6">固定资产净值</td>
						<td class="inquire_form6"><input id="dev_net_value" name=""
							class="input_width" type="text" /></td>
					</tr>

				</table>
			</div>
			<div id="tab_box_content1" class="tab_box_content"
				style="display: none;">
				<div style="overflow: auto">
					<table width="97%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr align="right">
							<td class="inquire_item6">累计里程(公里):</td>
							<td class="inquire_form6"><input id="v_mileage"
								name="v_mileage" class="input_width" type="text" readonly /></td>
							<td class="inquire_item6">累计钻井进尺(米):</td>
							<td class="inquire_form6"><input id="v_drilling_footage"
								name="v_drilling_footage" class="input_width" type="text"
								readonly /></td>
							<td class="inquire_item6">累计工作小时(小时):</td>
							<td class="inquire_form6"><input id="v_work_hour"
								name="v_work_hour" class="input_width" type="text" readonly /></td>
						</tr>
					</table>
				</div>
				<table id="yzMap" width="100%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
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
						<td class="bt_info_odd">查看明细</td>
					</tr>
					<tbody id="assign_body"></tbody>
				</table>
			</div>
			<!--维修记录-->
			<div id="tab_box_content2" class="tab_box_content"
				style="display: none;">
				<table id="byMap" width="250%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<!-- <td class="bt_info_odd">序号</td>
						<td class="bt_info_even">项目名称</td>
						<td class="bt_info_odd">设备名称</td>
						<td class="bt_info_even">自编号</td>
						<td class="bt_info_even">总成件类型</td>
						<td class="bt_info_odd">维修日期</td>
						<td class="bt_info_even">故障现象</td>
						<td class="bt_info_even">故障及解决办法</td>
						<td class="bt_info_even">承修单位</td>
						<td class="bt_info_odd">消耗备件</td> -->

						<td class="bt_info_odd">序号</td>
						<td class="bt_info_even">日期</td>
						<td class="bt_info_odd">设备型号</td>
						<td class="bt_info_even">自编号</td>
						<td class="bt_info_even">累计工作小时</td>
						<td class="bt_info_odd">故障现象</td>
						<td class="bt_info_even">故障原因</td>
						<td class="bt_info_even">故障解决办法</td>
						<td class="bt_info_even">更换主要备件</td>
						<td class="bt_info_odd">遗留问题</td>
						<td class="bt_info_even">主修（机械师）</td>
						<td class="bt_info_odd">备注</td>
						<td class="bt_info_even"><span class="dc"
							style="float: right; margin-top: -4px;"> <a href="#"
								onclick="exportDataDoc('wxjl')" title="导出excel"></a>
						</span></td>
					</tr>
					<tbody id="assign_body"></tbody>
				</table>
			</div>
			<!--单机材料消耗-->
			<div id="tab_box_content3" class="tab_box_content"
				style="display: none;">
				<div style="overflow: auto">
					<table width="97%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr align="right">
							<td class="inquire_item6">开始时间:</td>
							<td class="inquire_form6"><input id="v_start_date"
								name="v_start_date" class="input_width" type="text" readonly />
								<img src="/gms4/images/calendar.gif" id="tributton1" width="16"
								height="16" style="cursor: hand;"
								onmouseover="calDateSelector(v_start_date,tributton1);" /></td>
							<td class="inquire_item6">结束时间:</td>
							<td class="inquire_form6"><input id="v_end_date"
								name="v_end_date" class="input_width" type="text" readonly /> <img
								src="/gms4/images/calendar.gif" id="tributton2" width="16"
								height="16" style="cursor: hand;"
								onmouseover="calDateSelector(v_end_date,tributton2);" /></td>
							<td class="ali_query"><span class="cx"><a href="#"
									onclick="djxh()" title="JCDP_btn_query"></a></span></td>
							<td class="inquire_item6">累计总价(元):</td>
							<td class="inquire_form6"><input id="v_total_charge"
								name="v_total_charge" class="input_width" type="text" readonly />
							</td>
						</tr>
					</table>
				</div>
				<table id="metMap" width="250%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<td class="bt_info_odd">序号</td>
						<td class="bt_info_even">项目名称</td>
						<td class="bt_info_odd">物资编码</td>
						<td class="bt_info_even">物资名称</td>
						<td class="bt_info_odd">单位</td>
						<td class="bt_info_even">参考价格</td>
						<td class="bt_info_odd">实际价格</td>
						<td class="bt_info_even">消耗数量</td>
						<td class="bt_info_even">使用日期</td>
					</tr>
					<tbody id="assign_body"></tbody>
				</table>
			</div>
			<!--油水消耗-->
			<div id="tab_box_content4" class="tab_box_content"
				style="display: none;">
				<div style="overflow: auto">
					<table width="97%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr align="right">
							<td class="inquire_item6">项目累计数量(升):</td>
							<td class="inquire_form6"><input id="v_oil_num"
								name="v_oil_num" class="input_width" type="text"
								style="width: 160px;" readonly /></td>
							<td class="inquire_item6">项目累计金额(元):</td>
							<td class="inquire_form6"><input id="v_total_money"
								name="v_total_money" class="input_width" type="text"
								style="width: 160px;" readonly /></td>
						</tr>
					</table>
				</div>
				<table id="ysMap" width="250%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<td class="bt_info_odd">序号</td>
						<td class="bt_info_even">项目名称</td>
						<td class="bt_info_odd">设备名称</td>
						<td class="bt_info_even">AMIS资产编号</td>
						<!-- <td class="bt_info_even">加注日期</td>
						<td class="bt_info_odd">油品名称</td>
						<td class="bt_info_even">单位</td>
					    <td class="bt_info_odd">数量</td> -->
						<td class="bt_info_even">累计数量</td>
						<!-- <td class="bt_info_odd">单价（元）</td> -->
						<td class="bt_info_even">累计金额（元）</td>
						<td class="bt_info_odd">查看明细</td>
					</tr>
					<tbody id="assign_body"></tbody>
				</table>
			</div>
			<!--事故记录-->
			<div id="tab_box_content5" class="tab_box_content"
				style="display: none;">
				<table id="sgMap" width="250%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
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
			<!-- 项目修理记录 -->
			<div id="tab_box_content6" class="tab_box_content"
				style="display: none;">
				<div style="overflow: auto">
					<table width="97%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr align="right">
							<td class="inquire_item6">合计工时费(元):</td>
							<td class="inquire_form6"><input id="v_human_cost"
								name="v_human_cost" class="input_width" type="text"
								style="width: 160px;" readonly /></td>
							<td class="inquire_item6">合计材料费(元):</td>
							<td class="inquire_form6"><input id="v_material_cost"
								name="v_material_cost" class="input_width" type="text"
								style="width: 160px;" readonly /></td>
						</tr>
					</table>
				</div>
				<table id="whMap" width="250%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<td class="bt_info_even">序号</td>
						<td class="bt_info_odd">项目名称</td>
						<td class="bt_info_even">设备名称</td>
						<td class="bt_info_odd">AMIS资产编号</td>
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
			<!--总成件维修记录-->
			<div id="tab_box_content7" class="tab_box_content"
				style="display: none;">
				<table id="djMap" width="250%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<td class="bt_info_even">序号</td>
						<td class="bt_info_odd">日期</td>
						<td class="bt_info_even">自编号</td>
						<td class="bt_info_odd">总成件名称</td>
						<td class="bt_info_even">型号</td>
						<td class="bt_info_odd">系列号</td>
						<td class="bt_info_even">累计运转小时</td>
						<td class="bt_info_odd">修理级别</td>
						<td class="bt_info_even">主要修理内容</td>
						<td class="bt_info_odd">主要装配尺寸及性能指标</td>
						<td class="bt_info_even">承修单位</td>
						<td class="bt_info_odd">主修人</td>
						<td class="bt_info_even">备注</td>
						<td class="bt_info_odd"><span class="dc"
							style="float: right; margin-top: -4px;"> <a href="#"
								onclick="exportDataDoc('zcjjlwx')" title="导出excel"></a>
						</span></td>

					</tr>
					<tbody id="assign_body"></tbody>
				</table>
			</div>

			<!--总成件更换记录-->
			<div id="tab_box_content12" class="tab_box_content"
				style="display: none;">
				<table id="djMap" width="250%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<td  style="width: 5%" class="bt_info_even">序号</td>
						<td  style="width: 10%" class="bt_info_even">总成件名称</td>
						<td class="bt_info_even">型号</td>
						<td class="bt_info_odd">系列号</td>
						<td class="bt_info_odd">变更记录</td>
						<td class="bt_info_even">更换日期</td>
						<td class="bt_info_odd">承修人</td>
						
						<td class="bt_info_odd"><span class="dc"
							style="float: right; margin-top: -4px;"> <a href="#"
								onclick="exportDataDoc('zcjghjl')" title="导出excel"></a>
						</span></td>
					</tr>
					<tbody id="assign_body"></tbody>
				</table>
			</div>

			<!--参与项目-->
			<div id="tab_box_content8" class="tab_box_content"
				style="display: none;">
				<table id="djMap" width="250%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<td class="bt_info_even">序号</td>
						<td class="bt_info_odd">设备型号</td>
						<td class="bt_info_even">自编号</td>
						<td class="bt_info_odd">起止时间</td>
						<!-- <td class="bt_info_even">入队时间</td>
						<td class="bt_info_even">离队时间</td> -->
						<td class="bt_info_odd">国家/地区</td>
						<td class="bt_info_even">项目名称</td>
						<td class="bt_info_odd">施工队号</td>
						<td class="bt_info_even">施工方法</td>
						<td class="bt_info_odd">施工参数</td>
						<td class="bt_info_even">地表特征</td>
						<td class="bt_info_odd">工作时值12h/24h</td>
						<td class="bt_info_even">项目长/组长</td>	
						<td   align="left"><span class="dc"
							style="float: right; margin-top: -4px;"> <a href="#"
								onclick="exportDataDoc('kkzysgll')" title="导出excel"></a>
						</span></td>
					</tr>
					<tbody id="assign_body"></tbody>
				</table>
			</div>
			<!--保养记录-->
			<div id="tab_box_content11" class="tab_box_content"
				style="display: none;">
				<table id="djMap" width="250%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<!-- <td class="bt_info_even">序号</td>
						<td class="bt_info_odd">项目名称</td>
						<td class="bt_info_even">设备名称</td>
						<td class="bt_info_odd">自编号</td>
						<td class="bt_info_even">保养日期</td>
						<td class="bt_info_even">总成件类型</td>
						<td class="bt_info_odd">保养级别</td>
						<td class="bt_info_odd">主要保养内容</td>
						<td class="bt_info_odd">消耗备件</td> -->

						<td class="bt_info_even">序号</td>
						<td class="bt_info_odd">日期</td>
						<td class="bt_info_even">设备型号</td>
						<td class="bt_info_odd">自编号</td>
						<td class="bt_info_even">累计工作小时</td>
						<td class="bt_info_even">保养级别</td>
						<td class="bt_info_odd">主要保养内容</td>
						<td class="bt_info_odd">性能描述</td>
						<td class="bt_info_odd">主修(机械师)</td>
						<td class="bt_info_odd">备注</td>
						<td class="bt_info_odd"><span class="dc"
							style="float: right; margin-top: -4px;"> <a href="#"
								onclick="exportDataDoc('byjl')" title="导出excel"></a>
						</span></td>
					</tr>
					<tbody id="assign_body"></tbody>
				</table>
			</div>

			<div id="tab_box_content9" class="tab_box_content"
				style="display: none;"></div>
			<div id="tab_box_content10" class="tab_box_content"
				style="display: none;">
				<table id="remarkTab" width="100%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<td class="inquire_item6">备注</td>
						<td class="inquire_form6"><input id="dev_acc_remark" name=""
							class="input_width" type="text" /></td>
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
	//下拉时查询
	function selectRefreshData(){
	    searchDevData();
	}
	function searchDevData(){
		var v_dev_model = document.getElementById("s_dev_model").value;
		var v_self_num = document.getElementById("s_self_num").value;
		
		var obj = new Array();
		obj.push({"label":"dev_model","value":v_dev_model});
		obj.push({"label":"self_num","value":v_self_num});
		refreshData(obj);
		
	}
	 //清空查询条件
    function clearQueryText(){
		document.getElementById("s_dev_model").value="";
		document.getElementById("s_self_num").value="";
		$("#country  option").eq(0).attr("selected","selected");
    }
	//点击树节点查询
	var code = '<%=code%>';
	code = code.replace("S","");//点根节点时去除S,只有根节点带S
	function refreshData(arrObj){
		var userid = '<%=userOrgId%>';
		var orgLength = userid.length;
		var str = "";
		var country=$("#country").val();
		var   option=$("#country option:selected").text();
		if(orgLength==4){
			
			str += "select aa.*,(case when aa.owning_org_name_desc=aa.use_name then '' else aa.use_name end)use_name_desc from (select (select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc, "+
			" nvl(t.ifcountry, '国内') as ifcountry_tmp,(select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc,t.*,substr(t.foreign_key,8) as erp_id,"+
			" (select pro.project_name from gp_task_project pro where pro.project_info_no=t.project_info_no) as project_name_desc, (  select max(wx.work_hours)    from gms_device_zy_bywx wx   where wx.dev_acc_id  in (select dui.dev_acc_id from gms_device_account_dui dui where dui.fk_dev_acc_id=t.dev_acc_id)   or wx.dev_acc_id=t.dev_acc_id   and wx.bsflag = '0') as workhours,"+
			" (case when t.owning_sub_id like 'C105001005%' then '塔里木物探处' else (case when t.owning_sub_id like 'C105001002%' then '新疆物探处'else(case when t.owning_sub_id like 'C105001003%' then '吐哈物探处'else(case when t.owning_sub_id like 'C105001004%' then '青海物探处'else(case when t.owning_sub_id like 'C105005004%' then '长庆物探处'else(case when t.owning_sub_id like 'C105005000%' then '华北物探处'else(case when t.owning_sub_id like 'C105005001%' then '新兴物探开发处'else(case when t.owning_sub_id like 'C105007%' then '大港物探处'else(case when t.owning_sub_id like 'C105063%' then '辽河物探处'else(case when t.owning_sub_id like 'C105006%' then '装备服务处'else (case when t.owning_sub_id like 'C105002%' then '国际勘探事业部'else (case when t.owning_sub_id like 'C105003%' then '研究院'else (case when t.owning_sub_id like 'C105008%' then '综合物化处'else (case when t.owning_sub_id like 'C105015%' then '井中地震中心'  else (case when t.owning_sub_id like 'C105017%' then '矿区服务事业部' else '' end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) as owning_org_name_desc,i.org_abbreviation usage_org_name_desc ,nvl(pi.org_abbreviation,org.org_abbreviation) use_name,"+
			" (select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc "+
			" from gms_device_account t inner join (comm_org_subjection s inner join comm_org_information org on s.org_id=org.org_id) on t.owning_sub_id=s.org_subjection_id "+
			" left join comm_org_information i on t.usage_org_id = i.org_id and i.bsflag ='0'"+
			" left join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag ='0'"+
			" left join gp_task_project_dynamic d on p.project_info_no = d.project_info_no and d.bsflag ='0' "+
			" left join comm_org_information pi on d.org_id = pi.org_id and pi.bsflag ='0'"+
			"where t.bsflag='0' and t.account_stat!='0110000013000000005' "+
			"and t.owning_sub_id like '"+userid+"%' and t.dev_type like 'S062301%' and t.using_stat != '0110000007000000001'";
		
		
			
		}else{
			str += "select aa.*,aa.use_name use_name_desc from (select (select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc, "+
			" nvl(t.ifcountry, '国内') as ifcountry_tmp,(select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc,t.*,substr(t.foreign_key,8) as erp_id,"+
			" (select pro.project_name from gp_task_project pro where pro.project_info_no=t.project_info_no) as project_name_desc,"+
			" org.org_abbreviation as owning_org_name_desc ,       (select max(wx.work_hours) from gms_device_zy_bywx  wx where wx.dev_acc_id=t.dev_acc_id and wx.bsflag='0') as workhours,i.org_abbreviation usage_org_name_desc ,pi.org_abbreviation use_name,"+
			" (select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc "+
			" from gms_device_account t inner join (comm_org_subjection s inner join comm_org_information org on s.org_id=org.org_id) on t.owning_sub_id=s.org_subjection_id "+
			" left join comm_org_information i on t.usage_org_id = i.org_id and i.bsflag ='0'"+
			" left join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag ='0'"+
			" left join gp_task_project_dynamic d on p.project_info_no = d.project_info_no and d.bsflag ='0' "+
			" left join comm_org_information pi on d.org_id = pi.org_id and pi.bsflag ='0'"+
			" where t.bsflag='0' and t.account_stat!='0110000013000000005' "+
			" and t.owning_sub_id like '"+userid+"%' and t.dev_type like 'S062301%' and  t.using_stat != '0110000007000000001'";
		
		}

		for(var key in arrObj) {
			if(arrObj[key].value!=undefined && arrObj[key].value!=''){
				if(option=='=请选择='  || option=='全部'){
					country='全部';
				}
				str += "and "+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
			}
			
		}
		if(country=='国内'){
			str +="  and ( ifcountry is null  or ifcountry='国内') ";
		}else if(country=='国外'){
			str +="  and ifcountry='国外' ";
		}else if(country=='全部'){
	
		}
		str += " )aa   order by self_num desc";

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
			djxh();
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
			byjl(ids);
		else if(index==12) 
			zcjgh(ids);
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
        var querySql = "select pro.project_name,acc.dev_name,acc.asset_coding,info.dev_acc_id,nvl(sum(info.mileage),0) as mileage_total,nvl(sum(info.drilling_footage),0) as drilling_footage_total,";
            querySql +="nvl(sum(info.work_hour),0) as work_hour_total,max(info.modify_date) as modify_date from gms_device_operation_info info ";
            querySql +="left join gms_device_archive_detail arc on arc.dev_archive_refid = info.operation_info_id left join gms_device_account acc on acc.dev_acc_id = arc.dev_acc_id ";
            querySql +="left join gp_task_project pro on arc.project_info_id = pro.project_info_no where arc.dev_archive_type = '1' ";
            querySql +="and arc.dev_acc_id ='"+shuaId+"' group by pro.project_name, acc.dev_name, acc.asset_coding,info.dev_acc_id ";
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
				var newTd1 = newTr.insertCell();
				newTd1.innerText = retObj[i].project_name;
				var newTd2 = newTr.insertCell();
				newTd2.innerText = retObj[i].dev_name;
				var newTd3 = newTr.insertCell();
				newTd3.innerText = retObj[i].asset_coding;
				newTr.insertCell().innerText=retObj[i].mileage_total;
				newTr.insertCell().innerText=retObj[i].drilling_footage_total;
				newTr.insertCell().innerText=retObj[i].work_hour_total;
				newTr.insertCell().innerText=retObj[i].modify_date;
				newTr.insertCell().innerHTML = "<a onClick='openYzjlView(\""+retObj[i].dev_acc_id+"\")'>查看</a>";
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
	function openYzjlView(id){
		if(id != ''){
			//popWindow('<%=contextPath%>/rm/dm/deviceArchive/devArchiveView.jsp?devaccid='+id);
			window.showModalDialog("<%=contextPath%>/rm/dm/deviceArchive/devArchiveView_yzjl.jsp?devaccid="+id,"","dialogWidth=1050px;dialogHeight=480px");
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
		//var querySql="select pro.project_name,acc.dev_name,acc.asset_coding,info.repair_start_date,info.repair_detail,info.human_cost,info.material_cost from BGP_COMM_DEVICE_REPAIR_INFO info "+
		//	"left join GMS_DEVICE_ARCHIVE_DETAIL arc on arc.dev_archive_refid=info.repair_info "+
		//	"left join gms_device_account acc on acc.dev_acc_id=arc.dev_acc_id "+
		//	"left join gp_task_project pro on arc.project_info_id = pro.project_info_no "+
		//	"where arc.dev_archive_type='2' and arc.dev_acc_id='"+shuaId+"' order by seqinfo desc ";
		//var querySql=" select * from (select wx.bywx_date,  wx.falut_desc,  wx.falut_case,wx.maintenance_desc,  wx.repair_unit,   wx.repair_men,(select d.coding_name from comm_coding_sort_detail d where d.coding_code_id=wx.zcj_type) as zcj_type,  wx.usemat_id, '不在项目' as project_name, t.dev_name, t.self_num   from gms_device_zy_bywx wx ";
		 //  querySql+=" left join gms_device_account t on wx.dev_acc_id=t.dev_acc_id      where wx.MAINTENANCE_LEVEL = '无'  and wx.bsflag = '0'  and wx.project_info_id is null ";
		 //  querySql+=" and wx.dev_acc_id='"+shuaId+"'   union all      select   wx.bywx_date,  wx.falut_desc,  wx.falut_case,wx.maintenance_desc,  wx.repair_unit,   wx.repair_men, (select d.coding_name from comm_coding_sort_detail d where d.coding_code_id=wx.zcj_type) as zcj_type,  wx.usemat_id,   p.project_name ,";
		 //  querySql+=" dui.dev_name,   dui.self_num   from gms_device_zy_bywx wx left join gms_device_account_dui dui on wx.dev_acc_id=dui.dev_acc_id ";
		 //  querySql+=" left join gp_task_project p on p.project_info_no=wx.project_info_id  where wx.MAINTENANCE_LEVEL = '无'  and wx.bsflag = '0'  and wx.project_info_id is not null  and dui.fk_dev_acc_id='"+shuaId+"') tt order by tt.bywx_date desc ";
	var querySql="	select distinct*"
 +" from (select *"
 +"  from (select wx.create_date, wx.bak, wx.legacy, wx.falut_reason, wx.work_hours,t.dev_model, wx.bywx_date,wx.falut_desc, wx.falut_case, wx.maintenance_desc, wx.repair_unit,"
 +"                  wx.repair_men, (select d.coding_name"
 +"                      from comm_coding_sort_detail d"
 +"                      where d.coding_code_id = wx.zcj_type) as zcj_type,"
 +"                     wx.usemat_id, t.dev_name, i.wz_name, t.self_num"
 +"                from gms_device_zy_bywx wx"
 +"                left join gms_device_zy_wxbymat w"
 +"                 on wx.usemat_id = w.usemat_id"
 +"               left join gms_mat_recyclemat_info r"
 +"                  on r.wz_id = w.wz_id"
 +"                left join gms_mat_infomation i"
 +"                  on r.wz_id = i.wz_id"
 +"                left join gms_device_account_dui t"
 +"                  on t.dev_acc_id = wx.dev_acc_id"
 +"               where r.wz_type = '3'"
 +"                  and r.bsflag = '0'"
 +"              	                   and wx.bsflag = '0'"
	 +"                 and wx.project_info_id is not null"
	 +"                and r.project_info_id is not null"
	 +"                and wx.project_info_id = wx.project_info_id"
	 +"              and wx.maintenance_level = '无'"
	 +"              and t.fk_dev_acc_id = '"+shuaId+"'"
	 +"           union all"
	 +"           select wx.create_date, wx.bak,wx.legacy,wx.falut_reason, wx.work_hours, t.dev_model, wx.bywx_date,  wx.falut_desc, wx.falut_case,  wx.maintenance_desc,  wx.repair_unit,"
	 +"                  wx.repair_men,"
	 +"                  (select d.coding_name"
	 +"                    from comm_coding_sort_detail d"
	 +"                   where d.coding_code_id = wx.zcj_type) as zcj_type,"
	 +"                 wx.usemat_id, t.dev_name, i.wz_name, t.self_num"
	 +"            from gms_device_zy_bywx wx"
	 +"            left join gms_device_zy_wxbymat w"
	 +"              on wx.usemat_id = w.usemat_id"
	 +"             left join gms_mat_recyclemat_info r"
	 +"               on r.wz_id = w.wz_id"
	 +"            left join gms_mat_infomation i"
	 +"               on i.wz_id = r.wz_id"
	 +"             left join gms_device_account t"
	 +"               on t.dev_acc_id = wx.dev_acc_id"
	 +"            where r.wz_type = '3'"
	 +"             and r.bsflag = '0'"
	 +"             and wx.bsflag = '0'"
	 +"             and wx.project_info_id is null"
	 +"              and r.project_info_id is null"
	 +"              and wx.maintenance_level = '无'"
	 +"              and t.dev_acc_id = '"+shuaId+"') tt"
	 +"   union all"
	 +"   select *"
	 +"    from (select wx.create_date, wx.bak,wx.legacy, wx.falut_reason, wx.work_hours, t.dev_model, wx.bywx_date, wx.falut_desc,  wx.falut_case,  wx.maintenance_desc,  wx.repair_unit,"
	 +"                wx.repair_men, (select d.coding_name from comm_coding_sort_detail d"
	 +"                       where d.coding_code_id = wx.zcj_type) as zcj_type, wx.usemat_id, t.dev_name, '' as wz_name, t.self_num"
	 +"                from gms_device_zy_bywx wx  left join gms_device_account_dui t"
	 +"                 on t.dev_acc_id = wx.dev_acc_id"
	 +"              where (wx.usemat_id is null or"
	 +"                    wx.usemat_id not in"
	 +"                    (select usemat_id"
	 +"                        from gms_device_zy_wxbymat"
	 +"                       where usemat_id is not null))"
      +"                and wx.bsflag = '0' and wx.project_info_id is not null and wx.maintenance_level = '无' and t.fk_dev_acc_id = '"+shuaId+"'"
      +"             union all"
      +"             select  wx.create_date, wx.bak, wx.legacy, wx.falut_reason,  wx.work_hours, t.dev_model, wx.bywx_date, wx.falut_desc, wx.falut_case, wx.maintenance_desc, wx.repair_unit,"
      +"                   wx.repair_men,(select d.coding_name"
      +"                      from comm_coding_sort_detail d   where d.coding_code_id = wx.zcj_type) as zcj_type,    wx.usemat_id, t.dev_name, '' as wz_name,  t.self_num"
      +"             from gms_device_zy_bywx wx  left join gms_device_account t"
      +"               on t.dev_acc_id = wx.dev_acc_id"
      +"            where (wx.usemat_id is null or"
      +"                   wx.usemat_id not in"
      +"                  (select usemat_id"
      +"                      from gms_device_zy_wxbymat"
      +"                     where usemat_id is not null))"
       +"               and wx.bsflag = '0'"
       +"              and wx.project_info_id is null"
       +"              and wx.maintenance_level = '无'"
       +"               and t.dev_acc_id = '"+shuaId+"') ttt) k"
       +"  order by create_date  desc ,bywx_date desc";

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
				$("input[type='checkbox']","#queryRetTable").each(function(){
					if(this.checked){
						columnsObj = this.parentNode.parentNode.cells;
					}
				});
			var newTr = by_body1.insertRow();
					
			var newTd = newTr.insertCell();
			newTd.innerText = i+1;
			var newTd1 = newTr.insertCell();
			newTd1.innerText = retObj[i].bywx_date;
			var newTd2 = newTr.insertCell();
			newTd2.innerText = retObj[i].dev_model;
			var newTd3 = newTr.insertCell();
			newTd3.innerText = retObj[i].self_num;
			newTr.insertCell().innerText=retObj[i].work_hours;
			newTr.insertCell().innerText=retObj[i].falut_desc;
			newTr.insertCell().innerText=retObj[i].falut_reason;
			newTr.insertCell().innerText=retObj[i].falut_case;
			newTr.insertCell().innerText=retObj[i].wz_name;
			newTr.insertCell().innerText=retObj[i].legacy;
			newTr.insertCell().innerText=retObj[i].repair_men;
			newTr.insertCell().innerText=retObj[i].bak;
			//newTr.insertCell().innerHTML = "<a onClick='openwuzi(\""+retObj[i].usemat_id+"\")'>查看</a>";
			}
		}

	
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
		var querySql = "select acc.dev_name,acc.asset_coding,pro.project_name,t.project_info_no,d.dev_acc_id,";
			querySql += "nvl(sum(d.oil_num),0) oil_num,nvl(sum(d.total_money),0) total_money from gms_mat_teammat_out t ";
			querySql += "left join GMS_MAT_TEAMMAT_OUT_DETAIL d on t.teammat_out_id = d.teammat_out_id ";
			querySql += "left join gms_device_account_dui acc on acc.dev_acc_id = d.dev_acc_id left join gp_task_project pro ";
			querySql += "on t.project_info_no = pro.project_info_no where t.out_type = '3' ";
			querySql += "and acc.fk_dev_acc_id ='"+shuaId+"' group by acc.dev_name,acc.asset_coding,pro.project_name,t.project_info_no,d.dev_acc_id ";
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
				newTd1.innerText = retObj[i].project_name;
			var newTd2 = newTr.insertCell();
				newTd2.innerText = retObj[i].dev_name;
			var newTd3 = newTr.insertCell();
				newTd3.innerText = retObj[i].asset_coding;
												
				//newTr.insertCell().innerText=retObj[i].fill_date;
				//newTr.insertCell().innerText=retObj[i].oil_name1;
				//newTr.insertCell().innerText=retObj[i].oil_unit1;
				//newTr.insertCell().innerText=retObj[i].oil_quantity;
				//newTr.insertCell().innerText=retObj[i].quantity_total;
				//newTr.insertCell().innerText=retObj[i].oil_unit_price;
				//newTr.insertCell().innerText=retObj[i].oil_total;
				newTr.insertCell().innerText=retObj[i].oil_num;
				newTr.insertCell().innerText=retObj[i].total_money;
				newTr.insertCell().innerHTML = "<a onClick='openYsjlView(\""+retObj[i].dev_acc_id+"\",\""+retObj[i].project_info_no+"\")'>查看</a>";
	            
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
		var querySql = "select arc.project_info_id,pro.project_name,arc.dev_acc_id,acc.dev_name,acc.asset_coding,nvl(sum(info.human_cost), 0) human_cost,";
		    querySql += "nvl(sum(info.material_cost), 0) material_cost from BGP_COMM_DEVICE_REPAIR_INFO info left join GMS_DEVICE_ARCHIVE_DETAIL arc ";
		    querySql += "on arc.dev_archive_refid = info.repair_info left join gms_device_account acc on acc.dev_acc_id = arc.dev_acc_id ";
		    querySql += "left join gp_task_project pro on arc.project_info_id = pro.project_info_no where arc.dev_archive_type = '7' ";
		    querySql += "and arc.dev_acc_id ='"+shuaId+"' group by arc.project_info_id,pro.project_name,arc.dev_acc_id,acc.dev_name,acc.asset_coding ";
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
					newTd1.innerText = retObj[i].project_name;
				var newTd2 = newTr.insertCell();
					newTd2.innerText = retObj[i].dev_name;
				var newTd3 = newTr.insertCell();
					newTd3.innerText = retObj[i].asset_coding;		
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
					newTr.insertCell().innerHTML = "<a onClick='openWsjlView(\""+retObj[i].dev_acc_id+"\",\""+retObj[i].project_info_id+"\")'>查看</a>";
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
		* 总成件维修记录****************************************************************************************************************************
		* @param {Object} shuaId
	*/
	function djjl(shuaId){
							 
		var retObj;
		var querySql="select  wx.create_date, wx.zcj_model,t.dev_name,t.self_num,wx.sequence,(select    t.coding_name  from   comm_coding_sort_detail  t where  t.coding_sort_id='5110000187' and t.coding_code_id=wx.zcj_name) as zcj_name,wx.wx_date,wx.work_hour, d.coding_name as wx_level,wx.wx_content,wx.worker ,wx.performance_desc  ,wx.worker_unit ,wx.bak  from gms_device_zy_zcjwx wx   left join comm_coding_sort_detail d on d.coding_code_id=wx.wx_level left join gms_device_account t on t.dev_acc_id=wx.dev_acc_id "+
				"where wx.bsflag='0' and t.dev_acc_id='"+shuaId+"'  order by wx.create_date desc ";
			
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
					newTd1.innerText = retObj[i].wx_date;
					
					var newTd4 = newTr.insertCell();
					newTd4.innerText = retObj[i].self_num;
				var newTd2 = newTr.insertCell();
					newTd2.innerText = retObj[i].zcj_name;
				var newTd3 = newTr.insertCell();
				newTd3.innerText = retObj[i].zcj_model;
				newTr.insertCell().innerText= retObj[i].sequence;
				newTr.insertCell().innerText=retObj[i].work_hour;
					newTr.insertCell().innerText=retObj[i].wx_level;
					newTr.insertCell().innerText=retObj[i].wx_content;
					newTr.insertCell().innerText=retObj[i].performance_desc;
					newTr.insertCell().innerText=retObj[i].worker_unit;
					newTr.insertCell().innerText=retObj[i].worker;
					newTr.insertCell().innerText=retObj[i].bak;
			}
		}
		$("#assign_body>tr:odd>td:odd",'#tab_box_content7').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#tab_box_content7').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#tab_box_content7').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#tab_box_content7').addClass("even_even");
	}
		
		/**
		* 总成件更换记录****************************************************************************************************************************
		* @param {Object} shuaId
	*/
	function zcjgh(shuaId){
							 
		var retObj;
		/**var querySql="select * from(   select w.work_hours,w.repair_men,w.bywx_date,p.project_name,d.coding_name as zcj_type,  (select wz_sequence  from( select info.wz_sequence,wz_id    from gms_mat_recyclemat_info info   ) where rownum=1 and wz_id=t.wz_id ) as wz_sequence  from gms_device_zy_bywx w "+
				" left join gp_task_project p on p.project_info_no=w.project_info_id "+
				" left join comm_coding_sort_detail d on d.coding_code_id=w.zcj_type"+
				" left join gms_device_zy_wxbymat t on t.usemat_id=w.usemat_id "+
				" where  w.zcj_type is not null"+
				" and w.bsflag='0'    and w.dev_acc_id='"+shuaId+"'   union all"+
				"   select w.work_hours,w.repair_men,w.bywx_date,p.project_name,d.coding_name as zcj_type,  (select wz_sequence  from( select info.wz_sequence,wz_id    from gms_mat_recyclemat_info info   ) where rownum=1 and wz_id=t.wz_id ) as wz_sequence  from gms_device_zy_bywx w "+
				" left join gp_task_project p on p.project_info_no=w.project_info_id "+
				" left join comm_coding_sort_detail d on d.coding_code_id=w.zcj_type"+
				" left join gms_device_zy_wxbymat t on t.usemat_id=w.usemat_id "+
				" where  w.zcj_type is not null"+
				" and w.bsflag = '0'   and w.dev_acc_id in ( select dui.dev_acc_id from gms_device_account_dui dui where dui.fk_dev_acc_id = '"+shuaId+"')  ) order by bywx_date desc";*/
				var querySql="select  code.coding_name,a.* from  comm_coding_sort_detail code left join   ( 	select w.create_date ,( select s.coding_name   from   comm_coding_sort_detail  s   where s.coding_code_id=w.zcj_type ) zcj_type ,r.mat_model ,r.wz_sequence,w.falut_case,w.bywx_date,w.repair_men from comm_coding_sort_detail  c  left join gms_device_zy_bywx w   on c.coding_code_id=w.zcj_type  left  join  gms_device_zy_wxbymat t on w.usemat_id=t.usemat_id "+
				" left  join gms_mat_recyclemat_info r on t.wz_id=r.wz_id   left join gms_device_account_dui dui on dui.dev_acc_id=w.dev_acc_id "+
				" where w.bsflag='0' and r.wz_type='3'  and r.bsflag='0' and r.project_info_id=w.project_info_id "+
				" and r.project_info_id is not null and w.project_info_id  is not null  and  w.zcj_type  is not null  and dui.fk_dev_acc_id='"+shuaId+"'  "+
				" union all "+
				"  select w.create_date , ( select s.coding_name   from   comm_coding_sort_detail  s   where s.coding_code_id=w.zcj_type ) zcj_type ,r.mat_model ,r.wz_sequence,w.falut_case,w.bywx_date,w.repair_men  from comm_coding_sort_detail  c  left join gms_device_zy_bywx w  on c.coding_code_id=w.zcj_type   left  join  gms_device_zy_wxbymat t on w.usemat_id=t.usemat_id "+
				"  left  join gms_mat_recyclemat_info r on t.wz_id=r.wz_id left join gms_device_account dui on dui.dev_acc_id=w.dev_acc_id "+
				"  where w.bsflag='0' and r.wz_type='3'  and r.bsflag='0'  "+
				"  and r.project_info_id is  null and w.project_info_id  is null  and  w.zcj_type  is not null  and dui.dev_acc_id='"+shuaId+"' 	) a  on a.zcj_type=code.coding_name  where code.coding_sort_id='5110000187' and  code.coding_code_id  !='5110000187000000015'  order by code.coding_code_id asc ,a.create_date desc ";	
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj= queryRet.datas;
		var size = $("#assign_body", "#tab_box_content12").children("tr").size();
			if(size > 0){
				$("#assign_body", "#tab_box_content12").children("tr").remove();
			}
		var by_body1 = $("#assign_body", "#tab_box_content12")[0];
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
					newTd1.innerText = retObj[i].coding_name;
				var newTd2 = newTr.insertCell();
					newTd2.innerText = retObj[i].mat_model;
				var newTd3 = newTr.insertCell();
				newTd3.innerText = retObj[i].wz_sequence;	
				
				
				var newTd4 = newTr.insertCell();
				newTd4.innerText = retObj[i].falut_case;	
				
				
				var newTd5 = newTr.insertCell();
				newTd5.innerText = retObj[i].bywx_date;	
				
				newTr.insertCell().innerText= retObj[i].repair_men;									
			}
		}
		$("#assign_body>tr:odd>td:odd",'#tab_box_content12').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#tab_box_content12').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#tab_box_content12').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#tab_box_content12').addClass("even_even");
	}
		
	/**
		* 单机材料消耗****************************************************************************************************************************
		* @param {Object} shuaId
	*/
	function djxh(){
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
		    	alert("请选择一条记录");
		 		return;
		    }	
		   var startDate=document.getElementById("v_start_date").value;
		   var endDate=document.getElementById("v_end_date").value;
		    
		var retObj;
		var sum_total_charge="0";
		var total_charge="0";

		var querySql = "     select distinct* from (select nvl((select project_name  from gp_task_project p           where p.project_info_no = wx.project_info_id),           '不在项目') as projectname,"+
			 "     r.wz_id,i.wz_name, i.wz_prickie, i.wz_price, r.actual_price, mat.use_num, wx.bywx_date ,wx.create_date from gms_device_zy_bywx wx left join gms_device_zy_wxbymat mat  on wx.usemat_id = mat.usemat_id  left join gms_mat_recyclemat_info r    on r.wz_id = mat.wz_id  left join gms_mat_infomation i    on i.wz_id = r.wz_id  "+
		     "      left join gms_device_account_dui dui   on dui.dev_acc_id = wx.dev_acc_id    where  dui.fk_dev_acc_id = '"+ids+"'  and  r.wz_type = '3'   and r.bsflag = '0'   and r.project_info_id is not null   and wx.project_info_id is not null   and wx.bsflag = '0'  and wx.project_info_id = r.project_info_id "+
		     "      union all "+
		     "     select nvl((select project_name             from gp_task_project p           where p.project_info_no = wx.project_info_id),           '不在项目') as projectname,  "+
		     "            r.wz_id,       i.wz_name,       i.wz_prickie,       i.wz_price,       r.actual_price,       mat.use_num,       wx.bywx_date  ,wx.create_date  from gms_device_zy_bywx wx left join gms_device_zy_wxbymat mat    on wx.usemat_id = mat.usemat_id  left join gms_mat_recyclemat_info r    on r.wz_id = mat.wz_id  "+
		     "        left join gms_mat_infomation i    on i.wz_id = r.wz_id  left join gms_device_account dui    on dui.dev_acc_id = wx.dev_acc_id    where    dui.dev_acc_id = '"+ids+"'  and  r.wz_type = '3'   and r.bsflag = '0'  and r.project_info_id is null   and wx.project_info_id is null   and wx.bsflag = '0') a "; 

	
		    if(startDate!=undefined && startDate!=''){
		    	   querySql+=" and create_date>= to_date('"+startDate+"','yyyy-MM-dd')   ";
			}
		    if(endDate!=undefined && endDate!=''){
		    	   querySql+="  and create_date<= to_date('"+endDate+"','yyyy-MM-dd') ";
			}
		    querySql+=" order by bywx_date desc ,create_date desc";
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
					newTd1.innerText = retObj[i].projectname;
				var newTd2 = newTr.insertCell();
					newTd2.innerText = retObj[i].wz_id;
				var newTd3 = newTr.insertCell();
					newTd3.innerText = retObj[i].wz_name;
										
			
										
					newTr.insertCell().innerText=retObj[i].wz_prickie;
					newTr.insertCell().innerText=retObj[i].wz_price;
					newTr.insertCell().innerText=retObj[i].actual_price;
					newTr.insertCell().innerText=retObj[i].use_num;
					newTr.insertCell().innerText=retObj[i].bywx_date;
					
					total_charge= Number(retObj[i].use_num) * Number(retObj[i].actual_price);
					sum_total_charge=Number(sum_total_charge)+Number(total_charge);
				}
			}
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
		//var querySql="select pro.project_name, acc.dev_name, acc.asset_coding,dui.actual_in_time,dui.actual_out_time,  p.local_temp_low,  p.local_temp_height, p.projecter, p.work_hour, p.surface from gms_device_account_dui dui ";
		  // querySql+="left join gp_task_project pro on dui.project_info_id = pro.project_info_no left join gms_device_account acc on acc.dev_acc_id=dui.fk_dev_acc_id left join gms_device_zy_project p on p.project_info_id=dui.project_info_id  ";
		  // querySql+="where acc.dev_acc_id = '"+shuaId+"' and pro.bsflag = '0' and dui.bsflag = '0' and dui.is_leaving = '1' ";
		  // querySql+="group by pro.project_name,acc.dev_name,acc.asset_coding,dui.actual_in_time,dui.actual_out_time,p.local_temp_low,p.local_temp_height, p.projecter, p.work_hour, p.surface order by dui.actual_out_time desc";
		  var querySql="select pro.project_name,dui.dev_name,dui.asset_coding, dui.actual_in_time, dui.actual_out_time, p.local_temp_low,p.local_temp_height,"+
	              "  p.projecter,p.country,p.project_address,p.work_hour,p.surface, dui.dev_model,dui.self_num, org.org_abbreviation,p.construction_method,"+
	              " p.construction_paramete  "+
	              " from gms_device_account_dui dui join gms_device_zy_project p  "+
	              "  on p.project_info_id = dui.project_info_id   "+
	              " join gp_task_project pro   on dui.project_info_id = pro.project_info_no  "+
	              " join gp_task_project_dynamic dy   on dy.project_info_no = pro.project_info_no  "+
	              " join comm_org_information org     on org.org_id = dy.org_id  "+
	              " where dui.fk_dev_acc_id = '"+shuaId+"'";
		  
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
					newTd1.innerText = retObj[i].dev_model;
				var newTd2 = newTr.insertCell();
					newTd2.innerText = retObj[i].self_num;
				var newTd3 = newTr.insertCell();
					newTd3.innerText = retObj[i].actual_in_time+"--"+retObj[i].actual_out_time;
					newTr.insertCell().innerText=retObj[i].country+"/"+retObj[i].project_address;
					newTr.insertCell().innerText=retObj[i].project_name+"";
					newTr.insertCell().innerText=retObj[i].org_abbreviation;
					newTr.insertCell().innerText=retObj[i].construction_method;
					newTr.insertCell().innerText=retObj[i].construction_paramete;
					newTr.insertCell().innerText=retObj[i].surface;
					newTr.insertCell().innerText=retObj[i].work_hour+"h";
					//newTr.insertCell().innerText=retObj[i].local_temp_low+"℃";
				//	newTr.insertCell().innerText=retObj[i].local_temp_height+"℃";
					newTr.insertCell().innerText=retObj[i].projecter;
					
					
			}
		}
		$("#assign_body>tr:odd>td:odd",'#tab_box_content8').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#tab_box_content8').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#tab_box_content8').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#tab_box_content8').addClass("even_even");
	}
		/**
		* 保养记录****************************************************************************************************************************
		* @param {Object} shuaId
	*/
	function byjl(shuaId){
		var retObj;
		//var querySql=" select * from (select wx.bywx_date,wx.maintenance_level, wx.maintenance_desc,(select d.coding_name from comm_coding_sort_detail d where d.coding_code_id=wx.zcj_type) as zcj_type,  wx.usemat_id, '不在项目' as project_name, t.dev_name, t.self_num   from gms_device_zy_bywx wx ";
		  // querySql+=" left join gms_device_account t on wx.dev_acc_id=t.dev_acc_id      where wx.MAINTENANCE_LEVEL <> '无'  and wx.bsflag = '0'  and wx.project_info_id is null ";
		 //  querySql+=" and wx.dev_acc_id='"+shuaId+"'   union all      select   wx.bywx_date,wx.maintenance_level, wx.maintenance_desc, (select d.coding_name from comm_coding_sort_detail d where d.coding_code_id=wx.zcj_type) as zcj_type,  wx.usemat_id,   p.project_name ,";
		  // querySql+=" dui.dev_name,   dui.self_num   from gms_device_zy_bywx wx left join gms_device_account_dui dui on wx.dev_acc_id=dui.dev_acc_id ";
		  // querySql+=" left join gp_task_project p on p.project_info_no=wx.project_info_id  where wx.MAINTENANCE_LEVEL <> '无'  and wx.bsflag = '0'  and wx.project_info_id is not null  and dui.fk_dev_acc_id='"+shuaId+"') tt order by tt.bywx_date desc ";
		 	var  querySql = " select * from (select  wx.create_date,wx.bywx_date,wx.maintenance_level, wx.maintenance_desc,(select d.coding_name from comm_coding_sort_detail d where d.coding_code_id=wx.zcj_type) as zcj_type,  wx.usemat_id, '不在项目' as project_name, t.dev_name, t.self_num ,t.dev_model,wx.work_hours,( case wx.performance_desc   when '0'  then   '良好'  when '1'  then '待修'  when '2'  then '待查' end  ) as  performance_desc,wx.repair_men,wx.bak  from gms_device_zy_bywx wx ";
			querySql += " left join gms_device_account t on wx.dev_acc_id=t.dev_acc_id      where wx.MAINTENANCE_LEVEL <> '无'  and wx.bsflag = '0'  and wx.project_info_id is null ";
			querySql += " and wx.dev_acc_id='"
					+ shuaId
					+ "'   union all      select wx.create_date,  wx.bywx_date,wx.maintenance_level, wx.maintenance_desc, (select d.coding_name from comm_coding_sort_detail d where d.coding_code_id=wx.zcj_type) as zcj_type,  wx.usemat_id,   p.project_name ,";
			querySql += " dui.dev_name,   dui.self_num ,dui.dev_model,wx.work_hours, ( case wx.performance_desc    when '0' then '良好'  when '1'  then '待修'  when '2'  then '待查' end )  as performance_desc ,wx.repair_men,wx.bak  from gms_device_zy_bywx wx left join gms_device_account_dui dui on wx.dev_acc_id=dui.dev_acc_id ";
			querySql += " left join gp_task_project p on p.project_info_no=wx.project_info_id  where wx.MAINTENANCE_LEVEL <> '无'  and wx.bsflag = '0'  and wx.project_info_id is not null  and dui.fk_dev_acc_id='"
					+ shuaId + "') tt order by tt.create_date  desc ,tt.bywx_date desc ";
		
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
					newTd.innerText = i+1;
				var newTd1 = newTr.insertCell();
					newTd1.innerText = retObj[i].bywx_date;
				var newTd2 = newTr.insertCell();
					newTd2.innerText = retObj[i].dev_model;
				var newTd3 = newTr.insertCell();
					newTd3.innerText = retObj[i].self_num;
				var newTd4 = newTr.insertCell();
					newTd4.innerText = retObj[i].work_hours;
					newTr.insertCell().innerText=retObj[i].maintenance_level;
					newTr.insertCell().innerText=retObj[i].maintenance_desc;
					newTr.insertCell().innerText=retObj[i].performance_desc;
					newTr.insertCell().innerText=retObj[i].repair_men;
					newTr.insertCell().innerText=retObj[i].bak;
					//newTr.insertCell().innerHTML = "<a onClick='openwuzi(\""+retObj[i].usemat_id+"\")'>查看</a>";
			}
		}
		$("#assign_body>tr:odd>td:odd",'#tab_box_content11').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#tab_box_content11').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#tab_box_content11').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#tab_box_content11').addClass("even_even");
	}
	function openwuzi(num)
		{
			if(num=="")
				{
					alert("消耗备件为空!");
					return;}
			window.showModalDialog("<%=contextPath%>/rm/dm/kkzy/mutiPorject/devMatView_zy.jsp?usemat_id="+num,"","dialogWidth=1050px;dialogHeight=480px");
		}
	function openproject(num)
	{
		if(num=="")
			{
				alert("项目施工基本信息为空!");
				return;}
		window.showModalDialog("<%=contextPath%>/rm/dm/kkzy/mutiPorject/devProjectView_zy.jsp?project_id="+ num, "", "dialogWidth=1050px;dialogHeight=480px");
	}

	function exportDataDoc(exportFlag) {
		var dev_acc_id = "";
		$("input[type='checkbox'][name='rdo_entity_id']").each(function(i) {
			if ($(this).attr("checked") == 'checked') {
				dev_acc_id = $(this).val();
			}
		});
		if (dev_acc_id != "") {
			//调用导出方法
			var path = cruConfig.contextPath
					+ "/rm/dm/common/DmZhfxToExcel.srq";
			var submitStr = "";
			submitStr = "exportFlag=" + exportFlag + "&dev_acc_id="
					+ dev_acc_id;
			var retObj = syncRequest("post", path, submitStr);
			var filename = retObj.excelName;
			filename = encodeURI(filename);
			filename = encodeURI(filename);
			var showname = retObj.showName;
			showname = encodeURI(showname);
			showname = encodeURI(showname);
			window.location = cruConfig.contextPath
					+ "/rm/dm/common/download_temp.jsp?filename=" + filename
					+ "&showname=" + showname;
		} else {
			return;
		}
	}
</script>
</html>