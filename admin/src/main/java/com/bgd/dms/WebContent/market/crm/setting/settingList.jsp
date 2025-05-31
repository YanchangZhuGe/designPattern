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
<body style="background:#fff" >
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath %>/images/list_15.png">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="ali_cdn_name" align="right">上级节点:</td>
							<td class="ali_cdn_input" align="left"><span id="name"></span></td>
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
			  <td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{type_id}' onclick=check(this)/>" >
			  	<input type='checkbox' name='chk_entity_id' value='' onclick='check(this)'/></td>
			  <td class="bt_info_even" autoOrder="1">序号</td> 
			  <td class="bt_info_odd" exp="{type_name}">类别名称</td>
			  <td class="bt_info_even" exp="{type_short_name}">类别简称</td>
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
	<div class="lashen" id="line"></div>
	<div id="tag-container_3" >
      <ul id="tags" class="tags">
        <li class="selectTag"><a href="#" onclick="getTab(this,1)">常用</a></li>
      </ul>
    </div>
	<div id="tab_box" class="tab_box" style="overflow:hidden;">
		<div id="tab_box_content1" class="tab_box_content" >
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr align="right" >
			  	<td>&nbsp;</td>
			    <auth:ListButton functionId="" css="tj" event="onclick='newSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
			  </tr>
			</table>
			<form action="" id="form0" name="form0" method="post" target="record">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		    		<tr>
			     		<input type="hidden" name="type_id" id="type_id" value="" />
			     		<input type="hidden" name="parent_type_id" id="parent_type_id" value=""/>
			     		<input type="hidden" name="divisory_type" id="divisory_type" value=""/>
			     		<input type="hidden" name="user_id" id="user_id" value="<%=user.getUserId()%>"/>
				    	<td class="inquire_item6">上级节点:</td>
				    	<td class="inquire_form6"><input name="parent_type_name" id="parent_type_name" type="text" class="input_width" value="" disabled="disabled"/></td>
				    	<td class="inquire_item6"><font color="red">*</font>类别名称:</td>
				    	<td class="inquire_form6"><input name="type_name" id="type_name" type="text" class="input_width" value="" /></td>
				    	<td class="inquire_item6"><font color="red">*</font>类别简称:</td>
				    	<td class="inquire_form6"><input name="type_short_name" id="type_short_name" type="text" class="input_width" value="" /></td>
				    </tr>
				</table>
			</form> 
		</div>
	</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	function refresh(typeId ,typeName){
		refreshData(typeId ,typeName);
		var parent_type_id = document.getElementById("parent_type_id").value;
		parent.mainTopframe.refreshTree(parent_type_id);
	}
	function refreshData(typeId ,typeName ,divisory_type){
		document.getElementById("parent_type_id").value = typeId;
		document.getElementById("parent_type_name").value = typeName;
		document.getElementById("divisory_type").value = divisory_type;
		document.getElementById("name").innerHTML = typeName;
		cruConfig.cdtType = 'form';
		if(typeId!=null && typeId=='root'){
			cruConfig.queryStr = "select t.type_id ,t.type_name ,t.type_short_name from bgp_market_company_type t where t.bsflag='0' and (t.parent_type_id is null or t.parent_type_id='root') and t.divisory_type='"+divisory_type+"'";
		}
		if(typeId!=null && typeId!='root'){
			cruConfig.queryStr = "select t.type_id ,t.type_name ,t.type_short_name from bgp_market_company_type t where t.bsflag='0' and t.parent_type_id ='"+typeId+"' and t.divisory_type='"+divisory_type+"'";
		}
		
		cruConfig.currentPageUrl = "<%=contextPath%>/market/crm/setting/settingList.jsp";
		queryData(1);
		document.getElementById("type_id").value = '';
		document.getElementById("type_name").value = '';
		document.getElementById("type_short_name").value = '';
	}
	/* 详细信息 */
	function loadDataDetail(id){
		var obj = event.srcElement; 
    	if(obj.tagName.toLowerCase() == "td"){   
    		var   tr   =  obj.parentNode ;
    		tr.cells[0].firstChild.checked = true;
    	} 
    	var querySql = "select t.type_id ,t.type_name ,t.type_short_name from bgp_market_company_type t where t.bsflag='0' and t.type_id ='"+id+"' ";				 	 
    	retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj.returnCode=='0'){
			if(retObj.datas[0] != null){
				datas = retObj.datas[0];
				document.getElementById("type_id").value = id;
				document.getElementById("type_name").value = datas.type_name;
				document.getElementById("type_short_name").value = datas.type_short_name;
			}
		}
	}
	/* 修改 */
	function newSubmit() {
		if(checkValue() == false){
			return ;
		}
		var substr ='';
		var type_id = document.getElementById("type_id").value;
		var user_id = document.getElementById("user_id").value;
		var type_name = document.getElementById("type_name").value;
		var divisory_type = document.getElementById("divisory_type").value;
		var type_short_name = document.getElementById("type_short_name").value;
		if(type_id!=null && type_id!=''){
			substr = substr + "update bgp_market_company_type t set t.type_id ='"+type_id+"' ,t.updator_id='"+user_id+"' ," +
			" t.modifi_date = sysdate ,t.type_name ='"+type_name+"', t.type_short_name ='"+type_short_name+"' "+
			" where t.type_id ='"+type_id+"';" 
		}else{
			var parent_type_id = document.getElementById("parent_type_id").value;
			substr = substr + "insert into bgp_market_company_type(type_id ,type_name ,type_short_name ,parent_type_id ,divisory_type ,"+
			" bsflag ,create_date,creator_id ,modifi_date ,updator_id) "+
			" values((select lower(sys_guid()) from dual),'"+type_name+"' ,'"+type_short_name+"' ,'"+parent_type_id+"' ," +
			" '"+divisory_type+"','0' ,sysdate ,'"+user_id+"' ,sysdate ,'"+user_id+"');"
		}
		if(substr!=''){
			var retObj = jcdpCallService("ClientRelationSrv", "saveClientRelation", "sql="+substr);
			if(retObj.returnCode =='0'){
				alert("保存成功!");
				var parent_type_id = document.getElementById("parent_type_id").value;
				var parent_type_name = document.getElementById("parent_type_name").value;
				refreshData(parent_type_id,parent_type_name);
				parent.mainTopframe.refreshTree(parent_type_id);
			}
		}
	}
	function checkValue(){
		var obj = document.getElementById("type_name") ;
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("类别名称不能为空!");
			return false;
		}
		obj = document.getElementById("type_short_name") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("类别简称不能为空!");
			return false;
		}
	}
	var selectedTag=document.getElementsByTagName("li")[0];
	function getTab(obj,index) {  
		if(selectedTag!=null){
			selectedTag.className ="";
		}
		selectedTag = obj.parentElement;
		selectedTag.className ="selectTag";
		var showContent = 'tab_box_content'+index;
		for(var i=1; j=document.getElementById("tab_box_content"+i); i++){
			j.style.display = "none";
		}
		document.getElementById(showContent).style.display = "block";
	}
	function toAdd() { 
		var parent_type_id = document.getElementById("parent_type_id").value;
		if(parent_type_id==null || parent_type_id==''){
			alert("选择上街节点!");
			return;
		}
		var parent_type_name = document.getElementById("parent_type_name").value;
		var divisory_type = document.getElementById("divisory_type").value;
		popWindow("<%=contextPath%>/market/crm/setting/settingEdit.jsp?parent_type_id="+parent_type_id+"&parent_type_name="+parent_type_name+"&divisory_type="+divisory_type);
	}
	function toEdit() {
		var type_id = document.getElementById("type_id").value;
      	var text = '你确定要修改?';
		if(type_id!=null && window.confirm(text)){
			var parent_type_id = document.getElementById("parent_type_id").value;
			var parent_type_name = document.getElementById("parent_type_name").value;
			popWindow("<%=contextPath%>/market/crm/setting/settingEdit.jsp?type_id="+type_id+"&parent_type_id="+parent_type_id+"&parent_type_name="+parent_type_name);
			return;
		}
		alert("请选择修改的记录!");
	}
	function toDel() {
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var type_id = '';
		var substr = '';
		for (var i = objLen-2;i > 0;i--){  
			if (obj [i].checked == true) { 
				type_id=obj [i].value;
				if(window.confirm('你确定要删除第'+i+'行吗?')){
					substr = substr + "update bgp_market_company_type t set t.bsflag ='1' where t.type_id ='"+type_id+"';" 
				}
			}   
		} 
		if(substr!=''){
			var retObj = jcdpCallService("ClientRelationSrv", "saveClientRelation", "sql="+substr);
			if(retObj.returnCode =='0'){
				alert("删除成功!");
				var parent_type_id = document.getElementById("parent_type_id").value;
				var parent_type_name = document.getElementById("parent_type_name").value;
				var ctt = top.frames('list');
				ctt.frames[1].refresh(parent_type_id,parent_type_name);
				return;
			}
		}
		var type_id = document.getElementById("type_id").value;
      	var text = '你确定要删除?';
		if(type_id!=null && window.confirm(text)){
			var substr ="update bgp_market_company_type t set t.bsflag ='1' where t.type_id ='"+type_id+"';" 
			if(substr!=''){
				var retObj = jcdpCallService("ClientRelationSrv", "saveClientRelation", "sql="+substr);
				if(retObj.returnCode =='0'){
					alert("删除成功!");
					var parent_type_id = document.getElementById("parent_type_id").value;
					var parent_type_name = document.getElementById("parent_type_name").value;
					var ctt = top.frames('list');
					ctt.frames[1].refresh(parent_type_id,parent_type_name);
					return;
				}
			}
		}
		alert("请选择删除的记录!");
	}
	function frameSize(){
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

</body>
</html>
