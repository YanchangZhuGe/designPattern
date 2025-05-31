<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getUserName();
    ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
    Map map=resultMsg.getMsgElement("reportMap").toMap();
    List<MsgElement> fileList = resultMsg.getMsgElements("fileList");
    Date d = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	String d1 = sdf.format(d).toString().substring(0, 4);
	Integer n = Integer.parseInt(d1);
	List listYear = new ArrayList();
	for (int i = n; i >= 2005; i--) {
		listYear.add(i);
	}
	String  orgId = resultMsg.getValue("orgId");
%> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>修改页面</title>
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
<form name="form1" id="form1" enctype="multipart/form-data" method="post" action="<%=contextPath%>/market/updateReport.srq">
<table border="0" cellpadding="0" cellspacing="0" class="form_info">
	<input type="hidden" id="historyReportId" name="historyReportId" value="<%=(String)map.get("historyReportId")%>"></input>
	<input type="hidden"  name="deletedFiles" id="deletedFiles"/>
	<tr class="odd">
	  	<td class="inquire_item"><font color=red>*</font>&nbsp;名称：</td>
	    <td class="inquire_form" >
	    	<input type="text" name="title" id="title" value="<%=(String)map.get("title") %>" class="input_width"/>	    
	    </td>
     	<td class="inquire_item"><font color=red>*</font>&nbsp;类型：</td>
    	<td class="inquire_form">
    		<select id=type name="type">
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
	    	<textarea name="memo" id="memo" max=500 msg="备注不超过500个汉字"><%=(String)map.get("memo") %></textarea>   
	    </td>
	</tr>
	   <tr class="odd">
        <td class="inquire_item">附件：</td>
        <td  colspan="3"  class="inquire_form" height="28px;">
          <label>
            <script type="text/javascript">ocUpload.init(6);</script>
          </label>
          <%
         		if(fileList!=null && fileList.size()>0){
         			for(int j=0;j<fileList.size();j++){
         				Map fileMap=fileList.get(j).toMap();
         				String name = (String)fileMap.get("attachName");
        			  	String id = (String)fileMap.get("attachId");
         	%>
			<div id="<%=id%>"><%=name%>
			<input type=button onclick="delfiles('<%=id%>','<%=(String)map.get("historyReportId")%>')"  value="删除">
			</div>
         	<%
         			}
         		}
         	%>
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
	document.getElementById("type").value="<%=(String)map.get("type")%>";
	document.getElementById("recordYear").value="<%=(String)map.get("recordYear") %>";
	document.getElementById("month").value="<%=(String)map.get("month") %>";
	
function save(){
	
	document.getElementById("form1").submit();
	
}
function cancel()
{
	window.location="<%=contextPath%>/market/startReport.srq?orgId=<%=orgId%>";
}
function delfiles(id,id2) {
	if(confirm("确定要删除此附件?")) {
    	var id1=id;
    	var id3=id2;
     	document.getElementById('deletedFiles').value+=id1 +',';
     	document.getElementById(id).style.display='none';
  	} else {
    	return false;
 	}	
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
