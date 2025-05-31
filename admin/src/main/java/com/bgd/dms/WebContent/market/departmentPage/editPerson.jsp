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
    Map map=resultMsg.getMsgElement("map").toMap();
    String personId = resultMsg.getValue("personId");
    String politicalStatus = map.get("politicalStatus") ==null ? "" : (String)map.get("politicalStatus");
    String nationality = map.get("nationality") ==null ? "" : (String)map.get("nationality");
    String sex= "";
    if(map.get("sex")==null||map.get("sex").equals("")){
    	sex="0";
    }else{
    	sex=(String)map.get("sex");
    }
%> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>修改人员信息</title>
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
	var deptId = document.getElementById("deptId").value;
	var corpId = document.getElementById("corpId").value;
	var form = document.forms[0];
		document.getElementById("form1").submit();
			alert('修改成功！');
	}
	
	function checkText(){
		var name = document.getElementById("name").value;
		if(name == ""){
			alert("人员姓名不能为空");
			return true;
		}
		return false;
	}
	function cancel_date(id){
		document.getElementById(id).value="";
	}
	
</script>
</head>

<body>
<form name="form1" id="form1" enctype="multipart/form-data" method="post" action="<%=contextPath%>/market/updatePerson.srq">
<table border="0" cellpadding="0" cellspacing="0" width="95%" height="800" class="form_info">
 	 
	 <input name="personId" type="hidden" value="<%=personId %>"/>
	 <input name="corpId" type="hidden" value="<%=map.get("corpId") %>"/>
	 <input name="deptId" type="hidden" value="<%=map.get("deptId") %>"/>
	<tr class="odd">
	  	<td class="inquire_item"><font color=red>*</font>&nbsp;人员姓名：</td>
	    <td class="inquire_form">
	    	<input type="text" name="name" id="name" value="<%=map.get("name") %>" class="input_width"/>
	    </td>
	    <td class="inquire_item">&nbsp;性别：</td>
    	<td class="inquire_form">
    		<select name="sex" id="sex" class="select_width">
		        <option value="0" selected>男</option>
		        <option value="1" >女</option>
		  </select>
     </td>
	</tr>
  	<tr class="odd">
  		<td class="inquire_item">&nbsp;出生日期：</td>
    	<td class="inquire_form">
    		<input type="text" name="birthday" id="birthday" value="<%=map.get("birthday") %>" class="input_width" readonly/>
    		&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16"  style="cursor:hand;" onMouseOver="dateSelector(birthday,tributton2);"/>
     </td>
    	<td class="inquire_item">&nbsp;民族：</td>
    	<td class="inquire_form">
	    	<select name="nationality" class="select_width">
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
  		<td class="inquire_item">&nbsp;政治面貌：</td>
    	<td class="inquire_form">
    		<select name="politicalStatus" class="select_width">
		        <option value="" selected>请选择</option>
		        <option value="0020001" >中共党员</option>
		        <option value="0020002" >共青团员</option>
		        <option value="0020003" >群众</option>
		  	</select>
     </td>
    	<td class="inquire_item">&nbsp;职务：</td>
    	<td class="inquire_form">
    		 <input type="text" name="duty" id="duty" value="<%=map.get("duty") %>" class="input_width"/>
      </td>
    </tr>   
    <tr class="odd">
  		<td class="inquire_item">&nbsp;手机号码：</td>
    	<td class="inquire_form">
    		 <input type="text" name="mobilePhone" id="mobilePhone" value="<%=map.get("mobilePhone") %>" class="input_width"/>
     </td>
    	<td class="inquire_item">&nbsp;办公电话：</td>
    	<td class="inquire_form">
    		<input type="text" name="officePhone" id="officePhone" value="<%=map.get("officePhone") %>" class="input_width"/>
      </td>
    </tr>   
    <tr class="odd">
  		<td class="inquire_item">&nbsp;家庭电话：</td>
    	<td class="inquire_form">
    		<input type="text" name="homePhone" id="homePhone" value="<%=map.get("homePhone") %>" class="input_width"/>
     </td>
    	<td class="inquire_item">&nbsp;传真：</td>
    	<td class="inquire_form">
    		<input type="text" name="fax" id="fax" value="<%=map.get("fax") %>" class="input_width"/>
      </td>
    </tr>   
    <tr class="odd">
  		<td class="inquire_item">&nbsp;电子邮箱：</td>
    	<td class="inquire_form">
    		<input type="text" name="email" id="email" value="<%=map.get("email") %>" class="input_width"/>
     </td>
    	<td class="inquire_item">&nbsp;主管业务：</td>
    	<td class="inquire_form">
    		<input type="text" name="inChargeOf" id="inChargeOf" value="<%=map.get("inChargeOf") %>" class="input_width"/>
      </td>
    </tr>   
    <tr class="odd">
  		<td class="inquire_item">&nbsp;所学专业：</td>
    	<td class="inquire_form">
    		<input type="text" name="majorSubject" id="majorSubject" value="<%=map.get("majorSubject") %>" class="input_width"/>
     </td>
    	<td class="inquire_item">&nbsp;最高学位：</td>
    	<td class="inquire_form">
    		<input type="text" name="educationLevel" id="educationLevel" value="<%=map.get("educationLevel") %>" class="input_width"/>
      </td>
    </tr>   
    <tr class="odd">
  		<td class="inquire_item">&nbsp;籍贯：</td>
    	<td class="inquire_form">
    		<input type="text" name="birthPlace" id="birthPlace" value="<%=map.get("birthPlace") %>" class="input_width"/>
     </td>
    	<td class="inquire_item">&nbsp;个人爱好：</td>
    	<td class="inquire_form">
    		<input type="text" name="hobby" id="hobby" value="<%=map.get("hobby") %>" class="input_width"/>
      </td>
    </tr>   
    <tr class="odd">
  		<td class="inquire_item">&nbsp;家庭住址：</td>
    	<td class="inquire_form">
    		<input type="text" name="homeAddress" id="homeAddress" value="<%=map.get("homeAddress") %>" class="input_width"/>
     </td>
    	<td class="inquire_item">&nbsp;工作地点：</td>
    	<td class="inquire_form">
    		<input type="text" name="workPlace" id="workPlace" value="<%=map.get("workPlace") %>" class="input_width"/>
      </td>
    </tr>   
    <tr class="odd">
  		<td class="inquire_item">&nbsp;与公司关系：</td>
    	<td class="inquire_form">
    		<input type="text" name="relationship" id="relationship" value="<%=map.get("relationship") %>" class="input_width"/>
     </td>
    	<td class="inquire_item">&nbsp;毕业院校：</td>
    	<td class="inquire_form">
    		<input type="text" name="graduateFrom" id="graduateFrom" value="<%=map.get("graduateFrom") %>" class="input_width"/>
      </td>
    </tr>   
    <tr class="odd">
  		<td class="inquire_item">&nbsp;毕业日期：</td>
    	<td class="inquire_form">
    		<input type="text" name="graduateDate" id="graduateDate" value="<%=map.get("graduateDate") %>" class="input_width" readonly/>
    		&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16"  style="cursor:hand;" onMouseOver="dateSelector(graduateDate,tributton3);"/>
     </td>
    	<td class="inquire_item">&nbsp;特长领域：</td>
    	<td class="inquire_form">
    		<input type="text" name="goodAt" id="goodAt" value="<%=map.get("goodAt") %>" class="input_width"/>
      </td>
    </tr>   
    
    <tr class="odd" height="300">
	  	<td class="inquire_item">&nbsp;学习经历：</td>
	    <td colspan="3"  class="inquire_form">
         	 <textarea name="studyExperience" id="studyExperience" max=2000 msg="学习经历不超过2000个汉字"><%=map.get("studyExperience") %></textarea>
	    </td>
	</tr>
	 <tr class="odd" height="300">
	  	<td class="inquire_item">&nbsp;家庭成员情况：</td>
	    <td colspan="3"  class="inquire_form">
         	  <textarea name="homeMemo" id="homeMemo" max=2000 msg="家庭成员情况不超过2000个汉字"><%=map.get("homeMemo") %></textarea>
	    </td>
	</tr>
	 <tr class="odd" height="300">
	  	<td class="inquire_item">&nbsp;个人简介：</td>
	    <td colspan="3"  class="inquire_form">
         	<textarea name="memo" id="memo" max=500 msg="个人简历不超过500个汉字"><%=map.get("memo") %></textarea>
	    </td>
	</tr>
       <tr class="odd">
    <td colspan="4" class="ali4">
    	<input name="Submit" type="button" class="iButton2"  onClick="saveInfo()" value="保存" />
    	<input name="Return" type="button" class="iButton2"  onClick="toBack();" value="返回" />
    </td>
  </tr> 
</table>
</form>
</body>
<script type="text/javascript">
	document.getElementById("sex").value="<%=sex %>";
	document.getElementById("politicalStatus").value="<%=politicalStatus %>";
	document.getElementById("nationality").value="<%=nationality %>";
	
	function toBack(){
		window.location="<%=contextPath%>/market/departmentPage/selectPerson.jsp?id=<%=map.get("deptId")%>&corpId=<%=map.get("corpId")%>";
	}
	
</script>
</html>
