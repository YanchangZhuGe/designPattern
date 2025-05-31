<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();

	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String message = request.getParameter("message");
	if(message==null || "".equals(message)){
		message = resultMsg.getValue("message");
	}
	
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新建项目</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
</head>
<body >
<form name="form" id="form"  method="post" action="" >
<div id="list_table" >
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
		    <td background="<%=contextPath%>/images/list_15.png">
		    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
					    <td>&nbsp;</td>
					    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="bc" event="onclick='toSubmit()'" title="保存"></auth:ListButton> 
				  	</tr>
				</table>
			</td>
		  </tr>
		</table>
	</div>
  <div id="new_table_box_content" style="width: 100%;padding: 0px;" >
		<div id="new_table_box_bg" >
			<div><font color="red">说明：每个功能项默认值为“涉及”，可设置为“不涉及”，每周系统考核时，不涉及的功能项将不纳入考核。每周的考核取值时间为每周四中午12点。</font></div>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
			  <tr>
		     	<td class="inquire_item6">集中打井下药后民爆物品管理方案：</td>
		      	<td class="inquire_form6">
		      		<input type="radio" name="radiobutton1" value="" checked>考核</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
					<input type="radio" name="radiobutton1" value="1">不考核</input>
		      	</td>
		     	<td class="inquire_item6">夜间施工计划：</td>
		      	<td class="inquire_form6">
		      		<input type="radio" name="radiobutton2" value="" checked>考核</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
					<input type="radio" name="radiobutton2" value="2">不考核</input>
		      	</td>
		     	<td class="inquire_item6">长途搬迁方案：</td>
		      	<td class="inquire_form6">
		      		<input type="radio" name="radiobutton3" value="" checked>考核</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
					<input type="radio" name="radiobutton3" value="3">不考核</input>
		      	</td>
		     </tr>
		     <tr>
		     	<td class="inquire_item6">受控文件的作废和销毁：</td>
		      	<td class="inquire_form6">
		      		<input type="radio" name="radiobutton4" value="" checked>考核</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
					<input type="radio" name="radiobutton4" value="4">不考核</input>
		      	</td>
		     	<td class="inquire_item6">承包商（供应商）监督检查：</td>
		      	<td class="inquire_form6">
		      		<input type="radio" name="radiobutton5" value="" checked>考核</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
					<input type="radio" name="radiobutton5" value="5">不考核</input>
		      	</td>
		     	<td class="inquire_item6">危险作业许可管理：</td>
		      	<td class="inquire_form6">
		      		<input type="radio" name="radiobutton6" value="" checked>考核</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
					<input type="radio" name="radiobutton6" value="6">不考核</input>
		      	</td>
		     </tr>
		     <tr>
		     	<td class="inquire_item6">非常规作业许可管理：</td>
		      	<td class="inquire_form6">
		      		<input type="radio" name="radiobutton7" value="" checked>考核</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
					<input type="radio" name="radiobutton7" value="7">不考核</input>
		      	</td>
		     	<td class="inquire_item6">变更管理：</td>
		      	<td class="inquire_form6">
		      		<input type="radio" name="radiobutton8" value="" checked>考核</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
					<input type="radio" name="radiobutton8" value="8">不考核</input>
		      	</td>
		     	<td class="inquire_item6">文件/记录销毁清单：</td>
		      	<td class="inquire_form6">
		      		<input type="radio" name="radiobutton9" value="" checked>考核</input>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
					<input type="radio" name="radiobutton9" value="9">不考核</input>
		      	</td>
		     </tr>
			</table>
		</div>
  
  
</div> 
</div>
</form>
</body>

<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";
$("#new_table_box_content").css("height",$(window).height()-5);
$("#new_hour_table").css("height",$(window).height()-5);
var projectInfoNo = "<%=projectInfoNo %>";
var message = "<%=message%>";
toEdit();

if(message!="11"){
	alert(message);
}


 	function toSubmit(){
 		debugger;
 		var checked_value = "";
 		for(var i=1;i<10;i++){
 			var temp = document.getElementsByName("radiobutton"+i);
 			 for(var m = 0; m < temp.length ; m++ ){
 	            if(temp[m].checked){
 	                
 	                if(temp[m].value!=""){
	 	            	if(checked_value!=""){
	 	            		checked_value += ",";
	 	            	}
 	                	checked_value += temp[m].value;
 	                	
 	                }
 	                break;
 	            }
 	        }
 		}
 		
 		var form = document.getElementById("form");
 		form.action="<%=contextPath%>/hse/examine/editHseExamine.srq?ids="+checked_value;
 		form.submit();
 	}

	function toEdit(){
		var checkSql="SELECT * FROM BGP_HSE_EXAMINE_MENU t where t.project_info_no='"+projectInfoNo+"' and t.bsflag='0'";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql+'&&pageSize=100');
		var datas = queryRet.datas;
		if(datas==null||datas==""){
				
		}else{
			debugger;
			for (var i = 0; i<datas.length; i++) {
				var temp = document.getElementsByName("radiobutton"+datas[i].menu_id);
	 			 for(var m = 0; m < temp.length ; m++ ){
 	                if(temp[m].value==datas[i].menu_id){
	 	            	temp[m].checked = true;
	 	                break;
	 	            }
	 	        }
			}
		}
	} 

</script>
</html>