<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String message = "";
	if(respMsg != null){
		message = respMsg.getValue("message");
	}
 
	   String projectInfoNo ="";
	if(request.getParameter("projectInfoNo") != null){
		projectInfoNo=request.getParameter("projectInfoNo");	    		
	}
	  String isProject = request.getParameter("isProject");
		 
		
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"> 
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" /> 
<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/js/bgpmcs/DivHiddenOpen.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_search.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath %>';
var message = "<%=message%>";
if(message != "" && message != 'null'){
	if(message=="导入成功!"){ 
		alert(message);
//		top.frames('list').frames[1].refreshData();
		top.frames('list').refreshData();
		newClose();
	}else{
		alert(message);		
	}
	
}
	function uploadFile(){		
		var filename = document.getElementById("fileName").value;
		var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
		var second_org = document.getElementsByName("second_org")[0].value;		
		var check_unit_org = document.getElementsByName("check_unit_org")[0].value;
		var check_roots_org = document.getElementsByName("check_roots_org")[0].value;	
		 var check_unit_id = document.getElementsByName("check_unit_id")[0].value;		
		 var check_roots_id = document.getElementsByName("check_roots_id")[0].value;		
		 
		
		if(filename == ""){
			alert("请选择上传附件!");
			return;
		}

		if(check(filename)){
			document.getElementById("confirmButton").disabled="disabled";	
			document.getElementById("fileForm").action = "<%=contextPath%>/hse/check/importHseCheckMain.srq?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>&org_sub_id="+org_sub_id+"&second_org="+second_org+"&check_unit_org="+encodeURI(check_unit_org)+"&check_roots_org="+encodeURI(check_roots_org)+"&check_unit_id="+check_unit_id+"&check_roots_id="+check_roots_id;    
			document.getElementById("fileForm").submit();
		}
			
	}
	function alertError(str){		
		alert(str);
	}

	function check(filename){
		var type=filename.match(/^(.*)(\.)(.{1,8})$/)[3];
		type=type.toUpperCase();
		if(type=="XLS" || type=="XLSX"){
		   return true;
		}
		else{
		   alert("上传类型有误，请上传EXCLE文件！");
		   return false;
		}
	}
	
	function downloadModel(modelname,filename){
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		window.location.href="<%=contextPath%>/rm/em/humanLabor/download.jsp?path=/hse/hseOptionPage/hseCheck/"+modelname+".xlsx&filename="+filename+".xlsx";
	}
	
 

	function selectOrg(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
	    if(teamInfo.fkValue!=""){
	    	document.getElementById("org_sub_id").value = teamInfo.fkValue;
	        document.getElementById("org_sub_id2").value = teamInfo.value;
	    }
	}

	function selectOrg2(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var second = document.getElementById("org_sub_id").value;
		var org_id="";
			var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+second+"'";
		   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;
			if(datas==null||datas==""){
			}else{
				org_id = datas[0].org_id; 
		    }
			    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
			    if(teamInfo.fkValue!=""){
			    	 document.getElementById("second_org").value = teamInfo.fkValue; 
			        document.getElementById("second_org2").value = teamInfo.value;
				}
	   
	}
	
	function selectOrgs(){
		  var teamInfo = {
			        fkValue:"",
			        value:""
			    };
	    var check_unit_org = document.getElementById("check_unit_org").value;
	    window.showModalDialog('<%=contextPath%>/hse/hseOptionPage/hseCheck/selectOrgHR.jsp?multi=true&select=orgid',teamInfo);
	    if(teamInfo.fkValue!=""){
	   	 document.getElementById("check_unit_org2").value = teamInfo.fkValue;
	       document.getElementById("check_unit_org").value = teamInfo.value;
	       document.getElementById("check_unit_id").value = teamInfo.fkValue;
	   }
	}

	function selectOrgs2(){
		  var teamInfo = {
			        fkValue:"",
			        value:""
			    };
	  var check_unit_org = document.getElementById("check_roots_org").value;
	  window.showModalDialog('<%=contextPath%>/hse/hseOptionPage/hseCheck/selectOrgHR.jsp?multi=true&select=orgid',teamInfo);
	  if(teamInfo.fkValue!=""){
	 	 document.getElementById("check_roots_org2").value = teamInfo.fkValue;
	 	  document.getElementById("check_roots_id").value = teamInfo.fkValue;
	     document.getElementById("check_roots_org").value = teamInfo.value;
	    
	 }
	}


</script>
<title>选择要导入的文件</title>
</head>
<body>
<form action="" id="fileForm" method="post" enctype="multipart/form-data">
   <table width="100%" border="0" cellspacing="0" cellpadding="0"  id="oTb" class="tab_line_height" >	
   
					    <tr>			 				   
					       <td class="inquire_item4">检查单位：</td>
				        	<td class="inquire_form4">
				        	<input type="hidden" id="org_sub_id" name="org_sub_id" />				
					      	<input type="text" id="org_sub_id2" name="org_sub_id2"  />
				        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>	        	 
				        	</td> 
				        	 <td class="inquire_item4">检查基层单位：</td>
				        	<td class="inquire_form4">
				        	 <input type="hidden" id="second_org" name="second_org"  />
				 	      	<input type="text" id="second_org2" name="second_org2"   />
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
				        	</td>
					  </tr>			      
				      <tr>		 
					        <td class="inquire_item4">被检查单位：</td>
					      	<td class="inquire_form4">				    
					      	<input type="hidden" id="check_unit_id" name="check_unit_id"    />
					      	<input type="text" id="check_unit_org" name="check_unit_org"    readonly="readonly"/>
					      	<input type="hidden" id="check_unit_org2" name="check_unit_org2"    readonly="readonly"/>
					      	 <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrgs()"/>
					      	</td>
					      	  <td class="inquire_item4">被检查基层单位：</td>
					      	<td class="inquire_form4">				     
					     	<input type="hidden" id="check_roots_id" name="check_roots_id"     />
					      	<input type="text" id="check_roots_org" name="check_roots_org"     readonly="readonly"/>
					    	<input type="hidden" id="check_roots_org2" name="check_roots_org2"   readonly="readonly"/>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrgs2()"/>
					      	</td>
					  </tr>		
					  	  
	 </table>
<table border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%">
	<tr class="even">
		<td class="rtCRUFdName">选择文件：</td>
		<td class="rtCRUFdValue">
		<input type="file"  id="fileName" name="fileName" class="input_width">
		</td>
	</tr>
</table>
<table id="buttonTable" border="0" cellpadding="0" cellspacing="0" class="form_info">
	<tr align="right">
		
		<td>
		<a href="javascript:downloadModel('ImportHseCheckM','HSE检查主信息')"><font color=red>下载导入模板</font></a>
		<input name="Submit" type="button" class="iButton2" id="confirmButton"  onClick="uploadFile()" value="确定" />
		<input name="Submit" type="button" class="iButton2" id="confirmButton"  onClick="newClose()" value="关闭" />
		&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
	</tr>
</table>
<iframe id="targetIframe" name="targetIframe" style="display: none">
</iframe>
</form>
</body>
</html>