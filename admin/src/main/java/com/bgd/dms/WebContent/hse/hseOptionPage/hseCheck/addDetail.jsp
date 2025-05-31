<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@ taglib uri="code" prefix="code"%> 
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
 
<%
	String contextPath = request.getContextPath();

	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getUserName();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());	
	String orgSubId = request.getParameter("orgSubId");	 
	if (orgSubId == null || orgSubId.equals("")){
		orgSubId = user.getOrgSubjectionId();
	}
	
	String check_no="";
	if(request.getParameter("check_no") != null){
		check_no=request.getParameter("check_no");	
		
	}
	String check_detail_no="";
	if(request.getParameter("check_detail_no") != null){
		check_detail_no=request.getParameter("check_detail_no");	
		
	}
	
 %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>HSE问题整改</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
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
<body onload="listInfo();">
<form name="form" id="form"  method="post" action="" >
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
    
			    <table width="100%" border="0" cellspacing="0" cellpadding="0" id="equipmentTableInfo" class="tab_line_height" >					  
			    <tr>						      	  
			  	  <td class="inquire_item6">存在单位：</td>
				      	<td class="inquire_form6" colspan="3" id="id1">
				       		 <input type="text" id="exist_units" name="exist_units"   /> 
				      	</td>   
				  </tr>		
				  <tr>						      	  
				 
			      <td class="inquire_item6">存在基层单位：</td>
			    	<td class="inquire_form6" colspan="3" id="id2">				     
						<input type="text" id="roots_units" name="roots_units"   /> 
			    	</td>
			     </tr>	 </table>	
				    <table width="100%" border="0" cellspacing="0" cellpadding="0"  class="tab_line_height" >					  
				      
					 
					  <tr>		 				   
					    <td class="inquire_item6">存在部门/部位：</td>					 
					    <td class="inquire_form6"> 
					    <input type="hidden" id="bsflag" name="bsflag" value="0" />
				      	<input type="hidden" id="create_date" name="create_date" value="" />
				      	<input type="hidden" id="creator" name="creator" value="" />
				      	<input type="hidden" id="check_no" name="check_no"   />
				    	<input type="hidden" id="check_detail_no" name="check_detail_no"   /> 
					    <input type="text" id="exist_parts" name="exist_parts" class="input_width"   />     </td>	 	  
					    <td class="inquire_item6">整改完成时间：</td>
					    <td class="inquire_form6"><input type="text" id="completion_time" name="completion_time" class="input_width"   readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(completion_time,tributton1);" />&nbsp;</td>
			    	  </tr>		   
				 	</table>
				 	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  id="hseTableInfo2">			
					 <tr> 
					    <td class="inquire_item6">存在要素：</td>			 
					    <td class="inquire_form6" colspan="2">
					    <select id="spare2" name="spare2" class="select_width"> 
					       <option value="" >请选择</option>
					       <option value="5.1领导和承诺" >5.1领导和承诺</option>
					       <option value="5.2HSE方针" >5.2HSE方针</option>	
					       <option value="5.3.1危害因素辨识、风险评价和风险控制的策划" >5.3.1危害因素辨识、风险评价和风险控制的策划</option>
					       <option value="5.3.2法律、法规和其他要求" >5.3.2法律、法规和其他要求</option>
					       <option value="5.3.3目标和指标" >5.3.3目标和指标</option>
					       <option value="5.3.4管理方案" >5.3.4管理方案</option>
					       <option value="5.4.1组织结构和职责" >5.4.1组织结构和职责</option>
					       <option value="5.4.2管理者代表" >5.4.2管理者代表</option>
					       <option value="5.4.3资源" >5.4.3资源</option>
					       <option value="5.4.4能力、培训和意识" >5.4.4能力、培训和意识</option>
					       <option value="5.4.5协商和沟通" >5.4.5协商和沟通</option>
					       <option value="5.4.6文件" >5.4.6文件</option>
					       <option value="5.4.7文件控制" >5.4.7文件控制</option>
					       <option value="5.5.1设备设施完整有效性" >5.5.1设备设施完整有效性</option>
					       <option value="5.5.2承包商和（或）供应商" >5.5.2承包商和（或）供应商</option>
					       <option value="5.5.3顾客和产品" >5.5.3顾客和产品</option>
					       <option value="5.5.5社区和公共关系" >5.5.5社区和公共关系</option>
					       <option value="5.5.5作业许可" >5.5.5作业许可</option>
					       <option value="5.5.6运行控制" >5.5.6运行控制</option>
					       <option value="5.5.7变更管理" >5.5.7变更管理</option>
					       <option value="5.5.8应急准备和响应" >5.5.8应急准备和响应</option>
					       <option value="5.6.1绩效测量和监视" >5.6.1绩效测量和监视</option>
					       <option value="5.6.2合规性评价" >5.6.2合规性评价</option>
					       <option value="5.6.3不符合、纠正措施和预防措施" >5.6.3不符合、纠正措施和预防措施</option>
					       <option value="5.6.4事故、事件报告、调查和处理" >5.6.4事故、事件报告、调查和处理</option>
					       <option value="5.6.5记录控制" >5.6.5记录控制</option>
					       <option value="5.6.6内部审核" >5.6.6内部审核</option>
					       <option value="5.7管理评审" >5.7管理评审</option> 
						</select>
					    
					    </td>
					  </tr>	
				 	<tr> 
					    <td class="inquire_item6">问题描述：</td>			 
					    <td class="inquire_form6" colspan="2"><textarea id="notes" name="notes"  style="width:530px;height:60px;"   class="textarea" ></textarea></td>
					  </tr>	
					 <tr> 
					    <td class="inquire_item6">原因分析：</td>			 
					    <td class="inquire_form6" colspan="2"><textarea id="gause_analysis" name="gause_analysis"  style="width:530px;height:60px;"   class="textarea" ></textarea></td>
					  </tr>	
						 <tr> 
						    <td class="inquire_item6">整改要求：</td>			 
						    <td class="inquire_form6" colspan="2"><textarea id="requirements" name="requirements"  style="width:530px;height:60px;"  class="textarea" ></textarea></td>
						  </tr>	
							 <tr> 
							    <td class="inquire_item6">整改完成情况：</td>			 
							    <td class="inquire_form6" colspan="2"><textarea id="completion" name="completion"   style="width:530px;height:60px;" class="textarea" ></textarea></td>
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
 
 var check_no='<%=check_no%>';
 var check_detail_no='<%=check_detail_no%>';

 
function submitButton(){
 
	var rowParams = new Array(); 
		var rowParam = {};			
		 
		var check_detail_no = document.getElementsByName("check_detail_no")[0].value;
		var create_date = document.getElementsByName("create_date")[0].value;
		var creator = document.getElementsByName("creator")[0].value;			 
		var bsflag = document.getElementsByName("bsflag")[0].value;
		var exist_unit=document.getElementsByName("exist_units")[0].value;
		var roots_unit=document.getElementsByName("roots_units")[0].value;		
		var exist_parts = document.getElementsByName("exist_parts")[0].value;			
		var gause_analysis = document.getElementsByName("gause_analysis")[0].value;			
		var requirements = document.getElementsByName("requirements")[0].value;
		var completion = document.getElementsByName("completion")[0].value;
		var completion_time = document.getElementsByName("completion_time")[0].value;	
		var notes = document.getElementsByName("notes")[0].value;
		var spare2 = document.getElementsByName("spare2")[0].value;
		
		
		rowParam['check_no'] =check_no;  
		 rowParam['exist_unit'] = encodeURI(encodeURI(exist_unit));
		 rowParam['roots_unit'] = encodeURI(encodeURI(roots_unit));
		rowParam['exist_parts'] = encodeURI(encodeURI(exist_parts));
		rowParam['gause_analysis'] = encodeURI(encodeURI(gause_analysis));		 
		rowParam['requirements'] = encodeURI(encodeURI(requirements));
		rowParam['completion'] = encodeURI(encodeURI(completion));
		rowParam['completion_time'] = encodeURI(encodeURI(completion_time));
		rowParam['notes'] = encodeURI(encodeURI(notes));
		rowParam['spare2'] = encodeURI(encodeURI(spare2));
		
	  if(check_detail_no !=null && check_detail_no !=''){
		    rowParam['check_detail_no'] = check_detail_no;
			rowParam['creator'] = encodeURI(encodeURI(creator));
			rowParam['create_date'] =create_date;
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;
			
	  }else{
		    rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['create_date'] ='<%=curDate%>';
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;
		  
	  }  				
  
		rowParams[rowParams.length] = rowParam; 
		var rows=JSON.stringify(rowParams);	 
		saveFunc("BGP_HSE_CHECK_DETAIL",rows);	
		top.frames('list').loadDataDetail(check_no);	
		newClose();
	
}
 
function selectOrg(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    var second_orgId = document.getElementById("second_org").value;
    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
    	 document.getElementById("second_org").value = teamInfo.fkValue;
        document.getElementById("second_org2").value = teamInfo.value;
        if(second_orgId!=teamInfo.fkValue){
        	document.getElementById("third_org").value = "";
	        document.getElementById("third_org2").value = "";
        }
    }
}

function selectOrg2(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    var second = document.getElementById("second_org").value;
    if(second==""||second==null){
    	alert("请先选择二级单位！");
    }else{
	    var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+second+"'";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""){
		}else{
			var org_id = datas[0].org_id; 
		    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
		    if(teamInfo.fkValue!=""){
		    	 document.getElementById("third_org").value = teamInfo.fkValue;
		        document.getElementById("third_org2").value = teamInfo.value;
		    }
		}
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
 
	
	 
	 
	 function listInfo(){ 
/*		querySql1 = "  select    tr.check_unit_org, tr.check_roots_org       from BGP_HSE_CHECK tr   where tr.bsflag = '0'   and tr.check_no = '"+ check_no +"' ";
		 queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
	
		 if(queryRet1.returnCode=='0'){
			  datas1 = queryRet1.datas;	
	
					if(datas1 != null && datas1 != ''){							 
						    var listValues=datas1[0].check_unit_org;
						    var listValuesA=datas1[0].check_roots_org;
						    var tr = document.getElementById("equipmentTableInfo").insertRow();	
						    var td1=document.getElementById("id1");
						    var td2=document.getElementById("id2");
						    var check_unit_orgs = listValues.split(','); 
						    var check_roots_orgs= listValuesA.split(','); 
				 
						    var  stringList='';
						    var  stringLists='';
						    for(var i=0;i<check_unit_orgs.length;i++)
					        {
						    	var check_unit_org = listValues.split(',')[i]; 					    	 
						    	stringList += '<input type="checkbox"    id="exist_unit'+ i + '"   name="exist_unit" value="'+check_unit_org+'" />'+check_unit_org;
						    						  
					        }					    	
					       	 
						    td1.innerHTML=stringList;
						    td1.style.display = "";						 								
					      	   		  
						    for(var j=0;j<check_roots_orgs.length;j++)
					        {
						    	var check_roots_org = listValuesA.split(',')[j]; 	
						     
						    	stringLists += '<input type="checkbox"    id="roots_unit'+ j + '"   name="roots_unit" value="'+check_roots_org+'" />'+check_roots_org;
						    						  
					        }	   
						    td2.innerHTML=stringLists;
						    td2.style.display = "";	
					
					}
		    	
			}
*/	 
		 if(check_detail_no !=null){
				var querySql = "";
				var queryRet = null;
				var  datas =null;		
				
				querySql = " select cn.check_detail_no,cn.check_no,  cn.creator, cn.spare2,cn.notes,  cn.create_date,    cn.bsflag,      cn.modifi_date, cn.updator,cn.exist_unit,cn.roots_unit,cn.exist_parts,cn.gause_analysis,cn.requirements,cn.completion,cn.completion_time from BGP_HSE_CHECK_DETAIL cn  left join BGP_HSE_CHECK tr on cn.check_no=tr.check_no and tr.bsflag='0'  where cn.bsflag='0' and  cn.check_detail_no='"+check_detail_no+"'  and cn.check_no='"+check_no+"' ";				 	 
				queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
				if(queryRet.returnCode=='0'){
					datas = queryRet.datas;
					if(datas != null){				 		   
			             document.getElementsByName("check_no")[0].value=datas[0].check_no; 
			    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;	    
			    	     document.getElementsByName("check_detail_no")[0].value=datas[0].check_detail_no;	
			  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
			    		 document.getElementsByName("creator")[0].value=datas[0].creator;	  
			    		 document.getElementsByName("exist_units")[0].value=datas[0].exist_unit;
			    		 
/*			    		 var listValues=datas[0].exist_unit; 
			    		 var check_unit_orgs = listValues.split(';'); 
			    		 var certificate = document.getElementsByName("exist_unit");			 		
						    for(var i=0;i<check_unit_orgs.length;i++)					        {
						    	var check_unit_org = listValues.split(';')[i]; 	
				  		    	for(var j=0;j<certificate.length;j++){
				  				if(certificate[j].value==check_unit_org){				  					
				  					certificate[j].checked=true;
				  				}
			  				 
				  		    	}
			  		       	}
				  		     						    
						    var listValuesA=datas[0].roots_unit; 
				    		 var check_unit_orgsA = listValuesA.split(';'); 
				    		 var certificateA = document.getElementsByName("roots_unit");			 		
							    for(var i=0;i<check_unit_orgsA.length;i++)					
							    { 
							    	var check_unit_orgA = listValuesA.split(';')[i]; 	  
					  		    	for(var j=0;j<certificateA.length;j++){
					  				if(certificateA[j].value==check_unit_orgA){				  					
					  					certificateA[j].checked=true;
					  				}
				  				 
					  		    	}
				  		       	}
*/							    							    
			    		 
			    		  document.getElementsByName("roots_units")[0].value=datas[0].roots_unit;
			    		  document.getElementsByName("exist_parts")[0].value=datas[0].exist_parts;			
			    		  document.getElementsByName("gause_analysis")[0].value=datas[0].gause_analysis;			
			    		  document.getElementsByName("requirements")[0].value=datas[0].requirements;
			    		  document.getElementsByName("completion")[0].value=datas[0].completion;
			    		  document.getElementsByName("completion_time")[0].value=datas[0].completion_time;	
			    		  document.getElementsByName("notes")[0].value=datas[0].notes;	
			    		  document.getElementsByName("spare2")[0].value=datas[0].spare2;
			    
					}					
				
			    	}		
				
			}

		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
	 }
	 function addSelect(){ 
		   var certificate = document.getElementsByName("exist_unit");
		   var roots_units = document.getElementsByName("roots_unit");
			var certificate_no = "";
			var roots_units_no = "";
 
			for(var i=0;i<certificate.length;i++){
				if(certificate[i].checked==true){
					certificate_no = certificate_no + certificate[i].value + ";";	
				}
			}
			for(var j=0;j<roots_units.length;j++){
				if(roots_units[j].checked==true){
					roots_units_no = roots_units_no + roots_units[j].value + ";";	
				}
			}
 
			document.getElementsByName("exist_units")[0].value=certificate_no;
			document.getElementsByName("roots_units")[0].value=roots_units_no;
 	       
		}
	  
</script>
</html>