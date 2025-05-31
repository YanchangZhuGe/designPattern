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
    Date d = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	String d1 = sdf.format(d).toString().substring(0, 4);
	Integer n = Integer.parseInt(d1);
	List listYear = new ArrayList();
	for (int i = n; i >= 2005; i--) {
		listYear.add(i);
	}
	%>
<head>
<title>项目明细填报</title>
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/table.css" />
<script type="text/javascript" src="/BGPMCS/BGP_TS_Forum/js/oc_common.js"></script>
<script type="text/javascript" src="/BGPMCS/BGP_TS_Forum/js/oc_upload.js"></script>
</head>
<script type="text/javascript">
	
</script>
</head>
<body>
<form name="form1" id="form1" enctype="multipart/form-data" method="post" action="<%=contextPath%>/market/addProjectDynamic.srq">
<table border="0" cellpadding="0" cellspacing="0" class="form_info">
		<input type="hidden" name="orgId" value="<%=orgId%>"></input>
	<tr class="odd">
	  	<td class="inquire_item"><font color=red>*</font>&nbsp;记录年度：</td>
	    <td class="inquire_form">
    		<select id="recordYear" name="recordYear" >
    		<%for(int j=0;j<listYear.size();j++){%>
			<option value="<%=listYear.get(j) %>"><%=listYear.get(j) %></option>
			<% } %>
			</select>
     	</td>
     	<td class="inquire_item"><font color=red>*</font>&nbsp;项目运行状态：</td>
    	<td class="inquire_form">
    		<select id="projectStatus" name="projectStatus">
				<option value="准备启动" >准备启动</option>
				<option value="已完成" >已完成</option>
				<option value="运行中" >运行中</option>
				<option value="暂停" >暂停</option>
			</select>
     	</td>    
	</tr>
  	<tr class="odd">
    	<td class="inquire_item">&nbsp;施工队号：</td>
    	<td class="inquire_form">
    		<input name="teamNo" id="teamNo" type="text" value="" maxlength=25 readonly="readonly"/>
    		<img src="<%=contextPath%>/images/magnifier.gif" id="validateButton" width="16" height="16" style="cursor:hand;" onclick="selectTeamNo();"/>
     	</td>
      	<td class="inquire_item"><font color=red>*</font>&nbsp;项目类型：</td>
    	<td class="inquire_form">
			<select id="projectType" name="projectType">
				<option value="二维物探" >二维物探</option>
				<option value="三维物探" >三维物探</option>
				<option value="非地震" >非地震</option>
				<option value="处理解释" >处理解释</option>
				<option value="VSP" >VSP</option>
				<option value="其它" >其它</option>
			</select>
      </td>
    </tr> 
    <tr class="odd">
    	<td class="inquire_item"><font color=red>*</font>&nbsp;项目名称：</td>
    	<td class="inquire_form">
    		<input name="projectName" id="projectName" type="text" class="input_width" value="" maxlength=50  />
		</td>
      	<td class="inquire_item"><font color=red>*</font>&nbsp;客户名称：</td>
    	<td class="inquire_form">
			<input name="truster" id="truster" type="text"  value="" class="input_width" maxlength=50 readonly="readonly" />
			<img src="<%=contextPath%>/images/magnifier.gif" id="validateButton" width="16" height="16" style="cursor:hand;" onclick="selectOrg();"/>
      </td>
    </tr>    
    <tr class="odd">
    	<td class="inquire_item">&nbsp;设计合同工作量(2D:km,3D:k㎡)：</td>
    	<td class="inquire_form">
    		<input name="designWorkload" id="designWorkload" type="text"  value=""/>
     	</td>
      	<td class="inquire_item">&nbsp;落实价值工作量<br>(万元)：</td>
    	<td class="inquire_form">
			<input name="valueWorkload" id="valueWorkload" type="text"  value=""/>
      </td>
    </tr>    
    <tr class="odd">
    	<td class="inquire_item">&nbsp;物理点数：</td>
    	<td class="inquire_form">
    		<input name="physicsCount" id="physicsCount" type="text" value=""/>
     	</td>
      	<td class="inquire_item">&nbsp;合同签订情况：</td>
    	<td class="inquire_form">
			<select id="conStatus" name="conStatus">
				<option value="未签" >未签</option>
				<option value="已签" >已签</option>
			</select>
      </td>
    </tr>    
    
    <tr class="odd">
	  	<td class="inquire_item">&nbsp;施工方法<br>(如:覆盖次数、接收道数、炮数等):</td>
	    <td class="inquire_form"  colspan="3">
	    	<textarea id="constructionMethod" name="constructionMethod" max=1000 msg="施工方法不超过1000个汉字"></textarea>
	    </td>
	</tr>
	<tr class="odd">
	  	<td class="inquire_item">&nbsp;项目简介:</td>
	    <td class="inquire_form"  colspan="3">
	    	<textarea id="projectIntroduction" name="projectIntroduction" max=2000 msg="项目简介不超过2000个汉字"></textarea>
	    </td>
	</tr>
	<tr class="odd">
	  	<td class="inquire_item">&nbsp;项目进度<br>(开工时间,完成时间,验收时间):</td>
	    <td class="inquire_form"  colspan="3">
	    	<textarea id="projectSchedule" name="projectSchedule" max=2000 msg="项目进度不超过2000个汉字"></textarea>
	    </td>
	</tr>
	<tr class="odd">
	  	<td class="inquire_item">&nbsp;存在问题:</td>
	    <td class="inquire_form"  colspan="3">
	    	<textarea id="problem" name="problem" max=1000 msg="存在问题不超过1000个汉字"></textarea>
	    </td>
	</tr>
	<tr class="odd">
		<td class="inquire_item">合同款结算:</td>
		<td class="inquire_form">
			<input name="balance" id="balance" type="text" class="input_width" value="" maxlength=50   />
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


function selectOrg() {
	path = "<%=contextPath%>/market/projectDynamic/org_tree.jsp";
    window.open(path,"_report","width=400,height=550,location=no,alwaysRaised=1,scrollbars=yes");
}

function getValue(orgName){
	document.getElementById("truster").value = orgName;
}

function cancel()
{
	window.location="<%=contextPath%>/market/startProjectDynamic.srq?orgId=<%=orgId%>";
}
function selectTeamNo() {
	window.open("<%=contextPath%>/market/projectDynamic/addTeamNo.jsp?orgId=<%=orgId%>",'','height=610,width=750');
}
function getTeamNo(teamNo){
	document.getElementById("teamNo").value = teamNo;

}
function checkText(){
	var projectStatus=document.getElementById("projectStatus").value;
	var projectType=document.getElementById("projectType").value;
	var projectName=document.getElementById("projectName").value;
	var recordYear=document.getElementById("recordYear").value;
	var truster=document.getElementById("truster").value;
	if(recordYear==""){
		alert("记录年度不能为空，请填写！");
		return true;
	}
	if(projectStatus==""){
		alert("项目运行状态不能为空，请选择！");
		return true;
	}
	if(projectType==""){
		alert("项目类型不能为空，请选择！");
		return true;
	}
	if(projectName==""){
		alert("项目名称不能为空，请选择！");
		return true;
	}
	if(truster==""){
		alert("客户名称不能为空，请选择！");
		return true;
	}
	return false;
}

</script>
</html>
