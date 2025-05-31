 
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>

 
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="GBK"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	Map employeeMap = new HashMap();
	
	if(respMsg.getMsgElement("employeeMap") != null){
		employeeMap = respMsg.getMsgElement("employeeMap").toMap();
	}
	List projectMap = respMsg.getMsgElements("projectMap"); 
	List blackListMap = respMsg.getMsgElements("blackListMap"); 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=GBK">

<title>人员信息</title>
<link rel="stylesheet"	href="<%=contextPath%>/css/em/emSpryTabbedPanels.css" type="text/css">
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<link href="<%=contextPath%>/dialog/jquery_dialog.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/dialog/jquery.js"></script>
<script type="text/javascript" src="<%=contextPath%>/dialog/jquery_dialog.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>

</head>
<body><div id="inq_tool_box">
<DIV id=tag-container_3>
<UL id=tags class=tags>
  <li class="selectTag"><A onClick="selectTag('tagContent0',this)" href="javascript:void(0)">基本信息</A></li> 
  <li><A onClick="selectTag('tagContent1',this)"  href="javascript:void(0)">项目经历</A></li>
  <li><A onClick="selectTag('tagContent2',this)"  href="javascript:void(0)">培训经历</A></li>
  <li><A onClick="selectTag('tagContent3',this)"  href="javascript:void(0)">资格证书信息</A></li>
  <li><A onClick="selectTag('tagContent4',this)"  href="javascript:void(0)">黑名单信息</A></li>
  </UL>
  </DIV>
  
  <div id="tab_box">
	
<div  id="tagContent0" >
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="background:#efefef">
<tr align="right"  >
   <td>&nbsp;</td>
     
</tr>
</table>
 

<table  border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="background:#efefef"> 
    <tr>
      <td   class="inquire_item6">姓名：</td>
      <td   class="inquire_form6" ><input name="" class="input_width" type="text"  value="<%= employeeMap.get("employee_name") != null ? employeeMap.get("employee_name"):""%>"/> &nbsp;</td>
      <td  class="inquire_item6">&nbsp;性别：</td>
      <td  class="inquire_form6"  ><input name="" class="input_width" type="text"  value="<%= employeeMap.get("employee_gender_name") != null ? employeeMap.get("employee_gender_name"):""%>"/>&nbsp;</td>
     </tr>
     <tr >
     <td  class="inquire_item6">出生年月：</td>
     <td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("employee_birth_date") != null ? employeeMap.get("employee_birth_date"):""%>"/>&nbsp;</td>
     <td  class="inquire_item6">&nbsp;民族：</td>
     <td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("employee_nation_name") != null ? employeeMap.get("employee_nation_name"):""%>"/>&nbsp;</td>
    </tr>
    <tr>
    <td  class="inquire_item6">身份证号：</td>
    <td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("employee_id_code_no") != null ? employeeMap.get("employee_id_code_no"):""%>"/>&nbsp;</td>
    <td  class="inquire_item6">&nbsp;文化程度：</td>
    <td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("employee_education_level_name") != null ? employeeMap.get("employee_education_level_name"):""%>"/>&nbsp;</td>
   </tr>
   <tr>
   <td  class="inquire_item6">家庭住址：</td>
   <td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("employee_address") != null ? employeeMap.get("employee_address"):""%>"/>&nbsp;</td>
   <td  class="inquire_item6">&nbsp;联系电话：</td>
   <td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("phone_num") != null ? employeeMap.get("phone_num"):""%>&nbsp;"/></td>
  </tr>
  <tr>
  <td  class="inquire_item6">健康信息：</td>
  <td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("employee_health_info") != null ? employeeMap.get("employee_health_info"):""%>"/>&nbsp;</td>
  <td  class="inquire_item6">&nbsp;是否骨干：</td>
  <td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("elite_if_name") != null ? employeeMap.get("elite_if_name"):""%>"/>&nbsp;</td>
 </tr>
 <tr >
 <td  class="inquire_item6">班组：</td>
 <td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("apply_teams") != null ? employeeMap.get("apply_teams"):""%>"/>&nbsp;</td>
 <td  class="inquire_item6">&nbsp;岗位：</td>
 <td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("posts") != null ? employeeMap.get("posts"):""%>"/>&nbsp;</td>
</tr>
<tr>
<td  class="inquire_item6">用工来源：</td>
<td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("workerfrom_name") != null ? employeeMap.get("workerfrom_name"):""%>"/>&nbsp;</td>
<td  class="inquire_item6">&nbsp;技术职称：</td>
<td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("technical_title_name") != null ? employeeMap.get("technical_title_name"):""%>"/>&nbsp;</td>
</tr>
<tr>
<td  class="inquire_item6">手机号码：</td>
<td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("mobile_number") != null ? employeeMap.get("mobile_number"):""%>"/>&nbsp;</td>
<td  class="inquire_item6">&nbsp;项目状态：</td>
<td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("if_project_name") != null ? employeeMap.get("if_project_name"):""%>"/>&nbsp;</td>
</tr>
<tr >
<td  class="inquire_item6">组织机构：</td>
<td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("org_name") != null ? employeeMap.get("org_name"):""%>"/>&nbsp;</td>
<td  class="inquire_item6">&nbsp;用工性质：</td>
<td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("if_engineer_name") != null ? employeeMap.get("if_engineer_name"):""%>"/>&nbsp;</td>
</tr>
<tr>
<td  class="inquire_item6">邮编：</td>
<td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("postal_code") != null ? employeeMap.get("postal_code"):""%>"/>&nbsp;</td>
<td  class="inquire_item6">&nbsp;劳动合同：</td>
<td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("cont_num") != null ? employeeMap.get("cont_num"):""%>"/>&nbsp;</td>
</tr>
<tr >
<td  class="inquire_item6">技能：</td>
<td  class="inquire_form6" rowspan="3"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("specialty") != null ? employeeMap.get("specialty"):""%>"/>&nbsp;</td>
   
</tr>
  </table></td></tr>
</table>

</div>
 
 
<div   id="tagContent1" style="background:#efefef" >
<table  border="0" cellpadding="0" cellspacing="0" width="100%" >
<tr><td>
  <table class="form_info" border="0" cellpadding="0" cellspacing="0" width="100%"  >
    <tr class="even">
      <td width="10%" class="even_even">姓名：</td>
      <td width="12%" class="inquire_form8_m"><%= employeeMap.get("employee_name") != null ? employeeMap.get("employee_name"):""%>&nbsp;</td>
      <td width="10%" class="inquire_item8_m">&nbsp;性别：</td>
      <td width="12%" class="inquire_form8_m"><%= employeeMap.get("employee_gender_name") != null ? employeeMap.get("employee_gender_name"):""%>&nbsp;</td>
      <td width="10%" class="inquire_item8_m">组织机构：</td>
      <td width="32%" class="inquire_form8_m"><%= employeeMap.get("org_name") != null ? employeeMap.get("org_name"):""%>&nbsp;</td>
      </tr>
    </table>
</td></tr>
<tr><td>
<table class="tab_info" border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-top:2px;">
    	<tr  >
    	    <td  class="bt_info_odd">序号</td>
            <td  class="bt_info_even">项目名称</td>
            <td class="bt_info_odd">班组</td>
            <td class="bt_info_even">岗位</td>
            <td class="bt_info_odd">进入项目时间</td>
            <td class="bt_info_even"> 离开项目时间</td>
            <td class="bt_info_odd">天数</td>
        </tr>
        <% 	if(projectMap != null && projectMap.size()>0){
			for(int i = 0;i < projectMap.size(); i++){
				MsgElement msg = (MsgElement)projectMap.get(i);
				Map project = msg.toMap(); 
       %>
     <tr >
	 <td style= "height:30px"><%= i+1 %></td>	
	 <td><%= project.get("project_name") != null ? project.get("project_name"):"" %>&nbsp;</td>	
	 <td><%= project.get("apply_team_name") != null ? project.get("apply_team_name"):"" %>&nbsp;</td>	
	 <td><%= project.get("post_name") != null ? project.get("post_name"):"" %>&nbsp;</td>
	 <td><%= project.get("start_date") != null ? project.get("start_date"):"" %>&nbsp;</td>	
	 <td><%= project.get("end_date") != null ? project.get("end_date"):"" %>&nbsp;</td>
	 <td><%= project.get("plan_days") != null ? project.get("plan_days"):"" %>&nbsp;</td>	
	 </tr>
 <% } }%>   
</table>

</td></tr>
</table>

</div>


<div  style="background:#efefef"  id="tagContent2">
<table  border="0" cellpadding="0" cellspacing="0" width="100%">
<tr><td>
  <table class="form_info" border="0" cellpadding="0" cellspacing="0" width="100%" >
    <tr class="even">
     
      <td width="10%" class="inquire_item8_m">姓名：</td>
      <td width="12%" class="inquire_form8_m"><%= employeeMap.get("employee_name") != null ? employeeMap.get("employee_name"):""%>&nbsp;</td>
      <td width="10%" class="inquire_item8_m">&nbsp;性别：</td>
      <td width="12%" class="inquire_form8_m"><%= employeeMap.get("employee_gender_name") != null ? employeeMap.get("employee_gender_name"):""%>&nbsp;</td>
      <td width="10%" class="inquire_item8_m">组织机构：</td>
      <td width="32%" class="inquire_form8_m"><%= employeeMap.get("org_name") != null ? employeeMap.get("org_name"):""%>&nbsp;</td>
      </tr>
    </table>
</td></tr>
<tr><td>
<table class="tab_info" border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-top:2px;">
    	<tr >
    	    <td  class="bt_info_odd">序号</td>
            <td class="bt_info_even">起止时间</td>
            <td class="bt_info_odd">培训项目名称</td>		
            <td class="bt_info_even">证书编号</td>
            <td class="bt_info_odd">签发机构</td>			
            <td class="bt_info_even">签发日期</td>          
            <td class="bt_info_odd">发证地点</td>
        </tr>
   
</table>
</td></tr>
</table>
</div>

 
<div  style="background:#efefef" id="tagContent3">
<table  border="0" cellpadding="0" cellspacing="0" width="100%">
<tr><td>
  <table class="form_info" border="0" cellpadding="0" cellspacing="0" width="100%" >
    <tr class="even">
     
      <td width="10%" class="inquire_item8_m">姓名：</td>
      <td width="12%" class="inquire_form8_m"><%= employeeMap.get("employee_name") != null ? employeeMap.get("employee_name"):""%>&nbsp;</td>
      <td width="10%" class="inquire_item8_m">&nbsp;性别：</td>
      <td width="12%" class="inquire_form8_m"><%= employeeMap.get("employee_gender_name") != null ? employeeMap.get("employee_gender_name"):""%>&nbsp;</td>
      <td width="10%" class="inquire_item8_m">组织机构：</td>
      <td width="32%" class="inquire_form8_m"><%= employeeMap.get("org_name") != null ? employeeMap.get("org_name"):""%>&nbsp;</td>
      </tr>
    </table>
</td></tr>
<tr><td>
<table class="form_info" border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-top:2px;">
    	<tr  >
    	    <td  class="bt_info_odd">序号</td>
            <td class="bt_info_even">证书类别</td>
            <td class="bt_info_odd">证书编号</td>		
            <td class="bt_info_even">培训机构</td>
            <td class="bt_info_odd">签发单位</td>			
            <td class="bt_info_even">签发日期</td>          
            <td class="bt_info_odd">有效期</td>
        </tr>
   
</table>
</td></tr>
</table>
</div>

<div  style="background:#efefef" id="tagContent4">
<table  border="0" cellpadding="0" cellspacing="0" width="100%">
<tr><td>
  <table class="form_info" border="0" cellpadding="0" cellspacing="0" width="100%" >
  
    <tr class="even">
     
      <td width="10%" class="inquire_item8_m">姓名：</td>
      <td width="12%" class="inquire_form8_m"><%= employeeMap.get("employee_name") != null ? employeeMap.get("employee_name"):""%>&nbsp;</td>
      <td width="10%" class="inquire_item8_m">&nbsp;性别：</td>
      <td width="12%" class="inquire_form8_m"><%= employeeMap.get("employee_gender_name") != null ? employeeMap.get("employee_gender_name"):""%>&nbsp;</td>
      <td width="42%" class="inquire_item8_m" clospan="2">
       <span class="zj"><a href="#" onClick="toAdd()"></a></span>
       <span class="xg"><a href="#" onClick="toEdit()"></a>
        <span class="sc"><a href="#" onClick="toDelete()"></a></span>
      </td>
     
      </tr>
    </table>
</td></tr>
<tr><td>
<table class="form_info" border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-top:2px;">
    	<tr class="even">
    	  <td  class="bt_info_odd">选择</td>
    	    <td class="bt_info_even">序号</td>
            <td  class="bt_info_odd">项目名称</td>
            <td class="bt_info_even">列入黑名单日期</td>		
            <td  class="bt_info_odd">列入黑名单原因</td>
        </tr>
        <% 	if(blackListMap != null && blackListMap.size()>0){
			for(int i = 0;i < blackListMap.size(); i++){
				MsgElement msg = (MsgElement)blackListMap.get(i);
				Map blackList = msg.toMap(); 
       %>
     <tr class="odd">
     <td style= "height:30px"><input type='radio' name='chx_entity_id' value='<%= blackList.get("list_id") != null ? blackList.get("list_id"):"" %>'></td>	
	 <td><%= i+1 %></td>	
	 <td><%= blackList.get("project_name") != null ? blackList.get("project_name"):"" %>&nbsp;</td>	
	 <td><%= blackList.get("list_date") != null ? blackList.get("list_date"):"" %>&nbsp;</td>	
	 <td><%= blackList.get("list_reason") != null ? blackList.get("list_reason"):"" %>&nbsp;</td>	
	 </tr>
 <% } }%>   
</table>
</td></tr>
</table>
</div>
</div>
</div>

<SCRIPT type=text/javascript>
 
	function selectTag(showContent,selfObj){
		// 标签
		var tag = document.getElementById("tags").getElementsByTagName("li");
		var taglength = tag.length;
		for(i=0; i<taglength; i++){
		tag[i].className = "";
		}
		selfObj.parentNode.className = "selectTag";
		// 标签内容
		for(i=0; j=document.getElementById("tagContent"+i); i++){
		j.style.display = "none";
		}
		document.getElementById(showContent).style.display = "block";
	}
	function toAdd(){
		
		var userName="userName="+"<%=employeeMap.get("employee_name")%>";
		userName=encodeURI(encodeURI(userName));
		var userGex="<%=employeeMap.get("employee_id_code_no")%>";
		var  laborId="<%=employeeMap.get("labor_id")%>";
		window.open ('<%=contextPath%>/rm/em/humanLabor/laborBlistModify.jsp?pagerAction=edit2Add&action=add&'+userName+'&userGex='+userGex+'&laborId='+laborId, 'newwindow', 'height=600, width=600, top=50,left=300, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no')

  	
	}
	function toEdit(){
		var userName="&userName="+"<%=employeeMap.get("employee_name")%>";
		userName=encodeURI(encodeURI(userName));
		var userGex="<%=employeeMap.get("employee_id_code_no")%>";
		var  laborId="<%=employeeMap.get("labor_id")%>";
		var obj=document.getElementsByName("chx_entity_id");
	 
	 var ids='';
		for (i=0;i<obj.length;i++){  //遍历Radio  
			if(obj[i].checked){
				    ids=obj[i].value;	
				 
			}  
		}
 
		if (ids==''){
			
			alert('请选中一条记录！');
		}else{
	 
				 window.open ('<%=contextPath%>/rm/em/humanLabor/laborBlistModify.jsp?action=edit&laborId='+laborId+'&id='+ids+userName+'&userGex='+userGex, 'newwindow', 'height=600, width=600, top=50,left=300, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
				
		}	 
	}
	
	function toDelete(){
		var obj=document.getElementsByName("chx_entity_id");
		 
		 var ids='';
			for (i=0;i<obj.length;i++){  //遍历Radio  
				if(obj[i].checked){
					    ids=obj[i].value;	
					 
				}  
			}
	 
			if (ids==''){
				
				alert('请选中一条记录！');
			}else{
		 

		deleteEntities("update BGP_COMM_HUMAN_LABOR_LIST t set t.bsflag='1',modifi_date=sysdate where t.list_id in ("+ids+")");
			}
	}
 </SCRIPT>
</body>
</html>