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
<%@ taglib prefix="auth" uri="auth"%>

<%
String contextPath = request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String userName = (user==null)?"":user.getEmpId();
SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
String curDate = format.format(new Date());

//处理主表信息
ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
  
   BgpHumanTrainingPlan applyInfo = 
		(BgpHumanTrainingPlan) resultMsg.getMsgElement("applyInfo").toPojo(	BgpHumanTrainingPlan.class);
	
  // Map sumAll =(Map)resultMsg.getMsgElement("sumAll").toMap();

     BgpHumanPlanDetail sumAll = new BgpHumanPlanDetail();
     if(resultMsg.getMsgElement("sumAll")!=null){
    	 sumAll = (BgpHumanPlanDetail) resultMsg.getMsgElement("sumAll").toPojo(BgpHumanPlanDetail.class);
     }

	
 
List<MsgElement> list = resultMsg.getMsgElements("detailInfo");
List<BgpHumanPlanDetail> beanList=new ArrayList<BgpHumanPlanDetail>(0);
if(list!=null){
	beanList = new ArrayList<BgpHumanPlanDetail>(list.size());	
	for (int i = 0; i < list.size(); i++) {
		beanList.add((BgpHumanPlanDetail) list.get(i).toPojo(
				BgpHumanPlanDetail.class));
	}
}

%>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
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
 
 
 
function sucess() { 
	if(currentCount==0){
		alert("请添加一条培训信息后再点击保存");
		return ;
	}
	if(checkForm()){
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/rm/em/toSaveHumanTrainingDetail.srq";
		form.submit();
		alert('保存成功');
		newClose();
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
			if(!notNullForCheck("fy"+i+"trainContent","培训内容")) return false;
		}
		//var projectEvaluate = document.getElementById("fy"+i+"projectEvaluate").value;
	//	var sprojectEvaluate = encodeURI(encodeURI(projectEvaluate));
		//alert(sprojectEvaluate);
	}
 
	return true;
	
}
 

function notNullForCheck(filedName,fieldInfo){

	if(document.getElementById(filedName).value==null||document.getElementById(filedName).value==""){
		alert(fieldInfo+"不能为空");
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
			alert(fieldInfo+"格式不正确,请重新输入");
			return false;
		}else{
			return true;
		}
	}else{
		return true;
	}
}

var currentCount=parseInt('0');
var deviceCount = parseInt('0');
var listSize =parseInt('<%=beanList.size()%>');  
deviceCount=deviceCount+listSize;
currentCount=currentCount+listSize;
 

function calculateCost(i){
	
	var trainTotal=0;
 
	var trainCost = document.getElementById("fy"+i+"trainCost").value;
	var trainTransportation = document.getElementById("fy"+i+"trainTransportation").value;
	var trainMaterials = document.getElementById("fy"+i+"trainMaterials").value;
	var trainPlaces = document.getElementById("fy"+i+"trainPlaces").value;
	var trainAccommodation = document.getElementById("fy"+i+"trainAccommodation").value;
	var trainOther = document.getElementById("fy"+i+"trainOther").value;
 
 
	if(checkNaN("fy"+i+"trainCost")){
		trainTotal = parseFloat(trainTotal)+parseFloat(trainCost);
 
	 	}
	if(checkNaN("fy"+i+"trainTransportation")){
		trainTotal = parseFloat(trainTotal)+parseFloat(trainTransportation);
	}
	if(checkNaN("fy"+i+"trainMaterials")){
		trainTotal = parseFloat(trainTotal)+parseFloat(trainMaterials);
	}
	if(checkNaN("fy"+i+"trainPlaces")){
		trainTotal = parseFloat(trainTotal)+parseFloat(trainPlaces);
	}
	if(checkNaN("fy"+i+"trainAccommodation")){
		trainTotal = parseFloat(trainTotal)+parseFloat(trainAccommodation);
	}
	if(checkNaN("fy"+i+"trainOther")){
		trainTotal = parseFloat(trainTotal)+parseFloat(trainOther);
	}
 
	document.getElementById("fy"+i+"trainTotal").value=substrin(trainTotal);
 
}
function allNumber(){
	
	var trainTotal=0;
	var a1=0;
	var a2=0;
	var a3=0;
	var a4=0;
	var a5=0;
	var a6=0;
	var a7=0;
	for(var i=0;i<deviceCount;i++){
	var trainCost = document.getElementById("fy"+i+"trainCost").value;
	var trainTransportation = document.getElementById("fy"+i+"trainTransportation").value;
	var trainMaterials = document.getElementById("fy"+i+"trainMaterials").value;
	var trainPlaces = document.getElementById("fy"+i+"trainPlaces").value;
	var trainAccommodation = document.getElementById("fy"+i+"trainAccommodation").value;
	var trainOther = document.getElementById("fy"+i+"trainOther").value;
	var trainClass = document.getElementById("fy"+i+"trainClass").value;
 
	if(checkNaN("fy"+i+"trainCost")){
		trainTotal = parseFloat(trainTotal)+parseFloat(trainCost);
		a1 = parseFloat(a1)+parseFloat(trainCost);
	 	}
	if(checkNaN("fy"+i+"trainClass")){
 
		a7 = parseFloat(a7)+parseFloat(trainClass);
	 	}
	if(checkNaN("fy"+i+"trainTransportation")){
		trainTotal = parseFloat(trainTotal)+parseFloat(trainTransportation);
		a2 = parseFloat(a2)+parseFloat(trainTransportation);
	}
	if(checkNaN("fy"+i+"trainMaterials")){
		trainTotal = parseFloat(trainTotal)+parseFloat(trainMaterials);
		a3 = parseFloat(a3)+parseFloat(trainMaterials);
	}
	if(checkNaN("fy"+i+"trainPlaces")){
		trainTotal = parseFloat(trainTotal)+parseFloat(trainPlaces);
		a4 = parseFloat(a4)+parseFloat(trainPlaces);
	}
	if(checkNaN("fy"+i+"trainAccommodation")){
		trainTotal = parseFloat(trainTotal)+parseFloat(trainAccommodation);
		a5 = parseFloat(a5)+parseFloat(trainAccommodation);
	}
	if(checkNaN("fy"+i+"trainOther")){
		trainTotal = parseFloat(trainTotal)+parseFloat(trainOther);
		a6 = parseFloat(a6)+parseFloat(trainOther);
	}
	document.getElementById("a1").innerText=substrin(a1);
	document.getElementById("a2").innerText=substrin(a2);
	document.getElementById("a3").innerText=substrin(a3);
	document.getElementById("a4").innerText=substrin(a4);
	document.getElementById("a5").innerText=substrin(a5);
	document.getElementById("a6").innerText=substrin(a6);
	document.getElementById("a7").innerText=substrin(a7);
	document.getElementById("a9").innerText=substrin(trainTotal);
	document.getElementById("trainAmount").value=substrin(trainTotal);
	}
}

function substrin(str)
{ 
	str = Math.round(str * 10000) / 10000;
	return(str); 
 }

function checkNaN(numids){

	 var str = document.getElementById(numids).value;
 
	 if(str!=""){		 
		if(isNaN(str)){
			alert("请输入数字");
			document.getElementById(numids).value="";
			return false;
		}else{
			return true;
		}
	  }

}
var natureP="";
//加一行人员
function addDevice1(trainDetailNos,trainContents,classifications,trainNumbers,trainClasss,trainCosts,trainTransportations,trainMaterialss,trainPlacess,trainAccommodations,trainOthers){
 //	trainDetailNo,bsflag,trainContent,classification,trainNumber,trainClass,trainCost,trainTransportation,trainMaterials,trainPlaces,trainAccommodation,trainOther,trainTotal
	var  trainDetailNo="";
 
	var  trainContent="";
	var  classification="";
	var  trainNumber="";
	var  trainClass="";
	var  trainCost="";
	var  trainTransportation="";
	var  trainMaterials="";
	var  trainPlaces="";
	var  trainAccommodation="";
	var  trainOther="";
 
	
	if(trainDetailNos != null && trainDetailNos != ""){
		trainDetailNo =trainDetailNos;
	}
 
	if(trainContents != null && trainContents != ""){
		trainContent=trainContents;
	}
	if(classifications != null && classifications != ""){
		classification =classifications;
	}
	if(trainNumbers != null && trainNumbers != ""){
		trainNumber =trainNumbers;
	}
	if(trainClasss != null && trainClasss != ""){
		trainClass =trainClasss;
	}
	if(trainCosts != null && trainCosts != ""){
		trainCost =trainCosts;
	}
	if(trainTransportations != null && trainTransportations != ""){
		trainTransportation =trainTransportations;
	}
	if(trainMaterialss != null && trainMaterialss != ""){
		trainMaterials=trainMaterialss;
	}
	if(trainPlacess != null && trainPlacess != ""){
		trainPlaces=trainPlacess;
	}
	if(trainAccommodations != null && trainAccommodations != ""){
		trainAccommodation=trainAccommodations;
	}
	if(trainOthers != null && trainOthers != ""){
		trainOther=trainOthers;
	}
 
  var projectInfo_no=document.getElementById("projectInfoNo").value;
  var spare_no=document.getElementById("spare1").value;
  
  //添加tr
	var tr = document.getElementById("equipmentTableInfo").insertRow();

	tr.align ="center";
	tr.id = "fy"+deviceCount+"trflag";

  	if(deviceCount % 2 == 1){  
  		tr.className = "odd";
	}else{ 
		tr.className = "even";
	}	
  //需求子表id,为空
 	tr.insertCell().innerHTML  ='<input type="hidden" id="fy'+deviceCount+'trainDetailNo" name="fy'+deviceCount+'trainDetailNo" value="'+trainDetailNo+'"/><input type="hidden" id="fy'+deviceCount+'bsflag" name="fy'+deviceCount+'bsflag" value="0"/>'+'<input type="hidden" id="fy'+deviceCount+'spare1" name="fy'+deviceCount+'spare1" value="'+projectInfo_no+'"/><input type="hidden" id="fy'+deviceCount+'spare2" name="fy'+deviceCount+'spare2" value="'+spare_no+'"/><input type="text" maxlength="32" id="fy'+deviceCount+'trainContent" name="fy'+deviceCount+'trainContent"  value="'+trainContent+'" class="input_width" />';	
	//请选择 
	if(classification == ""){ 
 	tr.insertCell().innerHTML = '<select  style="width:100px;"  id="fy'+deviceCount+'classification"  name="fy'+deviceCount+'classification"   ><option value="1" >质量</option><option value="2">HSE</option><option value="4">HSE和质量</option><option value="5">操作技能</option><option value="3">其他</option></select>';
	}else{
		getSelectList(classification);
		tr.insertCell().innerHTML = '<select  style="width:100px;"  id="fy'+deviceCount+'classification"  name="fy'+deviceCount+'classification"   >'+natureP+'</select>';
		
	}
 	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'trainNumber" name="fy'+deviceCount+'trainNumber"  value="'+trainNumber+'" class="input_width" />';	
	//请选择
	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'trainClass" name="fy'+deviceCount+'trainClass"  onblur="allNumber();"  value="'+trainClass+'" class="input_width" />';
 	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'trainCost"  onblur="calculateCost('+deviceCount+');allNumber();"  name="fy'+deviceCount+'trainCost"  value="'+trainCost+'" class="input_width" />';	
 	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'trainTransportation"  onblur="calculateCost('+deviceCount+');allNumber();"  name="fy'+deviceCount+'trainTransportation" value="'+trainTransportation+'" class="input_width" />';	
 	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'trainMaterials"  onblur="calculateCost('+deviceCount+');allNumber();"  name="fy'+deviceCount+'trainMaterials"  value="'+trainMaterials+'" class="input_width" />';	
	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'trainPlaces"  onblur="calculateCost('+deviceCount+');allNumber();" name="fy'+deviceCount+'trainPlaces"  value="'+trainPlaces+'"  class="input_width" />';
 	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'trainAccommodation" onblur="calculateCost('+deviceCount+');allNumber();"  name="fy'+deviceCount+'trainAccommodation"  value="'+trainAccommodation+'" class="input_width" />';	
 	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'trainOther" onblur="calculateCost('+deviceCount+');allNumber();"  name="fy'+deviceCount+'trainOther"  value="'+trainOther+'"  class="input_width" />';	
  
	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'trainTotal"  readonly="readonly"  name="fy'+deviceCount+'trainTotal"  value=""  class="input_width" />';	
 
	tr.insertCell().innerHTML= '<input type="hidden" name="orderDrill" value="' + deviceCount + '"/><img src="'+'<%=contextPath%>'+'/images//delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteDevice('+deviceCount+')"/>';

	document.getElementById("equipmentSize").value=deviceCount+1;
	deviceCount+=1;
	currentCount+=1;

}
 
function deleteDevice(deviceNum){
 
	var rowDetailId = document.getElementById("hidDetailId").value;
	var rowDeleteId = document.getElementById("fy"+deviceNum+"trainDetailNo").value;
 
	if(	rowDeleteId!=""&&rowDeleteId!=null){
		rowDetailId = rowDetailId+rowDeleteId+",";
		document.getElementById("hidDetailId").value = rowDetailId;
		//删除子表信息
		var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
		var submitStr='JCDP_TABLE_NAME=BGP_COMM_HUMAN_TRAINING_DETAIL&JCDP_TABLE_ID='+rowDeleteId+'&bsflag=1';
		syncRequest('Post',path,encodeURI(encodeURI(submitStr)));
		deleteChangeInfoNum2('trainDetailNo')
	}	

	var rowDevice = document.getElementById("fy"+deviceNum+"trflag"); 
 	rowDevice.parentNode.removeChild(rowDevice);
	var rowFlag = document.getElementById("deleteRowFlag").value;
	rowFlag=rowFlag+deviceNum+",";
	document.getElementById("deleteRowFlag").value = rowFlag;

	currentCount-=1;

	//删除后重新排列序号
   //deleteChangeInfoNum('trainDetailNo');

}


function  getSelectList(selectValue){
		natureP='<option value="">请选择</option>';
		if(selectValue=='1'){
			natureP+='<option value="1" selected="selected" >质量</option>';	
			natureP+='<option value="2" >HSE</option>';
			natureP+='<option value="4" >HSE和质量</option>';
			natureP+='<option value="5" >操作技能</option>';
			natureP+='<option value="3" >其他</option>';
		}else if(selectValue=='2'){
			natureP+='<option value="1"  >质量</option>';	
			natureP+='<option value="2"  selected="selected" >HSE</option>';
			natureP+='<option value="4" >HSE和质量</option>';
			natureP+='<option value="5" >操作技能</option>';
			natureP+='<option value="3" >其他</option>';
		}else if(selectValue=='3'){
			natureP+='<option value="1" >质量</option>';	
			natureP+='<option value="2" >HSE</option>';
			natureP+='<option value="4" >HSE和质量</option>';
			natureP+='<option value="5" >操作技能</option>';
			natureP+='<option value="3"  selected="selected" >其他</option>';
		} 
		else if(selectValue=='4'){
			natureP+='<option value="1" >质量</option>';	
			natureP+='<option value="2" >HSE</option>';
			natureP+='<option value="4"  selected="selected" >HSE和质量</option>';
			natureP+='<option value="5" >操作技能</option>';
			natureP+='<option value="3"  >其他</option>';
		}
		else if(selectValue=='5'){
			natureP+='<option value="1" >质量</option>';	
			natureP+='<option value="2" >HSE</option>';
			natureP+='<option value="4" >HSE和质量</option>';
			natureP+='<option value="5"  selected="selected" >操作技能</option>';
			natureP+='<option value="3" >其他</option>';
		}
		
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
		 
		   // document.getElementById("fy"+rowFlag+"bsflag").value="1"; 
		 
			
			num+=1;
		}
	}	
	// document.getElementById("fy"+rowFlag+"bsflag").value="1"; 
}

function deleteChangeInfoNum2(warehouseDetailId){
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
			 document.getElementById("fy"+i+"bsflag").value="1"; 
			num+=1;
		}
	}	 
}

function toUploadFile(){
	var obj=window.showModalDialog('<%=contextPath%>/rm/em/singleHuman/humanTrainingPlan/humanImportFile.jsp',"","dialogHeight:500px;dialogWidth:600px");
	if(obj!="" && obj!=undefined ){		
		var checkStr = obj.split(",");
		for(var i=0;i<checkStr.length-1;i++){
			var check = checkStr[i].split("@");  
			addDevice1("",check[0],check[1],check[2],check[3],check[4],check[5],check[6],check[7],check[8],check[9]);
		}
		
	}

}


function downloadModelA(){
		var  filename="人员培训计划导入";
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		window.location.href="<%=contextPath%>/rm/em/humanRequest/download.jsp?path=/rm/em/singleHuman/humanTrainingPlan/ImpleHumanPlan.xlsx&filename="+filename+".xlsx";
	}	
	 
</script>
<title>人员培训计划添加</title>
</head>
<body style="overflow-y:auto" > 
<form id="CheckForm" name="Form0" action="" method="post"  target="list">
<div  style="display:none;">
<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
	<tr  >
	<td  class="inquire_item4"><font color=red></font>&nbsp;单号：</td>
	<td class="inquire_form4">
	<input type="hidden" id="trainPlanNo" name="trainPlanNo" value="<%=applyInfo.getTrainPlanNo()==null?"":applyInfo.getTrainPlanNo() %>"/>
 
	<input type="text" style="color: gray;" value="<%=applyInfo.getPlanNumber()==null?"申请提交后系统自动生成":applyInfo.getPlanNumber()%>" id="planNumber"  name="planNumber" class='input_width' readonly="readonly"></input>  
	</td>
	<td class="inquire_item4"> </td> 
	<td class="inquire_form4"> </td>	
	</tr>

	<tr  >
		<td  class="inquire_item4"><font color=red></font>&nbsp;培训对象：</td>
		<td class="inquire_form4">
		<input type="text"   value="<%=applyInfo.getTrainObject()==null?"":applyInfo.getTrainObject()%>" id="trainObject" name="trainObject" class='input_width'></input>
		</td>
		<td class="inquire_item4">培训地点：</td> 
		<td class="inquire_form4">
		<input type="text" value="<%=applyInfo.getTrainAddress()==null?"":applyInfo.getTrainAddress()%>" id="trainAddress" name="trainAddress" class='input_width'  ></input>
		</td>	
	</tr>
	
	<tr  >
		<td  class="inquire_item4"><font color=red></font>&nbsp;项目名称：</td>
		<td class="inquire_form4">
		<input type="hidden" id="projectInfoNo" name="projectInfoNo" value="<%=applyInfo.getProjectInfoNo()==null?"":applyInfo.getProjectInfoNo()%>"/>
		<input type="text"  readonly="readonly" value="<%=applyInfo.getProjectName()==null?"":applyInfo.getProjectName()%>" id="projectName" name="projectName" class='input_width'></input>
		</td>
		<td class="inquire_item4">施工队伍：</td> 
		<td class="inquire_form4">
		<input type="hidden" value="<%=applyInfo.getSpare1()==null?"":applyInfo.getSpare1()%>" id="spare1" name="spare1"></input>
		<input type="text" value="<%=applyInfo.getApplicantOrgName()==null?"":applyInfo.getApplicantOrgName()%>" id="applicantOrgName" name="applicantOrgName" class='input_width' readonly="readonly"></input>
		</td>	
	</tr>

	<tr  >
	<td  class="inquire_item4"><font color=red></font>&nbsp;提交人：</td>
	<td class="inquire_form4">
	<input type="text" value="<%=applyInfo.getApplicantName()==null?"":applyInfo.getApplicantName()%>" id="applicantName" name="applicantName" class='input_width' readonly="readonly"></input>
	</td>
	<td class="inquire_item4">提交时间：</td> 
	<td class="inquire_form4">
	<input type="text" value="<%=applyInfo.getCreateDate()==null?"":applyInfo.getCreateDate()%>" id="createDate" name="createDate" class='input_width' readonly="readonly">	</input>&nbsp;
	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(applyDate,tributton1);" />
	</td>	
	</tr>
	<tr  >
	<td  class="inquire_item4"><font color=red></font>&nbsp;培训目的：</td>
	<td class="inquire_form4"  colspan="3">
	<input type="text"  maxlength="100" style="width:800px;" value="<%=applyInfo.getTrainPurpose()==null?"":applyInfo.getTrainPurpose()%>" id="trainPurpose" name="trainPurpose" class='input_width'  ></input>  
	</td>
	 
	</tr>
	<tr>
	<td  class="inquire_item4"><font color=red></font>&nbsp;培训时间：</td>
	<td class="inquire_form4" colspan="3">
	<input type="hidden" value="<%=applyInfo.getTrainAmount()==null?"":applyInfo.getTrainAmount()%>" id="trainAmount" name="trainAmount"></input>
	<input type="text"    style="width:800px;" value="<%=applyInfo.getTrainCycle()==null?"":applyInfo.getTrainCycle()%>" id="trainCycle" name="trainCycle" class='input_width'  ></input>  
	</td>
 	</tr>
	
</table>
<table width="100%" border="1" cellspacing="0" cellpadding="0"   >
<tr align="center">
<td width="30%" ><font color=red>合计（元）</font> </td>
<td width="7%"><label id="a7"><%=sumAll.getTrainClass()==null?"":sumAll.getTrainClass()%></label></td>
<td  width="7%"><label id="a1"><%=sumAll.getTrainCost()==null?"":sumAll.getTrainCost()%></label></td>
<td width="7%"><label id="a2"><%=sumAll.getTrainTransportation()==null?"":sumAll.getTrainTransportation()%></label></td>
<td width="7%"><label id="a3"><%=sumAll.getTrainMaterials()==null?"":sumAll.getTrainMaterials()%></label></td>
<td width="7%"><label id="a4"><%=sumAll.getTrainPlaces()==null?"":sumAll.getTrainPlaces()%></label></td>
<td width="7%"><label id="a5"><%=sumAll.getTrainAccommodation()==null?"":sumAll.getTrainAccommodation()%></label></td>
 <td width="7%"><label id="a6"><%=sumAll.getTrainOther()==null?"":sumAll.getTrainOther()%></label></td>
<td width="7%"><label id="a9" ><%=sumAll.getTrainTotal()==null?"":sumAll.getTrainTotal()%></label></td>
<td width="4%"><label id="a8" ></label></td>
</tr>
</table>

</div>
<table width="100%" border="0" cellspacing="0" cellpadding="0"   >
<tr>
  <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
  <td background="<%=contextPath%>/images/list_15.png">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr align="right">
  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  
  <a    href="javascript:downloadModelA()" >下载人员培训计划模板</a>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </td>
 
  <td> 
  <auth:ListButton functionId="" css="dr" event="onclick='toUploadFile()'" title="快速导入"></auth:ListButton>
  <auth:ListButton functionId="" css="zj" event="onclick='addDevice1()'" title="JCDP_btn_add"></auth:ListButton>
    </td>
</tr>
</table>
</td>
  <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
</tr>
</table>
 
<table border="0"  width="100%"  cellspacing="0" cellpadding="0" class="tab_info"   id="equipmentTableInfo">
	<tr> 
	 
		<TD  class="bt_info_odd" width="15%" >培训内容</TD>
		<TD  class="bt_info_even" width="5%" >分类</TD>
		<TD  class="bt_info_odd"  width="8%">人数</TD>
		<TD class="bt_info_even"  width="8%">学时</TD>
		<TD  class="bt_info_odd"   width="8%"><font color=black>授课费</font></TD>
		<TD class="bt_info_even"  width="8%"><font color=black>交通费</font> </TD>
		<TD  class="bt_info_odd"  width="8%"><font color=black>材料费</font></TD>
		<TD class="bt_info_even"   width="8%"><font color=black>场地费 </font></TD>
		<TD class="bt_info_odd" width="8%"><font color=black>食宿费 </font></TD>
		<TD class="bt_info_even"  width="8%" ><font color=black>其他费用</font> </TD>
		<TD class="bt_info_odd"  width="8%" ><font color=black>费用合计（元）</font>
		<input type="hidden" id="equipmentSize" name="equipmentSize"   value="<%=beanList.size()%>" />
		<input type="hidden" id="hidDetailId" name="hidDetailId" value=""/>
		<input type="hidden" id="deleteRowFlag" name="deleteRowFlag" value="" />
		</TD>
		<TD class="bt_info_even" width="3%">操作</TD>
	</tr>
		 <%
			for (int i = 0; i < beanList.size(); i++) {
				String className = "";
				if (i % 2 == 1) {
					className = "odd";
				} else {
					className = "even";
				} 
				BgpHumanPlanDetail applyDetailInfo = beanList.get(i);
				String ss="fy"+String.valueOf(i)+"deviceUnit";
		  %>
			<tr class="<%=className%>" id="fy<%=i%>trflag"  >
			
			<td><%=i+1 %><input type="hidden" name="fy<%=i%>trainDetailNo" id="fy<%=i%>trainDetailNo" value="<%=applyDetailInfo.getTrainDetailNo()==null?"":applyDetailInfo.getTrainDetailNo()%>"/>
			<input type="hidden" name="fy<%=i%>bsflag" id="fy<%=i%>bsflag" value="<%=applyDetailInfo.getBsflag()==null?"":applyDetailInfo.getBsflag()%>"/></td>
		 
			<td><input type="text" class="input_width" id="fy<%=i%>trainContent" name="fy<%=i%>trainContent" value="<%=applyDetailInfo.getTrainContent()==null?"":applyDetailInfo.getTrainContent()%>"   />&nbsp;
			</td>
 
			<td>
			<select id="fy<%=i%>classification" style="width:100px;" name="fy<%=i%>classification"   >
			<option value="1" <%if(applyDetailInfo.getClassification().equals ("1")){%> selected="selected" <%}%> >质量</option>
			<option value="2" <%if(applyDetailInfo.getClassification().equals ("2")){%> selected="selected" <%}%> >HSE</option>
			<option value="4" <%if(applyDetailInfo.getClassification().equals ("4")){%> selected="selected" <%}%> >HSE和质量</option>
			<option value="5" <%if(applyDetailInfo.getClassification().equals ("5")){%> selected="selected" <%}%> >操作技能</option>
			<option value="3" <%if(applyDetailInfo.getClassification().equals ("3")){%> selected="selected" <%}%> >其他</option>
			</select>
			</td>
		 
			<td><input type="text" class="input_width" id="fy<%=i%>trainNumber" name="fy<%=i%>trainNumber"     value="<%=applyDetailInfo.getTrainNumber()==null?"":applyDetailInfo.getTrainNumber()%>"  />&nbsp;
			</td> 
			<td><input type="text"class="input_width"  name="fy<%=i%>trainClass" id="fy<%=i%>trainClass"  onblur="allNumber();"  value="<%=applyDetailInfo.getTrainClass()==null?"":applyDetailInfo.getTrainClass()%>"    />&nbsp;</td>
			<td><input type="text" class="input_width" name="fy<%=i%>trainCost"  onblur="calculateCost('<%=i%>');allNumber();" id="fy<%=i%>trainCost"       value="<%=applyDetailInfo.getTrainCost()==null?"":applyDetailInfo.getTrainCost()%>" />&nbsp;</td>
			<td><input type="text" class="input_width" name="fy<%=i%>trainTransportation"  onblur="calculateCost('<%=i%>');allNumber();" id="fy<%=i%>trainTransportation"      value="<%=applyDetailInfo.getTrainTransportation()==null?"":applyDetailInfo.getTrainTransportation()%>" />&nbsp;</td>
			<td><input type="text" class="input_width" name="fy<%=i%>trainMaterials"  onblur="calculateCost('<%=i%>');allNumber();" id="fy<%=i%>trainMaterials"     value="<%=applyDetailInfo.getTrainMaterials()==null?"":applyDetailInfo.getTrainMaterials()%>"    />&nbsp;</td>
			<td><input type="text" class="input_width" name="fy<%=i%>trainPlaces"  onblur="calculateCost('<%=i%>');allNumber();" id="fy<%=i%>trainPlaces"      value="<%=applyDetailInfo.getTrainPlaces()==null?"":applyDetailInfo.getTrainPlaces()%>" />&nbsp;</td>
			<td><input type="text" class="input_width"  name="fy<%=i%>trainAccommodation"  onblur="calculateCost('<%=i%>');allNumber();" id="fy<%=i%>trainAccommodation"       value="<%=applyDetailInfo.getTrainAccommodation()==null?"":applyDetailInfo.getTrainAccommodation()%>" />&nbsp;</td>
			 <td><input type="text" class="input_width" name="fy<%=i%>trainOther"  onblur="calculateCost('<%=i%>');allNumber();" id="fy<%=i%>trainOther"     value="<%=applyDetailInfo.getTrainOther()==null?"":applyDetailInfo.getTrainOther()%>" />&nbsp;</td>
			<td><input type="text"  class="input_width" name="fy<%=i%>trainTotal" readonly="readonly" id="fy<%=i%>trainTotal"      value="<%=applyDetailInfo.getTrainTotal()==null?"":applyDetailInfo.getTrainTotal()%>" />&nbsp;</td>
			<td ><input type="hidden" name="order" value=""/><img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteDevice('<%=i%>')"/></td>
		 
			</tr>	
		  <%
			}
		  %>
 
	
 
</table>	 
 
<table width="100%" border="0" cellspacing="0" cellpadding="0"   >
<tr>
 
  <td background="<%=contextPath%>/images/list_15.png" >
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr align="center">
 
  <td  >
  <span  class="bc_btn"> <a href="#" onclick="sucess(); "></a></span>
  <span class="gb_btn"> <a href="#" onclick="newClose();"></a></span>
  </td>
</tr>
</table>
</td>
 
</tr>
</table>

</form>
</body>
</html>