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
<!--Remark JavaScript����-->
<SCRIPT language=javaScript>
var cruTitle = "�½�--�û�";
var userStatus = new Array(
['0','��Ч'],['1','����'],['2','����']
);
var ifAdmin = new Array(
['0','��'],['1','��']
);

var jcdp_codes_items = null;
var jcdp_codes = new Array(
);

var jcdp_record = null;
/**0�ֶ�����1��ʾlabel��2�Ƿ���ʾ��༭��Hide,Edit,ReadOnly��
   3�ֶ����ͣ�TEXT(�ı�),N(����),NN(����),D(����),EMAIL,ET(Ӣ��)��
             MEMO(��ע)��SEL_Codes(�����),SEL_OPs(�Զ��������б�) ��FK(�����)��
   4������볤�ȣ�
   5Ĭ��ֵ��'CURRENT_DATE'��ǰ���ڣ�'CURRENT_DATE_TIME'��ǰ����ʱ�䣬
           �༭���޸�ʱ���Ϊ�ձ�ʾȡ0�ֶ�����Ӧ��ֵ��'{ENTITY.fieldName}'��ʾȡfieldName��Ӧ��ֵ��
           ����Ĭ��ֵ
   6�����ĳ��ȣ�7�������ֵ�򵯳�ҳ������ӣ�8 �Ƿ�ǿգ�ȡֵΪnon-empty�����������*
   9 Column Name��10 Event,11 Table Name
*/
var fields = new Array(
['JCDP_TABLE_NAME',null,'Hide','TEXT',null,'p_auth_user']
,['emp_id','����','Edit','FK',,,,'<%=contextPath%>/common/selectEmployee.jsp,getEmpInfo','non-empty',,]
,['login_id','��½ID','Edit','TEXT',,,,,,,]
,['user_pwd','����','Edit','TEXT',,,,,'',,]
,['user_name','����','Hide','TEXT',,,,,,,]
,['org_id','��֯����ID','Hide','TEXT',,,,,,,]
,['email','EMail','Edit','EMAIL',,,,,,,]
,['user_status','user_status','Hide','TEXT',,,,,,,]
,['if_admin','�Ƿ����Ա','Edit','SEL_OPs',,,,ifAdmin,,,]
,['modifi_date','�޸�ʱ��','Hide','D',,'CURRENT_DATE_TIME',,,,,]
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
		alert('�Ѿ�Ϊ��Ա���������˻� '+login_id);
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
		alert(login_id+'�Ѿ�����');
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
				alert("�����볤�����Ϊ8λ�����������룡");
				return false ;
			}
			
			if(first_user_pwd.length>20){
				alert("�����볤���Ϊ20λ�����������룡");
				return false;
			}

			var reg = /\S*\d+\S*/;
			if(!reg.exec(first_user_pwd)){
				alert("����������Ҫ����һλ���֣����������룡");
				return false;
			}

			reg = /\S*[a-zA-Z]+\S*/;
			if(!reg.exec(first_user_pwd)){
				alert("����������Ҫ����һλ��ĸ�����������룡");
				return false;
			}
			
			//getObj('user_pwd').value = BASE64encode(first_user_pwd);
		}else{
			alert("������������벻һ�£����������룡");
			second_user_pwd_input.value="";
			first_user_pwd_input.value="";
			first_user_pwd_input.focus();
			return false;
		}
	}else if(first_user_pwd!='' && second_user_pwd==''){
		alert("���ٴ��������룡");
		second_user_pwd_input.focus();
		return false;
	}else if(first_user_pwd=='' && second_user_pwd!=''){
		alert("���������룡");
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
	if(successHint==undefined) successHint = '�ύ�ɹ�';
	if(failHint==undefined) failHint = '�ύʧ��';
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
				<TD id=cruTitle class=text11 background=<%=contextPath%>/images/oms_index_11.gif width="40%" align=left>�½�--�û�</TD>
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
					<TD class=rtCRUFdName><FONT color=red>*</FONT>&nbsp;���ƣ�</TD>
					<TD class=rtCRUFdValue><INPUT class=input_width dataFld=1 size=18 name=emp_id readonly MAXLENGTH=50> <IMG style="CURSOR: hand" onclick="popFKWindow('<%=contextPath%>/common/selectEmployee.jsp,getEmpInfo','emp_id')" src="<%=contextPath%>/images/magnifier.gif"></TD>
					<TD class=rtCRUFdName><FONT color=red>*</FONT>&nbsp;��½ID��</TD>
					<TD class=rtCRUFdValue><INPUT class=input_width dataFld=2 name=login_id MAXLENGTH=16 style='ime-mode:disabled'></TD>
				</TR>
				<TR>
					<TD class=rtCRUFdName>��֯������</TD>
					<TD class=rtCRUFdValue><INPUT class=input_width id=org_name readonly></TD>
					<TD class=rtCRUFdName>EMail��</TD>
					<TD class=rtCRUFdValue><INPUT class=input_width dataFld=6 name=email MAXLENGTH=50></TD>
				</TR>
				<TR>
					<TD class=rtCRUFdName>���룺</TD>
					<TD class=rtCRUFdValue><INPUT type=password class=input_width id=first_user_pwd></TD>
					<TD class=rtCRUFdName>ȷ�����룺</TD>
					<TD class=rtCRUFdValue><INPUT type=password class=input_width id=second_user_pwd></TD>
				</TR>
				<TR>
					<TD class=rtCRUFdName>�Ƿ����Ա��</TD>
					<TD class=rtCRUFdValue>
						<select name="if_admin" class=input_width>
							<option value="0">��</option>
							<option value="1">��</option>
						</select>
					</TD>
					<TD class=rtCRUFdName>&nbsp;</TD>
					<TD class=rtCRUFdValue>&nbsp;</TD>
				</TR>
				<TR>
				
					<TD class=ali4 colSpan=4>
						<INPUT class=iButton2 onclick=submitFunc(); value=ȷ�� type=button name=Submit> 
						<INPUT class=iButton2 onclick=window.history.back(); value=ȡ�� type=button name=Submit>
					</TD>
				</TR>
				<tr>
					<td width="100%" align="left" colspan="4" style="padding-left:50px;">
						�������<br>
						1�����볤�����8λ���20λ��<br>
						2����������Ҫ����һλ���ֺ�һλ��ĸ��<br>
						3��������������룬Ĭ��Ϊabcd1234��
					</td>
				</tr>
			</TBODY>
		</TABLE>
	</FORM>
	<IFRAME height=1 marginHeight=0 frameBorder=0 width=1 name=hidden_frame marginWidth=0 scrolling=no></IFRAME>
</body>
</html>
