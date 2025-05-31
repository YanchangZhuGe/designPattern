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

	List<MsgElement> list = resultMsg.getMsgElements("detailInfo");
	List<BgpProjectHumanProfessPost> beanList=new ArrayList<BgpProjectHumanProfessPost>(0);
	if(list!=null){
		beanList = new ArrayList<BgpProjectHumanProfessPost>(list.size());	
		for (int i = 0; i < list.size(); i++) {
			beanList.add((BgpProjectHumanProfessPost) list.get(i).toPojo(
					BgpProjectHumanProfessPost.class));
		}
	}

	String degreeStr = resultMsg.getValue("degreeStr");
	
	String workYearStr = resultMsg.getValue("workYearStr");
	
	String ageStr = resultMsg.getValue("ageStr");
	String buttonViewFile = resultMsg.getValue("buttonView"); 
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
		form.action = "<%=contextPath%>/rm/em/toSaveProfessionRequired.srq";
		form.submit();
		newClose();
	}

}

function checkForm(){
	var deviceCount = document.getElementById("equipmentSize").value;
	var isCheck=true;
	for(var i=0;i<deviceCount;i++){
		if(document.getElementById("fy"+i+"check").checked == true){
			isCheck=false;
			if(!notNullForCheck("fy"+i+"planStartDate","计划进入项目时间")) return false;
			if(!notNullForCheck("fy"+i+"planEndDate","计划离开项目时间")) return false;
			
			if(!notNullForCheck("fy"+i+"ownNum","自有人数")) return false;
			if(!notNullForCheck("fy"+i+"deployNum","需调配人数")) return false;
									
		}
	}
	if(isCheck){
		alert("请选择一条记录");
		return false;
	}else{
		return true;
	}
	

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
	td.className=classCss+"odd";
 
	td.innerHTML = '<input type="checkbox" id="fy'+deviceCount+'check" name="fy'+deviceCount+'check" >';
	
	var td = tr.insertCell(1);
	td.className=classCss+"even";
 
	td.innerHTML = currentCount+1+'&nbsp;&nbsp;<input type="hidden" id="fy'+deviceCount+'postNo" name="fy'+deviceCount+'postNo" value="" />';
		
	var td = tr.insertCell(2);
	td.className=classCss+"odd";
	 
	td.innerHTML = '<select style="width:70px;" name="fy'+ deviceCount + 'applyTeam" id="fy'+ deviceCount + 'applyTeam" onchange="getPost('+deviceCount+')" >'+getApplyTeam()+'</select>';
	
	var td = tr.insertCell(3);
	td.className=classCss+"even";
 
	td.innerHTML = '<select style="width:150px;"    name="fy'+ deviceCount + 'post" id="fy'+ deviceCount + 'post"  > <option value="">请选择</option> </select>';
	
	var td = tr.insertCell(4);
	td.className=classCss+"odd";
 
	td.innerHTML = '<input type="text" maxlength="32"   readonly="readonly" name="fy'+ deviceCount + 'spare2" id="fy'+ deviceCount + 'spare2"  value="" style="width:55px;background-color:#DDDDDD;"  />';

	var td = tr.insertCell(5);
	td.className=classCss+"even";
 
	td.innerHTML = '<input type="text" maxlength="32"  readonly="readonly"  name="fy'+ deviceCount + 'spare3" id="fy'+ deviceCount + 'spare3" value="" style="width:60px;background-color:#DDDDDD;"  />';

	var td = tr.insertCell(6);
	td.className=classCss+"odd";
	 
	td.innerHTML = '<input type="text" onpropertychange="calDays('+deviceCount+')"  readonly="readonly" maxlength="32" id="fy'+deviceCount+'planStartDate" name="fy'+deviceCount+'planStartDate" value="" style="width:60px;"  />'+'<img src="'+'<%=contextPath%>'+'/images/calendar.gif" id="tributton3'+deviceCount+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+"'"+startTime+"'"+',tributton3'+deviceCount+');" />';
	
	var td = tr.insertCell(7);
	td.className=classCss+"even";
 
	td.innerHTML = '<input type="text" onpropertychange="calDays('+deviceCount+')" readonly="readonly" maxlength="32" id="fy'+deviceCount+'planEndDate" name="fy'+deviceCount+'planEndDate" value="" style="width:60px;"  />'+'<img src="'+'<%=contextPath%>'+'/images/calendar.gif" id="tributton4'+deviceCount+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+"'"+endTime+"'"+',tributton4'+deviceCount+');" />';
	
	var td = tr.insertCell(8);
	td.className=classCss+"odd";
 
	td.innerHTML = '<select id="fy'+deviceCount+'age" name="fy'+deviceCount+'age" style="width:84px;" >'+age_str+'</select>';

	var td = tr.insertCell(9);
	td.className=classCss+"even";
 
	td.innerHTML = '<select id="fy'+deviceCount+'workYears" name="fy'+deviceCount+'workYears" style="width:84px;" >'+work_str+'</select>';
	
	var td = tr.insertCell(10);
	td.className=classCss+"odd";
	 
	td.innerHTML = '<select id="fy'+deviceCount+'culture" name="fy'+deviceCount+'culture" style="width:140px;" >'+ge_str+'</select>';

	var td = tr.insertCell(11);
	td.className=classCss+"even";
 
	td.innerHTML = '<input type="text" maxlength="32" value="" style="width:50px;"  />';
			
	var td = tr.insertCell(12);
	td.className=classCss+"odd";
 
	td.innerHTML = '<input type="text" maxlength="32" value="" style="width:50px;"  />';

	
	var td = tr.insertCell(13);
	td.className=classCss+"even";
	 
	td.innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'ownNum" name="fy'+deviceCount+'ownNum" onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);" value="" style="width:50px;"  />';

	var td = tr.insertCell(14);
	td.className=classCss+"odd";
 
	td.innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'deployNum" name="fy'+deviceCount+'deployNum" onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);" value="" style="width:50px;"  />';
 
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


</script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
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
		<input type="text" value="<%=applyInfo.getApplyDate()==null?"":applyInfo.getApplyDate()%>" id="applyDate" name="applyDate" class='input_width' readonly="readonly">
		</input>&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;"
			onmouseover="calDateSelector(applyDate,tributton1);" />
		</td>
    </tr>
</table>
</div>  
<% 
String buttonView = resultMsg.getValue("buttonView"); 
if("true".equals(buttonView)){
%>
<div id="oper_div" align="center">
	<span class="zj"><a href="#" onclick="addLine()"></a></span>
</div>	
<%} %>
	<div style="width:100%;overflow-x:scroll;overflow-y:scroll;"> 			
	<table id="lineTable" width="1400" border="0" cellspacing="0" cellpadding="0"  style="margin-top:2px;" >
    	<tr>
    	    <td class="bt_info_odd" width="20" >选择</td>
    	    <td class="bt_info_even"   width="20">序号</td>
            <td class="bt_info_odd" width="60">  班组  </td>
            <td class="bt_info_even" width="130">  岗位  </td>		
            <td class="bt_info_odd" width="55">计划人数</td>
            <td class="bt_info_even" width="60">其中专业化人数</td>
            <td class="bt_info_odd" width="70">计划进入时间</td>			
            <td class="bt_info_even" width="75">计划离开时间</td> 
            <td class="bt_info_odd" width="75">年龄</td>			
            <td class="bt_info_even" width="75">工作年限</td> 
            <td class="bt_info_odd" width="120">文化程度</td>        
            <td class="bt_info_even" width="50">已申请人数</td>
            <td class="bt_info_odd" width="50"> 尚需人数</td>       
            <td class="bt_info_even" width="50"><font color=red>*</font>自有人数</td>
            <td class="bt_info_odd" width="50"><font color=red>*</font>需调配人数 <input type="hidden" id="equipmentSize" name="equipmentSize" value="<%=beanList.size()%>" /></td>
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
			String ss="fy"+String.valueOf(i)+"deviceUnit";
	  %>
		<tr id="fy<%=i%>trflag">
		
		<td class="<%=className%>odd" ><input type="checkbox" name="fy<%=i%>check" id="fy<%=i%>check"  <%if(applyDetailInfo.getPostNo()!=null){ %> checked="checked" <%} %>/></td>
		<td class="<%=className%>even"><%=i+1 %>&nbsp;&nbsp;<input type="hidden" name="fy<%=i%>postNo" id="fy<%=i%>postNo" value="<%=applyDetailInfo.getPostNo()==null?"":applyDetailInfo.getPostNo()%>"/></td>
		<td class="<%=className%>odd"><input type="hidden" id="fy<%=i%>applyTeam" name="fy<%=i%>applyTeam" value="<%=applyDetailInfo.getApplyTeam()==null?"":applyDetailInfo.getApplyTeam()%>"   readonly="readonly"/>
		<input type="text" id="fy<%=i%>applyTeamname" name="fy<%=i%>applyTeamname" value="<%=applyDetailInfo.getApplyTeamname()==null?"":applyDetailInfo.getApplyTeamname()%>" readonly="readonly" style="width:65px;" />
		</td>
		<td class="<%=className%>even"><input type="hidden" id="fy<%=i%>post" name="fy<%=i%>post" value="<%=applyDetailInfo.getPost()==null?"":applyDetailInfo.getPost()%>" class="input_width" readonly="readonly" />
		<input type="text" id="fy<%=i%>postname" name="fy<%=i%>postname" value="<%=applyDetailInfo.getPostname()==null?"":applyDetailInfo.getPostname()%>" style="width:150px;" readonly="readonly" />
		</td>
		<td class="<%=className%>odd"><input type="text" id="fy<%=i%>peopleNum" name="fy<%=i%>peopleNum" value="<%=applyDetailInfo.getPeopleNum()==null?"":applyDetailInfo.getPeopleNum()%>" style="width:55px;background-color:#DDDDDD;"  readonly="readonly"  /></td>
		<td class="<%=className%>even"><input type="text" id="fy<%=i%>professNum" name="fy<%=i%>professNum" value="<%=applyDetailInfo.getProfessNum()==null?"":applyDetailInfo.getProfessNum()%>" style="width:60px;background-color:#DDDDDD;" readonly="readonly"/></td>
		
		<td class="<%=className%>odd"><input type="text" name="fy<%=i%>planStartDate" id="fy<%=i%>planStartDate"  readonly="readonly" value="<%=applyDetailInfo.getPlanStartDate()==null?"":applyDetailInfo.getPlanStartDate()%>" style="width:75px;"  /></td>
		<td class="<%=className%>even"><input type="text" name="fy<%=i%>planEndDate" id="fy<%=i%>planEndDate"  readonly="readonly" value="<%=applyDetailInfo.getPlanEndDate()==null?"":applyDetailInfo.getPlanEndDate()%>" style="width:75px;"  /></td>
		
		<td class="<%=className%>odd"><code:codeSelect name='<%=("fy"+String.valueOf(i)+"age")%>' option="hrAgeOps" addAll="true" selectedValue='<%=applyDetailInfo.getAge()==null?"":applyDetailInfo.getAge()%>'/></td>
		<td class="<%=className%>even"><code:codeSelect name='<%=("fy"+String.valueOf(i)+"workYears")%>' option="workYearOps" addAll="true" selectedValue='<%=applyDetailInfo.getWorkYears()==null?"":applyDetailInfo.getWorkYears()%>' /></td>
		<td class="<%=className%>odd"><code:codeSelect name='<%=("fy"+String.valueOf(i)+"culture")%>' option="hrDegreeOps" addAll="true" selectedValue='<%=applyDetailInfo.getCulture()==null?"":applyDetailInfo.getCulture()%>'/></td>
			
		<td class="<%=className%>even"><input type="text" value="<%=applyDetailInfo.getZ3()==null?"":applyDetailInfo.getZ3()%>" style="width:50px;background-color:#DDDDDD;"  readonly="readonly" /></td>
		<td class="<%=className%>odd"><input type="text" value=" <%=(Integer.parseInt(applyDetailInfo.getProfessNum()==null?"0":applyDetailInfo.getProfessNum())-Integer.parseInt(applyDetailInfo.getZ3()==null?"0":applyDetailInfo.getZ3()))>0?(Integer.parseInt(applyDetailInfo.getProfessNum())-Integer.parseInt(applyDetailInfo.getZ3())):"0"%>" style="width:50px;background-color:#DDDDDD;" readonly="readonly" /></td>
		<td class="<%=className%>even"><input type="text" maxlength="32" id="fy<%=i%>ownNum" name="fy<%=i%>ownNum" onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);" value="<%=applyDetailInfo.getOwnNum()==null?"":applyDetailInfo.getOwnNum()%>" style="width:50px;"  /></td>
		<td class="<%=className%>odd"><input type="text" maxlength="32" id="fy<%=i%>deployNum" name="fy<%=i%>deployNum" onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);" value="<%=applyDetailInfo.getDeployNum()==null?"":applyDetailInfo.getDeployNum()%>" style="width:50px;"  /></td>
				
		</tr>	
	  <%
		}
	  %>
    </table>	
    <table id="equipmentTableInfo" width="1400" border="0" cellspacing="0"  align="center" cellpadding="0" class="scrolltable">

    </table>
    
	</div>
	<% 
 
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
