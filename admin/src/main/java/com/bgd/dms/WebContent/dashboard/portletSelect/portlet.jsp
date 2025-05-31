<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();

	String creatorId = request.getParameter("creatorId");
	String isUser = request.getParameter("isUser");
	
	boolean isSuperadmin=false;

	if(isUser.equals("1")){
		UserToken user = OMSMVCUtil.getUserToken(request);
	
		if(user.getRoleIds().indexOf("INIT_AUTH_ROLE_012345678000000")>=0) isSuperadmin = true;
	}
	
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	/*String role_id = request.getParameter("id");
	if(role_id==null){
		role_id ="";
	}*/
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
			document.getElementById("portlet_id").value = "";
			document.getElementById("portlet_name").value = "";
		}
		else{
			checked = true;
		}
	}
</script>
<title>列表页面</title>
</head>
<body style="background:#fff" >
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="ali_cdn_name" align="right">Portlet级别:</td>
							<td class="ali_cdn_input" align="left"><select id="level" name="level" onchange="changeLevel();" class="select_width">
									<option value="">请选择</option>
									<option value="1">公司级</option>
									<option value="2">物探处级</option>
									<option value="3">地震队级</option>
								</select></td>
							<td class="ali_cdn_name" align="right">Portlet名称:</td>
							<td class="ali_cdn_input" align="left"><input type="hidden" name="category_id" id="category_id" value=""/>
								<input type="hidden" name="category_name" id="category_name" class="input_width" value="" />
								<input type="text" name="name" id="name" class="input_width" value="" /></td>
							<auth:ListButton functionId="" css="cx" event="onclick='changeLevel()'" title="JCDP_btn_submit"></auth:ListButton>
				    		<auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_submit"></auth:ListButton>
						 	<td>&nbsp;</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>
			  <td class="bt_info_odd" autoOrder="1">序号</td> 
			  <td class="bt_info_even" exp="<input type='hidden' name='' value='{portlet_id}:{portlet_name}:{portlet_url}'/>{portlet_name}">Portlet名称</td>
			  <td class="bt_info_odd" exp="{portlet_level}">Portlet级别</td>
			  
			</tr>
		</table>
	</div> 
	<div id="fenye_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
		  <tr>
		    <td align="right">第1/1页，共0条记录</td>
		    <td width="10">&nbsp;</td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_01.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_02.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_03.png" width="20" height="20" /></td>
		    <td width="30"><img src="<%=contextPath %>/images/fenye_04.png" width="20" height="20" /></td>
		    <td width="50">到 
		      <label>
		        <input type="text" name="changePage" id="changePage" style="width:20px;" />
		      </label></td>
		    <td align="left"><img src="<%=contextPath %>/images/fenye_go.png" width="22" height="22" onclick="changePage()"/></td>
		  </tr>
		</table>
	</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	function clearQueryText(){
		document.getElementById("name").value = "";
		document.getElementById("level").options[0].selected =true;
		changeLevel();
	}
	function changeLevel(){
		var category_id = document.getElementById("category_id").value ;
		var category_name = document.getElementById("category_name").value ;
		refreshData(category_id ,category_name );
	}
 
	function refreshData(category_id ,category_name ){ 
		cruConfig.cdtType = 'form';
		if(category_id==null || category_id==''){
			alert("请选择portlet分类!");
			return;
		}else{
			if(category_id==null || category_id ==''){
				category_id = document.getElementById("category_id").value;
				category_name = document.getElementById("category_name").value;
			}
			document.getElementById("category_id").value = category_id;
			document.getElementById("category_name").value = category_name;
			var category_ids = "";
			var retObj = jcdpCallService("PortletSrv", "getCategoryIds", "category_id="+category_id);
			if(retObj!=null && retObj.returnCode =='0'){
				category_ids = retObj.category_ids;
			}
			if(category_ids==null || category_ids ==''){
				return ;
			}
			var name = document.getElementById("name").value;
			var portlet_level= document.getElementById("level").value;

			var queryStr = "";
//alert(category_ids +"============"+category_ids+"======="+name +"============"+name+"======="+portlet_level +"============"+portlet_level);
			<%if("1".equals(isUser)){%>
				queryStr = "select distinct t.portlet_id ,t.category_id ,t.portlet_name ,t.portlet_url ,"+
				" decode(t.portlet_level,'1','公司级','2','物探处级','3','项目级') portlet_level ,t.portlet_desc "+
				" from bgp_comm_portlet_dms t join p_auth_role_portlet_dms t1 on t.portlet_id=t1.portlet_id join p_auth_user_role t2 on t2.role_id=t1.role_id where t.category_id in("+category_ids+") and t.portlet_level like '"+portlet_level+"%'"+
				" and t.portlet_name like '%"+name+"%'";
				<%
				if(!isSuperadmin){
				%>
				queryStr += " and t2.user_id='<%=creatorId%>'";
				<%}%>
			<%}else{%>
				queryStr = "select distinct t.portlet_id ,t.category_id ,t.portlet_name ,t.portlet_url ,"+
				" decode(t.portlet_level,'1','公司级','2','物探处级','3','项目级') portlet_level ,t.portlet_desc "+
				" from bgp_comm_portlet_dms t join p_auth_role_portlet_dms t1 on t.portlet_id=t1.portlet_id and t1.role_id='<%=creatorId%>' where t.category_id in("+category_ids+") and t.portlet_level like '"+portlet_level+"%'"+
				" and t.portlet_name like '%"+name+"%'";
			<%}%>
			cruConfig.queryStr = queryStr;
		}
		//cruConfig.currentPageUrl = "<%=contextPath%>/market/crm/information/informationList.jsp";
		queryData(1);
		dClick();
	}
	function dClick(){
		var obj = document.getElementById("queryRetTable");
		for(var i = 1;i<obj.rows.length;i++){
			var tr = obj.rows[i];
			tr.ondblclick = function(){
				dbClick();
			}
		}
	}
	/* 详细信息 */
	function dbClick(){
		var obj = event.srcElement;  
    	if(obj.tagName.toLowerCase() == "td"){ 
    		var tr = obj.parentNode ;
    		var portlet = tr.cells[1].firstChild.value.split(":");
    		var portlet_id = portlet[0];
    		var portlet_name = portlet[1];
    		var portlet_url = portlet[2];
    		//top.frames['list'].setContent(portlet_id, portlet_name, portlet_url);
    		top.dialogCallback('setContent',[portlet_id, portlet_name, portlet_url]);
    		newClose();
    	}
	}
	
	function frameSize(){
		$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-7);
	}
	frameSize();
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	})	

</script>

</body>
</html>
