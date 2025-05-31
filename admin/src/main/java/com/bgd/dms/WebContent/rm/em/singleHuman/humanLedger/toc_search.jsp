<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request); 
	String projectId= user.getProjectInfoNo();
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String taskObjectId = request.getParameter("taskObjectId");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" /> 
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
           <td class="inquire_item4">证书大类:</td>
           <td class="inquire_form4">
           <select class="select_width" id="dalei" name="dalei" onchange="getPost()"></select> 
          <td class="inquire_item4">证书类别:</td>
          <td class="inquire_form4">
          <select class="select_width"  id="xiaolei" name="xiaolei" ></select>   
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
    	var ctt = top.frames('list').frames[1]; 
	    ctt.refreshData('','<%=projectId%>','<%=taskObjectId%>',arrayObj);  
		newClose(); 
		 
}
  
 function getApplyTeam(){
    	var selectObj = document.getElementById("dalei"); 
    	document.getElementById("dalei").innerHTML="";
    	selectObj.add(new Option('-请选择-',""),0);
 
    	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryCertificate","");	

    	for(var i=0;i<applyTeamList.detailInfo.length;i++){
    		var templateMap = applyTeamList.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
    	}   	
    	var selectObj1 = document.getElementById("xiaolei");
    	document.getElementById("xiaolei").innerHTML="";
    	selectObj1.add(new Option('-请选择-',""),0);
    }
 
 
 function getPost(){
        var applyTeam = "coding_code="+document.getElementById("dalei").value;   
    	var applyPost=jcdpCallService("HumanCommInfoSrv","queryCertificateList",applyTeam);	

    	var selectObj = document.getElementById("xiaolei");
    	document.getElementById("xiaolei").innerHTML="";
    	selectObj.add(new Option('-请选择-',""),0);
    	if(applyPost.detailInfo!=null){
    		for(var i=0;i<applyPost.detailInfo.length;i++){
    			var templateMap = applyPost.detailInfo[i];
    			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
    		}
    	}
    }
 
 

</script>
</html>

