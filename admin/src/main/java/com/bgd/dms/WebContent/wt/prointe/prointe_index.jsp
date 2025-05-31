<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String projectInfoNo = user.getProjectInfoNo();
    String orgSubId = "C105";
	String orgId = "C6000000000001";
	if(user != null){
		orgSubId = user.getSubOrgIDofAffordOrg();
		orgId = user.getCodeAffordOrgID();
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>  
<title>无标题文档</title>
</head>
<body style="background: #fff; overflow-y: auto" onload="getFusionChart()">
 <div id="new_table_box" align="center">
  <div id="new_table_box_content"  > 
   <div id="new_table_box_bg">
<table   width="80%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
<tr>
		<td align="center" colspan="4"  class="inquire_form"> 
		<input type="radio" name="method1" id="method1" value="0110000048000000001" onclick="queryMethod()"/> 重力
		<input type="radio" name="method1" id="method1" value="0110000048000000002" onclick="queryMethod()"/> 磁力
		<input type="radio" name="method1" id="method1" value="0110000048000000003" onclick="queryMethod()"/> 电法
		<input type="radio" name="method1" id="method1" value="0110000048000000004" onclick="queryMethod()"/> 遥感
		<input type="radio" name="method1" id="method1" value="0110000048000000005" onclick="queryMethod()"/> 化探
		<input type="radio" name="method1" id="method1" value="0110000048000000006" onclick="queryMethod()"/> 其他
		</td> 
	</tr>
	<tr>
		<td align="center"   style="width: 20%" >
		 项目启动
		</td>
		<td align="center"   style="width: 20%"  >
		 项目计划
		</td>
		<td  align="center"   style="width: 20%"  >
		 项目运行
		</td>
		<td align="center"   style="width: 20%" >
		 项目收尾
		</td>
		
	</tr> 
		<tr>
		 
		<td align="center"    style="width: 20%" >
		  <input type="button" name="button1" id="button2" value="项目信息" /> 
		  <br>
		  <input type="radio" name="button1" id="button1" value=""/> <input type="button" name="button1" id="button2" value="处理解释任务书" />
		</td>
		<td align="center"    style="width: 20%" >
		 <input type="button" name="button1" id="button2" value="项目信息" /> 
		  <br>
		  <input type="radio" name="button1" id="button1" value=""/> <input type="button" name="button1" id="button2" value="处理解释任务书" />
		    <br>
		  <input type="radio" name="button1" id="button1" value=""/> <input type="button" name="button1" id="button2" value="处理解释任务书" />
		
		  <br>
		  <input type="radio" name="button1" id="button1" value=""/> <input type="button" name="button1" id="button2" value="处理解释任务书" />
		
		  <br>
		  <input type="radio" name="button1" id="button1" value=""/> <input type="button" name="button1" id="button2" value="处理解释任务书" />
		
		</td>
		<td  align="center"   style="width: 20%"  >
		 项目运行
		</td>
		<td align="center"   style="width: 20%" >
		 项目收尾
		</td>
		
	</tr>
</table>
      </div>
    </div>
   </div>
</body>
<script type="text/javascript">
 function queryMethod(){
	var retObj = jcdpCallService("WorkAreaSrv", "getSurfaceType", "");
 }
</script>
</html>

