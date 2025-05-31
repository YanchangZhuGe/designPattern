<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%@page import="java.util.Date"%>
<%
	String contextPath = request.getContextPath();
	String appDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
	/* UserToken user = OMSMVCUtil.getUserToken(request); */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@include file="/common/include/quotesresource.jsp"%>

<title>物料报废</title>
 
<style>

 
</style>
</head>

<body style="background:#fff" onload="refreshData()">
<div id="list_table">
	<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			<td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
		      <tr>
		          <td class="ali_cdn_name">&nbsp;申请单位:</td>
		          <td class="ali_cdn_input">
		          	<input name="apply_unit" id="apply_unit" class="input_width" type="text"/>
		          </td>
		          <td class="ali_cdn_name">&nbsp;项目名称:</td>
					<td class="ali_cdn_input">
						<input name="opi_name" id="opi_name" class="input_width" type="text" value=""/>
					</td>
					 <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
				    </td>
				    <td class="ali_query">
					    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
				    </td>
				    
				    <td>&nbsp;</td>
				    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="新增"></auth:ListButton>
					<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="修改"></auth:ListButton>
				    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="删除"></auth:ListButton>
			 		<auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			 </tr>
	       </table>
	      </td>
				<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
		</tr>
      </table>
     </div>
     <div id="table_box">
			  <table style="width:98.5%;table-layout: fixed;" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr>
			     	<td class="bt_info_odd" width="4%" exp="<input type='radio' name='selectedbox' value='{scrape_apply_wz_id}' id='selectedbox_{scrape_apply_wz_id}'/>" >选择</td>
					<td class="bt_info_even" width="4%" autoOrder="1" >序号</td> 
					<td class="bt_info_even" style="white-space:nowrap;overflow:hidden;text-overflow: ellipsis;"  width="36%" exp="{scrape_apply_title}">标题</td>
					<td class="bt_info_even" style="white-space:nowrap;overflow:hidden;text-overflow: ellipsis;" width="36%" exp="{scrape_apply_content}">报废说明</td>
					<td class="bt_info_odd" style="white-space:nowrap;overflow:hidden;text-overflow: ellipsis;" width="6%" exp="{asset_value}">原值金额</td>
 
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
			    <li id="tag3_0" ><a href="#" onclick="getContentTab(this,1)">设备明细</a></li>
			  </ul>
	  </div>
	  <div id="tab_box" class="tab_box">
		<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
		 <table id="scrapeMap" name="scrapeMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">标题：</td>
				      <td  class="inquire_form6" ><input id="scrape_apply_wz_title" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">原值：</td>
				      <td  class="inquire_form6"><input id="asset_value" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				     <tr>
				      <td  class="inquire_item6">&nbsp;报废说明：</td>
				      <td  class="inquire_form6"><textarea id="scrape_apply_wz_content" name="scrape_apply_wz_content"  class="input_width easyui-textarea easyui-validatebox main" style="width:100%;height:40px;" overflow-x:hidded;"></textarea> &nbsp;</td>
				     </tr>
					</table>
	   </div>
	   <div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content"  >  
	   <table id="mixcoll_grid">
						<thead>
							<tr>
								<th data-options="field:'wz_id',checkbox:true,align:'center',dc:false" width="10">主键</th>
								<th data-options="field:'wz_name',align:'center',sortable:'true'" width="30">物料名称</th>
								<th data-options="field:'wz_prickie',align:'center',sortable:'true'" width="8">单位</th>
								<th data-options="field:'wz_price',align:'center'" width="10">单价</th>
								<th data-options="field:'wz_count',align:'center'" width="10">数量</th>
								<th data-options="field:'wz_money',align:'center'" width="10">金额</th>
								<th data-options="field:'wz_warehouse',align:'center',sortable:'true'" width="25">仓位</th>
								<th data-options="field:'wz_entrepot',align:'center',sortable:'true'" width="15">库位</th>
								<th data-options="field:'wz_slotting',align:'center',sortable:'true'" width="10">新库位</th>
								<th data-options="field:'wz_type',align:'center'" width="20">物料类型</th>
								<th data-options="field:'wz_from',align:'center',sortable:'true'" width="15">进口/国产</th>
								<th data-options="field:'scrapetime',align:'center',sortable:'true'" width="45" >报废年限</th>
								<th data-options="field:'remark',align:'center',sortable:'true'" width="45" >备注</th>
							</tr>
						</thead>
					 </table>
	   </div>
	   
</body>
<script type="text/javascript">
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "queryRetTable";
	cruConfig.queryService = "ScrapeSrvNew";
	cruConfig.queryOp = "queryScrapeApplyWzList";
	function frameSize(){
		setTabBoxHeight();
	}
	frameSize();
	//初始单台设备调配信息
	$("#mixcoll_grid").datagrid({ 
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
		fitColumns:true,
		pageList: [10, 20, 50, 100,200]
		
		 
	});
	//点击记录查询明细信息
    function loadDataDetail(shuaId){
    	//取消其他选中的
		//$("input[type='radio'][name='selectedbox'][id!='selectedbox_"+shuaId+"']").removeAttr("checked");
		//选中这一条checkbox
		$("input[type='radio'][name='selectedbox'][id='selectedbox_"+shuaId+"']").attr("checked",'true');
   		getContentTab(undefined,selectedTagIndex);
    }
	
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
		if(index==0){
		var ids = getSelIds('selectedbox');
				var querySql = " select * from SCRAPE_APPLY_WZ where bsflag='0' and scrape_apply_wz_id='"+ids+"'";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql+'&pageSize=10000');
				var basedatas = queryRet.datas;
				debugger;
		 		$("#scrape_apply_wz_title").val(basedatas[0].scrape_apply_title);
		 		$("#scrape_apply_wz_content").val(basedatas[0].scrape_apply_content);
		 		$("#asset_value").val(basedatas[0].asset_value);
		}
		if(index == 1){
		 	 var ids = getSelIds('selectedbox');
			$("#mixcoll_grid").datagrid({
				queryParams:{'scrape_apply_wz_id': ids},
				url:"${pageContext.request.contextPath}/dmsManager/safekeeping/queryKeepingConfInfoList.srq?JCDP_SRV_NAME=ScrapeSrvNew&JCDP_OP_NAME=queryWZScrapeList"
			});
			 
			 
		}
		 
		$(filternotobj).hide();
		$(filterobj).show();
	}
	/** 关联设备信息 */
	function appendDataToPeopleTab(filterobj,datas){
		debugger;
		for(var i=0;i<datas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_coding+"</td><td>"+datas[i].dev_name+"</td>";
			innerHTML += "<td>"+datas[i].dev_model+"</td>";
			innerHTML += "<td>"+datas[i].asset_value+"</td><td>"+datas[i].net_value+"</td>";
			innerHTML += "</tr>";
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	 
		
	/* 产品基本信息*/
	function loadDataDetail1(change_id){  
    	 
    }
	 
	function insertFilePublicSkill(name,id){
		$("#file_skill_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' style='width :25%'>附件:</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"</tr>"
			);
	}
	//显示已插入的测试使用报告文件文件
	function insertFilePublicTest(name,id){
		$("#file_test_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' style='width :25%'>附件:</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"</tr>"
			);
	}
	//显示已插入的文件
	function insertFilePublicUser(name,id){
		$("#userProve_file_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' style='width :25%'>附件:</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"</tr>"
			);
	}
	//显示已插入的文件
	function insertFilePublicProduction(name,id){
		$("#production_file_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' style='width :25%'>附件:</td>"+
					"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"</tr>"
			);
	}
	//显示已插入的文件
	function insertFilePublicOther(name,id){
		$("#other_file_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' style='width :25%'>附件:</td>"+
					"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"</tr>"
			);
	}
	//显示已插入的文件
	function insertFilePublicReview(name,id){
		$("#other_file_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' style='width :25%'>附件:</td>"+
					"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"</tr>"
			);
	}
	//显示已插入的评审信息报告文件文件
	function insertFilePublicTestPS(name,id){
		$("#review_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5' style='width :25%'>附件:</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;' style='width :45%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"</tr>"
			);
	}
	
	
	// 查询
	function searchDevData(){
		var apply_unit = document.getElementById("apply_unit").value;
		var opi_name = document.getElementById("opi_name").value;
		refreshData(apply_unit,opi_name);
	}
    function refreshData(apply_unit, opi_name){ 
      	var temp = "";
		if(typeof apply_unit!="undefined" && apply_unit!=""){
			temp += "&apply_unit="+apply_unit;
		}
		if(typeof opi_name!="undefined" && opi_name!=""){
			temp += "&project_name="+opi_name;
		}
		cruConfig.submitStr = temp;	
		queryData(1);

	}
	// 清空
	function clearQueryText(){
		document.getElementById("apply_unit").value = "";
		document.getElementById("opi_name").value = "";
		refreshData("","");
		 
	}
	
	// 新增一个产品
	function toAdd(){
		popWindow("<%=contextPath%>/dmsManager/scrape/scrapeApplyWzApply.jsp");
	}

	// 修改
	function toEdit(){      
		var baseData;
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
		    	$.messager.alert("提示","请先选中一条记录!","warning");
	     		return;
		    }
		// baseData = jcdpCallService("EquipmentSelectionApply", "getEquipmentUnit", "select_model_id="+ids);
		
		//if(baseData.deviceappMap.review_state=='待评审')
		//{
		//	$.messager.alert("提示","您选择的记录中存在状态为'待审批'的单据,不能修改!","warning");
		//	return;
		//}
		//	if(baseData.deviceappMap.review_state=='评审通过')
		//{
		//	$.messager.alert("提示","您选择的记录中存在状态为'审批通过'的单据,不能修改!","warning");
		//	return;
		//}
		popWindowAuto('<%=contextPath%>/dmsManager/scrape/scrapeApplyWzApply.jsp?scrape_apply_wz_id='+ids,'840:650','');
						
	}
	// 删除
	function toDelete(){
		var baseData;
		var ids = getSelIds('selectedbox');
	    if(ids==''){ 
	    	$.messager.alert("提示","请先选中一条记录!","warning");
     		return;
	    } 
		baseData = jcdpCallService("EquipmentSelectionApply", "getEquipmentUnit", "select_model_id="+ids);
		
		//if(baseData.deviceappMap.review_state=='待评审')
		//{
		//	$.messager.alert("提示","您选择的记录中存在状态为'待审批'的单据,不能删除!","warning");
		//	return;
		//}
		//	if(baseData.deviceappMap.review_state=='评审通过')
		//{
		//	$.messager.alert("提示","您选择的记录中存在状态为'审批通过'的单据,不能删除!","warning");
		//	return;
		//}
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("EquipmentSelectionApply", "deleteModelChange", "change_id="+ids);
			if(typeof retObj.operationFlag!="undefined"){
				var dOperationFlag=retObj.operationFlag;
				if(''!=dOperationFlag){
					if("failed"==dOperationFlag){
						alert("删除失败！");
					}	
					if("success"==dOperationFlag){
						alert("删除成功！");
						queryData(cruConfig.currentPage);
					}
				}
			}
		}
	}
	
	// 提交评审
	function toReview(){
		var baseData;
		var ids = getSelIds('selectedbox');
	    if(ids==''){ 
	    	$.messager.alert("提示","请先选中一条记录!","warning");
     		return;
	    }
			
	    baseData = jcdpCallService("EquipmentSelectionApply", "setReview", "select_model_id="+ids);
		 if(baseData.deviceappMap.review_state !='未提交'){
			if(baseData.deviceappMap.review_state=='待评审'){
				$.messager.alert("提示","您选择的记录中存在状态为'待审批'的单据,不能重复提交评审!","warning");
				return;
			}
		 if(baseData.deviceappMap.review_state=='评审通过'){
				$.messager.alert("提示","您选择的记录中存在状态为'审批通过'的单据,不能重复提交评审!","warning");
				return;
			}	
		if(baseData.deviceappMap.review_state =='评审未通过'){
			if(confirm("'您选择的记录中尊在的状态为'评审未通过'的单据,确定提交评审吗?")){
				obj = jcdpCallService("EquipmentSelectionApply", "setReviewPs", "select_model_id="+ids);
				 if(typeof obj.deviceappMap.operationFlag!="undefined"){
						var dOperationFlag=obj.deviceappMap.operationFlag;
						if(''!=dOperationFlag){
							if("success"==dOperationFlag){
								alert("提交评审成功！");
							}
							if("failed"==dOperationFlag){
								alert("提交评审失败！");
							}
						}
					}
				refreshData();
				}
			} 
		 }else{
			obj = jcdpCallService("EquipmentSelectionApply", "setReviewPs", "select_model_id="+ids);
			 if(typeof obj.deviceappMap.operationFlag!="undefined"){
					var dOperationFlag=obj.deviceappMap.operationFlag;
				if(''!=dOperationFlag){
					if("success"==dOperationFlag){
						alert("提交评审成功！");
					}	
					if("failed"==dOperationFlag){
						alert("提交评审失败！");
					}
				}
			}
			refreshData();
			} 
	}
	
	$(document).ready(lashen);
</script>
</html>

