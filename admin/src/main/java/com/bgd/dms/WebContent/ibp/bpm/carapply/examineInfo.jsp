<%@ page contentType="text/html;charset=GBK"%>
<%@ page import="java.util.List"%>
<%@ page import="com.cnpc.jcdp.webapp.util.ActionUtils"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.webapp.constant.MVCConstant"%>
<%@ page import="java.util.Map"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	
%>

<html>
<head>
<title>新增页面</title>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css"  />

<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script> 
<link rel="stylesheet" href="<%=contextPath%>/css/common.css" type="text/css" />
<link rel="stylesheet" href="<%=contextPath%>/css/main.css" type="text/css" />
<link rel="stylesheet" href="<%=contextPath%>/css/rt_cru.css" type="text/css" />


<%
Map map =null;
Map wf_Test_Map = null;
List nodeList=null;
String isFirstApplyNode="";
boolean isFirst=true;
boolean isCanPass=false;
     if(respMsg.getValue("isFirstApplyNode")!=null){
		 isFirstApplyNode =respMsg.getValue("isFirstApplyNode");
		 if(isFirstApplyNode.equals("false"))
		 {
		  isFirst=false;
		 }
	}	

	if(respMsg.getMsgElements("examineinInfo")!=null){
		List list=ActionUtils.listWithMap(respMsg.getMsgElements("examineinInfo"));
		map=(Map)list.get(0);
		
		
	}	
		
    if(respMsg.getMsgElement("wfTest")!=null){
		 wf_Test_Map= respMsg.getMsgElement("wfTest").toMap();
		
	}
	if(respMsg.getMsgElements("nodeList")!=null){
		 nodeList =ActionUtils.listWithMap(respMsg.getMsgElements("nodeList"));
	
	}	
	 if(respMsg.getValue("isCanPass")!=null){
		 String pass=respMsg.getValue("isCanPass");
		 if(pass.equals("true"))
		 {
		  isCanPass=true;
		 }
	}	
%>

<script>
function pass()
{
   document.getElementById("examineForm").submit();
  return   false;
}
function passend()
{
  document.getElementById("isPass").value="passend";
   document.getElementById("examineForm").submit();
  return   false
}
function nopass()
{
  document.getElementById("isPass").value="nopass";
   document.getElementById("examineForm").submit();
  return   false
 
}
function nopassend()
{
  document.getElementById("isPass").value="nopassend";
   document.getElementById("examineForm").submit();
  return   false
}
function backprocess()
{
  document.getElementById("examineForm").action='<%=contextPath%>/wf/test/backProcInst.srq';
document.getElementById("examineForm").submit();

}
</script>

</head>
<body>
<div id="hintTitle">
<span id="cruTitle">车辆申请</span>	
</div>
<div>
<span id="cruTitle">审批测试页面</span>	
</div>

<div id="addDiv">	
<form name="examineForm" id="examineForm" action="<%=contextPath%>/wf/test/examineNode.srq" >
 <table id="rtCRUTable" cellSpacing=0 cellPadding=1 width="100%" align=center border=0>
 <%
    if(wf_Test_Map!=null)
    {
    
 %>
			<tr>
			    <td class="rtCRUFdName">&nbsp;申请标题：</td>
				<td class="rtCRUFdValue"><%=wf_Test_Map.get("title") %></td>
				
			</tr>
			<tr>
				 <td class="rtCRUFdName">&nbsp;用车时间：</td>
				 <td class="rtCRUFdValue"><%=wf_Test_Map.get("usedate") %></td>
	
			</tr>			
			<tr>
				<td class="rtCRUFdName">&nbsp;发车起始地址：</td>
				<td class="rtCRUFdValue"><%=wf_Test_Map.get("from_address") %> --><%=wf_Test_Map.get("to_address") %></td>
			
			</tr>			
			<tr>
				<td class="rtCRUFdName">&nbsp;下级审批：</td>
				<td class="rtCRUFdValue">
			
				<select name="nextNodeID">
				<%
				if(nodeList!=null)
				{
				  for(int j=0;j<nodeList.size();j++)
				  {
				  Map node=(Map)nodeList.get(j);
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
			<td class="rtCRUFdName">&nbsp;重审意见：</td>
				<td class="rtCRUFdValue">
				<textarea name="reexamineInfo"><%=map.get("reason") %></textarea>
				</td>
				
			</tr>
			<%} %>
			
			<tr>
			<td class="rtCRUFdName">&nbsp;审批意见：</td>
				<td class="rtCRUFdValue">
				<textarea name="examineInfo"></textarea>
				</td>
				
			</tr>			
			<tr>
				<td class="rtCRUFdName">操作：</td>
				<td class="rtCRUFdValue"><a href="<%=contextPath%>/wf/showproc/test.html" target="_blank"> 查看审批过程</a> 
				    <a href="#" onclick="pass()">通过</a>   <a href="#" onclick="nopass()">不通过</a>  
				    <%if(!isFirst) {%><a href="#" onclick="backprocess()">重审</a><%} %>
				    <%if(isCanPass){%>
				    <a href="#" onclick="passend()">直接通过</a><a href="#" onclick="nopassend()">直接不通过</a>
				    <%}%>
				    </td> 
			</tr>	
			 <input type="hidden" id="procinstID" name="procinstID" value="<%=map.get("procinstId")%>">
			 <input type="hidden" id="examineinstID" name="examineinstID" value="<%=map.get("examineinstId")%>">
			<%
			}
			 %>																																				
		</table>
  
   <input type="hidden" id="isPass" name="isPass" value="pass">
</form>
</body>
</html>
