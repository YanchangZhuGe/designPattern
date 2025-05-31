<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId=user.getEmpId();
	String projectInfoNo = user.getProjectInfoNo();
	boolean proc_status = OPCommonUtil.getProcessStatus2("BGP_OP_TARGET_PROJECT_INFO","gp_target_project_id","5110000004100000032",projectInfoNo);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript"  src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>

  <title>人员投入表</title>
 </head>

 <body style="background:#fff" onload="refreshData()">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">班组</td>
			    <td class="ali_cdn_input"><input id="team_name" name="team_name" class="input_width" type="text"/></td>
			    <td class="ali_cdn_name">牌照号</td>
			    <td class="ali_cdn_input"><input id="license_num" name="license_num" class="input_width" type="text"/></td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
				<td>&nbsp;</td>
				<td align="right" style="padding-right: 20px;"><font color="red"><span id="sum_value"></span></font></td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			     <tr>
			      <td class="bt_info_odd"  exp="<input type='checkbox' name='rdo_entity_id' value='{dev_acc_id}' id='rdo_entity_id_{dev_acc_id}'   />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{team_name}">班组</td>
			      <td class="bt_info_even" exp="{dev_name}">设备名称</td>
			      <td class="bt_info_odd" exp="{dev_model}">规格型号</td>
			      <td class="bt_info_odd" exp="{license_num}">牌照号</td>
			      <td class="bt_info_even" exp="{qc_money}" onclick="getSum(1)">汽车材料</td>
			      <td class="bt_info_even" exp="{zj_money}" onclick="getSum(2)">钻机材料</td>
			      <td class="bt_info_odd" exp="{qy_money}" onclick="getSum(3)">汽油</td>
			      <td class="bt_info_odd" exp="{cy_money}" onclick="getSum(4)">柴油</td>
			      <td class="bt_info_odd" exp="{x_money}" onclick="getSum(5)">小油品</td>
			     </tr>
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
				    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">材料明细</a></li>
				    <li id="tag3_1"><a href="#" onclick="getTab3(1)">油品明细</a></li>
				  </ul>
			</div>
			<div id="tab_box" class="tab_box" style="overflow:hidden;">
				    <div id="tab_box_content0" class="tab_box_content">
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
				    <div id="tab_box_content1" class="tab_box_content">
				    	<div style="overflow:auto">
				      	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						  	<tr align="right">
						  		<td class="ali_cdn_name" ></td>
						  		<td class="ali_cdn_input" ></td>
						  		<td class="ali_cdn_name" ></td>
						  		<td class="ali_cdn_input" ></td>
						  		<td>&nbsp;</td>
						    	<auth:ListButton functionId="" css="zj" event="onclick='toAddYS()'" title="JCDP_btn_add"></auth:ListButton>
								<auth:ListButton functionId="" css="xg" event="onclick='toEditYS()'" title="JCDP_btn_edit"></auth:ListButton>
								<auth:ListButton functionId="" css="sc" event="onclick='toDeleteYS()'" title="JCDP_btn_delete"></auth:ListButton>
							</tr>
						  </table>
					  </div>
					<table id="ysMap" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
						<tr>   
						<td class="bt_info_odd">选择</td>          
						<td class="bt_info_even">加注日期</td>
						<td class="bt_info_odd">油品名称</td>
						<td class="bt_info_even">单位</td>
					    <td class="bt_info_odd">数量</td>
						<!-- <td class="bt_info_even">累计数量</td> -->
					    <td class="bt_info_even">单价（元）</td>
					    <td class="bt_info_odd"> 金额（元） </td>
					  </tr>
					  <tbody id="assign_body"></tbody>
					</table>
				    </div>
			</div>
</body>

<script type="text/javascript">


	$(document).ready(readyForSetHeight);

	frameSize();
	
	$(document).ready(lashen);

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNo = '<%=projectInfoNo%>';
	function simpleSearch(){
		refreshData();
	}

	function clearQueryText(){
		$("#team_name").val('');
		$("#license_num").val('');
		refreshData();
	}
	
	function refreshData(ids){
		if(ids==null||ids==""||ids==undefined) ids=cruConfig.currentPage;
		if(ids==0)ids=1;
		cruConfig.queryStr =" select sd.coding_name team_name,m.dev_acc_id,m.dev_name,m.license_num,m.dev_model,p3.qy_money,p3.cy_money,p1.x_money,p2.qc_money,p2.zj_money "+ 
		" from gms_device_account_dui m  "+
		" left join (select dui.dev_acc_id,sum(case when mi.coding_code_id like '0705%' or mi.coding_code_id like '0707%' or mi.coding_code_id like '0708%' "+
		" or mi.coding_code_id like '0709%' or mi.coding_code_id like '179905%' then d.mat_num * d.actual_price else 0 end) x_money"+
		" from gms_device_account_dui dui left join gms_mat_teammat_out o on dui.dev_acc_id = o.dev_acc_id and o.bsflag = '0' and o.dev_acc_id is not null"+
		" left join gms_mat_teammat_out_detail d on o.teammat_out_id = d.teammat_out_id and d.bsflag = '0'"+
		" left join gms_mat_infomation mi on d.wz_id = mi.wz_id and mi.bsflag = '0'  "+
		" where dui.project_info_id = '"+projectInfoNo+"' group by dui.dev_acc_id) p1  on m.dev_acc_id = p1.dev_acc_id "+
		" left join (select dui.dev_acc_id,sum(case when mi.coding_code_id like '55%' or mi.coding_code_id like '56%' then d.mat_num * d.actual_price else 0 end) qc_money,  "+
		" sum(case when mi.coding_code_id like '48%' then d.mat_num * d.actual_price else 0 end) zj_money "+
		" from gms_device_account_dui dui left join gms_mat_teammat_out o on dui.dev_acc_id = o.dev_acc_id and o.bsflag = '0' and o.dev_acc_id is not null"+
		" left join gms_mat_teammat_out_detail d on o.teammat_out_id = d.teammat_out_id and d.bsflag = '0'"+
		" left join gms_mat_infomation mi on d.wz_id = mi.wz_id and mi.bsflag = '0'  "+
		" where dui.project_info_id = '"+projectInfoNo+"' group by dui.dev_acc_id) p2  on m.dev_acc_id = p2.dev_acc_id "+
		" left join (select dui.dev_acc_id,sum(case when mi.coding_code_id like '070301%' then d.oil_num * d.actual_price else 0 end) qy_money, "+
		" sum(case when mi.coding_code_id like '070303%' then d.oil_num * d.actual_price else 0 end) cy_money "+
		" from gms_device_account_dui dui left join gms_mat_teammat_out_detail d on dui.dev_acc_id = d.dev_acc_id and d.bsflag = '0' and d.dev_acc_id is not null"+
		" left join gms_mat_teammat_out o on d.teammat_out_id = o.teammat_out_id and o.bsflag = '0'"+
		" left join gms_mat_infomation mi on d.wz_id = mi.wz_id and mi.bsflag = '0'  "+
		" where dui.project_info_id = '"+projectInfoNo+"' group by dui.dev_acc_id) p3  on m.dev_acc_id = p3.dev_acc_id "+
		" left outer join comm_coding_sort_detail sd on m.dev_team = sd.coding_code_id "+
		" where m.project_info_id = '"+projectInfoNo+"'and m.dev_type not like 'S1405%'";
		
		if($("#team_name").val()!=''){
			cruConfig.queryStr+=" and sd.coding_name like'%"+$("#team_name").val()+"%'";
		}
		if($("#license_num").val()!=''){
			cruConfig.queryStr+=" and m.license_num like '%"+$("#license_num").val()+"%'";
		}
		cruConfig.currentPageUrl = "/op/costActualManager/costSingleDeviceConsumeInfo.jsp";
		queryData(ids);
	}
	function loadDataDetail(ids){
  			ysjl(ids);
			wzjl(ids);
  	}
	function ysjl(shuaId){
		if (shuaId != null) {
			var querySql=" select ''oil_info_id,o.outmat_date,mi.wz_name,mi.wz_prickie,d.mat_num,d.actual_price,nvl(d.mat_num,0)*nvl(d.actual_price,0) total_money "+
			" from gms_device_account_dui dui left join gms_mat_teammat_out o on dui.dev_acc_id = o.dev_acc_id and o.bsflag = '0' and o.dev_acc_id is not null"+
			" left join gms_mat_teammat_out_detail d on o.teammat_out_id = d.teammat_out_id and d.bsflag = '0'"+
			" left join gms_mat_infomation mi on d.wz_id = mi.wz_id and mi.bsflag = '0'  "+
			" where dui.dev_acc_id = '"+shuaId+"' and (mi.coding_code_id like '0705%' or mi.coding_code_id like '0707%' or mi.coding_code_id like '0708%'"+ 
			" or mi.coding_code_id like '0709%' or mi.coding_code_id like '179905%') union all"+
			" select ''oil_info_id,o.outmat_date,mi.wz_name,mi.wz_prickie,d.mat_num,d.actual_price, nvl(d.oil_num,0)*nvl(d.actual_price,0)total_money "+
			" from gms_device_account_dui dui left join gms_mat_teammat_out_detail d on dui.dev_acc_id = d.dev_acc_id and d.bsflag = '0' and d.dev_acc_id is not null"+
			" left join gms_mat_teammat_out o on d.teammat_out_id = o.teammat_out_id and o.bsflag = '0'"+
			" left join gms_mat_infomation mi on d.wz_id = mi.wz_id and mi.bsflag = '0'  "+
			" where dui.dev_acc_id = '"+shuaId+"' and (mi.coding_code_id like '070301%' or mi.coding_code_id like '070303%' )";

			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+encodeURI(encodeURI(querySql)));
			retObj = queryRet.datas;
			
			var size = $("#assign_body", "#tab_box_content1").children("tr").size();
			if (size > 0) {
				$("#assign_body", "#tab_box_content1").children("tr").remove();
			}
			var ys_body1 = $("#assign_body", "#tab_box_content1")[0];
			if (retObj != undefined) {
				for (var i = 0; i < retObj.length; i++) {
				var newTr=ys_body1.insertRow()
				newTr.id=retObj[i].oil_info_id;
				newTr.onclick=function(){setGl2(this, 'tab_box_content1');}
				newTr.ondblclick=function(){toEdit(this);}
				newTr.insertCell().innerHTML="<input type=checkbox id='ys_info"+retObj[i].oil_info_id+"' value='"+retObj[i].oil_info_id+"'/>";
				newTr.insertCell().innerText=retObj[i].outmat_date;
				newTr.insertCell().innerText=retObj[i].wz_name;
				newTr.insertCell().innerText=retObj[i].wz_prickie;
				newTr.insertCell().innerText=retObj[i].mat_num;
				//newTr.insertCell().innerText=retObj[i].quantity_total;
				newTr.insertCell().innerText=retObj[i].actual_price;
				newTr.insertCell().innerText=retObj[i].total_money;
					
				}
			}
		}
		$("#assign_body>tr:odd>td:odd", '#tab_box_content1').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even", '#tab_box_content1').addClass("odd_even");
		$("#assign_body>tr:even>td:odd", '#tab_box_content1').addClass("even_odd");
		$("#assign_body>tr:even>td:even", '#tab_box_content1').addClass("even_even");
	}
	function wzjl(ids){
		for(var j =1;j <document.getElementById("taskTable")!=null && j < document.getElementById("taskTable").rows.length ;){
  				document.getElementById("taskTable").deleteRow(j);
  			}
  			var retObj = jcdpCallService("OPCostSrv", "findGrantList", "devAccId="+ids);
  			var taskList = retObj.matInfo;
  			for(var i =0; taskList!=null && i < taskList.length; i++){
  				var coding_code_id = taskList[i].coding_code_id;
  				var wz_name = taskList[i].wz_name;
  				var wz_prickie = taskList[i].wz_prickie;
  				var mat_num = taskList[i].mat_num;
  				var actual_price = taskList[i].actual_price;
  				var total_money = taskList[i].total_money;
  				var outmat_date = taskList[i].outmat_date;
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
  		        td.innerHTML = coding_code_id;
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
  				
  		        td.innerHTML = mat_num*actual_price;
  		        td.className = tdClass+'_odd';
  		        if(autoOrder%2==0){
  					td.style.background = "#f6f6f6";
  				}else{
  					td.style.background = "#e3e3e3";
  				}
  		      td = newTR.insertCell(7);
		        td.innerHTML = outmat_date;
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
	
	function getSum(type){
		var projectInfoNo = '<%=projectInfoNo%>';
		var querySql = " select sum(nvl(qc_money,0)) sum_value1,sum(nvl(zj_money,0)) sum_value2,sum(nvl(qy_money,0)) sum_value3,sum(nvl(cy_money,0)) sum_value4,"+
		" sum(nvl(x_money,0)) sum_value5 from gms_device_account_dui m  "+
		" left join (select dui.dev_acc_id,sum(case when mi.coding_code_id like '0705%' or mi.coding_code_id like '0707%' or mi.coding_code_id like '0708%' "+
		" or mi.coding_code_id like '0709%' or mi.coding_code_id like '179905%' then d.mat_num * d.actual_price else 0 end) x_money"+
		" from gms_device_account_dui dui left join gms_mat_teammat_out o on dui.dev_acc_id = o.dev_acc_id and o.bsflag = '0' and o.dev_acc_id is not null"+
		" left join gms_mat_teammat_out_detail d on o.teammat_out_id = d.teammat_out_id and d.bsflag = '0'"+
		" left join gms_mat_infomation mi on d.wz_id = mi.wz_id and mi.bsflag = '0'  "+
		" where dui.project_info_id = '"+projectInfoNo+"' group by dui.dev_acc_id) p1  on m.dev_acc_id = p1.dev_acc_id "+
		" left join (select dui.dev_acc_id,sum(case when mi.coding_code_id like '55%' or mi.coding_code_id like '56%' then d.mat_num * d.actual_price else 0 end) qc_money,  "+
		" sum(case when mi.coding_code_id like '48%' then d.mat_num * d.actual_price else 0 end) zj_money "+
		" from gms_device_account_dui dui left join gms_mat_teammat_out o on dui.dev_acc_id = o.dev_acc_id and o.bsflag = '0' and o.dev_acc_id is not null"+
		" left join gms_mat_teammat_out_detail d on o.teammat_out_id = d.teammat_out_id and d.bsflag = '0'"+
		" left join gms_mat_infomation mi on d.wz_id = mi.wz_id and mi.bsflag = '0'  "+
		" where dui.project_info_id = '"+projectInfoNo+"' group by dui.dev_acc_id) p2  on m.dev_acc_id = p2.dev_acc_id "+
		" left join (select dui.dev_acc_id,sum(case when mi.coding_code_id like '070301%' then d.oil_num * d.actual_price else 0 end) qy_money, "+
		" sum(case when mi.coding_code_id like '070303%' then d.oil_num * d.actual_price else 0 end) cy_money "+
		" from gms_device_account_dui dui left join gms_mat_teammat_out_detail d on dui.dev_acc_id = d.dev_acc_id and d.bsflag = '0' and d.dev_acc_id is not null"+
		" left join gms_mat_teammat_out o on d.teammat_out_id = o.teammat_out_id and o.bsflag = '0'"+
		" left join gms_mat_infomation mi on d.wz_id = mi.wz_id and mi.bsflag = '0'  "+
		" where dui.project_info_id = '"+projectInfoNo+"' group by dui.dev_acc_id) p3  on m.dev_acc_id = p3.dev_acc_id "+
		" left outer join comm_coding_sort_detail sd on m.dev_team = sd.coding_code_id "+
		" where m.project_info_id = '"+projectInfoNo+"'and m.dev_type not like 'S1405%'";
		
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj!=null && retObj.returnCode=='0'&& retObj.datas!=null && retObj.datas[0]!=null){
			debugger;
			var sum_value = 0;
			if(type==1){
				sum_value = retObj.datas[0].sum_value1;
			}else if(type==2){
				sum_value = retObj.datas[0].sum_value2;
			}else if(type==3){
				sum_value = retObj.datas[0].sum_value3;
			}else if(type==4){
				sum_value = retObj.datas[0].sum_value4;
			}else if(type==5){
				sum_value = retObj.datas[0].sum_value5;
			}
			document.getElementById("sum_value").innerHTML = "合计:"+sum_value;
		}	
	}
</script>
</html>