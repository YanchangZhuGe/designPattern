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
			      <td class="bt_info_odd" exp="<input name = 'plan_id_{wz_id}' id='rdo_entity_id' checked='checked'type='checkbox' value='{wz_id}' onclick='loadDataDetail()'/>"><input type='checkbox' name='task_entity_id' value='' onclick='check()'/></td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{wz_name}">资源名称</td>
			      <td class="bt_info_even" exp="{wz_id}">物资编码</td>
			      <td class="bt_info_odd" exp="{coding_code_id}">物资分类码</td>
			      <td class="bt_info_even" exp="{wz_prickie}">单位</td>
			      <td class="bt_info_odd" exp="{wz_price}">参考单价</td>
			      <td class="bt_info_even" exp="{demand_num}">申请数量</td>
			    </tr>
			  </table>
			</div>
			<table  id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="/gms4/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="/gms4/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="/gms4/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="/gms4/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="/gms4/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			
			</table>
    <div id="oper_div">
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
    var submiteNumber = getQueryString("submiteNumber");
    function refreshData(){
		var sql ='';
		sql += "select i.wz_name,i.wz_id,i.wz_prickie,i.wz_price,i.coding_code_id,t.demand_num from gms_mat_demand_plan_detail t inner join gms_mat_infomation i on t.wz_id= i.wz_id and i.bsflag='0' where t.submite_number='"+submiteNumber+"'";
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/multiproject/matapprove/planContral.jsp";
		queryData(1);
		showTitle(submiteNumber);
	}
    function showTitle(value){
    	var retObj = jcdpCallService("MatItemSrv", "getplanPru", "laborId="+value);
    	document.getElementById("plan_invoice_id").value = retObj.matInfo.submiteNumber;
    	document.getElementById("creator_id").value = retObj.matInfo.userName;
    	document.getElementById("project_name").value = retObj.matInfo.projectName;
    	document.getElementById("org_id").value = retObj.matInfo.orgName;
    	document.getElementById("creator_date").value = retObj.matInfo.createDate;
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