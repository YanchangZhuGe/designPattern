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
	String orgSubId = user.getOrgSubjectionId();
	
	
	
 
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
			  	<td class="ali_cdn_name" style="width: 60px;">物资名称</td>
		 	    <td class="ali_cdn_input" style="width: 120px;"><input class="input_width" id="s_wz_name" name="s_wz_name" type="text"/></td>
		 	    <td class="ali_cdn_name" style="width: 60px;">物资编码</td>
		 	    <td class="ali_cdn_input" style="width: 120px;"><input class="input_width" id="s_wz_id" name="s_wz_id" type="text"/></td>
				<auth:ListButton functionId="" css="cx" event="onclick='simpleSearch()'" title="JCDP_btn_query"></auth:ListButton>
			    <auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
			    <td align="right">
			    <a  href="<%=contextPath%>/mat/singleproject/mattemplate/download.jsp?path=/mat/multiproject/matLed/repmat/repMat.xlsx&filename=repMat.xlsx">下载模板</a>
			    </td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
				<auth:ListButton functionId="" css="dr" event="onclick='AddExcelData()'" title="导入excel"></auth:ListButton>
				<auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{wz_id}' onclick='loadDataDetail();chooseOne(this)'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			       <td class="bt_info_even" exp="{coding_code_id}">物资分类码</td>
			      <td class="bt_info_odd" exp="{wz_id}">物资编码</td>
			      <td class="bt_info_even" exp="{wz_name}">物资名称</td>
			      <td class="bt_info_odd" exp="{wz_prickie}">计量单位</td>
			      <td class="bt_info_even" exp="{wz_price}">参考单价</td>
			      <td class="bt_info_odd" exp="{actual_price}">实际单价(元)</td>
			      <td class="bt_info_even" exp="{stock_num}">库存数量</td>
			      <td class="bt_info_odd" exp="{code_name}">分类</td>
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
<!-- 			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">备注</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">附件</a></li>
			    <li id="tag3_5"><a href="#" onclick="getTab3(5)">分类码</a></li>
 -->			    
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
				     <td  class="inquire_item6">可用数量：</td>
				     <td  class="inquire_form6"><input id="total_num" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>  
				    </tr>
				    <tr >
				     <td  class="inquire_item6">报废数量：</td>
				     <td  class="inquire_form6"><input id="broken_num" class="input_width_no_color" type="text"  value=""/> &nbsp;</td> 
				    </tr>
				  </table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<form name="form1" id="form1" method="post" action="">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30"><span class="bc"><a href="#" onclick="toUpdate()" title="保存"></a></span></td>
		                  <td width="5"></td>
		                </tr>
	             	 </table>
				   <table id="taskTable" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  >
			    	<tr>
			    		<td class="bt_info_even">选择</td>
			    	    <td class="bt_info_odd">序号</td>
			            <td class="bt_info_even">队伍</td>
			            <td class="bt_info_odd">实际单价</td>
			            <td class="bt_info_even">数量</td>
			            <td class="bt_info_odd">金额</td>
			            <td class="bt_info_even">入库时间</td>
			        </tr>
			        </table>
			        </form>
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
<!-- 				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
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
 -->				
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
	var orgSubjectionId = "<%=user.getOrgSubjectionId() %>";
	var orgId = "<%=user.getOrgId() %>";
	
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
	var codeId = getQueryString("codeId");
	function refreshData(){
		var sql='';
		debugger;
		//根据用户组织机构ID，查询是否机关人员，如是权限放大
		retObj = jcdpCallService("HseSrv", "queryOrg", "");
		if(retObj.flag!="false"){
			var len = retObj.list.length;
			if(len>1){
				if(retObj.list[1].organFlag=="0"){
					orgSubjectionId = retObj.list[0].orgSubId;
					orgId = retObj.list[0].orgId;
				}
			}
		}
		
		if(codeId==null||codeId=='C105'){
		 	sql +="select i.*, c.code_name, tt.stock_num,tt.actual_price from (select   t.wz_id,sum(t.stock_num) stock_num,round(sum(t.stock_num * t.actual_price)/case when sum(t.stock_num)=0 then 1 else sum(t.stock_num) end,3) actual_price from gms_mat_recyclemat_info t where t.bsflag = '0' and t.wz_type = '2' and t.org_subjection_id like '"+orgSubjectionId+"%'  group by t.wz_id) tt inner join (gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id=c.coding_code_id and i.bsflag='0' and c.bsflag='0') on tt.wz_id=i.wz_id order by i.coding_code_id asc ,i.wz_id asc";
			}
		else{
		 	sql +="select i.*, c.code_name, tt.stock_num,tt.actual_price from (select   t.wz_id,sum(t.stock_num) stock_num,round(sum(t.stock_num * t.actual_price)/case when sum(t.stock_num)=0 then 1 else sum(t.stock_num) end,3) actual_price from gms_mat_recyclemat_info t where t.bsflag = '0' and t.wz_type = '2' and t.org_subjection_id like '"+orgSubjectionId+"%'  group by t.wz_id) tt inner join (gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id=c.coding_code_id and i.bsflag='0' and c.bsflag='0' and i.coding_code_id like '%"+codeId+"%') on tt.wz_id=i.wz_id  order by i.wz_id asc";
		}
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/multiproject/matLed/mat/matItemList.jsp";
		queryData(1);
	}

	function loadDataDetail(shuaId){
		var retObj;
		if(shuaId!= undefined){
			 retObj = jcdpCallService("MatItemSrv", "getMatRep", "laborId="+shuaId+"&orgSubjectionId="+orgSubjectionId);
			
		}else{
			var ids = document.getElementById('rdo_entity_id').value;
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		     retObj = jcdpCallService("MatItemSrv", "getMatRep", "laborId="+ids+"&orgSubjectionId="+orgSubjectionId);
		}
		document.getElementById("wz_name").value = retObj.matInfo.wzName;
		document.getElementById("wz_prickie").value = retObj.matInfo.wzPrickie;
		document.getElementById("mat_desc").value = retObj.matInfo.matDesc;
		document.getElementById("code_name").value = retObj.matInfo.codeName;
		document.getElementById("wz_price").value = retObj.matInfo.wzPrice;
		document.getElementById("note").value = retObj.matInfo.note;
		document.getElementById("stock_num").value = retObj.matInfo.stockNum;
		document.getElementById("actual_price").value = retObj.matInfo.actualPrice;
		document.getElementById("total_num").value = retObj.matInfo.totalNum;
		document.getElementById("broken_num").value = retObj.matInfo.brokenNum;
		taskShow(shuaId);  
		taskOutShow(shuaId); 
//		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+shuaId;
//		document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+shuaId;
//		document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=6&relationId="+shuaId;
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
    	   var sql ="select i.*,c.code_name,t.stock_num,t.recyclemat_info,t.actual_price from gms_mat_recyclemat_info t inner join (gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id=c.coding_code_id and i.bsflag='0' and c.bsflag='0') on t.wz_id=i.wz_id  where t.bsflag='0'and t.wz_type='2' ";
    	   var wz_name = document.getElementById("s_wz_name").value;
			var wz_id = document.getElementById("s_wz_id").value;
			if(wz_name !='' && wz_name != null || wz_id !='' && wz_id != null){
				if(wz_name !=''){
					sql += "  and i.wz_name like'%"+wz_name+"%'";
				}
				if(wz_id !='' && wz_id != null){
					sql += " and t.wz_id like'%"+wz_id+"%'";
					}
			}
			else{
				alert('请输入查询内容！');
				}  
			sql +=" order by i.coding_code_id asc ,i.wz_id asc";
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
    			var retObj = jcdpCallService("MatItemSrv", "findMatInRep", "ids="+value+"&orgSubjectionId="+orgSubjectionId);
    			var taskList = retObj.matInfo;
    			for(var i =0; taskList!=null && i < taskList.length; i++){
    				var org_id = taskList[i].org_abbreviation;
    				var out_price = taskList[i].out_price;
    				var out_num = taskList[i].out_num;
    				var total_money = taskList[i].total_money;
    				var create_date = taskList[i].out_date;
    				var out_info_detail_id = taskList[i].out_info_detail_id
    				var autoOrder = document.getElementById("taskTable").rows.length;
    				var newTR = document.getElementById("taskTable").insertRow(autoOrder);
    				var tdClass = 'even';
    				if(autoOrder%2==0){
    					tdClass = 'odd';
    				}
    				
    				var td = newTR.insertCell(0);
    		      	td.innerHTML = "<input name = 'wz_ids' id='wz_ids' type='checkbox' value='"+out_info_detail_id+"'/>";
    		        td.className = tdClass+'_odd';
    		        if(autoOrder%2==0){
    					td.style.background = "#FFFFFF";
    				}else{
    					td.style.background = "#ebebeb";
    				}
    				
    		        var td = newTR.insertCell(1);
    		      	td.innerHTML = autoOrder;
    		        td.className = tdClass+'_odd';
    		        if(autoOrder%2==0){
    					td.style.background = "#f6f6f6";
    				}else{
    					td.style.background = "#e3e3e3";
    				}

    		        td = newTR.insertCell(2);
    		        td.innerHTML = org_id;
    		        //debugger;
    		        td.className =tdClass+'_even'
    		        if(autoOrder%2==0){
    					td.style.background = "#FFFFFF";
    				}else{
    					td.style.background = "#ebebeb";
    				}
    		        
    		        td = newTR.insertCell(3);
    				
    		        td.innerHTML = "<input type='text' id='out_price_"+out_info_detail_id+"' name='out_price_"+out_info_detail_id+"' value='"+out_price+"' onchange='changeTotal(\""+out_info_detail_id+"\")'/> ";
    		        td.className = tdClass+'_odd';
    		        if(autoOrder%2==0){
    					td.style.background = "#f6f6f6";
    				}else{
    					td.style.background = "#e3e3e3";
    				}
	    		    td = newTR.insertCell(4);
	  		        td.innerHTML = "<input type='text' id='out_num_"+out_info_detail_id+"' name='out_num_"+out_info_detail_id+"' value='"+out_num+"' onchange='changeTotal(\""+out_info_detail_id+"\")' /> ";
	  		        //debugger;
	  		        td.className =tdClass+'_even'
	  		        if(autoOrder%2==0){
	  					td.style.background = "#FFFFFF";
	  				}else{
	  					td.style.background = "#ebebeb";
	  				}
	  		        
	  		        td = newTR.insertCell(5);
	  				
	  		        td.innerHTML = "<input type='text' id='total_money_"+out_info_detail_id+"' name='total_money_"+out_info_detail_id+"' value='"+total_money+"' readonly/> ";
	  		        td.className = tdClass+'_odd';
	  		        if(autoOrder%2==0){
	  					td.style.background = "#f6f6f6";
	  				}else{
	  					td.style.background = "#e3e3e3";
	  				}
	  		        td = newTR.insertCell(6);
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
    	 //出库明细信息
    	 function taskOutShow(value){
    			for(var j =1;j <document.getElementById("taskTable1")!=null && j < document.getElementById("taskTable1").rows.length ;){
    				document.getElementById("taskTable1").deleteRow(j);
    			}
    			var retObj = jcdpCallService("MatItemSrv", "findMatOutRep", "ids="+value+"&orgSubjectionId="+orgSubjectionId);
    			var taskList = retObj.matInfo;
    			for(var i =0; taskList!=null && i < taskList.length; i++){
    				var org_id = taskList[i].org_abbreviation;
    				var project_info_no = taskList[i].project_name;
    				var actual_price = taskList[i].actual_price;
    				var mat_num = taskList[i].mat_num;
    				var total_mpney = taskList[i].total_money;
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
    		        td.innerHTML = project_info_no;
    		        //debugger;
    		        td.className =tdClass+'_even'
    		        if(autoOrder%2==0){
    					td.style.background = "#FFFFFF";
    				}else{
    					td.style.background = "#ebebeb";
    				}
    		        
    		        td = newTR.insertCell(2);
    				
    		        td.innerHTML = org_id;
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
    		        td.innerHTML = total_mpney;
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
 	function toAdd(){
 	 	popWindow("<%=contextPath%>/mat/multiproject/matLed/repmat/repMatLedgerEdit.jsp?orgSubjectionId="+orgSubjectionId+"&orgId="+orgId,'1024:800');
 	 	}
	function toEdit(){
		ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	 	 else{
		 	 popWindow('<%=contextPath%>/mat/multiproject/matLed/repmat/repMatLedgerUpdate.jsp?laborId='+ids+'&orgSubjectionId='+orgSubjectionId,'1024:800');
		}
	    }
	function toDelete(){
		 ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
		    else{
		 	   if(confirm('确定要删除吗?')){  
			   var retObj = jcdpCallService("MatItemSrv", "deleteRepMat", "matId="+ids+"&orgSubjectionId="+orgSubjectionId);
			 	queryData(cruConfig.currentPage);
		       }
		    }
		}
	function AddExcelData(){
		 popWindow("<%=contextPath%>/mat/multiproject/matLed/repmat/excelRepMatAdd.jsp");
		}
	
	function toUpdate(){
		var ids = getSelIds('wz_ids');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }else{
	    	var form = document.getElementById("form1");
			form.action="<%=contextPath%>/mat/multiproject/matLed/repmat/repMatLedgerUpdateDetail.srq?ids="+ids;
			form.submit();	
	    }	
	}
	
	function changeTotal(out_info_detail_id){
		debugger;
		var out_price = document.getElementById("out_price_"+out_info_detail_id).value;
		var out_num = document.getElementById("out_num_"+out_info_detail_id).value;
		document.getElementById("total_money_"+out_info_detail_id).value = Number(out_price)*Number(out_num);
	}
</script>

</html>

