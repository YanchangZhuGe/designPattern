<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
	String contextPath = request.getContextPath();
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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>无标题文档</title>
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
				<td class="ali3" align='left'>审核结果：
				<select id="lockedIf" name="lockedIf"   onchange="testQuery(this)">
				<option value="0" selected="selected">全部</option>
				<option value="3">待调剂</option>
				<option value="5">调剂通过</option>
				<option value="4">调剂不通过</option>
			    </select>
				</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    </td>
				<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_audit"></auth:ListButton>
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
			exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{plan_invoice_id}' onclick='loadDataDetail();'/>">选择</td>
		<td class="bt_info_even" autoOrder="1">序号</td>
		<td class="bt_info_odd" exp="{plan_invoice_id}">申请单号</td>
		<td class="bt_info_even" exp="{org_name}">队伍</td>
		<td class="bt_info_odd" exp="{project_name}">项目</td>
		<td class="bt_info_even" exp="{compile_date}">需求日期</td>
		<td class="bt_info_odd" exp="{creator_id}">创建人</td>
		<td class="bt_info_even" exp="{submite_if}">送审状态</td>
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
				<li id="tag3_1"><a href="#" onclick="getTab3(1)">明细信息</a></li>
				<li id="tag3_2"><a href="#" onclick="getTab3(2)">审批信息</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">备注</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">附件</a></li>
			    <li id="tag3_5"><a href="#" onclick="getTab3(5)">分类码</a></li>
</ul>
</div>

<div id="tab_box" class="tab_box">
<div id="tab_box_content0" class="tab_box_content">
<from name="form_task" id ="form_task" method = "post" action="" >
<input type='hidden' id="plan_id" value=''/>
<table border="0" cellpadding="0" cellspacing="0" id = "taskTable"
	class="tab_line_height" width="100%" style="background: #efefef">
	<tr>
		<td class="bt_info_odd" exp="<input type='checkbox' name='task_entity_id' 
		value='' onclick=doCheck(this)/>" >
	    <input type='checkbox' name='task_entity_id' value='' onclick='check()'/></td>
		<td class="bt_info_odd">序号</td>
		<td class="bt_info_even">物资名称</td>
		<td class="bt_info_odd">计量单位</td>
		<td class="bt_info_even">需求数量</td>
		<td class="bt_info_odd">参考单价</td>
		<td class="bt_info_even">现有数量</td>
		<td class="bt_info_odd">可调计量</td>
		<td class="bt_info_even">物资说明</td>
		<td class="bt_info_odd">物资类别</td>
	</tr>
</table>
</from>
</div>
<div id="tab_box_content1" class="tab_box_content"
	style="display: none;">
<table id="projectMap" width="100%" border="0" cellspacing="0"
	cellpadding="0" class="tab_line_height">
	<tr>
		<td class="bt_info_odd">序号</td>
		<td class="bt_info_even">班组</td>
		<td class="bt_info_odd">物资名称</td>
		<td class="bt_info_even">需求数量</td>
		<td class="bt_info_odd">需求日期</td>
		<td class="bt_info_even">备注</td>
	</tr>
</table>
</div>
<div id="tab_box_content2" class="tab_box_content"
	style="display: none;">
<table id="projectMap" width="100%" border="0" cellspacing="0"
	cellpadding="0" class="tab_line_height">
	<tr>
		<td class="bt_info_odd">序号</td>
		<td class="bt_info_even">审批状态</td>
		<td class="bt_info_odd">审批时间</td>
		<td class="bt_info_even">审批人</td>
		<td class="bt_info_odd">审批意见</td>
	</tr>
</table>
</div>
<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="annex" id="annex" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content5" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
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
			sql +="select distinct i.org_name,g.project_name,t.compile_date,t.creator_id ,t.plan_invoice_id, decode(t.submite_if,'3','等待调剂','4','调剂未通过','5','调剂通过') submite_if from gms_mat_demand_plan_invoice t inner join gms_mat_demand_plan p on t.plan_invoice_id=p.plan_invoice_id and p.regulate_num>0 inner join gp_task_project g on t.project_info_no=g.project_info_no inner join comm_org_information i on t.org_id=i.org_id and i.bsflag='0' where t.bsflag = '0'and t.submite_if>'2'";
			
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/multiproject/matapprove/planAppList.jsp";
		queryData(1);
	}
	
		function loadDataDetail(shuaId){
			if(shuaId!= undefined){
				taskShow(shuaId);
				
			}else{
				var ids = document.getElementById('rdo_entity_id').value;
			    if(ids==''){ 
				    alert("请先选中一条记录!");
		     		return;
			    }
			    taskShow(ids);
			}
			document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+shuaId;
			document.getElementById("annex").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+shuaId;
			document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=6&relationId="+shuaId;    
		}
		//汇总信息
	 function taskShow(value){
			for(var j =1;j <document.getElementById("taskTable")!=null && j < document.getElementById("taskTable").rows.length ;){
				document.getElementById("taskTable").deleteRow(j);
			}
			var retObj = jcdpCallService("MatItemSrv", "getAppList", "ids="+value);
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
		        var td = newTR.insertCell(0);

		        td.innerHTML = "<input type='checkbox' name='task_entity_id' value=''/>";
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}

		        td = newTR.insertCell(1);
		        td.innerHTML = autoOrder;
		        //debugger;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
		        
		        td = newTR.insertCell(2);
				
		        td.innerHTML = wzName;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		        
		        td = newTR.insertCell(3);

		        td.innerHTML = wzPrickie;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
				td = newTR.insertCell(4);
				
		        td.innerHTML = demandNum;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		        td = newTR.insertCell(5);

		        td.innerHTML = wzPrice;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
				td = newTR.insertCell(6);
		        td.innerHTML = haveNum;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		        td = newTR.insertCell(7);

		        td.innerHTML =regulateNum;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
				td = newTR.insertCell(8);
				
		        td.innerHTML = description;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		        td = newTR.insertCell(9);

		        td.innerHTML = codeName;
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
	 function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }
	    function toAdd(){
	    	 ids = getSelIds('rdo_entity_id');
	 	    if(ids==''){ alert("请先选中一条记录!");
	 	     	return;
	 	    }	
	 	   popWindow("<%=contextPath%>/mat/multiproject/matapprove/planAppEdit.jsp?planInvoiceId="+ids,'1024:800');

		    }  
	    //查询函数
	    function  testQuery(selectThis){
			//alert(selectThis.options[selectThis.selectedIndex].text);
	 		var sql = "";
			if(selectThis.options[selectThis.selectedIndex].value=='0'){
				sql +="select distinct i.org_name,g.project_name,t.compile_date,t.creator_id ,t.plan_invoice_id, decode(t.submite_if,'3','等待调剂','4','调剂未通过','5','调剂通过') submite_if from gms_mat_demand_plan_invoice t inner join gms_mat_demand_plan p on t.plan_invoice_id=p.plan_invoice_id and p.regulate_num>0 inner join gp_task_project g on t.project_info_no=g.project_info_no inner join comm_org_information i on t.org_id=i.org_id and i.bsflag='0' where t.bsflag = '0'and t.submite_if>'2'";
			}else{
			 
				sql += "select distinct i.org_name,g.project_name,t.compile_date,t.creator_id ,t.plan_invoice_id, decode(t.submite_if,'3','等待调剂','4','调剂未通过','5','调剂通过') submite_if from gms_mat_demand_plan_invoice t inner join gms_mat_demand_plan p on t.plan_invoice_id=p.plan_invoice_id and p.regulate_num>0 inner join gp_task_project g on t.project_info_no=g.project_info_no inner join comm_org_information i on t.org_id=i.org_id and i.bsflag='0' where t.bsflag = '0'and t.submite_if='"+selectThis.options[selectThis.selectedIndex].value+"'";
			
			}
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = sql;
			cruConfig.currentPageUrl = "/mat/multiproject/matapprove/planAppList.jsp";
			queryData(1);
			 
		} 
</script>

</html>

