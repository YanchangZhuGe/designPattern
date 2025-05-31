<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.bgp.gms.service.rm.em.pojo.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ taglib uri="code" prefix="code"%> 

<%
String contextPath = request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String userName = (user==null)?"":user.getEmpId();
SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
String curDate = format.format(new Date());
String project_id= user.getProjectInfoNo();
//�������뵥��Ϣ
ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
BgpProjectHumanRequirement applyInfo = (BgpProjectHumanRequirement) resultMsg
		.getMsgElement("applyInfo").toPojo(	BgpProjectHumanRequirement.class);
 
List<MsgElement> list = resultMsg.getMsgElements("detailInfo");
List<BgpProjectHumanPost> beanList=new ArrayList<BgpProjectHumanPost>(0);
if(list!=null){
	beanList = new ArrayList<BgpProjectHumanPost>(list.size());	
	for (int i = 0; i < list.size(); i++) {
		beanList.add((BgpProjectHumanPost) list.get(i).toPojo(
				BgpProjectHumanPost.class));
	}
}

String degreeStr = resultMsg.getValue("degreeStr");

String workYearStr = resultMsg.getValue("workYearStr");

String ageStr = resultMsg.getValue("ageStr");

String buttonViewFile = resultMsg.getValue("buttonView"); 
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
  <link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
  <link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
  <link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
  <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<style type="text/css">
body,table, td {font-size:12px;font-weight:normal;}
/* �ص㣺�̶���ͷ��ʽ*/  
.scrollRowThead{BACKGROUND-COLOR: #AEC2E6;position: relative; left: expression(this.parentElement.parentElement.parentElement.parentElement.scrollLeft);z-index:0;}  
/* �ص㣺�̶���ͷ��ʽ*/  
.scrollColThead {position: relative;top: expression(this.parentElement.parentElement.parentElement.scrollTop);z-index:2;}  
/* ���н���ĵط�*/  
.scrollCR{ z-index:3;}
/*div ���*/  
.scrollDiv {height:330;clear: both; border: 1px solid #94B6E6;OVERFLOW: scroll;width: 100%; }  
/* ��ͷ����*/  
.scrollColThead td,.scrollColThead th{ text-align: center ;}  
/* ��ͷ��ͷ����*/  
.scrollRowThead,.scrollColThead td,.scrollColThead th{background-color:#94B6E6;background-repeat:repeat;}  
/* ������*/  
.scrolltable{border-bottom:1px solid #CCCCCC; border-right:1px solid #8EC2E6;}  
/* ��Ԫ����ߵ�*/  
.scrolltable td,.scrollTable th{border-left: 1px solid #CCCCCC; border-top: 1px solid #CCCCCC; padding: 1px;}
.scrollTable thead th{background-color:#94B6E6;position:relative;}
.td_head {
	FONT-SIZE: 12px;
	COLOR: #296184;
	font-family:"΢���ź�", Arial, Helvetica, sans-serif;
	font-weight:normal;
	text-align: center;
	vertical-align: middle;
	height:20px;
	line-height: 20px;
	background:#CCCCCC;
}
</style>
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath %>';

var currentCount=parseInt('<%=beanList.size()%>');
var deviceCount = parseInt('<%=beanList.size()%>');
 
//ѧ����ʼ��
var codeStr = '<%=degreeStr%>';
//�����ʼ��
var ageStr = '<%=ageStr%>';
//�������޳�ʼ��
var workYearStr = '<%=workYearStr%>';
var buttonViewFile='<%=buttonViewFile%>';

var optionStr=codeStr.split("@");
var ge_str='<option value="">��ѡ��</option>';
for(var i=0;i<optionStr.length;i++){
	ge_str+='<option value="'+optionStr[i].split(",")[0]+'" >'+optionStr[i].split(",")[1]+'</option>';
}
var ageOptionStr=ageStr.split("@");
var age_str='<option value="">��ѡ��</option>';
for(var i=0;i<ageOptionStr.length;i++){
	age_str+='<option value="'+ageOptionStr[i].split(",")[0]+'" >'+ageOptionStr[i].split(",")[1]+'</option>';
}
var workOptionStr=workYearStr.split("@");
var work_str='<option value="">��ѡ��</option>';
for(var i=0;i<workOptionStr.length;i++){
	work_str+='<option value="'+workOptionStr[i].split(",")[0]+'" >'+workOptionStr[i].split(",")[1]+'</option>';
}

 
function sucess(){
	if(checkForm()){
		var requirementNo= document.getElementsByName("requirementNo")[0].value;
		var querySql = " select t.file_id, t.ucm_id from bgp_doc_gms_file t    where  t.bsflag='0' and  t.relation_id = '"+requirementNo+"' and t.project_info_no = '<%=project_id%>' ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		var datas = queryRet.datas;		
		if(queryRet.returnCode=='0'){
			if(datas != null && datas != ''){	
				 document.getElementsByName("fileId")[0].value=datas[0].file_id; 
				 document.getElementsByName("ucmId")[0].value=datas[0].ucm_id; 
			}
		}
		
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/rm/em/toSaveHumanRequired.srq";
		form.submit();
		alert('����ɹ�');
		newClose();
	}
}

function checkForm(){
	var deviceCount = document.getElementById("equipmentSize").value;
	var isCheck=true;
	for(var i=0;i<deviceCount;i++){
		if(document.getElementById("fy"+i+"check").checked == true){
			isCheck=false;
			break;
		}
	}
	if(isCheck){
		alert("��ѡ��һ����¼");
		return false;
	}else{
		for(var i=0;i<deviceCount;i++){
			if(document.getElementById("fy"+i+"check").checked == true){				
				if(!notNullForCheck("fy"+i+"applyTeam","����")) return false;
				if(!notNullForCheck("fy"+i+"post","��λ")) return false;
				if(!notNullForCheck("fy"+i+"planStartDate","�ƻ�����ʱ��")) return false;
				if(!notNullForCheck("fy"+i+"planEndDate","�ƻ��뿪ʱ��")) return false;
				if(!notNullForCheck("fy"+i+"peopleNumber","������������")) return false;
				if(!notNullForCheck("fy"+i+"auditNumber","������ʱ����������")) return false;
			}
		}		
		return true;
	}
}
	
//�õ����а���
var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeam","");	

function getApplyTeam(){

	var applypost_str='<option value="">��ѡ��</option>';
	for(var i=0;i<applyTeamList.detailInfo.length;i++){
		var templateMap = applyTeamList.detailInfo[i];
		//ѡ��ǰ����
		applypost_str+='<option value="'+templateMap.value+'" >'+templateMap.label+'</option>';
	}
	
	return applypost_str;

}
 
//�������ú���
function getPost( id ){

    var applyTeam = "applyTeam="+document.getElementById("fy"+id+"applyTeam").value;   
	var applyPost=jcdpCallService("HumanRequiredSrv","queryApplyPostList",applyTeam);	

	var selectObj = document.getElementById("fy"+id+"post");
	document.getElementById("fy"+id+"post").innerHTML="";
	selectObj.add(new Option('��ѡ��',""),0);
	if(applyPost.detailInfo!=null){
	for(var i=0;i<applyPost.detailInfo.length;i++){
		var templateMap = applyPost.detailInfo[i];
		selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	}
	}
}

function notNullForCheck(filedName,fieldInfo){

	if(document.getElementById(filedName).value==null||document.getElementById(filedName).value==""){
		alert(fieldInfo+"����Ϊ��");
		document.getElementById(filedName).onfocus="true";
		return false;
	}else{
		return true;
	}
}
function isNumberForCheck(filedName,fieldInfo){
	var valNumber = document.getElementById(filedName).value;
	var re=/^[1-9]+[0-9]*]*$/;
	if(valNumber!=null&&valNumber!=""){
		if(!re.test(valNumber)){
			alert(fieldInfo+"��ʽ����ȷ,����������");
			return false;
		}else{
			return true;
		}
	}else{
		return true;
	}
}

function addLine(){
	

	var tr = document.getElementById("equipmentTableInfo").insertRow();
	
	tr.id = "fy"+deviceCount+"trflag";
	
	if(deviceCount % 2 == 1){  
  		classCss = "even_";
	}else{ 
		classCss = "odd_";
	}

	var startTime = "fy"+deviceCount+"planStartDate";
	var endTime = "fy"+deviceCount+"planEndDate";

	var td = tr.insertCell(0);
	td.className="scrollRowThead";
	td.width="2%";
	td.innerHTML = '<input type="checkbox" id="fy'+deviceCount+'check" name="fy'+deviceCount+'check" >';
	
	var td = tr.insertCell(1);
	td.className="scrollRowThead";
	td.width="2%";
	td.innerHTML = currentCount+1+'<input type="hidden" id="fy'+deviceCount+'postNo" name="fy'+deviceCount+'postNo" value=""/>';
		
	var td = tr.insertCell(2);
	td.className="scrollRowThead";
	td.width="6%";
	td.innerHTML = '<select class="select_width"  name="fy'+ deviceCount + 'applyTeam" id="fy'+ deviceCount + 'applyTeam" onchange="getPost('+deviceCount+')" >'+getApplyTeam()+'</select>';
	
	var td = tr.insertCell(3);
	td.className="scrollRowThead";
	td.width="6%";
	td.innerHTML = '<select class="select_width"   name="fy'+ deviceCount + 'post" id="fy'+ deviceCount + 'post"  > <option value="">��ѡ��</option> </select>';
	

	var td = tr.insertCell(4);
	td.className=classCss+"odd";
	td.width="6%";
	td.innerHTML = '<input type="text" onpropertychange="calDays('+deviceCount+')"  readonly="readonly" maxlength="32" id="fy'+deviceCount+'planStartDate" name="fy'+deviceCount+'planStartDate" value="" class="input_width" />'+'<img src="'+'<%=contextPath%>'+'/images/calendar.gif" id="tributton3'+deviceCount+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+"'"+startTime+"'"+',tributton3'+deviceCount+');" />';
	
	var td = tr.insertCell(5);
	td.className=classCss+"even";
	td.width="6%";
	td.innerHTML = '<input type="text" onpropertychange="calDays('+deviceCount+')" readonly="readonly" maxlength="32" id="fy'+deviceCount+'planEndDate" name="fy'+deviceCount+'planEndDate" value="" class="input_width" />'+'<img src="'+'<%=contextPath%>'+'/images/calendar.gif" id="tributton4'+deviceCount+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+"'"+endTime+"'"+',tributton4'+deviceCount+');" />';
	
	var td = tr.insertCell(6);
	td.className=classCss+"odd";
	td.width="5%";
	td.innerHTML = '<select id="fy'+deviceCount+'age" name="fy'+deviceCount+'age" class="select_width">'+age_str+'</select>';

	var td = tr.insertCell(7);
	td.className=classCss+"even";
	td.width="5%";
	td.innerHTML = '<select id="fy'+deviceCount+'workYears" name="fy'+deviceCount+'workYears" class="select_width">'+work_str+'</select>';
	
	var td = tr.insertCell(8);
	td.className=classCss+"odd";
	td.width="5%";
	td.innerHTML = '<select id="fy'+deviceCount+'culture" name="fy'+deviceCount+'culture" class="select_width">'+ge_str+'</select>';

	var td = tr.insertCell(9);
	td.className=classCss+"odd";
	td.width="4%";
	td.innerHTML = '<input type="text" maxlength="32" name="fy'+ deviceCount + 'spare2" id="fy'+ deviceCount + 'spare2"  value="" class="input_width" />';

	var td = tr.insertCell(10);
	td.className=classCss+"even";
	td.width="4%";
	td.innerHTML = '<input type="text" maxlength="32" name="fy'+ deviceCount + 'spare3" id="fy'+ deviceCount + 'spare3" value="" class="input_width" />';

	
	var td = tr.insertCell(11);
	td.className=classCss+"even";
	td.width="3%";
	td.innerHTML = '<input type="text" maxlength="32" value="" class="input_width" />';
			
	var td = tr.insertCell(12);
	td.className=classCss+"odd";
	td.width="3%";
	td.innerHTML = '<input type="text" maxlength="32" value="" class="input_width" />';

	
	var td = tr.insertCell(13);
	td.className=classCss+"even";
	td.width="4%";
	td.innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'peopleNumber" name="fy'+deviceCount+'peopleNumber" onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);" value="" class="input_width" />';

	var td = tr.insertCell(14);
	td.className=classCss+"odd";
	td.width="4%";
	td.innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'auditNumber" name="fy'+deviceCount+'auditNumber" onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);" value="" class="input_width" />';
	
	var td = tr.insertCell(15);
	td.className=classCss+"even";
	td.width="3%";
	td.innerHTML = '<input type="text" maxlength="32" value="" class="input_width" />';

	document.getElementById("equipmentSize").value=deviceCount+1;
	deviceCount+=1;
	currentCount+=1;
	
}

function hrefParam(){ 
     if(buttonViewFile=="false"){
    	 
    	 var te = document.getElementById('fileId');
    	 var par = te.parentNode.parentNode;
    	 par.style.display='none'; 
    	 var teA = document.getElementById('loadFileId');
    	 var parA = teA.parentNode.parentNode;
    	 parA.style.display='block';
    	 
    		var requirementNo= document.getElementsByName("requirementNo")[0].value;
    		var querySql = " select t.file_id, t.ucm_id ,t.file_name from bgp_doc_gms_file t      where  t.bsflag='0' and t.project_info_no='<%=project_id%>'  and t.relation_id='"+requirementNo+"' ";
    		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
    		var datas = queryRet.datas;		
    		if(queryRet.returnCode=='0'){
    			if(datas != null && datas != ''  ){	 
    			          document.getElementById("loadFile").innerText=datas[0].file_name; 
    	            	  document.getElementById("loadFile").href="<%=contextPath%>/doc/downloadDocByUcmId.srq?emflag=0&docId="+datas[0].ucm_id;
    				
    			}else{
    				  document.getElementById("loadFile").innerText="���ϴ��ĵ�";
    				  document.getElementById("loadFile").href="#";
    			}
    		}
    		 
     }else if (buttonViewFile=="true"){ 
    	 var te = document.getElementById('fileId');
    	 var par = te.parentNode.parentNode;
    	 par.style.display='block'; 
    	 var teA = document.getElementById('loadFileId');
    	 var parA = teA.parentNode.parentNode;
    	 parA.style.display='none';
    	 
	}
 
}

</script>
<title>��Ա�������</title>
</head>
<body onload="hrefParam();" >
<form id="CheckForm" name="Form0" action="" method="post"  target="list"   enctype="multipart/form-data">
<div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:100%">
<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
	<tr>
	<td  class="inquire_item4">���뵥�ţ�</td>
	<td class="inquire_form4">
	<input type="hidden" id="requirementNo" name="requirementNo" value="<%=applyInfo.getRequirementNo()==null?"":applyInfo.getRequirementNo() %>"/>
	<input type="text" style="color: gray;" value="<%=applyInfo.getApplyNo()==null?"�����ύ��ϵͳ�Զ�����":applyInfo.getApplyNo()%>" id="applyNo"  name="applyNo" class='input_width' readonly="readonly"></input>  
	</td>
	<td class="inquire_item4"> </td> 
	<td class="inquire_form4"> </td>	
	</tr>

	<tr>
		<td  class="inquire_item4">��Ŀ���ƣ�</td>
		<td class="inquire_form4">
		<input type="hidden" id="projectInfoNo" name="projectInfoNo" value="<%=applyInfo.getProjectInfoNo()==null?"":applyInfo.getProjectInfoNo()%>"/>
		<input type="text"  readonly="readonly" value="<%=applyInfo.getProjectName()==null?"":applyInfo.getProjectName()%>" id="projectName" name="projectName" class='input_width'></input>
		</td>
		<td class="inquire_item4">ʩ�����飺</td> 
		<td class="inquire_form4">
		<input type="hidden" value="<%=applyInfo.getApplyCompany()==null?"":applyInfo.getApplyCompany()%>" id="applyCompany" name="applyCompany"></input>
		<input type="text" value="<%=applyInfo.getApplicantOrgName()==null?"":applyInfo.getApplicantOrgName()%>" id="applicantOrgName" name="applicantOrgName" class='input_width' readonly="readonly"></input>
		</td>	
	</tr>	
	<tr>
	<td  class="inquire_item4">�ύ�ˣ�</td>
	<td class="inquire_form4">
	<input type="hidden" value="<%=applyInfo.getApplicantId()==null?"":applyInfo.getApplicantId()%>" id="applicantId" name="applicantId"></input>
	<input type="text" value="<%=applyInfo.getApplicantName()==null?"":applyInfo.getApplicantName()%>" id="applicantName" name="applicantName" class='input_width' readonly="readonly"></input>
	</td>
	<td class="inquire_item4">�ύʱ�䣺</td> 
	<td class="inquire_form4">
	<input type="text" value="<%=applyInfo.getApplyDate()==null?"":applyInfo.getApplyDate()%>" id="applyDate" name="applyDate" class='input_width' readonly="readonly"/>&nbsp;
	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(applyDate,tributton1);" />
	</td>	
</tr>	 
<tr style="display:none;">
	<td class="inquire_item4">�ϴ��ļ��� </td>
	<td class="inquire_form4" > 
    <input name="fileId" id="fileId" class="input_width" value="" type="hidden" readonly="readonly"/>
    <input name="ucmId" id="ucmId" class="input_width" value="" type="hidden" readonly="readonly"/>
	<input name="file" id="file" style="width:300px;" value="" type="file" />  
	</td>
</tr>	 
<tr style="display:none;">
<td class="inquire_item4">�����ļ��� </td>
<td class="inquire_form4" > 
<input name="loadFileId" id="loadFileId" class="input_width" value="" type="hidden" readonly="readonly"/>
<a  id="loadFile" href="" style="color:red;"></a>
</td>
</tr>	

</table> 
 
</div>  
	<div id="oper_div" align="center">
     	<span class="zj"><a href="#" onclick="addLine()"></a></span>
    </div>	

<div id="scrollDiv" class="scrollDiv" >
<table width="1300" border="0" cellspacing="0"  align="center" cellpadding="0" class="scrolltable">
  <thead>
	<tr class="scrollColThead td_head"> 
	    <td class="scrollCR scrollRowThead" width="2%">ѡ��</td>
		<td class="scrollCR scrollRowThead" width="2%" >���</td>
		<td class="scrollCR scrollRowThead" width="6%">����</td>
		<td class="scrollCR scrollRowThead" width="6%">��λ</td>

		<td width="6%">�ƻ�����ʱ�� </td>
		<td width="6%">�ƻ��뿪ʱ��</td>
		<td width="5%">���� </td>
		<td width="5%">�������� </td>
		<td width="5%" >�Ļ��̶� </td>
		<td width="4%">�ƻ�����</td>
		<td width="4%">����רҵ������ </td>
		
		<td width="3%">���������� </td> 
		<td width="3%">�������� </td> 
		<td width="4%"><font color="red">*</font>������������</td> 
		<td width="4%"><font color="red">*</font>������ʱ����������</td>
		<td width="3%" >רҵ����Ա<input type="hidden" id="equipmentSize" name="equipmentSize" value="<%=beanList.size()%>" /></td>
	</tr>
		 <%
			for (int i = 0; i < beanList.size(); i++) {
				String className = "";
				if (i % 2 == 0) {
					className = "odd_";
				} else {
					className = "even_";
				}
				BgpProjectHumanPost applyDetailInfo = beanList.get(i);
				String ss="fy"+String.valueOf(i)+"deviceUnit";
		  %>
			<tr  id="fy<%=i%>trflag">
			
			
			<td class="scrollRowThead"><input type="checkbox" name="fy<%=i%>check" id="fy<%=i%>check"   <%if(applyDetailInfo.getPostNo()!=null){ %> checked="checked" <%} %>/></td>
			<td class="scrollRowThead"><%=i+1 %><input type="hidden" name="fy<%=i%>postNo" id="fy<%=i%>postNo" value="<%=applyDetailInfo.getPostNo()==null?"":applyDetailInfo.getPostNo()%>"/></td>
			<td class="scrollRowThead"><input type="hidden" id="fy<%=i%>applyTeam" name="fy<%=i%>applyTeam" value="<%=applyDetailInfo.getApplyTeam()==null?"":applyDetailInfo.getApplyTeam()%>"   readonly="readonly"/>
			<input type="text" id="fy<%=i%>applyTeamname" name="fy<%=i%>applyTeamname" class="input_width"  value="<%=applyDetailInfo.getApplyTeamname()==null?"":applyDetailInfo.getApplyTeamname()%>"  readonly="readonly"/>
			</td>
			
			<td class="scrollRowThead"><input type="hidden" id="fy<%=i%>post" name="fy<%=i%>post" value="<%=applyDetailInfo.getPost()==null?"":applyDetailInfo.getPost()%>"  readonly="readonly"/>
			<input type="text" id="fy<%=i%>postname" name="fy<%=i%>postname"  class="input_width"  value="<%=applyDetailInfo.getPostname()==null?"":applyDetailInfo.getPostname()%>"   readonly="readonly"/>
			</td> 
				<td class="<%=className%>odd"><input type="text" name="fy<%=i%>planStartDate" id="fy<%=i%>planStartDate"   class="input_width"   readonly="readonly" value="<%=applyDetailInfo.getPlanStartDate()==null?"":applyDetailInfo.getPlanStartDate()%>" />
			<img src="<%=contextPath%>/images/calendar.gif" id="tributton3<%=i%>" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector('fy<%=i%>planStartDate',tributton3<%=i%>);"  /></td>
			<td class="<%=className%>even"><input type="text" name="fy<%=i%>planEndDate" id="fy<%=i%>planEndDate"  class="input_width"   readonly="readonly" value="<%=applyDetailInfo.getPlanEndDate()==null?"":applyDetailInfo.getPlanEndDate()%>" />
			<img src="<%=contextPath%>/images/calendar.gif" id="tributton4<%=i%>" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector('fy<%=i%>planEndDate',tributton4<%=i%>);"  /></td>
			<td class="<%=className%>odd"><code:codeSelect name='<%=("fy"+String.valueOf(i)+"age")%>' option="hrAgeOps" addAll="true"  cssClass="select_width" selectedValue='<%=applyDetailInfo.getAge()==null?"":applyDetailInfo.getAge()%>'  /></td>
			<td class="<%=className%>even"><code:codeSelect name='<%=("fy"+String.valueOf(i)+"workYears")%>' option="workYearOps" addAll="true" cssClass="select_width" selectedValue='<%=applyDetailInfo.getWorkYears()==null?"":applyDetailInfo.getWorkYears()%>'  /></td>
			<td class="<%=className%>odd"><code:codeSelect name='<%=("fy"+String.valueOf(i)+"culture")%>' option="hrDegreeOps" addAll="true" cssClass="select_width" selectedValue='<%=applyDetailInfo.getCulture()==null?"":applyDetailInfo.getCulture()%>'  /></td>
			
			<td class="<%=className%>odd"><input type="text" class="input_width" name="fy<%=i%>spare2" id="fy<%=i%>spare2" value="<%=applyDetailInfo.getSpare2()==null?"":applyDetailInfo.getSpare2()%>"  readonly="readonly"/></td>
			<td class="<%=className%>even"><input type="text" class="input_width" name="fy<%=i%>spare3" id="fy<%=i%>spare3" value="<%=applyDetailInfo.getSpare3()==null?"":applyDetailInfo.getSpare3()%>"  readonly="readonly"/></td>
		
			<td class="<%=className%>even"><input type="text" class="input_width"  value="<%=applyDetailInfo.getZ1()==null?"":applyDetailInfo.getZ1()%>"  readonly="readonly"/></td>
			<td class="<%=className%>odd"><input type="text" class="input_width"  value="<%=applyDetailInfo.getZ2()==null?"":applyDetailInfo.getZ2()%>"  readonly="readonly"/></td>
			<td class="<%=className%>even"><input type="text" class="input_width"  name="fy<%=i%>peopleNumber" id="fy<%=i%>peopleNumber" onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);"  value="<%=applyDetailInfo.getPeopleNumber()==null?"":applyDetailInfo.getPeopleNumber()%>" /></td>
			<td class="<%=className%>odd"><input type="text" class="input_width"  name="fy<%=i%>auditNumber" id="fy<%=i%>auditNumber" onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);"  value="<%=applyDetailInfo.getAuditNumber()==null?"":applyDetailInfo.getAuditNumber()%>" /></td>
			<td class="<%=className%>even"><input type="text" class="input_width"  value="<%=applyDetailInfo.getZ3()==null?"":applyDetailInfo.getZ3()%>"  readonly="readonly"/></td>
			
			</tr>	
		  <%
			}
		  %>

</table>
<table id="equipmentTableInfo" width="1300" border="0" cellspacing="0"  align="center" cellpadding="0" class="scrolltable">

</table>
</div>
<% 
   String buttonView = resultMsg.getValue("buttonView"); 
   if("true".equals(buttonView)){
%>
<div id="oper_div">
    <span class="bc_btn"><a href="#" onclick="sucess()"></a></span>
    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
</div>
<%} %>
</form>
</body>
</html>