<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@ page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();

	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String duty_id = request.getParameter("duty_id");
	if(duty_id==null){
		duty_id = "";
	}
	Date date = new Date();
	int year = date.getYear()+1900;
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>新建项目</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
</head>
<body onload="queryOrg()">
<form name="form" id="form"  method="post" action="" >
<input type="hidden" id="duty_id" name="duty_id" value="<%=duty_id %>"/>
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
			<tr>
				<td class="inquire_item6">单位：</td>
		      	<td class="inquire_form6">
		      	<input type="hidden" id="second_org" name="second_org" class="input_width" />
		      	<input type="text" id="second_org2" name="second_org2" class="input_width" <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
		      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
		      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
		      	<%} %>
		      	</td>
		     	<td class="inquire_item6">基层单位：</td>
		      	<td class="inquire_form6">
		      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
		      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
		      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
		      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
		      	<%} %>
		      	</td>
		      	<td class="inquire_item6">下属单位：</td>
		      	<td class="inquire_form6">
		      	<input type="hidden" id="fourth_org" name="fourth_org" class="input_width" />
		      	<input type="text" id="fourth_org2" name="fourth_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
		      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
		      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
		      	<%}%>
		      	</td>
		    </tr>
		    <tr>
		    	<td class="inquire_item6"><font color="red">*</font>与关键岗位员工签订责任书数量：</td>
		      	<td class="inquire_form6"><input type="text" id="employee_num" name="employee_num"   class="input_width" value=""  onkeydown="return checkIfNum(event)"/></td>
	      		<td class="inquire_item6"><font color="red">*</font>录入年份：</td>
	      		<td class="inquire_form6"><select id="duty_year" name="duty_year" class="select_width">
	      					<option value="" >请选择</option>
				    <% for(int i = year ; i>=2002 ; i--){%>
					       <option value="<%=i %>" ><%=i %></option>
					<% }%>
						</select></td>

		    	<td class="inquire_item6"><font color="red">*</font>作业性质：</td>
	      		<td class="inquire_form6"><select id="task" name="task" class="select_width">
				       <option value="" >请选择</option>
				       <option value="1" >野外一线</option>
				       <option value="2" >固定场所</option>
				       <option value="3" >科研单位</option>
				       <option value="4" >培训接待</option>
				       <option value="5" >矿区</option>
					</select>
	      		</td>
	        </tr>
	        <tr>
		     	<td class="inquire_item6"><font color="red">*</font>与直线主管签订责任书数量：</td>
		      	<td class="inquire_form6"><input type="text" id="master_num" name="master_num"   class="input_width" value="" onkeydown="return checkIfNum(event)"/></td>
	      		<td class="inquire_item6"><font color="red">*</font>板块属性：</td>
	      		<td class="inquire_form6"><select id="duty_module" name="duty_module" class="select_width">
				       <option value="" >请选择</option>
				       <option value="1" >机关管理</option>
				       <option value="2" >二线</option>
				       <option value="3" >野外一线</option>
					</select>
	      		</td>
		    </tr>
		</table>
	</div>
	<div id="oper_div">
		<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
		<span class="gb_btn"><a href="#" onclick="closeButton()"></a></span>
	</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";
	//键盘上只有删除键，和左右键好用
	function noEdit(event){
		if(event.keyCode==8 || event.keyCode ==37 || event.keyCode ==39){
			return true;
		}else{
			return false;
		}
	}

	function queryOrg(){
		var retObj = jcdpCallService("HseSrv", "queryOrg", "");
		if(retObj.returnCode =='0'){
			if(retObj.list!=null){
				var len = retObj.list.length;
				if(len>0){
					document.getElementById("second_org").value=retObj.list[0].orgSubId;
					document.getElementById("second_org2").value=retObj.list[0].orgAbbreviation;
				}
				if(len>1){
					document.getElementById("third_org").value=retObj.list[1].orgSubId;
					document.getElementById("third_org2").value=retObj.list[1].orgAbbreviation;
				}
				if(len>2){
					document.getElementById("fourth_org").value=retObj.list[2].orgSubId;
					document.getElementById("fourth_org2").value=retObj.list[2].orgAbbreviation;
				}
			}
		}
		loadDataDetail();
	}
	function loadDataDetail(){
		var duty_id = '<%=duty_id%>';
		retObj = jcdpCallService("HseOperationSrv", "getDutyBookDetail", "duty_id="+duty_id);
		if(retObj.returnCode =='0'){
			var map = retObj.dutyMap;
			if(map!=null){
				document.getElementById("duty_id").value =duty_id;
				document.getElementById("second_org").value =map.second_org;
				document.getElementById("third_org").value =map.second_org;
				document.getElementById("fourth_org").value =map.fourth_org;
				document.getElementById("second_org2").value =map.second_name;
				document.getElementById("third_org2").value =map.third_name;
				document.getElementById("fourth_org2").value =map.fourth_name;
				document.getElementById("master_num").value = map.master_num;
				document.getElementById("employee_num").value = map.employee_num;
				var duty_year = document.getElementById("duty_year");
				var value = map.duty_year;
				if(duty_year!=null && duty_year.options.length>0){
					for(var i =0; i<duty_year.options.length;i++){
						var option = duty_year.options[i];
						if(value == option.value){
							option.selected = true;
						}
					}
				}
				var task = document.getElementById("task");
				var value = map.task;
				if(task!=null && task.options.length>0){
					for(var i =0; i<task.options.length;i++){
						var option = task.options[i];
						if(value == option.value){
							option.selected = true;
						}
					}
				}
				var duty_module = document.getElementById("duty_module");
				var value = map.duty_module;
				if(duty_module!=null && duty_module.options.length>0){
					for(var i =0; i<duty_module.options.length;i++){
						var option = duty_module.options[i];
						if(value == option.value){
							option.selected = true;
						}
					}
				}
			}
		}
	}
	function submitButton(){
		var form = document.getElementById("form");
		if(checkText0()){
			return;
		}
		var duty_id = document.getElementById("duty_id").value;	
		var second_org = document.getElementById("second_org").value;
		var third_org = document.getElementById("third_org").value;
		var fourth_org = document.getElementById("fourth_org").value;
		var duty_year=document.getElementById("duty_year").value;
		var task=document.getElementById("task").value;
		var duty_module=document.getElementById("duty_module").value;
		var master_num=document.getElementById("master_num").value;
		var employee_num=document.getElementById("employee_num").value;
		var substr = 'second_org='+second_org+'&third_org='+third_org +
		'&fourth_org='+fourth_org+'&duty_year='+duty_year+'&task='+task +
		'&duty_module='+duty_module+'&master_num='+master_num+'&employee_num='+employee_num;
		if(duty_id!=null && duty_id!=''){
			substr = substr +'&duty_id='+duty_id;
		}
		var obj = jcdpCallService("HseOperationSrv", "saveDutyBook", substr);
		if(obj.returnCode == '0'){
			alert("保存成功!");			
		}
		var ctt = top.frames('list');
		ctt.frames[1].refreshData();
		newClose();
	}
	
	function closeButton(){
		var ctt = top.frames('list');
		ctt.frames[1].refreshData();
		newClose();
	}
	
	function selectOrg(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId=C6000000000001',teamInfo);
	    if(teamInfo.fkValue!=""){
	    	document.getElementById("second_org").value = teamInfo.fkValue;
	        document.getElementById("second_org2").value = teamInfo.value;
	    }
	}
	
	function selectOrg2(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var second = document.getElementById("second_org").value;
		var org_id="";
		var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+second+"'";
	   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""){
		}else{
			org_id = datas[0].org_id; 
	    }
	    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
	    if(teamInfo.fkValue!=""){
	    	 document.getElementById("third_org").value = teamInfo.fkValue;
	        document.getElementById("third_org2").value = teamInfo.value;
		}
	   
	}
	
	function selectOrg3(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var third = document.getElementById("third_org").value;
		var org_id="";
		var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+third+"'";
	   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""){
		}else{
			org_id = datas[0].org_id; 
	    }
	    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
	    if(teamInfo.fkValue!=""){
	    	 document.getElementById("fourth_org").value = teamInfo.fkValue;
	        document.getElementById("fourth_org2").value = teamInfo.value;
		}
	}
	
	function checkText0(){
		var second_org2=document.getElementById("second_org2").value;
		var third_org2=document.getElementById("third_org2").value;
		var fourth_org2=document.getElementById("fourth_org2").value;
		var duty_year=document.getElementById("duty_year").value;
		var task=document.getElementById("task").value;
		var duty_module=document.getElementById("duty_module").value;
		var master_num=document.getElementById("master_num").value;
		var employee_num=document.getElementById("employee_num").value;
		/*if(second_org2==""){
			document.getElementById("second_org").value = "";
			alert("单位不能为空，请选择！");
			return true;
		}
		if(third_org2==""){
			document.getElementById("third_org").value="";
			alert("基层单位不能为空，请选择！");
			return true;
		}
		if(fourth_org2==""){
			document.getElementById("fourth_org").value="";
			alert("下属单位不能为空，请选择！");
			return true;
		} */
		
		if(second_org2==""){
			document.getElementById("second_org").value = "";
		}
		if(third_org2==""){
			document.getElementById("third_org").value="";
		}
		if(fourth_org2==""){
			document.getElementById("fourth_org").value="";
		}
		
		
		if(duty_year==""){
			alert("录入年份不能为空，请选择！");
			return true;
		}
		if(task==""){
			alert("作业性质不能为空，请选择！");
			return true;
		}
		if(duty_module==""){
			alert("板块属性不能为空，请选择！");
			return true;
		}
		if(master_num==""){
			alert("与直线主管签订责任书数量不能为空，请填写！");
			return true;
		}
		if(employee_num==""){
			alert("与关键岗位员工签订责任书数量不能为空，请填写！");
			return true;
		}
		return false;
	}
	/* 输入的是否是数字 */
	function checkIfNum(event){
		var element = event.srcElement;
		if(element.value != null && element.value =='0' && (event.keyCode>=48 && event.keyCode<=57)){
			element.value = '';
		}
		if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8 || event.keyCode ==37 || event.keyCode ==39 || event.keyCode ==9){
			return true;
		}
		else{
			return false;
		}
	}
</script>
</html>