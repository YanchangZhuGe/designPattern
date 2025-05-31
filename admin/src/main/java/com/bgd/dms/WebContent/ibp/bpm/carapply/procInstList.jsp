<%@ page contentType="text/html;charset=GBK"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="com.cnpc.jcdp.webapp.util.ActionUtils"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.webapp.constant.MVCConstant"%>

<html>
<head>
<style>

body{
	margin:0;
	padding:0;
	background:#f1f1f1;
	font:70% Arial, Helvetica, sans-serif; 
	color:#555;
	line-height:150%;
	text-align:left;
}
a{
	text-decoration:none;
	color:#057fac;
}
a:hover{
	text-decoration:none;
	color:#999;
}
h1{
	font-size:140%;
	margin:0 20px;
	line-height:80px;	
}
h2{
	font-size:120%;
}
#container{
	margin:0 auto;
	width:680px;
	background:#fff;
	padding-bottom:20px;
}
#content{margin:0 20px;}
p.sig{	
	margin:0 auto;
	width:680px;
	padding:1em 0;
}
form{
	margin:1em 0;
	padding:.2em 20px;
	background:#eee;
}
</style>

<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
List list =null;
	if(respMsg.getMsgElements("procInstList")!=null){
		 list =ActionUtils.listWithMap(respMsg.getMsgElements("procInstList"));
	
	}	
%>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
<title>Auth Role</title>	
<link href="<%=contextPath%>/wf/tablecloth.css" rel="stylesheet" type="text/css" media="screen" />


</head>
<body>
<table  border="0" cellpadding="0" cellspacing="0" class="Tab_page_title">
  <tr class="Tab_page_title">
    <td align="left" height="24"  width=2% class="nav-back"><img src="<%=contextPath%>/images/btn4.jpg" width="14" height="24" style="margin-left:10px;"/></td>
    <td align="left" class="big_title" width="98%">已发申请列表</td>
  </tr>
</table>

	
		<table cellspacing="0" cellpadding="0">
		
			<tr>
				<th>模板名称</th>
				<th>发起时间</th>
				<th>状态</th>
				<th>流程运行情况</th>
			</tr>
			
			<%
			if(list !=null)
			{
			    for(int i=0;i<list.size();i++)
			    {
			    Map map=(Map)list.get(i);
            %>
        	<tr>
				<td><%=map.get("procName") %></td>
				<td><%=map.get("createDate") %></td>
				<td>
				<%
				   String state=(String)map.get("state");
				   String stateShow="";
				   if(state.equals("1"))
				   {
				    stateShow="审批中";
				   }else if(state.equals("3"))
				   {
				    stateShow="审批通过";
				   }else if(state.equals("4"))
				   {
				    stateShow="审批未通过";
				   }
				   
				   
				  
				 %>
				<%=stateShow %>
				</td>
			
        
        
		  
     <td><a target="_blank" href="<%=contextPath%>/wf/getProcInstView.srq?procinstID=<%=map.get("entityId") %>">查看</a></td>		
     <%
           }
       }
     %>		
     </tr>																
		</table>




</body>
</html>
