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
	String projectInfoNo = user.getProjectInfoNo();
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
			    <td class="ali_cdn_name">物资名称：</td>
		 	    <td class="ali_cdn_input"><input class="input_width" id="s_wz_name" name="s_wz_name" type="text" /></td>
		 	    <td class="ali_cdn_name">物资编码：</td>
		 	    <td class="ali_cdn_input"><input class="input_width" id="s_wz_id" name="s_wz_id" type="text" /></td>
				<auth:ListButton functionId="" css="cx" event="onclick='simpleSearch()'" title="JCDP_btn_query"></auth:ListButton>
			    <auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
			    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>

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
			      <td class="bt_info_odd" exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{wz_id}' onclick='loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{coding_code_id}">物资分类码</td>
			      <td class="bt_info_odd" exp="{wz_id}">物资编码</td>
			      <td class="bt_info_even" exp="{wz_name}">物资名称</td>
			      <td class="bt_info_odd" exp="{wz_prickie}">计量单位</td>
			      <td class="bt_info_even" exp="{wz_price}">单价</td>
			      <td class="bt_info_odd" exp="{stock_num}">库存数量</td>
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">料签信息</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">入库明细</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">发放明细</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">退库信息</a></li>
			    <li id="tag3_5"><a href="#" onclick="getTab3(5)">备注</a></li>
			    <li id="tag3_6"><a href="#" onclick="getTab3(6)">附件</a></li>
			    <li id="tag3_7"><a href="#" onclick="getTab3(7)">分类码</a></li>
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
				      <td  class="inquire_item6">&nbsp;物资描述：</td>
				      <td  class="inquire_form6"  ><input id="describe" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>
				     </tr>
				     <tr >
				     <td  class="inquire_item6">物资分类：</td>
				     <td  class="inquire_form6"><input id="coding_code_id" class="input_width_no_color" type="text"  value=""/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;参考单价：</td>
				     <td  class="inquire_form6"><input id="wz_price" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>  
				      <td  class="inquire_item6">&nbsp;库存数量：</td>
				     <td  class="inquire_form6"><input id="stock_num" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>  
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
				   <table id="projectMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  >
			    	<tr>
			    		<td class="bt_info_odd">序号</td>
			    	    <td  class="bt_info_even">组织发送单号</td>
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
				   <table id="projectMapxh" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  >
			    	<tr>
			    		<td class="bt_info_odd">序号</td>
			    		<td  class="bt_info_even">班组/单机</td>
			            <td  class="bt_info_odd">物资分类码</td>
			    	  	<td  class="bt_info_even">物资编码</td>
			            <td  class="bt_info_odd">物资名称</td>
			            <td class="bt_info_even">数量</td>
			            <td  class="bt_info_odd">单价</td>
			            <td class="bt_info_even">金额</td>
			            <td  class="bt_info_odd">货位</td>
			        </tr>
			        </table>
				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
				   <table id="projectMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  >
			    	<tr>
			    	   	<td class="bt_info_odd">序号</td>
			    	  	<td  class="bt_info_even">物资编码</td>
			            <td  class="bt_info_odd">物资名称</td>
			            <td class="bt_info_even">计量单位</td>
			            <td  class="bt_info_odd">调拨数量</td>
			            <td class="bt_info_even">调拨单价</td>
			            <td  class="bt_info_odd">金额</td>
			            <td class="bt_info_even">货位</td>
			            <td  class="bt_info_odd">维修工单号</td>
			        </tr>
			        </table>
				</div>
				<div id="tab_box_content5" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content6" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content7" class="tab_box_content" style="display:none;">
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
		var sql ='';
		if(codeId !=null && codeId != rootId){
			//sql +="select g.wz_id ,g.coding_code_id,g.wz_name,g.wz_prickie,g.wz_code,g.wz_price,g.note,w.stock_num from gms_mat_infomation g inner join gms_mat_teammat_info w on g.wz_id = w.wz_id and w.bsflag ='0' and g.coding_code_id like'"+codeId+"%'and w.project_info_no='<%=projectInfoNo%>'and w.is_recyclemat='0' order by g.coding_code_id asc,g.wz_id asc";
			sql +="select aa.wz_id,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,i.wz_price from ( ";
			sql +="select tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='<%=projectInfoNo%>'and mti.invoices_type='2'and mti.if_input='0' group by tid.wz_id ";
			sql +=")aa left join ( ";
			sql +="select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='1' and mto.project_info_no='<%=projectInfoNo%>' group by tod.wz_id ";
			sql +=") bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0' and coding_code_id like'"+codeId+"%'";
			}
		else{
			//sql +="select g.wz_id ,g.coding_code_id,g.wz_name,g.wz_prickie,g.wz_code,g.wz_price,g.note,w.stock_num from gms_mat_infomation g inner join gms_mat_teammat_info w on g.wz_id = w.wz_id and w.bsflag ='0'and w.project_info_no='<%=projectInfoNo%>'and w.is_recyclemat='0' order by g.coding_code_id asc,g.wz_id asc";
			sql +="select aa.wz_id,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,i.wz_price from ( ";
			sql +="select tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='<%=projectInfoNo%>' and mti.invoices_type='2'and mti.if_input='0' group by tid.wz_id ";
			sql +=")aa left join ( ";
			sql +="select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='1' and mto.project_info_no='<%=projectInfoNo%>' group by tod.wz_id ";
			sql +=") bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0'";
			}
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/matLedger/matItemList.jsp";
		queryData(1);
	}

	function loadDataDetail(shuaId){
	
		var retObj;
		if(shuaId!= undefined){
//			 retObj = jcdpCallService("MatItemSrv", "getSingleMatLedger", "laborId="+shuaId);
			 retObj = jcdpCallService("MatItemSrv", "getSingleRepMatLedger", "laborId="+shuaId);
			 taskShow(shuaId);
		}else{
			var ids = document.getElementById('rdo_entity_id').value;
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		     retObj = jcdpCallService("MatItemSrv", "getSingleRepMatLedger", "laborId="+ids);
		     taskShow(ids);
		}
		document.getElementById("wz_name").value = retObj.matInfo.wzName;
		document.getElementById("wz_prickie").value = retObj.matInfo.wzPrickie;
		document.getElementById("describe").value = retObj.matInfo.matDesc;
		document.getElementById("coding_code_id").value = retObj.matInfo.codingCodeId;
		document.getElementById("wz_price").value = retObj.matInfo.wzPrice;
		document.getElementById("stock_num").value = retObj.matInfo.stockNum;

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
		 
			  popWindow("<%=contextPath%>/mat/singleproject/matLedger/changeType.jsp");
			
	 }  

       function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }  
       function simpleSearch(){
    	   var sql ="select g.wz_id ,g.coding_code_id,g.wz_name,g.wz_prickie,g.wz_code,g.wz_price,g.note,w.stock_num from gms_mat_infomation g inner join gms_mat_teammat_info w on g.wz_id = w.wz_id and w.bsflag ='0'where w.project_info_no='<%=projectInfoNo%>'and w.is_recyclemat='0'";
			var wz_name = document.getElementById("s_wz_name").value;
			var wz_id = document.getElementById("s_wz_id").value;
			if(wz_name !='' && wz_name != null || wz_id !='' && wz_id != null){
				if(wz_name !=''){
					sql += " and g.wz_name like'%"+wz_name+"%'";
				}
				if(wz_id !='' && wz_id != null){
					sql += " and g.wz_id like'%"+wz_id+"%'";
					}
			}
			else{
				alert('请输入查询内容！');
				}  
			sql +=" order by g.coding_code_id asc,g.wz_id asc";
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = sql;
			cruConfig.currentPageUrl = "/mat/singleproject/matLedger/matItemList.jsp";
			queryData(1);
			
	}
       function clearQueryText(){
   		document.getElementById("s_wz_name").value = "";
   	} 
     //汇总信息
  	 function taskShow(value){
  			for(var j =1;j <document.getElementById("projectMapxh")!=null && j < document.getElementById("projectMapxh").rows.length ;){
  				document.getElementById("projectMapxh").deleteRow(j);
  			}
  			var retObj = jcdpCallService("MatItemSrv", "getTeamListXH", "wz_type=1&ids="+value);
  			var taskList = retObj.matInfo;
  			for(var i =0; taskList!=null && i < taskList.length; i++){
  				var tname = taskList[i].tname;
  				var wzName = taskList[i].wzName;
  				var wzId = taskList[i].wzId;
  				var codingCodeId = taskList[i].codingCodeId; 
  				var wzPrickie = taskList[i].wzPrickie;
  				var wzPrice = taskList[i].actualPrice;
  				var matNum = taskList[i].matNum;
  				var goodsAllocation = taskList[i].goodsAllocation;
  				var totalMoney = taskList[i].totalMoney;
  				var autoOrder = document.getElementById("projectMapxh").rows.length;
  				var newTR = document.getElementById("projectMapxh").insertRow(autoOrder);
  				var tdClass = 'even';
  				if(autoOrder%2==0){
  					tdClass = 'odd';
  				}
  		        var td = newTR.insertCell(0);
  	
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
  				
  		        td.innerHTML = tname;
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
  				
  		        td.innerHTML = wzId;
  		        td.className = tdClass+'_odd';
  		        if(autoOrder%2==0){
  					td.style.background = "#f6f6f6";
  				}else{
  					td.style.background = "#e3e3e3";
  				}
  		        td = newTR.insertCell(4);

  		        td.innerHTML = wzName;
  		        td.className =tdClass+'_even'
  		        if(autoOrder%2==0){
  					td.style.background = "#FFFFFF";
  				}else{
  					td.style.background = "#ebebeb";
  				}
  		      td = newTR.insertCell(5);

		        td.innerHTML = matNum;
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

		        td.innerHTML = totalMoney;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		      td = newTR.insertCell(8);

		        td.innerHTML = goodsAllocation;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}
  		        newTR.onclick = function(){
  		        	// 取消之前高亮的行
  		       		for(var i=1;i<document.getElementById("projectMapxh").rows.length;i++){
  		    			var oldTr = document.getElementById("projectMapxh").rows[i];
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

