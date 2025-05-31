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
	String projectName=user.getProjectName();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String projectInfoNo = user.getProjectInfoNo();
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String projectType = user.getProjectType();
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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open2.js"></script>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
<title>无标题文档</title>
</head>

<body style="background: #fff" onload="refreshData();getApplyTeam()">
<div id="list_table">
<div id="inq_tool_box">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="6"><img src="<%=contextPath%>/images/list_13.png"
			width="6" height="36" /></td>
		<td background="<%=contextPath%>/images/list_15.png">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="ali_cdn_name">班组名称：</td>
		 	    <td class="ali_cdn_input"  style="width: 100px;"><select id="s_team" name="s_team" class="select_width"></select></td>
		 	    <td class="ali_cdn_name">创建时间：</td>
		 	    <td class="ali_cdn_input" style="width: 120px;"><input class="input_width" id="s_create_date" name="s_create_date" type="text"  style="width: 70%;"/>&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(s_create_date,tributton1);" /></td>
		 	    <auth:ListButton functionId="" css="cx" event="onclick='simpleSearch()'" title="JCDP_btn_query"></auth:ListButton>
			    <auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
				<td>&nbsp;</td>
				<td></td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
				<auth:ListButton functionId="" css="dr" event="onclick='AddExcelData()'" title="导入excel"></auth:ListButton>
				<auth:ListButton functionId="" css="dc" event="onclick='outExcelData()'" title="导出excel"></auth:ListButton>
				<auth:ListButton functionId="" css="gb" event="onclick='closeData()'" title="关闭"></auth:ListButton>
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
		<td class="bt_info_even" exp="{coding_name}">班组</td>
		<td class="bt_info_odd" exp="{org_abbreviation}">队伍</td>
		<td class="bt_info_even" exp="{user_name}">创建人</td>
<!-- 		<td class="bt_info_odd" exp="{if_purchase}">自采购</td> -->
		<td class="bt_info_odd" exp="{total_money}">金额</td>
		<td class="bt_info_even" exp="{if_submit}">状态</td>
		<td class="bt_info_odd" exp="{create_date}">创建时间</td>
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
	<li id='tag3_1' ><a href="#" onclick="getTab3(1)">审批流程</a></li>
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
		<td class="bt_info_odd" >需求数量</td>
		<td class="bt_info_even" >审核数量</td>
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
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
	var taskObjectId = getQueryString("taskObjectId");
	var projectInfoNo = getQueryString("projectInfoNo");
	function refreshData(){
		
		var sql ='';
			sql +="select t.submite_number,t.create_date,t.total_money,t.submite_id,u.user_name,o.org_abbreviation,d.coding_name,case when t.if_submit = '4' then '已关闭' else (case when m.proc_status = '1' then '待审批' else (case when m.proc_status = '3' then '审批通过' else (case when m.proc_status = '4' then '审批不通过' else '未提交' end) end) end)  end as if_submit,decode(t.if_purchase,'0','是','1','否') if_purchase from gms_mat_demand_plan_bz t inner join comm_org_information o on t.org_id=o.org_id and o.bsflag='0' inner join p_auth_user u on t.creator_id=u.user_id left join comm_coding_sort_detail d on t.s_apply_team=d.coding_code_id and d.bsflag='0' left join common_busi_wf_middle m on t.submite_number=m.business_id and m.bsflag='0' where t.bsflag='0'and t.task_object_id='"+taskObjectId+"'and t.project_info_no='"+projectInfoNo+"' and t.if_purchase='1' order by t.if_purchase desc,t.create_date desc";
			
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/plan/planItemList.jsp";
		queryData(1);
	}
	var projectInfoNo = '<%=projectInfoNo%>';
	function loadDataDetail(shuaId){
		
		if(shuaId!= undefined){
			var tab =document.getElementById("queryRetTable");
			var row = tab.rows;
			var obj = event.srcElement;
			var businessType="";
			var totalMoney = 0;
			for(var i=1;i<row.length;i++){
				var cell_0 = row[i].cells[0].firstChild.checked;
				if(cell_0 == true){
					var cell_6 = row[i].cells[6].innerHTML;
					totalMoney = cell_6;
					
					if((-totalMoney<0)&&(-totalMoney>-10000)){
						businessType = "5110000004100000996";
					}else if((-totalMoney<-10000)&&(-totalMoney>-50000)){
						businessType = "5110000004100000997";
					}else if((-totalMoney<-50000)&&(-totalMoney>-100000)){
						businessType = "5110000004100000998";
					}else if(-totalMoney<-100000){
						businessType = "5110000004100000999";
					}
				}
			}
			
			taskShow(shuaId);
			processNecessaryInfo={
					businessTableName:"GMS_MAT_DEMAND_PLAN_BZ",	
					businessType:businessType,
					businessId: shuaId,
					businessInfo:"<%=projectName%>-物资计划申请",
					applicantDate: '<%=appDate%>'
				};
				
				processAppendInfo = {
						plan_id:shuaId,
						projectName: '<%=projectName%>'
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
		    	var retObj = jcdpCallService("MatItemSrv", "getSubTeamJZ", "ids="+ids);
	 	    	var submiteIf = retObj.matInfo.ifSubmit;
	 	    	if(submiteIf =='1' || submiteIf =='3'){
	 	    		alert("申请单待审批或者已审批,不能操作!");
	 	     		return;
		 	    }else{
	 	    		if(confirm('确定要删除吗?')){  
		 	   			var retObj = jcdpCallService("MatItemSrv", "deletePlan", "matId="+ids);
		 	   			queryData(cruConfig.currentPage);
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
		    	var retObj = jcdpCallService("MatItemSrv", "getSubTeamJZ", "ids="+ids);
	 	    	var submiteIf = retObj.matInfo.ifSubmit;
	 	    	if(submiteIf =='1' || submiteIf =='3'){
	 	    		alert("申请单待审批或者已审批,不能操作!");
	 	     		return;
		 	    }else{
					popWindow('<%=contextPath%>/mat/singleproject/plan/queryPlan.srq?laborId='+ids,'1024:800');
			}
		    }
	 }
	 function toAdd(){ 
		  
			  popWindow("<%=contextPath%>/mat/singleproject/plan/planAddItemList.jsp?taskObjectId="+taskObjectId+"&projectInfoNo="+projectInfoNo,'1024:800');
			
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

    		        td.innerHTML = approveNum;
    		        td.className =tdClass+'_even'
    		        if(autoOrder%2==0){
    					td.style.background = "#FFFFFF";
    				}else{
    					td.style.background = "#ebebeb";
    				}
    		        td = newTR.insertCell(7);

      		        td.innerHTML = wzPrice;
      		        td.className = tdClass+'_odd';
        		        if(autoOrder%2==0){
        					td.style.background = "#f6f6f6";
        				}else{
        					td.style.background = "#e3e3e3";
        				}
        		        td = newTR.insertCell(8);

        		        td.innerHTML = demandDate;
        		        td.className =tdClass+'_even'
        		        if(autoOrder%2==0){
        					td.style.background = "#FFFFFF";
        				}else{
        					td.style.background = "#ebebeb";
        				}
        		        td = newTR.insertCell(9);

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
    		 function toSubmit(){
    				ids = getSelIds('rdo_entity_id');
    			    if(ids==''){ alert("请先选中一条记录!");
    			     	return;
    			    }	
    			    else{
    			    	var retObj = jcdpCallService("MatItemSrv", "getSubTeam", "ids="+ids);
    		 	    	var submiteIf = retObj.matInfo.ifSubmit;
    		 	    	if(submiteIf =='1'){ alert("申请单已被提交!");
    		 	     	return;
    			 	    }else{
    			 	    	if(submiteIf =='3'){ alert("申请单已被审批!");
    			 	     	return;
    				 	    }
    			 	    	else{   
        			 	    	var ifPurchase = retObj.matInfo.ifPurchase;
        			 	    	if(ifPurchase =='0'){
            			 	    	alert("您所提交的数据属于自采购请在流程里面提交！");
            			 	    	return;
            			 	    	}
        			 	    	else{
	    							if(confirm('确定要提交吗?')){  
	    								var retObj = jcdpCallService("MatItemSrv", "updateTeam", "matId="+ids);
	    								refreshData();
    							}
    				}
    				}
    				}
    			    }
    			}
    		 function AddExcelData(){
    		    	popWindow("<%=contextPath%>/mat/singleproject/plan/planExcelAddItemList.jsp?taskObjectId="+taskObjectId,'1024:800');
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
			    	var retObj = jcdpCallService("MatItemSrv", "getSubTeamJZ", "ids="+ids);
		 	    	var submiteIf = retObj.matInfo.ifSubmit;
		 	    	if(submiteIf =='4'){ alert("申请单已被关闭!");
		 	     	return;
		 	    	}
		 	     	else{
		 	     		if(submiteIf ==''){ alert("申请单未提交!");
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
		    	   var sql ="select t.submite_number,t.create_date,t.total_money,t.submite_id,u.user_name,o.org_abbreviation,d.coding_name,decode(t.if_submit,'0','未提交','1','已提交','2','流程','4','已关闭') if_submit,decode(t.if_purchase,'0','是','1','否') if_purchase from gms_mat_demand_plan_bz t inner join comm_org_information o on t.org_id=o.org_id and o.bsflag='0' inner join p_auth_user u on t.creator_id=u.user_id left join comm_coding_sort_detail d on t.s_apply_team=d.coding_code_id and d.bsflag='0'  where t.bsflag='0'and t.task_object_id='"+taskObjectId+"'and t.project_info_no='"+projectInfoNo+"' ";
					var s_team = document.getElementById("s_team").value;
					var s_create_date = document.getElementById("s_create_date").value;
					if(s_team !='' && s_team != null || s_create_date !='' && s_create_date != null){
						if(s_team !=''){
							sql += " and d.coding_name like'%"+s_team+"%'";
						}
						if(s_create_date !=''){
							sql +=" and to_char(t.create_date,'yyyy-mm-dd') like '%"+s_create_date+"%'";
							}
					}
					else{
						alert('请输入查询内容！');
						} 
					sql +=" order by t.create_date desc";
					cruConfig.cdtType = 'form';
					cruConfig.queryStr = sql;
					cruConfig.currentPageUrl = "/mat/singleproject/plan/planItemList.jsp";
					queryData(1);
					
			}
		   	
		       function clearQueryText(){
		   		document.getElementById("s_team").value = "";
		   	} 
			function showTag(value){
				var retObj;
				var retdatas;
				var sql = " select * from gms_mat_demand_plan_bz b where b.submite_number='"+value+"' ";
				var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql);
				retdatas = retObj.datas;
				if(retdatas[0].if_purchase!=1){
					$("#tag3_1").show();
				}
				else{
					$("#tag3_1").hide();
					}
				}
			
			function getApplyTeam(){
		    	var selectObj = document.getElementById("s_team"); 
		    	document.getElementById("s_team").innerHTML="";
		    	selectObj.add(new Option('请选择',""),0);

//		    	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeam","");	
		    	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeamP","projectType=<%=projectType%>");
		    	for(var i=0;i<applyTeamList.detailInfo.length;i++){
		    		var templateMap = applyTeamList.detailInfo[i];
					selectObj.add(new Option(templateMap.label,templateMap.label),i+1);
		    	}   	
		    	selectObj.add(new Option("储备","储备"),applyTeamList.detailInfo.length+1);
		    	selectObj.add(new Option("配件","配件"),applyTeamList.detailInfo.length+2);
		    }
</script>

</html>

