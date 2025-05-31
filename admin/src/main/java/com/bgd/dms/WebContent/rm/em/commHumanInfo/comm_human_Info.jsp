<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>

<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	Map employeeMap = new HashMap();
	
	if(respMsg.getMsgElement("employeeMap") != null){
		employeeMap = respMsg.getMsgElement("employeeMap").toMap();
	}
	List recordMap = respMsg.getMsgElements("recordMap");
	List trainMap = respMsg.getMsgElements("trainMap");
	List projectMap = respMsg.getMsgElements("projectMap");
	List educationMap = respMsg.getMsgElements("educationMap");
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>人员信息</title>
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<link href="<%=contextPath%>/dialog/jquery_dialog.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/dialog/jquery.js"></script>
<script type="text/javascript" src="<%=contextPath%>/dialog/jquery_dialog.js"></script>
</head>
<body>

    
<div id="tag-container_3" >
<ul id="tags" class="tags">
  <li class="selectTag"><A onclick="getTab(this,0)"  href="javascript:void(0)">人员基本信息</A></li> 
  <li><A onclick="getTab(this,1)"  href="javascript:void(0)">工作履历</A></li>
  <li><A onclick="getTab(this,2)"  href="javascript:void(0)">项目经历</A></li>
  <li><A onclick="getTab(this,3)"  href="javascript:void(0)">培训信息</A></li>
  <li><A onclick="getTab(this,4)"  href="javascript:void(0)">教育经历</A></li>
</ul>
</div>

<div id="tab_box" style="background:#efefef;">
<div id="tab_box_content0">
<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%"> 
    <tr  >
      <td class="inquire_item8">人员编号：</td>
      <td class="inquire_form8"><%= employeeMap.get("employee_cd") != null ? employeeMap.get("employee_cd"):""%>&nbsp;</td>
      <td class="inquire_item8">姓名：</td>
      <td class="inquire_form8"><%= employeeMap.get("employee_name") != null ? employeeMap.get("employee_name"):""%>&nbsp;</td>
      <td class="inquire_item8">&nbsp;性别：</td>
      <td class="inquire_form8"><%= employeeMap.get("employee_gender") != null ? employeeMap.get("employee_gender"):""%>&nbsp;</td>
      <td class="inquire_item8">年龄：</td>
      <td class="inquire_form8"><%= employeeMap.get("age") != null ? employeeMap.get("age"):""%>&nbsp;</td>
      </tr>
    <tr  >
      <td class="inquire_item8">民族：</td>
      <td class="inquire_form8"><%= employeeMap.get("employee_nation_name") != null ? employeeMap.get("employee_nation_name"):""%>&nbsp;</td>
      <td class="inquire_item8">国籍：</td>
      <td class="inquire_form8"><%= employeeMap.get("nationality_name") != null ? employeeMap.get("nationality_name"):""%>&nbsp; </td>
      <td class="inquire_item8">文化程度：</td>
      <td class="inquire_form8"><%= employeeMap.get("employee_education_level_name") != null ? employeeMap.get("employee_education_level_name"):""%>&nbsp; </td>
      <td class="inquire_item8">员工类型：</td>
      <td class="inquire_form8"><%= employeeMap.get("employee_gz_name") != null ? employeeMap.get("employee_gz_name"):""%>&nbsp; </td>
      </tr>
    <tr  >
      <td class="inquire_item8">岗位：</td>
      <td class="inquire_form8"><%= employeeMap.get("post") != null ? employeeMap.get("post"):""%>&nbsp;</td>
      <td class="inquire_item8">岗位类别：</td>
      <td class="inquire_form8"><%= employeeMap.get("post_sort_name") != null ? employeeMap.get("post_sort_name"):""%>&nbsp;</td>
      <td class="inquire_item8">职位级别：</td>
      <td class="inquire_form8"><%= employeeMap.get("post_level_name") != null ? employeeMap.get("post_level_name"):""%>&nbsp;</td>
      <td class="inquire_item8">用工来源：</td>
      <td class="inquire_form8"><%= employeeMap.get("workerfrom_name") != null ? employeeMap.get("workerfrom_name"):""%>&nbsp;</td>
      </tr>
    <tr  >
      <td class="inquire_item8">外语语种：</td>
      <td class="inquire_form8"><%= employeeMap.get("language_sort_name") != null ? employeeMap.get("language_sort_name"):""%>&nbsp;</td>
      <td class="inquire_item8">外语级别：</td>
      <td class="inquire_form8"><%= employeeMap.get("language_level_name") != null ? employeeMap.get("language_level_name"):""%>&nbsp;</td>
      <td class="inquire_item8">参加工作时间：</td>
      <td class="inquire_form8"><%= employeeMap.get("work_date") != null ? employeeMap.get("work_date"):""%>&nbsp;</td>
      <td class="inquire_item8">进入中石油时间：</td>
      <td class="inquire_form8"><%= employeeMap.get("work_cnpc_date") != null ? employeeMap.get("work_cnpc_date"):""%>&nbsp;</td>
      </tr>
    <tr  >
      <td class="inquire_item8">组织机构：</td>
      <td class="inquire_form8"><%= employeeMap.get("org_name") != null ? employeeMap.get("org_name"):""%>&nbsp;</td>
      <td class="inquire_item8">邮箱：</td>
      <td class="inquire_form8"><%= employeeMap.get("mail_address") != null ? employeeMap.get("mail_address"):""%>&nbsp;</td>
      <td class="inquire_item8">固定电话：</td>
      <td class="inquire_form8"><%= employeeMap.get("phone_num") != null ? employeeMap.get("phone_num"):""%>&nbsp;</td>
      <td class="inquire_item8">手机：</td>
      <td class="inquire_form8"><%= employeeMap.get("employee_mobile_phone") != null ? employeeMap.get("employee_mobile_phone"):""%>&nbsp;</td>
      </tr>
     
     <tr  >
      <td class="inquire_item8">设置班组：</td>
      <td class="inquire_form8"><%= employeeMap.get("set_team_name") != null ? employeeMap.get("set_team_name"):""%>&nbsp;</td>
      <td class="inquire_item8">设置岗位：</td>
      <td class="inquire_form8"><%= employeeMap.get("set_post_name") != null ? employeeMap.get("set_post_name"):""%>&nbsp;</td>
      <td class="inquire_item8">用工分布：</td>
      <td class="inquire_form8"><%= employeeMap.get("spare7") != null ? employeeMap.get("spare7"):""%>&nbsp;</td>  
      <td class="inquire_item8">&nbsp;</td>
      <td class="inquire_form8">&nbsp;</td>

    </tr>
</table>

</div>


<div id="tab_box_content1" >
<table  border="0" cellpadding="0" cellspacing="0" width="100%">
<tr><td>
  <table class="tab_line_height" border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr  >
      <td class="inquire_item8">人员编号：</td>
      <td class="inquire_form8"><%= employeeMap.get("employee_cd") != null ? employeeMap.get("employee_cd"):""%>&nbsp;</td>
      <td class="inquire_item8">姓名：</td>
      <td class="inquire_form8"><%= employeeMap.get("employee_name") != null ? employeeMap.get("employee_name"):""%>&nbsp;</td>
      <td class="inquire_item8">&nbsp;性别：</td>
      <td class="inquire_form8"><%= employeeMap.get("employee_gender") != null ? employeeMap.get("employee_gender"):""%>&nbsp;</td>
      <td class="inquire_item8">组织机构：</td>
      <td class="inquire_form8"><%= employeeMap.get("org_name") != null ? employeeMap.get("org_name"):""%>&nbsp;</td>
      </tr>
    </table>
</td></tr>
<tr><td>
<div id="table_box">
   <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;">
    	<tr  >
    	    <td class="bt_info_odd">序号</td>
            <td class="bt_info_even">开始时间</td>
            <td class="bt_info_odd">结束时间</td>		
            <td class="bt_info_even">工作单位</td>
            <td class="bt_info_odd">岗位</td>			
            <td class="bt_info_even">行政级别</td>           
            <td class="bt_info_odd">技术职称</td>
            <td class="bt_info_even">技能级别</td>
        </tr>
         <% 	if(recordMap != null && recordMap.size()>0){
    				for(int i = 0;i < recordMap.size(); i++){
    					MsgElement msg = (MsgElement)recordMap.get(i);
    					Map record = msg.toMap(); 
    					String classCss = "";
         %>
         		<% if(i % 2 == 1){  classCss = "even";%>
					<%}else{ classCss = "odd"; %>
					<% }%>
         	 <tr>
        	 <td class="<%=classCss%>_odd" ><%= i+1 %></td>	
			 <td class="<%=classCss%>_even"><%= record.get("start_date") != null ? record.get("start_date"):"" %>&nbsp;</td>	
			 <td class="<%=classCss%>_odd" ><%= record.get("end_date") != null ? record.get("end_date"):"" %>&nbsp;</td>	
			 <td class="<%=classCss%>_even"><%= record.get("company") != null ? record.get("company"):"" %>&nbsp;</td>
			 <td class="<%=classCss%>_odd" ><%= record.get("post") != null ? record.get("post"):"" %>&nbsp;</td>
			 <td class="<%=classCss%>_even"><%= record.get("administration") != null ? record.get("administration"):"" %>&nbsp;</td>
			 <td class="<%=classCss%>_odd" ><%= record.get("technology") != null ? record.get("technology"):"" %>&nbsp;</td>
			 <td class="<%=classCss%>_even"><%= record.get("skillname") != null ? record.get("skillname"):"" %>&nbsp;</td>
			 </tr>
         <% } }%>
	</table>
</div>
</td></tr>
</table>
</div>


<div id="tab_box_content2">
<table  border="0" cellpadding="0" cellspacing="0" width="100%">
<tr><td>
  <table class="tab_line_height" border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr  >
      <td class="inquire_item8">人员编号：</td>
      <td class="inquire_form8"><%= employeeMap.get("employee_cd") != null ? employeeMap.get("employee_cd"):""%>&nbsp;</td>
      <td class="inquire_item8">姓名：</td>
      <td class="inquire_form8"><%= employeeMap.get("employee_name") != null ? employeeMap.get("employee_name"):""%>&nbsp;</td>
      <td class="inquire_item8">&nbsp;性别：</td>
      <td class="inquire_form8"><%= employeeMap.get("employee_gender") != null ? employeeMap.get("employee_gender"):""%>&nbsp;</td>
      <td class="inquire_item8">组织机构：</td>
      <td class="inquire_form8"><%= employeeMap.get("org_name") != null ? employeeMap.get("org_name"):""%>&nbsp;</td>
      </tr>
    </table>
</td></tr>
<tr><td>
<table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;">
    	<tr  >
    	    <td class="bt_info_odd">序号</td>
            <td class="bt_info_even">项目名称</td>
            <td class="bt_info_odd">类型</td>		
            <td class="bt_info_even">项目开始日期</td>
            <td class="bt_info_odd">项目结束日期</td>			
            <td class="bt_info_even">进入项目日期</td>          
            <td class="bt_info_odd">离开项目日期</td>
            <td class="bt_info_even">班组</td>
            <td class="bt_info_odd">岗位</td>
            <td class="bt_info_even">人员评价</td>
        </tr>
                 <% 	if(projectMap != null && projectMap.size()>0){
    				for(int i = 0;i < projectMap.size(); i++){
    					MsgElement msg = (MsgElement)projectMap.get(i);
    					Map project = msg.toMap(); 
    					String classCss = "";
         %>
                  	<% if(i % 2 == 1){  classCss = "even";%>
					<%}else{ classCss = "odd"; %>
					<% }%>
             <tr>
        	 <td class="<%=classCss%>_odd"><%= i+1 %></td>	
        	 <td class="<%=classCss%>_even"><%= project.get("project_name") != null ? project.get("project_name"):"" %>&nbsp;</td>	
        	 <td class="<%=classCss%>_odd"><%= project.get("project_type_name") != null ? project.get("project_type_name"):"" %>&nbsp;</td>	
			 <td class="<%=classCss%>_even"><%= project.get("plan_start_date") != null ? project.get("plan_start_date"):"" %>&nbsp;</td>	
			 <td class="<%=classCss%>_odd"><%= project.get("plan_end_date") != null ? project.get("plan_end_date"):"" %>&nbsp;</td>
			 <td class="<%=classCss%>_even"><%= project.get("actual_start_date") != null ? project.get("actual_start_date"):"" %>&nbsp;</td>	
			 <td class="<%=classCss%>_odd"><%= project.get("actual_end_date") != null ? project.get("actual_end_date"):"" %>&nbsp;</td>
			 <td class="<%=classCss%>_even"><%= project.get("teamname") != null ? project.get("teamname"):"" %>&nbsp;</td>	
			 <td class="<%=classCss%>_odd"><%= project.get("postname") != null ? project.get("postname"):"" %>&nbsp;</td>
			 <td class="<%=classCss%>_even"><%= project.get("project_evaluate") != null ? project.get("project_evaluate"):"" %>&nbsp;</td>
			 </tr>
         <% } }%>
</table>

</td></tr>
</table>

</div>


<div id="tab_box_content3">
<table  border="0" cellpadding="0" cellspacing="0" width="100%">
<tr><td>
  <table class="tab_line_height" border="0" cellpadding="0" cellspacing="0" width="100%" >
    <tr  >
      <td class="inquire_item8">人员编号：</td>
      <td class="inquire_form8"><%= employeeMap.get("employee_cd") != null ? employeeMap.get("employee_cd"):""%>&nbsp;</td>
      <td class="inquire_item8">姓名：</td>
      <td class="inquire_form8"><%= employeeMap.get("employee_name") != null ? employeeMap.get("employee_name"):""%>&nbsp;</td>
      <td class="inquire_item8">&nbsp;性别：</td>
      <td class="inquire_form8"><%= employeeMap.get("employee_gender") != null ? employeeMap.get("employee_gender"):""%>&nbsp;</td>
      <td class="inquire_item8">组织机构：</td>
      <td class="inquire_form8"><%= employeeMap.get("org_name") != null ? employeeMap.get("org_name"):""%>&nbsp;</td>
      </tr>
    </table>
</td></tr>
<tr><td>
<table class="tab_line_height" border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-top:2px;">
    	<tr  >
    	    <td class="bt_info_odd">序号</td>
            <td class="bt_info_even">开始时间</td>
            <td class="bt_info_odd">结束时间</td>		
            <td class="bt_info_even">培训班名称</td>
            <td class="bt_info_odd">培训内容</td>			
            <td class="bt_info_even">培训级别</td>          
            <td class="bt_info_odd">培训渠道</td>
            <td class="bt_info_even">培训分类</td>
            <td class="bt_info_odd">培训形式</td>
            <td class="bt_info_even">培训结果</td>
            <td class="bt_info_odd">培训地点</td>
        </tr>
         <% 	if(trainMap != null && trainMap.size()>0){
    				for(int i = 0;i < trainMap.size(); i++){
    					MsgElement msg = (MsgElement)trainMap.get(i);
    					Map train = msg.toMap(); 
    					String classCss = "";
         %>
              	<% if(i % 2 == 1){  classCss = "even";%>
					<%}else{ classCss = "odd"; %>
					<% }%>
             <tr>
        	 <td class="<%=classCss%>_odd"><%= i+1 %></td>	
			 <td class="<%=classCss%>_even"><%= train.get("start_date") != null ? train.get("start_date"):"" %>&nbsp;</td>	
			 <td class="<%=classCss%>_odd"><%= train.get("end_date") != null ? train.get("end_date"):"" %>&nbsp;</td>
			 <td class="<%=classCss%>_even"><%= train.get("class_name") != null ? train.get("class_name"):"" %>&nbsp;</td>
			 <td class="<%=classCss%>_odd"><%= train.get("train_content") != null ? train.get("train_content"):"" %>&nbsp;</td>
			 <td class="<%=classCss%>_even"><%= train.get("train_level") != null ? train.get("train_level"):"" %>&nbsp;</td>
			 <td class="<%=classCss%>_odd"><%= train.get("train_channel") != null ? train.get("train_channel"):"" %>&nbsp;</td>
			 <td class="<%=classCss%>_even"><%= train.get("train_sort") != null ? train.get("train_sort"):"" %>&nbsp;</td>
			 <td class="<%=classCss%>_odd"><%= train.get("train_form") != null ? train.get("train_form"):"" %>&nbsp;</td>
			 <td class="<%=classCss%>_even"><%= train.get("train_result") != null ? train.get("train_result"):"" %>&nbsp;</td>
			 <td class="<%=classCss%>_odd"><%= train.get("train_place") != null ? train.get("train_place"):"" %>&nbsp;</td>
			 </tr>
         <% } }%>
</table>
</td></tr>
</table>
</div>


<div id="tab_box_content4">
<table  border="0" cellpadding="0" cellspacing="0" width="100%">
<tr><td>
  <table class="tab_line_height" border="0" cellpadding="0" cellspacing="0" width="100%" >
    <tr  >
      <td class="inquire_item8">人员编号：</td>
      <td class="inquire_form8"><%= employeeMap.get("employee_cd") != null ? employeeMap.get("employee_cd"):""%>&nbsp;</td>
      <td class="inquire_item8">姓名：</td>
      <td class="inquire_form8"><%= employeeMap.get("employee_name") != null ? employeeMap.get("employee_name"):""%>&nbsp;</td>
      <td class="inquire_item8">&nbsp;性别：</td>
      <td class="inquire_form8"><%= employeeMap.get("employee_gender") != null ? employeeMap.get("employee_gender"):""%>&nbsp;</td>
      <td class="inquire_item8">组织机构：</td>
      <td class="inquire_form8"><%= employeeMap.get("org_name") != null ? employeeMap.get("org_name"):""%>&nbsp;</td>
      </tr>
    </table>
</td></tr>
<tr><td>
<table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;">
    	<tr  >
    	    <td class="bt_info_odd">序号</td>
            <td class="bt_info_even">开始时间</td>
            <td class="bt_info_odd">结束时间</td>		
            <td class="bt_info_even">毕业院校</td>
            <td class="bt_info_odd">所学专业</td>			
            <td class="bt_info_even">学历</td>          
        </tr>
         <% 	if(educationMap != null && educationMap.size()>0){
    				for(int i = 0;i < educationMap.size(); i++){
    					MsgElement msg = (MsgElement)educationMap.get(i);
    					Map education = msg.toMap(); 
    					String classCss = "";
         %>
                 <% if(i % 2 == 1){  classCss = "even";%>
					<%}else{ classCss = "odd"; %>
					<% }%>
             <tr>
        	 <td class="<%=classCss%>_odd"><%= i+1 %></td>	
			 <td class="<%=classCss%>_even"><%= education.get("start_date") != null ? education.get("start_date"):"" %>&nbsp;</td>	
			 <td class="<%=classCss%>_odd"><%= education.get("finish_date") != null ? education.get("finish_date"):"" %>&nbsp;</td>
			 <td class="<%=classCss%>_even"><%= education.get("school_name") != null ? education.get("school_name"):"" %>&nbsp;</td>
			 <td class="<%=classCss%>_odd"><%= education.get("profess") != null ? education.get("profess"):"" %>&nbsp;</td>
			 <td class="<%=classCss%>_even"><%= education.get("education") != null ? education.get("education"):"" %>&nbsp;</td>
			 </tr>
         <% } }%>
</table>
</td></tr>
</table>
</div>

</div>
<script type="text/javascript">
function frameSize(){
	var height = $(window).height()-$("#frame_header").height()-$("#frame_foot").height()-$("#list_nav").height();
	$("#tab_box_content").css("height",$(window).height()-$("#frame_header").height()-$("#frame_foot").height()-$("#list_nav").height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	var width = $(window).width()-$("#navHid").width()-$("#frame_nav").width();
	$("#frame_ctt").css("width",width);
	$("#navHid a").css("margin-top",height/2-22);
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	
</script>
<script type="text/javascript">

	
	function getTab(selfObj,showContent){
		// 标签
		var tag = document.getElementById("tags").getElementsByTagName("li");
		var taglength = tag.length;
		for(i=0; i<taglength; i++){
		tag[i].className = "";
		}
		selfObj.parentNode.className = "selectTag";
		// 标签内容
		for(i=0; j=document.getElementById("tab_box_content"+i); i++){
		j.style.display = "none";
		}
		document.getElementById("tab_box_content"+showContent).style.display = "block";
	}


</script>
</body>
</html>