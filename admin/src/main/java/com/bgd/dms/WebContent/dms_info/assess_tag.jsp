<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_id = user.getOrgSubjectionId();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<%@include file="/common/include/quotesresource.jsp"%>
<title>管理员首页监控页面</title>
</head>
<body style="background:#fff" >
      	<div id="list_table2">
      		<div id="tag-container2_3" style="width: 80%">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a style="width: 105px;" href="####" onclick="getTab3(0)">管理要素</a></li>
			    <li id="tag3_1"><a style="width: 105px;" href="####" onclick="getTab3(1)">装备管理要素</a></li>
			    <!-- <li id="tag3_1"><a style="width: 105px;" href="####" onclick="getTab3(1)">项目监控</a></li>
			    <li id="tag3_1"><a style="width: 105px;" href="####" onclick="getTab3(1)">所属单位</a></li>
			    <li id="tag3_2"><a style="width: 105px;" href="####" onclick="getTab3(2)">固定场所</a></li> -->
			  </ul>
			</div>
		</div>
</body>

<script type="text/javascript">
	
	var selectedTagIndex = 0;
	getTab3(0);
	function getTab3(index) {  
		var selectedTag = document.getElementById("tag3_"+selectedTagIndex);
		var assesstype = "";
		selectedTag.className ="";
		selectedTagIndex = index;		
		selectedTag = document.getElementById("tag3_"+selectedTagIndex);
		selectedTag.className ="selectTag";
		if(index==0){//物探队
			parent.assessFrame.location.href = "<%=contextPath%>/dms_info/indicatorMonitor.jsp";
			//assesstype = "5110000198000000002";
			//parent.assessFrame.location.href = "<%=contextPath%>/dms_info/indicatorMonitor.jsp?assesstype="+assesstype;
		}else if(index==1){//所属单位
			parent.assessFrame.location.href = "<%=contextPath%>/dms_info/indicatorZBMonitor.jsp";
			//assesstype = "5110000198000000003";
			//parent.assessFrame.location.href = "<%=contextPath%>/dms_info/assessScoreMonitor.jsp?assesstype="+assesstype;
		}else if(index==2){//固定场所
			//assesstype = "5110000198000000001";
		}
		//parent.assessFrame.location.href = "<%=contextPath%>/dms_info/indicatorMonitor.jsp";
		//parent.assessFrame.location.href = "<%=contextPath%>/dms_info/assessIndexScore.jsp?assesstype="+assesstype;
		//parent.assessFrame.location.href = "<%=contextPath%>/dms_info/assessScoreMonitor.jsp?assesstype="+assesstype;
		//parent.assessFrame.location.href = "<%=contextPath%>/dms_info/indicatorMonitor.jsp?assesstype="+assesstype;
	}
	
	
</script>

</html>

