<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@ taglib uri="code" prefix="code"%> 
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getUserName();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//	String curDate = format.format(new Date());	
	Date curDate = new Date();
	String orgSubId = request.getParameter("orgSubId");	 
	if (orgSubId == null || orgSubId.equals("")){
		orgSubId = user.getOrgSubjectionId();
	}
	
	String change_no="";
	if(request.getParameter("change_no") != null){
		change_no=request.getParameter("change_no");	
		
	}
    String projectInfoNo ="";
    	if(request.getParameter("projectInfoNo") != null){
    		projectInfoNo=request.getParameter("projectInfoNo");	    		
    	}
	
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String hse_accident_id ="";  
	if(resultMsg!=null){
	 hse_accident_id = resultMsg.getValue("hse_accident_id");
	}
	
	String isProject = request.getParameter("isProject");

%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>变更管理功能</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

</head>
<body>
<form name="form" id="form"  method="post" action="" >
<input type="hidden" id="hse_accident_id" name="hse_accident_id" value="<%=hse_accident_id %>"/>
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
				    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >					
					  <tr>						   
						  <td class="inquire_item6">单位：</td>
				    	  <td class="inquire_form6">
				    	  <input type="hidden" id="org_sub_id" name="org_sub_id" class="input_width" />
					      	<input type="text" id="org_sub_id2" name="org_sub_id2" class="input_width" readonly="readonly" onkeydown="return noEdit(event)"/>
				        	
				        	</td>				  
						  <td class="inquire_item6">基层单位：</td>
				    	  <td class="inquire_form6">
				    	  <input type="hidden" id="second_org" name="second_org" class="input_width" />
				    	  <input type="text" id="second_org2" name="second_org2" class="input_width"  readonly="readonly" onkeydown="return noEdit(event)"/>
				        	</td>	    	  
					  </tr>					  
						<tr>								 
						  <td class="inquire_item6">下属单位：</td>
					      	<td class="inquire_form6">
				 	      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
					      	<input type="hidden" id="create_date" name="create_date" value="" />
					      	<input type="hidden" id="creator" name="creator" value="" />
					    	<input type="hidden" id="project_no" name="project_no" value="" />
					      	<input type="hidden" id="change_no" name="change_no"   />
					      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
					      	<input type="text" id="third_org2" name="third_org2" class="input_width"  readonly="readonly" onkeydown="return noEdit(event)"/>
					      	</td> 
					    <td class="inquire_item6"><font color="red">*</font>变更名称：</td>
					    <td class="inquire_form6">
					    <input type="text" id="change_name" name="change_name" class="input_width"  readonly="readonly" />    					    
					    </td>					    
						</tr>						
					  <tr>	
					    <td class="inquire_item6">变更日期：</td>
					    <td class="inquire_form6"><input type="text" id="change_date" name="change_date" class="input_width"   readonly="readonly"/>
					    </td>
			 		    <td class="inquire_item6">变更类型：</td>
					    <td class="inquire_form6"> 
					    <select id="change_type" name="change_type" class="select_width" disabled="disabled">
					       <option value="" >请选择</option>
					       <option value="1" >管理变更</option>
					       <option value="2" >工艺安全类变更</option>
					       <option value="3" >设备设施变更</option>
					       <option value="4" >作业环境变更</option>
						</select> 
					    </td>
					  </tr>					  
					  
					</table>
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
					  <tr>
					    <td class="inquire_item6">变更内容：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:450px;" id="change_content" name="change_content"   class="textarea" readonly="readonly"></textarea></td>
					    <td class="inquire_item6"> </td> 				 
					  </tr>	
					
					</table>
				</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
 var change_no='<%=change_no%>';
 
//键盘上只有删除键，和左右键好用
 function noEdit(event){
 	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
 		return true;
 	}else{
 		return false;
 	}
 }

	if(change_no !=null){
		var querySql = "";
		var queryRet = null;
		var  datas =null;		
		
		querySql = " select  tr.project_no,tr.second_org,tr.org_sub_id,tr.third_org,oi3.org_abbreviation org_name, tr.change_no, tr.change_name,tr.creator,tr.create_date,tr.bsflag, tr.change_type,tr.change_content,tr.change_date, oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_CHANGE_MANAGEMENT tr    left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0'  left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' left join comm_org_subjection os3 on os3.org_subjection_id=tr.org_sub_id and os3.bsflag='0' left join comm_org_information oi3 on oi3.org_id = os3.org_id and oi3.bsflag='0'      where tr.bsflag = '0' and tr.change_no='"+change_no+"'";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null&&datas!=""){		 
	             document.getElementsByName("change_no")[0].value=datas[0].change_no; 
	    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
	    		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name;
	    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
	    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
	    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
	    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
	    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
	  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
	    		 document.getElementsByName("creator")[0].value=datas[0].creator;		    		 
	    		  document.getElementsByName("change_type")[0].value=datas[0].change_type;
	     		  document.getElementsByName("change_content")[0].value=datas[0].change_content;
	    		  document.getElementsByName("change_date")[0].value=datas[0].change_date;		
	    		  document.getElementsByName("change_name")[0].value=datas[0].change_name;			
	    		   document.getElementsByName("project_no")[0].value=datas[0].project_no;		
	    
			}					
		
	    	}		
		
	}

</script>
</html>