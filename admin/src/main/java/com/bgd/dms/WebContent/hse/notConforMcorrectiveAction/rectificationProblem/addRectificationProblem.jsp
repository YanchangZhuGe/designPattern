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
	SimpleDateFormat format =  new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());	
	String orgSubId = request.getParameter("orgSubId");	 
	if (orgSubId == null || orgSubId.equals("")){
		orgSubId = user.getOrgSubjectionId();
	}
	
	String problem_no="";
	if(request.getParameter("problem_no") != null){
		problem_no=request.getParameter("problem_no");	
		
	}
    String projectInfoNo ="";
	if(request.getParameter("projectInfoNo") != null){
		projectInfoNo=request.getParameter("projectInfoNo");	    		
	}

	String isProject = request.getParameter("isProject");
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>问题项整改验证</title>
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
					      	<input type="hidden" id="problem_no" name="problem_no"   />
					    	<input type="hidden" id="project_no" name="project_no" value="" />
					      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
					      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
					      	<%}%>
					      	</td> 
					      	
					        <td class="inquire_item6"><font color="red">*</font>是否整改：</td>					 
						    <td class="inquire_form6"> 
						    <select id="if_corrective" name="if_corrective" class="select_width">
						       <option value="" >请选择</option>
						       <option value="1" >是</option>
						       <option value="2" >否</option> 
							</select></td>						    				    
							</tr>													 
				
						    <tr>					  
							<td class="inquire_item6"><font color="red">*</font>整改完成日期：</td>
						    <td class="inquire_form6"><input type="text" id="rectification_date" name="rectification_date" class="input_width"   readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(rectification_date,tributton1);" />&nbsp;</td>
						   <td class="inquire_item6"><font color="red">*</font>整改负责人：</td>
						    <td class="inquire_form6"><input type="text" id="rectification_in" name="rectification_in"    class="input_width"/></td>
						    </tr>				 		
						    <tr>					  
							<td class="inquire_item6"><font color="red">*</font>体系要素号：</td>
						    <td class="inquire_form6"><input type="text" id="psystem_elements" name="psystem_elements" class="input_width"   readonly="readonly"/>
						    <input type="hidden" id="qdetail_no" name="qdetail_no" class="input_width"   />
						    <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectContent()"/>
						    </td>
						   <td class="inquire_item6">问题类别：</td>
						    <td class="inquire_form6"><input type="text" id="pproblem_category" name="pproblem_category"    class="input_width" readonly="readonly" /></td>
						    </tr>	
						    <tr>					  
							<td class="inquire_item6">问题性质：</td>
						    <td class="inquire_form6"><input type="text" id="pnature" name="pnature" class="input_width"   readonly="readonly"/>
						    </td>

						    </tr>			  
					</table>
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>问题项：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:500px;" id="a_problem" name="a_problem"   class="textarea" ></textarea>
					     </td>
					    <td class="inquire_item6"> </td> 				 
					  </tr>	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>整改结果综述：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:500px;" id="rectification_results" name="rectification_results"   class="textarea" ></textarea></td>
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
 var problem_no='<%=problem_no%>';
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
 		if(problem_no!=null && problem_no!=""){
 		 	
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

	function checkJudge(){
 		var org_sub_id = document.getElementsByName("org_sub_id2")[0].value;
		var second_org = document.getElementsByName("second_org2")[0].value;			
		var third_org = document.getElementsByName("third_org2")[0].value;			

		var a_problem = document.getElementsByName("a_problem")[0].value;
		var if_corrective = document.getElementsByName("if_corrective")[0].value;		
		var rectification_date = document.getElementsByName("rectification_date")[0].value;			
		var rectification_in = document.getElementsByName("rectification_in")[0].value;			
		var rectification_results = document.getElementsByName("rectification_results")[0].value;
		var psystem_elements = document.getElementsByName("psystem_elements")[0].value;
		
 		if(org_sub_id==""){
 			document.getElementById("org_sub_id").value = "";
 		}
 		if(second_org==""){
 			document.getElementById("second_org").value="";
 		}
 		if(third_org==""){
 			document.getElementById("third_org").value="";
 		}
 		if(a_problem==""){
 			alert("问题项不能为空，请填写！");
 			return true;
 		}
 		if(if_corrective==""){
 			alert("是否整改不能为空，请选择！");
 			return true;
 		}
 		if(rectification_date==""){
 			alert("整改完成日期不能为空，请填写！");
 			return true;
 		}
 
		if(rectification_in==""){
 			alert("整改负责人不能为空，请填写！");
 			return true;
 		}
		if(rectification_results==""){
 			alert("整改结果综述不能为空，请填写！");
 			return true;
 		}
	 
		if(psystem_elements==""){
 			alert("体系要素号不能为空，请填写！");
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
		var problem_no = document.getElementsByName("problem_no")[0].value;
		var create_date = document.getElementsByName("create_date")[0].value;
		var creator = document.getElementsByName("creator")[0].value;		
		var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
		var bsflag = document.getElementsByName("bsflag")[0].value;
		var second_org = document.getElementsByName("second_org")[0].value;			
		var third_org = document.getElementsByName("third_org")[0].value;		
		var a_problem = document.getElementsByName("a_problem")[0].value;
		var if_corrective = document.getElementsByName("if_corrective")[0].value;		
		var rectification_date = document.getElementsByName("rectification_date")[0].value;			
		var rectification_in = document.getElementsByName("rectification_in")[0].value;			
		var rectification_results = document.getElementsByName("rectification_results")[0].value;
		var project_no = document.getElementsByName("project_no")[0].value;	
		
		var qdetail_no = document.getElementsByName("qdetail_no")[0].value;
		var psystem_elements = document.getElementsByName("psystem_elements")[0].value;
		var pproblem_category = document.getElementsByName("pproblem_category")[0].value;
		var pnature = document.getElementsByName("pnature")[0].value;
		
		isProject = "<%=isProject%>";
		
		rowParam['org_sub_id'] = org_sub_id;
		rowParam['second_org'] = second_org;
		rowParam['third_org'] = third_org;			 
		
		rowParam['a_problem'] = encodeURI(encodeURI(a_problem));
		rowParam['if_corrective'] = encodeURI(encodeURI(if_corrective));
		rowParam['rectification_date'] = encodeURI(encodeURI(rectification_date));
		rowParam['rectification_in'] = encodeURI(encodeURI(rectification_in));		 
		rowParam['rectification_results'] = encodeURI(encodeURI(rectification_results));
		rowParam['qdetail_no'] = encodeURI(encodeURI(qdetail_no));	
		rowParam['psystem_elements'] = encodeURI(encodeURI(psystem_elements));	
		rowParam['pproblem_category'] = encodeURI(encodeURI(pproblem_category));	
		rowParam['pnature'] = encodeURI(encodeURI(pnature));	
	 
	  if(problem_no !=null && problem_no !=''){
		  
		    rowParam['problem_no'] = problem_no;
			rowParam['creator'] = encodeURI(encodeURI(creator));
			rowParam['create_date'] =create_date;
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;
			
	  }else{
		  if(isProject=="2"){
			rowParam['project_no'] ='<%=projectInfoNo%>';
		  }
		    rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['create_date'] ='<%=curDate%>';
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;
	  }  				
  
		rowParams[rowParams.length] = rowParam; 
		var rows=JSON.stringify(rowParams);	 
		saveFunc("BGP_RECTIFICATION_PROBLEM",rows);	
	//	top.frames('list').getTab3('0');	
		top.frames('list').refreshData();	
		newClose();
 
}
 
function  selectContent(){ 
	  window.open('<%=contextPath%>/hse/notConforMcorrectiveAction/rectificationProblem/orderList.jsp?isProject=<%=isProject%>','pagename','height=400,width=650px,left=350px,top=160px,menubar=no,status=no,toolbar=no');
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
 
	

 
function  selectContent1(){
	  window.open("<%=contextPath%>/hse/notConforMcorrectiveAction/rectificationProblem/MainPage.jsp",'homeMain','height=500,width=1000px,left=100px,top=100px,menubar=no,status=no,toolbar=no ', '');
		
	  window.open("<%=contextPath%>/hse/notConforMcorrectiveAction/rectificationProblem/homeFrame.jsp",'homeMain','height=500,width=1000px,left=100px,top=100px,menubar=no,status=no,toolbar=no ', '');
	
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
 
	if(problem_no !=null){
		var querySql = "";
		var queryRet = null;
		var  datas =null;		
		
		querySql = "  select    tr.project_no,tr.qdetail_no,tr.psystem_elements,tr.pproblem_category,tr.pnature,tr.problem_no,tr.a_problem,tr.if_corrective,tr.rectification_date,tr.rectification_in,tr.rectification_results,tr.verify_date,tr.verifier,tr.if_qualified,tr.risk_situation,tr.validation_reviews,tr.second_org,tr.third_org,ion.org_abbreviation org_name,tr.org_sub_id, tr.creator,tr.create_date,tr.bsflag,oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_RECTIFICATION_PROBLEM tr    left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'  left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left  join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'  left join comm_org_subjection ose on tr.org_sub_id = ose.org_subjection_id and ose.bsflag = '0' left join comm_org_information ion on ion.org_id = ose.org_id  and ion.bsflag='0'     where tr.bsflag = '0' and tr.problem_no='"+problem_no+"'";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null){			   
	             document.getElementsByName("problem_no")[0].value=datas[0].problem_no; 
	    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
	    		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name;
	    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
	    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
	    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
	    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
	    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
	  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
	    		 document.getElementsByName("creator")[0].value=datas[0].creator;	   
	    		   document.getElementsByName("project_no")[0].value=datas[0].project_no;		
	    		 document.getElementsByName("a_problem")[0].value=datas[0].a_problem;
	    		 document.getElementsByName("if_corrective")[0].value=datas[0].if_corrective;		
	    		 document.getElementsByName("rectification_date")[0].value=datas[0].rectification_date;			
	    		 document.getElementsByName("rectification_in")[0].value=datas[0].rectification_in;			
	    	     document.getElementsByName("rectification_results")[0].value=datas[0].rectification_results;
	    	     document.getElementsByName("qdetail_no")[0].value=datas[0].qdetail_no;
	    	     document.getElementsByName("psystem_elements")[0].value=datas[0].psystem_elements;
	    	     document.getElementsByName("pproblem_category")[0].value=datas[0].pproblem_category;
	    	     document.getElementsByName("pnature")[0].value=datas[0].pnature;
	    
			}					
		
	    	}		
		
	}

</script>
</html>