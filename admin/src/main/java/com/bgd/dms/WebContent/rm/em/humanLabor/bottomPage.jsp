 
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

<title>��Ա��Ϣ</title>
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
  <li class="selectTag"><A onClick="selectTag('tagContent0',this)" href="javascript:void(0)">������Ϣ</A></li> 
  <li><A onClick="selectTag('tagContent1',this)"  href="javascript:void(0)">��Ŀ����</A></li>
  <li><A onClick="selectTag('tagContent2',this)"  href="javascript:void(0)">��ѵ����</A></li>
  <li><A onClick="selectTag('tagContent3',this)"  href="javascript:void(0)">�ʸ�֤����Ϣ</A></li>
  <li><A onClick="selectTag('tagContent4',this)"  href="javascript:void(0)">��������Ϣ</A></li>
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
      <td   class="inquire_item6">������</td>
      <td   class="inquire_form6" ><input name="" class="input_width" type="text"  value="<%= employeeMap.get("employee_name") != null ? employeeMap.get("employee_name"):""%>"/> &nbsp;</td>
      <td  class="inquire_item6">&nbsp;�Ա�</td>
      <td  class="inquire_form6"  ><input name="" class="input_width" type="text"  value="<%= employeeMap.get("employee_gender_name") != null ? employeeMap.get("employee_gender_name"):""%>"/>&nbsp;</td>
     </tr>
     <tr >
     <td  class="inquire_item6">�������£�</td>
     <td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("employee_birth_date") != null ? employeeMap.get("employee_birth_date"):""%>"/>&nbsp;</td>
     <td  class="inquire_item6">&nbsp;���壺</td>
     <td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("employee_nation_name") != null ? employeeMap.get("employee_nation_name"):""%>"/>&nbsp;</td>
    </tr>
    <tr>
    <td  class="inquire_item6">���֤�ţ�</td>
    <td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("employee_id_code_no") != null ? employeeMap.get("employee_id_code_no"):""%>"/>&nbsp;</td>
    <td  class="inquire_item6">&nbsp;�Ļ��̶ȣ�</td>
    <td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("employee_education_level_name") != null ? employeeMap.get("employee_education_level_name"):""%>"/>&nbsp;</td>
   </tr>
   <tr>
   <td  class="inquire_item6">��ͥסַ��</td>
   <td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("employee_address") != null ? employeeMap.get("employee_address"):""%>"/>&nbsp;</td>
   <td  class="inquire_item6">&nbsp;��ϵ�绰��</td>
   <td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("phone_num") != null ? employeeMap.get("phone_num"):""%>&nbsp;"/></td>
  </tr>
  <tr>
  <td  class="inquire_item6">������Ϣ��</td>
  <td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("employee_health_info") != null ? employeeMap.get("employee_health_info"):""%>"/>&nbsp;</td>
  <td  class="inquire_item6">&nbsp;�Ƿ�Ǹɣ�</td>
  <td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("elite_if_name") != null ? employeeMap.get("elite_if_name"):""%>"/>&nbsp;</td>
 </tr>
 <tr >
 <td  class="inquire_item6">���飺</td>
 <td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("apply_teams") != null ? employeeMap.get("apply_teams"):""%>"/>&nbsp;</td>
 <td  class="inquire_item6">&nbsp;��λ��</td>
 <td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("posts") != null ? employeeMap.get("posts"):""%>"/>&nbsp;</td>
</tr>
<tr>
<td  class="inquire_item6">�ù���Դ��</td>
<td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("workerfrom_name") != null ? employeeMap.get("workerfrom_name"):""%>"/>&nbsp;</td>
<td  class="inquire_item6">&nbsp;����ְ�ƣ�</td>
<td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("technical_title_name") != null ? employeeMap.get("technical_title_name"):""%>"/>&nbsp;</td>
</tr>
<tr>
<td  class="inquire_item6">�ֻ����룺</td>
<td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("mobile_number") != null ? employeeMap.get("mobile_number"):""%>"/>&nbsp;</td>
<td  class="inquire_item6">&nbsp;��Ŀ״̬��</td>
<td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("if_project_name") != null ? employeeMap.get("if_project_name"):""%>"/>&nbsp;</td>
</tr>
<tr >
<td  class="inquire_item6">��֯������</td>
<td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("org_name") != null ? employeeMap.get("org_name"):""%>"/>&nbsp;</td>
<td  class="inquire_item6">&nbsp;�ù����ʣ�</td>
<td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("if_engineer_name") != null ? employeeMap.get("if_engineer_name"):""%>"/>&nbsp;</td>
</tr>
<tr>
<td  class="inquire_item6">�ʱࣺ</td>
<td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("postal_code") != null ? employeeMap.get("postal_code"):""%>"/>&nbsp;</td>
<td  class="inquire_item6">&nbsp;�Ͷ���ͬ��</td>
<td  class="inquire_form6"><input name="" class="input_width" type="text"  value="<%= employeeMap.get("cont_num") != null ? employeeMap.get("cont_num"):""%>"/>&nbsp;</td>
</tr>
<tr >
<td  class="inquire_item6">���ܣ�</td>
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
      <td width="10%" class="even_even">������</td>
      <td width="12%" class="inquire_form8_m"><%= employeeMap.get("employee_name") != null ? employeeMap.get("employee_name"):""%>&nbsp;</td>
      <td width="10%" class="inquire_item8_m">&nbsp;�Ա�</td>
      <td width="12%" class="inquire_form8_m"><%= employeeMap.get("employee_gender_name") != null ? employeeMap.get("employee_gender_name"):""%>&nbsp;</td>
      <td width="10%" class="inquire_item8_m">��֯������</td>
      <td width="32%" class="inquire_form8_m"><%= employeeMap.get("org_name") != null ? employeeMap.get("org_name"):""%>&nbsp;</td>
      </tr>
    </table>
</td></tr>
<tr><td>
<table class="tab_info" border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-top:2px;">
    	<tr  >
    	    <td  class="bt_info_odd">���</td>
            <td  class="bt_info_even">��Ŀ����</td>
            <td class="bt_info_odd">����</td>
            <td class="bt_info_even">��λ</td>
            <td class="bt_info_odd">������Ŀʱ��</td>
            <td class="bt_info_even"> �뿪��Ŀʱ��</td>
            <td class="bt_info_odd">����</td>
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
     
      <td width="10%" class="inquire_item8_m">������</td>
      <td width="12%" class="inquire_form8_m"><%= employeeMap.get("employee_name") != null ? employeeMap.get("employee_name"):""%>&nbsp;</td>
      <td width="10%" class="inquire_item8_m">&nbsp;�Ա�</td>
      <td width="12%" class="inquire_form8_m"><%= employeeMap.get("employee_gender_name") != null ? employeeMap.get("employee_gender_name"):""%>&nbsp;</td>
      <td width="10%" class="inquire_item8_m">��֯������</td>
      <td width="32%" class="inquire_form8_m"><%= employeeMap.get("org_name") != null ? employeeMap.get("org_name"):""%>&nbsp;</td>
      </tr>
    </table>
</td></tr>
<tr><td>
<table class="tab_info" border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-top:2px;">
    	<tr >
    	    <td  class="bt_info_odd">���</td>
            <td class="bt_info_even">��ֹʱ��</td>
            <td class="bt_info_odd">��ѵ��Ŀ����</td>		
            <td class="bt_info_even">֤����</td>
            <td class="bt_info_odd">ǩ������</td>			
            <td class="bt_info_even">ǩ������</td>          
            <td class="bt_info_odd">��֤�ص�</td>
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
     
      <td width="10%" class="inquire_item8_m">������</td>
      <td width="12%" class="inquire_form8_m"><%= employeeMap.get("employee_name") != null ? employeeMap.get("employee_name"):""%>&nbsp;</td>
      <td width="10%" class="inquire_item8_m">&nbsp;�Ա�</td>
      <td width="12%" class="inquire_form8_m"><%= employeeMap.get("employee_gender_name") != null ? employeeMap.get("employee_gender_name"):""%>&nbsp;</td>
      <td width="10%" class="inquire_item8_m">��֯������</td>
      <td width="32%" class="inquire_form8_m"><%= employeeMap.get("org_name") != null ? employeeMap.get("org_name"):""%>&nbsp;</td>
      </tr>
    </table>
</td></tr>
<tr><td>
<table class="form_info" border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-top:2px;">
    	<tr  >
    	    <td  class="bt_info_odd">���</td>
            <td class="bt_info_even">֤�����</td>
            <td class="bt_info_odd">֤����</td>		
            <td class="bt_info_even">��ѵ����</td>
            <td class="bt_info_odd">ǩ����λ</td>			
            <td class="bt_info_even">ǩ������</td>          
            <td class="bt_info_odd">��Ч��</td>
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
     
      <td width="10%" class="inquire_item8_m">������</td>
      <td width="12%" class="inquire_form8_m"><%= employeeMap.get("employee_name") != null ? employeeMap.get("employee_name"):""%>&nbsp;</td>
      <td width="10%" class="inquire_item8_m">&nbsp;�Ա�</td>
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
    	  <td  class="bt_info_odd">ѡ��</td>
    	    <td class="bt_info_even">���</td>
            <td  class="bt_info_odd">��Ŀ����</td>
            <td class="bt_info_even">�������������</td>		
            <td  class="bt_info_odd">���������ԭ��</td>
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
		// ��ǩ
		var tag = document.getElementById("tags").getElementsByTagName("li");
		var taglength = tag.length;
		for(i=0; i<taglength; i++){
		tag[i].className = "";
		}
		selfObj.parentNode.className = "selectTag";
		// ��ǩ����
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
		for (i=0;i<obj.length;i++){  //����Radio  
			if(obj[i].checked){
				    ids=obj[i].value;	
				 
			}  
		}
 
		if (ids==''){
			
			alert('��ѡ��һ����¼��');
		}else{
	 
				 window.open ('<%=contextPath%>/rm/em/humanLabor/laborBlistModify.jsp?action=edit&laborId='+laborId+'&id='+ids+userName+'&userGex='+userGex, 'newwindow', 'height=600, width=600, top=50,left=300, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
				
		}	 
	}
	
	function toDelete(){
		var obj=document.getElementsByName("chx_entity_id");
		 
		 var ids='';
			for (i=0;i<obj.length;i++){  //����Radio  
				if(obj[i].checked){
					    ids=obj[i].value;	
					 
				}  
			}
	 
			if (ids==''){
				
				alert('��ѡ��һ����¼��');
			}else{
		 

		deleteEntities("update BGP_COMM_HUMAN_LABOR_LIST t set t.bsflag='1',modifi_date=sysdate where t.list_id in ("+ids+")");
			}
	}
 </SCRIPT>
</body>
</html>