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
	SimpleDateFormat format =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());	
	String orgSubId = request.getParameter("orgSubId");	 
	if (orgSubId == null || orgSubId.equals("")){
		orgSubId = user.getOrgSubjectionId();
	}
	
	String questions_no="";
	if(request.getParameter("questions_no") != null){
		questions_no=request.getParameter("questions_no");	
		
	}
 
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request); 

%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>问题清单</title>
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
				    	  <input type="hidden" id="org_sub_id" name="org_sub_id" class="input_width" />
					      	<input type="text" id="org_sub_id2" name="org_sub_id2" class="input_width"   <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
				        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
				        	<%} %>
				        	</td>					  
						  <td class="inquire_item6">基层单位：</td>
				    	  <td class="inquire_form6">
				    	  <input type="hidden" id="second_org" name="second_org" class="input_width" />
				    	  <input type="text" id="second_org2" name="second_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
				        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
				        	<%} %>
				        	</td>		    	  
					  </tr>					  
						<tr>								 
						  <td class="inquire_item6">下属单位：</td>
					      	<td class="inquire_form6">
				 	      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
					      	<input type="hidden" id="create_date" name="create_date" value="" />
					      	<input type="hidden" id="creator" name="creator" value="" />
					    	<input type="hidden" id="project_no" name="project_no" value="" />
					      	<input type="hidden" id="questions_no" name="questions_no"   />
					      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
					      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
					      	<%}%>
					      	</td> 
					   	      	
					    <td class="inquire_item6"><font color="red">*</font>检查人：</td>
					    <td class="inquire_form6">
					    <input type="text" id="check_people" name="check_people" class="input_width"   />    					    
					    </td>					    
						</tr>						
					  <tr>	
					    <td class="inquire_item6"><font color="red">*</font>检查日期：</td>
					    <td class="inquire_form6"><input type="text" id="check_date" name="check_date" class="input_width"   readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_date,tributton1);" />&nbsp;</td>
			 		    <td class="inquire_item6"><font color="red">*</font>被检查部门负责人：</td>
					    <td class="inquire_form6"> 
					    <input type="text" id="check_person" name="check_person" class="input_width"   />    		
					    </td>
					  </tr>					  
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>整改期限：</td> 					   
					    <td class="inquire_form6"  align="center" > 
					    <input type="text" id="rectification_period" name="rectification_period" class="input_width"    readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(rectification_period,tributton2);" />&nbsp;</td>
					  </tr>	
					</table>
					<fieldset>
					<legend>
					问题描述项：
					</legend>
					<div id="tab_box_contentT" class="tab_box_content"  >  
		              <table border="0"  width="100%"  cellspacing="0" cellpadding="0" class="tab_info"    id="equipmentTableInfo">
			          	<tr > 		 
			                <TD  class="bt_info_odd"  width="5%">选择</TD>
			                <TD  class="bt_info_even"  width="5%">序号</TD>
				            <td  class="bt_info_odd"><font color=red>问题描述</font></td>
				            <td class="bt_info_even"><font color=red>体系要素号</font></td>		
				            <td  class="bt_info_odd">问题类别</td>			            
				            <td class="bt_info_even">问题性质</td>	
			          		<input type="hidden" id="equipmentSize1" name="equipmentSize1"   value="0" />
			          		<input type="hidden" id="hidDetailId1" name="hidDetailId1" value=""/>
			          		<input type="hidden" id="deleteRowFlag1" name="deleteRowFlag1" value="" />	          
			          		<input type="hidden" id="lineNum1" value="0"/>
			          	</tr> 
					          
			          </table>	 
			      
				</div>			
			    </fieldset>
				
			    <fieldset>
				<legend>
				整改要求：
				</legend>
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" > 
					  <tr>
									   
					    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:100%;" id="rectification_requirements" name="rectification_requirements"   class="textarea" ></textarea></td>
					
			 
					  </tr>	
					 
					</table>
				  </fieldset> 
					 
				</div>
			<div id="oper_div">
				<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
 var questions_no='<%=questions_no%>';
//键盘上只有删除键，和左右键好用
 function noEdit(event){
 	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
 		return true;
 	}else{
 		return false;
 	}
 }

 	function queryOrg(){
 		if(questions_no!=null && questions_no!=""){
 		 	
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
 
	if(questions_no !=null){
		var querySql = "";
		var queryRet = null;
		var  datas =null;		
		
		querySql = "  select  tr.project_no,tr.questions_no	,tr.org_sub_id,tr.check_people,tr.check_date,tr.check_person,tr.problem,tr.rectification_requirements,tr.rectification_period ,tr.second_org,tr.third_org,ion.org_abbreviation as  org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_LIST_QUESTIONS tr    left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'  left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left  join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection ose on tr.org_sub_id = ose.org_subjection_id and ose.bsflag = '0' left join comm_org_information ion on ion.org_id = ose.org_id  and ion.bsflag='0'     where tr.bsflag = '0' and tr.questions_no='"+questions_no+"'";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null){				 
		   
	             document.getElementsByName("questions_no")[0].value=datas[0].questions_no; 
	    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
	    		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name;
	    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
	    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
	    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
	    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
	    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
	  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
	    		 document.getElementsByName("creator")[0].value=datas[0].creator;		  
	    		document.getElementsByName("check_people")[0].value=datas[0].check_people;	
	    		document.getElementsByName("check_date")[0].value=datas[0].check_date;		
	    		document.getElementsByName("check_person")[0].value=datas[0].check_person;				
	
	    		document.getElementsByName("rectification_requirements")[0].value=datas[0].rectification_requirements;		
	            document.getElementsByName("rectification_period")[0].value=datas[0].rectification_period;					
	    		   document.getElementsByName("project_no")[0].value=datas[0].project_no;
	    
			}					
		
	    	}		
		
		 document.getElementById("lineNum1").value="0"; 
		   querySql1 = "select tr.qdetail_no,tr.questions_no,tr.problem_des,tr.problem_category,tr.system_elements,tr.nature,tr.creator,tr.create_date,tr.updator,tr.modifi_date,tr.bsflag,dl.coding_name   from BGP_LIST_QUESTIONS_DETAIL tr  left join comm_coding_sort_detail dl on tr.system_elements=dl.coding_code_id   where  tr.bsflag='0' and tr.questions_no='" + questions_no + "'  order by  tr.modifi_date";
		   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
			if(queryRet1.returnCode=='0'){
			  datas1 = queryRet1.datas;	 
				if(datas1 != null && datas1 != ''){	  
					for(var i = 0; i<datas1.length; i++){	 
			       var rowNum = document.getElementById("lineNum1").value;								
					var tr = document.getElementById("equipmentTableInfo").insertRow();							
					tr.align="center";							 
				  	if(rowNum % 2 == 1){  
				  		tr.className = "odd";
					}else{ 
						tr.className = "even";
					}	
				 
					tr.id = "row_" + rowNum + "_";  
					tr.insertCell().innerHTML = '<input type="radio"    id="chx_entity_id' + '_' + rowNum + '"  onclick="sucess('+rowNum+')"  name="chx_entity_id' + '_' + rowNum + '" value="'+datas1[i].qdetail_no+','+datas1[i].problem_des+','+datas1[i].coding_name+','+datas1[i].problem_category+','+datas1[i].nature+'" />';
					tr.insertCell().innerHTML = parseInt(rowNum) + 1;												
					tr.insertCell().innerHTML = '<input type="hidden"  name="qdetail_no' + '_' + rowNum + '" value="'+datas1[i].qdetail_no+'"/>'+'<textarea name="problem_des' + '_' + rowNum + '"  id="problem_des' + '_' + rowNum + '"    style="height:34px; width:320px;" class="textarea" >'+datas1[i].problem_des+'</textarea> ';
					tr.insertCell().innerHTML = '<input type="text" style="width:120px;" class="input_width" name="system_elements' + '_' + rowNum + '" value="'+datas1[i].coding_name+'" />';
					tr.insertCell().innerHTML = '<input type="text" style="width:150px;" class="input_width" name="problem_category' + '_' + rowNum + '" value="'+datas1[i].problem_category+'" />'; 
					tr.insertCell().innerHTML = '<input type="text" style="width:150px;" class="input_width" name="nature' + '_' + rowNum + '" value="'+datas1[i].nature+'" />';
  
					var td = tr.insertCell(); 
					td.style.display = "";						 
					
					document.getElementById("lineNum1").value = parseInt(rowNum) + 1;	
		       				      
			       
			       
					}
					
				}
		    }	
		
	}

	function sucess(i) {

		ids = getSelIds('chx_entity_id_'+i);
	 
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    }  
	    
	   window.opener.document.getElementById("qdetail_no").value=ids.split(',')[0];
	   window.opener.document.getElementById("a_problem").value=ids.split(',')[1];
	   window.opener.document.getElementById("psystem_elements").value=ids.split(',')[2];
	   window.opener.document.getElementById("pproblem_category").value=ids.split(',')[3];
	   window.opener.document.getElementById("pnature").value=ids.split(',')[4]; 
	    
	   
	　   window.opener.changeTest();
	   window.close();
	}
	
</script>
</html>