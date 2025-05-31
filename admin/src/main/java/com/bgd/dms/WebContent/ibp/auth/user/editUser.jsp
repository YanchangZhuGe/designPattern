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
<script type="text/javascript" src="<%=contextPath %>/js/Base64.js"></script>
<%@ include file="/common/pmd_edit.jsp"%>
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
,['user_name','����','Edit','TEXT',,,,,'non-empty',,]
,['user_pwd','����','Edit','TEXT',,,,,'',,]
,['email','EMail','Edit','EMAIL',,,,,,,]
,['user_status','״̬','Edit','TEXT',,,,,,,]
,['if_admin','�Ƿ����Ա','Edit','SEL_OPs',,,,ifAdmin,,,]
,['modifi_date','�޸�ʱ��','Hide','D',,'CURRENT_DATE_TIME',,,,,]
);
var uniqueFields = ':emp_id:login_id:';
var fileFields = ':';

function page_init(){
	getObj('cruTitle').innerHTML = cruTitle;
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.openerUrl = "/ibp/auth/user/userList.jsp";
	cruConfig.querySql = "SELECT u.*,oi.org_abbreviation as org_name FROM p_auth_user u left join comm_org_information oi on u.org_id=oi.org_id and oi.bsflag='0' WHERE u.user_id='<%=request.getParameter("id")%>'";

	path = cruConfig.contextPath+appConfig.queryListAction;
	var queryRet = syncRequest('Post',path,'querySql='+cruConfig.querySql);
	jcdp_record = queryRet.datas[0];
	if(jcdp_record!=null){
		getObj('user_id').value=jcdp_record.user_id;
		getObj('user_pwd').value=jcdp_record.user_pwd;
		getObj('user_name').value=jcdp_record.user_name;
		getObj('login_id').value=jcdp_record.login_id;		
		getObj('org_name').value=jcdp_record.org_name;
		getObj('email').value=jcdp_record.email;
		getObj('if_admin').value=jcdp_record.if_admin;
		getObj('user_status').value=jcdp_record.user_status;
		getObj('org_id').value=jcdp_record.org_id;
		
		var set_user_status = getObj('set_user_status');
		for(var i=0;i<set_user_status.length;i++){
			if(set_user_status[i].value==jcdp_record.user_status){
				set_user_status.selectedIndex=i;
				break;
			}
		}

		var set_if_admin = getObj('set_if_admin');
		for(var i=0;i<set_if_admin.length;i++){
			if(set_if_admin[i].value==jcdp_record.if_admin){
				set_if_admin.selectedIndex=i;
				break;
			}
		}
	}
	//cru_init();
}

function submitFunc(){
	
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
			alert("��������������벻һ�£����������룡");
			second_user_pwd_input.value="";
			first_user_pwd_input.value="";
			first_user_pwd_input.focus();
			return false;
		}
	}else if(first_user_pwd!='' && second_user_pwd==''){
		alert("���ٴ����������룡");
		second_user_pwd_input.focus();
		return false;
	}else if(first_user_pwd=='' && second_user_pwd!=''){
		alert("�����������룡");
		first_user_pwd_input.focus();
		return false;
	}
	
	var path = '<%=contextPath%>/common/auth/user/addOrUpdateUser.srq';
	submitStr = getSubmitStr();
	//alert(submitStr);return;
	if(submitStr == null) return;
	if(first_user_pwd!=''){
		submitStr = submitStr+"&new_user_pwd="+first_user_pwd;
	}
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
				<INPUT type=hidden name=user_id>
				<INPUT type=hidden name=user_pwd>
				<INPUT type=hidden name=org_id>
				<INPUT value=0 type=hidden name=user_status>
				<INPUT value=0 type=hidden name=if_admin>
				<INPUT name=modifi_date value=CURRENT_DATE_TIME type=hidden>
			</SPAN>
			<TBODY>
				<TR>
					<TD class=rtCRUFdName><font color='red'>*</font>&nbsp;���ƣ�</TD>
					<TD class=rtCRUFdValue><INPUT class=input_width size=18 name=user_name dataFld=1 MAXLENGTH=50></TD>
					<TD class=rtCRUFdName>��½ID��</TD>
					<TD class=rtCRUFdValue><INPUT class=input_width id=login_id readonly></TD>
				</TR>
				<TR>
					<TD class=rtCRUFdName>��֯������</TD>
					<TD class=rtCRUFdValue><INPUT class=input_width id=org_name readonly></TD>
					<TD class=rtCRUFdName>EMail��</TD>
					<TD class=rtCRUFdValue><INPUT class=input_width dataFld=2 name=email MAXLENGTH=50></TD>
				</TR>
				<TR>
					<TD class=rtCRUFdName>�����룺</TD>
					<TD class=rtCRUFdValue><INPUT type=password class=input_width id=first_user_pwd></TD>
					<TD class=rtCRUFdName>ȷ�������룺</TD>
					<TD class=rtCRUFdValue><INPUT type=password class=input_width id=second_user_pwd></TD>
				</TR>
				<TR>
					<TD class=rtCRUFdName>�Ƿ����Ա��</TD>
					<TD class=rtCRUFdValue><select class="input_width" id="set_if_admin" onchange="getObj('if_admin').value=this.value"><option value=0>��</option><option value=1>��</option></select></TD>
					<TD class=rtCRUFdName>״̬��</TD>
					<TD class=rtCRUFdValue><select class="input_width" id="set_user_status" onchange="getObj('user_status').value=this.value"><option value=0>��Ч</option><option value=1>����</option><option value=2>����</option></select></TD>
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
						3��������������룬�����޸�ԭ�������롣
					</td>
				</tr>
			</TBODY>
		</TABLE>
	</FORM>
	<IFRAME height=1 marginHeight=0 frameBorder=0 width=1 name=hidden_frame marginWidth=0 scrolling=no></IFRAME>
</body>
</html>
