<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.bgp.mcs.service.hse.service.pojo.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ taglib uri="code" prefix="code"%> 
<%@ taglib prefix="auth" uri="auth"%>

<%
String contextPath = request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String userName = (user==null)?"":user.getEmpId();
SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
String curDate = format.format(new Date());

String id="";
if(request.getParameter("id") != null){
	id=request.getParameter("id");		
}

 
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


<title>人员培训计划添加</title>
</head>
<body  style="overflow-y:auto" > 
<form id="CheckForm" name="Form0" action="" method="post"  target="list">
<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
	<tr  >
	<td  align="center" colspan="5"><font color=black size="4px">不符合通知单</font></td>
	</tr>
	<tr   >
	<td  align="right"><font color=red></font>&nbsp;被检查/审核单位：</td>
	<td >
	<input type="hidden" id="orderNo" name="orderNo" value=""/>
	<input type="hidden"     id="auditUnit" value=""  name="auditUnit" class='input_width' readonly="readonly"></input>	
	<input type="text"    id="orgName"   value=""    name="orgName" class='input_width' readonly="readonly"></input>	
	  <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
	</td>
	<td  align="right"> 检查/审核日期：</td> 
	<td > <input type="text" id="auditDate" name="auditDate" class="input_width"   value=""    readonly="readonly"/>
    <img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(auditDate,tributton1);" />&nbsp;</td>	
    </tr>


	<tr  >
	  <td height="21" colspan="4" >  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; 请你单位对以下存在的不符合，逐条进行原因分析，制定纠正措施和预防措施，并将原因分析、纠正和预防措施、 验证结果同本通知单于：	   </td>
    </tr>
	<tr   >
	  <td colspan="4"  >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;<input type="text" id="amonth" name="amonth" style="width:50px;"  value=""  />月
	    <input type="text" id="aday" name="aday" value=""  style="width:50px;"/>
	    日前报
        <input type="text" id="reporter" name="reporter" value=""    style="width:250px;" />
        。以上问题委托 
        <input type="text" id="client" name="client" value=""   style="width:250px;" />
      进行跟踪验证。</td>
    </tr>
	<tr  align="right" >
	  <td height="21" >验证情况：</td>
	  <td colspan="3"  ><input type="text" id="validationSituation" name="validationSituation"  value=""  class="input_width" style="width:800px;" /></td>
    </tr>
	
	<tr   >
 
	<td align="right" ><font color=red></font>&nbsp;验证人：</td>
	<td ><input type="text" id="verifierSignature" name="verifierSignature" value="" /></td>
 
 	<td  align="right"> 验证日期：</td> 
	<td > <input type="text" id="verifyDate" name="verifyDate" class="input_width"  value=""  readonly="readonly"/>
    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(verifyDate,tributton2);" />&nbsp;</td>	
    </tr>
	<tr  >
	
		<td align="right" ><font color=red></font>&nbsp;审核/检查组成员：</td>
		<td >
		<input type="TEXT" id="inspectionTeam" name="inspectionTeam" value=""  class='input_width'/>		</td>
		<td align="right" >被检查/审核单位负责人：</td> 
		<td >
		<input type="TEXT" value=""   id="personCharge" name="personCharge" class='input_width' ></input>		</td>	
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0"   >
<tr>
  <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
  <td background="<%=contextPath%>/images/list_15.png">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr align="right">
  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
 
  <td> 
 
    </td>
</tr>
</table>
</td>
  <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
</tr>
</table>
 
<table border="0"  width="100%"  cellspacing="0" cellpadding="0" class="tab_info"   id="equipmentTableInfo">
	<tr  > 
	     <TD  class="bt_info_odd"  width="5%">选择</TD>
	    <TD  class="bt_info_even"  width="5%">序号</TD>
		<TD  class="bt_info_odd" width="15%" >不符合描述</TD>
		<TD  class="bt_info_even" width="15%" >不符合条款号</TD>
		<TD  class="bt_info_odd"  width="15%">整改建议/要求</TD>
		<TD class="bt_info_even"  width="15%">整改期限</TD>		 
		<TD  class="bt_info_odd"  width="15%">关闭情况</TD>
		<input type="hidden" id="equipmentSize" name="equipmentSize"   value="" />
		<input type="hidden" id="hidDetailId" name="hidDetailId" value=""/>
		<input type="hidden" id="deleteRowFlag" name="deleteRowFlag" value="" />
		<input type="hidden" id="lineNum" value="0"/>
		</TD>
 
	</tr>
		 
</table>	 
 
<table width="100%" border="0" cellspacing="0" cellpadding="0"   >
<tr>
 
  <td background="<%=contextPath%>/images/list_15.png" >
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr align="center">
 
  <td  >
  <span class="gb_btn"><a href="#" onclick="window.close();"></a></span>
  </td>
</tr>
</table>
</td>
 
</tr>
</table>

</form>
</body>

<script type="text/javascript">
cruConfig.contextPath='<%=contextPath %>';
 
 var ids="<%=id%>";

function sucess(i) {

	ids = getSelIds('chx_entity_id_'+i);
 
    if(ids==''){ alert("请先选中一条记录!");
     return;
    }  
    
   window.opener.document.getElementById("paramsName").value=ids.split(',')[0];
   window.opener.document.getElementById("paramsNum").value=ids.split(',')[1];
   window.opener.document.getElementById("detilNo").value=ids.split(',')[2];
　   window.opener.changeTest();
   window.close();
}
 
	if(ids !=null){
		var querySql = "";
		var queryRet = null;
		var  datas =null;		
 
			querySql = " select   ion.org_name, bn.verifier_signature, bn.order_no,bn.audit_unit,bn.audit_date ,bn.amonth,bn.aday,bn.reporter,bn.client,bn.validation_situation,bn.verify_date,bn.inspection_team,bn.person_charge,bn.creator,bn.create_date,bn.updator,bn.modifi_date,bn.bsflag from  BGP_NOACCORDWITH_ORDER  bn  join comm_org_subjection os1     on bn.audit_unit = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information ion     on ion.org_id = os1.org_id    where bn.bsflag='0' and bn.order_no='"+ids+"'";			 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){			 			   
		              document.getElementsByName("auditUnit")[0].value=datas[0].audit_date; 
		    		  document.getElementsByName("orgName")[0].value=datas[0].org_name; 	 		    	      
		    		  document.getElementsByName("verifierSignature")[0].value=datas[0].verifier_signature;
		     		  document.getElementsByName("orderNo")[0].value=datas[0].order_no;
		    		  document.getElementsByName("auditDate")[0].value=datas[0].audit_date;		
		    		  document.getElementsByName("amonth")[0].value=datas[0].amonth;			
		    		  document.getElementsByName("aday")[0].value=datas[0].aday;			
		    		  document.getElementsByName("reporter")[0].value=datas[0].reporter;
		    	      document.getElementsByName("client")[0].value=datas[0].client;
		    		  document.getElementsByName("validationSituation")[0].value=datas[0].validation_situation;	  		    		  
		    		  document.getElementsByName("verifyDate")[0].value=datas[0].verify_date;			
		    		  document.getElementsByName("inspectionTeam")[0].value=datas[0].inspection_team;			
		    		  document.getElementsByName("personCharge")[0].value=datas[0].person_charge;
	 
				}					
			
		    	}		
		var querySql1="";
		var queryRet1=null;
		var datas1 =null;
	 
		 document.getElementById("lineNum").value="0";	
			   querySql1 = " select order_detail_no,order_no,no_conformity,no_conform_num,suggestions,period,creator,create_date,updator,modifi_date,bsflag,spare1  from  BGP_HSE_ORDER_DETAIL  where bsflag='0' and order_no='" +ids+ "'  order by modifi_date desc";
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
									tr.insertCell().innerHTML = '<input type="radio"    id="chx_entity_id' + '_' + rowNum + '"  onclick="sucess('+rowNum+')"  name="chx_entity_id' + '_' + rowNum + '" value="'+datas1[i].no_conformity+','+datas1[i].no_conform_num+','+datas1[i].order_detail_no+'" />';
									tr.insertCell().innerHTML = parseInt(rowNum) + 1;												
									tr.insertCell().innerHTML = '<input type="hidden"  name="order_detail_no' + '_' + rowNum + '" value="'+datas1[i].order_detail_no+'"/>'+'<input type="text" style="width:260px;" class="input_width" name="no_conformity' + '_' + rowNum + '" value="'+datas1[i].no_conformity+'" />';
									tr.insertCell().innerHTML = '<input type="text" style="width:180px;" class="input_width" name="no_conform_num' + '_' + rowNum + '" value="'+datas1[i].no_conform_num+'" />';
									tr.insertCell().innerHTML = '<input type="text" style="width:150px;" class="input_width" name="suggestions' + '_' + rowNum + '" value="'+datas1[i].suggestions+'" />';		
						 
									tr.insertCell().innerHTML = '<input type="text" style="width:150px;" class="input_width" name="period' + '_' + rowNum + '" value="'+datas1[i].period+'" />';
									tr.insertCell().innerHTML = '<input type="text" style="width:150px;" class="input_width" name="spare1' + '_' + rowNum + '" value="'+datas1[i].spare1+'" />';
									
									var td = tr.insertCell(); 
									td.style.display = "";						 
									
									document.getElementById("lineNum").value = parseInt(rowNum) + 1;	
						       				      
								}
								
						}
			       }	
 
	 

	}
	
 

</script>
</html>