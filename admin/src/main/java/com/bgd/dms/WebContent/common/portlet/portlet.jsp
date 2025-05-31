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
			  <td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{portlet_id}' onclick=check(this)/>" >
			  	<input type='checkbox' name='chk_entity_id' value='' onclick='check(this)'/></td>
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
        <li class="selectTag"><a href="#" onclick="getTab(this,1)">基本信息</a></li>
        <!-- <li><a href="#" onclick="getTab(this,2)" >关键联系人信息</a></li>
        <li><a href="#" onclick="getTab(this,3)" >合同信息</a></li>
        <li><a href="#" onclick="getTab(this,4)" >互访记录</a></li>
        <li id="year_workload" style="display: none;"><a href="#" onclick="getTab(this,5)" >每年工作量</a></li> -->
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
			<input type="hidden" name="portlet_id" id="portlet_id" value="" class="input_width" />
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				<tr>
				   	<td class="inquire_item6"><font color="red">*</font>Portlet名称:</td>
				    <td class="inquire_form6"><input type="text" name="portlet_name" id="portlet_name" value="" class="input_width"/></td>
				   	<td class="inquire_item6"><font color="red">*</font>Portlet地址:</td>
				   	<td class="inquire_form6"><input type="text" name="portlet_url" id="portlet_url" value="" class="input_width" /></td>
				    <td class="inquire_item6"><font color="red">*</font>Portlet级别:</td>
				    <td class="inquire_form6"><select id="portlet_level" name="portlet_level" class="select_width" >
				    			<option value="">请选择</option>
								<option value="1">公司级</option>
								<option value="2">物探处级</option>
								<option value="3">项目级</option>
							</select></td>
    			</tr>
				<tr>
					<td class="inquire_item6">Portlet说明:</td>
				    <td class="inquire_form6" colspan="5"><textarea rows="4" cols="10" id="portlet_desc" name="portlet_desc" class="textarea"></textarea></td>
				</tr>
			</table>
		</div>
		<div id="tab_box_content2" class="tab_box_content" style="display:none;">
			<iframe width="100%" height="100%" name="contract" id="contract" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
		</div>
	</div>
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	var level = 0;
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
			if(category_name.indexOf('公司')!=-1){
				level = 1 ;
				document.getElementById("level").disabled = true;
			}else if(category_name.indexOf('物探处')!=-1){
				level = 2 ;
				document.getElementById("level").disabled = true;
			}else if(category_name.indexOf('项目')!=-1){
				level = 3 ;
				document.getElementById("level").disabled = true;
			}else{
				level = 0 ;
				document.getElementById("level").removeAttribute("disabled");
			}
			document.getElementById("level").options[level].selected = true;
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
			" decode(t.portlet_level,'1','公司级','2','物探处级','3','项目级') portlet_level ,t.portlet_desc "+
			" from bgp_comm_portlet_dms t where t.category_id in("+category_ids+") and t.portlet_level like '"+portlet_level+"%'"+
			" and t.portlet_name like '%"+name+"%'";
		}
		cruConfig.currentPageUrl = "<%=contextPath%>/market/crm/information/informationList.jsp";
		queryData(1);
		if(level!=0){
			document.getElementById("portlet_level").disabled = true;
		}else{
			document.getElementById("portlet_level").removeAttribute("disabled");
		}
		document.getElementById("portlet_level").options[level].selected = true;
	}
	//refreshData('' ,'');
	/* 详细信息 */
	function loadDataDetail(id){
		var obj = event.srcElement;
		if(obj.tagName.toLowerCase() =='td'){
			obj.parentNode.cells[0].firstChild.checked = 'checked';
		}
		var portlet_id = id;
		var sql = "select t.portlet_id ,t.category_id ,t.portlet_name ,t.portlet_url ,t.portlet_level ,t.portlet_desc from bgp_comm_portlet_dms t "+
		" where t.portlet_id ='"+portlet_id+"'";
		
		var retObj = syncRequest('Post',cruConfig.contextPath + appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
		if(retObj!=null && retObj.returnCode =='0'){
			if(retObj.datas!=null && retObj.datas.length>0){
				if(retObj.datas[0]!=null){
					var map = retObj.datas[0];
					document.getElementById("portlet_id").value = portlet_id;
					document.getElementById("portlet_name").value = map.portlet_name;
					document.getElementById("portlet_url").value = map.portlet_url;
					document.getElementById("portlet_desc").value = map.portlet_desc;
					var portlet_level = map.portlet_level;
					document.getElementById("portlet_level").options[portlet_level].selected = 'selected';
				}
			}
		}
	}
	/* 修改 */
	function newSubmit() {
		if(checkValue() == false){
			return ;
		}
		var portlet_id = document.getElementById("portlet_id").value ;
		var category_id = document.getElementById("category_id").value ;
		var category_name = document.getElementById("category_name").value ;
		var portlet_name = document.getElementById("portlet_name").value ;
		var portlet_url = document.getElementById("portlet_url").value ;
		var portlet_level = document.getElementById("portlet_level").value ;
		var portlet_desc = document.getElementById("portlet_desc").value ;
		var substr = '';
		if(portlet_id==null || portlet_id==''){
			substr = "insert into bgp_comm_portlet_dms(portlet_id ,portlet_name ,portlet_url ,category_id ,portlet_level ,portlet_desc) " +
			" values((select lower(sys_guid()) from dual),'"+portlet_name+"','"+portlet_url+"','"+category_id+"','"+portlet_level+"','"+portlet_desc+"');";
			retObj = jcdpCallService("PortletSrv", "savePortletBySql", "sql="+substr);
		}else{
			substr = "update bgp_comm_portlet_dms t set t.portlet_id ='"+portlet_id+"' ,t.portlet_name ='"+portlet_name+"' ,t.portlet_url ='"+portlet_url+"' ,"+
			" category_id='"+category_id+"' ,t.portlet_level ='"+portlet_level+"' ,t.portlet_desc='"+portlet_desc+"' where t.portlet_id='"+portlet_id+"';";
			retObj = jcdpCallService("PortletSrv", "savePortletBySql", "sql="+substr);
		}
		if(retObj!=null && retObj.returnCode=='0'){
			alert("保存成功!")
			refreshData(category_id ,category_name);
			
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
		popWindow("<%=contextPath%>/common/portlet/portletEdit.jsp?category_id="+category_id+"&category_name="+category_name+"&level="+level);
	}
	function toEdit() {
		var portlet_id = document.getElementById("portlet_id").value;
      	var text = '你确定要修改?';
		if(portlet_id!=null && window.confirm(text)){
			var category_id = document.getElementById("category_id").value;
			var category_name = document.getElementById("category_name").value;
			popWindow("<%=contextPath%>/common/portlet/portletEdit.jsp?portlet_id="+portlet_id+"&category_id="+category_id+"&category_name="+category_name+"&level="+level);
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
