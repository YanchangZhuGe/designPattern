<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
    String userName = (user==null)?"":user.getUserName();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String today = format.format(new Date());
    
    String weekDate = resultMsg.getValue("weekDate");
    String weekEndDate = resultMsg.getValue("weekEndDate");
    String orgId = resultMsg.getValue("orgId");
    String action = resultMsg.getValue("action");
    
    List<MsgElement> list1 = resultMsg.getMsgElements("list1");
    List<MsgElement> list2 = resultMsg.getMsgElements("list2");
    List<MsgElement> list3 = resultMsg.getMsgElements("list3");
    List<MsgElement> list4 = resultMsg.getMsgElements("list4");
    List<MsgElement> list5 = resultMsg.getMsgElements("list5");
    
%> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>油公司动态</title>
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/table.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/calendar-blue.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/bgpmcs_table.css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<link href="/BGPMCS/BGP_TS_Forum/include/oc_upload.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/BGPMCS/BGP_TS_Forum/js/oc_common.js"></script>
</head>

<body>
<form name="form1" id="form1" enctype="multipart/form-data" method="post" action="<%=contextPath%>/market/week/saveWeekReport.srq">
<table border="0" cellpadding="0" cellspacing="0" class="form_info">
	 <input name="orgId" type="hidden" value="<%=orgId%>"/>
	<tr>
	  	<td class="rtCRUFdName"><font color=red>*</font>&nbsp;周报开始日期：</td>
	    <td class="rtCRUFdValue">
	    	<input type="text" name="week_date" id="week_date" value="<%=weekDate %>" class="input_width" readonly/>	    
	    </td>
	    <td class="rtCRUFdName"><font color=red>*</font>&nbsp;周报结束日期：</td>
    	<td class="rtCRUFdValue"><input type="text" id="week_end_date" class="input_width"  name="week_end_date" value="<%=weekEndDate %>" readonly>
    </tr>  
</table>  
<table border="0" cellpadding="0" cellspacing="0" id="lineTable" class="form_info" width="100%" style="margin-top:-1px;">
    <tr class="bt_info">
      <td  class="tableHeader" width="20%">类别</td>
      <td class="tableHeader" width="40%" >内容</td>
    </tr>
    <tr>
	  	<td >&nbsp;本周中标及新签价值工作量情况说明</td>
	    <td colspan="3" >
        <textarea id="typeOne" name="typeOne" style="height: 100px" max=2000 msg="本周市场落实情况不超过2000个汉字"  <%if(action.equals("view")){%>readonly<%} %>><%
        if(list1!=null){
       		 for(int i= 0;i<list1.size();i++){
				Map map1=list1.get(i).toMap();
				String orgAbbreviation = (String)map1.get("orgAbbreviation");
				String content = (String)map1.get("content");
				if(orgAbbreviation.equals("西安物探装备分公司")){
					orgAbbreviation="西安装备分公司";
				}
				if(orgAbbreviation.equals("英洛瓦（天津）物探装备有限责任公司")){
					orgAbbreviation="英洛瓦物探装备";
				}
        %>
<%=orgAbbreviation %> : <%=content %><%} }%>    
        </textarea>
	    </td>
	</tr>  
	<tr>
	  	<td>&nbsp;投标项目跟踪</td>
	    <td colspan="3" >
        <textarea id="typeTwo" name="typeTwo" style="height: 100px" max=2000 msg="本周市场落实情况不超过2000个汉字"  <%if(action.equals("view")){%>readonly<%} %>><%
        if(list2!=null){
       		 for(int i= 0;i<list2.size();i++){
				Map map2=list2.get(i).toMap();
				String orgAbbreviation = (String)map2.get("orgAbbreviation");
				String content = (String)map2.get("content");
				if(orgAbbreviation.equals("西安物探装备分公司")){
					orgAbbreviation="西安装备分公司";
				}
				if(orgAbbreviation.equals("英洛瓦（天津）物探装备有限责任公司")){
					orgAbbreviation="英洛瓦物探装备";
				}
        %>
<%=orgAbbreviation %> : <%=content %><%} }%>   
        </textarea>
	    </td>
	</tr> 
	 <tr >
	  	<td >&nbsp;市场开发动态</td>
	    <td colspan="3" >
         <textarea id="typeThree" name="typeThree" style="height: 100px" max=2000 msg="本周市场落实情况不超过2000个汉字"  <%if(action.equals("view")){%>readonly<%} %>><%
         if(list3!=null){
       		 for(int i= 0;i<list3.size();i++){
				Map map3=list3.get(i).toMap();
				String orgAbbreviation = (String)map3.get("orgAbbreviation");
				String content = (String)map3.get("content");
				if(orgAbbreviation.equals("西安物探装备分公司")){
					orgAbbreviation="西安装备分公司";
				}
				if(orgAbbreviation.equals("英洛瓦（天津）物探装备有限责任公司")){
					orgAbbreviation="英洛瓦物探装备";
				}
        %>
<%=orgAbbreviation %> : <%=content %><%} }%>    
         </textarea>
	    </td>
	</tr>  
	<tr>
	  	<td >&nbsp;油田公司动态</td>
	    <td colspan="3" >
         <textarea id="typeFour" name="typeFour" style="height: 100px" max=2000 msg="本周市场落实情况不超过2000个汉字"  <%if(action.equals("view")){%>readonly<%} %>><%
         if(list4!=null){
       		 for(int i= 0;i<list4.size();i++){
				Map map4=list4.get(i).toMap();
				String orgAbbreviation = (String)map4.get("orgAbbreviation");
				String content = (String)map4.get("content");
				if(orgAbbreviation.equals("西安物探装备分公司")){
					orgAbbreviation="西安装备分公司";
				}
				if(orgAbbreviation.equals("英洛瓦（天津）物探装备有限责任公司")){
					orgAbbreviation="英洛瓦物探装备";
				}
        %>
<%=orgAbbreviation %> : <%=content %><%} }%>   
         </textarea>
	    </td>
	</tr>  
	<tr>
	  	<td >&nbsp;物探公司动态</td>
	    <td colspan="3" >
        <textarea id="typeFive" name="typeFive" style="height: 100px" max=2000 msg="本周市场落实情况不超过2000个汉字"  <%if(action.equals("view")){%>readonly<%} %>><%
        if(list5!=null){
       		 for(int i= 0;i<list5.size();i++){
				Map map5=list5.get(i).toMap();
				String orgAbbreviation = (String)map5.get("orgAbbreviation");
				String content = (String)map5.get("content");
				if(orgAbbreviation.equals("西安物探装备分公司")){
					orgAbbreviation="西安装备分公司";
				}
				if(orgAbbreviation.equals("英洛瓦（天津）物探装备有限责任公司")){
					orgAbbreviation="英洛瓦物探装备";
				}
        %>
<%=orgAbbreviation %> : <%=content %><%} }%>   
        </textarea>
	    </td>
	</tr>  
</table>
<table  border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%">
       <tr class="odd">
    	<td colspan="4" class="ali4">
    	<%if(action.equals("add")){%> 
		<input name="Submit2" type="button" class="iButton2" onClick="save()" value="保存" />
		<%} %>
    	<input name="Submit" type="button" class="iButton2"  onClick="cancel();" value="返回" />
    </td>
  </tr> 
</table>
</form>
</body>

<script type="text/javascript">
function save(){
	document.getElementById("form1").submit();
	
}

function cancel()
{
	window.location="<%=contextPath%>/market/week/weekReport.srq?orgId=<%=orgId%>";
}



</script>
</html>
