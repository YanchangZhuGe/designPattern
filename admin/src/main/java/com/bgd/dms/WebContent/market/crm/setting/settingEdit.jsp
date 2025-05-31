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
	String user_id = user.getUserId();
	String type_id = request.getParameter("type_id");
	if(type_id==null){
		type_id = "";
	}
	String parent_type_id = request.getParameter("parent_type_id");
	if(parent_type_id == null){
		parent_type_id = "";
	}
	String parent_type_name = request.getParameter("parent_type_name");
	if(parent_type_name==null){
		parent_type_name = "";
	}
	String divisory_type = request.getParameter("divisory_type");
	if(divisory_type==null){
		divisory_type = "";
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
  	<title></title> 
	</head> 
<body>
<input type="hidden" name="type_id" id="type_id" value="<%=type_id %>" />
<input type="hidden" name="parent_type_id" id="parent_type_id" value="<%=parent_type_id %>"/>
<input type="hidden" name="user_id" id="user_id" value="<%=user_id %>"/>
<div id="new_table_box" align="center">
	<div id="new_table_box_content"> 
		<div id="new_table_box_bg">
			<table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		     	<tr>
			    	<td class="inquire_item6">上级节点:</td>
			    	<td class="inquire_form6"><input name="parent_type_name" id="parent_type_name" type="text" value="<%=parent_type_name %>" class="input_width" disabled="disabled"/></td>
			    	<td class="inquire_item6"><font color="red">*</font>类别名称:</td>
			    	<td class="inquire_form6"><input name="type_name" id="type_name" type="text" class="input_width" value="" /></td>
			    	<td class="inquire_item6"><font color="red">*</font>类别简称:</td>
			    	<td class="inquire_form6"><input name="type_short_name" id="type_short_name" type="text" class="input_width" value="" /></td>
			    </tr>
		    </table> 
		</div> 
		<div id="oper_div">
			<span class="tj_btn"><a href="#" onclick="newSubmit()"></a></span>
			<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
		</div>
	</div> 
</div>
<script type="text/javascript">
	cruConfig.contextPath = '<%=contextPath%>';
	function refreshData(){
		var id  = '<%=type_id%>';
		var querySql = "select t.type_id ,t.type_name ,t.type_short_name from bgp_market_company_type t where t.bsflag='0' and t.type_id ='"+id+"' ";				 	 
    	retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj.returnCode=='0'){
			if(retObj.datas != null && retObj.datas.length>0){
				datas = retObj.datas[0];
				document.getElementById("type_id").value = id;
				document.getElementById("type_name").value = datas.type_name;
				document.getElementById("type_short_name").value = datas.type_short_name;
			}
		}
	}
	refreshData();
	function newSubmit() {
		if(checkValue() == false){
			return ;
		}
		var substr ='';
		var type_id = document.getElementById("type_id").value;
		var user_id = document.getElementById("user_id").value;
		var type_name = document.getElementById("type_name").value;
		var divisory_type = '<%=divisory_type%>';
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
				var ctt = top.frames('list');
				ctt.frames[1].refresh(parent_type_id,parent_type_name);
				newClose();
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
</script>
</body>
</html>