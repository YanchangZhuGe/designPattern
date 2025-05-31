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
	String testProgressId = request.getParameter("testProgressId")!=null?request.getParameter("testProgressId"):"";
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>风险识别</title>
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
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
    <tr>
    	<td class="inquire_item4">试验类型：
    	<input type="hidden" name="testProgressId" id="testProgressId" value="<%=testProgressId%>"/>
    	</td>
      	<td class="inquire_form4">
			<select name="testType" id="testType" class="select_width">
			      	<option value="1">系统试验</option>
			      	<option value="2">考核试验</option>
			</select>
		</td>
    	<td class="inquire_item4"><font color="red">*</font>试验日期：</td>
      	<td class="inquire_form4">
	       <input type="text" name="testDate" id="testDate" readonly="readonly"/>&nbsp;&nbsp;
	       <img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor:hand;" onmouseover="calDateSelector(testDate,tributton2);"/>
	    </td>
    </tr> 
    <tr>
    	<td class="inquire_item4"><font color="red">*</font>测线号/线束号：</td>
      	<td class="inquire_form4"><input type="text" name="lineGroupId" id="lineGroupId" class="input_width" /></td>
    	<td class="inquire_item4">试验点位置：</td>
      	<td class="inquire_form4"><input type="text" name="testPlace" id="testPlace" class="input_width"/></td>
    </tr> 
    <tr>
    	<td class="inquire_item4">X坐标：</td>
      	<td class="inquire_form4"><input type="text" name="testPointX" id="testPointX" class="input_width" /></td>
    	<td class="inquire_item4">Y坐标：</td>
      	<td class="inquire_form4"><input type="text" name="testPointY" id="testPointY" class="input_width"/></td>
    </tr> 
    <tr>
        <td class="inquire_item4">试验总炮数：</td>
      	<td class="inquire_form4">
      		<input type="text" name="totalTestSpNum" id="totalTestSpNum" class="input_width" />
      	</td>
    	<td class="inquire_item4">试验合格炮数：</td>
      	<td class="inquire_form4">
      	<input type="text" name="testQualifiedSpNum2" id="testQualifiedSpNum2" class="input_width" />
      	</td>
    </tr>     
    <tr>
        <td class="inquire_item4">震源类型：</td>
      	<td class="inquire_form4">
      		<input type="text" name="sourceType" id="sourceType" class="input_width" />
      	</td>
    	<td class="inquire_item4">试验内容：</td>
      	<td class="inquire_form4">
      	<textarea rows="3" cols="" id="testContent" name="testContent"></textarea>
      	</td>
    </tr>
    <tr>
        <td class="inquire_item4">试验结论：</td>
      	<td class="inquire_form4">
      	<textarea rows="3" cols="" id="testConclusion" name="testConclusion"></textarea>
      	</td>
    	<td class="inquire_item4">备注：</td>
      	<td class="inquire_form4">
      	<textarea rows="3" cols="" id="notes" name="notes"></textarea>
      	</td>
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
	var testProgressId = '<%=testProgressId%>';
	if('<%=testProgressId%>'!=""&&'<%=testProgressId%>'!='null'){
		getRiskIdentifyInfo('<%=testProgressId%>');
	}	

	if('<%=pageAction%>'!=""&&'<%=pageAction%>'!='null'){
		if('<%=pageAction%>'=='Add'){
			document.getElementById("form1").action = "<%=contextPath%>/pm/dailyreport/insertTestProgress.srq";
		}
		if('<%=pageAction%>'=='Edit'){
			document.getElementById("form1").action = "<%=contextPath%>/pm/dailyreport/updateTestProgress.srq";
		}
	}
	
	function getRiskIdentifyInfo(id){
		var retObj = jcdpCallService("InputDailyProgressSrv", "queryTestProgressById", "testProgressNo="+id);
		document.getElementById("testType").value= retObj.progressInfoMap.testType != undefined ? retObj.progressInfoMap.testType:"";
		document.getElementById("testDate").value= retObj.progressInfoMap.testDate != undefined ? retObj.progressInfoMap.testDate:"";
		document.getElementById("testPlace").value= retObj.progressInfoMap.testPlace != undefined ? retObj.progressInfoMap.testPlace:"";
		document.getElementById("lineGroupId").value= retObj.progressInfoMap.lineGroupId != undefined ? retObj.progressInfoMap.lineGroupId:"";
		document.getElementById("testPointX").value = retObj.progressInfoMap.testPointX != undefined ? retObj.progressInfoMap.testPointX:"";
		document.getElementById("testPointY").value= retObj.progressInfoMap.testPointY != undefined ? retObj.progressInfoMap.testPointY:"";
		document.getElementById("totalTestSpNum").value= retObj.progressInfoMap.totalTestSpNum != undefined ? retObj.progressInfoMap.totalTestSpNum:"";
		document.getElementById("testQualifiedSpNum2").value= retObj.progressInfoMap.testQualifiedSpNum2 != undefined ? retObj.progressInfoMap.testQualifiedSpNum2:"";
		document.getElementById("sourceType").value= retObj.progressInfoMap.sourceType != undefined ? retObj.progressInfoMap.sourceType:"";
		document.getElementById("testContent").innerHTML= retObj.progressInfoMap.testContent != undefined ? retObj.progressInfoMap.testContent:"";
		document.getElementById("testConclusion").innerHTML= retObj.progressInfoMap.testConclusion != undefined ? retObj.progressInfoMap.testConclusion:"";
		document.getElementById("notes").innerHTML= retObj.progressInfoMap.notes != undefined ? retObj.progressInfoMap.notes:"";
	}
	
	function checkForm(){ 	
		
		if (!isTextPropertyNotNull("testDate", "试验日期")) {		
			document.form1.testDate.focus();
			return false;	
		}
		if (!isTextPropertyNotNull("lineGroupId", "测线号/线束号")) {		
			document.form1.lineGroupId.focus();
			return false;	
		}
		if (!isValidFloatProperty12_2("testPointX", "X坐标")) {		
			document.form1.testPointX.focus();
			return false;	
		}
		if (!isValidFloatProperty12_2("testPointY", "Y坐标")) {		
			document.form1.testPointY.focus();
			return false;	
		}
		if (!isValidFloatProperty12_2("totalTestSpNum", "试验总炮数")) {		
			document.form1.totalTestSpNum.focus();
			return false;	
		}
		if (!isValidFloatProperty12_2("testQualifiedSpNum2", "试验合格炮数")) {		
			document.form1.testQualifiedSpNum2.focus();
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