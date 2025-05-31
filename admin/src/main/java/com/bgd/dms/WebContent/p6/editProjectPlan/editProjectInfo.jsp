<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page  import="java.net.URLDecoder" %>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.bgp.mcs.service.pm.service.project.P6ProjectPlanSrv,com.cnpc.jcdp.cfg.BeanFactory"%>

<%

	UserToken user = OMSMVCUtil.getUserToken(request);

	String contextPath = request.getContextPath();
	String projectInfoNo = request.getParameter("projectInfoNo");

	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	P6ProjectPlanSrv planSrv =  new P6ProjectPlanSrv("P6RelationshipWSBean");
	Map map = planSrv.getProjectDate(projectInfoNo);
	String plan_start_date= (String)map.get("planStartDate");
	String last_recalc_date= (String)map.get("lastRecalcDate");
	String PROJ_ID = (String)map.get("projId");
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />

<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>

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
		           <td width="30" id="buttonDis1" ><span class="bc"  onclick="updateProjectDate()"><a href="#"></a></span></td>
		           <td width="5"></td>
		       </tr>
		    </table>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   <tr>
			      <td class="inquire_item4">项目计划开始时间：</td>
			 	<td class="inquire_from4"><input name="plan_start_date" id="plan_start_date" class="input_width"  type="text" readonly="readonly" value="<%=plan_start_date%>"/>
      			  <img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(plan_start_date,tributton1);" />
				  </td>
			      <td class="inquire_item4">数据日期：</td>		   
			       <td class="inquire_from4"><input name="last_recalc_date" id="last_recalc_date" class="input_width" readonly="readonly" type="text" value="<%=last_recalc_date%>"/>
      			  <img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(last_recalc_date,tributton2);" />
				  </td>
			   </tr>
			</table>
		</div>
	</div>
</body>
<script type="text/javascript">

function updateProjectDate(){
	
	var str = "plan_start_date="+document.getElementById("plan_start_date").value;
	str += "&last_recalc_date="+document.getElementById("last_recalc_date").value;	
	str += "&proj_id=<%=PROJ_ID%>";

	
	var obj = jcdpCallService("P6ProjectPlanSrv", "updateProjectDate", str);
	
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

