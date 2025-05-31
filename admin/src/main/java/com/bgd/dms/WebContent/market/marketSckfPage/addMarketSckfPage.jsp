<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getUserName();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String today = format.format(new Date());
    
    String dailyNo = request.getParameter("id");
    
    String action = request.getParameter("action");

%> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title>市场开发</title>
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/table.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/calendar-blue.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/bgpmcs_table.css" />
<script type="text/javascript" src="<%=contextPath%>/js/kindeditor/kindeditor.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/kindeditor/lang/zh_CN.js"></script>
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
<form name="form1" id="form1" enctype="multipart/form-data" method="post" action="<%=contextPath%>/market/addSckf.srq">
<table border="0" cellpadding="0" cellspacing="0" class="form_info">
	 <input name="infomation_id" type="hidden" value=""/>
	<tr class="odd">
	  	<td class="inquire_item"><font color=red>*</font>&nbsp;标题：</td>
	    <td class="inquire_form">
	    	<input type="text" name="infomation_name" id="infomation_name" value="" class="input_width"/>	    
	    </td>
	    <td class="inquire_item"><font color=red>*</font>&nbsp;发布日期：</td>
    	<td class="inquire_form"><input type="text" id="release_date" class="input_width"  name="release_date" value="<%=today %>" readonly>
      &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16"  style="cursor:hand;" onMouseOver="dateSelector(release_date,tributton2);"/></td>
	</tr>
  	<tr class="odd">
  		
    	<td class="inquire_item"><font color=red>*</font>&nbsp;类别：</td>
    	<td class="inquire_form" colspan="3">
    	<% 
    		String sql = "select t.code,t.code_name from bgp_infomation_type_info t where t.father_code='103' order by t.code";
    		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
    		for(int i= 0;i<list.size();i++){
    			Map map=(Map)list.get(i);
    			String code = (String)map.get("code");
    			String codeName = (String)map.get("codeName");
    			%>
    			<input type="radio" name="two_type_id" id="two_type_id" onclick="changeType(this)" value="<%=code %>"><%=codeName %>
    	<%		
    		}
    	%>
      </td>
    </tr>
    <tr class="odd">
	   <td class="inquire_item">&nbsp;新闻范围：</td>
    	<td class="inquire_form" colspan="3">
    	<div id="three_type_id" style="display:block;">
    	</div>
      </td>
    </tr>    
    <tr class="odd">
	  	<td class="inquire_item">&nbsp;摘要：</td>
	    <td class="inquire_form"  colspan="3">
	    	<input type="text" name="abstract" id="abstract" value="" class="input_width"/>	    
	    </td>
	</tr>
    
    <tr class="odd">
	  	<td class="inquire_item">&nbsp;内容：</td>
	    <td colspan="3"  class="inquire_form">
	    <textarea id="editor_id" name="content" style="width:95%;height:500px;">
	    </textarea>
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

var editor;
	KindEditor.ready(function(K) {
	        editor = K.create('#editor_id');
	});
	
function changeType(ob){
	if("10306"==ob.value||"10307"==ob.value){
		document.getElementById("three_type_id").innerHTML="<input type=radio id=three_type_id name=three_type_id checked=checked value=10803001>国内<input type=radio id=three_type_id name=three_type_id value=10803002>国际";
	}else{
		document.getElementById("three_type_id").innerHTML="";
	}
}


function save(){
	if(checkText()){
		return;
	};
	document.getElementById("editor_id").value=editor.html();
	document.getElementById("form1").submit();

}
function cancel()
{
	window.location="<%=contextPath%>/market/marketSckfPage/MarketSckfPageList.jsp";
}

function checkText(){
	var infomation_name=document.getElementById("infomation_name").value;
	var release_date=document.getElementById("release_date").value;
	var two=document.getElementsByName("two_type_id");
	var abstract123=document.getElementById("abstract").value;
	var twoCount=0;
	
	if(infomation_name==""){
		alert("标题不能为空，请填写！");
		return true;
	}
	if(release_date==""){
		alert("发布日期不能为空，请选择！");
		return true;
	}
	for(var i=0; i<two.length;i++){
		if(two[i].checked==true){
			twoCount= twoCount+1;
		}
	}
	if(twoCount!=1){
		alert("类别不能为空，请填写！");
		return true;
	}
	return false;
}

</script>
</html>
