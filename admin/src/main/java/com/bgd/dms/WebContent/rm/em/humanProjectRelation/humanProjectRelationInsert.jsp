<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.bgp.mcs.service.rm.em.humanRequired.pojo.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	

	
	//�����б�
	List<MsgElement> allTeamList = resultMsg.getMsgElements("teamList");
	//��λ�б�
	List<MsgElement> allPostList = resultMsg.getMsgElements("postList");
	//��Ÿ�λ�����Ķ�Ӧ
	Map postMsg = new HashMap();
	//����ĺŵ��ڸ�λ�İ����,��ƴΪmap(��λ��,�����:������)����ʽ
	if(allTeamList != null){
		for(int i = 0; i < allTeamList.size(); i++){
			MsgElement msg = (MsgElement) allTeamList.get(i);
			Map tempMap = msg.toMap();
			StringBuffer sb = new StringBuffer("");
			for(int j = 0; j < allPostList.size(); j++){
				MsgElement msgj = (MsgElement) allPostList.get(j);
				Map tempMapj = msgj.toMap();

				if(tempMap.get("value").toString().equals(tempMapj.get("team").toString())){
				      sb.append(tempMapj.get("applyPost")).append(":").append(tempMapj.get("applyPostname")).append(",");					
				}
			}
			postMsg.put(tempMap.get("value"),sb.toString());
		}
	}

%>
<% 
//��ʼ��������λ�б�option
    String apply_str = "<option value="+" "+">��ѡ��</option>";
	if(allTeamList != null){
	for(int m = 0; m < allTeamList.size(); m++){
		MsgElement msg = (MsgElement) allTeamList.get(m);
		Map tempMap = msg.toMap();
		apply_str+="<option value="+tempMap.get("value")+">"+tempMap.get("label")+"</option>";	
	}	
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
 
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
 
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath %>';

var currentCount=parseInt('0');
var deviceCount = parseInt('0');
//��������option
var apply_str="<%=apply_str%>";
//ѡ��������
function selectPerson(i){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/rm/em/humanProjectRelation/selectEmployee.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
        document.getElementById("fy"+i+"employeeId").value = teamInfo.fkValue;
        document.getElementById("fy"+i+"employeeName").value = teamInfo.value;
    }
}

//ѡ����Ŀ
function selectTeam(){
	
//    var teamInfo = {
//        fkValue:"",
//        value:""
//    };
//    window.showModalDialog('<%=contextPath%>/rm/em/humanLabor/selectProject.lpmd',teamInfo);
//    if(teamInfo.fkValue!=""){
//        document.getElementById("projectInfoNo").value = teamInfo.fkValue;
//        document.getElementById("projectName").value = teamInfo.value;
//    }
	
	 var result = window.showModalDialog('<%=contextPath%>/rm/em/humanCostPlan/searchProjectList.jsp','');
	    if(result!=""){
	    	var checkStr = result.split("-");	
		        document.getElementById("projectInfoNo").value = checkStr[0];
		        document.getElementById("projectName").value = checkStr[1];
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

function calCheckDays(i){
	var startTime = document.getElementById("fy"+i+"actualStartDate").value;
	var returnTime = document.getElementById("fy"+i+"actualEndDate").value;
	if(startTime!=null&&startTime!=''&&returnTime!=null&&returnTime!=''){
	var days=(new Date(returnTime.replace(/-/g,'/'))-new Date(startTime.replace(/-/g,'/')))/3600/24/1000;
	if(days<0){
		alert("ʵ���뿪��Ŀʱ��Ӧ����ʵ�ʽ�����Ŀʱ��");
		return false;
	}else{
		return true;
	}
	}
	return true;
}

function sucess() {

	if(currentCount==0){
		alert("�����һ����Ա��Ϣ���ٵ������");
		return ;
	}
	if(checkForm()){
	var form = document.getElementById("CheckForm");
	form.action = "<%=contextPath%>/rm/em/savehumanProjectRelat.srq";
	form.submit();
	alert('����ɹ�');
	}
}

function checkForm(){	

	var rowFlag = document.getElementById("deleteRowFlag").value;
	var notCheck=rowFlag.split(",");
	for(var i=0;i<deviceCount;i++){
		var isCheck=true;
		for(var j=0;notCheck!=""&&j<notCheck.length;j++){
			if(notCheck[j]==i) isCheck =false;
		}
		if(isCheck){
			if(!notNullForCheck("fy"+i+"employeeId","����")) return false;
				
		if(!calDays(i))return false;
		
		}
		//var projectEvaluate = document.getElementById("fy"+i+"projectEvaluate").value;
	//	var sprojectEvaluate = encodeURI(encodeURI(projectEvaluate));
		//alert(sprojectEvaluate);
	}

	if(!notNullForCheck("projectInfoNo","��Ŀ����")) return false;

	return true;
	
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


//�������ú���
function getApplyPostList( id ){

    var applyTeam = "applyTeam="+document.getElementById("fy"+id+"team").value;   
	var applyPost=jcdpCallService("HumanLaborMessageSrv","queryApplyPostList",applyTeam);	

	var selectObj = document.getElementById("fy"+id+"workPost");
	document.getElementById("fy"+id+"workPost").innerHTML="";
	selectObj.add(new Option('��ѡ��',""),0);
	if(applyPost.detailInfo!=null){
	for(var i=0;i<applyPost.detailInfo.length;i++){
		var templateMap = applyPost.detailInfo[i];
		selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	}
	}
}

//��һ����Ա
function addDevice(){

    //���tr
	var tr = document.getElementById("equipmentTableInfo").insertRow();
	tr.align ="center";
	tr.id = "fy"+deviceCount+"trflag";

	var startTime = "fy"+deviceCount+"planStartDate";
	var endTime = "fy"+deviceCount+"planEndDate";
	var startTime1 = "fy"+deviceCount+"actualStartDate";
	var endTime1 = "fy"+deviceCount+"actualEndDate";
		
	if(deviceCount % 2 == 1){  
  		classCss = "even_";
	}else{ 
		classCss = "odd_";
	}

	
    //�����ӱ�id,Ϊ��
	var td = tr.insertCell(0);
	td.className=classCss+"odd";
	
	td.innerHTML  = currentCount+1+'<input type="hidden" id="fy'+deviceCount+'relationNo" name="fy'+deviceCount+'relationNo" value=""/>';

	var td = tr.insertCell(1);
	td.className=classCss+"even";
	td.innerHTML  = '<input type="hidden" readonly="readonly" maxlength="32" id="fy'+deviceCount+'employeeId" name="fy'+deviceCount+'employeeId" value="" class="input_width" />'+'<input type="text" readonly="readonly" maxlength="32" id="fy'+deviceCount+'employeeName" name="fy'+deviceCount+'employeeName" value="" class="input_width" />'+'<img src="'+'<%=contextPath%>'+'/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectPerson('+deviceCount+')"  />';
	//��ѡ��
	var td = tr.insertCell(2);
	td.className=classCss+"odd";
	td.innerHTML ='<select id="fy'+deviceCount+'team" name="fy'+deviceCount+'team" class="select_width" onchange="getApplyPostList('+deviceCount+')" >'+apply_str+'</select>';
	//��ѡ��
	var td = tr.insertCell(3);
	td.className=classCss+"even";
	td.innerHTML = '<select id="fy'+deviceCount+'workPost" name="fy'+deviceCount+'workPost" class="select_width"> <option value="">��ѡ��</option> </select>';

	var td = tr.insertCell(4);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" onpropertychange="calDays('+deviceCount+')" readonly="readonly" maxlength="32" id="fy'+deviceCount+'planStartDate" name="fy'+deviceCount+'planStartDate" value="" class="input_width" />'+'<img src="'+'<%=contextPath%>'+'/images/calendar.gif" id="tributton2'+deviceCount+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+"'"+startTime+"'"+',tributton2'+deviceCount+');" />';
	var td = tr.insertCell(5);
	td.className=classCss+"even";
	td.innerHTML  = '<input type="text" onpropertychange="calDays('+deviceCount+')" readonly="readonly" maxlength="32" id="fy'+deviceCount+'planEndDate" name="fy'+deviceCount+'planEndDate" value="" class="input_width" />'+'<img src="'+'<%=contextPath%>'+'/images/calendar.gif" id="tributton3'+deviceCount+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+"'"+endTime+"'"+',tributton3'+deviceCount+');" />';

	var td = tr.insertCell(6);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" onpropertychange="calCheckDays('+deviceCount+')"  readonly="readonly" maxlength="32" id="fy'+deviceCount+'actualStartDate" name="fy'+deviceCount+'actualStartDate" value="" class="input_width" />'+'<img src="'+'<%=contextPath%>'+'/images/calendar.gif" id="tributton4'+deviceCount+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+"'"+startTime1+"'"+',tributton4'+deviceCount+');" />';
	var td = tr.insertCell(7);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" onpropertychange="calCheckDays('+deviceCount+')"  maxlength="32" id="fy'+deviceCount+'actualEndDate" name="fy'+deviceCount+'actualEndDate" value="" class="input_width" />'+'<img src="'+'<%=contextPath%>'+'/images/calendar.gif" id="tributton5'+deviceCount+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+"'"+endTime1+"'"+',tributton5'+deviceCount+');" />';
	
	var td = tr.insertCell(8);
	td.className=classCss+"odd";		
	td.innerHTML = '<select  style="width:100px;"  id="fy'+deviceCount+'projectEvaluate" name="fy'+deviceCount+'projectEvaluate"  ><option value="">��ѡ��</option><option value="0110000058000000001">����</option><option value="0110000058000000002">��ְ</option><option value="0110000058000000003">������ְ</option><option value="0110000058000000004">����ְ</option></select>';
	var td = tr.insertCell(9);
	td.className=classCss+"even";
	td.innerHTML= '<input type="hidden" name="orderDrill" value="' + deviceCount + '"/><img src="'+'<%=contextPath%>'+'/images//delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteDevice(' +deviceCount + ')"/>';

	document.getElementById("equipmentSize").value=deviceCount+1;
	deviceCount+=1;
	currentCount+=1;

}
function deleteDevice(deviceNum){

	var rowDetailId = document.getElementById("hidDetailId").value;
	var rowDeleteId = document.getElementById("fy"+deviceNum+"relationNo").value;

	if(	rowDeleteId!=""&&rowDeleteId!=null){
		rowDetailId = rowDetailId+rowDeleteId+",";
		document.getElementById("hidDetailId").value = rowDetailId;
	}	

	var rowDevice = document.getElementById("fy"+deviceNum+"trflag");
	rowDevice.parentNode.removeChild(rowDevice);
	var rowFlag = document.getElementById("deleteRowFlag").value;
	rowFlag=rowFlag+deviceNum+",";
	document.getElementById("deleteRowFlag").value = rowFlag;

	currentCount-=1;

	//ɾ���������������
	deleteChangeInfoNum('relationNo');

}
function deleteChangeInfoNum(warehouseDetailId){
	var rowFlag = document.getElementById("deleteRowFlag").value;
	var notCheck=rowFlag.split(",");
	var num=1;
	for(var i=0;i<deviceCount;i++){
		var isCheck=true;
		for(var j=0;notCheck!=""&&j<notCheck.length;j++){
			if(notCheck[j]==i&&notCheck[j]!="") isCheck =false;
		}
		if(isCheck){
			document.getElementById("fy"+i+warehouseDetailId).parentNode.innerHTML=num+document.getElementById("fy"+i+warehouseDetailId).outerHTML;
			num+=1;
		}
	}	
}




 
</script>
<script type="text/javascript">

 
function getTab() {  
	var selectedTag=document.getElementsByTagName("li")[0];
	var selectedTag1=document.getElementsByTagName("li")[1];
	
	if(selectedTag!=null){
		selectedTag.className ="selectTag";
	}
	if(selectedTag1!=null){
		selectedTag1.className ="";
	}
	var selectedTabBox = document.getElementById("tab_box_content1")
	selectedTabBox.style.display="NONE";
	var selectedTabBox0 = document.getElementById("tab_box_content0")
	selectedTabBox0.style.display="BLOCK";
	
}

function getTab1() {  
	var selectedTag=document.getElementsByTagName("li")[0];
	var selectedTag1=document.getElementsByTagName("li")[1];
	
	if(selectedTag!=null){
		selectedTag.className ="";
	}
	if(selectedTag1!=null){
		selectedTag1.className ="selectTag";
	}
	var selectedTabBox = document.getElementById("tab_box_content1")
	selectedTabBox.style.display="BLOCK";
	var selectedTabBox0 = document.getElementById("tab_box_content0")
	selectedTabBox0.style.display="NONE";
	
}
 
</script>



<title>��Ա��Ŀ��������</title>
</head>
<body >  
<div id="tag-container_3">
<ul id="tags" class="tags">
<li class="selectTag" id="tag3_0" name="tag3_0"><a href="#" onclick="getTab()">������Ŀ</a></li>
<li id="tag3_1" name="tag3_1"><a href="#" onclick="getTab1()">������Ա</a></li>
</ul>
</div>
<div id="tab_box" class="tab_box">
<div id="tab_box_content0" class="tab_box_content" style="background:#ccc"  >
<form id="CheckForm" name="Form0" action="" method="post" target="list" >
<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%"   >

	<tr >
		<td class="inquire_item4" ><font color=red>*</font>&nbsp;��Ŀ���ƣ�</td>
		<td class="inquire_form4">
		<input type="hidden" id="projectInfoNo" name="projectInfoNo" value="" class="input_width"/>
		<input type="text"  unselectable="on"   readonly="readonly" value="" maxlength="32" id="projectName" name="projectName" class='input_width'></input>
		<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectTeam()"/>
		</td>
		<td class="inquire_item4">&nbsp;</td>
		<td class="inquire_form4">&nbsp;</td>	
	</tr>
	
</table>
 
<table width="100%" border="0" cellspacing="0" cellpadding="0"   >
  <tr>
    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
    <td background="<%=contextPath%>/images/list_15.png">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr align="right">
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
   
    <td><auth:ListButton functionId="" css="zj" event="onclick='addDevice()'" title="JCDP_btn_add"></auth:ListButton> </td>
  </tr>
</table>
</td>
    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
  </tr>
</table>
  
<table border="0" cellspacing="0" cellpadding="0" class="tab_info" width="100%" id="equipmentTableInfo"   >
	<tr  >
		<TD class="bt_info_odd" width="3%">���</TD>
		<TD class="bt_info_even" width="9%"><font color=red>*</font>����</TD>
		<TD class="bt_info_odd" width="12%">����</TD>
		<TD class="bt_info_even" width="12%">��λ</TD>

		<TD class="bt_info_odd" width="12%">Ԥ�ƽ�����Ŀʱ��</TD>
		<TD class="bt_info_even" width="12%">Ԥ���뿪��Ŀʱ�� </TD>
		<TD class="bt_info_odd" width="12%">ʵ�ʽ�����Ŀʱ��</TD>
		<TD class="bt_info_even" width="12%">ʵ���뿪��Ŀʱ�� </TD>
		<TD class="bt_info_odd" width="10%">��Ա���� 
		<input type="hidden" id="equipmentSize" name="equipmentSize" value="0" />
		<input type="hidden" id="hidDetailId" name="hidDetailId" value=""/>
		<input type="hidden" id="deleteRowFlag" name="deleteRowFlag" value="" /></TD>
		<TD class="bt_info_even" width="3%">����	</TD>
	</tr>

</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0"   >
<tr>
 
  <td background="<%=contextPath%>/images/list_15.png" >
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr align="center">
   
  <td  >
  <span class="bc_btn" ><a href="#" onclick="sucess();newClose();"></a></span>
  <span class="gb_btn"><a href="#" onclick="newClose();"></a></span>
  </td>
</tr>
</table>
</td>
 
</tr>
</table>
</form></div>

<script type="text/javascript">
cruConfig.contextPath='<%=contextPath %>';

var currentCount1=parseInt('0');
var deviceCount1 = parseInt('0');
//��������option
var apply_str="<%=apply_str%>";
//ѡ��������
function selectPerson1(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/rm/em/humanProjectRelation/selectEmployee.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
        document.getElementById("employeeId1").value = teamInfo.fkValue;
        document.getElementById("employeeName1").value = teamInfo.value;
    }
}

//ѡ����Ŀ
function selectTeam1(i){
//    var teamInfo = {
//        fkValue:"",
//        value:""
//    };
//    window.showModalDialog('<%=contextPath%>/rm/em/humanLabor/selectProject.lpmd',teamInfo);
//    if(teamInfo.fkValue!=""){
//        document.getElementById("f"+i+"projectInfoNo").value = teamInfo.fkValue;
//        document.getElementById("f"+i+"projectName").value = teamInfo.value;
//    }
//    
    var result = window.showModalDialog('<%=contextPath%>/rm/em/humanCostPlan/searchProjectList.jsp','');
    if(result!=""){
    	var checkStr = result.split("-");	
    	document.getElementById("f"+i+"projectInfoNo").value = checkStr[0];
    	document.getElementById("f"+i+"projectName").value = checkStr[1];
    }
    
}

function calDays1(i){
	var startTime = document.getElementById("f"+i+"planStartDate").value;
	var returnTime = document.getElementById("f"+i+"planEndDate").value;
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

function calCheckDays1(i){
	var startTime = document.getElementById("f"+i+"actualStartDate").value;
	var returnTime = document.getElementById("f"+i+"actualEndDate").value;
	if(startTime!=null&&startTime!=''&&returnTime!=null&&returnTime!=''){
	var days=(new Date(returnTime.replace(/-/g,'/'))-new Date(startTime.replace(/-/g,'/')))/3600/24/1000;
	if(days<0){
		alert("ʵ���뿪��Ŀʱ��Ӧ����ʵ�ʽ�����Ŀʱ��");
		return false;
	}else{
		return true;
	}
	}
	return true;
}

function sucess1() {
  
	if(currentCount1==0){
		alert("�����һ����Ա��Ϣ���ٵ������");
		return ;
	}
	if(checkForm1()){
	var form = document.getElementById("CheckForm1");
	form.action = "<%=contextPath%>/rm/em/saveProjectHumanRelat.srq";
	form.submit();
	alert('����ɹ�');
	}
}

function checkForm1(){	

	var rowFlag = document.getElementById("deleteRowFlag1").value;
	var notCheck=rowFlag.split(",");
	for(var i=0;i<deviceCount1;i++){
		var isCheck=true;
		for(var j=0;notCheck!=""&&j<notCheck.length;j++){
			if(notCheck[j]==i) isCheck =false;
		}
		if(isCheck){
			if(!notNullForCheck1("f"+i+"projectInfoNo","��Ŀ����")) return false;
				
		if(!calDays1(i))return false;
		}
	}

	if(!notNullForCheck1("employeeId1","����")) return false;

	return true;
	
}
function notNullForCheck1(filedName,fieldInfo){

	if(document.getElementById(filedName).value==null||document.getElementById(filedName).value==""){
		alert(fieldInfo+"����Ϊ��");
		document.getElementById(filedName).onfocus="true";
		return false;
	}else{
		return true;
	}
}
 

//�������ú���
function getApplyPostList1( id ){

    var applyTeam = "applyTeam="+document.getElementById("f"+id+"team").value;   
	var applyPost=jcdpCallService("HumanLaborMessageSrv","queryApplyPostList",applyTeam);	

	var selectObj = document.getElementById("f"+id+"workPost");
	document.getElementById("f"+id+"workPost").innerHTML="";
	selectObj.add(new Option('��ѡ��',""),0);
	if(applyPost.detailInfo!=null){
	for(var i=0;i<applyPost.detailInfo.length;i++){
		var templateMap = applyPost.detailInfo[i];
		selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	}
	}
}

//��һ����Ա
function addDevice1(){

    //���tr
	var tr = document.getElementById("equipmentTableInfo1").insertRow();
	tr.align ="center";
	tr.id = "f"+deviceCount1+"trflag1";

	var startTime = "f"+deviceCount1+"planStartDate";
	var endTime = "f"+deviceCount1+"planEndDate";
	var startTime1 = "f"+deviceCount1+"actualStartDate";
	var endTime1 = "f"+deviceCount1+"actualEndDate";
	
	
	if(deviceCount1 % 2 == 1){  
  		classCss = "even_";
	}else{ 
		classCss = "odd_";
	}
	
    //�����ӱ�id,Ϊ��
	var td = tr.insertCell(0);
	td.className=classCss+"odd";
	
	td.innerHTML = currentCount1+1+'<input type="hidden" id="f'+deviceCount1+'relationNo" name="f'+deviceCount1+'relationNo" value=""/>';

	var td = tr.insertCell(1);
	td.className=classCss+"even";
	td.innerHTML  = '<input type="hidden" readonly="readonly" maxlength="32" id="f'+deviceCount1+'projectInfoNo" name="f'+deviceCount1+'projectInfoNo" value="" class="input_width" />'+'<input type="text" readonly="readonly" maxlength="32" id="f'+deviceCount1+'projectName" name="f'+deviceCount1+'projectName" value="" class="input_width" />'+'<img src="'+'<%=contextPath%>'+'/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectTeam1('+deviceCount1+')"  />';
	//��ѡ��
	var td = tr.insertCell(2);
	td.className=classCss+"odd";
	td.innerHTML= '<select id="f'+deviceCount1+'team" name="f'+deviceCount1+'team" class="select_width" onchange="getApplyPostList1('+deviceCount1+')" >'+apply_str+'</select>';
	//��ѡ��
	var td = tr.insertCell(3);
	td.className=classCss+"even";
	td.innerHTML  = '<select id="f'+deviceCount1+'workPost" name="f'+deviceCount1+'workPost" class="select_width"> <option value="">��ѡ��</option> </select>';

	var td = tr.insertCell(4);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" onpropertychange="calDays1('+deviceCount1+')"  readonly="readonly" maxlength="32" id="f'+deviceCount1+'planStartDate" name="f'+deviceCount1+'planStartDate" value="" class="input_width" />'+'<img src="'+'<%=contextPath%>'+'/images/calendar.gif" id="tributton2'+deviceCount1+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+"'"+startTime+"'"+',tributton2'+deviceCount1+');" />';
	var td = tr.insertCell(5);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" onpropertychange="calDays1('+deviceCount1+')" readonly="readonly" maxlength="32" id="f'+deviceCount1+'planEndDate" name="f'+deviceCount1+'planEndDate" value="" class="input_width" />'+'<img src="'+'<%=contextPath%>'+'/images/calendar.gif" id="tributton3'+deviceCount1+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+"'"+endTime+"'"+',tributton3'+deviceCount1+');" />';

	var td = tr.insertCell(6);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" onpropertychange="calCheckDays1('+deviceCount1+')"  readonly="readonly" maxlength="32" id="f'+deviceCount1+'actualStartDate" name="f'+deviceCount1+'actualStartDate" value="" class="input_width" />'+'<img src="'+'<%=contextPath%>'+'/images/calendar.gif" id="tributton4'+deviceCount1+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+"'"+startTime1+"'"+',tributton4'+deviceCount1+');" />';
	var td = tr.insertCell(7);
	td.className=classCss+"even";
	td.innerHTML= '<input type="text" onpropertychange="calCheckDays1('+deviceCount1+')" readonly="readonly" maxlength="32" id="f'+deviceCount1+'actualEndDate" name="f'+deviceCount1+'actualEndDate" value="" class="input_width" />'+'<img src="'+'<%=contextPath%>'+'/images/calendar.gif" id="tributton5'+deviceCount1+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+"'"+endTime1+"'"+',tributton5'+deviceCount1+');" />';
	
	var td = tr.insertCell(8);
	td.className=classCss+"odd";	
	td.innerHTML= '<select  style="width:100px;"  id="f'+deviceCount1+'projectEvaluate" name="f'+deviceCount1+'projectEvaluate"  ><option value="">��ѡ��</option><option value="0110000058000000001">����</option><option value="0110000058000000002">��ְ</option><option value="0110000058000000003">������ְ</option><option value="0110000058000000004">����ְ</option></select>';	
	var td = tr.insertCell(9);
	td.className=classCss+"even";
	td.innerHTML = '<input type="hidden" name="orderDrill1" value="' + deviceCount1 + '"/><img src="'+'<%=contextPath%>'+'/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteDevice1(' +deviceCount1+ ')"/>';

	document.getElementById("equipmentSize1").value=deviceCount1+1;
	deviceCount1+=1;
	currentCount1+=1;

}
function deleteDevice1(deviceNum){

	var rowDetailId = document.getElementById("hidDetailId1").value;
	var rowDeleteId = document.getElementById("f"+deviceNum+"relationNo").value;

	if(	rowDeleteId!=""&&rowDeleteId!=null){
		rowDetailId = rowDetailId+rowDeleteId+",";
		document.getElementById("hidDetailId1").value = rowDetailId;
	}	

	var rowDevice = document.getElementById("f"+deviceNum+"trflag1");
	rowDevice.parentNode.removeChild(rowDevice);
	var rowFlag = document.getElementById("deleteRowFlag1").value;
	rowFlag=rowFlag+deviceNum+",";
	document.getElementById("deleteRowFlag1").value = rowFlag;

	currentCount1-=1;

	//ɾ���������������
	deleteChangeInfoNum1('relationNo');

}
function deleteChangeInfoNum1(warehouseDetailId){
	var rowFlag = document.getElementById("deleteRowFlag1").value;
	var notCheck=rowFlag.split(",");
	var num=1;
	for(var i=0;i<deviceCount1;i++){
		var isCheck=true;
		for(var j=0;notCheck!=""&&j<notCheck.length;j++){
			if(notCheck[j]==i&&notCheck[j]!="") isCheck =false;
		}
		if(isCheck){
			document.getElementById("f"+i+warehouseDetailId).parentNode.innerHTML=num+document.getElementById("f"+i+warehouseDetailId).outerHTML;
			num+=1;
		}
	}	
}
</script>
<div id="tab_box_content1" class="tab_box_content" style="display:none;background:#ccc;" >  
<form id="CheckForm1" name="Form1" action="" method="post"  target="list">
<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">

	<tr  >
		<td  class="inquire_item4"><font color=red>*</font>&nbsp;������</td>
		<td class="inquire_form4">
		<input type="hidden" id="employeeId1" name="employeeId1" value="" class="input_width"/>
		<input type="text"  unselectable="on"   readonly="readonly" value="" maxlength="32" id="employeeName1" name="employeeName1" class='input_width'></input>
		<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectPerson1()"/>
		</td>
		<td class="inquire_item4">&nbsp;</td>
		<td class="inquire_form4">&nbsp;</td>	
	</tr>
	
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0"   >
<tr>
  <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
  <td background="<%=contextPath%>/images/list_15.png">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr align="right">
  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
   <td><auth:ListButton functionId="" css="zj" event="onclick='addDevice1()'" title="JCDP_btn_add"></auth:ListButton>  </td>
</tr>
</table>
</td>
  <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
</tr>
</table>

<table border="0" cellspacing="0" cellpadding="0" class="tab_info" width="100%" id="equipmentTableInfo1">
	<tr  >
		<TD  class="bt_info_odd" width="3%">���</TD>
		<TD class="bt_info_even" width="9%"><font color=red>*</font>��Ŀ����</TD>
		<TD  class="bt_info_odd" width="12%">����</TD>
		<TD class="bt_info_even" width="12%">��λ</TD>

		<TD  class="bt_info_odd" width="12%">Ԥ�ƽ�����Ŀʱ��</TD>
		<TD class="bt_info_even" width="12%">Ԥ���뿪��Ŀʱ�� </TD>
		<TD  class="bt_info_odd" width="12%">ʵ�ʽ�����Ŀʱ��</TD>
		<TD class="bt_info_even" width="12%">ʵ���뿪��Ŀʱ�� </TD>
		<TD  class="bt_info_odd" width="10%">��Ա���� 
		<input type="hidden" id="equipmentSize1" name="equipmentSize1" value="0" />
		<input type="hidden" id="hidDetailId1" name="hidDetailId1" value=""/>
		<input type="hidden" id="deleteRowFlag1" name="deleteRowFlag1" value="" /></TD>
		<TD class="bt_info_even" width="3%">����</TD>
	</tr>
	

</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0"   >
<tr>
 
  <td background="<%=contextPath%>/images/list_15.png" >
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr align="center">
  
  <td  >
  <span class="bc_btn" ><a href="#" onclick="sucess1();newClose();"></a></span>
  <span class="gb_btn"><a href="#" onclick="newClose();"></a></span>
  </td>
</tr>
</table>
</td>
 
</tr>
</table>

</form>
</div> </div> 
</body>
</html>