<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String orgName = user.getOrgName();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>无标题文档</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">物资单号：</td>
		 	    <td class="ali_cdn_input"><input class="input_width" id="s_wz_name" name="s_wz_name" type="text" /></td>
				   <auth:ListButton functionId="" css="cx" event="onclick='simpleSearch()'" title="JCDP_btn_query"></auth:ListButton>
			    	<auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
			    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>

			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_warehouse_entry"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='toOutExcel()'" title="导出"></auth:ListButton>
			    <td></td>
			    <td></td>
			    <td></td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{invoices_id}' onclick='loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{invoices_no}">料单编号</td>
			      <td class="bt_info_odd" exp="{total_money}">金额</td>
			      <td class="bt_info_even" exp="{input_date}">验收日期</td>
			      <td class="bt_info_odd" exp="{operator}">经办人</td>
			      <td class="bt_info_even" exp="{pickupgoods}">提货人</td>
			      <td class="bt_info_odd" exp="{storage}">保管人</td>
			      <td class="bt_info_even" exp="{method}">入库方式</td>
			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">料签信息</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">验收明细</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">备注</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">附件</a></li>
			    <li id="tag3_5"><a href="#" onclick="getTab3(5)">分类码</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table  border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="background:#efefef"> 
				    <tr>
				      <td   class="inquire_item6">料单编号：</td>
				      <td   class="inquire_form6" ><input id="procure_no" class="input_width_no_color" type="text" value=""/> &nbsp;</td>
				      <td  class="inquire_item6">接收单位：</td>
				      <td  class="inquire_form6"  ><input id="org_name" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;金额：</td>
				      <td  class="inquire_form6"  ><input id="total_money" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>
				     </tr>
				     <tr >
				     <td  class="inquire_item6">验收日期：</td>
				     <td  class="inquire_form6"><input id="input_date" class="input_width_no_color" type="text"  value=""/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;经办：</td>
				     <td  class="inquire_form6"><input id="operator" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>  
				      <td  class="inquire_item6">&nbsp;提货：</td>
				     <td  class="inquire_form6"><input id="pickupgoods" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>  
				    </tr>
				     <tr >
				     <td  class="inquire_item6">保管：</td>
				     <td  class="inquire_form6"><input id="storage" class="input_width_no_color" type="text"  value=""/> &nbsp;</td> 
				    <td  class="inquire_item6">备注：</td>
				     <td  class="inquire_form6"><input id="note" class="input_width_no_color" type="text"  value=""/> &nbsp;</td> 
				    </tr>
				  </table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				   <table id="projectMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  >
			    	<tr>
			    	    <td  class="bt_info_odd">序号</td>
			            <td  class="bt_info_even">库(场)</td>
			            <td class="bt_info_odd">架(区)</td>
			            <td  class="bt_info_even">层(排)</td>
			            <td class="bt_info_odd">位</td>
			            <td  class="bt_info_even">无动态年限</td>
			            <td class="bt_info_odd">备注</td>
			        </tr>
			        </table>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				   <table id="taskTable" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  >
			    	<tr>
			    		<td class="bt_info_odd">序号</td>
			    	    <td  class="bt_info_even">物资名称</td>
			            <td  class="bt_info_odd">入库数量</td>
			            <td class="bt_info_even">入库单价</td>
			            <td  class="bt_info_odd">金额</td>
			            <td class="bt_info_even">收料库</td>
			            <td  class="bt_info_odd">货位</td>
			            <td class="bt_info_even">接受编号</td>
			            <td  class="bt_info_odd">入库类别</td>
			            <td class="bt_info_even">入库时间</td>
			        </tr>
			        </table>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
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
	cruConfig.contextPath =  "<%=contextPath%>";
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
	var codeId = getQueryString("codeId");
	function refreshData(){
		var sql ="select t.invoices_id,t.invoices_no,t.total_money,t.input_date,t.operator,t.note,t.pickupgoods,t.storage,decode(t.source,null, '自验收', '转入') as  method from GMS_MAT_TEAMMAT_INVOICES t left join comm_org_information i on t.source=i.org_id and i.bsflag='0' where t.project_info_no='<%=projectInfoNo%>' and (t.invoices_type='5' or ((t.invoices_type='4' or t.invoices_type='1' or t.invoices_type='2') and t.source is not null )) and t.if_input='0' and t.bsflag='0' order by t.input_date desc,t.create_date desc";
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/matLedger/matItemList.jsp";
		queryData(1);
	}

	function loadDataDetail(shuaId){
	
		var retObj;
		if(shuaId!= undefined){
			 retObj = jcdpCallService("MatItemSrv", "getPurList", "laborId="+shuaId);
			
		}else{
			var ids = document.getElementById('rdo_entity_id').value;
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		     retObj = jcdpCallService("MatItemSrv", "getPurList", "laborId="+ids);
		}
		document.getElementById("procure_no").value = retObj.matInfo.invoices_no;
		document.getElementById("org_name").value = "<%=orgName%>";
		document.getElementById("input_date").value = retObj.matInfo.input_date;
		document.getElementById("operator").value = retObj.matInfo.operator;
		document.getElementById("pickupgoods").value = retObj.matInfo.pickupgoods;
		document.getElementById("total_money").value = retObj.matInfo.total_money;
		document.getElementById("storage").value = retObj.matInfo.storage;
		document.getElementById("note").value = retObj.matInfo.note;
		taskShow(shuaId); 
		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+shuaId;
		document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+shuaId;
		document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=6&relationId="+shuaId;
	}
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	  function toAdd(){ 
		 
			  popWindow("<%=contextPath%>/mat/singleproject/warehouse/accept/selfaccept/acceptLedgerAdd.jsp",'1024:800');
			
	 }  
		function toEdit(){
			ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				alert("请选择一条记录!");
				return;
			}
			popWindow("<%=contextPath%>/mat/singleproject/warehouse/accept/selfaccept/queryAcceptDatas.srq?laborId="+ids,'1024:800');
			}
		function toDelete(){
	 		
		    ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
			    
			if(confirm('确定要删除吗?')){  
				
				var retObj = jcdpCallService("MatItemSrv", "deleteAcceptDatas", "laborId="+ids);
				queryData(cruConfig.currentPage);
			}  
		}
       function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }  
       function simpleSearch(){
    	   var sql ='';
			var wz_name = document.getElementById("s_wz_name").value;
			sql+="select g.wz_id ,g.coding_code_id,g.wz_name,g.wz_prickie,g.wz_code,g.wz_price,g.note,w.stock_num from gms_mat_infomation g inner join gms_mat_teammat_info w on g.wz_id = w.wz_id and w.bsflag ='0' and g.wz_name like'%"+wz_name+"%'"
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = sql;
			cruConfig.currentPageUrl = "/mat/singleproject/matLedger/matItemList.jsp";
			queryData(1);
			
	}
       function clearQueryText(){
   		document.getElementById("s_wz_name").value = "";
   	} 
       //验收明细信息
    	 function taskShow(value){
    			for(var j =1;j <document.getElementById("taskTable")!=null && j < document.getElementById("taskTable").rows.length ;){
    				document.getElementById("taskTable").deleteRow(j);
    			}
    			var retObj = jcdpCallService("MatItemSrv", "findPruList", "ids="+value);
    			var taskList = retObj.matInfo;
    			for(var i =0; taskList!=null && i < taskList.length; i++){
    				var coding_code_id = taskList[i].coding_code_id;
    				var wz_name = taskList[i].wz_name;
    				var mat_num = taskList[i].mat_num;
    				var actual_price = taskList[i].actual_price;
    				var total_money = taskList[i].total_money;
    				var warehouse_number = taskList[i].warehouse_number;
    				var goods_allocation = taskList[i].goods_allocation;
    				var receive_number = taskList[i].receive_number;
    				var input_type = taskList[i].input_type;
    				var create_date = taskList[i].input_date;
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
    		        td.innerHTML = wz_name;
    		        //debugger;
    		        td.className =tdClass+'_even'
    		        if(autoOrder%2==0){
    					td.style.background = "#FFFFFF";
    				}else{
    					td.style.background = "#ebebeb";
    				}
    		        
    		        td = newTR.insertCell(2);
    				
    		        td.innerHTML = mat_num;
    		        td.className = tdClass+'_odd';
    		        if(autoOrder%2==0){
    					td.style.background = "#f6f6f6";
    				}else{
    					td.style.background = "#e3e3e3";
    				}
    		      td = newTR.insertCell(3);
  		        td.innerHTML = actual_price;
  		        //debugger;
  		        td.className =tdClass+'_even'
  		        if(autoOrder%2==0){
  					td.style.background = "#FFFFFF";
  				}else{
  					td.style.background = "#ebebeb";
  				}
  		        
  		        td = newTR.insertCell(4);
  				
  		        td.innerHTML = total_money;
  		        td.className = tdClass+'_odd';
  		        if(autoOrder%2==0){
  					td.style.background = "#f6f6f6";
  				}else{
  					td.style.background = "#e3e3e3";
  				}
  		        td = newTR.insertCell(5);
    		        td.innerHTML = warehouse_number;
    		        //debugger;
    		        td.className =tdClass+'_even'
    		        if(autoOrder%2==0){
    					td.style.background = "#FFFFFF";
    				}else{
    					td.style.background = "#ebebeb";
    				}
    		        
    		        td = newTR.insertCell(6);
    				
    		        td.innerHTML = goods_allocation;
    		        td.className = tdClass+'_odd';
    		        if(autoOrder%2==0){
    					td.style.background = "#f6f6f6";
    				}else{
    					td.style.background = "#e3e3e3";
    				}
    		      td = newTR.insertCell(7);
  		        td.innerHTML = receive_number;
  		        //debugger;
  		        td.className =tdClass+'_even'
  		        if(autoOrder%2==0){
  					td.style.background = "#FFFFFF";
  				}else{
  					td.style.background = "#ebebeb";
  				}
  		        
  		        td = newTR.insertCell(8);
  				
  		        td.innerHTML = input_type;
  		        td.className = tdClass+'_odd';
  		        if(autoOrder%2==0){
  					td.style.background = "#f6f6f6";
  				}else{
  					td.style.background = "#e3e3e3";
  				}
  		        td = newTR.insertCell(9);
    		        td.innerHTML = create_date;
    		        //debugger;
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
    	 function toOutExcel(){
 			 ids = getSelIds('rdo_entity_id');
  		    if(ids==''){ alert("请先选中一条记录!");
  		     	return;
  		    }	
  		    else{
  		    	window.location = '<%=contextPath%>/mat/singleproject/warehouse/accept/selfaccept/acceptItemList.srq?id='+ids;
  		    }
 	 		}
</script>

</html>

