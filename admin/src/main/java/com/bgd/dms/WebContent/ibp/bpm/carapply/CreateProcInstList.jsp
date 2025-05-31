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
		if(respMsg.getMsgElements("procInstList")!=null){
		 procInsts =ActionUtils.listWithMap(respMsg.getMsgElements("procInstList"));
	
	}	
%>

<html>
<head>
 <script type="text/javascript" src="<%=contextPath%>/ibp/bpm/js/jquery.min.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/ibp/bpm/js/jquery.treetable.js"></script>
<link href="<%=contextPath%>/ibp/bpm/css/styles.css" rel="stylesheet" type="text/css" media="screen" />

<title>流程管理</title>

</head>


 <BODY>
 <div style="float:left;margin:0 0 0 10px;">
  <table  cellspacing="0" cellpadding="0" >
	<caption>发起车辆申请  </caption>
	<tr><th>模板名称</th><th>发起时间</th><th >状态</th><th>流程运行情况</th></tr>
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
				<td><%=map.get("createDate") %></td>
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
				<td><%=stateShow %></td>
				<td><a target="_blank" href="<%=contextPath%>/wf/getProcInstView.srq?procinstID=<%=map.get("entityId") %>">查看</a></td>
			
			</tr>	
        
        
		  <%
           }
       }else{
       %>
       <tr >
				
	
				<td colspan="4"><span align="center">无任何记录！</span></td>
			</tr>
       
       
       <%
       }
       %>							
	
	</tbody>
  </table>
  </div>
 
 </BODY>
</HTML>
