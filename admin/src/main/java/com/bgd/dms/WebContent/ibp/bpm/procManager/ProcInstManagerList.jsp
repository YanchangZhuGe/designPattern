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
	List procInsts=null;
		if(respMsg.getMsgElements("procInsts")!=null){
		 procInsts =ActionUtils.listWithMap(respMsg.getMsgElements("procInsts"));

	}
%>

<html>
<head>
 <script type="text/javascript" src="<%=contextPath%>/ibp/bpm/js/jquery.min.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/ibp/bpm/js/jquery.treetable.js"></script>
<link href="<%=contextPath%>/ibp/bpm/css/styles.css" rel="stylesheet" type="text/css" media="screen" />

<title>流程实例管理</title>

</head>


 <BODY>
 <div style="float:left;margin:0 0 0 10px;">
  <table  cellspacing="0" cellpadding="0" >
	<caption>流程实例管理  <a href="<%=contextPath%>/wf/queryProcDefineList.srq">返回</a> </caption>
	<tr><th>流程名称</th><th>流程版本号</th><th >创建时间</th><th>创建用户</th><th>操作</th></tr>
	<tbody id="tb" >
       <%
			if(procInsts !=null)
			{
			    for(int i=0;i<procInsts.size();i++)
			    {
			    Map map=(Map)procInsts.get(i);
            %>
        	<tr>
				<td><%=map.get("procName") %></td>
				<td><%=map.get("procVersion") %></td>
				<td><%=map.get("createDate") %></td>
				<td><%=map.get("createUserName") %></td>
				<%if(map.get("state").toString().equals("1")){%>
				<td><a href="<%=contextPath%>/wf/stopProcInstById.srq?procInstId=<%=map.get("entityId") %>">挂起</a></td>
				<%}else{%>
				<td></td>
				<%}%>
			</tr>


		  <%
           }
       }else{
       %>
       <tr >


				<td colspan="5"><span align="center">无任何记录！</span></td>
			</tr>


       <%
       }
       %>

	</tbody>
  </table>
  </div>

 </BODY>
</HTML>
