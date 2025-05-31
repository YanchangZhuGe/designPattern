<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.bgp.gms.service.rm.em.pojo.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ taglib uri="code" prefix="code"%> 

<%
String contextPath = request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String userName = (user==null)?"":user.getEmpId();
SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
String curDate = format.format(new Date());
 
 
%>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
<link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
<link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
<link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
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

<title>问题项整改验证</title>
</head>
<body  >
<form id="CheckForm" name="Form0" action="" method="post"  target="list">
<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="1000px">
 
	<tr  >
		<td  class="inquire_item4"><font color=red></font>&nbsp;单位：</td>
		<td class="inquire_form4">	 
  	  <input type="hidden" id="org_sub_id" name="org_sub_id" class="input_width" />
	  <input type="text" id="org_sub_id2" name="org_sub_id2" class="input_width" readonly="readonly"  />
		</td>
		<td class="inquire_item4">基层单位：</td> 
		<td class="inquire_form4">	 
		  <input type="hidden" id="second_org" name="second_org" class="input_width" />
    	  <input type="text" id="second_org2" name="second_org2" class="input_width" readonly="readonly"  />
    	  <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
    	  </td>
	</tr>
	<tr  >
	<td  class="inquire_item4"><font color=red></font>&nbsp;下属单位：</td>
	<td class="inquire_form4">	 
 	<input type="hidden" id="third_org" name="third_org" class="input_width" />
  	<input type="text" id="third_org2" name="third_org2" class="input_width"    readonly="readonly"/>
 	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
  	</td>
	<td class="inquire_item4">检查日期：</td> 
	<td class="inquire_form4">	 
	<input type="text" id="rectification_date" name="rectification_date" class="input_width"   readonly="readonly"/>
    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(rectification_date,tributton1);" />&nbsp;</td>	
	</tr>
	 
</table>
 
<table  width="1000px;" border="0" cellspacing="0" cellpadding="0"   >
<tr> 
  <td background="<%=contextPath%>/images/list_15.png" >
  <table width="1000px" border="0" cellspacing="0" cellpadding="0">
<tr align="right">

	<td class="ali_query"></td>
	<td class="ali_query"></td>
	<td class="ali_query"></td>
	<td class="ali_query"></td>
	<td class="ali_query">&nbsp;&nbsp;&nbsp;&nbsp;</td>
	<td class="ali_query">&nbsp;&nbsp;&nbsp;&nbsp;</td>
  <td class="ali_query">
  <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
 
  <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
  </td>
</tr>
</table>
</td>
 
</tr>
</table>
<table border="0"  width="1000px;"  cellspacing="0" cellpadding="0" class="tab_info"  id="equipmentTableInfo">
	<tr  >     
	<TD  width="50%">
<div style="width:500;overflow:hidden;overflow:auto"> 	
<table border="0"  width="50%"  cellspacing="0" cellpadding="0" class="tab_info"   id="equipmentTableInfo1">
	<tr  >  
	    <TD  class="bt_info_odd"  width="3%">选择</TD>
		<TD  class="bt_info_even" width="3%" >单位</TD>
		<TD  class="bt_info_odd"  width="8%"><font color=black>基层单位</font></TD>
		<TD class="bt_info_even"  width="8%"><font color=black>下属单位</font></TD>
		<TD  class="bt_info_odd"   width="5%"><font color=black>检查日期</font></TD>
		<TD class="bt_info_even"  width="5%" >整改期限
		<input type="hidden" id="lineNum" value="0"/>
		<div style="display:none">
		<textarea  style="width:500px;" id="contentTest" name="contentTest"   class="textarea" ></textarea> 
		</div>
		</TD>		 
	</tr>		 
</table>	</div>
<table width="100%" border="0" cellspacing="0" cellpadding="0"   >
<tr>
 
  <td background="<%=contextPath%>/images/list_15.png" >
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr align="right">
 
  <td  >
  <span  class="tj_btn"><a href="#" onclick="add(); "></a></span>
  
  </td>
</tr>
</table>
</td>
 
</tr>
</table>

</TD>
<TD  width="50%">
<div style="width:300;overflow-x:scroll;overflow-y:scroll;"> 	
<table border="0"  width="50%"  cellspacing="0" cellpadding="0" class="tab_info"  id="equipmentTableInfo2">
	<tr  >  
	    <TD  class="bt_info_odd"  width="3%">选择</TD>
		<TD  class="bt_info_even" width="3%" >单位</TD>
		<TD  class="bt_info_odd"  width="5%"><font color=black>基层单位</font></TD>
		<TD class="bt_info_even"  width="5%"><font color=black>下属单位</font></TD>
		<TD  class="bt_info_odd"   width="6%"><font color=black>检查日期</font></TD>
		<TD class="bt_info_even"  width="6%" >整改期限
		<input type="hidden" id="lineNum2" value="0"/>
		</TD>
	</tr>		 
</table>	</div>
<table width="100%" border="0" cellspacing="0" cellpadding="0"   >
<tr> 
  <td background="<%=contextPath%>/images/list_15.png" >
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr align="right">
   <td  >
  <span  class="tj_btn"><a href="#" onclick="add(); "></a></span>
  <span class="gb_btn"><a href="#" onclick="window.top.close()"></a></span>
  </td>
</tr>
</table>
</td> 
</tr>
</table>


</TD>
</tr>
</table>

<script type="text/javascript">
cruConfig.contextPath='<%=contextPath %>';

var querySql1="";
var queryRet1=null;
var datas1 =null;

 document.getElementById("lineNum").value="0";	
	   querySql1 = "  select  tr.questions_no	,tr.check_people,tr.check_date,tr.check_person,tr.problem,tr.rectification_requirements,tr.rectification_period ,tr.second_org,tr.third_org,ion.org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_LIST_QUESTIONS tr     join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   join comm_org_information ion     on ion.org_id = os1.org_id     where tr.bsflag = '0'   order by tr.modifi_date desc";
	   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
 
	   if(queryRet1.returnCode=='0'){
		  datas1 = queryRet1.datas;	
 
				if(datas1 != null && datas1 != ''){							 
				  						 
						for(var i = 0; i<datas1.length; i++){	 	
							var rowNum = document.getElementById("lineNum").value;								
							var tr = document.getElementById("equipmentTableInfo1").insertRow();							
							tr.align="center";							 
						  	if(rowNum % 2 == 1){  
						  		tr.className = "odd";
							}else{ 
								tr.className = "even";
							}							 
							tr.id = "row_" + rowNum + "_";  
							tr.insertCell().innerHTML = '<input type="checkbox"    id="questions_no'+ rowNum + '"   name="questions_no" value="'+datas1[i].questions_no+'" />';
							tr.insertCell().innerHTML =	datas1[i].org_name;
							tr.insertCell().innerHTML =	datas1[i].second_org_name;
							tr.insertCell().innerHTML =	datas1[i].third_org_name;
							
							tr.insertCell().innerHTML =	datas1[i].check_date;
							tr.insertCell().innerHTML =	datas1[i].rectification_period;
					
							var td = tr.insertCell(); 
							td.style.display = "";						 
							
							document.getElementById("lineNum").value = parseInt(rowNum) + 1;	
				       				      
						}
						
				}
	      	
		}
	   
	   
	   function add(){
			
		   var certificate = document.getElementsByName("questions_no");
			var certificate_no = "";
			for(var i=0;i<certificate.length;i++){
				if(certificate[i].checked==true){
					certificate_no = certificate_no + certificate[i].value + ",";
		
				}
			}
       

			 if(certificate_no !=null  || certificate_no !="'null'"){		 
					
					var tempIds = certificate_no.split(",");
					var id = "";
					for(var i=0;i<tempIds.length;i++){
						id = id + "'" + tempIds[i] + "'";
						if(i != tempIds.length -1){
							id = id + ",";
						
						}
					}
					certificate_no=id;				
					 querySql1 = "  select  tr.questions_no	,tr.check_people,tr.check_date,tr.check_person,tr.problem,tr.rectification_requirements,tr.rectification_period ,tr.second_org,tr.third_org,ion.org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_LIST_QUESTIONS tr     join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   join comm_org_information ion     on ion.org_id = os1.org_id     where tr.bsflag = '0'  and tr.questions_no in(" +certificate_no+ ")";
					   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
				 
					   if(queryRet1.returnCode=='0'){
						  datas1 = queryRet1.datas;	

								if(datas1 != null && datas1 != ''){							 
								  						 
										for(var i = 0; i<datas1.length; i++){	 	
											var rowNum = document.getElementById("lineNum2").value;								
											var tr = document.getElementById("equipmentTableInfo2").insertRow();							
											tr.align="center";							 
										  	if(rowNum % 2 == 1){  
										  		tr.className = "odd";
											}else{ 
												tr.className = "even";
											}							 
											tr.id = "row_" + rowNum + "_";  
											tr.insertCell().innerHTML = '<input type="checkbox"    id="questions_no'+ rowNum + '"   name="questions_no" value="'+datas1[i].problem+'" />';
											tr.insertCell().innerHTML =	datas1[i].org_name;
											tr.insertCell().innerHTML =	datas1[i].second_org_name;
											tr.insertCell().innerHTML =	datas1[i].third_org_name;								
											tr.insertCell().innerHTML =	datas1[i].check_date;
											tr.insertCell().innerHTML =	datas1[i].rectification_period;						
											var td = tr.insertCell(); 
											td.style.display = "";						 								
											document.getElementById("lineNum2").value = parseInt(rowNum) + 1;	
								       				      
										}
										
								}
					      	
						}
					   
			
			
			
			 }
			
			
		}
 
</script>
</form>
</body>
</html>