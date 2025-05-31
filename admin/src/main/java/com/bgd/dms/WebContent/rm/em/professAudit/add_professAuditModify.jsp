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
<%@ taglib uri="wf" prefix="wf"%>
<%@ taglib uri="auth" prefix="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getEmpId();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());

	//处理申请单信息
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	BgpProjectHumanProfess applyInfo = (BgpProjectHumanProfess) resultMsg
			.getMsgElement("applyInfo").toPojo(
					BgpProjectHumanProfess.class);
	System.out.println(resultMsg
			.getMsgElement("applyInfo").toMap());
	List<MsgElement> list = resultMsg.getMsgElements("detailInfo");
	List<BgpProjectHumanProfessPost> beanList=new ArrayList<BgpProjectHumanProfessPost>(0);
	if(list!=null){
		beanList = new ArrayList<BgpProjectHumanProfessPost>(list.size());	
		for (int i = 0; i < list.size(); i++) {
			beanList.add((BgpProjectHumanProfessPost) list.get(i).toPojo(
					BgpProjectHumanProfessPost.class));
		}
	}
	List<MsgElement> subList = resultMsg.getMsgElements("subDetailInfo");
	List<BgpProjectHumanProfessDeta> subBeanList=new ArrayList<BgpProjectHumanProfessDeta>(0);
	if(subList!=null){
		subBeanList = new ArrayList<BgpProjectHumanProfessDeta>(subList.size());	
		for (int i = 0; i < subList.size(); i++) {
			subBeanList.add((BgpProjectHumanProfessDeta) subList.get(i).toPojo(
					BgpProjectHumanProfessDeta.class));
		}
	}
	
	String degreeStr = resultMsg.getValue("degreeStr");
	
	String workYearStr = resultMsg.getValue("workYearStr");
	
	String ageStr = resultMsg.getValue("ageStr");
	
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
var currentECount=parseInt('<%=subBeanList.size()%>');
var deviceECount = parseInt('<%=subBeanList.size()%>');

//学历初始化
var codeStr = '<%=degreeStr%>';
//年龄初始化
var ageStr = '<%=ageStr%>';
//工作年限初始化
var workYearStr = '<%=workYearStr%>';

var optionStr=codeStr.split("@");
var ageOptionStr=ageStr.split("@");
var workOptionStr=workYearStr.split("@");

var cu_str = "";
function getCultureStr(culture){
	cu_str='<option value="">请选择</option>';
	for(var i=0;i<optionStr.length;i++){
		if(optionStr[i].split(",")[0] == culture){
			cu_str+='<option value="'+optionStr[i].split(",")[0]+'" selected="selected" >'+optionStr[i].split(",")[1]+'</option>';
		}else{
			cu_str+='<option value="'+optionStr[i].split(",")[0]+'" >'+optionStr[i].split(",")[1]+'</option>';
		}
		
	}
	
}
var ag_str = "";
function getAgeStr(age){
	ag_str='<option value="">请选择</option>';
	for(var i=0;i<ageOptionStr.length;i++){
		if(ageOptionStr[i].split(",")[0] == age){
			ag_str+='<option value="'+ageOptionStr[i].split(",")[0]+'" selected="selected" >'+ageOptionStr[i].split(",")[1]+'</option>';
		}else{
			ag_str+='<option value="'+ageOptionStr[i].split(",")[0]+'" >'+ageOptionStr[i].split(",")[1]+'</option>';
		}
		
	}
	
}
var wo_str = "";
function getWorkStr(work){
	wo_str='<option value="">请选择</option>';
	for(var i=0;i<workOptionStr.length;i++){
		if(optionStr[i].split(",")[0] == work){
			wo_str+='<option value="'+workOptionStr[i].split(",")[0]+'" selected="selected" >'+workOptionStr[i].split(",")[1]+'</option>';
		}else{
			wo_str+='<option value="'+workOptionStr[i].split(",")[0]+'" >'+workOptionStr[i].split(",")[1]+'</option>';
		}
		
	}
	
}

function pass(){
	document.getElementById("isPass").value="pass";
	save();
}
function notpass(){
	document.getElementById("checkedSchemaId").value= getCheckedValues("selectSchemaName")
	var form = document.getElementById("CheckForm");
	if(isFirst=="true"){
		document.getElementById("isPass").value="back1";
	}else{
		document.getElementById("isPass").value="back";
	}
	form.action = "<%=contextPath%>/rm/em/toSaveProfessionAudit.srq";
	form.submit();
	setTimeout("closeHere()","2000");
}

function save(){
	if(checkForm()){
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/rm/em/toSaveProfessionAudit.srq";
		form.submit();
		 setTimeout("closeHere()","2000");
	}
}

 
function closeHere(){
	window.close();
}
function checkForm(){
	
//	if(currentECount == 0){
//		alert("请调配一条记录");
//		return false;
//	}

	var rowFlag = document.getElementById("deleteERowFlag").value;	
	var notCheck=rowFlag.split(",");
	for(var i=0;i<deviceECount;i++){
		var isCheck=true;
		for(var j=0;notCheck!=""&&j<notCheck.length;j++){
			if(notCheck[j]==i) isCheck =false;
		}
		if(isCheck){
			if(!notNullForCheck("em"+i+"deployOrg","调配单位")) return false;
			if(!notNullForCheck("em"+i+"peopleNumber","调配人数")) return false;
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

function addDeploy(deviceNum) {
	
	var tr = document.getElementById("equipmentTableInfo").insertRow();
	tr.align ="center";
	
  	if(currentECount % 2 == 1){  
  		tr.className = "odd";
	}else{ 
		tr.className = "even";
	}	
	tr.id = "em"+deviceECount+"trflag";
	
	var postNo = document.getElementById("fy"+deviceNum+"postNo").value;
	var applyTeam = document.getElementById("fy"+deviceNum+"applyTeam").value;
	var applyTeamname = document.getElementById("fy"+deviceNum+"applyTeamname").value;
	var post = document.getElementById("fy"+deviceNum+"post").value;
	var postname = document.getElementById("fy"+deviceNum+"postname").value;
	var age = document.getElementById("fy"+deviceNum+"age").value;
	var workYears = document.getElementById("fy"+deviceNum+"workYears").value;
	var culture = document.getElementById("fy"+deviceNum+"culture").value;
	var planStartDate = document.getElementById("fy"+deviceNum+"planStartDate").value;
	var planEndDate = document.getElementById("fy"+deviceNum+"planEndDate").value;
	
	var startTime = "em"+deviceECount+"planStartDate";
	var endTime = "em"+deviceECount+"planEndDate";
	
	 //需求子表id,为空
	tr.insertCell().innerHTML = currentECount+1+'<input type="hidden" id="em'+deviceECount+'postDetailNo" name="em'+deviceECount+'postDetailNo" value=""/>';
	tr.insertCell().innerHTML = '<input type="hidden" id="em'+deviceECount+'postNo" name="em'+deviceECount+'postNo" value="'+postNo+'"/>'+'<input type="hidden" readonly="readonly" maxlength="32" id="em'+deviceECount+'applyTeam" name="em'+deviceECount+'applyTeam" value="'+applyTeam+'" class="input_width" />'+'<input type="text" readonly="readonly" maxlength="32" id="em'+deviceECount+'applyTeamname" name="em'+deviceECount+'applyTeamname" value="'+applyTeamname+'" class="input_width" />';
	tr.insertCell().innerHTML = '<input type="hidden" readonly="readonly" maxlength="32" id="em'+deviceECount+'post" name="em'+deviceECount+'post" value="'+post+'" class="input_width" />'+'<input type="text" readonly="readonly" maxlength="32" id="em'+deviceECount+'postname" name="em'+deviceECount+'postname" value="'+postname+'" class="input_width" />';

	tr.insertCell().innerHTML = '<input type="hidden" readonly="readonly" maxlength="32" id="em'+deviceECount+'deployOrg" name="em'+deviceECount+'deployOrg" value="" class="input_width" />'+'<input type="text" readonly="readonly" maxlength="32" id="em'+deviceECount+'deployOrgName" name="em'+deviceECount+'deployOrgName" value="" class="input_width" />'+'<img src="'+'<%=contextPath%>'+'/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectDeployOrg('+deviceECount+')"  />';
	tr.insertCell().innerHTML = '<input type="text" id="em'+deviceECount+'peopleNumber" name="em'+deviceECount+'peopleNumber" class="input_width" onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);" value="" class="input_width"/>';
	
	getAgeStr(age);
	tr.insertCell().innerHTML = '<select id="em'+deviceECount+'age" name="em'+deviceECount+'age" class="select_width">'+ag_str+'</select>';
	getWorkStr(workYears);
	tr.insertCell().innerHTML = '<select id="em'+deviceECount+'workYears" name="em'+deviceECount+'workYears" class="select_width">'+wo_str+'</select>';
	getCultureStr(culture);
	tr.insertCell().innerHTML = '<select id="em'+deviceECount+'culture" name="em'+deviceECount+'culture" class="select_width">'+cu_str+'</select>';
	
	tr.insertCell().innerHTML = '<input type="text" readonly="readonly" id="em'+deviceECount+'planStartDate" name="em'+deviceECount+'planStartDate" value="'+planStartDate+'" class="input_width"/>';
	tr.insertCell().innerHTML = '<input type="text" readonly="readonly" id="em'+deviceECount+'planEndDate" name="em'+deviceECount+'planEndDate" value="'+planEndDate+'" class="input_width"/>';
	tr.insertCell().innerHTML = '<input type="text" id="em'+deviceECount+'notes" name="em'+deviceECount+'notes"  value="" class="input_width" />';
	var delRow = "em"+deviceECount;
	tr.insertCell().innerHTML =  '<span class="sc"><a href="#" onclick="deleteDevice(\'' + delRow + '\')"></a></span>';
	document.getElementById("equipmentESize").value=deviceECount+1;
	deviceECount+=1;
	currentECount+=1;
}

//选择调配单位
function selectDeployOrg(deviceECount){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/common/selectOrg.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
        document.getElementById("em"+deviceECount+"deployOrg").value = teamInfo.fkValue;
        document.getElementById("em"+deviceECount+"deployOrgName").value = teamInfo.value;
    }
}

function deleteDevice(deviceNum){

	var rowDetailId = document.getElementById("hidEDetailId").value;
	var rowDeleteId = document.getElementById(deviceNum+"postDetailNo").value;

	if(	rowDeleteId!=""&&rowDeleteId!=null){
		rowDetailId = rowDetailId+rowDeleteId+",";
		document.getElementById("hidEDetailId").value = rowDetailId;
	}	

	var rowDevice = document.getElementById(deviceNum+"trflag");
	rowDevice.parentNode.removeChild(rowDevice);
	var rowFlag = document.getElementById("deleteERowFlag").value;
	rowFlag=rowFlag+deviceNum.substr(2)+",";
	document.getElementById("deleteERowFlag").value = rowFlag;

	currentECount-=1;
	
	//删除后重新排列序号
	deleteChangeInfoNum('em','postDetailNo');

}

function deleteChangeInfoNum(flag,warehouseDetailId){

	var rowFlag = document.getElementById("deleteERowFlag").value;
	var notCheck=rowFlag.split(",");
	var num=1;
	for(var i=0;i<deviceECount;i++){
		var isCheck=true;
		for(var j=0;notCheck!=""&&j<notCheck.length;j++){
			if(notCheck[j]==i&&notCheck[j]!="") isCheck =false;
		}
		if(isCheck){
		  	if(num % 2 == 1){  
		  		document.getElementById("em"+i+"trflag").className = "even";
			}else{ 
				document.getElementById("em"+i+"trflag").className = "odd";
			}
			document.getElementById("em"+i+warehouseDetailId).parentNode.innerHTML=num+document.getElementById("em"+i+warehouseDetailId).outerHTML;
			num+=1;
		}
	}
}
</script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
</head>
<body style="overflow-y:auto">
<iframe id="hidderIframe" name="hidderIframe" style="display: none"></iframe>

<form id="CheckForm" action="" method="post"  target="hidderIframe"  enctype="multipart/form-data">
<div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
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
      	<td class="inquire_item6">&nbsp;</td>
      	<td class="inquire_form6">&nbsp;</td>
    </tr>
    <tr>
    	<td class="inquire_item6">申请单号：</td>
      	<td class="inquire_form6">
      	<input type="hidden" id="professNo" name="professNo" value="<%=applyInfo.getProfessNo()==null?"":applyInfo.getProfessNo() %>"/>
		<input type="text" style="color: gray;" value="<%=applyInfo.getApplyNo()==null?"申请提交后系统自动生成":applyInfo.getApplyNo()%>" id="applyNo"  name="applyNo" class='input_width' readonly="readonly"></input>
		</td>
      	<td class="inquire_item6">申请人：</td>
      	<td class="inquire_form6">
		<input type="hidden" value="<%=applyInfo.getApplicantId()==null?"":applyInfo.getApplicantId()%>" id="applicantId" name="applicantId"></input>
		<input type="text" value="<%=applyInfo.getApplicantName()==null?"":applyInfo.getApplicantName()%>" id="applicantName" name="applicantName" class='input_width' readonly="readonly"></input>
		</td>
      	<td class="inquire_item6">申请时间：</td>
      	<td class="inquire_form6">
		<input type="text" value="<%=applyInfo.getApplyDate()==null?"":applyInfo.getApplyDate()%>" id="applyDate" name="applyDate" class='input_width' readonly="readonly"/>
		&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;"
			onmouseover="calDateSelector(applyDate,tributton1);" />
		</td>
    </tr>
</table>
</div>  

	<div  style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%;">
 	<wf:getProcessInfo/>
 	<input type="hidden" id="checkedSchemaId" value=""/>
   </div>
	<div> 			
	<table id="lineTable" width="100%" border="0" cellspacing="0" cellpadding="0"  style="margin-top:2px;" >
    	<tr>
    	    <td class="bt_info_odd" width="3%">序号</td>
            <td class="bt_info_even" width="6%">班组</td>
            <td class="bt_info_odd" width="6%">岗位</td>		
            <td class="bt_info_even" width="6%">计划人数</td>
            <td class="bt_info_odd" width="8%">计划进入时间</td>			
            <td class="bt_info_even" width="8%">计划离开时间</td> 
            <td class="bt_info_odd" width="8%">年龄</td>			
            <td class="bt_info_even" width="8%">工作年限</td> 
            <td class="bt_info_odd" width="8%">文化程度</td>             
            <td class="bt_info_even" width="6%">自有人数</td>
            <td class="bt_info_odd" width="6%">需调配人数</td>
            <td class="bt_info_even" width="3%">操作</td>
        </tr>
        
       <%
		for (int i = 0; i < beanList.size(); i++) {
			String className = "";
			if (i % 2 == 0) {
				className = "odd_";
			} else {
				className = "even_";
			}
			BgpProjectHumanProfessPost applyDetailInfo = beanList.get(i);

	  %>
		<tr id="fy<%=i%>trflag">
		
		<td class="<%=className%>odd"><%=i+1 %><input type="hidden" name="fy<%=i%>postNo" id="fy<%=i%>postNo" value="<%=applyDetailInfo.getPostNo()==null?"":applyDetailInfo.getPostNo()%>"/></td>
		<td class="<%=className%>even"><input type="hidden" id="fy<%=i%>applyTeam" name="fy<%=i%>applyTeam" value="<%=applyDetailInfo.getApplyTeam()==null?"":applyDetailInfo.getApplyTeam()%>" class="input_width" readonly="readonly"/>
		<input type="text" id="fy<%=i%>applyTeamname" name="fy<%=i%>applyTeamname" value="<%=applyDetailInfo.getApplyTeamname()==null?"":applyDetailInfo.getApplyTeamname()%>" class="input_width" readonly="readonly" />
		</td>
		<td class="<%=className%>odd"><input type="hidden" id="fy<%=i%>post" name="fy<%=i%>post" value="<%=applyDetailInfo.getPost()==null?"":applyDetailInfo.getPost()%>" class="input_width" readonly="readonly"/>
		<input type="text" id="fy<%=i%>postname" name="fy<%=i%>postname" value="<%=applyDetailInfo.getPostname()==null?"":applyDetailInfo.getPostname()%>" class="input_width" readonly="readonly" />
		</td>
		<td class="<%=className%>even"><input type="text" id="fy<%=i%>peopleNum" name="fy<%=i%>peopleNum" value="<%=applyDetailInfo.getPeopleNum()==null?"":applyDetailInfo.getPeopleNum()%>" class="input_width" readonly="readonly" /></td>		
		<td class="<%=className%>odd"><input type="text" name="fy<%=i%>planStartDate" id="fy<%=i%>planStartDate"  readonly="readonly" value="<%=applyDetailInfo.getPlanStartDate()==null?"":applyDetailInfo.getPlanStartDate()%>"  class="input_width"/></td>
		<td class="<%=className%>even"><input type="text" name="fy<%=i%>planEndDate" id="fy<%=i%>planEndDate"  readonly="readonly" value="<%=applyDetailInfo.getPlanEndDate()==null?"":applyDetailInfo.getPlanEndDate()%>"  class="input_width"/></td>
		
		<td class="<%=className%>odd"><code:codeSelect name='<%=("fy"+String.valueOf(i)+"age")%>' option="hrAgeOps" addAll="true" selectedValue='<%=applyDetailInfo.getAge()==null?"":applyDetailInfo.getAge()%>' cssClass="select_width"/></td>
		<td class="<%=className%>even"><code:codeSelect name='<%=("fy"+String.valueOf(i)+"workYears")%>' option="workYearOps" addAll="true" selectedValue='<%=applyDetailInfo.getWorkYears()==null?"":applyDetailInfo.getWorkYears()%>'  cssClass="select_width"/></td>
		<td class="<%=className%>odd"><code:codeSelect name='<%=("fy"+String.valueOf(i)+"culture")%>' option="hrDegreeOps" addAll="true" selectedValue='<%=applyDetailInfo.getCulture()==null?"":applyDetailInfo.getCulture()%>'  cssClass="select_width"/></td>
					
		<td class="<%=className%>even"><input type="text" maxlength="32" id="fy<%=i%>ownNum" name="fy<%=i%>ownNum" onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);" value="<%=applyDetailInfo.getOwnNum()==null?"":applyDetailInfo.getOwnNum()%>" class="input_width" readonly="readonly" /></td>
		<td class="<%=className%>odd"><input type="text" maxlength="32" id="fy<%=i%>deployNum" name="fy<%=i%>deployNum" onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);" value="<%=applyDetailInfo.getDeployNum()==null?"":applyDetailInfo.getDeployNum()%>" class="input_width" readonly="readonly" /></td>
		<td class="<%=className%>even" ><input name="button" type="button" onclick="addDeploy('<%=i%>')" value="调配" /></td>	
		</tr>	
	  <%
		}
	  %>
    </table>	
	</div>
	
	<div> 			
	<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:2px;" id="equipmentTableInfo" >
    	<tr class="bt_info">
    	    <td width="3%">序号</td>
            <td width="6%">班组</td>
            <td width="6%">岗位</td>		
            <td width="8%">调配单位</td>
            <td width="6%">调配人数</td>			
            <td width="8%">年龄</td>			
            <td width="8%">工作年限</td> 
            <td width="8%">文化程度</td> 
            <td width="8%">预计进入项目时间</td> 
            <td width="8%">预计离开项目时间</td> 
            <td width="6%">备注</td> 
            <td width="3%">操作<input type="hidden" id="equipmentESize" name="equipmentESize" value="<%=subBeanList.size()%>" />
			<input type="hidden" id="hidEDetailId" name="hidEDetailId" value=""/>
			<input type="hidden" id="deleteERowFlag" name="deleteERowFlag" value="" /></td>
        </tr>
        
        <%
		for (int i = 0; i < subBeanList.size(); i++) {
			String className = "";
			if (i % 2 == 1) {
				className = "odd";
			} else {
				className = "even";
			}
			BgpProjectHumanProfessDeta applyDetailInfo = subBeanList.get(i);

		%>	
		<tr class="<%=className%>" id="em<%=i%>trflag">
		
		<td><%=i+1 %><input type="hidden" name="em<%=i%>postDetailNo" id="em<%=i%>postDetailNo" value="<%=applyDetailInfo.getPostDetailNo()==null?"":applyDetailInfo.getPostDetailNo()%>"/>
		</td>
		<td><input type="hidden" name="em<%=i%>postNo" id="em<%=i%>postNo" value="<%=applyDetailInfo.getPostNo()==null?"":applyDetailInfo.getPostNo()%>"/> 
		<input type="hidden" id="em<%=i%>applyTeam" name="em<%=i%>applyTeam" value="<%=applyDetailInfo.getApplyTeam()==null?"":applyDetailInfo.getApplyTeam()%>" class="input_width" readonly="readonly"/>
		<input type="text" id="em<%=i%>applyTeamname" name="em<%=i%>applyTeamname" value="<%=applyDetailInfo.getApplyTeamname()==null?"":applyDetailInfo.getApplyTeamname()%>"  readonly="readonly"  class="input_width"  onfocus="this.class='input_width_on'" onblur="this.class='input_width'"/>
		</td>
		<td><input type="hidden" id="em<%=i%>post" name="em<%=i%>post" value="<%=applyDetailInfo.getPost()==null?"":applyDetailInfo.getPost()%>" class="input_width" readonly="readonly"/>
		<input type="text" id="em<%=i%>postname" name="em<%=i%>postname" value="<%=applyDetailInfo.getPostname()==null?"":applyDetailInfo.getPostname()%>" readonly="readonly"  class="input_width"  />
		</td>
		<td><input type="hidden" id="em<%=i%>deployOrg" name="em<%=i%>deployOrg" value="<%=applyDetailInfo.getDeployOrg()==null?"":applyDetailInfo.getDeployOrg()%>" readonly="readonly"  class="input_width"  />
		<input type="text" maxlength="32" id="em<%=i%>deployOrgName" name="em<%=i%>deployOrgName" value="<%=applyDetailInfo.getDeployOrgName()==null?"":applyDetailInfo.getDeployOrgName()%>"   readonly="readonly"   class="input_width"  /></td>
		<td><input type="text" id="em<%=i%>peopleNumber" name="em<%=i%>peopleNumber" value="<%=applyDetailInfo.getPeopleNumber()==null?"":applyDetailInfo.getPeopleNumber()%>" readonly="readonly"  onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);"  class="input_width"  /></td>
		<td><code:codeSelect name='<%=("em"+String.valueOf(i)+"age")%>' option="hrAgeOps" addAll="true" selectedValue='<%=applyDetailInfo.getAge()==null?"":applyDetailInfo.getAge()%>' cssClass="select_width"/></td>
		<td><code:codeSelect name='<%=("em"+String.valueOf(i)+"workYears")%>' option="workYearOps" addAll="true" selectedValue='<%=applyDetailInfo.getWorkYears()==null?"":applyDetailInfo.getWorkYears()%>' cssClass="select_width"/></td>
		<td><code:codeSelect name='<%=("em"+String.valueOf(i)+"culture")%>' option="hrDegreeOps" addAll="true" selectedValue='<%=applyDetailInfo.getCulture()==null?"":applyDetailInfo.getCulture()%>' cssClass="select_width"/></td>			
		<td><input type="text" name="em<%=i%>planStartDate" id="em<%=i%>planStartDate"  readonly="readonly" value="<%=applyDetailInfo.getPlanStartDate()==null?"":applyDetailInfo.getPlanStartDate()%>"   class="input_width"  /></td>
		<td><input type="text" name="em<%=i%>planEndDate" id="em<%=i%>planEndDate"  readonly="readonly" value="<%=applyDetailInfo.getPlanEndDate()==null?"":applyDetailInfo.getPlanEndDate()%>"   class="input_width"  /></td>
		<td><input type="text" maxlength="32" id="em<%=i%>notes" name="em<%=i%>notes"  value="<%=applyDetailInfo.getNotes()==null?"":applyDetailInfo.getNotes()%>" class="input_width"  /></td>
		<td><span class="sc"><a href="#" onclick="deleteDevice('em<%=i%>')"></a></span></td>	
		</tr>	
		<%
		}
	%>
      </table>
     </div>
    <div id="oper_div">
        <span class="pass_btn"><a href="#" onclick="pass()"></a></span>
        <span class="nopass_btn"><a href="#" onclick="notpass()"></a></span>
        <span class="gb_btn"><a href="#" onclick="window.close()"></a></span>
    </div>
 </form>
</body>
</html>
