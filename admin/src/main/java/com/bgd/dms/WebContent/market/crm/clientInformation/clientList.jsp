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
						   <auth:ListButton functionId="" css="ck" event="onclick='toView()'" title="JCDP_btn_view"></auth:ListButton>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			<tr>
			  <td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{company_id}' onclick=check(this)/>" >
			  	<input type='checkbox' name='chk_entity_id' value='' onclick='check(this)'/></td>
			  <td class="bt_info_even" autoOrder="1">序号</td> 
			  <td class="bt_info_odd" exp="{company_name}">公司全称</td>
			  <td class="bt_info_even" exp="{company_short_name}">简称</td>
			  <td class="bt_info_odd" exp="{contract_num}">合同数量</td>
			  <td class="bt_info_even" exp="{bid_total}">投标数量</td>
			  <td class="bt_info_odd" exp="{bid_pecent}">中标率</td>
			  <td class="bt_info_even" exp="{contact_num}">互访数量</td>
			  <td class="bt_info_odd" exp="{company_place_name}">所在国家（地区）</td>
			  <td class="bt_info_even" exp="{parent_company_name}">母公司名称</td>
			  <td class="bt_info_odd" exp="{company_stork}">合资公司股份</td>
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
        <li><a href="#" onclick="getTab(this,2)" >关键联系人信息</a></li>
        <li><a href="#" onclick="getTab(this,3)" >合同信息</a></li>
        <li><a href="#" onclick="getTab(this,4)" >互访记录</a></li>
        <!-- <li><a href="#" onclick="getTab(this,5)" >投标信息</a></li> -->
      </ul>
    </div>
	<div id="tab_box" class="tab_box" style="overflow:hidden;">
		<div id="tab_box_content1" class="tab_box_content" >
			<input type="hidden" name="company_id" id="company_id" value="" />
			<input type="hidden" name="type_id" id="type_id" value="" />
     		<input type="hidden" name="divisory_type" id="divisory_type" value=""/>
     		<input type="hidden" name="user_id" id="user_id" value="<%=user.getUserId()%>"/>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	    		<tr>
			    	<td class="inquire_item4"><font color="red">*</font>公司全称:</td>
			    	<td class="inquire_form4"><input name="company_name" id="company_name" type="text" class="input_width" value="" /></td>
			    	<td class="inquire_item4"><font color="red">*</font>公司简称:</td>
			    	<td class="inquire_form4"><input name="company_short_name" id="company_short_name" type="text" class="input_width" value="" /></td>
			    </tr>
			    <tr>
			    	<td class="inquire_item4">所在国家(地区):</td>
			    	<td class="inquire_form4"><input name="company_place" id="company_place" type="hidden" class="input_width" value="" />
			    		<input name="company_place_name" id="company_place_name" type="text" class="input_width" value="" />
			    		<img onclick="companyType('2','company_place','company_place_name')" src="<%=contextPath %>/images/images/tree_12.png" width="16" height="16" style="cursor: hand;" /></td>
			    	<td class="inquire_item4">母公司名称:</td>
			    	<td class="inquire_form4"><input name="parent_company_id" id="parent_company_id" type="hidden" class="input_width" value="" />
			    		<input name="parent_company_name" id="parent_company_name" type="text" class="input_width" value="" />
						<img onclick="companyType('1','parent_company_id','parent_company_name')" src="<%=contextPath %>/images/images/tree_12.png" width="16" height="16" style="cursor: hand;" /></td>
			    </tr>
			   <tr>
			    	<td class="inquire_item4">合资公司股份:</td>
			    	<td class="inquire_form4"><input name="company_stork" id="company_stork" type="text" class="input_width" value="" /></td>
			    </tr>
			</table>
		</div>
		<div id="tab_box_content2" class="tab_box_content" style="display:none;">
			<table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			    <tr>
			    	<td class="inquire_item4">关键联系人:</td>
			    	<td class="inquire_form4"><input name="key_name" id="key_name" type="text" class="input_width" value="" /></td>
			    	<td class="inquire_item4">联系人职位:</td>
			    	<td class="inquire_form4"><input name="key_position" id="key_position" type="text" class="input_width" value="" /></td>
			    </tr>
			    <tr>	
			    	<td class="inquire_item4">联系人电话:</td>
			    	<td class="inquire_form4"><input name="key_telephone" id="key_telephone" type="text" class="input_width" value="" /></td>
			    	<td class="inquire_item4">联系人邮箱:</td>
			    	<td class="inquire_form4"><input name="key_email" id="key_email" type="text" class="input_width" value="" /></td>
			    </tr>
		    </table>  
		</div>
		<div id="tab_box_content3" class="tab_box_content" style="display:none;">
			<iframe width="100%" height="100%" name="contract" id="contract" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
		</div>
		<div id="tab_box_content4" class="tab_box_content" style="display:none;">
			<iframe width="100%" height="100%" name="contact" id="contact" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
		</div>
		<div id="tab_box_content5" class="tab_box_content" style="display:none;">
			<iframe width="100%" height="100%" name="bid" id="bid" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
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
		document.getElementById("name").innerHTML = typeName;
		document.getElementById("type_id").value = typeId;
		document.getElementById("divisory_type").value = divisory_type;
		cruConfig.cdtType = 'form';
		if(typeId==null || typeId==''){
			cruConfig.queryStr = "select t.company_id ,t.company_name ,t.company_short_name ,t.company_place ,t1.type_short_name company_place_name ,t.parent_company_id ,t2.type_short_name parent_company_name ,t.company_stork ,"+
			" t.key_name ,t.key_position ,t.key_telephone ,t.key_email ,c1.contract_num ,c2.contact_num ,c3.bid_total ,c4.bid_num ,c4.bid_num/c3.bid_total bid_pecent from bgp_market_oil_company t " +
			" left join (select distinct c.company_id ,count(c.company_id) contract_num "+
			" from bgp_market_contract c where c.bsflag='0' group by c.company_id) c1 on t.company_id = c1.company_id "+
			" left join (select distinct tac.company_id ,count(tac.company_id) contact_num"+
			" from bgp_market_contact tac where tac.bsflag='0' group by tac.company_id) c2 on t.company_id = c2.company_id "+
			" left join (select distinct b.owner ,count(b.owner) bid_total  from bgp_market_bid b "+
			" where b.bsflag='0' group by b.owner) c3 on t.company_id = c3.owner "+
			" left join (select distinct bid.owner ,count(bid.owner) bid_num  from bgp_market_bid bid "+
			" where bid.bsflag='0' and bid.eva_result ='5' group by bid.owner) c4 on t.company_id = c4.owner"+
	    	" left join bgp_market_company_type t1 on t.company_place = t1.type_id and t1.bsflag='0' left join bgp_market_company_type t2 on t.parent_company_id = t2.type_id and t2.bsflag='0' " +
	    	" where t.bsflag='0' and t.company_type ='1' order by t.create_date desc";
		}else{
			cruConfig.queryStr = "select t.company_id ,t.company_name ,t.company_short_name ,t.company_place ,t1.type_short_name company_place_name ,t.parent_company_id ,t2.type_short_name parent_company_name ,t.company_stork ,"+
			" t.key_name ,t.key_position ,t.key_telephone ,t.key_email ,c1.contract_num ,c2.contact_num ,c3.bid_total ,c4.bid_num ,c4.bid_num/c3.bid_total bid_pecent from bgp_market_oil_company t " +
			" left join (select distinct c.company_id ,count(c.company_id) contract_num "+
			" from bgp_market_contract c where c.bsflag='0' group by c.company_id) c1 on t.company_id = c1.company_id "+
			" left join (select distinct tac.company_id ,count(tac.company_id) contact_num"+
			" from bgp_market_contact tac where tac.bsflag='0' group by tac.company_id) c2 on t.company_id = c2.company_id "+
			" left join (select distinct b.owner ,count(b.owner) bid_total  from bgp_market_bid b "+
			" where b.bsflag='0' group by b.owner) c3 on t.company_id = c3.owner "+
			" left join (select distinct bid.owner ,count(bid.owner) bid_num  from bgp_market_bid bid "+
			" where bid.bsflag='0' and bid.eva_result ='5' group by bid.owner) c4 on t.company_id = c4.owner"+
			" left join bgp_market_company_type t1 on t.company_place = t1.type_id and t1.bsflag='0' left join bgp_market_company_type t2 on t.parent_company_id = t2.type_id and t2.bsflag='0' "+
			" where t.bsflag='0' and t.company_type ='1' and (t.company_place ='"+typeId+"' or t.parent_company_id ='"+typeId+"') order by t.create_date desc ";
		}
		cruConfig.currentPageUrl = "<%=contextPath%>/market/crm/clientInformation/clientList.jsp";
		queryData(1);
		frameSize();
		resizeNewTitleTable();
	}
	refreshData('' ,'' ,'');
	/* 详细信息 */
	function loadDataDetail(id){
		var obj = event.srcElement; 
    	if(obj.tagName.toLowerCase() == "td"){   
    		var   tr   =  obj.parentNode ;
    		tr.cells[0].firstChild.checked = true;
    	} 
    	document.getElementById("contract").src = "<%=contextPath%>/market/crm/clientInformation/contractList.jsp?company_id="+id;
    	document.getElementById("contact").src = "<%=contextPath%>/market/crm/clientInformation/contactList.jsp?company_id="+id;
    	var querySql = "select t.company_id ,t.company_name ,t.company_short_name ,t.company_place ,t1.type_short_name company_place_name ,t.parent_company_id ,t2.type_short_name parent_company_name ,t.company_stork ,"+
		" t.key_name ,t.key_position ,t.key_telephone ,t.key_email from bgp_market_oil_company t " +
		" left join bgp_market_company_type t1 on t.company_place = t1.type_id and t1.bsflag='0' left join bgp_market_company_type t2 on t.parent_company_id = t2.type_id and t2.bsflag='0' where t.bsflag='0' and t.company_id='"+id+"'";				 	 
		retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj.returnCode=='0'){
			if(retObj.datas[0] != null){
				datas = retObj.datas[0];
				document.getElementById("company_id").value = id;
				document.getElementById("company_name").value = datas.company_name;
				document.getElementById("company_short_name").value = datas.company_short_name;
				document.getElementById("company_place").value = datas.company_place;
				document.getElementById("company_place_name").value = datas.company_place_name;
				document.getElementById("parent_company_id").value = datas.parent_company_id;
				document.getElementById("parent_company_name").value = datas.parent_company_name;
				document.getElementById("company_stork").value = datas.company_stork;
				document.getElementById("key_name").value =datas.key_name;
				document.getElementById("key_position").value =datas.key_position;
				document.getElementById("key_telephone").value =datas.key_telephone;
				document.getElementById("key_email").value =datas.key_email;
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
		var type_short_name = document.getElementById("type_short_name").value;
		if(type_id!=null && type_id!=''){
			substr = substr + "update bgp_market_company_type t set t.type_id ='"+type_id+"' ,t.updator_id='"+user_id+"' ," +
			" t.modifi_date = sysdate ,t.type_name ='"+type_name+"', t.type_short_name ='"+type_short_name+"' "+
			" where t.type_id ='"+type_id+"';" 
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
		var type_id = document.getElementById("type_id").value;
		var divisory_type = document.getElementById("divisory_type").value;
		var type_name = document.getElementById("name").value;
		if(type_name==null || type_name==undefined){
			type_name ='';
		}
		popWindow("<%=contextPath%>/market/crm/clientInformation/clientEdit.jsp?type_id="+type_id+"&type_name="+type_name+"&divisory_type="+divisory_type);
	}
	function toEdit() {
		var company_id = document.getElementById("company_id").value;
      	var text = '你确定要修改?';
		if(company_id!=null && window.confirm(text)){
			var type_id = document.getElementById("type_id").value;
			var type_name = document.getElementById("name").innerHTML;
			var divisory_type = document.getElementById("divisory_type").value;
			popWindow("<%=contextPath%>/market/crm/clientInformation/clientEdit.jsp?company_id="+company_id+"&type_id="+type_id+"&type_name="+type_name+"&divisory_type="+divisory_type);
			return;
		}
		alert("请选择修改的记录!");
	}
	function toView() {
		var company_id = document.getElementById("company_id").value;
      	var text = '你确定要修改?';
		if(company_id!=null ){
			var type_id = document.getElementById("type_id").value;
			var type_name = document.getElementById("name").innerHTML;
			var divisory_type = document.getElementById("divisory_type").value;
			popWindow("<%=contextPath%>/market/crm/provider/providerEdit.jsp?company_id="+company_id+"&type_id="+type_id+"&type_name="+type_name+"&divisory_type="+divisory_type);
			return;
		}
		alert("请选择修改的记录!");
	}
	function toDel() {
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var company_id = '';
		var substr = '';
		if(window.confirm('你确定要删除吗?')){
			for (var i = objLen-2;i > 0;i--){  
				if (obj [i].checked == true) { 
					company_id=obj [i].value;
					substr = substr + "update bgp_market_oil_company t set t.bsflag ='1' where t.company_id ='"+company_id+"';" 
				}   
			} 
		}
		if(substr!=''){
			var retObj = jcdpCallService("ClientRelationSrv", "saveClientRelation", "sql="+substr);
			if(retObj.returnCode =='0'){
				alert("删除成功!");
				var typeName = document.getElementById("name").innerHTML;
				var typeId = document.getElementById("type_id").value ;
				var divisory_type = document.getElementById("divisory_type").value;
				refresh(typeId,typeName,divisory_type);
				return;
			}
		}
		alert("请选择删除的记录!");
	}
	function companyType(select ,id ,name){
		var type_id = document.getElementById("type_id").value;
	    var company_type = {
	        fkValue:"",
	        name:"",
	        short_name:""
	    };
	    if(select !=null && select=='1'){
	    	window.showModalDialog('<%=contextPath%>/market/crm/common/company_tree.jsp?key_id='+type_id,company_type,'dialogWidth=300px;dialogHeight=768px');
	    }else if(select !=null && select=='2'){
	    	window.showModalDialog('<%=contextPath%>/market/crm/common/section_tree.jsp?key_id='+type_id,company_type,'dialogWidth=300px;dialogHeight=768px');
	    }else{
	    	window.showModalDialog('<%=contextPath%>/market/crm/common/client_tree.jsp?key_id='+type_id,company_type,'dialogWidth=300px;dialogHeight=768px');
	    }
	    if(company_type.fkValue!=null && company_type.fkValue !=""){
			document.getElementById(id).value = company_type.fkValue;
			document.getElementById(name).value = company_type.short_name;
	    }
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
