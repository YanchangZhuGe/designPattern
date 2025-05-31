<%@ page contentType="text/html;charset=GBK"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.cnpc.jcdp.webapp.util.ActionUtils"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String tableHtml="";
	  if(respMsg.getValue("procsHtml")!=null){
		 tableHtml =respMsg.getValue("procsHtml");
	}	
%>

<html>
<head>
 <script type="text/javascript" src="<%=contextPath%>/ibp/bpm/js/jquery.min.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/ibp/bpm/js/jquery.treetable.js"></script>
<link href="<%=contextPath%>/ibp/bpm/css/styles.css" rel="stylesheet" type="text/css" media="screen" />
<script LANGUAGE="JavaScript" >
  
	$(document).ready(function(){
	
		$.treetable.defaults={
			id_col:0,//ID td列 {从0开始}
			parent_col:1,//父ID td列
			handle_col:2,//加上操作展开操作的 td列
			open_img:"<%=contextPath%>/ibp/bpm/images/minus.gif",
			close_img:"<%=contextPath%>/ibp/bpm/images/plus.gif"
		}
		
		//$("#tb").treetable({id_col:0,parent_col:1,handle_col:2,open_img:"images/minus.gif",close_img:"images/plus.gif"});
		
		//只能应用于tbody
		$("#tb").treetable();
		
		//应用样式
		$("#tb tr:even td").addClass("alt");
		$("#tb tr").find("td:eq(2)").addClass("spec");
		$("#tb tr:even").find("td:eq(2)").removeClass().addClass("specalt");
		
		//隐藏数据列
		$("#tb tr").find("td:eq(0)").hide();
		$("#tb tr").find("td:eq(1)").hide();
		$("#mytable tr:eq(0)").find("th:eq(0)").hide();
		$("#mytable tr:eq(0)").find("th:eq(1)").hide();
	});
	
  </script>
<title>流程管理</title>

</head>


 <BODY>
 <div style="float:left;margin:0 0 0 10px;">
  <table id="mytable" cellspacing="0" cellpadding="0" >
	<caption>流程管理</caption>
	<tr><th>区域编号</th><th>上级区域</th><th >流程模板名称</th><th>版本号</th><th>创建用户</th><th>状态</th><th>运行实例数</th><th>挂起实例数</th><th>完成实例数</th><th>修改</th></tr>
	<tbody id="tb" >
<%=tableHtml%>
	
	</tbody>
  </table>
  </div>
 
 </BODY>
</HTML>
