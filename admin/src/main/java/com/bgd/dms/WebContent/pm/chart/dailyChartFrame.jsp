<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page  import="java.util.*" %>
<%@ page  import="java.text.*" %>

    <%
	String contextPath = request.getContextPath();
    String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo == null || "".equals(projectInfoNo) || projectInfoNo == "null" || "null".equals(projectInfoNo)) {
		UserToken user = OMSMVCUtil.getUserToken(request);
		projectInfoNo = user.getProjectInfoNo();
	}

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String produce_date = sdf.format(new Date());
		
    %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script src="<%=contextPath%>/js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<title>项目进度图</title>

</head>
<body>
<div id="new_table_box">
		<div id="new_table_box_content">
			<div id="new_table_box_bg">
				<div id="tag-container_3">
				  <ul id="tags" class="tags">
				 <!-- 
				    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
				   --> 
				  </ul>
				</div>
				
				<div id="tab_box_content7" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
					  	<td class="inquire_form8">
					  	 <input type="hidden" name="daily_no" id="daily_no" /> 
		                <input type="text" name="produceDate" id='produceDate' value='<%=produce_date%>' readonly="readonly" onchange="onchangeDate()"/>&nbsp;&nbsp; 
		                <img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;"
						onmouseover="calDateSelector(produceDate,tributton1);" />&nbsp;&nbsp;
					  	</td>
		                </tr>
		              </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					  	<td>
					  		<div id="imageDiv" style="width: 600px;height: 600px"></div>
					  	</td>
						</tr>
					</table>
				</div>

			</div>
		</div>
</div>
</body>
<script type="text/javascript">
var retObj = jcdpCallService("ChartSrv", "getProjectMethod", "projectInfoNo=<%=projectInfoNo%>");
var strHtml="";
for(var i=0;i<retObj.resultList.length;i++){
	strHtml+='<li id="m'+retObj.resultList[i].methodCode+'"><a href="#" onclick="onloadPicture(\''+retObj.resultList[i].methodCode+'\')">'+retObj.resultList[i].methodName+'</a></li>';		
}
$("#tags").append(strHtml);

function onloadPicture(exMethodCode){
    $('#tags li').each(function(){
        var mid = $(this).attr('id');
      	$("#"+mid).removeClass("selectTag");
        
    });
	$("#m"+exMethodCode).addClass("selectTag");
    
	var date = $("#produceDate").val();
	var imageObj = jcdpCallService("ChartSrv", "getExeMthodPicture", "projectInfoNo=<%=projectInfoNo%>&produceDate="+date+"&exMethod="+exMethodCode);
	if(imageObj.isUcmId=="yes"){	
		$("#imageDiv").html('<img ondblclick="downloadImg(\''+imageObj.ucmId+'\')" src="'+imageObj.imagePath+'"  alt="双击下载" height="420" width="560"/>');
 //<input onclick="window.location ='/doc/downloadDocByUcmId.srq?docId=98787';" );

	}else{
		$("#imageDiv").html('无图');
	}
}
function downloadImg(ucmid){
	 window.location ="<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucmid;
}
function onchangeDate(){
	var idm = $(".selectTag").attr("id");
	idm=idm.substring(1,idm.length);
	onloadPicture(idm);
}
</script>
</html>