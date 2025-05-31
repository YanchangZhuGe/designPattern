<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgCode = user.getOrgCode();
	String orgId = user.getOrgId();
	String orgSubjectionId = user.getOrgSubjectionId();
	String scrape_apply_id = request.getParameter("scrape_apply_id");
	String userid=user.getSubOrgIDofAffordOrg();//所属单位隶属关系id
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<%@include file="/common/include/processresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>报废申请</title>
 <style type="text/css">
.pagination table{
	float:right;
}

.panel .inquire_item{
	text-align:right;
}
.inquire_form{
	width:180px;
}

.tab_line_height {
	border-color: #1C86EE;
 	border-style: dotted;
 	border-width: 2px;
	width:100%;
	line-height:24px;
	height:24px;
	color:#000;
	margin: 0;
    padding: 0;
}
.tab_line_height td {
	border-color: #1C86EE;
	border-style: dotted;
	line-height:24px;
	border-width: 1px;
	height:24px;
	white-space:nowrap;
	word-break:keep-all;
	margin: 0;
    padding: 0;
}
.panel .panel-body{
	font-size: 12px;
}
input,textarea{
	font-size: 12px;
}
</style> 
 </head>
 <body style="background:#fff" onload="refreshData('','','<%=scrape_apply_id%>')">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			    <td class="ali_cdn_name">报废申请名称</td>
			    <td class="ali_cdn_input">
			    	<input id="scrape_apply_name" name="scrape_apply_name" type="text" class="input_width" />
			    </td>
			       <td class="ali_cdn_name">报废申请单号</td>
			    <td class="ali_cdn_input">
			    	<input id="scrape_apply_no" name="scrape_apply_no" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td width="50%">&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAddScrapePage()'" title="新增"></auth:ListButton>
				<auth:ListButton functionId="" css="xg" event="onclick='toModifyScrapePage()'" title="修改"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelScrapePage()'" title="删除"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='toSumbitScrapeApp()'" title="提交"></auth:ListButton>
			    <!--<td width="2%"><img src="<%=contextPath%>/images/ck.png" onclick="toSeeScrapePage()" align="right" width="22" height="22" style="cursor:hand;" title="评审通过明细查看"/></td>
			    <td width="2%"><img src="<%=contextPath%>/images/ck_two.png" onclick="toTwoUnitsSeeScrapePage()" align="right" width="22" height="22" style="cursor:hand;" title="评审未通过信息查看"/></td>-->
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='scrape_apply_id_{scrape_apply_id}' name='scrape_apply_id'  idinfo='{scrape_apply_id}'>
			     	<td class="bt_info_odd" exp="<input type='radio' name='selectedbox' value='{scrape_apply_id}' id='selectedbox_{scrape_apply_id}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{scrape_apply_no}">报废申请单号</td>
					<td class="bt_info_odd" exp="{scrape_apply_name}">报废申请单名称</td>
					<td class="bt_info_even" exp="{employee_name}">申请人</td>
					<td class="bt_info_odd" exp="{org_name}">申请单位</td>
					<td class="bt_info_even" exp="{apply_date}">申请时间</td>
					<td class="bt_info_odd" exp="{apply_status}">状态</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">基本信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">评审通过明细</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,7)">评审不通过明细</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,8)">报废申请明细</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,2)">审批流程</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,14);byjh();">专家鉴定信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,15);">公司审批信息</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="scrapeMap" name="scrapeMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">设备报废单号：</td>
				      <td  class="inquire_form6" ><input id="scrape_apply_no" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">设备报废单名称：</td>
				      <td  class="inquire_form6"><input id="scrape_apply_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;申请单位：</td>
				      <td  class="inquire_form6"><input id="org_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				    <tr>
				      <td  class="inquire_item6">申请人：</td>
				      <td  class="inquire_form6"><input id="employee_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;申请时间：</td>
				      <td  class="inquire_form6"><input id="apply_date" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					    <td background="<%=contextPath%>/images/list_15.png">
						    <table width="100%" border="0" cellspacing="0" cellpadding="0">
							    <tr>
								    <td>&nbsp;</td>
								    <auth:ListButton functionId="" css="xz" event="onclick='exportDevData()'" title="导出该申请单设备"></auth:ListButton>
							    </tr>
							</table>
						</td>
					    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="20" /></td>
					  </tr>
					</table>
					<table id="dev_grid">
						<thead>
							<tr>
							  <th nowrap="false" data-options="field:'dev_type',align:'center',sortable:'true'" width="6%">设备编码</th>
						      <th nowrap="false" data-options="field:'dev_coding',align:'center',sortable:'true'" width="6%">设备编号</th>
						      <th nowrap="false" data-options="field:'asset_coding',align:'center',sortable:'true'" width="6%">资产编码</th>
						      <th nowrap="false" data-options="field:'dev_name',align:'center',sortable:'true'" width="6%">设备名称</th>
						      <th nowrap="false" data-options="field:'dev_model',align:'center',sortable:'true'" width="6%">规格型号</th>
						      <th nowrap="false" data-options="field:'license_num',align:'center',sortable:'true'" width="6%">牌照号</th>
						      <th nowrap="false" data-options="field:'producting_date',align:'center',sortable:'true'" width="6%">启用时间</th>
						      <th nowrap="false" data-options="field:'dev_date',align:'center',sortable:'true'" width="6%">折旧年限</th>
						      <th nowrap="false" data-options="field:'org_name',align:'center',sortable:'true'" width="6%">事业部</th>
						      <!-- <th nowrap="false" data-options="field:'jlb',align:'center',sortable:'true'" width="6%">经理部</th>
						      <th nowrap="false" data-options="field:'bm',align:'center',sortable:'true'" width="6%">部门/小队</th>
						      <th nowrap="false" data-options="field:'sl',align:'center',sortable:'true'" width="6%">数量</th> -->
						      <th nowrap="false" data-options="field:'asset_value',align:'center',sortable:'true'" width="6%">原值</th>
						      <th nowrap="false" data-options="field:'ljzj',align:'center',sortable:'true'" width="6%">累计折旧</th>
						      <th nowrap="false" data-options="field:'jzzb',align:'center',sortable:'true'" width="6%">减值准备</th>
						      <th nowrap="false" data-options="field:'net_value',align:'center',sortable:'true'" width="6%">净额</th>
						      <th nowrap="false" data-options="field:'scrape_type',align:'center',sortable:'true'" formatter='scrapeTypeCheck' width="6%">报废原因</th>
						      <th nowrap="false" data-options="field:'duty_unit',align:'center',sortable:'true'" width="6%">责任单位</th>
						      <th nowrap="false" data-options="field:'team_name',align:'center',sortable:'true'" width="6%">部门名称</th>
							</tr>
						</thead>
					</table>
				</div>
				<div id="tab_box_content7" name="tab_box_content7" idinfo="" class="tab_box_content" style="display:none">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					    <td background="<%=contextPath%>/images/list_15.png">
						    <table width="100%" border="0" cellspacing="0" cellpadding="0">
							    <tr>
								    <td>&nbsp;</td>
								    <auth:ListButton functionId="" css="xz" event="onclick='exportDevData()'" title="导出该申请单设备"></auth:ListButton>
							    </tr>
							</table>
						</td>
					    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="20" /></td>
					  </tr>
					</table>
					<table id="not_dev_grid">
						<thead>
							<tr>
							  <th nowrap="false" data-options="field:'dev_type',align:'center',sortable:'true'" width="6%">设备编码</th>
						      <th nowrap="false" data-options="field:'dev_coding',align:'center',sortable:'true'" width="6%">设备编号</th>
						      <th nowrap="false" data-options="field:'asset_coding',align:'center',sortable:'true'" width="6%">资产编码</th>
						      <th nowrap="false" data-options="field:'dev_name',align:'center',sortable:'true'" width="6%">设备名称</th>
						      <th nowrap="false" data-options="field:'dev_model',align:'center',sortable:'true'" width="6%">规格型号</th>
						      <th nowrap="false" data-options="field:'license_num',align:'center',sortable:'true'" width="6%">牌照号</th>
						      <th nowrap="false" data-options="field:'producting_date',align:'center',sortable:'true'" width="6%">启用时间</th>
						      <th nowrap="false" data-options="field:'dev_date',align:'center',sortable:'true'" width="6%">折旧年限</th>
						      <th nowrap="false" data-options="field:'org_name',align:'center',sortable:'true'" width="6%">事业部</th>
						      <!-- <th nowrap="false" data-options="field:'jlb',align:'center',sortable:'true'" width="6%">经理部</th>
						      <th nowrap="false" data-options="field:'bm',align:'center',sortable:'true'" width="6%">部门/小队</th>
						      <th nowrap="false" data-options="field:'sl',align:'center',sortable:'true'" width="6%">数量</th> -->
						      <th nowrap="false" data-options="field:'asset_value',align:'center',sortable:'true'" width="6%">原值</th>
						      <th nowrap="false" data-options="field:'ljzj',align:'center',sortable:'true'" width="6%">累计折旧</th>
						      <th nowrap="false" data-options="field:'jzzb',align:'center',sortable:'true'" width="6%">减值准备</th>
						      <th nowrap="false" data-options="field:'net_value',align:'center',sortable:'true'" width="6%">净额</th>
						      <th nowrap="false" data-options="field:'scrape_type',align:'center',sortable:'true'" formatter='scrapeTypeCheck' width="6%">报废原因</th>
						      <th nowrap="false" data-options="field:'duty_unit',align:'center',sortable:'true'" width="6%">责任单位</th>
						      <th nowrap="false" data-options="field:'team_name',align:'center',sortable:'true'" width="6%">部门名称</th>
							</tr>
						</thead>
					</table>
				</div>
				<div id="tab_box_content8" name="tab_box_content8" idinfo="" class="tab_box_content" style="display:none">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					    <td background="<%=contextPath%>/images/list_15.png">
						    <table width="100%" border="0" cellspacing="0" cellpadding="0">
							    <tr>
								    <td>&nbsp;</td>
								    <auth:ListButton functionId="" css="xz" event="onclick='exportDevData()'" title="导出该申请单设备"></auth:ListButton>
							    </tr>
							</table>
						</td>
					    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="20" /></td>
					  </tr>
					</table>
					<table id="dev_grid1"  >
						<thead>
							<tr>
							  <th nowrap="false" data-options="field:'dev_type',align:'center',sortable:'true'" width="6%">设备编码</th>
						      <th nowrap="false" data-options="field:'dev_coding',align:'center',sortable:'true'" width="6%">设备编号</th>
						      <th nowrap="false" data-options="field:'asset_coding',align:'center',sortable:'true'" width="6%">资产编码</th>
						      <th nowrap="false" data-options="field:'dev_name',align:'center',sortable:'true'" width="6%">设备名称</th>
						      <th nowrap="false" data-options="field:'dev_model',align:'center',sortable:'true'" width="6%">规格型号</th>
						      <th nowrap="false" data-options="field:'license_num',align:'center',sortable:'true'" width="6%">牌照号</th>
						      <th nowrap="false" data-options="field:'producting_date',align:'center',sortable:'true'" width="6%">启用时间</th>
						      <th nowrap="false" data-options="field:'dev_date',align:'center',sortable:'true'" width="6%">折旧年限</th>
						      <th nowrap="false" data-options="field:'org_name',align:'center',sortable:'true'" width="6%">事业部</th>
						      <!-- <th nowrap="false" data-options="field:'jlb',align:'center',sortable:'true'" width="6%">经理部</th>
						      <th nowrap="false" data-options="field:'bm',align:'center',sortable:'true'" width="6%">部门/小队</th>
						      <th nowrap="false" data-options="field:'sl',align:'center',sortable:'true'" width="6%">数量</th> -->
						      <th nowrap="false" data-options="field:'asset_value',align:'center',sortable:'true'" width="6%">原值</th>
						      <th nowrap="false" data-options="field:'ljzj',align:'center',sortable:'true'" width="6%">累计折旧</th>
						      <th nowrap="false" data-options="field:'jzzb',align:'center',sortable:'true'" width="6%">减值准备</th>
						      <th nowrap="false" data-options="field:'net_value',align:'center',sortable:'true'" width="6%">净额</th>
						      <th nowrap="false" data-options="field:'scrape_type',align:'center',sortable:'true'" formatter='scrapeTypeCheck' width="6%">报废原因</th>
						      <th nowrap="false" data-options="field:'duty_unit',align:'center',sortable:'true'" width="6%">责任单位</th>
						      <th nowrap="false" data-options="field:'team_name',align:'center',sortable:'true'" width="6%">部门名称</th>
							</tr>
						</thead>
					</table>
				</div>
			<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none;">
				<%-- <wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/> --%>
				<table id="startProcessInfo" width="100%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 0px;">
					<tr>
						<td class="bt_info_odd">业务环节</td>
						<td class="bt_info_even">审批情况</td>
						<td class="bt_info_odd">审批意见</td>
						<td class="bt_info_even">审批人</td>
						<td class="bt_info_odd">审批时间</td>
					</tr>
					<tbody id="spmx_body" name="spmx_body"></tbody>
				</table>
			</div>
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
			</div>
			<div id="tab_box_content14" name="tab_box_content14"
				class="tab_box_content" style="display: none;">
				<div style="overflow: auto">
					<table width="97%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height" style="background:url(<%=contextPath%>/images/list_15.png)">
						<tr align="right">
							<td class="ali_cdn_name"></td>
							<td class="ali_cdn_input"></td>
							<td class="ali_cdn_name"></td>
							<td class="ali_cdn_input"></td>
							<td>&nbsp;</td>
							<auth:ListButton functionId="" css="bc"	event="onclick='toEditEmp()'" title="保存"></auth:ListButton>
						</tr>
					</table>
				</div>
				<table id="planTab" width="100%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 0px;">
					<tr>
						<td class="bt_info_odd">鉴定小组组长</td>
 						<td class="bt_info_even">鉴定信息</td>
						<td class="bt_info_odd">鉴定小组组员</td>
					</tr>
					<tbody id="assign_body" name="assign_body"></tbody>
				</table>
			</div>
			<div id="tab_box_content15" name="tab_box_content15"
				class="tab_box_content" style="display: none;">
				<div style="overflow: auto">
					<table width="97%" border="0" cellspacing="0" cellpadding="0"
						class="tab_line_height" style="background:url(<%=contextPath%>/images/list_15.png)">
					</table>
				</div>
				<table id="planTab" width="100%" border="0" cellspacing="0"
					cellpadding="0" class="tab_info" style="margin-top: 0px;">
					<tr>
						<td class="bt_info_odd">业务环节</td>
						<td class="bt_info_even">审批情况</td>
						<td class="bt_info_odd">审批意见</td>
						<td class="bt_info_even">审批人</td>
						<td class="bt_info_odd">审批时间</td>
					</tr>
					<tbody id="gsspmx_body" name="gsspmx_body"></tbody>
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
	//初始化详细信息
	$("#dev_grid").datagrid({ 
		method:'post',
		rownumbers:true,
		toolbar:'',
		border:false,
		striped:true,
		singleSelect:true,
		pagination:true,
		fit:true,
		fitColumns:true,
		pageList:[100,300,500,1000,1500]
	});
	//初始化详细信息
	$("#dev_grid1").datagrid({ 
		method:'post',
		rownumbers:true,
		toolbar:'',
		border:false,
		striped:true,
		singleSelect:true,
		pagination:true,
		fit:true,
		fitColumns:true,pageList:[100,300,500,1000,1500]
	});
	//初始化未通过详细信息
	$("#not_dev_grid").datagrid({ 
		method:'post',
		rownumbers:true,
		toolbar:'',
		border:false,
		striped:true,
		singleSelect:true,
		pagination:true,
		fit:true,
		fitColumns:true,pageList:[100,300,500,1000,1500]
	});
})	

	var selectedTagIndex = 0;
	function getContentTab(obj,index) {
		selectedTagIndex = index;
		if(obj!=undefined){
			$("LI","#tag-container_3").removeClass("selectTag");
			var contentSelectedTag = obj.parentElement;
			contentSelectedTag.className ="selectTag";
		}
		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		var currentid = getSelIds('selectedbox');
		if(index == 1){
			var baseData;
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		  //设备信息显示
			$("#dev_grid").datagrid({
				url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=ScrapeSrv&JCDP_OP_NAME=getScrapeDetailInfo",
				queryParams:{'scrape_apply_id':ids}
			});
		}else if(index == 8){
		var baseData;
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		  //设备信息显示
			$("#dev_grid1").datagrid({
				url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=ScrapeSrv&JCDP_OP_NAME=getScrapeDetailInfoAll",
				queryParams:{'scrape_apply_id':ids}
			});
		}else if(index == 2){
			spmx();
		}else if(index == 3){
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid);
		}else if(index == 4){
			$("#remark").attr("src","<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+currentid);
		}else if(index == 5){
			$("#codeManager").attr("src","<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=5&relationId="+currentid);
		}else if(index == 7){
			var baseData;
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		  //设备信息显示
			$("#not_dev_grid").datagrid({
				url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=ScrapeSrv&JCDP_OP_NAME=getScrapeDetailNotGoInfo",
				queryParams:{'scrape_apply_id':ids}
			});
		 /* var retObj;
		   retObj = jcdpCallService("ScrapeSrv", "getScrapeDetailNotGoInfo", "scrape_apply_id="+ids);
		   basedatas = retObj.datas;
		  	$(filtermapid).empty();
		   if(basedatas!=undefined && basedatas.length>=1){
				//先清空
				var filtermapid = "#notdetailMap";
				$(filtermapid).empty();
				appendDataToDetailTab(filtermapid,basedatas);
				//设置当前标签页显示的主键
				$(filterobj).attr("idinfo",currentid);
			}else{
				var filtermapid = "#notdetailMap";
				$(filtermapid).empty();
				$(filterobj).attr("idinfo",currentid);
			}*/
		}else if(index == 15){
			gsspxx();//公司审批信息
		}
		$(filternotobj).hide();
		$(filterobj).show(); 
	}
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td>";
			innerHTML += "<td>"+datas[i].dev_type+"</td>";
			innerHTML += "<td>"+datas[i].dev_coding+"</td>";
			innerHTML += "<td>"+datas[i].asset_coding+"</td>";
			innerHTML += "<td>"+datas[i].dev_name+"</td>";
			innerHTML += "<td>"+datas[i].dev_model+"</td>";
			innerHTML += "<td>"+datas[i].license_num+"</td>";
			innerHTML += "<td>"+datas[i].producting_date+"</td>";
			innerHTML += "<td>"+datas[i].dev_date+"</td>";
			innerHTML += "<td>"+datas[i].org_name+"</td>";
			/* innerHTML += "<td>/</td>";
			innerHTML += "<td>/</td>";
			innerHTML += "<td>1</td>"; */
			innerHTML += "<td>"+datas[i].asset_value+"</td>";
			innerHTML += "<td>/</td>";
			innerHTML += "<td>/</td>";
			innerHTML += "<td>"+datas[i].net_value+"</td>";
			if(datas[i].scrape_type=="0"){
				innerHTML += "<td>正常报废</td>";
			}else if(datas[i].scrape_type=="1"){
				innerHTML += "<td>技术淘汰</td>";
			}else if(datas[i].scrape_type=="2"){
				innerHTML += "<td>毁损</td>";
			}else if(datas[i].scrape_type=="3"){
				innerHTML += "<td>盘亏</td>";
			}
			innerHTML += "<td>"+datas[i].duty_unit+"</td>";
			innerHTML += "<td>"+datas[i].team_name+"</td>";
			innerHTML += "</tr>";
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	$(document).ready(lashen);
</script>
 
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "ScrapeSrv";
	cruConfig.queryOp = "queryScrapeApplyList";
	var path = "<%=contextPath%>";

	
	function getdate() { 
		var   now=new   Date() 
		y=now.getFullYear() 
		m=now.getMonth()+1 
		d=now.getDate() 
		m=m <10? "0"+m:m 
		d=d <10? "0"+d:d 
		return   y + "-" + m + "-" + d ;
	}
	function searchDevData(){
		var scrape_apply_no = document.getElementById("scrape_apply_no").value;
		var scrape_apply_name = document.getElementById("scrape_apply_name").value;
		refreshData(scrape_apply_no, scrape_apply_name,'');
	}
	function clearQueryText(){
		document.getElementById("scrape_apply_no").value = "";
		document.getElementById("scrape_apply_name").value = "";
		refreshData("", "",'');
	}
    function refreshData(scrape_apply_no, scrape_apply_name, scrape_apply_id){
      	var temp = "";
		if(typeof scrape_apply_no!="undefined" && scrape_apply_no!=""){
			temp += "&scrape_apply_no="+scrape_apply_no;
		}
		if(typeof scrape_apply_name!="undefined" && scrape_apply_name!=""){
			temp += "&scrape_apply_name="+scrape_apply_name;
		}
		if(typeof scrape_apply_id!="undefined" && scrape_apply_id!=""){
			temp += "&scrape_apply_id="+scrape_apply_id;
		}
		cruConfig.submitStr = temp;	
		queryData(1);

	}
    function loadDataDetail(scrape_apply_id){
    	var retObj;
		if(scrape_apply_id!=null){
			 retObj = jcdpCallService("ScrapeSrv", "getScrapeInfo", "scrape_apply_id="+scrape_apply_id);
			
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("ScrapeSrv", "getScrapeInfo", "scrape_apply_id="+ids);
		}
	
		//选中这一条checkbox
		$("#selectedbox_"+retObj.deviceappMap.scrape_apply_id).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceappMap.scrape_apply_id+"']").removeAttr("checked");
		//给数据回填
		$("#scrape_apply_no","#scrapeMap").val(retObj.deviceappMap.scrape_apply_no);
		$("#scrape_apply_name","#scrapeMap").val(retObj.deviceappMap.scrape_apply_name);
		$("#apply_date","#scrapeMap").val(retObj.deviceappMap.apply_date);
		$("#employee_name","#scrapeMap").val(retObj.deviceappMap.employee_name);
		$("#org_name","#scrapeMap").val(retObj.deviceappMap.org_name);
		
		var curbusinesstype = "";
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
		//专家信息查询方法
		//byjh();
		//工作流信息
		var submitdate =getdate();
		var curbusinesstype="";
		var orgSubjectionId = '<%=orgSubjectionId%>';
		if(orgSubjectionId.length>=10){
			orgSubjectionId =orgSubjectionId.substring(0,10);
			if(orgSubjectionId=='C105005000'){//华北
				curbusinesstype="5110000181000000022";
			}else if(orgSubjectionId=='C105005001'){//新兴
				curbusinesstype="5110000181000000026";
			}else if(orgSubjectionId=='C105001002'){//新疆
				curbusinesstype="5110000181000000027";
			} 
		}
		if(curbusinesstype==""){
			if(orgSubjectionId.length>=7){
				orgSubjectionId =orgSubjectionId.substring(0,7);
				if(orgSubjectionId.substring(0,7)=='C105017'){//矿区
					curbusinesstype="5110000181000000024";
				}else if(orgSubjectionId=='C105007'){//大港
					curbusinesstype="5110000181000000025";
				}else {//其他默认22
					curbusinesstype="5110000181000000022";
				}
			}
		}
		/* if(orgSubjectionId=='C105005000'){//华北
			curbusinesstype="5110000181000000019";
		}else if(orgSubjectionId=='C105063'){//辽河
			curbusinesstype="5110000181000000020";
		}else if(orgSubjectionId=='C105005004'){//长庆
			curbusinesstype="5110000181000000021";
		}else if(orgSubjectionId=='C105006'){//装备物资处
			curbusinesstype="5110000181000000022";
		}else{
			curbusinesstype="5110000181000000003";
		}   */
    	processNecessaryInfo={        							//流程引擎关键信息
			businessTableName:"dms_scrape_apply",    			//置入流程管控的业务表的主表表明
			businessType:curbusinesstype,    				//业务类型 即为之前设置的业务大类
			businessId:scrape_apply_id,           			//业务主表主键值
			businessInfo:"报废申请审批流程>报废申请单名称:"+scrape_apply_name+";报废申请单号:"+scrape_apply_no+">",
			applicantDate:submitdate       						//流程发起时间
		};
		processAppendInfo={ 
			scrape_apply_id:scrape_apply_id
		};
		//loadProcessHistoryInfo();
    }
	function toAddScrapePage(){
		popWindow('<%=contextPath%>/dmsManager/scrape/scrapeApply_add.jsp','','新增报废申请');
	}
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
	function toDelScrapePage(){
		var baseData;
		var retObj;
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		 baseData = jcdpCallService("ScrapeSrv", "getScrapeState", "scrape_apply_id="+ids);
		
		if(baseData.deviceappMap.proc_status=='1')
		{
			alert("您选择的记录中存在状态为'待审批'的单据,不能删除!");
			return;
		}
			if(baseData.deviceappMap.proc_status=='3')
		{
			alert("您选择的记录中存在状态为'审批通过'的单据,不能删除!");
			return;
		}
		if(confirm('确定要删除吗?')){  
			retObj = jcdpCallService("ScrapeSrv", "deleteScrapeInfo", "scrape_apply_id="+ids);
			alert('删除成功!');
			refreshData();
		}
	}
	function toSumbitScrapeApp(){
			var retObj;
			var baseData;
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		  //判断所有设备 附件是否全部关联
		  var  baseData = jcdpCallService("ScrapeSrvNew", "getScrapeFileInfoNew", "scrape_apply_id="+ids);
		  if(baseData.msg!='false'){
	      alert(baseData.msg);
		  return;
		  }
		  //添加判断是否添加了专家
		    var empDataList = jcdpCallService("ScrapeSrv", "getScrapeEmpOpinionCount", "scrape_apply_id="+ids).deviceappList;
		  debugger;
		    if(empDataList!=null){
		    	if(empDataList.length>0){
		    		for(var i=0;i<empDataList.length;i++){
		    			if(empDataList[i].type=='01'){
		    				alert("正常报废、技术淘汰设备，专家未添加,不能提交！");
		    				return;
		    			}else{
		    				alert("盘亏、毁损设备，专家未添加,不能提交！");
		    				return;
		    			}
		    		}
		     	}
		    }
		    //添加判断是否完成模拟会签意见的操作
		    var count;
		    count = jcdpCallService("ScrapeSrv", "getScrapeEmpOpinion", "scrape_apply_id="+ids).count;
		    if(count>0){
		    	alert("还有"+count+"名专家未填写意见,不能提交！");
		     	return;
		    }
		baseData = jcdpCallService("ScrapeSrv", "getScrapeState", "scrape_apply_id="+ids);
		if(baseData.deviceappMap.proc_status=='1')
		{
			alert("您选择的记录中存在状态为'待审批'的单据,不能提交!");
			return;
		}
			if(baseData.deviceappMap.proc_status=='3')
		{
			alert("您选择的记录中存在状态为'审批通过'的单据,不能提交!");
			return;
		}
		    
		 retObj = jcdpCallService("ScrapeSrv", "getScrapeDetail", "scrape_apply_id="+ids);
		if(retObj.deviceappMap.result=='0')
		{
			alert("您选择的记录中未添加设备报废明细,不能提交!")
			return;
		}
		 //判断所有设备 事业部是否为空
		  var  baseData = jcdpCallService("ScrapeSrvNew", "getScrapeOrgIdIsNull", "scrape_apply_id="+ids);
		  if(baseData.flag!='0'){
	      alert(baseData.msg);
		  return;
		  }
	if (window.confirm("确认要提交吗?")) {
			submitProcessInfo();
			alert('提交成功!');
			refreshData();
		}
	}
	


    function chooseOne(cb){   
        var obj = document.getElementsByName("selectedbox");  
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    }   
    /**
	 * 专家信息************************************************************************************************************************
	 */
	function byjh(){
		var shuaId = getSelIds('selectedbox');
	    if(shuaId==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
		if (shuaId != null) {
			var baseData = jcdpCallService("ScrapeSrv", "getScrapeEmpOpinionAll", "scrape_apply_id="+shuaId);
			var retObj = baseData.deviceappMap;
			var size = $("#assign_body", "#tab_box_content14").children("tr").size();
			if (size > 0) {
				$("#assign_body", "#tab_box_content14").children("tr").remove();
			}
			if (retObj != undefined) {
				for (var i = 0; i < retObj.length; i++) {
					//动态新增表格
					var innerHTML = "<tr id='tr"+i+"' name='tr"+i+"'>";
					innerHTML += 		"<input type='hidden' name='id"+i+"' id='id"+i+"' value='"+retObj[i].id+"'/>";
					innerHTML += 		"<input type='hidden' name='scrapeid"+i+"' id='scrapeid"+i+"' value='"+retObj[i].scrapeid+"'/>";
					innerHTML += 		"<input type='hidden' name='types"+i+"' id='types"+i+"' value='"+retObj[i].types+"'/>";
					innerHTML += 		"<input type='hidden' name='employee_name"+i+"' id='employee_name"+i+"' value='"+retObj[i].employee_name+"'/>";
					innerHTML += 		"<td>"+retObj[i].employee_name+"</td>";
 					innerHTML +=        "<td><textarea row='3' cols='20' name='employee_opinion"+i+"' id='employee_opinion"+i+"' value='"+retObj[i].employee_opinion+"'>"+retObj[i].employee_opinion+"</textarea></td>";
					innerHTML +=        "<td><textarea row='3' cols='20' name='bak"+i+"' id='bak"+i+"' value='"+retObj[i].bak+"'>"+retObj[i].bak+"</textarea></td>";
					innerHTML += "</tr>";
					$("#assign_body").append(innerHTML);
				}
			}
		}
		$("#assign_body>tr:odd>td:odd", '#tab_box_content14').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even", '#tab_box_content14').addClass("odd_even");
		$("#assign_body>tr:even>td:odd", '#tab_box_content14').addClass("even_odd");
		$("#assign_body>tr:even>td:even", '#tab_box_content14').addClass("even_even");
	}
	//打开保养计划修改界面
	 function toEditEmp(){
		 var tr_id = $("#assign_body>tr:last").attr("id");
		 if(tr_id != undefined){
				tr_id = parseInt(tr_id.substr(2),10);
			}
			if(tr_id == undefined){
				tr_id = 0;
			}else{
				tr_id = tr_id+1;
			}
		 var ids="";
		 var employee_names="";
		 var employee_opinions="";
		 var baks="";
		 var scrapeids ="";
		 var types="";
		 for(var i=0;i<tr_id;i++){
			 if($("#employee_opinion"+i).val().length>50){
				 alert("鉴定信息长度不能超过50字符");
				 return;
			 }
			 if($("#bak"+i).val().length>50){
				 alert("组员长度不能超过50字符");
				 return;
			 }
			 ids+=$("#id"+i).val()+"&";
			 employee_names+=$("#employee_name"+i).val()+"&";
			 employee_opinions+=$("#employee_opinion"+i).val()+"&";
			 baks+=$("#bak"+i).val()+"&";
			 types+=$("#types"+i).val()+"&";
			 scrapeids+=$("#scrapeid"+i).val()+"&";
		 }
		 if(employee_names !=""){
				Ext.MessageBox.wait('请等待','处理中');
				Ext.Ajax.request({
					url : "<%=contextPath%>/dmsManager/scrape/batUpdateScrapeEmp.srq",
					method : 'Post',
					isUpload : true,  
					params : {
						ids :ids,
						employee_names :employee_names,
						employee_opinions :employee_opinions,
						baks :baks,
						types:types,
						scrapeids:scrapeids
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
			}
	 }
/* 	 function chooseOneEmp(cb){
	        var obj = document.getElementsByName("myselectedbox");  
	        for (var i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }  */
   function exportDevData(){
	var ids = getSelIds('selectedbox');
	ids = "'"+ids.replace(new RegExp(/(,)/g),"','")+"'";
	var exportFlag = 'bfsqcx';
	var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
	var submitStr="scrape_apply_id="+ids+"&exportFlag="+exportFlag;
	var retObj = syncRequest("post", path, submitStr);
	var filename=retObj.excelName;
	filename = encodeURI(filename);
	filename = encodeURI(filename);
	var showname=retObj.showName;
	showname = encodeURI(showname);
	showname = encodeURI(showname);
	window.location=cruConfig.contextPath+"/rm/dm/common/download_temp.jsp?filename="+filename+"&showname="+showname;
}
   /**
 * 审批明细************************************************************************************************************************
 */
function spmx(){
	var shuaId = getSelIds('selectedbox');
    if(shuaId==''){ 
	    alert("请先选中一条记录!");
    		return;
    }
	if (shuaId != null) {
		var baseData = jcdpCallService("ScrapeSrvNew", "getScrapeApplyInfo", "scrape_apply_id="+shuaId);
		var retObj = baseData.scrapeAppFlowList;
		var size = $("#spmx_body", "#tab_box_content2").children("tr").size();
		if (size > 0) {
			$("#spmx_body", "#tab_box_content2").children("tr").remove();
		}
		if (retObj != undefined) {
			for (var i = 0; i < retObj.length; i++) {
				//动态新增表格
				var innerHTML = "<tr id='tr"+i+"' name='tr"+i+"'>";
				innerHTML += 		"<td  style='text-align:center;vertical-align: middle;'>"+retObj[i].node_name+"</td>";
				innerHTML += 		"<td  style='text-align:center;vertical-align: middle;'>"+retObj[i].curstate+"</td>";
				innerHTML += 		"<td  style='text-align:center;vertical-align: middle;'>"+retObj[i].examine_info+"</td>";
				innerHTML += 		"<td  style='text-align:center;vertical-align: middle;'>"+retObj[i].examine_user_name+"</td>";
				innerHTML += 		"<td  style='text-align:center;vertical-align: middle;'>"+retObj[i].examine_end_date+"</td>";
				innerHTML += "</tr>";
				$("#spmx_body").append(innerHTML);
			}
		}
	}
}
	/** 通过的可以查看*/
	function toSeeScrapePage(){
		var baseData;
		var ids = getSelIds('selectedbox');
	    if(ids==''){ 
		    alert("请先选中一条记录!");
	 		return;
	    }
	  baseData = jcdpCallService("ScrapeSrv", "getScrapeAppleState", "scrape_apply_id="+ids);
	 var proStatus = baseData.deviceappMap.sp_pass_flag;
		popWindow('<%=contextPath%>/dmsManager/scrape/scrapeApply_See.jsp?scrape_apply_id='+ids+'&proStatus='+proStatus,'840:650','评审查看');
	}
	/** 未通过的二级单位可以查看 */
	function toTwoUnitsSeeScrapePage(){
		var baseData;
		var ids = getSelIds('selectedbox');
	    if(ids==''){ 
		    alert("请先选中一条记录!");
	 		return;
	    }
	    baseData = jcdpCallService("ScrapeSrv", "getScrapeAppleState", "scrape_apply_id="+ids);
	    var proStatus = baseData.deviceappMap.sp_pass_flag;
		popWindow('<%=contextPath%>/dmsManager/scrape/scrapeApply_See2.jsp?scrape_apply_id='+ids+'&proStatus='+proStatus,'840:650','评审查看');
	}
	function scrapeTypeCheck(value,row,index){
    	var innerHtml ="";
    	if(value=="0"){
    		innerHtml = "正常报废";
    	}else if(value=="1"){
    		innerHtml = "技术淘汰";
    	}else if(value=="2"){
    		innerHtml = "毁损";
    	}else if(value=="3"){
    		innerHtml = "盘亏";
    	}
    	return innerHtml;
    }
	/**
	 * 公司审批信息************************************************************************************************************************
	 */
	function gsspxx(){

		var shuaId = getSelIds('selectedbox');
	    if(shuaId==''){ 
		    alert("请先选中一条记录!");
	    		return;
	    }
		if (shuaId != null) {
			var baseData = jcdpCallService("ScrapeSrvNew", "getScrapeApplyCompanyInfo", "scrape_apply_id="+shuaId);
			var retObj = baseData.scrapeAppFlowList;
			var size = $("#gsspmx_body", "#tab_box_content15").children("tr").size();
			if (size > 0) {
				$("#gsspmx_body", "#tab_box_content15").children("tr").remove();
			}
			if (retObj != undefined) {
				for (var i = 0; i < retObj.length; i++) {
					//动态新增表格
					var innerHTML = "<tr id='tr"+i+"' name='tr"+i+"'>";
					innerHTML += 		"<td  style='text-align:center;vertical-align: middle;'>"+retObj[i].node_name+"</td>";
					innerHTML += 		"<td  style='text-align:center;vertical-align: middle;'>"+retObj[i].curstate+"</td>";
					innerHTML += 		"<td  style='text-align:center;vertical-align: middle;'>"+retObj[i].examine_info+"</td>";
					innerHTML += 		"<td  style='text-align:center;vertical-align: middle;'>"+retObj[i].examine_user_name+"</td>";
					innerHTML += 		"<td  style='text-align:center;vertical-align: middle;'>"+retObj[i].examine_end_date+"</td>";
					innerHTML += "</tr>";
					$("#gsspmx_body").append(innerHTML);
				}
			}
		}
	}
</script>
</html>