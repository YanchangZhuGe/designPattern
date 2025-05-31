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
	List examineinList =null;
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	
	if(respMsg.getMsgElements("examineInstList")!=null){
		 examineinList =ActionUtils.listWithMap(respMsg.getMsgElements("examineInstList"));
	
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
<link href="<%=contextPath%>/ibp/bpm/wf/tablecloth.css" rel="stylesheet" type="text/css" media="screen" />
<title>审批信息页面</title>

</head>

<body>

 
 <table  border="0" cellpadding="0" cellspacing="0" >
  <tr class="Tab_page_title">
    <td align="left" height="24"  width=2% class="nav-back"><img src="<%=contextPath%>/images/btn4.jpg" width="14" height="24" style="margin-left:10px;"/></td>
    <td align="left" class="big_title" width="98%">审批信息</td>
  </tr>
</table>

	
		<table cellspacing="0" cellpadding="0">
		
			<tr>
				<th>审批人</th>
				<th>审批周期</th>
				<th>审批意见</th>
			
			</tr>
			
			<%
			if(examineinList !=null)
			{
			    for(int i=0;i<examineinList.size();i++)
			    {
			    Map map=(Map)examineinList.get(i);
            %>
        	<tr>
				<td><%=map.get("examineUserId") %></td>
				<td><%=map.get("examineStartDate") %> --> <%=map.get("examineEndDate") %></td>
				<td><%=map.get("examineInfo") %></td>
			</tr>	
        
        
		  <%
           }
       }
     %>																			
		</table>


</body>
</html>