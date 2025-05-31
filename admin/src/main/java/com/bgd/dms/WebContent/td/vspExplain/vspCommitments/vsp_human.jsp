<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/js/bgpmcs/DivHiddenOpen.js"></script>
<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>
<%@ include file="/common/pmd_list.jsp"%>
<title>列表页面</title>
</head>
<script language="javaScript">
<!--Remark JavaScript定义-->
var pageTitle = "正式工页面";
cruConfig.contextPath =  "<%=contextPath%>";
var genderOps = new Array(
['0','女'],['1','男']
);

var jcdp_codes_items = null;
var jcdp_codes = new Array(
);


function page_init(){ 
	cruConfig.cdtType = 'form'; 
	cruConfig.queryStr = " select distinct e.employee_id,hr.employee_cd,case  when hr.employee_cd is not null then  '正式工' else '' end  as type_s ,e.employee_name, e.employee_gender,decode(e.employee_gender, '1', '男', '0', '女','2','女')employee_gender_name,e.employee_id_code_no, hr.post as posts, d1.coding_name post_level_name   from comm_human_employee e  inner join comm_human_employee_hr hr on e.employee_id = hr.employee_id   and hr.bsflag='0'  left join comm_coding_sort_detail d1 on hr.post_level = d1.coding_code_id and d1.bsflag = '0' left join comm_org_information cn on cn.org_id= hr.second_org  left join comm_org_subjection so on so.org_id=cn.org_id  and so.bsflag='0'  where e.bsflag = '0' and so.ORG_SUBJECTION_ID like 'C105005001%'  ";
	cruConfig.currentPageUrl = "/rm/em/humanAttendance/selectHuman.jsp";
	queryData(1);
}

var fields = new Array();
 
	
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

	var employee_name = document.getElementById("employee_name").value; 
	var employee_gender= document.getElementById("employee_gender").value; 
	employee_name = employee_name ? employee_name : "";
	employee_gender = employee_gender ? employee_gender : "";
	debugger;
	cruConfig.cdtType = 'form';
	cruConfig.queryStr =  " select * from ( select distinct e.employee_id,hr.employee_cd,case  when hr.employee_cd is not null then  '正式工' else '' end  as type_s ,e.employee_name, e.employee_gender,decode(e.employee_gender, '1', '男', '0', '女','2','女')employee_gender_name,e.employee_id_code_no, hr.post as posts, d1.coding_name post_level_name   from comm_human_employee e  inner join comm_human_employee_hr hr on e.employee_id = hr.employee_id   and hr.bsflag='0'  left join comm_coding_sort_detail d1 on hr.post_level = d1.coding_code_id and d1.bsflag = '0'  left join comm_org_information cn on cn.org_id= hr.second_org  left join comm_org_subjection so on so.org_id=cn.org_id  and so.bsflag='0'  where e.bsflag = '0' and so.ORG_SUBJECTION_ID like 'C105005001%' ) ";
	if(employee_name!=""||employee_gender!=""){
		cruConfig.queryStr = cruConfig.queryStr + " where ";
		if(employee_name!=""){
			cruConfig.queryStr = cruConfig.queryStr + " employee_name like '%"+employee_name+"%'";
		}
		if(employee_name!=""&&employee_gender!=""){
			cruConfig.queryStr = cruConfig.queryStr + " and ";
		}
		if(employee_gender!=""){
			cruConfig.queryStr = cruConfig.queryStr + " employee_gender_name = '"+employee_gender+"'" ;
		}
	}
	cruConfig.currentPageUrl = "/rm/em/humanAttendance/selectHuman.jsp";
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
function JcdpButton0OnClick(){
	if(checked == ""){
		alert("请选择一条记录!");
		return;
	}
	window.returnValue = checked;
	window.close();  
}

function JcdpButton1OnClick(){
	window.returnValue = "";
	window.close(); 
}
</script>

<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
</head>
<body onload="page_init()">
<div id="queryDiv" style="display:">
<table  border="0" cellpadding="0" cellspacing="0" class="form_info" id="queryCdtTable" enctype="multipart/form-data">
<tr >
<td class="ali_cdn_name">姓名：</td>
 <td  ><input id="employee_name"    name="employee_name" type="text"   />	 
 </td>
<td class="ali_cdn_name">性别：</td>
<td  >
<select id="employee_gender" name="employee_gender"  >
<option value="" >请选择</option>
<option value="男" >男</option>
<option value="女" >女</option> 
</select>  
</td>
 </tr>
 
  <tr class="ali4">
    <td colspan="4"><input type="submit" onclick="classicQuery()" name="search" value="查询"  class="iButton2"/>  <input type="reset" name="reset" value="清除" onclick="clearQueryCdt()" class="iButton2"/></td>
  </tr>  
</table>
</div>
</div>
<div id="lidiv" >
<table  border="0" cellpadding="0" cellspacing="0" class="Tab_new_mod_del">
  <tr class="ali7">
    <td>
		<input class="iButton2" type="button" value="保存" onClick="JcdpButton0OnClick()">
		<input class="iButton2" type="button" value="返回" onClick="JcdpButton1OnClick()">
    </td>
  </tr>
</table>
</div>
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
   	    <td class="tableHeader" 	 exp="<input type='radio' name='chx_entity_id'  value='{employee_id}-{employee_name}-{employee_gender}-{employee_id_code_no}-{posts}-{employee_cd}-{type_s}' onclick=doCheck(this) />"></td>
		<td class="tableHeader" 	 exp="{employee_id}" isShow="TextHide" style="display:none">employee_id</td>
		<td class="tableHeader" 	 exp="{type_s}">用工类别</td>
		<td class="tableHeader" 	 exp="{employee_name}">姓名</td>
		<td class="tableHeader" 	 exp="{employee_gender_name}">性别</td>
		<td class="tableHeader" 	 exp="{posts}">岗位</td>
		<td class="tableHeader" 	 exp="{employee_cd}">编号</td>
		
	</tr>
	</thead>
	<tbody>
	
	</tbody>
</table>
</div>
</body>
</html>
