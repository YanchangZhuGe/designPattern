<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
 
<%

	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String userName = (user==null)?"":user.getEmpId();
	String foreignKeyId = "";	
	if(resultMsg.getValue("foreignKeyId")!=null){
		foreignKeyId =resultMsg.getValue("foreignKeyId");
	}
	String action = "";
	if(resultMsg.getValue("action")!=null){
		action =resultMsg.getValue("action");
	}
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());
 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<title>备注页面</title>
</head>
<body style="background:#e8eaeb" onload="refreshData()">
 
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		     <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			 <td background="<%=contextPath%>/images/list_15.png">
			    <table width="100%" border="0" cellspacing="0" cellpadding="0">			  
				  <tr>			    
				    <td>&nbsp;</td>
				    <%if(!action.equals("view")){%>			   
				    <auth:ListButton functionId="" css="bc" event="onclick='toAdd()'" title="保存"></auth:ListButton>
				    <%}%>		 
				  </tr>			  
			   </table>
			</td>
			<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
		 </tr>
		</table>
			
			  <table width="100%" border="0"   cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="even" >	
			      <input type="hidden" name="remarkId" id="remarkId" value=""/> 					 
			      <input type="hidden" name="foreignKeyId" id="foreignKeyId" value="<%=foreignKeyId==null?"":foreignKeyId%>"/> 
					 
			      <textarea id="notes" name="notes"  class="textarea" ></textarea>			      
			      </td>			  
			    </tr>
			  </table>
		 
 
</body>
<script type="text/javascript">
function frameSize(){
	$("#queryRetTable").css("height",$(window).height()-36);
	$("#notes").css("height",$(window).height()-48);
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	
</script>

<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var foreignKeyId='<%=foreignKeyId%>';
 
	 function refreshData(){
		 if(foreignKeyId != 'null' && foreignKeyId != ""){
				var querySql = "select t.* from BGP_COMM_REMARK t where t.foreign_key_id= '" + foreignKeyId + "' and t.bsflag='0' ";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
				if(queryRet.datas.length!='0'){
					document.getElementsByName("remarkId")[0].value=queryRet.datas[0].remark_id;	
					document.getElementsByName("foreignKeyId")[0].value=queryRet.datas[0].foreign_key_id;	
					document.getElementsByName("notes")[0].value=queryRet.datas[0].notes;	
				 
				}
		 }
		 
	 }
	 
	function toAdd(){
		   var remarkId=document.getElementById("remarkId").value;//获得 主表id
			var foreignKeyId=document.getElementById("foreignKeyId").value;
			var notes=document.getElementById("notes").value;			
			if(notes !='null' && notes !=""){
			var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
			var submitStr = 'JCDP_TABLE_NAME=BGP_COMM_REMARK&JCDP_TABLE_ID='+remarkId+'&foreign_key_id='+foreignKeyId+'&notes='+notes
			+'&creator=<%=userName%>&updator=<%=userName%>&create_date=<%=curDate%>&modifi_date=<%=curDate%>&bsflag=0';
			syncRequest('Post',path,encodeURI(encodeURI(submitStr)));   //先添加主表信息			
			alert('保存成功！');
			}else{
				alert('请输入相关信息！');
				
			}
	}

 

</script>
</html>