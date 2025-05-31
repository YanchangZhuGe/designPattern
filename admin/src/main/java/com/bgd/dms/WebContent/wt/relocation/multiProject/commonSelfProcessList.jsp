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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>


  <title>项目费用方案管理</title>
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
			    <auth:ListButton functionId="" css="dc" event="onclick='toPrint()'" title="打印动迁通知书"></auth:ListButton>
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
			      <td class="bt_info_odd"  exp="<input type='checkbox' name='rdo_entity_id' value='{businessId}@{entityId}@{procinstId}@{taskinstId}@{businessType}@{nodeLink}@{nodeLinkType}@{wfVar_projectInfoNo}' id='rdo_entity_id_{cost_project_schema_id}'   />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			       <%for(int i=0;i<listBuilders.length&&"项目名称".equals(listBuilderMeans[i]);i++) {
			      		String className="bt_info_odd";
				     %>
	       			<td class="<%=className%>" exp="{<%=listBuilders[i] %>}"><%= listBuilderMeans[i]%></th>
	   			  <%} %>
			      <td class="<%=j==0?"bt_info_odd":"bt_info_even"%>" exp="{currentProcName}">流程名称</td>
			      <td class="<%=j==0?"bt_info_odd":"bt_info_even"%>" exp="{currentNode}">当前环节</td>
			      <td class="<%=j==0?"bt_info_odd":"bt_info_even"%>" exp="{businessInfo}">业务信息</td>
			      <td class="<%=j==0?"bt_info_odd":"bt_info_even"%>" exp="{examineUserName}">当前审批人</td>
			      <td class="<%=j==0?"bt_info_odd":"bt_info_even"%>" exp="{currentcreateDate}">提交时间</td>
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
				    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">流程审批历史信息</a></li>
				    <li id="tag3_1"><a href="#" onclick="getTab3(1)">流程轨迹</a></li>
				  </ul>
			</div>
			<div id="tab_box" class="tab_box" style="overflow:hidden;">
				    <div id="tab_box_content0" class="tab_box_content">
					<table id="processInfoTab" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;">
						<tr class="bt_info">
							<td>业务环节</td>
							<td>审批情况</td>
							<td>审批意见</td>
							<td>审批人</td>
							<td>审批时间</td>
						</tr>
					</table>
					</div>
				    <div id="tab_box_content1" class="tab_box_content">
				    	<iframe width="100%" height="100%" name="wfPic" id="wfPic" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
				    </div>
			</div>
</body>

<script type="text/javascript">
debugger;



	$(document).ready(readyForSetHeight);

	frameSize();
	
	$(document).ready(lashen);

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryService = "WFCommonSrv";
	cruConfig.queryOp = "getWFProcessList";
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
	    cruConfig.currentPageUrl = "/bpm/common/toGetSelfProcessList.srq";
	    queryData(ids);
	    //top.frames("footFrame").setProcNums();
	}
	function loadDataDetail(ids){
		var datas=ids.split("@");
		var businessId=datas[0];
		var entityId=datas[1];
		var procinstId=datas[2];
		var taskinstId=datas[3];
		var businessType=datas[4];
		var nodeLink=datas[5];
		var nodeLinkType=datas[6];
		//获取流程历史信息
		processNecessaryInfo.businessTableName="";
		processNecessaryInfo.businessType=businessType;
		processNecessaryInfo.businessId=businessId;
		loadProcessHistoryInfo();
		
		
		
		//载入流程轨迹信息
		document.getElementById("wfPic").src="<%=contextPath + "/BPM/viewProcinst.jsp?procinstId="%>"+procinstId;
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
			if(nodeLinkType!='1'){
			var editUrl = "/bpm/common/toGetProcessInfoView.srq?taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
			window.showModalDialog(cruConfig.contextPath+editUrl,window,"dialogWidth=800px;dialogHeight=600px")
			}else{
				nodeLink=nodeLink+"&taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
				window.showModalDialog(cruConfig.contextPath+nodeLink,window,"dialogWidth=800px;dialogHeight=600px")
			}
		}else{
			if(nodeLinkType!='1'){
			var editUrl = "/bpm/common/toGetProcessInfo.srq?taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
			window.showModalDialog(cruConfig.contextPath+editUrl,window,"dialogWidth=800px;dialogHeight=600px")
			}else{
				nodeLink=nodeLink+"&taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
				window.showModalDialog(cruConfig.contextPath+nodeLink,window,"dialogWidth=800px;dialogHeight=600px")
			}
		}
		alert("操作成功");
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
			if(nodeLinkType!='1'){
			var editUrl = "/bpm/common/toGetProcessInfoView.srq?taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
			window.showModalDialog(cruConfig.contextPath+editUrl,window,"dialogWidth=800px;dialogHeight=600px")
			}else{
				nodeLink=nodeLink+"&taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
				window.showModalDialog(cruConfig.contextPath+nodeLink,window,"dialogWidth=800px;dialogHeight=600px")
			}
		}else{
			if(nodeLinkType!='1'){
			var editUrl = "/bpm/common/toGetProcessInfo.srq?taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
			window.showModalDialog(cruConfig.contextPath+editUrl,window,"dialogWidth=800px;dialogHeight=600px")
			}else{
				nodeLink=nodeLink+"&taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
				window.showModalDialog(cruConfig.contextPath+nodeLink,window,"dialogWidth=800px;dialogHeight=600px")
			}
		}
		//alert("操作成功");
		 simpleSearch();
	}

	function toPrint(){
		ids = getSelIds('rdo_entity_id');
		var datas=ids.split("@");
		if(datas.length>8){
			alert("只能选择一条记录!");
			return;
		}
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		window.open("<%=contextPath%>/wt/relocation/multiProject/printRelocationNotice.jsp?projectInfoNo="+datas[7],"打印","toolbar=no,left=350,top=150,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,width=800,height=900");
	}
	
</script>
</html>