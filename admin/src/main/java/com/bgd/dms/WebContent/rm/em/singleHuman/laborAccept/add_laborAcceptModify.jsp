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
    String projectInfoNo = user.getProjectInfoNo();
	String laborCategory = request.getParameter("laborCategory");
	  String projectType = user.getProjectType();
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
  
function save(){
	if(checkForm()){
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/rm/em/toLaborAcceptEdit.srq";
		form.submit();
		//top.frames('list').refreshData('<%=projectInfoNo%>','<%=laborCategory%>');
		newClose();
	}

}

function checkForm(){
	var deviceCount = document.getElementById("equipmentSize").value;
	var isCheck=true;
	for(var i=0;i<deviceCount;i++){
		if(document.getElementById("fy"+i+"bsflag").value == "0"){
			isCheck=false;
			
			if(!notNullForCheck("fy"+i+"laborId","姓名")) return false;
			if(!notNullForCheck("fy"+i+"laborId","身份证号")) return false;
			if(!notNullForCheck("fy"+i+"applyTeam","班组")) return false;
			if(!notNullForCheck("fy"+i+"post","岗位")) return false;
	//		if(!notNullForCheck("fy"+i+"taskId","作业")) return false;
			if(!notNullForCheck("fy"+i+"planStartDate","预计进入时间")) return false;
									
		}
	}
	if(isCheck){
		alert("请调配一条记录");
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
	var projectType="<%=projectType%>";
	var rowNum = document.getElementById("equipmentSize").value;	
	var tr = document.getElementById("lineTable").insertRow();
	tr.id = "row_" + rowNum + "_";
	
	if(rowNum % 2 == 1){  
  		classCss = "even_";
	}else{ 
		classCss = "odd_";
	}	

	var startDates = "fy"+ rowNum + "planStartDate";
	var endDates = "fy"+ rowNum + "planEndDate";
	
	var td = tr.insertCell(0);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="hidden" name="fy'+ rowNum + 'receiveNo" id="fy'+ rowNum + 'receiveNo" value=""/>'+(parseInt(rowNum) + 1);
	
	var td = tr.insertCell(1);
	td.className=classCss+"even";
	td.innerHTML = '<input type="hidden"  name="fy'+ rowNum + 'contNum" id="fy'+ rowNum + 'contNum" value=""/>'+'<input type="hidden"  name="fy'+ rowNum + 'laborId" id="fy'+ rowNum + 'laborId" value=""/>'+'<input type="text" readonly="readonly" name="fy'+ rowNum + 'laborName" id="fy'+ rowNum + 'laborName"  value="" class="input_width" onFocus="this.select()"/>'+'<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" onclick="selectEmployee(\''+rowNum+'\')"/>';

	var td = tr.insertCell(2);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text"  name="fy'+ rowNum + 'employeeIdCodeNo" id="fy'+ rowNum + 'employeeIdCodeNo"  value="" readonly="readonly" class="input_width" onFocus="this.select()"/>';

	var td = tr.insertCell(3);
	td.className=classCss+"even";
	td.innerHTML = '<select class="input_width"  name="fy'+ rowNum + 'applyTeam" id="fy'+ rowNum + 'applyTeam" onchange="getPost('+rowNum+')" >'+getApplyTeam()+'</select>';
	
	var td = tr.insertCell(4);
	td.className=classCss+"odd";
	td.innerHTML = '<select class="input_width"   name="fy'+ rowNum + 'post" id="fy'+ rowNum + 'post"  > <option value="">请选择</option> </select>';
		
  
     if( projectType !='5000100004000000008'){
    		var td = tr.insertCell(5);
    		td.className=classCss+"even";
    		td.innerHTML = '<input type="hidden" readonly="readonly"  name="fy'+ rowNum + 'taskId" id="fy'+ rowNum + 'taskId"  value="" onFocus="this.select()"/>'+'<input type="text" readonly="readonly"  class="input_width" name="fy'+ rowNum + 'taskName" id="fy'+ rowNum + 'taskName"  value="" onFocus="this.select()"/>'+'<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" onclick="selectTree(\''+rowNum+'\')"/>';
    		
    		var td = tr.insertCell(6);
    		td.className=classCss+"odd";
    		td.innerHTML = '<input type="text" class="input_width"  readonly="readonly" name="fy'+ rowNum + 'planStartDate" id="fy'+ rowNum + 'planStartDate" value="" />'+'<img src="<%=contextPath%>/images/calendar.gif" id="tributton1'+rowNum+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+startDates+',tributton1'+rowNum+');" />';

    		var td = tr.insertCell(7);
    		td.className=classCss+"even";
    		td.innerHTML = '<input type="text" class="input_width"   name="fy'+ rowNum + 'notes" id="fy'+ rowNum + 'notes" value="" />'+'<input type="hidden"  class="input_width" name="fy' + rowNum + 'bsflag" id="fy' + rowNum + 'bsflag" value="0"/>';
    			
    		var rowid = "row_" + rowNum + "_";
    		var td = tr.insertCell(8);
    		td.className=classCss+"odd";
    		td.innerHTML = '<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine('+"'"+rowid+"'"+')"/>';
    		document.getElementById("equipmentSize").value = (parseInt(rowNum) + 1);
		} else{ 
			 	
			var td = tr.insertCell(5);
			td.className=classCss+"odd";
			td.innerHTML = '<input type="text" class="input_width"  readonly="readonly" name="fy'+ rowNum + 'planStartDate" id="fy'+ rowNum + 'planStartDate" value="" />'+'<img src="<%=contextPath%>/images/calendar.gif" id="tributton1'+rowNum+'" width="16" height="16" style="cursor: hand;"'+ 'onmouseover="calDateSelector('+startDates+',tributton1'+rowNum+');" />';

			var td = tr.insertCell(6);
			td.className=classCss+"even";
			td.innerHTML = '<input type="text" class="input_width"   name="fy'+ rowNum + 'notes" id="fy'+ rowNum + 'notes" value="" />'+'<input type="hidden"  class="input_width" name="fy' + rowNum + 'bsflag" id="fy' + rowNum + 'bsflag" value="0"/>';
				
			var rowid = "row_" + rowNum + "_";
			var td = tr.insertCell(7);
			td.className=classCss+"odd";
			td.innerHTML = '<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine('+"'"+rowid+"'"+')"/>';
			document.getElementById("equipmentSize").value = (parseInt(rowNum) + 1);
		}
	  	


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

function getPost(i){
    var applyTeam = "applyTeam="+document.getElementById("fy"+ i + "applyTeam").value;   
	var applyPost=jcdpCallService("HumanCommInfoSrv","queryApplyPostList",applyTeam);	

	var selectObj = document.getElementById("fy"+ i + "post");
	document.getElementById("fy"+ i + "post").innerHTML="";
	selectObj.add(new Option('请选择',""),0);
	if(applyPost.detailInfo!=null){
		for(var i=0;i<applyPost.detailInfo.length;i++){
			var templateMap = applyPost.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
		}
	}
}


function deleteLine(lineId){		
	var rowNum = lineId.split('_')[1];
	var line = document.getElementById(lineId);		

	var bsflag = document.getElementsByName("fy" + rowNum + "bsflag")[0].value;
	if(bsflag!=""){
		line.style.display = 'none';
		document.getElementsByName("fy" + rowNum + "bsflag")[0].value = '1';
	}else{
		line.parentNode.removeChild(line);
	}	

}

function selectTree(i){

  var teamInfo = {
	  TaskIds:"",
	  Names:"",
	  StartDates:"",
	  EndDates:"",
	  CheckOther1s:""
  }; 
  window.showModalDialog('<%=contextPath%>/p6/tree/selectTree.jsp?projectInfoNo=<%=projectInfoNo%>',teamInfo);
  
  if(teamInfo.CheckOther1s != ""){
	  
	  document.getElementById("fy"+ i + "taskId").value =teamInfo.CheckOther1s;
	  document.getElementById("fy"+ i + "taskName").value =teamInfo.Names;

  }
  
}


function selectEmployee(i){

   popWindow('<%=contextPath%>/rm/em/singleHuman/laborAccept/searchLaborList.jsp?laborCategory=<%=laborCategory%>&rowid='+i,'800:603'); 	
  
}


function getMessage(arg){
	
	var rowid = document.getElementsByName("showMessage")[0].value=arg[0];
	var checked = document.getElementsByName("showMessage2")[0].value=arg[1];
	
    if(checked != ""){
		  var check = checked.split("-");
		  document.getElementById("fy"+ rowid + "laborId").value =check[0];
		  document.getElementById("fy"+ rowid + "laborName").value =check[1];
		  document.getElementById("fy"+ rowid + "employeeIdCodeNo").value =check[2];
		  document.getElementById("fy"+ rowid + "contNum").value =check[5];

   }
	
}
</script>
</head>
<body>
<form id="CheckForm" action="" method="post" target="list" >

	<div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%">
	<input type="hidden" id="project_info_no" name="project_info_no" value="<%=projectInfoNo%>"/>
	<input type="hidden" id="labor_category" name="labor_category" value="<%=laborCategory%>"/> 
	<input type="hidden" name="showMessage" value=""/>
    <input type="hidden" name="showMessage2" value=""/>
	<div ic="oper_div" align="center">
     	<span class="zj"><a href="#" onclick="addLine()"></a></span>
    </div>		
	<table id="lineTable" width="100%" border="0" cellspacing="0" cellpadding="0"  style="margin-top:2px;" >
    	<tr>
    	    <td class="bt_info_odd" width="3%">序号</td>
    	    <td class="bt_info_even" width="6%">姓名</td>
    	    <td class="bt_info_odd" width="8%">身份证号</td>
            <td class="bt_info_even"  width="8%">班组</td>
            <td class="bt_info_odd"  width="8%">岗位</td>		
             <% 
			        if(!"5000100004000000008".equals(projectType)){
						  %>
			    <td class="bt_info_even"  width="8%">作业</td>		 
			    <%
					} 
				 %>	
				  
                   
            <td class="bt_info_odd"  width="8%">预计进入时间</td>					
            <td class="bt_info_even"  width="6%">备注</td> 
            <td class="bt_info_odd" width="3%">操作<input type="hidden" id="equipmentSize" name="equipmentSize" value="0" /></td> 
        </tr>  
    </table>	
	</div>
    <div id="oper_div">
        <span class="bc_btn"><a href="#" onclick="save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
 </form>
</body>
</html>
