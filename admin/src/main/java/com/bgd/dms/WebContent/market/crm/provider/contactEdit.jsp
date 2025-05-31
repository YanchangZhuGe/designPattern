<%@page import="java.text.SimpleDateFormat"%>
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
	String company_name = request.getParameter("company_name");
	//company_name = decode(company_name);
	if(company_name==null){
		company_name = "";
	}
	String contact_id = request.getParameter("contact_id");
	if(contact_id==null){
		contact_id = "";
	}
	SimpleDateFormat sd = new SimpleDateFormat("yyyy");
	int end = Integer.parseInt(sd.format(new Date()));
	
	int start = end - 5;
	
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
<input type="hidden" name="contact_id" id="contact_id" value="<%=contact_id %>"/>
<input type="hidden" name="company_id" id="company_id" value="<%=company_id %>"/>
<input type="hidden" name="user_id" id="user_id" value="<%=user_id %>"/>
<div id="new_table_box" align="center">
	<div id="new_table_box_content"> 
		<div id="new_table_box_bg">
			<table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		     	<tr>
			    	<td class="inquire_item4"><font color="red">*</font>记录年度:</td>
			    	<td class="inquire_form4"><select name="contact_year" id="contact_year" class="select_width">
			    			<%for(int i=end ;i>=start ;i--){%>
			    			<option value="<%=i%>"><%=i %></option>
			    			<% }%>
			    		</select></td>
			    	<td class="inquire_item4"><font color="red">*</font>记录日期:</td>
			    	<td class="inquire_form4"><input name="contact_date" id="contact_date" type="text" class="input_width" value="" readonly="readonly"/>
			   			<img width="16" height="16" id="cal_button7" style="cursor: hand;" onmouseover="calDateSelector(contact_date,cal_button7);" src="<%=contextPath %>/images/calendar.gif" /></td>
			    </tr>
			    
			    <tr>	
			    	<td class="inquire_item4"><font color="red">*</font>交往单位:</td>
			    	<td class="inquire_form4"><input type="hidden" name="org_id" id="org_id" value="" class="input_width" />
			    	<input name="org_name" id="org_name" type="text" class="input_width" value="" disabled="disabled"/>
					<img onclick="selectOrgHR('orgId','org_id','org_name')" src="<%=contextPath %>/images/images/tree_12.png" width="16" height="16" style="cursor: hand;" /></td> 
			    	<td class="inquire_item4">地点:</td>
			    	<td class="inquire_form4"><input name="contact_place" id="contact_place" type="text" class="input_width" value="" /></td>
			    </tr>
			    <tr>	
			    	<td class="inquire_item4">客户单位:</td>
			    	<td class="inquire_form4"><input name="company_name" id="company_name" type="text" class="input_width" value="<%=company_name %>" readonly="readonly"/></td>
			    	<td class="inquire_item4">访问类型:</td>
			    	<td class="inquire_form4"><select id="contact_type" name="contact_type" class="select_width">
			    		<option value="1">访问客户</option>
			    		<option value="2">客户回访</option>
			    		</select></td>
			    </tr>
			    <tr>
			    	<td class="inquire_item4"><font color="red">*</font>主题:</td>
			    	<td class="inquire_form4" colspan="3"><textarea class="textarea" id="contact_title" name="contact_title" rows="" cols="" ></textarea>
			    	<!-- <input name="contact_title" id="contact_title" type="text" class="input_width" value="" /> --></td>
			    </tr>
			    <tr>
			    	<td class="inquire_item4">相关内容:</td>
			    	<td class="inquire_form4" colspan="3"><textarea class="textarea" id="contact_content" name="contact_content" rows="" cols="" ></textarea></td>
			    </tr>
		    </table> 
		</div> 
		<div id="oper_div">
			<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
		</div>
	</div> 
</div>
<script type="text/javascript">
	cruConfig.contextPath = '<%=contextPath%>';
	function refreshData(){
		var id  = '<%=company_id%>';
		cruConfig.pageSize = cruConfig.pageSizeMax;
		var querySql ="select t.contact_id ,t.contact_title ,t.contact_year ,t.contact_date ,t.contact_type ,p.company_name ,"+
		" t.contact_place ,t.contact_content ,t.company_id ,t.org_id ,inf.org_abbreviation org_name from bgp_market_contact t" +
		" left join bgp_market_oil_company p on t.company_id = p.company_id and p.bsflag='0' " +
    	" join comm_org_information inf on t.org_id = inf.org_id and inf.bsflag='0' where t.bsflag = '0' and t.contact_id = '<%=contact_id%>'";
    	retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj.returnCode=='0'){
			if(retObj.datas != null && retObj.datas.length>0){
				datas = retObj.datas[0];
				document.getElementById("contact_title").value = datas.contact_title;
				document.getElementById("contact_date").value = datas.contact_date;
				document.getElementById("contact_place").value = datas.contact_place;
				document.getElementById("company_name").value = datas.company_name;
				document.getElementById("contact_content").value = datas.contact_content;
				document.getElementById("org_id").value =datas.org_id;
				document.getElementById("org_name").value =datas.org_name;
				var obj = document.getElementById("contact_year").options ;
				for(var i=0;i<obj.length;i++){
					var option = obj[i].value;
					if(option == datas.contact_year){
						obj[i].selected = true;
						break;
					}
				}
				obj = document.getElementById("contact_type").options ;
				for(var i=0;i<obj.length;i++){
					var option = obj[i].value;
					if(option == datas.contact_type){
						obj[i].selected = true;
						break;
					}
				}
			}
		}
	}
	refreshData();
	function newSubmit() {
		if(checkValue() == false){
			return ;
		}
		var contact_id = '<%=contact_id%>';
		var company_id = document.getElementById("company_id").value;
		var user_id = document.getElementById("user_id").value;
		var contact_title = document.getElementById("contact_title").value;
		var contact_year = document.getElementById("contact_year").value;
		var contact_date = document.getElementById("contact_date").value ;
		var contact_type = document.getElementById("contact_type").value ;
		var contact_place = document.getElementById("contact_place").value ;
		var contact_content = document.getElementById("contact_content").value ;
		var org_id = document.getElementById("org_id").value ;
		var org_id = document.getElementById("org_id").value ;
		if(contact_id!=null && contact_id!=''){
			var substr = "update bgp_market_contact t set t.company_id ='"+company_id+"' ,t.updator_id='"+user_id+"' ,t.modifi_date = sysdate ," +
			" t.contact_title ='"+contact_title+"', t.contact_year ='"+contact_year+"' , t.contact_date =to_date('"+contact_date+"','yyyy-MM-dd') ,t.org_id='"+org_id+"'," +
			" t.contact_type ='"+contact_type+"' , t.contact_place ='"+contact_place+"' ,t.contact_content='"+contact_content+"' ,contact_id='"+contact_id+"'" +
			" where t.contact_id ='"+contact_id+"';" 
			if(substr!=''){
				var retObj = jcdpCallService("ClientRelationSrv", "saveClientRelation", "sql="+substr);
				if(retObj.returnCode =='0'){
					alert("保存成功!");
					var ctt = top.frames('list');
					ctt.frames[1].contact.refreshData();
					newClose(); 
				}
			}
		}else{
			var substr ="insert into bgp_market_contact(contact_id ,contact_title ,contact_year  ,contact_date ,contact_type ,"+
			" contact_place ,contact_content ,company_id ,org_id ,bsflag ,create_date,creator_id ,modifi_date ,updator_id) "+
			" values((select lower(sys_guid()) from dual),'"+contact_title+"' ,'"+contact_year+"' ,to_date('"+contact_date+"','yyyy-MM-dd') ,"+
			" '"+contact_type+"' ,'"+contact_place+"' ,'"+contact_content+"' ,'"+company_id+"' ,'"+org_id+"' ," +
			" '0' ,sysdate ,'"+user_id+"' ,sysdate ,'"+user_id+"');"
			if(substr!=''){
				var retObj = jcdpCallService("ClientRelationSrv", "saveClientRelation", "sql="+substr);
				if(retObj.returnCode =='0'){
					alert("保存成功!");
					var ctt = top.frames('list');
					ctt.frames[1].contact.refreshData();
					newClose(); 
				}
			}
		}
	}
	function checkValue(){
		var obj = document.getElementById("contact_title") ;
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("合同名称不能为空!");
			return false;
		}
		obj = document.getElementById("contact_date") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("记录日期不能为空!");
			return false;
		}
		obj = document.getElementById("contact_title") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("主题不能为空!");
			return false;
		}
		obj = document.getElementById("org_id") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("交往单位不能为空!");
			return false;
		}
	}
	function selectOrgHR(select_type , select_id , select_name){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgHR.jsp?select='+select_type,teamInfo);
	    if(teamInfo.fkValue!=""){
	        document.getElementById(select_id).value = teamInfo.fkValue;
	        document.getElementById(select_name).value = teamInfo.value;
	    }
	}
</script>
</body>
</html>