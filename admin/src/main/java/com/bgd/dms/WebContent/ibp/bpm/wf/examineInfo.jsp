<%@ page contentType="text/html;charset=GBK"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
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
List examineinList =null;
List nodeList=null;
String isFirstApplyNode="";
boolean isFirst=true;
     if(request.getAttribute("isFirstApplyNode")!=null){
		 isFirstApplyNode =(String)request.getAttribute("isFirstApplyNode");
		 if(isFirstApplyNode.equals("false"))
		 {
		  isFirst=false;
		 }
	}	
	if(request.getAttribute("examineinList")!=null){
		 examineinList =(List)request.getAttribute("examineinList");
	
	}	
	if(request.getAttribute("nodeList")!=null){
		 nodeList =(List)request.getAttribute("nodeList");
	
	}	
%>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
<title>Auth Role</title>	
<link href="<%=contextPath%>/wf/tablecloth.css" rel="stylesheet" type="text/css" media="screen" />
<script>
function pass()
{
   document.getElementById("examineForm").submit();
  return   false;
}
function nopass()
{
  document.getElementById("isPass").value="nopass";
   document.getElementById("examineForm").submit();
  return   false
 
}
function backprocess()
{
  document.getElementById("examineForm").action='<%=contextPath%>/wf/backProcInst.srq';
document.getElementById("examineForm").submit();

}
</script>

</head>
<body>
<table  border="0" cellpadding="0" cellspacing="0" class="Tab_page_title">
  <tr class="Tab_page_title">
    <td align="left" height="24"  width=2% class="nav-back"><img src="<%=contextPath%>/images/btn4.jpg" width="14" height="24" style="margin-left:10px;"/></td>
    <td align="left" class="big_title" width="98%">审批</td>
  </tr>
</table>
<div id="container">
	<h1>申请信息：</h1>
	
	<div id="content">
<form name="examineForm" id="examineForm" action="<%=contextPath%>/wf/examineNode.srq" >
<table cellspacing="0" cellpadding="0">
 <%
    if(examineinList!=null)
    {
     Map map=(Map)examineinList.get(0);
     out.print(map.get("reason"));
 %>
			<tr>
				<th>流程模板名称</th>
				<td><%=map.get("proc_name") %></td>
				
			</tr>
			<tr>
				<th>审批标题</th>
				<td><%=map.get("proc_title") %></td>
	
			</tr>			
			<tr>
				<th>流程发起时间</th>
				<td><%=map.get("examineStartDate") %></td>
			
			</tr>			
			<tr>
				<th>流程审批人</th>
				<td><%=map.get("examineUserName") %></td>
				
			</tr>
			
			<tr>
				<th>下级审批</th>
				<td>
			
				<select name="nextNodeID">
				<%
				if(nodeList!=null)
				{
				  for(int j=0;j<nodeList.size();j++)
				  {
				  Map node=utils.toMap(nodeList.get(j));
				 %>
				   <option value="<%=node.get("entityId") %>"><%=node.get("nodeName") %></option>
				<%
				   }
				}else
				{
				 %>
				  <option value="999">无下级节点</option>
				 
				 <%
				 }
				  %>
				</select>
				
				</td>
				
			</tr>
			
			<%
			if(map.get("reason")!=null)
			{
			 %>
	
		  <tr>
			<th>重审意见</th>
				<td>
				<textarea name="reexamineInfo"><%=map.get("reason") %></textarea>
				</td>
				
			</tr>
			<%} %>
			
			<tr>
			<th>审批意见</th>
				<td>
				<textarea name="examineInfo"></textarea>
				</td>
				
			</tr>			
			<tr>
				<th>操作</th>
				<td><a href="<%=contextPath%>/wf/showproc/test.html" target="_blank"> 查看审批过程</a> 
				    <a href="#" onclick="pass()">通过</a>   <a href="#" onclick="nopass()">不通过</a>  
				    <%if(!isFirst) {%><a href="#" onclick="backprocess()">重审</a><%} %></td>
			</tr>	
			 <input type="hidden" id="procinstID" name="procinstID" value="<%=map.get("procinstId")%>">
			 <input type="hidden" id="examineinstID" name="examineinstID" value="<%=map.get("entityId")%>">
			<%
			}
			 %>																																				
		</table>
  
   <input type="hidden" id="isPass" name="isPass" value="pass">
</form>
</body>
</html>
