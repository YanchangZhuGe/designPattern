<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>物资汇总编辑管理</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
</head>
<body onload="refreshData()" style="background: #fff">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" align="center">
		<div id="new_table_box_content"> 
			<div id="new_table_box_bg">
				<fieldset>
				<input type='hidden' name='plan_invoice_id' id='plan_invoice_id'value=''>
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
			</table>
			</fieldset>
			<fieldset>
			<div id="tag-container_3">
			<ul id="tags" class="tags">
				<li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">汇总信息</a></li>
				<li  id="tag3_1"><a href="#" onclick="getTab3(1)">明细信息</a></li>
			</ul>
			</div>
			<div id="tab_box_content0" class="tab_box_content">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
						    <tr>
						      <td class="bt_info_odd" exp="<input name = 'plan_id_{plan_id}' id='rdo_entity_id' checked='checked'type='checkbox' value='{plan_id}' onclick='loadDataDetail()'/>"><input type='checkbox' name='task_entity_id' value='' onclick='check()'/></td>
						      <td class="bt_info_even" autoOrder="1">序号</td>
						      <td class="bt_info_odd" exp="{wz_name}">资源名称</td>
						      <td class="bt_info_even" exp="{demand_num}">需求数量</td>
						      <td class="bt_info_odd" exp="{wz_price}">参考单价</td>
						      <td class="bt_info_even" exp="{have_num}">现有数量</td>
						      <td class="bt_info_odd" exp="{regulate_num}">可调剂数量</td>
						      <td class="bt_info_even" exp="{apply_num}">合计申请量</td>
						      <td class="bt_info_odd" exp="{plan_money}">计划金额</td>
						      <td class="bt_info_even" exp="{description}">物资说明</td>
						      <td class="bt_info_odd" exp="{code_name}">物资类别</td>
						    </tr>
						  </table>
						<table  id="fenye_box_table">
						</table>
					</div>
		<div id="tab_box_content1" class="tab_box_content" style="display: none; overflow: hidden;">
		<iframe width="100%" height="100%" name="team" id="team" frameborder="0" marginheight="0" marginwidth="0" >
		</iframe>
		</div>
		</fieldset>
		</div>
	</div>
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
        }
	function save(){	
		ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
	    document.getElementById("form1").action = "<%=contextPath%>/mat/multiproject/matapprove/updateApprove.srq?laborId="+ids;
		document.getElementById("form1").submit();
	}
	function frameSize(){
		setTabBoxHeight();
	}
	frameSize();
</script>
</html>