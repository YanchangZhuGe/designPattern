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

  <title>待办事项</title>
 </head>

 <body style="background:#fff;padding-left: 0px; padding-right: 0px; padding-top: 0px; padding-bottom: 0px; overflow-y : auto; overflow-x:hidden;" onload="refreshData(1)">
		   
		  <div id="list_table" >
			
			<div style="width:100%; overflow-y : auto">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			     <tr onclick="">
			      <td class="bt_info_even" autoOrder="1" exp="<input id='infoKey' name='infoKey' type='hidden' value='{businessId}@{entityId}@{procinstId}@{taskinstId}@{businessType}@{nodeLink}@{nodeLinkType}'/>">序号
			      </td>
			      <td class="bt_info_odd" exp="{currentProcName}" func="substr,0,10" tips="{currentProcName}">流程名称</td>
			      <td class="bt_info_even" exp="{currentNode}" func="substr,0,10" tips="{currentNode}">当前环节</td>
			      <td class="bt_info_odd" exp="{businessInfo}" func="substr,0,10" tips="{businessInfo}">业务信息</td>
			      <td class="bt_info_odd" exp="{createUserName}" func="" tips="{createUserName}">提交人</td>
			      
			      
			     </tr>
			  </table>
			</div>
			<div id="fenye_box"  style="display:block">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
				  
				</table>
			</div>
			</div>
</body>

<script type="text/javascript">
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
		cruConfig.pageSize=5;
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
					alert("nodeLink="+nodeLink);
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
	
	//重写方法，使行数据单击事件运行双击事件的方法
	function renderTable(tbObj,tbCfg){
	// 
	renderNaviTable(tbObj,tbCfg);
	// 
	var headChxBox = getObj("headChxBox");
	if(headChxBox!=undefined) headChxBox.checked = false;
	for(var i=tbObj.rows.length-1;i>0;i--)
		tbObj.deleteRow(i);

	var titleRow = tbObj.rows[0];

	// 
	tbObj.selectedRow = 0;
	tbObj.selectedValue = '';
	
	// 
	for(var j=0;j<titleRow.cells.length;j++){
		var tCell = titleRow.cells[j];
		tCell.exp = tCell.getAttribute("exp");
		tCell.func = tCell.getAttribute("func");
		
		tCell.cellClass = tCell.getAttribute("cellClass");
		tCell.isShow = tCell.getAttribute("isShow");
		tCell.isExport = tCell.getAttribute("isExport");
		if(tCell.getAttribute("isShow")=="Hide"){
			tCell.style.display = 'none';
		}
	}// end
	
	var datas = tbCfg.items;
	if(datas==undefined) datas=[];
	if(datas!=null){
		for(var i=0;i<datas.length;i++){
			var data = datas[i];
			var vTr = tbObj.insertRow();
			vTr.orderNum = i+1;
			//  
			vTr.onclick = function(){
				//alert(tbObj.selectedRow);
				//  
				if(tbObj.selectedRow>0){
					var oldTr = tbObj.rows[tbObj.selectedRow];
					var cells = oldTr.cells;
					for(var j=0;j<cells.length;j++){
						cells[j].style.background="#96baf6";
						// 
						if(tbObj.selectedRow%2==0){
							if(j%2==1) cells[j].style.background = "#FFFFFF";
							else cells[j].style.background = "#f6f6f6";
						}else{
							if(j%2==1) cells[j].style.background = "#ebebeb";
							else cells[j].style.background = "#e3e3e3";
						}
					}
				}
				tbObj.selectedRow=this.orderNum;
				//  
				var cells = this.cells;
				for(var i=0;i<cells.length;i++){
					cells[i].style.background="#ffc580";
				}
				tbObj.selectedValue = cells[0].childNodes[0].value;
				// 
				dbclickRow(cells[0].childNodes[0].value);
			}
			vTr.ondblclick = function(){
				var cells = this.cells;
				dbclickRow(cells[0].childNodes[0].value);
			}
			
			if(cruConfig.cruAction=='list2Link'){// 
				vTr.onclick = function(){
					eval(rowSelFuncName+"(this)");
				}
				vTr.onmouseover = function(){this.className = "trSel";}
				vTr.onmouseout = function(){this.className = this.initClassName;}
			}
	
			for(var j=0;j<titleRow.cells.length;j++){
				var tCell = titleRow.cells[j];
				var vCell = vTr.insertCell();
				//  
				if(i%2==1){
					if(j%2==1) vCell.className = "even_even";
					else vCell.className = "even_odd";
				}else{
					if(j%2==1) vCell.className = "odd_even";
					else vCell.className = "odd_odd";
				}
				
				var outputValue = getOutputValue(tCell,data,false);
				var cellValue = outputValue;
				
				if(tCell.getAttribute("isShow")=="Edit"){
					cellValue = "<input type=text onclick=tableInputEditable(this) onkeydown=tableInputkeydown(this) class=rtTableInputReadOnly";
					if(tCell.fieldName!=undefined) cellValue += " name="+tCell.fieldName
					else cellValue += " name="+tCell.exp.substr(1,tCell.exp.length-2);
					if(tCell.size!=undefined) cellValue += " size="+tCell.size;
					else cellValue += " size=8";
					cellValue += " value='"+outputValue+"'>";
				}
				else if(tCell.getAttribute("isShow")=="Hide"){
					cellValue = "<input type=text value="+outputValue;
					if(tCell.fieldName!=undefined) cellValue += " name="+tCell.fieldName+">"
					else cellValue += " name="+tCell.exp.substr(1,tCell.exp.length-2)+">";
					vCell.style.display = 'none';
				}else if(tCell.isShow=="TextHide"){
					vCell.style.display = 'none';
				}
	//alert(typeof cellValue);alert(cellValue == undefined);
				if(cellValue == undefined || cellValue == 'undefined') cellValue = "";
				if(cellValue=='') {cellValue = "&nbsp;";}
				else if(cellValue.indexOf("undefined")!=-1){
				   cellValue = cellValue.replace("undefined","");
				}
	
				// 
				if(tCell.autoOrder=='1' || tCell.getAttribute('autoOrder')=='1'){
					if(cellValue==null || cellValue=="null") cellValue="";
					cellValue += ((tbCfg.currentPage-1) * tbCfg.pageSize + 1 + i);
				}
				
				vCell.innerHTML = cellValue;
				
				if(tCell.tips!=undefined && tCell.tips!=""){
					vCell.title = getOutputValue(tCell,data,true);
				}
			}
		}
		
		if(cruConfig.pageSize!=cruConfig.pageSizeMax){
			for(var i=datas.length;i<tbCfg.pageSize;i++){
				var vTr = tbObj.insertRow();
				for(var j=0;j<titleRow.cells.length;j++){
					var tCell = titleRow.cells(j);
					var vCell = vTr.insertCell();
					// 
					if(i%2==1){
						if(j%2==1) vCell.className = "even_even";
						else vCell.className = "even_odd";
					}else{
						if(j%2==1) vCell.className = "odd_even";
						else vCell.className = "odd_odd";
					}
					vCell.innerHTML = "&nbsp;";
					//
					if(tCell.getAttribute("isShow")=="Hide"){
						vCell.style.display='none';
					}
				}
			}
		}
	}
	createNewTitleTable();
	resizeNewTitleTable();
}
</script>
</html>