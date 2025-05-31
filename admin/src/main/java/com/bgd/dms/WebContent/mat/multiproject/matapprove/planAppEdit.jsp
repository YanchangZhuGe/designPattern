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
<title>物资汇总编辑管理</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
</head>
<body onload="refreshData()" class="odd_odd">
<form name="form1" id="form1" method="post" action="">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">

  	<tr>
    	<td colspan="4" align="center">送审计划审批</td>
    </tr>
    <tr>
    	<td class="inquire_item4">项目名称：</td>
      	<td class="inquire_form4"><input type="text" name="project_name" id="project_name" class="input_width" value="" readonly/></td>
    	<td class="inquire_item4">申请单号：</td>
      	<td class="inquire_form4"><input type="text" name="plan_invoice_id" id="plan_invoice_id" class="input_width" value="" readonly/></td>
      
    </tr>
      <tr>
    	<td class="inquire_item4">队伍：</td>
      	<td class="inquire_form4"><input type="text" name="org_id" id="org_id" class="input_width" value="" readonly/></td>
      	<td class="inquire_item4">创建人：</td>
      	<td class="inquire_form4"><input type="text" name="creator_id" id="creator_id" class="input_width" value="" readonly/></td>
    </tr>
     <tr>
      	<td class="inquire_item4">审批：</td>
      	<td class="inquire_form4"><select name = 'submite_if' id = 'submite_if' class="select_width">
      									<option value=''>请选择</option>
      									<option value='4'>未通过</option>
      									<option value='5'>通过</option>
      							  </select>
      	</td>
      	<td class="inquire_item4">创建时间：</td>
      	<td class="inquire_form4"><input type="text" name="creator_date" id="creator_date" class="input_width" value="" readonly/></td>
    </tr>
</table>
<div id="inq_tool_box">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="6"><img src="<%=contextPath%>/images/list_13.png"
			width="6" height="36" /></td>
		<td background="<%=contextPath%>/images/list_15.png">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td  align="left">汇总信息</td>
			</tr>
		</table>
		</td>
		<td width="4"><img src="<%=contextPath%>/images/list_17.png"
			width="4" height="36" /></td>
	</tr>
</table>
</div>
<div id="table_box" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input name = 'plan_id_{plan_id}' id='rdo_entity_id' checked='checked'type='checkbox' value='{plan_id}' onclick='loadDataDetail()'/>"><input type='checkbox' name='task_entity_id' value='' onclick='check()'/></td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{wz_name}">资源名称</td>
			      <td class="bt_info_even" exp="{demand_num}">需求数量</td>
			      <td class="bt_info_odd" exp="{wz_prickie}">参考单价</td>
			      <td class="bt_info_even" exp="{have_num}">现有数量</td>
			      <td class="bt_info_odd" exp="{regulate_num}">可调剂数量</td>
			      <td class="bt_info_even" exp="{description}">物资说明</td>
			      <td class="bt_info_odd" exp="{code_name}">物资类别</td>
			    </tr>
			  </table>
			</div>
			<table  id="fenye_box_table">
			</table>
    <div id="oper_div">
     	<span class="bc_btn"><a href="#" onclick="save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</form>
</body>

<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
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
		var sql ='';
		sql += "select t.demand_num,t.plan_id,t.have_num,t.regulate_num,t.apply_num,t.plan_money,m.wz_name,m.wz_prickie,m.wz_price,c.code_desc,c.code_name from GMS_MAT_DEMAND_PLAN t inner join gms_mat_infomation m on t.wz_id = m.wz_id and t.bsflag='0'and m.bsflag='0'inner join gms_mat_coding_code c on m.coding_code_id=c.coding_code_id and c.bsflag='0' and plan_invoice_id ='"+planInvoiceId+"' and t.regulate_num>0";
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/plansub/planSubEdit.jsp";
		queryData(1);
		showTitle(planInvoiceId);
	}
    function showTitle(value){
    	var retObj = jcdpCallService("MatItemSrv", "getplan", "laborId="+value);
    	document.getElementById("plan_invoice_id").value = retObj.matInfo.planInvoiceId;
    	document.getElementById("creator_id").value = retObj.matInfo.userName;
    	document.getElementById("project_name").value = retObj.matInfo.projectName;
    	document.getElementById("org_id").value = retObj.matInfo.orgName;
    	document.getElementById("creator_date").value = retObj.matInfo.compileDate;
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
	
</script>
</html>