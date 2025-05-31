<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String company_id = request.getParameter("company_id");
	if(company_id==null){
		company_id = "";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<style type="text/css" >
</style>
<script type="text/javascript" >
	var checked = false;
	function check(){
		var chk = document.getElementsByName("chk_entity_id");
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
</script>
<title>列表页面</title>
</head>
<body style="background:#fff;overflow-y: auto" >
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						 	<td>&nbsp;</td>
						    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
						    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
						    <auth:ListButton functionId="" css="sc" event="onclick='toDel()'" title="JCDP_btn_delete"></auth:ListButton>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>
			  <td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{bid_id}' onclick=check(this)/>" >
			  	<input type='checkbox' name='chk_entity_id' value='' onclick='check(this)'/></td>
			  <td class="bt_info_even" autoOrder="1">序号</td> 
			  <td class="bt_info_odd" exp="{bid_name}">招投标内容</td>
			  <td class="bt_info_even" exp="{bid_date}">投标时间</td>
			  <td class="bt_info_odd" exp="{org_name}">招标方</td>
			  <!-- <td class="bt_info_even" exp="{project_info_no}">项目名称</td> -->
			</tr>
		</table>
	</div> 
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	function refreshData(){
		var company_id = '<%=company_id%>';
		cruConfig.pageSize = cruConfig.pageSizeMax;
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select t.bid_id ,t.bid_name ,t.bid_date ,t.bid_type ,t.bid_result ,t.company_id ,p.company_short_name company_name ,"+
		" t.org_id ,inf.org_abbreviation org_name ,t.workload ,t.reason ,t.project_info_no from bgp_market_bid t" +
		" join comm_org_information inf on t.org_id = inf.org_id and inf.bsflag='0' "+
    	" left join bgp_market_oil_company p on t.company_id = p.company_id and p.bsflag='0' where t.bsflag = '0' and t.company_id = '<%=company_id%>'";
		cruConfig.currentPageUrl = "<%=contextPath%>/market/crm/clientInformation/bidList.jsp";
		queryData(1);
		resizeNewTitleTable();
	}
	refreshData();
	/* 详细信息 */
	function loadDataDetail(id){
		var obj = event.srcElement; 
    	if(obj.tagName.toLowerCase() == "td"){   
    		var   tr   =  obj.parentNode ;
    		tr.cells[0].firstChild.checked = true;
    	} 
	}
	function toAdd() { 
		var company_id ='<%=company_id%>';
		if(company_id==null || company_id==''){
			alert("选择油公司");
			return;
		}
		popWindow("<%=contextPath%>/market/crm/clientInformation/bidEdit.jsp?company_id="+company_id);
	}
	function toEdit() {
		var company_id ='<%=company_id%>';
		if(company_id==null || company_id==''){
			alert("选择油公司");
			return;
		}
		var obj = document.getElementsByName("chk_entity_id");
		for(var i=1;i<obj.length;i++){
			if(obj[i].checked ==true){
				var bid_id = obj[i].value;
				var text = '你确定要修改第'+i+'行吗?';
				if(bid_id!=null && window.confirm(text)){
					popWindow("<%=contextPath%>/market/crm/clientInformation/bidEdit.jsp?bid_id="+bid_id+"&company_id="+company_id);
					return;
				}
			}
		}
		alert("请选择修改的记录!");
	}
	function toDel() {
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var bid_id = '';
		var substr = '';
		for (var i = objLen-1;i > 0;i--){  
			if (obj [i].checked == true) { 
				bid_id=obj [i].value;
				if(window.confirm('你确定要删除第'+i+'行吗?')){
					substr = substr + "update bgp_market_bid t set t.bsflag ='1' where t.bid_id ='"+bid_id+"';" 
				}
			}   
		} 
		if(substr!=''){
			var retObj = jcdpCallService("ClientRelationSrv", "saveClientRelation", "sql="+substr);
			if(retObj.returnCode =='0'){
				alert("删除成功!");
				refreshData();
				return;
			}
		}
		alert("请选择删除的记录!");
	}
	function renderNaviTable(tbObj,tbCfg){
	}
</script>

</body>
</html>
