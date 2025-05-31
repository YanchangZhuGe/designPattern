<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
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
	String ids  =request.getParameter("ids");
	String orgId  =request.getParameter("orgId");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.dialog.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
</head>
<body onload="refreshData()">
<form name="form1" id="form1" method="post"
	action="">
<div id="new_table_box">
<div id="new_table_box_content">
<div id="new_table_box_bg">

	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right" id="queryRetTable">
			<tr>
				<td class="bt_info_even" exp="<input name = 'rdo_entity_id'  type='checkbox'  value='{out_info_detail_id}' checked = 'true' onclick='loadDataDetail()'/>" ><input type='checkbox' name='rdo_entity_id' value='' onclick='check()'/></td>
				<td class="bt_info_odd" autoOrder="1">序号</td>
				<td class="bt_info_even" exp="{wz_id}<input type='text' style='display:none' name='wz_id_{out_info_detail_id}' id='wz_id_{out_info_detail_id}' value='{wz_id}'  style='width:40px' />">物资编码</td>
				<td class="bt_info_odd" exp="{wz_name}<input type='text' style='display:none' name='wz_name_{out_info_detail_id}' id='wz_name_{out_info_detail_id}' value='{wz_name}'  style='width:40px' />">物资名称</td>
				<td class="bt_info_even" exp="{out_num}">退库数量</td>
				<td class="bt_info_odd" exp="{out_price}<input type='text' style='display:none' name='out_price_{out_info_detail_id}' id='mat_num_{out_info_detail_id}' value='{out_price}'  style='width:40px' />">入库单价</td>
				<td class="bt_info_even"exp="{out_num}<input type='text' style='display:none' name='out_num_{out_info_detail_id}' id='out_num_{out_info_detail_id}' value='{out_num}'  style='width:40px' onkeyup='keyup()'/>">入库数量</td>
				<td class="bt_info_odd" exp="{total_money}<input type='text' style='display:none' name='total_money_{out_info_detail_id}' id='mat_num_{out_info_detail_id}' value='{total_money}'  style='width:40px'/>">入库金额</td>
				<td class="bt_info_even" exp="{coding_code_id}<input type='text' style='display:none' name='coding_code_id_{out_info_detail_id}' id='coding_code_id_{out_info_detail_id}' value='{coding_code_id}'  style='width:40px'/>">物资分类码</td>
				<td class="bt_info_even" exp="{org_abbreviation}<input type='text' style='display:none' name='source_org_id_{out_info_detail_id}' id='source_org_id_{out_info_detail_id}' value='{org_id}'  style='width:40px'/>">物资来源</td>
				<td class="bt_info_odd"exp="<select style='' id='wz_type' name='wz_type_{out_info_detail_id}' value='' ><option value='1'>在帐物资</option><option value='2'>可重复物资</option>">物资类型</td> 
				<td class="bt_info_even"exp="<input style='' id='note' name='note_{out_info_detail_id}' value='' />">备注</td> 
			</tr>
		</table>
	</div>
	<table id="fenye_box_table">
	</table>
</div>
		
<div id="oper_div"><span class="bc_btn"><a href="#"
	onclick="save()"></a></span> <span class="gb_btn"><a href="#"
	onclick="newClose()"></a></span></div>
</div>
</div>
<div id="dialog-modal" title="正在执行" style="display:none;">
	请不要关闭
</div>
</form>
</body>
<script type="text/javascript">
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
<script type="text/javascript"><!--
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	var checked = false;
  	function check(){
		var chk = document.getElementsByName("rdo_entity_id");
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
	function refreshData(){
		var ids = "<%=ids%>";
		var sql ="select * from (select q.out_info_detail_id ,wz_name,i.coding_code_id,i.wz_id,out_num,out_price,operator,comm.org_abbreviation,comm.org_id,case when q.bsflag ='0' then '未验收' else '已验收' end bsflag,(out_num*out_price) total_money from GMS_MAT_OUT_INFO_DETAIL q inner join GMS_MAT_OUT_INFO q1 on q1.out_info_id=q.out_info_id inner join comm_org_information comm on q1.org_id=comm.org_id  inner join gms_mat_infomation i on q.wz_id=i.wz_id  where receive_org_id='<%=user.getOrgId()%>' and q.bsflag='0') abc ";
		var id = ids.split(",");
		sql += " where abc.out_info_detail_id in (";
		for(var i=0;i<id.length;i++){
			sql += "'"+id[i]+"'";
			if(i!=id.length-1){
				sql += ",";
			}
		}
		sql += " ) ";
		debugger;
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/multiproject/suppliesAllocate/acceptItemList.jsp";
		queryData(1);
	}					
	
	function openMatHave(){
		var selectWzId = document.getElementById("selectWzId").value;
		var selected = window.showModalDialog("<%=contextPath%>/mat/singleproject/warehouse/accept/selfaccept/selectAcceptList.jsp?selectWzId="+selectWzId,"","dialogWidth=1240px;dialogHeight=480px");
		var wz_id = selected;
		document.getElementById("selectWzId").value = wz_id;
		cruConfig.submitStr ="wz_ids="+wz_id;
		if(selected!=null&&selected!=""){
			refreshData();
		}
	}
	
	function deleteMatHave(){
		ids = getSelIds('rdo_entity_id');
   	  	if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
   	 	var tab=document.getElementById("queryRetTable");//最好给table指定个id
	   // for(var i=0;i<tab.rows.length;i++) {
    	var obj=document.getElementsByName("rdo_entity_id");
    	var length = obj.length;
    	
    	if(obj!=null ){
    		for(var j=length-1; j>=0;j--){
		    	var rdo = obj[j];
		    	if(rdo!=null && rdo.checked==true) {//你没说需求我就直接将第一行中有checkbox且为true的删除
		            tab.deleteRow(j);
	            }
	    	}
    	}
		var newIds = getSelIds2('rdo_entity_id');
		var wz_ids = "";
		if(newIds!=""){
			var temp = newIds.split(",");
			for(var i=0;i<temp.length;i++){
				if(wz_ids!=""){
					wz_ids += ","; 
				}
				wz_ids += "'"+temp[i]+"'";
			}
		}
		//重新刷新列表页面
		document.getElementById("selectWzId").value = wz_ids;
		if(wz_ids!=null&&wz_ids!=""){
			cruConfig.submitStr ="wz_ids="+wz_ids;
			refreshData();
		}
	}
   	 	
	function getSelIds2(inputName){
		var checkboxes = document.getElementsByName(inputName);
		
		var ids = "";
		for(var i=0;i<checkboxes.length;i++){
			var chx = checkboxes[i];
			if(ids!="") ids += ",";
			ids += chx.value;
		}
		return ids;
	}	
	
	
	
	function save(){	
		//if (!checkForm()) return;
		ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				alert("请选择一条记录!");
				return;
			}
		
		
		openMask();
		document.getElementById("form1").action="<%=contextPath%>/mat/singleproject/warehouse/accept/selfaccept/saveAcceptWz.srq?id="+ids;
		document.getElementById("form1").submit();
	}
	 function openMask(){
			$( "#dialog-modal" ).dialog({
				height: 140,
				modal: true,
				draggable: false
			});
		}
	 
	 
	function keyup(){
		var tab =document.getElementById("queryRetTable");
		var outNum=0;
		var wzPrice=0;
		var totalMoney=0;
		var row = tab.rows;
		for(var i=1;i<row.length;i++){
			if(row[i].cells[5].innerHTML!=null){
				debugger;
				if(row[i].cells[5].innerHTML!="&nbsp;"){
					row[i].cells[7].firstChild.value=row[i].cells[5].innerHTML;
					}
				
				var cell_5 = row[i].cells[5].innerHTML;
				var cell_6 = row[i].cells[6].firstChild.value;
				var cell_7 = row[i].cells[7].firstChild.value;
				var cell_8 = row[i].cells[8].firstChild.value;
				var cell_0 = row[i].cells[0].firstChild.checked;
				if(cell_0 == true){
					if(cell_7!=undefined && cell_8!=undefined &&cell_6!=undefined){
						if(parseInt(cell_5,10)<parseInt(cell_7,10)){
							row[i].cells[7].firstChild.value=cell_5;
							cell_7=cell_5;
						}
							if(cell_7==""){
								outNum=0;
								}
							else{
								outNum=cell_7;
								}
							
							if(cell_6==""){
								wzPrice=0;
								}
							else{
								wzPrice=cell_6;
								}
							if(cell_5==""){
								cell_5=0;
								}
							
						row[i].cells[8].firstChild.value=Math.round((outNum*wzPrice)*1000)/1000;
					}
				}

				}
		}
	}
	 
</script>
</html>