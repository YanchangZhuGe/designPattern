<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.bgp.mcs.service.rm.em.humanRequired.pojo.*"%>

<%
	String contextPath = request.getContextPath();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	List<MsgElement> list = resultMsg.getMsgElements("detailInfo");
	List<BgpProjectHumanRelation> beanList=new ArrayList<BgpProjectHumanRelation>(0);
	if(list!=null){
		 beanList = new ArrayList<BgpProjectHumanRelation>(
				list.size());
		
		for (int i = 0; i < list.size(); i++) {
			beanList.add((BgpProjectHumanRelation) list.get(i).toPojo(
					BgpProjectHumanRelation.class));
		}
	}
	BgpProjectHumanRelation relation = new BgpProjectHumanRelation();
	if(beanList != null){
		relation = (BgpProjectHumanRelation)beanList.get(0);
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
<html>
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

var currentCount=parseInt('<%=beanList.size()%>');
var deviceCount = parseInt('<%=beanList.size()%>');

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
		alert("�����һ����Ա������Ϣ���ٵ������");
		return ;
	}
	if(checkForm()){
	var form = document.getElementById("CheckForm");
	form.action = "<%=contextPath%>/rm/em/savehumanProjectRelat.srq";	
	form.submit();
	alert('�޸ĳɹ�');
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



</script>
<title>��Ա��Ŀ�����޸�</title>
</head>
<body>
<form id="CheckForm" name="Form0" action="" method="post" target="list">
<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">

	<tr >
		<td class="inquire_item4"><font color=red>*</font>&nbsp;��Ŀ���ƣ�</td>
		<td  class="inquire_form4">
		<input type="hidden" id="projectInfoNo" name="projectInfoNo" value="<%= relation.getProjectInfoNo()==null?"":relation.getProjectInfoNo() %>"/>
		<input type="text"  unselectable="on"   readonly="readonly" value="<%= relation.getProjectName()==null?"":relation.getProjectName() %>" maxlength="32" id="projectName" name="projectName" class='input_width'></input>
		<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectTeam()"/>
		</td>
		<td class="inquire_item4">&nbsp;</td>
		<td  class="inquire_form4">&nbsp;</td>	
	</tr>
	
</table>

<table border="0" cellspacing="0" cellpadding="0" class="tab_info" width="100%" id="equipmentTableInfo">
	<tr  >
		<TD class="bt_info_odd" width="9%"><font color=red>*</font>����</TD>
		<TD class="bt_info_even" width="12%">����</TD>
		<TD class="bt_info_odd" width="12%">��λ</TD>

		<TD class="bt_info_even" width="12%">Ԥ�ƽ�����Ŀʱ��</TD>
		<TD class="bt_info_odd" width="12%">Ԥ���뿪��Ŀʱ�� </TD>
		<TD class="bt_info_even" width="12%">ʵ�ʽ�����Ŀʱ��</TD>
		<TD class="bt_info_odd" width="12%">ʵ���뿪��Ŀʱ�� </TD>
		<TD class="bt_info_even" width="10%">��Ա���� 
		<input type="hidden" id="equipmentSize" name="equipmentSize" value="<%=beanList.size()%>" />
		<input type="hidden" id="deleteRowFlag" name="deleteRowFlag" value="" /></TD>
	</tr>
	<tr  id="fy0trflag" align ="center">
		<td class="even_odd">
		<input type="hidden" id="fy0relationNo" name="fy0relationNo" value="<%=relation.getRelationNo()==null?"":relation.getRelationNo()%>" />
		<input type="hidden" id="fy0employeeId" name="fy0employeeId" value="<%= relation.getEmployeeId()==null?"":relation.getEmployeeId() %>"/>
		<input type="text"  unselectable="on"  id="fy0employeeName" name="fy0employeeName" readonly="readonly" value="<%= relation.getEmployeeName()==null?"":relation.getEmployeeName() %>" maxlength="32"  class='input_width'></input>
		<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectPerson('0')"/>
		</td>
		<td class="odd_even">
		<select name="fy0team" id="fy0team" onchange="getApplyPostList('0')" class="input_width">
			<option value="">��ѡ��</option>
			<% 	if(allTeamList != null){
				for(int m = 0; m < allTeamList.size(); m++){
					MsgElement msg = (MsgElement) allTeamList.get(m);
					Map tempMap = msg.toMap();
			%>
				<option value="<%=tempMap.get("value")%>" <%if(tempMap.get("value").toString().equals(relation.getTeam())){%> selected="selected" <%} %>>
				<%=tempMap.get("label")%>
				</option>	
			<%
				}	
			} %>
		</select>
		&nbsp;</td>		
		<td class="even_odd">
		<select name="fy0workPost" id="fy0workPost" class="input_width">
			<option value="">��ѡ��</option>
			<% if(postMsg != null){
				//�õ������Ӧ�ĸ�λƴ�Ӵ�
				String postsb = (String)postMsg.get(relation.getTeam());
				if(postsb!=null&&!"".equals(postsb)){
				String[] temp =postsb.split(",");
				for(int n = 0; n<temp.length; n++){
					String post = temp[n];
					String[] poststr = post.split(":");
			%>
				<option value="<%=poststr[0]%>" 
				<%if(poststr[0].equals(relation.getWorkPost())){%> selected="selected" <%} %>>
				<%=poststr[1]%></option>
			<%					
				}	
				}
			}			
			%>
		</select>	   
		&nbsp;</td>

		<td class="odd_even"><input type="text" onchange="calDays('0')" name="fy0planStartDate" id="fy0planStartDate"  readonly="readonly" value="<%=relation.getPlanStartDate()==null?"":relation.getPlanStartDate()%>" class="input_width" /><img src="<%=contextPath%>/images/calendar.gif" id="tributton20" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector('fy0planStartDate',tributton20);" />&nbsp;</td>
		<td class="even_odd"><input type="text" onchange="calDays('0')" name="fy0planEndDate" id="fy0planEndDate"  readonly="readonly" value="<%=relation.getPlanEndDate()==null?"":relation.getPlanEndDate()%>" class="input_width" /><img src="<%=contextPath%>/images/calendar.gif" id="tributton30" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector('fy0planEndDate',tributton30);" />&nbsp;</td>
		
		<td class="odd_even"><input type="text" onchange="calCheckDays('0')"  name="fy0actualStartDate" id="fy0actualStartDate"  readonly="readonly" value="<%=relation.getActualStartDate()==null?"":relation.getActualStartDate()%>" class="input_width" /><img src="<%=contextPath%>/images/calendar.gif" id="tributton40" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector('fy0actualStartDate',tributton40);" />&nbsp;</td>
		<td class="even_odd"><input type="text" onchange="calCheckDays('0')" name="fy0actualEndDate" id="fy0actualEndDate"  readonly="readonly" value="<%=relation.getActualEndDate()==null?"":relation.getActualEndDate()%>" class="input_width" /><img src="<%=contextPath%>/images/calendar.gif" id="tributton50" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector('fy0actualEndDate',tributton50);" />&nbsp;</td>
		
		<td class="odd_even">
		<%
		System.out.println(relation.getProjectEvaluate());
			if(relation.getProjectEvaluate()==null){
		%>
		 
			<select  style="width:100px;" id="fy0projectEvaluate" name="fy0projectEvaluate"  ><option value="">��ѡ��</option><option value="0110000058000000001">����</option><option value="0110000058000000002">��ְ</option><option value="0110000058000000003">������ְ</option><option value="0110000058000000004">����ְ</option></select>
		<%
		 	} 
		if(relation.getProjectEvaluate()!=null ){
		if (relation.getProjectEvaluate().equals("0110000058000000001")){
		%>
			<select  style="width:100px;" id="fy0projectEvaluate" name="fy0projectEvaluate"  ><option value="">��ѡ��</option><option value="0110000058000000001" selected="selected" >����</option><option value="0110000058000000002">��ְ</option><option value="0110000058000000003">������ְ</option><option value="0110000058000000004">����ְ</option></select>
		<%
		 	} 
		if(relation.getProjectEvaluate().equals("0110000058000000002")){
		%>
			<select  style="width:100px;" id="fy0projectEvaluate" name="fy0projectEvaluate"  ><option value="">��ѡ��</option><option value="0110000058000000001">����</option><option value="0110000058000000002"  selected="selected" >��ְ</option><option value="0110000058000000003">������ְ</option><option value="0110000058000000004">����ְ</option></select>
		<%
		 	}
		if(relation.getProjectEvaluate().equals("0110000058000000003")){
		%>
			<select  style="width:100px;" id="fy0projectEvaluate" name="fy0projectEvaluate"  ><option value="">��ѡ��</option><option value="0110000058000000001">����</option><option value="0110000058000000002">��ְ</option><option value="0110000058000000003" selected="selected"  >������ְ</option><option value="0110000058000000004">����ְ</option></select>
		<%
		 	}
		if(relation.getProjectEvaluate().equals("0110000058000000004")){
		%>
			<select  style="width:100px;" id="fy0projectEvaluate" name="fy0projectEvaluate"  ><option value="">��ѡ��</option><option value="0110000058000000001">����</option><option value="0110000058000000002">��ְ</option><option value="0110000058000000003">������ְ</option><option value="0110000058000000004" selected="selected" >����ְ</option></select>
		<%
		 	}
		}
		%>
		</td>
	</tr>

</table>
<br>
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
</form>
</body>
</html>