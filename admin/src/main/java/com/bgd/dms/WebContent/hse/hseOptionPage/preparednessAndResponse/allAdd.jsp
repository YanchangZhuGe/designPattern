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
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());	
	String orgSubId = request.getParameter("orgSubId");	 
	String projectInfoNo = user.getProjectInfoNo();
	if (orgSubId == null || orgSubId.equals("")){
		orgSubId = user.getOrgSubjectionId();
	}
    String emergencyNo ="";
	if(request.getParameter("emergencyNo") != null){
		emergencyNo=request.getParameter("emergencyNo");	    		
	}
    String paramS ="";
	if(request.getParameter("paramS") != null){
		paramS=request.getParameter("paramS");	    		
	}
 
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=8" /> 
<title>选择页面</title>
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
<body >
<form name="form" id="form"  method="post" action="" >
<div id="new_table_box" style="width:700px; height:475px;">
  <div id="new_table_box_content" style="width:668px; height:475px;">
    <div id="new_table_box_bg"   style="width:648px; height:420px; ">		 
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >    
	 		
	  <tr  id="trA" style="display:none;" >	       
	    <td class="inquire_item6"><font color="red">*</font>保管人：</td>
	    <td class="inquire_form6">
	    <input type="text" id="the_depository" name="the_depository" class="input_width" />
		<input type="hidden" id="project_no" name="project_no" value="" />
      	<input type="hidden" id="emergency_no" name="emergency_no"   />
	    </td>	   
      </tr>		
		<tr  id="trB" style="display:none;">
		 <td class="inquire_item6"><font color="red">*</font>物资类别：</td>
		    <td class="inquire_form6">
		    <select id="supplies_category" name="supplies_category" class="select_width">
		       <option value="" >请选择</option>
		       <option value="1" >人身防护</option>
		       <option value="2" >医疗急救</option>
		       <option value="3" >消防救援</option>
		       <option value="4" >防洪防汛</option>
		       <option value="5" >应急照明</option>
		       <option value="6" >交通运输</option>
		       <option value="7" >通讯联络</option>
		       <option value="8" >检测监测</option>
		       <option value="9" >工程抢险</option>
		       <option value="10" >剪切破拆</option>
		       <option value="11" >电力抢修</option>
		       <option value="12" >其他</option>
			</select> 
		    </td> 
		   
	  </tr>
		<tr  id="trC" style="display:none;">		 
		    <td class="inquire_item6"><font color="red">*</font>型号/规格：</td>					 
		    <td class="inquire_form6"> 
		    <input type="text" id="model_num" name="model_num" class="input_width"  />
			  </td>	
	  </tr>
 
	  <tr  id="trD" style="display:none;">
	    <td class="inquire_item6"><font color="red">*</font>购置时间：</td>
	    <td class="inquire_form6">
	    <input type="text" id="acquisition_time" name="acquisition_time" class="input_width"    readonly="readonly"/>
	    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acquisition_time,tributton1);" />&nbsp;</td>
	    </td>
	    	
	  </tr>					  
	  <tr id="trE" style="display:none;">	   
	    <td class="inquire_item6"><font color="red">*</font>有效期截止至：</td>
	    <td class="inquire_form6">
	    <input type="text" id="valid_until" name="valid_until" class="input_width"    readonly="readonly"/>
	    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(valid_until,tributton2);" />&nbsp;</td>
	    </td>		
	  </tr>					  
	 
	  <tr id="trF" style="display:none;">
	    <td class="inquire_item6"><font color="red">*</font>校验期截止至：</td>
	    <td class="inquire_form6">
	    <input type="text" id="check_period_until" name="check_period_until" class="input_width"    readonly="readonly"/>
	    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_period_until,tributton3);" />&nbsp;</td>
	    </td> 	
	  </tr>			
	  <tr id="trG" style="display:none;"   > 
	    <td class="inquire_item6"><font color="red">*</font>存放位置：</td>
	    <td class="inquire_form6">
	    <input type="text" id="storage_location" name="storage_location"    class="input_width"/>
	    </td>		
	  </tr>		
	</table>
 
</div>				 
		<div id="oper_div2" style="display:block;text-align:center; " >
		<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
		<span class="gb_btn"><a href="#" onclick="window.close()"></a></span>
		</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript"> 
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form'; 
var emergencyNo="<%=emergencyNo%>";
var projectInfoNo="<%=projectInfoNo%>";
var paramS="<%=paramS%>";
var tempIds = paramS.split(",");
var id = "";
for(var i=0;i<tempIds.length;i++){
	id =tempIds[i];
	if(id=="1"){
		 document.getElementById('trA').style.display=''; 
	}
	if(id=="2"){
		 document.getElementById('trB').style.display=''; 
		}
	if(id=="3"){
		 document.getElementById('trC').style.display=''; 
		}
	if(id=="4"){
		 document.getElementById('trD').style.display=''; 
	}
	if(id=="5"){
		 document.getElementById('trE').style.display=''; 
		}
	if(id=="6"){
		 document.getElementById('trF').style.display=''; 
		}
	if(id=="7"){
		 document.getElementById('trG').style.display=''; 
		}
}
 
function calMonthSelector(inputField,tributton)
{    
    Calendar.setup({
        inputField     :    inputField,   // id of the input field
        ifFormat       :    "%Y-%m",       // format of the input field
        align          :    "Br",
		button         :    tributton,
        onUpdate       :    null,
        weekNumbers    :    false,
		singleClick    :    false,
		step	       :	1
    });
}
 
function submitButton(){ 
	var supplies_category = document.getElementsByName("supplies_category")[0].value;		
	var model_num = document.getElementsByName("model_num")[0].value;			  
	var acquisition_time = document.getElementsByName("acquisition_time")[0].value;
	var valid_until = document.getElementsByName("valid_until")[0].value;			
	var check_period_until = document.getElementsByName("check_period_until")[0].value;			
	var storage_location = document.getElementsByName("storage_location")[0].value;
	var the_depository = document.getElementsByName("the_depository")[0].value;
 
	var emergencyNos = emergencyNo.split(",");
	var id = "";
	var lengthH=emergencyNos.length-1
	for(var i=0;i<lengthH;i++){
		id =emergencyNos[i];		 
		if(id!=""){
			 
       			var checkSql="select oi1.org_abbreviation as org_name,         w.org_subjection_id as second_org,         w.org_id as org_sub_id,         oi2.org_abbreviation as second_org_name,         w.teammat_info_id as emergency_no,         g.wz_name as supplies_name,         '' as supplies_category,         '' as supplies_category_s,         to_char('', 'yyyy-MM-dd') as acquisition_time,         '0' as bsflag    from gms_mat_infomation g   inner join gms_mat_teammat_info w      on g.wz_id = w.wz_id     and w.bsflag = '0'    left join comm_org_subjection os1      on w.org_id = os1.org_subjection_id     and os1.bsflag = '0'    left join comm_org_information oi1      on oi1.org_id = os1.org_id     and oi1.bsflag = '0'    left join BGP_EMERGENCY_INFORMATION ein      on ein.teammat_info_id = w.teammat_info_id    left join comm_org_subjection os2      on w.org_subjection_id = os2.org_subjection_id     and os2.bsflag = '0'    left join comm_org_information oi2      on oi2.org_id = os2.org_id     and oi2.bsflag = '0'   where g.coding_code_id like '45%'     and w.is_recyclemat = '1'     and ein.information_no is null  and w.teammat_info_id='"+id+"'";
    		   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(checkSql)));
    			var datas = queryRet.datas;
    			if(datas==null||datas==""){    			
    				var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';	       	
       				var submitStr = 'JCDP_TABLE_NAME=BGP_EMERGENCY_STANDBOOK&JCDP_TABLE_ID='+id +'&supplies_category='+supplies_category +'&model_num='+model_num +'&acquisition_time='+acquisition_time  +'&project_no='+projectInfoNo +'&bsflag=0'
       				+'&valid_until='+valid_until +'&check_period_until='+check_period_until +'&storage_location='+storage_location  +'&the_depository='+the_depository	+'&updator=<%=userName%>&modifi_date=<%=curDate%>';
       			   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		
        
           			var submitStrs = 'JCDP_TABLE_NAME=BGP_EMERGENCY_INFORMATION&JCDP_TABLE_ID='+id +'&supplies_category='+supplies_category +'&model_num='+model_num +'&acquisition_time='+acquisition_time  +'&project_no='+projectInfoNo +'&bsflag=0'
       				+'&valid_until='+valid_until +'&check_period_until='+check_period_until +'&storage_location='+storage_location  +'&the_depository='+the_depository	+'&updator=<%=userName%>&modifi_date=<%=curDate%>';
           		    syncRequest('Post',path,encodeURI(encodeURI(submitStrs)));  //保存主表信息	
           		    
    			}else{ 
    		 
	    				var rowParams = new Array(); 
	    				var rowParam = {};		
	        	     	rowParam['teammat_info_id'] =  id;	    			
	        	     	rowParam['information_no'] =  '';
	        	     	
	    				rowParam['supplies_category'] = encodeURI(encodeURI(supplies_category));
	    				rowParam['model_num'] = encodeURI(encodeURI(model_num));
	    				rowParam['acquisition_time'] = encodeURI(encodeURI(acquisition_time));
	    				rowParam['valid_until'] = encodeURI(encodeURI(valid_until));
	    				rowParam['check_period_until'] = encodeURI(encodeURI(check_period_until));
	    				rowParam['storage_location'] = encodeURI(encodeURI(storage_location));
	    				rowParam['the_depository'] = encodeURI(encodeURI(the_depository));
	    				
	    				rowParam['project_no'] = encodeURI(encodeURI(projectInfoNo));
	    				rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
	    				rowParam['create_date'] ='<%=curDate%>';		
	    				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
	    				rowParam['modifi_date'] = '<%=curDate%>';	
	    				rowParam['bsflag'] = '0';
	    			 			
	    			rowParams[rowParams.length] = rowParam; 
	    			var rows=JSON.stringify(rowParams);	 		 
	    			var path = getContextPath()+"/rad/addOrUpdateEntities.srq";  
	    			submitStr = "tableName=BGP_EMERGENCY_INFORMATION&"+"rowParams="+rows;
	    			if(submitStr == null) return;
	    	    	syncRequest('Post',path,submitStr);
    				 
    		    }
 
  
		}
			
	  }
	alert('保存成功！');
	/*
	window.top.opener.refreshData();*/
	  window.close();
}
 

</script>
</html>