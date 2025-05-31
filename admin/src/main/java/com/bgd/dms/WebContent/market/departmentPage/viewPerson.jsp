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
    List<MsgElement> nationalityList = resultMsg.getMsgElements("nationalityList");
    List<MsgElement> politicalStatusList = resultMsg.getMsgElements("politicalStatusList");
%> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>查看人员基本信息</title>
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/table.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/calendar-blue.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/bgpmcs_table.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/styles/forum.css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
</head>

<body>
<form name="form1" id="form1" enctype="multipart/form-data" method="post" >
<table border="0" cellpadding="0" cellspacing="0" width="95%" height="800" class="form_info">
	 <input name="infomation_id" type="hidden" value=""/>
	<tr class="odd">
	  	<td class="inquire_item">&nbsp;人员姓名：</td>
	    <td class="inquire_form">
	    	 <%=map.get("name") %>
	    </td>
	    <td class="inquire_item">&nbsp;性别：</td>
    	<td class="inquire_form">
    		<%if(map.get("sex")!=null&&map.get("sex").equals("0")){ %>
    		男
    		<%}else if(map.get("sex")!=null&&map.get("sex").equals("1")){ %>
    		女
    		<%} %>
     </td>
	</tr>
  	<tr class="odd">
  		<td class="inquire_item">&nbsp;出生日期：</td>
    	<td class="inquire_form">
    		<%=map.get("birthday") %>
     </td>
    	<td class="inquire_item">&nbsp;民族：</td>
    	<td class="inquire_form">
    	<%if(map.get("nationality")!=null){
    		for(int i=0;i<nationalityList.size();i++){
    			Map mapNat=nationalityList.get(i).toMap();
    			String code = (String)mapNat.get("code");
    			String name = (String)mapNat.get("name");
    			if(code.equals(map.get("nationality"))){
    				%>
    				<%=name %>
    	<% 		}
    		}
    	}%>
    	
      </td>
    </tr>    
    <tr class="odd">
  		<td class="inquire_item">&nbsp;政治面貌：</td>
    	<td class="inquire_form">
    		<%if(map.get("politicalStatus")!=null){
    		for(int i=0;i<politicalStatusList.size();i++){
    			Map mapPol=politicalStatusList.get(i).toMap();
    			String code = (String)mapPol.get("code");
    			String name = (String)mapPol.get("name");
    			if(code.equals(map.get("politicalStatus"))){
    				%>
    				<%=name %>
    	<% 		}
    		}
    	}%>
     </td>
    	<td class="inquire_item">&nbsp;职务：</td>
    	<td class="inquire_form">
    		 <%=map.get("duty") %>
      </td>
    </tr>   
    <tr class="odd">
  		<td class="inquire_item">&nbsp;手机号码：</td>
    	<td class="inquire_form">
    		 <%=map.get("mobilePhone") %>
     </td>
    	<td class="inquire_item">&nbsp;办公电话：</td>
    	<td class="inquire_form">
    		<%=map.get("officePhone") %>
      </td>
    </tr>   
    <tr class="odd">
  		<td class="inquire_item">&nbsp;家庭电话：</td>
    	<td class="inquire_form">
    		<%=map.get("homePhone") %>
     </td>
    	<td class="inquire_item">&nbsp;传真：</td>
    	<td class="inquire_form">
    		<%=map.get("fax") %>
      </td>
    </tr>   
    <tr class="odd">
  		<td class="inquire_item">&nbsp;电子邮箱：</td>
    	<td class="inquire_form">
    		<%=map.get("email") %>
     </td>
    	<td class="inquire_item">&nbsp;主管业务：</td>
    	<td class="inquire_form">
    		<%=map.get("inChargeOf") %>
      </td>
    </tr>   
    <tr class="odd">
  		<td class="inquire_item">&nbsp;所学专业：</td>
    	<td class="inquire_form">
    		<%=map.get("majorSubject") %>
     </td>
    	<td class="inquire_item">&nbsp;最高学位：</td>
    	<td class="inquire_form">
    		<%=map.get("educationLevel") %>
      </td>
    </tr>   
    <tr class="odd">
  		<td class="inquire_item">&nbsp;籍贯：</td>
    	<td class="inquire_form">
    		<%=map.get("birthPlace") %>
     </td>
    	<td class="inquire_item">&nbsp;个人爱好：</td>
    	<td class="inquire_form">
    		<%=map.get("hobby") %>
      </td>
    </tr>   
    <tr class="odd">
  		<td class="inquire_item">&nbsp;家庭住址：</td>
    	<td class="inquire_form">
    		<%=map.get("homeAddress") %>
     </td>
    	<td class="inquire_item">&nbsp;工作地点：</td>
    	<td class="inquire_form">
    		<%=map.get("workPlace") %>
      </td>
    </tr>   
    <tr class="odd">
  		<td class="inquire_item">&nbsp;与公司关系：</td>
    	<td class="inquire_form">
    		<%=map.get("relationship") %>
     </td>
    	<td class="inquire_item">&nbsp;毕业院校：</td>
    	<td class="inquire_form">
    		<%=map.get("graduateFrom") %>
      </td>
    </tr>   
    <tr class="odd">
  		<td class="inquire_item">&nbsp;毕业日期：</td>
    	<td class="inquire_form">
    		<%=map.get("graduateDate") %>
     </td>
    	<td class="inquire_item">&nbsp;特长领域：</td>
    	<td class="inquire_form">
    		<%=map.get("goodAt") %>
      </td>
    </tr>   
    
    <tr class="odd" height="300">
	  	<td class="inquire_item">&nbsp;学习经历：</td>
	    <td colspan="3"  class="inquire_form">
         	<%=map.get("studyExperience") %>
	    </td>
	</tr>
	 <tr class="odd" height="300">
	  	<td class="inquire_item">&nbsp;家庭成员情况：</td>
	    <td colspan="3"  class="inquire_form">
         	<%=map.get("homeMemo") %>
	    </td>
	</tr>
	 <tr class="odd" height="300">
	  	<td class="inquire_item">&nbsp;个人简介：</td>
	    <td colspan="3"  class="inquire_form">
         	<%=map.get("memo") %>
	    </td>
	</tr>
       <tr class="odd">
    <td colspan="4" class="ali4">
    	<input name="Submit" type="button" class="iButton2"  onClick="toBack();" value="返回" />
    </td>
  </tr> 
</table>
</form>
</body>
<script type="text/javascript">
function toBack(){
	window.location="<%=contextPath%>/market/departmentPage/selectPerson.jsp?id=<%=map.get("deptId")%>&corpId=<%=map.get("corpId")%>";
}
</script>
</html>
