<%@ page contentType="text/html;charset=GBK"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%
String contextPath = request.getContextPath();
%>
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
List examineinList =null;
	if(request.getAttribute("examineinList")!=null){
		 examineinList =(List)request.getAttribute("examineinList");
	
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
    <td align="left" class="big_title" width="98%">待审批信息</td>
  </tr>
</table>

	
		<table cellspacing="0" cellpadding="0">
		
			<tr>
				<th>流程模板名称</th>
				<th>标题</th>
				<th>流程发起时间</th>
				<th>流程审批人</th>
				<th>操作</th>
			</tr>
			
			<%
			if(examineinList !=null)
			{
			    for(int i=0;i<examineinList.size();i++)
			    {
			    Map map=(Map)examineinList.get(i);
            %>
        	<tr>
				<td><%=map.get("proc_name") %></td>
				<td><%=map.get("proc_title") %></td>
				<td><%=map.get("examineStartDate") %></td>
				<td><%=map.get("examineUserName") %></td>
				<td><a href="<%=contextPath%>/wf/getExamineInfo.srq?examineinstID=<%=map.get("entityId")%>&procinstID=<%=map.get("procinstId")%>">审批</a>   <a href="<%=contextPath%>/wf/coginUsers.jsp?examineinstID=<%=map.get("entityId")%>" target="_blank">委托</a></td>
			</tr>	
        
        
		  <%
           }
       }
     %>																			
		</table>




</body>
</html>
