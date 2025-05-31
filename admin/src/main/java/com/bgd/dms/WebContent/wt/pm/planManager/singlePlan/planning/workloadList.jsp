<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="java.util.*" %>
<%@ page  import="java.net.*" %>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<%@ page import="java.text.*" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String activityObjectIds = request.getParameter("taskObjectId") != null ? request.getParameter("taskObjectId"):"";
	String[] idArray = {};
	if(activityObjectIds != ""){
		idArray = activityObjectIds.split(",");
	}
	String activityNames = request.getParameter("taskName") != null ? request.getParameter("taskName"):"";
	String foward = request.getParameter("foward") != null ? request.getParameter("foward"):"";
	if("1" == foward || "1".equals(foward)){
		activityNames = request.getParameter("testTaskName") != null ? request.getParameter("testTaskName"):"";
	}
	String paramTaskNames = URLDecoder.decode(activityNames,"UTF-8");
	String[] nameArray = {};
	String newArray = "";
	if(paramTaskNames != ""){
		nameArray = paramTaskNames.split(",");
		newArray = "array";
	}
		 
	String projectInfoNo = request.getParameter("projectInfoNo") != null ? request.getParameter("projectInfoNo"):"";
	if(projectInfoNo != "" && projectInfoNo != null){
		projectInfoNo = user.getProjectInfoNo();
	}
	
	String expMethod = request.getParameter("expMethod") != null ? request.getParameter("expMethod") : "";
	String[] methods = expMethod.split(",");
	String methodString = "";
	for(int i=0;i<methods.length;i++){
		methodString += ",'"+methods[i]+"'";
	}
	String methodParams = "("+methodString.substring(1,methodString.length())+")";

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />

<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript">
	<%
	out.print("var activityNameArray=new Array(");
	for(int i=0;i<idArray.length;i++){
		out.print("['");
		out.print(idArray[i]);
		out.print("','");
		out.print(nameArray[i].substring(0,nameArray[i].indexOf("(")));
		out.print("'],");
	}
	out.print("[]);");
		out.print(""+foward);
	%>

	<%------
	//////////校验数字类型
	function IsNum(e) {
	    var k = window.event ? e.keyCode : e.which;
	    if (((k >= 48) && (k <= 57)) || k == 8 || k == 0) {
	    } else {
	        if (window.event) {
	            window.event.returnValue = false;
	        }
	        else {
	            e.preventDefault(); //for firefox 
	        }
	    }
	}
-------%>
	
	

///////////////综合物化探工作量 导出用
 

var hideExportAreaTimerWt;
function exportDataWt(){
	$tip = $("<div id='exportArea' style='position:absolute; left:" + (event.clientX-90) + "px; top:" + (event.clientY+10) + "px; width:75px; height:60px; padding: 5px; border:1px solid; text-align: center; background: white; '></div>");
	$tip.bind('mouseover', exportAreaMouseoverWt);
	$tip.bind('mouseout', exportAreaMouseoutWt);
	
	$curpage = $("<div style='position:relative; border: 1px solid; padding-top: 3px; margin-bottom: 5px; height: 22px; cursor: pointer;' onclick='exportData2Wt()'>导出当前页</div>");
	$tip.append($curpage);
	
	$allpage = $("<div style='position:relative; border: 1px solid; padding-top: 3px; margin-bottom: 5px; height: 22px; cursor: pointer; ' onclick='exportData2Wt(1,100000)'>导出全部页</div>");
	$tip.append($allpage);

	$(document.body).append($tip);
	
	hideExportAreaTimerWt = setTimeout(hideExportAreaWt,1000);
}
function hideExportAreaWt(){
	$('#exportArea').remove();
}
function exportAreaMouseoverWt(){
	clearTimeout(hideExportAreaTimerWt);
}
function exportAreaMouseoutWt(){
	hideExportAreaTimerWt = setTimeout(hideExportAreaWt,1000);
}
//导出数据
function exportData2Wt(curPage, pageSize){
	
	
	
	hideExportAreaWt();
	
	if(curPage==undefined) curPage=cruConfig.currentPage;
	if(pageSize==undefined) pageSize=cruConfig.pageSize;
	
	var titleRow = getObj('queryRetTable').rows[0];
	var columnExp="";
	var columnTitle="";
	for(var j=0;j<titleRow.cells.length;j++){
		var tCell = titleRow.cells[j];
		if(tCell.exp==null || tCell.exp=="null" || tCell.exp.indexOf("{")>0 ) continue;
//debugger;
		var tempcell = tCell.exp.substring(1,tCell.exp.length-1);
		if("activity_name"==tempcell||"resource_name"==tempcell||"planned_units"==tempcell){
		
			columnExp += tCell.exp.substring(1,tCell.exp.length-1) + ",";
			columnTitle += tCell.innerHTML + ",";
		}
	}

	// file name
	var excel_name = top.frames["fourthMenuFrame"].selectedTag.childNodes[0].innerHTML;
	//alert(excel_name);
	
	var querySql='';
	var submitStr = "currentPage="+curPage+"&pageSize="+pageSize;
	var path = '';
	if(cruConfig.funcCode!='') submitStr += "&EP_DATA_AUTH_funcCode="+cruConfig.funcCode;
	var retObject;
	debugger;
	if(cruConfig.queryService!=''){//调用服务查询
		if(cruConfig.cdtStr!=''){
			submitStr += "&querySql="+cruConfig.cdtStr;
		}

		submitStr = encodeURI(submitStr);
		submitStr = encodeURI(submitStr);
		if(cruConfig.submitStr!='')submitStr += "&"+cruConfig.submitStr;
		
		submitStr+="&JCDP_SRV_NAME="+cruConfig.queryService+"&JCDP_OP_NAME="+cruConfig.queryOp+"&JCDP_COLUMN_EXP="+columnExp+"&JCDP_COLUMN_TITLE="+columnTitle+"&JCDP_FILE_NAME="+excel_name;
		
		path = cruConfig.contextPath+"/common/excel/listToExcel.srq";

	}
	else if(cruConfig.queryListAction != null){
		if(cruConfig.cdtStr!=''){

			submitStr += "&querySql="+cruConfig.cdtStr;
		}

		submitStr = encodeURI(submitStr);
		submitStr = encodeURI(submitStr);

		path = cruConfig.contextPath+cruConfig.queryListAction;

	}
	else{//根据sql查询
		querySql = cruConfig.queryStr;
		if(cruConfig.cdtStr!=''){
			if(querySql!=''){
				querySql = "Select dataAuthView.* FROM ("+querySql+")dataAuthView WHERE "+cruConfig.cdtStr;}
			else{
				querySql = cruConfig.cdtStr;
			}
		}
		submitStr += "&querySql="+querySql;

		submitStr = encodeURI(submitStr);
		submitStr = encodeURI(submitStr);

		submitStr+="&JCDP_SRV_NAME=RADCommCRUD&JCDP_OP_NAME=queryRecords&JCDP_COLUMN_EXP="+columnExp+"&JCDP_COLUMN_TITLE="+columnTitle+"&JCDP_FILE_NAME="+excel_name;
		path = cruConfig.contextPath+"/common/excel/listToExcel.srq";

	}
	
	debugger;
	
	var retObj = syncRequest("post", path, submitStr);
	excel_name = encodeURI(excel_name);
    excel_name = encodeURI(excel_name);

	window.location=cruConfig.contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname="+excel_name+".xls";
}
function exportDailyTemplateWt(){
	window.location.href="<%=contextPath%>/pm/dailyReport/exportDailyTemplateWt.srq?activity_object_id=<%=activityObjectIds %>";
	
}
	
</script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<title>无标题文档</title>
</head>

<body style="background:#fff">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<!-- <td>当前操作的任务为<%=activityNames %></td> -->
			    <td>&nbsp;</td>
			    <!-- <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_query"></auth:ListButton> -->
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='toUpdate()'" title="JCDP_btn_submit"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportDataWt()'" title="JCDP_btn_export"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportDailyTemplateWt()'" title="导出日报模板"></auth:ListButton>
			  </tr>
			  
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			<form action="<%=contextPath%>/wt/pm/workload/updateWorkload.srq" method="post"  id="form1">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			    
			    	<input type="hidden" value="<%=activityObjectIds %>"  id="activityObjectIds" name="activityObjectIds"/>
			    	<input type="hidden" value="<%=activityNames %>"  id="taskNames" name="taskNames"/>
			    	
			    	<input type="hidden" value=""  id="taskId" name="taskId"/>
			    	<input type="hidden" value=""  id="projectInfoNo" name="projectInfoNo"/>
			    	<input type="hidden" value=""  id="method" name="method"/>
			    	
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{object_id}' id='rdo_entity_id_{object_id}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{activity_name}" isShow="Hide" style="display:none">任务名称</td> 
			      <td class="bt_info_odd" exp="{activity_object_id}" func="getOpValue,activityNameArray">任务名称</td><!-- -->
			      <td class="bt_info_even" exp="{resource_id}" isShow="Hide" style="display:none">工作量编号</td>
			      <td class="bt_info_even" exp="{resource_name}">工作量名称</td>
			      <td class="bt_info_odd" exp="<input id='planned_units_{object_id}'   name='planned_units_{object_id}'  class='input_width' value='{planned_units}' onpaste='return false' onfocus='this.style.imeMode=disabled'  onkeyup='ttest(  &quot;{resource_id}&quot;  ,  &quot;planned_units_{object_id}&quot;  );'   maxlength='10'  />">计划工作量</td>
			      <td class="bt_info_even" exp="{planned_units}" isShow="Hide" style="display:none">计划工作量 </td>
			    </tr>
			  </table>
			  </form>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
			
		  </div>

</body>
<script type="text/javascript">
//alert("xinxinxinxwrokload list jsp");
function frameSize(){
	//setTabBoxHeight();
	$("#table_box").css("height",$(window).height()*0.85);
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

</script>

<script type="text/javascript">
	//debugger;
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "WorkloadSrv";
	cruConfig.queryOp = "queryWorkload";
	var projectName="";
	var projectId="";
	var projectType="";
	var projectYear="";
	var isMainProject="";
	var projectStatus="";
	var orgName="";
	var projectInfoNo = "";
	var taskId = "";
	var method = "";

	//校验输入数字
	function ttest(resourceId,inputId){
		


		var inputvalue = document.getElementById(inputId).value;

		//alert("@"+inputvalue+"@");
		
		if(inputvalue!=""){
		
			if(resourceId=="G660201"||resourceId=="G660301"||resourceId=="G660401"||resourceId=="G660501"||resourceId=="G660601"||resourceId=="G660701"){
				//可以输入小数
				var ree = /^\\d{8}$/;
				if(inputvalue.match(/^\d{1,8}$/) || /\.\d{0,2}$/.test(inputvalue)){
					
				}else{
					alert("请输入整数或两位小数");
					document.getElementById(inputId).value="";
				}

				
			}else{
				//不可以输入小数
	
				 
		      // var re = /^[1-9]+[0-9]*]*$/;              //判断字符串是否为数字 ^[0-9]+.?[0-9]*$/
		     var re =  /^\d{1,8}$/;
		       if (!re.test(document.getElementById(inputId).value))
		       {
		          alert("请输入整数");
		          document.getElementById(inputId).value="";
		       }
		        
				
			}
		}
		
	}

	// 复杂查询
	function refreshData(){

		cruConfig.submitStr = "activity_object_id=<%=activityObjectIds %>";
		queryData(1);
	}

	refreshData();
	// 简单查询
	function simpleRefreshData(){
		var q_projectName = document.getElementById("projectName").value;
		refreshData(q_projectName, "", "", "", "", "", orgSubjectionId);
	}
	
	function loadDataDetail(ids){
	    if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
	}
	
	function toUpdate(){
		var form = document.getElementById("form1");
		form.submit();
	}

	function toAdd(){

		var obj = {
				fkValue:"",
				value:"",
				method:"",
				taskId:"",
				projectInfoNo:""
			};
		window.showModalDialog("<%=contextPath%>/wt/pm/planManager/singlePlan/planning/selectWorkload.jsp?codingSortId=7101&project_exp_method=<%=expMethod%>&activity_object_id=<%=activityObjectIds%>&project_info_no=<%=projectInfoNo%>",obj);
		//obj.fkValue 选择的工作量的id 可包含多个                             activityObjectIds 选择的任务Id(可多选) 
		var projectInfoNo = obj.projectInfoNo;
		document.getElementById("projectInfoNo").value = projectInfoNo;
		var taskId = obj.taskId;
		document.getElementById("taskId").value = taskId;
		var method = obj.method;
		document.getElementById("method").value = method;
		
		var retObj = jcdpCallService("WorkloadSrv", "saveWorkload", "resourceObjectIds="+obj.fkValue+"&activityObjectIds=<%=activityObjectIds %>");
		if(retObj["saveResult"]!='undefined'&&retObj["saveResult"]!=null&&retObj["saveResult"]!=""){
			alert(retObj["saveResult"]);
		}
		
		debugger;
		refreshData();
		
	}
	
	function toDelete(){
		//alert("暂时屏蔽删除功能");return;
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中至少一条记录!");
	     	return;
	    }	
		    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("WorkloadSrv", "deleteWorkload", "objectIds="+ids);
			queryData(cruConfig.currentPage);
		}
	}

	function toSearch(){
		popWindow('');
	}
	
	function dbclickRow(ids){
		
	}
	
	
</script>

</html>

