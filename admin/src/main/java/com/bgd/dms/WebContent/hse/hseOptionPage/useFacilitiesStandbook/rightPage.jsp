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
String usefacilities_no=request.getParameter("usefacilities_no");
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

<title>设备设施台账右頁面</title>
</head>
<body  onload="check();" >
<form id="CheckForm" name="Form0" action="" method="post"  target="list">
  
<div style="width:300;overflow-x:scroll;overflow-y:scroll;"> 	
<table border="0"  width="100%"  cellspacing="0" cellpadding="0" class="tab_info"  id="equipmentTableInfo">
	<tr  >  
		<TD  class="bt_info_odd"  width="4%">选择</TD>
		<TD  class="bt_info_even" width="20%" >单位</TD>
		<TD  class="bt_info_odd"  width="15%">基层单位</TD>
		<TD class="bt_info_even"  width="15%">设备设施名称</TD>
		<TD  class="bt_info_odd"   width="12%">规格型号</TD>
		<TD class="bt_info_even"  width="12%" >出厂日期
		<input type="hidden" id="lineNum" value="0"/>
		</TD>		
		<TD  class="bt_info_odd"   width="10%">设施类别一</TD>
		<TD class="bt_info_even"  width="10%">设施类别二</TD>
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
 var  optionP='<%=optionP%>';
 var usefacilities_no='<%=usefacilities_no%>';
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
		   querySql1 =  "  select t.dev_acc_id as pk_id, (case when t.owning_sub_id like 'C105001005%' then '塔里木物探处' else (case when t.owning_sub_id like 'C105001002%' then '新疆物探处'else(case when t.owning_sub_id like 'C105001003%' then '吐哈物探处'else(case when t.owning_sub_id like 'C105001004%' then '青海物探处'else(case when t.owning_sub_id like 'C105005004%' then '长庆物探处'else(case when t.owning_sub_id like 'C105005000%' then '华北物探处'else(case when t.owning_sub_id like 'C105005001%' then '新兴物探开发处'else(case when t.owning_sub_id like 'C105007%' then '大港物探处'else(case when t.owning_sub_id like 'C105063%' then '辽河物探处'else(case when t.owning_sub_id like 'C105006%' then '装备服务处'else (case when t.owning_sub_id like 'C105002%' then '国际勘探事业部'else (case when t.owning_sub_id like 'C105003%' then '研究院'else (case when t.owning_sub_id like 'C105008%' then '综合物化处'else (case when t.owning_sub_id like 'C105015%' then '井中地震中心'  else (case when t.owning_sub_id like 'C105017%' then '矿区服务事业部' else '' end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) as org_name , (select org_abbreviation  from comm_org_information org  where t.owning_org_id = org.org_id) as second_org_name,t.dev_name as facilities_name,t.dev_model as specifications, (select coding_name  from comm_coding_sort_detail c  where t.using_stat = c.coding_code_id) as using_stat_desc,  (select coding_name  from comm_coding_sort_detail c  where t.tech_stat = c.coding_code_id) as tech_stat_desc,t.producting_date as release_date,t.license_num as paizhaohao,(select coding_name  from comm_coding_sort_detail c  where et.equipment_one = c.coding_code_id) as equipment_one,   (select coding_name  from comm_coding_sort_detail c  where et.equipment_two = c.coding_code_id) as equipment_two ,'1'spare1,et.eq_id  from GMS_DEVICE_ACCOUNT t left join gms_device_account_equipment et on t.dev_acc_id=et.dev_acc_id  where t.bsflag = '0'  and t.dev_type like 'S08%' and substr(t.dev_type,2,4)!='0809' and substr(t.dev_type,2,4)!='0808'   and t.dev_acc_id in(" +pk_id+ ") "
			    +" union "+
			    "  select  tr.facilities_no as pk_id,ion.org_abbreviation as org_name,  oi1.org_abbreviation as second_org_name,tr.facilities_name,tr.specifications,  (select coding_name  from comm_coding_sort_detail c  where tr.use_situation = c.coding_code_id) as using_stat_desc,  (select coding_name  from comm_coding_sort_detail c  where tr.technical_conditions = c.coding_code_id) as tech_stat_desc,   tr.release_date,tr.paizhaohao,(select coding_name  from comm_coding_sort_detail c  where tr.equipment_one = c.coding_code_id) as equipment_one,   (select coding_name  from comm_coding_sort_detail c  where tr.equipment_two = c.coding_code_id) as equipment_two ,tr.spare1 ,tr.creator as eq_id  from BGP_FACILITIES_STANDBOOK tr     join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0' left   join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'  left   join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'    left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  join comm_org_information ion    on ion.org_id = ose.org_id    where tr.bsflag = '0'   and tr.facilities_no in(" +pk_id+ ")";
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
								tr.insertCell().innerHTML = '<input type="checkbox"    id="pk_id'+ rowNum + '"   name="pk_id" value="'+datas1[i].pk_id+','+datas1[i].facilities_name+','+datas1[i].specifications+','+datas1[i].tech_stat_desc+','+datas1[i].using_stat_desc+','+datas1[i].release_date+','+datas1[i].paizhaohao+','+datas1[i].equipment_one+','+datas1[i].equipment_two+'" />';
								tr.insertCell().innerHTML =	'<input type="hidden" id="bsflag' + '_' + rowNum + '"  name="bsflag" value="0"/>'+datas1[i].org_name;
								tr.insertCell().innerHTML =	datas1[i].second_org_name;
								tr.insertCell().innerHTML =	datas1[i].facilities_name;							
								tr.insertCell().innerHTML =	datas1[i].specifications;
								tr.insertCell().innerHTML =	datas1[i].release_date;  
								tr.insertCell().innerHTML =	datas1[i].equipment_one;
								tr.insertCell().innerHTML =	datas1[i].equipment_two;	 
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
		var rowParams = new Array();  
		if(usefacilities_no !=null && usefacilities_no !=''){
			if(addTypes=="1"){ 
					for(var i=0;i<certificate.length;i++){ 
						if(certificate[i].checked==true){
							var  params=certificate[i].value; 
							var rowParam = {};	
							var pk_ids = params.split(',')[0];
							var facilities_name = params.split(',')[1];
							var specifications = params.split(',')[2];
							var tech_stat_desc = params.split(',')[3]; 
							var using_stat_desc = params.split(',')[4];
							var release_date = params.split(',')[5];
							var paizhaohao = params.split(',')[6];
							var equipment_one = params.split(',')[7];
							var equipment_two = params.split(',')[8];
							
							var bsflag = document.getElementsByName("bsflag")[i].value;
	//						window.parent.opener.top.frames('list').loadDataDetail(usefacilities_no);
	//						window.parent.opener.top.frames('list').addLine1('',usefacilities_no,pk_ids,facilities_name,specifications,tech_stat_desc,using_stat_desc,release_date,paizhaohao,equipment_one,equipment_two,'','','','',bsflag);
					 
						 				rowParam['facilities_name'] = encodeURI(encodeURI(facilities_name));
										rowParam['specifications'] = encodeURI(encodeURI(specifications));
										rowParam['technical_conditions'] = encodeURI(encodeURI(tech_stat_desc));
										rowParam['use_situation'] = encodeURI(encodeURI(using_stat_desc));
										rowParam['release_date'] = encodeURI(encodeURI(release_date));
										rowParam['paizhaohao'] = encodeURI(encodeURI(paizhaohao));
										rowParam['equipment_one'] = encodeURI(encodeURI(equipment_one));
										rowParam['equipment_two'] = encodeURI(encodeURI(equipment_two)); 
										
										rowParam['facilities_no'] = encodeURI(encodeURI(pk_ids)); 
									    rowParam['udetail_no'] = "";
									    rowParam['usefacilities_no'] = usefacilities_no;
									    rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
		 								rowParam['create_date'] ='<%=curDate%>';
										rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
										rowParam['modifi_date'] = '<%=curDate%>';		
										rowParam['bsflag'] = "0";	 
										rowParams[rowParams.length] = rowParam; 
		 
							//debugger;
							// window.parent.opener.top.frames('list').addLine1
							 //window.parent.opener.top.frames('list').loadDataDetail(usefacilities_no);					
							 // window.top.opener.addLine1('',usefacilities_no,pk_ids,hidden_names,report_dates,'','','','',bsflag);
				 
				    	} 
			    	}
					var rows=JSON.stringify(rowParams);		 
					saveFunc("BGP_USEFACILITIES_DETAIL",rows);	
					window.parent.opener.top.frames('list').loadDataDetail(usefacilities_no);
					window.parent.opener.newClose();
					window.parent.close();
			 
			}else if (addTypes=="2"){
				for(var i=0;i<certificate.length;i++){
					if(certificate[i].checked==true){
						var  params=certificate[i].value;
						var pk_ids = params.split(',')[0];
						var facilities_name = params.split(',')[1];
						var specifications = params.split(',')[2];
						var tech_stat_desc = params.split(',')[3]; 
						var using_stat_desc = params.split(',')[4];
						var release_date = params.split(',')[5];
						var paizhaohao = params.split(',')[6];
						var equipment_one = params.split(',')[7];
						var equipment_two = params.split(',')[8];
						
						var bsflag = document.getElementsByName("bsflag")[i].value;  
						 window.top.opener.addLine1('','',pk_ids,facilities_name,specifications,tech_stat_desc,using_stat_desc,release_date,paizhaohao,equipment_one,equipment_two,'','','','',bsflag);
						 
					}
				}	 
		         window.top.close();
				
				
			}
			 
		}else {  
			for(var i=0;i<certificate.length;i++){
				if(certificate[i].checked==true){
					var  params=certificate[i].value;
					var pk_ids = params.split(',')[0];
					var facilities_name = params.split(',')[1];
					var specifications = params.split(',')[2];
					var tech_stat_desc = params.split(',')[3]; 
					var using_stat_desc = params.split(',')[4];
					var release_date = params.split(',')[5];
					var paizhaohao = params.split(',')[6];
					var equipment_one = params.split(',')[7];
					var equipment_two = params.split(',')[8];
					
					var bsflag = document.getElementsByName("bsflag")[i].value;  
					 window.top.opener.addLine1('','',pk_ids,facilities_name,specifications,tech_stat_desc,using_stat_desc,release_date,paizhaohao,equipment_one,equipment_two,'','','','',bsflag);
					 
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