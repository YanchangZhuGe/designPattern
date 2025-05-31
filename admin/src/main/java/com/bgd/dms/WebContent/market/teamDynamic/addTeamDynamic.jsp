<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<html>
	<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
    String userName = (user==null)?"":user.getUserName();
    String orgId=request.getParameter("orgId");
	%>
<head>
<title>添加队伍动态信息</title>
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/table.css" />
<script type="text/javascript" src="/BGPMCS/BGP_TS_Forum/js/oc_common.js"></script>
<script type="text/javascript" src="/BGPMCS/BGP_TS_Forum/js/oc_upload.js"></script>
</head>
<script type="text/javascript">
	
</script>
</head>
<body>
<form name="form1" id="form1"  method="post" action="<%=contextPath%>/market/addTeamDynamic.srq">
<table border="0" cellpadding="0" cellspacing="0" class="form_info">
 		<input name="orgId" type="hidden" value="<%=orgId %>"/>
    <tr class="odd">
    	<td class="inquire_item"><font color=red>*</font>&nbsp;作业队号：</td>
    	<td class="inquire_form">
    		<input name="teamNo" id="teamNo" type="text" class="input_width" value=""/>
		</td>
      	<td class="inquire_item"><font color=red>*</font>&nbsp;队伍状态：</td>
    	<td class="inquire_form">
    		<select id="teamStatus" name="teamStatus">
				<option value="在工">在工</option>
				<option value="闲置">闲置</option>
				<option value="准备启动">准备启动</option>
			</select>
      </td>
    </tr>    
    <tr class="odd">
    	<td class="inquire_item">&nbsp;作业地点：</td>
    	<td class="inquire_form" colspan="3">
			<textarea name="workPlace" id="workPlace" max=50 msg="作业地点不超过50个汉字"></textarea>
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
	window.location="<%=contextPath%>/market/startTeamDynamic.srq?orgId=<%=orgId%>";
}
	
function checkText(){
	var teamNo=document.getElementById("teamNo").value;
	if(teamNo==""){
		alert("作业队号不能为空，请填写！");
		return true;
	}
	return false;
}

</script>
</html>
