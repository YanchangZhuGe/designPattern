<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_id = user.getOrgSubjectionId();
	String user_id = user.getUserId();

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
			<input type="hidden" id="hse_model_id" name="hse_model_id" value=""></input>
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">模板名称</td>
			    <td class="ali_cdn_input">
			    <input id="modelName" name="modelName" type="text"/>
			    </td>
 				<td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>

			    <td>&nbsp;</td>
			     <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{hse_model_id}' id='rdo_entity_id_{hse_model_id}'  onclick='chooseOne(this);'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{model_name}">模板名称</td>
			      <td class="bt_info_even" exp="{user_name}">创建人</td>
			      <td class="bt_info_odd" exp="{create_date}">创建时间</td>
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
		
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select m.hse_model_id,m.model_name,m.creator_id,u.user_name,m.create_date from bgp_hse_assess_model m join p_auth_user u on m.creator_id=u.user_id and u.bsflag='0' where m.bsflag='0' order by m.modifi_date desc"
		cruConfig.currentPageUrl = "/hse/objAndTarget/hseAssess/model_list.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/objAndTarget/hseAssess/model_list.jsp";
		queryData(1);
	}
	
	
	// 简单查询
	function simpleSearch(){
			var modelName = document.getElementById("modelName").value;
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = "select m.hse_model_id,m.model_name,m.creator_id,u.user_name,m.create_date from bgp_hse_assess_model m join p_auth_user u on m.creator_id=u.user_id and u.bsflag='0' where m.bsflag='0' and m.model_name like '%"+modelName+"%' order by m.modifi_date desc"
			cruConfig.currentPageUrl = "/hse/objAndTarget/hseAssess/model_list.jsp";
			queryData(1);
	}
	
	function clearQueryText(){
		document.getElementById("modelName").value = "";
	}
	
	
	function loadDataDetail(shuaId){
		
		var retObj;
		if(shuaId!=null){
			 document.getElementById("hse_model_id").value= shuaId;
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    document.getElementById("hse_model_id").value= ids;
		}
	}
	
	function dbclickRow(shuaId){
		var retObj;
		if(shuaId!=null){
			popWindow("<%=contextPath%>/hse/objAndTarget/hseAssess/addModel.jsp?action=view&&hse_model_id="+shuaId);
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    popWindow("<%=contextPath%>/hse/objAndTarget/hseAssess/addModel.jsp?action=view&&hse_model_id="+ids);
		}
	}
	
	function toAdd(){
		popWindow("<%=contextPath%>/hse/objAndTarget/hseAssess/addModel.jsp?action=add");
	}
	
	function toEdit(){
		var hse_model_id = document.getElementById("hse_model_id").value;
		if(hse_model_id==""||hse_model_id==null){
			alert("请先选中一条记录！");
			return;
		}
		popWindow("<%=contextPath%>/hse/objAndTarget/hseAssess/addModel.jsp?action=edit&&hse_model_id="+hse_model_id);
	}
	
	function toDelete(){
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("HseSrv", "deleteModel", "hse_model_id="+ids);
			queryData(cruConfig.currentPage);
		}
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/objAndTarget/hseAssess/model_search.jsp");
	}
	
</script>

</html>

