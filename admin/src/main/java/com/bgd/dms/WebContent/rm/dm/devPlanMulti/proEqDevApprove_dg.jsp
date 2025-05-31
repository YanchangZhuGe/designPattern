<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
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
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

  <title>多项目-计划审批-自有设备申请-审批(大港)</title>
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
			      <td class="bt_info_odd"  exp="<input type='checkbox' name='rdo_entity_id' value='{businessId}@{entityId}@{procinstId}@{taskinstId}@{businessType}@{nodeLink}@{nodeLinkType}@{device_allapp_id}' id='rdo_entity_id_{cost_project_schema_id}' onclick='chooseOne(this)' />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			       <%for(int i=0;i<listBuilders.length&&"项目名称".equals(listBuilderMeans[i]);i++) {
			      		String className="bt_info_odd";
				     %>
	       			<td class="<%=className%>" exp="{<%=listBuilders[i] %>}"><%= listBuilderMeans[i]%></th>
	   			  <%} %>
			      <td class="<%=j==0?"bt_info_odd":"bt_info_even"%>" exp="{project_name}">项目名称</td>
	   			  <td class="<%=j==0?"bt_info_odd":"bt_info_even"%>" exp="{device_allapp_no}">计划单号</td>
	   			  <td class="<%=j==0?"bt_info_odd":"bt_info_even"%>" exp="{device_allapp_name}">计划名称</td>
			      <td class="<%=j==0?"bt_info_odd":"bt_info_even"%>" exp="{org_name}">申请单位名称</td>
			      <td class="<%=j==0?"bt_info_odd":"bt_info_even"%>" exp="{allapp_type}">申请单类型</td>
			      <td class="<%=j==0?"bt_info_odd":"bt_info_even"%>" exp="{appdate}">提交时间</td>
			      <td class="<%=j==0?"bt_info_odd":"bt_info_even"%>" exp="{state_desc}">审批状态</td>
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
		 <div id="tag-container_3">
			<ul id="tags" class="tags">
				<li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">审批明细</a></li>
				<li id="tag3_1"><a href="#" onclick="getTab3(1)">审批流程</a></li>
			</ul>
		</div>
		
		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" class="tab_box_content">
					<table border="0" cellpadding="0" cellspacing="0" id = "taskTable"
							class="tab_line_height" width="100%" style="background: #efefef">
						<tr>	 
		 					<td class="bt_info_even">序号</td>   
							<td class="bt_info_odd">项目名称</td>
							<td class="bt_info_even">班组</td>
							<td class="bt_info_odd">设备名称</td>
							<td class="bt_info_even">型号</td>
							<td class="bt_info_odd">单位</td>
							<td class="bt_info_even">申请数量</td>
							<td class="bt_info_even">申请人</td>
							<td class="bt_info_odd">用途</td>
							<td class="bt_info_even">计划开始时间</td>
							<td class="bt_info_odd">计划结束时间</td>							
						</tr>
					</table>
			</div>
			<div id="tab_box_content1" class="tab_box_content" style="display:none">
				<wf:startProcessInfo title=""/>
			</div>
		</div>
</body>

<script type="text/javascript">

	$(document).ready(readyForSetHeight);
	frameSize();	
	$(document).ready(lashen);
	var dgflag = 'Y';
	var projectInfoNos = '<%=projectInfoNo%>';
	
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryService = "WFCommonSrv";
	cruConfig.queryOp = "getWFProcessListDevDg";
	 <%
	    if(businessType!=null&&!"".equals(businessType)){
	 %>
	    cruConfig.submitStr="businessType=<%=businessType==null?"":businessType%>";
	    //cruConfig.submitStr="businessType=5110000004100000119,5110000004100000113,5110000004100000120";
	    
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
	   // cruConfig.submitStr="businessType=5110000004100000119,5110000004100000113,5110000004100000120";
	    
	    cruConfig.submitStr+="&businessType=<%=businessType%>";
	    <%
	    }
		 %>
	    cruConfig.currentPageUrl = "/bpm/common/toGetSelfProcessListDevDgPro.srq";
	    queryData(ids);
	    //parent.frames("footFrame").setProcNums();
	}

	function getdate() { 
		var   now=new   Date() 
		y=now.getFullYear() 
		m=now.getMonth()+1 
		d=now.getDate() 
		m=m <10? "0"+m:m 
		d=d <10? "0"+d:d 
		return   y + "-" + m + "-" + d ;
	}
	
	function loadDataDetail(ids){
		var datas=ids.split("@");
		var deviceallappid_tmp=datas[7];
		
		for(var j =1;j <document.getElementById("taskTable")!=null && j < document.getElementById("taskTable").rows.length ;){
			document.getElementById("taskTable").deleteRow(j);
		}

		if(deviceallappid_tmp!=null){
			var retObj = jcdpCallService("DevCommInfoSrv", "getDevAllAppBaseInfoDg", "deviceallappid="+deviceallappid_tmp);
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("DevCommInfoSrv", "getDevAllAppBaseInfoDg", "deviceallappid="+deviceallappid_tmp);
		}

		//选中这一条checkbox
		//$("#selectedbox_"+retObj.deviceappMap.device_allapp_id).attr("checked","checked");
			
		var taskList = retObj.list;
		var projectName;
		var deviceAllAppName;
		var allappType;
		var businessTypeDg;
		
		for(var i =0; taskList!=null && i < taskList.length; i++){
			 projectName = taskList[i].project_name;
			 deviceAllAppName = taskList[i].device_allapp_name
			 allappType = taskList[i].allapp_type;
			var teamName = taskList[i].teamname;
			var devCiName = taskList[i].dev_ci_name;
			var devCiCode = taskList[i].dev_ci_model;
			var unitName=taskList[i].unitname;
			var applyNum=taskList[i].apply_num;
			var employeeName=taskList[i].employee_name;
			var purPose=taskList[i].purpose;
			var planStartDate=taskList[i].plan_start_date;
			var planEndDate=taskList[i].plan_end_date;
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
	        td.innerHTML = projectName;
	        td.className = tdClass+'_odd';
	        if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
	        
	        td = newTR.insertCell(2);
	        td.innerHTML = teamName;
	        td.className =tdClass+'_even'
	        if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}
			
			td = newTR.insertCell(3);			
	        td.innerHTML = devCiName;
	        td.className = tdClass+'_odd';
	        if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
			
	        td = newTR.insertCell(4);
	        td.innerHTML = devCiCode;
	        td.className =tdClass+'_even'
	        if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}
			
	        td = newTR.insertCell(5);
	        td.innerHTML = unitName;
	        td.className =tdClass+'_odd'
	        if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}
			
	        td = newTR.insertCell(6);
	        td.innerHTML = applyNum;
	        td.className =tdClass+'_even'
	        if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}
			
	        td = newTR.insertCell(7);
	        td.innerHTML = employeeName;
	        td.className =tdClass+'_even'
	        if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}

	        td = newTR.insertCell(8);
	        td.innerHTML = purPose;
	        td.className =tdClass+'_even'
	        if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}

	        td = newTR.insertCell(9);
	        td.innerHTML = planStartDate;
	        td.className =tdClass+'_even'
	        if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}

	        td = newTR.insertCell(10);
	        td.innerHTML = planEndDate;
	        td.className =tdClass+'_even'
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

		if(allappType=='S1405'){
			businessTypeDg='5110000004100001031';
		}else if(allappType=='S1404'){
			businessTypeDg='5110000004100001028';
		}else if(allappType='S0623'){//震源
			businessTypeDg='5110000004100001029';
		}
				
		//工作流信息
		var submitdate =getdate();
        processNecessaryInfo={        							//流程引擎关键信息
        			businessTableName:"gms_device_allapp",    			//置入流程管控的业务表的主表表明
        			businessType:businessTypeDg,    //业务类型 即为之前设置的业务大类
        			businessId:deviceallappid_tmp,           				//业务主表主键值
        			businessInfo:"设备配置计划审批列表信息<配置计划单名称:"+deviceAllAppName+">",
        			applicantDate:submitdate       						//流程发起时间
        		};

		processAppendInfo={ 
			projectName:projectName,								//流程引擎附加临时变量信息
			projectInfoNo:projectInfoNos,
			deviceaddappid:deviceallappid_tmp
		};
    	loadProcessHistoryInfo();
	}

	function chooseOne(cb){   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
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
		var device_allapp_id=datas[7];
		var isdone=$("#isdone").val();
		if(isdone==1){
			if(nodeLinkType!='1'){
			var editUrl = "/bpm/common/toGetProcessInfoView.srq?taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
			window.showModalDialog(cruConfig.contextPath+editUrl,window,"dialogWidth=800px;dialogHeight=600px")
			}else{
				nodeLink=nodeLink+"&taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>&isDone="+isdone;
					window.showModalDialog(cruConfig.contextPath+nodeLink,window,"dialogWidth=800px;dialogHeight=600px")
			}
		}else{
			if(nodeLinkType!='1'){
			var editUrl = "/bpm/common/toGetProcessInfo.srq?taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
			window.showModalDialog(cruConfig.contextPath+editUrl,window,"dialogWidth=800px;dialogHeight=600px")

			}else{
				nodeLink=nodeLink+"&taskinstId="+taskinstId+"&businessId="+businessId+"&device_allapp_id="+device_allapp_id+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>&isDone="+isdone;
				window.showModalDialog(cruConfig.contextPath+nodeLink,window,"dialogWidth=1024px;dialogHeight=768px")

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
		var device_allapp_id=datas[7];
		var isdone=$("#isdone").val();

		if(isdone==1){
			if(nodeLinkType!='1'){
			var editUrl = "/bpm/common/toGetProcessInfoView.srq?taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
			window.showModalDialog(cruConfig.contextPath+editUrl,window,"dialogWidth=800px;dialogHeight=600px")
			}else{
				nodeLink=nodeLink+"&taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>&isDone="+isdone;
					window.showModalDialog(cruConfig.contextPath+nodeLink,window,"dialogWidth=800px;dialogHeight=600px")
			}
		}else{
			if(nodeLinkType!='1'){
			var editUrl = "/bpm/common/toGetProcessInfo.srq?taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
			window.showModalDialog(cruConfig.contextPath+editUrl,window,"dialogWidth=800px;dialogHeight=600px")

			}else{
				//nodeLink=nodeLink+"&dgflag="+dgflag+"&deviceallappid="+device_allapp_id+"&taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
				//window.showModalDialog(cruConfig.contextPath+"/rm/dm/getDevAllAppInfosForProcwfpgDg.srq?"+nodeLink.substring(60),window,"dialogWidth=900px;dialogHeight=600px")
				nodeLink=nodeLink+"&taskinstId="+taskinstId+"&businessId="+businessId+"&device_allapp_id="+device_allapp_id+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>&isDone="+isdone;

					window.showModalDialog(cruConfig.contextPath+nodeLink,window,"dialogWidth=1024px;dialogHeight=768px")

				}
		}
		 simpleSearch();
			
	}
</script>
</html>