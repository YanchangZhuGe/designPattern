<%@page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubjectionId = user.getOrgSubjectionId();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet"
	type="text/css" />
<script language="JavaScript" type="text/JavaScript"
	src="<%=contextPath%>/js/bgpmcs/DivHiddenOpen.js"></script>
<%@ include file="/common/pmd_list.jsp"%>
<title>列表页面</title>
</head>
<script language="javaScript">
<!--Remark JavaScript定义-->
var pageTitle = "人员项目经历审核";
cruConfig.contextPath =  "<%=contextPath%>";
var applyStateOps = new Array(
['0','未提交'],['1','待审核'],['2','审核通过'],['3','审核未通过'],['4','已调配']
);

var auditStatus = new Array(
['0','待审核'],['1','审核通过'],['2','审核不通过']
);

var sex = new Array(
	['女','女'],['男','男']
)

var jcdp_codes_items = null;
var jcdp_codes = new Array(
);


function JcdpButton0OnClick(){

 	if(checked == ""){
		alert("请选择一条记录!");
		return;
	}

    var tempa = checked.split(',');
    var relation_nos = "";
    for(var i=0;i<tempa.length-1; i++){

    	var tempas = tempa[i];
    	var tempal = tempas.split("-");
	    var relation_no =  tempal[0];    
	    if( i == tempa.length-2){
			relation_nos = relation_nos +"'"+ relation_no+"'" ;
		}else{
			relation_nos = relation_nos + "'"+ relation_no+"',";
		}
	    
	}    
	var sql = "update bgp_project_human_relation set locked_if='1',modifi_date=sysdate where relation_no in ("+relation_nos+")";
	updateEntitiesBySql(sql,"提交");
	var retuObj = jcdpCallService("HumanCommInfoSrv", "doHumanReturnafterRelation","relation_nos="+relation_nos);
	checked="";
}
			
function JcdpButton1OnClick(){
	if(checked == ""){
			alert("请选择一条记录!");
			return;
	}

    var tempa = checked.split(',');
    var relation_nos = "";
    for(var i=0;i<tempa.length-1; i++){

    	var tempas = tempa[i];
    	var tempal = tempas.split("-");
	    var relation_no =  tempal[0];    
		if( i == tempa.length-2){
			relation_nos = relation_nos +"'"+ relation_no+"'" ;
		}else{
			relation_nos = relation_nos + "'"+ relation_no+"',";
		}
	    
	}

	var sql = "update bgp_project_human_relation set locked_if='2',modifi_date=sysdate where relation_no in ("+relation_nos+")";
    updateEntitiesBySql(sql,"提交");
    var retuObj = jcdpCallService("HumanCommInfoSrv", "doHumanReturnafterRelation","relation_nos="+relation_nos);
    checked="";
}
  
function page_init(){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.funcCode = "F_EM_HUMAN_018";
	cruConfig.cdtType = 'form';
	cdt_init();
	cruConfig.queryStr = "select decode(hr.locked_if, '0', '待审核', '1', '审核通过', '2', '审核不通过') locked_if_name, decode(he.EMPLOYEE_GENDER,'0','女','1','男' ) employee_gender, p.project_name, hr.locked_if, hr.relation_no, hr.project_info_no,hr.project_info_name, hr.employee_id, he1.employee_cd,he1.spare2, he.employee_name, hr.plan_start_date,nvl(hr.spare1,he.org_id) org_id, hr.plan_end_date, hr.actual_start_date, hr.actual_end_date,((hr.actual_end_date-hr.actual_start_date)-(-1)) sub_date, hr.team, sd.coding_name team_name, hr.work_post, sd2.coding_name work_post_name, decode(sd3.coding_name,'',hr.project_evaluate,sd3.coding_name) project_evaluate from bgp_project_human_relation hr left join  comm_human_employee he on hr.employee_id = he.employee_id and  he.bsflag = '0' left join comm_human_employee_hr he1 on hr.employee_id = he1.employee_id left join comm_coding_sort_detail  sd on hr.team = sd.coding_code_id and  sd.bsflag = '0' left join comm_coding_sort_detail  sd2 on hr.work_post = sd2.coding_code_id and sd2.bsflag = '0'  left join comm_coding_sort_detail sd3 on hr.project_evaluate =sd3.coding_code_id left join gp_task_project p on hr.project_info_no = p.project_info_no and p.bsflag='0' where hr.bsflag='0' order by hr.modifi_date ";
	cruConfig.currentPageUrl = "/rm/em/humanProjecRelation/humanProjectRelation.jsp";
	classicQuery();
}

var fields = new Array();
	
function basicQuery(){
	var qStr = generateBasicQueryStr();
	cruConfig.cdtStr = qStr;
	queryData(1);
}

function queryData(targetPage){
	cruConfig.currentPage = targetPage;

	var submitStr = "currentPage="+targetPage+"&pageSize="+cruConfig.pageSize;
	if(cruConfig.funcCode!='') submitStr += "&EP_DATA_AUTH_funcCode="+cruConfig.funcCode;

	var retObject;//alert(cruConfig.queryService);
	if(cruConfig.queryService!=''){//调用服务查询
		submitStr = encodeURI(submitStr);
		submitStr = encodeURI(submitStr);
		retObject = jcdpCallService(cruConfig.queryService,cruConfig.queryOp,submitStr);
	}
	else{//根据sql查询
		var querySql = cruConfig.queryStr;
		if(cruConfig.cdtStr!=''){
			querySql = "Select * FROM ("+querySql+")TARGET_RET WHERE "+cruConfig.cdtStr;
		}
		submitStr += "&querySql="+querySql;
		submitStr = encodeURI(submitStr);
		submitStr = encodeURI(submitStr);
		var path = cruConfig.contextPath+appConfig.queryListAction;
		retObject = syncRequest('Post',path,submitStr);
	}

	if (retObject.returnCode != "0") return;
	cruConfig.items = retObject.datas;
	cruConfig.totalRows = retObject.totalRows;
	renderTable(getObj(cruConfig.queryRetTable_id),cruConfig);

	cruConfig.currentPageRlIds = '';
	cruConfig.relationedIds=checked;
	if(cruConfig.relationedIds!=''){
		
		var chxs = document.getElementsByName("chx_entity_id");
		for(var i=0;i<chxs.length;i++)
			if(cruConfig.relationedIds.indexOf(chxs[i].value)>=0){
				 chxs[i].checked = true;
				 if(cruConfig.currentPageRlIds=='') cruConfig.currentPageRlIds = chxs[i].value;
				 else cruConfig.currentPageRlIds += ','+chxs[i].value;
				
			}
	}
}

function cmpQuery(){
	var qStr = generateCmpQueryStr();
	cruConfig.cdtStr = qStr;
	queryData(1);
}

function classicQuery(){
	var qStr = generateClassicQueryStr();
	var employeeName=document.getElementById("employeeName").value;
	var lockedIf=document.getElementById("lockedIf").value;
	var work=document.getElementById("work").value;
	var post=document.getElementById("post").value;
	var employeeCd=document.getElementById("employeeCd").value;
	var projectName=document.getElementById("projectName").value;
	var spare2 = "";
	if(document.getElementById("spare2") != null){
		spare2=document.getElementById("spare2").value;
	}
	if(qStr==""){
		qStr+="  (1=1";
	}else{
	qStr+="and (1=1";
	}
	if(employeeName!=""){
		qStr=qStr +" and employee_name like '%"+employeeName+"%' ";
	}
	if(lockedIf!=""){
		qStr=qStr +" and locked_if = "+lockedIf;
	}
	if(work!=""){
		qStr=qStr +" and team = "+work;
	}
	if(post!=""){
		qStr=qStr +" and work_post  = "+post;
	}
	if(employeeCd!=""){
		qStr=qStr +" and employee_cd  like '%"+employeeCd+"%'";
	}
	if(projectName!=""){
		qStr=qStr +" and project_name like '%"+projectName+"%'";
	}
	if(spare2!=""){
		qStr=qStr +" and spare2  like '%"+spare2+"%'";
	}
	qStr+=" )";
	
	cruConfig.cdtStr = qStr;
	queryData(1);
}

function onlineEdit(rowParams){
	var path = cruConfig.contextPath+cruConfig.editAction;
	var params = cruConfig.editTableParams+"&rowParams="+rowParams.toJSONString();
	var retObject = syncRequest('Post',path,params);
	if(retObject.returnCode!=0){
		alert(retObject.returnMsg);
		return false;
	}else return true;
}

function selectTeam(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/common/selectProject.lpmd',teamInfo);
    if(teamInfo.fkValue!=""){
        document.getElementById("projectId").value = teamInfo.fkValue;
        document.getElementById("projectName").value = teamInfo.value;
    }
}

function getTeamList(){

	//得到所有班组
	var applyTeamList=jcdpCallService("HumanRequiredSrv","queryApplyTeam","");	
	var selectObj = document.getElementById("work");
	document.getElementById("work").innerHTML="";
	selectObj.add(new Option('请选择',""),0);
	if(applyTeamList.detailInfo!=null){
	for(var i=0;i<applyTeamList.detailInfo.length;i++){
		var templateMap = applyTeamList.detailInfo[i];
		selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	}
	}
	var selectObj1 = document.getElementById("post");
	document.getElementById("post").innerHTML="";
	selectObj1.add(new Option('请选择',""),0);
}

function getApplyPostList(){

    var applyTeam = "applyTeam="+document.getElementById("work").value;  
	var applyPost=jcdpCallService("HumanRequiredSrv","queryApplyPostList",applyTeam);	

	var selectObj = document.getElementById("post");
	document.getElementById("post").innerHTML="";
	selectObj.add(new Option('请选择',""),0);
	if(applyPost.detailInfo!=null){
	for(var i=0;i<applyPost.detailInfo.length;i++){
		var templateMap = applyPost.detailInfo[i];
		selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	}
	}
}
function head_chx_box_changed(headChx){
		var chxBoxes = document.getElementsByName("chx_entity_id");
		if(chxBoxes==undefined) return;
		for(var i=0;i<chxBoxes.length;i++){
		  if(!chxBoxes[i].disabled){
				chxBoxes[i].checked = headChx.checked;	
				doCheck(chxBoxes[i]);
		  }
		  
		}
}
//保存的checkbox拼接的值
var checked="";

function doCheck(id){

	//序号
	var num = -1;
	//新的check值
	var newcheck = "";
	//拼接的值不为空

	if(checked != ""){
		var checkStr = checked.split(",");
		for(var i=0;i<checkStr.length-1; i++){
			//如果check中存在  选择的id值
			if(checkStr[i] == id.value){
				//记录位置
				num = i;		
				break;	
			}
		}
        //判断num是否有值
		if(num != -1 ){
			if(id.checked==false){
				for(var j=0;j<checkStr.length-1; j++){
					if( j != num ){
						newcheck += checkStr[j] + ',';
					}
				}
				checked = newcheck;
			}
		}else{
			//直接拼
			if(id.checked==true){
				checked= checked + id.value + ',';	
			}		
		}
	}else{
		checked = id.value + ',';
		
	}
}

//选择项目
function selectTeam(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/common/selectProject.lpmd',teamInfo);
    if(teamInfo.fkValue!=""){
        document.getElementById("projectId").value = teamInfo.fkValue;
        document.getElementById("projectName").value = teamInfo.value;
    }
}

</script>

<script type="text/javascript" src="/BGPMCS/js/calendar.js"></script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
<script type="text/javascript" src="/BGPMCS/js/calendar-setup.js"></script>
</head>
<body onload="page_init();getTeamList()">
<div id="queryDiv" style="display: ">
<table border="0" cellpadding="0" cellspacing="0" class="form_info"
	id="queryCdtTable" enctype="multipart/form-data">
	<tr>
		<td class="rtCRUFdName">姓名：</td>
		<td class="rtCRUFdValue"><input type="text" value=""
			id="employeeName" name="employeeName" class='input_width'></input></td>
		<td class="rtCRUFdName">审核状态：</td>
		<td class="rtCRUFdValue">
		<select id="lockedIf" name="lockedIf" class="input_width">
			<option value="">全部</option>
			<option value="0" selected="selected">待审核</option>
			<option value="1">审核通过</option>
			<option value="2">审核不通过</option>
		</select>
		</td>
	</tr>
	<tr>
		<td class="rtCRUFdName">班组：</td>
		<td class="rtCRUFdValue"><select id="work" class="input_width"
			onchange="getApplyPostList()"></select></td>
		<td class="rtCRUFdName">岗位：</td>
		<td class="rtCRUFdValue"><select id="post" class="input_width"></select>
		</td>
	</tr>
	<tr>
		<td class="rtCRUFdName">项目名称：</td>
		<td class="rtCRUFdValue"><input type="hidden" value=""
			id="projectId" name="projectId"></input> <input type="text" value=""
			id="projectName" name="projectName" class='input_width'
			readonly="readonly"></input> <img
			src="<%=contextPath%>/images/magnifier.gif" width="16" height="16"
			style="cursor: hand;" onclick="selectTeam()" /></td>
		<td class="rtCRUFdName">&nbsp;员工编号</td>
		<td class="rtCRUFdValue"><input type="text" class='input_width'
			id="employeeCd" name="employeeCd" value="" /></td>
	</tr>
	<%
		if (orgSubjectionId != null && orgSubjectionId.length() > 9
				&& orgSubjectionId.substring(0, 10).equals("C105001005")) {
	%>
	<tr>
		<td class="rtCRUFdName">&nbsp;职工编号</td>
		<td class="rtCRUFdValue"><input type="text" class='input_width'
			id="spare2" name="spare2" value="" /></td>
		<td class="rtCRUFdName">&nbsp;</td>
		<td class="rtCRUFdValue">&nbsp;</td>
	</tr>
	<%
		}
	%>
	<tr class="ali4">
		<td colspan="4"><input type="submit" onclick="classicQuery()"
			name="search" value="查询" class="iButton2" /> <input type="reset"
			name="reset" value="清除" onclick="clearQueryCdt()" class="iButton2" /></td>
	</tr>
</table>
</div>
<table border="0" cellpadding="0" cellspacing="0"
	class="Tab_new_mod_del">
	<tr class="ali7">
		<td><input class="iButton2" type="button" value="审核通过"
			functionId="F_EM_HUMAN_032" onClick="JcdpButton0OnClick()"> <input
			class="iButton2" type="button" value="审核不通过"
			functionId="F_EM_HUMAN_032" onClick="JcdpButton1OnClick()"></td>
	</tr>
</table>
<!--Remark 查询指示区域-->
<div id="rtToolbarDiv">
<table border="0" cellpadding="0" cellspacing="0" class="rtToolbar"
	width="100%">
	<tr>
		<td align="right"><span id="dataRowHint">第0/0页,共0条记录 </span>
		<table id="navTableId" border="0" cellpadding="0" cellspacing="0"
			style="display: inline">
			<tr>
				<td><img
					src="<%=contextPath%>/images/table/firstPageDisabled.gif"
					style="border: 0" alt="First" /></td>
				<td><img
					src="<%=contextPath%>/images/table/prevPageDisabled.gif"
					style="border: 0" alt="Prev" /></td>
				<td><img
					src="<%=contextPath%>/images/table/nextPageDisabled.gif"
					style="border: 0" alt="Next" /></td>
				<td><img
					src="<%=contextPath%>/images/table/lastPageDisabled.gif"
					style="border: 0" alt="Last" /></td>
			</tr>
		</table>
		<span>到&nbsp;<input type="text" id="changePage"
			class="rtToolbar_chkboxme">&nbsp;页<a
			href='javascript:changePage()'><img
			src='<%=contextPath%>/images/table/bullet_go.gif' alt='Go'
			align="absmiddle" /></a></span></td>
	</tr>
</table>
</div>

<div id="resultable" style="width: 100%; overflow-x: scroll;">
<table border="0" cellspacing="0" cellpadding="0" class="form_info"
	width="100%" id="queryRetTable">
	<thead>

		<tr class="bt_info">
			<td class="tableHeader"
				exp="<input type='checkbox' name='chx_entity_id' onclick=doCheck(this) value='{relation_no}-{locked_if}'>"><input
				type='checkbox' id='headChxBox' onclick="head_chx_box_changed(this)"></td>
			<td class="tableHeader" exp="{locked_if_name}">审核状态</td>
			<td class="tableHeader" exp="{employee_cd}">员工编号</td>
			<%
				if (orgSubjectionId != null && orgSubjectionId.length() > 9
						&& orgSubjectionId.substring(0, 10).equals("C105001005")) {
			%>
			<td class="tableHeader" exp="{spare2}">职工编号</td>
			<%
				}
			%>
			<td class="tableHeader" exp="{employee_name}">姓名</td>
			<td class="tableHeader" exp="{project_name}">项目名称</td>
			<td class="tableHeader" exp="{team_name}">班组</td>
			<td class="tableHeader" exp="{work_post_name}">岗位</td>
			<td class="tableHeader" exp="{plan_start_date}">计划进入项目时间</td>
			<td class="tableHeader" exp="{plan_end_date}">计划离开项目时间</td>
			<td class="tableHeader" exp="{actual_start_date}">实际进入项目时间</td>
			<td class="tableHeader" exp="{actual_end_date}">实际离开项目时间</td>
			<td class="tableHeader" exp="{sub_date}">参与项目天数</td>
			<td class="tableHeader" exp="{project_evaluate}">人员评价</td>
		</tr>
	</thead>
	<tbody>

	</tbody>
</table>
</div>
</body>
</html>



<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.bgp.mcs.service.rm.em.humanRequired.pojo.*"%>

<%
	String contextPath = request.getContextPath();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	

	
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

var currentCount=parseInt('0');
var deviceCount = parseInt('0');
//新增班组option
var apply_str="<%=apply_str%>";
//选择申请人
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

//选择项目
function selectTeam(){
	
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/rm/em/humanLabor/selectProject.lpmd',teamInfo);
    if(teamInfo.fkValue!=""){
        document.getElementById("projectInfoNo").value = teamInfo.fkValue;
        document.getElementById("projectName").value = teamInfo.value;
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
		alert("实际离开项目时间应大于实际进入项目时间");
		return false;
	}else{
		return true;
	}
	}
	return true;
}

function sucess() {

	if(currentCount==0){
		alert("请添加一条人员信息后再点击保存");
		return ;
	}
	if(checkForm()){
	var form = document.getElementById("CheckForm");
	form.action = "<%=contextPath%>/rm/em/savehumanProjectRelat.srq";
	form.submit();
	alert('保存成功');
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
			if(!notNullForCheck("fy"+i+"employeeId","姓名")) return false;
				
		if(!calDays(i))return false;
		
		}
		//var projectEvaluate = document.getElementById("fy"+i+"projectEvaluate").value;
	//	var sprojectEvaluate = encodeURI(encodeURI(projectEvaluate));
		//alert(sprojectEvaluate);
	}

	if(!notNullForCheck("projectInfoNo","项目名称")) return false;

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


//联动调用函数
function getApplyPostList( id ){

    var applyTeam = "applyTeam="+document.getElementById("fy"+id+"team").value;   
	var applyPost=jcdpCallService("HumanLaborMessageSrv","queryApplyPostList",applyTeam);	

	var selectObj = document.getElementById("fy"+id+"workPost");
	document.getElementById("fy"+id+"workPost").innerHTML="";
	selectObj.add(new Option('请选择',""),0);
	if(applyPost.detailInfo!=null){
	for(var i=0;i<applyPost.detailInfo.length;i++){
		var templateMap = applyPost.detailInfo[i];
		selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	}
	}
}

//加一行人员
function addDevice(){

    //添加tr
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

	
    //需求子表id,为空
	var td = tr.insertCell(0);
	td.className=classCss+"odd";
	
	td.innerHTML  = currentCount+1+'<input type="hidden" id="fy'+deviceCount+'relationNo" name="fy'+deviceCount+'relationNo" value=""/>';

	var td = tr.insertCell(1);
	td.className=classCss+"even";
	td.innerHTML  = '<input type="hidden" readonly="readonly" maxlength="32" id="fy'+deviceCount+'employeeId" name="fy'+deviceCount+'employeeId" value="" class="input_width" />'+'<input type="text" readonly="readonly" maxlength="32" id="fy'+deviceCount+'employeeName" name="fy'+deviceCount+'employeeName" value="" class="input_width" />'+'<img src="'+'<%=contextPath%>'+'/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectPerson('+deviceCount+')"  />';
	//请选择
	var td = tr.insertCell(2);
	td.className=classCss+"odd";
	td.innerHTML ='<select id="fy'+deviceCount+'team" name="fy'+deviceCount+'team" class="select_width" onchange="getApplyPostList('+deviceCount+')" >'+apply_str+'</select>';
	//请选择
	var td = tr.insertCell(3);
	td.className=classCss+"even";
	td.innerHTML = '<select id="fy'+deviceCount+'workPost" name="fy'+deviceCount+'workPost" class="select_width"> <option value="">请选择</option> </select>';

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
	td.innerHTML = '<input type="text" maxlength="32" id="fy'+deviceCount+'projectEvaluate" name="fy'+deviceCount+'projectEvaluate"  value="" class="input_width" />';	
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

	//删除后重新排列序号
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
<title>人员项目经历新增</title>
</head>
<body >
 
 
<form id="CheckForm1" name="Form0" action="" method="post" target="list" >
<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%"   >

	<tr >
		<td class="inquire_item4" ><font color=red>*</font>&nbsp;项目名称：</td>
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
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    <td><span class="zj"  ><a href="#" onclick="addDevice()"></a></span></td>
  </tr>
</table>
</td>
    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
  </tr>
</table>
  
<table border="0" cellspacing="0" cellpadding="0" class="tab_info" width="100%" id="equipmentTableInfo"   >
	<tr  >
		<TD class="bt_info_odd" width="3%">序号</TD>
		<TD class="bt_info_even" width="9%"><font color=red>*</font>姓名</TD>
		<TD class="bt_info_odd" width="12%">班组</TD>
		<TD class="bt_info_even" width="12%">岗位</TD>

		<TD class="bt_info_odd" width="12%">预计进入项目时间</TD>
		<TD class="bt_info_even" width="12%">预计离开项目时间 </TD>
		<TD class="bt_info_odd" width="12%">实际进入项目时间</TD>
		<TD class="bt_info_even" width="12%">实际离开项目时间 </TD>
		<TD class="bt_info_odd" width="10%">人员评价 
		<input type="hidden" id="equipmentSize" name="equipmentSize" value="0" />
		<input type="hidden" id="hidDetailId" name="hidDetailId" value=""/>
		<input type="hidden" id="deleteRowFlag" name="deleteRowFlag" value="" /></TD>
		<TD class="bt_info_even" width="3%">操作	</TD>
	</tr>

</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0"   >
<tr>
 
  <td background="<%=contextPath%>/images/list_15.png" >
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr align="right">
  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </td>
  <td  >
  <span class="tj" ><a href="#" onclick="sucess();newClose();"></a></span>
  <span class="gb"><a href="#" onclick="newClose();"></a></span>
  </td>
</tr>
</table>
</td>
 
</tr>
</table>

</form> 
</body>
</html>
