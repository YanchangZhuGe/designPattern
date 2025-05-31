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
	String curDate = format.format(new Date());	
	String orgSubId = request.getParameter("orgSubId");	 
	if (orgSubId == null || orgSubId.equals("")){
		orgSubId = user.getOrgSubjectionId();
	} 
	String cicheck_no="";
	String cinspection_no="";
	if(request.getParameter("cicheck_no") != null){
		cicheck_no=request.getParameter("cicheck_no");	
		
	}
	if(request.getParameter("cinspection_no") != null){
		cinspection_no=request.getParameter("cinspection_no");	
		
	}
 
 
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>承包商（供应商）监督检查</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
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
<body  onload="" >
<form name="form" id="form"  method="post" action="" >
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg"> 
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
					  <tr> 
					    <td class="inquire_item6"><font color="red">*</font>整改完成时间：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" >
			 	      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
				      	<input type="hidden" id="create_date" name="create_date" value="" />
				      	<input type="hidden" id="creator" name="creator" value="" />
				      	<input type="hidden" id="cicheck_no" name="cicheck_no"   />
				     	<input type="hidden" id="cinspection_no" name="cinspection_no"   />
				     	 <input type="text" id="r_completion_time" name="r_completion_time" class="input_width"   style="width:250px;" readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(r_completion_time,tributton1);" />&nbsp;
					    <td class="inquire_item6"> </td> 				 
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>问题描述：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" > 
					    <textarea  style="width:450px;" id="problem_description" name="problem_description"   class="textarea" ></textarea></td>
					    <td class="inquire_item6"> </td> 				 
					  </tr>	
					  
					  <tr>
					    <td class="inquire_item6">整改完成情况：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" > 
					    <textarea  style="width:450px;" id="r_completion" name="r_completion"   class="textarea" ></textarea></td>
					    <td class="inquire_item6"> </td> 				 
					  </tr>	
					</table>
				</div>
			<div id="oper_div">
				<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
				<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
 var cicheck_no='<%=cicheck_no%>';
 var cinspection_no='<%=cinspection_no%>';
 
 
 function checkJudge(){ 
	 var r_completion_time=document.getElementsByName("r_completion_time")[0].value;
	 var problem_description=document.getElementsByName("problem_description")[0].value;
 	
		if(r_completion_time==""){
			alert("整改完成时间不能为空，请填写！");
			return true;
		}
	    if(problem_description==""){
			alert("问题描述不能为空，请填写！");
			return true;
		}
		return false;
	}
function submitButton(){  
	if(checkJudge()){
		return;
	}
	var rowParams = new Array(); 
		var rowParam = {};			
   		var cicheck_no = document.getElementsByName("cicheck_no")[0].value;
		var create_date = document.getElementsByName("create_date")[0].value;
		var creator = document.getElementsByName("creator")[0].value; 
		var bsflag = document.getElementsByName("bsflag")[0].value; 
		var cinspection_nos = document.getElementsByName("cinspection_no")[0].value;
		
		var problem_description = document.getElementsByName("problem_description")[0].value;		
		var r_completion = document.getElementsByName("r_completion")[0].value;		
		var r_completion_time = document.getElementsByName("r_completion_time")[0].value;		
	   
		rowParam['problem_description'] = encodeURI(encodeURI(problem_description));
		rowParam['r_completion'] = encodeURI(encodeURI(r_completion));
		rowParam['r_completion_time'] = encodeURI(encodeURI(r_completion_time));
	  
	  if(cicheck_no !=null && cicheck_no !=''){
		    rowParam['cicheck_no'] = cicheck_no;
		    rowParam['cinspection_no'] = cinspection_nos;
			rowParam['creator'] = encodeURI(encodeURI(creator));
			rowParam['create_date'] =create_date;
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;
			
	  }else{
		    rowParam['cinspection_no'] = cinspection_no;
		    rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['create_date'] ='<%=curDate%>';
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;
		  
	  }  				
	  
		rowParams[rowParams.length] = rowParam; 
		var rows=JSON.stringify(rowParams);	 
		saveFunc("BGP_CINSPECTION_CHECK",rows);	
		
		 var querySql1="";
	       var queryRet1=null;
	       var datas1 =null; 
	       querySql1 = "  select count(*) as num_sum ,cn.cinspection_no  from BGP_CINSPECTION_CHECK  cn  where cn.bsflag='0' and cn.cinspection_no='"+cinspection_no+"' group by   cn.cinspection_no ";
	       queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
	      
		 	if(queryRet1.returnCode=='0'){
		 	  datas1 = queryRet1.datas;	 
		 		if(datas1 != null && datas1 != ''){	  
		 			var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq'; 
		 				var submitStr = 'JCDP_TABLE_NAME=BGP_CONTRACTOR_INSPECTION&JCDP_TABLE_ID='+cinspection_no+'&number_problems='+datas1[0].num_sum  
		 				+'&updator=<%=userName%>&modifi_date=<%=curDate%>';
		 			   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));   
		 		}
		
		 	 }  
		 	
		top.frames('list').refreshData();	
		top.frames('list').loadDataDetail(cinspection_no);	 
		newClose();
 
}
 
  
	if(cicheck_no !=null){
		var querySql = "";
		var queryRet = null;
		var  datas =null;		
		
		querySql = " select tr.cicheck_no,tr.cinspection_no, tr.problem_description,tr.r_completion,tr.r_completion_time,tr.creator,tr.create_date,tr.bsflag  from BGP_CINSPECTION_CHECK tr    where tr.bsflag = '0' and tr.cicheck_no='"+ cicheck_no +"'";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null && datas!=""){				 
				 document.getElementsByName("cicheck_no")[0].value=datas[0].cicheck_no;  
	    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag; 
	  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
	    		 document.getElementsByName("creator")[0].value=datas[0].creator;	
	    		 document.getElementsByName("cinspection_no")[0].value=datas[0].cinspection_no;    	
	    		 
	    		    document.getElementsByName("problem_description")[0].value=datas[0].problem_description;
					document.getElementsByName("r_completion")[0].value=datas[0].r_completion;		
					document.getElementsByName("r_completion_time")[0].value=datas[0].r_completion_time;	
	    		 
			}					
		
	    	}		
		
	}
 
</script>
</html>