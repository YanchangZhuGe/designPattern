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
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	String orgSubId = request.getParameter("orgSubId");	 
	if (orgSubId == null || orgSubId.equals("")){
		orgSubId = user.getOrgSubjectionId();
	}
	
	String emergency_no="";
	if(request.getParameter("emergency_no") != null){
		emergency_no=request.getParameter("emergency_no");	
		
	}
	  String projectInfoNo ="";
  	if(request.getParameter("projectInfoNo") != null){
  		projectInfoNo=request.getParameter("projectInfoNo");	    		
  	}
  	
	String isProject = request.getParameter("isProject");
	if(isProject==null||isProject.equals("")){
		isProject = resultMsg.getValue("isProject");
	}
	

%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>应急物资台账</title>
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
<body  onload="queryOrg()">
<form name="form" id="form"  method="post" action="" >
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
				    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >
				    <tr>			 				   
				    <td class="inquire_item6">单位：</td>
		        	<td class="inquire_form6">				     
			      	<input type="text" id="org_sub_id3" name="org_sub_id3" class="input_width"      readonly="readonly" style="color:gray"   />	
		        	</td>
		          	<td class="inquire_item6">基层单位：</td>
		        	<td class="inquire_form6">
			    	  <input type="text" id="second_org3" name="second_org3" class="input_width"    readonly="readonly" style="color:gray"     />	
		        	</td>
			     </tr>	
				  <tr>							   
			      	 <td class="inquire_item6">物资名称：</td>
				      	<td class="inquire_form6">
				      	<input type="hidden" id="bsflag3" name="bsflag3" value="0" />
				      	<input type="hidden" id="create_date3" name="create_date3" value="" />
				      	<input type="hidden" id="creator3" name="creator3" value="" />
				      	<input type="hidden" id="emergency_no3" name="emergency_no3"   />	
				    	<input type="hidden" id="project_no" name="project_no" value="" />
				    	<input type="hidden" id="teammat_info_id" name="teammat_info_id"   /> 	
				      	<input type="hidden" id="information_no" name="information_no"   /> 		 
					    <input type="text" id="supplies_name3" name="supplies_name3" class="input_width"   readonly="readonly" style="color:gray" />
					   </td>
					   <td class="inquire_item6">	数量：</td>
					    <td class="inquire_form6"><input type="text" id="quantity3" name="quantity3"    class="input_width"   readonly="readonly" style="color:gray"  /></td>
					   
				  </tr>					  
					<tr>
					   <td class="inquire_item6">计量单位：</td>
				        <td class="inquire_form6"><input type="text" id="unit_measurement3" name="unit_measurement3"    readonly="readonly" style="color:gray"    class="input_width"/></td>
				    
					    <td class="inquire_item6"><font color="red">*</font>保管人：</td>
					    <td class="inquire_form6">
					    <input type="text" id="the_depository3" name="the_depository3" class="input_width" />
					    </td> 
				  </tr>
					
				  <tr>	 
				  <td class="inquire_item6"><font color="red">*</font>物资类别：</td>
				    <td class="inquire_form6">
				    <select id="supplies_category3" name="supplies_category3" class="select_width">
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
				    <td class="inquire_item6">型号/规格：</td>					 
				    <td class="inquire_form6"> 
				    <input type="text" id="model_num3" name="model_num3" class="input_width"  />
				    </td>	
				    
				  </tr>	
				  <tr>
				    <td class="inquire_item6"><font color="red">*</font>购置时间：</td>
				    <td class="inquire_form6">
				    <input type="text" id="acquisition_time3" name="acquisition_time3" class="input_width"    readonly="readonly"/>
				    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton5" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acquisition_time3,tributton5);" />&nbsp;</td>
				    </td>
				    <td class="inquire_item6">有效期截止至：</td>
				    <td class="inquire_form6">
				    <input type="text" id="valid_until3" name="valid_until3" class="input_width"    readonly="readonly"/>
				    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(valid_until3,tributton4);" />&nbsp;</td>
				    </td>		
				  </tr>					  
				 
				  <tr>
				    <td class="inquire_item6">校验期截止至：</td>
				    <td class="inquire_form6">
				    <input type="text" id="check_period_until3" name="check_period_until3" class="input_width"    readonly="readonly"/>
				    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton6" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_period_until3,tributton6);" />&nbsp;</td>
				    </td>
				    <td class="inquire_item6"><font color="red">*</font>存放位置：</td>
				    <td class="inquire_form6">
				    <input type="text" id="storage_location3" name="storage_location3"    class="input_width"/>
				    </td>		
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
 var emergency_no='<%=emergency_no%>';
 var projectInfoNo='<%=projectInfoNo%>';
//键盘上只有删除键，和左右键好用
 function noEdit(event){
 	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
 		return true;
 	}else{
 		return false;
 	}
 }

 	function queryOrg(){
 		if(emergency_no!=null && emergency_no!=""){
 		 	
 		}else{
	 		retObj = jcdpCallService("HseSrv", "queryOrg", "");
	 		if(retObj.flag=="true"){
	 			var len = retObj.list.length;
	 			if(len>0){
	 				document.getElementById("org_sub_id").value=retObj.list[0].orgSubId;
	 				document.getElementById("org_sub_id2").value=retObj.list[0].orgAbbreviation;
	 			}
	 			if(len>1){
	 				document.getElementById("second_org").value=retObj.list[1].orgSubId;
	 				document.getElementById("second_org2").value=retObj.list[1].orgAbbreviation;
	 			}
	 			if(len>2){
	 				document.getElementById("third_org").value=retObj.list[2].orgSubId;
	 				document.getElementById("third_org2").value=retObj.list[2].orgAbbreviation;
	 			}
	 		}
 		}
 	}
 	
 	function checkJudge1(){  
		var supplies_category = document.getElementsByName("supplies_category3")[0].value;		 	  
		var acquisition_time = document.getElementsByName("acquisition_time3")[0].value; 	
		var storage_location = document.getElementsByName("storage_location3")[0].value;
		var the_depository = document.getElementsByName("the_depository3")[0].value;
  
 		if(supplies_category==""){
 			alert("物资类别不能为空，请选择！");
 			return true;
 		} 
  
		if(acquisition_time==""){
 			alert("购置时间不能为空，请填写！");
 			return true;
 		}
		if(storage_location==""){
 			alert("存放位置不能为空，请填写！");
 			return true;
 		}
		if(the_depository==""){
 			alert("保管人不能为空，请填写！");
 			return true;
 		}
		 
 		return false;
 	}
 	
 	
 	
function submitButton(){ 
	if(checkJudge1()){
		return;
	}
	    var rowParams = new Array(); 
		var rowParam = {};
		    var emergency_no = document.getElementsByName("emergency_no3")[0].value;	 
		    var project_no = document.getElementsByName("project_no")[0].value;	
		
		    var teammat_info_id = document.getElementsByName("teammat_info_id")[0].value;
		    var information_no = document.getElementsByName("information_no")[0].value;
			var supplies_category = document.getElementsByName("supplies_category3")[0].value;		
			var model_num = document.getElementsByName("model_num3")[0].value;			  
			var acquisition_time = document.getElementsByName("acquisition_time3")[0].value;
			var valid_until = document.getElementsByName("valid_until3")[0].value;			
			var check_period_until = document.getElementsByName("check_period_until3")[0].value;			
			var storage_location = document.getElementsByName("storage_location3")[0].value;
			var the_depository = document.getElementsByName("the_depository3")[0].value;
				 
		if(check_period_until ==""){
			if(valid_until ==""){
				alert('校验期截日期为空时，有效期截日期不能为空！');return;
			}
		}	 
		if(valid_until ==""){
			if(check_period_until ==""){
				alert('有效期截日期为空时，校验期截日期不能为空！');return;
			}
		}
 
		rowParam['supplies_category'] = encodeURI(encodeURI(supplies_category)); 
		rowParam['model_num'] =encodeURI(encodeURI(model_num));  
		rowParam['acquisition_time'] = encodeURI(encodeURI(acquisition_time)); 
		rowParam['valid_until'] =encodeURI(encodeURI(valid_until));	 
		rowParam['check_period_until'] = encodeURI(encodeURI(check_period_until));
		rowParam['storage_location'] = encodeURI(encodeURI(storage_location)); 
		rowParam['the_depository'] =encodeURI(encodeURI(the_depository));	
 
		  if(project_no !=null && project_no !='' ){
				rowParam['project_no'] =project_no;	
			}else{
				rowParam['project_no'] ='<%=projectInfoNo%>';
			}
            rowParam['teammat_info_id'] = teammat_info_id;
		    rowParam['information_no'] = information_no; 
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = '0';
 
		rowParams[rowParams.length] = rowParam; 
		var rows=JSON.stringify(rowParams);	 
		saveFunc("BGP_EMERGENCY_INFORMATION",rows);	
		top.frames('list').frames[0].refreshData();	
		newClose();
  
}
 
function selectOrg(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
    	document.getElementById("org_sub_id").value = teamInfo.fkValue;
        document.getElementById("org_sub_id2").value = teamInfo.value;
    }
}

function selectOrg2(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    var second = document.getElementById("org_sub_id").value;
	var org_id="";
		var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+second+"'";
	   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""){
		}else{
			org_id = datas[0].org_id; 
	    }
		    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
		    if(teamInfo.fkValue!=""){
		    	 document.getElementById("second_org").value = teamInfo.fkValue; 
		        document.getElementById("second_org2").value = teamInfo.value;
			}
   
}

function selectOrg3(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    var third = document.getElementById("second_org").value;
	var org_id="";
		var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+third+"'";
	   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""){
		}else{
			org_id = datas[0].org_id; 
	    }
		    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
		    if(teamInfo.fkValue!=""){
		    	 document.getElementById("third_org").value = teamInfo.fkValue;
		        document.getElementById("third_org2").value = teamInfo.value;
			}
}


function selectTeam1(){
	
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/rm/em/humanLabor/selectProject.lpmd',teamInfo);
    if(teamInfo.fkValue!=""){
        document.getElementById("project_id").value = teamInfo.fkValue;
        document.getElementById("project_name").value = teamInfo.value;
    }
}

function checkText0(){
	var second_org=document.getElementById("second_org").value;
	 
	if(second_org==""){
		alert("二级单位不能为空，请填写！");
		return true;
	}
	 
	var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  

    if (!re.test(second_org))
   {
       alert("初步估计经济损失请输入数字！");
       return true;
    }
	return false;
}

var isProject = "<%=isProject%>";
	if(emergency_no !=null){
 
 		var querySql = "";
		var queryRet = null;
		var  datas =null;			
		if(isProject=="1"){
			querySql = " select     ein.project_no,   ein.valid_until,ein.check_period_until,   ein.information_no, w.recyclemat_info     as emergency_no,  w.recyclemat_info  ,  g.wz_name    as supplies_name,  g.wz_prickie as unit_measurement,  w.stock_num  as quantity,   decode(ein.appearance, '1', '完好', '2', '不完好') appearance,     decode(ein.identification, '1', '符合', '2', '不符合') identification,  decode(ein.performance_s, '1', '有效', '2', '失效') performance_s,   ein.testing_time,   ein.corrective_completiontime,   ein.supplies_category,    ein.model_num,   ein.acquisition_time,   (trunc(nvl(ein.valid_until, sysdate) - sysdate, 0)) v_day,    (trunc(nvl(ein.check_period_until, sysdate) - sysdate, 0)) c_day,   case   when (trunc(nvl(ein.valid_until, sysdate) - sysdate, 0)) >= 30 then      ''    when (trunc(nvl(ein.valid_until, sysdate) - sysdate, 0)) <= 0 then    'red'      when (trunc(nvl(ein.check_period_until, sysdate) - sysdate, 0)) >= 30 then          ''         when (trunc(nvl(ein.check_period_until, sysdate) - sysdate, 0)) <= 0 then          'red'         else          'orange'       end color,       ein.storage_location,       ein.the_depository,       ein.bsflag,       decode(oi1.org_abbreviation,'',oi2.org_abbreviation)org_name,       oi2.org_abbreviation as second_org_name  from gms_mat_infomation g  inner join gms_mat_recyclemat_info w    on g.wz_id = w.wz_id   and w.bsflag = '0'  left join comm_org_subjection os1    on w.org_id = os1.org_subjection_id   and os1.bsflag = '0'  left join comm_org_information oi1    on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  left join BGP_EMERGENCY_INFORMATION ein    on ein.teammat_info_id = w.recyclemat_info  left join comm_org_subjection os2    on w.org_subjection_id = os2.org_subjection_id   and os2.bsflag = '0'  left join comm_org_information oi2    on oi2.org_id = os2.org_id   and oi2.bsflag = '0' where g.coding_code_id like '45%'    and w.recyclemat_info='"+emergency_no+"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){	
					 document.getElementsByName("emergency_no3")[0].value=datas[0].emergency_no; 
				     document.getElementsByName("teammat_info_id")[0].value=datas[0].recyclemat_info; 
		             document.getElementsByName("information_no")[0].value=datas[0].information_no; 		 
		      		 document.getElementsByName("org_sub_id3")[0].value=datas[0].org_name;
		    		 document.getElementsByName("bsflag3")[0].value=datas[0].bsflag; 	
		    		 document.getElementsByName("second_org3")[0].value=datas[0].second_org_name;
		    		 document.getElementsByName("supplies_name3")[0].value=datas[0].supplies_name;
		    		document.getElementsByName("supplies_category3")[0].value=datas[0].supplies_category;		
		    		document.getElementsByName("model_num3")[0].value=datas[0].model_num;			
		    		document.getElementsByName("quantity3")[0].value=datas[0].quantity;			
		    		document.getElementsByName("unit_measurement3")[0].value=datas[0].unit_measurement;
		    		document.getElementsByName("acquisition_time3")[0].value=datas[0].acquisition_time;
		    		document.getElementsByName("valid_until3")[0].value=datas[0].valid_until;			
		    		document.getElementsByName("check_period_until3")[0].value=datas[0].check_period_until;			
		    		document.getElementsByName("storage_location3")[0].value=datas[0].storage_location;
		    		document.getElementsByName("the_depository3")[0].value=datas[0].the_depository;
		    		   document.getElementsByName("project_no")[0].value=datas[0].project_no;	
				}					
			
		    	}	
			
		}else if(isProject=="2"){
		querySql = " select     ein.project_no,   ein.valid_until,ein.check_period_until,   ein.information_no, w.teammat_info_id     as emergency_no,  w.teammat_info_id  ,  g.wz_name    as supplies_name,  g.wz_prickie as unit_measurement,  w.stock_num  as quantity,   decode(ein.appearance, '1', '完好', '2', '不完好') appearance,     decode(ein.identification, '1', '符合', '2', '不符合') identification,  decode(ein.performance_s, '1', '有效', '2', '失效') performance_s,   ein.testing_time,   ein.corrective_completiontime,   ein.supplies_category,    ein.model_num,   ein.acquisition_time,   (trunc(nvl(ein.valid_until, sysdate) - sysdate, 0)) v_day,    (trunc(nvl(ein.check_period_until, sysdate) - sysdate, 0)) c_day,   case   when (trunc(nvl(ein.valid_until, sysdate) - sysdate, 0)) >= 30 then      ''    when (trunc(nvl(ein.valid_until, sysdate) - sysdate, 0)) <= 0 then    'red'      when (trunc(nvl(ein.check_period_until, sysdate) - sysdate, 0)) >= 30 then          ''         when (trunc(nvl(ein.check_period_until, sysdate) - sysdate, 0)) <= 0 then          'red'         else          'orange'       end color,       ein.storage_location,       ein.the_depository,       ein.bsflag,       oi1.org_abbreviation as org_name,       oi2.org_abbreviation as second_org_name  from gms_mat_infomation g  inner join gms_mat_teammat_info w    on g.wz_id = w.wz_id   and w.bsflag = '0'  left join comm_org_subjection os1    on w.org_id = os1.org_subjection_id   and os1.bsflag = '0'  left join comm_org_information oi1    on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  left join BGP_EMERGENCY_INFORMATION ein    on ein.teammat_info_id = w.teammat_info_id  left join comm_org_subjection os2    on w.org_subjection_id = os2.org_subjection_id   and os2.bsflag = '0'  left join comm_org_information oi2    on oi2.org_id = os2.org_id   and oi2.bsflag = '0' where g.coding_code_id like '45%'     and w.teammat_info_id='"+emergency_no+"'";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null){	
				 document.getElementsByName("emergency_no3")[0].value=datas[0].emergency_no; 
			     document.getElementsByName("teammat_info_id")[0].value=datas[0].teammat_info_id; 
	             document.getElementsByName("information_no")[0].value=datas[0].information_no; 		 
	      		 document.getElementsByName("org_sub_id3")[0].value=datas[0].org_name;
	    		 document.getElementsByName("bsflag3")[0].value=datas[0].bsflag; 	
	    		 document.getElementsByName("second_org3")[0].value=datas[0].second_org_name;
	    		 document.getElementsByName("supplies_name3")[0].value=datas[0].supplies_name;
	    		document.getElementsByName("supplies_category3")[0].value=datas[0].supplies_category;		
	    		document.getElementsByName("model_num3")[0].value=datas[0].model_num;			
	    		document.getElementsByName("quantity3")[0].value=datas[0].quantity;			
	    		document.getElementsByName("unit_measurement3")[0].value=datas[0].unit_measurement;
	    		document.getElementsByName("acquisition_time3")[0].value=datas[0].acquisition_time;
	    		document.getElementsByName("valid_until3")[0].value=datas[0].valid_until;			
	    		document.getElementsByName("check_period_until3")[0].value=datas[0].check_period_until;			
	    		document.getElementsByName("storage_location3")[0].value=datas[0].storage_location;
	    		document.getElementsByName("the_depository3")[0].value=datas[0].the_depository;
	    		   document.getElementsByName("project_no")[0].value=datas[0].project_no;	
			}					
		
	    	}	
		}
 	
		
	}

</script>
</html>