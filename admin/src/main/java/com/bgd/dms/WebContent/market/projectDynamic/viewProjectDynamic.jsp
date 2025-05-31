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
	Map map=resultMsg.getMsgElement("map").toMap();
	List<MsgElement> fileList = resultMsg.getMsgElements("fileList");
	String orgId = resultMsg.getValue("orgId");
	String back = resultMsg.getValue("back");
	String button = resultMsg.getValue("button");
    String userName = (user==null)?"":user.getUserName();
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
<form name="form1" id="form1" enctype="multipart/form-data" method="post" action="<%=contextPath%>/market/updateProjectDynamic.srq">
<table border="0" cellpadding="0" cellspacing="0" class="form_info">
		<input type="hidden" name="orgId" value="<%=orgId%>"></input>
		<input type="hidden" name="projectDynamicId" value="<%=(String)map.get("projectDynamicId")%>"></input>
		<input type="hidden"  name="deletedFiles" id="deletedFiles"/>
	<tr class="odd">
	  	<td class="inquire_item"><font color=red>*</font>&nbsp;记录年度：</td>
	    <td class="inquire_form">
    		<select id="recordYear" name="recordYear"  <%if(button.equals("view")){ %>disabled="disabled"<%} %>>
    		<%for(int j=0;j<listYear.size();j++){%>
			<option value="<%=listYear.get(j) %>"><%=listYear.get(j) %></option>
			<% } %>
			</select>
     	</td>
     	<td class="inquire_item"><font color=red>*</font>&nbsp;项目运行状态：</td>
    	<td class="inquire_form">
    		<select id="projectStatus" name="projectStatus"  <%if(button.equals("view")){ %>disabled="disabled"<%} %>>
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
    		<input name="teamNo" id="teamNo" type="text" value="<%=(String)map.get("teamNo") %>" maxlength=25  readonly="readonly" />
    		<%if(button.equals("edit")){ %>
			<img src="<%=contextPath%>/images/magnifier.gif" id="validateButton" width="16" height="16" style="cursor:hand;" onclick="selectTeamNo();"/>
			<%} %>
     	</td>
      	<td class="inquire_item"><font color=red>*</font>&nbsp;项目类型：</td>
    	<td class="inquire_form">
			<select id="projectType" name="projectType"  <%if(button.equals("view")){ %>disabled="disabled"<%} %>>
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
    		<input name="projectName" id="projectName" type="text"  value="<%=(String)map.get("projectName") %>" class="input_width"  <%if(button.equals("view")){ %>readonly="readonly" <%} %> />
		</td>
      	<td class="inquire_item"><font color=red>*</font>&nbsp;客户名称：</td>
    	<td class="inquire_form">
			<input name="truster" id="truster" type="text"  value="<%=(String)map.get("truster") %>" class="input_width" maxlength=50 readonly="readonly"  />
			<%if(button.equals("edit")){ %>
			<img src="<%=contextPath%>/images/magnifier.gif" id="validateButton" width="16" height="16" style="cursor:hand;" onclick="selectOrg();"/>
			<%} %>
      </td>
    </tr>    
    <tr class="odd">
    	<td class="inquire_item">&nbsp;设计合同工作量(2D:km,3D:k㎡)：</td>
    	<td class="inquire_form">
    		<input name="designWorkload" id="designWorkload" type="text"  value="<%=(String)map.get("designWorkload") %>"  <%if(button.equals("view")){ %>readonly="readonly" <%} %>/>
     	</td>
      	<td class="inquire_item">&nbsp;落实价值工作量<br>(万元)：</td>
    	<td class="inquire_form">
			<input name="valueWorkload" id="valueWorkload" type="text"  value="<%=(String)map.get("valueWorkload") %>"  <%if(button.equals("view")){ %>readonly="readonly" <%} %>/>
      </td>
    </tr>    
    <tr class="odd">
    	<td class="inquire_item">&nbsp;物理点数：</td>
    	<td class="inquire_form">
    		<input name="physicsCount" id="physicsCount" type="text"  value="<%=(String)map.get("physicsCount") %>"  <%if(button.equals("view")){ %>readonly="readonly" <%} %>/>
     	</td>
      	<td class="inquire_item">&nbsp;合同签订情况：</td>
    	<td class="inquire_form">
			<select id="conStatus" name="conStatus"  <%if(button.equals("view")){ %>disabled="disabled"<%} %>>
				<option value="未签" >未签</option>
				<option value="已签" >已签</option>
			</select>
      </td>
    </tr>    
    
    <tr class="odd">
	  	<td class="inquire_item">&nbsp;施工方法<br>(如:覆盖次数、接收道数、炮数等):</td>
	    <td class="inquire_form"  colspan="3">
	    	<textarea id="constructionMethod" name="constructionMethod" max=1000 msg="施工方法不超过1000个汉字"  <%if(button.equals("view")){ %>readonly="readonly" <%} %>><%=(String)map.get("constructionMethod") %></textarea>
	    </td>
	</tr>
	<tr class="odd">
	  	<td class="inquire_item">&nbsp;项目简介:</td>
	    <td class="inquire_form"  colspan="3">
	    	<textarea id="projectIntroduction" name="projectIntroduction" max=2000 msg="项目简介不超过2000个汉字"  <%if(button.equals("view")){ %>readonly="readonly" <%} %>><%=(String)map.get("projectInstrroduction") %></textarea>
	    </td>
	</tr>
	<tr class="odd">
	  	<td class="inquire_item">&nbsp;项目进度<br>(开工时间,完成时间,验收时间):</td>
	    <td class="inquire_form"  colspan="3">
	    	<textarea id="projectSchedule" name="projectSchedule" max=2000 msg="项目进度不超过2000个汉字"  <%if(button.equals("view")){ %>readonly="readonly" <%} %>><%=(String)map.get("projectSchedule") %></textarea>
	    </td>
	</tr>
	<tr class="odd">
	  	<td class="inquire_item">&nbsp;存在问题:</td>
	    <td class="inquire_form"  colspan="3">
	    	<textarea id="problem" name="problem" max=1000 msg="存在问题不超过1000个汉字"  <%if(button.equals("view")){ %>readonly="readonly" <%} %>><%=(String)map.get("problem") %></textarea>
	    </td>
	</tr>
	<tr class="odd">
		<td class="inquire_item">合同款结算:</td>
		<td class="inquire_form">
			<input name="balance" id="balance" type="text" class="input_width" value="<%=(String)map.get("balance") %>" maxlength=50  <%if(button.equals("view")){ %>readonly="readonly" <%} %> />
		</td>
	</tr>
 	<tr class="odd">
        <td class="inquire_item">附件：</td>
        <td  colspan="3"  class="inquire_form" height="28px;">
        <%if(button.equals("edit")){ %>
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
			<input type=button onclick="delfiles('<%=id%>','<%=(String)map.get("projectDynamicId")%>')"  value="删除">
			</div>
         	<%
         			}
         		}
        	}else{
         	%>
         	 <%
         		if(fileList!=null && fileList.size()>0){
         			for(int j=0;j<fileList.size();j++){
         				Map fileMap=fileList.get(j).toMap();
         	%>
         	<li><a href="<%=contextPath%>/market/DownloadFileAction.srq?pkValue=<%=(String)fileMap.get("attachId")%>"><%=(String)fileMap.get("attachName")%></a></li>
         	<%
         			}
         		}
        	}
         	%>
        </td>
      </tr>
     
       <tr class="odd">
    <td colspan="4" class="ali4">
    	 <%if(button.equals("edit")){ %>
		<input name="Submit2" type="button" class="iButton2" onClick="save()" value="保存" />
		<%} %>
		<%if(back.equals("display")){ %>
    	<input name="Submit" type="button" class="iButton2"  onClick="cancel();" value="返回" />
    	<%} %>
    </td>
  </tr> 
</table>
</form>
</body>
<script type="text/javascript">
	document.getElementById("recordYear").value = "<%=(String)map.get("recordYear") %>"
	document.getElementById("projectStatus").value = "<%=(String)map.get("projectStatus") %>"
	document.getElementById("projectType").value = "<%=(String)map.get("projectType") %>"
	document.getElementById("conStatus").value = "<%=(String)map.get("conStatus") %>"

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

function selectTeamNo() {
	window.open("<%=contextPath%>/market/projectDynamic/addTeamNo.jsp?orgId=<%=orgId%>",'','height=610,width=750');
}
function getTeamNo(teamNo){
	document.getElementById("teamNo").value = teamNo;

}


function cancel()
{
	window.location="<%=contextPath%>/market/startProjectDynamic.srq?orgId=<%=orgId%>";
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
