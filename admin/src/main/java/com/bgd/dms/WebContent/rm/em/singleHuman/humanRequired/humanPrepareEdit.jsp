<%@page import="com.cnpc.jcdp.webapp.util.ActionUtils"%>
<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.bgp.gms.service.rm.em.pojo.*"%>
<%@ taglib uri="code" prefix="code"%> 

<html>
<head>
<%
	String contextPath = request.getContextPath();

	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubjectionId = user.getOrgSubjectionId();
 	String subOrgIDofAffordOrg = user.getSubOrgIDofAffordOrg();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	String update = resultMsg.getValue("update");//update���ڿ�Ϊ����������trueΪ�޸Ļ����ʱ�鿴������falseΪ�������ʱ�鿴
	String auditStatus = resultMsg.getValue("auditStatus");//0���е���  1������
	//������
	List<MsgElement> listFile =new ArrayList<MsgElement>();
	if(resultMsg.getMsgElement("fileInfo")!=null){
		listFile = resultMsg.getMsgElements("fileInfo");
	}
	//�������뵥��Ϣ
	BgpProjectHumanRequirement applyInfo = (BgpProjectHumanRequirement) resultMsg
			.getMsgElement("applyInfo").toPojo(
					BgpProjectHumanRequirement.class);

	
	//������䵥��Ϣ
	BgpHumanPrepare prepareMap = (BgpHumanPrepare) resultMsg
			.getMsgElement("prepareMap").toPojo(
					BgpHumanPrepare.class);
	List<MsgElement> list = resultMsg.getMsgElements("detailInfo");
	//��λ�б�
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

	//���������Ϣ
	List<MsgElement> examineInfoList=resultMsg.getMsgElements("listProcHistory");
	
    //������Ա��Ϣ
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
	param2="spare2=0";
}
%>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">


<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet"
	type="text/css" />
<script language="JavaScript" type="text/JavaScript"
	src="<%=contextPath%>/js/bgpmcs/DivHiddenOpen.js"></script>

<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>

<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/extjs/ext-all.js"></script>

<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_search.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<style>
.SelectMode {
	width: 82%;
	color: red;
}
</style>

<script type="text/javascript">
cruConfig.contextPath='<%=contextPath %>';
//��������option
var apply_str="<%=apply_str%>";

var spare_str="<%=spare_str%>";

var applypost_str="";

var apppost_str="";



//�õ����а���
var applyTeamList=jcdpCallService("HumanRequiredSrv","queryApplyTeam","param2");	

function doPrepare() {
	
	if(currentCount==0){
			alert("�������Ա���ٵ������");
			return ;
	}
	
	if(checkForm()){
		var form = document.getElementById("CheckForm");	

	if(document.getElementById("prefunctionType").value == '2'){
		form.action = "<%=contextPath%>/rm/em/toSaveReliefPrepare.srq";		
	}else if(document.getElementById("prefunctionType").value == '1'){		
		form.action = "<%=contextPath%>/rm/em/toSaveHumanPrepare.srq";
	}else{
		form.action = "<%=contextPath%>/rm/em/toSaveProfessionPrepare.srq";
	}
		Ext.MessageBox.wait('��ȴ�','������');
	    form.submit();
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

function notNullForTeamCheck(filedName,fieldInfo){

	if(document.getElementById(filedName).value==null||document.getElementById(filedName).value==""){
		return false;
	}else{
		return true;
	}
}

function checkForm(){	
	
	var checkStr = "";
//	var rowLen = document.getElementById("postDetailSize").value;
	
//	for(var i=0;i<rowLen;i++){
//		if(!notNullForCheck("fy"+i+"prepareNumber","��������")) return false;	
//	}
	//��Ա�б�		
	var rowFlag = document.getElementById("deleteRowFlag").value;
	var notCheck = rowFlag.split(",");
	var isRe=true;
	for(var m=0;m<deviceCount;m++){
		var isCheck=true;
		for(var j=0;notCheck!=""&&j<notCheck.length;j++){
			if(notCheck[j]==m&&notCheck[j]!="") isCheck =false;
		}
		if(isCheck){
			if(!notNullForCheck("em"+m+"planStartDate","Ԥ�ƽ�����Ŀʱ��")) return false;
			if(!notNullForCheck("em"+m+"planEndDate","Ԥ���뿪��Ŀʱ��")) return false;			
			if(!notNullForTeamCheck("em"+m+"team","����")){
				document.getElementById("em"+m+"team").style.color="red";
				isRe=false;
			}else{
				document.getElementById("em"+m+"team").style.color="black";
			}
			if(!notNullForTeamCheck("em"+m+"workPost","��λ")){
				document.getElementById("em"+m+"workPost").style.color="red";
				isRe=false;
			}else{
				document.getElementById("em"+m+"workPost").style.color="black";
			}								
		}
		
	}	
	if(!isRe){
		alert("������λ����Ϊ�գ�");
		return false;
	}

	if(document.getElementById("prefunctionType").value == '1'){
		var rowLen = document.getElementById("postDetailSize").value;
		
		for(var i=0;i<rowLen;i++){
			if(!notNullForCheck("fy"+i+"prepareNumber","��������")) return false;	
		}
		for(var i=0;i<rowLen;i++){
			//���ε�����������λ��š���λ����
			var preNum = document.getElementById("fy"+i+"prepareNumber").value;
			var post = document.getElementById("fy"+i+"post").value;
			var postName = document.getElementById("fy"+i+"postname").value;
			//��Ա�б�		
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
				checkStr = checkStr + postName+"��λ�ĵ���������һ��\n";
			}		
		}
	}else if(false){
		for(var i=0;i<rowLen;i++){
			//���ε�����������λ��š���λ����
			var preNum = document.getElementById("fy"+i+"prepareNumber").value;
			var post = document.getElementById("fy"+i+"post").value;
			var postName = document.getElementById("fy"+i+"postname").value;
			var flag = document.getElementById("fy"+i+"flag").value;
			if(flag == "true"){
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
					checkStr = checkStr + postName+"��λ�ĵ���������һ��\n";
				}	
			}
		}
		var eRowLen = document.getElementById("equipmentESize").value;
		for(var i=0;i<eRowLen;i++){
			//���ε�����������λ��š���λ����
			var preNum = document.getElementById("hu"+i+"prepareNumber").value;
			var post = document.getElementById("hu"+i+"post").value;
			var postName = document.getElementById("hu"+i+"postname").value;
			var flag = document.getElementById("hu"+i+"flag").value;

			if(flag == "true"){
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
					checkStr = checkStr + postName+"��λ�ĵ���������һ��\n";
				}	
			}
		}
	}
	 
	if(checkStr != ""){
		if(spare_str=="1"){
			//�����Ƶ���
			if(!window.confirm(checkStr+"�Ƿ񱣴棿")) {
				return false;
		 	}else{
		 		return true;
			}	
		}else{
			//�������Ƶ���Ҫ��֤�����λ
			alert(checkStr);	
			return false;
		}
	}else{
		return true;
	}
		
}

function importSerialNumber(){
	var obj=window.showModalDialog('<%=contextPath%>/rm/em/humanPlant/humanPrepare/humanImportFile.jsp',"","dialogHeight:600px;dialogWidth:800px");
	if(obj!="" && obj!=undefined ){		
		var checkStr = obj.split(",");	
		var reCheck = "";	
		var newCheck = "";
		if(deviceCount>0){
			var checkNum = deviceCount;
			//��Ա�б�		
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
					addEmployee(applyTeam,applyTeamname,post,postname,emplTemp[0],emplTemp[1],planStartDate,planEndDate);	
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
				addEmployee(applyTeam,applyTeamname,post,postname,emplTemp[0],emplTemp[1],planStartDate,planEndDate);	
			}
		}		
				
		if(reCheck != ""){
			reCheck = reCheck.substring(0,reCheck.length-1);
			alert(reCheck+"�ѵ���");
		}
		
		
	}
}

function openSearch(rowid){

	var humanInfo={
			flag:"",
			applyCompanySub:"",
			applyCompany:"",
			postname:"",
			applicantOrgSubName:""
	};
	if(rowid == undefined){
		humanInfo.flag="true";
		humanInfo.applyCompany = document.getElementById("applyCompany").value;
		humanInfo.applyCompanySub = document.getElementById("applyCompanySub").value;
		humanInfo.applicantOrgSubName = document.getElementById("applicantOrgSubName").value;
	}else{
		humanInfo.flag="false";
		if(rowid.substring(0,1)=="h"){
			humanInfo.postname = document.getElementById(rowid+"postname").value;
		}else{
			humanInfo.postname = document.getElementById("fy"+rowid+"postname").value;
		}		
	}
	var result = showModalDialog('<%=contextPath%>/rm/em/humanRequest/searchHumanInfo.jsp',humanInfo,'dialogWidth:900px;dialogHeight:500px;status:yes'); 	
	if(result!="" && result!=undefined ){
				
		var checkStr = result.split(",");	
		var reCheck = "";	
		var newCheck = "";
		if(deviceCount>0){
			var checkNum = deviceCount;
			//��Ա�б�		
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
						var emplTemp = checkStr[i].split("-");	
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
						if(rowid.substring(0,1)=="h"){
							applyTeam = document.getElementById(rowid+"applyTeam").value;
							applyTeamname = document.getElementById(rowid+"applyTeamname").value;
							post = document.getElementById(rowid+"post").value;
							postname = document.getElementById(rowid+"postname").value;
							planStartDate = document.getElementById(rowid+"planStartDate").value;
							planEndDate = document.getElementById(rowid+"planEndDate").value;
						}else{
							applyTeam = document.getElementById("fy"+rowid+"applyTeam").value;
							applyTeamname = document.getElementById("fy"+rowid+"applyTeamname").value;
							post = document.getElementById("fy"+rowid+"post").value;
							postname = document.getElementById("fy"+rowid+"postname").value;
							planStartDate = document.getElementById("fy"+rowid+"planStartDate").value;
							planEndDate = document.getElementById("fy"+rowid+"planEndDate").value;
						}								
					}
					addEmployee(applyTeam,applyTeamname,post,postname,emplTemp[0],emplTemp[1],planStartDate,planEndDate);	
				}					
			}			
		}else{
			for(var i=0;i<checkStr.length-1; i++){
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
					if(rowid.substring(0,1)=="h"){
						applyTeam = document.getElementById(rowid+"applyTeam").value;
						applyTeamname = document.getElementById(rowid+"applyTeamname").value;
						post = document.getElementById(rowid+"post").value;
						postname = document.getElementById(rowid+"postname").value;
						planStartDate = document.getElementById(rowid+"planStartDate").value;
						planEndDate = document.getElementById(rowid+"planEndDate").value;
					}else{
						applyTeam = document.getElementById("fy"+rowid+"applyTeam").value;
						applyTeamname = document.getElementById("fy"+rowid+"applyTeamname").value;
						post = document.getElementById("fy"+rowid+"post").value;
						postname = document.getElementById("fy"+rowid+"postname").value;
						planStartDate = document.getElementById("fy"+rowid+"planStartDate").value;
						planEndDate = document.getElementById("fy"+rowid+"planEndDate").value;
					}
				}
				addEmployee(applyTeam,applyTeamname,post,postname,emplTemp[0],emplTemp[1],planStartDate,planEndDate);	
			}
		}		
				
		if(reCheck != ""){
			reCheck = reCheck.substring(0,reCheck.length-1);
			alert(reCheck+"�ѵ���");
		}
		
	}
	
}

function getApplyTeam( selectValue){

	applypost_str='<option value="">��ѡ��</option>';
	for(var i=0;i<applyTeamList.detailInfo.length;i++){
		var templateMap = applyTeamList.detailInfo[i];
		//ѡ��ǰ����
		if(templateMap.value == selectValue){
			applypost_str+='<option value="'+templateMap.value+'" selected="selected" >'+templateMap.label+'</option>';			
		}else{
			applypost_str+='<option value="'+templateMap.value+'" >'+templateMap.label+'</option>';
		}
	}

}
//���ݸ�λֵ����������ֵ
function getPostForList( teams,applyPosts ){

    var applyTeam = "applyTeam="+teams;   
	var applyPost=jcdpCallService("HumanRequiredSrv","queryApplyPostList",applyTeam);	

	apppost_str='<option value="">��ѡ��</option>';
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
//��һ����Ա����
function addEmployee(applyTeam,applyTeamname,post,postname,employid,employname,planStartDate,planEndDate){

	var tr = document.getElementById("employeeTable").insertRow();
	tr.align ="center";
	if(deviceCount%2==0) trClassName = "even";
	else trClassName = "odd";
	tr.id = "em"+deviceCount+"trflag";
	
	var startTime = "em"+deviceCount+"planStartDate";
	var endTime = "em"+deviceCount+"planEndDate";
		
	tr.insertCell().innerHTML = currentCount+1+'<input type="hidden" id="em'+deviceCount+'humanDetailNo" name="em'+deviceCount+'humanDetailNo"  value=""/>';
	
	if(applyTeam == ""){
		tr.insertCell().innerHTML = '<select class="select_width"  id="em'+deviceCount+'team" name="em'+deviceCount+'team" onchange="getApplyPostList('+deviceCount+')"  >'+apply_str+'</select>';
	}else{
		//ѡ�����ֵ
		getApplyTeam(applyTeam);
		tr.insertCell().innerHTML = '<select id="em'+deviceCount+'team" name="em'+deviceCount+'team"  onchange="getApplyPostList('+deviceCount+')" class="select_width" >'+applypost_str+'</select>';
	}

	if(post == ""){
		tr.insertCell().innerHTML = '<select id="em'+deviceCount+'workPost" name="em'+deviceCount+'workPost" class="select_width" > <option value="">��ѡ��</option> </select>';
	}else{
		//ѡ���λֵ
		getPostForList(applyTeam,post);
		tr.insertCell().innerHTML = '<select id="em'+deviceCount+'workPost" name="em'+deviceCount+'workPost" class="select_width" >'+apppost_str+'</select>';
	}

	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="em'+deviceCount+'employeeName" name="em'+deviceCount+'employeeName"  value="'+employname+'" class="input_width" readonly="readonly"/>'+'<input type="hidden" id="em'+deviceCount+'employeeId" name="em'+deviceCount+'employeeId"  value="'+employid+'"/>';
	tr.insertCell().innerHTML = '<input type="text" onpropertychange="calDays('+deviceCount+')"  readonly="readonly" maxlength="32" id="em'+deviceCount+'planStartDate" name="em'+deviceCount+'planStartDate" value="'+planStartDate+'" class="input_width" />'+'&nbsp;&nbsp;<img src="'+'<%=contextPath%>'+'/images/calendar.gif" id="tributton2'+deviceCount+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="dateSelector('+"'"+startTime+"'"+',tributton2'+deviceCount+');" />';
	tr.insertCell().innerHTML = '<input type="text" onpropertychange="calDays('+deviceCount+')" readonly="readonly" maxlength="32" id="em'+deviceCount+'planEndDate" name="em'+deviceCount+'planEndDate" value="'+planEndDate+'" class="input_width" />'+'&nbsp;&nbsp;<img src="'+'<%=contextPath%>'+'/images/calendar.gif" id="tributton3'+deviceCount+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="dateSelector('+"'"+endTime+"'"+',tributton3'+deviceCount+');" />';
	tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="days'+deviceCount+'" name="days'+deviceCount+'"  value="" class="input_width" readonly="readonly"/>';
	//����Ԥ������
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
		alert("Ԥ���뿪��Ŀʱ��Ӧ����Ԥ�ƽ�����Ŀʱ��");
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
	var rowDeleteId = document.getElementById("em"+deviceNum+"humanDetailNo").value;

	if(	rowDeleteId!=""&&rowDeleteId!=null){
		rowDetailId = rowDetailId+rowDeleteId+",";
		document.getElementById("hidDetailId").value = rowDetailId;
	}	

	var rowDevice = document.getElementById("em"+deviceNum+"trflag");
	rowDevice.parentNode.removeChild(rowDevice);
	var rowFlag = document.getElementById("deleteRowFlag").value;
	rowFlag=rowFlag+deviceNum+",";
	document.getElementById("deleteRowFlag").value = rowFlag;

	currentCount-=1;

	//ɾ���������������
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

//�������ú���
function getApplyPostList( id ){

    var applyTeam = "applyTeam="+document.getElementById("em"+id+"team").value;   
	var applyPost=jcdpCallService("HumanRequiredSrv","queryApplyPostList",applyTeam);	

	var selectObj = document.getElementById("em"+id+"workPost");
	document.getElementById("em"+id+"workPost").innerHTML="";
	selectObj.add(new Option('��ѡ��',""),0);
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
//ѡ��������
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
//��������

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
</script>
<title>��Ա����</title>
</head>
<body>
	<form id="CheckForm" name="CheckForm" action="" method="post"
		enctype="multipart/form-data">
		<input type="hidden" name="checkids" id="checkids">
 
		<table border="0" cellpadding="0" cellspacing="0" class="form_info"
			width="100%">
			<tr class="even">
				<td align="center" colspan="4">������Ϣ</td>
			</tr>
			<tr class="even">
				<td class="rtCRUFdName">���䵥�ţ�</td>
				<td class="rtCRUFdValue"><input type="hidden"
					id="preprepareOrgId" name="preprepareOrgId"
					value="<%=prepareMap.getPrepareOrgId()==null?(applyInfo.getApplyCompany()==null?"":applyInfo.getApplyCompany()):prepareMap.getPrepareOrgId()%>" />
					<input type="hidden" id="prefunctionType" unselectable="on"
					name="prefunctionType"
					value="<%=prepareMap.getFunctionType()==null?"":prepareMap.getFunctionType()%>" />
					<input type="hidden" id="preprepareNo" unselectable="on"
					name="preprepareNo"
					value="<%=prepareMap.getPrepareNo()==null?"":prepareMap.getPrepareNo()%>" />
					<input type="text"
					value="<%=prepareMap.getPrepareId()==null?"�����ύ��ϵͳ�Զ�����":prepareMap.getPrepareId()%>"
					id="prePrepareId" name="prePrepareId" class='input_width'
					readonly="readonly"></input>
				</td>
				<td class="rtCRUFdName">�����ˣ�</td>
				<td class="rtCRUFdValue"><input type="hidden"
					value="<%=prepareMap.getApplicantId()==null?"":prepareMap.getApplicantId()%>"
					id="preapplicantId" name="preapplicantId"></input> <input
					type="text"
					value="<%=prepareMap.getApplicantName()==null?"":prepareMap.getApplicantName()%>"
					id="preapplicantName" name="preapplicantName" class='input_width'
					readonly="readonly"></input> <img
					src="<%=contextPath%>/images/magnifier.gif" width="16" height="16"
					style="cursor: hand;" onclick="selectPerson()" /></td>
			</tr>
			<tr class="even">
				<td class="rtCRUFdName">�������ڣ�</td>
				<td class="rtCRUFdValue"><input type="text" unselectable="on"
					value="<%=prepareMap.getDeployDate()==null?"":prepareMap.getDeployDate()%>"
					id="predeployDate" name="predeployDate" class='input_width'
					readonly="readonly"></input>&nbsp;&nbsp;<img
					src="<%=contextPath%>/images/calendar.gif" id="tributton1"
					width="16" height="16" style="cursor: hand;"
					onmouseover="timeSelector(predeployDate,tributton1);" /></td>
				<td class="rtCRUFdName">��ע��</td>
				<td class="rtCRUFdValue"><input type="text" maxlength="50"
					id="prenotes" name="prenotes" class='input_width'
					value="<%=prepareMap.getNotes()==null?"":prepareMap.getNotes()%>" />
				</td>
			</tr>
			<tr>
				<td class="rtCRUFdName">֪ͨ�ˣ�</td>
				<td class="rtCRUFdValue"><input type="hidden" id="noticeUserId"
					name="noticeUserId" maxlength="32"
					value="<%=applyInfo.getNoticeUserId()==null?"":applyInfo.getNoticeUserId() %>"
					class="input_width" /> <input type="hidden" id="noticeType"
					name="noticeType" maxlength="32" value="humanApply"
					class="input_width" /> <input type="text" readonly="readonly"
					unselectable="on" id="noticeUser" name="noticeUser" maxlength="32"
					value="<%=applyInfo.getNoticeUser()==null?"":applyInfo.getNoticeUser() %>"
					class="input_width" /> <img
					src="<%=contextPath%>/images/magnifier.gif" width="16" height="16"
					style="cursor: hand;" onclick="selectMultiPerson()" /></td>
				<td class="rtCRUFdName">֪ͨ��ʽ��</td>
				<td class="rtCRUFdValue">
					<%String noticeWay= applyInfo.getNoticeWay();
				if(noticeWay==null||"".equals(noticeWay)){
					noticeWay="";
				}
			%> <input type="checkbox" id="noticeWay" name="noticeWay"
					value="0110000010000000004"
					<% if(noticeWay.contains("0110000010000000004")){%>
					checked="checked" <%} %> /><font color="black">��������</font> <input
					type="checkbox" id="noticeWay" name="noticeWay"
					value="0110000010000000001"
					<% if(noticeWay.contains("0110000010000000001")){%>
					checked="checked" <%} %> /><font color="black">OCS</font> <input
					type="checkbox" id="noticeWay" name="noticeWay"
					value="0110000010000000002"
					<% if(noticeWay.contains("0110000010000000002")){%>
					checked="checked" <%} %> /><font color="black">�ʼ�</font> <input
					type="checkbox" id="noticeWay" name="noticeWay"
					value="0110000010000000003"
					<% if(noticeWay.contains("0110000010000000003")){%>
					checked="checked" <%} %> /><font color="black">����</font></td>
			</tr>
		</table>
		<%if(listFile!=null&&listFile.size()>0) {%>
		<br>
		<table border="0" cellpadding="0" cellspacing="0" class="form_info"
			width="100%">
			<tr class="even">
				<td align="center" colspan="4">������Ϣ</td>
			</tr>
			<tr background="blue" class="bt_info">
				<td class="tableHeader">���</td>
				<td class="tableHeader">�ĵ�����</td>
				<td class="tableHeader">������</td>
				<td class="tableHeader">����ʱ��</td>
				<td class="tableHeader">���ڵ�λ</td>
			</tr>
			<%
			Map  mapFile=new HashMap();
			for(int i=0;i<listFile.size();i++) {
				mapFile =listFile.get(i).toMap(); 
				String className = "";
				if (i % 2 == 0) {
					className = "even";
				} else {
					className = "odd";
				}
		%>
			<tr class="<%=className%>">
				<td><%=i+1 %></td>
				<td><a
					href="<%=contextPath%>/icg/file/DownloadFileAction.srq?pkValue=<%=mapFile.get("fileId")%>&tableName=<%="p_file_content"%>&fileColumn=<%="file_content"%>&fileName=<%=mapFile.get("fileName") %>"
					name=""><%=mapFile.get("fileName") %></a>&nbsp;</td>
				<td><%=mapFile.get("creatorName")==null?"":mapFile.get("creatorName") %>&nbsp;</td>
				<td><%=mapFile.get("createDate") %>&nbsp;</td>
				<td><%=mapFile.get("orgName") %>&nbsp;</td>
			</tr>
			<%} %>
		</table>
		<%} %>
		<% if("1".equals(prepareMap.getFunctionType())){%>
		<table border="0" cellspacing="0" cellpadding="0" class="form_info"
			width="100%" id="equipmentTableButton">
			<tr class="even">
				<td align="right">
					<% if(applyInfo.getRequirementNo()==null){ %> <input type="checkbox"
					name="spare1" id="spare1" value="1">�Ƿ�ɽ��Ƶ��� <%}else{ if(applyInfo.getSpare1()!=null&&"1".equals(applyInfo.getSpare1())){%>
					<input type="checkbox" name="spare1" id="spare1" value="1"
					checked="checked">�Ƿ�ɽ��Ƶ��� <%}else{%> <input type="checkbox"
					name="spare1" id="spare1" value="1">�Ƿ�ɽ��Ƶ��� <%}} %> <a
					href="<%=contextPath%>/rm/em/humanPlant/download.jsp?path=/rm/em/humanPlant/importHumanList.xls&filename=��Ա���뵼��ģ��.xls">������Ա����ģ��</a>
					<input name="Submit" type="button" class="iButton2"
					onClick="openSearch()" value="�������Ա����" /> <input name="Submit1"
					type="button" class="iButton2" onClick="importSerialNumber()"
					value="����" /></td>
			</tr>
		</table>
		<%}else if("2".equals(prepareMap.getFunctionType())){%>
		<table border="0" cellspacing="0" cellpadding="0" class="form_info"
			width="100%" id="equipmentTableButton">
			<tr class="even">
				<td align="right">
					<a href="<%=contextPath%>/rm/em/humanPlant/download.jsp?path=/rm/em/humanPlant/importHumanList.xls&filename=��Ա���뵼��ģ��.xls">������Ա����ģ��</a>
					<input name="Submit1" type="button" class="iButton2" onClick="importSerialNumber()" value="����" />
					</td>
			</tr>
		</table>
		<%} %>
		<%if("0".equals(auditStatus) || ("true".equals(update) && "1".equals(auditStatus))){ %>
		<table border="0" cellspacing="0" cellpadding="0" class="form_info"
			width="100%" id="equipmentTableInfo">
			<tr background="blue" class="bt_info">
				<TD class="tableHeader" width="3%">���</TD>
				<TD class="tableHeader" width="10%">����</TD>
				<TD class="tableHeader" width="10%">��λ</TD>
				<TD class="tableHeader" width="6%">��������</TD>
				<TD class="tableHeader" width="6%">�ѵ�������</TD>
				<TD class="tableHeader" width="6%"><font color=red>*</font>&nbsp;���ε�������</TD>
				<TD class="tableHeader" width="7%">����</TD>
				<TD class="tableHeader" width="7%">��������</TD>
				<TD class="tableHeader" width="7%">�Ļ��̶�</TD>
				<TD class="tableHeader" width="10%">Ԥ�ƽ�����Ŀʱ��</TD>
				<TD class="tableHeader" width="10%">Ԥ���뿪��Ŀʱ��</TD>
				<TD class="tableHeader" width="6%">Ԥ������</TD>
				<TD class="tableHeader" width="3%">��ע</TD>
				<TD class="tableHeader" width="3%">����<input type="hidden"
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
			String flag = "false";
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
				
				<td><input type="text" maxlength="32" name="fy<%=i%>alNum"
					id="fy<%=i%>alNum"
					value="<%=applyDetailInfo.getPreNum()==null?"0":applyDetailInfo.getPreNum()%>"
					class="input_width" readonly />
				</td>
				<%  
			int preNum = 0; 
				if(Integer.parseInt(applyDetailInfo.getPeopleNumber()==null?"0":applyDetailInfo.getPeopleNumber())>=Integer.parseInt(applyDetailInfo.getPreNum()==null?"0":applyDetailInfo.getPreNum())){
					preNum = Integer.parseInt(applyDetailInfo.getPeopleNumber()==null?"0":applyDetailInfo.getPeopleNumber())-Integer.parseInt(applyDetailInfo.getPreNum()==null?"0":applyDetailInfo.getPreNum());
				}
		%>
				<td><input type="text" maxlength="32"
					name="fy<%=i%>prepareNumber" id="fy<%=i%>prepareNumber"
					value="<%=applyDetailInfo.getPrepareNumber()==null?preNum:applyDetailInfo.getPrepareNumber()%>"
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
					class="input_width" readonly />
				</td>
				<td>
					<% if("3".equals(prepareMap.getFunctionType())){
				String subjectionId = applyInfo.getOrgSubjectionId();
				if(update != null){ subjectionId = applyDetailInfo.getPrepareSubjectionId();}
			%> <%if(subOrgIDofAffordOrg!=null &&subjectionId.startsWith(subOrgIDofAffordOrg)){ flag = "true";%>
					<a href="javascript:openSearch('<%=i%>')">ѡ��</a> <%}else{ %> <a
					href="javascript:openSearch('hu<%=i%>')" disabled="disabled"
					onclick="return false;">ѡ��</a> <%}}else if("1".equals(prepareMap.getFunctionType())){ %>
					<a href="javascript:openSearch('<%=i%>')">ѡ��</a> <%} %> <input
					type="hidden" name="fy<%=i%>flag" id="fy<%=i%>flag"
					value="<%=flag%>" />
				</td>
			</tr>
			<%
		}
	%>
		</table>
		<%} %>
		<% if((("3".equals(prepareMap.getFunctionType()) && "1".equals(auditStatus)) || "2".equals(prepareMap.getFunctionType())) &&subBeanList.size()>0 ){%>
		<table border="0" cellspacing="0" cellpadding="0" class="form_info"
			width="100%" id="equipmentTableInfo1">
			<tr background="blue" class="bt_info">
				<TD class="tableHeader" width="3%">���</TD>
				<TD class="tableHeader" width="10%">����</TD>
				<TD class="tableHeader" width="10%">��λ</TD>
				<TD class="tableHeader" width="10%">���䵥λ</TD>
				<TD class="tableHeader" width="6%">��������</TD>
				<TD class="tableHeader" width="6%">�ѵ�������</TD>
				<TD class="tableHeader" width="6%"><font color=red>*</font>&nbsp;���ε�������</TD>
				<TD class="tableHeader" width="7%">����</TD>
				<TD class="tableHeader" width="7%">��������</TD>
				<TD class="tableHeader" width="7%">�Ļ��̶�</TD>
				<TD class="tableHeader" width="5%">Ԥ�ƽ�����Ŀʱ��</TD>
				<TD class="tableHeader" width="5%">Ԥ���뿪��Ŀʱ��</TD>
				<TD class="tableHeader" width="4%">Ԥ������</TD>
				<TD class="tableHeader" width="3%">��ע<input type="hidden"
					id="equipmentESize" name="equipmentESize"
					value="<%=subBeanList.size()%>" /></TD>
				<TD class="tableHeader" width="3%">����</TD>
			</tr>
			<%
		for (int i = 0; i < subBeanList.size(); i++) {
			String className = "";
			if (i % 2 == 0) {
				className = "even";
			} else {
				className = "odd";
			}
			BgpProjectHumanProfessDeta applyDetailInfo = subBeanList.get(i);
			String ss="em"+String.valueOf(i)+"deviceUnit";
			String flag = "false";
	%>
			<tr class="<%=className%>" id="hu<%=i%>trflag">
				<td><%=i + 1%><input type="hidden" id="hu<%=i%>postDetailNo"
					name="hu<%=i%>postDetailNo"
					value="<%=applyDetailInfo.getPostDetailNo()==null?"":applyDetailInfo.getPostDetailNo()%>" />
				</td>
				<td><input type="hidden" maxlength="32"
					name="hu<%=i%>applyTeam" id="hu<%=i%>applyTeam"
					value="<%=applyDetailInfo.getApplyTeam()==null?"":applyDetailInfo.getApplyTeam()%>" />
					<input type="text" maxlength="32" name="hu<%=i%>applyTeamname"
					id="hu<%=i%>applyTeamname"
					value="<%=applyDetailInfo.getApplyTeamname()==null?"":applyDetailInfo.getApplyTeamname()%>"
					readonly="readonly" class="input_width" /></td>
				<td><input type="hidden" maxlength="32" name="hu<%=i%>post"
					id="hu<%=i%>post"
					value="<%=applyDetailInfo.getPost()==null?"":applyDetailInfo.getPost()%>"
					class="input_width" /> <input type="text" maxlength="32"
					name="hu<%=i%>postname" id="hu<%=i%>postname"
					value="<%=applyDetailInfo.getPostname()==null?"":applyDetailInfo.getPostname()%>"
					readonly="readonly" class="input_width" /></td>
				<td><input type="hidden" maxlength="32" id="hu<%=i%>deployOrg"
					name="hu<%=i%>deployOrg"
					value="<%=applyDetailInfo.getDeployOrg()==null?"":applyDetailInfo.getDeployOrg()%>"
					class="input_width" /><input type="text" maxlength="32"
					id="em<%=i%>deployOrgName" name="em<%=i%>deployOrgName"
					value="<%=applyDetailInfo.getDeployOrgName()==null?"":applyDetailInfo.getDeployOrgName()%>"
					class="input_width" readonly="readonly" />
				</td>
				<td><input type="text" maxlength="32" id="hu<%=i%>peopleNumber"
					name="hu<%=i%>peopleNumber"
					onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);"
					value="<%=applyDetailInfo.getPeopleNumber()==null?"":applyDetailInfo.getPeopleNumber()%>"
					class="input_width" readonly="readonly" />&nbsp;</td>
				<td><input type="text" maxlength="32" name="hu<%=i%>alNum"
					id="hu<%=i%>alNum"
					value="<%=applyDetailInfo.getAlNum()==null?"0":applyDetailInfo.getAlNum()%>"
					class="input_width" readonly="readonly" />
				</td>
				<%  
			int preNum = 0; 
			if(applyDetailInfo.getAlNum()!=null){
				if(Integer.parseInt(applyDetailInfo.getPeopleNumber())>=Integer.parseInt(applyDetailInfo.getAlNum()==null?"0":applyDetailInfo.getAlNum())){
					preNum = Integer.parseInt(applyDetailInfo.getPeopleNumber())-Integer.parseInt(applyDetailInfo.getAlNum()==null?"0":applyDetailInfo.getAlNum());
				}				
			} 
		%>
				<td><input type="text" maxlength="32"
					name="hu<%=i%>prepareNumber" id="hu<%=i%>prepareNumber"
					value="<%=preNum%>"
					onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);"
					class="input_width" />
				</td>
				<td><bgp:codeSelect name='<%=("hu"+String.valueOf(i)+"age")%>'
						option="hrAgeOps" addAll="true"
						selectedValue='<%=applyDetailInfo.getAge()==null?"":applyDetailInfo.getAge()%>'
						cssClass="input_width" />&nbsp;</td>
				<td><bgp:codeSelect
						name='<%=("hu"+String.valueOf(i)+"workYears")%>'
						option="workYearOps" addAll="true"
						selectedValue='<%=applyDetailInfo.getWorkYears()==null?"":applyDetailInfo.getWorkYears()%>'
						cssClass="input_width" />&nbsp;</td>
				<td><bgp:codeSelect
						name='<%=("hu"+String.valueOf(i)+"culture")%>'
						option="hrDegreeOps" addAll="true"
						selectedValue='<%=applyDetailInfo.getCulture()==null?"":applyDetailInfo.getCulture()%>'
						cssClass="input_width" />&nbsp;</td>
				<td><input type="text" name="hu<%=i%>planStartDate"
					id="hu<%=i%>planStartDate" readonly="readonly"
					value="<%=applyDetailInfo.getPlanStartDate()==null?"":applyDetailInfo.getPlanStartDate()%>"
					class="input_width" />
				</td>
				<td><input type="text" name="hu<%=i%>planEndDate"
					id="hu<%=i%>planEndDate" readonly="readonly"
					value="<%=applyDetailInfo.getPlanEndDate()==null?"":applyDetailInfo.getPlanEndDate()%>"
					class="input_width" />
				</td>
				<td><input type="text" maxlength="32" name="hu<%=i%>spare1"
					value="<%=applyDetailInfo.getSpare1()==null?"":applyDetailInfo.getSpare1()%>"
					class="input_width" />
				</td>
				<td><input type="text" maxlength="32" name="hu<%=i%>notes"
					value="<%=applyDetailInfo.getNotes()==null?"":applyDetailInfo.getNotes()%>"
					class="input_width" />
				</td>
				<td>
		<%if(subOrgIDofAffordOrg!=null &&applyDetailInfo.getDeploySubId().startsWith(subOrgIDofAffordOrg)){
			if("3".equals(prepareMap.getFunctionType()) && "1".equals(applyDetailInfo.getDeployFlag())){
				if("true".equals(applyDetailInfo.getDeFlag())){ flag = "true"; %> <a
					href="javascript:openSearch('hu<%=i%>')">ѡ��</a>
				<%}else{ flag = "false"; %>
					<a href="javascript:openSearch('hu<%=i%>')" disabled="disabled"
					onclick="return false;">ѡ��</a>			
			 <%}	
			}else{ flag = "true";%> <a href="javascript:openSearch('hu<%=i%>')">ѡ��</a>
					<%}
		 }else{
			    flag = "false"; %>
				 <a href="javascript:openSearch('hu<%=i%>')"
					disabled="disabled" onclick="return false;">ѡ��</a>
		 <%} %>
			    <input
					type="hidden" name="hu<%=i%>flag" id="hu<%=i%>flag"
					value="<%=flag%>" /></td>
			</tr>
		<%
			}
		%>
		</table>
		<%}%>
		<% if("1".equals(prepareMap.getFunctionType())){%>
		<div align="right">
			<% if(applyInfo.getSpare1()!=null&&"1".equals(applyInfo.getSpare1())){%>
			<font color="red" />�ɽ��Ƶ���</font/>
			<%}else{ %>
			<font color="red" />��Ա����������<%=peopleNum %></font/><font color="red" />��Ա���������<%=auditNumber %></font/>
			<%} %>
		</div>
		<%}%>
		<table border="0" cellspacing="0" cellpadding="0" class="form_info"
			width="100%" id="equipmentTableButton">
			<tr class="even">
				<td align="right"><input name="Submit1" type="button"
					class="iButton2" onClick="copyEsimiDate();" value="��������" /></td>
			</tr>
		</table>
		<table border="0" cellspacing="0" cellpadding="0" class="form_info"
			width="100%" id="employeeTable">
			<tr background="blue" class="bt_info">
				<TD class="tableHeader" width="3%">���</TD>
				<TD class="tableHeader" width="10%"><font color=red>*</font>&nbsp;����</TD>
				<TD class="tableHeader" width="10%"><font color=red>*</font>&nbsp;��λ</TD>
				<TD class="tableHeader" width="10%"><font color=red>*</font>&nbsp;����</TD>
				<TD class="tableHeader" width="10%"><font color=red>*</font>&nbsp;Ԥ�ƽ�����Ŀʱ��</TD>
				<TD class="tableHeader" width="10%"><font color=red>*</font>&nbsp;Ԥ���뿪��Ŀʱ��
				</TD>
				<TD class="tableHeader" width="6%">&nbsp;Ԥ������</TD>
				<TD class="tableHeader" width="3%">����<input type="hidden"
					id="equipmentSize" name="equipmentSize"
					value="<%=humanList.size()%>" /> <input type="hidden"
					id="hidDetailId" name="hidDetailId" value="" /> <input
					type="hidden" id="deleteRowFlag" name="deleteRowFlag" value="" />
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
					class="input_width" /> <input type="text" maxlength="32"
					name="em<%=j%>employeeName"
					value="<%=humanInfo.getEmployeeName()==null?"":humanInfo.getEmployeeName()%>"
					readonly="readonly" class="input_width" /></td>

				<td><input type="text" name="em<%=j%>planStartDate"
					id="em<%=j%>planStartDate" readonly="readonly"
					value="<%=humanInfo.getPlanStartDate()==null?"":humanInfo.getPlanStartDate()%>"
					onpropertychange="calDays('<%=j %>')" class="input_width" />&nbsp;&nbsp;<img
					src="<%=contextPath%>/images/calendar.gif" id="tributton2<%=j%>"
					width="16" height="16" style="cursor: hand;"
					onmouseover="dateSelector('em<%=j%>planStartDate',tributton2<%=j%>);" />
				</td>
				<td><input type="text" name="em<%=j%>planEndDate"
					id="em<%=j%>planEndDate" readonly="readonly"
					value="<%=humanInfo.getPlanEndDate()==null?"":humanInfo.getPlanEndDate()%>"
					onpropertychange="calDays('<%=j %>')" class="input_width" />&nbsp;&nbsp;<img
					src="<%=contextPath%>/images/calendar.gif" id="tributton3<%=j%>"
					width="16" height="16" style="cursor: hand;"
					onmouseover="dateSelector('em<%=j%>planEndDate',tributton3<%=j%>);" />
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
		<br>
		<table id="buttonTable" border="0" cellpadding="0" cellspacing="0"
			class="form_info">
			<tr align="right">
				<td><input name="Submit" type="button" class="iButton2"
					onClick="doPrepare();" value="����" /> <input name="Submit"
					type="button" class="iButton2" onClick="window.history.back();"
					value="����" />
				</td>
			</tr>
		</table>
	</form>
</body>
</html>