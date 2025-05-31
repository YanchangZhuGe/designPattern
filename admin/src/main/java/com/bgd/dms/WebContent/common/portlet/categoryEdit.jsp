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
	String parent_category_id = request.getParameter("parent_category_id");
	if(parent_category_id==null){
		parent_category_id = "";
	}
	String category_id = request.getParameter("category_id");
	if(category_id==null){
		category_id = "";
	}
	String parent_category_name = request.getParameter("parent_category_name");
	if(parent_category_name==null){
		parent_category_name = "";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head> 
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
		<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
		<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
		<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
	</head> 
<body><!-- class="bgColor_f3f3f3"  onload="page_init()"> --> 
<form name="fileForm" id="fileForm" method="post" > <!--target="hidden_frame" enctype="multipart/form-data" --> 
	<div id="new_table_box" align="center">
		<div id="new_table_box_content"> 
			<div id="new_table_box_bg">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<input type="hidden" name="parent_category_id" id="parent_category_id" value="<%=parent_category_id %>" class="input_width" />
					<input type="hidden" name="category_id" id="category_id" value="<%=category_id %>" class="input_width" />
					<tr>
					    <td class="inquire_item4">父分类名称:</td>
					    <td class="inquire_form4" ><input type="text" name="parent_category_name" id="parent_category_name" value="<%=parent_category_name %>" class="input_width" disabled="disabled"/></td>
					    <td class="inquire_item4">序号:</td>
					   	<td class="inquire_form4"><input type="text" name="order_num" id="order_num" value="" class="input_width" onkeydown="javascript:return checkIfNum(event);"/></td>
					</tr>
					<tr>
						<td class="inquire_item4"><font color="red">*</font>分类名称:</td>
					    <td class="inquire_form4" colspan="3"><input type="text" name="category_name" id="category_name" value="" class="input_width"/></td>
	    			</tr>
				</table>
			</div> 
			<div id="oper_div">
					<span class="tj_btn"><a href="#" onclick="newSubmit()"></a></span>
					<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			</div>
		</div>
	</div>
</form> 
<script type="text/javascript">
	cruConfig.contextPath = '<%=contextPath%>';
	/* 输入的是否是数字 */
	function checkIfNum(){
		var element = event.srcElement;
		if(element.value != null && element.value =='0' && (event.keyCode>=48 && event.keyCode<=57)){
			element.value = '';
		}
		if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8 || event.keyCode ==37 || event.keyCode ==39 || event.keyCode ==9){
			return true;
		}
		else{
			alert("只能输入数字");
			return false;
		}
	}
	function refreshData(){
		var category_id = '<%=category_id%>';
		var sql = "select t.category_id ,t.category_name ,t.order_num from bgp_comm_portlet_category_dms t where t.category_id ='"+category_id+"'";
		
		var retObj = syncRequest('Post',cruConfig.contextPath + appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
		if(retObj!=null && retObj.returnCode =='0'){
			if(retObj.datas!=null && retObj.datas.length>0){
				if(retObj.datas[0]!=null){
					var map = retObj.datas[0];
					document.getElementById("category_id").value = category_id;
					document.getElementById("category_name").value = map.category_name;
					document.getElementById("order_num").value = map.order_num;
				}
			}
		}
	}
	refreshData();
	function newSubmit() {
		if(checkValue() == false){
			return ;
		}
		var category_id = document.getElementById("category_id").value ;
		var category_name = document.getElementById("category_name").value ;
		var order_num = document.getElementById("order_num").value ;
		var parent_category_id = document.getElementById("parent_category_id").value; 
		var substr = '';
		if(category_id==null || category_id==''){
			var sql = " select * from bgp_comm_portlet_category_dms t where t.parent_category_id='"+parent_category_id+"' and t.category_name='"+category_name+"'";
			var retObj = syncRequest('Post',cruConfig.contextPath + appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
			if(retObj!=null && retObj.returnCode =='0'){
				if(retObj.datas!=null && retObj.datas.length>0){
					alert("分类名称已经存在!");
					return;
				}
			}
			substr = "insert into bgp_comm_portlet_category_dms(category_id ,category_name ,parent_category_id ,order_num) " +
			" values((select lower(sys_guid()) from dual),'"+category_name+"','"+parent_category_id+"','"+order_num+"');";
			retObj = jcdpCallService("PortletSrv", "savePortletBySql", "sql="+substr);
		}else{
			substr = "update bgp_comm_portlet_category_dms t set t.category_name ='"+category_name+"' ,t.order_num ='"+order_num+"' where t.category_id ='"+category_id+"';";
			var retObj = jcdpCallService("PortletSrv", "savePortletBySql", "sql="+substr);
		}
		if(retObj!=null && retObj.returnCode=='0'){
			alert("保存成功!")
			var ctt = top.frames['list'];
			var parent_category_id = '<%=parent_category_id%>';
			ctt.mainTopframe.refreshTree(parent_category_id);
			newClose();
			
		}
	}
	function checkValue(){
		var obj = document.getElementById("category_name");
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("分类名称不能为空!");
			return false;
		}
		var obj = document.getElementById("order_num");
		var value = obj.value ;
		if(obj !=null && value!='' && value.length>5){
			alert("序号长度不能超过5位!");
			return false;
		}
	}
</script>
</body>
</html>