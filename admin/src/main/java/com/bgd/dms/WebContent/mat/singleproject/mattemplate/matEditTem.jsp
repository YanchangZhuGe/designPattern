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
	String projectType = user.getProjectType();
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
<body onload='refreshData()'class="odd_odd">
<form name="form1" id="form1" method="post" action="">
	<input type='hidden' name='code_id' id='code_id' value='1'/>
	<input type='hidden' name='laborId' id='laborId' value=''/>
<input name='tamplate_id' id='tamplate_id'  type='hidden' value='<gms:msg msgTag="matInfo" key="tamplate_id"/>'readonly/>
<table border="0" cellpadding="0" cellspacing="0"
	class="tab_line_height" width="100%">
						 <tr>
					    	<td class="ali_cdn_input">模板名称 ：</td>
					    	<td class="ali_cdn_input"><input name='tamplate_name' id='tamplate_name'  type='text' value=''/></td>
						  </tr>
						  <tr>
						  <td class="ali_cdn_input">模板类型：</td>
						  <td><input type='radio' name='tamplate_type' value='0' onclick='checkdiv(0)' checked="checked" disabled/>班组模板</td>
						  <td><input type='radio' name='tamplate_type' value='1' onclick='checkdiv(1)' disabled/>设备模板</td>
						  </tr>
</table>
<div style="display:" id="iDBody1">
<table>
	<tr>
		<td class="ali_cdn_input">
			使用班组：
		</td>
		<td class="ali_cdn_input"><select class="select_width" id="s_apply_team" name="s_apply_team" disabled></select></td>
	</tr>
</table>
</div> 
<div style="display:none" id="iDBody2">
<table>
	<tr>
		<td class="ali_cdn_input">
			设备名称：
		</td>
		<td class="ali_cdn_input">
			<input type='text' name='devicename' id='devicename' disabled>
		</td>
	</tr>
</table>
</div> 
<table >
	<tr>
		<td class="ali_cdn_input">
			通用模板：
		</td>
		<td class="ali_cdn_input">
		<select class="select_width" id="loacked_if" name="loacked_if" disabled>
		<option value='0'>是</option>
		<option value='1'>否</option>
		</select>
		</td>
	</tr>
</table>
<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
			    <td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    </td>
			    <td><auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton></td>
			    <td></td>
			    <td></td>
			    <td></td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			 </tr>
			</table>
			</div>
<div id="list_table">
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right" id="queryRetTable">
			<tr>
				<td class="bt_info_odd" exp="<input name = 'rdo_entity_id'  type='checkbox' checked='true' value='{wz_id}' onclick='loadDataDetail()'/>" ><input type='checkbox' name='rdo_entity_id' value='' onclick='check()'/></td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			       <td class="bt_info_odd" exp="{wz_id}">物资编码</td>
			      <td class="bt_info_even" exp="{coding_code_id}">物资分类码</td>
			      <td class="bt_info_odd" exp="{wz_id}">物资编码</td>
			       <td class="bt_info_odd" exp="{coding_code_id}">物资分类码</td>
			      <td class="bt_info_even" exp="{wz_name}">名称</td>
			      <td class="bt_info_odd" exp="{wz_prickie}">单位</td>
			      <td class="bt_info_even" exp="{wz_price}" >单价</td>
			      <td class="bt_info_odd" exp="<input name ='unit_num{wz_id}' type='text' value='{unit_num}'/>" >单元用量</td>
			      <td class="bt_info_odd" exp="{note}">备注</td>
			</tr>
		</table>
	</div>
	<table id="fenye_box_table">
	</table>
	
</div>
<div id="oper_div">
<table width="100%" border="0" cellspacing="0" cellpadding="0"   >
<tr>
 
  <td background="<%=contextPath%>/images/list_15.png" >
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr align="center">
<td>
<span class="bc_btn"><a href="#"onclick="save()"></a></span> 
<span class="gb_btn"><a href="#"onclick="newClose()"></a></span>
</td>
</tr>
</table>
</td>
</tr>
</table>
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
<script type="text/javascript">
	
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	var tamplateId='';
	function refreshData(value){
		
		var sql ='';
		tamplateId += "<gms:msg msgTag="matInfo" key="tamplate_id"/>";
		//sql +="select i.* from gms_mat_demand_tamplate_detail t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag='0' where t.tamplate_id = '"+tamplateId+"' and t.bsflag='0'";
		cruConfig.queryService = "MatItemSrv";
		cruConfig.queryOp = "getPlanLeaf";
		cruConfig.submitStr ="value="+tamplateId;
		queryData(1);
		document.getElementById("tamplate_name").value="<gms:msg msgTag="matInfo" key="tamplate_name"/>";
		document.getElementById("loacked_if").value="<gms:msg msgTag="matInfo" key="loacked_if"/>";
		var tamplateType= "<gms:msg msgTag="matInfo" key="tamplate_type"/>";
		var val = document.getElementsByName("tamplate_type");
		for(i=0;i<val.length;i++){
			if(val[i].value==tamplateType){
				val[i].checked = true;
				checkdiv(val[i].value);
				}
			}
		if(tamplateType=="0"){
			var obj = "<gms:msg msgTag="matInfo" key="coding_code_id"/>";
		    getApplyTeam(obj);
			}
		else{
			document.getElementById("devicename").value="<gms:msg msgTag="matInfo" key="device_name"/>";
			}
	}							
	function save(){	
		//if (!checkForm()) return;
		ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				alert("请选择一条记录!");
				return;
			}
			else{
				openMask();
				document.getElementById("laborId").value = ids;
				document.getElementById("form1").action="<%=contextPath%>/mat/singleproject/mattemplate/saveMatTem.srq";
				document.getElementById("form1").submit();
			}
	}
	function toDelete(){
		 ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				alert("请选择一条记录!");
				return;
			}
			else{
			if(confirm('确定要删除吗?')){  
				var retObj = jcdpCallService("MatItemSrv", "deleteTemList", "matId="+ids);
				queryData(cruConfig.currentPage);
			}
			}
	}
	
	function checkdiv(value){
		if(value==1){
			 document.getElementById('iDBody1').style.display = "none";
		     document.getElementById('iDBody2').style.display = "";
		    
		}
		}
	 function getApplyTeam(val){
	    	var selectObj = document.getElementById("s_apply_team"); 
	    	document.getElementById("s_apply_team").innerHTML="";

//	    	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeam","");
	    	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeamP","projectType=<%=projectType%>");
	    	for(var i=0;i<applyTeamList.detailInfo.length;i++){
	    		var templateMap = applyTeamList.detailInfo[i];
	    		if(templateMap.value == val){
					selectObj.add(new Option(templateMap.label,templateMap.value),0);
					}
	    		else{
					selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	    		}
	    	}   	
	    	selectObj.options[0].selected='selected';
	    }
	 function toAdd(trid){
			var obj = new Object();
			var ids=getSelIds('rdo_entity_id');
			var vReturnValue = window.showModalDialog('<%=contextPath%>/mat/select/template/selectMatList.jsp?ids='+ids+'&tamplateId='+tamplateId,obj,'dialogWidth=1024px;dialogHigth=400px');
			if(vReturnValue!=undefined){
				queryData(cruConfig.currentPage);
				
				}
		}
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
		 function openMask(){
				$( "#dialog-modal" ).dialog({
					height: 140,
					modal: true,
					draggable: false
				});
			}
</script>
</html>