<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	
%>

<html>
<head>
<title>新增页面</title>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css"  />

<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script> 
<link rel="stylesheet" href="<%=contextPath%>/css/common.css" type="text/css" />
<link rel="stylesheet" href="<%=contextPath%>/css/main.css" type="text/css" />
<link rel="stylesheet" href="<%=contextPath%>/css/rt_cru.css" type="text/css" />

<body bgcolor="#EFF4F9">

<form name="insertOrgForm" method="post">
  <div id="checkFieldDiv" style="display:none;">
    <table width="100%"  border="0" cellpadding="0" class="error_td">
      <tr>
          <td height=20 align=left><div id="msgDiv"><div></td>
      </tr>
    </table>
  </div>
 <table id="rtCRUTable" cellSpacing=0 cellPadding=1 width="100%" align=center border=0>

   <tr>
      <td class="rtCRUFdName"><font color="red">*</font>&nbsp;缓存中加载流程模板：</td>
      <td class="rtCRUFdValue">
      	<input type="button" class="button save" onclick="javascript:location.href='${pageContext.request.contextPath }/wf/loadproc.srq'"  value="测试">
      </td>
    </tr>
    <tr>
      <td class="rtCRUFdName"><font color="red">*</font>&nbsp;发起用车申请链接：</td>
      <td class="rtCRUFdValue">
      	<input type="button" class="button save" onclick="javascript:location.href='${pageContext.request.contextPath }/ibp/bpm/carapply/carapply.jsp'" value="测试">
      </td>
    </tr>
    <tr>
      <td class="rtCRUFdName"><font color="red">*</font>&nbsp;查看待审批申请链接：</td>
      <td class="rtCRUFdValue">
      	<input type="button" class="button save" onclick="javascript:location.href='${pageContext.request.contextPath }/wf/test/getExamineList.srq'"  value="测试">
      </td>
    </tr>
    <tr>
      <td class="rtCRUFdName"><font color="red">*</font>&nbsp;查看已发申请链接：</td>
      <td class="rtCRUFdValue">
      	<input type="button" class="button save" onclick="javascript:location.href='${pageContext.request.contextPath }/wf/test/getStartProcInsts.srq'"  value="测试">
      </td>
    </tr>
      <tr>
      <td class="rtCRUFdName"><font color="red">*</font>&nbsp;流程管理：</td>
      <td class="rtCRUFdValue">
      	<input type="button" class="button save" onclick="javascript:location.href='${pageContext.request.contextPath }/wf/queryProcDefineList.srq'"  value="测试">
      </td>
    </tr>
  
</table>
</form>
</body>
</html>
