<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.net.URLEncoder"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String projectInfoNo = user.getProjectInfoNo();
	String projectName = user.getProjectName();
	String userOrgSubId = user.getSubOrgIDofAffordOrg();
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	//获取组织机构--大港
	String orgCode=user.getOrgCode();
	
	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>大港</title>
</head>

<body style="background: #fff" onload="refreshData()">
<div id="list_table">
<div id="inq_tool_box">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="6"><img src="<%=contextPath%>/images/list_13.png"
			width="6" height="36" /></td>
		<td background="<%=contextPath%>/images/list_15.png">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<tr>
				<td class="ali3" align='left'>审核结果：
				<select id="lockedIf" name="lockedIf"   onchange="testQuery(this)">
				<option value="0" selected="selected">全部</option>
				<option value="1" >待审核</option>
				<option value="3">审核通过</option>
				<option value="4">审核不通过</option>
			    </select>
				</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    </td>
				<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
				<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
				<auth:ListButton functionId="" css="dc" event="onclick='outExcelData()'" title="导出excel"></auth:ListButton>
				<td></td>
				<td></td>
				<td></td>
			</tr>
		</table>
		</td>
		<td width="4"><img src="<%=contextPath%>/images/list_17.png"
			width="4" height="36" /></td>
	</tr>
</table>
</div>
<div id="table_box">
<table width="100%" border="0" cellspacing="0" cellpadding="0"
	class="tab_info" id="queryRetTable">
	<tr>
		<td class="bt_info_odd"
			exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{plan_invoice_id}' onclick='loadDataDetail();chooseOne(this)'/>">选择</td>
		<td class="bt_info_even" autoOrder="1">序号</td>
		<td class="bt_info_odd" exp="{submite_number}">申请单号</td>
		<td class="bt_info_even" exp="{plan_name}">计划名称</td>
		<td class="bt_info_odd" exp="{plan_invoice_type}">计划指向</td>
		<td class="bt_info_even" exp="{compile_date}">需求日期</td>
		<td class="bt_info_odd" exp="{user_name}">创建人</td>
		<td class="bt_info_even" exp="{total_money}">金额</td>
		<td class="bt_info_odd" exp="{if_submit}">状态</td>
	</tr>
</table>
</div>
<div id="fenye_box">
<table width="100%" border="0" cellspacing="0" cellpadding="0"
	id="fenye_box_table">
	<tr>
		<td align="right">第1/1页，共0条记录</td>
		<td width="10">&nbsp;</td>
		<td width="30"><img src="<%=contextPath%>/images/fenye_01.png"
			width="20" height="20" /></td>
		<td width="30"><img src="<%=contextPath%>/images/fenye_02.png"
			width="20" height="20" /></td>
		<td width="30"><img src="<%=contextPath%>/images/fenye_03.png"
			width="20" height="20" /></td>
		<td width="30"><img src="<%=contextPath%>/images/fenye_04.png"
			width="20" height="20" /></td>
		<td width="50">到 <label> <input type="text"
			name="textfield" id="textfield" style="width: 20px;" /> </label></td>
		<td align="left"><img src="<%=contextPath%>/images/fenye_go.png"
			width="22" height="22" /></td>
	</tr>
</table>
</div>
<div class="lashen" id="line"></div>
<div id="tag-container_3">
<ul id="tags" class="tags">
	<li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">汇总信息</a></li>
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
	   <!--  <td class="bt_info_even">物资说明</td>
		<td class="bt_info_odd">物资类别</td>  -->
	</tr>
</table>
</div>
<div id="tab_box_content1" class="tab_box_content"
	style="display: none;">
<table id="projectMap" width="100%" border="0" cellspacing="0"
	cellpadding="0" class="tab_line_height">
	<tr>
		<td class="bt_info_odd">序号</td>
		<td class="bt_info_even">物资名称</td>
		<td class="bt_info_odd">计量单位</td>
		<td class="bt_info_even">需求数量</td>
		<td class="bt_info_odd">参考单价</td>
		<!--<td class="bt_info_even">现有数量</td>
	
		 <td class="bt_info_odd">可调计量</td>
		<td class="bt_info_even">合计申请量</td> -->
		<td class="bt_info_odd">计划金额</td>
	   <!--  <td class="bt_info_even">物资说明</td>
		<td class="bt_info_odd">物资类别</td>  -->
	</tr>
</table>
</div>
<div id="tab_box_content2" class="tab_box_content">
	<wf:startProcessInfo title=""/>
</div>
</div>
</div>
</body>
<script type="text/javascript">

var orgCode='<%=orgCode%>';
function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]);
    return null;
    }
function frameSize(){
//	$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-40);
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
</script>

<script type="text/javascript">
var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
var showTabBox = document.getElementById("tab_box_content0");
	cruConfig.contextPath =  "<%=contextPath%>";
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
	var checked = false;
	function check(){
		var chk = document.getElementsByName("task_entity_id");
		for(var i = 0; i < chk.length; i++){ 
			if(!checked){ 
				chk[i].checked = true; 
			}
			else{
				chk[i].checked = false;
			}
		} 
		if(checked){
			checked = false;
		}
		else{
			checked = true;
		}
	}
	var projectInfoNo = getQueryString("projectInfoNo");
	function refreshData(){
		var sql ='';
			sql +="select t.plan_invoice_type,t.total_money,t.compile_date,u.user_name ,t.plan_invoice_id,t.submite_number,(case when comm.proc_status = '1'then'待审核' when comm.proc_status = '3' then '审批通过' when comm.proc_status = '4' then '审批不通过' else '未提交' end) if_submit,t.plan_name from gms_mat_demand_plan_invoice t left join common_busi_wf_middle comm on t.plan_invoice_id=comm.business_id and comm.bsflag='0' inner join p_auth_user u on t.creator_id=u.user_id and u.bsflag='0'  where t.bsflag = '0'and t.project_info_no='<%=projectInfoNo%>' order by t.compile_date desc,t.modifi_date desc";
			
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/plansub/planSubListAssignDg.jsp";
		queryData(1);
	}
	
		function loadDataDetail(shuaId){
			if(shuaId!= undefined){
				var tab =document.getElementById("queryRetTable");
				var row = tab.rows;
				var obj = event.srcElement;
				if(obj.tagName.toLowerCase() =='td'){
					var tr = obj.parentNode;
					selectIndex = tr.rowIndex;
				}else if(obj.tagName.toLowerCase() =='input'){
					var tr = obj.parentNode.parentNode;
					selectIndex = tr.rowIndex;
				}
				debugger;
				var businessType="";
				var totalMoney = 0;
				var retObj = jcdpCallService("MatItemSrv", "getProcess", "ids=");
				var taskList = retObj.matInfo;
				for(var i=1;i<row.length;i++){
					var cell_0 = row[i].cells[0].firstChild.checked;
					if(cell_0 == true){
						var cell_7 = row[i].cells[7].innerHTML;
						totalMoney = cell_7;
						for(var j =0;j < taskList.length; j++){
							var startMoney = taskList[j].startMoney;
							var endMoney = taskList[j].endMoney;
							if((-totalMoney < -startMoney) && (-totalMoney >= -endMoney)){
								businessType = taskList[j].businessType;
								break;
									}
							}
					}
				}
				processNecessaryInfo={
						businessTableName:"gms_mat_demand_plan_invoice",	
						businessType:businessType,
						businessId: shuaId,
						businessInfo:"<%=projectName%>-物资计划申请",
						applicantDate:'<%=appDate%>'
					};
				processAppendInfo={
							planInvoiceId:shuaId,
							projectName: '<%=projectName%>'
					};
				loadProcessHistoryInfo();

				taskShow(shuaId);
				detailedShow(shuaId);
			}else{
				var ids = document.getElementById('rdo_entity_id').value;
			    if(ids==''){ 
				    alert("请先选中一条记录!");
		     		return;
			    }
			    taskShow(ids);
			    detailedShow(ids);
			}
			    
		}
		//汇总信息
	 function taskShow(value){
			for(var j =1;j <document.getElementById("taskTable")!=null && j < document.getElementById("taskTable").rows.length ;){
				document.getElementById("taskTable").deleteRow(j);
			}
			var retObj = jcdpCallService("MatItemSrv", "getSubList", "ids="+value);
			var taskList = retObj.matInfo;
			for(var i =0; taskList!=null && i < taskList.length; i++){
				var wzName = taskList[i].wzName;
				var demandNum = taskList[i].demandNum;
				var wzPrickie = taskList[i].wzPrickie;
				var wzPrice = taskList[i].wzPrice;
				var description = taskList[i].codeDesc;
				var codeName = taskList[i].codeName;
				var planMoney = taskList[i].planMoney;
				var haveNum = taskList[i].haveNum;
				var regulateNum = taskList[i].regulateNum;
				var applyNum = taskList[i].applyNum;
				var autoOrder = document.getElementById("taskTable").rows.length;
				var newTR = document.getElementById("taskTable").insertRow(autoOrder);
				var tdClass = 'even';
				if(autoOrder%2==0){
					tdClass = 'odd';
				}
				
//		        var td = newTR.insertCell(0);
//		        td.innerHTML = "<input type='checkbox' name='task_entity_id' value=''/>";
//		        td.className = tdClass+'_odd';
//		        if(autoOrder%2==0){
//					td.style.background = "#f6f6f6";
//				}else{
//					td.style.background = "#e3e3e3";
//				}

		        var td = newTR.insertCell(0);
		        td.innerHTML = autoOrder;
		        //debugger;
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
			//	td = newTR.insertCell(5);
		 //       td.innerHTML = haveNum;
		  //      td.className = tdClass+'_odd';
		 //       if(autoOrder%2==0){
		//			td.style.background = "#f6f6f6";
		//		}else{
		//			td.style.background = "#e3e3e3";
		//	}
		     //   td = newTR.insertCell(6);

		     //   td.innerHTML =regulateNum;
		    //    td.className =tdClass+'_even'
		    //    if(autoOrder%2==0){
			//		td.style.background = "#FFFFFF";
			//	}else{
			//		td.style.background = "#ebebeb";
			//	}
			//	td = newTR.insertCell(7);
				
		    //    td.innerHTML =applyNum;
		    //    td.className = tdClass+'_odd';
		    //    if(autoOrder%2==0){
			//		td.style.background = "#f6f6f6";
			//	}else{
			//		td.style.background = "#e3e3e3";
			//	}
		        td = newTR.insertCell(5);
		        td.innerHTML = Math.round(demandNum * wzPrice);
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
				//td = newTR.insertCell(9);
				
		       // td.innerHTML = description;
		       // td.className = tdClass+'_odd';
		       // if(autoOrder%2==0){
				//	td.style.background = "#f6f6f6";
				//}else{
				//	td.style.background = "#e3e3e3";
				//}
		      //  td = newTR.insertCell(10);

		      //  td.innerHTML = codeName;
		       // td.className =tdClass+'_even'
		      //  if(autoOrder%2==0){
				//	td.style.background = "#FFFFFF";
				//}else{
				//	td.style.background = "#ebebeb";
				//}
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
	//明细信息
	 function detailedShow(value){
			for(var j =1;j <document.getElementById("projectMap")!=null && j < document.getElementById("projectMap").rows.length ;){
				document.getElementById("projectMap").deleteRow(j);
			}
			var retObj = jcdpCallService("MatItemSrv", "getSubDetaile", "ids="+value);
			var taskList = retObj.matInfo;
			for(var i =0; taskList!=null && i < taskList.length; i++){
				var submiteId = taskList[i].submiteId;
				var wzName = taskList[i].wzName;
				var demandNum = taskList[i].demandNum;
				var codingName = taskList[i].codingName;
				var note = taskList[i].note;
				var demandDate = taskList[i].demandDate;
				var autoOrder = document.getElementById("projectMap").rows.length;
				var newTR = document.getElementById("projectMap").insertRow(autoOrder);
				var tdClass = 'even';
				if(autoOrder%2==0){
					tdClass = 'odd';
				}
		        var td = newTR.insertCell(0);

		        td.innerHTML = autoOrder;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}

  				td = newTR.insertCell(1);
				
		        td.innerHTML = submiteId;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
				
		        td = newTR.insertCell(2);
		        td.innerHTML = codingName;
		        //debugger;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
		        
		        td = newTR.insertCell(3);
				
		        td.innerHTML = wzName;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		        
		        td = newTR.insertCell(4);

		        td.innerHTML = demandNum;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
				td = newTR.insertCell(5);
				
		        td.innerHTML = demandDate;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		        td = newTR.insertCell(6);

		        td.innerHTML = note;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
				
		        newTR.onclick = function(){
		        	// 取消之前高亮的行
		       		for(var i=1;i<document.getElementById("projectMap").rows.length;i++){
		    			var oldTr = document.getElementById("projectMap").rows[i];
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
	
	 function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }
	    function toAdd(){
		    /*
	    	ids = getSelIds('rdo_entity_id');
	 	    if(ids==''){ alert("请先选中一条记录!");
	 	     	return;
	 	    }
	 	    else{
	 	    	var retObj = jcdpCallService("MatItemSrv", "getSubIf", "ids="+ids);
	 	    	var submiteIf = retObj.matInfo.submiteIf;
	 	    	if(submiteIf =='1'){ alert("申请单已被提交!");
	 	     	return;
		 	    }else{
		 	    	if(submiteIf =='3'){ alert("申请单已被审批!");
		 	     	return;
			 	    }
			 	    }
		 	    }	
	 	   */
	 	   
	 	  if(orgCode.indexOf("C105007")>-1){
			popWindow('<%=contextPath%>/mat/singleproject/plansub/planSumListDg.jsp?','1024:800');
			}else{
			popWindow('<%=contextPath%>/mat/singleproject/plansub/planSumList.jsp?','1024:800');
			}
	 	   
	 	  	
	    	//popWindow("<%=contextPath%>/mat/singleproject/plansub/planSumEdit.jsp");
		    }   
	    //查询函数
	    function  testQuery(selectThis){
			//alert(selectThis.options[selectThis.selectedIndex].text);
	 		var sql = "";
			if(selectThis.options[selectThis.selectedIndex].value=='0'){
				sql +="select t.plan_invoice_type,t.total_money,t.compile_date,u.user_name ,t.plan_invoice_id,t.submite_number,(case when comm.proc_status = '1'then'待审核' when comm.proc_status = '3' then '审批通过' when comm.proc_status = '4' then '审批不通过' else '未提交' end) if_submit,t.plan_name from gms_mat_demand_plan_invoice t left join common_busi_wf_middle comm on t.plan_invoice_id=comm.business_id and comm.bsflag='0' inner join p_auth_user u on t.creator_id=u.user_id and u.bsflag='0'  where t.bsflag = '0'and t.project_info_no='<%=projectInfoNo%>' order by t.compile_date desc,t.modifi_date desc";
			}else if(selectThis.options[selectThis.selectedIndex].value=='4'){
				sql+=" select * from (select t.plan_invoice_type,t.total_money,t.compile_date,u.user_name ,t.plan_invoice_id,t.submite_number,(case when comm.proc_status = '1'then'待审核' when comm.proc_status = '3' then '审批通过' when comm.proc_status = '4' then '审批不通过' else '未提交' end) if_submit,t.plan_name from gms_mat_demand_plan_invoice t left join common_busi_wf_middle comm on t.plan_invoice_id=comm.business_id and comm.bsflag='0' inner join p_auth_user u on t.creator_id=u.user_id and u.bsflag='0'  where t.bsflag = '0'and t.project_info_no='<%=projectInfoNo%>' order by t.compile_date desc,t.modifi_date desc )ttt  where ttt.if_submit='审批不通过'"
			}else{
				sql +="select distinct t.plan_invoice_type,t.total_money,t.compile_date,u.user_name ,t.plan_invoice_id,t.submite_number,(case when comm.proc_status = '1'then'待审核' when comm.proc_status = '3' then '审批通过' when comm.proc_status = '4' then '审批不通过' else '未提交' end) if_submit,t.plan_name from gms_mat_demand_plan_invoice t left join common_busi_wf_middle comm on t.plan_invoice_id=comm.business_id inner join p_auth_user u on t.creator_id=u.user_id and u.bsflag='0'  where t.bsflag = '0'and t.project_info_no='<%=projectInfoNo%>' and comm.proc_status='"+selectThis.options[selectThis.selectedIndex].value+"' order by t.compile_date desc";
				}
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = sql;
			cruConfig.currentPageUrl = "/mat/singleproject/plansub/planSubListDg.jsp";
			queryData(1);
			 
		}
		function toDelete(){
			ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }
		    else{
		    	var retObj = jcdpCallService("MatItemSrv", "getSubIf", "ids="+ids);
	 	    	var submiteIf = retObj.matInfo.submiteIf;
	 	    	if(submiteIf =='1'){ alert("申请单已被提交!");
	 	     	return;
			    }else{
		 	    	if(submiteIf =='3'){ alert("申请单已被审批!");
		 	     	return;
			 	    }
		 	    	else{
		 	    		if(confirm('确定要删除吗?')){  
		 					
		 					var retObj = jcdpCallService("MatItemSrv", "deleteMatSub", "matId="+ids);
		 					
		 					queryData(cruConfig.currentPage);
		 				}
		 	    	}
			    }   	
			}
		}
		function toSubmit(){
			ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
		    else{
		    	var retObj = jcdpCallService("MatItemSrv", "getSubIf", "ids="+ids);
	 	    	var submiteIf = retObj.matInfo.submiteIf;
	 	    	if(submiteIf =='1'){ alert("申请单已被提交!");
	 	     	return;
		 	    }else{
		 	    	if(submiteIf =='3'){ alert("申请单已被审批!");
		 	     	return;
			 	    }
		 	    	else{   
						if(confirm('确定要提交吗?')){  
							popWindow("<%=contextPath%>/mat/singleproject/plansub/planSubmit.jsp?planInvoiceId="+ids,'1024:800');
							//var retObj = jcdpCallService("MatItemSrv", "submitMat", "matId="+ids);
							
			}
			}
			}
		    }
		}
		function toEdit(){
			ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
		    else{
		    	var retObj = jcdpCallService("MatItemSrv", "getSubIf", "ids="+ids);
	 	    	var submiteIf = retObj.matInfo.procStatus;
	 	    	if(submiteIf =='1'){ alert("申请单已被提交!");
	 	     	return;
		 	    }else{
		 	    	if(submiteIf =='3'){ alert("申请单已被审批!");
		 	     	return;
			 	    }
		 	    	else{
		 	    	
		 	    		if(orgCode.indexOf("C105007")>-1){
						popWindow("<%=contextPath%>/mat/singleproject/plansub/planSubEditDg.jsp?planInvoiceId="+ids,'1024:800');
						}else{
						popWindow("<%=contextPath%>/mat/singleproject/plansub/planSubEdit.jsp?planInvoiceId="+ids,'1024:800');
						}
		 	    	
		 	    	
		    			
		 	    	}
			    }   
			
			}
		}
		 function outExcelData(){
	    	 ids = getSelIds('rdo_entity_id');
			    if(ids==''){ alert("请先选中一条记录!");
			     	return;
			    }	
			    else{
			    	window.location = '<%=contextPath%>/mat/singleproject/plansub/matExcelOutPlanList.srq?planId='+ids;
			    }
	    	
	        }
	        	 //刷新状态
		        function loadBusinessInfoStatus(){ 
			        if(wfPublicProcinstId != '')
		        	    refreshData();
			        }
</script>

</html>

