<%@page import="com.cnpc.jcdp.webapp.util.ActionUtils"%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.bgp.gms.service.rm.em.pojo.*"%>
<%@ taglib uri="code" prefix="code"%> 
<%@ taglib prefix="auth" uri="auth"%>

<html>
<head>
<%
	String contextPath = request.getContextPath();

	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_id= user.getProjectInfoNo();
	String orgSubjectionId = user.getOrgSubjectionId();
 	String subOrgIDofAffordOrg = user.getSubOrgIDofAffordOrg();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	String update = resultMsg.getValue("update");//update等于空为新增，等于true为修改或调配时查看，等于false为调配审核时查看
	String project_type = resultMsg.getValue("project_type");
	String projectInfoNo_s = resultMsg.getValue("projectInfoNo");  
	if(projectInfoNo_s != null){
		project_id=projectInfoNo_s;
	}
	//处理申请单信息
	BgpProjectHumanRequirement applyInfo = (BgpProjectHumanRequirement) resultMsg
			.getMsgElement("applyInfo").toPojo(
					BgpProjectHumanRequirement.class);

	
	//处理调配单信息
	BgpHumanPrepare prepareMap = (BgpHumanPrepare) resultMsg
			.getMsgElement("prepareMap").toPojo(
					BgpHumanPrepare.class);
	List<MsgElement> list = resultMsg.getMsgElements("detailInfo");
	//岗位列表
	List<BgpHumanPreparePostDetail> beanList=new ArrayList<BgpHumanPreparePostDetail>(0);
	int peopleNum = 0;
	int auditNumber = 0;
	if(list!=null){
		beanList = new ArrayList<BgpHumanPreparePostDetail>(list.size());	
		for (int i = 0; i < list.size(); i++) {
			BgpHumanPreparePostDetail postDetail = (BgpHumanPreparePostDetail) list.get(i).toPojo(
					BgpHumanPreparePostDetail.class);
			beanList.add(postDetail);
			if(postDetail != null){
				if(postDetail.getPeopleNumber() != null) peopleNum += Integer.parseInt(postDetail.getPeopleNumber());
				if(postDetail.getAuditNumber() != null) auditNumber+= Integer.parseInt(postDetail.getAuditNumber());				
			}
			
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
	//班组列表
	List<MsgElement> allTeamList = resultMsg.getMsgElements("teamList");
	//岗位列表
	List<MsgElement> allPostList = resultMsg.getMsgElements("postList");
	//存放岗位与班组的对应
	Map postMsg = new HashMap();
	//班组的号等于岗位的班组号,则拼为map(岗位号,班组号:班组名)的形式
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

	int a;
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
<% 
//初始化下拉岗位列表option
    String apply_str = "<option value="+" "+">请选择</option>";
	if(allTeamList != null){
	for(int m = 0; m < allTeamList.size(); m++){
		MsgElement msg = (MsgElement) allTeamList.get(m);
		Map tempMap = msg.toMap();
		apply_str+="<option value="+tempMap.get("value")+">"+tempMap.get("label")+"</option>";	
	}	
}
%>
<% 
    String spare_str="";
	if(applyInfo.getSpare1()!=null){
		spare_str=applyInfo.getSpare1();
	}
%>
<% 
String spare2="1";
String param2="";
if("3".equals(prepareMap.getFunctionType())){
	spare2="0";
	param2="&spare2=0";
}
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>


<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet"
	type="text/css" />
<script language="JavaScript" type="text/JavaScript"	src="<%=contextPath%>/rm/em/humanRequest/DivHiddenOpen.js"></script>

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
<style>
.SelectMode {
	width: 82%;
	color: red;
}
</style>

<script type="text/javascript">
cruConfig.contextPath='<%=contextPath %>';
//新增班组option
var apply_str="<%=apply_str%>";

var spare_str="<%=spare_str%>";
 
var applypost_str="";

var apppost_str="";

var paramP="project_type=<%=project_type%><%=param2%>"

//得到所有班组
var applyTeamList=jcdpCallService("HumanRequiredSrv","queryApplyTeam",paramP);	

function doPrepare() {
	
//	if(currentCount==0){
//			alert("请调配人员后再点击保存");
//			return ;
//	}
	
	if(checkForm()){
		var form = document.getElementById("CheckForm");	
		form.action = "<%=contextPath%>/rm/em/toSaveHumanPrepare.srq";
		//Ext.MessageBox.wait('请等待','处理中');
	    form.submit();
	    alert('保存成功');
	    newClose();
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

function notNullForTeamCheck(filedName,fieldInfo){

	if(document.getElementById(filedName).value==null||document.getElementById(filedName).value==""){
		return false;
	}else{
		return true;
	}
}

function calNumber(){	
	
	var rowLen = document.getElementById("postDetailSize").value;
	var rowFlag = document.getElementById("deleteRowFlag").value;
	var notCheck = rowFlag.split(",");
	for(var i=0;i<rowLen;i++){

		var post = document.getElementById("fy"+i+"post").value;
		var num=0;
		for(var m=0;m<deviceCount;m++){
			var isCheck=true;
			for(var j=0;notCheck!=""&&j<notCheck.length;j++){
				if(notCheck[j]==m&&notCheck[j]!="") isCheck =false;
			}
			if(isCheck){
				var workPost = document.getElementById("em"+m+"workPost").value;
				if(post == workPost){
					num = num + 1;
				}
			}				
		}	
		document.getElementById("fy"+i+"prepareNumber").value=num;	
	}

}

function checkForm(){	
	
	var checkStr = "";	
	var rowFlag = document.getElementById("deleteRowFlag").value;
	var rowLen = document.getElementById("postDetailSize").value;
	var notCheck = rowFlag.split(",");
	var isRe=true;
	for(var m=0;m<deviceCount;m++){
		var isCheck=true;
		for(var j=0;notCheck!=""&&j<notCheck.length;j++){
			if(notCheck[j]==m&&notCheck[j]!="") isCheck =false;
		}
		if(isCheck){
			if(!notNullForCheck("em"+m+"planStartDate","预计进入项目时间")) return false;
			if(!notNullForCheck("em"+m+"planEndDate","预计离开项目时间")) return false;			
			if(!notNullForTeamCheck("em"+m+"team","班组")){
				document.getElementById("em"+m+"team").style.color="red";
				isRe=false;
			}else{
				document.getElementById("em"+m+"team").style.color="black";
			}
			
			if(!notNullForTeamCheck("em"+m+"workPost","岗位")){
				document.getElementById("em"+m+"workPost").style.color="red";
				isRe=false;
			}else{
				var team = document.getElementById("em"+m+"team").value;
				var workPost = document.getElementById("em"+m+"workPost").value;
				//检查班组岗位是否存在		
				var isExist=false;
				for(var i=0;i<rowLen;i++){
					var applyTeam = document.getElementById("fy"+i+"applyTeam").value;
					var post = document.getElementById("fy"+i+"post").value;
					if(post == workPost && team == applyTeam){
						isExist=true;
						break;
					}
				}
				if(!isExist){
					document.getElementById("em"+m+"team").style.color="red";
					document.getElementById("em"+m+"workPost").style.color="red";
					alert("班组或岗位不存在！");					
					return false;
				}else{
					document.getElementById("em"+m+"team").style.color="black";
					document.getElementById("em"+m+"workPost").style.color="black";
				}				
			}				
		}
		
	}	
	if(!isRe){
		alert("班组或岗位不能为空！");
		return false;
	}
	
	for(var i=0;i<rowLen;i++){
		if(!notNullForCheck("fy"+i+"prepareNumber","调配人数")) return false;	
	}
	for(var i=0;i<rowLen;i++){
		//本次调配人数、岗位编号、岗位名称
		var preNum = document.getElementById("fy"+i+"prepareNumber").value;
		var post = document.getElementById("fy"+i+"post").value;
		var postName = document.getElementById("fy"+i+"postname").value;
		//人员列表		
		//	var rowFlag = document.getElementById("deleteRowFlag").value;
		//	var notCheck=rowFlag.split(",");
		var num=0;
		for(var m=0;m<deviceCount;m++){
			var isCheck=true;
			for(var j=0;notCheck!=""&&j<notCheck.length;j++){
				if(notCheck[j]==m&&notCheck[j]!="") isCheck =false;
			}
			if(isCheck){
				var workPost = document.getElementById("em"+m+"workPost").value;
				if(post == workPost){
					num = num + 1;
				}
			}				
		}	
		if(preNum != num){
			checkStr = checkStr + postName+"岗位的调配人数不一致\n";
		}		
	}
	
	
	if(checkStr != ""){
		if(spare_str=="1"){
			//整建制调配
			if(!window.confirm(checkStr+"是否保存？")) {
				return false;
		 	}else{
		 		return true;
			}	
		}else{
			//非整建制调配要验证班组岗位
			alert(checkStr);	
			return false;
		}
	}else{
		return true;
	}
		
}

function importSerialNumber(){
	var project_types="<%=project_type%>"; 
	var obj="";
	if(project_types == "5000100004000000009"){
		 obj=window.showModalDialog('<%=contextPath%>/rm/em/humanRequest/humanImportFilezh.jsp?project_type=<%=project_type%>',"","dialogHeight:500px;dialogWidth:600px");

	}else{
		
		 obj=window.showModalDialog('<%=contextPath%>/rm/em/humanRequest/humanImportFile.jsp?project_type=<%=project_type%>',"","dialogHeight:500px;dialogWidth:600px");

	}
		//var obj=window.open ('<%=contextPath%>/rm/em/humanRequest/humanImportFile.jsp', 'newwindow', 'height=450, width=600, top=150,left=300, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
	if(obj!="" && obj!=undefined ){		
		var checkStr = obj.split(",");	
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
					var id = document.getElementById("em"+m+"employeeId").value;
					var name = document.getElementById("em"+m+"employeeName").value;
					for(var i=0;i<checkStr.length-1; i++){
						var emplTemp = checkStr[i].split("@");	
						if(id == emplTemp[0]){
							newCheck += i + ",";
							reCheck += emplTemp[1] +",";
							break;
						}						
					}	
				}
			}
			for(var i=0;i<checkStr.length-1; i++){
				newCheck = "," + newCheck;
				if(newCheck.indexOf(","+i+",") == -1){
					var emplTemp = checkStr[i].split("@");	
					var applyTeam = "";
					var applyTeamname = "";
					var post = "";
					var postname = "";
					var planStartDate = "";
					var planEndDate = "";		
					var qufen = "";		
					if(emplTemp[2]!='' && emplTemp[3] != '' ){
						applyTeam = emplTemp[2];
						post = emplTemp[3];
					}	
					if(emplTemp[4]!=''){
						planStartDate = emplTemp[4];
					}
					if(emplTemp[5]!=''){
						planEndDate = emplTemp[5];
					}
					if(emplTemp[6]!=''){
						qufen = emplTemp[6];
					}
					
					addEmployee(applyTeam,applyTeamname,post,postname,emplTemp[0],emplTemp[1],planStartDate,planEndDate,qufen);	
				}					
			}			
		}else{
			for(var i=0;i<checkStr.length-1; i++){
				var emplTemp = checkStr[i].split("@");	
				var applyTeam = "";
				var applyTeamname = "";
				var post = "";
				var postname = "";
				var planStartDate = "";
				var planEndDate = "";		
				var qufen = "";	
				if(emplTemp[2]!='' && emplTemp[3] != '' ){
					applyTeam = emplTemp[2];
					post = emplTemp[3];
				}
				if(emplTemp[4]!=''){
					planStartDate = emplTemp[4];
				}
				if(emplTemp[5]!=''){
					planEndDate = emplTemp[5];
				}
				if(emplTemp[6]!=''){
					qufen = emplTemp[6];
				}
				
				addEmployee(applyTeam,applyTeamname,post,postname,emplTemp[0],emplTemp[1],planStartDate,planEndDate,qufen);	
			}
		}		
				
		if(reCheck != ""){
			reCheck = reCheck.substring(0,reCheck.length-1);
			alert(reCheck+"已调配");
		}		
		
	}
}
function openSearch(rowid){
	
	popWindow('<%=contextPath%>/rm/em/professPrepare/searchHumanList.jsp?project_type=<%=project_type%>&rowid='+rowid,'880:725'); 	
}

function getMessage(arg){
 
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
				 
					var id = document.getElementById("em"+m+"employeeId").value;
					var name = document.getElementById("em"+m+"employeeName").value;
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
					if(rowid == undefined){			
						if(emplTemp[2]!='' && emplTemp[3] != '' ){
							applyTeam = emplTemp[2];
							post = emplTemp[3];
						}		
					}else{	
						applyTeam = document.getElementById("fy"+rowid+"applyTeam").value;
						applyTeamname = document.getElementById("fy"+rowid+"applyTeamname").value;
						post = document.getElementById("fy"+rowid+"post").value;
						postname = document.getElementById("fy"+rowid+"postname").value;
						planStartDate = document.getElementById("fy"+rowid+"planStartDate").value;
						planEndDate = document.getElementById("fy"+rowid+"planEndDate").value;						
					}
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
				if(rowid == undefined){			
					if(emplTemp[2]!='' && emplTemp[3] != '' ){
						applyTeam = emplTemp[2];
						post = emplTemp[3];
					}		
				}else{			
					applyTeam = document.getElementById("fy"+rowid+"applyTeam").value;
					applyTeamname = document.getElementById("fy"+rowid+"applyTeamname").value;
					post = document.getElementById("fy"+rowid+"post").value;
					postname = document.getElementById("fy"+rowid+"postname").value;
					planStartDate = document.getElementById("fy"+rowid+"planStartDate").value;
					planEndDate = document.getElementById("fy"+rowid+"planEndDate").value;
				}
				addEmployee(applyTeam,applyTeamname,post,postname,emplTemp[0],emplTemp[1],planStartDate,planEndDate,emplTemp[2]);	
			}
			
		}		

		if(reCheck != ""){
			reCheck = reCheck.substring(0,reCheck.length-1);
			alert(reCheck+"已调配");
		}else{
			document.getElementById("fy"+rowid+"prepareNumber").value=checkStr.length;
		}
		
	}
	
}

function getApplyTeam( selectValue){

	applypost_str='<option value="">请选择</option>';
 
	for(var i=0;i<applyTeamList.detailInfo.length;i++){
		var templateMap = applyTeamList.detailInfo[i];
		//选择当前班组
		if(templateMap.value == selectValue){
			applypost_str+='<option value="'+templateMap.value+'" selected="selected" >'+templateMap.label+'</option>';			
		}else{
			applypost_str+='<option value="'+templateMap.value+'" >'+templateMap.label+'</option>';
		}
	}

}
//根据岗位值获得下拉框的值
function getPostForList( teams,applyPosts ){

    var applyTeam = "applyTeam="+teams;   
	var applyPost=jcdpCallService("HumanRequiredSrv","queryApplyPostList",applyTeam);	

	apppost_str='<option value="">请选择</option>';
	if(applyPost != null){
		for(var i=0;i<applyPost.detailInfo.length;i++){
			var templateMap = applyPost.detailInfo[i];
			if(templateMap.value == applyPosts){
				apppost_str+='<option value="'+templateMap.value+'" selected="selected">'+templateMap.label+'</option>';
			}else{
				apppost_str+='<option value="'+templateMap.value+'"  >'+templateMap.label+'</option>';
			}
	
		}
	}
}
var currentCount=parseInt('<%=humanList.size()%>');
var deviceCount = parseInt('<%=humanList.size()%>');
//加一行人员需求
function addEmployee(applyTeam,applyTeamname,post,postname,employid,employname,planStartDate,planEndDate,qufen){

	var tr = document.getElementById("employeeTable").insertRow();
	tr.align ="center";
 
 	if(deviceCount % 2 == 1){  
  		tr.className = "odd";
	}else{ 
		tr.className = "even";
	}	
	
	tr.id = "em"+deviceCount+"trflag";
	var startTime = "em"+deviceCount+"planStartDate";
	var endTime = "em"+deviceCount+"planEndDate";
	tr.insertCell().innerHTML = currentCount+1+'<input type="hidden" id="em'+deviceCount+'humanDetailNo" name="em'+deviceCount+'humanDetailNo"  value=""/>';
	
	if(applyTeam == ""){
		tr.insertCell().innerHTML = '<select class="select_width"  id="em'+deviceCount+'team" name="em'+deviceCount+'team" onchange="getApplyPostList('+deviceCount+')"  >'+apply_str+'</select>';
	}else{
		//选择班组值
		getApplyTeam(applyTeam);
		tr.insertCell().innerHTML = '<select id="em'+deviceCount+'team" name="em'+deviceCount+'team"  onchange="getApplyPostList('+deviceCount+')" class="select_width" >'+applypost_str+'</select>';
	}

	if(post == ""){
		tr.insertCell().innerHTML = '<select id="em'+deviceCount+'workPost" name="em'+deviceCount+'workPost" class="select_width" > <option value="">请选择</option> </select>';
	}else{
		//选择岗位值
		getPostForList(applyTeam,post);
		tr.insertCell().innerHTML = '<select id="em'+deviceCount+'workPost" name="em'+deviceCount+'workPost" class="select_width" >'+apppost_str+'</select>';
	}
  
	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="em'+deviceCount+'employeeName" name="em'+deviceCount+'employeeName"  value="'+employname+'" class="input_width" readonly="readonly"/>'+'<input type="hidden" id="em'+deviceCount+'employeeId" name="em'+deviceCount+'employeeId"  value="'+employid+'"/>'+ '<input type="hidden" id="em'+deviceCount+'qufen" name="em'+deviceCount+'qufen"  value="'+qufen+'"/>'+'<input type="hidden" id="em'+deviceCount+'psw" name="em'+deviceCount+'psw"  value="a"/>';
	tr.insertCell().innerHTML = '<input type="text" onpropertychange="calDays('+deviceCount+')"  readonly="readonly" maxlength="32" id="em'+deviceCount+'planStartDate" name="em'+deviceCount+'planStartDate" value="'+planStartDate+'" class="input_width" />'+'<img src="'+'<%=contextPath%>'+'/images/calendar.gif" id="tributton2'+deviceCount+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+"'"+startTime+"'"+',tributton2'+deviceCount+');" />';
	tr.insertCell().innerHTML = '<input type="text" onpropertychange="calDays('+deviceCount+')" readonly="readonly" maxlength="32" id="em'+deviceCount+'planEndDate" name="em'+deviceCount+'planEndDate" value="'+planEndDate+'" class="input_width" />'+'<img src="'+'<%=contextPath%>'+'/images/calendar.gif" id="tributton3'+deviceCount+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+"'"+endTime+"'"+',tributton3'+deviceCount+');" />';
	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="days'+deviceCount+'" name="days'+deviceCount+'"  value="" class="input_width" readonly="readonly"/>';
	//计算预计日期
	calDays(deviceCount);
	tr.insertCell().innerHTML = '<input type="hidden" name="orderDrill" value="' + deviceCount + '"/><img src="'+'<%=contextPath%>'+'/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteDevice(' +deviceCount + ')"/>';

	document.getElementById("equipmentSize").value=deviceCount+1;

	deviceCount+=1;
	currentCount+=1;
}
function calDays(i){
	var startTime = document.getElementById("em"+i+"planStartDate").value;
	var returnTime = document.getElementById("em"+i+"planEndDate").value;
	if(startTime!=null&&startTime!=''&&returnTime!=null&&returnTime!=''){
	var days=(new Date(returnTime.replace(/-/g,'/'))-new Date(startTime.replace(/-/g,'/')))/3600/24/1000;
	if(days<0){
		alert("预计离开项目时间应大于预计进入项目时间");
		return false;
	}else{
		document.getElementById("days"+i).value = days+1;
		return true;
	}
	}
	return true;
}

function deleteDevice(deviceNum){

	var rowDetailId = document.getElementById("hidDetailId").value;
	var employeeIds = document.getElementById("employeeIds").value;
	var qufens = document.getElementById("qufens").value;
 
	var rowDeleteId = document.getElementById("em"+deviceNum+"humanDetailNo").value;
	var rowDeleteEId = document.getElementById("em"+deviceNum+"employeeId").value;
	var qufen = document.getElementById("em"+deviceNum+"qufen").value; 
	
	if(	rowDeleteId!=""&&rowDeleteId!=null){
		rowDetailId = rowDetailId+rowDeleteId+",";
		employeeIds = employeeIds+rowDeleteEId+",";
		qufens = qufens+qufen+",";
		
		document.getElementById("hidDetailId").value = rowDetailId;
		document.getElementById("employeeIds").value = employeeIds;
		document.getElementById("qufens").value = qufens;
	}	

	var rowDevice = document.getElementById("em"+deviceNum+"trflag");
	rowDevice.parentNode.removeChild(rowDevice);
	var rowFlag = document.getElementById("deleteRowFlag").value;
	rowFlag=rowFlag+deviceNum+",";  
	document.getElementById("deleteRowFlag").value = rowFlag;

	currentCount-=1;

	//删除后重新排列序号
	deleteChangeInfoNum('humanDetailNo');

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
			document.getElementById("em"+i+warehouseDetailId).parentNode.innerHTML=num+document.getElementById("em"+i+warehouseDetailId).outerHTML;
			num+=1;
		}
	}	
}

//联动调用函数
function getApplyPostList( id ){

    var applyTeam = "applyTeam="+document.getElementById("em"+id+"team").value;   
	var applyPost=jcdpCallService("HumanRequiredSrv","queryApplyPostList",applyTeam);	

	var selectObj = document.getElementById("em"+id+"workPost");
	document.getElementById("em"+id+"workPost").innerHTML="";
	selectObj.add(new Option('请选择',""),0);
	if(applyPost.detailInfo!=null){
	for(var i=0;i<applyPost.detailInfo.length;i++){
		var templateMap = applyPost.detailInfo[i];
		selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	}
	}
}
function selectMultiPerson(){
	var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectEmployeeMulti.jsp',teamInfo);
	    document.getElementById("noticeUserId").value=teamInfo.fkValue;
	    document.getElementById("noticeUser").value=teamInfo.value;
}
//选择申请人
function selectPerson(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/common/selectEmployee.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
        document.getElementById("preapplicantId").value = teamInfo.fkValue;
        document.getElementById("preapplicantName").value = teamInfo.value;
    }
}
function viewProjectInfo(projectInfoNo){
	showModalDialog("<%=contextPath%>/common/viewProject.srq?projectInfoNo="+projectInfoNo,'','dialogWidth:900px;dialogHeight:500px;status:yes');
}
//复制日期

function copyEsimiDate(){
	
	var infoSize = document.getElementById("equipmentSize").value;
	var deleteInfo = document.getElementById("deleteRowFlag").value;

	var date1 = "";
	var date2 = "";
	for(var i=0;i<infoSize;i++){
		if(!checkIsInArray(deleteInfo,i)){
			if(document.getElementById("em"+i+"planStartDate").value != ""){
				date1=document.getElementById("em"+i+"planStartDate").value;
			}else{
				document.getElementById("em"+i+"planStartDate").value=date1;
			}
			if(document.getElementById("em"+i+"planEndDate").value!=""){
				date2=document.getElementById("em"+i+"planEndDate").value;
			}else{
				document.getElementById("em"+i+"planEndDate").value=date2;
			}
		}
	}
}

function checkIsInArray(deleteInfo,key){
	if(deleteInfo==""){
		return false;
	}else{
		var strs=deleteInfo.split(",");
		for(var i=0;strs!=null&&strs!=undefined&&i<strs.length;i++){
			if(key==strs[i]&&strs[i]!=""){
				return true;
			}
		}
		return false;
	}
}

function hrefParam(){
	var requirementNo=document.getElementById("requirementNo").value;
	
	var querySql = " select t.file_id, t.ucm_id ,t.file_name from bgp_doc_gms_file t      where  t.bsflag='0' and t.project_info_no='<%=project_id%>'  and t.relation_id='"+requirementNo+"' ";
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
	var datas = queryRet.datas;	 
	if(queryRet.returnCode=='0'){
		if(datas != null && datas != ''  ){	 
			for (var i =0;i<datas.length;i++ ){
				 document.getElementById("hrefs"+i).innerText=datas[i].file_name+"    "; 
           	   document.getElementById("hrefs"+i).href="<%=contextPath%>/doc/downloadDocByUcmId.srq?emflag=0&docId="+datas[i].ucm_id;
			}
 
			
		}else{
			  document.getElementById("hrefs").innerText="无下载文件";
			  document.getElementById("hrefs").href="#";
		}
	}
	 
}

function toDownload(){
	var elemIF = document.createElement("iframe");  
    var projectTyp='<%=project_type%>';
	var iName ="人员申请导入模板";  
	iName = encodeURI(iName);
	iName = encodeURI(iName);

	if(projectTyp!="" && projectTyp !="null"){
		if(projectTyp =="5000100004000000006"){  //深海模板
			elemIF.src = "<%=contextPath%>/rm/em/humanRequest/download.jsp?path=/rm/em/humanRequest/importHumanListSh.xls&filename="+iName+".xls";
		}else if (projectTyp =="5000100004000000009"){  // 综合模板
			elemIF.src = "<%=contextPath%>/rm/em/humanRequest/download.jsp?path=/rm/em/humanRequest/importHumanListZh.xls&filename="+iName+".xls";
		}else { //其他类型
			elemIF.src = "<%=contextPath%>/rm/em/humanRequest/download.jsp?path=/rm/em/humanRequest/importHumanListLd.xls&filename="+iName+".xls";
		}
	}
	  
	
	
	elemIF.style.display = "none";  
	document.body.appendChild(elemIF);  
}


</script>
<title>人员调配</title>
</head>
<body style="overflow-y:auto" onload="hrefParam();" >
	<form id="CheckForm" name="CheckForm" action="" method="post" 	enctype="multipart/form-data"   target="list">
	<div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:100%">
		<input type="hidden" name="checkids" id="checkids">
 
		<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height"  
			width="100%">
		<tr>
		<td class="inquire_item6">项目名称：</td>
		<td class="inquire_form6"  clospan="5">
	    <input type="hidden" name="showMessage" value=""/>
		<input type="hidden" name="showMessage2" value=""/>
		<%=applyInfo.getProjectName()==null?"":applyInfo.getProjectName()%>
			<input type="hidden" id="projectInfoNo" name="projectInfoNo"
			value="<%=applyInfo.getProjectInfoNo()==null?"":applyInfo.getProjectInfoNo()%>" />
		<%--
		<input type="text"  unselectable="on"   readonly="readonly" value="<%=applyInfo.getProjectName()==null?"":applyInfo.getProjectName()%>" maxlength="32" id="projectName" name="projectName" class='input_width'></input>--%>
		</td>
		</tr>
			<tr >
			<td class="inquire_item6">申请单号：</td>
			<td class="rtCRUFdValue"><input type="hidden"
				id="inquire_form6" unselectable="on" name="requirementNo"
				value="<%=applyInfo.getRequirementNo()==null?"":applyInfo.getRequirementNo()%>" />
				<input type="text"
				value="<%=applyInfo.getApplyNo()==null?"申请提交后系统自动生成":applyInfo.getApplyNo()%>"
				id="applyNo" name="applyNo"    style="width:210px;" readonly="readonly"></input>
			</td>
			<td class="inquire_item6">申请单位：</td>
			<td class="inquire_form6"><input type="hidden"
				value="<%=applyInfo.getApplicantOrgSubName()==null?"":applyInfo.getApplicantOrgSubName()%>"
				id="applicantOrgSubName" name="applicantOrgSubName"></input> <input
				type="hidden"
				value="<%=applyInfo.getApplyCompanySub()==null?"":applyInfo.getApplyCompanySub()%>"
				id="applyCompanySub" name="applyCompanySub"></input> <input
				type="hidden"
				value="<%=applyInfo.getApplyCompany()==null?"":applyInfo.getApplyCompany()%>"
				id="applyCompany" name="applyCompany"></input> <input type="text"
				unselectable="on"
				value="<%=applyInfo.getApplicantOrgName()==null?"":applyInfo.getApplicantOrgName()%>"
				id="applicantOrgName" name="applicantOrgName"  style="width:210px;"
				readonly="readonly"></input> 
			</td>
 
		  </tr>
		  <tr  >
			<td class="inquire_item6">申请日期：</td>
			<td class="inquire_form6"><input type="text" unselectable="on"
				value="<%=applyInfo.getApplyDate()==null?"":applyInfo.getApplyDate()%>"
				id="applyDate" name="applyDate" style="width:210px;"
				readonly="readonly"></input>
			</td>
			<td class="inquire_item6">申请人：</td>
			<td class="inquire_form6"><input type="hidden" id="applicantId"
				name="applicantId"
				value="<%=applyInfo.getApplicantId()==null?"":applyInfo.getApplicantId()%>" />
				<input type="text" unselectable="on" readonly="readonly"
				value="<%=applyInfo.getApplicantName()==null?"":applyInfo.getApplicantName()%>"
				maxlength="32" id="applicantName" name="applicantName"
					style="width:210px;"></input></td>
				 
		</tr>
		
			<tr  >
				<td class="inquire_item6">调配单号：</td>
				<td class="inquire_form6"><input type="hidden"
					id="preprepareOrgId" name="preprepareOrgId"
					value="<%=prepareMap.getPrepareOrgId()==null?(applyInfo.getApplyCompany()==null?"":applyInfo.getApplyCompany()):prepareMap.getPrepareOrgId()%>" />
					<input type="hidden" id="prefunctionType" unselectable="on"
					name="prefunctionType"
					value="<%=prepareMap.getFunctionType()==null?"":prepareMap.getFunctionType()%>" />
					<input type="hidden" id="preprepareNo" unselectable="on"
					name="preprepareNo"
					value="<%=prepareMap.getPrepareNo()==null?"":prepareMap.getPrepareNo()%>" />
					<input type="text"
					value="<%=prepareMap.getPrepareId()==null?"申请提交后系统自动生成":prepareMap.getPrepareId()%>"
					id="prePrepareId" name="prePrepareId" style="width:210px;"
					readonly="readonly"></input>
				</td>
				<td class="inquire_item6">经办人：</td>
				<td class="inquire_form6"><input type="hidden"
					value="<%=prepareMap.getApplicantId()==null?"":prepareMap.getApplicantId()%>"
					id="preapplicantId" name="preapplicantId"></input> <input
					type="text"
					value="<%=prepareMap.getApplicantName()==null?"":prepareMap.getApplicantName()%>"
					id="preapplicantName" name="preapplicantName" style="width:210px;"
					readonly="readonly"></input> <img
					src="<%=contextPath%>/images/magnifier.gif" width="16" height="16"
					style="cursor: hand;" onclick="selectPerson()" /></td>
				 
			</tr>
			<tr  >
				<td class="inquire_item6">调配日期：</td>
				<td class="inquire_form6"><input type="text" unselectable="on"
					value="<%=prepareMap.getDeployDate()==null?"":prepareMap.getDeployDate()%>"
					id="predeployDate" name="predeployDate" style="width:210px;"
					readonly="readonly"></input>&nbsp;&nbsp;<img
					src="<%=contextPath%>/images/calendar.gif" id="tributton1"
					width="16" height="16" style="cursor: hand;"
					onmouseover="calDateSelector(predeployDate,tributton1);" /></td>
					  
					
				<td class="inquire_item6">备注：</td>
				<td class="inquire_form6"><input type="text" maxlength="50"
					id="prenotes" name="prenotes" style="width:210px;"
					value="<%=prepareMap.getNotes()==null?"":prepareMap.getNotes()%>" />
				</td>
			 
			</tr>
 
		</table>
 
		 
		<table border="0" cellspacing="0" cellpadding="0" class="form_info"
			width="100%" id="equipmentTableButton">
			<tr class="even"> 
				<td align="left"> 下载附件:
				   <a  id="hrefs0" href=""></a>
				     <a  id="hrefs1" href=""></a>
				       <a  id="hrefs2" href=""></a>
				         <a  id="hrefs3" href=""></a>
				           <a  id="hrefs4" href=""></a>
				           
				</td> 
				<td align="right">
					<input name="Submit" type="hidden" class="iButton2"
					onClick="openSearch()" value="申请队人员调配" />   &nbsp;&nbsp;
					<auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="下载人员申请模板"></auth:ListButton>
					  <auth:ListButton functionId="" css="dr" event="onclick='importSerialNumber()'" title="导入信息"></auth:ListButton>
					  <auth:ListButton functionId="" css="jd" event="onclick='calNumber()'" title="统计计算"></auth:ListButton>
					</td>
			</tr>
		</table>
	<div> 			
	     <table id="equipmentTableInfo" width="100%" border="0" cellspacing="0" cellpadding="0"  style="margin-top:2px;" >
			<tr>
				<TD class="bt_info_odd" width="2%">序号</TD>
				<TD class="bt_info_even" width="5%">班组</TD>
				<TD class="bt_info_odd" width="9%">岗位</TD>
				<TD class="bt_info_even" width="3%">本次申请人数</TD>
				   <% 
			        if(!"5000100004000000009".equals(project_type)){
						  %>
				<TD class="bt_info_odd" width="3%">其中临时工人数</TD>
				
				  <%
					}
				  %>
				<TD class="bt_info_even" width="3%">需调配人数</TD>
				<TD class="bt_info_odd" width="3%">已调配人数</TD>
				<TD class="bt_info_even" width="3%"><font color=red>*</font>&nbsp;本次调配人数</TD>
				<TD class="bt_info_odd" width="7%">年龄</TD>
				<TD class="bt_info_even" width="7%">工作年限</TD>
				<TD class="bt_info_odd" width="7%">文化程度</TD>
				<TD class="bt_info_even" width="6%">预计进入项目时间</TD>
				<TD class="bt_info_odd" width="6%">预计离开项目时间</TD>
				<TD class="bt_info_even" width="3%">预计天数</TD>
				<TD class="bt_info_odd" width="4%">备注</TD>
				<TD class="bt_info_even" width="2%">调配人员<input type="hidden"
					name="postDetailSize" id="postDetailSize"
					value="<%=beanList.size()%>"></TD>
			</tr>
			<%
		for (int i = 0; i < beanList.size(); i++) {
			String className = "";
			if (i % 2 == 0) {
				className = "even";
			} else {
				className = "odd";
			}
			BgpHumanPreparePostDetail applyDetailInfo = beanList.get(i);
			String ss="fy"+String.valueOf(i)+"deviceUnit";
	%>
			<tr class="<%=className%>" id="fy<%=i%>trflag">
				<td><%=i + 1%><input type="hidden"
					id="fy<%=i%>preparePostDetailNo" name="fy<%=i%>preparePostDetailNo"
					value="<%=applyDetailInfo.getPreparePostDetailNo()==null?"":applyDetailInfo.getPreparePostDetailNo()%>" />
				</td>
				<td><input type="hidden" maxlength="32"
					name="fy<%=i%>applyTeam" id="fy<%=i%>applyTeam"
					value="<%=applyDetailInfo.getApplyTeam()==null?"":applyDetailInfo.getApplyTeam()%>" />
					<input type="text" maxlength="32" name="fy<%=i%>applyTeamname"
					id="fy<%=i%>applyTeamname"
					value="<%=applyDetailInfo.getApplyTeamname()==null?"":applyDetailInfo.getApplyTeamname()%>"
					readonly="readonly" class="input_width" /></td>
				<td><input type="hidden" maxlength="32" name="fy<%=i%>post"
					id="fy<%=i%>post"
					value="<%=applyDetailInfo.getPost()==null?"":applyDetailInfo.getPost()%>"
					class="input_width" /> <input type="text" maxlength="32"
					name="fy<%=i%>postname" id="fy<%=i%>postname"
					value="<%=applyDetailInfo.getPostname()==null?"":applyDetailInfo.getPostname()%>"
					readonly="readonly" class="input_width" /></td>
				<td><input type="text" maxlength="32"
					name="fy<%=i%>peopleNumber" id="fy<%=i%>peopleNumber"
					value="<%=applyDetailInfo.getPeopleNumber()==null?"":applyDetailInfo.getPeopleNumber()%>"
					class="input_width" readonly />
				</td>
				 <% 
			        if(!"5000100004000000009".equals(project_type)){
						  %>
							<td><input type="text" maxlength="32"
								name="fy<%=i%>auditNumber" id="fy<%=i%>auditNumber"
								value="<%=applyDetailInfo.getAuditNumber()==null?"":applyDetailInfo.getAuditNumber()%>"
								class="input_width" readonly />
							</td>
							<td><input type="text" maxlength="32" name="fy<%=i%>alNum"
								id="fy<%=i%>alNum"
								value="<%=Integer.parseInt(applyDetailInfo.getPeopleNumber()==null?"0":applyDetailInfo.getPeopleNumber())-Integer.parseInt(applyDetailInfo.getAuditNumber()==null?"0":applyDetailInfo.getAuditNumber())%>"
								class="input_width" readonly />
							</td>
							<td><input type="text" maxlength="32"
								value="<%=applyDetailInfo.getPreNum()==null?"":applyDetailInfo.getPreNum()%>"
								class="input_width" readonly />
							</td>
				  <%
					}else{
				  %>
						<td><input type="text" maxlength="32" name="fy<%=i%>alNum"
							id="fy<%=i%>alNum"
							value="<%=Integer.parseInt(applyDetailInfo.getPeopleNumber()==null?"0":applyDetailInfo.getPeopleNumber())-Integer.parseInt(applyDetailInfo.getPrepareNumber()==null?"0":applyDetailInfo.getPrepareNumber())%>"
							class="input_width" readonly />
						</td>

						<td><input type="text" maxlength="32"
							value="<%=applyDetailInfo.getPrepareNumber()==null?"0":applyDetailInfo.getPrepareNumber()%>"
							class="input_width" readonly />
						</td>
				  <%		
					}
				  %>
				  
				

				<%  
			int preNum = 0; 
				if(Integer.parseInt(applyDetailInfo.getPeopleNumber()==null?"0":applyDetailInfo.getPeopleNumber())>=Integer.parseInt(applyDetailInfo.getPreNum()==null?"0":applyDetailInfo.getPreNum())){
					preNum = Integer.parseInt(applyDetailInfo.getPeopleNumber()==null?"0":applyDetailInfo.getPeopleNumber())-Integer.parseInt(applyDetailInfo.getPreNum()==null?"0":applyDetailInfo.getPreNum());
				}
		%>
				<td><input type="text" maxlength="32"
					name="fy<%=i%>prepareNumber" id="fy<%=i%>prepareNumber"
					value="<%=applyDetailInfo.getPrepareNumber()==null?"0":applyDetailInfo.getPrepareNumber()%>"
					onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);"
					class="input_width" />
				</td>
				<td><code:codeSelect name='<%=("fy"+String.valueOf(i)+"age")%>'
						option="hrAgeOps" addAll="true"
						selectedValue='<%=applyDetailInfo.getAge()==null?"":applyDetailInfo.getAge()%>'
						cssClass="input_width" />&nbsp;</td>
				<td><code:codeSelect
						name='<%=("fy"+String.valueOf(i)+"workYears")%>'
						option="workYearOps" addAll="true"
						selectedValue='<%=applyDetailInfo.getWorkYears()==null?"":applyDetailInfo.getWorkYears()%>'
						cssClass="input_width" />&nbsp;</td>
				<td><code:codeSelect
						name='<%=("fy"+String.valueOf(i)+"culture")%>'
						option="hrDegreeOps" addAll="true"
						selectedValue='<%=applyDetailInfo.getCulture()==null?"":applyDetailInfo.getCulture()%>'
						cssClass="input_width" />&nbsp;</td>
							
				<td><input type="text" name="fy<%=i%>planStartDate"
					id="fy<%=i%>planStartDate" readonly="readonly"
					value="<%=applyDetailInfo.getPlanStartDate()==null?"":applyDetailInfo.getPlanStartDate()%>"
					class="input_width" />&nbsp;</td>
				<td><input type="text" name="fy<%=i%>planEndDate"
					id="fy<%=i%>planEndDate" readonly="readonly"
					value="<%=applyDetailInfo.getPlanEndDate()==null?"":applyDetailInfo.getPlanEndDate()%>"
					class="input_width" />&nbsp;</td>
				<td><input type="text" name="fy<%=i%>spare1"
					id="fy<%=i%>spare1" readonly="readonly"
					value="<%=applyDetailInfo.getSpare1()==null?"":applyDetailInfo.getSpare1()%>"
					class="input_width" />&nbsp;</td>
				<td><input type="text" maxlength="32" name="fy<%=i%>notes"
					value="<%=applyDetailInfo.getNotes()==null?"":applyDetailInfo.getNotes()%>"
					class="input_width"   />
				</td>
				<td><a href="javascript:openSearch('<%=i%>')">选择</a>
				</td>
			</tr>
			<%
		}
	%>
		</table>
		 
	 </div>
		<% if("1".equals(prepareMap.getFunctionType())){%>
		<div align="right">
			<% if(applyInfo.getSpare1()!=null&&"1".equals(applyInfo.getSpare1())){%>
			<font color="red" />成建制调配</font/>
			<%}else{ %>
			<font color="red" />人员需求总数：<%=peopleNum %></font/> &nbsp;&nbsp;&nbsp;&nbsp;
			<%} %>
		</div>
		<%}%>
		<table border="0" cellspacing="0" cellpadding="0" class="form_info"
			width="100%" id="equipmentTableButton">
			<tr class="even">
				<td align="left"><input name="Submit1" type="hidden"
					class="iButton2" onClick="copyEsimiDate();" value="复制日期" />
				 
				</td>
			</tr>
		</table>
					
	<div> 	
	 
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:2px;" id="employeeTable">
			<tr  >
				<TD class="bt_info_odd" width="3%">序号</TD>
				<TD class="bt_info_even" width="15%"><font color=red>*</font>&nbsp;班组</TD>
				<TD class="bt_info_odd" width="17%"><font color=red>*</font>&nbsp;岗位</TD>
				<TD class="bt_info_even" width="8%"><font color=red>*</font>&nbsp;姓名</TD>
				<TD class="bt_info_odd" width="8%"><font color=red>*</font>&nbsp;预计进入项目时间</TD>
				<TD class="bt_info_even" width="8%"><font color=red>*</font>&nbsp;预计离开项目时间
				</TD>
				<TD class="bt_info_odd" width="6%">&nbsp;预计天数</TD>
				<TD class="bt_info_even" width="3%">操作<input type="hidden"
					id="equipmentSize" name="equipmentSize"
					value="<%=humanList.size()%>" /> <input type="hidden"
					id="hidDetailId" name="hidDetailId" value="" /> <input
					type="hidden" id="deleteRowFlag" name="deleteRowFlag" value="" />
					<input type="hidden" id="employeeIds" name="employeeIds" value="" />  
					<input type="hidden" id="qufens" name="qufens" value="" />  
				</TD>
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
			<tr class="<%=className%>" id="em<%=j%>trflag">
				<td><%=j + 1%><input type="hidden" id="em<%=j%>humanDetailNo"
					name="em<%=j%>humanDetailNo"
					value="<%=humanInfo.getHumanDetailNo() ==null?"":humanInfo.getHumanDetailNo()%>" />
				
				</td>
				<td><input type="hidden" maxlength="32" name="em<%=j%>team"
					id="em<%=j%>team"
					value="<%=humanInfo.getTeam()==null?"":humanInfo.getTeam()%>" /> <input
					type="text" maxlength="32" name="em<%=j%>teamName"
					id="em<%=j%>teamName"
					value="<%=humanInfo.getTeamName()==null?"":humanInfo.getTeamName()%>"
					readonly="readonly" class="input_width" /></td>
				<td><input type="hidden" maxlength="32" name="em<%=j%>workPost"
					id="em<%=j%>workPost"
					value="<%=humanInfo.getWorkPost()==null?"":humanInfo.getWorkPost()%>"
					class="input_width" /> <input type="text" maxlength="32"
					name="em<%=j%>workPostName" id="em<%=j%>workPostName"
					value="<%=humanInfo.getWorkPostName()==null?"":humanInfo.getWorkPostName()%>"
					readonly="readonly" class="input_width" /></td>
				<td><input type="hidden" maxlength="32"
					name="em<%=j%>employeeId"
					value="<%=humanInfo.getEmployeeId()==null?"":humanInfo.getEmployeeId()%>"
					class="input_width" /><input type="hidden" id="em<%=j%>qufen"
					name="em<%=j%>qufen"
						value="<%=humanInfo.getQufen() ==null?"2":humanInfo.getQufen()%>" /> 
				<input type="hidden" id="em<%=j%>psw"	 name="em<%=j%>psw"	value="u" /> <input type="text" maxlength="32"
					name="em<%=j%>employeeName"
					value="<%=humanInfo.getEmployeeName()==null?"":humanInfo.getEmployeeName()%>"
					readonly="readonly" class="input_width" /></td>

				<td><input type="text" name="em<%=j%>planStartDate"
					id="em<%=j%>planStartDate" readonly="readonly"
					value="<%=humanInfo.getPlanStartDate()==null?"":humanInfo.getPlanStartDate()%>"
					onpropertychange="calDays('<%=j %>')" class="input_width" /><img
					src="<%=contextPath%>/images/calendar.gif" id="tributton2<%=j%>"
					width="16" height="16" style="cursor: hand;"
					onmouseover="calDateSelector('em<%=j%>planStartDate',tributton2<%=j%>);" />
				</td>
				<td><input type="text" name="em<%=j%>planEndDate"
					id="em<%=j%>planEndDate" readonly="readonly"
					value="<%=humanInfo.getPlanEndDate()==null?"":humanInfo.getPlanEndDate()%>"
					onpropertychange="calDays('<%=j %>')" class="input_width" /><img
					src="<%=contextPath%>/images/calendar.gif" id="tributton3<%=j%>"
					width="16" height="16" style="cursor: hand;"
					onmouseover="calDateSelector('em<%=j%>planEndDate',tributton3<%=j%>);" />
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
		<br>
	 
		<table border="0" cellspacing="0" cellpadding="0" class="form_info"
			width="100%" id="equipmentTableButton">
			<tr class="even"  style="height:10px;">
				<td align="center">
				<span  class="bc_btn"><a href="#" onclick="doPrepare();"></a></span>
				  <span class="gb_btn"><a href="#" onclick="newClose();"></a></span>
				</td>
			</tr>
		</table>
		</div>
	</form>
</body>
</html>