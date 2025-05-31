<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%> 
<%@page import="java.util.*"%> 
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);	 
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String ifReturn="";
 
	if(request.getParameter("folderid") != null){
		ifReturn = request.getParameter("folderid");
	}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>


<title>信息查询</title>
</head>
<body class="bgColor_f3f3f3"  onload="getApplyTeam();">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">   
      <table width="100%" border="0" cellspacing="0" cellpadding="0" id="table1" class="tab_line_height">
        <tr>  
          <td class="inquire_item4">姓名:</td>
          <td class="inquire_form4">    <input id="employee_name" class="input_width"  name="employee_name" type="text"   />  </td>
          <td class="inquire_item4">班组:</td>
          <td class="inquire_form4">
          <select class="select_width" id="apply_team" name="apply_team" onchange="getPost()"></select> 
          </td>
        </tr>
        <tr>
        <td class="inquire_item4">身份证号:</td>
        <td class="inquire_form4"> <input id="employee_id_code_no" class="input_width"  name="employee_id_code_no" type="text"   /> </td>
          <td class="inquire_item4">岗位:</td>
          <td class="inquire_form4">
          <select class="select_width"  id="post" name="post" ></select>   
          </td>
        </tr>
        <%
        if(ifReturn !=""){     
       
        %>
        <tr>
        <td class="inquire_item4">返还状态:</td>
        <td class="inquire_form4">
    	<select name="if_project" class="select_width">
		<option value="">-请选择-</option>
		<option value="1">在项目</option>
		<option value="0">不在项目</option>
	   </select>   
        </td>
      </tr>
      <%
      
        }
      %>
      </table>
     
    </div>
    <div id="oper_div">
    	<auth:ListButton functionId="" css="tj_btn" event="onclick='refreshData()'"></auth:ListButton>
        <auth:ListButton functionId="" css="gb_btn" event="onclick='newClose()'"></auth:ListButton>
    </div>
  </div>
</div>
</body>
<script language="javaScript">
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';

function refreshData(){

 
		var arrayObj = new Array();
		var t=document.getElementById("table1").childNodes.item(0);
   		for(var i=0;i< t.childNodes.length;i++)
    	{
    		for(var j=1;j<t.childNodes(i).childNodes.length;j=j+2)
          {
          	arrayObj.push({"label":t.childNodes(i).childNodes[j].firstChild.name,"value":t.childNodes(i).childNodes[j].firstChild.value}); 
          }
       	
    	}
    	var ctt = top.frames('list');
	    ctt.refreshData(arrayObj);
		newClose();
	 
}
  
 function getApplyTeam(){
    	var selectObj = document.getElementById("apply_team"); 
    	document.getElementById("apply_team").innerHTML="";
    	selectObj.add(new Option('-请选择-',""),0);
 
    	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeam","");	

    	for(var i=0;i<applyTeamList.detailInfo.length;i++){
    		var templateMap = applyTeamList.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
    	}   	
    	var selectObj1 = document.getElementById("post");
    	document.getElementById("post").innerHTML="";
    	selectObj1.add(new Option('-请选择-',""),0);
    }


 
 function getPost(){
        var applyTeam = "applyTeam="+document.getElementById("apply_team").value;   
    	var applyPost=jcdpCallService("HumanCommInfoSrv","queryApplyPostList",applyTeam);	

    	var selectObj = document.getElementById("post");
    	document.getElementById("post").innerHTML="";
    	selectObj.add(new Option('-请选择-',""),0);
    	if(applyPost.detailInfo!=null){
    		for(var i=0;i<applyPost.detailInfo.length;i++){
    			var templateMap = applyPost.detailInfo[i];
    			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
    		}
    	}
    }
 
 
 
 function getDegreeOps(){
		var sdegreeOps=jcdpCallService("HumanLaborMessageSrv","queryDegreeOps","");	
    	var selectObj = document.getElementById("employee_education_level"); 
    	document.getElementById("employee_education_level").innerHTML="";
    	selectObj.add(new Option('-请选择-',""),0);

    	for(var i=0;i<sdegreeOps.detailInfo.length;i++){    
    		var queryDegreeOps = sdegreeOps.detailInfo[i];
			selectObj.add(new Option(queryDegreeOps.label,queryDegreeOps.value),i+1);
    	}   	
     
    }

</script>
</html>

