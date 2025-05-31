<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	String businessType=resultMsg.getValue("businessType");
	String isDone=resultMsg.getValue("isDone");
	if(isDone==null||"".equals(isDone)){
		isDone="0";
	}
	String projectInfoNo=resultMsg.getValue("projectInfoNo");
	
	String queryBuilder=resultMsg.getValue("queryBuilder");
	String queryBuilderMean=resultMsg.getValue("queryBuilderMean");
	String listBuilder=resultMsg.getValue("listBuilder");
	String listBuilderMean=resultMsg.getValue("listBuilderMean");
	
	String[] queryBuilders=queryBuilder==null?new String[0]:queryBuilder.split(",");
	String[] queryBuilderMeans=queryBuilderMean==null?new String[0]:queryBuilderMean.split(",");
	String[] listBuilders=listBuilder==null?new String[0]:listBuilder.split(",");
	String[] listBuilderMeans=listBuilderMean==null?new String[0]:listBuilderMean.split(",");
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript"  src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

  <title>大港需求审批</title>
 </head>

 <body style="background:#fff" onload="refreshData()">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">审批状态</td>
			    <td class="ali_cdn_input">
			    <select id="isdone" class="input_width">
			    	<option value="0"  <%=isDone.equals("0")?"selected='selected'":""%>>待审批</option>
			    	<option value="1" <%=isDone.equals("1")?"selected='selected'":""%>>已审批</option>
			    </select>
			    </td>
			    <%for(int i=0;i<listBuilders.length&&"项目名称".equals(listBuilderMeans[i])&&(projectInfoNo==null||"".equals(projectInfoNo));i++) {
				     %>
	       			<td class="ali_cdn_name">项目名称</td>
			    	<td class="ali_cdn_input"><input type="text" id="projectName" name="projectName"/></td>
	   			<%} %>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
				<td>&nbsp;</td>
			    <auth:ListButton  css="dk" event="onclick='toAudit()'" title="JCDP_btn_audit"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			     <tr>
			     <%int j=0;%>
			      <td class="bt_info_odd"  exp="<input type='checkbox' name='rdo_entity_id' value='{businessId}@{entityId}@{procinstId}@{taskinstId}@{businessType}@{nodeLink}@{nodeLinkType}' id='rdo_entity_id_{cost_project_schema_id}'  onclick='chooseOne(this)' />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			       <%for(int i=0;i<listBuilders.length&&"项目名称".equals(listBuilderMeans[i]);i++) {
			      		String className="bt_info_odd";
				     %>
	       			<td class="<%=className%>" exp="{<%=listBuilders[i] %>}"><%= listBuilderMeans[i]%></th>
	   			  <%} %>
	   			  <td class="<%=j==0?"bt_info_odd":"bt_info_even"%>" exp="{planName}">计划名称</td>
			      <td class="<%=j==0?"bt_info_odd":"bt_info_even"%>" exp="{totalMoney}">计划金额</td>
			      <td class="<%=j==0?"bt_info_odd":"bt_info_even"%>" exp="{plan_invoice_type}">计划指向</td>
			      <td class="<%=j==0?"bt_info_odd":"bt_info_even"%>" exp="{submiteNumber}">申请单号</td>
			      <td class="<%=j==0?"bt_info_odd":"bt_info_even"%>" exp="{username}">申请人</td>
			      <td class="<%=j==0?"bt_info_odd":"bt_info_even"%>" exp="{currentcreateDate}">提交时间</td>
			      <td class="<%=j==0?"bt_info_odd":"bt_info_even"%>" exp="{state}">审批状态</td>
			      <%for(int i=0;i<listBuilders.length;i++) {
			      		String className="";
			    	  	if(i%2==0){
			    	  		className=j==0?"bt_info_even":"bt_info_odd";
				      	}else{
				      		className=j==0?"bt_info_odd":"bt_info_even";
				      	}
			    	  	if(!"项目名称".equals(listBuilderMeans[i])){
				     %>
	       			<td class="<%=className%>" exp="{<%=listBuilders[i] %>}"><%= listBuilderMeans[i]%></th>
	   			  <%	}
			    	  }%>
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
			</div>
		<div id="tag-container_3">
		<ul id="tags" class="tags">
			<li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">审批明细</a></li>
			<!-- <li id="tag3_1"><a href="#" onclick="getTab3(1)">明细信息</a></li> -->
			<li id="tag3_2"><a href="#" onclick="getTab3(2)">审批流程</a></li>
		</ul>
		</div>
		
		<div id="tab_box" class="tab_box">
		<div id="tab_box_content0" class="tab_box_content">
		<input type='hidden' id="plan_id" value=''/>
		<table border="0" cellpadding="0" cellspacing="0" id = "taskTable"
			class="tab_line_height" width="100%" style="background: #efefef">
			<tr>
		<!-- 		<td class="bt_info_odd" exp="<input type='checkbox' name='task_entity_id' 
				value='' onclick=doCheck(this)/>" >
			    <input type='checkbox' name='task_entity_id' value='' onclick='check()'/></td>
		 -->	    
				<td class="bt_info_odd">序号</td>
				<td class="bt_info_even">物资名称</td>
				<td class="bt_info_odd">计量单位</td>
				<td class="bt_info_even">需求数量</td>
				<td class="bt_info_odd">参考单价</td>
				<!--<td class="bt_info_even">现有数量</td>
			
				 <td class="bt_info_odd">可调计量</td>
				<td class="bt_info_even">合计申请量</td> -->
				<td class="bt_info_odd">计划金额</td>
				<!-- 
				<td class="bt_info_even"  exp="<input name = 'rdo_number' id='rdo_number' type='text'  value='0' onchange='setMoney()' style='width:40px;'/>">审批数量</td>
				<td class="bt_info_odd" exp="{wz_price}">参考单价</td> 
				<td class="bt_info_even" exp="0">审批金额</td>
				<td class="bt_info_odd" exp="">出库单位</td>
				
				 -->
							
			</tr>
		</table>
		</div>
		<div id="tab_box_content2" class="tab_box_content"
			>
		<table id="projectMap" width="100%" border="0" cellspacing="0"
			cellpadding="0" class="tab_line_height">
			<tr>
				<td class="bt_info_odd">业务环节</td>
				<td class="bt_info_even">审批情况</td>
				<td class="bt_info_odd">审批意见</td>
				<td class="bt_info_even">审批人</td>
				<td class="bt_info_odd">审批时间</td>
			</tr>
		</table>
		</div>
		
</body>

<script type="text/javascript">


	$(document).ready(readyForSetHeight);

	frameSize();
	
	$(document).ready(lashen);

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryService = "WFCommonSrv";
	cruConfig.queryOp = "getWFProcessListDg";
	 <%
	    if(businessType!=null&&!"".equals(businessType)){
	    %>
	    	cruConfig.submitStr="businessType=<%=businessType==null?"":businessType%>";
	    <%
	    }
	 %>
	 function simpleSearch(){
		 refreshData(1);
	 }
	function refreshData(ids){
		if(ids==undefined||ids==""||ids==null) ids=cruConfig.currentPage;
		var submitStr = "currentPage="+ids+"&pageSize="+cruConfig.pageSize;
		cruConfig.submitStr=("&isDone="+$("#isdone").val());
		if($("#projectName").val()!=null&&$("#projectName").val()!=''&&$("#projectName").val()!=undefined){
			cruConfig.submitStr+="&wfVar_projectName="+$("#projectName").val();
		}
		<%
			if(projectInfoNo!=null&&!"".equals(projectInfoNo)){
		%>
		cruConfig.submitStr+="&projectInfoNo=<%=projectInfoNo%>";
		 <%
	    }
		 %>
		<%
	    if(businessType!=null&&!"".equals(businessType)){
	    %>
	    	cruConfig.submitStr+="&businessType=<%=businessType%>";
	    <%
	    }
		 %>
	    cruConfig.currentPageUrl = "/bpm/common/toGetSelfProcessListDg.srq";
	    queryData(ids);
	    //top.frames("footFrame").setProcNums();
	}
	function loadDataDetail(ids){
		var datas=ids.split("@");
		var procinstId=datas[2];
		var  numbers=datas[5];
		//获取审批信息
		for(var j =1;j <document.getElementById("projectMap")!=null && j < document.getElementById("projectMap").rows.length ;){
			document.getElementById("projectMap").deleteRow(j);
		}
		var getProcessDgwt = jcdpCallService("MatItemSrv", "getProcessDgwt", "procinstId="+procinstId);
		var process = getProcessDgwt.list;
		for(var i =0; process!=null && i < process.length; i++){
			debugger;
			var nodeName = process[i].node_name;
			var curState = process[i].curstate;
			var examine_user_name = process[i].examine_user_name;
			var examine_start_date = process[i].examine_start_date;
			var examine_info = process[i].examine_info;
			
			var autoOrders = document.getElementById("projectMap").rows.length;
			var newTR = document.getElementById("projectMap").insertRow(autoOrders);
				var tdClass = 'even';
				if(autoOrder%2==0){
					tdClass = 'odd';
				}
				
	
		        var td = newTR.insertCell(0);
		        td.innerHTML = nodeName;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}

		        var td = newTR.insertCell(1);
		        td.innerHTML = curState;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}

		        var td = newTR.insertCell(2);
		        td.innerHTML = examine_info;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}

		        var td = newTR.insertCell(3);
		        td.innerHTML = examine_user_name;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}

		        var td = newTR.insertCell(4);
		        td.innerHTML = examine_start_date;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}

			}

		//物资信息
		for(var j =1;j <document.getElementById("taskTable")!=null && j < document.getElementById("taskTable").rows.length ;){
			document.getElementById("taskTable").deleteRow(j);
		}
		var retObj = jcdpCallService("MatItemSrv", "findPlanDgwt", "ids="+numbers);
		var taskList = retObj.list;
		for(var i =0; taskList!=null && i < taskList.length; i++){
			var wzName = taskList[i].wz_name;
			var demandNum = taskList[i].approve_num;
			var wzPrickie = taskList[i].wz_prickie;
			var wzPrice = taskList[i].wz_price;
			var approveNum=taskList[i].approve_num;
			var autoOrder = document.getElementById("taskTable").rows.length;
			var newTR = document.getElementById("taskTable").insertRow(autoOrder);
			var tdClass = 'even';
			if(autoOrder%2==0){
				tdClass = 'odd';
			}
			

	        var td = newTR.insertCell(0);
	        td.innerHTML = autoOrder;
	        td.className =tdClass+'_even'
	        if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}
	        
	        td = newTR.insertCell(1);
			
	        td.innerHTML = wzName;
	        td.className = tdClass+'_odd';
	        if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
	        
	        td = newTR.insertCell(2);

	        td.innerHTML = wzPrickie;
	        td.className =tdClass+'_even'
	        if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}
			td = newTR.insertCell(3);
			
	        td.innerHTML = demandNum;
	        td.className = tdClass+'_odd';
	        if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
	        td = newTR.insertCell(4);

	        td.innerHTML = wzPrice;
	        td.className =tdClass+'_even'
	        if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}
	        td = newTR.insertCell(5);
	        td.innerHTML = Math.round(demandNum * wzPrice);
	        td.className =tdClass+'_odd'
	        if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}
	        //td = newTR.insertCell(6);
	       // td.innerHTML = approveNum;
	        //td.className =tdClass+'_even'
	       // if(autoOrder%2==0){
			//	td.style.background = "#FFFFFF";
			//}else{
			//	td.style.background = "#ebebeb";
			//		}
	       // td = newTR.insertCell(7);

	       // td.innerHTML = wzPrice;
	       // td.className =tdClass+'_odd'
	      //  if(autoOrder%2==0){
			//	td.style.background = "#FFFFFF";
			//}else{
			//	td.style.background = "#ebebeb";
			//}
	      //  td = newTR.insertCell(8);
	      //  td.innerHTML = Math.round(demandNum * wzPrice);
	      //  td.className =tdClass+'_even'
	        if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}
			
	        newTR.onclick = function(){
	        	// 取消之前高亮的行
	       		for(var i=1;i<document.getElementById("taskTable").rows.length;i++){
	    			var oldTr = document.getElementById("taskTable").rows[i];
	    			var cells = oldTr.cells;
	    			for(var j=0;j<cells.length;j++){
	    				cells[j].style.background="#96baf6";
	    				// 设置列样式
	    				if(i%2==0){
	    					if(j%2==1) cells[j].style.background = "#FFFFFF";
	    					else cells[j].style.background = "#f6f6f6";
	    				}else{
	    					if(j%2==1) cells[j].style.background = "#ebebeb";
	    					else cells[j].style.background = "#e3e3e3";
	    				}
	    			}
	       		}
				// 设置新行高亮
				var cells = this.cells;
				for(var i=0;i<cells.length;i++){
					cells[i].style.background="#ffc580";
				}
			}
		}
	}
	function toAudit(){
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		var datas=ids.split("@");
		var businessId=datas[0];
		var entityId=datas[1];
		var procinstId=datas[2];
		var taskinstId=datas[3];
		var businessType=datas[4];
		var nodeLink=datas[5];
		var nodeLinkType=datas[6];
		var isdone=$("#isdone").val();
		if(isdone==1){
			//if(nodeLinkType!='1'){
			//var editUrl = "/bpm/common/toGetProcessInfoView.srq?taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
			//window.showModalDialog(cruConfig.contextPath+editUrl,window,"dialogWidth=800px;dialogHeight=600px")
			//}else{
			//	nodeLink=nodeLink+"&taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
			//	window.showModalDialog(cruConfig.contextPath+nodeLink,window,"dialogWidth=800px;dialogHeight=600px")
			//}
		}else{
			if(nodeLinkType!='1'){
			var editUrl = "/bpm/common/toGetProcessInfo.srq?taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
			window.showModalDialog(cruConfig.contextPath+editUrl,window,"dialogWidth=800px;dialogHeight=600px")
			}else{
				nodeLink=nodeLink+"&taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
				window.showModalDialog(cruConfig.contextPath+nodeLink,window,"dialogWidth=900px;dialogHeight=600px")
			}
		}
		//alert("操作成功");
		 simpleSearch();
		
	}
	function dbclickRow(ids){
		var datas=ids.split("@");
		var businessId=datas[0];
		var entityId=datas[1];
		var procinstId=datas[2];
		var taskinstId=datas[3];
		var businessType=datas[4];
		var nodeLink=datas[5];
		var nodeLinkType=datas[6];
		var isdone=$("#isdone").val();
		if(isdone==1){
			//if(nodeLinkType!='1'){
			//var editUrl = "/bpm/common/toGetProcessInfoView.srq?taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
			//window.showModalDialog(cruConfig.contextPath+editUrl,window,"dialogWidth=800px;dialogHeight=600px")
			//}else{
			//	nodeLink=nodeLink+"&taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
			//	window.showModalDialog(cruConfig.contextPath+nodeLink,window,"dialogWidth=800px;dialogHeight=600px")
			//}
		}else{
			if(nodeLinkType!='1'){
			var editUrl = "/bpm/common/toGetProcessInfo.srq?taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
			window.showModalDialog(cruConfig.contextPath+editUrl,window,"dialogWidth=800px;dialogHeight=600px")
			}else{
				nodeLink=nodeLink+"&taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
				window.showModalDialog(cruConfig.contextPath+nodeLink,window,"dialogWidth=900px;dialogHeight=600px")
			}
		}
		//alert("操作成功");
		 simpleSearch();
	}
	function chooseOne(cb){   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    }


</script>
</html>