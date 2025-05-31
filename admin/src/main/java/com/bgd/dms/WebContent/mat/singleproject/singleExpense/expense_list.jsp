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
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
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
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    </td>
				<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
				<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="提交"></auth:ListButton>
				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
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
	<input type="hidden" id="teammat_out_id" name="teammat_out_id"></input>
	<tr>
		<td class="bt_info_odd"
			exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{teammat_out_id}' onclick='loadDataDetail();chooseOne(this)'/>">选择</td>
		<td class="bt_info_even" autoOrder="1">序号</td>
		<td class="bt_info_odd" exp="{procure_no}">计划单号</td>
		<td class="bt_info_even" exp="{device_use_name}">计划名称</td>
		<td class="bt_info_odd" exp="{dev_ci_name}">设备名称</td>
		<td class="bt_info_even" exp="{license_num}">牌照号</td>
		<td class="bt_info_odd" exp="{self_num}">自编号</td>
		<td class="bt_info_even" exp="{status}">状态</td>
		<td class="bt_info_odd" exp="{user_name}">创建人</td>
		<td class="bt_info_even" exp="{create_date}">创建时间</td>
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
	<li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
	<li id="tag3_1"><a href="#" onclick="getTab3(1)">详情</a></li>
</ul>
</div>

<div id="tab_box" class="tab_box">

<div id="tab_box_content0" class="tab_box_content">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		<tr>
			<td class="inquire_item6">计划单号：</td>
			<td class="inquire_form6">
				<input type="text" id="procure_no" name="procure_no" class="input_width"/>
			</td>
			<td class="inquire_item6">设备名称：</td>
			<td class="inquire_form6">
				<input type="text" id="dev_ci_name" name="dev_ci_name" class="input_width"  readonly="readonly"/>
			</td>
			<td class="inquire_item6">状态：</td>
			<td class="inquire_form6"><input type="text" id="status" name="status" class="input_width" /></td>
		</tr>
		<tr>
			<td class="inquire_item6">自编号：</td>
			<td class="inquire_form6">
				<input type="text" id="self_num" name="self_num" class="input_width"/>
			</td>
			<td class="inquire_item6">牌照号：</td>
			<td class="inquire_form6">
				<input type="text" id="license_num" name="license_num" class="input_width"  readonly="readonly"/>
			</td>
			<td class="inquire_item6">创建人：</td>
			<td class="inquire_form6"><input type="text" id="user_name" name="user_name" class="input_width" /></td>
		</tr>
		<tr>
			<td class="inquire_item6">创建时间：</td>
			<td class="inquire_form6"><input type="text" id="create_date" name="create_date" class="input_width" /></td>
			<td class="inquire_item6">金额：</td>
			<td class="inquire_form6"><input type="text" id="total_money" name="total_money" class="input_width" /></td>
			<td class="inquire_item6"></td>
			<td class="inquire_form6"></td>
					  </tr>	
					  <tr>
					    <td class="inquire_item6">备注：</td>
					    <td class="inquire_form6" colspan="5"><textarea id="notes" name="notes" class="textarea"  ></textarea></td>
					  </tr>	
					</table>
				</div>

<div id="tab_box_content1" class="tab_box_content">
<from name="form_task" id ="form_task" method = "post" action="" >
<input type='hidden' id="plan_id" value=''/>
<table border="0" cellpadding="0" cellspacing="0" id = "taskTable"
	class="tab_line_height" width="100%" style="background: #efefef">
	<tr>
		<td class="bt_info_odd">序号</td>
		<td class="bt_info_even">物资分类码</td>
		<td class="bt_info_odd">物资编码</td>
		<td class="bt_info_even">资源名称</td>
		<td class="bt_info_odd">计量单位</td>
		<td class="bt_info_even">参考单价</td>
		<td class="bt_info_odd">计划数量</td>
		<td class="bt_info_even">领出数量</td>
	</tr>
</table>
</from>
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
			sql +="select o.teammat_out_id,o.procure_no,o.device_use_name,decode(o.status,'0','未提交','1','已提交','2','已关闭') status,c.dev_ci_name,o.create_date,u.user_name,r.notes,ad.license_num,ad.self_num from gms_mat_teammat_out o inner join GMS_MAT_DEVICE_USE_INFO_DETAIL d on o.teammat_out_id=d.teammat_out_id  join gms_device_codeinfo c on o.device_id = c.dev_ci_code  join p_auth_user u on o.creator_id=u.user_id and u.bsflag='0' left join gms_device_account_dui ad on o.dev_acc_id = ad.dev_acc_id and ad.bsflag='0' left join bgp_comm_remark r on o.teammat_out_id =r.foreign_key_id and r.bsflag='0'  where o.bsflag='0'and o.project_info_no='<%=projectInfoNo%>'group by o.teammat_out_id,o.procure_no,o.device_use_name,o.status,c.dev_ci_name,o.create_date,u.user_name,r.notes,o.modifi_date,ad.license_num,ad.self_num order by o.modifi_date desc";
			
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/singleExpense/expense_list.jsp";
		queryData(1);
	}
	
	function loadDataDetail(shuaId){
			if(shuaId!= undefined){
				retObj = jcdpCallService("MatItemSrv", "viewExpense", "teammat_out_id="+shuaId);
				taskShow(shuaId);
				document.getElementById("teammat_out_id").value=shuaId;
			}else{
				var ids = document.getElementById('rdo_entity_id').value;
			    if(ids==''){ 
				    alert("请先选中一条记录!");
		     		return;
			    }
			    retObj = jcdpCallService("MatItemSrv", "viewExpense", "teammat_out_id="+ids);
			    taskShow(ids);
			    document.getElementById("teammat_out_id").value=ids;
			}
				document.getElementById("procure_no").value =retObj.matInfo.procure_no;
				document.getElementById("dev_ci_name").value =retObj.matInfo.dev_name;
				document.getElementById("status").value =retObj.matInfo.stat;
				document.getElementById("user_name").value =retObj.matInfo.user_name;
				document.getElementById("create_date").value =retObj.matInfo.create_date;
				document.getElementById("notes").value =retObj.matInfo.notes;
				document.getElementById("self_num").value =retObj.matInfo.self_num;
				document.getElementById("license_num").value =retObj.matInfo.license_num;
				document.getElementById("total_money").value =retObj.matInfo.total_money;
			    
		}
		
		//汇总信息
	 function taskShow(value){
			for(var j =1;j <document.getElementById("taskTable")!=null && j < document.getElementById("taskTable").rows.length ;){
				document.getElementById("taskTable").deleteRow(j);
			}
			var retObj = jcdpCallService("MatItemSrv", "queryExpense", "ids="+value);
			var taskList = retObj.datas;
			for(var i =0; taskList!=null && i < taskList.length; i++){
				var coding_code_id = taskList[i].coding_code_id;
				var wz_id = taskList[i].wz_id;
				var wz_name = taskList[i].wz_name;
				var wz_prickie = taskList[i].wz_prickie;
				var wz_price = taskList[i].wz_price;
				var plan_num = taskList[i].plan_num;
				var use_num = taskList[i].use_num;
				var autoOrder = document.getElementById("taskTable").rows.length;
				var newTR = document.getElementById("taskTable").insertRow(autoOrder);
				var tdClass = 'even';
				if(autoOrder%2==0){
					tdClass = 'odd';
				}
		        var td = newTR.insertCell(0);

		        td.innerHTML = autoOrder;
		        //debugger;
		        td.className =tdClass+'odd'
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		        
		        td = newTR.insertCell(1);
				
		        td.innerHTML = coding_code_id;
		        td.className = tdClass+'_even';
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
		        
		        td = newTR.insertCell(2);

		        td.innerHTML = wz_id;
		        td.className =tdClass+'_odd'
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
 				td = newTR.insertCell(3);
				
		        td.innerHTML = wz_name;
		        td.className = tdClass+'_even';
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
		        
		        td = newTR.insertCell(4);

		        td.innerHTML = wz_prickie;
		        td.className =tdClass+'_odd'
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
				td = newTR.insertCell(5);
				
		        td.innerHTML = wz_price;
		        td.className = tdClass+'_even';
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
		        td = newTR.insertCell(6);

		        td.innerHTML = plan_num;
		        td.className =tdClass+'_odd'
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
				td = newTR.insertCell(7);
				
		        td.innerHTML = use_num;
		        td.className = tdClass+'_even';
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
		        td = newTR.insertCell(8);
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
	    popWindow("<%=contextPath%>/mat/singleproject/singleExpense/addExpense.jsp",'1024:800');
	 }
	 
	function toEdit(){
		var teammat_out_id = document.getElementById("teammat_out_id").value;
	  	if(teammat_out_id==''||teammat_out_id==null){  
	  		alert("请选择一条信息!");  
	  		return;  
	  	} 
	  	
	  	var checkSql="select o.teammat_out_id,o.device_use_name,decode(o.status,'0','未提交','1','已提交','2','已关闭') status,c.dev_ci_name,o.create_date,u.user_name,r.notes from gms_mat_teammat_out o join gms_device_codeinfo c on o.device_id = c.dev_ci_code  join p_auth_user u on o.creator_id=u.user_id and u.bsflag='0'  left join bgp_comm_remark r on o.teammat_out_id =r.foreign_key_id and r.bsflag='0'  where o.teammat_out_id='"+teammat_out_id+"' and o.bsflag='0' order by o.modifi_date desc";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas!=null&&datas!=""){
			var status = datas[0].status;
			if(status!="未提交"){
				alert("该记录"+status+"，不能修改");
				return;
			}
		}
		
	  	popWindow("<%=contextPath%>/mat/singleproject/expense/viewExpense.srq?teammat_out_id="+teammat_out_id);	    
	}
	 
	function toSubmit(){
		ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    debugger;
	    var temp = ids.split(',');
	    for(var i=0;i<temp.length;i++){
	    	var checkSql="select o.teammat_out_id,o.device_use_name,decode(o.status,'0','未提交','1','已提交','2','已关闭') status,c.dev_ci_name,o.create_date,u.user_name,r.notes from gms_mat_teammat_out o join gms_device_codeinfo c on o.device_id = c.dev_ci_code  join p_auth_user u on o.creator_id=u.user_id and u.bsflag='0'  left join bgp_comm_remark r on o.teammat_out_id =r.foreign_key_id and r.bsflag='0'  where o.teammat_out_id='"+temp[i]+"' and o.bsflag='0' order by o.modifi_date desc";
		    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;
			if(datas!=null&&datas!=""){
				var status = datas[0].status;
				if(status!="未提交"){
					alert("该记录"+status+"，不能提交");
					return;
				}
			}
	    }
	    var sql = "update gms_mat_teammat_out set status='1' where  bsflag='0' and teammat_out_id='{id}'";
		if (!window.confirm("确认要提交吗?")) {
			return;
		}
		var path = cruConfig.contextPath+"/rad/asyncUpdateEntitiesBySql.srq";
		var params = "sql="+sql;
		params += "&ids="+ids;
		var retObject = syncRequest('Post',path,params);
		if(retObject.returnCode!=0) alert(retObject.returnMsg);
		else queryData(cruConfig.currentPage);
	}
			
	 
	function toDelete(){
			ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
		    var temp = ids.split(',');
		    for(var i=0;i<temp.length;i++){
		    	var checkSql="select o.teammat_out_id,o.device_use_name,decode(o.status,'0','未提交','1','已提交','2','已关闭') status,c.dev_ci_name,o.create_date,u.user_name,r.notes from gms_mat_teammat_out o join gms_device_codeinfo c on o.device_id = c.dev_ci_code  join p_auth_user u on o.creator_id=u.user_id and u.bsflag='0' left join bgp_comm_remark r on o.teammat_out_id =r.foreign_key_id and r.bsflag='0'  where o.teammat_out_id='"+temp[i]+"' and o.bsflag='0' order by o.modifi_date desc";
			    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
				var datas = queryRet.datas;
				if(datas!=null&&datas!=""){
					var status = datas[0].status;
					if(status!="未提交"){
						alert("该记录"+status+"，不能删除");
						return;
					}
				}
		    }
		    if(confirm('确定要删除吗?')){  
				var retObj = jcdpCallService("MatItemSrv", "deleteExpense", "ids="+ids);
				queryData(cruConfig.currentPage);
			}
	}
	  function closeData(){
		  ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
		    var temp = ids.split(',');
		    for(var i=0;i<temp.length;i++){
		    	var checkSql="select o.teammat_out_id,o.device_use_name,decode(o.status,'0','未提交','1','已提交','2','已关闭') status,c.dev_ci_name,o.create_date,u.user_name,r.notes from gms_mat_teammat_out o join gms_device_codeinfo c on o.device_id = c.dev_ci_code  join p_auth_user u on o.creator_id=u.user_id and u.bsflag='0' left join bgp_comm_remark r on o.teammat_out_id =r.foreign_key_id and r.bsflag='0'  where o.teammat_out_id='"+temp[i]+"' and o.bsflag='0' order by o.modifi_date desc";
			    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
				var datas = queryRet.datas;
				if(datas!=null&&datas!=""){
					var status = datas[0].status;
					if(status!="已提交"){
						alert("该记录"+status+"，不能关闭");
						return;
					}
				}
		    }
		    if(confirm('确定要关闭吗?')){  
				var retObj = jcdpCallService("MatItemSrv", "closeExpense", "ids="+ids);
				queryData(cruConfig.currentPage);
			}
		    
	    }
</script>

</html>

