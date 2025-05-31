<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
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
<%@include file="/common/include/quotesresource.jsp"%>
<%@include file="/common/include/processresource.jsp"%>
<title>报废统计页面</title> 
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
 <body style="background:#cdddef" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备类型</td>
          		<td class="ali_cdn_input">
          		<select id="s_dev_types" name="s_dev_types">
						<option value="">全部</option>
						<option value="S08">运输设备</option>
						<option value="S0601">物探钻机</option>
						<option value="S070301">推土机</option>
						<option value="S14050301">检波器(串)</option>
						<option value="S140501">地震仪器(道)</option>
						<option value="S0623">震源</option>
					</select>
          		</td>
			    <td class="ali_cdn_name">年度：</td>
			 	    <td class="ali_cdn_input">
					<select id="collect_date" name="collect_date">
						<option value="">全部</option>
						<option value="2013">2013</option>
						<option value="2014">2014</option>
						<option value="2015">2015</option>
						<option value="2016">2016</option>
						<option value="2017">2017</option>
						<option value="2018">2018</option>
						<option value="2019">2019</option>
						<option value="2020">2020</option>
					</select>
			 	   </td>
			    
      			<td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>			          			
			    <td>&nbsp;</td>
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
			     <tr id='dev_type_{dev_type}' name='dev_type'  idinfo='{dev_type}'>
					<td class="bt_info_even" exp="<input type='radio' name='selectedbox' value='{dev_type}' id='selectedbox_{dev_type}'  onclick='chooseOne(this)'/>" >选择</td>
					<!-- <td class="bt_info_odd" exp="{owning_org_name_desc}">所属单位</td> -->
					<td class="bt_info_odd" exp="{dev_name}">设备类型</td>
					<td class="bt_info_even" exp="{count}">数量</td>
					<td class="bt_info_even" exp="{asset_value}">原值</td>
					<td class="bt_info_even" exp="{net_value}">净值</td>
					<td class="bt_info_even" exp="{can_value}">残值</td>
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
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this)">明细信息</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					    <td background="<%=contextPath%>/images/list_15.png">
						    <table width="100%" border="0" cellspacing="0" cellpadding="0">
							    <tr>
								    <td>&nbsp;</td>
								    <auth:ListButton functionId="" css="dc" event="onclick='exportDevData()'" title="导出该申请单设备"></auth:ListButton>
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
		</div>
	</div>
</body>
<script type="text/javascript">
	function frameSize(){
		setTabBoxHeight();
	}
	frameSize();
	$(function(){
		$(window).resize(function(){
			frameSize();
		});
	})
	$(document).ready(lashen);
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	/* cruConfig.queryStr = "";
	cruConfig.queryService = "ScrapeSrvNew";
	cruConfig.queryOp = "queryScrapeInfoNew"; */
	//下拉时查询
	function selectRefreshData(){
	    searchDevData();
	}
	function searchDevData(){
		var v_dev_type = document.getElementById("s_dev_types").value;
		var v_collect_date = document.getElementById("collect_date").value;
		refreshData(v_dev_type,v_collect_date);
	}
	 //清空查询条件
    function clearQueryText(){
		document.getElementById("s_dev_types").value="";
		document.getElementById("collect_date").value="";
    }
	function refreshData(v_dev_type,v_collect_date){
		var userid = '<%=userOrgId%>';
		var orgLength = userid.length;
		var str = "";
		
		str +=" select case when dev_type='S14050301' then 0 else sum(net_value)*0.05 end as can_value,";
		str +=" sum(net_value) as net_value,sum(asset_value) as asset_value,count(dev_name) as count,dev_name dev_name,dev_type from (select ";
		str +=" case when acc.dev_type like 'S08%' then '运输设备'";
		str +=" when acc.dev_type like 'S0601%' then '物探钻机'";
		str +=" when acc.dev_type like 'S070301%' then '推土机' ";
		str +=" when acc.dev_type like 'S14050301%' then '检波器(串)'";
		str +=" when acc.dev_type like 'S140501%' then '地震仪器(道)'";
		str +=" when acc.dev_type like 'S0623%' then '震源'";
		str +=" else '其它' end as dev_name,";
		str +=" case when acc.dev_type like 'S08%' then 'S08'";
		str +=" when acc.dev_type like 'S0601%' then 'S0601'";
		str +=" when acc.dev_type like 'S070301%' then 'S070301' ";
		str +=" when acc.dev_type like 'S14050301%' then 'S14050301'";
		str +=" when acc.dev_type like 'S140501%' then 'S140501'";
		str +=" when acc.dev_type like 'S0623%' then 'S0623'";
		str +=" else 'other'";
		str +=" end as dev_type,acc.net_value,acc.asset_value from dms_scrape_detailed acc,dms_scrape_apply app where acc.bsflag=0 and app.scrape_apply_id = acc.scrape_apply_id ";
		//如果是超级管理员的话不做所属单位数据筛选，查询全部的单位数据
		var scrape_org_id = '<%=orgId%>';
		if('<%=orgCode%>'!='C105'){
			str +=" and app.scrape_org_id ='"+scrape_org_id+"'";
		}
		if(v_dev_type!=undefined && v_dev_type!=''){
			str +=" and acc.dev_type like '"+v_dev_type+"%'";
		}
		if(v_collect_date!=undefined && v_collect_date!=''){
			str +=" and to_char(acc.scrape_date,'yyyy') = "+v_collect_date;
		}
		str +=" ) group by dev_name,dev_type order by dev_type asc";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
		$("#tab_box_content1").show(); 
	}
	function loadDataDetail(scrape_apply_id){
		getContentTab();
	}
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
		fitColumns:true
	});
	function getContentTab(obj) {
		if(obj!=undefined){
			$("LI","#tag-container_3").removeClass("selectTag");
			var contentSelectedTag = obj.parentElement;
			contentSelectedTag.className ="selectTag";
		}
		var ids = getSelIds('selectedbox');
	    if(ids==''){
		    alert("请先选中一条记录!");
     		return;
	    }
		var collect_date = document.getElementById("collect_date").value;
	  	//设备信息显示
		$("#dev_grid").datagrid({
			url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=ScrapeSrv&JCDP_OP_NAME=getScrapeDetailInfoBydevType",
			queryParams:{'dev_type':ids,
				'collect_date':collect_date}
		});
		$("#tab_box_content1").show(); 
	}
 	function chooseOne(cb){   
        var obj = document.getElementsByName("selectedbox");  
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
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
	/**导出**/
	 function exportDevData(){
	var ids = getSelIds('selectedbox');
	var collect_date = document.getElementById("collect_date").value;
	var exportFlag = 'bfxxcx';//报废信息查询
	var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
	var submitStr="dev_type="+ids+"&collect_date="+collect_date+"&exportFlag="+exportFlag;
	var retObj = syncRequest("post", path, submitStr);
	var filename=retObj.excelName;
	filename = encodeURI(filename);
	filename = encodeURI(filename);
	var showname=retObj.showName;
	showname = encodeURI(showname);
	showname = encodeURI(showname);
	window.location=cruConfig.contextPath+"/rm/dm/common/download_temp.jsp?filename="+filename+"&showname="+showname;
}
</script>
</html>