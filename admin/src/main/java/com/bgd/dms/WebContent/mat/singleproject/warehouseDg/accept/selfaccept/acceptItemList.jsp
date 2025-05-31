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
	String name="转出";
	System.out.println(name.equals("物资供应")?"1":name.equals("转出")?"2":"3");
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
<title>地震队验收入库</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">物资单号：</td>
		 	     <td class="ali_cdn_input"><select  onchange="simpleSearch(this)"><option value="0">未入库</option><option value="1">已入库</option></select></td>
			    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>

			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_warehouse_entry"></auth:ListButton>
			   <!--  <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='toOutExcel()'" title="导出"></auth:ListButton> -->
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
			      <td class="bt_info_odd" exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{plan_flat_id},{invoices_id},{org_id},{wz_id},{plan_flat_type}' onclick='loadDataDetail();chooseOne(this);'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{wz_name}">物资名称</td>
			      <td class="bt_info_even" exp="{wz_type}">物资类型</td>
			      <td class="bt_info_odd" exp="{plan_num}">调配数量</td>
			      <td class="bt_info_even" exp="{plan_price}">实际单价</td>
			      <td class="bt_info_odd" exp="{user_name}">调配人</td>
			      <td class="bt_info_even" exp="{org_abbreviation}">调配单位</td>
			      <td class="bt_info_odd" exp="{plan_flat_type}">状态</td>
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">入库信息</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">料签信息</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">验收明细</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">备注</a></li>
			    <!-- <li id="tag3_5"><a href="#" onclick="getTab3(5)">附件</a></li>
			    <li id="tag3_6"><a href="#" onclick="getTab3(6)">分类码</a></li> -->
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content" >
					   <table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="background:#efefef" >
				    	 <tr>
				      <td  class="inquire_item6">物资编号：</td>
				      <td  class="inquire_form6" ><input id="wz_id" class="input_width_no_color" type="text" value="" /> &nbsp;</td>
				      <td  class="inquire_item6">物资名称：</td>
				      <td  class="inquire_form6"  ><input id="wz_name" class="input_width_no_color" type="text"  value="" /> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;物资分类码：</td>
				      <td  class="inquire_form6"  ><input id="wz_prickie" class="input_width_no_color" type="text"  value="" /> &nbsp;</td>
				     </tr>
				        </table>
					</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<table  border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="background:#efefef"> 
				    <tr>
				      <td  class="inquire_item6">料单编号：</td>
				      <td  class="inquire_form6" ><input id="procure_no" class="input_width_no_color" type="text" value="" /> &nbsp;</td>
				      <td  class="inquire_item6">接收单位：</td>
				      <td  class="inquire_form6"  ><input id="org_name" class="input_width_no_color" type="text"  value="" /> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;金额：</td>
				      <td  class="inquire_form6"  ><input id="total_money" class="input_width_no_color" type="text"  value="" /> &nbsp;</td>
				     </tr>
				     <tr >
				     <td  class="inquire_item6">验收日期：</td>
				     <td  class="inquire_form6"><input id="input_date" class="input_width_no_color" type="text"  value="" /> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;经办：</td>
				     <td  class="inquire_form6"><input id="operator" class="input_width_no_color" type="text"  value="" /> &nbsp;</td>  
				      <td  class="inquire_item6">&nbsp;提货：</td>
				     <td  class="inquire_form6"><input id="pickupgoods" class="input_width_no_color" type="text"  value="" /> &nbsp;</td>  
				    </tr>
				     <tr >
				     <td  class="inquire_item6">保管：</td>
				     <td  class="inquire_form6"><input id="storage" class="input_width_no_color" type="text"  value="" /> &nbsp;</td> 
				    <td  class="inquire_item6">备注：</td>
				     <td  class="inquire_form6"><input id="note" class="input_width_no_color" type="text"  value="" /> &nbsp;</td> 
				    </tr>
				  </table>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
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
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
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
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content5" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content6" class="tab_box_content" style="display:none;">
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
	var codeId = getQueryString("codeId");
	function refreshData(){
		var sql =" select i.wz_id, i.wz_name, comm.org_abbreviation, comm.org_id, u.user_name,  t.plan_num, t.plan_price, decode(t.plan_flat_type, '0', '未入库', '1', '已入库') plan_flat_type, t.plan_flat_id, invoices_id,decode(t.wz_type, '1', '在帐', '2', '可重复') wz_type  from gms_mat_demand_plan_flat t inner join p_auth_user u on t.creator_id = u.user_id inner join comm_org_information comm on t.plan_org = comm.org_id inner join gms_mat_infomation i on t.wz_id = i.wz_id where project_info_no = '<%=projectInfoNo%>' and plan_flat_type = '0' ";
		sql+=" union all select i.wz_id,i.wz_name,decode(t2.outbound_org_id, '', '大港分中心') org_abbreviation,decode(t2.outbound_org_id, '', 'C6000000005370') outbound_org_id,decode(t2.outbound_org_id, '', '大港分中心') user_name,t2.demand_num plan_num,i.wz_price plan_price, decode(t2.flat_type, '0', '未入库', '', '未入库', '3', '已入库') plan_flat_type, t2.plan_detail_id plan_flat_id, t2.outbound_number invoices_id,case when t4.plan_invoice_type is not null then '在帐' else '在帐' end wz_type from gms_mat_demand_plan_bz t inner join GMS_MAT_DEMAND_PLAN_DETAIL t2 on t.submite_number = t2.submite_number inner join common_busi_wf_middle t3 on t3.business_id = t.plan_invoice_id inner join gms_mat_demand_plan_invoice t4 on t.plan_invoice_id = t4.plan_invoice_id inner join gms_mat_infomation i on t2.wz_id = i.wz_id where t3.proc_status = '3' and t.bsflag = '0' and t4.plan_invoice_type = '物资供应' and project_info_no = '<%=projectInfoNo%>' and t2.flat_type !='3'";
		sql+=" union all select i.wz_id,i.wz_name,task.project_name org_abbreviation , task.project_info_no org_id,    t.operator user_name,info.out_num plan_num ,info.out_price plan_price,case when info.receive_org_id is not null then '未入库' else '已入库' end plan_flat_type ,info.out_info_detail_id plan_flat_id,info.goods_allocation invoices_id, case when info.goods_allocation is  null then '从其他项目转入'  end wz_type from gms_mat_out_info t  inner join common_busi_wf_middle mid on t.out_info_id=mid.business_id and mid.bsflag='0' and mid.proc_status ='3'  inner join gms_mat_out_info_detail info  on t.out_info_id=info.out_info_id inner join gms_mat_teammat_out ot on t.out_info_id = ot.plan_invoice_id and ot.bsflag='0'  inner join gms_mat_infomation i on i.wz_id=info .wz_id inner join gp_task_project task on t.project_info_no=task.project_info_no where t.out_type='4' and t.input_org='<%=projectInfoNo%>' and info.receive_org_id !='1'";
		if(org_id!=null&&(org_id=="C6000000000039"||org_id=="C6000000000040"||org_id=="C6000000005275"||org_id=="C6000000005277"||org_id=="C6000000005278"||org_id=="C6000000005279"||org_id=="C6000000005280")){
			sql = "select i.wz_id,i.wz_name,task.project_name org_abbreviation , task.project_info_no org_id,    t.operator user_name,info.out_num plan_num ,info.out_price plan_price,case when info.receive_org_id is not null then '未入库' else '已入库' end plan_flat_type ,info.out_info_detail_id plan_flat_id,info.goods_allocation invoices_id, case when info.goods_allocation is  null then '从其他项目转入'  end wz_type from gms_mat_out_info t  inner join common_busi_wf_middle mid on t.out_info_id=mid.business_id and mid.bsflag='0' and mid.proc_status ='3'  inner join gms_mat_out_info_detail info  on t.out_info_id=info.out_info_id inner join gms_mat_teammat_out ot on t.out_info_id = ot.plan_invoice_id and ot.bsflag='0'  inner join gms_mat_infomation i on i.wz_id=info .wz_id inner join gp_task_project task on t.project_info_no=task.project_info_no where t.out_type='4' and t.input_org='<%=projectInfoNo%>' and info.receive_org_id !='1' and ot.wz_type='11' and t.org_id = '"+org_id+"'";
		  }else{
			  sql += " and ot.wz_type = '22'";
		}
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/warehouseDg/accept/selfaccept/acceptItemList.jsp";
		queryData(1);
	}

	function loadDataDetail(ids){
		if(ids!=null&&ids!="") {
			}else{return;}
		var retObj;
		 var id=ids.split(",");


		 var wz_id=id[3];
		 if(wz_id==""){
				return;
				 }
		if(wz_id!= undefined){
			 retObj = jcdpCallService("MatItemSrv", "getWz", "wz_id="+wz_id);
			
		}else{
	     		return;
		}
		document.getElementById("wz_id").value = retObj.matInfo.wzId;
		document.getElementById("wz_name").value = retObj.matInfo.wzName;
		document.getElementById("wz_prickie").value = retObj.matInfo.wzPrickie;
		 
		 		 
		 var shuaId=id[1];
		 if(shuaId==""){
				return;
				 }
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
		  ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
		    var id=ids.split(",");
		    if(id[2]!=""&&id[4]=="未入库"){
		    	 popWindow("<%=contextPath%>/mat/singleproject/warehouseDg/accept/selfaccept/acceptLedgerAdd.jsp?ids="+id[0]+"&orgId="+id[2],'1024:800');
			    }
		   
			
	 }  
		
       
       function simpleSearch(select){
    	   var sql ='';
			var type = select.value;
			if(type==0){
				var sql =" select i.wz_id, i.wz_name, comm.org_abbreviation, comm.org_id, u.user_name,  t.plan_num, t.plan_price, decode(t.plan_flat_type, '0', '未入库', '1', '已入库') plan_flat_type, t.plan_flat_id, invoices_id,decode(t.wz_type, '1', '在帐', '2', '可重复') wz_type  from gms_mat_demand_plan_flat t inner join p_auth_user u on t.creator_id = u.user_id inner join comm_org_information comm on t.plan_org = comm.org_id inner join gms_mat_infomation i on t.wz_id = i.wz_id where project_info_no = '<%=projectInfoNo%>' and plan_flat_type = '0' ";
				sql+=" union all select i.wz_id,i.wz_name,decode(t2.outbound_org_id, '', '大港分中心') org_abbreviation,decode(t2.outbound_org_id, '', 'C6000000005370') outbound_org_id,decode(t2.outbound_org_id, '', '大港分中心') user_name,t2.demand_num plan_num,i.wz_price plan_price, decode(t2.flat_type, '0', '未入库', '', '未入库', '3', '已入库') plan_flat_type, t2.plan_detail_id plan_flat_id, t2.outbound_number invoices_id,case when t4.plan_invoice_type is not null then '在帐' else '在帐' end wz_type from gms_mat_demand_plan_bz t inner join GMS_MAT_DEMAND_PLAN_DETAIL t2 on t.submite_number = t2.submite_number inner join common_busi_wf_middle t3 on t3.business_id = t.plan_invoice_id inner join gms_mat_demand_plan_invoice t4 on t.plan_invoice_id = t4.plan_invoice_id inner join gms_mat_infomation i on t2.wz_id = i.wz_id where t3.proc_status = '3' and t.bsflag = '0' and t4.plan_invoice_type = '物资供应' and project_info_no = '<%=projectInfoNo%>' and t2.flat_type !='3'";
				sql+=" union all select i.wz_id,i.wz_name,task.project_name org_abbreviation , task.project_info_no org_id,    t.operator user_name,info.out_num plan_num ,info.out_price plan_price,case when info.receive_org_id is not null then '未入库' else '已入库' end plan_flat_type , info.out_info_detail_id plan_flat_id,info.goods_allocation invoices_id, case when info.goods_allocation is  null then '在帐'  end wz_type from gms_mat_out_info t  inner join common_busi_wf_middle mid on t.out_info_id=mid.business_id and mid.bsflag='0' and mid.proc_status ='3'  inner join gms_mat_out_info_detail info  on t.out_info_id=info.out_info_id inner join gms_mat_teammat_out ot on t.out_info_id = ot.plan_invoice_id and ot.bsflag='0' inner join gms_mat_infomation i on i.wz_id=info .wz_id inner join gp_task_project task on t.project_info_no=task.project_info_no where t.out_type='4' and t.input_org='<%=projectInfoNo%>' and info.receive_org_id!='1'";
				if(org_id!=null&&(org_id=="C6000000000039"||org_id=="C6000000000040"||org_id=="C6000000005275"||org_id=="C6000000005277"||org_id=="C6000000005278"||org_id=="C6000000005279"||org_id=="C6000000005280")){
					sql = "select i.wz_id,i.wz_name,task.project_name org_abbreviation , task.project_info_no org_id,    t.operator user_name,info.out_num plan_num ,info.out_price plan_price,case when info.receive_org_id is not null then '未入库' else '已入库' end plan_flat_type , info.out_info_detail_id plan_flat_id,info.goods_allocation invoices_id, case when info.goods_allocation is  null then '在帐'  end wz_type from gms_mat_out_info t  inner join common_busi_wf_middle mid on t.out_info_id=mid.business_id and mid.bsflag='0' and mid.proc_status ='3'  inner join gms_mat_out_info_detail info  on t.out_info_id=info.out_info_id inner join gms_mat_teammat_out ot on t.out_info_id = ot.plan_invoice_id and ot.bsflag='0' inner join gms_mat_infomation i on i.wz_id=info .wz_id inner join gp_task_project task on t.project_info_no=task.project_info_no where t.out_type='4' and t.input_org='<%=projectInfoNo%>' and info.receive_org_id!='1' and ot.wz_type='11' and t.org_id = '"+org_id+"'";
				}else{
					sql += " and ot.wz_type = '22'";
				}
			}else{
			debugger;
				var sql =" select i.wz_id, i.wz_name, comm.org_abbreviation, comm.org_id, u.user_name,  t.plan_num, t.plan_price, decode(t.plan_flat_type, '0', '未入库', '1', '已入库') plan_flat_type, t.plan_flat_id, invoices_id from gms_mat_demand_plan_flat t inner join p_auth_user u on t.creator_id = u.user_id inner join comm_org_information comm on t.plan_org = comm.org_id inner join gms_mat_infomation i on t.wz_id = i.wz_id where project_info_no = '<%=projectInfoNo%>' and plan_flat_type = '"+type+"' ";
				sql+=" union all select i.wz_id,i.wz_name,decode(t2.outbound_org_id, '', '大港分中心') org_abbreviation,decode(t2.outbound_org_id, '', 'C6000000005370') outbound_org_id,decode(t2.outbound_org_id, '', '大港分中心') user_name,t2.demand_num plan_num,i.wz_price plan_price, decode(t2.flat_type, '0', '未入库', '', '未入库', '3', '已入库') plan_flat_type, t2.plan_detail_id plan_flat_id, t2.outbound_number invoices_id from gms_mat_demand_plan_bz t inner join GMS_MAT_DEMAND_PLAN_DETAIL t2 on t.submite_number = t2.submite_number inner join common_busi_wf_middle t3 on t3.business_id = t.plan_invoice_id inner join gms_mat_demand_plan_invoice t4 on t.plan_invoice_id = t4.plan_invoice_id inner join gms_mat_infomation i on t2.wz_id = i.wz_id where t3.proc_status = '3' and t.bsflag = '0' and t4.plan_invoice_type = '物资供应' and project_info_no = '<%=projectInfoNo%>' and t2.flat_type ='3' and t2.outbound_number is not null";
				sql+=" union all select i.wz_id,i.wz_name,task.project_name org_abbreviation , task.project_info_no org_id,    t.operator user_name,info.out_num plan_num ,info.out_price plan_price,case when info.receive_org_id is not null then '已入库' else '未入库' end plan_flat_type , info.out_info_detail_id plan_flat_id,info.goods_allocation invoices_id from gms_mat_out_info t  inner join common_busi_wf_middle mid on t.out_info_id=mid.business_id and mid.bsflag='0' and mid.proc_status ='3'  inner join gms_mat_out_info_detail info  on t.out_info_id=info.out_info_id inner join gms_mat_teammat_out ot on t.out_info_id = ot.plan_invoice_id and ot.bsflag='0' inner join gms_mat_infomation i on i.wz_id=info .wz_id inner join gp_task_project task on t.project_info_no=task.project_info_no where t.out_type='4' and t.input_org='<%=projectInfoNo%>' and info.receive_org_id='1'";
				if(org_id!=null&&(org_id=="C6000000000039"||org_id=="C6000000000040"||org_id=="C6000000005275"||org_id=="C6000000005277"||org_id=="C6000000005278"||org_id=="C6000000005279"||org_id=="C6000000005280")){
					sql = "select i.wz_id,i.wz_name,task.project_name org_abbreviation , task.project_info_no org_id,    t.operator user_name,info.out_num plan_num ,info.out_price plan_price,case when info.receive_org_id is not null then '已入库' else '未入库' end plan_flat_type , info.out_info_detail_id plan_flat_id,info.goods_allocation invoices_id from gms_mat_out_info t  inner join common_busi_wf_middle mid on t.out_info_id=mid.business_id and mid.bsflag='0' and mid.proc_status ='3'  inner join gms_mat_out_info_detail info  on t.out_info_id=info.out_info_id inner join gms_mat_teammat_out ot on t.out_info_id = ot.plan_invoice_id and ot.bsflag='0' inner join gms_mat_infomation i on i.wz_id=info .wz_id inner join gp_task_project task on t.project_info_no=task.project_info_no where t.out_type='4' and t.input_org='<%=projectInfoNo%>' and info.receive_org_id='1' and ot.wz_type='11' and t.org_id = '"+org_id+"'";
				}else{
					sql += " and ot.wz_type = '22'";
				}
			}
			
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
	 	function dbclickRow(ids){
	 	//	ids = getSelIds('rdo_entity_id');
	 		var id=ids.split(",");
	 		if(id[2]!=""&&id[4]=="未入库"){
	 		//var ids=document.getElementById("rdo_entity_id");
	 		 popWindow("<%=contextPath%>/mat/singleproject/warehouseDg/accept/selfaccept/acceptLedgerAdd.jsp?ids="+id[0]+"&orgId="+id[2],'1024:800');
	 				}
		 		}
	 	function chooseOne(cb){  
	        //先取得同name的chekcBox的集合物件   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            //判斷obj集合中的i元素是否為cb，若否則表示未被點選   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            //若是 但原先未被勾選 則變成勾選；反之 則變為未勾選   
	            //else  obj[i].checked = cb.checked;   
	            //若要至少勾選一個的話，則把上面那行else拿掉，換用下面那行   
	            else obj[i].checked = true;   
	        }   
	 	}
</script>

</html>

