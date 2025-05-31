<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo==null||"".equals(projectInfoNo)){
		UserToken user = OMSMVCUtil.getUserToken(request);
		projectInfoNo= user.getProjectInfoNo();
	}
	String planInvoiceId = request.getParameter("planInvoiceId");
	String isDone = request.getParameter("isDone");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>配置补充计划审批明细页面</title> 
 </head> 
 <body class="bgColor_f3f3f3" onload="refreshData()">
 <form name="form1" id="form1" method="post" action="" target="target_id">
 		<div id="list_table">
			<div id="table_box" style="overflow-y:srcoll;height:1000px">
				<fieldSet style="margin-left:2px;width:98%"><legend>送审计划基本信息</legend>
			      	<input type='hidden' name='plan_invoice_id' id='plan_invoice_id' value=''>
			      	<input type='hidden' name='laborId' id='laborId' value=''>
					<table  border="0" cellpadding="0" cellspacing="0" id='tab_line_height' name='tab_line_height' class="tab_line_height" width="100%">
			  			<tr>
			    			<td colspan="4" align="center">送审计划审批</td>
			    		</tr>
					    <tr>
					    	<td class="inquire_item4">项目名称：</td>
					      	<td class="inquire_form4"><input type="text" name="project_name" id="project_name" class="input_width" value="" readonly/></td>
					    	<td class="inquire_item4">申请单号：</td>
					      	<td class="inquire_form4"><input type="text" name="submite_number" id="submite_number" class="input_width" value="" readonly/></td>
					    </tr>
					    <tr>
					    	<td class="inquire_item4">队伍：</td>
					      	<td class="inquire_form4"><input type="text" name="org_id" id="org_id" class="input_width" value="" readonly/></td>
					      	<td class="inquire_item4">创建人：</td>
					      	<td class="inquire_form4"><input type="text" name="creator_id" id="creator_id" class="input_width" value="" readonly/></td>
					    </tr>
					    <tr>
					      	<td class="inquire_item4">创建时间：</td>
					      	<td class="inquire_form4"><input type="text" name="creator_date" id="creator_date" class="input_width" value="" readonly/></td>
					      	<td class="inquire_item4">金额：</td>
					      	<td class="inquire_form4"><input type="text" name="total_money" id="total_money" class="input_width" value="" readonly/></td>
					    </tr>
					    <tr>
					    	<td class="inquire_item4">主办区域：</td>
					      	<td class="inquire_form4"><input type="text" name="main_part" id="main_part" class="input_width" value="" readonly/></td>
					      	<td class="inquire_item4"></td>
					      	<td class="inquire_form4"></td>
					    </tr>
					    <tr>
					    	<td class="inquire_item4">备注：</td>
					      	<td class="inquire_form4" colspan="3"><textarea id="memo" name="memo" class="textarea"></textarea></td>
					    </tr>
					</table>
		    </fieldSet>
			<div id="tag-container_3">
			<ul id="tags" class="tags">
				<li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">审批明细</a></li>
				<li id="tag3_1"><a href="#" onclick="getTab3(1)">汇总信息</a></li>
				<li id="tag3_2"><a href="#" onclick="getTab3(2)">明细信息</a></li>
			</ul>
			</div>
			<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content" style="display:block;">
				<wf:getProcessInfo />
				<br />
			<%
				 if(!("1").equals(isDone)){
					 %>
					  <div id="oper_div" >
			        <span class="pass_btn" title="审批通过"><a id="submitButton" href="#" onclick="submitInfo(1)"></a></span>
			        <span class="nopass_btn" title="审批不通过"><a href="#" onclick="submitInfo(0)"></a></span>
			    </div>
					 <%
				 }
				 %>
				 
			</div>
			<div id="tab_box_content1" class="tab_box_content" style="display: none; overflow: hidden;">
			   <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
					<tr>
						<td class="bt_info_odd" exp="<input name = 'plan_id_{wz_id}' id='rdo_entity_id' checked='checked'type='checkbox' value='{wz_id}' onclick='loadDataDetail()'/>"><input type='checkbox' name='task_entity_id' value='' onclick='check()'/></td>
						<td class="bt_info_even" autoOrder="1">序号</td>
						<td class="bt_info_odd" exp="{wz_name}">资源名称</td>
						<td class="bt_info_even" exp="{demand_num}">需求数量</td>
						<td class="bt_info_odd" exp="{wz_price}">参考单价</td>
						<td class="bt_info_even" exp="{have_num}">现有数量</td>
						<td class="bt_info_odd" exp="{regulate_num}">库存量</td>
						<td class="bt_info_even" exp="<input name = 'regulate_num{wz_id}'  type='text' value='{regulate_num}'/>">本次可调剂数量</td>
						<td class="bt_info_odd" exp="<input name='apply_num{wz_id}'  type='text' value='' readonly/>">合计申请量</td>
						<td class="bt_info_even" exp="{plan_money}">计划金额</td>
						<td class="bt_info_odd" exp="{description}">物资说明</td>
						<td class="bt_info_even" exp="{code_name}">物资类别</td>
					</tr>
				</table>
				<table  id="fenye_box_table">
				</table>
			</div>
			<div id="tab_box_content2" class="tab_box_content" style="display: none; overflow: hidden;height: 350px;">
			<iframe width="100%" height="100%" name="team" id="team" frameborder="0" marginheight="0" marginwidth="0" >
			</iframe>
			</div>
		   </div>
		 </div>
	</div>
</form>
<iframe style="display: none;" id="target_id" name="target_id"></iframe>
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
    	debugger;
    	cruConfig.queryService = "MatItemSrv";
    	cruConfig.queryOp = "getPlanEdit";
		cruConfig.submitStr ="planInvoiceId="+planInvoiceId;
		queryData(1);
		showTitle(planInvoiceId);
		document.getElementById("team").src = "<%=contextPath%>/mat/singleproject/plansub/teamList.jsp?planInvoiceId="+planInvoiceId;
	}
    function showTitle(value){
    	var retObj = jcdpCallService("MatItemSrv", "getplan", "laborId="+value);
    	document.getElementById("plan_invoice_id").value = value;
    	document.getElementById("submite_number").value = retObj.matInfo.submiteNumber;
    	document.getElementById("creator_id").value = retObj.matInfo.userName;
    	document.getElementById("project_name").value = retObj.matInfo.projectName;
    	document.getElementById("org_id").value = retObj.matInfo.orgName;
    	document.getElementById("creator_date").value = retObj.matInfo.compileDate;
    	document.getElementById("total_money").value = retObj.matInfo.totalMoney;
    	document.getElementById("main_part").value = retObj.matInfo.mainPart;
    	document.getElementById("memo").value = retObj.matInfo.memo;
        }
    
    function loadDataDetail(shuaId){
		var tab =document.getElementById("queryRetTable");
		var outNum=0;
		var wzPrice=0;
		var totalMoney=0;
		var row = tab.rows;
		var obj = event.srcElement;
		var flag = true;
		debugger;
		for(var i=1;i<row.length;i++){
			var cell_3 = row[i].cells[3].innerHTML;
			var cell_4 = row[i].cells[4].innerHTML;
			var cell_5 = row[i].cells[5].innerHTML;
			var cell_7 = row[i].cells[7].firstChild.value;
			var cell_6 = row[i].cells[6].innerHTML;
			if(cell_7!=undefined){
				
					if(cell_3=="&nbsp;"){
						cell_3=0;
						}
					if(cell_4=='&nbsp;'){
						cell_4=0;
						}
					if(cell_5=="&nbsp;"){
						cell_5=0;
						}
					if(cell_7==""){
						cell_7=0;
						}
					if(cell_6=="&nbsp;"){
						cell_6 = 0;
					}
					
					if(Number(cell_7)>Number(cell_3)||Number(cell_7)>Number(cell_6)){
						alert("请确认填写的调剂数量，不能大于需求数量和库存量!");
						flag = false;
						return;
					}
					
				row[i].cells[8].firstChild.value=Math.round((cell_3-cell_5-cell_7)*1000)/1000;
				if(parseInt(row[i].cells[8].firstChild.value)<0){
					row[i].cells[8].firstChild.value=0;
					}
				row[i].cells[9].innerHTML = Math.round((cell_4*(row[i].cells[8].firstChild.value))*1000)/1000;
				totalMoney += Math.round((cell_4*(row[i].cells[8].firstChild.value))*1000)/1000;
			}
		}
		document.getElementById("total_money").value = Math.round(totalMoney*1000)/1000;
		return flag;
	}
    
	
	function submitInfo(oprinfo){
		var oprstate;
		debugger;
		if(oprinfo==1){
			oprstate = "pass";
		}else{
			oprstate = "notPass";
		}
		ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
		if(loadDataDetail()){
			document.getElementById("isPass").value=oprstate;
			document.getElementById("laborId").value = ids;
			document.getElementById("form1").action = "<%=contextPath%>/mat/singleproject/plan/toSaveMatAllAddAppAuditInfowfpa.srq?oprstate="+oprstate;
			document.getElementById("form1").submit();
			document.getElementById("submitButton").onclick = "";
			window.setTimeout(function(){window.close();},2000);
		}
		//window.close();
	}
	
	function frameSize(){
		setTabBoxHeight();
	}
	frameSize();
	
	
	function setTabBoxHeight(){
		if(lashened==0){
			$("#table_box").css("height",$(window).height()*0.76);
		}
		//$("#tab_box .tab_box_content").css("height",$(window).height()-$("#table_box").height()-$("#tag-container_3").height()-10);
		$("#tab_box .tab_box_content").each(function(){
			if($(this).children('iframe').length > 0){
				$(this).css('overflow-y','hidden');
			}
		});
	}
</script>
</html>