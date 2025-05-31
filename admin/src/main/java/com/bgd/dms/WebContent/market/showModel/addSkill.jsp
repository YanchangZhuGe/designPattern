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
    Map mapOrgTech = new HashMap();
	if(resultMsg.getMsgElement("mapOrgTech")!=null){
		mapOrgTech = resultMsg.getMsgElement("mapOrgTech").toMap();
		System.out.println("mapOrgTech===="+mapOrgTech);
	}
	String corpId = (String)mapOrg.get("orgId");
	String exceptionalSkill = (String)mapOrgTech.get("exceptionalSkill")==null ? "没有信息" : (String)mapOrgTech.get("exceptionalSkill");
	String skillSeries = (String)mapOrgTech.get("skillSeries")==null ? "没有信息" : (String)mapOrgTech.get("skillSeries");
	
%> 
<html>
<head>
<base target="targetIframe">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>添加技术装备能力</title>
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/table.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/calendar-blue.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/bgpmcs_table.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/styles/forum.css" />
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
<script type="text/javascript" src="/BGPMCS/BGP_TS_Forum/js/oc_upload.js"></script>
<script type="text/javascript">
	
	function saveInfo() {
	var corpId = document.getElementById("corpId").value;
	var skillId = document.getElementById("skillId").value;
	var form = document.forms[0];
		document.getElementById("form1").submit();
		setTimeout("parentInfo()",2000);
		setTimeout("window.close()",2000);
	}
	function parentInfo(){
		window.dialogArguments.location="<%=contextPath%>/market/show/showSecondPageLike.srq?pageType=jzhbdt&&typeName=技术装备能力&&typeId=10601001&&headingInfo=物探公司动态&&threeTypeId=10802001";
	}
	
	
</script>
</head>
<body>
<form name="form1"  target="targetIframe" id="form1" enctype="multipart/form-data" method="post" action="<%=contextPath%>/market/saveSkill.srq">
<table border="0" cellpadding="0" cellspacing="0" width="95%" height="800" class="form_info">
		<input type="hidden" name="corpId" id="corpId" value="<%=corpId %>"></input>
		<input type="hidden" name="skillId" id="skillId" value="<%=(String)mapOrgTech.get("exceptionalSkillId") %>"></input>
			<tr class="odd">
				<td class="inquire_item">特色技术:</td>
				<td class="inquire_form">
				   <textarea name="exceptionalSkill" id="exceptionalSkill" style="width: 350px;height: 110px;"><%=exceptionalSkill%></textarea>
				</td>	
			</tr>
			<tr class="odd">
				<td class="inquire_item">技术系列:</td>
				<td class="inquire_form" >
				   <textarea name="skillSeries" id="skillSeries" style="width: 350px;height: 110px;"><%=skillSeries %></textarea>
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
