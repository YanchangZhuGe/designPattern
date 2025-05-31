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
String assessment_no=request.getParameter("assessment_no");
 
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

<title>������Ϣ���</title>
</head>
<body  onload="refreshData();" >
<form id="CheckForm" name="Form0" action="" method="post"  target="list">
  
<div style="width:700;overflow-x:scroll;overflow-y:scroll;"> 	
<table border="0"  width="100%"  cellspacing="0" cellpadding="0" class="tab_info"   id="equipmentTableInfo">
	<tr>  
	    <TD  class="bt_info_odd"  width="4%">ѡ��</TD>
		<TD  class="bt_info_even" width="22%" >��λ</TD>
		<TD  class="bt_info_odd"  width="22%"><font color=black>���㵥λ</font></TD>
		<TD class="bt_info_even"  width="22%"><font color=black>������λ</font></TD>
		<TD  class="bt_info_odd"   width="22%"><font color=black>��������</font></TD>
		<TD class="bt_info_even"  width="6%" >�ϱ�����
		<input type="hidden" id="lineNum" value="0"/>
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

<script type="text/javascript">
cruConfig.contextPath='<%=contextPath %>';
var assessment_no='<%=assessment_no%>';
var querySql="";
var queryRet1=null;
var datas1 =null;

 document.getElementById("lineNum").value="0";	
 function refreshData(arrObj){
	   querySql = " select  tr.hidden_no,tr.operation_post,tr.hidden_name,tr.identification_method,tr.hazard_big,tr.hazard_center,tr.whether_new,tr.recognition_people,  tr.report_date,tr.risk_levels,  tr.rectification_state,tr.reward_state,tr.hidden_description  ,tr.second_org,tr.third_org,ion.org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_HIDDEN_INFORMATION tr     join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   join comm_org_information ion     on ion.org_id = os1.org_id     where tr.bsflag = '0'   and  tr.hidden_no not in (select dil.hidden_no  from BGP_ASSESSMENT_DETAIL dil left join  BGP_ASSESSMENT_INFORMATION ion on ion.ASSESSMENT_NO=dil.ASSESSMENT_NO and dil.bsflag='0' where ion.bsflag='0')  ";
		for(var key in arrObj) { 
			//alert(arrObj[key].label+arrObj[key].value);
			if(arrObj[key].value!=undefined && arrObj[key].value!='')
				if(arrObj[key].label =="report_date"){
					querySql += "and to_char(tr."+arrObj[key].label+",'yyyy-MM-dd')='"+arrObj[key].value+"' ";
				}else{
					querySql += "and tr."+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";					
				}
			
		}
		 var querySql1="   order by tr.modifi_date desc";
		 querySql=querySql+querySql1;
	   
	   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql)));
 
	   if(queryRet1.returnCode=='0'){
		  datas1 = queryRet1.datas;	
 
				if(datas1 != null && datas1 != ''){							 
				  						 
						for(var i = 0; i<datas1.length; i++){	 	
							var rowNum = document.getElementById("lineNum").value;								
							var tr = document.getElementById("equipmentTableInfo").insertRow();							
							tr.align="center";							 
						  	if(rowNum % 2 == 1){  
						  		tr.className = "odd";
							}else{ 
								tr.className = "even";
							}							 
							tr.id = "row_" + rowNum + "_";  
							tr.insertCell().innerHTML = '<input type="checkbox"    id="hidden_no'+ rowNum + '"   name="hidden_no" value="'+datas1[i].hidden_no+'" />';
							tr.insertCell().innerHTML =	datas1[i].org_name;
							tr.insertCell().innerHTML =	datas1[i].second_org_name;
							tr.insertCell().innerHTML =	datas1[i].third_org_name;							
							tr.insertCell().innerHTML =	datas1[i].hidden_name;
							tr.insertCell().innerHTML =	datas1[i].report_date;
					
							var td = tr.insertCell(); 
							td.style.display = "";						 
							
							document.getElementById("lineNum").value = parseInt(rowNum) + 1;	
				       				      
						}
						
				}
	      	
		}
 }   
 
 function deleteTableTr(tableID){
		var tb = document.getElementById(tableID);
	     var rowNum=tb.rows.length;

	     for (i=1;i<rowNum;i++)
	     {
	         tb.deleteRow(i);
	         rowNum=rowNum-1;
	         i=i-1;
	     }
	}	   
	   
	   function add(){
			
		   var certificate = document.getElementsByName("hidden_no");
			var certificate_no = "";
			for(var i=0;i<certificate.length;i++){
				if(certificate[i].checked==true){
					certificate_no = certificate_no + certificate[i].value + ",";
		
				}
			} 
		//	self.parent.frames["rightframe"].add();
        self.parent.frames["rightframe"].location="<%=contextPath %>/hse/hseOptionPage/hiddeniInformation/rightPage.jsp?hidden_no="+certificate_no+"&assessment_no="+assessment_no;

		}

	   function sucess(){

			var deviceCount = document.getElementById("lineNum").value;
			alert(deviceCount);
			var isCheck=true;
			for(var i=0;i<deviceCount;i++){
				if(document.getElementById("questions_no_"+i).checked == true){
					isCheck=false;
				}
			}
			if(isCheck){
				alert("��ѡ��һ����¼");
				return false;
			}else{
		 
				newClose();
				return true;
			}
			
		 
		}

 
</script>
</form>
</body>
</html>