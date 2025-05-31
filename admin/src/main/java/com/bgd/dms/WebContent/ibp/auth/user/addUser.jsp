<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<%@ include file="/common/pmd_add.jsp"%>
<!--Remark JavaScript定义-->
<SCRIPT language=javaScript>
var cruTitle = "新建--用户";
var userStatus = new Array(
['0','有效'],['1','禁用'],['2','作废']
);
var ifAdmin = new Array(
['0','否'],['1','是']
);

var jcdp_codes_items = null;
var jcdp_codes = new Array(
);

var jcdp_record = null;
/**0字段名，1显示label，2是否显示或编辑：Hide,Edit,ReadOnly，
   3字段类型：TEXT(文本),N(整数),NN(数字),D(日期),EMAIL,ET(英文)，
             MEMO(备注)，SEL_Codes(编码表),SEL_OPs(自定义下拉列表) ，FK(外键型)，
   4最大输入长度，
   5默认值：'CURRENT_DATE'当前日期，'CURRENT_DATE_TIME'当前日期时间，
           编辑或修改时如果为空表示取0字段名对应的值，'{ENTITY.fieldName}'表示取fieldName对应的值，
           其他默认值
   6输入框的长度，7下拉框的值或弹出页面的链接，8 是否非空，取值为non-empty会在输入框后加*
   9 Column Name，10 Event,11 Table Name
*/
var fields = new Array(
['JCDP_TABLE_NAME',null,'Hide','TEXT',null,'p_auth_user']
,['emp_id','名称','Edit','FK',,,,'<%=contextPath%>/common/selectEmployee.jsp,getEmpInfo','non-empty',,]
,['login_id','登陆ID','Edit','TEXT',,,,,,,]
,['user_pwd','密码','Edit','TEXT',,,,,'',,]
,['user_name','名称','Hide','TEXT',,,,,,,]
,['org_id','组织机构ID','Hide','TEXT',,,,,,,]
,['email','EMail','Edit','EMAIL',,,,,,,]
,['user_status','user_status','Hide','TEXT',,,,,,,]
,['if_admin','是否管理员','Edit','SEL_OPs',,,,ifAdmin,,,]
,['modifi_date','修改时间','Hide','D',,'CURRENT_DATE_TIME',,,,,]
,['bsflag','','Hide','TEXT',,'0',,,,,]
);
var uniqueFields = ':emp_id:login_id:';
var fileFields = ':';

function getEmpInfo(){
	var empIdObj=getObj("emp_id");
    var emp_id = empIdObj.fkValue; 
       //if(emp_id=='')return;
    var querySql = "SELECT t.org_id,nvl(t.mail_address,'')as email,oi.org_name as org_name,u.login_id,u.bsflag FROM comm_human_employee t left join comm_org_information oi on t.org_id=oi.org_id and oi.bsflag='0' left join p_auth_user u on u.emp_id=t.employee_id where t.employee_id='"+emp_id+"'"; 
    var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql); 
    var login_id = queryOrgRet.datas[0].login_id;
    var bsflag = queryOrgRet.datas[0].bsflag;
	if(login_id!='' && bsflag=='0'){
		alert('已经为此员工建立过账户 '+login_id);
		empIdObj.fkValue='';
		empIdObj.value='';
		return false;
	}
	empIdObj.readOnly=false;
    getObj('org_id').value = queryOrgRet.datas[0].org_id;
    getObj('org_name').value = queryOrgRet.datas[0].org_name;
	var email = queryOrgRet.datas[0].email;
	if(email!='' && email.indexOf('@')>0){
		//if(getObj('login_id').value==''){
			getObj('email').value = email;
		//}
		//if(getObj('login_id').value==''){
			getObj('login_id').value = email.substr(0,email.indexOf('@'));
		//}
	}
	
}
	

function page_init(){
	getObj('cruTitle').innerHTML = cruTitle;
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.openerUrl = "/ibp/auth/user/userList.jsp";
	//cru_init();
}

function submitFunc(){
	var login_id = getObj('login_id').value;
	var querySql = "SELECT count(u.login_id) as num FROM p_auth_user u where u.login_id='"+login_id+"' and u.bsflag='0'"; 
    var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql); 
    var num = queryOrgRet.datas[0].num;
	if(num>0){
		alert(login_id+'已经存在');
		return false;
	}

	getObj('user_name').value = getObj('emp_id').value;
	
	var first_user_pwd_input = getObj('first_user_pwd');
	var second_user_pwd_input = getObj('second_user_pwd'); 
	var first_user_pwd = first_user_pwd_input.value;
	var second_user_pwd = second_user_pwd_input.value;
	
	if(first_user_pwd!='' && second_user_pwd!=''){
		if(first_user_pwd==second_user_pwd){

			if(first_user_pwd.length<8){
				alert("新密码长度最短为8位，请重新输入！");
				return false ;
			}
			
			if(first_user_pwd.length>20){
				alert("新密码长度最长为20位，请重新输入！");
				return false;
			}

			var reg = /\S*\d+\S*/;
			if(!reg.exec(first_user_pwd)){
				alert("新密码至少要包含一位数字，请重新输入！");
				return false;
			}

			reg = /\S*[a-zA-Z]+\S*/;
			if(!reg.exec(first_user_pwd)){
				alert("新密码至少要包含一位字母，请重新输入！");
				return false;
			}
			
			//getObj('user_pwd').value = BASE64encode(first_user_pwd);
		}else{
			alert("两次输入的密码不一致，请重新输入！");
			second_user_pwd_input.value="";
			first_user_pwd_input.value="";
			first_user_pwd_input.focus();
			return false;
		}
	}else if(first_user_pwd!='' && second_user_pwd==''){
		alert("请再次输入密码！");
		second_user_pwd_input.focus();
		return false;
	}else if(first_user_pwd=='' && second_user_pwd!=''){
		alert("请输入密码！");
		first_user_pwd_input.focus();
		return false;
	}
	
	var path = "<%=contextPath%>/common/auth/user/addOrUpdateUser.srq";
	submitStr = getSubmitStr();
	//alert(submitStr);
	if(submitStr == null) return;
	var retObject = syncRequest('Post',path,submitStr);

	afterSubmit(retObject);
}

function afterSubmit(retObject,successHint,failHint){
	if(successHint==undefined) successHint = '提交成功';
	if(failHint==undefined) failHint = '提交失败';
	if (retObject.returnCode != "0") alert(failHint);
	else{
		window.location = cruConfig.contextPath+cruConfig.openerUrl;
	}
}

</SCRIPT>
</head>
<body onload="page_init()">
	<TABLE class=Tab_page_title border=0 cellSpacing=0 cellPadding=0>
		<TBODY>
			<TR>
				<TD height=1 colSpan=4 align=left></TD></TR>
			<TR>
				<TD height=28 width="5%" align=left><IMG src="<%=contextPath%>/images/oms_index_09.gif" width="100%" height=28></TD>
				<TD id=cruTitle class=text11 background=<%=contextPath%>/images/oms_index_11.gif width="40%" align=left>新建--用户</TD>
				<TD width="5%" align=left><IMG src="<%=contextPath%>/images/oms_index_13.gif" width="100%" height=28></TD>
				<TD style="BACKGROUND: url(<%=contextPath%>/images/oms_index_14.gif) repeat-x" width="50%" align=left>&nbsp;</TD>
			</TR>
		</TBODY>
	</TABLE>
	<FORM encType=multipart/form-data method=post name=fileForm target=hidden_frame>
		<TABLE id=rtCRUTable class=form_info border=0 cellSpacing=0 cellPadding=0>
			<SPAN style="DISPLAY: none" id=hiddenFields>
				<INPUT value=p_auth_user type=hidden name=JCDP_TABLE_NAME>
				<INPUT type=hidden name=user_name>
				<INPUT type=hidden name=org_id>
				<INPUT type=hidden name=user_pwd value="abcd1234">
				<INPUT value=0 type=hidden name=user_status>
				<INPUT name=modifi_date value=CURRENT_DATE_TIME type=hidden>
				<INPUT name=bsflag value=0 type=hidden>
			</SPAN>
			<TBODY>
				<TR>
					<TD class=rtCRUFdName><FONT color=red>*</FONT>&nbsp;名称：</TD>
					<TD class=rtCRUFdValue><INPUT class=input_width dataFld=1 size=18 name=emp_id readonly MAXLENGTH=50> <IMG style="CURSOR: hand" onclick="popFKWindow('<%=contextPath%>/common/selectEmployee.jsp,getEmpInfo','emp_id')" src="<%=contextPath%>/images/magnifier.gif"></TD>
					<TD class=rtCRUFdName><FONT color=red>*</FONT>&nbsp;登陆ID：</TD>
					<TD class=rtCRUFdValue><INPUT class=input_width dataFld=2 name=login_id MAXLENGTH=16 style='ime-mode:disabled'></TD>
				</TR>
				<TR>
					<TD class=rtCRUFdName>组织机构：</TD>
					<TD class=rtCRUFdValue><INPUT class=input_width id=org_name readonly></TD>
					<TD class=rtCRUFdName>EMail：</TD>
					<TD class=rtCRUFdValue><INPUT class=input_width dataFld=6 name=email MAXLENGTH=50></TD>
				</TR>
				<TR>
					<TD class=rtCRUFdName>密码：</TD>
					<TD class=rtCRUFdValue><INPUT type=password class=input_width id=first_user_pwd></TD>
					<TD class=rtCRUFdName>确认密码：</TD>
					<TD class=rtCRUFdValue><INPUT type=password class=input_width id=second_user_pwd></TD>
				</TR>
				<TR>
					<TD class=rtCRUFdName>是否管理员：</TD>
					<TD class=rtCRUFdValue>
						<select name="if_admin" class=input_width>
							<option value="0">否</option>
							<option value="1">是</option>
						</select>
					</TD>
					<TD class=rtCRUFdName>&nbsp;</TD>
					<TD class=rtCRUFdValue>&nbsp;</TD>
				</TR>
				<TR>
				
					<TD class=ali4 colSpan=4>
						<INPUT class=iButton2 onclick=submitFunc(); value=确定 type=button name=Submit> 
						<INPUT class=iButton2 onclick=window.history.back(); value=取消 type=button name=Submit>
					</TD>
				</TR>
				<tr>
					<td width="100%" align="left" colspan="4" style="padding-left:50px;">
						密码规则：<br>
						1、密码长度最短8位，最长20位。<br>
						2、密码至少要包含一位数字和一位字母。<br>
						3、如果不输入密码，默认为abcd1234。
					</td>
				</tr>
			</TBODY>
		</TABLE>
	</FORM>
	<IFRAME height=1 marginHeight=0 frameBorder=0 width=1 name=hidden_frame marginWidth=0 scrolling=no></IFRAME>
</body>
</html>
