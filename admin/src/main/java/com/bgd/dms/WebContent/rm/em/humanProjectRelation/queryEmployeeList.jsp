<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubjectionId = user.getOrgSubjectionId();
	String subOrgIDofAffordOrg = user.getSubOrgIDofAffordOrg();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/js/bgpmcs/DivHiddenOpen.js"></script>
<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>

<%@ include file="/common/pmd_list.jsp"%>
<%@ include file="/common/jspHeader.jsp"%>
<title>列表页面</title>
</head>
<script language="javaScript">
<!--Remark JavaScript定义-->
var pageTitle = "人员基本信息";
cruConfig.contextPath =  "<%=contextPath%>";
var jcdp_codes_items = null;
var jcdp_codes = new Array(
['postLevel','职位级别',"SELECT t.coding_code_id AS value, t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id = '0110000022' and t.bsflag = '0' order by t.coding_show_id"],
['employeeEducationLevel','文化程度',"SELECT t.coding_code_id AS value, t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id = '0500100004' and t.bsflag = '0' order by t.coding_show_id"]);

function viewLink(employeeId){
    editUrl = "/rm/em/humanCommInfoAction.srq?employeeId="+employeeId; 
    window.location=cruConfig.contextPath+editUrl+"&backUrl="+cruConfig.currentPageUrl; 
}

function viewLinkReport(){
	
	if(checked == ""){
		alert("请选择一条记录!");
		return;
	}
	var checks = checked.split(",");
	if(checks.length-1 > 1){
		alert("请选择一条记录!");
		return;
	}
	window.showModalDialog('<%=contextPath%>/rm/em/humanPlant/humanReport/commhumanInfoReport.jsp?employeeId='+checks[0],"","dialogHeight:600px;dialogWidth:800px");

}

function JcdpButton0OnClick(){
	ids = getSelIds('chx_entity_id');
    if(ids==''){ alert("请先选中一条记录!");
     return;
    } 
    var tempa = ids.split(',');
    var obj = window.dialogArguments;
	obj.fkValue =tempa[0];
	obj.value = tempa[1];
	window.close();
}
function queryData(targetPage){
	cruConfig.currentPage = targetPage;

	var submitStr = "currentPage="+targetPage+"&pageSize="+cruConfig.pageSize;
	if(cruConfig.funcCode!='') submitStr += "&EP_DATA_AUTH_funcCode="+cruConfig.funcCode;

	var retObject;
	//alert(cruConfig.queryService);
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
var queryListAction = "/tcg/ajaxServiceProxyAction.srq?JCDP_SRV_NAME=HumanCommInfoSrv&JCDP_OP_NAME=queryCommHumanInfoPagesize&funcCode=F_EM_HUMAN_001&pageSize=4&params=";

function page_init(){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.funcCode = "F_EM_HUMAN_001";
	cruConfig.pageSize=5;
	cruConfig.cdtType = 'form';
	cdt_init();
	
	appConfig.queryListAction = queryListAction;	
	//cruConfig.queryStr = "select   hr.employee_cd,                 e.employee_id,                 e.org_id,                 e.employee_name,                 decode(e.employee_gender, '0', '女', '1', '男') employee_gender_name,                 (to_char(sysdate, 'YYYY') - to_char(e.employee_birth_date, 'YYYY')) age,                 hr.work_date,                 i.org_name,                 hr.post,                 hr.post_level,                 d1.coding_name post_level_name,                 e.employee_education_level,                 d2.coding_name employee_education_level_name,                 s.org_subjection_id,                 hr.spare2   from comm_human_employee e  inner join comm_human_employee_hr hr on e.employee_id = hr.employee_id   left join comm_org_subjection s on e.org_id = s.org_id                                  and s.bsflag = '0'   left join comm_org_information i on e.org_id = i.org_id                                   and i.bsflag = '0'   left join comm_coding_sort_detail d1 on hr.post_level =                                           d1.coding_code_id                                       and d1.bsflag = '0'   left join comm_coding_sort_detail d2 on e.employee_education_level =                                           d2.coding_code_id                                       and d2.bsflag = '0'  where e.bsflag = '0'  order by e.org_id";
	cruConfig.queryStr = "";
	cruConfig.currentPageUrl = "/rm/em/humanPlant/commHumanInfo/commHumanInfo.jsp";
	classicQuery();
}

var fields = new Array();
fields[0] = ['employee_cd','员工编号','TEXT'];
fields[1] = ['employee_name','姓名','TEXT'];

	
function basicQuery(){
	var qStr = generateBasicQueryStr();
	cruConfig.cdtStr = qStr;
	queryData(1);
}


function cmpQuery(){
	var qStr = generateCmpQueryStr();
	cruConfig.cdtStr = qStr;
	queryData(1);
}

function classicQuery(){
	
	var qStr = generateClassicQueryStr();

	var orgId=document.getElementById("orgId").value;
	var post=document.getElementById("post").value;
	
	if(qStr==""){
		qStr+=" and (1=1";
	}else{
		qStr = " and " + qStr;
		qStr+=" and (1=1";
	}
	if(orgId!=""){
		qStr=qStr +" and org_subjection_id  like '"+orgId+"%'";
	}
	if(post!=""){
		qStr=qStr +" and post  like '%"+post+"%'";
	}
	qStr+=" )";
	appConfig.queryListAction = queryListAction + encodeURI(encodeURI(qStr));
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

//选择组织机构
function selectOrg(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
        document.getElementById("orgId").value = teamInfo.fkValue;
        document.getElementById("orgName").value = teamInfo.value;
    }
}

function expData(){
	
	var orgId = "";
	if(document.getElementById("orgId").value != ""){
		orgId=document.getElementById("orgId").value;
	}else{
		orgId="<%=subOrgIDofAffordOrg%>";
	}
	window.location.href = "<%=contextPath%>/gpe/team/expDataToExcel.do?fullPath=<%=fullPath%>&moduleNo=0019&orgId="+orgId;
}
</script>

<script type="text/javascript" src="/BGPMCS/js/calendar.js"></script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
<script type="text/javascript" src="/BGPMCS/js/calendar-setup.js"></script>
</head>
<body onload="page_init()">
<div id="queryDiv" style="display:">
<table  border="0" cellpadding="0" cellspacing="0" class="form_info" id="queryCdtTable" enctype="multipart/form-data">
<!--此处开发人员可添加查询条件-->
	<tr class="even">
		<td class="rtCRUFdName">组织机构：</td>
		<td class="rtCRUFdValue">
		<input type="hidden" value="" id="orgId" name="orgId"></input>
		<input type="text" value="" id="orgName" name="orgName" class='input_width' readonly="readonly"></input>
		<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
		</td>
		<td class="rtCRUFdName">&nbsp;岗位</td>
		<td class="rtCRUFdValue"><input type="text"  class='input_width' id="post" name="post" value=""/></td>	
	</tr>
  <tr class="ali4">
    <td colspan="4"><input type="submit" onclick="classicQuery()" name="search" value="查询"  class="iButton2"/>  <input type="reset" name="reset" value="清除" onclick="clearQueryCdt()" class="iButton2"/></td>
  </tr>  
</table>
</div>


<table  border="0" cellpadding="0" cellspacing="0" class="Tab_new_mod_del">
  <tr class="ali7">
    <td>
		<input class="iButton2" type="button" value="确认" onClick="JcdpButton0OnClick()">
    </td>
  </tr>
</table>

<!--Remark 查询指示区域-->
<div id="rtToolbarDiv">
<table border="0"  cellpadding="0"  cellspacing="0"  class="rtToolbar"  width="100%" >
	<tr>
		<td align="right" >
			<span id="dataRowHint">第0/0页,共0条记录 </span>
			<table id="navTableId" border="0"  cellpadding="0"  cellspacing="0" style="display:inline">
				<tr>
					<td><img src="<%=contextPath%>/images/table/firstPageDisabled.gif"  style="border:0"  alt="First" /></td>
					<td><img src="<%=contextPath%>/images/table/prevPageDisabled.gif"  style="border:0"  alt="Prev" /></td>
					<td><img src="<%=contextPath%>/images/table/nextPageDisabled.gif"  style="border:0"  alt="Next" /></td>
					<td><img src="<%=contextPath%>/images/table/lastPageDisabled.gif"  style="border:0"  alt="Last" /></td>				
				</tr>
			</table>
			<span>到&nbsp;<input type="text"  id="changePage"  class="rtToolbar_chkboxme">&nbsp;页<a href='javascript:changePage()'><img src='<%=contextPath%>/images/table/bullet_go.gif' alt='Go' align="absmiddle" /></a></span>		
		</td>
	</tr>
</table>
</div>

<div id="resultable"  style="width:100%; overflow-x:scroll ;" >
<table border="0"  cellspacing="0"  cellpadding="0"  class="form_info"  width="100%" id="queryRetTable">
	<thead>

	<tr class="bt_info">
		<td class="tableHeader" 	 exp="<input type='radio' name='chx_entity_id' value='{employeeId},{employeeName}' id='chx_entity_id_{employeeId}'\>"><input type='radio' id='headChxBox' onclick="head_chx_box_changed(this)"></td>
		<td class="tableHeader" 	 exp="{employeeName}">姓名</td>
		<td class="tableHeader" 	 exp="{employeeCd}">人员编号</td>
		<td class="tableHeader" 	 exp="{employeeGenderName}">性别</td>
		<td class="tableHeader" 	 exp="{orgName}">组织机构</td>
		<td class="tableHeader" 	 exp="{postLevelName}">职位级别</td>
		<td class="tableHeader" 	 exp="{employeeEducationLevelName}">文化程度</td>		
	</tr>
	</thead>
	<tbody>
	
	</tbody>
</table>
</div>
</body>
</html>
