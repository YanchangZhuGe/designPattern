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
	String company_id = request.getParameter("company_id");
	if(company_id==null){
		company_id = "";
	}
	String type_id = request.getParameter("type_id");
	if(type_id==null){
		type_id = "root";
	}
	String type_name = request.getParameter("type_name");
	if(type_name==null){
		type_name = "";
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
<input type="hidden" name="company_id" id="company_id" value="<%=company_id %>" />
<input type="hidden" name="user_id" id="user_id" value="<%=user_id %>"/>
<div id="new_table_box" align="center">
	<div id="new_table_box_content"> 
		<div id="new_table_box_bg">
			<table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
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
			    	<td class="inquire_item4">关键联系人:</td>
			    	<td class="inquire_form4"><input name="key_name" id="key_name" type="text" class="input_width" value="" /></td>
			    </tr>
			    <tr>
			    	<td class="inquire_item4">联系人职位:</td>
			    	<td class="inquire_form4"><input name="key_position" id="key_position" type="text" class="input_width" value="" /></td>
			    	<td class="inquire_item4">联系人电话:</td>
			    	<td class="inquire_form4"><input name="key_telephone" id="key_telephone" type="text" class="input_width" value="" /></td>
			    </tr>
			    <tr>
			    	<td class="inquire_item4">联系人邮箱:</td>
			    	<td class="inquire_form4"><input name="key_email" id="key_email" type="text" class="input_width" value="" /></td>
			    </tr>
		    </table> 
		</div> 
		<div id="oper_div">
			<span class="tj_btn"><a href="#" onclick="newClose()"></a></span>
			<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
		</div>
	</div> 
</div>
<script type="text/javascript">
	cruConfig.contextPath = '<%=contextPath%>';
	function refreshData(){
		var id  = '<%=company_id%>';
		var querySql = "select t.company_id ,t.company_name ,t.company_short_name ,t.company_place ,t1.type_short_name company_place_name ,t.parent_company_id ,t2.type_short_name parent_company_name ,t.company_stork ,"+
			" t.key_name ,t.key_position ,t.key_telephone ,t.key_email from bgp_market_oil_company t " +
    		" left join bgp_market_company_type t1 on t.company_place = t1.type_id and t1.bsflag='0' left join bgp_market_company_type t2 on t.parent_company_id = t2.type_id and t2.bsflag='0' where t.bsflag='0' and t.company_id='"+id+"'";				 	 
    	retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj.returnCode=='0'){
			if(retObj.datas != null && retObj.datas.length>0){
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
	refreshData();
	function newSubmit() {
		if(checkValue() == false){
			return ;
		}
		var type_id = '<%=type_id%>';
		var type_name = '<%=type_name%>';
		var divisory_type = '<%=divisory_type%>';
		var company_id = document.getElementById("company_id").value;
		var user_id = document.getElementById("user_id").value;
		var company_name = document.getElementById("company_name").value;
		var company_short_name = document.getElementById("company_short_name").value;
		var company_place = document.getElementById("company_place").value ;
		//var company_place_name = document.getElementById("company_place_name").value ;
		var parent_company_id = document.getElementById("parent_company_id").value ;
		//var parent_company_name = document.getElementById("parent_company_name").value ;
		var company_stork = document.getElementById("company_stork").value ;
		var key_name = document.getElementById("key_name").value ;
		var key_position = document.getElementById("key_position").value ;
		var key_telephone = document.getElementById("key_telephone").value ;
		var key_email = document.getElementById("key_email").value ;
		if(company_id!=null && company_id!=''){
			var substr = "update bgp_market_oil_company t set t.company_id ='"+company_id+"' ,t.updator_id='"+user_id+"' ," +
			" t.modifi_date = sysdate ,t.company_name ='"+company_name+"', t.company_short_name ='"+company_short_name+"' ,"+
			" t.company_place ='"+company_place+"', t.parent_company_id ='"+parent_company_id+"' ,t.company_stork ='"+company_stork+"' ,"+
			" t.key_name ='"+key_name+"', t.key_position ='"+key_position+"' ,t.key_telephone ='"+key_telephone+"' ,t.key_email ='"+key_email+"'"+
			" where t.company_id ='"+company_id+"';" 
			if(substr!=''){
				var retObj = jcdpCallService("ClientRelationSrv", "saveClientRelation", "sql="+substr);
				if(retObj.returnCode =='0'){
					alert("保存成功!");
					var ctt = top.frames('list');
					ctt.frames[1].refreshData(type_id,type_name,divisory_type);
					newClose(); 
				}
			}
		}else{
			var substr ="tableName=bgp_market_oil_company&company_name="+company_name+"&company_short_name="+company_short_name+"&company_place="+company_place +"&parent_company_id="+parent_company_id+
			"&company_stork="+company_stork+"&key_name="+key_name +"&key_position="+key_position+"&key_telephone="+key_telephone+"&key_email="+key_email ;
			if(substr!=''){
				var retObj = jcdpCallService("ClientRelationSrv", "saveCRMByMap", substr);
				if(retObj.returnCode =='0'){
					debugger;
					if(retObj.id!=null){
						var id = retObj.id;
						var sql = "insert into bgp_market_company_type(type_id ,type_name ,type_short_name ,parent_type_id ,company_id ,"+
						" bsflag ,create_date,creator_id ,modifi_date ,updator_id) "+
						" values((select lower(sys_guid()) from dual),'"+company_name+"' ,'"+company_short_name+"' ,'"+parent_company_id+"' ,'"+id+"' ," +
						" '0' ,sysdate ,'"+user_id+"' ,sysdate ,'"+user_id+"');"
						retObj = jcdpCallService("ClientRelationSrv", "saveClientRelation", "sql="+sql);
					}
					alert("保存成功!");
					var ctt = top.frames('list');
					ctt.frames[1].refreshData(type_id,type_name,divisory_type);
					newClose();
				}
			}
		}
	}
	function checkValue(){
		var obj = document.getElementById("company_name") ;
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("公司全称不能为空!");
			return false;
		}
		obj = document.getElementById("company_short_name") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("公司简称不能为空!");
			return false;
		}
	}
	function companyType(select ,id ,name){
		var type_id = '<%=type_id%>';
	    var company_type = {
	        fkValue:"",
	        name:"",
	        short_name:""
	    };
	    if(select !=null && select=='1'){
	    	window.showModalDialog('<%=contextPath%>/market/crm/common/company_tree.jsp?key_id=<%=type_id%>',company_type,'dialogWidth=300px;dialogHeight=768px');
	    }else if(select !=null && select=='2'){
	    	window.showModalDialog('<%=contextPath%>/market/crm/common/section_tree.jsp?key_id=<%=type_id%>',company_type,'dialogWidth=300px;dialogHeight=768px');
	    }else{
	    	window.showModalDialog('<%=contextPath%>/market/crm/common/client_tree.jsp?key_id=<%=type_id%>',company_type,'dialogWidth=300px;dialogHeight=768px');
	    }
	    if(company_type.fkValue!=null && company_type.fkValue !=""){
			document.getElementById(id).value = company_type.fkValue;
			document.getElementById(name).value = company_type.short_name;
	    }
	}
</script>
</body>
</html>