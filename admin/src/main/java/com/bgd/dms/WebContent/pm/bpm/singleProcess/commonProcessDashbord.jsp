<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg,com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String businessType=resultMsg.getValue("businessType");
	String isDone=resultMsg.getValue("isDone");
	String queryBuilder=resultMsg.getValue("queryBuilder");
	String queryBuilderMean=resultMsg.getValue("queryBuilderMean");
	String listBuilder=resultMsg.getValue("listBuilder");
	String listBuilderMean=resultMsg.getValue("listBuilderMean");
	
	
	String[] queryBuilders=queryBuilder==null?new String[0]:queryBuilder.split(",");
	String[] queryBuilderMeans=queryBuilderMean==null?new String[0]:queryBuilderMean.split(",");
	String[] listBuilders=listBuilder==null?new String[0]:listBuilder.split(",");
	String[] listBuilderMeans=listBuilderMean==null?new String[0]:listBuilderMean.split(",");
	/**监测系统传递页面参数添加代码 开始**/
	String businessId_88=resultMsg.getValue("businessId_88");
	String entityId_88=resultMsg.getValue("entityId_88");
	String procinstId_88=resultMsg.getValue("procinstId_88");
	String taskinstId_88=resultMsg.getValue("taskinstId_88");
	String businessType_88=resultMsg.getValue("businessType_88");
	String nodeLink_88=resultMsg.getValue("nodeLink_88");
	String nodeLinkType_88=resultMsg.getValue("nodeLinkType_88");
	List<MsgElement> processTypes = resultMsg.getMsgElements("processTypes");
	/**监测系统传递页面参数添加代码 结束**/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript"  src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
  <title>待办事宜</title>
 </head>
 <body style="background:#fff;padding:0px;" onload="refreshData(1)">
		   
		  <div id="list_table" >
			<div id="inq_tool_box"  >
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">流程分类</td>
			    <td class="ali_cdn_input">
			   <select id="business_type" name="business_type" onchange="changeType(this.value)"  class="select_width">
				<option value="undefined"  >全部</option>
				<%
				 for(int i=0; i<processTypes.size();i++){
					 Map map = ((MsgElement)processTypes.get(i)).toMap();  
					
					 %>
					 <option value="<%=map.get("codingCodeId")%>"><%=map.get("codingName")%></option>
					 <%
				 }
				%>
				 
			   </select>
			    </td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				     
				</td>
				<td>&nbsp;</td> 
				
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
			      <td class="bt_info_even" autoOrder="1" exp="<input id='infoKey' name='infoKey' type='hidden' value='{businessId}@{entityId}@{procinstId}@{taskinstId}@{businessType}@{nodeLink}@{nodeLinkType}'/>">序号
			      </td>
			      <td class="bt_info_odd" exp="{currentProcName}" func="substr,0,10" tips="{currentProcName}">流程名称</td>
			      <td class="bt_info_even" exp="{currentNode}" func="substr,0,10" tips="{currentNode}">当前环节</td>
			      <td class="bt_info_odd" exp="{businessInfo}" func="substr,0,10" tips="{businessInfo}">业务信息</td>
			      <td class="bt_info_even" exp="{orgName}" func="" tips="{orgName}">提交单位</td>
			      <td class="bt_info_odd" exp="{createUserName}" func="" tips="{createUserName}">提交人</td>
			      <td class="bt_info_even" exp="{wfVar_projectName}">项目名称</td>
			      <td class="bt_info_odd" exp="{createDate}">提交时间</td>
			      <%for(int i=0;i<listBuilders.length;i++) {
			      		String className="";
			    	  	if(i%2==0){
			    	  		className="bt_info_even";
				      	}else{
				      		className="bt_info_odd";
				      	}
				     %>
	       			<td class="<%=className%>" exp="{<%=listBuilders[i] %>}"><%= listBuilderMeans[i]%></th>
	   			  <%} %>
			     </tr>
			  </table>
			</div>
			<div id="fenye_box">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
			</div>
</body>

<script type="text/javascript">

//设置表格高度
function frameSize(){
	$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-10);
}
//页面初始化信息
$(function(){
	frameSize();
	$(window).resize(function(){
  		frameSize();
	});
}); 

var businessType ;
function clearQueryText(){
    document.getElementById("business_type").value = '';
}
function changeType(value){
    businessType = value;
}
 

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
		var submitStr = "currentPage="+ids+"&pageSize="+cruConfig.pageSize+"&businessType="+businessType;
		 
		cruConfig.submitStr ="&isDone=<%=isDone%>"+"&businessType="+businessType;
	 
		<%
	    if(businessType!=null&&!"".equals(businessType)){
	    %>
	    	cruConfig.submitStr+="&businessType=<%=businessType%>";
	    <%
	    }
		 %>
		 
	    cruConfig.currentPageUrl = "/bpm/common/toGetSelfProcessList.srq";
	    
	    queryData(ids);
	}
	function loadDataDetail(ids){
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
			popWindow(cruConfig.contextPath+editUrl);
			}else{
				nodeLink=nodeLink+"&taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
				popWindow(cruConfig.contextPath+nodeLink);
			}
		}else{
			if(nodeLinkType!='1'){ 
			var editUrl = "/bpm/common/toGetProcessInfo.srq?taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
			popWindow(cruConfig.contextPath+editUrl);
			}else{
				nodeLink=nodeLink+"&taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
				popWindow(cruConfig.contextPath+nodeLink);
			}
		}
		
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
		swapDbClk(businessId,entityId,procinstId,taskinstId,businessType,nodeLink,nodeLinkType);
	}
	
	function swapDbClk(businessId,entityId,procinstId,taskinstId,businessType,nodeLink,nodeLinkType){
		var isdone=$("#isdone").val();
		isdone=<%=isDone%>;
	
		if(isdone==1){
			if(nodeLinkType!='1'){  
			var editUrl = "/bpm/common/toGetProcessInfoView.srq?taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>";
			//window.showModalDialog(cruConfig.contextPath+editUrl,window,"dialogWidth=1000px;dialogHeight=600px; scroll:yes")
			 
			window.open(cruConfig.contextPath+editUrl,"审批","scrollbars=yes,resizable=yes");
			//popWindow(cruConfig.contextPath+editUrl);
			}else{  
				nodeLink=nodeLink+"&taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>&isDone=<%=isDone%>";
				//window.showModalDialog(cruConfig.contextPath+nodeLink,window,"dialogWidth=1000px;dialogHeight=600px; scroll:yes")
				window.open(cruConfig.contextPath+nodeLink,"审批","scrollbars=yes,resizable=yes");
				//popWindow(cruConfig.contextPath+nodeLink);
			}
		}else{
			
			if(nodeLinkType!='1'){   
			var editUrl = "/bpm/common/toGetProcessInfo.srq?taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType="+businessType;

			window.open(cruConfig.contextPath+editUrl,"审批","scrollbars=yes,resizable=yes");
			//popWindow(cruConfig.contextPath+editUrl);
			//dialogOpen('流程任务表','1000','650',cruConfig.contextPath+editUrl);
			}else{  
				nodeLink=nodeLink+"&taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType=<%=businessType%>&isDone=<%=isDone%>";
				 
				window.open(cruConfig.contextPath+nodeLink,"审批","scrollbars=yes,resizable=yes");
				//popWindow(cruConfig.contextPath+nodeLink);
			}
		}
		simpleSearch();
	}
	/**监测系统传递页面参数添加代码 开始**/
	//指定的参数不为空，则自动触发双击
	var businessId_1 = "<%=businessId_88%>";
	var entityId_1 = "<%=entityId_88%>";
	var procinstId_1 = "<%=procinstId_88%>";
	var taskinstId_1 = "<%=taskinstId_88%>";
	var businessType_1 = "<%=businessType_88%>";
	var nodeLink_1 = "<%=nodeLink_88%>";
	var nodeLinkType_1 = "<%=nodeLinkType_88%>";
	if((!!businessId_1 && businessId_1!='null') && (!!entityId_1 && entityId_1!='null') && (!!procinstId_1 && procinstId_1!='null')){
		swapDbClk(businessId_1,entityId_1,procinstId_1,taskinstId_1,businessType_1,nodeLink_1,nodeLinkType_1);
	}
	/**监测系统传递页面参数添加代码 结束**/
</script>
</html>