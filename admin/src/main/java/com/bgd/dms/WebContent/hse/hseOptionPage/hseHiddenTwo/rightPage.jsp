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
String pk_id = request.getParameter("pk_id");
String optionP=request.getParameter("optionP");
String paramS= request.getParameter("paramS");
 
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

<title>隐患信息</title>
</head>
<body  onload="check();">
<form id="CheckForm" name="Form0" action="" method="post"  target="list">
  
<div style="width:700;overflow-x:scroll;overflow-y:scroll;"> 	
<table border="0"  width="100%"  cellspacing="0" cellpadding="0" class="tab_info"  id="equipmentTableInfo">
	<tr  >  
		<TD  class="bt_info_odd"  width="4%"> </TD>
		<TD  class="bt_info_even" width="20%" >单位</TD>
		<TD  class="bt_info_odd"  width="15%"><font color=black>基层单位</font></TD>
		<TD class="bt_info_even"  width="15%"><font color=black>下属单位</font></TD>
		<TD  class="bt_info_odd"   width="12%"><font color=black>隐患描述</font></TD>
		<TD class="bt_info_even"  width="12%" >上报日期
		<input type="hidden" id="lineNum" value="0"/>
		</TD>		
		<TD  class="bt_info_odd"   width="3%">操作</TD>
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
</form>

<script type="text/javascript">
cruConfig.contextPath='<%=contextPath %>';
 var pk_id='<%=pk_id%>'; 
 var optionP='<%=optionP%>';
 var paramS='<%=paramS%>';
 var checked = false;
 function check(){
 	var chk = document.getElementsByName("pk_id");
 	for(var i = 0; i < chk.length; i++){ 
 		if(!checked){ 
 			chk[i].checked = true; 
 		}
 		else{
 			chk[i].checked = false;
 		}
 	} 
 	if(checked){
 		checked = false;
 	}
 	else{
 		checked = true;
 	}
 }
 
 if(pk_id !=null  || pk_id !="'null'"){		 
		
		var tempIds = pk_id.split(",");
		var id = "";
		for(var i=0;i<tempIds.length;i++){
			id = id + "'" + tempIds[i] + "'";
			if(i != tempIds.length -1){
				id = id + ",";
			
			}
		}
		pk_id=id;		 
		   querySql1 =  "  select case when length(tr.hidden_description)<= 25 then tr.hidden_description else concat(substr(tr.hidden_description,0,25),'...') end  hse_hidden_description,hdl.reward_state, decode(hdl.risk_levels,'1','低风险','2','中风险','3','高风险') risk_levels,decode(hdl.rectification_state,'1','已整改','2','未整改','3','正在整改')rectification_state,tr.hidden_no,tr.operation_post,tr.hidden_name,tr.identification_method,tr.hazard_big,tr.hazard_center,tr.whether_new,tr.recognition_people,  tr.report_date, tr.hidden_description  ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_HSE_HIDDEN_INFORMATION tr   left  join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left  join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   left join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   left join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'     left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0' left join comm_org_information ion    on ion.org_id = ose.org_id   left join BGP_HIDDEN_INFORMATION_DETAIL hdl  on hdl.hidden_no=tr.hidden_no and hdl.bsflag='0'  where tr.bsflag = '0'   and tr.hidden_no in(" +pk_id+ ")";
		   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
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
								tr.insertCell().innerHTML = '<input type="checkbox"    id="pk_id'+ rowNum + '"   name="pk_id" value="'+datas1[i].hidden_no+'" />';
								tr.insertCell().innerHTML =	'<input type="hidden" id="bsflag' + '_' + rowNum + '"  name="bsflag" value="0"/>'+datas1[i].org_name;
								tr.insertCell().innerHTML =	datas1[i].second_org_name;
								tr.insertCell().innerHTML =	datas1[i].third_org_name;							
								tr.insertCell().innerHTML =	datas1[i].hidden_name;
								tr.insertCell().innerHTML =	datas1[i].report_date;  
								var td = tr.insertCell(); 
								td.style.display = "";			
								td.innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/>'+'<img src="'+'<%=contextPath%>'+'/images//delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + tr.id + '\')"/>';
								document.getElementById("lineNum").value = parseInt(rowNum) + 1;	
					       				      
							}
							
					}
		      	
			}
		    
	 }
 
 function deleteLine(lineId){		
		var rowNum = lineId.split('_')[1];
		var line = document.getElementById(lineId);		 
		var bsflag = document.getElementsByName("bsflag_"+rowNum)[0].value;
		 document.getElementsByName("pk_id")[rowNum].checked=false;
		if(bsflag!=""){
			line.style.display = 'none';
			document.getElementsByName("bsflag_"+rowNum)[0].value = '1';
		}else{
			line.parentNode.removeChild(line);
		}	
	}

 
 function add(){ 
	   var certificate = document.getElementsByName("pk_id"); 
		var certificate_no = "";
 
			for(var i=0;i<certificate.length;i++){
				if(certificate[i].checked==true){
					certificate_no = certificate_no + certificate[i].value + ",";
				}
			}
			if(certificate_no==""){alert('请选择一条信息！');return;} 
			
		     window.open("<%=contextPath%>/hse/hseOptionPage/hseHiddenTwo/addAll.jsp?hiddenNo="+certificate_no+"&paramS="+paramS,'homeMain','height=600px,width=1024px,left=100px,top=50px,menubar=no,status=no,toolbar=no ', '');
		   //  window.top.close();
	 

	}
 
</script>
</body>
</html>