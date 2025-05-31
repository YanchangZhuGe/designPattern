<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>

<%
		String contextPath = request.getContextPath();
		UserToken user = OMSMVCUtil.getUserToken(request);
		String orgName = user.getOrgName();
		String projectName = user.getProjectName();
		String userName = user.getUserName();
		String projectInfoId = user.getProjectInfoNo();
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		String subDate = df.format(new Date());
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String applyDate = sdf.format(new Date());
		
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>物资汇总编辑管理</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
<link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
<link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
<link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json2.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
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
<body onload="refreshData()" style="background: #fff">
<form name="form1" id="form1" method="post" action="">
<input type='hidden' name='laborId' id='laborId' value=''/>
	<table  border="0" cellpadding="0" cellspacing="0" id='tab_line_height' name='tab_line_height' class="tab_line_height" width="100%">

  	<tr>
    	<td colspan="4" align="center">计划汇总</td>
    </tr>
    <tr>
    	
    	<td class="inquire_item4"><font color="red">*</font>项目名称：</td>
      	<td class="inquire_form4">
      	<input type="text" name="project_name" id="project_name"class="input_width" value="" />
      	<input type="hidden" name="plan_invoice_id" id="plan_invoice_id"class="input_width" value="" />
      	</td>
      	<td class="inquire_item4">申请队伍：</td>
      	<td class="inquire_form4"><input type="text" name="org_name" id = "org_name" class="input_width" value="" /></td>
    </tr>
    <tr>
    	<td class="inquire_item4">提交人：</td>
      	<td class="inquire_form4"><input type="text" name="creator_id" id="creator_id" class="input_width" value="" /></td>
		<td class="inquire_item4">提交时间：</td>
      	<td class="inquire_form4"><input type="text" name="compile_date" id = 'compile_date'class="input_width" value="" />
      	<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(compile_date,tributton1);" /></td>
    </tr> 
    <tr>
    	<td class="inquire_item4">金额：</td>
	    <td class="inquire_form4"><input type='text' name='total_money' id='total_money' value=''></td>
	    <td class="inquire_item4">申请单号：</td>
	    <td class="inquire_form4"><input type='text' name='submite_number' id='submite_number' value=''></td>
    </tr>
    <tr>
    	 <td class="inquire_item4">计划名称：</td>
	    <td class="inquire_form4"><input type='text' name='plan_name' id='plan_name' class="input_width" value=''></td>
	    <td class="inquire_item4">主办区域：</td>
	    <td class="inquire_form4"><input type="text" name="main_part" id="main_part" class="input_width" value=""></td>
    </tr>
    <tr>
    	 <td class="inquire_item4">备注：</td>
	     <td class="inquire_form4" colspan="3"><textarea id="memo" name="memo" calss="textarea" style="width: 80%;height: 50px;"></textarea></td>
    </tr>
</table>
<div id="tag-container_3">
<ul id="tags" class="tags">
	<li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">汇总信息</a></li>
	<li id="tag3_1"><a href="#" onclick="getTab3(1)">明细信息</a></li>
</ul>
</div>
<div id="tab_box" class="tab_box">
<div id="tab_box_content0" class="tab_box_content">
<div id="table_box" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input name = 'wz_id_{wz_id}' id='rdo_entity_id' checked='checked'type='checkbox' value='{wz_id}' onclick='loadDataDetail()'/>"><input type='checkbox' name='task_entity_id' value='' onclick='check()'/></td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{wz_name}">资源名称</td>
			      <td class="bt_info_even" exp="{demand_num}">需求数量</td>
			      <td class="bt_info_odd" exp="{wz_price}">参考单价</td>
			      <td class="bt_info_even" exp="<input name='have_num{wz_id}'  type='text' value='{have_num}' readonly/>">现有数量</td>
			      <td class="bt_info_odd" isShow='Hide' exp="<input name = 'regulate_num{wz_id}'  type='text' value='{regulate_num}' readonly/>">可调剂数量</td>
			      <td class="bt_info_even" exp="<input name='apply_num{wz_id}'  type='text' value='' readonly/>">合计申请量</td>
			      <td class="bt_info_odd" exp="<input name='plan_money{wz_id}'  type='text' value='' readonly/>">计划金额</td>
<!-- 			      <td class="bt_info_even" exp="{mat_desc}">物资说明</td> -->
			    </tr>
			  </table>
			</div>
			<table  id="fenye_box_table">
			</table>
			</div>
			<div id="tab_box_content1" class="tab_box_content" style="display: none; overflow: hidden;">
			<iframe width="100%" height="100%" name="team" id="team" frameborder="0" marginheight="0" marginwidth="0" >
			</iframe>
			</div>
</div>
    <div id="oper_div">
     	<span class="bc_btn"><a href="#" onclick="save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
    <div id="dialog-modal" title="正在执行" style="display:none;">
	请不要关闭
</div>
</form>
</body>
<script type="text/javascript">

var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
var showTabBox = document.getElementById("tab_box_content0");
</script>
<script type="text/javascript">
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
	function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]);
    return null;
    }
    var planInvoiceId = getQueryString("planInvoiceId");
    function refreshData(){
    	showTitle(planInvoiceId);
    	cruConfig.queryService = "MatItemSrv";
    	cruConfig.queryOp = "getTeamEdit";
		cruConfig.submitStr ="planInvoiceId="+planInvoiceId;
		queryData(1);
		loadDataDetail();
		document.getElementById("team").src = "<%=contextPath%>/mat/singleproject/plansub/subEditTeamList.jsp?planInvoiceId="+planInvoiceId;
	}
    function showTitle(value){
    	var retObj = jcdpCallService("MatItemSrv", "getplan", "laborId="+value);
    	debugger;
    	document.getElementById("plan_invoice_id").value = value;
    	document.getElementById("project_name").value = retObj.matInfo.projectName;
    	document.getElementById("org_name").value = retObj.matInfo.orgName;
    	document.getElementById("creator_id").value = retObj.matInfo.userName;
    	document.getElementById("compile_date").value = retObj.matInfo.compileDate;
    	document.getElementById("submite_number").value = retObj.matInfo.submiteNumber;
    	document.getElementById("total_money").value = retObj.matInfo.totalMoney;
    	document.getElementById("plan_name").value = retObj.matInfo.planName;
    	document.getElementById("main_part").value = retObj.matInfo.mainPart;
    	document.getElementById("memo").value = retObj.matInfo.memo;
    	
        }
	function save(){	
		ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
	    document.getElementById("laborId").value = ids;
	    openMask();
	    document.getElementById("form1").action = "<%=contextPath%>/mat/singleproject/plansub/updatePlanSub.srq";
		document.getElementById("form1").submit();
	}
	function frameSize(){
		setTabBoxHeight();
	}
	frameSize();

	function loadDataDetail(shuaId){
		var tab =document.getElementById("queryRetTable");
		var outNum=0;
		var wzPrice=0;
		var totalMoney=0;
		var row = tab.rows;
		var obj = event.srcElement;
/*		if(obj.tagName.toLowerCase() =='td'){
			var tr = obj.parentNode;
			selectIndex = tr.rowIndex;
		}else if(obj.tagName.toLowerCase() =='input'){
			var tr = obj.parentNode.parentNode;
			selectIndex = tr.rowIndex;
		}
*/	
	for(var i=1;i<row.length;i++){
		var cell_0 = row[i].cells[0].firstChild.checked;
		if(cell_0){
			var cell_3 = row[i].cells[3].innerHTML;
			var cell_4 = row[i].cells[4].innerHTML;
			var cell_5 = row[i].cells[5].firstChild.value;
//			var cell_6 = row[i].cells[6].firstChild.value;
			var cell_6 = 0;//默认为0
			if(cell_4!=undefined && cell_6!=undefined){
				
					if(cell_3==""){
						cell_3=0;
						}
					if(cell_4=='&nbsp;'){
						cell_4=0;
						}
					if(cell_5==""){
						row[i].cells[5].firstChild.value=0;
						cell_5=0;
						}
					if(cell_6==""){
						row[i].cells[6].firstChild.value=0;
						cell_6=0;
						}
					
					row[i].cells[7].firstChild.value=Math.round((cell_3-cell_5-cell_6)*1000)/1000;
				if(parseInt(row[i].cells[7].firstChild.value)<0){
					row[i].cells[7].firstChild.value=0;
					}
				row[i].cells[8].firstChild.value = Math.round((cell_4*(row[i].cells[7].firstChild.value))*1000)/1000;
				totalMoney += Math.round((cell_4*(row[i].cells[7].firstChild.value))*1000)/1000;
			}
		}
	}
		document.getElementById("total_money").value = Math.round(totalMoney*1000)/1000;
	}
	
	 function openMask(){
			$( "#dialog-modal" ).dialog({
				height: 140,
				modal: true,
				draggable: false
			});
		}
	 function getPlanNum(){
			var retObj = jcdpCallService("MatItemSrv", "findSumNum", "ids=");
			var taskList = retObj.matInfo;
			var num=1;
			if(taskList!=undefined){
					num=taskList.length+1;
				}
			document.getElementById("submite_number").value=<%=applyDate%>+"-00"+num;
			}	
</script>
</html>