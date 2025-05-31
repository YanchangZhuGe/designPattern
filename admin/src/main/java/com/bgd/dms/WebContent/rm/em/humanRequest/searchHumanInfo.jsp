<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%

	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubjectionId = user.getOrgSubjectionId();
	String orgName = user.getOrgName();
%>
<html>
<%@ include file="/common/jspHeader.jsp"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/rm/em/humanRequest/DivHiddenOpen.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-en.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  
<%@ include file="/common/pmd_list.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>�б�ҳ��</title>
</head>
<script language="javaScript">
<!--Remark JavaScript����-->
var pageTitle = "��Ա������Ϣ";
cruConfig.contextPath =  "<%=contextPath%>";

var personOps = new Array(
		['����Ŀ','����Ŀ'],['������Ŀ','������Ŀ']
	)
var deployOps = new Array(
		['1','������'],['2','�ѵ���'],['0','δ����']
	)
var sex = new Array(
		['0','Ů'],['1','��']
	)
var jcdp_codes_items = null;
var jcdp_codes = new Array(
);

function expData(){
	var orgId = "";
	if(document.getElementById("orgId").value != ""){
		orgId=document.getElementById("orgId").value;
	}
	
}

function viewLink(employeeId){
    editUrl = "/rm/em/humanCommInfoAction.srq?employeeId="+employeeId; 
    window.location=cruConfig.contextPath+editUrl+"&backUrl="+cruConfig.currentPageUrl; 
}
	
var queryListAction = "/tcg/ajaxServiceProxyAction.srq?JCDP_SRV_NAME=HumanRequiredSrv&JCDP_OP_NAME=searchforHumanInfo&funcCode=F_EM_HUMAN_035&params=";

function page_init(){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.funcCode = "F_EM_HUMAN_035";
	cruConfig.cdtType = 'form';
	cdt_init();
	
	if(window.dialogArguments!=null){
		var flag =window.dialogArguments.flag;
		if(flag=="true"){
			document.getElementById("lidiv").style.display="none"; 
			document.getElementById("alldiv").style.display=""; 	
		}
	}
	
	appConfig.queryListAction = queryListAction;	
//	cruConfig.queryStr = "select distinct rownum, e.employee_id,  e.employee_name, e.employee_gender, decode(e.employee_gender, '0', 'Ů', '1', '��') employee_gender_name,  decode(hr.person_status, '0', '', '1',i1.org_abbreviation , '') relief_org_name,hr.relief_org,  (to_char(sysdate, 'yyyy') -  to_char(e.employee_birth_date, 'yyyy')) age, e.org_id,  i.org_abbreviation,  i.org_name,  hr.post, hr.spare2,   hr.employee_cd,hr.set_team,hr.set_post,d1.coding_name set_team_name,d2.coding_name set_post_name,decode((to_char(sysdate, 'yyyy') - to_char(hr.work_date, 'yyyy')),  '0', '1',(to_char(sysdate, 'yyyy') - to_char(hr.work_date, 'yyyy'))) work_age,  s.org_subjection_id , decode(nvl(hr.deploy_status,'0'),'0','','1','������','2','�ѵ���','') deploy_status_name, nvl(hr.deploy_status,'0') deploy_status, decode(hr.person_status,'0','������Ŀ','1','����Ŀ','������Ŀ') person_status ,decode(hr.person_status, '0', '', '1', to_char(t2.plan_end_date,'yyyy-MM-dd'), '') plan_end_date,  t2.team, t2.work_post,t4.actual_start_date,t4.actual_end_date,t4.project_name from comm_human_employee e   inner join comm_human_employee_hr hr on e.employee_id = hr.employee_id  and hr.bsflag = '0'     left join comm_org_subjection s on e.org_id = s.org_id   and s.bsflag = '0'   left join comm_org_information i on e.org_id = i.org_id    and i.bsflag = '0'  left join comm_org_information i1 on hr.relief_org = i1.org_id and i1.bsflag = '0'   left join comm_coding_sort_detail d1 on hr.set_team=d1.coding_code_id  left join comm_coding_sort_detail d2 on hr.set_post=d2.coding_code_id left join (select * from (select employee_id,team,work_post, plan_end_date, row_number() over(partition by employee_id order by plan_end_date desc) r  from bgp_human_prepare_human_detail) t1 where t1.r=1) t2 on e.employee_id=t2.employee_id left join (select t3.*,p1.project_name from (select employee_id,project_info_no, actual_start_date,actual_end_date,  row_number() over(partition by employee_id order by actual_start_date desc) r from bgp_project_human_relation where bsflag='0' and locked_if = '1' ) t3 left join gp_task_project p1 on t3.project_info_no = p1.project_info_no  where t3.r = 1) t4 on e.employee_id = t4.employee_id where e.bsflag = '0' order by rownum";
	cruConfig.currentPageUrl = "/rm/em/humanRequest/searchHumanInfo.jsp";
	classicQuery();
	

	

}
var numTimes = 0;

function classicQuery(){
	var qStr = generateClassicQueryStr();
	
	var age1=document.getElementById("age1").value;
	var age2=document.getElementById("age2").value;
	var work_age1=document.getElementById("work_age1").value;
	var work_age2=document.getElementById("work_age2").value;
	var orgId=document.getElementById("orgId").value;
	var post=document.getElementById("post").value;
	var setWork=document.getElementById("setWork").value;
	var setPost=document.getElementById("setPost").value;
	var employeeCd=document.getElementById("employeeCd").value;
	var spare2 = "";
	if(document.getElementById("spare2") != null){
		spare2=document.getElementById("spare2").value;
	}
	if(window.dialogArguments!=null){
		var flag =window.dialogArguments.flag;
		var postname =window.dialogArguments.postname;
		if(flag=="false"){
			//��ѡ��
			if(postname!=""){
				if(numTimes==0){//�ж�Ϊ�˿���ֻ�е�һ�ν���ҳ��ʱ���մ���ĸ�λ��ѯ��֮�󶼰���ҳ���ϵĸ�λ��ѯ������ѯ
					post = postname;
					document.getElementById("post").value=postname;
					numTimes = 1;
				}
			}
		}
		if(flag=="true"&&orgId==""){
			//��������Ա����
			orgId =window.dialogArguments.applyCompanySub;			
			document.getElementById("orgId").value = window.dialogArguments.applyCompanySub;			
			document.getElementById("orgName").value = window.dialogArguments.applicantOrgSubName;			
		}
	}

	if(qStr==""){
		qStr+=" and (1=1";
	}else{
		qStr = " and " + qStr;
		qStr+=" and (1=1";
	}
	
	if(age1!=""){
		qStr=qStr +" and age >= "+age1;
	}
	if(age2!=""){
		qStr=qStr +" and age  < "+age2;
	}
	

	if(work_age1!=""){
		qStr=qStr +" and work_age >= "+work_age1;
	}
	if(work_age2!=""){
		qStr=qStr +" and work_age  < "+work_age2;
	}

		
	if(orgId!=""){
		qStr=qStr +" and org_subjection_id  like '"+orgId+"%'";
	}else{
		qStr=qStr +" and org_subjection_id  like '"+"<%=orgSubjectionId%>"+"%'";
	}

	if(post!=""){
		qStr=qStr +" and post like '%"+post+"%'";
	}
	
	if(employeeCd!=""){
		qStr=qStr +" and employee_cd  like '%"+employeeCd+"%'";
	}
	
	if(spare2!=""){
		qStr=qStr +" and spare2  like '%"+spare2+"%'";
	}
	if(setWork!=""){
		qStr=qStr +" and set_team  like '"+setWork+"%'";
	}
	if(setPost!=""){
		qStr=qStr +" and set_post  like '"+setPost+"%'";
	}
	
	qStr+=" )";
	
	appConfig.queryListAction = queryListAction + encodeURI(encodeURI(qStr));
	queryData(1);
}

var fields = new Array();
fields[0] = ['employee_name','����','TEXT'];
fields[1] = ['employee_gender','�Ա�','TEXT',,,'SEL_OPs',sex];
//fields[2] = ['employee_cd','Ա�����','TEXT'];
//fields[3] = ['spare2','ְ�����','TEXT'];
fields[2] = ['person_status','��Ա״̬','TEXT',,,'SEL_OPs',personOps];
fields[3] = ['deploy_status','����״̬','TEXT',,,'SEL_OPs',deployOps];

function basicQuery(){
	var qStr = generateBasicQueryStr();
	cruConfig.cdtStr = qStr;
	queryData(1);
}


function cmpQuery(){
	var qStr = generateCmpQueryStr();
	cruConfig.cdtStr = qStr;
	queryData(1);
}


function onlineEdit(rowParams){
	var path = cruConfig.contextPath+cruConfig.editAction;
	var params = cruConfig.editTableParams+"&rowParams="+rowParams.toJSONString();
	var retObject = syncRequest('Post',path,params);
	if(retObject.returnCode!=0){
		alert(retObject.returnMsg);
		return false;
	}else return true;
}

//�����checkboxƴ�ӵ�ֵ
var checked="";

function doCheck(id){

	//���
	var num = -1;
	//�µ�checkֵ
	var newcheck = "";
	//ƴ�ӵ�ֵ��Ϊ��

	if(checked != ""){
		var checkStr = checked.split(",");
		for(var i=0;i<checkStr.length-1; i++){
			//���check�д���  ѡ���idֵ
			if(checkStr[i] == id.value){
				//��¼λ��
				num = i;		
				break;	
			}
		}
        //�ж�num�Ƿ���ֵ
		if(num != -1 ){
			if(id.checked==false){
				for(var j=0;j<checkStr.length-1; j++){
					if( j != num ){
						newcheck += checkStr[j] + ',';
					}
				}
				checked = newcheck;
			}
		}else{
			//ֱ��ƴ
			if(id.checked==true){
				checked= checked + id.value + ',';	
			}		
		}
	}else{
		checked = id.value + ',';
		
	}
	

}

function head_chx_box_changed(headChx){
	var chxBoxes = document.getElementsByName("chx_entity_id");
	if(chxBoxes==undefined) return;
	for(var i=0;i<chxBoxes.length;i++){
	  if(!chxBoxes[i].disabled){
			chxBoxes[i].checked = headChx.checked;	
			doCheck(chxBoxes[i]);
	  }
	  
	}
}
	
	  
	  
function queryData(targetPage){
	cruConfig.currentPage = targetPage;

	var submitStr = "currentPage="+targetPage+"&pageSize="+cruConfig.pageSize;
	if(cruConfig.funcCode!='') submitStr += "&EP_DATA_AUTH_funcCode="+cruConfig.funcCode;

	var retObject;//alert(cruConfig.queryService);
	if(cruConfig.queryService!=''){//���÷����ѯ
		submitStr = encodeURI(submitStr);
		submitStr = encodeURI(submitStr);
		retObject = jcdpCallService(cruConfig.queryService,cruConfig.queryOp,submitStr);
	}
	else{//����sql��ѯ
		var querySql = cruConfig.queryStr;
		if(cruConfig.cdtStr!=''){
			querySql = "Select * FROM ("+querySql+")TARGET_RET WHERE "+cruConfig.cdtStr;
		}
		submitStr += "&querySql="+querySql;
		submitStr = encodeURI(submitStr);
		submitStr = encodeURI(submitStr);
		var path = cruConfig.contextPath+appConfig.queryListAction;
		retObject = syncRequest('Post',path,submitStr);
	}

	if (retObject.returnCode != "0") return;
	cruConfig.items = retObject.datas;
	cruConfig.totalRows = retObject.totalRows;
	renderTable(getObj(cruConfig.queryRetTable_id),cruConfig);

	cruConfig.currentPageRlIds = '';
	cruConfig.relationedIds=checked;
	if(cruConfig.relationedIds!=''){
		
		var chxs = document.getElementsByName("chx_entity_id");
		for(var i=0;i<chxs.length;i++)
			if(cruConfig.relationedIds.indexOf(chxs[i].value)>=0){
				 chxs[i].checked = true;
				 if(cruConfig.currentPageRlIds=='') cruConfig.currentPageRlIds = chxs[i].value;
				 else cruConfig.currentPageRlIds += ','+chxs[i].value;
				
			}
	}
}

function calDays(i){
	var startTime = document.getElementById("fy"+i+"planStartDate").value;
	var returnTime = document.getElementById("fy"+i+"planEndDate").value;
	if(startTime!=null&&startTime!=''&&returnTime!=null&&returnTime!=''){
	var days=(new Date(returnTime.replace(/-/g,'/'))-new Date(startTime.replace(/-/g,'/')))/3600/24/1000;
	if(days<0){
		alert("Ԥ���뿪��Ŀʱ��Ӧ����Ԥ�ƽ�����Ŀʱ��");
		return false;
	}else{
		return true;
	}
	}
	return true;
}

function JcdpButton0OnClick(){
	if(checked == ""){
		alert("��ѡ��һ����¼!");
		return;
	}
	window.returnValue = checked;
	window.close();  
}

function JcdpButton1OnClick(){
	window.returnValue = "";
	window.close(); 
}

function JcdpButton3OnClick(){
	if(checked == ""){
		alert("��ѡ��һ����¼!");
		return;
	}
	var isSet = "";
	var selects = document.getElementsByName("isSet");  
    for (var i=0; i<selects.length; i++){  
        if (selects[i].checked== true) {  
        	isSet = selects[i].value;  
            break;  
        }  
    }  
    var str = "checked="+checked+"&isSet="+isSet;
	var humanList = jcdpCallService("HumanRequiredSrv","queryAllHumanList",str);
	var returncheck = "";
	if(humanList.peopleList!=null){
		for(var i=0;i<humanList.peopleList.length;i++){
			var templateMap = humanList.peopleList[i];
			returncheck += templateMap.employeeId+'-'+templateMap.employeeName +'-'+templateMap.team+ "-" +templateMap.workPost+",";			
		}		
	}
	window.returnValue = returncheck;
	window.close();  
}

function JcdpButton2OnClick(){

	var isSet = "";
	var selects = document.getElementsByName("isSet");  
    for (var i=0; i<selects.length; i++){  
        if (selects[i].checked== true) {  
        	isSet = selects[i].value;  
            break;  
        }  
    }  
    var str = "orgId="+window.dialogArguments.applyCompany+"&isSet="+isSet;   
	var humanList = jcdpCallService("HumanRequiredSrv","queryAllHumanList",str);
	
	 var dflag = "0";
	 if(!window.confirm("����Ա״̬Ϊ������Ŀ���͵���״̬Ϊ���ѵ��䡱���������С�����Ա���Ƿ���䣿")) {
 		dflag="1";
 	 }
	 var returncheck = "";
	if(humanList.peopleList!=null){
		var num = 0;
		for(var i=0;i<humanList.peopleList.length;i++){
			var templateMap = humanList.peopleList[i];
			
			if(templateMap.personStatus =='0' && templateMap.deployStatus =='0'){
				returncheck += templateMap.employeeId+'-'+templateMap.employeeName +'-'+templateMap.team+ "-" +templateMap.workPost+",";
				num ++;				
			}else{
				if(dflag == '0'){
					returncheck += templateMap.employeeId+'-'+templateMap.employeeName +'-'+templateMap.team+ "-" +templateMap.workPost+",";
					num ++;
				}
			}

		}
		if(!window.confirm("���ε��乲�漰"+num+"����Ա���Ƿ�ִ�е��䣿")) {
	 		return;
	 	 }
	}
	if(returncheck == ""){
		alert("�޿ɵ�����Ա!");
		return;
	}
	window.returnValue = returncheck;
	window.close();  
	
}

//ѡ����֯����
function selectOrg(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
        document.getElementById("orgId").value = teamInfo.fkValue;
        document.getElementById("orgName").value = teamInfo.value;
    }
}
function getTeamList(){

	//�õ����а���
	var applyTeamList=jcdpCallService("HumanRequiredSrv","queryApplyTeam","");	
	var selectObj = document.getElementById("setWork");
	document.getElementById("setWork").innerHTML="";
	selectObj.add(new Option('��ѡ��',""),0);
	if(applyTeamList.detailInfo!=null){
	for(var i=0;i<applyTeamList.detailInfo.length;i++){
		var templateMap = applyTeamList.detailInfo[i];
		var option = new Option(templateMap.label,templateMap.value);
		selectObj.add(option,i+1);
	}
	}
	var selectObj1 = document.getElementById("setPost");
	document.getElementById("setPost").innerHTML="";
	selectObj1.add(new Option('��ѡ��',""),0);
	
}
function getApplyPostList(){

    var applyTeam = "applyTeam="+document.getElementById("setWork").value;  
	var applyPost=jcdpCallService("HumanRequiredSrv","queryApplyPostList",applyTeam);	

	var selectObj = document.getElementById("setPost");
	document.getElementById("setPost").innerHTML="";
	selectObj.add(new Option('��ѡ��',""),0);
	if(applyPost.detailInfo!=null){
	for(var i=0;i<applyPost.detailInfo.length;i++){
		var templateMap = applyPost.detailInfo[i];
		selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	}
	}
}
</script>


<body onload="page_init();getTeamList()">
<table border="0" cellpadding="0" cellspacing="0" class="Tab_page_title">
  <tr>
			<td height=1 colspan="4" align=left></td>
  </tr>
  <tr>
			<td width="5%"   height=28 align=left ><img src="<%=contextPath%>/images/oms_index_09.gif" width="100%" height="28" /></td>
			<td id="cruTitle" width="40%" align=left background="<%=contextPath%>/images/oms_index_11.gif" class="text11">
            	��Աɸѡ
          	</td>
			<td width="5%" align=left ><img src="<%=contextPath%>/images/oms_index_13.gif" width="100%" height="28" /></td>
			<td width="50%" align=left style="background:url(<%=contextPath%>/images/oms_index_14.gif) repeat-x;">&nbsp;</td>
  </tr>
</table>
<div id="queryDiv" style="display:">
<table  border="0" cellpadding="0" cellspacing="0" class="form_info" id="queryCdtTable" enctype="multipart/form-data">
<!--�˴�������Ա����Ӳ�ѯ����-->
	<tr class="even">
		<td class="rtCRUFdName">��֯������</td>
		<td class="rtCRUFdValue">
		<input type="hidden" value="<%=orgSubjectionId%>" id="orgId" name="orgId"></input>
		<input type="text" value="<%=orgName%>" id="orgName" name="orgName" class='input_width' readonly="readonly"></input>
		<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
		</td>
		<td class="rtCRUFdName">&nbsp;��λ</td>
		<td class="rtCRUFdValue"><input type="text"  class='input_width' id="post" name="post" value=""/></td>	
	</tr>
	<tr>
		<td class="rtCRUFdName">���ð��飺</td>
		<td class="rtCRUFdValue">
			<select id="work" name="setWork" class="input_width" onchange="getApplyPostList()"></select>
		</td>
		<td class="rtCRUFdName">���ø�λ��</td>
		<td class="rtCRUFdValue">
			<select id="post" name="setPost" class="input_width"></select>
		</td>	
	</tr>
	<tr>
	    <td class="rtCDTFdName">����ӣ�</td>
	    <td class="rtCDTFdValue">
	    <input name="age1" id="age1" type="text"  onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);"/>��
	     <input name="age2" id="age2" type="text" onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);" />     
	    </td>
	    <td class="rtCDTFdName">�������޴ӣ�
	    </td>
	    <td class="rtCDTFdValue" >
	     <input name="work_age1" id="work_age1" type="text" onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);" />�� 
	     <input name="work_age2" id="work_age2" type="text" onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);"/>
		</td>    
  </tr>
	<tr>
		<td class="rtCRUFdName">&nbsp;Ա�����</td>
		<td class="rtCRUFdValue"><input type="text"  class='input_width' id="employeeCd" name="employeeCd" value=""/></td>	
		<%  if(orgSubjectionId!=null && orgSubjectionId.length()>9 && orgSubjectionId.substring(0, 10).equals("C105001005")){%>
			<td class="rtCRUFdName">&nbsp;ְ�����</td>
			<td class="rtCRUFdValue"><input type="text"  class='input_width' id="spare2" name="spare2" value=""/></td>	
		<% }else{%>
			<td class="rtCRUFdName">&nbsp;</td>
			<td class="rtCRUFdValue">&nbsp;</td>
		<%} %>
	</tr>
  <tr class="ali4">
    <td colspan="4"><input type="submit" onclick="classicQuery()" name="search" value="��ѯ"  class="iButton2"/>  <input type="reset" name="reset" value="���" onclick="clearQueryCdt()" class="iButton2"/></td>
  </tr>  
</table>
</div>
<div id="alldiv" style="display:none"> 
<table  border="0" cellpadding="0" cellspacing="0" class="Tab_new_mod_del">
  <tr class="ali7">
    <td>
		<input class="iButton2" type="button" id="button1" value="ȫ�����䱾����Ա" onClick="JcdpButton2OnClick()">
		<input class="iButton2" type="button" value="����" onClick="JcdpButton3OnClick()">
		<input class="iButton2" type="button" value="����" onClick="JcdpButton1OnClick()">
		<input type="button"  class="iButton2" name="exp" value="����" onClick="expData()">				
		<input type="radio" name="isSet" id="isSet" value="1" checked="checked">���õİ����λ����
		<input type="radio" name="isSet" id="isSet" value="2">�ϴε���İ����λ����		
    </td>
  </tr>
</table>
</div>
<div id="lidiv" >
<table  border="0" cellpadding="0" cellspacing="0" class="Tab_new_mod_del">
  <tr class="ali7">
    <td>
		<input class="iButton2" type="button" value="����" onClick="JcdpButton0OnClick()">
		<input class="iButton2" type="button" value="����" onClick="JcdpButton1OnClick()">
		<input type="button"  class="iButton2" name="exp" value="����" onClick="expData()">
    </td>
  </tr>
</table>
</div>
<!--Remark ��ѯָʾ����-->
<div id="rtToolbarDiv">
<table border="0"  cellpadding="0"  cellspacing="0"  class="rtToolbar"  width="100%" >
	<tr>
		<td align="right" >
			<span id="dataRowHint">��0/0ҳ,��0����¼ </span>
			<table id="navTableId" border="0"  cellpadding="0"  cellspacing="0" style="display:inline">
				<tr>
					<td><img src="<%=contextPath%>/images/table/firstPageDisabled.gif"  style="border:0"  alt="First" /></td>
					<td><img src="<%=contextPath%>/images/table/prevPageDisabled.gif"  style="border:0"  alt="Prev" /></td>
					<td><img src="<%=contextPath%>/images/table/nextPageDisabled.gif"  style="border:0"  alt="Next" /></td>
					<td><img src="<%=contextPath%>/images/table/lastPageDisabled.gif"  style="border:0"  alt="Last" /></td>				
				</tr>
			</table>
			<span>��&nbsp;<input type="text"  id="changePage"  class="rtToolbar_chkboxme">&nbsp;ҳ<a href='javascript:changePage()'><img src='<%=contextPath%>/images/table/bullet_go.gif' alt='Go' align="absmiddle" /></a></span>		
		</td>
	</tr>
</table>
</div>

<div id="resultable"  style="width:100%; overflow-x:none;" >
<table border="0"  cellspacing="0"  cellpadding="0"  class="form_info"  width="100%" id="queryRetTable">
	<thead>

	<tr class="bt_info">
		<td class="tableHeader" 	 exp="<input type='checkbox' name='chx_entity_id'  value='{employeeId}-{employeeName}' onclick=doCheck(this) />"><input type='checkbox' id='headChxBox' onclick="head_chx_box_changed(this)"></td>
		<td class="tableHeader" 	 exp="{employeeCd}">Ա�����</td>
		<%  if(orgSubjectionId!=null && orgSubjectionId.length()>9 && orgSubjectionId.substring(0, 10).equals("C105001005")){%>
			<td class="tableHeader" 	 exp="{spare2}">ְ�����</td>
		<%} %>
		<td class="tableHeader" 	 exp="<a href=javascript:viewLink('{employeeId}') > {employeeName} </a>">����</td>
		<td class="tableHeader" 	 exp="{employeeGenderName}">�Ա�</td>
		<td class="tableHeader" 	 exp="{age}">����</td>
		<td class="tableHeader" 	 exp="{orgAbbreviation}">��֯����</td>
		<td class="tableHeader" 	 exp="{reliefOrgName}">���䵥λ</td>
		<td class="tableHeader" 	 exp="{post}">��λ</td>
		<td class="tableHeader" 	 exp="{setTeamName}">���ð���</td>
		<td class="tableHeader" 	 exp="{setPostName}">���ø�λ</td>
		<td class="tableHeader" 	 exp="{workAge}">��������</td>
		<td class="tableHeader" 	 exp="{personStatus}">��Ա״̬</td>
		<td class="tableHeader" 	 exp="{planEndDate}">Ԥ���뿪��Ŀʱ��</td>
		<td class="tableHeader" 	 exp="{deployStatusName}">����״̬</td>
		<td class="tableHeader" 	 exp="{actualStartDate}">���һ�ν�����Ŀʱ��</td>
		<td class="tableHeader" 	 exp="{actualEndDate}">���һ���뿪��Ŀʱ��</td>
		<td class="tableHeader" 	 exp="{projectName}">���һ���ϸ���Ŀ����</td>		
	</tr>
	</thead>
	<tbody>
	
	</tbody>
</table>
</div>
</body>
</html>
