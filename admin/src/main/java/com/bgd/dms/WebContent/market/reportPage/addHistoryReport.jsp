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
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<link href="<%=contextPath%>/js/oc/oc_upload.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/oc/oc_common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/oc/oc_upload.js"></script>
</head>

<body>
<form name="form1" id="form1" enctype="multipart/form-data" method="post" action="<%=contextPath%>/market/addReport.srq">
<table border="0" cellpadding="0" cellspacing="0" class="form_info">
		<input type="hidden" name="orgId" value="<%=orgId%>"></input>
	<tr class="odd">
	  	<td class="inquire_item"><font color=red>*</font>&nbsp;名称：</td>
	    <td class="inquire_form">
	    	<input type="text" name="title" id="title" value="" class="input_width"/>	    
	    </td>
     	<td class="inquire_item"><font color=red>*</font>&nbsp;类型：</td>
    	<td class="inquire_form">
    		<select id=type name="type" >
      		  <option value="周报">周报</option>
	          <option value="月报" >月报</option>
	          <option value="季报" >季报</option>
		    </select>
     	</td>    
	</tr>
  	<tr class="odd">
    	<td class="inquire_item"><font color=red>*</font>&nbsp;年度：</td>
    	<td class="inquire_form">
    		<select id="recordYear" name="recordYear"  >
    		<%for(int j=0;j<listYear.size();j++){%>
			<option value="<%=listYear.get(j) %>"><%=listYear.get(j) %></option>
			<% } %>
			</select>
     	</td>
      	<td class="inquire_item"><font color=red>*</font>&nbsp;月份：</td>
    	<td class="inquire_form">
			<select id="month" name="month" >
	          <option value="一月" >一月</option>
	          <option value="二月" >二月</option>
	          <option value="三月" >三月</option>
	          <option value="四月" >四月</option>
	          <option value="五月" >五月</option>
	          <option value="六月" >六月</option>
	          <option value="七月" >七月</option>
	          <option value="八月" >八月</option>
	          <option value="九月" >九月</option>
	          <option value="十月" >十月</option>
	          <option value="十一月" >十一月</option>
	          <option value="十二月" >十二月</option>
		    </select>
      </td>
    </tr>    
    <tr class="odd">
	  	<td class="inquire_item">&nbsp;备注：</td>
	    <td class="inquire_form"  colspan="3">
	    	<textarea name="memo" id="memo" max=500 msg="备注不超过500个汉字"></textarea>   
	    </td>
	</tr>
	   <tr class="odd">
        <td class="inquire_item">附件：</td>
        <td  colspan="3"  class="inquire_form" height="28px;">
          <label>
            <script type="text/javascript">ocUpload.init(6);</script>
          </label>
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
	window.location="<%=contextPath%>/market/startReport.srq?orgId=<%=orgId%>";
}
function checkText(){
	var title=document.getElementById("title").value;
	var type=document.getElementById("type").value;
	var corpId=document.getElementsByName("corpId");
	var recordYear=document.getElementById("recordYear").value;
	var month=document.getElementById("month").value;
	if(title==""){
		alert("名称不能为空，请填写！");
		return true;
	}
	if(type==""){
		alert("类型不能为空，请选择！");
		return true;
	}
	if(corpId==""){
		alert("组织机构不能为空，请选择！");
		return true;
	}
	if(recordYear==""){
		alert("年度不能为空，请选择！");
		return true;
	}
	if(month==""){
		alert("月份不能为空，请选择！");
		return true;
	}
	return false;
}

</script>
</html>
