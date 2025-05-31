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
	String expert_leader_id=request.getParameter("expert_leader_id");
	String userid=user.getSubOrgIDofAffordOrg();//所属单位隶属关系id
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<%@include file="/common/include/processresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>专家信息填写</title>
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
			<div id="inq_tool_box"> 
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			       
			     	<td class="bt_info_odd" exp="<input type='radio' name='selectedbox' value='{scrapeid}' id='selectedbox_{scrapeid}'  />" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{scrape_apply_no}">报废申请单号</td>
					<td class="bt_info_odd" exp="{scrape_apply_name}">报废申请单名称</td>
					<td class="bt_info_odd" exp="{types}">报废类型</td>
					<td class="bt_info_even" exp="{employee_name}">申请人</td>
					<td class="bt_info_even" exp="{apply_date}">申请时间</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">专家信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,8)">报废申请明细</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				 
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
			 
			 
			<div id="tab_box_content0" name="tab_box_content0"
				class="tab_box_content"  >
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
		if(index==0){
		byjh();
		}
		else if(index == 8){
		var baseData;
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		  //设备信息显示
			$("#dev_grid1").datagrid({
				url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=ScrapeSrv&JCDP_OP_NAME=getScrapeDetailInfoAllForOA",
				queryParams:{'scrapeid':ids}
			});
		
		}
		$(filternotobj).hide();
		$(filterobj).show(); 
	}
 
	$(document).ready(lashen);
</script>
 
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "ScrapeSrv";
	cruConfig.queryOp = "queryScrapeApplyForOA";
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
		var scrape_apply_no =  '';
		var scrape_apply_name = '';
		refreshData(scrape_apply_no, scrape_apply_name,'');
	}
	function clearQueryText(){
		document.getElementById("scrape_apply_no").value = "";
		document.getElementById("scrape_apply_name").value = "";
		refreshData("", "",'');
	}
    function refreshData(scrape_apply_no, scrape_apply_name, scrape_apply_id){
      	var temp = "&expert_leader_id=<%=expert_leader_id%>";
		 
		cruConfig.submitStr = temp;	
		queryData(1);
		 

	}
    
	 
    /**
	 * 专家信息************************************************************************************************************************
	 */
	function byjh(){
		$("#assign_body").empty();
		var shuaId = getSelIds('selectedbox');
	    if(shuaId==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
		if (shuaId != null) {
			var baseData = jcdpCallService("ScrapeSrv", "getScrapeEmpOpinionAllforOA", "scrapeid="+shuaId);
			var retObj = baseData.deviceappMap;
			var size = $("#assign_body", "#tab_box_content0").children("tr").size();
			if (size > 0) {
				$("#assign_body", "#tab_box_content0").children("tr").remove();
			}
			if (retObj != undefined) {
				for (var i = 0; i < retObj.length; i++) {
					//动态新增表格
					var innerHTML = "<tr id='tr"+i+"' name='tr"+i+"'>";
					innerHTML += 		"<input type='hidden' name='id"+i+"' id='id"+i+"' value='"+retObj[i].id+"'/>";
					innerHTML += 		"<input type='hidden' name='scrapeid"+i+"' id='scrapeid"+i+"' value='"+retObj[i].scrapeid+"'/>";
					innerHTML += 		"<input type='hidden' name='types"+i+"' id='types"+i+"' value='"+retObj[i].types1+"'/>";
					innerHTML += 		"<input type='hidden' name='employee_name"+i+"' id='employee_name"+i+"' value='"+retObj[i].employee_name+"'/>";
					innerHTML += 		"<td>"+retObj[i].employee_name+"</td>";
 					innerHTML +=        "<td><textarea row='3' cols='20' name='employee_opinion"+i+"' id='employee_opinion"+i+"' value='"+retObj[i].employee_opinion+"'>"+retObj[i].employee_opinion+"</textarea></td>";
					innerHTML +=        "<td><textarea row='3' cols='20' name='bak"+i+"' id='bak"+i+"' value='"+retObj[i].bak+"'>"+retObj[i].bak+"</textarea></td>";
					innerHTML += "</tr>";
					$("#assign_body").append(innerHTML);
				}
			}
		}
		$("#assign_body>tr:odd>td:odd", '#tab_box_content0').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even", '#tab_box_content0').addClass("odd_even");
		$("#assign_body>tr:even>td:odd", '#tab_box_content0').addClass("even_odd");
		$("#assign_body>tr:even>td:even", '#tab_box_content0').addClass("even_even");
	}
	  function loadDataDetail(scrape_apply_id){
    	 
	
		//选中这一条checkbox
		$("#selectedbox_"+scrape_apply_id).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+scrape_apply_id+"']").removeAttr("checked");
		getContentTab(undefined,selectedTagIndex);
		}
	//专家意见保存
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
					 //设备信息显示
					 var ids = getSelIds('selectedbox');
					 	refreshData("", "",'');
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