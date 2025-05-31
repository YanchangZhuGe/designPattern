<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page  import="java.net.URLDecoder" %>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%

	UserToken user = OMSMVCUtil.getUserToken(request);

	String contextPath = request.getContextPath();

	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	
	String wbsObjectId = request.getParameter("taskObjectId") != null ? request.getParameter("taskObjectId").toString() : "";
	String wbsName = request.getParameter("wbsName") != null ? request.getParameter("wbsName").toString() : "";
	if(wbsName != ""){
		wbsName = URLDecoder.decode(wbsName,"UTF-8");
	}
	String wbsCode = request.getParameter("wbsCode") != null ? request.getParameter("wbsCode").toString() : "";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

</head>

<body style="background:#cdddef;overflow-y: auto;">
	<div id="tag-container_3">
	  <ul id="tags" class="tags">
	    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">常用</a></li>
	  </ul>
	</div>
	
	<div id="tab_box" class="tab_box" style="overflow-y: auto;">
		<div id="tab_box_content0" class="tab_box_content">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
		       <tr align="right">
		           <td>&nbsp;</td>
		           <td width="30" id="buttonDis1" ><span class="bc"  onclick="updateWBS()"><a href="#"></a></span></td>
		           <td width="5"></td>
		       </tr>
		    </table>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   <tr>
			      <td class="inquire_item4">WBS名称：</td>
			      <td class="inquire_form4">
			      	<input name="wbs_name" id="wbs_name" class="input_width" type="text" value="<%=wbsName %>"/>
					<input type="hidden" name="wbs_object_id" id="wbs_object_id" value="<%=wbsObjectId%>"/>
				  </td>
			      <td class="inquire_item4">WBSCode：</td>
			      <td class="inquire_form4"><input name="wbs_code" id="wbs_code" class="input_width" type="text" value="<%=wbsCode%>" readonly="readonly"/></td>
			   </tr>
<!-- 			   <tr> -->
<!-- 			      <td class="inquire_item4">计划开始：</td> -->
<!-- 			      <td class="inquire_form4"><input name="startDate" class="input_width" type="text" value=""/>&nbsp;</td> -->
<!-- 			      <td class="inquire_item4">计划结束：</td> -->
<!-- 			      <td class="inquire_form4"><input name="finishDate" class="input_width" type="text" value=""/>&nbsp;</td> -->
<!-- 			   </tr> -->
			</table>
		</div>
	</div>
</body>
<script type="text/javascript">

function updateWBS(){
	
	var str = "wbs_name="+document.getElementById("wbs_name").value;
	str += "&wbs_object_id="+encodeURI(encodeURI(document.getElementById("wbs_object_id").value));
	str += "&wbs_code="+document.getElementById("wbs_code").value;
	
	var obj = jcdpCallService("P6ProjectPlanSrv", "updateWBS", str);
	
	if(obj != null && obj.message == "success") {
		alert("修改成功");
		reload();
	} else {
		alert("修改失败");
	}
}

function reload(){
	var ctt = top.frames['list'];
	if(ctt != "" && ctt != undefined){
		ctt.location.reload();
	}
}

function frameSize(){

	var height = $(window).height()-$("#head").height()-$("#head_bot").height()-$("#mainTopframe").height();

	$("#tab_box").css("height",400);
	//$("#tab_box").css("height",$(window).height()-$("#head").height()-$("#head_bot").height()-$("#mainTopframe").height()-60);

	var width = $(window).width()-$("#page_aside").width()-$("#navHidBtn").width();

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

	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	var selectedTag=document.getElementsByTagName("li")[0];

	function getTab(obj,index) {  

		if(selectedTag!=null){

			selectedTag.className ="";

		}

		selectedTag = obj.parentElement;

		selectedTag.className ="selectTag";

	}


</script>

</html>

