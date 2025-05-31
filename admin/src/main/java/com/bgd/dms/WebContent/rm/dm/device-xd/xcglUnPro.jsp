<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectType = user.getProjectType();
	String taskId = request.getParameter("taskId");
	String code = request.getParameter("code");
	String userOrgId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link rel="stylesheet" type="text/css" media="all"
	href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/Calendar1.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>多项目-现场管理-现场管理(非生产单位)</title>
</head>

<body style="background: #cdddef" onload="refreshData()">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png"
						width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png"><table
							width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="ali_cdn_name">设备名称</td>
								<td class="ali_cdn_input" style="width: 105px"><input
									id="s_dev_name" name="s_dev_name" type="text" /></td>
								<td class="ali_cdn_name">规格型号</td>
								<td class="ali_cdn_input" style="width: 105px"><input
									id="s_dev_model" name="s_dev_model" type="text" /></td>
								<td class="ali_cdn_name">自编号</td>
								<td class="ali_cdn_input" style="width: 105px"><input
									id="s_self_num" name="s_self_num" type="text" /></td>
									<td class="ali_cdn_name">牌照号</td>
			    <td class="ali_cdn_input" style="width:105px"><input id="s_license_num" name="s_license_num" type="text" /></td>
								<td class="ali_cdn_name">保养计划&nbsp;&nbsp;</td>
								<td style="width: 280px;"><input id="s_start_date"
									name="s_start_date" type="text" size="12" /><img
									src="<%=contextPath%>/images/calendar.gif" id="tributton1"
									width="16" height="16" style="cursor: hand;"
									onmouseover="calDateSelector(s_start_date,tributton1);" />
									&nbsp;至&nbsp; <input id="s_end_date" name="s_end_date"
									type="text" size="12" /><img
									src="<%=contextPath%>/images/calendar.gif" id="tributton2"
									width="16" height="16" style="cursor: hand;"
									onmouseover="calDateSelector(s_end_date,tributton2);" /></td>
								<td class="ali_query"><span class="cx"><a href="#"
										onclick="searchDevData()" title="JCDP_btn_query"></a></span></td>
								<td class="ali_query"><span class="qc"><a href="#"
										onclick="clearQueryText()" title="JCDP_btn_clear"></a></span></td>

								<td>&nbsp;</td>
								 <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="设备返还"></auth:ListButton>
								<auth:ListButton functionId="" css="gl"
									event="onclick='newSearch()'" title="JCDP_btn_filter"></auth:ListButton>
								<auth:ListButton functionId="" css="dc"
									event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
								 <auth:ListButton functionId="" css="dr" event="onclick='deviceDataAdd()'" title="导入"></auth:ListButton>
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
					<td class="bt_info_even"
					exp="<input type='checkbox' name='rdo_entity_id' value='{dev_acc_id}'  id='rdo_entity_id_{dev_acc_id}'/>">选择</td>
					 <td class="bt_info_odd" exp="<img src='<%=contextPath%>/pm/projectHealthInfo/head{info}.jpg' alt='保养状况'  onclick=alertinfo('{info}') style='cursor: pointer;' width='14px' height='14px'/> " >&nbsp;&nbsp;保养状况</td>
					<td class="bt_info_even" exp="{dev_type}">设备编码</td>
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_model}">规格型号</td>
					<td class="bt_info_odd" exp="{self_num}">自编号</td>
					<td class="bt_info_even" exp="{license_num}">牌照号</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_even" exp="{asset_value}">固定资产原值</td>
					<td class="bt_info_even" exp="{owning_org_name_desc}">所属单位</td>
					<td class="bt_info_odd" exp="{usage_org_name_desc}">所在单位</td>
					<td class="bt_info_odd" exp="{tech_stat_desc}">技术状况</td>
					<td class="bt_info_odd" exp="{dev_position}">所在位置</td>
					<td class="bt_info_odd" exp="{producting_date}">投产日期</td>
					<td class="bt_info_even" exp="{erp_id}">ERP设备编号</td>	
					<td class="bt_info_odd" exp="{account_stat_desc}">资产状况</td>
					<td class="bt_info_even" exp="{spare1}">备注1</td>
					<td class="bt_info_odd" exp="{spare2}">备注2</td>
					<td class="bt_info_even" exp="{spare3}">备注3</td>
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
					onclick="getContentTab(this,0)">基本信息</a></li>
				<li id="tag3_14"><a href="#"
					onclick="getContentTab(this,14);loaddata('',14)">保养计划</a></li>
				<li id="tag3_6"><a href="#"
					onclick="getContentTab(this,6);loaddata('',6)">强制保养</a></li>
				<li id="tag3_7"><a href="#"
					onclick="getContentTab(this,7);loaddata('',7)">设备维修</a></li>
				<li id="tag3_8"><a href="#"
					onclick="getContentTab(this,8);loaddata('',8)">设备考勤</a></li>
				<li id="tag3_9"><a href="#"
					onclick="getContentTab(this,9);loaddata('',9)">设备事故</a></li>
				<li id="tag3_10"><a href="#"
					onclick="getContentTab(this,10);loaddata('',10)">设备检查</a></li>
				<li id="tag3_15"><a href="#"
					onclick="getContentTab(this,15);loaddata('',15)">日常检查</a></li>
				
				
				<li id="tag3_11"><a href="#"
					onclick="getContentTab(this,11);loaddata('',11)">油水记录</a></li>
			
				<li id="tag3_12"><a href="#"
					onclick="getContentTab(this,12);loaddata('',12)">定人定机</a></li>
				<li id="tag3_13"><a href="#"
					onclick="getContentTab(this,13);loaddata('',13)">运转记录</a></li>
				<li id="tag3_3"><a href="#"
					onclick="getContentTab(this,3);loaddata('',3)">附件</a></li>
				<li id="tag3_4"><a href="#"
					onclick="getContentTab(this,4);loaddata('',4)">备注</a></li>

			</ul>
		</div>
		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" name="tab_box_content0"
				class="tab_box_content">
				<table id="devMap" width="100%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<td class="inquire_item6">设备名称</td>
						<td class="inquire_form6"><input id="dev_acc_name" name=""
							class="input_width" type="text" /></td>
						<td class="inquire_item6">规格型号</td>
						<td class="inquire_form6"><input id="dev_acc_model" name=""
							class="input_width" type="text" /></td>
						<td class="inquire_item6">设备编码</td>
						<td class="inquire_form6"><input id="dev_type"
							name="dev_type" class="input_width" type="text" /></td>
					</tr>
					<tr>
						<!--<td class="inquire_item6">资产编号</td>
						    <td class="inquire_form6"><input id="dev_acc_assetcoding" name="" class="input_width" type="text" /></td>-->
						<td class="inquire_item6">ERP设备编号</td>
						<td class="inquire_form6"><input id="dev_acc_erpid" name=""
							class="input_width" type="text" /></td>
						<td class="inquire_item6">实物标识号</td>
						<td class="inquire_form6"><input id="dev_acc_sign" name=""
							class="input_width" type="text" /></td>
						<td class="inquire_item6">自编号</td>
						<td class="inquire_form6"><input id="dev_acc_self" name=""
							class="input_width" type="text" /></td>
					</tr>
					
					<tr>
						<td class="inquire_item6">投产日期</td>
						<td class="inquire_form6"><input id="producting_date" name=""
							class="input_width" type="text" /></td>
								<td class="inquire_item6">固定资产原值</td>
						<td class="inquire_form6"><input id="asset_value" name=""
							class="input_width" type="text" /></td>
								<td class="inquire_item6">固定资产净值</td>
						<td class="inquire_form6"><input id="net_value" name=""
							class="input_width" type="text" /></td>
					</tr>
					<tr>
						<td class="inquire_item6">AMIS资产编号</td>
						<td class="inquire_form6"><input id="asset_coding" name=""
							class="input_width" type="text" /></td>
						<td class="inquire_item6">合同编号</td>
						<td class="inquire_form6"><input id="cont_num"
							name="" class="input_width" type="text" /></td>
						<td class="inquire_item6">转资单号</td>
						<td class="inquire_form6"><input id="turn_num"
							name="" class="input_width" type="text" /></td>
					</tr>
					<tr>
						<td class="inquire_item6">资产状况</td>
						<td class="inquire_form6"><input id="dev_acc_asset_stat"
							name="" class="input_width" type="text" /></td>
						<td class="inquire_item6">技术状况</td>
						<td class="inquire_form6"><input id="dev_acc_tech_stat"
							name="" class="input_width" type="text" /></td>
					
					</tr>

				</table>
			</div>
			<!--强制保养-->
			<div id="tab_box_content6" name="tab_box_content6"
				class="tab_box_content" style="display: none;">
				<table width="97%" border="0" cellspacing="0" cellpadding="0"
					class="tab_line_height">
					<tr align="right">
						<td class="ali_cdn_name"></td>
						<td class="ali_cdn_input"></td>
						<td class="ali_cdn_name"></td>
						<td class="ali_cdn_input"></td>
						<td>&nbsp;</td>
						<auth:ListButton functionId="" css="zj"
							event="onclick='toAddQZBY()'" title="JCDP_btn_add"></auth:ListButton>
						<auth:ListButton functionId="" css="jh"
							event="onclick='toViewQZBY()'" title="查看明细"></auth:ListButton>
						<auth:ListButton functionId="" css="xg"
							event="onclick='toEditQZBY()'" title="JCDP_btn_edit"></auth:ListButton>
						<auth:ListButton functionId="" css="sc"
							event="onclick='toDeleteQZBY()'" title="JCDP_btn_delete"></auth:ListButton>
					</tr>
				</table>
				<table id="byMap" width="250%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<td class="bt_info_odd">选择</td>
						<td class="bt_info_even">设备名称</td>
						<td class="bt_info_odd">规格型号</td>
						<td class="bt_info_even">自编号</td>
						<td class="bt_info_odd">牌照号</td>
						<td class="bt_info_even">保养日期</td>
						<td class="bt_info_odd">修理详情</td>
						<td class="bt_info_even">送修日期</td>
						<td class="bt_info_odd">竣工日期</td>
						<td class="bt_info_even">工时费</td>
						<td class="bt_info_odd">材料费</td>
						<td class="bt_info_even">承修人</td>
						<td class="bt_info_odd">验收人</td>
						<td class="bt_info_even">单据状态</td>
					</tr>
					<tbody id="assign_body"></tbody>
				</table>
			</div>
			<!--维修保养-->
			<div id="tab_box_content7" name="tab_box_content7"
				class="tab_box_content" style="display: none;">
				<div style="overflow: auto">
					<table id='byMap' width="97%" border="0" cellspacing="0"
						cellpadding="0" class="tab_line_height">
						<tr align="right">
							<td class="ali_cdn_name"></td>
							<td class="ali_cdn_input"></td>
							<td class="ali_cdn_name"></td>
							<td class="ali_cdn_input"></td>
							<td>&nbsp;</td>
							<auth:ListButton functionId="" css="zj"
								event="onclick='toAddWHBY()'" title="JCDP_btn_add"></auth:ListButton>
							<auth:ListButton functionId="" css="jh"
								event="onclick='toView()'" title="查看明细"></auth:ListButton>
							<auth:ListButton functionId="" css="xg"
								event="onclick='toEditWHBY()'" title="JCDP_btn_edit"></auth:ListButton>
							<auth:ListButton functionId="" css="sc"
								event="onclick='toDeleteWHBY()'" title="JCDP_btn_delete"></auth:ListButton>
						</tr>
					</table>
				</div>
				<table id="whMap" width="250%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<td class="bt_info_odd">选择</td>
						<td class="bt_info_even">设备名称</td>
						<td class="bt_info_odd">规格型号</td>
						<td class="bt_info_even">自编号</td>
						<td class="bt_info_odd">牌照号</td>
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
			<!--设备考勤-->
			<div id="tab_box_content8" name="tab_box_content8"
				class="tab_box_content" style="display: none;">
				<div style="overflow: auto">
					<table width="97%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr align="right">
							<td class="ali_cdn_name"></td>
							<td class="ali_cdn_input"></td>
							<td class="ali_cdn_name"></td>
							<td class="ali_cdn_input"></td>
							<td>&nbsp;</td>
							<auth:ListButton functionId="" css="dr"
								event="onclick='toDRKQ()'" title="导入"></auth:ListButton>
							<auth:ListButton functionId="" css="zj"
								event="onclick='toAddKQ()'" title="JCDP_btn_add"></auth:ListButton>
							<auth:ListButton functionId="" css="sc"
								event="onclick='toDeleteKQ()'" title="JCDP_btn_delete"></auth:ListButton>
						</tr>
					</table>
				</div>
				<table id="kqMap" width="250%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<td class="bt_info_odd">选择</td>
						<td class="bt_info_even">设备名称</td>
						<td class="bt_info_odd">规格型号</td>
						<td class="bt_info_even">自编号</td>
						<td class="bt_info_odd">牌照号</td>
						<td class="bt_info_even">实物标识号</td>
						<td class="bt_info_odd">考勤月份</td>
						<td class="bt_info_even">详情</td>
					</tr>
					<tbody id="assign_body"></tbody>
				</table>
			</div>
			<!--设备事故-->
			<div id="tab_box_content9" name="tab_box_content9"
				class="tab_box_content" style="display: none;">
				<div style="overflow: auto">
					<table width="97%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr align="right">
							<td class="ali_cdn_name"></td>
							<td class="ali_cdn_input"></td>
							<td class="ali_cdn_name"></td>
							<td class="ali_cdn_input"></td>
							<td>&nbsp;</td>
							<auth:ListButton functionId="" css="zj"
								event="onclick='toAddSG()'" title="JCDP_btn_add"></auth:ListButton>
							<auth:ListButton functionId="" css="xg"
								event="onclick='toEditSG()'" title="JCDP_btn_edit"></auth:ListButton>
							<auth:ListButton functionId="" css="sc"
								event="onclick='toDeleteSG()'" title="JCDP_btn_delete"></auth:ListButton>
						</tr>
					</table>
				</div>
				<table id="sgMap" width="250%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<td class="bt_info_odd">选择</td>
						<td class="bt_info_even">设备名称</td>
						<td class="bt_info_odd">规格型号</td>
						<td class="bt_info_even">自编号</td>
						<td class="bt_info_odd">牌照号</td>
						<td class="bt_info_even">事故名称</td>
						<td class="bt_info_odd">所在单位</td>
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
			<!--设备检查-->
			<div id="tab_box_content10" name="tab_box_content10"
				class="tab_box_content" style="display: none;">
				<div style="overflow: auto">
					<table width="97%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr align="right">
							<td class="ali_cdn_name"></td>
							<td class="ali_cdn_input"></td>
							<td class="ali_cdn_name"></td>
							<td class="ali_cdn_input"></td>
							<td>&nbsp;</td>
							<auth:ListButton functionId="" css="zj"
								event="onclick='toAddSBJC()'" title="JCDP_btn_add"></auth:ListButton>
							<auth:ListButton functionId="" css="xg"
								event="onclick='toEditJC()'" title="JCDP_btn_edit"></auth:ListButton>
							<auth:ListButton functionId="" css="sc"
								event="onclick='toDeleteJC()'" title="JCDP_btn_delete"></auth:ListButton>
							<auth:ListButton functionId="" css="xz"
								event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton>
						</tr>
					</table>
				</div>
				<table id="jcMap" width="250%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<td class="bt_info_odd">选择</td>
						<td class="bt_info_even">设备名称</td>
						<td class="bt_info_odd">规格型号</td>
						<td class="bt_info_even">自编号</td>
						<td class="bt_info_odd">牌照号</td>
						<td class="bt_info_odd">所在单位</td>
						<!-- <td class="bt_info_even">项目名称</td>-->
						<!--  <td class="bt_info_odd">操作手</td>-->
						<td class="bt_info_even">检查类型</td>
						<td class="bt_info_odd">检查人</td>
						<td class="bt_info_even">检查日期</td>
						<td class="bt_info_even">责任人</td>
						<td class="bt_info_odd">附件</td>
					</tr>
					<tbody id="assign_body"></tbody>
				</table>
			</div>

			<!--日常检查-->
			<div id="tab_box_content15" name="tab_box_content15"
				class="tab_box_content" style="display: none;">
				<div style="overflow: auto">
					<table width="97%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr align="right">
							<td class="ali_cdn_name"></td>
							<td class="ali_cdn_input"></td>
							<td class="ali_cdn_name"></td>
							<td class="ali_cdn_input"></td>
							<td>&nbsp;</td>
						</tr>
					</table>
				</div>
				<table id="rcnewMap" width="250%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<td class="bt_info_odd">序号</td>
						<td class="bt_info_even">检查记录人</td>
						<td class="bt_info_odd">检查记录时间</td>
						<td class="bt_info_even">检查更新时间</td>
						<td class="bt_info_odd">创建时间</td>
						<td class="bt_info_even">详细</td>
					</tr>
					<tbody id="assign_body"></tbody>
				</table>
			</div>


			<!--油水记录-->
			<div id="tab_box_content11" name="tab_box_content11"
				class="tab_box_content" style="display: none;">
				<div style="overflow: auto">
					<table width="97%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr align="right">
							<td class="ali_cdn_name"></td>
							<td class="ali_cdn_input"></td>
							<td class="ali_cdn_name"></td>
							<td class="ali_cdn_input"></td>
							<td>&nbsp;</td>
						    	<auth:ListButton functionId="" css="zj" event="onclick='toAddYS()'" title="JCDP_btn_add"></auth:ListButton>
								<auth:ListButton functionId="" css="sc" event="onclick='toDeleteYS()'" title="JCDP_btn_delete"></auth:ListButton>
							
						</tr>
					</table>
				</div>
				<table id="ysMap" width="250%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<td class="bt_info_odd">选择</td>
						<td class="bt_info_even">设备名称</td>
						<td class="bt_info_odd">规格型号</td>
						<td class="bt_info_even">自编号</td>
						<td class="bt_info_odd">牌照号</td>
						<td class="bt_info_even">加注日期</td>
						<td class="bt_info_odd">油品名称</td>
						<td class="bt_info_even">单位</td>
						<td class="bt_info_odd">单价（元）</td>
						<td class="bt_info_even">数量</td>
						<td class="bt_info_odd">金额（元）</td>
						<td class="bt_info_even">累计数量</td>
						<td class="bt_info_odd">累计金额（元）</td>
					</tr>
					<tbody id="assign_body"></tbody>
				</table>
			</div>
			<!--定人定机-->
			<div id="tab_box_content12" name="tab_box_content12"
				class="tab_box_content" style="display: none;">
				<div style="overflow: auto">
					<table width="97%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr align="right">
							<td class="ali_cdn_name"></td>
							<td class="ali_cdn_input"></td>
							<td class="ali_cdn_name"></td>
							<td class="ali_cdn_input"></td>
							<td>&nbsp;</td>
							<auth:ListButton functionId="" css="zj"
								event="onclick='toAddDJ()'" title="JCDP_btn_add"></auth:ListButton>
							<auth:ListButton functionId="" css="xg"
								event="onclick='toEditDJ()'" title="JCDP_btn_edit"></auth:ListButton>
						</tr>
					</table>
				</div>
				<table id="djMap" width="250%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<td class="bt_info_odd">选择</td>
						<td class="bt_info_even">设备名称</td>
						<td class="bt_info_odd">规格型号</td>
						<td class="bt_info_even">自编号</td>
						<td class="bt_info_odd">牌照号</td>
						<td class="bt_info_even">所在单位</td>
						<td class="bt_info_even">操作手</td>

					</tr>
					<tbody id="assign_body"></tbody>
				</table>
			</div>

			<!--保养计划-->
			<div id="tab_box_content14" name="tab_box_content14"
				class="tab_box_content" style="display: none;">
				<div style="overflow: auto">
					<table width="97%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr align="right">
							<td class="ali_cdn_name"></td>
							<td class="ali_cdn_input"></td>
							<td class="ali_cdn_name"></td>
							<td class="ali_cdn_input"></td>
							<td>&nbsp;</td>
							<auth:ListButton functionId="" css="zj"
								event="onclick='toAddbyjh()'" title="JCDP_btn_add"></auth:ListButton>
							<auth:ListButton functionId="" css="xg"
								event="onclick='toEditbyjh()'" title="JCDP_btn_edit"></auth:ListButton>
						</tr>
					</table>
				</div>
				<table id="planTab" width="100%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<td class="bt_info_even">设备名称</td>
						<td class="bt_info_odd">规格型号</td>
						<td class="bt_info_even">计划保养时间</td>


					</tr>
					<tbody id="assign_body"></tbody>
				</table>
			</div>
			<!--运转记录-->
			<div id="tab_box_content13" name="tab_box_content13"
				class="tab_box_content" style="display: none;">
				<div style="overflow: auto">
					<table width="97%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height">
						<tr align="right">
							<td class="ali_cdn_name"></td>
							<td class="ali_cdn_input"></td>
							<td class="ali_cdn_name"></td>
							<td class="ali_cdn_input"></td>
							<td>&nbsp;</td>
							<auth:ListButton functionId="" css="dr"
								event="onclick='toDRYZ()'" title="导入"></auth:ListButton>
							<auth:ListButton functionId="" css="zj"
								event="onclick='toAddYZ()'" title="JCDP_btn_add"></auth:ListButton>
							<auth:ListButton functionId="" css="sc"
								event="onclick='toEditYZ()'" title="JCDP_btn_delete"></auth:ListButton>
						</tr>
					</table>
				</div>
				<table id="yzMap" width="100%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 2px;">
					<tr>
						<td class="bt_info_odd">选择</td>
						<td class="bt_info_even">设备名称</td>
						<td class="bt_info_odd">规格型号</td>
						<td class="bt_info_even">自编号</td>
						<td class="bt_info_odd">牌照号</td>
						<td class="bt_info_even">实物标识号</td>
						<td class="bt_info_even">填报时间</td>
						<td class="bt_info_odd">里程(公里)</td>
						<td class="bt_info_even">累计里程(公里)</td>
						<td class="bt_info_odd">钻井进尺(米)</td>
						<td class="bt_info_even">累计进尺(米)</td>
						<td class="bt_info_odd">工作小时(小时)</td>
						<td class="bt_info_even">累计小时(小时)</td>
					</tr>
					<tbody id="assign_body"></tbody>
				</table>
			</div>

			<div id="tab_box_content3" name="tab_box_content3"
				class="tab_box_content" style="display: none;">
				<iframe width="100%" height="100%" name="attachement"
					id="attachement" frameborder="0" src="" marginheight="0"
					marginwidth="0"></iframe>
			</div>
			<div id="tab_box_content4" name="tab_box_content4"
				class="tab_box_content" style="display: none;">
				<iframe width="100%" height="100%" name="remark" id="remark"
					frameborder="0" src="" marginheight="0" marginwidth="0"></iframe>
			</div>
			<div id="tab_box_content5" name="tab_box_content5"
				class="tab_box_content" style="display: none;">
				<iframe width="100%" height="100%" name="codeManager"
					id="codeManager" frameborder="0" src="" marginheight="0"
					marginwidth="0" scrolling="auto" style="overflow: scroll;"></iframe>
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
function getContentTab(obj,index) { 
		$("LI","#tag-container_3").removeClass("selectTag");
		var contentSelectedTag = obj.parentElement;
		contentSelectedTag.className ="selectTag";

		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		var currentid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				currentid = this.value;
			}		
		});
		if(index == 3){
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid);
		}else if(index == 4){
			$("#remark").attr("src","<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+currentid);
		}
		
		$(filternotobj).hide();
		$(filterobj).show();
	}
$(document).ready(lashen);
</script>

<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var taskIds = '<%=taskId%>';
	var projectType="<%=projectType%>";
	var ret;
	var retFatherNo;
	var project_num = 0;



	function searchDevData(){
		var v_dev_name = document.getElementById("s_dev_name").value;
		var v_dev_model = document.getElementById("s_dev_model").value;
		var v_self_num = document.getElementById("s_self_num").value;
		var v_license_num = document.getElementById("s_license_num").value;
		var obj = new Array();
		obj.push({"label":"dev_name","value":v_dev_name});
		obj.push({"label":"dev_model","value":v_dev_model});
		obj.push({"label":"self_num","value":v_self_num});
		obj.push({"label":"license_num","value":v_license_num});
		var dateobj = new Object();
		var v_start_date = document.getElementById("s_start_date").value;
		var v_end_date = document.getElementById("s_end_date").value;
		if(v_start_date !=""){
			dateobj.actual_in_time_s = v_start_date;
		}
		if(v_end_date !=""){
			dateobj.actual_in_time_e = v_end_date;
		}
		refreshData(obj,dateobj);
	}
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_dev_name").value="";
		document.getElementById("s_dev_model").value="";
		document.getElementById("s_self_num").value="";
		document.getElementById("s_start_date").value="";
		document.getElementById("s_end_date").value="";
    }
	//点击树节点查询
	var code = '<%=code%>';
	code = code.replace("S","");//点根节点时去除S,只有根节点带S
	function refreshData(arrObj,dateobj){
		var userid = '<%=userOrgId%>';
		
		var str = "select aa.* from (select  (case when nvl(t.mileage, -1) >= nvl(plan.mileage, 0) then  'red'   else   (case  when nvl(t.work_hour, -1) >=";
		str+=" nvl(plan.work_hour, 0) then  'red'  else (case  when nvl(t.drilling_footage, -1) >=  nvl(plan.drilling_footage, 0) then  'red'";
		str+=" 	 else    (case  when to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') >=nvl(( select plan_date from gms_device_maintenance_plan p where p.plan_num=1 and p.dev_acc_id=t.dev_acc_id),to_date(to_char(sysdate+1,'yyyy-mm-dd'),'yyyy-mm-dd'))";
		str+="  then  'red'  else  (case  when  (select count(*) from gms_device_maintenance_plan w where w.dev_acc_id=t.dev_acc_id)+   (select count(*) from gms_device_maintenance_unplan p where p.dev_acc_id=t.dev_acc_id )  <=0 ";
		str+=" 	 then  'yellow'   else  'green'  end)   end)  end) end) end) as info,  ";
        str+="  nvl(t.ifcountry, '国内') as ifcountry_tmp,    (select coding_name";
		str+="   from comm_coding_sort_detail c  where t.tech_stat = c.coding_code_id) as tech_stat_desc,";
		str+="  t.*, t.dev_coding as erp_id,     (case   when t.owning_sub_id like 'C105001005%' then   '塔里木物探处'   else";
		str+=" (case   when t.owning_sub_id like 'C105001002%' then   '新疆物探处'";
		str+=" else     (case   when t.owning_sub_id like 'C105001003%' then   '吐哈物探处'";
		str+=" else   (case  when t.owning_sub_id like 'C105001004%' then  '青海物探处'";
		str+=" else    (case   when t.owning_sub_id like 'C105005004%' then  '长庆物探处'";
		str+=" else    (case  when t.owning_sub_id like 'C105005000%' then      '华北物探处'";
		str+=" else (case  when t.owning_sub_id like 'C105005001%' then  '新兴物探开发处'";
		str+=" else (case  when t.owning_sub_id like 'C105007%' then  '大港物探处'";
    str+=" else   (case  when t.owning_sub_id like 'C105063%' then '辽河物探处'";
    str+=" else  (case when t.owning_sub_id like 'C105006%' then  '装备服务处'";
    str+=" else (case when t.owning_sub_id like 'C105002%' then  '国际勘探事业部'";
    str+=" else   (case  when t.owning_sub_id like 'C105003%' then  '研究院'";
    str+=" else (case  when t.owning_sub_id like 'C105008%' then '综合物化处'";
    str+=" else   (case  when t.owning_sub_id like 'C105015%' then  '井中地震中心'";
    str+=" else (case  when t.owning_sub_id like 'C105017%' then  '矿区服务事业部'";
    str+=" else  ''  end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) as owning_org_name_desc,";
    str+=" i.org_abbreviation usage_org_name_desc,  (select coding_name from comm_coding_sort_detail co";
    str+=" where co.coding_code_id = t.account_stat) as account_stat_desc  from gms_device_account_unpro t";
    str+=" inner join(comm_org_subjection s  inner join comm_org_information org on s.org_id = org.org_id) on t.owning_sub_id = s.org_subjection_id";
    str+=" left join comm_org_information i on t.usage_org_id = i.org_id   and i.bsflag = '0'";
    str+="    left join gms_device_maintenance_unplan plan on plan.dev_acc_id=t.dev_acc_id";
    str+=" where t.bsflag = '0' and t.is_leaving='0'  and t.owning_sub_id like '"+userid+"%'";
	
	for(var key in arrObj) { 
		if(arrObj[key].value!=undefined && arrObj[key].value!=''){
			if(arrObj[key].label.indexOf("actual_in_time")==-1){
				str += "and "+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
			}
		}
	}
    
	if(dateobj!=undefined && dateobj!=""){
		if(dateobj.actual_in_time_s!=undefined && dateobj.actual_in_time_e!=undefined){
			str += " and exists(select 1 from gms_device_maintenance_plan plan where plan.dev_acc_id=t.dev_acc_id ";
			str += "and trunc(plan.plan_date,'dd') >= to_date('"+dateobj.actual_in_time_s+"','yyyy-mm-dd') ";
			str += "and trunc(plan.plan_date,'dd') <= to_date('"+dateobj.actual_in_time_e+"','yyyy-mm-dd') ";
			str += ") ";
			}
		if(dateobj.actual_in_time_s!=undefined && dateobj.actual_in_time_e==undefined){
			str += " and exists(select 1 from gms_device_maintenance_plan plan where plan.dev_acc_id=t.dev_acc_id ";
			str += "and trunc(plan.plan_date,'dd') >= to_date('"+dateobj.actual_in_time_s+"','yyyy-mm-dd') ";
			str += ") ";
		}
		if(dateobj.actual_in_time_s==undefined && dateobj.actual_in_time_e!=undefined){
			str += " and exists(select 1 from gms_device_maintenance_plan plan where plan.dev_acc_id=t.dev_acc_id ";
			str += "and trunc(plan.plan_date,'dd') <= to_date('"+dateobj.actual_in_time_e+"','yyyy-mm-dd') ";
			str += ") ";
		}
		 
	}
		str += ") aa";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	var actualOutTime;
    function loadDataDetail(shuaId){
    	var retObj;
    	$("#queryRetTable :checked").removeAttr("checked");
    	$("#rdo_entity_id_"+shuaId).attr("checked","checked");
		if(shuaId!=null){
			var querySql="select  (select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc, t.*,t.dev_coding as erp_id,(select org_abbreviation from comm_org_information org where t.owning_org_id=org.org_id) as owning_org_name_desc,(select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc from Gms_Device_Account_Unpro t where dev_acc_id= '"+shuaId+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			retObj = queryRet.datas;
			 //retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfo", "deviceId="+shuaId);
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    var querySql="select  (select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc, t.*,t.dev_coding as erp_id,(select org_abbreviation from comm_org_information org where t.owning_org_id=org.org_id) as owning_org_name_desc,(select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc from Gms_Device_Account_Unpro t where dev_acc_id= '"+ids+"'"  ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj = queryRet.datas;
		    // retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfo", "deviceId="+ids);
		}
		document.getElementById("dev_acc_name").value =retObj[0].dev_name;
		document.getElementById("dev_acc_sign").value =retObj[0].dev_sign;
		document.getElementById("dev_type").value =retObj[0].dev_type;
		document.getElementById("dev_acc_erpid").value =retObj[0].erp_id;
		document.getElementById("dev_acc_model").value =retObj[0].dev_model;
		document.getElementById("dev_acc_self").value =retObj[0].self_num;
		document.getElementById("producting_date").value =retObj[0].producting_date;
		document.getElementById("asset_value").value =retObj[0].asset_value;
		document.getElementById("net_value").value =retObj[0].net_value;
		document.getElementById("asset_coding").value =retObj[0].asset_coding;
		document.getElementById("cont_num").value =retObj[0].cont_num;
		document.getElementById("turn_num").value =retObj[0].turn_num;
		document.getElementById("dev_acc_tech_stat").value =retObj[0].tech_stat_desc;
		document.getElementById("dev_acc_asset_stat").value =retObj[0].account_stat_desc;
		

		actualOutTime = retObj[0].actual_out_time;
		//alert(actualOutTime);
		
		
		document.getElementById("dev_type").value =retObj[0].dev_type;
		if(shuaId==null)
			shuaId = ids;
		loaddata(shuaId,selectedTagIndex);
    }
	
        
    function newSearch(){
    	popWindow('<%=contextPath%>/rm/dm/device-xd/devquery.jsp');
    }
	/**
	 * 强制保养****************************************************************************************************************************
	 * @param {Object} shuaId
	 */
	function qzby(shuaId){
		var retObj;
		var querySql="select * from bgp_comm_device_repair_info "+
			"where repair_type='0110000037000000002' and device_account_id='"+shuaId+"' order by repair_start_date desc ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
		retObj= queryRet.datas;
		var size = $("#assign_body", "#tab_box_content6").children("tr").size();
		if (size > 0) {
			$("#assign_body", "#tab_box_content6").children("tr").remove();
		}
		var by_body1 = $("#assign_body", "#tab_box_content6")[0];
		if (retObj != undefined) {
			for (var i = 0; i < retObj.length; i++) {
				var columnsObj ;
				$("input[type='checkbox']", "#queryRetTable").each(function(){
					if(this.checked){
						columnsObj = this.parentNode.parentNode.cells;
					}
				});
				var newTr = by_body1.insertRow();
				newTr.onclick = function(){
						setGl2(this, 'tab_box_content6');
					}
				newTr.ondblclick = function(){
					getdate(this);
				}
				newTr.insertCell().innerHTML = "<input type='checkbox' id='repair_info"+retObj[i].repair_info+"' value='"+retObj[i].repair_info+"'/>";
				
				
				var newTd2 = newTr.insertCell();
				newTd2.innerText = columnsObj(3).innerText;
				var newTd3 = newTr.insertCell();
				newTd3.innerText = columnsObj(4).innerText;
				var newTd4 = newTr.insertCell();
				newTd4.innerText = columnsObj(5).innerText;
				var newTd5 = newTr.insertCell();
				newTd5.innerText = columnsObj(6).innerText;
				
				
				var newTd5 = newTr.insertCell();
				newTd5.innerText = retObj[i].repair_start_date;// + "-" + retObj[i].month;
				var newTd6 = newTr.insertCell();
				newTd6.innerText = retObj[i].repair_detail;
				newTr.insertCell().innerText = retObj[i].repair_start_date;
				newTr.insertCell().innerText = retObj[i].repair_end_date;
				newTr.insertCell().innerText = retObj[i].human_cost;
				newTr.insertCell().innerText = retObj[i].material_cost;
				newTr.insertCell().innerText = retObj[i].repairer;
				newTr.insertCell().innerText = retObj[i].accepter;
				newTr.insertCell().innerText = retObj[i].record_status;
			}
		}
		$("#assign_body>tr:odd>td:odd",'#tab_box_content6').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#tab_box_content6').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#tab_box_content6').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#tab_box_content6').addClass("even_even");
	}   	
	function toAddQZBY(){
		  
		var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }
	 	popWindow("<%=contextPath%>/rm/dm/device-xd/qzbyUnPro.jsp?ids="+ids,'950:680'); 
	 	
	 }
	//查看保养明细界面
    function toViewQZBY(obj){
   	 if(obj==undefined){
     		obj=$("input[type='checkbox'][id^='repair_info']", "#byMap>tbody");	//$("#wh_body :checked")[0].parentNode.parentNode;
     	}
		if(obj == undefined)
			return;
		var repairinfoval = null;
		for(var index=0;index<obj.length;index++){
			if(obj[index].checked == true){
				repairinfoval = obj[index].value;
				break;
			}
		}
     	var ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
    	popWindow("<%=contextPath%>/rm/dm/device-xd/qzbydetailUnPro.jsp?ids="+ids+"&repair_info="+repairinfoval,'950:680'); 
        }
    //修改界面
     function toEditQZBY(obj){ 
    		var ids = getSelIds('rdo_entity_id');
     	if(obj==undefined){
     		obj=$("input[type='checkbox'][id^='repair_info']", "#byMap>tbody");	//$("#wh_body :checked")[0].parentNode.parentNode;
     	}
		if(obj == undefined)
			return;
		var repairinfoval = null;
		for(var index=0;index<obj.length;index++){
			if(obj[index].checked == true){
				repairinfoval = obj[index].value;
				break;
			}
		}
     	var ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
    	popWindow("<%=contextPath%>/rm/dm/device-xd/qzbyUnPro.jsp?ids="+ids+"&repair_info="+repairinfoval,'950:680'); 
	 }
	 function toDeleteQZBY(obj){
		 if(obj==undefined){
	     		obj=$("input[type='checkbox'][id^='repair_info']", "#byMap>tbody");	//$("#wh_body :checked")[0].parentNode.parentNode;
	     	}
			if(obj == undefined)
				return;
			var repairinfoval = null;
			for(var index=0;index<obj.length;index++){
				if(obj[index].checked == true){
					repairinfoval = obj[index].value;
					break;
				}
			}
 		ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
			    
			if(confirm('确定要删除吗?')){  
				var retObj = jcdpCallService("DevCommInfoSrv", "deleteQZBY", "deviceId="+repairinfoval);
				qzby(ids);
			}

	}
	/**
	 * 获取日期
	 * @param {Object} obj
	 */
	function getdate(obj){
    var dev_appdet_id;
	var ye;
	var me;
	var vall=obj.lin.split("&");
	for(var i=0;i<vall.length;i++){
		var temp= vall[i].split("=");
		if(temp[0]=="device_acc_id"){
			dev_appdet_id= temp[1];
		}
		if(temp[0]=="ye"){
			ye= temp[1];
		}
		if(temp[0]=="me"){
			me= temp[1];
		}
	}
    	var querySql="select to_char(a.next_maintain_date,'yyyy') as Year,to_char(a.NEXT_MAINTAIN_DATE,'mm') as month,to_char(a.NEXT_MAINTAIN_DATE,'dd') as day,a.* from BGP_COMM_DEVICE_MAINTAIN a where a.device_account_id='"+dev_appdet_id+"' and to_char(a.NEXT_MAINTAIN_DATE,'yyyy')='"+ye+"' and to_char(a.NEXT_MAINTAIN_DATE,'mm')='"+me+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
		var basedatas = queryRet.datas;
		calendar2(basedatas);
    }
    function qzbycallback(obj){
    
    }
	/**
	 *维修保养****************************************************************************************************************************
	 */
	function wxby(shuaId){
		
		if(shuaId!=null){
			var querySql="select (select coding_name from comm_coding_sort_detail where coding_code_id=a.REPAIR_TYPE)as repairtype,(select coding_name from comm_coding_sort_detail where coding_code_id=a.repair_item )as repairitem ,a.* from BGP_COMM_DEVICE_REPAIR_INFO a where a.repair_type<>'0110000037000000002' and a.DEVICE_ACCOUNT_ID= '"+shuaId+"' order by a.repair_start_date desc";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj= queryRet.datas;
			var size = $("#assign_body","#tab_box_content7").children("tr").size();
			if(size>0){
				$("#assign_body","#tab_box_content7").children("tr").remove();
			}
			var wh_body1 = $("#assign_body","#tab_box_content7")[0];
			if (retObj != undefined) {
				for (var i = 0; i < retObj.length; i++) {
					var columnsObj ;
					$("input[type='checkbox']", "#queryRetTable").each(function(){
						if(this.checked){
							columnsObj = this.parentNode.parentNode.cells;
						}
					});
					var newTr = wh_body1.insertRow();
					newTr.id = retObj[i].repair_info;
					newTr.onclick = function(){
						setGl2(this, 'tab_box_content7');
					}
					//newTr.ondblclick=function(){toEdit();}
					newTr.insertCell().innerHTML = "<input type='checkbox' id='repair_info"+retObj[i].repair_info+"' value='"+retObj[i].repair_info+"'/>";
				
					newTr.insertCell().innerText = columnsObj(3).innerText;
					newTr.insertCell().innerText = columnsObj(4).innerText;
					newTr.insertCell().innerText = columnsObj(5).innerText;
					newTr.insertCell().innerText = columnsObj(6).innerText;
					newTr.insertCell().innerText = retObj[i].repairtype;
					newTr.insertCell().innerText = retObj[i].repairitem;
					newTr.insertCell().innerText = retObj[i].repair_detail;
					newTr.insertCell().innerText = retObj[i].repair_start_date;
					newTr.insertCell().innerText = retObj[i].repair_end_date;
					newTr.insertCell().innerText = retObj[i].human_cost;
					newTr.insertCell().innerText = retObj[i].material_cost;
					newTr.insertCell().innerText = retObj[i].repairer;
					newTr.insertCell().innerText = retObj[i].accepter;
					newTr.insertCell().innerText = retObj[i].record_status;
					
				}
			}
		}
		
		$("#assign_body>tr:odd>td:odd",'#tab_box_content7').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#tab_box_content7').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#tab_box_content7').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#tab_box_content7').addClass("even_even");
    
	}
	function test(){
		alert("test");
	}
	function toAddWHBY(){   
		var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }
	 	popWindow("<%=contextPath%>/rm/dm/device-xd/DEVICE_REPAIR_INFO_UNPRO.jsp?ids="+ids,'950:680'); 
	 	
	 }
    //修改界面
     function toEditWHBY(obj){ 
     	if(obj==undefined){
     		obj=$("input[type='checkbox'][id^='repair_info']", "#whMap>tbody");	//$("#wh_body :checked")[0].parentNode.parentNode;
     	}
		if(obj == undefined)
			return;
		var repairinfoval = null;
		for(var index=0;index<obj.length;index++){
			if(obj[index].checked == true){
				repairinfoval = obj[index].value;
				break;
			}
		}
     	var ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
    	popWindow("<%=contextPath%>/rm/dm/device-xd/DEVICE_REPAIR_INFO_UNPRO.jsp?ids="+ids+"&repair_info="+repairinfoval,'950:680'); 
	 } 
	 //查看维修明细界面
     function toView(obj){ 
     	if(obj==undefined){
     		obj=$("input[type='checkbox'][id^='repair_info']", "#whMap>tbody");	//$("#wh_body :checked")[0].parentNode.parentNode;
     	}
		if(obj == undefined)
			return;
		var repairinfoval = null;
		for(var index=0;index<obj.length;index++){
			if(obj[index].checked == true){
				repairinfoval = obj[index].value;
				break;
			}
		}
     	var ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
    	popWindow("<%=contextPath%>/rm/dm/device-xd/repairdetailunpro.jsp?ids="+ids+"&repair_info="+repairinfoval,'950:680'); 
	 } 
	
	 function toDeleteWHBY(obj){
		 if(obj==undefined){
	     		obj=$("input[type='checkbox'][id^='repair_info']", "#whMap>tbody");	//$("#wh_body :checked")[0].parentNode.parentNode;
	     	}
			if(obj == undefined)
				return;
			var repairinfoval = null;
			for(var index=0;index<obj.length;index++){
				if(obj[index].checked == true){
					repairinfoval = obj[index].value;
					break;
				}
			}
 		ids = getSelIds('rdo_entity_id');
 		
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
			    
			if(confirm('确定要删除吗?')){  
				var retObj = jcdpCallService("DevCommInfoSrv", "deleteQZBY", "deviceId="+repairinfoval);
				wxby(ids);
			}

	}
	
	/**
	 * 设备事故****************************************************************************************************************************
	 */
	function sggl(shuaId){
		if(shuaId!=null){
			  var querySql="select (select coding_name from comm_coding_sort_detail where coding_code_id=a.accident_properties)as accident_properties1,";  
		        querySql+="  (select coding_name from comm_coding_sort_detail where coding_code_id=a.accident_grade)as accident_grade1,";  
		        querySql+="  i.org_abbreviation as owning_org_name,a.*,eq.operator_name ";  
		         querySql+=" from BGP_COMM_DEVICE_ACCIDENT_INFO a left join Gms_Device_Account_Unpro b on a.DEVICE_ACCOUNT_ID=b.dev_acc_id   ";
		        querySql+="  left join (select * from (select device_account_id,wmsys.wm_concat(operator_name) over(partition by device_account_id) as operator_name from gms_device_equipment_operator where bsflag='0' )a group by a.device_account_id,a.operator_name ) eq on eq.device_account_id=a.device_account_id";   
		     querySql+="  left join comm_org_information i on b.usage_org_id = i.org_id where a.device_account_id='"+shuaId+"' order by a.accident_time desc  ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj = queryRet.datas;
			var size = $("#assign_body","#tab_box_content9").children("tr").size();
			if(size>0){
				$("#assign_body","#tab_box_content9").children("tr").remove();
			}
			var sg_body1 = $("#assign_body","#tab_box_content9")[0];
			if (retObj != undefined) {
				for (var i = 0; i < retObj.length; i++) {
					var columnsObj ;
					$("input[type='checkbox']", "#queryRetTable").each(function(){
						if(this.checked){
							columnsObj = this.parentNode.parentNode.cells;
						}
					});
					var newTr = sg_body1.insertRow();
					newTr.id = retObj[i].accident_info_id;
					newTr.onclick = function(){
						setGl2(this, 'tab_box_content9');
					}
					newTr.insertCell().innerHTML="<input type=checkbox>";
					var newTd2=newTr.insertCell();
					newTd2.innerText=columnsObj(3).innerText; 
					var newTd3=newTr.insertCell();
					newTd3.innerText=columnsObj(4).innerText; 
					var newTd4=newTr.insertCell();
					newTd4.innerText=columnsObj(5).innerText; 
					var newTd5=newTr.insertCell();
					newTd5.innerText=columnsObj(6).innerText; 
					var newTd6=newTr.insertCell();
					newTd6.innerText=retObj[i].accident_name;
					newTr.insertCell().innerText=retObj[i].owning_org_name;
					newTr.insertCell().innerText=retObj[i].operator_name;
					newTr.insertCell().innerText=retObj[i].accident_loss;
					newTr.insertCell().innerText=retObj[i].accident_grade1;
					newTr.insertCell().innerText=retObj[i].accident_charge_person;
					newTr.insertCell().innerText=retObj[i].accident_properties1;
					newTr.insertCell().innerText=retObj[i].accident_time;
				}
			}
		}
		$("#assign_body>tr:odd>td:odd",'#tab_box_content9').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#tab_box_content9').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#tab_box_content9').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#tab_box_content9').addClass("even_even");
	}
	//打开事故新增界面
	 function toAddSG(){   
		var ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
	    	alert("请先选中一条记录!");
	     	return;
	    }
	 	popWindow("<%=contextPath%>/rm/dm/device-xd/sgUnPro.jsp?ids="+ids); 
	 	
	 }

    //修改事故界面
     function toEditSG(obj){  
     	if(obj==undefined){
     		$("input[type='checkbox']", "#sgMap").each(function(){
     			if(this.checked){
     				obj = this.parentNode.parentNode;
     			}
     		});
     	}
     	var ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
    	popWindow("<%=contextPath%>/rm/dm/device-xd/sgUnPro.jsp?ids="+ids+"&accident_info_id="+obj.id); 
	  } 
	  function toDeleteSG(obj){
		  if(obj==undefined){
	     		$("input[type='checkbox']", "#sgMap").each(function(){
	     			if(this.checked){
	     				obj = this.parentNode.parentNode;
	     			}
	     		});
	     	}
 		ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
			    
			if(confirm('确定要删除吗?')){  
				var retObj = jcdpCallService("DevCommInfoSrv", "deleteSG", "deviceId="+obj.id);
				sggl(ids);
			}

	}
	  /*****************************************************************************************************************************
	   * 公共复选框选择
	   */
	  function setGl2(obj,divid){
		var tableobj = obj.parentNode;
    	$("#"+tableobj.id+">tr:odd>td:odd","#"+divid).css("background-color","#e3e3e3");
		$("#"+tableobj.id+">tr:even>td:odd","#"+divid).css("background-color","#ebebeb");
		$("#"+tableobj.id+">tr:odd>td:even","#"+divid).css("background-color","#f6f6f6");
		$("#"+tableobj.id+">tr:even>td:even","#"+divid).css("background-color","#FFFFFF");
		$("input[type='checkbox']","#"+divid).removeAttr("checked");
    	var columnsObj=obj.cells;
    	columnsObj[0].childNodes[0].checked=true;
    	for(var i=0;i<columnsObj.length;i++){
    		columnsObj[i].style.background="#ffc580";
    	}
    }
	/**
	 * 设备检查************************************************************************************************************************
	 */
	function sbjc(shuaId){
		if (shuaId != null) {
			var querySql = "select (select coding_name from comm_coding_sort_detail where coding_code_id=a.inspection_type)as inspection_type1,";
			querySql += "b.owning_org_name,a.*, doc.file_name,doc.ucm_id ";
			querySql += "from BGP_COMM_DEVICE_INSPECTION a left join Gms_Device_Account_Unpro b on a.DEVICE_ACCOUNT_ID=b.dev_acc_id left join bgp_doc_gms_file doc on doc.relation_id=a.inspection_id ";
			querySql += "where DEVICE_ACCOUNT_ID='" + shuaId + "' order by a.inspection_date desc";
			var queryRet = syncRequest('Post', '<%=contextPath%>' + appConfig.queryListAction, 'pageSize=100000&querySql=' + querySql);
			retObj = queryRet.datas;
			
			var size = $("#assign_body", "#tab_box_content10").children("tr").size();
			if (size > 0) {
				$("#assign_body", "#tab_box_content10").children("tr").remove();
			}
			var jc_body1 = $("#assign_body", "#tab_box_content10")[0];
			if (retObj != undefined) {
				for (var i = 0; i < retObj.length; i++) {
					var columnsObj ;
					$("input[type='checkbox']", "#queryRetTable").each(function(){
						if(this.checked){
							columnsObj = this.parentNode.parentNode.cells;
						}
					});
					var newTr = jc_body1.insertRow()
					newTr.id = retObj[i].inspection_id+":"+retObj[i].ucm_id;
					newTr.onclick = function(){
						setGl2(this, 'tab_box_content10');
					}
					newTr.insertCell().innerHTML = "<input type='checkbox'>";
					
					var newTd2 = newTr.insertCell();
					newTd2.innerText = columnsObj(3).innerText;
					var newTd3 = newTr.insertCell();
					newTd3.innerText = columnsObj(4).innerText;
					var newTd4 = newTr.insertCell();
					newTd4.innerText = columnsObj(5).innerText;
					var newTd5 = newTr.insertCell();
					newTd5.innerText = columnsObj(6).innerText;
					newTr.insertCell().innerText = retObj[i].owning_org_name;
					//newTr.insertCell().innerText="暂无";
					newTr.insertCell().innerText = retObj[i].inspection_type1;
					newTr.insertCell().innerText = retObj[i].inspector;
					newTr.insertCell().innerText = retObj[i].inspection_date;
					newTr.insertCell().innerText = retObj[i].charge_person;
					newTr.insertCell().innerText = retObj[i].file_name;
				}
			}
		}
		$("#assign_body>tr:odd>td:odd", '#tab_box_content10').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even", '#tab_box_content10').addClass("odd_even");
		$("#assign_body>tr:even>td:odd", '#tab_box_content10').addClass("even_odd");
		$("#assign_body>tr:even>td:even", '#tab_box_content10').addClass("even_even");
	}
		//打开新增界面
	 function toAddSBJC(){   
		var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }
	 	popWindow("<%=contextPath%>/rm/dm/device-xd/jcUnPro.jsp?ids="+ids,'800:700'); 
	 }
	  function toDeleteJC(obj){
		  var inspectionId ;
	     	if(obj==undefined){
	     		$("input[type='checkbox']", "#jcMap").each(function(){
	     			if(this.checked){
	     				obj = this.parentNode.parentNode;
	     				inspectionId = obj.id.split(":")[0];
	     			}
	     		});
	     	}
	     	var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }
				if(confirm('确定要删除吗?')){  
					var retObj = jcdpCallService("DevCommInfoSrv", "deleteJC", "deviceId="+inspectionId);
					sbjc(ids);
				}

		}
	 //下载文档
	 function toDownload(){
		 var ids;
		 var obj
		 if(obj==undefined){
	     		$("input[type='checkbox']", "#jcMap").each(function(){
	     			if(this.checked){
	     				obj = this.parentNode.parentNode;
	     				ids = obj.id;
	     			}
	     		});
	     	}
		    if(ids.split(":").length > 2){
		    	alert("请只选中一条记录");
		    	return;
		    }
		    var file_id = ids.split(":")[0];
		    var ucm_id = ids.split(":")[1];
		    if(ucm_id != ""){
		    	window.location = "<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucm_id;
		    }else{
		    	alert("该条记录没有文档");
		    	return;
		    }
		    
		}
    //修改界面
     function toEditJC(obj){  
        var inspectionId ;
     	if(obj==undefined){
     		$("input[type='checkbox']", "#jcMap").each(function(){
     			if(this.checked){
     				obj = this.parentNode.parentNode;
     				inspectionId = obj.id.split(":")[0];
     			}
     		});
     	}
     	var ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
    	popWindow("<%=contextPath%>/rm/dm/device-xd/jcUnPro.jsp?ids="+ids+"&inspection_id="+inspectionId); 
	  } 
	  /*
	  function toDeleteSG(){
 		ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
			    
			if(confirm('确定要删除吗?')){  
				var retObj = jcdpCallService("DevCommInfoSrv", "deleteUpdate", "deviceId="+ids);
				
				queryData(cruConfig.currentPage);
				
			}

	}
	*/
	
	
	/**
	 * 日常检查************************************************************************************************************************
	 */
	function rcjc(shuaId){
		if (shuaId != null) {
			debugger;
			var querySqlType = "select dui.dev_type from gms_device_account_unpro dui where dui.bsflag='0' and dui.dev_acc_id='"+shuaId+"'"; 
			var queryRetType = syncRequest('Post', '<%=contextPath%>' + appConfig.queryListAction, 'pageSize=100000&querySql=' + querySqlType);
			retObjType = queryRetType.datas;
			if (retObjType != undefined) {
				var dev_type = retObjType[0].dev_type;
				
				
				String.prototype.startWith = function(compareStr){
				    return this.indexOf(compareStr) == 0;
				}
				var type="";
				
				if(dev_type.startWith('S08')){//运输车辆
					type="3";
				}else if(dev_type.startWith('S0623')){//可控震源
					type="1";
				}else if(dev_type.startWith('S060102')){//轻便钻机
					type="2";
				}else if(dev_type.startWith('S060101')||dev_type.startWith('S060199')){//车装钻机
					type="4";
				}
			
				var querySql = "select rownum nums, n.devinspectioin_id,n.inspectioin_no,n.inspectioin_people,n.inspectioin_time,n.suggestion,n.project_info_no,n.create_time,n.dev_acc_id,n.creater,n.inspectioin_update_time  from  GMS_DEVICE_INSPECTIOIN n  where n.bsflag='0' and n.dev_acc_id='" + shuaId + "' and n.type='"+type+"' order by n.create_time  desc "; 
				var queryRet = syncRequest('Post', '<%=contextPath%>' + appConfig.queryListAction, 'pageSize=100000&querySql=' + querySql);
				retObj = queryRet.datas;
				
				var size = $("#assign_body", "#tab_box_content15").children("tr").size();
				if (size > 0) {
					$("#assign_body", "#tab_box_content15").children("tr").remove();
				}
				var jc_body1 = $("#assign_body", "#tab_box_content15")[0];
				if (retObj != undefined) {
					for (var i = 0; i < retObj.length; i++) {
					 
						var newTr = jc_body1.insertRow()
						newTr.id = retObj[i].devinspectioin_id;
					 
						newTr.insertCell().innerText = i+1;
						newTr.insertCell().innerText = retObj[i].creater;
						newTr.insertCell().innerText = retObj[i].inspectioin_time;
						newTr.insertCell().innerText = retObj[i].inspectioin_update_time;
						newTr.insertCell().innerText = retObj[i].create_time;
						
						newTr.insertCell().innerHTML = "<a   onClick='openW(\""+retObj[i].devinspectioin_id+"\",\""+type+"\")'>查看</a>";
					}
				}
			}
		}
		$("#assign_body>tr:odd>td:odd", '#tab_box_content15').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even", '#tab_box_content15').addClass("odd_even");
		$("#assign_body>tr:even>td:odd", '#tab_box_content15').addClass("even_odd");
		$("#assign_body>tr:even>td:even", '#tab_box_content15').addClass("even_even");
	}
	
	
	 function openW(ids,type){ 
		 
		 if(type=="3"){//运输车辆
			 popWindow('<%=contextPath%>/rm/dm/device-xd/searchRcjcYscl.jsp?ids='+ids,'1000:760');
		 }else if(type=="1"){//可控震源
			 popWindow('<%=contextPath%>/rm/dm/device-xd/searchRcjcKkzy.jsp?ids='+ids,'1000:760');
		 }else if(type=="2"){//轻便钻机
			 popWindow('<%=contextPath%>/rm/dm/device-xd/searchRcjcQbzj.jsp?ids='+ids,'1000:760');
		 }else if(type=="4"){//车装钻机
			 popWindow('<%=contextPath%>/rm/dm/device-xd/searchRcjcCzzj.jsp?ids='+ids,'1000:760');
		 }
	 }
	 
	 
	 
	 /**
		 * 状态监测记录************************************************************************************************************************
		 */
		function ztjcjl(shuaId){
			if (shuaId != null) {
				var querySql = " select rownum nums,  gw.devwork_id,gw.devwork_record,gw.devwork_time,gw.dwork_speed,gw.dwork_oil_pressure,gw.dwork_water_temp,  gw.devwork_no,gw.dwork_drill_one,gw.dwork_vibrate_one,gw.dwork_drill_two,gw.dwork_vibrate_two     from  GMS_DEVICE_WORK_INFORMATION  gw  where gw.bsflag='0' and gw.dev_acc_id='" + shuaId + "' order by gw.create_time  desc  "; 
				var queryRet = syncRequest('Post', '<%=contextPath%>' + appConfig.queryListAction, 'pageSize=100000&querySql=' + querySql);
				retObj = queryRet.datas;
				
				var size = $("#assign_body", "#tab_box_content16").children("tr").size();
				if (size > 0) {
					$("#assign_body", "#tab_box_content16").children("tr").remove();
				}
				var jc_body1 = $("#assign_body", "#tab_box_content16")[0];
				if (retObj != undefined) {
					for (var i = 0; i < retObj.length; i++) {
					 
						var newTr = jc_body1.insertRow()
						newTr.id = retObj[i].devwork_id;
					 
						newTr.insertCell().innerText = i+1; 
						newTr.insertCell().innerText = retObj[i].devwork_no;
						newTr.insertCell().innerText = retObj[i].devwork_record;
						newTr.insertCell().innerText = retObj[i].devwork_time;
						newTr.insertCell().innerText = retObj[i].dwork_speed;
						newTr.insertCell().innerText = retObj[i].dwork_oil_pressure;
						newTr.insertCell().innerText = retObj[i].dwork_water_temp;
						newTr.insertCell().innerText = retObj[i].dwork_drill_one;
						newTr.insertCell().innerText = retObj[i].dwork_drill_two;
						newTr.insertCell().innerText = retObj[i].dwork_vibrate_one;
						newTr.insertCell().innerText = retObj[i].dwork_vibrate_two;
					}
				}
			}
			$("#assign_body>tr:odd>td:odd", '#tab_box_content16').addClass("odd_odd");
			$("#assign_body>tr:odd>td:even", '#tab_box_content16').addClass("odd_even");
			$("#assign_body>tr:even>td:odd", '#tab_box_content16').addClass("even_odd");
			$("#assign_body>tr:even>td:even", '#tab_box_content16').addClass("even_even");
		}
	
	  /**
	 * 油水记录************************************************************************************************************************
	 */
	function ysjl(shuaId){
		if (shuaId != null) {
			var querySql="select tmp1.*,sum(oil_quantity) over(order by fill_date) as oil_sum_quantity, "+
			"sum(oil_total) over(order by fill_date) as oil_sum_total from ("+
			"select (select coding_name from comm_coding_sort_detail where coding_code_id=a.OIL_NAME)as OIL_NAME1,"+
			"(select coding_name from comm_coding_sort_detail where coding_code_id=a.OIL_MODEL)as OIL_MODEL1,"+
			"a.oil_info_id,a.device_account_id,a.fill_date,a.oil_unit,a.oil_quantity,a.oil_unit_price,a.oil_total,"+
			"'false' as checktype "+
			"from bgp_comm_device_oil_info a "+
			"left join gms_device_account_unpro b on a.device_account_id=b.dev_acc_id "+
			"where a.bsflag='0'  and a.device_account_id='"+shuaId+"' ) tmp1 order by tmp1.fill_date desc "
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			debugger;
			retObj = queryRet.datas;
			var size = $("#assign_body", "#tab_box_content11").children("tr").size();
			if (size > 0) {
				$("#assign_body", "#tab_box_content11").children("tr").remove();
			}
			var ys_body1 = $("#assign_body", "#tab_box_content11")[0];
			if (retObj != undefined) {
				for (var i = 0; i < retObj.length; i++) {
					var columnsObj ;
					$("input[type='checkbox']", "#queryRetTable").each(function(){
						if(this.checked){
							columnsObj = this.parentNode.parentNode.cells;
						}
					});
					var newTr=ys_body1.insertRow()
					newTr.id=retObj[i].oil_info_id;
					newTr.onclick=function(){setGl2(this, 'tab_box_content11');}
					newTr.ondblclick=function(){toEdit(this);}
					newTr.insertCell().innerHTML="<input type=checkbox  id='ys_info"+retObj[i].oil_info_id+"' value='"+retObj[i].oil_info_id+"'/>";
				
					var newTd2=newTr.insertCell();
					newTd2.innerText=columnsObj(3).innerText; 
					var newTd3=newTr.insertCell();
					newTd3.innerText=columnsObj(4).innerText; 
					var newTd=newTr.insertCell();
					newTd.innerText=columnsObj(5).innerText; 
					var newTd1=newTr.insertCell();
					newTd1.innerText=columnsObj(6).innerText; 
					//newTr.insertCell().innerText=columnsObj(9).innerText;//retObj[i].owning_org_name;
					//newTr.insertCell().innerText=retObj[i].project_name;
					
					newTr.insertCell().innerText=retObj[i].fill_date;
					newTr.insertCell().innerText=retObj[i].oil_name1+retObj[i].oil_model1;
					newTr.insertCell().innerText=retObj[i].oil_unit;
					newTr.insertCell().innerText=retObj[i].oil_unit_price;
					newTr.insertCell().innerText=retObj[i].oil_quantity;
					newTr.insertCell().innerText=retObj[i].oil_total;
					newTr.insertCell().innerText=retObj[i].oil_sum_quantity;
					newTr.insertCell().innerText=retObj[i].oil_sum_total;
					if (retObj[i].checktype == 'false') {
						document.getElementById("ys_info" + retObj[i].oil_info_id).disabled = false;
					}
					else if(retObj[i].checktype=='true'){
						document.getElementById("ys_info"+retObj[i].oil_info_id).disabled=true;	
					}	
				}
			}
		}
		$("#assign_body>tr:odd>td:odd", '#tab_box_content11').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even", '#tab_box_content11').addClass("odd_even");
		$("#assign_body>tr:even>td:odd", '#tab_box_content11').addClass("even_odd");
		$("#assign_body>tr:even>td:even", '#tab_box_content11').addClass("even_even");
	}
	//打开油水导入界面
    function toDRYS(){
	 	popWindow("<%=contextPath%>/rm/dm/device-xd/xlsimportpage.jsp?method=ys","800:350");
    }
		//打开新增界面
	 function toAddYS(){   
		var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }
	 	popWindow("<%=contextPath%>/rm/dm/device-xd/ypUnPro.jsp?ids="+ids); 
	 	
	 }

    //修改界面
     function toEditYS(obj){  
     	if(obj==undefined){
     		$("input[type='checkbox']", "#ysMap").each(function(){
     			if(this.checked){
     				obj = this.parentNode.parentNode;
     			}
     		});
     	}
     	var ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
    	popWindow("<%=contextPath%>/rm/dm/device-xd/ypUnPro.jsp?ids="+ids+"&oil_info_id="+obj.id); 
	  } 
	  function toDeleteYS(obj){
	  	if(obj==undefined){
     		obj=$("input[type='checkbox'][id^='ys_info']", "#ysMap>tbody");	//$("#wh_body :checked")[0].parentNode.parentNode;
     	}
		
		if(obj == undefined)
			return;
		var oil_info_id = null;
		var checktype;
		for(var index=0;index<obj.length;index++){
			if(obj[index].checked == true){
				oil_info_id = obj[index].value;
				checktype = obj[index].disabled;
				break;
			}
		}
		//alert(checktype)
		if(checktype==true){
			return;
		}
     	var ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
		
			    
			if(confirm('确定要删除吗?')){  
				var retObj = jcdpCallService("DevCommInfoSrv", "deleteYS", "oil_info_id="+oil_info_id);
				
				//queryData(cruConfig.currentPage);
				ysjl(ids);
			}
			

	}
	/**
	 * 定人定机************************************************************************************************************************
	 */
	function drdj(shuaId){
		if (shuaId != null) {
			var querySql="select  case when a.operator_id is not null then d.employee_name else a.operator_name end as employee_name,";
			querySql+="b.owning_org_name,a.* ";
			querySql+="from GMS_DEVICE_EQUIPMENT_OPERATOR a left join gms_device_account_unpro b on a.DEVICE_ACCOUNT_ID=b.dev_acc_id ";
			querySql+=" left join comm_human_employee d on a.OPERATOR_ID=d.employee_id where DEVICE_ACCOUNT_ID='"+shuaId+"'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj = queryRet.datas;
			
			var size = $("#assign_body", "#tab_box_content12").children("tr").size();
			if (size > 0) {
				$("#assign_body", "#tab_box_content12").children("tr").remove();
			}
			var dj_body1 = $("#assign_body", "#tab_box_content12")[0];
			if (retObj != undefined) {
				for (var i = 0; i < retObj.length; i++) {
					var columnsObj ;
					$("input[type='checkbox']", "#queryRetTable").each(function(){
						if(this.checked){
							columnsObj = this.parentNode.parentNode.cells;
						}
					});
					var newTr=dj_body1.insertRow()
					newTr.id=retObj[i].oil_info_id;
					newTr.onclick=function(){setGl2(this, 'tab_box_content12');}
					newTr.insertCell().innerHTML="<input type=checkbox>";
					var newTd1=newTr.insertCell();
					newTd1.innerText=columnsObj(2).innerText; 
					var newTd2=newTr.insertCell();
					newTd2.innerText=columnsObj(3).innerText; 
					var newTd3=newTr.insertCell();
					newTd3.innerText=columnsObj(4).innerText; 
					var newTd4=newTr.insertCell();
					newTd4.innerText=columnsObj(5).innerText; 
			
					newTr.insertCell().innerText=retObj[i].owning_org_name;
					newTr.insertCell().innerText=retObj[i].employee_name;
			
				}
			}
		}
		$("#assign_body>tr:odd>td:odd", '#tab_box_content12').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even", '#tab_box_content12').addClass("odd_even");
		$("#assign_body>tr:even>td:odd", '#tab_box_content12').addClass("even_odd");
		$("#assign_body>tr:even>td:even", '#tab_box_content12').addClass("even_even");
	}
		//打开新增界面
	 function toAddDJ(){
		    
		var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }
	 	popWindow("<%=contextPath%>/rm/dm/device-xd/djUnPro.jsp?ids="+ids);  
	 	
	 }

    //修改界面
     function toEditDJ(obj){  
     	if(obj==undefined){
     		$("input[type='checkbox']", "#djMap").each(function(){
     			if(this.checked){
     				obj = this.parentNode.parentNode;
     			}
     		});
     	}
     	var ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
    	popWindow("<%=contextPath%>/rm/dm/device-xd/djUnPro.jsp?ids="+ids+"&oil_info_id=111"); 
	  } 
	  function toDeleteDJ(){
 		ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
			    
			if(confirm('确定要删除吗?')){  
				var retObj = jcdpCallService("DevCommInfoSrv", "deleteUpdate", "deviceId="+ids);
				
				queryData(cruConfig.currentPage);
				
			}

	}
	
	/**
	 * 设备考勤************************************************************************************************************************
	 */
	function sbkq(shuaId){
		if (shuaId != null) {
			 retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfoKq", "deviceId="+shuaId);
			
			var size = $("#assign_body", "#tab_box_content8").children("tr").size();
			if (size > 0) {
				$("#assign_body", "#tab_box_content8").children("tr").remove();
			}
			var kq_body1 = $("#assign_body", "#tab_box_content8")[0];
			if (retObj.group != undefined) {
				for(var i=0;i<retObj.group.length;i++){
					var columnsObj ;
					$("input[type='checkbox']", "#queryRetTable").each(function(){
						if(this.checked){
							columnsObj = this.parentNode.parentNode.cells;
						}
					});
					str="device_acc_id="+retObj.device_acc_id+"&ye="+retObj.group[i].year+"&me="+retObj.group[i].month;
					var newTr=kq_body1.insertRow()
					newTr.lin=str;
					newTr.onclick=function(){setGl2(this, 'tab_box_content8');}
					newTr.ondblclick=function(){getdatekq(this);}
					newTr.insertCell().innerHTML="<input type=checkbox>";
					
					
					var newTd2=newTr.insertCell();
					newTd2.innerText=columnsObj(3).innerText; 
					var newTd3=newTr.insertCell();
					newTd3.innerText=columnsObj(4).innerText; 
					var newTd4=newTr.insertCell();
					newTd4.innerText=columnsObj(5).innerText;
					var newTd5=newTr.insertCell();
					newTd5.innerText=columnsObj(6).innerText;
					var newTd8=newTr.insertCell();
					newTd8.innerText=columnsObj(7).innerText;
					var newTd6=newTr.insertCell();
					newTd6.innerText=retObj.group[i].year+"-"+retObj.group[i].month;
					var newTd7=newTr.insertCell();					
					newTd7.innerHTML="<a lin="+str+" onclick=getdatekq(this);><img src=<%=contextPath%>/images/calendar.gif /></a>";
				}
			}
		}
		$("#assign_body>tr:odd>td:odd", '#tab_box_content8').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even", '#tab_box_content8').addClass("odd_even");
		$("#assign_body>tr:even>td:odd", '#tab_box_content8').addClass("even_odd");
		$("#assign_body>tr:even>td:even", '#tab_box_content8').addClass("even_even");
	}
	function getdatekq(obj){
    var dev_appdet_id;
	var ye;
	var me;
	var vall=obj.lin.split("&");
	for(var i=0;i<vall.length;i++){
		var temp= vall[i].split("=");
		if(temp[0]=="device_acc_id"){
			dev_appdet_id= temp[1];
		}
		if(temp[0]=="ye"){
			ye= temp[1];
		}
		if(temp[0]=="me"){
			me= temp[1];
		}
	}
    	var querySql="select to_char(a.timesheet_date,'yyyy') as Year,to_char(a.timesheet_date,'mm') as month,to_char(a.timesheet_date,'dd') as day,a.* from BGP_COMM_DEVICE_TIMESHEET a where a.bsflag='0' and a.device_account_id='"+dev_appdet_id+"' and to_char(a.timesheet_date,'yyyy')='"+ye+"' and to_char(a.timesheet_date,'mm')='"+me+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
		var basedatas = queryRet.datas;
		
		calendar1(basedatas,'kqcallback');
		
    }
    function kqcallback(obj){
		if (confirm('确定要删除吗?')) {
			var ids = getSelIds('rdo_entity_id');
			var retObj = jcdpCallService("DevCommInfoSrv", "deleteKQ", "deviceId="+ids+"&date="+obj);
			queryData(cruConfig.currentPage);
		}
    	
		
    }
    //打开考勤的导入界面
    function toDRKQ(){
	 	popWindow("<%=contextPath%>/rm/dm/device-xd/xlsimportpage.jsp?method=kq","800:350");
    }
	//打开新增界面
	function toAddKQ(){
	 	popWindow("<%=contextPath%>/rm/dm/device-xd/kqUnPro.jsp","1024:700");  
	}
    //修改界面
     function toEditKQ(obj){  
     	if(obj==undefined){
     		$("input[type='checkbox']", "#kqMap").each(function(){
     			if(this.checked){
     				obj = this.parentNode.parentNode;
     			}
     		});
     	}
     	var ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
    	popWindow("<%=contextPath%>/rm/dm/device-xd/kq.jsp?ids="+ids+"&oil_info_id=111"); 
	  } 
     function toDeleteKQ(obj){
  		ids = getSelIds('rdo_entity_id');
 		    if(ids==''){ alert("请先选中一条记录!");
 		     	return;
 		    }	
 	    if(obj==undefined){
      		$("input[type='checkbox']", "#kqMap").each(function(){
      			if(this.checked){
      				obj = this.parentNode.parentNode;
      			}
      		});
      	}
 	    var vall=obj.lin.split("&");
 	    var ye;
 		var me;
 		for(var i=0;i<vall.length;i++){
 			var temp= vall[i].split("=");
 			if(temp[0]=="device_acc_id"){
 				dev_appdet_id= temp[1];
 			}
 			if(temp[0]=="ye"){
 				ye= temp[1];
 			}
 			if(temp[0]=="me"){
 				me= temp[1];
 			}
 		}  
 		if(confirm('确定要删除吗?')){  
 			var retObj = jcdpCallService("DevCommInfoSrv", "deleteUpdateKQ", "deviceId="+ids+"&ye="+ye+"&me="+me);
 		sbkq(ids);
 		}
 	}
	/**
	 * 保养计划************************************************************************************************************************
	 */
	function byjh(shuaId){
		if (shuaId != null) {
			var querySql="select * from GMS_DEVICE_MAINTENANCE_PLAN plan  ";
			querySql+="left join gms_device_account_unpro dui on dui.dev_acc_id=plan.dev_acc_id ";
			querySql+="where plan.dev_acc_id='"+shuaId+"' ";
			querySql+=" order by plan.plan_date";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj = queryRet.datas;
			var size = $("#assign_body", "#tab_box_content14").children("tr").size();
			if (size > 0) {
				$("#assign_body", "#tab_box_content14").children("tr").remove();
			}
			var jh_body1 = $("#assign_body", "#tab_box_content14")[0];
			if (retObj != undefined) {
				for (var i = 0; i < retObj.length; i++) {
					var columnsObj ;
					$("input[type='checkbox']", "#queryRetTable").each(function(){
						if(this.checked){
							columnsObj = this.parentNode.parentNode.cells;
						}
					});
					var newTr=jh_body1.insertRow();
					newTr.id=retObj[i].maintenance_id;
					var newTd2=newTr.insertCell();
					newTd2.innerText=columnsObj(3).innerText; 
					var newTd3=newTr.insertCell();
					newTd3.innerText=columnsObj(4).innerText; 
					newTr.insertCell().innerText=retObj[i].plan_date;
				}
			}
		}
		$("#assign_body>tr:odd>td:odd", '#tab_box_content14').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even", '#tab_box_content14').addClass("odd_even");
		$("#assign_body>tr:even>td:odd", '#tab_box_content14').addClass("even_odd");
		$("#assign_body>tr:even>td:even", '#tab_box_content14').addClass("even_even");
	}
	
	//打开保养计划新增界面
	 function toAddbyjh(){   
		var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }
	 	popWindow("<%=contextPath%>/rm/dm/device-xd/dev_byjh.jsp?ids="+ids); 
	 }
		//打开保养计划修改界面
	 function toEditbyjh(){   
		var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }
	 	popWindow("<%=contextPath%>/rm/dm/device-xd/dev_byjh.jsp?ids="+ids); 
	 	
	 }
	
	
	 /**
	 * 运转记录************************************************************************************************************************
	 */
	function yzjl(shuaId){
		if (shuaId != null) {
			var querySql="select t.operation_info_id,t.dev_acc_id,t.modify_date,t.mileage,"+
				"sum(t.mileage) over (order by t.modify_date) as mileage_total,t.drilling_footage,"+
				"sum(t.drilling_footage) over (order by t.modify_date) as drilling_footage_total,"+
				"t.work_hour,sum(t.work_hour) over (order by t.modify_date) as work_hour_total from GMS_DEVICE_OPERATION_INFO t";
			
			querySql+=" where dev_acc_id='"+shuaId+"' order by t.modify_date desc ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj = queryRet.datas;
			
			var size = $("#assign_body", "#tab_box_content13").children("tr").size();
			if (size > 0) {
				$("#assign_body", "#tab_box_content13").children("tr").remove();
			}
			var ys_body1 = $("#assign_body", "#tab_box_content13")[0];
			if (retObj != undefined) {
				for (var i = 0; i < retObj.length; i++) {
					var columnsObj ;
					$("input[type='checkbox']", "#queryRetTable").each(function(){
						if(this.checked){
							columnsObj = this.parentNode.parentNode.cells;
						}
					});
					var newTr=ys_body1.insertRow()
					newTr.id=retObj[i].operation_info_id;
					newTr.onclick=function(){setGl2(this, 'tab_box_content13');}
					newTr.insertCell().innerHTML="<input type=checkbox id='operation_info_id"+retObj[i].operation_info_id+"' value='"+retObj[i].operation_info_id+"'>";
				
				
					var newTd2=newTr.insertCell();
					newTd2.innerText=columnsObj(3).innerText; 
					var newTd3=newTr.insertCell();
					newTd3.innerText=columnsObj(4).innerText; 
					var newTd4=newTr.insertCell();
					newTd4.innerText=columnsObj(5).innerText;
					var newTd5=newTr.insertCell();
					newTd5.innerText=columnsObj(6).innerText;
					var newTd6=newTr.insertCell();
					newTd6.innerText=columnsObj(7).innerText;
				
					newTr.insertCell().innerText=retObj[i].modify_date;
					newTr.insertCell().innerText=retObj[i].mileage;
					newTr.insertCell().innerText=retObj[i].mileage_total;
					newTr.insertCell().innerText=retObj[i].drilling_footage;
					newTr.insertCell().innerText=retObj[i].drilling_footage_total;
					newTr.insertCell().innerText=retObj[i].work_hour;
					newTr.insertCell().innerText=retObj[i].work_hour_total;
				}
			}
		}
		$("#assign_body>tr:odd>td:odd", '#tab_box_content13').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even", '#tab_box_content13').addClass("odd_even");
		$("#assign_body>tr:even>td:odd", '#tab_box_content13').addClass("even_odd");
		$("#assign_body>tr:even>td:even", '#tab_box_content13').addClass("even_even");
	}
	//打开运转的导入界面
    function toDRYZ(){
	 	popWindow("<%=contextPath%>/rm/dm/device-xd/xlsimportpage.jsp?method=yz","800:350");
    }
	//打开新增界面
	 function toAddYZ(){   
		var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }
	 	popWindow("<%=contextPath%>/rm/dm/device-xd/yzUnPro.jsp?ids="+ids); 
		queryData(cruConfig.currentPage);
	 }

    //修改界面
     function toEditYZ(obj){  
		if(obj==undefined){
     		obj=$("input[type='checkbox'][id^='operation_info_id']", "#yzMap>tbody");
     	}
		if(obj == undefined)
			return;
		var operation_info_id = null;
		for(var index=0;index<obj.length;index++){
			if(obj[index].checked == true){
				operation_info_id = obj[index].value;
				break;
			}
		}
		
     	var ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
		if (confirm("确认删除？")) {
			var sql = "delete from GMS_DEVICE_OPERATION_INFO where operation_info_id='" + operation_info_id + "'";
			var path = cruConfig.contextPath + "/rad/asyncDelete.srq";
			var params = "deleteSql=" + sql;
			params += "&ids=";
			var retObject = syncRequest('Post', path, params);
			//refreshData();
			yzjl(ids);
		}
    	
	}
	function toDeleteYZ() {
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请先选中一条记录!");
			return;
		}

		if (confirm('确定要删除吗?')) {
			var retObj = jcdpCallService("DevCommInfoSrv", "deleteUpdate",
					"deviceId=" + ids);

			queryData(cruConfig.currentPage);

		}

	}
	//提醒保养计划状态
	
	function alertinfo(info)
	{
		if(info=='red')
		{
			alert("该设备需要进行保养！");
			return;
		}
		if(info=='green')
		{
			alert("该设备保养状况正常！");
			return;
		}
		if(info=='yellow')
		{
			alert("该设备需要制定设备保养计划！");
			return;
		}
		
		
	}
	/**
	 * 延迟加载*****************************************************************************************************************************
	 * @param {Object} index
	 */
	function loaddata(ids, index) {

		selectedTagIndex = index;

		
		if (ids == "") {

			var ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				//			    alert("请先选中一条记录!");
				return;
			}
		}
		var currentid;
		$("input[type='checkbox'][name='selectedbox']").each(function() {
			if (this.checked) {
				currentid = this.value;
			}
		});
		if (index == 6)
			qzby(ids);
		else if (index == 7)
			wxby(ids);
		else if (index == 8)
			sbkq(ids);//设备考勤
		else if (index == 9)
			sggl(ids);
		else if (index == 10)
			sbjc(ids);
		else if (index == 11)
			ysjl(ids);
		else if (index == 12)
			drdj(ids);
		else if (index == 14)
			byjh(ids);
		else if (index == 13)
			yzjl(ids)
		else if (index == 15)
			rcjc(ids);
		else if (index == 16)
			ztjcjl(ids);
	}
	 function deviceDataAdd(){
			popWindow('<%=contextPath%>/rm/dm/device-xd/devAddUnPro.jsp?code','1200:600','设备导入');
			queryData(cruConfig.currentPage);
	 }
	 
		function toDelete(){
	 		ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
		     	return;
		    }
		    info = ids.split("~",-1);
		
			if(confirm('确定要返还吗?')){  
				var retObj = jcdpCallService("DevInsSrv", "deleteUpdate", "deviceId="+info[0]);
				queryData(cruConfig.currentPage);
			}
		}
	 
</script>

</html>