<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgName = user.getOrgName();
	String projectName = user.getProjectName();
	String userName = user.getUserName();
	String projectInfoId = user.getProjectInfoNo();
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>大港物资汇总编辑管理</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
<link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
<link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
<link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json2.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
</head>
<body onload="refreshData()" class="odd_odd">
<form name="form1" id="form1" method="post" action="">
<div id="inq_tool_box">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="6"><img src="<%=contextPath%>/images/list_13.png"
			width="6" height="36" /></td>
		<td background="<%=contextPath%>/images/list_15.png">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td  align="left">计划汇总</td>
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
			exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{submite_number}@{submite_id}' onclick=''/>">选择</td>
		<td class="bt_info_even" autoOrder="1">序号</td>
		<td class="bt_info_odd" exp="{submite_id}">计划编号</td>
		 <td class="bt_info_even" exp="{type}">计划指向</td> 
		<td class="bt_info_odd" exp="{org_name}">队伍</td>
		<td class="bt_info_even" exp="{user_name}">创建人</td>
	</tr>
</table>
</div>
</form>
<table id="fenye_box_table">
</table>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
    
    <br />
    <div id="tab_box" class="tab_box">
<div id="tab_box_content0" class="tab_box_content">
<table border="0" cellpadding="0" cellspacing="0" id='taskTable'
	class="tab_line_height" width="100%" style="background: #efefef">
	<tr>
		<td class="bt_info_even" >序号</td>
		<td class="bt_info_odd" >物资编码</td>
		<td class="bt_info_even" >物资分类码</td>
		<td class="bt_info_odd" >物资名称</td>
		<td class="bt_info_even" >计量单位</td>
		<td class="bt_info_odd" >需求数量</td>
		<!-- <td class="bt_info_even" >审核数量</td> -->
		<td class="bt_info_odd" >参考单价</td>
		<td class="bt_info_even" >需求日期</td>
		<td class="bt_info_odd" >备注</td>
		</tr>
</table>
</div>
<div id="tab_box_content1" class="tab_box_content" >
			
		</div>
</div>
    
    
</body>
<script type="text/javascript">
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
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "MatItemSrv";
	cruConfig.queryOp = "getPlanTeamDg";
    function refreshData(){
    //	var sql ='';
	//	sql +="select t.submite_number,t.submite_id,u.user_name,o.org_name,d.coding_name from gms_mat_demand_plan_bz t inner join comm_org_information o on t.org_id=o.org_id and o.bsflag='0' inner join p_auth_user u on t.creator_id=u.user_id inner join comm_coding_sort_detail d on t.s_apply_team=d.coding_code_id and d.bsflag='0'  where t.bsflag='0'and t.plan_invoice_id='0'and t.project_info_no='<%=projectInfoId%>'";
		
		cruConfig.submitStr ="value="+"<%=projectInfoId%>";
		queryData(1);
		
		
	}
	
	function loadDataDetail(shuaId){
	taskShow(shuaId);
	//popWindow("<%=contextPath%>/mat/singleproject/plansub/planSumList.jsp?shuaId="+shuaId,'1024:800');
	}
	
	 function taskShow(value){
    			for(var j =1;j <document.getElementById("taskTable")!=null && j < document.getElementById("taskTable").rows.length ;){
    				document.getElementById("taskTable").deleteRow(j);
    			}
    			var values=value.split("@");
    			var retObj = jcdpCallService("MatItemSrv", "findPlanList", "ids="+values[0]);
    			var taskList = retObj.matInfo;
    			for(var i =0; taskList!=null && i < taskList.length; i++){
    				var wzName = taskList[i].wzName;
    				var wzId = taskList[i].wzId;
    				var codingCodeId = taskList[i].codingCodeId;
    				var demandNum = taskList[i].demandNum; 
    				var approveNum = taskList[i].approveNum; 
    				var wzPrickie = taskList[i].wzPrickie;
    				var wzPrice = taskList[i].wzPrice;
    				var demandDate = taskList[i].demandDate;
    				var note = taskList[i].note;
    				var autoOrder = document.getElementById("taskTable").rows.length;
    				var newTR = document.getElementById("taskTable").insertRow(autoOrder);
    				var tdClass = 'even';
    				if(autoOrder%2==0){
    					tdClass = 'odd';
    				}
    				
 /*   		        var td = newTR.insertCell(0);

    		        td.innerHTML = "<input type='checkbox' name='task_entity_id' value=''/>";
    		        td.className = tdClass+'_odd';
    		        if(autoOrder%2==0){
    					td.style.background = "#f6f6f6";
    				}else{
    					td.style.background = "#e3e3e3";
    				}
*/
    		        td = newTR.insertCell(0);
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

  		        td.innerHTML = demandNum;
  		        td.className = tdClass+'_odd';
    		        if(autoOrder%2==0){
    					td.style.background = "#f6f6f6";
    				}else{
    					td.style.background = "#e3e3e3";
    				}
    		        td = newTR.insertCell(6);

    		        td.innerHTML = wzPrice;
    		        td.className =tdClass+'_even'
    		        if(autoOrder%2==0){
    					td.style.background = "#FFFFFF";
    				}else{
    					td.style.background = "#ebebeb";
    				}
    		        td = newTR.insertCell(7);

      		        td.innerHTML = demandDate;
      		        td.className = tdClass+'_odd';
        		        if(autoOrder%2==0){
        					td.style.background = "#f6f6f6";
        				}else{
        					td.style.background = "#e3e3e3";
        				}
        		        td = newTR.insertCell(8);

        		        td.innerHTML = note;
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
    			
    		}
	
	
   
	function save(){
	debugger;	
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		else{
			//46代表单个提交  ---  >55代表多个小队单合并
			if(ids.length>55){
				debugger;
				var bo=true;
				var id=ids.split(",");
				var type=id[0].substring(33,36);
				for(var i=1; i<id.length;i++){
					if(type!=id[i].substring(33,36)){
						bo=false;
						}
					}
					if(!bo){
						alert("不同计划不能汇总");
						}else{
							ids="";
							for(var i=0; i<id.length;i++){
								if(ids==""){
									ids=id[i].substring(0,32);
									}else{
										ids=ids+","+id[i].substring(0,32);
										}
								}
							if(confirm("确认申请计划汇总？")){
								document.getElementById("form1").action = "<%=contextPath%>/mat/singleproject/plansub/planSumEditDg.jsp?id="+ids+"&type="+type;
								document.getElementById("form1").submit();
							}

				
					
					}
			}else{
				var id=ids.split("@");
				document.getElementById("form1").action = "<%=contextPath%>/mat/singleproject/plansub/planSumEditDg.jsp?id="+id[0]+"&type="+id[1].substring(0,3);
				document.getElementById("form1").submit();
			}
			
		}
	}
	
</script>
</html>