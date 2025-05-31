<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.net.URLDecoder" %>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
    //获取当前的项目编号，作为树的最顶层
    //String root_folderId = request.getParameter("rootFolderId").toString();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo") != null ? request.getParameter("projectInfoNo").toString() : "";
	String parentWbsObjectId = request.getParameter("parentWbsObjectId") != null ? request.getParameter("parentWbsObjectId").toString() : "";
	String parentWbsName = request.getParameter("parentWbsName") != null ? request.getParameter("parentWbsName").toString() : "";
	if(parentWbsName != ""){
		parentWbsName = URLDecoder.decode(parentWbsName,"UTF-8");
	}
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>增加WBS</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>

</head>
<body>
<form name="form1" id="form1" method="post" action="<%=contextPath%>/pm/p6/addWBS.srq">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg" style="height: 170px;">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
  	<tr>
    	<td colspan="4" align="center">增加WBS(名称和分类码不能重复)</td>
    </tr>
    <tr>
    	<td class="inquire_item4">上级WBS：</td>
      	<td class="inquire_form4">
      	<input type="text" name="parent_wbs_name" id="parent_wbs_name" value="<%=parentWbsName%>" class="input_width" readonly="readonly"/>
      	<input type="hidden" name="parent_wbs_object_id" id="parent_wbs_object_id" value="<%=parentWbsObjectId%>"/>
      	<input type="hidden" name="project_info_no" id="project_info_no" value="<%=projectInfoNo%>"/>
      	<input type="hidden" name="ordercode" id="ordercode" value="">  
      	</td>
    	<td class="inquire_item4"><font color="red">*</font>WBS名称：</td>
      	<td class="inquire_form4"><input type="text" name="wbs_name" id="wbs_name" class="input_width"/></td>
    </tr>
    <tr>
    	<td class="inquire_item4"><font color="red">*</font>WBS分类码：</td>
      	<td class="inquire_form4"><input type="text" name="wbs_code" id="wbs_code" class="input_width" readonly="readonly"/></td>
      	
      	<td class="inquire_item4"><font color="red"></font>责任人：</td>
      	<td class="inquire_form4"><input type="text" name="wbs_head" id="wbs_head" class="input_width"/></td>

    </tr>
  </table> 
</div>
    <div id="oper_div">
     <span class="tj_btn"><a href="#" onclick="save()"></a></span>
    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>

        
    </div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">


	cruConfig.contextPath = "<%=contextPath%>";	
	
	getNextWbsCode();
	
	function cancel()
	{
		window.close();
	}
		
	
	function save(){
		if(checkForm()){
			var str = $("#form1").serialize();				
			var result = jcdpCallService("P6ProjectPlanSrv", "addWBS", str);
			reload();
			window.setTimeout(newClose(),2000);
	}
}
	
	function checkForm(){ 	
	
		if (!isTextPropertyNotNull("wbs_name", "WBS名称")) {		
			document.form1.activity_name.focus();
			return false;	
		}
		return true;
	}	
	
	function getNextWbsCode(){
		var parentWbsObjectId = "<%=parentWbsObjectId%>";
		var str = "project_info_no=<%=projectInfoNo%>&parent_wbs_object_id="+parentWbsObjectId;
		var obj = jcdpCallService("P6ProjectPlanSrv", "getNextWbsCode", str);
		if(obj != null && obj.wbsObjectId != "") {
			document.getElementById("wbs_code").value = obj.wbsObjectId;
			document.getElementById("ordercode").value = obj.ordercode;
			
			
		} 
	}


	
	function reload(){
		var ctt = top.frames('list');
		ctt.refreshTree('<%=parentWbsObjectId%>');

	}
</script>

</html>