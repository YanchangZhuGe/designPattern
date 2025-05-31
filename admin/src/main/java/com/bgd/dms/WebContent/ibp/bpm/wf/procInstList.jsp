<%@ page contentType="text/html;charset=GBK"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="com.cnpc.sais.bpm.util.WFUtils"%>
<%

String contextPath = request.getContextPath();
WFUtils utils=new WFUtils();

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
List list =null;
	if(request.getAttribute("procInstList")!=null){
		 list =(List)request.getAttribute("procInstList");
	
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
				<th>申请标题</th>
				<th>用车时间</th>
				<th>发车起始地址</th>
				<th>联系电话</th>
				<th>操作</th>
			</tr>
			
			<%
			if(list !=null)
			{
			    for(int i=0;i<list.size();i++)
			    {
			    Map map=(Map)utils.toMap(list.get(i));
            %>
        	<tr>
				<td><%=map.get("proc_car_title") %></td>
				<td><%=map.get("proc_date") %></td>
				<td><%=map.get("proc_start_address") %> --><%=map.get("proc_end_address") %></td>
				<td><%=map.get("proc_officePhone") %></td>
				<td><a href="<%=contextPath%>/wf/test/getExamineInfo.srq?examineinstID=<%=map.get("entityId")%>&procinstID=<%=map.get("procinstId")%>">审批</a>   <a href="<%=contextPath%>/wf/coginUsers.jsp?examineinstID=<%=map.get("entityId")%>" target="_blank">委托</a></td>
			</tr>	
        
        
		  <%
           }
       }
     %>																			
		</table>




</body>
</html>
