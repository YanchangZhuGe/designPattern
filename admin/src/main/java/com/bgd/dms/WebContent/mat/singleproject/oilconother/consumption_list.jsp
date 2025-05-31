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
				<td>&nbsp;</td>
				<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
				<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
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
		<td class="bt_info_odd" exp="{share_name}">分包商</td>
		<td class="bt_info_even" exp="{coding_name}">油料用途</td>
		<td class="bt_info_odd" exp="{team_name}">使用班组</td>
		<td class="bt_info_even" exp="{wz_name}">油料名称</td>
		<td class="bt_info_odd" exp="{actual_price}">单价</td>
		<td class="bt_info_even" exp="{oil_num}">使用数量(升)</td>
		<td class="bt_info_odd" exp="{mat_num}">使用数量(吨)</td>
		<td class="bt_info_even" exp="{total_money}">金额</td>
		<td class="bt_info_odd" exp="{user_name}">创建人</td>
		<td class="bt_info_even" exp="{outmat_date}">消耗时间</td>
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
			<td class="inquire_item6">分包商：</td>
			<td class="inquire_form6">
				<input type="text" id="share_name" name="share_name" class="input_width"  readonly="readonly"/>
			</td>
			<td class="inquire_item6">油料用途：</td>
			<td class="inquire_form6"><input type="text" id="coding_name" name="coding_name" class="input_width" /></td>
			<td class="inquire_item6">使用班组：</td>
			<td class="inquire_form6"><input type="text" id="team_name" name="team_name" class="input_width" /></td>
		</tr>
		<tr>
			<td class="inquire_item6">金额：</td>
			<td class="inquire_form6"><input type="text" id="total_money" name="total_money" class="input_width" /></td>
			<td class="inquire_item6">创建人：</td>
			<td class="inquire_form6"><input type="text" id="user_name" name="user_name" class="input_width" /></td>
			<td class="inquire_item6">消耗时间：</td>
			<td class="inquire_form6"><input type="text" id="outmat_date" name="outmat_date" class="input_width" /></td>
			  </tr>	
			</table>
		</div>

<div id="tab_box_content1" class="tab_box_content">
<table border="0" cellpadding="0" cellspacing="0" id = "taskTable"
	class="tab_line_height" width="100%" style="background: #efefef">
	<tr>
		<td class="bt_info_odd">序号</td>
		<td class="bt_info_even">资源名称</td>
		<td class="bt_info_odd">计量单位</td>
		<td class="bt_info_even">参考单价</td>
		<td class="bt_info_odd">实际单价</td>
		<td class="bt_info_even">使用数量(升)</td>
		<td class="bt_info_odd">使用数量(吨)</td>
		<td class="bt_info_even">金额</td>
	</tr>
</table>
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
	
	// 简单查询
	function simpleSearch(){
		var sql ='';
		sql +="select t.teammat_out_id,t.procure_no,t.total_money,t.outmat_date,t.device_use_name,c.dev_name,c.self_num,c.license_num,t.create_date,u.user_name,i.wz_name,td.actual_price from gms_mat_teammat_out t inner join(GMS_MAT_TEAMMAT_OUT_DETAIL td inner join gms_mat_infomation i on td.wz_id = i.wz_id and i.bsflag = '0') on t.teammat_out_id = td.teammat_out_id and td.bsflag = '0' left join p_auth_user u on t.creator_id=u.user_id and u.bsflag='0' left join gms_device_account_dui c on t.dev_acc_id = c.dev_acc_id where t.out_type='3' and t.bsflag='0'and t.project_info_no='<%=projectInfoNo%>'";
		
		var s_license_num = document.getElementById("s_license_num").value;
		
		if(s_license_num!=''){
			sql+=" and c.license_num like '%"+s_license_num+"%'";
		}else{
			alert('请输入查询内容！');
		}
		sql+=" order by t.outmat_date desc";
		
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/oilconsumption/consumption_list.jsp";
		queryData(1);
	}
	
	function refreshData(){
		var sql ="select t.teammat_out_id,t.device_use_name,t.procure_no,t.outmat_date,t.total_money,u.user_name,d.coding_name team_name,t.drawer share_name,sd.coding_name,i.wz_name,td.actual_price,td.mat_num,td.oil_num from gms_mat_teammat_out t inner join(GMS_MAT_TEAMMAT_OUT_DETAIL td inner join gms_mat_infomation i on td.wz_id = i.wz_id and i.bsflag = '0') on t.teammat_out_id = td.teammat_out_id and td.bsflag = '0' left join p_auth_user u on t.creator_id=u.user_id left join comm_coding_sort_detail d on t.team_id=d.coding_code_id left join comm_coding_sort_detail o on t.drawer=o.coding_code_id left join comm_coding_sort_detail sd on t.use_user=sd.coding_code_id  where t.out_type='4' and t.bsflag='0'and t.project_info_no='<%=projectInfoNo%>'order by t.outmat_date desc";
		
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/oilconother/consumption_list.jsp";
		queryData(1);
	}
	
	function loadDataDetail(shuaId){
			if(shuaId!= undefined){
				retObj = jcdpCallService("MatItemSrv", "viewConOil", "teammat_out_id="+shuaId);
				taskShow(shuaId);
				document.getElementById("teammat_out_id").value=shuaId;
			}else{
				var ids = document.getElementById('rdo_entity_id').value;
			    if(ids==''){ 
				    alert("请先选中一条记录!");
		     		return;
			    }
			    retObj = jcdpCallService("MatItemSrv", "viewConOil", "teammat_out_id="+ids);
			    taskShow(shuaId);
			    document.getElementById("teammat_out_id").value=ids;
			}
				document.getElementById("team_name").value =retObj.map.teamName;
				document.getElementById("total_money").value =retObj.map.totalMoney;
				document.getElementById("user_name").value =retObj.map.userName;
				document.getElementById("outmat_date").value =retObj.map.outmatDate;
				document.getElementById("coding_name").value =retObj.map.codingName;
				document.getElementById("share_name").value =retObj.map.drawer;
			    
		}
		
			
	 function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }
	 
	 
	 function toAdd(){
	    popWindow("<%=contextPath%>/mat/singleproject/oilconother/addConsumption.jsp");
	 }
	 
	function toEdit(){
		ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
	    else{
	    	 popWindow("<%=contextPath%>/mat/singleproject/oilconother/editConsumption.srq?teammatOutId="+ids);
	}
	}
	function toDelete(){
			ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }
		    else{
		    if(confirm('确定要删除吗?')){  
				var retObj = jcdpCallService("MatItemSrv", "deleteConsumption", "ids="+ids);
				queryData(cruConfig.currentPage);
			}
	}
	}
	//汇总信息
	 function taskShow(value){
			for(var j =1;j <document.getElementById("taskTable")!=null && j < document.getElementById("taskTable").rows.length ;){
				document.getElementById("taskTable").deleteRow(j);
			}
			var retObj = jcdpCallService("MatItemSrv", "findConOilList", "ids="+value);
			var taskList = retObj.matInfo;
			for(var i =0; taskList!=null && i < taskList.length; i++){
				var wzName = taskList[i].wzName;
				var wzPrickie = taskList[i].wzPrickie;
				var wzPrice = taskList[i].wzPrice;
				var matNum = taskList[i].matNum;
				var oilNum = taskList[i].oilNum;
				var actualPrice = taskList[i].actualPrice;
				var totalMoney = taskList[i].totalMoney;
				var autoOrder = document.getElementById("taskTable").rows.length;
				var newTR = document.getElementById("taskTable").insertRow(autoOrder);
				var tdClass = 'even';
				if(autoOrder%2==0){
					tdClass = 'odd';
				}
		      
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
				
		        td.innerHTML = wzPrice;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		        td = newTR.insertCell(4);

		        td.innerHTML = actualPrice;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
		      td = newTR.insertCell(5);
		        td.innerHTML = oilNum;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		        
		        td = newTR.insertCell(6);
		        td.innerHTML = matNum;
		        td.className = tdClass+'_even';
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
		        
		        td = newTR.insertCell(7);

		        td.innerHTML = totalMoney;
		        td.className =tdClass+'_odd'
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
			 popWindow("<%=contextPath%>/mat/singleproject/oilconsumption/oilExcelAdd.jsp");
			}
		function toSerach(){
			popWindow('<%=contextPath%>/mat/singleproject/oilconsumption/doc_search.jsp');
		}
		function popSearch(str){
			alert(str);
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = str;
			cruConfig.currentPageUrl = "/mat/singleproject/oilconsumption/consumption_list.jsp";
			queryData(1);
		}
		function clearQueryText(){ 
			document.getElementById("s_license_num").value='';
			cruConfig.cdtStr = "";
		}
</script>

</html>

