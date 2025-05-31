<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	String submite_number = request.getParameter("submiteNumber");
	//System.out.println("11111111111111"+submite_number);	

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
 <body class="bgColor_f3f3f3" onload="getConRatio(),refreshData()">
 <form name="form1" id="form1" method="post" action="" target="target_id">
 		<div id="list_table">
			<div id="table_box" style="overflow-y:srcoll;height:1000px">
				<fieldSet style="margin-left:2px;width:98%"><legend>送审计划基本信息</legend>
			      	<input type='hidden' name='submite_number' id='submite_number' value=''>
					<table  border="0" cellpadding="0" cellspacing="0" id='tab_line_height' name='tab_line_height' class="tab_line_height" width="100%">
			  			<tr>
			    			<td colspan="4" align="center">送审计划审批</td>
			    		</tr>
					   <tr>
						  	<td class="inquire_item4"><font color="red">*</font>计划编号：</td>
						   	<td class="inquire_form4"><input name="plannum" id="plannum" type="text" class="input_width" value=""/>
						   	</td>
						  	<td class="inquire_item4">转入项目：</td>
							<td class="inquire_item4">
							<input type="text"name="input_name" id="input_name" class="input_width"value="" readonly />
							<input type="hidden"name="input_org" id="input_org" class="input_width"value="" readonly />
							</td>
						  </tr>
						  <tr>
						  <td class="inquire_item4"><font color="red">*</font>计划用途：</td>
						   	<td class="inquire_form4">
						   		<select id="plan_type" name="plan_type" class="select_width"></select>
						   	</td>
 							<td class="inquire_item4">金额:</td>
						   	<td class="inquire_form4"><input name="total_money" id="total_money" type="text" class="input_width" value="" readonly="readonly"/>
						   	</td>
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
						<td class="bt_info_even">序号</td>
						<td class="bt_info_odd">物资编码</td>
						<td class="bt_info_even">分类编码</td>
						<td class="bt_info_odd">资源名称</td>
						<td class="bt_info_even">计量单位</td>
						
						<td class="bt_info_odd">参考单价</td>
						<td class="bt_info_even">发放数量</td>
						<td class="bt_info_odd">金额</td>
						<td class="bt_info_even">备注</td>
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
		var checkSql="select * from gms_mat_demand_plan_bz bz inner join gp_task_project p on bz.project_info_no = p.project_info_no and p.bsflag='0' where bz.bsflag='0' and bz.submite_number='<%=submite_number%>' ";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		debugger;
		if(datas!=null&&datas!=""){
			document.getElementById("submite_number").value = datas[0].submite_number;
			document.getElementById("plannum").value = datas[0].submite_id;
			document.getElementById("input_name").value = datas[0].project_name;
			document.getElementById("input_org").value = datas[0].project_info_no;
			document.getElementById("plan_type").value = datas[0].plan_type;
			document.getElementById("total_money").value = datas[0].total_money;
		}
	}
    
 
	 function taskShow(){
			for(var j =1;j <document.getElementById("queryDataTable")!=null && j < document.getElementById("queryDataTable").rows.length ;){
				document.getElementById("queryDataTable").deleteRow(j);
			}
			var retObj = jcdpCallService("MatItemSrv", "findPlanLeafDg", "value=<%=submite_number%>");
			var taskList = retObj.datas;
				debugger;
			for(var i =0; taskList!=null && i < taskList.length; i++){
				var wzId = taskList[i].wz_id;
				var codingCodeId = taskList[i].coding_code_id;
				var wzName = taskList[i].wz_name;
				var wzPrickie = taskList[i].wz_prickie;
				var stockNum = taskList[i].stock_num;
				var wzPrice = taskList[i].wz_price;
				var demandNum = taskList[i].demand_num;
				var demandMoney = taskList[i].demand_money;
				var note = taskList[i].note;
				var autoOrder = document.getElementById("queryDataTable").rows.length;
				var newTR = document.getElementById("queryDataTable").insertRow(autoOrder);
				var tdClass = 'even';
				if(autoOrder%2==0){
					tdClass = 'odd';
				}
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
		        td.innerHTML = wzId;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		        
		        td = newTR.insertCell(2);

		        td.innerHTML = codingCodeId;
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
		        td.innerHTML =wzPrice;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
		        
				td = newTR.insertCell(6);
		        td.innerHTML = demandNum;
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
		        
				td = newTR.insertCell(8);
		        td.innerHTML = note;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
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
    
    
    function getConRatio(){
		var selectObj = document.getElementById("plan_type"); 
    	document.getElementById("plan_type").innerHTML="";

    	var retObj=jcdpCallService("MatItemSrv","queryConRatio","radioValue=1");	
    	var taskList = retObj.matInfo;
    	for(var i =0; taskList!=null && i < taskList.length; i++){
			selectObj.add(new Option(taskList[i].lable,taskList[i].value),i+1);
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
		window.setTimeout(function(){window.close();},3000);
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
		document.getElementById("form1").action = "<%=contextPath%>/mat/singleproject/plan/toSaveMatPlanDgAddAppAuditInfowfpa.srq?oprstate="+oprstate;
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