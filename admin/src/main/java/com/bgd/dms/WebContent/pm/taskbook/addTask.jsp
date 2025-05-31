<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%
    String contextPath = request.getContextPath();
    UserToken user = OMSMVCUtil.getUserToken(request);
    String projectInfoNo = user.getProjectInfoNo();
    String root_folderId = projectInfoNo;
    String projectName = user.getProjectName();
    String orgSubId=user.getOrgSubjectionId();
	if(orgSubId.startsWith("C105007")){
		response.sendRedirect(contextPath+"/pm/taskbook/addDgTask.jsp");
	}
    if(projectName==null){
    	projectName = "";
    }
    
  	String projectType = user.getProjectType() ; 
  	
  	//滩浅海项目（任务书类型选项要增加2项：气枪、试验），编码管理中添加，以便后期维护-----顾西炳 2013.10.24
	String sql =   " select substr(t.coding_code_id,length(t.coding_code_id),1) as coding_code_id_shot,"+
				   " t.*,t.rowid from comm_coding_sort_detail t where t.bsflag='0' " +
				   " and t.coding_code_id like '5110000058%' and t.coding_code_id not in " +
				   " ('5110000058000000009','5110000058000000010' ) order by t.coding_show_id asc " ;
  	if( null!=projectType && !"".equals(projectType) && ("5000100004000000002".equals(projectType) || "5000100004000000010".equals(projectType)) )
  	{
		sql = " select substr(t.coding_code_id,length(t.coding_code_id),1) as coding_code_id_shot,t.*,t.rowid "+
			  " from comm_coding_sort_detail t where t.bsflag='0' and t.coding_code_id like '5110000058%' order by t.coding_show_id asc" ;
  	}
	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>新增任务书</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/help.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/validator.js"></script>
<script>
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';

var projectInfoNo = "<%=projectInfoNo%>";
	
function forward()
{
	//window.location.href="index.html"
}
</script>
<script type="text/javascript">
var module_name = top.frames("topFrame").selectedTag.childNodes[0].innerHTML;
var module_id = top.frames("topFrame").selectedTag.childNodes[0].menuId;



function loadData(){
	var retObj = jcdpCallService("TaskBookSrv", "getProjectInfo", "");
	if(retObj.project != null){
		document.getElementById("workarea_name").value = retObj.project.workarea;
		document.getElementById("team_name").value = retObj.project.team_name;
	}
}

function checkForm() {
	return true;
}
	
function toSave(){
	if (!checkForm()) return;
	var form = document.forms[0];
	form.action="<%=contextPath%>/pm/gpe/saveTaskBook.srq";
	form.submit();
}

function cancle(){
}

function settaskname(){
	var lineId = document.getElementById("line_group_id").value;
	var selectObj = document.getElementById("work_type");
	var index = selectObj.selectedIndex;
	var taskType = selectObj.options[index].text;
	var taskName = taskType + "任务书（" + lineId + "）";
	document.getElementById("task_name").value = taskName;
	document.getElementById("receive_name").value = taskType+"组";
	document.getElementById("send_name").value = "解释组";
}

function selectFolder(){
	var folder_info={
        fkValue:"",
		value:""
	};
	if(checkModuleID(module_id,projectInfoNo) == 0){
		window.showModalDialog('<%=contextPath%>/doc/common/select_folder_project.jsp?project_info_no=<%=root_folderId%>',folder_info);
	}else if(checkModuleID(module_id,projectInfoNo) == 1){
		window.showModalDialog('<%=contextPath%>/doc/common/select_folder.jsp?project_info_no=<%=root_folderId%>&moduleID='+module_id,folder_info);
	}
	document.getElementsByName("select_folder")[0].value = folder_info.value;
	document.getElementsByName("folder_id")[0].value = folder_info.fkValue;
	generateFileNumber(folder_info.fkValue);
}
	
function checkModuleID(moduleId,projectNo){
	var querySql = "Select * FROM bgp_doc_folder_module b WHERE b.module_id = '"+moduleId+"' and b.bsflag='0' and b.project_info_no ='"+projectNo+"'";
	var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
	if(queryOrgRet.datas.length == 0){
		return 0;
	}else{
		return 1;
	}
}
</script>
<link href="table.css" rel="stylesheet" type="text/css" />
</head>

<body onload="loadData()">
<form id="CheckForm" name="form1" enctype="multipart/form-data" action="" method="post" >
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height">
  	<tr>
   <td class="inquire_item4"><font color="red">*</font>&nbsp;项目信息：</td>
   <td class="inquire_form4">
   <input type="hidden" name="object_id" value=""/>
   <input type="hidden" name="project_info_no" value="<%=projectInfoNo%>"/>
   <input id="line_group_id" name="line_group_id" type="text" value="<%=projectName %>" class="input_width" onchange="settaskname()"/>
   </td>
   <td class="inquire_item4">任务书类型：</td>
   <td class="inquire_form4">
   <!-- 
		<select id="work_type" name="work_type" onchange="settaskname()">
			<option value="1">测量</option>
			<option value="2">表层调查（微测井）</option>
			<option value="3">表层调查（小折射）</option>
			<option value="4">钻井</option>
			<option value="5">放线</option>
			<option value="6">爆炸班</option>
			<option value="7">震源</option>
			<option value="8">仪器</option>
		</select>
	 -->	
		<select name="work_type" id="work_type" class="select_width" onchange="settaskname()">
			<option value="">请选择</option>
		<%if(list!=null&&list.size()>0)
		{
			for(int i=0;i<list.size();i++)
			{
				Map map = (Map)list.get(i);
				String coding_name = (String)map.get("codingName");
				String coding_code_id_shot = (String)map.get("codingCodeIdShot");
		 %>
			<option value="<%=coding_code_id_shot%>"><%=coding_name %></option>
		<%
			}
		}
		%>
		</select>
   </td>
  </tr>
  <tr>
   <td class="inquire_item4">任务书名称：</td>
   <td class="inquire_form4"><input id="task_name" name="name" type="text" value=""class="input_width" readonly/></td>
    <td class="inquire_item4">工&nbsp;&nbsp;区：</td>
    <td class="inquire_form4">
    <input id="workarea_name" name="workarea_name" type="text" value="" class="input_width"  /></td>
  </tr>
   <tr>
  	<td class="inquire_item4">队&nbsp;&nbsp;号：</td>
    <td class="inquire_form4">
    	<input id="team_name" name="team_name" type="text" value="" class="input_width" readonly/></td>
    </td>
	 <td class="inquire_item4">下达日期：</td>
	 <td class="inquire_form4"><input name="produce_date" type="text" value="" class="input_width" readonly/>
	 <img src="<%=contextPath%>/images/calendar.gif" id="tbutton3" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(produce_date,tbutton3);"/>
	 </td>
  </tr>
  <tr>
     <td class="inquire_item4">接收任务班组：</td>
     <td class="inquire_form4"><input id="receive_name" name="receive_name" type="text" value="" class="input_width"/></td>
     <td class="inquire_item4">下达任务班组：</td>
     <td class="inquire_form4" colspan="3"><input id="send_name" name="send_name" type="text" value="" class="input_width"/></td>
  </tr>
  <tr>
     <td class="inquire_item4">选择目录：</td>
     <td class="inquire_form4">
     	<input type="text" name="select_folder" class="input_width" readonly="readonly"/>
      	<img style="cursor: hand;" src="<%=contextPath%>/images/magnifier.gif" onclick="selectFolder()" />	
      	<input type="hidden" name="folder_id"/>
     </td>
     <td class="inquire_item4">文档：</td>
     <td class="inquire_form4" colspan="3">
     	<input type="file" name="doc_content" id="doc_content" onchange="getFileInfo()" class="input_width"/>
     </td>
  </tr>  
</table>
  </div>
  <div id="oper_div">
   	<span class="tj_btn"><a href="#" onclick="toSave()"></a></span>
    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
  </div>
</div></div>
</form>
<script type="text/javascript">
autoSelectFolder();
function autoSelectFolder(){
	var querySql1 = "select f.file_id,f.file_name from bgp_doc_gms_file f where f.bsflag = '0' and f.is_file <> '1' and f.file_abbr = 'SCRWS' and f.project_info_no = '"+projectInfoNo+"'";
	var queryOrgRet1 = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql1);
	if(queryOrgRet1.datas!=null && queryOrgRet1.datas.length == 1){
		document.getElementsByName("select_folder")[0].value = queryOrgRet1.datas[0].file_name;
		document.getElementsByName("folder_id")[0].value =  queryOrgRet1.datas[0].file_id;
	}else{
		alert("没有生产任务书这个文件夹!");
		return;
	}
}
</script>
</body>
</html>