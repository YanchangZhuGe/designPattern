<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
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

	//处理申请单信息
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	BgpProjectHumanRelief applyInfo = (BgpProjectHumanRelief) resultMsg
			.getMsgElement("applyInfo").toPojo(
					BgpProjectHumanRelief.class);
	System.out.println(resultMsg
			.getMsgElement("applyInfo").toMap());
	List<MsgElement> list = resultMsg.getMsgElements("detailInfo");
	List<BgpProjectHumanReliefdetail> beanList=new ArrayList<BgpProjectHumanReliefdetail>(0);
	if(list!=null){
		beanList = new ArrayList<BgpProjectHumanReliefdetail>(list.size());	
		for (int i = 0; i < list.size(); i++) {
			beanList.add((BgpProjectHumanReliefdetail) list.get(i).toPojo(
					BgpProjectHumanReliefdetail.class));
		}
	}

	String degreeStr = resultMsg.getValue("degreeStr");
	
	String workYearStr = resultMsg.getValue("workYearStr");
	
	String ageStr = resultMsg.getValue("ageStr");
	
	String buttonViewFile = resultMsg.getValue("buttonView"); 
	
	String projectInfoType = resultMsg.getValue("projectInfoType");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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

<!--Remark JavaScript定义-->
<script language="javaScript">
cruConfig.contextPath='<%=contextPath %>';
var currentCount=parseInt('<%=beanList.size()%>');
var deviceCount = parseInt('<%=beanList.size()%>');



var currentCount=parseInt('0');
var deviceCount = parseInt('0');
var listSize =parseInt('<%=beanList.size()%>');  
deviceCount=deviceCount+listSize;
currentCount=currentCount+listSize;

//学历初始化
var codeStr = '<%=degreeStr%>';
//年龄初始化
var ageStr = '<%=ageStr%>';
//工作年限初始化
var workYearStr = '<%=workYearStr%>';

var optionStr=codeStr.split("@");
var ge_str='<option value="">请选择</option>';
for(var i=0;i<optionStr.length;i++){
	ge_str+='<option value="'+optionStr[i].split(",")[0]+'" >'+optionStr[i].split(",")[1]+'</option>';
}
var ageOptionStr=ageStr.split("@");
var age_str='<option value="">请选择</option>';
for(var i=0;i<ageOptionStr.length;i++){
	age_str+='<option value="'+ageOptionStr[i].split(",")[0]+'" >'+ageOptionStr[i].split(",")[1]+'</option>';
}
var workOptionStr=workYearStr.split("@");
var work_str='<option value="">请选择</option>';
for(var i=0;i<workOptionStr.length;i++){
	work_str+='<option value="'+workOptionStr[i].split(",")[0]+'" >'+workOptionStr[i].split(",")[1]+'</option>';
}

function save(){
	if(checkForm()){
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/rm/em/toSaveReliefRequired.srq";
		form.submit();
		newClose();
	}

}

function checkForm(){
	
	if(currentCount == 0){
		alert("请分配一条记录");
		return false;
	}
	var rowFlag = document.getElementById("deleteRowFlag").value;	
	var notCheck=rowFlag.split(",");
	for(var i=0;i<deviceCount;i++){
		var isCheck=true;
		for(var j=0;notCheck!=""&&j<notCheck.length;j++){
			if(notCheck[j]==i) isCheck =false;
		}
 
		if(isCheck){
 
			if(!notNullForCheck("fy"+i+"applyTeam","班组")) return false;
			if(!notNullForCheck("fy"+i+"post","岗位")) return false;
			if(!notNullForCheck("fy"+i+"peopleNumber","需求人数")) return false;
			if(!notNullForCheck("fy"+i+"planStartDate","计划进入时间")) return false;
			if(!notNullForCheck("fy"+i+"planEndDate","计划离开时间")) return false;
		}
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


function addLine(){
	
	var tr = document.getElementById("lineTable").insertRow();
	
	tr.align="center";		

	tr.id = "fy"+deviceCount+"trflag";
	
	if(deviceCount % 2 == 1){  
  		classCss = "even_";
	}else{ 
		classCss = "odd_";
	}

	var startTime = "fy"+deviceCount+"planStartDate";
	var endTime = "fy"+deviceCount+"planEndDate";
	
	var td = tr.insertCell(0);
	td.className=classCss+"odd";
	td.innerHTML = currentCount+1+'<input type="hidden" id="fy'+deviceCount+'postNo" name="fy'+deviceCount+'postNo" value=""/>';
		
	var td = tr.insertCell(1);
	td.className=classCss+"even";
	td.innerHTML = '<select class="select_width"  name="fy'+ deviceCount + 'applyTeam" id="fy'+ deviceCount + 'applyTeam" onchange="getPost('+deviceCount+')" >'+getApplyTeam()+'</select>'+'<input type="hidden" id="fy'+deviceCount+'bsflag" name="fy'+deviceCount+'bsflag" value="0"/>';
	
	var td = tr.insertCell(2);
	td.className=classCss+"odd";
	td.innerHTML = '<select class="select_width"   name="fy'+ deviceCount + 'post" id="fy'+ deviceCount + 'post"  > <option value="">请选择</option> </select>';

	
	var td = tr.insertCell(3);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'peopleNumber" name="fy'+deviceCount+'peopleNumber" onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);" value="" class="input_width" />';
	
	var td = tr.insertCell(4);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" onpropertychange="calDays('+deviceCount+')"  readonly="readonly" maxlength="32" id="fy'+deviceCount+'planStartDate" name="fy'+deviceCount+'planStartDate" value="" class="input_width" />'+'<img src="'+'<%=contextPath%>'+'/images/calendar.gif" id="tributton2'+deviceCount+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+"'"+startTime+"'"+',tributton2'+deviceCount+');" />';
	
	var td = tr.insertCell(5);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" onpropertychange="calDays('+deviceCount+')" readonly="readonly" maxlength="32" id="fy'+deviceCount+'planEndDate" name="fy'+deviceCount+'planEndDate" value="" class="input_width" />'+'<img src="'+'<%=contextPath%>'+'/images/calendar.gif" id="tributton3'+deviceCount+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+"'"+endTime+"'"+',tributton3'+deviceCount+');" />';
	
	var td = tr.insertCell(6);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'spare1" name="fy'+deviceCount+'spare1"  value="" readonly="readonly" class="input_width" />';
	
	var td = tr.insertCell(7);
	td.className=classCss+"even";
	td.innerHTML = '<select id="fy'+deviceCount+'age" name="fy'+deviceCount+'age" class="select_width">'+age_str+'</select>';

	var td = tr.insertCell(8);
	td.className=classCss+"odd";
	td.innerHTML = '<select id="fy'+deviceCount+'workYears" name="fy'+deviceCount+'workYears" class="select_width">'+work_str+'</select>';
	
	var td = tr.insertCell(9);
	td.className=classCss+"even";
	td.innerHTML = '<select id="fy'+deviceCount+'culture" name="fy'+deviceCount+'culture" class="select_width">'+ge_str+'</select>';
	
			
	var td = tr.insertCell(10);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'notes" name="fy'+deviceCount+'notes"  value="" class="input_width" />';
	

	var td = tr.insertCell(11);
	td.className=classCss+"even";
	td.innerHTML = '<input type="hidden" name="order" value="' + deviceCount + '"/>'+'<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteDevice(' +deviceCount + ')"/>';
	
	document.getElementById("equipmentSize").value=deviceCount+1;
	deviceCount+=1;
	currentCount+=1;
	
}

//得到所有班组
var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeamP","");	

function getApplyTeam(){

	var applypost_str='<option value="">请选择</option>';
	for(var i=0;i<applyTeamList.detailInfo.length;i++){
		var templateMap = applyTeamList.detailInfo[i];
		//选择当前班组
		applypost_str+='<option value="'+templateMap.value+'" >'+templateMap.label+'</option>';
	}
	
	return applypost_str;

}

//联动调用函数
function getPost( id ){

    var applyTeam = "applyTeam="+document.getElementById("fy"+id+"applyTeam").value;   
	var applyPost=jcdpCallService("HumanRequiredSrv","queryApplyPostList",applyTeam);	

	var selectObj = document.getElementById("fy"+id+"post");
	document.getElementById("fy"+id+"post").innerHTML="";
	selectObj.add(new Option('请选择',""),0);
	if(applyPost.detailInfo!=null){
	for(var i=0;i<applyPost.detailInfo.length;i++){
		var templateMap = applyPost.detailInfo[i];
		selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	}
	}
}
function calDays(i){
	var startTime = document.getElementById("fy"+i+"planStartDate").value;
	var returnTime = document.getElementById("fy"+i+"planEndDate").value;
	if(startTime!=null&&startTime!=''&&returnTime!=null&&returnTime!=''){
	var days=(new Date(returnTime.replace(/-/g,'/'))-new Date(startTime.replace(/-/g,'/')))/3600/24/1000;
	if(days<0){
		alert("预计离开项目时间应大于预计进入项目时间");
		return false;
	}else{
		document.getElementById("fy"+i+"spare1").value = days+1;
		return true;
	}
	}
	return true;
}

function deleteDevice(deviceNum){

	var rowDetailId = document.getElementById("hidDetailId").value;
	var rowDeleteId = document.getElementById("fy"+deviceNum+"postNo").value;

	if(	rowDeleteId!=""&&rowDeleteId!=null){
		rowDetailId = rowDetailId+rowDeleteId+",";
		document.getElementById("hidDetailId").value = rowDetailId;
	}	

	var rowDevice = document.getElementById("fy"+deviceNum+"trflag");
	rowDevice.parentNode.removeChild(rowDevice);
	var rowFlag = document.getElementById("deleteRowFlag").value;
	rowFlag=rowFlag+deviceNum+",";
	document.getElementById("deleteRowFlag").value = rowFlag;

	//currTrNum-=1;
	currentCount-=1;
 
	//删除后重新排列序号
	deleteChangeInfoNum('postNo');

}

function deleteDeviceEdit(deviceNum){

	var rowDetailId = document.getElementById("hidDetailId").value;
	var rowDeleteId = document.getElementById("fy"+deviceNum+"postNo").value;
 
	if(	rowDeleteId!=""&&rowDeleteId!=null){
		rowDetailId = rowDetailId+rowDeleteId+",";
		document.getElementById("hidDetailId").value = rowDetailId;
 
		//删除子表信息
		var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
		var submitStr='JCDP_TABLE_NAME=bgp_project_human_reliefdetail&JCDP_TABLE_ID='+rowDeleteId+'&bsflag=1';
		syncRequest('Post',path,encodeURI(encodeURI(submitStr)));
		deleteChangeInfoNum2('postNo')
	}	

	var rowDevice = document.getElementById("fy"+deviceNum+"trflag");
	rowDevice.parentNode.removeChild(rowDevice);
	var rowFlag = document.getElementById("deleteRowFlag").value;
	rowFlag=rowFlag+deviceNum+",";
	document.getElementById("deleteRowFlag").value = rowFlag;

	//currTrNum-=1;
	currentCount-=1;

	//删除后重新排列序号
	deleteChangeInfoNum('postNo');

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
			num+=1;
		}
	}	 
}


</script>
</head>
<body style="overflow-y:auto">
<form id="CheckForm" action="" method="post" target="list" enctype="multipart/form-data">
<div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%">
<table width="96%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
    <tr>
    	<td class="inquire_item6">项目名称：</td>
      	<td class="inquire_form6">
		<input type="hidden" id="projectInfoNo" name="projectInfoNo" value="<%=applyInfo.getProjectInfoNo()==null?"":applyInfo.getProjectInfoNo()%>"/>
		<input type="text"  readonly="readonly" value="<%=applyInfo.getProjectName()==null?"":applyInfo.getProjectName()%>" id="projectName" name="projectName" class='input_width'></input>
		</td>
      	<td class="inquire_item6">申请单位：</td>
      	<td class="inquire_form6">
		<input type="hidden" value="<%=applyInfo.getApplyCompany()==null?"":applyInfo.getApplyCompany()%>" id="applyCompany" name="applyCompany"></input>
		<input type="text" value="<%=applyInfo.getApplicantOrgName()==null?"":applyInfo.getApplicantOrgName()%>" id="applicantOrgName" name="applicantOrgName" class='input_width' readonly="readonly"></input>
		</td>
		<td class="inquire_item6">申请单号：</td>
      	<td class="inquire_form6">
      	<input type="hidden" id="humanReliefNo" name="humanReliefNo" value="<%=applyInfo.getHumanReliefNo()==null?"":applyInfo.getHumanReliefNo() %>"/>
		<input type="text" style="color: gray;" value="<%=applyInfo.getApplyNo()==null?"申请提交后系统自动生成":applyInfo.getApplyNo()%>" id="applyNo"  name="applyNo" class='input_width' readonly="readonly"></input>
		</td>
    </tr>
    <tr>
      	<td class="inquire_item6">提交人：</td>
      	<td class="inquire_form6">
		<input type="hidden" value="<%=applyInfo.getApplicantId()==null?"":applyInfo.getApplicantId()%>" id="applicantId" name="applicantId"></input>
		<input type="text" value="<%=applyInfo.getApplicantName()==null?"":applyInfo.getApplicantName()%>" id="applicantName" name="applicantName" class='input_width' readonly="readonly"></input>
		</td>
      	<td class="inquire_item6">提交时间：</td>
      	<td class="inquire_form6">
		<input type="text" value="<%=applyInfo.getApplyDate()==null?"":applyInfo.getApplyDate()%>" id="applyDate" name="applyDate" class='input_width' readonly="readonly"/>
		&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;"
			onmouseover="calDateSelector(applyDate,tributton1);" />
		</td>
		<td class="inquire_item6">&nbsp;</td>
      	<td class="inquire_form6">&nbsp;</td>
    </tr>
    <tr>
    	<td class="inquire_item6">备注：</td>
      	<td class="inquire_form6" colspan="5">
      	<textarea id="notes" name="notes" onpropertychange="if(value.length>100) value=value.substr(0,100)" class='textarea'><%=applyInfo.getNotes()==null?"":applyInfo.getNotes()%></textarea>
		</td>
    </tr>
</table>
</div>  

 		
	<div ic="oper_div" align="center">
     	<span class="zj"><a href="#" onclick="addLine()"></a></span>
    </div>		
	<div style="width:100%;overflow-x:scroll;overflow-y:scroll;"> 		
	<table id="lineTable" width="1400" border="0" cellspacing="0" cellpadding="0"  style="margin-top:2px;" >
    	<tr>
    	    <td class="bt_info_odd" width="3%">序号</td>
            <td class="bt_info_even" width="6%">班组</td>
            <td class="bt_info_odd" width="6%">岗位</td>		
            <td class="bt_info_even" width="6%">需求人数</td>
            <td class="bt_info_odd" width="8%">计划进入时间</td>			
            <td class="bt_info_even" width="8%">计划离开时间</td> 
            <td class="bt_info_odd" width="6%">计划天数</td> 
            <td class="bt_info_even" width="6%">年龄</td>			
            <td class="bt_info_odd" width="6%">工作年限</td> 
            <td class="bt_info_even" width="6%">文化程度</td>             
            <td class="bt_info_odd" width="6%">备注</td>
			<td class="bt_info_even" width="3%">操作 <input type="hidden" id="equipmentSize" name="equipmentSize" value="<%=beanList.size()%>" />
				<input type="hidden" id="hidDetailId" name="hidDetailId" value="" />
				<input type="hidden" id="deleteRowFlag" name="deleteRowFlag" value="" /></td>
        </tr>
        
       <%
		for (int i = 0; i < beanList.size(); i++) {
			String className = "";
			if (i % 2 == 0) {
				className = "odd_";
			} else {
				className = "even_";
			}
			BgpProjectHumanReliefdetail applyDetailInfo = beanList.get(i);
			String ss="fy"+String.valueOf(i)+"deviceUnit";
	  %>
		<tr id="fy<%=i%>trflag">
		
		<td class="<%=className%>odd"><%=i+1 %><input type="hidden" name="fy<%=i%>postNo" id="fy<%=i%>postNo" value="<%=applyDetailInfo.getPostNo()==null?"":applyDetailInfo.getPostNo()%>"/><input type="hidden" name="fy<%=i%>bsflag" id="fy<%=i%>bsflag" value="0"/></td>
		<td class="<%=className%>even"><input type="hidden" id="fy<%=i%>applyTeam" name="fy<%=i%>applyTeam" value="<%=applyDetailInfo.getApplyTeam()==null?"":applyDetailInfo.getApplyTeam()%>" class="input_width"  readonly="readonly"/>
		<input type="text" id="fy<%=i%>applyTeamname" name="fy<%=i%>applyTeamname" value="<%=applyDetailInfo.getApplyTeamname()==null?"":applyDetailInfo.getApplyTeamname()%>" readonly="readonly" class="input_width" />
		</td>
		<td class="<%=className%>odd"><input type="hidden" id="fy<%=i%>post" name="fy<%=i%>post" value="<%=applyDetailInfo.getPost()==null?"":applyDetailInfo.getPost()%>" class="input_width" readonly="readonly" />
		<input type="text" id="fy<%=i%>postname" name="fy<%=i%>postname" value="<%=applyDetailInfo.getPostname()==null?"":applyDetailInfo.getPostname()%>" class="input_width" readonly="readonly" />
		</td>
		<td class="<%=className%>even"><input type="text" id="fy<%=i%>peopleNumber" name="fy<%=i%>peopleNumber" value="<%=applyDetailInfo.getPeopleNumber()==null?"":applyDetailInfo.getPeopleNumber()%>" class="input_width" /></td>
		
		<td class="<%=className%>odd"><input type="text" name="fy<%=i%>planStartDate" id="fy<%=i%>planStartDate"  readonly="readonly" value="<%=applyDetailInfo.getPlanStartDate()==null?"":applyDetailInfo.getPlanStartDate()%>" class="input_width" /></td>
		<td class="<%=className%>even"><input type="text" name="fy<%=i%>planEndDate" id="fy<%=i%>planEndDate"  readonly="readonly" value="<%=applyDetailInfo.getPlanEndDate()==null?"":applyDetailInfo.getPlanEndDate()%>" class="input_width" /></td>
		<td class="<%=className%>odd"><input type="text" id="fy<%=i%>spare1" name="fy<%=i%>spare1" value="<%=applyDetailInfo.getSpare1()==null?"":applyDetailInfo.getSpare1()%>" class="input_width"  readonly="readonly"/></td>
		
		<td class="<%=className%>even"><code:codeSelect name='<%=("fy"+String.valueOf(i)+"age")%>' option="hrAgeOps" addAll="true" selectedValue='<%=applyDetailInfo.getAge()==null?"":applyDetailInfo.getAge()%>' cssClass="select_width"/></td>
		<td class="<%=className%>odd"><code:codeSelect name='<%=("fy"+String.valueOf(i)+"workYears")%>' option="workYearOps" addAll="true" selectedValue='<%=applyDetailInfo.getWorkYears()==null?"":applyDetailInfo.getWorkYears()%>' cssClass="select_width"/></td>
		<td class="<%=className%>even"><code:codeSelect name='<%=("fy"+String.valueOf(i)+"culture")%>' option="hrDegreeOps" addAll="true" selectedValue='<%=applyDetailInfo.getCulture()==null?"":applyDetailInfo.getCulture()%>' cssClass="select_width"/></td>
			
		<td class="<%=className%>odd"><input type="text" maxlength="32" id="fy<%=i%>notes" name="fy<%=i%>notes" value="<%=applyDetailInfo.getNotes()==null?"":applyDetailInfo.getNotes()%>" class="input_width" /></td>
		<td class="<%=className%>even">
		<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor: hand;" onclick="deleteDeviceEdit('<%=i%>')" /></td>	
		
		</tr>	
	  <%
		}
	  %>
    </table>	
	</div>
	<% 
	   String buttonView = resultMsg.getValue("buttonView"); 
	   if("true".equals(buttonView)){
	%>
	
    <div id="oper_div">
        <span class="bc_btn"><a href="#" onclick="save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
    <%} %>
 </form>
</body>
</html>
