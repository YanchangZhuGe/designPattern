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
	String orgSubId = user.getSubOrgIDofAffordOrg();
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
<title>燃油消耗</title>
</head>

<body style="background: #cdddef" onload="refreshData()">
<div id="list_table">
<div id="inq_tool_box">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="6"><img src="<%=contextPath%>/images/list_13.png"
			width="6" height="36" /></td>
		<td background="<%=contextPath%>/images/list_15.png">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
				
			    <td align="right">
			    <a  href="javascript:downloadModel('主台帐燃油消耗导入模板')">下载模板</a>
			    </td>
			    <auth:ListButton functionId="" css="gl" event="onclick='toSerach()'" title="过滤器"></auth:ListButton>
				<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
				<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
				 <auth:ListButton functionId="" css="dr" event="onclick='AddExcelData()'" title="导入excel"></auth:ListButton>
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
			exp="<input name ='rdo_entity_id' id='rdo_entity_id_{teammat_out_id}' type='checkbox' value='{teammat_out_id}' onclick='loadDataDetail()'/>">选择</td>
		<td class="bt_info_even" autoOrder="1">序号</td>
		<td class="bt_info_odd" exp="{wz_name}">油料名称</td>
		<td class="bt_info_even" exp="{actual_price}">单价</td>
		<td class="bt_info_odd" exp="{oil_num}">油料数量(升)</td>
		<td class="bt_info_even" exp="{mat_num}">油料数量(吨)</td>
		<td class="bt_info_odd" exp="{total_money}">金额(元)</td>
		<td class="bt_info_even" exp="{user_name}">创建人</td>
		<td class="bt_info_odd" exp="{outmat_date}">消耗时间</td>
		<td class="bt_info_even" exp="{oil_from}">油料来源</td>
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
	<li id="tag3_0"><a href="#" onclick="getTab3(0)">详情</a></li>
</ul>
</div>

<div id="tab_box" class="tab_box">

<div id="tab_box_content0" class="tab_box_content">
<table border="0" cellpadding="0" cellspacing="0" id = "taskTable"
	class="tab_line_height" width="100%" style="background: #efefef">
	<tr>
		<td class="bt_info_odd">序号</td>
		<td class="bt_info_even">设备名称</td>
		<td class="bt_info_odd">自编号</td>
		<td class="bt_info_even">牌照号</td>
		<td class="bt_info_odd">实物标识号</td>
		<td class="bt_info_even">操作手</td>
		<td class="bt_info_odd">计量单位</td>
		<td class="bt_info_even">实际单价</td>
		<td class="bt_info_odd">使用数量(升)</td>
		<td class="bt_info_even">使用数量(吨)</td>
		<td class="bt_info_odd">金额</td>
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
		var sql ="select t.teammat_out_id,t.procure_no,t.total_money,t.outmat_date,t.device_use_name,c.dev_name,c.self_num,c.license_num,t.create_date,u.user_name from gms_mat_teammat_out t left join p_auth_user u on t.creator_id=u.user_id and u.bsflag='0' left join gms_device_account_dui c on t.dev_acc_id = c.dev_acc_id where t.out_type='3' and t.bsflag='0'and t.project_info_no='<%=projectInfoNo%>'";
		
		var s_license_num = document.getElementById("s_license_num").value;
		
		if(s_license_num!=''){
			sql+=" and c.license_num like '%"+s_license_num+"%'";
		}else{
			alert('请输入查询内容！');
			return;
		}
		sql+=" order by t.outmat_date desc";
		
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/oilconsumption/consumption_list.jsp";
		queryData(1);
	}
	
	function refreshData(){
		var sql ="select t.teammat_out_id,d.actual_price,t.outmat_date,i.wz_name,u.user_name,decode(t.oil_from,'0','油库','1','加油站','') oil_from,sum(d.oil_num) oil_num,sum(d.mat_num)mat_num,sum(d.total_money)total_money from gms_mat_teammat_out t inner join (gms_mat_teammat_out_detail d inner join gms_mat_infomation i on d.wz_id=i.wz_id)on t.teammat_out_id=d.teammat_out_id and d.bsflag='0' left join p_auth_user u on t.creator_id=u.user_id and u.bsflag='0' where t.out_type='3' and t.bsflag='0'and t.project_info_no is null and t.org_subjection_id like '<%=orgSubId%>%' group by t.teammat_out_id,d.actual_price,t.outmat_date,i.wz_name,u.user_name,t.oil_from order  by t.outmat_date desc";
		
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/rm/dm/devRun/equipmentOperator/eo_list.jsp";
		queryData(1);
	}
	
	function loadDataDetail(shuaId){
		if(shuaId!= undefined){
			taskShow(shuaId);
			 //取消选中框--------------------------------------------------------------------------
	    	var obj = document.getElementsByName("rdo_entity_id");  
		        for (i=0; i<obj.length; i++){   
		            obj[i].checked = false;
		        } 
		      //选中这一条checkbox
			$("#rdo_entity_id_"+shuaId).attr("checked","checked");
			document.getElementById("teammat_out_id").value=shuaId;
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    //取消选中框--------------------------------------------------------------------------
	    	var obj = document.getElementsByName("rdo_entity_id");  
		        for (i=0; i<obj.length; i++){   
		            obj[i].checked = false;
		        } 
		      //选中这一条checkbox
			$("#rdo_entity_id_"+ids).attr("checked","checked");
		    taskShow(ids);
		    document.getElementById("teammat_out_id").value=ids;
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
	    popWindow("<%=contextPath%>/rm/dm/devRun/equipmentOperator/eo_add.jsp",'950:480','-添加燃油消耗');
	 }
	 
	function toEdit(){
		ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
	    else{
	    	var temp = ids.split(",");
		    	if(temp.length==1){
		    		popWindow("<%=contextPath%>/rm/dm/devRun/equipmentOperator/toEOEdit.srq?teammatOutId="+ids,'950:480','-修改燃油消耗');
		    	}else{
		    		alert("请先选中一条记录!");
			    	return;
		    	}
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
		var retObj = jcdpCallService("MatItemSrv", "findDevConsumptionList", "ids="+value);
		var taskList = retObj.matInfo;
		for(var i =0; taskList!=null && i < taskList.length; i++){
			var devName = taskList[i].devName;
			var wzPrickie = taskList[i].wzPrickie;
			var selfNum = taskList[i].selfNum;
			var licenseNum = taskList[i].licenseNum;
			var matNum = taskList[i].matNum;
			var oilNum = taskList[i].oilNum;
			var actualPrice = taskList[i].actualPrice;
			var totalMoney = taskList[i].totalMoney;
			var dev_sign = taskList[i].devSign;
			var operator_name = taskList[i].operatorName;
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
			
	        td.innerHTML = devName;
	        td.className = tdClass+'_odd';
	        if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
	        
	        td = newTR.insertCell(2);
	        td.innerHTML = selfNum;
	        td.className =tdClass+'_even'
	        if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}
	        
			td = newTR.insertCell(3);
	        td.innerHTML = licenseNum;
	        td.className = tdClass+'_odd';
	        if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
	        
	        td = newTR.insertCell(4);
	        td.innerHTML = dev_sign;
	        td.className =tdClass+'_even'
	        if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}
	        
			td = newTR.insertCell(5);
	        td.innerHTML = operator_name;
	        td.className = tdClass+'_odd';
	        if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
	        
	        td = newTR.insertCell(6);
	        td.innerHTML = wzPrickie;
	        td.className =tdClass+'_even'
	        if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}
	      td = newTR.insertCell(7);

	        td.innerHTML = actualPrice;
	        td.className = tdClass+'_odd';
	        if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
	        
	        td = newTR.insertCell(8);
	        td.innerHTML = oilNum;
	        td.className =tdClass+'_even'
	        if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}
	        
	        td = newTR.insertCell(9);
	        td.innerHTML = matNum;
	        td.className =tdClass+'_odd'
	        if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
	        td = newTR.insertCell(10);

	        td.innerHTML = totalMoney;
	        td.className = tdClass+'_even';
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
	function AddExcelData(){
		 popWindow("<%=contextPath%>/rm/dm/devRun/equipmentOperator/eo_import.jsp");
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
	
	
	function downloadModel(filename){
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		window.location.href="<%=contextPath%>/mat/singleproject/mattemplate/download.jsp?path=/rm/dm/devRun/equipmentOperator/oilInport.xlsx&filename="+filename+".xlsx";
	}
</script>

</html>

