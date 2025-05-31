<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getEmpId();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());

    String action = request.getParameter("action")==null?"":request.getParameter("action");
    String addButtonDisplay="";
    if("view".equals(action)) addButtonDisplay="none";
    String projectInfoNo = request.getParameter("projectInfoNo")==null?"":request.getParameter("projectInfoNo");
    String projectType = request.getParameter("projectType")==null?"":request.getParameter("projectType");
    //是否项目资源配置中录入
    String resourceFlag = request.getParameter("resourceFlag")==null?"":request.getParameter("resourceFlag");
    //项目补充资源配置主表ID
    String planId = request.getParameter("planId")==null?"":request.getParameter("planId");
   
   String shenText=request.getParameter("shenText")==null?"":request.getParameter("shenText");
   String viewId=request.getParameter("id")==null?"":request.getParameter("id");
 
     if( viewId != null && !"".equals(viewId)){
    	 addButtonDisplay="none";
     }
   
   String mid=request.getParameter("mid")==null?"":request.getParameter("mid");
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
var cruTitle = "资格证信息";
var projectInfoNo="<%=projectInfoNo%>";
var projectType="<%=projectType%>";
var mid="<%=mid%>";
 
function notNullForCheck(filedName,fieldInfo){
	if(document.getElementById(filedName).value==null||document.getElementById(filedName).value==""){
		alert(fieldInfo+"不能为空");
		document.getElementById(filedName).onfocus="true";
		return false;
	}else{
		return true;
	}
}

function checkForm(){
	var rowNum = document.getElementById("lineNum").value;	
	var isCheck=true;
	for(var i=0;i<rowNum;i++){
		var bsflag = document.getElementById("bsflag_"+i).value;
		if(bsflag == "0"){
			isCheck=false;
			if(!notNullForCheck("apply_team_"+i,"班组")) return false;
			if(!notNullForCheck("post_"+i,"岗位")) return false;
			if(!notNullForCheck("people_number_"+i,"人数")) return false;
			//if(!notNullForCheck("plan_start_date_"+i,"计划进入时间")) return false;
			//if(!notNullForCheck("plan_end_date_"+i,"计划离开时间")) return false;
		}
	}

	if(isCheck){
		alert("请添加一条记录");
		return false;
	}else{
		return true;
	}

}

function save(){
	if(checkForm()){
	var rowNum = document.getElementById("lineNum").value;	
	var rowParams = new Array();
	var planId = jcdpCallService("HumanCommInfoSrv","submitSupplyHumanPlanZh","projectInfoNo="+projectInfoNo+"&mid="+mid);
	
	for(var i=0;i<rowNum;i++){
		var rowParam = {};
						
		var plan_detail_id = document.getElementsByName("plan_detail_id_"+i)[0].value;
		var apply_team = document.getElementsByName("apply_team_"+i)[0].value;			
		var post = document.getElementsByName("post_"+i)[0].value;			
		var people_number = document.getElementsByName("people_number_"+i)[0].value;			
		//var profess_number = document.getElementsByName("profess_number_"+i)[0].value;			
		var plan_start_date = document.getElementsByName("plan_start_date_"+i)[0].value;			
		var plan_end_date = document.getElementsByName("plan_end_date_"+i)[0].value;			
		var notes = document.getElementsByName("notes_"+i)[0].value;			
		var bsflag = document.getElementsByName("bsflag_"+i)[0].value;			

		rowParam['project_info_no'] = projectInfoNo;		
		rowParam['bsflag'] = bsflag;
		if(plan_detail_id!=null&&plan_detail_id!=""){
			rowParam['plan_detail_id'] = plan_detail_id;
			//alert("是空");
		}		
		rowParam['apply_team'] = apply_team;
		rowParam['post'] = post;
		rowParam['people_number'] = people_number;
		//rowParam['profess_number'] = profess_number;
		rowParam['plan_start_date'] = plan_start_date;
		rowParam['plan_end_date'] = plan_end_date;
		rowParam['notes'] = encodeURI(encodeURI(notes));
		rowParam['create_date'] = '<%=curDate%>';
		rowParam['modifi_date'] = '<%=curDate%>';
		//是否项目资源配置录入的数据
		rowParam['resourceflag'] = '<%=resourceFlag%>';
		//项目补充资源配置主表ID
		rowParam['spare1'] = planId.planId;
		
		rowParams[rowParams.length] = rowParam;
	}
		var rows=JSON.stringify(rowParams);
		saveFunc("bgp_comm_human_plan_detail",rows);	
		//项目补充资源刷新父窗口
		if(""!=planId.planId){
			top.frames[5].refreshData();
		}else{
			top.frames('list').frames('mainRightframe').refreshData(projectInfoNo);
			newClose();
		}
	}
	//parent.list.frames[1].location.reload();
	top.frames('list').frames('mainRightframe').refreshData(projectInfoNo);
	newClose();
	
}


function deleteLine(lineId){		
	var rowNum = lineId.split('_')[1];
	var line = document.getElementById(lineId);		

	var bsflag = document.getElementsByName("bsflag_"+rowNum)[0].value;
	if(bsflag!=""){
		line.style.display = 'none';
		document.getElementsByName("bsflag_"+rowNum)[0].value = '1';
	}else{
		line.parentNode.removeChild(line);
	}	

}



function addLine( plan_detail_ids, apply_teams, posts, people_numbers,plan_start_dates, plan_end_dates, numss, notess){
	var plan_detail_id = "";
	var apply_team = "";
	var post = "";
	var people_number = "";
	//var profess_number = "";
	var plan_start_date = "";
	var plan_end_date = "";
	var nums = "";
	var notes = "";

	if(plan_detail_ids != null && plan_detail_ids != ""){
		plan_detail_id=plan_detail_ids;
	}
	if(apply_teams != null && apply_teams != ""){
		apply_team=apply_teams;
	}
	if(posts != null && posts != ""){
		post=posts;
	}
	if(people_numbers != null && people_numbers != ""){
		people_number=people_numbers;
	}
	//if(profess_numbers != null && profess_numbers != ""){
	//	profess_number=profess_numbers;
	//}
	if(plan_start_dates != null && plan_start_dates != ""){
		plan_start_date=plan_start_dates;
	}
	if(plan_end_dates != null && plan_end_dates != ""){
		plan_end_date=plan_end_dates;
	}
	if(numss != null && numss != ""){
		nums=numss;
	}	
	if(notess != null && notess != ""){
		notes=notess;
	}
	

	var rowNum = document.getElementById("lineNum").value;	

	var tr = document.getElementById("lineTable").insertRow();
	
	tr.align="center";		

	tr.id = "row_" + rowNum + "_";
	
	if(rowNum % 2 == 1){  
  		classCss = "even_";
	}else{ 
		classCss = "odd_";
	}

	var startDates = "plan_start_date_"+rowNum;
	var endDates = "plan_end_date_"+rowNum;

	
	var td = tr.insertCell(0);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="hidden" name="plan_detail_id' + '_' + rowNum + '" id="plan_detail_id' + '_' + rowNum + '" value="'+plan_detail_id+'"/>'+(parseInt(rowNum) + 1);
		
	var td = tr.insertCell(1);
	td.className=classCss+"even";
	td.innerHTML = '<select class="input_width" id="apply_team' + '_' + rowNum + '" name="apply_team' + '_' + rowNum + '" onchange="getPost('+rowNum+')" >'+getApplyTeam(apply_team)+'</select>';

	if(post == ""){
		//请选择			
		var td = tr.insertCell(2);
		td.className=classCss+"odd";
		td.innerHTML = '<select class="input_width"  name="post' + '_' + rowNum + '" id="post' + '_' + rowNum + '" > <option value="">请选择</option> </select>';
	}else{	
		//选择岗位值
		var td = tr.insertCell(2);
		td.className=classCss+"odd";
		td.innerHTML = '<select class="input_width" name="post' + '_' + rowNum + '" id="post' + '_' + rowNum + '" >'+getPostForList(apply_team,post)+'</select>';
	}
		
	var td = tr.insertCell(3);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" class="input_width" id="people_number' + '_' + rowNum + '" name="people_number' + '_' + rowNum + '" value="'+people_number+'" onpropertychange="if(isNaN(value)) value=value.substring(0,value.length-1);" />';
	
	var td = tr.insertCell(4);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" class="input_width"   readonly="readonly" onpropertychange="calDays('+rowNum+')" id="plan_start_date' + '_' + rowNum + '"  name="plan_start_date' + '_' + rowNum + '" value="'+plan_start_date+'" />'+'<img src="<%=contextPath%>/images/calendar.gif" id="tributton1'+rowNum+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+startDates+',tributton1'+rowNum+');" />';
	
	var td = tr.insertCell(5);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" class="input_width"  readonly="readonly"  onpropertychange="calDays('+rowNum+')"  id="plan_end_date' + '_' + rowNum + '" name="plan_end_date' + '_' + rowNum + '" value="'+plan_end_date+'" />'+'<img src="<%=contextPath%>/images/calendar.gif" id="tributton2'+rowNum+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+endDates+',tributton2'+rowNum+');" />';
	
	var td = tr.insertCell(6);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" class="input_width" readonly="readonly" id="nums' + '_' + rowNum + '" name="nums' + '_' + rowNum + '" value="'+nums+'" />';

	var td = tr.insertCell(7);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" class="input_width"  name="notes' + '_' + rowNum + '" id="notes' + '_' + rowNum + '" value="'+notes+'" />'+'<input type="hidden"  class="input_width" name="bsflag' + '_' + rowNum + '" id="bsflag' + '_' + rowNum + '" value="0"/>';
	
	var td = tr.insertCell(8);
	td.className=classCss+"even";
	
	var rowid = "row_" + rowNum + "_";
	td.innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/><img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine('+"'"+rowid+"'"+')"/>';
	document.getElementById("lineNum").value = (parseInt(rowNum) + 1);

}

function setSelectOn(it){
	it.className="input_width_list_on";
}
function setSelectOff(it){
	it.className="input_width_list";
}

function page_init(){
	var planId="<%=planId%>";
	var plan_detail_id = '<%=request.getParameter("id")==null?"":request.getParameter("id")%>';	
	if(plan_detail_id!='null'){
		var querySql = "select d.plan_detail_id,d.apply_team,s1.coding_name apply_team_name,d.post,s2.coding_name post_name,d.people_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date) nums,d.notes,d.profess_number "+
			"from bgp_comm_human_plan_detail d left join comm_coding_sort_detail s1 on d.apply_team=s1.coding_code_id and s1.bsflag='0' "+
			"left join comm_coding_sort_detail s2 on d.post=s2.coding_code_id and s2.bsflag='0' "+
			"where d.plan_detail_id='"+plan_detail_id+"' and d.bsflag='0' ";
		if(""!=planId){
			querySql+=" and d.spare1='"+planId+"' ";
		}else{
			querySql+=" and d.spare1 is null ";
		}
		querySql+="order by d.modifi_date ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		for (var i = 0; i<datas.length; i++) {	
			addLine(datas[i].plan_detail_id,datas[i].apply_team,datas[i].post,datas[i].people_number,datas[i].plan_start_date,datas[i].plan_end_date,datas[i].nums,datas[i].notes);
		}			
	}

}

function getPost(i){
    var applyTeam = "applyTeam="+document.getElementById("apply_team_"+i).value;   
	var applyPost=jcdpCallService("HumanCommInfoSrv","queryApplyPostList",applyTeam);	

	var selectObj = document.getElementById("post_"+i);
	document.getElementById("post_"+i).innerHTML="";
	selectObj.add(new Option('请选择',""),0);
	if(applyPost.detailInfo!=null){
		for(var i=0;i<applyPost.detailInfo.length;i++){
			var templateMap = applyPost.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
		}
	}
}

function toDownload(){
	var elemIF = document.createElement("iframe");  

	var iName ="项目资源人员配置";  
	iName = encodeURI(iName);
	iName = encodeURI(iName);
	var file="";
	if("5000100004000000009"==projectType){//综合物化探
		file="/rm/em/humanRequest/download.jsp?path=/rm/em/planning/importHumanPlan.xls";
	}else{
		file="/rm/em/humanRequest/download.jsp?path=/rm/em/singleHuman/humanPlan/importHumanPlanList.xls";
	}
	
	elemIF.src = "<%=contextPath%>"+file+"&filename="+iName+".xls";
	elemIF.style.display = "none";  
	document.body.appendChild(elemIF);  
}

function exportData(){
	var obj=window.showModalDialog("<%=contextPath%>/rm/em/planning/planImportFile.jsp","","dialogHeight:500px;dialogWidth:600px");
	if(obj!="" && obj!=undefined ){	
		//alert(obj);
		var checkStr = obj.split(",");	
				
		for (var i = 0; i<checkStr.length; i++) {	
			var check = checkStr[i].split("@");		
			//var days=(new Date(check[4].replace(/-/g,'/'))-new Date(check[3].replace(/-/g,'/')))/3600/24/1000+1;
			addLine("",check[0],check[1],check[2],check[3]==null?"":check[3],check[4]==null?"":check[4],"","");			
		}			
	}
}

function calDays(i){
	var startTime = document.getElementById("plan_start_date_"+i).value;
	var returnTime = document.getElementById("plan_end_date_"+i).value;
	if(startTime!=null&&startTime!=''&&returnTime!=null&&returnTime!=''){
		var days=(new Date(returnTime.replace(/-/g,'/'))-new Date(startTime.replace(/-/g,'/')))/3600/24/1000;
		if(days<0){
			alert("计划离开时间应大于计划进入时间");
			return false;
		}else{
			document.getElementById("nums_"+i).value = days+1;
			return true;
		}
	}
	return true;
}

</script>

</head>
<body onload="page_init();"  style="overflow-y:auto">
	<div id="inq_tool_box">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
	    <td background="<%=contextPath%>/images/list_15.png">
	    <table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr align="right">
		<td width="88%">&nbsp;</td>
	    <td>
	 
	    <span class="zj" style="display:<%=addButtonDisplay%>"  title="添加人员配置" ><a href="#" onclick="addLine()"></a></span>
	    <span class="xz" style="display:<%=addButtonDisplay%>"  title="下载excel模板" ><a href="#" onclick="toDownload()"></a></span>
	    <span class="dr" style="display:<%=addButtonDisplay%>"   title="导入excel模板" ><a href="#" onclick="exportData()"></a></span>
	 
	    </td>
	  </tr>
	</table>
	</td>
	    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
	  </tr>
	</table>
	</div>
				
	<table id="lineTable" width="99%" border="0" cellspacing="0" cellpadding="0"  style="margin-top:2px;" >
    	<tr>
    	    <td class="bt_info_odd" width="3%">序号</td>
            <td class="bt_info_even" width="9%">班组</td>
            <td class="bt_info_odd" width="9%">岗位</td>		
            <td class="bt_info_even" width="5%">计划人数</td>
            <td class="bt_info_even" width="9%">计划进入时间</td>			
            <td class="bt_info_odd" width="9%">计划离开时间</td>           
            <td class="bt_info_even" width="8%">预计在项目时间</td>
            <td class="bt_info_odd" width="8%">备注</td>
            <td class="bt_info_even" width="3%">操作<input type="hidden" id="lineNum" value="0"/></td> 
        </tr>
    </table>	

    <div id="oper_div">
        <span class="bc_btn"><a href="#" onclick="save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>

<script type="text/javascript" src="<%=contextPath%>/common/applyTeam.js"></script>
</body>
</html>
