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
String emergency_no = request.getParameter("emergency_no");
String optionP=request.getParameter("optionP");
String inspection_no=request.getParameter("inspection_no");
String isProject =request.getParameter("isProject");  
String addTypes=request.getParameter("addTypes");
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

<title>应急物资台账右頁面</title>
</head>
<body   onload="check();">
<form id="CheckForm" name="Form0" action="" method="post"  target="list">
  
<div style="width:700;overflow-x:scroll;overflow-y:scroll;"> 	
<table border="0"  width="100%"  cellspacing="0" cellpadding="0" class="tab_info"  id="equipmentTableInfo">
	<tr  >  
	    <TD  class="bt_info_odd"  width="3%">选择</TD>
		<TD  class="bt_info_even" width="22%" >单位</TD>
		<TD  class="bt_info_odd"  width="18%"><font color=black>基层单位</font></TD>
 
		<TD  class="bt_info_odd"   width="18%"><font color=black>物资名称</font></TD>
		<TD class="bt_info_even"  width="13%" >物资类别
		<input type="hidden" id="lineNum" value="0"/>
		</TD>		
		<TD  class="bt_info_odd"   width="13%"><font color=black>购置时间</font></TD>
		<TD class="bt_info_even"  width="13%"><font color=black>验收时间</font></TD>
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
 var emergency_no='<%=emergency_no%>'; 
 var  optionP='<%=optionP%>';
 var inspection_no='<%=inspection_no%>';
 var isProject='<%=isProject%>';
 var addTypes='<%=addTypes%>';
 
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
 
 
 if(emergency_no !=null  || emergency_no !="'null'"){		 
		
		var tempIds = emergency_no.split(",");
		var id = "";
		for(var i=0;i<tempIds.length;i++){
			id = id + "'" + tempIds[i] + "'";
			if(i != tempIds.length -1){
				id = id + ",";
			
			}
		}
		emergency_no=id;	 
		var querySql1="";
		var queryRet1="";
		if(isProject=="1"){ 
			 querySql1 = " select tr.information_no as emergency_no,       dil.mdetail_no, decode(tr.supplies_category,'1','人身防护','2','医疗急救','3','消防救援','4','防洪防汛','5','应急照明','6','交通运输','7','通讯联络','8','检测监测','9','工程抢险','10','剪切破拆','11','电力抢修','12','其他') supplies_category,   ions.materials_no,       mn.wz_name as supplies_name,       tr.acquisition_time,       ions.acceptance_time,       decode(ion.org_abbreviation,'',oi1.org_abbreviation,ion.org_abbreviation) org_name,       oi1.org_abbreviation as second_org_name  from BGP_MATERIALS_DETAIL dil  left join BGP_MATERIALS_ACCEPTANCE ions    on ions.materials_no = dil.materials_no   and dil.bsflag = '0'  left join BGP_EMERGENCY_INFORMATION tr    on dil.emergency_no = tr.information_no   and tr.bsflag = '0'  left join gms_mat_recyclemat_info w    on tr.teammat_info_id = w.RECYCLEMAT_INFO   and w.bsflag = '0'  left join gms_mat_infomation mn    on w.wz_id = mn.wz_id   and mn.bsflag = '0'  left join comm_org_subjection os1    on w.org_subjection_id = os1.org_subjection_id   and os1.bsflag = '0'  left join comm_org_information oi1    on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  left join comm_org_subjection ose    on w.org_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id  where tr.bsflag = '0'   and ions.bsflag = '0'   and tr.information_no  in (" +emergency_no+ ") " +
				" union " +
		   		" select tr.emergency_no,       dil.mdetail_no,      decode(tr.supplies_category,'1','人身防护','2','医疗急救','3','消防救援','4','防洪防汛','5','应急照明','6','交通运输','7','通讯联络','8','检测监测','9','工程抢险','10','剪切破拆','11','电力抢修','12','其他') supplies_category,      ions.materials_no,     tr.supplies_name,       tr.acquisition_time,       ions.acceptance_time,       decode(ion.org_abbreviation,'',oi1.org_abbreviation,ion.org_abbreviation) org_name,       oi1.org_abbreviation as second_org_name  from BGP_MATERIALS_DETAIL dil  left join BGP_MATERIALS_ACCEPTANCE ions    on ions.materials_no = dil.materials_no   and dil.bsflag = '0'  join BGP_EMERGENCY_STANDBOOK tr    on dil.emergency_no = tr.emergency_no   and tr.bsflag = '0'  join comm_org_subjection os1    on tr.second_org = os1.org_subjection_id   and os1.bsflag = '0'  join comm_org_information oi1    on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  left join comm_org_subjection os2    on tr.third_org = os2.org_subjection_id   and os2.bsflag = '0'  left join comm_org_information oi2    on oi2.org_id = os2.org_id   and oi2.bsflag = '0'  left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  join comm_org_information ion    on ion.org_id = ose.org_id where tr.bsflag = '0'   and ions.bsflag = '0'   and tr.emergency_no  in (" +emergency_no+ ") " ;
		}else if (isProject=="2"){
		 querySql1 = " select tr.information_no as emergency_no,       dil.mdetail_no, decode(tr.supplies_category,'1','人身防护','2','医疗急救','3','消防救援','4','防洪防汛','5','应急照明','6','交通运输','7','通讯联络','8','检测监测','9','工程抢险','10','剪切破拆','11','电力抢修','12','其他') supplies_category,   ions.materials_no,       mn.wz_name as supplies_name,       tr.acquisition_time,       ions.acceptance_time,       decode(ion.org_abbreviation,'',oi1.org_abbreviation,ion.org_abbreviation) org_name,       oi1.org_abbreviation as second_org_name  from BGP_MATERIALS_DETAIL dil  left join BGP_MATERIALS_ACCEPTANCE ions    on ions.materials_no = dil.materials_no   and dil.bsflag = '0'  left join BGP_EMERGENCY_INFORMATION tr    on dil.emergency_no = tr.information_no   and tr.bsflag = '0'  left join gms_mat_teammat_info w    on tr.teammat_info_id = w.teammat_info_id   and w.bsflag = '0'  left join gms_mat_infomation mn    on w.wz_id = mn.wz_id   and mn.bsflag = '0'  left join comm_org_subjection os1    on w.org_subjection_id = os1.org_subjection_id   and os1.bsflag = '0'  left join comm_org_information oi1    on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  left join comm_org_subjection ose    on w.org_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id  where tr.bsflag = '0'   and ions.bsflag = '0'   and tr.information_no  in (" +emergency_no+ ") " +
			" union " +
	   		" select tr.emergency_no,       dil.mdetail_no,      decode(tr.supplies_category,'1','人身防护','2','医疗急救','3','消防救援','4','防洪防汛','5','应急照明','6','交通运输','7','通讯联络','8','检测监测','9','工程抢险','10','剪切破拆','11','电力抢修','12','其他') supplies_category,      ions.materials_no,     tr.supplies_name,       tr.acquisition_time,       ions.acceptance_time,       decode(ion.org_abbreviation,'',oi1.org_abbreviation,ion.org_abbreviation) org_name,       oi1.org_abbreviation as second_org_name  from BGP_MATERIALS_DETAIL dil  left join BGP_MATERIALS_ACCEPTANCE ions    on ions.materials_no = dil.materials_no   and dil.bsflag = '0'  join BGP_EMERGENCY_STANDBOOK tr    on dil.emergency_no = tr.emergency_no   and tr.bsflag = '0'  join comm_org_subjection os1    on tr.second_org = os1.org_subjection_id   and os1.bsflag = '0'  join comm_org_information oi1    on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  left join comm_org_subjection os2    on tr.third_org = os2.org_subjection_id   and os2.bsflag = '0'  left join comm_org_information oi2    on oi2.org_id = os2.org_id   and oi2.bsflag = '0'  left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  join comm_org_information ion    on ion.org_id = ose.org_id where tr.bsflag = '0'   and ions.bsflag = '0'   and tr.emergency_no  in (" +emergency_no+ ") " ;
		}
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
								tr.insertCell().innerHTML = '<input type="checkbox"    id="pk_id'+ rowNum + '"   name="pk_id" value="'+datas1[i].emergency_no+','+datas1[i].supplies_name+','+datas1[i].supplies_category+','+datas1[i].acquisition_time+','+datas1[i].acceptance_time+'" />';
								tr.insertCell().innerHTML =	'<input type="hidden" id="bsflag' + '_' + rowNum + '"  name="bsflag" value="0"/>'+datas1[i].org_name;
								tr.insertCell().innerHTML =	datas1[i].second_org_name;						
								tr.insertCell().innerHTML =	datas1[i].supplies_name;
								tr.insertCell().innerHTML =	datas1[i].supplies_category;  
								tr.insertCell().innerHTML =	datas1[i].acquisition_time;	
								tr.insertCell().innerHTML =	datas1[i].acceptance_time;
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
		var rowParams = new Array();  
		var certificate_no = "";
		if(inspection_no !=null && inspection_no !="null"){
			if(addTypes=="1"){   
				for(var i=0;i<certificate.length;i++){
					if(certificate[i].checked==true){
						var  params=certificate[i].value;
						var rowParam = {};	
						var emergency_nos = params.split(',')[0];
						var supplies_name = params.split(',')[1];
						var supplies_category = params.split(',')[2];
						var acquisition_time = params.split(',')[3];
						var acceptance_time = params.split(',')[4];
						var bsflag = document.getElementsByName("bsflag")[i].value; 
						// window.parent.opener.top.frames('list').addLine2('',inspection_no,emergency_nos,supplies_name,supplies_category,acquisition_time,acceptance_time,'','','','',bsflag);
				        //   window.parent.opener.top.frames('list').loadDataDetail(inspection_no);					
						// window.top.opener.addLine1('',inspection_no,emergency_nos,hidden_names,report_dates,'','','','',bsflag);
					 
							rowParam['supplies_name'] = encodeURI(encodeURI(supplies_name));
							rowParam['supplies_category'] = encodeURI(encodeURI(supplies_category));
							rowParam['acceptance_time'] = encodeURI(encodeURI(acceptance_time));
							rowParam['acuisition_time'] = encodeURI(encodeURI(acquisition_time));
			 
						    rowParam['idetail_no'] = "";
							rowParam['emergency_no'] = encodeURI(encodeURI(emergency_nos));			 		
						    rowParam['inspection_no'] = inspection_no;
							rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
							rowParam['create_date'] ='<%=curDate%>';	
							rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
							rowParam['modifi_date'] = '<%=curDate%>';		
							rowParam['bsflag'] = "0";	
							rowParams[rowParams.length] = rowParam; 
					}
				}
				
					var rows=JSON.stringify(rowParams);		 
					saveFunc("BGP_INSPECTION_DETAIL",rows);	
					window.parent.opener.top.frames('list').frames[2].loadDataDetail(inspection_no);
				    window.parent.opener.newClose();
				    window.parent.close();
				   
			}else  if(addTypes=="2"){ 				
				for(var i=0;i<certificate.length;i++){
					if(certificate[i].checked==true){
						var  params=certificate[i].value;
						var emergency_nos = params.split(',')[0];
						var supplies_name = params.split(',')[1];
						var supplies_category = params.split(',')[2];
						var acquisition_time = params.split(',')[3];
						var acceptance_time = params.split(',')[4];
						var bsflag = document.getElementsByName("bsflag")[i].value; 
						 window.parent.opener.top.frames('list').addLine2('',inspection_no,emergency_nos,supplies_name,supplies_category,acquisition_time,acceptance_time,'','','','',bsflag);
				          //   window.parent.opener.top.frames('list').loadDataDetail(inspection_no);					
						 // window.top.opener.addLine1('',inspection_no,emergency_nos,hidden_names,report_dates,'','','','',bsflag);
					}
				}
				 window.parent.opener.newClose();
				 window.parent.close();
				 
			}
			
			 
		}else { 
			for(var i=0;i<certificate.length;i++){
				if(certificate[i].checked==true){
					var  params=certificate[i].value;
					var emergency_nos = params.split(',')[0];
					var supplies_name = params.split(',')[1];
					var supplies_category = params.split(',')[2];
					var acquisition_time = params.split(',')[3];
					var acceptance_time = params.split(',')[4];
					var bsflag = document.getElementsByName("bsflag")[i].value;  
					 window.top.opener.addLine1('','',emergency_nos,supplies_name,supplies_category,acquisition_time,acceptance_time,'','','','',bsflag);
					 
				}
			}
	 		//  window.top.opener.document.getElementById("a_problem").value=certificate_no;	 	
			  //window.opener.selectTeam1();
	         window.top.close();
			
		}
		

	}
 
</script>
</body>
</html>