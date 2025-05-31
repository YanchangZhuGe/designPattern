<%@page import="com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath(); 
	String pageAction = request.getParameter("pageAction")!=null?request.getParameter("pageAction"):"";
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectNo = user.getProjectInfoNo();
	String acquireNo = request.getParameter("acquireNo")!=null?request.getParameter("acquireNo"):"";
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>编辑采集进度</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" media="all" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>

</head>
<body>
<form name="form1" id="form1" method="post" action="" enctype="multipart/form-data">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
    <tr>
    	<td class="inquire_item4">
    		<font color="red">*</font>施工日期：
    		<input type="hidden" name="testProgressId" id="testProgressId" value="<%=acquireNo%>"/>
    	</td>
      	<td class="inquire_form4">
	       <input type="text" name="consDate" id="consDate" readonly="readonly"/>&nbsp;&nbsp;
	       <img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor:hand;" onmouseover="calDateSelector(consDate,tributton2);"/>
	    </td>
	    <td class="inquire_item4"><font color="red">*</font>测线号/线束号：</td>
      	<td class="inquire_form4"><input type="text" name="lineGroupId" id="lineGroupId" class="input_width" /></td>
    </tr> 
    <tr>
    	<td class="inquire_item4"><font color="red">*</font>&nbsp;S文件：</td>
      	<td class="inquire_form4">
      	<input type="file" name="sFile" id="sFile" class="input_width" />
      	<a href="#" id="sFileLink" name="sFileLink"></a>
      	</td>
    	<td class="inquire_item4"><font color="red">*</font>&nbsp;R文件：</td>
      	<td class="inquire_form4">
      	<input type="file" name="rFile" id="rFile" class="input_width"/>
      	<a href="#" id="rFileLink" name="rFileLink"></a>
      	</td>
    </tr> 
    <tr>
    	<td class="inquire_item4"><font color="red">*</font>&nbsp;X文件：</td>
      	<td class="inquire_form4">
      	<input type="file" name="xFile" id="xFile" class="input_width" />
      	<a href="#" id="xFileLink" name="xFileLink"></a>
      	</td>
    	<td class="inquire_item4">&nbsp;</td>
      	<td class="inquire_form4">&nbsp;</td>
    </tr>       
</table>
</div>
    <div id="oper_div">
    	<auth:ListButton functionId="" css="tj_btn" event="onclick='refreshData()'"></auth:ListButton>
        <auth:ListButton functionId="" css="gb_btn" event="onclick='newClose()'"></auth:ListButton>        
    </div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">
	
	cruConfig.contextPath =  "<%=contextPath%>";
	var project_no = '<%=projectNo%>';
	var acquireNo = '<%=acquireNo%>';
	if('<%=acquireNo%>'!=""&&'<%=acquireNo%>'!='null'){
		getAcquireInfo('<%=acquireNo%>');
	}	

	if('<%=pageAction%>'!=""&&'<%=pageAction%>'!='null'){
		if('<%=pageAction%>'=='Add'){
			document.getElementById("form1").action = "<%=contextPath%>/pm/dailyreport/insertAcquireProgress.srq?projectInfoNo="+project_no;
		}
		if('<%=pageAction%>'=='Edit'){
			document.getElementById("form1").action = "<%=contextPath%>/pm/dailyreport/updateAcquireProgress.srq?projectInfoNo="+project_no+"&acquireNo="+acquireNo;
		}
	}
	
	function getAcquireInfo(id){
		var retObj = jcdpCallService("InputDailyProgressSrv", "queryAcquireProgressById", "acquireNo="+id);
		document.getElementById("consDate").value= retObj.progressInfoMap.cons_date != undefined ? retObj.progressInfoMap.cons_date:"";
		document.getElementById("lineGroupId").value= retObj.progressInfoMap.line_group_id != undefined ? retObj.progressInfoMap.line_group_id:"";
		var acquireNo = retObj.progressInfoMap.acquire_no != undefined ? retObj.progressInfoMap.acquire_no:"";
		var lineGroupId = retObj.progressInfoMap.line_group_id != undefined ? retObj.progressInfoMap.line_group_id:"";
		document.getElementById("rFileLink").innerHTML= "查看R文件";
		document.getElementById("sFileLink").innerHTML= "查看S文件";
		document.getElementById("xFileLink").innerHTML= "查看X文件";
		document.getElementById("rFileLink").href= "<%=contextPath %>/pm/dailyreport/downloadAcquireFile.srq?fileType=rFile&acquireNo="+acquireNo+"&lineGroupId="+lineGroupId+"&projectInfoNo="+project_no;
		document.getElementById("sFileLink").href= "<%=contextPath %>/pm/dailyreport/downloadAcquireFile.srq?fileType=sFile&acquireNo="+acquireNo+"&lineGroupId="+lineGroupId+"&projectInfoNo="+project_no;
		document.getElementById("xFileLink").href= "<%=contextPath %>/pm/dailyreport/downloadAcquireFile.srq?fileType=xFile&acquireNo="+acquireNo+"&lineGroupId="+lineGroupId+"&projectInfoNo="+project_no;
	}
	
	function checkForm(){ 	
		var consDate = document.getElementById("consDate").value;
		var lineGroupId = document.getElementById("lineGroupId").value;
		var sFile = document.getElementById("sFile").value;
		var rFile = document.getElementById("rFile").value;
		var xFile = document.getElementById("xFile").value;
		
		if (consDate=="")
		{
			alert("施工日期不应为空，请重新输入！");
			return false;
		}
		
		if (lineGroupId=="")
		{
			alert("测线号/线束号不应为空，请重新输入！");
			return false;
		}
		if(lineGroupId.length>16)
		{
			alert("测线号/线束号长度不能超过16，请重新输入！");
			return false;
		}

		if (sFile=="")
		{
			alert("S文件不应为空，请重新输入！");
			return false;
		}
		if(sFile.substring(sFile.lastIndexOf(".")+1,sFile.length).toUpperCase()!="S")
		{
			alert("S文件上传的类型不匹配,请重新上传!");
			return false;
		}			
		if (rFile=="")
		{
			alert("R文件不应为空，请重新输入！");
			return false;
		}
		if(rFile.substring(rFile.lastIndexOf(".")+1,rFile.length).toUpperCase()!="R")
		{
			alert("R文件上传的类型不匹配,请重新上传!");
			return false;
		}

		if (xFile=="")
		{
			alert("X文件不应为空，请重新输入！");
			return false;
		}
		if(xFile.substring(xFile.lastIndexOf(".")+1,xFile.length).toUpperCase()!="X")
		{
			alert("X文件上传的类型不匹配,请重新上传!");
			return false;
		}
		return true;
	}	
	
	function refreshData(){
		if (!checkForm()) return;
		document.getElementById("form1").submit();
	}

</script>
</html>