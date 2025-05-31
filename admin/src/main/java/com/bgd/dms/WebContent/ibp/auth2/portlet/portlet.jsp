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
	String role_id = request.getParameter("id");
	if(role_id==null){
		role_id ="";
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
									<option value="3">项目级</option>
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
			  <td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{portlet_id}' onclick=check(this)/>" >选择</td>
			  <td class="bt_info_even" autoOrder="1">序号</td> 
			  <td class="bt_info_odd" exp="{portlet_name}">Portlet名称</td>
			  <td class="bt_info_even" exp="{portlet_level}">Portlet级别</td>
			  <td class="bt_info_odd" exp="{portlet_url}">Portlet地址</td>
			  
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
        <li class="selectTag"><a href="#" onclick="getTab(this,1)">Portlet</a></li>
      </ul>
    </div>
	<div id="tab_box" class="tab_box" style="overflow:hidden;">
		<div id="tab_box_content1" class="tab_box_content" >
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr align="right" >
			  	<td>&nbsp;</td>
			    <%-- <auth:ListButton functionId="" css="tj" event="onclick='newSubmit()'" title="JCDP_btn_submit"></auth:ListButton> --%>
			  </tr>
			</table>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				<tr>
				    <td class="inquire_form6" colspan="5"><textarea rows="4" cols="10" id="portlet_name" name="portlet_name" class="textarea"></textarea>
				    	<textarea rows="4" cols="10" id="portlet_id" name="portlet_id" class="textarea" style="display: none"></textarea></td>
				</tr>
			</table>
			<div id="oper_div" >
					<span class="tj_btn"><a href="#" onclick="newSubmit()"></a></span>
			</div>
		</div>
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
			cruConfig.queryStr = "select t.portlet_id ,t.category_id ,t.portlet_name ,t.portlet_url ,"+
			" decode(t.portlet_level,'1','公司级','2','物探处级','3','地震队级') portlet_level ,t.portlet_desc "+
			" from bgp_comm_portlet_dms t where t.category_id in("+category_ids+") and t.portlet_level like '"+portlet_level+"%'"+
			" and t.portlet_name like '%"+name+"%'";
		}
		cruConfig.currentPageUrl = "<%=contextPath%>/market/crm/information/informationList.jsp";
		queryData(1);
		getChecked();
		//frameSize();
		//resizeNewTitleTable();
	}
	//refreshData('' ,'');
	getPortlet();
	function getPortlet(){
		var role_id = '<%=role_id%>';
		var ids ='';
		var names ='';
		var querySql = "select t.entity_id ,t.role_id ,t.portlet_id ,p.portlet_name from p_auth_role_portlet_dms t "+
			" join bgp_comm_portlet_dms p on t.portlet_id = p.portlet_id  where t.role_id='"+role_id+"'" ;
		var retObj = syncRequest('Post', cruConfig.contextPath+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql))+'&pageSize='+cruConfig.pageSizeMax);
		if(retObj!=null && retObj.returnCode=='0'){
			if(retObj.datas!=null && retObj.datas.length >0){
				for(var i =0;i<retObj.datas.length && retObj.datas[i]!=null;i++){
					var data = retObj.datas[i];
					var portlet_id = data.portlet_id;
					var portlet_name = data.portlet_name;
					ids = portlet_id +',' + ids;
					names = portlet_name +',' + names;
				}
				document.getElementById("portlet_id").value = ids;
				document.getElementById("portlet_name").value = names;
			}
		}
	}
	function getChecked(){
		var portlet_ids = document.getElementById("portlet_id").value ;
		var table = document.getElementById("queryRetTable");
		for(var i=1;i<table.rows.length;i++){
			var portlet_id = table.rows[i].cells[0].firstChild.value;
			if(portlet_ids.indexOf(portlet_id)!=-1){
				table.rows[i].cells[0].firstChild.checked =true;
			}
		}
	}
	/* 详细信息 */
	function loadDataDetail(id){
		var ids = document.getElementById("portlet_id").value;
		var portlet_names = document.getElementById("portlet_name").value ;
		var obj = event.srcElement;
		var tr = '';
		if(obj.tagName.toLowerCase() =='td'){
			tr = obj.parentNode;
			obj.parentNode.cells[0].firstChild.checked = 'checked';
		}else{
			tr = obj.parentNode.parentNode;
			var checked = tr.cells[0].firstChild.checked;
			if(checked!=null && checked ==false){
				id = id + ",";
				var name = tr.cells[2].innerHTML;
				name = name + ",";
				ids = ids.replace(id ,'');
				debugger;
				portlet_names = portlet_names.replace(name ,'');
				document.getElementById("portlet_id").value = ids;
				document.getElementById("portlet_name").value = portlet_names;
				return;
			}
			
		}
		
		if(ids.indexOf(id)!=-1){
			return;
		}
		document.getElementById("portlet_id").value = id +"," +ids;
		document.getElementById("portlet_name").value = tr.cells[2].innerHTML +","+ portlet_names;
	}
	/* 修改 */
	function newSubmit() {
		var portlet_ids = document.getElementById("portlet_id").value ;
		var role_id = '<%=role_id%>';
		if(portlet_ids.indexOf(',')!=-1){
			portlet_ids = portlet_ids.substring(0,portlet_ids.length-1);
			var sql = "delete p_auth_role_portlet_dms t where t.role_id='"+role_id+"'";
			retObj = jcdpCallService("PortletSrv", "savePortletBySql", "sql="+sql);
			
		}else{
			return;
		}
		var substr = '';
		var ids = portlet_ids.split(',');
		for(var i =0;i<ids.length;i++){
			var portlet_id = ids[i];
			substr = substr + "insert into p_auth_role_portlet_dms(entity_id ,role_id ,portlet_id ) " +
			" values((select lower(sys_guid()) from dual),'"+role_id+"','"+portlet_id+"');";
		}
		if(substr!=null && substr!=''){
			retObj = jcdpCallService("PortletSrv", "savePortletBySql", "sql="+substr);
			if(retObj!=null && retObj.returnCode=='0'){
				alert("保存成功!")
				document.getElementById("portlet_id").value = "";
				document.getElementById("portlet_name").value = "";
				var category_id = document.getElementById("category_id").value ;
				var portlet_name = document.getElementById("portlet_name").value ;
				getPortlet();
				refreshData(category_id ,category_name);
			}
		}
	}
	function checkValue(){
		var obj = document.getElementById("portlet_name");
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("Portlet名称不能为空!");
			return false;
		}
		obj = document.getElementById("portlet_url");
		value = obj.value ;
		if(obj ==null || value==''){
			alert("Portlet地址不能为空!");
			return false;
		}
		obj = document.getElementById("portlet_level");
		value = obj.value ;
		if(obj ==null || value==''){
			alert("Portlet级别不能为空!");
			return false;
		}
	}
	
	function toAdd() { 
		var category_id = document.getElementById("category_id").value;
		var category_name = document.getElementById("category_name").value;
		if(category_id==null || category_id==''){
			alert("请选择portlet分类!");
			return; 
		}
		popWindow("<%=contextPath%>/common/portlet/portletEdit.jsp?category_id="+category_id+"&category_name="+category_name);
	}
	function toEdit() {
		var portlet_id = document.getElementById("portlet_id").value;
      	var text = '你确定要修改?';
		if(portlet_id!=null && window.confirm(text)){
			var category_id = document.getElementById("category_id").value;
			var category_name = document.getElementById("category_name").value;
			popWindow("<%=contextPath%>/common/portlet/portletEdit.jsp?portlet_id="+portlet_id+"&category_id="+category_id+"&category_name="+category_name);
			return;
		}
		alert("请选择修改的记录!");
	}
	function toDel() {
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var portlet_id = '';
		var substr = '';
		if(window.confirm('你确定要删除吗?')){
			for (var i = objLen-2;i > 0;i--){  
				if (obj [i].checked == true) { 
					portlet_id = obj [i].value;
					substr = substr + "delete bgp_comm_portlet_dms t where t.portlet_id ='"+portlet_id+"';" 
				}   
			} 
		}
		if(substr!=''){
			var retObj = jcdpCallService("PortletSrv", "savePortletBySql", "sql="+substr);
			if(retObj.returnCode =='0'){
				alert("删除成功!");
				var category_name = document.getElementById("category_name").value;
				var category_id = document.getElementById("category_id").value ;
				refreshData(category_id,category_name);
				return;
			}
		}
		alert("请选择删除的记录!");
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
