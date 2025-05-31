<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	 
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());

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
<body class="bgColor_f3f3f3" onload="getDalei();">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">   
      <table width="100%" border="0" cellspacing="0" cellpadding="0" id="table1" class="tab_line_height">
        <tr>  
          <td class="inquire_item4">编号:</td>
          <td class="inquire_form4"><input id="s_employee_cd"  name="s_employee_cd" class="input_width" type="text" /></td>
          <td class="inquire_item4">姓名:</td>
          <td class="inquire_form4"><input id="s_employee_name" name="s_employee_name" class="input_width"  type="text"/></td>
        </tr>
        <tr>
          <td class="inquire_item4">职位级别:</td>
          <td class="inquire_form4"><code:codeSelect name='s_post_level' option="postLevelOps" addAll="true"  cssClass="select_width" selectedValue=''/></td>
          <td class="inquire_item4">学历:</td>
          <td class="inquire_form4"><code:codeSelect name='s_employee_education_level' option="employeeEducationLevelOps"  cssClass="select_width" addAll="true" selectedValue=''/></td>
        </tr>
        <tr>
          <td class="inquire_item4">用工分布:</td>
          <td class="inquire_form4"><code:codeSelect name='s_spare7' option="humanScatteredOps"  cssClass="select_width" addAll="true" selectedValue=''/></td>
		  <td class="inquire_item4">员工类型:</td>
          <td class="inquire_form4">
          <select id="s_employee_gz" name="s_employee_gz" class="select_width">
          <option value="">--请选择--</option><option value="0110000019000000001">合同化用工</option><option  value="0110000019000000002">市场化用工</option>
          </select>
          </td>
        
        </tr>
        <tr>  
	        <td class="inquire_item4">证书大类:</td>
	        <td class="inquire_form4">
	        <select class="select_width" id="dalei" name="dalei" onchange="getXiao()"></select> 
	       <td class="inquire_item4">证书类别:</td>
	       <td class="inquire_form4">
	       <select class="select_width"  id="xiaolei" name="xiaolei" ></select>   
	       </td>
       </tr> 
     
        <tr>  
        <td class="inquire_item4">岗位:</td>
        <td class="inquire_form4"><input id="post"  name="post" class="input_width" type="text" /></td>
        <td class="inquire_item4">托福成绩是否合格:</td>
        <td class="inquire_form4"> 
        <select id="if_qualified" name="if_qualified" class="select_width">
        <option value="">--请选择--</option><option value="0">是</option><option  value="1">否</option>
        </select>
        </td>
        
      </tr>
      <tr>  
 
      <td class="inquire_item4">900成绩是否合格:</td>
      <td class="inquire_form4"> 
      <select id="if_qualifieds" name="if_qualifieds" class="select_width">
      <option value="">--请选择--</option><option value="0">是</option><option  value="1">否</option>
      </select>
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
	
	var s_employee_cd = document.getElementById("s_employee_cd").value;
	var s_employee_name = document.getElementById("s_employee_name").value;
	var s_post_level = document.getElementsByName("s_post_level")[0].value;
	var s_employee_education_level = document.getElementsByName("s_employee_education_level")[0].value;
	var s_employee_gz = document.getElementsByName("s_employee_gz")[0].value;
	var s_spare7 = document.getElementsByName("s_spare7")[0].value;
	var s_post = document.getElementsByName("post")[0].value;
	
	var dalei = document.getElementsByName("dalei")[0].value;
	var xiaolei = document.getElementsByName("xiaolei")[0].value;
	
	var if_qualified = document.getElementsByName("if_qualified")[0].value;
	var if_qualifieds = document.getElementsByName("if_qualifieds")[0].value;
	
	var str = " 1=1 ";
	
	if(s_employee_cd!=''){
		str = str + "and employee_cd like '"+s_employee_cd+"%' ";
	}
	if(s_employee_name!=''){
		str = str + "and employee_name like '"+s_employee_name+"%' ";
	}
	if(s_post_level!=''){
		str = str + "and post_level like '"+s_post_level+"%' ";
	}
	if(s_employee_education_level!=''){
		str = str + "and employee_education_level like '"+s_employee_education_level+"%' ";
	}
	if(s_employee_gz!=''){
		str = str + "and employee_gz like '"+s_employee_gz+"%' ";
	}
	if(s_spare7!=''){
		str = str + "and spare7 like '"+s_spare7+"%' ";
	}
	
	if(dalei!=''){
		str = str + "and dalei like '"+dalei+"%' ";
	}
	if(xiaolei!=''){
		str = str + "and xiaolei like '"+xiaolei+"%' ";
	}
	
	 
	if(s_post!=''){
		str = str + "and post like '%"+s_post+"%' ";
	}
	
	if(if_qualified!=''){
		str = str + "and if_qualified = '"+if_qualified+"' ";
	}
	if(if_qualifieds!=''){
		str = str + "and if_qualifieds = '"+if_qualifieds+"' ";
	}
	
	
 	top.frames('list').frames('mainFrame').popSearch(str);
	newClose();
	 
}

function getDalei(){
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


function getXiao(){
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

