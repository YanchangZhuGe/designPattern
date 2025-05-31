<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil,com.cnpc.jcdp.soa.msg.MsgElement,java.util.List"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	UserToken user=OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
	String isCache= user.getIsCache();
	String isDashbord=user.getIsDashbord();
	String userProfileId=user.getUserProfileId();
%>	
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css">
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" /><head>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
<script type="text/javascript">
	function toSubmit(){
		var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
		
		var isCache=$("#isCache").val();
		var isDashbord=$("#isDashbord").val();
		var userProfileId=$("#userProfileId").val();
		
		var submitStr = 'JCDP_TABLE_NAME=P_AUTH_USER_PROFILE_DMS&JCDP_TABLE_ID=&user_id=<%=userId%>&user_profile_id='+userProfileId+'&modifi_date=sysdate&is_cache='+isCache+'&is_dashbord='+isDashbord+'&bsflag=0';
		var retObject = syncRequest('Post',path,submitStr);
		if (retObject.returnCode != "0"){
		 	alert("提交失败！");
		}else{
			alert("提交成功！");
		} 
	}
	
	function init(){
		$("#isCache").val("<%=isCache%>");
		$("#isDashbord").val("<%=isDashbord%>");
		$("#userProfileId").val("<%=userProfileId%>");
	}
</script>
</head>
<body onload="init()">
		<form id="form1" name="form1" method="post" action="login.srq">
		
		<table id="rtCRUTable" border="0" cellpadding="0" cellspacing="0" class="tab_line_height">
			<tr>
				<td  class="inquire_item6">是否开启本地缓存
				</td>
				<td class="inquire_form6">
					<select id="isCache" class="select_width">
						<option value="0">否</option>
						<option value="1">是</option>
					</select>
				</td>
				<td  class="inquire_item6">是否加载仪表盘
				</td>
				<td class="inquire_form6" >
					<select id="isDashbord" class="select_width">
						<option value="0">否</option>
						<option value="1">是</option>
					</select>
				</td>
			</tr>
			<tr class="ali4" >
			<td colspan="4" align="right">
				   <input type="button" onclick="toSubmit()" class="iButton" value="提交"/>
			</td>
			</tr>
			<tr>
				<td width="100%" align="left" colspan="4" style="padding-left:50px;">
					说明：<br>
					1、若开启本地缓存，请保证IE浏览器版本为IE8.0+。<br>
					2、若选择不加载仪表盘，则个人仪表盘以及模块仪表盘将显示空白页，若想查看仪表盘，请重新至此处开启加载仪表盘。<br>
				</td>
			</tr>
		</table>
		  <input id="userProfileId" type="hidden" value="<%=userProfileId%>"/>
		</form>
</body>