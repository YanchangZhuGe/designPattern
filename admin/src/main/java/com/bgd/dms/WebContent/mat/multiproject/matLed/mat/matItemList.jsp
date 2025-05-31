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
String userId = user.getSubOrgIDofAffordOrg();
	//  userId = "C105001";
ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String codeId = "";
	codeId = request.getParameter("codeId");
	
 
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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open2.js"></script>
<title>无标题文档</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">物资名称</td>
		 	    <td class="ali_cdn_input"><input class="input_width" id="s_wz_name" name="s_wz_name" type="text" /></td>
				   <auth:ListButton functionId="" css="cx" event="onclick='simpleSearch()'" title="JCDP_btn_query"></auth:ListButton>
			    	<auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
			    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
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
			      <td class="bt_info_odd" exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{recyclemat_info}' onclick='loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{wz_name}">物资名称</td>
			      <td class="bt_info_odd" exp="{wz_prickie}">计量单位</td>
			      <td class="bt_info_even" exp="{wz_price}">参考单价</td>
			      <td class="bt_info_odd" exp="{stock_num}">库存数量</td>
			      <td class="bt_info_even" exp="{code_name}">分类</td>
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">常用</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">入库情况</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">发放详情</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">备注</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">附件</a></li>
			    <li id="tag3_5"><a href="#" onclick="getTab3(5)">分类码</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table  border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="background:#efefef"> 
				    <tr>
				      <td   class="inquire_item6">物资名称：</td>
				      <td   class="inquire_form6" ><input id="wz_name" class="input_width_no_color" type="text" value=""/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;计量单位：</td>
				      <td  class="inquire_form6"  ><input id="wz_prickie" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;描述：</td>
				      <td  class="inquire_form6"  ><input id="mat_desc" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>
				     </tr>
				     <tr >
				     <td  class="inquire_item6">物资分类：</td>
				     <td  class="inquire_form6"><input id="code_name" class="input_width_no_color" type="text"  value=""/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;参考单价：</td>
				     <td  class="inquire_form6"><input id="wz_price" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>  
				      <td  class="inquire_item6">&nbsp;备注：</td>
				     <td  class="inquire_form6"><input id="note" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>  
				    </tr>
				     <tr >
				     <td  class="inquire_item6">库存数量：</td>
				     <td  class="inquire_form6"><input id="stock_num" class="input_width_no_color" type="text"  value=""/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;实际单价：</td>
				     <td  class="inquire_form6"><input id="actual_price" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>  
				    </tr>
				  </table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				   <table id="taskTable" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  >
			    	<tr>
			    	    <td  class="bt_info_odd">序号</td>
			            <td  class="bt_info_even">队伍</td>
			            <td class="bt_info_odd">实际单价</td>
			            <td  class="bt_info_even">数量</td>
			            <td class="bt_info_odd">金额</td>
			            <td  class="bt_info_even">入库时间</td>
			        </tr>
			        </table>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				   <table id="taskTable1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  >
			    	<tr>
			    	    <td  class="bt_info_odd">序号</td>
			            <td  class="bt_info_even">使用项目</td>
			            <td class="bt_info_odd">队伍</td>
			            <td  class="bt_info_even">实际单价</td>
			            <td class="bt_info_odd">消耗数量</td>
			            <td  class="bt_info_even">金额</td>
			            <td class="bt_info_odd">发放时间</td>
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
	var rootId = "8ad889f13759d014013759d3de520003";
	cruConfig.contextPath =  "<%=contextPath%>";
	var userId = '<%=userId%>';
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
	var codeId = getQueryString("codeId");
	function refreshData(){
		var sql='';
		if(codeId==null||codeId=='C105'){
		 	sql +="select i.*,c.code_name,t.stock_num,t.recyclemat_info from gms_mat_recyclemat_info t inner join (gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id=c.coding_code_id and i.bsflag='0' and c.bsflag='0') on t.wz_id=i.wz_id and t.bsflag='0'and t.wz_type='1'";
			}
		else{
		 	sql +="select i.*,c.code_name,t.stock_num,t.recyclemat_info from gms_mat_recyclemat_info t inner join (gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id=c.coding_code_id and i.bsflag='0' and c.bsflag='0'and i.coding_code_id like '%"+codeId+"%') on t.wz_id=i.wz_id and t.bsflag='0'and t.wz_type='1'";
		}
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/multiproject/matLed/mat/matItemList.jsp";
		queryData(1);
	}

	function loadDataDetail(shuaId){
		var retObj;
		if(shuaId!= undefined){
			 retObj = jcdpCallService("MatItemSrv", "getMat", "laborId="+shuaId);
			
		}else{
			var ids = document.getElementById('rdo_entity_id').value;
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		     retObj = jcdpCallService("MatItemSrv", "getMat", "laborId="+ids);
		}
		document.getElementById("wz_name").value = retObj.matInfo.wzName;
		document.getElementById("wz_prickie").value = retObj.matInfo.wzPrickie;
		document.getElementById("mat_desc").value = retObj.matInfo.matDesc;
		document.getElementById("code_name").value = retObj.matInfo.codeName;
		document.getElementById("wz_price").value = retObj.matInfo.wzPrice;
		document.getElementById("note").value = retObj.matInfo.note;
		document.getElementById("stock_num").value = retObj.matInfo.stockNum;
		document.getElementById("actual_price").value = retObj.matInfo.actualPrice;
		taskShow(shuaId);  
		taskOutShow(shuaId); 
		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+shuaId;
		document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+shuaId;
		document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=6&relationId="+shuaId;
	}
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

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
			 if(userId == 'C105'){
					sql += "select g.*, c.code_name from gms_mat_infomation g inner join GMS_MAT_CODING_CODE c on g.coding_code_id = c.coding_code_id and g.bsflag='0' and c.bsflag='0' and g.wz_name='%"+wz_name+"%'";
				  }else{
					sql +="select c.code_name, g.wz_id ,g.coding_code_id,g.wz_name,g.wz_prickie,g.wz_code,g.wz_price from gms_mat_infomation_wtc  w inner join gms_mat_infomation g on g.wz_id = w.wz_id inner join GMS_MAT_CODING_CODE c on g.coding_code_id = c.coding_code_id and g.bsflag='0'and c.bsflag='0' and w.bsflag ='0' and g.wz_name like'%"+wz_name+"%'";
					  }
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = sql;
			cruConfig.currentPageUrl = "/mat/multiproject/matLedger/matItemList.jsp";
			queryData(1);
			
	}
   	
       function clearQueryText(){
   		document.getElementById("s_wz_name").value = "";
   	} 
       //入库明细信息
    	 function taskShow(value){
    			for(var j =1;j <document.getElementById("taskTable")!=null && j < document.getElementById("taskTable").rows.length ;){
    				document.getElementById("taskTable").deleteRow(j);
    			}
    			var retObj = jcdpCallService("MatItemSrv", "findMatIn", "ids="+value);
    			var taskList = retObj.matInfo;
    			for(var i =0; taskList!=null && i < taskList.length; i++){
    				var org_id = taskList[i].org_id;
    				var org_abbreviation=taskList[i].org_abbreviation;
    				var out_price = taskList[i].out_price;
    				var out_num = taskList[i].out_num;
    				var total_money = taskList[i].total_money;
    				var out_date = taskList[i].out_date;
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
    		        td.innerHTML = org_abbreviation;
    		        //debugger;
    		        td.className =tdClass+'_even'
    		        if(autoOrder%2==0){
    					td.style.background = "#FFFFFF";
    				}else{
    					td.style.background = "#ebebeb";
    				}
    		        
    		        td = newTR.insertCell(2);
    				
    		        td.innerHTML = out_price;
    		        td.className = tdClass+'_odd';
    		        if(autoOrder%2==0){
    					td.style.background = "#f6f6f6";
    				}else{
    					td.style.background = "#e3e3e3";
    				}
	    		    td = newTR.insertCell(3);
	  		        td.innerHTML = out_num;
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
    		        td.innerHTML = out_date;
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
    	 //出库明细信息
    	 function taskOutShow(value){
    			for(var j =1;j <document.getElementById("taskTable1")!=null && j < document.getElementById("taskTable1").rows.length ;){
    				document.getElementById("taskTable1").deleteRow(j);
    			}
    			var retObj = jcdpCallService("MatItemSrv", "findMatOut", "ids="+value);
    			var taskList = retObj.matInfo;
    			for(var i =0; taskList!=null && i < taskList.length; i++){
    				var org_id = taskList[i].org_id;
    				var project_info_no = taskList[i].project_info_no;
    				var project_name = taskList[i].project_name;
    				var org_abbreviation = taskList[i].org_abbreviation;
    				var actual_price = taskList[i].actual_price;
    				var mat_num = taskList[i].mat_num;
    				var total_money = taskList[i].total_money;
    				var create_date = taskList[i].create_date;
    				var autoOrder = document.getElementById("taskTable1").rows.length;
    				var newTR = document.getElementById("taskTable1").insertRow(autoOrder);
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
    		        td.innerHTML = project_name;
    		        //debugger;
    		        td.className =tdClass+'_even'
    		        if(autoOrder%2==0){
    					td.style.background = "#FFFFFF";
    				}else{
    					td.style.background = "#ebebeb";
    				}
    		        
    		        td = newTR.insertCell(2);
    				
    		        td.innerHTML = org_abbreviation;
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
  				
  		        td.innerHTML = mat_num;
  		        td.className = tdClass+'_odd';
  		        if(autoOrder%2==0){
  					td.style.background = "#f6f6f6";
  				}else{
  					td.style.background = "#e3e3e3";
  				}
  		        td = newTR.insertCell(5);
    		        td.innerHTML = total_money;
    		        //debugger;
    		        td.className =tdClass+'_even'
    		        if(autoOrder%2==0){
    					td.style.background = "#FFFFFF";
    				}else{
    					td.style.background = "#ebebeb";
    				}
    		    td = newTR.insertCell(6);
      				
      		    td.innerHTML = create_date;
      		    td.className = tdClass+'_odd';
      		    if(autoOrder%2==0){
      				td.style.background = "#f6f6f6";
      			}else{
      				td.style.background = "#e3e3e3";
      			}
      				
    		       newTR.onclick = function(){
    		        	// 取消之前高亮的行
    		       		for(var i=1;i<document.getElementById("taskTable1").rows.length;i++){
    		    			var oldTr = document.getElementById("taskTable1").rows[i];
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
</script>

</html>

