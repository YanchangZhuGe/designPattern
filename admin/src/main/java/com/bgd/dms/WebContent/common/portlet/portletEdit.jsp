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
	String portlet_id = request.getParameter("portlet_id");
	if(portlet_id==null){
		portlet_id = "";
	}
	String category_id = request.getParameter("category_id");
	if(category_id==null){
		category_id = "";
	}
	String category_name = request.getParameter("category_name");
	if(category_name==null){
		category_name = "";
	}
	String level = request.getParameter("level");
	if(level==null){
		level = "";
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
					<input type="hidden" name="portlet_id" id="portlet_id" value="<%=portlet_id %>" class="input_width" />
					<input type="hidden" name="category_id" id="category_id" value="<%=category_id %>" class="input_width" />
					<tr>
					    <td class="inquire_item4">Portlet分类:</td>
					    <td class="inquire_form4"><input type="text" name="category_name" id="category_name" value="<%=category_name %>" class="input_width" readonly="readonly"  /></td>
					   	<td class="inquire_item4"><font color="red">*</font>Portlet名称:</td>
					    <td class="inquire_form4"><input type="text" name="portlet_name" id="portlet_name" value="" class="input_width"/></td>
					</tr>
					<tr>   	
					   	<td class="inquire_item4"><font color="red">*</font>Portlet地址:</td>
					   	<td class="inquire_form4"><input type="text" name="portlet_url" id="portlet_url" value="" class="input_width" /></td>
					    <td class="inquire_item4"><font color="red">*</font>Portlet级别:</td>
					    <td class="inquire_form4"><select id="portlet_level" name="portlet_level" class="select_width">
									<option value="">请选择</option>
									<option value="1">公司级</option>
									<option value="2">物探处级</option>
									<option value="3">项目级</option>
								</select></td>
	    			</tr>
					<tr>
						<td class="inquire_item4">Portlet说明:</td>
					    <td class="inquire_form4" colspan="3"><textarea rows="4" cols="10" id="portlet_desc" name="portlet_desc" class="textarea"></textarea></td>
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
		var portlet_id = '<%=portlet_id%>';
		var level ='<%=level%>';
		if(level!=0){
			document.getElementById("portlet_level").disabled = true;
		}else{
			document.getElementById("portlet_level").removeAttribute("disabled");
		}
		document.getElementById("portlet_level").options[level].selected = true;
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
					var portlet_level =  map.portlet_level;
					document.getElementById("portlet_level").options[portlet_level].selected = true;
					document.getElementById("portlet_desc").value = map.portlet_desc;
				}
			}
		}
	}
	refreshData();
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
			" t.portlet_level ='"+portlet_level+"' ,t.portlet_desc='"+portlet_desc+"' where t.portlet_id='"+portlet_id+"';";
			retObj = jcdpCallService("PortletSrv", "savePortletBySql", "sql="+substr);
		}
		if(retObj!=null && retObj.returnCode=='0'){
			alert("保存成功!") 
			parent.frames['indexFrame'].frames['list'][1].refreshData(category_id ,category_name);
			newClose();
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