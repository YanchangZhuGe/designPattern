<%@ page contentType="text/html;charset=GBK"%>
<%@ page import="java.util.Map"%>
<%
String contextPath=request.getContextPath();
String nodeId="";
  if(request.getParameter("nodeId")!=null)
  {
    nodeId=request.getParameter("nodeId");
  }
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

<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
<title>Auth Role</title>	
<link href="<%=contextPath%>/wf/tablecloth.css" rel="stylesheet" type="text/css" media="screen" />
<script>
	function select()
	{
	    var checkObj= document.getElementsByName("user");
		var len = checkObj.length; 
		var users="";
	    var checked = false; 
	
	    for (i = 0; i < len; i++) 
	    { 
	        if (checkObj[i].checked == true) 
	        { 
	            checked = true; 
	            users=users+checkObj[i].value+",";
	        } 
	    } 
	    if (!checked) 
	    { 
	        alert("请至少选择一个用户！"); 
	        return; 
	    }
        if(users.length>0)
        {
          users=users.substring(0,users.length-1);
        }
      
        window.parent.opener.getValue('',users,'<%=nodeId%>');
       window.opener=null   
  window.close()  
   }




</script>

</head>
<body>
<table  border="0" cellpadding="0" cellspacing="0" class="Tab_page_title">
  <tr class="Tab_page_title">
    <td align="left" height="24"  width=2% class="nav-back"><img src="<%=contextPath%>/images/btn4.jpg" width="14" height="24" style="margin-left:10px;"/></td>
    <td align="left" class="big_title" width="98%">审批用户信息</td>
  </tr>
</table>
<div id="container">
	<h1>审批用户信息：</h1>
	
	<div id="content">
	
		<table cellspacing="0" cellpadding="0">
		
			<tr>
				<th>选择</th>
				<th>用户</th>
			</tr>
	        <tr>
				<td><input type=checkbox name="user" value="U001"></td>
				<td>U001</td>
			</tr>	
			 <tr>
				<td><input type=checkbox name="user" value="U002"></td>
				<td>U002</td>
			</tr>
			 <tr>
				<td><input type=checkbox name="user" value="U003"></td>
				<td>U003</td>
			</tr>
			 <tr>
				<td><input type=checkbox name="user" value="U004"></td>
				<td>U004</td>
			</tr>	
			 <tr>
				<td  colspan=2><a href="#" onclick="select()">确定</a></td>
				
			</tr>													
		</table>




</body>
</html>
