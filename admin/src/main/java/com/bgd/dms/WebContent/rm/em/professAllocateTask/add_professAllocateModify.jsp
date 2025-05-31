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
	
	List<MsgElement> allocatelist = resultMsg.getMsgElements("allocatelist");
	List<BgpCommHumanAllocateTaskA> alloTaskList=new ArrayList<BgpCommHumanAllocateTaskA>(0);
	if(allocatelist!=null){
		alloTaskList = new ArrayList<BgpCommHumanAllocateTaskA>(allocatelist.size());	
		for (int i = 0; i < allocatelist.size(); i++) {
			alloTaskList.add((BgpCommHumanAllocateTaskA) allocatelist.get(i).toPojo(
					BgpCommHumanAllocateTaskA.class));
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
var currentCount=parseInt('<%=alloTaskList.size()%>');
var deviceCount = parseInt('<%=alloTaskList.size()%>');

function save(){
	if(checkForm()){
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/rm/em/toSaveProfessionAllocate.srq";
		form.submit();
		newClose(); 
}
}


function closeHere(){
window.close();
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
			if(!notNullForCheck("al"+i+"employeeId","调配人")) return false;
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

//加一行分配任务
function addDeploy(deviceNum){

	var postDetailNo = document.getElementById("em"+deviceNum+"postDetailNo").value;
	var applyTeamname = document.getElementById("em"+deviceNum+"applyTeamname").value;
	var applyTeam = document.getElementById("em"+deviceNum+"applyTeam").value;
	var postname = document.getElementById("em"+deviceNum+"postname").value;
	var post = document.getElementById("em"+deviceNum+"post").value;
	
    //添加tr
	var tr = document.getElementById("equipmentTableInfo").insertRow();
  	if(currentCount % 2 == 1){  
  		tr.className = "odd";
	}else{ 
		tr.className = "even";
	}	
	tr.id = "al"+deviceCount+"trflag";

    //需求子表id,为空
	tr.insertCell().innerHTML = currentCount+1+'<input type="hidden" id="al'+deviceCount+'taskAllocationId" name="al'+deviceCount+'taskAllocationId" value=""/>'+'<input type="hidden" id="al'+deviceCount+'postDetailNo" name="al'+deviceCount+'postDetailNo" value="'+postDetailNo+'"/>';
	tr.insertCell().innerHTML = '<input type="hidden" id="al'+deviceCount+'applyTeam" name="al'+deviceCount+'applyTeam" value="'+applyTeam+'"/>'+'<input type="text" readonly="readonly" id="al'+deviceCount+'applyTeamname" name="al'+postDetailNo+'applyTeamname" value="'+applyTeamname+'" class="input_width"/>';
	tr.insertCell().innerHTML = '<input type="hidden" id="al'+deviceCount+'post" name="al'+deviceCount+'post" value="'+post+'"/>'+'<input type="text" readonly="readonly" id="al'+deviceCount+'postname" name="al'+postDetailNo+'postname" value="'+postname+'" class="input_width"/>';
	tr.insertCell().innerHTML = '<input type="hidden" id="al'+deviceCount+'employeeId" name="al'+deviceCount+'employeeId" value=""/>'+'<input type="text" readonly="readonly"  id="al'+deviceCount+'employeeName" name="al'+deviceCount+'employeeName" value="" class="input_width"/>'+'<img src="'+'<%=contextPath%>'+'/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectPerson('+deviceCount+')"  />';
	tr.insertCell().innerHTML = '<input type="text"  id="al'+deviceCount+'notes" name="al'+deviceCount+'notes"  value=""  class="input_width"/>';

	tr.insertCell().innerHTML =  '<span class="sc"><a href="#" onclick="deleteDevice(\'' + deviceCount + '\')"></a></span>';

	document.getElementById("equipmentSize").value=deviceCount+1;
	deviceCount+=1;
	currentCount+=1;

}

//选择调配人
function selectPerson(deviceNum){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/common/selectEmployee.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
        document.getElementById("al"+deviceNum+"employeeId").value = teamInfo.fkValue;
        document.getElementById("al"+deviceNum+"employeeName").value = teamInfo.value;
    }
}


function deleteDevice(deviceNum){
	
	var rowDetailId = document.getElementById("hidDetailId").value;
	var rowDeleteId = document.getElementById("al"+deviceNum+"taskAllocationId").value;

	if(	rowDeleteId!=""&&rowDeleteId!=null){
		rowDetailId = rowDetailId+rowDeleteId+",";
		document.getElementById("hidDetailId").value = rowDetailId;
	}	

	var rowDevice = document.getElementById("al"+deviceNum+"trflag");
	rowDevice.parentNode.removeChild(rowDevice);
	var rowFlag = document.getElementById("deleteRowFlag").value;
	rowFlag=rowFlag+deviceNum+",";
	document.getElementById("deleteRowFlag").value = rowFlag;

	currentCount-=1;
	
	//删除后重新排列序号
	deleteChangeInfoNum('taskAllocationId');

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
		  	if(num % 2 == 1){  
		  		document.getElementById("al"+i+"trflag").className = "even";
			}else{ 
				document.getElementById("al"+i+"trflag").className = "odd";
			}
			document.getElementById("al"+i+warehouseDetailId).parentNode.innerHTML=num+document.getElementById("al"+i+warehouseDetailId).outerHTML;
			num+=1;
		}
	}
}
</script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
</head>
<body>
<form id="CheckForm" action="" method="post" target="list" enctype="multipart/form-data">
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
	<div> 			
	<table id="lineTable" width="100%" border="0" cellspacing="0" cellpadding="0"  style="margin-top:2px;" >
    	<tr>
    	    <td class="bt_info_odd" width="3%">序号</td>
            <td class="bt_info_even" width="6%">班组</td>
            <td class="bt_info_odd" width="6%">岗位</td>		
            <td class="bt_info_even" width="6%">计划人数</td>
            <td class="bt_info_odd" width="8%">计划进入时间</td>			
            <td class="bt_info_even" width="8%">计划离开时间</td> 
            <td class="bt_info_odd" width="6%">年龄</td>			
            <td class="bt_info_even" width="6%">工作年限</td> 
            <td class="bt_info_odd" width="6%">文化程度</td>             
            <td class="bt_info_even" width="6%">自有人数</td>
            <td class="bt_info_odd" width="6%">需调配人数</td>
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
		<input type="text" id="fy<%=i%>applyTeamname" name="fy<%=i%>applyTeamname" value="<%=applyDetailInfo.getApplyTeamname()==null?"":applyDetailInfo.getApplyTeamname()%>" class="input_width" readonly="readonly"/>
		</td>
		<td class="<%=className%>odd"><input type="hidden" id="fy<%=i%>post" name="fy<%=i%>post" value="<%=applyDetailInfo.getPost()==null?"":applyDetailInfo.getPost()%>" class="input_width" readonly="readonly"/>
		<input type="text" id="fy<%=i%>postname" name="fy<%=i%>postname" value="<%=applyDetailInfo.getPostname()==null?"":applyDetailInfo.getPostname()%>" class="input_width" readonly="readonly"/>
		</td>
		<td class="<%=className%>even"><input type="text" id="fy<%=i%>peopleNum" name="fy<%=i%>peopleNum" value="<%=applyDetailInfo.getPeopleNum()==null?"":applyDetailInfo.getPeopleNum()%>" class="input_width" readonly="readonly"/></td>
		
		<td class="<%=className%>odd"><input type="text" name="fy<%=i%>planStartDate" id="fy<%=i%>planStartDate"  readonly="readonly" value="<%=applyDetailInfo.getPlanStartDate()==null?"":applyDetailInfo.getPlanStartDate()%>" class="input_width" /></td>
		<td class="<%=className%>even"><input type="text" name="fy<%=i%>planEndDate" id="fy<%=i%>planEndDate"  readonly="readonly" value="<%=applyDetailInfo.getPlanEndDate()==null?"":applyDetailInfo.getPlanEndDate()%>" class="input_width" /></td>
		
		<td class="<%=className%>odd"><code:codeSelect name='<%=("fy"+String.valueOf(i)+"age")%>' option="hrAgeOps" addAll="true" selectedValue='<%=applyDetailInfo.getAge()==null?"":applyDetailInfo.getAge()%>' /></td>
		<td class="<%=className%>even"><code:codeSelect name='<%=("fy"+String.valueOf(i)+"workYears")%>' option="workYearOps" addAll="true" selectedValue='<%=applyDetailInfo.getWorkYears()==null?"":applyDetailInfo.getWorkYears()%>' /></td>
		<td class="<%=className%>odd"><code:codeSelect name='<%=("fy"+String.valueOf(i)+"culture")%>' option="hrDegreeOps" addAll="true" selectedValue='<%=applyDetailInfo.getCulture()==null?"":applyDetailInfo.getCulture()%>' /></td>
					
		<td class="<%=className%>even"><input type="text" maxlength="32" id="fy<%=i%>ownNum" name="fy<%=i%>ownNum" onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);" value="<%=applyDetailInfo.getOwnNum()==null?"":applyDetailInfo.getOwnNum()%>" class="input_width" readonly="readonly"/></td>
		<td class="<%=className%>odd"><input type="text" maxlength="32" id="fy<%=i%>deployNum" name="fy<%=i%>deployNum" onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);" value="<%=applyDetailInfo.getDeployNum()==null?"":applyDetailInfo.getDeployNum()%>" class="input_width" readonly="readonly"/></td>
		</tr>	
	  <%
		}
	  %>
    </table>	
	</div>
	<br/>
	<div> 			
	<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:2px;"  >
    	<tr class="bt_info">
    	    <td width="3%">序号</td>
            <td width="6%">班组</td>
            <td width="6%">岗位</td>		
            <td width="8%">调配单位</td>
            <td width="5%">调配人数</td>			
            <td width="6%">年龄</td>			
            <td width="6%">工作年限</td> 
            <td width="6%">文化程度</td> 
            <td width="8%">预计进入项目时间</td> 
            <td width="8%">预计离开项目时间</td> 
            <td width="6%">备注</td> 
            <td width="3%">操作</td>
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
		<input type="text" id="em<%=i%>applyTeamname" name="em<%=i%>applyTeamname" value="<%=applyDetailInfo.getApplyTeamname()==null?"":applyDetailInfo.getApplyTeamname()%>" class="input_width" readonly="readonly"/>
		</td>
		<td><input type="hidden" id="em<%=i%>post" name="em<%=i%>post" value="<%=applyDetailInfo.getPost()==null?"":applyDetailInfo.getPost()%>" class="input_width" readonly="readonly"/>
		<input type="text" id="em<%=i%>postname" name="em<%=i%>postname" value="<%=applyDetailInfo.getPostname()==null?"":applyDetailInfo.getPostname()%>" class="input_width" readonly="readonly"/>
		</td>
		<td><input type="hidden" id="em<%=i%>deployOrg" name="em<%=i%>deployOrg" value="<%=applyDetailInfo.getDeployOrg()==null?"":applyDetailInfo.getDeployOrg()%>" class="input_width" readonly="readonly"/>
		<input type="text" maxlength="32" id="em<%=i%>deployOrgName" name="em<%=i%>deployOrgName" value="<%=applyDetailInfo.getDeployOrgName()==null?"":applyDetailInfo.getDeployOrgName()%>" class="input_width" readonly="readonly"/></td>
		<td><input type="text" id="em<%=i%>peopleNumber" name="em<%=i%>peopleNumber" value="<%=applyDetailInfo.getPeopleNumber()==null?"":applyDetailInfo.getPeopleNumber()%>"  onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);" class="input_width" /></td>
		<td><code:codeSelect name='<%=("em"+String.valueOf(i)+"age")%>' option="hrAgeOps" addAll="true" selectedValue='<%=applyDetailInfo.getAge()==null?"":applyDetailInfo.getAge()%>' cssClass="select_width" /></td>
		<td><code:codeSelect name='<%=("em"+String.valueOf(i)+"workYears")%>' option="workYearOps" addAll="true" selectedValue='<%=applyDetailInfo.getWorkYears()==null?"":applyDetailInfo.getWorkYears()%>' cssClass="select_width"/></td>
		<td><code:codeSelect name='<%=("em"+String.valueOf(i)+"culture")%>' option="hrDegreeOps" addAll="true" selectedValue='<%=applyDetailInfo.getCulture()==null?"":applyDetailInfo.getCulture()%>' cssClass="select_width"/></td>			
		<td><input type="text" name="em<%=i%>planStartDate" id="em<%=i%>planStartDate"  readonly="readonly" value="<%=applyDetailInfo.getPlanStartDate()==null?"":applyDetailInfo.getPlanStartDate()%>" class="input_width"/></td>
		<td><input type="text" name="em<%=i%>planEndDate" id="em<%=i%>planEndDate"  readonly="readonly" value="<%=applyDetailInfo.getPlanEndDate()==null?"":applyDetailInfo.getPlanEndDate()%>" class="input_width"/></td>
		<td><input type="text" maxlength="32" id="em<%=i%>notes" name="em<%=i%>notes"  value="<%=applyDetailInfo.getNotes()==null?"":applyDetailInfo.getNotes()%>" class="input_width" /></td>
		<td><input name="button" type="button" onclick="addDeploy('<%=i%>')" value="分配" /></td>	
		</tr>	
		<%
		}
	%>
      </table>
     </div>
     <br/>
 	<div> 			
	<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:2px;" id="equipmentTableInfo" >
    	<tr class="bt_info">
    	    <td width="6%">序号</td>
            <td width="15%">班组</td>
            <td width="15%">岗位</td>		
            <td width="15%">调配人</td>
            <td width="15%">备注</td>			
            <td width="5%">操作<input type="hidden" id="equipmentSize" name="equipmentSize" value="<%=alloTaskList.size()%>" />
			<input type="hidden" id="hidDetailId" name="hidDetailId" value=""/>
			<input type="hidden" id="deleteRowFlag" name="deleteRowFlag" value="" /></td>
        </tr>
        
        <%
		for (int i = 0; i < alloTaskList.size(); i++) {
			String className = "";
			if (i % 2 == 1) {
				className = "odd";
			} else {
				className = "even";
			}
			BgpCommHumanAllocateTaskA applyDetailInfo = alloTaskList.get(i);

		%>	
	<tr class="<%=className%>" id="al<%=i%>trflag">
		<td><%=i + 1%><input type="hidden" id="al<%=i%>taskAllocationId" name="al<%=i%>taskAllocationId" value="<%=applyDetailInfo.getTaskAllocationId()==null?"":applyDetailInfo.getTaskAllocationId()%>" />
		<input type="hidden" id="al<%=i%>postDetailNo" name="al<%=i%>postDetailNo" value="<%=applyDetailInfo.getPostDetailNo()==null?"":applyDetailInfo.getPostDetailNo()%>" /></td>		
		<td><input type="hidden" id="al<%=i%>applyTeam" name="al<%=i%>applyTeam" value="<%=applyDetailInfo.getApplyTeam()==null?"":applyDetailInfo.getApplyTeam()%>"/>
		<input type="text" readonly="readonly" id="al<%=i%>applyTeamname" name="al<%=i%>applyTeamname" value="<%=applyDetailInfo.getApplyTeamname()==null?"":applyDetailInfo.getApplyTeamname()%>" class="input_width"/>
		</td>
		<td><input type="hidden" id="al<%=i%>post" name="al<%=i%>post" value="<%=applyDetailInfo.getPost()==null?"":applyDetailInfo.getPost()%>"/>
		<input type="text" readonly="readonly" id="al<%=i%>postname" name="al<%=i%>postname" value="<%=applyDetailInfo.getPostname()==null?"":applyDetailInfo.getPostname()%>" class="input_width"/>
		</td>
		<td><input type="hidden" id="al<%=i%>employeeId" name="al<%=i%>employeeId" value="<%=applyDetailInfo.getEmployeeId()==null?"":applyDetailInfo.getEmployeeId()%>"/>
		<input type="text" readonly="readonly" id="al<%=i%>employeeName" name="al<%=i%>employeeName" value="<%=applyDetailInfo.getEmployeeName()==null?"":applyDetailInfo.getEmployeeName()%>" class="input_width"/>
		<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectPerson('<%=i%>')"  />
		</td>
		<td><input type="text" id="al<%=i%>notes" name="al<%=i%>notes" value="<%=applyDetailInfo.getNotes()==null?"":applyDetailInfo.getNotes()%>" class="input_width"/></td>
		<td><input type="hidden" name="orderDrill" value=""/>
		<span class="sc"><a href="#" onclick="deleteDevice('<%=i%>')"></a></span></td>
	</tr>	

		<%
		}
	%>
      </table>
</div>
    <div id="oper_div">
        <span class="bc_btn"><a href="#" onclick="save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
 </form>
</body>
</html>
