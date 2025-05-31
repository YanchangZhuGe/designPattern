<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getUserName();
    Date d = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	String d1 = sdf.format(d).toString().substring(0, 4);
	Integer n = Integer.parseInt(d1);
	List listYear = new ArrayList();
	for (int i = n; i >= 2005; i--) {
		listYear.add(i);
	}
	String orgId = request.getParameter("orgId");
	System.out.println("orgId========="+orgId);
%> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>添加页面</title>
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/table.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/calendar-blue.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/bgpmcs_table.css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="/BGPMCS/BGP_TS_Forum/js/oc_common.js"></script>
</head>

<body>
<form name="form1" id="form1" enctype="multipart/form-data" method="post" action="<%=contextPath%>/market/addValueQuantity.srq">
<table border="0" cellpadding="0" cellspacing="0" class="form_info">
	<input type="hidden" name="orgId" value="<%=orgId%>"> </input>
	<tr class="odd">
	  	<td class="inquire_item"><font color=red>*</font>&nbsp;记录年度：</td>
	   <td class="inquire_form">
    		<select id="recordYear" name="recordYear"  >
    		<%for(int j=0;j<listYear.size();j++){%>
			<option value="<%=listYear.get(j) %>"><%=listYear.get(j) %></option>
			<% } %>
			</select>
     	</td>
     </tr>
     <tr class="odd">
	    <td class="inquire_item"><font color=red>*</font>&nbsp;记录月份：</td>
	    <td class="inquire_form">
			<select id="recordMonth" name="recordMonth" >
	          <option value="1" >1</option>
	          <option value="2" >2</option>
	          <option value="3" >3</option>
	          <option value="4" >4</option>
	          <option value="5" >5</option>
	          <option value="6" >6</option>
	          <option value="7" >7</option>
	          <option value="8" >8</option>
	          <option value="9" >9</option>
	          <option value="10" >10</option>
	          <option value="11" >11</option>
	          <option value="12" >12</option>
		    </select>
      </td>
	 </tr>
     <tr class="odd">
     	<td class="inquire_item"><font color=red>*</font>&nbsp;预算指标（万元）：</td>
     	<td class="inquire_form">
    		<input type="text" name="planValue" id="planValue" value=""></input>
     	</td>
	</tr>
  	<tr class="odd">
    	<td class="inquire_item"><font color=red>*</font>&nbsp;落实价值工作量（万元）：</td>
    	<td class="inquire_form">
    		<input type="text" name="implValue" id="implValue" value="" />
     	</td>
     </tr>
     <tr class="odd">
    	<td class="inquire_item"><font color=red>*</font>&nbsp;累计完成价值量（万元）：</td>
    	<td class="inquire_form">
    		<input type="text" name="totalValue" id="totalValue" value="" />
     	</td>
     </tr>
    <tr class="odd">
    <td colspan="4" class="ali4">
		<input name="Submit2" type="button" class="iButton2" onClick="save()" value="保存" />
    	<input name="Submit" type="button" class="iButton2"  onClick="cancel();" value="返回" />
    </td>
  </tr> 
</table>
</form>
</body>

<script type="text/javascript">
function save(){
	if(checkText()){
		return;
	}
	document.getElementById("form1").submit();
	
}
function cancel()
{
	window.location="<%=contextPath%>/market/startValueQuantity.srq?orgId=<%=orgId%>";
}
function checkText(){
	var recordYear=document.getElementById("recordYear").value;
	var recordMonth=document.getElementById("recordMonth").value;
	var corpId=document.getElementsByName("corpId");
	var planValue=document.getElementById("planValue").value;
	var implValue=document.getElementById("implValue").value;
	var totalValue=document.getElementById("totalValue").value;
	if(recordYear==""){
		alert("记录年度不能为空，请填写！");
		return true;
	}
	if(recordMonth==""){
		alert("记录月份不能为空，请选择！");
		return true;
	}
	if(corpId==""){
		alert("组织机构不能为空，请选择！");
		return true;
	}
	if(planValue==""){
		alert("预算指标不能为空，请选择！");
		return true;
	}
	if(implValue==""){
		alert("落实价值工作量不能为空，请选择！");
		return true;
	}
	if(totalValue==""){
		alert("累计完成价值量不能为空，请选择！");
		return true;
	}
	return false;
}

</script>
</html>
