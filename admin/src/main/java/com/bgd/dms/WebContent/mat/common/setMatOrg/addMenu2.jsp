<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();

	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String parentMenuId = request.getParameter("id");
	System.out.println(parentMenuId);
	String pagerAction = request.getParameter("pagerAction");
	if(pagerAction==null){
		pagerAction = "";
	}
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新建项目</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
</head>
<body onload="toEdit()">
<form name="form" id="form"  method="post" action="" >
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
					<input type="hidden" id="fatherMatMenuId" name="fatherMatMenuId" value="<%=parentMenuId %>" />
					<input type="hidden" id="pagerAction" name="pagerAction" value="<%=pagerAction %>" />
					 	<tr>
				      		<td class="inquire_item6"><font color="red">*</font>名称:</td>
				      		<td class="inquire_form6"><input type="text" id="menu_name" name="menu_name" class="input_width"></input></td>
				      		</tr>
				      		<tr>
				      		<td class="inquire_item6"><font color="red">*</font>从属单位:</td>
				      		<td class="inquire_form6">
				      		<input type="hidden" id="org_subjection_id" name="org_subjection_id" ></input>
				      		<input type="hidden" id="org_id" name="org_id"></input>
				      		<input type="text" id="org_name" name="org_name"  class="input_width" readonly="readonly" onkeydown="return noEdit(event)"></input>
				      		<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
				      		</td>
				      	</tr>
				      	<tr>
				      		<td class="inquire_item6" style="width: 20%"><font color="red">*</font>是否叶子节点:</td>
				      		<td class="inquire_form6" style="width: 80%">
				      			<select id="is_leaf" name="is_leaf" class=""  class="select_width" >
									<option value="1">是</option>
									<option value="0">否</option>
								</select>
				      		</td>
				      		</tr>
				      		<tr>
				      		<td class="inquire_item6" style="width: 20%">序号:</td>
				      		<td class="inquire_form6" style="width: 80%"><input type="text" id="order_num" name="order_num" class="input_width"></input></td>
				      	</tr>
				      	<tr>
				      		<td class="inquire_item6" style="width: 20%">备注:</td>
				      		<td class="inquire_form6" style="width: 80%"><textarea class="textarea" id="memo" name="memo"></textarea></td>
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

//var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
//var showTabBox = document.getElementById("tab_box_content0");


cruConfig.contextPath =  "<%=contextPath%>";
//键盘上只有删除键，和左右键好用
function noEdit(event){
	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
		return true;
	}else{
		return false;
	}
}

function submitButton(){
	var form = document.getElementById("form");
		if(checkText()){
			return;
		}
	form.action="<%=contextPath%>/mat/buss/saveMatBuss.srq";
	form.submit();
}

function closeButton(){
	
	newClose();
}

function selectOrg(){
    var teamInfo = {
        orgId:"",
        orgSubjectionId:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/mat/common/setMatOrg/selectOrgHR.jsp',teamInfo);
    if(teamInfo.orgSubjectionId!=""){
    	document.getElementById("org_subjection_id").value = teamInfo.orgSubjectionId;
        document.getElementById("org_id").value = teamInfo.orgId;
        document.getElementById("org_name").value = teamInfo.value;
    }
}


function toEdit(){
	var pagerAction = "<%=pagerAction%>";
	if(pagerAction=="edit"){
		debugger;
		var querySql = "select t.*,oi.org_abbreviation from gms_mat_buss_menu t join comm_org_information oi on oi.org_id=t.org_id and oi.bsflag='0' where t.mat_menu_id='<%=parentMenuId%>' and t.bsflag='0'";
		var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
		if(queryOrgRet.datas.length != 0){
			document.getElementById("menu_name").value = queryOrgRet.datas[0].menu_name; 
			document.getElementById("org_subjection_id").value = queryOrgRet.datas[0].org_subjection_id; 
			document.getElementById("org_id").value = queryOrgRet.datas[0].org_id; 
			document.getElementById("org_name").value = queryOrgRet.datas[0].org_abbreviation; 
			document.getElementById("is_leaf").value = queryOrgRet.datas[0].is_leaf; 
			document.getElementById("order_num").value = queryOrgRet.datas[0].order_num; 
			document.getElementById("memo").value = queryOrgRet.datas[0].memo; 
		}
	}
}

function checkText(){
	var menu_name=document.getElementById("menu_name").value;
	var org_id=document.getElementById("org_id").value;
	var org_name=document.getElementById("org_name").value;
	var order_num=document.getElementById("order_num").value;
	if(org_name==""){
		document.getElementById("org_id").value = "";
		document.getElementById("org_subjection_id").value = "";
	}
	if(menu_name==""){
		alert("名称不能为空，请填写！");
		return true;
	}
	if(org_id==""){
		alert("从属单位不能为空，请选择！");
		return true;
	}
	
	var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  

    if (!re.test(order_num))
   {
       alert("序号请输入数字！");
       return true;
    }
	return false;
}




</script>
</html>