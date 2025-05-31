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
	Map map=resultMsg.getMsgElement("map").toMap();
	String personId = resultMsg.getValue("personId");
	String button = resultMsg.getValue("button");
	String qwe = map.get("politicalStatus")== null ? "" : (String)map.get("politicalStatus");
	
	String asd = map.get("nationality")== null ? "" : (String)map.get("nationality");
	System.out.println("qwe:"+qwe);
	System.out.println("asd:"+asd);
	
%>
<head>
<title>添加人员信息</title>
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
	if(checkText()){
		return;
	};
	var form = document.forms[0];
	document.getElementById("form1").submit();
}

function checkText(){
	var name = document.getElementById("name").value;
	var corpId = document.getElementById("corpId").value;
	if(name == ""){
		alert("人员姓名不能为空");
		return true;
	}else if(corpId==""){
		alert("请选择组织机构");
		return true;
	}
	return false;
}

function cancel()
{
	window.location="<%=contextPath%>/market/competePage/competeList.lpmd";
}
	
</script>

</head>
<body>
<form name="form1" id="form1" method="post"  action="<%=contextPath%>/market/updateWuTanPerson.srq">
<table border="0" cellpadding="0" cellspacing="0" width="95%" height="800" class="form_info">
	 <input name="personId" type="hidden" value="<%=map.get("personId") %>"/>
  <tr class="odd">
  	<td class="inquire_item"><font color="red">* </font>姓名:</td>
    <td class="inquire_form">
	  <input name="name" id="name" type="text" class="input_width" value="<%=map.get("name") %>" maxlength=16 <%if(button.equals("view")){ %> readonly="readonly" <%} %> />
	</td>
    <td class="inquire_item"><font color="red">* </font>性别:</td>
    <td class="inquire_form">
	  <select name="sex" id="sex" class="select_width" <%if(button.equals("view")){ %> disabled="disabled" <%} %>>
        <option value="0" selected>男</option>
        <option value="1" >女</option>
	  </select>
	</td>
  </tr>
  <tr class="odd">
  <td class="inquire_item"><font color="red">* </font>组织机构:</td>
    <td class="inquire_form">
	  <select name="corpId" id="corpId" class="select_width" <%if(button.equals("view")){ %> disabled="disabled" <%} %>>
        <option value="">中石油-------------------------------------------------------------</option>
  	<option value="63">大庆物探一公司</option>
  	<option value="65">大庆物探二公司</option>
  	<option value="36">川庆钻探物探公司</option>
  	<option value="">中石化-------------------------------------------------------------</option>
  	<option value="37">胜利物探公司</option>
  	<option value="44">江汉物探公司</option>
  	<option value="43">江苏物探公司</option>
  	<option value="42">河南物探公司</option>
  	<option value="35">中原物探公司</option>
  	<option value="30">南方物探公司</option>
  	<option value="50">第一物探公司</option>
  	<option value="48">西南二物</option>
  	<option value="49">中南五物</option>
  	<option value="34">东北物探公司</option>
  	<option value="32">华北物探公司</option>
  	<option value="33">华东物探公司</option>
  	<option value="31">西北物探公司</option>
  	<option value="">中海油-------------------------------------------------------------</option>
  	<option value="29">中海油物探公司</option>
  	<option value="">国际物探公司-------------------------------------------------------------</option>
  	<option value="68">CGGVeritas</option>
  	<option value="69">WesternGeco</option>
  	<option value="70">Fugro</option>
  	<option value="71">PGS</option>
  	<option value="72">TGS-Nopec</option>
  	<option value="73">SeaBird</option>
  	<option value="74">Geokinetics</option>
  	<option value="75">IGS</option>
  	<option value="">其他物探公司-------------------------------------------------------------</option>
  	<option value="51">八一四队</option>
  	<option value="56">安徽省勘查技术院</option>
  	<option value="57">北京勘察技术工程公司</option>
  	<option value="58">廊坊地球物理地球化学勘查研究院</option>
  	<option value="59">北京中色物探有限公司</option>
  	<option value="60">中国冶金地质勘查工程总局地球物理勘查院</option>
  	<option value="61">西安中勘工程有限公司</option>
  	<option value="62">天津华北有色</option>
	  </select>
	</td>
    <td class="inquire_item">出生日期:</td>
    <td class="inquire_form">
    	<input type="text" name="birthday" id="birthday" value="<%=map.get("birthday") %>" class="input_width" readonly/>
    		&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16"  style="cursor:hand;" onMouseOver="dateSelector(birthday,tributton2);"/>
	</td>
	
  </tr>
  <tr class="odd">
  	<td class="inquire_item">政治面貌:</td>
    <td class="inquire_form">
    	<select name="politicalStatus" id="politicalStatus" class="select_width" <%if(button.equals("view")){ %> disabled="disabled" <%} %>>
		        <option value="" selected>请选择</option>
		        <option value="0020001" >中共党员</option>
		        <option value="0020002" >共青团员</option>
		        <option value="0020003" >群众</option>
		  	</select>
	</td>
	<td class="inquire_item">民族:</td>
	<td class="inquire_form">
	  <select name="nationality" id="nationality" class="select_width" <%if(button.equals("view")){ %> disabled="disabled" <%} %>>
		        <option value="" selected>请选择</option>
		        <option value="0010001" >汉族</option>
		        <option value="0010002" >满族</option>
		        <option value="0010003" >回族</option>
		        <option value="0010004" >维吾尔族</option>
		        <option value="0010005" >藏族</option>
		        <option value="0010006" >朝鲜族</option>
		  	</select>
	</td>
 </tr>
  <tr class="odd">
  <td class="inquire_item">职务:</td>
    	<td class="inquire_form">
    	<input name="duty" type="text" class="input_width" value="<%=map.get("duty") %>" maxlength=40 <%if(button.equals("view")){ %> readonly="readonly" <%} %>/>
	</td>
	<td class="inquire_item">手机号码:</td>
    <td class="inquire_form">
	  <input name="mobilePhone" type="text" class="input_width" value="<%=map.get("mobilePhone") %>" maxlength=16 <%if(button.equals("view")){ %> readonly="readonly" <%} %>/>
	</td>
  	
	</tr>
  <tr class="odd">
  <td class="inquire_item">办公电话:</td>
    <td class="inquire_form">
	  <input name="officePhone" type="text" class="input_width" value="<%=map.get("officePhone") %>" maxlength=16 <%if(button.equals("view")){ %> readonly="readonly" <%} %>/>
	</td>
    <td class="inquire_item">家庭电话:</td>
    <td class="inquire_form">
		<input name="homePhone" type="text" class="input_width" value="<%=map.get("homePhone") %>" maxlength=16 <%if(button.equals("view")){ %> readonly="readonly" <%} %>/>
	</td>
	
	</tr>
  <tr class="odd">
  <td class="inquire_item">传真:</td>
    <td class="inquire_form">
	  <input name="fax" type="text" class="input_width" value="<%=map.get("fax") %>" maxlength=16 <%if(button.equals("view")){ %> readonly="readonly" <%} %>/>
	</td>
	<td class="inquire_item">电子邮箱:</td>
    <td class="inquire_form">
	  <input name="email" type="text" class="input_width" value="<%=map.get("email") %>" <%if(button.equals("view")){ %> readonly="readonly" <%} %> isEmail msg="请按照正确格式输入邮箱地址"/>
	</td>
	
	</tr>
  <tr class="odd">
  	<td class="inquire_item">最高学位:</td>
    <td class="inquire_form">
	  <input type="text" name="educationLevel" class="input_width" value="<%=map.get("educationLevel") %>" maxlength=50 <%if(button.equals("view")){ %> readonly="readonly" <%} %>/>
	</td>
	<td class="inquire_item">籍贯:</td>
	<td class="inquire_form">
	   <input name="birthPlace" type="text" class="input_width" value="<%=map.get("birthPlace") %>" maxlength=25 <%if(button.equals("view")){ %> readonly="readonly" <%} %>/>
	</td>
	</tr>
	<tr class="odd">
	<td class="inquire_item">个人爱好:</td>
    <td class="inquire_form">
	  <input name="hobby" type="text" class="input_width" value="<%=map.get("hobby") %>" maxlength=50 <%if(button.equals("view")){ %> readonly="readonly" <%} %>/>
	</td>
	 <td class="inquire_item">家庭住址:</td>
    <td class="inquire_form">
    	<input name="homeAddress" type="text" class="input_width" value="<%=map.get("homeAddress") %>" maxlength=50 <%if(button.equals("view")){ %> readonly="readonly" <%} %>/>
	</td>
	</tr>
  <tr class="odd">
  <td class="inquire_item">工作地点:</td>
    <td class="inquire_form">
	  <input name="workPlace" type="text" class="input_width" value="<%=map.get("workPlace") %>" maxlength=25 <%if(button.equals("view")){ %> readonly="readonly" <%} %>/>
	</td>
	<td class="inquire_item">所学专业:</td>
    	<td class="inquire_form"  >
    		 <input name="majorSubject" type="text" class="input_width" value="<%=map.get("majorSubject") %>" maxlength=16 <%if(button.equals("view")){ %> readonly="readonly" <%} %>/>
		</td>
	</tr>
  <tr class="odd">
  <td class="inquire_item">毕业院校:</td>
    <td class="inquire_form">
	  <input name="graduateFrom" type="text" class="input_width" value="<%=map.get("graduateFrom") %>" maxlength=32 <%if(button.equals("view")){ %> readonly="readonly" <%} %>/>
	</td>
	<td class="inquire_item">毕业日期:</td>
    <td class="inquire_form">
	  	<input type="text" name="graduateDate" id="graduateDate" value="<%=map.get("graduateDate") %>" class="input_width" readonly/>
    		&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16"  style="cursor:hand;" onMouseOver="dateSelector(graduateDate,tributton3);"/>
	</td>
	</tr>
	<tr class="odd">
	 <td class="inquire_item">特长领域:</td>
    <td class="inquire_form" >
    	 <input name="goodAt" type="text" class="input_width" value="<%=map.get("goodAt") %>" maxlength=50 <%if(button.equals("view")){ %> readonly="readonly" <%} %>/>
	</td>
	<td></td>
	<td></td>
	</tr>
  <tr class="odd">
	<td class="inquire_item">主管业务:</td>
	 <td class="inquire_form" colspan="3">
      <textarea name="inChargeOf" id="inChargeOf" max=16 msg="主管业务不超过16个汉字" <%if(button.equals("view")){ %> readonly="readonly" <%} %>><%=map.get("inChargeOf") %></textarea>
	</td>
		</tr>
	<tr class="odd">
		 <td class="inquire_item">学习经历:</td>
    <td class="inquire_form" colspan="3">
      <textarea name="studyExperience" id="studyExperience" max=2000 msg="学习经历不超过2000个汉字" <%if(button.equals("view")){ %> readonly="readonly" <%} %>><%=map.get("studyExperience") %></textarea>
	</td>
	</tr>
	<tr class="odd">
	<td class="inquire_item">家庭成员情况:</td>
    <td class="inquire_form" colspan="3">
      <textarea name="homeMemo" id="homeMemo" max=2000 msg="家庭成员情况不超过2000个汉字" <%if(button.equals("view")){ %> readonly="readonly" <%} %>><%=map.get("homeMemo") %></textarea>
	</td>
	</tr>
  <tr class="odd">
	 <td class="inquire_item">个人简介:</td>
    <td class="inquire_form" colspan="3">
      <textarea name="memo" id="memo" max=2000 msg="个人简介不超过2000个汉字" <%if(button.equals("view")){ %> readonly="readonly" <%} %>><%=map.get("memo") %></textarea>
	</td>
	</tr>
  <tr class="odd">
    <td colspan="4" class="ali3">
      <%if(button.equals("edit")){ %>
	  <input type="button" class="iButton2" value="保存" onclick="saveInfo();"/>
	  <%} %> 
	  <input type="button" class="iButton2" value="返回" onclick="cancel();"/>
	</td>
  </tr>
</table>
</form>
</body>
<script type="text/javascript">
	document.getElementById("corpId").value=<%=map.get("corpId")%>;
	document.getElementById("sex").value=<%=map.get("sex")== null ? "" : map.get("sex")%>;
	document.getElementById("politicalStatus").value="<%=qwe%>";
	document.getElementById("nationality").value="<%=asd%>";

</script>
</html>