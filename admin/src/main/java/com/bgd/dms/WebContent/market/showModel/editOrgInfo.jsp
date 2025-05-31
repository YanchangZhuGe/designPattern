<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
    String userName = (user==null)?"":user.getUserName();
    String typeId = resultMsg.getValue("typeId");
    Map mapOrg = resultMsg.getMsgElement("mapOrg").toMap();
    Map mapOrgInfo = new HashMap();
	if(resultMsg.getMsgElement("mapOrgInfo")!=null){
		mapOrgInfo = resultMsg.getMsgElement("mapOrgInfo").toMap();
		System.out.println("mapOrgInfo===="+mapOrgInfo);
	}
	String corpId = (String)mapOrg.get("orgId");
%> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>添加技术装备能力</title>
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/table.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/calendar-blue.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/bgpmcs_table.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/styles/forum.css" />

<script type="text/javascript">
	
	function saveInfo() {
	var corpId = document.getElementById("corpId").value;
	var form = document.forms[0];
		document.getElementById("form1").submit();
		setTimeout("parentInfo()",1000);
		setTimeout("window.close()",2000);
	}
	function parentInfo(){
		window.dialogArguments.location="<%=contextPath%>/market/show/showSecondPageLike.srq?typeId=<%=typeId%>";
	}
	
</script>
</head>

<body>
<form name="form1" id="form1" enctype="multipart/form-data" method="post" action="<%=contextPath%>/market/saveOrgInfo.srq" target="targetIframe">
<table border="0" cellpadding="0" cellspacing="0" width="95%" height="800" class="form_info">
		<input type="hidden" name="orgId" id="orgId" value="<%=corpId %>"></input>
		<input type="hidden" name="corpId" id="corpId" value="<%=mapOrgInfo.get("corpId") %>"></input>
		<input type="hidden" name="typeId" id="typeId" value="<%=typeId %>"></input>
		<tr class="odd">
		  	<td class="inquire_item"><font color=red>*</font>&nbsp;公司简称：</td>
		    <td class="inquire_form">
		    	<input type="text" name="shortName" value="<%=mapOrgInfo.get("shortName")==null?"":mapOrgInfo.get("shortName") %>" class="input_width"/>	    
		    </td>
		    <td class="inquire_item">&nbsp;公司全称：</td>
	    	<td class="inquire_form">
	    		<input type="text" id="fullName" class="input_width"  name="fullName" value="<%=mapOrgInfo.get("fullName")==null?"":mapOrgInfo.get("fullName") %>">
	     	</td>
		</tr>
		<tr class="odd">
		  	<td class="inquire_item">&nbsp;公司地址：</td>
		    <td class="inquire_form">
		    	<input type="text" name="address" value="<%=mapOrgInfo.get("address")==null?"":mapOrgInfo.get("address") %>" class="input_width"/>	    
		    </td>
		    <td class="inquire_item">&nbsp;邮政编码：</td>
	    	<td class="inquire_form">
	    		<input type="text" id="zipCode" class="input_width"  name="zipCode" value="<%=mapOrgInfo.get("zipCode")==null?"":mapOrgInfo.get("zipCode") %>">
	     	</td>
		</tr>
		<tr class="odd">
		  	<td class="inquire_item">&nbsp;电话：</td>
		    <td class="inquire_form">
		    	<input type="text" name="phone" value="<%=mapOrgInfo.get("phone")==null?"":mapOrgInfo.get("phone") %>" class="input_width"/>	    
		    </td>
		    <td class="inquire_item">&nbsp;传真：</td>
	    	<td class="inquire_form" >
	    		<input type="text" id="fax" class="input_width"  name="fax" value="<%=mapOrgInfo.get("fax")==null?"":mapOrgInfo.get("fax") %>">
	     	</td>
		</tr>
		<%if(typeId.startsWith("106")){%>
		<tr class="odd">
			<td class="inquire_item">主营业务:</td>
			<td class="inquire_form" colspan="3">
				 <textarea name="mainBusiness" id="mainBusiness" style="width: 350px;height: 110px;"><%=mapOrgInfo.get("mainBusiness")==null?"":mapOrgInfo.get("mainBusiness") %></textarea>
			</td>
		</tr>	
		<%}else{ %>
		<tr class="odd">
			<td class="inquire_item">油田范围:</td>
			<td class="inquire_form" colspan="3">
				 <textarea name="oilField" id="oilField" style="width: 350px;height: 110px;"><%=mapOrgInfo.get("oilField")==null?"":mapOrgInfo.get("oilField") %></textarea>
			</td>
		</tr>	
		<%} %>
		<tr class="odd">
			<td class="inquire_item">公司简介:</td>
			<td class="inquire_form" colspan="3">
				<textarea name="memo" id="memo" style="width: 350px;height: 110px;" ><%=mapOrgInfo.get("memo")==null?"":mapOrgInfo.get("memo") %></textarea>
			</td>
		</tr>	  
       <tr class="odd">
    <td colspan="4" class="ali4">
    	<input name="Submit" type="button" class="iButton2"  onClick="saveInfo()" value="保存" />
    </td>
  </tr> 
</table>
</form>
<iframe id="targetIframe" name="targetIframe" style="display: none">
</iframe>
</body>
</html>
