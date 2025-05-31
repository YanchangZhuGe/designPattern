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

	String orgSubjectionId = user.getOrgSubjectionId();
 	String subOrgIDofAffordOrg = user.getSubOrgIDofAffordOrg();
	//处理申请单信息
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
    String update = resultMsg.getValue("update");
    String project_type = resultMsg.getValue("project_type");
    
	String buttonViewFile = resultMsg.getValue("buttonView"); 
	BgpProjectHumanProfess applyInfo = (BgpProjectHumanProfess) resultMsg
			.getMsgElement("applyInfo").toPojo(
					BgpProjectHumanProfess.class);
	
	List<MsgElement> list = resultMsg.getMsgElements("detailInfo");
	List<BgpHumanPreparePostDetail> beanList=new ArrayList<BgpHumanPreparePostDetail>(0);
	if(list!=null){
		beanList = new ArrayList<BgpHumanPreparePostDetail>(list.size());	
		for (int i = 0; i < list.size(); i++) {
			BgpHumanPreparePostDetail postDetail = (BgpHumanPreparePostDetail) list.get(i).toPojo(
					BgpHumanPreparePostDetail.class);
			beanList.add(postDetail);			
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
	
	
	//处理调配单信息
	BgpHumanPrepare prepareMap = (BgpHumanPrepare) resultMsg
			.getMsgElement("prepareMap").toPojo(
					BgpHumanPrepare.class);

    //调配人员信息
	List<MsgElement> humanMsg = resultMsg.getMsgElements("humanInfoList");
	List<BgpHumanPrepareHumanDetail> humanList=new ArrayList<BgpHumanPrepareHumanDetail>(0);
	if(humanMsg!=null){
		humanList = new ArrayList<BgpHumanPrepareHumanDetail>(humanMsg.size());	
		for (int i = 0; i < humanMsg.size(); i++) {
			humanList.add((BgpHumanPrepareHumanDetail) humanMsg.get(i).toPojo(
					BgpHumanPrepareHumanDetail.class));
		}
	}
	
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

var currentCount=parseInt('<%=humanList.size()%>');
var deviceCount = parseInt('<%=humanList.size()%>');

function save(){
	if(checkForm()){
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/rm/em/toSaveProfessionPrepare.srq";
		form.submit();
		newClose(); 
	}
}

function checkForm(){
	if(currentCount == 0){
		alert("请调配一条记录");
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
	tr.insertCell().innerHTML = '<input type="text" id="em'+deviceECount+'peopleNumber" name="em'+deviceECount+'peopleNumber" class="input_width" onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);" value=""/>';
	
	getAgeStr(age);
	tr.insertCell().innerHTML = '<select id="em'+deviceECount+'age" name="em'+deviceECount+'age" >'+ag_str+'</select>';
	getWorkStr(workYears);
	tr.insertCell().innerHTML = '<select id="em'+deviceECount+'workYears" name="em'+deviceECount+'workYears" >'+wo_str+'</select>';
	getCultureStr(culture);
	tr.insertCell().innerHTML = '<select id="em'+deviceECount+'culture" name="em'+deviceECount+'culture" >'+cu_str+'</select>';
	
	tr.insertCell().innerHTML = '<input type="text" readonly="readonly" id="em'+deviceECount+'planStartDate" name="em'+deviceECount+'planStartDate" value="'+planStartDate+'"/>';
	tr.insertCell().innerHTML = '<input type="text" readonly="readonly" id="em'+deviceECount+'planEndDate" name="em'+deviceECount+'planEndDate" value="'+planEndDate+'" />';
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

	var rowDetailId = document.getElementById("hidDetailId").value;
	var employeeIds = document.getElementById("employeeIds").value;
	var qufens = document.getElementById("qufens").value;
	
	
	var rowDeleteId = document.getElementById("hu"+deviceNum+"humanDetailNo").value;
	var qufen = document.getElementById("hu"+deviceNum+"qufen").value; 
	var rowDeleteEId = document.getElementById("hu"+deviceNum+"employeeId").value;
	
	if(	rowDeleteId!=""&&rowDeleteId!=null){
		rowDetailId = rowDetailId+rowDeleteId+",";
		employeeIds = employeeIds+rowDeleteEId+",";
		qufens = qufens+qufen+",";
		
		document.getElementById("hidDetailId").value = rowDetailId;
		document.getElementById("employeeIds").value = employeeIds;
		document.getElementById("qufens").value = qufens;
	}	

	var rowDevice = document.getElementById("hu"+deviceNum+"trflag");
	rowDevice.parentNode.removeChild(rowDevice);
	var rowFlag = document.getElementById("deleteRowFlag").value;
	rowFlag=rowFlag+deviceNum+",";
	document.getElementById("deleteRowFlag").value = rowFlag;

	currentCount-=1;
	
	//删除后重新排列序号
	deleteChangeInfoNum('hu','humanDetailNo');

}

function deleteChangeInfoNum(flag,warehouseDetailId){

	var rowFlag = document.getElementById("deleteRowFlag").value;
	var notCheck=rowFlag.split(",");
	var num=1;
	for(var i=0;i<deviceCount;i++){
		var isCheck=true;
		for(var j=0;notCheck!=""&&j<notCheck.length;j++){
			if(notCheck[j]==i&&notCheck[j]!="") isCheck =false;
		}
		if(isCheck){
		  	if(num % 2 == 1){  
		  		document.getElementById("hu"+i+"trflag").className = "even";
			}else{ 
				document.getElementById("hu"+i+"trflag").className = "odd";
			}
			document.getElementById("hu"+i+warehouseDetailId).parentNode.innerHTML=num+document.getElementById("hu"+i+warehouseDetailId).outerHTML;
			num+=1;
		}
	}
}


function getMessage(arg){
	//  alert(arg);
	var rowid = document.getElementsByName("showMessage")[0].value=arg[0];
	var result = document.getElementsByName("showMessage2")[0].value=arg[1];
 
	if(result!="" && result!=undefined ){
				
		var checkStr = result.split(",");	
		var reCheck = "";	
		var newCheck = "";
		if(deviceCount>0){
			var checkNum = deviceCount;
			//人员列表		
			var rowFlag = document.getElementById("deleteRowFlag").value;
			var notCheck = rowFlag.split(",");
			var isRe=true;
			for(var m=0;m<checkNum;m++){
				var isCheck=true;
				for(var j=0;notCheck!=""&&j<notCheck.length;j++){
					if(notCheck[j]==m&&notCheck[j]!="") isCheck =false;
				}
				if(isCheck){
					var id = document.getElementById("hu"+m+"employeeId").value;
					var name = document.getElementById("hu"+m+"employeeName").value;
					for(var i=0;i<checkStr.length; i++){
						var emplTemp = checkStr[i].split("-");	
						if(id == emplTemp[0]){
							newCheck += i + ",";
							reCheck += emplTemp[1] +",";
							break;
						}						
					}	
				}
			}
			for(var i=0;i<checkStr.length; i++){
				newCheck = "," + newCheck;
				if(newCheck.indexOf(","+i+",") == -1){
					var emplTemp = checkStr[i].split("-");	
					var applyTeam = "";
					var applyTeamname = "";
					var post = "";
					var postname = "";
					var planStartDate = "";
					var planEndDate = "";
					
					applyTeam = document.getElementById(rowid+"applyTeam").value;
					applyTeamname = document.getElementById(rowid+"applyTeamname").value;
					post = document.getElementById(rowid+"post").value;
					postname = document.getElementById(rowid+"postname").value;
					planStartDate = document.getElementById(rowid+"planStartDate").value;
					planEndDate = document.getElementById(rowid+"planEndDate").value;
					
					addEmployee(applyTeam,applyTeamname,post,postname,emplTemp[0],emplTemp[1],planStartDate,planEndDate,emplTemp[2]);	
				}					
			}			
		}else{
			for(var i=0;i<checkStr.length; i++){
				var emplTemp = checkStr[i].split("-");	
				var applyTeam = "";
				var applyTeamname = "";
				var post = "";
				var postname = "";
				var planStartDate = "";
				var planEndDate = "";
				
				applyTeam = document.getElementById(rowid+"applyTeam").value;
				applyTeamname = document.getElementById(rowid+"applyTeamname").value;
				post = document.getElementById(rowid+"post").value;
				postname = document.getElementById(rowid+"postname").value;
				planStartDate = document.getElementById(rowid+"planStartDate").value;
				planEndDate = document.getElementById(rowid+"planEndDate").value;
				
				addEmployee(applyTeam,applyTeamname,post,postname,emplTemp[0],emplTemp[1],planStartDate,planEndDate,emplTemp[2]);	
			}
		}		
				
		if(reCheck != ""){
			reCheck = reCheck.substring(0,reCheck.length-1);
			alert(reCheck+"已调配");
		}
		
	}
	
}



function openSearch(rowid){
 
	popWindow('<%=contextPath%>/rm/em/professPrepare/searchOrgHumanList.jsp?project_type=<%=project_type%>&rowid='+rowid,'880:725'); 	
}


//加一行人员需求
function addEmployee(applyTeam,applyTeamname,post,postname,employid,employname,planStartDate,planEndDate,qufen){

	var tr = document.getElementById("employeeTable").insertRow();
	tr.align ="center";
	
  	if(currentCount % 2 == 1){  
  		tr.className = "odd";
	}else{ 
		tr.className = "even";
	}	
	tr.id = "hu"+deviceCount+"trflag";
	
	var startTime = "hu"+deviceCount+"planStartDate";
	var endTime = "hu"+deviceCount+"planEndDate";
		
	tr.insertCell().innerHTML = currentCount+1+'<input type="hidden" id="hu'+deviceCount+'humanDetailNo" name="hu'+deviceCount+'humanDetailNo"  value=""/>';
	

	tr.insertCell().innerHTML ='<input type="hidden" id="hu'+deviceCount+'psw" name="hu'+deviceCount+'psw"  value="a"/>'+ '<input type="hidden" id="hu'+deviceCount+'qufen" name="hu'+deviceCount+'qufen"  value="'+qufen+'"/>'+'<input type="hidden" readonly="readonly" maxlength="32" id="hu'+deviceCount+'team" name="hu'+deviceCount+'team" value="'+applyTeam+'" class="input_width" />'+'<input type="text" readonly="readonly" maxlength="32" id="hu'+deviceCount+'teamname" name="hu'+deviceCount+'teamname" value="'+applyTeamname+'" class="input_width" />';
	tr.insertCell().innerHTML = '<input type="hidden" readonly="readonly" maxlength="32" id="hu'+deviceCount+'workPost" name="hu'+deviceCount+'workPost" value="'+post+'" class="input_width" />'+'<input type="text" readonly="readonly" maxlength="32" id="hu'+deviceCount+'workPostName" name="hu'+deviceCount+'workPostName" value="'+postname+'" class="input_width" />';


	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="hu'+deviceCount+'employeeName" name="hu'+deviceCount+'employeeName"  value="'+employname+'" class="input_width" readonly="readonly"/>'+'<input type="hidden" id="hu'+deviceCount+'employeeId" name="hu'+deviceCount+'employeeId"  value="'+employid+'"/>';
	tr.insertCell().innerHTML = '<input type="text" readonly="readonly" id="hu'+deviceCount+'planStartDate" name="hu'+deviceCount+'planStartDate" value="'+planStartDate+'"  class="input_width" />';
	tr.insertCell().innerHTML = '<input type="text" readonly="readonly" id="hu'+deviceCount+'planEndDate" name="hu'+deviceCount+'planEndDate" value="'+planEndDate+'"  class="input_width" />';
	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="days'+deviceCount+'" name="days'+deviceCount+'"  value="" class="input_width" readonly="readonly"/>';

	calDays(deviceCount);
	tr.insertCell().innerHTML = '<input type="hidden" name="orderDrill" value="' + deviceCount + '"/><img src="'+'<%=contextPath%>'+'/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteDevice(' +deviceCount + ')"/>';

	document.getElementById("equipmentSize").value=deviceCount+1;

	deviceCount+=1;
	currentCount+=1;
}

function calDays(i){
	var startTime = document.getElementById("hu"+i+"planStartDate").value;
	var returnTime = document.getElementById("hu"+i+"planEndDate").value;
	if(startTime!=null&&startTime!=''&&returnTime!=null&&returnTime!=''){
		var days=(new Date(returnTime.replace(/-/g,'/'))-new Date(startTime.replace(/-/g,'/')))/3600/24/1000;
		document.getElementById("days"+i).value = days+1;
	}
}

</script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
</head>
<body style="overflow-y:auto">
<form id="CheckForm" action="" method="post" target="list" enctype="multipart/form-data">
<div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%">  		
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
    <tr>
    	<td class="inquire_item6">项目名称：</td>
      	<td class="inquire_form6">
	    <input type="hidden" name="showMessage" value=""/>
		<input type="hidden" name="showMessage2" value=""/>
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
    </tr>
</table>
</div>  
<br/>
<div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
    <tr>
    	<td class="inquire_item6">调配单号：</td>
      	<td class="inquire_form6">
		<input type="hidden" id="preprepareOrgId" name="preprepareOrgId"
					value="<%=prepareMap.getPrepareOrgId()==null?(applyInfo.getApplyCompany()==null?"":applyInfo.getApplyCompany()):prepareMap.getPrepareOrgId()%>" />
					<input type="hidden" id="prefunctionType" unselectable="on"
					name="prefunctionType"
					value="<%=prepareMap.getFunctionType()==null?"":prepareMap.getFunctionType()%>" />
					<input type="hidden" id="preprepareNo" unselectable="on"
					name="preprepareNo"
					value="<%=prepareMap.getPrepareNo()==null?"":prepareMap.getPrepareNo()%>" />
					<input type="text"
					value="<%=prepareMap.getPrepareId()==null?"申请提交后系统自动生成":prepareMap.getPrepareId()%>"
					id="prePrepareId" name="prePrepareId" class='input_width'
					readonly="readonly"/>
		</td>
      	<td class="inquire_item6">经办人：</td>
      	<td class="inquire_form6">
		<input type="hidden"
					value="<%=prepareMap.getApplicantId()==null?"":prepareMap.getApplicantId()%>"
					id="preapplicantId" name="preapplicantId"></input> <input
					type="text"
					value="<%=prepareMap.getApplicantName()==null?"":prepareMap.getApplicantName()%>"
					id="preapplicantName" name="preapplicantName" class='input_width'
					readonly="readonly"></input> <img
					src="<%=contextPath%>/images/magnifier.gif" width="16" height="16"
					style="cursor: hand;" onclick="selectPerson()" />
		</td>
      	<td class="inquire_item6">调配日期:</td>
      	<td class="inquire_form6"><input type="text"
					value="<%=prepareMap.getDeployDate()==null?"":prepareMap.getDeployDate()%>"
					id="predeployDate" name="predeployDate" class='input_width'
					readonly="readonly"></input>&nbsp;&nbsp;<img
					src="<%=contextPath%>/images/calendar.gif" id="tributton1"
					width="16" height="16" style="cursor: hand;"
					onmouseover="timeSelector(predeployDate,tributton1);" /></td>
    </tr>
    <tr>
    	<td class="inquire_item6">备注：</td>
      	<td class="inquire_form6" colspan="5">
      	<textarea id="prenotes" name="prenotes" onpropertychange="if(value.length>100) value=value.substr(0,100)" class='textarea'><%=prepareMap.getNotes()==null?"":prepareMap.getNotes()%></textarea>
		</td>
    </tr>
</table>
</div>  

  		<% String subjectionIdDiv = applyInfo.getOrgSubjectionId(); 
			   if(subOrgIDofAffordOrg!=null &&subjectionIdDiv.startsWith(subOrgIDofAffordOrg)){  
			%>
			<div> 
	    <%}else{ %>		
			<div style="display:none;"> 
		  <%
			}
		  %>			
	<table id="lineTable" width="99%" border="0" cellspacing="0" cellpadding="0"  style="margin-top:2px;" >
    	<tr>
    	    <td class="bt_info_odd" width="3%">序号</td>
            <td class="bt_info_odd" width="6%">班组</td>
            <td class="bt_info_even" width="6%">岗位</td>		
            <td class="bt_info_odd" width="6%">计划人数</td>
            <td class="bt_info_even" width="6%">其中专业化人数</td>
            <td class="bt_info_odd" width="8%">计划进入时间</td>			
            <td class="bt_info_even" width="8%">计划离开时间</td> 
            <td class="bt_info_odd" width="6%">年龄</td>			
            <td class="bt_info_even" width="6%">工作年限</td> 
            <td class="bt_info_odd" width="6%">文化程度</td>             
            <td class="bt_info_even" width="6%">自有人数</td>
            <td class="bt_info_odd" width="6%">需调配人数<input type="hidden"
					name="postDetailSize" id="postDetailSize"
					value="<%=beanList.size()%>"/></td>
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
			BgpHumanPreparePostDetail applyDetailInfo = beanList.get(i);
			String flag = "false";
	  %>
		<tr id="fy<%=i%>trflag">
		
		<td class="<%=className%>odd"><%=i+1 %><input type="hidden" name="fy<%=i%>postNo" id="fy<%=i%>postNo" value="<%=applyDetailInfo.getPostNo()==null?"":applyDetailInfo.getPostNo()%>"/></td>
		<td class="<%=className%>even"><input type="hidden" id="fy<%=i%>applyTeam" name="fy<%=i%>applyTeam" value="<%=applyDetailInfo.getApplyTeam()==null?"":applyDetailInfo.getApplyTeam()%>" class="input_width" readonly="readonly"/>
		<input type="text" id="fy<%=i%>applyTeamname" name="fy<%=i%>applyTeamname" value="<%=applyDetailInfo.getApplyTeamname()==null?"":applyDetailInfo.getApplyTeamname()%>" class="input_width" readonly="readonly"/>
		</td>
		<td class="<%=className%>odd"><input type="hidden" id="fy<%=i%>post" name="fy<%=i%>post" value="<%=applyDetailInfo.getPost()==null?"":applyDetailInfo.getPost()%>" class="input_width" readonly="readonly"/>
		<input type="text" id="fy<%=i%>postname" name="fy<%=i%>postname" value="<%=applyDetailInfo.getPostname()==null?"":applyDetailInfo.getPostname()%>" class="input_width" readonly="readonly"/>
		</td>
		<td class="<%=className%>even"><input type="text" id="fy<%=i%>peopleNum" name="fy<%=i%>peopleNum" value="<%=applyDetailInfo.getPeopleNum()==null?"":applyDetailInfo.getPeopleNum()%>" class="input_width" readonly="readonly"/></td>
		<td class="<%=className%>even"><input type="text" id="fy<%=i%>professNum" name="fy<%=i%>professNum" value="<%=applyDetailInfo.getProfessNum()==null?"":applyDetailInfo.getProfessNum()%>"  class="input_width"  readonly="readonly"/></td>
		
		<td class="<%=className%>odd"><input type="text" name="fy<%=i%>planStartDate" id="fy<%=i%>planStartDate"  readonly="readonly" value="<%=applyDetailInfo.getPlanStartDate()==null?"":applyDetailInfo.getPlanStartDate()%>"  class="input_width" /></td>
		<td class="<%=className%>even"><input type="text" name="fy<%=i%>planEndDate" id="fy<%=i%>planEndDate"  readonly="readonly" value="<%=applyDetailInfo.getPlanEndDate()==null?"":applyDetailInfo.getPlanEndDate()%>"  class="input_width" /></td>
		
		<td class="<%=className%>odd"><code:codeSelect name='<%=("fy"+String.valueOf(i)+"age")%>' option="hrAgeOps" addAll="true" selectedValue='<%=applyDetailInfo.getAge()==null?"":applyDetailInfo.getAge()%>' cssClass="select_width"/></td>
		<td class="<%=className%>even"><code:codeSelect name='<%=("fy"+String.valueOf(i)+"workYears")%>' option="workYearOps" addAll="true" selectedValue='<%=applyDetailInfo.getWorkYears()==null?"":applyDetailInfo.getWorkYears()%>' cssClass="select_width"/></td>
		<td class="<%=className%>odd"><code:codeSelect name='<%=("fy"+String.valueOf(i)+"culture")%>' option="hrDegreeOps" addAll="true" selectedValue='<%=applyDetailInfo.getCulture()==null?"":applyDetailInfo.getCulture()%>' cssClass="select_width"/></td>
					
		<td class="<%=className%>even"><input type="text" maxlength="32" id="fy<%=i%>ownNum" name="fy<%=i%>ownNum" onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);" value="<%=applyDetailInfo.getOwnNum()==null?"":applyDetailInfo.getOwnNum()%>" class="input_width" readonly="readonly"/></td>
		<td class="<%=className%>odd"><input type="text" maxlength="32" id="fy<%=i%>deployNum" name="fy<%=i%>deployNum" onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);" value="<%=applyDetailInfo.getDeployNum()==null?"":applyDetailInfo.getDeployNum()%>" class="input_width" readonly="readonly"/></td>
		<td class="<%=className%>even">
			<% String subjectionId = applyInfo.getOrgSubjectionId(); 
			  // if(update != null){ subjectionId = applyDetailInfo.getPrepareSubjectionId();}
			   if(subOrgIDofAffordOrg!=null &&subjectionId.startsWith(subOrgIDofAffordOrg)){ flag = "true";
			%>
			<a href="javascript:openSearch('fy<%=i%>')">选择</a><%}else{ %>
			<a href="javascript:openSearch('fy<%=i%>')" disabled="disabled"
					onclick="return false;">选择</a> <%}%><input
					type="hidden" name="fy<%=i%>flag" id="fy<%=i%>flag"
					value="<%=flag%>" />
			
		</td>	
		

		
		</tr>	
	  <%
		}
	  %>
    </table>	
	</div>
	
	<%if(subBeanList.size()>0){
		if(subOrgIDofAffordOrg!=null &&subjectionIdDiv.startsWith(subOrgIDofAffordOrg)){  
	 %>
				<div style="display:none;"> 
	 <%}else{ %>		
			
				<div <% if(update != null){ %>  style="display:block" <%} %>> 	
	   <%
		 }
	   %>
 		
	<table width="99%" border="0" cellspacing="0" cellpadding="0" style="margin-top:2px;">
    	<tr class="bt_info">
    	    <td width="3%">序号</td>
            <td width="6%">班组</td>
            <td width="6%">岗位</td>		
            <td width="8%">调配单位</td>
            <td width="6%">调配人数</td>			
            <td width="5%">年龄</td>			
            <td width="5%">工作年限</td> 
            <td width="5%">文化程度</td> 
            <td width="8%">预计进入项目时间</td> 
            <td width="8%">预计离开项目时间</td> 
            <td width="6%">备注</td> 
            <td width="3%">操作<input type="hidden"
					id="equipmentESize" name="equipmentESize"
					value="<%=subBeanList.size()%>" /></td>
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
			String flag = "false";
		%>	
		<tr class="<%=className%>" id="em<%=i%>trflag">
		
		<td><%=i+1 %><input type="hidden" name="em<%=i%>postDetailNo" id="em<%=i%>postDetailNo" value="<%=applyDetailInfo.getPostDetailNo()==null?"":applyDetailInfo.getPostDetailNo()%>"/>
		</td>
		<td><input type="hidden" name="em<%=i%>postNo" id="em<%=i%>postNo" value="<%=applyDetailInfo.getPostNo()==null?"":applyDetailInfo.getPostNo()%>"/> 
		<input type="hidden" id="em<%=i%>applyTeam" name="em<%=i%>applyTeam" value="<%=applyDetailInfo.getApplyTeam()==null?"":applyDetailInfo.getApplyTeam()%>" class="input_width" readonly="readonly"/>
		<input type="text" id="em<%=i%>applyTeamname" name="em<%=i%>applyTeamname" value="<%=applyDetailInfo.getApplyTeamname()==null?"":applyDetailInfo.getApplyTeamname()%>" class="input_width" readonly="readonly"/>
		</td>
		<td><input type="hidden" id="em<%=i%>post" name="em<%=i%>post" value="<%=applyDetailInfo.getPost()==null?"":applyDetailInfo.getPost()%>" class="input_width" readonly="readonly"/>
		<input type="text" id="em<%=i%>postname" name="em<%=i%>postname" value="<%=applyDetailInfo.getPostname()==null?"":applyDetailInfo.getPostname()%>" class="input_width" readonly="readonly"/>
		</td>
		<td><input type="hidden" id="em<%=i%>deployOrg" name="em<%=i%>deployOrg" value="<%=applyDetailInfo.getDeployOrg()==null?"":applyDetailInfo.getDeployOrg()%>" class="input_width" readonly="readonly"/>
		<input type="text" maxlength="32" id="em<%=i%>deployOrgName" name="em<%=i%>deployOrgName" value="<%=applyDetailInfo.getDeployOrgName()==null?"":applyDetailInfo.getDeployOrgName()%>" class="input_width" readonly="readonly"/></td>
		<td><input type="text" id="em<%=i%>peopleNumber" name="em<%=i%>peopleNumber" value="<%=applyDetailInfo.getPeopleNumber()==null?"":applyDetailInfo.getPeopleNumber()%>"  onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);" class="input_width" /></td>
		<td><code:codeSelect name='<%=("em"+String.valueOf(i)+"age")%>' option="hrAgeOps" addAll="true" selectedValue='<%=applyDetailInfo.getAge()==null?"":applyDetailInfo.getAge()%>' cssClass="select_width"/></td>
		<td><code:codeSelect name='<%=("em"+String.valueOf(i)+"workYears")%>' option="workYearOps" addAll="true" selectedValue='<%=applyDetailInfo.getWorkYears()==null?"":applyDetailInfo.getWorkYears()%>' cssClass="select_width" /></td>
		<td><code:codeSelect name='<%=("em"+String.valueOf(i)+"culture")%>' option="hrDegreeOps" addAll="true" selectedValue='<%=applyDetailInfo.getCulture()==null?"":applyDetailInfo.getCulture()%>' cssClass="select_width"/></td>			
		<td><input type="text" name="em<%=i%>planStartDate" id="em<%=i%>planStartDate"  readonly="readonly" value="<%=applyDetailInfo.getPlanStartDate()==null?"":applyDetailInfo.getPlanStartDate()%>"  class="input_width" /></td>
		<td><input type="text" name="em<%=i%>planEndDate" id="em<%=i%>planEndDate"  readonly="readonly" value="<%=applyDetailInfo.getPlanEndDate()==null?"":applyDetailInfo.getPlanEndDate()%>"  class="input_width" /></td>
		<td><input type="text" maxlength="32" id="em<%=i%>notes" name="em<%=i%>notes"  value="<%=applyDetailInfo.getNotes()==null?"":applyDetailInfo.getNotes()%>" class="input_width" />
		</td>
		<td>
		<%if(subOrgIDofAffordOrg!=null &&applyDetailInfo.getDeploySubId().startsWith(subOrgIDofAffordOrg)){
			if("3".equals(prepareMap.getFunctionType()) && "1".equals(applyDetailInfo.getDeployFlag())){
				if("true".equals(applyDetailInfo.getDeFlag())){ flag = "true"; %> <a
					href="javascript:openSearch('em<%=i%>')">选择</a>
				<%}else{ flag = "false"; %>
					<a href="javascript:openSearch('em<%=i%>')" disabled="disabled"
					onclick="return false;">选择</a>			
			 <%}	
			}else{ flag = "true";%> <a href="javascript:openSearch('em<%=i%>')">选择</a>
					<%}
		 }else{
			    flag = "false"; %>
				 <a href="javascript:openSearch('em<%=i%>')"
					disabled="disabled" onclick="return false;">选择</a>
		 <%} %>
			    <input
					type="hidden" name="em<%=i%>flag" id="em<%=i%>flag"
					value="<%=flag%>" />
					</td>


		</tr>	
		<%
		}
	}
	%>
      </table>
     </div>
     
     <div style="width:100%;overflow-x:scroll;overflow-y:scroll;"> 		
	<table width="99%" border="0" cellspacing="0" cellpadding="0" style="margin-top:2px;" id="employeeTable">
    	<tr class="bt_info">
    	    <td width="3%">序号</td>
            <td width="15%">班组</td>
            <td width="15%">岗位</td>		
            <td width="10%">姓名</td>
            <td width="15%">预计进入项目时间</td> 
            <td width="15%">预计离开项目时间</td> 
            <td width="10%">预计天数</td> 
            <td width="3%">操作<input type="hidden"
					id="equipmentSize" name="equipmentSize"
					value="<%=humanList.size()%>" /> <input type="hidden"
					id="hidDetailId" name="hidDetailId" value="" /> <input
					type="hidden" id="deleteRowFlag" name="deleteRowFlag" value="" />
					<input type="hidden" id="employeeIds" name="employeeIds" value="" />  
					<input type="hidden" id="qufens" name="qufens" value="" />  
					
					</td>
        </tr>       
   <%
	if(humanList != null && humanList.size()>0){			  

		for (int j = 0; j < humanList.size(); j++) {
			String className = "";
			if (j % 2 == 0) {
				className = "even";
			} else {
				className = "odd";
			}
			BgpHumanPrepareHumanDetail humanInfo = humanList.get(j);

	%>
			<tr class="<%=className%>" id="hu<%=j%>trflag">
				<td><%=j + 1%><input type="hidden" id="hu<%=j%>humanDetailNo"
					name="hu<%=j%>humanDetailNo"
					value="<%=humanInfo.getHumanDetailNo() ==null?"":humanInfo.getHumanDetailNo()%>" />
				
				</td>
				<td><input type="hidden" id="hu<%=j%>psw"
					name="hu<%=j%>psw"
						value="u" /><input type="hidden" id="hu<%=j%>qufen"
					name="hu<%=j%>qufen"
						value="<%=humanInfo.getQufen() ==null?"2":humanInfo.getQufen()%>" /> <input type="hidden" maxlength="32" name="hu<%=j%>team"
					id="hu<%=j%>team"
					value="<%=humanInfo.getTeam()==null?"":humanInfo.getTeam()%>" /> <input
					type="text" maxlength="32" name="hu<%=j%>teamName"
					id="hu<%=j%>teamName"
					value="<%=humanInfo.getTeamName()==null?"":humanInfo.getTeamName()%>"
					readonly="readonly" class="input_width" /></td>
				<td><input type="hidden" maxlength="32" name="hu<%=j%>workPost"
					id="hu<%=j%>workPost"
					value="<%=humanInfo.getWorkPost()==null?"":humanInfo.getWorkPost()%>"
					class="input_width" /> <input type="text" maxlength="32"
					name="hu<%=j%>workPostName" id="hu<%=j%>workPostName"
					value="<%=humanInfo.getWorkPostName()==null?"":humanInfo.getWorkPostName()%>"
					readonly="readonly" class="input_width" /></td>
				<td><input type="hidden" maxlength="32"
					name="hu<%=j%>employeeId" id="hu<%=j%>employeeId"
					value="<%=humanInfo.getEmployeeId()==null?"":humanInfo.getEmployeeId()%>"
					class="input_width" /> <input type="text" maxlength="32"
					name="hu<%=j%>employeeName" id="hu<%=j%>employeeName"
					value="<%=humanInfo.getEmployeeName()==null?"":humanInfo.getEmployeeName()%>"
					readonly="readonly" class="input_width" /></td>

				<td><input type="text" name="hu<%=j%>planStartDate"
					id="hu<%=j%>planStartDate" readonly="readonly"
					value="<%=humanInfo.getPlanStartDate()==null?"":humanInfo.getPlanStartDate()%>"
					onpropertychange="calDays('<%=j %>')" class="input_width" />&nbsp;&nbsp;<img
					src="<%=contextPath%>/images/calendar.gif" id="tributton2<%=j%>"
					width="16" height="16" style="cursor: hand;"
					onmouseover="calDateSelector('hu<%=j%>planStartDate',tributton2<%=j%>);" />
				</td>
				<td><input type="text" name="hu<%=j%>planEndDate"
					id="hu<%=j%>planEndDate" readonly="readonly"
					value="<%=humanInfo.getPlanEndDate()==null?"":humanInfo.getPlanEndDate()%>"
					onpropertychange="calDays('<%=j %>')" class="input_width" />&nbsp;&nbsp;<img
					src="<%=contextPath%>/images/calendar.gif" id="tributton3<%=j%>"
					width="16" height="16" style="cursor: hand;"
					onmouseover="calDateSelector('hu<%=j%>planEndDate',tributton3<%=j%>);"  />
				</td>
				<td><input type="text" maxlength="32" name="days<%=j%>"
					value="<%=humanInfo.getPlanDays()==null?"":humanInfo.getPlanDays()%>"
					readonly="readonly" class="input_width" />
				</td>
				<td><input type="hidden" name="orderDrill" value="" /><img
					src="<%=contextPath%>/images/delete.png" width="16" height="16"
					style="cursor: hand;" onclick="deleteDevice('<%=j%>')" />
				</td>
			</tr>
			<%
			}
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
