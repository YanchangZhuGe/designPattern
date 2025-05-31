<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	String out_info_id = request.getParameter("out_info_id");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>配置补充计划审批明细页面</title> 
 </head> 
 <body class="bgColor_f3f3f3" onload="refreshData()">
 <form name="form1" id="form1" method="post" action="" target="target_id">
 		<div id="list_table">
			<div id="table_box" style="overflow-y:srcoll;height:1000px">
				<fieldSet style="margin-left:2px;width:98%"><legend>送审计划基本信息</legend>
			      	<input type='hidden' name='out_info_id' id='out_info_id' value=''>
					<table  border="0" cellpadding="0" cellspacing="0" id='tab_line_height' name='tab_line_height' class="tab_line_height" width="100%">
			  			<tr>
			  				<td class="inquire_item6">转出项目：</td>
							<td class="inquire_item6"><input type="text"name="project_info_no" id="project_info_no" class="input_width" value=""></input>
							</td>
							<td class="inquire_item6">转入项目：</td>
							<td class="inquire_item6">
							<input type="text"name="input_name" id="input_name" class="input_width"value="" readonly />
							</td>
							<td class="inquire_item6">操作人：</td>
							<td class="inquire_item6"><input type="text" name="operator" id="operator"class="input_width"value="" /></td>
						</tr>
						<tr>
							<td class="inquire_item6">转出时间：</td>
							<td class="inquire_item6"><input type="text" name="out_date" id="out_date" class="input_width" value="" readonly /></td>
							<td class="inquire_item6">合计金额：</td>
							<td class="inquire_item6"><input type="text" name="total_money" id="total_money"class="input_width"value="" /></td>
						</tr>
					</table>
		    </fieldSet>
			<div id="tag-container_3">
			<ul id="tags" class="tags">
				<li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">审批明细</a></li>
				<li id="tag3_1"><a href="#" onclick="getTab3(1)">明细信息</a></li>
			</ul>
			</div>
			<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content" style="display:block;">
				<wf:getProcessInfo />
			</div>
			<div id="tab_box_content1" class="tab_box_content" style="display: none; overflow: hidden;">
			   <table width="100%" border="0" cellspacing="0" cellpadding="0" class="" id="queryDataTable">
					<tr>
						<td class="bt_info_odd">序号</td>
			    		<td  class="bt_info_even">物资分类码</td>
			    	  	<td  class="bt_info_odd">物资编码</td>
			            <td  class="bt_info_even">物资说明</td>
			            <td class="bt_info_odd">单位</td>
			            <td class="bt_info_even">转出数量</td>
			            <td  class="bt_info_odd">物资单价</td>
			            <td class="bt_info_even">金额</td>
					</tr>
				</table>
			</div>
		   </div>
		 </div>
		 <div id="oper_div">
	        <span class="pass_btn" title="审批通过"><a id="submitButton" href="#" onclick="changeSub(1);submitInfo(1)"></a></span>
	        <span class="nopass_btn" title="审批不通过"><a href="#" onclick="changeSub(0);submitInfo(0)"></a></span>
	    </div>
	</div>
</form>
<iframe style="display: none;" id="target_id" name="target_id"></iframe>
</body>
<script type="text/javascript">

var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
var showTabBox = document.getElementById("tab_box_content0");
</script>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	var checked = false;
	function check(){
		var chk = document.getElementsByName("rdo_entity_id");
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
	function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]);
    return null;
    }
    var planInvoiceId = getQueryString("planInvoiceId");
    function refreshData(){
    	queryPlanDetail();
    	taskShow();
/*    	cruConfig.queryService = "MatItemSrv";
    	cruConfig.queryOp = "findPlanLeafDg";
		cruConfig.submitStr ="value=submite_number";
		queryData(1);
*/
	}
    
    
    function queryPlanDetail(){
		var checkSql="select info.out_info_id, info.out_date, info.operator, info.total_money, p.project_name input_name,p2.project_name  from GMS_MAT_OUT_INFO info inner join gp_task_project p on info.input_org = p.project_info_no and p.bsflag = '0' inner join gp_task_project p2 on info.project_info_no = p2.project_info_no and p2.bsflag='0' where info.out_info_id = '<%=out_info_id%>' and info.bsflag = '0'";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		debugger;
		if(datas!=null&&datas!=""){
			document.getElementById("out_info_id").value = datas[0].out_info_id;
			document.getElementById("project_info_no").value = datas[0].project_name;
			document.getElementById("input_name").value = datas[0].input_name;
			document.getElementById("operator").value = datas[0].operator;
			document.getElementById("out_date").value = datas[0].out_date;
			document.getElementById("total_money").value = datas[0].total_money;
		}
	}
    
 
	 function taskShow(){
			for(var j =1;j <document.getElementById("queryDataTable")!=null && j < document.getElementById("queryDataTable").rows.length ;){
				document.getElementById("queryDataTable").deleteRow(j);
			}
			var retObj = jcdpCallService("MatItemSrv", "getRemoveMatList", "ids=<%=out_info_id%>");
			var taskList = retObj.matInfo;
				debugger;
			for(var i =0; taskList!=null && i < taskList.length; i++){
				var wzName = taskList[i].wzName;
				var wzId = taskList[i].wzId;
				var codingCodeId = taskList[i].codingCodeId; 
				var wzPrickie = taskList[i].wzPrickie;
				var wzPrice = taskList[i].outPrice;
				var demandNum = taskList[i].outNum;
				var demandMoney = taskList[i].totalMoney;
				var autoOrder = document.getElementById("queryDataTable").rows.length;
				var newTR = document.getElementById("queryDataTable").insertRow(autoOrder);
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
		        td.innerHTML = codingCodeId;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		        
		        td = newTR.insertCell(2);
		        td.innerHTML = wzId;
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
		        td.innerHTML = wzPrickie;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
		        
		        
		        td = newTR.insertCell(5);
		        td.innerHTML =demandNum;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
		        
				td = newTR.insertCell(6);
		        td.innerHTML = wzPrice;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		        
		        td = newTR.insertCell(7);
		        td.innerHTML = demandMoney;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
		        
		        newTR.onclick = function(){
		        	// 取消之前高亮的行
		       		for(var i=1;i<document.getElementById("queryDataTable").rows.length;i++){
		    			var oldTr = document.getElementById("queryDataTable").rows[i];
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
    
    
    
    function loadDataDetail(shuaId){
	}
    
    function changeSub(oprinfo){
		var oprstate;
		if(oprinfo==1){
			oprstate = "pass";
		}else{
			oprstate = "notPass";
		}		
		document.getElementById("isPass").value=oprstate;
		//跳到空方法中，更新审批状态
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toUpStateInfowfpa.srq";     
		document.getElementById("form1").submit();
	}
    
	function submitInfo(oprinfo){
		var oprstate;
		debugger;
		if(oprinfo==1){
			oprstate = "pass";
		}else{
			oprstate = "notPass";
		}
		document.getElementById("isPass").value=oprstate;
		document.getElementById("form1").action = "<%=contextPath%>/mat/singleproject/plan/toSaveMatRemoveDgAddAppAuditInfowfpa.srq?oprstate="+oprstate;
		document.getElementById("form1").submit();
		document.getElementById("submitButton").onclick = "";
		window.setTimeout(function(){window.close();},4000);
	}
	
	function frameSize(){
		setTabBoxHeight();
	}
	frameSize();
	
	
	function setTabBoxHeight(){
		if(lashened==0){
			$("#table_box").css("height",$(window).height()*0.76);
		}
		//$("#tab_box .tab_box_content").css("height",$(window).height()-$("#table_box").height()-$("#tag-container_3").height()-10);
		$("#tab_box .tab_box_content").each(function(){
			if($(this).children('iframe').length > 0){
				$(this).css('overflow-y','hidden');
			}
		});
	}
</script>
</html>