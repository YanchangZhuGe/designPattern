<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String isProject = request.getParameter("isProject");
	if(isProject==null||isProject.equals("")){
		isProject = resultMsg.getValue("isProject");
	}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/hse/js/hseCommon.js"></script>
<title>无标题文档</title>
<style type="text/css">
.ali_cdn_input{
	width: 180px;
	text-align: left; 
}

.ali_cdn_input input{
	width: 80%;
}

</style>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			<input type="hidden" id="hse_check_id" name="hse_check_id" value=""></input>
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">观察人</td>
			    <td class="ali_cdn_input">
			    <input id="Name" name="Name" type="text" />
			    </td>
 				<td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>

			    <td>&nbsp;</td>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="fz" event="onclick='toCopyAdd()'" title="复制并添加"></auth:ListButton>
			     <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="" css="bb" event="onclick='toTj()'" title="图表"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{hse_check_id}' id='rdo_entity_id_{hse_check_id}'  onclick='chooseOne(this);'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">基层单位</td>
			      <td class="bt_info_odd" exp="{fourth_org_name}">下属单位</td>
			      <td class="bt_info_even" exp="{check_date}">观察日期</td>
			      <td class="bt_info_odd" exp="{check_person}">观察人</td>
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
		  </div>
</body>

<script type="text/javascript">


	cruConfig.contextPath =  "<%=contextPath%>";
	// 复杂查询
	function refreshData(){
		var isProject = "<%=isProject%>";
		var querySqlAdd = "";
		if(isProject=="1"){
			querySqlAdd = getMultipleSql();
		}else if(isProject=="2"){
			querySqlAdd = "and t.project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select t.*,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name from  bgp_hse_safecheck  t left join comm_org_subjection os1 on t.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on oi1.org_id=os1.org_id and oi1.bsflag='0' left join comm_org_subjection os2 on t.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on oi2.org_id=os2.org_id and oi2.bsflag='0' left join comm_org_subjection os3 on t.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on oi3.org_id=os3.org_id and oi3.bsflag='0'  where t.bsflag='0' "+querySqlAdd+" order by t.modifi_date desc";
		cruConfig.currentPageUrl = "/hse/weekReport/week_list.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/weekReport/week_list.jsp";
		queryData(1);
	}
	
	
	// 简单查询
	function simpleSearch(){
			var Name = document.getElementById("Name").value;
			var isProject = "<%=isProject%>";
			var querySqlAdd = "";
			if(isProject=="1"){
				querySqlAdd = getMultipleSql();
			}else if(isProject=="2"){
				querySqlAdd = "and t.project_info_no='<%=user.getProjectInfoNo()%>'";
			}
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = "select t.*,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,oi3.org_abbreviation as fourth_org_name from  bgp_hse_safecheck  t left join comm_org_subjection os1 on t.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on oi1.org_id=os1.org_id and oi1.bsflag='0' left join comm_org_subjection os2 on t.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on oi2.org_id=os2.org_id and oi2.bsflag='0' left join comm_org_subjection os3 on t.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on oi3.org_id=os3.org_id and oi3.bsflag='0' where t.bsflag='0' "+querySqlAdd+" and t.check_person like '%"+Name+"%' order by t.modifi_date desc"
			cruConfig.currentPageUrl = "/hse/weekReport/week_list.jsp";
			queryData(1);
	}
	
	function clearQueryText(){
		document.getElementById("Name").value = "";
	}
	
	
	function loadDataDetail(shuaId){
		
		var retObj;
		if(shuaId!=null){
			 document.getElementById("hse_check_id").value= shuaId;
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    document.getElementById("hse_check_id").value= ids;
		}
	}
	
	function dbclickRow(shuaId){
		var retObj;
		if(shuaId!=null){
			popWindow("<%=contextPath%>/hse/leaderAndPromise/safeCheck/addCheck.jsp?action=view&isProject=<%=isProject%>&hse_check_id="+shuaId,"1300:800");
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    popWindow("<%=contextPath%>/hse/leaderAndPromise/safeCheck/addCheck.jsp?action=view&isProject=<%=isProject%>&hse_check_id="+ids,"1300:800");
		}
	}

	
	function toAdd(){
		popWindow("<%=contextPath%>/hse/leaderAndPromise/safeCheck/addCheck.jsp?action=add&isProject=<%=isProject%>","1300:800");
	}
	
	function toEdit(){
		var hse_check_id = document.getElementById("hse_check_id").value;
		if(hse_check_id==""||hse_check_id==null){
			alert("请先选中一条记录！");
			return;
		}
		popWindow("<%=contextPath%>/hse/leaderAndPromise/safeCheck/addCheck.jsp?action=edit&isProject=<%=isProject%>&hse_check_id="+hse_check_id,"1300:800");
	}
	
	function toCopyAdd(){
		var hse_check_id = document.getElementById("hse_check_id").value;
		if(hse_check_id==""||hse_check_id==null){
			alert("请先选中一条记录！");
			return;
		}
		window.location="<%=contextPath%>/hse/check/addAndCopySafeCheck.srq?isProject=<%=isProject%>&hse_check_id="+hse_check_id;
	}
	
	
	function toTj(){
		popWindow("<%=contextPath%>/hse/leaderAndPromise/safeCheck/selectCharts.jsp");
	}
	
	function toDelete(){
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("HseSrv", "deleteCheck", "hse_check_id="+ids);
			queryData(cruConfig.currentPage);
		}
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/leaderAndPromise/safeCheck/check_search.jsp?isProject=<%=isProject%>");
	}
	
	function fridaySelector(inputField,tributton)
	{    
	    Calendar.setup({
	        inputField     :    inputField,   // id of the input field
	        ifFormat       :    "%Y-%m-%d",       // format of the input field
	        align          :    "Br",
			button         :    tributton,
	        onUpdate       :    null,
	        weekNumbers    :    true,
			singleClick    :    true,
			step        : 1,
			disableFunc: function(date) {
		        if (date.getDay() != 5) {
		            return true;
		        } else {
		            return false;
		        }
		    }
		    });
	}
	
</script>

</html>

