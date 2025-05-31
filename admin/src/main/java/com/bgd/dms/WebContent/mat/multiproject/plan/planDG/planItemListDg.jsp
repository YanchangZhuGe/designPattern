<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>

<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>

<script type="text/javascript" src="<%=contextPath %>/js/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.dialog.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
<title>大港</title>
</head>

<body style="background: #fff" onload="refreshData();">
<div id="list_table">
<div id="inq_tool_box">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="6"><img src="<%=contextPath%>/images/list_13.png"
			width="6" height="36" /></td>
		<td background="<%=contextPath%>/images/list_15.png">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
		 	    <td class="ali_cdn_name">计划编号：</td>
		 	    <td class="ali_cdn_input" style="width: 120px;"><input class="input_width" id="submite_id" name="submite_id" type="text" style="width: 70%;"/>&nbsp;</td>
		 	    <td class="ali_cdn_name">单位：</td>
		 	    <td class="ali_cdn_input" style="width: 220px;">
			 	    <select id="orgSubjectionId" value="">
			 	    	<option value="">全部</option>
			 	    	<option value="C6000000005275">采集项目支持中心</option>
			 	    	<option value="C6000000000039">船舶管理服务中心</option>
			 	    	<option value="C6000000000040">仪器设备服务中心</option>
			 	    	<option value="C6000000005277">人力资源中心</option>
			 	    	<option value="C6000000005278">滩海运载设备服务中心</option>
			 	    	<option value="C6000000005279">小车服务中心</option>
			 	    	<option value="C6000000005280">运输设备服务中心</option>
			 	    	<option value="C6000000007366">物探方法研究所</option>
			 	    </select>
		 	    </td>
		 	    <auth:ListButton functionId="" css="cx" event="onclick='simpleSearch()'" title="JCDP_btn_query"></auth:ListButton>
			    <auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
				<td>&nbsp;</td>
				<td></td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
				<auth:ListButton functionId="" css="dr" event="onclick='AddExcelData()'" title="导入excel"></auth:ListButton>
				<auth:ListButton functionId="" css="dc" event="onclick='outExcelData()'" title="导出excel"></auth:ListButton>
<!-- 			<auth:ListButton functionId="" css="gb" event="onclick='closeData()'" title="关闭"></auth:ListButton> -->
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
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
	<tr>
		<td class="bt_info_odd"
			exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{submite_number}' onclick='chooseOne(this);loadDataDetail();'/>">选择</td>
		<td class="bt_info_even" autoOrder="1">序号</td>
		<td class="bt_info_odd" exp="{submite_id}">计划编号</td>
		<td class="bt_info_even" exp="{org_abbreviation}">队伍</td>
		<td class="bt_info_odd" exp="{project_name}">项目名称</td>
		<td class="bt_info_even" exp="{user_name}">创建人</td>
		<td class="bt_info_odd" exp="{total_money}">金额</td>
		<td class="bt_info_even" exp="{if_submit_dg}">状态</td>
		<td class="bt_info_odd" exp="{create_date}">创建时间</td>
		<td class="bt_info_even" exp="{proc_statue}">状态</td>
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
	<li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">详细计划</a></li>
	<li id='tag3_1' style="display:none"><a href="#" onclick="getTab3(1)">审批流程</a></li>
</ul>
</div>

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
		<td class="bt_info_odd" >发放数量</td>
		<td class="bt_info_odd" >参考单价</td>
		<td class="bt_info_even" >需求日期</td>
		<td class="bt_info_odd" >备注</td>
		</tr>
</table>
</div>
<div id="tab_box_content1" class="tab_box_content" >
			<wf:startProcessInfo   title=""/>
		</div>
</div>
</div>
</body>
<script type="text/javascript">
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
	var orgSubId = "<%=user.getOrgSubjectionId()%>";
	if(orgSubId=="C105007027"){
		orgSubId = "C105007";
	}
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
	function refreshData(){
		
		var sql ='';
			sql +=" select t.submite_number,t.create_date,t.total_money,t.submite_id,u.user_name,o.org_abbreviation,d.coding_name,p.project_name,decode(m.proc_status,'1','待审批','3','审批通过','4','审批不通过','未提交') proc_statue  from gms_mat_demand_plan_bz t  inner join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag='0' inner join comm_org_information o on t.org_id=o.org_id and o.bsflag='0' inner join p_auth_user u on t.creator_id=u.user_id left join comm_coding_sort_detail d on t.s_apply_team=d.coding_code_id and d.bsflag='0' left join common_busi_wf_middle m on t.submite_number=m.business_id and m.bsflag='0' where t.bsflag='0'  and t.if_purchase='9' and t.org_subjection_id like '"+orgSubId+"%'  order by t.create_date desc";
			
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/plan/planItemListDg.jsp";
		queryData(1);
	}
	function loadDataDetail(shuaId){
		if(shuaId!= undefined){
			taskShow(shuaId);
			$("#tag3_1").show();
			
			var project_name = "";
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
			for(var i=1;i<row.length;i++){
				var cell_4 = row[i].cells[4].innerHTML;
				if(row[i].cells[0].firstChild.checked==true){
					if(cell_4=='&nbsp;'){
						project_name='';
						}
					else{
						project_name=cell_4;
						}
							
				}
			}
			
			processNecessaryInfo={
					businessTableName:"GMS_MAT_DEMAND_PLAN_BZ",	
					businessType:"5110000004100001082",
					businessId: shuaId,
					businessInfo:"<%=user.getOrgName()%>-物资计划申请",
					applicantDate: '<%=appDate%>'
				};
				
				processAppendInfo = {
						submiteNumber:shuaId
				};
				loadProcessHistoryInfo();
				
		}else{
			var ids = document.getElementById('rdo_entity_id').value;
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    taskShow(ids);
		}
		
	}
	function toDelete(){
		 ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
		    else{
		    	var retObj = jcdpCallService("MatItemSrv", "getSubTeamDg", "ids="+ids);
	 	    	var submiteIf = retObj.matInfo.ifSubmit;
	 	    	if(submiteIf =='1'){ alert("申请单已被提交!");
	 	     	return;
		 	    }else{
		 	    	if(submiteIf =='3'){ alert("申请单已被审批!");
		 	     	return;
			 	    }
		 	    	else{   
		 	    		if(confirm('确定要删除吗?')){  
			 	   			var retObj = jcdpCallService("MatItemSrv", "deletePlan", "matId="+ids);
			 	   			queryData(cruConfig.currentPage);
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
		    	var retObj = jcdpCallService("MatItemSrv", "getSubTeamDg", "ids="+ids);
	 	    	var submiteIf = retObj.matInfo.ifSubmit;
	 	    	if(submiteIf =='1'){ alert("申请单已被提交!");
	 	     	return;
		 	    }else{
		 	    	if(submiteIf =='3'){ alert("申请单已被审批!");
		 	     	return;
			 	    }
		 	    	else{   
						
						popWindow('<%=contextPath%>/mat/multiproject/plan/planDG/planEditDg.jsp?submite_number='+ids,'1024:800');
			}
			}
		    }
	 }
	 function toAdd(){ 
			  popWindow("<%=contextPath%>/mat/multiproject/plan/planDG/planAddItemListDg.jsp",'1024:800');
	 }  

       function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }   
     //汇总信息
    	 function taskShow(value){
    			for(var j =1;j <document.getElementById("taskTable")!=null && j < document.getElementById("taskTable").rows.length ;){
    				document.getElementById("taskTable").deleteRow(j);
    			}
    			var retObj = jcdpCallService("MatItemSrv", "findPlanList", "ids="+value);
    			var taskList = retObj.matInfo;
    			for(var i =0; taskList!=null && i < taskList.length; i++){
    				var wzName = taskList[i].wzName;
    				var wzId = taskList[i].wzId;
    				var codingCodeId = taskList[i].codingCodeId;
    				var demandNum = taskList[i].demandNum; 
    				var approveNum = taskList[i].approveNum; 
    				var wzPrickie = taskList[i].wzPrickie;
    				var wzPrice = taskList[i].wzPrice;
    				var demandDate = taskList[i].createDate;
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
    		 function AddExcelData(){
    		    	popWindow("<%=contextPath%>/mat/multiproject/plan/planDG/planExcelAddItemList.jsp",'1024:800');
    		        }   
    		 function outExcelData(){
    		    	 ids = getSelIds('rdo_entity_id');
    				    if(ids==''){ alert("请先选中一条记录!");
    				     	return;
    				    }	
    				    else{
    				    	window.location = '<%=contextPath%>/mat/singleproject/plan/outExcelPlanList.srq?submiteNumber='+ids;
    				    }
    		    	
    		        }
		    function closeData(){
		    	ids = getSelIds('rdo_entity_id');
			    if(ids==''){ alert("请先选中一条记录!");
			     	return;
			    }	
			    else{
			    	var retObj = jcdpCallService("MatItemSrv", "getSubTeam", "ids="+ids);
		 	    	var submiteIf = retObj.matInfo.ifSubmit;
		 	    	if(submiteIf =='4'){ alert("申请单已被关闭!");
		 	     	return;
		 	    	}
		 	     	else{
		 	     		if(submiteIf =='0'){ alert("申请单未提交!");
			 	     	return;
		 	     		}
		 	     		else
		 	     		{
					    	if(confirm('确定要关闭吗?')){  
								var retObj = jcdpCallService("MatItemSrv", "closeTeam", "matId="+ids);
								refreshData();
					    	}
		 	     		}
			    	}
			    }
		    }
		    function simpleSearch(){
		    	   var sql =" select t.submite_number,t.create_date,t.total_money,t.submite_id,u.user_name,o.org_abbreviation,t.org_id,d.coding_name,p.project_name,decode(m.proc_status,'1','待审批','3','审批通过','4','审批不通过','未提交') proc_statue  from gms_mat_demand_plan_bz t  inner join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag='0' inner join comm_org_information o on t.org_id=o.org_id and o.bsflag='0' inner join p_auth_user u on t.creator_id=u.user_id left join comm_coding_sort_detail d on t.s_apply_team=d.coding_code_id and d.bsflag='0' left join common_busi_wf_middle m on t.submite_number=m.business_id and m.bsflag='0' where t.bsflag='0'  and t.if_purchase='9' and t.org_subjection_id like '"+orgSubId+"%' ";
					var submite_id = document.getElementById("submite_id").value;
					var submite_type = document.getElementById("orgSubjectionId").value;
					if(submite_id!=""){
						sql+=" and submite_id like '%"+submite_id+"%' ";
						}
					if(submite_type!=""){
						sql+=" and org_id = '"+submite_type+"'";
					}
					 
					sql +=" order by t.create_date desc";
					cruConfig.cdtType = 'form';
					cruConfig.queryStr = sql;
					cruConfig.currentPageUrl = "/mat/singleproject/plan/planItemListDg.jsp";
					queryData(1);
					
			}
		   	
			function clearQueryText(){
				document.getElementById("submite_id").value="";
				document.getElementById("orgSubjectionId").value="";
			} 
			
</script>

</html>

