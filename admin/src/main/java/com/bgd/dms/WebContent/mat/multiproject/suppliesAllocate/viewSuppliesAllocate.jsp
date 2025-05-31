<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	
	String planInvoiceId = request.getParameter("plan_invoice_id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>

<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>配置补充计划审批明细页面</title> 
 </head> 
 <body class="bgColor_f3f3f3" onload="refreshData()">
 <form name="form1" id="form1" method="post" action="" target="target_id">
 		<div id="list_table">
			<div id="table_box" style="overflow-y:srcoll;height:1000px">
				<fieldSet style="margin-left:2px;width:98%"><legend>计划基本信息</legend>
			      	<input type='hidden' name='plan_invoice_id' id='plan_invoice_id' value=''>
			      	<input type='hidden' name='laborId' id='laborId' value=''>
					<table  border="0" cellpadding="0" cellspacing="0" id='tab_line_height' name='tab_line_height' class="tab_line_height" width="100%">
			  			
					    <tr>
					    	<td class="inquire_item4">项目名称：</td>
					      	<td class="inquire_form4"><input type="text" name="project_name" id="project_name" class="input_width" value="" readonly/></td>
					    	<td class="inquire_item4">申请单号：</td>
					      	<td class="inquire_form4"><input type="text" name="submite_number" id="submite_number" class="input_width" value="" readonly/></td>
					    </tr>
					    <tr>
					    	<td class="inquire_item4">队伍：</td>
					      	<td class="inquire_form4"><input type="text" name="org_id" id="org_id" class="input_width" value="" readonly/></td>
					      	<td class="inquire_item4">创建人：</td>
					      	<td class="inquire_form4"><input type="text" name="creator_id" id="creator_id" class="input_width" value="" readonly/></td>
					    </tr>
					    <tr>
					      	<td class="inquire_item4">创建时间：</td>
					      	<td class="inquire_form4"><input type="text" name="creator_date" id="creator_date" class="input_width" value="" readonly/></td>
					      	<td class="inquire_item4">金额：</td>
					      	<td class="inquire_form4"><input type="text" name="total_money" id="total_money" class="input_width" value="" readonly/></td>
					    </tr>
					    <tr>
					    	<td class="inquire_item4">计划名称：</td>
					      	<td class="inquire_form4"><input type="text" name="plan_name" id="plan_name" class="input_width" value="" readonly/></td>
					      	<td class="inquire_item4"></td>
					      	<td class="inquire_form4"></td>
					    </tr>
					    <tr>
					    	<td class="inquire_item4">备注：</td>
					      	<td class="inquire_form4" colspan="3"><textarea id="memo" name="memo" class="textarea"></textarea></td>
					    </tr>
					</table>
		    </fieldSet>
			<div id="tag-container_3">
			<ul id="tags" class="tags">
				<li id="tag3_1"><a href="#" >调配信息</a></li>
			</ul>
			</div>
			<div id="tab_box" class="tab_box">
			
			<div id="tab_box_content1" class="tab_box_content" style="overflow: hidden;">
			   <table border="0" cellpadding="0" cellspacing="0" id='taskTable'
					class="tab_line_height" width="100%" style="background: #efefef">
					<tr>
						<td class="bt_info_even" >序号</td>
						<td class="bt_info_odd"  style="width:100px;">物资名称</td>
						<!-- <td class="bt_info_even" >需求数量</td> -->
						<td class="bt_info_odd" >计量单位</td>
						<td class="bt_info_even" >物资编号</td>
						<td class="bt_info_odd" >出库单位</td>
						<td class="bt_info_even" >需求数量</td>
						<td class="bt_info_odd" >已调配数量</td>
						<td class="bt_info_even" style="width:20px;">&nbsp;未调配数量</td>
						</tr>
				</table>
			</div>
			
		   </div>
		 </div>
		 <div id="oper_div">
	        <span class="gb_btn" title="关闭"><a href="#" onclick="newClose()"></a></span>
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
    var planInvoiceId = getQueryString("plan_invoice_id");
    function refreshData(){
    	//var sql ="select t.compile_date,t.total_money,t.plan_invoice_id,t.submite_number,o.org_abbreviation org_name,u.user_name,p.project_name,t.plan_name,t.main_part,t.memo,decode(t.assign_type, '0', '未分配', '1', '已分配', '', '未分配') assign_type from gms_mat_demand_plan_invoice t inner join p_auth_user u on t.creator_id=u.user_id and u.bsflag='0' inner join comm_org_information o on t.org_id=o.org_id and o.bsflag='0' inner join gp_task_project p on t.project_info_no=p.project_info_no and p.bsflag='0' where t.plan_invoice_id in(select t.plan_invoice_id from gms_mat_demand_plan_invoice t  inner join common_busi_wf_middle t3 on t3.business_id =t.plan_invoice_id  inner join gms_mat_demand_plan_invoice t2 on t3.business_id=t2.plan_invoice_id  where t.org_subjection_id like 'C105007%'  and t3.proc_status='3' and t.bsflag='0')";
		//cruConfig.cdtType = 'form';
		//cruConfig.queryStr = sql;
		//cruConfig.currentPageUrl = "/mat/singleproject/suppliesAllocate/planSubListAssignDg.jsp";
		//queryData(1);
		showTitle(planInvoiceId);
		loadDataDetail(planInvoiceId);
	}
    function showTitle(value){
    	var retObj = jcdpCallService("MatItemSrv", "viewSuppliesAllocate", "plan_invoice_id="+value);
    	document.getElementById("plan_invoice_id").value = value;
    	document.getElementById("submite_number").value = retObj.matInfo.submiteNumber;
    	document.getElementById("creator_id").value = retObj.matInfo.userName;
    	document.getElementById("project_name").value = retObj.matInfo.projectName;
    	document.getElementById("org_id").value = retObj.matInfo.orgName;
    	document.getElementById("creator_date").value = retObj.matInfo.compileDate;
    	document.getElementById("total_money").value = retObj.matInfo.totalMoney;
    	document.getElementById("plan_name").value = retObj.matInfo.planName;
    	document.getElementById("memo").value = retObj.matInfo.memo;
        }
    
    function loadDataDetail(shuaId){
		var ids=shuaId.split(",");
		projectInfoNo=ids[0];
		assign=ids[1];
		for(var j =1;j <document.getElementById("taskTable")!=null && j < document.getElementById("taskTable").rows.length ;){
				document.getElementById("taskTable").deleteRow(j);
			}
			var retObj = jcdpCallService("MatItemSrv", "slectAllocateList", "ids="+projectInfoNo+",未调配");
			var taskList = retObj.list;
			for(var i =0; taskList!=null && i < taskList.length; i++){
				var wz_id = taskList[i].wz_id;       //物资ID
				var wz_name = taskList[i].wz_name;	 //物资名称
				var wz_price = taskList[i].wz_price; //参考单价
				var demand_num = taskList[i].demand_num; //使用数量
				
				var wz_prickie = taskList[i].wz_prickie; //计量单位
				var demand_date = taskList[i].demand_date;  //需求日期

				var flat_num        =taskList[i].plan_num;	        //已经调配数量
				var outbound_name   =taskList[i].outbound_name;
				var flat_name   =taskList[i].plan_name;
				
				var autoOrder = document.getElementById("taskTable").rows.length;
				var newTR = document.getElementById("taskTable").insertRow(autoOrder);
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
		        td.id=wz_id;
		        td.innerHTML = wz_name;
		        //debugger;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
		        
		      //  td = newTR.insertCell(2);
				
		      //  td.innerHTML = demand_num;
		      //  td.className = tdClass+'_odd';
		      //  if(autoOrder%2==0){
				//	td.style.background = "#f6f6f6";
				//}else{
				//	td.style.background = "#e3e3e3";
				//}
    		    td = newTR.insertCell(2);
  		        td.innerHTML = wz_prickie;
  		        //debugger;
  		        td.className =tdClass+'_even'
  		        if(autoOrder%2==0){
  					td.style.background = "#FFFFFF";
  				}else{
  					td.style.background = "#ebebeb";
  				}
  		        
  		        td = newTR.insertCell(3);
  				
  		        td.innerHTML = wz_id;
  		        td.className = tdClass+'_odd';
  		        if(autoOrder%2==0){
  					td.style.background = "#f6f6f6";
  				}else{
  					td.style.background = "#e3e3e3";
  				}
  		        td = newTR.insertCell(4);
		        td.innerHTML = outbound_name;
		        //debugger;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
		      td = newTR.insertCell(5);
			
	        td.innerHTML = demand_num;
	        td.className = tdClass+'_odd';
	        if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
			td = newTR.insertCell(6);
	        	td.innerHTML =flat_num;
		     				
		       // td.innerHTML = select;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		        td = newTR.insertCell(7);
  				
  		        td.innerHTML = demand_num-flat_num==0?"—":demand_num-flat_num;
  		        td.className = tdClass+'_odd';
  		        if(autoOrder%2==0){
  					td.style.background = "#f6f6f6";
  				}else{
  					td.style.background = "#e3e3e3";
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
    
	
	function submitInfo(oprinfo){
		var oprstate;
		debugger;
		if(oprinfo==1){
			oprstate = "pass";
		}else{
			oprstate = "notPass";
		}
		ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
		if(loadDataDetail()){
			document.getElementById("isPass").value=oprstate;
			document.getElementById("laborId").value = ids;
			document.getElementById("form1").action = "<%=contextPath%>/mat/singleproject/plan/toSaveMatAllAddAppAuditInfowfpa.srq?oprstate="+oprstate;
			document.getElementById("form1").submit();
			window.setTimeout(function(){window.close();},2000);
		}
		//window.close();
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