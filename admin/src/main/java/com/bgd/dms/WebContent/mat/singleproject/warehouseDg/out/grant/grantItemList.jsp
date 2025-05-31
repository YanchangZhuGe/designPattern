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
			    <td class="ali_cdn_name">出库单号：</td>
		 	    <td class="ali_cdn_input"><input class="input_width" id="s_wz_name" name="s_wz_name" type="text" /></td>
				<auth:ListButton functionId="" css="cx" event="onclick='simpleSearch()'" title="JCDP_btn_query"></auth:ListButton>
			    <auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_warehouse_out"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="修改"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='outExcelData()'" title="导出excel"></auth:ListButton>
			    <auth:ListButton functionId="" css="dr" event="onclick='inExcelData()'" title="导入excel"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{teammat_out_id}' onclick='loadDataDetail()'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{procure_no}">单号</td>
			      <td class="bt_info_odd" exp="{coding_name}">物资用途</td>
			      <td class="bt_info_even" exp="{tname}">使用单位</td>
			      <td class="bt_info_odd" exp="{out_type}">出库类型</td>
			      <td class="bt_info_even" exp="{total_money}">合计金额</td>
			      <td class="bt_info_odd" exp="{outmat_date}">发料时间</td>
			      <td class="bt_info_even" exp="{note}">备注</td>
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">发放明细</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">附件</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">分类码</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table  border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="background:#efefef"> 
				    <tr>
				      <td   class="inquire_item6">编号：</td>
				      <td   class="inquire_form6" ><input id="teammat_out_id" class="input_width_no_color" type="text" value=""/> &nbsp;</td>
				      <td  class="inquire_item6">发料时间：</td>
				      <td  class="inquire_form6"  ><input id="create_date" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>
				      <td  class="inquire_item6">班组/设备：</td>
				      <td  class="inquire_form6" ><input id="team_dev" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>
				     </tr>
				     <tr >
				     <td  class="inquire_item6">出库类型：</td>
				     <td  class="inquire_form6"><input id="out_type" class="input_width_no_color" type="text"  value=""/> &nbsp;</td> 
				     <td  class="inquire_item6">合计金额：</td>
				     <td  class="inquire_form6"><input id="total_money" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>  
				      <td  class="inquire_item6">开票员：</td>
				     <td  class="inquire_form6"><input id="drawer" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>  
				    </tr>
				     <tr >
				     <td  class="inquire_item6">保管员：</td>
				     <td  class="inquire_form6"><input id="storage" class="input_width_no_color" type="text"  value=""/> &nbsp;</td> 
				     <td  class="inquire_item6">提料人：</td>
				     <td  class="inquire_form6"><input id="pickupgoods" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>  
				    </tr>
				  </table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				   <table id="taskTable" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  >
			    	<tr>
			    		<td class="bt_info_odd">序号</td>
			    	    <td  class="bt_info_even">物资编码</td>
			            <td class="bt_info_odd">名称</td>
			            <td  class="bt_info_even">单位</td>
			            <td class="bt_info_odd">数量</td>
			            <td  class="bt_info_even">单价</td>
			            <td class="bt_info_odd">金额</td>
			            <td  class="bt_info_even">发放时间</td>
			            <td class="bt_info_odd">备注</td>
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
	var org_id = "<%=user.getOrgId() %>";
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
	function refreshData(){
		var sql ="select t.teammat_out_id,t.procure_no,t.outmat_date,t.total_money,decode(t.out_type,'1','正常出库','2','虚拟出库') out_type,sd.coding_name ,nvl(c.coding_name,(dev.dev_name||'-'||dev.license_num||'-'||dev.self_num||'-'||dev.dev_sign)) as tname,t.note from gms_mat_teammat_out t  inner join GMS_MAT_TEAMMAT_OUT_DETAIL d on t.teammat_out_id=d.teammat_out_id and t.bsflag='0' and d.bsflag='0' left join comm_coding_sort_detail c on t.team_id = c.coding_code_id and c.bsflag='0' left join gms_device_account_dui dev on t.dev_acc_id = dev.dev_acc_id left join comm_coding_sort_detail sd on t.use_type=sd.coding_code_id and sd.bsflag='0' where t.bsflag='0' and t.project_info_no='<%=projectInfoNo%>'and t.out_type <3 and sd.coding_name !='大港专业化中心' ";
		if(org_id!=null&&(org_id=="C6000000000039"||org_id=="C6000000000040"||org_id=="C6000000005275"||org_id=="C6000000005277"||org_id=="C6000000005278"||org_id=="C6000000005279"||org_id=="C6000000005280")){
			
			sql += " and t.org_id='"+org_id+"' and t.wz_type='11'";
		}else{
			sql += " and t.wz_type='22'";
		}
		sql += " group by t.procure_no,t.out_type,t.outmat_date,t.teammat_out_id,t.note,t.total_money,t.create_date,c.coding_name,dev.dev_name,dev.self_num,dev.dev_sign, dev.license_num，sd.coding_name  order by t.create_date desc";
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/warehouse/accept/purchase/purItemList.jsp";
		queryData(1);
		
	}

       function simpleSearch(){
    	   var sql ='';
			var wz_name = document.getElementById("s_wz_name").value;
			sql+="select t.teammat_out_id,t.procure_no,t.outmat_date,t.total_money,decode(t.out_type,'1','正常出库','2','虚拟出库') out_type,sd.coding_name ,nvl(c.coding_name,(dev.dev_name||'-'||dev.license_num||'-'||dev.self_num||'-'||dev.dev_sign)) as tname,t.note from gms_mat_teammat_out t  inner join GMS_MAT_TEAMMAT_OUT_DETAIL d on t.teammat_out_id=d.teammat_out_id and t.bsflag='0' and d.bsflag='0' left join comm_coding_sort_detail c on t.team_id = c.coding_code_id and c.bsflag='0' left join gms_device_account_dui dev on t.dev_acc_id = dev.dev_acc_id left join comm_coding_sort_detail sd on t.use_type=sd.coding_code_id and sd.bsflag='0' where t.bsflag='0' and t.project_info_no='<%=projectInfoNo%>'and t.out_type <3 and t.procure_no like '%"+wz_name+"%' "; 
			if(org_id!=null&&(org_id=="C6000000000039"||org_id=="C6000000000040"||org_id=="C6000000005275"||org_id=="C6000000005277"||org_id=="C6000000005278"||org_id=="C6000000005279"||org_id=="C6000000005280")){
				sql += " and t.wz_type='11' and t.org_id = '"+org_id+"'";
			}else{
				sql += " and t.wz_type='22'";
			}
			sql += " group by t.procure_no,t.out_type,t.outmat_date,t.teammat_out_id,t.note,t.total_money,t.create_date,c.coding_name,dev.dev_name,dev.self_num,dev.dev_sign, dev.license_num，sd.coding_name order by t.create_date desc"
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = sql;
			cruConfig.currentPageUrl = "/mat/singleproject/matLedger/matItemList.jsp";
			queryData(1);
			
	}
       function clearQueryText(){
   		document.getElementById("s_wz_name").value = "";
   	} 
       
	function loadDataDetail(shuaId){
	
		var retObj;
		if(shuaId!= undefined){
			 retObj = jcdpCallService("MatItemSrv", "getGrantList", "laborId="+shuaId);
			
		}else{
			var ids = document.getElementById('rdo_entity_id').value;
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		     retObj = jcdpCallService("MatItemSrv", "getGrantList", "laborId="+ids);
		}
		document.getElementById("teammat_out_id").value = retObj.matInfo.procure_no;
		document.getElementById("create_date").value = retObj.matInfo.outmat_date;
		document.getElementById("team_dev").value = retObj.matInfo.tname;
		document.getElementById("total_money").value = retObj.matInfo.total_money;
		document.getElementById("out_type").value = retObj.matInfo.out_type;
		document.getElementById("drawer").value = retObj.matInfo.drawer;
		document.getElementById("storage").value = retObj.matInfo.storage;
		document.getElementById("pickupgoods").value = retObj.matInfo.pickupgoods;
		taskShow(shuaId);   
		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+shuaId;
		document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+shuaId;
		document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=6&relationId="+shuaId;
	}
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	  function toAdd(){ 
		 
			  popWindow("<%=contextPath%>/mat/singleproject/warehouseDg/out/grant/grantOutOther.jsp",'1024:800');
			
	 }  

       function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }  
     //验收明细信息
  	 function taskShow(value){
  			for(var j =1;j <document.getElementById("taskTable")!=null && j < document.getElementById("taskTable").rows.length ;){
  				document.getElementById("taskTable").deleteRow(j);
  			}
  			var retObj = jcdpCallService("MatItemSrv", "findGrantList", "ids="+value);
  			var taskList = retObj.matInfo;
  			for(var i =0; taskList!=null && i < taskList.length; i++){
  				var wz_id = taskList[i].wz_id;
  				var wz_name = taskList[i].wz_name;
  				var wz_prickie = taskList[i].wz_prickie;
  				var mat_num = taskList[i].mat_num;
  				var actual_price = taskList[i].actual_price;
  				var total_money = taskList[i].total_money;
  				var create_date = taskList[i].outmat_date;
  				var note = taskList[i].note;
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
  		        td.innerHTML = wz_id;
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
				
		        td.innerHTML = mat_num;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		        td = newTR.insertCell(5);
  		        td.innerHTML = actual_price;
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
		        td.innerHTML = create_date;
		        //debugger;
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
      function toEdit(){
    	  ids = getSelIds('rdo_entity_id');
    	  var value = ids.split(",");
    	  if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		  if(value.length>1){
			  	alert("请选中一条记录!");
	     		return;
			  }
    	 var retState = jcdpCallService("MatItemSrv", "getState", "teammat_out_id="+ids);
    	  if(retState.map.status==1){
    		  popWindow("<%=contextPath%>/mat/singleproject/warehouseDg/out/grant/grantOutEdite.srq?laborId="+ids,'1024:800');
        	  }
    	  else if(retState.map.status==2){
    		  popWindow("<%=contextPath%>/mat/singleproject/warehouseDg/out/grant/grantOtherEdite.srq?teammat_out_id="+ids,'1024:800');
        	  }
    	  else{
				alert("系统错误，数据不存在！");
        	  }
    	  //popWindow("<%=contextPath%>/mat/singleproject/warehouse/out/grant/grantOutEdite.srq?laborId="+ids,'1024:800');
          }
      function outExcelData(){
     	 ids = getSelIds('rdo_entity_id');
 		    if(ids==''){ alert("请先选中一条记录!");
 		     	return;
 		    }	
 		    else{
 		    	window.location = '<%=contextPath%>/mat/singleproject/warehouse/out/grant/excelGrantList.srq?id='+ids;
 		    }
     	
         } 
      function inExcelData(){
    	  popWindow("<%=contextPath%>/mat/singleproject/warehouse/out/grant/grantOutExcel.jsp",'1024:800');
          }
</script>

</html>

