<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<%@include file="/common/include/processresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>报废设备评审</title>
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
 
 <body>
      	<div id="list_table">
      	<!-- 查询条件 -->
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			    <td class="ali_cdn_name">报废汇总名称</td>
			    <td class="ali_cdn_input">
			    	<input id="scrape_collect_name" name="scrape_collect_name" type="text" class="input_width" />
			    </td>
			       <td class="ali_cdn_name">报废汇总单号</td>
			    <td class="ali_cdn_input">
			    	<input id="scrape_collect_no" name="scrape_collect_no" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAddScrapePage()'"  title="新增"></auth:ListButton>
				<auth:ListButton functionId="" css="xg" event="onclick='toModifyScrapePage()'" title="修改"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelScrapePage()'" title="删除"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
			    <td width="2%"><img src="<%=contextPath%>/images/ck_two.png" onclick="toSeeScrapePage()" align="right" width="22" height="22" style="cursor:hand;" title="信息查看"/></td>
			    <!--  汇总不需要提交 -->
			    <%-- <auth:ListButton functionId="" css="tj" event="onclick='toSumbitScrapeApp()'" title="提交"></auth:ListButton> --%>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<!-- 展示数据 -->
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='scrape_collect_id_{scrape_collect_id}' name='scrape_collect_id'  idinfo='{scrape_collect_id}'>
			     	<td class="bt_info_odd" exp="<input type='radio' name='selectedbox' value='{scrape_collect_id}' id='selectedbox_{scrape_collect_id}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{scrape_collect_no}">报废汇总单号</td>
					<td class="bt_info_odd" exp="{scrape_collect_name}">报废汇总单名称</td>
					<td class="bt_info_even" exp="{employee_name}">汇总人</td>
					<td class="bt_info_odd" exp="{org_name}">汇总单位</td>
					<td class="bt_info_even" exp="{collect_date}">汇总时间</td>
					<!-- <td class="bt_info_odd" exp="{apply_status}">状态</td> -->
			     </tr> 
			  </table>
			</div>
			<!-- 分页 -->
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
			    <!-- <li id="tag3_1"><a href="#" onclick="getContentTab(this,2)">审批流程</a></li> -->
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,6)">申请单明细</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="scrapeMap" name="scrapeMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">设备报废单号：</td>
				      <td  class="inquire_form6" ><input id="scrape_collect_no" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">设备报废单名称：</td>
				      <td  class="inquire_form6"><input id="scrape_collect_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;汇总单位：</td>
				      <td  class="inquire_form6"  ><input id="org_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				    <tr>
				      <td  class="inquire_item6">汇总人：</td>
				      <td  class="inquire_form6"><input id="employee_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;汇总时间：</td>
				      <td  class="inquire_form6"  ><input id="collect_date" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none;padding-bottom:70px;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					    <td background="<%=contextPath%>/images/list_15.png">
						    <table width="100%" border="0" cellspacing="0" cellpadding="0">
							    <tr>
								    <td>&nbsp;</td>
								    <auth:ListButton functionId="" css="xz" event="onclick='exportDevPassData()'" title="导出该申请单通过设备"></auth:ListButton>
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
						      <th nowrap="false" data-options="field:'asset_coding',align:'center',sortable:'true'" width="6%">资产编号</th>
						      <th nowrap="false" data-options="field:'dev_name',align:'center',sortable:'true'" width="6%">设备名称</th>
						      <th nowrap="false" data-options="field:'dev_model',align:'center',sortable:'true'" width="6%">规格型号</th>
						      <th nowrap="false" data-options="field:'license_num',align:'center',sortable:'true'" width="6%">牌照号</th>
						      <th nowrap="false" data-options="field:'producting_date',align:'center',sortable:'true'" width="6%">启用时间</th>
						      <th nowrap="false" data-options="field:'org_name',align:'center',sortable:'true'" width="6%">事业部</th>
						      <th nowrap="false" data-options="field:'bm',align:'center',sortable:'true'" width="6%">部门/小队</th>
						      <th nowrap="false" data-options="field:'sl',align:'center',sortable:'true'" width="6%">数量</th>
						  	  <th nowrap="false" data-options="field:'project_name',align:'center',sortable:'true'" width="6%">项目名/国家名</th>
						      <th nowrap="false" data-options="field:'asset_value',align:'center',sortable:'true'" width="6%">原值</th>
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
								    <auth:ListButton functionId="" css="xz" event="onclick='exportDevNotPassData()'" title="导出该申请单未通过设备"></auth:ListButton>
							    </tr>
							</table>
						</td>
					    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="20" /></td>
					  </tr>
					</table>
					<table id="dev_grid7">
						<thead>
							<tr>
							  <th nowrap="false" data-options="field:'dev_type',align:'center',sortable:'true'" width="6%">设备编码</th>
						      <th nowrap="false" data-options="field:'dev_coding',align:'center',sortable:'true'" width="6%">设备编号</th>
						      <th nowrap="false" data-options="field:'asset_coding',align:'center',sortable:'true'" width="6%">资产编号</th>
						      <th nowrap="false" data-options="field:'dev_name',align:'center',sortable:'true'" width="6%">设备名称</th>
						      <th nowrap="false" data-options="field:'dev_model',align:'center',sortable:'true'" width="6%">规格型号</th>
						      <th nowrap="false" data-options="field:'license_num',align:'center',sortable:'true'" width="6%">牌照号</th>
						      <th nowrap="false" data-options="field:'producting_date',align:'center',sortable:'true'" width="6%">启用时间</th>
						      <th nowrap="false" data-options="field:'org_name',align:'center',sortable:'true'" width="6%">事业部</th>
						      <th nowrap="false" data-options="field:'bm',align:'center',sortable:'true'" width="6%">部门/小队</th>
						      <th nowrap="false" data-options="field:'sl',align:'center',sortable:'true'" width="6%">数量</th> 
						      <th nowrap="false" data-options="field:'asset_value',align:'center',sortable:'true'" width="6%">原值</th>
						      <th nowrap="false" data-options="field:'project_name',align:'center',sortable:'true'" width="6%">项目名/国家名</th>
						      <th nowrap="false" data-options="field:'net_value',align:'center',sortable:'true'" width="6%">净额</th>
						      <th nowrap="false" data-options="field:'scrape_type',align:'center',sortable:'true'" formatter='scrapeTypeCheck' width="6%">报废原因</th>
						      <th nowrap="false" data-options="field:'duty_unit',align:'center',sortable:'true'" width="6%">责任单位</th>
						      <th nowrap="false" data-options="field:'team_name',align:'center',sortable:'true'" width="6%">部门名称</th>
							</tr>
						</thead>
					</table>
				</div>
				
			<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none;">
				<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>
			</div>
			<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
			</div>
			<div id="tab_box_content6" name="tab_box_content6" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="scrapeApplyList" id="scrapeApplyList" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
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
		fitColumns:true
	});
	//初始化详细信息
	$("#dev_grid7").datagrid({ 
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
		//评审通过明细
		if(index == 1){
			var queryParams;
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
			//设备信息显示
			$("#dev_grid").datagrid({
				url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=ScrapeSrv&JCDP_OP_NAME=getScrapeDetailInfo",
				queryParams:{'scrape_collect_id':ids}
			});
		}
		else if(index == 3){
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid);
		}else if(index == 4){
			$("#remark").attr("src","<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+currentid);
		}else if(index == 5){
			$("#codeManager").attr("src","<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=5&relationId="+currentid);
		}else if(index == 6){
			$("#scrapeApplyList").attr("src","<%=contextPath%>/dmsManager/scrape/scrapeApplyListforCollect.jsp?relationId="+currentid);
		}
		else if(index == 7){
			var baseData;
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		  //设备信息显示
			$("#dev_grid7").datagrid({
				url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=ScrapeSrv&JCDP_OP_NAME=getScrapeDetailNotGoInfo",
				queryParams:{'scrape_collect_id':ids}
			});
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
			innerHTML += "<td>"+datas[i].dev_name+"</td>";
			innerHTML += "<td>"+datas[i].dev_model+"</td>";
			innerHTML += "<td>"+datas[i].license_num+"</td>";
			innerHTML += "<td>"+datas[i].producting_date+"</td>";
			innerHTML += "<td>"+datas[i].dev_date+"</td>";
			innerHTML += "<td>"+datas[i].org_name+"</td>";
			innerHTML += "<td>/</td>";
			innerHTML += "<td>/</td>";
			innerHTML += "<td>1</td>";
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
	cruConfig.queryOp = "queryScrapeCollectList";
	var path = "<%=contextPath%>";
	$(function(){
		searchDevData();
	});
	
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
		var scrape_collect_no = document.getElementById("scrape_collect_no").value;
		var scrape_collect_name = document.getElementById("scrape_collect_name").value;
		refreshData(scrape_collect_no, scrape_collect_name);
	}
	function clearQueryText(){
		document.getElementById("scrape_collect_no").value = "";
		document.getElementById("scrape_collect_name").value = "";
		refreshData("", "");
	}
    function refreshData(scrape_collect_no, scrape_collect_name){
      	var temp = "";
		if(typeof scrape_collect_no!="undefined" && scrape_collect_no!=""){
			temp += "&scrape_collect_no="+scrape_collect_no;
		}
		if(typeof scrape_collect_name!="undefined" && scrape_collect_name!=""){
			temp += "&scrape_collect_name="+scrape_collect_name;
		}
		cruConfig.submitStr = temp;	
		queryData(1);

	}
    function loadDataDetail(scrape_collect_id){
    	var retObj;
		if(scrape_collect_id!=null){
			 retObj = jcdpCallService("ScrapeSrv", "getScrapeCollectInfo", "scrape_collect_id="+scrape_collect_id);
			
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("ScrapeSrv", "getScrapeCollectInfo", "scrape_collect_id="+ids);
		}
	
		//选中这一条checkbox
		$("#selectedbox_"+retObj.deviceappMap.scrape_collect_id).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceappMap.scrape_collect_id+"']").removeAttr("checked");
		//给数据回填
		$("#scrape_collect_no","#scrapeMap").val(retObj.deviceappMap.scrape_collect_no);
		$("#scrape_collect_name","#scrapeMap").val(retObj.deviceappMap.scrape_collect_name);
		$("#collect_date","#scrapeMap").val(retObj.deviceappMap.collect_date);
		$("#employee_name","#scrapeMap").val(retObj.deviceappMap.employee_name);
		$("#org_name","#scrapeMap").val(retObj.deviceappMap.org_name);
		
		var curbusinesstype = "";
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
	function toAddScrapePage(){
		popWindow('<%=contextPath%>/dmsManager/scrape/scrapeCollectAddNew.jsp','','');
	}
	function toSeeScrapePage(){
		var baseData;
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		var   baseData = jcdpCallService("ScrapeSrv", "getScrapeCollectDate", "scrape_collect_id="+ids);
		if(baseData.result=='1'){//2018之后数据展示
		popWindow('<%=contextPath%>/dmsManager/scrape/scrapeCollectAddForProc.jsp?scrape_collect_id='+ids+'&type=q','','报废评审查看');
		}else{//2018年之前数据展示
		popWindow('<%=contextPath%>/dmsManager/scrape/OldOfscrapeCollectAddForProc.jsp?scrape_collect_id='+ids+'&type=q','','报废评审查看');
		}  
		
		
	}
	function toModifyScrapePage(){
		var baseData;
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		 baseData = jcdpCallService("ScrapeSrv", "getScrapeCollectState", "scrape_collect_id="+ids);
		if(baseData.flag=='1')
		{
			alert("您选择的记录已上报,不能修改!");
			//return;
		}
		popWindow('<%=contextPath%>/dmsManager/scrape/scrapeCollectAddNew.jsp?scrape_collect_id='+ids,'','报废评审');
	}
	function toDelScrapePage(){
		var baseData;
		var retObj;
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		 baseData = jcdpCallService("ScrapeSrv", "getScrapeCollectState", "scrape_collect_id="+ids);
		
		if(baseData.flag=='1')
		{
			alert("您选择的记录已上报,不能修改!");
			return;
		}
		if(confirm('确定要删除吗?')){  
			retObj = jcdpCallService("ScrapeSrv", "deleteScrapeCollectInfo", "scrape_collect_id="+ids);
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
		 baseData = jcdpCallService("ScrapeSrv", "getScrapeCollectState", "scrape_collect_id="+ids);
		
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
		    
		 retObj = jcdpCallService("ScrapeSrv", "getScrapeDetail", "scrape_collect_id="+ids);
		if(retObj.deviceappMap.result=='0')
		{
			alert("您选择的记录中未添加设备报废明细,不能提交!")
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
    //评审数据导出
    function exportDevPassData(){
    	var ids = getSelIds('selectedbox');
    	ids = "'"+ids.replace(new RegExp(/(,)/g),"','")+"'";
    	var exportFlag = 'bfpscx';//报废评审查询
    	var sp_pass_flag ="0";//审批是否通过0通过
    	var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
    	var submitStr="scrape_collect_id="+ids+"&exportFlag="+exportFlag+"&sp_pass_flag="+sp_pass_flag;
    	var retObj = syncRequest("post", path, submitStr);
    	var filename=retObj.excelName;
    	filename = encodeURI(filename);
    	filename = encodeURI(filename);
    	var showname=retObj.showName;
    	showname = encodeURI(showname);
    	showname = encodeURI(showname);
    	window.location=cruConfig.contextPath+"/rm/dm/common/download_temp.jsp?filename="+filename+"&showname="+showname;
    }
  //评审数据导出
    function exportDevNotPassData(){
    	var ids = getSelIds('selectedbox');
    	ids = "'"+ids.replace(new RegExp(/(,)/g),"','")+"'";
    	var exportFlag = 'bfpscx';
    	var sp_pass_flag ="1";//审批是否通过1不通过
    	var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
    	var submitStr="scrape_collect_id="+ids+"&exportFlag="+exportFlag+"&sp_pass_flag="+sp_pass_flag;
    	var retObj = syncRequest("post", path, submitStr);
    	var filename=retObj.excelName;
    	filename = encodeURI(filename);
    	filename = encodeURI(filename);
    	var showname=retObj.showName;
    	showname = encodeURI(showname);
    	showname = encodeURI(showname);
    	window.location=cruConfig.contextPath+"/rm/dm/common/download_temp.jsp?filename="+filename+"&showname="+showname;
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
</script>
</html>