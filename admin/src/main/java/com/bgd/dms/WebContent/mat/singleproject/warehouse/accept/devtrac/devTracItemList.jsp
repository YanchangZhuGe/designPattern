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

			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_warehouse_out"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{out_info_id}' onclick='loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{invoices_id}">单号</td>
			      <td class="bt_info_even" exp="{dev_name}">设备</td>
			       <td class="bt_info_odd" exp="{dev_model}">规格型号</td>
			       <td class="bt_info_even" exp="{license_num}">牌照号</td>
			       <td class="bt_info_odd" exp="{self_num}">自编号</td>
			       <td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
			      <td class="bt_info_odd" exp="{total_money}">合计金额</td>
			      <td class="bt_info_even" exp="{out_date}">退货时间</td>
			      <td class="bt_info_odd" exp="{note}">备注</td>
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">验收明细</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">附件</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">分类码</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table  border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="background:#efefef"> 
				    <tr>
				      <td   class="inquire_item6">单号：</td>
				      <td   class="inquire_form6" ><input id="invoices_id" class="input_width_no_color" type="text" value=""/> &nbsp;</td>
				      <td  class="inquire_item6">发料时间：</td>
				      <td  class="inquire_form6"  ><input id="out_date" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>
				      <td  class="inquire_item6">领料单位：</td>
				      <td  class="inquire_form6"  ><input id="org_name" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>
				     </tr>
				     <tr >
				    <td  class="inquire_item6">合计金额：</td>
				     <td  class="inquire_form6"><input id="total_money" class="input_width_no_color" type="text"  value=""/> &nbsp;</td> 
				     <td  class="inquire_item6">项数：</td>
				     <td  class="inquire_form6"><input id="terms_num" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>  
				      <td  class="inquire_item6">运输方式：</td>
				     <td  class="inquire_form6"><input id="transport_type" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>  
				    </tr>
				     <tr >
				     <td  class="inquire_item6">经办：</td>
				     <td  class="inquire_form6"><input id="operator" class="input_width_no_color" type="text"  value=""/> &nbsp;</td> 
				     <td  class="inquire_item6">发料：</td>
				     <td  class="inquire_form6"><input id="storage" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>  
				      <td  class="inquire_item6">提料：</td>
				     <td  class="inquire_form6"><input id="pickupgoods" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>  
				    </tr>
				     <tr >
				     <td  class="inquire_item6">备注：</td>
				     <td  class="inquire_form6"><input id="note" class="input_width_no_color" type="text"  value=""/> &nbsp;</td> 
				     
				    </tr>
				  </table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				   <table id="taskTable" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  >
			    	<tr>
			    		<td class="bt_info_odd">序号</td>
			    	    <td  class="bt_info_even">物资编码</td>
			            <td  class="bt_info_odd">名称</td>
			            <td  class="bt_info_even">单位</td>
			            <td class="bt_info_odd">数量</td>
			            <td  class="bt_info_even">单价</td>
			            <td class="bt_info_odd">金额</td>
			            <td class="bt_info_even">货位</td>
			        </tr>
			        </table>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
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
	function refreshData(){
		
		var sql ="select dui.dev_name,dui.dev_model,dui.self_num,dui.license_num,dui.dev_sign,t.note,t.out_date,t.total_money,t.out_info_id,t.invoices_id,i.org_name,decode(t.if_submit,'0','未提交','1','已提交') if_submit from gms_mat_out_info t  left join gms_device_account_dui dui on t.dev_acc_id=dui.dev_acc_id inner join comm_org_information i on t.org_id=i.org_id and t.bsflag='0'and t.out_type='5'and t.project_info_no='<%=projectInfoNo%>'";
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/warehouse/out/rettrac/tracItemList.jsp";
		queryData(1);
		
	}

	function loadDataDetail(shuaId){
	
		var retObj;
		if(shuaId!= undefined){
			 retObj = jcdpCallService("MatItemSrv", "getTracOut", "laborId="+shuaId);
			
		}else{
			var ids = document.getElementById('rdo_entity_id').value;
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		     retObj = jcdpCallService("MatItemSrv", "getTracOut", "laborId="+ids);
		}
		document.getElementById("invoices_id").value = retObj.matInfo.invoices_id;
		document.getElementById("org_name").value = retObj.matInfo.org_name;
		document.getElementById("out_date").value = retObj.matInfo.out_date;
		document.getElementById("total_money").value = retObj.matInfo.total_money;
		document.getElementById("operator").value = retObj.matInfo.operator;
		document.getElementById("pickupgoods").value = retObj.matInfo.pickupgoods;
		document.getElementById("storage").value = retObj.matInfo.storage;
		document.getElementById("terms_num").value = retObj.matInfo.terms_num;
		document.getElementById("transport_type").value = retObj.matInfo.transport_type;
		document.getElementById("note").value = retObj.matInfo.note;
		taskShow(shuaId);  
		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+shuaId;
		document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+shuaId;
		document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=6&relationId="+shuaId; 
	}
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function toOut(){
		popWindow("<%=contextPath%>/mat/singleproject/matLedger/outChange.jsp");
	}

	  function toAdd(){ 
		 
			  popWindow("<%=contextPath%>/mat/singleproject/warehouse/accept/devtrac/devMatRet.jsp",'1024:800');
			
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
  			var retObj = jcdpCallService("MatItemSrv", "findTracOut", "ids="+value);
  			var taskList = retObj.matInfo;
  			for(var i =0; taskList!=null && i < taskList.length; i++){
  				var wz_code = taskList[i].wz_code;
  				var wz_name = taskList[i].wz_name;
  				var wz_prickie = taskList[i].wz_prickie;
  				var out_num = taskList[i].out_num;
  				var out_price = taskList[i].out_price;
  				var total_money = taskList[i].total_money;
  				var goods_allocation = taskList[i].goods_allocation;
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
  		        td.innerHTML = wz_code;
  		        //debugger;
  		        td.className =tdClass+'_even'
  		        if(autoOrder%2==0){
  					td.style.background = "#FFFFFF";
  				}else{
  					td.style.background = "#ebebeb";
  				}
  		        
  		        td = newTR.insertCell(2);
  				
  		        td.innerHTML = wz_name;
  		        td.className = tdClass+'_odd';
  		        if(autoOrder%2==0){
  					td.style.background = "#f6f6f6";
  				}else{
  					td.style.background = "#e3e3e3";
  				}
  		      td = newTR.insertCell(3);
		        td.innerHTML = wz_prickie;
		        //debugger;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
		        
		        td = newTR.insertCell(4);
				
		        td.innerHTML = out_num;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		        td = newTR.insertCell(5);
  		        td.innerHTML = out_price;
  		        //debugger;
  		        td.className =tdClass+'_even'
  		        if(autoOrder%2==0){
  					td.style.background = "#FFFFFF";
  				}else{
  					td.style.background = "#ebebeb";
  				}
  		        
  		        td = newTR.insertCell(6);
  				
  		        td.innerHTML = total_money;
  		        td.className = tdClass+'_odd';
  		        if(autoOrder%2==0){
  					td.style.background = "#f6f6f6";
  				}else{
  					td.style.background = "#e3e3e3";
  				}
  		      td = newTR.insertCell(7);
		        td.innerHTML = goods_allocation;
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
      function toEdit(){
    	  ids = getSelIds('rdo_entity_id');
    	  if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    else{
	 	    		 popWindow("<%=contextPath%>/mat/singleproject/warehouse/accept/devtrac/devMatOutEdit.jsp?laborId="+ids,'1024:800');
			 	    	}
      }
      function toDelete(){
    	  ids = getSelIds('rdo_entity_id');
    	  if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
    	  else{
		 	    		  if(confirm('确定要删除吗?')){  
		 	 				
		 	 				var retObj = jcdpCallService("MatItemSrv", "deleteTeamOut", "matId="+ids);
		 	 				
		 	 				queryData(cruConfig.currentPage);
		 	 			}
			 	    	}
          }
      function toSubmit(){
    	  ids = getSelIds('rdo_entity_id');
    	  if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
    	  else{
    		    var retObj = jcdpCallService("MatItemSrv", "getTracOut", "laborId="+ids);
	 	    	var ifSubmit = retObj.matInfo.if_submit;
	 	    	if(ifSubmit =='1'){
					alert("申请单已被提交");
					return;
		 	    	}
	 	    	else{
	 	    		 if(confirm('确定要提交吗?')){  
	 					
	 					var retObj = jcdpCallService("MatItemSrv", "submitTeamOut", "matId="+ids);
	 					
	 					queryData(cruConfig.currentPage);
	 				}
		 	    	}
        	  }
          }
</script>

</html>

