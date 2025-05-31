<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String dispose_apply_id = request.getParameter("dispose_apply_id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<%@include file="/common/include/processresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

  <title>处置申请</title>
 </head> 
 
 <body style="background:#fff" onload="refreshData('','','<%=dispose_apply_id%>')">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			   <td class="ali_cdn_name">申请单名称</td>
			    <td class="ali_cdn_input">
			    	<input id="app_name" name="app_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">处置申请单号</td>
			    <td class="ali_cdn_input">
			    	<input id="app_no" name="app_no" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td width="50%">&nbsp;</td>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='dispose_apply_id{dispose_apply_id}' name='dispose_apply_id' ondblclick='toModifyDetail(this)' idinfo='{dispose_apply_id}'>
			     	<td class="bt_info_odd" exp="<input type='radio' name='selectedbox' value='{dispose_apply_id}' id='selectedbox_{dispose_apply_id}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{app_no}">处置申请单单号</td>
					<td class="bt_info_even" exp="{app_name}">处置申请单名称</td>
					<td class="bt_info_even" exp="{org_name}">申请单位名称</td>
					<td class="bt_info_odd" exp="{employee_name}">申请人</td>
					<td class="bt_info_even" exp="{apply_date}">申请时间</td>
					<td class="bt_info_odd" exp="{apply_status}">状态</td>
					<td class="bt_info_odd" exp="{sum_asset}">累计原值</td>
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
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">明细信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,2)">审批流程</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="scrapeMap" name="scrapeMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">设备报废处置单号：</td>
				      <td  class="inquire_form6" ><input id="app_no" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">设备报废单名称：</td>
				      <td  class="inquire_form6"><input id="app_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;申请单位：</td>
				      <td  class="inquire_form6"  ><input id="org_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				    <tr>
				      <td  class="inquire_item6">申请人：</td>
				      <td  class="inquire_form6"><input id="employee_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;申请时间：</td>
				      <td  class="inquire_form6"  ><input id="apply_date" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;备注：</td>
				      <td  class="inquire_form6"  ><input id="bak" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
					</table>
				</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
						  <td class="bt_info_odd">序号</td>
				          <td class="bt_info_even">资产编码</td>
					      <td class="bt_info_odd">设备编号</td>
					      <td class="bt_info_even">设备名称</td>
					      <td class="bt_info_odd">规格型号</td>
					      <td class="bt_info_even">牌照号</td>
					      <td class="bt_info_odd">启用时间</td>
					      <td class="bt_info_even">折旧年限</td>
					      <td class="bt_info_odd">所属单位</td>
					     <!--  <td class="bt_info_even">经理部</td>
					      <td class="bt_info_odd">部门/小队</td>
					      <td class="bt_info_even">数量</td> -->
					      <td class="bt_info_odd">原值</td>
					      <td class="bt_info_even">累计折旧</td>
					      <td class="bt_info_odd">减值准备</td>
					      <td class="bt_info_even">净额</td>
					      <td class="bt_info_odd">报废原因</td>
					      <td class="bt_info_even">责任单位</td>
					      <td class="bt_info_odd">部门名称</td>
				        </tr> 
				        <tbody id="detailMap" name="detailMap" ></tbody>
					</table>
				</div>
					<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none;">
				<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>
			</div>
			<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
			</div>
		
		 </div>
</div>
</body>
<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "ScrapeSrv";
	cruConfig.queryOp = "queryDisposeList";
	var path = "<%=contextPath%>";
	var activity_type="1";//流程类别设置，默认1普通流程，2千万级流程
	var curbusinesstype="5110000181000000029";//流程默认的类别普通类


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
	function searchDevData(){
		var app_no = document.getElementById("app_no").value;
		var app_name = document.getElementById("app_name").value;
		refreshData(app_no, app_name,'');
	}
	function clearQueryText(){
		document.getElementById("app_no").value = "";
		document.getElementById("app_name").value = "";
		refreshData("", "",'');
	}
    function refreshData(app_no, app_name,dispose_apply_id){
      	var temp = "";
		if(typeof app_no!="undefined" && app_no!=""){
			temp += "&app_no="+app_no;
		}
		if(typeof app_name!="undefined" && app_name!=""){
			temp += "&app_name="+app_name;
		}
		if(typeof dispose_apply_id!="undefined" && dispose_apply_id!=""){
			temp += "&dispose_apply_id="+dispose_apply_id;
		}
		cruConfig.submitStr = temp;	
		queryData(1);
	}
    function loadDataDetail(dispose_apply_id){
    	var retObj;
		if(dispose_apply_id!=null){
			 retObj = jcdpCallService("ScrapeSrv", "getDisposeInfo", "dispose_apply_id="+dispose_apply_id);
			
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("ScrapeSrv", "getDisposeInfo", "dispose_apply_id="+ids);
		}
		//选中这一条checkbox
		$("#selectedbox_"+retObj.deviceMap.dispose_apply_id).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceMap.dispose_apply_id+"']").removeAttr("checked");
		//给数据回填
		$("#app_no","#scrapeMap").val(retObj.deviceMap.app_no);
		$("#app_name","#scrapeMap").val(retObj.deviceMap.app_name);
		$("#apply_date","#scrapeMap").val(retObj.deviceMap.apply_date);
		$("#employee_name","#scrapeMap").val(retObj.deviceMap.employee_name);
		$("#org_name","#scrapeMap").val(retObj.deviceMap.org_name);
		$("#bak","#scrapeMap").val(retObj.deviceMap.bak);
		
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
		getProcessInfo(dispose_apply_id);
    }
    function getProcessInfo(dispose_apply_id){
    	//工作流信息
		var submitdate =getdate();
		if(activity_type=="2"){
			curbusinesstype="5110000181000000030";
		}
    	processNecessaryInfo={        							//流程引擎关键信息
			businessTableName:"dms_dispose_apply",    			//置入流程管控的业务表的主表表明
			businessType:curbusinesstype,    				//业务类型 即为之前设置的业务大类
			businessId:dispose_apply_id,           			//业务主表主键值
			businessInfo:"报废处置申请审批流程>报废处置申请单名称:"+app_name+";报废申请单号:"+app_no+">",
			applicantDate:submitdate       						//流程发起时间
		};
		processAppendInfo={ 
			dispose_apply_id:dispose_apply_id
		};
		loadProcessHistoryInfo();
		activity_type="1";
    }
	function toAddDisposePage(){
		popWindow('<%=contextPath%>/dmsManager/scrape/disposeApplyAdd.jsp','','新增报废处置申请');
	}
	function toModifyDisposePage(){
		var baseData;
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		 baseData = jcdpCallService("ScrapeSrv", "getDisposeState", "dispose_apply_id="+ids);
		
		if(baseData.deviceappMap.proc_status=='1')
		{
			alert("您选择的记录中存在状态为'待审批'的单据,不能修改!");
			return;
		}
			if(baseData.deviceappMap.proc_status=='3')
		{
			alert("您选择的记录中存在状态为'审批通过'的单据,不能修改!");
			return;
		}
	popWindow('<%=contextPath%>/dmsManager/scrape/disposeApplyAdd.jsp?dispose_apply_id='+ids);
	}
	function toDelDisposePage(){
		var baseData;
		var retObj;
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		 baseData = jcdpCallService("ScrapeSrv", "getDisposeState", "dispose_apply_id="+ids);
		
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
			retObj = jcdpCallService("ScrapeSrv", "deleteDisposeInfo", "dispose_apply_id="+ids);
			alert('删除成功!');
			refreshData();
		}
	}
	function toSumbitDisposeApp(){
			var retObj;
			var baseData;
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		 baseData = jcdpCallService("ScrapeSrv", "getDisposeState", "dispose_apply_id="+ids);
		
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
		    
		
	if (window.confirm("确认要提交吗?")) {
		//alert("baseData.sum_asset="+baseData.sum_asset);
		if(baseData.sum_asset>10000000)
		activity_type="2";
		getProcessInfo(ids);
		//发起工作流的方法
		submitProcessInfo();
		alert('提交成功!');
		activity_type="1";
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
			var retObj;
		   retObj = jcdpCallService("ScrapeSrv", "getDisposeInfo", "dispose_apply_id="+ids);
		   basedatas = retObj.datas;
		  	$(filtermapid).empty();
		   if(basedatas!=undefined && basedatas.length>=1){
					//先清空
					var filtermapid = "#detailMap";
					$(filtermapid).empty();
					appendDataToDetailTab(filtermapid,basedatas);
					//设置当前标签页显示的主键
					$(filterobj).attr("idinfo",currentid);
				}else{
					var filtermapid = "#detailMap";
					$(filtermapid).empty();
					$(filterobj).attr("idinfo",currentid);
				}
		}
		else if(index == 3){
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid);
		}
		$(filternotobj).hide();
		$(filterobj).show();
	}
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<datas.length;i++){
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
		/* 	innerHTML += "<td>/</td>";
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
	function getdate() { 
		var   now=new   Date() 
		y=now.getFullYear() 
		m=now.getMonth()+1 
		d=now.getDate() 
		m=m <10? "0"+m:m 
		d=d <10? "0"+d:d 
		return   y + "-" + m + "-" + d ;
	}
	/* 通过的可以查看*/
	 function toDisposePage(){
		 var baseData;
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	  		return;
		    }
		    baseData = jcdpCallService("ScrapeSrv", "getDisposeState", "dispose_apply_id="+ids);
		
		/* if(baseData.deviceappMap.proc_status=='1')
		{
			alert("您选择的记录中存在状态为'待审批'的单据,不能修改!");
			return;
		}
			if(baseData.deviceappMap.proc_status=='3')
		{
			alert("您选择的记录中存在状态为'审批通过'的单据,不能修改!");
			return;
		} */
		popWindow('<%=contextPath%>/dmsManager/scrape/disposeApplySee.jsp?dispose_apply_id='+ids);
		
	 }
</script>
</html>